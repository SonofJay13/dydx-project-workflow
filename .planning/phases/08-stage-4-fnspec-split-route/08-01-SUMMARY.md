---
phase: 8
plan: 08-01
subsystem: dydx-delivery — Stage 4a fnspec-platform skill
tags: [stage-4a, fnspec-platform, D-78, D-79, D-81, D-82, D-84, D-85, ROUTE-03, STG4-04, STG4-05]
requirements: [STG4-01, STG4-04, STG4-05, ROUTE-03]
dependency_graph:
  requires: []
  provides:
    - "Stable 4a frontmatter contract for 08-02 (generate-fnspec-integration upstream input)"
    - "D-78 4-enum baked into Stage 4a SKILL.md + template (P4 anchor)"
    - "D-82 row markup contract documented in SKILL.md + template + rubric (P5 anchor)"
    - "D-79 addendum body skeleton + emit-when conditions documented (P7 + P8 anchors)"
    - "## Key decisions section in 4a SKILL.md (4a half of T-02-06-02 / ROUTE-01 two-place declaration; I8 contribution)"
  affects:
    - "08-02 (Wave 2 — generate-fnspec-integration): reads 04a_fnspec-platform_v*.md upstream + matches 4b half of two-place key-decisions"
    - "08-03 (Wave 3 — phase8-structure-check.sh): wires P1-P8 assertion strings authored here into run_4a_section()"
tech_stack:
  added: []
  patterns:
    - "Canonical-pointer block-quote pattern lifted from kickoff-capture/SKILL.md (FOUND-04 / D-59)"
    - "Auto-classify rubric body shape lifted from kickoff-capture/references/auto-classify-rubric.md (5 triggers + escalation table + operational-principle backstop)"
    - "Functional-spec 10-H2 body skeleton lifted from generate-functional-spec/references/functional-spec-template.md; extended with Delivery column in sections 4 / 5 / 8 per D-82"
key_files:
  created:
    - dydx-delivery/skills/generate-fnspec-platform/SKILL.md
    - dydx-delivery/skills/generate-fnspec-platform/references/fnspec-platform-template.md
    - dydx-delivery/skills/generate-fnspec-platform/references/auto-classify-rubric.md
    - dydx-delivery/skills/generate-fnspec-platform/references/addendum-template.md
  modified: []
  deleted: []
decisions:
  - "Default platform: pipefy chosen as the concrete enum value in the template frontmatter (reviewer switches at write time per D-78). Rationale: pipefy is the Phase 6 reference platform with the richest native-ai-inventory.md; using it as the planner-default surfaces D-82 markup variants (HIGH / MEDIUM / LOW) with realistic per-platform context."
  - "MEDIUM trigger threshold set to >=2 distinct verified MCP probes — matches Phase 6 native-ai-inventory HIGH/MEDIUM/LOW canon. No deviation."
  - "Addendum table example rows include explicit per-platform context (Pipefy GraphQL OAuth bearer / Wrike OAuth2 / Ziflow API key + 4 req per 10s) — keeps the skeleton platform-agnostic enough for D-78 'other' while grounding the auth + rate-limit columns in concrete v2.1 reality."
  - "T5 plan-local gate is a verification-only step — produces no committed file. Will be re-implemented as run_4a_section() in 08-03 (phase8-structure-check.sh)."
metrics:
  duration_min: ~25
  completed: 2026-05-11
  tasks_completed: 5
  files_created: 4
---

# Phase 8 Plan 08-01: Stage 4a Fnspec Split — generate-fnspec-platform Skill Authoring Summary

Authored the Stage 4a `generate-fnspec-platform/` skill end-to-end — SKILL.md body + 3 references/ files (fnspec-platform-template / auto-classify-rubric / addendum-template) — locking the 4a frontmatter contract (D-78 4-enum baked in, D-82 per-row `delivery:` markup, D-79 conditional addendum branch + frontmatter), the D-81 / STG4-05 classifier rubric, and the two-place key-decisions declaration (D-78/D-79/D-82/D-84/D-85) per the T-02-06-02 / ROUTE-01 mitigation. All 8 plan-local assertion strings (P1-P8) verified PASS via the T5 one-liner; 4a section is ready for 08-02 (Wave 2 — generate-fnspec-integration) to consume the stable 4a frontmatter contract upstream, and ready for 08-03 (Wave 3) to wire the same P1-P8 strings into `phase8-structure-check.sh run_4a_section()`.

## Files Created

