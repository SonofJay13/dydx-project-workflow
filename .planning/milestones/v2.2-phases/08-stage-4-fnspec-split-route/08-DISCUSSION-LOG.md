# Phase 8: Stage 4 Fnspec Split + ROUTE (incl. TD-2 inline) - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-05-11
**Phase:** 8-stage-4-fnspec-split-route
**Areas discussed:** TD-2 + ROUTE-03 addendum carrier; Plan slicing + wave parallelism; Skill internals — rubric + markup + refs shape; Cross-spec wiring — consistency + skip + smoke

---

## Gray-area selection

| Option | Description | Selected |
|--------|-------------|----------|
| TD-2 + ROUTE-03 addendum carrier | Resolve ziflow enum (add vs integration-only) + decide who authors the Platform-API Addendum H2 body when v2.2 has no Stage 5 consumer. | ✓ |
| Plan slicing + wave parallelism | 3 plans (default D-69) vs 4 plans (split ROUTE cross-cutting). Sequential vs parallel waves. Where TD-2 enum work lives. | ✓ |
| Skill internals — rubric + markup + refs shape | Where the HIGH/MED/LOW → delivery rubric lives, per-row markup pattern, references/ folder shape for 4a and 4b. | ✓ |
| Cross-spec wiring — consistency + skip + smoke | Consistency check implementation form, either-spec-skip detection pattern, forward-compat smoke check location/authorship. | ✓ |

**User's choice:** All four selected.

---

## TD-2 + ROUTE-03 addendum carrier

### Sub-decision A — ROUTE-04 TD-2 resolution branch

| Option | Description | Selected |
|--------|-------------|----------|
| (a) ADD `ziflow` to stage-skill `platform:` enum | Add `ziflow` to `platform: pipefy | wrike | ziflow | other` across ALL stage skills + glossary routing-key entry. Aligns with platform-ziflow/SKILL.md:14's existing claim. Touches every stage-skill mentioning the enum; future-proofs proof-review-led engagements. | ✓ |
| (b) Document Ziflow as integration-only | Drop the routing-key claim from `platform-ziflow/SKILL.md:14`; document Ziflow as integration-only. Leaves stage-skill enum at `pipefy | wrike | other`. Lower-touch; precludes Ziflow-primary projects. | |

**User's choice:** (a) ADD ziflow to stage-skill enum → **D-78**.

### Sub-decision B — ROUTE-03 addendum body authorship

| Option | Description | Selected |
|--------|-------------|----------|
| Stage 4a writes the addendum body in v2.2 | Stage 4a SKILL.md instructs the skill to author the full addendum body (error-paths discipline for API portions) inline. Matches DESIGN-21 wording. v2.3 Stage 5 consumes body verbatim. | ✓ |
| Stage 4a emits a stub addendum + frontmatter only | Stage 4a writes the H2 header + frontmatter but leaves body as placeholder. Saves authoring work; v2.2 artefacts incomplete on platform-only path until v2.3. | |
| Defer addendum body entirely until v2.3 | v2.2 emits frontmatter only; no H2 appended. Contradicts ROADMAP success criterion 4(b) ("4a carries `## Platform-API Addendum` H2"). | |

**User's choice:** Stage 4a writes inline → **D-79**.

---

## Plan slicing + wave parallelism

| Option | Description | Selected |
|--------|-------------|----------|
| 3 plans, sequential (D-69 precedent) | 08-01 = Stage 4a; 08-02 = Stage 4b (depends on 4a); 08-03 = retire + ROUTE-04 + ROUTE-05 + STG4-03 + STG4-06 + REQUIREMENTS flips + structure-check. No parallel waves. Mirrors v2.1 D-63 + Phase 7 D-69. | ✓ |
| 4 plans, parallel Wave 1 | 08-01 (Stage 4a) ‖ 08-02 (TD-2 enum) in Wave 1 (disjoint files), then 08-03 (Stage 4b), then 08-04 (closeout). Mirrors v2.1 Phase 6 Wave 2. | |
| 2 plans, big-and-small | 08-01 = both 4a + 4b in one plan; 08-02 = everything else. Smaller plan count; larger atomic units. Conflicts with D-63 ("reviewer-context loss"). | |

