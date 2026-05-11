<!--
  D-79 — Platform-API Addendum body skeleton.

  This skeleton is appended INSIDE `04a_fnspec-platform_v<N>.md` when BOTH of the following hold:
    (a) no Stage 4b integration fnspec is in scope (SOW omits or empties `## Integration Scope`), AND
    (b) this 4a carries any `delivery: api` rows after the Step 4 classifier pass.

  When emitted, 4a frontmatter ALSO carries:
    has_platform_api_addendum: true
    tech_spec_scope: platform-api-addendum-only

  v2.3 Stage 5 reads these frontmatter fields, skips writing `05_techspec_v<N>.md`, and consumes the addendum body verbatim
  per DESIGN-21 + ROUTE-03. Error-paths discipline matches a full tech spec — API portions only.

  Every row in the API surface inventory table continues to carry D-82 routing markup (canonical enum order `native-ai | api`;
  the reversed form is forbidden per STG4-04). In this addendum the rows are typically all `delivery: api [...]` — that is
  the precondition for emitting the addendum in the first place. Any `delivery: native-ai` row belongs in the main fnspec
  body sections 4 / 5 / 8, not here.
-->

## Platform-API Addendum

This addendum exists because (a) no Stage 4b integration functional spec is in scope for this engagement, AND (b) this Stage 4a carries `delivery: api` requirement rows that need full tech-spec discipline. The body below is the v2.3 Stage 5 input on the platform-only-with-API-rows topology per DESIGN-21 + ROUTE-03 + D-79; Stage 5 reads `has_platform_api_addendum: true` + `tech_spec_scope: platform-api-addendum-only` in this artefact's frontmatter, skips writing `05_techspec_v<N>.md`, and consumes the body verbatim.

Error-paths discipline matches a full technical specification — API portions only. Every row in the API surface inventory table carries D-82 routing markup so the routing key survives forward into Stage 5 / 6 / 7b / 10 per ROUTE-05.

### API surface inventory

| Endpoint | Method | Auth | Rate limit | Delivery |
|---|---|---|---|---|
| `<e.g. /v1/cards>` | POST | <e.g. OAuth bearer (Pipefy GraphQL) / OAuth2 (Wrike) / API key header (Ziflow)> | <e.g. paginate_all per Phase 6 / 4 req per 10s (Ziflow)> | delivery: api [LOW → default api, src: platform-<platform>] |
| `<e.g. /v1/cards/{id}>` | GET | <auth surface> | <rate-limit policy> | delivery: api [LOW → default api, src: platform-<platform>] |
| `<e.g. /v1/cards/{id}>` | PATCH | <auth surface> | <rate-limit policy> | delivery: api [reviewer-override: api] |
| `<e.g. /v1/webhooks>` | POST | <auth surface> | <rate-limit policy> | delivery: api [LOW → default api, src: platform-<platform>] |

> Auth column documents the platform's auth surface. Pipefy: GraphQL OAuth bearer. Wrike: OAuth2 with refresh-token rotation. Ziflow: API key in header (no OAuth flow). For `platform: other`, document the auth surface explicitly inline.
>
> Rate-limit column documents per-platform limits. Pipefy: `paginate_all` per Phase 6 canon. Wrike: TBD (verify against active inventory). Ziflow: 4 req / 10s window (per Phase 6 / Q05 decided). For `platform: other`, document observed limits inline.

### Error paths

> The D-79 error-paths discipline requires concrete per-platform error mapping AND a reviewer-facing message for every HTTP class. Generic prose ("handle errors gracefully") fails this section's discipline check at Step 6 senior-level challenge.