| Path | Purpose | Commit |
|---|---|---|
| `dydx-delivery/skills/generate-fnspec-platform/SKILL.md` | Stage 4a skill body (canonical pointers + Inputs/Output + 7 How-to-run steps + D-79 addendum branch + Key decisions block + verbatim handoff) | `8a213d3` |
| `dydx-delivery/skills/generate-fnspec-platform/references/fnspec-platform-template.md` | Artefact frontmatter contract + 10 H2 sections + Delivery column with D-82 markup in sections 4 / 5 / 8 + D-79 addendum H2 carrier | `a9c41f0` |
| `dydx-delivery/skills/generate-fnspec-platform/references/auto-classify-rubric.md` | D-81 + STG4-05 classifier rubric (5 explicit triggers + escalation table + reviewer-override mechanics + re-run preservation rule + operational-principle backstop) | `d25cd88` |
| `dydx-delivery/skills/generate-fnspec-platform/references/addendum-template.md` | D-79 Platform-API Addendum H2 body skeleton (API surface inventory / Error paths / Retry + idempotency rules / Observability hooks) | `d182995` |

## Tasks Executed

| Task | Name | Commit | Status |
|---|---|---|---|
| T1 | Author generate-fnspec-platform/SKILL.md | `8a213d3` | done — all P1, P3, P4, P5, P6, P7, P8 anchors verified; 7 numbered How-to-run steps; D-78 / D-79 / D-82 / D-84 / D-85 named in Key decisions block |
| T2 | Author references/fnspec-platform-template.md | `a9c41f0` | done — 10 H2 sections; frontmatter contract per DESIGN-20; canonical 4-state lifecycle; D-82 markup in sections 4 / 5 / 8; ## Platform-API Addendum H2 carrier; P4 + P5 + P8 anchors verified |
| T3 | Author references/auto-classify-rubric.md | `d25cd88` | done — 5 numbered triggers; escalation table; reviewer-override mechanics; re-run preservation rule; operational-principle backstop; consumer reference to SKILL.md Step 4 |
| T4 | Author references/addendum-template.md | `d182995` | done — ## Platform-API Addendum H2 + 4 sub-sections per D-79; has_platform_api_addendum: true + tech_spec_scope: platform-api-addendum-only documented; D-82 markup on every API surface inventory row |
| T5 | Plan-local 4a-section gate (P1-P8 proxy assertions) | n/a (verification only) | done — all 8 PASS lines emitted; exit code 0; "ALL P1-P8 ASSERTIONS PASSED — 4a section ready for 08-03 wire-up" printed |

## Verification

### T5 plan-local gate (P1-P8) — exit code 0; 8 PASS lines

```
PASS P1: SKILL.md exists
PASS P2: 3 references/ files exist
PASS P3: 4 canonical pointers present
PASS P4
PASS P5
PASS P6
PASS P7
PASS P8
ALL P1-P8 ASSERTIONS PASSED — 4a section ready for 08-03 wire-up
```

### Concrete values locked (08-02 / 08-03 grep targets)

- **`platform:` enum default in `fnspec-platform-template.md`:** `pipefy` (reviewer switches at write time to one of `pipefy | wrike | ziflow | other` per D-78).
- **D-82 markup example rows used in template sections 4 / 5 / 8 (verbatim — 08-02 + 08-03 may grep against these):**
  - `delivery: native-ai [HIGH, src: platform-pipefy]`
  - `delivery: native-ai [MEDIUM, src: platform-pipefy]`
  - `delivery: api [LOW → default api, src: platform-pipefy]`
  - `delivery: api [reviewer-override: api]`
  - `delivery: native-ai [reviewer-override: native-ai]`
- **D-79 addendum-template body subsection structure (all 4 present, in this order):**
  1. `### API surface inventory` (table with `Endpoint | Method | Auth | Rate limit | Delivery` columns)
  2. `### Error paths` (table with `HTTP class | Expected behaviour | Per-platform error mapping | Reviewer-facing message` columns)
  3. `### Retry + idempotency rules` (bulleted list — idempotent vs not-idempotent operations + per-platform idempotency-key field names)
  4. `### Observability hooks` (bulleted list — request log / response capture / audit-trail surface / trace correlation)
- **D-81 MEDIUM trigger threshold:** `≥2 distinct verified MCP probes` (default, matches Phase 6 native-ai-inventory canon; no deviation).
- **Verbatim handoff-message string locked** (08-02 + 08-03 structure-check may grep against this verbatim):

  ```
  Awaiting status: approved on 04a_fnspec-platform_v<N>.md. Stage 4b (generate-fnspec-integration) reads this artefact when integration scope exists. If integration is out-of-scope AND this 4a carries delivery: api rows, this artefact's `## Platform-API Addendum` H2 body is the v2.3 Stage 5 input via has_platform_api_addendum: true + tech_spec_scope: platform-api-addendum-only frontmatter.
  ```

### Cross-plan deferred verifications

- **I8 (two-place key-decisions cross-reference between 4a + 4b SKILL.md)** — 08-02's responsibility. This plan authored the 4a half (D-78 / D-79 / D-82 / D-84 / D-85 named in `## Key decisions`); 08-02's plan-close gate asserts both halves cross-reference correctly.
- **P1-P8 wired into `phase8-structure-check.sh run_4a_section()`** — 08-03's responsibility. The assertion strings in T5 above MUST match what 08-03 wires verbatim.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 — Bug] Removed reversed-enum literal from SKILL.md Step 4 step-body prose.**

