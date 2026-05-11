---
client: Up & Up Group
platform: wrike
integrations: [ziflow]
frontmatter_version: 2
version: 2
status: draft
based_on_kickoff: 01_kickoff_v2.md
generated_at: 2026-05-11
captured_by: phase-7-e2e-smoke-reviewer
fixture_run: true
---

# SOW — Up & Up Group · Creative Review Handoff

> Stage 3 (draft-sow path). Generated DIRECTLY from `01_kickoff_v2.md` per DESIGN-19 dual-input contract; Stage 2 (discovery-intake) was SKIPPED per STG2-02 — kickoff_branch: draft-sow.

## 1. Business outcome

Eliminate manual Wrike-to-Ziflow handoff for creative-review workflow; auto-create Ziflow reviews on asset upload; route to Senior vs Junior reviewer queue by `asset_type`; roll client approval back to Wrike task completion.

## Platform Scope

In-scope deliverables — consumed by Stage 4a (`generate-fnspec-platform`):

- **Wrike automation**: on task `Creative Asset Uploaded` transition to Done, fire outbound webhook (existing integration).
- **Ziflow review template** parameterised by `asset_type`:
  - Video → Senior Reviewer Queue
  - Static → Junior Reviewer Queue
  - Null `asset_type` → Senior Reviewer Queue (safer default per kickoff §7)
- **Ziflow → Wrike state-back configuration**: client approval triggers Wrike task `Done` transition.
- **Operator runbook page** (Coda) describing the new automation, routing rules, and exception handling.

## Integration Scope

In-scope integrations — consumed by Stage 4b (`generate-fnspec-integration`):

- **Wrike → Ziflow (outbound)**: extend existing API-token integration to auto-create Ziflow reviews on the `Creative Asset Uploaded` Done event.
- **Ziflow → Wrike (inbound)**: extend existing webhook-back integration to flip Wrike task state on client approval.
- Both integrations already exist in production for unrelated review workflows; this work is a configuration extension, not a net-new integration.

## 2. Out-of-scope

- New Wrike custom fields beyond what the existing creative-review template already provides.
- Ziflow account migration or tenancy changes.
- Custom approval-routing logic beyond `asset_type` (e.g. tier-based, time-based, region-based).
- Creative-team upload-flow UX changes.
- Reporting / analytics dashboards.

## 3. Approach and phases

1. Stage 4a — platform fnspec covering Wrike automation + Ziflow review template config.
2. Stage 4b — integration fnspec covering the Wrike↔Ziflow webhook extensions.
3. Stage 5 — tech spec (addendum-only scope; existing integrations).
4. Stage 6 — cost estimate.
5. Stage 7a — build prompt; dYdX platform engineer.
6. Stage 8 — test plan against UUG sandbox tenant.
7. Stage 9 — operator runbook publish; Stage 11 sign-off.

## 4. Assumptions

- Existing Wrike↔Ziflow API token + webhook surface has sufficient quota for ~20–40 events/wk.
- `asset_type` is a populated Wrike custom field at the point of `Creative Asset Uploaded` Done transition.
- Senior + Junior reviewer queues already exist in Ziflow on the UUG tenant.

## 5. Risks and dependencies

| Risk | Owner | Mitigation |
|---|---|---|
| `asset_type` unset at routing time | UUG creative team | Default to Senior queue per kickoff §7; reviewer can re-route. |
| Wrike/Ziflow webhook latency spikes during peak periods | dYdX platform engr | Observability via existing Ziflow ops dashboard per kickoff §8. |
| Existing integration auth-token rotation timing | UUG IT | Coordinate token rotation outside delivery window. |

**Client dependencies before kickoff to build:** confirm `asset_type` field is reliably populated; confirm Ziflow Senior/Junior queues exist.

## 6. Acceptance

- Auto-creation of Ziflow review fires on every `Creative Asset Uploaded` Done event (zero manual handoffs in test window).
- Routing matrix passes for Video / Static / null `asset_type` fixtures.
- Client approval in Ziflow flips Wrike task to Done (verified end-to-end).
- Operator runbook signed off by UUG studio lead.

## 7. Commercial framing

- **TBC** — rates, structure, payment cadence to be filled by commercial lead.

## 8. Timeline

- High-level milestone: Stages 4a/4b → 7a → 8 → 9 within current quarter (±5 business days).

## 9. Architectural notes

- Configuration extension to two existing production integrations; no net-new surface.
- Routing is data-driven (`asset_type`) — future asset types add as configuration rows in the review template, not engineering.
- Stage-2 discovery was SKIPPED per kickoff routing — the kickoff carried sufficient operational signal for direct SOW drafting.
