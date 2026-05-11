# Wrike — Native-AI inventory

> `tier_claims_last_verified:` matches SKILL.md frontmatter value (2026-05-09 baseline per D-68; updated to execution date if fresh re-verification happens during this plan).

## Re-verification trigger

Re-verify this capability matrix against current Wrike Copilot + MCP Server
documentation (`https://developers.wrike.com/wrike-mcp/` + `https://www.wrike.com/ai/mcp/`)
BEFORE any v2.x phase that consumes the matrix:
- Stage 4a delivery routing (consumes confidence ratings)
- Stage 7b implementation prompt (consumes capability surface list)
- Stage 10 native-AI paste bundle (consumes paste targets — Copilot workflow narratives + MCP tool config)

Update `tier_claims_last_verified:` on `dydx-delivery/skills/platform-wrike/SKILL.md`
frontmatter after each re-verification, citing the source doc URL + date in commit
message.

## Capability matrix (2026-grounded)

| Capability | Available? | Surface | Confidence |
|---|---|---|---|
| Wrike Copilot (real-time AI in workspace) | yes | Wrike workspace UI / Copilot panel | HIGH |
| MCP Server (16-tool baseline) | yes | `developers.wrike.com/wrike-mcp/` | **DESIGN-15 = 16 tools; current secondary count = 47 (stackone.com 2026-05-11)** — PLAT-02 execution MAY re-verify against `developers.wrike.com/wrike-mcp/` + `www.wrike.com/ai/mcp/` and record the authoritative count |
| Attach-doc-via-MCP knowledge-ingestion path | yes | MCP `attach_doc` tool surface | MEDIUM — requires MCP adoption (UAT-3.5 parks MCP through v2.6; paste-only fallback per UAT-6.1) |
| AI Studio knowledge-ingestion API | **CLOSED (UAT-6.1)** | n/a | UAT-6.1 — OPEN-Q02 closed; no API ingestion path through v2.6 |

## Paste-only delivery (UAT-6.1)

`native_ai_path:` accepts the closed enum `paste | none` ONLY — the previously-considered API ingestion path (the forbidden third enum value) is FORBIDDEN. The Stage 10 paste bundle is the only supported ingestion path through v2.6; humans upload manually via the Wrike UI. See `references/knowledge-ingestion.md` for the paste-bundle shape.

## Optional execution-time re-verification

If PLAT-02 executor wishes to re-verify the MCP tool count against current vendor docs (`developers.wrike.com/wrike-mcp/`) before committing, they MAY update the MCP row AND `dydx-delivery/skills/platform-wrike/SKILL.md` `tier_claims_last_verified:` to the execution date. Default: leave 2026-05-09 baseline as-is and surface the 16-vs-47 delta as a flag for downstream PLAT-02 review. Per VALIDATION § Manual-Only Verifications row 2 this is a manual reviewer check, not an automated assertion.

**Commit-message audit-trail requirement (REVIEWS C6 / D-68):** If you bump `tier_claims_last_verified:` during execution, the commit message MUST cite the specific vendor URL used for the re-verification (e.g., `https://developers.wrike.com/wrike-mcp/` or `https://www.wrike.com/ai/mcp/`). Format: a one-line `Verified-Against: <URL>` trailer in the commit body.
