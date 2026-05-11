# Testing Patterns

**Analysis Date:** 2026-05-09

> This is a Claude Code plugin marketplace, not a code project. There is **no traditional code testing**: no unit tests, no integration test suite, no CI pipeline, no test runner config (no Jest / Vitest / pytest), no `*.test.*` / `*.spec.*` files. "Testing" in this repo refers to a domain workflow — running QA test plans against a client's sandbox tenant — implemented as two skills inside the `dydx-delivery` plugin: `generate-test-plan` (authoring) and `execute-tests` (running). Hard safety rules for sandbox runs live at `dydx-delivery/skills/execute-tests/references/safety-rules.md`.

---

## Test mechanism inventory

| Mechanism | File | Role |
|---|---|---|
| `generate-test-plan` skill | `dydx-delivery/skills/generate-test-plan/SKILL.md` | Authors a structured test plan from an approved technical spec |
| Test plan template | `dydx-delivery/skills/generate-test-plan/references/test-plan-template.md` | Markdown template the skill fills in |
| `execute-tests` skill | `dydx-delivery/skills/execute-tests/SKILL.md` | Runs the approved test plan against the client's sandbox tenant via platform API |
| Safety rules | `dydx-delivery/skills/execute-tests/references/safety-rules.md` | Hardcoded rules the runner enforces regardless of test plan content |
| Results template | `dydx-delivery/skills/execute-tests/references/results-template.md` | Markdown template for run output (results-YYYY-MM-DD_v{N}.md) |

There is no other test framework, no `tests/` directory in the repo, and no automated test execution against this repo itself.

---

## Pipeline position

The two test-related skills are stages 5 and 7 of the seven-stage `dydx-delivery` pipeline (per `dydx-delivery/README.md`):

```
discovery-intake → generate-sow → generate-functional-spec → generate-technical-spec
  → generate-test-plan → generate-build-prompt → [Claude Code build] → execute-tests
```

`generate-test-plan` runs in Cowork after a technical spec is approved. `execute-tests` runs in Cowork as the terminal stage, after the build is complete.

---

## `generate-test-plan` skill

**Location:** `dydx-delivery/skills/generate-test-plan/SKILL.md`

**Trigger phrases:** "generate test plan", "create test plan", "draft test cases", "build the QA plan".

**Inputs:**

- The latest `<Client>/build-specs/<platform>/03_technical-spec_v*.md` (required)
- The functional spec `02_functional-spec_v*.md` for acceptance criteria reference
- A `<feature>` name (kebab-case) used in the output path

**Output path:**

```
<Client>/testing/<feature>/test-plan_v{N}.md
```

**Test-case derivation walks three sources in order:**

1. **Acceptance criteria** — every `AC-X` from the functional spec produces at least one test row. Multi-variant ACs produce multiple rows.
2. **Edge cases** — every `EC-X` from the functional spec produces a test row.
3. **Business rules** — every `BR-X` not already covered produces a row, especially routing, state transitions, conditional logic.

**Per-test-case fields filled in:**

| Field | Notes |
|---|---|
| `TC-ID` | `TC-001`, `TC-002`, ... — stable, never renumbered |
| `Title` | Short imperative (e.g. "Reject submission with past-dated deadline") |
| `Maps to` | `AC-X`, `EC-Y`, `BR-Z` references |
| `Setup` | Concrete data state required before action |
| `Action` | Exact API call or interaction |
| `Expected` | Observable outcome |
| `Assertion type` | `state_check` / `field_check` / `integration_called` / `error_raised` / `audit_log` |
| `Sandbox-safe?` | `Yes` for read/create/update; `No` for deletes/destructive |
| `Priority` | `Critical` / `Important` / `Nice-to-have` |
| `Notes` | Free text |

**Frontmatter required on the test plan:**

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

**Header sections in the generated test plan** (per `test-plan-template.md`):

1. Sandbox metadata table (tenant, pipe ID, space ID, API endpoint, test users)
2. Hard rules block — copied verbatim, enforced by `execute-tests`
3. Test cases table
4. Test data fixtures (YAML block — users, cards, etc.)
5. Execution notes (order, cleanup, repeatability, failure handling)
6. Coverage map — `AC → Tests`, `EC → Tests`, `BR → Tests`
7. Handoff section

