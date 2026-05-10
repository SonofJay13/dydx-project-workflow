# dYdX Delivery Plugin

## What This Is

A Claude Code plugin that owns the full client delivery lifecycle for dYdX Digital — kickoff, discovery, scope, cost, build, test, document, native-AI enablement, and archive. Skills run inside Cowork (strategy seat) and Claude Code (build seat), producing versioned, human-reviewed artefacts at every stage. Platforms (Pipefy, Wrike, Ziflow) are first-class skills inside the plugin, not external references.

## Core Value

The plugin behaves as a senior implementation partner end-to-end: every stage produces an artefact polished enough to send to a client or hand to a developer without rework, and every change request leaves the client's brain, documentation, and native-AI knowledge bases coherent and up to date.

## Requirements

### Validated

<!-- Shipped in v0.3.0 (`dydx-delivery` plugin, marketplace `dydx-digital@1.2.0`).
     Inherited baseline — no GSD milestone retroactively claims these. -->

- ✓ **discovery-intake** skill — captures system, users, triggers, data, rules, integrations, exceptions, failure points (v0.3.0)
- ✓ **generate-sow** skill — drafts a stage-2 scope of work from approved discovery (v0.3.0)
- ✓ **generate-functional-spec** skill — single fnspec per project, platform-tagged via `platform:` frontmatter (v0.3.0)
- ✓ **generate-technical-spec** skill — translates fnspec into platform constructs (v0.3.0)
- ✓ **generate-test-plan** skill — produces table-format test plan against sandbox tenant (v0.3.0)
- ✓ **generate-build-prompt** skill — emits Claude-Code-ready build prompt for developers (v0.3.0)
- ✓ **execute-tests** skill — runs the approved test plan, enforces sandbox-only safety rules (v0.3.0)
- ✓ Stage-gated artefact pipeline — every stage human-reviewed, no auto-progression (v0.3.0)
- ✓ Versioned artefacts — Option B `_v{N}.md` filenames, frontmatter `version`, `status` (v0.3.0)
- ✓ Sandbox safety rules — read-write only against named sandbox tenants, no destructive integrations outside scope (v0.3.0)

### Active

<!-- v2.0 "Implementor Edition" milestone scope — populated by REQUIREMENTS.md. -->

See `REQUIREMENTS.md` for full v2.0 scope. High-level:

- [ ] Stage 0 kickoff capture (NEW) — Miro/notes/feedback ingest, branches into discovery or draft SOW
- [ ] Stage 1 discovery intake (tweaked to consume kickoff artefact)
- [ ] Stage 2 SOW (carry forward, structurally unchanged)
- [ ] Stage 3 functional specs SPLIT — Platform fnspec + Integration fnspec, native-AI vs API tagging
- [ ] Stage 4 technical spec gated to integration work + lightweight platform-API addendum
- [ ] Stage 5 scoping & costing in Coda (NEW) — per-assignee tasks with risk-adjusted hours, client-facing cost estimate
- [ ] Stage 6 dual build prompts — dev prompt (existing) + non-dev implementation prompt (NEW)
- [ ] Stage 7 per-client persistent test harness (EVOLVED) — hybrid Python+AI orchestrator, sandbox-only
- [ ] Stage 8 documentation update (NEW) — Drive-linked, diff-reviewed, schema-versioned
- [ ] Stage 9 native AI enablement (NEW) — direct API ingestion or copy-paste fallback per platform
- [ ] Stage 10 sign-off, brain update, archive (NEW) — local-canonical brain → Coda mirror, Field Notes triage at next kickoff
- [ ] Platform skills inside the plugin — `platform-pipefy`, `platform-wrike`, `platform-ziflow`
- [ ] Plugin v2 design audit — current-plugin audit, v2 design doc, change list, open questions (v2.0 deliverable)

### Out of Scope

| Exclusion | Reason |
|---|---|
| Replacing Cowork or Claude Code as the runtime | Out of scope per kickoff; runtime stays the same |
| Redesigning the per-client Brain pattern or workspace folder layout | Existing pattern is canonical; plugin adapts to it |
| Building net-new connectors (auth provider, custom MCPs) | Plugin uses connectors already wired in the workspace |
| Re-platforming existing clients off Pipefy/Wrike/Ziflow | Out of scope per kickoff |
| Two-way Coda sync (Coda → local brain merge) | Coda mirror is strictly one-way local→Coda; Field Notes table is read-only triage queue |
| Auto-progression between stages | Approval gates are non-negotiable; humans gate every stage |
| Skill edits during the v2.0 design phase | Kickoff prompt explicitly forbids skill edits in the design milestone |

