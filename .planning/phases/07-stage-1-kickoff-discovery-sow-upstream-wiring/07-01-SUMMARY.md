---
phase: 7
plan: 07-01
slug: stage-1-kickoff-discovery-sow-upstream-wiring
wave: 1
status: complete
completed: 2026-05-11
requirements: [STG1-01, STG1-02, STG1-03, STG1-04, STG1-05]
files_created:
  - dydx-delivery/skills/kickoff-capture/SKILL.md
  - dydx-delivery/skills/kickoff-capture/references/kickoff-template.md
  - dydx-delivery/skills/kickoff-capture/references/auto-classify-rubric.md
  - dydx-delivery/skills/kickoff-capture/references/capture-paths.md
  - .planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/scripts/phase7-structure-check.sh
files_modified: []
commits:
  - { sha: 5df4566, scope: 07-01, type: feat, summary: "phase7-structure-check.sh with kickoff|discovery|sow|all dispatch" }
  - { sha: 1e3a50f, scope: 07-01, type: feat, summary: "kickoff-capture/SKILL.md (Stage 1 skill body)" }
  - { sha: 2bb78d0, scope: 07-01, type: feat, summary: "kickoff-template.md (concrete kickoff_branch + 8 H2 categories)" }
  - { sha: 08a8734, scope: 07-01, type: feat, summary: "auto-classify-rubric.md (D-73 triggers + escalation + backstop)" }
  - { sha: e47f349, scope: 07-01, type: feat, summary: "capture-paths.md (3 paste protocols + MOD-8 prevention)" }
gate:
  command: "bash .planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/scripts/phase7-structure-check.sh --section kickoff"
  exit_code: 0
  pass_count: 8
  assertions_passed: [K1, K2, K3, K4, K4b, K5, K6, K7]
kickoff_branch_concrete_value: discovery-ready
---

# Phase 7 Plan 07-01: Stage 1 kickoff-capture skill + phase7-structure-check.sh Summary

Ships the Stage 1 `kickoff-capture/` skill end-to-end (SKILL.md + 3 references/ files) and the phase7-structure-check.sh harness with `--section <kickoff|discovery|sow|all>` partitioning per D-77. Locks the kickoff frontmatter contract (concrete `kickoff_branch:` enum + `[unknown — needs human classification]` marker + 8-category H2 list) before Wave 2 (07-02 + 07-03) lights up against it.

## Files created (5)

1. **`dydx-delivery/skills/kickoff-capture/SKILL.md`** — Stage 1 skill body. Frontmatter + 4 canonical-pointer block quotes (safety-rules / stage-numbering / frontmatter-scheme / glossary) per FOUND-04 / D-59 pattern. 5-step How-to-run (locate entry / 8-section classify / senior challenge / kickoff_branch classify / write-and-hand-off). DESIGN-17 line 574 verbatim handoff. Both enum values named in body.
2. **`dydx-delivery/skills/kickoff-capture/references/kickoff-template.md`** — artefact-body template. Pre-frontmatter HTML comment + "Valid values" line documenting both enums (C1 fix). Frontmatter carries the concrete value `kickoff_branch: discovery-ready` (planner default per C1; reviewer switches to `draft-sow` at write time). 8 H2 sections in STG1-04 order. `[unknown — needs human classification]` marker inline in every section. `## Routing` block + `## Sign-off` block.
3. **`dydx-delivery/skills/kickoff-capture/references/auto-classify-rubric.md`** — D-73 confidence rubric. 5 explicit triggers, input-signal → outcome escalation table, operational principle backstop ("Mark unknown when you'd hesitate to defend the classification to a reviewer").
4. **`dydx-delivery/skills/kickoff-capture/references/capture-paths.md`** — 3 paste protocols (meeting-notes / Miro fallback / Field Notes). `processed_at IS NULL` verbatim filter (K6). Read-only input queue + MOD-8 prevention loop (keep / drop / edit-and-keep). Deferred Coda MCP section.
5. **`.planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/scripts/phase7-structure-check.sh`** — phase7 verification harness. 4 dispatch modes via `--section` + `--all` alias. 4 runners (kickoff / discovery / sow / cross). K1-K7 + K4b + D1-D3 + S1-S2 + X1-X2 assertion blocks. Lifted skeleton from phase6-structure-check.sh.

## Structure-check gate