**User's choice:** 3 plans, sequential (with explicit preview) → **D-80**.

---

## Skill internals — rubric + markup + refs shape

### Sub-decision A — Classifier rubric location

| Option | Description | Selected |
|--------|-------------|----------|
| Per-skill `references/auto-classify-rubric.md` (D-73 precedent) | `generate-fnspec-platform/references/auto-classify-rubric.md` carries the HIGH/MED/LOW → delivery mapping + override mechanics + re-run preservation. SKILL.md cites the rubric. 4b reads 4a's tags. | ✓ |
| Shared `dydx-delivery/references/delivery-classifier.md` | Plugin-level reference. Pro: single SoT. Con: doesn't match Phase 7 D-73; no other v2.2 consumer of the rubric. | |
| Inline in 4a SKILL.md | Rubric prose inside SKILL.md body. Pro: no indirection. Con: bloats SKILL.md; breaks Phase 7 D-73 consistency. | |

**User's choice:** Per-skill `references/auto-classify-rubric.md` → **D-81**.

### Sub-decision B — Per-row markup pattern

| Option | Description | Selected |
|--------|-------------|----------|
| Terse inline marker: `delivery: native-ai [HIGH, src: platform-pipefy]` | Bracketed confidence + source suffix; `[reviewer-override: ...]` for human edits; re-run preserves overrides. Greppable; one-line provenance. Mirrors Phase 7 STG1-04 `[unknown ...]` idiom. | ✓ |
| Verbose HTML comment block above each row | `<!-- classifier: delivery=... confidence=... source=... -->` above each row. Pro: cleaner artefact. Con: 2x line count; HTML comments may not survive Coda mirror (DESIGN-09). | |
| Minimal: just `delivery: native-ai` (no confidence, no source) | Shortest artefact. Con: no provenance; re-run can't distinguish override from default-to-api. | |

**User's choice:** Terse inline marker → **D-82**.

### Sub-decision C — references/ folder shape

| Option | Description | Selected |
|--------|-------------|----------|
| 4a = 3 files; 4b = 3 files (D-71 precedent) | 4a: fnspec-platform-template.md + auto-classify-rubric.md + addendum-template.md. 4b: fnspec-integration-template.md + consistency-rules.md + either-spec-skip-paths.md. Mirrors kickoff-capture (D-71). | ✓ |
| 4a = 2 files; 4b = 2 files | Fold addendum-template into main template; fold either-spec-skip into SKILL.md or consistency-rules. Fewer files; conflates concerns. | |
| Mixed: 4a = 3 files, 4b = 2 files | Asymmetric. Pro: each skill carries only what it needs. Con: inconsistency between siblings. | |

**User's choice:** 4a = 3 files; 4b = 3 files → **D-83**.

---

## Cross-spec wiring — consistency + skip + smoke

### Sub-decision A — Consistency check form

| Option | Description | Selected |
|--------|-------------|----------|
| SKILL.md prose contract + `references/consistency-rules.md` | SKILL.md states behavioural contract; consistency-rules.md carries detailed checks + failure-report template. No shell script. Matches D-77 distinction (PHASE-GATE = script, RUNTIME-SKILL = prose). | ✓ |
| Standalone shell script + SKILL.md pointer | `consistency-check.sh` implements the three checks. Pro: deterministic. Con: introduces new pattern; D-77 reserved script-form for PHASE GATES; all v0.3.0/v2.1/v2.2 skill checks have been prose-only. | |
| Inline in SKILL.md, no separate references file | All rules + template inside SKILL.md. Pro: no indirection. Con: bloats SKILL.md; conflicts with D-83 (which already allocates consistency-rules.md). | |

