# Phase 7: Stage 1 Kickoff + Discovery/SOW upstream wiring — Research

**Researched:** 2026-05-11
**Domain:** Plugin skill authoring (Anthropic Claude skill convention) — NEW `kickoff-capture/` skill + surgical mods to two existing v0.3.0 stage skills + phase-local bash structure-check script.
**Confidence:** HIGH (all source materials are in-repo, design-locked, and verified line-by-line).

## Summary

Phase 7 lands 3 atomic per-skill plans per D-69 (Phase 6 D-63 precedent). All 10 STG1/STG2/STG3 requirements are design-locked at DESIGN-17/18/19 — research is **lift-and-fix** posture: extract the locked literal content the planner pastes, and surface the exact insertion points for surgical edits to the two MODIFIED skill bodies. DESIGN-17/18/19 contain only the **categories + frontmatter shape + verbatim hand-off message + key decisions**; they carry **no literal template body, no rubric body, no capture-paths protocol body**. Per D-70 / D-73 the planner therefore **authors prose from the locked categories**.

Two critical observations the planner must handle on Day 1:
1. **CONTEXT.md cites `.planning/codebase/PATTERNS.md` — that file does not exist.** Bash skeleton lives in `.planning/milestones/v2.1-phases/06-internalise-platform-skills/scripts/phase6-structure-check.sh` (281 lines, fully reusable). SKILL.md body conventions live in `.planning/codebase/CONVENTIONS.md` § "SKILL.md body structure" (lines 185-201), not in `STRUCTURE.md` as CONTEXT.md claims.
2. **One terminology drift in DESIGN.md glossary vs the design body.** DESIGN.md line 1482 (glossary) defines `kickoff_branch` enum as `kickoff-direct | discovery-via`, but DESIGN-17 body (line 562), the roadmap success criteria, and CONTEXT.md all use `discovery-ready | draft-sow`. The **body/roadmap/CONTEXT spelling is authoritative** per CONTEXT decisions D-69/D-77 and roadmap criterion #1 wording. The planner must NOT lift the glossary spelling.

**Primary recommendation:** Plan 07-01 lifts the phase6 bash skeleton wholesale and re-partitions `--section` to `kickoff|discovery|sow`. Plans 07-02 / 07-03 carry surgical-edit task lists keyed off the exact line numbers documented below — no rewrites of the existing v0.3.0 SKILL.md bodies. Synthesis stays folded inside 07-03 (predicted LOC well below the ~400 threshold; see §10).

## Architectural Responsibility Map

| Capability | Primary Tier | Secondary Tier | Rationale |
|------------|-------------|----------------|-----------|
| Kickoff artefact authorship + branch routing field | Plugin skill (`kickoff-capture/SKILL.md`) | — | Stage 1 is the entry tier; no upstream artefact exists |
| Auto-classification confidence rubric | Plugin reference (`kickoff-capture/references/auto-classify-rubric.md`) | Plugin skill (consumer) | Splitting to `references/` keeps SKILL.md body ≤v0.3.0 norm |
| Capture-paths protocol (paste/Miro/Field Notes) | Plugin reference (`kickoff-capture/references/capture-paths.md`) | Plugin skill (consumer) | Operational protocol — paste-only per D-72 |
| Kickoff template body | Plugin reference (`kickoff-capture/references/kickoff-template.md`) | — | Mirrors existing `*-template.md` convention |
| Branch-routing fan-out READ (Stage 2 + Stage 3) | Plugin skill body (`discovery-intake/SKILL.md`, `generate-sow/SKILL.md`) | Frontmatter contract owner = kickoff | Read-only consumers per D-77 cross-section assert |
| Phase shape verification | Bash script (`scripts/phase7-structure-check.sh`) | — | Self-verifies via `grep -qF` / `grep -qE` against on-disk SKILL.md text |
| Reviewer ergonomics (skip-branch UX, audit trail) | Plugin skill body (`discovery-intake/SKILL.md` Step N) | git history + handoff log | D-74: no marker file; stdout emit only |

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

**D-69 — Plan slicing: 3 per-skill atomic plans (D-63 precedent)**

| Plan | Scope | Requirements | Depends on | Parallel-eligible |
|---|---|---|---|---|
| `07-01-PLAN.md` | `skills/kickoff-capture/` SKILL.md + 3 `references/` files end-to-end + ships `scripts/phase7-structure-check.sh` with `--section <kickoff\|discovery\|sow>` (Wave 0-equivalent) | STG1-01..05 | — | — |
| `07-02-PLAN.md` | `skills/discovery-intake/SKILL.md` modifications — consume kickoff, RETIRE raw-notes path, verbatim skip-message on `draft-sow` | STG2-01..03 | 07-01 (kickoff frontmatter contract + structure-check `--section discovery`) | Yes (disjoint dir from 07-03) |
| `07-03-PLAN.md` | `skills/generate-sow/SKILL.md` modifications — lock canonical lifecycle + dual-scope H2s + synthesis (OPEN-Q row flips + e2e smoke against sample CR + `--all` structure-check) | STG3-01..02 + synthesis | 07-01 | Yes (disjoint dir from 07-02) |

Synthesis-folding rule: split to `07-04-PLAN.md` if plan 3 content >~400 LOC.

**D-70** — `kickoff-template.md` authored by planner from STG1-04 8-category list + STG1-02 routing field + STG1-03 triage + STG1-04 marker convention. Lift-and-fix precedence — planner checks DESIGN-17 for any literal blocks first (per research below: **none exist**); falls back to author-from-categories.

**D-71** — `kickoff-capture/references/` shape = exactly 3 files: `kickoff-template.md`, `auto-classify-rubric.md`, `capture-paths.md` (mirrors `execute-tests/references/` multi-ref pattern, not `discovery-intake/references/` template-only pattern).

**D-72** — Field Notes Coda access path = **doc-only paste protocol**. No MCP call, no Coda API curl, no probe hook ships in v2.2. Future Coda MCP captured as Deferred (v2.6 / SURF-01..03).

**D-73** — Auto-classification rubric body = 3-5 explicit triggers + input-signal → outcome escalation table + operational principle backstop. Triggers itemised in CONTEXT.md D-73 verbatim (category not named verbatim; <2 distinct source mentions; explicit TBD/?/unclear text; conflicting alternatives unresolved; reviewer-pre-flagged TBD).

**D-74** — `discovery-intake` skip emit on `kickoff_branch: draft-sow` = pure stdout / handoff message; exits without writing any artefact (no `02_discovery_v0_SKIPPED.md` marker file). Verbatim message: `Stage 2 SKIPPED — kickoff branch = draft-sow`.

**D-75** — `generate-sow` SOW body for STG3-02 = two H2 sections inside the single SOW artefact: `## Platform Scope` + `## Integration Scope`. No frontmatter `scope:` array (would require DESIGN-19 amendment — rejected). Lenient-mode reads v0.3.0 single-narrative `## Scope` per DESIGN-08.

**D-76** — Lenient v0.3.0 reconciliation = lenient-read OK, enforce `based_on_kickoff:` MANDATORY on **writes from v2.2+ only**. `validate-frontmatter` hook implementation deferred to v2.6 (SURF-01..03); write-path enforcement documented in SKILL.md body for now.

**D-77** — Single `scripts/phase7-structure-check.sh` with `--section <kickoff|discovery|sow|all>` partitioning. Sections + asserts itemised in CONTEXT.md D-77 verbatim.

### Claude's Discretion

