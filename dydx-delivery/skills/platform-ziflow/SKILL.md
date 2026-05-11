---
name: platform-ziflow
description: Provide Ziflow REST API contract + 2026 ReviewAI capability matrix + per-client shape gotchas + vocabulary for any stage skill that targets a Ziflow tenant. Use when artefact frontmatter carries `platform: ziflow`. Documents the webhook-PRIMARY pattern for read-after-create signalling (vendor-recommended) + `wait_for_proof` fallback helper for environments without webhook delivery; ReviewAI Checklists Public Preview + Change Verification + Brand Standards capability tracking; paste-only native-AI ingestion per UAT-6.1. Does NOT execute API calls — pure reference content for skills + Stage 8 test bot.
frontmatter_version: 2
platform: ziflow
tier_claims_last_verified: 2026-05-09
native_ai_path: paste
---

# platform-ziflow

Ziflow platform reference for the dydx-delivery plugin. Any stage skill operating
against a Ziflow tenant loads this skill alongside the stage-specific skill;
artefact frontmatter `platform: ziflow` is the routing key.

## Inputs

- Artefact frontmatter carrying `platform: ziflow` and a populated `sandbox:` block (loaded by the calling stage skill)
- Phase 5 canonical references at `dydx-delivery/references/`

## Output

This skill produces NO artefacts. It is a reference skill — the calling stage skill produces the versioned output.

## Hard rules

> **Hard rules:** Sandbox-only operations. Read-write only against named sandbox tenants. Refuses destructive actions. See `dydx-delivery/references/safety-rules.md` for the canonical ruleset.

## What this skill provides

- `references/api-contract.md` — REST endpoint (per-tenant base URL), auth header shape, webhook-PRIMARY framing (Ziflow officially recommends webhooks over polling per Q05 vendor research 2026-05-11), `wait_for_proof` FALLBACK helper contract (MOD-6) with `max_wait_s=30` / `interval_s=2` defaults.
- `references/native-ai-inventory.md` — 2026 Ziflow ReviewAI capability matrix (Checklists Public Preview + Change Verification + Brand Standards + Checklist Templates API) per DESIGN-16.
- `references/knowledge-ingestion.md` — Paste-only Stage 10 path (UAT-6.1): ReviewAI Checklist criteria + copy-paste fallback.
- `references/client-shape-gotchas.md` — Per-client tenant variations (Acme placeholder + TBD markers for Up & Up Group + VodafoneZiggo; append-only as new clients onboard).
- `references/vocabulary.md` — Ziflow-specific terms (proof / review / decision / stage / version / project_id / ReviewAI / Checklist / Change Verification / Brand Standards).

## Re-verification trigger

Re-verify `references/native-ai-inventory.md` against current Ziflow ReviewAI
documentation BEFORE any v2.x phase that consumes the capability matrix:
- Stage 4a delivery routing (consumes confidence ratings)
- Stage 7b implementation prompt (consumes capability surface list)
- Stage 10 native-AI paste bundle (consumes paste targets — ReviewAI Checklist criteria)

Update `tier_claims_last_verified:` on this SKILL.md frontmatter after each
re-verification, citing the source doc URL + date in commit message.

Doc URL anchors:
- Ziflow: https://api-docs.ziflow.com/ + https://www.ziflow.com/reviewai

**High-churn note:** Ziflow ReviewAI is in active expansion — Change Verification +
Brand Standards are listed as "Coming Soon" per DESIGN-16. This `tier_claims_last_verified:`
date will likely drift forward earliest among the three platform skills; PLAT-03
execution MAY bump it forward if the Coming Soon items have shipped.
