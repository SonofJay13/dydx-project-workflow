# Project Research Summary — dydx-delivery v2.0 "Implementor Edition"

**Project:** dydx-delivery plugin v2.0 (brownfield rebuild on top of v0.3.0)
**Domain:** Claude Code plugin (markdown skills + per-client artefact pipeline) for SI delivery across Pipefy / Wrike / Ziflow
**Researched:** 2026-05-09
**Overall confidence:** MEDIUM-HIGH — plugin-surface mechanics, Coda API, Wrike auth model, Python deps, and in-repo behavioural pitfalls are HIGH; native-AI ingestion APIs (Pipefy/Wrike/Ziflow) and Miro structured-ingest semantics are LOW; vendor MCP availability in the team's tenant is MEDIUM-LOW.

> **Capture caveat.** Two of the four research files (FEATURES.md, PITFALLS.md) were captured by the orchestrator from inline researcher replies because the researcher agent's tool surface blocked Write to `.planning/research/`. This SUMMARY.md was likewise captured from the synthesizer's inline reply for the same reason. Content is verbatim; only the persistence path differs. ARCHITECTURE.md and STACK.md were written directly by their researchers. Confidence in the research substance is unaffected.

---

## Executive Summary

The v2.0 milestone is a **design-only** brownfield rebuild that turns a 7-skill markdown plugin into a 13-skill senior-implementation partner spanning 11 lifecycle stages (Stage 1 kickoff through Stage 11 sign-off, with 4a/4b, 7a/7b, 8a–8d substages). The architecture researcher returned a fully-formed v2 design with explicit NEW/MODIFIED/RETIRED tagging against v0.3.0; the requirements step does not need to invent shape, only to lock the design and prepare the build sequence. The single highest-leverage feature is the **Stage 4 fnspec split** (Platform fnspec vs Integration fnspec) carrying per-requirement `delivery: native-ai|api` tagging — that tag is the routing key for Stages 5, 6, 7, 8d, and 10, and every downstream skill depends on the split landing first.

The recommended approach is to land four canonical references (`safety-rules.md`, `stage-numbering.md`, `frontmatter-scheme.md`, `glossary.md`) at `dydx-delivery/references/` as the first build move, then internalise the three platform skills (`platform-pipefy/wrike/ziflow`) so dangling v0.3.0 references stop breaking, then ship the Stage 1 kickoff + Stage 4 fnspec split before any other new skill, then layer on Coda integration (Stage 5 + Stage 11), the persistent test bot (Stage 7 + 8a–8d + agent), Drive doc publishing (Stage 9), native-AI knowledge push (Stage 10), and finally surfaces (commands/, agents/, hooks/). The stack is markdown + YAML + JSON for the plugin itself; **Python only enters the per-client test harness** that lives in `<Client> Brain/test-bot/` (outside this repo), pinned at Python 3.11 with `gql[requests]`, `requests`, `PyYAML`, and `pytest`.

The dominant risk class is **distributed-system silent failure** on the Coda integration: the Coda doc-content write ceiling is 5 req/10s per user across all docs, every mutation returns `202 Accepted` with a `requestId` that must be polled via `mutationStatus`, formula columns silently revert plain row writes, and default tokens inherit the creator's full permissions across every doc they own. The second risk class is **migration corruption** of in-flight v0.3.0 client artefacts (`status: client_review` could be auto-rewritten to `approved` if the canonical scheme drops it). The third is **native-AI ingestion paths cannot be verified externally** — Pipefy AI / Wrike AI Studio / Ziflow ReviewAI knowledge-base APIs are not documented in any verifiable source available in this run, so Stage 10 must ship with a per-platform `api | paste | none` switch in platform-skill frontmatter and copy-paste fallback as the default. All three are designed-around in the architecture research; the requirements step must lock those design moves as hard constraints.

---

## Key Findings

### Recommended Stack

The plugin itself stays markdown-only (skills, templates, references), YAML for frontmatter, JSON for manifests — no runtime dependency added. v2 adds three new plugin surfaces (`commands/`, `agents/`, `hooks/`) verified HIGH against the Claude Code plugin spec via Context7 `/anthropics/claude-code`. Python 3.11+ enters only inside the per-client test harness at `<Client> Brain/test-bot/`, which the plugin generates but doesn't ship as a runtime dep.

**Core technologies (additions only — v0.3.0 markdown-only baseline carries forward):**

