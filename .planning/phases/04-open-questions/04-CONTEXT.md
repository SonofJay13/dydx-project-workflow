# Phase 4: Open questions register - Context

**Gathered:** 2026-05-10
**Status:** Ready for planning

<domain>

## Phase Boundary

Phase 4 produces `.planning/OPEN-QUESTIONS.md` — the **closed register** of every "couldn't verify" + "needs human decision" item across the v2.0 design milestone, each assigned an **owning phase** from the v2.x build sequence committed in CHANGELIST.md (CHANGE-01) and a **verification owner** (phase + role tag). The register is the milestone's **handoff artefact** to v2.1+ build phases — every v2.x phase begins by reading the rows it owns and resolving them before locking plans.

**This is a register-authoring phase, not a design phase.** No new design decisions are made here. No skill files are edited (kickoff mandate; design-only milestone). The output is a single markdown deliverable at the planning root: `.planning/OPEN-QUESTIONS.md`.

**Boundary with Phase 3:** Phase 3 produced CHANGELIST.md Appendix E — the closed list of every `[OPEN: Phase 4 — ...]` marker in CHANGELIST.md (9 bullets after Phase 3 expanded the DESIGN.md baseline 8 to honour D-27 net-new Phase 3 OPEN-07 deferral). Phase 4 walks Appendix E mechanically and merges it with REQUIREMENTS.md OPEN-01..07 + ROADMAP success criteria 1-5 + any new questions discovered during Phase 4 authoring. Phase 3 does NOT pre-write the register; Phase 4 owns row generation.

**Boundary with v2.1+ build phases:** OPEN-QUESTIONS.md is the **handoff document**, not a build executor. Every register row carries an owning phase + resolution path; v2.x build phases consume their assigned rows but Phase 4 does not resolve them. Items pulled forward into the register from CHANGELIST.md inline markers (per D-27) keep their owner assignment unchanged — Phase 4 mechanically transcribes; it does not re-decide.

**Boundary with milestone completion:** Phase 4 is the **terminal phase** of the v2.0 Implementor Edition milestone. Approval of OPEN-QUESTIONS.md = milestone-design-complete. After approval, v2.1 milestone definition can begin, inheriting OPEN-QUESTIONS.md as the resolution backlog.

</domain>

<decisions>

## Implementation Decisions

D-N numbering picks up at **D-46** (Phase 3 ended D-45). All Phase 4 decisions are D-46..D-55. Cross-cutting decisions D-14 / D-15 / D-16 / D-17 / D-25 / D-27 / D-28 carried from Phase 1+2; D-36..D-45 carried from Phase 3 (where they apply to register-authoring discipline).

### D-46 — Top-level document shape: hybrid (primary by OPEN-NN; secondary index by owning phase)

OPEN-QUESTIONS.md groups **primarily by OPEN-NN source category** (one H2 per OPEN-01 through OPEN-07, matching the ROADMAP success criteria 1-5 + REQUIREMENTS.md OPEN-01..07 1:1). A **secondary per-phase rollup index** appears in Appendix A enumerating which v2.x phases own how many rows. Reader scanning by category lands on a single H2; reader planning a v2.x phase scans Appendix A first for assigned rows.

**Rationale:** OPEN-NN are the canonical requirement IDs. Matching H2 anchors to OPEN-NN gives mechanical traceability into REQUIREMENTS.md and avoids redundant naming. Per-phase rollup as secondary index is necessary because v2.x phases each need their own assigned-rows view.

### D-47 — Per-row schema (closed shape, mandatory fields)

Every register row carries the following 9 fields, in this order, as a markdown table OR as a per-row block (planner discretion). All fields are mandatory:

