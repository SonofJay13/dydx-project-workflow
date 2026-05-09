# Technology Stack — v2.0 Implementor Edition Additions

**Project:** dydx-delivery plugin v2.0 ("Implementor Edition")
**Researched:** 2026-05-09
**Mode:** Project Research — additions only (existing v0.3.0 markdown-only stack is the baseline; do not re-state it)
**Overall confidence:** MEDIUM — Coda API, Claude Code plugin spec, Python deps verified via Context7 (HIGH); MCP server identities and native-AI ingestion paths could not be verified for the team's actual tenant (LOW; flagged inline)

---

## Constraint baseline (carried from v0.3.0)

These do **not** change in v2:

- **Languages of the plugin itself:** Markdown for skills/templates/references, YAML for frontmatter, JSON for manifests. (`.planning/codebase/STACK.md` lines 7-13.)
- **Runtime:** Claude Code (build seat) + Cowork (strategy seat). No new runtime introduced.
- **Manifest contract:** root `.claude-plugin/marketplace.json` + `dydx-delivery/.claude-plugin/plugin.json`.
- **Distribution:** Claude Code plugin marketplace; manual semver bump in both manifests + push.
- **Per-client artefact storage:** filesystem only (`<Client> Brain/`, `ChangeRequests/<CR>/`).

The only place Python enters the v2 footprint is **inside the per-client persistent test harness**, which lives in `<Client> Brain/` (outside this repo) and is treated by this plugin as a generated artefact, not a plugin dependency. The plugin still ships zero runtime dependencies.

---

## v2 additions overview

| Layer | Addition | Purpose | Confidence |
|---|---|---|---|
| Plugin surfaces | `commands/` directory | Implements `/refine-<skill>` and `/run-test-harness` slash commands | HIGH — verified against Claude Code plugin spec |
| Plugin surfaces | `agents/` directory | Hosts the test-harness orchestrator subagent and (optional) audit subagents | HIGH |
| Plugin surfaces | `hooks/hooks.json` | Optional — sandbox-id pre-flight hook to enforce safety-rules.md on `Bash`/file-write | HIGH |
| Plugin surfaces | `mcpServers` manifest field (or `.mcp.json`) | Declares which MCPs the plugin expects (no servers shipped in repo) | HIGH |
| Connector — Coda | Coda REST API v1 + (optional) `coda-mcp` community server | Stage 5 scope/cost tasks + Stage 10 brain-mirror publish (one-way local→Coda) | HIGH (API), MEDIUM (MCP) |
| Connector — Miro | Miro REST API v2 (Python client `miro-api`) | Stage 0 kickoff capture — board ingest, image fallback | MEDIUM — no canonical Miro MCP found in Context7; treat MCP-vs-API as a workspace question |
| Connector — Google Workspace | One unified MCP (Drive + Gmail + Calendar + Docs + Slides + Sheets) | Stage 0 (notes), Stage 8 (doc publish), Stage 10 (archive) | MEDIUM — recommended candidate identified, but the team must confirm which one is actually wired |
| Test harness — Python | Python 3.11 (minimum), `pytest 9.0.x`, `gql[requests] 3.5.x`, `requests 2.32.x` (or `httpx 0.28.x`), `PyYAML 6.0.x` | Per-client persistent state-assertion runner | HIGH |
| Versioning | Plugin to `v2.0.0`, marketplace to `2.0.0` (sync the two) | Major bump justified by surface additions + lifecycle expansion | HIGH (semver convention is repo-documented) |

---

## 1. Plugin surfaces — Claude Code platform reality

### Plugin directory spec (verified 2026-05-09 via Context7 `/anthropics/claude-code`)

A Claude Code plugin can declare any of:

```
dydx-delivery/
├── .claude-plugin/
│   └── plugin.json          # manifest (already present)
├── skills/                  # already present (7 skills v0.3.0)
├── commands/                # NEW for v2 — slash commands, .md files, auto-discovered
├── agents/                  # NEW for v2 — subagents, .md files, auto-discovered
├── hooks/
│   └── hooks.json           # NEW for v2 — lifecycle hooks (optional)
└── (.mcp.json optional, or mcpServers field in plugin.json)
```

The plugin manifest can declare these surfaces explicitly:

```json
{
  "name": "dydx-delivery",
  "version": "2.0.0",
  "commands": "./commands",
  "agents": "./agents",
  "hooks": "./hooks/hooks.json",
  "mcpServers": "./.mcp.json"
}
```

**Source (HIGH):** `/anthropics/claude-code` → `plugins/plugin-dev/skills/plugin-structure/references/manifest-reference.md`. Fields shown: `commands`, `agents`, `hooks`, `mcpServers`.

### `commands/` — slash commands

