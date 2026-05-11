---
phase: 04-open-questions
plan: 04
subsystem: planning-artefacts
tags: [open-questions, OPEN-06, OPEN-07, policy, refine-resolution, plugin-self-test, design-only, wave-4]
requirements: [OPEN-06, OPEN-07]
dependency_graph:
  requires:
    - .planning/phases/04-open-questions/04-01-SUMMARY.md (Wave 1 scaffold + structural-check shipped)
    - .planning/phases/04-open-questions/04-02-SUMMARY.md (Wave 2 OPEN-01 + OPEN-02 populated, 15 rows)
    - .planning/phases/04-open-questions/04-03-SUMMARY.md (Wave 3 OPEN-03 + OPEN-04 + OPEN-05 populated, 22 rows)
    - .planning/OPEN-QUESTIONS.md (carrying OPEN-01..05 from Waves 2+3)
  provides:
    - .planning/OPEN-QUESTIONS.md `## OPEN-06` body populated with 2 register rows (OPEN-Q21 main decision + OPEN-Q21.1 namespace sub-decision decimal-ID)
    - .planning/OPEN-QUESTIONS.md `## OPEN-07` body populated with 1 canonical register row (OPEN-Q22 — ID locked by OPEN-03 forward cross-reference)
    - cumulative register total 25 rows (Wave 2: 15 + Wave 3: 7 + Wave 4: 3)
  affects:
    - Plan 04-05 (Wave 5 — synthesis; consumes 25 rows for Appendix A/B/C reconciliation; Appendix B numerical sort handles decimal IDs Q06.1/Q06.2/Q07.1/Q07.2/Q21.1)
tech_stack:
  added: []
  patterns:
    - per-row block form for D-47 9-field schema (unbolded field labels match script regex; precedent established Wave 2)
    - decimal-form sub-row IDs (precedent Q06.1/Q06.2/Q07.1/Q07.2 from Wave 2; Wave 4 emits Q21.1)
    - D-52 sub-field embedding inside Proposed-default field (4 nested markdown-list sub-fields; preserves closed 9-field schema)
    - D-50 cross-reference resolution (OPEN-03 → OPEN-Q22 forward reference now lands)
    - inline-anchor-citation rule from Wave 3 — narrative prose uses `OPEN-NN H2 anchor (description)` phrasing rather than full literal `## OPEN-NN: <description>` substring (preserves A2 H2-uniqueness)
key_files:
  created:
    - .planning/phases/04-open-questions/04-04-SUMMARY.md
  modified:
    - .planning/OPEN-QUESTIONS.md
decisions:
  - D-46 carried — primary-by-OPEN-NN H2 layout exercised in OPEN-06 + OPEN-07 bodies
  - D-47 carried — closed 9-field per-row block form; all 3 new rows carry all 8 named fields
  - D-48 carried — severity 3-tier closed enum; all 3 new rows = INFORMATIONAL (recommended defaults are shippable per D-52)
  - D-49 carried — resolution-path 5-value closed enum; new enum value `policy-pending-sign-off` exercised on all 3 new rows (5th and final enum value reached — full enum coverage at Wave 4)
  - D-50 carried — OPEN-03 forward cross-reference (`See OPEN-Q22`) now resolves to canonical home in OPEN-07
  - D-52 — sub-field discipline applied: every Wave 4 row's Proposed-default field embeds Recommendation / Decision deadline / Acceptance signal / Fallback-if-undecided as nested markdown-list (NOT extra top-level columns — preserves closed 9-field schema)
  - D-14 (carried) — backtick-wrapped path:line citation pattern; 6 new path:line citations across 3 rows
  - cross-AI C2 (carried) — OPEN-Q21.1 decimal-ID counted by structural-check A4 regex `OPEN-Q[0-9]+(\.[0-9]+)?` (Wave 1 fix)
  - cross-AI C5 (carried) — citation line numbers grounded against current file lengths; manual A14 line-validity confirmed for all 6 new citations
  - cross-AI C6 (carried) — single-owner only; zero hybrid-owner literal globally
  - cross-AI C7 (carried) — platform-neutral wording in Proposed-default fields ("edit file at path", "explicit go-ahead in chat or commit message")
  - cross-AI C8 (carried) — proposed-default fields stay register-only; recommended defaults track REQUIREMENTS.md verbatim text without prescribing destinations beyond what REQUIREMENTS already specifies
