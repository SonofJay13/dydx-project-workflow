# Roadmap: dydx-delivery v2.0 — Implementor Edition

## Overview

This is a **design-only** milestone. The deliverables are four markdown documents under `.planning/` — `AUDIT.md`, `DESIGN.md`, `CHANGELIST.md`, `OPEN-QUESTIONS.md` — that together lock the v2 architecture for the dydx-delivery plugin so the v2.1+ rebuild can execute without rework. No skill files are edited in this milestone (kickoff explicitly forbids it). The roadmap follows a **deliverable-shaped** structure: one phase per output document, sequenced so each rests on the previous (audit grounds design; design sequences the change list; change list scopes the open-questions register).

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3, 4): Planned milestone work
- Decimal phases (e.g., 2.1): Urgent insertions only — none expected in a design-only milestone
- All phases gated by human approval of the deliverable file before the next phase runs

- [x] **Phase 1: Audit** — Catalogue v0.3.0 plugin reality so v2 design rests on observation, not memory; output `.planning/AUDIT.md` ✓ APPROVED 2026-05-09
- [ ] **Phase 2: Design** — Lock v2 architecture across cross-cutting structure, 13-skill inventory, platform skills, every stage skill, and test bot; output `.planning/DESIGN.md`
- [ ] **Phase 3: Change list** — Sequence the v0.3.0 → v2 delta as the v2.1+ build plan with per-skill delta and cosmetic-fix list; output `.planning/CHANGELIST.md`
- [ ] **Phase 4: Open questions register** — Catalogue every "couldn't verify" + design-decision-deferred item, assign owner / phase; output `.planning/OPEN-QUESTIONS.md`

## Phase Details

### Phase 1: Audit
**Goal**: Produce `.planning/AUDIT.md` — a complete, citation-grounded inventory of the v0.3.0 plugin (skills, connectors, missing artefacts, duplicated content, version mismatches, cosmetic issues, live MCP wiring) so every later v2 design move rests on accurate observation rather than memory.
**Depends on**: Nothing (first phase)
**Requirements**: AUDIT-01, AUDIT-02, AUDIT-03, AUDIT-04, AUDIT-05, AUDIT-06, AUDIT-07, AUDIT-08
**Output deliverable**: `.planning/AUDIT.md`
**Success Criteria** (what must be TRUE when this phase completes):
  1. `AUDIT.md` exists at `.planning/AUDIT.md` and catalogues every v0.3.0 skill (`discovery-intake`, `generate-sow`, `generate-functional-spec`, `generate-technical-spec`, `generate-test-plan`, `generate-build-prompt`, `execute-tests`) with purpose, inputs, outputs, hand-off contract, dependencies, observed brittleness, and what's missing for v2 — readable as a self-contained reference without consulting the v0.3.0 source files.
  2. `AUDIT.md` is a verified superset of `.planning/codebase/CONCERNS.md` (every existing entry absorbed) and adds any new structural issues found during the audit pass; auditor confirms in the document that no CONCERNS.md entry was dropped silently.
  3. `AUDIT.md` contains a per-stage connector dependency table (Miro, Coda, Drive, Gmail, Calendar, Claude in Chrome, Pipefy/Wrike/Ziflow APIs) marking each connector *required* vs *graceful-degradation* per stage, AND a live-wiring probe table recording present-and-working / present-but-broken / missing for each MCP in this workspace with version pins where present.
  4. `AUDIT.md` catalogues every referenced-but-missing artefact (`platform-pipefy`/`platform-wrike` skills, `/refine-<skill>` slash commands, workspace `hub.md`, client-folder `.env.example`) with exact citations from v0.3.0 docs, AND every duplicated content block (hard-rules across 4 files; pipeline diagram across 3 files; start-at-any-point block across 6 SKILL.md files; Cowork-vs-Claude-Code positioning across 3 files) with a canonical-source recommendation per duplicate.
  5. `AUDIT.md` lists every version-string mismatch across `plugin.json`, `marketplace.json`, root README, plugin README and hardcoded version strings (recommending `2.0.0` as the synced target) AND flags every cosmetic-but-client-visible issue (README truncation, residual "test sheet" wording, missing `LICENSE`, owner-email mismatch) with each cosmetic fix scheduled for v2.1 build, NOT this design milestone.
