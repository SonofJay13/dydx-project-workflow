---
phase: 8
plan: 08-02
subsystem: dydx-delivery — Stage 4b fnspec-integration skill
tags: [stage-4b, fnspec-integration, D-78, D-82, D-84, D-85, ROUTE-01, ROUTE-02, ROUTE-03, STG4-02, STG4-04, STG4-06]
requirements: [STG4-02, STG4-04, ROUTE-01, ROUTE-02, ROUTE-03]
dependency_graph:
  requires:
    - "08-01 (Wave 1 — generate-fnspec-platform skill) — 4a SKILL.md ## Key decisions block is the upstream half of the T-02-06-02 / ROUTE-01 two-place declaration (I8 cross-plan check)"
  provides:
    - "Stable 4b skill contract for 08-03 (phase8-structure-check.sh run_4b_section wires I1-I8 verbatim)"
    - "D-84 consistency-check ownership encoded in SKILL.md Step 3 (FIRST before any write) + consistency-rules.md (three checks (a)/(b)/(c) named verbatim)"
    - "D-85 either-spec-skip mechanics — verbatim string Stage 4b SKIPPED — no integration work in scope locked in SKILL.md + either-spec-skip-paths.md"
    - "ROUTE-02 halt-on-failure protocol — 04b_consistency_check_v<N>.md frontmatter contract + body template documented in consistency-rules.md"
    - "ROUTE-03 4b read-side — based_on_fnspec_platform: in 4b SKILL.md + template (conditional field — present on 'both', absent on 4b-only)"
    - "T-02-06-02 / ROUTE-01 mitigation — 4b ## Key decisions block in 4b SKILL.md matches 4a ## Key decisions block in 4a SKILL.md (I8 cross-plan verified)"
  affects:
    - "08-03 (Wave 3 — phase8-structure-check.sh): wires I1-I8 assertion strings authored here into run_4b_section()"
tech_stack:
  added: []
  patterns:
    - "Canonical-pointer block-quote pattern lifted from 08-01 4a SKILL.md (FOUND-04 / D-59)"
    - "Two-place key-decisions block pattern — verbatim D-IDs named in BOTH 4a + 4b SKILL.md per T-02-06-02 / ROUTE-01"
    - "Halt-before-write protocol pattern — consistency checks run FIRST in Step 3, halt artefact written + exit before any fnspec write"
    - "Verbatim skip-emit string with unicode em-dash — pattern lifted from Phase 7 D-74 discovery-intake skip-emit (D-85 anchor)"
key_files:
  created:
    - dydx-delivery/skills/generate-fnspec-integration/SKILL.md
    - dydx-delivery/skills/generate-fnspec-integration/references/fnspec-integration-template.md
    - dydx-delivery/skills/generate-fnspec-integration/references/consistency-rules.md
    - dydx-delivery/skills/generate-fnspec-integration/references/either-spec-skip-paths.md
  modified: []
  deleted: []
decisions:
  - "Default platform: pipefy chosen as concrete enum value in 4b template frontmatter (matches 4a template default — symmetry across 4a/4b skill pair; reviewer switches to pipefy | wrike | ziflow | other at write time per D-78)."
  - "Failure-row template columns locked at Check ID | Failure type | Row reference | Detail | Suggested resolution (per planner default in 08-02 plan body; no deviation)."
  - "Topology exemption documented for 4b-only topology — checks (b) and (c) vacuously pass when 4a is absent; based_on_fnspec_platform: field omitted entirely (not commented out) on 4b-only output. Documented in consistency-rules.md AND either-spec-skip-paths.md."
  - "Three-topology summary table added to either-spec-skip-paths.md — quick-reference grid covering 4a presence / SOW H2 content / 4b behaviour / based_on_fnspec_platform: frontmatter rule per topology. Planner-discretion addition beyond plan-mandated content; net positive for reviewer scan-ability."
metrics:
  duration_min: ~20
  completed: 2026-05-11
  tasks_completed: 5
  files_created: 4
---

# Phase 8 Plan 08-02: Stage 4b Fnspec Split — generate-fnspec-integration Skill Authoring Summary

