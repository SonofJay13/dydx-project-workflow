# Roadmap: dydx-delivery v2.0 — Implementor Edition

## Overview

This is a **design-only** milestone. The deliverables are four markdown documents under `.planning/` — `AUDIT.md`, `DESIGN.md`, `CHANGELIST.md`, `OPEN-QUESTIONS.md` — that together lock the v2 architecture for the dydx-delivery plugin so the v2.1+ rebuild can execute without rework. No skill files are edited in this milestone (kickoff explicitly forbids it). The roadmap follows a **deliverable-shaped** structure: one phase per output document, sequenced so each rests on the previous (audit grounds design; design sequences the change list; change list scopes the open-questions register).

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3, 4): Planned milestone work
- Decimal phases (e.g., 2.1): Urgent insertions only — none expected in a design-only milestone
- All phases gated by human approval of the deliverable file before the next phase runs

- [x] **Phase 1: Audit** — Catalogue v0.3.0 plugin reality so v2 design rests on observation, not memory; output `.planning/AUDIT.md` ✓ APPROVED 2026-05-09
- [x] **Phase 2: Design** — Lock v2 architecture across cross-cutting structure, 13-skill inventory, platform skills, every stage skill, and test bot; output `.planning/DESIGN.md` ✓ APPROVED 2026-05-10
- [x] **Phase 3: Change list** — Sequence the v0.3.0 → v2 delta as the v2.1+ build plan with per-skill delta and cosmetic-fix list; output `.planning/CHANGELIST.md` ✓ APPROVED 2026-05-10
- [x] **Phase 4: Open questions register** — Catalogue every "couldn't verify" + design-decision-deferred item, assign owner / phase; output `.planning/OPEN-QUESTIONS.md` ✓ APPROVED 2026-05-10 — **MILESTONE v2.0 DESIGN-COMPLETE**

### Milestone v2.1 — Foundations + Platform Skills (started 2026-05-10)

Phase numbering CONTINUES from v2.0. Two phases bundled per CHANGELIST CHANGE-01. Phase 5 lands BEFORE Phase 6 (intra-milestone ordering — Phase 6 platform skills point at Phase 5 canonical references).

- [ ] **Phase 5: Foundations + Connector Verification** — Plugin-level canonical references + manifest sync + LICENSE + scaffold dirs + connector probe matrix + 5 cosmetic CONCERNS fixes; resolves all v0.3.0 BLOCKING bugs from AUDIT.md
- [ ] **Phase 6: Internalise Platform Skills** — `skills/platform-{pipefy,wrike,ziflow}/` with 5-file `references/` shape + `paginate_all`/`wait_for_proof` helpers + OAuth-host persistence + `tier_claims_last_verified:` + `native_ai_path: paste|none` enum

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

