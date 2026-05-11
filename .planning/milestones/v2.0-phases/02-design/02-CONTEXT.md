# Phase 2: Design - Context

**Gathered:** 2026-05-09
**Status:** Ready for planning

<domain>
## Phase Boundary

Produce a single self-contained markdown document at `.planning/DESIGN.md` that locks the v2 architecture for the dydx-delivery plugin so the v2.1+ rebuild can execute without re-deciding. The document covers, against the 30 DESIGN-* requirements:

- **Cross-cutting structural decisions** (DESIGN-01..10) — frontmatter scheme, stage numbering, hard-rules SoT, plugin surfaces, `/refine-<skill>` resolution, approval-gate enforcement, connector probe + graceful-degradation matrix, frontmatter migration co-existence, directional boundary, persona contract.
- **Skill layout & hand-offs** (DESIGN-11..13) — v2 folder layout, 13-skill inventory (6 NEW + 3 NEW platform + 4 MODIFIED + 2 UNCHANGED + 1 RETIRED), stage-by-stage hand-off contracts.
- **Platform skills** (DESIGN-14..16) — `platform-pipefy`, `platform-wrike`, `platform-ziflow` with the 5-file `references/` shape and 2026-grounded native-AI capability matrices.
- **Stage skills** (DESIGN-17..27) — Stage 1 Kickoff, Stage 2 Discovery refactor, Stage 3 SOW refactor, Stage 4a/4b Fnspec split, Stage 5 Tech spec scope gate, Stage 6 Cost estimate, Stage 7a/7b Build prompts (dual), Stage 8 Test bot architecture, Stage 9 Documentation, Stage 10 Native-AI, Stage 11 Sign-off.
- **Test bot deeper specifics** (DESIGN-28..30) — Python↔AI orchestrator boundary, `client_state.yaml` schema, drift-detection algorithm.

Self-contained means a reader can use it without re-deriving from research or AUDIT.md. This is a **design-only** phase — DESIGN.md describes the v2 architecture as locked contracts; **no skill files are edited in this milestone** (kickoff mandate). The v2.1+ build phases (sequenced by Phase 3 CHANGELIST.md) execute against this design.

</domain>

<decisions>
## Implementation Decisions

### Document structure (top-level)
- **D-18:** DESIGN.md is a **single self-contained markdown file** at `.planning/DESIGN.md`, organized by DESIGN-* requirement — one major section per DESIGN-01..30 (or per logical group of adjacent DESIGN-* IDs). Reviewer can verify the success criteria 1:1 against the doc. Where a finding spans two requirements (e.g., persona contract DESIGN-10 cross-references hand-off message shape DESIGN-13), the contract lives in its primary section and is cross-referenced from the other.
- **D-19:** Authoring pattern mirrors AUDIT.md (Phase 1 D-11/D-12): each major section opens with a **scannable matrix** (where the requirement carries a list — skill inventory, hand-off contracts, platform skills, stage skills) followed by per-item prose. Cross-cutting decisions (DESIGN-01..10) get a single decision-summary table at the top of the cross-cutting section, then per-decision prose below. One read, one approval gate.

### Per-stage skill depth (DESIGN-12, DESIGN-17..27)
- **D-20:** Each of the 11 stage skills carries a **decision contract only** — purpose, inputs (frontmatter + upstream artefact paths), outputs, downstream consumer, status flag(s), hand-off message shape, complexity tag, dependencies, and the key v2 design decisions for that stage (e.g., Stage 4 split rationale, Stage 6 risk-multiplier taxonomy structure). **Full SKILL.md prose is NOT drafted in this milestone** — that authoring runs in v2.1+ build phases where each skill build phase produces its own SKILL.md against this contract.
- **D-21:** Same decision-contract shape applies to the 3 platform skills (DESIGN-14..16): purpose, 5-file `references/` layout, native-AI capability matrix (2026-grounded), API surface for the gap, sandbox access pattern, knowledge ingestion path with `native_ai_path: api | paste | none` flag, `tier_claims_last_verified` frontmatter. No full SKILL.md draft.

