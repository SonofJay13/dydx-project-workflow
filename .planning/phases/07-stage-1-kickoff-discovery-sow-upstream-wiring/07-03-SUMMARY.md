---
phase: 7
plan: 07-03
slug: stage-1-kickoff-discovery-sow-upstream-wiring
wave: 2
subsystem: dydx-delivery/skills/generate-sow
tags: [stage-3, sow, dual-upstream, 4-state-lifecycle, platform-integration-split, R-05-cleanup]
requirements: [STG3-01, STG3-02]
depends_on: [07-01]
dependency_graph:
  requires:
    - dydx-delivery/skills/kickoff-capture/references/kickoff-template.md (shipped 07-01 — supplies based_on_kickoff path)
    - dydx-delivery/references/frontmatter-scheme.md (canonical lifecycle SoT)
  provides:
    - canonical-4-state-lifecycle-anchor (S1 sentinel — verifier-readable)
    - dual-upstream-input-contract (based_on_discovery OR based_on_kickoff)
    - dual-scope-template-split (Platform + Integration H2 sections — feeds Stage 4a/4b)
  affects:
    - Phase 8 generate-fnspec-platform (consumes ## Platform Scope)
    - Phase 8 generate-fnspec-integration (consumes ## Integration Scope)
tech-stack:
  added: []
  patterns:
    - dual-scope-H2-split (single artefact, two routing targets per D-75)
    - dual-upstream-input-policy (YAML comment-block alternation per DESIGN-19 line 643)
key-files:
  created: []
  modified:
    - dydx-delivery/skills/generate-sow/SKILL.md
    - dydx-delivery/skills/generate-sow/references/sow-template.md
decisions:
  - "Canonical 4-state lifecycle 'draft → client_review → approved → archived' anchored in BOTH SKILL.md narrative AND sow-template.md frontmatter comment (redundant by design — S1 satisfies on either; double-anchor adds robustness)."
  - "Dual upstream contract documented via YAML comment-block alternation (one field active, alternative commented) rather than two-mode template variants — keeps surgical-edit footprint to one file each."
  - "R-05 pre-emptive cleanup applied within this plan: all generate-functional-spec references in BOTH files now route to Stage 4a/4b nomenclature, eliminating Phase 8 follow-up debt."
metrics:
  duration: "~10 minutes"
  completed_date: "2026-05-11"
  tasks_completed: "3/3"
---

# Phase 7 Plan 07-03: Generate-SOW Upstream Wiring — Summary

Surgical modifications to `dydx-delivery/skills/generate-sow/SKILL.md` + `references/sow-template.md` that lock the canonical 4-state lifecycle, wire the dual upstream input contract (`based_on_discovery` OR `based_on_kickoff`), split the SOW artefact into `## Platform Scope` + `## Integration Scope` H2 sections feeding Stage 4a/4b, and pre-emptively retire the `generate-functional-spec` handoff per R-05.

## Surgical edits applied

### `dydx-delivery/skills/generate-sow/SKILL.md` (6 edits)

| # | Section | Change |
|---|---------|--------|
| 1 | `## Inputs` | Replaced single-discovery requirement with dual upstream contract narrative (discovery-ready vs draft-sow paths per DESIGN-19 lines 635-636 + 643). Added single-artefact-covers-both-scopes note per STG3-02 + D-75. |
| 2 | `### Step 1 — Locate upstream artefact` | Rewrote triage to read kickoff first, then branch on `kickoff_branch:` (`discovery-ready` → look for 02_discovery; `draft-sow` → use kickoff directly). Removed inline-stub fallback — explicit error directs reviewer to run upstream stage. |
| 3 | `### Step 3 — Draft the SOW` | Order-of-work split deliverables into Platform Scope + Integration Scope items; Approach-and-phases reference points to Stage 4a/4b instead of single generate-functional-spec. |
| 4 | `### Step 5 — Write and hand off` (frontmatter block) | Added `frontmatter_version: 2`, `ziflow` to platform enum, dual-policy comment block (`based_on_discovery` active + `based_on_kickoff` commented alternative per DESIGN-19 line 643). Added canonical lifecycle narrative line below the YAML block (`draft → client_review → approved → archived`). |
| 5 | `### Step 5` handoff message | Replaced `generate-functional-spec` routing with DESIGN-19 line 653 verbatim: "Awaiting status: approved on 03_sow_v<N>.md; routing to Stage 4a (platform fnspec) and/or Stage 4b (integration fnspec) per project scope." Added `archived` state to status-progression review step. |
| 6 | `## What this skill does not do` | Appended bullet documenting artefact-level scope-split exclusion (scope split happens at Stage 4, not here). |

### `dydx-delivery/skills/generate-sow/references/sow-template.md` (3 edits)

| # | Section | Change |
|---|---------|--------|
| 1 | Frontmatter (lines ~2-9) | Added `frontmatter_version: 2`, added `ziflow` to platform enum, replaced single `based_on_discovery:` with dual-policy YAML block (one active, one commented, with DESIGN-19 reference comment). Added canonical lifecycle inline comment on `status: draft` line. |
| 2 | `## 2. In-scope deliverables` (lines ~26-33) | Replaced single 4-col table with two top-level H2 sections: `## Platform Scope` (4-col Platform table; intro names Stage 4a consumer) + `## Integration Scope` (4-col Integration table; intro names Stage 4b consumer with empty-table escape valve for "no integration scope"). |
| 3 | `## Handoff` block (lines ~147-155) | Replaced `generate-functional-spec` routing with DESIGN-19 line 653 verbatim handoff message; added Stage 4a/4b routing-explanation paragraph; preserved "Next stage reads" pointer. Canonical lifecycle inline reminder added. |

## Verification — `phase7-structure-check.sh --section sow`

```
PASS: S1: canonical 4-state lifecycle 'draft → client_review → approved → archived' present
PASS: S2: dual-scope H2s ('## Platform Scope' + '## Integration Scope') present in sow-template.md
ALL ASSERTIONS PASSED
EXIT=0
```

- Exit code: **0**
- PASS-line count: **2** (S1, S2 — matches spec)

## R-05 outcome

`grep -c "generate-functional-spec"` against both modified files:

| File | Count before | Count after |
|------|--------------|-------------|
| `dydx-delivery/skills/generate-sow/SKILL.md` | 1 | **0** |
| `dydx-delivery/skills/generate-sow/references/sow-template.md` | 1 | **0** |

R-05 closed within scope. No Phase 8 follow-up debt from generate-sow → fnspec routing.

## C3 outcome (ASCII-arrow leak check)

`grep -F "draft ->"` against both modified files: **0 matches** — zero ASCII-arrow lifecycle leakage. The unicode `→` (U+2192) form is preserved verbatim in both `SKILL.md` and `sow-template.md`. C3 closed.

## Acceptance criteria — all PASS

**T1 (SKILL.md):**
- `grep -qF "draft → client_review → approved → archived" generate-sow/SKILL.md` → PASS (1 match)
- `grep -qF "based_on_kickoff" generate-sow/SKILL.md` → PASS (4 matches)
- `grep -qF "based_on_discovery" generate-sow/SKILL.md` → PASS (4 matches)
- `grep -qF "Awaiting status: approved on 03_sow_v<N>.md; routing to Stage 4a"` → PASS (1 match)
- `grep -c "generate-functional-spec" generate-sow/SKILL.md` → **0** (expected 0)
- `grep -F "draft ->" generate-sow/SKILL.md | wc -l` → **0** (expected 0)

**T2 (sow-template.md):**
- `grep -qE "^## Platform Scope" sow-template.md` → PASS (1 match)
- `grep -qE "^## Integration Scope" sow-template.md` → PASS (1 match)
- `grep -qF "based_on_kickoff" sow-template.md` → PASS (1 match)
- `grep -qF "based_on_discovery" sow-template.md` → PASS (1 match)
- `grep -c "generate-functional-spec" sow-template.md` → **0** (expected 0)
- `grep -qF "## 1. Business outcome" sow-template.md` → PASS (preserved — non-destructive edit)
- `grep -F "draft ->" sow-template.md | wc -l` → **0** (expected 0)

**T3 (structure-check gate):**
- Exit code 0
- `ALL ASSERTIONS PASSED` in stdout
- 2 PASS lines (S1, S2)

## Commit log

| Task | Commit | Files | Lines changed |
|------|--------|-------|---------------|
| T1 | `1d204ce` | `dydx-delivery/skills/generate-sow/SKILL.md` | +41/-24 |
| T2 | `202220c` | `dydx-delivery/skills/generate-sow/references/sow-template.md` | +27/-9 |
| T3 | (no source change — verification gate) | — | — |

Total: 2 source files modified, +68/-33 lines.

## Deviations from plan

**None.** Plan executed exactly as written. Edit 5 in T1 (hunt-and-replace `generate-functional-spec`) was satisfied by the Step 5 handoff rewrite in Edit 4 — no additional dangling references existed in the body. The plan permitted that consolidation ("Hunt-and-replace any other `generate-functional-spec` references" — there were none beyond the Step 5 handoff already replaced).

## Phase synthesis deferred

Per cross-AI review C2 split: phase synthesis (R-02 DESIGN.md glossary fix, sample-CR fixtures, manual e2e smoke, REQUIREMENTS.md trace flips, `phase7-structure-check.sh --all` final gate) lives in **`07-04-PLAN.md`** (Wave 3, `depends_on: [07-02, 07-03]`, `autonomous: false`). This SUMMARY closes only the surgical-edit + `--section sow` gate scope.

## Self-Check: PASSED

- File `dydx-delivery/skills/generate-sow/SKILL.md` → FOUND
- File `dydx-delivery/skills/generate-sow/references/sow-template.md` → FOUND
- Commit `1d204ce` → FOUND
- Commit `202220c` → FOUND
- Structure-check `--section sow` exit 0 confirmed by direct execution above
