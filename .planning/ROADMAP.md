# Roadmap: dydx-delivery v2.x — Implementor Edition

## Milestones

- ✅ **v2.0 — Implementor Edition** (design-only) — Phases 1-4 (design-complete 2026-05-10)
- ✅ **v2.1 — Foundations + Platform Skills** — Phases 5-6 (shipped 2026-05-11) · archive: [`milestones/v2.1-ROADMAP.md`](./milestones/v2.1-ROADMAP.md)
- ✅ **v2.2 — Stage 1 Kickoff + Stage 4 Fnspec Split** — Phases 7-8 (shipped 2026-05-11) · archive: [`milestones/v2.2-ROADMAP.md`](./milestones/v2.2-ROADMAP.md)
- 📋 **v2.3-v2.6 — Stages 5/6/7/8/9/10 build + test-bot + native-AI paste + sign-off + archive** — sequenced per CHANGELIST.md CHANGE-01

## Phases

<details>
<summary>✅ v2.0 Implementor Edition (Phases 1-4) — DESIGN-COMPLETE 2026-05-10</summary>

Phase numbering uses integer phases (1-4) for planned milestone work; decimal phases reserved for urgent insertions only — none used.

- [x] **Phase 1: Audit** — `.planning/AUDIT.md` ✓ APPROVED 2026-05-09 (9/9 plans)
- [x] **Phase 2: Design** — `.planning/DESIGN.md` ✓ APPROVED 2026-05-10 (10/10 plans)
- [x] **Phase 3: Change list** — `.planning/CHANGELIST.md` ✓ APPROVED 2026-05-10 (7/7 plans)
- [x] **Phase 4: Open questions register** — `.planning/OPEN-QUESTIONS.md` ✓ APPROVED 2026-05-10 (5/5 plans)

**Deliverables (locked):** AUDIT.md (50 requirements catalogued — 8 AUDIT + 30 DESIGN + 5 CHANGE + 7 OPEN), DESIGN.md (v2 architecture: cross-cutting structure + 13-skill inventory + 3 platform skills + every stage skill + test bot architecture), CHANGELIST.md (sequenced v0.3.0 → v2 delta as v2.1+ build plan + per-skill NEW/MODIFIED/RETIRED + cosmetic-fix list + research-blocked flags + migration cutover rules), OPEN-QUESTIONS.md (register of all deferred questions with owners + target phases).

**v2.0 milestone artefacts archived to `.planning/milestones/v2.0-phases/`** on 2026-05-11 at v2.2 kickoff (deferred archive of design-only milestone that was never CLI-closed via `/gsd-complete-milestone v2.0`).

</details>

<details>
<summary>✅ v2.1 Foundations + Platform Skills (Phases 5-6) — SHIPPED 2026-05-11</summary>

Phase numbering CONTINUES from v2.0. Two phases bundled per CHANGELIST CHANGE-01. Phase 5 landed BEFORE Phase 6 (intra-milestone ordering — Phase 6 platform skills point at Phase 5 canonical references).

- [x] **Phase 5: Foundations + Connector Verification** — 5/5 plans complete · FOUND-01..FOUND-13 satisfied (2026-05-10)
- [x] **Phase 6: Internalise Platform Skills** — 4/4 plans complete · PLAT-01..PLAT-06 satisfied (2026-05-11)

**Delivered:**
- Plugin-level canonical references at `dydx-delivery/references/{safety-rules,stage-numbering,frontmatter-scheme,glossary,connector-matrix}.md`
- 7 v0.3.0 stage skills repointed to canonical references (duplicates collapsed; sandbox-block bug fixed; `based_on_*` normalised)
- Plugin manifest 2.0.0 synced; LICENSE in place; commands/agents/hooks scaffold dirs created
- 3 platform reference skills (`platform-pipefy`, `platform-wrike`, `platform-ziflow`) with 5-file references/ shape
- `paginate_all` helper (Pipefy); OAuth-host persistence pattern (Wrike); `wait_for_proof` fallback (Ziflow); webhook-PRIMARY framing (Ziflow)
- `tier_claims_last_verified: 2026-05-09` baseline; `native_ai_path: paste|none` enum locked (T-06-02 zero `api` assignments)
- 5 cosmetic CONCERNS fixes; B.5 owner-email INTENTIONAL per UAT-3.1
- 3 throttle/consistency OPEN-Q rows flipped to `decided` (Q05 Ziflow / Q06.2 Pipefy / Q07.2 Wrike)

**Audit:** [`v2.1-MILESTONE-AUDIT.md`](./milestones/v2.1-MILESTONE-AUDIT.md) — status `tech_debt` (no blockers; 2 non-blocking follow-ups: REQUIREMENTS.md checkbox flip done at close + TD-2 stage-skill `platform:` enum reconciliation deferred to v2.2).

**Phase archives:** `.planning/milestones/v2.1-phases/05-foundations/` + `.planning/milestones/v2.1-phases/06-internalise-platform-skills/`.

</details>

<details>
<summary>✅ v2.2 Stage 1 Kickoff + Stage 4 Fnspec Split (Phases 7-8) — SHIPPED 2026-05-11</summary>

