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

(populated by Wave 9 — synthesis after Waves 2-8 land)

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

## AUDIT-04: Referenced-but-Missing Artefacts

(populated by 01-04-PLAN.md / Wave 4)

---

## AUDIT-05: Duplicated Content Blocks

(populated by 01-05-PLAN.md / Wave 5)

---

## AUDIT-06: Version-String Mismatches

(populated by 01-06-PLAN.md / Wave 6)

---

## AUDIT-07: Cosmetic-but-Client-Visible Issues

(populated by 01-07-PLAN.md / Wave 7)

---

## AUDIT-08: Live MCP Wiring Probe

(populated by 01-08-PLAN.md / Wave 8)

---

## Appendix A: Glossary

(populated by Wave 9)

---

## Appendix B: CONCERNS.md → AUDIT.md trace

(populated by Wave 9)

---

*Audit produced 2026-05-09; CONCERNS.md becomes "historical input — superseded by AUDIT.md" after this milestone approves.*
