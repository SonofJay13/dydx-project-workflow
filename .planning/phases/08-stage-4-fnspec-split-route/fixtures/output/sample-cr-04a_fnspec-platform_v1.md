---
client: VodafoneZiggo
project: ticket-routing-phase-add
frontmatter_version: 2
platform: pipefy
based_on_discovery: 02_discovery_v1.md
based_on_sow: 03_sow_v1.md
based_on_kickoff: 01_kickoff_v1.md
has_platform_api_addendum: true
tech_spec_scope: platform-api-addendum-only
status: approved
approved_by: planner@dydx-delivery
approved_at: 2026-05-11
generated_at: 2026-05-11
fixture: true
fixture_for: phase-8-e2e-smoke
---

# 04a Fnspec — Platform — VodafoneZiggo Ticket Routing Phase Add

> Phase 8 e2e smoke fixture. Synthetic sample-CR scenario exercising D-78 / D-79 / D-81 / D-82 / D-84 / D-85 contracts against the 4a template. Reviewer-authored at plan-execute time per 08-03-PLAN.md T5. NOT a real client artefact — `fixture: true` flags non-production status.

## 1. Scope summary

This 4a fnspec covers the platform-side scope for a Pipefy ticket-routing phase add on the VodafoneZiggo Operations pipe. Adds a "Triage" phase before "Assigned" that auto-routes by ticket category + SLA tier. Loads `dydx-delivery/skills/platform-pipefy/references/native-ai-inventory.md` as the classifier input per DESIGN-20 / Step 4.

## 2. Personas

| Persona | Role | Volume |
|---|---|---|
| Triage agent | Reviews unassigned tickets; sets category + SLA tier | ~80/day |
| Routing supervisor | Audits auto-routing decisions weekly | ~5h/week |

## 3. User journeys

1. Ticket lands in pipe with `status: unassigned` → auto-routes to Triage phase
2. Triage agent reviews + classifies → ticket auto-routes to correct assignee queue
3. Supervisor weekly audit pulls routing-decision log via Pipefy GraphQL

## 4. Business rules

| Rule ID | Description | Delivery |
|---|---|---|
| REQ-1 | Tickets with `category: incident` + `sla_tier: P1` route to `On-call queue` | delivery: native-ai [HIGH, src: platform-pipefy] |
| REQ-2 | Tickets with `category: request` route by `team_tag:` to team-specific queues | delivery: native-ai [MEDIUM, src: platform-pipefy] |
| REQ-3 | Tickets without a category after 4h auto-escalate to Triage supervisor | delivery: native-ai [HIGH, src: platform-pipefy] |
| REQ-4 | Routing-decision audit log persisted to ticket history | delivery: api [LOW → default api, src: platform-pipefy] |

## 5. Field requirements

| Field | Type | Source | Delivery |
|---|---|---|---|
| `category` | enum (incident / request / change) | Triage agent classification | delivery: native-ai [HIGH, src: platform-pipefy] |
| `sla_tier` | enum (P1 / P2 / P3 / P4) | Triage agent classification | delivery: native-ai [MEDIUM, src: platform-pipefy] |
| `routing_decision_log` | JSON array of decisions | Pipefy Behaviors auto-write | delivery: api [reviewer-override: api] |

## 6. Edge cases

- Tickets created via email-to-pipe API bypass triage on first ingest; backfill scheduled hourly.
- Re-routing on category change is one-way (no undo); audit log preserves original assignment.

## 7. Out of scope

- Not in scope: cross-pipe routing (only same-pipe phase transitions).
- Not in scope: SLA-tier auto-detection (relies on agent classification).

## 8. Acceptance criteria

| AC ID | Description | Delivery |
|---|---|---|
| AC-1 | All `category: incident` + `sla_tier: P1` tickets route to On-call queue within 30s | delivery: native-ai [HIGH, src: platform-pipefy] |
| AC-2 | Routing-decision log queryable via Pipefy GraphQL `card.history` | delivery: api [LOW → default api, src: platform-pipefy] |
| AC-3 | No tickets stuck in Triage phase >4h without escalation | delivery: native-ai [reviewer-override: native-ai] |

## 9. Dependencies

- `platform-pipefy/references/native-ai-inventory.md` — confidence rows used in Step 4 classifier
- `01_kickoff_v1.md` — engagement scope per Phase 7 STG1-02
- `02_discovery_v1.md` + `03_sow_v1.md` — upstream approved artefacts

## 10. Open questions

None at write time. Reviewer noted: Pipefy Behaviors throttle is 100 actions/min/pipe per Pipefy GraphQL rate-limit page; well under expected ~80 tickets/day volume.

## Platform-API Addendum

> Emitted inline per D-79 because no 4b is in scope on this engagement AND this 4a carries `delivery: api` rows. v2.3 Stage 5 consumes this addendum body verbatim via `has_platform_api_addendum: true` + `tech_spec_scope: platform-api-addendum-only` frontmatter.

### API surface inventory

| Endpoint | Method | Auth | Rate limit | Delivery |
|---|---|---|---|---|
| `/cards/{id}/history` | GET | Pipefy GraphQL OAuth bearer | 100 req/min | delivery: api [LOW → default api, src: platform-pipefy] |
| `/cards/{id}/move_to_phase` | POST | Pipefy GraphQL OAuth bearer | 100 req/min | delivery: api [reviewer-override: api] |

### Error paths

| HTTP class | Expected behaviour | Per-platform error mapping | Reviewer-facing message |
|---|---|---|---|
| 4xx | Fail-fast; log card_id + payload | Pipefy returns `errors[].message` | "Routing call rejected; check ticket payload" |
| 5xx | Exponential backoff (2s/4s/8s); max 3 retries | Pipefy returns 5xx on tenant overload | "Pipefy tenant unavailable; retrying" |

### Retry + idempotency rules

- `/cards/{id}/move_to_phase` is idempotent (target phase is end-state; replays no-op).
- Idempotency-key field: Pipefy uses card `id` + `to_phase_id` as natural key.
- `/cards/{id}/history` is read-only (no idempotency concern).

### Observability hooks

- Request log: card_id + endpoint + duration captured via Pipefy webhook.
- Response capture: full `move_to_phase` response stored in routing-decision log.
- Audit-trail surface: Pipefy Activity Stream per pipe.
- Trace correlation: dYdX trace_id propagated via Pipefy header `X-Trace-Id`.
