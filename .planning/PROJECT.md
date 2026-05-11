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

<!-- Shipped in v2.2 (Stage 1 Kickoff + Stage 4 Fnspec Split) — see milestones/v2.2-ROADMAP.md -->

- ✓ **kickoff-capture** skill (Stage 1, NEW) — SKILL.md + 3 references/ files (kickoff-template.md / auto-classify-rubric.md / capture-paths.md); 3 capture paths (meeting-notes paste / Miro paste fallback / Field Notes Coda read with `processed_at IS NULL` triage default); `01_kickoff_v<N>.md` artefact with single-field `kickoff_branch: discovery-ready | draft-sow` routing + `platform: pipefy | wrike | ziflow | other` 4-enum — v2.2
- ✓ **discovery-intake** MODIFIED — consumes `01_kickoff_v*` as sole upstream (`based_on_kickoff:` MANDATORY); raw-notes entry path RETIRED per STG2-01; verbatim skip-emit on `draft-sow` branch — v2.2
- ✓ **generate-sow** MODIFIED — canonical 4-state lifecycle `draft → client_review → approved → archived` per DESIGN-08 / AUDIT-01.2; single-SOW dual-scope H2 split (Platform + Integration sections per D-75) — v2.2
- ✓ **generate-fnspec-platform** skill (Stage 4a, NEW) — SKILL.md + 3 references/ files (fnspec-platform-template.md / auto-classify-rubric.md / addendum-template.md); reads approved discovery + approved SOW + per-platform `native-ai-inventory.md`; emits `04a_fnspec-platform_v<N>.md` with `delivery: native-ai | api` routing key on every requirement row — v2.2
- ✓ **generate-fnspec-integration** skill (Stage 4b, NEW) — SKILL.md + 3 references/ files (fnspec-integration-template.md / consistency-rules.md / either-spec-skip-paths.md); reads approved discovery + approved SOW + Stage 4a output; OWNS cross-spec consistency check (D-84 three checks; runs FIRST before fnspec write; halt-on-failure emits `04b_consistency_check_v<N>.md`) — v2.2
- ✓ v0.3.0 **generate-functional-spec** RETIRED — directory removed; templates / READMEs / changelogs repointed to 4a + 4b; legacy `_v*.md` artefacts remain readable per DESIGN-08 lenient mode — v2.2
- ✓ `delivery: native-ai | api` canonical enum order LOCKED — anti-pattern scan returns 0 matches of reversed `api | native-ai` across all `dydx-delivery/` skills — v2.2
- ✓ Stage 5 scope-gate forward-compat per DESIGN-21 — 3 branches (full / skip-with-addendum / skip-entirely) resolve cleanly from 4a/4b frontmatter alone (`has_platform_api_addendum:` + `tech_spec_scope:` + `## Platform-API Addendum` H2); actual Stage 5 consumption ships v2.3 — v2.2
- ✓ TD-2 from v2.1 audit CLOSED — D-78 path-(a) selected: `ziflow` ADDED to stage-skill `platform:` 4-enum (`pipefy | wrike | ziflow | other`) across 10 files / 11 lines; `platform-ziflow/SKILL.md:14` aligned; DESIGN-20 D-78 sub-decision + glossary routing-key entry landed — v2.2
- ✓ Forward-compat smoke check passes — 3 fixture-output artefacts prove `delivery:` field survives at canonical position through `based_on_*` chain to Stage 5/6/7b/10 consumer stubs — v2.2
- ✓ R-02 / R-01 glossary alignment — DESIGN.md `kickoff_branch` entry aligned to authoritative `discovery-ready` / `draft-sow`; `dydx-delivery/references/glossary.md` lines 47+66 cleaned of legacy `discovery-via` / `kickoff-direct` spellings — v2.2

### Active

<!-- v2.3 milestone scope — populated by REQUIREMENTS.md when /gsd-new-milestone runs. -->

