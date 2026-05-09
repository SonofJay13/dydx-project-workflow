# Audit: dydx-delivery v0.3.0 — v2.0 Implementor Edition baseline

**Audit Date:** 2026-05-09
**Branch / commit:** dydx-delivery-v2 / (record current commit at AUDIT-08 wave)

## How to read this audit

(preamble placeholder — written in final synthesis Wave 9)

## Executive Summary

(executive summary table placeholder — populated in Wave 9)

---

## AUDIT-01: Per-Skill Inventory

Catalogues all 7 v0.3.0 skills shipped under `dydx-delivery/skills/`. Each skill has a matrix row below plus a focused prose subsection covering hand-off contract, observed brittleness, and what's missing for v2 — observation-led; design moves are deferred to DESIGN-* requirements in `.planning/REQUIREMENTS.md`. Every brittleness bullet carries a `file:line` citation and a severity tag (`[BLOCKING]` / `[STRUCTURAL]` / `[COSMETIC]`); every "What's missing for v2" subsection ends with a `**Closes via:** DESIGN-NN` trailer that names the requirement closing the gap without prescribing the fix.

| Skill | Purpose (1 line) | Inputs | Outputs | Downstream consumer | Deps | Status flag(s) |
|---|---|---|---|---|---|---|
| `discovery-intake` | Capture system, users, triggers, data, rules, integrations, exceptions, failure points | Free-form context; optional existing `00_discovery_v*.md` | `<Client>/build-specs/<platform>/00_discovery_v{N}.md` | `generate-sow` | — | `status: draft` (no follow-up status documented) |
| `generate-sow` | Draft a stage-2 scope of work from approved discovery | Latest `00_discovery_v*.md`; inline commercial framing | `<Client>/build-specs/<platform>/01_sow_v{N}.md` | `generate-functional-spec` | — | `draft → client_review → approved` (sole skill documenting `client_review`) |
| `generate-functional-spec` | Single fnspec per project, platform-tagged via `platform:` frontmatter | Latest `01_sow_v*.md` (required); discovery for context | `<Client>/build-specs/<platform>/02_functional-spec_v{N}.md` | `generate-technical-spec` | — | `draft → approved` (no `client_review`) |
| `generate-technical-spec` | Translate fnspec into platform constructs | Latest `02_functional-spec_v*.md`; reads `platform:` frontmatter to dispatch | `<Client>/build-specs/<platform>/03_technical-spec_v{N}.md` | `generate-test-plan` | platform-pipefy / platform-wrike (referenced; missing — see AUDIT-04) | `draft → approved` |
| `generate-test-plan` | Produce table-format test plan against sandbox tenant | Latest `03_technical-spec_v*.md`; functional spec for AC; user-supplied `<feature>` name | `<Client>/testing/<feature>/test-plan_v{N}.md` | `generate-build-prompt` | — | `draft → approved` |
| `generate-build-prompt` | Emit Claude-Code-ready build prompt for developers | Latest `03_technical-spec_v*.md` (must be `approved` for production); latest `test-plan_v*.md`; fnspec + SOW for context | `<Client>/build-specs/<platform>/04_build-prompt_v{N}.md` | `execute-tests` (after dev build) | platform-pipefy / platform-wrike (referenced; missing — see AUDIT-04) | `draft` (no follow-up status documented) |
| `execute-tests` | Run the approved test plan, enforce sandbox-only safety rules | Latest `test-plan_v*.md` (`approved`); sandbox credentials; matching platform skill | `<Client>/testing/<feature>/results-YYYY-MM-DD_v{N}.md` | (terminal — results summary) | platform-pipefy / platform-wrike (referenced; missing — see AUDIT-04) | (no `status:` field on results-template) |

---

### 1.1 discovery-intake

**Hand-off contract:**
- Carrier file path: `<Client>/build-specs/<platform>/00_discovery_v{N}.md`
- Frontmatter fields propagated: `client / platform / integrations / version / status: draft / captured_by / captured_at`
- Gating status flag: `status: draft` (no follow-up status documented)
- Hand-off message points at: `generate-sow`

**Observed brittleness:**
- `dydx-delivery/skills/discovery-intake/SKILL.md:27-28` references workspace `hub.md` twice ("match it against the workspace `hub.md` client index" and "see `hub.md`"); no `hub.md` exists in the repo. **[STRUCTURAL]**
- `dydx-delivery/skills/discovery-intake/SKILL.md:98-107` writes `status: draft` but the skill body documents no follow-up status word — no `client_review` or `approved` mentioned for the discovery artefact. **[STRUCTURAL]**
- `dydx-delivery/skills/discovery-intake/references/intake-template.md:13` self-labels "Stage 0" while file-prefix scheme is `00_` and the canonical v2 numbering elsewhere is "Stage 1 Kickoff" → "Stage 2 Discovery"; two-scheme conflict surfaces here. **[STRUCTURAL]**

**What's missing for v2:**
- No kickoff input branch today: discovery-intake takes free-form context only; no Miro/notes/feedback ingest path exists.
- No skip-this-stage behaviour when a kickoff produces a draft SOW directly (today the linear pipeline always starts at discovery).
- No `frontmatter_version` field to support a frontmatter scheme migration.
- **Closes via:** DESIGN-17 (Stage 1 Kickoff capture skill); DESIGN-18 (Stage 2 Discovery refactor); DESIGN-01 (frontmatter scheme).
- **Pitfall ref:** CRIT-6 (frontmatter migration corruption).

---

### 1.2 generate-sow

**Hand-off contract:**
- Carrier file path: `<Client>/build-specs/<platform>/01_sow_v{N}.md`
- Frontmatter fields propagated: `... status: draft, based_on_discovery: 00_discovery_v{N}.md`
- Gating status flag: `draft → client_review → approved` (the only skill whose hand-off message names both `client_review` and `approved`)
- Hand-off message points at: `generate-functional-spec`

**Observed brittleness:**
- `dydx-delivery/skills/generate-sow/SKILL.md:27-33` carries the start-at-any-point triage block — 1st of 6 near-identical copies across the platform-dispatch skills (see AUDIT-05). **[STRUCTURAL]**
- `dydx-delivery/skills/generate-sow/references/sow-template.md` carries no "Stage N" self-label — sole template without a stage label, while five sibling templates do self-label (see AUDIT-05). **[STRUCTURAL]**

**What's missing for v2:**
- Today's SOW implicitly assumes a single-platform shape; no structural slot for an SOW that spans platform AND integration work in a single artefact.
- Status lifecycle is documented in prose at `SKILL.md:93` rather than locked to the canonical scheme.
- **Closes via:** DESIGN-19 (Stage 3 SOW refactor); DESIGN-01 (frontmatter scheme — `client_review` MUST be retained as the canonical SOW lifecycle word).
- **Pitfall ref:** CRIT-6 (frontmatter migration — preserve `client_review`).

---

### 1.3 generate-functional-spec

