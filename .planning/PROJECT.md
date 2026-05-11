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

<!-- Shipped in v2.0 (design-only milestone — locked architecture; no skill edits). -->

- ✓ **AUDIT.md** — citation-grounded inventory of v0.3.0 plugin (8 AUDIT-XX requirements) — v2.0
- ✓ **DESIGN.md** — locked v2 architecture: cross-cutting structural decisions, 13-skill inventory, 3 internalised platform skills, every stage skill design, test bot architecture (30 DESIGN-XX requirements) — v2.0
- ✓ **CHANGELIST.md** — sequenced v0.3.0 → v2 delta with per-skill NEW/MODIFIED/RETIRED tagging + research-blocked phase flags + migration cutover rules (5 CHANGE-XX requirements) — v2.0
- ✓ **OPEN-QUESTIONS.md** — register of all deferred questions with owners + target phases (7 OPEN-XX requirements) — v2.0

<!-- Shipped in v2.1 (Foundations + Platform Skills) — see milestones/v2.1-ROADMAP.md -->

- ✓ Plugin-level canonical references (`safety-rules.md`, `stage-numbering.md`, `frontmatter-scheme.md`, `glossary.md`, `connector-matrix.md`) — v2.1
- ✓ 7 v0.3.0 skills repointed to canonical references (duplicates collapsed, sandbox-block bug fixed, `based_on_*` normalised) — v2.1
- ✓ File renumbering 00→02 / 01→03 / 02→04 / 03→05 / 04→07a — v2.1
- ✓ Plugin manifest 2.0.0 sync across `plugin.json` + `marketplace.json` — v2.1
- ✓ LICENSE file at repo root — v2.1
- ✓ Empty `commands/`, `agents/`, `hooks/` scaffold dirs — v2.1
- ✓ Connector probe + graceful-degradation matrix (Coda MCP / Google Workspace MCP / Miro MCP / Pipefy API / Wrike API / Ziflow API) — v2.1
- ✓ 5 cosmetic CONCERNS fixes (B.1 / B.2 / B.3 / B.4 / B.6); B.5 owner-email INTENTIONAL per UAT-3.1 — v2.1
- ✓ **platform-pipefy** skill — 5-file references/ shape + `paginate_all` helper + canonical `api.pipefy.com/graphql` endpoint + HTML-on-auth-failure detection + Q06.2 13 req/sec throttle — v2.1
- ✓ **platform-wrike** skill — 5-file references/ shape + OAuth `host` persistence pattern + 16 Copilot MCP tools matrix + Q07.2 320 req/min throttle — v2.1
- ✓ **platform-ziflow** skill — 5-file references/ shape + webhook-PRIMARY framing + `wait_for_proof` fallback (max_wait_s=30 / interval_s=2) + ReviewAI 4-row matrix + Q05 resolution — v2.1
- ✓ `tier_claims_last_verified: 2026-05-09` frontmatter on each platform skill — v2.1
- ✓ Per-platform `native_ai_path: paste|none` enum locked (T-06-02: zero `api` field assignments) — v2.1

### Active

<!-- v2.2 milestone scope — populated by REQUIREMENTS.md when /gsd-new-milestone runs. -->

**v2.2 (next):** Stage 1 Kickoff + Stage 4 Fnspec split (CHANGE-01 bundle 2 of N)

- [ ] **stage-1-kickoff** skill — the missing front-end stage between signed SOW and discovery-intake (kickoff agenda, RACI, comms cadence, first-week deliverables)
- [ ] **Stage 4 Fnspec split (DESIGN-20)** — break `generate-functional-spec` into 4a (platform-agnostic functional decomposition) and 4b (platform-routed delivery shape) per the DESIGN.md locked architecture
- [ ] **Delivery routing key + cross-spec consistency check** (DESIGN-20 sub-items)
- [ ] **TD-2 carry-forward from v2.1 audit** — reconcile stage-skill `platform:` enum (`pipefy|wrike|other`) with platform-ziflow routing claim; either add `ziflow` to enum or explicitly document Ziflow as integration-only (never primary platform routing key)

**Queued for later v2.x milestones (out of scope for v2.2):**

- v2.3-v2.6: Stages 5/6/7/8/9/10 build, per-client persistent test harness, documentation update, native-AI paste-bundle workflow (paste-only per UAT-6.1), sign-off + brain update + archive — per CHANGELIST.md CHANGE-01 phasing

### Out of Scope

