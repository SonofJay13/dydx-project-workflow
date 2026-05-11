---
phase: 01-audit
plan: 01
subsystem: audit-scaffold
tags: [audit, scaffold, structural-check, design-only, wave-1]
requires: []
provides:
  - audit-structure-check.sh — Wave 0 structural verifier (8 assertions)
  - AUDIT.md skeleton with all 8 AUDIT-0N H2 anchors + preamble + executive summary + Appendix B
affects:
  - Plans 01-02 through 01-09 (each populates one section under the matching H2 anchor)
tech_stack:
  added:
    - bash (structural verification)
  patterns:
    - case-insensitive ERE for prose-matching grep assertions
    - literal-string match (grep -qF) only for sentinel tokens like 2.0.0
    - tolerant Appendix B row regex (^\| [^|]+ \|) for any first-column format
key_files:
  created:
    - .planning/phases/01-audit/scripts/audit-structure-check.sh
    - .planning/AUDIT.md
  modified: []
decisions:
  - D-01 enforced — 8 AUDIT-0N H2 anchors land in skeleton
  - D-03 enforced — Executive Summary + How to read this audit anchors land
  - D-09 enforced — Appendix B trace anchor lands; row-count assertion (>= 14) installed
  - D-16 enforced — case-insensitive ERE pattern for v2.1 phrase tolerates capitalization drift
  - D-17 enforced — literal-string assertion for 2.0.0 synced target
metrics:
  duration: ~5 minutes
  tasks_completed: 3
  files_created: 2
  completed_date: 2026-05-09
---

# Phase 1 Plan 01: Wave 1 Scaffold + Structural-Check Script Summary

Bash structural verifier (8 assertions) and AUDIT.md skeleton (8 H2 anchors + appendices) scaffolded; structural-check confirmed live by failing on missing-content assertions against empty skeleton.

## What Was Built

- **`.planning/phases/01-audit/scripts/audit-structure-check.sh`** — executable bash, syntax-valid, 8 assertions per VALIDATION.md Wave 0 Requirements:
  1. AUDIT.md file exists
  2. 8 `## AUDIT-0N:` H2 sections present
  3. D-16 v2.1 constraint phrase (case-insensitive ERE)
  4. CONCERNS.md absorption claim (case-insensitive ERE)
  5. `## Executive Summary` anchor (D-03)
  6. `## Appendix B:` anchor (D-09)
  7. Appendix B >= 14 data rows (D-09 — one per CONCERNS.md H2 section)
  8. `2.0.0` synced target (D-17, literal-string match)
  Header comment documents the case-insensitive ERE pattern and tolerant row regex.

- **`.planning/AUDIT.md`** skeleton — 8 AUDIT-0N H2 anchors, preamble + executive summary anchors, Appendix A glossary + Appendix B trace anchors, trailing italic line. Bodies are parenthetical placeholders pointing at the wave that populates them.

## Wave 1 Invariant Verified

Structural-check is live, NOT a no-op. Run against empty skeleton:

```
$ bash .planning/phases/01-audit/scripts/audit-structure-check.sh
FAIL: D-16 v2.1 constraint phrase not found (expected case-insensitive ERE 'scheduled for v2\.1 (foundations )?build')
EXIT_CODE=1
```

Assertions 1 (file exists) and 2 (8 sections) PASS. Assertion 3 (v2.1 phrase) FAILS first — confirming the script catches missing AUDIT-07 content. Subsequent assertions (4 absorption claim, 7 Appendix B rows, 8 2.0.0) would also fail if reached. T-01-02 mitigated.

## Anchor List for Downstream Plans

The exact H2 strings landed (line-anchored — downstream plans grep these):

```
## AUDIT-01: Per-Skill Inventory                          → Plan 02 / Wave 2
## AUDIT-02: CONCERNS.md absorption (verified superset)   → Wave 9 (synthesis)
## AUDIT-03: Per-Stage Connector Dependencies             → Plan 03 / Wave 3
## AUDIT-04: Referenced-but-Missing Artefacts             → Plan 04 / Wave 4
## AUDIT-05: Duplicated Content Blocks                    → Plan 05 / Wave 5
## AUDIT-06: Version-String Mismatches                    → Plan 06 / Wave 6
## AUDIT-07: Cosmetic-but-Client-Visible Issues           → Plan 07 / Wave 7
## AUDIT-08: Live MCP Wiring Probe                        → Plan 08 / Wave 8
## How to read this audit                                 → Wave 9
## Executive Summary                                       → Wave 9
## Appendix A: Glossary                                    → Wave 9
## Appendix B: CONCERNS.md → AUDIT.md trace                → Wave 9
```

Plan 02 (Wave 2) populates AUDIT-01 next.

## Commits

| Task | Description | Commit |
|------|-------------|--------|
| 1 | audit-structure-check.sh (8 assertions, exec, syntax-valid) | dd6132c |
| 2 | AUDIT.md skeleton at .planning/AUDIT.md (8 H2 anchors) | 8891f47 |
| 3 | Verify-only — script exits 1 against empty skeleton (no commit) | — |

## Files Created

- `.planning/phases/01-audit/scripts/audit-structure-check.sh` (55 lines, executable bash)
- `.planning/AUDIT.md` (76 lines, skeleton placeholders)

No files outside these two were modified. `dydx-delivery/` untouched (verified design-only mandate).

## Deviations from Plan

None — plan executed exactly as written.

## Threat Model Compliance

- **T-01-01 (wrong H2 string):** Mitigated — exact strings written; assertion #2 catches typos via `^## AUDIT-0[1-8]:` count.
- **T-01-02 (script claims all-pass when no-op):** Mitigated — Task 3 negative test confirms script exits 1 with `FAIL:` message against empty skeleton.
- **T-01-03 (silent CONCERNS.md drop):** Mitigated (deferred enforcement to Plan 09) — assertions #4 (absorption claim) and #7 (Appendix B >= 14 rows) installed; Plan 09 must satisfy them.
- **T-01-06 (D-16 capitalization drift):** Mitigated — case-insensitive ERE `'scheduled for v2\.1 (foundations )?build'` accepts both lowercase and uppercase variants.

## Pointer

**Plan 02 (Wave 2) populates AUDIT-01 next** — per-skill inventory matrix + per-skill subsections for the 7 v0.3.0 skills. Plan 02 will append content under `## AUDIT-01: Per-Skill Inventory` in `.planning/AUDIT.md`.

## Self-Check: PASSED

- File `.planning/phases/01-audit/scripts/audit-structure-check.sh` — FOUND
- File `.planning/AUDIT.md` — FOUND
- Commit `dd6132c` (Task 1) — FOUND in git log
- Commit `8891f47` (Task 2) — FOUND in git log
- Script exits 1 against empty skeleton with FAIL message — VERIFIED (assertion #3 fires first)
- 8 AUDIT-0N H2 anchors present in skeleton — VERIFIED (`grep -cE '^## AUDIT-0[1-8]:' .planning/AUDIT.md` = 8)
