# Design: dydx-delivery v2.0 — Implementor Edition architecture

**Design Date:** 2026-05-09
**Branch / commit:** dydx-delivery-v2 / (record current commit at synthesis plan)
**Phase 1 Audit (ground truth):** `.planning/AUDIT.md` (approved 2026-05-09)

> **How to read this design.** This document locks the v2 architecture for the dydx-delivery plugin so the v2.1+ rebuild can execute without re-deciding. Each major section opens with a one-line success-criteria echo (`> **DESIGN-NN:** <plain-English statement>`) so reviewer can match section to REQUIREMENTS.md without cross-referencing. Inline `[OPEN: Phase 4 — ...]` markers flag undecided contracts; the closing `## Deferred to Phase 4 OPEN-QUESTIONS` section enumerates every marker for Phase 4 register handoff. Citations use `file:line` format (Phase 1 D-14 convention). DESIGN.md cites `AUDIT.md §X.Y` for v0.3.0 facts (Phase 2 D-34) — does NOT re-derive observations from v0.3.0 source.
>
> (Preamble placeholder — finalised in synthesis plan 02-10)

## Executive Summary

(Executive summary table placeholder — populated in synthesis plan 02-10. Acts as TOC: per-section page-anchor + one-line decision summary so reader can skip-to-contract.)

---

## Cross-cutting decisions

(Populated by 02-02-PLAN.md / Wave 2. Covers DESIGN-01..10 — frontmatter scheme, stage numbering, hard-rules SoT, plugin surfaces, /refine resolution, approval-gate enforcement, connector probe, frontmatter migration co-existence, directional boundary, persona contract.)

frontmatter_version: 2

### Live status-lifecycle survey
(Populated by 02-02-PLAN.md alongside DESIGN-08. Methodology + results from sampling live `<Client> Brain/` folders per D-25.)

---

## Skill layout

(Populated by 02-03-PLAN.md / Wave 3. Covers DESIGN-11 — v2 folder layout: `skills/`, `commands/`, `agents/`, `hooks/`, `.claude-plugin/`, plugin-level `references/`.)

---

## 13-skill inventory

(Populated by 02-03-PLAN.md / Wave 3. Covers DESIGN-12 — 13-skill inventory matrix-then-prose: 6 NEW stage + 3 NEW platform + 4 MODIFIED + 2 UNCHANGED + 1 RETIRED-AND-REPLACED.)

---

## Stage-by-stage hand-off contract

(Populated by 02-03-PLAN.md / Wave 3. Covers DESIGN-13 — single transition matrix per D-26: From | To | Carrier file path | Frontmatter fields propagated | Gating status flag | Hand-off message. >= 10 transition rows.)

| From | To | Carrier file path | Frontmatter fields propagated | Gating status flag | Hand-off message |
|------|-----|-------------------|-------------------------------|--------------------|--------------------|

---

## Platform skills

(Populated by 02-04-PLAN.md / Wave 4. Covers DESIGN-14, 15, 16 — `platform-pipefy/`, `platform-wrike/`, `platform-ziflow/` with identical 5-file `references/` shape.)

### platform-pipefy
(populated by 02-04-PLAN.md)

### platform-wrike
(populated by 02-04-PLAN.md)

### platform-ziflow
(populated by 02-04-PLAN.md)

---

## Stage 1: Kickoff capture
(Populated by 02-05-PLAN.md / Wave 5. Covers DESIGN-17.)

## Stage 2: Discovery refactor
(Populated by 02-05-PLAN.md / Wave 5. Covers DESIGN-18.)

## Stage 3: SOW refactor
(Populated by 02-05-PLAN.md / Wave 5. Covers DESIGN-19.)

## Stage 4a: Functional spec — platform
(Populated by 02-06-PLAN.md / Wave 6. Covers DESIGN-20 first half.)

## Stage 4b: Functional spec — integration
(Populated by 02-06-PLAN.md / Wave 6. Covers DESIGN-20 second half.)

## Stage 5: Tech spec
(Populated by 02-06-PLAN.md / Wave 6. Covers DESIGN-21.)

## Stage 6: Cost estimate
(Populated by 02-07-PLAN.md / Wave 7. Covers DESIGN-22 — risk-multiplier taxonomy structure; numeric defaults DEFERRED per D-22.)

## Stage 7a: Build prompt — dev
(Populated by 02-07-PLAN.md / Wave 7. Covers DESIGN-23 first half.)

## Stage 7b: Build prompt — implementation per platform
(Populated by 02-07-PLAN.md / Wave 7. Covers DESIGN-23 second half.)

## Stage 8: Test bot — overview
(Populated by 02-08-PLAN.md / Wave 8. Covers DESIGN-24.)

## Stage 9: Documentation publishing
(Populated by 02-08-PLAN.md / Wave 8. Covers DESIGN-25.)

## Stage 10: Native-AI enablement
(Populated by 02-08-PLAN.md / Wave 8. Covers DESIGN-26.)

## Stage 11: Sign-off, brain update, archive
(Populated by 02-08-PLAN.md / Wave 8. Covers DESIGN-27.)

---

## Test bot architecture

(Populated by 02-09-PLAN.md / Wave 9. Covers DESIGN-28, 29, 30 — Python↔AI orchestrator boundary, `client_state.yaml` skeleton, drift-detection contract.)

### DESIGN-28: tier-1 / tier-2 boundary
(populated by 02-09-PLAN.md)

### DESIGN-29: client_state.yaml skeleton
(populated by 02-09-PLAN.md)

### DESIGN-30: drift-detection contract
(populated by 02-09-PLAN.md)

---

## Deferred to Phase 4 OPEN-QUESTIONS

(Populated by 02-10-PLAN.md / Wave 10 synthesis. Closed enumerated list of every inline `[OPEN: Phase 4 — ...]` marker, in document order, with source section reference. Phase 4 register builds against this list.)

- [OPEN: Phase 4 — risk-multiplier numeric defaults pending dYdX-historical validation per D-22]

---

## Appendix A: Glossary
(Populated by 02-10-PLAN.md / Wave 10 synthesis.)

---

## Appendix B: DESIGN-* → DESIGN.md section traceability
(Populated by 02-10-PLAN.md / Wave 10 synthesis. 30-row table: DESIGN-NN | section anchor | locking decision IDs.)

---

## Appendix C: Persona contract worked examples
(Populated by 02-02-PLAN.md alongside DESIGN-10. 3 before/after examples per D-29.)

---

*Design produced 2026-05-09; supersedes ad-hoc v0.3.0 architecture. Phase 3 CHANGELIST.md sequences the v2.x build against this design; Phase 4 OPEN-QUESTIONS.md catalogues every inline [OPEN] marker.*
