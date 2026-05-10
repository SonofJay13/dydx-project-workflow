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

> **Why this phase here.** Drive MCP integration; depends on shipped CRs to diff against and on Phase 1 connector verification. *(per `.planning/research/SUMMARY.md` § "Phase 6 — Documentation Publishing (Stage 9)")*

| Attribute | Detail |
|---|---|
| Deliverables | (a) `update-documentation/` skill (Stage 9, NEW; writes `ChangeRequests/<CR>/doc-diff.md`, requires reviewer approval, publishes via Drive MCP); (b) naming-scheme normalisation `<client_slug>__<project_slug>__<doc_type>__v<N>` with double-underscore separator + closed `doc_type` enum (per DESIGN-25 9-value enum); (c) `doc_published_at` timestamp on Drive doc + frontmatter; (d) `00_Index.md` canonical in Drive (local snapshot regenerated on push); (e) graceful halt condition if `<Client> Brain/00_HUB.md` `Documentation:` link missing (does not halt other stages — MOD-1 prevention). |
| Depends on | Phase 1 (Drive MCP verified via connector probe), Phase 5 (Stage 8d test results approved upstream gate Stage 9 doc-diff) |
| Addresses | STG9-01, STG9-02 |
| Avoids pitfalls | CRIT-8 (publish/ingest race — `doc_published_at` invariant before Stage 10), MOD-1 (hub-link contract halts unrelated stages — graceful halt at Stage 9 only), MOD-15 (naming-scheme drift — closed `doc_type` enum + double-underscore separator), MIN-1 (diff rubber-stamp — plain-English summary + targeted question), MIN-2 (Drive permission asymmetry on new docs) |
| Skills introduced/modified | 1 NEW (`update-documentation`, Stage 9). Appendix A row 14. |
| Research-blocked | — |

## Phase 7: Native-AI knowledge push (v2.5) [BLOCKED — see Appendix C]

> **Why this phase here.** Per-platform path; depends on platform skills (Phase 2) and approved doc fragments (Phase 6). *(per `.planning/research/SUMMARY.md` § "Phase 7 — Native-AI Knowledge Push (Stage 10)" + § "Phase Ordering Rationale": "Phase 6 before Phase 7 because Stage 10 ingests approved doc fragments from Stage 9.")*

| Attribute | Detail |
|---|---|
| Deliverables | (a) `push-native-ai-knowledge/` skill (Stage 10, NEW); (b) reads `04a` + approved doc fragments from Stage 9 + per-platform `references/native-ai-inventory.md`; (c) branches on `native_ai_path: api | paste | none` (copy-paste fallback default); (d) refuses ingest if `doc_published_at < last_diff_review_at` (CRIT-8 fix); (e) per-client target ID in `00_HUB.md` `Pipefy AI:` / `Wrike AI:` blocks; (f) refuses ingest if target mismatches `client:` frontmatter (MIN-4 fix); (g) `doc_version: <semver>` + `ingested_at: <ISO>` per ingested doc. |
| Depends on | Phase 2 (platform-pipefy/-wrike/-ziflow `native-ai-inventory.md` references), Phase 6 (approved doc fragments from Stage 9) |
| Addresses | STG10-01, STG10-02, STG10-03 (REQUIREMENTS.md flags "BLOCKED BY OPEN-01") |
| Avoids pitfalls | CRIT-8 (knowledge-ingestion races doc publishing — refuses ingest if `doc_published_at < last_diff_review_at`), MIN-3 (knowledge-versioning gap — `doc_version` + `ingested_at` per ingested doc), MIN-4 (multi-tenant knowledge leak — refuses ingest if target mismatches `client:`) |
| Skills introduced/modified | 1 NEW (`push-native-ai-knowledge`, Stage 10). Appendix A row 15. |
| Research-blocked | ⚠ **HARD BLOCKER (Phase 7 inherits OPEN-01).** Three native-AI ingestion paths could not be externally verified: Pipefy AI KB content-upload endpoint, Wrike AI Studio knowledge-ingestion API, Ziflow ReviewAI knowledge-ingestion API. See Appendix C for full unknown-list + recommended `/gsd-research-phase` invocation.<br><br>**Inline marker (per D-27 carried — pulled forward from DESIGN.md Appendix E bullet 1):** `[OPEN: Phase 4 — Pipefy AI KB content-upload endpoint not externally verified per OPEN-01 — Phase 7 owner per CHANGE-04]`<br><br>**OPEN-01 contingent fallback (verbatim per D-37):** "If OPEN-01 (native-AI ingestion paths per platform) remains unresolved at v2.5 kickoff, split P6 → v2.5 (Documentation only) and P7 → v2.6 (Native-AI when unblocked); slide P8/P9 → v2.7. Phase 7 is the only blocked-by-OPEN phase; isolating it preserves cadence on the rest." |

