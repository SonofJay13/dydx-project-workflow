# Requirements: dydx-delivery v2.0 — Implementor Edition

**Defined:** 2026-05-09
**Core Value:** Plugin behaves as a senior implementation partner end-to-end. Every stage produces an artefact polished enough to send to a client or hand to a developer without rework. Every change request leaves the client's brain, documentation, and native-AI knowledge bases coherent and up to date.

> **Milestone framing.** This is a **design-only** milestone (per kickoff: "Do not edit any skill files in this session"). Requirements describe what the v2.0 design deliverables (audit, design doc, change list, open questions register) must cover. The actual rebuild — internalised platform skills, kickoff/fnspec/cost/test-bot/docs/native-AI/archive skills, plus commands/agents/hooks surfaces — runs in subsequent milestones (v2.1+) sequenced by the change list this milestone produces.

> **Scope boundary.** Stage numbering in requirements aligns to the synthesizer's 11-stage canonical (Stage 1 Kickoff … Stage 11 Sign-off). The 9-phase build plan in `.planning/research/SUMMARY.md` is the recommended downstream sequence — this milestone *commits to it as the change list*, and the requirements below cover it being properly captured, justified, and unblocked.

---

## v2.0 Requirements

### Audit (AUDIT.md)

Coverage of the v0.3.0 plugin so the v2 design rests on accurate observation, not memory.

- [x] **AUDIT-01**: AUDIT.md catalogues every v0.3.0 skill (`discovery-intake`, `generate-sow`, `generate-functional-spec`, `generate-technical-spec`, `generate-test-plan`, `generate-build-prompt`, `execute-tests`) with purpose, inputs, outputs, hand-off contract, dependencies, observed brittleness, and what's missing for v2. *(complete 2026-05-09 in Phase 1 Plan 02)*
- [x] **AUDIT-02**: AUDIT.md absorbs every entry in `.planning/codebase/CONCERNS.md` and adds any new structural issues found during the audit pass — the audit is a superset of CONCERNS.md, never less. *(complete 2026-05-09 in Phase 1 Plan 09 — verified-superset claim in §AUDIT-02 + 15-row Appendix B trace + canonical sentinel "All CONCERNS.md sections absorbed; zero entries dropped silently")*
- [x] **AUDIT-03**: AUDIT.md inventories per-stage connector dependencies (Miro, Coda, Drive, Gmail, Calendar, Claude in Chrome, Pipefy/Wrike/Ziflow APIs) and identifies which connectors are *required* vs *graceful-degradation* per stage.
- [ ] **AUDIT-04**: AUDIT.md catalogues referenced-but-missing artefacts (`platform-pipefy`/`platform-wrike` skills, `/refine-<skill>` slash commands, workspace `hub.md`, client-folder `.env.example`) with exact citations from the v0.3.0 docs.
- [x] **AUDIT-05**: AUDIT.md surfaces duplicated content with the canonical-source recommendation per duplicate (hard-rules across 4 files; pipeline diagram across 3 files; start-at-any-point triage block across 6 SKILL.md files; Cowork-vs-Claude-Code positioning across 3 files).
- [ ] **AUDIT-06**: AUDIT.md inventories versioning mismatches across `plugin.json`, `marketplace.json`, root README, plugin README, and any hardcoded version strings, recommending `2.0.0` as the synced target.
- [x] **AUDIT-07**: AUDIT.md flags every cosmetic-but-client-visible issue (README truncation, residual "test sheet" wording, missing `LICENSE`, owner-email mismatch with stated org) — fixes scheduled for the v2.1 build, NOT this design milestone.
- [x] **AUDIT-08**: AUDIT.md verifies connector wiring in this workspace by probing each MCP (Coda, Miro, Google Workspace, Gmail, Calendar) and recording: present-and-working / present-but-broken / missing — with version pins where present.

### Design (DESIGN.md)

Plugin v2 architecture decisions locked. Each requirement names a decision the design must close out.

#### Cross-cutting structural decisions

