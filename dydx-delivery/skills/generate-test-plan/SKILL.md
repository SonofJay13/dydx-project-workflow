---
name: generate-test-plan
description: Generate a structured test plan from an approved Technical Specification. Use when the user says "generate test plan", "create test plan", "draft test cases", "build the QA plan", or asks to produce tests for a feature that already has a technical spec. Reads the highest-version technical spec, derives test cases from acceptance criteria and platform mappings, and writes a versioned markdown test plan ready for execution.
---

# generate-test-plan

Produce a structured, executable test plan from an approved technical spec. The output is the test plan the `execute-tests` skill will run against the client's sandbox tenant.

## Inputs

- The latest `<Client>/build-specs/<platform>/03_technical-spec_v*.md` (required)
- The functional spec (`02_functional-spec_v*.md`) for acceptance criteria reference
- A `<feature>` name (used in the output path) — ask the user if not obvious

## Output

`<Client>/testing/<feature>/test-plan_vN.md`

Format: a markdown header with sandbox metadata + a table where each row is one executable test case.

## How to run

### Step 1 — Locate upstream artefacts

Find the highest-version `03_technical-spec_v*.md`. Pull the related `02_functional-spec_v*.md` for acceptance criteria.

**If technical spec not found**, run start-at-any-point triage:

> I don't see a technical spec for `<Client>` at `<expected path>`. How do you want to proceed?
>
> **(a) Paste an existing technical spec** — I'll save it as `03_technical-spec_v1.md`
> **(b) Walk through the platform implementation inline** — I'll capture enough to derive test cases, stub the technical spec, then proceed
> **(c) Cancel**

### Step 2 — Determine feature scope and sandbox

Ask the user (if unclear):

- What `<feature>` name to use for the folder (`testing/<feature>/`). Use kebab-case.
- Which sandbox tenant to test against (e.g. Pipefy sandbox pipe ID, Wrike sandbox space ID). This must be confirmed by the client and recorded in the test plan header — the `execute-tests` skill enforces sandbox-only.

### Step 3 — Check for existing test plan

Look for `test-plan_v*.md` in `<Client>/testing/<feature>/`. If found, ask whether to revise (`_v{N+1}`), extend, or start fresh.

### Step 4 — Derive test cases

Use the template at `references/test-plan-template.md`. Build the test plan by walking three sources in order:

**1. Acceptance criteria** — every AC from the functional spec produces at least one test row. AC-1 → TC-001 minimum. ACs that have multiple variants produce multiple rows.

**2. Edge cases** — every EC from the functional spec produces a test row. These are usually the highest-value tests because they catch what nobody thinks to check.

**3. Business rules** — every BR not already covered by an AC test produces a row. Especially routing, state transitions, and conditional logic.

For each test case, fill in:

- **TC-ID** — `TC-001`, `TC-002`, etc. Stable, never renumbered.
- **Title** — short imperative (e.g. "Reject submission with past-dated deadline")
- **Maps to** — AC-X, EC-Y, BR-Z references from the functional spec
- **Setup** — the data state required before the action (e.g. "Approver Roster has user `alice` with `out_of_office: true` and `delegate: bob`")
- **Action** — the exact API call or interaction (e.g. `POST /cards { ... }` or "submit form with payload X")
- **Expected** — the observable outcome (state, field values, integration calls fired, errors raised)
- **Assertion type** — one of: `state_check`, `field_check`, `integration_called`, `error_raised`, `audit_log`
- **Sandbox-safe?** — `Yes` if the test only does reads/creates/updates; `No` if it requires deletes or destructive actions (these must be marked and `execute-tests` will refuse them)
- **Priority** — `Critical`, `Important`, `Nice-to-have`

### Step 5 — Write the test plan header

The header above the table records:

- Client and feature
- Sandbox tenant identifiers (pipe ID, space ID, or whatever maps the test scope to a real environment)
- Reference to the technical spec version this plan was derived from
- Hard rules block (copied verbatim — these are enforced by `execute-tests`)

### Step 6 — Senior-level challenge

Before finalising:

- Does every AC have at least one Critical test?
- Does every EC have a test? (These are the high-leverage tests — don't skip them.)
- Is every test row independently runnable, or do later rows depend on earlier rows? Mark dependencies if so.
- Are setup steps concrete (real test data, real user IDs from sandbox), or vague placeholders? Concrete only.
- Does any row require a destructive action? Mark `Sandbox-safe? No` and explain in a note — the runner will refuse these.

### Step 7 — Write and hand off

Write to `<Client>/testing/<feature>/test-plan_v{N}.md` with frontmatter:

```yaml
---
client: <Client>
feature: <feature>
platform: <pipefy | wrike | other>
version: 1
status: draft
based_on_technical_spec: 03_technical-spec_v{N}.md
generated_at: <ISO date>
sandbox:
  pipe_id: <id>
  space_id: <id>
  tenant: <name>
---
```

End with this exact handoff message:

> Test plan drafted at `<path>`.
>
> **Review steps:**
> 1. Walk the plan with QA / implementation lead — do the cases cover what could break?
> 2. Verify every test references real sandbox IDs, real user IDs, real fixture data
> 3. Flag any test row that needs a destructive action (these will be refused by `execute-tests`)
> 4. Confirm the sandbox tenant identifiers in the frontmatter
> 5. If you make edits, save as `test-plan_v{N+1}.md`
> 6. Update `status:` to `approved` when ready
>
> When approved, run **`generate-build-prompt`** to produce the executable build instruction set. (The build prompt references this test plan so the executor self-checks against it during the build.)

## What this skill does not do

- Does not execute tests (that's the next stage)
- Does not generate destructive test cases — flags them as `Sandbox-safe? No` for human review
- Does not invent acceptance criteria; only derives tests from approved upstream artefacts

## Quality bar

A good test plan:

- Has 100% coverage of acceptance criteria
- Has 100% coverage of edge cases
- Has every row runnable without follow-up clarification
- Has zero destructive operations expected from the runner
- Lists sandbox identifiers explicitly so there's no ambiguity about where it runs
