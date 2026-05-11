---
client: <CLIENT_NAME>
platform: <pipefy | wrike | ziflow | other>
integrations: []
frontmatter_version: 2
version: 1
status: draft   # canonical lifecycle: draft → client_review → approved → archived (STG3-01 + DESIGN-08)
# One or the other — never both per DESIGN-19 line 643:
based_on_discovery: 02_discovery_v<N>.md   # discovery-ready path (Stage 2 ran)
# based_on_kickoff: 01_kickoff_v<N>.md     # draft-sow path (Stage 2 skipped)
generated_at: <YYYY-MM-DD>
---

# Scope of Work — <CLIENT_NAME> · <ENGAGEMENT_NAME>

**Prepared by:** dYdX Digital
**Prepared for:** <CLIENT_NAME>
**Version:** 1.0 (Draft)
**Date:** <YYYY-MM-DD>

---

## 1. Business outcome

<One paragraph: what the client is trying to achieve, why now, what changes if it ships.>

---

## Platform Scope

What ships as platform configuration on Pipefy / Wrike / Ziflow (the primary delivery platform for this engagement). Stage 4a (`generate-fnspec-platform`) consumes this section.

| # | Deliverable | Platform | Notes |
|---|---|---|---|
| P1 | <e.g. Brief intake form with conditional routing> | <pipefy \| wrike \| ziflow> | <Acceptance criteria, routing logic, validation rules> |

---

## Integration Scope

What ships as inbound/outbound integration work (custom APIs, webhooks, ETL, external system handoffs). Stage 4b (`generate-fnspec-integration`) consumes this section. If the engagement has no integration work, leave the table empty and note "no integration scope" — Stage 4b will then skip cleanly.

| # | Deliverable | Integration target | Notes |
|---|---|---|---|
| I1 | <e.g. Ziflow review webhook → Pipefy card status> | <Ziflow API v2> | <Auth, payload shape, retry policy, acceptance criteria> |

---

## 3. Out-of-scope

**Explicitly excluded from this engagement:**

- <e.g. Migration of historical briefs from legacy system>
- <e.g. Custom mobile app — workflow accessed via web only>
- <e.g. Training materials beyond a single recorded handover session>
- <e.g. Ongoing support — first 30 days warranty only, separate SLA needed for ongoing>

---

## 4. Approach and phases

This engagement follows the dydx-delivery pipeline:

| Phase | Output | Owned by | Duration estimate |
|---|---|---|---|
| Discovery | Approved discovery artefact | dYdX + client SMEs | Complete |
| Functional spec | User journeys, business rules, acceptance criteria | dYdX | <X> days |
| Technical spec | Platform-specific implementation plan | dYdX | <X> days |
| Build | Configured pipes/blueprints/automations | Implementation partner | <X> days |
| Test | Sandbox test execution + UAT | dYdX + client | <X> days |
| Handover | Operating manual + support runbook | dYdX | <X> days |

**Total duration estimate:** <X weeks ± Y days>

---

## 5. Assumptions

> Each assumption is a risk if wrong. Validate before kickoff.

- <e.g. Client has admin access to Pipefy and can grant dYdX a builder seat within 2 days of signing>
- <e.g. Existing Ziflow integration credentials are valid and not rate-limited>
- <e.g. Approver list is stable for the duration of the build (no major restructuring)>

---

## 6. Risks and dependencies

| # | Item | Type | Owner | Mitigation |
|---|---|---|---|---|
| R1 | <e.g. Approver list churns mid-build> | Risk | Client | <e.g. Lock approver list at functional spec sign-off> |
| D1 | <e.g. Ziflow API credentials> | Dependency | Client | <Provide before technical spec sign-off> |
| D2 | <e.g. Sample brief data for testing> | Dependency | Client | <Provide before test plan generation> |

---

## 7. Acceptance

Each deliverable is accepted when:

1. The acceptance criteria in the deliverables table are met
2. The deliverable passes the test plan relevant to it (see `testing/<feature>/08b_test-plan_v*.md`)
3. The client signs off in writing on the deliverable

Final engagement acceptance is on completion of all deliverables plus successful UAT in the client's sandbox tenant.

---

## 8. Commercial framing

**Engagement type:** <Fixed-price | Time & Materials | Milestone-based>

**Rate (if T&M):** <**TBC** or value>

**Total fee (if fixed):** <**TBC** or value>

**Payment schedule:**

| Milestone | Trigger | % of fee |
|---|---|---|
| Kickoff | SOW signed | <30%> |
| Spec sign-off | Technical spec approved | <30%> |
| Build complete | Test plan executed and passed | <30%> |
| Handover | Operating manual delivered | <10%> |

**Currency:** <ZAR / EUR / USD>

---

## 9. Timeline

| Milestone | Target date | Confidence |
|---|---|---|
| Kickoff | <date> | <Hard / Soft> |
| Functional spec sign-off | <date ± 2 days> | <Soft> |
| Technical spec sign-off | <date ± 2 days> | <Soft> |
| Build complete | <date ± 5 days> | <Soft> |
| UAT complete | <date ± 3 days> | <Soft> |
| Handover | <date ± 2 days> | <Soft> |

---

## 10. Architectural notes

> Things the SOW implies but doesn't explicitly cover. Useful context for the implementation partner.

- <e.g. Single-tenant build — multi-tenant would require a different approach and is out of scope>
- <e.g. Assumes Pipefy public API is sufficient; no private API access requested>

---

## 11. Open questions

> Items that must be resolved before this SOW can be signed.

- [ ] <Question 1>
- [ ] <Question 2>

---

## Handoff

When this SOW is approved:

1. Update frontmatter `status:` to `approved` (canonical lifecycle: `draft → client_review → approved → archived`)
2. Save the signed PDF (or signature confirmation) alongside this file
3. Route per DESIGN-19 line 653:

> Awaiting status: approved on 03_sow_v<N>.md; routing to Stage 4a (platform fnspec) and/or Stage 4b (integration fnspec) per project scope.

`## Platform Scope` feeds Stage 4a (`generate-fnspec-platform`); `## Integration Scope` feeds Stage 4b (`generate-fnspec-integration`). If `## Integration Scope` is empty / "no integration scope", Stage 4b skips cleanly.

**Next stage reads:** the highest-version `03_sow_v*.md` in this folder.
