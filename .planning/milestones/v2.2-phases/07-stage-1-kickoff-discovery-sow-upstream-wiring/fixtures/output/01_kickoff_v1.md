---
client: VodafoneZiggo
project: ticket-auto-routing-by-tier
frontmatter_version: 2
kickoff_branch: discovery-ready
field_notes_processed_count: 0
status: approved
based_on_kickoff: N/A
captured_by: phase-7-e2e-smoke-reviewer
captured_at: 2026-05-11
fixture_run: true
source_fixture: .planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/fixtures/sample-cr-meeting-notes.md
---

# Kickoff — VodafoneZiggo · Ticket Auto-Routing by Tier

> Stage 1 of the dydx-delivery pipeline. Captures the operational reality of an engagement so downstream stages have a real foundation.

## 1. System

| Field | Value |
|---|---|
| Current state | Single inbound CR queue in Pipefy; studio lead manually re-orders by `customer_tier` from a Coda view. Gold-tier SLA missed ~20% of weeks. |
| Target state | New "Triage by tier" Pipefy phase between existing `Triage` and `Studio Queue`; auto-routes Gold to Director Queue, Silver/Bronze to Studio Lead Queue. |
| Scope edges | Single Pipefy pipe; no Wrike/Ziflow integration; no SLA timer changes; no portal updates. |

*Narrative*: VodafoneZiggo wants an automated tier-based router added to the existing CR pipe so Gold-tier SLA misses drop.

## 2. Users

| Role | Type | Notes |
|---|---|---|
| Studio lead (VZ) | primary | Consumes Studio Lead Queue (Silver/Bronze). |
| Director (VZ) | primary | Consumes Director Queue (Gold). |
| Platform engineer (dYdX) | secondary | Implementer. |

## 3. Triggers

| Trigger | Mode | Frequency / cadence |
|---|---|---|
| Card landing in `Triage Phase` with `customer_tier != null` | event | Per-card, every CR. |

## 4. Data

| Data element | Direction | Source / sink | Persistence boundary |
|---|---|---|---|
| `customer_tier` | in | Pipefy card field (already populated) | Stays in Pipefy. |
| Queue assignment | out | Pipefy card movement | Stays in Pipefy. |

## 5. Rules

- `customer_tier == Gold` → route to Director Queue (priority lane).
- `customer_tier in {Silver, Bronze}` → route to Studio Lead Queue (FIFO).
- Tier upgrades mid-ticket: handle manually for v1 — *[unknown — needs human classification]* whether automated re-routing is in scope.

## 6. Integrations

| Integration | Direction | Auth model | Volume / cadence |
|---|---|---|---|
| (none) | — | — | — |

No integrations in scope for v1 — Pipefy-internal only.

## 7. Exceptions

- *[unknown — needs human classification]* — what happens if `customer_tier` is null at routing time? Default queue? Block? Surface for discovery.
- *[unknown — needs human classification]* — re-routing on mid-ticket tier upgrade (deferred per studio lead — surface for discovery).

## 8. Failure points

- *[unknown — needs human classification]* — observability: how do we detect a stuck card in the new phase? Today there's no SLA timer on Triage; same risk here.

## Routing

**kickoff_branch:** `discovery-ready` (set in frontmatter)

**Rationale:** Three explicit `[unknown — needs human classification]` markers remain after Step 2 classification (null-tier handling, mid-ticket tier upgrade routing, new-phase observability). The CR has clear bones but material unknowns — discovery is needed before SOW can lock scope. Routes to Stage 2 `discovery-intake`.

## Sign-off

| Field | Value |
|---|---|
| Captured by | phase-7-e2e-smoke-reviewer |
| Captured on | 2026-05-11 |
| Approval status | approved |
| Approved by | phase-7-e2e-smoke-reviewer |
| Approved on | 2026-05-11 |
