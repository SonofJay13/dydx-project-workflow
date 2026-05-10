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

> **Why this phase here.** Tech spec scope-gates against fnspec-integration existence; cost estimate adds Coda integration (depends on Phase 1 Coda verification); implementation prompt is a sibling of the existing build prompt. Cannot run before Phase 3 because cost estimate reads fnspecs. *(per `.planning/research/SUMMARY.md` § "Phase 4 — Tech Spec Scope Gate, Stage 6 Cost Estimate, Stage 7b Implementation Prompt")*

| Attribute | Detail |
|---|---|
| Deliverables | (a) `generate-technical-spec/` MODIFIED (Stage 5, scope-gated; emits platform-API addendum on 4a if no 4b); (b) `generate-cost-estimate/` (Stage 6, NEW; reads Coda task-table schema + caches in 00_HUB.md, writes per-assignee rows via `rows/upsert` with `keyColumns`, polls `mutationStatus`, rate-limits at 4 req/10s — 80% of Coda's 5/10s ceiling per CRIT-3); (c) `generate-build-prompt/` MODIFIED (Stage 7a); (d) `generate-implementation-prompt/` (Stage 7b, NEW; per-platform shape — Pipefy = Behaviors instructions + KB upload list; Wrike = Copilot workflow narrative; Ziflow = checklist/criteria spec); (e) risk-multiplier taxonomy STRUCTURE locked per DESIGN-22 (with mandatory `rationale` field per row) — numeric defaults DEFERRED per D-22. |
| Depends on | Phase 1 (Coda MCP verified), Phase 2 (platform skills loaded for per-platform Stage 7b shapes), Phase 3 (fnspec-platform + fnspec-integration to read) |
| Addresses | STG5-01, STG6-01, STG6-02, STG7-01, STG7-02 |
| Avoids pitfalls | CRIT-1 (Coda formula column overwrite — schema-introspect first), CRIT-2 (Coda async-202 — `mutate_and_wait`), CRIT-3 (Coda write rate-limit — batch `rows/upsert` + 4/10s buffer + idempotent retry via `keyColumns`), CRIT-9 (Coda token over-scope — per-client tokens + 00_HUB.md doc IDs), MOD-10 (risk-multiplier indefensible — closed taxonomy + `rationale` field per row) |
| Skills introduced/modified | 1 MODIFIED (`generate-technical-spec`, Stage 5) + 1 NEW (`generate-cost-estimate`, Stage 6) + 1 MODIFIED (`generate-build-prompt`, Stage 7a) + 1 NEW (`generate-implementation-prompt`, Stage 7b). Appendix A rows 6, 7, 8, 9. |
| Research-blocked | — (Coda API HIGH-confidence per RESEARCH.md; per-platform Stage 7b implementation-prompt shapes documented in FEATURES.md). Risk-multiplier numeric defaults `[OPEN: Phase 4 — risk-multiplier defaults pending dYdX-historical validation per D-22]` — Phase 4 OPEN-QUESTIONS register owner. |

## Phase 5: Test bot rebuild (v2.4)

> **Why this phase here.** Test bot needs the new fnspec-platform + fnspec-integration to derive cases properly; building before Phase 3 means rebuilding to handle the split. Self-contained otherwise; depends only on `<Client> Brain/test-bot/` shape and existing `execute-tests` safety contract. *(per `.planning/research/SUMMARY.md` § "Phase 5 — Test Bot Rebuild" + § "Phase Ordering Rationale": "Phase 3 before Phase 5 because test bot derives cases from fnspecs.")*

| Attribute | Detail |
|---|---|
| Deliverables | (a) `provision-test-harness/` (Stage 8a, NEW; bootstrap once, delta-update thereafter against `client_state.yaml`); (b) `generate-test-plan/` UNCHANGED body / MODIFIED path (Stage 8b — moves to `<Client> Brain/test-bot/test_cases/`); (c) `generate-uat-plan/` (Stage 8c, NEW); (d) `execute-tests/` UNCHANGED user-facing / MODIFIED-internally (Stage 8d — invokes test-bot agent); (e) `agents/test-bot-orchestrator/` agent (NEW); (f) per-client `client_state.yaml` schema (sandbox tenant IDs gated by platform, fixtures, integration toggles, `wrike_host`, `last_known_schema` per platform, `last_passed_at` per test case, `targets_artefact` per test case for obsolescence detection); (g) sandbox-allowlist extended to Coda (CRIT-5 fix); (h) `harness_drift` failure class added to `spec gap | implementation gap | environment issue | unknown`; (i) `sandbox_lock.yaml` for concurrency; (j) test-case lifecycle states `active | obsolete | quarantined`; (k) drift-detection algorithm per DESIGN-30 (pre-flight schema diff; mismatch halts + emits `schema_drift_report.md`). |
| Depends on | Phase 3 (fnspec-platform + fnspec-integration to derive cases) |
| Addresses | STG8-01, STG8-02, STG8-03, STG8-04 |
| Avoids pitfalls | CRIT-5 (sandbox enforcement gap on Coda — extend allowlist), CRIT-7 (harness drift — `client_state.yaml` + drift detection), MOD-11 (stale tests linger — lifecycle states), MOD-12 (Python/AI orchestrator boundary creep — hard contract on layer separation), MOD-13 (concurrency conflict in sandbox — `sandbox_lock.yaml`), MOD-14 (sandbox cleanup-via-no-deletes — fixture run-ID prefix); also avoids AP-3 (recreating test-bot on each ship) |
| Skills introduced/modified | 1 NEW (`provision-test-harness`, Stage 8a) + 1 MODIFIED (`generate-test-plan`, Stage 8b — body unchanged; path moves to `<Client> Brain/test-bot/test_cases/`) + 1 NEW (`generate-uat-plan`, Stage 8c) + 1 MODIFIED (`execute-tests`, Stage 8d — internally invokes `test-bot-orchestrator` agent). Plus 1 NEW agent: `agents/test-bot-orchestrator/`. Appendix A rows 10, 11, 12, 13. |
| Research-blocked | — (self-contained — depends on `<Client> Brain/test-bot/` shape + existing `execute-tests` safety contract; both validated) |

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
