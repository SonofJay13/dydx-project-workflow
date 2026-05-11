# Pipefy — API contract

> Canonical SoT for Pipefy API contracts per DESIGN-14 REVISED (`.planning/DESIGN.md:408-457`). Documents the canonical-only GraphQL endpoint, auth shape, rate-limit + throttle, auth-failure detection, helper contracts, multi-tenant auth-concurrency, and MCP availability (parked reference).
>
> **Scope locks (UAT 2026-05-10):**
> - **UAT-4.1 / Q24 verified 2026-05-10:** API endpoint canonical-only — `api.pipefy.com/graphql` for ALL tenants. `web_host` and `org_id` vary per tenant; the per-tenant API-host override configuration field is REMOVED (DNS verified: `api.<subdomain>.pipefy.com` does not resolve for custom-subdomain tenants). Skills MUST NOT introduce per-tenant API-host configuration.
> - **UAT-3.5:** Pipedream Pipefy MCP is parked reference only — not adopted through v2.6.
> - **UAT-6.1:** Native-AI ingestion APIs OUT-OF-SCOPE — `native_ai_path:` accepts the closed enum `paste | none` only (the previously-considered API ingestion path is forbidden). See `references/knowledge-ingestion.md`.
> - **UAT-4.2:** Auth-concurrency = `exclusive` — cannot auth to two Pipefy tenants simultaneously.
>
> **Cross-refs:**
> - Sandbox enforcement: `dydx-delivery/references/safety-rules.md` § "1. Sandbox enforcement"
> - Connector probe: `dydx-delivery/references/connector-matrix.md` (Phase 5 canonical)
> - Glossary: `dydx-delivery/skills/platform-pipefy/references/vocabulary.md` (Pipefy-specific terms)

> **Auth header & secret-handling note:** All helper contracts below document the auth header NAME + value SHAPE only (e.g., `Authorization: Bearer <token>`). NEVER paste real tokens, API keys, OAuth refresh tokens, or session cookies into this file. Tokens live in per-tenant `client_state.yaml` (gitignored) or env vars — never in the canonical reference set.

## Endpoint(s) + auth shape

- **Base URL (canonical-only for ALL tenants per UAT-4.1 / Q24 verified 2026-05-10):** `https://api.pipefy.com/graphql`
- **Auth header:** `Authorization: Bearer <token>` (header NAME only — see secret-handling note above)
- **Per-tenant variants:** `web_host` (e.g., `app.pipefy.com` default OR `<subdomain>.pipefy.com` custom-subdomain) and `org_id` (path segment in web URLs; NOT required in GraphQL calls). These two fields are per-tenant; the API host is NOT.
- **Removed (UAT-4.1):** the previously-considered per-tenant API-host override configuration field is NOT used anywhere — DNS verified `api.<subdomain>.pipefy.com` does not resolve for custom-subdomain tenants. Skills MUST NOT introduce per-tenant API-host configuration.
- Sandbox tenant only — see `dydx-delivery/references/safety-rules.md` Rule 1.

## Rate limit + throttle

- **Published ceiling:** 500 req / 30s per token ≈ 16.67 req/sec per token (Pipefy Community + Pipefy Help Center, re-confirmed 2026-05-11; Phase 5 Q06.1 baseline at `dydx-delivery/references/connector-matrix.md:72`).
- **Helper throttle (Q06.2 resolution, PLAT-06):** **13 req/sec per token (80% buffer, DESIGN-22 carried throttle pattern at `.planning/DESIGN.md:795`)**.
- **429 handling:** Max 3 retries per call with exponential backoff `[1s, 2s, 4s]`; total budget per page = ~7s before raising `PipefyRateLimitExhausted`.
- **Pipe Reports Export sub-limit:** 25 req / 24h per pipe — helpers consuming `paginate_all` against pipe-report endpoints carry a per-day budget tracker. Out-of-budget → return cached / partial result with warning, NOT raise.

## Auth-failure detection

Pipefy GraphQL endpoint returns a **Keycloak login HTML page** with `Content-Type: text/html` on auth failure, NOT a JSON `401 Unauthorized`. This is the Pipefy-specific auth-failure shape (UAT-4.1 bonus finding).

