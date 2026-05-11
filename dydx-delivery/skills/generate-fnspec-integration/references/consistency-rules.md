# Stage 4b consistency rules — D-84 + ROUTE-01

This file documents the three cross-spec consistency checks owned by Stage 4b per D-84 + ROUTE-01. These checks run FIRST in `generate-fnspec-integration/SKILL.md` Step 3, before any `04b_fnspec-integration_v<N>.md` write. On any failure, the skill writes `04b_consistency_check_v<N>.md` listing the failure rows and HALTS — no fnspec is produced until the reviewer resolves the failure and re-invokes Stage 4b.

## The three checks (D-84 + ROUTE-01)

### Check (a) — Conflicting delivery tags across 4a and 4b

For every requirement ID present in BOTH 4a and 4b, the `delivery:` tag MUST match.

**Conflict example.** 4a row carries `REQ-12: delivery: native-ai [HIGH, src: platform-pipefy]`; 4b row for the same requirement carries `REQ-12: delivery: api [reviewer-override: api]`. The routing key disagrees for the same requirement — this is the canonical (a) failure.

**Trigger logic.** Parse all rows in 4a sections 4 / 5 / 8 + all rows in 4b sections 4 / 5 / 5a / 8. Collect `(req_id, delivery_value)` pairs from each. Flag any `req_id` that appears in both sets with non-identical `delivery_value`. A row with `[reviewer-override:]` token in EITHER spec is authoritative for that side — the conflict surfaces against the override-resolved value.

### Check (b) — Dangling 4b integration touchpoints

Every row in 4b section 4 (Integration touchpoints) MUST cite a referenced platform requirement ID from 4a in its `Cites 4a req` column.

**Dangling = either:** (1) the `Cites 4a req` column is empty / `n/a` / `TBD` for that row, OR (2) the column cites a `req_id` that does NOT exist in 4a.

**Trigger logic.** Parse 4b section 4. For each row's cited `req_id`, assert it appears as a row identifier in 4a sections 4 / 5 / 8. If absent or empty → dangling failure.

**Topology exemption.** On the 4b-only topology (`04a_fnspec-platform_v*.md` does not exist), check (b) is VACUOUSLY satisfied — there is no 4a to cite into. The 4b template `Cites 4a req` column may be omitted or filled with `n/a` on 4b-only.

### Check (c) — Orphan API endpoints in 4b

Every row in 4b section 5a (API endpoints) MUST map to a 4a requirement ID via the `Cites 4a req` column.

**Orphan = either:** (1) the endpoint row's `Cites 4a req` column is empty, OR (2) cites a `req_id` that does NOT exist in 4a sections 4 / 5 / 8.

**Trigger logic.** Parse 4b section 5a. Same trigger logic as check (b), scoped to endpoints.

**Topology exemption.** Same as check (b) — vacuously satisfied on 4b-only topology.

## Halt-on-failure protocol (D-84 + ROUTE-02)

On ANY failure (any of (a), (b), or (c) fails on any row):

1. Write `04b_consistency_check_v<N>.md` to `<Client> Brain/<Project>/` with the frontmatter contract below.
2. Emit halt message to stdout naming the artefact filename.
3. EXIT WITHOUT writing `04b_fnspec-integration_v<N>.md`.

**Versioning.** First failure → `04b_consistency_check_v1.md`. If the reviewer resolves the failures and re-invokes Stage 4b and a NEW failure surfaces → `04b_consistency_check_v2.md`. The version counter is independent of the eventual `04b_fnspec-integration_v<N>.md` counter.

**Clean checks leave no audit footprint.** On a successful re-run (all three checks pass on every row), write `04b_fnspec-integration_v<N>.md` normally — do NOT write a fresh consistency-check artefact on the clean path. The clean-run audit footprint is intentionally absent per D-84 (only failures are persisted as artefacts).

**Halt before any fnspec write.** This is the critical structural invariant: no `04b_fnspec-integration_v<N>.md` may exist on disk for a run where any of (a) / (b) / (c) failed. If a stale fnspec exists from a prior clean run, leave it alone — the new halt artefact does not delete prior approved work.

## 04b_consistency_check_v<N>.md frontmatter contract

```yaml
---
client: <CLIENT_NAME>
project: <PROJECT_NAME>
frontmatter_version: 2
artefact_type: consistency_check_failure
based_on_fnspec_platform: 04a_fnspec-platform_v<N>.md
based_on_attempted_fnspec_integration: <intended-04b-filename-or-N/A-if-pre-write>
checks_run: 3
checks_failed: <N>
status: halt
generated_at: <ISO date>
---
```

