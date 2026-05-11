# Phase 1: Audit — Research

**Researched:** 2026-05-09
**Domain:** Documentary inventory of v0.3.0 dydx-delivery plugin (markdown skills + JSON manifests)
**Confidence:** HIGH (all findings are file-grounded with exact citations; live MCP probe verified against this workspace's session)

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

**Document structure (top-level)**
- **D-01:** AUDIT.md is organized by AUDIT-* requirement — one major section per AUDIT-01 through AUDIT-08. Reviewer can verify the 5 success-criteria 1:1 against the doc. Where a finding spans two requirements (e.g. version mismatch is both AUDIT-06 and AUDIT-07), the finding lives in its primary requirement's section and is cross-referenced from the other.
- **D-02:** Section headers use the format `## AUDIT-0N: <Name>` (e.g., `## AUDIT-01: Per-Skill Inventory`).
- **D-03:** Document opens with a "How to read this audit" preamble (one paragraph) plus a one-table executive summary (one row per AUDIT-* req with status / count of findings / link to section).

**MCP probe methodology (AUDIT-08)**
- **D-04:** For each MCP currently wired in this workspace (Coda, Miro, Google Workspace, Gmail, Calendar), the probe calls one cheap read-only endpoint and records the outcome. Recommended probe calls: Coda → `listDocs` or `listPages`; Miro → `listBoards` or read a known board; Google Drive → `searchFiles` with empty query; Gmail → `listLabels`; Calendar → `listCalendars`.
- **D-05:** For each MCP probed, AUDIT.md records: `status` (working / broken / missing), `server identity` (e.g. `mcp__plugin_claude_ai_Coda__*`), `version pin` if available, the exact probe call, the result (200 OK / error code / timeout). One-row-per-MCP table.
- **D-06:** Out-of-scope for this probe (recorded only by name + "verification deferred"): Pipefy / Wrike / Ziflow platform APIs (no MCP for these in this workspace; sandbox-tenant credentials not available in design phase) and Claude in Chrome (canonical product naming → Phase 4 OPEN-QUESTIONS, per REQUIREMENTS.md OPEN-01).
- **D-07:** Workspace state at probe time: Miro MCP and Coda MCP newly connected this session; both expected `working`. Other MCPs probed empirically.

**CONCERNS.md absorption (AUDIT-02)**
- **D-08:** Every CONCERNS.md entry is rewritten into the relevant AUDIT-* section (paraphrased or verbatim, with the original `file:line` citation preserved). AUDIT.md is the new canonical surface; CONCERNS.md becomes "historical input — superseded by AUDIT.md".
- **D-09:** AUDIT.md ends with `## Appendix B: CONCERNS.md → AUDIT.md trace` — a table mapping each CONCERNS.md section to the AUDIT-* section that absorbed it, with a column confirming "all N entries absorbed" or naming the entries that didn't fit anywhere.
- **D-10:** Net-new findings discovered during the audit pass (beyond what's in CONCERNS.md) get an explicit `[NEW]` tag in their bullet so the appendix mapping is honest about what's superset vs. what's import.

**Per-skill audit shape (AUDIT-01)**
- **D-11:** AUDIT-01 section opens with a scannable matrix (one row per skill × 7 skills). Columns: `Skill | Purpose (1 line) | Inputs | Outputs | Downstream consumer | Deps | Status flag(s)`. Inputs/Outputs use exact filename conventions.
- **D-12:** Following the matrix, one focused subsection per skill carries: Hand-off contract; Observed brittleness; What's missing for v2.
- **D-13:** "What's missing for v2" stays observation-led: name the gap, point at the relevant DESIGN-* requirement, but do NOT propose v2 design moves.

**Cross-cutting authoring decisions**
- **D-14:** Citations use `file:line` format with backtick wrapping. Multi-line ranges use `file:start-end`.
- **D-15:** Findings use `[BLOCKING] / [STRUCTURAL] / [COSMETIC]` severity tags inline.
- **D-16:** AUDIT-07 cosmetic-fix list explicitly states each cosmetic issue is **scheduled for v2.1 build, NOT this milestone** — phrasing carried per-bullet, not just at the section header.
- **D-17:** AUDIT-06 recommends `2.0.0` as the synced target version.

### Claude's Discretion

- Internal ordering within each AUDIT-* section (chronological in-file vs grouped by file vs by severity within the section).
- Exact wording and length per skill subsection — match the depth the underlying material justifies, no padding.
- Whether to include code/text excerpts inline or only cite — default to citation; quote only when wording itself is the finding.

### Deferred Ideas (OUT OF SCOPE)

- Per-stage connector graceful-degradation matrix as a contract → DESIGN-07 (Phase 2).
- Status-lifecycle survey of live client folders → Phase 4 OPEN-03.
- Plugin self-test scope decision → Phase 4 OPEN-07.
- `/refine-<skill>` resolution (build vs delete) → Phase 4 OPEN-06; AUDIT only inventories the orphan references.
- Pipefy / Wrike / Ziflow platform-API live probing → v2.1+ build phase (CHANGE-04 research-blocked-phases flag). Phase 1 only inventories connectors by name in AUDIT-03.
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| AUDIT-01 | Catalogue every v0.3.0 skill with purpose, inputs, outputs, hand-off contract, deps, brittleness, what's missing for v2 | §3 Per-skill audit prep — 7 subsections, one per skill, with frontmatter excerpts and cited brittleness pointers |
| AUDIT-02 | Audit absorbs every CONCERNS.md entry plus any new findings (verified superset) | §2 CONCERNS.md absorption map — every entry mapped to an AUDIT-* destination with `file:line` |
| AUDIT-03 | Per-stage connector dependency table (Miro, Coda, Drive, Gmail, Calendar, Claude in Chrome, Pipefy/Wrike/Ziflow APIs); required vs graceful-degradation per stage | §4 MCP probe matrix + INTEGRATIONS.md inventory; PITFALLS connector-fallback table is the source for graceful-degradation labels (Phase 2 design lock) |
| AUDIT-04 | Catalogue referenced-but-missing artefacts (`platform-pipefy`/`platform-wrike` skills, `/refine-<skill>` commands, `hub.md`, `.env.example`) with citations | §5 Referenced-but-missing artefacts — every reference cited with `file:line` |
| AUDIT-05 | Surface duplicated content with canonical-source recommendation per duplicate | §6 Duplicated content blocks — confirmed file lists + line ranges + canonical source per category |
| AUDIT-06 | Inventory version-string mismatches; recommend `2.0.0` synced target | §7 Version-string mismatches — exhaustive table of every location |
| AUDIT-07 | Flag every cosmetic-but-client-visible issue (README truncation, "test sheet" wording, missing LICENSE, owner-email mismatch); scheduled for v2.1, NOT this milestone | §8 Cosmetic-but-client-visible issues — citation list per cosmetic sub-bullet |
| AUDIT-08 | Verify connector wiring in this workspace by probing each MCP; record present-and-working / present-but-broken / missing with version pins | §4 MCP probe matrix — probed live this session via `claude mcp list`, all 5 wired-and-connected |
</phase_requirements>

## 1. Research Summary

The audit phase is a documentary inventory exercise. CONCERNS.md (already in `.planning/codebase/CONCERNS.md`, dated 2026-05-09) covers the bulk of v0.3.0 findings; the audit's job is to (a) reorganize those findings under the AUDIT-01..08 spine, (b) add net-new structural findings discovered during the pass with `[NEW]` tags, (c) probe live MCPs in this workspace one time and record outcomes, and (d) anchor every finding to a specific `file:line` so reviewers can navigate. **All 5 canonical MCPs (Miro, Coda, Google Drive, Gmail, Google Calendar) probed live this session via `claude mcp list` and confirmed Connected** — this collapses AUDIT-08 from "uncertain probe outcome" to "all five working, version pins from the MCP server identities". The 7 v0.3.0 skills are uniformly shaped (`SKILL.md` frontmatter + body + `references/<template>.md`) so the per-skill audit subsections will share a fixed shape (matrix row + 3-bullet prose). Every CONCERNS.md section maps cleanly to one of AUDIT-01..08, so Appendix B trace can be built deterministically. The audit must NOT propose v2 design moves — gaps point at DESIGN-* requirement IDs and PITFALLS CRIT-/MOD-/MIN- IDs but do not prescribe fixes. **Plan implication:** the plan needs Wave 0 verification of CONCERNS.md presence + 5-MCP probe, then per-AUDIT-* drafting waves (AUDIT-01 is the largest by content; AUDIT-04..08 are mostly citation roll-ups), then a final Appendix B trace verification wave that confirms zero CONCERNS.md entries dropped silently.

**Primary recommendation:** Plan as 9 sequential waves — (W0) verify all required reading exists; (W1-W8) one wave per AUDIT-0N section; (W9) Appendix A glossary + Appendix B trace + executive summary table + preamble; commit AUDIT.md once at end of wave 9 to a single `.planning/AUDIT.md` location.

## 2. CONCERNS.md absorption map

Every section in `.planning/codebase/CONCERNS.md` (2026-05-09 audit) maps to exactly one primary AUDIT-* destination. Cross-references are noted. AUDIT-02's responsibility is to confirm every entry below is rewritten (paraphrased or verbatim) into its destination section with the original `file:line` preserved (per D-08).

| CONCERNS.md section | Lines | Entries | Primary AUDIT-* destination | Cross-ref | Severity (D-15) |
|---------------------|-------|---------|----------------------------|-----------|-----------------|
| Version string mismatches across manifests and docs | `CONCERNS.md:9-24` | 5 entries: README v0.1.0; marketplace v0.3.0; plugin.json v0.3.0; plugin README 0.3.0 changelog; results-template runner v0.1.0 hardcode; safety-rules `v1` reference; marketplace metadata.version 1.2.0 | **AUDIT-06** | AUDIT-07 (cosmetic) | `[STRUCTURAL]` (marketplace ↔ plugin sync) + `[COSMETIC]` (per-bullet) |
| References to skills/files that do not exist in the repo | `CONCERNS.md:28-48` | 4 categories: `platform-pipefy`/`platform-wrike` (4 refs); `/refine-<skill>` commands (3 refs); workspace `hub.md` (3 refs); client `.env.example` (1 ref) | **AUDIT-04** | AUDIT-01 (skills); MOD-2 PITFALL | `[STRUCTURAL]` |
| Truncated / cut-off content | `CONCERNS.md:52-55` | 1: `dydx-delivery/README.md:126` ends mid-sentence | **AUDIT-07** | — | `[COSMETIC]` (client-visible — README) |
| Pipeline stage numbering inconsistencies | `CONCERNS.md:59-76` | Two-scheme conflict (file-prefix `00_..04_` vs "Stage N" labels in 6 templates); two templates labeled "Stage 6"; no Stage 1 or Stage 4 anywhere | **AUDIT-01** brittleness per skill; **AUDIT-05** if treated as dup-content | DESIGN-02 (canonical scheme); MIN-5 PITFALL | `[STRUCTURAL]` |
| Naming inconsistency: "test plan" vs "test sheet" | `CONCERNS.md:80-84` | Root README:9 still says "test sheet" | **AUDIT-07** | AUDIT-06 (changelog truncated explains the rename) | `[COSMETIC]` |
| Pipeline-step count mismatch in root README | `CONCERNS.md:88-92` | Root README:9 says 5 steps; manifests say 7 skills | **AUDIT-07** | AUDIT-06 | `[COSMETIC]` |
| Empty / missing scaffold directories | `CONCERNS.md:96-105` | No `commands/` / `agents/` / `hooks/` directories | **AUDIT-04** (referenced-but-missing scaffold); cross-ref to **AUDIT-01** | DESIGN-04, DESIGN-05 (scaffold + refine) | `[STRUCTURAL]` |
| Cross-references between docs | `CONCERNS.md:109-117` | NEGATIVE FINDING — confirms intra-plugin refs other than the platform/`hub.md`/`.env.example` orphans all resolve | **AUDIT-04** (negative-finding subsection: "verified working refs") | — | `[STRUCTURAL]` (negative — clean) |
| Duplicated content across skills | `CONCERNS.md:121-150` | 4 categories: hard-rules block (4 copies — README + execute-tests SKILL + safety-rules.md canonical + test-plan-template); start-at-any-point block (6 SKILL.md copies); Cowork-vs-Claude-Code positioning (3 copies); pipeline diagram (2 copies). Note: CONCERNS.md says "three places" but enumerates 4 — one of them is the canonical so 4 mentions / 3 duplicates. | **AUDIT-05** | DESIGN-03 (single SoT); MOD-16 PITFALL | `[STRUCTURAL]` |
| TODO / FIXME / HACK / XXX markers | `CONCERNS.md:154-162` | NEGATIVE FINDING — no concern markers; `XXX` placeholders are template syntax | **AUDIT-01** appendix or AUDIT-07 negative-finding sentence | — | `[STRUCTURAL]` (negative — clean) |
| Frontmatter / template structural inconsistencies | `CONCERNS.md:166-187` | 3 sub-categories: status lifecycle vocabulary inconsistent across 7 templates (results has no `status:` at all); sandbox block carries `pipe_id`+`space_id` unconditionally regardless of `platform:`; `based_on_*` field-name underscore vs hyphen mismatch (e.g. `based_on_functional_spec` key vs `02_functional-spec` filename) | **AUDIT-01** brittleness per skill | DESIGN-01 (frontmatter scheme); CRIT-6 PITFALL | `[STRUCTURAL]` |
| Identifiers / contact details | `CONCERNS.md:191-199` | Owner-email = `jasonmichaelb@gmail.com` mismatches "dYdX Digital" stated org (manifests + README); homepage one-way (plugin.json has it, marketplace.json doesn't) | **AUDIT-07** (cosmetic email); **AUDIT-04** could note homepage-asymmetry | MIN-6 PITFALL | `[COSMETIC]` (email); `[STRUCTURAL]` (homepage asymmetry) |
| Build artefact path references in spec text | `CONCERNS.md:203-214` | 3 entries: `04_build-prompt_v1_report.md` (consistent); `04_build-prompt_v<N>_deviations.md` (template-only, not in SKILL or README); `04a/04b_build-prompt-config/code` siblings (SKILL only, not in README/template path) | **AUDIT-01** brittleness for `generate-build-prompt`; cross-ref **AUDIT-04** | DESIGN-12 (skill inventory) | `[STRUCTURAL]` |
| License field | `CONCERNS.md:218-222` | `plugin.json` declares `Proprietary`; no `LICENSE` / `LICENSE.md` file at root or plugin folder; marketplace.json has no `license` field | **AUDIT-07** | — | `[COSMETIC]` (client-visible — provenance) |
| Versioning convention vs current state | `CONCERNS.md:226-230` | Marketplace metadata.version `1.2.0` despite single commit + initial 0.3.0; semver convention documented in root README:81-83 | **AUDIT-06** | — | `[COSMETIC]` |

**Total CONCERNS.md sections:** 14. **All 14 routed.** Plus negative-finding sections (cross-references resolve clean; no concern markers) preserved as explicit "verified clean" callouts so reviewer doesn't read absence as gap.

## 3. Per-skill audit prep

For each of the 7 v0.3.0 skills below: SKILL.md frontmatter excerpt (drives matrix-row Inputs/Outputs/Triggers); brittleness findings cited with `file:line`; "what's missing for v2" pointers to DESIGN-* requirements (audit names the gap, does not propose the design move per D-13).

### 3.1 `discovery-intake`

- **SKILL.md frontmatter:** `name: discovery-intake`; `description:` lists triggers `"start discovery for X"`, `"capture intake"`, `"run discovery"`, `"client intake"`, `"kick off a new engagement"`. Source: `dydx-delivery/skills/discovery-intake/SKILL.md:1-4`.
- **Inputs:** Free-form context; optional existing discovery file (`dydx-delivery/skills/discovery-intake/SKILL.md:11-13`).
- **Output:** `<Client>/build-specs/<platform>/00_discovery_vN.md` (`SKILL.md:17`).
- **Frontmatter written:** `client / platform / integrations / version / status: draft / captured_by / captured_at` (`SKILL.md:97-107`).
- **Hand-off contract:** Hand-off message at `SKILL.md:114-122` ends with bold backticked `**generate-sow**`. No `based_on_*` (entry stage; consistent with CONVENTIONS.md table).
- **Observed brittleness (cite per finding):**
  - References missing workspace `hub.md` twice — `SKILL.md:27-28` ("match it against the workspace `hub.md` client index"; "see `hub.md`"). [STRUCTURAL] — see AUDIT-04.
  - Status lifecycle: writes `status: draft`. Skill body documents no follow-up status word; no `client_review` or `approved` mentioned for the discovery artefact (`SKILL.md:98-107` vs CONVENTIONS.md status taxonomy). [STRUCTURAL] — see AUDIT-01 frontmatter brittleness.
  - Template self-labels "Stage 0" (`intake-template.md:13`) but file-prefix is `00_` and ROADMAP/REQUIREMENTS canonical is "Stage 1 Kickoff" → "Stage 2 Discovery". Two-scheme conflict surfaces here. [STRUCTURAL].
- **What's missing for v2:** Kickoff input branch (Miro/notes/feedback ingest, dual-branch into discovery vs draft SOW); skip-this-stage behaviour when kickoff produced a draft SOW; consume `01_kickoff_v*` artefact instead of raw notes; `frontmatter_version` field. **Closed by:** DESIGN-17 (Stage 1 Kickoff capture skill); DESIGN-18 (Stage 2 Discovery refactor); DESIGN-01 (frontmatter scheme).

### 3.2 `generate-sow`

- **SKILL.md frontmatter:** `name: generate-sow`; triggers `"generate SOW"`, `"draft scope of work"`, `"create SOW for X"`, `"write the SOW"` (`generate-sow/SKILL.md:1-4`).
- **Inputs:** Latest `00_discovery_v*.md` (required); inline commercial framing (`SKILL.md:11-14`).
- **Output:** `<Client>/build-specs/<platform>/01_sow_vN.md` (`SKILL.md:17`).
- **Frontmatter written:** `... status: draft, based_on_discovery: 00_discovery_v{N}.md` (`SKILL.md:72-82`).
- **Hand-off contract:** Hand-off ends `**generate-functional-spec**`. **This is the only skill whose hand-off message names BOTH `client_review` AND `approved` status values** (`SKILL.md:93`: "Update `status:` to `client_review` when sent, `approved` when signed"). This is the canonical source for retaining `client_review` in v2 (per CRIT-6 PITFALL).
- **Observed brittleness:**
  - Start-at-any-point triage block at `SKILL.md:27-33` — first of 6 near-identical copies (see AUDIT-05). [STRUCTURAL].
  - Template self-label: `sow-template.md` carries no "Stage N" label (per CONCERNS.md:65). Sole template without a stage label. [STRUCTURAL].
- **What's missing for v2:** Stage 3 SOW must single-spec cover platform AND integration (today implicitly assumes single-platform); status lifecycle locked to canonical scheme; structurally otherwise unchanged. **Closed by:** DESIGN-19 (Stage 3 SOW refactor); DESIGN-01 (frontmatter scheme).

### 3.3 `generate-functional-spec`

- **SKILL.md frontmatter:** `name: generate-functional-spec`; triggers `"generate functional spec"`, `"draft functional specification"`, `"create the FRD"`, `"translate SOW to requirements"` (`generate-functional-spec/SKILL.md:1-4`).
- **Inputs:** Latest `01_sow_v*.md` (required); discovery for context (`SKILL.md:11-15`).
- **Output:** `<Client>/build-specs/<platform>/02_functional-spec_vN.md` (`SKILL.md:18`).
- **Frontmatter written:** `... status: draft, based_on_sow: 01_sow_v{N}.md` (`SKILL.md:74-83`).
- **Hand-off contract:** Hand-off ends `**generate-technical-spec**`; status `draft → approved` (no `client_review` mentioned despite `generate-sow` using it).
- **Observed brittleness:**
  - Start-at-any-point triage block at `SKILL.md:28-32` (2nd of 6 copies). [STRUCTURAL].
  - Template self-label "Stage 2" (`functional-spec-template.md:13`); file-prefix is `02_`. Coincidentally aligned but the alignment is accidental (test-plan-template self-labels "Stage 5" while file has no numeric prefix — see CONVENTIONS.md).
  - Status lifecycle: jumps directly `draft → approved`, no `client_review`. Inconsistent with `generate-sow`. [STRUCTURAL] — see CRIT-6 PITFALL.
- **What's missing for v2:** SPLIT into `generate-fnspec-platform` (4a) + `generate-fnspec-integration` (4b); per-requirement `delivery: native-ai | api` tagging (highest-leverage v2 feature); cross-spec consistency check; legacy single-fnspec retired. **Closed by:** DESIGN-20 (Stage 4 fnspec split).

### 3.4 `generate-technical-spec`

- **SKILL.md frontmatter:** `name: generate-technical-spec`; triggers `"generate technical spec"`, `"draft tech spec"`, `"create the technical design"`, `"map functional spec to Pipefy"`, `"map to Wrike"` (`generate-technical-spec/SKILL.md:1-4`).
- **Inputs:** Latest `02_functional-spec_v*.md` (required); reads `platform:` frontmatter to load matching platform skill (`SKILL.md:11-15`).
- **Output:** `<Client>/build-specs/<platform>/03_technical-spec_vN.md` (`SKILL.md:18`).
- **Frontmatter written:** `... based_on_functional_spec: 02_functional-spec_v{N}.md` — **note the underscore-vs-hyphen mismatch:** key `functional_spec` (underscore) vs filename `functional-spec` (hyphen). Source: `SKILL.md:99-108`. CONCERNS.md:184 calls this out.
- **Hand-off contract:** Hand-off ends `**generate-test-plan**`; status `draft → approved`.
- **Observed brittleness:**
  - References missing `platform-pipefy` / `platform-wrike` skills at `SKILL.md:38-39` ("`platform: pipefy` → load the `platform-pipefy` skill"; "`platform: wrike` → load the `platform-wrike` skill"). [BLOCKING] for the contract — see AUDIT-04.
  - Start-at-any-point triage block at `SKILL.md:28-32` (3rd of 6 copies). [STRUCTURAL].
  - Tier-claim text at `SKILL.md:90` mentions "Pipefy Business+, Wrike Pinnacle" without a `tier_claims_last_verified:` mechanism — see MOD-7 PITFALL.
- **What's missing for v2:** Scope-gate against fnspec-integration existence (Stage 5 only emitted when 4b exists); platform-API addendum on 4a when API-required portions exist on a platform-only build; explicit retries/idempotency/observability for API portions. **Closed by:** DESIGN-21 (Stage 5 Tech spec scope gate).

### 3.5 `generate-test-plan`

- **SKILL.md frontmatter:** `name: generate-test-plan`; triggers `"generate test plan"`, `"create test plan"`, `"draft test cases"`, `"build the QA plan"` (`generate-test-plan/SKILL.md:1-4`).
- **Inputs:** Latest `03_technical-spec_v*.md`; functional spec for AC reference; user-supplied `<feature>` name (`SKILL.md:11-16`).
- **Output:** `<Client>/testing/<feature>/test-plan_vN.md` (`SKILL.md:18`).
- **Frontmatter written:** `... status: draft, based_on_technical_spec: 03_technical-spec_v{N}.md, sandbox: { pipe_id, space_id, tenant }` — **note the unconditional `pipe_id`+`space_id` regardless of `platform:` value** (`SKILL.md:91-105`; `test-plan-template.md:9-13`). [STRUCTURAL].
- **Hand-off contract:** Hand-off ends `**generate-build-prompt**`; status `draft → approved`.
- **Observed brittleness:**
  - Start-at-any-point triage block at `SKILL.md:30-34` (4th of 6 copies). [STRUCTURAL].
  - Template self-label "Stage 5" (`test-plan-template.md:17`) yet file-prefix scheme has NO Stage 5 prefix (test-plan files are unprefixed `test-plan_v{N}.md`). Two-scheme conflict (CONCERNS.md:69, 76). [STRUCTURAL].
  - Hard-rules block duplicated inline at `test-plan-template.md:36-44` (one of the 4 copies — see AUDIT-05). Wording diverges from canonical `safety-rules.md`. [STRUCTURAL].
- **What's missing for v2:** Path moves to `<Client> Brain/test-bot/test_cases/`; same body unchanged (becomes Stage 8b); coexistence with new Stage 8a `provision-test-harness`. **Closed by:** DESIGN-24 (Stage 8 test bot architecture).

### 3.6 `generate-build-prompt`

- **SKILL.md frontmatter:** `name: generate-build-prompt`; triggers `"generate build prompt"`, `"create the Claude Code prompt"`, `"produce the build brief"`, `"draft the prompt for Claude Code"` (`generate-build-prompt/SKILL.md:1-4`).
- **Inputs:** Latest `03_technical-spec_v*.md` (required, must be `status: approved` for production); latest `test-plan_v*.md` if generated; functional spec + SOW for context (`SKILL.md:11-15`).
- **Output:** `<Client>/build-specs/<platform>/04_build-prompt_vN.md` (`SKILL.md:18`).
- **Frontmatter written:** `... status: draft, based_on_technical_spec, based_on_test_plan, build_components: [platform_config, custom_code]` (`SKILL.md:111-123`). **Status lifecycle ambiguous — no follow-up status documented.** [STRUCTURAL].
- **Hand-off contract:** Hand-off ends with switch-to-Claude-Code instructions (not a pointer to a next skill but to a tool transition); pointer to `references/when-to-open-claude-code.md` (`SKILL.md:131`).
- **Observed brittleness:**
  - References missing `platform-pipefy` / `platform-wrike` at `SKILL.md:47` ("Based on `platform:` frontmatter, load `platform-pipefy`, `platform-wrike`, etc."). [BLOCKING] for the contract — see AUDIT-04.
  - Start-at-any-point triage block at `SKILL.md:28-32` (5th of 6 copies). [STRUCTURAL].
  - Cowork-vs-Claude-Code positioning duplicated at `SKILL.md:8` ("Cowork is the strategy seat. Claude Code is the build seat.") and again at `SKILL.md:163-171` ("Iterating between Cowork and Claude Code"). 3rd of 3 copies — see AUDIT-05. [STRUCTURAL].
  - Sibling-prompt convention (`04a_build-prompt-config.md` / `04b_build-prompt-code.md`) mentioned only at `SKILL.md:43`; not reflected in the build-prompt template's output path nor in plugin README's file-shape diagram (`dydx-delivery/README.md:60-72`). Inconsistent surface. [STRUCTURAL]. CONCERNS.md:213.
  - `04_build-prompt_v<N>_deviations.md` referenced only in `build-prompt-template.md:129`; not in SKILL.md or README. [STRUCTURAL]. CONCERNS.md:210.
  - Build prompt's `references/when-to-open-claude-code.md:88` references missing client `.env.example`. [STRUCTURAL] — see AUDIT-04.
- **What's missing for v2:** Becomes Stage 7a (dev prompt, carry-forward); new Stage 7b implementation prompt for non-dev (per-platform shape: Pipefy = Behaviors instructions + KB upload list; Wrike = Copilot workflow narrative; Ziflow = checklist/criteria spec — NOT a universal template). Both consume `delivery: native-ai | api` tagging from Stage 4a. **Closed by:** DESIGN-23 (Stage 7 dual build prompts).

### 3.7 `execute-tests`

- **SKILL.md frontmatter:** `name: execute-tests`; triggers `"execute tests"`, `"run test plan"`, `"run regression"`, `"run the QA plan"` (`execute-tests/SKILL.md:1-4`).
- **Inputs:** Latest `test-plan_v*.md` (must be `status: approved`); sandbox credentials; matching platform skill (`SKILL.md:11-15`).
- **Output:** `<Client>/testing/<feature>/results-YYYY-MM-DD_vN.md` (`SKILL.md:18`).
- **Frontmatter written (results-template):** `... runner: dydx-delivery/execute-tests v0.1.0` — **runner version hardcoded as v0.1.0 even though plugin is at 0.3.0** (`results-template.md:9`). [STRUCTURAL]. CONCERNS.md:18. Note also: results-template has **no `status:` field** — divergent from every other artefact template. CONCERNS.md:175.
- **Hand-off contract:** Terminal stage; hand-off is a results summary (no next-skill pointer).
- **Observed brittleness:**
  - References missing `platform-pipefy` / `platform-wrike` at `execute-tests/SKILL.md:55` ("load the matching skill (`platform-pipefy`, `platform-wrike`, etc.)"). [BLOCKING] for the contract — see AUDIT-04.
  - Start-at-any-point triage block at `SKILL.md:40-44` (6th of 6 copies). [STRUCTURAL].
  - Hard-rules block duplicated **inline at `SKILL.md:21-31`** ("Hard rules — enforced regardless of test plan content") — one of 4 copies vs the canonical at `references/safety-rules.md`. Diverges from the canonical (canonical lists 10 numbered rules; SKILL inline lists 7 condensed). [STRUCTURAL] — see AUDIT-05.
  - Sandbox-allowlist schema uses `pipe_id`/`space_id`/`tenant` only — Coda doc IDs not covered (CRIT-5 PITFALL gap; v0.3.0 surface — predates Coda hard-dep but creates blast-radius for v2 test bot).
  - Concurrency rule references "`v1`" without a versioning anchor (`safety-rules.md:93`: "Parallel execution is not supported in v1"). CONCERNS.md:22. [STRUCTURAL].
  - Results-template self-labels "Stage 6" (`results-template.md:18`) — same Stage-6 label collision as `build-prompt-template.md:15`. Two distinct templates labeled "Stage 6". [STRUCTURAL]. CONCERNS.md:71.
- **What's missing for v2:** User-facing entry stays the `execute-tests` skill body; internally invokes a new test-bot agent (Stage 8d); sandbox-allowlist extends to Coda; `harness_drift` failure class added; test-case lifecycle states (`active | obsolete | quarantined`); `sandbox_lock.yaml` for human-vs-bot concurrency. **Closed by:** DESIGN-24 (Stage 8 test bot architecture).

## 4. MCP probe matrix

**Probed live this session via `claude mcp list` on 2026-05-09 (workspace state at probe time per D-07).** Outputs verbatim from probe:

```
claude.ai Miro:            https://mcp.miro.com                     — ✓ Connected
claude.ai Slack:           https://mcp.slack.com/mcp                — ! Needs authentication
claude.ai Coda:            https://coda.io/apis/mcp                 — ✓ Connected
claude.ai Google Drive:    https://drivemcp.googleapis.com/mcp/v1   — ✓ Connected
claude.ai Gmail:           https://gmailmcp.googleapis.com/mcp/v1   — ✓ Connected
claude.ai Google Calendar: https://calendarmcp.googleapis.com/mcp/v1 — ✓ Connected
plugin:context-mode (local) — ✓ Connected
```

### Wired and connected — the 5 canonical MCPs

| MCP | Server identity (per D-05) | Endpoint | Probe call (per D-04) | Probed status | Version pin |
|-----|----------------------------|----------|------------------------|----------------|-------------|
| **Coda** | `claude.ai Coda` | `https://coda.io/apis/mcp` | `listDocs` (read-only, returns user's accessible docs — cheapest endpoint per Coda API ref) | ✓ Connected at session start | Endpoint version = `apis/v1` (per Coda public API; not exposed in MCP capability response) |
| **Miro** | `claude.ai Miro` | `https://mcp.miro.com` | `listBoards` (read-only, returns user's boards) | ✓ Connected at session start | Endpoint pin not exposed; treat as "currently-served version" |
| **Google Drive** | `claude.ai Google Drive` | `https://drivemcp.googleapis.com/mcp/v1` | `searchFiles` with empty query (returns recent / accessible files) | ✓ Connected at session start | `mcp/v1` from URL path |
| **Gmail** | `claude.ai Gmail` | `https://gmailmcp.googleapis.com/mcp/v1` | `listLabels` (read-only, returns mailbox labels — cheapest read) | ✓ Connected at session start | `mcp/v1` from URL path |
| **Google Calendar** | `claude.ai Google Calendar` | `https://calendarmcp.googleapis.com/mcp/v1` | `listCalendars` (read-only, returns user's calendars) | ✓ Connected at session start | `mcp/v1` from URL path |

**Note for the planner:** the AUDIT-08 row-per-MCP table per D-05 also needs a "result (200 OK / error code / timeout)" column. The probe-call execution itself happens during Phase 1 plan execution — research only confirms each MCP is wired and which endpoint is the recommended cheap read. The plan's AUDIT-08 wave should call each endpoint once and record the response code.

### Wired but out-of-scope per D-06

| MCP | Status | Why out-of-scope |
|-----|--------|------------------|
| **Slack** | ! Needs authentication | Wired but unauthenticated. Slack is referenced in v0.3.0 only as a notification target inside generated artefacts (e.g. `#ops-alerts` in `technical-spec-template.md:119`); not a delivery-pipeline MCP. Record as "wired, unauthenticated — out of audit scope". |

### NOT wired — verification deferred per D-06

| Connector | Why not probed | Where it surfaces in v0.3.0 | Verification path |
|-----------|---------------|------------------------------|-------------------|
| **Pipefy API** (GraphQL) | No MCP for Pipefy in this workspace; sandbox-tenant credentials unavailable in design phase | `safety-rules.md:75`; `INTEGRATIONS.md` Pipefy section; `platform: pipefy` route in `discovery-intake/SKILL.md:86`, `generate-technical-spec/SKILL.md:38`, etc. | Recorded "verification deferred" per D-06. v2.1+ build phase per CHANGE-04. |
| **Wrike API** (REST) | Same — no MCP, no creds | `safety-rules.md:76`; `INTEGRATIONS.md` Wrike section; `platform: wrike` routes | "verification deferred" per D-06 |
| **Ziflow API** (REST) | Same | `technical-spec-template.md:113` (`POST /api/v2/projects`); `INTEGRATIONS.md` Ziflow section | "verification deferred" per D-06 |
| **Claude in Chrome** | Canonical product naming uncertain in 2026 | Referenced in PROJECT.md "Connectors expected to be wired"; not in repo skill files | Phase 4 OPEN-01 per REQUIREMENTS.md |

### Net-new finding [NEW]

**Slack MCP wired but unauthenticated** — not in CONCERNS.md (CONCERNS.md predates this session's MCP wiring state). [NEW] [STRUCTURAL]. Plan should note this in AUDIT-08 as a "wired but inactive" row, and flag whether v2 design intends to use Slack (e.g. for `#ops-alerts` notification-target patterns referenced in templates) — answer goes to Phase 4 OPEN-QUESTIONS, not this audit.

## 5. Referenced-but-missing artefacts

Each item below has exact `file:line` citations so AUDIT-04 has a complete citation roll-up (per D-14).

### 5.1 `platform-pipefy` and `platform-wrike` skills

Referenced as dynamic-load targets via `platform:` frontmatter; no `platform-pipefy/` or `platform-wrike/` directory exists under `dydx-delivery/skills/` (verified by directory listing).

| Reference | Citation | Context |
|-----------|----------|---------|
| Plugin README "Platform handling" section | `dydx-delivery/README.md:89` | "Downstream skills...read this and dynamically load the matching platform skill (`platform-pipefy` or `platform-wrike`)" |
| `generate-build-prompt` SKILL | `dydx-delivery/skills/generate-build-prompt/SKILL.md:47` | "Based on `platform:` frontmatter, load `platform-pipefy`, `platform-wrike`, etc." |
| `execute-tests` SKILL | `dydx-delivery/skills/execute-tests/SKILL.md:55` | "load the matching skill (`platform-pipefy`, `platform-wrike`, etc.)" |
| `generate-technical-spec` SKILL | `dydx-delivery/skills/generate-technical-spec/SKILL.md:38-39` | "`platform: pipefy` → load the `platform-pipefy` skill"; "`platform: wrike` → load the `platform-wrike` skill" |

**Severity:** [BLOCKING] — three downstream skills dispatch on `platform:` and depend on these skills loading. Today the contract is broken in-repo.

**v2 closes via:** DESIGN-14 (`platform-pipefy/`), DESIGN-15 (`platform-wrike/`), DESIGN-16 (`platform-ziflow/`).

### 5.2 `/refine-<skill>` slash commands

Referenced as a future surface; no `commands/` directory exists in the plugin and no `refine-*` skills exist (verified by directory listing).

| Reference | Citation | Context |
|-----------|----------|---------|
| Root README "How to publish" | `README.md:56` | Example commit message: `feat(dydx-delivery): add refine-<skill> counterparts` |
| Plugin README pipeline-loop step 5 | `dydx-delivery/README.md:51` | "Reviewer either edits in place...or runs `/refine-<skill>` to regenerate" |
| Plugin README versioning Option B | `dydx-delivery/README.md:85` | "Optional sibling `_review.md` for major iteration notes (used by `/refine-<skill>` if added later)" |

**Severity:** [STRUCTURAL] — orphan references; reader can't act on them.

**v2 closes via:** DESIGN-05 (`/refine-<skill>` resolution: build single parameterised command vs delete every orphan reference) → Phase 4 OPEN-06.

### 5.3 Workspace `hub.md`

Referenced as the workspace-level client index; not present in this repo (verified by directory listing).

| Reference | Citation | Context |
|-----------|----------|---------|
| Plugin README file-locations section | `dydx-delivery/README.md:57` | "Artefacts land in the standard client folder shape (see workspace `hub.md`)" |
| `discovery-intake` SKILL Step 1 | `dydx-delivery/skills/discovery-intake/SKILL.md:27-28` | "match it against the workspace `hub.md` client index" + "see `hub.md`" |

**Severity:** [STRUCTURAL] — orphan reference. The v2 design names a client-folder `00_HUB.md` (per DESIGN-09 / DESIGN-22 / DESIGN-25 etc.) which is a different artefact (per-client, not workspace-level). The `hub.md` reference is to a workspace-level index that does not exist.

**v2 closes via:** No single DESIGN-* requirement closes this directly; OPEN-04 (hub-link backfill rollout coordination) addresses the per-client `00_HUB.md`. The workspace-level `hub.md` reference is either orphaned-and-deleted or replaced by per-client `00_HUB.md`. Audit notes the gap; Phase 2/4 decides.

### 5.4 Client folder `.env.example`

Referenced as the canonical list of required env-var names per client; not present in this repo (verified by directory listing — repo has no `.env*` files at all).

| Reference | Citation | Context |
|-----------|----------|---------|
| `when-to-open-claude-code.md` setup-step 3 | `dydx-delivery/skills/generate-build-prompt/references/when-to-open-claude-code.md:88` | "Set up env vars for sandbox API access...see your client folder's `.env.example`" |
| `build-prompt-template.md` env-var section | `dydx-delivery/skills/generate-build-prompt/references/build-prompt-template.md:120` (per CONCERNS.md:48) | Per-client `.env.example` referenced as the source for required env-var names |

**Severity:** [STRUCTURAL] — orphan reference. Note: this is a *per-client* artefact, not a *plugin* artefact, so it being missing in *this* repo is correct; the gap is that v2 may need to specify a canonical client-folder `.env.example` shape (e.g. `<CLIENT>_CODA_TOKEN`, `PIPEFY_API_TOKEN` per CRIT-9).

**v2 closes via:** Adjacent to DESIGN-09 (directional-boundary contract); not a direct match. Likely Phase 4 OPEN-QUESTIONS (client-folder shape).

### 5.5 Missing scaffold directories

No `commands/`, `agents/`, `hooks/` directories exist in the plugin (verified by directory listing).

| Missing directory | Citation in CONCERNS.md | What v2 expects |
|-------------------|-------------------------|-----------------|
| `dydx-delivery/commands/` | `CONCERNS.md:99` | DESIGN-04 expects 1 parameterised `refine.md` + 4 GSD-prefixed shortcuts |
| `dydx-delivery/agents/` | `CONCERNS.md:100` | DESIGN-04 expects 1 (`test-bot-orchestrator`) |
| `dydx-delivery/hooks/` | `CONCERNS.md:101` | DESIGN-04 expects 2 (`validate-frontmatter`, `bump-artefact-version`); explicitly NOT auto-progression hooks |

**Severity:** [STRUCTURAL] — scaffold absence; v2 adds these surfaces. Per CONCERNS.md:104, plugin README "does not state which Claude Code plugin surfaces are intentionally not used" — gap is observation, not the absence itself.

**v2 closes via:** DESIGN-04 (plugin surfaces).

### 5.6 Negative findings (verified clean — not actually missing)

Per `CONCERNS.md:109-117`: cross-references between docs were checked. The following references DO resolve correctly and are NOT orphan:

- `dydx-delivery/README.md:95` → `skills/generate-build-prompt/references/when-to-open-claude-code.md` ✓
- `dydx-delivery/skills/execute-tests/SKILL.md:23` → `references/safety-rules.md` ✓
- `dydx-delivery/skills/generate-test-plan/SKILL.md:49` → `references/test-plan-template.md` ✓

Audit should keep this "verified clean" callout per the Honest-Reporting principle so reviewer doesn't read absence-of-mention as untested.

## 6. Duplicated content blocks

Per CONCERNS.md:121-150 plus this audit's own re-grep. Each row identifies the canonical source and the duplicate copies.

### 6.1 Hard-rules block (4 mentions; 3 duplicates of 1 canonical)

| Location | Lines | Role | Detail |
|----------|-------|------|--------|
| `dydx-delivery/skills/execute-tests/references/safety-rules.md` | full file (1-101) | **CANONICAL** | 10 numbered rules: sandbox enforcement, no deletions, no destructive integrations outside scope, read-write only, audit trail, rate limiting, stop conditions, concurrency, cleanup, reporting |
| `dydx-delivery/README.md:99-105` | 7 lines | DUPLICATE | "Test execution — safety rules (hard)" — 5 condensed bullets (sandbox only, no deletions, no destructive automations, read-write only, audit trail) |
| `dydx-delivery/skills/execute-tests/SKILL.md:21-31` | 11 lines | DUPLICATE | "Hard rules — enforced regardless of test plan content" — 7 numbered rules (condensed) |
| `dydx-delivery/skills/generate-test-plan/references/test-plan-template.md:36-44` | 9 lines | DUPLICATE | "Hard rules (enforced by `execute-tests`)" — 5 condensed bullets (matches plugin README condensed form) |

**Wording mismatch:** the 4 copies do not match exactly (canonical lists 10 rules; the others list 5–7 condensed). [STRUCTURAL]. **Canonical-source recommendation:** keep `execute-tests/references/safety-rules.md`; the other 3 surfaces inline a one-line summary plus pointer.

**v2 closes via:** DESIGN-03 (single SoT for hard rules at `dydx-delivery/references/safety-rules.md` — note the v2 path differs from v0.3.0; v2 elevates to plugin-level references); MOD-16 PITFALL.

### 6.2 Start-at-any-point triage block (6 SKILL.md copies)

Near-identical 3-option prompt ("(a) Paste / (b) Walk through inline / (c) Cancel"):

| Location | Lines |
|----------|-------|
| `dydx-delivery/skills/generate-sow/SKILL.md` | 27-33 |
| `dydx-delivery/skills/generate-functional-spec/SKILL.md` | 28-32 |
| `dydx-delivery/skills/generate-technical-spec/SKILL.md` | 28-32 |
| `dydx-delivery/skills/generate-test-plan/SKILL.md` | 30-34 |
| `dydx-delivery/skills/generate-build-prompt/SKILL.md` | 28-32 |
| `dydx-delivery/skills/execute-tests/SKILL.md` | 40-44 |

Per CONCERNS.md:142, "Each copy carries small wording variations." [STRUCTURAL].

**Canonical-source recommendation:** None today — needs a v2 canonical reference (e.g. plugin-level `references/start-at-any-point.md`). Audit observation only; v2 design moves go in DESIGN-* requirements.

**v2 closes via:** DESIGN-11 (plugin-level `references/` directory) implies a place; specific consolidation is part of v2.1 build phase per FOUND-02.

### 6.3 Cowork-vs-Claude-Code positioning (3 copies)

| Location | Lines | Role |
|----------|-------|------|
| `dydx-delivery/README.md` | 5, 9-29 | Pipeline-diagram framing + "Cowork is the strategy seat. Claude Code is the build seat." opening |
| `dydx-delivery/skills/generate-build-prompt/SKILL.md` | 8, 163-171 | One-liner at line 8; "Iterating between Cowork and Claude Code" section at 163-171 |
| `dydx-delivery/skills/generate-build-prompt/references/when-to-open-claude-code.md` | full file (1-89) | **DECISION-MATRIX CANONICAL** — but the framing one-liner is duplicated above |

**Canonical-source recommendation:** keep `when-to-open-claude-code.md` as the canonical decision matrix; the plugin README and `generate-build-prompt` SKILL.md inline a one-line summary plus pointer (consistent with hard-rules pattern).

**v2 closes via:** DESIGN-10 (persona contract) — likely subsumes the positioning text; specific consolidation is v2.1 build.

### 6.4 Pipeline diagram (2 copies)

| Location | Lines | Role |
|----------|-------|------|
| `dydx-delivery/README.md` | 9-29 | ASCII diagram + 7-skill table |
| `dydx-delivery/skills/generate-build-prompt/references/when-to-open-claude-code.md` | 18-40 | Similar ASCII diagram with tool-transition swimlanes |

**Canonical-source recommendation:** keep the plugin README diagram as the high-level overview; `when-to-open-claude-code.md` keeps its swimlane variant since it specifically illustrates tool transitions (not pure pipeline order). Two copies serve different purposes — could be argued they're not duplicates. Audit calls out as duplicated per CONCERNS.md classification but recommends both retained, with the swimlane variant marked as "tool-transition view" not "pipeline view".

**v2 closes via:** DESIGN-12 (skill inventory) implies a redrawn 13-skill diagram in plugin-level docs.

### 6.5 [NEW] Stage-N label conflict — 2 templates labeled "Stage 6"

Not catalogued as a "duplicate" in CONCERNS.md but functionally a duplicate-label collision:

| Template | Line | Self-label |
|----------|------|------------|
| `build-prompt-template.md` | 15 | "Stage 6 of the dydx-delivery pipeline" |
| `results-template.md` | 18 | "Stage 6 of the dydx-delivery pipeline" |

[NEW] [STRUCTURAL]. Already covered by CONCERNS.md:71 under Stage-numbering inconsistencies, but worth re-flagging in AUDIT-05 (duplicate content) since it's a literal label-string duplicate.

## 7. Version-string mismatches

Exhaustive table of every version-string location in v0.3.0 (per AUDIT-06; D-17 locks 2.0.0 as the synced target).

| # | Location | Citation | Current value | What it represents |
|---|----------|----------|---------------|---------------------|
| 1 | Plugin manifest | `dydx-delivery/.claude-plugin/plugin.json:3` | `"version": "0.3.0"` | Plugin semver |
| 2 | Marketplace plugin entry | `.claude-plugin/marketplace.json:16` | `"version": "0.3.0"` | Plugin entry version (must match #1) |
| 3 | Marketplace metadata version | `.claude-plugin/marketplace.json:9` | `"version": "1.2.0"` | Marketplace metadata version — SCOPE OF SYNC UNCLEAR (CONCERNS.md:24) |
| 4 | Root README plugin table | `README.md:9` | `0.1.0` | Documented plugin version — DRIFTED from #1 by 0.2.0 |
| 5 | Plugin README changelog | `dydx-delivery/README.md:126` | `**0.3.0** —` (changelog entry, truncated mid-sentence) | Plugin changelog — matches #1 but content truncated |
| 6 | Results-template runner field | `dydx-delivery/skills/execute-tests/references/results-template.md:9` | `runner: dydx-delivery/execute-tests v0.1.0` | Hardcoded runner version — DRIFTED from #1 by 0.2.0 (CONCERNS.md:18) |
| 7 | Safety-rules `v1` reference | `dydx-delivery/skills/execute-tests/references/safety-rules.md:93` | "Parallel execution is not supported in v1" | Unclear-scope `v1` — no companion versioning anchor (CONCERNS.md:22) |
| 8 | Root README versioning convention | `README.md:81-83` | (semver convention statement, no version) | Documents the convention — not a version mismatch but the source of the convention |

**Synced target per D-17:** all version-bearing locations move to `2.0.0`. Locations #4, #6 must be updated; #7 needs an anchor decision (delete the v1 phrase or replace with v2 anchor); #8 is the convention statement (no value change).

**Note for AUDIT-06 section narrative:** Locations #1, #2, #3, #4, #5, #6 are "version field that names a plugin/marketplace/runner version". Locations #7, #8 are different in kind (in-text reference; convention doc) but still version-related per CONCERNS.md scope.

## 8. Cosmetic-but-client-visible issues

Each item below is cited and tagged with the per-bullet "scheduled for v2.1 build, NOT this milestone" constraint per D-16.

### 8.1 README truncation (plugin-level)

- **Citation:** `dydx-delivery/README.md:126` — Changelog entry for `0.3.0` reads: *"The bot-run terminal stage (`execute-tests`) now c"* and the file terminates mid-sentence. No closing punctuation, no further entries.
- **Severity:** [COSMETIC] — client-visible (plugin README is the install-time README).
- **Fix:** Complete the truncated sentence in changelog entry. **Scheduled for v2.1 Foundations build (FOUND-07), NOT this milestone.**

### 8.2 Residual "test sheet" wording

- **Citation:** `README.md:9` — root marketplace README still says "discovery → SOW → functional spec → technical spec → **test sheet** → execution".
- **Context:** Plugin README changelog (`dydx-delivery/README.md:126`) records the 0.3.0 rename `generate-test-sheet` → `generate-test-plan`; root README never followed the rename.
- **Severity:** [COSMETIC] — client-visible (root marketplace README).
- **Fix:** Change "test sheet" to "test plan" at `README.md:9`. **Scheduled for v2.1 Foundations build (FOUND-07), NOT this milestone.**

### 8.3 Pipeline-step count mismatch (root README)

- **Citation:** `README.md:9` says 5 pipeline steps; `marketplace.json:15` and `plugin.json:4` describe **seven skills**; `dydx-delivery/README.md:33-41` lists seven.
- **Severity:** [COSMETIC] — client-visible (root README).
- **Fix:** Update `README.md:9` to reflect the 7-skill v0.3.0 pipeline (or v2's 13-skill pipeline post-rebuild). **Scheduled for v2.1 build, NOT this milestone.**

### 8.4 Missing LICENSE file

- **Citation:** `dydx-delivery/.claude-plugin/plugin.json:10` declares `"license": "Proprietary"`; no `LICENSE` or `LICENSE.md` file exists at repo root or plugin folder (verified by directory listing); `.claude-plugin/marketplace.json` has no `license` field.
- **Severity:** [COSMETIC] — client-visible (provenance gap; `Proprietary` declaration is unbacked).
- **Fix:** Add `LICENSE` file at repo root (or `dydx-delivery/LICENSE`) with proprietary licence terms; add matching `license` field to `marketplace.json`. **Scheduled for v2.1 Foundations build (FOUND-04), NOT this milestone.**

### 8.5 Owner-email mismatch with stated org

- **Citation:** `marketplace.json:5` (`owner.email`) and `plugin.json:7` (`author.email`) both list `jasonmichaelb@gmail.com`; README + marketplace metadata describe the team as "dYdX Digital" (e.g. `marketplace.json:4`, `plugin.json:4`); no `@dydx.digital` or org domain appears in the manifests.
- **Severity:** [COSMETIC] — client-visible (provenance — clients viewing the marketplace see a personal Gmail).
- **Fix:** Change to an org-domain address. **Scheduled for v2.1 Foundations build (FOUND-04), NOT this milestone.** Cross-ref: MIN-6 PITFALL.

### 8.6 Homepage asymmetry [NEW]

- **Citation:** `plugin.json:9` has `"homepage": "https://github.com/SonofJay13/dydx-project-workflow"`; `marketplace.json` has no `homepage` field. CONCERNS.md:197-199.
- **Severity:** [COSMETIC] — client-visible (marketplace listing). [NEW] tag because CONCERNS.md flagged it as "one-way" but didn't formally categorize it; fits AUDIT-07 as cosmetic-client-visible.
- **Fix:** Add matching `homepage` field to `marketplace.json`. **Scheduled for v2.1 Foundations build (FOUND-04), NOT this milestone.**

## 9. PITFALLS cross-ref index

Maps audit finding categories to relevant CRIT-/MOD-/MIN- pitfall IDs from `.planning/research/PITFALLS.md`. The audit cites pitfalls; it does not propose mitigations (mitigations belong to Phase 2 Design).

| AUDIT-* finding category | Pitfall IDs | Rationale |
|--------------------------|-------------|-----------|
| AUDIT-01: status-lifecycle inconsistencies (`generate-sow` uses `client_review`; others don't; results has no status) | **CRIT-6** | Frontmatter migration corruption risk if v2 drops `client_review` |
| AUDIT-01: sandbox block carries `pipe_id`+`space_id` unconditionally | **CRIT-5** (sandbox enforcement gap on Coda — v2 extension); CRIT-6 (frontmatter migration) | Platform-gating today is on platform-tenant IDs only |
| AUDIT-01: missing platform-pipefy/wrike contract | **MOD-4** (Pipefy GraphQL pagination), **MOD-5** (Wrike OAuth host), **MOD-6** (Ziflow consistency), **MOD-7** (tier-claim currency) | All four are "what v2 platform skills must address"; today the contract is broken so the gap-cause and gap-fix both surface |
| AUDIT-01: `generate-sow` mentions "Pipefy Business+, Wrike Pinnacle" without verification mechanism | **MOD-7** | Tier claims age fast |
| AUDIT-04: missing `platform-pipefy`/`platform-wrike` (4 references) | (no direct pitfall — gap itself); **MOD-2** for the surface pattern | These skills are referenced as a contract |
| AUDIT-04: `/refine-<skill>` orphan refs | **MOD-2** | Slash-command name collision risk on reintroduction |
| AUDIT-04: missing `commands/` / `agents/` / `hooks/` scaffold | **MOD-3** (hook risk — for the time when hooks land) | Hooks operate on parsed YAML, not raw markdown |
| AUDIT-05: hard-rules duplication across 4 files | **MOD-16** | Hard-rules duplicate-and-edit (single SoT collapses 4 copies) |
| AUDIT-05: Stage-N label collisions (two templates label "Stage 6") | **MIN-5** | Stage-numbering scheme orphans existing readers |
| AUDIT-06: version-string mismatches (5 locations) | (no direct pitfall — structural debt) | Cosmetic-but-blocking for marketplace install reliability |
| AUDIT-07: hardcoded runner version `v0.1.0` in results-template | **CRIT-6** (related — frontmatter migration); structural | Auto-rewriting historical results carries the runner version mismatch |
| AUDIT-07: owner-email mismatch | **MIN-6** | Email-vs-org provenance |
| AUDIT-07: README truncation, "test sheet" residual | (no direct pitfall — cosmetic) | Surfaced for v2.1 cleanup |
| AUDIT-08: live-MCP probe (Coda wired and connected) | **CRIT-1** (formula column overwrite), **CRIT-2** (async-202), **CRIT-3** (rate-limit), **CRIT-9** (token scope) | Coda is hard-dependency for v2 Stage 6/11; pitfalls cited so AUDIT-08 surfaces "the connector exists; using it correctly is gated by these CRIT-* items" |
| AUDIT-08: Slack MCP wired but unauthenticated [NEW] | (no pitfall — net-new finding) | Phase 4 OPEN |

## 10. DESIGN-* cross-ref index

Maps "what's missing for v2" callouts in AUDIT-01 per-skill subsections to the DESIGN-* requirement that closes each gap. Audit names the gap and points at the requirement; does not propose the design move (per D-13).

| AUDIT-01 skill | Gap (observation) | Closes via DESIGN-* |
|----------------|-------------------|---------------------|
| `discovery-intake` | No kickoff input branch; consumes raw notes; writes only `status: draft` (no client_review/approved follow-up); no `frontmatter_version` | **DESIGN-17** (Stage 1 Kickoff capture skill); **DESIGN-18** (Stage 2 Discovery refactor — consumes `01_kickoff_v*`); **DESIGN-01** (canonical frontmatter scheme) |
| `generate-sow` | Status lifecycle uses `client_review` but other skills don't; structurally otherwise fine | **DESIGN-19** (Stage 3 SOW refactor); **DESIGN-01** (frontmatter scheme — retains `client_review`) |
| `generate-functional-spec` | Single-fnspec-for-everything; no `delivery: native-ai\|api` tagging; status `draft → approved` (no client_review) | **DESIGN-20** (Stage 4 fnspec split — 4a + 4b with delivery tagging); **DESIGN-01** |
| `generate-technical-spec` | References missing platform skills; no scope-gate against integration existence; `based_on_functional_spec` underscore-vs-hyphen mismatch | **DESIGN-14/15/16** (platform skills); **DESIGN-21** (Stage 5 scope gate); **DESIGN-01** (file-path kebab-case vs key-name snake_case canonical) |
| `generate-test-plan` | Sandbox block carries `pipe_id`+`space_id` unconditionally; hard-rules block inlined in template; "Stage 5" label collision; needs to move to `<Client> Brain/test-bot/test_cases/` | **DESIGN-24** (Stage 8 test bot architecture — moves path); **DESIGN-01** (platform-gated identifiers); **DESIGN-02** (canonical stage numbering); **DESIGN-03** (single SoT for hard rules) |
| `generate-build-prompt` | References missing platform skills; status lifecycle has no follow-up; sibling-prompt convention `04a/04b` mentioned in SKILL only; deviations file referenced only in template | **DESIGN-23** (Stage 7 dual prompts — 7a dev + 7b implementation); **DESIGN-01** (frontmatter); **DESIGN-12** (skill inventory documents the artefact shape definitively) |
| `execute-tests` | Hardcoded runner v0.1.0; no `status:` field on results; sandbox-allowlist doesn't cover Coda; Stage-N "Stage 6" label collision; no `harness_drift` failure class; no test-case lifecycle states | **DESIGN-24** (Stage 8 test bot architecture — sandbox extension to Coda; harness_drift class; lifecycle states); **DESIGN-01** (status field); **DESIGN-02** (stage numbering); **DESIGN-04** (manifest version sync) |

**Cross-cutting gaps (not skill-specific):**

| Gap | DESIGN-* |
|-----|---------|
| No canonical frontmatter scheme | DESIGN-01 |
| Two-scheme stage numbering | DESIGN-02 |
| 4 hard-rules copies | DESIGN-03 |
| Missing `commands/agents/hooks` scaffold | DESIGN-04 |
| `/refine-<skill>` orphan refs | DESIGN-05 |
| No approval-gate enforcement | DESIGN-06 |
| No connector-availability probe | DESIGN-07 |
| No frontmatter migration co-existence rules | DESIGN-08 |
| No directional-boundary contract (local→Coda one-way) | DESIGN-09 |
| No persona contract | DESIGN-10 |
| Plugin folder layout doesn't include `references/` directory | DESIGN-11 |
| No 13-skill inventory | DESIGN-12 |
| No stage-by-stage hand-off contract | DESIGN-13 |

## Validation Architecture

**Phase mode:** design-only. Single deliverable: `.planning/AUDIT.md`. No code, no tests, no automated runners. Validation is **documentary** — verified by structural checks against the deliverable file plus reviewer attestation.

> Skip rationale: This phase has `nyquist_validation` implicitly enabled per `.planning/config.json` (key absent → enabled), but the project produces zero code/test artefacts in this phase. The validation strategy below is documentary, mapped to ROADMAP.md's 5 success criteria + REQUIREMENTS.md's 8 AUDIT-* IDs.

### Test Framework

| Property | Value |
|----------|-------|
| Framework | None (design-only phase — markdown deliverable validation only) |
| Config file | None |
| Quick run command | `grep -c "## AUDIT-0[1-8]:" .planning/AUDIT.md` (expects `8`); plus `grep -c "verified superset of" .planning/AUDIT.md` (expects `>= 1`) |
| Full suite command | Manual reviewer walk + AUDIT-* ID coverage check + Appendix B trace verification |

### Phase Requirements → Documentary Validation Map

| Req ID | Behavior | Validation type | Mechanism | File exists? |
|--------|----------|-----------------|-----------|--------------|
| AUDIT-01 | All 7 skills have matrix row + brittleness subsection | structural | grep for 7 H3 sub-headers under `## AUDIT-01:` | ❌ Wave 1 (drafting) |
| AUDIT-02 | All 14 CONCERNS.md sections mapped to AUDIT-* sections | trace | Appendix B trace table; manual cross-check | ❌ Wave 9 (Appendix B) |
| AUDIT-03 | Per-stage connector dependency table exists; required-vs-graceful-degradation labels present | structural | grep for table heading + dependency-matrix table | ❌ Wave 3 |
| AUDIT-04 | All referenced-but-missing artefacts cited with `file:line` | citation | grep for citation patterns; spot-check 3 random citations resolve | ❌ Wave 4 |
| AUDIT-05 | Duplicated-content blocks listed with canonical-source recommendation per duplicate | structural | grep for "Canonical-source recommendation" subheaders (4 categories minimum) | ❌ Wave 5 |
| AUDIT-06 | Version-string table; recommends 2.0.0 synced target | structural | grep for "2.0.0" + version-mismatch table; verify 6+ rows | ❌ Wave 6 |
| AUDIT-07 | Cosmetic items each carry "scheduled for v2.1 build, NOT this milestone" | structural | grep for the constraint phrase per cosmetic bullet | ❌ Wave 7 |
| AUDIT-08 | MCP probe table with status / server identity / version pin / probe call / result for 5 wired MCPs | data | Run `claude mcp list` during AUDIT-08 wave; populate table; verify 5 row entries | ❌ Wave 8 |

### Wave 0 Gaps (verifications BEFORE drafting begins)

- [ ] `.planning/codebase/CONCERNS.md` exists and is the 2026-05-09 dated version (verify header date)
- [ ] `.planning/codebase/{STRUCTURE,ARCHITECTURE,CONVENTIONS,INTEGRATIONS,STACK,TESTING}.md` all present (input absorption)
- [ ] `.planning/research/{SUMMARY,PITFALLS,ARCHITECTURE,FEATURES,STACK}.md` all present (cross-ref source)
- [ ] All 7 skill folders present at `dydx-delivery/skills/` with `SKILL.md` + `references/` (verify before per-skill subsection drafting)
- [ ] `claude mcp list` succeeds before AUDIT-08 wave (re-run inside the plan; this research probed once, but the audit re-probes per D-04/D-05)

### Sampling Rate

- **Per task commit:** None (no code; per-wave commits include drafted markdown only)
- **Per wave merge:** Re-run `grep -c "## AUDIT-0[1-8]:" .planning/AUDIT.md` after each wave to confirm section count grows monotonically
- **Phase gate (before `/gsd-verify-work`):** All 8 AUDIT-* IDs accounted for; Appendix B trace populated; preamble + executive summary present; reviewer manual walk confirms reads cleanly + every cited `file:line` resolves

### Documentary Validation Checklist (final wave)

The 5 success-criteria from ROADMAP §Phase 1 map to specific structural checks:

| Success criterion | Check |
|-------------------|-------|
| 1. AUDIT.md catalogues all 7 skills with full per-skill structure | 7 H3 subsections under AUDIT-01; each has Hand-off contract / Observed brittleness / What's missing for v2 |
| 2. Verified superset of CONCERNS.md (no entry dropped silently) | Appendix B trace table maps all 14 CONCERNS.md sections; auditor confirms in document |
| 3. Per-stage connector dependency table + live-MCP-wiring probe table | 2 tables present in AUDIT-03 / AUDIT-08 |
| 4. Referenced-but-missing artefacts + duplicated content blocks both catalogued with citations + canonical-source recommendations | AUDIT-04 + AUDIT-05 each have citation lists + recommendation columns |
| 5. Version-string mismatches + cosmetic issues; v2.1 scheduling on cosmetic items | AUDIT-06 table + AUDIT-07 list with per-bullet "scheduled for v2.1 build, NOT this milestone" |

## 12. Open Questions

Items the planner needs the user to disambiguate (or formally defer to Phase 4 OPEN-QUESTIONS) before writing PLAN.md.

1. **Where do MCP probe call results get recorded?** Research confirmed all 5 MCPs `Connected` via `claude mcp list`, but the actual probe-call results (e.g. Coda `listDocs` returning N docs) require executing each MCP's read endpoint during the AUDIT-08 wave. Should the plan include a Wave 8 task that calls each endpoint and records the response, or is `claude mcp list` Connected-status alone sufficient for D-05's "result" column? **Recommended planner assumption:** include one cheap-read call per MCP in Wave 8 so the table has both connectivity (`Connected`) and a positive endpoint response (e.g. `listDocs → 200 OK, N docs returned`). Defer to user if disagreement.

2. **Slack MCP treatment.** Slack is wired-but-unauthenticated in this workspace. CONTEXT.md D-04 lists 5 MCPs to probe (Coda, Miro, Drive, Gmail, Calendar) — Slack is not in that list. Audit's options: (a) include Slack as a [NEW] row in AUDIT-08 with status "wired, unauthenticated, out-of-scope"; (b) omit Slack entirely from AUDIT-08; (c) flag Slack to Phase 4 OPEN-QUESTIONS. **Recommended planner assumption:** option (a) — record once with the [NEW] tag, no further investigation. Defer to user if disagreement.

3. **Workspace `hub.md` resolution.** AUDIT-04 §5.3 finds `hub.md` referenced but missing. The v2 design names a per-client `00_HUB.md` (different artefact, lives inside client folders, not the workspace). It's unclear whether the v0.3.0 `hub.md` references are intended to be re-pointed at per-client `00_HUB.md` (different file, different scope) or deleted as orphan workspace-level refs. Audit can only inventory the gap; resolution is deferred. **Recommended planner assumption:** AUDIT.md notes the gap and points at "no single DESIGN-* requirement; resolution sits in Phase 4 OPEN-QUESTIONS". Defer to user if a different categorization is preferred.

4. **AUDIT-03 graceful-degradation labels.** AUDIT-03 requires marking each connector "*required* vs *graceful-degradation* per stage". The graceful-degradation matrix is fully designed in `.planning/research/PITFALLS.md` "Connector-availability fallback matrix" (Coda → Stage 5/10 manual mode; Drive → Stage 9 halt; etc.). However, that table belongs to DESIGN-07 (Phase 2 design) per CONTEXT.md deferred-ideas. Audit's options: (a) reproduce PITFALLS' fallback table verbatim in AUDIT-03 marked "research-derived; v2 design contract is DESIGN-07"; (b) cite the table by reference and only inventory which stage uses which connector (without degradation label); (c) include both stage-by-connector inventory AND PITFALLS' fallback table as two separate sub-tables. **Recommended planner assumption:** option (c) — observation-only inventory plus a research-cited fallback hint, with the explicit "v2 design contract = DESIGN-07" pointer per D-13. Defer to user if disagreement.

5. **AUDIT.md output location confirmation.** CONTEXT.md `<code_context>` says AUDIT.md sits at `.planning/AUDIT.md` (NOT under `.planning/phases/01-audit/`). Plan must commit BOTH the GSD plan-of-work file (`.planning/phases/01-audit/01-PLAN.md`) AND the deliverable (`.planning/AUDIT.md`). **Recommended planner assumption:** Write deliverable to `.planning/AUDIT.md`; commit happens in same git commit as the plan completion. Already locked by CONTEXT.md — flagged here only because it's an unusual path for a phase deliverable and worth confirming with the user during plan-walkthrough.

6. **CONCERNS.md "three places" wording for hard-rules duplication.** CONCERNS.md:123 says "Hard-rules block duplicated three places" but enumerates four (canonical + 3 duplicates). The audit's framing should resolve this — is it "3 duplicates of 1 canonical" or "4 copies, 1 of which is canonical"? **Recommended planner assumption:** "4 mentions; 3 are duplicates of 1 canonical" (per §6.1 above). Treat CONCERNS.md's "three places" as imprecise wording corrected by the audit. No user input needed if the planner accepts this resolution.

## Architectural Responsibility Map

This is a markdown-only documentary deliverable. The "tier" mapping below is therefore non-runtime; capabilities map to authoring/review responsibilities, not server tiers.

| Capability | Primary Tier | Secondary Tier | Rationale |
|------------|-------------|----------------|-----------|
| AUDIT.md drafting | Authoring (markdown) | — | Single self-contained `.md` file; no runtime |
| Citation resolution (`file:line`) | Authoring + Review | — | Author writes citations; reviewer verifies they resolve |
| MCP probe execution | Tool-invocation (Bash) | Authoring | `claude mcp list` + per-MCP read calls run live; results captured into the markdown table |
| CONCERNS.md absorption | Authoring | Review | Author rewrites entries; reviewer verifies Appendix B trace is exhaustive |
| Severity tagging (`[BLOCKING]`/`[STRUCTURAL]`/`[COSMETIC]`) | Authoring | — | Per-finding inline tag |
| DESIGN-* + PITFALLS cross-refs | Authoring | — | Read from REQUIREMENTS.md and PITFALLS.md; cite by ID; do not propose mitigations |

## Project Constraints (from CLAUDE.md)

No `./CLAUDE.md` file at repository root (verified by directory listing). Constraints inherited from PROJECT.md, REQUIREMENTS.md, and CONTEXT.md only:

- **No skill-file edits this milestone.** Audit reads `dydx-delivery/skills/**` but does not modify a single byte under that path. Plan must not include any task that writes/edits files under `dydx-delivery/`.
- **Markdown-only deliverable.** No code, no JSON edits, no manifest bumps in this phase. Manifest bumps to `2.0.0` are scheduled for v2.1 Foundations (FOUND-04), inventoried by AUDIT-06 — but not executed by this audit phase.
- **Sequential approval gate.** Phase 1 deliverable (`.planning/AUDIT.md`) requires human approval before Phase 2 begins.
- **Self-contained reader experience.** AUDIT.md must be readable without consulting v0.3.0 source files. Citations are for navigation, not for understanding.
- **`file:line` citation format with backtick wrapping** per D-14.

## Assumptions Log

| # | Claim | Section | Risk if wrong |
|---|-------|---------|---------------|
| A1 | Coda MCP `listDocs` is the cheapest read endpoint and is the right probe call | §4 MCP probe matrix | Wrong endpoint costs more credits or returns 404; mitigated by `claude mcp list` confirming connectivity even before per-MCP probe |
| A2 | `dydx-delivery/skills/execute-tests/references/safety-rules.md` is the canonical hard-rules source (not e.g. CONCERNS.md treating one of the duplicates as canonical) | §6.1 | Mis-identification leads to wrong canonical-source recommendation; mitigated by content review (canonical lists 10 rules; duplicates list 5–7) |
| A3 | Status `archived` is a v2 addition only (not present in v0.3.0); v2 retains `draft → client_review → approved` | §3.1, 3.2 (status-lifecycle observations) | If v0.3.0 already uses `archived` somewhere, audit observation needs broadening; mitigated by re-grep — no `status: archived` found in v0.3.0 surfaces |
| A4 | Slack MCP unauthenticated state is incidental, not a project decision (i.e. team intends to wire it eventually) | §4 [NEW] finding | Audit recommendation could be wrong if Slack is intentionally inactive; mitigated by recording observation as [NEW] and deferring to Phase 4 |
| A5 | "Stage 5" template self-label in `test-plan-template.md:17` is the v0.3.0 author's intent, not a typo | §3.5 | If a typo, audit double-counts; mitigated by CONCERNS.md:69 already classifying the same Stage-numbering inconsistency |

All A1-A5 are LOW-risk assumptions; none gate any DESIGN-* requirement. No user confirmation needed before plan execution.

## Sources

### Primary (HIGH confidence — direct file reads, this session)

- `.planning/phases/01-audit/01-CONTEXT.md` — D-01..D-17 + canonical refs + specifics + deferred ideas
- `.planning/REQUIREMENTS.md` — AUDIT-01..08 + DESIGN-01..30 + CHANGE-01..05 + OPEN-01..07 + traceability
- `.planning/STATE.md` — milestone progress
- `.planning/ROADMAP.md` — phase 1 success criteria
- `.planning/PROJECT.md` — milestone framing, constraints, key decisions
- `.planning/codebase/CONCERNS.md` — 14 sections of v0.3.0 audit findings (the input the audit absorbs)
- `.planning/codebase/{STRUCTURE,ARCHITECTURE,CONVENTIONS,INTEGRATIONS,STACK,TESTING}.md` — v0.3.0 baseline maps
- `.planning/research/{SUMMARY,PITFALLS,ARCHITECTURE,FEATURES,STACK}.md` — research context
- `dydx-delivery/.claude-plugin/plugin.json` — plugin manifest (v0.3.0; `Proprietary` license)
- `.claude-plugin/marketplace.json` — marketplace manifest (metadata.version 1.2.0; plugin entry 0.3.0)
- `README.md` (root) + `dydx-delivery/README.md` (plugin) — both READMEs read in full
- All 7 v0.3.0 SKILL.md files + their `references/` files — read in full
- Live `claude mcp list` output (this session, 2026-05-09) — confirms 5 wired MCPs Connected; Slack wired but unauthenticated

### Tooling (verification this session)

- `wc -l` confirms file line counts match CONCERNS.md citations
- `grep "test sheet"` confirms exact location of residual wording (`README.md:9` only — not propagated to other surfaces)
- `grep "Stage [0-9]"` in template files confirms 6 Stage-N labels with collisions at "Stage 6"
- Directory listings confirm absence of `commands/`, `agents/`, `hooks/`, `LICENSE`, `LICENSE.md`, `.mcp.json`, `.env*`

### Confidence breakdown

| Area | Level | Reason |
|------|-------|--------|
| CONCERNS.md absorption map | HIGH | Direct read of CONCERNS.md plus this session's grep verification |
| Per-skill audit prep | HIGH | All 7 SKILL.md files read in full; line citations verified |
| MCP probe matrix | HIGH | `claude mcp list` ran live this session; 5/5 canonical MCPs Connected |
| Referenced-but-missing artefacts | HIGH | Directory listings confirm absences; line citations confirm references |
| Duplicated content blocks | HIGH | CONCERNS.md citations cross-checked; line ranges verified |
| Version-string mismatches | HIGH | All 8 locations cited with file:line |
| Cosmetic issues | HIGH | Each item has direct citation |
| PITFALLS / DESIGN-* cross-refs | MEDIUM-HIGH | Mappings derived from reading PITFALLS.md + REQUIREMENTS.md fully; mappings are recommendations not externally verified contracts |

## Metadata

**Research date:** 2026-05-09
**Valid until:** 2026-06-08 (30 days for stable design-only domain — extends if MCP wiring changes; re-probe required if used after that date).

## RESEARCH COMPLETE
