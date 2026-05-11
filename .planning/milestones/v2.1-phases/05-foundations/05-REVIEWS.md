---
phase: 5
reviewers: [gemini, codex]
reviewed_at: 2026-05-10
plans_reviewed:
  - 05-01-PLAN.md
  - 05-02-PLAN.md
  - 05-03-PLAN.md
  - 05-04-PLAN.md
  - 05-05-PLAN.md
attempted_but_failed: [ollama]
ollama_failure_reason: |
  Ollama (gemma4:e4b, local 4B model) returned a hallucinated review referencing
  files that do not exist in this project (src/utils.js, src/api_client.py,
  index.html, Cypress/Playwright tests, "Frontend UI/UX"). The 325KB prompt
  exceeded the model's effective context handling. Output excluded from
  REVIEWS.md to avoid polluting the planner's revision pass with confabulated
  content.
---

# Cross-AI Plan Review — Phase 5: Foundations + Connector Verification

**Plans reviewed:** 5 (05-01 through 05-05)
**Reviewers (succeeded):** Gemini (`gemini` CLI default model), Codex (`codex exec` default model)
**Reviewers (failed/excluded):** Ollama gemma4:e4b — see frontmatter `ollama_failure_reason`

---

## Gemini Review

# Cross-AI Plan Review: Phase 5 (Foundations + Connector Verification)

This review covers implementation plans `05-01` through `05-05` for the dYdX Delivery Plugin v2.1 milestone.

## 1. Summary
The plans for Phase 5 are exceptionally thorough, technically grounded, and ready for execution. They demonstrate a high degree of "operational ground-truth" awareness, using exact line citations and byte-perfect text strings derived from the preceding audit and research phases. The wave-based sequencing is logical, ensuring that canonical sources of truth are established in Wave 1 before being referenced by downstream skill edits in Wave 2. The inclusion of a cross-platform line-ending fix for the LICENSE file and the rigorous use of `grep`/`jq` for validation indicate a senior level of implementation detail.

## 2. Strengths
*   **Logical Dependency Management:** Establishing the `references/` directory in Wave 1 before repointing skills in Wave 2 prevents dangling pointers and ensures every edit is verifiable against an existing source.
*   **Discrepancy Reconciliation:** Plan 05-02 correctly identifies that implementation decision `D-59` nominated the wrong files for hard-rules deduplication and proactively adheres to the audited reality in `AUDIT-05.1`.
*   **Validation Rigor:** Each task embeds specific, automated shell assertions. The "retrospective" validation script in Wave 5 provides a robust final gate that ratifies all ~40 foundational requirements.
*   **Windows Compatibility:** The use of `.gitattributes` to pin the `LICENSE` file to LF line endings is a critical "Nyquist" detail that prevents Windows CRLF auto-conversion from breaking the byte-exact verification requirement.
*   **Open Question Closure:** Plan 04's "inline" resolution of 8 open questions efficiently closes research gaps (rate limits, product naming, MCP wiring) without requiring a separate research turn.

## 3. Concerns
*   **[LOW] Autonomy Halt in Wave 5:** Plan 05-05 is marked `autonomous: false` due to wording choices for B.1 and B.3. While this is procedurally correct for user-visible text, it creates a manual checkpoint in a predominantly automated sequence.
*   **[LOW] Coda MCP Permission Risk:** The preferred "Option A" for the status-lifecycle survey (Plan 05-01) relies on Coda MCP access to specific client docs. If permissions have drifted since the audit, the executor will need to be diligent in switching to the "Option B" fallback.
*   **[LOW] Citation Drift:** Plan 05-04 relies on line-number citations in `OPEN-QUESTIONS.md`. Although the plan mandates re-calculating these lines via `grep` immediately before editing, any concurrent file modifications (unlikely given the wave slicing) could still cause minor drift.

## 4. Suggestions
*   **Task 1 (Plan 05-05):** To minimize the manual overhead of the `checkpoint:decision`, consider accepting the `b1-research-suggested-plus-b3-v2-endstate` default as the baseline, as it is already aligned with the approved `ROADMAP.md` and `REQUIREMENTS.md`.
*   **Grep Gate Hygiene:** In the `phase5-structure-check.sh` script, ensure that negative grep assertions (checking for absence) specifically exclude the script's own directory or comments to avoid false-positive failures.
*   **Glossary Narrowing:** During Wave 1, ensure the "lift-and-narrow" of the glossary strictly removes design-phase-only terms (like `gsd-verifier`) to keep the runtime reference clean for developers.

