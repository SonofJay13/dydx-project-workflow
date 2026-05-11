---
phase: 02-design
plan: 06
subsystem: stages-4a-4b-5-skills
tags: [design, stage-skills, fnspec-split, tech-spec, wave-6]
requires: [cross-cutting-decisions-locked, skill-layout-locked, skill-inventory-locked, handoff-matrix-locked, platform-skills-locked, stages-1-3-locked]
provides: [stage-4a-platform-fnspec-design-20, stage-4b-integration-fnspec-design-20, stage-5-tech-spec-scope-gate-design-21, delivery-routing-key-locked, cross-spec-consistency-check-locked]
affects: [.planning/DESIGN.md]
tech_stack:
  added: []
  patterns:
    - "Per-stage decision contract shape per D-20 (Skill / Stage / Complexity / Inputs / Outputs / Downstream consumer / Status flag(s) / Hand-off message / Key v2 decisions / Dependencies / Cross-references)"
    - "DESIGN-20 echo line appears under BOTH 4a and 4b H2s (per D-35 per-section echo + plan dual-echo contract)"
    - "Routing key contract `delivery: native-ai | api` (canonical order; never reversed) per requirement row in 4a/4b output"
    - "Cross-spec consistency check OWNED by Stage 4b, DECLARED in both 4a and 4b key-decisions (two-place traceability)"
    - "Stage 5 scope gate — three explicit branches (full / addendum / skip-entirely); no silent default"
    - "Error-paths discipline — 4 elements per endpoint (failure modes / retry policy / idempotency / observability); hand-waving forbidden"
    - "Forward-reference guardrails (cross-AI MEDIUM #6) — DESIGN-22/23/26 cited as anchor placeholders only with explicit `forward reference, populated in Plan 02-0X`"
    - "Echo blockquote `> **DESIGN-NN:**` pattern per D-35 — 3 echo lines added (DESIGN-20 contributes 2 — one per substage); running total 22/30"
key_files:
  created:
    - .planning/phases/02-design/02-06-SUMMARY.md
  modified:
    - .planning/DESIGN.md
