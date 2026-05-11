---
phase: 02-design
plan: 05
subsystem: stages-1-3-skills
tags: [design, stage-skills, kickoff, discovery, sow, wave-5]
requires: [cross-cutting-decisions-locked, skill-layout-locked, skill-inventory-locked, handoff-matrix-locked, platform-skills-locked]
provides: [stage-1-kickoff-design-17, stage-2-discovery-design-18, stage-3-sow-design-19, dual-branch-routing-locked, raw-notes-mode-retired, single-sow-scope-locked]
affects: [.planning/DESIGN.md]
tech_stack:
  added: []
  patterns:
    - "Per-stage decision contract shape per D-20 (Skill / Stage / Complexity / Inputs / Outputs / Downstream consumer / Status flag(s) / Hand-off message / Key v2 decisions / Dependencies / Cross-references)"
    - "Hand-off message verbatim restate from DESIGN-13 matrix per D-26 (literal-string match between matrix cell and per-stage subsection)"
    - "Dual-branch routing via single `kickoff_branch:` enum field — DESIGN-17 produces it; DESIGN-18 reads to skip; DESIGN-19 reads for direct-from-kickoff path"
    - "Forward-reference guardrails (cross-AI MEDIUM #6) — DESIGN-20 cited as anchor placeholder; body verification deferred to Plan 02-10"
    - "Echo blockquote `> **DESIGN-NN:**` pattern per D-35 — 3 echo lines added; running total 19/30"
key_files:
  created:
    - .planning/phases/02-design/02-05-SUMMARY.md
  modified:
    - .planning/DESIGN.md
decisions:
  - "Phase 2 Plan 05: Stage 1 dual-branch contract locked — single `kickoff_branch:` enum field on `01_kickoff_v<N>.md` steers downstream stages (`discovery-ready` -> Stage 2; `draft-sow` -> SKIP Stage 2 -> Stage 3). DESIGN-18 + DESIGN-19 both read this same field — no separate routing flags."
  - "Phase 2 Plan 05: Stage 1 Field Notes triage filter locked at `processed_at IS NULL` (per DESIGN-09 directional boundary — Coda is read-only triage queue, never auto-merged). Reviewer human-classifies during kickoff approval; only then does row's `processed_at` get written back."
  - "Phase 2 Plan 05: Stage 1 Miro paste fallback locked (per DESIGN-07 connector probe + AUDIT.md §AUDIT-08 Miro MCP currently MISSING). When Miro MCP comes online (Phase 1 of v2.x build), API ingest replaces paste fallback without contract change — `kickoff-capture/` skill structure stays stable."
  - "Phase 2 Plan 05: Stage 1 auto-classification with explicit `[unknown — needs human classification]` inline markers — forces visible reviewer triage instead of silent guesswork. Auto-classifies into v0.3.0 canonical sections (system / users / triggers / data / rules / integrations / exceptions / failure-points)."
  - "Phase 2 Plan 05: Stage 2 raw-notes mode RETIRED — v0.3.0's 'paste meeting notes here' entry path removed. Discovery becomes pure transform of approved kickoff. Eliminates 'did discovery start from notes or kickoff?' ambiguity that v0.3.0 silently allowed."
  - "Phase 2 Plan 05: Stage 2 `based_on_kickoff:` field MANDATORY (no v0.3.0 lenient absence). Approval-gate hook + frontmatter-validate hook (DESIGN-04 plugin self-tests, D-24) refuse `02_discovery_v<N>.md` writes lacking the field."
  - "Phase 2 Plan 05: Stage 2 skip behaviour explicit (not silent) — when `kickoff_branch: draft-sow`, `discovery-intake/` skill emits 'Stage 2 SKIPPED — kickoff produced draft SOW; routing to Stage 3' hand-off and exits without writing `02_discovery_v<N>.md`. Reviewer sees the routing decision logged."
  - "Phase 2 Plan 05: Stage 3 single-SOW scope locked — ONE SOW covers BOTH platform work and integration work. Stage 4 is where platform/integration split happens (per DESIGN-20 forward ref). Stage 3 stays unified for client commercial review."
  - "Phase 2 Plan 05: Stage 3 `client_review` retained explicitly per AUDIT.md §AUDIT-01.2 + DESIGN-08 status-lifecycle survey result — interim commercial-review state is real workflow stage, not v0.3.0 quirk."
  - "Phase 2 Plan 05: Hand-off message verbatim restate verified — both Stage 2 -> Stage 3 and Stage 3 -> Stage 4a strings appear exactly twice in DESIGN.md (matrix row + per-stage subsection); literal-substring grep matches pass."
  - "Phase 2 Plan 05: Echo count progresses 16 -> 19/30 (DESIGN-17 + DESIGN-18 + DESIGN-19 added); structural-check exits 1 with assertion #4 short-circuit at 19 < 30 — expected mid-phase invariant; Plans 02-06..02-09 close remaining 11."
  - "Phase 2 Plan 05: Forward-reference guardrails per cross-AI review MEDIUM #6 honoured — DESIGN-20 (Stage 4 split downstream) cited as anchor placeholder only with explicit `forward — populated in Plan 02-06` inline at every cite site; acceptance criteria did NOT assert DESIGN-20 body content exists; deferred to Plan 02-10 Appendix B traceability synthesis."
  - "Phase 2 Plan 05: No new `[OPEN: Phase 4 — ...]` markers added — DESIGN-17/18/19 contracts are LOCKED. Stage 1 Miro swimlane-reconstruction algorithm remains build-phase research (deferred per CONTEXT.md `<deferred>` — NOT a fresh `[OPEN]` here). Total inline `[OPEN]` count across DESIGN.md unchanged from Plan 02-04 (= 13)."
