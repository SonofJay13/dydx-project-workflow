# Project Retrospective

*A living document updated after each milestone. Lessons feed forward into future planning.*

## Milestone: v2.1 — Foundations + Platform Skills

**Shipped:** 2026-05-11
**Phases:** 2 (Phase 5 Foundations + Phase 6 Platform Skills) | **Plans:** 9 | **Sessions:** ~6 working sessions across 2026-05-10..2026-05-11

### What Was Built

- 5 plugin-level canonical references (`safety-rules.md`, `stage-numbering.md`, `frontmatter-scheme.md`, `glossary.md`, `connector-matrix.md`) as the single source of truth that every stage skill now points at
- 3 platform reference skills (`platform-pipefy`, `platform-wrike`, `platform-ziflow`) each with the locked 5-file `references/` shape (api-contract / native-ai-inventory / knowledge-ingestion / client-shape-gotchas / vocabulary)
- 7 v0.3.0 stage skills repointed to canonical refs (4 hard-rules duplicates collapsed; sandbox-block bug fixed; `based_on_*` field normalised)
- Plugin shipped at v2.0.0 — manifest sync, LICENSE in place, scaffold dirs, file renumbering applied
- Connector probe + graceful-degradation matrix (6 connectors × 11 stages) with 8 OPEN-Q resolutions inline
- Three throttle/consistency OPEN-Qs resolved (Q05 Ziflow webhook-PRIMARY; Q06.2 Pipefy 13 req/sec; Q07.2 Wrike 320 req/min)

### What Worked

- **Per-platform atomic slicing (D-63).** Treating each platform's whole skill tree (SKILL.md + 5 references/) as one atomic plan made reviewer-grading per platform clean. Plans 06-01/02/03 each shipped a complete platform in a single review unit.
- **Wave 0 scaffold built into the first plan.** 06-01 carried both the Pipefy skill AND the phase-wide `phase6-structure-check.sh` with the `--section <pipefy|wrike|ziflow>` partition flag. That let Wave 2 plans (06-02 + 06-03) self-verify in parallel against their own platform's assertions before all 3 platforms even existed on disk.
- **Parallel execution where directories were disjoint.** Wave 2 (06-02 Wrike + 06-03 Ziflow) ran in parallel because `platform-wrike/` and `platform-ziflow/` are strictly disjoint directories. Wall time roughly halved versus sequential execution.
- **Single-owner write for OPEN-QUESTIONS row flips (D-67).** Putting all 3 OPEN-Q row flips in a dedicated synthesis plan (06-04) avoided inter-plan file-ownership conflict — same precedent as Phase 5's D-57 OPEN-QUESTIONS handling.
- **Goal-backward verification.** Both Phase 5 and Phase 6 used the gsd-verifier with independent grep checks (not trusting plan SUMMARYs as truth). Caught zero false-positives, surfaced TD-1 (REQUIREMENTS.md checkbox flip lag) and TD-2 (stage-skill enum vs platform-ziflow routing claim) as non-blocking warnings.

### What Was Inefficient

