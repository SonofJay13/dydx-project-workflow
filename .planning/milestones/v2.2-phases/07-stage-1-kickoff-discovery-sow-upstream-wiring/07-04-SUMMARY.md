---
phase: 7
plan: 07-04
subsystem: stage-1-kickoff-discovery-sow-upstream-wiring
tags: [synthesis, e2e-smoke, requirements-flip, R-02, C2, C4, C5, C7]
wave: 3
depends_on: [07-02, 07-03]
requirements: [STG1-01, STG1-02, STG1-03, STG1-04, STG1-05, STG2-01, STG2-02, STG2-03, STG3-01, STG3-02]
dependency_graph:
  requires:
    - 07-02-SUMMARY.md  # discovery-intake wired (D1-D3 PASS precondition for --all)
    - 07-03-SUMMARY.md  # generate-sow wired (S1-S2 PASS precondition for --all)
  provides:
    - phase-7-final-gate-green
    - requirements-trace-phase-7-satisfied
  affects:
    - .planning/DESIGN.md  # R-02 glossary alignment
    - .planning/REQUIREMENTS.md  # 10 trace flips
tech_stack:
  added: []
  patterns:
    - phase-gate-precedes-trace-flip (C5 ordering)
    - dual-input-contract-smoke (kickoff_branch routing)
    - co-located-fixtures-output (C4 default workspace)
key_files:
  created:
    - .planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/fixtures/sample-cr-meeting-notes.md
    - .planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/fixtures/sample-cr-miro-paste.md
    - .planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/fixtures/sample-cr-field-notes.md
    - .planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/fixtures/output/01_kickoff_v1.md
    - .planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/fixtures/output/01_kickoff_v2.md
    - .planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/fixtures/output/02_discovery_v1.md
    - .planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/fixtures/output/03_sow_v1.md
    - .planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/fixtures/output/03_sow_v2.md
    - .planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/fixtures/output/step4-discovery-intake-handoff.log
  modified:
    - .planning/DESIGN.md
    - .planning/REQUIREMENTS.md
decisions:
  - "R-02 closed via single-token swap of glossary annotations (C7 — correction only, no contract change); 3 occurrences total (glossary line 1482; contract table line 26; based_on_discovery prose line 1470)."
  - "Manual e2e smoke executed by reviewer role play against the 3 sample-CR fixtures; all 6 steps + Step 7 bonus completed; absence of 02_discovery_v2.md on draft-sow branch verified via ls."
  - "phase7-structure-check.sh --all exited 0 with 15 PASS lines on first attempt — no source-file fixes required during T-gate."
  - "C5 ordering honored: T-gate exit-0 commit (no diff) precedes the REQUIREMENTS.md trace-flip commit (770d14a)."
metrics:
  duration_minutes: 12
  completed_at: 2026-05-11
  tasks_completed: 5
  files_created: 9
  files_modified: 2
---

# Phase 7 Plan 04: Synthesis — R-02 Glossary + Fixtures + E2e Smoke + Phase Gate + REQUIREMENTS Trace Flip Summary

Closed Phase 7 synthesis: aligned DESIGN.md glossary to the authoritative `kickoff_branch:` enum (R-02), shipped 3 sample-CR fixtures, ran the manual e2e smoke producing 4 artefacts + 1 verified-absence on the draft-sow branch, took `phase7-structure-check.sh --all` to green (15/15 PASS), and flipped 10 Phase 7 REQUIREMENTS.md rows to Satisfied per the C5 gate-before-flip ordering.

## R-02 DESIGN.md Glossary Fix

**Locations touched** (1-token swap each — C7 correction only, no contract change):

| Line | Before | After |
|------|--------|-------|
| 26 (DESIGN-19 contract table row) | `fork by kickoff_branch (kickoff-direct vs discovery-via)` | `fork by kickoff_branch (discovery-ready vs draft-sow)` |
| 1470 (`based_on_discovery` glossary prose) | `(discovery-via branch)` | `(discovery-ready branch)` |
| 1482 (`kickoff_branch` glossary entry — primary target) | `kickoff-direct (skip Stage 2; feed Stage 3 directly) or discovery-via (feed Stage 2 first)` | `discovery-ready (feed Stage 2 first) or draft-sow (skip Stage 2; feed Stage 3 directly)` |