- **Found during:** T1 verification.
- **Issue:** The Step 4 body originally read "Canonical enum order is `native-ai | api` — NEVER `api | native-ai` (STG4-04 lock)." The literal substring `api | native-ai` inside the warning text triggered the P5 complementary check (`! grep -qF 'api | native-ai' SKILL.md`), which is the STG4-04 lock anti-regression assertion. The original phrasing was self-defeating against its own assertion.
- **Fix:** Rephrased to "Canonical enum order is `native-ai | api` — the reversed form is forbidden per STG4-04 lock." Conveys the same meaning, no reversed-enum literal anywhere in the body.
- **Files modified:** `dydx-delivery/skills/generate-fnspec-platform/SKILL.md` (Step 4 body).
- **Commit:** Fix landed inside T1's atomic commit `8a213d3` (caught before commit; not a second commit).
- **Forward implication:** 08-02 SKILL.md authoring MUST use the same anti-pattern-free phrasing in its own canonical-enum-order documentation. Flag for 08-02 plan execution.

No other deviations. Plan executed as written.

## Plan Anchors

This plan was authored against the v2.2 Phase 8 Stage 4 Fnspec Split + ROUTE objective. All artefacts honour:

- **D-78** — `platform: pipefy | wrike | ziflow | other` 4-enum (baked into SKILL.md + template).
- **D-79** — `## Platform-API Addendum` H2 authored INLINE by 4a on the platform-only-with-API-rows topology; `has_platform_api_addendum: true` + `tech_spec_scope: platform-api-addendum-only` frontmatter contract locked.
- **D-81 / STG4-05** — HIGH/MEDIUM → suggest native-ai; LOW / `[OPEN]` / absent → default api. `[reviewer-override:]` token preserved on re-run.
- **D-82** — Per-row `delivery: native-ai | api [<confidence>, src: <platform>]` markup in canonical enum order; unicode arrow `→` verbatim.
- **D-84** — Stage 4b OWNS the three cross-spec consistency checks; this 4a does NOT run them. Documented in `## What this skill does not do`.
- **D-85** — Stage 4a runs normally regardless of 4b topology; no "skip 4a" path. Documented in `## Key decisions`.
- **STG4-01** — Reviewer can invoke `generate-fnspec-platform` against approved discovery + approved SOW + per-platform inventory and receive `04a_fnspec-platform_v<N>.md` per DESIGN-02.
- **STG4-04** — Canonical enum order `native-ai | api` lock; reversed form forbidden everywhere (asserted by `! grep -qF 'api | native-ai'`).
- **ROUTE-03** — 4a authors the addendum body on platform-only-with-API-rows topology; v2.3 Stage 5 forward-compat interface locked via frontmatter.
- **T-02-06-02 / ROUTE-01 mitigation** — `## Key decisions` section in SKILL.md is the 4a half of the two-place declaration; 08-02 authors the matching 4b half.

## Threat Flags

None. All threat-model entries from the plan are mitigated as designed:

- T-08-01 (enum drift) — mitigated by P4 (grep against `pipefy | wrike | ziflow | other` in SKILL.md AND template; verified PASS).
- T-08-02 (reversed enum) — mitigated by P5 (`! grep -qF 'api | native-ai'` in SKILL.md; verified PASS after the Rule 1 auto-fix above).
- T-08-03 (`[reviewer-override:]` token drift) — mitigated by literal documentation in SKILL.md + template + rubric (3 places; all verified).
- T-08-04 (D-79 frontmatter field rename) — mitigated by P8 (`grep -qF 'has_platform_api_addendum' && grep -qF 'tech_spec_scope'` in SKILL.md AND template; verified PASS).
- T-08-05 (path traversal) — accepted per plan (reviewer is the operator; future SURF-01..03 hook in v2.6).

## Self-Check: PASSED

All 4 files exist at the expected paths:

- `dydx-delivery/skills/generate-fnspec-platform/SKILL.md` — FOUND
- `dydx-delivery/skills/generate-fnspec-platform/references/fnspec-platform-template.md` — FOUND
- `dydx-delivery/skills/generate-fnspec-platform/references/auto-classify-rubric.md` — FOUND
- `dydx-delivery/skills/generate-fnspec-platform/references/addendum-template.md` — FOUND

All commit hashes are reachable in `git log`:

- `8a213d3` (T1 SKILL.md) — FOUND
- `a9c41f0` (T2 template) — FOUND
- `d25cd88` (T3 rubric) — FOUND
- `d182995` (T4 addendum) — FOUND

T5 plan-local P1-P8 gate exit code 0 with all 8 PASS lines emitted; "ALL P1-P8 ASSERTIONS PASSED — 4a section ready for 08-03 wire-up" printed.