- [x] **DESIGN-01**: DESIGN.md establishes the canonical **frontmatter scheme** — status lifecycle (`draft → client_review → approved → archived`); field-name convention (underscore-snake-case for keys, hyphen-kebab-case for file paths); platform-gated identifiers (`pipe_id`/`space_id`/`project_id` only present when their `platform:` value is active); `frontmatter_version: 2` field on new artefacts; absent → v0.3.0 lenient mode.
- [x] **DESIGN-02**: DESIGN.md establishes the canonical **stage-numbering scheme** — file-prefix is the stage number (`01_kickoff_…` through `11_…`); substages `4a/4b/7a/7b/8a/8b/8c/8d` per architecture research; canonical reference at `dydx-delivery/references/stage-numbering.md`; old→new mapping table for migration.
- [x] **DESIGN-03**: DESIGN.md establishes a **single source of truth for hard rules** at `dydx-delivery/references/safety-rules.md`, plus a per-client override mechanism (`<Client> Brain/safety-overrides.yaml` overlaying only fields marked `overridable: true`). Skills inline a one-line summary plus pointer; never copy the full ruleset.
- [x] **DESIGN-04**: DESIGN.md commits to **plugin surfaces** — `commands/` (1 parameterised `refine.md` taking skill name as `$1` + 4 GSD-prefixed shortcuts), `agents/` (1 — test-bot-orchestrator), `hooks/` (2 — `validate-frontmatter`, `bump-artefact-version`; explicitly NOT auto-progression hooks), `mcpServers` field. Plugin manifest version `2.0.0` synced across `plugin.json` + `marketplace.json` metadata + plugins[0].
- [x] **DESIGN-05**: DESIGN.md decides the **`/refine-<skill>` pattern** — build a single parameterised `commands/refine.md` taking skill name as `$1` (recommended), OR delete every orphan reference during v2.1 cutover. No middle ground.
- [x] **DESIGN-06**: DESIGN.md establishes the **approval-gate enforcement contract** — every stage skill ends with an explicit handoff message naming the approval action; `status: approved` writes carry mandatory `approved_by` + `approved_at`; an approval-gate hook refuses `status: approved` writes lacking `approved_by`.
- [x] **DESIGN-07**: DESIGN.md establishes the **connector-availability probe + graceful-degradation matrix** — session-start probe of each MCP; per-stage fallback behaviour (Stage 6 → manual mode if Coda missing; Stage 9 → halt if Drive missing; Stage 10 → copy-paste fallback if direct API missing; etc.) per the PITFALLS connector-fallback table.
- [x] **DESIGN-08**: DESIGN.md establishes **frontmatter migration co-existence rules** — v2 readers tolerate v0.3.0 frontmatter via the `frontmatter_version` field; migration is opt-in per change request; in-flight `client_review` artefacts NEVER auto-flip to `approved`; status lifecycle MUST retain `client_review` (in use in `generate-sow` today).
- [x] **DESIGN-09**: DESIGN.md establishes the **directional-boundary contract** — local `<Client> Brain/` is canonical; Coda is one-way published mirror; Field Notes table is read-only triage queue; Field Notes are NEVER auto-merged into the brain (kickoff quotes the note + asks human keep/drop/edit-and-keep).
- [x] **DESIGN-10**: DESIGN.md establishes the **persona contract** — "senior implementer voice" specification with do/don't examples; every stage skill quality bar restates "does not auto-progress."

#### Skill layout & hand-offs

- [ ] **DESIGN-11**: DESIGN.md presents the v2 **folder/skill layout** — `skills/`, `commands/`, `agents/`, `hooks/`, `.claude-plugin/`, plus the new plugin-level `references/` directory.
- [ ] **DESIGN-12**: DESIGN.md presents the v2 **skill inventory** — 13 skills total per architecture research (6 NEW stage skills + 3 NEW platform skills + 4 MODIFIED + 2 UNCHANGED + 1 RETIRED-AND-REPLACED). Each skill carries: purpose, inputs (frontmatter + upstream artefact), outputs, downstream consumer, complexity tag, dependencies, hand-off message shape.
- [ ] **DESIGN-13**: DESIGN.md presents the **stage-by-stage hand-off contract** — for every stage transition, the carrier file path, the frontmatter fields that propagate, and the status flag that gates the next stage.

#### Platform skills (internalisation)