- File format: Markdown with optional YAML frontmatter; each `.md` file becomes a slash command named after the filename.
- Frontmatter fields (all optional): `description`, `argument-hint`, `allowed-tools`, `model`.
- Body is the prompt; can use `$1`, `$2`, `$ARGUMENTS`, `@path/to/file`, and `` !`bash command` `` for inline bash output.
- **Source (HIGH):** `/anthropics/claude-code` → `plugins/plugin-dev/skills/command-development/references/frontmatter-reference.md`.

**Recommendation for `/refine-<skill>`:** Create one `commands/refine-<skill>.md` per refinable skill (or one parameterised `commands/refine.md` taking the skill name as `$1`). Resolves the unimplemented-`/refine-*`-references concern in `CONCERNS.md` lines 37-41.

```markdown
---
description: Refine a v0.3.0 dydx-delivery artefact — reads latest, asks targeted questions, writes _v(N+1)
argument-hint: <skill-name> [client] [feature]
allowed-tools: Read, Write, Glob, Grep
---

You are refining the latest output of `$1` for the named client/feature...
```

### `agents/` — subagents

- File format: Markdown with YAML frontmatter (`name`, `description`, `model`, `color`, `tools` array).
- `tools` array implements least-privilege.
- Auto-discovered by Claude Code; can be invoked manually or implicitly when the description matches.
- **Source (HIGH):** `/anthropics/claude-code` → `plugins/plugin-dev/skills/agent-development/SKILL.md`.

**Recommendation for the test-harness orchestrator:** It is an `agents/` entry, not a `commands/` entry.

Reason: the orchestrator is long-running, makes judgement calls across multiple platform calls, and benefits from a constrained tool set. Slash commands run in the parent context and cannot enforce per-invocation tool restrictions cleanly. Agent frontmatter `tools: ["Read", "Bash", "Grep"]` is the right shape for "may shell out to the per-client Python harness, may read results, must not edit specs".

### `hooks/hooks.json` — lifecycle gates

Verified shape (Context7 `/anthropics/claude-code`):

```json
{
  "description": "dydx-delivery v2 safety hooks",
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          { "type": "command",
            "command": "python3 ${CLAUDE_PLUGIN_ROOT}/hooks/sandbox_guard.py",
            "timeout": 10 }
        ]
      }
    ]
  }
}
```

**Recommendation:** v2 ships an **optional** `hooks/sandbox_guard.py` PreToolUse hook for the `execute-tests` flow that re-asserts the rules in `dydx-delivery/skills/execute-tests/references/safety-rules.md` (sandbox-only, no `delete_*`, no production tenant IDs). Hooks **augment**, do not replace, the in-skill enforcement. Hard rules location stays canonical at `references/safety-rules.md` (one of the structural decisions called out in `PROJECT.md`).

`PreToolUse` hooks can return `permissionDecision: "deny"` with a `systemMessage`, which is exactly the shape needed for "refused: out_of_sandbox" enforcement.

### Versioning rules (verified)

`README.md` lines 81-83 already document the semver convention. v2 plan:

- `dydx-delivery/.claude-plugin/plugin.json` → `version: "2.0.0"` (major: surfaces added, lifecycle stages added, breaking artefact-name changes likely).
- `.claude-plugin/marketplace.json` → `metadata.version: "2.0.0"` and `plugins[0].version: "2.0.0"` — keep the two locked.
- **Concern resolved on the way:** `CONCERNS.md` lines 9-24 lists the v0.1.0 / v0.3.0 / 1.2.0 / hardcoded-`v0.1.0`-runner mismatch. Pick **one** number per surface and have v2.0.0 be the cleanup commit.

---

## 2. Connectors / MCPs

> **Strong caveat (LOW confidence on workspace state):** I could not verify which MCPs are actually installed in the team's Cowork/Claude Code seats. The names below are the *current canonical candidates from Context7 / public registries* — the design must include a "connector probe" step that lists what is actually wired before any v2 skill assumes a server.

### 2.1 Miro MCP — **NO canonical MCP found in Context7**

- Searches for `miro` returned `/miroapp/api-clients` (the **Miro Python REST client**, MIT-licensed, official Miro org) and `/websites/developers_miro` (developer docs). **No `*-miro-mcp`-style server appears in Context7.**
- **Confidence: LOW** that a maintained Miro MCP exists. There may be community ones outside Context7 — could not verify in this run because WebSearch was denied.
- The Miro REST API itself is well-documented (HIGH): base `https://api.miro.com/v2/`, OAuth 2.0 access token, image-create endpoint accepts URLs or data URLs (`POST /v2/boards/{board-id}/images`).
- **Image vs text:** Public Miro REST API exposes board *items* (sticky notes, shapes, text, images) per item. There is no documented "render whole board to PNG" REST endpoint — board export to image/PDF is historically a Frame-level operation in the UI and a paid-tier feature on the API side. Could not verify export-job endpoint in 2026; treat as **NOT AVAILABLE** until the team confirms tier.

**Fallback shape (recommended for v2 Stage 0):**

