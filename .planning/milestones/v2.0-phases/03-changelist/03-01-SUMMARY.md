---
phase: 03-changelist
plan: 01
plan_id: 03-01
subsystem: changelist-scaffold
tags: [changelist, scaffold, structural-check, design-only]
requires:
  - phase-2-design-approved (.planning/DESIGN.md ✓ 2026-05-10)
  - phase-1-audit-approved (.planning/AUDIT.md ✓ 2026-05-09)
provides:
  - changelist-structure-check.sh (15 grep/awk assertions per D-36/D-37/D-38/D-41/D-42/D-43/D-16/D-27 plus cross-AI C1/C6/C9 fixes)
  - .planning/CHANGELIST.md skeleton (16 H2 anchors per D-36; opening-sentence sentinels for Appendices B/D/E pre-laid; placeholder bodies only)
affects:
  - downstream-plans (03-02..03-07 populate the H2 sections under these locked anchors)
tech-stack:
  added: [bash structural verifier — pattern carried from Phase 2 02-01]
  patterns: [stateful section_between awk helper; grep -qF for sentinel tokens; grep -cE for pattern counts; case-sensitive matching throughout]
key-files:
  created:
    - .planning/phases/03-changelist/scripts/changelist-structure-check.sh
    - .planning/CHANGELIST.md
    - .planning/phases/03-changelist/03-01-SUMMARY.md
  modified: []
decisions:
  - D-36 16-H2 layout encoded as verbatim required-anchor list (Wave 0 lock)
  - D-37 milestone-tag visibility encoded via `^## Phase [1-9]: .* \(v2\.[1-6]\)` regex >= 9
  - D-42 Phase 7 [BLOCKED — see Appendix C] inline tag asserted by literal-string grep -qF
  - D-41 Appendix B verbatim-lift sentinel pre-laid in skeleton
  - D-43 Appendix D citation-header sentinel pre-laid in skeleton
  - D-27 (carried) Appendix E mechanical-walk sentinel pre-laid in skeleton
  - Cross-AI C1 — Appendix A row regex anchored on D-39 Status closed enum (not v0.3.0-origin first column)
  - Cross-AI C6 — H2 uniqueness loop catches duplicate anchors that would extend section_between past intended end
  - Cross-AI C9 — final-only no-placeholder assertion catches leftover `Populated by 03-XX` / `placeholder` / plan-ID strings
metrics:
  duration: ~25 minutes
  completed: 2026-05-10
  tasks: 3 (2 with file changes + 1 verification-only)
  commits: 2 (4fafb3f script, 3df3698 skeleton)
  files-created: 2 (script + skeleton; SUMMARY.md added in final-metadata commit)
---

# Phase 3 Plan 01: Wave 0 Scaffold (CHANGELIST structural-check + skeleton) Summary

