# Phase 8: Stage 4 Fnspec Split + ROUTE (incl. TD-2 inline) - Context

**Gathered:** 2026-05-11
**Status:** Ready for planning

<domain>
## Phase Boundary

Build two NEW Stage 4 skills (`generate-fnspec-platform/` 4a + `generate-fnspec-integration/` 4b) that replace the retiring v0.3.0 `generate-functional-spec/`. Stage 4a emits `04a_fnspec-platform_v<N>.md` from approved discovery (`02_discovery_v*`) + approved SOW (`03_sow_v*`) + per-platform `references/native-ai-inventory.md`; every requirement row carries the `delivery: native-ai | api` routing key with confidence-tagged provenance. Stage 4b emits `04b_fnspec-integration_v<N>.md` from the same upstream inputs plus Stage 4a output, running three cross-spec consistency checks FIRST (before any write) and halting with `04b_consistency_check_v<N>.md` on any failure. The v0.3.0 `generate-functional-spec/` directory is removed; legacy artefacts remain readable via DESIGN-08 lenient mode. The cross-cutting ROUTE work resolves v2.1's TD-2 stage-skill enum reconciliation by adding `ziflow` to the `platform:` enum, emits the DESIGN-21 Stage 5 scope-gate frontmatter (`has_platform_api_addendum`, `tech_spec_scope`) + `## Platform-API Addendum` H2 body on 4a when the platform-only-with-API-rows topology applies, and ships a `phase8-structure-check.sh --section smoke` forward-compat assertion that proves the `delivery:` field survives at the canonical position through a synthetic Stage 5 / 6 / 7b / 10 consumer-stub read chain.

11 requirements: STG4-01..06 (Stage 4 split) + ROUTE-01..05 (routing key, consistency check, scope-gate, TD-2, forward-compat smoke).

</domain>

<decisions>
## Implementation Decisions

### TD-2 + ROUTE-03 addendum carrier

- **D-78 — TD-2 resolution: ADD `ziflow` to stage-skill `platform:` enum.**
  The stage-skill `platform:` enum migrates from `pipefy | wrike | other` to `pipefy | wrike | ziflow | other` across every stage SKILL.md that declares the enum (`generate-fnspec-platform/SKILL.md`, `generate-fnspec-integration/SKILL.md`, plus every existing stage skill whose frontmatter declares `platform:`). `platform-ziflow/SKILL.md:14`'s pre-existing routing-key claim is retained — D-78 finally wires it through. The glossary routing-key entry at `dydx-delivery/references/glossary.md` is updated to enumerate `pipefy | wrike | ziflow | other` with one-line definitions per platform. Resolution is captured as a sub-decision under DESIGN-20 (Stage 4 split contract) on update. **Rationale.** Ziflow is the only proof-review tier-1 platform and locking it into the routing-key enum future-proofs proof-review-led engagements; the alternative (document Ziflow as integration-only) was rejected because it would preclude Ziflow-primary projects without a structural reason. Touches are mechanical and enumerable by the planner during 08-03.

