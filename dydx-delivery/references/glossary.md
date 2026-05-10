# dYdX Delivery — Glossary (canonical)

> Canonical plugin-runtime vocabulary, narrowed from `.planning/DESIGN.md` Appendix A (`.planning/DESIGN.md:1462-1549`). Design-process-only terms are excluded by design — bar for inclusion is "would a skill author at runtime need this term?".
>
> Two entries below carry the marker `[provisional — ratified by W4 OPEN-Q closure]` per Codex C-4 finding: `Claude for Chrome` (OPEN-Q09) and `Wrike host field` (OPEN-Q13). Wave 4 (Plan 05-04 Task 2) flips OPEN-Q09 + OPEN-Q13 to `Status: decided` and strips these provisional markers in the same edit.

## Pipeline / Stage terms

**Stage 1 — Kickoff capture** — Meeting-note / requirement / Field-Notes triage into `01_kickoff_v<N>.md`. Skill `kickoff-capture/` per DESIGN-17.
**Stage 2 — Discovery** — Discovery refactor into `02_discovery_v<N>.md`. Skill `discovery-intake/` per DESIGN-18.
**Stage 3 — SOW** — Statement-of-Work synthesis into `03_sow_v<N>.md`. Skill `generate-sow/` per DESIGN-19. Produces SoWs in `client_review` status (live in v0.3.0 per the DESIGN-08 status-lifecycle survey).
**Stage 4a — fnspec-platform** — Platform-shaped functional spec at `04a_fnspec-platform_v<N>.md`; carries `delivery: native-ai | api` switch per requirement. Skill `generate-fnspec-platform/` per DESIGN-20.
**Stage 4b — fnspec-integration** — Integration-shaped functional spec at `04b_fnspec-integration_v<N>.md`. Skill `generate-fnspec-integration/` per DESIGN-20.
**Stage 5 — techspec** — Technical spec at `05_techspec_v<N>.md`. Skill `generate-technical-spec/` per DESIGN-21. Scope-gate values `full | addendum-only | skip-entirely` via `tech_spec_scope:`.
**Stage 6 — Cost estimate** — `06_cost_v<N>.md` plus Coda task-table push. Skill `generate-cost-estimate/` per DESIGN-22. Halt-gate on `commercial_inputs_status: provided`.
**Stage 7a — build-prompt-dev** — Dev build prompt at `07a_build-prompt_v<N>.md`. Skill `generate-build-prompt/` per DESIGN-23. Routing key `delivery_filter: api`.
**Stage 7b — implementation-prompt** — Per-platform implementation prompt at `07b_implementation-prompt_v<N>.md`. Skill `generate-implementation-prompt/` per DESIGN-23. Routing key `delivery_filter: native-ai`.
**Stage 8a — provision-test-harness** — Test harness provisioning at `08a_test-harness_v<N>.md`. Skill `provision-test-harness/` per DESIGN-24.
**Stage 8b — test plan** — Test plan at `08b_test-plan_v<N>.md`. Skill `generate-test-plan/` per DESIGN-24. Path lives under `<Client> Brain/test-bot/test_cases/`.
**Stage 8c — UAT plan** — User-acceptance test plan at `08c_uat-plan_v<N>.md`. Skill `generate-uat-plan/` per DESIGN-24.
**Stage 8d — execute-tests** — Test execution + results at `08d_test-results_v<N>.md`. Skill `execute-tests/` per DESIGN-24 / DESIGN-28.
**Stage 9 — Documentation** — Doc publishing + `<CR>/doc-diff.md`. Skill `update-documentation/` per DESIGN-25.
**Stage 10 — native-AI enablement** — Per-platform native-AI ingestion (paste / api / internal_skill routes). Skill `push-native-ai-knowledge/` per DESIGN-26.
**Stage 11 — sign-off + archive** — `<Client> Brain/` spoke updates + Coda mirror push + CR archive. Skill `sign-off-and-archive/` per DESIGN-27.
**archive** — Stage 11 movement of approved artefacts into `Archive/<CR>/` plus terminal `status: archived` write per DESIGN-27.
**cost estimate** — See Stage 6.
**discovery** — See Stage 2.
**documentation** — See Stage 9.
**Field Notes** — Coda input-only triage queue read by Stage 1; never overwritten by Stage 11 per DESIGN-09 / DESIGN-27.
**fnspec-integration** — See Stage 4b.
**fnspec-platform** — See Stage 4a.
**kickoff** — See Stage 1.
**native-AI** — Umbrella term for vendor-native AI surfaces (Pipefy AI Agents, Wrike Copilot, Ziflow ReviewAI). Distinct from API delivery; see `delivery:` enum.
**sign-off** — See Stage 11.
**SOW** — See Stage 3.
**substage** — Letter suffix on stage prefix indicating sub-step within a stage; canonical substages are `4a / 4b / 7a / 7b / 8a / 8b / 8c / 8d` per DESIGN-20 / DESIGN-23 / DESIGN-24.
**techspec** — See Stage 5.
**test bot** — The four-substage Stage 8 cluster (8a-8d) per DESIGN-24 / DESIGN-28.
**test plan** — See Stage 8b. (v0.1.0 vocab "test sheet" retired; see B.2 cosmetic fix.)
**UAT plan** — See Stage 8c.