Field semantics:

- `artefact_type: consistency_check_failure` — distinguishes this halt artefact from the normal `04b_fnspec-integration_v<N>.md` artefact in downstream tooling (e.g., structure-check, future Stage 5).
- `based_on_attempted_fnspec_integration:` — the filename the skill *would have* written had checks passed. Set to `N/A` when the failure was detected pre-write (typical case).
- `checks_run: 3` — always 3 in v2.2 (checks (a) / (b) / (c)).
- `checks_failed: <N>` — count of distinct check IDs that failed at least once. Range 1-3.
- `status: halt` — non-canonical (does not appear in the 4-state lifecycle). Distinguishes halt artefacts from normal `draft / client_review / approved / archived` artefacts.

## Failure-report body template

```markdown
# Stage 4b Consistency Check Failure — <CLIENT> · <PROJECT>

Three consistency checks ran. <N> failed. No `04b_fnspec-integration_v<M>.md` was written.

## Failure rows

| Check ID | Failure type | Row reference | Detail | Suggested resolution |
|----------|--------------|---------------|--------|----------------------|
| (a)      | Conflicting delivery tags | REQ-12 in 4a row L23 + 4b row L45 | 4a: native-ai [HIGH, src: platform-pipefy]; 4b: api [reviewer-override: api] | Reviewer decides authoritative routing for REQ-12; align both rows + re-invoke 4b. |
| (b)      | Dangling 4b touchpoint | 4b Section 4 row 3 (Touchpoint TP-07) | Cites 4a req `REQ-99` which does NOT exist in 4a | Edit TP-07 in 4b to cite an existing 4a req OR add REQ-99 to 4a + re-approve 4a first. |
| (c)      | Orphan API endpoint | 4b Section 5a row 2 (Endpoint EP-04) | Cites 4a req column is empty | Map EP-04 to a 4a req OR remove EP-04 from 4b scope. |

## Retry mechanics

Reviewer resolves each failure row above (edit 4a OR 4b as appropriate), then re-invokes Stage 4b. If checks pass on retry, `04b_fnspec-integration_v<N>.md` is written. If new failures surface, a new `04b_consistency_check_v<N+1>.md` is written.
```

## Reviewer-retry mechanics

Failure resolution may live in either 4a OR 4b, by reviewer judgement:

- **Resolution in 4a.** If the failure points to a 4a authoring gap (e.g., missing requirement, wrong `delivery:` classification), the reviewer edits 4a, re-approves 4a (status flips back through `draft → client_review → approved` per the canonical lifecycle), then re-invokes Stage 4b.
- **Resolution in 4b.** If the failure points to a 4b drafting mistake (e.g., dangling cite to a renamed 4a req, orphan endpoint that should be removed from scope), the reviewer edits the draft 4b inputs + re-invokes Stage 4b. 4a is unchanged.
- **No silent fix.** Stage 4b never auto-fixes failures — every retry is a new explicit reviewer pass. Auto-fix would violate the D-81 reviewer-authority invariant.

## Two-place key-decisions cross-reference (T-02-06-02 mitigation)

Per ROUTE-01 mitigation T-02-06-02, the consistency-check ownership AND the routing-key contract are declared in BOTH `generate-fnspec-platform/SKILL.md` (4a) AND `generate-fnspec-integration/SKILL.md` (4b) `## Key decisions` sections — naming D-78 (TD-2 ziflow enum), D-79 (Platform-API Addendum carrier), D-82 (per-row routing markup), D-84 (consistency check ownership), and D-85 (either-spec-skip mechanics). The cross-reference avoids single-source drift: if one SKILL.md is edited and a decision is dropped, the other SKILL.md still names it explicitly, and the I8 structure-check assertion catches the divergence at gate time. The 4b structure-check assertion I8 verifies BOTH halves are present.

## How this rubric is consumed

`generate-fnspec-integration/SKILL.md` Step 3 references this file by relative path. Structure-check assertions I6 + I7 grep-assert the three check letters (`Check (a)` / `Check (b)` / `Check (c)`) AND the halt-on-failure contract (`04b_consistency_check_v` filename + `artefact_type: consistency_check_failure` frontmatter) are documented in BOTH this file AND SKILL.md. I6 + I7 fail-loud at the section gate if either file drifts.
