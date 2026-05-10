# Phase 3: Change list - Context

**Gathered:** 2026-05-10
**Status:** Ready for planning

<domain>
## Phase Boundary

Phase 3 produces `.planning/CHANGELIST.md` — the **sequenced, justified delta** from v0.3.0 to v2 that:

1. Commits the `.planning/research/SUMMARY.md` 9-phase build plan as the authoritative v2.x milestone sequence (CHANGE-01).
2. Inventories the per-skill delta — every existing v0.3.0 skill tagged `NEW / MODIFIED / RETIRED / UNCHANGED` with change description; every NEW v2 skill tagged with introducing phase (CHANGE-02).
3. Schedules the cosmetic-fix list for v2.1 Foundations build, OUT OF SCOPE for this milestone (CHANGE-03).
4. Flags research-blocked phases — Phase 1 (connector probe) and Phase 7 (native-AI ingestion paths) — recommending `/gsd-research-phase` passes before those phases lock plans (CHANGE-04).
5. Captures migration cutover rules so v0.3.0 in-flight artefacts don't get auto-corrupted (CHANGE-05).

**This is a design-document-authoring phase.** No skill files are edited (kickoff mandate; design-only milestone). No new architecture is decided here — Phase 3 sequences the architecture Phase 2 locked. The output is a single markdown deliverable at the planning root: `.planning/CHANGELIST.md`.

**Boundary with Phase 4:** Phase 3 owns the change-list sequence and per-skill delta. Phase 4 (Open questions register) consumes the sequence — every open-question item gets assigned an owning phase from the v2.x sequence committed here. Items deferred to Phase 4 carry `[OPEN: Phase 4 — <one-line summary>]` markers inline in CHANGELIST.md (per D-27 from Phase 2).

**Boundary with v2.1+ build phases:** CHANGELIST.md is a *plan*, not an *executor*. The cosmetic-fix list ships items but doesn't fix them; the per-skill delta inventories the change but doesn't author the new SKILL.md. Every fix-bullet carries the per-bullet sentinel `**Scheduled for v2.1 Foundations build (FOUND-NN), NOT this milestone.**` (D-16 carried from Phase 1) so a v2.1 implementer cannot lift one bullet out of context.

</domain>

<decisions>
## Implementation Decisions

### Document structure (top-level H2 shape)
- **D-36:** **Hybrid shape** — 9-phase plan is the spine of CHANGELIST.md (largest section, addresses CHANGE-01 + woven CHANGE-02 skill-deltas per phase via the "Skills introduced/modified" attribute row). Cosmetic-fix list, full per-skill delta matrix, research-blocked summary, migration cutover rules each get **appendix-level H2 sections**. Locked H2 list:
  - `## Executive Summary`
  - `## How to read this change list`
  - `## Phase 1: Foundations + Connector Verification (v2.1)`
  - `## Phase 2: Internalise Platform Skills (v2.1)`
  - `## Phase 3: Stage 1 + Stage 4 split (v2.2)`
  - `## Phase 4: Tech spec + Cost + Implementation prompt (v2.3)`
  - `## Phase 5: Test bot rebuild (v2.4)`
  - `## Phase 6: Documentation publishing (v2.5)`
  - `## Phase 7: Native-AI knowledge push (v2.5) [BLOCKED — see Appendix C]`
  - `## Phase 8: Sign-off + Coda mirror (v2.6)`
  - `## Phase 9: Surfaces (v2.6)`
  - `## Appendix A: Per-skill delta matrix (CHANGE-02)`
  - `## Appendix B: Cosmetic-fix list (CHANGE-03)`
  - `## Appendix C: Research-blocked phases (CHANGE-04)`
  - `## Appendix D: Migration cutover rules (CHANGE-05)`
  - `## Appendix E: Deferred to Phase 4 OPEN-QUESTIONS`
  - **Rationale:** reader asking "what's in v2.3 ship?" lands on a phase H2; reader asking "is skill X changing?" lands in Appendix A; reader asking "what's still unknown?" lands in Appendix C. Optimised for the 3 most-likely reader queries. Phase-section H2s reflect milestone tag inline (`(v2.X)`) so milestone bundling is visible without re-reading the executive summary.

