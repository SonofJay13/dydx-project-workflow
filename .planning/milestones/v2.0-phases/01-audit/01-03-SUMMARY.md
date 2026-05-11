---
phase: 01-audit
plan: 03
subsystem: audit
tags: [audit, connector-dependencies, design-only, observation-led]
requires:
  - .planning/AUDIT.md (Wave 1 skeleton with AUDIT-03 placeholder)
  - .planning/codebase/INTEGRATIONS.md
  - .planning/research/PITFALLS.md
  - .planning/REQUIREMENTS.md (AUDIT-03, DESIGN-07)
  - .planning/phases/01-audit/01-CONTEXT.md (D-13, D-14)
provides:
  - .planning/AUDIT.md AUDIT-03 section populated with per-stage × per-connector dependency table + research-cited graceful-degradation hint sub-table
affects:
  - subsequent AUDIT-04..08 waves continue under same H2 conventions
  - DESIGN-07 (Phase 2) inherits the research-derived fallback matrix as input
tech-stack:
  added: []
  patterns:
    - "Markdown table with explicit cell-vocabulary enum for dependency status (none / referenced / optional / REQUIRED)"
    - "Pointer-only design references (`Closes via: DESIGN-NN`) per D-13 observation-led discipline"
key-files:
  created:
    - .planning/phases/01-audit/01-03-SUMMARY.md
  modified:
    - .planning/AUDIT.md (AUDIT-03 section populated)
decisions:
  - "Cell vocabulary fixed at 4 values: `(none)` / `(referenced in artefact only)` / `optional (graceful)` / `REQUIRED` — keeps observation precision tight without leaking design proposals"
  - "Live-wiring probe results (working/broken/missing) explicitly deferred to AUDIT-08; AUDIT-03 inventories dependency, not connectivity"
  - "Fallback hint sub-table sources 4 representative rows from PITFALLS.md (sample, not full mirror) to honour D-13 — full matrix is DESIGN-07's territory"
metrics:
  duration: ~10 min
  completed_date: 2026-05-09
---

# Phase 1 Plan 03: AUDIT-03 Per-Stage Connector Dependency Table Summary

**One-liner:** Populated AUDIT-03 with a 7-stage × 9-connector dependency matrix observing v0.3.0's artefact-driven reality (most cells `(none)`; only `discovery-intake` Miro and `execute-tests` Pipefy/Wrike/Ziflow show real connector coupling) plus a 4-row PITFALLS-cited graceful-degradation hint sub-table that points reviewers at DESIGN-07 without proposing the contract.

## What landed

**Section opener (single paragraph, 3 sentences):** States the artefact-driven nature of v0.3.0; names the two real-connector exceptions (`discovery-intake` Miro paste, `execute-tests` sandbox API calls); defers v2 Coda/Drive/Gmail/Calendar dependencies to **DESIGN-07** by name.