## Frontmatter terms

**approved_at** — ISO-8601 timestamp recording sign-off time; mandatory on `status: approved` writes per DESIGN-06. Hook refuses write if missing.
**approved_by** — Human author name recording sign-off identity; mandatory on `status: approved` writes per DESIGN-06. Hook refuses literal `Claude` / `AI` / `system` values.
**based_on_cost** — Frontmatter field on `07a_*` / `07b_*` artefacts pointing at the upstream `06_cost_v<N>.md` per DESIGN-22 / DESIGN-23.
**based_on_discovery** — Frontmatter field on `03_sow_*` artefacts (discovery-via branch) pointing at the upstream `02_discovery_v<N>.md` per DESIGN-19.
**based_on_fnspec_integration** — Frontmatter field on `06_cost_*` / `05_techspec_*` / `07a_*` artefacts pointing at the upstream `04b_fnspec-integration_v<N>.md` per DESIGN-20 / DESIGN-22.
**based_on_fnspec_platform** — Frontmatter field on `06_cost_*` / `07b_*` artefacts pointing at the upstream `04a_fnspec-platform_v<N>.md` per DESIGN-20 / DESIGN-22.
**based_on_kickoff** — Frontmatter field on `02_discovery_*` and `03_sow_*` artefacts pointing at the upstream `01_kickoff_v<N>.md` carrier per DESIGN-18 / DESIGN-19.
**based_on_sow** — Frontmatter field on `04a_*` / `04b_*` fnspec artefacts pointing at the upstream `03_sow_v<N>.md` per DESIGN-20.
**based_on_techspec** — Frontmatter field on `06_cost_*` and `07a_*` artefacts pointing at the upstream `05_techspec_v<N>.md` per DESIGN-21 / DESIGN-22 / DESIGN-23.
**client** — Frontmatter scalar naming the client; participates in `<Client> Brain/` directory naming per DESIGN-09.
**client_state_version** — Top-level integer in `<Client> Brain/test-bot/client_state.yaml`; bumped on Stage 8a schema-refresh acknowledge path per DESIGN-29 / DESIGN-30.
**commercial_inputs_status** — Halt-gate field on `06_cost_inputs_v<N>.md`; values `pending | provided` per DESIGN-22 wait-for-commercial-inputs gate.
**delivery** — Per-requirement routing key on `04a_fnspec-platform_v<N>.md` rows; closed enum `native-ai | api`; drives Stage 5 / Stage 7b / Stage 10 dispatch per DESIGN-20 / DESIGN-21 / DESIGN-26.
**delivery_filter** — Reading-side filter used by Stage 5 / Stage 7b / Stage 10 to select rows from `04a_*` by `delivery:` value per DESIGN-21 / DESIGN-23 / DESIGN-26.
**doc_published_at** — ISO-timestamp on `<CR>/doc-diff.md` recording when a doc was pushed to Drive; pre-archive sanity check requires every diff-listed doc has this field per DESIGN-25 / DESIGN-27.
**doc_type** — Closed-enum field on Stage 9 docs (9 values: operating-runbook | platform-shape | integration-shape | brain-spoke | brain-index | onboarding | safety-rules | hand-off | release-notes) per DESIGN-25.
**doc_version** — Integer on Stage 9 docs; bumped by `bump-artefact-version.py` hook per DESIGN-04.
**failure_class** — Closed-enum on `08d_test-results_v<N>.md` per-TC failure rows; 5-value enum `ingest_lag | agent_skip | log_silence | unknown | harness_drift` per DESIGN-24 / DESIGN-30.
**feature** — Frontmatter scalar naming the feature within a client / CR.
**frontmatter_version** — Mandatory integer on every v2 artefact; absent value triggers v0.3.0 lenient mode per DESIGN-01 / DESIGN-08. Locked at `frontmatter_version: 2`.
**generated_at** — ISO date on an artefact recording when it was first written.
**ingested_at** — ISO-timestamp on Stage 10 native-AI artefacts recording when content was last pushed to a platform's native-AI surface per DESIGN-26.
**kickoff_branch** — Routing key on `01_kickoff_v<N>.md` selecting the downstream path: `kickoff-direct` (skip Stage 2; feed Stage 3 directly) or `discovery-via` (feed Stage 2 first) per DESIGN-17 / DESIGN-19.
**last_diff_review_at** — Field on Stage 9 docs recording when the last diff was reviewer-approved per DESIGN-25.
**last_passed_at** — ISO-timestamp on test-case artefacts recording the most recent successful run per DESIGN-29.
**native_ai_path** — Closed-enum routing key on `04a_*` rows; values `api | paste | internal_skill` per DESIGN-26 + per-platform DESIGN-14 / DESIGN-15 / DESIGN-16. v2.1 first-build value: `paste | none` only (api deferred).
**pipe_id** — Pipefy-only frontmatter identifier; presence on a non-Pipefy artefact is a `validate-frontmatter` hook failure per DESIGN-01.
**platform** — Closed-enum frontmatter field (`pipefy | wrike | ziflow | other`); gates platform-specific identifier presence per DESIGN-01.
**project** — Frontmatter scalar naming the project / CR within a client per DESIGN-09.
**project_id** — Ziflow-only frontmatter identifier; analogous to `pipe_id` per DESIGN-01 / DESIGN-16.
**risk_multiplier_version** — Frontmatter field on `06_cost_v<N>.md` locking which numeric default set was used per DESIGN-22 / D-22.
**sandbox** — Top-level frontmatter block naming the sandbox tenant + IDs. The runner pins all API calls inside this block per safety-rules.md Rule 1.
**space_id** — Wrike-only frontmatter identifier; analogous to `pipe_id` per DESIGN-01 / DESIGN-15.
**status** — Lifecycle state of an artefact; canonical 4-value enum `draft → client_review → approved → archived` per DESIGN-01. Lifecycle values:
  - `draft` — Initial status of a newly written artefact; pre-reviewer per DESIGN-01.
  - `client_review` — Status indicating an artefact is in client / reviewer hands; retained per DESIGN-08 live-survey result (live in `generate-sow:93`).
  - `approved` — Status indicating reviewer approval; mandatory `approved_by` + `approved_at` per DESIGN-06.
  - `archived` — Terminal status applied to artefacts moved into `Archive/<CR>/` by Stage 11 per DESIGN-27.
