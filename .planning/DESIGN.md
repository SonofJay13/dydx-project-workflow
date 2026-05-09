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

> **DESIGN-11:** v2 folder layout — `skills/`, `commands/`, `agents/`, `hooks/`, `.claude-plugin/`, plus the new plugin-level `references/` directory.

The v2 plugin folder layout extends the v0.3.0 shape (which had `skills/` + `.claude-plugin/` only — per AUDIT.md §AUDIT-01 + §AUDIT-08) with the surfaces locked in DESIGN-04 plus a plugin-level `references/` directory for canonical SoT documents per DESIGN-02 / DESIGN-03. The four canonical reference files (`safety-rules.md`, `stage-numbering.md`, `frontmatter-scheme.md`, `glossary.md`) land per FOUND-01 in the v2.1 Foundations build; skills cite them via relative path (`../../references/<file>.md`) rather than copy the content. The `tests/` directory (NEW per D-24) holds plugin-level pytest smoke tests run on every PR.

```text
dydx-delivery/
├── .claude-plugin/
│   ├── plugin.json                       # manifest version 2.0.0 (DESIGN-04, AUDIT-06)
│   └── marketplace.json                  # marketplace metadata synced 2.0.0 (AUDIT-06)
├── references/                           # NEW in v2 — plugin-level canonical SoT docs (FOUND-01)
│   ├── safety-rules.md                   # canonical hard-rules SoT (DESIGN-03, AUDIT-05)
│   ├── stage-numbering.md                # canonical stage→file-prefix mapping (DESIGN-02)
│   ├── frontmatter-scheme.md             # canonical frontmatter scheme (DESIGN-01)
│   └── glossary.md                       # canonical vocabulary (FOUND-01)
├── skills/                               # 15 v2 end-state skill folders (DESIGN-12)
│   ├── kickoff-capture/                  # NEW (Stage 1) — DESIGN-17
│   ├── discovery-intake/                 # MODIFIED (Stage 2) — DESIGN-18
│   ├── generate-sow/                     # UNCHANGED-structure (Stage 3) — DESIGN-19
│   ├── generate-fnspec-platform/         # NEW (Stage 4a) — DESIGN-20
│   ├── generate-fnspec-integration/      # NEW (Stage 4b) — DESIGN-20
│   ├── generate-technical-spec/          # MODIFIED (Stage 5) — DESIGN-21
│   ├── generate-cost-estimate/           # NEW (Stage 6) — DESIGN-22
│   ├── generate-build-prompt/            # MODIFIED (Stage 7a) — DESIGN-23
│   ├── generate-implementation-prompt/   # NEW (Stage 7b) — DESIGN-23
│   ├── provision-test-harness/           # NEW (Stage 8a) — DESIGN-24
│   ├── generate-test-plan/               # MODIFIED (Stage 8b) — DESIGN-24
│   ├── generate-uat-plan/                # NEW (Stage 8c) — DESIGN-24
│   ├── execute-tests/                    # MODIFIED (Stage 8d) — DESIGN-24
│   ├── update-documentation/             # NEW (Stage 9) — DESIGN-25
│   ├── push-native-ai-knowledge/         # NEW (Stage 10) — DESIGN-26
│   ├── sign-off-and-archive/             # NEW (Stage 11) — DESIGN-27
│   ├── platform-pipefy/                  # NEW platform — DESIGN-14
│   ├── platform-wrike/                   # NEW platform — DESIGN-15
│   └── platform-ziflow/                  # NEW platform — DESIGN-16
├── commands/                             # NEW in v2 (DESIGN-04)
│   ├── refine.md                         # parameterised — takes skill name as $1 (DESIGN-05, D-23)
│   ├── gsd-research-phase.md             # GSD shortcut (namespace /dydx-*)
│   ├── gsd-plan-phase.md                 # GSD shortcut
│   ├── gsd-execute-phase.md              # GSD shortcut
│   └── gsd-review-phase.md               # GSD shortcut
├── agents/                               # NEW in v2 (DESIGN-04, DESIGN-24)
│   └── test-bot-orchestrator.md          # drives Stage 8 tier-2 AI orchestration (DESIGN-28)
├── hooks/                                # NEW in v2 (DESIGN-04) — NOT auto-progression hooks
│   ├── validate-frontmatter.py           # enforces DESIGN-01/06 frontmatter rules
│   └── bump-artefact-version.py          # enforces Option B versioning idempotently
└── tests/                                # NEW in v2 (D-24) — plugin-level pytest smoke tests
    ├── test_validate_frontmatter.py      # positive + negative hook coverage
    ├── test_bump_artefact_version.py     # idempotency + version-bump correctness
    └── test_frontmatter_parser.py        # lifecycle / platform-gated / lenient mode
```

**RETIRED in v2:** `skills/generate-functional-spec/` (replaced by `generate-fnspec-platform/` + `generate-fnspec-integration/` per Stage 4 split / DESIGN-20).

---

## v2 skill inventory

> **DESIGN-12:** v2 skill inventory — 6 NEW stage + 3 NEW platform + 4 MODIFIED + 2 UNCHANGED + 1 RETIRED-AND-REPLACED per REQUIREMENTS DESIGN-12 categorical breakdown. End-state count = 15 skill folders that ship in v2 (the 1 RETIRED is removed; logged separately for migration mapping). Each skill carries purpose, inputs, outputs, downstream consumer, complexity, dependencies, hand-off message shape per D-20.