decisions:
  - "Phase 2 Plan 06: Stage 4a `generate-fnspec-platform/` skill is NEW (replaces v0.3.0 `generate-functional-spec` for platform portions per AUDIT.md §1.3 single-spec-for-everything anti-pattern); Stage 4b `generate-fnspec-integration/` skill is NEW (replaces v0.3.0 `generate-functional-spec` for integration portions); both skills carry the same `delivery: native-ai | api` per-requirement routing-key contract."
  - "Phase 2 Plan 06: `delivery: native-ai | api` routing key locked at canonical order (NOT `delivery: api | native-ai` reversed); per-requirement row in fnspec output; drives 4 downstream stages (5 / 6 / 7b / 10) without re-classifying. Single key, four consumers — eliminates silent re-classification drift."
  - "Phase 2 Plan 06: Per-platform capability matrix as classifier input — Stage 4a reads platform skill's `references/native-ai-inventory.md` (per DESIGN-14/15/16) and uses HIGH/MEDIUM confidence rows to suggest `delivery: native-ai`; LOW confidence (i.e., `[OPEN]`-flagged) defaults to `delivery: api` to avoid optimistic claims when only copy-paste works."
  - "Phase 2 Plan 06: Cross-spec consistency check OWNED by Stage 4b (runs FIRST, before fnspec write); 3 specific checks enumerated — (a) no requirement ID in both 4a and 4b with conflicting `delivery:` tags; (b) every integration touchpoint in 4b cites referenced platform requirement ID from 4a (no dangling references); (c) no orphan API endpoints. Failure halts before fnspec write; emits `04b_consistency_check_v<N>.md` for human triage."
  - "Phase 2 Plan 06: Cross-spec consistency check DECLARED in both 4a and 4b key-decisions (two-place traceability) per T-02-06-02 mitigation — 4a key-decision #3 mentions the check runs at start of 4b; 4b key-decision #1 owns it explicitly."
  - "Phase 2 Plan 06: Stage 4a OPTIONAL for integration-only projects (SOW `platform:` field absence signals); Stage 4b OPTIONAL for platform-only projects (Stage 5 SKIPS with addendum on 4a instead per DESIGN-21)."
  - "Phase 2 Plan 06: Stage 5 scope gate has 3 explicit branches per T-02-06-03 mitigation — (1) Default: 4b exists -> full tech spec; (2) Skip with addendum: no 4b but 4a has `delivery: api` rows -> `## Platform-API Addendum` H2 INSIDE 4a artefact + frontmatter `has_platform_api_addendum: true`; (3) Skip entirely: no 4b AND no `delivery: api` rows anywhere -> no tech spec written at all."
  - "Phase 2 Plan 06: Stage 5 frontmatter field `tech_spec_scope: full | platform-api-addendum-only` records which scope-gate branch was taken; addendum lives INSIDE 4a artefact (not a separate file) to keep artefact count clean for platform-only projects."
  - "Phase 2 Plan 06: Stage 5 error-paths discipline — every API endpoint enumerates 4 elements per T-02-06-04 mitigation: (a) failure modes; (b) retry policy with backoff curve; (c) idempotency key strategy; (d) observability (request ID propagation + error class tagging + metric emission). 'Hand-waving forbidden' callout present."
  - "Phase 2 Plan 06: Stage 5 hand-off message verbatim from matrix Stage 5 -> Stage 6 row including the wait-for-commercial-inputs gate per T-02-06-06 mitigation — references DESIGN-22 forward as anchor placeholder (cross-AI MEDIUM #6)."
  - "Phase 2 Plan 06: Hand-off matrix rows for Stage 4a -> 4b and Stage 4b -> 5 updated to align literal text with per-stage subsection (`> Awaiting \\`status: approved\\` to \\`04a\\`...` and `> Awaiting \\`status: approved\\` to \\`04b\\`...`) per D-26 verbatim-restate contract; outer code-span backticks dropped to permit inner backtick formatting (markdown table cells cannot nest backticks inside code spans cleanly)."
  - "Phase 2 Plan 06: Echo count progresses 19 -> 22/30 (DESIGN-20 contributes 2 echoes — one each under 4a and 4b H2s; DESIGN-21 contributes 1 under Stage 5); structural-check exits 1 with assertion #4 short-circuit at 22 < 30 — expected mid-phase invariant; Plans 02-07..02-09 close remaining 8."
  - "Phase 2 Plan 06: Forward-reference guardrails per cross-AI review MEDIUM #6 honoured — DESIGN-22 (Stage 6) / DESIGN-23 (Stage 7) / DESIGN-26 (Stage 10) cited as anchor placeholders only with explicit `forward reference, populated in Plan 02-07/02-08` inline at every cite site (Stage 4a + Stage 4b + Stage 5 cross-references); acceptance criteria did NOT assert forward-reference body content exists; deferred to Plan 02-10 Appendix B traceability synthesis (T-02-06-07 mitigation)."
  - "Phase 2 Plan 06: No new `[OPEN: Phase 4 — ...]` markers added — DESIGN-20 + DESIGN-21 contracts are LOCKED. Total inline `[OPEN]` count across DESIGN.md unchanged from Plan 02-04 (= 13)."
metrics:
  duration_minutes: 9
  completed_date: "2026-05-09"
  task_count: 2
  file_count: 1
---

# Phase 2 Plan 06: Stages 4a/4b/5 skills (Fnspec split + Tech spec scope gate) Summary

**One-liner:** Locked DESIGN-20 (Stage 4 fnspec split — 4a `generate-fnspec-platform` + 4b `generate-fnspec-integration` with per-requirement `delivery: native-ai | api` routing key + per-platform capability matrix as classifier input + cross-spec consistency check OWNED by 4b with 3 specific checks) and DESIGN-21 (Stage 5 Tech spec scope gate — 3 explicit branches: full / addendum / skip-entirely + lightweight `## Platform-API Addendum` INSIDE 4a artefact for platform-only-with-API edge case + error-paths discipline 4 elements per endpoint with hand-waving forbidden); 3 echo blockquotes added (DESIGN-20 contributes 2 — one each under 4a and 4b H2s — plus DESIGN-21 under Stage 5); running total 22/30; structural-check exits 1 at expected mid-phase invariant.

