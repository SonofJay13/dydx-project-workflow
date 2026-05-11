# Roadmap: dydx-delivery v2.x — Implementor Edition

## Milestones

- ✅ **v2.0 — Implementor Edition** (design-only) — Phases 1-4 (design-complete 2026-05-10)
- ✅ **v2.1 — Foundations + Platform Skills** — Phases 5-6 (shipped 2026-05-11) · archive: [`milestones/v2.1-ROADMAP.md`](./milestones/v2.1-ROADMAP.md)
- 🟢 **v2.2 — Stage 1 Kickoff + Stage 4 Fnspec Split** (active) — Phases 7-8 (planned 2026-05-11 per CHANGELIST.md CHANGE-01 bundle 2 of N)
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

### 🟢 v2.2 Stage 1 Kickoff + Stage 4 Fnspec Split (active — planned 2026-05-11)

Phase numbering CONTINUES from v2.1 (v2.1 ended at Phase 6; no `--reset-phase-numbers`). Two phases bundled per CHANGELIST.md CHANGE-01 Phase 3 (v2.2). Phase 7 lands BEFORE Phase 8 (intra-milestone ordering — Stage 4a/4b in Phase 8 reads approved discovery + approved SOW produced by Phase 7's MODIFIED upstream stages).

- [ ] **Phase 7: Stage 1 Kickoff + Discovery/SOW upstream wiring** — Stage 1 `kickoff-capture/` NEW + Stage 2 `discovery-intake/` MODIFIED + Stage 3 `generate-sow/` MODIFIED — STG1-01..05 / STG2-01..03 / STG3-01..02 (10 reqs)
- [ ] **Phase 8: Stage 4 Fnspec Split + ROUTE (incl. TD-2 inline)** — Stage 4a `generate-fnspec-platform/` NEW + Stage 4b `generate-fnspec-integration/` NEW + cross-spec consistency check + `delivery:` routing key + Stage 5 scope-gate forward-compat + TD-2 reconciliation — STG4-01..06 / ROUTE-01..05 (11 reqs)

## Phase Details

### Phase 7: Stage 1 Kickoff + Discovery/SOW upstream wiring
**Goal**: A reviewer can run a kickoff-to-SOW pipeline end-to-end against a sample CR — produce an approved kickoff artefact, see the downstream stages route correctly on either `discovery-ready` or `draft-sow` branch, and end with an approved single-scope SOW carrying the canonical 4-state lifecycle.
**Depends on**: Phase 6 (platform skills + canonical references must exist; STG2/STG3 stage-skill repointing carries forward from FOUND-05/06)
**Requirements**: STG1-01, STG1-02, STG1-03, STG1-04, STG1-05, STG2-01, STG2-02, STG2-03, STG3-01, STG3-02
**Success Criteria** (what must be TRUE):
  1. A reviewer can invoke `kickoff-capture` against meeting notes / Miro paste / Field Notes (`processed_at IS NULL` triage default) and receive a `01_kickoff_v<N>.md` artefact carrying a single `kickoff_branch: discovery-ready | draft-sow` enum field, with `[unknown — needs human classification]` markers visible inline wherever auto-classification confidence is low.
  2. When `kickoff_branch: discovery-ready` ships, `discovery-intake` consumes the kickoff (`based_on_kickoff:` MANDATORY in frontmatter) and emits `02_discovery_v<N>.md`; raw-notes entry path returns an explicit RETIRED error rather than silently accepting input.
  3. When `kickoff_branch: draft-sow` ships, `discovery-intake` emits the verbatim hand-off `Stage 2 SKIPPED — kickoff branch = draft-sow` and writes no `02_discovery_v<N>.md` artefact; `generate-sow` then reads the kickoff directly via `based_on_kickoff:`.
  4. `generate-sow` writes `03_sow_v<N>.md` carrying the canonical 4-state lifecycle `draft → client_review → approved → archived` (sole skill retaining `client_review` per DESIGN-08 survey + AUDIT-01.2); single SOW covers BOTH platform AND integration scope (no Stage 3 split — that lives in Stage 4 per DESIGN-20).
  5. Phase 7 structure-check exits 0 — kickoff skill directory + `references/` shape present; canonical-reference pointers at `safety-rules.md` / `stage-numbering.md` / `frontmatter-scheme.md` / `glossary.md` resolve; `based_on_kickoff:` field appears on every test `02_*` artefact; SOW status-lifecycle enum matches the 4-state canonical exactly.
**Plans**: 3 plans
- [ ] 07-01-PLAN.md — NEW kickoff-capture skill (SKILL.md + 3 references/ files) + phase7-structure-check.sh with --section dispatch
- [ ] 07-02-PLAN.md — MODIFIED discovery-intake (consume kickoff, RETIRE raw-notes, verbatim skip-message on draft-sow)
- [ ] 07-03-PLAN.md — MODIFIED generate-sow (4-state lifecycle + dual-scope H2 split) + synthesis (R-02 glossary fix, R-05 cleanup, 3 fixtures, e2e smoke, REQUIREMENTS trace flips, --all gate)

### Phase 8: Stage 4 Fnspec Split + ROUTE (incl. TD-2 inline)
**Goal**: A reviewer can produce a Stage 4a platform fnspec AND a Stage 4b integration fnspec from approved discovery+SOW, see every requirement row carry the `delivery: native-ai | api` routing key, watch the consistency check halt on synthetic conflicts, and confirm the routing key survives forward into a v0.3.0-style smoke read — and the v2.1 TD-2 stage-skill enum vs platform-ziflow routing-claim is resolved with a single documented outcome.
**Depends on**: Phase 7 (Stage 4a reads approved `02_discovery_v*` + approved `03_sow_v*`; Stage 4b reads same plus Stage 4a output). Also depends on Phase 6 (platform skills' `references/native-ai-inventory.md` is the classifier input for `delivery:` row tagging).
**Requirements**: STG4-01, STG4-02, STG4-03, STG4-04, STG4-05, STG4-06, ROUTE-01, ROUTE-02, ROUTE-03, ROUTE-04, ROUTE-05
**Success Criteria** (what must be TRUE):
  1. A reviewer can invoke `generate-fnspec-platform` (Stage 4a) and receive `04a_fnspec-platform_v<N>.md` with every requirement row carrying `delivery: native-ai | api` (canonical enum order, never reversed); HIGH/MEDIUM-confidence rows from the loaded platform skill's `native-ai-inventory.md` suggest `native-ai`, LOW/`[OPEN]` rows default to `api`, and human reviewer overrides per row are preserved on re-run.
  2. A reviewer can invoke `generate-fnspec-integration` (Stage 4b) — the consistency check runs FIRST (before fnspec write); synthetic conflicts (a conflicting `delivery:` tag across 4a/4b, a dangling integration touchpoint ref, an orphan API endpoint) halt the skill and emit `04b_consistency_check_v<N>.md` listing the specific failure rows. On clean checks, `04b_fnspec-integration_v<N>.md` writes successfully.
  3. The v0.3.0 `generate-functional-spec/` skill is RETIRED — directory removed; legacy filename artefacts (`02_functional-spec_v*.md` or `04_functional-spec_v*.md`) still parse via DESIGN-08 lenient-read; templates / READMEs / changelogs reference 4a + 4b in place of `generate-functional-spec`.
  4. All three Stage 5 scope-gate branches resolve cleanly from 4a/4b frontmatter alone (no downstream Stage 5 skill needed in v2.2): (a) full path — 4b exists with `delivery: api` rows; (b) skip-with-addendum — no 4b but 4a carries `## Platform-API Addendum` H2 + `has_platform_api_addendum: true` + `tech_spec_scope: platform-api-addendum-only`; (c) skip-entirely — no 4b AND no `delivery: api` rows anywhere → no addendum, no frontmatter change. Either-spec-skip (4a-only or 4b-only) is independently selectable per project.
  5. TD-2 carryover RESOLVED with a single documented outcome — either (a) `ziflow` added to the stage-skill `platform:` enum across all consuming stage skills + `platform-ziflow/SKILL.md:14` aligned, OR (b) Ziflow documented as integration-only (never primary platform routing key) and `platform-ziflow/SKILL.md:14` updated to drop the routing-key claim. Outcome recorded in DESIGN-20 sub-decision or `dydx-delivery/references/glossary.md` routing-key entry.
  6. Forward-compat smoke check passes — `delivery:` field survives at the canonical position on every requirement row through a `based_on_*` chain read into a synthetic Stage 5 / Stage 6 / Stage 7b / Stage 10 consumer stub; no field stripping, no position drift, no enum reorder.
**Plans**: TBD

## Progress

| Phase | Milestone | Plans Complete | Status | Completed |
|-------|-----------|----------------|--------|-----------|
| 1. Audit | v2.0 | 9/9 | Complete ✓ APPROVED | 2026-05-09 |
| 2. Design | v2.0 | 10/10 | Complete ✓ APPROVED | 2026-05-10 |
| 3. Change list | v2.0 | 7/7 | Complete ✓ APPROVED | 2026-05-10 |
| 4. Open questions register | v2.0 | 5/5 | Complete ✓ APPROVED | 2026-05-10 |
| 5. Foundations + Connector Verification | v2.1 | 5/5 | Complete ✓ SHIPPED | 2026-05-10 |
| 6. Internalise Platform Skills | v2.1 | 4/4 | Complete ✓ SHIPPED | 2026-05-11 |
| 7. Stage 1 Kickoff + Discovery/SOW upstream wiring | v2.2 | 0/3 | Plans authored — ready for `/gsd-execute-phase 7` | — |
| 8. Stage 4 Fnspec Split + ROUTE | v2.2 | 0/TBD | Not started — awaiting Phase 7 completion | — |

---

*Roadmap created: 2026-05-09 (v2.0 Implementor Edition design-only)*
*v2.1 milestone shipped 2026-05-11 — Phase 5 + Phase 6 collapsed into archive; full detail at [`milestones/v2.1-ROADMAP.md`](./milestones/v2.1-ROADMAP.md)*
*v2.2 milestone planned 2026-05-11 — Phases 7-8 mapped against 21 v2.2 reqs (10 + 11; 100% coverage) per CHANGELIST.md Phase 3*
*Last updated: 2026-05-11 after v2.2 roadmap lock*
