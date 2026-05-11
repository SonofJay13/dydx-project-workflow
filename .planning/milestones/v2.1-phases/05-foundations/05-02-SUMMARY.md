---
phase: 05-foundations
plan: 02
subsystem: foundations
tags: [foundations, skill-repoint, hard-rules-dedup, file-renumbering, based-on-normalisation, wave-2]
requires:
  - dydx-delivery/references/safety-rules.md
  - dydx-delivery/references/stage-numbering.md
provides:
  - All 7 v0.3.0 skills repointed at Wave 1 canonical references
  - Zero inlined hard-rules duplicates in skills tree (sole canonical = dydx-delivery/references/safety-rules.md)
  - Uniform v2 stage-prefix naming across based_on_* values, skill prose, and template self-labels
affects:
  - dydx-delivery/skills/* (all 7 skills + README)
tech_stack:
  added: []
  patterns: [verbatim-pointer-collapse, replace-all-prefix-renumber, ordered-edit-deconfliction]
key_files:
  created: []
  modified:
    - dydx-delivery/README.md
    - dydx-delivery/skills/discovery-intake/SKILL.md
    - dydx-delivery/skills/discovery-intake/references/intake-template.md
    - dydx-delivery/skills/execute-tests/SKILL.md
    - dydx-delivery/skills/execute-tests/references/results-template.md
    - dydx-delivery/skills/execute-tests/references/safety-rules.md
    - dydx-delivery/skills/generate-build-prompt/SKILL.md
    - dydx-delivery/skills/generate-build-prompt/references/build-prompt-template.md
    - dydx-delivery/skills/generate-functional-spec/SKILL.md
    - dydx-delivery/skills/generate-functional-spec/references/functional-spec-template.md
    - dydx-delivery/skills/generate-sow/SKILL.md
    - dydx-delivery/skills/generate-sow/references/sow-template.md
    - dydx-delivery/skills/generate-technical-spec/SKILL.md
    - dydx-delivery/skills/generate-technical-spec/references/technical-spec-template.md
    - dydx-delivery/skills/generate-test-plan/SKILL.md
    - dydx-delivery/skills/generate-test-plan/references/test-plan-template.md
decisions:
  - D-59 verbatim one-line pointer wording landed in exactly 3 files (AUDIT-05.1 ground truth, NOT the D-59 nominee list)
  - D-62 safety-rules.md collapsed to 3-line Pointer-only stub (NOT deleted) — preserves cite-anchor stability
  - DESIGN-02 stage-prefix mapping applied uniformly (00->02 / 01->03 / 02->04a / 03->05 / 04->07a / test-plan->08b / results-YYYY-MM-DD->08d)
  - Cross-AI flag 1 resolved in favour of AUDIT-05.1 grep ground truth — discovery-intake/SKILL.md and generate-sow/SKILL.md confirmed to carry NO hard-rules duplicates and therefore got no D-59 pointer
metrics:
  tasks_completed: 3
  files_created: 0
  files_modified: 16
  completed_at: 2026-05-10
requirements_satisfied: [FOUND-05, FOUND-06]
---

# Phase 5 Plan 02: Skill repoint + hard-rules dedup + filename renumber (Wave 2) Summary

**One-liner:** Repointed all 7 v0.3.0 skills at Wave 1 canonical references — 4 hard-rules surfaces collapsed (3 D-59 pointers + 1 D-62 stub), 13 based_on_* values + all skill prose filenames + 6 template Stage-N self-labels migrated to v2 stage prefixes, zero old-prefix survivors anywhere in dydx-delivery/skills/.

## Tasks Completed

| Task | Name | Commit | Files |
|------|------|--------|-------|
| 1 | Hard-rules dedup — 4 AUDIT-05.1 surfaces collapsed (3 D-59 pointers + 1 D-62 stub) | `9c4e31f` | execute-tests/SKILL.md; generate-test-plan/references/test-plan-template.md; dydx-delivery/README.md; execute-tests/references/safety-rules.md |
| 2 | based_on_* renumber across 11 files (13 value-string substitutions) | `285317d` | 11 files (7 SKILL.md + 4 templates) |
| 3 | Skill prose filename refs + 6 template Stage-N self-labels | `9a3a6f5` | 14 files (all 7 SKILL.md + 6 templates) |
| 3-fix | Collapse accidental 08b_08b_test-plan_v double-prefix (Rule 1 auto-fix) | `c97dc54` | generate-build-prompt/SKILL.md; generate-build-prompt/references/build-prompt-template.md |

## Cross-AI Flag 1 Resolution

**Plan's stated stance honoured.** D-59 nominated `discovery-intake/SKILL.md` and `generate-sow/SKILL.md` as 2 of 4 pointer-replacement targets, but AUDIT-05.1 grep ground truth (re-verified at task start) showed those files carry NO hard-rules duplicates. Wave 2 used AUDIT-05.1's actual 4 files:

1. `dydx-delivery/skills/execute-tests/SKILL.md` (D-59 pointer)
2. `dydx-delivery/skills/generate-test-plan/references/test-plan-template.md` (D-59 pointer)
3. `dydx-delivery/README.md` (D-59 pointer)
4. `dydx-delivery/skills/execute-tests/references/safety-rules.md` (D-62 collapse stub)

D-59's **wording** of the pointer remained authoritative — the verbatim blockquote string is byte-identical across the 3 pointer-target files, verified by `grep -lF`.

## Per-File Line Ranges Actually Edited

| File | Plan-cited range | Actual edit | Drift? |
|------|------------------|-------------|--------|
| execute-tests/SKILL.md | L20-30 (heading + 7-rule list) | L20-22 (heading + 1 blockquote pointer; net -8 lines) | None — content matched at L20 |
| generate-test-plan/references/test-plan-template.md (hard-rules) | L36-44 (heading + 5 bullets) | L36-38 (heading + 1 blockquote pointer; net -6 lines) | None |
| dydx-delivery/README.md | L97-107 (heading + 5 bullets + footer) | L97-99 (heading + 1 blockquote pointer; net -8 lines) | None — actual section heading sits at L97, plan-cited L99-105 was the bullet range |
| execute-tests/references/safety-rules.md | full file (101 lines) | 3 lines total (H1 + blank + blockquote) | None — full file overwrite per D-62 |
| All 13 based_on_* lines | L79 / L7 / L81 / L7 / L105 / L7 / L99 / L7 / L118 / L119 / L7 / L8 / L6 | Exact lines confirmed by grep before edit; no drift | None |
| 6 Stage-N self-labels | L13 / L13 / L13 / L17 / L15 / L18 | Exact lines confirmed by grep before edit | None |

## D-59 Pointer Text Identity — Verified

```bash
$ grep -lF "See \`dydx-delivery/references/safety-rules.md\` for the canonical ruleset" \
    dydx-delivery/skills/execute-tests/SKILL.md \
    dydx-delivery/skills/generate-test-plan/references/test-plan-template.md \
    dydx-delivery/README.md
dydx-delivery/skills/execute-tests/SKILL.md
dydx-delivery/skills/generate-test-plan/references/test-plan-template.md
dydx-delivery/README.md

$ grep -cF "Sandbox-only operations. Read-write only against named sandbox tenants. Refuses destructive actions." \
    dydx-delivery/skills/execute-tests/SKILL.md \
    dydx-delivery/skills/generate-test-plan/references/test-plan-template.md \
    dydx-delivery/README.md
1 (each file)
```

3 files, 3 verbatim-identical pointer blockquotes. Threat T-05W2-01 (pointer drift) mitigated by acceptance gate.

## based_on_* Renumber Count

**Target: 13. Applied: 13. Zero-survivor verification passed.**

| # | File | Key | Old value | New value |
|---|------|-----|-----------|-----------|
| 1 | generate-sow/SKILL.md:79 | based_on_discovery | 00_discovery_v{N}.md | 02_discovery_v{N}.md |
| 2 | generate-sow/references/sow-template.md:7 | based_on_discovery | 00_discovery_v<N>.md | 02_discovery_v<N>.md |
| 3 | generate-functional-spec/SKILL.md:81 | based_on_sow | 01_sow_v{N}.md | 03_sow_v{N}.md |
| 4 | generate-functional-spec/references/functional-spec-template.md:7 | based_on_sow | 01_sow_v<N>.md | 03_sow_v<N>.md |
| 5 | generate-technical-spec/SKILL.md:105 | based_on_functional_spec | 02_functional-spec_v{N}.md | 04a_fnspec-platform_v{N}.md |
| 6 | generate-technical-spec/references/technical-spec-template.md:7 | based_on_functional_spec | 02_functional-spec_v<N>.md | 04a_fnspec-platform_v<N>.md |
| 7 | generate-test-plan/SKILL.md:99 | based_on_technical_spec | 03_technical-spec_v{N}.md | 05_techspec_v{N}.md |
| 8 | generate-test-plan/references/test-plan-template.md:7 | based_on_technical_spec | 03_technical-spec_v<N>.md | 05_techspec_v<N>.md |
| 9 | generate-build-prompt/SKILL.md:118 | based_on_technical_spec | 03_technical-spec_v{N}.md | 05_techspec_v{N}.md |
| 10 | generate-build-prompt/SKILL.md:119 | based_on_test_plan | test-plan_v{N}.md | 08b_test-plan_v{N}.md |
| 11 | generate-build-prompt/references/build-prompt-template.md:7 | based_on_technical_spec | 03_technical-spec_v<N>.md | 05_techspec_v<N>.md |
| 12 | generate-build-prompt/references/build-prompt-template.md:8 | based_on_test_plan | test-plan_v<N>.md | 08b_test-plan_v<N>.md |
| 13 | execute-tests/references/results-template.md:6 | based_on_test_plan | test-plan_v<N>.md | 08b_test-plan_v<N>.md |

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 — Bug] Accidental `08b_08b_test-plan_v` double-prefix in generate-build-prompt**

- **Found during:** Global Wave 2 post-Task-3 verification grep
- **Issue:** Task 3 sub-deliverable A applied `replace_all "test-plan_v" -> "08b_test-plan_v"` across `generate-build-prompt/SKILL.md` and `generate-build-prompt/references/build-prompt-template.md` to migrate skill prose references (e.g., line 38 `<Client>/testing/<feature>/test-plan_v<N>.md`). But Task 2 had already migrated 2 `based_on_test_plan:` value-string lines in those same files to `08b_test-plan_v...`. Task 3's blanket `replace_all` then re-prefixed those frontmatter values to `08b_08b_test-plan_v...`. The bug was masked by the Task 2 acceptance regex (`08b_test-plan_v[{<]N[}>]\.md`) which matches both correct and double-prefixed strings as a substring.
- **Fix:** Two `Edit replace_all "08b_08b_test-plan_v" -> "08b_test-plan_v"` calls, one per affected file. Verified `grep -rn "08b_08b_\|05_05_\|07a_07a_\|04a_04a_\|02_02_discovery_\|03_03_sow_\|08d_08d_" dydx-delivery/` returns zero matches.
- **Files modified:** `dydx-delivery/skills/generate-build-prompt/SKILL.md`, `dydx-delivery/skills/generate-build-prompt/references/build-prompt-template.md`
- **Commit:** `c97dc54`
- **Root cause / lesson for future replace_all renumber waves:** Order matters — apply LONGEST prefix substitutions first, OR avoid `replace_all` on substrings that overlap with already-migrated tokens. The remediation took ~3 minutes but the failure mode (mask by substring-match acceptance regex) is worth calling out to future executors.

### Auth Gates Encountered

None — all 3 tasks are file-edit-only against the local repo; no external service, no auth-gated CLI, no secret prompt.

## Acceptance Criteria — Per-Task Status

All `<acceptance_criteria>` blocks ran green:

- **Task 1** — D-59 pointer in 3 files (uniform wording verified); old headings absent; safety-rules.md collapsed to 3 lines with `Pointer-only` marker and zero rule headings; 4 negative-grep "Sandbox enforcement" zero-survivor check passed.
- **Task 2** — 5 positive grep counts met threshold (P1=2, P2=2, P3=2, P4=4, P5=3); 5 negative greps (zero-survivor for 00_discovery / 01_sow / 02_functional-spec / 03_technical-spec / bare test-plan_v) all exit 0; all 11 target files present.
- **Task 3** — 6 Stage-N labels positive (Stage 2 / 4a / 5 / 8b / 7a / 8d); 3 old Stage labels gone; zero-survivor grep for `00_discovery_v|01_sow_v|02_functional-spec_v|03_technical-spec_v|04_build-prompt_v|results-YYYY-MM-DD_v` returns empty; positive coverage `02_discovery_v >= 2` and `08b_test-plan_v >= 3` met (final counts: 13 and 14 respectively).

## Threat Flags

None — no new security-relevant surface introduced. Wave 2 is pure content-substitution across existing skill files. Threat mitigations from the plan's `<threat_model>` are all in force:

- **T-05W2-01 (pointer wording drift):** mitigated by 3-file `grep -lF` identity check (passed).
- **T-05W2-02 (accidental safety-rules.md deletion):** mitigated by `test -f` + `Pointer-only` marker check (passed; D-62 collapse not delete).
- **T-05W2-03 (based_on_* renumber gaps):** mitigated by 5 positive + 5 zero-survivor grep assertions (passed).
- **T-05W2-04 (skill prose drift outside scope):** mitigated by per-skill grep candidate list in Task 3; `dydx-delivery/README.md` lines outside ~99-105 hard-rules section untouched (verified — no incidental edits leaked to the B.1 truncation area at line ~126).
- **T-05W2-05 (Wave 5 cosmetic fixes leaking into Wave 2):** mitigated — `dydx-delivery/README.md` diff only touches the L97-99 hard-rules section; B.1 truncation at L126 + B.3 step count + root README B.2 wording untouched and explicitly deferred to Wave 5.

## Known Stubs

None — all 14 modified files retain substantive content. The `execute-tests/references/safety-rules.md` 3-line file is intentional per D-62 (Pointer-only stub, not a placeholder) and points at the canonical SoT `dydx-delivery/references/safety-rules.md` landed in Wave 1 (Task 2 of Plan 05-01, commit `c543318`).

## Next Step Pointer

**Wave 3 (Plan 05-03):** plugin manifest 2.0.0 sync (`plugin.json` + `.claude-plugin/marketplace.json`) + `LICENSE` file at repo root + empty `commands/` / `agents/` / `hooks/` scaffold dirs. None of these touch the skill content modified here — Wave 3 is an isolated manifest/scaffold landing.

## TDD Gate Compliance

N/A — Plan 05-02 is `type: execute` (docs / content-substitution). No `tdd="true"` tasks. No test gates required.

## Self-Check: PASSED

**Commits verified present in git log:**
- `9c4e31f` — Task 1 hard-rules dedup
- `285317d` — Task 2 based_on_* renumber
- `9a3a6f5` — Task 3 prose + Stage-N labels
- `c97dc54` — Rule 1 fix for double-prefix

**Files verified modified (16 total, including 1 file collapsed-overwritten and 15 in-place edits):**
- All 16 paths listed in frontmatter `key_files.modified` confirmed via `git diff --name-only 9c4e31f~1..HEAD`.

**Invariants verified post-final-commit:**
- D-59 pointer in exactly 3 files (`grep -lF` returns the 3 expected paths).
- D-62 stub at 3 lines with Pointer-only marker.
- 13 based_on_* values all on new prefixes; zero old-prefix `based_on_*` matches.
- 6 Stage-N self-labels on new prefixes (Stage 2 / 4a / 5 / 8b / 7a / 8d).
- Zero-survivor across `dydx-delivery/skills/` for `00_discovery_v|01_sow_v|02_functional-spec_v|03_technical-spec_v|04_build-prompt_v|results-YYYY-MM-DD_v`.
- Zero double-prefix survivors anywhere in `dydx-delivery/` tree.