## 5. Risk Assessment
**Overall Risk Level: LOW**

The plans are surgical, minimize side effects by scoping edits to specific line ranges, and include comprehensive automated verification. The dependency on previously approved design contracts (`DESIGN.md`, `UAT-6.1`) is handled verbatim, ensuring no scope creep or re-litigation of decisions.

**Status:** **Approved for Execution** once the Wave 5 checkpoint is acknowledged.

---

## Codex Review

## Summary

Overall, the Phase 5 plan set is strong and close to execution-ready. The wave slicing is sensible, dependencies mostly line up, and the plans do a good job turning a messy foundation phase into grep-verifiable, reviewable work. The main risks are not about missing scope, but about over-specification, a few brittle validation commands, and some cross-wave decisions that need to be made explicit before execution.

## Strengths

- Clear wave sequencing: W1 canonical refs, W2 skill repoint, W3 manifests/scaffold, W4 connector matrix, W5 cleanup/validation.
- Good handling of the D-59 vs AUDIT-05.1 mismatch; using AUDIT-05.1 as ground truth is the right call.
- Strong negative assertions around owner email, native-AI API scope, Pipefy MCP scope, secrets, and old-prefix leftovers.
- Good preservation of v0.3.0 compatibility through permanent lenient mode and no in-flight artefact renaming.
- W3 correctly identifies the real plugin manifest path: `dydx-delivery/.claude-plugin/plugin.json`.
- B.6 landing in W3 is pragmatic and avoids a second `marketplace.json` edit.
- LICENSE line-ending handling via `.gitattributes` is a useful Windows-specific safeguard.

## Concerns

- **HIGH:** Plan 05-04 says OPEN-QUESTIONS row flips should change "ONLY the Status field", but also appends resolution text. That is contradictory. If the row schema already has a Resolution field, the plan should say exactly which field receives the resolution text.

- **HIGH:** Plan 05-05 defaults B.3 to "13 stages", even though v2.1 still ships 7 existing skills plus foundations/platform work. This satisfies ROADMAP/REQUIREMENTS wording, but risks making the README forward-state the product. The checkpoint helps, but the default may still create misleading public docs.

- **MEDIUM:** Plan 05-01 glossary includes Q09/Q13 terms before W4 formally resolves those OPEN-Qs. Since RESEARCH already contains the answers, this is probably fine, but it weakens the clean wave boundary.

- **MEDIUM:** Coda status-survey execution is under-specified for the actual tool environment. The plan names a questionable tool pattern (`mcp__plugin_context-mode_context-mode__ctx_*`) and assumes Coda page traversal. It needs a concrete fallback path if only URLs or no Coda tools are available.

- **MEDIUM:** Several validation snippets are Bash-specific, but the environment context is PowerShell/Windows. The plans assume Bash availability. That may be fine if GSD standardises on Bash/WSL, but it should be stated as a prerequisite.

- **MEDIUM:** Empty scaffold dirs with `.gitkeep` conflict slightly with "empty dirs" wording. This is practical for Git, but validation should consistently define "empty" as "only `.gitkeep`".

- **LOW:** Some grep assertions are brittle around markdown formatting, pluralisation, and line wrapping. They may fail on semantically correct content.

- **LOW:** `mcpServers` deferral is reasonable, but because DESIGN-04 names it, the deferral should be recorded in the final summary or OPEN register to avoid looking like an accidental omission.

## Suggestions

- In 05-04, rewrite the OPEN-Q edit rule to: "Preserve the row schema; update `Status` to `decided`; update the existing `Resolution path` or `Resolution` field with the cited resolution." Avoid saying "ONLY Status".

- For B.3, consider making the default README wording explicit as future-facing, for example: "v2 roadmap targets a 13-stage pipeline". That avoids implying all 13 stages are already shipped.

- Add a small "execution prerequisite" note: Bash + `jq` required on Windows, likely via Git Bash or WSL.

- In 05-01, separate "glossary includes provisional Q09/Q13 research-backed terms" from "W4 formally closes OPEN-Q rows", or move those two entries to W4/W5.

- Replace the Coda survey tool reference with a tool-agnostic instruction: use available Coda MCP page-read tools if present; otherwise document no access and run the SKILL.md fallback.

