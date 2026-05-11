---
phase: 7
slug: stage-1-kickoff-discovery-sow-upstream-wiring
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-05-11
---

# Phase 7 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.
> Source: 07-RESEARCH.md § 8 Validation Architecture.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | bash + grep (structure-check is the verification harness — same as Phase 5 / Phase 6) |
| **Config file** | none (script self-contained per `set -euo pipefail`) |
| **Quick run command** | `bash .planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/scripts/phase7-structure-check.sh --section <kickoff\|discovery\|sow>` |
| **Full suite command** | `bash .planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/scripts/phase7-structure-check.sh` |
| **Estimated runtime** | <1s |

---

## Sampling Rate

- **After every task commit:** Run `bash scripts/phase7-structure-check.sh --section <relevant>` (≤1s, dependency-free)
- **After every plan wave:** Same as per-commit (single-section scope)
- **Before `/gsd-verify-work`:** Full suite (`bash scripts/phase7-structure-check.sh`) must be green
- **Max feedback latency:** 1 second

---

## Per-Task Verification Map

> Populated by gsd-planner during plan generation. Each `<automated>` block in a PLAN.md task gets a row here mapping task → section → assertion ID.

| Task ID | Plan | Wave | Requirement | Threat Ref | Secure Behavior | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|------------|-----------------|-----------|-------------------|-------------|--------|
| _pending — populated by planner_ | | | | | | | | | |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

### Requirement → Assertion Mapping (from RESEARCH §8)

| Req ID | Behavior | Assertion ID(s) | Section |
|--------|----------|-----------------|---------|
| STG1-01 | kickoff-capture skill + canonical pointers | K1, K2, K3 | `--section kickoff` |
| STG1-02 | `kickoff_branch:` enum in template | K4 | `--section kickoff` |
| STG1-03 | `processed_at IS NULL` triage default in capture-paths.md | K6 | `--section kickoff` |
| STG1-04 | `[unknown — needs human classification]` marker convention | K5 | `--section kickoff` |
| STG1-05 | 3 capture paths documented (paste / Miro / Field Notes) | K2 (existence) + manual review of capture-paths.md | `--section kickoff` |
| STG2-01 | `based_on_kickoff:` MANDATORY documented | D1 | `--section discovery` |
| STG2-02 | Verbatim skip-message present | D3 | `--section discovery` |
| STG2-03 | `intake-template.md` body unchanged | manual `git diff` (empty after Phase 7) | n/a |
| STG3-01 | Canonical 4-state lifecycle locked | S1 | `--section sow` |
| STG3-02 | `## Platform Scope` + `## Integration Scope` H2s in template | S2 | `--section sow` |
| Cross | `kickoff_branch:` + `based_on_kickoff:` consistent across 3 skills | X1, X2 | `--all` (cross-section) |

---

## Wave 0 Requirements

- [ ] `.planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/scripts/phase7-structure-check.sh` — adapt from `.planning/milestones/v2.1-phases/06-internalise-platform-skills/scripts/phase6-structure-check.sh` skeleton per RESEARCH §3; ships inside 07-01 (Wave 0-equivalent per D-77)
- [ ] No framework install — bash + grep are baseline; same as Phase 5 / Phase 6

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| STG2-03 intake-template.md body unchanged | STG2-03 | Diff-against-baseline check; no structure-check sensor (a "no-edit" assertion is anti-pattern in bash) | `git diff dydx-delivery/skills/discovery-intake/references/intake-template.md` after Phase 7 commits — expect empty diff (frontmatter + body untouched) |
| E2e smoke: sample CR kickoff → SOW round-trip | All Phase 7 reqs | No test framework runs skills end-to-end; manual reviewer invokes via standard plugin runner | Synthesis task (07-03): paste 3 fixtures (`sample-cr-meeting-notes.md` / `sample-cr-miro-paste.md` / `sample-cr-field-notes.md`) into `kickoff-capture`; observe `01_kickoff_v<N>.md`; run `discovery-intake` once per branch (`discovery-ready` → emits 02; `draft-sow` → emits verbatim skip + writes nothing); run `generate-sow`; observe `03_sow_v<N>.md` |
| STG1-05 capture-paths content sufficiency | STG1-05 | Subjective adequacy of 3 capture path protocol descriptions | Manual review of `capture-paths.md` — does each of (paste / Miro paste / Field Notes paste) have enough protocol to follow without re-derivation? |

---

## Dimension 8 Sensor Model (Nyquist)

Phase 7 structure-check covers Dimension 8 (structural verification) via 13 assertions spanning:

- **3 file-existence sensors** — kickoff SKILL.md + 3 references/ files + script itself
- **4 canonical-pointer sensors** — `safety-rules.md` / `stage-numbering.md` / `frontmatter-scheme.md` / `glossary.md` substrings in kickoff SKILL.md
- **4 literal-string sensors** — verbatim `kickoff_branch:` enum / verbatim `[unknown — needs human classification]` marker / verbatim `Stage 2 SKIPPED — kickoff branch = draft-sow` skip-message / verbatim `draft → client_review → approved → archived` 4-state lifecycle
- **2 cross-skill consistency sensors** — X1 (`kickoff_branch` referenced consistently across all 3 skills) / X2 (`based_on_kickoff` referenced consistently in discovery + sow)

E2e smoke (Dimension 9) is **manual-only** for Phase 7 — synthesis task lives in 07-03.

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references (phase7-structure-check.sh)
- [ ] No watch-mode flags
- [ ] Feedback latency < 1s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