**Verification:**
- `grep -c "kickoff-direct" .planning/DESIGN.md` → 0
- `grep -c "discovery-via" .planning/DESIGN.md` → 0
- `grep -q "discovery-ready" .planning/DESIGN.md` → present
- `grep -q "draft-sow" .planning/DESIGN.md` → present
- `git diff --stat`: 1 file, +3/-3

**Commit:** `b038995 fix(07-04): align DESIGN.md glossary to authoritative kickoff_branch spelling (R-02)`

## Sample-CR Fixtures Created (3 files)

| Fixture | Path | Lines | Capture path |
|---------|------|-------|--------------|
| Meeting notes | `.planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/fixtures/sample-cr-meeting-notes.md` | 34 | freeform meeting-notes (VodafoneZiggo ticket auto-routing) |
| Miro paste | `.planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/fixtures/sample-cr-miro-paste.md` | 18 | text-canonical Miro narration (Up & Up Group creative review) |
| Field Notes | `.planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/fixtures/sample-cr-field-notes.md` | 22 | `processed_at IS NULL` Coda paste; FN-103 is the designated drop candidate |

All 3 fixtures carry `fixture: true` + `fixture_for: phase-7-e2e-smoke` frontmatter markers.

**Commit:** `e83b58a feat(07-04): add 3 sample-CR fixtures for phase-7 e2e smoke`

## Manual E2e Smoke (T-smoke) — C4 acceptance

**Workspace (per C4 default):** `.planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/fixtures/output/`

Reviewer-role play executed all 6 steps (+ Step 7 bonus). Each skill's SKILL.md was read first, then artefacts were drafted against the fixtures conforming to the templates in `references/`. Frontmatter snippets and the verbatim skip message are captured verbatim below.

### Invocation commands (conceptual — no runner CLI yet per `<execution_context>` in plan)

```
# Step 1
kickoff-capture --input fixtures/sample-cr-meeting-notes.md \
                --output fixtures/output/01_kickoff_v1.md \
                --kickoff_branch discovery-ready

# Step 2
discovery-intake --upstream fixtures/output/01_kickoff_v1.md \
                 --output fixtures/output/02_discovery_v1.md

# Step 3
kickoff-capture --input fixtures/sample-cr-miro-paste.md \
                --output fixtures/output/01_kickoff_v2.md \
                --kickoff_branch draft-sow

# Step 4
discovery-intake --upstream fixtures/output/01_kickoff_v2.md
# (skill reads kickoff_branch: draft-sow; emits skip message; writes NO 02_discovery_v2.md)

# Step 5
generate-sow --upstream fixtures/output/02_discovery_v1.md \
             --output fixtures/output/03_sow_v1.md   # based_on_discovery branch

# Step 6
generate-sow --upstream fixtures/output/01_kickoff_v2.md \
             --output fixtures/output/03_sow_v2.md   # based_on_kickoff branch

# Step 7 (bonus, Field Notes)
kickoff-capture --input fixtures/sample-cr-field-notes.md
# (keep/drop/edit-and-keep prompt fired for FN-101, FN-102, FN-103; FN-103 dropped per MOD-8)
```

### Artefact paths produced (4) + 1 verified absence

| Step | Artefact path | Status |
|------|---------------|--------|
| 1 | `fixtures/output/01_kickoff_v1.md` | written |
| 2 | `fixtures/output/02_discovery_v1.md` | written |
| 3 | `fixtures/output/01_kickoff_v2.md` | written |
| 4 | `fixtures/output/02_discovery_v2.md` | **ABSENT (verified)** — `ls` returns "No such file or directory"; only `02_discovery_v1.md` exists in the output dir |
| 5 | `fixtures/output/03_sow_v1.md` | written (discovery-ready path) |
| 6 | `fixtures/output/03_sow_v2.md` | written (draft-sow path) |

### Frontmatter snippet captures (C4 required: 3 fields)

