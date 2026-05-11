# Phase 1: Audit - Context

**Gathered:** 2026-05-09
**Status:** Ready for planning

<domain>
## Phase Boundary

Produce a single self-contained markdown document at `.planning/AUDIT.md` that catalogues v0.3.0 plugin reality so v2 design rests on observation, not memory. The document covers: per-skill inventory of all 7 v0.3.0 skills; per-stage connector dependency table plus live-MCP-wiring probe matrix; referenced-but-missing artefacts; duplicated content blocks; version-string mismatches across manifests and docs; cosmetic-but-client-visible issues. Self-contained means a reader can use it without consulting v0.3.0 source files. Verified superset of `.planning/codebase/CONCERNS.md` (no entry dropped silently).

This is a **design-only** phase — AUDIT.md describes reality, schedules cosmetic fixes for v2.1 build, and never edits skill files in this milestone.

</domain>

<decisions>
## Implementation Decisions

### Document structure (top-level)
- **D-01:** AUDIT.md is organized by AUDIT-* requirement — one major section per AUDIT-01 through AUDIT-08. Reviewer can verify the 5 success-criteria 1:1 against the doc. Where a finding spans two requirements (e.g. version mismatch is both AUDIT-06 and AUDIT-07), the finding lives in its primary requirement's section and is cross-referenced from the other.
- **D-02:** Section headers use the format `## AUDIT-0N: <Name>` (e.g., `## AUDIT-01: Per-Skill Inventory`).
- **D-03:** Document opens with a "How to read this audit" preamble (one paragraph) plus a one-table executive summary (one row per AUDIT-* req with status / count of findings / link to section).

### MCP probe methodology (AUDIT-08)
- **D-04:** For each MCP currently wired in this workspace (Coda, Miro, Google Workspace, Gmail, Calendar), the probe calls one cheap read-only endpoint and records the outcome. Recommended probe calls:
  - Coda → `listDocs` or `listPages` against any accessible doc.
  - Miro → `listBoards` or read a known board.
  - Google Drive (Workspace) → `searchFiles` with empty query.
  - Gmail → `listLabels`.
  - Calendar → `listCalendars`.
- **D-05:** For each MCP probed, AUDIT.md records: `status` (working / broken / missing), `server identity` (e.g. `mcp__plugin_claude_ai_Coda__*`), `version pin` if available, the exact probe call, the result (200 OK / error code / timeout). One-row-per-MCP table.
- **D-06:** Out-of-scope for this probe (recorded only by name + "verification deferred"): Pipefy / Wrike / Ziflow platform APIs (no MCP for these in this workspace; sandbox-tenant credentials not available in design phase) and Claude in Chrome (canonical product naming → Phase 4 OPEN-QUESTIONS, per REQUIREMENTS.md OPEN-01).
- **D-07:** Workspace state at probe time: Miro MCP and Coda MCP newly connected this session; both expected `working`. Other MCPs probed empirically.