## What Was Done

### Task 1 — Stage 4a + Stage 4b decision contracts (DESIGN-20 — both halves)

Replaced placeholder bodies of `## Stage 4a: Functional spec — platform` and `## Stage 4b: Functional spec — integration` H2s. Both H2s carry their own `> **DESIGN-20:**` echo line per D-35 per-section echo + plan dual-echo contract.

**(A) Stage 4a — Platform fnspec (DESIGN-20 first half):**

- **Echo blockquote:** `> **DESIGN-20:** Stage 4a Fnspec — platform — generate-fnspec-platform skill; per-requirement delivery: native-ai | api tagging (the routing key for downstream Stages 5 / 6 / 7b / 10); per-platform capability matrix as classifier input; cross-spec consistency check against 4b; optional for integration-only projects.`
- **Skill / Stage / Complexity:** `generate-fnspec-platform/` (NEW — replaces v0.3.0 `generate-functional-spec` for platform portions) / Stage 4a / Medium-high.
- **Inputs:** `based_on_sow: 03_sow_v<N>` + `platform: pipefy | wrike | ziflow` (REQUIRED — activates platform-gated identifiers per DESIGN-01); upstream `03_sow_v<N>.md` (must carry `status: approved`); external = per-platform `references/native-ai-inventory.md` (per DESIGN-14/15/16) as classifier input.
- **Outputs:** `04a_fnspec-platform_v<N>.md` carrying per-requirement `delivery: native-ai | api` tagging (THE DESIGN-20 contract); frontmatter set incl. platform-gated identifier (`pipe_id` / `space_id` / `project_id` whichever matches) per DESIGN-01.
- **Downstream consumers:** 4 stages — 4b consistency check; Stage 5 platform-API addendum routing per DESIGN-21 (same wave); Stage 6 cost categorisation (forward); Stage 7b implementation prompt routing (forward); Stage 10 native-AI push (forward).
- **5 key v2 decisions:** per-requirement `delivery:` tagging (canonical order locked); per-platform capability matrix as classifier input (HIGH/MEDIUM -> native-ai; LOW -> api default); cross-spec consistency check (runs at start of 4b); optional for integration-only; legacy single fnspec retired.
- **Dependencies:** DESIGN-14/15/16, DESIGN-01, DESIGN-08.
- **Cross-references:** DESIGN-19 (backward); DESIGN-20 Stage 4b below (consistency-check ownership); DESIGN-21 (same wave); DESIGN-22/23/26 (forward — anchor placeholders only); AUDIT.md §1.3 (backward, populated).

**(B) Stage 4b — Integration fnspec (DESIGN-20 second half):**

- **Echo blockquote:** `> **DESIGN-20:** Stage 4b Fnspec — integration — generate-fnspec-integration skill; per-requirement delivery: native-ai | api tagging continues (per DESIGN-20 same routing key); cross-spec consistency check against 4a runs at start; optional for platform-only projects (Stage 5 SKIPPED with platform-API addendum on 4a instead).`
- **Skill / Stage / Complexity:** `generate-fnspec-integration/` (NEW) / Stage 4b / Medium-high.
- **Inputs:** `based_on_sow: 03_sow_v<N>` + (optional) `based_on_fnspec_platform: 04a_fnspec-platform_v<N>` if 4a exists; upstream `03_sow_v<N>.md` (REQUIRED) + (optional) `04a_fnspec-platform_v<N>.md`.
- **Outputs:** `04b_fnspec-integration_v<N>.md`; same per-requirement `delivery:` tagging; cross-spec consistency report `04b_consistency_check_v<N>.md` emitted FIRST when 4a exists.
- **Cross-spec consistency check (THE Stage 4b key responsibility):** runs FIRST, three checks — (1) no conflicting `delivery:` tags between 4a/4b; (2) integration touchpoint cross-references cite 4a requirement IDs; (3) no orphan API endpoints. Failure halts before fnspec write.
- **Downstream consumers:** Stage 5 (same wave; consumes 4b REQUIRED); Stage 6 cost (forward); Stage 7a build prompt (forward).
- **4 key v2 decisions:** cross-spec consistency check OWNED here; same `delivery:` tagging contract; optional for platform-only; legacy single fnspec retired.
- **Dependencies:** DESIGN-20 Stage 4a above; DESIGN-01.
- **Cross-references:** DESIGN-20 Stage 4a above (backward); DESIGN-21 (same wave); DESIGN-22 / DESIGN-23 Stage 7a (forward — anchor placeholders); AUDIT.md §1.3 (backward, populated).