| Exclusion | Reason |
|---|---|
| Replacing Cowork or Claude Code as the runtime | Out of scope per kickoff; runtime stays the same |
| Redesigning the per-client Brain pattern or workspace folder layout | Existing pattern is canonical; plugin adapts to it |
| Building net-new connectors (auth provider, custom MCPs) | Plugin uses connectors already wired in the workspace |
| Re-platforming existing clients off Pipefy/Wrike/Ziflow | Out of scope per kickoff |
| Two-way Coda sync (Coda → local brain merge) | Coda mirror is strictly one-way local→Coda; Field Notes table is read-only triage queue |
| Auto-progression between stages | Approval gates are non-negotiable; humans gate every stage |
| Skill edits during the v2.0 design phase | Kickoff prompt explicitly forbids skill edits in the design milestone (v2.0 shipped 2026-05-10; lock lifted at v2.1 start) |
| Native-AI API ingestion (Pipefy / Wrike / Ziflow) | UAT-6.1 locked through v2.6 — Stage 10 = paste bundle + upload audit log only |
| MCP adoption for Pipefy / Wrike | UAT-3.5 locked through v2.6 — API-first across all platform skills; re-evaluated post-first-real-client-engagement |

## Context

**Repository:** `dydx-project-workflow` — single-plugin marketplace. Plugin lives at `dydx-delivery/` at version **2.0.0** (synced across `plugin.json` + `marketplace.json`) with **10 skills total**: 7 stage skills (discovery-intake, generate-sow, generate-functional-spec, generate-technical-spec, generate-test-plan, generate-build-prompt, execute-tests) + 3 platform reference skills (platform-pipefy, platform-wrike, platform-ziflow) shipped in v2.1. Empty `commands/`, `agents/`, `hooks/` scaffold dirs exist. LICENSE in place.

**Pipeline today (post-v2.1):** Linear stage-gated flow — discovery → SOW → fnspec → techspec → test plan → build prompt → execute tests. Each stage reads the highest-version output from the prior stage. Stage skills load platform reference skills (platform-pipefy / platform-wrike) via `platform:` frontmatter enum; `ziflow` currently falls through `other` (TD-2 carryover to v2.2). Single fnspec / single tech spec (Stage 4 split lands in v2.2 per DESIGN-20).

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
| Brownfield v2.0 framing (not greenfield v1.0) | Existing v0.3.0 plugin is shipped reality; v2.0 captures the rebuild without rewriting history | ✓ Good — v2.0 design-locked architecture shipped without rewriting v0.3.0 history |
| Platform skills move inside `dydx-delivery` plugin | Platforms are first-class to delivery; living outside causes broken-reference drift today | ✓ Good — platform-{pipefy,wrike,ziflow} shipped in v2.1 with 5-file references/ shape |
| Coda becomes a hard dependency | Required for scope/costing tasks AND brain mirror; no fallback without Coda | — Pending (lands in v2.4+ when Stage 6 cost + Stage 11 archive consume Coda) |
| Local brain canonical, Coda mirror published one-way | Two-way sync invites merge conflicts; Field Notes stays a triage queue, never auto-merged | — Pending (lands in v2.5+ with Stage 11 brain-update workflow) |
| Test harness per client, persistent, hybrid Python+AI | Deterministic state checks + AI judgement is the only way to get reliable end-to-end coverage across heterogeneous platforms | — Pending (lands in v2.5 Stage 8 test-bot rebuild) |
| Reset phase numbering at 1 for v2.0 | No prior milestone phases archived; clean numbering avoids confusion with file-prefix stage numbers | ✓ Good — Phases 1-4 (v2.0) + Phases 5-6 (v2.1); no collision with file-prefix stage numbers |
| Run-domain research before defining requirements | Hybrid Python+AI test harness, Coda schema patterns, native-AI ingestion paths, and integration pitfalls warrant grounded inputs | ✓ Good — research outputs in .planning/research/ informed CHANGELIST sequencing |
| v2.0 milestone is design-only — no skill edits | Kickoff explicitly mandates audit + design lock before build; prevents premature skill churn | ✓ Good — design-lock held through Phase 4; first skill edits landed in Phase 5 (v2.1) as planned |
| Per-platform slicing of Phase 6 (D-63) — Pipefy/Wrike/Ziflow each as one atomic plan | Reviewer grades a whole platform at a time; mixing platforms across plans causes review-context loss | ✓ Good — 06-01/02/03 shipped as atomic platforms; parallel Wave 2 execution worked |
| Webhook-PRIMARY framing for Ziflow read-after-create (Q05) | Vendor explicitly recommends webhooks over polling; wait_for_proof is fallback only | ✓ Good — landed in platform-ziflow/api-contract.md with 30s/2s polling defaults |
| `tier_claims_last_verified:` per-platform date (MOD-7, D-68) | Connector capability claims rot fast; per-platform date gives a re-verification trigger | ✓ Good — 2026-05-09 baseline applied to all 3 platform SKILL.md frontmatter |
| Vocabulary dedup gate (D-66) — project-wide glossary terms ONLY in glossary.md | Platform-specific vocabularies must not redefine project-wide terms | ✓ Good — D-66 grep gate green at v2.1 close; zero cross-platform redefinitions |

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

## Current State: v2.1 Shipped (2026-05-11)