- [ ] **DESIGN-14**: DESIGN.md specifies `platform-pipefy/` skill structure — `SKILL.md` + `references/{api-contract.md, native-ai-inventory.md, knowledge-ingestion.md, client-shape-gotchas.md, vocabulary.md}`. Native-AI capability matrix grounded in 2026 Pipefy AI Agents docs (KB + Skills + MCP + IDP + Web Search + BYO-LLM). API surface for the gap (GraphQL, including `paginate_all` helper for cursor pagination). Sandbox access pattern. Native-AI knowledge ingestion path with `native_ai_path: api | paste | none` flag (LOW-confidence: KB upload endpoint not externally verified). `tier_claims_last_verified` frontmatter.
- [ ] **DESIGN-15**: DESIGN.md specifies `platform-wrike/` skill structure with the same shape. Native-AI matrix grounded in Wrike Copilot + 16 MCP tools. API surface for the gap (REST; `host` field from OAuth token response is base-URL — hardcoding `www.wrike.com` is a bug). Sandbox access. Knowledge ingestion via attach-doc-via-MCP.
- [ ] **DESIGN-16**: DESIGN.md specifies `platform-ziflow/` skill structure with the same shape. Native-AI matrix grounded in Ziflow ReviewAI (Checklists Public Preview; Change Verification + Brand Standards Coming Soon). API surface for the gap (REST; `wait_for_proof` helper for eventual consistency on proof creation). Sandbox access. Knowledge ingestion path = Checklist generation primarily; copy-paste fallback.

#### Stage skill designs

- [x] **DESIGN-17**: DESIGN.md specifies **Stage 1 Kickoff capture skill** — inputs (meeting notes / client requirements / internal feedback / Miro workflow map); dual artefact branching (discovery-ready vs draft SOW); Field Notes triage from Coda brain doc (defaults to `processed_at IS NULL`, never auto-merges); Miro paste fallback when API ingest unavailable; auto-classification into kickoff template sections with explicit "unknown" markers.
- [x] **DESIGN-18**: DESIGN.md specifies **Stage 2 Discovery intake refactor** — consume `01_kickoff_v*` artefact (skip raw-notes mode); skip the entire stage when kickoff produced a draft SOW; same template structure as v0.3.0 otherwise.
- [x] **DESIGN-19**: DESIGN.md specifies **Stage 3 SOW refactor** — single SOW covering platform AND integration; status lifecycle locked to canonical scheme (DESIGN-01); structurally unchanged from v0.3.0 otherwise.
- [x] **DESIGN-20**: DESIGN.md specifies **Stage 4 Fnspec split** — `generate-fnspec-platform` (4a) + `generate-fnspec-integration` (4b); per-requirement `delivery: native-ai | api` tagging (the routing key for downstream stages); per-platform capability matrix as classifier input; cross-spec consistency check; either spec optional for single-track projects; legacy single fnspec retired.
- [x] **DESIGN-21**: DESIGN.md specifies **Stage 5 Tech spec scope gate** — required only when Stage 4b exists; lightweight platform-API addendum on Stage 4a when API-required portions exist on a platform-only build; covers error handling + observability + retries + idempotency for API portions; never hand-waves error paths.
- [ ] **DESIGN-22**: DESIGN.md specifies **Stage 6 Cost estimate design** — per-assignee task breakdown (dev / non-dev / QA / lead); `estimated_hours` + `risk_adjusted_hours` columns with mandatory `rationale` field; closed risk-multiplier taxonomy (default L=1.1 / M=1.3 / H=1.6 — flagged for dYdX-historical validation); schema-introspection of existing client task table cached in `00_HUB.md`; Coda writes via `rows/upsert` with `keyColumns` for idempotency, `mutationStatus` polling, rate-limit at 4 req/10s; wait-for-commercial-inputs gate before client-facing cost estimate generation.
- [ ] **DESIGN-23**: DESIGN.md specifies **Stage 7 Build prompts (dual)** — Stage 7a dev prompt (carry forward existing `generate-build-prompt`); Stage 7b implementation prompt (NEW; per-platform shape — Pipefy = Behaviors instructions + KB upload list; Wrike = workflow narrative for Copilot; Ziflow = checklist/criteria spec; NOT a universal template). Both prompts pull `delivery: native-ai | api` tagging straight from Stage 4a fnspec.
- [ ] **DESIGN-24**: DESIGN.md specifies **Stage 8 Test bot architecture** — `provision-test-harness` skill (8a) bootstraps once and updates each ship via delta against `client_state.yaml`; persistent harness lives at `<Client> Brain/test-bot/{client_state.yaml, test_runner.py, test_cases/}` (outside this repo); tier-1 deterministic Python (state/schema/equality/regex/retry/status-code class) + tier-2 AI orchestrator (free-form output, failure classification, remediation suggestion); layers don't overlap; `harness_drift` failure class added to `spec gap | implementation gap | environment issue | unknown`; `sandbox_lock.yaml` for concurrency; sandbox allowlist extended to Coda (CRIT-5 fix); test-case lifecycle states `active | obsolete | quarantined`. Stage 8b (test plan), 8c (UAT plan), 8d (execute-tests refactor with agent invocation) follow the same template structure as today, paths move to `<Client> Brain/test-bot/`.
- [ ] **DESIGN-25**: DESIGN.md specifies **Stage 9 Documentation publishing** — `update-documentation` skill writes `ChangeRequests/<CR>/doc-diff.md`; reviewer-approval gate before push; deterministic local→Drive folder/filename mapping; closed `doc_type` enum (`discovery | sow | platform_fnspec | integration_fnspec | tech_spec | test_plan | build_prompt | results | brain_spoke`); naming `<client_slug>__<project_slug>__<doc_type>__v<N>` (double-underscore separator); `doc_published_at` timestamp on Drive doc + frontmatter; halt condition if `00_HUB.md` `Documentation:` link missing (graceful — does not halt other stages).
- [ ] **DESIGN-26**: DESIGN.md specifies **Stage 10 Native-AI enablement** — `push-native-ai-knowledge` skill reads Stage 4a + approved Stage 9 doc fragments + per-platform `native-ai-inventory.md`; branches on `native_ai_path: api | paste | none`; copy-paste fallback is the default; refuses to ingest if `doc_published_at` < `last_diff_review_at` (CRIT-8 fix); per-client target ID in `00_HUB.md` `Pipefy AI:` / `Wrike AI:` blocks; refuses ingest if target mismatches `client:` frontmatter (MIN-4 fix); `doc_version: <semver>` + `ingested_at: <ISO>` per ingested doc.
- [ ] **DESIGN-27**: DESIGN.md specifies **Stage 11 Sign-off, brain update, archive** — `sign-off-and-archive` skill updates local `<Client> Brain/<spokes>/`; one-way push to Coda mirror with brain-mirror Coda doc template (Overview / Workflows / Platforms / Integrations / Operating Model / Change History / Field Notes); `tone_lint` pass before publish (MOD-9 prevention); CR move to `Archive/`; `00_Index.md` version bump; Field Notes table preserved (input-only, never overwritten); pre-archive sanity check (no orphan refs, no missing artefacts).