- Add a validation assertion that `.gitattributes` changes do not overwrite existing directives.

- In W5, if option "13 stages" is chosen, make README wording align with current vs target state rather than only passing the numeric grep.

## Risk Assessment

**Overall risk: MEDIUM.** The plans are comprehensive and mostly executable, but the OPEN-Q row-edit contradiction, README "13 stages" ambiguity, and Bash/Coda environment assumptions should be tightened before execution.

---

## Consensus Summary

Both reviewers rate the plans as **execution-ready** with **LOW–MEDIUM overall risk**. Two HIGH-severity concerns surface only in the Codex review — both are actionable corrections that could be folded in via `/gsd-plan-phase 5 --reviews` before execution if the user chooses to incorporate them.

### Convergent findings (both reviewers flag)

1. **Wave 5 checkpoint:decision (B.3 step-count)** — both note that the checkpoint creates manual overhead. Gemini explicitly recommends accepting Option (ii) "13 stages" as default since it aligns with ROADMAP SC-4 + REQUIREMENTS FOUND-11 (already done in iteration-2 revision).
2. **Coda MCP availability for status survey (Plan 05-01 Task 1)** — both note Option A relies on Coda MCP being wired; both endorse the Option B fallback path. Codex asks for a more concrete fallback specification when only URLs are available.
3. **Citation-line drift in Plan 05-04 Task 2** — Gemini calls it LOW (mitigated by the `grep -n` re-resolution step added in the iteration-2 revision); Codex elevates the broader OPEN-Q row-edit semantics to HIGH (see "ONLY Status" contradiction below).

### Codex-only HIGH findings (worth incorporating)

1. **Plan 05-04 OPEN-Q row-edit semantics contradiction** — the plan says "change ONLY the Status field" but ALSO appends resolution text. Codex flags this as a HIGH-severity contradiction. **Fix:** rewrite the rule to "Preserve row schema; set Status field to `decided`; populate the existing Resolution / Resolution-path field with the cited resolution text."
2. **Plan 05-05 B.3 README wording risk** — even with default Option (ii) (13 stages), the literal README phrasing risks making the README forward-state the product when only 7 skills currently ship. Codex suggests phrasing as "v2 roadmap targets a 13-stage pipeline" rather than implying all 13 stages are shipped today.

### Codex-only MEDIUM findings

3. **Bash + jq prerequisite** — many validation snippets are Bash-specific in a PowerShell/Windows environment. Codex asks for an explicit "execution prerequisite: Bash + jq via Git Bash or WSL" note in plan metadata.
4. **Glossary mentions Q09/Q13 terms in W1 before W4 formally resolves them** — soft wave-boundary leak; defensible since RESEARCH.md already has the answers, but Codex would prefer either (a) splitting those glossary entries to W4/W5 or (b) annotating them as "provisional, ratified by W4 OPEN-Q closure."
5. **`.gitattributes` overwrite safety** — Codex recommends adding an assertion that the new `LICENSE text eol=lf` directive does not clobber existing directives.
6. **Empty-dir wording vs `.gitkeep`** — terminology cleanup: define "empty" as "only `.gitkeep` present" consistently across the structure-check.

### Gemini-only LOW findings

7. **Glossary narrowing** — ensure the "lift-and-narrow" of the glossary strictly removes design-phase-only terms (e.g. `gsd-verifier`) to keep the runtime reference clean.
8. **Negative-grep hygiene in `phase5-structure-check.sh`** — exclude the script's own directory and comments from absence-checks to prevent false-positive failures.

### Risk verdicts

| Reviewer | Risk | Verdict |
|----------|------|---------|
| Gemini | **LOW** | "Approved for Execution once the Wave 5 checkpoint is acknowledged." |
| Codex | **MEDIUM** | "Comprehensive and mostly executable, but the OPEN-Q row-edit contradiction, README '13 stages' ambiguity, and Bash/Coda environment assumptions should be tightened before execution." |

### Recommended action

Run `/gsd-plan-phase 5 --reviews` to fold the Codex HIGH findings (#1 + #2) and the highest-leverage MEDIUM (#3 Bash prerequisite + #5 `.gitattributes` safety) back into the plans before `/gsd-execute-phase 5`. The remaining LOW findings can be addressed in a follow-up or accepted as-is.
