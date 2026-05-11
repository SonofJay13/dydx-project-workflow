---
phase: 7
plan: 07-02
slug: stage-1-kickoff-discovery-sow-upstream-wiring
subsystem: dydx-delivery/skills/discovery-intake
tags: [stage-2, discovery-intake, upstream-wiring, kickoff-consumer, raw-notes-retired]
requirements_satisfied: [STG2-01, STG2-02, STG2-03]
dependency_graph:
  requires:
    - "07-01 (kickoff-capture skill + structure-check.sh shipped)"
    - "D-74 (verbatim skip-message AUTHORITATIVE spelling)"
    - "D-76 (based_on_kickoff write-path MANDATORY / read-path lenient)"
    - "R-01 (DESIGN-18 line 604 alt spelling NOT lifted)"
    - "R-04 (intake-template 9-section list intentionally diverges from kickoff 8-list)"
  provides:
    - "Stage 2 skill body that consumes 01_kickoff_v<N>.md as sole upstream artefact"
    - "Verbatim draft-sow skip-message in SKILL.md (D-74 / STG2-02)"
    - "based_on_kickoff: MANDATORY contract documented for write-path"
  affects:
    - "Stage 3 (generate-sow / 07-03): X2 cross-section assertion now satisfied on discovery side"
    - "Phase 7 wave 3 gate (07-04 --section all): D1, D2, D3 confirmed PASS"
tech-stack:
  added: []
  patterns:
    - "Surgical edits to existing skill body (5 edits in T1, 2 in T2 — total 7)"
    - "AWK-bounded raw-notes placement assertions (C8a/C8b) for section-correctness"
    - "Verbatim-string contract via grep -qF in structure-check (D3 spelling protection)"
key-files:
  created: []
  modified:
    - "dydx-delivery/skills/discovery-intake/SKILL.md"
decisions:
  - "Full deletion of `## Start-at-any-point handling` block (no kickoff-survivable content to preserve — entire block was v0.3.0 shortcut-inputs for raw-notes path)"
  - "RETIRED bullet placed at TOP of `## What this skill does not do` for prominence (literal token 'RETIRED' uppercase per D2 grep robustness guidance)"
  - "Step 1 fully restructured: kickoff-locate + branch-route promoted above target-location logic; target-location now derives from kickoff frontmatter (`client:` / `platform:`) instead of `hub.md` lookup"
  - "Step 6 collapsed to single block-quote handoff (DESIGN-18 line 612 verbatim); v0.3.0 review-procedure narrative removed wholesale"
metrics:
  duration_minutes: ~10
  completed_date: "2026-05-11"
  tasks_completed: 4
  files_modified: 1
  files_created: 0
---

# Phase 7 Plan 07-02: discovery-intake upstream wiring Summary

One-liner: discovery-intake/SKILL.md now consumes approved `01_kickoff_v<N>.md` as sole upstream input, retires the raw-notes entry path, and emits the verbatim D-74 skip-message on `kickoff_branch: draft-sow` — closing the kickoff→discovery contract per STG2-01 / STG2-02 / STG2-03.

## Tasks Executed

| Task | Type | Outcome | Commit |
|------|------|---------|--------|
| T1 — Surgical edits (description, Inputs, Step 1, Step 5 frontmatter, Step 6 handoff) | auto | 5 edits applied; D1 + D3 + X2 + R-01-drift-absent acceptance criteria PASS | `3425245` |
| T2 — Retire raw-notes path (delete Start-at-any-point block, add RETIRED bullet) | auto | Block fully deleted; RETIRED bullet appended; D2 + C8a + C8b PASS; Business outcome preserved | `1d204ce` |
| T3 — Verify intake-template.md unchanged (STG2-03 no-op) | auto | `git diff` empty; file exists; H2 count = 12 (unchanged) | n/a (no-op) |
| T4 — Run `phase7-structure-check.sh --section discovery` | auto | Exit code 0; D1, D2, D3 all PASS; `ALL ASSERTIONS PASSED` printed | n/a (gate) |

## Surgical Edits Applied (7 total — matches T1 Edits 1-5 + T2 Edits 6-7)

