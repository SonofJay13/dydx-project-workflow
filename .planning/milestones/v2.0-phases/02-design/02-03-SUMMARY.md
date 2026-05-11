---
phase: 02-design
plan: 03
subsystem: skill-layout-and-handoff-matrix
tags: [design, skill-inventory, hand-off-matrix, layout, wave-3]
requires: [cross-cutting-decisions-locked, design-md-skeleton, design-structure-check]
provides: [skill-layout-design-11, v2-skill-inventory-design-12, handoff-matrix-design-13, h2-anchor-renamed]
affects: [.planning/DESIGN.md, .planning/phases/02-design/scripts/design-structure-check.sh]
tech_stack:
  added: []
  patterns:
    - matrix-then-prose for skill inventory + hand-off contract (D-19, D-26)
    - per-DESIGN H2 with > **DESIGN-NN:** echo blockquote (D-35)
    - file:line + AUDIT.md §X.Y citation discipline (D-32 / D-34)
    - stateful awk section_between extraction for inventory + hand-off row counts (cross-AI HIGH #1)
    - neutral H2 anchor (no count) for resilience to count drift (cross-AI MEDIUM #4)
    - single-line hand-off message cells (carrier path + status flag grep-canonical) per D-26
key_files:
  created:
    - .planning/phases/02-design/02-03-SUMMARY.md
  modified:
    - .planning/DESIGN.md
    - .planning/phases/02-design/scripts/design-structure-check.sh
decisions:
  - "Phase 2 Plan 03: H2 anchor renamed `## 13-skill inventory` -> `## v2 skill inventory` (cross-AI review MEDIUM #4) — neutral title without count is resilient to v2.x count drift; structural-check script's required_h2 array updated in same commit so the rename is atomic"
  - "Phase 2 Plan 03: Inventory matrix shows 19 v2 end-state skills (16 stage skills + 3 platform skills) — exceeds the >= 13 floor; reconciliation paragraph cites architecture research as source of truth and explains discrepancy against REQUIREMENTS DESIGN-12 sub-bullet's '6 NEW + 3 NEW platform + 4 MODIFIED + 2 UNCHANGED + 1 RETIRED' framing (Phase 1 D-32 / D-34 honesty precedent — research enumeration kept; discrepancy logged not padded/trimmed)"
  - "Phase 2 Plan 03: Skill layout ASCII tree enumerates 7 v2 surfaces (.claude-plugin/, references/, skills/, commands/, agents/, hooks/, tests/) with per-leaf cite of locking decision (DESIGN-NN, AUDIT-NN, FOUND-NN); plugin-level `references/` directory grounded in FOUND-01 (safety-rules.md, stage-numbering.md, frontmatter-scheme.md, glossary.md)"
  - "Phase 2 Plan 03: RETIRED `generate-functional-spec` excluded from end-state matrix; migration mapping note at section bottom captures the retired skill -> Stage 4a + 4b mapping per DESIGN-20; v0.3.0 artefacts remain readable per DESIGN-08 lenient mode with CR-driven opt-in upgrade"
  - "Phase 2 Plan 03: Hand-off matrix has 12 transition rows (Stage 1->2 through 10->11); exceeds >= 10 floor; each cell uses single-line format (no embedded newlines) so cells are reusable verbatim by Plans 02-05..02-08"
  - "Phase 2 Plan 03: CRIT-8 fix encoded in Stage 9->10 row hand-off message (`push-native-ai-knowledge refuses ingest if doc_published_at < last_diff_review_at`) — grep-canonical contract reference for the Stage 10 build phase"
  - "Phase 2 Plan 03: Status-flag values in matrix use DESIGN-01 canonical lifecycle (`status: approved` literal); gates that allow `client_review` (Stage 3->4a row) call it out explicitly so Stage 3 SKILL.md author knows the carrier file is reachable in pre-approval state"
  - "Phase 2 Plan 03: Echo line count progresses 10 -> 13 (DESIGN-11, DESIGN-12, DESIGN-13 added); structural-check assertion #9 (hand-off matrix >= 10 rows via stateful section_between) PASSES; assertion #4 (echo count >= 30) is the only failing one — Plans 02-04..02-09 close the remaining 17 echoes"
metrics:
  duration: ~10 min
  completed_date: 2026-05-09
---

# Phase 2 Plan 03: Skill layout DESIGN-11 + v2 skill inventory DESIGN-12 + Stage-by-stage hand-off contract DESIGN-13 Summary

Wave 3 — populated `.planning/DESIGN.md` `## Skill layout`, `## v2 skill inventory`, and `## Stage-by-stage hand-off contract` sections. Renamed the inventory H2 anchor from `## 13-skill inventory` -> `## v2 skill inventory` (cross-AI review MEDIUM #4) and updated the structural-check script's `required_h2` array to match. Echo line count progressed 10 -> 13. Hand-off matrix structural-check assertion #9 now passes.

## What Was Built

**One-liner:** v2 plugin folder layout locked under DESIGN-11 ASCII tree (7 surfaces); 19-row skill inventory matrix grounds Plans 02-04..02-09 with grep-canonical "Detailed contract section" anchors; 12-row stage hand-off matrix is the single most-cited DESIGN.md section with carrier paths + frontmatter fields + gating status flags + hand-off messages all grep-canonical for v2.1+ build phases.

### `.planning/DESIGN.md` — populated regions

**`## Skill layout` H2 — populated** (was: stub placeholder):

- `> **DESIGN-11:** ...` echo blockquote (D-35).
- One-paragraph framing citing the v0.3.0 base shape (per AUDIT.md §AUDIT-01 + §AUDIT-08), the v2 surface additions (per DESIGN-04), and the plugin-level `references/` directory (per FOUND-01, DESIGN-02, DESIGN-03).
- Code-fenced ASCII tree (` ```text `) showing the full v2 plugin folder layout. 7 top-level surfaces enumerated: `.claude-plugin/`, `references/`, `skills/`, `commands/`, `agents/`, `hooks/`, `tests/`. Each leaf comment cites the locking decision (DESIGN-NN, AUDIT-NN, FOUND-NN). Skills folder enumerates all 19 v2 skill folders (16 stage + 3 platform) with per-skill stage anchor + change-tag (NEW / MODIFIED / UNCHANGED-structure).
- Trailing **RETIRED** line names `skills/generate-functional-spec/` -> Stage 4 split (`generate-fnspec-platform/` + `generate-fnspec-integration/`) per DESIGN-20.

**`## v2 skill inventory` H2 — renamed + populated** (was: `## 13-skill inventory` stub placeholder):

- H2 anchor renamed `## 13-skill inventory` -> `## v2 skill inventory` (cross-AI review MEDIUM #4). Neutral title with no number — resilient to v2.x count drift.
- `> **DESIGN-12:** ...` echo blockquote (D-35).
- **Reconciliation paragraph** (per cross-AI review MEDIUM #4): explicitly states that REQUIREMENTS.md DESIGN-12 sub-bullet describes 5 categories totalling 16 categorical items (6 NEW + 3 NEW platform + 4 MODIFIED + 2 UNCHANGED + 1 RETIRED-AND-REPLACED); reconciles legacy "13 skills total" framing with the actual end-state count of skill folders that ship: 15 (16 - 1 RETIRED). Cites architecture research (`.planning/research/SUMMARY.md` + `.planning/research/ARCHITECTURE.md`) as source of truth + AUDIT.md §AUDIT-01 for v0.3.0 starting state. Explicitly invokes Phase 1 D-32 / D-34 honesty precedent.
- **Inventory matrix** — 19 rows (16 stage skills covering Stages 1..11 inc. substages 4a/4b/7a/7b/8a/b/c/d + 3 platform skills). Columns: `# | Skill name | Tag | Stage | Inputs | Outputs | Downstream consumer | Complexity | Dependencies | Detailed contract section`. Tag distribution: 10 NEW (stage), 5 MODIFIED, 1 UNCHANGED-structure, 3 NEW (platform). Each row's "Detailed contract section" column references the H2 anchor where Plans 02-04..02-09 land per-skill prose.
- **Tag-breakdown reconciliation**: matrix-derived totals (10 NEW + 5 MODIFIED + 1 UNCHANGED + 3 NEW-platform + 1 RETIRED) reconciled against REQUIREMENTS sub-bullet ("6 NEW + 3 NEW platform + 4 MODIFIED + 2 UNCHANGED + 1 RETIRED"). Discrepancy explained: Stage 4 split + Stage 7 dual + Stage 8 four-substage + Stage 11 NEW push the NEW count above 6.
- **Per-skill prose subsections** disclaimer: full SKILL.md prose NOT drafted in this milestone per D-20; landing in v2.1+ build phases.
- **Migration mapping note** for the RETIRED skill: `generate-functional-spec/` -> Stage 4a + 4b; v0.3.0 artefacts readable via DESIGN-08 lenient mode; CR-driven opt-in upgrade.

**`## Stage-by-stage hand-off contract` H2 — populated** (was: stub + empty matrix header):

- `> **DESIGN-13:** ...` echo blockquote (D-35).
- Framing paragraph naming D-26 (single transition matrix); calls out that this is the most-cited section per CONTEXT specifics; commits carrier paths to DESIGN-02 stage-prefixed convention and gating status flags to DESIGN-01 canonical lifecycle vocabulary.
- **Transition matrix** — 12 data rows (>= 10 floor cleared). Columns: `From | To | Carrier file path | Frontmatter fields propagated | Gating status flag | Hand-off message`. Transitions: 1->2, 2->3, 3->4a, 4a->4b, 4b->5, 5->6, 6->7a, 7a/7b->8a, 8a/b/c->8d, 8d->9, 9->10, 10->11. Each `Hand-off message` cell is single-line (no embedded newlines) so cells are reusable verbatim by Plans 02-05..02-08 per-stage subsections per D-26.
- **Stage 9->10 row** encodes the CRIT-8 fix verbatim: `push-native-ai-knowledge refuses ingest if doc_published_at < last_diff_review_at`.

### `.planning/phases/02-design/scripts/design-structure-check.sh` — required_h2 array updated

- Single-line edit: `"## 13-skill inventory"` -> `"## v2 skill inventory"`. Atomic with the DESIGN.md rename so structural-check stays green on the new anchor.
- `bash -n` exits 0 (script syntax still valid).

## Tasks Executed

| Task | Name | Commit | Files |
|------|------|--------|-------|
| 1 | Rename `## 13-skill inventory` -> `## v2 skill inventory` (cross-AI MEDIUM #4) + write `## Skill layout` body (DESIGN-11) + `## v2 skill inventory` matrix-then-prose (DESIGN-12) | 59252e6 | `.planning/DESIGN.md`, `.planning/phases/02-design/scripts/design-structure-check.sh` |
| 2 | Populate `## Stage-by-stage hand-off contract` matrix with 12 transition rows (DESIGN-13 / D-26) + run structural-check (assertion #9 now PASSES via stateful helper) | 1d67dd1 | `.planning/DESIGN.md` |

## Cross-AI Review Fixes Applied

| ID | Type | Fix |
|----|------|-----|
| HIGH #1 | Tampering / verification correctness | Inventory + hand-off row counts use stateful awk `section_between` extraction (`awk -v hdr 'f && /^## /{exit} f{print} index($0,hdr)==1 && /^## /{f=1}' file`) — same pattern as the structural-check script's hand-off assertion. Naive `awk '/^## X/,/^## /'` ranges would only capture the header line because the start H2 also matches the end H2 regex on the same line. |
| HIGH #2 | Process / traceability | `02-03-SUMMARY.md` listed in plan frontmatter `files_modified` (this file). |
| MEDIUM #4 | Documentation alignment / count framing | H2 anchor renamed `## 13-skill inventory` -> `## v2 skill inventory` pre-execution per the resolution rule documented in plan `<interfaces>` block. Reconciliation paragraph explicitly cites both the REQUIREMENTS DESIGN-12 categorical breakdown and the architecture research enumeration; explains the legacy "13 skills total" framing; commits the matrix to architecture research's enumeration without padding or trimming (Phase 1 D-32 / D-34 honesty precedent). Structural-check script's `required_h2` array updated to match new anchor in the same commit (atomic). |

## Deviations from Plan

None. Plan executed exactly as written. Both tasks landed on first verification pass; no Rule 1/2/3 fixes required during execution.

## Verification Snapshot

```
$ grep -qF '## v2 skill inventory' .planning/DESIGN.md && echo OK
OK
$ grep -qF '## 13-skill inventory' .planning/DESIGN.md && echo BAD || echo old_anchor_gone
old_anchor_gone
$ grep -qF '"## v2 skill inventory"' .planning/phases/02-design/scripts/design-structure-check.sh && echo OK
OK
$ bash -n .planning/phases/02-design/scripts/design-structure-check.sh && echo SYNTAX_OK
SYNTAX_OK
$ awk -v hdr='## v2 skill inventory' 'f && /^## /{exit} f{print} index($0,hdr)==1 && /^## /{f=1}' .planning/DESIGN.md | grep -cE '^\| [0-9]+ \|'
19
$ awk -v hdr='## Stage-by-stage hand-off contract' 'f && /^## /{exit} f{print} index($0,hdr)==1 && /^## /{f=1}' .planning/DESIGN.md | grep -cE '^\| Stage'
12
$ grep -cE '^> \*\*DESIGN-[0-9]{2}:\*\*' .planning/DESIGN.md
13
$ bash .planning/phases/02-design/scripts/design-structure-check.sh
FAIL: expected >= 30 'DESIGN-NN:' success-criteria echo blockquote lines (D-35), found 13
EXIT_CODE=1   # mid-phase state — Plans 02-04..02-09 close remaining 17 echoes
```

Hand-off matrix assertion #9 now PASSES (we get past it before assertion #4 fires); only assertion #4 (echo count) remains failing, exactly as the plan predicted.

## Pointer

**Next:** Plan 02-04 (Wave 4) populates Platform skills next (DESIGN-14, 15, 16) — the 3 platform skill subsections (`## platform-pipefy`, `## platform-wrike`, `## platform-ziflow`) each add 1 echo line. Running total after 02-04 = 16/30. The inventory matrix's "Detailed contract section" column (rows 17, 18, 19) anchors forward to Plan 02-04's per-platform prose.

## Self-Check: PASSED

Verified files exist:

- `.planning/DESIGN.md` — FOUND (populated `## Skill layout` body with DESIGN-11 echo + ASCII tree; renamed `## v2 skill inventory` body with DESIGN-12 echo + reconciliation + 19-row matrix + migration note; populated `## Stage-by-stage hand-off contract` body with DESIGN-13 echo + 12-row matrix).
- `.planning/phases/02-design/scripts/design-structure-check.sh` — MODIFIED (`required_h2` array entry renamed `## 13-skill inventory` -> `## v2 skill inventory`; `bash -n` exits 0).
- `.planning/phases/02-design/02-03-SUMMARY.md` — FOUND (this file).

Verified commits exist on `dydx-delivery-v2`:

- `59252e6` — FOUND (Task 1: H2 rename + Skill layout + v2 skill inventory).
- `1d67dd1` — FOUND (Task 2: Stage-by-stage hand-off contract matrix populated).

Structural-check script: exits 1 against the populated state (assertion #4 fails with `FAIL: expected >= 30 'DESIGN-NN:' ... found 13` — expected and correct mid-phase invariant; assertion #9 hand-off matrix passes via stateful section_between).
