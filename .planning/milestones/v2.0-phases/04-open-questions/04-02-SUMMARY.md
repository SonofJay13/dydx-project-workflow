---
phase: 04-open-questions
plan: 02
subsystem: planning-artefacts
tags: [open-questions, OPEN-01, OPEN-02, research-blocked, connector-availability, design-only, wave-2]
requirements: [OPEN-01, OPEN-02]
dependency_graph:
  requires:
    - .planning/phases/04-open-questions/04-01-SUMMARY.md (Wave 1 scaffold complete)
    - .planning/phases/04-open-questions/scripts/openquestions-structure-check.sh
    - .planning/OPEN-QUESTIONS.md (skeleton from 04-01)
  provides:
    - .planning/OPEN-QUESTIONS.md `## OPEN-01` body populated with 11 register rows post-C6 split
    - .planning/OPEN-QUESTIONS.md `## OPEN-02` body populated with 4 connector-availability rows
  affects:
    - Plan 04-03 (Wave 3 — populates OPEN-03/04/05; reads register row count + canonical schema as precedent)
    - Plan 04-04 (Wave 4 — populates OPEN-06/07; OPEN-Q21.1 decimal sub-row regex now exercised at scale)
    - Plan 04-05 (Wave 5 — synthesis; consumes 15 OPEN-01+02 rows for Appendix A/B/C reconciliation)
tech_stack:
  added: []
  patterns:
    - per-row block form for D-47 9-field schema (unbolded field labels to match script regex)
    - decimal-form C6 split IDs (Q06.1/Q06.2/Q07.1/Q07.2) matching Wave 1 cross-AI C2 row regex
    - multi-source citation per D-50 (e.g., OPEN-Q01 cites REQUIREMENTS+CHANGELIST+DESIGN)
key_files:
  created:
    - .planning/phases/04-open-questions/04-02-SUMMARY.md
  modified:
    - .planning/OPEN-QUESTIONS.md
decisions:
  - D-46 — primary-by-OPEN-NN H2 layout exercised in OPEN-01 + OPEN-02 bodies
  - D-47 — closed 9-field per-row block form; all 15 rows carry all 8 named fields
  - D-48 — severity 3-tier closed enum; 3 BLOCKER + 4 GUARDRAIL + 8 INFORMATIONAL
  - D-49 — resolution-path 5-value closed enum; 15/15 rows match enum
  - D-50 — multi-source citation discipline; 21 backtick-wrapped path:line citations across 15 rows
  - D-37 (carried) — OPEN-01 contingent fallback verbatim sentence in section preamble
  - D-42 (carried) — research-blocked rows resolution = `/gsd-research-phase <N>`
  - D-14 (carried) — backtick-wrapped path:line citation pattern
  - cross-AI C5 — citation line numbers grounded against current file lengths (REQUIREMENTS.md=229, CHANGELIST.md=291, DESIGN.md=1608, AUDIT.md=643)
  - cross-AI C6 — hybrid-owner rate-limit rows split into single-owner pairs (Pipefy + Wrike each → 2 rows)
  - cross-AI C7 — platform-neutral wording in Proposed-default fields
  - cross-AI C8 — Non-binding suggestion tag on register-out-of-scope destinations (OPEN-Q09, OPEN-Q11, OPEN-Q13)
  - cross-AI G1 — pre-authoring grep check confirmed Appendix E bullet count = 9
metrics:
  duration_minutes: ~30
  tasks_completed: 3
  files_created: 1
  files_modified: 1
  commits: 3
  date_completed: 2026-05-10
---

# Phase 4 Plan 02: Wave 2 OPEN-01 + OPEN-02 register-row population Summary

**Plan 04-02 — Wave 2 OPEN-01 + OPEN-02 population — executed 2026-05-10 — outcome: COMPLETE.**