**Hand-off contract:**
- Carrier file path: `<Client>/build-specs/<platform>/02_functional-spec_v{N}.md`
- Frontmatter fields propagated: `... status: draft, based_on_sow: 01_sow_v{N}.md`
- Gating status flag: `draft → approved` (no `client_review` — diverges from sibling `generate-sow`)
- Hand-off message points at: `generate-technical-spec`

**Observed brittleness:**
- `dydx-delivery/skills/generate-functional-spec/SKILL.md:28-32` carries the start-at-any-point triage block — 2nd of 6 near-identical copies (see AUDIT-05). **[STRUCTURAL]**
- `dydx-delivery/skills/generate-functional-spec/references/functional-spec-template.md:13` self-labels "Stage 2"; the alignment with file-prefix `02_` is coincidental given that sibling templates label "Stage 5" / "Stage 6" without matching prefixes. **[STRUCTURAL]**
- `dydx-delivery/skills/generate-functional-spec/SKILL.md:74-83` jumps the status lifecycle directly `draft → approved`, skipping `client_review` — divergent from the `generate-sow` sibling that documents `client_review`. **[STRUCTURAL]**

**What's missing for v2:**
- Today there is one fnspec per project; no structural split between platform-fnspec and integration-fnspec, and no per-requirement `delivery: native-ai | api` tagging on requirements.
- No cross-spec consistency check between platform and integration views.
- **Closes via:** DESIGN-20 (Stage 4 fnspec split into 4a + 4b with native-AI vs API tagging).

---

### 1.4 generate-technical-spec

**Hand-off contract:**
- Carrier file path: `<Client>/build-specs/<platform>/03_technical-spec_v{N}.md`
- Frontmatter fields propagated: `... based_on_functional_spec: 02_functional-spec_v{N}.md` (note: key uses underscore `functional_spec`; filename uses hyphen `functional-spec`)
- Gating status flag: `draft → approved`
- Hand-off message points at: `generate-test-plan`

**Observed brittleness:**
- `dydx-delivery/skills/generate-technical-spec/SKILL.md:38-39` references missing `platform-pipefy` and `platform-wrike` skills via `platform:` dispatch ("`platform: pipefy` → load the `platform-pipefy` skill"; "`platform: wrike` → load the `platform-wrike` skill"); contract is broken in-repo — neither skill folder exists under `dydx-delivery/skills/`. **[BLOCKING]**
- `dydx-delivery/skills/generate-technical-spec/SKILL.md:28-32` carries the start-at-any-point triage block — 3rd of 6 near-identical copies (see AUDIT-05). **[STRUCTURAL]**
- `dydx-delivery/skills/generate-technical-spec/SKILL.md:99-108` writes frontmatter key `based_on_functional_spec` (underscore) referencing filename `02_functional-spec_v{N}.md` (hyphen) — key/filename casing mismatch. **[STRUCTURAL]**
- `dydx-delivery/skills/generate-technical-spec/SKILL.md:90` carries the tier-claim text "Pipefy Business+, Wrike Pinnacle" without any `tier_claims_last_verified:` mechanism in the frontmatter; tier claims age silently. **[STRUCTURAL]**

**What's missing for v2:**
- No scope-gate against fnspec-integration existence (today the tech spec runs unconditionally, not only when integration work exists).
- No platform-API addendum slot on the platform fnspec for API-required portions of an otherwise platform-only build.
- No explicit retries / idempotency / observability commitments for API portions of a tech spec.
- **Closes via:** DESIGN-21 (Stage 5 Tech spec scope gate); DESIGN-14 / DESIGN-15 / DESIGN-16 (platform skills internalised + tier-verification mechanism); DESIGN-01 (frontmatter scheme — fixes underscore-vs-hyphen key naming).
- **Pitfall ref:** MOD-7 (tier-claim currency); CRIT-6 (frontmatter migration).

---

### 1.5 generate-test-plan

**Hand-off contract:**
- Carrier file path: `<Client>/testing/<feature>/test-plan_v{N}.md`
- Frontmatter fields propagated: `... status: draft, based_on_technical_spec: 03_technical-spec_v{N}.md, sandbox: { pipe_id, space_id, tenant }` (note: `pipe_id` and `space_id` written unconditionally regardless of `platform:` value)
- Gating status flag: `draft → approved`
- Hand-off message points at: `generate-build-prompt`

**Observed brittleness:**
- `dydx-delivery/skills/generate-test-plan/SKILL.md:30-34` carries the start-at-any-point triage block — 4th of 6 near-identical copies (see AUDIT-05). **[STRUCTURAL]**
- `dydx-delivery/skills/generate-test-plan/references/test-plan-template.md:17` self-labels "Stage 5" yet test-plan output files have no numeric prefix (`test-plan_v{N}.md`); two-scheme conflict between file-prefix and Stage-N labels. **[STRUCTURAL]**
- `dydx-delivery/skills/generate-test-plan/SKILL.md:91-105` and `dydx-delivery/skills/generate-test-plan/references/test-plan-template.md:9-13` both emit `pipe_id` and `space_id` together regardless of `platform:` — Pipefy vocabulary and Wrike vocabulary co-mingled in one frontmatter block. **[STRUCTURAL]**
- `dydx-delivery/skills/generate-test-plan/references/test-plan-template.md:36-44` inlines a "Hard rules" block — 1 of 4 duplicated copies of the canonical hard-rules content (canonical lives at `dydx-delivery/skills/execute-tests/references/safety-rules.md`; see AUDIT-05). **[STRUCTURAL]**

**What's missing for v2:**
- Today's test plan path is `<Client>/build-specs/<platform>/...` adjacent under `<Client>/testing/...`; no slot inside a per-client persistent test harness ("test-bot") path.
- No coexistence model with a forthcoming `provision-test-harness` Stage 8a skill.
- **Closes via:** DESIGN-24 (Stage 8 test bot architecture); DESIGN-01 (frontmatter scheme — sandbox block keyed by `platform:`); DESIGN-02 (canonical stage numbering); DESIGN-03 (single source of truth for hard rules).
- **Pitfall ref:** CRIT-5 (sandbox-allowlist gap on Coda).

---

### 1.6 generate-build-prompt

**Hand-off contract:**
- Carrier file path: `<Client>/build-specs/<platform>/04_build-prompt_v{N}.md`
- Frontmatter fields propagated: `... status: draft, based_on_technical_spec, based_on_test_plan, build_components: [platform_config, custom_code]`
- Gating status flag: `draft` (no follow-up status documented anywhere in the SKILL body)
- Hand-off message points at: tool transition to Claude Code (not a next-skill pointer); pointer to `references/when-to-open-claude-code.md`