- **REQUIREMENTS.md checkbox flip lag.** All 13 FOUND-XX rows stayed `Pending` in the traceability table even after Phase 5 VERIFICATION.md confirmed them all SATISFIED. The milestone audit had to surface this as TD-1 and the milestone-close step had to flip the checkboxes inline. The pattern: VERIFICATION.md is the source of truth, but the REQUIREMENTS.md table is a manual reflection. Phase 5's recommended-next-step #2 explicitly called this out and it still wasn't done until close. **Lesson for v2.2:** add a final task at the end of each phase's last plan that flips the corresponding REQUIREMENTS.md rows, or extend the gsd-verifier to auto-flip them when status PASSes.
- **MILESTONES.md auto-extracted accomplishments arrived as noise.** The `gsd-sdk query milestone.complete` CLI extracted accomplishments from SUMMARY.md files but produced fragments like `One-liner:` × 13, `Row`, `Subsection` — extraction selector was probably matching headings rather than content. Had to rewrite the accomplishments list by hand. **Lesson for v2.2:** when the CLI auto-extract produces noise, fix the SUMMARY.md template to put the one-liner on the same line as the heading (so the regex doesn't capture the heading without a value).
- **Documentation-asymmetric routing (TD-2) wasn't caught at planning time.** `platform-ziflow/SKILL.md:14` claims `platform: ziflow` is the routing key, but the 6 stage skills only enumerate `platform: <pipefy | wrike | other>`. This would have shown up cheaper if the planner cross-referenced platform-skill claims against stage-skill enums at plan time, or if cross-AI review prompts included "verify that any new routing key declared in this plan is consumed by at least one downstream caller". Defer to v2.2 Stage 4 Fnspec split where stage-skill routing is already in scope.
- **v2.0 milestone was never CLI-closed.** Phases 1-4 were all approved 2026-05-10 ("MILESTONE v2.0 DESIGN-COMPLETE") but `/gsd-complete-milestone v2.0` was never run. Result: stale UAT-gap + verification-gap markers from Phase 02 surfaced in the v2.1 audit-open scan and had to be acknowledged as deferred. **Lesson:** when a design-only milestone reaches its approval gate, run `/gsd-complete-milestone` even though no code shipped — it freezes the artefacts and clears the deferred-item scan for the next milestone.

### Patterns Established

- **Per-platform atomic plan slicing for platform-skill phases (D-63).** Establishes the pattern for future platform additions: ship the whole platform (SKILL.md + 5 references/) in one plan with reviewer-grading scoped to that platform.
- **Per-phase structure-check.sh with `--section` flag for parallel Wave 2 plans.** Wave 0 scaffolding builds the verification harness into the first plan so later parallel plans can self-verify per-section without waiting for the full tree to exist.
- **7-part helper contract structure (D-64).** Every cross-platform helper (`paginate_all`, `wait_for_proof`, OAuth-host) uses the 7-part contract: signature + behaviour + retry budget + failure modes + return shape + pseudocode + worked example. Locks reviewer expectations; reusable for future platform helpers.
- **Tightened YAML-field-assignment grep gates (REVIEWS C3).** Threat-mitigation grep gates regex against the literal field-assignment shape (`native_ai_path: api`), not loose prose mentions. Allows worked examples + URL refs to forbidden values while blocking the actual breakage. Reusable for future "no `X:` field in `Y/` tree" gates.
- **awk-between-headings extraction for OPEN-Q row verification (REVIEWS C8).** Replaces brittle `grep -A N` shape that breaks when resolution bullets push the `Status:` line beyond N lines. Reusable for any markdown row-flip verification.
- **`tier_claims_last_verified:` per-platform frontmatter date (MOD-7 / D-68).** Per-platform re-verification trigger date; tier claims rot fast (Ziflow's ReviewAI especially) and the date gives a concrete signal to re-check.
- **Vocabulary dedup gate (D-66).** Project-wide glossary terms live ONLY in `glossary.md`; platform-specific vocabularies must not redefine them. Grep gate enforces.
- **Webhook-PRIMARY framing where vendors recommend it (Q05).** Don't default to polling just because it's easier; document webhook-PRIMARY when the vendor explicitly recommends it, with polling as fallback.

### Key Lessons

1. **VERIFICATION.md is the source of truth; REQUIREMENTS.md trace table is a downstream reflection.** Wire phase execution to auto-flip the trace table at phase close OR run audit-milestone before each milestone close to surface drift. Manual flips lag.
2. **Run `/gsd-complete-milestone` even on design-only milestones.** The CLI is what clears deferred-item scans for the next milestone. Skipping it because "nothing shipped to production" leaves stale state in the audit pipeline.
3. **Cross-AI review at plan time should verify downstream consumers, not just upstream contracts.** TD-2 (stage-skill enum vs platform-ziflow routing claim) would have been caught by asking "for every new routing key this plan declares, is there a downstream consumer that maps it?".
4. **Per-platform atomic plans + Wave 0 self-verification scaffold + disjoint-directory parallelism is the right recipe for "ship N similar things" phases.** Reuse this shape for v2.2 Stage 4 Fnspec split if both 4a + 4b ship in the same phase.
5. **Threat-mitigation grep regex should target field-assignment shape, not prose.** Tighten the regex up front; otherwise worked examples and URL refs trigger false-positive blocks and force last-minute rewrites.

### Cost Observations

- Model mix: predominantly Opus 4.7 (1M context) for orchestration + executor; verifier + integration-checker also Opus
- Sessions: ~6 working sessions across 2 calendar days (2026-05-10 + 2026-05-11)
- Notable: parallel Wave 2 execution of Wrike + Ziflow plans cut wall-time roughly in half versus sequential; subagent context budgets stayed in healthy range (~120k each, no SSE timeouts despite the wave heartbeats being in place)

---

## Cross-Milestone Trends

### Process Evolution

| Milestone | Sessions | Phases | Key Change |
|-----------|----------|--------|------------|
| v2.0 (design-only) | ~10 | 4 | Established GSD planning shape for this project; audit + design + changelist + open-questions register as 4 deliverable-shaped phases |
| v2.1 | ~6 | 2 | First build milestone; established per-platform atomic plan slicing + Wave 0 self-verification scaffold + disjoint-directory parallel execution pattern |

### Cumulative Quality

| Milestone | Requirements | Status | Cross-AI Review Convergence |
|-----------|--------------|--------|-----------------------------|
| v2.0 | 50/50 (8 AUDIT + 30 DESIGN + 5 CHANGE + 7 OPEN) | All approved | Phase 4 used cross-AI review convergence loop |
| v2.1 | 19/19 (13 FOUND + 6 PLAT) | All satisfied + 4/4 threat mitigations + 17/17 structural assertions | Phase 6 used cross-AI review (C1..C9 incorporated into replan) |

---
*Created: 2026-05-11 after v2.1 milestone close*