| # | Section | Change |
|---|---------|--------|
| 1 | Frontmatter `description:` | Dropped raw-notes trigger phrasing; advertised kickoff-consumption + raw-notes RETIRED |
| 2 | `## Inputs` | Replaced bullets with kickoff MANDATORY upstream; added Write-path contract paragraph (D-76) |
| 3 | `### Step 1` | Renamed → "Locate upstream kickoff and route by branch"; added `kickoff_branch:` routing with verbatim D-74 skip-message in fenced code block; target-location now reads from kickoff frontmatter |
| 4 | `### Step 5` frontmatter | Added `based_on_kickoff: 01_kickoff_v<N>.md   # MANDATORY per D-76 / STG2-01`; added explanatory paragraph linking to v2.6 hook deferral |
| 5 | `### Step 6` | Replaced v0.3.0 review-procedure narrative with single DESIGN-18 line 612 verbatim block-quote |
| 6 | `## Start-at-any-point handling` | Fully deleted (entire block was raw-notes-path documentation; nothing kickoff-survivable) |
| 7 | `## What this skill does not do` | Prepended `**Does NOT accept raw notes** — RETIRED in v2.2` bullet with cross-link to kickoff-capture/SKILL.md |

## Verification Gate Results

`bash phase7-structure-check.sh --section discovery` — **exit 0**:

```
PASS: D1: based_on_kickoff MANDATORY documented in discovery-intake/SKILL.md
PASS: D2: raw-notes RETIRED documented in discovery-intake/SKILL.md
PASS: D3: verbatim skip-message present in discovery-intake/SKILL.md
ALL ASSERTIONS PASSED
```

### C8 AWK-bounded raw-notes placement assertions

- **C8a (Inputs section clean):** `awk '/^## Inputs$/{flag=1; next} /^## /{flag=0} flag' SKILL.md | grep -i -E 'raw[- ]notes' | wc -l` → `0` ✓
- **C8b (RETIRED in correct section):** `awk '/^## What this skill does not do$/{flag=1; next} /^## /{flag=0} flag' SKILL.md | grep -i -E 'raw[- ]notes' | wc -l` → `1` ✓

### T1 acceptance-criteria spot-checks (all pass)

- `grep -qF 'Stage 2 SKIPPED — kickoff branch = draft-sow'` → match (D-74 / STG2-02 / R-01 authoritative spelling)
- `grep -qF 'based_on_kickoff'` → match (D1 + X2)
- `grep -qiE '(MANDATORY|required)'` → match (D1 write-path policy)
- `grep -qF '01_kickoff_v<N>.md'` → match (upstream reference)
- `grep -qF 'Awaiting status: approved write to 02_discovery_v<N>.md'` → match (DESIGN-18 line 612 handoff)
- `grep -qF 'kickoff produced draft SOW; routing to Stage 3'` → NO match (R-01: DESIGN-18 line 604 drift absent)

### T3 no-op verification

- `git diff dydx-delivery/skills/discovery-intake/references/intake-template.md` → empty
- File exists at canonical path
- H2 count = 12 (9 discovery dimensions + Business outcome / Users / Systems / Triggers / Data / Rules / Integrations / Exceptions / Open Questions structure preserved + template framing H2s)
- R-04 intentional 9-vs-8 mismatch with kickoff template body PRESERVED

### Start-at-any-point block disposition

- **Full deletion**. Inspection confirmed the entire `## Start-at-any-point handling` section was raw-notes-shortcut content ("I already have a brief…" + "Just structure these notes…") plus a generic statement about other skills' inline-capture fallback. No kickoff-based content survived STG2-01 — full removal is correct, partial preservation rationale is N/A.

## Deviations from Plan

None — plan executed exactly as written.

## Commits (chronological)

| SHA | Message |
|-----|---------|
| `3425245` | `feat(07-02): wire kickoff as sole upstream for discovery-intake (T1)` |
| `1d204ce` | `refactor(07-02): retire raw-notes entry path in discovery-intake (T2)` |

(Final docs commit for SUMMARY follows.)

## Threat Register Mitigations Verified

| Threat ID | Mitigation status |
|-----------|-------------------|
| T-07-06 (skip-message spelling drift) | mitigated — D3 `grep -qF` enforces D-74 spelling; alt-spelling absence verified |
| T-07-07 (no provenance on write) | mitigated — D1 + write-path paragraph document `based_on_kickoff:` MANDATORY |
| T-07-08 (legacy artefact reads) | accepted (per plan) — lenient-read documented in Inputs Write-path paragraph |
| T-07-09 (template body drift) | mitigated — T3 git diff empty confirms STG2-03 contract |
| T-07-10 (missing upstream kickoff) | accepted (per plan) — Step 1 explicit error directing to kickoff-capture documented |
| T-07-10b (RETIRED notice in wrong section) | mitigated — C8a + C8b AWK-bounded assertions pass |

## Self-Check

- [x] `dydx-delivery/skills/discovery-intake/SKILL.md` modified — `git log --oneline --all | grep 3425245` and `1d204ce` both confirmed present
- [x] `dydx-delivery/skills/discovery-intake/references/intake-template.md` unchanged — `git diff` empty
- [x] Structure-check `--section discovery` exit 0 — confirmed in T4

## Self-Check: PASSED
