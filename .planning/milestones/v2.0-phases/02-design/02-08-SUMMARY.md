---
phase: 02-design
plan: 08
subsystem: stages-8-9-10-11-skills
tags: [design, stage-skills, test-bot-overview, documentation, native-ai, sign-off, wave-8]
requires: [cross-cutting-decisions-locked, skill-layout-locked, skill-inventory-locked, handoff-matrix-locked, platform-skills-locked, stages-1-3-locked, stages-4a-4b-5-locked, stages-6-7a-7b-locked]
provides: [stage-8-test-bot-overview-design-24, stage-9-documentation-publishing-design-25, stage-10-native-ai-design-26, stage-11-signoff-design-27, closed-doc-type-enum-locked, double-underscore-naming-locked, doc-published-at-invariant-locked, native-ai-path-branching-locked, brain-mirror-7-section-template-locked, field-notes-input-only-preserved]
affects: [.planning/DESIGN.md]
tech_stack:
  added: []
  patterns:
    - "Per-stage decision contract shape per D-20 (Skill / Stage / Complexity / Inputs / Outputs / Hand-off / Status flag / Key v2 decisions / Dependencies / Cross-references)"
    - "Stage 8 test-bot OVERVIEW level only — detailed architecture (DESIGN-28..30) deferred to Plan 02-09 with forward-reference guardrails per cross-AI MEDIUM #6"
    - "DESIGN-25 closed doc_type enum (9 values: discovery | sow | platform_fnspec | integration_fnspec | tech_spec | test_plan | build_prompt | results | brain_spoke); skill quality gate REJECTS non-enum doc_type"
    - "DESIGN-25 double-underscore naming `<client_slug>__<project_slug>__<doc_type>__v<N>` — single-underscore field separators FORBIDDEN (would conflate field boundaries with intra-field underscores in doc_type values like platform_fnspec)"
    - "DESIGN-25 doc-diff workflow: skill writes ChangeRequests/<CR>/doc-diff.md FIRST + halts; reviewer approves writing status: approved + last_diff_review_at: <ISO>; only then Drive push happens setting doc_published_at: <ISO> >= last_diff_review_at: <ISO> by construction (CRIT-8 invariant)"
    - "DESIGN-25 MOD-1 graceful halt — missing 00_HUB.md Documentation: link halts ONLY Stage 9; other stages continue"
    - "DESIGN-26 native_ai_path branching enum (canonical order: api | paste | none); copy-paste fallback IS the default per ## Out of Scope (LOW-confidence native-AI ingestion APIs default to paste, not optimistic API claims)"
    - "DESIGN-26 CRIT-8 refusal — Stage 10 hard halts if doc_published_at < last_diff_review_at; paired contract with DESIGN-25 invariant"
    - "DESIGN-26 MIN-4 refusal — Stage 10 hard halts if per-platform target_id resolved from 00_HUB.md does not match artefact's client: frontmatter (cross-client contamination prevention)"
    - "DESIGN-27 brain-mirror Coda doc template — 7 canonical sections in canonical order (Overview / Workflows / Platforms / Integrations / Operating Model / Change History / Field Notes)"
    - "DESIGN-27 one-way local→Coda mirror per DESIGN-09 directional boundary; Field Notes section is INPUT-ONLY (Stage 11 NEVER overwrites)"
    - "DESIGN-27 tone_lint pass before publish per DESIGN-10 forbidden-phrasings list (MOD-9 prevention)"
    - "DESIGN-27 pre-archive sanity check (orphan refs + missing artefacts + tone_lint + outstanding [OPEN] markers)"
    - "DESIGN-27 CR move to Archive/<CR>/ atomic + 00_Index.md append-only version bump; idempotent re-runs"
    - "Stage 8 sandbox allowlist EXTENDED to Coda (CRIT-5 fix) — canonical safety-rules at dydx-delivery/references/safety-rules.md (per DESIGN-03 SoT) carries the extended allowlist"
    - "Stage 8 failure-class enum extension — `harness_drift` added to `spec gap | implementation gap | environment issue | unknown` (5 classes total in v2)"
    - "Stage 8 test-case lifecycle states `active | obsolete | quarantined`"
    - "Stage 8 sandbox_lock.yaml per client at <Client> Brain/test-bot/sandbox_lock.yaml — single per-client lock; stale-lock detection halts (no auto-clear)"
    - "Stage 8 persistent harness location at <Client> Brain/test-bot/{client_state.yaml, test_runner.py, test_cases/} — explicitly OUTSIDE this repo"
    - "Forward-reference guardrails (cross-AI MEDIUM #6) — DESIGN-28/29/30 cited as anchor placeholders only with explicit FORWARD reference labels; body verification deferred to Plan 02-09"
    - "Echo blockquote `> **DESIGN-NN:**` pattern per D-35 — 4 echo lines added (DESIGN-24/25/26/27 once each); running total 29/30"
key_files:
  created:
    - .planning/phases/02-design/02-08-SUMMARY.md
  modified:
    - .planning/DESIGN.md
