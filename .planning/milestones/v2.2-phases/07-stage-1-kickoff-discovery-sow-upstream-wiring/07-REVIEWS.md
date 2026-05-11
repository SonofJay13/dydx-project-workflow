---
phase: 7
reviewers: [gemini, codex]
reviewer_models:
  gemini: gemini-2.5-flash (gemini-3-flash-preview + gemini-2.5-pro both rate-limited)
  codex: default
reviewed_at: 2026-05-11
plans_reviewed:
  - 07-01-PLAN.md
  - 07-02-PLAN.md
  - 07-03-PLAN.md
skipped:
  claude: self (running inside Claude Code — independence)
  coderabbit: not installed
  opencode: not installed
  qwen: not installed
  cursor: not installed
---

# Cross-AI Plan Review — Phase 7

## Gemini Review

Here's my review of the implementation plans for Phase 7:

### Overall Phase 7 Review

**Summary:** Phase 7 presents a robust and meticulously planned approach to introducing the new `kickoff-capture` skill and integrating it seamlessly with the modified `discovery-intake` and `generate-sow` skills. The phase is characterized by a strong emphasis on verbatim string fidelity, clear contract establishment between components, and a comprehensive validation strategy employing a custom, partitioned structure-check script and a manual end-to-end smoke test. The plan effectively addresses identified risks and adheres strictly to out-of-scope guardrails, setting a solid foundation for subsequent development.

**Strengths:**
- **Atomic and Parallel Execution:** The slicing into three atomic plans (07-01, 07-02, 07-03) with clear dependencies (07-02/07-03 depend on 07-01) and identified parallel eligibility (07-02 and 07-03) is highly efficient and well-structured.
- **Centralized Validation Script:** Shipping the `phase7-structure-check.sh` in the first plan and using its partitioned `--section` mode for incremental validation is an excellent practice, enabling early and continuous feedback.
- **Strong Verbatim String Contracts:** The plans consistently identify critical verbatim strings and ensure they are asserted with `grep -qF`, mitigating risks of subtle variations. This includes correct handling of unicode characters and specific error messages.
- **Proactive Risk Mitigation:** Identified risks like R-01 (skip-message conflict), R-02 (glossary drift), and R-05 (handoff cleanup) are explicitly addressed and resolved within the respective plans, preventing them from propagating.
- **Adherence to Out-of-Scope Definitions:** The plans meticulously respect all project-level and milestone-level out-of-scope items, particularly regarding MCP integrations, API ingestion, and auto-progression, demonstrating strong guardrails.
- **Comprehensive E2e Testing Strategy:** The inclusion of sample CR fixtures and a detailed manual e2e smoke test provides essential functional validation, complementing the structural checks.
- **Accurate Documentation Updates:** The plan ensures `REQUIREMENTS.md` traceability is updated and glossary inconsistencies are resolved, maintaining high-quality project documentation.

**Concerns:**
- **Reliance on Manual Review for `capture-paths.md` content (LOW):** While its existence is checked (K2), the content sufficiency of `capture-paths.md` (STG1-05) still relies on manual review. This is acknowledged in `07-VALIDATION.md` but is a slight gap in automated coverage for a "protocol" document. This is acceptable given the descriptive nature of the content.
- **Output Path Consistency (LOW):** The `07-RESEARCH.md` assumption A3 flags a potential inconsistency between `DESIGN-17` (`<Client> Brain/<Project>/`) and v0.3.0 SKILL.md paths (`<Client>/build-specs/<platform>/`) but notes it's "out-of-scope per STG2-03 body-unchanged". While technically correct that STG2-03 prevents changing *discovery-intake's* path, a comprehensive solution might involve harmonizing output paths across all v2 artefacts later. For Phase 7, this is correctly noted as deferred.

**Suggestions:**
- **Future Output Path Harmonization (Deferred):** Recommend prioritizing the "path harmonisation pass" (A3 in `07-RESEARCH.md`) for a future milestone (v2.6 / SURF-01..03 candidate) to ensure all v2 artefacts consistently use the `<Client> Brain/<Project>/` scheme.