metrics:
  duration_minutes: ~12
  tasks_completed: 3
  files_created: 1
  files_modified: 1
  commits: 3
  date_completed: 2026-05-10
---

# Phase 4 Plan 04: Wave 4 OPEN-06 + OPEN-07 register-row population Summary

**Plan 04-04 — Wave 4 OPEN-06 + OPEN-07 population — executed 2026-05-10 — outcome: COMPLETE.**

Wave 4 lands 3 new register rows in `.planning/OPEN-QUESTIONS.md` across `## OPEN-06: /refine-<skill> resolution` (2 rows: OPEN-Q21 main decision + OPEN-Q21.1 namespace sub-decision decimal-ID) and `## OPEN-07: Plugin self-test scope` (1 row: OPEN-Q22 — ID locked by OPEN-03 forward cross-reference from Plan 04-03). Cumulative register total now **25 rows** (Wave 2: 15 + Wave 3: 7 + Wave 4: 3), well above the cross-AI C4 floor of 21. All rows conform to the D-47 closed 9-field schema; all severity / resolution-path / status / owning-phase fields exact-match closed enums; all rows carry ≥ 1 backtick-wrapped `path:line` citation per D-14. The fifth and final D-49 resolution-path enum value (`policy-pending-sign-off`) is now exercised — full enum coverage achieved at Wave 4. ROADMAP Phase 4 success criterion 5 ("with clear 'decide before Phase X' owners") is satisfied via the D-52 sub-field discipline (Decision deadline embedded in every policy row).

## Sections populated

| Section | Row count | Severity breakdown | Resolution paths | Owning phases |
|---------|-----------|--------------------|--------------------|---------------|
| OPEN-06 | 2 | 2 INFORMATIONAL | `policy-pending-sign-off` (×2) | Phase 1 (×2) |
| OPEN-07 | 1 | 1 INFORMATIONAL | `policy-pending-sign-off` (×1) | Phase 9 (×1) |
| **Wave 4 new** | **3** | **0 BLOCKER + 0 GUARDRAIL + 3 INFORMATIONAL** | `policy-pending-sign-off` (×3) | Phase 1 (×2) + Phase 9 (×1) |
| **Cumulative (after Wave 4)** | **25** | **3 BLOCKER + 4 GUARDRAIL + 18 INFORMATIONAL** | 5 of 5 enum values exercised (full coverage) | 7 distinct phases |

## OPEN-Q21.1 decimal-ID confirmed counted (cross-AI C2)

The OPEN-Q21.1 namespace sub-decision row uses decimal-form ID per Wave 2 precedent (Q06.1/Q06.2/Q07.1/Q07.2). Plan 04-01 fixed the structural-check A4/A10/A14 regex to `OPEN-Q[0-9]+(\.[0-9]+)?` so decimal-ID rows are NOT silently dropped. Verification:

```
$ grep -cE '^\*\*OPEN-Q[0-9]+(\.[0-9]+)?\*\*' .planning/OPEN-QUESTIONS.md
25
$ grep -cF 'OPEN-Q21.1' .planning/OPEN-QUESTIONS.md
2
```

The decimal-ID row is counted in the register total of 25 (≥ A4 floor 21). T-04-15 mitigated. Two literal `OPEN-Q21.1` occurrences = the row ID line + the conditional cross-reference inside OPEN-Q21.1's Proposed-default ("only relevant if OPEN-Q21 = build").

## OPEN-Q22 ID lock — OPEN-03 cross-reference now resolves (D-50)

Plan 04-03 emitted a forward cross-reference at the end of OPEN-03 body: `See OPEN-Q22 (assigned at Wave 4 / Plan 04-04)`. Plan 04-04 honoured this by assigning OPEN-Q22 strictly to the OPEN-07 row (T-04-14 mitigated). Verification:

```
$ grep -cF 'OPEN-Q22' .planning/OPEN-QUESTIONS.md
3
$ awk -v hdr='## OPEN-07: Plugin self-test scope' 'f && /^## /{exit} f{print} index($0,hdr)==1 && /^## /{f=1}' .planning/OPEN-QUESTIONS.md | grep -cF '**OPEN-Q22**'
1
```