Phase numbering CONTINUES from v2.1 — no `--reset-phase-numbers`. Two phases bundled per CHANGELIST.md CHANGE-01 Phase 3 (v2.2). Phase 7 lands BEFORE Phase 8 (intra-milestone ordering — Phase 8 reads approved discovery + approved SOW produced by Phase 7's MODIFIED upstream stages).

- [x] **Phase 7: Stage 1 Kickoff + Discovery/SOW upstream wiring** — 4/4 plans complete · STG1-01..05 / STG2-01..03 / STG3-01..02 (10 reqs) satisfied (2026-05-11)
- [x] **Phase 8: Stage 4 Fnspec Split + ROUTE (incl. TD-2 inline)** — 3/3 plans complete · STG4-01..06 / ROUTE-01..05 (11 reqs) satisfied (2026-05-11)

**Delivered:**
- `kickoff-capture/` Stage 1 skill NEW (SKILL.md + 3 references/ files); `01_kickoff_v<N>.md` with single-field `kickoff_branch: discovery-ready | draft-sow` routing
- `discovery-intake/` MODIFIED — consumes kickoff as sole upstream; raw-notes entry path RETIRED; verbatim skip-emit on `draft-sow` branch
- `generate-sow/` MODIFIED — canonical 4-state lifecycle `draft → client_review → approved → archived`; single-SOW dual-scope H2 split (Platform + Integration sections per D-75)
- `generate-fnspec-platform/` (Stage 4a, NEW) + `generate-fnspec-integration/` (Stage 4b, NEW) with `delivery: native-ai | api` routing key on every requirement row (canonical enum order locked)
- Cross-spec consistency check OWNED by Stage 4b; halt-on-failure runs FIRST; failure emits dedicated `04b_consistency_check_v<N>.md`
- Stage 5 scope-gate forward-compat per DESIGN-21 (3 branches resolve from 4a/4b frontmatter alone in v2.2; actual Stage 5 consumption ships v2.3)
- v0.3.0 `generate-functional-spec/` RETIRED; legacy `_v*.md` artefacts remain readable per DESIGN-08 lenient mode
- TD-2 closed inline as D-78 path-(a) — `ziflow` ADDED to stage-skill `platform:` 4-enum (`pipefy | wrike | ziflow | other`) across 10 files / 11 lines
- 3 fixture-output artefacts for ROUTE-05 forward-compat smoke; `phase8-structure-check.sh --all` PASS exit 0 (32/32 PASS)
- 3 hygiene TD items (TD-v2.2-01..03) closed inline pre-archive in commit `e9c69cf`

**Audit:** [`v2.2-MILESTONE-AUDIT.md`](./milestones/v2.2-MILESTONE-AUDIT.md) — final verdict `passed` (was `tech_debt` at audit time; all 3 hygiene items closed inline pre-archive).

**Phase archives:** `.planning/milestones/v2.2-phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/` + `.planning/milestones/v2.2-phases/08-stage-4-fnspec-split-route/`.

</details>

### 📋 v2.3-v2.6 (planned — sequenced per CHANGELIST.md CHANGE-01)

Phase numbering CONTINUES from v2.2 (Phase 9+). Milestones scoped at `/gsd-new-milestone` time.

- **v2.3** — Stage 5 Tech Spec + Stage 6 Cost + Stage 7a/7b Build Prompts (STG5-01 / STG6-01..02 / STG7-01..02)
- **v2.4** — Stage 8 Test Bot Rebuild (STG8-01..04 — provision-test-harness 8a / generate-test-plan 8b MODIFIED / generate-uat-plan 8c NEW / execute-tests 8d MODIFIED / test-bot-orchestrator agent + `client_state.yaml` + drift detection)
- **v2.5** — Stage 9 Documentation Publishing (STG9-01..02) + Stage 10 Native-AI Upload Bundle paste-only (STG10-01..03)
- **v2.6** — Stage 11 Sign-off + Coda Mirror (STG11-01..03) + Plugin Surfaces (SURF-01..03: commands/refine.md parameterised + 4 GSD-prefixed shortcuts + frontmatter / version-bump / approval-gate hooks + optional `mcpServers` + optional plugin self-tests)

## Progress

| Phase | Milestone | Plans Complete | Status | Completed |
|-------|-----------|----------------|--------|-----------|
| 1. Audit | v2.0 | 9/9 | Complete ✓ APPROVED | 2026-05-09 |
| 2. Design | v2.0 | 10/10 | Complete ✓ APPROVED | 2026-05-10 |
| 3. Change list | v2.0 | 7/7 | Complete ✓ APPROVED | 2026-05-10 |
| 4. Open questions register | v2.0 | 5/5 | Complete ✓ APPROVED | 2026-05-10 |
| 5. Foundations + Connector Verification | v2.1 | 5/5 | Complete ✓ SHIPPED | 2026-05-10 |
| 6. Internalise Platform Skills | v2.1 | 4/4 | Complete ✓ SHIPPED | 2026-05-11 |
| 7. Stage 1 Kickoff + Discovery/SOW upstream wiring | v2.2 | 4/4 | Complete ✓ SHIPPED | 2026-05-11 |
| 8. Stage 4 Fnspec Split + ROUTE | v2.2 | 3/3 | Complete ✓ SHIPPED | 2026-05-11 |

---

*Roadmap created: 2026-05-09 (v2.0 Implementor Edition design-only)*
*v2.1 milestone shipped 2026-05-11 — Phase 5 + Phase 6 collapsed into archive; full detail at [`milestones/v2.1-ROADMAP.md`](./milestones/v2.1-ROADMAP.md)*
*v2.2 milestone shipped 2026-05-11 — Phase 7 + Phase 8 collapsed into archive; full detail at [`milestones/v2.2-ROADMAP.md`](./milestones/v2.2-ROADMAP.md)*
*Last updated: 2026-05-11 after v2.2 milestone close*
