# External Integrations

**Analysis Date:** 2026-05-09

> Note: this repository contains no executable code. "Integrations" below means: (1) the host systems the plugin is *distributed to and runs inside* (Claude Code, Cowork), and (2) the external systems that the plugin's generated artefacts and `execute-tests` runner *target* at consumer time. The plugin itself does not contain wired-up SDK clients or runtime API code — it contains skill content that describes how downstream skills/builds should integrate.

## Plugin Host Systems

### Claude Code

- **Role:** Primary plugin host. Plugin distributed via Claude Code plugin marketplace.
- **Manifest contract:** `.claude-plugin/marketplace.json` (marketplace) + `dydx-delivery/.claude-plugin/plugin.json` (plugin)
- **Install path documented:** `dydx-delivery/README.md` lines 109–113 and root `README.md` lines 17–27:
  ```
  /plugin marketplace add https://github.com/SonofJay13/dydx-project-workflow
  /plugin install dydx-delivery
  ```
- **Update path:** `/plugin update dydx-delivery` or `/plugin update --marketplace dydx-digital`
- **Skill loading:** Each `dydx-delivery/skills/<skill-name>/SKILL.md` is auto-loaded by Claude Code's skill loader; YAML frontmatter `name` + `description` drives discovery/triggering.
- **Role per pipeline:** "build seat" — runs `generate-build-prompt` output, executes platform API calls, writes/edits code (per `dydx-delivery/skills/generate-build-prompt/references/when-to-open-claude-code.md`)

### Cowork

- **Role:** Secondary plugin host. Same plugin, same skills.
- **Role per pipeline:** "strategy seat" — runs `discovery-intake`, `generate-sow`, `generate-functional-spec`, `generate-technical-spec`, `generate-test-plan`, `generate-build-prompt`, and `execute-tests` (per `dydx-delivery/skills/generate-build-prompt/references/when-to-open-claude-code.md` table)
- **Reasoning documented:** Cowork has connectors (Slack, calendar, email) and handles unstructured human input; Claude Code has filesystem + shell access.

### MCP (Model Context Protocol)

- **Mention:** `dydx-delivery/skills/generate-build-prompt/references/when-to-open-claude-code.md` line 79: "if you don't have an MCP that lets Claude Code hit the platform API → hand the prompt to the implementation partner instead"
- **No MCP servers defined in this repo.** No `.mcp.json`, no MCP configuration. MCP is referenced as a *consumer-side* mechanism the team may have set up separately.

## Target Platforms (referenced by plugin content)

These are the systems that downstream-generated artefacts target. The plugin does not embed clients for them — it contains naming, vocabulary, and contract templates.

### Pipefy

- **Type:** Workflow management platform (primary target platform)
- **API style:** GraphQL (per `dydx-delivery/skills/execute-tests/references/safety-rules.md` line 75: "Pipefy GraphQL")
- **Operations referenced:**
  - Refused (deletion-class): `deleteCard`, `deletePipe`, `deletePhase`, `deleteOrganization`, `deleteTable`, `deleteTableRecord`, `deleteWebhook` (`safety-rules.md` line 32)
  - Allowed: `create_*` / `POST`, `update_*` / `PATCH` / `PUT`, `read_*` / `GET`, `transition_*` / phase moves (`safety-rules.md` lines 53–58)
- **Constructs referenced in templates:** pipes, phases, fields, connections, databases, automations, start forms, scheduled automations (per `dydx-delivery/skills/generate-technical-spec/SKILL.md` line 60 and `dydx-delivery/skills/generate-technical-spec/references/technical-spec-template.md`)
- **Rate limit:** 100 req/min per token; runner buffers at 80; backs off on 429 (`safety-rules.md` line 75)
- **Tier dependencies flagged:** `Business` tier needed for scheduled automations, custom roles, API access (`technical-spec-template.md` lines 156–162)
- **Auth env-var convention (consumer side):** `PIPEFY_API_TOKEN`, `PIPEFY_TENANT_ID` (pattern `<PLATFORM>_API_TOKEN` / `<PLATFORM>_TENANT_ID` per `build-prompt-template.md` lines 109–110)
- **Platform skill referenced (not in this repo):** `platform-pipefy` — loaded dynamically based on `platform:` frontmatter (per `dydx-delivery/skills/generate-technical-spec/SKILL.md` line 32 and `execute-tests/SKILL.md` line 53)

### Wrike

