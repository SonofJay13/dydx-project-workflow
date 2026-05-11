# dYdX Delivery — Connector availability matrix (canonical)

> Canonical SoT per DESIGN-07 (`.planning/DESIGN.md:162-178`). Documents session-start probe behaviour for each MCP/API the plugin depends on, plus per-stage graceful-degradation fallback when a connector is missing. **Doc-only per D-56** — no slash command, no agent, no probe hook ships in Phase 5; skills read this matrix at session start. Manual re-run via `claude mcp list` against the matrix.
>
> **Scope locks (UAT 2026-05-10):** Pipefy/Wrike/Ziflow are API-only through v2.6 (UAT-3.5) — no MCP path branches for those 3 platforms. Native-AI ingestion APIs are OUT-OF-SCOPE entirely (UAT-6.1) — Stage 10 = paste-only. Pipefy API endpoint canonical-only `api.pipefy.com/graphql` (UAT-4.1 / Q24 verified 2026-05-10).
>
> **Cross-refs:**
> - Rule 1 sandbox enforcement: `dydx-delivery/references/safety-rules.md` § "1. Sandbox enforcement" — the session-start probe NEVER targets a non-allowlisted resource; probe cheap-reads honour the `sandbox:` allowlist.
> - Stage numbering: `dydx-delivery/references/stage-numbering.md` — canonical 11-stage list.
> - Glossary: `dydx-delivery/references/glossary.md` — canonical product naming (e.g., Claude for Chrome / Wrike host field).

## Cell value enum

| Value | Meaning | Halt behaviour |
|---|---|---|
| `REQUIRED` | Stage cannot complete without the connector wired and authenticated. | HALT with explicit error; surface the connector name + cheap-read failure to the user. |
| `GRACEFUL` | Stage prefers the connector but has a documented fallback (paste / manual mode / local-only). | Skill logs degraded-mode entry; continues with fallback path documented per-stage below. |
| `N/A` | Stage does not consume this connector (out-of-scope by design — e.g., native-AI ingestion APIs under UAT-6.1). | No probe; no fallback; row not exercised. |

## Connectors

| Connector | Probe method | Endpoint / cheap-read | Probe status (2026-05-10) | Owner phase |
|---|---|---|---|---|
| Coda MCP | `claude mcp list` ⇒ status line + `whoami` cheap-read | `apis/v1` (Coda MCP server tool surface; canonical `coda://docs/{docId}` URI shape per MCP server instructions) | Re-confirmed wired 2026-05-10 (no drift vs AUDIT-08 baseline 2026-05-09T17:05Z; in-agent `whoami` round-trip OK). | Phase 6+ |
| Google Workspace MCP (3 Anthropic-maintained servers — Drive / Gmail / Calendar) | `claude mcp list` ⇒ 3 status lines + per-MCP cheap-read | `drivemcp.googleapis.com/mcp/v1` + `gmailmcp.googleapis.com/mcp/v1` + `calendarmcp.googleapis.com/mcp/v1` (all `*mcp.googleapis.com` — Anthropic-maintained, NOT `taylorwilsdon` / NOT `piotr-agier`) | AUDIT-08 baseline re-affirmed (probe-date 2026-05-09T17:05Z all 3 wired; in-agent live `claude mcp list` unavailable inside execution context — local CLI re-run recommended at next session start per D-56). No drift signal observed. | Phase 8+ |
| Miro MCP | `claude mcp list` ⇒ status line + `board_search_boards` cheap-read | `https://mcp.miro.com` (MCP server endpoint; cheap-read returns first-N boards) | AUDIT-08 baseline re-affirmed (probe-date 2026-05-09T17:05Z returned 5 boards / total 920; in-agent live probe unavailable — local CLI re-run recommended at next session start per D-56). No drift signal observed. | Phase 7+ |
| Pipefy API (GraphQL) | HTTP GET probe ⇒ 200 (or 401 HTML — see DESIGN-14 gotcha) | `https://api.pipefy.com/graphql` (canonical-only per UAT-4.1 / Q24 — ALL tenants route through this host; `pipefy_api_host:` field REMOVED from DESIGN-29) | API endpoint reachable; auth shape `Authorization: Bearer <token>` (header NAME documented; never log real token). | Phase 6 PLAT-01 |
| Wrike API (REST) | OAuth token-exchange dry-run ⇒ token response `host` field | per-tenant `host` field returned by OAuth token-exchange (Q13 — per-tenant SoT); auth shape `Authorization: Bearer <token>` | OAuth flow documented; per-tenant host parsed at runtime; sandbox-tenant subset only per safety-rules.md Rule 1. | Phase 6 PLAT-02 |
| Ziflow API (REST) | OAuth token-exchange dry-run ⇒ 200 + token | per-tenant Ziflow API host; auth shape `Authorization: Bearer <token>` | OAuth flow documented; sandbox-tenant subset only per safety-rules.md Rule 1. | Phase 6 PLAT-03 |

