---
phase: 7
slug: stage-1-kickoff-discovery-sow-upstream-wiring
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-05-11
revised: 2026-05-11 (cross-AI review C1 K4/K4b split)
---

# Phase 7 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.
> Source: 07-RESEARCH.md § 8 Validation Architecture.
> Revised per cross-AI review C1 fix: K4 split into K4 (concrete enum-value assertion) + K4b (enum-documented-somewhere assertion).

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | bash + grep (structure-check is the verification harness — same as Phase 5 / Phase 6) |
| **Config file** | none (script self-contained per `set -euo pipefail`) |
| **Quick run command** | `bash .planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/scripts/phase7-structure-check.sh --section <kickoff\|discovery\|sow>` |
| **Full suite command** | `bash .planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/scripts/phase7-structure-check.sh --all` |
| **Estimated runtime** | <1s |

---

## Sampling Rate

- **After every task commit:** Run `bash scripts/phase7-structure-check.sh --section <relevant>` (≤1s, dependency-free)
- **After every plan wave:** Same as per-commit (single-section scope)
- **Before `/gsd-verify-work`:** Full suite (`bash scripts/phase7-structure-check.sh --all`) must be green — runs in 07-04 (Wave 3) per cross-AI review C2 split
- **Max feedback latency:** 1 second

---

## Per-Task Verification Map

> Populated by gsd-planner during plan generation. Each `<automated>` block in a PLAN.md task gets a row here mapping task → section → assertion ID.

| Task ID | Plan | Wave | Requirement | Threat Ref | Secure Behavior | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|------------|-----------------|-----------|-------------------|-------------|--------|
| _pending — populated by planner_ | | | | | | | | | |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

### Requirement → Assertion Mapping (post-C1 fix)

| Req ID | Behavior | Assertion ID(s) | Section |
|--------|----------|-----------------|---------|
| STG1-01 | kickoff-capture skill + canonical pointers | K1, K2, K3 | `--section kickoff` |
| STG1-02 | `kickoff_branch:` enum (concrete value in template + enum documented in skill body) | **K4** (concrete enum-value regex on `kickoff-template.md`) **+ K4b** (both enum values documented somewhere across the 4 kickoff-capture skill files) | `--section kickoff` |
| STG1-03 | `processed_at IS NULL` triage default in capture-paths.md | K6 | `--section kickoff` |
| STG1-04 | `[unknown — needs human classification]` marker convention | K5 | `--section kickoff` |
| STG1-05 | 3 capture paths documented (paste / Miro / Field Notes) | K2 (existence) + manual review of capture-paths.md | `--section kickoff` |
| STG2-01 | `based_on_kickoff:` MANDATORY documented + raw-notes RETIRED in correct section | D1 + D2 + **C8a/C8b AWK-bounded section asserts** | `--section discovery` + plan-local C8 checks |
| STG2-02 | Verbatim skip-message present | D3 | `--section discovery` |
| STG2-03 | `intake-template.md` body unchanged | manual `git diff` (empty after Phase 7) | n/a |
| STG3-01 | Canonical 4-state lifecycle locked (unicode arrows verbatim) | S1 | `--section sow` |
| STG3-02 | `## Platform Scope` + `## Integration Scope` H2s in template | S2 | `--section sow` |
| Cross | `kickoff_branch:` + `based_on_kickoff:` consistent across 3 skills | X1, X2 | `--all` (cross-section, runs in 07-04 Wave 3) |

### K4 / K4b Split Detail (per cross-AI review C1 fix)

The original K4 was a single anchored-regex assertion (`^kickoff_branch: (discovery-ready|draft-sow)$`) targeted at the kickoff-template.md frontmatter. Codex flagged that the planned template literal at the time (`kickoff_branch: <discovery-ready | draft-sow>`) did NOT match the regex, creating a literal-read failure path: an executor following the plan exactly would still fail `--section kickoff`.

The C1 fix splits the assertion into two complementary checks:

- **K4 (concrete enum-value assertion).** `grep -qE '^kickoff_branch: (discovery-ready|draft-sow)$' kickoff-capture/references/kickoff-template.md` — asserts the template carries a CONCRETE enum value (one of the two valid values, not a placeholder). The planner default per 07-01 T3 is `discovery-ready`; reviewer switches to `draft-sow` at write time when applicable.
- **K4b (enum-documented assertion).** Both literal strings `discovery-ready` AND `draft-sow` MUST appear at least once SOMEWHERE in the union of the 4 kickoff-capture skill files (SKILL.md + 3 references/ files). Implemented as two `grep -qF` calls against the cat-joined union. Ensures the alternate branch is documented even though the template only carries one concrete value.