**Senior-level challenge questions before finalising:**

- Does every AC have at least one Critical test?
- Does every EC have a test?
- Is every test row independently runnable, or does it depend on earlier rows?
- Are setup steps concrete (real test data, real user IDs) or vague placeholders?
- Does any row require a destructive action? Mark `Sandbox-safe? No`.

**Quality bar (stated in SKILL.md):**

- 100% coverage of acceptance criteria
- 100% coverage of edge cases
- Every row runnable without follow-up clarification
- Zero destructive operations expected from the runner
- Sandbox identifiers listed explicitly

**Skill-stated non-responsibilities:**

- Does not execute tests
- Does not generate destructive test cases — flags as `Sandbox-safe? No` for human review
- Does not invent acceptance criteria; only derives tests from approved upstream artefacts

---

## `execute-tests` skill

**Location:** `dydx-delivery/skills/execute-tests/SKILL.md`

**Trigger phrases:** "execute tests", "run test plan", "run regression", "run the QA plan".

**Inputs:**

- The latest `<Client>/testing/<feature>/test-plan_v*.md` (required, must have `status: approved`)
- Sandbox tenant credentials
- Platform skill loaded based on `platform:` frontmatter (e.g. `platform-pipefy`, `platform-wrike`)

**Output path:**

```
<Client>/testing/<feature>/results-YYYY-MM-DD_v{N}.md
```

If multiple runs happen on the same day, `_v{N}` increments and a run identifier is added in the header.

**Run sequence (7 steps, per SKILL.md):**

1. **Locate test plan** — find highest-version `test-plan_v*.md`. Run start-at-any-point triage if missing.
2. **Verify approval and sandbox** — `status:` must be `approved`; `sandbox:` block must contain real tenant identifiers (not `<id>` placeholders). Asks the user to confirm if status is not approved.
3. **Load platform skill** — from `platform:` frontmatter, load matching skill providing API client construction, common operation patterns, response parsing helpers. Refuses if no platform skill is available.
4. **Pre-flight checks** —
   - Single read-only call to verify connectivity
   - Confirm fixtures exist or can be created; list missing fixtures
   - Display test count, sandbox tenant, estimated duration
   - Wait for explicit "go" / "proceed" reply (safety gate)
5. **Execute each test row** in order — apply safety rules, run setup, act, assert, log. Append to results file in real-time.
6. **Write results** using `references/results-template.md`.
7. **Hand off** — emit summary (totals, top failures, next steps).

**Per-test capture fields:**

- `TC-ID`
- `Status`: `PASS` / `FAIL` / `REFUSED` / `SETUP_FAILED` / `SKIPPED` / `ERROR`
- Duration
- Request payload(s)
- Response(s)
- Assertion result
- Notes (e.g. "Retry 1/3 succeeded after 2.1s")

**Skill-stated non-responsibilities:**

- Does not modify or create files outside the test results path
- Does not alter the test plan (read-only)
- Does not execute destructive actions even if the test plan asks for them
- Does not cleanup test data — that's a separate sandbox housekeeping concern

**Failure-mode behaviour table (per SKILL.md):**

| Failure | Behaviour |
|---|---|
| Sandbox unreachable | Abort run, log `INFRA_UNREACHABLE`, write partial results |
| Auth failure | Abort run, log `AUTH_FAILED`, write partial results |
| Rate limited | Back off, retry, continue |
| Single test fails | Log result, continue to next test |
| 3 consecutive infra errors | Abort run, log `INFRA_DEGRADED`, write partial results |
| User cancels mid-run | Stop on next test boundary, write partial results |

**Quality bar (stated in SKILL.md):**

- Runs every test row not refused by safety rules
- Produces a results file readable in a single screen for the summary, with full detail per test
- Logs every API call for audit
- Refuses destructive actions cleanly without halting the run
- Distinguishes spec gaps from implementation gaps in failure messages where possible

---

## Safety rules

**Location:** `dydx-delivery/skills/execute-tests/references/safety-rules.md`

Stated as "hardcoded into the runner. They override anything in the test plan. They are not configurable per run."

### Rule 1 — Sandbox enforcement

