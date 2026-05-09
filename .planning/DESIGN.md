# Design: dydx-delivery v2.0 — Implementor Edition architecture

**Design Date:** 2026-05-09
**Branch / commit:** dydx-delivery-v2 / (record current commit at synthesis plan)
**Phase 1 Audit (ground truth):** `.planning/AUDIT.md` (approved 2026-05-09)

> **How to read this design.** This document locks the v2 architecture for the dydx-delivery plugin so the v2.1+ rebuild can execute without re-deciding. Each major section opens with a one-line success-criteria echo (`> **DESIGN-NN:** <plain-English statement>`) so reviewer can match section to REQUIREMENTS.md without cross-referencing. Inline `[OPEN: Phase 4 — ...]` markers flag undecided contracts; the closing `## Deferred to Phase 4 OPEN-QUESTIONS` section enumerates every marker for Phase 4 register handoff. Citations use `file:line` format (Phase 1 D-14 convention). DESIGN.md cites `AUDIT.md §X.Y` for v0.3.0 facts (Phase 2 D-34) — does NOT re-derive observations from v0.3.0 source.
>
> (Preamble placeholder — finalised in synthesis plan 02-10)

## Executive Summary

(Executive summary table placeholder — populated in synthesis plan 02-10. Acts as TOC: per-section page-anchor + one-line decision summary so reader can skip-to-contract.)

---

## Cross-cutting decisions

These ten cross-cutting decisions ground every later section. Each is locked here as a contract — substages that depend on a contract cite it back rather than re-arguing the decision. Per D-19, this section opens with a scannable decision-summary table; per-decision prose follows under H3 anchors below.

frontmatter_version: 2

| ID | Decision area | Locked contract (one line) | Locking decision |
|----|---------------|-----------------------------|------------------|
| DESIGN-01 | Frontmatter scheme | `frontmatter_version: 2`; status `draft → client_review → approved → archived`; underscore-snake-case keys; platform-gated identifiers | D-25 (survey) |
| DESIGN-02 | Stage numbering | File-prefix = stage number `01..11`; substages `4a/4b/7a/7b/8a..8d`; canonical at `dydx-delivery/references/stage-numbering.md` | — |
| DESIGN-03 | Hard-rules SoT | Single SoT at `dydx-delivery/references/safety-rules.md` + per-client `safety-overrides.yaml` overlay (only `overridable: true` fields) | AUDIT.md §AUDIT-05 (4 hard-rules duplicates collapsed) |
| DESIGN-04 | Plugin surfaces | `commands/`: 1 parameterised `refine.md` + 4 GSD shortcuts; `agents/`: 1 test-bot-orchestrator; `hooks/`: 2 (`validate-frontmatter` + `bump-artefact-version`, NOT auto-progression); `mcpServers` field; manifest `2.0.0`; pytest self-tests at `dydx-delivery/tests/` per D-24 | D-24 |
| DESIGN-05 | `/refine-<skill>` resolution | Single parameterised `commands/refine.md` taking skill name as `$1`; namespace `/dydx-refine-*` (NOT bare `/refine-*`) | D-23 |
| DESIGN-06 | Approval-gate enforcement | Mandatory `approved_by` + `approved_at` on `status: approved` writes; hook refuses writes lacking these fields | — |
| DESIGN-07 | Connector probe + degradation | Session-start MCP probe + per-stage fallback per AUDIT.md §AUDIT-03 PITFALLS-cited fallback table | AUDIT.md §AUDIT-03 |
| DESIGN-08 | Frontmatter migration co-existence | CR-driven opt-in; `client_review` retained (live in `generate-sow`); v0.3.0 absent → lenient mode; in-flight artefacts NEVER auto-flip | D-25 (survey result locks) |
| DESIGN-09 | Directional boundary | Local `<Client> Brain/` canonical; Coda one-way mirror; Field Notes read-only triage queue; never auto-merged | — |
| DESIGN-10 | Persona contract | ~5 senior-implementer voice principles + forbidden-phrasings list inline; 3 worked before/after examples in Appendix C | D-29 |

### DESIGN-01 — Canonical frontmatter scheme

> **DESIGN-01:** Canonical frontmatter scheme — status lifecycle, field-name convention, platform-gated identifiers, frontmatter_version semantics.

