# Project Research — PITFALLS

**Project:** dydx-delivery v2.0 "Implementor Edition"
**Research dimension:** Pitfalls (warning signs + prevention + owning phase)
**Researcher:** gsd-project-researcher (parallel run)
**Date:** 2026-05-09
**Overall confidence:** MEDIUM — Coda API claims HIGH (Context7-verified); platform-API claims drawn from in-repo `safety-rules.md` + `INTEGRATIONS.md` and explicitly flagged where un-verified; behavioural pitfalls drawn from in-repo `CONCERNS.md` are HIGH

> **Capture note.** The researcher agent returned findings inline because its tool surface blocked Write to this directory (same agent-frontmatter conflict that affected the FEATURES researcher). The orchestrator captured the findings here verbatim so the synthesizer can read them as if the researcher wrote the file directly.

---

## How to read this file

Each pitfall carries **Warning sign**, **Prevention** (concrete v2 design move, not "be careful"), **Owning phase** (P1 Architecture / P2 Plugin Surface / P3 Stage Skills / P4 Test Harness / P5 Integrations / P6 Migration — phase numbers indicative pending roadmap lock), and **Source** with confidence.

---

## Critical Pitfalls

### CRIT-1 — Coda formula column overwrite via plain row write

**What goes wrong:** Stage 5 cost-generation writes per-assignee task rows. Any column flagged `calculated: true` (has a `formula:`) cannot be set via row write — the call returns `202 Accepted` regardless, but the formula re-evaluates on next recalc and silently restores the computed value. If the formula references other agent-written fields, race-y partial writes propagate.

**Warning sign:** Cost rows mysteriously revert in Coda UI between writes. Audit log shows `202 Accepted` followed by user reporting "the numbers I saw a second ago are gone."

**Prevention:**
1. Before any write, the Coda skill MUST `GET /docs/{docId}/tables/{tableId}/columns/{columnId}` and refuse to write to columns with `calculated: true`.
2. Cache the column-schema map per table per session; revalidate on schema-version mismatch.
3. The costing-table contract splits "input columns" (agent-writable) from "output columns" (formula, agent-readable only). Document the contract inside the plugin.

**Owning phase:** P5 Integrations (Coda schema contract); P1 Architecture (write-path safety contract).

**Source:** Context7 `/websites/coda_io_apis_v1` — column schema includes `calculated: boolean` and `formula: string`; row-writes return 202 even on no-op. **HIGH.**

---

### CRIT-2 — Coda async-202 treated as synchronous success

**What goes wrong:** `POST /docs/{docId}/tables/{tableId}/rows` returns `202 Accepted` with a `requestId`. v2 build assumes 202 = success and proceeds to next stage / publish to Drive / mark ship complete. Coda may take seconds to process; if the upsert fails (validation, schema drift), the agent has already moved on.

**Warning sign:** Stage 5 cost table partially populated with no errors logged. Hub/brain say "shipped" but Coda mirror missing rows.

**Prevention:**
1. Every Coda mutation polls `GET /mutationStatus/{requestId}` until `completed: true`, surfacing `warning` strings verbatim.
2. Bake `coda.mutate_and_wait()` helper into platform-coda skill with mandatory poll, explicit timeout (Coda doc: "intended to be used shortly after the request was made" — status disappears after ~1 day).
3. Stage transitions that depend on Coda mirror state gate on completion, not on POST acceptance.

**Owning phase:** P5 Integrations (Coda client contract); P3 Stage Skills (Stage 5 cost + Stage 10 mirror).

**Source:** Context7 `/websites/coda_io_apis_v1` — `GET /mutationStatus/{requestId}`; "Status information is not guaranteed to be available for more than one day". **HIGH.**

---

### CRIT-3 — Coda write rate-limit collapse on per-assignee task generation

**What goes wrong:** Stage 5 generates per-assignee tasks at scale (e.g. 30 tasks across 5 assignees). Naïve loop = ~30 row writes. Coda's *write rate limit on doc content is 5 requests per 10 seconds* — much tighter than plugin authors intuit. The 6th write returns `429`. v0.3.0 has no Coda-specific backoff; the bot retries immediately, gets throttled harder.

**Warning sign:** Cost generation hangs ~30s into the run. Audit shows `429` cluster. Eventually completes or aborts mid-table — leaving the costing table half-populated while the user thinks costing succeeded.

**Prevention:**
1. Platform-coda skill batches row writes via `POST /docs/{docId}/tables/{tableId}/rows/upsert` with `rows: [...]` array — one HTTP call carries up to N rows.
2. Even with batching, rate-limit doc-content writes at **4 req per 10s** (buffer at 80% of the 5/10s ceiling, mirroring v0.3.0 platform-skill convention from `safety-rules.md` rule 6).
3. On 429, respect `Retry-After`; abort cleanly after second 429 with partial-state report (mirrors `execute-tests` rule 7).
4. Cost generation must be re-runnable: idempotency key per task row (use task ID as upsert `keyColumns`) so partial run resumes without duplicates.

