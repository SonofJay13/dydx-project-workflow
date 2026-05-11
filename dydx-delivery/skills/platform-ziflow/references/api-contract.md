# Ziflow — API contract

> Canonical SoT for Ziflow API contracts per DESIGN-16 (`.planning/DESIGN.md:502-543`). Documents the per-tenant REST base URL, auth shape, webhook-PRIMARY pattern (vendor-recommended per Q05 vendor research 2026-05-11), `wait_for_proof` FALLBACK helper, multi-tenant auth-concurrency, and MCP availability (none — direct REST only).
>
> **Scope locks (UAT 2026-05-10):**
> - **Q05 resolution (2026-05-11):** Ziflow officially recommends webhooks over polling. The canonical pattern is to subscribe to the `processed` event webhook BEFORE proof creation. `wait_for_proof` is the documented FALLBACK for environments where webhook delivery is unavailable.
> - **UAT-3.5:** Ziflow has no MCP — direct REST only.
> - **UAT-6.1:** Native-AI ingestion APIs OUT-OF-SCOPE — `native_ai_path:` accepts the closed enum `paste | none` only (the previously-considered API ingestion path is forbidden). See `references/knowledge-ingestion.md`.
> - **Q25 (Phase 5 resolution):** Auth-concurrency class default = `exclusive`; live tenant test deferred to PLAT-03 kickoff verification.
>
> **Cross-refs:**
> - Sandbox enforcement: `dydx-delivery/references/safety-rules.md` § "1. Sandbox enforcement"
> - Connector probe: `dydx-delivery/references/connector-matrix.md` (Phase 5 canonical)
> - Glossary: `dydx-delivery/skills/platform-ziflow/references/vocabulary.md` (Ziflow-specific terms)

> **Auth header & secret-handling note:** All helper contracts below document the auth header NAME + value SHAPE only (e.g., `Authorization: Bearer <token>`). NEVER paste real tokens, API keys, OAuth refresh tokens, or session cookies into this file. Tokens live in per-tenant `client_state.yaml` (gitignored) or env vars — never in the canonical reference set.

## Endpoint(s) + auth shape

- **Base URL (per-tenant — populated from OAuth token-exchange or per-tenant configuration):** `https://<tenant-host>/api/v2` (final pattern at PLAT-03 kickoff verification per Q25)
- **Auth header:** `Authorization: Bearer <token>` (header NAME only — see secret-handling note above)
- **Per-tenant variants:** tenant-host (populated at first engagement); `project_id` per workspace
- Sandbox tenant only — see `dydx-delivery/references/safety-rules.md` Rule 1.

## Webhook-PRIMARY (canonical pattern) — Q05 resolution

**Ziflow officially recommends webhooks over polling for proof-ready signalling.** Per vendor guidance (2026-05-11 research; sources: `help.ziflow.com/hc/en-us/articles/30725068740244-Webhooks` + `help.ziflow.com/hc/en-us/articles/30721919730836-Embedded-Review-Approval`):

> "Use webhooks instead of polling the Ziflow API for updates." — Ziflow Help Center

**Canonical flow:**
1. Subscribe to the `processed` event webhook for the target project BEFORE creating a proof.
2. Create the proof. The proof-create call returns success before the proof is fully readable (eventual consistency window per MOD-6).
3. Ziflow delivers the `processed` event to the subscribed webhook endpoint when the proof is ready.
4. The caller reads the proof via `GET /proofs/{proof_id}` after webhook delivery — no polling needed.

**When to use `wait_for_proof` instead:** Local dev, sandbox harness runs, environments without an exposed webhook URL. See § `wait_for_proof` (FALLBACK) below.

**Vendor doc anchors:**
- `help.ziflow.com/hc/en-us/articles/30725068740244-Webhooks` — webhook subscription mechanics
- `help.ziflow.com/hc/en-us/articles/30721919730836-Embedded-Review-Approval` — embedded review-approval flow (calls out webhook-primary)

## Rate limit + throttle

- **Published ceiling:** Phase 5 / Phase 6 did not surface a Ziflow per-second/per-minute rate-limit publication. The bounded budget for `wait_for_proof` is `max_wait_s=30` total with `interval_s=2` between polls = up to ~15 polls per call.
- **Webhook-primary path:** event-driven; no per-call rate-limit applies (single webhook delivery per proof-ready transition).
- **429 handling (helper-internal):** If Ziflow returns 429 on a poll inside `wait_for_proof`, retry once with `interval_s` backoff; subsequent 429 → raise the dedicated **`ZiflowRateLimitExceeded`** failure class (REVIEWS C7 — 429 is rate-limiting, distinct from `ZiflowServerError` which is reserved for 5xx server errors).
- **Re-verify at PLAT-03 kickoff:** if the published rate limit is surfaced during execution, record it here AND in `dydx-delivery/references/connector-matrix.md` for future calibration.

## wait_for_proof

**FALLBACK ONLY** — primary path is webhook subscription to the `processed` event (see § Webhook-PRIMARY above).

