# Change list: dydx-delivery v2.0 → v2.x build sequence

**Change list date:** 2026-05-10
**Branch / commit:** dydx-delivery-v2 / (record current commit at synthesis plan)
**Phase 1 Audit (v0.3.0 ground truth):** `.planning/AUDIT.md` (approved 2026-05-09)
**Phase 2 Design (v2 architecture ground truth):** `.planning/DESIGN.md` (approved 2026-05-10)

> (Preamble placeholder — finalised in synthesis plan 03-07.)

## Executive Summary

(Executive summary table placeholder — populated in synthesis plan 03-07. Acts as TOC: per-section page-anchor + one-line decision summary so reader can skip-to-contract.)

## How to read this change list

(Populated in synthesis plan 03-07. Reader-flow guide — read-in-order vs skip-to-specific-item.)

---

## Phase 1: Foundations + Connector Verification (v2.1)

(Populated by 03-02-PLAN.md / Wave 1. Carries the 6-row mini-table per D-38 + ordering-rationale paragraph from `.planning/research/SUMMARY.md` § Phase Ordering Rationale.)

## Phase 2: Internalise Platform Skills (v2.1)

(Populated by 03-02-PLAN.md / Wave 1.)

## Phase 3: Stage 1 + Stage 4 split (v2.2)

(Populated by 03-02-PLAN.md / Wave 1.)

## Phase 4: Tech spec + Cost + Implementation prompt (v2.3)

(Populated by 03-02-PLAN.md / Wave 1.)

## Phase 5: Test bot rebuild (v2.4)

(Populated by 03-02-PLAN.md / Wave 1.)

## Phase 6: Documentation publishing (v2.5)

(Populated by 03-03-PLAN.md / Wave 1.)

## Phase 7: Native-AI knowledge push (v2.5) [BLOCKED — see Appendix C]

(Populated by 03-03-PLAN.md / Wave 1. The `[BLOCKED — see Appendix C]` H2 tag per D-42 makes the only at-risk phase visible on a casual H2 scan.)

## Phase 8: Sign-off + Coda mirror (v2.6)

(Populated by 03-03-PLAN.md / Wave 1.)

## Phase 9: Surfaces (v2.6)

(Populated by 03-03-PLAN.md / Wave 1.)

---

## Appendix A: Per-skill delta matrix (CHANGE-02)

(Populated by 03-04-PLAN.md / Wave 1. Single matrix, one row per v2 skill — 13 v2 skills + 2 RETIRED rows minimum = 15 rows. Columns: `v0.3.0 origin | v2 name | Status | Change | Introduced (phase) | DESIGN`.)

## Appendix B: Cosmetic-fix list (CHANGE-03)

Lifted verbatim from `.planning/AUDIT.md` § AUDIT-07 (per D-16 sentinel discipline). Editing here without also editing AUDIT-07 introduces drift; if a fix needs revision, edit AUDIT.md first and re-lift.

(Populated by 03-05-PLAN.md / Wave 1. Verbatim lift from AUDIT-07's 6 fix subsections — each carries the per-bullet sentinel `**Scheduled for v2.1 Foundations build (FOUND-NN), NOT this milestone.**` per D-16/D-41.)

## Appendix C: Research-blocked phases (CHANGE-04)

(Populated by 03-06-PLAN.md / Wave 1. 2-row matrix — Phase 1 / Phase 7 — with full unknown-list per blocked phase + recommended `/gsd-research-phase` invocation. Mirrors D-42 "marker at point of use + closed list at end" pattern.)

## Appendix D: Migration cutover rules (CHANGE-05)

Authoritative contract: `.planning/DESIGN.md` § DESIGN-08 (locked by D-25). This appendix restates the rules in implementer-readable form; if rules conflict, DESIGN-08 wins.

(Populated by 03-05-PLAN.md / Wave 1. Numbered checklist of 5-7 rules per D-43.)

## Appendix E: Deferred to Phase 4 OPEN-QUESTIONS

Closed list of every `[OPEN: Phase 4 — ...]` marker in this document. Phase 4 OPEN-QUESTIONS register can be built mechanically by walking this list — every row becomes a register entry with the owning phase already assigned. New deferrals discovered during Phase 3 authoring add a row here AND inline at point of use.

(Populated by 03-07-PLAN.md / Wave 2 synthesis. Pre-populated at minimum from DESIGN.md § "Deferred to Phase 4 OPEN-QUESTIONS" 8-bullet baseline; new Phase 3 deferrals append.)

---

*Change list produced 2026-05-10; sequences `.planning/AUDIT.md` (v0.3.0 ground truth) → `.planning/DESIGN.md` (v2 architecture) into the v2.x build milestone sequence. Phase 4 OPEN-QUESTIONS.md catalogues every `[OPEN]` marker enumerated in Appendix E.*
