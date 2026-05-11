# Pipefy — Knowledge ingestion

## Primary path (paste-only per UAT-6.1)

`native_ai_path:` accepts `paste` here. Stage 10 (`push-native-ai-knowledge` skill, v2.5 / Phase 7) emits a paste bundle containing:

1. **Pipefy Behaviors instructions** — the Behaviors prose block authored from approved Stage 9 documentation fragments (see DESIGN-26 paste-bundle contract).
2. **KB document upload list** — file paths + filenames for the documents the human will manually upload to the Pipefy AI Agents Knowledge Base via the Pipefy UI.
3. **Per-client target ID** — Pipefy AI target reference from `<Client> Brain/00_HUB.md` `Pipefy AI:` block (DESIGN-26 / MIN-4 fix — refuses ingest on target mismatch).

The paste bundle is human-upload-only via the Pipefy AI Agents UI. No API ingestion path is exercised through v2.6 (UAT-6.1; OPEN-Q01 closed).

## Audit log shape

Stage 10 records each ingestion in `<Client> Brain/changelog/cr-<id>/native-ai-audit.md` with these fields:

- `ingested_at:` ISO-8601 timestamp
- `doc_version:` semver from the approved Stage 9 doc
- `target_id:` Pipefy AI target reference (matches `00_HUB.md` `Pipefy AI:` block)
- `paste_bundle_path:` local path to the bundle artefact emitted by Stage 10
- `human_upload_acknowledged_at:` ISO-8601 timestamp recorded after the human confirms the upload in Pipefy UI

Refuses ingest if `doc_published_at < last_diff_review_at` (CRIT-8 fix per DESIGN-26) or `target_id` mismatches the artefact's `client:` frontmatter (MIN-4 fix).

## Fallback (manual paste via UI)

Paste-only IS the fallback. UAT-6.1 forecloses an API ingestion path through v2.6; humans manually upload via the Pipefy AI Agents Knowledge Base UI. The Stage 10 paste-bundle artefact + audit-log entry are the canonical record that ingestion happened.