**User's choice:** SKILL.md prose contract + `references/consistency-rules.md` → **D-84**.

### Sub-decision B — Either-spec-skip mechanics

| Option | Description | Selected |
|--------|-------------|----------|
| Both skills emit verbatim skip logs; no artefact on skip path (D-74 precedent) | 4a runs normally (no skip path). 4b detects skip via 4a absence + SOW Scope H2s + reviewer signal; emits verbatim string to stdout; writes no artefact. Topology rules in `either-spec-skip-paths.md`. | ✓ |
| Auto-detect from SOW scope; written skip-marker file | Each skill auto-decides from SOW H2s; writes a `04*_skipped_v<N>.md` marker. Pro: explicit artefact trail. Con: new file convention; conflicts with D-74. | |
| SKILL.md asks reviewer at invocation; no artefact on skip | Both skills prompt reviewer at start. Pro: explicit human gate. Con: extra friction; doesn't leverage SOW H2s. | |

**User's choice:** Verbatim skip logs, stdout-only (D-74 precedent) → **D-85**.

### Sub-decision C — Forward-compat smoke location

| Option | Description | Selected |
|--------|-------------|----------|
| 08-03 plan deliverable: `phase8-structure-check.sh --section smoke` + fixture stubs | Smoke check ships in 08-03 as a structure-check.sh partition; loads sample 4a + 4b artefacts; reads via synthetic 5/6/7b/10 consumer-stubs (shell grep/awk); asserts `delivery:` field survives canonical position. Mirrors Phase 7 D-77 + 07-04 e2e smoke. | ✓ |
| Standalone Python test in `dydx-delivery/tests/` | Pytest-style test per DESIGN-04 D-24. Pro: proper test runner. Con: tests/ doesn't exist yet; pytest infra is scope creep relative to v2.2. | |
| Manual e2e smoke note only (like Phase 7 07-04-SUMMARY.md) | Reviewer manually walks fixtures; captures findings in 08-VERIFICATION.md. Pro: zero new automation. Con: ROUTE-05 verification rests on human discipline each release. | |

**User's choice:** `phase8-structure-check.sh --section smoke` + fixture stubs → **D-86**.

---

## Claude's Discretion

Areas where the user delegated to Claude (see CONTEXT.md §"Claude's Discretion" for the full list):

- Detailed body wording inside `fnspec-platform-template.md`, `fnspec-integration-template.md`, `addendum-template.md`.
- Exact escalation thresholds inside `auto-classify-rubric.md` (MEDIUM definition tolerance).
- Failure-row template wording inside `consistency-rules.md` + the `04b_consistency_check_v<N>.md` artefact body.
- The exact verbatim skip-emit string for D-85 (`Stage 4b SKIPPED — no integration work in scope` is the working default; lockable at plan time).
- Plan-task counts inside each of 08-01 / 08-02 / 08-03; whether 08-03 splits to 08-04 (~400 LOC heuristic).
- Synthetic Stage 5/6/7b/10 consumer-stub shell-function bodies inside `phase8-structure-check.sh --section smoke`.
- OPEN-Q row surfacing during 08-01 / 08-02 research.

## Deferred Ideas

- Stage 5 actual consumption of `has_platform_api_addendum` / `tech_spec_scope` / addendum H2 (v2.3).
- Stage 6 / 7b / 10 consumption of `delivery:` routing key (v2.3+).
- Stage 9 documentation publishing (`update-documentation/`) — v2.5.
- Stage 8 test bot rebuild + persistent harness — v2.4+.
- Coda mirror + Coda hard dependency activation — v2.4+.
- Auto-migration of v0.3.0 `04_functional-spec_v*.md` to new 4a/4b naming — explicitly out per STG4-03.
- Pytest test runner in `dydx-delivery/tests/` — deferred until a future milestone needs more than gate-form assertions.
