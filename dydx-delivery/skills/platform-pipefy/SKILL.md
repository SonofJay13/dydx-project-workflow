---
name: platform-pipefy
description: Provide Pipefy GraphQL API contract + 2026 AI Agents capability matrix + per-client shape gotchas + vocabulary for any stage skill that targets a Pipefy tenant. Use when artefact frontmatter carries `platform: pipefy`. Documents the `paginate_all` helper contract for cursor pagination; the HTML-on-auth-failure detection rule (Pipefy returns Keycloak login HTML, not JSON 401); the canonical-only API endpoint (`api.pipefy.com/graphql` for ALL tenants); paste-only native-AI ingestion path per UAT-6.1. Does NOT execute API calls — pure reference content for skills + Stage 8 test bot.
frontmatter_version: 2
platform: pipefy
tier_claims_last_verified: 2026-05-09
native_ai_path: paste
---

# platform-pipefy

Pipefy platform reference for the dydx-delivery plugin. Any stage skill operating
against a Pipefy tenant loads this skill alongside the stage-specific skill;
artefact frontmatter `platform: pipefy` is the routing key.

## Inputs

- Artefact frontmatter carrying `platform: pipefy` and a populated `sandbox:` block (loaded by the calling stage skill)
- Phase 5 canonical references at `dydx-delivery/references/` (consumed transitively via this skill's pointers)

## Output

This skill produces NO artefacts. It is a reference skill — the calling stage skill produces the versioned output.

## Hard rules

> **Hard rules:** Sandbox-only operations. Read-write only against named sandbox tenants. Refuses destructive actions. See `dydx-delivery/references/safety-rules.md` for the canonical ruleset.

## What this skill provides

- `references/api-contract.md` — GraphQL endpoint (canonical-only `api.pipefy.com/graphql` for ALL tenants per UAT-4.1 / Q24), auth header shape, rate limit (500 req/30s ceiling; 13 req/sec throttle per Q06.2), HTML-on-auth-failure detection (UAT-4.1), `paginate_all` helper contract (MOD-4).
- `references/native-ai-inventory.md` — 2026 Pipefy AI Agents 2.0 capability matrix (KB / Skills / MCP / IDP / Web Search / BYO-LLM) per DESIGN-14.
- `references/knowledge-ingestion.md` — Paste-only Stage 10 path (UAT-6.1): Pipefy Behaviors instructions + KB upload list.
- `references/client-shape-gotchas.md` — Per-client pipe shape variations (Vodacom custom-subdomain verified seed; append-only as new clients onboard).
- `references/vocabulary.md` — Pipefy-specific terms (pipe / phase / card / connection / org_id / web_host / pipe_id / phase_id / card_id / Behaviors / Pipefy AI Agents).

## Re-verification trigger

Re-verify `references/native-ai-inventory.md` against current Pipefy AI Agents
documentation BEFORE any v2.x phase that consumes the capability matrix:
- Stage 4a delivery routing (consumes confidence ratings)
- Stage 7b implementation prompt (consumes capability surface list)
- Stage 10 native-AI paste bundle (consumes paste targets — Behaviors / Copilot
  workflow narratives / ReviewAI Checklist criteria)

Update `tier_claims_last_verified:` on this SKILL.md frontmatter after each
re-verification, citing the source doc URL + date in commit message.

Doc URL anchors:
- Pipefy: https://www.pipefy.com/ + Pipefy Help Center