**Contract.**

- `frontmatter_version: 2` is mandatory on every new artefact written by a v2 skill. Absent value → v0.3.0 lenient mode (per DESIGN-08).
- Status lifecycle (canonical): `draft → client_review → approved → archived`. `client_review` is retained per AUDIT.md §AUDIT-01.2 (live in `dydx-delivery/skills/generate-sow/SKILL.md:93`); see `### Live status-lifecycle survey` above for the reconciliation confirming no live value is orphaned.
- Field-name convention: underscore-snake-case for keys (`based_on_kickoff`, `pipe_id`, `approved_by`, `approved_at`, `tier_claims_last_verified`); hyphen-kebab-case for file paths inside `based_on_*` values (`02_kickoff_v1`).
- Platform-gated identifiers: `pipe_id` / `space_id` / `project_id` may only appear when the artefact's `platform:` value is active for that identifier (Pipefy / Wrike / Ziflow respectively). Carrying `pipe_id` on a Wrike artefact is a validation failure raised by the `validate-frontmatter` hook (DESIGN-04).
- `frontmatter_version: 2` lenient-mode reader behaviour is specified in DESIGN-08; v2 readers MUST NOT auto-flip in-flight artefacts.

**Cross-references.** DESIGN-04 (hook implementation); DESIGN-06 (approval-gate field requirements `approved_by` + `approved_at`); DESIGN-08 (migration semantics + lenient mode); DESIGN-27 (Stage 11 writes `status: archived`).

---

### DESIGN-02 — Canonical stage-numbering scheme

> **DESIGN-02:** Canonical stage-numbering scheme — file-prefix as stage number, substages, canonical reference doc, old→new mapping.

**Contract.**

- File-prefix = stage number across the v2 pipeline: `01_kickoff_*` (Stage 1) → `02_discovery_*` (Stage 2) → `03_sow_*` (Stage 3) → `04a_fnspec-platform_*` / `04b_fnspec-integration_*` (Stages 4a / 4b) → `05_techspec_*` (Stage 5) → `06_cost_*` (Stage 6) → `07a_build-prompt-dev_*` / `07b_build-prompt-impl_*` (Stages 7a / 7b) → `08_test-results_*` (Stage 8) → `09_doc-diff_*` (Stage 9) → `10_native-ai_*` (Stage 10) → `11_signoff_*` (Stage 11).
- Substage letter suffixes: `4a` / `4b` (fnspec split per DESIGN-20); `7a` / `7b` (build-prompt dual per DESIGN-23); `8a` / `8b` / `8c` / `8d` (provision-test-harness / test plan / UAT plan / execute-tests refactor per DESIGN-24).
- Canonical reference document at `dydx-delivery/references/stage-numbering.md` (NEW in v2; lands in v2.1 Foundations build) carries the full stage→file-prefix mapping plus the v0.3.0→v2 migration table. Skills cite this doc rather than re-asserting numbering.
- Old→new mapping table: v0.3.0 `00_discovery_*` → v2 `02_discovery_*`; v0.3.0 `01_sow_*` → v2 `03_sow_*`; v0.3.0 `02_functional-spec_*` → v2 `04a_fnspec-platform_*` (split per DESIGN-20); v0.3.0 `03_technical-spec_*` → v2 `05_techspec_*`; v0.3.0 `04_build-prompt_*` → v2 `07a_build-prompt-dev_*`; v0.3.0 `test-plan_v*` → v2 `08b_test-plan_*` (path moves to `<Client> Brain/test-bot/test_cases/`); v0.3.0 `results-YYYY-MM-DD_v*` → v2 `08_test-results_*`. Resolves the two-scheme conflict cited at AUDIT.md §AUDIT-01.1 (`intake-template.md:13` self-labels "Stage 0" while file-prefix is `00_`).

**Cross-references.** DESIGN-08 (migration co-existence — old prefixes coexist during opt-in CR-driven upgrade); DESIGN-13 (hand-off contract uses v2 carrier file paths); DESIGN-20 (fnspec split anchors `4a` / `4b`); DESIGN-23 (build prompt dual anchors `7a` / `7b`).

---

### DESIGN-03 — Single source of truth for hard rules

