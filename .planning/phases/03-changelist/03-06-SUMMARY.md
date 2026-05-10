---
phase: 03-changelist
plan: 06
subsystem: changelist
tags: [changelist, change-04, appendix-c, research-blocked, design-only, inline-markers]
requirements: [CHANGE-04]
dependency_graph:
  requires:
    - 03-01 (scaffold + structural-check)
    - 03-02 (Phases 1-5 mini-tables — Phase 1 + Phase 2 Research-blocked cells)
    - 03-03 (Phases 6-9 mini-tables — Phase 7 D-37 fallback verbatim)
    - 03-04 (Appendix A — 20-row delta matrix)
    - 03-05 (Appendix B + Appendix D)
  provides:
    - Appendix C populated (CHANGE-04 — 2-row research-blocked matrix)
    - Phase 1 + Phase 2 Research-blocked cell enrichment (6 verbatim inline OPEN markers)
    - Reconciliation-readiness for Plan 03-07 synthesis (8 baseline markers + 1 Phase 3 new deferral)
  affects:
    - .planning/CHANGELIST.md (Appendix C body + Phase 1/Phase 2 Research-blocked cells)
tech_stack:
  added: []
  patterns:
    - D-42 "marker at point of use + closed list at end" carried from D-27
    - D-37 verbatim contingent-fallback sentence (cross-AI MEDIUM #6 mitigation)
key_files:
  created:
    - .planning/phases/03-changelist/03-06-SUMMARY.md
  modified:
    - .planning/CHANGELIST.md
decisions:
  - D-42 implementing — Appendix C as 2-row matrix with per-phase unknown-list + recommended /gsd-research-phase invocation
  - D-37 carried — verbatim contingent-fallback sentence in Appendix C Phase 7 row (NOT cross-referenced; full sentence per cross-AI MEDIUM #6)
  - D-27 carried — verbatim inline OPEN markers at point of use in Phase 1 + Phase 2 mini-tables
metrics:
  duration: ~10 min
  completed: 2026-05-10
  tasks: 2
  commits:
    - ca5ab1b (Task 1 — Appendix C populated)
    - bf02173 (Task 2 — Phase 1 + Phase 2 inline-marker enrichment)
---

# Phase 03 Plan 06: Change list — Appendix C + Phase 1/2 inline-marker enrichment Summary

**One-liner:** Populated Appendix C (CHANGE-04 research-blocked phases — Phase 1 + Phase 7 matrix with verbatim D-37 fallback) and enriched Phase 1 + Phase 2 mini-table Research-blocked cells with 6 verbatim inline `[OPEN: Phase 4 — ...]` markers from DESIGN.md Appendix E bullets 2, 3, 4, 5, 6, 7.

## What Shipped

**Task 1 — Appendix C populated (commit ca5ab1b):**
- Framing paragraph (D-42 default — single 2-row matrix; mirrors D-27 "marker at point of use + closed list at end" pattern)
- Phase 1 row: 5 connector probe items (Coda MCP version pin, Google Workspace MCP choice, Miro MCP existence, Wrike rate-limit currency, Ziflow auth header) + recommended `/gsd-research-phase 1` invocation
- Phase 7 row: 3 native-AI ingestion APIs (Pipefy AI KB content-upload endpoint, Wrike AI Studio knowledge-ingestion API, Ziflow ReviewAI knowledge-ingestion API) + OPEN-01 cross-reference + **verbatim D-37 contingent-fallback sentence** ("If OPEN-01 ... slide P8/P9 → v2.7 ...") + recommended `/gsd-research-phase 7` MANDATORY invocation marked HARD BLOCKER
- Closing paragraph cross-references Appendix E + CHANGE-04

**Task 2 — Phase 1 + Phase 2 inline-marker enrichment (commit bf02173):**
- Phase 1 Research-blocked cell appended with 2 verbatim markers (DESIGN.md Appendix E bullets 3, 5 — Pipefy + Wrike 2026 rate-limit currency)
- Phase 2 Research-blocked cell appended with 4 verbatim markers (DESIGN.md Appendix E bullets 2, 4, 6, 7 — Pipefy GraphQL pagination cursor / Wrike AI Studio API / Ziflow ReviewAI API / Ziflow read-after-create consistency window)
- Original `⚠` summary text preserved in both cells (no overwrite)
- 6 row labels intact in each mini-table

## Verification Results

**Task 1 automated verify:** PASS (`TASK_1_OK` — all 8 substring checks succeeded, 2 phase rows confirmed)

**Task 2 automated verify:** PARTIAL — all 6 markers correctly placed and all structural integrity checks pass, but cumulative-count assertion `[ "$CUMULATIVE" = "8" ]` returned 9 (one above expected). See Deviations.

**Structural-check status (after final commit):**
- **Expected:** EXIT=1 (assertion #10 — Appendix E ≥ 8 bullets — STILL FAILS because Appendix E body still empty; all other assertions PASS)
- **Actual:** EXIT=1 with `FAIL: Appendix E must enumerate >= 8 [OPEN: Phase 4 — ...] bullets ... found 0`
- **Match:** Exactly as documented in PLAN.md verification §9. All other 11 assertions pass. Plan 03-07 (Wave 7) unblocks Appendix E.

**Other manual integrity checks:**
- Phase 1 + Phase 2 mini-tables retain all 6 row labels (Deliverables / Depends on / Addresses / Avoids pitfalls / Skills introduced/modified / Research-blocked): confirmed via grep
- Phase 1 + Phase 2 prefix `⚠ ...` summaries preserved: confirmed via `grep -qF`
- Phase 4 risk-multiplier marker (Plan 03-02): unchanged
- Phase 7 Pipefy AI KB marker (Plan 03-03): unchanged
- Phase 9 plugin self-test marker (predecessor wave): unchanged

## Deviations from Plan

**1. [Rule 1 — Plan-vs-reality bug] Cumulative inline-marker count = 9, not 8 as expected by PLAN.md must-haves**

- **Found during:** Task 2 automated verify (the `CUMULATIVE` awk-pipe assertion).
- **Issue:** PLAN.md line 21 + Task 2 acceptance criteria expected exactly 8 unique inline `[OPEN: Phase 4 — ...]` markers in CHANGELIST.md body outside Appendix E (matching DESIGN.md Appendix E baseline). Reality at end of Plan 03-06 is 9 unique markers. The 9th is `[OPEN: Phase 4 — plugin self-test scope per OPEN-07]` in Phase 9 mini-table Deliverables row item (g).
- **Root cause:** This 9th marker was placed in Phase 9 by Plan 03-03 (Wave 3 — Phases 6-9 mini-tables) per CONTEXT.md "Deferred Ideas" line 254 and per D-27 carried discipline ("New deferrals discovered during Phase 3 authoring add a row here AND inline at point of use"). It is a legitimate net-new Phase 3 deferral pulled forward from REQUIREMENTS.md OPEN-07 (plugin self-test scope), NOT one of the 8 DESIGN.md baseline bullets.
- **Why this is a plan bug, not an execution bug:** PLAN.md framed cumulative count as `= 8` (DESIGN.md baseline). PLAN.md should have framed it as `>= 8` (baseline minimum, with new Phase 3 deferrals additive per D-27). The `changelist-structure-check.sh` Appendix E assertion correctly uses `>= 8`. The 9 markers exactly are: 8 DESIGN.md baseline + 1 net-new Phase 3 deferral (OPEN-07).
- **Fix:** None required to CHANGELIST.md. The 9 markers are correct. Plan 03-07 reconciliation walks all 9 → emits 9 rows in Appendix E. Reconciliation algorithm in Plan 02-10 supports this naturally (it walks unique markers, not a fixed 8-count).
- **Files modified:** None.
- **Reviewer attestation note:** Plan 03-07 must populate Appendix E with 9 bullets (8 DESIGN.md baseline + 1 plugin-self-test-scope OPEN-07). The structural-check `>= 8` floor accommodates this without modification.

## Auth Gates

None.

## Cumulative Inline-Marker Inventory (Plan 03-07 reconciliation input)

CHANGELIST.md body now carries the following 9 unique inline `[OPEN: Phase 4 — ...]` markers in document order (excluding Appendix E):

1. **(Phase 1 mini-table — Plan 03-06)** Pipefy 2026 rate-limit currency — DESIGN.md bullet 3
2. **(Phase 1 mini-table — Plan 03-06)** Wrike 2026 rate-limit currency — DESIGN.md bullet 5
3. **(Phase 2 mini-table — Plan 03-06)** Pipefy GraphQL pagination cursor field names — DESIGN.md bullet 2
4. **(Phase 2 mini-table — Plan 03-06)** Wrike AI Studio knowledge-ingestion API — DESIGN.md bullet 4
5. **(Phase 2 mini-table — Plan 03-06)** Ziflow ReviewAI knowledge-ingestion API — DESIGN.md bullet 6
6. **(Phase 2 mini-table — Plan 03-06)** Ziflow read-after-create consistency window — DESIGN.md bullet 7
7. **(Phase 4 mini-table — Plan 03-02)** risk-multiplier defaults pending dYdX-historical validation — DESIGN.md bullet 8
8. **(Phase 7 mini-table — Plan 03-03)** Pipefy AI KB content-upload endpoint — DESIGN.md bullet 1
9. **(Phase 9 mini-table deliverable (g) — Plan 03-03)** plugin self-test scope per OPEN-07 — net-new Phase 3 deferral per D-27

## CHANGE-04 Status

**COMMITTED.** Research-blocked phases flagged BOTH inline (D-42 marker at point of use — Phase 1 + Phase 2 + Phase 7 mini-tables) AND in dedicated Appendix C closed list (D-42 closed list at end). ROADMAP Phase 3 success criterion 4 satisfied.

## Pointer to Plan 03-07

Plan 03-07 (Wave 7 — synthesis) is the FINAL plan:
- Executive Summary table (5 cols: Phase / Milestone / Theme / Skills delta count / Blocker)
- "How to read this change list" reader-flow guide
- Appendix E mechanical walk: 9 bullets enumerating the 9 inline markers (per Phase 2 02-10 reconciliation algorithm)
- Final preamble (frontmatter / changelist-date / branch-commit fields)
- Final structural-check pass (all 12 assertions exit 0; final no-placeholder assertion passes once `(Populated by 03-07-PLAN.md / Wave 2 synthesis...)` skeleton stub in Appendix E is replaced with mechanical-walk content)

After Plan 03-07 completes, `.planning/CHANGELIST.md` is reviewer-ready and ready for Phase 3 approval gate review per ROADMAP.

## Self-Check: PASSED

- File `.planning/CHANGELIST.md` modified — confirmed via git log
- Commit `ca5ab1b` (Task 1) — confirmed via `git log --oneline`
- Commit `bf02173` (Task 2) — confirmed via `git log --oneline`
- File `.planning/phases/03-changelist/03-06-SUMMARY.md` created — this file
- All 6 verbatim markers present and byte-identical to DESIGN.md Appendix E source — confirmed via `grep -qF`
- Phase 1 + Phase 2 row-label counts = 6 each — confirmed via `grep -cE`
- Original `⚠` summary text preserved in both cells — confirmed via `grep -qF`
- Pre-existing markers from Plans 03-02 / 03-03 unchanged — confirmed via `grep -qF`
- Structural-check exit code matches PLAN.md expectation (EXIT=1, only Appendix E assertion #10 fails) — confirmed
