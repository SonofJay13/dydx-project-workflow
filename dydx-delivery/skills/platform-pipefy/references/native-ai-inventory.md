# Pipefy — Native-AI inventory

> `tier_claims_last_verified:` matches SKILL.md frontmatter value (2026-05-09 baseline per D-68; updated to execution date if fresh re-verification happens during this plan).

## Re-verification trigger

Re-verify this capability matrix against current Pipefy AI Agents documentation
(`https://www.pipefy.com/` + Pipefy Help Center + AI Agents 2.0 launch docs at
`globenewswire.com/news-release/2025/11/12/3186348`) BEFORE any v2.x phase that
consumes the matrix:
- Stage 4a delivery routing (consumes confidence ratings)
- Stage 7b implementation prompt (consumes capability surface list)
- Stage 10 native-AI paste bundle (consumes paste targets — Behaviors + KB upload list)

Update `tier_claims_last_verified:` on `dydx-delivery/skills/platform-pipefy/SKILL.md`
frontmatter after each re-verification, citing the source doc URL + date in commit
message.

## Capability matrix (2026-grounded)

| Capability | Available? | Surface | Confidence |
|---|---|---|---|
| Knowledge base | yes | Pipefy AI Agents → KB | HIGH |
| Skills | yes | AI Agents → Skills | HIGH |
| MCP integration | **flag for re-verify** | AI Agents → MCP | **DESIGN-14 = HIGH; current research = MEDIUM** — one secondary 2026 source contradicts ("Pipefy is not designed to ingest agents built on third-party frameworks through standard protocols like MCP"). PLAT-01 execution MAY re-verify against Pipefy.com / Pipefy AI Agents 2.0 launch docs (`globenewswire.com/news-release/2025/11/12/3186348`) and bump the date forward. |
| IDP | yes | AI Agents → IDP (Intelligent Document Processing; Agents 2.0 native) | HIGH — confirmed via 2025-11 launch announcement |
| Web Search | yes | AI Agents → Web Search | HIGH |
| BYO-LLM | yes | AI Agents config (multi-LLM routing per workflow step) | HIGH — confirmed via 2025-11 launch announcement |
| KB content-upload via API | **CLOSED (UAT-6.1)** | n/a | UAT-6.1 — OPEN-Q01 closed; no API ingestion path through v2.6 |

## Paste-only delivery (UAT-6.1)

`native_ai_path:` accepts the closed enum `paste | none` ONLY — the previously-considered API ingestion path (the forbidden third enum value) is FORBIDDEN. The Stage 10 paste bundle is the only supported ingestion path through v2.6; humans upload manually via the Pipefy UI. See `references/knowledge-ingestion.md` for the paste-bundle shape.
