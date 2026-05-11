---
phase: 04-open-questions
plan: 03
subsystem: planning-artefacts
tags: [open-questions, OPEN-03, OPEN-04, OPEN-05, design-deferred, hub-link, coda-templates, design-only, wave-3]
requirements: [OPEN-03, OPEN-04, OPEN-05]
dependency_graph:
  requires:
    - .planning/phases/04-open-questions/04-01-SUMMARY.md (Wave 1 scaffold + structural-check shipped)
    - .planning/phases/04-open-questions/04-02-SUMMARY.md (Wave 2 OPEN-01 + OPEN-02 populated, 15 rows)
    - .planning/OPEN-QUESTIONS.md (carrying OPEN-01 + OPEN-02 from Wave 2)
  provides:
    - .planning/OPEN-QUESTIONS.md `## OPEN-03` body populated with 3 design-deferred rows + cross-reference blockquote forwarding plugin self-test scope to OPEN-Q22
    - .planning/OPEN-QUESTIONS.md `## OPEN-04` body populated with single canonical row per D-51 + sub-row reservation
    - .planning/OPEN-QUESTIONS.md `## OPEN-05` body populated with 3 Coda-template rows; all Phase 8 owner; all Coda-template-authoring resolution
    - cumulative register total 22 rows (Wave 2: 15 + Wave 3: 7)
  affects:
    - Plan 04-04 (Wave 4 — populates OPEN-06 + OPEN-07; MUST assign OPEN-Q21 to OPEN-06 first row + OPEN-Q22 to OPEN-07 plugin self-test row to honour OPEN-03 cross-reference)
    - Plan 04-05 (Wave 5 — synthesis; consumes 22 rows for Appendix A/B/C reconciliation; reconciliation algorithm accommodates 1-row OR 2-row OPEN-04 cardinality per D-51 sub-row reservation)