- On startup, read the test plan frontmatter `sandbox:` block.
- Build an allowlist of `(resource_type, resource_id)` pairs.
- Before every API call, check the call targets a resource in the allowlist.
- If non-allowlisted, refuse and log `REFUSED: out_of_sandbox`.
- **Explicit denylist:** never call APIs against production tenant identifiers, even if the test plan misconfigures `sandbox:` to point at production IDs.

### Rule 2 — No deletions

Refused operations:

| Platform | Refused operations |
|---|---|
| Pipefy GraphQL | `deleteCard`, `deletePipe`, `deletePhase`, `deleteOrganization`, `deleteTable`, `deleteTableRecord`, `deleteWebhook` |
| Wrike REST | `DELETE /tasks/{id}`, `DELETE /folders/{id}`, `DELETE /workflows/{id}`, any `DELETE` HTTP verb |
| Generic | Any operation containing `delete_`, `remove_`, or `destroy_` |

Logged as `REFUSED: delete_blocked` with the operation name.

### Rule 3 — No destructive integrations outside scope

Refused unless the test plan explicitly lists them in scope **AND** the integration is pointed at a sandbox / mock endpoint:

- Sending real emails to non-test recipients
- Posting to real Slack channels (only `#test-*` channels permitted)
- Triggering real Ziflow proofs (sandbox project only)
- Triggering real billing or invoice generation
- Calling third-party publishing APIs (social, CMS push)

**Detection:** runner inspects action description and target endpoint; if a known production integration endpoint is targeted, refuse.

### Rule 4 — Read-write only

- Permitted: `create_*` / `POST`, `update_*` / `PATCH` / `PUT`, `read_*` / `GET`, `transition_*` / phase moves (subject to rule 3).
- Refused: `delete_*` (rule 2), anything that fires a destructive integration (rule 3).

### Rule 5 — Audit trail

Every API call **and** every refusal logged. Format:

```
[timestamp] TC-XXX | <PASS | FAIL | REFUSED:<reason> | ERROR:<class>>
  request:  <method> <url>
            <payload>
  response: <status>
            <body>
  notes:    <retry count, etc.>
```

Silent refusals not allowed.

### Rule 6 — Rate limiting

| Platform | Default limit | Runner behaviour |
|---|---|---|
| Pipefy GraphQL | 100 req/min per token | Buffer at 80; back off on 429 |
| Wrike REST | 200 req/min per token | Buffer at 160; back off on 429 |
| Generic | (read from platform skill) | Buffer at 80% |

On `429 Too Many Requests`: wait per `Retry-After` header (or 5s if absent), retry once, then continue.

### Rule 7 — Stop conditions

The runner aborts (writes partial results, exits cleanly) if:

- 3 consecutive tests fail with infrastructure errors (5xx, timeout, network)
- Auth failure (401/403) on any call
- Sandbox unreachable on pre-flight check
- User cancellation
- Any operation attempts to escape sandbox enforcement (rule 1) — treated as a critical bug

### Rule 8 — Concurrency

Tests run sequentially by default. Parallel execution is not supported in v1 (avoids state contention in shared sandboxes).

### Rule 9 — Cleanup

Runner does not delete test data. Sandbox housekeeping is a separate concern. Tests that rely on a clean state must include setup steps that reset fixtures **without** delete operations.

### Rule 10 — Reporting

Every refusal goes into the results file with enough context for a human to understand why. The runner does not silently fix or work around refusals.

---

## Results format

**Location:** `dydx-delivery/skills/execute-tests/references/results-template.md`

**Frontmatter:**

```yaml
---
client: <CLIENT_NAME>
feature: <feature-slug>
platform: <pipefy | wrike | other>
version: 1
based_on_test_plan: test-plan_v<N>.md
run_started_at: <ISO datetime>
run_finished_at: <ISO datetime>
runner: dydx-delivery/execute-tests v0.1.0
sandbox:
  pipe_id: <id>
  space_id: <id>
  tenant: <name>
---
```

**Body sections (in order):**

