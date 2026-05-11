---
phase: 03-changelist
plan: 02
plan_id: 03-02
subsystem: changelist-phase-mini-tables
tags: [changelist, change-01a, phase-mini-tables, design-only]
requires:
  - 03-01 (.planning/CHANGELIST.md skeleton + structural-check script ✓ 2026-05-10)
provides:
  - .planning/CHANGELIST.md § Phase 1 / Phase 2 / Phase 3 / Phase 4 / Phase 5 mini-tables (5 of 9 phases — covers v2.1 + v2.2 + v2.3 + v2.4 milestones; Phases 6..9 deferred to Plan 03-03)
  - 5 ordering-rationale paragraphs (each verbatim or paraphrased from `.planning/research/SUMMARY.md` § Phase Ordering Rationale + § Phase N — <name>)
  - Phase 1 inline `⚠` Research-blocked marker linking to Appendix C (D-42)
  - Phase 4 inline `[OPEN: Phase 4 — risk-multiplier defaults pending dYdX-historical validation per D-22]` marker (D-27 carried; verbatim from DESIGN.md Appendix E bullet 8)
affects:
  - downstream-plans (03-03 closes Phases 6..9 mini-tables; 03-04 populates Appendix A; 03-05 populates Appendices B + D; 03-06 populates Appendix C + adds inline markers on Phase 1 + Phase 7; 03-07 synthesises Executive Summary + How-to-read + Appendix E mechanical walk + final structural-check pass)
tech-stack:
  added: []
  patterns: [matrix-then-prose for phase mini-tables (D-38); inline-marker + closed-list for deferred items (D-27 carried); blockquote-prefixed ordering paragraphs for visual distinction from prose body]
key-files:
  created:
    - .planning/phases/03-changelist/03-02-SUMMARY.md
  modified:
    - .planning/CHANGELIST.md (5 H2 phase sections populated under existing 03-01 anchors — Phase 1 / 2 / 3 / 4 / 5)
decisions:
  - D-36 (carried) — H2 anchors used verbatim from 03-01 skeleton; populated bodies appended under existing anchors without re-emitting headings
  - D-37 (carried) — milestone tags `(v2.1)` / `(v2.2)` / `(v2.3)` / `(v2.4)` already inline on H2 anchors from 03-01; not duplicated
  - D-38 (carried) — 6-row Attribute/Detail mini-table per phase: Deliverables / Depends on / Addresses / Avoids pitfalls / Skills introduced/modified / Research-blocked
  - D-42 (carried) — Phase 1 Research-blocked cell carries inline `⚠` marker referencing Appendix C
  - D-27 (carried) — Phase 4 Research-blocked cell carries inline `[OPEN: Phase 4 — ...]` marker; verbatim text matches DESIGN.md Appendix E bullet 8 for Plan 03-07 reconciliation
  - D-44 (carried) — D-N pool frozen at D-45; this plan reuses existing D-IDs only (no new D-IDs introduced)
  - D-14 (carried) — `file:line`-style citations use backtick wrapping; SUMMARY.md inline citations use the form `per `.planning/research/SUMMARY.md` § "<heading>"`
metrics:
  duration: ~20 minutes
  completed: 2026-05-10
  tasks: 2 (both with file changes)
  commits: 2 (7f47acf Phase 1+2+3, c393043 Phase 4+5)
  files-modified: 1 (`.planning/CHANGELIST.md`)
  files-created: 1 (this SUMMARY)
---

# Phase 3 Plan 02: Wave 2 — CHANGELIST Phase 1-5 mini-tables (CHANGE-01 first half) Summary

**One-liner:** Populated `.planning/CHANGELIST.md` Phases 1-5 H2 sections with the 6-row Attribute/Detail mini-table per D-38 + ordering-rationale paragraph (hard cap 4 sentences) per phase. 5 of 9 phase mini-tables landed (covering v2.1 + v2.2 + v2.3 + v2.4 milestones); Phase 1 Research-blocked cell carries inline `⚠` marker per D-42; Phase 4 Research-blocked cell carries verbatim `[OPEN: Phase 4 — risk-multiplier defaults pending dYdX-historical validation per D-22]` marker per D-27 carried.