decisions:
  - "Phase 2 Plan 08: Stage 8 is the OVERVIEW section only — detailed architecture (DESIGN-28 tier-1/tier-2 boundary + DESIGN-29 client_state.yaml schema + DESIGN-30 drift-detection contract) lives under `## Test bot architecture` and is populated by Plan 02-09 in Wave 9. Forward references from Stage 8 overview to DESIGN-28/29/30 are explicit anchor placeholders (`FORWARD reference, populated by Plan 02-09`); acceptance criteria in this plan did NOT assert DESIGN-28/29/30 body content (T-02-08-08 mitigation per cross-AI MEDIUM #6)."
  - "Phase 2 Plan 08: Stage 8 substages — 4 enumerated (8a provision-test-harness/ NEW + 8b generate-test-plan/ MODIFIED + 8c generate-uat-plan/ NEW + 8d execute-tests/ MODIFIED with paths moved under <Client> Brain/test-bot/); persistent harness explicitly OUTSIDE this repo at <Client> Brain/test-bot/{client_state.yaml, test_runner.py, test_cases/}."
  - "Phase 2 Plan 08: Stage 8 failure-class enum extension — `harness_drift` added as fifth canonical class (v0.3.0: `spec gap | implementation gap | environment issue | unknown`; v2: `spec gap | implementation gap | environment issue | harness_drift | unknown`)."
  - "Phase 2 Plan 08: Stage 8 sandbox_lock.yaml — single per-client concurrency lock at <Client> Brain/test-bot/sandbox_lock.yaml; stale-lock detection halts with explicit error (no auto-clear). Prevents two concurrent test runs from contending for same sandbox tenant."
  - "Phase 2 Plan 08: Stage 8 sandbox allowlist EXTENDED to Coda (CRIT-5 fix) — v0.3.0 dydx-delivery/skills/execute-tests/references/safety-rules.md allowlists Pipefy/Wrike/Ziflow sandbox tenants but OMITS Coda sandbox; v2 canonical safety-rules at dydx-delivery/references/safety-rules.md (per DESIGN-03 SoT promotion) carries the extended allowlist including Coda."
  - "Phase 2 Plan 08: Stage 8 test-case lifecycle states locked — `active | obsolete | quarantined` (3 states); per-test-case `state:` field in <Client> Brain/test-bot/test_cases/<case>.yaml; quarantine is bounded (reviewer must triage before each ship)."
  - "Phase 2 Plan 08: Stage 8 tier separation high-level contract (detailed under DESIGN-28 FORWARD) — Python tier-1 deterministic (state assertions / schema checks / equality / regex / retry-count / status-code class) + AI tier-2 orchestrator (free-form output interpretation / failure classification / remediation suggestion); tier-1 tests are HUMAN-AUTHORED, AI does NOT write tier-1 per `## Out of Scope`."
  - "Phase 2 Plan 09 will populate DESIGN-28 / DESIGN-29 / DESIGN-30 H3 sections under `## Test bot architecture` (worked tier-1/tier-2 classification example + skeleton client_state.yaml schema + drift-detection algorithmic contract)."
  - "Phase 2 Plan 08: Stage 9 closed doc_type enum locked — exactly 9 values (discovery | sow | platform_fnspec | integration_fnspec | tech_spec | test_plan | build_prompt | results | brain_spoke); skill quality gate REJECTS non-enum doc_type. Adding a new doc_type requires updating this enum + the Stage 9 quality gate + the Stage 10 ingestion filter."
  - "Phase 2 Plan 08: Stage 9 naming convention locked at <client_slug>__<project_slug>__<doc_type>__v<N> with DOUBLE-UNDERSCORE separator. Single-underscore separators FORBIDDEN by skill quality gate (single-underscores appear inside doc_type enum values like `platform_fnspec`, so a single-underscore field separator would conflate field boundaries with intra-field underscores). Slugs are kebab-case lowercase per DESIGN-01."
  - "Phase 2 Plan 08: Stage 9 doc-diff-before-publish workflow — skill writes ChangeRequests/<CR>/doc-diff.md FIRST + halts at status: draft; reviewer approves writing status: approved + last_diff_review_at: <ISO>; only then Drive push happens setting doc_published_at: <ISO>. By construction doc_published_at >= last_diff_review_at — this is the invariant Stage 10 (DESIGN-26 CRIT-8 refusal) refuses to violate."
  - "Phase 2 Plan 08: Stage 9 MOD-1 graceful halt — if <Client> Brain/00_HUB.md `Documentation:` link is missing, Stage 9 halts with explicit error in doc-diff.md; OTHER stages continue (graceful = does not halt other stages). Resume condition: reviewer adds Documentation: link to 00_HUB.md AND re-runs Stage 9 against same cr_id."
  - "Phase 2 Plan 08: Stage 10 native_ai_path enum locked at canonical order `api | paste | none` (3 branches); copy-paste fallback IS the default per `## Out of Scope` (LOW-confidence native-AI ingestion APIs per DESIGN-14/15/16 [OPEN] markers default to paste, not optimistic API claims). Optimistic-API anti-pattern explicitly forbidden."
  - "Phase 2 Plan 08: Stage 10 CRIT-8 refusal contract — Stage 10 REFUSES to ingest any doc fragment whose source Drive doc carries doc_published_at < last_diff_review_at. Hard halt, not warning. Paired contract with DESIGN-25 invariant. If Stage 10 reads a fragment violating the invariant (e.g., a manually-edited Drive doc that bypassed Stage 9), the skill halts with explicit error in 10_native-ai-push_v<N>.md."
  - "Phase 2 Plan 08: Stage 10 MIN-4 refusal contract — Stage 10 reads per-platform target ID from <Client> Brain/00_HUB.md (Pipefy AI: / Wrike AI: / Ziflow AI: blocks). REFUSES to ingest if resolved target_id does not match artefact's client: frontmatter. Prevents cross-client contamination (a v2 design contract addressing MIN-4 'wrong tenant ingestion' historic risk). Hard halt; reviewer triages 00_HUB.md configuration."
  - "Phase 2 Plan 08: Stage 10 per-doc traceability — every ingested fragment carries doc_version: <semver> (carried forward from Stage 9 doc_version:) + ingested_at: <ISO> (set by Stage 10 at moment of ingestion) + target_id: <platform-specific> (the per-platform AI target identifier). Downstream audit can reconstruct what version of which doc was pushed to which target at what time."
  - "Phase 2 Plan 08: Stage 11 brain-mirror Coda doc template locked — 7 canonical sections in canonical order (Overview / Workflows / Platforms / Integrations / Operating Model / Change History / Field Notes). Section count + ordering is the design contract; Phase 8 of 9-phase build (per CHANGE-04) implements the template via OPEN-05 standard Coda templates work."
  - "Phase 2 Plan 08: Stage 11 one-way Coda mirror per DESIGN-09 directional boundary — local canonical, Coda mirror; Coda → local merge OUT OF SCOPE. Field Notes is the only Coda → local channel (Stage 1 reads processed_at IS NULL rows, NOT Stage 11)."
  - "Phase 2 Plan 08: Stage 11 tone_lint pass before publish (MOD-9 prevention) — runs against EVERY spoke per DESIGN-10 forbidden-phrasings list ('we recommend' / 'as an AI' / 'I would suggest' / 'perhaps consider' / 'might want to' + rest of 10-item list); failure halts; tone_lint_status: passed | failed recorded on 11_signoff_v<N>.md."
  - "Phase 2 Plan 08: Stage 11 CR archive workflow — atomic mv from <Client> Brain/<Project>/ChangeRequests/<CR>/ to <Client> Brain/<Project>/Archive/<CR>/; idempotent re-runs (already-archived CR detection = no-op); 00_Index.md append-only version bump per archived CR (cr_id + archived_at + summary + artefacts list + spokes touched)."
  - "Phase 2 Plan 08: Stage 11 pre-archive sanity check — orphan refs (every based_on_*: resolves to existing approved file) + missing artefacts (every doc-diff.md doc was actually pushed to Drive per doc_published_at:) + tone_lint pass + outstanding [OPEN: Phase 4 — ...] markers (any introduced during this CR must be resolved or explicitly deferred-with-justification). Failure halts; reviewer triages."
  - "Phase 2 Plan 08: Stage 11 Field Notes preserved input-only — Coda Field Notes table is the input-only triage queue per DESIGN-09; Stage 1 (kickoff-capture) reads processed_at IS NULL rows; Stage 11 NEVER overwrites Field Notes table; brain-mirror push explicitly excludes Field Notes section from write set. Field Notes table is NEVER overwritten."
  - "Phase 2 Plan 08: Echo count progresses 25 -> 29/30 (DESIGN-24 once + DESIGN-25 once + DESIGN-26 once + DESIGN-27 once = 4 net new echoes); structural-check exits 1 with assertion #4 short-circuit at 29 < 30 — expected mid-phase invariant; Plan 02-09 closes remaining DESIGN-28/29/30 to reach 32/30 final (>= 30 assertion tolerates dual-echo overcount)."
  - "Phase 2 Plan 08: No new inline [OPEN: Phase 4 — ...] markers added in Stages 8-11 — all DESIGN-24/25/26/27 contracts LOCKED with closed enums (doc_type 9 values; native_ai_path 3 values; brain-mirror 7 sections; failure-classes 5 values; lifecycle states 3 values). Inline marker count unchanged from Plan 02-07 baseline (= 17 across DESIGN.md)."
  - "Phase 2 Plan 08: Forward-reference guardrails per cross-AI MEDIUM #6 honoured — DESIGN-28 (tier-1/tier-2 boundary) + DESIGN-29 (client_state.yaml schema) + DESIGN-30 (drift-detection contract) cited as FORWARD anchor placeholders only at every cite site (Stage 8 overview cross-references); acceptance criteria in this plan did NOT assert DESIGN-28/29/30 body content exists (those H3 sections still carry `(populated by 02-09-PLAN.md)` placeholders); verification deferred to Plan 02-10 Appendix B traceability synthesis (T-02-08-08 mitigation honoured)."
  - "Phase 2 Plan 08: No content under dydx-delivery/ modified — design-only milestone discipline maintained per kickoff mandate."
  - "Phase 2 Plan 08: Recovery from Task 1 over-broad Edit — initial Stage 8 + Stage 9 Edit accidentally included Stage 10 + Stage 11 placeholders in the old_string, so the post-Task-1 file lacked Stage 10/11 placeholders. Recovery: Task 2 Edit inserted Stage 10 + Stage 11 sections between the existing Stage 9 cross-references line and the `## Test bot architecture` H2 — net effect identical to the planned 4-section addition; both Task 1 and Task 2 commits remain atomic and reviewable."