### Risk-multiplier defaults (DESIGN-22 / Stage 6 cost estimate)
- **D-22:** DESIGN-22 locks the **structure only** — closed L/M/H taxonomy with mandatory `rationale:` field per row; `estimated_hours` + `risk_adjusted_hours` columns; per-assignee task breakdown (dev / non-dev / QA / lead); schema-introspection of existing client task table cached in `00_HUB.md`; Coda writes via `rows/upsert` with `keyColumns` for idempotency, `mutationStatus` polling, rate-limit at 4 req/10s; wait-for-commercial-inputs gate. **Numeric defaults (1.1 / 1.3 / 1.6) are explicitly DEFERRED** — DESIGN.md uses placeholder syntax (`L=<TBD-deferred>`, etc.) and carries an inline `[OPEN: Phase 4 — risk-multiplier defaults pending dYdX-historicals validation]` marker. Phase 4 OPEN-QUESTIONS owns resolution; decision required before Stage 6 build phase.

### `/refine-<skill>` resolution (DESIGN-05)
- **D-23:** **Build a single parameterised `commands/refine.md`** that takes the skill name as `$1`. Namespace is `/dydx-refine-*` (NOT bare `/refine-*`) to avoid collision with other plugins or native shortcuts. Existing v0.3.0 orphan references resolve cleanly via the parameterised command in v2.1 cutover. DESIGN-05 records this decision; Phase 3 CHANGELIST.md schedules the build for v2.1 Foundations.

### Plugin self-tests (extension to DESIGN-04 plugin surfaces)
- **D-24:** Plugin v2.1 ships with **pytest smoke tests** for plugin-level correctness — coverage: `validate-frontmatter` hook (positive + negative cases), `bump-artefact-version` hook (idempotency, version bump correctness), frontmatter parser (status-lifecycle validation, platform-gated identifier rules, `frontmatter_version` field handling). Self-tests live at `dydx-delivery/tests/` (NEW directory) and run in plugin CI. DESIGN.md adds a **"Plugin self-tests" subsection** under DESIGN-04 specifying scope, test framework (pytest), location, and CI integration.

### Frontmatter migration cutover (DESIGN-08)
- **D-25:** DESIGN-08 locks **CR-driven opt-in** (NOT date-based cutover): v2 readers tolerate v0.3.0 frontmatter via the `frontmatter_version` field; migration is opt-in per change request — artefacts upgrade only when their owning CR fires; in-flight `client_review` artefacts NEVER auto-flip to `approved`; status lifecycle MUST retain `client_review` (live in `generate-sow` today). **A status-lifecycle survey of live `<Client> Brain/` folders runs as part of THIS phase** (not deferred) — survey output confirms no live `status:` value gets orphaned by the canonical `draft → client_review → approved → archived` lifecycle. Survey result locks the DESIGN-08 contract (or surfaces a violating value that requires handling). The survey itself is a section in DESIGN.md (or an appendix) citing what was checked and what was found.

### Hand-off contract presentation (DESIGN-13)
- **D-26:** DESIGN-13 presents the stage-by-stage hand-off contract as **a single transition matrix** (10 rows for the 10 stage transitions Stage 1→2, 2→3, 3→4a, 4a→4b, 4b→5, 5→6, 6→7, 7→8, 8→9, 9→10, 10→11 — adjusted for substages where applicable) with columns: `From | To | Carrier file path | Frontmatter fields propagated | Gating status flag | Hand-off message`. Then each stage's per-stage subsection (under DESIGN-12 skill inventory) carries the hand-off message shape verbatim for unambiguous downstream use. Mirrors AUDIT.md D-11 matrix-then-prose pattern.