metrics:
  duration_minutes: 8
  completed_date: "2026-05-09"
  task_count: 2
  file_count: 1
---

# Phase 2 Plan 05: Stage 1-3 skills (Kickoff + Discovery + SOW) Summary

**One-liner:** Locked DESIGN-17 (Stage 1 Kickoff capture — dual-branch routing via `kickoff_branch:` enum + Field Notes triage filter `processed_at IS NULL` + Miro paste fallback + auto-classification with `[unknown]` markers), DESIGN-18 (Stage 2 Discovery refactor — raw-notes mode RETIRED + mandatory `based_on_kickoff:` + skip-when-draft-SOW behaviour reading upstream `kickoff_branch:`), and DESIGN-19 (Stage 3 SOW refactor — single SOW covering platform AND integration + canonical 4-stage lifecycle with `client_review` retained); 3 echo blockquotes added; running total 19/30; structural-check exits 1 at expected mid-phase invariant.

## What Was Done

### Task 1 — Stage 1 Kickoff capture decision contract (DESIGN-17)

Replaced placeholder body of `## Stage 1: Kickoff capture` H2 with full per-stage decision contract per D-20:

- **Echo blockquote** (D-35): `> **DESIGN-17:** Stage 1 Kickoff capture — inputs (...); dual artefact branching (...); Field Notes triage from Coda brain doc (defaults to processed_at IS NULL, never auto-merges per DESIGN-09); Miro paste fallback when API ingest unavailable; auto-classification into kickoff template sections with explicit "unknown" markers.`
- **Skill / Stage / Complexity:** `kickoff-capture/` (NEW) / Stage 1 (`01_kickoff_*` per DESIGN-02) / Medium.
- **Inputs:** `client:` + `project:` + `frontmatter_version: 2`; no upstream artefact (Stage 1 is entry point); external inputs = meeting notes / requirements docs / internal feedback / Miro paste / Field Notes from Coda (read-only).
- **Outputs:** `01_kickoff_v<N>.md` carrying `kickoff_branch: discovery-ready | draft-sow`, `field_notes_processed_count: <N>`, `status: draft`. Branch routing rules:
  - `kickoff_branch: discovery-ready` → Stage 2 consumes.
  - `kickoff_branch: draft-sow` → Stage 2 SKIPS; Stage 3 consumes directly.
- **Auto-classification markers:** `[unknown — needs human classification]` inline whenever confidence is low.
- **Status flag:** `status: approved` gates either downstream stage; approval-gate hook (DESIGN-06) refuses writes lacking `approved_by` + `approved_at`.
- **Hand-off message:** verbatim from DESIGN-13 matrix Stage 1 → Stage 2 row.
- **4 key v2 decisions:** dual-branch artefact / Field Notes triage filter `processed_at IS NULL` / Miro paste fallback / auto-classification with explicit unknown markers.
- **Dependencies:** DESIGN-09 / DESIGN-07 / DESIGN-01 / DESIGN-06.
- **Cross-references:** DESIGN-18 + DESIGN-19 (forward); AUDIT.md §AUDIT-08 + §AUDIT-01.1 (backward, populated).