## Phase 8: Sign-off + Coda mirror (v2.6)

> **Why this phase here.** Depends on Coda MCP verification (Phase 1) and stable brain shape; closes the loop because next ship's kickoff reads Field Notes table populated since the last archive. *(per `.planning/research/SUMMARY.md` § "Phase 8 — Sign-off, Brain Update, Archive (Stage 11) + Coda Mirror" + § "Phase Ordering Rationale": "Phase 8 last among stage-skill phases because it depends on Coda MCP verification AND stable brain shape AND closes the loop with Field Notes for next ship's Phase 3 kickoff.")*

| Attribute | Detail |
|---|---|
| Deliverables | (a) `sign-off-and-archive/` skill (Stage 11, NEW); (b) updates local `<Client> Brain/<spokes>/`; (c) one-way push to Coda mirror with brain-mirror Coda doc template (Overview / Workflows / Platforms / Integrations / Operating Model / Change History / Field Notes — 7 canonical spoke-shaped sections per DESIGN-27); (d) `tone_lint` pass before publish (MOD-9 prevention); (e) CR move to `Archive/`; (f) `00_Index.md` version bump; (g) Field Notes preserved (input-only, never overwritten); (h) pre-archive sanity check (no orphan refs, no missing artefacts). |
| Depends on | Phase 1 (Coda MCP verified — required for one-way mirror push), Phase 6 (documentation published — sign-off references published-doc state) |
| Addresses | STG11-01, STG11-02, STG11-03 |
| Avoids pitfalls | CRIT-4 (two-way Coda sync re-emerging through Field Notes auto-merge — Field Notes never auto-merged; Stage 11 push is one-way only per DESIGN-09 directional boundary), MOD-9 (brain spoke leaks internal-only language to Coda — `tone_lint` pass before publish) |
| Skills introduced/modified | 1 NEW (`sign-off-and-archive`, Stage 11). Appendix A row 16. |
| Research-blocked | — |

## Phase 9: Surfaces (v2.6)

> **Why this phase here.** Quality-of-life on top of fully-shipped skills; building before underlying skills means rewriting as skills shift. Validation/safety hooks fall here because they enforce shapes that only stabilise after Phases 1–8 land. *(per `.planning/research/SUMMARY.md` § "Phase 9 — Surfaces (commands/, agent wrapping, hooks/)" + § "Phase Ordering Rationale": "Phase 9 last overall because surfaces wrap stable underlying behaviour; building hooks before skills means hooks chase a moving target.")*

| Attribute | Detail |
|---|---|
| Deliverables | (a) `commands/refine.md` (single parameterised command taking skill name as `$1` per DESIGN-05 — avoids 10+ separate files; namespace `/dydx-refine-*` per DESIGN-23 carried); (b) `commands/{gsd-test-bot-run, gsd-publish-docs, gsd-push-native-ai, gsd-archive-cr}.md` (4 GSD-prefixed shortcuts per DESIGN-04); (c) `hooks/validate-frontmatter.py` (PostToolUse, parses YAML object never raw markdown per MOD-3 prevention); (d) `hooks/bump-artefact-version.py` (PreToolUse, enforces `_v{N+1}.md` naming); (e) approval-gate hook refusing `status: approved` writes lacking `approved_by` per DESIGN-06; (f) `mcpServers` field in `dydx-delivery/.claude-plugin/plugin.json` per DESIGN-04; (g) optional plugin self-tests at `dydx-delivery/tests/` per DESIGN-04 + D-24 (scope decision is `[OPEN: Phase 4 — plugin self-test scope per OPEN-07]` — pulled forward from REQUIREMENTS.md OPEN-07). |
| Depends on | Phases 1-8 (surfaces wrap behaviour; building hooks before skills means hooks chase a moving target — per ordering rule) |
| Addresses | SURF-01, SURF-02, SURF-03 |
| Avoids pitfalls | MOD-2 (slash-command name collision — namespace as `/dydx-refine-*`; `/refine-<skill>` orphan references resolved per CONCERNS.md MOD-2), MOD-3 (hook frontmatter corruption — operates on parsed YAML object, never raw markdown). Plus anti-feature avoided: auto-progression hooks (REQUIREMENTS.md Out of Scope row 12 — explicitly excluded). |
| Skills introduced/modified | No skill rows. `agents/test-bot-orchestrator/` shipped in Phase 5 — Phase 9 wraps it as a user-facing surface only via `/gsd-test-bot-run` shortcut. |
| Research-blocked | — |

