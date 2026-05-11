---
client: VodafoneZiggo
project: ticket-routing-phase-add
frontmatter_version: 2
artefact_type: consistency_check_failure
based_on_fnspec_platform: 04a_fnspec-platform_v1.md
based_on_attempted_fnspec_integration: N/A-pre-write
checks_run: 3
checks_failed: 1
status: halt
generated_at: 2026-05-11
fixture: true
fixture_for: phase-8-e2e-smoke
---

# 04b Consistency Check — VodafoneZiggo Ticket Routing Phase Add — HALT

> Phase 8 e2e smoke halt-path fixture. Synthetic conflict injection demonstrating the ROUTE-02 halt-on-failure protocol. The skill `generate-fnspec-integration` would emit this artefact + STOP before any `04b_fnspec-integration_v*.md` write. NOT a real client artefact — `fixture: true` flags non-production status.

## Halt summary

| Check | Result | Details |
|---|---|---|
| Check (a) — No conflicting `delivery:` tags | **FAIL** | REQ-3 conflict: 4a says `native-ai`; attempted 4b says `api`. Halts before fnspec write. |
| Check (b) — Integration touchpoints cite 4a req IDs | n/a (not reached) | Check halts after first failure per ROUTE-02. |
| Check (c) — No orphan API endpoints | n/a (not reached) | Check halts after first failure per ROUTE-02. |

## Failure-row table

| Check ID | Failure type | Row reference | Detail | Suggested resolution |
|---|---|---|---|---|
| (a) | Conflicting delivery tags | REQ-3 (4a) vs INT-X (attempted 4b) | 4a REQ-3 carries `delivery: native-ai [HIGH, src: platform-pipefy]`. Attempted 4b row REQ-3 carries `delivery: api [reviewer-override: api]`. The routing key must agree across specs per D-82 + D-84. | Reviewer decides authoritative routing for REQ-3. If native-ai: drop the 4b row OR cite a different 4a req from 4b. If api: edit 4a REQ-3 + bump 4a `_v2.md` + re-approve before re-running 4b. |

## Next step

Per ROUTE-02:

1. Reviewer reads this halt artefact + reconciles REQ-3 routing.
2. Edits the authoritative source spec (either 4a or attempted-4b draft).
3. Re-runs `generate-fnspec-integration` against the reconciled inputs.
4. On clean Check (a) + (b) + (c), 4b emits `04b_fnspec-integration_v<N>.md` + no halt artefact.

> Operator note: this is a documentation fixture. The runtime skill is not exercised on this fixture path. See `dydx-delivery/skills/generate-fnspec-integration/references/consistency-rules.md` for the live skill's halt-on-failure contract.
