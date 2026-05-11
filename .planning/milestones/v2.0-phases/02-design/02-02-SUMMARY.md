---
phase: 02-design
plan: 02
subsystem: cross-cutting-decisions
tags: [design, cross-cutting, status-survey, persona, wave-2]
requires: [design-structure-check, design-md-skeleton]
provides: [cross-cutting-decisions-locked, design-01-through-10, status-lifecycle-survey-result, persona-worked-examples]
affects: [.planning/DESIGN.md]
tech_stack:
  added: []
  patterns:
    - matrix-then-prose for cross-cutting decisions (D-19)
    - per-DESIGN H3 with > **DESIGN-NN:** echo blockquote (D-35)
    - file:line + AUDIT.md §X.Y citation discipline (D-32 / D-34)
    - stateful awk section_between extraction for forbidden-phrasings scope (cross-AI MEDIUM #5)
    - split-bullet forbidden-phrasings list (line-counted by grep -c, per Plan 05/06 split-line precedent)
key_files:
  created:
    - .planning/phases/02-design/02-02-SUMMARY.md
  modified:
    - .planning/DESIGN.md
decisions:
  - "Phase 2 Plan 02: Status-lifecycle survey ran in fallback mode (no live `<Client> Brain/` folders reachable) — v0.3.0 SKILL.md enumeration documented transparently per T-02-02-01 mitigation; 12 sampled-source rows cite `file:line` per D-32"
  - "Phase 2 Plan 02: Distinct status values found in v0.3.0 = {draft, client_review, approved}; `archived` is net-new in v2 (DESIGN-27 Stage 11 writes it); canonical lifecycle does not orphan any observed value — DESIGN-08 contract locked WITHOUT [MIGRATION-RISK] marker"
  - "Phase 2 Plan 02: Forbidden-phrasings list rendered as 10 separate bullet lines (NOT inline comma-separated) — `grep -cE` counts matching LINES not occurrences; same precedent as Phase 1 Plan 05 §5.5 split-citation, Plan 06 STRUCTURAL split, Plan 08 CRIT-cross-ref split (Rule 1 fix during Task 2 verification)"
  - "Phase 2 Plan 02: DESIGN-10 forbidden-phrasings count is verified within the DESIGN-10 H3 region only (cross-AI review MEDIUM #5 fix) via stateful awk `section_between` extraction — prevents future false positives if broader persona-linting (e.g., end-of-phase tone-lint pass) is added"
  - "Phase 2 Plan 02: 10 H3 subsections placed BEFORE the `### Live status-lifecycle survey` H3 so DESIGN-08 cross-reference reads forward in document order; survey methodology + result already populated in Task 1 above the H3 contract block"
  - "Phase 2 Plan 02: Plugin self-tests subsection lives inline within DESIGN-04 (NOT a separate H3) per D-24 — pytest scope covers validate-frontmatter (positive+negative), bump-artefact-version (idempotency + version bump), frontmatter parser (lifecycle / platform-gated / frontmatter_version handling); CI on every PR"
  - "Phase 2 Plan 02: DESIGN-08 cross-references the survey via the literal text `### Live status-lifecycle survey` (D-25 hand-off); contract sentence locks the no-orphan conclusion explicitly so Phase 3 CHANGELIST.md can cite without re-deriving"
metrics:
  duration: ~14 min
  completed_date: 2026-05-09
---

# Phase 2 Plan 02: Cross-cutting decisions DESIGN-01..10 + status-lifecycle survey + Appendix C

Wave 2 — populated `.planning/DESIGN.md` cross-cutting decisions (DESIGN-01..10), the live status-lifecycle survey under D-25, and Appendix C with 3 persona-contract worked before/after examples. Locks the 10 cross-cutting structural contracts that ground every later section per D-31 author-flow ("cross-cutting first").

## What Was Built

**One-liner:** 10 cross-cutting design contracts locked under one decision-summary table + 10 H3 subsections; status-lifecycle survey confirms canonical `draft → client_review → approved → archived` does not orphan any v0.3.0 value; persona contract now has 3 grounded worked examples in Appendix C.

### `.planning/DESIGN.md` — populated regions

**`## Cross-cutting decisions` H2 — populated** (was: stub placeholder + sentinel-only):

- One-paragraph preamble citing D-19 anchor and the matrix-then-prose pattern.
- 10-row decision-summary table (D-19 — `| ID | Decision area | Locked contract | Locking decision |`); rows DESIGN-01 through DESIGN-10 with one-line locked contract + locking decision ID per row.
- `frontmatter_version: 2` sentinel preserved in body.
- 10 H3 subsections (`### DESIGN-01 — Canonical frontmatter scheme` through `### DESIGN-10 — Persona contract`), each carrying:
  1. H3 heading (zero-padded two-digit ID per acceptance regex `^### DESIGN-(0[1-9]|10) — `).
  2. Echo blockquote `> **DESIGN-NN:** <plain-English statement>` (D-35).
  3. `**Contract.**` block with concrete contract bullets.
  4. `**Cross-references.**` block listing related DESIGN-NN sections + AUDIT.md §X.Y cites.
  - DESIGN-04 carries the `**Plugin self-tests subsection (per D-24)**` callout naming pytest scope, location (`dydx-delivery/tests/`), and CI integration.
  - DESIGN-05 explicitly locks `/dydx-refine-*` namespace (D-23).
  - DESIGN-08 cross-references `### Live status-lifecycle survey` for canonical-lifecycle reconciliation.
  - DESIGN-10 carries 5 voice principles + 10 forbidden phrasings rendered as separate bullet lines + Appendix C pointer.

**`### Live status-lifecycle survey` H3 — populated** (was: stub placeholder):

- **Methodology** paragraph: documents fallback mode transparently — no live `<Client> Brain/` folders reachable from `C:/Users/Jason Blignaut/Documents/Coding/`; v0.3.0 SKILL.md enumeration used per D-25 fallback (T-02-02-01 mitigation honoured).
- **Sampled sources table** — 12 rows; every row carries `file:line` citation per D-32. Sources span 5 v0.3.0 SKILL.md files (`discovery-intake`, `generate-sow`, `generate-functional-spec`, `generate-build-prompt`, `execute-tests`) + 2 AUDIT.md ground-truth cross-references (`§AUDIT-01.2` + `§AUDIT-01.3`).
- **Distinct values found:** `{draft, client_review, approved}` — `archived` not observed (added net-new in v2 per DESIGN-27).
- **Reconciliation** block: 4 per-value lines confirming each canonical status either appears in v0.3.0 (preserved unchanged) or is additive (`archived` only).
- **Conclusion**: canonical lifecycle does not orphan any observed value; DESIGN-08 contract locked; no `[MIGRATION-RISK]` marker required.

**`## Appendix C: Persona contract worked examples` — populated** (was: stub placeholder):

- 3 worked examples following the D-29 shape (`### Example N — <label>` / Source / Before / After / Why-the-rewrite-works).
- Example 1 (truncated changelog) — cites `AUDIT.md §AUDIT-07.1`; eliminates 3 forbidden phrasings.
- Example 2 ("test sheet" residual) — cites `AUDIT.md §AUDIT-07.2`; eliminates 6 forbidden phrasings + apology-prefaces.
- Example 3 (generic AI-style hedging) — cites `AUDIT.md §AUDIT-01.1` (`hub.md` orphan reference + missing follow-up status); eliminates 5 forbidden phrasings.

## Survey Result (key takeaway)

Canonical lifecycle `draft → client_review → approved → archived` is locked. v0.3.0 enumeration found `{draft, client_review, approved}` across 5 SKILL.md files; `client_review` lives only in `generate-sow` (per AUDIT.md §AUDIT-01.2). DESIGN-08 commits to retention without auto-flip; DESIGN-27 Stage 11 introduces `archived` net-new. No live value is orphaned. No `[MIGRATION-RISK]` marker added.

## 10 Cross-Cutting Contracts Locked

| ID | Decision area | Locking decision |
|----|---------------|------------------|
| DESIGN-01 | Frontmatter scheme | D-25 (survey) |
| DESIGN-02 | Stage numbering | — |
| DESIGN-03 | Hard-rules SoT | AUDIT.md §AUDIT-05 |
| DESIGN-04 | Plugin surfaces (incl. self-tests) | D-24 |
| DESIGN-05 | `/refine-<skill>` resolution | D-23 |
| DESIGN-06 | Approval-gate enforcement | — |
| DESIGN-07 | Connector probe + degradation | AUDIT.md §AUDIT-03 |
| DESIGN-08 | Frontmatter migration co-existence | D-25 (survey result) |
| DESIGN-09 | Directional boundary | — |
| DESIGN-10 | Persona contract | D-29 |

## Appendix C — 3 Worked Examples (one-line summary)

1. **Truncated changelog/README sentence** — `AUDIT.md §AUDIT-07.1`; rewrite eliminates "we recommend" / "perhaps consider" / "might want to"; satisfies DESIGN-10 principles 1, 2, 4.
2. **"Test sheet" residual wording** — `AUDIT.md §AUDIT-07.2`; rewrite eliminates 6 forbidden phrasings/apology-prefaces; satisfies principles 2, 3, 4.
3. **Generic AI-style hedging in skill prose** — `AUDIT.md §AUDIT-01.1` (`hub.md` orphan + missing follow-up status); rewrite eliminates 5 forbidden phrasings; satisfies principles 1, 2, 5 (end with hand-off).

## Cross-AI Review Fixes Applied

| ID | Type | Fix |
|----|------|-----|
| HIGH #2 | Process / traceability | `02-02-SUMMARY.md` listed in `files_modified` frontmatter (this file). |
| MEDIUM #5 | Tampering / scope creep | Forbidden-phrasings grep is scoped to the `### DESIGN-10 — Persona contract` H3 region only via stateful `awk` `section_between` extraction — broader persona-linting added at end-of-phase will not false-positive on the persona contract's own quoted phrases. |
| HIGH #1 (carried) | Tampering | Decision-summary table row count uses the same stateful section_between awk pattern from Plan 02-01 (NOT a naive `awk '/^## X/,/^## /'` range) — confirmed `ROW_COUNT=10` against the populated section. |

## Tasks Executed

| Task | Name | Commit | Files |
|------|------|--------|-------|
| 1 | Run status-lifecycle survey + populate `### Live status-lifecycle survey` + write `## Cross-cutting decisions` opening (decision-summary table) | 6d8d720 | `.planning/DESIGN.md` |
| 2 | Write 10 H3 subsections (`### DESIGN-01..DESIGN-10`) with success-criteria echo + concrete contract prose | 2b78f95 | `.planning/DESIGN.md` |
| 3 | Populate `## Appendix C: Persona contract worked examples` with 3 before/after examples + run structural-check | b69615e | `.planning/DESIGN.md` |

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 — Bug] Forbidden phrasings inline-comma rendered → split into 10 bullet lines**

