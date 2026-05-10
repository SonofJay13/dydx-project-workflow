---
name: generate-sow
description: Generate a Scope of Work (SOW) for a client engagement from an approved discovery artefact. Use when the user says "generate SOW", "draft scope of work", "create SOW for X", "write the SOW", or asks to scope a project they've already done discovery on. Reads the highest-version discovery file from the client folder, produces a versioned SOW with scope, deliverables, exclusions, assumptions, risks, dependencies, and commercial framing.
---

# generate-sow

Produce a clean, defensible Scope of Work from an approved discovery artefact. The output is the contract surface — what's in, what's out, what's assumed, what's at risk.

## Inputs

- The latest `<Client>/build-specs/<platform>/02_discovery_v*.md` (required)
- Any commercial framing the user provides inline (rates, time-and-materials vs fixed, milestone preferences)

## Output

`<Client>/build-specs/<platform>/03_sow_vN.md`

## How to run

### Step 1 — Locate upstream artefact

Find the highest-version `02_discovery_v*.md` in `<Client>/build-specs/<platform>/`.

**If not found**, run the start-at-any-point triage:

> I don't see a discovery artefact for `<Client>` at `<expected path>`. How do you want to proceed?
>
> **(a) Paste an existing brief or discovery doc** — I'll save it as `02_discovery_v1.md` and continue
> **(b) Walk through a quick inline discovery** — I'll capture the essentials in chat and stub the discovery file
> **(c) Cancel** — exit without writing

Wait for the user to choose. If (a) or (b), create the discovery stub before drafting the SOW so the audit trail stays intact.

### Step 2 — Check for existing SOW

Look for `03_sow_v*.md`. If found, ask:

> Found `03_sow_v{N}.md`. Do you want to (a) revise it as `_v{N+1}`, (b) extend in place, or (c) start fresh?

### Step 3 — Draft the SOW

Use the template at `references/sow-template.md`. The SOW is anchored on the discovery artefact — every claim in scope, exclusions, and assumptions must be traceable back to a discovery answer or marked as a new assumption.

**Order of work:**

1. **Business outcome** — copy from discovery, sharpen if needed
2. **In-scope deliverables** — list every concrete output the engagement will produce. Be specific. "Pipefy automation" is not a deliverable; "Brief intake form with conditional routing to Studio Lead or Director queue" is.
3. **Out-of-scope** — every adjacent thing the client might assume is included but isn't. Generous list. This is where misunderstanding lives.
4. **Approach and phases** — how the work is broken down. Reference the dydx-delivery pipeline stages (functional spec → technical spec → build → test → handover).
5. **Assumptions** — anything taken as true to make scoping possible. Each one is a risk if wrong.
6. **Risks and dependencies** — what could derail the timeline or quality, and what the client owes us before we can start.
7. **Acceptance** — how the client confirms each deliverable is done.
8. **Commercial framing** — rates, structure (fixed / T&M / milestone), payment cadence. Use what the user provides; mark as `**TBC**` if not given.
9. **Timeline** — high-level milestones with rough durations. Mark precision (e.g. `±2 days`).

### Step 4 — Apply senior-level challenge

Before finalising, push back on weak spots:

- Is anything in scope actually three things in a trench coat? Split it.
- Is anything in scope dependent on a client decision that hasn't been made? Move to dependencies.
- Are exclusions genuinely things the client might assume are included? Add the ones that aren't.
- Are assumptions actually unknowns that should be open questions? Demote them.

Write a short **Architectural notes** section with anything the SOW implies but doesn't explicitly cover (e.g. "this assumes a single tenant, not multi-tenant").

### Step 5 — Write and hand off

Write to `<Client>/build-specs/<platform>/03_sow_v{N}.md` with frontmatter:

```yaml
---
client: <Client>
platform: <pipefy | wrike | other>
integrations: [<...>]
version: 1
status: draft
based_on_discovery: 02_discovery_v{N}.md
generated_at: <ISO date>
---
```

End with this exact handoff message:

> SOW drafted at `<path>`.
>
> **Review steps:**
> 1. Walk the document with the commercial / project lead — does the scope match what you can defend?
> 2. Confirm exclusions are tight enough to prevent scope creep
> 3. Validate the timeline with the implementation partner
> 4. If you make edits, save as `03_sow_v{N+1}.md`
> 5. Update `status:` to `client_review` when sent, `approved` when signed
>
> When approved, run **`generate-functional-spec`** to convert scope into requirements.

## What this skill does not do

- Does not produce binding pricing — uses what the user provides or marks `**TBC**`
- Does not commit to a timeline without a real estimate from the implementation partner
- Does not invent acceptance criteria — anchors them in the deliverables list

## Quality bar

A good SOW:

- Is short enough that a non-technical stakeholder can read it in 10 minutes
- Has a list of exclusions that's at least as long as the in-scope list
- Names every assumption
- Doesn't bury risks at the end — surfaces them with the relevant scope item