> **Auth header & secret-handling note (T-3 — security_threat_model):** All endpoint rows above document the auth header NAME + value SHAPE only (e.g., `Authorization: Bearer <token>`). NEVER paste real tokens, API keys, OAuth refresh tokens, or session cookies into this file. Tokens live in per-tenant `client_state.yaml` (gitignored) or env vars — never in the canonical reference set.

## Stage × connector grid

Cells use the `REQUIRED | GRACEFUL | N/A` enum from §Cell value enum above. The 11-stage list is canonical per `stage-numbering.md`; substages collapsed where the substage shares its parent stage's connector posture.

| Stage | Coda MCP | Google Workspace MCP | Miro MCP | Pipefy API | Wrike API | Ziflow API |
|---|---|---|---|---|---|---|
| Stage 1 Kickoff | GRACEFUL | N/A | GRACEFUL | N/A | N/A | N/A |
| Stage 2 Discovery | GRACEFUL | N/A | N/A | N/A | N/A | N/A |
| Stage 3 SOW | GRACEFUL | N/A | GRACEFUL | N/A | N/A | N/A |
| Stage 4a fnspec-platform | N/A | N/A | N/A | N/A | N/A | N/A |
| Stage 4b fnspec-integration | N/A | N/A | N/A | N/A | N/A | N/A |
| Stage 5 Tech spec | N/A | N/A | N/A | N/A | N/A | N/A |
| Stage 6 Cost estimate | GRACEFUL | N/A | N/A | N/A | N/A | N/A |
| Stage 7a Build prompt (dev) | N/A | N/A | N/A | N/A | N/A | N/A |
| Stage 7b Implementation prompt | N/A | N/A | N/A | N/A | N/A | N/A |
| Stage 8 Test bot (8a/8b/8c/8d) | GRACEFUL (sandbox writes per safety-rules Rule 3) | N/A | N/A | REQUIRED | REQUIRED | REQUIRED |
| Stage 9 Documentation | N/A | REQUIRED (Drive) | N/A | N/A | N/A | N/A |
| Stage 10 Native-AI | N/A | N/A | N/A | N/A (UAT-6.1 paste-only) | N/A (UAT-6.1 paste-only) | N/A (UAT-6.1 paste-only) |
| Stage 11 Sign-off | GRACEFUL | N/A | N/A | N/A | N/A | N/A |

> **UAT-6.1 lock:** Stage 10 Native-AI ingestion is `paste-only` for all 3 platforms; the matrix carries NO `api` branch for any native-AI ingestion path. Tool produces docs; humans paste manually per platform UI.
>
> **UAT-3.5 lock:** Pipefy/Wrike/Ziflow are API-only through v2.6 — the matrix carries NO MCP-branch column for these 3 platforms. (Pipedream-hosted MCP wrappers for Pipefy / Wrike are catalogued as parked references in PROJECT.md; not exercised by this matrix.)

## Per-stage fallback behaviour