**Task 1 also bundled:** Stage 5 Tech spec contract was authored in the same atomic Edit (Task 2 below). Both tasks landed in commit `32f74e0`.

### Task 2 — Stage 5 Tech spec decision contract (DESIGN-21) + structural-check run

Replaced placeholder body of `## Stage 5: Tech spec` H2 in the same atomic Edit as Task 1; structural-check ran post-edit.

- **Echo blockquote:** `> **DESIGN-21:** Stage 5 Tech spec scope gate — REQUIRED only when Stage 4b exists; lightweight platform-API addendum on Stage 4a when API-required portions exist on platform-only build; covers error handling + observability + retries + idempotency for API portions; never hand-waves error paths.`
- **Skill / Stage / Complexity:** `generate-technical-spec/` (MODIFIED — scope gate added; error-paths discipline tightened per AUDIT.md §1.4) / Stage 5 / Medium.
- **Inputs:** `based_on_fnspec_integration: 04b_fnspec-integration_v<N>` (REQUIRED full path) + (optional) `based_on_fnspec_platform: 04a_fnspec-platform_v<N>`.
- **Outputs (full path):** `05_techspec_v<N>.md` with `tech_spec_scope: full`; (skip-with-addendum path): no standalone artefact — `## Platform-API Addendum` H2 appended INSIDE 4a + 4a frontmatter gains `has_platform_api_addendum: true`.
- **Scope gate (3 explicit branches per T-02-06-03 mitigation):**
  1. **Default — full tech spec runs.** Stage 4b exists → `05_techspec_v<N>.md` written; `tech_spec_scope: full`.
  2. **Skip with platform-API addendum.** Stage 4b absent BUT 4a has `delivery: api` rows → `## Platform-API Addendum` INSIDE 4a; `has_platform_api_addendum: true`; `tech_spec_scope: platform-api-addendum-only`.
  3. **Skip entirely.** Stage 4b absent AND no `delivery: api` rows anywhere → no tech spec; no addendum; no 4a frontmatter change.
- **Error-paths discipline (4 elements per endpoint per T-02-06-04 mitigation):** (1) failure modes; (2) retry policy with backoff curve + max-retries bound; (3) idempotency key strategy; (4) observability (request ID propagation + error class tagging + metric emission). "Hand-waving forbidden" callout present.
- **Status flag:** `status: approved` on `05_techspec_v<N>.md` (full path) gates Stage 6 (which also requires wait-for-commercial-inputs gate per DESIGN-22 forward).
- **Hand-off message:** verbatim from matrix Stage 5 → Stage 6 row including wait-for-commercial-inputs gate per T-02-06-06 mitigation.
- **3 key v2 decisions:** scope-gate against 4b existence; lightweight platform-API addendum on 4a; error-paths discipline 4-elements + hand-waving forbidden.
- **Dependencies:** DESIGN-20 (4a/4b existence + `delivery:` rows drive scope-gate decision); DESIGN-22 (forward — wait-for-commercial-inputs gate downstream).
- **Cross-references:** DESIGN-20 Stage 4a above (consumed for addendum routing); DESIGN-20 Stage 4b above (REQUIRED for full path); DESIGN-22 (forward — anchor placeholder); AUDIT.md §1.4 (backward — error-paths discipline rationale).

