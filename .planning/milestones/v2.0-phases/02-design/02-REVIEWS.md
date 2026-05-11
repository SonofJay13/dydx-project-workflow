---
phase: 2
reviewers: [gemini, codex]
reviewed_at: 2026-05-09T22:00:00.000Z
plans_reviewed: ["02-01-PLAN.md", "02-02-PLAN.md", "02-03-PLAN.md", "02-04-PLAN.md", "02-05-PLAN.md", "02-06-PLAN.md", "02-07-PLAN.md", "02-08-PLAN.md", "02-09-PLAN.md", "02-10-PLAN.md"]
self_skipped: claude (running inside Claude Code CLI)
---

# Cross-AI Plan Review — Phase 2 (Design)

10 plans reviewed by 2 external AI systems (Gemini 2.5 Flash, Codex GPT-5.5).
`claude` CLI skipped for independence (this orchestration ran inside Claude Code).

---

## Gemini Review (gemini-2.5-flash)

> Initial attempt with `gemini-2.5-pro` exhausted quota (HTTP 429); retried successfully with `gemini-2.5-flash`.

### **Summary**

The set of 10 plans meticulously outlines the process of building the `.planning/DESIGN.md` document. It adopts a systematic, wave-based approach, leveraging a structural-check script to enforce consistency and completeness. The plans progressively layer architectural decisions, from foundational structure and cross-cutting concerns to detailed stage and platform skill contracts, culminating in a comprehensive synthesis. This structured method effectively addresses the complexity of the v2 architecture, ensuring all requirements are covered and potential risks are proactively managed.

### **Strengths**

*   **Granular and Iterative Approach:** Breaking down the complex task into 10 distinct, sequential plans allows for focused development, easier debugging, and incremental verification. Each plan builds logically on the previous one, ensuring a stable foundation.
*   **Robust Automated Verification:** The `design-structure-check.sh` script is a significant strength. Its detailed assertions, including checks for H2/H3 anchors, echo line counts, `[OPEN]` markers, and matrix row counts, provide continuous, automated structural validation. The explicit negative invariants in Plan 02-01 ensure the script's efficacy.
*   **Comprehensive Requirement Coverage:** All 30 `DESIGN-*` requirements and 18 `D-` CONTEXT decisions are meticulously mapped and addressed across the plans. This ensures no architectural aspect is overlooked.
*   **Clear Traceability and Citation:** The plans consistently emphasize and enforce traceability through `DESIGN-NN`, `D-NN`, and `AUDIT.md Â§X.Y` citations, ensuring that every contract and decision is grounded and verifiable.
*   **Proactive Risk Mitigation:** Potential pitfalls, especially those related to Coda integration (rate limits, async operations, token scope), frontmatter migration, and test harness drift, are identified and addressed with concrete design contracts and failure modes (e.g., `mutate_and_wait`, `keyColumns` for idempotency, `harness_drift` failure class).
*   **Explicit Handling of Open Questions:** The use of inline `[OPEN: Phase 4]` markers and the detailed process for enumerating them in a closed list (Plan 02-10) provides a robust mechanism for tracking deferred decisions and research dependencies.
*   **Focus on Reviewer Experience:** The design considerations for `DESIGN.md` (e.g., executive summary as TOC, matrix-then-prose, grep-canonical hand-off messages) enhance the document's readability and navigability for human reviewers.
*   **Adherence to Constraints:** Strict adherence to the "design-only milestone" and "no skill edits" mandate throughout all plans is clearly maintained, preventing scope creep and ensuring architectural locking before implementation.

### **Concerns**

*   **Skill Count Discrepancy (MEDIUM):** Plan 02-03 notes a discrepancy between the `DESIGN-12` claim of "13 skills total" and the architecture research enumerating 15. While a reconciliation paragraph is planned, the initial ambiguity in a core requirement like skill count could lead to confusion if not resolved clearly and early in the document.
*   **Numerous Research Dependencies (MEDIUM):** A significant number of `[OPEN]` markers are introduced for research-blocked items (e.g., native-AI ingestion endpoints, GraphQL cursor field names, rate-limit currency). While managed by deferral to Phase 4, the sheer volume of these indicates a high dependency on external research for full contract closure, posing a risk to downstream build phases if research outcomes are delayed or inconclusive.
*   **Potential for Literal String Brittleness (LOW):** While exact literal string matching for acceptance criteria is precise, it could be overly brittle to minor, non-semantic wording variations that might arise during human authoring. However, the use of case-insensitive ERE for prose-matching offers some mitigation.
*   **Manual Attestation Reliance (LOW):** Some verification steps still depend on manual reviewer attestation for qualitative aspects (e.g., "No full SKILL.md prose drafted," "Persona contract ... does not violate"). This is inherent to design review but highlights the need for diligent human oversight.