### Open-questions handling inside DESIGN.md
- **D-27:** Every undecided contract carries an **inline `[OPEN: Phase 4 — <one-line summary>]` marker at point of use** so a reader sees deferral context where it lives. DESIGN.md ends with a **closed list** ("Deferred to Phase 4 OPEN-QUESTIONS") that enumerates every `[OPEN]` marker for traceability into the Phase 4 register. Nothing falls through cracks; Phase 4 register can be built mechanically by walking the closed list. Items expected to land here at minimum: risk-multiplier numeric defaults (D-22), Pipefy GraphQL pagination cursor field names (per OPEN-01), Ziflow read-after-create consistency window (OPEN-01), Pipefy/Wrike 2026 rate-limit currency (OPEN-01), Pipefy AI KB content-upload endpoint (OPEN-01 — Phase 7 owner per Phase 4 success criteria), Wrike AI Studio knowledge-ingestion API (OPEN-01), Ziflow ReviewAI knowledge-ingestion API (OPEN-01).

### Decision-ID convention
- **D-28:** Phase 2 continues the `D-N` numbering from Phase 1 — Phase 1 used D-1 through D-17; Phase 2 picks up **D-18 onwards** for cross-milestone traceability. CHANGELIST.md (Phase 3) cites D-IDs without prefix disambiguation. Authoring decisions (about how DESIGN.md is structured) and architectural decisions (the v2 contracts themselves) share the same numbering pool — they coexist as decisions made during the design milestone.

### Persona contract concreteness (DESIGN-10)
- **D-29:** DESIGN-10 ships **principles + forbidden-phrasings list + 3 worked before/after examples** — not principle-only, not a full tone-lint regex set. Concretely: ~5 senior-implementer voice principles (e.g., "no AI hedging", "specific over abstract", "no apology-prefaces"); enumerated forbidden phrasings list ("we recommend", "as an AI", "I would suggest", filler hedging like "perhaps consider", "might want to"); 3 worked examples each showing a v0.3.0-style passage rewritten to v2 senior-implementer voice (drawn from real audit findings — e.g., truncated changelog sentence, "test sheet" residual, generic AI-style hedging spotted in skills). Concrete enough that v2.1 build phases can self-lint against it; not a full style guide.

### Test-bot architecture detail (DESIGN-28..30)
- **D-30:** **Interface-level contract + skeleton schema** — DESIGN-28 names the tier-1/tier-2 boundary in prose (Python tier-1 asserts state/schema/presence/equality/regex/retry-count/status-code class; AI tier-2 interprets free-form output, classifies failure causes, suggests remediation; mixed-layer cases flagged for human design) plus **1 worked test-case classification example** showing how a sample TC is split across tiers. DESIGN-29 ships a **skeleton `client_state.yaml`** showing top-level keys (sandbox tenant IDs gated by platform; fixtures; integration toggles; `wrike_host`; `last_known_schema` per platform; `last_passed_at` per test case; `targets_artefact` per test case) with **1 worked example per platform** (Pipefy, Wrike, Ziflow); not full per-test fixtures. DESIGN-30 ships the **drift-detection contract** — inputs (current sandbox schema, cached `last_known_schema`), outputs (match → proceed / mismatch → halt + emit `schema_drift_report.md`), halt condition, report shape, human-action requirement (acknowledge or revert) — without numbered pseudocode. Stage 8 build phase fills algorithmic detail.

### Author flow (planning)
- **D-31:** DESIGN.md is drafted **section-by-section across multiple plans** (NOT a single straight-through plan). Plan groupings:
  1. **Plan 02-01 (Cross-cutting):** DESIGN-01..10 + status-lifecycle survey appendix.
  2. **Plan 02-02 (Skill inventory + hand-offs):** DESIGN-11, DESIGN-12, DESIGN-13.
  3. **Plan 02-03 (Platform skills):** DESIGN-14, DESIGN-15, DESIGN-16.
  4. **Plan 02-04 (Stage skills 1–4):** DESIGN-17..20.
  5. **Plan 02-05 (Stage skills 5–8):** DESIGN-21..24.
  6. **Plan 02-06 (Stage skills 9–11):** DESIGN-25, DESIGN-26, DESIGN-27.
  7. **Plan 02-07 (Test bot):** DESIGN-28, DESIGN-29, DESIGN-30.
  8. **Plan 02-08 (Synthesis):** executive summary, glossary, traceability appendix, closed `[OPEN]` list, structural-check pass.
  Single approval gate at end (final DESIGN.md as a whole). Planner can sequence reviewable waves; if scope reveals more or fewer plans are appropriate, planner adjusts. Author sequence respects dependency: cross-cutting first (it grounds the rest), then skill inventory + hand-offs, then per-skill specs, then test bot, then synthesis.