- Detailed template body wording inside `kickoff-template.md` — author from STG1 + DESIGN-17 categories per D-70; only the H2 section list is locked.
- Specific trigger thresholds inside `auto-classify-rubric.md` (e.g., whether "<2 distinct source mentions" should be "<3") — planner picks during research; adjustable at execute time.
- Exact wording of `## Platform Scope` / `## Integration Scope` section descriptions in SOW template.
- Plan-task counts inside each per-skill plan.
- Whether 07-03 splits to 07-04 (~400 LOC threshold from D-69).
- Existence of any STG1/STG2/STG3 OPEN-Q rows — researcher checks; resolved inline per D-67 (**finding: zero rows exist**; see §1 below).

### Deferred Ideas (OUT OF SCOPE)

- Coda MCP integration for Field Notes (v2.6 / SURF-01..03 candidate).
- Stage 1 → Stage 2/3 auto-progression hook (approval gates non-negotiable per DESIGN-06).
- Auto-migration of legacy v0.3.0 `00_discovery_v*.md` / `01_sow_v*.md` artefacts (lenient-read only per DESIGN-08).
- Frontmatter `scope:` array on SOW (rejected — DESIGN-19 amendment needed).
- Always-mark-default rubric mode (rejected — reviewer load disproportionate to signal).
- Marker file on `draft-sow` skip (rejected per D-74 — violates verbatim "writes no artefact").
- MCP integrations (UAT-3.5 — paste-only through v2.6).
- Native-AI ingestion APIs (UAT-6.1 — paste-only through v2.6).
- New platform skills (v2.1 sealed catalogue at Pipefy + Wrike + Ziflow).
- `validate-frontmatter` / `bump-artefact-version` hook bodies (deferred to v2.6).

</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description (verbatim from REQUIREMENTS.md) | Research Support |
|----|----|----|
| **STG1-01** | `kickoff-capture/` skill exists at `dydx-delivery/skills/kickoff-capture/` with `SKILL.md` (+ standard `references/` shape where applicable), points at canonical references (`safety-rules.md`, `stage-numbering.md`, `frontmatter-scheme.md`, `glossary.md`) per FOUND-01..04, and produces `01_kickoff_v<N>.md` artefact per DESIGN-02 file-prefix scheme. | §2 DESIGN-17 lift map; §6 canonical-pointer pattern; §4 SKILL.md body landmarks |
| **STG1-02** | Kickoff artefact carries a single `kickoff_branch:` enum field on frontmatter — `discovery-ready` routes to Stage 2; `draft-sow` SKIPS Stage 2 → Stage 3. Both downstream stages read this same field; no separate routing flags. (DESIGN-17+18+19) | §2 DESIGN-17 frontmatter; §11 glossary-vs-body terminology mismatch flag |
| **STG1-03** | Field Notes triage filter defaults to `processed_at IS NULL` per DESIGN-09. Field Notes Coda table is read-only input queue; kickoff never auto-merges entries (MOD-8 prevention — quote + ask keep/drop/edit-and-keep). | §2 DESIGN-17 key-decision #2; D-72 doc-only paste |
| **STG1-04** | Auto-classification into 8 sections (system/users/triggers/data/rules/integrations/exceptions/failure-points) emits explicit `[unknown — needs human classification]` inline markers where confidence is low. | §2 DESIGN-17 key-decision #4; D-73 rubric body |
| **STG1-05** | Capture paths: (a) meeting-notes paste freeform; (b) Miro paste fallback per DESIGN-07+AUDIT-08; (c) Field Notes Coda table read. No raw-notes-direct-to-discovery shortcut. | §2 DESIGN-17 key-decision #3; D-72 paste-only |
| **STG2-01** | `discovery-intake/` MODIFIED to consume `01_kickoff_v<N>.md` as sole upstream artefact. `based_on_kickoff:` MANDATORY on every new `02_discovery_v<N>.md`. Raw-notes entry path RETIRED. | §4 surgical-edit landmarks (Inputs + Step 1 + Step 5); D-76 write-path enforcement |
| **STG2-02** | On `kickoff_branch: draft-sow`, emit `Stage 2 SKIPPED — kickoff branch = draft-sow` hand-off message; exit without writing artefact. | §4 Step N landmark; D-74 stdout-only; §7 verbatim string asserted by structure-check |
| **STG2-03** | Same discovery template structure as v0.3.0 (8 sections). Only upstream contract + skip behaviour change; body unchanged. | §5 intake-template.md confirmed UNCHANGED (157 lines, body structurally aligned with 8 categories) |
| **STG3-01** | `generate-sow/` status lifecycle locked to canonical `draft → client_review → approved → archived` per DESIGN-08. `client_review` retained explicitly per AUDIT-01.2 + DESIGN-08. | §4 surgical-edit landmark — Step 5 frontmatter block + handoff message (line 93 references `status:` lifecycle) |
| **STG3-02** | Single SOW covers both platform AND integration scope (no Stage 3 split — happens at Stage 4 per DESIGN-20). | §5 sow-template.md landmark — `## 2. In-scope deliverables` (line 26) needs split to `## Platform Scope` + `## Integration Scope` H2s per D-75 |

</phase_requirements>

## 1. OPEN-QUESTIONS.md scan — STG1/STG2/STG3 rows

**Finding: ZERO STG1-*, STG2-*, or STG3-* rows exist in `.planning/OPEN-QUESTIONS.md`.**

Verification: searched the register for tokens `STG1`, `STG2`, `STG3` — no matches. All existing OPEN-Q rows are Q01..Q26-style (legacy register numbering, not STG-prefixed). Of those, the only rows that touch v2.2 scope are:
- Q06.2 (Pipefy throttle) — `decided` 2026-05-10 (v2.1 closure)
- Q07.2 (Wrike throttle) — `decided` 2026-05-10 (v2.1 closure)
- Q15 (status-lifecycle survey re-run) — `decided` 2026-05-10 (re-run at Phase 1 kickoff — already executed)
- Q22 / Q23 (commercial inputs / refine commands / pytest tests / hub anchors) — all marked `decided` 2026-05-10

**Planner implication.** The synthesis section in 07-03 (or 07-04 if split) **does not** need to flip any STG-named OPEN-Q register row. D-67 inline-resolution requirement is **vacuously satisfied** for Phase 7. The synthesis block instead carries: (a) e2e smoke against sample CR, (b) `--all` structure-check run, and (c) REQUIREMENTS.md traceability checkbox flips (10 boxes: STG1-01..05 + STG2-01..03 + STG3-01..02).

Confidence: **HIGH** [VERIFIED: grep `.planning/OPEN-QUESTIONS.md` for STG1|STG2|STG3 — 0 matches].

## 2. DESIGN-17/18/19 literal-content extraction

Read `.planning/DESIGN.md` lines 547-664 (DESIGN-17 + DESIGN-18 + DESIGN-19 in full). The three design rows carry **shape + frontmatter + verbatim hand-off message + key-decision narrative — NOT literal template body, rubric body, capture-paths body, or SKILL.md prose**. Lift map:

### DESIGN-17 (lines 547-585) — Kickoff capture