**Per-stage × per-connector dependency table:**
- **Stage rows:** 7 (one per v0.3.0 skill — discovery-intake, generate-sow, generate-functional-spec, generate-technical-spec, generate-test-plan, generate-build-prompt, execute-tests)
- **Connector columns:** 9 (Miro, Coda, Drive, Gmail, Calendar, Claude in Chrome, Pipefy API, Wrike API, Ziflow API)
- **Total cells:** 63
  - `(none)` cells: **51** (the artefact-driven reality; majority of cells)
  - `(referenced in artefact only)` cells: **8** (technical-spec / test-plan / build-prompt mention Pipefy/Wrike/Ziflow API contracts in their generated outputs but skills themselves don't invoke)
  - `optional (graceful)` cells: **1** (discovery-intake × Miro paste-in)
  - `REQUIRED` cells: **3** (execute-tests × Pipefy/Wrike/Ziflow per `platform:` dispatch)
- **Citation legend** below table points to `INTEGRATIONS.md §"Stage Pipeline Wiring"` (lines 175-197) + per-skill `SKILL.md` Inputs/Outputs as the consolidated source; explicitly defers live-wiring probe to AUDIT-08.

**Sub-section: Research-derived graceful-degradation hints:**
- Bold-keyed paragraph (not H3) per PATTERNS.md Pattern 2 — preserves AUDIT-01's exclusive H3 depth for skill subsections
- Paragraph names PITFALLS.md as the research source + DESIGN-07 as the v2 contract owner
- 4-row sample table covers Stage 6 (Coda → manual mode), Stage 9 (Drive → halt), Stage 10 (Pipefy/Wrike/Ziflow → copy-paste), Stage 1 (Miro → paste-in)
- Each row's `Closes via` cites DESIGN-07 + a secondary DESIGN-NN (DESIGN-22 / DESIGN-25 / DESIGN-26 / DESIGN-17)
- Closing pointer reads "Research-derived; v2 design contract = DESIGN-07" verbatim per RESEARCH.md §12 Open Q4 + cites pitfall IDs (CRIT-3, CRIT-5, MOD-1, MIN-2)
- Section closes with `---` separator before AUDIT-04

## Acceptance criteria status

| Criterion | Result |
|---|---|
| 10-column header (Stage + 9 connectors) detected | PASS |
| Exactly 7 stage rows | PASS (7) |
| At least one `REQUIRED` cell | PASS (3 cells: execute-tests × Pipefy/Wrike/Ziflow) |
| At least one `optional (graceful)` cell | PASS (1 cell: discovery-intake × Miro) |
| Citation legend present (`INTEGRATIONS.md`) | PASS |
| `DESIGN-07` references >= 2 | PASS (7 occurrences — fallback table + pointer + Closes-via cells) |
| `PITFALLS` reference present | PASS |
| Locked phrase "Research-derived" present | PASS |
| Sub-section fallback rows >= 4 | PASS (4 rows) |
| Section closes with `---` (>= 2 in AUDIT-03 span) | PASS (2 separators) |
| D-13 banned-phrase ERE = 0 (canonical: `we should\|the design will\|recommend that v2\|propose\|v2 will`) | PASS (0 matches) |
| 8 `## AUDIT-0[1-8]:` H2 anchors still present | PASS |

## Decisions made

- **D-03-01:** Cell-vocabulary enum locked at exactly 4 values to keep the observation tight: `(none)` / `(referenced in artefact only)` / `optional (graceful)` / `REQUIRED`. Any cell needing nuance gets cited inline in the citation legend, not in the cell — keeps the matrix scannable.
- **D-03-02:** Live-MCP probe results (working/broken/missing) live in AUDIT-08, not AUDIT-03. AUDIT-03 inventories *dependency* (which connector each stage needs); AUDIT-08 inventories *connectivity* (whether the wiring is live in this workspace). The split prevents reviewers conflating "stage uses connector X" with "X is currently working."
- **D-03-03:** Fallback hint sub-table is a 4-row sample, not a transcription of the full PITFALLS.md matrix. Honours D-13 (no design proposals) and the threat register's T-01-03-03 mitigation (sample, not mirror). Reviewers wanting the full matrix follow the `.planning/research/PITFALLS.md` cross-reference.

## Deviations from plan

None — plan executed exactly as written. Cell vocabulary, row count, column count, citation legend, sub-section paragraph header convention, and DESIGN-07 pointer phrasing all followed PLAN.md verbatim. No deviation rules triggered (no bugs found, no missing critical functionality, no blocking issues, no architectural changes needed).

## Threat surface scan

No new security-relevant surface introduced — this plan only edits a markdown audit document; no new endpoints, auth paths, file access patterns, or schema changes. Plan-level threat register entries (T-01-03-01 / T-01-03-02 / T-01-03-03) all mitigated by acceptance criteria gates that ran 0 banned-phrase matches and confirmed cell vocabulary against INTEGRATIONS.md citations.

## Pointer

**Plan 04 (Wave 4) populates AUDIT-04 next** — referenced-but-missing artefacts (the `platform-pipefy` / `platform-wrike` / `/refine-<skill>` / `commands/agents/hooks` orphan-reference inventory).

## Self-Check: PASSED

- File exists: `.planning/AUDIT.md` (modified — AUDIT-03 section populated)
- File exists: `.planning/phases/01-audit/01-03-SUMMARY.md` (this file)
- Commit `bcc0093` (Task 1) found in `git log`
- Commit `f8b6268` (Task 2) found in `git log`
- AUDIT-03 H2 still detected by `grep -cE '^## AUDIT-0[1-8]:'` = 8