### Cross-cutting authoring decisions (carried from Phase 1)
- **D-32:** Citations use `file:line` format with backtick wrapping (`` `dydx-delivery/skills/generate-sow/SKILL.md:42` ``) — same convention as AUDIT.md D-14.
- **D-33:** Open-question markers use the syntax `[OPEN: Phase 4 — <one-line summary>]` inline (per D-27); severity is implied by the deferral path (Phase 4 register), not by inline tags. Where a contract has known compatibility risks for migration, use `[MIGRATION-RISK: <summary>]` inline (distinct from `[OPEN]` — these are flagged hazards, not open questions).
- **D-34:** AUDIT.md is treated as ground truth — DESIGN.md cites `AUDIT.md §X.Y` for v0.3.0 facts (skill behaviour, connector wiring, brittleness). DESIGN.md does NOT re-derive observations from v0.3.0 source files except where AUDIT.md is silent.
- **D-35:** Each DESIGN-* section opens with a one-line success-criteria echo (the requirement ID + plain-English statement of what locks it) so reviewer can match section to REQUIREMENTS.md without cross-referencing.

### Claude's Discretion
- Internal ordering within each DESIGN-* section (decision-first vs context-first) — Claude picks per section based on what reads cleanest.
- Exact wording and length per stage-skill subsection — match the depth the underlying contract justifies, no padding. Stage 4 (fnspec split) and Stage 8 (test bot) likely need more prose than Stage 2 (discovery refactor — minimal change from v0.3.0).
- Whether to inline a small worked example vs. cite the research/AUDIT source — default to inline if the example fits in <10 lines and clarifies the contract; otherwise cite.
- Status-lifecycle survey methodology (which client folders to sample, how to record findings) — Claude executes the survey during Plan 02-01; methodology recorded in DESIGN.md alongside survey result.
- Whether to make the `[OPEN]` closed list a section or an appendix — Claude picks based on what reads cleanest at synthesis time.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents (researcher, planner, executor) MUST read these before planning or implementing.**

### Phase scope and requirements
- `.planning/ROADMAP.md` §"Phase 2: Design" — phase boundary, success criteria 1–6, approval gate
- `.planning/REQUIREMENTS.md` §"Design (DESIGN.md)" — DESIGN-01 through DESIGN-30 with detailed sub-bullets; §"Out of Scope" — what DESIGN.md must NOT decide
- `.planning/PROJECT.md` — milestone framing, kickoff mandate ("no skill edits in design milestone"), runtime constraints
- `.planning/STATE.md` — current position, milestone progress

### Ground truth (DESIGN.md cites these for v0.3.0 facts; does NOT re-derive)
- `.planning/AUDIT.md` — Phase 1 deliverable, approved 2026-05-09. Single canonical inventory of v0.3.0 plugin reality. DESIGN.md cites `AUDIT.md §X.Y` for skill behaviour, connector wiring, brittleness, version mismatches, missing artefacts, duplicated content blocks, live MCP wiring snapshot, `[NEW]`-tagged net-new findings.
- `.planning/phases/01-audit/01-CONTEXT.md` — Phase 1 context decisions D-1..D-17 (carried convention: citation format, severity tags, matrix-then-prose authoring)

### Research context (DESIGN.md grounds v2 architecture in this)
- `.planning/research/SUMMARY.md` — 9-phase build plan that DESIGN.md commits to (per CHANGE-01 in REQUIREMENTS.md)
- `.planning/research/ARCHITECTURE.md` — v2 architecture intent (substages, plugin surfaces, agent/hook scope)
- `.planning/research/FEATURES.md` — v2 feature inventory (table-stakes / differentiators / anti-features per stage)
- `.planning/research/PITFALLS.md` — CRIT-/MOD-/MIN- pitfall IDs cited in graceful-degradation matrix (DESIGN-07), connector-fallback rules, and migration-risk callouts
- `.planning/research/STACK.md` — research-derived stack decisions