**v2.3 (next):** Stage 5 Tech Spec + Stage 6 Cost + Stage 7 Build Prompts (CHANGE-01 bundle 3 of N per CHANGELIST.md Phase 4)

- [ ] **generate-technical-spec** MODIFIED — scope-gated to Stage 4b existence; consumes the v2.2 forward-compat frontmatter (`has_platform_api_addendum:` + `tech_spec_scope:`); never hand-waves error paths (per DESIGN-21 / STG5-01)
- [ ] **generate-cost-estimate** skill NEW — Stage 6 Coda integration (read schema → upsert via `keyColumns` → poll `mutationStatus`); rate-limit 4 req/10s (80% of 5/10s ceiling); closed risk-multiplier taxonomy with mandatory `rationale` per row (per DESIGN-22 / STG6-01)
- [ ] **commercial-inputs gate** — wait-for-commercial-inputs gate before client-facing cost summary (`commercial_inputs_status: provided` gate per STG6-02)
- [ ] **generate-build-prompt** MODIFIED — Stage 7a dev prompt; pulls `delivery: api` rows from 4a/4b (per DESIGN-23 / STG7-01)
- [ ] **generate-implementation-prompt** skill NEW — Stage 7b per-platform implementation prompt (Pipefy Behaviors + KB upload list; Wrike Copilot workflow narrative; Ziflow ReviewAI checklists — NOT a universal template; per DESIGN-23 / STG7-02)

**Queued for later v2.x milestones (out of scope for v2.3):**

- v2.4: Stage 8 Test Bot Rebuild — `provision-test-harness/` NEW (Stage 8a) + `generate-test-plan/` MODIFIED (Stage 8b) + `generate-uat-plan/` NEW (Stage 8c) + `execute-tests/` MODIFIED (Stage 8d) + `agents/test-bot-orchestrator/` NEW + `client_state.yaml` schema + drift detection (per DESIGN-24/28/29/30)
- v2.5: Stage 9 Documentation Publishing (per DESIGN-25) + Stage 10 Native-AI Upload Bundle paste-only (per DESIGN-26 / UAT-6.1)
- v2.6: Stage 11 Sign-off + Coda Mirror (per DESIGN-27) + Plugin Surfaces — `commands/refine.md` parameterised + 4 GSD-prefixed shortcuts + frontmatter / version-bump / approval-gate hooks + optional `mcpServers` field + optional plugin self-tests (per DESIGN-04/05/06)

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

**Repository:** `dydx-project-workflow` — single-plugin marketplace. Plugin lives at `dydx-delivery/` at version **2.0.0** (synced across `plugin.json` + `marketplace.json`) with **12 skills total**: 9 stage skills (kickoff-capture, discovery-intake, generate-sow, generate-fnspec-platform [4a], generate-fnspec-integration [4b], generate-technical-spec, generate-test-plan, generate-build-prompt, execute-tests) + 3 platform reference skills (platform-pipefy, platform-wrike, platform-ziflow). Empty `commands/`, `agents/`, `hooks/` scaffold dirs exist. LICENSE in place. v0.3.0 `generate-functional-spec/` RETIRED in v2.2 (split into 4a + 4b).

