---
name: execute-tests
description: Execute an approved test plan against a client's sandbox tenant. Use when the user says "execute tests", "run test plan", "run regression", "run the QA plan", or asks to test a feature whose test plan is already drafted. Reads the highest-version test plan, loads the matching platform skill for API access, executes each test row in the sandbox, and writes a versioned results file. Read-write only — refuses deletes and destructive actions.
---

# execute-tests

Run an approved test plan against the client's sandbox tenant and write the results. This is the terminal stage of the dydx-delivery pipeline.

## Inputs

- The latest `<Client>/testing/<feature>/test-plan_v*.md` (required, must have `status: approved`)
- Sandbox tenant credentials (loaded from the client's secrets store or provided by user)
- Platform skill loaded based on `platform:` frontmatter

## Output

`<Client>/testing/<feature>/results-YYYY-MM-DD_vN.md`

## Hard rules

> **Hard rules:** Sandbox-only operations. Read-write only against named sandbox tenants. Refuses destructive actions. See `dydx-delivery/references/safety-rules.md` for the canonical ruleset.

## How to run

### Step 1 — Locate test plan

Find the highest-version `test-plan_v*.md` in `<Client>/testing/<feature>/`.

**If not found**, run start-at-any-point triage:

> I don't see a test plan for `<Client>` / `<feature>` at `<expected path>`. How do you want to proceed?
>
> **(a) Paste an existing test plan** — I'll save it as `test-plan_v1.md` and continue
> **(b) Run `generate-test-plan` first** — recommended if you have a technical spec but no test plan yet
> **(c) Cancel**

### Step 2 — Verify approval and sandbox

Read the frontmatter:

- `status:` must be `approved`. If not, ask: "Test plan is in `<status>` — proceed anyway? (y/n)"
- `sandbox:` block must contain real tenant identifiers. If empty or `<id>` placeholders, refuse to run and explain.

### Step 3 — Load platform skill

From frontmatter `platform:`, load the matching skill (`platform-pipefy`, `platform-wrike`, etc.). The platform skill provides:

- API client construction (auth, base URL, rate limits)
- Common operation patterns (create card, update field, transition phase)
- Response parsing helpers

If no platform skill is available for the named platform, refuse to run and ask the user to provide the API contract inline or skip.

### Step 4 — Pre-flight checks

Before running any test:

1. Verify API connectivity (single read-only call to the sandbox)
2. Confirm test fixtures exist (or can be created) — list any missing fixtures and ask the user to confirm before proceeding
3. Display the test count, the sandbox tenant, and the estimated duration. Ask for explicit "go" before executing.

> **Important — explicit user confirmation required.** Do not start the run until the user replies "go", "proceed", or equivalent. This is the safety gate.

### Step 5 — Execute each test row

For each test in the plan, in order:

1. **Apply safety rules.** If the row violates a rule, log `REFUSED: <reason>` in results and continue.
2. **Set up.** Run the setup actions described in the row. If setup fails, log `SETUP_FAILED` and skip the test.
3. **Act.** Execute the action against the sandbox API. Capture request and response.
4. **Assert.** Run the assertion type against the captured response and any follow-up reads needed.
5. **Log.** Append to the results file in real-time (don't buffer — if the run aborts, partial results are still useful).

For each test, capture:

- TC-ID
- Status: `PASS`, `FAIL`, `REFUSED`, `SETUP_FAILED`, `SKIPPED`, `ERROR`
- Duration
- Request payload(s)
- Response(s)
- Assertion result (what passed, what didn't)
- Notes (e.g. "Retry 1/3 succeeded after 2.1s")

### Step 6 — Write results

Use the format in `references/results-template.md`. Write to `<Client>/testing/<feature>/results-YYYY-MM-DD_v{N}.md`.

If multiple runs happen on the same day, increment `_v{N}` and add a run identifier in the header.

### Step 7 — Hand off

End with a results summary:

> Test run complete. Results at `<path>`.
>
> **Summary:**
> - Total: <N> tests
> - Passed: <X>
> - Failed: <Y>
> - Refused: <Z>
> - Other (setup_failed / error / skipped): <W>
>
> **Top failures (if any):** <list TC-IDs>
>
> **Next steps:**
> 1. Review the results file
> 2. For each failure, determine: spec gap (update technical spec) or implementation gap (raise with implementation partner)
> 3. After fixes, re-run by calling `execute-tests` again — results write to a new dated file

## What this skill does not do

- Does not modify or create files outside the test results path
- Does not alter the test plan (read-only)
- Does not execute destructive actions even if the test plan asks for them
- Does not cleanup test data — that's a separate sandbox housekeeping concern

## Failure modes to expect

| Failure | Behaviour |
|---|---|
| Sandbox unreachable | Abort run, log `INFRA_UNREACHABLE`, write partial results |
| Auth failure | Abort run, log `AUTH_FAILED`, write partial results |
| Rate limited | Back off, retry, continue |
| Single test fails | Log result, continue to next test |
| 3 consecutive infra errors | Abort run, log `INFRA_DEGRADED`, write partial results |
| User cancels mid-run | Stop on next test boundary, write partial results |

## Quality bar

A good test run:

- Runs every test row not refused by safety rules
- Produces a results file readable in a single screen for the summary, with full detail per test
- Logs every API call for audit
- Refuses destructive actions cleanly without halting the run
- Distinguishes spec gaps from implementation gaps in failure messages where possible