- **Found during:** Task 2 verification.
- **Issue:** Initial draft of DESIGN-10's forbidden-phrasings list rendered all 10 phrases on a single comma-separated line. Acceptance regex `grep -cE '"(...)"'` counts matching **lines** not occurrences (same gotcha as Phase 1 Plan 05 §5.5, Plan 06 STRUCTURAL split, Plan 08 CRIT-cross-ref split). Verification returned `forbidden phrasings count=1` against the required `>= 5`.
- **Fix:** Split the 10 phrases into 10 separate bullet lines (`- "we recommend"` / `- "as an AI"` / etc.). Each phrase now occupies its own line so the line-counting grep scores each one.
- **Files modified:** `.planning/DESIGN.md` (DESIGN-10 H3 forbidden-phrasings list).
- **Commit:** Folded into Task 2 commit `2b78f95` (no separate commit since Task 2 had not yet been committed when the regex failed; fix applied + verified before commit).

No other deviations. Plan executed exactly as written. The 12-row sampled-sources table exceeds the plan's "at minimum 5 SKILL.md files" guidance because the survey transparently includes 2 AUDIT.md ground-truth rows + multiple `status:` value occurrences within the same file (Phase 1 D-32 / D-34 honesty precedent — cite every observation, do not consolidate to make a cleaner table).