**Overall Phase Risk Assessment (LOW):** Phase 7 is exceptionally well-planned. The clear definition of contracts, meticulous attention to detail, robust validation strategy, and proactive risk mitigation efforts combine to create a low-risk implementation phase.

### Per-Plan Reviews (Gemini)

**07-01-PLAN.md** — Comprehensive coverage of STG1-01..05; clear contract establishment; verbatim string fidelity; structure-check script integration with early-validation pattern; canonical-reference use; robust acceptance criteria. **No concerns. No suggestions.**

**07-02-PLAN.md** — Explicit R-01 resolution (authoritative spelling enforced; DESIGN-18 drift forbidden); strict STG2-03 adherence (intake-template.md no-op verification); clear raw-notes retirement; robust `based_on_kickoff:` enforcement; comprehensive surgical edits keyed to RESEARCH §4 line numbers. **No concerns. No suggestions.**

**07-03-PLAN.md** — Effective synthesis folding under ~400 LOC threshold; robust verbatim string handling (unicode arrows for 4-state lifecycle); direct R-02 and R-05 resolution; comprehensive e2e smoke test with autonomous: false; full phase gate via `--all`; accurate traceability update. **No concerns. No suggestions.**

---

## Codex Review

### Summary

07-01 is mostly strong, but has one blocking verifier flaw: the planned `kickoff_branch:` template line and the K4 grep assertion do not match. As written, an executor can follow the plan literally and still fail `--section kickoff`.

07-02 is the strongest plan. It handles R-01 explicitly, repeats the authoritative skip string, forbids the drift string, and preserves STG2-03 by keeping `intake-template.md` unchanged.

07-03 is useful but overloaded. The synthesis tasks are logical, yet the manual e2e smoke and REQUIREMENTS trace flips should not be allowed to pass before 07-02 has definitely landed. It also has repeated ASCII-arrow lifecycle text that increases drift risk.

Overall, the phase is well-scoped and the per-skill split is sound, but plan quality is currently **MEDIUM risk** because a few literal-string assertions are internally inconsistent.

### Strengths

- Good per-skill slicing: 07-01 establishes the contract, 07-02 and 07-03 consume it in disjoint directories.
- R-01 is handled well in 07-02. The authoritative skip message is repeated, asserted, and the bad DESIGN-18 wording is explicitly forbidden.
- The structure-check approach is pragmatic and fits the repo's existing bash/grep verification pattern.
- Out-of-scope guardrails are mostly respected: no MCP implementation, no auto-progression hook, no legacy migration, no native-AI ingestion.
- 07-02's `intake-template.md` no-op verification is a good guard against accidental STG2-03 drift.

### Concerns

- **HIGH — 07-01 K4 assertion is wrong for the planned template.**
  The script asserts `^kickoff_branch: (discovery-ready|draft-sow)$`, which only matches `kickoff_branch: discovery-ready` or `kickoff_branch: draft-sow`. It will not match `kickoff_branch: <discovery-ready | draft-sow>` or `kickoff_branch: discovery-ready | draft-sow`. The plan text incorrectly says the pipe-list satisfies the alternation.

- **HIGH — 07-03 may run full `--all` before 07-02 has completed in parallel.**
  07-03 depends only on 07-01, but its T7 requires D1-D3 from 07-02. In Wave 2 parallel execution, 07-03's final gate has an undeclared dependency on 07-02 completion.

- **MEDIUM — lifecycle string is quoted inconsistently.**
  07-03 repeatedly writes `draft -> client_review -> approved -> archived` while the verifier requires `draft → client_review → approved → archived`. The plan warns executors, but literal-following executors can still paste ASCII arrows into prose. The acceptance criteria catch it, but avoidable churn.

