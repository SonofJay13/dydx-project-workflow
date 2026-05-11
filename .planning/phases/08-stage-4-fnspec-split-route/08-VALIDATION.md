# Phase 8: Stage 4 Fnspec Split + ROUTE — Validation Architecture

**Generated:** 2026-05-11
**Source:** Extracted from `08-RESEARCH.md` §4 — Phase 7 `07-VALIDATION.md` pattern
**Status:** Ready for planner

> This document is the canonical Nyquist-coverage artefact for Phase 8 (Dimension 8 structural verification).
> The planner MUST cover every assertion ID listed below in the corresponding plan's `must_haves.truths`.

---

## 1. Phase Requirements → Verification Map

| Req ID | Plan | Assertion ID | Fixture | Section |
|--------|------|--------------|---------|---------|
| STG4-01 | 08-01 | P1 (skill exists), P2 (3 references/ files), P3 (4 canonical pointers) | `fixtures/output/sample-cr-04a_fnspec-platform_v1.md` | `--section 4a` |
| STG4-02 | 08-02 | I1 (skill exists), I2 (3 references/ files), I3 (4 canonical pointers) | `fixtures/output/sample-cr-04b_fnspec-integration_v1.md` | `--section 4b` |
| STG4-03 | 08-03 | E5 (`generate-functional-spec/` directory does NOT exist) | n/a (delete-only) | `--section route` |
| STG4-04 | 08-01 + 08-02 | P5 (`delivery: native-ai \| api` canonical order in 4a SKILL.md), S3 + S5 (smoke stub asserts no reversed enum across both fixtures) | both 4a + 4b fixtures | `--section 4a` + `--section smoke` |
| STG4-05 | 08-01 | P6 (`auto-classify-rubric.md` referenced from SKILL.md); manual rubric content review | rubric file itself | `--section 4a` |
| STG4-06 | 08-03 | E6 (three topologies documented in BOTH 4a + 4b SKILL.md bodies) | `either-spec-skip-paths.md` content; both SKILL.md bodies | `--section route` |
| ROUTE-01 | 08-02 | I6 (3 consistency checks named), I8 (two-place key-decisions cross-reference) | `consistency-rules.md`; both SKILL.md key-decisions sections | `--section 4b` |
| ROUTE-02 | 08-02 | I7 (halt + `04b_consistency_check_v<N>.md` contract documented) | `sample-cr-04b_consistency_check_v1.md` fixture | `--section 4b` |
| ROUTE-03 | 08-01 + 08-02 | P8 (`has_platform_api_addendum` + `tech_spec_scope` documented in 4a); I4 (`based_on_fnspec_platform:` documented in 4b) | 4a fixture (with addendum H2 body in one topology variant); 4b fixture | `--section 4a` + `--section 4b` |
| ROUTE-04 | 08-03 | E1 (4-enum `ziflow` present in all 11 modified files), E2 (`platform-ziflow/SKILL.md:14` retains routing-key claim), E3 (glossary routing-key entry 4-enum), E4 (glossary `kickoff_branch` entry uses `discovery-ready \| draft-sow` — Phase 7 R-02 carry-forward) | n/a (code-only) | `--section route` |
| ROUTE-05 | 08-03 | S1-S6 (smoke section — synthetic Stage 5/6/7b/10 stubs read both fixtures end-to-end) | both 4a + 4b fixtures | `--section smoke` |

Cross-section asserts (X1-X4 per RESEARCH.md §2.3) run only under `--all` / no-flag invocation and form the structure-check gate before `/gsd-verify-work`.

## 2. Manual e2e smoke walkthrough (Phase 7 07-04-SUMMARY pattern)

Plan 08-03 (or split-off 08-04) authors a manual reviewer smoke walkthrough:

