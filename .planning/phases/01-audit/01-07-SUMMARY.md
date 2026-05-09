---
phase: 01-audit
plan: 07
subsystem: audit
tags: [audit, cosmetic-issues, design-only, v2.1-deferred, AUDIT-07]
dependency_graph:
  requires:
    - .planning/AUDIT.md (AUDIT-07 placeholder from Plan 01)
    - .planning/phases/01-audit/01-RESEARCH.md §8 (pre-built citations + FOUND-* mapping)
    - .planning/phases/01-audit/01-CONTEXT.md (D-10, D-13, D-14, D-15, D-16)
    - .planning/phases/01-audit/01-PATTERNS.md (canonical sentinel wording)
  provides:
    - AUDIT-07 populated with 6 H3 cosmetic-fix subsections (7.1–7.6)
    - per-bullet D-16 sentinel on every fix bullet (>=6 case-insensitive matches inside AUDIT-07)
    - [COSMETIC] severity tags (6), [NEW] tag on 7.6
    - FOUND-04 + FOUND-07 traceability links to v2.1 build
    - structural-check assertion #3 (case-insensitive ERE 'scheduled for v2\.1 (foundations )?build') now passes
  affects:
    - .planning/AUDIT.md (AUDIT-06 opener reworded — Rule 1 fix; sentinel leakage scrubbed)
tech_stack:
  added: []
  patterns:
    - per-bullet sentinel enforcement (D-16) — phrase carried on every bullet, not section header alone
    - leakage-gate scrubbing — phrase confined to AUDIT-07 only (T-01-07-04 mitigation)
key_files:
  created:
    - .planning/phases/01-audit/01-07-SUMMARY.md
  modified:
    - .planning/AUDIT.md (AUDIT-07 populated; AUDIT-06 opener reworded)
decisions:
  - applied D-16 (per-bullet v2.1 sentinel) — canonical uppercase form 'Scheduled for v2.1 Foundations build (FOUND-NN), NOT this milestone.' on every bullet
  - applied D-10 ([NEW] tag on 7.6 homepage asymmetry — CONCERNS flagged but did not formally categorize)
  - applied D-14 (compact `file:line` citations), D-15 ([COSMETIC] inline tag)
  - Rule 1 fix during verification — rewrote AUDIT-06 opener to drop the sentinel phrase ('scheduled for v2.1 Foundations build (FOUND-04)' → 'lands in the v2.1 Foundations work (FOUND-04)') so Plan 07's leakage check (awk AUDIT-01..AUDIT-07 | grep -ciE returns 0) passes per threat model T-01-07-04. Same meaning; phrase containment restored.
metrics:
  duration: ~7 min
  completed: 2026-05-09
  tasks: 1
  files_modified: 1
---

# Phase 1 Plan 07: AUDIT-07 Cosmetic-but-Client-Visible Issues Summary

Transcribed RESEARCH.md §8's 6 pre-built cosmetic findings into AUDIT-07 with per-bullet v2.1 deferral sentinels (D-16), [COSMETIC]/[NEW] severity tags, and FOUND-04/FOUND-07 traceability — and scrubbed a leaked sentinel phrase from AUDIT-06's opener so the leakage gate passes.

## What Was Done

- **AUDIT-07 populated** with section opener (paragraph naming D-16 per-bullet enforcement rationale) plus 6 H3 subsections in `.planning/AUDIT.md` (lines 446–502):
  - **7.1** README truncation (plugin-level) — `dydx-delivery/README.md:126` — closed by FOUND-07
  - **7.2** Residual "test sheet" wording — `README.md:9` + `dydx-delivery/README.md:126` — closed by FOUND-07
  - **7.3** Pipeline-step count mismatch (root README) — `README.md:9` + `.claude-plugin/marketplace.json:15` + `dydx-delivery/.claude-plugin/plugin.json:4` + `dydx-delivery/README.md:33-41` — closed by FOUND-07
  - **7.4** Missing LICENSE file — `dydx-delivery/.claude-plugin/plugin.json:10` + `.claude-plugin/marketplace.json` (no license field) — closed by FOUND-04
  - **7.5** Owner-email mismatch with stated org — `.claude-plugin/marketplace.json:5` + `dydx-delivery/.claude-plugin/plugin.json:7,4` + `.claude-plugin/marketplace.json:4` — closed by FOUND-04 (cross-ref MIN-6 PITFALL)
  - **7.6** [NEW] Homepage asymmetry — `dydx-delivery/.claude-plugin/plugin.json:9` + `.claude-plugin/marketplace.json` (no homepage) — closed by FOUND-04

