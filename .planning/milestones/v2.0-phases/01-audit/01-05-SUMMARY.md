---
phase: 01-audit
plan: 05
subsystem: audit
tags: [audit, duplicated-content, design-only]
requires:
  - .planning/phases/01-audit/01-RESEARCH.md
  - .planning/codebase/CONCERNS.md
  - .planning/REQUIREMENTS.md
provides:
  - "AUDIT-05 section: 5 H3 subsections (4 confirmed dups + 1 [NEW] label collision)"
affects:
  - .planning/AUDIT.md
tech-stack:
  added: []
  patterns:
    - "Pattern 6 — pipe-style markdown tables with Location/Lines/Role columns"
    - "Pattern 4 — bracketed [STRUCTURAL] severity tag at end of bullet"
    - "Pattern 4 — [NEW] tag preceding severity per D-10"
    - "Pattern 5 — **Closes via:** DESIGN-NN trailer line per D-13"
    - "Compact `file:line` citation form per D-14"
key-files:
  created: []
  modified:
    - .planning/AUDIT.md
decisions:
  - "Hard-rules duplication framing locked at '4 mentions; 3 duplicates of 1 canonical' per RESEARCH.md §12 Open Q6 (corrects CONCERNS.md's 'three places' wording)"
  - "5.5 [NEW] Stage-N label collision citations split onto separate bullet lines so each `file:line` citation matches the per-line acceptance regex (Rule 1 fix during verification)"
  - "5.4 pipeline diagram retains BOTH copies as 'CANONICAL' for distinct lenses (high-level overview vs tool-transition swimlane); audit logs visual-drift risk without prescribing consolidation"
metrics:
  duration: ~12 min
  completed: 2026-05-09
---

# Phase 1 Plan 05: AUDIT-05 Duplicated Content Blocks Summary

AUDIT-05 populated with 5 H3 subsections — 4 confirmed duplicate-content categories from CONCERNS.md plus 1 [NEW] Stage-N label collision — each naming canonical source (or "none today" gap) and the DESIGN-* closure that addresses it.

## What Was Built

**Subsection** | **Topic** | **Citation count** | **Canonical source** | **Closes via**
---|---|---|---|---
5.1 | Hard-rules block | 4 (1 canonical + 3 dups) | `dydx-delivery/skills/execute-tests/references/safety-rules.md` | DESIGN-03 + MOD-16
5.2 | Start-at-any-point triage | 6 SKILL.md copies | None today (gap named) | DESIGN-11 + FOUND-02
5.3 | Cowork-vs-Claude-Code positioning | 3 copies | `when-to-open-claude-code.md` | DESIGN-10
5.4 | Pipeline diagram | 2 copies (distinct lenses) | Both retained | DESIGN-12
5.5 [NEW] | Stage-N label collision | 2 templates labelled "Stage 6" | n/a (label conflict) | DESIGN-02

**Citation totals:** 17 distinct `file:line` references across 5 subsections (4 in 5.1; 6 in 5.2; 3 in 5.3; 2 in 5.4; 2 in 5.5).

**Severity tags applied:** 5 [STRUCTURAL] tags (one per subsection); 1 [NEW] tag on 5.5 per D-10.

**DESIGN-* closures referenced:** DESIGN-02, DESIGN-03, DESIGN-10, DESIGN-11, DESIGN-12 (5 distinct DESIGN requirements anchored).

## Verification Results

All Task 1 acceptance criteria pass:
- `grep -cE '^### 5\.[1-4] '` returns 4
- `**Canonical source:**` lines: 4 (one per 5.1-5.4)
- `**Closes via:**` lines: 4 (one per 5.1-5.4)
- DESIGN-03/10/11/12 references: 4 distinct
- 5.2 SKILL.md citations: 6 (one per skill)
- 5.1 `safety-rules.md` mentions: 3 (canonical-source named)
- 5.1 dydx-delivery citations: 6 (>=4 required)
- [STRUCTURAL] tags in section: 4 (>=4 required)
- D-13 banned-phrase ERE (`we should|the design will|recommend that v2|propose|v2 will`): **0**

All Task 2 acceptance criteria pass:
- `### 5.5 [NEW] Stage-N label collision` header match: 1
- 5.5 template citations (build-prompt-template + results-template): 2
- [NEW] tag in 5.5: 1
- [STRUCTURAL] tag in 5.5: 1
- DESIGN-02 ref in 5.5: 1
- Total `5.[1-5]` H3 subsections: 5
- 8 AUDIT-0N H2 sections preserved (structural-check invariant intact)

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] 5.5 acceptance regex required per-line citation match**
- **Found during:** Task 2 verification
- **Issue:** PLAN's drafted Task-2 prose had both Stage-6 template citations on a single semicolon-separated line. Acceptance regex `grep -cE '\`dydx-delivery/skills/.*/(build-prompt-template|results-template)\.md:[0-9]+'` is line-counted (`-c`), so the inline form scored 1 instead of the required >=2.
- **Fix:** Split the two citations onto separate bullet lines under a `Citations:` lead-in. Same content; better grep-ability (and consistent with D-14's per-citation-on-its-own-line discipline used in §5.1-5.4 tables).
- **Files modified:** `.planning/AUDIT.md` (5.5 only)
- **Commit:** Folded into c9b8926 (caught before commit)

No other deviations. Tasks 1 and 2 transcribed RESEARCH.md §6 content with the canonical-source framing already pre-decided in the plan's `<interfaces>` block.

## Authentication Gates

None. Audit-only document edits; no live-MCP calls in this plan.

## Threat Flags

None. AUDIT-05 only modifies `.planning/AUDIT.md` (audit deliverable). No new endpoints, auth surfaces, or trust-boundary changes.

## Pointer

Plan 06 (Wave 6) populates AUDIT-06 next — version-string mismatches across manifests and docs (D-17 locks `2.0.0` as the synced target version).

## Self-Check: PASSED

- `.planning/AUDIT.md` exists and contains `## AUDIT-05: Duplicated Content Blocks` opener + `### 5.1`–`### 5.5` H3 subsections (verified by grep).
- Commit `bf93049` (Task 1 — sections 5.1-5.4) present in `git log --oneline -5`.
- Commit `c9b8926` (Task 2 — section 5.5 [NEW]) present in `git log --oneline -5`.
- 8 AUDIT-0N H2 sections preserved (structural-check invariant).
- D-13 banned-phrase ERE returns 0 across the AUDIT-05 section.