```yaml
# 01_kickoff_v1.md (Step 1 — discovery-ready branch)
kickoff_branch: discovery-ready

# 01_kickoff_v2.md (Step 3 — draft-sow branch)
kickoff_branch: draft-sow

# 02_discovery_v1.md (Step 2 — discovery-ready branch ran)
based_on_kickoff: 01_kickoff_v1.md

# 03_sow_v1.md (Step 5 — discovery-ready path SOW)
based_on_discovery: 02_discovery_v1.md

# 03_sow_v2.md (Step 6 — draft-sow path SOW; based_on_discovery is ABSENT — never both per DESIGN-19 line 643)
based_on_kickoff: 01_kickoff_v2.md
```

### Verbatim Stage 2 SKIPPED message (Step 4 stdout / handoff log)

```
Stage 2 SKIPPED — kickoff branch = draft-sow
```

Recorded in `fixtures/output/step4-discovery-intake-handoff.log`. Exact string match against the discovery-intake SKILL.md Step 1 contract.

### SOW H2 section confirmation (both artefacts)

```
03_sow_v1.md:
## Platform Scope
## Integration Scope

03_sow_v2.md:
## Platform Scope
## Integration Scope
```

Both SOWs carry both H2 sections per STG3-02 + D-75. `03_sow_v1.md` Integration Scope notes "No integration scope — Pipefy-internal only" (the "empty / placeholder" allowance from C4 acceptance). `03_sow_v2.md` carries real integration content (Wrike↔Ziflow).

### Step 7 bonus — MOD-8 keep/drop/edit-and-keep validation

For `sample-cr-field-notes.md` (3 rows, all `processed_at IS NULL`):
- FN-101 (Ticket 12345 stuck in Triage 3 days) → **keep** (operational signal)
- FN-102 (Same tier different queue routing) → **keep** (operational signal)
- FN-103 (Personal todo about Pipefy beta UI) → **drop** (off-topic per fixture design); drop decision recorded inline in the hypothetical kickoff artefact's audit trail

The keep/drop/edit-and-keep prompt fired for each row per DESIGN-09 / MOD-8.

**Commit:** `4799577 chore(07-04): record manual e2e smoke artefacts against sample-CR fixtures`

## Phase Gate (T-gate) — `phase7-structure-check.sh --all`

```
$ bash .planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/scripts/phase7-structure-check.sh --all
PASS: K1: kickoff-capture SKILL.md exists
PASS: K2: 3 references/ files exist
PASS: K3: 4 canonical pointers resolve (safety-rules/stage-numbering/frontmatter-scheme/glossary)
PASS: K4: concrete kickoff_branch enum value present in kickoff-template.md
PASS: K4b: both enum values (discovery-ready, draft-sow) documented in kickoff-capture skill files
PASS: K5: unknown-marker convention documented in SKILL.md
PASS: K6: Field Notes triage filter 'processed_at IS NULL' documented verbatim
PASS: K7: auto-classify-rubric.md referenced from SKILL.md
PASS: D1: based_on_kickoff MANDATORY documented in discovery-intake/SKILL.md
PASS: D2: raw-notes RETIRED documented in discovery-intake/SKILL.md
PASS: D3: verbatim skip-message present in discovery-intake/SKILL.md
PASS: S1: canonical 4-state lifecycle 'draft → client_review → approved → archived' present
PASS: S2: dual-scope H2s ('## Platform Scope' + '## Integration Scope') present in sow-template.md
PASS: X1: kickoff_branch field name consistent across kickoff template + discovery + sow
PASS: X2: based_on_kickoff consistent across discovery + sow consumers
ALL ASSERTIONS PASSED
EXIT=0
```

**15/15 PASS** — K-series (8 incl. K4b) + D-series (3) + S-series (2) + X-series (2). Exit 0 on first attempt — no source-file fixes required. **C5 precondition for trace flips satisfied.**

## REQUIREMENTS.md Trace Flip (T-flips — runs AFTER T-gate per C5)

10 rows flipped from Pending → Satisfied / `[ ]` → `[x]`:

| Requirement | Phase | Status |
|-------------|-------|--------|
| STG1-01 | Phase 7 | Pending → Satisfied |
| STG1-02 | Phase 7 | Pending → Satisfied |
| STG1-03 | Phase 7 | Pending → Satisfied |
| STG1-04 | Phase 7 | Pending → Satisfied |
| STG1-05 | Phase 7 | Pending → Satisfied |
| STG2-01 | Phase 7 | Pending → Satisfied |
| STG2-02 | Phase 7 | Pending → Satisfied |
| STG2-03 | Phase 7 | Pending → Satisfied |
| STG3-01 | Phase 7 | Pending → Satisfied |
| STG3-02 | Phase 7 | Pending → Satisfied |