metrics:
  duration_minutes: 12
  completed_date: "2026-05-09"
  task_count: 2
  file_count: 1
---

# Phase 2 Plan 08: Stages 8/9/10/11 — Test bot overview (DESIGN-24) + Documentation publishing (DESIGN-25) + Native-AI enablement (DESIGN-26) + Sign-off (DESIGN-27) Summary

**One-liner:** Locked DESIGN-24 (Stage 8 test-bot OVERVIEW only — provision-test-harness 8a + persistent harness OUTSIDE this repo at `<Client> Brain/test-bot/{client_state.yaml, test_runner.py, test_cases/}` + tier-1 deterministic Python / tier-2 AI orchestrator / hard layer-separation contract / `harness_drift` fifth failure class / `sandbox_lock.yaml` concurrency / sandbox allowlist EXTENDED to Coda CRIT-5 fix / test-case lifecycle states `active | obsolete | quarantined` / 4 substages 8a/8b/8c/8d enumerated; detailed architecture under `## Test bot architecture` DESIGN-28..30 deferred to Plan 02-09 with FORWARD-reference guardrails per cross-AI MEDIUM #6) + DESIGN-25 (Stage 9 documentation publishing — `update-documentation` skill NEW writes `ChangeRequests/<CR>/doc-diff.md`; closed `doc_type` enum 9 values `discovery | sow | platform_fnspec | integration_fnspec | tech_spec | test_plan | build_prompt | results | brain_spoke`; double-underscore naming `<client_slug>__<project_slug>__<doc_type>__v<N>`; doc-diff-before-publish reviewer-approval gate; `doc_published_at` invariant set at push >= `last_diff_review_at` by construction; MOD-1 graceful halt on missing `00_HUB.md` `Documentation:` link) + DESIGN-26 (Stage 10 native-AI enablement — `push-native-ai-knowledge` skill NEW; `native_ai_path: api | paste | none` branching with copy-paste fallback DEFAULT per `## Out of Scope`; CRIT-8 refusal `doc_published_at < last_diff_review_at` hard halt paired contract with DESIGN-25 invariant; MIN-4 refusal per-platform target_id mismatch with `client:` cross-client contamination prevention; per-doc traceability `doc_version: <semver>` + `ingested_at: <ISO>` + `target_id:`) + DESIGN-27 (Stage 11 sign-off + brain update + archive — `sign-off-and-archive` skill NEW; brain-mirror Coda doc template 7 canonical sections Overview / Workflows / Platforms / Integrations / Operating Model / Change History / Field Notes; one-way local→Coda push per DESIGN-09; `tone_lint` pass MOD-9 prevention; CR move to `Archive/`; `00_Index.md` append-only version bump; pre-archive sanity check; Field Notes table is NEVER overwritten input-only per DESIGN-09); 4 echo blockquotes added (DESIGN-24/25/26/27 once each); running total 29/30; structural-check exits 1 at expected mid-phase invariant.

## What Was Done

### Task 1 — Stage 8 overview (DESIGN-24) + Stage 9 documentation publishing (DESIGN-25)

Replaced placeholder bodies of `## Stage 8: Test bot — overview` and `## Stage 9: Documentation publishing` H2 sections.

**(A) Stage 8 — Test bot overview (DESIGN-24).** Stage-level overview only; detailed architecture (DESIGN-28..30) lives under `## Test bot architecture` and is populated by Plan 02-09 in Wave 9.

- **Echo blockquote:** `> **DESIGN-24:** Stage 8 Test bot architecture (overview) — provision-test-harness skill (8a) bootstraps once + delta-updates each ship; persistent harness lives at <Client> Brain/test-bot/{client_state.yaml, test_runner.py, test_cases/} (outside this repo); tier-1 deterministic Python + tier-2 AI orchestrator with hard layer-separation contract; harness_drift failure class added to spec gap | implementation gap | environment issue | unknown; sandbox_lock.yaml for concurrency; sandbox allowlist extended to Coda (CRIT-5 fix); test-case lifecycle states active | obsolete | quarantined. Detailed tier-1/tier-2 boundary + client_state.yaml schema + drift-detection contract live under ## Test bot architecture (DESIGN-28..30 — FORWARD reference, populated by Plan 02-09).`
- **4 substages enumerated:** 8a `provision-test-harness/` (NEW; bootstraps + delta-updates persistent harness) + 8b `generate-test-plan/` (MODIFIED; carries forward from v0.3.0 per AUDIT.md §AUDIT-01.5; paths move under `<Client> Brain/test-bot/test_cases/`) + 8c `generate-uat-plan/` (NEW; UAT plan; human-facing) + 8d `execute-tests/` (MODIFIED; carries forward from v0.3.0 per AUDIT.md §AUDIT-01.7; paths move; tier-2 AI orchestrator invocation per DESIGN-28 FORWARD).
- **Persistent harness location (DESIGN-24 contract):** `<Client> Brain/test-bot/{client_state.yaml, test_runner.py, test_cases/}` — explicitly OUTSIDE this repo. Per-client; reused across CRs.
- **Tier separation (high-level — detailed under DESIGN-28 FORWARD):** Python tier-1 deterministic (state / schema / equality / regex / retry-count / status-code class) + AI tier-2 orchestrator (free-form interpretation / failure classification / remediation suggestion). Tier-1 tests are HUMAN-AUTHORED; AI does NOT write tier-1 per `## Out of Scope`. Mixed-layer cases flagged for human design.
- **Failure-class enum extension:** `harness_drift` added as 5th canonical class. v2 enum: `spec gap | implementation gap | environment issue | harness_drift | unknown`.
- **Concurrency:** Single per-client `sandbox_lock.yaml` at `<Client> Brain/test-bot/sandbox_lock.yaml`. Stage 8d `execute-tests` acquires lock before run; releases on completion. Stale-lock detection halts (no auto-clear).
- **Sandbox allowlist extended to Coda (CRIT-5 fix):** v0.3.0 `dydx-delivery/skills/execute-tests/references/safety-rules.md` omits Coda sandbox; v2 canonical safety-rules at `dydx-delivery/references/safety-rules.md` (per DESIGN-03 SoT promotion) extends allowlist to include Coda. v0.3.0 path RETIRED per DESIGN-03 (4-copy collapse catalogued at AUDIT.md §AUDIT-05).
- **Test-case lifecycle states (3):** `active | obsolete | quarantined`. Per-test-case `state:` field in `<Client> Brain/test-bot/test_cases/<case>.yaml`. Quarantine bounded — reviewer must triage before each ship.
- **6 key v2 decisions** at overview level; detailed decisions under DESIGN-28..30 FORWARD.
- **Hand-off messages verbatim from matrix:** Stage 8a/b/c → 8d row + Stage 8d → 9 row.

**(B) Stage 9 — Documentation publishing (DESIGN-25).**

- **Echo blockquote:** `> **DESIGN-25:** Stage 9 Documentation publishing — update-documentation skill writes ChangeRequests/<CR>/doc-diff.md; reviewer-approval gate before push; deterministic local→Drive folder/filename mapping; closed doc_type enum; naming <client_slug>__<project_slug>__<doc_type>__v<N> (double-underscore separator); doc_published_at timestamp invariant; halt condition if 00_HUB.md Documentation: link missing (graceful — does not halt other stages per MOD-1).`
- **Skill / Stage / Complexity:** `update-documentation/` (NEW per DESIGN-12 inventory — replaces v0.3.0 ad-hoc documentation drops per AUDIT.md §AUDIT-04) / Stage 9 / Medium.
- **Inputs:** `based_on_test_results: 08d_test-results_v<N>` REQUIRED + all upstream `04*/05/06/07*` artefacts referenced; external = Drive MCP for publish + client `00_HUB.md` `Documentation:` link.
- **Outputs:** `ChangeRequests/<CR>/doc-diff.md` + per-doc Drive uploads. Each Drive doc carries `doc_type:` + `doc_version: <semver>` + `doc_published_at: <ISO>` + `last_diff_review_at: <ISO>`.
- **Closed `doc_type` enum (9 values):** `discovery | sow | platform_fnspec | integration_fnspec | tech_spec | test_plan | build_prompt | results | brain_spoke`. Skill quality gate REJECTS non-enum doc_type.
- **Naming convention:** `<client_slug>__<project_slug>__<doc_type>__v<N>` — DOUBLE-UNDERSCORE separator. Example: `acme-inc__widget-redesign__platform_fnspec__v3`. Single-underscore separators FORBIDDEN.
- **doc-diff-before-publish workflow:** Skill writes `doc-diff.md` first, halts at `status: draft`. Reviewer reviews + writes `status: approved` + `last_diff_review_at: <ISO>`. Then Drive push happens setting `doc_published_at: <ISO>` (always >= `last_diff_review_at` by construction — CRIT-8 invariant).
- **MOD-1 graceful halt:** Missing `<Client> Brain/00_HUB.md` `Documentation:` link → Stage 9 halts ONLY (other stages continue). Resume on link added + Stage 9 re-run.
- **5 key v2 decisions:** closed doc_type enum (9 values); double-underscore naming; doc-diff before push; `doc_published_at` invariant set at push; MOD-1 graceful halt.

### Task 2 — Stage 10 native-AI enablement (DESIGN-26) + Stage 11 sign-off + brain update + archive (DESIGN-27)

Replaced placeholder bodies of `## Stage 10: Native-AI enablement` and `## Stage 11: Sign-off, brain update, archive` H2 sections.

**(A) Stage 10 — Native-AI enablement (DESIGN-26).**

- **Echo blockquote:** `> **DESIGN-26:** Stage 10 Native-AI enablement — push-native-ai-knowledge skill reads Stage 4a + approved Stage 9 doc fragments + per-platform native-ai-inventory.md; branches on native_ai_path: api | paste | none; copy-paste fallback is the default; refuses to ingest if doc_published_at < last_diff_review_at (CRIT-8 fix); per-client target ID in 00_HUB.md Pipefy AI: / Wrike AI: / Ziflow AI: blocks; refuses ingest if target mismatches client: frontmatter (MIN-4 fix); doc_version: <semver> + ingested_at: <ISO> per ingested doc.`
- **Skill / Stage / Complexity:** `push-native-ai-knowledge/` (NEW; v0.3.0 had no native-AI ingestion path) / Stage 10 / **High**.
- **Inputs:** `based_on_fnspec_platform: 04a` REQUIRED + `based_on_doc_diff: ChangeRequests/<CR>/doc-diff.md` REQUIRED (status: approved + last_diff_review_at: set) + `client:` + `platform: pipefy | wrike | ziflow`; external = per-platform `references/native-ai-inventory.md` + `00_HUB.md` `Pipefy AI:` / `Wrike AI:` / `Ziflow AI:` blocks for target ID.
- **Outputs:** `10_native-ai-push_v<N>.md` + per-fragment `doc_version:` + `ingested_at:` + `target_id:`. `native_ai_path:` field on artefact records branch taken.
- **Branching on `native_ai_path` (canonical order):** `api` (HIGH-confidence direct API) / `paste` (copy-paste fallback — DEFAULT) / `none` (no native-AI surface for this fragment).
- **CRIT-8 refusal:** Hard halts if `doc_published_at < last_diff_review_at`. Paired contract with DESIGN-25 invariant.
- **MIN-4 refusal:** Hard halts if per-platform `target_id` from `00_HUB.md` does not match artefact's `client:` frontmatter. Cross-client contamination prevention.
- **Default:** Copy-paste fallback (`paste`) per `## Out of Scope` — LOW-confidence native-AI ingestion APIs default to paste; optimistic-API claims FORBIDDEN.
- **5 key v2 decisions:** native_ai_path 3-branch enum; CRIT-8 refusal; MIN-4 refusal; copy-paste fallback default; per-doc traceability (doc_version + ingested_at + target_id).

**(B) Stage 11 — Sign-off + brain update + archive (DESIGN-27).**

- **Echo blockquote:** `> **DESIGN-27:** Stage 11 Sign-off, brain update, archive — sign-off-and-archive skill updates local <Client> Brain/<spokes>/; one-way push to Coda mirror with brain-mirror Coda doc template (Overview / Workflows / Platforms / Integrations / Operating Model / Change History / Field Notes); tone_lint pass before publish (MOD-9 prevention); CR move to Archive/; 00_Index.md version bump; Field Notes table preserved (input-only, never overwritten); pre-archive sanity check (no orphan refs, no missing artefacts).`
- **Skill / Stage / Complexity:** `sign-off-and-archive/` (NEW) / Stage 11 / Medium. Terminal stage.
- **Inputs:** All upstream artefacts in this CR with `status: approved`; `cr_id:`; external = Coda MCP + brain-mirror Coda doc template per Phase 4 OPEN-05 (landed by Phase 8 of 9-phase build per CHANGE-04).
- **Outputs:** Local `<Client> Brain/<spokes>/` updates + Coda mirror update + CR archive (`mv` to `<Client> Brain/<Project>/Archive/<CR>/`) + `00_Index.md` version bump + `11_signoff_v<N>.md` carrier with `archived_at: <ISO>` + `tone_lint_status:` + `pre_archive_sanity_status:`.
- **Brain-mirror Coda doc template (7 canonical sections):** Overview / Workflows / Platforms / Integrations / Operating Model / Change History / Field Notes. One-way local→Coda push. Field Notes section is INPUT-ONLY (Stage 11 NEVER overwrites).
- **`tone_lint` pass (MOD-9 prevention):** Runs against EVERY spoke per DESIGN-10 forbidden-phrasings list. Failure halts.
- **CR archive:** Atomic `mv` from `ChangeRequests/<CR>/` to `Archive/<CR>/`; idempotent re-runs (already-archived CR detection = no-op).
- **`00_Index.md` version bump:** Append-only entry per archived CR (`cr_id` + `archived_at` + summary + artefacts + spokes touched).
- **Pre-archive sanity check:** orphan refs + missing artefacts + tone_lint pass + outstanding `[OPEN]` markers.
- **Field Notes preserved input-only:** Stage 11 NEVER overwrites Field Notes table; brain-mirror push explicitly excludes Field Notes section from write set. Field Notes table is NEVER overwritten.
- **6 key v2 decisions:** brain-mirror 7-section template; one-way Coda mirror; tone_lint MOD-9; CR archive + 00_Index version bump; pre-archive sanity check; Field Notes preserved input-only.
- **Hand-off message:** Pipeline-end terminal — `> Pipeline complete for CR <cr_id>. Brain updated; Coda mirror published; CR archived. Next CR's Stage 1 reads from updated <Client> Brain/.`

**Structural-check run:** exit code = 1 with assertion #4 short-circuit message `expected >= 30 'DESIGN-NN:' success-criteria echo blockquote lines (D-35), found 29` — expected mid-phase invariant. Plan 02-09 closes remaining 3 echoes (DESIGN-28/29/30) to reach 32/30 final (>= 30 assertion tolerates dual-echo overcount precedent from DESIGN-20/23).

## Files Created / Modified

| File | Type | Change |
|------|------|--------|
| `.planning/DESIGN.md` | modified | `## Stage 8: Test bot — overview` populated with DESIGN-24 stage-level overview (forward refs to DESIGN-28..30); `## Stage 9: Documentation publishing` populated with DESIGN-25 contract (closed `doc_type` enum 9 values + double-underscore naming + doc-diff-before-publish + `doc_published_at` invariant + MOD-1 graceful halt); `## Stage 10: Native-AI enablement` populated with DESIGN-26 contract (`native_ai_path` 3-branch enum + CRIT-8 refusal + MIN-4 refusal + copy-paste fallback default + per-doc traceability); `## Stage 11: Sign-off, brain update, archive` populated with DESIGN-27 contract (brain-mirror 7-section template + one-way Coda mirror + tone_lint MOD-9 + CR archive + 00_Index bump + pre-archive sanity + Field Notes input-only) |
| `.planning/phases/02-design/02-08-SUMMARY.md` | created | This document |

## Echo Count Progression

| Plan | Echoes added | Running total |
|------|--------------|---------------|
| 02-02 | DESIGN-01..10 | 10/30 |
| 02-03 | DESIGN-11/12/13 | 13/30 |
| 02-04 | DESIGN-14/15/16 | 16/30 |
| 02-05 | DESIGN-17/18/19 | 19/30 |
| 02-06 | DESIGN-20 (dual under 4a + 4b) + DESIGN-21 | 22/30 |
| 02-07 | DESIGN-22 + DESIGN-23 (dual under 7a + 7b) | 25/30 |
| **02-08 (this plan)** | **DESIGN-24 + DESIGN-25 + DESIGN-26 + DESIGN-27** | **29/30** |
| 02-09 (next) | DESIGN-28/29/30 | 32/30 (projected — final, dual-echo overcount tolerated by `>= 30`) |
| 02-10 | synthesis | structural-check assertion #4 passes |

DESIGN-24/25/26/27 each contribute 1 echo (single-stage echoes — no dual). Final echo count exceeds 30 because two prior plans had dual-echo IDs (DESIGN-20 under 4a/4b in Plan 02-06 + DESIGN-23 under 7a/7b in Plan 02-07); structural-check assertion #4 uses `>= 30` which tolerates overcount.

## Inline `[OPEN: Phase 4]` Marker Count Progression

| Plan | Marker count | Net change | Notes |
|------|--------------|-----------|-------|
| 02-04 (baseline) | 13 | +13 | 7 new pipefy/wrike/ziflow markers + 6 prior |
| 02-05 | 13 | 0 | DESIGN-17/18/19 contracts LOCKED |
| 02-06 | 13 | 0 | DESIGN-20/21 contracts LOCKED |
| 02-07 | 17 | +4 | 1 NEW canonical D-22 marker + 3 echo references |
| **02-08 (this plan)** | **17** | **0** | DESIGN-24/25/26/27 contracts LOCKED — closed enums (doc_type 9 values; native_ai_path 3 values; brain-mirror 7 sections; failure-classes 5 values; lifecycle states 3 values); no new inline `[OPEN]` markers needed |

All four DESIGN-24/25/26/27 contracts are LOCKED with closed enums; no inline deferrals required.

## Cross-AI Review Fixes Applied

- **HIGH #2 (Codex):** `.planning/phases/02-design/02-08-SUMMARY.md` present in plan frontmatter `files_modified` — verified before execution per plan revision log.
- **MEDIUM #6 (Gemini + Codex):** Forward-reference guardrails — DESIGN-28 (tier-1/tier-2 boundary) + DESIGN-29 (`client_state.yaml` schema) + DESIGN-30 (drift-detection contract) cited as FORWARD anchor placeholders only at every cite site (Stage 8 overview cross-references). Acceptance criteria in this plan did NOT assert that DESIGN-28/29/30 body content exists at end of Wave 8; verification deferred to Plan 02-10 Appendix B traceability synthesis (T-02-08-08 mitigation honoured).

## Threat Model Mitigations Honoured

| Threat ID | Mitigation | Status |
|-----------|-----------|--------|
| T-02-08-01 | Tampering: doc_type enum has fewer/extra values vs REQUIREMENTS canonical 9 — acceptance criteria assert all 9 enum values as literal substrings | ✓ verified all 9: discovery / sow / platform_fnspec / integration_fnspec / tech_spec / test_plan / build_prompt / results / brain_spoke |
| T-02-08-02 | Tampering: naming convention drifts to single underscore — acceptance criteria assert literal `__v` + full convention example | ✓ verified `<client_slug>__<project_slug>__<doc_type>__v<N>` literal present |
| T-02-08-03 | Tampering: native_ai_path uses reverse order — acceptance criteria assert literal `native_ai_path: api | paste | none` (canonical order) | ✓ verified literal `native_ai_path: api | paste | none` present |
| T-02-08-04 | Tampering: DESIGN-26 omits `paste` default → optimistic-API anti-pattern — Action explicitly states "copy-paste fallback IS the default" + cites `## Out of Scope` | ✓ verified prose contract names paste as DEFAULT |
| T-02-08-05 | Tampering: brain-mirror template missing one of 7 sections — acceptance criteria assert all 7 section names | ✓ verified all 7: Overview / Workflows / Platforms / Integrations / Operating Model / Change History / Field Notes |
| T-02-08-06 | Tampering: Field Notes preservation contract reversed — acceptance criteria assert `Field Notes preserved` OR `never overwritten` | ✓ verified `Field Notes table is NEVER overwritten` literal present |
| T-02-08-07 | Tampering: Stage 8 overview drifts into Plan 02-09's DESIGN-28..30 territory — Action explicitly states "Stage-level overview only" | ✓ verified explicit "This section provides stage-level overview only" + "Detailed architecture lives under ## Test bot architecture" prose; DESIGN-28/29/30 cited as FORWARD anchors only |
| T-02-08-08 | Tampering: Acceptance criteria assert content from forward-referenced DESIGN-28/29/30 that doesn't exist yet — false-fail at end of Wave 8 — cross-AI MEDIUM #6 fix: forward references are anchor placeholders only | ✓ no acceptance assertion for DESIGN-28/29/30 body content; deferred to Plan 02-10 Appendix B |

## Deviations from Plan

**1. [Rule 1 - Bug] Task 1 Edit `old_string` over-broad — accidentally consumed Stage 10 + Stage 11 placeholders**

- **Found during:** Task 2 — initial Edit attempt for Stage 10/11 failed because the placeholder lines (`## Stage 10: Native-AI enablement\n(Populated by 02-08-PLAN.md / Wave 8. Covers DESIGN-26.)\n\n## Stage 11: Sign-off, brain update, archive\n(Populated by 02-08-PLAN.md / Wave 8. Covers DESIGN-27.)`) were not present in the file.
- **Issue:** My Task 1 Edit `old_string` had matched all four contiguous placeholder blocks (Stage 8 + Stage 9 + Stage 10 + Stage 11) but the `new_string` only authored Stage 8 + Stage 9 contract bodies followed by direct transition to `## Test bot architecture` — Stage 10 + Stage 11 placeholders were silently consumed.
- **Fix:** Used a fresh Edit in Task 2 with `old_string` anchored on the Stage 9 closing cross-references line + `## Test bot architecture` H2 boundary (the now-adjacent line pair); `new_string` inserted the full Stage 10 + Stage 11 bodies between them. Net effect identical to the planned 4-section addition; both Task 1 and Task 2 commits remain atomic and reviewable. The Task 1 commit (`e6f479a`) writes Stage 8 + Stage 9; the Task 2 commit (`a55a51d`) writes Stage 10 + Stage 11; the H2 ordering and document-flow integrity are preserved.
- **Files modified:** `.planning/DESIGN.md` (Task 2's Edit inserted Stage 10 + Stage 11 sections between Stage 9 closing + `## Test bot architecture` H2).
- **Commit:** `a55a51d` (Task 2 — Stage 10 + Stage 11 contract bodies recovered + inserted).

## Pointer

Plan 02-09 (Wave 9) populates `## Test bot architecture` next (DESIGN-28 tier-1/tier-2 boundary contract + 1 worked test-case classification example + DESIGN-29 skeleton `client_state.yaml` schema with 1 worked example per platform + DESIGN-30 drift-detection algorithmic contract). Running echo total after 02-09 = 32/30 (projected — final, dual-echo overcount tolerated). Plan 02-10 (synthesis — Appendix B + Deferred list dedup + structural-check assertion #4 final pass) follows.

## Self-Check: PASSED

- ✓ `.planning/DESIGN.md` modified — 4 stage subsections (8, 9, 10, 11) populated
- ✓ Commit `e6f479a` exists (Task 1 Stage 8 DESIGN-24 + Stage 9 DESIGN-25) — verified `git log --oneline | grep e6f479a`
- ✓ Commit `a55a51d` exists (Task 2 Stage 10 DESIGN-26 + Stage 11 DESIGN-27) — verified `git log --oneline | grep a55a51d`
- ✓ DESIGN-24 echo present (`grep -qE '^> \*\*DESIGN-24:\*\*' .planning/DESIGN.md`)
- ✓ DESIGN-25 echo present (`grep -qE '^> \*\*DESIGN-25:\*\*' .planning/DESIGN.md`)
- ✓ DESIGN-26 echo present (`grep -qE '^> \*\*DESIGN-26:\*\*' .planning/DESIGN.md`)
- ✓ DESIGN-27 echo present (`grep -qE '^> \*\*DESIGN-27:\*\*' .planning/DESIGN.md`)
- ✓ All Task 1 acceptance greps pass (provision-test-harness + `<Client> Brain/test-bot/` + harness_drift + sandbox_lock.yaml + sandbox allowlist extended to Coda + CRIT-5 + doc_type + `__v` + doc_published_at + last_diff_review_at + platform_fnspec + brain_spoke + MOD-1 + Documentation: + `doc_published_at < last_diff_review_at` + all 9 doc_type enum values + `<client_slug>__<project_slug>__<doc_type>__v<N>` + `active | obsolete | quarantined`)
- ✓ All Task 2 acceptance greps pass (push-native-ai-knowledge + sign-off-and-archive + `native_ai_path: api | paste | none` + CRIT-8 + MIN-4 + MOD-9 + tone_lint + brain-mirror + Operating Model + Change History + Field Notes + 00_Index.md + 10_native-ai-push_v + 11_signoff_v + doc_version + ingested_at + pre-archive sanity check + `Field Notes table is NEVER overwritten`)
- ✓ Echo count = 29/30 (verified `grep -cE '^> \*\*DESIGN-[0-9]{2}:\*\*' .planning/DESIGN.md` returns 29)
- ✓ Structural-check exits 1 with expected assertion #4 short-circuit message at 29 < 30 (mid-phase invariant)
- ✓ No content under `dydx-delivery/` modified
- ✓ Forward-reference guardrails (cross-AI MEDIUM #6) applied — DESIGN-28/29/30 cited as FORWARD anchor placeholders; no body assertions made
- ✓ All STRIDE threats T-02-08-01..08 mitigations verified