**Pipeline today (post-v2.2):** Stage-gated flow with kickoff routing — kickoff → (discovery-ready → discovery → SOW | draft-sow → SKIP discovery → SOW) → 4a fnspec-platform + 4b fnspec-integration → techspec → test plan → build prompt → execute tests. Kickoff carries `kickoff_branch: discovery-ready | draft-sow` (single field, both downstream stages read it) and `platform: pipefy | wrike | ziflow | other` (4-enum after v2.2 D-78 rollout). Stage 4 split: 4a writes `04a_fnspec-platform_v<N>.md` with `delivery: native-ai | api` routing key on every requirement row; 4b OWNS three consistency checks (run FIRST before write; halt emits `04b_consistency_check_v<N>.md`). Stage 5 scope-gate forward-compat documented in 4a/4b frontmatter; actual Stage 5 consumption lands v2.3. Single SOW covers both platform AND integration scope (no Stage 3 split).

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
| Coda becomes a hard dependency | Required for scope/costing tasks AND brain mirror; no fallback without Coda | — Pending (lands in v2.3+ when Stage 6 cost + Stage 11 archive consume Coda) |
| Local brain canonical, Coda mirror published one-way | Two-way sync invites merge conflicts; Field Notes stays a triage queue, never auto-merged | — Pending (lands in v2.5+ with Stage 11 brain-update workflow) |
| Test harness per client, persistent, hybrid Python+AI | Deterministic state checks + AI judgement is the only way to get reliable end-to-end coverage across heterogeneous platforms | — Pending (lands in v2.4 Stage 8 test-bot rebuild) |
| Reset phase numbering at 1 for v2.0 | No prior milestone phases archived; clean numbering avoids confusion with file-prefix stage numbers | ✓ Good — Phases 1-4 (v2.0) + Phases 5-6 (v2.1) + Phases 7-8 (v2.2); no collision with file-prefix stage numbers |
| Run-domain research before defining requirements | Hybrid Python+AI test harness, Coda schema patterns, native-AI ingestion paths, and integration pitfalls warrant grounded inputs | ✓ Good — research outputs in .planning/research/ informed CHANGELIST sequencing |
| v2.0 milestone is design-only — no skill edits | Kickoff explicitly mandates audit + design lock before build; prevents premature skill churn | ✓ Good — design-lock held through Phase 4; first skill edits landed in Phase 5 (v2.1) as planned |
| Per-platform slicing of Phase 6 (D-63) — Pipefy/Wrike/Ziflow each as one atomic plan | Reviewer grades a whole platform at a time; mixing platforms across plans causes review-context loss | ✓ Good — 06-01/02/03 shipped as atomic platforms; parallel Wave 2 execution worked |
| Webhook-PRIMARY framing for Ziflow read-after-create (Q05) | Vendor explicitly recommends webhooks over polling; wait_for_proof is fallback only | ✓ Good — landed in platform-ziflow/api-contract.md with 30s/2s polling defaults |
| `tier_claims_last_verified:` per-platform date (MOD-7, D-68) | Connector capability claims rot fast; per-platform date gives a re-verification trigger | ✓ Good — 2026-05-09 baseline applied to all 3 platform SKILL.md frontmatter |
| Vocabulary dedup gate (D-66) — project-wide glossary terms ONLY in glossary.md | Platform-specific vocabularies must not redefine project-wide terms | ✓ Good — D-66 grep gate green at v2.1 close; zero cross-platform redefinitions |
| Phase 7 bundles STG1 + STG2 + STG3 (10 reqs) in one phase (v2.2) | STG2/STG3 are downstream consumers of the kickoff artefact contract; landing them with STG1 in the same phase lights the pipeline up end-to-end before Phase 8 starts | ✓ Good — e2e smoke against both `discovery-ready` and `draft-sow` branches green at Phase 7 close |
| Phase 8 bundles STG4 + ROUTE (11 reqs) per D-63 per-platform-atomic precedent (v2.2) | STG4 split + ROUTE consistency check + Stage 5 scope-gate forward-compat + TD-2 inline + delivery routing-key propagation are tightly coupled to DESIGN-20; ship as one atomic phase | ✓ Good — `phase8-structure-check.sh --all` PASS at close; 0 cross-coupling defects |
| TD-2 (ROUTE-04) resolved INLINE as D-78 path-(a) — `ziflow` ADDED to stage-skill `platform:` 4-enum (v2.2) | Path-(a) preserves Ziflow as primary platform routing key consistent with `platform-ziflow/SKILL.md:14`; path-(b) would have forced re-litigating v2.1 platform-skill catalogue | ✓ Good — 4-enum (`pipefy \| wrike \| ziflow \| other`) rolled out across 10 files / 11 lines; 0 residue of 3-enum |
| Cross-spec consistency check OWNED by Stage 4b — runs FIRST before fnspec write (D-84, v2.2) | Single-owner avoids 4a-vs-4b double-write race + halts on conflict before emitting inconsistent artefact | ✓ Good — halt-on-failure → dedicated `04b_consistency_check_v<N>.md` artefact landed in 08-02 |
| Stage 5 scope-gate forward-compat ONLY in v2.2 (DESIGN-21) — 4a/4b emit frontmatter; actual Stage 5 consumption ships v2.3 | Avoids premature Stage 5 work; ROUTE-03 success criteria fully testable from frontmatter alone | ✓ Good — 3 fixture-output artefacts in 08-03 prove all 3 scope-gate branches resolve from frontmatter |
| `delivery: native-ai \| api` canonical enum order LOCKED — never reversed (D-81 + STG4-04, v2.2) | Reverse order would invert downstream consumer assumptions in Stages 5/6/7b/10; grep-gate against reverse | ✓ Good — anti-pattern scan returns 0 matches of reversed `api \| native-ai` across all `dydx-delivery/` skills |

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