### Milestone-sizing call (CHANGE-01)
- **D-37:** **6 milestones via the example bundling already in CHANGE-01 wording**, locked as:

  | Milestone | Phases | Theme |
  |---|---|---|
  | v2.1 | P1 + P2 | Foundations + Connector Verification + Internalised Platform Skills |
  | v2.2 | P3 | Stage 1 Kickoff capture + Stage 4 fnspec split |
  | v2.3 | P4 | Tech spec + Cost estimate + Implementation prompt |
  | v2.4 | P5 | Test bot rebuild |
  | v2.5 | P6 + P7 | Documentation publishing + Native-AI knowledge push |
  | v2.6 | P8 + P9 | Sign-off + Coda mirror + Surfaces |

  **Re-bundling caveat (mandatory verbatim sentence in CHANGELIST.md):** "User may re-bundle phases at the start of any v2.x milestone kickoff via `/gsd-new-milestone` — this bundling is the recommended sequence, not a contract."

  **OPEN-01 contingent fallback (also mandatory in CHANGELIST.md, attached to the v2.5 row):** "If OPEN-01 (native-AI ingestion paths per platform) remains unresolved at v2.5 kickoff, split P6 → v2.5 (Documentation only) and P7 → v2.6 (Native-AI when unblocked); slide P8/P9 → v2.7. Phase 7 is the only blocked-by-OPEN phase; isolating it preserves cadence on the rest."

