---
name: generate-technical-spec
description: Generate a Technical Specification from an approved Functional Specification, mapping requirements to a specific platform (Pipefy, Wrike, etc.). Use when the user says "generate technical spec", "draft tech spec", "create the technical design", "map functional spec to Pipefy", "map to Wrike", or asks for the platform implementation plan. Reads the highest-version functional spec, loads the matching platform skill, produces pipes/blueprints, automation logic, field mappings, integration contracts, error handling, and observability hooks.
---

# generate-technical-spec

Translate an approved functional spec into a platform-specific implementation plan. This is the artefact the implementation partner builds from — every functional requirement must trace to a concrete platform construct.

## Inputs

- The latest `<Client>/build-specs/<platform>/04a_fnspec-platform_v*.md` (required)
- Frontmatter `platform:` field (drives platform skill selection)
- Discovery + SOW for context

## Output

`<Client>/build-specs/<platform>/05_techspec_vN.md`

## How to run

### Step 1 — Locate upstream artefact and platform

Find the highest-version `04a_fnspec-platform_v*.md`. Read its frontmatter to get `platform:` and `integrations:`.

**If functional spec not found**, run start-at-any-point triage:

> I don't see a functional spec for `<Client>` at `<expected path>`. How do you want to proceed?
>
> **(a) Paste an existing functional spec** — I'll save it as `04a_fnspec-platform_v1.md`
> **(b) Walk through requirements inline** — I'll capture user journeys, business rules, and acceptance criteria, stub the functional spec, then proceed
> **(c) Cancel**

### Step 2 — Load the platform skill

Based on `platform:` frontmatter, load the matching skill:

- `platform: pipefy` → load the `platform-pipefy` skill
- `platform: wrike` → load the `platform-wrike` skill
- `platform: other` → ask the user which platform skill (if any) applies, otherwise proceed with platform-agnostic patterns and flag the gap

The platform skill provides the vocabulary and constructs (Pipefy phases, fields, automations, GraphQL; Wrike custom item types, blueprints, request forms, etc.). Use that vocabulary throughout the technical spec.

### Step 3 — Check for existing technical spec

Look for `05_techspec_v*.md`. If found, ask whether to revise (`_v{N+1}`), extend, or start fresh.

### Step 4 — Draft the technical spec

Use the template at `references/technical-spec-template.md`. Work through these sections in order:

**1. Architecture overview** — one diagram (mermaid or ascii) plus a paragraph. Show the platform, the integrations, the data flow, the trigger points.

**2. Platform constructs** — translate every functional spec entity into platform constructs. For Pipefy: pipes, phases, fields, connections, databases. For Wrike: spaces, projects, custom item types, blueprints, request forms, workflows.

**3. Field mappings** — every field in section 5 of the functional spec maps to a concrete platform field. Include type, validation, default, source. Flag any field type the platform can't natively support.

**4. State / phase mapping** — translate the state model into the platform's workflow model. Identify the trigger for each transition.

**5. Automation logic** — for each business rule (BR-X), specify how it's implemented. Pipefy: which automation event, which condition, which action. Wrike: which blueprint, which workflow status, which approval flow.

**6. Integration contracts** — for each integration in `integrations:` frontmatter, specify:
   - Endpoint / API method
   - Trigger (when does the integration fire?)
   - Auth method
   - Payload structure (sample request + response)
   - Error handling (retries, circuit breaker, dead letter)
   - Idempotency key strategy

**7. Error handling and observability** — for each failure point in the functional spec edge cases:
   - Where the error is caught
   - What's logged (and where)
   - What the user sees
   - What the support team sees

**8. Security and access control** — who can read/write each pipe/space, role mapping, sensitive field masking.

**9. Migration / data load** — if applicable, how existing data is brought in.

**10. Open technical questions** — anything that needs the implementation partner's input or platform team's confirmation.

### Step 5 — Senior-level challenge

Before finalising:

- Does every business rule from the functional spec have a corresponding automation entry?
- Is anything over-engineered? Could a simpler construct (e.g. native conditional field vs custom automation) do the job?
- Are integration error paths actually defined, or just hand-waved?
- Is the spec testable? Could a QA lead write a test plan from this?
- Does the spec rely on any platform feature that requires a higher tier (Pipefy Business+, Wrike Pinnacle)? Flag explicitly.

Write a short **Trade-offs and decisions** section with anything where you chose one approach over another, and why.

### Step 6 — Write and hand off

Write to `<Client>/build-specs/<platform>/05_techspec_v{N}.md` with frontmatter:

```yaml
---
client: <Client>
platform: <pipefy | wrike | ziflow | other>
integrations: [<...>]
version: 1
status: draft
based_on_functional_spec: 04a_fnspec-platform_v{N}.md
generated_at: <ISO date>
---
```

End with this exact handoff message:

> Technical spec drafted at `<path>`.
>
> **Review steps:**
> 1. Walk the spec with the implementation partner — can they build from it without follow-up?
> 2. Validate platform constructs against the actual tenant (does the licence support what we need?)
> 3. Confirm integration contracts with integration owners (real auth, real endpoints, real rate limits)
> 4. If you make edits, save as `05_techspec_v{N+1}.md`
> 5. Update `status:` to `approved` when signed off
>
> When approved, run **`generate-test-plan`** to derive test cases from the acceptance criteria and platform mappings.

## Platform-specific behaviour

Each loaded platform skill should provide:

- A construct vocabulary (which terms to use)
- A mapping table for common functional spec elements
- Tenant-level considerations (licence tiers, API rate limits, automation limits)
- Reference patterns for common workflows

If the loaded platform skill doesn't cover a needed construct, flag it as an open technical question rather than guessing.

## What this skill does not do

- Does not produce platform configuration files or scripts (build artefacts, not specs)
- Does not invent platform features that don't exist on the client's licence tier
- Does not include test cases — that's the next stage

## Quality bar

A good technical spec:

- Is buildable by an implementation partner without needing a workshop
- Names every platform construct in the platform's actual vocabulary
- Has zero hand-waved error paths
- Flags every assumption about licence tier, API access, or third-party readiness
- Traces every functional requirement to a platform construct