Authored the Stage 4b `generate-fnspec-integration/` skill end-to-end — SKILL.md body + 3 references/ files (fnspec-integration-template / consistency-rules / either-spec-skip-paths) — locking the 4b frontmatter contract (D-78 4-enum + `based_on_fnspec_platform:` conditional field for ROUTE-03 4b read-side), the three D-84 consistency checks (run FIRST before any write — halt with `04b_consistency_check_v<N>.md` on any failure per ROUTE-02), the D-85 either-spec-skip mechanics with verbatim stdout string `Stage 4b SKIPPED — no integration work in scope` (unicode em-dash), and the 4b half of the T-02-06-02 / ROUTE-01 two-place `## Key decisions` cross-reference. All 8 plan-local I-assertions (I1-I8) + 2 supplementary checks (D-78-baked-in + canonical-enum-order) verified PASS via the T5 one-liner; 4b section is ready for 08-03 (Wave 3) to wire the same I1-I8 strings into `phase8-structure-check.sh run_4b_section()`.

## Files Created

| Path | Purpose | Commit |
|---|---|---|
| `dydx-delivery/skills/generate-fnspec-integration/SKILL.md` | Stage 4b skill body (canonical pointers + Inputs/Output + 7 How-to-run steps with Step 2 either-spec-skip detection + Step 3 consistency checks FIRST + halt-path + skip-path + Key decisions + verbatim handoff) | `ed70c66` |
| `dydx-delivery/skills/generate-fnspec-integration/references/fnspec-integration-template.md` | 4b artefact body shape — frontmatter contract + 10 H2 sections + dedicated `## 5a. API endpoints` sub-section + `Cites 4a req` columns (ROUTE-01 b + c) + Delivery column with D-82 markup on sections 4 / 5 / 5a / 8 | `206ec66` |
| `dydx-delivery/skills/generate-fnspec-integration/references/consistency-rules.md` | D-84 three checks (a/b/c) + halt-on-failure protocol + `04b_consistency_check_v<N>.md` frontmatter contract + failure-row body template + reviewer-retry mechanics + two-place cross-reference paragraph | `94932fd` |
| `dydx-delivery/skills/generate-fnspec-integration/references/either-spec-skip-paths.md` | STG4-06 three topologies (both / 4a-only / 4b-only) + topology detection signals in priority order + D-85 verbatim skip-emit string (unicode em-dash) + reviewer-override path + Stage 5 v2.3 forward-compat note | `068524e` |

## Tasks Executed

| Task | Name | Commit | Status |
|---|---|---|---|
| T1 | Author generate-fnspec-integration/SKILL.md | `ed70c66` | done — 4 canonical pointers + 7 numbered How-to-run steps + Step 3 names all three checks (a/b/c) inline (I6 reachable from SKILL.md) + verbatim D-85 skip-emit string + `04b_consistency_check_v` halt-path filename + ## Key decisions naming D-78/D-79/D-82/D-84/D-85 (I8 4b half) |
| T2 | Author references/fnspec-integration-template.md | `206ec66` | done — 10 H2 sections + dedicated `## 5a. API endpoints` + `Cites 4a req` column on sections 4 + 5a + D-82 markup variants (HIGH/MEDIUM/LOW/[reviewer-override:]) on sections 4 / 5 / 5a / 8 + canonical 4-state lifecycle + D-78 4-enum doc + `based_on_fnspec_platform:` documented as CONDITIONAL |
| T3 | Author references/consistency-rules.md | `94932fd` | done — three checks named verbatim (Check (a) / Check (b) / Check (c)) + halt-on-failure protocol + 04b_consistency_check_v<N>.md frontmatter contract (artefact_type: consistency_check_failure + status: halt + checks_run: 3) + failure-row body template + reviewer-retry mechanics + two-place cross-reference paragraph naming all 5 D-IDs |
| T4 | Author references/either-spec-skip-paths.md | `068524e` | done — three topologies named (both / 4a-only / 4b-only) + three-topology summary table + topology detection signals in priority order + verbatim D-85 string with unicode em-dash + reviewer-override prompt path + Stage 5 v2.3 forward-compat note covering all four sub-paths |
| T5 | Plan-local 4b-section gate (I1-I8 + supplementary) | n/a (verification only) | done — 10 PASS lines emitted (I1, I2, I3, I4, I5, I6, I7, I8, D-78-baked-in, canonical-enum-order); exit code 0; "ALL I1-I8 ASSERTIONS PASSED — 4b section ready for 08-03 wire-up" printed |