**IMPORTANT — Documentation framing:** Per 2026-05-11 vendor research, **Ziflow officially recommends webhooks over polling** (per `help.ziflow.com/hc/en-us/articles/30725068740244-Webhooks` + `help.ziflow.com/hc/en-us/articles/30721919730836-Embedded-Review-Approval`). The canonical pattern is to subscribe to the `processed` event webhook BEFORE proof creation, so the platform notifies the caller when the proof is ready. `wait_for_proof` is the documented **FALLBACK** for environments where webhook delivery is unavailable (e.g., local dev, sandbox tests without exposed webhook URLs, harness runs).

**Signature:** `wait_for_proof(proof_id: str, max_wait_s: int = 30, interval_s: int = 2) -> dict`

**Behaviour:** Polls Ziflow's proof-get endpoint until the proof becomes readable (HTTP 200 + valid proof payload) or `max_wait_s` is exceeded. Handles the read-after-create eventual-consistency window (MOD-6) where Ziflow's proof-create call returns success before the proof is fully readable; subsequent reads within the consistency window may 404.

**Retry / poll budget:** `max_wait_s=30` total / `interval_s=2` between polls = up to ~15 polls per call. Defaults match DESIGN-16 conservative baseline. Q05 resolution: defaults **CONFIRMED** at 30s/2s for fallback path; webhook-primary path has no polling budget (event-driven).

**Failure modes (REVIEWS C7 — dedicated `ZiflowRateLimitExceeded` class for 429, separate from `ZiflowServerError` for 5xx):**
- HTTP 404 on each poll until `max_wait_s` exceeded → raise `ZiflowProofNotReady(proof_id, polls_attempted, total_wait_s)`.
- HTTP 401 / 403 on poll → raise `ZiflowAuthFailed` (NOT eventual-consistency; auth issue).
- HTTP 429 on poll → 1 retry with `interval_s` backoff; subsequent 429 → raise `ZiflowRateLimitExceeded(proof_id, polls_attempted)`. (REVIEWS C7: 429 is rate-limiting, not a server error — distinct from 5xx.)
- HTTP 5xx on poll → 1 retry with `interval_s` backoff; subsequent 5xx → raise `ZiflowServerError`.
- Webhook delivery available + subscribed → caller should NOT use this helper; document the webhook path at the top of `api-contract.md`.

**Return shape:** `dict` — proof payload (id, status, version, project_id, urls, etc. per Ziflow proof-get response shape).

**Pseudocode:**
```python
def wait_for_proof(proof_id: str, max_wait_s: int = 30, interval_s: int = 2) -> dict:
    """
    FALLBACK ONLY — primary path is webhook subscription to 'processed' event.
    Use this helper when webhook delivery is unavailable (local dev / harness / sandbox).
    """
    deadline = time.time() + max_wait_s
    polls = 0
    while time.time() < deadline:
        polls += 1
        response = _get(f"/proofs/{proof_id}")
        if response.status_code == 200:
            return response.json()
        if response.status_code == 404:
            time.sleep(interval_s)
            continue
        if response.status_code in (401, 403):
            raise ZiflowAuthFailed(f"Auth failed at poll {polls}")
        if response.status_code == 429:
            time.sleep(interval_s)
            response = _get(f"/proofs/{proof_id}")
            if response.status_code == 200:
                return response.json()
            raise ZiflowRateLimitExceeded(f"429 persisted at poll {polls}")
        if response.status_code >= 500:
            time.sleep(interval_s)
            response = _get(f"/proofs/{proof_id}")
            if response.status_code == 200:
                return response.json()
            raise ZiflowServerError(f"5xx persisted at poll {polls}")
    raise ZiflowProofNotReady(proof_id, polls, max_wait_s)
```

**Worked example:** Proof created at t=0; first read at t=2s → 404 (eventual consistency); read at t=4s → 404; read at t=6s → 200 + proof payload. Helper returns at poll #3 (total wait ~6s, well within 30s budget). Test-bot tier-1 verifies the wait completed within budget.

**Source:** DESIGN-16 helper spec at `.planning/DESIGN.md:531` + Q05 vendor research 2026-05-11 (`help.ziflow.com/hc/en-us/articles/30725068740244-Webhooks` webhook-PRIMARY guidance + `help.ziflow.com/hc/en-us/articles/30721919730836-Embedded-Review-Approval` "use webhooks instead of polling" canonical statement) + REVIEWS C7 429 classification (dedicated `ZiflowRateLimitExceeded` failure class).

## Multi-tenant auth concurrency

- **Class (default):** `exclusive` per Phase 5 Q25 resolution (Pipefy precedent under UAT-4.2). LOW confidence — live tenant test deferred to PLAT-03 kickoff verification.
- **`client_state.yaml` field:** `ziflow.auth_concurrency_class: exclusive` (per DESIGN-29; populated by Phase 6 PLAT-03 probe).

## MCP availability (UAT-3.5 — PARKED REFERENCE)

Ziflow has **no MCP** — direct REST is the only access path through v2.6 (and likely beyond). MCP adoption is not currently a vendor offering.
