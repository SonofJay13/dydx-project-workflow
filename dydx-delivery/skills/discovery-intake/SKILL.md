---
name: discovery-intake
description: Capture Stage 2 discovery from an approved kickoff artefact. Use when the user says "start discovery for X", "capture intake for X", "run discovery", or "kick off Stage 2 for X".
---

# discovery-intake

Stage 2 of the dYdX delivery pipeline. Turn an approved kickoff into a structured discovery artefact for SOW and specification work.

For normal execution, use:

- `../../references/runtime-stage-map.md`
- `../../references/runtime-frontmatter.md`
- `../../references/runtime-safety-summary.md`
- `references/intake-template.md`

Discovery does not accept raw notes directly. Raw notes, Miro narration, and Field Notes rows go through `kickoff-capture` first.

## Inputs

Required:

- Latest approved `01_kickoff_v<N>.md` for the client/project.
- `status: approved` in kickoff frontmatter.
- Concrete `client:`, `project:`, `platform:`, and `kickoff_branch:` values.

Optional:

- Existing `02_discovery_v<N>.md` when the reviewer wants a revision or extension.

## Output

Write:

`<Client> Brain/build-specs/<platform>/02_discovery_v<N>.md`

Every new discovery artefact must include:

```yaml
based_on_kickoff: 01_kickoff_v<N>.md
```

If client or platform is missing from the approved kickoff, stop and ask the reviewer to fix the kickoff before continuing.

## How to run

### Step 1 - Locate and route from kickoff

Read the latest approved `01_kickoff_v<N>.md`.

If no approved kickoff exists, stop and tell the reviewer to run `kickoff-capture` first.

Route by `kickoff_branch:`:

- `discovery-ready` - continue to Step 2.
- `draft-sow` - emit exactly:

```text
Stage 2 SKIPPED — kickoff branch = draft-sow
```

Then exit without writing a `02_discovery_v<N>.md` artefact.

### Step 2 - Check for existing discovery

Look in `<Client> Brain/build-specs/<platform>/` for `02_discovery_v*.md`.

- If none exists, write `_v1`.
- If one or more exists, ask whether to revise as `_v{N+1}`, extend in place, or start fresh.

### Step 3 - Run the discovery interview

Walk through these eight dimensions. If the approved kickoff already answers a dimension, summarise what is known and ask only for the gap.

1. **Business outcome**
   - What measurable outcome does the client want?
   - Why now?
   - What does success look like in three months?

2. **Users**
   - Who interacts with the workflow?
   - Who owns it?
   - Who depends on it?
   - What is their technical level?

3. **Systems**
   - What platforms are in play?
   - What is the system of record for each key data item?
   - What is already automated vs manual?

4. **Triggers**
   - What starts the workflow?
   - How often does it happen?
   - Are there multiple entry points?

5. **Data**
   - What information moves through the workflow?
   - Where does it originate and end up?
   - Is any of it sensitive?

6. **Rules**
   - What decision logic changes the path?
   - Who approves what?
   - Are there SLAs or deadlines?

7. **Integrations**
   - What external systems are involved?
   - What is the direction of each integration?
   - What is known about auth, frequency, and error handling?

8. **Exceptions and failure points**
   - What goes wrong today?
   - What is manually patched up?
   - What happens if a system goes down mid-workflow?

### Step 4 - Confirm platform and integrations

Use the kickoff frontmatter as the starting point:

- `platform:` must be one of `pipefy`, `wrike`, `ziflow`, or `other`.
- `integrations:` should list supporting systems such as Ziflow, Workato, Frontify, Slack, or other named tools.

Ask only if the kickoff and discovery answers conflict.

### Step 5 - Draft the artefact

Use `references/intake-template.md`. Required frontmatter:

```yaml
---
client: <CLIENT_NAME>
project: <PROJECT_NAME>
platform: <pipefy | wrike | ziflow | other>
integrations: [<ziflow>, <workato>, ...]
version: <N>
status: draft
frontmatter_version: 2
based_on_kickoff: 01_kickoff_v<N>.md
captured_by: <user>
captured_at: <YYYY-MM-DD>
---
```

Fill every section. For anything genuinely unknown, write `[unknown — needs client input]`. Do not invent answers.

### Step 6 - Write and hand off

Write to `<Client> Brain/build-specs/<platform>/02_discovery_v<N>.md`.

End with this handoff:

```text
Awaiting status: approved write to 02_discovery_v<N>.md before generate-sow runs.
```

Do not auto-run `generate-sow`.

## Quality bar

A good discovery artefact:

- Builds directly on an approved kickoff.
- Surfaces edge cases and failure points, not only the happy path.
- Names platforms, integrations, owners, and systems of record clearly.
- Marks unknowns explicitly.
- Stays short enough to review in about five minutes.