## Context

**Repository:** `dydx-project-workflow` — single-plugin marketplace at `dydx-digital@1.2.0`. Plugin lives at `dydx-delivery/` with 7 markdown-only skills. No `commands/`, `agents/`, or `hooks/` directories yet.

**Pipeline today (v0.3.0):** Linear five-stage artefact-driven flow — discovery → SOW → fnspec → techspec → test plan → build prompt → execute tests. Each stage reads the highest-version output from the prior stage. Single fnspec, single tech spec. Platform-pipefy / platform-wrike skills are *referenced* but not present in the repo; they ship under `anthropic-skills` separately and need to move inside this plugin in v2.

**v2 ambition:** Plugin becomes a senior implementation partner that owns ten lifecycle stages (kickoff → discovery → SOW → split fnspec → tech spec → cost → dual build prompts → test → docs → native-AI enablement → archive). Each client gets a persistent test harness that lives in the client Brain and updates each ship.

**Client workspace shape:** Each client has a `<Client> Brain/` (canonical, local) and a `ChangeRequests/` folder. Active CRs live at `ChangeRequests/YYYY-MM_ProjectName/`; completed ones move to `ChangeRequests/Archive/`. Documentation publishes to Google Drive; brain publishes one-way to Coda. Each client's `00_HUB.md` carries a canonical `Documentation:` link to the Drive root.

**Connectors expected to be wired:** Miro MCP, Coda MCP, Google Drive MCP, Gmail MCP, Calendar MCP, Claude in Chrome. Connector availability **must be verified** during the v2.0 design phase before any skill assumes them.

**Concerns inventory:** `.planning/codebase/CONCERNS.md` (audit dated 2026-05-09) catalogues version-string mismatches, missing skills referenced in docs, frontmatter inconsistencies, duplicated hard-rules content across four files, two-scheme stage numbering, missing `commands/agents/hooks` scaffold, and unimplemented `/refine-<skill>` slash commands. v2 must resolve the structural items; cosmetic items get fixed during build.

**Testing reality today:** "Testing" means running an approved test plan against a client sandbox tenant via the `execute-tests` skill. Hard rules at `dydx-delivery/skills/execute-tests/references/safety-rules.md`. There is no traditional automated test suite for the plugin itself, no CI, no test runner — and the v2.0 design must decide whether build-time self-tests are needed for the plugin's own correctness.

## Constraints

- **Runtime:** Claude Code + Cowork — fixed; not changing
- **Languages:** Markdown for all skills/templates/references; YAML for frontmatter; JSON for manifests; Python only inside the per-client test harness
- **Frontmatter:** Single canonical scheme across all artefacts (status lifecycle, `based_on_*` field naming, platform-gated identifiers); v2 must lock this
- **Stage numbering:** Single canonical scheme across files, frontmatter, and skill bodies (resolves the v0.3.0 file-prefix vs Stage-N conflict)
- **Hard rules location:** Single source of truth (likely `references/safety-rules.md`); every other surface references it instead of duplicating
- **Approval gates:** No auto-progression between stages; humans approve every artefact before the next stage runs
- **Brain canonicality:** Local `<Client> Brain/` is canonical; Coda is a one-way published mirror; Field Notes table on Coda is read-only input queue
- **Doc canonicality:** Working `.md` drafts inside `ChangeRequests/<CR>/` locally; Google Docs/Slides in client Drive folder are published source of truth; doc updates only after diff review
- **Hub link contract:** Doc-update stage halts if `<Client> Brain/00_HUB.md` is missing the `Documentation:` Drive link; rest of pipeline still runs
- **Sandbox-only test execution:** Read-write only against sandbox tenants; refuses destructive actions; safety rules carry forward from v0.3.0 `execute-tests`
- **Test harness architecture:** Deterministic Python harness for state/integration assertions, AI orchestrator on top for judgement calls; one harness per client, persistent, lives in `<Client> Brain/`
- **Plugin licence:** `Proprietary` per `plugin.json`; no LICENSE file currently

## Key Decisions

