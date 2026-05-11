---
name: generate-sow
description: Generate a Scope of Work (SOW) for a client engagement from an approved discovery artefact. Use when the user says "generate SOW", "draft scope of work", "create SOW for X", "write the SOW", or asks to scope a project they've already done discovery on. Reads the highest-version discovery file from the client folder, produces a versioned SOW with scope, deliverables, exclusions, assumptions, risks, dependencies, and commercial framing.
---

# generate-sow

Produce a clean, defensible Scope of Work from an approved discovery artefact. The output is the contract surface — what's in, what's out, what's assumed, what's at risk.

## Inputs

Generate-sow has a **dual upstream input contract** per DESIGN-19 lines 635-636 + 643. Exactly one of the two upstream paths must be present — never both:

- **Discovery-ready path** (Stage 2 ran): the latest `status: approved` `<Client>/build-specs/<platform>/02_discovery_v<N>.md`. The new SOW frontmatter carries `based_on_discovery: 02_discovery_v<N>.md`.
- **Draft-sow path** (Stage 2 skipped per STG2-02): the latest `status: approved` `<Client>/build-specs/<platform>/01_kickoff_v<N>.md` carrying `kickoff_branch: draft-sow`. The new SOW frontmatter carries `based_on_kickoff: 01_kickoff_v<N>.md`.

One or the other, NOT both per DESIGN-19 line 643.

The SOW artefact covers BOTH platform AND integration scope as a single artefact (per STG3-02 + D-75). Splitting by platform vs integration happens at Stage 4 (Fnspec) per DESIGN-20 — not here.

- Any commercial framing the user provides inline (rates, time-and-materials vs fixed, milestone preferences)

## Output

`<Client>/build-specs/<platform>/03_sow_vN.md`

## How to run

### Step 1 — Locate upstream artefact

Apply the dual-input triage per DESIGN-19 lines 635-636 + 643:

1. Read the latest `status: approved` `01_kickoff_v<N>.md` for this `<Client>` + `<platform>`.
2. Read `kickoff_branch:` from the kickoff frontmatter:
   - If `kickoff_branch: discovery-ready` → look for the latest `status: approved` `02_discovery_v<N>.md` in the same folder. The new SOW frontmatter will carry `based_on_discovery: 02_discovery_v<N>.md`.
   - If `kickoff_branch: draft-sow` → use the kickoff directly (Stage 2 was skipped per STG2-02). The new SOW frontmatter will carry `based_on_kickoff: 01_kickoff_v<N>.md`.
3. If neither approved upstream is found, emit an explicit error directing the reviewer to run the upstream stage first:

> Cannot draft SOW for `<Client>` — no approved `01_kickoff_v*.md` (and on the discovery-ready branch, no approved `02_discovery_v*.md`) found at `<expected path>`. Run **`kickoff-capture`** first (and **`discovery-intake`** if `kickoff_branch: discovery-ready`), then re-run **`generate-sow`**.

Do NOT inline-stub upstream artefacts from this skill — that breaks the kickoff → discovery → SOW audit chain established in Phase 7.

### Step 2 — Check for existing SOW

Look for `03_sow_v*.md`. If found, ask:

> Found `03_sow_v{N}.md`. Do you want to (a) revise it as `_v{N+1}`, (b) extend in place, or (c) start fresh?

### Step 3 — Draft the SOW

Use the template at `references/sow-template.md`. The SOW is anchored on the upstream artefact (discovery on the discovery-ready path; kickoff on the draft-sow path) — every claim in scope, exclusions, and assumptions must be traceable back to an upstream answer or marked as a new assumption.

Deliverables now split into two top-level H2 sections per STG3-02 + D-75: `## Platform Scope` (consumed by Stage 4a `generate-fnspec-platform`) and `## Integration Scope` (consumed by Stage 4b `generate-fnspec-integration`). The template carries the load-bearing dual-scope split; populate each section from the upstream artefact.

**Order of work:**

