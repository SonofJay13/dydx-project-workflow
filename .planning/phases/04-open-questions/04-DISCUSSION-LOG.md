# Phase 4: Open questions register — Discussion Log

**Session:** 2026-05-10
**Mode:** Claude proposes recommended defaults; user reviews

## Context loaded

- `.planning/PROJECT.md` — milestone v2.0 Implementor Edition framing, key decisions, persona, "design-only milestone" mandate.
- `.planning/REQUIREMENTS.md` § "Open questions register (OPEN-QUESTIONS.md)" — OPEN-01..07 verbatim text.
- `.planning/ROADMAP.md` § "Phase 4: Open questions register" — goal, depends-on, success criteria 1-5, approval gate.
- `.planning/STATE.md` — Phase 3 ✓ APPROVED 2026-05-10; phase 4 next via `/gsd-discuss-phase 4`.
- `.planning/CHANGELIST.md` Appendix E — 9-bullet closed list of inline `[OPEN: Phase 4 — ...]` markers (canonical pre-walk input for Phase 4).
- `.planning/CHANGELIST.md` Appendix C — research-blocked Phase 1 + Phase 7 with verbatim D-37 OPEN-01 fallback.
- `.planning/phases/03-changelist/03-CONTEXT.md` — D-36..D-45 Phase 3 decisions; Phase-4-boundary statements; D-27 carry-forward semantics.
- `.planning/phases/03-changelist/scripts/changelist-structure-check.sh` — closest pattern reference for Phase 4's structural-check.

## Gray-area identification

9 gray areas surfaced: A1 (top-level shape), A2 (per-row schema), A3 (severity scheme), A4 (resolution-path enum), A5 (source merging discipline), A6 (hub-link backfill shape OPEN-04), A7 (policy-decisions shape OPEN-06+OPEN-07), A8 (synthesis structure), A9 (wave/plan count).

Pre-decided / inherited (skipped): document scaffold pattern, D-14 citation format, D-16 sentinel discipline, D-27 OPEN-marker carry-forward, reviewer-ready terminal-state phrase reservation per cross-AI MEDIUM #7, D-N numbering (continues at D-46), approval-gate signal pattern, planner discretion on wave shape per D-45.

## Mode selection

User offered four options for discuss flow. User selected: **"I'll propose recommended defaults for all 9 gray areas; you review"** — fast-path, low conversational overhead.

## Decisions reached (D-46 through D-55)

