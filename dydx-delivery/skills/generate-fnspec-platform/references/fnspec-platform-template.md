<!--
  04a_fnspec-platform template — Stage 4a output skeleton.

  Canonical status lifecycle: draft → client_review → approved → archived (DESIGN-01 + DESIGN-08 + Phase 7 D-75; unicode arrows verbatim, never `->`).

  delivery: row markup (D-82) — canonical enum order is `native-ai | api` (STG4-04 lock; reversed form forbidden).
  Suffix variants:
    - delivery: native-ai [HIGH, src: platform-pipefy]
    - delivery: native-ai [MEDIUM, src: platform-wrike]
    - delivery: api [LOW → default api, src: platform-ziflow]
    - delivery: api [reviewer-override: api]              # re-run preservation — NOT re-classified
    - delivery: native-ai [reviewer-override: native-ai]  # re-run preservation — NOT re-classified

  has_platform_api_addendum + tech_spec_scope (D-79) — emit ONLY when no 4b is in scope AND this 4a has any `delivery: api` rows.
  Otherwise omit both frontmatter fields AND the ## Platform-API Addendum H2 section at the end of this template.

  Platform enum (D-78): pipefy | wrike | ziflow | other. Switch the `platform:` field at write time to the SOW-driven value.
-->

---
client: <CLIENT_NAME>
project: <PROJECT_NAME>
frontmatter_version: 2
platform: pipefy                                # Valid values: pipefy | wrike | ziflow | other (D-78 — switch at write time)
based_on_discovery: 02_discovery_v<N>.md         # MANDATORY when discovery exists (normal path)
based_on_sow: 03_sow_v<N>.md                     # MANDATORY (single SOW path per STG3-02)
based_on_kickoff: <N/A or 01_kickoff_v<N>.md>    # CONDITIONAL — present only on the draft-sow path (Stage 2 skipped)
status: draft                                    # canonical 4-state: draft → client_review → approved → archived
has_platform_api_addendum: false                 # D-79 — set to true ONLY when no 4b is in scope AND this 4a has any delivery: api rows
tech_spec_scope: <omit or platform-api-addendum-only>  # D-79 — present ONLY when has_platform_api_addendum: true
approved_by: <name-or-handle>                    # MANDATORY on status: approved writes (DESIGN-06)
approved_at: <ISO date>                          # MANDATORY on status: approved writes
generated_at: <ISO date>
---

# Stage 4a Platform Functional Spec — <CLIENT_NAME> · <PROJECT_NAME>

> Stage 4a of the dydx-delivery pipeline. Captures the platform-side functional contract from approved discovery + approved SOW + the loaded platform skill's native-AI inventory. Every requirement row carries the `delivery: native-ai | api` routing key per D-82 — canonical enum order, never reversed (STG4-04). Stage 4b consumes this artefact as upstream for the integration fnspec + the three cross-spec consistency checks.

---

## 1. Scope summary

**In-scope deliverables (from SOW `## Platform Scope`):**

- D1: <Deliverable name>
- D2: <Deliverable name>

One-paragraph summary of the platform-side intent captured here. Reference the SOW deliverable IDs and the platform skill loaded at Step 2 of `generate-fnspec-platform/SKILL.md` (one of `pipefy | wrike | ziflow | other` per D-78).

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

> Numbered for cross-reference by the technical spec and test plan. Every row carries D-82 routing markup in the `Delivery` column (canonical enum order `native-ai | api`).

| ID | Rule | Source | Delivery |
|---|---|---|---|
| BR-1 | All briefs require: title, description, deadline, requesting team | Discovery §4.2 / SOW D1 | delivery: native-ai [HIGH, src: platform-pipefy] |
| BR-2 | Briefs over R50,000 require Director approval before Studio Lead | SOW D1 | delivery: native-ai [MEDIUM, src: platform-pipefy] |
| BR-3 | Routing: if `value > 50000` route to Director Queue, else Studio Lead Queue | SOW D1 | delivery: api [LOW → default api, src: platform-pipefy] |
| BR-4 | Approvers have 48h SLA; if breached, escalate to delegate | Discovery §4.5 | delivery: api [reviewer-override: api] |
| BR-5 | If approver has `out_of_office: true`, route to delegate | Discovery §4.6 | delivery: native-ai [reviewer-override: native-ai] |

---

## 5. Field-level requirements

> Every row carries D-82 routing markup in the `Delivery` column.

