---
phase: 01-audit
plan: 02
subsystem: audit-deliverable
tags: [audit, per-skill-inventory, design-only, AUDIT-01]
requires:
  - "01-audit/01 (Wave 1 scaffold — `.planning/AUDIT.md` skeleton + structural-check script)"
provides:
  - "AUDIT-01 section in `.planning/AUDIT.md` populated with 7-row matrix + 7 prose subsections"
  - "Routes 15 distinct DESIGN-* requirements as gap closers (DESIGN-01/02/03/04/12/14/15/16/17/18/19/20/21/23/24)"
affects:
  - "AUDIT-02 (CONCERNS.md absorption) — every CONCERNS.md per-skill brittleness finding now has a destination subsection in AUDIT-01 (status-lifecycle inconsistencies, sandbox-block coupling, based_on_* underscore-vs-hyphen, start-at-any-point block, hard-rules duplication, Stage-N label collisions)"
  - "AUDIT-04 (Referenced-but-Missing) — three [BLOCKING] flags forward the platform-pipefy/platform-wrike orphan to its primary AUDIT-04 home"
  - "AUDIT-05 (Duplicated content) — start-at-any-point block 6/6, hard-rules block 2/4, Cowork-vs-Claude-Code 3/3 mentions cross-ref forward"
tech-stack:
  added: []
  patterns:
    - "Pattern 2 (H2 + bold-keyed mini-headers + `---` separator)"
    - "Pattern 3 (compact `file:line` citation, backtick-wrapped, ASCII-hyphen ranges)"
    - "Pattern 4 (severity tag `**[BLOCKING]**` / `**[STRUCTURAL]**` end-of-bullet)"
    - "Pattern 5 (`**Closes via:** DESIGN-NN ...; DESIGN-MM ....` trailer + `**Pitfall ref:** CRIT-X` line)"
    - "Pattern 6 (pipe-table, no alignment colons, backtick-wrapped citations in cells)"
    - "Pattern 8 (bold-keyed paragraph header + bullet list of one-observation-per-bullet)"
key-files:
  created: []
  modified:
    - ".planning/AUDIT.md (AUDIT-01 section: framing paragraph + 7-row matrix + 7 H3 subsections; +166 lines)"
decisions:
  - "Each per-skill subsection emits exactly three bold-keyed mini-headers (Hand-off contract / Observed brittleness / What's missing for v2) — no skill omits any header even if a section would be terse, because reviewers scan for the contract triplet."
  - "`generate-build-prompt` hand-off is documented as a tool transition (Cowork → Claude Code) rather than a next-skill pointer, mirroring the SKILL body — no fabricated skill-name pointer."
  - "`execute-tests` results-template `(no status:)` divergence escalated to a STRUCTURAL bullet of its own rather than buried in frontmatter notes — it is the single concrete artefact that breaks the canonical lifecycle scheme."
  - "Sandbox-allowlist Coda gap (CRIT-5 PITFALL) attached to `execute-tests` 1.7 since safety-rules.md is its canonical artefact; not duplicated under `generate-test-plan` 1.5 to avoid double-counting."
  - "Three [BLOCKING] flags cite the SKILL line that names the platform-skill orphan (38-39 / 47 / 55) — not the README references — because the BLOCKING quality is about runtime contract loading, not documentation drift."
metrics:
  duration: "~25 min"
  completed: "2026-05-09"
  tasks_total: 2
  tasks_completed: 2
  files_modified: 1
  commits: 2
  net_lines_added: 167
---

# Phase 01 Plan 02: AUDIT-01 Per-Skill Inventory Summary

Populates `## AUDIT-01: Per-Skill Inventory` in `.planning/AUDIT.md` with a 7-row pipe-matrix (one per v0.3.0 skill) plus 7 H3 prose subsections, each carrying Hand-off contract / Observed brittleness / What's missing for v2 — citation-dense, severity-tagged, observation-led, with every gap routed via `**Closes via:** DESIGN-NN` to a Phase 2 design requirement.

## What changed

| Wave | Task | File(s) | Commit |
|---|---|---|---|
| 2 | Task 1 — AUDIT-01 framing paragraph + 7-row skill matrix | `.planning/AUDIT.md` | `96f4e81` |
| 2 | Task 2 — 7 per-skill prose subsections (1.1 .. 1.7) | `.planning/AUDIT.md` | `7021321` |

## AUDIT-01 contents (after this plan)

- 1 framing paragraph — names the section's role + observation-led posture (D-13).
- 1 pipe-matrix, 7 columns × 7 data rows (Skill | Purpose | Inputs | Outputs | Downstream consumer | Deps | Status flag(s)).
- 7 H3 subsections — `### 1.1 discovery-intake` through `### 1.7 execute-tests`, each with the three required mini-headers.

## Severity-tag totals (within `## AUDIT-01:` ... `## AUDIT-02:` block)

