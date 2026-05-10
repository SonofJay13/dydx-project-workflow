---
name: discovery-intake
description: Capture client discovery for a new engagement or feature. Use when the user says "start discovery for X", "capture intake for X", "run discovery", "client intake", "kick off a new engagement", or pastes meeting notes / a transcript and asks Claude to structure it. Produces a versioned discovery artefact that downstream stages (SOW, functional spec, technical spec) consume.
---

# discovery-intake

Capture the real operational context for a new client engagement or feature. Produce a structured discovery artefact that downstream skills consume.

## Inputs

- Free-form context: chat, pasted meeting notes, transcript, brief, email thread
- (Optional) Existing discovery file the user wants to extend or revise

## Output

`<Client>/build-specs/<platform>/02_discovery_vN.md` — versioned, frontmatter-tagged.

If `<Client>` and `<platform>` aren't obvious from context, ask once before drafting.

## How to run

### Step 1 — Establish target location

Determine the client folder and platform:

1. If the user named a client (e.g. "discovery for Up & Up"), match it against the workspace `hub.md` client index.
2. If the platform is obvious from the client folder (most clients have one primary platform — see `hub.md`), use it.
3. If either is ambiguous, ask the user to confirm. Do not draft without knowing where the file lands.

### Step 2 — Check for existing discovery

Look in `<Client>/build-specs/<platform>/` for files matching `02_discovery_v*.md`.

- **None found** → this is the first version. Proceed to Step 3.
- **One or more found** → ask: "I found `02_discovery_v{N}.md`. Do you want to (a) revise it as `_v{N+1}`, (b) extend in place, or (c) start a fresh artefact?"

### Step 3 — Run the discovery interview

Walk the user through the eight discovery dimensions. Ask them in this order. If the user has provided notes that already cover a dimension, summarise back what you captured and ask only for gaps. Do not interrogate — keep it conversational and efficient.

**1. Business outcome**
- What's the measurable outcome the client wants?
- Why now? What changes if this doesn't get done?
- What does success look like in three months?

**2. Users**
- Who interacts with this workflow? (roles, not names — but capture names if useful)
- Who owns it? Who depends on it?
- What's their technical level?

**3. Systems**
- What platforms are in play? (primary + supporting)
- What's the system of record for each piece of data?
- What's already automated vs manual?

**4. Triggers**
- What kicks off the workflow? (user action, time, event, integration)
- How frequently?
- Are there multiple entry points?

**5. Data**
- What information moves through the workflow?
- Where does it originate? Where does it end up?
- Any sensitive data? (PII, financial, health)

**6. Rules**
- Decision logic — what determines which path a piece of work takes?
- Approvals — who approves what, and what triggers them?
- SLAs or deadlines?

**7. Integrations**
- What external systems does this touch?
- Direction (inbound, outbound, bidirectional)?
- Auth method, frequency, error handling today?

**8. Exceptions and failure points**
- What goes wrong today? How is it caught?
- What's manually patched up that shouldn't be?
- What happens if a system goes down mid-workflow?

### Step 4 — Identify platform and integrations

Based on the user's answers, determine:

- **Primary platform**: pipefy, wrike, or other (ask if unclear)
- **Integration tools**: ziflow, workato, frontify, slack, others — captured as a list

These become frontmatter fields and dictate which platform skill the technical spec stage will load later.

### Step 5 — Draft the artefact

Use the template at `references/intake-template.md`. Fill every section. For anything genuinely unknown, write `**Unknown — needs client input**` rather than guessing.

Frontmatter is mandatory:

```yaml
---
client: <Client>
platform: <pipefy | wrike | other>
integrations: [<ziflow>, <workato>, ...]
version: 1
status: draft
captured_by: <user>
captured_at: <ISO date>
---
```

### Step 6 — Write and hand off

Write to `<Client>/build-specs/<platform>/02_discovery_v{N}.md`.

End with this exact handoff message to the user:

> Discovery captured at `<path>`.
>
> **Review steps:**
> 1. Open the file and check for accuracy
> 2. Mark any `**Unknown — needs client input**` items you can fill in
> 3. If you make significant edits, save as `02_discovery_v{N+1}.md` (Option B versioning)
>
> When you're ready, run **`generate-sow`** to produce the scope of work.

## Start-at-any-point handling

This is the entry skill — it doesn't depend on upstream artefacts. But if the user calls a *later* skill (e.g. `generate-sow`) without running discovery, that skill will offer to either: (a) paste an existing discovery doc, (b) run a quick inline capture, or (c) cancel.

This skill itself accepts shortcut inputs:

- "I already have a brief — here it is" → parse the brief into the template structure, ask only for missing dimensions
- "Just structure these notes" → take pasted notes, infer what you can, ask for the rest

## What this skill does not do

- Does not draft scope, spec, or technical detail — that's downstream
- Does not commit the user to a platform choice if it's genuinely unclear; asks instead
- Does not invent answers to "Unknown" items — flags them explicitly
- Does not run the next skill automatically

## Quality bar

A good discovery artefact:

- Reads like the team understands the actual operational reality, not the idealised version
- Surfaces edge cases and failure points, not just the happy path
- Names the platforms, integrations, and ownership crisply
- Marks every unknown — never silent
- Is short enough to read in 5 minutes