- **Type:** Workflow management platform (alternate primary target platform)
- **API style:** REST (per `safety-rules.md` line 76: "Wrike REST")
- **Operations referenced:**
  - Refused: `DELETE /tasks/{id}`, `DELETE /folders/{id}`, `DELETE /workflows/{id}`, any `DELETE` HTTP verb (`safety-rules.md` line 33)
- **Constructs referenced in templates:** spaces, projects, custom item types, blueprints, request forms, workflows (`generate-technical-spec/SKILL.md` line 60, `generate-build-prompt/SKILL.md` line 40)
- **Rate limit:** 200 req/min per token; runner buffers at 160; backs off on 429 (`safety-rules.md` line 76)
- **Tier dependencies flagged:** `Pinnacle` referenced as a higher tier in tier-gating language (`generate-technical-spec/SKILL.md` line 88)
- **Auth env-var convention (consumer side):** `WRIKE_API_TOKEN`, `WRIKE_TENANT_ID`
- **Platform skill referenced (not in this repo):** `platform-wrike`

### Ziflow

- **Type:** Proofing / creative review tool (integration target, not primary platform)
- **API style:** REST (`POST /api/v2/projects` per `technical-spec-template.md` line 113)
- **Trigger pattern documented:** "Card enters `Approved` phase" → `POST /api/v2/projects` (`technical-spec-template.md` lines 112–119)
- **Auth pattern:** API key stored in "secrets store" (placeholder, `technical-spec-template.md` line 115)
- **Idempotency strategy:** `card_id` as `client_request_id`
- **Retry policy referenced:** 3x exponential backoff (1s, 2s, 4s)
- **Failure path referenced:** Log to support pipe, notify Ops via Slack `#ops-alerts`
- **Rate limit referenced:** 100 req/min per tenant; buffer at 80
- **Categorisation:** Listed as an "integration tool" in `discovery-intake/SKILL.md` line 92 — captured in artefact frontmatter under `integrations:` array

### Workato

- **Type:** Integration / iPaaS platform (integration target)
- **Construct referenced:** "Workato recipes" (`generate-build-prompt/SKILL.md` line 40)
- **Categorisation:** Listed as an "integration tool" in `discovery-intake/SKILL.md` line 92, captured in `integrations:` frontmatter

### Frontify

- **Mention:** `dydx-delivery/skills/discovery-intake/SKILL.md` line 92, listed alongside ziflow/workato/slack as a possible integration tool
- **No further detail in repo.**

### Slack

- **Type:** Messaging platform (notification target)
- **Usage referenced:**
  - Failure-path notifications: `#ops-alerts` (`technical-spec-template.md` line 119)
  - Test-execution constraint: only `#test-*` channels permitted in test runs (`safety-rules.md` line 41)
- **Categorisation:** Integration tool, captured in `integrations:` frontmatter

### Generic / "other"

- `discovery-intake/SKILL.md` line 90 explicitly allows `platform: other` — the plugin does not require pipefy or wrike specifically.
- `safety-rules.md` line 34 defines a generic deletion denylist: any operation containing `delete_`, `remove_`, or `destroy_`.

## Data Storage

- **Local artefact storage:** Filesystem only. Generated client artefacts live at `<Client>/build-specs/<platform>/` and `<Client>/testing/<feature>/` paths *outside this repo* (per `dydx-delivery/README.md` lines 76–94).
- **Test results storage:** Filesystem markdown files at `<Client>/testing/<feature>/results-YYYY-MM-DD_vN.md` (per `execute-tests/SKILL.md` line 17).
- **No databases.** No caching.

## Authentication & Identity

The plugin itself does no authentication. It documents auth contracts that downstream-generated builds must implement.

**Patterns referenced in skill content:**

- API tokens passed via env vars: `<PLATFORM>_API_TOKEN`, `<PLATFORM>_TENANT_ID` (`build-prompt-template.md` lines 109–110)
- Per-client `.env.example` referenced as the source for required env-var names (`build-prompt-template.md` line 120, `when-to-open-claude-code.md` line 88)
- "Secrets store" referenced abstractly (`technical-spec-template.md` line 115, `execute-tests/SKILL.md` line 13: "loaded from the client's secrets store or provided by user")
- **Hard rule:** "No credentials in code, configs, or commit messages — env vars only" (`generate-build-prompt/SKILL.md` line 80, `build-prompt-template.md` line 86)

## Monitoring & Observability