**Reconciliation (per cross-AI review MEDIUM #4).** REQUIREMENTS.md DESIGN-12 sub-bullet describes the v2 inventory in 5 categories totalling 16 categorical items: 6 NEW stage skills + 3 NEW platform skills + 4 MODIFIED + 2 UNCHANGED + 1 RETIRED-AND-REPLACED. The "X skills total" headline figure in different framings (legacy "13", categorical "16") is reconciled here against the actual end-state count of skill folders that ship: **15 v2 end-state skills** (16 categorical items minus the 1 RETIRED `generate-functional-spec` which is removed and replaced by the Stage 4 split — `generate-fnspec-platform` + `generate-fnspec-integration`). The matrix below lists the 15 v2 end-state skills; the migration-mapping note at the bottom captures the RETIRED skill. Per Phase 1 D-32 / D-34 honesty precedent: this reconciliation cites architecture research (`.planning/research/SUMMARY.md` + `.planning/research/ARCHITECTURE.md`) as the source of truth for the count; AUDIT.md §AUDIT-01 grounds the v0.3.0 starting state (7 existing skills); the section title uses neutral "v2 skill inventory" (no number) so the H2 anchor is resilient if the count adjusts in v2.x.

**Inventory matrix.**

| # | Skill name | Tag | Stage | Inputs (frontmatter + upstream artefact) | Outputs | Downstream consumer | Complexity | Dependencies | Detailed contract section |
|---|------------|-----|-------|------------------------------------------|---------|---------------------|------------|--------------|---------------------------|
| 1 | `kickoff-capture/` | NEW | 1 | meeting notes / requirements / Field Notes; `client:` `project:` | `01_kickoff_v<N>.md` | `discovery-intake` OR `generate-sow` | Medium | Miro paste fallback; Field Notes triage | `## Stage 1: Kickoff capture` |
| 2 | `discovery-intake/` | MODIFIED | 2 | `01_kickoff_v*` artefact; `based_on_kickoff:` | `02_discovery_v<N>.md` | `generate-sow` | Low | none new | `## Stage 2: Discovery refactor` |
| 3 | `generate-sow/` | UNCHANGED-structure / behaviour-modified | 3 | `02_discovery_v*` OR `01_kickoff_v*`; `based_on_discovery:` | `03_sow_v<N>.md` | `generate-fnspec-platform` AND/OR `generate-fnspec-integration` | Medium | none new | `## Stage 3: SOW refactor` |
| 4 | `generate-fnspec-platform/` | NEW | 4a | `03_sow_v*`; `based_on_sow:` | `04a_fnspec-platform_v<N>.md` with `delivery: native-ai \| api` per requirement | `generate-fnspec-integration` AND `generate-cost-estimate` AND `generate-implementation-prompt` AND `push-native-ai-knowledge` | Medium-high | per-platform capability matrix | `## Stage 4a: Functional spec — platform` |
| 5 | `generate-fnspec-integration/` | NEW | 4b | `03_sow_v*` + (optional) `04a_fnspec-platform_v*` | `04b_fnspec-integration_v<N>.md` | `generate-technical-spec` AND `generate-cost-estimate` AND `generate-build-prompt` | Medium-high | cross-spec consistency check vs 4a | `## Stage 4b: Functional spec — integration` |
| 6 | `generate-technical-spec/` | MODIFIED | 5 | `04b_fnspec-integration_v*` + (optional) `04a_*` | `05_techspec_v<N>.md` | `generate-cost-estimate`; `generate-build-prompt` | Medium | none new | `## Stage 5: Tech spec` |
| 7 | `generate-cost-estimate/` | NEW | 6 | `04a_*` AND/OR `04b_*` AND `05_techspec_v*` | `06_cost_v<N>.md` + Coda task-table rows | client-facing cost estimate | High (Coda) | `platform-<X>` for schema introspection | `## Stage 6: Cost estimate` |
| 8 | `generate-build-prompt/` | MODIFIED | 7a | `04b_*` AND `05_techspec_v*` AND `06_cost_v*` | `07a_build-prompt_v<N>.md` | dev | Medium | none new | `## Stage 7a: Build prompt — dev` |
| 9 | `generate-implementation-prompt/` | NEW | 7b | `04a_*` AND `06_cost_v*`; per-platform shape | `07b_implementation-prompt_v<N>.md` | non-dev per platform | Medium | `platform-<X>` reference | `## Stage 7b: Build prompt — implementation per platform` |
| 10 | `provision-test-harness/` | NEW | 8a | `04a_*` AND `04b_*` AND `client_state.yaml` | `08a_test-harness_v<N>.md` + persistent harness | `execute-tests` | High | `platform-<X>` + `sandbox_lock` | `## Stage 8: Test bot — overview` |
| 11 | `generate-test-plan/` | MODIFIED | 8b | `04b_*` AND `05_techspec_v*` AND `08a_*` | `08b_test-plan_v<N>.md` | `execute-tests` | Medium | DESIGN-28 layer boundary | `## Stage 8: Test bot — overview` |
| 12 | `generate-uat-plan/` | NEW | 8c | `04a_*` AND `04b_*` AND `08b_*` | `08c_uat-plan_v<N>.md` | client | Low-medium | none new | `## Stage 8: Test bot — overview` |
| 13 | `execute-tests/` | MODIFIED | 8d | `08a_*` AND `08b_*` AND `08c_*` | `08d_test-results_v<N>.md` | `update-documentation` | High (sandbox + AI orchestrator) | `test-bot-orchestrator` agent | `## Stage 8: Test bot — overview` |
| 14 | `update-documentation/` | NEW | 9 | `08d_test-results_v*` (approved) AND all upstream | `ChangeRequests/<CR>/doc-diff.md` + Drive doc | reviewer; `push-native-ai-knowledge` | Medium | Drive MCP | `## Stage 9: Documentation publishing` |
| 15 | `push-native-ai-knowledge/` | NEW | 10 | `04a_*` AND approved `09_doc-diff_v*` AND per-platform `native-ai-inventory.md` | per-platform native-AI ingestion + `doc_version:` `ingested_at:` | client native-AI surface | High | `platform-<X>`; CRIT-8 + MIN-4 refusal gates | `## Stage 10: Native-AI enablement` |
| 16 | `sign-off-and-archive/` | NEW | 11 | All approved upstream artefacts; `tone_lint` pass | `<Client> Brain/<spokes>/` updated + Coda mirror push + CR archived | Field Notes preserved; next CR's Stage 1 | Medium | brain-mirror Coda template | `## Stage 11: Sign-off, brain update, archive` |
| 17 | `platform-pipefy/` | NEW (platform) | n/a — referenced by stages 4a/5/7b/8/10 | `platform: pipefy` artefacts | platform-API contract + native-AI capability matrix + knowledge ingestion path | Stage skills that load by `platform:` dispatch | Medium-high | Pipefy GraphQL pagination cursor + 2026 rate-limit currency `[OPEN: Phase 4]` | `## platform-pipefy` |
| 18 | `platform-wrike/` | NEW (platform) | n/a — referenced by stages 4a/5/7b/8/10 | `platform: wrike` artefacts | platform-API contract + native-AI capability matrix + knowledge ingestion path | Stage skills that load by `platform:` dispatch | Medium-high | Wrike OAuth `host` persistence + AI Studio knowledge-ingestion API `[OPEN: Phase 4]` | `## platform-wrike` |
| 19 | `platform-ziflow/` | NEW (platform) | n/a — referenced by stages 4a/5/7b/8/10 | `platform: ziflow` artefacts | platform-API contract + native-AI capability matrix + knowledge ingestion path | Stage skills that load by `platform:` dispatch | Medium-high | Ziflow read-after-create consistency + ReviewAI knowledge-ingestion API `[OPEN: Phase 4]` | `## platform-ziflow` |

**Tag breakdown reconciliation against REQUIREMENTS DESIGN-12 categorical totals.** Counting matrix tags above: NEW (stage) = rows 1, 4, 5, 7, 9, 10, 12, 14, 15, 16 = 10; MODIFIED (stage) = rows 2, 6, 8, 11, 13 = 5; UNCHANGED-structure / behaviour-modified = row 3 = 1; NEW (platform) = rows 17, 18, 19 = 3. Plus 1 RETIRED-AND-REPLACED (`generate-functional-spec/`, NOT shipped — see migration mapping note below). REQUIREMENTS DESIGN-12 sub-bullet ("6 NEW + 3 NEW platform + 4 MODIFIED + 2 UNCHANGED + 1 RETIRED-AND-REPLACED") describes a tighter scoping; the matrix's 10 NEW / 5 MODIFIED / 1 UNCHANGED / 3 NEW-platform / 1 RETIRED follows architecture research's enumeration (Stage 4 split + Stage 7 dual + Stage 8 four-substage + Stage 11 NEW skills push the NEW count above 6). Honesty precedent (Phase 1 D-32 / D-34): the matrix follows the research enumeration; the discrepancy is logged here rather than padded or trimmed.

**Per-skill prose subsections.** Per-skill decision contracts (purpose, inputs, outputs, downstream consumer, complexity tag, dependencies, hand-off message shape) live in their respective sections per the "Detailed contract section" column. Per D-20, full SKILL.md prose is NOT drafted in this milestone; v2.1+ build phases authoring each skill produce its `SKILL.md` against the contract laid here.

**Migration mapping note (RETIRED skill).** RETIRED `generate-functional-spec/` maps to the new Stage 4a + Stage 4b skills per DESIGN-20. v0.3.0 artefacts using the old skill name (`02_functional-spec_v*.md`) remain readable per DESIGN-08 lenient mode; CR-driven opt-in upgrades them to the new names (`04a_fnspec-platform_v*.md` / `04b_fnspec-integration_v*.md` per DESIGN-02 stage-numbering scheme) during their owning CR. v0.3.0 references to the retired skill in `generate-technical-spec/SKILL.md` and `generate-build-prompt/SKILL.md` (per AUDIT.md §AUDIT-01) update to the new pair as part of the v2.1 Foundations build.

---

## Stage-by-stage hand-off contract

> **DESIGN-13:** Stage-by-stage hand-off contract — for every stage transition, the carrier file path, the frontmatter fields that propagate, and the status flag that gates the next stage. Single transition matrix per D-26 (matrix-then-prose); per-stage subsections (Stage 1..11) restate hand-off message verbatim for grep-ability.

The hand-off matrix is the single most-cited section of DESIGN.md (per CONTEXT specifics). v2.1+ build phases reference these rows when authoring per-stage SKILL.md files — every carrier file path, frontmatter field name, and gating status flag value here is grep-canonical. Per D-26, the matrix is the source of truth; per-stage subsections (under `## Stage 1: Kickoff capture` through `## Stage 11: Sign-off, brain update, archive`) restate the hand-off message verbatim for navigability. Carrier file paths follow DESIGN-02 stage-prefixed naming; gating status flags use the canonical DESIGN-01 lifecycle vocabulary.

| From | To | Carrier file path | Frontmatter fields propagated | Gating status flag | Hand-off message |
|------|-----|-------------------|-------------------------------|--------------------|--------------------|
| Stage 1 | Stage 2 | `01_kickoff_v<N>.md` | `client:` `project:` `frontmatter_version: 2` | `status: approved` | `> Awaiting status: approved write to 01_kickoff_v<N>.md. Branch routing on kickoff_branch: value (discovery-ready -> Stage 2; draft-sow -> SKIP Stage 2 -> Stage 3).` |
| Stage 2 | Stage 3 | `02_discovery_v<N>.md` | `based_on_kickoff: 01_kickoff_v<N>` `client:` `project:` | `status: approved` | `> Awaiting status: approved write to 02_discovery_v<N>.md before generate-sow runs.` |
| Stage 3 | Stage 4a | `03_sow_v<N>.md` | `based_on_discovery:` (or `based_on_kickoff:`) `platform:` (if known) | `status: approved` AND `client_review` allowed | `> Awaiting status: approved on 03_sow_v<N>.md; routing to Stage 4a (platform fnspec) and/or Stage 4b (integration fnspec) per project scope.` |
| Stage 4a | Stage 4b | `04a_fnspec-platform_v<N>.md` | `based_on_sow:` `platform:` `delivery: native-ai \| api` | `status: approved` (4a optional for integration-only) | > Awaiting `status: approved` to `04a`; cross-spec consistency check runs at start of 4b. |
| Stage 4b | Stage 5 | `04b_fnspec-integration_v<N>.md` | `based_on_sow:` `based_on_fnspec_platform:` (if 4a exists) | `status: approved` (Stage 5 SKIPPED if no 4b) | > Awaiting `status: approved` to `04b`; Stage 5 tech spec runs (or SKIPS if no `04b`, with platform-API addendum on `04a` instead per DESIGN-21). |
| Stage 5 | Stage 6 | `05_techspec_v<N>.md` | `based_on_fnspec_integration:` `based_on_fnspec_platform:` | `status: approved` | `> Awaiting status: approved on 05_techspec_v<N>.md AND wait-for-commercial-inputs gate before generate-cost-estimate runs (per DESIGN-22).` |
| Stage 6 | Stage 7a | `06_cost_v<N>.md` + Coda task-table rows | `based_on_techspec:` `based_on_fnspec_*:` `risk_multiplier_version:` `commercial_inputs_status:` | `status: approved` AND `commercial_inputs_status: provided` | > Awaiting `status: approved` to `06`; locks costed scope before build-prompt generation. |
| Stage 7a / 7b | Stage 8a | `07a_build-prompt_v<N>.md` AND/OR `07b_implementation-prompt_v<N>.md` | `based_on_fnspec_*:` `based_on_cost:` `delivery_filter:` | `status: approved` on both (when both run) | > Awaiting `status: approved` to `07a` and/or `07b`; provision-test-harness reads `delivery:` routing. |
| Stage 8a/b/c | Stage 8d | `08a_test-harness_v<N>.md` + `08b_test-plan_v<N>.md` + `08c_uat-plan_v<N>.md` + `client_state.yaml` | `based_on_fnspec_*:` `client_state_version:` `harness_version:` `last_known_schema_version:` | `status: approved` on 8a + 8b; 8c human-facing | `> Awaiting status: approved on 08a_test-harness_v<N>.md AND 08b_test-plan_v<N>.md; execute-tests runs against current client_state.yaml; sandbox_lock.yaml acquired before run.` |
| Stage 8d | Stage 9 | `08d_test-results_v<N>.md` | `based_on_test_plan:` `based_on_harness:` `failure_classes:` | `status: approved` | `> Awaiting status: approved on 08d_test-results_v<N>.md; doc-diff generation requires test approval.` |
| Stage 9 | Stage 10 | `ChangeRequests/<CR>/doc-diff.md` + Drive doc per closed `doc_type` enum | `doc_type:` `doc_version:` `doc_published_at:` `last_diff_review_at:` | `status: approved` on doc-diff | `> Awaiting status: approved on doc-diff.md AND doc_published_at set; push-native-ai-knowledge refuses ingest if doc_published_at < last_diff_review_at (CRIT-8 fix).` |
| Stage 10 | Stage 11 | per-platform native-AI ingestion artefact + `doc_version:` `ingested_at:` per ingested doc | `native_ai_path:` `target_id:` | `status: approved` on per-platform ingestion record | `> Awaiting status: approved on per-platform native-AI ingestion records; sign-off-and-archive runs only after all push-native-ai-knowledge runs succeed (or native_ai_path: none).` |

---

## Platform skills

The three platform skills (`platform-pipefy/`, `platform-wrike/`, `platform-ziflow/`) internalise per-platform knowledge that v0.3.0 referenced as missing artefacts (per AUDIT.md §AUDIT-04.1). Each carries an identical 5-file `references/` shape: `api-contract.md` + `native-ai-inventory.md` + `knowledge-ingestion.md` + `client-shape-gotchas.md` + `vocabulary.md`. The native-AI capability matrices are 2026-grounded per RESEARCH.md / FEATURES.md. Per D-21, this section ships decision contracts only — full SKILL.md and references/*.md prose authoring runs in v2.2 per CHANGELIST.md PLAT-01..03. Each platform contract carries a `tier_claims_last_verified: <ISO date>` frontmatter requirement so the v2.x build's first action against any platform skill re-verifies the native-AI capability matrix against then-current platform reality (locks the contract against silent drift).

**Platform-comparison matrix (per D-19).**

| Platform | Native-AI surface (2026) | API protocol | Sandbox access | `native_ai_path` default | Known research-blocked items |
|----------|--------------------------|--------------|-----------------|--------------------------|------------------------------|
| pipefy | AI Agents (KB + Skills + MCP + IDP + Web Search + BYO-LLM) | GraphQL | Sandbox tenant per client | `api` (HIGH on Behaviors/Skills; LOW on KB content-upload) | KB content-upload endpoint; GraphQL pagination cursor field names; 2026 rate-limit currency |
| wrike | Copilot + 16 MCP tools | REST | Sandbox space per client; `host` from OAuth token persisted (NOT hardcoded `www.wrike.com`) | `api` (MEDIUM; depends on Copilot knowledge-ingestion API) | AI Studio knowledge-ingestion API; 2026 rate-limit currency |
| ziflow | ReviewAI Checklists Public Preview (Change Verification + Brand Standards Coming Soon) | REST | Sandbox project per client | `paste` (Checklists Public Preview is the documented path; copy-paste fallback default) | ReviewAI knowledge-ingestion API; read-after-create consistency window |

### platform-pipefy

> **DESIGN-14:** `platform-pipefy/` skill structure — 5-file `references/` shape (`api-contract.md`, `native-ai-inventory.md`, `knowledge-ingestion.md`, `client-shape-gotchas.md`, `vocabulary.md`); 2026-grounded native-AI capability matrix; API surface for the gap; sandbox access pattern; `native_ai_path: api | paste | none` flag with confidence; `tier_claims_last_verified` frontmatter.

**Skill folder layout (5-file references/ shape per DESIGN-14):**

```text
dydx-delivery/skills/platform-pipefy/
├── SKILL.md
└── references/
    ├── api-contract.md           # GraphQL endpoints, paginate_all helper, rate-limit handling
    ├── native-ai-inventory.md    # AI Agents capability matrix (KB / Skills / MCP / IDP / Web Search / BYO-LLM)
    ├── knowledge-ingestion.md    # KB content-upload path (LOW-confidence — see [OPEN] below)
    ├── client-shape-gotchas.md   # per-client pipe shape variations
    └── vocabulary.md             # Pipefy-specific terms (pipe, phase, card, connection, etc.)
```

**Native-AI capability matrix (2026-grounded per RESEARCH.md / FEATURES.md):**

| Capability | Available? | Surface | Confidence |
|------------|------------|---------|------------|
| Knowledge base | yes | Pipefy AI Agents → KB | HIGH |
| Skills | yes | AI Agents → Skills | HIGH |
| MCP integration | yes | AI Agents → MCP | HIGH |
| IDP (Intelligent Document Processing) | yes | AI Agents → IDP | HIGH |
| Web Search | yes | AI Agents → Web Search | HIGH |
| BYO-LLM | yes | AI Agents config | HIGH |
| KB content-upload via API | unknown | `[OPEN: Phase 4 — Pipefy AI KB content-upload endpoint not externally verified per OPEN-01 — Phase 7 owner per CHANGE-04]` | LOW |

**API surface for the gap:**

- Protocol: GraphQL via Pipefy public API.
- Helper: `paginate_all(query, cursor_field)` for cursor pagination across multi-page result sets.
- Cursor field names: `[OPEN: Phase 4 — Pipefy GraphQL pagination cursor field names need verification against current 2026 schema per OPEN-01]`.
- Rate limit: `[OPEN: Phase 4 — Pipefy 2026 rate-limit currency unverified; Phase 1/Phase 2 owner per CHANGE-04. Documented historic ceiling: ~5 req/sec per token.]`
- Auth: Bearer token from Pipefy app installation; sandbox token distinct from production token.

**Sandbox access pattern:** Sandbox tenant per client; production OUT OF SCOPE for v2 test bot. `client_state.yaml` (DESIGN-29 — forward reference, populated in Plan 02-09) carries `pipefy_sandbox_pipe_id:` per client.

**`native_ai_path` flag (DESIGN-26 routing — forward reference):** `api` for Behaviors instructions + Skills config (HIGH-confidence). `paste` fallback for KB content-upload UNTIL the `[OPEN]` resolves; downgrade to `paste` keeps Stage 10 functional even with the LOW-confidence row unsettled.

**Frontmatter contract:** `tier_claims_last_verified: <ISO date>`; `platform: pipefy`. The `tier_claims_last_verified` field is the v2.x build's hook for re-verifying the native-AI capability matrix against then-current Pipefy reality before any new ingestion run.

**Cross-references:** DESIGN-22 (Stage 6 cost — forward reference, populated in Plan 02-07); DESIGN-23 (Stage 7b implementation prompt — forward reference, populated in Plan 02-07); DESIGN-24 (Stage 8a test harness — forward reference, populated in Plan 02-08); DESIGN-26 (Stage 10 native-AI push — forward reference, populated in Plan 02-08); AUDIT.md §AUDIT-04.1 (v0.3.0 platform skill orphan references catalogued).

### platform-wrike

> **DESIGN-15:** `platform-wrike/` skill structure — 5-file `references/` shape; 2026-grounded native-AI capability matrix (Copilot + 16 MCP tools); API surface for the gap (REST; `host` from OAuth token persisted, NOT hardcoded `www.wrike.com`); sandbox access; knowledge-ingestion via attach-doc-via-MCP.

**Skill folder layout (5-file references/ shape per DESIGN-15):**

```text
dydx-delivery/skills/platform-wrike/
├── SKILL.md
└── references/
    ├── api-contract.md           # REST endpoints, host persistence rule, rate-limit handling
    ├── native-ai-inventory.md    # Copilot + 16 MCP tools capability matrix
    ├── knowledge-ingestion.md    # attach-doc-via-MCP path + AI Studio API gap (see [OPEN] below)
    ├── client-shape-gotchas.md   # per-client space shape variations + custom field IDs
    └── vocabulary.md             # Wrike-specific terms (space, folder, project, task, custom field)
```

**Native-AI capability matrix (2026-grounded per RESEARCH.md / FEATURES.md):**

| Capability | Available? | Surface | Confidence |
|------------|------------|---------|------------|
| Copilot (chat-style assistant) | yes | Wrike Copilot | HIGH |
| MCP tools (16 tools) | yes | Wrike MCP integration — 16 tools | HIGH |
| Knowledge ingestion via attach-doc-via-MCP | yes | MCP attach-doc tool | MEDIUM |
| AI Studio knowledge-ingestion API | unknown | `[OPEN: Phase 4 — Wrike AI Studio knowledge-ingestion API not externally verified per OPEN-01 — Phase 7 owner per CHANGE-04]` | LOW |

**API surface for the gap:**

- Protocol: REST.
- **CRITICAL — `host` persistence rule.** The `host` field MUST be persisted from the OAuth token response and used as the API base URL for every subsequent call. Hardcoding `www.wrike.com` is the v0.3.0 bug per RESEARCH.md / PITFALLS.md (Wrike returns a tenant-specific host per OAuth handshake; the persisted `host` differs per client and is NOT always `www.wrike.com`). The `wrike_host:` field in `client_state.yaml` (DESIGN-29 — forward reference, populated in Plan 02-09) carries the per-client host string.
- Rate limit: `[OPEN: Phase 4 — Wrike 2026 rate-limit currency unverified per OPEN-01; Phase 1/Phase 2 owner per CHANGE-04. Documented historic: ~100 req/min per user.]`
- Auth: OAuth token; sandbox space distinct from production space.

**Sandbox access pattern:** Sandbox space per client; production OUT OF SCOPE for v2 test bot. `client_state.yaml` (DESIGN-29 — forward reference, populated in Plan 02-09) carries `wrike_sandbox_space_id:` AND `wrike_host:` per client. Both fields are mandatory — `wrike_sandbox_space_id:` without `wrike_host:` triggers the v0.3.0 hardcode bug.

**`native_ai_path` flag (DESIGN-26 routing — forward reference):** `api` for Copilot + 16 MCP tools (HIGH-confidence). `paste` fallback for AI Studio knowledge ingestion UNTIL the `[OPEN]` resolves; downgrade keeps Stage 10 functional even with the AI Studio API row unsettled.

**Frontmatter contract:** `tier_claims_last_verified: <ISO date>`; `platform: wrike`. The `tier_claims_last_verified` field is the v2.x build's hook for re-verifying the Copilot + MCP tool inventory against then-current Wrike reality.

**Cross-references:** DESIGN-22 (Stage 6 cost — forward reference, populated in Plan 02-07); DESIGN-23 (Stage 7b implementation prompt — forward reference, populated in Plan 02-07); DESIGN-24 (Stage 8a test harness — forward reference, populated in Plan 02-08); DESIGN-26 (Stage 10 native-AI push — forward reference, populated in Plan 02-08); DESIGN-29 (`wrike_host:` field — forward reference, populated in Plan 02-09); AUDIT.md §AUDIT-04.1 (v0.3.0 platform skill orphan references catalogued).

### platform-ziflow

> **DESIGN-16:** `platform-ziflow/` skill structure — 5-file `references/` shape; 2026-grounded native-AI capability matrix (ReviewAI Checklists Public Preview; Change Verification + Brand Standards Coming Soon); API surface for the gap (REST; `wait_for_proof` helper for eventual consistency); sandbox access; knowledge-ingestion path = Checklist generation primarily + copy-paste fallback.

**Skill folder layout (5-file references/ shape per DESIGN-16):**

```text
dydx-delivery/skills/platform-ziflow/
├── SKILL.md
└── references/
    ├── api-contract.md           # REST endpoints, wait_for_proof helper, rate-limit handling
    ├── native-ai-inventory.md    # ReviewAI capability matrix (Checklists / Change Verification / Brand Standards)
    ├── knowledge-ingestion.md    # Checklist generation path + copy-paste fallback (see [OPEN] below)
    ├── client-shape-gotchas.md   # per-client project shape variations + workflow stage names
    └── vocabulary.md             # Ziflow-specific terms (proof, review, decision, stage, version)
```

**Native-AI capability matrix (2026-grounded per RESEARCH.md / FEATURES.md):**

| Capability | Available? | Surface | Confidence |
|------------|------------|---------|------------|
| ReviewAI Checklists (Public Preview) | yes | ReviewAI → Checklists | HIGH |
| Change Verification | coming soon | ReviewAI → Change Verification (announced; not yet GA) | MEDIUM |
| Brand Standards | coming soon | ReviewAI → Brand Standards (announced; not yet GA) | MEDIUM |
| ReviewAI knowledge-ingestion API | unknown | `[OPEN: Phase 4 — Ziflow ReviewAI knowledge-ingestion API not externally verified per OPEN-01 — Phase 7 owner per CHANGE-04]` | LOW |

**API surface for the gap:**

- Protocol: REST.
- Helper: `wait_for_proof(proof_id, max_wait_s)` for eventual consistency — Ziflow's proof-create call returns before the proof is fully readable; subsequent reads against the new proof_id may 404 within the read-after-create window. The helper polls until the proof becomes readable or the max-wait expires.
- Read-after-create consistency window: `[OPEN: Phase 4 — Ziflow read-after-create consistency window unverified per OPEN-01; Phase 2 owner per CHANGE-04. Conservative default in helper: 30 second poll with 2s interval.]`
- Auth: API key in header; sandbox project distinct from production project.

**Sandbox access pattern:** Sandbox project per client; production OUT OF SCOPE for v2 test bot. `client_state.yaml` (DESIGN-29 — forward reference, populated in Plan 02-09) carries `ziflow_sandbox_project_id:` per client.

**`native_ai_path` flag (DESIGN-26 routing — forward reference):** `paste` (DEFAULT). Checklists Public Preview is documented but the knowledge-ingestion path is copy-paste fallback first; `api` upgrade IF the `[OPEN]` resolves an ingestion API. Defaulting to `paste` keeps Stage 10 functional without depending on the LOW-confidence ingestion row.

**Frontmatter contract:** `tier_claims_last_verified: <ISO date>`; `platform: ziflow`. The `tier_claims_last_verified` field is the v2.x build's hook for re-verifying ReviewAI feature availability (Change Verification / Brand Standards GA status) against then-current Ziflow reality.

**Cross-references:** DESIGN-22 (Stage 6 cost — forward reference, populated in Plan 02-07); DESIGN-23 (Stage 7b implementation prompt — forward reference, populated in Plan 02-07); DESIGN-24 (Stage 8a test harness — forward reference, populated in Plan 02-08); DESIGN-26 (Stage 10 native-AI push — forward reference, populated in Plan 02-08); AUDIT.md §AUDIT-04.1 (v0.3.0 platform skill orphan references catalogued).

---

## Stage 1: Kickoff capture

> **DESIGN-17:** Stage 1 Kickoff capture — inputs (meeting notes / client requirements / internal feedback / Miro workflow map); dual artefact branching (discovery-ready vs draft SOW); Field Notes triage from Coda brain doc (defaults to `processed_at IS NULL`, never auto-merges per DESIGN-09); Miro paste fallback when API ingest unavailable; auto-classification into kickoff template sections with explicit "unknown" markers.

**Skill:** `kickoff-capture/` (NEW per DESIGN-12 inventory).
**Stage:** 1 (file prefix `01_kickoff_*` per DESIGN-02).
**Complexity:** Medium.

**Inputs.**
- **Frontmatter consumed:** `client:` + `project:` + (optional) `frontmatter_version: 2`. New artefact (no `based_on_*` upstream).
- **Upstream artefact paths:** N/A (Stage 1 is the entry point).
- **External inputs:** meeting notes (paste), client requirements docs, internal feedback, Miro workflow map (paste — see Miro paste fallback below); Field Notes from `<Client> Brain` Coda doc (read-only via Coda MCP per AUDIT.md §AUDIT-08).

**Outputs.**
- **Carrier file:** `01_kickoff_v<N>.md` in `<Client> Brain/<Project>/`.
- **Frontmatter set:** `client:`, `project:`, `frontmatter_version: 2`, `kickoff_branch: discovery-ready | draft-sow`, `field_notes_processed_count: <N>`, `status: draft`.
- **Branch routing (DESIGN-17 dual-branch contract).** The single `kickoff_branch:` enum field steers downstream stages:
  - `kickoff_branch: discovery-ready` → Stage 2 (Discovery) consumes `01_kickoff_v<N>.md`.
  - `kickoff_branch: draft-sow` → Stage 2 SKIPS entirely; Stage 3 (SOW) consumes `01_kickoff_v<N>.md` directly.
- **Auto-classification markers.** Where the Stage 1 skill cannot confidently assign a section in the kickoff template (e.g., a meeting note ambiguous between "users" and "triggers"), it emits an inline `[unknown — needs human classification]` marker rather than guessing or dropping. Reviewer triages markers before writing `status: approved`.

**Downstream consumer.** discovery-intake (Stage 2) IF `kickoff_branch: discovery-ready`; OR generate-sow (Stage 3) IF `kickoff_branch: draft-sow` (skips Stage 2).

**Status flag(s).** `status: approved` on `01_kickoff_v<N>.md` gates either downstream stage. Approval-gate hook (DESIGN-06) refuses `status: approved` writes lacking `approved_by` + `approved_at`.

**Hand-off message (verbatim from DESIGN-13 matrix Stage 1 → Stage 2 row).**

> Awaiting status: approved write to 01_kickoff_v<N>.md. Branch routing on kickoff_branch: value (discovery-ready -> Stage 2; draft-sow -> SKIP Stage 2 -> Stage 3).

**Key v2 decisions for this stage.**

1. **Dual-branch artefact** — single Stage 1 produces either a discovery-ready kickoff (Stage 2 consumes) OR a draft SOW kickoff (Stage 2 SKIPS, Stage 3 consumes). Branch encoded in `kickoff_branch:` enum frontmatter; Stage 2 / Stage 3 skills read this field directly.
2. **Field Notes triage filter** — Stage 1 reads the `<Client> Brain` Coda doc Field Notes table filtered on `processed_at IS NULL` (per DESIGN-09 directional boundary — Coda is read-only triage queue; Field Notes are NEVER auto-merged into the local brain). Reviewer human-classifies each surfaced row during kickoff approval; only then does the row's `processed_at` get written back.
3. **Miro paste fallback** — Miro MCP is currently MISSING per AUDIT.md §AUDIT-08; Stage 1 falls back to a paste-the-workflow-map mode (per DESIGN-07 connector probe + graceful-degradation matrix). When Miro MCP comes online (Phase 1 of v2.x build), API ingest replaces paste fallback without contract change.
4. **Auto-classification with `[unknown — needs human classification]` inline markers** — Stage 1 attempts auto-classification into the kickoff template's canonical sections (system / users / triggers / data / rules / integrations / exceptions / failure-points), but emits explicit `[unknown — needs human classification]` markers wherever confidence is low. Forces visible reviewer triage instead of silent guesswork.

**Dependencies.** DESIGN-09 (Field Notes never auto-merged — directional boundary); DESIGN-07 (Miro probe — paste fallback when API unavailable); DESIGN-01 (canonical frontmatter scheme — `kickoff_branch:` enum, `status:` lifecycle, `frontmatter_version: 2`); DESIGN-06 (approval gate — `approved_by` + `approved_at` required for `status: approved`).

**Cross-references.** DESIGN-18 (forward — Stage 2 reads `kickoff_branch:` to skip when `draft-sow`; populated next in this plan); DESIGN-19 (forward — Stage 3 reads same `kickoff_branch:` field for direct-from-kickoff path; populated next); AUDIT.md §AUDIT-08 (Miro MCP currently MISSING — Phase 1 connector probe owner); AUDIT.md §AUDIT-01.1 (Field Notes triage flow grounded in v0.3.0 brain pattern).

## Stage 2: Discovery refactor

> **DESIGN-18:** Stage 2 Discovery intake refactor — consume `01_kickoff_v*` artefact (skip raw-notes mode); skip entire stage when kickoff produced a draft SOW; same template structure as v0.3.0 otherwise.

**Skill:** `discovery-intake/` (MODIFIED per DESIGN-12 inventory — input shape changed; raw-notes mode RETIRED).
**Stage:** 2 (file prefix `02_discovery_*` per DESIGN-02).
**Complexity:** Low (skip mode adds a branch; template body structurally unchanged from v0.3.0).

**Inputs.**
- **Frontmatter consumed:** `based_on_kickoff: 01_kickoff_v<N>` + `client:` + `project:` + `frontmatter_version: 2`. The `based_on_kickoff:` field is now MANDATORY (v0.3.0 lenient mode tolerated absence; v2 requires it).
- **Upstream artefact paths:** `01_kickoff_v<N>.md` (Stage 1 output, must carry `status: approved`).
- **External inputs:** none — raw-notes mode RETIRED. Discovery now derives strictly from the approved kickoff artefact; meeting notes / paste flows belong to Stage 1.

**Outputs.**
- **Carrier file:** `02_discovery_v<N>.md` in `<Client> Brain/<Project>/`.
- **Frontmatter set:** `based_on_kickoff: 01_kickoff_v<N>`, `client:`, `project:`, `frontmatter_version: 2`, `status: draft → client_review → approved` per DESIGN-01 canonical lifecycle.

**Skip behaviour (DESIGN-18 contract).** IF `01_kickoff_v<N>.md` carries `kickoff_branch: draft-sow`, this stage SKIPS entirely — Stage 1 output flows directly to Stage 3 (generate-sow). The `discovery-intake/` skill itself reads the upstream `kickoff_branch:` value first; if `draft-sow`, the skill emits an explicit "Stage 2 SKIPPED — kickoff produced draft SOW; routing to Stage 3" hand-off and exits without writing a `02_discovery_v<N>.md` artefact. No silent skip; reviewer sees the routing decision logged.

**Downstream consumer.** generate-sow (Stage 3).

**Status flag(s).** `status: approved` on `02_discovery_v<N>.md` gates Stage 3. Approval-gate hook (DESIGN-06) enforces `approved_by` + `approved_at`.

**Hand-off message (verbatim from DESIGN-13 matrix Stage 2 → Stage 3 row).**

> Awaiting status: approved write to 02_discovery_v<N>.md before generate-sow runs.

**Key v2 decisions for this stage.**

1. **Raw-notes mode RETIRED** — v0.3.0's "paste meeting notes here" entry path is removed; meeting-note ingestion now belongs to Stage 1. Discovery becomes a pure transform of approved kickoff. Eliminates the "did discovery start from notes or kickoff?" ambiguity that v0.3.0 silently allowed.
2. **Kickoff-as-input forces explicit `based_on_kickoff:`** — frontmatter field is mandatory (no v0.3.0 lenient absence). Approval-gate hook + frontmatter-validate hook (per DESIGN-04 plugin self-tests, D-24) refuse `02_discovery_v<N>.md` writes lacking the field.
3. **Skip-when-draft-SOW reads `kickoff_branch:`** — single enum field on the upstream kickoff steers the skip decision. No separate "is this a draft-SOW project?" flag; reuses DESIGN-17's branch field.
4. **Template structurally unchanged** — same v0.3.0 sections (system / users / triggers / data / rules / integrations / exceptions / failure-points). Migration path: existing v0.3.0 `02_discovery_v<N>.md` artefacts read clean against v2 readers (per DESIGN-08 frontmatter-version tolerance).

**Dependencies.** DESIGN-17 (Stage 1 produces `01_kickoff_v<N>.md` with `kickoff_branch:` enum); DESIGN-01 (canonical `status:` lifecycle, `based_on_*` field-naming convention); DESIGN-06 (approval-gate enforcement); DESIGN-08 (frontmatter migration co-existence — v2 readers tolerate v0.3.0 discovery artefacts via `frontmatter_version` field).

**Cross-references.** DESIGN-17 (backward — Stage 1 contract just populated above); DESIGN-19 (forward — Stage 3 SOW refactor; populated next in this plan); AUDIT.md §AUDIT-01.1 (v0.3.0 discovery-intake hand-off contract — input shape was meeting-notes-or-kickoff lenient; v2 locks to kickoff-only).

---

## Stage 3: SOW refactor

> **DESIGN-19:** Stage 3 SOW refactor — single SOW covering platform AND integration; status lifecycle locked to canonical scheme (DESIGN-01); structurally unchanged from v0.3.0 otherwise.

**Skill:** `generate-sow/` (UNCHANGED-structure / behaviour-modified per DESIGN-12 inventory — template body carries forward from v0.3.0; status-lifecycle and input-routing change).
**Stage:** 3 (file prefix `03_sow_*` per DESIGN-02).
**Complexity:** Medium (single-spec scope explicit; status-lifecycle alignment to DESIGN-01 canonical).

**Inputs.**
- **Frontmatter consumed (normal path):** `based_on_discovery: 02_discovery_v<N>` + `client:` + `project:` + `frontmatter_version: 2` + (optional) `platform:` if known at SOW time.
- **Frontmatter consumed (draft-SOW path):** `based_on_kickoff: 01_kickoff_v<N>` (when Stage 2 was skipped per DESIGN-17/18 dual-branch contract).
- **Upstream artefact paths:** `02_discovery_v<N>.md` (normal) OR `01_kickoff_v<N>.md` (draft-SOW path) — must carry `status: approved`.
- **External inputs:** none — SOW is a pure transform of the approved upstream artefact.

**Outputs.**
- **Carrier file:** `03_sow_v<N>.md` in `<Client> Brain/<Project>/`.
- **Frontmatter set:** `based_on_discovery:` OR `based_on_kickoff:` (one or the other, not both); `client:`, `project:`, `frontmatter_version: 2`, `platform:` (if known); `status: draft → client_review → approved`. The `client_review` value is RETAINED per AUDIT.md §AUDIT-01.2 + DESIGN-08 (live in `generate-sow` today; canonical lifecycle preserves it).

**Single-spec scope (DESIGN-19 contract).** ONE SOW covers BOTH platform work and integration work for a project — no Stage-3 split. The Stage 4 fnspec is where platform/integration split happens (per DESIGN-20 — forward reference, populated in Plan 02-06). Stage 3 SOW remains the unified commercial-and-scope artefact the client sees and approves.

**Downstream consumer.** generate-fnspec-platform (Stage 4a — forward reference, populated in Plan 02-06); generate-fnspec-integration (Stage 4b — forward reference, populated in Plan 02-06). Whether 4a, 4b, or both run depends on `platform:` and integration-scope fields populated during Stage 3 SOW review.

**Status flag(s).** `status: approved` on `03_sow_v<N>.md` (canonical) gates Stage 4. `status: client_review` retained as an interim state per DESIGN-08 (v0.3.0 SOW workflow uses it; reader tolerates it; approval-gate enforces lifecycle progression `draft → client_review → approved`).

**Hand-off message (verbatim from DESIGN-13 matrix Stage 3 → Stage 4a row).**

> Awaiting status: approved on 03_sow_v<N>.md; routing to Stage 4a (platform fnspec) and/or Stage 4b (integration fnspec) per project scope.

**Key v2 decisions for this stage.**

1. **Canonical 4-stage lifecycle** — `status: draft → client_review → approved → archived` (per DESIGN-01); SOW always passes through `client_review` interim state in practice. v0.3.0 `generate-sow` already does this; v2 locks the lifecycle as the canonical scheme.
2. **`client_review` retained** — explicit retention rationale: SOW is the artefact the client signs off on; commercial-review interim state is a real workflow stage, not a v0.3.0 quirk. Per AUDIT.md §AUDIT-01.2 + DESIGN-08 status-lifecycle survey result.
3. **Single SOW covers BOTH platform AND integration** — no Stage 3 split. Stage 4 (DESIGN-20) is where the platform-fnspec / integration-fnspec split happens. Stage 3 stays unified for client commercial review.
4. **Structurally unchanged from v0.3.0** — same SOW template body (scope summary, deliverables, assumptions, exclusions, commercial). Migration path: existing v0.3.0 `03_sow_v<N>.md` artefacts read clean against v2 readers via `frontmatter_version` tolerance (DESIGN-08).

**Dependencies.** DESIGN-17 (Stage 1 produces kickoff for draft-SOW path); DESIGN-18 (Stage 2 produces discovery for normal path); DESIGN-01 (canonical `status:` lifecycle including `client_review` retention); DESIGN-08 (frontmatter migration co-existence — `client_review` retained, v2 readers tolerate v0.3.0 SOW artefacts).

**Cross-references.** DESIGN-18 (backward — Stage 2 contract above); DESIGN-20 (forward — Stage 4 fnspec split downstream; populated in Plan 02-06 / Wave 6); AUDIT.md §AUDIT-01.2 (v0.3.0 generate-sow hand-off contract + `client_review` retention rationale grounded in survey).

## Stage 4a: Functional spec — platform

> **DESIGN-20:** Stage 4a Fnspec — platform — `generate-fnspec-platform` skill; per-requirement `delivery: native-ai | api` tagging (the routing key for downstream Stages 5 / 6 / 7b / 10); per-platform capability matrix as classifier input; cross-spec consistency check against 4b; optional for integration-only projects.

**Skill:** `generate-fnspec-platform/` (NEW per DESIGN-12 inventory; replaces v0.3.0 `generate-functional-spec` for platform portions per AUDIT.md §1.3 single-spec-for-everything anti-pattern).
**Stage:** 4a (file prefix `04a_fnspec-platform_*` per DESIGN-02).
**Complexity:** Medium-high (per CONTEXT specifics — Stage 4 fnspec split carries the most decision weight; routing-key contract drives 4 downstream stages).

**Inputs.**
- **Frontmatter consumed:** `based_on_sow: 03_sow_v<N>` + `client:` + `project:` + `frontmatter_version: 2` + `platform: pipefy | wrike | ziflow` (REQUIRED for this skill to run; activates platform-gated identifiers per DESIGN-01).
- **Upstream artefact path:** `03_sow_v<N>.md` (Stage 3 output, must carry `status: approved`).
- **External inputs:** per-platform capability matrix from the platform skill's `references/native-ai-inventory.md` (per DESIGN-14 / DESIGN-15 / DESIGN-16) — used as classifier input for `delivery:` tagging.

**Outputs.**
- **Carrier file:** `04a_fnspec-platform_v<N>.md` in `<Client> Brain/<Project>/`.
- **Per-requirement `delivery: native-ai | api` tagging (THE DESIGN-20 contract).** Each requirement row in the fnspec carries an explicit `delivery:` field. Classifier rule: when the requirement maps cleanly to a platform native-AI capability (per the platform's `native-ai-inventory.md` matrix at HIGH or MEDIUM confidence), `delivery: native-ai`; otherwise `delivery: api`. LOW-confidence native-AI capabilities default to `delivery: api` to avoid promising direct ingestion when only copy-paste works (per `## Out of Scope` discipline).
- **Frontmatter set:** `frontmatter_version: 2`; `based_on_sow:`; `platform: <X>`; `pipe_id` / `space_id` / `project_id` (whichever matches the platform per DESIGN-01 platform-gated identifier rules); `status: draft → client_review → approved`.

**Downstream consumer.**
- `generate-fnspec-integration` (Stage 4b — for cross-spec consistency check at start of 4b).
- `generate-technical-spec` (Stage 5 — reads `delivery: api` rows for platform-API addendum routing per DESIGN-21 — same wave).
- `generate-cost-estimate` (Stage 6 — uses `delivery:` for cost categorisation; forward reference, populated in Plan 02-07).
- `generate-implementation-prompt` (Stage 7b — uses `delivery:` for implementation prompt routing; forward reference, populated in Plan 02-07).
- `push-native-ai-knowledge` (Stage 10 — reads `delivery: native-ai` rows for ingest selection; forward reference, populated in Plan 02-08).

**Status flag(s).** `status: approved` on `04a_fnspec-platform_v<N>.md` gates Stage 4b consistency check + Stage 5 platform-API addendum routing. Stage 4a is OPTIONAL for integration-only projects (project skips directly to Stage 4b).

**Hand-off message (verbatim from DESIGN-13 matrix Stage 4a → Stage 4b row).**

> Awaiting `status: approved` to `04a`; cross-spec consistency check runs at start of 4b.

**Key v2 decisions for this stage.**

1. **Per-requirement `delivery:` tagging** — single routing key `delivery: native-ai | api` per requirement row. Drives 4 downstream stages (5 / 6 / 7b / 10) without re-classifying. Order is fixed: `native-ai | api` (NOT reversed) — locks the canonical literal.
2. **Per-platform capability matrix as classifier input** — Stage 4a reads the platform skill's `native-ai-inventory.md` (per DESIGN-14 / DESIGN-15 / DESIGN-16) and uses HIGH / MEDIUM confidence rows to suggest `delivery: native-ai`; LOW confidence (i.e., `[OPEN]`-flagged in the platform skill) defaults to `delivery: api` to avoid optimistic claims.
3. **Cross-spec consistency check (runs at start of 4b)** — when 4a + 4b both exist, a check at start of 4b verifies: (a) no requirement appears in both specs with conflicting `delivery:` tags; (b) integration touchpoints in 4b reference platform requirements in 4a by ID; (c) no orphan API endpoints. The check is OWNED by Stage 4b but DECLARED in both 4a and 4b for traceability (see Stage 4b key decisions).
4. **Optional for integration-only projects** — if the project has no platform-side work, Stage 4a does not run. SOW (Stage 3) `platform:` field absence signals this; project routes directly to Stage 4b.
5. **Legacy single fnspec retired** — `generate-functional-spec` (v0.3.0) is RETIRED per DESIGN-12 inventory + AUDIT.md §1.3 single-spec-for-everything anti-pattern (the legacy single fnspec retired in favour of the 4a + 4b split); v0.3.0 artefacts using the old skill remain readable per DESIGN-08 lenient `frontmatter_version` mode.

**Dependencies.** DESIGN-14 / DESIGN-15 / DESIGN-16 (per-platform capability matrices as classifier input — same wave precedent in Plan 02-04); DESIGN-01 (platform-gated identifier rules); DESIGN-08 (lenient mode for v0.3.0 single-fnspec artefacts).

**Cross-references.** DESIGN-19 (backward — Stage 3 SOW upstream); DESIGN-20 Stage 4b below (cross-spec consistency check ownership); DESIGN-21 (Stage 5 platform-API addendum — same wave); DESIGN-22 (Stage 6 reads `delivery:` for cost categorisation — forward reference, populated in Plan 02-07); DESIGN-23 (Stage 7b reads `delivery:` for implementation prompt routing — forward reference, populated in Plan 02-07); DESIGN-26 (Stage 10 reads `delivery: native-ai` rows for ingest — forward reference, populated in Plan 02-08); AUDIT.md §1.3 (v0.3.0 `generate-functional-spec` brittleness — single-spec-for-everything anti-pattern + status-lifecycle skip — backward, populated).

## Stage 4b: Functional spec — integration

> **DESIGN-20:** Stage 4b Fnspec — integration — `generate-fnspec-integration` skill; per-requirement `delivery: native-ai | api` tagging continues (per DESIGN-20 same routing key); cross-spec consistency check against 4a runs at start; optional for platform-only projects (Stage 5 SKIPPED with platform-API addendum on 4a instead).

**Skill:** `generate-fnspec-integration/` (NEW per DESIGN-12 inventory; the integration-side replacement for v0.3.0 `generate-functional-spec` per AUDIT.md §1.3).
**Stage:** 4b (file prefix `04b_fnspec-integration_*` per DESIGN-02).
**Complexity:** Medium-high (owns the cross-spec consistency check; same routing-key contract as 4a).

**Inputs.**
- **Frontmatter consumed:** `based_on_sow: 03_sow_v<N>` + (optional) `based_on_fnspec_platform: 04a_fnspec-platform_v<N>` if Stage 4a exists + `client:` + `project:` + `frontmatter_version: 2`.
- **Upstream artefact paths:** `03_sow_v<N>.md` (REQUIRED, must carry `status: approved`) + (optional) `04a_fnspec-platform_v<N>.md` (must carry `status: approved` if present).
- **External inputs:** none — integration-side requirements derive from the SOW (and optionally from cross-referenced platform fnspec).

**Outputs.**
- **Carrier file:** `04b_fnspec-integration_v<N>.md` in `<Client> Brain/<Project>/`.
- **Per-requirement `delivery: native-ai | api` tagging continues** — same routing-key contract as Stage 4a per DESIGN-20.
- **Cross-spec consistency report (when 4a exists):** `04b_consistency_check_v<N>.md` emitted FIRST, before fnspec write. Report shape: per-check pass/fail rows (ID-conflict / orphan-touchpoint / orphan-endpoint).
- **Frontmatter set:** `frontmatter_version: 2`; `based_on_sow:`; `based_on_fnspec_platform:` (if present); `status: draft → client_review → approved`.

**Cross-spec consistency check (THE Stage 4b key responsibility).** Runs FIRST, before any fnspec write. Three specific checks:
1. **No conflicting `delivery:` tags** — no requirement ID appears in both 4a and 4b with conflicting `delivery:` values (one says `native-ai`, the other says `api`).
2. **Integration touchpoint cross-references** — every integration touchpoint in 4b that references a platform requirement cites that requirement's ID from 4a (no dangling references).
3. **No orphan API endpoints** — every API endpoint declared in 4b traces back to a `delivery: api` requirement (no endpoints without backing requirements).

Failure of any check halts before fnspec write; emits `04b_consistency_check_v<N>.md` documenting the failure for human triage.

**Downstream consumer.** `generate-technical-spec` (Stage 5 — same wave; consumes `04b` REQUIRED); `generate-cost-estimate` (Stage 6 — forward reference, populated in Plan 02-07); `generate-build-prompt` (Stage 7a — forward reference, populated in Plan 02-07).

**Status flag(s).** `status: approved` on `04b_fnspec-integration_v<N>.md` gates Stage 5. Stage 4b is OPTIONAL for platform-only projects — when absent, Stage 5 SKIPS with platform-API addendum on 4a instead (per DESIGN-21 scope gate, same wave).

**Hand-off message (verbatim from DESIGN-13 matrix Stage 4b → Stage 5 row).**

> Awaiting `status: approved` to `04b`; Stage 5 tech spec runs (or SKIPS if no `04b`, with platform-API addendum on `04a` instead per DESIGN-21).

**Key v2 decisions for this stage.**

1. **Cross-spec consistency check OWNED here** — Stage 4b runs the check at start when both 4a and 4b exist. Three checks (ID-conflict / orphan-touchpoint / orphan-endpoint); failure halts before fnspec write. Declared in both 4a and 4b key-decisions for two-place traceability.
2. **Same `delivery: native-ai | api` tagging contract** — routing-key carries forward from 4a per DESIGN-20; downstream stages consume the same field whether it originates in 4a or 4b.
3. **Optional for platform-only projects** — when Stage 4b does not run, Stage 5 SKIPS and DESIGN-21's platform-API addendum routes on 4a instead (covers API-required portions of an otherwise platform-only build).
4. **Legacy single fnspec retired** — same as Stage 4a per DESIGN-12 inventory + AUDIT.md §1.3; v0.3.0 single-spec artefacts read clean against v2 readers via DESIGN-08 lenient `frontmatter_version` mode.

**Dependencies.** DESIGN-20 Stage 4a above (cross-spec consistency check input); DESIGN-01 (frontmatter scheme + status-lifecycle).

**Cross-references.** DESIGN-20 Stage 4a above (backward); DESIGN-21 (Stage 5 scope gate consumes 4b existence — same wave); DESIGN-22 (Stage 6 reads `delivery:` — forward reference, populated in Plan 02-07); DESIGN-23 Stage 7a (reads 4b for build prompt — forward reference, populated in Plan 02-07); AUDIT.md §1.3 (v0.3.0 single-spec anti-pattern — backward, populated).

## Stage 5: Tech spec

> **DESIGN-21:** Stage 5 Tech spec scope gate — REQUIRED only when Stage 4b exists; lightweight platform-API addendum on Stage 4a when API-required portions exist on platform-only build; covers error handling + observability + retries + idempotency for API portions; never hand-waves error paths.

**Skill:** `generate-technical-spec/` (MODIFIED per DESIGN-12 inventory — scope gate logic added against Stage 4b existence; error-paths discipline tightened from v0.3.0 baseline per AUDIT.md §1.4).
**Stage:** 5 (file prefix `05_techspec_*` per DESIGN-02).
**Complexity:** Medium (scope-gate decision tree adds branching; error-paths discipline adds per-endpoint structure).

**Inputs.**
- **Frontmatter consumed:** `based_on_fnspec_integration: 04b_fnspec-integration_v<N>` (REQUIRED for full path) + (optional) `based_on_fnspec_platform: 04a_fnspec-platform_v<N>` + `client:` + `project:` + `frontmatter_version: 2` + `platform:` (if known).
- **Upstream artefact paths:** `04b_fnspec-integration_v<N>.md` (REQUIRED for full path, must carry `status: approved`) + (optional) `04a_fnspec-platform_v<N>.md` (must carry `status: approved` if present and consumed).
- **External inputs:** none — tech spec is a pure transform of approved upstream fnspec(s).

**Outputs.**
- **Carrier file (full path):** `05_techspec_v<N>.md` in `<Client> Brain/<Project>/`.
- **Carrier file (skip path with addendum):** no `05_techspec_v<N>.md` written; `## Platform-API Addendum` H2 section appended INSIDE `04a_fnspec-platform_v<N>.md`; 4a frontmatter gains `has_platform_api_addendum: true`.
- **Frontmatter set (full path):** `frontmatter_version: 2`; `based_on_fnspec_integration:`; `based_on_fnspec_platform:` (if 4a consumed); `tech_spec_scope: full | platform-api-addendum-only`; `status: draft → approved`.

**Scope gate (THE DESIGN-21 contract — three branches).**

1. **Default path — full tech spec runs.** Stage 4b exists with `status: approved` → full `05_techspec_v<N>.md` written; `tech_spec_scope: full`.
2. **Skip path with platform-API addendum.** Stage 4b does NOT exist → tech spec SKIPS the standalone artefact. BUT if 4a has any requirement with `delivery: api`, a **platform-API addendum** runs INSIDE the 4a artefact as a `## Platform-API Addendum` H2 section appended to `04a_fnspec-platform_v<N>.md`; 4a frontmatter gains `has_platform_api_addendum: true`. `tech_spec_scope: platform-api-addendum-only` recorded for the addendum block. The addendum carries the same error-paths discipline as a full tech spec for the API portions only.
3. **Skip path with no addendum.** Stage 4b does NOT exist AND 4a has no `delivery: api` requirements → tech spec SKIPS entirely; no addendum required; no `05_techspec_v<N>.md` written; no 4a frontmatter change.

**Error-paths discipline (THE Stage 5 quality gate — per DESIGN-21 "never hand-waves error paths").** Every API endpoint enumerated by Stage 5 (full path or addendum) MUST carry the following four elements per endpoint — hand-waving is forbidden:

1. **Failure modes** — explicit list of failure conditions (timeouts, 4xx classes, 5xx classes, schema mismatches, rate-limit responses).
2. **Retry policy** — per-failure-mode retry decision (retry / don't retry / retry with backoff); backoff curve specified (constant / exponential / decorrelated jitter); max-retries bound.
3. **Idempotency** — per-endpoint idempotency key strategy (where the key comes from; whether the endpoint is naturally idempotent; what guarantees the upstream API provides).
4. **Observability** — per-endpoint logging contract (request ID propagation; error class tagging; success/failure metric emission).

**Downstream consumer.** `generate-cost-estimate` (Stage 6 — forward reference, populated in Plan 02-07); `generate-build-prompt` (Stage 7a — forward reference, populated in Plan 02-07).

**Status flag(s).** `status: approved` on `05_techspec_v<N>.md` (full path) gates Stage 6 — note Stage 6 ALSO requires the wait-for-commercial-inputs gate per DESIGN-22 (forward reference). For the addendum path, the parent 4a artefact's `status: approved` continues to gate downstream — addendum lives inside 4a so 4a's gate covers both.

**Hand-off message (verbatim from DESIGN-13 matrix Stage 5 → Stage 6 row).**

> Awaiting status: approved on 05_techspec_v<N>.md AND wait-for-commercial-inputs gate before generate-cost-estimate runs (per DESIGN-22).

**Key v2 decisions for this stage.**

1. **Scope-gate against Stage 4b existence** — full tech spec runs only when 4b exists; otherwise SKIP with addendum (when API portions exist) or SKIP entirely (when no API portions anywhere). Three explicit branches; no silent default.
2. **Lightweight platform-API addendum on Stage 4a** — covers the platform-only-build edge case where API-required portions still need error-paths discipline; addendum lives INSIDE 4a artefact (not a separate file) to keep the artefact count clean for platform-only projects. Frontmatter `has_platform_api_addendum: true` flags 4a artefacts carrying the addendum.
3. **Error-paths discipline — never hand-waves** — every API endpoint enumerates failure modes + retry policy + idempotency + observability. Per AUDIT.md §1.4 (v0.3.0 `generate-technical-spec` brittleness — error paths underspecified). Reviewer can grep per-endpoint for all four elements.

**Dependencies.** DESIGN-20 (Stage 4a / Stage 4b existence drives the scope gate; `delivery: api` rows drive the addendum decision); DESIGN-22 (forward reference — Stage 5 hand-off cites the wait-for-commercial-inputs gate downstream, populated in Plan 02-07).

**Cross-references.** DESIGN-20 Stage 4a above (consumed for addendum routing); DESIGN-20 Stage 4b above (REQUIRED upstream for full path); DESIGN-22 (Stage 6 wait-for-commercial-inputs gate — forward reference, populated in Plan 02-07); AUDIT.md §1.4 (v0.3.0 `generate-technical-spec` brittleness — error-paths discipline rationale — backward, populated).

## Stage 6: Cost estimate

> **DESIGN-22:** Stage 6 Cost estimate — per-assignee task breakdown (dev / non-dev / QA / lead); `estimated_hours` + `risk_adjusted_hours` columns with mandatory `rationale` field; closed risk-multiplier taxonomy (default L=<TBD-deferred> / M=<TBD-deferred> / H=<TBD-deferred> per D-22 — `[OPEN: Phase 4 — risk-multiplier defaults pending dYdX-historical validation per D-22]`); schema-introspection of existing client task table cached in `00_HUB.md`; Coda writes via `table_rows_manage` with `keyColumns` for idempotency, `mutationStatus` polling, rate-limit at 4 req/10s; wait-for-commercial-inputs gate before client-facing summary.

**Skill:** `generate-cost-estimate/` (NEW per DESIGN-12 inventory — replaces v0.3.0 ad-hoc cost estimation that lived implicitly in `generate-sow` commercial section per AUDIT.md §AUDIT-01.2; cost estimate is now its own stage with its own approval gate, its own carrier file, and its own Coda-mirror contract).
**Stage:** 6 (file prefix `06_cost_*` per DESIGN-02).
**Complexity:** **High** — heaviest single decision contract in DESIGN.md per CONTEXT specifics. Combines (a) the risk-multiplier taxonomy STRUCTURE-LOCK contract per D-22 with numerics DEFERRED, (b) the Coda integration mechanics (5 elements: schema-introspection cache, upsert with `keyColumns`, `mutationStatus` polling, rate-limit, halt-on-failure), and (c) the wait-for-commercial-inputs 2-halt-point gate. Stage 6 is also the first stage to write to a non-local mirror (Coda) per DESIGN-09 directional boundary.

**Inputs.**
- **Frontmatter consumed:** `based_on_fnspec_platform: 04a_fnspec-platform_v<N>` AND/OR `based_on_fnspec_integration: 04b_fnspec-integration_v<N>` (at least one MUST exist) + (optional) `based_on_techspec: 05_techspec_v<N>` (full path; absent on skip-with-addendum and skip-entirely scope-gate branches per DESIGN-21) + `client:` + `project:` + `frontmatter_version: 2`.
- **Upstream artefact paths:** `04a_fnspec-platform_v<N>.md` and/or `04b_fnspec-integration_v<N>.md` (at least one with `status: approved`); when full Stage 5 ran, `05_techspec_v<N>.md` (`status: approved`); when scope-gate took the addendum branch, `04a_fnspec-platform_v<N>.md` carries the `## Platform-API Addendum` H2 INSIDE 4a + frontmatter `has_platform_api_addendum: true` (per DESIGN-21).
- **External inputs:** Coda MCP (per AUDIT.md §AUDIT-08 — wired and working) for schema introspection of the client's existing task table + idempotent upserts; client `<Client> Brain/00_HUB.md` for `coda_tasks_schema:` cache (re-read per Stage 6 run to detect schema drift); commercial inputs (rates, head-count availability, sandbox capacity) provided by reviewer through the wait-for-commercial-inputs gate.

**Outputs.**
- **Carrier file (local — canonical):** `06_cost_v<N>.md` in `<Client> Brain/<Project>/`. Local artefact is the canonical source of truth per DESIGN-09 directional boundary; Coda task-table rows are a one-way mirror.
- **Intermediate carrier file:** `06_cost_inputs_v<N>.md` — the wait-for-commercial-inputs halt artefact. Lists the commercial inputs Stage 6 needs from the reviewer (rates per assignee class, head-count availability, sandbox capacity windows, any `[OPEN]`-flagged risk-multiplier numerics that need explicit reviewer override). Stage 6 halts on first run emitting this file; resumes when reviewer writes `commercial_inputs_status: provided` plus the input values into the artefact.
- **Coda mirror (downstream — one-way):** rows in the client's existing Coda task table — one row per task on the per-assignee breakdown. Mirror direction is local → Coda only per DESIGN-09; Coda → local merge is OUT OF SCOPE.
- **Frontmatter set:** `frontmatter_version: 2`; `based_on_fnspec_platform:` and/or `based_on_fnspec_integration:`; `based_on_techspec:` (when full path); `risk_multiplier_version:` (locks which numeric default set was used — `<TBD-deferred>` for v2 design phase; concrete values populated by Phase 4 OPEN-QUESTIONS resolution); `commercial_inputs_status: pending | provided`; `assignee_class:` (per-row on task breakdown — `dev | non-dev | QA | lead`); `status: draft → client_review → approved`.

**Risk-multiplier taxonomy (THE D-22 STRUCTURE-LOCK contract — numerics DEFERRED).**

Closed taxonomy: three tiers — Low (L), Medium (M), High (H). Mandatory `rationale:` field per row; reviewer cannot ship a row without naming why a specific tier was chosen. Validation owner = Stage 6 author + reviewer. Numeric defaults DEFERRED per D-22 — DESIGN.md uses placeholder syntax (`L=<TBD-deferred>`) and carries an inline `[OPEN: Phase 4 — risk-multiplier defaults pending dYdX-historical validation per D-22]` marker at point of use. Phase 4 OPEN-QUESTIONS owns resolution; the recommended set from research (~1.1 / ~1.3 / ~1.6) is the candidate but requires dYdX-historical validation before Stage 6 build phase locks numerics.

| Tier | Multiplier | Rationale required | Validation owner | Default value |
|------|------------|--------------------|-------------------|----------------|
| L (Low risk) | `risk_adjusted_hours = estimated_hours × <L_multiplier>` | yes — mandatory `rationale:` field | Stage 6 author + reviewer | `L=<TBD-deferred>` (research-recommended ~1.1; pending dYdX-historical validation per D-22) |
| M (Medium risk) | `risk_adjusted_hours = estimated_hours × <M_multiplier>` | yes — mandatory `rationale:` field | Stage 6 author + reviewer | `M=<TBD-deferred>` (research-recommended ~1.3; pending dYdX-historical validation per D-22) |
| H (High risk) | `risk_adjusted_hours = estimated_hours × <H_multiplier>` | yes — mandatory `rationale:` field | Stage 6 author + reviewer | `H=<TBD-deferred>` (research-recommended ~1.6; pending dYdX-historical validation per D-22) `[OPEN: Phase 4 — risk-multiplier defaults pending dYdX-historical validation per D-22]` |

**Per-assignee task breakdown (DESIGN-22 contract).**

Four assignee classes, locked: `dev | non-dev | QA | lead`. Every task row in `06_cost_v<N>.md` carries an `assignee_class:` field naming exactly one of the four. The artefact opens with a per-class summary table (4 rows × 3 columns: `class | sum(estimated_hours) | sum(risk_adjusted_hours)`) for quick reviewer scan; the per-task detail table follows below. Reviewer can grep the artefact by `assignee_class:` to assemble per-class workload before commercial review.

| Assignee class | Typical scope | Sum estimated_hours | Sum risk_adjusted_hours |
|----------------|---------------|---------------------|-------------------------|
| dev | API endpoints + integration code + automated tests | (computed) | (computed) |
| non-dev | platform configuration (Pipefy / Wrike / Ziflow Behaviors / Copilot / ReviewAI setup), KB content authoring, native-AI ingestion runs | (computed) | (computed) |
| QA | test-plan execution + UAT support + bug triage | (computed) | (computed) |
| lead | discovery / SOW / fnspec authoring + reviewer + client-facing communication | (computed) | (computed) |

**Coda integration mechanics (DESIGN-22 contract — exact values; never approximate).**

- **Schema introspection.** First Stage 6 run per client introspects the client's existing Coda task table schema via Coda MCP `table_columns_read`. Schema cached in `<Client> Brain/00_HUB.md` `coda_tasks_schema:` block. Subsequent Stage 6 runs re-read the cache and re-introspect; on schema drift, the skill halts and emits `06_schema_drift_v<N>.md` for human triage (do NOT silently re-map columns).
- **Upsert pattern.** Coda writes via `table_rows_manage` (Coda MCP) with `keyColumns` parameter set to the client task table's primary-key column(s). Idempotent — re-running Stage 6 against the same `06_cost_v<N>.md` produces no duplicate rows.
- **Mutation status polling.** Each `table_rows_manage` call returns a `mutationStatus` ID. Stage 6 polls until terminal state (success or failure). Failure halts; reviewer triages from `06_cost_v<N>.md` directly (local artefact remains canonical).
- **Rate limit.** 4 req/10 second sliding window (= 80% of Coda public ceiling 5 req/10s). Single Coda MCP client; no parallel writers from Stage 6.
- **Wait-for-commercial-inputs gate (DESIGN-22 contract — 2 halt points).** Two distinct halt points before Stage 6 can produce its client-facing summary:
  1. **Pre-write halt.** On first Stage 6 invocation, the skill emits `06_cost_inputs_v<N>.md` listing the commercial inputs the reviewer must provide (rates, head-count availability, sandbox capacity windows, any `[OPEN]`-flagged risk-multiplier numerics requiring reviewer override). Stage 6 halts here. Resume condition: the reviewer writes `commercial_inputs_status: provided` plus the actual input values into the artefact.
  2. **Pre-publish halt.** After Stage 6 computes the per-task breakdown and risk-adjusted totals, the skill halts AGAIN before pushing to Coda (so the reviewer reviews the totals against the provided commercial inputs before the Coda mirror lands). Resume condition: reviewer writes `status: approved` to `06_cost_v<N>.md`. Only then does the Coda upsert + `mutationStatus` polling happen.

**Downstream consumer.** generate-build-prompt (Stage 7a — same wave); generate-implementation-prompt (Stage 7b — same wave). Both read `06_cost_v<N>.md` for the costed scope before producing build / implementation prompts.

**Status flag(s).** `status: approved` on `06_cost_v<N>.md` gates Stage 7a / 7b. Approval-gate hook (per DESIGN-06) refuses `status: approved` writes lacking `approved_by` + `approved_at`. The pre-publish halt point is encoded as a hard gate inside the skill, not just at the approval-gate hook — Stage 6 will not run the Coda upsert until `status: approved` AND `commercial_inputs_status: provided` are both present.

**Hand-off message (verbatim from DESIGN-13 matrix Stage 6 → Stage 7a row).**

> Awaiting `status: approved` to `06`; locks costed scope before build-prompt generation.

**Key v2 decisions for this stage.**

1. **Closed L/M/H risk-multiplier taxonomy with mandatory `rationale:` field per row** — three tiers, no extras, rationale required for every row. Eliminates v0.3.0's implicit-cost-estimate brittleness where risk loading was author judgement without a documented multiplier.
2. **Numeric defaults DEFERRED per D-22** — DESIGN.md uses `L=<TBD-deferred>` placeholder syntax with inline `[OPEN: Phase 4 — risk-multiplier defaults pending dYdX-historical validation per D-22]` marker. Phase 4 OPEN-QUESTIONS owns resolution; Stage 6 build phase cannot lock numerics without the resolution.
3. **Per-assignee task breakdown — 4 classes locked** (`dev | non-dev | QA | lead`). Per-row `assignee_class:` field; per-class summary table at top of artefact; reviewer can grep by class for commercial review.
4. **Schema-introspection of existing client task table cached in `00_HUB.md`** — Stage 6 reads Coda MCP `table_columns_read` once per client, caches in `coda_tasks_schema:` block; subsequent runs detect drift and halt. Eliminates "did I push to the wrong column?" silent failures.
5. **Coda upsert via `table_rows_manage` with `keyColumns` + `mutationStatus` polling + 4 req/10s rate-limit** — exact mechanics locked. Idempotent; no duplicate rows on retry; rate-limit is 80% of public ceiling (5 req/10s) so Stage 6 stays well clear of throttling.
6. **Wait-for-commercial-inputs 2-halt-point gate** — pre-write halt (commercial inputs required before compute) + pre-publish halt (reviewer reviews totals before Coda mirror). Two distinct halts; neither bypasses the other.

**Dependencies.** DESIGN-04 (plugin surfaces — Coda MCP wired); DESIGN-09 (directional-boundary contract — local canonical, Coda one-way mirror, Coda upsert is the mirror direction); DESIGN-14 / DESIGN-15 / DESIGN-16 (per-platform schema introspection — when 4a `delivery: api` rows exist, per-platform schema affects task breakdown).

**Cross-references.** DESIGN-20 (`delivery: native-ai | api` routing key feeds task breakdown); DESIGN-21 (Stage 5 tech spec / `## Platform-API Addendum` informs API-portion estimates); DESIGN-23 Stage 7a (forward — same wave below); DESIGN-23 Stage 7b (forward — same wave below); AUDIT.md §AUDIT-08 (Coda MCP wiring confirmed working); Phase 4 OPEN-QUESTIONS register (risk-multiplier numeric defaults — pending dYdX-historical validation per D-22).

## Stage 7a: Build prompt — dev

> **DESIGN-23:** Stage 7a Build prompt — dev — `generate-build-prompt` skill (MODIFIED, carries forward from v0.3.0); pulls `delivery: native-ai | api` from Stage 4a per DESIGN-20 routing key; Stage 7a covers `delivery: api` requirements (dev-implementation territory) + Stage 5 tech-spec details for API endpoints.

**Skill:** `generate-build-prompt/` (MODIFIED per DESIGN-12 inventory — carries forward from v0.3.0 v0.3.0 baseline; modified to filter on `delivery: api` rows only and to read `delivery_filter: api` frontmatter as its scope contract). Stage 7a is the dev-implementation-prompt path; the per-platform implementation-prompt path lives in Stage 7b below.
**Stage:** 7a (file prefix `07a_build-prompt_*` per DESIGN-02).
**Complexity:** Medium (the skill itself carries forward; the modification is limited to the `delivery_filter:` scope contract and the per-row consumption of `delivery: api` tagging).

**Inputs.**
- **Frontmatter consumed:** `based_on_fnspec_integration: 04b_fnspec-integration_v<N>` (REQUIRED — Stage 7a primary input is the integration fnspec) + `based_on_techspec: 05_techspec_v<N>` (REQUIRED for full path; absent on the skip-with-addendum branch where API endpoints live in 4a's `## Platform-API Addendum` H2 instead) + `based_on_cost: 06_cost_v<N>` (REQUIRED — locks costed scope before build prompt) + (optional) `based_on_fnspec_platform: 04a_fnspec-platform_v<N>` (consumed when 4a has any `delivery: api` rows requiring API implementation work).
- **Upstream artefact paths:** `04b_fnspec-integration_v<N>.md` + `05_techspec_v<N>.md` (full path) OR `04a_fnspec-platform_v<N>.md` carrying `## Platform-API Addendum` (skip-with-addendum path) + `06_cost_v<N>.md` (must carry `status: approved` per Stage 6 hand-off).
- **External inputs:** none — Stage 7a is a pure transform of the approved upstream artefacts.

**Outputs.**
- **Carrier file:** `07a_build-prompt_v<N>.md` in `<Client> Brain/<Project>/`.
- **Frontmatter set:** standard set (`client:`, `project:`, `frontmatter_version: 2`, `based_on_fnspec_integration:`, `based_on_techspec:`, `based_on_cost:`, optional `based_on_fnspec_platform:`) + `delivery_filter: api` (the DESIGN-23 scope-tag — locks 7a to `delivery: api` rows only); `status: draft → approved`.

**What Stage 7a does NOT cover.** `delivery: native-ai` requirements (those route to Stage 7b — see below). The `delivery_filter: api` frontmatter is the explicit complement to Stage 7b's `delivery_filter: native-ai`; the two filters are disjoint.

**Downstream consumer.** dev (human implementer) — Stage 7a's output is a developer-facing build prompt for API / integration work.

**Status flag(s).** `status: approved` on `07a_build-prompt_v<N>.md` gates Stage 8a (provision-test-harness). Approval-gate hook (per DESIGN-06) refuses `status: approved` writes lacking `approved_by` + `approved_at`.

**Hand-off message (verbatim from DESIGN-13 matrix Stage 7a / 7b → Stage 8a row).**

> Awaiting `status: approved` to `07a` and/or `07b`; provision-test-harness reads `delivery:` routing.

**Key v2 decisions for this stage.**

1. **Reads `delivery: api` rows only — `delivery_filter: api` frontmatter** — Stage 7a scopes itself by the DESIGN-20 routing key. No re-classification; Stage 4a / 4b's `delivery:` tagging flows straight through.
2. **Carries forward from v0.3.0 `generate-build-prompt`** — same skill, same template body, only the `delivery_filter:` scope-tag and per-row `delivery: api` consumption are new. Migration path: existing v0.3.0 build-prompt artefacts read clean against v2 readers via `frontmatter_version` lenient mode (DESIGN-08).
3. **7a + 7b complementary, never overlapping** — Stage 7a `delivery_filter: api` and Stage 7b `delivery_filter: native-ai` are explicit disjoint sets; reviewer can grep both filters for the same project to verify no requirement falls through cracks (and no requirement is double-counted).

**Dependencies.** DESIGN-20 (`delivery: native-ai | api` routing key — Stage 7a reads `delivery: api` rows); DESIGN-21 (Stage 5 tech spec / `## Platform-API Addendum` provides API-endpoint details for the build prompt); DESIGN-22 (Stage 6 cost estimate locks costed scope before build prompt — `based_on_cost:` REQUIRED).

**Cross-references.** DESIGN-19 Stage 3 (SOW upstream); DESIGN-20 Stage 4a / 4b (routing key); DESIGN-21 Stage 5 (tech spec); DESIGN-22 Stage 6 (cost — same wave above); DESIGN-23 Stage 7b (complement — same wave below); DESIGN-24 Stage 8a (forward — anchor placeholder, populated in Plan 02-08); AUDIT.md §AUDIT-01.6 (v0.3.0 generate-build-prompt baseline).

## Stage 7b: Build prompt — implementation per platform

> **DESIGN-23:** Stage 7b Build prompt — implementation per platform — `generate-implementation-prompt` skill (NEW); per-platform shape (Pipefy = Behaviors instructions + KB upload list; Wrike = Copilot workflow narrative; Ziflow = checklist/criteria spec); explicitly NOT a universal template (per `## Out of Scope`); reads `delivery: native-ai` rows from Stage 4a per DESIGN-20 routing key.

**Skill:** `generate-implementation-prompt/` (NEW per DESIGN-12 inventory — net-new skill; no v0.3.0 ancestor). Stage 7b is the per-platform implementation-prompt path; complement to Stage 7a above. The skill dispatches on the upstream `platform:` frontmatter to one of three template paths (pipefy / wrike / ziflow); a single universal template is explicitly forbidden per `## Out of Scope`.
**Stage:** 7b (file prefix `07b_implementation-prompt_*` per DESIGN-02).
**Complexity:** Medium (per-platform dispatch adds branching; per-platform body shapes are concrete but bounded by the platform skill's `references/` shape from DESIGN-14/15/16).

**Inputs.**
- **Frontmatter consumed:** `based_on_fnspec_platform: 04a_fnspec-platform_v<N>` (REQUIRED — Stage 7b reads platform fnspec) + `based_on_cost: 06_cost_v<N>` (REQUIRED — locks costed scope) + `platform: pipefy | wrike | ziflow` (REQUIRED — drives per-platform dispatch); standard `client:`, `project:`, `frontmatter_version: 2`.
- **Upstream artefact paths:** `04a_fnspec-platform_v<N>.md` (must carry `status: approved`); `06_cost_v<N>.md` (must carry `status: approved`).
- **External inputs:** per-platform `references/api-contract.md` + `references/native-ai-inventory.md` from the matching `platform-pipefy/` / `platform-wrike/` / `platform-ziflow/` skill (per DESIGN-14 / DESIGN-15 / DESIGN-16). The native-AI capability matrix in `native-ai-inventory.md` directly drives the per-platform implementation shape (which Behaviors / Copilot workflows / ReviewAI checklists are HIGH/MEDIUM confidence vs LOW with `[OPEN]` flags).

**Outputs.**
- **Carrier file:** `07b_implementation-prompt_v<N>.md` in `<Client> Brain/<Project>/`.
- **Frontmatter set:** standard set + `delivery_filter: native-ai` (the DESIGN-23 scope-tag — locks 7b to `delivery: native-ai` rows only); `platform: <pipefy | wrike | ziflow>` (carried from upstream); `status: draft → approved`.

**Per-platform shape (DESIGN-23 contract — NOT a universal template).** The skill dispatches on `platform:` frontmatter to one of three concrete template paths. Each platform's implementation prompt has its own H2 structure; consolidating these into a single template that "fits all platforms" is FORBIDDEN per `## Out of Scope`.

- **Pipefy** (`platform: pipefy`): Behaviors instructions block + KB upload list. The artefact body opens with `## Behaviors instructions` H2 (per-Behavior natural-language instructions for Pipefy's AI Behaviors feature, grouped by Pipe stage) followed by `## KB documents to upload` H2 (enumerated list of KB documents the implementer manually uploads via the Pipefy UI; cites the source doc path in `<Client> Brain/<Project>/` for each). Grounded in `platform-pipefy/references/native-ai-inventory.md` HIGH-confidence Behaviors + KB rows; LOW-confidence rows ship with explicit `[OPEN]` markers per OPEN-01.
- **Wrike** (`platform: wrike`): Copilot workflow narrative. The artefact body opens with `## Copilot workflow narrative` H2 (prose narrative describing the per-stage Copilot workflow the implementer configures via the Wrike UI; grounded in `platform-wrike/references/native-ai-inventory.md` Copilot HIGH-confidence rows + 16 MCP tools matrix) followed by `## MCP tools required` H2 (enumerated list of Wrike MCP tools the workflow consumes; the OAuth `host` persistence rule per DESIGN-15 is the CRITICAL bug-prevention callout repeated here).
- **Ziflow** (`platform: ziflow`): checklist/criteria spec. The artefact body opens with `## ReviewAI checklists` H2 (per-checklist criteria spec for ReviewAI Checklists Public Preview; grounded in `platform-ziflow/references/native-ai-inventory.md` HIGH-confidence rows; Change Verification + Brand Standards MEDIUM-confidence rows ship with `[Coming Soon]` markers) followed by `## Manual paste fallback` H2 (the copy-paste fallback when ReviewAI knowledge-ingestion API is unavailable per OPEN-01 — read-after-create eventual consistency window also flagged here).
- **Universal anti-pattern (per `## Out of Scope`).** A single template that "fits all platforms" is FORBIDDEN. The skill MUST dispatch on `platform:` frontmatter to one of three template paths; reviewer can grep `^## (Behaviors instructions|Copilot workflow narrative|ReviewAI checklists)` in the artefact to confirm the dispatch landed on the right path.

**Downstream consumer.** non-dev (human implementer per platform) — Stage 7b's output is a non-developer-facing implementation prompt for native-AI / platform-config work. The implementer reads the per-platform shape and configures the platform via UI (Pipefy AI Behaviors / Wrike Copilot / Ziflow ReviewAI Checklists).

**Status flag(s).** `status: approved` on `07b_implementation-prompt_v<N>.md` gates Stage 8a (provision-test-harness). Both 7a and 7b approval are required when both run; either's absence (when its `delivery:` filter has no matching rows) is acceptable.

**Hand-off message (verbatim from DESIGN-13 matrix Stage 7a / 7b → Stage 8a row).**

> Awaiting `status: approved` to `07a` and/or `07b`; provision-test-harness reads `delivery:` routing.

**Key v2 decisions for this stage.**

1. **NEW skill — no v0.3.0 ancestor** — `generate-implementation-prompt/` is net-new per DESIGN-12 inventory. v0.3.0 had only the dev-build-prompt path; the per-platform implementation-prompt path is a v2 addition addressing AUDIT.md §AUDIT-01.6 brittleness (build prompt blurred dev / platform-config implementation lines).
2. **Per-platform shape — NOT a universal template** — three concrete shapes (Pipefy Behaviors instructions + KB upload list / Wrike Copilot workflow narrative / Ziflow ReviewAI checklists) explicitly diverge per platform. A consolidated universal template is forbidden per `## Out of Scope`. Reviewer-grep `^## (Behaviors instructions|Copilot workflow narrative|ReviewAI checklists)` confirms the dispatch.
3. **Reads `delivery: native-ai` rows only — `delivery_filter: native-ai` frontmatter** — Stage 7b scopes itself by the DESIGN-20 routing key (complement to Stage 7a's `delivery_filter: api`). No re-classification.
4. **Per-platform reference docs drive affordances** — each platform skill's `references/native-ai-inventory.md` drives which native-AI affordances are HIGH/MEDIUM/LOW confidence; LOW-confidence rows ship with explicit `[OPEN]` markers per OPEN-01 (Pipefy KB content-upload API; Wrike AI Studio knowledge-ingestion API; Ziflow ReviewAI knowledge-ingestion API). Reviewer triages `[OPEN]` markers before approval.

**Dependencies.** DESIGN-14 / DESIGN-15 / DESIGN-16 (per-platform skills — Stage 7b consumes `references/native-ai-inventory.md` from the matching platform skill); DESIGN-20 (`delivery: native-ai | api` routing key — Stage 7b reads `delivery: native-ai` rows).

**Cross-references.** DESIGN-19 Stage 3 (SOW upstream); DESIGN-20 Stage 4a (routing key + native-AI rows); DESIGN-22 Stage 6 (cost — same wave above); DESIGN-23 Stage 7a (complement — same wave above); DESIGN-24 Stage 8a (forward — anchor placeholder, populated in Plan 02-08); platform-pipefy / platform-wrike / platform-ziflow (per-platform `references/` consumed); REQUIREMENTS `## Out of Scope` (universal-template anti-pattern callout — backward, populated).

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

Three worked before/after examples drawn from real audit findings. Each shows a v0.3.0-style passage rewritten in v2 senior-implementer voice; the **Why the rewrite works** line names which DESIGN-10 voice principle the rewrite satisfies and which forbidden phrasing it eliminates.

### Example 1 — Truncated changelog/README sentence

**Source:** `AUDIT.md §AUDIT-07.1` — `dydx-delivery/README.md:126` truncated changelog entry for `0.3.0` reads: *"The bot-run terminal stage (`execute-tests`) now c"* and the file terminates mid-sentence.

**Before (v0.3.0-style):**
> We recommend that the README be updated — perhaps consider completing the truncated sentence at line 126; it might want to read something more complete.

**After (v2 senior-implementer voice):**
> Update `dydx-delivery/README.md:126` — replace the truncated sentence ending mid-clause with the completed claim: *"The bot-run terminal stage (`execute-tests`) now consumes the approved test plan and emits a results artefact under `<Client>/testing/<feature>/results-YYYY-MM-DD_v{N}.md`."*

**Why the rewrite works:** Eliminates "we recommend", "perhaps consider", "might want to" (3 forbidden phrasings). Satisfies principle 1 (no AI hedging — the rewrite is a claim) + principle 2 (specific over abstract — exact `file:line` cited) + principle 4 (imperative over advisory — "Update" not "we recommend").

---

### Example 2 — "Test sheet" residual wording

**Source:** `AUDIT.md §AUDIT-07.2` — `README.md:9` still says "discovery → SOW → functional spec → technical spec → **test sheet** → execution"; `dydx-delivery/README.md:126` records the 0.3.0 rename `generate-test-sheet` → `generate-test-plan` but the root README never followed.

**Before (v0.3.0-style):**
> Note that the document references a "test sheet" which may need attention. It's worth noting that the rename happened in 0.3.0 — please be aware that you might want to update this in order to reflect the current vocabulary.

**After (v2 senior-implementer voice):**
> Replace `test sheet` (`README.md:9`) with `test plan` — `test sheet` is v0.1.0 vocabulary; the 0.3.0 rename to `generate-test-plan` is recorded at `dydx-delivery/README.md:126` but never propagated to the root README.

**Why the rewrite works:** Eliminates "Note that", "may need attention", "It's worth noting", "please be aware", "might want to", "in order to" (6 forbidden phrasings or apology-prefaces). Satisfies principle 2 (specific over abstract — both source and rename-record cited with `file:line`) + principle 3 (no apology-prefaces) + principle 4 (imperative — "Replace" not "may need attention").

---

### Example 3 — Generic AI-style hedging in skill prose

**Source:** `AUDIT.md §AUDIT-01.1` — `dydx-delivery/skills/discovery-intake/SKILL.md:98-107` writes `status: draft` but the skill body documents no follow-up status word; `discovery-intake/SKILL.md:27-28` references workspace `hub.md` twice when no `hub.md` exists. Representative pattern of the hedged hand-off message brittleness category catalogued at `AUDIT.md §AUDIT-01`.

**Before (v0.3.0-style):**
> As an AI, I would suggest that you make sure to check the `hub.md` file for client context. Feel free to skip this if it's not available — perhaps consider using the discovery template directly.

**After (v2 senior-implementer voice):**
> Read `<Client> Brain/00_HUB.md` for client context; the v0.3.0 reference to `hub.md` (`dydx-delivery/skills/discovery-intake/SKILL.md:27-28`) is an orphan — `hub.md` does not exist in the repo (per `AUDIT.md §AUDIT-01.1`). On `00_HUB.md` absence, halt and surface the missing-hub error — do not fall through to a templated discovery.

**Why the rewrite works:** Eliminates "As an AI", "I would suggest", "make sure to", "Feel free to", "perhaps consider" (5 forbidden phrasings). Satisfies principle 1 (no AI hedging — the speaker is the implementor, not an AI) + principle 2 (specific over abstract — `file:line` for the orphan reference + AUDIT.md cite) + principle 5 (end with hand-off, not summary — closing sentence names the next action: halt + surface error).

---

*Design produced 2026-05-09; supersedes ad-hoc v0.3.0 architecture. Phase 3 CHANGELIST.md sequences the v2.x build against this design; Phase 4 OPEN-QUESTIONS.md catalogues every inline [OPEN] marker.*
