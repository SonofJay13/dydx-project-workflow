---
client: VodafoneZiggo
platform: pipefy
integrations: []
frontmatter_version: 2
version: 1
status: draft
based_on_discovery: 02_discovery_v1.md
generated_at: 2026-05-11
captured_by: phase-7-e2e-smoke-reviewer
fixture_run: true
---

# SOW — VodafoneZiggo · Ticket Auto-Routing by Tier

> Stage 3 (discovery-ready path). Generated from `02_discovery_v1.md` per DESIGN-19 dual-input contract.

## 1. Business outcome

Eliminate Gold-tier SLA breaches caused by triage delay. Replace manual tier-based re-ordering with auto-routing in the existing VodafoneZiggo CR Pipefy pipe.

## Platform Scope

In-scope deliverables — consumed by Stage 4a (`generate-fnspec-platform`):

- **New Pipefy phase** `Triage by tier` inserted between existing `Triage Phase` and `Studio Queue`.
- **Pipefy automation**: on card entering `Triage by tier`, evaluate `customer_tier` and move card to one of:
  - Director Queue (when `customer_tier == Gold`)
  - Studio Lead Queue (when `customer_tier in {Silver, Bronze}` OR `customer_tier == null`)
- **Phase-duration alert**: Pipefy automation that flags cards >2 business days in `Triage by tier` and notifies the studio lead.
- **Operator runbook page** (Coda) describing the new phase, the routing matrix, and the alert behaviour.

## Integration Scope

No integration scope — Pipefy-internal only per discovery §7. Stage 4b (`generate-fnspec-integration`) will skip cleanly.

## 2. Out-of-scope

- Mid-ticket tier upgrade re-routing (deferred per discovery §6).
- SLA timer overhaul on the existing `Triage Phase`.
- Customer-portal updates.
- Wrike / Ziflow integration changes.
- Notification platform changes (alert uses existing Pipefy/Slack channel).

## 3. Approach and phases

1. Stage 4a — platform fnspec for Pipefy configuration.
2. Stage 5 — tech spec (addendum-only scope; existing pipe).
3. Stage 6 — cost estimate.
4. Stage 7a — build prompt; dYdX platform engineer executes.
5. Stage 8 — test against VodafoneZiggo sandbox pipe.
6. Stage 9 — operator runbook publish; Stage 11 sign-off.

## 4. Assumptions

- `customer_tier` is reliably populated upstream on every card (per discovery §11 — to be confirmed by VZ studio lead).
- Director Queue + Studio Lead Queue phases already exist (per discovery §11 — to be confirmed by VZ platform owner).
- Pipefy automation-step quota is available on the VZ pipe (per discovery §10).

## 5. Risks and dependencies

| Risk | Owner | Mitigation |
|---|---|---|
| `customer_tier` not populated → silent default routing | VZ platform owner | Default to Studio Lead Queue + flag in alert. |
| Pipefy quota hit during build | dYdX delivery lead | Pre-check quota at Stage 4a. |
| Alert routing target undecided | VZ studio lead | Resolve in discovery §10 follow-up before Stage 4a. |

**Client dependencies before kickoff to build:** confirm both discovery §11 assumptions; resolve discovery §10 alert routing target.

## 6. Acceptance

- New phase + routing automation deployed to VZ production pipe.
- Test plan (Stage 8) demonstrates 100% correct routing across Gold / Silver / Bronze / null fixtures.
- Phase-duration alert fires on a deliberately-stuck test card.
- Studio lead signs off on operator runbook.

## 7. Commercial framing

- **TBC** — rates, structure, payment cadence to be filled by commercial lead.
- Discovery §9 notes v1 must fit current cost window — commercial lead to confirm fit.

## 8. Timeline

- High-level milestone: Stages 4a → 7a → 8 → 9 within current quarter (±5 business days).

## 9. Architectural notes

- Single Pipefy pipe; no multi-tenant concerns.
- Routing is data-driven (`customer_tier`), not rule-coded — future tier additions are configuration, not engineering.
- Alert observability is the only new failure surface; mitigated by phase-duration automation.