## Verification Snapshot

```
$ grep -cE '^### DESIGN-(0[1-9]|10) — ' .planning/DESIGN.md
10
$ grep -cE '^> \*\*DESIGN-(0[1-9]|10):\*\*' .planning/DESIGN.md
10
$ awk -v hdr='### DESIGN-10 — Persona contract' 'f && /^### /{exit} f{print} index($0,hdr)==1 && /^### /{f=1}' .planning/DESIGN.md \
  | grep -cE '"(we recommend|as an AI|I would suggest|perhaps consider|might want to|it'\''s worth noting|please be aware|in order to|make sure to|feel free to)"'
10
$ bash .planning/phases/02-design/scripts/design-structure-check.sh
FAIL: expected >= 30 'DESIGN-NN:' success-criteria echo blockquote lines (D-35), found 10
EXIT_CODE=1   # mid-phase state — Plans 02-03..02-09 add the remaining 20
```

## Pointer

**Next:** Plan 02-03 (Wave 3) populates Skill layout + 13-skill inventory + Stage-by-stage hand-off contract next (DESIGN-11..13). Hand-off matrix needs >= 10 data rows to clear structural-check assertion #9. Echo-line count should progress to 13 after Plan 02-03 (one echo per DESIGN-11 / 12 / 13).

## Self-Check: PASSED

Verified files exist:

- `.planning/DESIGN.md` — FOUND (populated cross-cutting H2 + 10 H3 subsections + populated survey H3 + populated Appendix C; DESIGN-01..10 echo lines = 10).
- `.planning/phases/02-design/02-02-SUMMARY.md` — FOUND (this file).

Verified commits exist on `dydx-delivery-v2`:

- `6d8d720` — FOUND (Task 1: decision-summary table + status-lifecycle survey).
- `2b78f95` — FOUND (Task 2: 10 H3 subsections DESIGN-01..10).
- `b69615e` — FOUND (Task 3: Appendix C 3 worked examples).

Structural-check script: exits 1 against the populated-but-incomplete cross-cutting state (assertion #4 short-circuits with `FAIL: expected >= 30 'DESIGN-NN:' ... found 10` — expected and correct mid-phase invariant).