- **Per-bullet D-16 sentinel** on every fix line (canonical wording: `**Scheduled for v2.1 Foundations build (FOUND-NN), NOT this milestone.**`) — 7 case-insensitive matches inside AUDIT-07.
- **[COSMETIC] tags** on every subsection's severity line (6 matches). **[NEW]** tag added to 7.6.
- **FOUND-* traceability:** FOUND-07 referenced 4× (7.1, 7.2, 7.3, plus shared in opener); FOUND-04 referenced 4× (7.4, 7.5, 7.6, plus shared in opener).

## Acceptance Criteria — All Pass

| Check | Required | Actual |
|-------|----------|--------|
| H3 subsection count `^### 7\.[1-6] ` | = 6 | 6 |
| Sentinel count inside AUDIT-07 (case-insensitive ERE) | >= 6 | 7 |
| `[COSMETIC]` tag count inside AUDIT-07 | >= 6 | 6 |
| `[NEW]` tag in 7.6 | present | OK |
| FOUND-04 references in AUDIT-07 | >= 3 | 4 |
| FOUND-07 references in AUDIT-07 | >= 3 | 4 |
| Citation paths matching key-link pattern | >= 6 | 9 |
| Structural-check assertion #3 (sentinel anywhere in AUDIT.md) | passes | OK |
| Sentinel leakage check (`awk AUDIT-01..AUDIT-07 | grep -ciE`) | = 0 | 0 |
| Banned-phrase ERE inside AUDIT-07 | = 0 | 0 |

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] AUDIT-06 opener leaked the canonical D-16 sentinel into a non-AUDIT-07 section**
- **Found during:** Task 1 verification (leakage check returned 1, not 0)
- **Issue:** Plan 06's AUDIT-06 opener at `.planning/AUDIT.md:423` contained the phrase `"the actual version bump is scheduled for v2.1 Foundations build (FOUND-04), not this design milestone"` — a case-insensitive match for the leakage gate ERE `'scheduled for v2\.1 (foundations )?build'`. Plan 07's threat model T-01-07-04 specifically forbids this leakage; PATTERNS.md "Forbidden anywhere else" makes the rule explicit. Without the fix, Plan 07 cannot satisfy success criterion 7 (leakage check returns 0).
- **Fix:** Reworded the AUDIT-06 opener to `"the actual version bump lands in the v2.1 Foundations work (FOUND-04), not this design milestone"`. Same semantic content (v2.1 build closes the gap; not this milestone), but no token sequence matching the canonical sentinel ERE. Banned-phrase ERE also still returns 0 against the new wording. AUDIT-06's other gates (D-17 `2.0.0` recommendation, structural-check assertion #8 for the version-mismatch table) are untouched.
- **Files modified:** `.planning/AUDIT.md` (single-line edit in AUDIT-06 opener)
- **Commit:** `40b5a72` (single Task 1 commit — opener edit batched with AUDIT-07 population since both are the same atomic Plan-07 unit-of-work and `files_modified` lists `.planning/AUDIT.md` only)

## Authentication Gates

None.

## Threat Surface Scan

No new security-relevant surface introduced. AUDIT-07 documents existing v0.3.0 cosmetic issues; no network endpoints, auth paths, or trust-boundary changes. Threat model T-01-07-01..05 mitigations all in force per acceptance evidence above.

## TDD Gate Compliance

N/A (plan type: `execute`, not `tdd`).

## Pointer

Plan 08 (Wave 8) populates AUDIT-08 (live MCP wiring probe) next. AUDIT-08 + Wave 9 closeout (Appendix A glossary, Appendix B CONCERNS-trace, structural-check assertion #4 absorption claim) complete Phase 1.

## Self-Check: PASSED

- FOUND `.planning/AUDIT.md` (52 lines added in AUDIT-07; opener edit in AUDIT-06)
- FOUND commit `40b5a72` in `git log --oneline`