> **DESIGN-03:** Single source of truth for hard rules at `dydx-delivery/references/safety-rules.md` plus per-client overrides overlay.

**Contract.**

- Single SoT location: `dydx-delivery/references/safety-rules.md` (canonical hard-rules document; v0.3.0 lives at `dydx-delivery/skills/execute-tests/references/safety-rules.md` per AUDIT.md §AUDIT-05; v2 promotes it to plugin-level `references/`).
- Per-client overlay: `<Client> Brain/safety-overrides.yaml` overlays ONLY fields marked `overridable: true` in the canonical SoT. Non-overridable rules (sandbox-only test execution, hard-stop integration safety) cannot be relaxed by a client overlay.
- Skills inline a one-line summary plus a pointer at `dydx-delivery/references/safety-rules.md`; never copy the full ruleset. AUDIT.md §AUDIT-05 catalogues the 4 hard-rules duplicates (3 copies + 1 canonical) collapsed by this contract.
- Override resolution at runtime: skill loads canonical SoT → loads per-client overlay if present → applies overrides only to `overridable: true` fields → final ruleset assembled in memory.

**Cross-references.** DESIGN-04 (`validate-frontmatter` and `bump-artefact-version` hooks read from canonical SoT); DESIGN-24 (Stage 8 test bot sandbox-only enforcement reads canonical SoT); DESIGN-27 (Stage 11 archive checks pre-archive sanity against canonical rules).

---

### DESIGN-04 — Plugin surfaces

> **DESIGN-04:** Plugin surfaces — commands/agents/hooks/mcpServers/version + plugin self-tests (D-24).

**Contract.**

- `commands/`: 1 parameterised `commands/refine.md` (per DESIGN-05) + 4 GSD-prefixed shortcut commands (namespace: `/dydx-*`).
- `agents/`: 1 — `test-bot-orchestrator.md` (drives Stage 8 tier-2 AI orchestration per DESIGN-24).
- `hooks/`: 2 (NOT auto-progression hooks — explicit non-goal per kickoff mandate):
  - `validate-frontmatter.py` — validates `frontmatter_version`, status-lifecycle membership, platform-gated identifier rules, `approved_by` + `approved_at` mandatory on `status: approved` writes (DESIGN-06).
  - `bump-artefact-version.py` — increments `version` field in frontmatter and renames `_v{N}.md` → `_v{N+1}.md` idempotently (Option B versioning carried forward from v0.3.0).
- `mcpServers` field in `dydx-delivery/.claude-plugin/plugin.json` lists the 5 wired MCPs (Coda, Google Drive, Gmail, Calendar, Miro per AUDIT.md §AUDIT-08).
- Plugin manifest version `2.0.0` synced across `dydx-delivery/.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json` metadata + `marketplace.json:plugins[0]` (resolves AUDIT.md §AUDIT-06 version-string mismatches).

**Plugin self-tests subsection (per D-24).** Plugin v2.1 ships pytest smoke tests for plugin-level correctness at `dydx-delivery/tests/` (NEW directory). Coverage:
- `validate-frontmatter` hook — positive cases (valid v2 frontmatter passes) + negative cases (missing `approved_by` on `status: approved` write rejected; `pipe_id` on Wrike artefact rejected; non-canonical status value rejected).
- `bump-artefact-version` hook — idempotency (running twice on `_v3.md` produces `_v4.md` then `_v5.md` without artefact corruption); version-bump correctness (`version: 3` → `version: 4`).
- Frontmatter parser — status-lifecycle membership, platform-gated identifier rules, `frontmatter_version` field handling (absent → lenient mode per DESIGN-08).
- Test framework: pytest. CI integration: tests run on every PR via plugin CI (CI infrastructure lands with v2.1 Foundations build).

**Cross-references.** DESIGN-01 (frontmatter scheme — what hooks validate); DESIGN-05 (`commands/refine.md` parameterisation); DESIGN-06 (approval-gate fields enforced by `validate-frontmatter`); DESIGN-08 (lenient-mode reader behaviour); AUDIT.md §AUDIT-06 (version-string mismatch closure); AUDIT.md §AUDIT-08 (live MCP wiring snapshot).

---

### DESIGN-05 — `/refine-<skill>` resolution

> **DESIGN-05:** `/refine-<skill>` resolution — single parameterised `commands/refine.md`, namespace `/dydx-refine-*` (D-23).

