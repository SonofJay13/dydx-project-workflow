---
client: Up & Up Group
project: creative-review-handoff
frontmatter_version: 2
kickoff_branch: draft-sow
field_notes_processed_count: 0
status: approved
based_on_kickoff: N/A
captured_by: phase-7-e2e-smoke-reviewer
captured_at: 2026-05-11
fixture_run: true
source_fixture: .planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/fixtures/sample-cr-miro-paste.md
---

# Kickoff — Up & Up Group · Creative Review Handoff

> Stage 1 of the dydx-delivery pipeline. Captured from a text-canonical Miro narration per DESIGN-07 / AUDIT-08.

## 1. System

| Field | Value |
|---|---|
| Current state | Manual handoff from Wrike task completion to Ziflow review creation. |
| Target state | Auto-create Ziflow review when Wrike "Creative Asset Uploaded" task transitions to Done; auto-route to Senior vs Junior reviewer queue by `asset_type`. |
| Scope edges | Wrike → Ziflow handoff only; client-approval feedback already returns to Wrike via existing Ziflow integration. |

*Narrative*: When a creative asset lands in Wrike, create a Ziflow review automatically; branch the review queue by asset type (Video → Senior, Static → Junior); roll the approval state back to Wrike task `Done` on client approval.

## 2. Users

| Role | Type | Notes |
|---|---|---|
| Senior reviewer (UUG) | primary | Reviews Video assets. |
| Junior reviewer (UUG) | primary | Reviews Static assets. |
| Client (UUG) | primary | Final approval gate. |
| Creative team (UUG) | secondary | Uploads assets to Wrike. |

## 3. Triggers

| Trigger | Mode | Frequency / cadence |
|---|---|---|
| Wrike task `Creative Asset Uploaded` transitions to Done | event | Per asset; ~20–40/wk. |

## 4. Data

| Data element | Direction | Source / sink | Persistence boundary |
|---|---|---|---|
| Asset file | in | Wrike task attachment | Stays in Wrike; URL referenced in Ziflow. |
| `asset_type` | in | Wrike task field (Video / Static) | Drives routing. |
| Reviewer decision | out | Ziflow → Wrike task state | Persisted in both. |
| Client decision | out | Ziflow → Wrike task `Done` | Persisted in Wrike. |

## 5. Rules

- `asset_type == Video` → Senior Reviewer Queue.
- `asset_type == Static` → Junior Reviewer Queue.
- Reviewer approval gates client review (sequential approval).
- Client approval gates Wrike task `Done` transition.

## 6. Integrations

| Integration | Direction | Auth model | Volume / cadence |
|---|---|---|---|
| Wrike → Ziflow | out | API token (existing integration) | Per asset event. |
| Ziflow → Wrike | in | Webhook + token | Per approval event. |

## 7. Exceptions

- Asset uploaded without `asset_type` set → route to Senior Reviewer Queue (safer default); reviewer can re-route after triage.
- Client rejects → asset returns to creative team via existing Wrike comment thread; no new automation needed.

## 8. Failure points

- Wrike-Ziflow webhook delivery: existing integration already in production; observability lives in Ziflow operational dashboard. No new failure surface.

## Routing

**kickoff_branch:** `draft-sow` (set in frontmatter)

**Rationale:** The Miro narration covered all 8 sections cleanly — every routing rule, integration, and exception is declared from the diagram + decision points. No `[unknown — needs human classification]` markers remain after Step 2 classification. Engagement is well-enough understood to draft an SOW directly. Stage 2 SKIPPED — kickoff feeds Stage 3 (`generate-sow`) directly.

## Sign-off

| Field | Value |
|---|---|
| Captured by | phase-7-e2e-smoke-reviewer |
| Captured on | 2026-05-11 |
| Approval status | approved |
| Approved by | phase-7-e2e-smoke-reviewer |
| Approved on | 2026-05-11 |
