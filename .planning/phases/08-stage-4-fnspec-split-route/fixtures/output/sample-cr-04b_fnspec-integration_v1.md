---
client: VodafoneZiggo
project: ticket-routing-phase-add
frontmatter_version: 2
platform: pipefy
based_on_discovery: 02_discovery_v1.md
based_on_sow: 03_sow_v1.md
based_on_fnspec_platform: 04a_fnspec-platform_v1.md
status: approved
approved_by: planner@dydx-delivery
approved_at: 2026-05-11
generated_at: 2026-05-11
fixture: true
fixture_for: phase-8-e2e-smoke
---

# 04b Fnspec — Integration — VodafoneZiggo Ticket Routing Phase Add

> Phase 8 e2e smoke fixture. Integration-side scope produced AFTER 4a `status: approved` per DESIGN-20 + DESIGN-13 hand-off. ROUTE-01 three-check consistency pass (clean) — no `04b_consistency_check_v*.md` halt artefact emitted on this run. `based_on_fnspec_platform:` cites 04a above per ROUTE-03 read-side.

## 1. Scope summary

Integration touchpoints required to surface VodafoneZiggo's ticket-routing audit log into the dYdX Observability Coda doc + push routing decisions to the Slack #ops-routing channel. Reads `delivery:` rows from 04a as the routing contract per DESIGN-20.

## 2. Personas

| Persona | Role |
|---|---|
| Observability engineer | Reviews routing-decision Coda doc weekly |
| #ops-routing Slack channel | Receives real-time routing notifications |

## 3. User journeys

1. Routing decision lands in Pipefy → webhook fires → integration writes to Coda doc + Slack
2. Engineer audit pulls Coda doc → cross-references Pipefy audit log

## 4. Integration touchpoints

| Touchpoint ID | Description | Cites 4a req | Delivery |
|---|---|---|---|
| INT-1 | Pipefy webhook → integration layer | REQ-1 | delivery: api [LOW → default api, src: platform-pipefy] |
| INT-2 | Integration → Coda row write | REQ-4 | delivery: api [reviewer-override: api] |
| INT-3 | Integration → Slack #ops-routing post | REQ-1 | delivery: api [LOW → default api, src: platform-pipefy] |

## 5. API endpoints (5a)

| Endpoint | Method | Auth | Cites 4a req | Delivery |
|---|---|---|---|---|
| Coda `/docs/{id}/tables/{tid}/rows` | POST | Coda API token | REQ-4 | delivery: api [LOW → default api, src: platform-pipefy] |
| Slack `/chat.postMessage` | POST | Slack OAuth bot token | REQ-1 | delivery: api [reviewer-override: api] |

## 6. Edge cases

- Webhook delivery retries: Pipefy retries up to 3 times on 5xx response; integration layer is idempotent on `(card_id, decision_at)` tuple.
- Coda row write conflicts: rare (one writer); on conflict, refetch + re-write.

## 7. Out of scope

- Not in scope: bidirectional sync (Coda → Pipefy edits ignored).
- Not in scope: Slack thread replies (one-way notification only).

## 8. Acceptance criteria

| AC ID | Description | Cites 4a AC | Delivery |
|---|---|---|---|
| AC-INT-1 | Routing decision visible in Coda doc within 60s of Pipefy phase transition | AC-1 | delivery: native-ai [MEDIUM, src: platform-pipefy] |
| AC-INT-2 | Slack notification posted within 30s of routing decision | AC-1 | delivery: api [LOW → default api, src: platform-pipefy] |

## 9. Dependencies

- 04a fnspec-platform `status: approved` (REQUIRED via `based_on_fnspec_platform:`)
- Coda doc + table provisioned (out-of-band before integration build)
- Slack #ops-routing channel + bot token provisioned

## 10. Open questions

None at write time. Reviewer noted: Coda row-write rate limit is 6 req/s; well under expected ~80 routing decisions/day.

## Cross-spec consistency check log

> Per D-84, Stage 4b runs three consistency checks against 04a BEFORE this artefact was written. On this synthetic fixture, all three checks PASSED — no `04b_consistency_check_v*.md` artefact emitted (D-84 audit footprint: clean checks leave no record per the consistency-rules.md halt-on-failure contract).

- Check (a) — No conflicting `delivery:` tags across 4a + 4b on shared req IDs: PASS (no req ID appears in both).
- Check (b) — Every integration touchpoint cites a real 4a req: PASS (INT-1 → REQ-1; INT-2 → REQ-4; INT-3 → REQ-1).
- Check (c) — No orphan API endpoints: PASS (both endpoints traced to `delivery: api` rows via INT-2 / INT-3).