### Codebase context (live state DESIGN.md must respect)
- `.planning/codebase/STRUCTURE.md` — directory layout, skill folder conventions, frontmatter field names
- `.planning/codebase/ARCHITECTURE.md` — pipeline overview, stage transitions, artefact-driven flow
- `.planning/codebase/CONVENTIONS.md` — naming conventions, status lifecycle vocabulary
- `.planning/codebase/INTEGRATIONS.md` — connector inventory and current wiring assumptions
- `.planning/codebase/STACK.md` — language/format constraints (markdown + YAML frontmatter; no JSON in artefacts)
- `.planning/codebase/TESTING.md` — current `execute-tests` testing reality (relevant to DESIGN-24 test bot architecture)

### v0.3.0 source surfaces (cited only when AUDIT.md is silent)
- `dydx-delivery/.claude-plugin/plugin.json` — plugin manifest (target version `2.0.0` per AUDIT-06)
- `.claude-plugin/marketplace.json` — marketplace manifest
- `dydx-delivery/skills/*/SKILL.md` + `references/*` — only consulted when DESIGN.md needs a v0.3.0 detail not captured in AUDIT.md
- `dydx-delivery/skills/execute-tests/references/safety-rules.md` — canonical hard-rules document (per DESIGN-03 SoT decision)

### Live <Client> Brain folders (for DESIGN-08 status-lifecycle survey under D-25)
- Path pattern per environment; sample of live folders for `status:` value enumeration. Methodology recorded in DESIGN.md survey appendix.

### Output deliverable (what this phase produces)
- `.planning/DESIGN.md` — single self-contained v2 architecture document (does not exist yet; created across plans 02-01 through 02-08)

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- **`.planning/AUDIT.md` (Phase 1 deliverable):** the canonical inventory of v0.3.0 reality — DESIGN.md cites it for skill behaviour, hand-off contracts (per `AUDIT.md §AUDIT-01.X`), connector wiring (per `AUDIT.md §AUDIT-03`, `AUDIT-08`), missing artefacts (per `AUDIT.md §AUDIT-04`), duplicated content (per `AUDIT.md §AUDIT-05`). DESIGN.md "what's missing for v2" gaps map 1:1 to AUDIT.md "what's missing for v2" subsections.
- **`.planning/research/SUMMARY.md` 9-phase build plan:** committed as the v2.x milestone sequence (per CHANGE-01); DESIGN.md does NOT re-author this plan — it locks the architecture that the SUMMARY.md plan executes against.
- **Phase 1 authoring patterns:** matrix-then-prose section shape (Phase 1 D-11/D-12), `file:line` citation format (D-14), severity-tag inline marking (D-15 — adapted to `[OPEN:]` and `[MIGRATION-RISK:]` for Phase 2 per D-33), per-bullet constraint-carrying for cross-phase scheduling (D-16). DESIGN.md adopts the matrix-then-prose pattern wholesale.
- **`dydx-delivery/skills/execute-tests/references/safety-rules.md`:** canonical hard-rules document — DESIGN-03 commits this as the single SoT path with `<Client> Brain/safety-overrides.yaml` overlay (only `overridable: true` fields).
- **Existing 7 v0.3.0 skill folders:** the 13-skill inventory (DESIGN-12) is **derived against** these — 4 MODIFIED (`discovery-intake` → `kickoff-capture` modified inputs branching; `generate-functional-spec` retired-and-replaced by `generate-fnspec-platform` + `generate-fnspec-integration` per Stage 4 split; `generate-build-prompt` modified for Stage 7a; `generate-test-plan` modified for Stage 8 contract); 2 UNCHANGED structure (`generate-sow`, `execute-tests` template-level; behaviour modified per stage spec); 1 RETIRED-AND-REPLACED (`generate-functional-spec` per Stage 4 split). Per-skill delta is Phase 3 CHANGELIST.md territory; DESIGN.md only inventories the v2 13-skill end state.