- **Stage 1 Kickoff — Miro MCP (GRACEFUL):** When Miro MCP is missing or `board_search_boards` returns 0, the skill instructs the user to paste-from-screenshot the Miro board content into the kickoff capture. No HALT. Skill logs degraded-mode entry.
- **Stage 1 Kickoff — Coda MCP (GRACEFUL):** When Coda MCP is missing, Field Notes triage degrades to paste-from-Coda — the user copies Field Notes table content from the Coda doc UI into the kickoff capture. No HALT. Skill logs degraded-mode entry.
- **Stage 3 SOW — Miro MCP (GRACEFUL):** Same as Stage 1 — paste-from-screenshot fallback. No HALT.
- **Stage 6 Cost estimate — Coda MCP (GRACEFUL):** When Coda MCP is missing, the skill enters manual mode — cost estimate is emitted as a local `06_cost_v<N>.md` artefact only; the Coda task-table upsert is DEFERRED (queued for retry once Coda MCP is wired). The skill logs the deferred upsert with the task-table row payload so the user can manually re-run later. No HALT.
- **Stage 8 Test bot — Pipefy/Wrike/Ziflow API (REQUIRED, HALT):** The test runner cannot execute sandbox test cases without the platform API for the targeted platform. If the platform API probe fails, the runner HALTs with `REFUSED: connector_missing` and surfaces the connector name + cheap-read failure to the user. Stage 8a / 8d both depend on this.
- **Stage 9 Documentation — Google Drive MCP (REQUIRED, HALT):** Doc publishing cannot complete without Drive. If Drive MCP probe fails, the skill HALTs with an explicit error message and instructs the user to wire Drive MCP (or run `claude mcp list` to verify auth). No silent paste-fallback — Stage 9 publishes to canonical Drive doc URLs that downstream `<CR>/doc-diff.md` references; manual paste would orphan the diff.
- **Stage 10 Native-AI — Pipefy/Wrike/Ziflow API (N/A per UAT-6.1):** Paste-only. The skill emits a paste bundle for the user to upload manually via each platform's UI; no API call attempted. Audit log records the paste bundle + upload acknowledgement. No HALT (paste-only is the only supported path).
- **Stage 11 Sign-off — Coda MCP (GRACEFUL):** When Coda MCP is missing, the brain-mirror Coda one-way push is SKIPPED — local `<Client> Brain/` content is committed normally; the Coda mirror push is logged for retry. The CR archive completes without the mirror push. No HALT — the mirror is a one-way idempotent push that can be re-run later.

## Resolved OPEN-Q values (inline)

These 8 values are the inline resolutions for the connector-related OPEN-QUESTIONS rows owned by Phase 5 / Wave 4 (per D-57 inline-resolution method). The matching `Status: decided` row flips in `.planning/OPEN-QUESTIONS.md` cite the line offsets in this section.

