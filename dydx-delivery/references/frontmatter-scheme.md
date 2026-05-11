# dYdX Delivery — Frontmatter scheme (canonical)

> Canonical SoT for the v2 frontmatter scheme per DESIGN-01 (`.planning/DESIGN.md:62-74`). Approval-gate fields per DESIGN-06 (`.planning/DESIGN.md:147-158`). Migration co-existence + lenient-mode contract per DESIGN-08 (`.planning/DESIGN.md:181-193`). Lenient-mode reader behaviour is PERMANENT (not cutover-date-tied) per OPEN-Q15.

## Status lifecycle

Canonical v2 status values (ordered):

1. `draft`
2. `client_review`
3. `approved`
4. `archived`

State-machine arrows:

```
draft → client_review → approved → archived
```

`client_review` is retained per the live status-lifecycle survey (see `.planning/phases/05-foundations/05-STATUS-SURVEY.md` for the Phase 5 W1 re-run reproducing the DESIGN-08 baseline) — `generate-sow` produces SoW artefacts in `client_review` state today (v0.3.0 live use per AUDIT-01.2). Skipping `client_review` is permitted only on artefacts that have no review gate in their stage contract.

## Field-name conventions

- **Underscore-snake-case** for frontmatter keys: `based_on_kickoff`, `based_on_discovery`, `based_on_sow`, `based_on_fnspec_platform`, `based_on_fnspec_integration`, `based_on_techspec`, `based_on_cost`, `pipe_id`, `space_id`, `project_id`, `approved_by`, `approved_at`, `tier_claims_last_verified`, `frontmatter_version`, `generated_at`, `native_ai_path`, `doc_published_at`, `last_diff_review_at`.
- **Hyphen-kebab-case** for file paths inside `based_on_*` values (e.g., `based_on_techspec: 05_techspec_v1.md`).

## Platform-gated identifiers

Frontmatter MUST omit platform-specific sandbox identifiers that do not match the artefact's `platform:` value. The `validate-frontmatter` hook (DESIGN-04) rejects a Wrike artefact carrying `pipe_id`, etc.

- `pipe_id` — only when `platform: pipefy`
- `space_id` — only when `platform: wrike`
- `project_id` — only when `platform: ziflow`

## Canonical v2 artefact frontmatter

```yaml
---
client: <CLIENT_NAME>
feature: <feature-slug>
platform: <pipefy | wrike | ziflow | other>
version: 1
status: draft | client_review | approved | archived
based_on_technical_spec: 05_techspec_v<N>.md
frontmatter_version: 2
generated_at: <YYYY-MM-DD>
approved_by: <human-name>            # required when status: approved
approved_at: <ISO-8601 timestamp>    # required when status: approved
sandbox:
  pipe_id: <id>                      # only when platform: pipefy
  space_id: <id>                     # only when platform: wrike
  project_id: <id>                   # only when platform: ziflow
  tenant: <name>
---
```

## Approval-gate fields (DESIGN-06)

Per DESIGN-06 (`.planning/DESIGN.md:147-158`), every write that sets `status: approved` MUST carry:

- `approved_by: <human-name>` — the human author who signed off. Hook refuses literal `Claude` / `AI` / `system` / agent strings.
- `approved_at: <ISO-8601 timestamp>` — when the sign-off was recorded.

The `validate-frontmatter` hook (DESIGN-04; substantive implementation deferred to v2.6 / SURF-01..03) refuses any `status: approved` write lacking either field. Both fields are mandatory; neither has a default.

## Lenient-mode contract (PERMANENT)

v2 readers tolerate v0.3.0 frontmatter that is missing the `frontmatter_version` field. When `frontmatter_version` is absent, the reader assumes v0.3.0 conventions: do not raise on missing `archived` status / `approved_by` / `approved_at`. v0.3.0 in-flight artefacts are NEVER auto-flipped (per DESIGN-08); migration is opt-in per CR. This is not tied to a cutover date — it is the permanent reader contract per OPEN-Q15.

## Migration co-existence (DESIGN-08)

Per DESIGN-08 (`.planning/DESIGN.md:181-193`):

- `client_review` retained in canonical lifecycle. Live use in `generate-sow` today (AUDIT-01.2) — dropping the value would orphan in-flight SoWs.
- No bulk rewriting of v0.3.0 artefact files. v0.3.0 files stay at old prefixes on disk (lenient-mode read tolerance).
- Cross-ref `stage-numbering.md` § "Old → new mapping table (v0.3.0 → v2)" + § "Lenient-mode policy (PERMANENT)" for the file-prefix tolerance side of the contract. This document covers the frontmatter side (status / `frontmatter_version` / approval-gate fields); the stage-numbering reference covers the filename side.

## Status-survey result

`.planning/phases/05-foundations/05-STATUS-SURVEY.md` conclusion: **no drift** — every status value found in the v0.3.0 skill sources (`draft`, `client_review`, `approved`) maps cleanly to the canonical v2 lifecycle. `archived` is reserved for Stage 11 sign-off-and-archive writes per DESIGN-27 (net-new in v2, no orphan risk).
