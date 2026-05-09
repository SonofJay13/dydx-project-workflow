---
phase: 01-audit
plan: 06
subsystem: audit
tags: [audit, version-mismatches, design-only]
requires:
  - .planning/phases/01-audit/01-RESEARCH.md
  - .planning/phases/01-audit/01-CONTEXT.md
  - .planning/codebase/CONCERNS.md
  - .planning/REQUIREMENTS.md
provides:
  - "AUDIT-06 section: 8-row version-mismatch table + 2.0.0 synced-target recommendation"
affects:
  - .planning/AUDIT.md
tech-stack:
  added: []
  patterns:
    - "Pattern 6 — pipe-style markdown table (6 columns: # / Location / Citation / Current value / What it represents / Drifts from 0.3.0?)"
    - "Pattern 4 — bracketed [STRUCTURAL] severity tag, split per-bullet so per-line grep counts each (Rule 1 fix)"
    - "D-17 — literal `2.0.0` synced-target recommendation (observation-led; not a design move)"
    - "Compact `file:line` citation form per D-14"
    - "D-13 banned-phrase ERE returns 0 across the section"
key-files:
  created: []
  modified:
    - .planning/AUDIT.md
decisions:
  - "Summary observations split into 3 separate bullets so `grep -c '\\*\\*\\[STRUCTURAL\\]\\*\\*'` returns 3 (Rule 1 fix during verification — initial single-paragraph form put all 3 STRUCTURAL tags on one line, which `grep -c` counted as 1 line; bullet split per Pattern 4 enforces per-line counting consistent with Plan 05's same fix on 5.5 citations)"
  - "Manifest values transcribed verbatim from live source files (T-01-06-01 mitigation): plugin.json:3 = 0.3.0; marketplace.json:9 = 1.2.0; marketplace.json:16 = 0.3.0; README.md:9 = 0.1.0; results-template.md:9 = v0.1.0; safety-rules.md:93 = 'Parallel execution is not supported in v1' — all confirmed before transcription"
  - "Recommendation phrasing locked at 'Recommended sync target: `2.0.0`' (D-17); the banned-phrase ERE intentionally does NOT match this phrasing (`recommend that v2` requires literal contiguous tokens; `propose` token absent) — confirmed by `grep -ciE 'we should|the design will|recommend that v2|propose|v2 will' = 0`"
metrics:
  duration: ~10 min
  completed: 2026-05-09
---

# Phase 1 Plan 06: AUDIT-06 Version-String Mismatches Summary

AUDIT-06 populated with the exhaustive 8-row version-mismatch table plus the `2.0.0` synced-target recommendation per D-17. Catalogues every version-bearing location in v0.3.0; schedules the actual bump to v2.1 Foundations build (FOUND-04). Structural-check assertion #8 (`grep -qF '2.0.0' .planning/AUDIT.md`) now passes.

## What Was Built

**Row** | **Location** | **Citation** | **Current value** | **Drifts from 0.3.0?**
---|---|---|---|---
1 | Plugin manifest | `dydx-delivery/.claude-plugin/plugin.json:3` | `"version": "0.3.0"` | Source of truth
2 | Marketplace plugin entry | `.claude-plugin/marketplace.json:16` | `"version": "0.3.0"` | No
3 | Marketplace metadata version | `.claude-plugin/marketplace.json:9` | `"version": "1.2.0"` | YES (different scheme/scope)
4 | Root README plugin table | `README.md:9` | `0.1.0` | YES (drifted by 0.2.0)
5 | Plugin README changelog | `dydx-delivery/README.md:126` | `**0.3.0** —` (truncated) | No (matches; truncated → AUDIT-07)
6 | Results-template runner | `dydx-delivery/skills/execute-tests/references/results-template.md:9` | `runner: dydx-delivery/execute-tests v0.1.0` | YES (drifted by 0.2.0)
7 | Safety-rules `v1` reference | `dydx-delivery/skills/execute-tests/references/safety-rules.md:93` | "Parallel execution is not supported in v1" | Unclear (no anchor)
8 | Root README versioning convention | `README.md:81-83` | (semver convention statement) | N/A (convention doc)