## What Shipped

### Files Modified

| File | Purpose |
|------|---------|
| `.planning/CHANGELIST.md` | Phase 1 / 2 / 3 / 4 / 5 H2 sections populated under existing 03-01 anchors (placeholder notes replaced with mini-table content). Phases 6..9 + Appendices A..E remain placeholder per their populated-by note. |

### Files Created

| File | Purpose |
|------|---------|
| `.planning/phases/03-changelist/03-02-SUMMARY.md` | This summary. |

### Commits

| Hash | Message | Files |
|------|---------|-------|
| `7f47acf` | `docs(03-02): populate CHANGELIST Phase 1, 2, 3 mini-tables (v2.1 + v2.2)` | `.planning/CHANGELIST.md` |
| `c393043` | `docs(03-02): populate CHANGELIST Phase 4, 5 mini-tables (v2.3 + v2.4)` | `.planning/CHANGELIST.md` |

## Per-phase ordering-rationale source

| Phase | Source paragraph | Citation form used inline |
|-------|------------------|---------------------------|
| Phase 1 (v2.1) | Verbatim from SUMMARY.md § "Phase 1 — Foundations & Connector Verification" Rationale block + § "Phase Ordering Rationale" rule 1 | `per `.planning/research/SUMMARY.md` § "Phase 1 — Foundations & Connector Verification" + § "Phase Ordering Rationale": "Phase 1 before Phase 2 because platform skills also point at canonical references; landing Phase 2 first leaves dangling pointers."` |
| Phase 2 (v2.1) | Verbatim from SUMMARY.md § "Phase 2 — Internalise Platform Skills" Rationale block + § "Phase Ordering Rationale" rule 2 | `per `.planning/research/SUMMARY.md` § "Phase 2 — Internalise Platform Skills" + § "Phase Ordering Rationale": "Phase 2 before Phases 3, 4, 5, 7 because all four phases load platform skills."` |
| Phase 3 (v2.2) | Verbatim from SUMMARY.md § "Phase 3 — Stage 1 Kickoff + Stage 4 fnspec Split" Rationale block + § "Phase Ordering Rationale" rule 3 | `per `.planning/research/SUMMARY.md` § "Phase 3 — Stage 1 Kickoff + Stage 4 fnspec Split" + § "Phase Ordering Rationale": "Phase 3 before Phase 4 because tech spec reads fnspec-integration; cost estimate reads both fnspecs."` |
| Phase 4 (v2.3) | Verbatim from SUMMARY.md § "Phase 4 — Tech Spec Scope Gate, Stage 6 Cost Estimate, Stage 7b Implementation Prompt" Rationale block | `per `.planning/research/SUMMARY.md` § "Phase 4 — Tech Spec Scope Gate, Stage 6 Cost Estimate, Stage 7b Implementation Prompt"` |
| Phase 5 (v2.4) | Verbatim from SUMMARY.md § "Phase 5 — Test Bot Rebuild" Rationale block + § "Phase Ordering Rationale" rule 4 | `per `.planning/research/SUMMARY.md` § "Phase 5 — Test Bot Rebuild" + § "Phase Ordering Rationale": "Phase 3 before Phase 5 because test bot derives cases from fnspecs."` |