## Verification

### T5 plan-local gate (I1-I8 + 2 supplementary) — exit code 0; 10 PASS lines

```
PASS I1
PASS I2
PASS I3
PASS I4
PASS I5
PASS I6
PASS I7
PASS I8
PASS D-78-baked-in
PASS canonical-enum-order
ALL I1-I8 ASSERTIONS PASSED — 4b section ready for 08-03 wire-up
EXIT_CODE=0
```

### Concrete values locked (08-03 grep targets)

- **`platform:` enum default in `fnspec-integration-template.md`:** `pipefy` (reviewer switches at write time to one of `pipefy | wrike | ziflow | other` per D-78; matches 4a template default).
- **D-82 markup example rows used in template sections 4 / 5 / 5a / 8 (verbatim — 08-03 may grep against these):**
  - `delivery: native-ai [HIGH, src: platform-pipefy]`
  - `delivery: native-ai [MEDIUM, src: platform-pipefy]`
  - `delivery: api [LOW → default api, src: platform-pipefy]`
  - `delivery: api [reviewer-override: api]`
- **Verbatim D-85 skip-emit string locked** (em-dash `—` U+2014 verbatim, NOT hyphen, NOT en-dash):

  ```
  Stage 4b SKIPPED — no integration work in scope
  ```

  Present in BOTH `generate-fnspec-integration/SKILL.md` (Step 2 body + Quality bar) AND `references/either-spec-skip-paths.md` (§D-85 verbatim skip-emit string locked block + How this rubric is consumed paragraph). I5 satisfied from either location.

- **Failure-row template column headers in `consistency-rules.md`:** `Check ID | Failure type | Row reference | Detail | Suggested resolution` (planner default — no deviation).

- **`04b_consistency_check_v<N>.md` frontmatter contract verbatim fields locked:**
  - `artefact_type: consistency_check_failure`
  - `based_on_fnspec_platform: 04a_fnspec-platform_v<N>.md`
  - `based_on_attempted_fnspec_integration: <intended-04b-filename-or-N/A-if-pre-write>`
  - `checks_run: 3`
  - `checks_failed: <N>`
  - `status: halt`

- **Verbatim handoff-message string locked** (08-03 structure-check may grep against this):

  ```
  Awaiting status: approved on 04b_fnspec-integration_v<N>.md. Stage 5 v2.3 reads both 4a + 4b via the based_on_* chain (based_on_discovery + based_on_sow + based_on_fnspec_platform).
  ```

- **4a SKILL.md `## Key decisions` cross-plan I8 check (confirmation):** All 5 D-IDs present in 4a SKILL.md `## Key decisions` block (verified `grep -qF` on D-78 / D-79 / D-82 / D-84 / D-85). No 08-01 regression detected. Two-place declaration intact.

### Cross-plan deferred verifications

- **I1-I8 wired into `phase8-structure-check.sh run_4b_section()`** — 08-03's responsibility. The assertion strings in T5 above MUST match what 08-03 wires verbatim.

## Deviations from Plan

None — plan executed exactly as written. No Rule 1 / Rule 2 / Rule 3 auto-fixes triggered.

The forward implication flagged in 08-01 SUMMARY (use anti-pattern-free phrasing for canonical-enum-order documentation — never embed the reversed literal `api | native-ai` in body prose) was honoured: in 4b SKILL.md Step 5, the documentation reads "Canonical enum order is `native-ai | api` — the reversed form is forbidden per STG4-04 lock." No reversed-enum literal anywhere in 4b artefacts. T5 supplementary check `canonical-enum-order` (`! grep -qF 'api | native-ai' "$SK"`) PASSED.

## Plan Anchors

This plan was authored against the v2.2 Phase 8 Stage 4 Fnspec Split + ROUTE objective. All artefacts honour:

