# Project Retrospective

*A living document updated after each milestone. Lessons feed forward into future planning.*

## Milestone: v2.2 — Stage 1 Kickoff + Stage 4 Fnspec Split

**Shipped:** 2026-05-11
**Phases:** 2 (Phase 7 Stage 1 Kickoff + Discovery/SOW upstream wiring; Phase 8 Stage 4 Fnspec Split + ROUTE) | **Plans:** 7 (4 + 3) | **Sessions:** single-day execution 2026-05-11 (~8.5h)

### What Was Built

- `kickoff-capture/` (Stage 1, NEW) — SKILL.md + 3 references/ files (kickoff-template.md / auto-classify-rubric.md / capture-paths.md); 3 capture paths (meeting-notes paste / Miro paste fallback / Field Notes Coda read with `processed_at IS NULL` triage default); single-field `kickoff_branch: discovery-ready | draft-sow` routing carries to Stage 2 + Stage 3
- `generate-fnspec-platform/` (Stage 4a, NEW) + `generate-fnspec-integration/` (Stage 4b, NEW) — both with SKILL.md + 3 references/ files; v0.3.0 `generate-functional-spec/` RETIRED; `delivery: native-ai | api` canonical routing key on every requirement row; cross-spec consistency check OWNED by 4b with halt-on-failure before fnspec write
- `discovery-intake/` MODIFIED — consumes kickoff as sole upstream; raw-notes path RETIRED; verbatim skip-emit on `draft-sow` branch
- `generate-sow/` MODIFIED — canonical 4-state lifecycle `draft → client_review → approved → archived`; single-SOW dual-scope H2 split (Platform + Integration sections per D-75)
- TD-2 from v2.1 closed inline as D-78 path-(a) — `ziflow` ADDED to stage-skill `platform:` 4-enum across 10 files / 11 lines
- Stage 5 scope-gate forward-compat (3 branches resolve from 4a/4b frontmatter alone); 3 fixture-output artefacts prove ROUTE-05 smoke
- 2 per-phase structure-check harnesses (phase7 with `--section <kickoff|discovery|sow|all>` dispatch; phase8 with 5 section runners P/I/E/S/X + 4 cross-cutting X assertions + locked-literal grep on E2)

### What Worked

- **Phase 7 bundled STG1 + STG2 + STG3 (10 reqs) in one phase.** STG2/STG3 are downstream consumers of the kickoff artefact contract — landing them with STG1 in the same phase meant the pipeline lit up end-to-end through Stage 3 for both routing branches before Phase 8 started. E2e smoke fixtures green at Phase 7 close gave Phase 8 a working upstream to read from.
- **Phase 8 strict W1→W2→W3 sequence per D-80.** 4b reads 4a; closeout reads both. No parallel temptation that would have introduced read-before-write hazards. Wave gating was clean.
- **Wave 0 self-verification scaffold extended.** Phase 7 plan 07-01 built `phase7-structure-check.sh` with `--section` dispatch in the first plan; Phase 8 plan 08-01 didn't quite carry the same pattern but Phase 8's structure-check arrived in 08-03 with the 5-section runner shape. Per-section gating let intermediate plans verify their slice without waiting for the full tree.
- **TD-2 closed INLINE rather than as a separate phase.** Routing-key contract was already in scope for Phase 8 (DESIGN-20); folding the enum reconciliation into 08-03 cross-cutting closeout avoided a phase-scaffold overhead and kept the decision close to the consumer code.
- **08-03 `autonomous: false` with mid-execution checkpoint.** Cross-cutting closeout edits 10 disjoint files + retires a directory + lands fixture artefacts — too many concurrent surfaces for unattended execution. Orchestrator paused at checkpoint; reviewer approved; T-gate ran cleanly post-approval. Pattern reuse candidate for any phase with >5 file-surfaces and decision points worth gating.
- **Cross-AI review convergence loop applied at plan time.** Phase 7 absorbed C1-C8 into replan (5a5fcb1). Phase 8 plan-checker iter-1 found 1 BLOCKER + 2 WARNINGS in 08-03; planner revised; plan-checker iter-2 PASS. The BLOCKER/WARNING/NOTE severity classification stayed crisp — no debates about whether a NOTE was a BLOCKER.
- **Pre-archive hygiene-fix path.** User chose "Address TD inline first" at `/gsd-complete-milestone v2.2` pre-flight; all 3 audit-flagged hygiene items (`platform:` frontmatter missing on kickoff / ASCII pipeline naming retired skill / "Seven skills" stale manifest prose) closed in a single atomic commit (`e9c69cf`) — total ~5 line edits. Audit verdict flipped tech_debt → passed before archive. Faster + cleaner than full closure-phase ceremony for items of this size.

### What Was Inefficient

