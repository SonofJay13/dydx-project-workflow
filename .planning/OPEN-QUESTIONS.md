# Open questions register: dydx-delivery v2.0 → v2.x build sequence

**Register date:** 2026-05-10
**Branch / commit:** dydx-delivery-v2 / (record current commit at synthesis plan)
**Phase 1 Audit (v0.3.0 ground truth):** `.planning/AUDIT.md` (approved 2026-05-09)
**Phase 2 Design (v2 architecture ground truth):** `.planning/DESIGN.md` (approved 2026-05-10)
**Phase 3 Change list (v2.x build sequence):** `.planning/CHANGELIST.md` (approved 2026-05-10)

> (Preamble placeholder — finalised in synthesis plan 04-05.)

## Executive Summary

(Executive summary 3-table placeholder — populated by 04-05-PLAN.md / Wave 5 synthesis. Severity rollup + Owning-phase rollup + Resolution-path rollup tables.)

## How to read this register

(Populated by 04-05-PLAN.md / Wave 5 synthesis. 5 bold-headed paragraphs.)

---

## OPEN-01: Research-flagged unverified items

(Populated by 04-02-PLAN.md / Wave 2. Catalogues every research-flagged "couldn't verify" item with Owning phase + Verification owner per D-47 row schema. Heaviest section ~9-11 rows after cross-AI C6 split: 3x BLOCKER native-AI ingestion (Pipefy AI KB / Wrike AI Studio / Ziflow ReviewAI) + 1x Pipefy GraphQL pagination GUARDRAIL + 1x Ziflow read-after-create GUARDRAIL + Pipefy 2026 rate-limit SPLIT into Q06a Phase 1 + Q06b Phase 2 + Wrike 2026 rate-limit SPLIT into Q07a Phase 1 + Q07b Phase 2 + Miro export-whole-board INFORMATIONAL + Claude in Chrome canonical product naming INFORMATIONAL.)

## OPEN-02: Connector-availability uncertainties

(Populated by 04-02-PLAN.md / Wave 2. ~3-4 rows for connector probes — Coda MCP / Google Workspace MCP / Miro MCP / Wrike auth header. All Phase 1 owner; resolution = `/gsd-research-phase 1`.)

## OPEN-03: Design-decision-deferred items

(Populated by 04-03-PLAN.md / Wave 3. ~3-4 rows: risk-multiplier defaults / frontmatter migration cutover date / status-lifecycle survey / plugin self-test scope cross-link to OPEN-07.)

## OPEN-04: Hub-link backfill rollout coordination

(Populated by 04-03-PLAN.md / Wave 3. Single canonical row per D-51 — pointer-only + invariant.)

## OPEN-05: Standard Coda templates v2 must author

(Populated by 04-03-PLAN.md / Wave 3. ~3 rows: brain-mirror template / task-table template / 00_HUB.md Coda block schema. All Phase 8 owner; resolution = `Coda-template-authoring (Phase 8)`.)

## OPEN-06: /refine-<skill> resolution

(Populated by 04-04-PLAN.md / Wave 4. 1-2 rows: namespace decision + parameterised-vs-orphan-delete. Phase 1 deadline; resolution = `policy-pending-sign-off`.)

## OPEN-07: Plugin self-test scope

(Populated by 04-04-PLAN.md / Wave 4. 1 row: smoke tests scope. Phase 9 owner; resolution = `policy-pending-sign-off`.)

---

## Appendix A: Per-phase rollup index

(Populated by 04-05-PLAN.md / Wave 5 synthesis. `| Phase | Question IDs | BLOCKER | GUARDRAIL | INFORMATIONAL |` — one row per v2.x phase that owns >= 1 question.)

## Appendix B: Source traceability

(Populated by 04-05-PLAN.md / Wave 5 synthesis. `| OPEN-QN | Source citations |` — one row per register row; 1:1 cardinality with register-total per D-53. Sorted numerically by OPEN-QNN per cross-AI G2.)

## Appendix C: Reconciliation algorithm result

(Populated by 04-05-PLAN.md / Wave 5 synthesis. Terminal-state proof block: INPUT_COUNT_AFTER_DEDUP / REGISTER_ROW_COUNT / CARDINALITY_MATCH=TRUE / ALL_CITATIONS_VERIFIED=TRUE / ALL_OWNERS_ASSIGNED=TRUE. Reproduces Phase 2 02-10 / Phase 3 03-07 reconciliation precedent — REAL multiset comparison per cross-AI C3, NOT assumed equality.)

---

*Open questions register produced 2026-05-10; catalogues every "couldn't verify" + "needs human decision" item across `.planning/AUDIT.md` (v0.3.0 ground truth) → `.planning/DESIGN.md` (v2 architecture) → `.planning/CHANGELIST.md` (v2.x sequence). Owning phases assigned per CHANGELIST.md CHANGE-01 sequence; v2.x build phases inherit assigned rows as their resolution backlog.*