**Approval gate**: Human reviews `.planning/AUDIT.md` and approves before Phase 2 begins. Approval signal = explicit go-ahead from the user. Rationale: design rests on accurate audit (CRIT-6 frontmatter migration risk requires surveying live `status:` values before locking canonical lifecycle).
**Plans:** 9 plans
Plans:
**Wave 1**
- [x] 01-01-PLAN.md — Wave 1 scaffold: structural-check script + AUDIT.md skeleton with all 8 H2 anchors *(complete 2026-05-09; SUMMARY at `.planning/phases/01-audit/01-01-SUMMARY.md`)*

**Wave 2** *(complete)*
- [x] 01-02-PLAN.md — AUDIT-01: 7-row skill matrix + 7 prose subsections (per-skill brittleness + DESIGN-* closures) *(complete 2026-05-09; SUMMARY at `.planning/phases/01-audit/01-02-SUMMARY.md`)*

**Wave 3** *(complete)*
- [x] 01-03-PLAN.md — AUDIT-03: per-stage × per-connector dependency table + PITFALLS-cited fallback hint with DESIGN-07 pointer *(complete 2026-05-09; SUMMARY at `.planning/phases/01-audit/01-03-SUMMARY.md`)*

**Wave 4** *(complete)*
- [x] 01-04-PLAN.md — AUDIT-04: 5 missing-artefact subsections + 1 verified-clean negative-finding subsection *(complete 2026-05-09; SUMMARY at `.planning/phases/01-audit/01-04-SUMMARY.md`)*

**Wave 5** *(complete)*
- [x] 01-05-PLAN.md — AUDIT-05: 4 confirmed duplicate-content subsections + 1 [NEW] Stage-N label collision *(complete 2026-05-09; SUMMARY at `.planning/phases/01-audit/01-05-SUMMARY.md`)*

**Wave 6** *(complete)*
- [x] 01-06-PLAN.md — AUDIT-06: 8-row version-mismatch table + 2.0.0 synced-target recommendation (D-17) *(complete 2026-05-09; SUMMARY at `.planning/phases/01-audit/01-06-SUMMARY.md`)*

**Wave 7** *(complete)*
- [x] 01-07-PLAN.md — AUDIT-07: 6 cosmetic-fix subsections, each with per-bullet "scheduled for v2.1 build, NOT this milestone" (D-16) *(complete 2026-05-09; SUMMARY at `.planning/phases/01-audit/01-07-SUMMARY.md`)*

**Wave 8** *(complete)*
- [x] 01-08-PLAN.md — AUDIT-08: live MCP probe table (5 wired + Slack [NEW] + 4 deferred) with probe-time timestamp *(complete 2026-05-09; SUMMARY at `.planning/phases/01-audit/01-08-SUMMARY.md`)*

**Wave 9** *(complete)*
- [x] 01-09-PLAN.md — Synthesis: AUDIT-02 absorption claim + Appendix A glossary + Appendix B trace + executive summary + preamble + reviewer coverage doc; structural-check exits 0 (all 8 assertions pass) *(complete 2026-05-09; SUMMARY at `.planning/phases/01-audit/01-09-SUMMARY.md`)*