#### Test bot deeper specifics

- [ ] **DESIGN-28**: DESIGN.md specifies the **Python ↔ AI orchestrator boundary** — Python tier-1 asserts state, schema, presence/absence, equality, regex, retry-count, status-code class; AI tier-2 interprets free-form output, classifies failure causes, suggests remediation. Test plans mark each TC with the layer it belongs to. Mixed-layer cases flagged for human design.
- [ ] **DESIGN-29**: DESIGN.md specifies the **`client_state.yaml` schema** — sandbox tenant IDs (gated by platform), fixtures, integration toggles, `wrike_host`, `last_known_schema` per platform, `last_passed_at` per test case, `targets_artefact` per test case for obsolescence detection.
- [ ] **DESIGN-30**: DESIGN.md specifies the **drift detection algorithm** — pre-flight fetches current sandbox schema and diffs against `client_state.yaml.last_known_schema`; mismatch halts + emits `schema_drift_report.md` instead of executing; drift requires explicit human action (acknowledge or revert).

### Change list (CHANGELIST.md)

Sequenced, justified delta from v0.3.0 to v2.

- [ ] **CHANGE-01**: CHANGELIST.md presents the **9-phase build plan** with rationale per ordering, mapped to milestones (v2.1 = Foundations + Platform skills; v2.2 = Stage 1 + Stage 4 split; etc. — pending the user's milestone-sizing call). Each phase carries: deliverables, dependencies, addresses-which-requirements, avoids-which-pitfalls.
- [ ] **CHANGE-02**: CHANGELIST.md presents the **per-skill delta** — for every existing v0.3.0 skill, mark NEW / MODIFIED / RETIRED / UNCHANGED with the change description; for every NEW v2 skill, mark introduced-in-which-phase.
- [ ] **CHANGE-03**: CHANGELIST.md presents the **cosmetic-fix list** — version-string mismatches, README truncation, residual "test sheet" wording, missing `LICENSE`, owner-email mismatch — scheduled for the Phase 1 Foundations build (v2.1), out of design milestone scope.
- [ ] **CHANGE-04**: CHANGELIST.md flags **research-blocked phases** — Phase 1 (connector availability per tenant — Coda MCP version, Google Workspace MCP choice, Miro MCP existence, Wrike rate-limit currency, Ziflow auth header) and Phase 7 (native-AI ingestion paths per platform — single biggest unknown) — recommending `/gsd-research-phase` passes before those phases lock plans.
- [ ] **CHANGE-05**: CHANGELIST.md captures **migration cutover rules** — v2 readers tolerate v0.3.0 frontmatter via `frontmatter_version`; migration is opt-in per CR; `client_review` retained in canonical lifecycle; no auto-rewriting historical artefacts.

### Open questions register (OPEN-QUESTIONS.md)

Every "couldn't verify" + "needs human decision" surfaced and assigned an owner / phase.

- [ ] **OPEN-01**: OPEN-QUESTIONS.md catalogues **every "couldn't verify" item from research** with owning phase and verification owner — Pipefy AI KB content-upload endpoint, Wrike AI Studio knowledge-ingestion API, Ziflow ReviewAI knowledge-ingestion API, Pipefy GraphQL pagination cursor field names, Ziflow read-after-create consistency window, Pipefy/Wrike 2026 rate-limit currency, Miro export-whole-board endpoint availability, Claude in Chrome canonical product naming.
- [ ] **OPEN-02**: OPEN-QUESTIONS.md catalogues **connector-availability uncertainties** in this workspace — Coda MCP wired? Google Workspace MCP wired (which server)? Miro MCP wired (or paste-only)? — with the Phase 1 connector probe as the resolution path.
- [ ] **OPEN-03**: OPEN-QUESTIONS.md catalogues **design-decision-deferred items** that need human input before locking — risk-multiplier defaults validated against dYdX historicals (default 1.1/1.3/1.6 from research), frontmatter migration cutover date, status-lifecycle survey of live client folders to confirm no live `status:` value gets orphaned, plugin self-test scope (smoke tests for hooks + frontmatter validator vs none).
- [ ] **OPEN-04**: OPEN-QUESTIONS.md catalogues **hub-link backfill rollout coordination** with Jason's parallel workstream — list of clients whose `00_HUB.md` does/doesn't yet carry the `Documentation:` Drive link, expected backfill cadence, plugin behaviour for clients without the link (graceful halt at Stage 9 only).
- [ ] **OPEN-05**: OPEN-QUESTIONS.md catalogues **standard Coda templates v2 must author** — brain-mirror doc template (section per spoke + Field Notes table), task-table template for clients without a pre-existing one, default `00_HUB.md` Coda block schema (`coda_brain_doc:`, `coda_tasks_table:`, `coda_tasks_schema:` cache).
- [ ] **OPEN-06**: OPEN-QUESTIONS.md catalogues **`/refine-<skill>` resolution** — confirm "build single parameterised command" (recommended) or "delete every orphan reference"; if build, namespace decision (`/dydx-refine-*` vs `/refine-*`).
- [ ] **OPEN-07**: OPEN-QUESTIONS.md catalogues **plugin self-test scope** — smoke tests for hooks + frontmatter validator (recommended; `pytest` on the plugin's own correctness) vs defer; plugin ships v2.1 without self-tests.

---

## Future Requirements (deferred — v2.1+)

Build-phase requirements that will be defined in subsequent milestones once this milestone's design lands.

### v2.1 — Foundations (deferred)

- **FOUND-01**: Plugin-level `references/{safety-rules.md, stage-numbering.md, frontmatter-scheme.md, glossary.md}` written and authoritative
- **FOUND-02**: Existing 7 skills updated to point at canonical references (collapses 4 hard-rules duplicates; fixes sandbox-block bug; normalises `based_on_*` field names)
- **FOUND-03**: File renumbering 00→02 / 01→03 / 02→04 / 03→05 / 04→07a per architecture research mapping table
- **FOUND-04**: Plugin manifest `2.0.0` synced across `plugin.json` + `marketplace.json`; owner-email mismatch corrected; `LICENSE` file added
- **FOUND-05**: Empty `commands/`, `agents/`, `hooks/` scaffold directories created
- **FOUND-06**: Connector probe + graceful-degradation matrix codified
- **FOUND-07**: All cosmetic CONCERNS.md items cleaned (README truncation, "test sheet" wording residual)

### v2.2+ — Skill builds (deferred per CHANGE-01 phase plan)

- **PLAT-01..03**: Internalised `platform-pipefy`, `platform-wrike`, `platform-ziflow` skills (Phase 2)
- **STG1-01..02**: Stage 1 Kickoff capture skill + Stage 2 discovery refactor (Phase 3)
- **STG3-01**: Stage 3 SOW refactor (Phase 3)
- **STG4-01..02**: Stage 4 fnspec split (Phase 3)
- **STG5-01**: Stage 5 tech spec scope gate (Phase 4)
- **STG6-01..02**: Stage 6 cost estimate + Coda integration (Phase 4)
- **STG7-01..02**: Stage 7 dual build prompts (Phase 4)
- **STG8-01..04**: Stage 8 test bot rebuild (Phase 5)
- **STG9-01..02**: Stage 9 documentation publishing (Phase 6)
- **STG10-01..03**: Stage 10 native-AI enablement (Phase 7) — BLOCKED BY OPEN-01
- **STG11-01..03**: Stage 11 sign-off + brain mirror (Phase 8)
- **SURF-01..03**: Surfaces — `commands/`, agent wrapping, `hooks/` (Phase 9)

These are noted, not committed. The v2.0 milestone's CHANGELIST.md (CHANGE-01) is the authoritative sequence; these IDs become first-class requirements when the v2.1+ milestones inherit them.

---

## Out of Scope

Explicit exclusions for v2.0. These prevent scope creep into "Implementor Edition" and codify the synthesizer's anti-feature list.

| Feature / behaviour | Reason |
|---|---|
| Editing any v0.3.0 skill file in this milestone | Kickoff explicitly forbids skill edits in the design milestone |
| Replacing Cowork or Claude Code as the runtime | Out of scope per kickoff; runtime stays the same |
| Redesigning the per-client Brain pattern or workspace folder layout | Existing pattern is canonical; plugin adapts to it |
| Building net-new connectors (auth provider, custom MCPs) | Plugin uses connectors already wired in the workspace |
| Re-platforming existing clients off Pipefy/Wrike/Ziflow | Out of scope per kickoff |
| Two-way Coda↔local sync (Coda → local brain merge) | Local is canonical; Coda is one-way mirror; Field Notes is read-only triage |
| Auto-progression between stages on `status: approved` | Approval gates are non-negotiable; humans gate every stage |
| Auto-merging Field Notes into the brain | Field Notes is a triage queue; humans decide what's incorporated |
| Auto-rewriting historical v0.3.0 frontmatter during cutover | Risks corrupting in-flight client builds (CRIT-6) |
| Auto-progression hooks in `hooks/` | Anti-feature explicitly excluded; hooks are validation/version-bump only |
| Single-fnspec-for-everything (legacy v0.3.0 shape) | Retired in favour of Stage 4a/4b split |
| Universal non-dev implementation prompt across platforms | Per-platform shapes required; Pipefy ≠ Wrike ≠ Ziflow |
| Auto-publish cost estimate or doc to Drive without diff review | Defeats review gate |
| Native-AI implementation prompt requesting API access "just in case" | Splits the routing logic |
| Generating Python tier-1 tests from natural language alone | Tier-1 is human-authored; AI lives in tier-2 |
| Recreating the test-bot on each ship | Bot updates each ship via delta against `client_state.yaml`; never recreated |
| Production tenant access (any platform) | Sandbox-only enforcement preserved |
| Promising direct-API ingestion when only copy-paste works | Set expectations honestly per platform |
| Single universal AI-ingestion API abstraction | Each platform's shape is too different |
| Mirroring Drive doc version history outside Drive | Drive is source of truth for published; don't double-track |
| Custom MCP server for the test harness | Out of scope per kickoff |
| Inlining hard rules into every SKILL.md "for self-containment" | Single SoT pattern; skills point at canonical reference |
| Carrying `pipe_id`+`space_id` unconditionally | Must be platform-gated |

---

## Traceability

Updated during roadmap creation. Each requirement maps to exactly one phase.

| Requirement | Phase | Status |
|---|---|---|
| AUDIT-01 | Phase 1 | Complete (2026-05-09 — Plan 02) |
| AUDIT-02 | Phase 1 | Complete (2026-05-09 — Plan 09) |
| AUDIT-03 | Phase 1 | Complete (2026-05-09 — Plan 03) |
| AUDIT-04 | Phase 1 | Pending |
| AUDIT-05 | Phase 1 | Complete (2026-05-09 — Plan 05) |
| AUDIT-06 | Phase 1 | Pending |
| AUDIT-07 | Phase 1 | Complete (2026-05-09 — Plan 07) |
| AUDIT-08 | Phase 1 | Complete (2026-05-09 — Plan 08) |
| DESIGN-01 | Phase 2 | Complete (2026-05-09 — Plan 02-02) |
| DESIGN-02 | Phase 2 | Complete (2026-05-09 — Plan 02-02) |
| DESIGN-03 | Phase 2 | Complete (2026-05-09 — Plan 02-02) |
| DESIGN-04 | Phase 2 | Complete (2026-05-09 — Plan 02-02) |
| DESIGN-05 | Phase 2 | Complete (2026-05-09 — Plan 02-02) |
| DESIGN-06 | Phase 2 | Complete (2026-05-09 — Plan 02-02) |
| DESIGN-07 | Phase 2 | Complete (2026-05-09 — Plan 02-02) |
| DESIGN-08 | Phase 2 | Complete (2026-05-09 — Plan 02-02) |
| DESIGN-09 | Phase 2 | Complete (2026-05-09 — Plan 02-02) |
| DESIGN-10 | Phase 2 | Complete (2026-05-09 — Plan 02-02) |
| DESIGN-11 | Phase 2 | Pending |
| DESIGN-12 | Phase 2 | Pending |
| DESIGN-13 | Phase 2 | Pending |
| DESIGN-14 | Phase 2 | Pending |
| DESIGN-15 | Phase 2 | Pending |
| DESIGN-16 | Phase 2 | Pending |
| DESIGN-17 | Phase 2 | Complete (Plan 02-05) |
| DESIGN-18 | Phase 2 | Complete (Plan 02-05) |
| DESIGN-19 | Phase 2 | Complete (Plan 02-05) |
| DESIGN-20 | Phase 2 | Complete (Plan 02-06) |
| DESIGN-21 | Phase 2 | Complete (Plan 02-06) |
| DESIGN-22 | Phase 2 | Pending |
| DESIGN-23 | Phase 2 | Pending |
| DESIGN-24 | Phase 2 | Pending |
| DESIGN-25 | Phase 2 | Pending |
| DESIGN-26 | Phase 2 | Pending |
| DESIGN-27 | Phase 2 | Pending |
| DESIGN-28 | Phase 2 | Pending |
| DESIGN-29 | Phase 2 | Pending |
| DESIGN-30 | Phase 2 | Pending |
| CHANGE-01 | Phase 3 | Pending |
| CHANGE-02 | Phase 3 | Pending |
| CHANGE-03 | Phase 3 | Pending |
| CHANGE-04 | Phase 3 | Pending |
| CHANGE-05 | Phase 3 | Pending |
| OPEN-01 | Phase 4 | Pending |
| OPEN-02 | Phase 4 | Pending |
| OPEN-03 | Phase 4 | Pending |
| OPEN-04 | Phase 4 | Pending |
| OPEN-05 | Phase 4 | Pending |
| OPEN-06 | Phase 4 | Pending |
| OPEN-07 | Phase 4 | Pending |

**Coverage:**
- v2.0 requirements: 50 total (8 AUDIT + 30 DESIGN + 5 CHANGE + 7 OPEN)
- Mapped to phases: 50 (8 → Phase 1 / 30 → Phase 2 / 5 → Phase 3 / 7 → Phase 4)
- Unmapped: 0 ✓

---
*Requirements defined: 2026-05-09*
*Last updated: 2026-05-09 after roadmap lock — 4 phases, 50/50 mapped*