```
Preferred:  Direct API ingest via miro-api Python client → walk items, build markdown
Acceptable: Manual screenshot (board PNG export from Miro UI) pasted into Claude Code
            with the kickoff skill prompting the user to paste the image
Forbidden:  Assuming an MCP "fetch board as image" tool exists
```

Stage 0 kickoff skill must include a **branch:** "if Miro MCP `get_board` returns text → use it; if not → ask the user to paste an image".

**Pin (only if the team builds a small Stage 0 helper script):**
- `miro-api` Python (PyPI) — official Miro org, generated from OpenAPI. **Confidence: HIGH** that the package exists and reads `MIRO_CLIENT_ID`/`MIRO_CLIENT_SECRET`/`MIRO_REDIRECT_URL` env vars. Latest version not verified in this run; pin once confirmed.

### 2.2 Coda — API + community MCP

**Coda REST API v1 (HIGH confidence, source: `/websites/coda_io_apis_v1`):**

| Aspect | Value | Notes |
|---|---|---|
| Base URL | `https://coda.io/apis/v1` | |
| Auth | `Authorization: Bearer <api_token>` | API token from https://coda.io/account |
| Read rate limits | 100 req / 6 s | |
| Write rate limits | 10 req / 6 s (POST/PUT/PATCH on table data) | **Tight** — Stage 10 brain mirror must batch |
| Doc-content writes | 5 req / 10 s | Affects writing pages/sections |
| List docs | 4 req / 6 s | |
| 429 handling | Standard `{statusCode: 429, statusMessage: "Too Many Requests", message: "Too Many Requests"}` — back off and retry | No `Retry-After` header documented |
| Schema discovery | `GET /docs/{docId}/tables/{tableIdOrName}/columns` returns `id`, `name`, `display`, `calculated`, `formula`, `defaultValue`, `format` per column | `format.type` includes column-type info; pagination via `pageToken`, `limit` 1-100 (default 25) |
| Write rows | `POST /docs/{docId}/tables/{tableIdOrName}/rows` — body `{rows: [{cells: [{column, value}]}], keyColumns?: [...]}` — returns **202 Accepted** with `requestId` (queued processing, "several seconds") | If `keyColumns` set → upsert; if absent → always insert |
| Idempotency | **No documented idempotency key.** The response includes `requestId` but it is server-generated, not client-supplied. Must implement client-side idempotency via `keyColumns` upsert pattern. | |
| Formula columns | Column object exposes `calculated: true` and `formula:` — these are **read-only via API**. Writes to a formula column would be rejected; the v2 schema-mapper must skip them. | |
| Linked-reference columns | Writes accept the linked row's `value` per cell. Coda parses linked rows by display name unless `disableParsing=true`. | |

**Coda MCP (`/dustinrgood/coda-mcp`, MEDIUM confidence — community, not Coda-official):**

Tool surface (from Context7 `/dustinrgood/coda-mcp`):
- `coda_list_rows` — filter, sort, paginate
- `coda_get_row` — single row, optional column-name view
- `coda_update_row` — single row update
- `coda_bulk_update_rows` — batch updates
- (presumed but not seen in this snippet pull: list_docs, list_tables, list_columns, insert_rows — typical for these MCPs)

**Capability gap analysis:**

| Need | Coda API direct | Coda MCP (community) | Recommendation |
|---|---|---|---|
| Read schema | YES | Likely YES | Either is fine |
| Read rows | YES | YES | Either |
| Insert/upsert rows (Stage 5 task creation, Stage 10 brain mirror) | YES — POST /rows with `keyColumns` | YES — `coda_bulk_update_rows` for updates; insert path documented as supported | API direct is more controllable; MCP is acceptable for one-off ops |
| Idempotency | Manual via `keyColumns` upsert | Inherited from underlying API call | **Adopt: client-side `keyColumns` pattern using the brain-mirror's stable local IDs as the upsert key** |
| Write to formula column | NO (calculated columns are read-only) | NO | Schema-map must filter |
| Two-way sync | N/A — out of scope per `PROJECT.md` line 60 | N/A | — |

**v2 recommendation:**

- **Primary: Coda REST API v1 directly** from a small Python helper invoked by the relevant skill. Reasons: (1) tight rate limits demand client-side batching/throttling that an MCP wrapper hides poorly; (2) the brain-mirror is one-way and bulk, which a typed HTTP call models better than chained MCP tool calls; (3) idempotency via `keyColumns` requires explicit control of the request body.
- **Acceptable secondary: `coda-mcp` server** for *interactive* skill flows — Stage 5 "show me current task list / update one row" works fine over MCP.
- **Pin (when adopted):**
  - `coda-mcp` (npm) — `npx -y coda-mcp@latest`, env `API_KEY`. Version not pinnable in this run; recommend pinning to a specific version after first install (e.g. `coda-mcp@0.4.0`) rather than `@latest`.
  - For direct API access: `requests 2.32.x` (or `httpx 0.28.x`) — see §3.

### 2.3 Google Workspace MCP — Drive + Gmail + Calendar (recommend a unified server)