**Owning phase:** P5 Integrations (Coda rate-limit policy); P3 (Stage 5 design).

**Source:** Context7 `/websites/coda_io_apis_v1` — "Writing data (POST/PUT/PATCH): 10 requests per 6 seconds; Writing doc content data (POST/PUT/PATCH): 5 requests per 10 seconds; per-user across all endpoints sharing the same limit and across all docs." **HIGH.**

---

### CRIT-4 — Two-way Coda sync re-emerges through Field Notes triage

**What goes wrong:** PROJECT.md commits to one-way local→Coda mirror; Field Notes is a read-only triage queue. In practice, Stage 10 brain-update or next-kickoff sees a Field Note, decides it's "actionable" and *automatically merges* into the local brain. Result: human writes Field Note → bot rewrites local brain → next ship publishes bot's interpretation back to Coda → original intent lost. The "one-way" property is dead.

**Warning sign:** Field Notes rows disappear from Coda after a kickoff with no audit entry showing a human approved the merge. Brain spoke gains a paragraph the human can't trace.

**Prevention:**
1. Field Notes ingestion emits a *kickoff prompt artefact*, not a brain edit. Kickoff skill *quotes* the Field Note, surfaces it, asks: keep / drop / edit-and-keep. Only the human's response touches the brain.
2. Field Notes rows flagged `processed: <kickoff_id>`, never deleted by the bot. Deletion is human-only.
3. Brain-mirror publish refuses to clear a Field Note row.
4. Architecture doc includes an explicit "directional boundary" section.

**Owning phase:** P1 Architecture (directional boundary contract); P3 (Stage 0 kickoff and Stage 10 archive).

**Source:** PROJECT.md Constraints + Out-of-Scope explicitly forbid two-way sync. Risk is design drift, not contradicted spec. **HIGH.**

---

### CRIT-5 — Sandbox-only enforcement breaks when test harness writes to Coda

**What goes wrong:** Stage 7 hybrid harness needs persistent state per client. Someone routes that state through Coda for human visibility. The harness — which enforces sandbox-only on Pipefy/Wrike/Ziflow — has a write surface that can target *production Coda docs*. Rule 1 of `safety-rules.md` covers platform tenants, not Coda doc IDs.

**Warning sign:** Test-harness run writes scratch state to a real client doc. Audit log shows successful Coda writes during a quarantined run.

**Prevention:**
1. Extend sandbox-allowlist schema to include Coda: `coda: { doc_id, table_ids: [...] }`; fail-closed if test plan or harness state references a doc not in the allowlist.
2. Per-client harness state lives in **local filesystem only** (`<Client> Brain/testing/<feature>/state.yaml`). Coda gets a *published mirror* of harness summary, not live state.
3. Mirror writes flow through the same one-way publish path as brain spokes (CRIT-4) — harness can never write to a doc outside its publish target.

**Owning phase:** P4 Test Harness (state-storage contract); P1 Architecture (allowlist schema extension).

**Source:** Repo `safety-rules.md` rule 1 only covers platform tenant IDs, not Coda. **HIGH (gap).**

---

### CRIT-6 — Frontmatter migration corrupts in-flight client builds

**What goes wrong:** Real client projects today carry v0.3.0 frontmatter: `status: draft|approved` mixed with `client_review`, `based_on_functional_spec` underscore-vs-hyphen mismatch, two Stage 6 templates, no Stage 1 (per CONCERNS.md). v2 locks a single canonical scheme; a migration script "upgrades" frontmatter on every artefact. In-flight artefacts now fail the new schema (e.g. SOW at `status: client_review` becomes `approved` because v2 dropped `client_review` — but the human had not approved).

**Warning sign:** A build at "client review" yesterday is at "approved" today, with nobody having approved it. Diff log of the frontmatter change is the only trace.