| ID | Area | Decision | Rationale |
|----|------|----------|-----------|
| D-46 | A1 — top-level shape | **Hybrid:** primary by OPEN-NN category (7 H2 anchors mapping 1:1 to REQUIREMENTS.md OPEN-01..07); secondary index by owning v2.x phase in Appendix A | Matches ROADMAP success criteria 1:1; mechanical traceability into REQUIREMENTS.md; per-phase rollup necessary because v2.x phases each need assigned-rows view |
| D-47 | A2 — per-row schema | **Closed 9-field schema:** OPEN-QN / Question / Source citations / Owning phase / Verification owner / Severity / Resolution path / Proposed default / Status | Every field structurally checkable; multi-source citation accommodates dedup per D-50; closed enums per D-48/D-49 enforced |
| D-48 | A3 — severity | **3-tier closed enum:** BLOCKER / GUARDRAIL / INFORMATIONAL | Phase 7 D-37 already names "HARD BLOCKER"; pagination-style items aren't blocker but need resolution within phase; defaults like risk-multiplier numerics need awareness without halting; 3 tiers cover all observed cases |
| D-49 | A4 — resolution-path | **5-value closed enum:** /gsd-research-phase N / decide-before-Phase-N / Coda-template-authoring (Phase 8) / policy-pending-sign-off / live-workstream-pointer | Covers every observed input row across Appendix E + OPEN-01..07; closed enum keeps register grep-able for v2.x phases |
| D-50 | A5 — source merging | **Single canonical row per dedup-on-Question-text; multi-source citation list per row.** Reconciliation algorithm at end-of-doc: cardinality + diff + ownership-per-row | Phase 2 02-10 + Phase 3 03-07 reconciliation precedent; algorithm shape proven; dedup needed because Appendix E / OPEN-01 overlap heavily |
| D-51 | A6 — hub-link OPEN-04 | **Pointer-only + invariant.** Single row; resolution-path = live-workstream-pointer; verification-owner = Phase 1 / Jason; proposed default = "graceful halt at Stage 9 only" verbatim from REQUIREMENTS.md | Phase 4 doesn't have client list; snapshotting a moving target degrades over time; pointer keeps register valid as workstream evolves |
| D-52 | A7 — policy OPEN-06+07 | **Formalise decision-deadline + acceptance-signal + fallback-if-undecided per row.** Recommended defaults verbatim from REQUIREMENTS.md, status = `proposed` | ROADMAP criterion 5 says "with clear 'decide before Phase X' owners"; the 3 sub-fields encode that within the closed 9-field schema |
| D-53 | A8 — synthesis | **Full reviewer-ready shape mirroring Phase 3 03-07:** preamble blockquote / Executive Summary 3-table / How-to-read 5-section / OPEN-01..07 H2 sections / Appendix A per-phase rollup / Appendix B traceability / Appendix C reconciliation result | Phase 4 is milestone handoff doc — reviewer-ready demands matter; Phase 3 pattern is proven and extends naturally |
| D-54 | A9 — wave count | **Defer to planner per D-45.** Recommendation hint: 5 waves (scaffold / OPEN-01+02 / OPEN-03+04+05 / OPEN-06+07 / synthesis); structural-check script artefact mandatory | Inputs smaller than Phase 3 so 5 waves likely sufficient; but file-ownership analysis is planner's job; D-45 explicitly preserves planner discretion |
| D-55 | new-question discovery | **Authoring may discover questions not in input streams; back-cite into source file (D-27 bi-directional).** Limit: register-authoring not research-authoring | D-27 carry-forward is bi-directional; Phase 4 should not turn into a research phase mid-flight |

## Cross-cutting decisions (carried forward)

- **D-14** (Phase 1) — citation format `` `path:line` ``.
- **D-16** (Phase 1) — sentinel discipline; Phase 4 uses Owning-phase + Verification-owner per row as the OPEN-QUESTIONS-equivalent sentinel.
- **D-25** (Phase 2) — status-lifecycle survey discipline applies to register rows that reference live `status:` values.
- **D-27** (Phase 2) — OPEN-marker carry-forward (point of use AND closed list); Phase 4 IS the closed registry.
- **D-28** (Phase 2) — closed-enum discipline; Phase 4's 4 closed enums (severity / resolution-path / status / owning-phase) all structurally checked.
- **D-37** (Phase 3) — OPEN-01 contingent fallback verbatim wording where Phase 7-blocker rows are described.
- **D-42** (Phase 3) — research-blocked phases get `Resolution path: /gsd-research-phase <N>`.
- **D-45** (Phase 3) — final wave/plan shape stays planner discretion.

## Deferred ideas captured

- Live-workstream tracker source-of-truth (Jason names during v2.1 Foundations build).
- OPEN-NN ID renumbering / collapsing — v2.1 concern.
- Per-row last-verified timestamp — v2.x build phase concern.
- Cross-milestone carry-forward (v2.0 → v2.1+) — v2.1 milestone definition concern.
- Register render as JSON/YAML — v2.1 Foundations tooling concern.
- Auto-generated Appendix B traceability — v2.1+ tooling concern.

## Next steps presented to user

1. Review `.planning/phases/04-open-questions/04-CONTEXT.md` (10 D-N decisions; ready for planner).
2. If satisfied: `/gsd-plan-phase 4` to produce PLAN.md files.
3. If issues: identify which D-NN to revisit; request explicit revision.

## Approval signal

User to confirm via explicit go-ahead. Until then, CONTEXT.md is committed at `phase-discuss-complete-awaiting-review` state.
