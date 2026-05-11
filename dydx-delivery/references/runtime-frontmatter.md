# dYdX Delivery Runtime Frontmatter

Use this file for normal stage execution. The larger `frontmatter-scheme.md` remains the detailed maintenance reference.

## Required common fields

```yaml
---
client: <CLIENT_NAME>
project: <PROJECT_NAME>
platform: <pipefy | wrike | ziflow | other>
frontmatter_version: 2
version: <N>
status: draft
generated_at: <YYYY-MM-DD>
---
```

## Status values

- `draft` - newly written, not approved.
- `client_review` - in reviewer or client review.
- `approved` - signed off by a human.
- `archived` - closed and moved to archive.

Any artefact with `status: approved` must also carry:

```yaml
approved_by: <human-name>
approved_at: <ISO-8601 timestamp>
```

Do not use `Claude`, `AI`, `system`, or agent names as the approver.

## Early-stage fields

Stage 1 kickoff must include:

```yaml
kickoff_branch: <discovery-ready | draft-sow>
field_notes_processed_count: <N>
```

Stage 2 discovery must include:

```yaml
based_on_kickoff: 01_kickoff_v<N>.md
integrations: [<integration>, ...]
captured_by: <user>
captured_at: <YYYY-MM-DD>
```

## Unknowns

Use `[unknown — needs human classification]` when source material is too thin to classify confidently. Do not guess.