**Prevention:**
1. **Never auto-rewrite historical frontmatter.** v2 schema applies only to artefacts created at or after v2 cutover.
2. v2 readers (skills) tolerate v0.3.0 frontmatter via `frontmatter_version` field: absent → "v0.3.0 lenient mode"; new artefacts emit `frontmatter_version: 2`.
3. Migration is opt-in *per change request*: when a CR is reopened post-cutover, ask "migrate this CR's frontmatter to v2?" with a diff.
4. Status lifecycle in v2 must include `client_review` (don't drop it; in use in `generate-sow`) AND `approved` AND `draft`, plus document any new states.
5. Re-survey live client folders before locking v2 vocabulary so no live `status:` value gets orphaned.

**Owning phase:** P6 Migration (rollback / co-existence); P1 Architecture (schema versioning).

**Source:** CONCERNS.md "Frontmatter / template structural inconsistencies" + PROJECT.md Constraints. **HIGH.**

---

### CRIT-7 — Test-harness drift between `client_state.yaml` and reality

**What goes wrong:** Persistent harness remembers the sandbox state from the last ship. Between ships, a human implementer manually edits the sandbox (adds a phase, renames a field). Next harness run reads `client_state.yaml`, builds fixtures from stale schema, and *every test fails* — misclassified as "implementation gap" rather than "harness drift," wasting hours.

**Warning sign:** First run after a quiet period returns mass failures all classified as `implementation gap` or `unknown`. Or harness aborts with cryptic schema errors at fixture creation.

**Prevention:**
1. Harness pre-flight fetches current sandbox schema (pipe definition / space / project layout) and diffs against `client_state.yaml.last_known_schema`. Mismatch → halt + `schema_drift_report.md` instead of executing.
2. Drift-detected runs require human action: (a) update `client_state.yaml` (acknowledge drift, regenerate fixtures), or (b) revert sandbox. No silent reconciliation.
3. Schema diff stored as part of harness state, version-tagged.
4. Failure classification gains a fourth class: `harness_drift` (alongside `spec gap | implementation gap | environment issue | unknown`).

**Owning phase:** P4 Test Harness (pre-flight contract); P3 (Stage 7).

**Source:** Repo `execute-tests/SKILL.md` failure classification covers four classes; no drift detection in v0.3.0. **HIGH (gap).**

---

### CRIT-8 — Native-AI knowledge ingestion races doc publishing

**What goes wrong:** Stage 8 publishes updated docs to Drive. Stage 9 ingests new knowledge into the platform-AI bot. Between the two, the doc is partially updated (Drive doc-update is rarely atomic). Stage 9 ingests the Frankenstein state. The bot now answers from a knowledge base *no human ever reviewed*.

**Warning sign:** Bot answers a client question with a mix of old and new policy. Bot cites a section header that exists in the new draft but not the published doc.

**Prevention:**
1. Stage 8 commits a *single* `doc_published_at` timestamp (frontmatter + Drive-doc property) only after human approves the diff *and* the Drive write completes.
2. Stage 9 reads `doc_published_at` and refuses to ingest if older than `last_diff_review_at` or null.
3. For UI-paste platforms (Wrike per repo references; Ziflow couldn't verify externally), manual procedure includes a "checksum" step: paste a SHA of source doc into a known-location field, so next ship can detect "ingested != published."
4. Native-AI ingestion is **always Stage 9, never bundled into Stage 8** — boundary is the human's diff-approval gate.

**Owning phase:** P3 (Stage 8 + Stage 9 ordering); P1 Architecture (publish-then-ingest invariant).

**Source:** PROJECT.md Stage 8 + Stage 9 are explicitly separate; ingestion paths "direct API or copy-paste fallback per platform." **MEDIUM** (per-platform AI ingestion APIs not externally verified).

---

### CRIT-9 — Coda token over-scope leak

**What goes wrong:** A bot token created with default scope inherits the creator's permissions across *all* their Coda docs. v2 plugin uses one token for the costing table, brain mirror, and Field Notes. That token can write to every Coda doc the human owner can write to — including unrelated personal/internal docs.

**Warning sign:** Stage 5 logs show writes succeeding to a doc ID the team doesn't recognise. Or incident report involves a doc the bot was never supposed to touch.

**Prevention:**
1. Plugin doc requires per-client tokens, **each restricted at creation time** to the specific docs needed (cost, brain-mirror, Field Notes).
2. Plugin reads from documented secrets layout: `<CLIENT>_CODA_TOKEN` per client; refusal if the env var name doesn't match the client folder name.
3. Build prompts (Stage 6) and skill bodies NEVER hard-code a doc ID; doc IDs come from per-client config (e.g. `<Client> Brain/00_HUB.md` `Coda:` block, mirroring Drive-link contract).
4. Plugin v2 audit includes a "token blast radius" section.

**Owning phase:** P5 Integrations (secrets/scoping contract); P1 Architecture (multi-tenant boundary).

**Source:** Context7 `/websites/coda_io_apis_v1` — "Bearer tokens created for the Coda API, by default, have the same permissions as the user who generated them. It is possible to create tokens with restricted authorization." **HIGH.**

---

### CRIT-10 — Approval-gate bypass through "implementor confidence"

**What goes wrong:** v2 framing is "senior implementation partner." That voice can lead skills to *act before approval* — "I went ahead and added the Coda row since the cost was clearly correct" — violating PROJECT.md's non-negotiable approval gates. Once bypassed, team trust erodes; next regression makes the team treat the bot as suspect for unrelated reasons.

**Warning sign:** Stage transitions show no `approved_by:` frontmatter line. Reviewer says "I never approved this" while the artefact carries `status: approved`.

**Prevention:**
1. Every stage skill ends with a *handoff that names the approval action* — e.g. "Reply `approve` to set `status: approved` on `02_functional-spec_v3.md`." Skill never sets `status: approved` without the explicit phrase.
2. `status: approved` writes carry `approved_by: <user-handle>` and `approved_at: <ISO>`, mirrored into the audit-log convention from `safety-rules.md` rule 5.
3. Stage-skill quality bar includes "does not auto-progress" — already in v0.3.0; v2 must **preserve and re-state** this in every new stage skill (Stage 0, 5, 7, 8, 9, 10).
4. Plugin includes a hook (post-frontmatter-write) that refuses any change to `status: approved` lacking `approved_by:`. (See MOD-3 hook risk; logic must be small and well-tested.)

**Owning phase:** P1 Architecture (approval-gate contract); P3 (every new stage skill).

**Source:** PROJECT.md Constraints "No auto-progression between stages; humans approve every artefact before the next stage runs." **HIGH.**

---

## Moderate Pitfalls

### MOD-1 — Hub-link contract failure halts unrelated stages

**Symptom:** Stage 2 SOW skill aborts with "no Documentation: link in hub" — wrong stage, wrong error.
**Prevention:** Stage-dependency matrix in architecture doc lists which stages require which connectors / hub fields. Stages without the dependency MUST run. Plugin includes startup-time `connector_health_check`. Graceful-degradation behaviour codified: doc-update → halt; brain-mirror → halt; cost-generation → manual-mode (write costing markdown locally, defer Coda); native-AI ingestion → manual-paste fallback; everything else → unaffected.
**Owning phase:** P1 Architecture; P2 (health-check command).
**Source:** PROJECT.md Constraints — hub-link contract specified; degradation behaviour for other connectors not yet specified. **MEDIUM (gap).**

### MOD-2 — Slash-command name collision in `/refine-<skill>` reintroduction

**Symptom:** `/refine-functional-spec` invocation produces an error mentioning a different plugin's skill, or refines the wrong sub-spec after the Stage 3 split.
**Prevention:** Plugin v2 design **decides** whether `/refine-<skill>` exists. If yes, namespace as `/dydx-refine-<skill>`. Stage 3 split: `/dydx-refine-platform-fnspec` and `/dydx-refine-integration-fnspec`. If "don't build it," **delete the references in v0.3.0 docs** during cutover so orphan references don't leak.
**Owning phase:** P2 Plugin Surface; P6 Migration (orphan-reference sweep).
**Source:** CONCERNS.md "/refine-<skill> slash commands referenced but absent" — orphan references at root README:56, dydx-delivery README:51, dydx-delivery README:85. **HIGH.**

### MOD-3 — Hook corrupts frontmatter during artefact generation

**Symptom:** Stage N+1 skill aborts with "no `status:` in frontmatter" against an artefact the human just approved.
**Prevention:** Hooks operate on a *parsed YAML object*, never raw markdown. Use `yaml.safe_load`/`safe_dump` round-trip; refuse to write if round-trip fails. Every mutating hook emits a sibling diff for one-shot human inspection on first run. Hook smoke test in v2 build phase: a fixture artefact passes through every hook; result equals canonical scheme. Hooks are **opt-in per skill**, not global, until each is validated.
**Owning phase:** P2 Plugin Surface (hook architecture); P4 (hook smoke tests in harness).
**Source:** Training-data inference about YAML round-trip risk + PROJECT.md "frontmatter must be locked." **MEDIUM.**

### MOD-4 — Pipefy GraphQL pagination silently truncates

**Symptom:** Test plan claims to cover N=100 cards; harness only inspects the first 30. Coverage map looks complete because derived from AC-IDs, not observed card IDs.
**Prevention:** Platform-pipefy skill provides `paginate_all(query)` helper that follows `endCursor` until `hasNextPage: false`. Harness MUST use it for any list call. Pre-flight asserts `len(observed_set) == expected_set` for fixture inventories; mismatch = `INFRA_FIXTURE_DRIFT`. Test plans depending on "all cards in phase X" use the helper.
**Owning phase:** P5 Integrations (platform-pipefy contract); P4 (pre-flight contract).
**Source:** Repo `INTEGRATIONS.md` lists Pipefy as GraphQL but doesn't address pagination (gap). External Pipefy GraphQL pagination semantics couldn't be verified via Context7 — flag for build-phase verification. **LOW** on exact cursor field names; **HIGH** on the category (GraphQL pagination is a near-universal pitfall).

### MOD-5 — Wrike OAuth token-host trap during bulk reads

**Symptom:** A specific client's harness pre-flight fails with 401 while the same token works in another tool. Team blames "expired token" and re-issues — same symptom.
**Prevention:** Platform-wrike skill MUST persist `host` from the token response and use it as API base URL. Hard-coding `www.wrike.com` is a bug. Per-client `client_state.yaml` includes `wrike_host`; mismatch with current token-issued host = halt with `WRIKE_HOST_DRIFT`. Document in platform-wrike "auth pattern" section.
**Owning phase:** P5 Integrations (platform-wrike contract).
**Source:** Context7 `/websites/developers_wrike` — token response includes `host`; base URL is `https://<host>/api/v4`; wrong host returns same `not_authorized` error as expired token. **HIGH.**

### MOD-6 — Ziflow eventual consistency on proof creation

**Symptom:** Ziflow tests pass when re-run after a delay but fail in immediate execution. Re-runs flap.
**Prevention:** Platform-ziflow skill provides `wait_for_proof(project_id, timeout=10s)` polling helper. Test plan rows integrating with Ziflow prefer `assertion: integration_called` — assertion is "the create call was made and accepted," not "the resource is readable." Where read-back is required, harness uses the wait helper; flaky tests not allowed.
**Owning phase:** P5 Integrations (platform-ziflow contract); P4 (assertion-type guidance).
**Source:** Repo `INTEGRATIONS.md` documents idempotency / retry / 3x exponential backoff but not read-after-create consistency. External Ziflow consistency semantics couldn't be verified (no Ziflow library in Context7). **LOW** on Ziflow specifically; **HIGH** on the category (read-after-write inconsistency is a near-universal trap).

### MOD-7 — Platform-tier capability claims age fast

**Symptom:** SOW commits to a feature gated behind a tier the client doesn't have; surfaces during build, not scoping.
**Prevention:** Platform skills include `tier_claims_last_verified: <ISO>` frontmatter. Claims older than 6 months trigger a "verify before quoting" warning during Stage 5. Tier-gated features flagged with `verify_with_client_account: true` in the SOW; Stage 5 surfaces this in the human-review summary. Prefer features available on all paid tiers; tier-gating called out at SOW time.
**Owning phase:** P5 Integrations (platform-skill schema); P3 (Stage 2 SOW + Stage 5 cost).
**Source:** CONCERNS.md notes tier claims in templates without verification mechanism. **HIGH** on structural gap; the *currency* of any specific tier claim is **LOW** until reverified.

### MOD-8 — Field Notes pile-up at every kickoff

**Symptom:** Kickoff skill spends most of its time on Field Notes triage; humans default to "ignore the whole table."
**Prevention:** Each Field Note row gains `processed_at: <kickoff_id>` on first triage; dropped notes flagged `decision: drop` not deleted (audit retention). Kickoff skill defaults to showing only `processed_at IS NULL` plus `decision: keep_for_followup`. Annual brain-archive sweep: notes older than 1 year with `decision IN (drop, processed)` move to a `Field Notes Archive` doc, out of the live triage path.
**Owning phase:** P3 (Stage 0 kickoff); P1 (Field Notes lifecycle contract).
**Source:** Logical inference from PROJECT.md description. **MEDIUM** (no live data on real volumes).

### MOD-9 — Brain spoke leaks internal-only language to Coda

**Symptom:** Slack message: "did the bot really call our finance team 'the Karen risk'?"
**Prevention:** Brain-mirror publish runs a `tone_lint` pass before write: list of forbidden patterns (per-client `<Client> Brain/.lint.yaml`) plus generic "informal/derogatory" heuristics. Lint failure halts publish, surfaces lines for human edit. No silent rewrite. Brain-spoke template includes a "client-readable language" reminder. v2 publishes a *redacted view* to Coda, not a verbatim copy, with redaction policy committed to the plugin.
**Owning phase:** P3 (Stage 10 brain-update); P1 (publish-pipeline contract).
**Source:** Logical inference from one-way mirror + human writing patterns. **LOW** on prevalence; **HIGH** on consequences if it happens.

### MOD-10 — Risk-multiplier indefensible at client questioning

**Symptom:** Cost reviews regress to manual recalc because the multiplier feels black-box.
**Prevention:** Every multiplier carries a `rationale: <one-line>` field in the costing table. Multiplier taxonomy committed to plugin docs, not derived from hidden prompt heuristics: e.g. `1.0 baseline | 1.2 unfamiliar integration | 1.4 novel platform feature | 1.6 multi-system cutover | 2.0 client-side dependency outside team control`. SOW (Stage 2) carries multiplier rationale forward so client signs aware. If the agent can't pick from the closed taxonomy, the cost row is `<TBC — needs human risk call>` rather than guessed.
**Owning phase:** P3 (Stage 5 design).
**Source:** PROJECT.md Stage 5 specifies "risk-adjusted hours" without taxonomy. **HIGH** on structural need.

### MOD-11 — Test cases linger past relevance

**Symptom:** Verdict is `RED` for three months running; team treats it as background noise.
**Prevention:** Each test case carries `last_passed_at: <ISO>` and `targets_artefact: <doc-ref>`. After a ship that removes the targeted section, the harness flags affected tests as `obsolete` and quarantines them — they don't fail, they don't run, they require human "remove or rewrite" decision. Stage 7 generates a `test_obsolescence_report.md`. Tests not passing in 90 days auto-quarantine pending review.
**Owning phase:** P4 Test Harness (test-lifecycle contract).
**Source:** Repo `execute-tests/SKILL.md` describes one-shot run model; v2 persistent harness adds a longitudinal dimension. **HIGH (gap).**

### MOD-12 — Python-vs-AI orchestrator boundary creep

**Symptom:** Test results vary across re-runs of the *same* fixtures with the *same* code. Or Python harness file mostly contains string templating around an LLM client.
**Prevention:** Architecture doc carries hard contract: **Python layer asserts state, schema, presence/absence, equality, regex, retry-count, status-code class.** **AI orchestrator interprets free-form output, classifies failure causes, suggests remediation.** Neither overlaps. Code review rule: Python test code that calls an LLM is suspect; if needed, it goes in the AI-orchestrator layer. Test plans authored by `generate-test-plan` mark each TC with the layer it belongs to; mixed-layer cases flagged for human design.
**Owning phase:** P1 Architecture (boundary contract); P4 (separation enforcement).
**Source:** PROJECT.md Constraints "Deterministic Python harness for state/integration assertions, AI orchestrator on top for judgement calls." **HIGH.**

### MOD-13 — Concurrency conflict with live human in sandbox

**Symptom:** Tests fail intermittently; investigation reveals a human was poking the same pipe at the same time.
**Prevention:** Harness pre-flight checks `sandbox_lock.yaml` in the client folder. Lock acquired = harness runs; lock present and not-mine = abort with `SANDBOX_OCCUPIED`. Lock auto-released on harness exit; TTL fallback (60min) for crashed runs. Manual implementer activity also acquires the lock via small CLI (`dydx-delivery sandbox lock`). Honour-system locking — better than nothing.
**Owning phase:** P4 Test Harness (concurrency contract); P2 Plugin Surface (lock CLI).
**Source:** Repo `safety-rules.md` rule 8 covers test-internal concurrency only. **HIGH (gap).**

### MOD-14 — Sandbox cleanup-via-no-deletes accumulates state

**Symptom:** Pipefy UI takes seconds to load the sandbox pipe; harness pre-flight reports `card_id collision` on fixture creation.
**Prevention:** Out of harness scope (rule 9 is canon), but v2 defines a *separate* sandbox-housekeeping procedure — markdown checklist + a `/dydx-sandbox-housekeeping` command. Fixture naming includes a run-ID prefix (`harness_<run_id>_<fixture_name>`) so housekeeping can find stale fixtures by run age. Procedure surfaces "candidate stale fixtures" but does NOT delete — deletion is human-only via platform UI, preserving safety-rule 2.
**Owning phase:** P4 Test Harness (fixture naming); P2 Plugin Surface (housekeeping command).
**Source:** Repo `safety-rules.md` rule 9 explicitly out of scope for `execute-tests`; v2 inherits the constraint and adds the gap. **HIGH.**

### MOD-15 — Naming-scheme drift: `Client_Project_DocType_Version`

**Symptom:** "Why are there three docs called Acme_Renewal_FunctionalSpec_v1, Acme_Renewal_Functional-Spec_v1, Acme_Renewal_Functional Spec_v1?"
**Prevention:** Stage 8 doc-naming MUST normalise: strip non-alphanumeric, snake_case, lowercase. `<client_slug>__<project_slug>__<doc_type>__v<N>` (double underscore as separator, single underscore reserved for in-segment word breaks). `doc_type` enum is closed: `discovery | sow | platform_fnspec | integration_fnspec | tech_spec | test_plan | build_prompt | results | brain_spoke`. Doc-renames after publish go through a rename helper that updates hub backlinks, not via Drive UI.
**Owning phase:** P3 (Stage 8 design).
**Source:** PROJECT.md Stage 8 specifies "Drive-linked, diff-reviewed, schema-versioned" without specifying naming. **HIGH** on need.

### MOD-16 — Hard-rules duplicate-and-edit (existing v0.3.0 problem inverted)

**Symptom:** A client's `<Client> Brain/` contains a `safety-rules.local.md` that nobody knows how to keep in sync.
**Prevention:** Single SoT is the **schema**; per-client overrides are **values**. Rate limits live in `safety-rules.yaml` keyed by client; `safety-rules.md` describes the schema and references the YAML. Per-client overrides in `<Client> Brain/safety-overrides.yaml`. Skill loads canonical schema + overlays the override; emits a "running with overrides" notice in audit log. Override surface is enumerated and tight: only fields explicitly marked `overridable: true` in the schema can be overridden.
**Owning phase:** P1 Architecture (single-SoT plus override design); P6 Migration (collapse the four duplicates).
**Source:** CONCERNS.md "Hard-rules block duplicated three places" + four-copy mismatch. **HIGH** on existing pain; inverse-problem risk is **MEDIUM**.

---

## Minor Pitfalls

### MIN-1 — Diff-approval rubber-stamp
**Symptom:** Stage 8 surfaces a diff; reviewer clicks approve without reading.
**Prevention:** Diff display includes a "what changed in plain English" summary generated by the publishing skill, plus the raw diff. Approval requires answering one targeted question ("does the new section X correctly reflect Y?"). Mechanical click-through gets harder.
**Owning phase:** P3 (Stage 8 UX).

### MIN-2 — Drive permission asymmetry on new docs
**Symptom:** New Stage 8 doc created with restrictive sharing; client can't read it.
**Prevention:** Stage 8 reads parent folder's effective sharing and applies the same. If the agent lacks read on parent permissions, halt with `DRIVE_PERMISSION_UNREADABLE` and ask human to set sharing manually.
**Owning phase:** P5 Integrations (Drive client).

### MIN-3 — Knowledge-versioning gap in native-AI bots
**Symptom:** Bot answers correctly but cites old policy version; client confused which is canonical.
**Prevention:** Every ingested doc carries `doc_version: <semver>` and `ingested_at: <ISO>`. Bot prompt instruction includes "always cite the doc_version when answering." Stage 9 ingestion bumps version on every ship.
**Owning phase:** P3 (Stage 9).

### MIN-4 — Multi-tenant knowledge leak into wrong client bot
**Symptom:** Client A's bot answers with content from Client B's docs.
**Prevention:** One ingestion target per client per platform. Stage 9 hard-codes per-client target ID in `<Client> Brain/00_HUB.md` `Pipefy AI:` / `Wrike AI:` blocks. Skill refuses to ingest if target doesn't match the artefact's `client:` frontmatter.
**Owning phase:** P3 (Stage 9); P1 (multi-tenant boundary).

### MIN-5 — Stage-numbering scheme orphans existing readers
**Symptom:** v2 collapses to one numbering. Other skills, the harness, and humans grep for the old form and get nothing.
**Prevention:** Pick **file-prefix `00_…10_`** as canonical (already in use for filenames). `Stage-N` labels removed from v2 templates; readers scanning historical artefacts use a tolerant regex.
**Owning phase:** P6 Migration; P1 Architecture.

### MIN-6 — Email-mismatch with stated org
**Symptom:** Plugin manifest lists `jasonmichaelb@gmail.com`; team is "dYdX Digital." Client questions provenance.
**Prevention:** Cosmetic, not blocking. P6 Migration updates `plugin.json` and `marketplace.json` `author.email` / `owner.email` to an org-domain address before any client-facing v2 release.
**Owning phase:** P6 Migration.
**Source:** CONCERNS.md "Email address mismatch with stated org." **HIGH.**

---

## Phase-Specific Warnings

| Phase / Topic | Most-likely Pitfalls | Mitigation Anchor |
|---|---|---|
| P1 Architecture | CRIT-4 two-way sync drift, CRIT-5 sandbox surface for Coda, CRIT-10 approval-gate erosion, MOD-12 harness boundary creep, MOD-16 override-vs-SoT | Directional-boundary doc, sandbox-allowlist schema includes Coda, approval contract, harness boundary contract |
| P2 Plugin Surface (commands/agents/hooks) | MOD-2 slash-command collision, MOD-3 hook frontmatter corruption | Plugin-prefixed commands; hooks operate on parsed YAML only |
| P3 Stage Skills | CRIT-1 formula write, CRIT-2 async 202, CRIT-8 publish-then-ingest, CRIT-10 gate bypass, MOD-7 tier currency, MOD-10 multiplier rationale, MOD-15 naming, MIN-1 rubber-stamp | Per-skill quality bars; explicit handoff messages; stage-dependency matrix |
| P4 Test Harness | CRIT-7 schema drift, MOD-11 stale tests, MOD-12 layer creep, MOD-13 concurrency, MOD-14 fixture sprawl | Drift detection in pre-flight; test-lifecycle states; sandbox lock |
| P5 Integrations | CRIT-3 Coda rate-limit, CRIT-9 token scope, MOD-4 Pipefy pagination, MOD-5 Wrike host, MOD-6 Ziflow consistency | Per-platform skill contract; rate-limit policy; secrets layout |
| P6 Migration | CRIT-6 in-flight artefact corruption, MOD-2 orphan refs, MIN-5 stage-numbering, MIN-6 email | Schema versioning; orphan-reference sweep; co-existence rules |

---

## Connector-availability fallback matrix

Codified per PROJECT.md Constraints — make explicit in v2 architecture.

| Connector | Stage(s) | Fallback when missing |
|---|---|---|
| Coda MCP | Stage 5 (cost), Stage 10 (brain mirror) | Stage 5 → manual mode (markdown costing only); Stage 10 → halt brain mirror, rest of archive runs |
| Google Drive MCP | Stage 8 (doc update) | Halt Stage 8; rest of pipeline runs |
| Miro MCP | Stage 0 (kickoff capture) | Manual paste fallback for kickoff content |
| Gmail MCP / Calendar MCP | Stage 0 (kickoff capture) | Manual paste fallback |
| Pipefy / Wrike / Ziflow APIs | Stage 7 (test harness), build phase | Halt the affected stage; surface clear error; rest runs |
| Native-AI ingestion API (Pipefy AI direct) | Stage 9 | Copy-paste UI fallback |
| Native-AI ingestion (Wrike, Ziflow) | Stage 9 | Copy-paste UI fallback (already documented path) |

**Owning phase:** P1 Architecture.

---

## Sources

### HIGH confidence (Context7-verified)

- **Coda API rate limits** — `https://coda.io/developers/apis/v1` via Context7 `/websites/coda_io_apis_v1`: "Reading data: 100 requests per 6 seconds; Writing data: 10 requests per 6 seconds; Writing doc content data: 5 requests per 10 seconds; Listing docs: 4 requests per 6 seconds; per-user across all endpoints sharing the same limit and across all docs"
- **Coda async mutation pattern** — Context7 `/websites/coda_io_apis_v1`: "Each API endpoint that mutates a document will return a request id that you can pass to mutationStatus to check the completion status. Status information is not guaranteed to be available for more than one day after the mutation was completed."
- **Coda 202 Accepted on row writes** — Context7 `/websites/coda_io_apis_v1`: `POST /docs/{docId}/tables/{tableIdOrName}/rows` "always returns a 202, so long as the row exists and is accessible (and the update is structurally valid)."
- **Coda formula columns are calculated** — Context7 `/websites/coda_io_apis_v1` Column Schema: `calculated: boolean — Whether the column has a formula set on it`, `formula: string — Formula on the column`.
- **Coda token scope** — Context7 `/websites/coda_io_apis_v1`: "Bearer tokens created for the Coda API, by default, have the same permissions as the user who generated them. It is possible to create tokens with restricted authorization."
- **Coda upsert with keyColumns** — Context7 `/websites/coda_io_apis_v1` `POST /docs/{docId}/tables/{tableId}/rows/upsert` body supports batch `rows: [...]` with optional `keyColumns: [...]` for matching.
- **Wrike OAuth host parameter** — Context7 `/websites/developers_wrike` (`https://developers.wrike.com/oauth-20-authorization`): token response includes `host`; API base URL is `https://<host>/api/v4`; wrong host returns `not_authorized` (same shape as expired token).

### HIGH confidence (in-repo audit, dated 2026-05-09)

- `.planning/codebase/CONCERNS.md` — version mismatches; missing `platform-pipefy`/`platform-wrike` skills; orphan `/refine-<skill>` references; stage-numbering inconsistencies; frontmatter scheme inconsistencies; hard-rules duplication across four files; missing `commands/agents/hooks` scaffold; email-vs-org mismatch.
- `.planning/PROJECT.md` — Constraints (one-way Coda mirror; approval gates; sandbox-only; hybrid harness); Out of Scope (two-way sync, auto-progression).
- `.planning/codebase/INTEGRATIONS.md` — Pipefy GraphQL + Wrike REST + Ziflow REST + rate-limit / retry / idempotency contracts; OAuth scope assumptions; per-client `.env.example` pattern.
- `.planning/codebase/TESTING.md` and `dydx-delivery/skills/execute-tests/references/safety-rules.md` — sandbox enforcement, deletion bans, audit-trail format, rate limiting, stop conditions, sequential-only concurrency, no-cleanup rule.

### LOW confidence / couldn't verify

- **Pipefy GraphQL pagination cursor field names** — pitfall category is universal but exact cursor schema for Pipefy not Context7-verified. Flag for build-phase verification against Pipefy's official GraphQL docs.
- **Ziflow read-after-create consistency** — pitfall category is universal but Ziflow's specific eventual-consistency window not externally verified. Flag for build-phase smoke test.
- **Native-AI ingestion APIs (Pipefy AI direct ingest, Wrike AI, Ziflow AI)** — repo references "direct API or copy-paste fallback per platform" without verifiable API docs. Flag for build-phase verification per platform; design assumes copy-paste fallback always works.
- **Pipefy/Wrike tier feature gating currency** — claims in skill templates carry no `last_verified_at` today; explicit MOD-7 design move addresses this systemically.
- **Coda doc-content endpoints — exact list bound to the 5/10s ceiling** — Context7 confirms the bucket category but not the precise endpoint enumeration. Treat all `POST/PUT/PATCH` to `/docs/{docId}/...` as bound to the tighter 5/10s limit until further verification.
- **WebSearch unavailable in this session** — denied by environment; broader ecosystem cross-checks (forum threads, postmortems, recent blog posts) not performed. Findings rely on Context7 + in-repo audit; no fabricated external citations.

---

## Top 5 takeaways for the synthesizer / requirements step

1. **Coda's tightest write ceiling is 5 doc-content writes per 10 seconds, per user, across all docs** — Stage 5 per-assignee task generation must batch via `rows/upsert` and must NOT loop per-row. (CRIT-3, Context7-verified.)
2. **All Coda mutations return 202 with a `requestId` and require polling `mutationStatus`** — treating 202 as synchronous success will silently corrupt Stage 5/10 brain mirror. (CRIT-2.)
3. **Default Coda bot tokens inherit creator's full permissions across all docs** — per-client restricted tokens are mandatory; doc IDs must come from per-client config, never hard-coded. (CRIT-9.)
4. **Sandbox-only enforcement (safety-rules.md rule 1) covers platform tenants but NOT Coda doc IDs** — the persistent test harness can write to production Coda docs unless the allowlist schema is extended. (CRIT-5, gap in v0.3.0.)
5. **Frontmatter migration must NOT auto-rewrite historical artefacts** — in-flight client builds carry v0.3.0 frontmatter; auto-migration could change `status: client_review → approved` without human approval. v2 readers must tolerate v0.3.0 frontmatter via `frontmatter_version` field. (CRIT-6.)
