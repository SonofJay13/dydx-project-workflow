<!--
Stage 4b Integration Functional Spec — body template.

This template is the canonical body shape for `04b_fnspec-integration_v<N>.md`. Direct sibling of
`generate-fnspec-platform/references/fnspec-platform-template.md` — same 10-section spine, re-aimed at
system-to-system integration scope.

D-82 row markup convention (verbatim) — every integration-touchpoint / API-endpoint / acceptance-criteria
row carries one of:

    delivery: native-ai [HIGH, src: platform-pipefy]
    delivery: native-ai [MEDIUM, src: platform-pipefy]
    delivery: api [LOW → default api, src: platform-pipefy]
    delivery: api [reviewer-override: api]
    delivery: native-ai [reviewer-override: native-ai]

Canonical enum order is ALWAYS `native-ai | api`. The reversed form is forbidden per STG4-04 lock.
The unicode arrow `→` (U+2192) appears verbatim in the LOW → default-api markup; not `->`.
The `[reviewer-override:]` token is the canonical re-run preservation trigger per D-82 — never silently
re-classify a reviewer-overridden row.

`based_on_fnspec_platform:` is CONDITIONAL in the frontmatter — present when 4a exists ('both' topology),
ABSENT on the 4b-only topology. The reviewer omits the field entirely on 4b-only; it is not commented out.
-->

---
client: <CLIENT_NAME>
project: <PROJECT_NAME>
frontmatter_version: 2
platform: pipefy                                       # Valid values: pipefy | wrike | ziflow | other (D-78)
based_on_discovery: 02_discovery_v<N>.md               # MANDATORY when discovery exists
based_on_sow: 03_sow_v<N>.md                           # MANDATORY (single SOW path per STG3-02)
based_on_fnspec_platform: 04a_fnspec-platform_v<N>.md  # CONDITIONAL — present on 'both' topology; absent on 4b-only
status: draft                                          # canonical 4-state: draft → client_review → approved → archived
approved_by: <name-or-handle>                          # MANDATORY on approved
approved_at: <ISO date>                                # MANDATORY on approved
generated_at: <ISO date>
---

# Stage 4b Integration Functional Spec — <CLIENT_NAME> · <PROJECT_NAME>

> Stage 4b of the dydx-delivery pipeline. Captures the integration-side functional contract from approved discovery + approved SOW + (when 'both' topology) approved Stage 4a platform fnspec. Every requirement row carries the `delivery: native-ai | api` routing key per D-82 — canonical enum order, never reversed (STG4-04). Stage 4b reads 4a's per-row tags as-is (no re-classification); the three cross-spec consistency checks (D-84 + ROUTE-01) run FIRST before any write.

## 1. Scope summary

One-paragraph summary of the integration work in scope, lifted from the approved SOW `## Integration Scope` section. Name the primary integration domains (e.g., "Pipefy → Wrike work-package sync; Ziflow asset-proof push from Pipefy card attachment").

## 2. System participants

- **Primary system:** <e.g., Pipefy as the orchestration spine>
- **Integrated systems (external):** <e.g., Wrike for work-package execution; Ziflow for proof routing; Slack for notifications>
- **Paste-fed surfaces (if any):** <native-AI-only platforms that lack programmatic APIs in v2.1>

## 3. Data-flow journeys

System-to-system data flows, numbered. NOT user journeys — these are integration-specific data movements.

1. **Flow 1 — Work package created in Pipefy → Wrike task created.** Triggered by Pipefy card move into "Approved" phase; payload = card field map; target = Wrike `POST /tasks`.
2. **Flow 2 — Wrike task status update → Pipefy card status sync.** Triggered by Wrike webhook on task completion; payload = task ID + new status; target = Pipefy GraphQL mutation `updateCard`.
3. **Flow 3 — Ziflow proof approval → Pipefy attachment metadata.** Triggered by Ziflow proof status webhook; payload = proof URL + reviewer name; target = Pipefy card attachment field.

## 4. Integration touchpoints

Every row MUST cite a 4a requirement ID in the `Cites 4a req` column (ROUTE-01 check (b) input). The `Delivery` column carries D-82 markup using 4a's classification as input (no re-classification — D-81 closing clause).

| Touchpoint ID | Description                                          | Source system | Target system | Cites 4a req | Delivery                                          |
|---------------|------------------------------------------------------|---------------|---------------|--------------|---------------------------------------------------|
| TP-01         | Pipefy → Wrike work-package create on phase advance  | Pipefy        | Wrike         | REQ-12       | delivery: native-ai [HIGH, src: platform-pipefy]  |
| TP-02         | Wrike → Pipefy status sync on task complete          | Wrike         | Pipefy        | REQ-14       | delivery: native-ai [MEDIUM, src: platform-pipefy]|
| TP-03         | Ziflow → Pipefy proof-approval metadata write        | Ziflow        | Pipefy        | REQ-21       | delivery: api [LOW → default api, src: platform-pipefy] |
| TP-04         | Pipefy → Slack notification on stuck card (>72h SLA) | Pipefy        | Slack         | REQ-30       | delivery: api [reviewer-override: api]            |