Stage 1 subsection length = 41 lines (≥ 30 floor). Commit: `7644a36`.

### Task 2 — Stage 2 Discovery + Stage 3 SOW decision contracts (DESIGN-18, DESIGN-19)

**(A) Stage 2 Discovery refactor (DESIGN-18):**

- **Echo blockquote:** `> **DESIGN-18:** Stage 2 Discovery intake refactor — consume 01_kickoff_v* artefact (skip raw-notes mode); skip entire stage when kickoff produced a draft SOW; same template structure as v0.3.0 otherwise.`
- **Skill / Stage / Complexity:** `discovery-intake/` (MODIFIED) / Stage 2 / Low.
- **Inputs:** `based_on_kickoff: 01_kickoff_v<N>` MANDATORY; upstream artefact `01_kickoff_v<N>.md` with `status: approved`; external inputs RETIRED.
- **Outputs:** `02_discovery_v<N>.md` with canonical lifecycle `draft → client_review → approved`.
- **Skip behaviour:** explicit (not silent) — when upstream `kickoff_branch: draft-sow`, skill emits "Stage 2 SKIPPED" hand-off and exits without writing artefact.
- **Hand-off message:** verbatim from matrix Stage 2 → Stage 3 row.
- **Key v2 decisions:** raw-notes mode RETIRED / kickoff-as-input forces explicit `based_on_kickoff:` / skip reads upstream `kickoff_branch:` / template structurally unchanged.
- **Dependencies:** DESIGN-17 / DESIGN-01 / DESIGN-06 / DESIGN-08.
- **Cross-references:** DESIGN-17 (backward) / DESIGN-19 (forward) / AUDIT.md §AUDIT-01.1.

**(B) Stage 3 SOW refactor (DESIGN-19):**

- **Echo blockquote:** `> **DESIGN-19:** Stage 3 SOW refactor — single SOW covering platform AND integration; status lifecycle locked to canonical scheme (DESIGN-01); structurally unchanged from v0.3.0 otherwise.`
- **Skill / Stage / Complexity:** `generate-sow/` (UNCHANGED-structure / behaviour-modified) / Stage 3 / Medium.
- **Inputs:** `based_on_discovery: 02_discovery_v<N>` (normal) OR `based_on_kickoff: 01_kickoff_v<N>` (draft-SOW path); upstream artefact must carry `status: approved`.
- **Outputs:** `03_sow_v<N>.md`; canonical lifecycle including `client_review` retained per AUDIT.md §AUDIT-01.2 + DESIGN-08.
- **Single-spec scope:** ONE SOW covers BOTH platform AND integration; Stage 4 split downstream (DESIGN-20 forward).
- **Hand-off message:** verbatim from matrix Stage 3 → Stage 4a row.
- **Key v2 decisions:** canonical 4-stage lifecycle / `client_review` retained / single SOW covers BOTH / structurally unchanged from v0.3.0.
- **Dependencies:** DESIGN-17/18 / DESIGN-01 / DESIGN-08.
- **Cross-references:** DESIGN-18 (backward) / DESIGN-20 (forward — Stage 4 split downstream, populated in Plan 02-06) / AUDIT.md §AUDIT-01.2.

**(C) Structural-check run:** exit code = 1 with assertion #4 short-circuit message `expected >= 30 'DESIGN-NN:' success-criteria echo blockquote lines (D-35), found 19` — expected mid-phase invariant per Plan 02-01 precedent. Plans 02-06..02-09 close remaining 11 echoes.

Commit: `e8f903f`.

## Files Created / Modified

| File | Type | Change |
|------|------|--------|
| `.planning/DESIGN.md` | modified | `## Stage 1: Kickoff capture`, `## Stage 2: Discovery refactor`, `## Stage 3: SOW refactor` populated with full decision contracts |
| `.planning/phases/02-design/02-05-SUMMARY.md` | created | This document |

## Echo Count Progression