| What's there | Lift verbatim? | Where it goes |
|---|---|---|
| Skill name `kickoff-capture/` | Yes | SKILL.md H1 + directory name |
| File prefix `01_kickoff_*` per DESIGN-02 | Yes | SKILL.md Output section |
| Frontmatter fields list (line 562): `client:`, `project:`, `frontmatter_version: 2`, `kickoff_branch: discovery-ready \| draft-sow`, `field_notes_processed_count: <N>`, `status: draft` | Yes — verbatim block | kickoff-template.md frontmatter; SKILL.md Step 5 frontmatter example |
| Branch routing key-decision (line 563-565): `discovery-ready` → Stage 2; `draft-sow` → SKIP Stage 2 → Stage 3 | Yes | SKILL.md Step 4 (routing decision) + structure-check `--section kickoff` assertion |
| Auto-classification marker convention `[unknown — needs human classification]` (line 566) | Yes — verbatim string | kickoff-template.md section bodies + structure-check `--section kickoff` assertion + auto-classify-rubric.md operational principle |
| Hand-off message (line 574): "Awaiting status: approved write to 01_kickoff_v<N>.md. Branch routing on kickoff_branch: value (discovery-ready -> Stage 2; draft-sow -> SKIP Stage 2 -> Stage 3)." | Yes — verbatim | SKILL.md final Step (Write and hand off) |
| 4 key v2 decisions (lines 578-581): dual-branch / Field Notes triage / Miro paste fallback / auto-classification markers | Author from — informs key-decisions block in SKILL.md but no literal prose to lift |
| 8 category section names (line 581): `system / users / triggers / data / rules / integrations / exceptions / failure-points` | Yes — verbatim, in this order | kickoff-template.md H2 sections; auto-classify-rubric.md rubric input |

**Crucial:** DESIGN-17 contains **NO literal template body**, **NO rubric body**, **NO capture-paths protocol body**. Planner authors all three reference-file bodies per D-70 / D-73 / D-72 author-from-categories fallback.

### DESIGN-18 (lines 587-623) — Discovery refactor

| What's there | Lift verbatim? | Where it goes |
|---|---|---|
| Skill name `discovery-intake/` MODIFIED; raw-notes mode RETIRED | Yes | SKILL.md Inputs surgical edit |
| Inputs (line 595-598): `based_on_kickoff:` MANDATORY; upstream = `01_kickoff_v<N>.md`; raw-notes RETIRED | Yes — verbatim policy | SKILL.md Inputs section rewrite |
| Skip behaviour contract (line 604) — "emits an explicit 'Stage 2 SKIPPED — kickoff produced draft SOW; routing to Stage 3' hand-off and exits without writing a `02_discovery_v<N>.md` artefact" | **WARNING — DOES NOT MATCH STG2-02 / D-74 / ROADMAP**: DESIGN-18 line 604 says "kickoff produced draft SOW; routing to Stage 3"; STG2-02 + D-74 + Roadmap criterion #3 say verbatim `Stage 2 SKIPPED — kickoff branch = draft-sow`. **See §11 — flagged for planner.** Authoritative spelling = STG2-02 / D-74 / Roadmap. | SKILL.md Step N + structure-check `--section discovery` literal-string assertion |
| Hand-off message (line 612): "Awaiting status: approved write to 02_discovery_v<N>.md before generate-sow runs." | Yes — verbatim | SKILL.md final Step (Write and hand off) |
| 4 key v2 decisions (lines 614-619): raw-notes RETIRED / kickoff-as-input forces explicit `based_on_kickoff:` / skip-when-draft-SOW reads `kickoff_branch:` / template structurally unchanged | Yes — informs key-decisions block | SKILL.md narrative |

### DESIGN-19 (lines 627-664) — SOW refactor

| What's there | Lift verbatim? | Where it goes |
|---|---|---|
| Frontmatter inputs (lines 635-636): `based_on_discovery: 02_discovery_v<N>` + `based_on_kickoff: 01_kickoff_v<N>` (one or the other, not both) | Yes — verbatim policy | SKILL.md Inputs surgical edit + Step 5 frontmatter block |
| Frontmatter outputs (line 643): "`based_on_discovery:` OR `based_on_kickoff:` (one or the other, not both); `client:`, `project:`, `frontmatter_version: 2`, `platform:` (if known); `status: draft → client_review → approved`" — `client_review` retained per AUDIT-01.2 + DESIGN-08 | Yes — verbatim | SKILL.md Step 5 frontmatter block |
| Single-spec scope contract (line 645): "ONE SOW covers BOTH platform work and integration work for a project — no Stage-3 split. The Stage 4 fnspec is where platform/integration split happens" | Yes — informs SKILL.md narrative + STG3-02 D-75 dual-H2 split | sow-template.md ## Platform Scope + ## Integration Scope sections |
| Hand-off message (line 653): "Awaiting status: approved on 03_sow_v<N>.md; routing to Stage 4a (platform fnspec) and/or Stage 4b (integration fnspec) per project scope." | Yes — verbatim | SKILL.md final Step (Write and hand off) |
| 4 key v2 decisions (lines 657-660): canonical 4-stage lifecycle / `client_review` retained / single SOW covers both / structurally unchanged from v0.3.0 | Yes — informs narrative | SKILL.md key-decisions / Quality bar |

**Crucial:** DESIGN-19 carries the canonical lifecycle string `draft → client_review → approved → archived` (lines 643 + 657) — that's the exact text the structure-check `--section sow` assertion checks for, and what the planner pastes into `sow-template.md` frontmatter + SKILL.md Step 5 handoff text.

## 3. phase6-structure-check.sh bash skeleton (lift target for D-77)

Source: `.planning/milestones/v2.1-phases/06-internalise-platform-skills/scripts/phase6-structure-check.sh` (281 lines, fully readable).

**Skeleton parts the planner adapts:**

| Element | Lines | Lift verbatim? |
|---|---|---|
| Shebang + comment-vs-code policy banner | 1-40 | Adapt — re-title `phase7` + describe `--section <kickoff\|discovery\|sow>` partition |
| `set -euo pipefail` | 41 | Yes — verbatim |
| `fail()` / `pass()` helpers | 43-44 | Yes — verbatim |
| Arg parser with `--section` / `--quick` / `--help` / unknown-arg branches | 46-68 | Adapt — update USAGE block to list `kickoff\|discovery\|sow` |
| `run_<section>_section()` function shape (one per section) | 74-228 (3 funcs) | Adapt body — replace per-platform asserts with per-section asserts per D-77 |
| `run_cross_tree_section()` for full-run-only cross-tree asserts (A7 forbidden-token gate; A16 OPEN-Q row flips via `awk` between-headings extraction) | 234-265 | **Re-purpose** — the D-77 cross-section assert is "the kickoff frontmatter contract referenced from discovery + sow body matches the canonical field name". Replace A7/A16 body with `kickoff_branch:` + `based_on_kickoff:` cross-references. The `awk`-between-headings OPEN-Q flip is **not needed** (zero STG-rows per §1). |
| `case "$SECTION" in ... esac` dispatcher | 271-277 | Adapt branch names to `kickoff\|discovery\|sow\|""` |
| Exit-code conventions: `fail()` → `exit 1`; success path → `echo "ALL ASSERTIONS PASSED"` + `exit 0` | 43, 279-280 | Yes — verbatim |
| G-2 exclude-dirs convention (`--exclude-dir=scripts --exclude='*.sh' --exclude='*~'`) for recursive forbidden-token greps | 14-18, 247 | Yes — verbatim; needed if any forbidden-token grep ships (e.g., "no raw-notes input path leaked in discovery-intake/SKILL.md") |

**Concrete D-77 assertion bodies (planner can copy-shape directly):**