**target_id** — Stage 10 / `push-native-ai-knowledge` field naming the platform-side ingestion target (Pipefy KB id / Wrike AI Studio reference / Ziflow ReviewAI Checklist id) per DESIGN-26.
**targets_artefact** — Field on test-case artefacts in `<Client> Brain/test-bot/test_cases/` naming the upstream artefact a TC verifies; obsolescence detection compares against approved upstream artefacts per DESIGN-29.
**tech_spec_scope** — Closed-enum field on `05_techspec_v<N>.md`; values `full | addendum-only | skip-entirely` per DESIGN-21.
**tier_claims_last_verified** — ISO-date field on platform-skill `references/native-ai-inventory.md` artefacts; hook for re-verifying native-AI capability matrices per DESIGN-14 / DESIGN-15 / DESIGN-16.

## Platform terms

**Behaviors** — Pipefy domain term — workflow-rule automations per DESIGN-14.
**Card** — Pipefy domain term — work item per DESIGN-14.
**Checklist** — Ziflow domain term — Public-Preview ReviewAI feature per DESIGN-16.
**Claude for Chrome** [provisional — ratified by W4 OPEN-Q closure] — Anthropic browser extension; canonical product name per `claude.com/claude-for-chrome` marketing page; also `Claude in Chrome` per Help Center (`support.claude.com/en/articles/12012173-get-started-with-claude-in-chrome`) — terms interchangeable. Per OPEN-Q09 research, marketing/product page is canonical primary; Help Center wording is permissible cross-reference. Status as of May 2026: in beta on all paid plans.
**Coda** — Document + table workspace; sandbox writes permitted against `sandbox.coda_doc:` block in test plan frontmatter per safety-rules.md Rule 3 (CRIT-5 fix). Stage 11 brain-mirror push target per DESIGN-27.
**Custom Field** — Wrike domain term — tenant-extensible task field per DESIGN-15.
**Folder** — Wrike domain term — Space contains Folders; Folders contain Tasks per DESIGN-15.
**Google Workspace** — Drive / Docs / Sheets surface used by Stage 9 documentation publishing per DESIGN-25.
**Miro** — Diagram surface; paste-only delivery in v2.1 (`native_ai_path: paste`).
**paginate_all** — Pagination helper provided by `platform-pipefy/` + `platform-wrike/` skills; cursor-iterates a list endpoint until exhausted; centralised so per-stage skills do not re-implement pagination per DESIGN-14 / DESIGN-15.
**Phase** — Pipefy domain term — column on a Pipe per DESIGN-14.
**Pipe** — Pipefy domain term — a workflow per DESIGN-14.
**Pipefy** — GraphQL workflow platform; canonical endpoint `api.pipefy.com/graphql` for ALL tenants per OPEN-Q24 / DESIGN-14.
**Pipefy AI Agents** — Pipefy native-AI surface; addressed by Stage 7b implementation prompt + Stage 10 ingestion per DESIGN-14 / DESIGN-26.
**Project (Ziflow)** — Ziflow domain term — container for Proofs per DESIGN-16.
**Proof** — Ziflow domain term — review artefact inside a Project per DESIGN-16.
**ReviewAI** — Ziflow domain term — AI suite (Checklists + auto-comparison features) per DESIGN-16.
**Space** — Wrike domain term — top-level workspace container per DESIGN-15.
**Task** — Wrike domain term — work item inside a Folder per DESIGN-15.
**wait_for_proof** — Polling helper provided by `platform-ziflow/` skill; polls a Proof until it reaches the requested state (ready / approved / completed) with exponential backoff and a hard timeout per DESIGN-16.
**Wrike** — REST + AI Studio platform; per-tenant API base URL parsed from OAuth token `host` field per DESIGN-15.
**Wrike Copilot** — Wrike native-AI surface (AI Studio); addressed by Stage 7b implementation prompt + Stage 10 ingestion per DESIGN-15 / DESIGN-26.
**Wrike host field** [provisional — ratified by W4 OPEN-Q closure] — Per-tenant Wrike API base URL parsed from the OAuth token response `host` field; persisted as canonical SoT at `<Client> Brain/00_HUB.md` (per DESIGN-29 schema); hardcoding `www.wrike.com` breaks multi-tenant per MOD-5. Stage 7b implementation prompt and Stage 8 test-bot `client_state.yaml.wrike.host:` both read from this single SoT. (OPEN-Q13 research conclusion; non-binding storage destination per Phase 6 PLAT-02 discretion.)
**Ziflow** — Proof-review platform per DESIGN-16. Read-after-create consistency is per-tenant — `wait_for_proof` helper handles polling.
**Ziflow ReviewAI** — Ziflow native-AI surface; addressed by Stage 7b implementation prompt + Stage 10 ingestion per DESIGN-16 / DESIGN-26.

