# Roadmap: dydx-delivery v2.x — Implementor Edition

## Milestones

- ✅ **v2.0 — Implementor Edition** (design-only) — Phases 1-4 (design-complete 2026-05-10)
- ✅ **v2.1 — Foundations + Platform Skills** — Phases 5-6 (shipped 2026-05-11) · archive: [`milestones/v2.1-ROADMAP.md`](./milestones/v2.1-ROADMAP.md)
- 📋 **v2.2 — Stage 1 Kickoff + Stage 4 Fnspec Split** — Phases 7-? (planned per CHANGELIST.md CHANGE-01 bundle 2 of N)
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

**v2.0 milestone artefacts remain in `.planning/phases/01-audit/` through `.planning/phases/04-open-questions/`** — not retroactively archived via `/gsd-complete-milestone v2.0` (design-only milestone was implicitly accepted when Phase 4 was approved).

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

### 📋 v2.2 Stage 1 Kickoff + Stage 4 Fnspec Split (planned)

Per CHANGELIST.md CHANGE-01 bundle 2 of N. Specific phase breakdown locked when `/gsd-new-milestone` runs.

- [ ] **Phase 7 (tentative):** `stage-1-kickoff` skill — kickoff agenda, RACI, comms cadence, first-week deliverables; feeds discovery-intake
- [ ] **Phase 8 (tentative):** Stage 4 Fnspec split (DESIGN-20) — break `generate-functional-spec` into 4a (platform-agnostic) + 4b (platform-routed) + delivery routing key + cross-spec consistency check
- [ ] **TD-2 carry-forward (inline in Phase 8):** stage-skill `platform:` enum reconciliation with `platform-ziflow` routing claim

## Progress

| Phase | Milestone | Plans Complete | Status | Completed |
|-------|-----------|----------------|--------|-----------|
| 1. Audit | v2.0 | 9/9 | Complete ✓ APPROVED | 2026-05-09 |
| 2. Design | v2.0 | 10/10 | Complete ✓ APPROVED | 2026-05-10 |
| 3. Change list | v2.0 | 7/7 | Complete ✓ APPROVED | 2026-05-10 |
| 4. Open questions register | v2.0 | 5/5 | Complete ✓ APPROVED | 2026-05-10 |
| 5. Foundations + Connector Verification | v2.1 | 5/5 | Complete ✓ SHIPPED | 2026-05-10 |
| 6. Internalise Platform Skills | v2.1 | 4/4 | Complete ✓ SHIPPED | 2026-05-11 |
| 7+. v2.2 phases | v2.2 | TBD | Not started — awaiting `/gsd-new-milestone` | — |

---

*Roadmap created: 2026-05-09 (v2.0 Implementor Edition design-only)*
*v2.1 milestone shipped 2026-05-11 — Phase 5 + Phase 6 collapsed into archive; full detail at [`milestones/v2.1-ROADMAP.md`](./milestones/v2.1-ROADMAP.md)*
*Last updated: 2026-05-11 after v2.1 milestone close*