All 5 ordering paragraphs are <= 4 sentences (CONTEXT Claude's-Discretion cap honoured).

## Cited PITFALL IDs per phase

| Phase | PITFALL IDs cited | Count |
|-------|-------------------|-------|
| Phase 1 | CRIT-6 (frontmatter migration), MIN-5 (stage-numbering orphans), MOD-16 (hard-rules duplicate-and-edit), MIN-6 (email mismatch with stated org) | 4 |
| Phase 2 | MOD-4 (Pipefy GraphQL pagination silently truncates), MOD-5 (Wrike OAuth token-host trap), MOD-6 (Ziflow eventual consistency on proof creation), MOD-7 (Platform-tier capability claims age fast) | 4 |
| Phase 3 | MOD-8 (Field Notes pile-up); plus anti-features avoided: single-fnspec-for-everything (Out-of-Scope row 12); AI auto-classifying delivery tags without human review; AP-6 (splitting fnspec along feature lines instead of buildable surfaces) | 1 PITFALL ID + 3 anti-features |
| Phase 4 | CRIT-1 (Coda formula column overwrite), CRIT-2 (Coda async-202), CRIT-3 (Coda write rate-limit), CRIT-9 (Coda token over-scope), MOD-10 (risk-multiplier indefensible) | 5 |
| Phase 5 | CRIT-5 (sandbox enforcement gap on Coda), CRIT-7 (harness drift), MOD-11 (stale tests linger), MOD-12 (Python/AI orchestrator boundary creep), MOD-13 (concurrency conflict in sandbox), MOD-14 (sandbox cleanup-via-no-deletes); also AP-3 (recreating test-bot on each ship) | 6 PITFALL IDs + 1 anti-feature |
| **Total distinct IDs cited** | CRIT-1, CRIT-2, CRIT-3, CRIT-5, CRIT-6, CRIT-7, CRIT-9 (7 CRIT-class) + MOD-4, MOD-5, MOD-6, MOD-7, MOD-8, MOD-10, MOD-11, MOD-12, MOD-13, MOD-14, MOD-16 (11 MOD-class) + MIN-5, MIN-6 (2 MIN-class) + AP-3, AP-6 (2 anti-features) | **22 distinct** |

## Cited REQ-IDs per phase (FOUND-/PLAT-/STG*-)

| Phase | REQ-IDs | Count |
|-------|---------|-------|
| Phase 1 | FOUND-01, FOUND-02, FOUND-03, FOUND-04, FOUND-05, FOUND-06, FOUND-07 | 7 |
| Phase 2 | PLAT-01, PLAT-02, PLAT-03 | 3 |
| Phase 3 | STG1-01, STG1-02, STG3-01, STG4-01, STG4-02 | 5 |
| Phase 4 | STG5-01, STG6-01, STG6-02, STG7-01, STG7-02 | 5 |
| Phase 5 | STG8-01, STG8-02, STG8-03, STG8-04 | 4 |
| **Total** | 18 distinct REQ-IDs | **24 cells citing 18 distinct IDs** |

(Total cells: 7+3+5+5+4 = 24 individual ID citations; total distinct REQ-IDs: 18.)

## Skills introduced/modified per phase (Appendix A row pointers)

| Phase | Skills delta | Appendix A rows referenced |
|-------|-------------|---------------------------|
| Phase 1 | existing 7 v0.3.0 skills MODIFIED to point at canonical references (no NEW this phase) | rows tagged MODIFIED with Introduced (phase) = Phase 1 |
| Phase 2 | 3 NEW platform skills — `platform-pipefy`, `platform-wrike`, `platform-ziflow` | rows 17, 18, 19 (per DESIGN-12 v2 13-skill matrix) |
| Phase 3 | 1 NEW (`kickoff-capture`) + 1 MODIFIED (`discovery-intake`) + 1 UNCHANGED-structure / behaviour-modified (`generate-sow`) + 2 NEW (`generate-fnspec-platform` Stage 4a, `generate-fnspec-integration` Stage 4b) + 1 RETIRED → SPLIT (`generate-functional-spec`) | rows 1, 2, 3, 4, 5 + retired-row |
| Phase 4 | 1 MODIFIED (`generate-technical-spec`) + 1 NEW (`generate-cost-estimate`) + 1 MODIFIED (`generate-build-prompt`) + 1 NEW (`generate-implementation-prompt`) | rows 6, 7, 8, 9 |
| Phase 5 | 1 NEW (`provision-test-harness`) + 1 MODIFIED (`generate-test-plan` — body unchanged, path moves) + 1 NEW (`generate-uat-plan`) + 1 MODIFIED (`execute-tests` — internally invokes agent) + 1 NEW agent (`agents/test-bot-orchestrator`) | rows 10, 11, 12, 13 + agent row |

Coverage: rows 1-13 (the 13 stage-skill changes Phases 1-5 introduce) + 3 platform skills (rows 17-19) + 1 RETIRED row + 1 NEW agent row. Plan 03-04 owns Appendix A authoring; this plan only references its expected row enumeration.

## Inline `[OPEN]` markers introduced this plan

| Marker | Location | Source |
|--------|----------|--------|
| `[OPEN: Phase 4 — risk-multiplier defaults pending dYdX-historical validation per D-22]` | `.planning/CHANGELIST.md` Phase 4 Research-blocked cell | DESIGN.md Appendix E bullet 8 (verbatim) |

Count: **1 new inline marker** introduced by this plan. Plan 03-07 synthesis reconciles the closed list in Appendix E (DESIGN.md baseline carries 8 markers; new Phase 3-authoring deferrals — none added in this plan beyond the verbatim lift — append).

## Decisions Made (this plan — no new D-IDs introduced)

- **No new D-IDs** introduced by Plan 03-02. D-N pool stays frozen at D-45 per CONTEXT D-44. Every cell content reuses existing D-IDs (D-36 / D-37 / D-38 / D-42 / D-27 carried / D-22 carried / D-44 carried).
- **Bulleted-list rendering inside Deliverables cells:** chose inline `(a) ... (b) ... (c) ...` lettering inside a single table cell rather than nested markdown bullets. Single-cell readability + table-rendering compatibility (markdown table cells don't render `\n - bullet` consistently across renderers). Internal-ordering choice falls under CONTEXT Claude's-Discretion `Internal ordering of bullets within a mini-table cell`.
- **Blockquote vs plain paragraph for ordering rationale:** chose blockquote `>` prefix for visual distinction from the mini-table that follows. Aligned with CONTEXT Claude's-Discretion `Exact wording / length of per-phase ordering-rationale paragraph`.
- **Anti-feature citations** (Phase 3 `Avoids pitfalls` cell) include the `Out of Scope row 12` reference + `AP-6` ID even though the cell template suggests "PITFALL-ID cross-cite" — adopted because SUMMARY.md § Phase 3 explicitly calls these out as avoided shapes alongside MOD-8. Same shape on Phase 5 (`AP-3` named). Falls under D-38 cell-content discretion: "anti-features avoided" is a documented mini-table content type.

## Deviations from Plan

None — plan executed exactly as written. All file paths, mini-table row labels, REQ-ID citations, PITFALL-ID citations, skill names, ordering-rationale verbatim quotes, and inline marker text match the plan's `<interfaces>` and `<tasks>` blocks. The Phase 4 `[OPEN: Phase 4 — risk-multiplier defaults pending dYdX-historical validation per D-22]` substring is verbatim per the plan's CRITICAL requirement.

## Structural-check exit code

`bash .planning/phases/03-changelist/scripts/changelist-structure-check.sh; echo "EXIT_CODE=$?"`

**Expected exit code:** 1 (Wave 2 partial-state — Appendix B sentinel-count assertion still failing because Appendix B is Plan 03-05 territory).
**Actual exit code:** 1 (`FAIL: Appendix B per-bullet sentinel count must be >= 6 (matches AUDIT-07's 6 fixes per D-16/D-41), found 0`).

This matches the verification step 7 in the plan: "structural-check exit status: still 1 (because Phase 6..9 not yet populated; Appendix A/B/E still empty) — NOT 0 yet; that's normal Wave 1 state."

The phase mini-table count assertions (`>= 9 '| Deliverables |' rows / '| Addresses |' rows / '| Avoids pitfalls |' rows`) currently sit at 5 each (one per phase populated by this plan). Plan 03-03 (Wave 3) lands Phases 6..9 to bring each count to 9; subsequent waves close the remaining assertions; Plan 03-07 synthesis is the assertion that exit 0 holds end-to-end.

## Pointer for Next Plans

- **Plan 03-03 (sequential Wave 3 — file-ownership on `.planning/CHANGELIST.md` per cross-AI C8 gemini LOW)** populates Phase 6, 7, 8, 9 mini-tables (v2.5 + v2.6 milestones). Phase 7 is the `[BLOCKED — see Appendix C]` phase per D-42; its mini-table will carry both an inline `⚠` Research-blocked marker AND coordinate with Plan 03-06 for the Appendix C row.
- **Plan 03-04 (Wave 4)** populates Appendix A — must produce >= 15 rows matching the D-39 Status closed enum (`NEW | NEW (split) | MODIFIED | UNCHANGED | RETIRED | RETIRED → SPLIT`). The 5 phase mini-tables shipped by this plan establish the row-pointer expectations (rows 1-13 for stage skills + rows 17-19 for platform skills + retired-row).
- **Plan 03-05 (Wave 5)** populates Appendices B + D. Appendix B verbatim lift from AUDIT-07 6 fix subsections (each with the D-16 sentinel); this is the assertion that's currently first-failing in the structural-check.
- **Plan 03-06 (Wave 6)** populates Appendix C + adds inline `⚠` markers on Phase 1 + Phase 7 mini-tables tied to the Appendix C row body. Phase 1's `⚠` marker landed in this plan; Plan 03-06 may extend its inline text. Phase 7's `⚠` marker will land in Plan 03-03's Phase 7 cell as a coordinate placeholder; Plan 03-06 closes the cross-reference loop.
- **Plan 03-07 (Wave 7 synthesis)** does Executive Summary + How-to-read + Appendix E mechanical walk + final structural-check pass (script must exit 0 — all 15 assertions including the C9 final-only no-placeholder check).

Per cross-AI C8 (gemini LOW): file-ownership on `.planning/CHANGELIST.md` forces sequential execution despite disjoint H2 ownership across plans. Wave numbers (`wave: 2` → `wave: 3` → ...) and `depends_on` chain serialise the plan execution order; "parallel" framing in earlier drafts was a documentation error.

## Self-Check: PASSED

- **Files created/modified verified:**
  - `.planning/CHANGELIST.md` — exists, modified (5 phase H2 sections populated; Phases 6..9 + Appendices unchanged).
  - `.planning/phases/03-changelist/03-02-SUMMARY.md` — exists, this file.
- **Commits verified:**
  - `7f47acf` — `docs(03-02): populate CHANGELIST Phase 1, 2, 3 mini-tables (v2.1 + v2.2)` — present in `git log --oneline`.
  - `c393043` — `docs(03-02): populate CHANGELIST Phase 4, 5 mini-tables (v2.3 + v2.4)` — present in `git log --oneline`.
- **Mini-table row counts verified per phase:** 6 / 6 / 6 / 6 / 6 (Phase 1 / 2 / 3 / 4 / 5).
- **Aggregate counts verified:** `| Deliverables |` = 5 ; `| Addresses |` = 5 ; `| Avoids pitfalls |` = 5 (matches expected post-03-02 state of 5 per kind; Plan 03-03 brings each to 9).
- **Inline markers verified:** Phase 1 `⚠` + `see Appendix C` present; Phase 4 verbatim `[OPEN: Phase 4 — risk-multiplier defaults pending dYdX-historical validation per D-22]` substring present.
- **No accidental modifications:** Phase 6..9 + Appendices A/B/C/D/E still carry their 03-01 placeholder-by notes; H2 anchors unchanged; `(Populated by 03-03-PLAN.md / Wave 1.)` notes still present in Phase 6, 7, 8, 9 sections.
- **No new D-IDs introduced** — D-N pool frozen at D-45.
- **Structural-check exit 1** as expected (Wave 2 partial-state); first-failing assertion is Appendix B sentinel count (Plan 03-05 territory), not a Phase-1..5 assertion.