1. **`OPEN-QN`** — register-internal ID, format `OPEN-Q<NN>` (e.g., `OPEN-Q01`).
2. **Question** — one-line, action-shaped (e.g., "Is the Pipefy AI KB content-upload endpoint externally verifiable, and if so via which API call?").
3. **Source citations** — multi-source list using `` `file:line` `` format per D-14 carried; e.g., `` `.planning/REQUIREMENTS.md:90` `` + `` `.planning/CHANGELIST.md:284` `` + `` `.planning/DESIGN.md:NNN` ``.
4. **Owning phase** — closed enum from CHANGE-01 (`Phase 1` / `Phase 2` / ... / `Phase 9`); `owner: TBD` permitted only when Phase 4 explicitly cannot assign (no silent omission per D-27 spirit).
5. **Verification owner** — closed enum: `<owning phase> / <role tag>` where role tag is from `dev | non-dev | QA | lead | Jason` per DESIGN-22 closed enum carried.
6. **Severity** — closed enum: `BLOCKER | GUARDRAIL | INFORMATIONAL` per D-48.
7. **Resolution path** — closed enum from D-49.
8. **Proposed default / recommended answer** — verbatim lift from REQUIREMENTS.md or research where one exists; `none` literal where no recommendation has been authored (no silent omission).
9. **Status** — closed enum: `open | proposed | decided | closed`. Phase 4 ships every row at `open` (with `proposed` permitted when REQUIREMENTS.md or research carries a recommendation that just needs Jason sign-off).

**Citation discipline:** every Source citation is verifiable by `grep -n` against the cited file. The structural-check (planned per D-54) asserts every Source field parses to at least one valid `path:line` substring.

### D-48 — Severity closed enum (3-tier)

Closed enum: `BLOCKER | GUARDRAIL | INFORMATIONAL`. No fourth tier permitted; no overlap.

- **`BLOCKER`** — must be resolved before owning phase can lock plans. Plan-phase for the owning v2.x phase refuses to start while ANY assigned BLOCKER row remains `open` or `proposed`. Example: OPEN-01 native-AI ingestion endpoints (Phase 7 hard blocker per D-37 carried).
- **`GUARDRAIL`** — must be resolved during owning phase (before that phase ships) but does not halt plan-creation. Plan-phase warns but proceeds. Example: Pipefy GraphQL pagination cursor field names.
- **`INFORMATIONAL`** — documented for awareness; default is acceptable; explicit override required to change. Plan-phase neither halts nor warns. Example: risk-multiplier defaults 1.1 / 1.3 / 1.6 (DESIGN-22 structure-locked; numbers ship as defaults unless validated against dYdX historicals).

**Rationale:** ROADMAP criterion 1 + criterion 5 distinguish "must be resolved before phase X" from "decide before Phase X" from "decide before Phase X owners". The 3-tier closed enum encodes this distinction in a single field that downstream plan-phases can grep on.

### D-49 — Resolution-path closed enum (5-value)

Closed enum exactly:

1. **`/gsd-research-phase <N>`** — research-blocked items (verification requires probing live APIs / external docs). Owning phase number filled in.
2. **`decide-before-Phase-<N>`** — design decisions with phase deadline. Owning phase number filled in.
3. **`Coda-template-authoring (Phase 8)`** — template-shaped items (OPEN-05). Phase 8 = Documentation publishing per CHANGELIST.md CHANGE-01.
4. **`policy-pending-sign-off`** — Jason approves recommended default (no further work; just acceptance signal). Used for OPEN-06 + OPEN-07 + similar.
5. **`live-workstream-pointer`** — resolved via Jason's parallel workstream coordination (hub-link backfill OPEN-04). Pointer source named per row (e.g., `00_HUB.md` files / external Coda doc).

No other values permitted. The structural-check (per D-54) asserts every Resolution-path field exact-matches one of the 5 enum values.

### D-50 — Source merging / dedup discipline (single canonical question per row, multi-source citation)

Phase 4 input streams:

- `.planning/CHANGELIST.md` Appendix E (9 closed-list bullets — D-27 carried)
- `.planning/REQUIREMENTS.md` OPEN-01..07 (7 requirement IDs aggregating ~25-30 sub-items)
- `.planning/ROADMAP.md` Phase 4 success criteria 1-5
- `.planning/DESIGN.md` § "Deferred to Phase 4 OPEN-QUESTIONS" closed list (8 baseline bullets — superset of CHANGELIST.md Appendix E baseline before D-27 net-new addition)
- `.planning/AUDIT.md` open-issue cross-references where applicable

