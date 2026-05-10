---
client: <CLIENT_NAME>
platform: <pipefy | wrike | other>
integrations: []
version: 1
status: draft
based_on_sow: 03_sow_v<N>.md
generated_at: <YYYY-MM-DD>
---

# Functional Specification — <CLIENT_NAME> · <ENGAGEMENT_NAME>

> Stage 2 of the dydx-delivery pipeline. Defines **what** the system must do — platform-agnostic. Every business rule and acceptance criterion here must be testable.

---

## 1. Scope summary

**In-scope deliverables (from SOW):**

- D1: <Deliverable name>
- D2: <Deliverable name>

---

## 2. User roles

| Role | Description | System access |
|---|---|---|
| <Brief Requester> | <Submits creative briefs> | <Read/write own briefs> |
| <Studio Lead> | <Reviews and assigns> | <Read/write team briefs> |
| <Approver> | <Final sign-off> | <Read/write briefs flagged for approval> |
| <System> | <Automated actions> | <Full> |

---

## 3. User journeys

### 3.1 <Journey name — e.g. Submit and route a creative brief>

**Trigger:** <e.g. Brief Requester opens the intake form>

**Happy path:**

| Step | Actor | Action | System response |
|---|---|---|---|
| 1 | Brief Requester | Fills out intake form | Validates fields per BR-1, BR-2 |
| 2 | Brief Requester | Submits | Creates work item, sets state to `Submitted` |
| 3 | System | Routes per BR-3 | Item moves to `Studio Lead Queue` or `Director Queue` |
| 4 | Studio Lead | Reviews | Can assign, return to requester, or escalate |

**Variants:**

- <Brief Requester saves draft instead of submitting → state `Draft`, no routing>
- <Studio Lead returns brief → state `Returned`, requester notified, no routing>

---

### 3.2 <Next journey>

<Repeat the structure above for each major journey.>

---

## 4. Business rules

> Numbered for cross-reference by technical spec and test plan.

| # | Rule | Triggered by |
|---|---|---|
| BR-1 | All briefs require: title, description, deadline, requesting team | Form submission |
| BR-2 | Briefs over R50,000 require Director approval before Studio Lead | Form submission |
| BR-3 | Routing: if `value > 50000` route to Director Queue, else Studio Lead Queue | After validation |
| BR-4 | Approvers have 48h SLA; if breached, escalate to delegate | Approval request created |
| BR-5 | If approver has `out_of_office: true`, route to delegate | Approval request created |

---

## 5. Field-level requirements

| Field | Type | Mandatory | Validation | Default | Source |
|---|---|---|---|---|---|
| Brief title | Short text | Yes | Min 5 chars, max 120 | — | User input |
| Description | Long text | Yes | Min 20 chars | — | User input |
| Deadline | Date | Yes | Must be future, max 90 days out | — | User input |
| Requesting team | Single select | Yes | From team list | User's primary team | User input |
| Estimated value | Number | No | ≥ 0 | 0 | User input |
| Priority | Single select | No | High / Medium / Low | Medium | User input |
| State | Single select | Yes (system) | Draft / Submitted / In Review / Approved / Rejected / Done | Draft | System |
| Approver | User reference | Conditional (BR-2) | — | Resolved per BR-2/3 | System |

---

## 6. State model

```
Draft → Submitted → In Review → (Approved | Rejected) → Done
                              ↑
                           (Returned to Requester)
```

| State | Owner | Allowed next states | Trigger |
|---|---|---|---|
| Draft | Requester | Submitted | User submits |
| Submitted | System | In Review | Auto on submission |
| In Review | Studio Lead / Director | Approved, Rejected, Returned | Reviewer action |
| Returned | Requester | Submitted | Requester re-submits |
| Approved | System | Done | All deliverables signed off |
| Rejected | — | (terminal) | Reviewer rejects |
| Done | — | (terminal) | Final approval signed |

---

## 7. Edge cases

| # | Scenario | Expected behaviour |
|---|---|---|
| EC-1 | User submits with missing mandatory field | Form validation blocks; surfaces error per field |
| EC-2 | Approver on leave with no delegate set | Escalate to next-level manager after 24h |
| EC-3 | Integration (Ziflow) returns 5xx | Retry 3 times with exponential backoff; if still failing, log and notify Ops |
| EC-4 | Two users edit same item simultaneously | Last-write-wins, but log conflict and notify both |
| EC-5 | Brief submitted with deadline in the past | Block submission; surface validation error |
| EC-6 | System time zone vs user time zone mismatch | All timestamps stored UTC; displayed in user's TZ |

---

## 8. Acceptance criteria

> Each criterion becomes one or more rows in the test plan. Reference business rules where applicable.

| # | Criterion | Maps to | Verifies |
|---|---|---|---|
| AC-1 | A submitted brief with all mandatory fields creates a work item in `Submitted` state | D1 | BR-1 |
| AC-2 | A brief with `value > 50000` routes to Director Queue, not Studio Lead | D1 | BR-2, BR-3 |
| AC-3 | Approver SLA breach (>48h) escalates to delegate | D2 | BR-4 |
| AC-4 | Approver with `out_of_office: true` is bypassed; delegate receives request | D2 | BR-5 |
| AC-5 | Form rejects submission with deadline in the past | D1 | EC-5 |
| AC-6 | Ziflow 5xx retries 3x, then logs and notifies Ops | D3 | EC-3 |

---

## 9. Open questions

- [ ] <e.g. What's the escalation chain when delegate is also OoO?>
- [ ] <e.g. Should rejected briefs be archived or deleted after 90 days?>

---

## 10. Out-of-scope clarifications

> Things this functional spec explicitly does not cover.

- <Reporting / dashboards — separate engagement>
- <Mobile app — web only>

---

## Handoff

When this functional spec is approved:

1. Update `status:` to `approved`
2. Run `generate-technical-spec` to map these requirements onto the platform

**Next stage reads:** the highest-version `02_functional-spec_v*.md`.
