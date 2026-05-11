---
name: kickoff-capture
description: Capture a kickoff for a new engagement or change request. Use when the user says "kickoff for X", "start kickoff", "capture meeting notes for X", "run kickoff", or pastes raw meeting notes / Miro / Field Notes content needing structure.
---

# kickoff-capture

Stage 1 of the dYdX delivery pipeline. Turn messy kickoff inputs into a reviewed `01_kickoff_v<N>.md` artefact that downstream stages can trust.

For normal execution, use:

- `../../references/runtime-stage-map.md`
- `../../references/runtime-frontmatter.md`
- `../../references/runtime-safety-summary.md`
- `references/kickoff-template.md`
- `references/capture-paths.md` only when the input path is unclear
- `references/auto-classify-rubric.md` only when source material is sparse, conflicting, or marked TBD

## Inputs

Accept one or more pasted sources:

- Meeting notes, transcript snippets, email threads, briefs, or freeform notes.
- Miro fallback: a pasted image plus the reviewer's narration of what the board shows. The narration is the source of truth.
- Field Notes fallback: pasted Coda rows. Each row must be triaged as keep, drop, or edit-and-keep.

Do not call Coda, Miro, platform APIs, or production tenants from this skill.

## Output

Write:

`<Client> Brain/<Project>/01_kickoff_v<N>.md`

If `<Client>` or `<Project>` is unclear, ask once before drafting.

## How to run

### Step 1 - Establish the capture path

Identify the input path:

- Freeform text means meeting-notes capture.
- Image plus narration means Miro fallback.
- Pasted table rows from Coda means Field Notes fallback.

Multiple input paths may be merged into one kickoff artefact. Preserve raw facts and mark uncertain classification inline as `[unknown — needs human classification]`.

### Step 2 - Classify into 8 sections

Sort captured material into exactly these sections, in this order:

1. **System** - what is being built or changed; current state vs target state.
2. **Users** - primary actors and secondary stakeholders.
3. **Triggers** - manual, scheduled, or event-driven entry points.
4. **Data** - inputs, outputs, and persistence boundaries.
5. **Rules** - business logic, branches, and approval gates.
6. **Integrations** - platforms, SaaS APIs, and paste-fed surfaces.
7. **Exceptions** - non-happy paths, error states, and reviewer overrides.
8. **Failure points** - fragility, integration boundaries, and observability gaps.

When a source can reasonably fit more than one section, choose the most useful section for downstream scoping. Use the auto-classification rubric only when confidence is low.

### Step 3 - Challenge the input

Before drafting, name the material gaps:

- Which of the 8 sections is thin?
- Which TBDs or contradictions need human classification?
- Which assumptions would create risk if downstream stages treated them as fact?

Keep this challenge concise and practical. The goal is to make unknowns visible, not to block useful progress.

### Step 4 - Choose `kickoff_branch`

Set one concrete value:

- `discovery-ready` - material unknowns remain. Stage 2 `discovery-intake` should run after approval.
- `draft-sow` - the engagement is clear enough to draft a SOW directly. Stage 2 will be skipped.

Document the rationale in the artefact's `## Routing` section.

### Step 5 - Draft the artefact

Use `references/kickoff-template.md`. Required frontmatter:

```yaml
---
client: <CLIENT_NAME>
project: <PROJECT_NAME>
platform: <pipefy | wrike | ziflow | other>
frontmatter_version: 2
kickoff_branch: <discovery-ready | draft-sow>
field_notes_processed_count: <N>
status: draft
based_on_kickoff: <upstream-CR-id-or-N/A-for-fresh-engagement>
---
```

Fill every section. For anything genuinely unknown, write `[unknown — needs human classification]`. Do not invent answers.

### Step 6 - Write and hand off

Write `01_kickoff_v<N>.md` in the target client/project folder.

End with this handoff:

```text
Awaiting status: approved write to 01_kickoff_v<N>.md. Branch routing on kickoff_branch: value (discovery-ready -> Stage 2; draft-sow -> SKIP Stage 2 -> Stage 3).
```

Do not auto-run Stage 2 or Stage 3.

## Quality bar

A good kickoff artefact:

- Gives downstream stages enough operational context to proceed.
- Keeps source facts traceable, especially Field Notes rows.
- Marks weak signal explicitly instead of guessing.
- Uses one concrete `kickoff_branch` value with a clear rationale.
- Refuses production-tenant or destructive actions.