**Dedup rule:** **single canonical row per distinct question** (case-insensitive normalised match on Question text). When the same question appears in 2-5 input streams, the canonical row's `Source citations` field carries all `path:line` citations as a multi-source list. New questions discovered during Phase 4 authoring (rare — Appendix E is the authoritative pre-walk) get their own canonical row with full citation.

**Reconciliation algorithm (terminal-state gate):** Phase 4 synthesis plan walks all 5 input streams, builds the input-side multiset, dedup-merges on Question text, asserts `INPUT_COUNT_AFTER_DEDUP == REGISTER_ROW_COUNT` (cardinality match). Then for each row: assert at least 1 citation is verifiable via `grep -n` (textual match). Then for each row: assert `Owning phase` field is non-empty AND value is in the valid enum (ownership coverage). Algorithm precedent: Phase 2 02-10 (cross-AI HIGH #3 fix) and Phase 3 03-07 (Appendix E reconciliation, expanded to 9 per D-27).

### D-51 — Hub-link backfill (OPEN-04) shape: pointer-only + invariant

Phase 4 does **not enumerate clients** in OPEN-QUESTIONS.md. Single register row for OPEN-04 carries:

- **Question:** "Which clients have `00_HUB.md` carrying the `Documentation:` Drive link, and which need backfill before v2.x ship gates?"
- **Resolution path:** `live-workstream-pointer`
- **Pointer source-of-truth (during v2.x build):** "live `00_HUB.md` files in client folders + Jason's parallel workstream tracker (location TBD per OPEN-04 sub-row)".
- **Verification owner:** `Phase 1 / Jason` (Foundations build coordinates with Jason's parallel workstream).
- **Severity:** `INFORMATIONAL`.
- **Proposed default (verbatim from REQUIREMENTS.md OPEN-04):** "graceful halt at Stage 9 only — does not halt other stages, per MOD-1 prevention".

**Rationale:** Phase 4 doesn't have client list and shouldn't snapshot a moving target. Pointer-only keeps the register valid as the workstream evolves. Sub-row may be added later when the live-tracker source is named.

### D-52 — Policy-decisions (OPEN-06 + OPEN-07) shape: formalise decision-deadline + owner + acceptance-signal

Each policy-decision row carries the standard D-47 9-field schema PLUS **two policy-specific sub-fields** in the row body (not a separate column — keeps the 9-field schema closed):

- **Decision deadline** — named v2.x phase before which this must be decided (e.g., "before Phase 1 plan-phase for OPEN-06 namespace decision").
- **Acceptance signal** — explicit signal pattern (e.g., "Jason explicit go-ahead in chat or commit message").
- **Fallback-if-undecided** — what ships if the deadline passes without a decision (e.g., "v2.1 ships with `/refine-<skill>` references intact but undocumented; revisit at v2.2").

**Recommended defaults (verbatim from REQUIREMENTS.md, status: `proposed`):**

- **OPEN-06 — `/refine-<skill>` resolution:** "build single parameterised command" (recommended). If build, namespace recommendation: `/dydx-refine-<skill>` (plugin-prefixed; avoids clash with other plugins' `/refine-*` commands).
- **OPEN-07 — Plugin self-test scope:** "smoke tests for hooks + frontmatter validator via `pytest` on the plugin's own correctness" (recommended; pytest at `dydx-delivery/tests/` per DESIGN-04 carried). Owning phase = Phase 9 (Surfaces) per CHANGE-04.

**Rationale:** ROADMAP criterion 5 says "with clear 'decide before Phase X' owners". The 3 sub-fields encode this without breaking the closed 9-field schema.

### D-53 — Synthesis structure: full reviewer-ready shape (mirrors Phase 3 03-07 pattern)

OPEN-QUESTIONS.md final shape, in document order:

1. **Preamble blockquote** with reading conventions: row schema fields, severity enum, resolution-path enum, citation format (D-14 carried), source-merging discipline (D-50), reconciliation algorithm pointer.
2. **Executive Summary** — 3-table block:
   - Severity rollup: `| Severity | Count | Notes |` (3 rows: BLOCKER / GUARDRAIL / INFORMATIONAL).
   - Owning-phase rollup: `| Phase | Count | Sample questions |` (one row per v2.x phase that owns ≥1 question).
   - Resolution-path rollup: `| Path | Count | Notes |` (5 rows matching D-49 enum).
3. **How-to-read** section — 5 bold-headed paragraphs (Document purpose / Reading conventions / Reviewer flow / Source-of-truth pointers / Phase boundary).
4. **Per-OPEN-NN H2 sections** (7 sections — `## OPEN-01: …` through `## OPEN-07: …`). Each section opens with a 1-2 sentence framing paragraph, then the per-row schema (table or per-row blocks per planner choice; closed schema either way).
5. **Appendix A: Per-phase rollup index** — `| Phase | Question IDs (OPEN-QNN) | BLOCKER count | GUARDRAIL count | INFORMATIONAL count |` enabling v2.x phases to scan their assigned rows.
6. **Appendix B: Source traceability** — `| OPEN-QN | Source citations |` enabling reviewers to verify every row maps back to AUDIT/DESIGN/CHANGELIST/REQUIREMENTS source lines.
7. **Appendix C: Reconciliation algorithm result** — terminal-state proof: `INPUT_COUNT_AFTER_DEDUP = N`, `REGISTER_ROW_COUNT = N`, `CARDINALITY_MATCH = TRUE`, `ALL_CITATIONS_VERIFIED = TRUE`, `ALL_OWNERS_ASSIGNED = TRUE`. Reproduces Phase 2 02-10 / Phase 3 03-07 reconciliation precedent.
8. **Final structural-check pass** — `bash .planning/phases/04-open-questions/scripts/openquestions-structure-check.sh` exits 0. This is the phase-exit gate.
9. **Reviewer-ready terminal-state phrase** ("OPEN-QUESTIONS.md is reviewer-ready") reserved for the synthesis plan only per cross-AI MEDIUM #7 carried.

### D-54 — Wave / plan structure: defer to planner per D-45

CONTEXT.md does NOT lock plan / wave count. Recommendation hint to gsd-planner: file-ownership on `.planning/OPEN-QUESTIONS.md` likely forces sequential waves like Phase 3 (single shared file → single writer per wave). Inputs are smaller than Phase 3 (canonical input is the 9 Appendix E bullets + 7 OPEN-NN families with closed enums) so 4-5 plans likely suffices: scaffold + 1-2 plans grouping OPEN-NN sections by homogeneity + Appendices + synthesis. Final shape stays planner discretion per D-45.

**Mandatory script artefact:** Phase 4 produces `.planning/phases/04-open-questions/scripts/openquestions-structure-check.sh` (mirror of `changelist-structure-check.sh` shape). Minimum assertion list (per D-54 contract):

- File exists, has H1, has the 8-anchor H2 list (Preamble — note: preamble is a blockquote not H2 — Executive Summary / How-to-read / OPEN-01..07 / Appendix A / Appendix B / Appendix C; assert exactly 7 OPEN-NN H2 anchors verbatim).
- Severity enum: every severity field exact-matches `BLOCKER | GUARDRAIL | INFORMATIONAL`.
- Resolution-path enum: every path field exact-matches one of the 5 D-49 values.
- Status enum: every status field exact-matches `open | proposed | decided | closed`.
- Owning-phase non-empty + matches v2.x phase enum or literal `TBD`.
- Citation count: every row has ≥1 `` `path:line` `` citation matching backtick-wrapped pattern per D-14.
- Source-merging cardinality: row count matches Appendix B traceability table row count exactly (1:1).
- Reconciliation result block: present + asserts all 5 conditions TRUE.
- No-placeholder synthesis-end pass: no `Populated by`, `TBD` (other than legitimate `owner: TBD`), `<TBD>`, `…`, or other placeholder strings remain in final document (mirror of Phase 3 C9 assertion).

### D-55 — New-question discovery during Phase 4 authoring (rare; same D-27 carry-forward applies)

Authoring may discover questions not yet in any input stream. Rule: a new question added to OPEN-QUESTIONS.md must ALSO be back-cited in any source file that motivated discovering it (typically AUDIT.md or DESIGN.md inline section), so D-27 (point of use AND closed list) holds bi-directionally. Reconciliation algorithm (D-50) accommodates new rows naturally because it walks input-streams forward + register-rows backward.

**Limit:** Phase 4 is a register-authoring phase, not a research phase. Discovery should be limited to "this question was implicit in AUDIT/DESIGN but never explicitly inline-marked". Genuine new research questions belong in `/gsd-research-phase` or a future v2.x milestone scope.

### Cross-cutting authoring decisions (carried from Phase 1 / Phase 2 / Phase 3 — restated for downstream agents)

- **D-14 (Phase 1):** All citations use `` `path:line` `` backtick-wrapped format. Verifiable via `grep -n`.
- **D-16 (Phase 1):** Per-bullet sentinel discipline where applicable. Phase 4 register rows do NOT carry the FOUND-NN sentinel (FOUND-NN belongs to cosmetic-fix Appendix B in CHANGELIST.md, not OPEN-QUESTIONS register). However, every register row carries an equivalent **owner-bound disposition sentinel**: explicit Owning phase + Verification owner field per row. No silent omission.
- **D-17 (Phase 1):** Version pin convention preserved if any version-string mismatches surface as register entries. (None expected; CHANGELIST.md already schedules these for v2.1 build per FOUND-04 / FOUND-07.)
- **D-25 (Phase 2):** Status-lifecycle survey discipline applies if any register row references live `status:` values. Source citations (D-50) include `status:` survey refs where applicable.
- **D-27 (Phase 2):** OPEN-marker carry-forward — point of use cite AND closed-list bullet. Phase 4 IS the closed-list registry; back-citation from register entry to source file maintains the "point of use" invariant.
- **D-28 (Phase 2):** Closed-enum discipline. Every Phase 4 closed enum (severity D-48, resolution-path D-49, status D-47, owning-phase from CHANGE-01) is structurally checked by D-54.
- **D-37 (Phase 3):** OPEN-01 contingent fallback wording verbatim where Phase 7-blocker rows are described.
- **D-42 (Phase 3):** Research-blocked phases flagged inline + Appendix C in CHANGELIST.md. Phase 4 register rows for these items carry `Resolution path: /gsd-research-phase <N>` per D-49.
- **D-45 (Phase 3):** Final wave / plan shape stays planner discretion; CONTEXT provides recommendation hints, not hard contracts.

### Author flow (planning shape — hint to gsd-planner)

Recommended (planner free to deviate per D-45):

- **Wave 1 (scaffold):** `openquestions-structure-check.sh` + `OPEN-QUESTIONS.md` skeleton (H1 + 8-anchor H2 list — Executive Summary / How-to-read / OPEN-01 / OPEN-02 / OPEN-03 / OPEN-04 / OPEN-05 / OPEN-06 / OPEN-07 / Appendix A / Appendix B / Appendix C — total 12 H2 anchors; preamble is blockquote not H2). Empty bodies. Structural-check designed to fail at first content-check (similar to Phase 3 Wave 1 invariant).
- **Wave 2 (research-flagged + connector items):** populate OPEN-01 + OPEN-02 sections — these are the heaviest sections (~12-15 rows combined; mostly research-blocked → `/gsd-research-phase` resolution).
- **Wave 3 (design-deferred + hub-link + Coda-templates):** populate OPEN-03 + OPEN-04 + OPEN-05.
- **Wave 4 (policy decisions):** populate OPEN-06 + OPEN-07.
- **Wave 5 (synthesis):** preamble + Executive Summary + How-to-read + Appendix A per-phase rollup + Appendix B traceability + Appendix C reconciliation algorithm result block + final structural-check exits 0 + reviewer-ready phrase.

5-wave shape is a hint, not a contract. Planner may merge waves (e.g., 3-plan: scaffold / populate-all / synthesis) if file-ownership analysis shows no parallelism gain in splitting.

### Claude's Discretion

Planner agent may:

- Choose markdown table vs per-row block format for register entries (both satisfy D-47 9-field schema; choose whichever scans better given column widths).
- Re-order OPEN-NN sections within OPEN-01..07 if a different order surfaces dependencies more clearly (e.g., research items before design-deferred items).
- Add a 4th severity tier ONLY if Phase 4 authoring discovers a genuine 4th class that doesn't fit BLOCKER / GUARDRAIL / INFORMATIONAL — checkpoint required + D-N add (D-56).
- Subdivide OPEN-04 into multiple sub-rows if Jason's live workstream materialises a tracker source-of-truth during authoring.

Planner agent must NOT:

- Re-decide owning-phase assignments from CHANGELIST.md inline markers (those are locked).
- Skip the reconciliation algorithm (Appendix C) — it's the terminal-state gate.
- Introduce new D-N decisions outside D-46..D-55 without checkpoint.
- Add a 4th severity tier or 6th resolution path without explicit user sign-off.

</decisions>

<canonical_refs>

## Canonical References

### Phase scope and requirements

- `.planning/ROADMAP.md` Phase 4 section — success criteria 1-5 (lines around `### Phase 4: Open questions register`).
- `.planning/REQUIREMENTS.md` § "Open questions register (OPEN-QUESTIONS.md)" — OPEN-01..07 verbatim text (lines 88-96).

### Output deliverable (what this phase produces)

- `.planning/OPEN-QUESTIONS.md` (created by Phase 4 plans).
- `.planning/phases/04-open-questions/scripts/openquestions-structure-check.sh` (created by Phase 4 Wave 1).

### Ground truth (OPEN-QUESTIONS.md cites these for register-row sources; does NOT re-derive)

- `.planning/CHANGELIST.md` Appendix E (lines 269-287) — closed list of 9 inline `[OPEN: Phase 4 — ...]` markers; D-27 carry-forward authoritative input.
- `.planning/CHANGELIST.md` Appendix C (research-blocked phases) — Phase 1 + Phase 7 entries with verbatim D-37 OPEN-01 fallback wording.
- `.planning/CHANGELIST.md` per-phase mini-tables — Research-blocked cells carry inline markers cross-referenced from Appendix E.
- `.planning/DESIGN.md` § "Deferred to Phase 4 OPEN-QUESTIONS" closed list — 8 baseline bullets (superseded by CHANGELIST.md Appendix E for register input; cited for traceability).
- `.planning/AUDIT.md` § AUDIT-08 live MCP probe results — connector-availability uncertainty source for OPEN-02.
- `.planning/AUDIT.md` § AUDIT-04 — referenced-but-missing artefacts (informs OPEN-02 + OPEN-05).

### Research context (OPEN-QUESTIONS.md grounds research-blocked rows in this; cites without re-authoring)

- `.planning/research/SUMMARY.md` § "Phase Ordering Rationale" — Phase 1 + Phase 7 research-blocked sections.
- `.planning/research/PITFALLS.md` (CRIT-/MOD-/MIN- families) — pitfall IDs cross-referenced from register rows where applicable.

### Codebase context (live state OPEN-QUESTIONS.md must respect)

- `.planning/phases/01-audit/scripts/audit-structure-check.sh` — pattern reference for Phase 4's structural-check script.
- `.planning/phases/02-design/scripts/design-structure-check.sh` — pattern reference (more assertions than Phase 1; Phase 4 lands between Phase 1 and Phase 3 in assertion count).
- `.planning/phases/03-changelist/scripts/changelist-structure-check.sh` — closest precedent (15 assertions, stateful `section_between` helper, closed-enum regex anchors); Phase 4 mirrors this shape.

### Prior phase context (decisions carried forward — see `<decisions>` "Cross-cutting" section)

- `.planning/phases/01-audit/01-CONTEXT.md` — D-14, D-15, D-16, D-17.
- `.planning/phases/02-design/02-CONTEXT.md` — D-25, D-27, D-28.
- `.planning/phases/03-changelist/03-CONTEXT.md` — D-36..D-45 (especially D-37, D-39, D-42, D-45).
- `.planning/phases/03-changelist/03-VERIFICATION.md` — Phase 3 verifier PASS 12/12; reconciliation algorithm precedent at row 9.

### v0.3.0 source surfaces (cited only when AUDIT.md is silent — AUDIT.md is the preferred citation source)

- `dydx-delivery/SKILL.md` (and per-skill SKILL.md files) — for OPEN-06 `/refine-<skill>` orphan-reference inventory.
- `dydx-delivery/.claude-plugin/plugin.json` + `marketplace.json` — for OPEN-07 self-test scope (plugin's own correctness target).

</canonical_refs>

<code_context>

## Existing Code Insights

### Reusable Assets

- **Structural-check pattern (3 precedents):** `.planning/phases/01-audit/scripts/audit-structure-check.sh`, `.planning/phases/02-design/scripts/design-structure-check.sh`, `.planning/phases/03-changelist/scripts/changelist-structure-check.sh`. Phase 4's `openquestions-structure-check.sh` should mirror the Phase 3 shape: `fail()` helper, stateful `section_between()` extraction helper, closed-enum regex anchors, exits 0 only when all assertions pass.
- **Reconciliation algorithm precedent:** Phase 2 02-10 PLAN.md Task 2 (cross-AI HIGH #3 fix) and Phase 3 03-07 Task 3 (Appendix E reconciliation expanded to 9 per D-27). Both implementations walk input-stream → dedup → register → assert cardinality + diff + ownership. Phase 4 reuses the algorithm shape; only the input-stream count + dedup-key change.
- **OPEN-marker grep idiom:** `grep -nF '[OPEN: Phase 4' .planning/CHANGELIST.md` enumerates the 9 Appendix E source markers; useful in `openquestions-structure-check.sh` Appendix B traceability assertion.

### Established Patterns (carried into OPEN-QUESTIONS.md)

- **Citation format (D-14):** `` `path:line` `` backtick-wrapped, verifiable via `grep -n`.
- **Closed-enum discipline (D-28):** Every register field uses a closed enum (severity D-48, resolution-path D-49, status D-47, owning-phase from CHANGE-01). Structural-check enforces.
- **Sentinel-equivalent discipline (D-16 spirit):** Per-row Owning-phase + Verification-owner fields are the OPEN-QUESTIONS register's equivalent of Appendix B's per-bullet FOUND-NN sentinel. No silent omission.
- **Reviewer-ready terminal-state (cross-AI MEDIUM #7):** Phrase reserved for synthesis plan only.
- **Atomic-commit-per-task discipline (per execute-plan workflow):** Conventional commit format + co-author trailer; never amend; never skip hooks.
- **D-N numbering** picks up at D-46.

### Integration Points

- **CHANGELIST.md Appendix E** is the authoritative pre-walk input (9 bullets). Phase 4 reads this once at scaffold time.
- **REQUIREMENTS.md OPEN-01..07** is the requirement-level input (7 IDs). Phase 4 maps each H2 anchor 1:1.
- **ROADMAP.md Phase 4 success criteria 1-5** are the verifier's must-have set. Phase 4 verifier (gsd-verifier) checks them per success-criterion.
- **Future v2.x build phases** consume OPEN-QUESTIONS.md by `grep`-ing on `Owning phase: Phase <N>` to find their assigned backlog. Phase 4 must therefore use exact-match phrasing for owning-phase fields (no fuzzy variants).

</code_context>

<specifics>

## Specific Ideas

- **Mechanical generation, not interpretive:** Phase 4 should look mechanical — every register row is sourced, owned, and resolution-pathed. If a row reads as opinion, the citation field is missing.
- **Severity should be assigned, not derived:** BLOCKER vs GUARDRAIL vs INFORMATIONAL is a Phase 4 authoring call, but it must be defensible against the source citation. Where Phase 3's Appendix E inline marker calls something a "HARD BLOCKER" (e.g., OPEN-01 native-AI per D-37), Phase 4 must mirror that severity literally.
- **OPEN-01 native-AI ingestion is the heaviest single section:** 3 distinct API verification rows (Pipefy AI KB / Wrike AI Studio / Ziflow ReviewAI) all severity = BLOCKER, all owner = Phase 7, all resolution-path = `/gsd-research-phase 7`. Plus 5 more research-flagged items at GUARDRAIL severity. Total OPEN-01 likely 8 rows.
- **OPEN-02 connector-availability:** 3-4 rows (Coda MCP / Google Workspace MCP / Miro MCP / Wrike auth header). All severity = GUARDRAIL or INFORMATIONAL (Phase 1 connector probe is the resolution path). Owner = Phase 1.
- **OPEN-03 design-deferred:** 4 rows (risk-multiplier defaults / frontmatter migration cutover / status-lifecycle survey / plugin self-test scope). Note: plugin self-test scope appears in BOTH OPEN-03 and OPEN-07 — dedup per D-50 to a single canonical row referenced from both sections (or section-canonicalised under OPEN-07 which is its primary home).
- **OPEN-04 hub-link backfill:** single canonical row per D-51 (pointer-only). May expand to 2-row if Jason's live tracker source materialises during authoring.
- **OPEN-05 Coda templates:** 3 rows (brain-mirror template / task-table template / `00_HUB.md` Coda block schema). All owner = Phase 8, all resolution-path = `Coda-template-authoring (Phase 8)`. Severity likely INFORMATIONAL (recommended defaults shippable; templates author-as-built).
- **OPEN-06 + OPEN-07 policy:** 2 single rows total. Both severity = INFORMATIONAL (recommended defaults are shippable; `policy-pending-sign-off` resolution). OPEN-06 sub-decision (namespace `/dydx-refine-*` vs `/refine-*`) is a 2nd row OR a sub-bullet on the canonical row.
- **Total expected register size:** ~22-28 canonical rows after dedup. Sanity-check: significantly less than the raw input multiset (9 + 8 + ~12 + 5 = ~34 input rows pre-dedup) because Appendix E and OPEN-01 overlap heavily.
- **Approval gate signal pattern:** Same as prior phases — explicit go-ahead from user (e.g., "approved" in chat or commit message). Phase 4 approval = milestone-design-complete.

</specifics>

<deferred>

## Deferred Ideas

- **Live-workstream tracker source-of-truth for hub-link backfill** — pointer needs a real URL/path. Captured in OPEN-04 itself with `pointer source TBD` sub-bullet; resolved by Jason during v2.1 Foundations build kickoff. Not Phase 4's job to find the tracker.
- **OPEN-NN ID renumbering** — register-internal `OPEN-Q01..QNN` IDs are NEW (not the same as REQUIREMENTS.md OPEN-01..07 requirement IDs). Some readers may want collapsed IDs; collapsed-ID variants are a v2.1 concern, not Phase 4.
- **Per-row "last-verified" timestamp** — useful for v2.x build phases to know if a row has been re-checked. Phase 4 ships rows with no timestamps; v2.x build phases add `last_checked_at:` per row when they refresh. Out of scope for v2.0 milestone.
- **Cross-milestone open-question carry-forward** — questions that survive v2.0 → v2.1+ unresolved. Phase 4 ships them in OPEN-QUESTIONS.md `status: open`; v2.1 milestone definition decides which carry forward into a v2.1 register. Not Phase 4's call.
- **Register render as JSON / YAML alongside markdown** — programmatic consumption by v2.x phases. Captured as a v2.1 Foundations build idea; OPEN-QUESTIONS.md is markdown-only in v2.0.
- **Auto-generated Appendix B from grep on inline markers** — could mechanise traceability authoring. Phase 4 v2.0 ships hand-authored Appendix B; mechanisation is a v2.1+ tooling concern.

</deferred>

---

*Phase 4 CONTEXT.md gathered 2026-05-10 by Claude proposing recommended defaults across 9 gray areas (A1..A9). User approval pattern: "I'll propose recommended defaults; you review" — selected at start of discuss-phase. No interactive deep-dive performed; all decisions are Phase 1-3 precedent extrapolations grounded in CHANGELIST.md Appendix E + REQUIREMENTS.md OPEN-01..07 + ROADMAP success criteria 1-5.*