- **Plugin surfaces — `commands/` + `agents/` + `hooks/hooks.json` + `mcpServers` field** — verified Claude Code plugin spec. `commands/` for `/refine-<skill>` family + 4 GSD-prefixed shortcuts; one `agents/test-bot-orchestrator/` for the long-running test loop; two hooks (`validate-frontmatter`, `bump-artefact-version`) — explicitly NOT auto-progression hooks. (HIGH)
- **Coda REST API v1 (direct, not MCP) for Stage 5 + Stage 11** — Bearer token, `keyColumns` upsert pattern for idempotency, `mutationStatus` polling, batch via `POST /rows/upsert`, `calculated:true` columns are read-only. The community `coda-mcp` server is acceptable for interactive single-row ops; the brain-mirror and per-assignee task generation must use direct API for rate-limit and idempotency control. (HIGH on API; MEDIUM on community MCP)
- **Google Workspace unified MCP (Drive + Gmail + Calendar + Docs + Slides)** — recommend `taylorwilsdon/google_workspace_mcp` (MEDIUM, community); avoid splitting Drive/Gmail/Calendar into three separate servers. Pin a specific version, never `@latest`. (MEDIUM)
- **Miro: `miro-api` Python client + paste fallback** — no canonical Miro MCP found in Context7. Stage 1 kickoff branches: API ingest if available, image paste otherwise. Do NOT assume a "render whole board" endpoint exists. (MEDIUM)
- **Test harness Python: `gql[requests]==3.5.*` (Pipefy GraphQL), `requests==2.32.*` (Wrike + Ziflow REST), `PyYAML==6.0.*` (`client_state.yaml`, `safe_load`/`safe_dump` only), `pytest==9.0.*` (harness's own unit tests, not the per-client row-by-row runner)** — `httpx==0.28.*` only if async needed. Keep the v0.3.0 row-by-row markdown-driven runner pattern for the per-client tests; pytest is for testing the harness, not the client. (HIGH on PyYAML, pytest, Python 3.11; MEDIUM on exact patches of gql/requests/httpx)
- **Wrike base URL is dynamic per-account** — the OAuth token response includes a `host` field; hardcoding `www.wrike.com` is a bug (EU/regional accounts use different hosts). Persist `host` in `client_state.yaml`. (HIGH)
- **Versioning: plugin to `2.0.0`, marketplace metadata + plugins[0] to `2.0.0` — locked in sync.** Resolves CONCERNS.md v0.1.0/v0.3.0/1.2.0/hardcoded-v0.1.0-runner mismatch. (HIGH)

**Stack open questions** (must verify during requirements/design before any build phase commits):
1. Coda MCP version pin (install latest, capture exact version)
2. Google Workspace MCP choice between `taylorwilsdon` vs `piotr-agier` vs separate Anthropic-maintained servers
3. Pipefy GraphQL endpoint URL + 2026 rate limits
4. Wrike rate limit currency (200 req/min from v0.3.0 safety-rules.md not re-verified)
5. Ziflow auth header name + base URL
6. **Pipefy AI / Wrike AI / Ziflow native-AI knowledge-ingestion endpoints** — single biggest unknown
7. Latest patch versions for gql/requests/httpx/pytest/PyYAML

### Expected Features (organised by category with table-stakes / differentiator / anti-feature split)

**Cross-cutting structural decisions (table-stakes; lock at requirements time):**

- 11-stage explicit lifecycle with documented hand-offs (carry-forward chain via `based_on_*` frontmatter)
- Single canonical frontmatter scheme (status lifecycle `draft → client_review → approved → archived`; underscore-snake-case field names; hyphen-kebab-case file paths)
- Single canonical stage-numbering (file-prefix `01_`–`11_` with substage suffixes `4a/4b/7a/7b/8a/8b/8c/8d`)
- Single canonical `safety-rules.md` at `dydx-delivery/references/` (collapses 4 v0.3.0 duplicates)
- Connector-availability probe at session start (graceful halt on missing connectors per dependency matrix)
- Internalised platform skills (`platform-pipefy/wrike/ziflow` siblings of stage skills, loaded by `platform:` frontmatter)
- Persona consistency ("senior implementer voice") across all stage skills

**Anti-features at the cross-cutting layer (commit to OUT OF SCOPE):**
- Auto-progression between stages on `status: approved`
- Two-way Coda↔local sync (Field Notes is the controlled read-only exception, never auto-merged)
- One-shot mega-skill that bypasses the stage-gated pipeline
- Inlining hard rules into every SKILL.md "for self-containment"
- Carrying `pipe_id`+`space_id` unconditionally (must be platform-gated)
- A custom MCP server for the test harness (out of scope per PROJECT.md)
- Recreating the test-bot on each ship (must be update-only against `client_state.yaml`)
- Auto-rewriting historical v0.3.0 frontmatter during cutover

**Stage-level table-stakes (per ARCHITECTURE.md skill table):**
- Stage 1 kickoff: meeting-notes / requirements / feedback ingest, Field Notes triage from Coda, Miro paste fallback, dual-branch (discovery vs draft SOW), auto-classify into kickoff template sections
- Stage 2 discovery: consume kickoff artefact (skip raw-notes mode), skip when kickoff produced draft SOW, same template structure as v0.3.0
- Stage 3 SOW: single SOW covers platform AND integration, status lifecycle locked
- Stage 4a/4b fnspec split: per-requirement `delivery: native-ai|api` tagging, per-platform capability matrix as classifier input, cross-spec consistency check, skip 4b if no integration work
- Stage 5 tech spec: scope-gated (only emitted if 4b exists), platform-API addendum on 4a when integration-required portions exist, error handling + observability for API portions
- Stage 6 cost estimate: per-assignee task breakdown, `estimated_hours` + `risk_adjusted_hours` columns with rationale, schema-introspection of existing client task table (cached in 00_HUB.md), spec-line-item links, wait-for-commercial-inputs gate, client-facing cost summary
- Stage 7a dev build prompt (existing) + 7b non-dev implementation prompt (NEW; per-platform shape — Pipefy = Behaviors+KB list, Wrike = Copilot narrative, Ziflow = checklist/criteria)
- Stage 8a provision-test-harness (bootstrap once, update-only thereafter, never recreated)
- Stage 8b test plan + 8c UAT plan (shape unchanged from v0.3.0; path moves to `<Client> Brain/test-bot/test_cases/`)
- Stage 8d execute-tests: row-by-row markdown runner via test-bot agent, sandbox-only, audit-logged
- Stage 9 documentation update: `doc-diff.md` before publish, reviewer approval gate, versioned Drive filenames, halt if 00_HUB.md `Documentation:` link missing
- Stage 10 native-AI knowledge push: per-platform ingestion-path reference, copy-paste fallback always available, Wrike attach-doc-via-MCP, Ziflow Checklist generation
- Stage 11 sign-off: local brain update (canonical), one-way Coda mirror push, Field Notes preserved (read-only), CR move to Archive, 00_Index.md version bump

**Stage-level differentiators (where v2 distinguishes from doc-generation tools):**
- Stage 1: Miro workflow-map ingest via API + swimlane reconstruction (HARD — flagged as needing deeper research before build)
- Stage 4: per-requirement native-AI vs API tagging (HIGHEST LEVERAGE feature in v2)
- Stage 5: risk-multiplier matrix per project with `rationale:` field per row (default L/M/H = 1.1/1.3/1.6 — validate against dYdX historicals before locking)
- Stage 6: per-platform implementation-prompt shape (NOT a universal template — Pipefy ≠ Wrike ≠ Ziflow)
- Stage 7/8d: tier-2 LLM-as-judge for open-ended outcomes; persistent system-state YAML + drift detection (`harness_drift` failure class added); UAT plan auto-generation
- Stage 9: doc-diff side-by-side before publish; deterministic local→Drive mapping
- Stage 10: direct-API ingestion for Pipefy KB (LOW confidence — KB upload endpoint not in public ref; build copy-paste fallback first)
- Stage 11: pre-archive sanity check (no orphan refs, no missing artefacts)

**Per-stage anti-features (must be explicit OUT OF SCOPE in requirements):**
- Stage 1: triggered Miro→BPMN→workflow auto-extraction; re-capturing from raw notes when kickoff exists
- Stage 4: single fnspec for everything (legacy v0.3.0 shape — explicitly retired); AI auto-classifying delivery tags without human review; mixing platform vocabulary with integration vocabulary
- Stage 5: hand-waved error paths
- Stage 6: auto-publish cost estimate without review; flat-rate multiplier across all tasks
- Stage 7b: universal non-dev prompt across platforms (defeats per-platform shape); requesting API access "just in case"; embedded credentials in dev prompt
- Stage 8d: auto-passing tier-2 on retry; AI writing the deterministic Python tests; meta-testing the test harness; production tenant access
- Stage 9: auto-publish without diff; mirroring Drive doc version history outside Drive
- Stage 10: single universal AI-ingestion API abstraction; auto-pushing knowledge without diff; promising direct-API when only paste works
- Stage 11: bidirectional Coda↔local sync; auto-merging Field Notes; pulling Coda-edited brain content back into local

### Architecture Approach

The v2 plugin keeps the validated three-tier marketplace → plugin → skills hierarchy, the stage-gated artefact pipeline, the Cowork/Claude Code seat split, and the sandbox-only test execution model — none of those baseline contracts change. What changes is **structural**: the existing 7 skills get renumbered + repointed at canonical references, 6 new stage skills land, 3 platform skills internalise (today they're referenced but not present), 1 skill retires (single fnspec splits into Platform + Integration), and 4 new plugin surfaces appear (`commands/`, `agents/`, `hooks/`, plugin-level `references/`). The architecture imposes a hard build order — foundations before platform skills before fnspec split before everything else.

**Major components (NEW unless tagged):**

1. **Plugin-level `references/`** (NEW shared SoT) — `safety-rules.md` (canonical, collapses 4 duplicates), `stage-numbering.md` (canonical), `frontmatter-scheme.md` (canonical), `glossary.md`. Skills point at these; never inline.
2. **`skills/` extended 7 → 13** — 6 NEW stage skills + 3 NEW platform skills + 4 MODIFIED + 2 UNCHANGED + 1 RETIRED-AND-REPLACED.
3. **`commands/`** (NEW) — 5 entries: 1 single parameterised `refine.md` (takes skill name as `$1` instead of one-per-skill), plus 4 GSD-prefixed shortcuts (`gsd-test-bot-run`, `gsd-publish-docs`, `gsd-push-native-ai`, `gsd-archive-cr`).
4. **`agents/test-bot-orchestrator/`** (NEW) — exactly one agent. User-facing entry stays the `execute-tests` skill; internally that skill invokes the agent. Agent gets `tools: [Read, Bash, Grep]` only — never Write/Edit. Encapsulates the long-running judgement loop.
5. **`hooks/`** (NEW) — exactly two hooks: `validate-frontmatter` (PostToolUse, parses YAML object never raw markdown), `bump-artefact-version` (PreToolUse, enforces Option B `_v{N+1}.md` naming). NO auto-progression hooks.
6. **Per-client test bot at `<Client> Brain/test-bot/`** (NEW, lives outside this repo) — `client_state.yaml` (sandbox IDs, fixtures, integration toggles, `wrike_host`), `test_runner.py` (deterministic Python tier 1), `test_cases/` (additive, per-CR, never deleted). Bootstrapped once via `provision-test-harness`; updated thereafter via delta against `client_state.yaml`. Tier-1 Python asserts state/schema/equality/regex/retry; tier-2 AI orchestrator interprets free-form output and classifies failures (`spec gap | implementation gap | environment issue | harness_drift | unknown`).
7. **Coda integration surface** (NEW) — two roles: Stage 6 scope/cost task table (read schema → introspect → write rows via `keyColumns` upsert), Stage 11 brain mirror (one-way local→Coda, never read brain content from Coda). Field Notes table is the only read-from-Coda surface; it's a triage queue.
8. **Drive doc surface** (NEW) — Stage 9 publishing target. Local working drafts at `ChangeRequests/<CR>/`; published Docs in Drive with deterministic mapping. `Documentation:` link lives in `<Client> Brain/00_HUB.md` frontmatter.

**Architectural patterns locked by the architecture researcher (pre-decided; requirements step inherits these):**
- Plugin-level canonical reference (single SoT pattern)
- Stage skill as a "pipe stage" (UNCHANGED from v0.3.0)
- Frontmatter-as-contract for stage hand-off
- Highest-version read on upstream artefact
- Agent invoked from skill, never directly by user (NEW v2 pattern)
- Per-client persistent harness with delta-update semantics (NEW v2 pattern)
- Drive-canonical published docs, local-canonical drafts
- One-way local→Coda mirror with Field Notes triage queue
- Schema-mapped Coda task table (introspect → cache in 00_HUB.md → write)

### Critical Pitfalls (top 5 of 32 catalogued — see PITFALLS.md for full list)

1. **Coda async-202 treated as synchronous success** (CRIT-2) — every `POST /rows` returns 202 with a `requestId`. Mark stages "shipped" without polling `GET /mutationStatus/{requestId}` and the Coda mirror silently misses rows. Bake `coda.mutate_and_wait()` helper into platform-coda skill with mandatory poll + explicit timeout. Stage transitions gate on completion, not POST acceptance.
2. **Coda doc-content write rate limit (5 req / 10s per user, across ALL docs)** (CRIT-3) — Stage 6 per-assignee task generation naïve loop hits the ceiling at the 6th write. Must batch via `POST /rows/upsert` with `rows: [...]` array; rate-limit at 4/10s (80% of ceiling); on 429 respect `Retry-After`, abort cleanly after second 429 with partial-state report; idempotent via task ID `keyColumns` so re-runs resume.
3. **Coda token over-scope leak** (CRIT-9) — default Bearer tokens inherit creator's full permissions across every doc the human owns. Plugin must require per-client tokens scoped at creation to the specific docs (cost, brain-mirror, Field Notes); doc IDs come from per-client `<Client> Brain/00_HUB.md` `Coda:` block, never hard-coded; secrets layout `<CLIENT>_CODA_TOKEN` per client.
4. **Frontmatter migration corrupts in-flight client builds** (CRIT-6) — auto-rewriting v0.3.0 frontmatter to v2 canonical can flip `status: client_review` to `approved` without human approval. v2 schema applies only to artefacts created at/after cutover; v2 readers tolerate v0.3.0 via `frontmatter_version` field (absent → "v0.3.0 lenient mode"); migration is opt-in per CR. **Status lifecycle MUST include `client_review`** (in use in `generate-sow` today; do not drop).
5. **Sandbox-only enforcement gap on Coda** (CRIT-5) — `safety-rules.md` rule 1 covers platform tenants but NOT Coda doc IDs. The persistent test harness can write to production Coda docs. Extend allowlist schema to include Coda: `coda: { doc_id, table_ids: [...] }`; harness state lives in local filesystem only; Coda gets a published mirror through the same one-way path as brain spokes.

**Honourable mentions** (covered in PITFALLS.md):
- CRIT-1 Coda formula column overwrite (skill must `GET /columns` first; refuse `calculated:true`)
- CRIT-4 two-way Coda sync re-emerging through Field Notes auto-merge (Field Notes never auto-merged; ingestion emits a kickoff prompt artefact, not a brain edit)
- CRIT-7 test-harness drift between `client_state.yaml` and reality (pre-flight schema diff; `harness_drift` failure class)
- CRIT-8 native-AI knowledge ingestion races doc publishing (Stage 10 reads `doc_published_at`; refuses to ingest if older than `last_diff_review_at` or null)
- CRIT-10 approval-gate bypass through "implementor confidence" (every stage skill ends with explicit handoff naming the approval action; `approved_by:` + `approved_at:` mandatory; hook refuses `status: approved` writes lacking `approved_by:`)
- MOD-2 `/refine-<skill>` orphan references (CONCERNS.md flagged) — v2 must decide build-or-delete; if build, namespace as `/dydx-refine-*` and split for Stage 4 (`/dydx-refine-platform-fnspec` + `/dydx-refine-integration-fnspec`)
- MOD-12 Python-vs-AI orchestrator boundary creep (Python asserts state/schema/equality/regex/retry; AI interprets free-form, classifies failures, suggests remediation; neither overlaps)

---

## Implications for Roadmap

The architecture researcher's Build Order Recommendation maps cleanly onto a 9-phase build plan with one re-ordering: **the connector probe + structural-debt cleanup must run before platform skills**, because platform skills point at canonical references that don't exist yet, and Coda/Drive verification gates whether Stage 5 + Stage 11 + Stage 9 designs are buildable.

### Phase 1 — Foundations & Connector Verification

**Rationale:** Every later phase depends on canonical references existing and being authoritative; renumbering files before adding new skills is cheaper than after. Connector availability gates which Stage 5/9/11 designs ship vs degrade.
**Delivers:** `dydx-delivery/references/{safety-rules.md, stage-numbering.md, frontmatter-scheme.md, glossary.md}`. Existing 7 skills updated to point at canonical references (collapses 4 duplicate copies; fixes sandbox-block bug; normalises `based_on_*` field names; normalises stage labels). File renumbering 00→02 / 01→03 / 02→04 / 03→05 / 04→07a. Empty `commands/`, `agents/`, `hooks/` scaffolded. Plugin manifest version 0.3.0 → 2.0.0; marketplace metadata locked to 2.0.0. Connector probe verifying Coda MCP, Google Workspace MCP, Miro path, Pipefy/Wrike/Ziflow auth + native-AI ingestion paths. Owner-email mismatch (CONCERNS.md MIN-6) corrected.
**Addresses (table-stakes):** stage-numbering canonical scheme, frontmatter canonical scheme, single SoT for hard rules, connector-availability check, version sync.
**Avoids:** CRIT-6 (frontmatter migration), MIN-5 (stage-numbering orphans), MOD-16 (hard-rules duplicate-and-edit), MIN-6 (email mismatch). Establishes graceful-degradation matrix from PITFALLS connector-fallback table.

### Phase 2 — Internalise Platform Skills

**Rationale:** v0.3.0 references `platform-pipefy/wrike/ziflow` but they don't exist in the repo today (CONCERNS.md). Every later phase that loads a platform skill (Stage 4 fnspec split, Stage 5 tech spec, Stage 7b implementation prompt, Stage 8 test bot, Stage 10 native-AI push) inherits the broken contract until these land.
**Delivers:** `skills/platform-pipefy/`, `skills/platform-wrike/`, `skills/platform-ziflow/` — each with `SKILL.md` + `references/{api-contract.md, native-ai-inventory.md, knowledge-ingestion.md, client-shape-gotchas.md, vocabulary.md}`. `tier_claims_last_verified:` frontmatter on each per MOD-7. Per-platform `native_ai_path: api | paste | none` decision frontmatter per STACK.md §4.4.
**Addresses (table-stakes):** internalised platform skills, per-platform native-AI capability matrix.
**Avoids:** MOD-4 Pipefy GraphQL pagination silently truncates (platform-pipefy provides `paginate_all` helper), MOD-5 Wrike OAuth token-host trap (platform-wrike persists `host`), MOD-6 Ziflow eventual consistency (platform-ziflow provides `wait_for_proof` helper), MOD-7 platform-tier capability claims age fast.

### Phase 3 — Stage 1 Kickoff + Stage 4 fnspec Split

**Rationale:** These are the two largest shape-changes to the existing pipeline. Deferring means later phases inherit the broken single-fnspec contract. Stage 4 split is the highest-leverage v2 feature — the `delivery: native-ai|api` tag is the routing key for Stages 5/6/7b/10.
**Delivers:** `kickoff-capture` skill (Stage 1; reads Miro/notes/feedback, branches into discovery or draft SOW); `discovery-intake` MODIFIED to consume `01_kickoff_v*` (Stage 2); `generate-sow` MODIFIED (Stage 3, status lifecycle locked); `generate-fnspec-platform` (Stage 4a, NEW); `generate-fnspec-integration` (Stage 4b, NEW); `generate-functional-spec` retired. Cross-spec consistency check between 4a and 4b. `delivery: native-ai|api` tag carries through all downstream `based_on_*` chains.
**Addresses (table-stakes + DIFFERENTIATOR):** Stage 1 kickoff with dual-branch artefact, Stage 2/3 carry-forward, Stage 4 fnspec split with per-requirement delivery tagging.
**Avoids:** Anti-feature "single fnspec for everything"; AP-6 splitting fnspec along feature lines instead of buildable surfaces; MOD-8 Field Notes pile-up (kickoff filters by `processed_at IS NULL`).

### Phase 4 — Tech Spec Scope Gate, Stage 6 Cost Estimate, Stage 7b Implementation Prompt

**Rationale:** Tech spec scope-gates against fnspec-integration existence; cost estimate adds Coda integration (depends on Phase 1 Coda verification); implementation prompt is a sibling of the existing build prompt. Cannot run before Phase 3 because cost estimate reads fnspecs.
**Delivers:** `generate-technical-spec` MODIFIED (Stage 5, scope-gated; emits platform-API addendum on 4a if no 4b); `generate-cost-estimate` (Stage 6, NEW; reads Coda task-table schema + caches in 00_HUB.md, writes per-assignee rows via `rows/upsert` with `keyColumns`, polls `mutationStatus`); `generate-build-prompt` MODIFIED (Stage 7a); `generate-implementation-prompt` (Stage 7b, NEW; per-platform shape). Risk-multiplier taxonomy locked (1.0/1.2/1.4/1.6/2.0 with `rationale:` field per row).
**Addresses (table-stakes + DIFFERENTIATOR):** scope-gated tech spec, schema-mapped Coda task table, risk-multiplier matrix per project, per-platform implementation-prompt shape, dev/non-dev prompt split.
**Avoids:** CRIT-1 (formula column overwrite — schema-introspect first), CRIT-2 (async-202 — `mutate_and_wait`), CRIT-3 (rate-limit — batch upsert + 4/10s buffer + idempotent retry), CRIT-9 (token scope — per-client tokens + 00_HUB.md doc IDs), MOD-10 (multiplier indefensible — closed taxonomy + rationale).

### Phase 5 — Test Bot Rebuild

**Rationale:** Test bot needs the new fnspec-platform + fnspec-integration to derive cases properly; building before Phase 3 means rebuilding to handle the split. Self-contained otherwise; depends only on `<Client> Brain/test-bot/` shape and existing `execute-tests` safety contract.
**Delivers:** `provision-test-harness` (Stage 8a, NEW; bootstrap once, delta-update thereafter); `generate-test-plan` UNCHANGED body, MODIFIED path (Stage 8b, moves to `<Client> Brain/test-bot/test_cases/`); `generate-uat-plan` (Stage 8c, NEW); `execute-tests` UNCHANGED user-facing (Stage 8d) but internally invokes test-bot agent; `agents/test-bot-orchestrator/` with `references/{safety-rules.md (pointer), orchestrator-loop.md}`. Per-client `client_state.yaml` schema (sandbox IDs, fixtures, integration toggles, `wrike_host`, `last_known_schema`). Sandbox-allowlist extended to Coda. `harness_drift` failure class added. Test-case lifecycle states (`active | obsolete | quarantined`).
**Addresses (table-stakes + DIFFERENTIATOR):** per-client persistent harness, hybrid Python+AI orchestrator, `client_state.yaml` system map, drift detection, UAT plan auto-generation, sandbox-only enforcement carry-forward, bot updates each ship never recreated.
**Avoids:** CRIT-5 (sandbox enforcement gap on Coda), CRIT-7 (harness drift), MOD-11 (stale tests linger), MOD-12 (Python/AI boundary creep — hard contract on layer separation), MOD-13 (concurrency conflict — `sandbox_lock.yaml`), MOD-14 (sandbox cleanup-via-no-deletes — fixture run-ID prefix), AP-3 (recreating test-bot on each ship).

### Phase 6 — Documentation Publishing (Stage 9)

**Rationale:** Drive MCP integration; depends on shipped CRs to diff against and on Phase 1 connector verification.
**Delivers:** `update-documentation` skill (Stage 9, NEW; writes `ChangeRequests/<CR>/doc-diff.md`, requires reviewer approval, publishes via Drive MCP). Naming-scheme normalisation `<client_slug>__<project_slug>__<doc_type>__v<N>` with closed `doc_type` enum. `doc_published_at` timestamp on Drive doc + frontmatter. 00_Index.md canonical in Drive; local snapshot regenerated on push. Halt condition if 00_HUB.md `documentation:` link missing.
**Addresses (table-stakes):** Drive-canonical published docs, local-canonical drafts, doc diff before publish, reviewer-approved push, versioned filename schema, hub link contract halt.
**Avoids:** CRIT-8 (publish/ingest race — `doc_published_at` invariant before Stage 10), MOD-1 (hub-link contract halts unrelated stages — dependency matrix from Phase 1 disambiguates), MOD-15 (naming-scheme drift), MIN-1 (diff rubber-stamp — plain-English summary + targeted question), MIN-2 (Drive permission asymmetry).

### Phase 7 — Native-AI Knowledge Push (Stage 10)

**Rationale:** Per-platform path; depends on platform skills (Phase 2) and approved doc fragments (Phase 6).
**Delivers:** `push-native-ai-knowledge` skill (Stage 10, NEW; reads `04a` + approved doc fragments + `platform-<x>/native-ai-inventory.md`; branches on `native_ai_path: api | paste | none`). Direct API where verified; copy-paste fallback default; `none` skip with explicit note. `doc_version: <semver>` + `ingested_at: <ISO>` per ingested doc. Per-client target ID in 00_HUB.md `Pipefy AI:` / `Wrike AI:` blocks; refuses ingest if target mismatches `client:` frontmatter.
**Addresses (table-stakes + DIFFERENTIATOR):** per-platform ingestion-path reference, copy-paste fallback per platform, Wrike attach-doc-via-MCP, Ziflow Checklist generation, direct-API for Pipefy KB if available.
**Avoids:** MIN-3 (knowledge versioning gap), MIN-4 (multi-tenant knowledge leak), Stage-10 anti-features (universal abstraction, auto-push without diff, promising direct-API when only paste works).

**RESEARCH FLAG — HIGH PRIORITY.** Pipefy AI / Wrike AI / Ziflow native-AI knowledge-base ingestion endpoints could not be externally verified. Phase 7 will need a `/gsd-research-phase` pass to fill in `native_ai_path` per platform before build commits.

### Phase 8 — Sign-off, Brain Update, Archive (Stage 11) + Coda Mirror

**Rationale:** Depends on Coda MCP verification (Phase 1) and stable brain shape; closes the loop because next ship's kickoff reads Field Notes table populated since the last archive.
**Delivers:** `sign-off-and-archive` skill (Stage 11, NEW; updates local `<Client> Brain/<spokes>/`, one-way push to Coda mirror, CR move to `Archive/`, 00_Index.md version bump, Field Notes preserved). Brain-mirror Coda doc template (Overview / Workflows / Platforms / Integrations / Operating Model / Change History / Field Notes table). `tone_lint` pass before publish. Pre-archive sanity check (no orphan refs, no missing artefacts).
**Addresses (table-stakes + DIFFERENTIATOR):** local brain canonical, one-way Coda publish, Field Notes preserved as input-only, CR archive move, pre-archive sanity check.
**Avoids:** CRIT-4 (two-way sync re-emerging through Field Notes), AP-2 (two-way sync), MOD-9 (brain spoke leaks internal-only language to Coda).

### Phase 9 — Surfaces (commands/, agent wrapping, hooks/)

**Rationale:** Quality-of-life on top of fully-shipped skills; building before underlying skills means rewriting as skills shift. Validation/safety hooks fall here because they enforce shapes that only stabilise after Phases 1–8 land.
**Delivers:** `commands/refine.md` (single parameterised command taking skill name as `$1` — avoids 10+ separate files); `commands/{gsd-test-bot-run, gsd-publish-docs, gsd-push-native-ai, gsd-archive-cr}.md`. `hooks/{validate-frontmatter, bump-artefact-version}.md`. Optional `hooks/sandbox_guard.py` PreToolUse hook for `execute-tests` flow. `mcpServers` field in `plugin.json` pointing to `.mcp.json`. Approval-gate hook refusing `status: approved` writes lacking `approved_by:`.
**Addresses (table-stakes):** `/refine-<skill>` family resolved (CONCERNS.md MOD-2), GSD-prefixed shortcuts, frontmatter validation hook, version-bump hook, approval-gate enforcement hook.
**Avoids:** MOD-2 (slash-command name collision — namespace as `/dydx-refine-*` if community Claude installs collide), MOD-3 (hook frontmatter corruption — operates on parsed YAML object, never raw markdown; opt-in per skill until validated; smoke test in harness). Anti-pattern of auto-progression hooks (excluded explicitly from scope).

### Phase Ordering Rationale

- **Phase 1 before Phase 2** because platform skills also point at canonical references; landing Phase 2 first leaves dangling pointers.
- **Phase 2 before Phases 3, 4, 5, 7** because all four phases load platform skills.
- **Phase 3 before Phase 4** because tech spec reads fnspec-integration; cost estimate reads both fnspecs.
- **Phase 3 before Phase 5** because test bot derives cases from fnspecs.
- **Phase 6 before Phase 7** because Stage 10 ingests approved doc fragments from Stage 9.
- **Phase 8 last among stage-skill phases** because it depends on Coda MCP verification AND stable brain shape AND closes the loop with Field Notes for next ship's Phase 3 kickoff.
- **Phase 9 last overall** because surfaces wrap stable underlying behaviour; building hooks before skills means hooks chase a moving target.

### Research Flags

Phases likely needing deeper research during planning (suggest `/gsd-research-phase` pass):

- **Phase 1:** Connector availability per tenant — Coda MCP version pin, Google Workspace MCP choice (`taylorwilsdon` vs alternatives), Miro MCP existence in team's Cowork seat, Wrike rate-limit currency, Ziflow auth header + base URL. Fast verification — install + capture.
- **Phase 2:** Pipefy GraphQL pagination cursor field names; Pipefy/Wrike/Ziflow tier-feature gating currency; Ziflow read-after-create consistency window. Vendor-doc verification.
- **Phase 3:** Miro structured ingest semantics — connector/frame metadata reliability for clean BPMN extraction (FEATURES.md flags this; ARCHITECTURE.md doesn't have a verified path). DEEPER research warranted before Stage 1 build.
- **Phase 5:** `harness_drift` detection algorithm specifics — what exactly to diff in `last_known_schema` per platform. Design pattern; not blocked by external research.
- **Phase 7 (HIGH PRIORITY):** Pipefy AI Agents KB content-upload endpoint, Wrike AI Studio knowledge-ingestion API, Ziflow ReviewAI knowledge-ingestion API. **Single biggest "unknown" in v2.** All three may not exist as documented APIs — design assumes copy-paste fallback as default and flips to direct-API where verified. Vendor-doc deep-dive + sandbox testing.

Phases with standard patterns (skip dedicated research-phase):

- **Phase 4** (tech spec scope-gate, cost estimate Coda integration, implementation prompt) — Coda API HIGH-confidence in research; per-platform implementation-prompt shapes documented in FEATURES.md from vendor verification.
- **Phase 6** (documentation publishing) — diff-and-review pattern industry-standard; Drive MCP behaviour stable; naming-scheme is design decision not research.
- **Phase 8** (sign-off + Coda mirror) — Coda one-way mirror pattern + Field Notes triage queue fully designed in ARCHITECTURE.md Pattern 8; Coda API verified HIGH.
- **Phase 9** (surfaces) — Claude Code plugin spec verified HIGH for `commands/`/`agents/`/`hooks/`; design moves all decided.

---

## Confidence Assessment

| Area | Confidence | Notes |
|------|------------|-------|
| Stack | MEDIUM-HIGH | Plugin spec, Coda API, Wrike OAuth model, Python deps verified HIGH via Context7. MCP availability per tenant MEDIUM-LOW (must install + verify). Native-AI ingestion APIs LOW (couldn't verify externally). Patch-version pinning MEDIUM (verify on PyPI before pyproject.toml commits). |
| Features | MEDIUM-HIGH | Vendor surfaces (Pipefy AI Agents, Wrike MCP, Coda API, Ziflow ReviewAI) verified 2026-05-09. Miro structured-ingest semantics MEDIUM. Risk-multiplier numerics LOW. |
| Architecture | HIGH | Builds on validated v0.3.0 baseline; researcher had full required-reading access; every NEW/MODIFIED/RETIRED change tagged against existing repo files; no fabricated layout. |
| Pitfalls | HIGH on Coda + Wrike (Context7-verified) and in-repo behavioural pitfalls (CONCERNS.md HIGH). MEDIUM on Pipefy/Ziflow specifics (couldn't verify externally). MEDIUM on cross-cutting risks (logical inference). |

**Overall confidence:** MEDIUM-HIGH. The architecture is fully designed; the stack and pitfalls are well-grounded for the verified components. The two confidence holes are (a) native-AI ingestion paths per platform (Phase 7 research flag) and (b) MCP availability in the team's tenant (Phase 1 connector probe).

### Gaps to Address During Requirements / Planning

1. **Native-AI ingestion paths per platform** — Pipefy AI / Wrike AI / Ziflow ReviewAI knowledge-base APIs could not be externally verified. Requirements must lock the design contract: `native_ai_path: api | paste | none` in platform-skill frontmatter; copy-paste is the default; direct-API fills in during Phase 7 platform-skill build with vendor-doc verification.
2. **Connector availability in team tenant** — Coda MCP / Google Workspace MCP / Miro MCP availability not verified. Phase 1 must include a connector probe + graceful-degradation matrix per the PITFALLS connector-fallback table. Requirements must commit to "design fails gracefully if connector missing" not "design assumes connector exists."
3. **Coda doc IDs sourcing contract** — must come from `<Client> Brain/00_HUB.md` per-client config; never hard-coded in skills or build prompts. Requirements must lock 00_HUB.md frontmatter schema for Coda blocks (`coda_brain_doc`, `coda_tasks_table`, `coda_tasks_schema` cache).
4. **`/refine-<skill>` build-or-delete decision** — CONCERNS.md flags 3 orphan references in v0.3.0 docs. Requirements must commit either (a) ship `commands/refine.md` parameterised by skill name in Phase 9, OR (b) delete the 3 references during Phase 1 cleanup. Architecture researcher recommends (a) with single parameterised command.
5. **Plugin self-test scope** — PROJECT.md notes no traditional automated test suite for the plugin itself. Requirements must decide: (a) add `pytest` smoke tests for hooks + frontmatter validation only (recommended — covers the load-bearing failure modes from MOD-3), or (b) defer; v2 ships without plugin self-tests.
6. **Risk-multiplier defaults** — proposed L=1.1 / M=1.3 / H=1.6 from training-data services-firm patterns. FEATURES.md flags LOW confidence. Requirements should validate against dYdX historical project data before locking the closed taxonomy in MOD-10 prevention.
7. **Frontmatter migration co-existence rules** — v2 readers must tolerate v0.3.0 frontmatter via `frontmatter_version` field; migration is opt-in per CR; in-flight `client_review` artefacts must NOT auto-flip to `approved`. Requirements must lock the lenient-mode rules and the `frontmatter_version` field semantics.
8. **Status lifecycle — `client_review` MUST be retained.** Already in use in `generate-sow`. Requirements lock canonical lifecycle as `draft → client_review → approved → archived`. Adding `archived` is the only v2 change.

### Locked Decisions (carry into requirements as hard constraints, not open questions)

These are pre-decided by the architecture researcher with high confidence and should land in REQUIREMENTS.md as constraints, not as open issues:

- **Frontmatter scheme:** field names underscore-snake-case; file paths hyphen-kebab-case; status lifecycle `draft → client_review → approved → archived`; platform-gated `pipe_id`/`space_id`/`project_id` (only present when their platform is active); `frontmatter_version: 2` on new artefacts; absent → v0.3.0 lenient mode.
- **Stage-numbering scheme:** file-prefix IS the stage number (`01_kickoff_` through `11_…`); substages `4a/4b/7a/7b/8a/8b/8c/8d`; canonical at `dydx-delivery/references/stage-numbering.md`; templates put `> Stage N of the dydx-delivery pipeline.` at body top; readers tolerate v0.3.0 numbering during migration.
- **Single SoT for hard rules:** `dydx-delivery/references/safety-rules.md` is canonical; collapses 4 v0.3.0 duplicates; skills inline a one-line summary plus pointer; per-client overrides via `<Client> Brain/safety-overrides.yaml` (only fields marked `overridable: true` in schema).
- **Plugin surfaces:** `commands/` (5 entries), `agents/` (1 — test-bot-orchestrator), `hooks/` (2 — validation + version-bump, NOT auto-progression), `mcpServers` field pointing to `.mcp.json`. Versions `2.0.0` synced across plugin.json + marketplace.json metadata + plugins[0].
- **Test bot architecture:** Python tier-1 deterministic + AI tier-2 judgement; layers don't overlap; harness lives at `<Client> Brain/test-bot/` (outside this repo); update-only after bootstrap; `client_state.yaml` is the persistent state map; `harness_drift` is a first-class failure class; sandbox-allowlist extended to Coda.
- **Connector contracts:** Coda direct API for Stage 6 + Stage 11 (not MCP — rate-limit + idempotency control); Google Workspace unified MCP; Miro `miro-api` Python client + paste fallback (no canonical MCP found); per-client tokens scoped at creation; doc IDs sourced from per-client 00_HUB.md never hard-coded.
- **Directional boundary:** local `<Client> Brain/` is canonical; Coda is one-way published mirror; Field Notes table is read-only triage queue; never auto-merged into brain. Reviewer Coda edits must be pasted into local files.

---

## Sources

### Primary (HIGH confidence)

- Context7 `/anthropics/claude-code` — plugin manifest spec, `commands/`, `agents/`, `hooks/`, `mcpServers` field; frontmatter formats for command/agent/hook
- Context7 `/websites/coda_io_apis_v1` — Coda REST API v1 base URL, Bearer auth, rate limits (read 100/6s, write 10/6s, doc-content writes 5/10s, list-docs 4/6s), `keyColumns` upsert, `mutationStatus` polling, `calculated:true` formula columns, token scope semantics
- Context7 `/websites/developers_wrike` — Wrike REST API base URL pattern (`https://<host>/api/v4`), Bearer + OAuth 2.0 auth, dynamic `host` field per-account
- Context7 `/yaml/pyyaml` — `safe_load` / `safe_dump` contract, `yaml.load()` without Loader is forbidden
- Context7 `/pytest-dev/pytest` — pytest 9.0.0 current major
- `.planning/PROJECT.md` — v2.0 milestone scope, Constraints (one-way Coda; approval gates; sandbox-only; hybrid harness; status lifecycle; hub link contract), Out of Scope (two-way sync, auto-progression, runtime change, custom MCPs)
- `.planning/codebase/CONCERNS.md` — version mismatches, missing platform skills, orphan `/refine-<skill>` references, stage-numbering inconsistencies, frontmatter inconsistencies, hard-rules duplication, missing `commands/agents/hooks` scaffold, email mismatch
- `.planning/codebase/ARCHITECTURE.md` (v0.3.0 audit) — system overview, component responsibilities, patterns, data flow, anti-patterns
- `dydx-delivery/skills/execute-tests/references/safety-rules.md` — sandbox-only enforcement contract, deletion bans, audit-trail format, rate limiting, stop conditions, sequential-only concurrency, no-cleanup rule
- `dydx-delivery/skills/{discovery-intake,generate-functional-spec,generate-build-prompt,generate-test-plan,execute-tests}/SKILL.md` — current skill bodies and contracts

### Secondary (MEDIUM confidence — community sources or unverified versions)

- Context7 `/dustinrgood/coda-mcp` — community Coda MCP tool surface (`coda_list_rows`, `coda_get_row`, `coda_update_row`, `coda_bulk_update_rows`)
- Context7 `/taylorwilsdon/google_workspace_mcp` — unified Drive+Gmail+Calendar+Docs+Slides MCP; auth via `GOOGLE_OAUTH_CLIENT_ID`/`GOOGLE_OAUTH_CLIENT_SECRET`; runs via `uvx workspace-mcp`
- Context7 `/shinzo-labs/gmail-mcp` — Gmail-only fallback MCP; OAuth via `~/.gmail-mcp/gcp-oauth.keys.json`
- Context7 `/miroapp/api-clients` — `miro-api` Python client (MIT, official Miro org); reads `MIRO_CLIENT_ID`/`MIRO_CLIENT_SECRET`/`MIRO_REDIRECT_URL`
- Context7 `/websites/developers_miro` — Miro REST API v2 endpoints (`POST /v2/boards/{board-id}/images`, `GET /v2/boards/{board_id}/items`)
- Context7 `/graphql-python/gql` — Pipefy GraphQL client recommendation (3.5.x stable; 4.x pre-release)
- Context7 `/encode/httpx` — async HTTP client (3.9+); recommend 0.28.x
- Context7 `/psf/requests` — `requests` 2.32.x stable
- Pipefy Help Center / Pipefy Developers GraphQL reference — Agent CRUD verified; KB content-upload endpoint NOT visible
- Wrike MCP server documentation — 16 tools (task/folder/project CRUD, search, custom fields, workflows, contacts, approvals)
- Ziflow ReviewAI page — Checklists Public Preview; Change Verification + Brand Standards "Coming Soon"
- Evidently AI / promptfoo / LangChain — two-tier (Python deterministic + LLM-as-judge) industry-converged pattern

### Tertiary (LOW confidence — unverified, flag for design-phase verification)

- Pipefy AI Agents knowledge-base content-upload endpoint (Phase 7 research blocker)
- Wrike AI Studio knowledge-ingestion API (Phase 7 research blocker)
- Ziflow ReviewAI knowledge-ingestion API (Phase 7 research blocker)
- Pipefy GraphQL endpoint URL `https://api.pipefy.com/graphql` (training-data only; verify in Phase 1)
- Pipefy 2026 rate limits (training-data only; verify in Phase 1)
- Wrike 2026 rate limits (200 req/min from v0.3.0 safety-rules.md, not re-verified; verify in Phase 1)
- Ziflow auth header name + base URL (`technical-spec-template.md` line 113 only; verify in Phase 1)
- Pipefy GraphQL pagination cursor field names (universal pitfall category HIGH; Pipefy specifics LOW)
- Ziflow read-after-create consistency window (universal pitfall category HIGH; Ziflow specifics LOW)
- Risk-multiplier defaults L=1.1 / M=1.3 / H=1.6 (training-data services-firm patterns; validate against dYdX historicals)
- Miro export-whole-board-to-image endpoint — assume NOT AVAILABLE until tenant confirmed
- Coda doc-content endpoint enumeration bound to 5/10s ceiling — Context7 confirms category not exact endpoint list; treat all `POST/PUT/PATCH` to `/docs/{docId}/...` as bound to tighter limit
- Claude in Chrome canonical product naming + entrypoint in 2026
- Latest patch versions for `gql`, `requests`, `httpx`, `pytest`, `PyYAML` (verify on PyPI before pyproject.toml commit)

---

*Research completed: 2026-05-09. Ready for roadmap: yes — 9-phase build plan derived; 2 phases (1, 7) flagged for `/gsd-research-phase`; locked decisions enumerated for direct REQUIREMENTS.md import; 8 gaps for requirements step to address.*