## Current State: v2.2 Shipped (2026-05-11)

**Last shipped:** v2.2 Stage 1 Kickoff + Stage 4 Fnspec Split — 2 phases (Phase 7 Stage 1 Kickoff + Discovery/SOW upstream wiring; Phase 8 Stage 4 Fnspec Split + ROUTE), 7 plans, 21 requirements (5 STG1 + 3 STG2 + 2 STG3 + 6 STG4 + 5 ROUTE) all satisfied. Full archive: `.planning/milestones/v2.2-ROADMAP.md` + `v2.2-REQUIREMENTS.md` + `v2.2-MILESTONE-AUDIT.md` (final verdict `passed` — 3 hygiene items closed inline pre-archive).

**Plugin v2.0.0 surface today:**
- 9 stage skills + 3 platform reference skills under `dydx-delivery/skills/` (kickoff-capture, discovery-intake, generate-sow, generate-fnspec-platform [4a], generate-fnspec-integration [4b], generate-technical-spec, generate-test-plan, generate-build-prompt, execute-tests; + platform-pipefy, platform-wrike, platform-ziflow)
- 5 plugin-level canonical references + connector-matrix at `dydx-delivery/references/`
- Manifest 2.0.0 synced across `plugin.json` + `marketplace.json` (description prose refreshed to "Twelve skills" at v2.2 close)
- LICENSE in place; empty commands/agents/hooks/ scaffold dirs
- v0.3.0 `generate-functional-spec/` RETIRED in v2.2 (replaced by 4a + 4b)

**Pipeline end-to-end through Stage 4:**
- Stage 1 kickoff → routing on `kickoff_branch: discovery-ready | draft-sow` → Stage 2 discovery (or SKIPPED) → Stage 3 SOW (single, dual-scope H2 split) → Stage 4a fnspec-platform + Stage 4b fnspec-integration (consistency check OWNED by 4b; halt-on-failure) → forward-compat hand-off to Stage 5 (v2.3)
- `platform: pipefy | wrike | ziflow | other` 4-enum locked across all consuming stage skills (D-78 path-(a) rollout in v2.2)
- `delivery: native-ai | api` routing key emitted on every 4a/4b requirement row; survives forward through `based_on_*` chain (forward-compat smoke green)

**Carry-forward into v2.3:**
- All 21 v2.2 requirements satisfied; 3 hygiene TDs closed inline; no carryover tech debt
- Nyquist VALIDATION.md flag drift on Phase 7 + Phase 8 (informational only — coverage green per structure-checks); optional `/gsd-validate-phase 7` + `/gsd-validate-phase 8` retroactive normalization available
- Key v2.2 decision baselines locked for v2.3 planning: D-78 (4-enum precedent), D-79 (Platform-API Addendum), D-84 (consistency-first discipline), D-85 (either-spec-skip topology)

