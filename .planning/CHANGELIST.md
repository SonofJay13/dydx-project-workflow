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

> **Why this phase here.** Every later phase depends on canonical references existing and being authoritative; renumbering files before adding new skills is cheaper than after. Connector availability gates which Stage 5/9/11 designs ship vs degrade. *(per `.planning/research/SUMMARY.md` § "Phase 1 — Foundations & Connector Verification" + § "Phase Ordering Rationale": "Phase 1 before Phase 2 because platform skills also point at canonical references; landing Phase 2 first leaves dangling pointers.")*

| Attribute | Detail |
|---|---|
| Deliverables | (a) `dydx-delivery/references/{safety-rules.md, stage-numbering.md, frontmatter-scheme.md, glossary.md}` canonical references; (b) existing 7 skills updated to point at canonical references (collapses 4 hard-rules duplicates per AUDIT-05.1; fixes sandbox-block bug; normalises `based_on_*` field names); (c) file renumbering 00→02 / 01→03 / 02→04 / 03→05 / 04→07a per FOUND-03; (d) plugin manifest `2.0.0` synced across `plugin.json` + `marketplace.json` metadata + `plugins[0]`; (e) owner-email mismatch corrected (per MIN-6); (f) `LICENSE` file added; (g) empty `commands/`, `agents/`, `hooks/` scaffolded; (h) connector-probe + graceful-degradation matrix codified (Coda MCP / Google Workspace MCP / Miro path / Pipefy / Wrike / Ziflow auth + native-AI ingestion paths); (i) all cosmetic CONCERNS items cleaned per Appendix B. |
| Depends on | — (root phase) |
| Addresses | FOUND-01, FOUND-02, FOUND-03, FOUND-04, FOUND-05, FOUND-06, FOUND-07 |
| Avoids pitfalls | CRIT-6 (frontmatter migration corrupts in-flight builds), MIN-5 (stage-numbering orphans), MOD-16 (hard-rules duplicate-and-edit), MIN-6 (email mismatch with stated org) |
| Skills introduced/modified | existing 7 v0.3.0 skills MODIFIED to point at canonical references (no NEW skills this phase — see Appendix A rows tagged MODIFIED with Introduced (phase) = Phase 1) |
| Research-blocked | ⚠ Connector availability per tenant unverified (Coda MCP version pin, Google Workspace MCP choice, Miro MCP existence, Wrike rate-limit currency, Ziflow auth header) — see Appendix C |

## Phase 2: Internalise Platform Skills (v2.1)

> **Why this phase here.** v0.3.0 references `platform-pipefy/wrike/ziflow` but they don't exist in the repo today (per `.planning/AUDIT.md` § AUDIT-04.1). Every later phase that loads a platform skill (Stage 4 fnspec split, Stage 5 tech spec, Stage 7b implementation prompt, Stage 8 test bot, Stage 10 native-AI push) inherits the broken contract until these land. *(per `.planning/research/SUMMARY.md` § "Phase 2 — Internalise Platform Skills" + § "Phase Ordering Rationale": "Phase 2 before Phases 3, 4, 5, 7 because all four phases load platform skills.")*

| Attribute | Detail |
|---|---|
| Deliverables | (a) `skills/platform-pipefy/` + `references/{api-contract.md, native-ai-inventory.md, knowledge-ingestion.md, client-shape-gotchas.md, vocabulary.md}` (provides `paginate_all` helper to avoid MOD-4); (b) `skills/platform-wrike/` (same shape; persists `host` from OAuth token response per MOD-5); (c) `skills/platform-ziflow/` (same shape; provides `wait_for_proof` helper to handle MOD-6 eventual consistency); (d) `tier_claims_last_verified:` frontmatter on each per MOD-7; (e) per-platform `native_ai_path: api | paste | none` decision frontmatter per STACK.md §4.4. |
| Depends on | Phase 1 (canonical references must exist before platform skills point at them — per ordering rule) |
| Addresses | PLAT-01, PLAT-02, PLAT-03 |
| Avoids pitfalls | MOD-4 (Pipefy GraphQL pagination silently truncates), MOD-5 (Wrike OAuth token-host trap), MOD-6 (Ziflow eventual consistency on proof creation), MOD-7 (Platform-tier capability claims age fast) |
| Skills introduced/modified | 3 NEW platform skills — `platform-pipefy`, `platform-wrike`, `platform-ziflow` (Appendix A rows 17-19 per DESIGN-12 matrix). No stage-skill changes this phase. |
| Research-blocked | ⚠ Pipefy GraphQL pagination cursor field names + Pipefy/Wrike 2026 rate-limit currency + Ziflow read-after-create consistency window unverified — see Appendix C |

## Phase 3: Stage 1 + Stage 4 split (v2.2)

> **Why this phase here.** Two largest shape-changes to the existing pipeline (Stage 1 kickoff + Stage 4 fnspec split). Deferring means later phases inherit the broken single-fnspec contract. Stage 4 split is the highest-leverage v2 feature — the `delivery: native-ai|api` tag is the routing key for Stages 5/6/7b/10. *(per `.planning/research/SUMMARY.md` § "Phase 3 — Stage 1 Kickoff + Stage 4 fnspec Split" + § "Phase Ordering Rationale": "Phase 3 before Phase 4 because tech spec reads fnspec-integration; cost estimate reads both fnspecs.")*

| Attribute | Detail |
|---|---|
| Deliverables | (a) `kickoff-capture/` skill (Stage 1, NEW; reads Miro/notes/feedback, branches into discovery or draft SOW); (b) `discovery-intake/` MODIFIED to consume `01_kickoff_v*` (Stage 2); (c) `generate-sow/` MODIFIED (Stage 3, status lifecycle `draft → client_review → approved → archived` locked); (d) `generate-fnspec-platform/` (Stage 4a, NEW); (e) `generate-fnspec-integration/` (Stage 4b, NEW); (f) `generate-functional-spec/` RETIRED → SPLIT into 4a + 4b; (g) cross-spec consistency check between 4a and 4b; (h) `delivery: native-ai|api` tag carries through all downstream `based_on_*` chains. |
| Depends on | Phase 1 (canonical references), Phase 2 (platform skills loaded by Stage 4a per-platform capability matrix) |
| Addresses | STG1-01, STG1-02, STG3-01, STG4-01, STG4-02 |
| Avoids pitfalls | MOD-8 (Field Notes pile-up — kickoff filters by `processed_at IS NULL`); plus anti-features avoided: single-fnspec-for-everything (legacy v0.3.0 shape — explicitly retired per REQUIREMENTS.md Out of Scope row 12); AI auto-classifying delivery tags without human review; AP-6 (splitting fnspec along feature lines instead of buildable surfaces) |
| Skills introduced/modified | 1 NEW (`kickoff-capture`, Stage 1) + 1 MODIFIED (`discovery-intake`, Stage 2) + 1 UNCHANGED-structure/behaviour-modified (`generate-sow`, Stage 3) + 2 NEW (`generate-fnspec-platform` Stage 4a, `generate-fnspec-integration` Stage 4b) + 1 RETIRED (`generate-functional-spec` → SPLIT). Appendix A rows 1, 2, 3, 4, 5 + retired-row. |
| Research-blocked | — |

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