## Test-bot terms

**acknowledge** — Drift-resolution path 1: human runs Stage 8a to refresh `last_known_schema.<platform>`; quarantines affected TCs; bumps `client_state_version:` per DESIGN-30.
**active** — TC lifecycle state — the TC is in normal use per DESIGN-24.
**auth_switch_required** — Halt signal emitted when a TC requires a token / session that the runner does not currently hold per DESIGN-24.
**client_state.yaml** — Canonical per-client test-bot state file at `<Client> Brain/test-bot/client_state.yaml`; carries `client_state_version`, `last_known_schema.<platform>`, `wrike.host`, and other per-tenant pinning data per DESIGN-29.
**harness_drift** — Failure-class enum value emitted by Stage 8d when drift detection halts; per DESIGN-24 / DESIGN-30.
**last_known_schema** — Per-platform schema snapshot in `client_state.yaml` against which Stage 8d compares the live sandbox shape per DESIGN-30.
**obsolete** — TC lifecycle state — the TC's `targets_artefact:` no longer resolves per DESIGN-24.
**quarantined** — TC lifecycle state — the TC is suspended pending tier-1 update per DESIGN-24.
**revert** — Drift-resolution path 2: human reverts the sandbox to match `last_known_schema`; reruns Stage 8d; no `client_state.yaml` change required per DESIGN-30.
**sandbox_lock.yaml** — Sandbox concurrency-lock artefact in `<Client> Brain/test-bot/`; Stage 8a writes; Stage 8d reads; per DESIGN-24.
**schema_drift_report.md** — Drift-detection halt artefact; frontmatter (`previous_schema_hash` / `current_schema_hash` / `detected_at`) + body (per-column diff + recommended human action) per DESIGN-30.
**targets_artefact** — See Frontmatter terms — duplicated here as the test-bot-side surface of the field.
**tier-1 deterministic** — Python deterministic test layer; HUMAN-AUTHORED `test_runner.py` per DESIGN-28.
**tier-2 AI orchestrator** — AI orchestrator test layer; AI-GENERATED via `test-bot-orchestrator` agent per DESIGN-04 / DESIGN-28.