1. **Setup** — Author three sample-CR fixture inputs under `fixtures/input/` (or reuse Phase 7's `.planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/fixtures/` sample-CR inputs as the upstream `02_discovery_v1.md` + `03_sow_v1.md`).
2. **Run 4a** — Invoke `generate-fnspec-platform` against the sample-CR upstream. Observe `04a_fnspec-platform_v1.md` written under `fixtures/output/`. Verify per-row `delivery:` markup present on every business-rule / field-req / AC row.
3. **Run 4b — clean path** — Invoke `generate-fnspec-integration` with consistent inputs. Observe consistency check passes; `04b_fnspec-integration_v1.md` written under `fixtures/output/`.
4. **Run 4b — halt path** — Inject a synthetic conflict (4a row with `delivery: native-ai` and a 4b row tagged `delivery: api` for the same requirement ID). Invoke 4b. Observe `04b_consistency_check_v1.md` written + halt; no `04b_fnspec-integration_v*.md` produced.
5. **Run 4b — skip path** — Invoke 4b against an "integration out of scope" SOW signal (`## Integration Scope` section says "n/a" or absent). Observe verbatim stdout `Stage 4b SKIPPED — no integration work in scope`; no artefact written.
6. **Run smoke gate** — `bash .planning/phases/08-stage-4-fnspec-split-route/scripts/phase8-structure-check.sh --section smoke`. Expect all S1-S6 PASS.
7. **Run full gate** — `bash .planning/phases/.../phase8-structure-check.sh`. Expect ALL ASSERTIONS PASSED.
8. **Commit fixtures** — `fixtures/output/sample-cr-04a_fnspec-platform_v1.md` + `sample-cr-04b_fnspec-integration_v1.md` + `sample-cr-04b_consistency_check_v1.md`. Capture summary in plan-close SUMMARY.md per Phase 7 07-04 pattern.

## 3. Sampling Rate

- **Per task commit:** `bash scripts/phase8-structure-check.sh --section <relevant>` (≤1s; dependency-free)
- **Per wave merge:** Same as per-commit
- **Phase gate:** `bash scripts/phase8-structure-check.sh` (full suite — all 4 sections + cross-section) before `/gsd-verify-work`

## 4. Wave 0 gaps

- [ ] `.planning/phases/08-stage-4-fnspec-split-route/scripts/phase8-structure-check.sh` — adapt from `phase7-structure-check.sh` per RESEARCH.md §2.3 partition table; ships inside 08-03
- [ ] `.planning/phases/08-stage-4-fnspec-split-route/fixtures/input/` (optional reuse of Phase 7 fixtures via path reference; otherwise author fresh) + `fixtures/output/` (capture during 08-01 / 08-02 / 08-03 plan close)
- [ ] No framework install — bash + grep + sed + awk are baseline; same as Phase 7

## 5. Dimension 8 sensor model (Nyquist)

Phase 8 structure-check covers Dimension 8 (structural verification) via ~30 asserts across:

- **6 file-existence sensors** — 4a SKILL.md + 4a 3 references + 4b SKILL.md + 4b 3 references + script itself + retirement target absence
- **8 canonical-pointer sensors** — 4 per new skill × 2 skills (safety-rules + stage-numbering + frontmatter-scheme + glossary)
- **11 enum-rollout sensors** — one per D-78 edit-list file, asserting `ziflow` present in the `platform:` enum line
- **3 cross-skill consistency sensors** — X1-X3 + meta-assert X4 (4a/4b reference each other correctly; key-decisions cross-references present in both)
- **6 forward-compat smoke sensors** — S1-S6 (synthetic Stage 5/6/7b/10 consumer stubs assert `delivery:` survives canonical position)
- **Literal-string sensors** — D-82 row markup canonical order; D-85 verbatim skip-emit string; D-79 `has_platform_api_addendum` field; D-84 consistency-check halt-on-failure contract

E2e smoke (Dimension 9) is **manual-only** for Phase 8 — same posture as Phase 7. The 07-04-SUMMARY pattern carries directly.

---

*Validation strategy locked. Planner consumes this document to populate `must_haves.truths` in each plan.*