1. **Business outcome** — copy from upstream (kickoff or discovery), sharpen if needed
2. **In-scope deliverables — `## Platform Scope`** — list every concrete platform configuration output the engagement will produce (Pipefy / Wrike / Ziflow configuration). Be specific. "Pipefy automation" is not a deliverable; "Brief intake form with conditional routing to Studio Lead or Director queue" is.
3. **In-scope deliverables — `## Integration Scope`** — list every inbound/outbound integration output (custom APIs, webhooks, ETL, external-system handoffs). If the engagement has no integration work, note "no integration scope" — Stage 4b will then skip cleanly.
4. **Out-of-scope** — every adjacent thing the client might assume is included but isn't. Generous list. This is where misunderstanding lives.
5. **Approach and phases** — how the work is broken down. Reference the dydx-delivery pipeline stages (Stage 4a/4b functional spec → technical spec → build → test → handover).
6. **Assumptions** — anything taken as true to make scoping possible. Each one is a risk if wrong.
7. **Risks and dependencies** — what could derail the timeline or quality, and what the client owes us before we can start.
8. **Acceptance** — how the client confirms each deliverable is done.
9. **Commercial framing** — rates, structure (fixed / T&M / milestone), payment cadence. Use what the user provides; mark as `**TBC**` if not given.
10. **Timeline** — high-level milestones with rough durations. Mark precision (e.g. `±2 days`).

### Step 4 — Apply senior-level challenge

Before finalising, push back on weak spots:

- Is anything in scope actually three things in a trench coat? Split it.
- Is anything in scope dependent on a client decision that hasn't been made? Move to dependencies.
- Are exclusions genuinely things the client might assume are included? Add the ones that aren't.
- Are assumptions actually unknowns that should be open questions? Demote them.

Write a short **Architectural notes** section with anything the SOW implies but doesn't explicitly cover (e.g. "this assumes a single tenant, not multi-tenant").

### Step 5 — Write and hand off

Write to `<Client>/build-specs/<platform>/03_sow_v{N}.md` with frontmatter per DESIGN-19 line 643. Reviewer picks ONE of `based_on_discovery:` or `based_on_kickoff:` — never both:

```yaml
---
client: <Client>
platform: <pipefy | wrike | ziflow | other>
integrations: [<...>]
frontmatter_version: 2
version: 1
status: draft
# One or the other — never both per DESIGN-19 line 643:
based_on_discovery: 02_discovery_v{N}.md   # discovery-ready path (Stage 2 ran)
# based_on_kickoff: 01_kickoff_v{N}.md     # draft-sow path (Stage 2 skipped)
generated_at: <ISO date>
---
```

Status lifecycle (canonical per STG3-01 + DESIGN-08 + AUDIT-01.2): `draft → client_review → approved → archived`. generate-sow is the sole skill retaining `client_review` — the interim commercial-review state is a real workflow stage, not a v0.3.0 quirk.

End with this exact handoff message:

> SOW drafted at `<path>`.
>
> **Review steps:**
> 1. Walk the document with the commercial / project lead — does the scope match what you can defend?
> 2. Confirm exclusions are tight enough to prevent scope creep
> 3. Validate the timeline with the implementation partner
> 4. If you make edits, save as `03_sow_v{N+1}.md`
> 5. Update `status:` to `client_review` when sent, `approved` when signed, `archived` at Stage 11 sign-off
>
> Awaiting status: approved on 03_sow_v<N>.md; routing to Stage 4a (platform fnspec) and/or Stage 4b (integration fnspec) per project scope.

## What this skill does not do

- Does not produce binding pricing — uses what the user provides or marks `**TBC**`
- Does not commit to a timeline without a real estimate from the implementation partner
- Does not invent acceptance criteria — anchors them in the deliverables list
- Does NOT split scope by platform vs integration at the artefact level — that split happens at Stage 4 (Fnspec). The single SOW artefact carries both as `## Platform Scope` + `## Integration Scope` H2 sections (per DESIGN-19 + STG3-02 + D-75).

## Quality bar

A good SOW:

- Is short enough that a non-technical stakeholder can read it in 10 minutes
- Has a list of exclusions that's at least as long as the in-scope list
- Names every assumption
- Doesn't bury risks at the end — surfaces them with the relevant scope item