## Plugin-surface terms

**.claude-plugin/** — Plugin manifest directory at `dydx-delivery/.claude-plugin/`; contains `plugin.json` with `mcpServers` field per DESIGN-04.
**agents/** — Plugin agent directory at `dydx-delivery/agents/`; ships 1 `test-bot-orchestrator.md` per DESIGN-04. Empty scaffold in v2.1 / Phase 5.
**bump-artefact-version** — Hook (`bump-artefact-version.py`) under `hooks/` that bumps `doc_version:` on Stage 9 docs per DESIGN-04. Substantive implementation deferred to v2.6 / SURF-01..03.
**commands/** — Plugin slash-command directory at `dydx-delivery/commands/`; ships 1 parameterised `refine.md` plus 4 GSD-prefixed shortcuts per DESIGN-04 / DESIGN-05. Empty scaffold in v2.1 / Phase 5.
**/dydx-refine-** — Slash-command namespace for the parameterised refine helper (OPEN-Q21 / Q21.1); single `commands/refine.md` taking skill name as `$1`. Substantive command body lands in v2.6 / SURF-01.
**hooks/** — Plugin hooks directory at `dydx-delivery/hooks/`; ships 2 hooks (`validate-frontmatter.py`, `bump-artefact-version.py`) per DESIGN-04. Empty scaffold in v2.1 / Phase 5.
**mcpServers** — Field in `dydx-delivery/.claude-plugin/plugin.json` listing the wired MCPs per DESIGN-04.
**references/** — Plugin reference directory at `dydx-delivery/references/`; canonical `safety-rules.md` / `stage-numbering.md` / `frontmatter-scheme.md` / `glossary.md` / `connector-matrix.md` live here.
**validate-frontmatter** — Hook (`validate-frontmatter.py`) under `hooks/` that validates `frontmatter_version`, status-lifecycle membership, platform-gated identifier rules, `approved_by` + `approved_at` mandatory on `status: approved` writes per DESIGN-04 / DESIGN-06. Substantive implementation deferred to v2.6 / SURF-01..03.

## Doc + sign-off terms

**00_HUB.md** — Per-client hub file at `<Client> Brain/00_HUB.md` carrying canonical per-tenant pinning data (Coda brain-doc URL, Wrike host, sandbox IDs) per DESIGN-29.
**00_Index.md** — Append-only index file at `<Client> Brain/00_Index.md` carrying the Change History entries per DESIGN-27.
**`<client_slug>__<project_slug>__<doc_type>__v<N>`** — Stage 9 documentation filename pattern per DESIGN-25. Double-underscore segment separator.
**brain-mirror Coda doc** — Stage 11 one-way Coda push target — canonical `<Client> Brain/` content mirrored into a Coda doc per DESIGN-27 / DESIGN-09. Up & Up Group + VodafoneZiggo are the two established mirror targets.
**cr_id** — Change-Request identifier; appears in `<Client> Brain/00_Index.md` Change History entries and in `Archive/<CR>/` directory naming per DESIGN-27.
**doc-diff** — Stage 9 artefact (`<CR>/doc-diff.md`) listing every doc updated this CR; gates Stage 11 per DESIGN-25 / DESIGN-27.
**Documentation: link** — Mandatory link field in `<Client> Brain/00_HUB.md` pointing at the per-client documentation surface (Drive or Coda) per DESIGN-25 / DESIGN-27.
**Field Notes** — Coda input-only triage queue read by Stage 1; never overwritten by Stage 11 per DESIGN-09 / DESIGN-27.
**spoke** — Top-level subdirectory of `<Client> Brain/` (Overview / Workflows / Platforms / Integrations / Operating Model / Change History / Field Notes); brain-mirror Coda template carries 7 canonical spoke-shaped sections per DESIGN-27.
**tone_lint** — Pre-publish check enforcing the DESIGN-10 forbidden-phrasings list against any client-visible artefact; MOD-9 prevention per DESIGN-27.