**Row count:** 8 (matches RESEARCH.md §7 enumeration exactly).
**Citation count:** 9 distinct `file:line` references matched by the path regex (rows 1, 2, 3, 4, 5, 6, 7 each cite a unique source path; row 8 cites `README.md` again — 6 distinct source paths covered, ≥6 acceptance threshold).
**Severity tags:** 3 `**[STRUCTURAL]**` (one per drift class — backwards drift on #4/#6; scope-unclear on #3; unanchored `v1` on #7).
**Synced-target observation:** `2.0.0` named twice in the section (table + recommendation paragraph); whole-file `grep -qF '2.0.0'` now succeeds.

## Verification Results

All 9 Task 1 acceptance criteria pass:

| Criterion | Threshold | Actual | Status |
|---|---|---|---|
| 6-column header present | ≥1 | 1 | ✓ |
| Numbered rows (`\| N \|`) | =8 | 8 | ✓ |
| Literal `2.0.0` in section | ≥1 | 2 | ✓ |
| Distinct path citations | ≥6 | 9 | ✓ |
| `**[STRUCTURAL]**` tags | ≥3 | 3 | ✓ |
| `FOUND-04` referenced | ≥1 | 2 | ✓ |
| `AUDIT-07` cross-ref | ≥1 | 3 | ✓ |
| Banned-phrase ERE | =0 | 0 | ✓ |
| Whole-file `2.0.0` (assertion #8) | ≥1 | 2 | ✓ |

## Plan-Level Success Criteria

- [x] AUDIT-06 has 8-row version-mismatch table with the 6 specified columns
- [x] `2.0.0` appears at least once in AUDIT-06 (D-17 + structural-check assertion #8)
- [x] At least 3 [STRUCTURAL] tags (3 present, one per drift class)
- [x] FOUND-04 referenced as the v2.1 build target
- [x] No design-move language (canonical D-13 banned-phrase ERE returns 0)
- [x] No content under `dydx-delivery/` modified (`git diff --stat HEAD~1 HEAD -- dydx-delivery/` = empty)
- [x] Structural-check script's assertion #8 now passes; assertion #4 (CONCERNS absorption) still fails (Plan 09 closes that)

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Summary paragraph initially failed STRUCTURAL acceptance grep**
- **Found during:** Task 1 verification
- **Issue:** PLAN's drafted summary paragraph put all 3 `**[STRUCTURAL]**` tags on a single line. The acceptance criterion uses `grep -c '\*\*\[STRUCTURAL\]\*\*'`, which counts matching **lines**, not occurrences — so the single-line form scored 1, failing `>= 3`.
- **Fix:** Split the summary into 3 separate bullets, one `**[STRUCTURAL]**` per line. Same pattern as Plan 05's 5.5 citation-line split (Rule 1 fix). The text content and meaning are unchanged; only line-breaks differ.
- **Files modified:** `.planning/AUDIT.md` (AUDIT-06 summary observations only)
- **Commit:** `6335593`

No other deviations. Manifest values were verified live before transcription (T-01-06-01 mitigation); banned-phrase ERE returned 0 on first check; threat T-01-06-02 (no `dydx-delivery/` modifications) holds — only `.planning/AUDIT.md` modified.

## Decisions Made

- **Summary paragraph as bullets, not prose:** D-15 severity-tag format requires per-line grep counting; bullets enforce one-tag-per-line, future-proofing against the same Rule 1 fix re-occurring.
- **Live-source transcription discipline (T-01-06-01 mitigation):** Each of the 6 cited source files (`plugin.json`, `marketplace.json`, root `README.md`, plugin `README.md`, `results-template.md`, `safety-rules.md`) was Read at the cited line range BEFORE writing the table — eliminates hallucination risk on values that, if wrong, would invalidate the audit.
- **`2.0.0` literal phrasing per D-17:** Wrote "**Recommended sync target: `2.0.0`**" — the literal phrase D-17 mandates. Confirmed against the canonical D-13 banned-phrase ERE that this phrasing is NOT in the banned set (no `propose`; `recommend that v2` requires the contiguous tokens which "Recommended sync target" does not contain).
- **`v2.1 Foundations build (FOUND-04)`:** Future-tense phrasing ("scheduled for v2.1 Foundations build") is observation-led — names the requirement that closes the gap without prescribing the fix. Same pattern as Plan 04's "the named DESIGN-* requirement carries the fix" rephrasing.

## Files Created

(none — `.planning/phases/01-audit/01-06-SUMMARY.md` after Plan execution closes; AUDIT.md modified in place.)

## Files Modified

- `.planning/AUDIT.md` — `## AUDIT-06: Version-String Mismatches` section populated (replaced placeholder body); 20 lines added, 1 deleted (per `git show --stat 6335593`)

## Commits

- `6335593` — feat(01-06): populate AUDIT-06 version-string mismatches

## Next Plan

Plan 07 (Wave 7) populates AUDIT-07 — Cosmetic-but-Client-Visible Issues. AUDIT-06 cross-refs AUDIT-07 for the cosmetic overlap on row #4 (root README plugin table) and row #5 (plugin README changelog truncation), so Plan 07 will land near-adjacent findings.

## Self-Check: PASSED

- File `.planning/AUDIT.md` exists and contains the 8-row AUDIT-06 table — verified.
- Commit `6335593` exists in `git log --oneline` — verified.
- All 9 acceptance criteria + all 7 plan-level success criteria pass — verified.