- The Anthropic-maintained registry historically split these into per-product servers (`@modelcontextprotocol/server-gdrive`, `@modelcontextprotocol/server-gmail`, etc.). Could not verify their current status in this run (LOW).
- **Verified candidate (MEDIUM, Context7 `/taylorwilsdon/google_workspace_mcp`):** a single server covering Calendar, Drive, Gmail, Docs, Slides, Sheets, Forms, Chat.
  - Tool surface includes: `search_drive_files`, `get_drive_file_content`, `list_drive_items`, `create_drive_file`, `search_gmail_messages`, `send_gmail_message`, `draft_gmail_message`, `list_calendars`, `get_events`, `create_event`, `modify_event`, `delete_event`, plus Docs/Sheets/Slides read+write+comment tools.
  - Auth: `GOOGLE_OAUTH_CLIENT_ID` / `GOOGLE_OAUTH_CLIENT_SECRET` env vars (OAuth 2.0).
  - Run: `uvx workspace-mcp` or `uv run main.py`. Python 3.11+ required.
- **Capability fit:**
  - Stage 0 kickoff (read meeting notes from Drive) → ✓ `get_drive_file_content`
  - Stage 8 documentation update (write Docs/Slides) → ✓ `create_doc`, `batch_update_presentation`
  - Stage 10 archive (move CR folder, send sign-off email, create calendar reminder) → ✓ all three
  - Hub link contract check (`<Client> Brain/00_HUB.md` `Documentation:` Drive link) → ✓ `search_drive_files`

**Alternative candidate (Context7 `/piotr-agier/google-drive-mcp`, MEDIUM):** Drive + Docs + Sheets + Slides + Calendar in one. Smaller community footprint.

**Recommendation:** Use **one** unified Google Workspace MCP. Splitting Drive vs Gmail vs Calendar into three separate servers triples auth scope management and adds drift between Stage 0 (Gmail+Calendar+Drive) and Stage 8 (Drive+Docs). The skill design should reference tool *names* not server *names* so a swap stays cheap.

**v2 must include a "connector probe" skill or hook** that, on first session, lists installed MCPs and reports which expected surfaces are present. Today the plugin has zero MCPs declared — adding `mcpServers: "./.mcp.json"` to the plugin manifest is the recommended way to declare them once chosen, but the *running team* must wire credentials.

### 2.4 Gmail-only MCP (fallback)

If the team prefers a per-product split: `/shinzo-labs/gmail-mcp` (Context7 verified MEDIUM — uses Smithery installer or `npx @shinzolabs/gmail-mcp`, OAuth via `~/.gmail-mcp/gcp-oauth.keys.json` or env vars).

### 2.5 Calendar MCP

No standalone Calendar MCP appeared in Context7 results that matched cleanly; both unified servers (`taylorwilsdon`, `piotr-agier`) include Calendar tools. **Use one of those.**

### 2.6 Claude in Chrome

- This is an Anthropic product, not an MCP server. It is a runtime entrypoint (browser-context Claude). The plugin treats it as one more "seat" for Stage 0 kickoff capture (paste-from-browser flows). Nothing to pin in `plugin.json` for it.
- **Confidence: MEDIUM** that "Claude in Chrome" remains the canonical name in 2026; could not verify product naming in this run.

### 2.7 MCP wiring — declaration in `plugin.json`

Verified shape (Context7 `/anthropics/claude-code`):

```json
{
  "name": "dydx-delivery",
  "version": "2.0.0",
  "mcpServers": "./.mcp.json"
}
```