```bash
run_kickoff_section() {
  # K1 — kickoff-capture SKILL.md exists
  [ -f dydx-delivery/skills/kickoff-capture/SKILL.md ] \
    || fail "K1: dydx-delivery/skills/kickoff-capture/SKILL.md missing"
  pass "K1: kickoff-capture SKILL.md exists"

  # K2 — 3 references/ files exist
  local ref
  for ref in kickoff-template.md auto-classify-rubric.md capture-paths.md; do
    [ -f "dydx-delivery/skills/kickoff-capture/references/$ref" ] \
      || fail "K2: missing references/$ref"
  done
  pass "K2: 3 references/ files exist"

  # K3 — canonical-reference pointers resolve from SKILL.md
  for canonical in safety-rules.md stage-numbering.md frontmatter-scheme.md glossary.md; do
    grep -qF "dydx-delivery/references/$canonical" dydx-delivery/skills/kickoff-capture/SKILL.md \
      || fail "K3: canonical pointer '$canonical' missing from SKILL.md"
    [ -f "dydx-delivery/references/$canonical" ] \
      || fail "K3: canonical target dydx-delivery/references/$canonical does not exist"
  done
  pass "K3: 4 canonical pointers resolve"

  # K4 — kickoff_branch enum present in template with both values
  grep -qE '^kickoff_branch: (discovery-ready|draft-sow)$' \
    dydx-delivery/skills/kickoff-capture/references/kickoff-template.md \
    || fail "K4: kickoff_branch enum (discovery-ready|draft-sow) missing from template"
  pass "K4: kickoff_branch enum present"

  # K5 — [unknown — needs human classification] marker documented
  grep -qF '[unknown — needs human classification]' \
    dydx-delivery/skills/kickoff-capture/SKILL.md \
    || fail "K5: marker convention missing from SKILL.md"
  pass "K5: unknown-marker convention documented"

  # K6 — processed_at IS NULL documented in capture-paths.md
  grep -qF 'processed_at IS NULL' \
    dydx-delivery/skills/kickoff-capture/references/capture-paths.md \
    || fail "K6: processed_at IS NULL filter wording missing"
  pass "K6: Field Notes triage filter documented verbatim"

  # K7 — auto-classify-rubric.md referenced from SKILL.md
  grep -qF 'references/auto-classify-rubric.md' \
    dydx-delivery/skills/kickoff-capture/SKILL.md \
    || fail "K7: SKILL.md does not reference auto-classify-rubric.md"
  pass "K7: auto-classify-rubric.md referenced from SKILL.md"
}

run_discovery_section() {
  # D1 — based_on_kickoff MANDATORY documented for write-path
  grep -qF 'based_on_kickoff' dydx-delivery/skills/discovery-intake/SKILL.md \
    || fail "D1: based_on_kickoff field reference missing"
  grep -qiE '(MANDATORY|required)' dydx-delivery/skills/discovery-intake/SKILL.md \
    || fail "D1: write-path enforcement policy missing"
  pass "D1: based_on_kickoff MANDATORY documented"

  # D2 — raw-notes RETIRED error/message present
  grep -qiE 'raw[- ]notes.*(RETIRED|removed|no longer)' \
    dydx-delivery/skills/discovery-intake/SKILL.md \
    || fail "D2: raw-notes RETIRED message missing"
  pass "D2: raw-notes RETIRED documented"

  # D3 — verbatim skip-message present (single source of truth)
  grep -qF 'Stage 2 SKIPPED — kickoff branch = draft-sow' \
    dydx-delivery/skills/discovery-intake/SKILL.md \
    || fail "D3: verbatim skip-message missing"
  pass "D3: verbatim skip-message present"
}

run_sow_section() {
  # S1 — canonical 4-state lifecycle present
  grep -qF 'draft → client_review → approved → archived' \
    dydx-delivery/skills/generate-sow/SKILL.md \
    || grep -qF 'draft → client_review → approved → archived' \
       dydx-delivery/skills/generate-sow/references/sow-template.md \
    || fail "S1: canonical 4-state lifecycle string missing"
  pass "S1: canonical lifecycle present"

  # S2 — ## Platform Scope + ## Integration Scope H2s in template
  grep -qE '^## Platform Scope' \
    dydx-delivery/skills/generate-sow/references/sow-template.md \
    || fail "S2: ## Platform Scope H2 missing from template"
  grep -qE '^## Integration Scope' \
    dydx-delivery/skills/generate-sow/references/sow-template.md \
    || fail "S2: ## Integration Scope H2 missing from template"
  pass "S2: dual-scope H2s present"
}

run_cross_section() {
  # X1 — kickoff_branch field name matches across all 3 skills
  for skill in kickoff-capture/references/kickoff-template.md \
               discovery-intake/SKILL.md \
               generate-sow/SKILL.md; do
    grep -qF 'kickoff_branch' "dydx-delivery/skills/$skill" \
      || fail "X1: kickoff_branch reference missing in $skill"
  done
  pass "X1: kickoff_branch field name consistent across 3 skills"

  # X2 — based_on_kickoff field name matches across discovery + sow consumers
  grep -qF 'based_on_kickoff' dydx-delivery/skills/discovery-intake/SKILL.md \
    || fail "X2: based_on_kickoff missing from discovery-intake"
  grep -qF 'based_on_kickoff' dydx-delivery/skills/generate-sow/SKILL.md \
    || fail "X2: based_on_kickoff missing from generate-sow (draft-sow path)"
  pass "X2: based_on_kickoff consistent across consumers"
}

case "$SECTION" in
  kickoff)  run_kickoff_section ;;
  discovery) run_discovery_section ;;
  sow)      run_sow_section ;;
  all|"")   run_kickoff_section; run_discovery_section; run_sow_section; run_cross_section ;;
  *)        fail "unknown --section value: $SECTION (use kickoff|discovery|sow|all)" ;;
esac
```

The planner's 07-01 Wave 0 task ships this script substantially as-shown above. Exact assertion counts can flex; the structure (3 per-section + 1 cross-section + dispatcher) is the lift target.

Confidence: **HIGH** [VERIFIED: phase6-structure-check.sh read in full from disk].

## 4. v0.3.0 SKILL.md body landmarks — surgical-edit insertion points

### `dydx-delivery/skills/discovery-intake/SKILL.md` (149 lines)

