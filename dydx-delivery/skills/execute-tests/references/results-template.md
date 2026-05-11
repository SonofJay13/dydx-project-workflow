---
client: <CLIENT_NAME>
feature: <feature-slug>
platform: <pipefy | wrike | ziflow | other>
version: 1
based_on_test_plan: 08b_test-plan_v<N>.md
run_started_at: <ISO datetime>
run_finished_at: <ISO datetime>
runner: dydx-delivery/execute-tests v0.1.0
sandbox:
  pipe_id: <id>
  space_id: <id>
  tenant: <name>
---

# Test Results — <CLIENT_NAME> · <feature> · <YYYY-MM-DD>

> Stage 8d of the dydx-delivery pipeline. Output of one test run.

---

## Summary

| Metric | Value |
|---|---|
| Total tests | <N> |
| Passed | <X> |
| Failed | <Y> |
| Refused | <Z> |
| Setup failed | <A> |
| Errors | <B> |
| Skipped | <C> |
| Duration | <total time> |
| Average per test | <avg> |

**Verdict:** <GREEN — all critical pass | YELLOW — non-critical failures only | RED — critical failures>

---

## Failures (if any)

> Critical failures listed first.

### TC-XXX — <Title>

- **Maps to:** AC-X, BR-Y
- **Status:** FAIL
- **Likely cause:** <spec gap | implementation gap | environment issue | unknown>
- **Detail:** <what was expected vs what was returned>
- **Suggested action:** <e.g. raise with implementation partner; update technical spec; re-run>

---

## Refusals (if any)

> Operations the runner refused per safety rules.

### TC-XXX — <Title>

- **Reason:** REFUSED: <delete_blocked | out_of_sandbox | destructive_integration>
- **Action attempted:** <description>
- **Suggested action:** <e.g. remove this row from the test plan; redesign as non-destructive>

---

## Per-test detail

### TC-001 — <Title>

- **Status:** PASS
- **Duration:** 0.42s
- **Setup:** <executed steps>
- **Action:**
  ```
  POST https://api.pipefy.com/graphql
  { "query": "mutation { createCard(...) { ... } }" }
  ```
- **Response:**
  ```
  200 OK
  { "data": { "createCard": { "card": { "id": "12345", "current_phase": { "name": "Submitted" } } } } }
  ```
- **Assertion:** card.current_phase.name == "Submitted" → PASS
- **Notes:** —

### TC-002 — <Title>

<Repeat structure for each test>

---

## Coverage

| AC | Tested | Result |
|---|---|---|
| AC-1 | TC-001 | PASS |
| AC-2 | TC-003, TC-004 | PASS |
| AC-3 | TC-006 | FAIL |
| AC-4 | TC-005 | PASS |
| AC-5 | TC-002 | PASS |
| AC-6 | TC-007 | PASS |

---

## Audit log

> Every API call made during the run.

```
[2026-05-05T09:12:01Z] TC-001 | PASS
  request:  POST https://api.pipefy.com/graphql
            { ... }
  response: 200 { ... }
  notes:    —

[2026-05-05T09:12:02Z] TC-002 | PASS
  ...
```

(Full audit log appended below or in a sibling file `08d_test-results_v<N>_audit.log` if very large.)

---

## Recommendations

Based on this run:

- <e.g. TC-006 SLA escalation failed — likely scheduled automation isn't firing in sandbox; verify with implementation partner>
- <e.g. TC-007 retry logic worked but only after 2 retries, not 3 — check whether retry count is correctly configured>

---

## Re-run

To re-run after fixes:

```
execute-tests
```

Results will write to a new dated file. Comparing across runs surfaces regressions.