tech_stack:
  added: []
  patterns:
    - per-row block form for D-47 9-field schema (unbolded field labels match script regex; precedent established Wave 2)
    - decimal-form sub-row IDs (precedent Q06.1/Q06.2/Q07.1/Q07.2 from Wave 2; Wave 3 emits Q14..Q20 flat)
    - section-canonicalisation cross-reference per D-50 (OPEN-03 plugin self-test scope dedup'd to OPEN-07 forward reference Q22)
    - inline-anchor-citation MUST avoid full literal `## OPEN-NN: <description>` substring to preserve A2 H2 uniqueness — use `OPEN-NN H2 anchor` phrasing instead
key_files:
  created:
    - .planning/phases/04-open-questions/04-03-SUMMARY.md
  modified:
    - .planning/OPEN-QUESTIONS.md
decisions:
  - D-46 — primary-by-OPEN-NN H2 layout exercised in OPEN-03 + OPEN-04 + OPEN-05 bodies
  - D-47 — closed 9-field per-row block form; all 7 new rows carry all 8 named fields
  - D-48 — severity 3-tier closed enum; all 7 new rows = INFORMATIONAL
  - D-49 — resolution-path 5-value closed enum exercised across 3 enum values: `decide-before-Phase-<N>` (3 rows OPEN-03) + `live-workstream-pointer` (1 row OPEN-04) + `Coda-template-authoring (Phase 8)` (3 rows OPEN-05)
  - D-50 — multi-source citation discipline carried; plugin self-test cross-reference dedup
  - D-51 — single canonical row for OPEN-04 (pointer-only + invariant) + sub-row reservation paragraph
  - D-14 (carried) — backtick-wrapped path:line citation pattern; 13 new path:line citations across 7 rows
  - cross-AI C5 (carried) — citation line numbers grounded against current file lengths; manual A14 line-validity confirmed for all 13 new citations
  - cross-AI C6 (carried) — single-owner only; zero hybrid-owner literal globally
  - cross-AI C7 (carried) — platform-neutral wording in Proposed-default fields
  - cross-AI C8 (LOW) — Non-binding suggestion tag on OPEN-Q17 tracker destination (register-out-of-scope per D-51)
metrics:
  duration_minutes: ~25
  tasks_completed: 3
  files_created: 1
  files_modified: 1
  commits: 4
  date_completed: 2026-05-10
---

# Phase 4 Plan 03: Wave 3 OPEN-03 + OPEN-04 + OPEN-05 register-row population Summary

**Plan 04-03 — Wave 3 OPEN-03 + OPEN-04 + OPEN-05 population — executed 2026-05-10 — outcome: COMPLETE.**

Wave 3 lands 7 new register rows in `.planning/OPEN-QUESTIONS.md` across `## OPEN-03: Design-decision-deferred items` (3 rows + cross-reference blockquote), `## OPEN-04: Hub-link backfill rollout coordination` (1 row + sub-row reservation per D-51), and `## OPEN-05: Standard Coda templates v2 must author` (3 rows, all Phase 8 owner). Cumulative register total now **22 rows** (Wave 2: 15 + Wave 3: 7), exceeding the cross-AI C4 floor of 21. All rows conform to the D-47 closed 9-field schema; all severity / resolution-path / status / owning-phase fields exact-match closed enums; all rows carry ≥ 1 backtick-wrapped `path:line` citation per D-14. Three D-49 enum values are now exercised in addition to the Wave 2 `/gsd-research-phase <N>` value: `decide-before-Phase-<N>` (×3), `live-workstream-pointer` (×1), `Coda-template-authoring (Phase 8)` (×3).

## Sections populated

| Section | Row count | Severity breakdown | Resolution paths | Owning phases |
|---------|-----------|--------------------|--------------------|---------------|
| OPEN-03 | 3 + cross-reference | 3 INFORMATIONAL | `decide-before-Phase-4` (×1) + `decide-before-Phase-1` (×2) | Phase 4 (×1) / Phase 1 (×2) |
| OPEN-04 | 1 + sub-row reservation | 1 INFORMATIONAL | `live-workstream-pointer` (×1) | Phase 1 (×1) |
| OPEN-05 | 3 | 3 INFORMATIONAL | `Coda-template-authoring (Phase 8)` (×3) | Phase 8 (×3) |
| **Wave 3 new** | **7** | **0 BLOCKER + 0 GUARDRAIL + 7 INFORMATIONAL** | mixed | mixed |
| **Cumulative** | **22** | **3 BLOCKER + 4 GUARDRAIL + 15 INFORMATIONAL** | 4 of 5 enum values exercised | 7 distinct phases |

## OPEN-03 cross-reference (D-50 dedup)

Per D-50 source-merging discipline, `REQUIREMENTS.md` OPEN-03 4th sub-item ("plugin self-test scope") is section-canonicalised under the `OPEN-07` H2 anchor — its primary home. OPEN-03 emits a forward cross-reference blockquote pointing to **OPEN-Q22** (assigned at Wave 4 / Plan 04-04). The cross-reference text uses the phrasing `OPEN-07 H2 anchor (Plugin self-test scope)` rather than the full `## OPEN-07: ...` literal substring, to preserve A2 H2-uniqueness — see Deviations below.

## OPEN-04 single canonical row (D-51)

Per D-51, Phase 4 does NOT enumerate clients in this register — that is a moving target on Jason's parallel workstream. The single canonical row OPEN-Q17 records the invariant + pointer source-of-truth + proposed default verbatim from `.planning/REQUIREMENTS.md` OPEN-04 ("graceful halt at Stage 9 only — does not halt other stages, per MOD-1 prevention"). The closing paragraph reserves a sub-row (OPEN-Q17.1 or similar) for v2.1 Foundations build kickoff to name the live workstream tracker source-of-truth — Plan 04-05 reconciliation algorithm accommodates 1-row OR 2-row OPEN-04 cardinality cleanly.

```
$ grep -qF 'graceful halt at Stage 9 only' .planning/OPEN-QUESTIONS.md && echo OPEN_04_VERBATIM_OK
OPEN_04_VERBATIM_OK
```

## OPEN-05 Phase 8 ownership coupling

All 3 OPEN-05 rows carry both `Owning phase: Phase 8` AND `Resolution path: Coda-template-authoring (Phase 8)`. The acceptance criterion `Phase-8-owner count == OPEN5_ROW_COUNT` is asserted via grep:

```
$ awk -v hdr='## OPEN-05: Standard Coda templates v2 must author' 'f && /^## /{exit} f{print} index($0,hdr)==1 && /^## /{f=1}' .planning/OPEN-QUESTIONS.md | grep -cE 'Owning phase:[[:space:]]*Phase 8'
3
$ awk -v hdr='## OPEN-05: Standard Coda templates v2 must author' 'f && /^## /{exit} f{print} index($0,hdr)==1 && /^## /{f=1}' .planning/OPEN-QUESTIONS.md | grep -cE '^\*\*OPEN-Q[0-9]+\*\*'
3
```

3 == 3. T-04-12 mitigated.

## Closed-enum verification

| Enum | Field | Total fields document-wide | Off-enum literals |
|------|-------|----------------------------|-------------------|
| D-48 severity | `Severity:` | 22/22 (3 BLOCKER + 4 GUARDRAIL + 15 INFORMATIONAL) | 0 |
| D-49 resolution-path | `Resolution path:` | 22/22 (`/gsd-research-phase <N>` ×15 + `decide-before-Phase-<N>` ×3 + `live-workstream-pointer` ×1 + `Coda-template-authoring (Phase 8)` ×3) | 0 |
| D-47 status | `Status:` | 22/22 (3 open + 19 proposed) | 0 |
| D-47 owning-phase (cross-AI C6 tightened) | `Owning phase:` | 22/22 (`Phase [1-9]` only) | 0 hybrid `Phase 1/Phase 2` |

```
$ grep -cE 'Severity:[[:space:]]*(BLOCKER|GUARDRAIL|INFORMATIONAL)' .planning/OPEN-QUESTIONS.md
22
$ grep -cE 'Resolution path:[[:space:]]*(/gsd-research-phase [0-9]+|decide-before-Phase-[0-9]+|Coda-template-authoring \(Phase 8\)|policy-pending-sign-off|live-workstream-pointer)' .planning/OPEN-QUESTIONS.md
22
$ grep -cE 'Status:[[:space:]]*(open|proposed|decided|closed)' .planning/OPEN-QUESTIONS.md
22
$ grep -cE 'Owning phase:[[:space:]]*(Phase [1-9]|TBD)[[:space:]]*$' .planning/OPEN-QUESTIONS.md
22
$ grep -nF 'Owning phase: Phase 1/Phase 2' .planning/OPEN-QUESTIONS.md
(no output)
```

C6 hybrid-owner banned globally — confirmed.

## Citation discipline

```
$ grep -cE '`\.planning/[A-Za-z0-9_./-]+\.md:[0-9]+`' .planning/OPEN-QUESTIONS.md
21
$ grep -oE '`\.planning/[A-Za-z0-9_./-]+\.md:[0-9]+`' .planning/OPEN-QUESTIONS.md | wc -l
33
```

`grep -c` counts matching LINES (multi-citation source-citation lines collapse to 1) — total backtick-wrapped citation OCCURRENCES are 33 across 22 rows. Wave 3 added 13 new occurrences across 7 new rows (OPEN-Q14: 3 cites, OPEN-Q15: 3 cites, OPEN-Q16: 3 cites, OPEN-Q17: 3 cites, OPEN-Q18: 3 cites, OPEN-Q19: 2 cites, OPEN-Q20: 2 cites). All cited line numbers verified line-valid against current file lengths at execution time:

- `.planning/REQUIREMENTS.md` (229 lines) — Wave 3 cites :92 (OPEN-03), :93 (OPEN-04), :94 (OPEN-05) — all in-range ✓
- `.planning/CHANGELIST.md` (291 lines) — Wave 3 cites :283 (Appendix E risk-multiplier bullet), :260 (Appendix D rule 2 opt-in) — all in-range ✓
- `.planning/DESIGN.md` (1608 lines) — Wave 3 cites :181 (DESIGN-08 heading), :270 (status-survey passage), :619 (DESIGN-19), :795 (DESIGN-22), :1072 (DESIGN-26), :1122 (DESIGN-27) — all in-range ✓
- `.planning/AUDIT.md` (643 lines) — Wave 3 cites :38 (generate-sow status lifecycle row) — in-range ✓
- `.planning/research/PITFALLS.md` (417 lines) — Wave 3 cites :201 (MOD-1 hub-link contract failure) — in-range ✓

## C8 non-binding tag (Wave 3 — single application)

Wave 3 added one C8 non-binding tag:

- **OPEN-Q17** (Hub-link backfill rollout coordination) — register flags the unknown of WHERE the live workstream tracker lives (Coda doc / shared spreadsheet / GitHub issue / external URL); per D-51 the register does not own that destination — Phase 1 owner finalises during v2.1 Foundations build kickoff. C8 phrasing: *"Non-binding suggestion per cross-AI C8 — tracker format/destination is Phase 1 owner discretion; this register does not own that destination."*

OPEN-Q14 / Q15 / Q16 (OPEN-03) and OPEN-Q18 / Q19 / Q20 (OPEN-05) do NOT carry C8 tags — their proposed-default fields stay register-only (catalogue uncertainty, describe DESIGN.md decisions verbatim, prescribe author-as-built within Phase 8 authority for OPEN-05). No destination overreach beyond register scope.

## Mid-phase structural-check first-fail

Verbatim output:

```
$ bash .planning/phases/04-open-questions/scripts/openquestions-structure-check.sh
FAIL: Appendix B row count 0 != register total 22 (D-53 1:1 cardinality)
EXIT=1
```

**A10 first-fail is expected per Wave 3 invariant.** Earlier assertions A1-A9 all PASS:

- A1 (12 required H2 anchors present) ✓
- A2 (every required H2 anchor unique — 1 occurrence each) ✓ (after Deviation 1 below)
- A3 (exactly 7 OPEN-NN H2 anchors) ✓
- A4 (register row/block count 22 ≥ 21 floor per cross-AI C4) ✓
- A5 (severity closed enum — 22/22 conforming, 0 off-enum) ✓
- A6 (resolution-path closed enum — 22/22 conforming, 0 off-enum) ✓
- A7 (status closed enum — 22/22 conforming, 0 off-enum) ✓
- A8 (owning-phase enum tightened, single-owner only — 22/22 conforming, 0 hybrid) ✓
- A9 (citation count 33 ≥ register total 22) ✓

A10/A11/A13 will continue to fail until Wave 5 synthesis populates Appendix B/C and removes the remaining `Populated by 04-04` notes from OPEN-06+07 + `Populated by 04-05` notes from Executive Summary + How-to-read + Appendix A/B/C. A14 SAMPLE pass does not fire because the script fails-fast at A10 — but manual line-validity check (above) confirms all 13 new Wave 3 citations are line-valid; the script's A14 SAMPLE pass will succeed when reached at Wave 5 synthesis (after Appendix B/C populate).

## Decisions implemented

| Decision | Application |
|---------|-------------|
| **D-46** | OPEN-03 + OPEN-04 + OPEN-05 H2 anchors carry register rows; primary-by-OPEN-NN layout exercised |
| **D-47** | Per-row block form (8 field labels + bolded row ID) — closed 9-field schema across 7 new rows |
| **D-48** | Severity = INFORMATIONAL across all 7 Wave 3 rows |
| **D-49** | Three new resolution-path enum values exercised: `decide-before-Phase-<N>` (×3) + `live-workstream-pointer` (×1) + `Coda-template-authoring (Phase 8)` (×3) |
| **D-50** | Multi-source citations + plugin self-test cross-reference dedup (OPEN-03 → OPEN-07 forward reference Q22) |
| **D-51** | Single canonical row for OPEN-04 (pointer-only) + sub-row reservation paragraph |
| **D-14** carried | Every citation backtick-wrapped `path:line` |
| **cross-AI C5** carried | Line numbers grounded; manual A14 line-validity confirmed for all 13 new citations |
| **cross-AI C6** carried | Single-owner only; 0 hybrid `Phase 1/Phase 2` literal globally |
| **cross-AI C7** carried | Platform-neutral wording in Proposed-default fields |
| **cross-AI C8** | Non-binding suggestion tag on OPEN-Q17 (register-out-of-scope tracker destination per D-51) |

## Hand-off to Wave 4

**Plan 04-04 (Wave 4)** populates OPEN-06 + OPEN-07 sections:

- **OPEN-06** `/refine-<skill>` resolution — Phase 1 deadline; resolution = `policy-pending-sign-off`. **MUST assign OPEN-Q21 to the OPEN-06 first row** (1-2 rows expected: namespace decision + parameterised-vs-orphan-delete). If a sub-decision row is needed, it MUST use decimal form (`OPEN-Q21.1`) per cross-AI C2 + Wave 2 precedent (Q06.1/Q06.2/Q07.1/Q07.2).

- **OPEN-07** Plugin self-test scope — Phase 9 owner; resolution = `policy-pending-sign-off`. **MUST assign OPEN-Q22 to the OPEN-07 row** (1 row expected: smoke tests scope). This honours the OPEN-03 cross-reference blockquote that points forward to OPEN-Q22.

After Wave 4 lands, register count rises to 23-24 rows; A10 (Appendix B 0 ≠ register_total) + A11 (Appendix C reconciliation block missing) + A13 (narrowed regex still catches `Populated by 04-05` skeleton notes for Executive Summary + How-to-read + Appendix A/B/C) all continue to fail. Plan 04-05 (Wave 5) synthesises Executive Summary + How-to-read + Appendix A/B/C + final structural-check pass + reviewer-ready phrase.

**Numbering directive for Plan 04-04:** OPEN-Q21 = OPEN-06 first row; OPEN-Q22 = OPEN-07 plugin self-test row. The OPEN-03 cross-reference blockquote (`See OPEN-Q22`) depends on this assignment — diverging breaks the cross-reference (T-04-10 mitigation).

**Inline-citation-anchor rule (NEW — established Wave 3):** When citing an `## OPEN-NN: <description>` H2 anchor inline (in narrative or blockquote text), use the phrasing `OPEN-NN H2 anchor (<description>)` rather than the full literal `## OPEN-NN: <description>` substring. The structural-check A2 uses `grep -cF` literal substring match and counts inline references against H2-uniqueness — this rule prevents accidental A2 false-positive failure.

## Deviations from Plan

### Auto-fixed issues

**1. [Rule 1 — Bug] Duplicate `## OPEN-07: Plugin self-test scope` literal substring broke A2 H2-uniqueness**

- **Found during:** Task 3 (mid-phase structural-check after OPEN-05 author)
- **Issue:** The plan prescribed wording for the OPEN-03 section preamble + cross-reference blockquote that quoted the full literal `## OPEN-07: Plugin self-test scope` H2 anchor in backticks (twice). The structural-check A2 uses `grep -cF "$h" "$OPENQ_FILE"` (literal substring match, not anchored) — this counted those inline references as additional occurrences of the H2 anchor, returning 3 (preamble + blockquote + actual H2) where exactly 1 was expected. Structural-check failed at A2 with `H2 anchor '## OPEN-07: Plugin self-test scope' appears 3 times (expected exactly 1)`.
- **Fix:** Reworded both inline references to use the phrasing `OPEN-07 H2 anchor (Plugin self-test scope)` — same semantic content, different surface form, preserves A2 H2-uniqueness.
- **Files modified:** `.planning/OPEN-QUESTIONS.md`
- **Why this is a Rule 1 deviation, not Rule 4:** D-50 dedup contract preserved (cross-reference still names the canonical home + forwards to OPEN-Q22); only the surface form of the inline anchor reference changed. Wave 1 already shipped the structural-check; modifying the script is out of scope per `files_modified` design-only constraint. Analogous to Wave 2's Q06.1/Q06.2 letter→decimal-form fix — same class of script-regex-incompatibility-with-prescribed-text Rule 1 bug.
- **Forward-discipline:** New Wave 3 invariant added in Hand-off to Wave 4 above — "Inline-citation-anchor rule" — to prevent recurrence in Plan 04-04 OPEN-06/07 authoring.

## Self-Check: PASSED

- `.planning/OPEN-QUESTIONS.md` (modified) — FOUND
- `.planning/phases/04-open-questions/04-03-SUMMARY.md` — FOUND (this file)
- Commit `f4f9660` (OPEN-03 — 3 rows + cross-reference) — VERIFIED via git log
- Commit `658d162` (OPEN-04 — 1 row + sub-row reservation) — VERIFIED via git log
- (Pending Task-3 commit — OPEN-05 + cross-AI C6 inline-anchor fix + this SUMMARY)
- Mid-phase structural-check exit code — VERIFIED NON-ZERO (1) at A10 (`Appendix B row count 0 != register total 22`) — Wave 3 invariant met (A1-A9 all PASS; A4 floor 21 met with 22 rows)
- Cumulative register row count (script regex) — 22 ✓
- New Wave 3 row count — 7 ✓ (target ~7, exact match)
- Phase 8 owner total — 3 ✓ (OPEN-05 row count == 3)
- `Coda-template-authoring (Phase 8)` total — 4 ✓ (3 OPEN-05 rows + 1 closed-enum verification table line — actual register-row matches use Resolution-path field; 3 register rows confirmed via `grep -cE 'Resolution path:[[:space:]]*Coda-template-authoring \(Phase 8\)'`)
- `live-workstream-pointer` total — 1 ✓
- `decide-before-Phase-` total — 4 ✓ (3 register rows + 1 D-49 enum reference in OPEN-03 preamble)
- Hybrid-owner literal `Phase 1/Phase 2` — absent ✓
- All 13 new Wave 3 citations manually line-validity-checked — PASS
- OPEN-Q22 forward-reference present in OPEN-03 body ✓
