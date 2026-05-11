# Wrike — API contract

> Canonical SoT for Wrike API contracts per DESIGN-15 (`.planning/DESIGN.md:459-500`). Documents the per-tenant base URL from OAuth `host` field, auth shape, rate-limit + throttle, OAuth-host persistence 3-step pattern, multi-tenant auth-concurrency, and MCP availability (parked reference).
>
> **Scope locks (UAT 2026-05-10):**
> - **MOD-5 / DESIGN-15 (CRITICAL):** Base URL is parsed PER-TENANT from the OAuth token response `host` field. Hardcoding `www.wrike.com` breaks multi-tenant — NEVER hardcode `www.wrike.com`. Tenants like VodafoneZiggo run on `app-eu.wrike.com`; US-2 tenants on `app-us2.wrike.com`.
> - **UAT-3.5:** Wrike MCP Server is parked reference only — not adopted through v2.6.
> - **UAT-6.1:** Native-AI ingestion APIs OUT-OF-SCOPE — `native_ai_path:` accepts the closed enum `paste | none` only (the previously-considered API ingestion path is forbidden). See `references/knowledge-ingestion.md`.
> - **Q25 (Phase 5 resolution):** Auth-concurrency class default = `exclusive`; live tenant test deferred to PLAT-02 kickoff verification.
>
> **Cross-refs:**
> - Sandbox enforcement: `dydx-delivery/references/safety-rules.md` § "1. Sandbox enforcement"
> - Connector probe: `dydx-delivery/references/connector-matrix.md` (Phase 5 canonical; Q07.1 baseline at `:73`)
> - Glossary: `dydx-delivery/skills/platform-wrike/references/vocabulary.md` (Wrike-specific terms)

> **Auth header & secret-handling note:** All helper contracts below document the auth header NAME + value SHAPE only (e.g., `Authorization: Bearer <token>`). NEVER paste real tokens, API keys, OAuth refresh tokens, or session cookies into this file. Tokens live in per-tenant `client_state.yaml` (gitignored) or env vars — never in the canonical reference set.

## Endpoint(s) + auth shape

- **Base URL (per-tenant from OAuth `host` field per MOD-5 / DESIGN-15):** `https://<host>/api/v4` where `<host>` is the value returned by the Wrike OAuth token-exchange response (e.g., `app-us2.wrike.com` for US-2 region, `app-eu.wrike.com` for EU region).
- **Auth header:** `Authorization: Bearer <token>` (header NAME only — see secret-handling note above).
- **CRITICAL — DO NOT hardcode the host:** The `host` field MUST be persisted from the OAuth token response. NEVER hardcode `www.wrike.com` — that string is the marketing site, NOT a valid API base URL for any production tenant. See § OAuth-host persistence below for the 3-step pattern.
- Sandbox tenant only — see `dydx-delivery/references/safety-rules.md` Rule 1.

## Rate limit + throttle

- **Published ceiling:** 400 req/min per user + 5000 req/min per IP (Wrike Help Center, re-confirmed 2026-05-11; Phase 5 Q07.1 baseline at `dydx-delivery/references/connector-matrix.md:73`).
- **Helper throttle (Q07.2 resolution, PLAT-06):** **320 req/min per user (80% of 400 ceiling, DESIGN-22 carried throttle pattern at `.planning/DESIGN.md:795`)**.
- **IP-level ceiling (5000/min):** Not a per-helper constraint; multiple users may share the IP. IP-level rate-limit-aware behaviour is a Stage 8 test-bot concern.
- **429 handling:** Max 3 retries per call with exponential backoff `[1s, 2s, 4s]`.
- **`X-RateLimit-*` headers:** Wrike returns these on every response; helpers SHOULD parse them to dynamically adjust throttle when the API surfaces server-side remaining-quota. Per-call adaptive-throttle is a P2 enhancement; static 320 req/min/user is the P1 baseline.

## OAuth-host persistence pattern (3-step) — MOD-5

**Signature:** This is a **pattern**, not a single-callable helper. The pattern has three parts: (1) extract `host` from OAuth token response; (2) persist to `client_state.yaml` `wrike.host:`; (3) use as base URL for every subsequent API call.