---

## Appendix A: Per-skill delta matrix (CHANGE-02)

This appendix inventories every skill in the v2 universe — every existing v0.3.0 skill tagged `NEW / MODIFIED / RETIRED / RETIRED → SPLIT / UNCHANGED` with the change description, and every NEW v2 skill tagged with its introducing phase. Single source of truth for "is skill X changing in v2"; the matrix ties forward to `.planning/DESIGN.md` per-skill sections via the DESIGN column and back to the 9-phase build plan via the Introduced (phase) column.

| v0.3.0 origin | v2 name | Status | Change | Introduced (phase) | DESIGN |
|---|---|---|---|---|---|
| referenced-but-missing (per `.planning/AUDIT.md` § AUDIT-04.1) | `platform-pipefy/` | NEW | Platform-knowledge skill (sibling-of-stage shape per cross-AI C2) — internalises platform knowledge loaded by `platform: pipefy` frontmatter (per DESIGN-14)<br>Carries 5-file `references/` shape: api-contract / native-ai-inventory / knowledge-ingestion / client-shape-gotchas / vocabulary (per DESIGN-14)<br>Provides `paginate_all` helper for GraphQL cursor pagination (per DESIGN-14 / MOD-4 prevention) | Phase 2 (v2.1) | DESIGN-14 |
| referenced-but-missing (per `.planning/AUDIT.md` § AUDIT-04.1) | `platform-wrike/` | NEW | Platform-knowledge skill (sibling-of-stage shape per cross-AI C2) — internalises Wrike platform knowledge with same 5-file references shape (per DESIGN-15)<br>Persists `host` from OAuth token response (NOT hardcoded `www.wrike.com` — per MOD-5 prevention)<br>Native-AI matrix grounded in Wrike Copilot + 16 MCP tools (per DESIGN-15 + RESEARCH.md FEATURES) | Phase 2 (v2.1) | DESIGN-15 |
| none in v0.3.0 | `platform-ziflow/` | NEW | Platform-knowledge skill (sibling-of-stage shape per cross-AI C2) — new platform knowledge surface; same 5-file references shape (per DESIGN-16)<br>Provides `wait_for_proof` helper for read-after-create eventual consistency (per DESIGN-16 / MOD-6 prevention)<br>Native-AI matrix grounded in Ziflow ReviewAI Checklists Public Preview (per DESIGN-16) | Phase 2 (v2.1) | DESIGN-16 |
| none | `kickoff-capture/` | NEW | Stage 1 dual-branch artefact capture from meeting notes / Miro / Field Notes (per DESIGN-17)<br>Field Notes triage default `processed_at IS NULL` — never auto-merges (per DESIGN-17 / MOD-8 prevention)<br>Auto-classifies inputs into kickoff template sections with explicit "unknown" markers (per DESIGN-17) | Phase 3 (v2.2) | DESIGN-17 |
| derived from RETIRED `generate-functional-spec` (per `.planning/AUDIT.md` § AUDIT-01.3 + DESIGN-20) | `generate-fnspec-platform/` | NEW (split) | Stage 4a — platform-only fnspec; per-requirement `delivery: native-ai \| api` tagging is the routing key for downstream Stages 5/6/7b/10 (per DESIGN-20)<br>Per-platform capability matrix as classifier input (per DESIGN-20 + DESIGN-14/15/16)<br>Either spec optional for single-track projects (per DESIGN-20) | Phase 3 (v2.2) | DESIGN-20 |
| derived from RETIRED `generate-functional-spec` (per `.planning/AUDIT.md` § AUDIT-01.3 + DESIGN-20) | `generate-fnspec-integration/` | NEW (split) | Stage 4b — integration-only fnspec; cross-spec consistency check vs 4a (per DESIGN-20)<br>Skip if no integration work (per DESIGN-20 — single-track shape)<br>Tags every requirement with `delivery: native-ai \| api` mirroring Stage 4a (per DESIGN-20) | Phase 3 (v2.2) | DESIGN-20 |
| `dydx-delivery/skills/discovery-intake/SKILL.md` (per `.planning/AUDIT.md` § AUDIT-01.1) | `discovery-intake/` | MODIFIED | Consumes `01_kickoff_v*` artefact (skip raw-notes mode per DESIGN-18)<br>Skips entire stage when kickoff produced draft SOW (per DESIGN-18)<br>Same template structure as v0.3.0 otherwise (per DESIGN-18) | Phase 3 (v2.2) | DESIGN-18 |
| `dydx-delivery/skills/generate-sow/SKILL.md` (per `.planning/AUDIT.md` § AUDIT-01.2) | `generate-sow/` | MODIFIED | Structurally unchanged from v0.3.0 / behaviour-modified per cross-AI C2 — single SOW covers platform AND integration (per DESIGN-19)<br>Status lifecycle locked to canonical scheme: `draft → client_review → approved → archived` (`client_review` retained per DESIGN-08 + AUDIT.md § AUDIT-01.2 — sole skill carrying `client_review` in v0.3.0) | Phase 3 (v2.2) | DESIGN-19 |
| `dydx-delivery/skills/generate-functional-spec/SKILL.md` (per `.planning/AUDIT.md` § AUDIT-01.3) | (none — replaced by Stage 4a + 4b split) | RETIRED → SPLIT | Single-fnspec-for-everything legacy v0.3.0 shape retired in favour of Stage 4a / Stage 4b split (per DESIGN-20)<br>v0.3.0 artefacts using old skill name (`02_functional-spec_v*.md`) remain readable per DESIGN-08 lenient mode; CR-driven opt-in upgrades to new names (`04a_fnspec-platform_v*.md` / `04b_fnspec-integration_v*.md` per DESIGN-02) | Phase 3 (v2.2 — replacement landing) | DESIGN-20 |
| none | `generate-cost-estimate/` | NEW | Stage 6 cost estimate via Coda `rows/upsert` with `keyColumns` for idempotency, `mutationStatus` polling, rate-limit at 4 req/10s (per DESIGN-22 + CRIT-2/3/9 prevention)<br>Per-assignee task breakdown with `estimated_hours` + `risk_adjusted_hours` columns + mandatory `rationale` per row (per DESIGN-22 + MOD-10 prevention)<br>Wait-for-commercial-inputs gate before client-facing summary (per DESIGN-22 `commercial_inputs_status: provided` gate) | Phase 4 (v2.3) | DESIGN-22 |
| none | `generate-implementation-prompt/` | NEW | Stage 7b per-platform implementation prompt (Pipefy = Behaviors instructions + KB upload list; Wrike = Copilot workflow narrative; Ziflow = checklist/criteria spec — per DESIGN-23)<br>NOT a universal template (per DESIGN-23 + REQUIREMENTS.md Out of Scope row 13 — anti-feature explicitly excluded)<br>Pulls `delivery: native-ai` rows from Stage 4a fnspec (per DESIGN-23) | Phase 4 (v2.3) | DESIGN-23 |
| `dydx-delivery/skills/generate-technical-spec/SKILL.md` (per `.planning/AUDIT.md` § AUDIT-01.4) | `generate-technical-spec/` | MODIFIED | Scope-gated to Stage 4b existence — emits platform-API addendum on 4a if no 4b exists (per DESIGN-21)<br>Covers error handling + observability + retries + idempotency for API portions; never hand-waves error paths (per DESIGN-21) | Phase 4 (v2.3) | DESIGN-21 |
| `dydx-delivery/skills/generate-build-prompt/SKILL.md` (per `.planning/AUDIT.md` § AUDIT-01.6) | `generate-build-prompt/` | MODIFIED | Stage 7a — dev prompt; carries forward existing v0.3.0 generate-build-prompt body (per DESIGN-23)<br>Pulls `delivery: api` rows from Stage 4a/4b fnspecs (per DESIGN-23) | Phase 4 (v2.3) | DESIGN-23 |
| none | `provision-test-harness/` | NEW | Stage 8a — bootstraps the per-client harness once at `<Client> Brain/test-bot/` (outside this repo); delta-updates each ship via diff against `client_state.yaml` (per DESIGN-24)<br>Sandbox allowlist extended to Coda (per DESIGN-24 / CRIT-5 fix)<br>Drift-detection algorithm (per DESIGN-30) — pre-flight schema diff; mismatch halts + emits `schema_drift_report.md` | Phase 5 (v2.4) | DESIGN-24 |
| none | `generate-uat-plan/` | NEW | Stage 8c — auto-generated UAT plan (per DESIGN-24)<br>Reads Stage 4a + Stage 4b + Stage 8b test-plan as inputs (per DESIGN-24) | Phase 5 (v2.4) | DESIGN-24 |
| `dydx-delivery/skills/generate-test-plan/SKILL.md` (per `.planning/AUDIT.md` § AUDIT-01.5) | `generate-test-plan/` | MODIFIED | Stage 8b — body unchanged from v0.3.0 (per DESIGN-24)<br>Path moves to `<Client> Brain/test-bot/test_cases/` (per DESIGN-24)<br>Each TC marked with tier-1 (Python deterministic) or tier-2 (AI orchestrator) layer per DESIGN-28 | Phase 5 (v2.4) | DESIGN-24 |
| `dydx-delivery/skills/execute-tests/SKILL.md` (per `.planning/AUDIT.md` § AUDIT-01.7) | `execute-tests/` | MODIFIED | Stage 8d — user-facing entry unchanged (per DESIGN-24)<br>Internally invokes `agents/test-bot-orchestrator/` agent for tier-2 free-form interpretation (per DESIGN-04 + DESIGN-28)<br>Sandbox-only enforcement carry-forward (per DESIGN-24 + REQUIREMENTS.md Out of Scope row 18) | Phase 5 (v2.4) | DESIGN-24 |
| none | `update-documentation/` | NEW | Stage 9 — writes `ChangeRequests/<CR>/doc-diff.md`; reviewer-approval gate before push (per DESIGN-25 + MIN-1 prevention)<br>Closed `doc_type` 9-value enum + naming `<client_slug>__<project_slug>__<doc_type>__v<N>` with double-underscore separator (per DESIGN-25 / MOD-15 prevention)<br>Halt condition if `<Client> Brain/00_HUB.md` `Documentation:` link missing — graceful at Stage 9 only (per DESIGN-25 / MOD-1 prevention) | Phase 6 (v2.5) | DESIGN-25 |
| none | `push-native-ai-knowledge/` | NEW | Stage 10 — branches on `native_ai_path: api \| paste \| none`; copy-paste fallback default (per DESIGN-26)<br>Refuses ingest if `doc_published_at < last_diff_review_at` (per DESIGN-26 / CRIT-8 fix)<br>Refuses ingest if target mismatches `client:` frontmatter (per DESIGN-26 / MIN-4 fix) | Phase 7 (v2.5) — BLOCKED BY OPEN-01 per CHANGE-04 | DESIGN-26 |
| none | `sign-off-and-archive/` | NEW | Stage 11 — local `<Client> Brain/<spokes>/` update + one-way Coda mirror push (per DESIGN-27)<br>`tone_lint` pass before publish (per DESIGN-27 / MOD-9 prevention)<br>Field Notes preserved input-only; pre-archive sanity check + 00_Index.md version bump (per DESIGN-27) | Phase 8 (v2.6) | DESIGN-27 |

