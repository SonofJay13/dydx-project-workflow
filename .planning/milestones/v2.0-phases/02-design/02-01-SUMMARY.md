---
phase: 02-design
plan: 01
subsystem: design-scaffold
tags: [design, scaffold, structural-check, design-only, wave-1]
requires: []
provides: [design-structure-check, design-md-skeleton, h2-anchors-locked]
affects: [.planning/DESIGN.md, .planning/phases/02-design/scripts/design-structure-check.sh]
tech_stack:
  added: []
  patterns:
    - matrix-then-prose H2/H3 anchors (D-19)
    - stateful section_between() awk helper (cross-AI HIGH #1 fix)
    - case-sensitive grep -qF / grep -cE assertions (cross-AI LOW #8 fix)
    - per-DESIGN success-criteria echo convention (D-35)
    - inline [OPEN: Phase 4 — ...] + closed deferred-list (D-27 / D-33)
    - D-22 risk-multiplier sentinel pre-laid for cross-section gating
key_files:
  created:
    - .planning/phases/02-design/scripts/design-structure-check.sh
    - .planning/DESIGN.md
    - .planning/phases/02-design/02-01-SUMMARY.md
  modified: []
decisions:
  - "Phase 2 Plan 01: design-structure-check.sh defines stateful section_between() awk helper instead of broken `awk '/^## X/,/^## /'` range pattern (cross-AI review HIGH #1 fix) — start H2 cannot be re-matched as end H2 on the same line; helper extracts body only up to NEXT H2."
  - "Phase 2 Plan 01: script header comments accurately describe case-sensitive grep -qF (literal sentinel tokens) and grep -cE (case-sensitive ERE patterns) — script does NOT use -i flag; capitalisation is exact per author tooling responsibility (cross-AI review LOW #8 fix)."
  - "Phase 2 Plan 01: DESIGN.md lives at `.planning/DESIGN.md` (NOT under the phase folder) per CONTEXT.md Integration Points and D-18 — same convention as Phase 1 AUDIT.md."
  - "Phase 2 Plan 01: Wave 1 skeleton intentionally fails 2 of 9 assertions (#4 DESIGN-NN echo count = 0; #9 hand-off matrix data rows = 0) — proves the structural-check is live end-to-end. Phase 1 Plan 01 Task 3 set the precedent (audit-structure-check.sh exited 1 against empty skeleton with 'Appendix B trace has fewer than 14 rows'); same pattern."
  - "Phase 2 Plan 01: stateful-helper extraction confirmed against empty skeleton — `awk` with the section_between body returned 0 lines matching `^| Stage`, proving the helper does NOT spuriously match the header row (T-02-01-02 mitigation honoured)."
  - "Phase 2 Plan 01: 13 Stage-N H2 anchors created (Stages 1, 2, 3, 4a, 4b, 5, 6, 7a, 7b, 8, 9, 10, 11) — exceeds the >= 11 floor, accommodates Stage 4 fnspec split (DESIGN-20) and Stage 7 dual build prompts (DESIGN-23)."
metrics:
  duration: ~6 min
  completed_date: 2026-05-09
---

# Phase 2 Plan 01: Wave 1 scaffold — design-structure-check + DESIGN.md skeleton

Wave 1 scaffold for Phase 2 (Design): produced the structural-check script and the DESIGN.md skeleton so plans 02-02 through 02-10 each write their DESIGN-* slice into a known anchor and get graded by the same assertions. Mirrors Phase 1 Plan 01 (audit scaffold) pattern with an extra cross-AI-review-driven correction (stateful section_between helper replaces a broken awk range).

## What Was Built

**One-liner:** Locked the Phase 2 verification spine — 9-assertion bash structural-checker + 11-anchor DESIGN.md skeleton at `.planning/DESIGN.md`; structural-check is live (exits 1 with a clear `FAIL:` against the empty skeleton).

### `.planning/phases/02-design/scripts/design-structure-check.sh`

- 82 lines bash, executable, `bash -n` syntax-clean.
- `set -euo pipefail`; single `fail()` helper.
- Stateful `section_between()` awk helper (cross-AI HIGH #1 fix) — replaces the broken `awk '/^## X/,/^## /'` range pattern that would have captured only the H2 header line.
- 9 assertions:
  1. `.planning/DESIGN.md` exists.
  2. 11 required H2 anchors present (Cross-cutting decisions / Skill layout / 13-skill inventory / Stage-by-stage hand-off contract / Platform skills / Test bot architecture / Live status-lifecycle survey / Deferred to Phase 4 OPEN-QUESTIONS / Appendix A-C).
  3. Stage-skill H2 count >= 11 (case-sensitive ERE `^## Stage [0-9]+[ab]?[a-d]?( |:)`).
  4. Per-DESIGN success-criteria echo lines >= 30 (D-35 — `^> \*\*DESIGN-[0-9]{2}:\*\*`).
  5. D-22 risk-multiplier literal sentinel present.
  6. Inline `[OPEN: Phase 4 — ...]` marker count >= 1 (D-27 / D-33).
  7. Closed deferred-list section enumerates >= 1 `[OPEN]` item (D-27).
  8. `frontmatter_version: 2` sentinel present (DESIGN-01).
  9. Hand-off transition matrix has >= 10 `^| Stage`-prefixed data rows — uses `section_between` helper (D-26).

### `.planning/DESIGN.md` (skeleton)

- 143 lines, all H2/H3 anchors with placeholder bodies.
- H1 title + 3 metadata lines (Design Date / branch / Phase 1 Audit ground-truth pointer).
- Preamble blockquote explaining echo / `[OPEN]` / `file:line` / `AUDIT.md §X.Y` conventions.
- `## Executive Summary` placeholder.
- `## Cross-cutting decisions` + nested `### Live status-lifecycle survey` H3 (D-25).
- `## Skill layout`, `## 13-skill inventory`, `## Stage-by-stage hand-off contract` (with column-header row but zero data rows).
- `## Platform skills` + 3 H3s (`### platform-pipefy`, `### platform-wrike`, `### platform-ziflow`).
- 13 Stage-N H2s (Stage 1, 2, 3, 4a, 4b, 5, 6, 7a, 7b, 8, 9, 10, 11).
- `## Test bot architecture` + 3 H3s (`### DESIGN-28: tier-1 / tier-2 boundary`, `### DESIGN-29: client_state.yaml skeleton`, `### DESIGN-30: drift-detection contract`).
- `## Deferred to Phase 4 OPEN-QUESTIONS` with seed item: `[OPEN: Phase 4 — risk-multiplier numeric defaults pending dYdX-historical validation per D-22]`.
- `## Appendix A: Glossary`, `## Appendix B: DESIGN-* → DESIGN.md section traceability`, `## Appendix C: Persona contract worked examples`.
- Trailing italics line referencing supersession of v0.3.0 + Phase 3 / Phase 4 handoff.
- `frontmatter_version: 2` sentinel pre-laid in cross-cutting body.

## Wave 1 Invariant Confirmed

```
$ bash .planning/phases/02-design/scripts/design-structure-check.sh
FAIL: expected >= 30 'DESIGN-NN:' success-criteria echo blockquote lines (D-35), found 0
EXIT_CODE=1
```

- Script exits **1** (NOT 0) — confirms assertions are live and catch missing content.
- First failing assertion is #4 (DESIGN-NN echo count = 0) — expected; will pass after plans 02-02..02-09 write per-DESIGN echo lines.
- Hand-off matrix assertion (#9) would also fail if reached; independent verification with the stateful helper returned **0 rows** against the empty skeleton, proving the cross-AI HIGH #1 fix works (a broken `/^## X/,/^## /` range would have erroneously captured the header line and possibly produced spurious counts).
- The first 8 assertions logically depend on the encountered failure ordering; under `set -euo pipefail`, the script exits on the first `fail()` call — so #4 short-circuits before #9 is evaluated. Both negative invariants hold independently (verified directly).

## Cross-AI Review Fixes Applied

| ID | Type | Fix |
|----|------|-----|
| HIGH #1 | Tampering / Repudiation | Stateful `section_between()` awk helper replaces broken `awk '/^## X/,/^## /'` range. Helper exits only on the NEXT `## ` line, so the start H2 cannot be re-matched as the end H2 on the same line. Hand-off matrix assertion #9 uses the helper. |
| HIGH #2 | Process / traceability | `02-01-SUMMARY.md` listed in `files_modified` frontmatter (this file). |
| LOW #8 | Comment / code mismatch | Header comment block accurately describes case-sensitive `grep -qF` (literal-string) and `grep -cE` (case-sensitive ERE) behaviour. Removed the misleading "case-insensitive ERE" claim from earlier drafts. Added explicit note: "script does NOT use case-insensitive matching (-i)". |

## Anchor List (for downstream plans)

Plans 02-02 through 02-10 grep-locate their target section using these exact strings:

**H2 anchors** (top-level sections):

- `## Cross-cutting decisions` — Plan 02-02 (DESIGN-01..10)
- `### Live status-lifecycle survey` — Plan 02-02 (DESIGN-08 survey under D-25)
- `## Skill layout` — Plan 02-03 (DESIGN-11)
- `## 13-skill inventory` — Plan 02-03 (DESIGN-12)
- `## Stage-by-stage hand-off contract` — Plan 02-03 (DESIGN-13; populates the matrix data rows)
- `## Platform skills` + `### platform-pipefy` / `### platform-wrike` / `### platform-ziflow` — Plan 02-04 (DESIGN-14, 15, 16)
- `## Stage 1: Kickoff capture` — Plan 02-05 (DESIGN-17)
- `## Stage 2: Discovery refactor` — Plan 02-05 (DESIGN-18)
- `## Stage 3: SOW refactor` — Plan 02-05 (DESIGN-19)
- `## Stage 4a: Functional spec — platform` — Plan 02-06 (DESIGN-20 first half)
- `## Stage 4b: Functional spec — integration` — Plan 02-06 (DESIGN-20 second half)
- `## Stage 5: Tech spec` — Plan 02-06 (DESIGN-21)
- `## Stage 6: Cost estimate` — Plan 02-07 (DESIGN-22 — risk-multiplier structure; numeric defaults DEFERRED)
- `## Stage 7a: Build prompt — dev` — Plan 02-07 (DESIGN-23 first half)
- `## Stage 7b: Build prompt — implementation per platform` — Plan 02-07 (DESIGN-23 second half)
- `## Stage 8: Test bot — overview` — Plan 02-08 (DESIGN-24)
- `## Stage 9: Documentation publishing` — Plan 02-08 (DESIGN-25)
- `## Stage 10: Native-AI enablement` — Plan 02-08 (DESIGN-26)
- `## Stage 11: Sign-off, brain update, archive` — Plan 02-08 (DESIGN-27)
- `## Test bot architecture` + `### DESIGN-28` / `### DESIGN-29` / `### DESIGN-30` — Plan 02-09 (DESIGN-28, 29, 30)
- `## Deferred to Phase 4 OPEN-QUESTIONS` — Plan 02-10 synthesis (closed list)
- `## Appendix A: Glossary` — Plan 02-10 synthesis
- `## Appendix B: DESIGN-* → DESIGN.md section traceability` — Plan 02-10 synthesis (30-row trace)
- `## Appendix C: Persona contract worked examples` — Plan 02-02 (DESIGN-10 worked examples; D-29)

## Tasks Executed

| Task | Name | Commit | Files |
|------|------|--------|-------|
| 1 | Create scripts/ + write design-structure-check.sh | 8469bd9 | `.planning/phases/02-design/scripts/design-structure-check.sh` |
| 2 | Create DESIGN.md skeleton at `.planning/DESIGN.md` | bb13937 | `.planning/DESIGN.md` |
| 3 | Verify Wave 1 invariant — script exits 1 by design | (no commit; verification-only) | — |

## Deviations from Plan

None — plan executed exactly as written. The cross-AI review HIGH #1 / LOW #8 / HIGH #2 fixes were already encoded into the plan's `<interfaces>` block; this execution preserved them verbatim. No Rule 1/2/3 auto-fixes were needed.

The Task 1 acceptance criterion `grep -cE '^\s*fail' >= 9` matched only the `fail()` declaration line itself (line 18) because the 9 `|| fail` assertion calls are mid-line, not line-leading. The intent of the criterion (one fail-call site per assertion) is satisfied at the call-site level — there are 9 `|| fail "..."` invocations across lines 32, 49, 54, 58, 61, 65, 71, 74, 79 — the regex was imprecise but the structural property holds. No change made; the literal-substring assertions specified in the same acceptance block all pass.

## Pointer

**Next:** Plan 02-02 (Wave 2) populates `## Cross-cutting decisions` next — DESIGN-01..10 plus the live status-lifecycle survey under D-25, plus Appendix C persona-contract worked examples (D-29 / DESIGN-10).

## Self-Check: PASSED

Verified files exist:

- `.planning/phases/02-design/scripts/design-structure-check.sh` — FOUND (82 lines, executable, `bash -n` clean)
- `.planning/DESIGN.md` — FOUND (143 lines, all H2/H3 anchors present)
- `.planning/phases/02-design/02-01-SUMMARY.md` — FOUND (this file)

Verified commits exist on `dydx-delivery-v2`:

- `8469bd9` — FOUND (Task 1: design-structure-check.sh)
- `bb13937` — FOUND (Task 2: DESIGN.md skeleton)

Structural-check script: exits 1 against the Wave 1 empty skeleton (assertion #4 short-circuits with `FAIL: expected >= 30 'DESIGN-NN:'` — expected and correct).