- **`kickoff-capture` missing `platform:` frontmatter wasn't caught at plan time (INT-v2.2-01).** Producer ↔ consumer contract drift: `discovery-intake/SKILL.md:40-42` documented reading `platform:` from kickoff frontmatter, but kickoff-capture's template + SKILL.md never declared it. Phase 7 fixtures supplied `platform:` from body content during downstream invocation so the pipeline worked end-to-end (8 hidden hours of latent drift). Phase 8 ROUTE-04 D-78 4-enum rollout had 10 files in EDIT scope but `kickoff-capture/` wasn't one of them. **Lesson for v2.3:** when a downstream skill's SKILL.md documents reading a field from upstream frontmatter, the planner or plan-checker should verify the producer skill actually declares that field in its template. Add a structure-check assertion that greps for every documented upstream-read field against the producer skill's template — would have caught this in Phase 7.
- **Nyquist VALIDATION.md flag drift on both phases.** Phase 7 VALIDATION.md has `nyquist_compliant: false` + `wave_0_complete: false` in frontmatter despite structure-check harness running exit 0 with 15/15 PASS. Phase 8 VALIDATION.md has no YAML frontmatter at all (defaults to PARTIAL under the classification matrix). The actual coverage is green; the flag is the issue. **Lesson for v2.3:** at the end of each phase's last plan, the synthesis task should set `nyquist_compliant: true` in VALIDATION.md frontmatter if the structure-check harness ran clean. Or: the verifier should auto-flip the flag at PASS verdict.
- **REQUIREMENTS.md trace table flip timing.** All 21 v2.2 rows ended up `Satisfied` correctly by phase-close synthesis plans (07-04 for Phase 7's 10 rows; 08-03's T-flips for Phase 8's 11 rows) — so the v2.1 lesson "wire phase execution to auto-flip" was effectively applied. But the flip happened in a single big synthesis task at the end, not row-by-row as each plan landed. **Lesson for v2.3:** consider per-plan REQUIREMENTS.md row flips (each plan's synthesis flips its own rows) rather than one phase-end flip — avoids the big-bang task that could miss a row if the phase synthesis hits time pressure.
- **plugin.json + marketplace.json description drift.** Both manifests had stale "Seven skills" prose post-v2.1 (10 skills) AND post-v2.2 (12 skills). The v2.1 milestone close didn't refresh the description; v2.2 milestone close did refresh both (TD-v2.2-03 closure scope extended to marketplace.json parity). **Lesson for v2.3:** add manifest-description-currency check to milestone-audit (grep manifest description against actual skill count; flag mismatch).

### Patterns Established

- **Forward-compat smoke check via fixture-output artefacts (ROUTE-05).** When a milestone emits a tag that downstream stages will consume in future milestones, prove the tag survives through `based_on_*` chains by producing fixture artefacts in the current milestone (no live downstream skill invocation needed). Reusable for any forward-compat interface emission.
- **Halt-on-failure consistency check OWNED by one side (D-84 + ROUTE-01/02).** Single-owner avoids multi-write race; halt-first runs before any write; failure emits a dedicated artefact (`*_consistency_check_v<N>.md`) for human triage. Pattern reuse candidate for any cross-spec / cross-stage consistency contract.
- **Either-spec-skip with verbatim em-dash skip-emit (D-85).** When two parallel artefacts are independently optional (4a / 4b), the skip side emits a verbatim hand-off string (not silent absence) so downstream stages can detect skip vs missing-file. Reusable for any optional-stage topology.
- **Phase-local consistency check + Wave 3 cross-cutting closeout.** Phase 7 used 07-04 synthesis for cross-cutting work (R-02 glossary + fixtures + e2e smoke + REQUIREMENTS flip). Phase 8 used 08-03 closeout (RETIRE old skill + D-78 rollout + ROUTE-05 smoke + REQUIREMENTS flip). Last-plan-as-synthesis pattern is the right shape for any phase with multi-skill scope that needs cross-cutting reconciliation.
- **`autonomous: false` with mid-execution checkpoint for cross-cutting plans.** When a plan edits >5 disjoint files OR retires a skill OR makes decisions worth reviewer-gating, set `autonomous: false` and design an explicit checkpoint between the file-edit phase and the verification phase.
- **Pre-archive lightweight TD closure path (added to GSD workflow during v2.2 close).** When milestone-audit verdict is `tech_debt` with single-line hygiene items, user can choose between full closure-phase ceremony (discuss/plan/execute) or lightweight inline atomic commit. The latter is appropriate when items are ≤5 line edits total and all individually 1-line scope.

### Key Lessons