| Plan | Echoes added | Running total |
|------|--------------|---------------|
| 02-02 | DESIGN-01..10 | 10/30 |
| 02-03 | DESIGN-11/12/13 | 13/30 |
| 02-04 | DESIGN-14/15/16 | 16/30 |
| **02-05 (this plan)** | **DESIGN-17/18/19** | **19/30** |
| 02-06 (next) | DESIGN-20/21 | 21/30 (projected) |
| 02-07 | DESIGN-22/23 | 23/30 (projected) |
| 02-08 | DESIGN-24/25/26/27 | 27/30 (projected) |
| 02-09 | DESIGN-28/29/30 | 30/30 (projected — structural-check assertion #4 passes) |

## Cross-AI Review Fixes Applied

- **HIGH #2 (Codex):** Added `.planning/phases/02-design/02-05-SUMMARY.md` to plan frontmatter `files_modified` — verified before execution; fix already encoded in plan revision dated 2026-05-09.
- **MEDIUM #6 (Gemini + Codex):** Forward-reference guardrails — DESIGN-20 (Stage 4 split) cited as anchor placeholder with explicit `forward — populated in Plan 02-06` inline marker at every cite site (Stage 1 + Stage 2 + Stage 3 cross-references). Acceptance criteria did NOT assert DESIGN-20 body content exists; verification deferred to Plan 02-10 Appendix B traceability synthesis (T-02-05-06 mitigation honoured).

## Hand-off Verbatim Verification

Both inter-stage hand-off messages literal-string match between DESIGN-13 matrix row and per-stage subsection (D-26 contract):

| Hand-off | Matrix row | Per-stage subsection | Match |
|----------|-----------|---------------------|-------|
| Stage 1 → Stage 2 | line 355 | Stage 1 subsection | ✓ verbatim (literal substring grep matches 2 occurrences in DESIGN.md) |
| Stage 2 → Stage 3 | line 356 | Stage 2 subsection | ✓ verbatim (2 occurrences) |
| Stage 3 → Stage 4a | line 357 | Stage 3 subsection | ✓ verbatim (2 occurrences) |

## Threat Model Mitigations Honoured

| Threat ID | Mitigation | Status |
|-----------|-----------|--------|
| T-02-05-01 | Hand-off message verbatim from matrix | ✓ literal-substring grep verified 2 occurrences each |
| T-02-05-02 | Field Notes filter expressed as `processed_at IS NULL` (NOT `processed_at = null`) | ✓ verified `grep -qF 'processed_at IS NULL'` |
| T-02-05-03 | DESIGN-19 includes `client_review` retention rationale | ✓ explicit retention rationale + AUDIT.md §AUDIT-01.2 cite |
| T-02-05-04 | No full SKILL.md prose drafted | ✓ decision-contract-only per D-20 |
| T-02-05-05 | No new `[OPEN]` marker for Miro swimlane-reconstruction | ✓ no fresh `[OPEN]` markers added (deferred per CONTEXT.md `<deferred>` block, not inline) |
| T-02-05-06 | Forward-references to DESIGN-20 are anchor placeholders only | ✓ explicit `forward — populated in Plan 02-06` markers at all cite sites; no body assertions |

## Deviations from Plan

None — plan executed exactly as written. No Rule 1/2/3 auto-fixes triggered. No Rule 4 architectural decisions surfaced.

## Pointer

Plan 02-06 (Wave 6) populates Stage 4a/4b + Stage 5 next (DESIGN-20, 21) — fnspec split (platform / integration) + tech spec scope gate. Running echo total after 02-06 = 21/30 (projected).

## Self-Check: PASSED

- ✓ `.planning/DESIGN.md` modified — 3 stage subsections populated
- ✓ Commit `7644a36` exists (Task 1 — Stage 1 Kickoff capture)
- ✓ Commit `e8f903f` exists (Task 2 — Stage 2 Discovery + Stage 3 SOW + structural-check run)
- ✓ Echo count = 19/30 (verified `grep -cE '^> \*\*DESIGN-[0-9]{2}:\*\*' .planning/DESIGN.md`)
- ✓ Structural-check exits 1 with expected assertion #4 short-circuit message at 19 < 30 (mid-phase invariant)
- ✓ All Task 1 + Task 2 acceptance-criteria greps pass
- ✓ Hand-off messages verbatim (literal-substring match — 2 occurrences each for Stage 1→2 / Stage 2→3 / Stage 3→4a)
- ✓ No new `[OPEN]` markers added; total inline `[OPEN]` count across DESIGN.md unchanged from Plan 02-04 (= 13)
- ✓ No content under `dydx-delivery/` modified
- ✓ Forward-reference guardrails (cross-AI MEDIUM #6) applied — DESIGN-20 anchor-placeholder-only