…where `dydx-delivery/.mcp.json` lists the MCPs the plugin **expects to find available** (it doesn't ship them). Example:

```json
{
  "mcpServers": {
    "coda":  { "command": "npx", "args": ["-y", "coda-mcp@0.4.0"], "env": { "API_KEY": "${CODA_API_TOKEN}" } },
    "google_workspace": { "command": "uvx", "args": ["workspace-mcp@latest"], "env": { "GOOGLE_OAUTH_CLIENT_ID": "${GOOGLE_OAUTH_CLIENT_ID}", "GOOGLE_OAUTH_CLIENT_SECRET": "${GOOGLE_OAUTH_CLIENT_SECRET}" } }
  }
}
```

**Pin once chosen.** Avoid `@latest` for production seats; locks drift the user can't see.

---

## 3. Per-client persistent test harness — Python deps

The harness lives in `<Client> Brain/test-harness/` (one per client), is *generated* by the v2 plugin, and is *invoked* by Claude Code at Stage 7. The harness is the only Python in the v2 footprint.

### 3.1 Python version

**Pin: Python 3.11.x (minimum).** Justification:
- `httpx` requires 3.9+ (verified HIGH — Context7 `/encode/httpx`).
- The recommended Google Workspace MCP requires 3.11+.
- 3.11 has stable `tomllib` in stdlib (useful for harness config), better error messages, faster startup. 3.12/3.13 are acceptable but 3.11 is the floor that aligns with the Google Workspace MCP runtime if the team co-locates.

**Confidence: HIGH.**

### 3.2 Pipefy GraphQL client

**No Pipefy-specific Python SDK appears in Context7.** (Searched `pipefy`, only unrelated results.)

**Recommendation: use `gql` (Python) with the `requests` transport.**

- Library: `gql` from `/graphql-python/gql` (Context7 HIGH).
- Pin: `gql[requests]==3.5.*` for sync; `gql[aiohttp]==3.5.*` if async needed. (Latest 3.x is the stable line; 4.x is in pre-release per docs.) **Confidence: MEDIUM** on exact patch version — verify on PyPI before pinning.
- Auth pattern: `Authorization: Bearer <PIPEFY_API_TOKEN>` — matches the env-var convention already in the repo (`build-prompt-template.md` lines 109-110).
- Endpoint: `https://api.pipefy.com/graphql` (single endpoint).

```python
from gql import Client, gql
from gql.transport.requests import RequestsHTTPTransport
import os

transport = RequestsHTTPTransport(
    url="https://api.pipefy.com/graphql",
    headers={"Authorization": f"Bearer {os.environ['PIPEFY_API_TOKEN']}"},
    verify=True, retries=3,
)
client = Client(transport=transport, fetch_schema_from_transport=False)
```

**Why not `requests` + raw GraphQL strings?** `gql` validates queries client-side, supports schema introspection, handles variables cleanly, and gives better errors than ad-hoc string concatenation. The marginal complexity over `requests` is recovered the first time a query has a typo.

**Confidence on Pipefy GraphQL endpoint URL: MEDIUM** — could not verify in this run (WebSearch denied). The `api.pipefy.com/graphql` URL is the long-standing endpoint per training data; the design phase must confirm against current Pipefy docs.

### 3.3 Wrike REST client

**No Wrike Python SDK appears in Context7 with significant code coverage.** (Library entry `/websites/developers_wrike` exists but has only 12 snippets.)

**Recommendation: use `requests` directly** (or `httpx` if async is needed).

- Pin: `requests==2.32.*` (latest stable 2.x; verified HIGH that Requests is actively maintained at PSF). For async: `httpx==0.28.*` (Context7 `/encode/httpx` HIGH).
- Auth: Wrike supports two flavours (verified HIGH from `/websites/developers_wrike`):
  1. **Permanent access token** (recommended for sandbox): `Authorization: bearer <token>`, no refresh needed.
  2. **OAuth 2.0** with `client_id`/`client_secret` → `access_token` + `refresh_token` + `expires_in: 3600`. Token response includes a `host` field (e.g. `www.wrike.com`) used to build the base URL: `https://<host>/api/v4`.
- **Critical: The Wrike base URL is dynamic per-account.** The harness must read `host` from the OAuth token response (or read a per-client config var) and not hardcode `www.wrike.com`. EU and other regions use different hosts.

```python
import requests, os
host = os.environ.get("WRIKE_HOST", "www.wrike.com")
base = f"https://{host}/api/v4"
sess = requests.Session()
sess.headers["Authorization"] = f"bearer {os.environ['WRIKE_API_TOKEN']}"
```

**Rate limit:** existing safety-rules.md line 76 captures it as 200 req/min. Could not verify in this run that this is still current; the design phase should confirm.

### 3.4 Ziflow REST client

**No Ziflow Python SDK appears in Context7.** (Searches returned unrelated results.)

**Recommendation: use `requests` directly.** Endpoints documented in the existing `technical-spec-template.md` line 113 (`POST /api/v2/projects`) — keep the same shape.

- Pin: `requests==2.32.*`.
- Auth: API key in header (existing template treats it as "secrets store"-loaded). Header name and exact base URL **could not be verified** in this run; mark as **OPEN — needs API doc check during phase build**.

### 3.5 YAML parsing — `client_state.yaml`

**Recommendation: `PyYAML` 6.0.x with `safe_load` / `safe_dump`.** Confidence: HIGH (Context7 `/yaml/pyyaml`).

```python
import yaml
with open("client_state.yaml") as f:
    state = yaml.safe_load(f)         # dicts/lists/primitives only
yaml.safe_dump(state, open("client_state.yaml", "w"), default_flow_style=False)
```

**Why PyYAML over `ruamel.yaml`:**

| Criterion | PyYAML | ruamel.yaml |
|---|---|---|
| Round-trip preservation (comments, key order) | NO (key order yes since 3.7+, comments no) | YES |
| Maturity | Highest — de facto stdlib YAML | High |
| Dep size | Small | Medium |
| Use case fit | Reading and writing **machine-managed** state files where comments don't matter | Reading and writing **human-edited** files where preserving formatting matters |

`client_state.yaml` is harness-managed, not human-edited. Comments are not meaningful to preserve. PyYAML is the simpler choice and avoids an extra dependency line. If the team later wants `client_state.yaml` to be human-edited with comments, **switch to ruamel.yaml at that point** — switching is mechanical.

**Forbidden:** never `yaml.load()` without a Loader. Always `safe_load`. PyYAML's docs explicitly call this out (Context7 `/yaml/pyyaml`).

### 3.6 Test runner — `pytest` vs custom

**Recommendation: keep the v0.3.0 `execute-tests` runner pattern (custom assertion runner driven by the markdown test plan), AND add `pytest 9.0.x` for the harness's *own* unit tests.**

Rationale:

1. **Parity with v0.3.0.** `execute-tests` SKILL.md describes a row-by-row markdown test plan executor that logs to a results file in real-time. That contract is in the safety-rules.md ladder ("Audit trail", "Stop on infrastructure failure"). pytest's reporting model (collect → run → report) is a poor fit for "stop after 3 consecutive infra errors and write what we have" — pytest's `--maxfail=3` resembles it but the audit-log shape is wrong.
2. **The v2 *harness* has two different jobs.** (a) Run client-supplied test rows against the sandbox — this is the v0.3.0 contract, keep the custom runner. (b) Verify the harness *itself* is correct (e.g. "the schema mapper handles a column with calculated:true correctly") — this is unit-test territory, use pytest.
3. **pytest 9.0.x is the current stable line** (Context7 `/pytest-dev/pytest` shows version 9.0.0 in `Versions:` field). HIGH confidence.

```toml
# <Client> Brain/test-harness/pyproject.toml
[tool.pytest]
minversion = "9.0"
addopts = ["-ra", "-q"]
testpaths = ["tests"]
```

**Concrete file shape:**

```
<Client> Brain/test-harness/
├── pyproject.toml             # pytest config + deps
├── client_state.yaml          # PyYAML safe_load/dump
├── runner/
│   ├── __init__.py
│   ├── runner.py              # custom row-by-row runner (mirrors execute-tests)
│   ├── platforms/
│   │   ├── pipefy.py          # gql + Bearer auth
│   │   ├── wrike.py           # requests + dynamic host
│   │   └── ziflow.py          # requests + API key
│   └── safety.py              # local copy of the rule set, but referencing the canonical safety-rules.md
└── tests/                     # pytest tests of the harness itself
    └── test_schema_mapper.py
```

### 3.7 How the AI orchestrator invokes Python

Three options:

| Option | Mechanism | Verdict |
|---|---|---|
| A | `Bash` from inside an `execute-tests`-style skill — runs `python3 runner/run.py --test-plan <path>` | **Recommended.** Simple, audit-loggable, matches the existing skill model. Bash is already the trust-boundary the skill operates over. |
| B | A dedicated `agents/test-harness-orchestrator.md` subagent with `tools: ["Read", "Bash", "Grep"]` and a description that triggers on "run test harness" | **Recommended for the orchestration role.** The subagent reads the latest test plan, calls option-A from inside its own context, parses the results file, and decides whether to escalate to a human. Encapsulates the judgement layer described in `PROJECT.md` constraint "Test harness architecture: Deterministic Python harness for state/integration assertions, AI orchestrator on top for judgement calls". |
| C | A custom MCP server wrapping the harness | **Reject for v2.** Out of scope per `PROJECT.md` line 56 ("Building net-new connectors (auth provider, custom MCPs)"). |

**Use A + B together:** the subagent (B) shells out (A). The subagent's `tools` array is the enforcement boundary — give it `Read, Bash, Grep` only, deny `Write` / `Edit`. The harness Python writes its own results file; the subagent never edits source skills.

---

## 4. Native-AI knowledge ingestion paths

> **CRITICAL: All three native-AI knowledge endpoints below could NOT be verified in this run** (WebSearch was denied; Context7 has no entries for Pipefy AI, Wrike AI, or Ziflow native AI knowledge bases). Mark every claim here as **LOW confidence — requires Phase-1 verification before any v2 build.**

### 4.1 Pipefy AI

**Status: COULD NOT VERIFY** that Pipefy exposes a knowledge-base ingestion API in 2026.

What is *known* from the existing repo (`technical-spec-template.md`, `discovery-intake/SKILL.md`): Pipefy is the primary platform; the team interacts with it via GraphQL. Whether Pipefy has shipped a "Pipefy AI" branded feature with a public knowledge-ingestion endpoint is **not verifiable from training data + Context7**. Possible states:

1. Public API exists → great, design Stage 9 around it
2. Knowledge-ingestion is internal-only → fall back to copy-paste flow (drag a markdown file into the Pipefy AI UI)
3. No knowledge-base feature → Stage 9 for Pipefy is N/A and the kickoff section can be marked "Pipefy AI: not in product"

**Recommendation:** Stage 9 must be designed with **two paths per platform** — `api` (preferred) and `paste` (fallback). The platform skill (`platform-pipefy`) carries the path decision in its frontmatter. v2 design must call out "verify path before build phase".

### 4.2 Wrike AI / Work Intelligence

**Status: COULD NOT VERIFY.** Wrike has historically branded its AI features as "Work Intelligence". Whether that has a knowledge-ingestion API in 2026 — unknown.

Same recommendation as 4.1: design Stage 9 to support `api` or `paste` per platform.

### 4.3 Ziflow native AI

**Status: COULD NOT VERIFY** that Ziflow has shipped a native-AI knowledge-base feature. Ziflow's API surface in the repo today is purely operational (creating proof projects).

Same recommendation: `api` or `paste` switch per platform skill.

### 4.4 Implementation pattern (regardless of which platforms support API path)

```
platform-pipefy/SKILL.md frontmatter:
---
native_ai_path: api | paste | none
native_ai_endpoint: <url-if-api>
native_ai_auth: <env-var-name-if-api>
---
```

The Stage 9 skill reads frontmatter, branches:
- `api` → POST the brain markdown to the documented endpoint
- `paste` → emit a "ready-to-paste" prompt + markdown chunk and instruct user to paste into the platform UI
- `none` → skip with a note in the artefact

This decouples the *design lock* (do not need to know endpoints today) from the *build lock* (endpoints get filled in during platform-skill build phases).

---

## 5. Summary recommendation table

### Plugin manifest (proposed v2 state)

```json
{
  "name": "dydx-delivery",
  "version": "2.0.0",
  "description": "Stage-gated client delivery pipeline for dYdX Digital — Implementor Edition",
  "commands": "./commands",
  "agents": "./agents",
  "hooks": "./hooks/hooks.json",
  "mcpServers": "./.mcp.json"
}
```

### Per-client harness (`<Client> Brain/test-harness/pyproject.toml`)

```toml
[project]
requires-python = ">=3.11"
dependencies = [
  "gql[requests]==3.5.*",      # Pipefy GraphQL
  "requests==2.32.*",           # Wrike REST + Ziflow REST
  "httpx==0.28.*",              # only if any platform skill needs async (defer)
  "PyYAML==6.0.*",              # client_state.yaml
]

[project.optional-dependencies]
dev = [
  "pytest==9.0.*",
  "pytest-httpx==0.30.*",       # optional, only if async paths added
]

[tool.pytest]
minversion = "9.0"
addopts = ["-ra", "-q"]
testpaths = ["tests"]
```

### MCP servers expected (`dydx-delivery/.mcp.json`)

```json
{
  "mcpServers": {
    "coda": {
      "command": "npx", "args": ["-y", "coda-mcp@<pin>"],
      "env": { "API_KEY": "${CODA_API_TOKEN}" }
    },
    "google_workspace": {
      "command": "uvx", "args": ["workspace-mcp@<pin>"],
      "env": {
        "GOOGLE_OAUTH_CLIENT_ID": "${GOOGLE_OAUTH_CLIENT_ID}",
        "GOOGLE_OAUTH_CLIENT_SECRET": "${GOOGLE_OAUTH_CLIENT_SECRET}"
      }
    }
  }
}
```

(Versions left as `<pin>` — pin during build phase after the team installs and tests.)

### What NOT to add

| Avoid | Why |
|---|---|
| A custom MCP server for the test harness | Out of scope per `PROJECT.md` line 56 |
| `ruamel.yaml` | Over-spec for machine-managed state; PyYAML covers it |
| `pydantic` for state validation | Adds a heavy dep for a single YAML file; manual schema check is fine for v2 |
| `aiohttp` directly | If async needed, `httpx` is the modern pick (HTTP/2 support, sync+async unified) |
| `requests-cache` / Redis | No caching layer needed in v2 — Stage 5/10 Coda writes are user-driven, not high-volume |
| A new GraphQL Python lib (e.g. `sgqlc`) | `gql` is the maintained, broadly used choice |
| Splitting Drive / Gmail / Calendar into 3 separate MCPs | Triples auth scope mgmt; pick one unified server |
| Hardcoding Wrike base URL to `www.wrike.com` | Wrike returns the host per-account; respect the `host` field |
| Writing to Coda formula columns | API rejects them; schema-mapper must filter `calculated: true` columns |
| `@latest` in `.mcp.json` | Hidden version drift across team seats; pin specific versions |

---

## 6. Source confidence — explicit

| Claim | Source | Confidence |
|---|---|---|
| Claude Code plugin can declare `commands/`, `agents/`, `hooks/`, `mcpServers` | Context7 `/anthropics/claude-code` (manifest-reference.md) | HIGH |
| `commands/` files are .md with optional frontmatter (`description`, `argument-hint`, `allowed-tools`, `model`) | Context7 `/anthropics/claude-code` (command-development) | HIGH |
| `agents/` files are .md with frontmatter (`name`, `description`, `model`, `color`, `tools[]`) | Context7 `/anthropics/claude-code` (agent-development) | HIGH |
| `hooks/hooks.json` shape (PreToolUse, PostToolUse, Stop, SessionStart with matcher + command/prompt) | Context7 `/anthropics/claude-code` (hook-development) | HIGH |
| Coda API base URL, Bearer auth, rate limits, write-rows endpoint, columns endpoint, formula columns read-only | Context7 `/websites/coda_io_apis_v1` | HIGH |
| Coda upsert via `keyColumns` | Context7 `/websites/coda_io_apis_v1` | HIGH |
| Coda `coda-mcp` community server tools (`coda_list_rows`, `coda_get_row`, `coda_update_row`, `coda_bulk_update_rows`) | Context7 `/dustinrgood/coda-mcp` | MEDIUM (community, not Coda-official) |
| `miro-api` Python client exists and reads `MIRO_*` env vars | Context7 `/miroapp/api-clients` | HIGH |
| **No canonical Miro MCP found** in Context7 search results | Context7 search result enumeration | MEDIUM (absence is a search result, not a guarantee no MCP exists) |
| Miro REST API can create images on a board via POST `/v2/boards/{id}/images` | Context7 `/websites/developers_miro` | HIGH |
| Miro export-whole-board-to-image endpoint | — | NOT VERIFIED — assume **NOT AVAILABLE** until confirmed |
| Google Workspace unified MCP (`taylorwilsdon/google_workspace_mcp`) tool surface | Context7 `/taylorwilsdon/google_workspace_mcp` | MEDIUM (community) |
| Gmail MCP (`shinzo-labs/gmail-mcp`) auth flow | Context7 `/shinzo-labs/gmail-mcp` | MEDIUM |
| Wrike API base URL pattern (`https://<host>/api/v4`), Bearer token, OAuth 2.0 | Context7 `/websites/developers_wrike` | HIGH |
| Wrike rate limit "200 req/min per token" | Existing repo `safety-rules.md` line 76 — **not re-verified** in 2026 | MEDIUM |
| Pipefy GraphQL endpoint `https://api.pipefy.com/graphql` | Training data only | MEDIUM |
| Ziflow REST endpoint shape (`POST /api/v2/projects`) | Existing repo `technical-spec-template.md` line 113 — not re-verified | MEDIUM |
| Pipefy AI / Wrike AI / Ziflow native AI knowledge-ingestion APIs | None — could not search | LOW — explicit verification needed before any Stage-9 build |
| Python 3.11 minimum | Cross-referenced from `httpx` 3.9+ requirement and Google Workspace MCP 3.11+ requirement | HIGH |
| `gql 3.5.*` is current stable | Context7 `/graphql-python/gql` showing `pip install "gql[all]"` and pre-release 4.x signal | MEDIUM (exact patch not pulled) |
| `requests 2.32.*` | Context7 `/psf/requests` library entry — version not pulled in this run | MEDIUM |
| `httpx 0.28.*` is current | Context7 `/encode/httpx` — exact version not pulled in this run | MEDIUM |
| `PyYAML 6.0.*` | Context7 `/yaml/pyyaml` (HIGH-reputation source) | HIGH |
| `pytest 9.0.x` is the current major | Context7 `/pytest-dev/pytest` `Versions: 9.0.0` | HIGH |

### Items the design phase MUST verify (cannot mark green from this research run)

1. **Miro MCP availability in the team's Cowork seat** — what tools does the installed server actually expose? If none installed: rely on `miro-api` Python client + paste fallback.
2. **Coda MCP version pin** — install `coda-mcp@latest`, capture the exact version, pin it in `.mcp.json`.
3. **Google Workspace MCP choice** — `taylorwilsdon/google_workspace_mcp` vs `piotr-agier/google-drive-mcp` vs separate Anthropic-maintained servers. Pick one and verify it covers Drive + Gmail + Calendar. Pin version.
4. **Pipefy GraphQL endpoint URL + 2026 rate limits** — confirm `api.pipefy.com/graphql` and `100 req/min per token`.
5. **Wrike rate limits in 2026** — confirm `200 req/min per token`.
6. **Ziflow auth header name + base URL** — confirm against current Ziflow API docs.
7. **Pipefy AI / Wrike AI / Ziflow native AI knowledge-ingestion paths** — full audit; this is the single biggest "unknown" in v2.
8. **Latest patch versions** for `gql`, `requests`, `httpx`, `pytest`, `PyYAML` — verify on PyPI before committing the harness `pyproject.toml`.
9. **Claude in Chrome product naming and entrypoint** — confirm it's still the canonical name in 2026.

---

*Stack additions research — 2026-05-09. Web search and direct doc fetch were blocked in this run; all external verification was done through Context7 (`/anthropics/claude-code`, `/websites/coda_io_apis_v1`, `/dustinrgood/coda-mcp`, `/miroapp/api-clients`, `/websites/developers_miro`, `/websites/developers_wrike`, `/taylorwilsdon/google_workspace_mcp`, `/shinzo-labs/gmail-mcp`, `/yaml/pyyaml`, `/encode/httpx`, `/graphql-python/gql`, `/pytest-dev/pytest`, `/psf/requests`). The 9 items above are the explicit gaps the design phase must close.*