1. **Producer ↔ consumer frontmatter contract drift is invisible until it bites.** When a downstream skill's SKILL.md says "I read field X from upstream frontmatter," the planner / plan-checker must verify the producer actually declares X. Add a grep-based structure-check assertion at plan-checker time.
2. **Nyquist flag normalization needs to happen at phase close, not after milestone audit.** VALIDATION.md frontmatter `nyquist_compliant: true` should be set by the synthesis task when the structure-check harness exits 0 — not deferred to a post-audit `/gsd-validate-phase` cleanup pass.
3. **TD inline closure beats full closure-phase ceremony when items are ≤5 line edits.** The `/gsd-complete-milestone` pre-flight should offer this choice automatically when the audit lists items with that scope. (Added to the pre-flight options at this milestone close — codify the option.)
4. **Cross-AI review convergence loop continues to pay off.** Iter-1 → planner revision → iter-2 PASS caught a BLOCKER in 08-03 that would have shipped as a defect otherwise.
5. **`autonomous: false` checkpoints are cheap insurance for cross-cutting plans.** Single mid-execution pause-and-resume on 08-03 prevented an unattended T-gate run on possibly-still-broken state. Worth the latency.

### Cost Observations

- Model mix: predominantly Opus 4.7 (1M context) for orchestration + executor; verifier + integration-checker + audit-milestone all Opus
- Sessions: single calendar day (2026-05-11) with ~3 working sessions inside the day
- Notable: phase-close synthesis tasks (07-04 + 08-03 post-checkpoint) handled their reach without context pressure; the orchestrator did NOT need to delegate to a sub-agent for any of the trace-flip or fixture-write work
- Pre-flight + close conversation itself: ~150 tool calls, modest output (mostly archive/manifest edits + git operations); compact relative to phase-execution turn counts

---

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
| v2.2 | ~3 (single day) | 2 | First full-pipeline milestone (kickoff through Stage 4); established Wave 0 self-verification scaffold reuse + `autonomous: false` mid-execution checkpoint + halt-on-failure consistency check + forward-compat smoke via fixtures + pre-archive lightweight TD closure |

### Cumulative Quality

| Milestone | Requirements | Status | Cross-AI Review Convergence |
|-----------|--------------|--------|-----------------------------|
| v2.0 | 50/50 (8 AUDIT + 30 DESIGN + 5 CHANGE + 7 OPEN) | All approved | Phase 4 used cross-AI review convergence loop |
| v2.1 | 19/19 (13 FOUND + 6 PLAT) | All satisfied + 4/4 threat mitigations + 17/17 structural assertions | Phase 6 used cross-AI review (C1..C9 incorporated into replan) |
| v2.2 | 21/21 (5 STG1 + 3 STG2 + 2 STG3 + 6 STG4 + 5 ROUTE) | All satisfied + 32/32 structural assertions (P/I/E/S/X) + 15/15 phase7 structure-check + audit final verdict `passed` (3 hygiene TDs closed inline) | Phase 7 incorporated C1-C8; Phase 8 plan-checker iter-1 found 1 BLOCKER + 2 WARNINGS, iter-2 PASS |

### Recurring Patterns (v2.1 → v2.2)

- **Per-phase structure-check.sh harness.** v2.1 introduced; v2.2 extended (Phase 7 + Phase 8 both have `--section` dispatch; Phase 8 has 5 section runners P/I/E/S/X + 4 cross-cutting X assertions + locked-literal grep). Pattern locked: every phase with multi-skill scope gets one structure-check with section-partition support.
- **Phase-end synthesis plan for cross-cutting reconciliation.** v2.1: 06-04 OPEN-Q row flip + dedup gate. v2.2: 07-04 R-02 glossary + fixtures + e2e + REQUIREMENTS flip; 08-03 RETIRE + D-78 rollout + ROUTE-05 smoke + REQUIREMENTS flip. Pattern locked: last plan in any multi-skill phase carries cross-cutting load.
- **Cross-AI review convergence at plan time.** v2.1 Phase 6 absorbed C1..C9. v2.2 Phase 7 absorbed C1-C8; Phase 8 used plan-checker iter loop with BLOCKER/WARNING/NOTE severity classification. Pattern locked: every phase plan-phase ends with at least one cross-AI review iter; iter-1 findings drive a revision; iter-2 must PASS.
- **TD carryover resolution path.** v2.1 deferred TD-2; v2.2 closed it inline as part of an adjacent contract (DESIGN-20 routing-key work). v2.2 had 3 TDs from its own audit; all closed pre-archive in a single hygiene commit. Pattern locked: TD carryover is always picked up by the immediately-following milestone if it touches an adjacent contract, OR by the audit-driven inline closure path at milestone close.

---
*Created: 2026-05-11 after v2.1 milestone close*
*Updated: 2026-05-11 after v2.2 milestone close (single-day milestone — v2.1 close + v2.2 close on same calendar date)*
