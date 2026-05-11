---
client: VodafoneZiggo
platform: pipefy
integrations: []
version: 1
status: approved
based_on_kickoff: 01_kickoff_v1.md
captured_by: phase-7-e2e-smoke-reviewer
captured_at: 2026-05-11
fixture_run: true
---

# Discovery — VodafoneZiggo · Ticket Auto-Routing by Tier

> Stage 2 of the dydx-delivery pipeline. Pure transform of approved `01_kickoff_v1.md` per STG2-01 / DESIGN-18.

---

## 1. Business outcome

**Why this matters:** Gold-tier SLA missed ~20% of weeks today; revenue exposure on tier-1 accounts.

**Success in 3 months:** Zero Gold-tier SLA breaches attributable to triage delay; automated routing live in Pipefy production pipe.

**Success in 12 months:** Tier-aware routing extended to scheduled re-prioritisation if tier upgrades occur mid-ticket.

---

## 2. Users and ownership

| Role | What they do | Technical level | Owner / decision-maker |
|---|---|---|---|
| Studio lead (VZ) | Consumes Studio Lead Queue | Med | VZ Studio Lead |
| Director (VZ) | Consumes Director Queue | Med | VZ Director |
| Platform engineer (dYdX) | Implementer | High | dYdX delivery lead |

**Workflow owner:** VZ Studio Lead.

**Adoption risk:** Low — same humans consume queues; only routing automated.

---

## 3. Systems

**Primary platform:** pipefy

**Supporting systems:** none for v1.

**Already automated:** card creation, phase progression via standard Pipefy automations.
**Manual today:** tier-based re-ordering from Coda view by studio lead.

---

## 4. Triggers

| Trigger | Type | Frequency | Notes |
|---|---|---|---|
| Card lands in `Triage Phase` with `customer_tier != null` | Event | ~50/wk | Per kickoff Section 3. |

---

## 5. Data

| Field | Origin | Destination | Sensitivity |
|---|---|---|---|
| `customer_tier` | Pipefy card field | Pipefy phase routing | None |

---

## 6. Rules

**Decision logic (resolved from kickoff unknowns):**
- `customer_tier == Gold` → Director Queue.
- `customer_tier in {Silver, Bronze}` → Studio Lead Queue.
- `customer_tier == null` → Studio Lead Queue (default); flag for operator review. **(resolves kickoff §7 unknown)**
- Mid-ticket tier upgrade: v1 stays manual per studio lead; out of scope. **(resolves kickoff §5 / §7 unknown)**

---

## 7. Integrations

None in scope.

---

## 8. Exceptions and failure points

**Resolved from kickoff:**
- Null tier defaults to Studio Lead Queue (see Rules) — not blocked.
- Mid-ticket tier upgrade out of scope for v1.

**Observability gap (kickoff §8 unknown — still open):** No SLA timer on the new phase; ops blind to stuck cards. **Mitigation in scope:** add a Pipefy phase-duration alert (>2 business days) routed to studio lead.

---

## 9. Constraints

**Technical:** Cannot add Pipefy automation steps beyond Pipefy free-tier limits without commercial approval.
**Commercial:** v1 must fit current cost window (per kickoff timeline note).
**Time:** Target delivery within current quarter.

---

## 10. Open questions

- [ ] Confirm Pipefy automation-step quota available on VZ pipe.
- [ ] Confirm phase-duration alert routing target (studio lead Slack DM vs Pipefy notification).

---

## 11. Assumptions made

- `customer_tier` is reliably populated upstream — to be confirmed by VZ studio lead.
- Director and Studio Lead queues are already-existing Pipefy phases — to be confirmed by VZ platform owner.

---

## Handoff

Approved. Ready for `generate-sow` against this discovery.