**Contract.**

- Single parameterised `commands/refine.md` taking the skill name as `$1`. The command body dispatches to the named skill's refinement flow; new skills get refine-coverage automatically without N more command files.
- Namespace: `/dydx-refine-*` (NOT bare `/refine-*` — D-23). Avoids collision with other plugins or native shortcuts; clients invoke `/dydx-refine-discovery-intake`, `/dydx-refine-generate-sow`, etc.
- Resolves AUDIT.md §AUDIT-04.2 orphan-reference finding: v0.3.0 SKILL.md files reference `/refine-<skill>` commands that never shipped. v2.1 cutover: parameterised `refine.md` resolves all orphan references; documentation updates SKILL.md prose to use `/dydx-refine-*` namespace.
- Phase 3 CHANGELIST.md schedules the refine-command build for v2.1 Foundations.

**Cross-references.** DESIGN-04 (commands/ directory shape); AUDIT.md §AUDIT-04.2 (orphan `/refine-<skill>` references catalogued).

---

### DESIGN-06 — Approval-gate enforcement

> **DESIGN-06:** Approval-gate enforcement — mandatory `approved_by` + `approved_at` on `status: approved` writes, hook refuses otherwise.

**Contract.**

- Every stage skill ends with an explicit hand-off message naming the approval action (e.g., "Run `generate-sow` after `00_discovery_v{N}.md` is `status: approved`"). The hand-off message shape is locked per-stage in DESIGN-13.
- Mandatory frontmatter fields on every `status: approved` write: `approved_by: <human-name>` (NOT `Claude` / `AI` / `system`) + `approved_at: <ISO-8601 timestamp>`.
- The `validate-frontmatter` hook (DESIGN-04) refuses any write that sets `status: approved` and lacks either `approved_by` or `approved_at`. The hook returns a non-zero exit and surfaces the missing fields by name.
- Auto-progression between stages remains an explicit non-goal (kickoff mandate). Approval is a human action; the hook is the enforcement floor, not a substitute for review.

**Cross-references.** DESIGN-01 (status-lifecycle membership); DESIGN-04 (`validate-frontmatter` hook implementation); DESIGN-13 (hand-off message shape per stage transition).

---

### DESIGN-07 — Connector-availability probe + degradation matrix

> **DESIGN-07:** Connector-availability probe + per-stage graceful-degradation matrix.

**Contract.**

- Session-start MCP probe: at the start of each Claude Code session, the plugin probes each wired MCP (Coda, Google Drive, Gmail, Calendar, Miro per AUDIT.md §AUDIT-08) with a cheap-read endpoint. Probe outcome cached for the session: `connected | degraded | missing`.
- Per-stage graceful-degradation matrix: each stage skill's behaviour when a required connector returns `missing` is locked. Examples (full 10-row matrix lands in DESIGN-07 per the PITFALLS-cited fallback table referenced in AUDIT.md §AUDIT-03):
  - Stage 1 Kickoff (Miro missing) → paste-fallback mode (workflow-map ingest via copy-paste).
  - Stage 6 Cost estimate (Coda missing) → manual mode (cost estimate emitted as local `.md` only; Coda upsert deferred).
  - Stage 9 Documentation (Drive missing) → halt with explicit error; Stage 9 cannot complete without Drive.
  - Stage 10 Native-AI enablement (platform native-AI API missing) → copy-paste fallback per `native_ai_path: paste`.
- Probe is non-blocking at session start; failure to reach a connector does NOT block plugin load. Stages that require the connector halt at their own gates per the matrix.
- Probe results plus per-stage matrix are written to a session-scoped `connector_probe.yaml` cache so skills do not re-probe.

**Cross-references.** AUDIT.md §AUDIT-03 (per-stage connector dependencies); AUDIT.md §AUDIT-08 (live MCP wiring snapshot — probe baseline); DESIGN-26 (Stage 10 `native_ai_path` flag drives degradation).

---

### DESIGN-08 — Frontmatter migration co-existence

> **DESIGN-08:** Frontmatter migration co-existence — CR-driven opt-in, `client_review` retained, lenient mode for v0.3.0 absent (D-25 survey locks).

**Contract.**