**Structural-check run:** exit code = 1 with assertion #4 short-circuit message `expected >= 30 'DESIGN-NN:' success-criteria echo blockquote lines (D-35), found 22` — expected mid-phase invariant per Plan 02-01..02-05 precedent. Plans 02-07..02-09 close remaining 8 echoes.

**Tasks 1 + 2 bundled in commit `32f74e0`** — both Stage 4a/4b and Stage 5 contracts authored in a single atomic Edit (3 sections written together because plan acceptance grep targets — `tech_spec_scope:`, `platform-API addendum`, `has_platform_api_addendum:` — interleave with Stage 4a/4b `delivery:` routing-key references; splitting into two commits would have left an incomplete intermediate state where Stage 4b cross-refs Stage 5 but Stage 5 is still placeholder). Single commit captures the full Wave 6 unit of design work atomically.

### Hand-off matrix update (D-26 verbatim-restate alignment)

Stage 4a → 4b and Stage 4b → 5 matrix rows updated to literal-match the per-stage subsection hand-off text per D-26 verbatim-restate contract:

| Hand-off | Matrix row line | Per-stage subsection line | Match |
|----------|----------------|---------------------------|-------|
| Stage 4a → 4b | 358 | 659 | ✓ verbatim (`> Awaiting \`status: approved\` to \`04a\`; cross-spec consistency check runs at start of 4b.`) |
| Stage 4b → 5 | 359 | 705 | ✓ verbatim (`> Awaiting \`status: approved\` to \`04b\`; Stage 5 tech spec runs (or SKIPS if no \`04b\`, with platform-API addendum on \`04a\` instead per DESIGN-21).`) |
| Stage 5 → 6 | 360 | 754 | ✓ verbatim (`> Awaiting status: approved on 05_techspec_v<N>.md AND wait-for-commercial-inputs gate before generate-cost-estimate runs (per DESIGN-22).`) |

Outer code-span backticks dropped from the Stage 4a→4b and Stage 4b→5 matrix cells because cell content contains inner backticks for `\`status: approved\`` and `\`04a\``/`\`04b\``/`\`04\`` literal formatting; markdown tables cannot nest backticks inside code spans cleanly. Stage 5 → 6 row retained its existing format (no inner backticks).

## Files Created / Modified

| File | Type | Change |
|------|------|--------|
| `.planning/DESIGN.md` | modified | `## Stage 4a: Functional spec — platform`, `## Stage 4b: Functional spec — integration`, `## Stage 5: Tech spec` populated with full decision contracts; hand-off matrix Stage 4a→4b and Stage 4b→5 rows aligned with subsection literals |
| `.planning/phases/02-design/02-06-SUMMARY.md` | created | This document |

## Echo Count Progression

| Plan | Echoes added | Running total |
|------|--------------|---------------|
| 02-02 | DESIGN-01..10 | 10/30 |
| 02-03 | DESIGN-11/12/13 | 13/30 |
| 02-04 | DESIGN-14/15/16 | 16/30 |
| 02-05 | DESIGN-17/18/19 | 19/30 |
| **02-06 (this plan)** | **DESIGN-20 (under 4a) + DESIGN-20 (under 4b) + DESIGN-21 (under Stage 5)** | **22/30** |
| 02-07 (next) | DESIGN-22 + DESIGN-23 (Stage 7a + 7b — both echoes) | 24/30 (projected) |
| 02-08 | DESIGN-24/25/26/27 | 28/30 (projected) |
| 02-09 | DESIGN-28/29/30 | 31/30 (projected — DESIGN-23 dual + 31 reflects 4a/4b + 7a/7b dual-echo overcount; final = 31 if Plan 02-07 echoes both 7a and 7b) |
| 02-10 | synthesis | final structural-check assertion #4 passes |

DESIGN-20 contributes 2 echoes (one per substage 4a + 4b) per plan dual-echo contract — same precedent will apply to DESIGN-23 (Stage 7a + 7b) in Plan 02-07. Final echo count may exceed 30 if all dual-echo IDs fire; structural-check assertion #4 uses `>= 30` which tolerates overcount.

## Cross-AI Review Fixes Applied