| HTTP class | Expected behaviour | Per-platform error mapping | Reviewer-facing message |
|---|---|---|---|
| 4xx — 400 validation | Fail-fast; do not retry | <e.g. Pipefy GraphQL `errors[].extensions.code: VALIDATION_ERROR`> | "Validation failed on field `<field>`: `<error.message>`. Fix and re-submit." |
| 4xx — 401 auth | Fail-fast; surface re-auth prompt; do not retry | <e.g. Pipefy: `errors[].extensions.code: UNAUTHENTICATED`; Wrike: HTTP 401 with `error: not_authorized`; Ziflow: 401 + `Authentication failed`> | "Auth token expired or invalid. Re-authenticate `<platform>` and re-run." |
| 4xx — 403 forbidden | Fail-fast; do not retry; surface permission gap | <e.g. Pipefy: `FORBIDDEN`; Wrike: 403 + `account_permissions`; Ziflow: 403 + permission error> | "Account lacks permission for `<operation>`. Contact admin." |
| 4xx — 404 not found | Fail-fast; do not retry; surface missing resource | <e.g. Pipefy: GraphQL returns `null` data + error; Wrike: 404; Ziflow: 404> | "Resource `<id>` not found on `<platform>`. Verify the ID and re-run." |
| 4xx — 429 rate-limit | Retry with exponential backoff up to 3 attempts; if still failing, surface and queue | <e.g. Pipefy: paginate_all auto-throttles; Wrike: 429 + `Retry-After` header; Ziflow: 429 + 10s window message> | "Platform rate limit hit. Retrying with backoff (attempt `<n>` of 3)." |
| 5xx — 5xx transient | Retry with exponential backoff up to 3 attempts | <e.g. 502 / 503 / 504 → retryable on all 3 platforms> | "Platform transient error. Retrying (attempt `<n>` of 3)." |
| 5xx — 5xx persistent | After 3 retries, log + raise inline + notify reviewer | <e.g. 500 with persistent error body across retries> | "Platform unavailable after 3 retries. Logged at `<trace_id>`. Reviewer action required." |

### Retry + idempotency rules

- **Idempotent operations (safe to retry on transient failure):** GET / HEAD / read-only queries. Retry policy: exponential backoff (1s, 2s, 4s) up to 3 attempts.
- **NOT-idempotent operations (require explicit dedupe key):** POST creating new resources (cards, work-items, proofs) MUST carry a platform-specific idempotency key:
  - Pipefy: GraphQL mutation with reviewer-supplied `client_mutation_id` (per Phase 6 native-ai-inventory `paginate_all` companion convention).
  - Wrike: `requestId` field on POST; matches Wrike's documented idempotency contract.
  - Ziflow: dedupe via project+filename composite key (Ziflow has no documented idempotency-key field per Phase 6); on retry, query for existing resource first.
  - `other`: planner MUST resolve the idempotency-key field name + format inline.
- **Default retry policy:** exponential backoff (1s, 2s, 4s) up to 3 attempts before raising. Override per-platform when the loaded inventory documents a different cadence.
- **Idempotency-key field name + format:** documented per platform above. Do NOT default to a generic UUID without confirming the platform accepts it.

### Observability hooks

- **Request log:** every API call emits a structured log line carrying `request_id`, `trace_id`, `platform`, `operation`, `http_status`, `latency_ms`, `attempt_n`.
- **Response capture:** on non-2xx responses, capture `response.body` (truncated to 4KB) + `response.headers` (auth headers redacted) into the artefact's audit-trail block.
- **Audit-trail surface:** every retry attempt is logged inline in the artefact under a `## Audit trail` block (timestamps, response codes, error excerpts). Reviewer-visible.
- **Internal-only observations:** stack traces, internal queue depths, and dependency-health checks log to system telemetry only — NOT surfaced into the reviewer-facing artefact.
- **Trace correlation:** the `trace_id` emitted at request time is the same `trace_id` quoted in the reviewer-facing 5xx-persistent error message above, so a reviewer can hand it to operations for incident lookup.

---

*This addendum is the v2.3 Stage 5 input on the platform-only-with-API-rows topology (DESIGN-21 + ROUTE-03 + D-79). Stage 5 v2.3 consumes the body verbatim and does not re-author. Every row in the API surface inventory table carries D-82 markup so the routing key survives forward into Stage 5 / 6 / 7b / 10 per ROUTE-05.*