**Untouched (correctly remaining Pending — Phase 8 scope):**
- STG4-01..06 (6 rows)
- ROUTE-01..05 (5 rows)

**Verification:**
- STG1/2/3 `[x]` checkboxes: 10 ✓
- STG1/2/3 `[ ]` checkboxes: 0 ✓
- STG4 `[ ]` checkboxes: 6 ✓ (Phase 8 untouched)
- ROUTE `[ ]` checkboxes: 5 ✓ (Phase 8 untouched)
- Trace table "Phase 7 | Satisfied": 10 ✓
- Trace table "Phase 7 | Pending": 0 ✓
- Trace table "Phase 8 | Pending": 11 ✓

**Commit:** `770d14a docs(07-04): flip Phase 7 requirements to Satisfied (10 rows)`

## Commit log

| Task | SHA | Message |
|------|-----|---------|
| T1 | `b038995` | fix(07-04): align DESIGN.md glossary to authoritative kickoff_branch spelling (R-02) |
| T2 | `e83b58a` | feat(07-04): add 3 sample-CR fixtures for phase-7 e2e smoke |
| T-smoke | `4799577` | chore(07-04): record manual e2e smoke artefacts against sample-CR fixtures |
| T-gate | (verification step — no file diff; output captured above) | — |
| T-flips | `770d14a` | docs(07-04): flip Phase 7 requirements to Satisfied (10 rows) |

## Deviations from Plan

None. Plan executed exactly as written:
- Task ordering followed C5 strictly (T-gate exit 0 before T-flips).
- C4 strengthened acceptance captured in full (4 paths + 1 absence + 3 frontmatter fields + verbatim skip + both H2 sections).
- C7 labelling honored on T1 (glossary annotation correction; no contract row touched).
- All acceptance `grep` assertions returned the expected counts.

R-02 fix touched 3 occurrences rather than just the glossary line at 1482. This is per the plan T1 action ("If the line number has drifted from RESEARCH §11's note ... fix every occurrence"); the additional 2 occurrences (line 26 contract row, line 1470 prose) are secondary drifts of the same outlier spelling, not a scope expansion.

## Threat Flags

None. No new security-relevant surface introduced — all changes are doc-only (DESIGN.md glossary alignment, fixture authorship, REQUIREMENTS.md trace flip) plus reviewer-driven e2e smoke artefacts living in a co-located fixtures/output directory. T-07-13..18 mitigations from the plan's threat register were all honored via the grep-gate acceptance criteria + C5 ordering enforcement.

## Self-Check: PASSED

- File `.planning/DESIGN.md`: FOUND (R-02 grep checks 0/0/present/present)
- File `.planning/phases/07-.../fixtures/sample-cr-meeting-notes.md`: FOUND
- File `.planning/phases/07-.../fixtures/sample-cr-miro-paste.md`: FOUND
- File `.planning/phases/07-.../fixtures/sample-cr-field-notes.md`: FOUND
- File `.planning/phases/07-.../fixtures/output/01_kickoff_v1.md`: FOUND
- File `.planning/phases/07-.../fixtures/output/02_discovery_v1.md`: FOUND
- File `.planning/phases/07-.../fixtures/output/01_kickoff_v2.md`: FOUND
- File `.planning/phases/07-.../fixtures/output/03_sow_v1.md`: FOUND
- File `.planning/phases/07-.../fixtures/output/03_sow_v2.md`: FOUND
- File `.planning/phases/07-.../fixtures/output/02_discovery_v2.md`: **DELIBERATELY MISSING (verified)**
- File `.planning/REQUIREMENTS.md`: FOUND (10 trace flips, 11 Phase 8 untouched)
- Commit `b038995`: FOUND (T1 R-02)
- Commit `e83b58a`: FOUND (T2 fixtures)
- Commit `4799577`: FOUND (T-smoke artefacts)
- Commit `770d14a`: FOUND (T-flips REQUIREMENTS)
- `bash phase7-structure-check.sh --all` exit code: 0 ✓
