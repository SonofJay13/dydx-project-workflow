---
name: platform-wrike
description: Provide Wrike REST API contract + 2026 Copilot + MCP Server capability matrix + per-client shape gotchas + vocabulary for any stage skill that targets a Wrike tenant. Use when artefact frontmatter carries `platform: wrike`. Documents the OAuth-host persistence pattern (the `host` field MUST be persisted from the OAuth token response; hardcoding `www.wrike.com` breaks multi-tenant); the attach-doc-via-MCP knowledge-ingestion path; paste-only native-AI ingestion per UAT-6.1. Does NOT execute API calls — pure reference content for skills + Stage 8 test bot.
frontmatter_version: 2
platform: wrike
tier_claims_last_verified: 2026-05-09
native_ai_path: paste
---

# platform-wrike

Wrike platform reference for the dydx-delivery plugin. Any stage skill operating
against a Wrike tenant loads this skill alongside the stage-specific skill;
artefact frontmatter `platform: wrike` is the routing key.

## Inputs

- Artefact frontmatter carrying `platform: wrike` and a populated `sandbox:` block (loaded by the calling stage skill)
- `client_state.yaml` `wrike.host:` field (persisted from OAuth token response — see `references/api-contract.md` § OAuth-host persistence)
- Phase 5 canonical references at `dydx-delivery/references/`

## Output

This skill produces NO artefacts. It is a reference skill — the calling stage skill produces the versioned output.

## Hard rules

> **Hard rules:** Sandbox-only operations. Read-write only against named sandbox tenants. Refuses destructive actions. See `dydx-delivery/references/safety-rules.md` for the canonical ruleset.

## What this skill provides

- `references/api-contract.md` — REST endpoint (per-tenant base URL from OAuth `host` field per MOD-5), auth header shape, rate limit (400 req/min/user ceiling; 320 req/min/user throttle per Q07.2), OAuth-host persistence 3-step pattern, hardcoded `www.wrike.com` prohibition.
- `references/native-ai-inventory.md` — 2026 Wrike Copilot + 16-tool MCP baseline capability matrix per DESIGN-15.
- `references/knowledge-ingestion.md` — Paste-only Stage 10 path (UAT-6.1): Copilot workflow narrative + MCP tool config + attach-doc-via-MCP instructions.
- `references/client-shape-gotchas.md` — Per-client tenant variations (VodafoneZiggo EU verified seed; append-only as new clients onboard).
- `references/vocabulary.md` — Wrike-specific terms (space / folder / project / task / custom field / host / account_id / space_id / Wrike Copilot / MCP Server).

## Re-verification trigger

Re-verify `references/native-ai-inventory.md` against current Wrike Copilot
documentation BEFORE any v2.x phase that consumes the capability matrix:
- Stage 4a delivery routing (consumes confidence ratings)
- Stage 7b implementation prompt (consumes capability surface list)
- Stage 10 native-AI paste bundle (consumes paste targets — Copilot workflow narratives + MCP tool config)

Update `tier_claims_last_verified:` on this SKILL.md frontmatter after each
re-verification, citing the source doc URL + date in commit message.

Doc URL anchors:
- Wrike: https://developers.wrike.com/wrike-mcp/ + https://www.wrike.com/ai/mcp/