**Tag totals.** 13-skill v2 universe per DESIGN-12 (10 stage-skills + 3 platform-skills) + 6 MODIFIED rows tracking v0.3.0 skills carried forward into the v2 universe + 1 RETIRED → SPLIT row tracking the v0.3.0 skill no longer present in v2 (`generate-functional-spec`, replaced by `generate-fnspec-platform` Stage 4a + `generate-fnspec-integration` Stage 4b — see rows 4, 5 above) = 20 total Appendix A rows. NEW = 13 (10 stage-skill NEW + 3 platform-skill NEW). MODIFIED = 6 (`discovery-intake` / `generate-sow` / `generate-technical-spec` / `generate-build-prompt` / `generate-test-plan` / `execute-tests` — all carry-forwards from v0.3.0). RETIRED → SPLIT = 1. v2 end-state ship count = 13 skills (per DESIGN-12); the 6 MODIFIED rows are upgrades to skills inside the 13 universe; the RETIRED row ships nothing. AUDIT.md § AUDIT-01 grounds the v0.3.0 7-skill starting state.

## Appendix B: Cosmetic-fix list (CHANGE-03)

Lifted verbatim from `.planning/AUDIT.md` § AUDIT-07 (per D-16 sentinel discipline). Editing here without also editing AUDIT-07 introduces drift; if a fix needs revision, edit AUDIT.md first and re-lift.