- v2 readers tolerate v0.3.0 frontmatter via the `frontmatter_version` field. Absent value → lenient mode (reader assumes v0.3.0 conventions; does not raise on missing `archived` status, missing `frontmatter_version: 2`, or missing `approved_by` / `approved_at` on `status: approved` artefacts written before v2.1).
- Migration is opt-in per change request (CR-driven). When a CR fires that touches an artefact, the artefact upgrades to v2 frontmatter as part of that CR's diff. No date-based cutover.
- In-flight `client_review` artefacts NEVER auto-flip to `approved`. The migration upgrade preserves the in-flight status verbatim.
- Status lifecycle MUST retain `client_review` (live in `generate-sow:93` per AUDIT.md §AUDIT-01.2 and confirmed by the survey above).
- Survey result locks the contract: see `### Live status-lifecycle survey` above for methodology, sampled sources, distinct values found, and reconciliation against canonical `{draft, client_review, approved, archived}`. No live value is orphaned. No `[MIGRATION-RISK]` marker required.

**Cross-references.** DESIGN-01 (canonical frontmatter scheme — what v2 enforces); DESIGN-04 (`validate-frontmatter` hook lenient-mode behaviour); `### Live status-lifecycle survey` (above — D-25 methodology + result).

---

### DESIGN-09 — Directional-boundary contract

> **DESIGN-09:** Directional-boundary contract — local canonical, Coda one-way mirror, Field Notes read-only triage queue.

**Contract.**

- Local `<Client> Brain/` is canonical: every artefact, decision, and brain-spoke document lives locally first. Drafts edit locally; reviews happen against local files.
- Coda is a one-way mirror: Stage 11 (DESIGN-27) pushes brain content to a Coda mirror doc using the brain-mirror Coda doc template (Overview / Workflows / Platforms / Integrations / Operating Model / Change History / Field Notes). No Coda → local sync; no two-way merge.
- Field Notes table on Coda is a read-only triage queue: clients and team members add notes; the plugin reads notes during Stage 1 Kickoff (DESIGN-17) for triage but NEVER auto-merges. Kickoff quotes the note + asks human to keep / drop / edit-and-keep before integrating into the brain.
- Field Notes are NEVER auto-merged into the brain; the directional boundary is enforced by skill design, not by Coda permissions. Kickoff is the only stage that reads Field Notes.

**Cross-references.** DESIGN-17 (Stage 1 Kickoff — Field Notes triage); DESIGN-27 (Stage 11 — Coda one-way push); AUDIT.md §AUDIT-04 (existing brain-mirror references).

---

### DESIGN-10 — Persona contract

> **DESIGN-10:** Persona contract — senior-implementer voice principles + forbidden-phrasings list inline + 3 worked examples in Appendix C (D-29).

**Contract.**

Senior-implementer voice principles (5):

1. **No AI hedging.** Statements are claims, not suggestions. Avoid soft modal verbs ("might", "could", "perhaps").
2. **Specific over abstract.** Cite `file:line` when stating a fact about the codebase. Replace vague references with concrete paths or names.
3. **No apology-prefaces.** Skip "Note that…", "It's worth noting…", "Please be aware…". State the fact directly.
4. **Imperative over advisory.** Prefer "Update README:14" over "we recommend updating the README". The reader is the implementor; tell them what to do.
5. **End with hand-off, not summary.** The closing sentence names the next action and the artefact it produces; not a recap of what was just said.

Forbidden phrasings (verbatim — these strings MUST NOT appear in v2 prose authored by skills):

- "we recommend"
- "as an AI"
- "I would suggest"
- "perhaps consider"
- "might want to"
- "it's worth noting"
- "please be aware"
- "in order to"
- "make sure to"
- "feel free to"

3 worked before/after examples — see `## Appendix C: Persona contract worked examples`.

**Cross-references.** DESIGN-13 (hand-off message shape — closing sentence per principle 5); DESIGN-25 (`tone_lint` pass at Stage 11 enforces persona compliance pre-archive); `## Appendix C: Persona contract worked examples`.

---

### Live status-lifecycle survey

