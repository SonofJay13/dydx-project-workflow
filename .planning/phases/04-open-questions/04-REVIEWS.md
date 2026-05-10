# Phase 4: Open questions register — Cross-AI Plan Review

**Date:** 2026-05-10
**Reviewers:** gemini (Google) + codex (OpenAI Codex CLI)
**Self CLI skipped:** claude (this session)
**Phase:** 4 (Open questions register)
**Plans reviewed:** `04-01-PLAN.md` … `04-05-PLAN.md` (5 plans across 5 sequential waves)

---

## Gemini Review

This is a comprehensive and high-quality suite of plans for the **Phase 4: Open questions register** phase. The plans exhibit extreme procedural rigor, carrying forward successful patterns from the Audit and Design phases while surgical addressing the specific requirements of a multi-source register. The use of sequential waves to manage contention on the single `.planning/OPEN-QUESTIONS.md` file is well-handled, and the integration of the "reviewer-ready" terminal state aligns perfectly with the established cross-AI mandates. The plans successfully transition from the "research-heavy" nature of Phase 2 to the "mechanical-authoring" nature of Phase 4 without losing traceability.

### Strengths

- **Methodical Reconciliation:** The plans carry forward the fixed reconciliation algorithm from Phase 2/3 (HIGH #3), ensuring that every deferral found in `DESIGN.md` or `CHANGELIST.md` is accounted for without double-counting or orphan rows.
- **Enforcement of Closed Enums:** The structural-check script (`openquestions-structure-check.sh`) is designed to reject any entry that deviates from the locked enums for Severity, Resolution-path, and Status, ensuring consistency for downstream build phases.
- **Traceability Discipline:** The commitment to `path:line` citations (D-14) and the mechanical walk of `CHANGELIST.md` Appendix E ensures that the register is grounded in the project's historical record rather than being interpretive.
- **Cross-Plan Coordination:** Plan 04-03 explicitly instructs Plan 04-04 on row numbering (OPEN-Q21/Q22) to prevent the breakage of forward cross-references — a critical detail for maintaining document integrity.
- **Self-Healing Finalization:** Plan 04-05 includes a specific protocol to handle edge cases where the register-total might fall below the structural-check's floor, ensuring a clean "exit 0" for the final milestone deliverable.

### Concerns

- **Coda Template Sub-items (OPEN-05) [LOW]:** Plan 04-03 populates the Coda template rows. There is a small risk that the "author-as-built" resolution might be too vague for a reviewer looking for specific schema commitments. However, since Phase 8 owns the build, this is likely acceptable as an informational register entry.
- **Grep Line Number Drift [LOW]:** As the document is populated across 5 plans, line numbers cited in `OPEN-QUESTIONS.md` for *itself* (e.g., in Appendix A/B) could drift. Plan 04-05 mitigates this by computing counts and IDs at the very end.

### Suggestions

- **Checklist Verification:** In Plan 04-02, consider running a quick `grep` for the `[OPEN: Phase 4]` markers in `CHANGELIST.md` just before authoring to ensure no last-minute deferrals from the Phase 3 approval gate were missed.
- **Appendix B Sort Order:** Ensure Appendix B in Plan 04-05 is sorted numerically by `OPEN-QNN` to make it easier for human reviewers to verify 1:1 cardinality against the section bodies.

### Risk Assessment: LOW

The risk level is **LOW**. The plans rely on proven structural-check scripts and reconciliation algorithms. The sequential wave structure prevents merge conflicts, and the mandatory use of actual line-number resolution via `grep -n` ensures the final register is verifiable and actionable for the v2.1+ build teams. All Phase 4 ROADMAP success criteria are explicitly addressed.

---

## Codex Review

### Summary

The plan set is mostly strong: it has clear wave sequencing, good section ownership, explicit acceptance criteria, and a useful structural-check discipline. It should produce the intended `.planning/OPEN-QUESTIONS.md` if executed carefully. The main risks are in the verifier logic and synthesis plan: several checks do not quite match the row format the later plans use, and the reconciliation algorithm is currently too weak for the D-50 promise.

### Strengths

- Clear sequential ownership of the shared `.planning/OPEN-QUESTIONS.md`; the wave ordering is sensible.
- Strong closed-enum discipline for severity, resolution path, status, and owning phase.
- Good handling of D-37 fallback wording and OPEN-Q22 cross-reference reservation.
- OPEN-04 pointer-only treatment is pragmatic and avoids snapshotting a moving client list.
- Summaries and mid-phase negative invariants are useful for tracking progress.
- The final document shape maps well to ROADMAP success criteria 1-5.

### Concerns

- **HIGH — A13 will likely fail final synthesis.** The final Appendix C text explicitly includes `synthesis Plan 04-05`, and A13 rejects bare `04-0[1-9]`. This conflicts with the planned final content.
- **HIGH — Structural-check row counting does not support decimal IDs.** A4 and A10 use `OPEN-Q[0-9]+`, but Plan 04-04 allows `OPEN-Q21.1`. That row may be ignored by the verifier and Appendix B cardinality.
- **HIGH — Reconciliation algorithm is not real reconciliation.** Plan 04-05 sets `INPUT_COUNT_AFTER_DEDUP="$REGISTER_TOTAL"` and documents this as an assumption. That does not satisfy D-50's stated requirement to build the input multiset, dedup it, and compare.
- **MEDIUM — Row floor of 22 is brittle.** The expected canonical row count fluctuates between ~21 and ~22 depending on whether OPEN-Q21.1 exists. A hard floor risks forcing an artificial row or script edit at synthesis.
- **MEDIUM — Citation verification checks pattern, not validity.** The plan says citations are verifiable via `grep -n`, but the script only checks backtick `path:line` shape. Appendix C also only compares total citation count.
- **MEDIUM — OPEN-Q06 and OPEN-Q07 owner ambiguity.** They use `Owning phase: Phase 1/Phase 2`, but resolution path is `/gsd-research-phase 1`. That may be acceptable, but the consumer contract says phases grep `Owning phase: Phase <N>`, and this hybrid owner may be missed by Phase 2.
- **LOW — "Use Write tool" instruction conflicts with Codex execution conventions.** If executed by Codex, edits should use `apply_patch`; the plan wording is Claude-specific.
- **LOW — Some proposed defaults may overreach register scope.** A few rows add implementation destinations such as `references/glossary.md` or specific Coda schema storage. Fine as proposed defaults, but they should remain clearly non-binding.

### Suggestions

- Change every structural-check row regex to support decimal IDs consistently: `OPEN-Q[0-9]+(\.[0-9]+)?`.
- Fix A13 before execution. Either remove all final `04-05` references from `OPEN-QUESTIONS.md`, or narrow the regex to actual stubs such as `Populated by 04-0[1-9]|Preamble placeholder|Executive summary .* placeholder`.
- Replace the A4 hard floor with a computed consistency check after Wave 4, or set the floor to `>= 21` and rely on Appendix B cardinality plus ROADMAP coverage checks.
- Make the reconciliation algorithm honest: create an explicit canonical expected-question list in Appendix C or a temporary script, dedup by normalised question text, and compare against register row questions. Do not set dedup count equal to register total by assumption.
- Add a citation validation pass that reads each `` `path:line` `` citation, confirms the file exists, and confirms the line number is present. Pattern-only validation is too weak for D-14/D-50.
- Decide whether `Phase 1/Phase 2` is a valid owning phase or should become two rows / one primary owner plus "also consumed by Phase 2". This affects downstream grep-based consumption.
- In Plan 04-05, explicitly verify each ROADMAP success criterion 1-5, not only structural completeness.
- Keep OPEN-06 as one canonical row unless the namespace decision truly needs independent tracking. That reduces numbering friction and avoids decimal-ID complexity.

### Risk Assessment

**Overall risk: MEDIUM.** The content architecture is solid and the wave sequencing is workable, but the verifier and reconciliation details need tightening before execution. The biggest issue is that the final plan could claim reviewer-ready while the reconciliation is only assumed, or fail its own structural-check because of `04-05` and decimal ID mismatches. Fixing those points should bring the risk down to LOW.

---

## Consensus Summary

Both reviewers agree the plan-set's **architecture and sequencing are sound** (sequential waves on shared file; closed-enum discipline; D-37 verbatim discipline; cross-plan ID handshake; OPEN-04 pointer-only; reviewer-ready phrase reservation; ROADMAP SC 1-5 mapping). Risk-rating split: gemini = LOW, codex = MEDIUM.

**Codex surfaces 3 HIGH-severity issues that gemini did not catch** — all in Plan 04-01's structural-check script and Plan 04-05's reconciliation Step 2. These are concrete, actionable defects rather than philosophical concerns, and any one of them will trigger a structural-check failure or a falsified reconciliation claim if left uncorrected:

| ID | Severity | Issue | Recommended fix |
|----|----------|-------|-----------------|
| **C1** | HIGH | A13 (no-placeholder regex) rejects bare `04-0[1-9]` but final Appendix C text includes the literal `synthesis Plan 04-05` — final structural-check exit 0 will fail | Narrow A13 to actual stub patterns (`Populated by 04-0[1-9]` / `Preamble placeholder` / `placeholder`) instead of bare ID match; OR strip all `04-05` narrative references during synthesis (parallel to Phase 3 Wave 7 plan-ID rewording for C9) |
| **C2** | HIGH | A4 + A10 row regexes `OPEN-Q[0-9]+` will silently drop decimal-ID rows (Plan 04-04 reserves `OPEN-Q21.1` for namespace sub-decision) | Update row regex to `OPEN-Q[0-9]+(\.[0-9]+)?` everywhere; or eliminate decimal IDs by collapsing OPEN-06 to a single canonical row (Codex's preferred path) |
| **C3** | HIGH | Plan 04-05 Task 3 Step 2 sets `INPUT_COUNT_AFTER_DEDUP="$REGISTER_TOTAL"` by assumption — falsifies D-50's stated cardinality+diff+ownership-per-row reconciliation | Build canonical expected-question multiset (from Appendix E + REQUIREMENTS OPEN-01..07 + ROADMAP SC 1-5), normalise + dedup, compare to register row Questions; emit cardinality + diff explicitly |
| **C4** | MEDIUM | Row floor of 22 brittle (depends on whether OPEN-Q21.1 exists) | Replace hard floor with `>= 21` + Appendix B 1:1 cardinality check; OR auto-compute floor from input streams |
| **C5** | MEDIUM | Citation field validation is regex-pattern-only — doesn't verify file exists or line number is present | Add citation-validity pass: parse each `` `path:line` `` citation, run `grep -n` (or `awk` line check) to confirm |
| **C6** | MEDIUM | Hybrid owner `Phase 1/Phase 2` won't match downstream `grep 'Owning phase: Phase <N>'` consumer pattern | Either split into two rows; OR pick primary owner + add `secondary_consumers:` field; OR document the hybrid pattern in CONTEXT D-NN |
| **C7** | LOW | "Use Write tool" wording is Claude-specific; would conflict if Codex executes | Re-phrase as platform-neutral ("write file at path X" / "edit file at path X") |
| **C8** | LOW | Some proposed-default fields overreach register scope (`references/glossary.md`, Coda schema storage destinations) | Either tighten proposed-default to register-only language; OR keep as informational with explicit "non-binding suggestion" tag |

**Gemini's 2 LOW concerns** (Coda template vagueness; line-number drift) are already mitigated by the existing plan structure (Phase 8 owns Coda templates; Plan 04-05 computes IDs at end).

**Gemini's 2 suggestions** (last-minute Appendix E grep check in Plan 04-02; sort Appendix B numerically in Plan 04-05) are easy adds that don't require replanning — could fold into existing acceptance criteria.

---

## Recommended next step

**`/gsd-plan-phase 4 --reviews`** — replan touching Plan 04-01 (regex fixes for A4 / A10 / A13 — C1 + C2 + C5), Plan 04-04 (decimal-ID handling or collapse — C2 + C6), Plan 04-05 (real reconciliation algorithm + ROADMAP SC walk + Appendix B sort — C3 + C4 + C8), and possibly 04-CONTEXT.md (D-56 if hybrid-owner pattern needs codifying — C6). Pattern matches Phase 3's cross-AI revision pass (9 concerns C1..C9 → /gsd-plan-phase 3 --reviews → all 9 mitigated → re-verify PASS).

If you choose to skip `--reviews` and execute as-is, the 3 HIGH issues will likely surface as structural-check failures during Wave 5 synthesis — recoverable but adds friction. The 2 MEDIUM owner-ambiguity / citation-validity issues won't fail the structural-check but will degrade the register's downstream consumability for v2.x build phases.

**Files this review touches:**

- `.planning/phases/04-open-questions/04-REVIEWS.md` (this file).
- Temp prompt + per-CLI outputs at `$TEMP/gsd-review-prompt-04.md` / `$TEMP/gsd-review-gemini-04.md` / `$TEMP/gsd-review-codex-04.md` (cleanup optional).
