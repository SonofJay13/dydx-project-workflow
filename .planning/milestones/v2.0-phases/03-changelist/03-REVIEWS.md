---
phase: 3
reviewers: [gemini, codex]
reviewed_at: 2026-05-10
plans_reviewed:
  - 03-01-PLAN.md
  - 03-02-PLAN.md
  - 03-03-PLAN.md
  - 03-04-PLAN.md
  - 03-05-PLAN.md
  - 03-06-PLAN.md
  - 03-07-PLAN.md
risk_overall: MEDIUM (codex) / LOW (gemini)
---

# Cross-AI Plan Review — Phase 3 (Change list)

Independent reviewers invoked from the dydx-project-workflow root: Google Gemini CLI, OpenAI Codex CLI. The Claude Code CLI was skipped (self-CLI; running inside Claude Code).

## Gemini Review

This cross-AI review analyzes the 7-plan sequence (**03-01 to 03-07**) for Phase 3 of the `dydx-delivery` plugin project. The collective goal is the authoring and verification of `.planning/CHANGELIST.md`.

### 1. Summary
The plan sequence is exceptionally well-structured, adopting the high-fidelity authoring patterns established in Phases 1 and 2. The strategy of a "Wave 0" scaffold followed by sequential "Change-N" population waves and a final "Synthesis" pass ensures both document structural integrity and technical traceability. The plans correctly enforce all 32 critical/moderate pitfalls identified in research and integrate the complex milestone-bundling and fallback logic required by the context. The robust structural-check script (incorporating previous Phase 2 cross-AI review fixes like the stateful `section_between` helper) provides a strong automated gate for the terminal deliverable.

### 2. Strengths
*   **Verification Rigor:** The structural-check script in **03-01** is comprehensive. By setting a floor for mini-table rows, Appendix B sentinels, and Appendix A row counts, it ensures the final document is substantial and complete, not just a set of valid headings.
*   **Pattern Continuity:** The use of the **Phase 2 02-10 reconciliation algorithm** (Task 3 of **03-07**) for `[OPEN]` markers is a major strength. It prevents the regex double-counting issue discovered in the previous phase by using scoped body extraction and anchored bullet patterns.
*   **Verbatim Fidelity:** The plans are meticulous about verbatim text requirements. For instance, **03-03** and **03-07** correctly replicate the mandatory D-37 contingent fallback and re-bundling caveat sentences, ensuring no loss of intent from the design phase.
*   **Categorical Reconciliation:** **03-04** handles the potentially confusing skill counts (13 vs 15 vs 20) by providing a clear bottom-totals reconciliation paragraph that ties the 20 matrix rows back to the DESIGN-12 categories and architecture research.
*   **Risk Mitigation:** The "Meta-pattern reword" strategy in **03-07** (avoiding bracket-form markers in the Executive Summary and How-to-read sections) is a sophisticated move to prevent "noise" from breaking the automated reconciliation logic.