| Decision | Rationale | Outcome |
|---|---|---|
| Brownfield v2.0 framing (not greenfield v1.0) | Existing v0.3.0 plugin is shipped reality; v2.0 captures the rebuild without rewriting history | — Pending |
| Platform skills move inside `dydx-delivery` plugin | Platforms are first-class to delivery; living outside causes broken-reference drift today | — Pending |
| Coda becomes a hard dependency | Required for scope/costing tasks AND brain mirror; no fallback without Coda | — Pending |
| Local brain canonical, Coda mirror published one-way | Two-way sync invites merge conflicts; Field Notes stays a triage queue, never auto-merged | — Pending |
| Test harness per client, persistent, hybrid Python+AI | Deterministic state checks + AI judgement is the only way to get reliable end-to-end coverage across heterogeneous platforms | — Pending |
| Reset phase numbering at 1 for v2.0 | No prior milestone phases archived; clean numbering avoids confusion with file-prefix stage numbers | — Pending |
| Run-domain research before defining requirements | Hybrid Python+AI test harness, Coda schema patterns, native-AI ingestion paths, and integration pitfalls warrant grounded inputs | — Pending |
| v2.0 milestone is design-only — no skill edits | Kickoff explicitly mandates audit + design lock before build; prevents premature skill churn | — Pending |

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via `/gsd-transition`):
1. Requirements invalidated? → Move to Out of Scope with reason
2. Requirements validated? → Move to Validated with phase reference
3. New requirements emerged? → Add to Active
4. Decisions to log? → Add to Key Decisions
5. "What This Is" still accurate? → Update if drifted

**After each milestone** (via `/gsd-complete-milestone`):
1. Full review of all sections
2. Core Value check — still the right priority?
3. Audit Out of Scope — reasons still valid?
4. Update Context with current state

## Current Milestone: v2.0 Implementor Edition

**Goal:** Lock the audit and v2 design for the dydx-delivery plugin so the rebuild can execute without rework — covering all ten lifecycle stages, internalised platform skills, Coda integration, the per-client persistent test harness, and resolved structural decisions (frontmatter, stage numbering, source-of-truth for hard rules, plugin surfaces, refine pattern).

**Target features:**
- Stage 0 kickoff capture skill (Miro/notes/feedback ingest, dual artefact branching)
- Stage 1 discovery intake refactor (consumes kickoff artefact)
- Stage 3 functional spec split (Platform fnspec + Integration fnspec, native-AI vs API tagging)
- Stage 4 tech spec scope gate (integration-required + platform-API addendum)
- Stage 5 Coda scoping & costing (per-assignee tasks, risk-adjusted hours, client cost estimate)
- Stage 6 implementation prompt (non-dev companion to dev build prompt)
- Stage 7 per-client persistent hybrid test harness (Python + AI orchestrator)
- Stage 8 documentation update with Drive publishing + diff review
- Stage 9 native-AI enablement (direct API or copy-paste fallback)
- Stage 10 sign-off, brain update, archive (local→Coda mirror, Field Notes triage at next kickoff)
- Internalised platform skills (`platform-pipefy`, `platform-wrike`, `platform-ziflow`)
- Resolved frontmatter scheme, stage numbering, single-SoT for hard rules, plugin surface decisions, refine-pattern decision
- Plugin v2 audit doc + v2 design doc + change list + open-questions register

**Key context:** Session is design-only. No skill edits during this milestone. Audit and design must be locked before any v2 build phase begins. Connector availability (Miro, Coda, Drive, Gmail, Calendar, Claude in Chrome) must be verified — design fails gracefully if connectors are missing.

**Scope locks set during UAT (2026-05-10):**
- **MCPs for Pipefy/Wrike out-of-scope through v2.6** (UAT-3.5). API-first across all platform skills; MCPs (Pipedream Pipefy MCP at `mcp.pipedream.net/v2`; Wrike MCP at `https://developers.wrike.com/docs/setup-claude-with-wrike-mcp`) are parked references — adoption evaluated as a separate milestone post-first-real-client-engagement-practice-run. Ziflow has no MCP (locked direct-API).
- **Native-AI ingestion APIs out-of-scope entirely** (UAT-6.1). Stage 10 simplified to "paste bundle + upload audit log" producing structured upload instructions for humans to execute manually via each platform's UI. NO API ingestion attempts. Q01/Q02/Q03 (Pipefy AI KB / Wrike AI Studio / Ziflow ReviewAI knowledge-ingestion APIs) → withdrawn under UAT-6.1.

---
*Last updated: 2026-05-09 after milestone v2.0 kickoff*
