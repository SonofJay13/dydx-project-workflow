---
gsd_state_version: 1.0
milestone: v2.2
milestone_name: Stage 1 Kickoff + Stage 4 Fnspec Split
status: Not started — roadmap locked, awaiting plan-phase
stopped_at: Phase 7 context gathered
last_updated: "2026-05-11T08:21:54.459Z"
last_activity: 2026-05-11 — v2.2 ROADMAP.md locked (Phase 7 + Phase 8 mapped against 21 reqs; 100% coverage)
progress:
  total_phases: 2
  completed_phases: 0
  total_plans: 0
  completed_plans: 0
---

# STATE

## Project Reference

See: `.planning/PROJECT.md` (updated 2026-05-11)

**Core value:** Plugin behaves as a senior implementation partner end-to-end — every stage produces an artefact polished enough to send to a client or hand to a developer without rework, and every change request leaves the client's brain, documentation, and native-AI knowledge bases coherent and up to date.

**Current focus:** v2.2 milestone — Phase 7 (Stage 1 Kickoff + Discovery/SOW upstream wiring) ready to plan. Phase 8 (Stage 4 Fnspec Split + ROUTE incl. TD-2 inline) sequenced after Phase 7.

## Current Position

Phase: 7 — Stage 1 Kickoff + Discovery/SOW upstream wiring
Plan: —
Status: Not started — roadmap locked, awaiting plan-phase
Last activity: 2026-05-11 — v2.2 ROADMAP.md locked (Phase 7 + Phase 8 mapped against 21 reqs; 100% coverage)
Next step: `/gsd-discuss-phase 7`

## Deferred Items

Items acknowledged and deferred at v2.1 milestone close on 2026-05-11:

| Category | Item | Status |
|----------|------|--------|
| uat_gap | Phase 02 — 02-HUMAN-UAT.md | resolved (false-positive — 0 pending scenarios; file marker classifies it as a gap) |
| verification_gap | Phase 02 — 02-VERIFICATION.md | human_needed (lingering marker from v2.0 design milestone; v2.0 was implicitly accepted 2026-05-10 but never CLI-closed) |
| tech_debt | Stage-skill `platform:` enum vs `platform-ziflow` routing claim (TD-2) | In scope for v2.2 Phase 8 — ROUTE-04 (resolved inline as part of Stage 4 Fnspec Split routing-key contract per DESIGN-20 sub-decision) |

## Performance Metrics

**Velocity (cumulative across milestones):**

- Total plans completed: 19 (v2.1: 9 plans across Phases 5-6; v2.0: 31 plans across Phases 1-4 — design-only)
- Notable: v2.1 averaged ~11 min per plan; parallel Wave 2 execution of Wrike + Ziflow plans cut wall-time roughly in half

**v2.2 forecast:**

| Phase | Plans | Notes |
|-------|-------|-------|
| 7. Stage 1 Kickoff + Discovery/SOW upstream wiring | TBD | 10 reqs across 3 stage skills (1 NEW + 2 MODIFIED) |
| 8. Stage 4 Fnspec Split + ROUTE | TBD | 11 reqs across 2 NEW skills + 1 RETIRED + cross-cutting ROUTE + TD-2 inline |

*Plan completion log resumes at first Phase 7 plan land.*

## Accumulated Context

### Decisions

Full log in PROJECT.md Key Decisions table. Recent decisions affecting current work:

- v2.2 phase numbering CONTINUES from v2.1 — Phase 7 + Phase 8 (no `--reset-phase-numbers`)
- v2.2 phase shape locked at 2 phases (not 3) — Phase 7 bundles STG1+STG2+STG3 because STG2/STG3 are downstream consumers of the kickoff artefact contract (`based_on_kickoff:` MANDATORY; `kickoff_branch:` routes); landing them with STG1 in the same phase means the pipeline lights up end-to-end through Stage 3 for both `discovery-ready` and `draft-sow` branches before Phase 8 starts
- v2.2 Phase 8 bundles STG4+ROUTE per D-63 per-platform-atomic-slicing precedent — STG4 split (4a/4b) + ROUTE consistency check + Stage 5 scope-gate forward-compat + TD-2 inline + delivery routing-key propagation are all tightly coupled to the DESIGN-20 contract; ship as one atomic phase
- TD-2 (ROUTE-04) is INLINE in Phase 8 Stage 4 split work — NOT a separate phase
- Phase 7 → Phase 8 dependency is strict — Stage 4a reads approved `02_discovery_v*` + approved `03_sow_v*` produced by Phase 7's MODIFIED discovery-intake + generate-sow
- v2.1 retrospective lessons applied to v2.2 plan-phase wiring:
  - Wire phase execution to auto-flip REQUIREMENTS.md trace table OR run audit-milestone before close — manual flips lagged in v2.1 (TD-1 surfaced at v2.1 close)
  - Cross-AI review at plan time MUST verify downstream consumers (TD-2 would have been caught earlier); Phase 8 plan must verify ROUTE-04 resolution against ALL stage skills, not just the one being edited
  - Per-phase structure-check.sh with `--section` flag is the right shape for parallel plans within a phase if the phase has disjoint sub-trees (Phase 8's 4a + 4b directories are disjoint — eligible for parallel Wave 2 execution)

### Pending Todos

None at roadmap-lock.

### Blockers/Concerns

None at v2.2 roadmap lock. Phase 7 and Phase 8 are NOT research-blocked per CHANGELIST.md Phase 3 mini-table (Research-blocked cell = `—`). The DESIGN-17/18/19/20/21 contracts are locked verbatim; Phase 7/8 implementation work executes against locked design.

## Session Continuity

Last session: 2026-05-11T08:21:54.451Z
Stopped at: Phase 7 context gathered

Previously: v2.1 milestone close 2026-05-11 — Phase 6 P04 reviewer-ready signal; 17 OPEN-Q + 13 FOUND + 6 PLAT requirements all SATISFIED; phase dirs archived to `.planning/milestones/v2.1-phases/`; RETROSPECTIVE.md created; v2.0 phase dirs archived to `.planning/milestones/v2.0-phases/` at v2.2 kickoff (deferred archive of design-only milestone).

Resume file: .planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/07-CONTEXT.md

## Operator Next Steps

- Run `/gsd-discuss-phase 7` to plan Phase 7 (Stage 1 Kickoff + Discovery/SOW upstream wiring)
- After Phase 7 ships, run `/gsd-discuss-phase 8` for Stage 4 Fnspec Split + ROUTE (incl. TD-2 inline)