### **Suggestions**

*   **Explicit Skill Count Resolution:** For Plan 02-03, ensure the reconciliation paragraph for `DESIGN-12` not only explains the discrepancy but definitively states the *final, agreed-upon number* of v2 end-state skills, ensuring clarity from that point forward.
*   **Prioritize Research for Critical `[OPEN]` Items:** Before executing Phase 3 (Change list), consider a quick review of the `[OPEN]` list to identify any critical research items whose outcomes could significantly alter the build sequence or architectural decisions.
*   **Refine `[OPEN]` Marker Ownership Details:** In Plan 02-10, for each item in the closed `[OPEN]` list, ensure clear assignment of the *owning phase* (e.g., "Phase 4," "Phase 7") and, where possible, a named *verification owner* or team responsible for its resolution.
*   **Pre-emptive Review for Cross-cutting Impacts:** During the execution of plans, particularly for Plans 02-02, 02-03, and 02-04, a quick informal check by a human reviewer for any early-detected logical inconsistencies between these foundational sections could prevent cascading issues.

### **Risk Assessment**

**LOW-MEDIUM.** The overall risk level is **LOW** for structural integrity and **MEDIUM** for potential delays or rework arising from research dependencies and the inherent complexity of a comprehensive architectural design. The robust planning and verification mechanisms significantly mitigate risks related to completeness and quality. The detailed roadmap and explicit handling of open questions provide a clear path forward, but the successful execution of deferred research and the reconciliation of identified discrepancies will be crucial for the project's overall success.

---

---

## Codex Review (gpt-5.5)

## Summary
The plan set is strong on coverage and specificity, but it has a few execution-level flaws that would cause false failures or false confidence. The biggest issue is the repeated `awk '/^## X/,/^## /'` section-range pattern: because the start H2 also matches the end H2, those checks can capture only the heading line and miss the section body. That affects the structural checker and several acceptance criteria. Fix that before execution. Overall, the 10-plan split is justified by the size of `.planning/DESIGN.md`, but the plans need tighter file-modification boundaries and stronger final `[OPEN]` reconciliation.

## Strengths
- Strong DESIGN-01..30 coverage. Every requirement is mapped to a concrete plan and most have grep-verifiable checks.
- Good anti-shallow discipline. The plans specify exact anchors, field names, enum values, carrier paths, matrix columns, sentinel strings, and expected grep counts.
- Sensible serialisation. Since all waves edit `.planning/DESIGN.md`, strict wave order is appropriate.
- Good cross-cutting-first sequencing. DESIGN-01..10 land before downstream stage contracts depend on them.
- Clear design-only boundary in intent. Most tasks correctly avoid editing `dydx-delivery/skills/`.
- Good open-question discipline conceptually: inline `[OPEN: Phase 4 ...]` markers at point of use, then a final closed list in 02-10.
- The 10-plan split is not padded. The phase is large enough that scaffold, cross-cutting, inventory, platforms, stage groups, test architecture, and synthesis deserve separate waves.

## Concerns
- **HIGH:** The structural-check `awk` range for the hand-off matrix is broken:
  `awk '/^## Stage-by-stage hand-off contract/,/^## /'` will stop on the same H2 line it starts on. The matrix row count may stay `0` forever. Use a stateful range that exits only on the next H2, for example:
  ```bash
  awk 'f && /^## /{exit} f{print} /^## Stage-by-stage hand-off contract/{f=1}' "$DESIGN_FILE"
  ```
  The same bug appears in multiple plan verification snippets.

