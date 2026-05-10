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

<!-- v2.1 "Foundations + Platform Skills" milestone scope — populated by REQUIREMENTS.md.
     Wider v2.x roadmap (Stages 0/3/4/5/6/7/8/9/10 build, native-AI, archive) is queued
     for v2.2-v2.6 per CHANGELIST.md CHANGE-01. See REQUIREMENTS.md for current v2.1 REQ-IDs. -->

**v2.1 (current):** Foundations + Platform Skills

- [ ] Plugin-level canonical references (`safety-rules.md`, `stage-numbering.md`, `frontmatter-scheme.md`, `glossary.md`)
- [ ] 7 v0.3.0 skills updated to point at canonical references (collapses duplicates, fixes sandbox-block bug, normalises `based_on_*`)
- [ ] File renumbering 00→02 / 01→03 / 02→04 / 03→05 / 04→07a (FOUND-03)
- [ ] Plugin manifest 2.0.0 sync (`plugin.json` + `marketplace.json`)
- [ ] LICENSE file at repo root (two-line boilerplate per OPEN-Q23)
- [ ] Empty `commands/`, `agents/`, `hooks/` scaffold dirs
- [ ] Connector probe + graceful-degradation matrix (Coda MCP / Google Workspace MCP / Miro MCP / Pipefy API / Wrike API / Ziflow API)
- [ ] 5 active cosmetic CONCERNS fixes (B.1 / B.2 / B.3 / B.4 / B.6) — B.5 owner-email = INTENTIONAL (no fix)
- [ ] `skills/platform-pipefy/` with 5-file `references/` shape + `paginate_all` helper + DESIGN-14-revised canonical API endpoint + HTML-on-auth-failure gotcha
- [ ] `skills/platform-wrike/` with 5-file `references/` shape + OAuth `host` persistence (MOD-5)
- [ ] `skills/platform-ziflow/` with 5-file `references/` shape + `wait_for_proof` helper (MOD-6)
- [ ] `tier_claims_last_verified:` frontmatter on each platform skill (MOD-7)
- [ ] Per-platform `native_ai_path:` flag enum = `paste | none` (UAT-6.1)

**Queued for later v2.x milestones (out of scope for v2.1):**

- v2.2-v2.6: Stages 0/3/4/5/6/7/8/9/10 build, per-client persistent test harness, documentation update, native-AI enablement (paste-only per UAT-6.1), sign-off + brain update + archive — per CHANGELIST.md CHANGE-01 phasing

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

## Current Milestone: v2.1 Foundations + Platform Skills

**Goal:** First build milestone after v2.0 design-lock — land canonical-references foundation + 3 internalised platform skills (Pipefy/Wrike/Ziflow) per CHANGELIST CHANGE-01, resolving all v0.3.0 BLOCKING bugs from AUDIT.md and codifying the connector probe + graceful-degradation matrix. Apply v2.0 DESIGN contracts + UAT decisions verbatim — do not re-derive scope.

**Target features (Phase 5 — Foundations + Connector Verification):**
- Plugin-level canonical references at `dydx-delivery/references/{safety-rules.md, stage-numbering.md, frontmatter-scheme.md, glossary.md}` (single source of truth)
- 7 existing v0.3.0 skills updated to point at canonical references (collapses 4 hard-rules duplicates per AUDIT-05.1; fixes sandbox-block bug; normalises `based_on_*` field names)
- File renumbering 00→02 / 01→03 / 02→04 / 03→05 / 04→07a per FOUND-03
- Plugin manifest 2.0.0 synced across `plugin.json` + `marketplace.json` (metadata + `plugins[0]`)
- LICENSE file at repo root per OPEN-Q23 (two-line "All rights reserved.\nNot licensed for redistribution.")
- Empty `commands/`, `agents/`, `hooks/` scaffold directories
- Connector probe + graceful-degradation matrix (Coda MCP / Google Workspace MCP / Miro MCP / Pipefy API / Wrike API / Ziflow API)
- 5 active cosmetic CONCERNS fixes per AUDIT-07 (B.1 README truncation / B.2 "test sheet" wording / B.3 pipeline-step count → 13 / B.4 LICENSE created / B.6 homepage asymmetry). **B.5 owner-email is INTENTIONAL** (dYdX-approved private email per UAT-3.1; not a defect)