## 5. Integration business rules

| ID    | Rule                                                                                              | Source            | Delivery                                          |
|-------|---------------------------------------------------------------------------------------------------|-------------------|---------------------------------------------------|
| BR-01 | Wrike task title MUST equal `<Pipefy phase>: <Pipefy card title>` (deterministic concat).         | SOW §3.2          | delivery: native-ai [HIGH, src: platform-pipefy]  |
| BR-02 | Sync direction is one-way Pipefy → Wrike for create; bi-directional Wrike ↔ Pipefy for status.    | Discovery §4.1    | delivery: native-ai [MEDIUM, src: platform-pipefy]|
| BR-03 | Idempotency key for Pipefy → Wrike task create: SHA-256 of `<pipefy_card_id>:<phase_advanced_at>` | SOW §3.4          | delivery: api [reviewer-override: api]            |

## 5a. API endpoints

Dedicated sub-section per ROUTE-01 check (c). Every endpoint MUST map to a 4a requirement ID via the `Cites 4a req` column — no orphans.

| Endpoint ID | URL                                       | Method | Auth                | Cites 4a req | Delivery                                          |
|-------------|-------------------------------------------|--------|---------------------|--------------|---------------------------------------------------|
| EP-01       | `https://www.wrike.com/api/v4/tasks`       | POST   | OAuth2 bearer       | REQ-12       | delivery: api [HIGH, src: platform-pipefy]        |
| EP-02       | `https://api.pipefy.com/graphql`           | POST   | OAuth bearer        | REQ-14       | delivery: api [reviewer-override: api]            |

## 6. State model

State transitions across system boundaries. Capture the canonical end-to-end lifecycle for a unit of work as it crosses systems — e.g., `pipefy.phase=approved → wrike.task=created → wrike.task=completed → pipefy.phase=delivered`. Note any compensating transitions (rollback on partial write).

## 7. Edge cases

Concrete integration-path edge cases:

- **Network failure mid-write.** Pipefy → Wrike task create succeeds, but the webhook back to Pipefy times out — outcome: idempotency key (BR-03) prevents duplicate task on Pipefy retry.
- **Partial write.** Multi-step flow (e.g., create task + attach file + comment) fails on step 2 — outcome: documented compensating delete OR explicit reviewer escalation row in the audit log.
- **Idempotency violation.** Same idempotency key with different payload — outcome: hard failure, surface as `04b_consistency_check_v<N>.md` failure row if it persists.
- **Rate limit.** Ziflow API limited to 4 req per 10s — outcome: documented backoff + queue strategy.

## 8. Acceptance criteria

| ID    | AC                                                                                                | Validates touchpoint(s)/endpoint(s) | Delivery                                          |
|-------|---------------------------------------------------------------------------------------------------|--------------------------------------|---------------------------------------------------|
| AC-01 | Given a Pipefy card moved to Approved, when phase-advance fires, a Wrike task is created within 5s | TP-01, EP-01                         | delivery: native-ai [HIGH, src: platform-pipefy]  |
| AC-02 | Given a Wrike task status update webhook, when received, the Pipefy card phase is synced within 10s | TP-02, EP-02                         | delivery: native-ai [MEDIUM, src: platform-pipefy]|
| AC-03 | Given a duplicate Pipefy phase-advance event for the same card, when fired, no duplicate Wrike task is created (idempotency key honoured) | TP-01, BR-03                         | delivery: api [reviewer-override: api]            |

## 9. Open questions

Explicit unresolved items. Use `[OPEN]` marker on rows that block approval.

- [OPEN] Q1: Ziflow rate-limit budget — do we exceed 4 req/10s on a busy day? Need throughput estimate from discovery §4.3.

## 10. Out-of-scope clarifications

Explicit non-goals:

- No bidirectional sync for Wrike → Pipefy task create (one-way only; Pipefy is the create authority).
- No native-AI Coda doc auto-update from Pipefy events (deferred to v2.5 Stage 10).
- No real-time UI in v2.2 — all sync is event-driven async.

---

```
Awaiting status: approved on 04b_fnspec-integration_v<N>.md. Stage 5 v2.3 reads both 4a + 4b via the based_on_* chain (based_on_discovery + based_on_sow + based_on_fnspec_platform).
```