- **HIGH:** The final `[OPEN]` reconciliation in 02-10 is fragile. List entries quote the same marker text, so naive grep counts can double-count or accidentally include the closed-list section itself. The plan tries to avoid this with `INLINE_BODY`, but it should explicitly exclude the Deferred section and count bullet entries separately by `^- \*\*`\[OPEN`.

- **HIGH:** File modification scope is inconsistent. Each planÔÇÖs `files_modified` excludes the requested `02-NN-SUMMARY.md`, but the `<output>` section requires creating it. Several success criteria also say ÔÇ£No file modifications outsideÔÇªÔÇØ while summaries are extra files. This will create avoidable failure or ambiguity.

- **MEDIUM:** Plan 02-03 exposes a unresolved ÔÇ£13 vs 15 vs 16 skillsÔÇØ contradiction inside the plan itself. It instructs the executor to reconcile by reading research, which is sensible, but downstream headings and acceptance criteria still call the section `## 13-skill inventory`. If the true count is 15, the section title should be revised or explicitly explained in the title/body to avoid reviewer confusion.

- **MEDIUM:** Some acceptance criteria rely on exact phrasing that could conflict with the persona rule. For example, requiring quoted forbidden phrases in DESIGN-10 is fine, but broader greps may treat those as violations if later linting is added. Make the forbidden-list scope explicit.

- **MEDIUM:** Several forward references are acceptable but need guardrails. Plans 02-04 and 02-05 cite later sections such as DESIGN-22/23/26 before those sections exist. That is fine in a single accumulating document, but acceptance should not require later-body text until those waves run.

- **MEDIUM:** Plan 02-09 says the structural-check exits `0` before synthesis, but the closed `[OPEN]` list is still just a seed. Structurally this may pass, but ÔÇ£reviewer-readyÔÇØ only happens after 02-10. The wording should avoid treating 02-09 as fully complete.

- **LOW:** Plan 02-01 script comments say prose greps use case-insensitive ERE, but the script mostly uses `grep -qF` and `grep -cE` without `-i`. Either update the comments or use `grep -qiE` where intended.

- **LOW:** There are many exact-string checks containing `???`, which appear to be encoding artefacts for arrows or punctuation. If the repo stores proper arrows/dashes, these greps may fail. Standardise to ASCII tokens before execution.

## Suggestions
- Fix all `awk '/^## X/,/^## /'` ranges before approving execution. This is the main blocker.
- Add a shared helper in `design-structure-check.sh`, e.g. `section_between "## Heading"`, to avoid repeating brittle awk logic.
- Update every planÔÇÖs `files_modified` to include `.planning/phases/02-design/02-NN-SUMMARY.md`, or remove the summary creation requirement.
- Decide the skill-count wording before 02-03 runs. If the inventory is 15 end-state skills, rename the section to `## Skill inventory` or state ÔÇ£13-skillÔÇØ is legacy framing.
- Strengthen 02-10 reconciliation:
  - Count inline markers before the Deferred section.
  - Count Deferred list bullets that quote markers.
  - Compare normalised marker text, not only counts.
- Treat 02-09 as ÔÇ£structurally passableÔÇØ and 02-10 as ÔÇ£reviewer-readyÔÇØ.
- Add one final `git status -- dydx-delivery/` check in every plan summary, since design-only scope is non-negotiable.

## Risk Assessment
**MEDIUM.** Coverage is strong, but the broken section-range checks and file-scope contradictions could derail execution unless fixed before Wave 1.

---

## Consensus Summary

### Agreed Strengths
- **Granular plan-set with strong DESIGN-* coverage.** Both reviewers confirm all 30 DESIGN-* requirements and 18 D-* CONTEXT decisions are mapped to concrete tasks across the 10 plans.
- **Anti-shallow discipline.** Both reviewers note the plans specify exact anchors, matrix columns, sentinel strings, and grep-verifiable acceptance criteria — no "draft the section" hand-waving.
- **Strict serialisation justified.** Both agree that sequential waves are correct given the shared `.planning/DESIGN.md` deliverable.
- **Open-question discipline conceptually sound.** Inline `[OPEN: Phase 4 — ...]` markers + closed list in 02-10 is the right pattern (though execution has flaws — see Codex HIGH below).
- **10-plan split (vs CONTEXT D-31's ~8 hint) is justified, not padded.** Both reviewers confirm scaffold + cross-cutting + inventory + platforms + stage groups + test-bot architecture + synthesis legitimately deserve separate waves.

### Agreed Concerns
- **`13 vs 15 vs 16 skills` contradiction in Plan 02-03 (MEDIUM).** Both Codex and Gemini independently flagged that DESIGN-12's "13-skill" framing is contradicted by the architecture research (which enumerates 15 v2 end-state skills). The plan asks the executor to reconcile but downstream headings still say "13-skill inventory" — needs explicit pre-execution resolution.

### Codex-only HIGH concerns (action required before execution)
- **HIGH — Broken `awk '/^## X/,/^## /'` section-range pattern.** The start regex matches the end regex on the same H2 line, so the range captures only the header. Affects `design-structure-check.sh` and multiple plan acceptance criteria. Fix: use stateful awk (e.g., `awk 'f && /^## /{exit} f{print} /^## Hand-off/{f=1}'`) or a shared `section_between` helper. **This is the principal pre-execution blocker.**
- **HIGH — `[OPEN]` reconciliation in Plan 02-10 is fragile.** List entries quote the same marker text; naive grep counts can double-count or accidentally include the closed-list section itself. Fix: explicitly exclude the Deferred section from inline-marker scan; count Deferred bullets separately by anchored bullet pattern.
- **HIGH — `files_modified` excludes `02-NN-SUMMARY.md` but `<output>` requires creating them.** Inconsistent: success-criteria say "no file modifications outside…" while summaries are extra files. Fix: either add summaries to `files_modified` in every plan, or remove the SUMMARY.md creation requirement.

### Gemini-only MEDIUM concerns
- **High volume of research-blocked `[OPEN]` items.** Gemini notes the sheer count of inline `[OPEN]` markers (native-AI ingestion endpoints, GraphQL cursor field names, rate-limit currency, etc.) creates downstream-build risk if Phase 4 research stalls. Suggestion: pre-screen the closed list for any items whose resolution could re-shape build sequence before Phase 3 begins.

### Codex-only MEDIUM/LOW concerns
- **MEDIUM — Persona forbidden-phrase scope (DESIGN-10).** Acceptance criteria using forbidden quoted phrases could collide with future broader linting unless scope is made explicit.
- **MEDIUM — Forward-reference guardrails.** Plans 02-04/02-05 cite later sections (DESIGN-22/23/26) before those waves run — fine in an accumulating doc, but acceptance shouldn't require not-yet-written body text.
- **MEDIUM — Plan 02-09 "structural-check exits 0" wording premature.** 02-09 passes structural assertions but the closed `[OPEN]` list is still just the seed marker. Reviewer-readiness only happens after 02-10. Reword to "structurally passable" vs "reviewer-ready".
- **LOW — Plan 02-01 script comment/code mismatch.** Script comments claim case-insensitive ERE for prose greps, but most `grep` calls are `-qF` or `-cE` without `-i`. Either update comments or add `-i`.
- **LOW — Encoding artefacts (`???` literal strings).** Several exact-string checks contain encoding placeholders. If the repo stores proper Unicode arrows/dashes, greps may fail. Standardise to ASCII tokens before execution.

### Divergent Views
- **Overall risk level.** Gemini rates LOW-MEDIUM (LOW for structural integrity, MEDIUM for research-dependency delay). Codex rates MEDIUM (driven by the awk-range and `files_modified` execution-time bugs). The divergence reflects depth-of-review: Codex stress-tested the actual shell snippets; Gemini reviewed at the architectural-shape level. Both are valid and complementary.

### Recommended Next Step
Run `/gsd-plan-phase 2 --reviews` to incorporate this feedback. Priority items for the replan:
1. Fix the `awk` section-range pattern in `design-structure-check.sh` and any affected plan acceptance criteria (Codex HIGH).
2. Resolve the `13 vs 15 vs 16` skill-count framing in Plan 02-03 (Gemini + Codex consensus MEDIUM).
3. Reconcile `files_modified` with `<output>` SUMMARY.md requirements across all 10 plans (Codex HIGH).
4. Strengthen Plan 02-10 `[OPEN]` reconciliation logic (Codex HIGH).
5. Sweep encoding artefacts (`???`) → real Unicode dashes/arrows or ASCII tokens (Codex LOW but execution-blocking if greps fail).