| Tag | Count | Notes |
|---|---|---|
| `**[BLOCKING]**` | 3 | The three skills with `platform:` dispatch contracts (`generate-technical-spec` SKILL.md:38-39; `generate-build-prompt` SKILL.md:47; `execute-tests` SKILL.md:55) referencing the missing `platform-pipefy` / `platform-wrike` skills. |
| `**[STRUCTURAL]**` | 27 | Distributed across all 7 skills — start-at-any-point block (×6), Stage-N self-labels (×4), frontmatter inconsistencies (×6), duplicated hard-rules inlines (×2), missing `hub.md` / `.env.example` (×2), Cowork-vs-Claude-Code positioning duplicate, sibling-prompt orphan, deviations-file orphan, runner-version hardcode, results-template no-status, unscoped "v1" reference, sandbox-allowlist Coda gap, Stage-6 collision. |
| `**[COSMETIC]**` | 0 | All cosmetic findings live under AUDIT-07 per D-16; AUDIT-01 carries only structural and blocking tags. |
| `**[NEW]**` | 0 | Every brittleness finding here is sourced from CONCERNS.md or RESEARCH.md §3; no net-new findings beyond the existing concerns inventory in this wave. |

## Citation density

- 27 compact-form `` `dydx-delivery/skills/...:NN` `` and `:NN-MM` citations across the 7 subsections (D-14 compact form, ASCII-hyphen ranges).
- Plus citations to `dydx-delivery/.claude-plugin/plugin.json`, `dydx-delivery/README.md`, `dydx-delivery/skills/execute-tests/references/safety-rules.md` and `results-template.md` — 30 total `dydx-delivery/...` citations.

## DESIGN-* requirement coverage

15 distinct DESIGN-* IDs cross-referenced via `**Closes via:**` trailers (one trailer per skill plus DESIGN-04 attached to 1.7):

`DESIGN-01` (frontmatter scheme) · `DESIGN-02` (canonical stage numbering) · `DESIGN-03` (single SoT for hard rules) · `DESIGN-04` (refine pattern resolution) · `DESIGN-12` (skill inventory orphan-reference resolution) · `DESIGN-14` / `DESIGN-15` / `DESIGN-16` (3 internalised platform skills) · `DESIGN-17` (Stage 1 Kickoff) · `DESIGN-18` (Stage 2 Discovery refactor) · `DESIGN-19` (Stage 3 SOW refactor) · `DESIGN-20` (Stage 4 fnspec split) · `DESIGN-21` (Stage 5 tech-spec scope gate) · `DESIGN-23` (Stage 7 dual build prompts) · `DESIGN-24` (Stage 8 test bot architecture).

PITFALL refs cited: `CRIT-5` (sandbox-allowlist Coda gap, twice — under 1.5 and 1.7); `CRIT-6` (frontmatter migration corruption, three times — under 1.1, 1.2, 1.4, 1.7); `MOD-7` (tier-claim currency, once — under 1.4).

## D-13 enforcement (banned-phrase ERE)

The canonical D-13 banned-phrase ERE `'we should|the design will|recommend that v2|propose|v2 will'` (case-insensitive) returns **0** matches inside the AUDIT-01 block. Every "What's missing for v2" subsection states the gap as a present-tense observation and routes via `**Closes via:** DESIGN-NN` rather than prescribing a v2 design move.

## Verification

| Check | Result |
|---|---|
| `awk '/^## AUDIT-01:/,/^---$/' .planning/AUDIT.md \| grep -c '^\|'` ≥ 9 | 9 (header + separator + 7 data rows) |
| All 7 skill names in matrix | All present |
| `grep -cE '^### 1\.[1-7] ' .planning/AUDIT.md` = 7 | 7 |
| Each subsection has 3 mini-headers | 7 / 7 / 7 |
| `[BLOCKING]` ≥ 3 | 3 |
| `[STRUCTURAL]` ≥ 20 | 27 |
| `Closes via: DESIGN-` ≥ 7 | 8 (1.7 carries an extra DESIGN-04 closure for the refine-orphan note) |
| Compact citations ≥ 15 | 27 |
| Banned-phrase ERE = 0 | 0 |
| 8 AUDIT-0N H2 anchors preserved | 8 |
| Structural-check script behaviour | Still exits 1 on the missing v2.1-phrase assertion (Wave 7 hasn't landed). 8-section count assertion passes. |

## Deviations from Plan

None. Plan executed exactly as written. Per-skill source data transcribed verbatim from RESEARCH.md §3 with no re-discovery from SKILL.md files; all `file:line` citations match RESEARCH.md.

No deletions made. No skill files (`dydx-delivery/skills/*`) modified — design-only constraint preserved.

## Pointer

Plan 03 (Wave 3) populates `## AUDIT-03: Per-Stage Connector Dependencies` next — same `.planning/AUDIT.md` file, the next H2 anchor down. This plan's Wave 2 work has no incoming write conflicts with Wave 3 because Plan 03 edits a different H2 section (AUDIT-03) under the same skeleton.

## Self-Check: PASSED

- File `.planning/AUDIT.md` exists. Both task commits (`96f4e81` matrix; `7021321` subsections) present in `git log --oneline`.
- All acceptance gates from `.planning/phases/01-audit/01-02-PLAN.md` pass (matrix shape; 7 subsections; severity-tag counts; Closes-via trailer count; compact citation count; banned-phrase ERE = 0; 8-section anchor count preserved).