**Methodology.** No live `<Client> Brain/` folders are reachable from this workspace at probe time (2026-05-09; checked sibling directories under `C:/Users/Jason Blignaut/Documents/Coding/` — only non-client project folders present: `AWS`, `Anaconda`, `Ardit Sluice` (non-dYdX project subfolders), `dydx-project-workflow`). Per D-25 fallback, the survey enumerates every `status:` value visible in v0.3.0 SKILL.md sources: every literal `status:` token (frontmatter sample, `status:` flow assignment, prose status-flag reference, hand-off-message status reference) is captured with `file:line` per D-32. Fallback is documented transparently rather than fabricating live-folder results (T-02-02-01 mitigation).

**Sampled sources.**

| Source | Type | `status:` values observed |
|--------|------|---------------------------|
| `dydx-delivery/skills/discovery-intake/SKILL.md:103` | v0.3.0 frontmatter sample | `draft` |
| `dydx-delivery/skills/generate-sow/SKILL.md:78` | v0.3.0 frontmatter sample | `draft` |
| `dydx-delivery/skills/generate-sow/SKILL.md:93` | v0.3.0 hand-off prose | `client_review`, `approved` |
| `dydx-delivery/skills/generate-functional-spec/SKILL.md:80` | v0.3.0 frontmatter sample | `draft` |
| `dydx-delivery/skills/generate-functional-spec/SKILL.md:95` | v0.3.0 hand-off prose | `approved` |
| `dydx-delivery/skills/generate-build-prompt/SKILL.md:12` | v0.3.0 input requirement | `approved` |
| `dydx-delivery/skills/generate-build-prompt/SKILL.md:117` | v0.3.0 frontmatter sample | `draft` |
| `dydx-delivery/skills/generate-build-prompt/SKILL.md:138` | v0.3.0 prose | `approved` |
| `dydx-delivery/skills/execute-tests/SKILL.md:12` | v0.3.0 input requirement | `approved` |
| `dydx-delivery/skills/execute-tests/SKILL.md:50` | v0.3.0 prompt fallback | `approved` |
| `.planning/AUDIT.md §AUDIT-01.2` | Phase 1 ground truth — generate-sow lifecycle | `draft → client_review → approved` |
| `.planning/AUDIT.md §AUDIT-01.3` | Phase 1 ground truth — generate-functional-spec lifecycle | `draft → approved` (no `client_review`) |

**Distinct values found:** `{draft, client_review, approved}`.

**Reconciliation against canonical `{draft, client_review, approved, archived}`:**
- `draft` — observed; locked as canonical opening status. No reconciliation required.
- `client_review` — observed only in `generate-sow:93` (per AUDIT.md §AUDIT-01.2, the sole skill carrying `client_review` in its hand-off prose). Locked as canonical. DESIGN-08 mandates retention so in-flight `client_review` artefacts NEVER auto-flip on migration.
- `approved` — observed; locked as canonical sign-off status. DESIGN-06 layers `approved_by` + `approved_at` mandatory fields on every `status: approved` write.
- `archived` — NOT observed in v0.3.0 sources. Adding `archived` to the canonical lifecycle is net-new in v2 (DESIGN-27 Stage 11 sign-off-and-archive lands the write). No live value is orphaned by introducing `archived`.

**Conclusion.** Canonical lifecycle `draft → client_review → approved → archived` does not orphan any observed `status:` value. Every value present in v0.3.0 (`draft`, `client_review`, `approved`) is preserved unchanged; `archived` is additive and writes only at Stage 11. DESIGN-08 contract is locked: v2 readers tolerate v0.3.0 frontmatter via `frontmatter_version` (absent → lenient), CR-driven opt-in upgrade, no auto-flip. No `[MIGRATION-RISK]` marker required from this survey result.

---

## Skill layout

(Populated by 02-03-PLAN.md / Wave 3. Covers DESIGN-11 — v2 folder layout: `skills/`, `commands/`, `agents/`, `hooks/`, `.claude-plugin/`, plugin-level `references/`.)

---

## 13-skill inventory

(Populated by 02-03-PLAN.md / Wave 3. Covers DESIGN-12 — 13-skill inventory matrix-then-prose: 6 NEW stage + 3 NEW platform + 4 MODIFIED + 2 UNCHANGED + 1 RETIRED-AND-REPLACED.)

---

## Stage-by-stage hand-off contract