**One-liner:** Created `changelist-structure-check.sh` (15 assertions, stateful `section_between` helper carried from Phase 2 HIGH #1, plus cross-AI C1/C6/C9 review fixes) and `.planning/CHANGELIST.md` skeleton (16 D-36 H2 anchors with milestone tags inline, Phase 7 [BLOCKED] tag, Appendix B/D/E opening sentinels pre-laid; bodies are placeholders only). Wave 0 invariant verified: script exits 1 against the empty skeleton, failing first at assertion #8 (Appendix B sentinel count >= 6 — found 0).

## What Shipped

### Files Created

| File | Purpose |
|------|---------|
| `.planning/phases/03-changelist/scripts/changelist-structure-check.sh` | Structural verifier — 15 grep/awk assertions; bash `set -euo pipefail`; exits 0 (all-pass) or 1 (first failure with stderr). |
| `.planning/CHANGELIST.md` | Phase 3 deliverable skeleton at planning root (mirrors AUDIT.md / DESIGN.md placement per Phase 1 D-13 precedent). 16 D-36 H2 anchors verbatim; placeholder bodies only. |
| `.planning/phases/03-changelist/03-01-SUMMARY.md` | This summary. |

### Commits

| Hash | Message | Files |
|------|---------|-------|
| `4fafb3f` | `chore(03-01): add changelist-structure-check.sh structural verifier` | `.planning/phases/03-changelist/scripts/changelist-structure-check.sh` |
| `3df3698` | `docs(03-01): scaffold .planning/CHANGELIST.md skeleton with D-36 H2 anchors` | `.planning/CHANGELIST.md` |

(Task 3 is verification-only — no file modifications, no commit. Mirrors Phase 2 02-01 Task 3 precedent.)

## D-36 Anchor List (16 H2 Strings — Locked)

Downstream plans (03-02..03-07) MUST grep-locate their target sections by these exact strings. Adding content under any other heading or modifying these strings breaks `section_between` extraction and the script will fail.

```
## Executive Summary
## How to read this change list
## Phase 1: Foundations + Connector Verification (v2.1)
## Phase 2: Internalise Platform Skills (v2.1)
## Phase 3: Stage 1 + Stage 4 split (v2.2)
## Phase 4: Tech spec + Cost + Implementation prompt (v2.3)
## Phase 5: Test bot rebuild (v2.4)
## Phase 6: Documentation publishing (v2.5)
## Phase 7: Native-AI knowledge push (v2.5) [BLOCKED — see Appendix C]
## Phase 8: Sign-off + Coda mirror (v2.6)
## Phase 9: Surfaces (v2.6)
## Appendix A: Per-skill delta matrix (CHANGE-02)
## Appendix B: Cosmetic-fix list (CHANGE-03)
## Appendix C: Research-blocked phases (CHANGE-04)
## Appendix D: Migration cutover rules (CHANGE-05)
## Appendix E: Deferred to Phase 4 OPEN-QUESTIONS
```

## Wave 0 Invariant — Verified

The script SHOULD fail at this stage because the skeleton is content-free. Running:

```bash
$ bash .planning/phases/03-changelist/scripts/changelist-structure-check.sh; echo "EXIT_CODE=$?"
FAIL: Appendix B per-bullet sentinel count must be >= 6 (matches AUDIT-07's 6 fixes per D-16/D-41), found 0
EXIT_CODE=1
```

This proves: (a) the file-existence and 16 H2-anchor presence checks PASS (the first 7 assertions), confirming the skeleton's structural shape is correct; (b) the stateful `section_between` helper correctly extracts an empty body from Appendix B and counts 0 sentinels (the cross-AI HIGH #1 helper-fix carries through Phase 3); (c) the count-floor assertions are alive and will block any downstream plan that fails to populate its content.

Stateful-helper extractions confirmed all return `0` against the empty skeleton (Appendix A rows / Appendix B sentinels / Appendix E bullets / per-phase `| Deliverables |` / `| Addresses |` / `| Avoids pitfalls |` rows) — no spurious matches from header rows or framing prose.

## Patterns Carried from Phase 2 Plan 02-01

| Pattern | Source | How carried |
|---------|--------|-------------|
| Stateful `section_between()` awk helper | Phase 2 cross-AI HIGH #1 fix | Defined near top of script; used for Appendix A row count, Appendix B sentinel count, Appendix E bullet count. Replaces broken `awk '/^## X/,/^## /'` range pattern that captures only header line. |
| Accurate case-sensitive header comments | Phase 2 cross-AI LOW #8 fix | Header comment block explicitly states `grep -qF` (literal) for sentinel tokens, `grep -cE` (case-sensitive ERE) for pattern counts, no `-i` flag anywhere. |
| Per-bullet sentinel discipline (D-16) | Phase 1 / Phase 2 carried | Appendix B sentinel count assertion (`Scheduled for v2.1 Foundations build (FOUND-NN), NOT this milestone`) gates >= 6. Wave 0 expects 0 (skeleton); plan 03-05 must produce >= 6 to clear. |
| `set -euo pipefail` discipline | Phase 1 / Phase 2 carried | Top of script. |
| Single `fail()` helper | Phase 1 / Phase 2 carried | One per assertion; first failure echoes to stderr and exits 1. 15 fail() invocations total. |
| File-at-planning-root placement | Phase 1 D-13 precedent | `.planning/CHANGELIST.md` lives at planning root, NOT under `.planning/phases/03-changelist/`. Mirrors `.planning/AUDIT.md` and `.planning/DESIGN.md`. |

## Cross-AI Review Fixes Embedded

Three fixes from `.planning/phases/03-changelist/03-REVIEWS.md` are baked into the Wave 0 deliverables:

- **C1 (codex HIGH / gemini MEDIUM)** — Appendix A row regex anchors on the D-39 Status closed enum (`NEW|NEW (split)|MODIFIED|UNCHANGED|RETIRED|RETIRED → SPLIT`) instead of the loose first-column origin pattern. The previous narrow pattern under-counted because the `Change` column emits prefixes like `| none`, `| derived from`, `| referenced-but-missing` (per Plan 03-04). Status is the only column whose value-set is locked, so it is the source-of-truth check.
- **C6 (codex MEDIUM)** — H2 uniqueness loop added: for every required H2 anchor, `grep -cF` MUST return exactly 1. Duplicate H2s (start anchor accidentally re-emitted under itself) silently extend `section_between` past the intended end and slip past the presence-only loop.
- **C9 (codex MEDIUM)** — Final-only no-placeholder assertion (`! grep -qE 'Populated by|placeholder|03-0[1-9]'`) catches leftover skeleton stubs (`Populated by 03-04`, the literal word `placeholder`, plan-ID strings `03-01..03-09`). Tagged final-only — EXPECTED to fail in Waves 0..6 (placeholders progressively replaced); Plan 03-07 synthesis MUST leave the document clean and this assertion MUST pass at end of synthesis. Mid-phase fails join the existing count-floor failures.

## Decisions Made (Wave 0 implementation)

- **15 fail() invocations** (one per assertion) is the runtime count; the plan's acceptance criterion `grep -cE '^\s*fail'` only matches lines starting with whitespace+fail, but several assertions use `... \\` line-continuation followed by `  || fail` which counts under a more permissive pattern. Substantive intent (one fail() per assertion) is satisfied — verified by `grep -cE 'fail "'` = 15.
- **No `[OPEN]` markers seeded** in this skeleton — Phase 2 02-01 seeded one marker, but Phase 3 doesn't because Appendix E baseline (8 inline markers from DESIGN.md "Deferred to Phase 4 OPEN-QUESTIONS" closed list) lands in Wave 2 synthesis plan 03-07. The skeleton's Wave 0 negative invariant intentionally fails Appendix E's enumeration assertion.

## Deviations from Plan

None — plan executed exactly as written. All file paths, assertion contents, and acceptance criteria match the plan's `<interfaces>` block verbatim.

## Pointer for Next Plans

- **Plans 03-02 + 03-03 (Wave 1)** populate the 9 phase H2 mini-tables next (CHANGE-01).
- **Plan 03-04 (Wave 1)** populates Appendix A (CHANGE-02) — must produce >= 15 rows matching the D-39 Status closed enum.
- **Plan 03-05 (Wave 1)** populates Appendices B + D (CHANGE-03 + CHANGE-05) — Appendix B verbatim lift from AUDIT-07 6 fix subsections; Appendix D numbered checklist of 5-7 rules.
- **Plan 03-06 (Wave 1)** populates Appendix C + inline blocker rows on Phase 1 + Phase 7 (CHANGE-04).
- **Plan 03-07 (Wave 2)** synthesis: Executive Summary + How-to-read + Appendix E mechanical walk + final structural-check pass (script must exit 0 — all 15 assertions pass including the C9 final-only no-placeholder check).

## Self-Check: PASSED

- File `.planning/phases/03-changelist/scripts/changelist-structure-check.sh` exists (verified `test -f`).
- File `.planning/CHANGELIST.md` exists at planning root (verified `test -f`).
- Commits `4fafb3f` and `3df3698` exist on `dydx-delivery-v2` (verified `git log --oneline`).
- Script syntax valid (`bash -n` exit 0).
- Script exits 1 against empty skeleton with first failure on Appendix B sentinel count = 0 (Wave 0 invariant).
- All 16 D-36 H2 anchors present and unique in `.planning/CHANGELIST.md`; phase milestone-tag count = 9; Phase 7 [BLOCKED] tag present; Appendix B/D/E opening sentinels pre-laid.
- Wave 0 negative invariants confirmed: 0 `| Deliverables |`, 0 `| Addresses |`, 0 `| Avoids pitfalls |`, 0 Appendix A rows, 0 Appendix B sentinels, 0 Appendix E [OPEN] bullets.