Together K4 + K4b cover (a) wrong enum value in template, (b) enum spelling drift, (c) missing documentation of the alternative branch. Both assertions run under `--section kickoff`; both must pass for STG1-02 to be considered satisfied.

---

## Wave 0 Requirements

- [ ] `.planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/scripts/phase7-structure-check.sh` — adapt from `.planning/milestones/v2.1-phases/06-internalise-platform-skills/scripts/phase6-structure-check.sh` skeleton per RESEARCH §3; ships inside 07-01 (Wave 0-equivalent per D-77)
- [ ] No framework install — bash + grep are baseline; same as Phase 5 / Phase 6

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| STG2-03 intake-template.md body unchanged | STG2-03 | Diff-against-baseline check; no structure-check sensor (a "no-edit" assertion is anti-pattern in bash) | `git diff dydx-delivery/skills/discovery-intake/references/intake-template.md` after Phase 7 commits — expect empty diff (frontmatter + body untouched) |
| E2e smoke: sample CR kickoff → SOW round-trip | All Phase 7 reqs | No test framework runs skills end-to-end; manual reviewer invokes via standard plugin runner | 07-04 T-smoke (post-C2 split + post-C4 strengthening): paste 3 fixtures (`sample-cr-meeting-notes.md` / `sample-cr-miro-paste.md` / `sample-cr-field-notes.md`) into `kickoff-capture` with output workspace `.planning/phases/07-.../fixtures/output/`; observe `01_kickoff_v<N>.md`; run `discovery-intake` once per branch (`discovery-ready` → emits 02; `draft-sow` → emits verbatim skip + writes nothing); run `generate-sow`; observe `03_sow_v<N>.md`; record concrete paths + frontmatter snippets in `07-04-SUMMARY.md` |
| STG1-05 capture-paths content sufficiency | STG1-05 | Subjective adequacy of 3 capture path protocol descriptions | Manual review of `capture-paths.md` — does each of (paste / Miro paste / Field Notes paste) have enough protocol to follow without re-derivation? |

---

## Dimension 8 Sensor Model (Nyquist)

Phase 7 structure-check covers Dimension 8 (structural verification) via **15 assertions** (post-C1 fix, up from 13) spanning:

- **3 file-existence sensors** — kickoff SKILL.md + 3 references/ files + script itself
- **4 canonical-pointer sensors** — `safety-rules.md` / `stage-numbering.md` / `frontmatter-scheme.md` / `glossary.md` substrings in kickoff SKILL.md
- **5 literal-string sensors** (was 4 — K4b added per C1 fix):
  - **K4** — concrete `kickoff_branch:` enum value (anchored regex, one of two valid values) in `kickoff-template.md`
  - **K4b** — both enum values (`discovery-ready` + `draft-sow`) documented somewhere across the 4 kickoff-capture skill files
  - **K5** — verbatim `[unknown — needs human classification]` marker in `kickoff-capture/SKILL.md`
  - **D3** — verbatim `Stage 2 SKIPPED — kickoff branch = draft-sow` skip-message in `discovery-intake/SKILL.md`
  - **S1** — verbatim `draft → client_review → approved → archived` 4-state lifecycle (unicode arrows) in `generate-sow/SKILL.md` or `sow-template.md`
- **2 cross-skill consistency sensors** — X1 (`kickoff_branch` referenced consistently across all 3 skills) / X2 (`based_on_kickoff` referenced consistently in discovery + sow)

Total: 8 kickoff (K1-K7 + K4b) + 3 discovery (D1-D3) + 2 sow (S1-S2) + 2 cross (X1-X2) = **15 assertions**.

E2e smoke (Dimension 9) is **manual-only** for Phase 7 — runs in 07-04 T-smoke per cross-AI review C2 split.

---

## Cross-AI Review C8 (plan-local AWK-bounded assertions)

In addition to the 15 structure-check assertions, 07-02 T2 carries two plan-local AWK-bounded checks per cross-AI review C8 finding:

- **C8a:** AWK-extracts `## Inputs` section content; greps for `raw[- ]notes`; count MUST equal 0 (raw-notes mention forbidden inside Inputs).
- **C8b:** AWK-extracts `## What this skill does not do` section content; greps for `raw[- ]notes`; count MUST be ≥ 1 (raw-notes RETIRED notice required in correct section).

These are plan-local task-acceptance assertions, not structure-check runners. Run as part of 07-02 T2 verify block.

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references (phase7-structure-check.sh)
- [ ] No watch-mode flags
- [ ] Feedback latency < 1s
- [ ] K4 + K4b assertions present in `phase7-structure-check.sh` (C1 fix landed)
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
</content>
</invoke>