### Established Patterns (carried into DESIGN.md)
- **Skill folder shape:** `<skill>/SKILL.md` + `<skill>/references/*-template.md` + `<skill>/references/*-vocabulary.md`. Platform skills (DESIGN-14..16) share an extended 5-file `references/` shape (`api-contract.md`, `native-ai-inventory.md`, `knowledge-ingestion.md`, `client-shape-gotchas.md`, `vocabulary.md`).
- **Stage-prefixed artefact filenames:** v2 commits to file-prefix-as-stage-number (`01_kickoff_*` through `11_*`) per DESIGN-02; substages use letter suffixes (`4a/4b/7a/7b/8a..8d`); v0.3.0 prefix scheme migrates per DESIGN-02 old→new mapping table.
- **Frontmatter field conventions (locked by DESIGN-01):** underscore-snake-case for keys; hyphen-kebab-case for file paths in `based_on_*` values; platform-gated identifiers (`pipe_id`/`space_id`/`project_id` only when `platform:` is active); `frontmatter_version: 2` field on new artefacts; absent → v0.3.0 lenient mode.
- **`status:` lifecycle (locked by DESIGN-01):** canonical `draft → client_review → approved → archived`; `client_review` retained per DESIGN-08 (live in `generate-sow`); approval-gate hook (per DESIGN-06) refuses `status: approved` writes lacking `approved_by` + `approved_at`.
- **Hand-off message shape:** end-of-skill explicit handoff naming the approval action (per DESIGN-06); shape is locked per-stage in DESIGN-13 hand-off contract matrix.
- **Citation/severity tags:** `file:line` citations carried from Phase 1 D-14; `[OPEN: Phase 4 — ...]` and `[MIGRATION-RISK: ...]` introduced for Phase 2 (per D-33); existing v0.3.0-cite tags (`[BLOCKING] / [STRUCTURAL] / [COSMETIC]`) are NOT used in DESIGN.md (those were AUDIT.md severity for findings; DESIGN.md describes contracts not findings).

### Integration Points
- **Output location:** DESIGN.md sits at `.planning/DESIGN.md` (NOT under `.planning/phases/02-design/`) per ROADMAP.md "Output deliverable" — same convention as AUDIT.md. Phase 3 (Change list) and Phase 4 (Open questions) reference it without cross-phase pathing.
- **Plan commits:** Each Phase 2 plan must commit BOTH `.planning/phases/02-design/02-NN-PLAN.md` (the GSD plan-of-work) AND its slice of `.planning/DESIGN.md` (the deliverable accumulating across plans). The two file types have distinct purposes — plans are process; DESIGN.md is product.
- **Approval gate timing:** Single approval gate fires only at Phase 2 end (full DESIGN.md reviewed as a whole); intermediate plans do NOT trigger user approval — they trigger structural-check passes (per D-31 author-flow plan groupings). User reviews the assembled DESIGN.md once.
- **Phase 1 dependency:** AUDIT.md has been approved (2026-05-09). DESIGN.md treats it as immutable ground truth — if a v0.3.0 detail surfaces during design that conflicts with AUDIT.md, the discrepancy is logged as a `[MIGRATION-RISK]` and routed to Phase 4 OPEN-QUESTIONS, NOT silently resolved by re-deriving from source.
- **Live <Client> Brain status survey (D-25):** runs during Plan 02-01 (Cross-cutting) where DESIGN-08 lives. Survey methodology + result is a section/appendix in DESIGN.md.

</code_context>

<specifics>
## Specific Ideas