- **D-79 — ROUTE-03 addendum body: Stage 4a authors the `## Platform-API Addendum` H2 body inline in v2.2.**
  When (no 4b in scope) AND (4a has any `delivery: api` rows), `generate-fnspec-platform/SKILL.md` instructs the skill to author the FULL `## Platform-API Addendum` H2 body (carrying the same error-paths discipline as a full tech spec for the API portions only), append it INSIDE `04a_fnspec-platform_v<N>.md`, and emit frontmatter `has_platform_api_addendum: true` + `tech_spec_scope: platform-api-addendum-only`. v2.3 Stage 5 will read these frontmatter fields, skip writing `05_techspec_v<N>.md`, and consume the addendum body verbatim. The addendum-body skeleton lives in `generate-fnspec-platform/references/addendum-template.md` (D-83 file #3). **Rationale.** ROADMAP success criterion 4(b) explicitly mentions "4a carries `## Platform-API Addendum` H2"; the stub-and-defer-to-v2.3 alternative would produce incomplete v2.2 artefacts on the platform-only path until v2.3 ships. Tight DESIGN-21 wording ("addendum carries the same error-paths discipline as a full tech spec") matches author-now intent.

### Plan slicing + wave parallelism

- **D-80 — Three atomic plans, sequential (D-69 / D-63 precedent).**
  - **08-01** = `generate-fnspec-platform/` (Stage 4a). Requirements: STG4-01 (skill exists at canonical path with template + rubric + addendum-template references), STG4-04 (4a half — `delivery: native-ai | api` canonical-order tagging on every requirement row), STG4-05 (HIGH/MED → suggest native-ai, LOW/`[OPEN]` → default api, reviewer-override-per-row preserved on re-run), ROUTE-03 (4a half — D-79 addendum body authorship + frontmatter emission).
  - **08-02** = `generate-fnspec-integration/` (Stage 4b). Requirements: STG4-02 (skill exists at canonical path with template + consistency-rules + either-spec-skip-paths references), STG4-04 (4b half — same routing-key tagging on 4b rows), ROUTE-01 (three consistency checks owned by 4b, two-place key-decisions declaration), ROUTE-02 (halt + emit `04b_consistency_check_v<N>.md` on failure), ROUTE-03 (4b half — consume `has_platform_api_addendum:` from 4a frontmatter on read). **Depends on 08-01** — 4b reads approved 4a output as upstream; cannot start in parallel.
  - **08-03** = retire + cross-cutting closeout. Requirements: STG4-03 (remove `generate-functional-spec/` directory; update v0.3.0 templates / READMEs / changelogs to reference 4a + 4b), STG4-06 (document three topologies in both skill bodies — 4a-only / 4b-only / both — per `either-spec-skip-paths.md`), ROUTE-04 (D-78 ziflow enum rollout across all stage SKILL.md frontmatter examples + `platform-ziflow/SKILL.md:14` retention check + glossary routing-key entry update + DESIGN-20 sub-decision note), ROUTE-05 (forward-compat smoke check — D-86), REQUIREMENTS.md flips for all 11 rows, `phase8-structure-check.sh` (D-77 `--section` partitioning).
  - **No parallel waves.** 08-01 must complete before 08-02 (dependency); 08-03 must complete after both (lifts REQUIREMENTS flips + retirement + smoke from 4a + 4b outputs).
  **Rationale.** Mirrors v2.1 D-63 ("reviewer grades a whole platform / skill at a time") and Phase 7 D-69 ("3 per-skill atomic plans"). The 4-plan alternative (split ROUTE-04 enum work into its own Wave-1-parallel plan) was rejected because the enum touch-list is mechanical and bundling it into 08-03 keeps the cross-cutting closeout in one reviewable unit.

### Skill internals — rubric + markup + refs shape

- **D-81 — Classifier rubric per-skill at `generate-fnspec-platform/references/auto-classify-rubric.md` (D-73 precedent).**
  Carries explicit rules + escalation table mapping HIGH / MEDIUM → suggest `delivery: native-ai`, LOW / `[OPEN]` → default `delivery: api`; reviewer-override-per-row mechanics; re-run preservation rule (rows carrying `[reviewer-override: ...]` markup are NOT re-classified). Stage 4a SKILL.md cites the rubric file. Stage 4b does NOT carry its own rubric — it reads 4a's per-row tags as-is. **Rationale.** Phase 7 D-73 set the precedent that auto-classification rubrics live next to the skill that uses them; extracting to a reference (vs inline-in-SKILL.md) keeps the rubric editable without re-reading the whole skill. Shared-plugin-level alternative was rejected because v2.2 has no other consumer of the rubric.

- **D-82 — Per-row markup: terse inline marker `delivery: native-ai [HIGH, src: platform-pipefy]`.**
  Every requirement row in `04a_fnspec-platform_v<N>.md` carries `delivery: native-ai | api` (canonical order, never reversed — STG4-04 lock) followed by a bracketed suffix encoding confidence + source: `[HIGH, src: platform-pipefy]`, `[MEDIUM, src: platform-wrike]`, `[LOW → default api, src: platform-ziflow]`, or `[reviewer-override: api]` after human edit. Re-run preserves reviewer overrides by detecting the `[reviewer-override:]` token verbatim — overridden rows are never re-classified. Greppable; provenance fits in one line; mirrors Phase 7 STG1-04 `[unknown — needs human classification]` marker idiom. **Rationale.** Verbose HTML-comment-block alternative was rejected because it doubles line count and HTML comments don't always survive the v2.5+ Coda one-way mirror (DESIGN-09). Minimal `delivery: X`-only alternative was rejected because losing confidence + source signal makes re-run reviewer-override detection unreliable on LOW rows.

- **D-83 — references/ shape: 3 files per skill (D-71 precedent).**
  - **`generate-fnspec-platform/references/`** — (1) `fnspec-platform-template.md` (artefact skeleton: frontmatter contract incl. `delivery:` row markup + canonical H2 sections + handoff message); (2) `auto-classify-rubric.md` (D-81); (3) `addendum-template.md` (`## Platform-API Addendum` H2 body skeleton for D-79 — frontmatter + error-paths discipline structure for API portions).
  - **`generate-fnspec-integration/references/`** — (1) `fnspec-integration-template.md` (artefact skeleton: integration touchpoints + API-endpoint section + `based_on_fnspec_platform:` frontmatter); (2) `consistency-rules.md` (three checks + halt-on-failure protocol + `04b_consistency_check_v<N>.md` failure-report template); (3) `either-spec-skip-paths.md` (STG4-06 three-topology rules: 4a-only / 4b-only / both — input detection + verbatim skip-emit strings for D-85).
  **Rationale.** Mirrors Phase 7 D-71 (kickoff-capture 3-file references shape). The 2-file alternatives bloat the main template or conflate concerns (consistency vs topology); the asymmetric 3+2 alternative breaks symmetry between sibling skills.

### Cross-spec wiring — consistency + skip + smoke

- **D-84 — Consistency check form: SKILL.md prose contract + `references/consistency-rules.md`.**
  Stage 4b SKILL.md states the behavioural contract — "run the three checks FIRST, before any 4b write; on any failure emit `04b_consistency_check_v<N>.md` listing the failure rows and HALT (do not write `04b_fnspec-integration_v*.md`); reviewer must resolve before retry." Detailed rules + failure-report template + the three explicit checks (a: no requirement ID with conflicting `delivery:` tags across 4a and 4b; b: every integration touchpoint in 4b cites a referenced platform requirement ID from 4a; c: no orphan API endpoints in 4b — every endpoint maps to a requirement) live in `generate-fnspec-integration/references/consistency-rules.md`. Two-place declaration in 4a + 4b key-decisions sections per T-02-06-02 mitigation. No shell script. **Rationale.** D-77 distinguishes PHASE-GATE structure checks (script form, e.g., `phase8-structure-check.sh`) from RUNTIME-SKILL checks (prose form, LLM-executed). All v0.3.0 / v2.1 / v2.2 skill-internal checks have been prose-only; adding a script here would introduce an inconsistent runtime pattern.

- **D-85 — Either-spec-skip mechanics: verbatim skip logs, stdout-only, no skip-marker file written (D-74 precedent).**
  - **Stage 4a** runs normally — 4a is upstream-independent of 4b. There is no "skip 4a" path; 4a being out of scope means the reviewer simply does not invoke it.
  - **Stage 4b** detects either-spec-skip topology by combining (a) presence/absence of `04a_fnspec-platform_v*.md` in the project folder, (b) `## Platform Scope` / `## Integration Scope` H2s in the highest-version `03_sow_v*.md` (STG3-02 / D-75 signal), (c) explicit reviewer signal at skill invocation when ambiguous. When 4b is determined out of scope (no platform fnspec to integrate with OR explicit reviewer signal), 4b emits the verbatim string `Stage 4b SKIPPED — no integration work in scope` to stdout, writes NO `04b_*` artefact, and exits. Topology rules + verbatim skip-emit strings live in `either-spec-skip-paths.md` (D-83 file #3). **Rationale.** Mirrors Phase 7 D-74 (`discovery-intake` skip-emit = pure stdout, no file written). Skip-marker-file alternative was rejected because it introduces a new file convention; reviewer-prompt-at-invocation alternative was rejected as extra friction when SOW H2s already carry the signal.

- **D-86 — Forward-compat smoke: `phase8-structure-check.sh --section smoke` + fixture stubs (D-77 precedent).**
  ROUTE-05 verification ships in plan 08-03 as a partition of `phase8-structure-check.sh`. The `--section smoke` assertion loads sample `04a_fnspec-platform_v*.md` + `04b_fnspec-integration_v*.md` fixtures (written during 08-01 / 08-02 e2e smoke into `fixtures/output/`, mirroring Phase 7 07-04-SUMMARY.md pattern), reads each requirement row through a synthetic Stage 5 / 6 / 7b / 10 consumer-stub (minimal shell `grep` + `awk` functions that read frontmatter + iterate rows and re-emit them), and grep-asserts `delivery: native-ai | api` survives at the canonical position with no field stripping, no position drift, and no enum reorder on every requirement row through the full `based_on_*` chain. **Rationale.** Mirrors Phase 7 D-77 (single structure-check.sh with `--section` partitioning) + the manual e2e smoke evidence pattern (07-04-SUMMARY.md). Pytest alternative was rejected as scope creep — `dydx-delivery/tests/` doesn't exist yet (per `.planning/codebase/TESTING.md`); introducing pytest infra now goes beyond v2.2 stated need. Manual-only alternative was rejected because ROUTE-05 verification should survive future regressions without depending on human discipline at every release.

### Claude's Discretion

- Detailed body wording inside `fnspec-platform-template.md`, `fnspec-integration-template.md`, and `addendum-template.md` — planner authors from STG4 + DESIGN-20 + DESIGN-21 contracts; only the section-shape + frontmatter contract + handoff-message anchors are locked.
- Exact wording inside `auto-classify-rubric.md` escalation thresholds (e.g., "MEDIUM = ≥2 distinct verified MCP probes" vs "≥3") — planner picks during research, can be adjusted at execute time within D-81's rule shape.
- Specific failure-row template inside `consistency-rules.md` `04b_consistency_check_v<N>.md` — planner authors; only the halt-on-failure contract + the three checks are locked.
- The exact verbatim skip-emit string for D-85 (`Stage 4b SKIPPED — no integration work in scope` is the working default; planner may adjust phrasing if research surfaces a better idiom, but must lock one verbatim string before execute).
- Per-skill plan-task counts inside each of 08-01 / 08-02 / 08-03 — planner discretion at `/gsd-plan-phase` time.
- Whether plan 08-03 splits to 08-04 (Phase 7 D-69 ~400 LOC heuristic) — planner enforces threshold at plan time.
- Exact wording of synthetic Stage 5/6/7b/10 consumer-stub shell functions inside `phase8-structure-check.sh --section smoke` — planner authors from D-86 contract.
- Whether the planner surfaces any STG4 / ROUTE OPEN-Q rows during 08-01 / 08-02 research — researcher checks; resolution inline per D-67.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Locked design contracts

- `.planning/DESIGN.md` §DESIGN-20 — Stage 4 split contract: `generate-fnspec-platform/` (4a) + `generate-fnspec-integration/` (4b); per-requirement `delivery: native-ai | api` routing key; three cross-spec consistency checks; two-place key-decisions declaration in 4a + 4b. **D-78 will land as a sub-decision under DESIGN-20 on update.**
- `.planning/DESIGN.md` §DESIGN-21 — Stage 5 scope-gate contract: three branches (full / skip-with-addendum / skip-entirely); frontmatter fields `has_platform_api_addendum`, `tech_spec_scope`, `## Platform-API Addendum` H2 carrier. v2.2 emits frontmatter; v2.3 consumes.
- `.planning/DESIGN.md` §DESIGN-14 / §DESIGN-15 / §DESIGN-16 — Per-platform `native-ai-inventory.md` is the classifier input for `delivery:` row tagging (Pipefy / Wrike / Ziflow).
- `.planning/DESIGN.md` §DESIGN-02 — Stage-numbering scheme: file-prefix = stage number; substages `4a/4b`; canonical at `dydx-delivery/references/stage-numbering.md`. Artefact filenames `04a_fnspec-platform_v<N>.md`, `04b_fnspec-integration_v<N>.md`, `04b_consistency_check_v<N>.md`.
- `.planning/DESIGN.md` §DESIGN-08 — Frontmatter migration co-existence: legacy `04_functional-spec_v*.md` / `02_functional-spec_v*.md` remain readable via lenient mode; no auto-migration of existing artefacts.
- `.planning/DESIGN.md` §DESIGN-01 — Canonical frontmatter scheme: `frontmatter_version: 2`, status lifecycle `draft → client_review → approved → archived`, underscore-snake-case keys, platform-gated identifiers.
- `.planning/DESIGN.md` §DESIGN-06 — Approval-gate enforcement: mandatory `approved_by` + `approved_at` on `status: approved` writes (consumed by the v2.1 `validate-frontmatter` hook).

### Requirements

- `.planning/REQUIREMENTS.md` §"Stage 4 Fnspec Split (STG4)" — STG4-01..06 (6 rows).
- `.planning/REQUIREMENTS.md` §"Routing key + Cross-spec consistency check + TD-2 (ROUTE)" — ROUTE-01..05 (5 rows).
- `.planning/REQUIREMENTS.md` §"Traceability" — STG4-01..06 + ROUTE-01..05 mapped to Phase 8.
- `.planning/ROADMAP.md` §"Phase 8: Stage 4 Fnspec Split + ROUTE" — phase Goal + 6 Success Criteria.

### Prior phase context (carried forward — do NOT re-derive)

- `.planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/07-CONTEXT.md`
  - **D-69** — 3 per-skill atomic plans (precedent applied as D-80).
  - **D-71** — kickoff-capture 3-file `references/` shape (precedent applied as D-83).
  - **D-73** — auto-classify rubric extracted to `references/auto-classify-rubric.md` (precedent applied as D-81).
  - **D-74** — `discovery-intake` skip-emit = pure stdout, no file written (precedent applied as D-85).
  - **D-75** — SOW `## Platform Scope` + `## Integration Scope` H2s (D-85 reads these as topology signal).
  - **D-76** — lenient v0.3.0 reconciliation; enforce new frontmatter on NEW writes only (D-78 ziflow enum rollout follows: enforce on NEW + actively-edited frontmatter only; in-flight artefacts NEVER auto-flip per DESIGN-08).
  - **D-77** — single `phase<N>-structure-check.sh` with `--section` partitioning (precedent applied as `phase8-structure-check.sh` covering 4a / 4b / route / smoke sections + `--all` cross-section asserts; D-86 smoke section lives here).
- `.planning/milestones/v2.1-phases/05-foundations/05-CONTEXT.md` — D-56 (connector-matrix doc-only), D-57 (inline OPEN-Q resolution per D-67), D-62 (lift-and-fix precedent for retirement-and-replacement).
- `.planning/milestones/v2.1-phases/06-internalise-platform-skills/06-CONTEXT.md` — D-63 (3 per-platform atomic plans = D-69 / D-80 precedent), D-67 (per-phase OPEN-Q resolution inherited).
- `.planning/milestones/v2.1-RETROSPECTIVE.md` — v2.1 lessons applied to v2.2: auto-flip REQUIREMENTS.md trace on completion, per-phase structure-check with `--section` for parallel/sequential waves.

### Plugin canonical references (FOUND-01..04 outputs)

- `dydx-delivery/references/safety-rules.md` — Hard-rules SoT (DESIGN-03). Both 4a + 4b SKILL.md MUST cite this verbatim in canonical-pointer sentence (Phase 6 FOUND-04 pattern).
- `dydx-delivery/references/stage-numbering.md` — File-prefix scheme (DESIGN-02). Both SKILL.md cite.
- `dydx-delivery/references/frontmatter-scheme.md` — Canonical frontmatter (DESIGN-01). Both SKILL.md cite.
- `dydx-delivery/references/glossary.md` — Project-wide glossary; routing-key entry gains `pipefy | wrike | ziflow | other` enum on D-78 rollout (08-03 deliverable).

### Existing skill targets (the things this phase WRITES TO / CREATES / RETIRES)

- `dydx-delivery/skills/generate-functional-spec/` — RETIRED on 08-03 per STG4-03. Directory removed; legacy artefacts readable via DESIGN-08 lenient mode.
- `dydx-delivery/skills/generate-fnspec-platform/` (NEW path) — created by 08-01 per STG4-01 + D-83.
- `dydx-delivery/skills/generate-fnspec-integration/` (NEW path) — created by 08-02 per STG4-02 + D-83.
- `dydx-delivery/skills/platform-pipefy/references/native-ai-inventory.md` — classifier input for D-82 / STG4-05 (read-only).
- `dydx-delivery/skills/platform-wrike/references/native-ai-inventory.md` — classifier input (read-only).
- `dydx-delivery/skills/platform-ziflow/references/native-ai-inventory.md` — classifier input (read-only).
- `dydx-delivery/skills/platform-ziflow/SKILL.md` line 14 — routing-key claim retained on D-78 path (a); cross-check during 08-03 ROUTE-04 step.
- Every existing stage SKILL.md declaring the `platform:` enum (e.g., `dydx-delivery/skills/generate-sow/SKILL.md`, `dydx-delivery/skills/generate-build-prompt/SKILL.md`, all other stage skills) — D-78 enum-rollout touch-list during 08-03; planner enumerates exact files at plan time.

### Codebase intel

- `.planning/codebase/STRUCTURE.md` — Plugin directory layout; skill conventions (SKILL.md + references/).
- `.planning/codebase/CONVENTIONS.md` — Canonical-pointer sentence pattern (FOUND-04); frontmatter discipline.
- `.planning/codebase/TESTING.md` — "No traditional code testing"; structure-check shell scripts (D-77 / D-86) and prose-form skill-internal checks (D-84) are the only check forms in use.

### Project-level locks (carried forward — DO NOT re-litigate)

- `.planning/PROJECT.md` §"Key Decisions" — Brownfield framing; platform skills internal to plugin; Coda hard dependency (v2.4+); local-canonical / Coda-mirror direction; Webhook-PRIMARY (Q05); `tier_claims_last_verified:` per-platform (MOD-7).
- `.planning/PROJECT.md` §"Out of Scope" — Stage 5 actual consumption (lives in v2.3); native-AI knowledge upload non-human-paste (deferred).

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets

- `dydx-delivery/skills/generate-functional-spec/SKILL.md` v0.3.0 body — the RETIRING skill; harvest the platform-agnostic functional-spec section structure (user journeys + business rules + field-level requirements + edge cases + acceptance criteria + 5-question senior challenge + handoff-message shape) as the lift-and-adapt base for both `fnspec-platform-template.md` and `fnspec-integration-template.md`. Split: 4a takes platform configuration (workflow / fields / states / rules) + the new `delivery:` row markup; 4b takes integrations (touchpoints / API endpoints / data flow) + per-row `delivery:` markup + consistency-check protocol. Removed before phase close per STG4-03.
- `dydx-delivery/skills/generate-functional-spec/references/` — current 7-file shape (template + section guidance files). Lift the structural-section files into the new 4a / 4b templates; do NOT preserve the old references/ shape (D-83 specifies 3 files per skill, not 7).
- `.planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/scripts/phase7-structure-check.sh` — direct template for D-86 `phase8-structure-check.sh`. Lift-and-adapt: replace `--section <kickoff|discovery|sow>` partitioning with `--section <4a|4b|route|smoke>`, swap assertion blocks per D-86 spec.
- `dydx-delivery/skills/kickoff-capture/SKILL.md` + `references/auto-classify-rubric.md` — direct template for D-81 (per-skill auto-classify rubric structure: explicit rules + escalation table + reviewer-override mechanics).
- `dydx-delivery/skills/discovery-intake/SKILL.md` skip-emit body — direct template for D-85 (verbatim skip-string + stdout-only emission protocol).
- `dydx-delivery/skills/generate-sow/SKILL.md` `## Platform Scope` + `## Integration Scope` H2s — read by D-85 as the topology-detection signal for either-spec-skip; do NOT modify in Phase 8 (they're locked by Phase 7 D-75).
- `dydx-delivery/skills/platform-pipefy/references/native-ai-inventory.md` (+ wrike, ziflow) — Phase 6 outputs carrying HIGH / MEDIUM / LOW / `[OPEN]` confidence rows that D-81 / D-82 / STG4-05 consume read-only.

### Established Patterns

- **Canonical-pointer sentence (Phase 6 FOUND-04).** Every new SKILL.md opens with the verbatim sentence pattern citing `safety-rules.md` + `stage-numbering.md` + `frontmatter-scheme.md` + `glossary.md`. Both 08-01 and 08-02 SKILL.md MUST follow.
- **Frontmatter contract section.** Each SKILL.md declares its input + output frontmatter contract in a dedicated section (Phase 7 pattern). 4a declares: input `02_discovery_v*.md` + `03_sow_v*.md` + per-platform `native-ai-inventory.md`; output `04a_fnspec-platform_v<N>.md` carrying `frontmatter_version: 2`, `client`, `project`, `platform: pipefy | wrike | ziflow | other`, `based_on_discovery:`, `based_on_sow:`, `has_platform_api_addendum:` (conditional, D-79), `tech_spec_scope:` (conditional, D-79), `status: draft → client_review → approved → archived`, `approved_by` + `approved_at` (on approved writes). 4b mirrors with `based_on_fnspec_platform:` + integration-specific fields.
- **Status lifecycle 4-state.** `draft → client_review → approved → archived` (DESIGN-01 + DESIGN-08 + Phase 7 D-75). Both 4a + 4b carry it verbatim.
- **Lenient-read on legacy filenames (Phase 7 D-76).** Skills that read upstream artefacts MUST tolerate v0.3.0 filename variants without auto-migration. For 4b reading 4a's output, lenient-read does NOT apply (4a is v2.2-NEW); for any downstream reader of v0.3.0 `04_functional-spec_v*.md`, lenient-read applies per DESIGN-08.
- **Per-section structure-check (D-77 → D-86).** `phase8-structure-check.sh --section <4a|4b|route|smoke>` with `--all` cross-section asserts. Each plan self-verifies its section at execute close; 08-03 runs `--all` as the e2e smoke gate.
- **Skip-emit = stdout-only (Phase 7 D-74 → D-85).** No skip-marker file; verbatim string to stdout; topology rules in a dedicated references file.
- **Auto-classification rubric extracted to references/ (Phase 7 D-73 → D-81).** Inline-in-SKILL.md is discouraged; extracted reference + explicit citation in SKILL.md body is canon.

### Integration Points

- **Upstream read (4a + 4b).** Both skills consume approved `02_discovery_v*.md` (`status: approved` enforced) + approved `03_sow_v*.md`. 4b additionally consumes approved `04a_fnspec-platform_v*.md` (when present per D-85 topology rules). Frontmatter `based_on_*` chain is the lineage primitive (DESIGN-08).
- **Per-platform inventory read (4a).** 4a loads the active platform skill's `references/native-ai-inventory.md` based on the `platform:` enum value (D-78 expanded to include `ziflow`). The HIGH / MEDIUM / LOW / `[OPEN]` confidence rows feed D-82 row-markup directly.
- **Forward-emit (4a + 4b → Stage 5 / 6 / 7b / 10).** `delivery:` row markup + scope-gate frontmatter (`has_platform_api_addendum`, `tech_spec_scope`) are emitted by 4a / 4b but NOT consumed in v2.2; v2.3+ Stage 5 reads them. ROUTE-05 forward-compat smoke (D-86) is the only v2.2 consumer (synthetic stubs).
- **Glossary update (08-03 ROUTE-04).** `dydx-delivery/references/glossary.md` routing-key entry adds `ziflow` per D-78; glossary already exists as a v2.1 plugin canonical reference (FOUND-04 output).
- **REQUIREMENTS.md auto-flip (08-03 close).** All 11 rows (STG4-01..06 + ROUTE-01..05) flip `Pending` → `Satisfied` in REQUIREMENTS.md `## Traceability` table on phase verification, per v2.1 retrospective pattern.

</code_context>

<specifics>
## Specific Ideas

- **Exact `delivery:` row markup format (D-82).** `delivery: native-ai [HIGH, src: platform-pipefy]` is the canonical idiom. Suffix variants: `[MEDIUM, src: <platform>]`, `[LOW → default api, src: <platform>]`, `[reviewer-override: native-ai]` / `[reviewer-override: api]`. The arrow `→` is unicode verbatim (matches Phase 7 D-75 / DESIGN-01 verbatim-arrow precedent). The bracket token `[reviewer-override:]` is the re-run detection trigger — never re-classify a row carrying this marker.
- **Verbatim skip-emit string for D-85.** Working default: `Stage 4b SKIPPED — no integration work in scope` (mirrors Phase 7 D-74's `Stage 2 SKIPPED — kickoff branch = draft-sow` structure with unicode em-dash). Locked-verbatim once chosen during 08-02 planning.
- **Synthetic consumer-stub shape for D-86 smoke.** A minimal shell function per downstream stage that reads frontmatter via `sed -n '/^---/,/^---/p'` and iterates rows via `awk` / `grep` to re-emit the `delivery:` field. Asserted with grep on the re-emitted output. No real Stage 5 / 6 / 7b / 10 skill files referenced — pure stub.
- **Two-place key-decisions declaration (ROUTE-01 T-02-06-02 mitigation).** Both `generate-fnspec-platform/SKILL.md` and `generate-fnspec-integration/SKILL.md` carry a `## Key decisions` section explicitly naming D-78 (TD-2 / ziflow) + D-79 (addendum carrier) + D-82 (row markup) + D-84 (consistency check ownership) + D-85 (skip mechanics). Cross-reference avoids single-source drift.
- **Fixture output dir (Phase 7 07-04 pattern).** Plans 08-01 / 08-02 / 08-03 capture e2e smoke artefacts under `.planning/phases/08-stage-4-fnspec-split-route/fixtures/output/` using `sample-CR` style filename conventions (Phase 7 precedent: `01_kickoff_v1.md`, `02_discovery_v1.md`, etc.). D-86 smoke section asserts against these.

</specifics>

<deferred>
## Deferred Ideas

- **Stage 5 actual consumption** of `has_platform_api_addendum:` / `tech_spec_scope:` / `## Platform-API Addendum` H2 — lives in v2.3 per ROUTE-03 wording. v2.2 emits the interface only.
- **Stage 6 cost-estimate consumption** of `delivery:` routing key — v2.3 per ROUTE-05.
- **Stage 7b implementation-prompt consumption** of `delivery:` routing key — v2.3 per ROUTE-05.
- **Stage 10 push-native-ai-knowledge consumption** of `delivery:` routing key — v2.5+ per ROUTE-05 + Stage 10 milestone.
- **Stage 9 documentation publishing** (`update-documentation/`) — separate v2.5 milestone (STG9-01..02).
- **Test bot rebuild + persistent harness** — v2.4+ Stage 8 milestone.
- **Coda mirror / Coda hard dependency** — lands in v2.4+ when Stage 6 cost + Stage 11 archive consume Coda.
- **DESIGN-25 closed `doc_type` 9-enum** — Stage 9 v2.5 scope; out of v2.2.
- **Auto-migration of v0.3.0 `04_functional-spec_v*.md` artefacts to new 4a / 4b filename scheme** — explicitly out per STG4-03 ("no auto-migration"); legacy artefacts remain readable via lenient mode (DESIGN-08).
- **Pytest-based test runner in `dydx-delivery/tests/`** — DESIGN-04 D-24 mentions pytest self-tests as future surface; v2.2 D-86 uses structure-check.sh shell pattern, not pytest. Pytest infra deferred until a future milestone needs more than gate-form assertions.

</deferred>

---

*Phase: 8-stage-4-fnspec-split-route*
*Context gathered: 2026-05-11*