3 occurrences = OPEN-03 cross-reference blockquote + OPEN-07 cross-reference blockquote (linking back to OPEN-03 source) + OPEN-07 row ID line. The forward reference from Wave 3 now resolves; D-50 source-merging discipline preserved (single canonical row in OPEN-07; OPEN-03 forwards readers to it).

## D-52 sub-field discipline (closed-schema preservation)

D-52 prescribes that policy-decision rows (OPEN-06 + OPEN-07) embed 4 sub-fields inside the Proposed-default field as a nested markdown-list — NOT as separate top-level row fields — so the D-47 closed 9-field schema is preserved. All 3 Wave 4 rows carry all 4 sub-fields:

```
$ grep -cF 'Recommendation:' .planning/OPEN-QUESTIONS.md  # 3 (Wave 4 only — sub-field label)
$ grep -cF 'Decision deadline' .planning/OPEN-QUESTIONS.md
5
$ grep -cF 'Acceptance signal' .planning/OPEN-QUESTIONS.md
5
$ grep -cF 'Fallback-if-undecided' .planning/OPEN-QUESTIONS.md
5
```

Decision deadline / Acceptance signal / Fallback-if-undecided counts of 5 = 3 row body occurrences + 2 OPEN-06 section preamble references (D-52 sub-field naming for reader orientation). All Wave 4 rows pass the D-52 sub-field acceptance criteria. T-04-16 mitigated.

## Verbatim REQUIREMENTS.md recommended-default discipline

Both OPEN-Q21 + OPEN-Q22 lift the recommended default verbatim from REQUIREMENTS.md per D-52:

```
$ grep -qF 'build single parameterised command' .planning/OPEN-QUESTIONS.md && echo OPEN_06_VERBATIM_OK
OPEN_06_VERBATIM_OK
$ grep -qF 'smoke tests for hooks + frontmatter validator' .planning/OPEN-QUESTIONS.md && echo OPEN_07_VERBATIM_OK
OPEN_07_VERBATIM_OK
$ grep -qF 'pytest' .planning/OPEN-QUESTIONS.md && echo PYTEST_PRESENT
PYTEST_PRESENT
```

T-04-17 mitigated.

## Closed-enum verification (full document state, post-Wave-4)

| Enum | Field | Total fields document-wide | Off-enum literals |
|------|-------|----------------------------|-------------------|
| D-48 severity | `Severity:` | 25/25 (3 BLOCKER + 4 GUARDRAIL + 18 INFORMATIONAL) | 0 |
| D-49 resolution-path | `Resolution path:` | 25/25 (`/gsd-research-phase <N>` ×15 + `decide-before-Phase-<N>` ×3 + `live-workstream-pointer` ×1 + `Coda-template-authoring (Phase 8)` ×3 + `policy-pending-sign-off` ×3) | 0 |
| D-47 status | `Status:` | 25/25 (3 open + 22 proposed) | 0 |
| D-47 owning-phase (cross-AI C6 tightened) | `Owning phase:` | 25/25 (`Phase [1-9]` only) | 0 hybrid `Phase 1/Phase 2` |

```
$ grep -cE 'Severity:[[:space:]]*(BLOCKER|GUARDRAIL|INFORMATIONAL)' .planning/OPEN-QUESTIONS.md
25
$ grep -cE 'Resolution path:[[:space:]]*(/gsd-research-phase [0-9]+|decide-before-Phase-[0-9]+|Coda-template-authoring \(Phase 8\)|policy-pending-sign-off|live-workstream-pointer)' .planning/OPEN-QUESTIONS.md
25
$ grep -cE 'Status:[[:space:]]*(open|proposed|decided|closed)' .planning/OPEN-QUESTIONS.md
25
$ grep -cE 'Owning phase:[[:space:]]*(Phase [1-9]|TBD)[[:space:]]*$' .planning/OPEN-QUESTIONS.md
25
$ grep -nF 'Owning phase: Phase 1/Phase 2' .planning/OPEN-QUESTIONS.md
(no output)
```

C6 hybrid-owner banned globally — confirmed at 25 rows. T-04-18 mitigated.