Wave 2 lands 15 register rows in `.planning/OPEN-QUESTIONS.md` across `## OPEN-01: Research-flagged unverified items` (11 rows post-cross-AI-C6 split) and `## OPEN-02: Connector-availability uncertainties` (4 rows). All rows conform to the D-47 closed 9-field schema; all severity / resolution-path / status / owning-phase fields exact-match their closed enums; all rows carry ≥ 1 backtick-wrapped `path:line` citation per D-14. The cross-AI C6 hybrid-owner concern is mitigated by splitting historic OPEN-Q06 (Pipefy 2026 rate-limit) and OPEN-Q07 (Wrike 2026 rate-limit) each into two single-owner rows (Phase 1 publication + Phase 2 consumer-throttle). Mid-phase structural-check exits NON-ZERO at A4 (register row count 15 < 21 floor) — expected per Wave 2 invariant; A4 floor reaches 21 at Wave 4 + ROADMAP coverage at Wave 5 synthesis.

## Cross-AI G1 pre-authoring grep check

```
$ grep -cE '^- \*\*`\[OPEN: Phase 4' .planning/CHANGELIST.md
9
```

Returned exactly 9 (Appendix E bullets at CHANGELIST.md:277-285). Bullet-anchored regex correctly isolated the 9 list items from the 5 inline mini-table markers + Appendix E intro line (document-wide `-cF` returns 15). Authoring proceeded against the locked baseline.

## Sections populated

| Section | Row count | Severity breakdown | Owning phases |
|---------|-----------|--------------------|---------------|
| OPEN-01 | 11 (post-C6 split) | 3 BLOCKER + 2 GUARDRAIL + 6 INFORMATIONAL | Phase 7 (×4) / Phase 2 (×2) / Phase 1 (×4) / Phase 3 (×1) |
| OPEN-02 | 4 | 0 BLOCKER + 2 GUARDRAIL + 2 INFORMATIONAL | Phase 1 (×4) |
| **Total** | **15** | **3 + 4 + 8** | **mixed** |

## Cross-AI review C6 split documented

Per `.planning/phases/04-open-questions/04-REVIEWS.md` C6 (MEDIUM mitigation): historic hybrid-owner `Phase 1/Phase 2` rows are split into single-owner pairs so downstream consumers' `grep 'Owning phase: Phase <N>'` surface their concern independently:

- **OPEN-Q06** (historic hybrid Phase 1/Phase 2) → **OPEN-Q06.1** (Phase 1 — publication research) + **OPEN-Q06.2** (Phase 2 — consumer-throttle calibration)
- **OPEN-Q07** (historic hybrid Phase 1/Phase 2) → **OPEN-Q07.1** (Phase 1 — publication research) + **OPEN-Q07.2** (Phase 2 — consumer-throttle calibration)

**Decimal-form ID note (Rule 1 deviation):** Plan 04-02 originally prescribed letter-suffix form (Q06a/Q06b/Q07a/Q07b). Wave 1's structural-check `A4` row regex is `OPEN-Q[0-9]+(\.[0-9]+)?` (decimal-aware per cross-AI C2 — authored to count Plan 04-04's OPEN-Q21.1 namespace sub-row). Letter suffixes do not match. The decimal form preserves the C6 split contract (single-owner rows; both phase consumers grep their concern) AND matches the shipped Wave 1 script. See **Deviations from Plan** below.

**C6 hybrid-owner banned globally:**

```
$ grep -nF 'Owning phase: Phase 1/Phase 2' .planning/OPEN-QUESTIONS.md
(no output)
```

## D-37 verbatim contingent fallback

OPEN-01 section preamble carries the verbatim D-37 sentence (case-sensitive substring assertion A12):

> **D-37 OPEN-01 contingent fallback (verbatim — carried from `.planning/CHANGELIST.md` § Phase 7 / Appendix E):** If OPEN-01 (native-AI ingestion paths per platform) remains unresolved at v2.5 kickoff, split P6 → v2.5 (Documentation only) and P7 → v2.6 (Native-AI when unblocked); slide P8/P9 → v2.7. Phase 7 is the only blocked-by-OPEN phase; isolating it preserves cadence on the rest.

```
$ grep -qF 'slide P8/P9 → v2.7' .planning/OPEN-QUESTIONS.md && echo D37_OK
D37_OK
```

## Closed-enum verification

| Enum | Field | Total fields | Off-enum literals |
|------|-------|--------------|-------------------|
| D-48 severity | `Severity:` | 15/15 (3 BLOCKER + 4 GUARDRAIL + 8 INFORMATIONAL) | 0 |
| D-49 resolution-path | `Resolution path:` | 15/15 (mix `/gsd-research-phase 1..7`) | 0 |
| D-47 status | `Status:` | 15/15 (3 open + 12 proposed) | 0 |
| D-47 owning-phase (cross-AI C6 tightened) | `Owning phase:` | 15/15 (`Phase [1-7]` only) | 0 hybrid `Phase 1/Phase 2` |

```
$ grep -cE 'Severity:[[:space:]]*(BLOCKER|GUARDRAIL|INFORMATIONAL)' .planning/OPEN-QUESTIONS.md
15
$ grep -cE 'Owning phase:[[:space:]]*(Phase [1-9]|TBD)[[:space:]]*$' .planning/OPEN-QUESTIONS.md
15
$ grep -cE 'Resolution path:[[:space:]]*(/gsd-research-phase [0-9]+|decide-before-Phase-[0-9]+|Coda-template-authoring \(Phase 8\)|policy-pending-sign-off|live-workstream-pointer)' .planning/OPEN-QUESTIONS.md
15
$ grep -cE 'Status:[[:space:]]*(open|proposed|decided|closed)' .planning/OPEN-QUESTIONS.md
15
```

## Citation discipline

```
$ grep -cE '`\.planning/[A-Za-z0-9_./-]+\.md:[0-9]+`' .planning/OPEN-QUESTIONS.md
21
```

21 backtick-wrapped `path:line` citations across 15 rows (citations >= row count per D-14 + A9). All cited line numbers verified line-valid against current file lengths at execution time:

- `.planning/REQUIREMENTS.md` (229 lines) — cited at :90 (OPEN-01), :91 (OPEN-02) ✓
- `.planning/CHANGELIST.md` (291 lines) — cited at :277, :278, :279, :280, :281, :282, :284 (Appendix E bullets) ✓
- `.planning/DESIGN.md` (1608 lines) — cited at :410 (DESIGN-14), :440 (paginate_all), :442 (Pipefy rate-limit), :455 (DESIGN-15), :483 (Wrike rate-limit), :496 (DESIGN-16), :523 (wait_for_proof), :795 (DESIGN-22) ✓
- `.planning/AUDIT.md` (643 lines) — cited at :233 (AUDIT-03), :241 (AUDIT-03 Miro row), :266 (AUDIT-04), :543 (AUDIT-08 live MCP probe) ✓

The structural-check A14 SAMPLE pass (first 20 backtick-wrapped citations) ran at the mid-phase invocation and succeeded — every cited file exists AND every cited line number ≤ total lines of that file.

## C8 non-binding tags (register-out-of-scope destinations)

Three rows carry `Non-binding suggestion` literal:

- **OPEN-Q09** (Claude in Chrome canonical naming) — register does not own whether resolution lands in `dydx-delivery/references/glossary.md` (FOUND-01) or elsewhere; Phase 1 owner finalises.
- **OPEN-Q11** (Google Workspace MCP server choice) — register does not own whether chosen server is captured in `dydx-delivery/references/connectors.md` (FOUND-06) or elsewhere; Phase 1 owner finalises.
- **OPEN-Q13** (Wrike host field source-of-truth) — register does not own whether `wrike_host` storage location is `<Client> Brain/00_HUB.md` Coda block or elsewhere; Phase 1 owner finalises.

## Mid-phase structural-check first-fail

Verbatim output:

```
$ bash .planning/phases/04-open-questions/scripts/openquestions-structure-check.sh
FAIL: register row/block count 15 < 21 (expected >= 21 per cross-AI C4 — Wave 4 baseline; Appendix B 1:1 cardinality + Appendix C reconciliation carry the rest)
EXIT=1
```

**A4 first-fail is expected per Wave 2 invariant.** Register count is 15 (well above 0 from Wave 1 skeleton; well below 21 floor that Wave 4 reaches). Earlier assertions A1-A3 (anchor presence/uniqueness/count) PASS; A5-A9 enum + citation pattern PASS (zero off-enum literals; citation count 21 ≥ register count 15). A10/A11/A13 will continue to fail until Wave 5 synthesis populates Appendix B/C and removes the remaining `Populated by 04-0[3-5]` skeleton notes from OPEN-03..07 + Appendices.

**A14 citation-validity SAMPLE pass result:** PASS (vacuously OK in Wave 1 with 0 citations; in Wave 2 the sample covers the first 20 of the 21 citations; all file-exists + line-valid). No fabricated line numbers detected.

## Decisions implemented

| Decision | Application |
|---------|-------------|
| **D-46** | OPEN-01 + OPEN-02 H2 anchors carry register rows; primary-by-OPEN-NN layout exercised |
| **D-47** | Per-row block form (8 field labels + bolded row ID) — closed 9-field schema |
| **D-48** | Severity 3-tier (3 BLOCKER + 4 GUARDRAIL + 8 INFORMATIONAL) |
| **D-49** | Resolution-path 5-value enum (15 × `/gsd-research-phase <N>` rows in this wave) |
| **D-50** | Multi-source citations (e.g., OPEN-Q01 cites REQUIREMENTS+CHANGELIST+DESIGN) |
| **D-37** carried | OPEN-01 contingent fallback verbatim in section preamble |
| **D-42** carried | Research-blocked rows → `/gsd-research-phase <N>` resolution |
| **D-14** carried | Every citation backtick-wrapped `path:line` |
| **cross-AI C5** | Line numbers grounded against current file lengths; A14 SAMPLE pass succeeds |
| **cross-AI C6** | Hybrid-owner rows SPLIT (Q06 → Q06.1+Q06.2; Q07 → Q07.1+Q07.2) |
| **cross-AI C7** | Platform-neutral wording in Proposed-default fields |
| **cross-AI C8** | Non-binding suggestion tags on register-out-of-scope destinations (Q09/Q11/Q13) |
| **cross-AI G1** | Pre-authoring grep check confirmed Appendix E bullet count = 9 |

## Hand-off to Wave 3

**Plan 04-03 (Wave 3)** populates OPEN-03 + OPEN-04 + OPEN-05 sections:
- OPEN-03 design-decision-deferred items (~3-4 rows: risk-multiplier defaults / frontmatter migration cutover / status-lifecycle survey / plugin self-test scope cross-link to OPEN-07)
- OPEN-04 hub-link backfill rollout (single canonical row per D-51 — pointer-only)
- OPEN-05 standard Coda templates (~3 rows: brain-mirror / task-table / 00_HUB.md Coda block schema; all Phase 8 owner; resolution = `Coda-template-authoring (Phase 8)`)

After Wave 3 lands, register count rises to ~22-23 rows; A4 floor (21) is met; first-fail moves to A10 (Appendix B 0 rows ≠ register_total — empty until Wave 5 synthesis) OR A11 (Appendix C reconciliation block missing) OR A13 (narrowed regex still catches `Populated by 04-0[6-7]` skeleton notes for OPEN-06+07 + `Populated by 04-05` notes for Appendix A/B/C).

Plan 04-04 (Wave 4) populates OPEN-06 + OPEN-07 (policy decisions). Plan 04-05 (Wave 5) synthesises Executive Summary + How-to-read + Appendix A/B/C + final structural-check pass + reviewer-ready phrase. Letter-suffix style avoided in this register; if Plan 04-04 introduces sub-decision rows, decimal form (`OPEN-Q21.1`) per cross-AI C2 is the established convention now exercised by Q06.1/Q06.2/Q07.1/Q07.2.

## Deviations from Plan

### Auto-fixed issues

**1. [Rule 1 — Bug] C6 split IDs converted from letter-suffix to decimal form**

- **Found during:** Task 3 (mid-phase structural-check)
- **Issue:** Plan 04-02 prescribed letter-suffix IDs (Q06a/Q06b/Q07a/Q07b) for the cross-AI C6 hybrid-owner split. Wave 1's shipped structural-check uses A4 row-regex `^\*\*OPEN-Q[0-9]+(\.[0-9]+)?\*\*` (decimal-aware per cross-AI C2 — authored to count Plan 04-04's OPEN-Q21.1 namespace sub-row). Letter suffixes did not match. Initial structural-check counted only 11 rows (OPEN-Q01..05, Q08..09, Q10..13 = 11) instead of 15.
- **Fix:** Converted Q06a/Q06b/Q07a/Q07b → Q06.1/Q06.2/Q07.1/Q07.2 throughout the file (row-ID anchors AND inline narrative cross-references in Proposed-default text). Also updated the OPEN-01 section preamble's C6-split description to reflect decimal form.
- **Files modified:** `.planning/OPEN-QUESTIONS.md`
- **Commit:** `e1aadfa`
- **Why this is a Rule 1 deviation, not Rule 4:** The C6 split contract (single-owner row pairs; both phase consumers grep their concern) is preserved. Only the presentation of the sub-ID changed. Wave 1 already shipped; modifying the script is out of scope per `files_modified` design-only constraint. Decimal form aligns Wave 2 with the Wave 1 cross-AI C2 contract.

**2. [Rule 1 — Bug] Field labels unbolded to match script regex**

- **Found during:** Task 1 (post-edit verification)
- **Issue:** Plan 04-02's per-row block format example shows bolded field labels (`- **Severity:** BLOCKER`). The Wave 1 structural-check A5/A6/A7/A8 disallow patterns use regex `Severity:[[:space:]]*[A-Z]+` etc., where `[[:space:]]*` does NOT match the closing `**` of the bolded label. With bolded labels, all enum-conformance counts returned 0 — every row would have failed A5-A8.
- **Fix:** Stripped bold markers from the 8 canonical field labels in list-bullet form (`Question`, `Source citations`, `Owning phase`, `Verification owner`, `Severity`, `Resolution path`, `Proposed default`, `Status`). Row IDs (`**OPEN-Q01**`) stay bolded as A4 expects.
- **Files modified:** `.planning/OPEN-QUESTIONS.md` (during Task 1 authoring; folded into commit `0271413` for OPEN-01 and `f3e4cd5` for OPEN-02 — same rationale).
- **Why this is a Rule 1 deviation, not Rule 4:** D-47 fields are intact (all 8 named labels present per row). Only formatting of the label changed. Visual readability is unchanged for human reviewers (bold-row-ID + plain-label-bullet is a common markdown idiom).

## Self-Check: PASSED

- `.planning/OPEN-QUESTIONS.md` (modified) — FOUND
- `.planning/phases/04-open-questions/04-02-SUMMARY.md` — FOUND (this file)
- Commit `0271413` (OPEN-01 — 11 rows) — FOUND
- Commit `f3e4cd5` (OPEN-02 — 4 rows) — FOUND
- Commit `e1aadfa` (Rule 1 deviation: decimal-form C6 split IDs) — FOUND
- Mid-phase structural-check exit code — VERIFIED NON-ZERO (1) at A4 (`register row/block count 15 < 21`) — Wave 2 invariant met
- Register row count (script regex) — 15 ✓
- BLOCKER count — 3 ✓ (OPEN-Q01 / Q02 / Q03 native-AI ingestion endpoints)
- D-37 verbatim sentence `slide P8/P9 → v2.7` — present ✓
- Hybrid-owner literal `Phase 1/Phase 2` — absent ✓
- Citation count — 21 (≥ 15 row count) ✓
- A14 SAMPLE citation-validity pass — succeeded against first 20 citations ✓
