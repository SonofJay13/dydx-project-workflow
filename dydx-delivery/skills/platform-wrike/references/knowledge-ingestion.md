# Wrike — Knowledge ingestion

## Primary path (paste-only per UAT-6.1)

`native_ai_path:` accepts `paste` here. Stage 10 (`push-native-ai-knowledge` skill, v2.5 / Phase 7) emits a paste bundle containing:

1. **Wrike Copilot workflow narrative** — a structured prose block describing the workflow steps Copilot should support, authored from approved Stage 9 documentation fragments (see DESIGN-26 paste-bundle contract).
2. **MCP tool config** — the MCP tool-list configuration (DESIGN-15 baseline = 16 tools; current vendor count = 47 per `developers.wrike.com/wrike-mcp/`) the human will manually configure in the Wrike workspace.
3. **Attach-doc-via-MCP instructions** — paste-only instructions for the human to attach approved Stage 9 documents to the Wrike workspace via the MCP `attach_doc` tool surface (manual UI workflow).
4. **Per-client target ID** — Wrike AI target reference from `<Client> Brain/00_HUB.md` `Wrike AI:` block (DESIGN-26 / MIN-4 fix).

The paste bundle is human-upload-only via the Wrike UI. No API ingestion path is exercised through v2.6 (UAT-6.1; OPEN-Q02 closed).

## Audit log shape

Stage 10 records each ingestion in `<Client> Brain/changelog/cr-<id>/native-ai-audit.md` with these fields:

- `ingested_at:` ISO-8601 timestamp
- `doc_version:` semver from the approved Stage 9 doc
- `target_id:` Wrike AI target reference (matches `00_HUB.md` `Wrike AI:` block)
- `paste_bundle_path:` local path to the bundle artefact emitted by Stage 10
- `human_upload_acknowledged_at:` ISO-8601 timestamp recorded after the human confirms the upload in Wrike UI

Refuses ingest if `doc_published_at < last_diff_review_at` (CRIT-8 fix per DESIGN-26) or `target_id` mismatches the artefact's `client:` frontmatter (MIN-4 fix).

## Fallback (manual paste via UI)

Paste-only IS the fallback. UAT-6.1 forecloses an API ingestion path through v2.6; humans manually attach documents via the Wrike workspace UI (or the MCP `attach_doc` tool surface, treated as a manual workflow for UAT-3.5 / paste-only purposes). The Stage 10 paste-bundle artefact + audit-log entry are the canonical record that ingestion happened.