```
$ bash .planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/scripts/phase7-structure-check.sh --section kickoff
PASS: K1: kickoff-capture SKILL.md exists
PASS: K2: 3 references/ files exist
PASS: K3: 4 canonical pointers resolve (safety-rules/stage-numbering/frontmatter-scheme/glossary)
PASS: K4: concrete kickoff_branch enum value present in kickoff-template.md
PASS: K4b: both enum values (discovery-ready, draft-sow) documented in kickoff-capture skill files
PASS: K5: unknown-marker convention documented in SKILL.md
PASS: K6: Field Notes triage filter 'processed_at IS NULL' documented verbatim
PASS: K7: auto-classify-rubric.md referenced from SKILL.md
ALL ASSERTIONS PASSED
EXIT=0
```

8 PASS lines (K1 + K2 + K3 + K4 + K4b + K5 + K6 + K7). Exit code 0. Plan-local gate **GREEN**.

`--section discovery` and `--section sow` are expected to FAIL at end of 07-01 — 07-02 + 07-03 ship the files those sections assert against. `--all` is correspondingly forbidden per the plan's `<plan_warning>` block and per cross-AI review C6.

## Commit SHAs

| Task | Commit | Type | Files |
|---|---|---|---|
| T1 — structure-check script | `5df4566` | feat | `scripts/phase7-structure-check.sh` |
| T2 — SKILL.md | `1e3a50f` | feat | `kickoff-capture/SKILL.md` |
| T3 — kickoff-template.md | `2bb78d0` | feat | `references/kickoff-template.md` |
| T4 — auto-classify-rubric.md | `08a8734` | feat | `references/auto-classify-rubric.md` |
| T5 — capture-paths.md | `e47f349` | feat | `references/capture-paths.md` |
| T6 — gate run | (no commit — verification-only task) | — | — |

## Concrete `kickoff_branch:` value chosen

Template carries `kickoff_branch: discovery-ready` (planner default per C1 fix). Both enum values are documented in:

- the pre-frontmatter HTML comment block (lines 1-6 of `kickoff-template.md`)
- the "Valid values for `kickoff_branch:`" block-quote line (line 8 of `kickoff-template.md`)
- the `## Routing` block inside the template body (both branches with one-line description each)
- `kickoff-capture/SKILL.md` purpose paragraph + Step 4 (Classify `kickoff_branch`)

K4b is therefore satisfied via the template file alone, and additionally reinforced across the SKILL.md + capture-paths.md + auto-classify-rubric.md.

## Deviations from plan

**None.** All 6 tasks executed per the action blocks. No D-70 / D-72 / D-73 author-from-spec defaults overridden. No threshold adjustments to `auto-classify-rubric.md` trigger wording (D-73 verbatim wording preserved — `<2 distinct source mentions` kept; not relaxed to `<3`). No structural deviations to the structure-check script beyond the C1 K4/K4b split, which is the planned C1 fix itself.

R-02 outlier spelling (`kickoff-direct | discovery-via` from DESIGN.md glossary line 1482) explicitly avoided across all 4 kickoff-capture files. The glossary alignment fix is captured for Plan 07-03 synthesis per RESEARCH §11 R-02 recommendation; not in scope for 07-01.

## Downstream readiness

- **07-02 (Wave 2, discovery-intake mods):** can begin. `kickoff_branch:` frontmatter contract is locked at `discovery-ready | draft-sow`. `based_on_kickoff:` field-name convention documented in SKILL.md frontmatter-scheme pointer + Step 5 narrative. Structure-check `--section discovery` is ready to run against 07-02 output.
- **07-03 (Wave 2, generate-sow mods):** can begin. `--section sow` ready to run. Both `kickoff_branch:` consumers (X1) + `based_on_kickoff:` consumers (X2) wired into the cross-section runner.
- **07-04 (Wave 3, synthesis + traceability flip):** structure-check `--all` becomes the final phase-level gate. REQUIREMENTS.md traceability rows for STG1-01..05 + STG2-01..03 + STG3-01..02 (10 boxes) reserved for 07-04 per orchestrator instruction.

## Self-Check: PASSED

- All 5 file paths in `files_created` exist on disk (verified via `test -f` during T6 run).
- All 5 commit SHAs present in `git log` (verified — branch `dydx-delivery-v2`, HEAD at `e47f349`).
- `--section kickoff` exit 0 with 8 PASS lines (verified — verbatim output above).
