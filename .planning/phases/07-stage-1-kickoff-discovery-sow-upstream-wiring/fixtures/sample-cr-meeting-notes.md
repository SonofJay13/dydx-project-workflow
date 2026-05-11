---
fixture: true
fixture_for: phase-7-e2e-smoke
client: VodafoneZiggo
project: ticket-auto-routing-by-tier
capture_path: meeting-notes
---

# Kickoff meeting — 2026-05-08 — VodafoneZiggo ticket auto-routing

Attendees: studio lead (VZ), delivery lead (dYdX), platform engineer (dYdX).

## Notes

- VZ wants a new Pipefy phase between `Triage` and `Studio Queue` that
  auto-routes inbound CR tickets by customer tier (Gold / Silver / Bronze).
- Today, every CR drops into one queue; studio lead manually re-orders by
  tier from a Coda view. Gold-tier SLA is being missed ~20% of weeks.
- Tier is already in Pipefy as a card field (`customer_tier`); no enrichment
  needed from upstream systems.
- Rule sketch: Gold → Director Queue (priority lane); Silver/Bronze →
  Studio Lead Queue (FIFO). New "Triage by tier" phase implements the split.
- Trigger: card landing in `Triage Phase` with `customer_tier != null`.
- No new users in scope; same studio lead + director consume the routed
  queues. Reporting view stays in Coda.
- Risk noted but not assigned: what about tier upgrades mid-ticket? Studio
  lead said "rare, handle manually for now" — flagged for kickoff [unknown
  — needs human classification].
- Data scope mentioned: nothing leaves Pipefy; no integration to Wrike or
  Ziflow needed for v1.
- Out of scope (explicit): notification changes, SLA timer overhaul,
  customer-portal updates.
- Timeline ask: "ideally within current cost window — recommend discovery
  to validate effort before locking SOW."
