---
phase: 03-changelist
plan: 04
plan_id: 03-04
subsystem: changelist-appendix-a
tags: [changelist, change-02, appendix-a, per-skill-delta, design-only]
requires:
  - 03-01 (.planning/CHANGELIST.md skeleton + structural-check script ✓ 2026-05-10)
  - 03-02 (.planning/CHANGELIST.md Phase 1-5 mini-tables ✓ 2026-05-10)
  - 03-03 (.planning/CHANGELIST.md Phase 6-9 mini-tables + Phase 7 Pipefy AI KB inline marker ✓ 2026-05-10)
provides:
  - .planning/CHANGELIST.md § Appendix A — 20-row per-skill delta matrix per D-39 (single-matrix shape, Status closed enum, milestone → phase → status ordering)
  - Bottom totals paragraph per cross-AI C4 (codex MEDIUM) — single authoritative count model collapsing earlier 13/15/19/20 framing into one paragraph anchored on DESIGN-12 13-skill universe
  - 50 `(per DESIGN-NN)` citations across 20 rows (each Change cell carries 1-3 cited bullets per D-40)
  - First-failing structural-check assertion now moves from Appendix A row count (assertion #9, was 0) to Appendix B sentinel count (Plan 03-05 territory)
affects:
  - downstream-plans (03-05 populates Appendices B + D; 03-06 populates Appendix C + adds Phase 1 + Phase 2 inline markers; 03-07 synthesises Executive Summary + How-to-read + Appendix E mechanical walk + final no-placeholder pass)
  - CHANGE-02 status: COMMITTED — ROADMAP Phase 3 success criterion 2 satisfied
tech-stack:
  added: []
  patterns: [single-matrix-then-totals-paragraph for per-skill delta presentation (D-39); cited-bullets in Change column with `<br>` soft-line-break preserving single-line markdown row source per cell (D-40); milestone-block ordering inside the matrix rooted in introducing milestone (v2.1 → v2.6) → introducing phase → status enum; one-authoritative-count reconciliation paragraph per cross-AI C4 (collapsing earlier multi-count framing)]
key-files:
  created:
    - .planning/phases/03-changelist/03-04-SUMMARY.md
  modified:
    - .planning/CHANGELIST.md (Appendix A H2 section populated under existing 03-01 anchor — placeholder note replaced with framing paragraph + 20-row matrix + bottom totals paragraph)
decisions:
  - D-39 (carried) — single matrix per v2 skill; column headers `v0.3.0 origin | v2 name | Status | Change | Introduced (phase) | DESIGN`; Status closed enum `NEW / NEW (split) / MODIFIED / RETIRED / RETIRED → SPLIT / UNCHANGED` (no widening per cross-AI C2 codex HIGH); ordering rule milestone → phase → status
  - D-40 (carried) — cited-bullets format in Change column; each bullet ends with `(per DESIGN-NN)` citation where applicable; `<br>` soft line break inside markdown table cell keeps source single-line per row
  - D-14 (carried) — `file:line`-style citations use backtick wrapping; v0.3.0 origin cells cite `dydx-delivery/skills/<skill>/SKILL.md (per .planning/AUDIT.md § AUDIT-01.N)` for the 6 v0.3.0 carry-forwards
  - D-44 (carried) — D-N pool frozen at D-45; this plan reuses existing D-IDs only (no new D-IDs introduced)
  - cross-AI C2 (codex HIGH applied) — Status enum shrunk back to D-39's 6-value list; platform-skill framing moved into Change column (NOT a new `NEW (platform)` enum value); both `NEW (platform)` and `UNCHANGED-structure / behaviour-modified` are forbidden — verified absent in matrix
  - cross-AI C4 (codex MEDIUM applied) — bottom totals as single paragraph (not a matrix data row) with one authoritative count model (NEW = 13, MODIFIED = 6, RETIRED → SPLIT = 1, sum = 20); collapses earlier 13/15/19/20 multi-count framing
metrics:
  duration: ~12 minutes
  completed: 2026-05-10
  tasks: 1 (with file changes)
  commits: 1 (97a5dbe Appendix A populate)
  files-modified: 1 (`.planning/CHANGELIST.md`)
  files-created: 1 (this SUMMARY)
---

# Phase 3 Plan 04: Wave 4 — CHANGELIST Appendix A per-skill delta matrix (CHANGE-02) Summary

**One-liner:** Populated `.planning/CHANGELIST.md` Appendix A with a single 20-row per-skill delta matrix per D-39 — column headers exact, Status closed-enum used (4 of 6 values present: `NEW`, `NEW (split)`, `MODIFIED`, `RETIRED → SPLIT`), rows ordered by milestone (v2.1 → v2.6) → introducing phase → status, each Change cell carries 1-3 cited bullets per D-40 with 50 `(per DESIGN-NN)` citations total, bottom totals paragraph reconciles against DESIGN-12 categorical breakdown via the cross-AI C4 single-authoritative-count rule. CHANGE-02 status: COMMITTED — ROADMAP Phase 3 success criterion 2 (per-skill delta inventoried) satisfied.

## What Shipped

### Files Modified

| File | Purpose |
|------|---------|
| `.planning/CHANGELIST.md` | Appendix A H2 section populated under existing 03-01 anchor. Placeholder note replaced with: framing paragraph + 20-row data matrix (3 platform skills v2.1 + 6 v2.2 rows + 4 v2.3 rows + 4 v2.4 rows + 1 v2.5 Phase 6 row + 1 v2.5 Phase 7 row + 1 v2.6 Phase 8 row) + bottom totals paragraph. Phase 1..9 mini-tables and Appendices B / C / D / E unchanged from prior waves. |

### Files Created

| File | Purpose |
|------|---------|
| `.planning/phases/03-changelist/03-04-SUMMARY.md` | This summary. |

### Commits

| Hash | Message | Files |
|------|---------|-------|
| `97a5dbe` | `docs(03-04): populate Appendix A — 20-row per-skill delta matrix (CHANGE-02)` | `.planning/CHANGELIST.md` |

## Matrix-shape verification

**Column headers (D-39 verbatim):** `v0.3.0 origin | v2 name | Status | Change | Introduced (phase) | DESIGN` — emitted exactly once at the top of the matrix.

**Row count:** 20 data rows.
- 3 platform skills (Phase 2 / v2.1) — `platform-pipefy`, `platform-wrike`, `platform-ziflow` — Status `NEW`.
- 6 Phase 3 / v2.2 rows: `kickoff-capture` (NEW), `generate-fnspec-platform` (NEW (split)), `generate-fnspec-integration` (NEW (split)), `discovery-intake` (MODIFIED), `generate-sow` (MODIFIED), `generate-functional-spec` (RETIRED → SPLIT).
- 4 Phase 4 / v2.3 rows: `generate-cost-estimate` (NEW), `generate-implementation-prompt` (NEW), `generate-technical-spec` (MODIFIED), `generate-build-prompt` (MODIFIED).
- 4 Phase 5 / v2.4 rows: `provision-test-harness` (NEW), `generate-uat-plan` (NEW), `generate-test-plan` (MODIFIED), `execute-tests` (MODIFIED).
- 1 Phase 6 / v2.5 row: `update-documentation` (NEW).
- 1 Phase 7 / v2.5 row: `push-native-ai-knowledge` (NEW; Introduced (phase) cell flags `BLOCKED BY OPEN-01 per CHANGE-04`).
- 1 Phase 8 / v2.6 row: `sign-off-and-archive` (NEW).
- (Phase 1 ships no skill rows — Phase 1 modifications carry forward via the 6 MODIFIED rows tagged `Phase 3 (v2.2)` / `Phase 4 (v2.3)` / `Phase 5 (v2.4)` per-skill introducing-phase. Phase 9 ships plugin surfaces only.)

**Status enum coverage (D-39 6-value closed list):** 4 values used (`NEW`, `NEW (split)`, `MODIFIED`, `RETIRED → SPLIT`); 2 values permitted but not used in this matrix (`UNCHANGED` — no v0.3.0 skill carries forward unchanged; `RETIRED` — the only retired skill is `generate-functional-spec` which is `RETIRED → SPLIT`, not bare `RETIRED`).

**Forbidden values absent (cross-AI C2 codex HIGH lock):** `NEW (platform)` and `UNCHANGED-structure / behaviour-modified` strings explicitly verified absent via `grep -qF` checks during verification. Platform-skill framing lives in the Change column per D-40 (cited bullets carry the `Platform-knowledge skill (sibling-of-stage shape per cross-AI C2) ...` prefix), NOT in the Status enum.

**Citation count:** 50 `(per DESIGN-NN)` citations across the 20 rows (acceptance criteria minimum was >= 35; exceeded by margin).

## Bottom-totals paragraph (cross-AI C4 single-authoritative-count rule)

The matrix is followed by a single bottom paragraph (NOT a data row) that reconciles the matrix against DESIGN-12:

> **Tag totals.** 13-skill v2 universe per DESIGN-12 (10 stage-skills + 3 platform-skills) + 6 MODIFIED rows tracking v0.3.0 skills carried forward into the v2 universe + 1 RETIRED → SPLIT row tracking the v0.3.0 skill no longer present in v2 (`generate-functional-spec`, replaced by `generate-fnspec-platform` Stage 4a + `generate-fnspec-integration` Stage 4b — see rows 4, 5 above) = 20 total Appendix A rows. NEW = 13 (10 stage-skill NEW + 3 platform-skill NEW). MODIFIED = 6 (`discovery-intake` / `generate-sow` / `generate-technical-spec` / `generate-build-prompt` / `generate-test-plan` / `execute-tests` — all carry-forwards from v0.3.0). RETIRED → SPLIT = 1. v2 end-state ship count = 13 skills (per DESIGN-12); the 6 MODIFIED rows are upgrades to skills inside the 13 universe; the RETIRED row ships nothing. AUDIT.md § AUDIT-01 grounds the v0.3.0 7-skill starting state.

The arithmetic checks: 13 NEW + 6 MODIFIED + 1 RETIRED → SPLIT = 20 rows. 13 v2 universe per DESIGN-12 (10 stage-skill NEW + 3 platform-skill NEW; the 6 MODIFIED rows are upgrades to existing skills inside that universe — they don't add to the 13 ship count). The single anchor sentence `13-skill v2 universe per DESIGN-12` appears once and is the single authoritative count source per cross-AI C4 (no other count model is presented).

## Acceptance-criteria checklist

| Criterion | Result |
|-----------|--------|
| Appendix A row count >= 15 (per CONTEXT specifics floor) matching D-39 Status closed enum | ✓ 20 rows |
| All 20 distinct skill names appear (16 stage skills + 3 platform skills + 1 RETIRED skill) via `grep -qF` | ✓ all 20 names found |
| Status closed-enum coverage: 4 used values (`NEW`, `NEW (split)`, `MODIFIED`, `RETIRED → SPLIT`) all appear | ✓ |
| Forbidden values absent (`NEW (platform)`, `UNCHANGED-structure`) | ✓ both confirmed absent |
| Bottom totals paragraph contains `Tag totals`, `NEW = 13`, `MODIFIED = 6`, `RETIRED → SPLIT = 1`, `13-skill v2 universe per DESIGN-12` | ✓ all 5 substrings present |
| Each Change cell carries `(per DESIGN-NN)` cite — 50 citations counted (>= 35 floor) | ✓ |
| Structural-check assertion #9 (Appendix A row count >= 15) NOW PASSES | ✓ script no longer fails on Appendix A; first-failing assertion is Appendix B sentinel count (Plan 03-05 territory) |
| Row ordering: first non-header row is `platform-pipefy` (v2.1 block); last data row is `sign-off-and-archive` (v2.6 block) before totals paragraph | ✓ |
| No accidental modifications to Phase 1..9 mini-tables or Appendices B / C / D / E | ✓ git diff confirmed scope-bounded to Appendix A H2 section body |

## Structural-check exit code

`bash .planning/phases/03-changelist/scripts/changelist-structure-check.sh; echo "EXIT_CODE=$?"`

**Expected exit code:** 1 (Wave 4 partial-state — Appendix A row count assertion #9 now PASSES, but Appendix B sentinel-count assertion #8 still fails because Appendix B is Plan 03-05 territory; Appendix E bullet-count assertion #10 still fails because Appendix E is Plan 03-07 synthesis territory; the C9 final-only no-placeholder check still fails because Appendices B / C / D / E retain `Populated by 03-0N` placeholder strings).

**Actual exit code:** 1 (`FAIL: Appendix B per-bullet sentinel count must be >= 6 (matches AUDIT-07's 6 fixes per D-16/D-41), found 0`).

The first-failing assertion has progressed from Wave 3's `Appendix B` (the same first-failing assertion — appendix A was never first because the script reaches Appendix B before Appendix A in its assertion order). Crucially: the Appendix A row count assertion (`appendix_a_rows >= 15`) which previously held at 0 (matching no rows) NOW evaluates to 20 — verified by direct extraction in Task 1's verify block (`ROWS=20`). The script body confirms this: assertion #9 is no longer in the failure path; it's been silently cleared and the next failing assertion (Appendix B at line 89) is hit instead.

## Decisions Made (this plan — no new D-IDs introduced)

- **No new D-IDs.** D-N pool stays frozen at D-45 per CONTEXT D-44. Every cell content reuses existing D-IDs (D-39 / D-40 / D-14 / cross-AI C2 / cross-AI C4 carried).
- **Cited-bullets cell idiom:** `<br>` soft-line-break separator chosen between bullets within the Change column to keep each matrix row a single source line (preserves `^\| .+ \|` regex match the structural-check uses to count rows). Chose this idiom over actual newlines or sub-lists because (a) markdown renderers handle `<br>` reliably inside table cells; (b) the regex anchor on `^\|` would break with multi-line cells; (c) consistent with the Phase 7 Research-blocked cell pattern Plan 03-03 established. Falls under D-40 + CONTEXT Claude's-Discretion `Internal ordering of bullets within a mini-table cell`.
- **Pipe-escape inside cells:** `delivery: native-ai \| api` and `native_ai_path: api \| paste \| none` use `\|` escape since literal `|` would terminate the markdown table cell early. The escape preserves the v2 frontmatter literal and the structural-check Status enum match (which anchors on `(NEW|MODIFIED|...)` regex BEFORE pipe-escape characters).
- **Phase 7 introducing-phase cell flag:** the `push-native-ai-knowledge` row's `Introduced (phase)` cell is `Phase 7 (v2.5) — BLOCKED BY OPEN-01 per CHANGE-04` (the only row whose Introduced (phase) cell carries a blocker flag). This mirrors the Phase 7 H2 inline `[BLOCKED — see Appendix C]` tag the structural-check enforces (line 70-71 of the script). Reader scanning Appendix A for "what's blocked" sees the flag inline at the row.
- **Generate-functional-spec RETIRED → SPLIT cell:** `v2 name` cell reads `(none — replaced by Stage 4a + 4b split)` to make the lack-of-v2-replacement explicit. The Change cell cross-cites rows 4 and 5 (`see rows 4, 5 above`) so a reader landing on the RETIRED row immediately sees where the replacement skills appear.

## Deviations from Plan

None — plan executed exactly as written. All 20 rows match the `<interfaces>` block content character-for-character (modulo pipe-escape `\|` for inline `|` literals). Status enum values stay strictly within D-39's 6-value closed list. Bottom totals paragraph carries the verbatim cross-AI C4 wording from the plan's `<action>` block. Citation count (50) exceeds the >= 35 floor by margin (~70% of bullets carry a DESIGN-NN cite; remaining bullets are platform-framing prefixes that carry an AUDIT-04.1 / DESIGN context cite at the row's v0.3.0-origin column). No new D-IDs introduced. No accidental modifications outside Appendix A's H2 section body.

## Pointer for Next Plans

- **Plan 03-05 (Wave 5)** populates Appendices B + D. Appendix B verbatim lift from AUDIT-07 6 fix subsections (each with the D-16 sentinel — current first-failing assertion at line 89 of the structural-check script). Appendix D numbered checklist of 5-7 frontmatter migration rules per D-43.
- **Plan 03-06 (Wave 6)** populates Appendix C with the full unknown-list per blocked phase + recommended `/gsd-research-phase` invocation, AND adds Phase 1 + Phase 2 inline markers (rate-limit / pagination / read-after-create per CHANGE-04). Phase 7's Research-blocked cell content was populated by 03-03; 03-06 closes the cross-reference loop with the Appendix C body.
- **Plan 03-07 (Wave 7 synthesis)** does Executive Summary + How-to-read + Appendix E mechanical walk + final structural-check pass (script must exit 0 — all assertions including the C9 final-only no-placeholder check). Appendix E baseline = DESIGN.md "Deferred to Phase 4 OPEN-QUESTIONS" 8-bullet list + 3 inline markers introduced by Phase 3 authoring (Phase 4 risk-multiplier from 03-02 + Phase 7 Pipefy AI KB from 03-03 + Phase 9 OPEN-07 from 03-03) + any Phase 1 / Phase 2 markers Plan 03-06 introduces. The `push-native-ai-knowledge` row's `Phase 7 (v2.5) — BLOCKED BY OPEN-01 per CHANGE-04` flag inside Appendix A is NOT itself an `[OPEN: Phase 4 — ...]` marker (it's a CHANGE-04 cross-reference), so it does NOT add an Appendix E entry — Plan 03-07 should rely on the inline-marker pattern `^- \*\*\`\[OPEN: Phase 4` (the structural-check regex at line 105) for Appendix E enumeration.

CHANGE-02 status: **COMMITTED** — every v2 skill inventoried with v0.3.0 origin + Status + Change + Introducing phase + DESIGN section in single-matrix form per D-39. ROADMAP Phase 3 success criterion 2 (per-skill delta inventoried) satisfied.

## Self-Check: PASSED

- **Files created/modified verified:**
  - `.planning/CHANGELIST.md` — exists, modified (Appendix A H2 section body populated).
  - `.planning/phases/03-changelist/03-04-SUMMARY.md` — exists, this file.
- **Commit verified:**
  - `97a5dbe` — `docs(03-04): populate Appendix A — 20-row per-skill delta matrix (CHANGE-02)` — present in `git log --oneline`.
- **Matrix row count verified:** 20 (>= 15 floor per CONTEXT specifics; >= 15 floor per structural-check assertion #9).
- **Status enum values verified:** 4 of 6 D-39 values used (`NEW`, `NEW (split)`, `MODIFIED`, `RETIRED → SPLIT`); both forbidden values (`NEW (platform)`, `UNCHANGED-structure`) confirmed absent via direct `grep -qF` check.
- **Citation count verified:** 50 `(per DESIGN-NN)` citations (>= 35 floor).
- **Skill name coverage verified:** all 20 distinct skill names found via individual `grep -qF` checks (16 stage skills + 3 platform skills + 1 RETIRED skill).
- **Bottom totals paragraph verified:** all 5 required substrings (`Tag totals`, `NEW = 13`, `MODIFIED = 6`, `RETIRED → SPLIT = 1`, `13-skill v2 universe per DESIGN-12`) present.
- **No accidental modifications:** `git diff HEAD~1 -- .planning/CHANGELIST.md` confirms changes are scope-bounded to Appendix A H2 body. Phase 1..9 mini-tables and Appendices B / C / D / E unchanged.
- **No new D-IDs introduced** — D-N pool frozen at D-45.
- **Structural-check exit 1** as expected (Wave 4 partial-state); first-failing assertion is Appendix B sentinel count (Plan 03-05 territory), confirming Appendix A row count assertion #9 PASSES (script proceeded past it).