- **Audit trail:** Mandated for `execute-tests` runs. Format defined in `safety-rules.md` lines 64–72:
  ```
  [timestamp] TC-XXX | <PASS | FAIL | REFUSED:<reason> | ERROR:<class>>
    request:  <method> <url>
              <payload>
    response: <status>
              <body>
    notes:    <retry count, etc.>
  ```
- **Results templates:** `dydx-delivery/skills/execute-tests/references/results-template.md`
- **No external monitoring service** (Sentry, Datadog, etc.) integrated.

## CI/CD & Deployment

**Hosting:** GitHub (private repo at `https://github.com/SonofJay13/dydx-project-workflow`)

**CI Pipeline:** None. No `.github/workflows/`, no CI configuration files detected.

**Deployment:** Manual. Per repo `README.md` lines 47–58:
1. Bump `version` in `dydx-delivery/.claude-plugin/plugin.json`
2. Bump matching `version` in `.claude-plugin/marketplace.json`
3. Commit, push
4. Teammates pick up via `/plugin update`

**Branch state at audit:** working branch `dydx-delivery-v2`, main `main`, working tree clean.

## Environment Configuration

**Required env vars (in *this* repo):** None. The repo has no runtime.

**Required env vars (consumer-side, documented in skill templates):**
- `<PLATFORM>_API_TOKEN` — sandbox token (`build-prompt-template.md` line 110)
- `<PLATFORM>_TENANT_ID` — sandbox tenant (`build-prompt-template.md` line 110)
- Per-client repo `.env.example` referenced as the canonical list (`build-prompt-template.md` line 120, `when-to-open-claude-code.md` line 88)

**Secrets location:** Out-of-repo. References to "client's secrets store" (`execute-tests/SKILL.md` line 13) and the client's own `.env.example` files. No secrets in this repo.

## Webhooks & Callbacks

**Defined in this repo:** None.

**Referenced in skill templates (as patterns the build will implement):**
- Outgoing: Pipefy → Ziflow webhook on `Approved` phase entry (`technical-spec-template.md` lines 112–119, `build-prompt-template.md` line 53)
- Outgoing: Pipefy/Wrike → Slack `#ops-alerts` failure notifications

## Wiring Touchpoints — How Integrations Connect to the Pipeline

Integrations are wired into the pipeline through three frontmatter fields, set at `discovery-intake` and propagated through every downstream artefact:

1. **`platform:`** — single value (`pipefy`, `wrike`, `other`). Drives dynamic loading of `platform-<platform>` skill in:
   - `generate-technical-spec` (`generate-technical-spec/SKILL.md` line 30)
   - `generate-build-prompt` (`generate-build-prompt/SKILL.md` line 50)
   - `execute-tests` (`execute-tests/SKILL.md` line 53)

2. **`integrations:`** — list (`[ziflow, workato, frontify, slack, ...]`). Captured by `discovery-intake` (`discovery-intake/SKILL.md` lines 90–92), surfaced in technical spec section 6 "Integration contracts" with endpoint, trigger, auth, payload, retry, idempotency, rate-limit columns.

3. **`sandbox:`** (test-plan frontmatter only) — block of tenant identifiers. Used by `execute-tests` to build an allowlist; every API call is checked against it (`safety-rules.md` lines 11–17).

## Stage Pipeline Wiring

Pipeline is artefact-driven, not API-driven. Each skill reads the highest-version output of the previous skill from the filesystem:

```
discovery-intake          → 00_discovery_v{N}.md
   ↓
generate-sow              → 01_sow_v{N}.md          (reads 00_discovery)
   ↓
generate-functional-spec  → 02_functional-spec_v{N}.md  (reads 01_sow)
   ↓
generate-technical-spec   → 03_technical-spec_v{N}.md   (reads 02_functional-spec, loads platform-<platform>)
   ↓
generate-test-plan        → test-plan_v{N}.md           (reads 03_technical-spec)
   ↓
generate-build-prompt     → 04_build-prompt_v{N}.md     (reads 03_technical-spec, test-plan)
   ↓ (paste into Claude Code)
[build executes]          → 04_build-prompt_v{N}_report.md
   ↓
execute-tests             → results-YYYY-MM-DD_v{N}.md  (reads test-plan, loads platform-<platform>, hits sandbox API)
```

No skill auto-invokes the next. Human review is the gate at every stage (per `dydx-delivery/README.md` line 56–60).

---

*Integration audit: 2026-05-09*