**Full D-49 enum coverage achieved.** The `policy-pending-sign-off` value (5th and final D-49 enum) is now exercised by 3 rows (OPEN-Q21 + OPEN-Q21.1 + OPEN-Q22). All 5 enum values now have register-row backing — Wave 5 reconciliation in Plan 04-05 will reflect this in the resolution-path rollup table.

## Citation discipline (Wave 4)

```
$ grep -cE '`\.planning/[A-Za-z0-9_./-]+\.md:[0-9]+`' .planning/OPEN-QUESTIONS.md
24
$ grep -oE '`\.planning/[A-Za-z0-9_./-]+\.md:[0-9]+`' .planning/OPEN-QUESTIONS.md | wc -l
39
```

`grep -c` counts matching LINES (multi-citation source-citation lines collapse to 1) — total backtick-wrapped citation OCCURRENCES are 39 across 25 rows. Wave 4 added 6 new occurrences across 3 new rows (OPEN-Q21: 3 cites — REQUIREMENTS:95 + DESIGN:132 + AUDIT:287; OPEN-Q21.1: 3 cites — REQUIREMENTS:95 + DESIGN:132 + DESIGN:139; OPEN-Q22: 3 cites — REQUIREMENTS:96 + DESIGN:122 + CHANGELIST:160). Note OPEN-Q21.1 + OPEN-Q22 also reference additional path:line citations inside their Proposed-default Recommendation sub-fields (DESIGN:139 in Q21.1; DESIGN:122 + CHANGELIST:160 in Q22), bringing total Wave-4 occurrences higher when counted globally — these are reader-orientation references not separate citation rows.

All 6 new citations manually line-validity-checked against current file lengths at execution time:

- `.planning/REQUIREMENTS.md` (229 lines) — Wave 4 cites :95 (OPEN-06 verbatim) + :96 (OPEN-07 verbatim) — both in-range ✓
- `.planning/DESIGN.md` (1608 lines) — Wave 4 cites :122 (DESIGN-04 plugin self-tests subsection) + :132 (DESIGN-05 heading) + :139 (DESIGN-05 namespace lock) — all in-range ✓
- `.planning/AUDIT.md` (643 lines) — Wave 4 cites :287 (AUDIT-04 §4.2 /refine-<skill> orphan-references heading) — in-range ✓
- `.planning/CHANGELIST.md` (291 lines) — Wave 4 cites :160 (Phase 9 mini-table Deliverables row, item g optional plugin self-tests) — in-range ✓

## Mid-phase structural-check first-fail

Verbatim output:

```
$ bash .planning/phases/04-open-questions/scripts/openquestions-structure-check.sh
FAIL: Appendix B row count 0 != register total 25 (D-53 1:1 cardinality)
EXIT=1
```

**A10 first-fail is expected per Wave 4 invariant.** Appendices B + C are still empty (Wave 5 / Plan 04-05 owns synthesis). Earlier assertions A1-A9 all PASS:

- A1 (12 required H2 anchors present) ✓
- A2 (every required H2 anchor unique — 1 occurrence each) ✓
- A3 (exactly 7 OPEN-NN H2 anchors) ✓
- A4 (register row/block count 25 ≥ 21 floor per cross-AI C4) ✓ — well above floor (Wave 3 was 22; Wave 4 added 3)
- A5 (severity closed enum — 25/25 conforming, 0 off-enum) ✓
- A6 (resolution-path closed enum — 25/25 conforming, 0 off-enum; full 5-value enum coverage now achieved) ✓
- A7 (status closed enum — 25/25 conforming, 0 off-enum) ✓
- A8 (owning-phase enum tightened, single-owner only — 25/25 conforming, 0 hybrid) ✓
- A9 (citation count 39 ≥ register total 25) ✓

A10/A11/A13 will continue to fail until Wave 5 synthesis populates Appendix B/C and removes the remaining `Populated by 04-05` notes from Executive Summary + How-to-read + Appendix A/B/C. A14 SAMPLE pass does not fire because the script fails-fast at A10 — but manual line-validity check (above) confirms all 6 new Wave 4 citations are line-valid; the script's A14 SAMPLE pass will succeed when reached at Wave 5 synthesis (after Appendix B/C populate).