- **Q06.1 Pipefy rate-limit:** 500 req/30s ≈ 16.67 req/sec per token. Throttle at 13 req/sec (80% buffer). Source: Pipefy Community + Pipefy Help Center 2026-05-10. Re-verify at Phase 6 PLAT-01 kickoff per Q06.2 (consumer-throttle calibration).
- **Q07.1 Wrike rate-limit:** 400 req/min per user + 5000 req/min per IP. Throttle at 320 req/min per user (80% of per-user ceiling). Source: Wrike Help Center 2026-05-10. Re-verify at Phase 6 PLAT-02 kickoff per Q07.2 (consumer-throttle calibration).
- **Q09 Claude in Chrome canonical naming:** Primary canonical product name = "Claude for Chrome" (per `claude.com/claude-for-chrome` marketing page); also referred to as "Claude in Chrome" (per Anthropic Help Center `support.claude.com` Get-started article). Both names in active use 2026-05-10; treat as interchangeable. Glossary entry recorded in `dydx-delivery/references/glossary.md` § "Platform terms" → `Claude for Chrome`.
- **Q10 Coda MCP:** WIRED + authenticated; endpoint surface `apis/v1` (Coda MCP server canonical tool surface). Re-confirmed 2026-05-10 — no drift vs AUDIT-08 baseline 2026-05-09T17:05Z; in-agent `whoami` round-trip OK during Wave 4 authoring.
- **Q11 Google Workspace MCP:** Server choice = 3 separate Anthropic-maintained MCP servers (Drive / Gmail / Calendar) at `*mcp.googleapis.com/mcp/v1`. NOT `taylorwilsdon` / NOT `piotr-agier`. AUDIT-08 baseline re-affirmed 2026-05-10.
- **Q12 Miro MCP:** WIRED + authenticated; endpoint `https://mcp.miro.com`. AUDIT-08 baseline (probe-date 2026-05-09T17:05Z showed `board_search_boards` returned 5 boards / total 920) re-affirmed 2026-05-10 — no drift signal observed.
- **Q13 Wrike host SoT:** Per-tenant Wrike API base URL is parsed from the OAuth token response `host` field (per-tenant SoT — hardcoding `www.wrike.com` breaks multi-tenant per MOD-5). Canonical persistence destination = `<Client> Brain/00_HUB.md` Coda block (per DESIGN-29 schema); final destination at Phase 6 PLAT-02 discretion. Stage 7b implementation prompt + Stage 8 test-bot `client_state.yaml.wrike.host:` both read from this single SoT.
- **Q25 Wrike + Ziflow auth-concurrency:** Default `exclusive` per Pipefy precedent (UAT-4.2 — per-tenant operation serialization + `auth_switch_required` retry signals at tenant-boundary crossings). LOW confidence — live tenant test deferred to Phase 6 PLAT-02 (Wrike) and PLAT-03 (Ziflow) kickoff. `client_state.yaml` `wrike.auth_concurrency_class:` + `ziflow.auth_concurrency_class:` fields populated by Phase 6 probes.

## Session-start probe schema

Skills consume the matrix at session start. The probe transport-status semantics (per `claude mcp list` output) are:

| Status string | Meaning | Skill action |
|---|---|---|
| `✓ Connected` | MCP server listed + cheap-read returns expected shape | Proceed with connector path. |
| `! Needs authentication` | MCP server listed but auth missing/expired | Skill prompts the user to re-auth (`claude mcp` flow); does NOT auto-retry indefinitely. |
| `not listed` | MCP server absent from `claude mcp list` output | Apply per-stage fallback per §Per-stage fallback behaviour above (GRACEFUL) OR HALT (REQUIRED). |

Per-MCP cheap-read endpoints (executed once at session start to confirm authentication has not silently expired):

| Connector | Cheap-read |
|---|---|
| Coda MCP | `whoami` (returns workspace + user identity) |
| Google Drive MCP | List 1 file in user's Drive root (canonical `files.list` page-size=1) |
| Google Gmail MCP | List 1 label (canonical `labels.list` page-size=1) |
| Google Calendar MCP | List 1 calendar (`calendars.list` page-size=1) |
| Miro MCP | `board_search_boards` page-size=1 |
| Pipefy API | `query { me { id } }` (1-field introspection) |
| Wrike API | `GET /contacts?me=true` (1-field self) |
| Ziflow API | `GET /accounts` (canonical self-account list) |

> **`connector_probe.yaml` schema (session-scoped cache file):** Deferred to v2.6 / SURF-01..03 per CONTEXT D-56. Phase 5 ships matrix-as-doc only; the cache file shape is locked alongside the substantive `validate-frontmatter` + `bump-artefact-version` hook bodies in v2.6.

## Probe-cache deferral

Per D-56 (CONTEXT.md), this matrix is doc-only — no slash command, no agent, no probe hook ships in Phase 5. On-demand re-runs are manual: a human re-runs `claude mcp list` against this matrix at session start (or when a connector wiring changes). An on-demand `/dydx-probe-connectors` slash command, an auto-firing session-start probe hook, and the `connector_probe.yaml` session-scoped cache file are all DEFERRED to v2.6 / SURF-01..03 milestone delivery. Phase 5 establishes the canonical reference content; v2.6 wraps it in executable surfaces.