- **MEDIUM — 07-03's manual e2e smoke is under-specified for an actual skill runner.**
  It says "invoke skill" and "expected path", but does not define the exact command, workspace path, or whether artefacts should be written under fixtures, a test brain, or a real `<Client> Brain/<Project>/`. That makes the checkpoint subjective.

- **MEDIUM — REQUIREMENTS trace flips are premature if manual smoke is weak.**
  T6 flips all 10 Phase 7 requirements after T5, but T5 relies on human attestation without a concrete artefact checklist/path. This can create a false "Satisfied" state.

- **LOW — 07-01 creates cross-section assertions that knowingly fail until later plans.**
  This is acceptable because T6 runs only `--section kickoff`, but the plan should state clearly that `--all` is forbidden in 07-01 except as an expected-failure diagnostic.

- **LOW — DESIGN.md glossary edit is defensible but touches a locked design artefact.**
  R-02 is real, but editing `.planning/DESIGN.md` during implementation should be labelled as "glossary correction only, no design contract change" in 07-03.

### Suggestions

- Fix 07-01 T1/T3 K4 immediately. Either:
  - make the template line concrete, e.g. `kickoff_branch: discovery-ready`, and document the enum in comments/body; or
  - change K4 to assert the template enum form, e.g. `^kickoff_branch: <discovery-ready \| draft-sow>$`, plus separate greps for both values.
  Do not leave the current regex.

- Add a 07-03 dependency note: T7 and T6 require 07-02 completed. Better: split final synthesis into `07-04-PLAN.md` depending on `[07-02, 07-03]`, or make 07-03 depend on 07-02 if it owns the phase gate.

- Replace every ASCII lifecycle example in 07-03 with the exact Unicode string:
  `draft → client_review → approved → archived`
  Keep no `->` version except where explicitly saying "do not use ASCII arrows".

- Strengthen T5 manual smoke acceptance:
  - require recording the exact generated artefact paths;
  - require frontmatter snippets for `kickoff_branch`, `based_on_kickoff`, and `based_on_discovery`;
  - require confirming zero `02_discovery_v*` file for the draft-sow fixture;
  - require storing the smoke notes in `07-03-SUMMARY.md`.

- In 07-02 T2, tighten the raw-notes acceptance criterion. "`pasted meeting notes` returns false in Inputs / Steps context" is hard to grep by context. Use explicit forbidden checks against headings or require the only occurrence to be in "What this skill does not do".

- In 07-03 T6, flip requirements only after T7 passes, not before. Current order flips traceability before the full structural gate.

### Risk Assessment

Overall phase risk: **MEDIUM**.

The architecture is sensible and the main R-01 string conflict is well controlled. The main risk is not scope creep; it is verifier drift and phase-gate ordering. Fix K4, make the final synthesis depend on both Wave 2 plans, and remove ASCII-arrow ambiguity. After those changes, this drops to **LOW-MEDIUM**.

---

## Consensus Summary

**Reviewer split:** Gemini graded the phase **LOW risk** (no concerns flagged on any plan). Codex graded **MEDIUM risk** and found 2 HIGH-severity blockers + 3 MEDIUM concerns. The split is informative — Codex performed adversarial literal-read analysis (the explicit ask) while Gemini surface-validated the structure.

**Trust the adversarial reviewer.** Codex's HIGH findings are concrete, reproducible, and worth fixing before execution.

### Agreed Strengths (both reviewers)

- Per-skill atomic plan slicing (07-01 contract → 07-02/07-03 consumers) is well-structured.
- R-01 skip-message resolution in 07-02 is rigorous (authoritative spelling enforced, DESIGN-18 drift explicitly forbidden).
- Structure-check script with `--section` partitioning is a pragmatic verification pattern.
- Out-of-scope guardrails are respected (no MCP, no auto-progression, no legacy migration, no native-AI ingestion).
- STG2-03 intake-template.md no-op verification is a good drift guard.
- Verbatim string contracts use `grep -qF` to handle unicode (em-dash, arrows).

### Agreed Concerns (raised by 2+ reviewers)