- **D-78** — `platform: pipefy | wrike | ziflow | other` 4-enum (baked into SKILL.md + template; verified by I3-adjacent `grep -qF 'pipefy | wrike | ziflow | other'`).
- **D-82** — Per-row `delivery: native-ai | api [<confidence>, src: <platform>]` markup in canonical enum order; unicode arrow `→` verbatim in LOW → default-api rows; `[reviewer-override:]` preservation token.
- **D-84** — Three consistency checks owned by Stage 4b; run FIRST in Step 3 before any fnspec write; named verbatim as Check (a) / Check (b) / Check (c) in SKILL.md AND consistency-rules.md.
- **D-85** — Either-spec-skip detected via priority-ordered signals (reviewer / SOW H2 / 4a presence); verbatim stdout string with unicode em-dash; NO `04b_*` artefact written on skip path.
- **STG4-02** — Reviewer can invoke `generate-fnspec-integration` against approved discovery + approved SOW + approved 4a and receive `04b_fnspec-integration_v<N>.md` per DESIGN-02 (clean path).
- **STG4-04** — Canonical enum order `native-ai | api` lock; reversed form forbidden everywhere (asserted by `! grep -qF 'api | native-ai'` in SKILL.md AND template).
- **STG4-06** — Three valid topologies (both / 4a-only / 4b-only) documented with per-topology behaviour + frontmatter rules.
- **ROUTE-01** — Three consistency checks; two-place key-decisions cross-reference (T-02-06-02 mitigation) — 4b half here, 4a half from 08-01.
- **ROUTE-02** — Halt-on-failure protocol with `04b_consistency_check_v<N>.md` failure artefact; frontmatter contract locked (`artefact_type: consistency_check_failure` + `status: halt`).
- **ROUTE-03** — 4b read-side documentation: `based_on_fnspec_platform:` frontmatter field present on 'both' topology, absent on 4b-only.

## Threat Flags

None. All threat-model entries from the plan are mitigated as designed:

- T-08-06 (consistency check silently skipped) — mitigated by I6 + I7 grep gates (three checks named in BOTH SKILL.md AND consistency-rules.md; halt-on-failure protocol documented in BOTH); verified PASS.
- T-08-07 (D-85 verbatim skip-emit string drift) — mitigated by I5 grep gate on unicode em-dash literal; verified PASS.
- T-08-08 (I8 cross-plan two-place declaration regression) — mitigated by T5 cross-plan check; all 5 D-IDs verified in BOTH 4a + 4b SKILL.md.
- T-08-09 (halt artefact information disclosure) — accepted per plan posture (failure-row table contains only req IDs + delivery tags + reviewer-facing suggestions; no credentials).
- T-08-10 (pathological consistency-check input scale) — accepted per plan; out of v2.2 scope.

No new threat surface introduced beyond what the plan threat model registered.

## Self-Check: PASSED

All 4 files exist at the expected paths:

- `dydx-delivery/skills/generate-fnspec-integration/SKILL.md` — FOUND
- `dydx-delivery/skills/generate-fnspec-integration/references/fnspec-integration-template.md` — FOUND
- `dydx-delivery/skills/generate-fnspec-integration/references/consistency-rules.md` — FOUND
- `dydx-delivery/skills/generate-fnspec-integration/references/either-spec-skip-paths.md` — FOUND

All commit hashes are reachable in `git log`:

- `ed70c66` (T1 SKILL.md) — FOUND
- `206ec66` (T2 template) — FOUND
- `94932fd` (T3 consistency-rules) — FOUND
- `068524e` (T4 either-spec-skip-paths) — FOUND

T5 plan-local I1-I8 gate exit code 0 with all 8 I-PASS lines + 2 supplementary PASS lines emitted; "ALL I1-I8 ASSERTIONS PASSED — 4b section ready for 08-03 wire-up" printed.

Cross-plan I8 check confirmed: 4a SKILL.md (08-01 product) `## Key decisions` block contains all 5 D-IDs (D-78 / D-79 / D-82 / D-84 / D-85). No 08-01 regression. Two-place declaration intact.
