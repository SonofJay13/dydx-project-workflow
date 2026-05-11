---
name: generate-functional-spec
description: Generate a Functional Specification from an approved SOW. Use when the user says "generate functional spec", "draft functional specification", "create the FRD", "translate SOW to requirements", or asks to define what the system should do (without yet specifying how). Reads the highest-version SOW from the client folder, produces user journeys, business rules, field-level requirements, edge cases, and acceptance criteria — platform-agnostic.
---

# generate-functional-spec

Translate an approved SOW into a detailed, platform-agnostic specification of what the system must do. This is the bridge between business intent and technical design — every requirement here must be testable.

## Inputs

- The latest `<Client>/build-specs/<platform>/03_sow_v*.md` (required)
- Discovery artefact (`02_discovery_v*.md`) for context
- Any clarifying detail the user provides inline

## Output

`<Client>/build-specs/<platform>/04a_fnspec-platform_vN.md`

## How to run

### Step 1 — Locate upstream artefact

Find the highest-version `03_sow_v*.md`.

**If not found**, run start-at-any-point triage:

> I don't see an SOW for `<Client>` at `<expected path>`. How do you want to proceed?
>
> **(a) Paste an existing SOW** — I'll save it as `03_sow_v1.md` and continue
> **(b) Walk through scope inline** — I'll capture the in-scope deliverables in chat and stub the SOW
> **(c) Cancel**

### Step 2 — Check for existing functional spec

Look for `04a_fnspec-platform_v*.md`. If found, ask whether to revise (`_v{N+1}`), extend, or start fresh.

### Step 3 — Draft the functional spec

Use the template at `references/functional-spec-template.md`. Work deliverable-by-deliverable from the SOW. For each in-scope deliverable, produce:

**1. User journey** — step-by-step what each user role does, with system response. Include happy path and the major variants.

**2. Business rules** — the conditional logic. "If X, then Y, else Z." Number them so they can be referenced by the technical spec and test plan.

**3. Field-level requirements** — every data field involved: name, type, validation, mandatory/optional, default, source. Capture these in a flat list, not buried in prose.

**4. State model** — the lifecycle of the work item. States, transitions, who/what triggers each transition.

**5. Edge cases** — what happens when:
- A user submits incomplete data?
- An approver is on leave with no delegate?
- An integration is down or returns an error?
- A user tries to skip a required step?
- Multiple users edit the same item simultaneously?

**6. Acceptance criteria** — testable, observable conditions. Each one becomes a row (or rows) in the test plan.

**Important — keep it platform-agnostic.** Don't write "Pipefy phase" or "Wrike custom field" here. Write "approval state" or "priority field." Platform mapping happens in the technical spec.

### Step 4 — Senior-level challenge

Before finalising, pressure-test:

- Is every business rule numbered and unambiguous? Reword anything that can be read two ways.
- Does every deliverable in the SOW have at least one user journey + acceptance criteria block? If not, the SOW is incomplete.
- Are edge cases concrete or generic? "Handle errors gracefully" is not an edge case — "If Ziflow returns 401, queue the request for retry up to 3 times then raise a support ticket" is.
- Is anything in here secretly a technical decision? Move it to the technical spec.

### Step 5 — Write and hand off

Write to `<Client>/build-specs/<platform>/04a_fnspec-platform_v{N}.md` with frontmatter:

```yaml
---
client: <Client>
platform: <pipefy | wrike | other>
integrations: [<...>]
version: 1
status: draft
based_on_sow: 03_sow_v{N}.md
generated_at: <ISO date>
---
```

End with this exact handoff message:

> Functional spec drafted at `<path>`.
>
> **Review steps:**
> 1. Walk the spec with the client SME for the workflow — does it match how they actually work?
> 2. Validate every business rule and edge case against real cases the SME has seen
> 3. Check that every SOW deliverable has acceptance criteria
> 4. If you make edits, save as `04a_fnspec-platform_v{N+1}.md`
> 5. Update `status:` to `approved` when signed off
>
> When approved, run **`generate-technical-spec`** to map requirements to platform implementation.

## What this skill does not do

- Does not specify platform implementation — that's stage 4
- Does not include test cases — those come from the test plan stage, derived from acceptance criteria
- Does not invent business rules; if a rule is unclear, surfaces it as an open question

## Quality bar

A good functional spec:

- Lets the implementation partner build the right thing without needing a workshop
- Lets QA write a test plan from it
- Survives a six-month gap — readable when nobody remembers the original conversation
- Has numbered business rules referenced from the technical spec and test plan