*(None — Gemini raised no concerns. All concerns below are Codex-only and consensus-of-one. Treat as planner-must-resolve since they are concrete and grep-verifiable.)*

### Critical Action Items (from Codex HIGH findings)

| # | Severity | Issue | Action |
|---|---|---|---|
| C1 | HIGH | 07-01 K4 regex `^kickoff_branch: (discovery-ready\|draft-sow)$` doesn't match the planned template literal `kickoff_branch: <discovery-ready \| draft-sow>` | Fix either (a) make template line concrete (`kickoff_branch: discovery-ready`) + document enum in body, or (b) change K4 to assert the template-enum form + separate grep for each value. Don't leave inconsistent. |
| C2 | HIGH | 07-03 T7 (`--all` gate) and T6 (REQUIREMENTS trace flips) have undeclared dependency on 07-02 completion. In Wave 2 parallel exec, T7 can run before 07-02's D-section assertions are satisfied. | Either: (a) add 07-02 to 07-03's `depends_on` (serializes Wave 2), or (b) split T6+T7 into `07-04-PLAN.md` with `depends_on: [07-02, 07-03]`, or (c) move T6+T7 inside 07-02 (last plan in Wave 2 carries the phase gate). |

### Recommended Action Items (Codex MEDIUM findings)

| # | Severity | Issue | Action |
|---|---|---|---|
| C3 | MEDIUM | 07-03 prose contains ASCII arrows (`->`) alongside the required unicode `→`; literal-reading executors may paste ASCII into the SKILL.md body | Replace every ASCII `->` in 07-03 with the exact unicode string `draft → client_review → approved → archived`, keeping `->` only where explicitly negated. |
| C4 | MEDIUM | 07-03 T5 manual e2e smoke is under-specified — no exact command, workspace path, or artefact-destination convention | Strengthen T5 acceptance: record exact artefact paths, frontmatter snippets for `kickoff_branch` / `based_on_kickoff` / `based_on_discovery`, confirm zero `02_discovery_v*` for draft-sow fixture, store notes in `07-03-SUMMARY.md`. |
| C5 | MEDIUM | 07-03 T6 flips REQUIREMENTS trace before T7 structural gate passes | Reorder: T7 (`--all` exit 0) must precede T6 (trace flips). |

### Optional Refinements (Codex LOW findings)

| # | Severity | Issue | Action |
|---|---|---|---|
| C6 | LOW | 07-01 cross-section asserts X1/X2 knowingly fail until 07-02/07-03 ship | Add explicit note in 07-01 that `--all` is forbidden during 07-01 (expected-failure diagnostic only); only `--section kickoff` is the green gate. |
| C7 | LOW | 07-03 edits `.planning/DESIGN.md` glossary — touches a locked design artefact | Label R-02 edit as "glossary correction only, no design contract change" in 07-03 T3 description. |
| C8 | LOW | 07-02 T2 raw-notes acceptance is context-grep difficult | Tighten to explicit forbidden-heading check or require sole occurrence to be in "What this skill does not do" section. |
| C9 | LOW | Gemini-only — path harmonisation deferred to v2.6 / SURF-01..03 | No action — defer per `07-RESEARCH.md` A3. |

### Divergent Views

- **Risk grade.** Gemini = LOW. Codex = MEDIUM (dropping to LOW-MEDIUM after fixes). Codex's adversarial reading is the actionable signal.
- **07-01 plan quality.** Gemini = no concerns. Codex = HIGH blocker (K4 regex/template mismatch). Defer to Codex — the finding is reproducible by reading 07-01 T1 and T3 side-by-side.
- **07-03 dependency graph.** Gemini accepted as-stated. Codex flagged the missing 07-02 dependency on the phase gate. Codex's finding is structurally correct.

---

## Next Step

Run `/gsd-plan-phase 7 --reviews` to replan incorporating C1..C8 (skip C9 per RESEARCH §A3 deferral). Critical fixes are C1 (K4 regex) and C2 (07-03 phase-gate dependency); the rest are quality-of-life tightening.
