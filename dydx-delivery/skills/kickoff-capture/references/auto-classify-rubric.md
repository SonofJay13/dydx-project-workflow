# Auto-classification confidence rubric

Decide when to emit the `[unknown — needs human classification]` marker against any of the 8 STG1-04 kickoff sections (system / users / triggers / data / rules / integrations / exceptions / failure-points). The rubric is consumed by `kickoff-capture/SKILL.md` Step 2; the marker convention itself is documented in the SKILL.md body and asserted by the phase7 structure-check.

The rubric runs regardless of which `kickoff_branch:` value the kickoff will carry — the branch decision happens at Step 4, but every section is classified at Step 2 first.

## Explicit triggers

Emit the `[unknown — needs human classification]` marker against a section if ANY of the following triggers fires (per D-73 — verbatim):

1. **Category not named verbatim** in any source input (meeting notes / Miro paste / Field Notes paste). If no input mentions the category at all, the classification cannot be defended; mark unknown.
2. **< 2 distinct source mentions** — would require synthesising from a single witness. One mention is anecdote; two from independent sources are corroboration.
3. **Source contains explicit `TBD` / `?` / `unclear` / `come back to this`** text against this category. Where the reviewer or original author already signalled uncertainty, the kickoff must preserve that signal, not erase it.
4. **Source mentions cross conflicting alternatives** without resolution. Two captured opinions that disagree are NOT a classification — they are an unresolved decision that downstream stages need to be told about.
5. **Reviewer pre-flagged TBD** in the kickoff template input. If a reviewer started the kickoff with a section already marked `[unknown — needs human classification]`, the trigger fires regardless of what the captured inputs contain — reviewer judgement supersedes capture content.

## Input-signal → outcome escalation

Map each trigger to one of three outcomes against the section in question.

| Trigger | Section keeps marker (no classification attempted) | Section partially fills + retains marker | Section proceeds without marker |
|---|---|---|---|
| Trigger 1 — category not named in any source | ✔ | | |
| Trigger 2 — < 2 distinct source mentions | | ✔ | |
| Trigger 3 — explicit TBD / ? / unclear text | ✔ | | |
| Trigger 4 — conflicting alternatives unresolved | ✔ | | |
| Trigger 5 — reviewer pre-flagged TBD | ✔ | | |

A section can be "partially filled" (Trigger 2 outcome) by capturing the single mention verbatim while retaining the `[unknown — needs human classification]` marker on the section header or on the under-evidenced sub-row. This preserves the audit trail without inflating one witness into a confirmed classification.

If no trigger fires, the section proceeds without a marker — classification is defensible, and the kickoff records it as known.

## Operational principle

> Mark unknown when you'd hesitate to defend the classification to a reviewer.

This rule supersedes the explicit triggers above when reviewer judgement says the section is under-evidenced. The 5 triggers are sensors; the operational principle is the backstop. If the sensors say "proceed" but the reviewer's gut says "this is thin," mark unknown.

## How this rubric is consumed

`kickoff-capture/SKILL.md` Step 2 references this file by relative path (`references/auto-classify-rubric.md`) — that reference is asserted by the phase7 structure-check (assertion K7). The literal marker string `[unknown — needs human classification]` is documented in the SKILL.md body (assertion K5) and embedded inline in `kickoff-template.md` against every section (so reviewers see the convention before they start filling).

The rubric runs at Step 2 regardless of the eventual `kickoff_branch:` value (`discovery-ready` or `draft-sow`). The branch decision happens later, at Step 4. A kickoff destined for `draft-sow` is held to the same classification rigour as one destined for `discovery-ready`; skipping Stage 2 does not lower the kickoff's evidence bar.