**Behaviour:** Replaces the hardcoded `www.wrike.com` base URL with the per-tenant host value carried in the OAuth token response. Wrike's OAuth handshake returns a tenant-specific `host` field (e.g., `app-us2.wrike.com` for US-2 region, `app-eu.wrike.com` for EU region). Hardcoding `www.wrike.com` breaks multi-tenant per MOD-5.

**Persistence:** `client_state.yaml` `wrike.host:` field (per DESIGN-29 schema). Read at session start; written on initial OAuth + on host-change events (rare; typically only on regional migration).

**Retry / poll budget:** N/A (pattern, not a network call). Per-call throttle ceiling: **320 req/min per user (80% of 400 ceiling; resolves Q07.2 per Phase 5 connector-matrix.md `:73`)**.

**Failure modes:**
- OAuth token response missing `host` field → raise `WrikeContractDrift("OAuth response missing host field — multi-tenant guarantee broken")`.
- `wrike.host:` absent from `client_state.yaml` at runtime → refuse to operate; surface "Wrike host not provisioned — re-run OAuth handshake" to caller.
- Hardcoded `www.wrike.com` detected in any helper module → CI-level lint failure (Stage 8 test-bot tier-1 assertion).

**CRITICAL anti-pattern (MOD-5 — A12 verification gate):** NEVER hardcode `www.wrike.com` anywhere in helper modules, configuration, or example code. The OAuth token response carries the customer's regional host as part of its base-URL contract; hardcoding breaks multi-tenant.

**Pseudocode:**
```python
# Step 1 — Extract on OAuth completion
def on_oauth_complete(token_response: dict, client_state_path: Path) -> None:
    host = token_response.get("host")
    if not host:
        raise WrikeContractDrift("OAuth response missing host field")
    cs = load_client_state(client_state_path)
    cs["wrike"]["host"] = host
    save_client_state(client_state_path, cs)

# Step 2 — Read at every API call
def wrike_base_url(client_state: dict) -> str:
    host = client_state.get("wrike", {}).get("host")
    if not host:
        raise RuntimeError("wrike.host not provisioned — re-run OAuth handshake")
    return f"https://{host}/api/v4"

# Step 3 — Use as base URL
def list_tasks(client_state: dict, params: dict) -> dict:
    url = f"{wrike_base_url(client_state)}/tasks"
    return _execute_with_throttle(url, params=params,
                                   throttle_req_per_min=320)  # 80% of 400 ceiling per user
```

**Worked examples:**
- US-2 region tenant: `token_response.host == "app-us2.wrike.com"` → base URL `https://app-us2.wrike.com/api/v4`.
- VodafoneZiggo EU tenant (account `5996999`): `token_response.host == "app-eu.wrike.com"` → base URL `https://app-eu.wrike.com/api/v4`; entry URL pattern `https://app-eu.wrike.com/workspace.htm?acc=5996999`.

**Source:** DESIGN-15 OAuth-host rule at `.planning/DESIGN.md:488` + Phase 5 OPEN-Q13 resolution at `dydx-delivery/references/connector-matrix.md:78` + Phase 5 connector-matrix.md `:73` throttle ceiling.

## Multi-tenant auth concurrency

- **Class (default):** `exclusive` per Phase 5 Q25 resolution (Pipefy precedent under UAT-4.2). LOW confidence — live tenant test deferred to PLAT-02 kickoff verification per Q25 resolution.
- **`client_state.yaml` field:** `wrike.auth_concurrency_class: exclusive` (per DESIGN-29; populated by Phase 6 PLAT-02 probe).

## MCP availability (UAT-3.5 — PARKED REFERENCE)

Wrike MCP Server is available (`developers.wrike.com/wrike-mcp/` + `www.wrike.com/ai/mcp/`) but **not adopted through v2.6** per UAT-3.5. REST API is the canonical Wrike access path for v2.1–v2.6.

- **DESIGN-15 baseline:** 16 MCP tools documented.
- **Current vendor count (manual re-verify; per VALIDATION § Manual-Only Verifications row 2):** 47 tools per stackone.com (2026-05-11) — DELTA from DESIGN-15 baseline. PLAT-02 execution MAY record the authoritative count in `references/native-ai-inventory.md` after manual check against `developers.wrike.com/wrike-mcp/`.
- MCP adoption re-evaluated as a post-v2.6 milestone gated on first-real-client-engagement-practice-run (per `.claude/memory/feedback_platform_skills_api_first.md`).