## Current Milestone

**None active.** v2.2 closed 2026-05-11. Run `/gsd-new-milestone` to scope v2.3 (Stage 5 Tech Spec + Stage 6 Cost + Stage 7a/7b Build Prompts per CHANGELIST.md Phase 4).

<details>
<summary>Archived v2.2 milestone scope (Phases 7-8) — shipped 2026-05-11</summary>

**Phase 7 — Stage 1 Kickoff + Discovery/SOW upstream wiring (STG1-01..05 + STG2-01..03 + STG3-01..02):**
- `kickoff-capture/` NEW with SKILL.md + 3 references/ files (kickoff-template.md / auto-classify-rubric.md / capture-paths.md)
- 3 capture paths (meeting-notes paste / Miro paste fallback / Field Notes Coda read with `processed_at IS NULL` triage default)
- `discovery-intake/` MODIFIED — consumes kickoff as sole upstream; raw-notes path RETIRED; verbatim skip-emit on `draft-sow` branch
- `generate-sow/` MODIFIED — 4-state lifecycle `draft → client_review → approved → archived`; single-SOW dual-scope H2 split (Platform + Integration sections per D-75)
- `phase7-structure-check.sh` with `--section <kickoff|discovery|sow|all>` dispatch; 15/15 PASS at close
- 3 sample-CR fixtures for e2e smoke against both routing branches

**Phase 8 — Stage 4 Fnspec Split + ROUTE (STG4-01..06 + ROUTE-01..05):**
- `generate-fnspec-platform/` (Stage 4a, NEW) — SKILL.md + 3 references/ files (fnspec-platform-template.md / auto-classify-rubric.md per D-81 / addendum-template.md per D-79)
- `generate-fnspec-integration/` (Stage 4b, NEW) — SKILL.md + 3 references/ files (fnspec-integration-template.md / consistency-rules.md per D-84 / either-spec-skip-paths.md per STG4-06 + D-85)
- v0.3.0 `generate-functional-spec/` RETIRED — directory removed; templates / READMEs / changelogs repointed to 4a + 4b
- `delivery: native-ai | api` canonical enum order LOCKED on every 4a/4b requirement row
- D-78 path-(a) — `ziflow` ADDED to stage-skill `platform:` 4-enum across 10 files / 11 lines (TD-2 closed inline)
- 3 fixture-output artefacts for ROUTE-05 forward-compat smoke
- `phase8-structure-check.sh` with 5 section runners (P/I/E/S/X) + 4 cross-cutting X assertions + locked-literal grep on E2; 32/32 PASS at close
- R-01 glossary cleanup (lines 47+66) + DESIGN-20 D-78 sub-decision + glossary routing-key entry

</details>

**Scope locks carried forward from v2.0/v2.1/v2.2 (do not re-litigate):**
- UAT-3.5 — MCPs OUT-OF-SCOPE through v2.6 (API-first across all platforms)
- UAT-6.1 — Native-AI ingestion APIs OUT-OF-SCOPE entirely (paste-only)
- UAT-4.1 — Pipefy API host canonical-only; web_host + org_id vary per tenant
- UAT-4.2 — Pipefy auth-concurrency exclusive; Stage 8 test bot tier-1 serializes per-tenant
- UAT-3.1 — Private email `jasonmichaelb@gmail.com` on plugin manifests is INTENTIONAL (dYdX-approved)
- D-65 — Client-shape-gotchas use VodafoneZiggo + Up & Up Group; other clients TBD-at-first-engagement
- D-67 — Each phase resolves its own OPEN-Q rows inline; synthesis plans flip the OPEN-QUESTIONS register
- D-78 — `platform:` 4-enum `pipefy | wrike | ziflow | other` is canonical baseline (extend to 5-enum only via a new D-XX decision)
- D-81 — `delivery: native-ai | api` canonical enum order LOCKED; never reversed

---
*Last updated: 2026-05-11 after v2.2 milestone close*