#### B.1 README truncation (plugin-level)

- **Citation:** `dydx-delivery/README.md:126` — Changelog entry for `0.3.0` reads: *"The bot-run terminal stage (`execute-tests`) now c"* and the file terminates mid-sentence. No closing punctuation, no further entries.
- **Context:** Plugin README is the install-time README; truncation is visible to anyone reading the plugin's marketplace listing.
- **Severity:** **[COSMETIC]** — client-visible (plugin README).
- **Fix:** Complete the truncated sentence in the changelog entry. **Scheduled for v2.1 Foundations build (FOUND-07), NOT this milestone.**

#### B.2 Residual "test sheet" wording

- **Citation:** `README.md:9` — Root README still says "discovery → SOW → functional spec → technical spec → **test sheet** → execution".
- **Context:** Plugin README changelog (`dydx-delivery/README.md:126`) records the 0.3.0 rename `generate-test-sheet` → `generate-test-plan`; root README never followed the rename.
- **Severity:** **[COSMETIC]** — client-visible (root marketplace README).
- **Fix:** Change "test sheet" to "test plan" at `README.md:9`. **Scheduled for v2.1 Foundations build (FOUND-07), NOT this milestone.**

#### B.3 Pipeline-step count mismatch (root README)

- **Citation:** `README.md:9` says 5 pipeline steps; `.claude-plugin/marketplace.json:15` and `dydx-delivery/.claude-plugin/plugin.json:4` describe **seven skills**; `dydx-delivery/README.md:33-41` lists seven.
- **Context:** Two-vs-three sources of truth disagree on pipeline length; new readers see contradictory information.
- **Severity:** **[COSMETIC]** — client-visible (root README).
- **Fix:** Update `README.md:9` to reflect the 7-skill v0.3.0 pipeline (or v2's 13-skill pipeline post-rebuild). **Scheduled for v2.1 Foundations build (FOUND-07), NOT this milestone.**

#### B.4 Missing LICENSE file

- **Citation:** `dydx-delivery/.claude-plugin/plugin.json:10` declares `"license": "Proprietary"`; no `LICENSE` or `LICENSE.md` file exists at repo root or plugin folder; `.claude-plugin/marketplace.json` has no `license` field.
- **Context:** Provenance gap — the `Proprietary` declaration is unbacked by an actual licence text; clients viewing the marketplace see a license field that doesn't resolve to a document.
- **Severity:** **[COSMETIC]** — client-visible (provenance).
- **Fix:** Add `LICENSE` file at repo root (or `dydx-delivery/LICENSE`) with proprietary licence terms; add matching `license` field to `marketplace.json`. **Scheduled for v2.1 Foundations build (FOUND-04), NOT this milestone.**

#### B.5 Owner-email mismatch with stated org

- **Citation:** `.claude-plugin/marketplace.json:5` (`owner.email`) and `dydx-delivery/.claude-plugin/plugin.json:7` (`author.email`) both list `jasonmichaelb@gmail.com`; README and marketplace metadata describe the team as "dYdX Digital" (e.g. `.claude-plugin/marketplace.json:4`, `dydx-delivery/.claude-plugin/plugin.json:4`); no `@dydx.digital` or org domain appears in the manifests.
- **Context:** Provenance — clients viewing the marketplace see a personal Gmail; mismatches the stated organisational identity.
- **Severity:** **[COSMETIC]** — client-visible (provenance).
- **Fix:** Change to an org-domain address. **Scheduled for v2.1 Foundations build (FOUND-04), NOT this milestone.** **Cross-ref:** MIN-6 PITFALL.

#### B.6 [NEW] Homepage asymmetry

- **Citation:** `dydx-delivery/.claude-plugin/plugin.json:9` has `"homepage": "https://github.com/SonofJay13/dydx-project-workflow"`; `.claude-plugin/marketplace.json` has no `homepage` field. (`.planning/codebase/CONCERNS.md:197-199`).
- **Context:** Asymmetric metadata — the marketplace listing omits a link the plugin manifest provides.
- **Severity:** **[NEW]** **[COSMETIC]** — client-visible (marketplace listing). [NEW] tag because CONCERNS.md flagged the asymmetry but didn't formally categorize it; AUDIT.md elevates it to cosmetic-client-visible.
- **Fix:** Add matching `homepage` field to `marketplace.json`. **Scheduled for v2.1 Foundations build (FOUND-04), NOT this milestone.**

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
