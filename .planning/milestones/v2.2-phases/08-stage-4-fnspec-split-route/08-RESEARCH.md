# Phase 8: Stage 4 Fnspec Split + ROUTE (incl. TD-2 inline) — Research

**Researched:** 2026-05-11
**Domain:** Plugin skill authoring (Anthropic Claude skill convention) — TWO NEW Stage 4 skills replacing the retiring v0.3.0 `generate-functional-spec/` + cross-cutting routing-key + TD-2 enum closeout + forward-compat smoke harness.
**Confidence:** HIGH (all source materials in-repo, design-locked, every CONTEXT.md decision verified line-by-line; only `[ASSUMED]` items are LOC predictions and verbatim wording polish).

## Summary

Phase 8 lands the highest-leverage v2 feature: the Stage 4 functional-spec split with `delivery: native-ai | api` per-requirement routing key. Posture is **lift-and-adapt** from Phase 7's shipped artefacts — the bash skeleton, the `references/` 3-file shape, the canonical-pointer block, the verbatim-skip-emit idiom, the sample-CR fixtures pattern, and the `--section` partitioned structure-check all carry forward 1:1. CONTEXT.md locks 9 decisions (D-78..D-86) with a 3-plan sequential slicing (D-80).

Three load-bearing observations the planner must act on:

1. **glossary.md line 66 STILL carries the OLD `kickoff_branch` enum spelling** (`kickoff-direct | discovery-via`) — Phase 7's research flagged this as R-02 with a recommendation to fix in 07-03 synthesis, but the fix never landed. Verified `grep -n` on `dydx-delivery/references/glossary.md` (line 66). Phase 8's ROUTE-04 work touches the same glossary file (routing-key entry update for `pipefy | wrike | ziflow | other`) — the planner should bundle the glossary `kickoff_branch:` fix into 08-03 alongside ROUTE-04 to avoid a second cross-phase miss. **Confidence: HIGH [VERIFIED: glossary.md:66 read directly].**
2. **D-78 enum touch-list is exactly 12 locations across 6 stage skills + their templates** — `grep -rn "pipefy | wrike" dydx-delivery/` returns a complete, mechanical enumeration (full table in §2.3 below). Two files (`generate-sow/SKILL.md:86` + `generate-sow/references/sow-template.md:3`) already carry the 4-enum form `pipefy | wrike | ziflow | other` from Phase 7's STG3-02 work — the planner asserts these as **anchors** (no edit needed). `frontmatter-scheme.md:41` + `glossary.md:71` (the `**platform**` glossary entry) similarly already carry the 4-enum form — they are anchors, not edits.
3. **`generate-functional-spec/references/` contains exactly 1 file** (`functional-spec-template.md`, 165 lines) — Phase 4 v0.3.0 baseline `STRUCTURE.md` said the directory was 7 files but actual count on disk is 1. STG4-03 retirement is therefore even simpler than CONTEXT.md `<code_context>` line 146 ("current 7-file shape") implies: removing the directory removes 2 files total (SKILL.md + 1 template). **Confidence: HIGH [VERIFIED: ls of directory; 165-line template read in full].**

**Primary recommendation:** Plan 08-01 lifts the functional-spec-template.md body shape wholesale into `fnspec-platform-template.md` (sections 1-10: scope / roles / journeys / business-rules / field-reqs / state-model / edge-cases / acceptance / open-Qs / out-of-scope), adding the D-82 `delivery:` row markup in the business-rules + field-reqs + acceptance tables. Plan 08-02 forks the same template shape for `fnspec-integration-template.md` with integration touchpoints + API-endpoint sections + `based_on_fnspec_platform:` frontmatter. Plan 08-03 ships the structure-check shell script (D-86), the REQUIREMENTS flips, the enum rollout, the glossary update (both the ROUTE-04 routing-key entry AND the carry-forward `kickoff_branch:` fix), and the `generate-functional-spec/` retirement. **Three sequential plans, no parallelism opportunity discovered** (D-80 confirmed).

## Architectural Responsibility Map

| Capability | Primary Tier | Secondary Tier | Rationale |
|------------|-------------|----------------|-----------|
| Stage 4a platform fnspec authorship + per-row `delivery:` tagging | Plugin skill (`generate-fnspec-platform/SKILL.md`) | Plugin reference (`auto-classify-rubric.md` for the classifier rules) | Stage 4a is the routing-key author tier; per-row tags flow from skill body Step N |
| Stage 4b integration fnspec authorship + consistency check | Plugin skill (`generate-fnspec-integration/SKILL.md`) | Plugin reference (`consistency-rules.md` for the 3 checks + failure-report template) | Stage 4b owns the cross-spec consistency contract per D-84 |
| Auto-classification rubric (HIGH/MED → native-ai, LOW/[OPEN] → api) | Plugin reference (`generate-fnspec-platform/references/auto-classify-rubric.md`) | Plugin skill (consumer) | D-81 / D-73 precedent — rubric extracted from SKILL.md body |
| Platform-API addendum body (D-79 author-now path) | Plugin reference (`addendum-template.md`) | Plugin skill (`generate-fnspec-platform/SKILL.md` body authors inline when conditions match) | D-79 locks 4a as author; v2.3 Stage 5 reads the addendum verbatim |
| Either-spec-skip topology rules | Plugin reference (`generate-fnspec-integration/references/either-spec-skip-paths.md`) | Plugin skill (consumer) | D-83 file #3 — three topologies + verbatim skip-emit string |
| `04b_consistency_check_v<N>.md` failure-report writing | Plugin skill body (`generate-fnspec-integration/SKILL.md` halt-path Step) | Plugin reference (failure-report template inside `consistency-rules.md`) | D-84 — halt-on-failure protocol; no shell script |
| `platform:` enum reconciliation across 6 stage skills + templates | Cross-cutting plan 08-03 task | n/a | Mechanical grep-and-edit; D-78 |
| Forward-compat smoke (synthetic Stage 5 / 6 / 7b / 10 consumer stubs) | Bash script (`scripts/phase8-structure-check.sh --section smoke`) | Fixture files under `fixtures/output/` | D-86 — shell stubs read frontmatter + iterate rows; pure stubs |
| REQUIREMENTS.md traceability flips (all 11 rows) | Cross-cutting plan 08-03 task | n/a | v2.1 retrospective pattern, applied in 07-04 already |

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

**D-78 — TD-2 resolution: ADD `ziflow` to stage-skill `platform:` enum** (path a, not path b).
Migrates from `pipefy | wrike | other` → `pipefy | wrike | ziflow | other` across every stage SKILL.md + template that declares the enum. `platform-ziflow/SKILL.md:14` routing-key claim RETAINED — D-78 wires it through. `dydx-delivery/references/glossary.md` routing-key entry updated to enumerate the 4 values with per-platform one-line definitions. Captured as DESIGN-20 sub-decision on update.