| Field | Type | Required | Source | Delivery |
|---|---|---|---|---|
| Brief title | Short text | Yes | User input | delivery: native-ai [HIGH, src: platform-pipefy] |
| Description | Long text | Yes | User input | delivery: native-ai [HIGH, src: platform-pipefy] |
| Deadline | Date | Yes | User input | delivery: native-ai [MEDIUM, src: platform-pipefy] |
| Requesting team | Single select | Yes | User input | delivery: native-ai [HIGH, src: platform-pipefy] |
| Estimated value | Number | No | User input | delivery: native-ai [MEDIUM, src: platform-pipefy] |
| Priority | Single select | No | User input | delivery: native-ai [HIGH, src: platform-pipefy] |
| State | Single select | Yes (system) | System | delivery: api [LOW → default api, src: platform-pipefy] |
| Approver | User reference | Conditional (BR-2) | System | delivery: api [reviewer-override: api] |

---

## 6. State model

> Workflow state lifecycle — not row-tagged with `delivery:` markup (state transitions are workflow-level, not requirement-level).

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

> Concrete (not generic). "Handle errors gracefully" is not an edge case.

| # | Scenario | Expected behaviour |
|---|---|---|
| EC-1 | User submits with missing mandatory field | Form validation blocks; surfaces error per field |
| EC-2 | Approver on leave with no delegate set | Escalate to next-level manager after 24h |
| EC-3 | Platform API returns 429 rate-limit | Queue with exponential backoff up to 3 retries; surface inline status to reviewer |
| EC-4 | Two users edit same item simultaneously | Last-write-wins, but log conflict and notify both |
| EC-5 | Brief submitted with deadline in the past | Block submission; surface validation error |
| EC-6 | System time zone vs user time zone mismatch | All timestamps stored UTC; displayed in user's TZ |

---

## 8. Acceptance criteria

> Each criterion becomes one or more rows in the test plan. Every row carries D-82 routing markup in the `Delivery` column.

| ID | AC | Validates rule(s) | Delivery |
|---|---|---|---|
| AC-1 | A submitted brief with all mandatory fields creates a work item in `Submitted` state | BR-1 | delivery: native-ai [HIGH, src: platform-pipefy] |
| AC-2 | A brief with `value > 50000` routes to Director Queue, not Studio Lead | BR-2, BR-3 | delivery: native-ai [MEDIUM, src: platform-pipefy] |
| AC-3 | Approver SLA breach (>48h) escalates to delegate | BR-4 | delivery: api [LOW → default api, src: platform-pipefy] |
| AC-4 | Approver with `out_of_office: true` is bypassed; delegate receives request | BR-5 | delivery: api [reviewer-override: api] |
| AC-5 | Form rejects submission with deadline in the past | EC-5 | delivery: native-ai [HIGH, src: platform-pipefy] |
| AC-6 | Platform 429 retries 3× then surfaces inline status | EC-3 | delivery: api [LOW → default api, src: platform-pipefy] |

---

## 9. Open questions

- [ ] <e.g. What's the escalation chain when delegate is also OoO?>
- [ ] <e.g. Should rejected briefs be archived or deleted after 90 days?>

---

## 10. Out-of-scope clarifications

> Things this Stage 4a fnspec explicitly does not cover.

- <Reporting / dashboards — separate engagement>
- <Mobile app — web only>
- <Integration-side error mapping — owned by Stage 4b (generate-fnspec-integration)>

---

<!--
  D-79 — emit this H2 ONLY when has_platform_api_addendum: true (i.e., no 4b is in scope AND this 4a has any delivery: api rows).
  Body content is authored from `references/addendum-template.md`.
  v2.3 Stage 5 reads this body verbatim and skips writing 05_techspec_v<N>.md when tech_spec_scope: platform-api-addendum-only.
-->

## Platform-API Addendum

*(emit only when has_platform_api_addendum: true — see references/addendum-template.md for the body skeleton)*

---

## Handoff

Awaiting status: approved on 04a_fnspec-platform_v<N>.md. Stage 4b (generate-fnspec-integration) reads this artefact when integration scope exists. If integration is out-of-scope AND this 4a carries delivery: api rows, this artefact's `## Platform-API Addendum` H2 body is the v2.3 Stage 5 input via has_platform_api_addendum: true + tech_spec_scope: platform-api-addendum-only frontmatter.