| Section | Lines | Surgical edit (per STG2-01..03 + D-74 + D-76) |
|---|---|---|
| Frontmatter `description:` field | 3 | Update: drop "pasted meeting notes / transcript" trigger phrasing; replace with "consume approved kickoff artefact". Description currently advertises raw-notes intake — that path is RETIRED. |
| `## Inputs` | 10-13 | **REPLACE.** Remove "Free-form context: chat, pasted meeting notes, transcript, brief, email thread". Add: "Approved `01_kickoff_v<N>.md` (sole upstream artefact) carrying `status: approved` + `kickoff_branch:` enum". |
| `## Output` | 15-19 | Keep file prefix `02_discovery_vN.md`. Update target path convention if planner harmonises with `<Client> Brain/<Project>/` per DESIGN-17 line 561; current text uses `<Client>/build-specs/<platform>/` (v0.3.0 path) — **out-of-scope per STG2-03 ("body unchanged")**; leave path unchanged. |
| `### Step 1 — Establish target location` | 23-29 | Insert **Step 0 — Locate upstream kickoff** before Step 1 (or rename Step 1). New Step 0 reads `01_kickoff_v<N>.md`; if missing OR not `status: approved` → emit explicit error per CONVENTIONS.md "Start-at-any-point triage convention" with kickoff-routing options. |
| `### Step 1 — Establish target location` | 23-29 | Insert sub-step reading `kickoff_branch:` from kickoff frontmatter. If `draft-sow` → **immediately emit verbatim skip-message + exit (no writes)**. This is the D-74 branch. |
| `### Step 3 — Run the discovery interview` | 38-81 | **Body unchanged per STG2-03.** The 8 discovery dimensions (Business outcome / Users / Systems / Triggers / Data / Rules / Integrations / Exceptions and failure points) stay. Note: current discovery dimensions are **9** items (line 42 lists "Business outcome" as item 1, then Users/Systems/Triggers/Data/Rules/Integrations/Exceptions = 8 more = 9 total). STG1-04 + DESIGN-17 lock the **8-category list to** system/users/triggers/data/rules/integrations/exceptions/failure-points (no "Business outcome"). **Planner note:** kickoff-template.md uses the 8-list verbatim from STG1-04; discovery-intake is **structurally unchanged per STG2-03** so the 9-section dimension list stays — the mismatch is intentional per the requirement spec. Do not "fix" discovery to align with kickoff. |
| `### Step 4 — Identify platform and integrations` | 83-89 | Keep as-is. Platform identification still happens here (kickoff frontmatter doesn't carry `platform:` per DESIGN-17 line 562 — only `kickoff_branch:`). |
| `### Step 5 — Draft the artefact` | 91-107 | **Frontmatter block (lines 97-107) — UPDATE.** Add MANDATORY field `based_on_kickoff: 01_kickoff_v<N>.md`. Drop `captured_by:` / `captured_at:` if planner harmonises to DESIGN-01 (`approved_by:` / `approved_at:` are the canonical names per `frontmatter-scheme.md` — but DESIGN-01 reform is **out of scope per STG2-03 body-unchanged**); recommend keeping `captured_by` / `captured_at` and adding `based_on_kickoff:` alongside. |
| `### Step 6 — Write and hand off` | 109-122 | Update handoff to DESIGN-18 line 612 verbatim text: "Awaiting status: approved write to 02_discovery_v<N>.md before generate-sow runs." Current text (lines 113-122) is a multi-bullet review-steps block — planner replaces with the DESIGN-18 verbatim hand-off. |
| `## Start-at-any-point handling` | 124-130 | **DELETE entirely.** Discovery is no longer the entry skill; kickoff-capture is. The shortcut-inputs paragraph ("I already have a brief", "Just structure these notes") is the raw-notes path RETIRED per STG2-01. |
| `## What this skill does not do` | 132-138 | Add: "Does not accept raw notes — that path is RETIRED. Discovery is a pure transform of an approved kickoff artefact (per DESIGN-18 line 591)." |
| `## Quality bar` | 140-148 | Keep as-is — quality criteria still apply. |

### `dydx-delivery/skills/generate-sow/SKILL.md` (110 lines)

| Section | Lines | Surgical edit (per STG3-01..02 + D-75) |
|---|---|---|
| `## Inputs` | 11-14 | **UPDATE.** Current: "The latest `02_discovery_v*.md` (required)". Replace with: dual input per DESIGN-19 line 635-636 — approved `02_discovery_v<N>.md` (normal path) OR approved `01_kickoff_v<N>.md` (draft-sow path). Note `based_on_kickoff:` is read when Stage 2 was skipped. |
| `### Step 1 — Locate upstream artefact` | 22-34 | **UPDATE.** Triage prompt currently asks for discovery brief paste. Replace with: read upstream kickoff first; if `kickoff_branch: draft-sow` → use kickoff directly (no discovery exists); if `kickoff_branch: discovery-ready` → look for approved `02_discovery_v*.md`. The start-at-any-point triage block (lines 26-32) needs updating to reflect kickoff-as-primary-upstream. |
| `### Step 3 — Draft the SOW` | 41-56 | **Subsection 2 — In-scope deliverables → SPLIT to dual H2 per D-75.** Current text on line 49-50 ("`Pipefy automation` is not a deliverable; `Brief intake form with conditional routing to Studio Lead or Director queue` is.") is the single-list framing — planner adds explicit guidance that deliverables are split into **Platform Scope** items + **Integration Scope** items in the template. Body narrative stays largely intact; template H2 split is the load-bearing change. |
| `### Step 5 — Write and hand off` | 68-95 | **Frontmatter block (lines 72-82) — UPDATE.** Current line 78: `status: draft` — keep, but the SKILL.md body must document the canonical 4-state lifecycle `draft → client_review → approved → archived` per STG3-01. Add: `based_on_kickoff:` field on draft-sow path (or `based_on_discovery:` on normal path — one or the other, not both, per DESIGN-19 line 643). |
| `### Step 5 — Write and hand off` | 84-95 | **Handoff message (lines 86-95) — REPLACE** with DESIGN-19 line 653 verbatim: "Awaiting status: approved on 03_sow_v<N>.md; routing to Stage 4a (platform fnspec) and/or Stage 4b (integration fnspec) per project scope." Current handoff references the v0.3.0 next-stage skill (`generate-functional-spec`) which is being retired in Phase 8 — Phase 7 may either leave this reference or update to Stage 4a/4b; **recommend update to Phase 8 nomenclature** (`generate-fnspec-platform` and/or `generate-fnspec-integration`) to avoid an immediate Phase 8 follow-up edit. Confirm with planner — could be deferred to Phase 8. |
| `## What this skill does not do` | 97-101 | Keep — still accurate. Optionally add: "Does not split scope by platform vs integration at the artefact level; that split happens at Stage 4 (Fnspec) — single SOW carries both as ## Platform Scope + ## Integration Scope H2s (per DESIGN-19 + STG3-02)." |
| `## Quality bar` | 103-110 | Keep — still accurate. |

Confidence: **HIGH** [VERIFIED: both SKILL.md files read line-by-line from disk].

## 5. sow-template.md current location + dual-scope surgical edit

**Confirmed location:** `dydx-delivery/skills/generate-sow/references/sow-template.md` (155 lines, name `sow-template.md` verbatim — no rename needed).

**Surgical edits for D-75 + STG3-01 + STG3-02:**

| Line | Current | Edit |
|---|---|---|
| 6 | `status: draft` | Keep value. Add comment / nearby narrative documenting canonical lifecycle `draft → client_review → approved → archived` (STG3-01). |
| 7 | `based_on_discovery: 02_discovery_v<N>.md` | Replace with dual policy per DESIGN-19 line 643: either `based_on_discovery:` OR `based_on_kickoff:` (one or the other, not both). Add comment indicating the draft-sow path. |
| 26-33 | `## 2. In-scope deliverables` block (single table) | **SPLIT** into two H2 sections per D-75: `## 2. Platform Scope` + `## 3. Integration Scope` (renumber sections 3-11 down by one — or keep "## 2. In-scope deliverables" header and add two H3s underneath — **planner discretion**; the canonical assertion in structure-check is presence of literal H2 headers `## Platform Scope` and `## Integration Scope`, so plain H2 split is the safer path). |
| 22 | `## 1. Business outcome` | Keep. |
| 35 | `## 3. Out-of-scope` | If H2 split lifts deliverables to 2 sections, renumber subsequent sections from 4. |
| 100+ | Various | Update `### Handoff` and `**Next stage reads:**` footer to reference Stage 4a/4b or keep as `generate-functional-spec` for Phase 8 to handle (recommend Phase 8 deferral to keep Phase 7 surgical). |

**Key:** D-75 says **"`## Platform Scope` + `## Integration Scope` H2 sections"** — the literal H2 header text is what the structure-check asserts (assertion S2 in §3 above). Section numbering (`## 2.` vs `## Platform Scope`) is planner discretion; the verifier checks the H2 marker + literal scope-name string.

Confidence: **HIGH** [VERIFIED: sow-template.md read in full].

## 6. Canonical-pointer sentence template (FOUND-04 / D-59 pattern)

Source: `dydx-delivery/skills/platform-pipefy/SKILL.md` lines 25-27 (the only inline canonical-pointer in pipefy SKILL.md body). Pattern is **one block-quoted line per canonical ref**:

```markdown
> **Hard rules:** Sandbox-only operations. Read-write only against named sandbox tenants. Refuses destructive actions. See `dydx-delivery/references/safety-rules.md` for the canonical ruleset.
```

The pattern is `> **<topic>:** <one-line context> See \`dydx-delivery/references/<file>.md\` for the canonical <noun>.`

Cross-check: same exact pattern appears at `platform-wrike/SKILL.md:28` and `platform-ziflow/SKILL.md:27`. This is the **D-59 uniform pointer sentence** documented in Phase 5 / Phase 6.

**Note for planner:** Existing Phase 6 platform skills only carry the **safety-rules.md pointer inline in SKILL.md body**. The other canonical refs (`stage-numbering.md`, `frontmatter-scheme.md`, `glossary.md`) are pointed at **transitively** via `references/` files, not via SKILL.md body. STG1-01 says kickoff-capture "points at canonical references (`safety-rules.md`, `stage-numbering.md`, `frontmatter-scheme.md`, `glossary.md`) per FOUND-01..04" — so **kickoff-capture/SKILL.md must carry all 4 pointer sentences inline** (stronger than the v2.1 platform-skill precedent). Suggested kickoff-capture SKILL.md pointer block:

```markdown
> **Hard rules:** Sandbox-only operations. Refuses destructive actions on production tenants and on the Field Notes Coda table. See `dydx-delivery/references/safety-rules.md` for the canonical ruleset.

> **Stage numbering:** This skill writes `01_kickoff_v<N>.md` per the canonical file-prefix scheme. See `dydx-delivery/references/stage-numbering.md` for the canonical Stage 1 placement + old→new mapping table.

> **Frontmatter scheme:** This skill emits `kickoff_branch:` + `based_on_*` fields per the canonical underscore-snake-case convention. See `dydx-delivery/references/frontmatter-scheme.md` for the canonical scheme + lenient-mode contract.

> **Glossary:** `kickoff_branch:` and `[unknown — needs human classification]` are canonical terms defined in `dydx-delivery/references/glossary.md`.
```

Structure-check K3 asserts presence of all 4 `dydx-delivery/references/<canonical>.md` substrings in kickoff-capture SKILL.md.

Confidence: **HIGH** [VERIFIED: pointer pattern grep'd across 3 Phase 6 platform SKILL.md files].

## 7. `execute-tests/references/` shape — D-71 analog

Source: `ls dydx-delivery/skills/execute-tests/references/` →

| File | Role |
|---|---|
| `results-template.md` | Artefact-body template (the `06_results_v*.md` payload) |
| `safety-rules.md` | Supporting reference (local, predates the centralised `dydx-delivery/references/safety-rules.md` per Phase 5) |

That's a 2-file `references/` (template + supporting ref). The D-71 kickoff-capture target is **3 files** (template + 2 supporting refs) — same multi-ref shape, one file richer.

Compare `discovery-intake/references/` → **1 file** (`intake-template.md` only) — template-only shape.

D-71 explicitly chose the multi-ref shape over template-only, citing v0.3.0 norm preservation (Inputs/Output/How to run/etc. body stays lean by pushing rubric + capture-paths out to `references/`).

Confidence: **HIGH** [VERIFIED: ls of both directories].

## 8. Validation Architecture

### Test Framework

| Property | Value |
|----------|-------|
| Framework | bash + grep (no test framework; structure-check is the verification harness — same as Phase 5 / Phase 6) |
| Config file | none (the script is self-contained per `set -euo pipefail`) |
| Quick run command | `bash .planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/scripts/phase7-structure-check.sh --section <kickoff\|discovery\|sow>` |
| Full suite command | `bash .planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/scripts/phase7-structure-check.sh` (runs all 4 sections + cross-section) |

### Phase Requirements → Test Map

| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| STG1-01 | kickoff-capture/ skill + canonical pointers | structure | `phase7-structure-check.sh --section kickoff` (K1+K2+K3) | ❌ Wave 0 — script ships in 07-01 |
| STG1-02 | `kickoff_branch:` enum in template | structure | `phase7-structure-check.sh --section kickoff` (K4) | ❌ Wave 0 |
| STG1-03 | `processed_at IS NULL` triage default in capture-paths.md | structure | `phase7-structure-check.sh --section kickoff` (K6) | ❌ Wave 0 |
| STG1-04 | `[unknown — needs human classification]` marker convention | structure | `phase7-structure-check.sh --section kickoff` (K5) | ❌ Wave 0 |
| STG1-05 | 3 capture paths documented (paste / Miro / Field Notes) | manual + structure | Manual review of `capture-paths.md`; structure-check asserts file exists (K2) | ❌ Wave 0 |
| STG2-01 | `based_on_kickoff:` MANDATORY documented | structure | `phase7-structure-check.sh --section discovery` (D1) | ❌ Wave 0 |
| STG2-02 | Verbatim skip-message present | structure | `phase7-structure-check.sh --section discovery` (D3) | ❌ Wave 0 |
| STG2-03 | `intake-template.md` body unchanged | manual diff | `git diff dydx-delivery/skills/discovery-intake/references/intake-template.md` (expect empty diff after Phase 7) | n/a |
| STG3-01 | Canonical 4-state lifecycle locked | structure | `phase7-structure-check.sh --section sow` (S1) | ❌ Wave 0 |
| STG3-02 | `## Platform Scope` + `## Integration Scope` H2s in template | structure | `phase7-structure-check.sh --section sow` (S2) | ❌ Wave 0 |
| Cross | `kickoff_branch:` + `based_on_kickoff:` consistent across 3 skills | structure | `phase7-structure-check.sh` (X1+X2) | ❌ Wave 0 |
| E2e | Sample CR kickoff → SOW round-trip | manual + smoke | Synthesis-plan task — see §10 below | ❌ Wave 0 — fixtures author at synthesis |

### Sampling Rate

- **Per task commit:** `bash scripts/phase7-structure-check.sh --section <relevant>` (≤1s, dependency-free)
- **Per wave merge:** Same as per-commit (single-section scope)
- **Phase gate:** `bash scripts/phase7-structure-check.sh` (full suite — runs all sections + cross-section asserts) before `/gsd-verify-work`

### Wave 0 Gaps

- [ ] `.planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/scripts/phase7-structure-check.sh` — adapt from phase6 skeleton per §3; ships inside 07-01 (Wave 0-equivalent per D-77)
- [ ] No framework install — bash + grep are baseline; same as Phase 5 / Phase 6

### Dimension 8 sensor model (Nyquist)

Phase 7 structure-check covers Dimension 8 (structural verification) via 13 asserts spanning:
- 3 file-existence sensors (kickoff SKILL.md + 3 references/ files + script itself)
- 4 canonical-pointer sensors (safety-rules/stage-numbering/frontmatter-scheme/glossary substrings in kickoff SKILL.md)
- 4 literal-string sensors (verbatim `kickoff_branch:` enum / verbatim marker / verbatim skip-message / verbatim 4-state lifecycle string)
- 2 cross-skill consistency sensors (X1 `kickoff_branch` consistency / X2 `based_on_kickoff` consistency)

E2e smoke (Dimension 9, end-to-end) is **manual-only** for Phase 7 — no test framework runs skills end-to-end. The synthesis task runs the kickoff-capture skill against a sample CR, watches it produce `01_kickoff_v<N>.md`, then runs `discovery-intake` (or skips per branch) and `generate-sow`, observing artefacts on disk. See §10 for sample-CR fixture proposal.

## 9. Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|------------|-----------|---------|----------|
| bash | structure-check.sh | ✓ | 5.x (Git Bash on Windows; native bash on \*nix) | — |
| grep (GNU) | structure-check.sh assertions | ✓ | 3.x | — |
| awk | NOT REQUIRED (no OPEN-Q row flips per §1) | — | — | — |
| git | commit verification | ✓ | 2.x | — |
| Claude CLI / skill runner | manual e2e smoke against sample CR | ✓ | — | n/a (manual reviewer runs the skill via standard plugin invocation) |
| Coda MCP / Coda API | NOT REQUIRED (D-72 paste-only) | n/a | — | — |
| Miro MCP / Miro API | NOT REQUIRED (D-72 paste-only — DESIGN-07 paste fallback shape lives in capture-paths.md as protocol doc only) | n/a | — | — |

**Missing dependencies with no fallback:** none.
**Missing dependencies with fallback:** none — Phase 7 ships paste-only protocols per D-72; no live external service calls.

## 10. Plan-3 vs Plan-4 split prediction

**Recommendation: KEEP synthesis folded inside 07-03. Do NOT split to 07-04.**

LOC budget estimate for 07-03:
- `generate-sow/SKILL.md` surgical edits: ~30 LOC of plan content (Inputs update + Step 1 update + Step 3 narrative + Step 5 frontmatter + Step 5 handoff = 5 surgical edits, ~5-6 plan LOC each).
- `generate-sow/references/sow-template.md` surgical edits: ~15 LOC of plan content (frontmatter + ## Platform Scope + ## Integration Scope split).
- Synthesis tasks:
  - E2e smoke against sample CR: ~30 LOC of plan content (one manual reviewer task + sample-CR fixture authorship task)
  - `--all` structure-check run: ~5 LOC of plan content
  - REQUIREMENTS.md trace checkbox flips: ~10 LOC of plan content (10 checkboxes to flip)
  - OPEN-QUESTIONS.md row flips: **0 LOC** (zero STG rows per §1 — vacuous)

**Estimated total LOC for 07-03: ~90-110 LOC.** Well below the ~400 LOC threshold from D-69. **Keep folded.**

## 10b. Sample CR for e2e smoke — does one exist?

**No sample CR exists in the repo** for Phase 7 e2e smoke. Searched:
- `dydx-delivery/skills/*/references/` for `_v*.md` fixtures → none
- `.planning/phases/` for sample-CR fixtures → none
- Repo root for `<Client> Brain/` paths → none

**Proposal:** synthesis plan in 07-03 (or 07-04 if split) authors a minimal sample CR fixture under `.planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/fixtures/` with **three small input files**:

```
fixtures/
├── sample-cr-meeting-notes.md         # Freeform paste fixture (~30 lines)
├── sample-cr-miro-paste.md            # Image-paste shape per DESIGN-07 / AUDIT-08 (text describing a workflow, ~15 lines)
└── sample-cr-field-notes.md           # 2-3 mock Field Notes rows with processed_at IS NULL (~20 lines)
```

The reviewer task in the synthesis plan: paste each fixture into a `kickoff-capture` invocation, observe a `01_kickoff_v<N>.md` artefact at the expected output path, then run `discovery-intake` (one variant per branch) and `generate-sow`. Pure manual + visual inspection — no automated assert.

**Fixture file path proposal is non-binding** — planner may choose a different location (e.g., a `<Client> Brain/` test-client folder) if it better matches the documented output paths in DESIGN-17 line 561. Recommend `.planning/phases/` for clarity and discoverability.

## 11. Risk inventory — CONTEXT.md vs source-of-truth mismatches

**Five issues flagged for planner resolution at write time:**

### R-01 (HIGH) — Verbatim skip-message conflict between DESIGN-18 and STG2-02 / D-74 / Roadmap

| Source | Literal text |
|---|---|
| DESIGN-18 line 604 | `Stage 2 SKIPPED — kickoff produced draft SOW; routing to Stage 3` |
| STG2-02 (REQUIREMENTS.md line 37) | `Stage 2 SKIPPED — kickoff branch = draft-sow` |
| D-74 (07-CONTEXT.md line 107) | `Stage 2 SKIPPED — kickoff branch = draft-sow` |
| Roadmap criterion #3 (ROADMAP.md line 68) | `Stage 2 SKIPPED — kickoff branch = draft-sow` |

**Authoritative per CONTEXT.md decisions D-74:** the STG2-02/D-74/Roadmap spelling (`Stage 2 SKIPPED — kickoff branch = draft-sow`) wins; DESIGN-18 line 604 is a pre-CONTEXT.md drafting artefact. The structure-check D3 assertion verifies the authoritative string.

**Planner action:** use the STG2-02/D-74 spelling verbatim in `discovery-intake/SKILL.md`. Do not lift DESIGN-18 line 604 prose; lift the policy intent only.

### R-02 (MEDIUM) — Glossary spelling drift for `kickoff_branch` enum

| Source | Enum values |
|---|---|
| DESIGN.md line 1482 (glossary) | `kickoff-direct \| discovery-via` |
| DESIGN-17 line 562 body | `discovery-ready \| draft-sow` |
| STG1-02 (REQUIREMENTS.md line 27) | `discovery-ready \| draft-sow` |
| D-69/D-77 (CONTEXT.md) | `discovery-ready \| draft-sow` |
| Roadmap criterion #1 | `discovery-ready \| draft-sow` |

**Authoritative spelling:** `discovery-ready | draft-sow` (4 sources agree; glossary is the outlier).

**Planner action:** in the synthesis section of 07-03, **propose** flipping glossary line 1482 to align. This is a documentation hygiene fix, not a STG-numbered OPEN-Q. The planner may either: (a) bundle the glossary update into 07-03 synthesis (recommend); or (b) leave it as a Phase 8 follow-up. The structure-check `--section kickoff` K4 assertion enforces the authoritative spelling on the template file.

### R-03 (LOW) — CONTEXT.md references non-existent file

CONTEXT.md `<canonical_refs>` section line 190 cites `.planning/codebase/PATTERNS.md` — **this file does not exist**. The phase6 bash skeleton lives in `.planning/milestones/v2.1-phases/06-internalise-platform-skills/scripts/phase6-structure-check.sh` (verified). Also CONTEXT.md line 188 cites `.planning/codebase/STRUCTURE.md` § "SKILL.md body structure" — the section title is actually in `.planning/codebase/CONVENTIONS.md` § "SKILL.md body structure" (verified at lines 185-201).

**Planner action:** use the actual file paths (`CONVENTIONS.md` + `phase6-structure-check.sh`) in plan task references. No CONTEXT.md edit required (CONTEXT.md is a decision record, not a live index).

### R-04 (LOW) — Discovery-intake 9-section vs kickoff 8-section dimension mismatch

`discovery-intake/SKILL.md` Step 3 enumerates 9 dimensions (Business outcome + Users + Systems + Triggers + Data + Rules + Integrations + Exceptions and failure points + [implicit 9th from auto-classification]). DESIGN-17 STG1-04 locks the 8-category kickoff list at: `system / users / triggers / data / rules / integrations / exceptions / failure-points` (no "Business outcome"). **STG2-03 forbids structural changes to discovery.**

**Planner action:** explicitly note in 07-02 that the discovery 9-section / kickoff 8-section split is intentional per STG2-03 body-unchanged contract. The kickoff template uses the 8-list; discovery template uses the 9-list. **Do not "fix" discovery to align with kickoff.** Auto-classify-rubric.md inputs are the 8 kickoff categories — not the 9 discovery dimensions.

### R-05 (LOW) — generate-sow handoff message references about-to-retire skill

`generate-sow/SKILL.md` line 95 currently references `generate-functional-spec` as the next stage. v0.3.0 `generate-functional-spec/` is RETIRED in Phase 8 (per STG4-03). Phase 7 may either:
- (a) Update handoff to Stage 4a/4b nomenclature pre-emptively (cleaner — avoids a Phase 8 follow-up)
- (b) Leave as-is and let Phase 8 update during the retirement task

**Planner action:** recommend (a). DESIGN-19 line 653 verbatim handoff already uses the new naming ("routing to Stage 4a (platform fnspec) and/or Stage 4b (integration fnspec) per project scope"). Drop-in replacement, no inference required.

## Project Constraints (from CLAUDE.md)

No `./CLAUDE.md` file exists at repo root (verified via `ls`). No project-level constraint directives to extract. Project-level locks live in `.planning/PROJECT.md` § "Out of Scope" (UAT-3.5 / UAT-6.1 / UAT-3.1 / D-65 / D-67) — already captured in `<user_constraints>` Deferred Ideas above.

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | Authoritative skip-message spelling is `Stage 2 SKIPPED — kickoff branch = draft-sow` (STG2-02/D-74/Roadmap) over DESIGN-18 line 604 alt spelling | §11 R-01 | Structure-check D3 assertion uses the wrong string → false-PASS or false-FAIL. **Resolution: planner consults user inline if uncertain; the 3-vs-1 source vote + post-CONTEXT.md decision precedence is strong.** |
| A2 | Authoritative enum is `discovery-ready \| draft-sow` (4 sources) over `kickoff-direct \| discovery-via` (glossary only) | §11 R-02 | Structure-check K4 assertion uses wrong enum → false-PASS or false-FAIL. **Resolution: planner aligns glossary in 07-03 synthesis.** |
| A3 | `<Client> Brain/<Project>/` output path (DESIGN-17 line 561) vs `<Client>/build-specs/<platform>/` (v0.3.0 SKILL.md path) — leaving v0.3.0 path unchanged in discovery + sow per STG2-03 "body unchanged" + STG3 "structurally unchanged" | §4 surgical-edit tables | If reviewer expects DESIGN-17-aligned paths in v2 artefacts, the visible inconsistency could surface during e2e smoke. **Resolution: deferred to v2.6 / SURF-01..03 path harmonisation pass; flagged for awareness only.** |
| A4 | Synthesis plan size estimate (~90-110 LOC) | §10 | If actual content >400 LOC, planner splits to 07-04. **Resolution: planner re-measures at write time; threshold is mechanical.** |
| A5 | Sample-CR fixtures author into `.planning/phases/07-.../fixtures/` (proposed location only) | §10b | Different fixture location may better match reviewer ergonomics. **Resolution: planner discretion.** |

## Open Questions

1. **Should glossary `kickoff_branch:` enum be aligned in Phase 7 or Phase 8?**
   - What we know: DESIGN.md line 1482 carries `kickoff-direct | discovery-via` (outlier vs 4 other sources). All other Phase 7 deliverables use `discovery-ready | draft-sow`.
   - What's unclear: whether the planner bundles the glossary fix into 07-03 synthesis or punts to Phase 8.
   - Recommendation: bundle in 07-03 synthesis. ~3 LOC of glossary edit text; mechanical fix; avoids stranding the inconsistency.

2. **Should `generate-sow/SKILL.md` line 95 handoff text update to Stage 4a/4b pre-emptively?**
   - What we know: DESIGN-19 line 653 already specifies the new handoff text. v0.3.0 `generate-functional-spec` retires in Phase 8 per STG4-03.
   - What's unclear: whether Phase 7 makes this hygiene fix or Phase 8 picks it up during the retirement task.
   - Recommendation: Phase 7 makes the fix (single-line surgical edit; avoids a Phase 8 dependency).

3. **Does the kickoff Step 4 routing happen in `kickoff-capture/SKILL.md` Step 4 or via a separate "routing branch" Step?**
   - What we know: DESIGN-17 routes via the `kickoff_branch:` frontmatter value, not a runtime decision step.
   - What's unclear: whether the kickoff SKILL.md body documents the routing decision as a numbered Step (e.g., "Step 4 — Classify branch") or as guidance inside the template body.
   - Recommendation: numbered Step in SKILL.md body — matches the start-at-any-point body-structure norm (`### Step N — <title>` pattern per CONVENTIONS.md line 193).

## Sources

### Primary (HIGH confidence)
- `.planning/DESIGN.md` lines 547-585 (DESIGN-17), 587-623 (DESIGN-18), 627-664 (DESIGN-19); line 1482 (glossary entry — flagged outlier per §11 R-02)
- `.planning/REQUIREMENTS.md` lines 22-46 (STG1-01..05 / STG2-01..03 / STG3-01..02 verbatim)
- `.planning/ROADMAP.md` lines 61-70 (Phase 7 § with 5 success criteria verbatim)
- `.planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/07-CONTEXT.md` (D-69..D-77 + Claude's Discretion + Deferred Ideas)
- `.planning/milestones/v2.1-phases/06-internalise-platform-skills/scripts/phase6-structure-check.sh` (281-line bash skeleton — direct lift template)
- `.planning/milestones/v2.1-phases/06-internalise-platform-skills/06-CONTEXT.md` (D-63 per-platform atomic precedent + verification gates)
- `dydx-delivery/skills/discovery-intake/SKILL.md` (149 lines — surgical-edit target for 07-02)
- `dydx-delivery/skills/discovery-intake/references/intake-template.md` (157 lines — confirmed UNCHANGED per STG2-03)
- `dydx-delivery/skills/generate-sow/SKILL.md` (110 lines — surgical-edit target for 07-03)
- `dydx-delivery/skills/generate-sow/references/sow-template.md` (155 lines — D-75 dual-H2 edit target)
- `dydx-delivery/skills/platform-pipefy/SKILL.md` line 27 (canonical-pointer sentence exemplar — D-59 pattern)
- `dydx-delivery/references/frontmatter-scheme.md` lines 1-55 (canonical 4-state lifecycle + underscore-snake-case field-name convention)
- `.planning/codebase/CONVENTIONS.md` lines 185-201 (SKILL.md body structure — actual location, not STRUCTURE.md as CONTEXT.md claims)
- `.planning/codebase/CONCERNS.md` (v0.3.0 inventory baseline — workspace `hub.md` referenced but absent; v0.3.0 raw-notes intake path; numbering-scheme drift)
- `.planning/OPEN-QUESTIONS.md` (grep verified: zero STG1/STG2/STG3 rows)
- `.planning/STATE.md` (v2.2 milestone state confirmed; Phase 7 = active)

### Secondary (MEDIUM confidence)
- `dydx-delivery/skills/platform-wrike/SKILL.md` + `platform-ziflow/SKILL.md` (cross-verified canonical-pointer pattern matches pipefy — D-59 pattern is uniform)
- `dydx-delivery/skills/execute-tests/references/` directory listing (multi-ref shape — D-71 analog)

### Tertiary (LOW confidence)
- None — all findings traced to in-repo source files; no WebSearch / WebFetch needed for this phase.

## Metadata

**Confidence breakdown:**
- Standard stack (skill authoring conventions): HIGH — CONVENTIONS.md § "SKILL.md body structure" verified; 3 Phase 6 platform skills + 7 v0.3.0 stage skills follow the same shape.
- Architecture (per-skill atomic plan + structure-check partition): HIGH — Phase 6 D-63 precedent has shipped and verified; D-69 / D-77 are direct adaptations.
- Pitfalls (terminology drift + missing-file references in CONTEXT.md): MEDIUM-HIGH — three concrete drifts surfaced in §11; all resolvable in plan write-time.
- Bash skeleton lift target: HIGH — phase6-structure-check.sh is on disk, 281 lines, well-commented, fully reusable.
- Synthesis LOC estimate: MEDIUM — ~90-110 LOC predicted vs ~400 threshold; comfortable margin but not measured.

**Research date:** 2026-05-11
**Valid until:** 2026-06-10 (30 days — Phase 7 source materials are all design-locked under v2.2 milestone; no fast-moving external dependency)

## RESEARCH COMPLETE