**D-79 — ROUTE-03 addendum body: Stage 4a authors `## Platform-API Addendum` H2 body inline in v2.2** (not stub-and-defer).
When (no 4b in scope) AND (4a has any `delivery: api` rows), `generate-fnspec-platform/SKILL.md` instructs the skill to author the FULL addendum H2 body (error-paths discipline matching a full tech spec, API portions only), append it inside `04a_fnspec-platform_v<N>.md`, and emit frontmatter `has_platform_api_addendum: true` + `tech_spec_scope: platform-api-addendum-only`. v2.3 Stage 5 reads + consumes verbatim. Addendum-body skeleton lives in `generate-fnspec-platform/references/addendum-template.md` (D-83 file #3).

**D-80 — Three atomic plans, sequential** (D-69 / D-63 precedent).

| Plan | Scope | Requirements | Depends on | Parallel-eligible |
|------|-------|--------------|------------|-------------------|
| `08-01-PLAN.md` | `generate-fnspec-platform/` (Stage 4a) end-to-end — SKILL.md + 3 `references/` files + 4a half of routing | STG4-01, STG4-04 (4a), STG4-05, ROUTE-03 (4a addendum body) | — | — |
| `08-02-PLAN.md` | `generate-fnspec-integration/` (Stage 4b) end-to-end — SKILL.md + 3 `references/` files + 4b half of routing + consistency check | STG4-02, STG4-04 (4b), ROUTE-01, ROUTE-02, ROUTE-03 (4b read-side) | 08-01 (4b reads approved 4a output) | — |
| `08-03-PLAN.md` | Retire + cross-cutting closeout — STG4-03 (remove generate-functional-spec/), STG4-06 (3-topology docs), ROUTE-04 (D-78 enum rollout), ROUTE-05 (forward-compat smoke), REQUIREMENTS flips, structure-check authoring | STG4-03, STG4-06, ROUTE-04, ROUTE-05 | 08-01 + 08-02 | — |

No parallel waves discovered. 08-03 split to 08-04 if content >~400 LOC (planner enforces at write time).

**D-81 — Classifier rubric per-skill at `generate-fnspec-platform/references/auto-classify-rubric.md`** (D-73 precedent).
Explicit rules + escalation table mapping HIGH/MEDIUM → suggest `delivery: native-ai`; LOW/`[OPEN]` → default `delivery: api`; reviewer-override-per-row mechanics; re-run preservation rule (rows carrying `[reviewer-override: ...]` markup are NOT re-classified). Stage 4a SKILL.md cites the rubric file. Stage 4b does NOT carry its own rubric — reads 4a's per-row tags as-is.

**D-82 — Per-row markup: terse inline marker `delivery: native-ai [HIGH, src: platform-pipefy]`.**
Canonical enum order `native-ai | api`; never reversed (STG4-04 lock). Suffix variants: `[HIGH, src: <platform>]` / `[MEDIUM, src: <platform>]` / `[LOW → default api, src: <platform>]` / `[reviewer-override: native-ai]` / `[reviewer-override: api]`. Unicode arrow `→` verbatim. `[reviewer-override:]` token is the re-run preservation trigger.

**D-83 — `references/` shape: 3 files per skill** (D-71 precedent).
- `generate-fnspec-platform/references/` — (1) `fnspec-platform-template.md` (2) `auto-classify-rubric.md` (3) `addendum-template.md`
- `generate-fnspec-integration/references/` — (1) `fnspec-integration-template.md` (2) `consistency-rules.md` (3) `either-spec-skip-paths.md`

**D-84 — Consistency check form: SKILL.md prose contract + `references/consistency-rules.md`** (no shell script).
Stage 4b SKILL.md states the behavioural contract — three checks FIRST before any 4b write; on failure emit `04b_consistency_check_v<N>.md` + HALT. Detailed rules + failure-report template + the three explicit checks (a) no conflicting `delivery:` across 4a/4b for same requirement ID; (b) every 4b integration touchpoint cites a 4a requirement ID; (c) no orphan API endpoints in 4b — live in `consistency-rules.md`. Two-place key-decisions declaration in BOTH 4a + 4b skill bodies per T-02-06-02 mitigation.

**D-85 — Either-spec-skip mechanics: verbatim skip log, stdout-only, no skip-marker file** (D-74 precedent).
Stage 4a runs normally — no "skip 4a" path. Stage 4b detects skip topology by combining (a) presence/absence of `04a_fnspec-platform_v*.md`; (b) `## Platform Scope` / `## Integration Scope` H2s in highest-version `03_sow_v*.md` (STG3-02 / D-75 signal); (c) explicit reviewer signal at invocation. When 4b out of scope, emit verbatim `Stage 4b SKIPPED — no integration work in scope` to stdout, write NO artefact, exit. Working default string; planner may polish but must lock verbatim before execute.

**D-86 — Forward-compat smoke: `phase8-structure-check.sh --section smoke` + fixture stubs** (D-77 precedent).
Ships in 08-03. Loads `04a_*` + `04b_*` fixtures from `fixtures/output/` (written during 08-01 / 08-02 e2e smoke per 07-04 pattern); reads each requirement row through synthetic Stage 5 / 6 / 7b / 10 consumer-stub functions (minimal `sed` / `awk` / `grep` to read frontmatter + iterate rows + re-emit `delivery:` field); grep-asserts no field stripping, no position drift, no enum reorder. Pure stub — no real downstream skill files. Pytest alternative rejected (scope creep — `dydx-delivery/tests/` doesn't exist; v2.2 D-86 uses shell pattern).

### Claude's Discretion

- Detailed body wording inside `fnspec-platform-template.md`, `fnspec-integration-template.md`, `addendum-template.md` — author from STG4 + DESIGN-20 + DESIGN-21 contracts; only section-shape + frontmatter contract + handoff-message anchors are locked.
- Exact thresholds inside `auto-classify-rubric.md` (e.g., "MEDIUM = ≥2 distinct verified MCP probes" vs "≥3") — planner picks at execute time within D-81 rule shape.
- Specific failure-row template inside `consistency-rules.md` for `04b_consistency_check_v<N>.md` — planner authors; only halt-on-failure contract + 3 checks are locked.
- Exact verbatim skip-emit string for D-85 (`Stage 4b SKIPPED — no integration work in scope` is the working default; planner may polish phrasing but must lock one string before execute).
- Per-skill plan-task counts inside each plan.
- Whether 08-03 splits to 08-04 (~400 LOC heuristic).
- Exact wording of synthetic Stage 5/6/7b/10 consumer-stub shell functions inside `--section smoke`.
- Whether the planner surfaces any STG4 / ROUTE OPEN-Q rows during research — **finding: zero rows** (see §1).

### Deferred Ideas (OUT OF SCOPE)

- Stage 5 actual consumption of `has_platform_api_addendum:` / `tech_spec_scope:` / addendum H2 — v2.3.
- Stage 6 cost-estimate consumption of `delivery:` — v2.3.
- Stage 7b implementation-prompt consumption of `delivery:` — v2.3.
- Stage 10 push-native-ai-knowledge consumption of `delivery:` — v2.5+.
- Stage 9 documentation publishing (`update-documentation/`) — v2.5 milestone.
- Test bot rebuild + persistent harness — v2.4+ Stage 8.
- Coda mirror / Coda hard dependency — v2.4+ Stage 6 + Stage 11.
- DESIGN-25 closed `doc_type` 9-enum — Stage 9 v2.5.
- Auto-migration of v0.3.0 `04_functional-spec_v*.md` artefacts — STG4-03 lenient-read only.
- Pytest-based test runner — D-86 uses structure-check.sh; pytest deferred.

</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description (verbatim from REQUIREMENTS.md) | Research Support |
|----|---------------------------------------------|-------------------|
| **STG4-01** | `generate-fnspec-platform/` skill exists at `dydx-delivery/skills/generate-fnspec-platform/` (Stage 4a, NEW). Reads approved `02_discovery_v*` + approved `03_sow_v*` + per-platform `references/native-ai-inventory.md`. Writes `04a_fnspec-platform_v<N>.md` per DESIGN-02. | §2.1 (08-01 file map); §3.1 (4a frontmatter contract); §4.1 (assertion P1-P3); D-83 |
| **STG4-02** | `generate-fnspec-integration/` skill exists at `dydx-delivery/skills/generate-fnspec-integration/` (Stage 4b, NEW). Reads approved discovery + approved SOW + Stage 4a output. Writes `04b_fnspec-integration_v<N>.md` per DESIGN-02. | §2.2 (08-02 file map); §3.2 (4b frontmatter contract); §4.1 (assertion I1-I3); D-83 |
| **STG4-03** | v0.3.0 `generate-functional-spec/` RETIRED — directory removed; references in templates / READMEs / changelogs updated; v0.3.0 artefacts remain readable per DESIGN-08 lenient mode; no auto-migration. | §2.3 (08-03 deletion target + retirement task); §5 (only 1 file in references/) |
| **STG4-04** | Both 4a and 4b emit per-requirement `delivery: native-ai \| api` routing-key tagging on every row. Canonical enum order; never reversed. | §3.1 (4a per-row markup); §3.2 (4b per-row markup); §4.1 (assertion R1); D-82 |
| **STG4-05** | Stage 4a classifier reads loaded platform's `native-ai-inventory.md`. HIGH/MEDIUM → suggest `delivery: native-ai`; LOW/`[OPEN]` → default `delivery: api`. Reviewer override per row preserved. | §3.1 (rubric file); §6 (native-ai-inventory.md row counts verified); D-81 |
| **STG4-06** | 4a and 4b independently optional — three valid topologies (4a-only / 4b-only / both). Either-spec-skip supported per DESIGN-20; downstream stages handle skip per DESIGN-21 Stage 5 scope-gate. | §2.3 (08-03 topology-doc task); §3.2 (either-spec-skip-paths.md); §4.1 (assertion T1-T3); D-85 |
| **ROUTE-01** | Cross-spec consistency check OWNED by Stage 4b. Runs FIRST. Three checks: (a) no conflicting `delivery:` across 4a/4b for same req ID; (b) every 4b integration touchpoint cites a 4a req ID; (c) no orphan API endpoints in 4b. Two-place key-decisions declaration. | §3.2 (consistency-rules.md); §4.1 (assertion C1-C3); D-84 |
| **ROUTE-02** | Consistency check failure halts Stage 4b BEFORE fnspec write; emits `04b_consistency_check_v<N>.md` listing failure rows. No silent inconsistent write. | §3.2 (halt-path frontmatter + body); §4.1 (assertion C4); D-84 |
| **ROUTE-03** | Stage 5 scope-gate contract DOCUMENTED in 4a/4b skill bodies as forward-compatible interface — three branches per DESIGN-21. v2.2 emits frontmatter + addendum; v2.3 consumes. | §3.1 (`has_platform_api_addendum:` + `tech_spec_scope:`); §3.2 (4b read-side of frontmatter chain); D-79 |
| **ROUTE-04** | TD-2 resolved per D-78 — `ziflow` added to stage-skill `platform:` enum across all consumers; `platform-ziflow/SKILL.md:14` retained; glossary routing-key entry updated. | §2.3 (08-03 enum rollout task); §2.3 enum touch-list table; §4.1 (assertion E1-E4); D-78 |
| **ROUTE-05** | `delivery:` routing key declared in 4a/4b propagates forward through `based_on_*` chains to Stage 5 / 6 / 7b / 10. v2.2 emits + forward-compatibility smoke; downstream consumption ships v2.3+. | §2.3 (08-03 smoke task); §4.1 (`--section smoke` assertions S1-S6); D-86 |

</phase_requirements>

## 1. OPEN-QUESTIONS.md scan — STG4 / ROUTE rows

**Finding: ZERO `STG4-*` or `ROUTE-*` rows exist in `.planning/OPEN-QUESTIONS.md`.**

Same posture as Phase 7 (which also found zero STG-named rows). All existing register rows are Q-prefixed legacy numbering; the only ones touching v2.2 scope are Q05 / Q06.2 / Q07.2 / Q15 / Q22 / Q23, all already `decided` per Phase 7's research. D-67 inline-resolution is therefore vacuously satisfied for Phase 8. Synthesis section in 08-03 carries no STG4 / ROUTE register-row flips — only the 11 REQUIREMENTS.md trace-table flips (D-67 + v2.1 retrospective pattern).

Confidence: **HIGH** [VERIFIED: grep `.planning/OPEN-QUESTIONS.md` — zero `STG4` / `ROUTE` matches].

## 2. Per-plan technical research

### 2.1 Plan 08-01 — `generate-fnspec-platform/` (Stage 4a, NEW)

**Requirements:** STG4-01, STG4-04 (4a half), STG4-05, ROUTE-03 (4a addendum body authorship per D-79)

**Files created:**

| Path | Purpose | LOC estimate |
|------|---------|--------------|
| `dydx-delivery/skills/generate-fnspec-platform/SKILL.md` | Stage 4a skill body — canonical-pointer block + Inputs + Output + 6 numbered Steps + Key decisions + What this skill does not do + Quality bar | ~130-160 (Phase 7 kickoff-capture is ~130; 4a is slightly richer due to D-79 addendum branch) |
| `dydx-delivery/skills/generate-fnspec-platform/references/fnspec-platform-template.md` | Artefact skeleton — frontmatter contract + 10 H2 sections + handoff message | ~180-200 (functional-spec-template.md baseline is 165 lines; +15-35 for `delivery:` row markup additions) |
| `dydx-delivery/skills/generate-fnspec-platform/references/auto-classify-rubric.md` | D-81 rubric — 5 explicit triggers + escalation table + reviewer-override mechanics + re-run preservation rule | ~70-90 (Phase 7 kickoff-capture rubric is 44 lines; this rubric has richer thresholds) |
| `dydx-delivery/skills/generate-fnspec-platform/references/addendum-template.md` | D-79 `## Platform-API Addendum` H2 body skeleton — error-paths discipline structure for API portions | ~80-120 (template is structural; exact contents are planner discretion within D-79 contract) |
| `.planning/phases/08-stage-4-fnspec-split-route/fixtures/output/sample-cr-04a_fnspec-platform_v1.md` | e2e smoke fixture (capture during plan close) | ~120-180 (mirrors functional-spec-template.md fully filled) |

**Files modified:** None. (08-01 is fully greenfield within `dydx-delivery/skills/generate-fnspec-platform/`.)

**Lift-and-adapt sources:**

| Source | Lift target | Notes |
|--------|-------------|-------|
| `dydx-delivery/skills/generate-functional-spec/references/functional-spec-template.md` (165 lines, full) | `fnspec-platform-template.md` body shape — sections 1 (Scope summary) / 2 (User roles) / 3 (User journeys) / 4 (Business rules) / 5 (Field-level requirements) / 6 (State model) / 7 (Edge cases) / 8 (Acceptance criteria) / 9 (Open questions) / 10 (Out-of-scope clarifications) + Handoff footer | Section 4 (Business rules) + Section 5 (Field reqs) + Section 8 (Acceptance criteria) tables gain a new `Delivery` column carrying the D-82 markup (`delivery: native-ai [HIGH, src: platform-pipefy]` etc.) |
| `dydx-delivery/skills/generate-functional-spec/SKILL.md` (113 lines, full) | `generate-fnspec-platform/SKILL.md` body — Step 1 (Locate upstream artefact) / Step 2 (Check for existing fnspec) / Step 3 (Draft the fnspec) / Step 4 (Senior-level challenge) / Step 5 (Write + handoff) | Replace v0.3.0 single-input "latest SOW" with 4a's three-input contract (approved `02_discovery_v*` + approved `03_sow_v*` + per-platform `native-ai-inventory.md`). Add Step 3b: per-row classification per D-81 rubric. Add Step 5a: if no-4b + has `delivery: api` rows → author `## Platform-API Addendum` body (D-79) |
| `dydx-delivery/skills/kickoff-capture/SKILL.md` (4 canonical-pointer block quotes, lines 10, 12, 14, 16) | 4a SKILL.md canonical-pointer block — verbatim 4-pointer pattern (safety-rules + stage-numbering + frontmatter-scheme + glossary) | Adapt topic-line wording per skill role: "writes `04a_fnspec-platform_v<N>.md`"; "emits `delivery:` + `based_on_*` + `has_platform_api_addendum:` fields"; etc. |
| `dydx-delivery/skills/kickoff-capture/references/auto-classify-rubric.md` (44 lines, full) | `auto-classify-rubric.md` body shape — Explicit triggers / Input-signal → outcome escalation table / Operational principle / How this rubric is consumed | Replace 5 kickoff triggers with 4a-specific rules: (a) HIGH/MEDIUM in `native-ai-inventory.md` → suggest native-ai; (b) LOW → default api; (c) `[OPEN]` → default api; (d) reviewer override per row preserved; (e) re-run preservation when row carries `[reviewer-override:]` token |
| `dydx-delivery/skills/discovery-intake/SKILL.md:23-29` (Step 1 — Locate upstream + start-at-any-point triage) | 4a SKILL.md Step 1 — locate approved upstream artefacts (discovery + SOW); start-at-any-point triage when not found | Same triage pattern with three options: paste / walk-through / cancel |

**Frontmatter contract for `04a_fnspec-platform_v<N>.md`:**

```yaml
---
client: <CLIENT_NAME>
project: <PROJECT_NAME>
frontmatter_version: 2
platform: <pipefy | wrike | ziflow | other>     # D-78 expanded enum
based_on_discovery: 02_discovery_v<N>.md         # MANDATORY when discovery exists
based_on_sow: 03_sow_v<N>.md                     # MANDATORY (single SOW path)
based_on_kickoff: 01_kickoff_v<N>.md             # CONDITIONAL — only when discovery skipped (kickoff_branch: draft-sow path)
status: draft                                    # canonical 4-state lifecycle: draft → client_review → approved → archived
has_platform_api_addendum: <true | false>        # D-79 — present only when 4b is OUT of scope AND 4a has any delivery: api rows
tech_spec_scope: <platform-api-addendum-only>    # D-79 — present only when has_platform_api_addendum: true
approved_by: <name-or-handle>                    # MANDATORY on status: approved writes (DESIGN-06)
approved_at: <ISO date>                          # MANDATORY on status: approved writes (DESIGN-06)
generated_at: <ISO date>
---
```

**Per-row markup contract (D-82):**

Every row in Section 4 (Business rules) / Section 5 (Field-level requirements) / Section 8 (Acceptance criteria) of the platform fnspec carries the literal token in a `Delivery` column:

```
delivery: native-ai [HIGH, src: platform-pipefy]
delivery: native-ai [MEDIUM, src: platform-wrike]
delivery: api [LOW → default api, src: platform-ziflow]
delivery: api [reviewer-override: api]
delivery: native-ai [reviewer-override: native-ai]
```

Canonical enum order is `native-ai | api` — STG4-04 lock; structure-check assertion R1 grep-asserts this on every requirement row in the fixture.

**Step body sketch (5-8 steps):**

1. **Step 1 — Locate approved upstream artefacts** — Find highest-version approved `02_discovery_v*.md` + approved `03_sow_v*.md`. If discovery is absent (kickoff_branch=draft-sow path), use approved `01_kickoff_v*.md` directly per `based_on_kickoff:`. Start-at-any-point triage on missing inputs.
2. **Step 2 — Load platform skill's native-AI inventory** — Read `dydx-delivery/skills/platform-<platform>/references/native-ai-inventory.md` matching the SOW's `platform:` value. Cache HIGH/MEDIUM/LOW/`[OPEN]` confidence rows for Step 3 classifier.
3. **Step 3 — Check for existing 4a artefact + re-run policy** — If `04a_fnspec-platform_v*.md` exists, ask revise / extend / fresh; on revise, scan existing rows for `[reviewer-override:]` tokens and PRESERVE them (do not re-classify) per D-81.
4. **Step 4 — Draft the platform fnspec body** — Walk SOW `## Platform Scope` deliverable-by-deliverable; produce sections 1-10 per `references/fnspec-platform-template.md`. For every row in sections 4/5/8, apply the D-81 rubric → emit `delivery: native-ai | api [<confidence>, src: <platform>]` markup per D-82.
5. **Step 5 — Scope-gate branch decision (ROUTE-03 / D-79)** — Determine 4b topology from SOW `## Integration Scope` + presence/absence of 4a `delivery: api` rows. If no-4b-in-scope AND 4a has `delivery: api` rows → set `has_platform_api_addendum: true` + `tech_spec_scope: platform-api-addendum-only` AND author the `## Platform-API Addendum` H2 body using `references/addendum-template.md` (full error-paths discipline per D-79). Else → omit both frontmatter fields and the addendum.
6. **Step 6 — Senior-level challenge** — Pressure-test per the lifted functional-spec checks (every business rule numbered + unambiguous; every SOW platform deliverable has at least one user journey + AC block; edge cases concrete not generic; no platform-implementation details leaked).
7. **Step 7 — Write and hand off** — Write to `<Client> Brain/<Project>/04a_fnspec-platform_v<N>.md`. Emit verbatim handoff: "Awaiting status: approved on `04a_fnspec-platform_v<N>.md`; routing to Stage 4b (integration fnspec) if integration scope exists, else Stage 5 v2.3 reads frontmatter directly." (Planner may polish; lock verbatim before execute.)

**`references/` folder concrete file shape (D-83):**

| File | Contains (concrete) |
|------|---------------------|
| `fnspec-platform-template.md` | Frontmatter block (per §2.1 contract above) + H1 title + 10 H2 sections (Scope summary / User roles / User journeys / Business rules / Field reqs / State model / Edge cases / Acceptance criteria / Open questions / Out-of-scope) + Handoff footer. Sections 4/5/8 tables include a `Delivery` column with D-82 markup placeholders inline. |
| `auto-classify-rubric.md` | (a) Intro paragraph citing consumer (Step 3); (b) Explicit triggers section — 4-5 rules tied to `native-ai-inventory.md` confidence levels per STG4-05; (c) Input-signal → outcome escalation table (HIGH/MEDIUM/LOW/`[OPEN]` × suggest native-ai / default api / preserve reviewer-override); (d) Operational principle backstop; (e) Re-run preservation rule (rows carrying `[reviewer-override:]` token are NOT re-classified) per D-82; (f) How this rubric is consumed footer citing SKILL.md Step 3 + structure-check assertion. |
| `addendum-template.md` | `## Platform-API Addendum` H2 body skeleton — sub-sections: API surface inventory (endpoints + auth + rate limits per row) / Error paths (HTTP error class → expected behaviour, per-platform error mapping) / Retry + idempotency rules / Observability hooks. Each row carries the D-82 `delivery:` markup pattern (only `delivery: api` rows make sense in the addendum, but the row format matches the platform fnspec body for forward-compat smoke). |

---

### 2.2 Plan 08-02 — `generate-fnspec-integration/` (Stage 4b, NEW)

**Requirements:** STG4-02, STG4-04 (4b half), ROUTE-01, ROUTE-02, ROUTE-03 (4b read-side of `has_platform_api_addendum:` from 4a)

**Files created:**

| Path | Purpose | LOC estimate |
|------|---------|--------------|
| `dydx-delivery/skills/generate-fnspec-integration/SKILL.md` | Stage 4b skill body — canonical-pointer block + Inputs + Output + 7 numbered Steps (including consistency-check FIRST step + halt-path) + Key decisions + What this skill does not do + Quality bar | ~150-180 (slightly richer than 4a due to consistency-check + halt-path) |
| `dydx-delivery/skills/generate-fnspec-integration/references/fnspec-integration-template.md` | Integration fnspec skeleton — frontmatter contract + integration touchpoints + API-endpoint section + per-row `delivery:` markup | ~150-180 |
| `dydx-delivery/skills/generate-fnspec-integration/references/consistency-rules.md` | The three checks + halt-on-failure protocol + `04b_consistency_check_v<N>.md` failure-report template | ~80-110 |
| `dydx-delivery/skills/generate-fnspec-integration/references/either-spec-skip-paths.md` | STG4-06 three-topology rules (4a-only / 4b-only / both) + input detection logic + verbatim D-85 skip-emit string + per-topology behavioural contract | ~60-90 |
| `.planning/phases/08-stage-4-fnspec-split-route/fixtures/output/sample-cr-04b_fnspec-integration_v1.md` | e2e smoke fixture (capture during plan close) | ~120-180 |
| `.planning/phases/08-stage-4-fnspec-split-route/fixtures/output/sample-cr-04b_consistency_check_v1.md` | Halt-path fixture demonstrating consistency-check failure-report format | ~30-50 |

**Files modified:** None. (08-02 is fully greenfield within `dydx-delivery/skills/generate-fnspec-integration/`.)

**Lift-and-adapt sources:**

| Source | Lift target | Notes |
|--------|-------------|-------|
| `dydx-delivery/skills/generate-functional-spec/references/functional-spec-template.md` (165 lines) | `fnspec-integration-template.md` body shape — same 10-section spine | Sections 3 (User journeys), 4 (Business rules), 5 (Field reqs) re-aimed at INTEGRATIONS: replace user-role journeys with system-to-system data-flow journeys; replace business rules with integration-touchpoint rules; add a NEW section between 5 and 6 (call it "5b API endpoints" or rename Section 5 to "Integration touchpoints + API endpoints") per ROUTE-01 check (c) orphan-endpoint rule |
| 08-01 `generate-fnspec-platform/SKILL.md` (produced by plan 08-01) | 4b SKILL.md canonical-pointer block + Step 1 (Locate upstream) shape | Lift the canonical-pointer 4-block pattern verbatim; adapt Inputs to add `04a_fnspec-platform_v*.md` as upstream + sibling discovery + SOW |
| `dydx-delivery/skills/discovery-intake/SKILL.md` skip-emit body (per Phase 7 D-74 / 07-RESEARCH §11 R-01) | 4b SKILL.md Step 2 (either-spec-skip branch) | Verbatim skip-emit pattern: `echo` + stdout-only + no file written + exit. Replace skip-message string with `Stage 4b SKIPPED — no integration work in scope` (D-85 working default) |
| `dydx-delivery/skills/kickoff-capture/references/auto-classify-rubric.md` shape (5-trigger structure) | `consistency-rules.md` shape — three checks documented as ordered list + escalation table + halt protocol | Repurpose the rubric structure for the 3 consistency checks; add the halt-on-failure failure-report template at the end (failure rows table + retry mechanics for reviewer) |

**Frontmatter contract for `04b_fnspec-integration_v<N>.md`:**

```yaml
---
client: <CLIENT_NAME>
project: <PROJECT_NAME>
frontmatter_version: 2
platform: <pipefy | wrike | ziflow | other>     # carried forward from 4a + SOW
based_on_discovery: 02_discovery_v<N>.md         # MANDATORY when discovery exists
based_on_sow: 03_sow_v<N>.md                     # MANDATORY
based_on_fnspec_platform: 04a_fnspec-platform_v<N>.md  # CONDITIONAL — present when 4a exists (the 'both' topology); absent on the 4b-only topology
status: draft → client_review → approved → archived
approved_by: <name-or-handle>                    # MANDATORY on approved
approved_at: <ISO date>
generated_at: <ISO date>
---
```

**Frontmatter contract for `04b_consistency_check_v<N>.md` (halt-path artefact, ROUTE-02):**

```yaml
---
client: <CLIENT_NAME>
project: <PROJECT_NAME>
frontmatter_version: 2
artefact_type: consistency_check_failure
based_on_fnspec_platform: 04a_fnspec-platform_v<N>.md
based_on_attempted_fnspec_integration: <intended-04b-filename-or-N/A-if-pre-write>
checks_run: 3
checks_failed: <N>
status: halt
generated_at: <ISO date>
---
```

Body lists failure rows in a table: `Check ID | Failure type | Row reference | Detail | Suggested resolution`. Reviewer resolves, re-invokes Stage 4b; new artefact `04b_consistency_check_v<N+1>.md` written on next failure (versioned) or clean-check run produces `04b_fnspec-integration_v<N>.md` and skips emitting a fresh check artefact.

**Per-row markup contract:** Same D-82 pattern as 4a, applied to 4b rows. STG4-04 lock applies symmetrically.

**Step body sketch (7-9 steps):**

1. **Step 1 — Locate approved upstream artefacts** — Find approved `02_discovery_v*` + approved `03_sow_v*` + approved `04a_fnspec-platform_v*.md` if present. Start-at-any-point triage on missing inputs.
2. **Step 2 — Either-spec-skip detection (D-85)** — Combine signals: (a) presence/absence of `04a_*`; (b) SOW `## Platform Scope` + `## Integration Scope` H2 content; (c) explicit reviewer signal at invocation. If determined out-of-scope → emit verbatim `Stage 4b SKIPPED — no integration work in scope` to stdout, write NO artefact, exit. Topology rules cited from `references/either-spec-skip-paths.md`.
3. **Step 3 — Run consistency checks FIRST (D-84, before any write)** — Three checks against approved 4a output + draft 4b plan: (a) no requirement ID with conflicting `delivery:` tag across 4a/4b; (b) every 4b integration touchpoint cites a 4a requirement ID (no dangling refs); (c) no orphan API endpoints in 4b (every endpoint maps to a requirement). On any failure → write `04b_consistency_check_v<N>.md` listing failure rows, emit halt message, exit. No 4b fnspec is written.
4. **Step 4 — Check for existing 4b artefact + re-run policy** — If `04b_fnspec-integration_v*.md` exists, ask revise / extend / fresh; preserve `[reviewer-override:]` tokens per D-82.
5. **Step 5 — Draft the integration fnspec body** — Walk SOW `## Integration Scope` touchpoint-by-touchpoint; produce 10 sections per template. Apply D-82 row markup using 4a's classifications as input (no independent classifier — Stage 4b reads 4a tags as-is per D-81 closing clause).
6. **Step 6 — Senior-level challenge** — Cross-check integration touchpoints against discovery's data-flow narrative; verify every API endpoint has explicit error-path rules; surface any orphan touchpoints not in the SOW.
7. **Step 7 — Write and hand off** — Write to `<Client> Brain/<Project>/04b_fnspec-integration_v<N>.md`. Emit verbatim handoff: "Awaiting status: approved on `04b_fnspec-integration_v<N>.md`; Stage 5 (v2.3) will read both 4a + 4b via `based_on_*` chain." (Planner polishes; lock verbatim before execute.)

**`references/` folder concrete file shape (D-83):**

| File | Contains (concrete) |
|------|---------------------|
| `fnspec-integration-template.md` | Frontmatter block (per §2.2 contract) + H1 + 10 H2 sections; integration touchpoints table (Section 4/5) carries the `Delivery` column with D-82 markup. New "API endpoints" sub-section explicit per ROUTE-01 check (c). |
| `consistency-rules.md` | (a) Intro paragraph + ownership statement (Stage 4b runs FIRST per D-84); (b) The three checks as ordered list with concrete trigger logic per check; (c) Halt-on-failure protocol — emit `04b_consistency_check_v<N>.md` + exit before fnspec write; (d) Failure-report template (table format for the consistency_check artefact body); (e) Reviewer-retry mechanics (resolve in 4a or 4b, then re-invoke 4b); (f) Two-place key-decisions cross-reference (4a SKILL.md + 4b SKILL.md key-decisions sections both declare D-78/D-79/D-82/D-84/D-85 per T-02-06-02). |
| `either-spec-skip-paths.md` | (a) STG4-06 three-topology table — 4a-only / 4b-only / both — input detection signals + behavioural contract per topology; (b) D-85 verbatim skip-emit string locked: `Stage 4b SKIPPED — no integration work in scope`; (c) D-75 SOW signal documentation (`## Platform Scope` / `## Integration Scope` H2s read for topology hints); (d) Reviewer-override path when SOW signal is ambiguous; (e) Forward-compat note: 4a-only topology → Stage 5 v2.3 reads addendum (D-79); 4b-only topology → Stage 5 reads only 4b; both topology → Stage 5 reads chain. |

---

### 2.3 Plan 08-03 — Retire + cross-cutting closeout

**Requirements:** STG4-03 (retire generate-functional-spec/), STG4-06 (three-topology docs in both new skills), ROUTE-04 (D-78 enum rollout + glossary update), ROUTE-05 (forward-compat smoke via D-86), REQUIREMENTS.md trace flips (11 rows), `phase8-structure-check.sh` authoring with `--section <4a|4b|route|smoke|all>` partitioning.

**Files created:**

| Path | Purpose | LOC estimate |
|------|---------|--------------|
| `.planning/phases/08-stage-4-fnspec-split-route/scripts/phase8-structure-check.sh` | Phase 8 structure-check — 4 sections + `--all` cross-section + dispatcher | ~250-320 (Phase 7 phase7-structure-check.sh is 207 lines, includes 3 sections + cross; Phase 8 has 4 sections + smoke section's stub functions, so larger) |

**Files modified:**

| Path | Change | Notes |
|------|--------|-------|
| `dydx-delivery/skills/discovery-intake/SKILL.md:114` | `platform: <pipefy \| wrike \| other>` → `platform: <pipefy \| wrike \| ziflow \| other>` | D-78 enum rollout |
| `dydx-delivery/skills/discovery-intake/references/intake-template.md:3` | `platform: <pipefy \| wrike \| other>` → `platform: <pipefy \| wrike \| ziflow \| other>` | D-78 enum rollout |
| `dydx-delivery/skills/discovery-intake/references/intake-template.md:45` | `**Primary platform:** <pipefy \| wrike \| other>` → `**Primary platform:** <pipefy \| wrike \| ziflow \| other>` | D-78 enum rollout (prose form in template body) |
| `dydx-delivery/skills/generate-build-prompt/SKILL.md:114` | `platform: <pipefy \| wrike \| other>` → `platform: <pipefy \| wrike \| ziflow \| other>` | D-78 enum rollout |
| `dydx-delivery/skills/generate-build-prompt/references/build-prompt-template.md:3` | `platform: <pipefy \| wrike \| other>` → `platform: <pipefy \| wrike \| ziflow \| other>` | D-78 enum rollout |
| `dydx-delivery/skills/generate-technical-spec/SKILL.md:101` | `platform: <pipefy \| wrike \| other>` → `platform: <pipefy \| wrike \| ziflow \| other>` | D-78 enum rollout |
| `dydx-delivery/skills/generate-technical-spec/references/technical-spec-template.md:3` | `platform: <pipefy \| wrike \| other>` → `platform: <pipefy \| wrike \| ziflow \| other>` | D-78 enum rollout |
| `dydx-delivery/skills/generate-test-plan/SKILL.md:96` | `platform: <pipefy \| wrike \| other>` → `platform: <pipefy \| wrike \| ziflow \| other>` | D-78 enum rollout |
| `dydx-delivery/skills/generate-test-plan/references/test-plan-template.md:4` | `platform: <pipefy \| wrike \| other>` → `platform: <pipefy \| wrike \| ziflow \| other>` | D-78 enum rollout |
| `dydx-delivery/skills/execute-tests/references/results-template.md:4` | `platform: <pipefy \| wrike \| other>` → `platform: <pipefy \| wrike \| ziflow \| other>` | D-78 enum rollout |
| `dydx-delivery/README.md:62` | `│   └── <platform>/                       # pipefy \| wrike` → `│   └── <platform>/                       # pipefy \| wrike \| ziflow` | D-78 enum rollout (prose form in plugin README) |
| `dydx-delivery/references/glossary.md` (existing routing-key + `platform` entries) | (a) UPDATE the `**platform**` entry on line 71 — already carries 4-enum; verify text + add per-platform one-line definitions per D-78 instruction; (b) ADD/UPDATE routing-key entry to enumerate `pipefy \| wrike \| ziflow \| other` with one-line definitions per platform | D-78 — glossary is the canonical reference cited by all stage skills |
| `dydx-delivery/references/glossary.md:66` (`**kickoff_branch**` entry) | `kickoff-direct` / `discovery-via` → `discovery-ready` / `draft-sow` | **Phase 7 R-02 carry-forward fix** — the spelling drift CONTEXT.md did not address. Bundling here aligns the only remaining old-spelling reference with the rest of the codebase. **HIGHLY RECOMMEND.** |
| `.planning/REQUIREMENTS.md` § Traceability table (lines 130-140) | Flip all 11 v2.2 STG4 + ROUTE rows from `Pending` → `Satisfied` | v2.1 retrospective pattern; same as 07-04 |
| `dydx-delivery/skills/generate-functional-spec/` (entire directory) | DELETE | STG4-03 — directory + SKILL.md (113 lines) + references/functional-spec-template.md (165 lines) = 2 files total |
| `dydx-delivery/README.md` (any `generate-functional-spec` references) | UPDATE to `generate-fnspec-platform` + `generate-fnspec-integration` per STG4-03 | Pipeline diagram + skill table — planner greps `generate-functional-spec` across `dydx-delivery/` at plan time |
| `.planning/DESIGN.md` DESIGN-20 section | ADD sub-decision note per D-78 closeout — "TD-2 RESOLVED: `ziflow` added to stage-skill `platform:` enum per D-78; `platform-ziflow/SKILL.md:14` routing-key claim retained" | D-78 explicit mention in CONTEXT.md |

**Complete D-78 enum touch-list (mechanical enumeration):**

| # | File | Line | Current | Edit / Anchor |
|---|------|------|---------|---------------|
| 1 | `dydx-delivery/skills/discovery-intake/SKILL.md` | 114 | `<pipefy \| wrike \| other>` | EDIT → add `ziflow` |
| 2 | `dydx-delivery/skills/discovery-intake/references/intake-template.md` | 3 | `<pipefy \| wrike \| other>` | EDIT |
| 3 | `dydx-delivery/skills/discovery-intake/references/intake-template.md` | 45 | `<pipefy \| wrike \| other>` (prose) | EDIT |
| 4 | `dydx-delivery/skills/generate-build-prompt/SKILL.md` | 114 | `<pipefy \| wrike \| other>` | EDIT |
| 5 | `dydx-delivery/skills/generate-build-prompt/references/build-prompt-template.md` | 3 | `<pipefy \| wrike \| other>` | EDIT |
| 6 | `dydx-delivery/skills/generate-technical-spec/SKILL.md` | 101 | `<pipefy \| wrike \| other>` | EDIT |
| 7 | `dydx-delivery/skills/generate-technical-spec/references/technical-spec-template.md` | 3 | `<pipefy \| wrike \| other>` | EDIT |
| 8 | `dydx-delivery/skills/generate-test-plan/SKILL.md` | 96 | `<pipefy \| wrike \| other>` | EDIT |
| 9 | `dydx-delivery/skills/generate-test-plan/references/test-plan-template.md` | 4 | `<pipefy \| wrike \| other>` | EDIT |
| 10 | `dydx-delivery/skills/execute-tests/references/results-template.md` | 4 | `<pipefy \| wrike \| other>` | EDIT |
| 11 | `dydx-delivery/README.md` | 62 | `<platform>/   # pipefy \| wrike` (prose) | EDIT |
| 12 | `dydx-delivery/skills/generate-functional-spec/SKILL.md` | 77 | `<pipefy \| wrike \| other>` | DELETED via STG4-03 retirement (no edit needed) |
| 13 | `dydx-delivery/skills/generate-functional-spec/references/functional-spec-template.md` | 3 | `<pipefy \| wrike \| other>` | DELETED via STG4-03 retirement |
| A1 | `dydx-delivery/skills/generate-sow/SKILL.md` | 86 | `<pipefy \| wrike \| ziflow \| other>` | ANCHOR — already 4-enum (Phase 7 STG3-02 work) |
| A2 | `dydx-delivery/skills/generate-sow/references/sow-template.md` | 3 | `<pipefy \| wrike \| ziflow \| other>` | ANCHOR — already 4-enum |
| A3 | `dydx-delivery/references/frontmatter-scheme.md` | 41 | `<pipefy \| wrike \| ziflow \| other>` | ANCHOR — canonical reference; already 4-enum |
| A4 | `dydx-delivery/references/glossary.md` | 71 (`**platform**` entry) | `(pipefy \| wrike \| ziflow \| other)` | ANCHOR — glossary `**platform**` entry already 4-enum; ROUTE-04 expands one-line definitions only |
| A5 | `dydx-delivery/skills/platform-ziflow/SKILL.md` | 5 + 14 | `platform: ziflow` (frontmatter); routing-key claim in body | ANCHOR — RETAIN per D-78 path (a); verify (no edit needed) |
| N1 | `dydx-delivery/skills/generate-fnspec-platform/SKILL.md` | (new file) | `<pipefy \| wrike \| ziflow \| other>` | NEW — emitted by plan 08-01 with the 4-enum |
| N2 | `dydx-delivery/skills/generate-fnspec-platform/references/fnspec-platform-template.md` | (new file) | `<pipefy \| wrike \| ziflow \| other>` | NEW — emitted by 08-01 |
| N3 | `dydx-delivery/skills/generate-fnspec-integration/SKILL.md` | (new file) | `<pipefy \| wrike \| ziflow \| other>` | NEW — emitted by 08-02 |
| N4 | `dydx-delivery/skills/generate-fnspec-integration/references/fnspec-integration-template.md` | (new file) | `<pipefy \| wrike \| ziflow \| other>` | NEW — emitted by 08-02 |

**Edit count:** 11 files. **Anchor count:** 5 files (already correct). **Delete count:** 2 files (via STG4-03 directory removal). **New count:** 4 files (emitted by 08-01 + 08-02 with the 4-enum baked in).

Confidence: **HIGH** [VERIFIED: `grep -rn "pipefy | wrike"` and `grep -rn "^platform:"` produced the complete enumeration line-by-line].

**`phase8-structure-check.sh --section <name>` partition enumeration:**

| Section | Assertions | Lift template |
|---------|------------|---------------|
| `--section 4a` | P1 — `generate-fnspec-platform/SKILL.md` exists. P2 — 3 `references/` files exist (`fnspec-platform-template.md` / `auto-classify-rubric.md` / `addendum-template.md`). P3 — 4 canonical pointers resolve (safety-rules / stage-numbering / frontmatter-scheme / glossary). P4 — `platform:` enum carries all 4 values (`pipefy \| wrike \| ziflow \| other`). P5 — `delivery: native-ai \| api` canonical order documented in SKILL.md body. P6 — `auto-classify-rubric.md` referenced from SKILL.md. P7 — `addendum-template.md` referenced from SKILL.md. P8 — `has_platform_api_addendum` + `tech_spec_scope` frontmatter fields documented in SKILL.md / template. | Lift from Phase 7 `run_kickoff_section()` (lines 65-126 of phase7-structure-check.sh); 8 asserts vs Phase 7's 7 — adapt directly. |
| `--section 4b` | I1 — `generate-fnspec-integration/SKILL.md` exists. I2 — 3 `references/` files exist (`fnspec-integration-template.md` / `consistency-rules.md` / `either-spec-skip-paths.md`). I3 — 4 canonical pointers resolve. I4 — `based_on_fnspec_platform:` field documented. I5 — verbatim skip-emit string `Stage 4b SKIPPED — no integration work in scope` present in SKILL.md or `either-spec-skip-paths.md`. I6 — 3 consistency checks named in `consistency-rules.md`. I7 — halt-on-failure + `04b_consistency_check_v<N>.md` failure-artefact contract documented. I8 — Two-place key-decisions cross-reference (both 4a + 4b SKILL.md key-decisions sections name D-78/D-79/D-82/D-84/D-85) per T-02-06-02 (ROUTE-01). | Lift from Phase 7 `run_discovery_section()` + `run_kickoff_section()` blend. |
| `--section route` | E1 — `ziflow` present in `platform:` enum in all 11 modified files (per the §2.3 table). E2 — `platform-ziflow/SKILL.md:14` retains routing-key claim. E3 — `glossary.md` routing-key entry enumerates `pipefy \| wrike \| ziflow \| other`. E4 — `glossary.md` `**kickoff_branch**` entry uses `discovery-ready \| draft-sow` (Phase 7 R-02 carry-forward). E5 — `generate-functional-spec/` directory does NOT exist (STG4-03). E6 — Three topologies (4a-only / 4b-only / both) documented in BOTH 4a + 4b SKILL.md bodies (STG4-06). | Cross-cutting; uses `[ ! -d ... ]` for E5; `grep -qF` for the enum + topology asserts. |
| `--section smoke` | S1 — `fixtures/output/sample-cr-04a_fnspec-platform_v1.md` exists and parses as YAML frontmatter. S2 — `fixtures/output/sample-cr-04b_fnspec-integration_v1.md` exists and parses. S3 — Synthetic Stage 5 stub reads `delivery:` field from every row and re-emits at same column position; assert no rows stripped, no enum reorder. S4 — Synthetic Stage 6 stub re-emits row count matches 4a + 4b combined. S5 — Synthetic Stage 7b stub iterates rows and asserts canonical enum order `native-ai \| api` everywhere (no reversed `api \| native-ai`). S6 — Synthetic Stage 10 stub reads frontmatter `based_on_*` chain end-to-end, asserts no chain break. | Pure stubs — see §2.4 below for shell function shape. |
| `--all` (cross-section) | X1 — Same `platform:` enum spelling across every skill that declares it (all 4-enum after D-78 rollout — including the 4 NEW skill files). X2 — `delivery:` markup token grep-greppable from BOTH 4a + 4b template files (cross-skill consistency). X3 — `based_on_fnspec_platform:` cited in 4b SKILL.md AND `based_on_*` chain documented in canonical `frontmatter-scheme.md`. X4 — `phase8-structure-check.sh` itself passes `bash -n` (syntax check) — meta-assert. | Lift from Phase 7 `run_cross_section()` (lines 174-191). |

**Synthetic Stage 5 / 6 / 7b / 10 consumer-stub shape (D-86):**

Concept: each stub is a shell function that reads a fixture file's YAML frontmatter + iterates body rows, re-emitting the `delivery:` field. Asserts no field loss / position drift / enum reorder. Pure stub — no real downstream skill files referenced.

```bash
# Conceptual shape (planner formalises during plan write):

read_frontmatter() {
  # Read between '---' fences
  sed -n '/^---$/,/^---$/p' "$1" | sed '1d;$d'
}

iterate_delivery_rows() {
  # Grep rows carrying 'delivery: native-ai | api [...]' markup; return each row's delivery token
  grep -oE 'delivery: (native-ai|api) \[[^]]+\]' "$1"
}

synth_stage5_stub() {
  local fixture="$1"
  local row_count
  row_count=$(iterate_delivery_rows "$fixture" | wc -l)
  [ "$row_count" -gt 0 ] || fail "S3: synth_stage5_stub found 0 delivery rows in $fixture"
  # Assert canonical order on every row
  if iterate_delivery_rows "$fixture" | grep -qE 'delivery: api \| native-ai'; then
    fail "S3: reversed enum 'api | native-ai' found — STG4-04 canonical order violation"
  fi
  pass "S3: synth_stage5_stub re-emitted $row_count delivery rows in canonical order from $fixture"
}

# synth_stage6_stub, synth_stage7b_stub, synth_stage10_stub follow same pattern with
# minor variations:
#   - Stage 6 asserts row count matches across 4a + 4b combined
#   - Stage 7b iterates rows and asserts every row's enum order is native-ai | api (never reversed)
#   - Stage 10 reads frontmatter `based_on_*` chain (based_on_discovery / based_on_sow /
#     based_on_fnspec_platform) and asserts the chain is unbroken (each named file exists in
#     fixtures/output/ or is a known external reference)
```

The planner authors the full bodies. Above is the **shape contract** — each stub MUST: (a) read frontmatter via `sed`; (b) iterate rows via `grep -oE` against the D-82 token pattern; (c) assert no zero-row case + no reversed-enum case + no missing `based_on_*` link. The smoke section's purpose per D-86: prove the `delivery:` field survives at canonical position through a synthetic forward read chain.

Confidence: **HIGH** [VERIFIED: D-86 contract in CONTEXT.md; Phase 7 phase7-structure-check.sh patterns lift directly; sed/grep/awk are available baseline per Phase 7 environment audit].

## 3. Frontmatter contract summaries (consolidated for planner reference)

### 3.1 `04a_fnspec-platform_v<N>.md` (08-01 output)

Full contract per §2.1; key fields:

- `platform: <pipefy | wrike | ziflow | other>` — D-78 expanded enum
- `based_on_discovery:` — MANDATORY when discovery exists (normal path)
- `based_on_sow:` — MANDATORY
- `based_on_kickoff:` — CONDITIONAL (draft-sow path only)
- `status: draft → client_review → approved → archived` — canonical 4-state per DESIGN-01 + STG3-01 lock
- `has_platform_api_addendum:` (true/false) — D-79; present only when 4b out-of-scope AND 4a has `delivery: api` rows
- `tech_spec_scope: platform-api-addendum-only` — D-79; present only when `has_platform_api_addendum: true`
- `approved_by` + `approved_at` — MANDATORY on `status: approved` (DESIGN-06)

### 3.2 `04b_fnspec-integration_v<N>.md` (08-02 output)

Full contract per §2.2; key fields:

- `platform:` — carried from 4a / SOW
- `based_on_discovery:` + `based_on_sow:` — MANDATORY
- `based_on_fnspec_platform:` — CONDITIONAL (present when 4a exists — the `both` topology; absent on 4b-only topology)
- `status:` — canonical 4-state
- `approved_by` + `approved_at` — MANDATORY on approved

### 3.3 `04b_consistency_check_v<N>.md` (08-02 halt-path output, ROUTE-02)

Full contract per §2.2 halt-path; key fields:

- `artefact_type: consistency_check_failure`
- `based_on_fnspec_platform:` + `based_on_attempted_fnspec_integration:`
- `checks_run: 3` + `checks_failed: <N>`
- `status: halt`
- Body: failure-rows table per `consistency-rules.md` template

### 3.4 08-03 deliverables (no new artefact frontmatter)

- 11 REQUIREMENTS.md trace-table flips: `Pending` → `Satisfied` on STG4-01..06 + ROUTE-01..05
- `phase8-structure-check.sh` assertion blocks per §2.3 partition table
- `generate-functional-spec/` directory removed (STG4-03)
- 11 enum-rollout edits (§2.3 touch-list)
- Glossary updates (routing-key entry + carry-forward `kickoff_branch` fix)
- DESIGN-20 sub-decision note for D-78 closeout

## 4. Validation Architecture (Nyquist coverage)

### 4.1 Phase Requirements → Verification Map

| Req ID | Plan | Assertion ID | Fixture | Section |
|--------|------|--------------|---------|---------|
| STG4-01 | 08-01 | P1 (skill exists), P2 (3 references/ files), P3 (4 canonical pointers) | `fixtures/output/sample-cr-04a_fnspec-platform_v1.md` | `--section 4a` |
| STG4-02 | 08-02 | I1 (skill exists), I2 (3 references/ files), I3 (4 canonical pointers) | `fixtures/output/sample-cr-04b_fnspec-integration_v1.md` | `--section 4b` |
| STG4-03 | 08-03 | E5 (`generate-functional-spec/` directory does NOT exist) | n/a (delete-only) | `--section route` |
| STG4-04 | 08-01 + 08-02 | P5 (`delivery: native-ai \| api` canonical order in 4a SKILL.md), S3 + S5 (smoke stub asserts no reversed enum across both fixtures) | both 4a + 4b fixtures | `--section 4a` + `--section smoke` |
| STG4-05 | 08-01 | P6 (`auto-classify-rubric.md` referenced from SKILL.md); manual rubric content review | rubric file itself | `--section 4a` |
| STG4-06 | 08-03 | E6 (three topologies documented in BOTH 4a + 4b SKILL.md bodies) | `either-spec-skip-paths.md` content; both SKILL.md bodies | `--section route` |
| ROUTE-01 | 08-02 | I6 (3 consistency checks named), I8 (two-place key-decisions cross-reference) | `consistency-rules.md`; both SKILL.md key-decisions sections | `--section 4b` |
| ROUTE-02 | 08-02 | I7 (halt + `04b_consistency_check_v<N>.md` contract documented) | `sample-cr-04b_consistency_check_v1.md` fixture | `--section 4b` |
| ROUTE-03 | 08-01 + 08-02 | P8 (`has_platform_api_addendum` + `tech_spec_scope` documented in 4a); I4 (`based_on_fnspec_platform:` documented in 4b) | 4a fixture (with addendum H2 body in one topology variant); 4b fixture | `--section 4a` + `--section 4b` |
| ROUTE-04 | 08-03 | E1 (4-enum `ziflow` present in all 11 modified files), E2 (`platform-ziflow/SKILL.md:14` retains routing-key claim), E3 (glossary routing-key entry 4-enum), E4 (glossary `kickoff_branch` entry uses `discovery-ready \| draft-sow` — Phase 7 carry-forward) | n/a (code-only) | `--section route` |
| ROUTE-05 | 08-03 | S1-S6 (smoke section — synthetic Stage 5/6/7b/10 stubs read both fixtures end-to-end) | both 4a + 4b fixtures | `--section smoke` |

Cross-section asserts (X1-X4 per §2.3 table) run only under `--all` / no-flag invocation and act as the **phase gate** before `/gsd-verify-work`.

### 4.2 Manual e2e smoke walkthrough (07-04 pattern)

Following Phase 7's 07-04-SUMMARY.md pattern, plan 08-03 (or split-off 08-04) authors a manual reviewer smoke walkthrough:

1. **Setup** — Author the three sample-CR fixture inputs under `fixtures/input/` (or reuse Phase 7's `.planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/fixtures/` sample-CR inputs as the upstream `02_discovery_v1.md` + `03_sow_v1.md`).
2. **Run 4a** — Invoke `generate-fnspec-platform` against the sample-CR upstream. Observe `04a_fnspec-platform_v1.md` written under `fixtures/output/`. Verify per-row `delivery:` markup present on every business-rule / field-req / AC row.
3. **Run 4b — clean path** — Invoke `generate-fnspec-integration` with consistent inputs. Observe consistency check passes; `04b_fnspec-integration_v1.md` written under `fixtures/output/`.
4. **Run 4b — halt path** — Inject a synthetic conflict (e.g., a 4a row with `delivery: native-ai` and a corresponding 4b row tagged `delivery: api` for the same requirement ID). Invoke 4b. Observe `04b_consistency_check_v1.md` written + halt; no `04b_fnspec-integration_v*.md` produced.
5. **Run 4b — skip path** — Invoke 4b against an "integration out of scope" SOW signal (`## Integration Scope` section says "n/a" or absent). Observe verbatim stdout `Stage 4b SKIPPED — no integration work in scope`; no artefact written.
6. **Run smoke gate** — `bash .planning/phases/08-stage-4-fnspec-split-route/scripts/phase8-structure-check.sh --section smoke`. Expect all S1-S6 PASS.
7. **Run full gate** — `bash .planning/phases/.../phase8-structure-check.sh`. Expect ALL ASSERTIONS PASSED.
8. **Commit fixtures** — `fixtures/output/sample-cr-04a_fnspec-platform_v1.md` + `sample-cr-04b_fnspec-integration_v1.md` + `sample-cr-04b_consistency_check_v1.md`. Capture summary in plan-close SUMMARY.md per 07-04 pattern.

### 4.3 Sampling Rate

- **Per task commit:** `bash scripts/phase8-structure-check.sh --section <relevant>` (≤1s; dependency-free)
- **Per wave merge:** Same as per-commit
- **Phase gate:** `bash scripts/phase8-structure-check.sh` (full suite — all 4 sections + cross-section) before `/gsd-verify-work`

### 4.4 Wave 0 gaps

- [ ] `.planning/phases/08-stage-4-fnspec-split-route/scripts/phase8-structure-check.sh` — adapt from phase7 skeleton per §2.3 partition table; ships inside 08-03
- [ ] `.planning/phases/08-stage-4-fnspec-split-route/fixtures/input/` (optional reuse of Phase 7 fixtures via path reference; otherwise author fresh) + `fixtures/output/` (capture during 08-01 / 08-02 / 08-03 plan close)
- [ ] No framework install — bash + grep + sed + awk are baseline; same as Phase 7

### 4.5 Dimension 8 sensor model (Nyquist)

Phase 8 structure-check covers Dimension 8 (structural verification) via ~30 asserts across:
- 6 file-existence sensors (4a SKILL.md + 4a 3 references + 4b SKILL.md + 4b 3 references + script itself + retirement target absence)
- 8 canonical-pointer sensors (4 per new skill × 2 skills)
- 11 enum-rollout sensors (one per edit-list file, asserting `ziflow` present)
- 3 cross-skill consistency sensors (X1-X3 + meta-assert X4)
- 6 forward-compat smoke sensors (S1-S6 — synthetic consumer stubs)
- Plus literal-string sensors for: D-82 row markup canonical order; D-85 verbatim skip-emit string; D-79 `has_platform_api_addendum` field; D-84 consistency-check halt-on-failure contract

E2e smoke (Dimension 9) is **manual-only** for Phase 8 — same posture as Phase 7. The 07-04-SUMMARY pattern carries directly.

## 5. Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|------------|-----------|---------|----------|
| bash | phase8-structure-check.sh + smoke stubs | ✓ | 5.x Git Bash on Windows; native on \*nix | — |
| grep (GNU) | section assertions + smoke stubs | ✓ | 3.x | — |
| sed | smoke stubs (frontmatter read between `---` fences) | ✓ | baseline | — |
| awk | smoke stubs (optional — `grep -oE` alternative for row iteration) | ✓ | baseline | not strictly required (grep-only path also works) |
| git | commit verification | ✓ | 2.x | — |
| Claude CLI / skill runner | manual e2e smoke for 4a + 4b invocations | ✓ | — | n/a (manual reviewer task) |
| Coda MCP / Coda API | NOT REQUIRED (no Coda touchpoint in Phase 8) | n/a | — | — |
| pytest | NOT REQUIRED (D-86 uses bash; pytest deferred) | n/a | — | — |

**Missing dependencies with no fallback:** none.
**Missing dependencies with fallback:** none.

Phase 8 is fully self-contained — same posture as Phases 5/6/7. No external service calls; all paths are local file read/write + bash assertion.

Confidence: **HIGH** [VERIFIED: Phase 7 environment audit confirmed baseline; no Phase 8 deltas].

## 6. Open Questions / Risks

### R-01 (MEDIUM) — Glossary `kickoff_branch` enum spelling still drifted (Phase 7 R-02 carry-forward)

`dydx-delivery/references/glossary.md:66` STILL carries the old enum spelling `kickoff-direct | discovery-via` despite Phase 7's research flagging this as R-02 with a recommendation to fix in 07-03 synthesis. Verified directly: `grep -n "kickoff_branch" dydx-delivery/references/glossary.md` → line 66 `kickoff-direct (skip Stage 2; feed Stage 3 directly) or discovery-via (feed Stage 2 first)`.

**Phase 7's structure-check K4 asserted the authoritative spelling against the kickoff-template.md only — not against the glossary.** The drift survived. Phase 8 ROUTE-04 already touches glossary.md (routing-key entry update for `pipefy | wrike | ziflow | other`); bundling the `kickoff_branch` spelling fix into the same plan-08-03 task block is mechanical (~1 LOC edit) and surfaces the long-flagged inconsistency.

**Planner action:** include glossary line 66 fix in 08-03 alongside ROUTE-04 work. Add `phase8-structure-check.sh` assertion E4 asserting glossary `**kickoff_branch**` entry uses `discovery-ready | draft-sow` (carry-forward protection — prevents another cross-phase miss).

Confidence: **HIGH** [VERIFIED: glossary.md:66 read directly]. Recommend planner adopt this fix.

### R-02 (LOW) — Phase 8 fixture-input reuse from Phase 7

Phase 7 already authored sample-CR inputs at `.planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/fixtures/sample-cr-{meeting-notes,miro-paste,field-notes}.md` + an `output/` folder with `01_kickoff_v*.md` / `02_discovery_v*.md` / `03_sow_v*.md` outputs (per phase 7 close). Phase 8 needs approved `02_discovery_v*.md` + approved `03_sow_v*.md` as upstream input for 4a + 4b smoke.

**Two options:**
- (a) Reuse Phase 7's `fixtures/output/` artefacts as Phase 8's `fixtures/input/`, with a single README pointer cross-referencing the upstream phase's outputs.
- (b) Author fresh Phase 8 sample-CR inputs (more isolated; more LOC).

**Planner action:** Recommend (a) — reuse Phase 7 outputs as Phase 8 inputs. Cleaner chain demonstration; lower LOC; matches the real pipeline data flow per CONTEXT.md `<code_context>` integration-points section. If Phase 7's outputs don't include sample CRs with explicit `## Platform Scope` + `## Integration Scope` content needed to exercise STG4-06 three topologies, author MINIMAL additional fixtures for the missing topology paths only.

Confidence: **MEDIUM** [VERIFIED: Phase 7 fixtures directory listed; exact contents of `output/` not inspected in this research — planner verifies content sufficiency at plan time].

### R-03 (LOW) — Phase 8 plan size split threshold

CONTEXT.md `<decisions>` D-80 explicitly says "Whether plan 08-03 splits to 08-04 (Phase 7 D-69 ~400 LOC heuristic) — planner enforces threshold at plan time." Phase 7 ended up splitting 07-03 → 07-04 (per CHANGELIST + recent commits). Phase 8's 08-03 is **more cross-cutting** than 07-03 was: 11 enum-rollout edits + REQUIREMENTS flips + structure-check authoring (~250-320 LOC bash) + retirement + glossary + DESIGN-20 sub-decision. **Estimate: ~350-500 LOC for 08-03.**

**Planner action:** plan with split-readiness in mind. If 08-03 plan content nears 400 LOC, split: 08-03 = enum rollout + retirement; 08-04 = structure-check authoring + smoke + REQUIREMENTS flips + manual e2e smoke summary (per 07-04 pattern).

Confidence: **MEDIUM** [ASSUMED: LOC estimate — actual plan content depends on planner's task-list verbosity].

### R-04 (LOW) — `dydx-delivery/README.md` may carry additional `generate-functional-spec` references

STG4-03 says "Any references to `generate-functional-spec` in v0.3.0 templates / READMEs / changelogs updated to point at 4a + 4b." A grep of `dydx-delivery/` for `generate-functional-spec` may surface additional references (e.g., in pipeline diagrams, skill tables, the README plugin-overview section). The bash-only Read tool I have access to was unable to perform a full grep across the entire README without running additional searches.

**Planner action:** at plan time, `grep -rn "generate-functional-spec" dydx-delivery/ --exclude-dir=generate-functional-spec` and enumerate every result for 08-03's retirement task. Most likely files: `dydx-delivery/README.md` pipeline diagram + skill table + `dydx-delivery/skills/generate-technical-spec/SKILL.md` (since techspec reads functional-spec output per v0.3.0 pipeline — verify if the v0.3.0 read path is still mentioned anywhere).

Confidence: **MEDIUM** [ASSUMED: cross-references — planner enumerates at plan time].

### R-05 (LOW) — DESIGN.md DESIGN-20 sub-decision note edit

D-78 + CONTEXT.md both say the resolution is "captured as a sub-decision under DESIGN-20 on update." This is a `.planning/DESIGN.md` edit — a planning-tier document touch, not a plugin-tier edit. Planner should verify whether DESIGN.md edits are in-scope for 08-03 or whether the sub-decision note belongs only in `dydx-delivery/references/glossary.md`.

**Planner action:** Include both edits in 08-03 (DESIGN.md DESIGN-20 sub-decision note + glossary routing-key entry update). Both are mechanical adds.

Confidence: **MEDIUM** [ASSUMED: DESIGN.md is in scope — CONTEXT.md mentions it explicitly under D-78].

## 7. Wave plan

**Confirmed: 3 sequential plans, no parallelism opportunity** (per D-80).

| Plan | Sequence | Dependency | Parallel-eligible? |
|------|----------|------------|---------------------|
| 08-01 | First | None | — |
| 08-02 | Second | 08-01 (4b reads approved 4a output) | — |
| 08-03 | Third | 08-01 + 08-02 (lifts REQUIREMENTS flips, retirement, smoke from both upstream plans) | — |

**Parallelization opportunity considered + REJECTED:** Could ROUTE-04 enum-rollout (08-03's mechanical 11-file edit) split into a separate Wave-1 plan running parallel to 08-01? **No** — the new 08-01 and 08-02 skill files (4 new files, per the §2.3 touch-list rows N1-N4) MUST be authored with the 4-enum baked in from the start. Splitting enum rollout to a parallel plan would create a partial-state window where some files have 4-enum and others have 3-enum, and any new file authored in 08-01 during that window would need a follow-up edit. Bundling enum rollout into 08-03 (which runs AFTER 08-01 + 08-02) ensures the enum migration is applied uniformly + at-once across the codebase. Same logic CONTEXT.md `<decisions>` D-80 rationale cites.

If 08-03 grows past ~400 LOC (R-03 risk), split to 08-03 + 08-04 per Phase 7 precedent — but the split is still sequential (08-04 depends on 08-01 + 08-02 + 08-03 outputs).

## 8. Cross-references audit — every CONTEXT.md decision reflected

| Decision | Reflected in this RESEARCH.md | Section |
|----------|-------------------------------|---------|
| D-78 — TD-2 / `ziflow` enum rollout | YES — §2.3 enum touch-list table + ROUTE-04 assertions E1-E4 + R-01 carry-forward fix | §2.3 + §4.1 + §6 R-01 |
| D-79 — 4a authors `## Platform-API Addendum` body inline | YES — §2.1 step 5 + §3.1 frontmatter + 08-01 file list + addendum-template.md shape | §2.1 + §3.1 |
| D-80 — 3 sequential atomic plans | YES — §2 per-plan structure + §7 wave plan | §2 + §7 |
| D-81 — Classifier rubric per-skill at `auto-classify-rubric.md` | YES — §2.1 references/ file list + step 3 + §3.1 frontmatter classifier flow | §2.1 |
| D-82 — Per-row markup `delivery: native-ai [HIGH, src: ...]` | YES — §2.1 per-row markup contract + §4.1 assertion R1 / S3 / S5 | §2.1 + §4.1 |
| D-83 — `references/` shape: 3 files per skill | YES — §2.1 + §2.2 references/ folder shape tables | §2.1 + §2.2 |
| D-84 — Consistency check form: SKILL.md prose + `consistency-rules.md` | YES — §2.2 step 3 + consistency-rules.md content + §4.1 assertions I6-I8 | §2.2 + §4.1 |
| D-85 — Skip mechanics: stdout-only, no marker file | YES — §2.2 step 2 + either-spec-skip-paths.md + §4.1 assertion I5 verbatim string | §2.2 + §4.1 |
| D-86 — Forward-compat smoke via `--section smoke` + fixture stubs | YES — §2.3 smoke section + synthetic consumer-stub shape + §4.1 assertions S1-S6 | §2.3 + §4.1 |

**No drift.** Every CONTEXT.md decision lands in research output.

Phase 7 carry-forward decisions referenced and inherited:
- D-69 → D-80 (3 per-skill atomic plans)
- D-71 → D-83 (3-file references/ shape)
- D-73 → D-81 (rubric extracted to references/)
- D-74 → D-85 (skip-emit stdout-only)
- D-75 → D-85 input signal (SOW `## Platform Scope` / `## Integration Scope` H2s)
- D-76 → ROUTE-04 lenient rollout (enforce on NEW + actively-edited writes only)
- D-77 → D-86 (single phase-N-structure-check.sh with `--section` partitioning)

## Project Constraints (from CLAUDE.md)

No `./CLAUDE.md` exists at repo root (verified via Phase 7 research — same posture for Phase 8). Project-level locks live in `.planning/PROJECT.md` § "Out of Scope" — captured in `<user_constraints>` Deferred Ideas above. The MEMORY.md auto-memory carries 3 user-locked facts (platform skills API-only / private email approved / Coda brain docs for VodafoneZiggo + Up & Up Group) — none of which Phase 8 work touches directly (Phase 8 is plugin-skill authoring, not platform integration or Coda mirror).

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | LOC estimate for 08-03 ~350-500 → may need split to 08-04 | §6 R-03 | Planner over-counts and splits unnecessarily, or under-counts and ships an oversized plan. **Resolution: planner re-measures at write time; ~400 threshold is mechanical.** |
| A2 | Phase 7 fixture outputs are sufficient as Phase 8 inputs | §6 R-02 | If Phase 7 outputs lack `## Platform Scope` + `## Integration Scope` content needed for STG4-06 three-topology exercise, additional fixture authorship needed. **Resolution: planner inspects Phase 7 `fixtures/output/` content at plan time.** |
| A3 | `dydx-delivery/README.md` carries additional `generate-functional-spec` references beyond the obvious line-62 enum prose | §6 R-04 | If unaccounted references survive STG4-03 retirement, plugin documentation becomes inconsistent. **Resolution: planner runs `grep -rn` at plan time.** |
| A4 | DESIGN.md DESIGN-20 sub-decision note is in scope for 08-03 | §6 R-05 | Otherwise scope-drift onto planning-tier documents. **Resolution: planner verifies scope — likely yes per D-78 explicit mention.** |
| A5 | D-85 verbatim skip-emit string `Stage 4b SKIPPED — no integration work in scope` is the locked working default | CONTEXT.md decisions + §2.2 | Planner may polish before execute lock; downstream structure-check I5 assertion uses whichever string is locked. **Resolution: planner picks final wording during 08-02 planning.** |
| A6 | Synthetic consumer-stub shape (sed + grep + awk against frontmatter + rows) is sufficient for D-86 forward-compat smoke | §2.3 + §4.1 | If stubs are too thin, the smoke gate is a token PASS without real signal. **Resolution: planner authors full stub bodies during 08-03 plan time.** |

## Sources

### Primary (HIGH confidence)
- `.planning/REQUIREMENTS.md` lines 47-66 (STG4-01..06 / ROUTE-01..05 verbatim) + lines 130-140 (traceability table)
- `.planning/ROADMAP.md` lines 77-87 (Phase 8 § with 6 success criteria verbatim)
- `.planning/phases/08-stage-4-fnspec-split-route/08-CONTEXT.md` (D-78..D-86 + Claude's Discretion + Deferred Ideas)
- `.planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/07-RESEARCH.md` (structural template + D-69/D-71/D-73/D-74/D-77 precedents)
- `.planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/07-CONTEXT.md` (Phase 7 D-69..D-77 precedents Phase 8 inherits)
- `.planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/scripts/phase7-structure-check.sh` (207-line bash skeleton — direct lift template for D-86)
- `.planning/DESIGN.md` DESIGN-20 (Stage 4 split contract) + DESIGN-21 (Stage 5 scope-gate) + DESIGN-14/15/16 (per-platform native-ai-inventory) + DESIGN-02 + DESIGN-08 + DESIGN-01 + DESIGN-06
- `dydx-delivery/skills/generate-functional-spec/SKILL.md` (113 lines, full — the RETIRING skill, lift-and-adapt base)
- `dydx-delivery/skills/generate-functional-spec/references/functional-spec-template.md` (165 lines, full — direct template lift)
- `dydx-delivery/skills/kickoff-capture/SKILL.md` (Phase 7 product — canonical-pointer block + Step shape lift target)
- `dydx-delivery/skills/kickoff-capture/references/auto-classify-rubric.md` (44 lines, full — rubric structure direct template)
- `dydx-delivery/skills/discovery-intake/SKILL.md` (Phase 7 product — skip-emit body lift target)
- `dydx-delivery/skills/generate-sow/SKILL.md` + `references/sow-template.md` (Phase 7 product — confirms `pipefy | wrike | ziflow | other` already 4-enum in SOW)
- `dydx-delivery/skills/platform-ziflow/SKILL.md` line 14 (D-78 path (a) alignment target — retained)
- `dydx-delivery/references/glossary.md` (line 66 — flagged R-01 carry-forward; line 71 — `**platform**` entry already 4-enum)
- `dydx-delivery/references/frontmatter-scheme.md` line 41 (canonical 4-enum anchor)
- `dydx-delivery/skills/platform-pipefy/references/native-ai-inventory.md` (+ wrike + ziflow) (DESIGN-14/15/16 Phase 6 outputs; classifier input for STG4-05)
- `.planning/codebase/STRUCTURE.md` + `CONVENTIONS.md` + `TESTING.md` (codebase intel — no traditional tests; structure-check + prose-form skill-internal checks are the gate forms)
- `.planning/OPEN-QUESTIONS.md` (grep verified: zero `STG4` / `ROUTE` rows)
- `.planning/STATE.md` (v2.2 milestone state; Phase 7 complete; Phase 8 ready)
- `.planning/milestones/v2.1-RETROSPECTIVE.md` (auto-flip REQUIREMENTS pattern; per-phase structure-check with `--section`)

### Secondary (MEDIUM confidence)
- `dydx-delivery/skills/{discovery-intake,generate-build-prompt,generate-technical-spec,generate-test-plan,execute-tests}` (D-78 enum touch-list grep results — verified line-by-line)
- `.planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/fixtures/` directory listing (3 sample-CR inputs + `output/` subdir — content sufficiency for Phase 8 reuse is R-02)

### Tertiary (LOW confidence)
- None — all findings traced to in-repo source files; no WebSearch / WebFetch needed for this phase. Same posture as Phase 7.

## Metadata

**Confidence breakdown:**
- Standard stack (skill authoring conventions): HIGH — same convention layer as Phase 7; lift-and-adapt posture is mechanical.
- Architecture (per-skill atomic plan + structure-check partition + smoke section): HIGH — D-80 / D-86 carry directly from Phase 6 D-63 + Phase 7 D-77.
- Pitfalls (glossary `kickoff_branch` carry-forward; DESIGN.md edit scope): MEDIUM-HIGH — R-01 + R-05 are concrete drifts surfaced from direct file inspection.
- Bash skeleton lift target (phase8-structure-check.sh): HIGH — phase7-structure-check.sh is 207 lines, on disk, well-commented; smoke section's stub functions are the main new content.
- D-78 enum touch-list: HIGH — `grep -rn` produced the complete 12-row enumeration; verified line-by-line.
- LOC estimates for 08-03: MEDIUM — predicted ~350-500 vs ~400 threshold; planner re-measures at write time.

**Research date:** 2026-05-11
**Valid until:** 2026-06-10 (30 days — Phase 8 source materials are all design-locked under v2.2 milestone; no fast-moving external dependency)

## RESEARCH COMPLETE