**Observed brittleness:**
- `dydx-delivery/skills/generate-build-prompt/SKILL.md:47` references missing `platform-pipefy` / `platform-wrike` skills ("Based on `platform:` frontmatter, load `platform-pipefy`, `platform-wrike`, etc."); contract is broken in-repo. **[BLOCKING]**
- `dydx-delivery/skills/generate-build-prompt/SKILL.md:28-32` carries the start-at-any-point triage block — 5th of 6 near-identical copies (see AUDIT-05). **[STRUCTURAL]**
- `dydx-delivery/skills/generate-build-prompt/SKILL.md:8` and `dydx-delivery/skills/generate-build-prompt/SKILL.md:163-171` duplicate the Cowork-vs-Claude-Code positioning narrative — 3rd of 3 copies of this block across the plugin (see AUDIT-05). **[STRUCTURAL]**
- `dydx-delivery/skills/generate-build-prompt/SKILL.md:43` mentions the sibling-prompt convention `04a_build-prompt-config.md` / `04b_build-prompt-code.md`; convention is not reflected in `dydx-delivery/skills/generate-build-prompt/references/build-prompt-template.md` output path nor in `dydx-delivery/README.md:60-72` file-shape diagram. **[STRUCTURAL]**
- `dydx-delivery/skills/generate-build-prompt/references/build-prompt-template.md:129` references `04_build-prompt_v<N>_deviations.md`; the deviations-file convention appears nowhere else (not in SKILL.md, not in README). **[STRUCTURAL]**
- `dydx-delivery/skills/generate-build-prompt/references/when-to-open-claude-code.md:88` references a client-folder `.env.example` that does not exist in the repo. **[STRUCTURAL]**

**What's missing for v2:**
- Today there is one build prompt for a developer; no companion non-dev implementation prompt for clients who will operate the build directly.
- No per-platform shape for the implementation prompt (Pipefy / Wrike / Ziflow have different non-dev surfaces).
- No `delivery: native-ai | api` tag consumed from a Stage 4a fnspec.
- **Closes via:** DESIGN-23 (Stage 7 dual build prompts — 7a dev + 7b non-dev implementation); DESIGN-01 (frontmatter scheme — sibling-prompt naming locked); DESIGN-12 (skill inventory — orphan-reference resolution).

---

### 1.7 execute-tests

**Hand-off contract:**
- Carrier file path: `<Client>/testing/<feature>/results-YYYY-MM-DD_v{N}.md`
- Frontmatter fields propagated: `... runner: dydx-delivery/execute-tests v0.1.0` (hardcoded; results-template has no `status:` field at all — divergent from every other artefact template)
- Gating status flag: (terminal stage; no `status:` lifecycle on the results carrier)
- Hand-off message points at: (terminal stage — results summary back to user)