**Wave 10** *(complete — Phase 2 deliverable complete)*
- [x] 02-10-PLAN.md — Synthesis: preamble + Executive Summary 21-row TOC + Appendix A glossary 69 entries + Appendix B 30-row DESIGN-* traceability + finalised closed [OPEN] list 8 bullets with explicit ownership *(complete 2026-05-10; SUMMARY at `.planning/phases/02-design/02-10-SUMMARY.md`; **DESIGN.md is reviewer-ready** per cross-AI MEDIUM #7 terminal state)*

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
**Plans:** 7 plans
Plans:

**Wave 1** *(complete)*
- [x] 03-01-PLAN.md — Wave 0 scaffold: changelist-structure-check.sh + CHANGELIST.md skeleton with all 16 D-36 H2 anchors + opening sentinels for Appendices B/D/E *(complete 2026-05-10; SUMMARY at `.planning/phases/03-changelist/03-01-SUMMARY.md`)*

**Wave 2** *(complete)*
- [x] 03-02-PLAN.md — CHANGE-01 first half: populate Phases 1-5 H2 sections (v2.1 + v2.2 + v2.3 + v2.4 milestones) with 6-row D-38 mini-tables + ordering-rationale paragraphs (verbatim from research/SUMMARY.md § Phase Ordering Rationale) *(complete 2026-05-10; SUMMARY at `.planning/phases/03-changelist/03-02-SUMMARY.md`)*

**Wave 3** *(complete)*
- [x] 03-03-PLAN.md — CHANGE-01 second half: populate Phases 6-9 H2 sections (v2.5 + v2.6 milestones); Phase 7 mini-table carries D-37 OPEN-01 contingent fallback verbatim sentence + DESIGN.md Appendix E bullet 1 inline marker *(complete 2026-05-10; SUMMARY at `.planning/phases/03-changelist/03-03-SUMMARY.md`)*

**Wave 4** *(complete)*
- [x] 03-04-PLAN.md — CHANGE-02: populate Appendix A 20-row per-skill delta matrix per D-39 (column headers exact; Status closed enum; ordered by milestone → phase → status; cited-bullet Change cells per D-40) *(complete 2026-05-10; SUMMARY at `.planning/phases/03-changelist/03-04-SUMMARY.md`)*

**Wave 5** *(complete)*
- [x] 03-05-PLAN.md — CHANGE-03 + CHANGE-05: populate Appendix B (verbatim AUDIT-07 lift — 6 fix subsections each carrying per-bullet sentinel per D-16/D-41) + Appendix D (numbered 7-rule migration cutover checklist citing DESIGN-08 per D-43) *(complete 2026-05-10; SUMMARY at `.planning/phases/03-changelist/03-05-SUMMARY.md`)*

**Wave 6** *(complete)*
- [x] 03-06-PLAN.md — CHANGE-04: populate Appendix C 2-row research-blocked matrix (Phase 1 + Phase 7) per D-42 + enrich Phase 1 + Phase 2 mini-table Research-blocked cells with 6 verbatim inline `[OPEN: Phase 4 - ...]` markers (DESIGN.md Appendix E bullets 2, 3, 4, 5, 6, 7) *(complete 2026-05-10; SUMMARY at `.planning/phases/03-changelist/03-06-SUMMARY.md`)*

**Wave 7** *(synthesis — terminal plan; complete)*
- [x] 03-07-PLAN.md — Synthesis: finalise preamble + populate Executive Summary 5-col 9-row condensed milestone-bundling table per CONTEXT default + populate How-to-read reader-flow guide + populate Appendix E 8-bullet enumeration via Phase 2 02-10 reconciliation algorithm carried (HIGH #3 + #10) — expanded to 9 bullets at execution per D-27 (Phase 9 OPEN-07 net-new deferral); final structural-check exits 0 — **CHANGELIST.md is reviewer-ready** *(complete 2026-05-10; SUMMARY at `.planning/phases/03-changelist/03-07-SUMMARY.md`)*

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
**Plans:** 5 plans
Plans:

**Wave 1**
- [x] 04-01-PLAN.md — Wave 1 scaffold: openquestions-structure-check.sh (14 assertions A1..A14 — cross-AI C5 added A14 citation-validity) + OPEN-QUESTIONS.md skeleton with 12 H2 anchors + preamble blockquote placeholder *(complete 2026-05-10; SUMMARY at `.planning/phases/04-open-questions/04-01-SUMMARY.md`)*

**Wave 2**
- [x] 04-02-PLAN.md — OPEN-01 + OPEN-02: research-flagged unverified items (11 rows post C6 split; 3× BLOCKER native-AI ingestion + GUARDRAIL/INFORMATIONAL; D-37 contingent fallback verbatim in OPEN-01 preamble) + connector-availability uncertainties (4 rows; all Phase 1 owner) *(complete 2026-05-10; SUMMARY at `.planning/phases/04-open-questions/04-02-SUMMARY.md`)*

**Wave 3**
- [x] 04-03-PLAN.md — OPEN-03 + OPEN-04 + OPEN-05: design-decision-deferred items (3 rows; risk-multiplier / migration cutover / status-survey) + hub-link backfill (1 canonical row per D-51) + Coda templates v2 must author (3 rows; Phase 8 owner); cross-reference forward to OPEN-Q22 per D-50 dedup *(complete 2026-05-10; SUMMARY at `.planning/phases/04-open-questions/04-03-SUMMARY.md`)*

**Wave 4**
- [x] 04-04-PLAN.md — OPEN-06 + OPEN-07: /refine-<skill> resolution (2 rows OPEN-Q21 + OPEN-Q21.1; D-52 sub-fields embedded; verbatim REQUIREMENTS.md recommendation) + plugin self-test scope (single canonical row OPEN-Q22; Phase 9 owner; resolves OPEN-03 cross-reference) *(complete 2026-05-10; SUMMARY at `.planning/phases/04-open-questions/04-04-SUMMARY.md`)*

**Wave 5**
- [x] 04-05-PLAN.md — Synthesis: preamble + Executive Summary 3-table (severity / phase / resolution rollups) + How-to-read 5-paragraph guide + Appendix A per-phase rollup + Appendix B traceability (numerically sorted per cross-AI G2; 1:1 cardinality with register-total) + Appendix C reconciliation algorithm result (REAL multiset comparison via openquestions-reconcile.sh — INPUT_COUNT_AFTER_DEDUP=42 / REGISTER_ROW_COUNT=25 / 3 documented split-merges / SC1..SC5 PASS) + final structural-check exits 0 (all 14 assertions PASS) + reviewer-ready terminal-state phrase *(complete 2026-05-10; SUMMARY at `.planning/phases/04-open-questions/04-05-SUMMARY.md`)*

## Milestone v2.1: Foundations + Platform Skills

> **Milestone framing.** First build milestone after v2.0 design-lock. Phase numbering CONTINUES from v2.0 (last phase = 4) — v2.1 starts at Phase 5. Two phases bundled per CHANGELIST CHANGE-01: Phase 5 (Foundations + Connector Verification) lands BEFORE Phase 6 (Internalise Platform Skills) — Phase 6 platform skills point at Phase 5 canonical references. v2.0 design-only mandate ENDS at v2.1 start — skill edits are now permitted. Apply v2.0 DESIGN contracts + UAT decisions verbatim — do not re-derive scope.

### Phase 5: Foundations + Connector Verification
**Goal**: Land the plugin-level canonical-references foundation that every later v2.x phase depends on — write `dydx-delivery/references/{safety-rules.md, stage-numbering.md, frontmatter-scheme.md, glossary.md}` as authoritative single sources of truth, repoint all 7 v0.3.0 skills at them (collapsing 4 hard-rules duplicates per AUDIT-05.1, fixing the sandbox-block bug, normalising `based_on_*` field names), apply file renumbering 00→02 / 01→03 / 02→04 / 03→05 / 04→07a, sync plugin manifest to `2.0.0` across `plugin.json` + `marketplace.json`, ship LICENSE per OPEN-Q23 boilerplate, scaffold empty `commands/`/`agents/`/`hooks/` dirs, codify the connector probe + graceful-degradation matrix (Coda MCP / Google Workspace MCP / Miro MCP / Pipefy API / Wrike API / Ziflow API), clean 5 cosmetic CONCERNS items per AUDIT-07 (B.1/B.2/B.3/B.4/B.6 — B.5 owner-email is INTENTIONAL per UAT-3.1), re-run the status-lifecycle survey to confirm no drift, and resolve 8 connector OPEN-QUESTIONS (Q06.1 / Q07.1 / Q09 / Q10 / Q11 / Q12 / Q13 / Q25).
**Depends on**: v2.0 design-lock (AUDIT.md / DESIGN.md / CHANGELIST.md / OPEN-QUESTIONS.md all approved 2026-05-10) — root phase of v2.1 milestone
**Requirements**: FOUND-01, FOUND-02, FOUND-03, FOUND-04, FOUND-05, FOUND-06, FOUND-07, FOUND-08, FOUND-09, FOUND-10, FOUND-11, FOUND-12, FOUND-13
**Success Criteria** (what must be TRUE when this phase completes):
  1. **Canonical references exist + are authoritative.** All four files exist at `dydx-delivery/references/{safety-rules.md, stage-numbering.md, frontmatter-scheme.md, glossary.md}` with content matching DESIGN-01/02/03 contracts; all 7 v0.3.0 skills point at them; `grep -r` for inlined safety-rules content / inlined stage-numbering text / inlined frontmatter-scheme content returns ZERO hits across skill files (collapses 4 hard-rules duplicates per AUDIT-05.1); the v0.3.0 sandbox-block bug is fixed (sandbox allowlist extended to Coda per CRIT-5); `based_on_*` field names normalised across all skill artefact templates.
  2. **File renumbering applied + manifest 2.0.0 synced + LICENSE + scaffold dirs in place.** File-prefix renumbering 00→02 / 01→03 / 02→04 / 03→05 / 04→07a applied across skill directories per FOUND-03 mapping table (NEW artefacts only — v0.3.0 in-flight artefacts stay at original prefixes per DESIGN-08 lenient mode); plugin manifest version `2.0.0` synced across `plugin.json` + `marketplace.json` metadata + `plugins[0]` (owner-email NOT changed per UAT-3.1); `LICENSE` file at repo root contains exactly the two-line boilerplate `All rights reserved.\nNot licensed for redistribution.` per OPEN-Q23 decision; empty `commands/`, `agents/`, `hooks/` directories exist at plugin root.
  3. **Connector probe + graceful-degradation matrix codified.** `dydx-delivery/references/connector-matrix.md` (or equivalent canonical location per DESIGN-07) documents session-start probe behaviour for each MCP/API endpoint (Coda MCP / Google Workspace MCP / Miro MCP / Pipefy API / Wrike API / Ziflow API auth headers) AND per-stage fallback behaviour table (Stage 6 → manual mode if Coda missing; Stage 9 → halt if Drive missing; Stage 10 → copy-paste fallback if direct API missing; etc.); 8 connector OPEN-QUESTIONS resolved (Q06.1 Pipefy 2026 rate-limit / Q07.1 Wrike 2026 rate-limit / Q09 Claude in Chrome canonical name / Q10 Coda MCP wired+pin / Q11 Google Workspace MCP server choice / Q12 Miro MCP wired vs paste-only / Q13 Wrike host source-of-truth / Q25 Wrike+Ziflow auth-concurrency class) with values populated in matrix.
  4. **5 cosmetic CONCERNS items cleaned + status-lifecycle survey re-run.** Per AUDIT-07 (post-UAT-3.1 reclassification): B.1 README truncation completed; B.2 residual "test sheet" wording removed from `README.md:9`; B.3 pipeline-step count corrected to 13 in `README.md:9`; B.4 LICENSE created (covered by criterion 2); B.6 homepage asymmetry fixed (`marketplace.json` now carries matching `homepage` field); B.5 owner-email is INTENTIONAL — NO fix applied (UAT-3.1; dYdX-approved private email per user_email_approved memory). Status-lifecycle survey re-run at Phase 5 kickoff per OPEN-Q16 confirms no drift in `status:` values across live `<Client> Brain/` folders since 2026-05-10 sample.
  5. **All v0.3.0 BLOCKING bugs from AUDIT.md resolved + Phase 6 unblocked.** Every BLOCKING-tagged item from AUDIT.md (`platform:` runtime-loading contract, hard-rules duplication, sandbox-block bug, frontmatter inconsistencies) shows resolution-evidence in commit history; Phase 6 platform skills can land cleanly on top because canonical references they need to point at now exist.
**Approval gate**: Human reviews canonical references + manifest sync + connector matrix + cleaned cosmetic items before Phase 6 begins. Approval signal = explicit go-ahead from the user. Rationale: Phase 6 platform skills point at Phase 5 canonical references — landing Phase 6 first leaves dangling pointers (per CHANGELIST.md Phase Ordering Rationale).
**Plans:** 5 plans
Plans:

**Wave 1**
- [ ] 05-01-PLAN.md — FOUND-01..04 + FOUND-12: status-lifecycle survey re-run (Coda MCP / SKILL.md fallback) + 4 canonical references (safety-rules.md lift-and-fix per D-62 + CRIT-5 Coda clause / stage-numbering.md DESIGN-02 verbatim mapping / frontmatter-scheme.md DESIGN-01+06+08 with PERMANENT lenient-mode / glossary.md lift-and-narrow from DESIGN.md Appendix A + Q09/Q13 entries)

**Wave 2**
- [ ] 05-02-PLAN.md — FOUND-05..06: 4-file hard-rules dedup (D-59 verbatim pointer; AUDIT-05.1 ground truth supersedes D-59 nominees) + execute-tests/references/safety-rules.md COLLAPSE per D-62 + 13 based_on_* filename renumbers + 6 template Stage-N self-label renumbers + skill prose filename refs

**Wave 3**
- [ ] 05-03-PLAN.md — FOUND-07..09: plugin.json + marketplace.json sync to 2.0.0 (owner-email UNCHANGED per UAT-3.1) + B.6 homepage on marketplace.json plugins[0] (cross-AI flag 2 — lands in W3 inline) + LICENSE byte-exact OPEN-Q23 boilerplate at repo root + 3 empty scaffold dirs (commands/agents/hooks) with .gitkeep; mcpServers field DEFERRED to later v2.x (cross-AI flag 5)

**Wave 4**
- [ ] 05-04-PLAN.md — FOUND-10 + FOUND-13: connector-matrix.md doc-only (D-56) with 6 connectors x 11 stages grid + per-stage fallback narrative + 8 OPEN-Q resolved values inline + UAT-3.5/UAT-6.1 lock-honouring grep gates; OPEN-QUESTIONS.md 8 row Status flips (Q06.1/Q07.1/Q09/Q10/Q11/Q12/Q13/Q25 -> decided) with backtick `path:line` citations per D-14

**Wave 5** *(checkpoint — autonomous: false)*
- [ ] 05-05-PLAN.md — FOUND-11 + Wave 0 retrospective: B.1 dydx-delivery/README.md changelog truncation closure (user-adjudicated text per checkpoint) + B.2 root README "test sheet" -> "test plan" + B.3 pipeline-step count per cross-AI flag 3 (default = v2.1 reality, 7 skills) + scripts/phase5-structure-check.sh with ~40 assertions A1..A40 mirroring openquestions-structure-check.sh; B.4 + B.6 cross-referenced (already landed in W3); B.5 NO FIX (UAT-3.1)

### Phase 6: Internalise Platform Skills
**Goal**: Ship `skills/platform-{pipefy,wrike,ziflow}/` each with the 5-file `references/` shape (`api-contract.md` / `native-ai-inventory.md` / `knowledge-ingestion.md` / `client-shape-gotchas.md` / `vocabulary.md`) per DESIGN-14/15/16, with per-platform helpers for known gotchas (`paginate_all` for Pipefy GraphQL cursor pagination per MOD-4 / `wait_for_proof` for Ziflow read-after-create eventual consistency per MOD-6 / Wrike OAuth-host persistence per MOD-5), DESIGN-14 REVISED canonical-only Pipefy API endpoint (`api.pipefy.com/graphql` for ALL tenants — Q24 verified 2026-05-10 via DNS test) with HTML-on-auth-failure gotcha documented in `api-contract.md`, locked frontmatter contracts (`tier_claims_last_verified:` per MOD-7 + `native_ai_path:` enum locked to `paste | none` ONLY per UAT-6.1 — no `api` branch), and 3 throttle/consistency OPEN-QUESTIONS resolved (Q05 Ziflow read-after-create window / Q06.2 Pipefy throttle calibration / Q07.2 Wrike throttle calibration).
**Depends on**: Phase 5 (canonical references must exist before platform skills point at them — Phase 6 platform-skill `safety-rules.md` / `stage-numbering.md` / `frontmatter-scheme.md` / `glossary.md` references all resolve to Phase 5 deliverables)
**Requirements**: PLAT-01, PLAT-02, PLAT-03, PLAT-04, PLAT-05, PLAT-06
**Success Criteria** (what must be TRUE when this phase completes):
  1. **Pipefy platform skill shipped with revised DESIGN-14 contract.** `skills/platform-pipefy/SKILL.md` exists with 5-file `references/` shape; `references/api-contract.md` documents canonical-only `api.pipefy.com/graphql` endpoint for ALL tenants (per Q24 verification 2026-05-10) AND the HTML-on-auth-failure gotcha (Pipefy returns Keycloak login HTML page with `Content-Type: text/html`, NOT JSON 401, on auth fail) AND the `paginate_all` helper for GraphQL cursor pagination (avoiding silent truncation per MOD-4); `web_host` + `org_id` fields documented as per-tenant variants (per UAT-4.1 simplification — `api_host` field NOT present); `references/native-ai-inventory.md` grounded in 2026 Pipefy AI Agents docs (KB + Skills + MCP + IDP + Web Search + BYO-LLM).
  2. **Wrike platform skill shipped with OAuth-host persistence.** `skills/platform-wrike/SKILL.md` exists with same 5-file `references/` shape; `references/api-contract.md` documents that the `host` field MUST be persisted from the OAuth token response (NEVER hardcode `www.wrike.com` per MOD-5 — the OAuth token response carries the customer's regional host as part of its base-URL contract; hardcoding breaks multi-tenant); `references/native-ai-inventory.md` grounded in Wrike Copilot + 16 MCP tools per DESIGN-15; `references/knowledge-ingestion.md` documents the attach-doc-via-MCP path.
  3. **Ziflow platform skill shipped with `wait_for_proof` helper.** `skills/platform-ziflow/SKILL.md` exists with same 5-file `references/` shape; `references/api-contract.md` documents the `wait_for_proof` helper for read-after-create eventual consistency (MOD-6) with 30s poll budget / 2s interval default; `references/native-ai-inventory.md` grounded in Ziflow ReviewAI (Checklists Public Preview; Change Verification + Brand Standards Coming Soon); `references/knowledge-ingestion.md` documents checklist-generation as primary path with copy-paste fallback.
  4. **Frontmatter contracts locked across all 3 platform skills.** `tier_claims_last_verified:` frontmatter populated on `platform-pipefy/SKILL.md`, `platform-wrike/SKILL.md`, `platform-ziflow/SKILL.md` per MOD-7 (date stamps when native-AI tier claims were last verified against vendor docs); `native_ai_path:` flag enum locked to `paste | none` ONLY across all 3 platform skills (UAT-6.1 — `api` branch removed; native-AI ingestion APIs OUT-OF-SCOPE entirely; Stage 10 [v2.5] = paste bundle + upload audit log only); `grep -r 'native_ai_path: api' skills/platform-*/` returns ZERO hits.
  5. **3 throttle/consistency OPEN-QUESTIONS resolved.** Q05 Ziflow read-after-create consistency window resolved (informs `wait_for_proof` defaults in `platform-ziflow/references/api-contract.md`); Q06.2 Pipefy throttle calibration resolved (depends on Q06.1 / FOUND-13 from Phase 5); Q07.2 Wrike throttle calibration resolved (depends on Q07.1 / FOUND-13 from Phase 5); resolved values land in respective `api-contract.md` files; OPEN-QUESTIONS.md status fields flipped from `proposed` to `decided` for Q05 / Q06.2 / Q07.2.
**Approval gate**: Human reviews 3 platform skills + 5-file `references/` shape parity + revised DESIGN-14 contract verification + frontmatter contracts. Approval signal = explicit go-ahead from the user. Rationale: closes milestone v2.1 — every later v2.x phase that loads a platform skill (Stage 4 fnspec split, Stage 5 tech spec, Stage 7b implementation prompt, Stage 8 test bot, Stage 10 native-AI push) inherits clean platform-skill contracts.
**Plans**: TBD (defined via `/gsd-discuss-phase 6` then `/gsd-plan-phase 6` after Phase 5 approval)


## Progress

**Execution Order:**
Phases 1 → 2 → 3 → 4 (v2.0 milestone, design-only, complete 2026-05-10) → Phase 5 → Phase 6 (v2.1 milestone, build, started 2026-05-10). Each phase requires explicit human approval of its deliverable before the next phase begins. Phase 5 → Phase 6 dependency is hard (Phase 6 platform skills point at Phase 5 canonical references).

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Audit | 9/9 | Complete | 2026-05-09 |
| 2. Design | 10/10 | Complete ✓ APPROVED 2026-05-10 | 2026-05-10 |
| 3. Change list | 7/7 | Complete ✓ APPROVED 2026-05-10 | 2026-05-10 |
| 4. Open questions register | 5/5 | Complete ✓ APPROVED 2026-05-10 | 2026-05-10 |
| 5. Foundations + Connector Verification (v2.1) | 0/TBD | Not started — roadmap-locked | — |
| 6. Internalise Platform Skills (v2.1) | 0/TBD | Not started — depends on Phase 5 | — |

---

*Roadmap created: 2026-05-09 — milestone v2.0 Implementor Edition (design-only)*
*Roadmap extended: 2026-05-10 — milestone v2.1 Foundations + Platform Skills appended (Phase 5 + Phase 6 per CHANGELIST CHANGE-01; phase numbering continues from v2.0; 19/19 v2.1 requirements mapped — 13 → Phase 5 + 6 → Phase 6)*
*Last updated: 2026-05-10 — **MILESTONE v2.0 IMPLEMENTOR EDITION ✓ DESIGN-COMPLETE**: Phase 4 approved. All four design deliverables locked: AUDIT.md ✓ APPROVED 2026-05-09 / DESIGN.md ✓ APPROVED 2026-05-10 / CHANGELIST.md ✓ APPROVED 2026-05-10 / OPEN-QUESTIONS.md ✓ APPROVED 2026-05-10. v2.1 build milestone definition can now begin per CHANGELIST.md milestone bundling (v2.1 = Foundations + Platform skills per CHANGE-01). Phase 4 last-update detail: **Phase 4 EXECUTION COMPLETE — awaiting milestone-final approval**: All 5 plans executed sequentially across 5 waves on `dydx-delivery-v2` (file-ownership on `.planning/OPEN-QUESTIONS.md` forced serialisation). 16 atomic commits — Wave 1 (a11a1fb script + 704df41 skeleton + f6be347 SUMMARY); Wave 2 (0271413 OPEN-01 11 rows post-C6 split + f3e4cd5 OPEN-02 4 rows + e1aadfa decimal-form-IDs Rule-1-fix + 03110c1 SUMMARY); Wave 3 (f4f9660 OPEN-03 + 658d162 OPEN-04 single canonical row + fe681c2 OPEN-05+SUMMARY); Wave 4 (c31634f OPEN-06 OPEN-Q21+Q21.1 + 5b2c7f0 OPEN-07 OPEN-Q22 ID-locked-by-OPEN-03-cross-ref + 186d901 SUMMARY); Wave 5 (2180213 preamble+Executive-Summary+How-to-read + 1c1f33f Appendix-A+B + 555c77d synthesis terminal). Final structural-check exits 0 — all 14 assertions A1..A14 PASS. `openquestions-reconcile.sh` exits 0 with REAL multiset comparison (INPUT_COUNT_AFTER_DEDUP=42 / REGISTER_ROW_COUNT=25 / 3 documented split-merges Q06.1/.2 + Q07.1/.2 + Q21/Q21.1 / ALL_CITATIONS_VERIFIED=TRUE per cross-AI C5 / ALL_OWNERS_ASSIGNED=TRUE single-owner-only per cross-AI C6 / SC1..SC5 PASS via grep-grounded checks). gsd-verifier PASS 45/45 must-haves; VERIFICATION.md at `.planning/phases/04-open-questions/04-VERIFICATION.md`. OPEN-01..05 success criteria all met; ROADMAP success criteria 1-5 all addressed; D-N pool frozen at D-55. `OPEN-QUESTIONS.md` is reviewer-ready (479 lines; 25 rows across 12 H2 anchors; cross-AI MEDIUM #7 terminal-state phrase reserved for Plan 04-05). Carried Rule-1 deviations (all benign + documented per-wave): decimal-form OPEN-Q sub-IDs (Q06.1/Q06.2/Q07.1/Q07.2/Q21.1) per cross-AI C2; unbolded register-row field labels matching Wave 1 script regex; inline-anchor citation rule (literal H2 substrings inside backticks trip A2 H2-uniqueness — phrasing reworded throughout). Awaiting milestone-final approval gate review per ROADMAP — once approved, milestone v2.0 Implementor Edition is design-complete (deliverables: AUDIT.md ✓ DESIGN.md ✓ CHANGELIST.md ✓ OPEN-QUESTIONS.md ✓) and v2.1 milestone definition can begin (per CHANGELIST.md milestone bundling).*

*Previous Phase 3 last-update note: **Phase 3 EXECUTION COMPLETE — awaiting approval**: All 7 plans executed sequentially across 7 waves (file-ownership on `.planning/CHANGELIST.md` forced serial execution). Wave 1 (03-01) scaffold + 15-assertion structural-check; Wave 2-3 (03-02 + 03-03) full 9-phase build-plan mini-tables (Phase 7 carries verbatim D-37 fallback); Wave 4 (03-04) Appendix A 20-row per-skill delta matrix; Wave 5 (03-05) Appendix B 6 cosmetic-fix subsections (verbatim AUDIT-07 lift) + Appendix D 7-rule migration cutover checklist; Wave 6 (03-06) Appendix C research-blocked Phase 1 + Phase 7 + Phase 1/2 mini-table enrichment with 6 verbatim DESIGN.md Appendix E bullets; Wave 7 (03-07) reviewer-ready synthesis (preamble + Executive Summary 5-col 9-row milestone-bundling table + How-to-read + Appendix E 9-bullet reconciliation expanded from baseline 8 per D-27 net-new Phase 3 OPEN-07 deferral). Final structural-check exits 0 (all 14 assertions pass). gsd-verifier PASS 12/12 must-haves; VERIFICATION.md at `.planning/phases/03-changelist/03-VERIFICATION.md`. CHANGE-01..05 all met; ROADMAP success criteria 1-5 all addressed; D-N pool frozen at D-45. Awaiting Phase 3 approval gate review per ROADMAP. Phase 4 (Open questions register) next via `/gsd-discuss-phase 4` after approval — Phase 4 builds mechanically by walking the 9 Appendix E bullets.*

*Original Phase 2 last-update note: **Phase 2 COMPLETE**: Plan 02-10 (Wave 10 — synthesis) executed — preamble blockquote finalised + Executive Summary 21-row TOC table populated + Appendix A Glossary 69 entries populated (frontmatter fields / status lifecycle / stage prefixes / platform terms / test-bot terms / plugin surfaces / doc + sign-off terms) + Appendix B 30-row DESIGN-* → DESIGN.md section traceability table populated covering DESIGN-01..30 (substage-spanning rows for DESIGN-08 + DESIGN-12 (renamed `## v2 skill inventory` anchor per cross-AI MEDIUM #4 follow-through) + DESIGN-20 (4a + 4b) + DESIGN-23 (7a + 7b) + DESIGN-29/30 (D-30 interface-only)) + Deferred OPEN-QUESTIONS list finalised with 8-bullet enumeration in document order (Pipefy AI KB / Pipefy pagination cursor / Pipefy rate-limit / Wrike AI Studio / Wrike rate-limit / Ziflow ReviewAI / Ziflow read-after-create / risk-multiplier defaults) each with explicit `owner: Phase <N> per CHANGE-04` per cross-AI #10 + reconciliation algorithm passing all 3 conditions per cross-AI HIGH #3 (cardinality match INLINE_COUNT=LIST_BULLETS=8; textual match `diff` empty; ownership-per-bullet OWNERS_PRESENT=8=LIST_BULLETS); meta-pattern Rule 2 reword on preamble + CR pre-archive sanity bullet to remove literal `[OPEN: Phase 4 — ...]` ellipsis pattern that would inflate INLINE_COUNT; final structural-check exits 0 — all 9 assertions PASS — **DESIGN.md is reviewer-ready** (cross-AI MEDIUM #7 terminal state phrase reserved for Plan 02-10). Awaiting Phase 2 approval gate review per ROADMAP. Phase 3 (Change list) next via `/gsd-discuss-phase 3` after approval.*