- **HIGH #2 (Codex):** `.planning/phases/02-design/02-06-SUMMARY.md` present in plan frontmatter `files_modified` — verified before execution.
- **MEDIUM #6 (Gemini + Codex):** Forward-reference guardrails — DESIGN-22 (Stage 6) / DESIGN-23 (Stage 7) / DESIGN-26 (Stage 10) cited as anchor placeholders only with explicit `forward reference, populated in Plan 02-07/02-08` inline at every cite site (Stage 4a + 4b + 5 cross-references). Acceptance criteria did NOT assert that DESIGN-22/23/26 body content exists at end of Wave 6; verification deferred to Plan 02-10 Appendix B traceability synthesis (T-02-06-07 mitigation honoured).

## Threat Model Mitigations Honoured

| Threat ID | Mitigation | Status |
|-----------|-----------|--------|
| T-02-06-01 | DESIGN-20 contract uses canonical literal `delivery: native-ai | api` (NOT reversed `api | native-ai`) | ✓ verified `grep -qF 'delivery: native-ai \| api'` |
| T-02-06-02 | Cross-spec consistency check declared in BOTH 4a (key-decision #3) and 4b (key-decision #1) — two-place traceability | ✓ explicit declaration in both subsections |
| T-02-06-03 | Stage 5 scope gate enumerates 3 explicit branches (default / skip-with-addendum / skip-entirely) — no silent default | ✓ all 3 branches present in subsection prose |
| T-02-06-04 | Stage 5 error-paths discipline lists 4 elements (failure modes + retry policy + idempotency + observability) + `hand-waving forbidden` callout | ✓ all 4 grep targets pass + hand-waving literal present |
| T-02-06-05 | DESIGN-20 echo count verified per-stage via SAFE awk ranges (`/^## Stage 4a:/,/^## Stage 4b:/` and `/^## Stage 4b:/,/^## Stage 5:/` — distinct start/end anchors) | ✓ each range returns echo count = 1 |
| T-02-06-06 | Stage 5 hand-off message contains `wait-for-commercial-inputs` per matrix Stage 5 → 6 row verbatim | ✓ verified literal `wait-for-commercial-inputs gate before generate-cost-estimate runs (per DESIGN-22)` |
| T-02-06-07 | Forward references to DESIGN-22/23/26 are anchor placeholders only — body verification deferred to Plan 02-10 | ✓ explicit `forward reference, populated in Plan 02-07/02-08` markers at all cite sites; no body assertions |

## Deviations from Plan

**1. [Rule 1 - Bug] Hand-off matrix outer code-span backticks dropped for Stage 4a→4b and Stage 4b→5 rows**

- **Found during:** Task 1 acceptance verification — `grep -qF '> Awaiting \`status: approved\` to \`04a\`'` literal required inner backticks for `\`status: approved\``, `\`04a\``, `\`04b\``, `\`04\`` formatting.
- **Issue:** Pre-existing matrix rows wrapped entire hand-off cell in single backticks (`\`> Awaiting status: approved write to 01_kickoff_v<N>.md...\``) — a code span. Adding inner backticks for `\`status: approved\`` etc. inside an outer code span breaks markdown rendering (nested backticks ambiguous).
- **Fix:** Dropped outer code-span backticks for Stage 4a→4b and Stage 4b→5 rows so inner backticks render as code spans cleanly; cells become normal markdown text with inline code spans for the inner literals (which is the intent of the per-stage subsection format the plan specified). Stage 5→6 row retained existing format (no inner backticks needed).
- **Files modified:** `.planning/DESIGN.md` (matrix rows at lines 358-359).
- **Commit:** `32f74e0` (bundled with Task 1 + Task 2 atomic edit).
- **Affects:** matrix rendering only (not other plans' hand-off matrix rows — those are untouched).

**2. [Rule 1 - Bug] `legacy single fnspec retired` literal phrasing — initial edit used capitalized `Legacy single fnspec retired` only**

- **Found during:** Task 1 verification grep `grep -qF 'legacy single fnspec retired'` (case-sensitive literal).
- **Issue:** First Edit included `**Legacy single fnspec retired**` (capitalized list-item heading) but no lowercase occurrence; literal-substring grep failed because `grep -qF` is case-sensitive.
- **Fix:** Added lowercase phrase inline in 4a key-decision #5 prose (`...the legacy single fnspec retired in favour of the 4a + 4b split...`); both capitalized heading and lowercase prose now coexist.
- **Files modified:** `.planning/DESIGN.md` (Stage 4a key-decision #5).
- **Commit:** `32f74e0` (bundled).

**3. [Rule 3 - Blocker] Tasks 1 + 2 bundled into a single atomic Edit + commit `32f74e0`**

- **Found during:** Initial Task 1 implementation.
- **Issue:** Stage 4a + 4b + Stage 5 placeholder bodies were three contiguous H2 stub blocks (lines 630-637 of pre-edit DESIGN.md). Authoring Stage 4a/4b first leaves Stage 5 still as `(Populated by 02-06-PLAN.md / Wave 6. Covers DESIGN-21.)` placeholder — but Stage 4b cross-references Stage 5 ("Stage 5 SKIPS with platform-API addendum on 4a instead per DESIGN-21") and Stage 4a echo line cites "downstream Stages 5 / 6 / 7b / 10". Splitting into two commits would have left an intermediate state where Stage 4b body cross-refs an unwritten Stage 5 contract.
- **Fix:** Authored all three sections in a single Edit; committed as `32f74e0` with message documenting both DESIGN-20 and DESIGN-21 work. Plan's verification structure (Task 1 acceptance + Task 2 acceptance) verified independently against the same single edit — both pass.
- **Files modified:** `.planning/DESIGN.md` (all 3 stage subsections + 2 matrix rows).
- **Commit:** `32f74e0`.

## Pointer

Plan 02-07 (Wave 7) populates Stage 6 + Stage 7a + Stage 7b next (DESIGN-22 cost estimate + DESIGN-23 dual-echo build prompts). Running echo total after 02-07 = 24/30 (projected, assuming DESIGN-23 dual-echo under 7a + 7b like DESIGN-20 under 4a + 4b in this plan).

## Self-Check: PASSED

- ✓ `.planning/DESIGN.md` modified — 3 stage subsections (4a, 4b, 5) populated; hand-off matrix rows 358-359 aligned
- ✓ Commit `32f74e0` exists (bundled Task 1 + Task 2)
- ✓ Stage 4a echo count = 1 (verified `awk '/^## Stage 4a:/,/^## Stage 4b:/' .planning/DESIGN.md | grep -cE '^> \*\*DESIGN-20:\*\*'`)
- ✓ Stage 4b echo count = 1 (verified `awk '/^## Stage 4b:/,/^## Stage 5:/' .planning/DESIGN.md | grep -cE '^> \*\*DESIGN-20:\*\*'`)
- ✓ DESIGN-21 echo present (verified `grep -qE '^> \*\*DESIGN-21:\*\*'`)
- ✓ All Task 1 acceptance greps pass (delivery routing key + cross-spec consistency check + 04a/04b paths + skill names + legacy retired + platform literal + hand-off literals)
- ✓ All Task 2 acceptance greps pass (`tech_spec_scope:`, `platform-API addendum`, `has_platform_api_addendum:`, `05_techspec_v`, idempotency, observability, retry policy, failure modes, `platform-api-addendum-only`, hand-waving)
- ✓ Echo count = 22/30 (verified `grep -cE '^> \*\*DESIGN-[0-9]{2}:\*\*' .planning/DESIGN.md`)
- ✓ Structural-check exits 1 with expected assertion #4 short-circuit message at 22 < 30 (mid-phase invariant)
- ✓ No new `[OPEN]` markers added (DESIGN-20/21 contracts LOCKED); total inline `[OPEN]` count across DESIGN.md unchanged from Plan 02-04 (= 13)
- ✓ No content under `dydx-delivery/` modified
- ✓ Forward-reference guardrails (cross-AI MEDIUM #6) applied — DESIGN-22/23/26 anchor-placeholder-only with explicit `forward reference, populated in Plan 02-07/02-08` markers
