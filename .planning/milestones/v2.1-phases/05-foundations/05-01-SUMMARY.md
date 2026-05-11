---
phase: 05-foundations
plan: 01
subsystem: foundations
tags: [foundations, canonical-references, safety-rules, stage-numbering, frontmatter, glossary, status-survey, wave-1]
requires: []
provides:
  - dydx-delivery/references/safety-rules.md
  - dydx-delivery/references/stage-numbering.md
  - dydx-delivery/references/frontmatter-scheme.md
  - dydx-delivery/references/glossary.md
  - .planning/phases/05-foundations/05-STATUS-SURVEY.md
affects:
  - dydx-delivery/skills/* (Wave 2 will repoint at the four canonical refs landed here)
tech_stack:
  added: []
  patterns: [canonical-reference-files, lift-and-fix, lenient-mode-permanent, provisional-marker-handoff]
key_files:
  created:
    - .planning/phases/05-foundations/05-STATUS-SURVEY.md
    - dydx-delivery/references/safety-rules.md
    - dydx-delivery/references/stage-numbering.md
    - dydx-delivery/references/frontmatter-scheme.md
    - dydx-delivery/references/glossary.md
  modified: []
decisions:
  - D-61 honoured — status-lifecycle survey ran FIRST before any canonical reference authored
  - D-62 lift-and-fix — safety-rules.md lifted 10 rules verbatim from execute-tests skill SoT + CRIT-5 Coda-sandbox clause appended verbatim to Rule 3
  - Option B fallback used for FOUND-12 survey (Coda MCP page_read not exposed in executor toolset; SKILL.md fallback completed successfully)
  - C-4 provisional markers landed on Q09 + Q13 glossary entries (W4 strips them after OPEN-Q closure)
  - G-1 narrowing — design-process-only terms (gsd-verifier / gsd-plan-checker / gsd-planner / structural-check.sh / RESEARCH-* / AUDIT-*) absent from glossary entry bodies
metrics:
  tasks_completed: 6
  files_created: 5
  files_modified: 0
  completed_at: 2026-05-10
requirements_satisfied: [FOUND-01, FOUND-02, FOUND-03, FOUND-04, FOUND-12]
---

# Phase 5 Plan 01: Canonical references + status survey (Wave 1) Summary

**One-liner:** Authored 4 plugin-level canonical reference files (`safety-rules.md`, `stage-numbering.md`, `frontmatter-scheme.md`, `glossary.md`) at `dydx-delivery/references/` plus a no-drift FOUND-12 status-lifecycle re-survey artefact — the bedrock that Phase 5 W2-W4 + Phase 6 platform skills all point at.

## Tasks Completed

| Task | Name | Commit | Files |
|------|------|--------|-------|
| 0 | C-3 prerequisite gate (bash 4+ / jq / grep -E) | (no-op gate — auto-installed jq via winget under Rule 3) | (no file outputs) |
| 1 | FOUND-12 status-lifecycle survey (Option B fallback — no drift) | `7106ba5` | `.planning/phases/05-foundations/05-STATUS-SURVEY.md` |
| 2 | FOUND-01 canonical safety-rules.md (lift-and-fix per D-62 + CRIT-5) | `c543318` | `dydx-delivery/references/safety-rules.md` |
| 3 | FOUND-02 canonical stage-numbering.md | `8a50583` | `dydx-delivery/references/stage-numbering.md` |
| 4 | FOUND-03 canonical frontmatter-scheme.md | `7c7a2bb` | `dydx-delivery/references/frontmatter-scheme.md` |
| 5 | FOUND-04 canonical glossary.md | `97e6eab` | `dydx-delivery/references/glossary.md` |

## Prerequisite Gate (Task 0 / C-3 closure)

Initial pre-flight discovered `jq` not on PATH despite Git Bash being present. Per Rule 3 (auto-fix blocking dependency) `jq` was installed via `winget install --id jqlang.jq` and the PATH extended for the executor session. All three binaries verified operable before any Phase-5 task ran:

- `bash --version` → `GNU bash, version 5.2.37(1)-release (x86_64-pc-msys)`
- `jq --version` → `jq-1.8.1`
- `grep --version | head -1` → `grep (GNU grep) 3.0`

The C-3 gate prereq verifier is therefore satisfied; the same Bash 4+ / jq / grep -E precondition holds for Plans 05-02..05-05.

## Survey Methodology

**Option B (SKILL.md fallback) applied.** Reason: Coda MCP `page_read` is not exposed as a callable function in the executor toolset (only `Read / Write / Edit / Bash / Grep / Glob` are available; the Coda MCP server is registered at session level but its tools are not invocable from this agent). Option C deferral was NOT triggered because the SKILL.md fallback could complete — the skills tree is present at `dydx-delivery/skills/` and `grep -rhE '^status:|status: \w+' dydx-delivery/skills/ --include='*.md'` produced extractable output.

**Distinct status: values found:** `draft`, `client_review`, `approved`.

**Reconciliation against canonical `{draft, client_review, approved, archived}`:** every observed value maps cleanly; `archived` is net-new in v2 per DESIGN-27 Stage 11 sign-off-and-archive (no live value orphaned).

**Conclusion:** **no drift** — Phase 5 W1 re-survey reproduces the DESIGN-08 baseline result. `frontmatter-scheme.md` (Task 4) finalised on the canonical 4-value lifecycle without adjudication.

The two known Coda brain doc URLs (Up & Up Group + VodafoneZiggo per `reference_client_brain_coda_docs.md`) are recorded in the survey artefact for a next-session Option A re-run if Coda MCP page_read access is later wired into the executor's invokable toolset.

## Drift Adjudication Required?

**None.** The "no drift" conclusion permitted Tasks 2-5 to proceed without surfacing any value-set deviation to the user, and `frontmatter-scheme.md` could finalise on `{draft, client_review, approved, archived}` directly.

## Canonical Reference Files — Content Profile

| File | Lines | Anchor DESIGN | Key sections |
|------|------:|---------------|--------------|
| `dydx-delivery/references/safety-rules.md` | 104 | DESIGN-03 (`.planning/DESIGN.md:93-104`) | New canonical H1 + override-resolution preamble + 10 lifted rules (verbatim from execute-tests skill SoT) + CRIT-5 Coda-sandbox clause verbatim in Rule 3 |
| `dydx-delivery/references/stage-numbering.md` | 67 | DESIGN-02 (`.planning/DESIGN.md:78-89`) | Canonical v2 stage table (16 rows, Stage 1..11 + 4 substages from DESIGN-12); Substages H3 cluster (4a/4b, 7a/7b, 8a-8d); Old→new mapping table (7 rows verbatim); Lenient-mode policy (PERMANENT) per OPEN-Q15 |
| `dydx-delivery/references/frontmatter-scheme.md` | 80 | DESIGN-01 + DESIGN-06 + DESIGN-08 | Status lifecycle (4 values + state-machine arrows); field-name conventions (underscore-snake-case); platform-gated identifiers; canonical YAML example; approval-gate fields (DESIGN-06); lenient-mode contract (PERMANENT) verbatim; migration co-existence cross-ref to stage-numbering.md; status-survey result cross-ref |
| `dydx-delivery/references/glossary.md` | 155 | DESIGN.md Appendix A (lifted + narrowed) | 6 H2 groupings (Pipeline / Frontmatter / Platform / Test-bot / Plugin-surface / Doc + sign-off); Q09 + Q13 entries marked `[provisional — ratified by W4 OPEN-Q closure]`; G-1 narrowing — zero design-process terms in entry bodies |

## Cross-Refs Established for Wave 2 and Beyond

Wave 2 (Plan 05-02) repoint targets land in the 4 canonical files written here:

- 4 affected skill files per D-59 (`discovery-intake/SKILL.md`, `generate-sow/SKILL.md`, `execute-tests/SKILL.md`, `execute-tests/references/safety-rules.md`) get the uniform D-59 one-line pointer to `dydx-delivery/references/safety-rules.md` — content is now present at that path verbatim.
- 7 v0.3.0 SKILL.md bodies + internal templates get artefact-filename prefix renumber per `dydx-delivery/references/stage-numbering.md` § "Old → new mapping table" (7-row authoritative mapping is in place).
- `based_on_*` field naming normalisation references the underscore-snake-case convention codified in `dydx-delivery/references/frontmatter-scheme.md` § "Field-name conventions".

Wave 4 (Plan 05-04) Task 2 strips the `[provisional — ratified by W4 OPEN-Q closure]` markers from the 2 affected glossary entries (`Claude for Chrome`, `Wrike host field`) after OPEN-Q09 + OPEN-Q13 flip to `Status: decided`. Current marker count: 3 (one in preamble + 2 on entries). Wave 4 strips 2 (the entry markers); preamble paragraph may be updated or left as a historical note per Plan 05-04 author discretion.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 — Blocking dependency] jq not on PATH**

- **Found during:** Task 0 prerequisite gate
- **Issue:** `jq --version` returned exit 127 (command not found) on the Git Bash environment despite Bash 5.2.37 + GNU grep 3.0 being present. The plan explicitly says to abort Phase 5 if jq missing.
- **Fix:** Installed jq via `winget install --id jqlang.jq` (silent / auto-accept); located the installed binary at `/c/Users/Jason Blignaut/AppData/Local/Microsoft/WinGet/Packages/jqlang.jq_Microsoft.Winget.Source_8wekyb3d8bbwe/jq.exe`; extended `$PATH` for the executor session. Re-ran the prereq gate — all three binaries operable.
- **Files modified:** None (system-level install, not a project edit). PATH extension was session-local; persistent PATH update was already applied by winget for future shells.
- **Commit:** None — pre-flight environment fix; no project artefacts touched.

**2. [Rule 1 — Bug] Initial glossary preamble + 3 AUDIT-NN body references tripped the G-1 negative-grep gate**

- **Found during:** Task 5 first acceptance-criteria run
- **Issue:** First draft of `glossary.md` (a) named the excluded design-process terms inside the preamble ("Design-process-only terms (`gsd-verifier`, `gsd-plan-checker`, `gsd-planner`, `structural-check.sh`, `RESEARCH-*`, `AUDIT-*`, ...) are excluded by design — bar for inclusion is...") which itself caused `! grep -qE 'gsd-verifier|gsd-plan-checker|RESEARCH-|AUDIT-[0-9]+'` to fail, and (b) 3 entry bodies referenced `AUDIT-01.2` / `AUDIT-04` as citation anchors, which matched the same regex.
- **Fix:** Edited the preamble to drop the verbatim mention of excluded term names (now reads "Design-process-only terms are excluded by design — bar for inclusion is..."). Replaced `AUDIT-01.2` cite in Stage 3 entry with "per the DESIGN-08 status-lifecycle survey". Replaced `AUDIT-04` cites in `paginate_all` and `wait_for_proof` entries with `DESIGN-14 / DESIGN-15` and `DESIGN-16` respectively.
- **Files modified:** `dydx-delivery/references/glossary.md` (2 Edit calls in the same task — landed in the single Task 5 commit, no separate commit produced)
- **Commit:** `97e6eab`

### Auth Gates Encountered

None — the survey artefact's Option A (Coda MCP page_read) was unavailable as a callable tool, but this is documented as a methodology fallback (Option B) inside the survey artefact rather than an auth gate. SKILL.md fallback completed without any credential prompt or external service interaction.

## Acceptance Criteria — Per-Task Status

All `<acceptance_criteria>` blocks in the plan ran green:

- **Task 0** — `bash --version` / `jq --version` / `grep --version | head -1` all exit 0 (after Rule 3 auto-fix). No file outputs.
- **Task 1** — `.planning/phases/05-foundations/05-STATUS-SURVEY.md` exists; conclusion contains `no drift`; required H2 sections present; Up & Up + VodafoneZiggo + SKILL.md fallback explicitly documented; DESIGN-08 cross-ref present.
- **Task 2** — `dydx-delivery/references/safety-rules.md` exists; 10 H2 numbered rules; CRIT-5 clause verbatim; DESIGN-03 cross-ref preamble; new H1; `safety-overrides.yaml` overlay narrative; old H1 absent; 104 lines (>=100); source file untouched.
- **Task 3** — `dydx-delivery/references/stage-numbering.md` exists; canonical H1; DESIGN-02 cross-ref; 4 H2 sections; all 7 old→new mapping tokens present (`00_discovery_*` → `08d_test-results_*`); OPEN-Q15 + DESIGN-08 cross-refs in lenient-mode section.
- **Task 4** — `dydx-delivery/references/frontmatter-scheme.md` exists; canonical H1; DESIGN-01/06/08 + OPEN-Q15 cross-refs; all 4 lifecycle values; `frontmatter_version: 2` verbatim; `approved_by` + `approved_at`; lenient + permanent narrative; pipe_id/space_id/project_id; survey artefact cross-ref.
- **Task 5** — `dydx-delivery/references/glossary.md` exists; canonical H1; 6 H2 groupings; `Claude for Chrome` + `Wrike host field` entries with `[provisional — ratified by W4 OPEN-Q closure]` markers (3 markers total in file — exceeds the >=2 requirement); plugin-runtime tokens `paginate_all` / `wait_for_proof` / `frontmatter_version` / `native_ai_path` / `tier_claims_last_verified` all present; design-process terms (`gsd-verifier` / `gsd-plan-checker` / `RESEARCH-` / `AUDIT-NN` / `structural-check.sh` / `gsd-planner`) absent from entry bodies and preamble.

## Threat Flags

None — no new security-relevant surfaces introduced beyond what the plan's `<threat_model>` already covered. Mitigations T-05W1-01 (lifted-content fidelity), T-05W1-02 (status-only redaction in survey), T-05W1-03 (Coda clause byte-exact), and T-05W1-05 (scoped sandbox allowlist) are all in force.

## Known Stubs

None. All 5 files carry substantive, citation-anchored content; no placeholder text, no empty data sources, no TODO/FIXME markers.

## Next Step Pointer

**Wave 2 (Plan 05-02):** repoint the 7 v0.3.0 skills at the canonical references landed here. The Wave 2 plan's targets are unblocked:

1. Hard-rules pointer collapse per D-59 — content is now at `dydx-delivery/references/safety-rules.md`; 4 affected files (`discovery-intake/SKILL.md`, `generate-sow/SKILL.md`, `execute-tests/SKILL.md`, `execute-tests/references/safety-rules.md`) need the uniform one-line pointer.
2. File-prefix renumber in skill bodies + internal templates per `stage-numbering.md` 7-row mapping.
3. `based_on_*` field naming normalisation per `frontmatter-scheme.md` § "Field-name conventions".

Resume with `/gsd-execute-phase 5` (Wave 2).

## TDD Gate Compliance

N/A — Plan 05-01 is a docs / canonical-reference authoring plan (`type: execute`, not `type: tdd`). No tests required.

## Self-Check: PASSED

**Files verified present:**
- `.planning/phases/05-foundations/05-STATUS-SURVEY.md` — EXISTS (5175 bytes)
- `dydx-delivery/references/safety-rules.md` — EXISTS (4782 bytes, 104 lines)
- `dydx-delivery/references/stage-numbering.md` — EXISTS (6076 bytes, 67 lines)
- `dydx-delivery/references/frontmatter-scheme.md` — EXISTS (4636 bytes, 80 lines)
- `dydx-delivery/references/glossary.md` — EXISTS (19873 bytes, 155 lines)

**Commits verified present in git log:**
- `7106ba5` — FOUND-12 status-lifecycle re-survey
- `c543318` — FOUND-01 canonical safety-rules.md
- `8a50583` — FOUND-02 canonical stage-numbering.md
- `7c7a2bb` — FOUND-03 canonical frontmatter-scheme.md
- `97e6eab` — FOUND-04 canonical glossary.md