**Observed brittleness:**
- `dydx-delivery/skills/execute-tests/references/results-template.md:9` hardcodes `runner: dydx-delivery/execute-tests v0.1.0` while `dydx-delivery/.claude-plugin/plugin.json` declares the plugin at `0.3.0`. **[STRUCTURAL]**
- `dydx-delivery/skills/execute-tests/references/results-template.md` frontmatter has no `status:` field — every other artefact template (intake / sow / fnspec / techspec / test-plan / build-prompt) carries a `status:` field. **[STRUCTURAL]**
- `dydx-delivery/skills/execute-tests/SKILL.md:55` references missing `platform-pipefy` / `platform-wrike` skills ("load the matching skill (`platform-pipefy`, `platform-wrike`, etc.)"); contract is broken in-repo. **[BLOCKING]**
- `dydx-delivery/skills/execute-tests/SKILL.md:40-44` carries the start-at-any-point triage block — 6th of 6 near-identical copies (see AUDIT-05). **[STRUCTURAL]**
- `dydx-delivery/skills/execute-tests/SKILL.md:21-31` inlines a "Hard rules — enforced regardless of test plan content" block — 1 of 4 duplicated copies of the canonical hard-rules content (canonical lives at `dydx-delivery/skills/execute-tests/references/safety-rules.md`; SKILL inline lists 7 condensed rules vs canonical's 10 numbered rules — see AUDIT-05). **[STRUCTURAL]**
- `dydx-delivery/skills/execute-tests/references/safety-rules.md` sandbox-allowlist schema covers `pipe_id` / `space_id` / `tenant` only — Coda doc IDs are not covered, so the allowlist offers no constraint on Coda writes once Coda enters the v2 pipeline. **[STRUCTURAL]**
- `dydx-delivery/skills/execute-tests/references/safety-rules.md:93` reads "Parallel execution is not supported in v1" — no companion versioning anchor in the file; "v1" floats as an unscoped reference. **[STRUCTURAL]**
- `dydx-delivery/skills/execute-tests/references/results-template.md:18` self-labels "Stage 6" — same Stage-6 label as `dydx-delivery/skills/generate-build-prompt/references/build-prompt-template.md:15`; two distinct templates collide on the same Stage label. **[STRUCTURAL]**

**What's missing for v2:**
- Today's sandbox-allowlist does not cover Coda doc IDs; no `harness_drift` failure class exists; test-cases have no lifecycle states (`active | obsolete | quarantined`); no `sandbox_lock.yaml` for human-vs-bot concurrency control.
- **Closes via:** DESIGN-24 (Stage 8 test bot architecture — sandbox extension + drift class + case lifecycle + concurrency lock); DESIGN-01 (frontmatter scheme — results-template gains `status:`); DESIGN-02 (canonical stage numbering — Stage-6 collision resolved); DESIGN-04 (refine-pattern decision touches the missing-`/refine-execute-tests` orphan).
- **Pitfall ref:** CRIT-5 (sandbox-allowlist gap on Coda); CRIT-6 (frontmatter migration corruption).

---

## AUDIT-02: CONCERNS.md absorption (verified superset)

AUDIT.md is a **verified superset of** `.planning/codebase/CONCERNS.md` (audit dated 2026-05-09). Every CONCERNS.md entry has been rewritten into the appropriate AUDIT-* section per D-08, with the original `file:line` citation preserved. Net-new findings discovered during this audit pass carry the `[NEW]` tag per D-10. **All 15 CONCERNS.md sections absorbed; zero entries dropped silently.**

**All CONCERNS.md sections absorbed; zero entries dropped silently.**

High-level absorption summary (one row per CONCERNS.md H2 section → primary AUDIT-* destination — short form; **Appendix B carries the detailed trace**):

| CONCERNS.md section | Primary destination |
|---|---|
| Version string mismatches | AUDIT-06 |
| References to skills/files that do not exist | AUDIT-04 |
| Truncated / cut-off content | AUDIT-07 |
| Pipeline stage numbering inconsistencies | AUDIT-01; AUDIT-05 |
| "test plan" vs "test sheet" | AUDIT-07 |
| Pipeline-step count mismatch | AUDIT-07 |
| Empty / missing scaffold directories | AUDIT-04 |
| Cross-references between docs (negative) | AUDIT-04 §4.6 |
| Duplicated content across skills | AUDIT-05 |
| TODO / FIXME / HACK / XXX markers (negative) | AUDIT-01 / AUDIT-07 (clean) |
| Frontmatter / template structural inconsistencies | AUDIT-01 (per skill) |
| Identifiers / contact details | AUDIT-07 (email); AUDIT-04 / AUDIT-07 (homepage) |
| Build artefact path references in spec text | AUDIT-01 (build-prompt); AUDIT-04 |
| License field | AUDIT-07 |
| Versioning convention vs current state | AUDIT-06 |

**See Appendix B for the full row-per-section trace** including line ranges, entry counts, severity tags, and cross-references.

---

## AUDIT-03: Per-Stage Connector Dependencies

The v0.3.0 pipeline is **artefact-driven** — each skill reads a markdown file from the previous stage and writes a markdown file for the next, per `dydx-delivery/README.md:60-72` and `.planning/codebase/INTEGRATIONS.md:175-197`. As a result, most skills do NOT directly invoke connectors at all; generated artefacts merely *reference* connector vocabulary (e.g. Pipefy GraphQL endpoints in `dydx-delivery/skills/generate-technical-spec/references/technical-spec-template.md:112-119`, Slack `#ops-alerts` in `dydx-delivery/skills/execute-tests/references/safety-rules.md:41`). The two real-connector exceptions are `discovery-intake` (optional Miro paste) and `execute-tests` (the only skill that actually issues sandbox API calls per `dydx-delivery/skills/execute-tests/references/safety-rules.md:75-76`). v2's Coda/Drive/Gmail/Calendar dependencies (Phase 2 scope per `.planning/ROADMAP.md`) are OUT OF SCOPE for AUDIT-03 — the design contract for graceful-degradation lives in **DESIGN-07**.

| Stage | Miro | Coda | Drive | Gmail | Calendar | Claude in Chrome | Pipefy API | Wrike API | Ziflow API |
|---|---|---|---|---|---|---|---|---|---|
| discovery-intake | optional (graceful) | (none) | (none) | (none) | (none) | (none) | (none) | (none) | (none) |
| generate-sow | (none) | (none) | (none) | (none) | (none) | (none) | (none) | (none) | (none) |
| generate-functional-spec | (none) | (none) | (none) | (none) | (none) | (none) | (none) | (none) | (none) |
| generate-technical-spec | (none) | (none) | (none) | (none) | (none) | (none) | (referenced in artefact only) | (referenced in artefact only) | (referenced in artefact only) |
| generate-test-plan | (none) | (none) | (none) | (none) | (none) | (none) | (referenced in artefact only) | (referenced in artefact only) | (none) |
| generate-build-prompt | (none) | (none) | (none) | (none) | (none) | (none) | (referenced in artefact only) | (referenced in artefact only) | (referenced in artefact only) |
| execute-tests | (none) | (none) | (none) | (none) | (none) | (none) | REQUIRED | REQUIRED | REQUIRED |

*Citations: Per-stage usage derived from `dydx-delivery/skills/<skill>/SKILL.md` Inputs/Outputs sections; INTEGRATIONS.md §"Stage Pipeline Wiring" (lines 175-197) is the consolidated source. `discovery-intake` Miro paste-in is optional per `dydx-delivery/skills/discovery-intake/SKILL.md:30-50`. `execute-tests` REQUIRED cells reflect the `platform:` dispatch contract — exactly one of Pipefy/Wrike/Ziflow is required per active platform per `dydx-delivery/skills/execute-tests/SKILL.md:53-55` and `dydx-delivery/skills/execute-tests/references/safety-rules.md:11-17`. Live-wiring probe results (working/broken/missing) are AUDIT-08's territory; this table inventories dependency, not connectivity.*

---

**Sub-section: Research-derived graceful-degradation hints**

`.planning/research/PITFALLS.md` (research synthesis, 2026-05-09) drafts a connector-availability fallback matrix for v2 stages that go beyond v0.3.0's surface — Coda → Stage 5/Stage 10 manual mode if MCP missing; Drive → Stage 8 halt if MCP missing; Miro/Gmail/Calendar → manual paste fallback; Pipefy/Wrike/Ziflow APIs → halt the affected stage; native-AI ingestion → copy-paste UI fallback. The full matrix is research-derived input to DESIGN-07; AUDIT.md cites it by reference and does NOT lock the contract here. Representative rows below (sample, not full mirror):

| v2 stage (per Phase 2 scope) | Connector | Research fallback hint | Closes via |
|---|---|---|---|
| Stage 6 Cost estimate | Coda MCP | manual mode (`.csv` export + paste-in) when missing | DESIGN-07; DESIGN-22 |
| Stage 9 Documentation publishing | Google Drive MCP | halt — Stage 9 fails fast; rest of pipeline still runs | DESIGN-07; DESIGN-25 |
| Stage 10 Native-AI knowledge push | Pipefy/Wrike/Ziflow APIs | copy-paste fallback when direct API missing | DESIGN-07; DESIGN-26 |
| Stage 1 Kickoff capture | Miro MCP | paste-in fallback (already supported in v0.3.0 discovery-intake) | DESIGN-07; DESIGN-17 |

**Research-derived; v2 design contract = DESIGN-07.** AUDIT.md does not lock the matrix; the rows above are sourced from `.planning/research/PITFALLS.md` "Connector-availability fallback matrix" content (per RESEARCH.md §12 Open Q4 — option (c)) so reviewers see the input shape Phase 2 will work from. Pitfall IDs anchoring the per-row hints: CRIT-3 (Coda rate-limit forces manual fallback when MCP missing), CRIT-5 (sandbox-allowlist gap on Coda), MOD-1 (graceful-degradation behaviour codification gap), MIN-2 (Drive permission asymmetry on Stage 9 halt path).

---

## AUDIT-04: Referenced-but-Missing Artefacts

Catalogues every artefact that v0.3.0 docs reference but does not exist in the repo. Each subsection lists the exact references with `file:line` citations and points at the DESIGN-* requirement that closes the gap (audit names the gap; the named DESIGN-* requirement carries the fix per D-13). Subsection 4.6 collects verified-clean cross-references so absence-of-mention isn't read as untested.

### 4.1 platform-pipefy / platform-wrike skills

Three downstream skills dispatch on `platform:` frontmatter and dynamically load `platform-pipefy` or `platform-wrike` — neither directory exists under `dydx-delivery/skills/`.

| Reference | Citation | Context |
|---|---|---|
| Plugin README "Platform handling" | `` `dydx-delivery/README.md:89` `` | "Downstream skills...read this and dynamically load the matching platform skill (`platform-pipefy` or `platform-wrike`)" |
| `generate-build-prompt` SKILL | `` `dydx-delivery/skills/generate-build-prompt/SKILL.md:47` `` | "Based on `platform:` frontmatter, load `platform-pipefy`, `platform-wrike`, etc." |
| `execute-tests` SKILL | `` `dydx-delivery/skills/execute-tests/SKILL.md:55` `` | "load the matching skill (`platform-pipefy`, `platform-wrike`, etc.)" |
| `generate-technical-spec` SKILL | `` `dydx-delivery/skills/generate-technical-spec/SKILL.md:38-39` `` | "`platform: pipefy` → load the `platform-pipefy` skill"; "`platform: wrike` → load the `platform-wrike` skill" |

**Severity:** **[BLOCKING]** — three downstream skills dispatch on `platform:`; the contract is broken in-repo today.

**Closes via:** DESIGN-14 (`platform-pipefy/`); DESIGN-15 (`platform-wrike/`); DESIGN-16 (`platform-ziflow/`).

---

### 4.2 /refine-<skill> slash commands

Three orphan references to a `/refine-<skill>` command pattern; no `commands/` directory exists in the plugin and no `refine-*` skill exists.

| Reference | Citation | Context |
|---|---|---|
| Root README "How to publish" | `` `README.md:56` `` | "Example commit message: `feat(dydx-delivery): add refine-<skill> counterparts`" |
| Plugin README pipeline-loop step 5 | `` `dydx-delivery/README.md:51` `` | "Reviewer either edits in place...or runs `/refine-<skill>` to regenerate" |
| Plugin README versioning Option B | `` `dydx-delivery/README.md:85` `` | "Optional sibling `_review.md` for major iteration notes (used by `/refine-<skill>` if added later)" |

**Severity:** **[STRUCTURAL]** — orphan references; reader can't act on them.

**Closes via:** DESIGN-05 (refine pattern resolution) → Phase 4 OPEN-06.

---

### 4.3 Workspace hub.md

Workspace-level client index referenced in plugin README and discovery-intake; not present in this repo.

| Reference | Citation | Context |
|---|---|---|
| Plugin README file-locations | `` `dydx-delivery/README.md:57` `` | "Artefacts land in the standard client folder shape (see workspace `hub.md`)" |
| `discovery-intake` SKILL Step 1 | `` `dydx-delivery/skills/discovery-intake/SKILL.md:27` `` | "match it against the workspace `hub.md` client index" |
| `discovery-intake` SKILL Step 1 (second) | `` `dydx-delivery/skills/discovery-intake/SKILL.md:28` `` | "see `hub.md`" |

**Severity:** **[STRUCTURAL]** — orphan reference. v2 names a per-client `00_HUB.md` (different artefact, lives inside client folders) but the workspace-level `hub.md` reference does not match that.

**Closes via:** No single DESIGN-* requirement closes this directly; OPEN-04 (hub-link backfill) addresses per-client `00_HUB.md`. Workspace-level `hub.md` resolution is deferred to Phase 4 OPEN-QUESTIONS.

---

### 4.4 Client folder .env.example

Per-client `.env.example` referenced as the canonical list of required env-var names; this is a *per-client* artefact (lives outside this repo by design), but the gap is that v2 may need to specify a canonical shape.

| Reference | Citation | Context |
|---|---|---|
| `when-to-open-claude-code.md` setup-step 3 | `` `dydx-delivery/skills/generate-build-prompt/references/when-to-open-claude-code.md:88` `` | "Set up env vars for sandbox API access...see your client folder's `.env.example`" |
| `build-prompt-template.md` env-var section | `` `dydx-delivery/skills/generate-build-prompt/references/build-prompt-template.md:120` `` (per `` `.planning/codebase/CONCERNS.md:48` ``) | Per-client `.env.example` referenced as the source for required env-var names |

**Severity:** **[STRUCTURAL]** — orphan reference (per-client artefact, missing in *this* repo is correct; the gap is canonical-shape spec for v2).

**Closes via:** Adjacent to DESIGN-09 (directional-boundary contract); not a direct match. Likely Phase 4 OPEN-QUESTIONS.

---

### 4.5 Missing scaffold directories (commands/, agents/, hooks/)

Plugin scaffold directories absent; v2 architecture introduces all three.

| Reference | Citation | Context |
|---|---|---|
| `dydx-delivery/commands/` | `` `.planning/codebase/CONCERNS.md:99` `` | "No `commands/` directory exists in the plugin"; v2 introduces 1 parameterised `refine.md` + 4 GSD-prefixed shortcuts (DESIGN-04) |
| `dydx-delivery/agents/` | `` `.planning/codebase/CONCERNS.md:100` `` | "No `agents/` directory exists in the plugin"; v2 introduces 1 (`test-bot-orchestrator`) (DESIGN-04) |
| `dydx-delivery/hooks/` | `` `.planning/codebase/CONCERNS.md:101` `` | "No `hooks/` directory exists in the plugin"; v2 introduces 2 (`validate-frontmatter`, `bump-artefact-version`); explicitly NOT auto-progression (DESIGN-04) |

**Severity:** **[STRUCTURAL]** — scaffold absence; v2 adds these surfaces.

**Closes via:** DESIGN-04 (plugin surfaces).

---

### 4.6 Verified working cross-references (negative finding)

Beyond the missing artefacts above, several cross-references in v0.3.0 docs DO resolve correctly. Listed here so reviewers do not conflate "not flagged" with "not checked".

- `` `dydx-delivery/README.md:95` `` → points at `skills/generate-build-prompt/references/when-to-open-claude-code.md` — file resolves.
- `` `dydx-delivery/skills/execute-tests/SKILL.md:23` `` → points at `references/safety-rules.md` — file resolves.
- `` `dydx-delivery/skills/generate-test-plan/SKILL.md:49` `` → points at `references/test-plan-template.md` — file resolves.

(No broken intra-plugin references found beyond the 5 categories above. Verified by directory listings during the 2026-05-09 audit pass.)

---

## AUDIT-05: Duplicated Content Blocks

Catalogues every block of duplicated content in v0.3.0 along with the canonical-source recommendation per AUDIT-05 requirement. The recommendation names where canonical content should live; v2 design moves (single-SoT consolidation, plugin-level `references/`) are tracked under DESIGN-* requirements per D-13.

### 5.1 Hard-rules block (4 mentions; 3 duplicates of 1 canonical)

Sandbox / no-deletions / read-write-only / audit-trail rules appear in 4 surfaces. The 4 copies do NOT match exactly — canonical lists 10 numbered rules; the others list 5–7 condensed. Per RESEARCH.md §12 Open Q6, framing is "4 mentions; 3 are duplicates of 1 canonical" (correcting CONCERNS.md's "three places" wording).

| Location | Lines | Role |
|---|---|---|
| `dydx-delivery/skills/execute-tests/references/safety-rules.md` | full file (1-101) | **CANONICAL** — 10 numbered rules |
| `dydx-delivery/README.md:99-105` | 7 lines | DUPLICATE — 5 condensed bullets ("Test execution — safety rules (hard)") |
| `dydx-delivery/skills/execute-tests/SKILL.md:21-31` | 11 lines | DUPLICATE — 7 numbered rules condensed |
| `dydx-delivery/skills/generate-test-plan/references/test-plan-template.md:36-44` | 9 lines | DUPLICATE — 5 condensed bullets |

**Canonical source:** `dydx-delivery/skills/execute-tests/references/safety-rules.md` — most complete (10 numbered rules), already documented as the canonical reference at `dydx-delivery/skills/execute-tests/SKILL.md:23`.

**Severity:** **[STRUCTURAL]** — wording mismatch across 4 surfaces creates rule-divergence risk.

**Closes via:** DESIGN-03 (single SoT for hard rules at `dydx-delivery/references/safety-rules.md` — note v2 elevates to plugin-level `references/`). **Pitfall ref:** MOD-16 (hard-rules duplicate-and-edit).

---

### 5.2 Start-at-any-point triage block (6 SKILL.md copies)

Near-identical 3-option prompt ("(a) Paste / (b) Walk through inline / (c) Cancel") appears in 6 SKILL.md files with small wording variations. No canonical source today.

| Location | Lines | Role |
|---|---|---|
| `dydx-delivery/skills/generate-sow/SKILL.md:27-33` | 7 lines | DUPLICATE |
| `dydx-delivery/skills/generate-functional-spec/SKILL.md:28-32` | 5 lines | DUPLICATE |
| `dydx-delivery/skills/generate-technical-spec/SKILL.md:28-32` | 5 lines | DUPLICATE |
| `dydx-delivery/skills/generate-test-plan/SKILL.md:30-34` | 5 lines | DUPLICATE |
| `dydx-delivery/skills/generate-build-prompt/SKILL.md:28-32` | 5 lines | DUPLICATE |
| `dydx-delivery/skills/execute-tests/SKILL.md:40-44` | 5 lines | DUPLICATE |

**Canonical source:** None today. Audit observation: needs a v2 canonical reference (e.g. plugin-level `references/start-at-any-point.md`); audit names the gap, the named DESIGN-* requirement carries the location.

**Severity:** **[STRUCTURAL]** — wording variations create per-skill divergence.

**Closes via:** DESIGN-11 (plugin-level `references/` directory) implies a place; specific consolidation is part of v2.1 build phase per FOUND-02.

---

### 5.3 Cowork-vs-Claude-Code positioning (3 copies)

Cowork-as-strategy-seat / Claude-Code-as-build-seat framing appears in 3 surfaces. The decision-matrix `when-to-open-claude-code.md` is canonical; the other two repeat the framing one-liner without the matrix.

| Location | Lines | Role |
|---|---|---|
| `dydx-delivery/skills/generate-build-prompt/references/when-to-open-claude-code.md` | full file (1-89) | **CANONICAL** — decision matrix; framing one-liner duplicated above |
| `dydx-delivery/README.md:5,9-29` | header + 21 lines | DUPLICATE — pipeline-diagram framing + one-liner ("Cowork is the strategy seat. Claude Code is the build seat.") |
| `dydx-delivery/skills/generate-build-prompt/SKILL.md:8,163-171` | 1 line + 9 lines | DUPLICATE — one-liner at line 8; "Iterating between Cowork and Claude Code" section at 163-171 |

**Canonical source:** `dydx-delivery/skills/generate-build-prompt/references/when-to-open-claude-code.md` — keeps the canonical decision matrix; the plugin README and `generate-build-prompt` SKILL.md should inline a one-line summary plus pointer (consistent with hard-rules pattern).

**Severity:** **[STRUCTURAL]** — same framing duplicated; wording could drift.

**Closes via:** DESIGN-10 (persona contract) — likely subsumes the positioning text; specific consolidation is v2.1 build.

---

### 5.4 Pipeline diagram (2 copies)

Two ASCII pipeline diagrams: high-level overview (plugin README) and tool-transition swimlanes (`when-to-open-claude-code.md`). Two copies serve different purposes — could be argued they're not strict duplicates. Audit calls out per CONCERNS.md classification but recommends both retained.

| Location | Lines | Role |
|---|---|---|
| `dydx-delivery/README.md:9-29` | 21 lines | **CANONICAL (high-level overview)** — pipeline-overview ASCII + 7-skill table |
| `dydx-delivery/skills/generate-build-prompt/references/when-to-open-claude-code.md:18-40` | 23 lines | **CANONICAL (tool-transition view, distinct purpose)** — swimlane variant illustrating tool transitions |

**Canonical source:** Both retained; the swimlane variant is marked as "tool-transition view" not "pipeline view" — different lens, not strict duplicate.

**Severity:** **[STRUCTURAL]** — visual drift risk if maintained separately; observation logged for v2 consideration.

**Closes via:** DESIGN-12 (skill inventory) implies a redrawn 13-skill diagram in plugin-level docs.

---

### 5.5 [NEW] Stage-N label collision (2 templates labelled "Stage 6")

Two distinct templates self-label as "Stage 6" — a literal duplicate label-string conflict.

| Template | Line | Self-label |
|---|---|---|
| build-prompt-template.md | 15 | "Stage 6 of the dydx-delivery pipeline" |
| results-template.md | 18 | "Stage 6 of the dydx-delivery pipeline" |

Citations:
- `dydx-delivery/skills/generate-build-prompt/references/build-prompt-template.md:15`
- `dydx-delivery/skills/execute-tests/references/results-template.md:18`

**[NEW]** **[STRUCTURAL]** — already covered by `.planning/codebase/CONCERNS.md:71` under Stage-numbering inconsistencies, re-flagged here as a literal duplicate label.

**Closes via:** DESIGN-02 (canonical stage-numbering scheme — substages `4a/4b/7a/7b/8a-8d` and old→new mapping table).

---

## AUDIT-06: Version-String Mismatches

Inventories every version-bearing location in v0.3.0 — manifests, READMEs, hardcoded runner strings, and an unscoped `v1` reference — and recommends `2.0.0` as the synced target version per D-17. This audit catalogues the gap; the actual version bump lands in the v2.1 Foundations work (FOUND-04), not this design milestone.

| # | Location | Citation | Current value | What it represents | Drifts from 0.3.0? |
|---|---|---|---|---|---|
| 1 | Plugin manifest | `` `dydx-delivery/.claude-plugin/plugin.json:3` `` | `"version": "0.3.0"` | Plugin semver | Source of truth |
| 2 | Marketplace plugin entry | `` `.claude-plugin/marketplace.json:16` `` | `"version": "0.3.0"` | Plugin entry version (must match #1) | No |
| 3 | Marketplace metadata version | `` `.claude-plugin/marketplace.json:9` `` | `"version": "1.2.0"` | Marketplace metadata version — scope unclear | YES (different scheme/scope) |
| 4 | Root README plugin table | `` `README.md:9` `` | `0.1.0` | Documented plugin version | YES (drifted by 0.2.0) |
| 5 | Plugin README changelog | `` `dydx-delivery/README.md:126` `` | `**0.3.0** —` (truncated) | Plugin changelog | No (matches but content truncated → AUDIT-07) |
| 6 | Results-template runner | `` `dydx-delivery/skills/execute-tests/references/results-template.md:9` `` | `runner: dydx-delivery/execute-tests v0.1.0` | Hardcoded runner version | YES (drifted by 0.2.0) |
| 7 | Safety-rules `v1` reference | `` `dydx-delivery/skills/execute-tests/references/safety-rules.md:93` `` | "Parallel execution is not supported in v1" | Unclear-scope `v1` reference (no anchor) | Unclear (no companion anchor) |
| 8 | Root README versioning convention | `` `README.md:81-83` `` | (semver convention statement, no version) | Documents the semver convention | N/A (convention doc) |

Summary observations (locations #1, #2, #5 align at `0.3.0`; the rest drift):

- Locations #4 (root README at `0.1.0`) and #6 (results-template hardcoded `v0.1.0`) are the most egregious — both drift the plugin's declared version backwards by `0.2.0`. **[STRUCTURAL]**
- Location #3 (marketplace metadata at `1.2.0`) uses a different scheme and its scope is undocumented (`README.md:81-83` versioning convention does not address marketplace-vs-plugin version split). **[STRUCTURAL]**
- Location #7 references `v1` without a companion anchor (`safety-rules.md:93`: "Parallel execution is not supported in v1"). **[STRUCTURAL]**

**Recommended sync target: `2.0.0`** per AUDIT-06 requirement and D-17. All 6 version-bearing locations (#1, #2, #3, #4, #5, #6) move to `2.0.0` in v2.1 Foundations build (FOUND-04); location #7 needs an anchor decision (delete the `v1` phrase or replace with v2 anchor); location #8 is the convention statement (no value change required). **Cross-ref:** AUDIT-07 (cosmetic-but-client-visible aspect of locations #4 and #5).

---

## AUDIT-07: Cosmetic-but-Client-Visible Issues

Catalogues every cosmetic-but-client-visible issue in v0.3.0 — README truncation, naming residuals, pipeline-step count mismatch, missing LICENSE, owner-email mismatch, manifest asymmetries. **Each fix below carries the per-bullet sentinel "Scheduled for v2.1 Foundations build (FOUND-NN), NOT this milestone." so a v2.1 implementer cannot lift one bullet out of context (per D-16).** This audit catalogues the issues; the v2.1 Foundations build executes the fixes (FOUND-04, FOUND-07).

### 7.1 README truncation (plugin-level)

- **Citation:** `dydx-delivery/README.md:126` — Changelog entry for `0.3.0` reads: *"The bot-run terminal stage (`execute-tests`) now c"* and the file terminates mid-sentence. No closing punctuation, no further entries.
- **Context:** Plugin README is the install-time README; truncation is visible to anyone reading the plugin's marketplace listing.
- **Severity:** **[COSMETIC]** — client-visible (plugin README).
- **Fix:** Complete the truncated sentence in the changelog entry. **Scheduled for v2.1 Foundations build (FOUND-07), NOT this milestone.**

---

### 7.2 Residual "test sheet" wording

- **Citation:** `README.md:9` — Root README still says "discovery → SOW → functional spec → technical spec → **test sheet** → execution".
- **Context:** Plugin README changelog (`dydx-delivery/README.md:126`) records the 0.3.0 rename `generate-test-sheet` → `generate-test-plan`; root README never followed the rename.
- **Severity:** **[COSMETIC]** — client-visible (root marketplace README).
- **Fix:** Change "test sheet" to "test plan" at `README.md:9`. **Scheduled for v2.1 Foundations build (FOUND-07), NOT this milestone.**

---

### 7.3 Pipeline-step count mismatch (root README)

- **Citation:** `README.md:9` says 5 pipeline steps; `.claude-plugin/marketplace.json:15` and `dydx-delivery/.claude-plugin/plugin.json:4` describe **seven skills**; `dydx-delivery/README.md:33-41` lists seven.
- **Context:** Two-vs-three sources of truth disagree on pipeline length; new readers see contradictory information.
- **Severity:** **[COSMETIC]** — client-visible (root README).
- **Fix:** Update `README.md:9` to reflect the 7-skill v0.3.0 pipeline (or v2's 13-skill pipeline post-rebuild). **Scheduled for v2.1 Foundations build (FOUND-07), NOT this milestone.**

---

### 7.4 Missing LICENSE file

- **Citation:** `dydx-delivery/.claude-plugin/plugin.json:10` declares `"license": "Proprietary"`; no `LICENSE` or `LICENSE.md` file exists at repo root or plugin folder; `.claude-plugin/marketplace.json` has no `license` field.
- **Context:** Provenance gap — the `Proprietary` declaration is unbacked by an actual licence text; clients viewing the marketplace see a license field that doesn't resolve to a document.
- **Severity:** **[COSMETIC]** — client-visible (provenance).
- **Fix:** Add `LICENSE` file at repo root (or `dydx-delivery/LICENSE`) with proprietary licence terms; add matching `license` field to `marketplace.json`. **Scheduled for v2.1 Foundations build (FOUND-04), NOT this milestone.**

---

### 7.5 Owner-email mismatch with stated org

- **Citation:** `.claude-plugin/marketplace.json:5` (`owner.email`) and `dydx-delivery/.claude-plugin/plugin.json:7` (`author.email`) both list `jasonmichaelb@gmail.com`; README and marketplace metadata describe the team as "dYdX Digital" (e.g. `.claude-plugin/marketplace.json:4`, `dydx-delivery/.claude-plugin/plugin.json:4`); no `@dydx.digital` or org domain appears in the manifests.
- **Context:** Provenance — clients viewing the marketplace see a personal Gmail; mismatches the stated organisational identity.
- **Severity:** **[COSMETIC]** — client-visible (provenance).
- **Fix:** Change to an org-domain address. **Scheduled for v2.1 Foundations build (FOUND-04), NOT this milestone.** **Cross-ref:** MIN-6 PITFALL.

---

### 7.6 [NEW] Homepage asymmetry

- **Citation:** `dydx-delivery/.claude-plugin/plugin.json:9` has `"homepage": "https://github.com/SonofJay13/dydx-project-workflow"`; `.claude-plugin/marketplace.json` has no `homepage` field. (`.planning/codebase/CONCERNS.md:197-199`).
- **Context:** Asymmetric metadata — the marketplace listing omits a link the plugin manifest provides.
- **Severity:** **[NEW]** **[COSMETIC]** — client-visible (marketplace listing). [NEW] tag because CONCERNS.md flagged the asymmetry but didn't formally categorize it; AUDIT.md elevates it to cosmetic-client-visible.
- **Fix:** Add matching `homepage` field to `marketplace.json`. **Scheduled for v2.1 Foundations build (FOUND-04), NOT this milestone.**

---

## AUDIT-08: Live MCP Wiring Probe

Records the live MCP probe state in this Claude Code workspace at probe time. Probe methodology per D-04 / D-05: one cheap-read endpoint per MCP; outcome captured (status / response code / item count). Probe results are timestamped — re-probing later may differ as MCP wiring evolves.

**Probe time:** `2026-05-09T16:30:53Z`; **Workspace:** `dydx-project-workflow` (branch `dydx-delivery-v2`); **Operator:** Claude Code CLI session (sub-agent execution context, executor model = Opus 4.7).

**Probe transport:** `claude mcp list` was invoked at the timestamp above; the verbatim transport-level health output is the canonical "Connected" signal for each row's `Probed status` column. Per-endpoint cheap-read invocation outcomes are recorded in the `Result` column — see the per-row note where the `mcp__claude_ai_*` tool function for a Connected server is not exposed as a callable tool inside this sub-agent's tool set (an honest reporting boundary, not a server-side failure).

**Wired and connected — the 5 canonical MCPs**

| MCP | Server identity (per D-05) | Endpoint | Probe call (per D-04) | Probed status | Result | Version pin |
|---|---|---|---|---|---|---|
| Coda | `claude.ai Coda` (tool prefix expected `mcp__claude_ai_Coda__*`) | `https://coda.io/apis/mcp` | `listDocs` (read-only — returns user's accessible docs) | working (transport ✓ Connected); cheap-read **not invocable from this sub-agent** | `claude mcp list` reported `✓ Connected` at probe time. The `mcp__claude_ai_Coda__listDocs` tool function was not exposed in this sub-agent's tool registry (parent-session-only); recorded as honest reporting boundary per CRITICAL HONESTY RULE. **Reviewer re-probe MUST run `listDocs` directly per VALIDATION.md Manual-Only Verification.** | Endpoint version `apis/v1` (per Coda public API path; not exposed in MCP capability response) |
| Miro | `claude.ai Miro` (tool prefix expected `mcp__claude_ai_Miro__*`) | `https://mcp.miro.com` | `board_search_boards` / `listBoards` (read-only — returns user's boards) | working (transport ✓ Connected); cheap-read **not invocable from this sub-agent** | `claude mcp list` reported `✓ Connected`. Miro MCP tool functions not exposed in sub-agent tool registry. **Reviewer re-probe MUST run `listBoards` directly.** | Endpoint pin not exposed by server; treat as currently-served version |
| Google Drive | `claude.ai Google Drive` (tool prefix expected `mcp__claude_ai_Google_Drive__*`) | `https://drivemcp.googleapis.com/mcp/v1` | `searchFiles` with empty query / `list_recent_files` (read-only) | working (transport ✓ Connected); cheap-read **not invocable from this sub-agent** | `claude mcp list` reported `✓ Connected`. Google Drive MCP tool functions not exposed in sub-agent tool registry. **Reviewer re-probe MUST run `searchFiles` directly.** | `mcp/v1` from URL path |
| Gmail | `claude.ai Gmail` (tool prefix expected `mcp__claude_ai_Gmail__*`) | `https://gmailmcp.googleapis.com/mcp/v1` | `listLabels` (read-only — returns mailbox labels) | working (transport ✓ Connected); cheap-read **not invocable from this sub-agent** | `claude mcp list` reported `✓ Connected`. Gmail MCP tool functions not exposed in sub-agent tool registry. **Reviewer re-probe MUST run `listLabels` directly.** | `mcp/v1` from URL path |
| Google Calendar | `claude.ai Google Calendar` (tool prefix expected `mcp__claude_ai_Google_Calendar__*`) | `https://calendarmcp.googleapis.com/mcp/v1` | `listCalendars` (read-only — returns user's calendars) | working (transport ✓ Connected); cheap-read **not invocable from this sub-agent** | `claude mcp list` reported `✓ Connected`. Google Calendar MCP tool functions not exposed in sub-agent tool registry. **Reviewer re-probe MUST run `listCalendars` directly.** | `mcp/v1` from URL path |

**Honest reporting note (per CRITICAL HONESTY RULE / T-01-08-01 mitigation):** The five rows above carry `Probed status = working (transport ✓ Connected); cheap-read not invocable from this sub-agent` because the `mcp__claude_ai_*` tool functions are wired at the parent Claude Code session level but are not propagated into the spawned sub-agent's tool registry. Transport-level connectivity is empirically confirmed (`claude mcp list` output verbatim above the table). Per-endpoint response codes are deferred to **reviewer manual re-probe** per VALIDATION.md Manual-Only Verification — at least 3 of the 5 rows must be re-probed by the reviewer with the documented cheap-read calls and the actual response codes / item counts recorded back into this section before sign-off. Fabricating `200 OK / N items returned` here without the calls actually executing would poison the audit (T-01-08-01).

**Wired but out-of-scope per D-06**

| MCP | Status | Why out-of-scope |
|---|---|---|
| **Slack** | wired, unauthenticated — `! Needs authentication` (per `claude mcp list` 2026-05-09T16:30:53Z) | Wired but unauthenticated. Slack is referenced in v0.3.0 only as a notification target inside generated artefacts (e.g. `#ops-alerts` in `dydx-delivery/skills/generate-technical-spec/references/technical-spec-template.md:119`); not a delivery-pipeline MCP. **[NEW]** **[STRUCTURAL]** — flagged to Phase 4 OPEN-QUESTIONS. |

**Not wired — verification deferred per D-06**

| Connector | Why not probed | Where it surfaces in v0.3.0 | Verification path |
|---|---|---|---|
| **Pipefy API** (GraphQL) | No MCP for Pipefy in this workspace; sandbox-tenant credentials unavailable in design phase | `dydx-delivery/skills/execute-tests/references/safety-rules.md:75`; `platform: pipefy` route in `dydx-delivery/skills/discovery-intake/SKILL.md:86`, `dydx-delivery/skills/generate-technical-spec/SKILL.md:38`, etc. | "verification deferred" per D-06; v2.1+ build phase per CHANGE-04 |
| **Wrike API** (REST) | Same — no MCP, no creds | `dydx-delivery/skills/execute-tests/references/safety-rules.md:76`; `platform: wrike` routes in `dydx-delivery/skills/generate-technical-spec/SKILL.md:39` | "verification deferred" per D-06 |
| **Ziflow API** (REST) | Same | `dydx-delivery/skills/generate-technical-spec/references/technical-spec-template.md:113` (`POST /api/v2/projects`) | "verification deferred" per D-06 |
| **Claude in Chrome** | Canonical product naming uncertain in 2026 | Referenced in `.planning/PROJECT.md` "Connectors expected to be wired"; not in repo skill files | Phase 4 OPEN-01 per `.planning/REQUIREMENTS.md` |

**Coda integration risk surface (PITFALLS cross-ref):** Coda MCP is wired and connected, but using it correctly for v2 Stage 6 / Stage 11 is gated by four research-side pitfalls — these are research-input to DESIGN-22 (Stage 6 cost estimate) and DESIGN-27 (Stage 11 sign-off + brain mirror):

- **CRIT-1** — formula column overwrite (writes against formula columns silently no-op or corrupt rows).
- **CRIT-2** — async-202 (mutating endpoints return 202 with a request ID; reads must poll for actual landing).
- **CRIT-3** — rate-limit (per-doc and per-token quotas; bulk operations need throttle-and-retry).
- **CRIT-9** — token scope (doc-scoped vs workspace-scoped tokens behave differently for cross-doc reads).

---

## Appendix A: Glossary

(populated by Wave 9)

---

## Appendix B: CONCERNS.md → AUDIT.md trace

(populated by Wave 9)

---

*Audit produced 2026-05-09; CONCERNS.md becomes "historical input — superseded by AUDIT.md" after this milestone approves.*