## Decisions implemented

| Decision | Application |
|---------|-------------|
| **D-46** | OPEN-06 + OPEN-07 H2 anchors carry register rows; primary-by-OPEN-NN layout exercised |
| **D-47** | Per-row block form (8 field labels + bolded row ID) — closed 9-field schema across 3 new rows |
| **D-48** | Severity = INFORMATIONAL across all 3 Wave 4 rows (recommended defaults are shippable per D-52) |
| **D-49** | New enum value `policy-pending-sign-off` exercised (×3); full 5-value enum coverage now achieved across 25 rows |
| **D-50** | OPEN-03 → OPEN-Q22 forward cross-reference now resolves (single canonical row in OPEN-07; reverse cross-reference in OPEN-07 preamble points back to OPEN-03 source) |
| **D-52** | Sub-field discipline applied: 4 sub-fields embedded in Proposed-default (Recommendation / Decision deadline / Acceptance signal / Fallback-if-undecided) — NOT extra top-level columns; preserves closed 9-field schema. Verbatim REQUIREMENTS.md recommended defaults lifted. |
| **D-14** carried | Every citation backtick-wrapped `path:line` |
| **cross-AI C2** carried | OPEN-Q21.1 decimal-ID counted by structural-check A4 regex (Wave 1 fix); register total reaches 25 with decimal-ID counted |
| **cross-AI C5** carried | Line numbers grounded; manual A14 line-validity confirmed for all 6 new citations |
| **cross-AI C6** carried | Single-owner only; 0 hybrid `Phase 1/Phase 2` literal globally at 25 rows |
| **cross-AI C7** carried | Platform-neutral wording in Proposed-default fields ("explicit go-ahead in chat or commit message") |
| **cross-AI C8** carried | Proposed-default fields stay register-only; verbatim REQUIREMENTS.md recommendations lifted without destination overreach |

## Hand-off to Wave 5

**Plan 04-05 (Wave 5)** owns synthesis:

- **Preamble** — finalise top-of-document preamble (replace placeholder)
- **Executive Summary 3-table** — Severity rollup (3 BLOCKER + 4 GUARDRAIL + 18 INFORMATIONAL = 25); Owning-phase rollup (7 distinct phases); Resolution-path rollup (full 5-value enum coverage exercised)
- **How to read this register** — 5 bold-headed paragraphs
- **Appendix A: Per-phase rollup index** — `| Phase | Question IDs | BLOCKER | GUARDRAIL | INFORMATIONAL |` (one row per phase that owns ≥ 1 question)
- **Appendix B: Source traceability** — `| OPEN-QN | Source citations |` 1:1 cardinality with 25 register rows per D-53; sorted numerically by OPEN-QNN per cross-AI G2 (handles decimal IDs Q06.1/Q06.2/Q07.1/Q07.2/Q21.1)
- **Appendix C: Reconciliation algorithm result** — REAL terminal-state proof block per cross-AI C3 (NOT assumed equality): INPUT_COUNT_AFTER_DEDUP / REGISTER_ROW_COUNT / CARDINALITY_MATCH=TRUE / ALL_CITATIONS_VERIFIED=TRUE / ALL_OWNERS_ASSIGNED=TRUE
- **ROADMAP success-criteria walk** — confirm all 5 ROADMAP Phase 4 success criteria met (criterion 5 — "decide before Phase X owners" — already satisfied via D-52 sub-fields)
- **Final structural-check exits 0** — A1-A14 all PASS; A14 SAMPLE pass fires (citations real)
- **Reviewer-ready terminal-state phrase** appended

**Numbering directive for Plan 04-05:** No new register rows; synthesis-only. Appendix B numerical sort MUST place decimal IDs correctly (Q06 < Q06.1 < Q06.2 < Q07 < Q07.1 < Q07.2 < Q08 < ... < Q21 < Q21.1 < Q22) per cross-AI G2.

**Inline-citation-anchor rule (carried from Wave 3):** When citing an `## OPEN-NN: <description>` H2 anchor inline in narrative or blockquote text, use the phrasing `OPEN-NN H2 anchor (<description>)` rather than the full literal `## OPEN-NN: <description>` substring. The structural-check A2 uses `grep -cF` literal substring match; this rule prevents accidental A2 false-positive failure. Wave 4 honoured this rule throughout — see OPEN-07 preamble + cross-reference blockquote.

