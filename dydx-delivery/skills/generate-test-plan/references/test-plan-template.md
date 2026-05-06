---
client: <CLIENT_NAME>
feature: <feature-slug>
platform: <pipefy | wrike | other>
version: 1
status: draft
based_on_technical_spec: 03_technical-spec_v<N>.md
generated_at: <YYYY-MM-DD>
sandbox:
  pipe_id: <id>
  space_id: <id>
  tenant: <name>
---

# Test Plan — <CLIENT_NAME> · <feature>

> Stage 5 of the dydx-delivery pipeline. Executable test plan derived from the technical spec. Each row is one runnable test.

---

## Sandbox metadata

| Item | Value |
|---|---|
| Tenant | <e.g. up-and-up-sandbox> |
| Pipe ID | <e.g. 123456789> |
| Space ID | <e.g. IEAGS6BYI4XYZ> |
| API endpoint | <e.g. https://api.pipefy.com/graphql> |
| Test user 1 | <e.g. test.requester@dydx.local> |
| Test user 2 | <e.g. test.lead@dydx.local> |
| Approver under test | <e.g. test.alice@dydx.local> |
| Delegate under test | <e.g. test.bob@dydx.local> |

---

## Hard rules (enforced by `execute-tests`)

> Do not modify these. They are enforced regardless of test plan content.

- **Sandbox only** — runs only against the IDs above
- **No deletions** — `delete_*` API calls are refused
- **No destructive automations** — won't trigger phase moves or webhooks that fire external integrations not in scope (real emails, invoices, billing, third-party publishing)
- **Read-write only** — create / update allowed; deletes refused with a logged warning
- **Audit trail** — every API call logged in the results file

---

## Test cases

| TC-ID | Title | Maps to | Setup | Action | Expected | Assertion type | Sandbox-safe? | Priority | Notes |
|---|---|---|---|---|---|---|---|---|---|
| TC-001 | Submit valid brief creates work item | AC-1, BR-1 | None | `POST /cards { title: "Test", description: "Test description >20 chars", deadline: "+30d", team: "Studio" }` | Card created in `Submitted` phase, all mandatory fields populated | `state_check`, `field_check` | Yes | Critical | — |
| TC-002 | Reject submission with deadline in past | EC-5, BR-1 | None | `POST /cards { ..., deadline: "-1d" }` | Validation error; no card created | `error_raised` | Yes | Critical | — |
| TC-003 | Brief with value > 50000 routes to Director Queue | AC-2, BR-2, BR-3 | None | `POST /cards { ..., value: 75000 }` | Card created; phase = `Director Queue`, not `Studio Lead Queue` | `state_check`, `field_check` | Yes | Critical | — |
| TC-004 | Brief with value ≤ 50000 routes to Studio Lead Queue | AC-2, BR-3 | None | `POST /cards { ..., value: 25000 }` | Card created; phase = `Studio Lead Queue` | `state_check`, `field_check` | Yes | Critical | — |
| TC-005 | OoO approver bypassed; delegate receives request | AC-4, BR-5 | Set `alice.out_of_office = true`, `alice.delegate = bob` | Create card requiring approval; transition to `In Review` | Approval routed to `bob`, not `alice` | `field_check`, `audit_log` | Yes | Critical | — |
| TC-006 | SLA breach (>48h) escalates to delegate | AC-3, BR-4 | Card in `In Review` for >48h, approver still alice | Wait for scheduled automation tick (or trigger manually) | Approval reassigned to delegate; audit log entry recorded | `field_check`, `audit_log` | Yes | Important | Time-based; may need fixture clock manipulation |
| TC-007 | Ziflow 5xx triggers retry then logs | AC-6, EC-3 | Mock Ziflow endpoint to return 503 for first 3 calls, 200 on 4th | Transition card to `Approved` phase | After 3 retries, integration succeeds OR after 3 retries fails and Ops alerted; audit log shows retry sequence | `integration_called`, `audit_log` | Yes | Important | Requires mock or sandbox Ziflow tenant |
| TC-008 | Concurrent edit logs conflict | EC-4 | Two sessions open same card simultaneously | Both submit edits to `description` | Last-write-wins on field; conflict log entry recorded | `field_check`, `audit_log` | Yes | Nice-to-have | — |

---

## Test data fixtures

> Reusable test data. Reference by name from the test cases above.

```yaml
users:
  test_requester:
    email: test.requester@dydx.local
    role: requester
  test_studio_lead:
    email: test.lead@dydx.local
    role: studio_lead
  test_alice:
    email: test.alice@dydx.local
    role: approver
    out_of_office: true
    delegate: test_bob
  test_bob:
    email: test.bob@dydx.local
    role: approver

cards:
  valid_brief:
    title: "Test brief"
    description: "Test description with at least twenty characters."
    deadline: "+30d"  # relative to test run time
    team: "Studio"
    value: 25000
    priority: "Medium"

  high_value_brief:
    <<: *valid_brief
    value: 75000

  past_deadline_brief:
    <<: *valid_brief
    deadline: "-1d"
```

---

## Execution notes

- **Order:** TC-001 through TC-005 are independent; TC-006 depends on a card created in an earlier step (note dependency in setup).
- **Cleanup:** test cases create cards but never delete them. Sandbox is reset on a separate cadence by the team.
- **Repeatability:** every test must be re-runnable without manual setup beyond the fixtures above.
- **Failure handling:** if a test fails, runner continues to the next test and reports all results at the end.

---

## Coverage map

| Acceptance criterion | Tests |
|---|---|
| AC-1 | TC-001 |
| AC-2 | TC-003, TC-004 |
| AC-3 | TC-006 |
| AC-4 | TC-005 |
| AC-5 | TC-002 |
| AC-6 | TC-007 |

| Edge case | Tests |
|---|---|
| EC-3 | TC-007 |
| EC-4 | TC-008 |
| EC-5 | TC-002 |

| Business rule | Tests |
|---|---|
| BR-1 | TC-001, TC-002 |
| BR-2 | TC-003 |
| BR-3 | TC-003, TC-004 |
| BR-4 | TC-006 |
| BR-5 | TC-005 |

---

## Handoff

When this test plan is approved:

1. Update `status:` to `approved`
2. Run `generate-build-prompt` to produce the executable build instruction set
3. Once the build is complete, run `execute-tests` to run this plan against the sandbox tenant

**Next stage (`generate-build-prompt`) reads:** this test plan plus the technical spec.
**Final stage (`execute-tests`) reads:** the highest-version `test-plan_v*.md` in this folder.