1. **Summary table** — Total / Passed / Failed / Refused / Setup failed / Errors / Skipped / Duration / Average per test
2. **Verdict** — `GREEN — all critical pass` | `YELLOW — non-critical failures only` | `RED — critical failures`
3. **Failures** — per-failure block: TC-ID, Maps to (`AC-X`, `BR-Y`), Status, Likely cause (`spec gap | implementation gap | environment issue | unknown`), Detail, Suggested action. Critical failures listed first.
4. **Refusals** — per-refusal block: TC-ID, Reason (`REFUSED: <delete_blocked | out_of_sandbox | destructive_integration>`), Action attempted, Suggested action.
5. **Per-test detail** — every TC with Status, Duration, Setup, Action (full request), Response (full body), Assertion, Notes.
6. **Coverage** — `AC → TC → Result` table.
7. **Audit log** — block of timestamped entries (one per API call). May spill to sibling `results-YYYY-MM-DD_v<N>_audit.log` if very large.
8. **Recommendations** — per-failure analysis bullets.
9. **Re-run** — instruction to call `execute-tests` again; new dated file allows cross-run regression comparison.

---

## What is verified vs not verified

### Verified by `execute-tests`

- Every test row in the test plan that is not refused by safety rules
- Outcomes captured as `state_check`, `field_check`, `integration_called`, `error_raised`, `audit_log`
- Coverage of `AC-X` IDs (every AC ID listed in the plan ends up in the coverage map of the results)
- API call sequencing, retry behaviour on 429, retry behaviour on integration 5xx (per test plan rows like `TC-007 Ziflow 5xx triggers retry then logs`)
- That the runner refuses prohibited operations (refusals logged with reason, run continues)

### Not verified

- The `dydx-delivery` plugin code itself (no unit tests for the skills)
- The marketplace install / update process (no automated CI for plugin publication)
- Test data cleanup (rule 9 — sandbox housekeeping is out of scope)
- Time-based behaviour without fixture clock manipulation (test plan template flags `TC-006 Time-based; may need fixture clock manipulation` as a runner concern)
- Anything in production tenants (rule 1 hard-denies even if user misconfigures)
- Any operation requiring a delete (rule 2)
- Any destructive integration outside the test scope (rule 3)
- Parallel test execution (rule 8 — sequential only in v1)

---

## Test status taxonomy (closed sets)

**Per-test status:** `PASS`, `FAIL`, `REFUSED`, `SETUP_FAILED`, `SKIPPED`, `ERROR`.

**Refusal reason codes:** `delete_blocked`, `out_of_sandbox`, `destructive_integration`.

**Run-level abort codes:** `INFRA_UNREACHABLE`, `AUTH_FAILED`, `INFRA_DEGRADED`.

**Run-level verdict:** `GREEN`, `YELLOW`, `RED`.

**Failure-cause classification (in failure block):** `spec gap`, `implementation gap`, `environment issue`, `unknown`.

**Assertion types:** `state_check`, `field_check`, `integration_called`, `error_raised`, `audit_log`.

**Test priority:** `Critical`, `Important`, `Nice-to-have`.

**Sandbox-safety flag:** `Yes`, `No`.

---

## Coverage tracking

The test plan template includes three coverage maps (acceptance criteria → tests, edge cases → tests, business rules → tests). The results template includes a single coverage map (acceptance criteria → tests → result).

This is the only coverage mechanism in the repo. There is no source-code coverage tooling.

---

## Re-run / regression model

- Each run writes a new `results-YYYY-MM-DD_v{N}.md` (never overwrites).
- Comparing files across runs surfaces regressions.
- The handoff message in `execute-tests` directs users: "For each failure, determine: spec gap (update technical spec) or implementation gap (raise with implementation partner). After fixes, re-run by calling `execute-tests` again — results write to a new dated file."

---

## Build-time self-test (separate from `execute-tests`)

Documented in `dydx-delivery/skills/generate-build-prompt/SKILL.md` and `references/build-prompt-template.md` section 7 ("Self-test loop"). Not part of the `execute-tests` skill — it is an instruction the build prompt gives to Claude Code during the build:

- After each major build item, run a smoke subset of test plan rows against the sandbox.
- Subset is listed in the build prompt by TC-IDs (e.g. `TC-001, TC-003, TC-005`).
- Stop on failure; classify as build issue (fix and re-run) vs spec gap (stop and surface to user).
- Full test plan is **not** run during the build — that is `execute-tests`'s job in Cowork after the build.

---

*Testing analysis: 2026-05-09*
