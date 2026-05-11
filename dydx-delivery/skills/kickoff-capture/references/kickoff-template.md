<!--
  kickoff_branch enum values:
    - discovery-ready : Stage 2 (discovery-intake) will run against this kickoff. Default for engagements with material unknowns.
    - draft-sow       : Stage 2 will be SKIPPED. Use when the engagement is well-enough understood to draft a SOW directly from the kickoff.
  Reviewer: edit the `kickoff_branch:` line below to one of the two values at write time.
-->

> **Valid values for `kickoff_branch:`** — `discovery-ready` (Stage 2 runs) | `draft-sow` (Stage 2 skipped). Edit the frontmatter line below to one of these two values at write time.

---
client: <CLIENT_NAME>
project: <PROJECT_NAME>
frontmatter_version: 2
kickoff_branch: discovery-ready
field_notes_processed_count: <N>
status: draft
based_on_kickoff: <upstream-CR-id-or-N/A-for-fresh-engagement>
---

# Kickoff — <CLIENT_NAME> · <ENGAGEMENT_NAME>

> Stage 1 of the dydx-delivery pipeline. Captures the operational reality of an engagement / change request so downstream stages (discovery / SOW / fnspec / tech-spec) have a real foundation. Mark every unknown explicitly using the `[unknown — needs human classification]` marker convention — do not guess.

## 1. System

What is being built or changed? Describe the current state and the target state.

| Field | Value |
|---|---|
| Current state | *[unknown — needs human classification]* |
| Target state | *[unknown — needs human classification]* |
| Scope edges | *Where the system stops; what is explicitly out.* |

*Narrative*: <one-paragraph description of the workflow under consideration.>

## 2. Users

Who does the workflow serve? Name primary actors and secondary stakeholders.

| Role | Type (primary / secondary) | Notes |
|---|---|---|
| *[unknown — needs human classification]* | — | — |

## 3. Triggers

What kicks off the workflow? Manual, scheduled, event-driven, or some mix?

| Trigger | Mode (manual / scheduled / event) | Frequency / cadence |
|---|---|---|
| *[unknown — needs human classification]* | — | — |

## 4. Data

What inputs does the workflow consume? What outputs does it produce? Where does data live?

| Data element | Direction (in / out) | Source / sink | Persistence boundary |
|---|---|---|---|
| *[unknown — needs human classification]* | — | — | — |

## 5. Rules

Business logic, conditional branches, approval gates.

- *[unknown — needs human classification]* — rule statement, who owns it, when it fires.

## 6. Integrations

External systems involved — platforms (Pipefy / Wrike / Ziflow), SaaS APIs, paste-fed surfaces.

| Integration | Direction (in / out / bidirectional) | Auth model | Volume / cadence |
|---|---|---|---|
| *[unknown — needs human classification]* | — | — | — |

## 7. Exceptions

Non-happy paths, error states, reviewer overrides.

- *[unknown — needs human classification]* — exception condition + recovery / escalation path.

## 8. Failure points

Known fragility, integration boundaries, observability gaps. What is going to break first, and what won't tell us when it does?

- *[unknown — needs human classification]* — failure mode + current detection (or lack of it).

## Routing

**kickoff_branch:** (set in frontmatter — choose one)

- `discovery-ready` — discovery is needed before SOW; routes to Stage 2 (`discovery-intake`).
- `draft-sow` — engagement is well-enough understood to skip discovery; routes directly to Stage 3 (`generate-sow`). Stage 2 will emit `Stage 2 SKIPPED — kickoff branch = draft-sow` and write no `02_discovery_v<N>.md` artefact.

**Rationale:** <one-paragraph explanation of why this branch fits this engagement.>

## Sign-off

| Field | Value |
|---|---|
| Captured by | <reviewer name> |
| Captured on | <YYYY-MM-DD> |
| Approval status | draft |
| Approved by | *(set on status: approved)* |
| Approved on | *(set on status: approved)* |

Approval gates this artefact's transition to `status: approved`. Downstream stages (`discovery-intake`, `generate-sow`) MUST refuse to read this kickoff while `status: draft`.