### Phase 2: Design
**Goal**: Produce `.planning/DESIGN.md` — the locked v2 architecture covering cross-cutting structural decisions (frontmatter, stage numbering, hard-rules SoT, plugin surfaces, refine pattern, approval gates, connector probe, migration co-existence, directional boundary, persona); the v2 folder layout + 13-skill inventory + per-stage hand-off contracts; the three internalised platform skills (`platform-pipefy`/`-wrike`/`-ziflow`); every stage skill design (Stage 1 Kickoff, Stage 2 Discovery, Stage 3 SOW, Stage 4a/4b Fnspec split, Stage 5 Tech spec, Stage 6 Cost estimate, Stage 7a/7b Build prompts, Stage 8a-8d Test bot, Stage 9 Documentation, Stage 10 Native-AI, Stage 11 Sign-off); and the test bot architecture (Python↔AI orchestrator boundary, `client_state.yaml` schema, drift-detection algorithm).
**Depends on**: Phase 1 (Audit must be approved — design rests on accurate inventory of live `status:` values, connector wiring, and structural debt; lockable canonical lifecycle and migration co-existence rules cannot be drafted before audit verifies what's in flight).
**Requirements**: DESIGN-01, DESIGN-02, DESIGN-03, DESIGN-04, DESIGN-05, DESIGN-06, DESIGN-07, DESIGN-08, DESIGN-09, DESIGN-10, DESIGN-11, DESIGN-12, DESIGN-13, DESIGN-14, DESIGN-15, DESIGN-16, DESIGN-17, DESIGN-18, DESIGN-19, DESIGN-20, DESIGN-21, DESIGN-22, DESIGN-23, DESIGN-24, DESIGN-25, DESIGN-26, DESIGN-27, DESIGN-28, DESIGN-29, DESIGN-30
**Output deliverable**: `.planning/DESIGN.md`
**Success Criteria** (what must be TRUE when this phase completes):
  1. `DESIGN.md` locks all 10 cross-cutting structural decisions as concrete contracts (not aspirations): canonical frontmatter scheme with `frontmatter_version: 2` semantics + lenient mode for absent field; canonical stage-numbering with substages `4a/4b/7a/7b/8a-8d` and old→new mapping table; single SoT for hard rules at `dydx-delivery/references/safety-rules.md` plus per-client `safety-overrides.yaml` overlay (only `overridable: true` fields); plugin surfaces (`commands/`: 1 parameterised `refine.md` + 4 GSD shortcuts; `agents/`: 1 test-bot-orchestrator; `hooks/`: 2 — `validate-frontmatter` + `bump-artefact-version`, NOT auto-progression; `mcpServers` field; manifest `2.0.0` synced); `/refine-<skill>` resolution; approval-gate enforcement (mandatory `approved_by` + `approved_at` on `status: approved` writes, refused by hook otherwise); connector-availability probe + per-stage graceful-degradation matrix; frontmatter migration co-existence (`client_review` retained — it's live in `generate-sow`); directional boundary (local→Coda one-way; Field Notes never auto-merged); persona contract.
  2. `DESIGN.md` presents the v2 folder layout (`skills/`, `commands/`, `agents/`, `hooks/`, `.claude-plugin/`, plugin-level `references/`) AND the 13-skill inventory (6 NEW stage skills + 3 NEW platform skills + 4 MODIFIED + 2 UNCHANGED + 1 RETIRED-AND-REPLACED) with each skill carrying purpose, inputs (frontmatter + upstream artefact), outputs, downstream consumer, complexity tag, dependencies, hand-off message shape; AND the stage-by-stage hand-off contract — every transition naming the carrier file path, propagated frontmatter fields, and gating status flag.
  3. `DESIGN.md` specifies all three internalised platform skills (`platform-pipefy/`, `platform-wrike/`, `platform-ziflow/`) with identical 5-file `references/` shape (`api-contract.md`, `native-ai-inventory.md`, `knowledge-ingestion.md`, `client-shape-gotchas.md`, `vocabulary.md`); each carries a 2026-grounded native-AI capability matrix (Pipefy AI Agents: KB + Skills + MCP + IDP + Web Search + BYO-LLM; Wrike Copilot + 16 MCP tools; Ziflow ReviewAI Checklists Public Preview), API surface for the gap including platform-specific helpers (Pipefy `paginate_all`; Wrike `host` field from OAuth token persisted; Ziflow `wait_for_proof`); `native_ai_path: api | paste | none` flag with confidence; `tier_claims_last_verified` frontmatter.
  4. `DESIGN.md` specifies every stage skill end-to-end with concrete contracts — Stage 1 Kickoff dual-branch + Field Notes triage filter (`processed_at IS NULL`); Stage 2 Discovery refactor consuming `01_kickoff_v*` (skips raw-notes mode + skips entire stage if kickoff produced draft SOW); Stage 3 SOW single-spec covering platform AND integration; Stage 4 Fnspec split with per-requirement `delivery: native-ai | api` tagging (the routing key for Stages 5/6/7b/10) and cross-spec consistency check; Stage 5 Tech spec scope-gated to 4b existence with platform-API addendum on 4a; **Stage 6 Cost estimate naming the Coda integration mechanics concretely — `keyColumns` upsert for idempotency, `mutationStatus` polling, schema-introspection cached in `00_HUB.md`, closed risk-multiplier taxonomy (default L=1.1 / M=1.3 / H=1.6 — flagged for dYdX-historical validation) with mandatory `rationale` field per row, rate-limit at 4 req/10s (80% of 5/10s ceiling), wait-for-commercial-inputs gate before client-facing summary**; Stage 7a dev prompt + Stage 7b per-platform implementation prompt (Pipefy = Behaviors instructions + KB upload list; Wrike = Copilot workflow narrative; Ziflow = checklist/criteria spec — NOT a universal template); Stage 9 doc-diff before publish + closed `doc_type` enum + naming `<client_slug>__<project_slug>__<doc_type>__v<N>` with double-underscore separator + `doc_published_at` invariant; Stage 10 native-AI push reading `04a` + Stage 9 fragments + per-platform `native-ai-inventory.md`, refusing ingest if `doc_published_at < last_diff_review_at` (CRIT-8) or target ID mismatches `client:` frontmatter (MIN-4); Stage 11 sign-off with one-way Coda mirror + `tone_lint` pass + Field Notes preserved (input-only).
  5. `DESIGN.md` specifies the test bot architecture in full — `provision-test-harness` (8a) bootstraps once + delta-updates each ship; persistent harness lives at `<Client> Brain/test-bot/{client_state.yaml, test_runner.py, test_cases/}` (outside this repo); tier-1 deterministic Python (state/schema/equality/regex/retry/status-code class) + tier-2 AI orchestrator (free-form output, failure classification, remediation suggestion) with hard layer-separation contract (Python tests are human-authored, not AI-generated; AI does not write tier-1); `harness_drift` failure class added to `spec gap | implementation gap | environment issue | unknown`; `sandbox_lock.yaml` for concurrency; sandbox allowlist extended to Coda (CRIT-5 fix); test-case lifecycle states `active | obsolete | quarantined`; `client_state.yaml` schema (sandbox tenant IDs gated by platform, fixtures, integration toggles, `wrike_host`, `last_known_schema` per platform, `last_passed_at` per test case, `targets_artefact` per test case for obsolescence detection); drift-detection algorithm (pre-flight fetches current sandbox schema, diffs against `last_known_schema`, mismatch halts + emits `schema_drift_report.md` instead of executing, drift requires explicit human acknowledge-or-revert).
**Approval gate**: Human reviews `.planning/DESIGN.md` and approves before Phase 3 begins. Approval signal = explicit go-ahead from the user. Rationale: change list sequences against the locked design — sequencing before architecture is locked re-orders work that doesn't exist yet.
**Plans:** 10 plans
Plans:

**Wave 1**
- [x] 02-01-PLAN.md — Wave 1 scaffold: design-structure-check.sh + DESIGN.md skeleton with all required H2/H3 anchors + seed [OPEN] marker *(complete 2026-05-09; SUMMARY at `.planning/phases/02-design/02-01-SUMMARY.md`)*

**Wave 2** *(complete)*
- [x] 02-02-PLAN.md — Cross-cutting decisions (DESIGN-01..10) + status-lifecycle survey (D-25) + Appendix C persona examples *(complete 2026-05-09; SUMMARY at `.planning/phases/02-design/02-02-SUMMARY.md`)*

**Wave 3** *(complete)*
- [x] 02-03-PLAN.md — Skill layout (DESIGN-11) + v2 skill inventory (DESIGN-12; H2 anchor renamed from `13-skill inventory` per cross-AI MEDIUM #4) + Stage-by-stage hand-off matrix (DESIGN-13 / D-26; 12 transition rows) *(complete 2026-05-09; SUMMARY at `.planning/phases/02-design/02-03-SUMMARY.md`)*

**Wave 4**
- [x] 02-04-PLAN.md — Platform skills: platform-pipefy / -wrike / -ziflow (DESIGN-14, 15, 16) + per-platform [OPEN] markers *(complete 2026-05-09; SUMMARY at `.planning/phases/02-design/02-04-SUMMARY.md`)*

**Wave 5**
- [x] 02-05-PLAN.md — Stages 1-3 skills (DESIGN-17 Kickoff dual-branch + DESIGN-18 Discovery refactor + DESIGN-19 SOW refactor) *(complete 2026-05-09; SUMMARY at `.planning/phases/02-design/02-05-SUMMARY.md`)*

**Wave 6**
- [x] 02-06-PLAN.md — Stages 4a/4b/5 skills (DESIGN-20 Fnspec split + delivery routing key + cross-spec consistency check + DESIGN-21 Tech spec scope gate) *(complete 2026-05-09; SUMMARY at `.planning/phases/02-design/02-06-SUMMARY.md`)*

**Wave 7**
- [x] 02-07-PLAN.md — Stages 6/7a/7b skills (DESIGN-22 Cost estimate Coda mechanics + risk-multiplier structure + DESIGN-23 dual build prompts) *(complete 2026-05-09; SUMMARY at `.planning/phases/02-design/02-07-SUMMARY.md`)*

**Wave 8**
- [x] 02-08-PLAN.md — Stages 8 overview/9/10/11 skills (DESIGN-24/25/26/27 — closed doc_type enum + native_ai_path branching + brain-mirror template) *(complete 2026-05-09; SUMMARY at `.planning/phases/02-design/02-08-SUMMARY.md`)*

**Wave 9** *(complete)*
- [x] 02-09-PLAN.md — Test bot architecture: tier boundary (DESIGN-28) + client_state.yaml skeleton (DESIGN-29) + drift-detection contract (DESIGN-30) *(complete 2026-05-09; SUMMARY at `.planning/phases/02-design/02-09-SUMMARY.md`)*

**Wave 10**
- [ ] 02-10-PLAN.md — Synthesis: preamble + Executive Summary + Appendix A glossary + Appendix B 30-row DESIGN-* traceability + finalised closed [OPEN] list

### Phase 3: Change list
**Goal**: Produce `.planning/CHANGELIST.md` — the sequenced, justified delta from v0.3.0 to v2 that commits the SUMMARY.md 9-phase build plan as the authoritative v2.x milestone sequence, names per-skill NEW/MODIFIED/RETIRED/UNCHANGED tagging, schedules cosmetic fixes for v2.1 build (NOT this milestone), flags research-blocked phases (Phase 1 connector probe; Phase 7 native-AI ingestion paths), and locks migration cutover rules so v0.3.0 artefacts in flight don't get auto-corrupted.
**Depends on**: Phase 2 (Design must be approved — change list sequences against the locked architecture; per-skill NEW/MODIFIED/RETIRED tagging requires the v2 13-skill inventory from DESIGN-12 to exist).
**Requirements**: CHANGE-01, CHANGE-02, CHANGE-03, CHANGE-04, CHANGE-05
**Output deliverable**: `.planning/CHANGELIST.md`
**Success Criteria** (what must be TRUE when this phase completes):
  1. `CHANGELIST.md` presents the 9-phase build plan from `.planning/research/SUMMARY.md` (Foundations + Connector Verification → Internalise Platform Skills → Stage 1 + Stage 4 Split → Tech spec + Cost + Implementation prompt → Test bot rebuild → Documentation publishing → Native-AI knowledge push → Sign-off + Coda mirror → Surfaces) committed as the v2.x milestone sequence, with rationale per ordering, mapped to milestones (v2.1 = Foundations + Platform skills; v2.2 = Stage 1 + Stage 4 split; etc. — pending the user's milestone-sizing call). Each phase carries: deliverables, dependencies, addresses-which-requirements (REQ-IDs from FOUND-/PLAT-/STG*-/SURF- families), avoids-which-pitfalls (CRIT-/MOD-/MIN- IDs from PITFALLS).
  2. `CHANGELIST.md` presents the per-skill delta — every existing v0.3.0 skill (`discovery-intake`, `generate-sow`, `generate-functional-spec`, `generate-technical-spec`, `generate-test-plan`, `generate-build-prompt`, `execute-tests`) tagged NEW / MODIFIED / RETIRED / UNCHANGED with the change description; every NEW v2 skill (`kickoff-capture`, `generate-fnspec-platform`, `generate-fnspec-integration`, `generate-cost-estimate`, `generate-implementation-prompt`, `provision-test-harness`, `generate-uat-plan`, `update-documentation`, `push-native-ai-knowledge`, `sign-off-and-archive`) tagged with its introducing phase number from the 9-phase plan; every NEW platform skill (`platform-pipefy`, `platform-wrike`, `platform-ziflow`) tagged.
  3. `CHANGELIST.md` presents the cosmetic-fix list (version-string mismatches across plugin.json/marketplace.json/READMEs, README truncation, residual "test sheet" wording, missing `LICENSE` file, owner-email mismatch with stated org) explicitly scheduled for the Phase 1 Foundations build (v2.1) and explicitly OUT OF SCOPE for this design milestone.
  4. `CHANGELIST.md` flags the research-blocked phases — Phase 1 (connector availability per tenant: Coda MCP version pin, Google Workspace MCP choice, Miro MCP existence, Wrike rate-limit currency, Ziflow auth header) and Phase 7 (native-AI ingestion paths per platform — single biggest unknown: Pipefy AI KB content-upload, Wrike AI Studio knowledge-ingestion, Ziflow ReviewAI knowledge-ingestion) — recommending `/gsd-research-phase` passes before those phases lock plans.
  5. `CHANGELIST.md` captures migration cutover rules — v2 readers tolerate v0.3.0 frontmatter via `frontmatter_version` field (absent → v0.3.0 lenient mode); migration is opt-in per CR (never bulk-rewrite); `client_review` retained in canonical lifecycle (in use in `generate-sow` today); no auto-rewriting historical artefacts; `archived` is the only v2 lifecycle addition.
**Approval gate**: Human reviews `.planning/CHANGELIST.md` and approves before Phase 4 begins. Approval signal = explicit go-ahead from the user. Rationale: open questions are triaged against the change list — each unknown gets assigned to the right downstream v2.x phase, which requires the change list to name the phases first.
**Plans**: TBD

### Phase 4: Open questions register
**Goal**: Produce `.planning/OPEN-QUESTIONS.md` — every "couldn't verify" + "needs human decision" item surfaced from research and design, each assigned an owning phase from the change list and a verification owner, so v2.x build phases inherit a clean register of what to resolve before each phase locks plans (no surprises mid-build).
**Depends on**: Phase 3 (Change list must be approved — owning-phase assignment per open question requires the v2.x phases to be named and sequenced first; assigning OPEN-01 native-AI questions to "Phase 7" is meaningless until Phase 7 exists in the committed sequence).
**Requirements**: OPEN-01, OPEN-02, OPEN-03, OPEN-04, OPEN-05, OPEN-06, OPEN-07
**Output deliverable**: `.planning/OPEN-QUESTIONS.md`
**Success Criteria** (what must be TRUE when this phase completes):
  1. `OPEN-QUESTIONS.md` catalogues every research-flagged "couldn't verify" item with owning phase (per CHANGELIST.md sequence) and verification owner — Pipefy AI KB content-upload endpoint (Phase 7), Wrike AI Studio knowledge-ingestion API (Phase 7), Ziflow ReviewAI knowledge-ingestion API (Phase 7), Pipefy GraphQL pagination cursor field names (Phase 2), Ziflow read-after-create consistency window (Phase 2), Pipefy/Wrike 2026 rate-limit currency (Phase 1 / Phase 2), Miro export-whole-board endpoint availability (Phase 3), Claude in Chrome canonical product naming (Phase 1).
  2. `OPEN-QUESTIONS.md` catalogues every connector-availability uncertainty in this workspace — Coda MCP wired? Google Workspace MCP wired (which server: `taylorwilsdon` vs `piotr-agier` vs Anthropic-maintained)? Miro MCP wired (or paste-only)? — with the Phase 1 connector probe named as the resolution path; AND every design-decision-deferred item needing human input before locking — risk-multiplier defaults validated against dYdX historicals (default 1.1/1.3/1.6), frontmatter migration cutover date, status-lifecycle survey of live client folders to confirm no live `status:` value gets orphaned, plugin self-test scope (smoke tests for hooks + frontmatter validator vs none).
  3. `OPEN-QUESTIONS.md` catalogues hub-link backfill rollout coordination with Jason's parallel workstream — list of clients whose `<Client> Brain/00_HUB.md` does/doesn't yet carry the `Documentation:` Drive link, expected backfill cadence, plugin behaviour for clients without the link (graceful halt at Stage 9 only — does not halt other stages, per MOD-1 prevention).
  4. `OPEN-QUESTIONS.md` catalogues the standard Coda templates v2 must author with Phase 8 as owner — brain-mirror doc template (section per spoke + Field Notes table); task-table template for clients without a pre-existing one; default `00_HUB.md` Coda block schema (`coda_brain_doc:`, `coda_tasks_table:`, `coda_tasks_schema:` cache).
  5. `OPEN-QUESTIONS.md` catalogues the two policy decisions still open — `/refine-<skill>` resolution (confirm "build single parameterised command" recommended OR "delete every orphan reference"; if build, namespace decision `/dydx-refine-*` vs `/refine-*`) AND plugin self-test scope (smoke tests for hooks + frontmatter validator via `pytest` on the plugin's own correctness — recommended — vs defer; plugin ships v2.1 without self-tests) — both with clear "decide before Phase X" owners.
**Approval gate**: Human reviews `.planning/OPEN-QUESTIONS.md` and approves. This is the milestone-final approval. Approval signal = explicit go-ahead. Rationale: register is the handoff artefact to v2.1+ build milestones; once approved the milestone is design-complete and v2.1 milestone definition can begin.
**Plans**: TBD

## Progress

**Execution Order:**
Phases execute sequentially: 1 → 2 → 3 → 4. Each phase requires explicit human approval of its deliverable file before the next phase begins.

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Audit | 9/9 | Complete | 2026-05-09 |
| 2. Design | 9/10 | In progress (Waves 1-9 done; Wave 10 synthesis next) | - |
| 3. Change list | 0/TBD | Not started | - |
| 4. Open questions register | 0/TBD | Not started | - |

---

*Roadmap created: 2026-05-09 — milestone v2.0 Implementor Edition (design-only)*
*Last updated: 2026-05-09 — Phase 2 Plan 09 complete (Wave 9 — Test bot architecture DESIGN-28/29/30: DESIGN-28 tier-1 / tier-2 boundary 6-column table with Python deterministic HUMAN-AUTHORED + AI orchestrator AI-GENERATED hard layer-separation contract + verbatim Out-of-Scope anti-feature citation + mixed-layer cases flagged for human design + 1 worked Pipefy card-create TC classification example; DESIGN-29 client_state.yaml skeleton 7 top-level keys + 4 sandbox sub-blocks pipefy/wrike/ziflow/coda Coda per CRIT-5 + wrike.host PERSISTED per DESIGN-15 + 3 worked per-platform examples with concrete sandbox IDs pipe-12345/space-67890/project-abcde + field-by-field rationale; DESIGN-30 drift-detection contract interface-only WITHOUT numbered pseudocode + inputs/outputs/halt/report-shape/2-path-human-action; 3 echo blockquotes added; echo count 29 → 32/30; **structural-check exits 0 — DESIGN.md is structurally passable** (NOT yet reviewer-ready per cross-AI MEDIUM #7 wording; Plan 02-10 synthesis adds executive summary + Appendix A glossary + Appendix B 30-row DESIGN-* traceability + finalised closed [OPEN] list))*