## Deviations from Plan

None — plan executed exactly as written. The plan's `<interfaces>` block prescribed Citation field text with `<DESIGN-04 line>` / `<AUDIT-04 referenced-but-missing artefacts /refine-<skill> line>` / `<DESIGN-04 plugin surfaces line>` / `<Phase 9 mini-table line>` placeholders to be resolved at execution time per cross-AI C5 grounding discipline; resolved values:

- `.planning/REQUIREMENTS.md:95` (OPEN-06 verbatim row) — verified via `grep -nF '**OPEN-06**' .planning/REQUIREMENTS.md`
- `.planning/REQUIREMENTS.md:96` (OPEN-07 verbatim row) — verified
- `.planning/DESIGN.md:122` (DESIGN-04 plugin self-tests subsection — pytest at `dydx-delivery/tests/`)
- `.planning/DESIGN.md:132` (DESIGN-05 heading — `/refine-<skill>` resolution)
- `.planning/DESIGN.md:139` (DESIGN-05 namespace lock — `/dydx-refine-*` not bare `/refine-*`)
- `.planning/AUDIT.md:287` (AUDIT-04 §4.2 `/refine-<skill>` orphan-references heading)
- `.planning/CHANGELIST.md:160` (Phase 9 mini-table Deliverables row, item g optional plugin self-tests)

These resolutions are line-valid against current file lengths (REQUIREMENTS:229, DESIGN:1608, AUDIT:643, CHANGELIST:291); all citations passed manual A14 line-validity check.

The plan's `<interfaces>` example also referenced `parameterised refine.md command` per `DESIGN-04`; the actual canonical home for refine-pattern resolution is DESIGN-05 (DESIGN-04 covers plugin surfaces in general; DESIGN-05 is the dedicated refine resolution heading at `.planning/DESIGN.md:132`). OPEN-Q21 + OPEN-Q21.1 cite DESIGN-05 (line 132 + 139) directly; OPEN-Q22 cites DESIGN-04 plugin self-tests subsection (line 122) directly. Both citations are correct against the actual DESIGN.md structure — DESIGN-05 is the more precise citation for refine-pattern; DESIGN-04 plugin self-tests subsection is the more precise citation for plugin self-tests. This is a citation-precision improvement, not a deviation from plan intent.

## Self-Check: PASSED

- `.planning/OPEN-QUESTIONS.md` (modified) — FOUND
- `.planning/phases/04-open-questions/04-04-SUMMARY.md` — FOUND (this file)
- Commit `c31634f` (OPEN-06 — 2 rows OPEN-Q21 + OPEN-Q21.1) — VERIFIED via git log
- Commit `5b2c7f0` (OPEN-07 — 1 row OPEN-Q22) — VERIFIED via git log
- (Pending Task-3 commit — this SUMMARY)
- Mid-phase structural-check exit code — VERIFIED NON-ZERO (1) at A10 (`Appendix B row count 0 != register total 25`) — Wave 4 invariant met (A1-A9 all PASS; A4 floor 21 met with 25 rows)
- Cumulative register row count (script regex) — 25 ✓
- New Wave 4 row count — 3 ✓ (target 2-3, exact upper bound)
- Phase 9 owner total — 1 ✓ (OPEN-Q22)
- `policy-pending-sign-off` total — 5 (3 register rows + 2 OPEN-06/OPEN-07 section preamble references — actual register rows confirmed 3 via grep on Resolution-path field) ✓
- OPEN-Q22 forward-reference resolved — 3 occurrences (OPEN-03 cross-reference + OPEN-07 preamble + OPEN-07 row ID) ✓
- OPEN-Q21.1 decimal-ID counted by cross-AI C2 regex — 2 occurrences (row ID + conditional cross-reference) ✓
- Hybrid-owner literal `Phase 1/Phase 2` — absent ✓
- All 6 new Wave 4 citations manually line-validity-checked — PASS
- Inline-citation-anchor rule honoured throughout (Wave 3 invariant carried) — confirmed via post-write A2 PASS