### CONCERNS.md absorption (AUDIT-02)
- **D-08:** Every CONCERNS.md entry is rewritten into the relevant AUDIT-* section (paraphrased or verbatim, with the original `file:line` citation preserved). AUDIT.md is the new canonical surface; CONCERNS.md becomes "historical input — superseded by AUDIT.md".
- **D-09:** AUDIT.md ends with `## Appendix B: CONCERNS.md → AUDIT.md trace` — a table mapping each CONCERNS.md section to the AUDIT-* section that absorbed it, with a column confirming "all N entries absorbed" or naming the entries that didn't fit anywhere (forces auditor to face dropped entries before signing off).
- **D-10:** Net-new findings discovered during the audit pass (beyond what's in CONCERNS.md) get an explicit `[NEW]` tag in their bullet so the appendix mapping is honest about what's superset vs. what's import.

### Per-skill audit shape (AUDIT-01)
- **D-11:** AUDIT-01 section opens with a scannable matrix (one row per skill × 7 skills). Columns: `Skill | Purpose (1 line) | Inputs | Outputs | Downstream consumer | Deps | Status flag(s)`. Inputs/Outputs use exact filename conventions (`00_discovery_v{N}.md`, etc.).
- **D-12:** Following the matrix, one focused subsection per skill carries the prose-heavy fields:
  - **Hand-off contract:** carrier file path, frontmatter fields propagated, gating status flag.
  - **Observed brittleness:** specific issues found (status lifecycle gaps, duplication of "start-at-any-point" block, frontmatter inconsistencies — pulled from CONCERNS.md + new findings).
  - **What's missing for v2:** gap analysis pointing at the v2 design intent (e.g., discovery-intake → "needs kickoff input branch, frontmatter_version field").
- **D-13:** "What's missing for v2" stays observation-led: name the gap, point at the relevant DESIGN-* requirement in REQUIREMENTS.md, but do NOT propose v2 design moves. The audit describes what's missing; Phase 2 (Design) decides what fills the gap.

### Cross-cutting authoring decisions
- **D-14:** Citations use `file:line` format with backtick wrapping (`` `dydx-delivery/README.md:9` ``) so reviewers can navigate. Multi-line ranges use `file:start-end`.
- **D-15:** Findings use `[BLOCKING] / [STRUCTURAL] / [COSMETIC]` severity tags inline so reviewers can triage at a glance, even though sections are organized by AUDIT-* requirement (not severity).
- **D-16:** AUDIT-07 cosmetic-fix list explicitly states each cosmetic issue is **scheduled for v2.1 build, NOT this milestone** — phrasing carried per-bullet, not just at the section header, so a reader can't lift a single bullet without the constraint.
- **D-17:** AUDIT-06 recommends `2.0.0` as the synced target version (per REQUIREMENTS.md AUDIT-06).

### Claude's Discretion
- Internal ordering within each AUDIT-* section (chronological in-file vs grouped by file vs by severity within the section) — Claude picks per section based on what reads cleanest.
- Exact wording and length per skill subsection — match the depth the underlying material justifies, no padding.
- Whether to include code/text excerpts inline or only cite — default to citation; quote only when wording itself is the finding (e.g., truncated changelog sentence; "test sheet" residual wording).

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase scope and requirements
- `.planning/ROADMAP.md` §"Phase 1: Audit" — phase boundary, success criteria 1–5, approval gate
- `.planning/REQUIREMENTS.md` §"Audit (AUDIT.md)" — AUDIT-01 through AUDIT-08 with detailed sub-bullets
- `.planning/PROJECT.md` — milestone framing, runtime constraints, out-of-scope list, kickoff mandate ("no skill edits in design milestone")
- `.planning/STATE.md` — current position, milestone progress

### Inputs to absorb (the audit is a superset of these)
- `.planning/codebase/CONCERNS.md` — version mismatches, missing references, truncated content, stage-numbering inconsistencies, "test sheet" residual, duplicated hard-rules block, frontmatter inconsistencies, license gap (MUST be fully absorbed into AUDIT.md)
- `.planning/codebase/STRUCTURE.md` — directory layout, skill folder conventions, template/reference layout, frontmatter field names, status values
- `.planning/codebase/ARCHITECTURE.md` — pipeline overview, stage transitions, artefact-driven flow
- `.planning/codebase/CONVENTIONS.md` — naming conventions, status lifecycle vocabulary
- `.planning/codebase/INTEGRATIONS.md` — connector inventory and current wiring assumptions
- `.planning/codebase/STACK.md` — language/format constraints
- `.planning/codebase/TESTING.md` — current `execute-tests` testing reality

### Research context (informs what "missing for v2" means)
- `.planning/research/SUMMARY.md` — 9-phase build plan that AUDIT.md anchors to
- `.planning/research/PITFALLS.md` — CRIT-/MOD-/MIN- pitfall IDs cited in cosmetic-fix scheduling and brittleness commentary
- `.planning/research/ARCHITECTURE.md` — v2 architecture intent
- `.planning/research/FEATURES.md` — v2 feature inventory
- `.planning/research/STACK.md` — research-derived stack decisions

### v0.3.0 source surfaces being audited
- `dydx-delivery/.claude-plugin/plugin.json` — plugin manifest (version, author, license, keywords)
- `.claude-plugin/marketplace.json` — marketplace manifest (metadata.version, plugins[])
- `README.md` (root) — marketplace overview, install/publish instructions, version conventions
- `dydx-delivery/README.md` — plugin pipeline diagram, skill table, file conventions, changelog
- `dydx-delivery/skills/discovery-intake/SKILL.md` + `references/intake-template.md`
- `dydx-delivery/skills/generate-sow/SKILL.md` + `references/sow-template.md`
- `dydx-delivery/skills/generate-functional-spec/SKILL.md` + `references/functional-spec-template.md`
- `dydx-delivery/skills/generate-technical-spec/SKILL.md` + `references/technical-spec-template.md`
- `dydx-delivery/skills/generate-test-plan/SKILL.md` + `references/test-plan-template.md`
- `dydx-delivery/skills/generate-build-prompt/SKILL.md` + `references/build-prompt-template.md` + `references/when-to-open-claude-code.md`
- `dydx-delivery/skills/execute-tests/SKILL.md` + `references/results-template.md` + `references/safety-rules.md`

### Output deliverable (what this phase produces)
- `.planning/AUDIT.md` — single self-contained audit document (does not exist yet; created by this phase's plan)

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `.planning/codebase/CONCERNS.md` (audit dated 2026-05-09): full inventory of version-string mismatches, missing skills, truncated content, stage-numbering inconsistencies, "test sheet" residual, duplicated hard-rules block (4 copies), duplicated start-at-any-point block (6 copies), Cowork-vs-Claude-Code positioning duplication (3 copies), pipeline diagram duplication (2 copies), missing scaffold dirs (`commands/`, `agents/`, `hooks/`), frontmatter inconsistencies, owner-email mismatch, missing LICENSE. AUDIT.md absorbs every entry.
- `.planning/codebase/STRUCTURE.md`: authoritative directory map and naming conventions — used to populate AUDIT-01 matrix columns (skill paths, template paths, output filename patterns).
- 7 v0.3.0 skill folders under `dydx-delivery/skills/` — each is its own audit unit (one matrix row + one prose subsection).
- `dydx-delivery/skills/execute-tests/references/safety-rules.md` is the canonical hard-rules document; the other three duplicate copies are findings, not sources.

### Established Patterns
- **Skill folder shape:** `<skill>/SKILL.md` + `<skill>/references/*-template.md`. Audit reuses this shape to inventory each skill.
- **Stage-prefixed artefact filenames:** `00_..04_*` (file prefix scheme) coexisting with "Stage N" labels in templates (label scheme). The two schemes diverge today — finding documented in AUDIT-01 brittleness.
- **Frontmatter field convention:** snake_case keys, kebab-case file paths in `based_on_*` values. Inconsistencies are themselves findings.
- **`status:` lifecycle vocabulary:** `draft → client_review → approved` is referenced but not uniformly enforced — finding documented per-skill.

### Integration Points
- AUDIT.md sits at `.planning/AUDIT.md` (not under `.planning/phases/01-audit/`) per ROADMAP.md "Output deliverable" — the deliverable lives at `.planning/` so Phase 2 (Design), Phase 3 (Change list), Phase 4 (Open questions) can reference it without cross-phase pathing.
- Phase 1 plan must commit BOTH `.planning/phases/01-audit/01-PLAN.md` (the GSD plan-of-work) AND `.planning/AUDIT.md` (the deliverable). The two files have distinct purposes — plan is process, AUDIT is product.
- AUDIT-08 MCP probe runs against THIS Claude Code workspace (live MCPs from the running session, not a hypothetical reference workspace).

</code_context>

<specifics>
## Specific Ideas

- Reviewer experience: AUDIT.md should support both "read in order" (preamble → executive summary → AUDIT-01..08 → appendices) AND "skip to a specific finding" (executive summary table acts as a TOC; severity tags `[BLOCKING] / [STRUCTURAL] / [COSMETIC]` enable visual scan).
- "What's missing for v2" framing per skill should resemble: "Skill X today does Y; v2 needs Z (per DESIGN-NN); the gap is W". Stays factual and points at the requirement that closes it — does not propose the design move.
- Cosmetic-fix list (AUDIT-07) is the most likely place for misuse: someone in v2.1 might lift a bullet without the "scheduled for v2.1 build, NOT this milestone" constraint. Carry the constraint per-bullet, not just at the section header.
- Live-MCP probe results are timestamped (the probe is a snapshot — re-probing later may differ). Record probe timestamp at the top of the AUDIT-08 table.

</specifics>

<deferred>
## Deferred Ideas

- **Per-stage connector graceful-degradation matrix as a contract** — AUDIT-03 inventories *what each stage needs*; the actual graceful-degradation behaviour rules (Stage 6 → manual mode if Coda missing; Stage 9 → halt if Drive missing; etc.) are DESIGN-07's territory in Phase 2.
- **Status-lifecycle survey of live client folders** (to confirm no in-flight `status:` value gets orphaned during cutover) — captured for Phase 4 OPEN-QUESTIONS register per REQUIREMENTS.md OPEN-03.
- **Plugin self-test scope decision** (smoke tests for hooks + frontmatter validator vs none) — Phase 4 OPEN-QUESTIONS register per REQUIREMENTS.md OPEN-07.
- **`/refine-<skill>` resolution** (build single parameterised command vs delete every orphan reference) — Phase 4 OPEN-QUESTIONS register per REQUIREMENTS.md OPEN-06; Phase 1 only inventories the orphan references as a finding.
- **Pipefy / Wrike / Ziflow platform-API live probing** — requires sandbox tenant credentials; deferred to v2.1+ build phase per CHANGE-04 research-blocked-phases flag. Phase 1 only inventories the API connectors by name in AUDIT-03 dependency table.

</deferred>

---

*Phase: 1-audit*
*Context gathered: 2026-05-09*