### 3. Concerns
*   **Appendix A Regex Fragility (MEDIUM):** The structural-check script in **03-01** (assertion #9) uses a regex `` ^\| (`[a-z]|generate-) ``. However, the data rows planned in **03-04** start with `| none`, `| derived from`, and `| referenced-but-missing`. These do not start with a backtick or the word "generate", and letters like `n`, `d`, or `r` might not be covered if the regex intended to match only backtick-wrapped names. This will likely cause a false failure of the structural check.
*   **Appendix C Fallback Sentence (LOW):** Plan **03-06** Task 1 explicitly states that Appendix C will *cross-reference* the fallback sentence instead of duplicating it. However, decision **D-37** in the context states the sentence is "mandatory in... Appendix C (Phase 7 entry)". A cross-reference deviates from this "MUST" requirement.
*   **Sequential vs. Parallel Contradiction (LOW):** The objective in **03-02** and **03-03** claims these plans run in parallel. However, **03-03** has a `depends_on: [03-02]` and a higher wave number, making them sequential. While sequential is safer for editing a single file, the documentation should be consistent to avoid confusion during orchestration.

### 4. Suggestions
*   **Fix Appendix A Regex:** Update the regex in **03-01** Task 1 (assertion #9) to `` ^\| (none|derived|referenced|`[a-z]) `` to properly capture all valid origin states planned in **03-04**.
*   **Ensure Verbatim Fallback in Appendix C:** Update the action block in **03-06** Task 1 to include the verbatim D-37 contingent fallback sentence in the Phase 7 row of Appendix C, fulfilling the "mandatory" constraint in D-37.
*   **Correct Wave Prose:** Align the prose in **03-02** and **03-03** to reflect that the waves are sequential (Turn 2 and Turn 3) rather than parallel, acknowledging that both target the same markdown file.

### 5. Risk Assessment: LOW
The risk is **LOW**. The plans are highly prescriptive, and the few identified concerns are minor regex or documentation alignment issues. The reliance on the previously-perfected Phase 2 synthesis patterns significantly reduces the risk of structural or traceability failure. The phase successfully produces a reviewer-ready deliverable that satisfies all CHANGE-01 through CHANGE-05 requirements.

---

## Codex Review

## Summary

The plan set is strong overall: it is explicit, well-sequenced, and likely to produce a reviewer-ready `.planning/CHANGELIST.md`. The biggest risks are not conceptual, but mechanical: several verifier patterns do not match the content later plans intend to write, so the final structural check may fail even if the document is correct. There is also some over-specification and a few contradictory counts around the v2 skill universe.

## Strengths

- Clear phase ownership: each plan owns specific H2 sections, reducing accidental overlap on `.planning/CHANGELIST.md`.
- Good dependency discipline: `03-07` depends on all prior plans, and later plans correctly assume earlier content exists.
- Strong traceability: CHANGE-01..05 map cleanly to document sections, appendices, requirements, pitfalls, and design decisions.
- Good handling of locked wording: D-37, D-41, D-43, and D-27 are repeatedly called out and verified.
- Appendix E reconciliation is well designed: scoped inline extraction, anchored bullet count, text diff, and ownership checks address the common double-counting failure.
- The deliberate failing check in `03-01` is useful. It proves the verifier is live before the document is populated.

## Concerns

- **HIGH: Appendix A structural-check pattern likely undercounts rows.**
  `03-01` counts Appendix A rows with `` ^\| (`[a-z]|generate-) ``, but `03-04` writes many rows whose first column begins with `none`, `derived`, or `referenced-but-missing`. The plan's own `03-04` acceptance criteria use a broader pattern, but the actual final structural script still uses the narrower one. Final `03-07` may fail even with a correct 20-row Appendix A.

- **HIGH: Status enum is inconsistent.**
  D-39 closed enum says `NEW / NEW (split) / MODIFIED / RETIRED / RETIRED → SPLIT / UNCHANGED`. `03-04` introduces `NEW (platform)` and `UNCHANGED-structure / behaviour-modified`, which are outside that enum. Either D-39 must be updated, or Appendix A must use the locked enum and move nuance into the Change column.

- **MEDIUM: Skill-count framing is confused.**
  The context says "13-skill v2 universe + accounted RETIRED rows"; `03-04` moves to 20 rows and 19 shipped skills. That may be correct after deeper reconciliation, but the plan currently explains it in a way that could look like it is overriding D-39/DESIGN-12. This needs one authoritative count model.

- **MEDIUM: "Verbatim" guarantees are weakened by allowed transformations.**
  Appendix B says verbatim lift from AUDIT-07, but then allows H3→H4 and 7.N→B.N renumbering. That is fine, but call it "content-verbatim with heading renumbering" rather than byte-identical.

- **MEDIUM: The script only checks presence, not uniqueness.**
  H2 anchors are checked with `grep -qF`, so duplicate H2s would pass. The plans warn against re-emitting anchors, but the verifier will not catch it.

- **LOW: D-38 says H3 per phase in places, but implementation uses H2 phase anchors.**
  D-36's H2 shape appears to be the real contract. Still, the wording should be normalised so downstream agents do not try to add duplicate `### Phase N` headings.

- **LOW: The plan is very large and brittle.**
  It is thorough, but much of the correctness relies on exact prose replacement across one shared Markdown file. Small formatting drift could break later checks.

## Suggestions

- Update `changelist-structure-check.sh` Appendix A row pattern to match the actual matrix shape, for example count all table rows after the header/separator inside Appendix A:
  ```bash
  grep -cE '^\| .+ \| .+ \| (NEW|NEW \(split\)|NEW \(platform\)|MODIFIED|UNCHANGED|UNCHANGED-structure|RETIRED|RETIRED → SPLIT)'
  ```

- Decide and lock one Appendix A status enum before execution. Recommended: keep the enum small:
  `NEW / MODIFIED / UNCHANGED / RETIRED → SPLIT`, and put "platform", "split", and "behaviour-modified" in the Change column.

- Add duplicate-heading checks to the structural script:
  `grep -cF "$h" "$CHANGELIST_FILE" == 1` for each required H2.

- Reword Appendix B requirement to: "verbatim content lift, except heading level and Appendix B numbering".

- Add a final "no placeholders remain" assertion in `03-07`, checking for strings like `Populated by`, `placeholder`, and `03-0`.

- Make the skill-count reconciliation paragraph simpler and authoritative. The current explanation risks confusing reviewers.

## Risk Assessment

**Overall risk: MEDIUM.** The phase goal is achievable and the plan coverage is strong. The main risk is verifier/content drift, especially Appendix A row counting and status enum mismatch. Fix those before execution and the risk drops to LOW.

---

## Consensus Summary

### Agreed Strengths

| Strength | Reviewers |
|---|---|
| Clear phase ownership and good dependency discipline (each plan owns disjoint H2 sections; 03-07 depends on all priors) | gemini + codex |
| Strong CHANGE-01..05 traceability + locked-wording enforcement (D-37 / D-41 / D-43 / D-27) | gemini + codex |
| Appendix E reconciliation (Phase 2 02-10 algorithm carried — scoped extraction + cardinality + diff + ownership) | gemini + codex |
| Verification rigor: scaffold script + deliberate failing invariant at end of Wave 1 | gemini + codex |

### Agreed Concerns

| # | Concern | Severity (codex / gemini) | Plan | Fix |
|---|---|---|---|---|
| **C1** | **Appendix A row-count regex undercounts.** Script asserts `` ^\| (`[a-z]|generate-) `` but 03-04 will emit rows starting `\| none`, `\| derived from`, `\| referenced-but-missing`. Final 03-07 structural-check will false-fail. | HIGH / MEDIUM | 03-01 (script assertion #9) + 03-04 acceptance | Replace assertion regex with one that anchors on Status column closed enum (Codex's row-pattern suggestion), OR widen first-column pattern to `` ^\| (none\|derived\|referenced\|`[a-z]) `` (Gemini's suggestion). |

### Divergent / Single-Reviewer Concerns (still actionable)

| # | Concern | Reviewer | Severity | Plan | Fix |
|---|---|---|---|---|---|
| **C2** | **Status enum inconsistency.** 03-04 introduces `NEW (platform)` and `UNCHANGED-structure / behaviour-modified` — outside the D-39 closed enum (`NEW / NEW (split) / MODIFIED / RETIRED / RETIRED → SPLIT / UNCHANGED`). Either widen D-39 or move nuance into the Change column. | codex | HIGH | 03-04 + (CONTEXT D-39 if widening) | Pick: shrink enum back to D-39 + push nuance to Change cells, OR amend CONTEXT.md D-39 to add `NEW (platform)` + `UNCHANGED-structure` + `behaviour-modified`. Recommend the former — keeps D-39 stable. |
| **C3** | **D-37 Appendix C fallback "mandatory" not honoured.** 03-06 Task 1 cross-references the OPEN-01 contingent fallback sentence in Appendix C Phase 7 row instead of restating verbatim — D-37 wording says "mandatory in...Appendix C (Phase 7 entry)". | gemini | LOW | 03-06 Task 1 | Update 03-06 action block to include the full verbatim sentence in the Phase 7 row Research-blocked-items cell of Appendix C. |
| **C4** | **Skill-count framing confused.** "13-skill universe" claim alongside 20-row matrix and 19 shipped skills risks looking like the plan overrides D-39/DESIGN-12. | codex | MEDIUM | 03-04 reconciliation paragraph | Simplify the bottom-totals paragraph to one authoritative count: 13 v2 universe per DESIGN-12 (10 stage-skills + 3 platform-skills) + N RETIRED rows = matrix total. |
| **C5** | **"Verbatim" guarantees weakened by allowed renumbering.** Appendix B claims verbatim lift but allows H3→H4 and 7.N→B.N. | codex | MEDIUM | 03-05 Task 1 | Reword acceptance criterion: "content-verbatim with heading-level demote (H3→H4) and prefix renumber (7.N→B.N)". |
| **C6** | **No H2 uniqueness check.** Script uses `grep -qF` for each anchor — duplicate H2s would pass. | codex | MEDIUM | 03-01 Task 1 | Add `[ "$(grep -cF "$anchor" "$CHANGELIST_FILE")" = 1 ]` per required H2. |
| **C7** | **D-38 says H3 per phase, implementation uses H2.** Inconsistency in CONTEXT.md — D-36 H2 list is the real contract, but D-38 wording says `### Phase N`. | codex | LOW | CONTEXT D-38 wording (out-of-band fix) | Tweak D-38 to: "Each phase = `## Phase N` H2 (per D-36) + brief narrative paragraph + 6-row mini-table". Plans don't need changing — they already use H2. |
| **C8** | **Sequential-vs-parallel contradiction.** 03-02/03-03 prose calls them "parallel" but `wave` numbers + `depends_on` make them sequential. | gemini | LOW | 03-02 + 03-03 objective prose | Replace "parallel Wave 1" wording with "sequential Waves 2 + 3" in objective blocks. |
| **C9** | **No "no placeholders remain" assertion.** Final structural-check does not catch leftover `placeholder` / `Populated by` / `03-0X` strings. | codex | MEDIUM | 03-01 + 03-07 | Add `! grep -qE 'Populated by|placeholder|03-0[0-9]' "$CHANGELIST_FILE"` assertion in 03-01 (tagged as final-only) and assert PASS in 03-07. |

### Risk Reconciliation

- Gemini: **LOW** — concerns are regex / documentation drift only.
- Codex: **MEDIUM** — Appendix A regex + Status enum are HIGH-severity blockers if unfixed.
- **Effective risk before fixes: MEDIUM** (Codex is more conservative; the Appendix A regex issue is real and will false-fail the final structural-check).
- **Effective risk after fixes: LOW** (both reviewers converge on LOW once C1, C2, C6, C9 are addressed).

### Recommended Path

Two cheap revisions before executing:

1. **Plan-level revision (C1, C2, C6, C9):** Replan via `/gsd-plan-phase 3 --reviews` — the planner re-reads this REVIEWS.md and incorporates the fixes into 03-01 (regex + uniqueness + no-placeholder assertion), 03-04 (enum + reconciliation), 03-05 (reword), 03-06 (verbatim D-37 sentence in Appendix C), and 03-02 / 03-03 (objective-prose wording).
2. **CONTEXT.md amendment (C7 only):** Tweak D-38 wording to say `## Phase N` H2 instead of `### Phase N` H3 — this is a one-line edit to `.planning/phases/03-changelist/03-CONTEXT.md`. Plans don't need changing.

If you want to skip the replan and execute as-is, C1 + C9 will surface as structural-check failures during Wave 7 (03-07) and you'll have to fix in-flight. C2 will surface during 03-04 acceptance verification. None of these will silently corrupt CHANGELIST.md content — the final document will still be reviewer-ready.

---

*Reviewers invoked: gemini (Google Gemini CLI), codex (OpenAI Codex CLI). Skipped: claude (self-CLI). Other CLIs not installed: coderabbit, opencode, qwen, cursor.*