**Target features (Phase 6 — Internalise Platform Skills):**
- `skills/platform-pipefy/` + 5-file `references/` shape (`api-contract.md` / `native-ai-inventory.md` / `knowledge-ingestion.md` / `client-shape-gotchas.md` / `vocabulary.md`); `paginate_all` helper (avoids MOD-4); **DESIGN-14 REVISED:** `api.pipefy.com/graphql` canonical-only for ALL tenants (Q24 verified 2026-05-10 via DNS test); `web_host` + `org_id` vary per tenant; **HTML-on-auth-failure gotcha** documented in `api-contract.md` (Pipefy returns Keycloak login HTML, NOT JSON 401, on auth fail)
- `skills/platform-wrike/` same shape; persists `host` from OAuth token response (NEVER hardcode `www.wrike.com` per MOD-5)
- `skills/platform-ziflow/` same shape; `wait_for_proof` helper for read-after-create eventual consistency (MOD-6); 30s poll / 2s interval default
- `tier_claims_last_verified:` frontmatter on each platform skill (MOD-7)
- Per-platform `native_ai_path:` flag enum = `paste | none` ONLY (UAT-6.1 removed `api` branch — native-AI ingestion is OUT OF SCOPE entirely)

**Key context:** v2.0 design-only mandate ENDS at v2.1 start — skill edits are now permitted. Phase 5 canonical references land BEFORE Phase 6 platform skills point at them (intra-milestone ordering). Phase numbering continues from v2.0 (Phase 5 = Foundations; Phase 6 = Platform Skills).

**Active OPEN-QUESTIONS to resolve during v2.1 (11 rows):**
- *Phase 5 (8):* Q06.1 Pipefy 2026 rate-limits · Q07.1 Wrike 2026 rate-limits · Q09 Claude in Chrome canonical naming · Q10 Coda MCP wired+pin · Q11 Google Workspace MCP server choice (taylorwilsdon vs alternatives) · Q12 Miro MCP wired vs paste-only · Q13 Wrike host source-of-truth across multi-tenant deployments · Q25 Wrike+Ziflow auth-concurrency class verification
- *Phase 6 (3):* Q05 Ziflow read-after-create consistency window · Q06.2 Pipefy throttle calibration (depends on Q06.1) · Q07.2 Wrike throttle calibration (depends on Q07.1)

**Decisions inherited from v2.0 UAT (LOCKED — do not re-litigate):**
- Q15 — opt-in per CR; v2 readers permanently lenient on v0.3.0 frontmatter; no calendar trigger
- Q16 — re-run status-lifecycle survey at Phase 5 kickoff to confirm no drift since 2026-05-10 sample
- Q17 — per-client brain Coda docs ARE the canonical tracker; Up & Up Group + VodafoneZiggo are the 2 established clients (URLs in OPEN-QUESTIONS Q17); other clients TBD bootstrapped at first Stage 11 archive
- Q21 — single parameterised `commands/refine.md` taking skill name as `$1`
- Q21.1 — `/dydx-refine-*` plugin-prefixed namespace
- Q23 — LICENSE = "All rights reserved.\nNot licensed for redistribution." (two-line boilerplate)
- Q24 — Pipefy API canonical-only; DESIGN-29 simplified (no `api_host` field; `web_host` + `org_id` retained)

**Scope locks (LOCKED — do not re-open in v2.1):**
- **UAT-3.5 — MCPs OUT-OF-SCOPE through v2.6.** API-first across all platform skills. Pipedream Pipefy MCP (`mcp.pipedream.net/v2`) and Wrike MCP (`https://developers.wrike.com/docs/setup-claude-with-wrike-mcp`) are parked references — adoption re-evaluated as a post-v2.6 milestone gated on first-real-client-engagement-practice-run. Ziflow has no MCP.
- **UAT-6.1 — Native-AI ingestion APIs OUT-OF-SCOPE entirely.** OPEN-Q01/Q02/Q03 are status=closed. Stage 10 = paste bundle + upload audit log only. The tool produces correctly-shaped upload instructions; humans manually upload via each platform's UI.
- **UAT-4.1 — Pipefy host persistence simplified.** API host canonical-only; only `web_host` + `org_id` vary per tenant.
- **UAT-4.2 — Pipefy auth-concurrency = exclusive.** Stage 8 test bot tier-1 must serialize per-tenant ops + emit `auth_switch_required` retry signal.
- **AUDIT-07 §7.5 owner-email = INTENTIONAL** (UAT-3.1 — dYdX-approved private email; not a defect; do NOT change to org domain).

**Success definition:** All v0.3.0 BLOCKING bugs from AUDIT.md resolved + 3 new platform skills shipped + connector probe matrix codified.

---
*Last updated: 2026-05-10 after milestone v2.1 kickoff*