**Last shipped:** v2.1 Foundations + Platform Skills — 2 phases (Phase 5 Foundations + Connector Verification; Phase 6 Internalise Platform Skills), 9 plans, 19 requirements (13 FOUND + 6 PLAT) all satisfied. Full archive: `.planning/milestones/v2.1-ROADMAP.md` + `v2.1-REQUIREMENTS.md` + `v2.1-MILESTONE-AUDIT.md`.

**Plugin v2.0.0 surface today:**
- 7 stage skills + 3 platform reference skills under `dydx-delivery/skills/`
- 4 plugin-level canonical references + connector-matrix at `dydx-delivery/references/`
- Manifest 2.0.0 synced across plugin.json + marketplace.json
- LICENSE in place; empty commands/agents/hooks/ scaffold dirs

**Carry-forward into v2.2 (from v2.1 audit):**
- **TD-2:** Stage-skill `platform:` enum reconciliation with platform-ziflow routing key
- All 11 OPEN-Q rows owned by v2.1 are `Status: decided`; remaining OPEN-Q items belong to later phases

## Next Milestone Goals: v2.2 Stage 1 Kickoff + Stage 4 Fnspec Split

**Goal:** CHANGE-01 bundle 2 of N — land the missing Stage 1 Kickoff skill and split `generate-functional-spec` into 4a (platform-agnostic) + 4b (platform-routed) per DESIGN-20.

**Likely Phase breakdown** (verify against CHANGELIST.md when `/gsd-new-milestone` runs):
- Phase 7: `stage-1-kickoff` skill — kickoff agenda, RACI, comms cadence, first-week deliverables; feeds discovery-intake
- Phase 8: Stage 4 Fnspec split (DESIGN-20) — 4a/4b artefact shape, delivery routing key, cross-spec consistency check
- Phase 8 inline: TD-2 reconciliation (stage-skill `platform:` enum vs platform-ziflow routing claim)

**Scope locks carried forward from v2.0/v2.1 (do not re-litigate):**
- UAT-3.5 — MCPs OUT-OF-SCOPE through v2.6 (API-first across all platforms)
- UAT-6.1 — Native-AI ingestion APIs OUT-OF-SCOPE entirely (paste-only)
- UAT-4.1 — Pipefy API host canonical-only; web_host + org_id vary per tenant
- UAT-4.2 — Pipefy auth-concurrency exclusive; Stage 8 test bot tier-1 serializes per-tenant
- UAT-3.1 — Private email `jasonmichaelb@gmail.com` on plugin manifests is INTENTIONAL (dYdX-approved)
- D-65 — Client-shape-gotchas use VodafoneZiggo + Up & Up Group; other clients TBD-at-first-engagement
- D-67 — Each phase resolves its own OPEN-Q rows inline; synthesis plans flip the OPEN-QUESTIONS register

<details>
<summary>Archived v2.1 milestone scope (Phases 5-6) — shipped 2026-05-11</summary>

**Phase 5 — Foundations + Connector Verification (FOUND-01..FOUND-13):**
- Plugin-level canonical references at `dydx-delivery/references/{safety-rules.md, stage-numbering.md, frontmatter-scheme.md, glossary.md}`
- 7 v0.3.0 skills repointed to canonical references (4 hard-rules duplicates collapsed per AUDIT-05.1; sandbox-block bug fixed; `based_on_*` normalised)
- File renumbering 00→02 / 01→03 / 02→04 / 03→05 / 04→07a per FOUND-03
- Plugin manifest 2.0.0 synced (`plugin.json` + `marketplace.json`)
- LICENSE file at repo root per OPEN-Q23
- Empty `commands/`, `agents/`, `hooks/` scaffold dirs
- `connector-matrix.md` — Coda MCP / Google Workspace MCP / Miro MCP / Pipefy API / Wrike API / Ziflow API probe baseline 2026-05-09
- 5 cosmetic CONCERNS fixes per AUDIT-07 (B.1 / B.2 / B.3 / B.4 / B.6); B.5 owner-email INTENTIONAL per UAT-3.1

**Phase 6 — Internalise Platform Skills (PLAT-01..PLAT-06):**
- `platform-pipefy/` — 5-file references/ shape, `paginate_all` helper, `api.pipefy.com/graphql` canonical, HTML-on-auth detection, Q06.2 13 req/sec throttle
- `platform-wrike/` — 5-file references/ shape, OAuth host persistence, 16 Copilot MCP tools matrix, Q07.2 320 req/min throttle
- `platform-ziflow/` — 5-file references/ shape, webhook-PRIMARY framing, `wait_for_proof` fallback (30s/2s defaults), 4-row ReviewAI matrix, Q05 resolution, `ZiflowRateLimitExceeded` 429 class
- `tier_claims_last_verified: 2026-05-09` baseline on all 3 SKILL.md
- `native_ai_path: paste|none` enum locked (T-06-02: zero `api` field assignments)
- D-66 vocabulary dedup gate green
- 3 OPEN-Q row flips (Q05/Q06.2/Q07.2 proposed → decided)

</details>

---
*Last updated: 2026-05-11 after v2.1 milestone close*