- **Reviewer experience:** DESIGN.md should support both "read in order" (preamble → executive summary → cross-cutting → skill inventory → platform skills → stage skills → test bot → appendices) AND "skip to a specific contract" (executive summary table acts as TOC; per-section success-criteria echoes per D-35 enable visual scan; closed `[OPEN]` list at end enables Phase 4 register handoff).
- **DESIGN-* section opening pattern:** Each major section opens with a one-line success-criteria echo (e.g., `> **DESIGN-01:** Canonical frontmatter scheme — status lifecycle, field-name convention, platform-gated identifiers, frontmatter_version semantics.`) per D-35, then the contract proper. Reviewer can match section to REQUIREMENTS.md without cross-referencing.
- **`[OPEN]` and `[MIGRATION-RISK]` discipline:** Use sparingly — only where a contract is genuinely undecided or carries known compatibility risk. Overuse defeats Phase 4's ability to act on the closed list. If something can be locked now, lock it now (per D-27).
- **Survey appendix vs. inline (D-25):** The status-lifecycle survey result lives at the end of the cross-cutting section as a sub-section ("Live status-lifecycle survey — methodology + result") so the DESIGN-08 contract can cite it without forward-reference. Methodology = which client folders sampled, what fields checked, exact `status:` values found.
- **Stage skill subsection density:** Stage 4 (fnspec split — DESIGN-20), Stage 6 (cost — DESIGN-22), Stage 7 (build prompts dual — DESIGN-23), Stage 8 (test bot — DESIGN-24) carry the most decision weight; their subsections are likely longer than Stage 2 (Discovery refactor — DESIGN-18, structurally near-unchanged from v0.3.0) or Stage 3 (SOW refactor — DESIGN-19, status lifecycle change only).
- **Hand-off matrix as the most-used DESIGN.md page:** v2.1+ build phases will cite DESIGN-13's transition matrix more than any other section (it's the contract every stage skill builds against). Build it for grep-ability — exact carrier file paths, exact frontmatter field names, exact gating status flag values.

</specifics>

<deferred>
## Deferred Ideas

These items came up during discussion or are flagged by REQUIREMENTS.md / ROADMAP.md as out-of-scope for Phase 2 — they belong to later phases.

- **Risk-multiplier numeric defaults (1.1 / 1.3 / 1.6 vs. dYdX-historical-validated):** DESIGN-22 locks structure; numbers DEFERRED to Phase 4 OPEN-QUESTIONS per D-22. Decision required before Stage 6 build phase.
- **Pipefy GraphQL pagination cursor field names** (per OPEN-01) — DESIGN-14 platform-pipefy contract carries `[OPEN]` marker; Phase 2 owns the deferral assignment but cannot resolve in design.
- **Ziflow read-after-create consistency window** (per OPEN-01) — DESIGN-16 platform-ziflow contract carries `[OPEN]`.
- **Pipefy / Wrike 2026 rate-limit currency** (per OPEN-01) — relevant to DESIGN-14 / DESIGN-15 retry/backoff design; carries `[OPEN]`.
- **Pipefy AI KB content-upload endpoint, Wrike AI Studio knowledge-ingestion API, Ziflow ReviewAI knowledge-ingestion API** (per OPEN-01) — these are the SINGLE BIGGEST research-blocked unknowns. DESIGN-14/15/16 native-AI knowledge-ingestion sections carry `[OPEN]` markers; Phase 4 register assigns them to the v2 build phase that owns native-AI ingestion (Phase 7 of the 9-phase plan per CHANGE-04).
- **Per-skill NEW/MODIFIED/RETIRED/UNCHANGED tagging** — Phase 3 CHANGELIST.md territory. DESIGN.md inventories the v2 13-skill end state; CHANGELIST.md sequences the delta.
- **Cosmetic-fix scheduling for v2.1 build** — Phase 3 CHANGELIST.md per CHANGE-03; DESIGN.md does NOT re-list cosmetic fixes (they live in AUDIT-07 already).
- **Standard Coda templates** (brain-mirror doc template, task-table template, default `00_HUB.md` Coda block schema) — Phase 4 OPEN-QUESTIONS register per the Phase 4 success criteria; Phase 8 owner.
- **Hub-link backfill rollout coordination** with Jason's parallel workstream — Phase 4 register, NOT this design milestone.
- **Stage 1 Miro workflow-map ingest via API + swimlane reconstruction** — flagged by FEATURES.md as needing deeper research before build. DESIGN-17 records the contract (paste fallback when API unavailable) but the swimlane-reconstruction algorithm itself is build-phase research.
- **Pipefy / Wrike / Ziflow live API probing in this workspace** — requires sandbox tenant credentials; deferred to v2.1+ build phases per CHANGE-04.

</deferred>

---

*Phase: 2-design*
*Context gathered: 2026-05-09*