**Detection rule (MUST appear in every Pipefy helper):**
- Check `Content-Type` header BEFORE parsing JSON.
- If `Content-Type` starts with `text/html` → raise `PipefyAuthFailed("Keycloak login HTML received; token invalid or expired")`.
- Do NOT use `try / except JSONDecodeError` — it masks the real signal.

This rule is enforced inside `paginate_all` pseudocode below; downstream helpers (Stage 8 test bot tier-1 assertions) MUST replicate it.

## paginate_all

**Signature:** `paginate_all(query: str, cursor_field: str = "endCursor", page_size: int = 50) -> list[dict]`

**Behaviour:** Iterates Pipefy GraphQL cursor pagination across multi-page result sets until `pageInfo.hasNextPage == false`. Returns the accumulated flat list of records across all pages. Prevents the silent-truncation bug (MOD-4) that occurs when consumer skills assume a single-page response covers all records.

**Retry / poll budget:** Per-page request retries on HTTP 429 with exponential backoff. Throttle ceiling: **13 req/sec per token (80% of 16.67 ceiling = 500 req / 30s per token; resolves Q06.2 per Phase 5 connector-matrix.md `:72`)**. Max retries per page = 3; backoff curve `[1s, 2s, 4s]`. Total budget per page = ~7s before raising.

**Failure modes:**
- HTML response with `Content-Type: text/html` (Keycloak login HTML, UAT-4.1) → raise `PipefyAuthFailed` (NOT a JSON 401 — this is the Pipefy-specific auth-failure shape).
- HTTP 429 after max retries → raise `PipefyRateLimitExhausted`.
- Cursor field missing in response → raise `PipefyPaginationContractError` (signals API contract drift).
- Empty first page → return `[]` (not an error).

**Return shape:** `list[dict]` — flat accumulation of `result.edges[].node` payloads across all pages.

**Pseudocode:**
```python
def paginate_all(query: str, cursor_field: str = "endCursor", page_size: int = 50) -> list[dict]:
    results = []
    cursor = None
    while True:
        page = _execute_with_throttle(query, cursor=cursor, page_size=page_size,
                                       throttle_req_per_sec=13)  # 80% of 16.67 ceiling
        # Auth-failure detection (UAT-4.1 — non-standard Pipefy shape)
        if page.headers.get("Content-Type", "").startswith("text/html"):
            raise PipefyAuthFailed("Keycloak login HTML received; token invalid or expired")
        data = page.json()
        results.extend(node for node in data["result"]["edges"])
        page_info = data["result"]["pageInfo"]
        if not page_info["hasNextPage"]:
            break
        cursor = page_info[cursor_field]
    return results
```

**Worked example:** Querying all cards in a pipe with 247 cards (5 pages × 50 + final page × 47) → returns flat `list[dict]` of length 247. Single per-page HTTP 429 → 1s backoff → retry → succeeds; surface result identical to clean-path.

**Source:** DESIGN-14 helper spec at `.planning/DESIGN.md:440` + UAT-4.1 HTML-auth gotcha at `.planning/DESIGN.md:447` + Phase 5 connector-matrix.md `:72` throttle ceiling.

## Multi-tenant auth concurrency

- **Class:** `exclusive` (locked per UAT-4.2). Cannot auth to two Pipefy tenants simultaneously.
- **Implication for Stage 8 test bot:** Tier-1 assertions serialize per-tenant ops + emit `auth_switch_required` retry signal at tenant-boundary crossings (per DESIGN-28).
- **`client_state.yaml` field:** `pipefy.auth_concurrency_class: exclusive` (per DESIGN-29).

## MCP availability (UAT-3.5 — PARKED REFERENCE)

Pipedream Pipefy MCP is available (`mcp.pipedream.net/v2`) but **not adopted through v2.6** per UAT-3.5. Native API (GraphQL) is the canonical Pipefy access path for v2.1–v2.6. MCP adoption re-evaluated as a post-v2.6 milestone gated on first-real-client-engagement-practice-run (per `.claude/memory/feedback_platform_skills_api_first.md`).