### 9-phase plan presentation depth
- **D-38:** **H3 + per-phase mini-table per attribute.** Each phase = `### Phase N: <name> (v2.X)` + brief narrative paragraph (ordering rationale only — *why this phase here, not earlier or later*) + 6-row mini-table:

  | Attribute | Detail |
  |---|---|
  | Deliverables | <bulleted list of what this phase ships> |
  | Depends on | <prior-phase IDs or `— (root phase)`> |
  | Addresses | <REQ-IDs from FOUND-/PLAT-/STG*-/SURF- families, comma-separated> |
  | Avoids pitfalls | <CRIT-/MOD-/MIN- IDs from `.planning/research/PITFALLS.md`, comma-separated> |
  | Skills introduced/modified | <subset of the per-skill delta — ties Appendix A to the phase> |
  | Research-blocked | `⚠ <one-line summary>` linking to Appendix C, OR `—` if not blocked |

  **Pattern source:** matrix-then-prose (D-11/D-12 from Phase 1 carried into Phase 2). The narrative paragraph is bounded — *ordering rationale only*. Deliverables / dependencies / REQ-IDs / pitfalls / skills / blockers all live in the table for reviewer scanability.

  **Rationale-paragraph discipline:** the narrative is *why this phase appears at this position in the sequence*, not *what this phase does* (the deliverables row owns "what"). Source for ordering rationale: `.planning/research/SUMMARY.md` § "Phase Ordering Rationale" (verbatim where it fits, paraphrased where it doesn't).

### Per-skill delta presentation (CHANGE-02 → Appendix A)
- **D-39:** **Single matrix, one row per v2 skill.** Columns: `v0.3.0 origin | v2 name | Status | Change | Introduced (phase) | DESIGN`. Status enum: `NEW / NEW (split) / MODIFIED / RETIRED / RETIRED → SPLIT / UNCHANGED`. RETIRED-AND-REPLACED skills appear as their own row tagged `RETIRED` (or `RETIRED → SPLIT`) — the new replacement skill(s) appear above as `NEW (split)` rows with cross-cite back to the retired origin. Single source of truth for "is skill X changing"; no multi-table fragmentation.

  **Required ordering inside the matrix:** group rows by introducing milestone (v2.1 first → v2.6 last). Within each milestone block, order by introducing phase, then by status (NEW → MODIFIED → RETIRED → UNCHANGED). Reader scanning v2.1 sees the platform skills + foundations cleanup adjacent.

  **Required count totals at the bottom of Appendix A** (from the v2 13-skill end state per DESIGN-12): N rows tagged NEW; N tagged MODIFIED; N tagged RETIRED; N tagged UNCHANGED. Totals MUST sum to the 13-skill v2 universe + accounted RETIRED rows; mismatch indicates a missing or duplicated row.

### Skill-delta tagging granularity (Claude default — auto-applied)
- **D-40:** **Cited-bullets in the Change column.** Each `Change` cell = 1-3 short bullets, each ending with `(per DESIGN-NN)` cite where applicable. One-line per skill loses fidelity; multi-paragraph wastes a matrix cell. Bullets stay tight.

### Cosmetic-fix list (CHANGE-03 → Appendix B; Claude default — auto-applied)
- **D-41:** **Verbatim lift from `.planning/AUDIT.md` § AUDIT-07** with the per-bullet sentinel preserved. Single source of truth — AUDIT-07 already carries the D-16 sentinel on every bullet, so a verbatim lift inherits the discipline without drift risk. Appendix B opens with: "Lifted verbatim from `.planning/AUDIT.md` § AUDIT-07 (per D-16 sentinel discipline). Editing here without also editing AUDIT-07 introduces drift; if a fix needs revision, edit AUDIT.md first and re-lift." Appendix B does NOT re-author the fixes as change-tasks — that would split the source of truth and risk implementers acting on the change-task version while AUDIT-07 says something else.

### Research-blocked flag visibility (CHANGE-04 → Appendix C; Claude default — auto-applied)
- **D-42:** **Both inline markers AND dedicated Appendix C.** Inline: each affected phase carries the `⚠ <one-line>` row in its mini-table linking to Appendix C. Appendix C carries the full unknown-list per blocked phase + recommended `/gsd-research-phase` invocation. This addresses two reader paths: (a) someone reading the 9-phase plan top-to-bottom sees the blocker inline at the phase that hits it; (b) someone scanning for "what's still unknown" lands in Appendix C with the full register. Mirrors D-27's "marker at point of use + closed list at end" pattern from Phase 2.

  **Phases tagged research-blocked (per CHANGE-04):**
  - **Phase 1 (connector availability per tenant):** Coda MCP version pin, Google Workspace MCP choice, Miro MCP existence, Wrike rate-limit currency, Ziflow auth header.
  - **Phase 7 (native-AI ingestion paths per platform):** Pipefy AI KB content-upload endpoint, Wrike AI Studio knowledge-ingestion API, Ziflow ReviewAI knowledge-ingestion API. **Phase 7 inherits OPEN-01 as a hard blocker.**

### Migration cutover rules (CHANGE-05 → Appendix D; Claude default — auto-applied)
- **D-43:** **Citation header + reader-friendly numbered checklist.** Appendix D opens with: "Authoritative contract: `.planning/DESIGN.md` § DESIGN-08 (locked by D-25). This appendix restates the rules in implementer-readable form; if rules conflict, DESIGN-08 wins." Followed by a numbered checklist (5-7 rules, each one line) extracted from D-25:
  1. v2 readers tolerate v0.3.0 frontmatter via the `frontmatter_version` field (absent → v0.3.0 lenient mode).
  2. Migration is opt-in per change request — artefacts upgrade only when their owning CR fires.
  3. In-flight `client_review` artefacts NEVER auto-flip to `approved`.
  4. Status lifecycle MUST retain `client_review` (live in `dydx-delivery/skills/generate-sow/SKILL.md:93`).
  5. The canonical lifecycle is `draft → client_review → approved → archived` (per DESIGN-01).
  6. Artefact file renumbering (00→02 / 01→03 / 02→04 / 03→05 / 04→07a per FOUND-03) applies only to NEW artefacts written by v2 skills; existing files stay at v0.3.0 prefixes until their owning CR opts in.
  7. The status-lifecycle survey result (DESIGN.md § Live status-lifecycle survey) is the empirical confirmation that no live `status:` value gets orphaned by this contract.

### Decision-ID convention (carried from Phase 2)
- **D-44:** Phase 3 D-N numbering picks up at **D-36** (Phase 2 ended at D-35, verified 2026-05-10 via `grep -oE 'D-[0-9]+' .planning/phases/02-design/02-CONTEXT.md`). Authoring decisions (about how CHANGELIST.md is structured) and content decisions (about which entries land in CHANGELIST.md) share the same numbering pool. CHANGELIST.md cites D-IDs without prefix disambiguation.

### Cross-cutting authoring decisions (carried from Phase 1 / Phase 2 — restated for downstream agents)
- **D-14 (carried):** Citations use `` `file:line` `` format with backtick wrapping. Multi-line ranges use `` `file:start-end` ``.
- **D-15 (carried, narrowed):** Severity tags `[BLOCKING] / [STRUCTURAL] / [COSMETIC]` apply only to migrated AUDIT-07 cosmetic items lifted into Appendix B (preserving the original tagging) — NOT to CHANGE-N rows themselves (the CHANGE-N items are change-list entries, not findings; they carry phase / milestone tags instead).
- **D-16 (carried, mandatory):** Every cosmetic-fix bullet in Appendix B MUST carry `**Scheduled for v2.1 Foundations build (FOUND-NN), NOT this milestone.**` Verbatim lift from AUDIT-07 inherits this; the structural-check (if added per Plan-N) asserts the count in Appendix B matches AUDIT-07's count.
- **D-17 (carried, contextualised):** `2.0.0` is the synced manifest version; CHANGELIST.md cites this as the v2.1 ship target inside Phase 1 (Foundations) deliverables and inside Appendix B (cosmetic-fix list — version-string mismatches resolved by `2.0.0`).
- **D-25 (carried from Phase 2):** Frontmatter migration is CR-driven opt-in (DESIGN-08 contract — Appendix D restates, doesn't re-derive). The status-lifecycle survey (Phase 2 deliverable) is the empirical lock on this contract.
- **D-27 (carried from Phase 2):** Inline `[OPEN: Phase 4 — <one-line summary>]` markers at point of use; closed list in Appendix E enumerating every `[OPEN]` marker for mechanical traceability into the Phase 4 OPEN-QUESTIONS register. Phase 4 register can be built mechanically by walking Appendix E.
- **D-28 (carried from Phase 2):** `D-N` numbering continues across phases for cross-milestone traceability. CHANGELIST.md cites D-IDs without prefix disambiguation.

### Author flow (planning shape — hint to gsd-planner)
- **D-45:** Recommended planning shape mirrors Phase 2 — **Wave 0 scaffold** (create `.planning/CHANGELIST.md` skeleton with all H2 headings empty; verify structural-check fails-as-expected on empty content) → **Wave 1 parallel per-CHANGE-N plans** (5 plans: CHANGE-01..05, each owns one or more H2 sections per the D-36 layout) → **Wave 2 synthesis plan** (executive summary; Appendix E walk; reviewer-coverage doc; final structural-check pass). Per-phase mini-table authoring (deliverables / depends / addresses / avoids / skills / blocked) inside Wave 1 plans must read `.planning/research/SUMMARY.md`, `.planning/research/PITFALLS.md`, `.planning/REQUIREMENTS.md`, and `.planning/DESIGN.md` § DESIGN-12 (13-skill inventory) for source-of-truth attributes. **Final shape stays planner discretion** — single-pass plans or 5-vs-7 plan split is the planner's call; this hint provides the wave shape that worked in Phase 2.

### Claude's Discretion
- Internal ordering of bullets within a mini-table cell (chronological vs by-impact vs by-cite) — pick what reads cleanest per phase.
- Exact wording / length of per-phase ordering-rationale paragraph — match the depth the underlying material justifies; hard cap at 4 sentences.
- Whether to add a one-line "what changed since v0.3.0" callout at the top of phase H2 sections that touch existing skill behaviour (Phases 3, 4, 5, 6, 8). Default: yes if the phase touches MODIFIED or RETIRED skills; no if it only introduces NEW.
- Appendix-A `Change` column bullet wording (active voice; cite per-bullet where applicable).
- Whether Appendix C tabulates research-blocked items in a single matrix or per-phase sub-tables — default to a single 2-row matrix (Phase 1 / Phase 7) with a `Research-blocked items` cell per row, but accept per-phase sub-tables if cleaner.
- Whether the executive summary table replicates the per-phase mini-tables in condensed form, or just lists phase-name / milestone / status / blocker — default to condensed (5 cols: Phase / Milestone / Theme / Skills delta count / Blocker).

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase scope and requirements
- `.planning/ROADMAP.md` § "Phase 3: Change list" — phase goal, dependencies, requirements (CHANGE-01..05), success criteria 1-5
- `.planning/REQUIREMENTS.md` § "Change list (CHANGELIST.md)" — full text of CHANGE-01..05
- `.planning/PROJECT.md` — milestone framing, "no skill edits in design milestone" constraint, brownfield v2.0 framing
- `.planning/STATE.md` — current position (Phase 2 ✓ APPROVED 2026-05-10)

### Output deliverable (what this phase produces)
- `.planning/CHANGELIST.md` — the deliverable (created during plan execution; lives at planning root, NOT under phase folder; mirrors AUDIT.md / DESIGN.md placement)

### Ground truth (CHANGELIST.md cites these for v0.3.0 / v2 facts; does NOT re-derive)
- `.planning/AUDIT.md` (Phase 1 deliverable, ✓ APPROVED 2026-05-09) — canonical v0.3.0 reality
  - § AUDIT-01 — per-skill brittleness inventory (input to per-skill delta status tagging)
  - § AUDIT-04 — missing-artefacts inventory (input to NEW-skill rationale)
  - § AUDIT-05 — duplicated content (input to MODIFIED-skill cleanup-justification)
  - § AUDIT-06 — version-string mismatches (input to FOUND-04 / cosmetic-fix list)
  - § AUDIT-07 — cosmetic-but-client-visible issues (verbatim lift source for Appendix B per D-41)
  - § AUDIT-08 — live MCP probe results (input to research-blocked Phase 1 inventory)
- `.planning/DESIGN.md` (Phase 2 deliverable, ✓ APPROVED 2026-05-10) — canonical v2 architecture
  - § DESIGN-04 — plugin surfaces (input to Phase 9 deliverables)
  - § DESIGN-08 — frontmatter migration co-existence (authoritative for Appendix D per D-43)
  - § DESIGN-12 — v2 13-skill inventory (input to Appendix A row enumeration)
  - § DESIGN-14/15/16 — platform-pipefy / platform-wrike / platform-ziflow contracts (Phase 2 deliverables; input to NEW-skill rows in Appendix A)
  - § DESIGN-17..27 — stage-skill specs (input to Phase 3..8 deliverables + Appendix A change descriptions)
  - § DESIGN-28..30 — test-bot architecture (input to Phase 5 deliverables)
  - § "Deferred to Phase 4 OPEN-QUESTIONS" closed list (per D-27) — input to Appendix E pre-population
  - § "Live status-lifecycle survey" — empirical lock on Appendix D rule 7

### Research context (CHANGELIST.md grounds the 9-phase plan in this; cites without re-authoring)
- `.planning/research/SUMMARY.md` — 9-phase build plan (committed verbatim as the v2.x milestone sequence per CHANGE-01)
  - § "Phase Ordering Rationale" — source for per-phase ordering-rationale paragraphs (verbatim where fits, paraphrased where doesn't)
  - § "Implications for Roadmap" — milestone-bundling guidance underlying D-37
- `.planning/research/PITFALLS.md` — CRIT-/MOD-/MIN- pitfall IDs (input to per-phase "Avoids pitfalls" mini-table cell)
- `.planning/research/ARCHITECTURE.md` — v2 architecture intent (background for ordering-rationale paragraphs)
- `.planning/research/FEATURES.md` — v2 feature inventory (background)
- `.planning/research/STACK.md` — research-derived stack decisions (background)

### Codebase context (live state CHANGELIST.md must respect)
- `.planning/codebase/STRUCTURE.md` — v0.3.0 file layout (input to per-skill delta source-paths)
- `.planning/codebase/CONCERNS.md` — issue catalogue (already absorbed into AUDIT.md per AUDIT-02; cross-reference only)
- `.planning/codebase/INTEGRATIONS.md` — connector wiring (input to research-blocked Phase 1 inventory)
- `.planning/codebase/CONVENTIONS.md` — authoring conventions (D-14 citation format compliance)

### Prior phase context (decisions carried forward — see `<decisions>` "Cross-cutting" section)
- `.planning/phases/01-audit/01-CONTEXT.md` — D-1..D-17 (Phase 1 decisions; D-14/D-15/D-16/D-17 carry into Phase 3)
- `.planning/phases/02-design/02-CONTEXT.md` — D-18..D-35 (Phase 2 decisions; D-25/D-27/D-28 carry into Phase 3)

### v0.3.0 source surfaces (cited only when AUDIT.md is silent — AUDIT.md is the preferred citation source)
- `dydx-delivery/skills/discovery-intake/SKILL.md` — input to MODIFIED → kickoff-capture row (Appendix A)
- `dydx-delivery/skills/generate-sow/SKILL.md` — input to UNCHANGED row + DESIGN-08 status-lifecycle citation
- `dydx-delivery/skills/generate-functional-spec/SKILL.md` — input to RETIRED → SPLIT row (Appendix A)
- `dydx-delivery/skills/generate-technical-spec/SKILL.md` — input to MODIFIED row
- `dydx-delivery/skills/generate-test-plan/SKILL.md` — input to RETIRED → SPLIT row
- `dydx-delivery/skills/generate-build-prompt/SKILL.md` — input to MODIFIED row (Stage 7a)
- `dydx-delivery/skills/execute-tests/SKILL.md` — input to UNCHANGED row
- `dydx-delivery/.claude-plugin/plugin.json` — input to FOUND-04 / Appendix B version-sync items
- `.claude-plugin/marketplace.json` — input to FOUND-04 / Appendix B version-sync items
- `README.md` — input to Appendix B README-truncation / "test sheet" residual / pipeline-step count items

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- **`.planning/AUDIT.md` § AUDIT-07 (Phase 1 deliverable):** verbatim lift source for Appendix B (per D-41). The D-16 per-bullet sentinel is already present on every bullet in AUDIT-07; the lift inherits it without re-authoring.
- **`.planning/DESIGN.md` § DESIGN-12 (Phase 2 deliverable):** the v2 13-skill end-state inventory. Appendix A rows enumerate from this list; the per-phase mini-table "Skills introduced/modified" row cites the same list.
- **`.planning/DESIGN.md` § "Deferred to Phase 4 OPEN-QUESTIONS" closed list (per D-27):** the closed list of `[OPEN]` markers from Phase 2 — pre-populates Appendix E. Phase 3 walks this list mechanically; Phase 4 (OPEN-QUESTIONS register) consumes it.
- **`.planning/research/SUMMARY.md` § "Phase Ordering Rationale":** verbatim source for per-phase ordering-rationale narrative paragraphs (D-38). The 7 ordering rules in SUMMARY.md map 1:1 to the phases that need ordering justification.
- **`.planning/research/PITFALLS.md`:** CRIT-/MOD-/MIN- IDs ready for citation in the per-phase "Avoids pitfalls" mini-table cell. No re-derivation; just look up which pitfalls each phase addresses.
- **Phase 1 / Phase 2 authoring patterns:** matrix-then-prose (D-11/D-12 from Phase 1), `file:line` citation format (D-14), per-bullet sentinel discipline (D-16), inline `[OPEN]` markers + closed list (D-27 from Phase 2). CHANGELIST.md adopts these wholesale.
- **`.planning/REQUIREMENTS.md` § "Future Requirements (deferred — v2.1+)" subsections:** FOUND-01..07, PLAT-01..03, STG1-01..02, STG3-01, STG4-01..02, STG5-01, STG6-01..02, STG7-01..02, STG8-01..04, STG9-01..02, STG10-01..03, STG11-01..03, SURF-01..03 — REQ-IDs already organised by phase; the per-phase mini-table "Addresses" cell maps directly.

### Established Patterns (carried into CHANGELIST.md)
- **Matrix-then-prose section shape (D-11/D-12 from Phase 1):** mini-tables carry the structured attributes; prose carries narrative-only content (ordering rationale, executive summary). CHANGELIST.md adopts wholesale per D-38.
- **Per-bullet sentinel discipline (D-16):** every cosmetic-fix bullet in Appendix B carries `**Scheduled for v2.1 Foundations build (FOUND-NN), NOT this milestone.**` — verbatim from AUDIT-07 lift. Reviewer cannot lift one bullet out of context.
- **`[OPEN: Phase 4 — <summary>]` marker at point of use + closed list at doc end (D-27 from Phase 2):** CHANGELIST.md adopts the same convention. Items deferred to Phase 4 OPEN-QUESTIONS carry inline markers (in mini-tables, in Appendix C, in Appendix D where contracts cross-reference open issues), and Appendix E enumerates every marker.
- **Severity-tag inline marking (D-15, narrowed):** preserved on the AUDIT-07 verbatim lift in Appendix B. CHANGE-N items themselves carry milestone / phase tags, not severity tags.
- **`file:line` citation format (D-14):** all citations to source surfaces use this format with backtick wrapping.

### Integration Points
- **Output file location:** `.planning/CHANGELIST.md` lives at planning root (NOT under `.planning/phases/03-changelist/`). Mirrors `.planning/AUDIT.md` and `.planning/DESIGN.md` placement (Phase 1 D-13 integration-point precedent). The phase folder `.planning/phases/03-changelist/` carries planning artefacts (PLAN.md, RESEARCH.md, PATTERNS.md, VALIDATION.md, plan files) only.
- **Connection to Phase 4 (Open questions register):** Appendix E (closed `[OPEN]` marker list) is the input to Phase 4. Every Appendix E row becomes an OPEN-QUESTIONS register entry with owning phase already assigned (the inline marker carries the assignment).
- **Connection to v2.x build phases:** the locked 6-milestone bundling (D-37) drives `/gsd-new-milestone` invocations at v2.1, v2.2, ... v2.6 kickoff. The per-phase mini-tables carry the "Addresses" REQ-ID list that becomes the next milestone's REQUIREMENTS.md import.
- **Connection to research-blocked phases (CHANGE-04):** Appendix C carries the recommended `/gsd-research-phase` invocation per blocked phase. The v2.1 (P1 connector) and v2.5 (P7 native-AI) milestone kickoffs MUST run research before plan-phase locks the phase plan.
- **Structural-check script (Plan-N optional):** Phase 1 used `audit-structure-check.sh` to enforce H2 headings + per-bullet sentinel count (D-16 enforcement). Phase 3 may add an analogous `changelist-structure-check.sh` enforcing: 16 H2 sections present (per D-36 list); per-bullet sentinel count in Appendix B matches AUDIT-07; 9 phase-section H3s present; Appendix A row-count totals sum correctly. Planner's call.

</code_context>

<specifics>
## Specific Ideas

- **Reviewer experience (carried from Phase 1):** CHANGELIST.md should support both "read in order" (executive summary → 9-phase plan top-to-bottom → appendices) AND "skip to specific item" (executive summary table acts as TOC; phase H2s carry milestone tag inline; Appendix A is the "is skill X changing" lookup; Appendix C is the "what's still unknown" lookup; Appendix E is the "what's deferred" lookup).
- **Milestone tag rendering (per D-37):** every phase H2 carries the milestone tag inline `(v2.1)`, `(v2.2)`, etc. Phase 7's H2 explicitly carries `[BLOCKED — see Appendix C]` so a casual scan of the H2 list surfaces the only at-risk phase.
- **Re-bundling caveat (per D-37):** the verbatim sentence "User may re-bundle phases at the start of any v2.x milestone kickoff via `/gsd-new-milestone` — this bundling is the recommended sequence, not a contract." MUST appear in the executive summary AND immediately after the milestone-bundling table (if a bundling table appears in the executive summary). Belt-and-braces against an implementer reading only the table.
- **OPEN-01 contingent fallback (per D-37):** the verbatim contingency sentence MUST appear attached to the v2.5 row of any milestone-bundling table AND in the v2.5 executive-summary entry AND in Appendix C (Phase 7 entry). Reader scanning v2.5 from any direction sees the fallback.
- **Per-phase ordering-rationale source (per D-38):** when SUMMARY.md § "Phase Ordering Rationale" carries a verbatim ordering rule for a phase (e.g., "Phase 6 before Phase 7 because Stage 10 ingests approved doc fragments from Stage 9"), use that verbatim sentence in the phase's narrative paragraph. Where SUMMARY.md is silent, paraphrase from SUMMARY.md § "Implications for Roadmap" or compose. Cite SUMMARY.md inline (`per .planning/research/SUMMARY.md § Phase Ordering Rationale`).
- **Appendix A row count check:** the matrix MUST account for all 13 v2 skills + the RETIRED rows for v0.3.0 skills no longer present in v2 (RETIRED → SPLIT entries for `generate-functional-spec` and `generate-test-plan` per Phase 2 Reusable Assets analysis). Total rows = 13 v2 + 2 RETIRED = 15 minimum. Plan acceptance asserts the row count.
- **Appendix B opening sentence (per D-41):** "Lifted verbatim from `.planning/AUDIT.md` § AUDIT-07 (per D-16 sentinel discipline). Editing here without also editing AUDIT-07 introduces drift; if a fix needs revision, edit AUDIT.md first and re-lift." MUST appear as the first line under the H2.
- **Appendix D opening sentence (per D-43):** "Authoritative contract: `.planning/DESIGN.md` § DESIGN-08 (locked by D-25). This appendix restates the rules in implementer-readable form; if rules conflict, DESIGN-08 wins." MUST appear as the first line under the H2.
- **Appendix E mechanical-walk hint (per D-27):** Appendix E opens with: "Closed list of every `[OPEN: Phase 4 — ...]` marker in this document. Phase 4 OPEN-QUESTIONS register can be built mechanically by walking this list — every row becomes a register entry with the owning phase already assigned. New deferrals discovered during Phase 3 authoring add a row here AND inline at point of use."

</specifics>

<deferred>
## Deferred Ideas

These items came up during analysis or are flagged by REQUIREMENTS.md / ROADMAP.md as out-of-scope for Phase 3 — they belong to later phases.

- **Phase 4 OPEN-QUESTIONS register itself:** the catalogue of every "couldn't verify" + "needs human decision" item, each assigned an owning phase from the change list. CHANGELIST.md provides Appendix E as the input; Phase 4 produces the register. Phase 3 deferral assignments drive Phase 4 row generation; Phase 3 does NOT pre-write the register.
- **Risk-multiplier numeric defaults (1.1 / 1.3 / 1.6 vs. dYdX-historical-validated):** DESIGN-22 locked structure in Phase 2; numbers DEFERRED to Phase 4 OPEN-QUESTIONS per D-22. CHANGELIST.md's Phase 4 (Tech spec + Cost + Implementation prompt) section carries `[OPEN: Phase 4 — risk-multiplier defaults pending dYdX-historicals validation]` marker; Appendix E pre-populates this row.
- **Pipefy GraphQL pagination cursor field names** (per OPEN-01 / DESIGN-14) — Phase 2 owns the deferral assignment; CHANGELIST.md's Phase 2 (Internalise Platform Skills) section carries the inline marker; Appendix E pre-populates.
- **Ziflow read-after-create consistency window** (per OPEN-01 / DESIGN-16) — same shape as above; Phase 2 inline marker; Appendix E entry.
- **Pipefy / Wrike 2026 rate-limit currency** (per OPEN-01 / DESIGN-14/15) — Phase 1 + Phase 2 inline markers (rate-limit applies to both connector probe AND platform-skill retry/backoff); Appendix E entry.
- **Pipefy AI KB content-upload endpoint, Wrike AI Studio knowledge-ingestion API, Ziflow ReviewAI knowledge-ingestion API** (per OPEN-01 / DESIGN-14/15/16) — the SINGLE BIGGEST research-blocked unknown. Phase 7 hard blocker. Appendix C flags Phase 7 as `[BLOCKED]`; D-37 locks the contingent fallback; Appendix E catalogues each of the three APIs.
- **Plugin self-test scope decision** (smoke tests for hooks + frontmatter validator vs none) — Phase 4 OPEN-QUESTIONS register per REQUIREMENTS.md OPEN-07. Phase 2 D-24 locked the scope (pytest at `dydx-delivery/tests/`); the OPEN item now relates to *which* tests ship in v2.1 vs v2.2+. Phase 1 (Foundations) carries the inline marker; Appendix E entry.
- **`/refine-<skill>` resolution** — Phase 2 D-23 locked the pattern (single parameterised `commands/refine.md` with `/dydx-refine-*` namespace). v2.1 Foundations executes the build per FOUND-05. No OPEN item remains for this — fully resolved upstream.
- **Pipefy / Wrike / Ziflow platform-API live probing** — requires sandbox tenant credentials; deferred to v2.x build phase per CHANGE-04 research-blocked-phases flag. CHANGELIST.md Phase 2 (Internalise Platform Skills) section carries the inline marker; Appendix C entry under Phase 2.
- **Connector probe per tenant** (Coda MCP version, Google Workspace MCP, Miro MCP existence, Wrike rate-limit currency, Ziflow auth header per CHANGE-04) — research-blocked Phase 1 unknowns. Appendix C Phase 1 entry; recommended `/gsd-research-phase` invocation before v2.1 plan-phase locks the connector-probe plan.
- **Surfaces — `commands/`, agent wrapping, `hooks/` (SURF-01..03):** Phase 9 territory. Phase 3 inventories them in the Phase 9 mini-table; build executes in v2.6.

</deferred>

---

*Phase: 3-changelist*
*Context gathered: 2026-05-10*