(Populated by 02-03-PLAN.md / Wave 3. Covers DESIGN-13 — single transition matrix per D-26: From | To | Carrier file path | Frontmatter fields propagated | Gating status flag | Hand-off message. >= 10 transition rows.)

| From | To | Carrier file path | Frontmatter fields propagated | Gating status flag | Hand-off message |
|------|-----|-------------------|-------------------------------|--------------------|--------------------|

---

## Platform skills

(Populated by 02-04-PLAN.md / Wave 4. Covers DESIGN-14, 15, 16 — `platform-pipefy/`, `platform-wrike/`, `platform-ziflow/` with identical 5-file `references/` shape.)

### platform-pipefy
(populated by 02-04-PLAN.md)

### platform-wrike
(populated by 02-04-PLAN.md)

### platform-ziflow
(populated by 02-04-PLAN.md)

---

## Stage 1: Kickoff capture
(Populated by 02-05-PLAN.md / Wave 5. Covers DESIGN-17.)

## Stage 2: Discovery refactor
(Populated by 02-05-PLAN.md / Wave 5. Covers DESIGN-18.)

## Stage 3: SOW refactor
(Populated by 02-05-PLAN.md / Wave 5. Covers DESIGN-19.)

## Stage 4a: Functional spec — platform
(Populated by 02-06-PLAN.md / Wave 6. Covers DESIGN-20 first half.)

## Stage 4b: Functional spec — integration
(Populated by 02-06-PLAN.md / Wave 6. Covers DESIGN-20 second half.)

## Stage 5: Tech spec
(Populated by 02-06-PLAN.md / Wave 6. Covers DESIGN-21.)

## Stage 6: Cost estimate
(Populated by 02-07-PLAN.md / Wave 7. Covers DESIGN-22 — risk-multiplier taxonomy structure; numeric defaults DEFERRED per D-22.)

## Stage 7a: Build prompt — dev
(Populated by 02-07-PLAN.md / Wave 7. Covers DESIGN-23 first half.)

## Stage 7b: Build prompt — implementation per platform
(Populated by 02-07-PLAN.md / Wave 7. Covers DESIGN-23 second half.)

## Stage 8: Test bot — overview
(Populated by 02-08-PLAN.md / Wave 8. Covers DESIGN-24.)

## Stage 9: Documentation publishing
(Populated by 02-08-PLAN.md / Wave 8. Covers DESIGN-25.)

## Stage 10: Native-AI enablement
(Populated by 02-08-PLAN.md / Wave 8. Covers DESIGN-26.)

## Stage 11: Sign-off, brain update, archive
(Populated by 02-08-PLAN.md / Wave 8. Covers DESIGN-27.)

---

## Test bot architecture

(Populated by 02-09-PLAN.md / Wave 9. Covers DESIGN-28, 29, 30 — Python↔AI orchestrator boundary, `client_state.yaml` skeleton, drift-detection contract.)

### DESIGN-28: tier-1 / tier-2 boundary
(populated by 02-09-PLAN.md)

### DESIGN-29: client_state.yaml skeleton
(populated by 02-09-PLAN.md)

### DESIGN-30: drift-detection contract
(populated by 02-09-PLAN.md)

---

## Deferred to Phase 4 OPEN-QUESTIONS

(Populated by 02-10-PLAN.md / Wave 10 synthesis. Closed enumerated list of every inline `[OPEN: Phase 4 — ...]` marker, in document order, with source section reference. Phase 4 register builds against this list.)

- [OPEN: Phase 4 — risk-multiplier numeric defaults pending dYdX-historical validation per D-22]

---

## Appendix A: Glossary
(Populated by 02-10-PLAN.md / Wave 10 synthesis.)

---

## Appendix B: DESIGN-* → DESIGN.md section traceability
(Populated by 02-10-PLAN.md / Wave 10 synthesis. 30-row table: DESIGN-NN | section anchor | locking decision IDs.)

---

## Appendix C: Persona contract worked examples
(Populated by 02-02-PLAN.md alongside DESIGN-10. 3 before/after examples per D-29.)

---

*Design produced 2026-05-09; supersedes ad-hoc v0.3.0 architecture. Phase 3 CHANGELIST.md sequences the v2.x build against this design; Phase 4 OPEN-QUESTIONS.md catalogues every inline [OPEN] marker.*
