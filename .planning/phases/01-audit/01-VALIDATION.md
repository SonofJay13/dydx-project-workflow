---
phase: 1
slug: audit
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-05-09
---

# Phase 1 — Validation Strategy

> Documentary validation contract for Phase 1: Audit. This is a **design-only** phase that produces a single markdown deliverable (`.planning/AUDIT.md`) — there is no code, no test framework, no automated test runner. All verification is structural (grep / file-exists / heading-presence / row-count checks against AUDIT.md) plus reviewer attestation against the 5 ROADMAP success criteria and the 8 AUDIT-* requirement IDs.

> See `.planning/phases/01-audit/01-RESEARCH.md` § "Validation Architecture" for the source rationale and per-section structural checks.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | none — documentary phase, no test runner |
| **Config file** | none |
| **Quick run command** | `bash .planning/phases/01-audit/scripts/audit-structure-check.sh` (created in Wave 0; runs grep/file-exists/row-count assertions in <5s) |
| **Full suite command** | same as quick run + manual reviewer attestation against `.planning/ROADMAP.md` § Phase 1 success criteria 1–5 |
| **Estimated runtime** | ~3 seconds (structural checks) + manual review (~15 minutes for first pass) |

---

## Sampling Rate

- **After every task commit:** Run `bash .planning/phases/01-audit/scripts/audit-structure-check.sh` (only meaningful once AUDIT.md sections start landing — earlier tasks are scaffolding/data-gathering and have file-exists/grep assertions of their own)
- **After every plan wave:** Run the full structural check + read the diff of newly-added AUDIT.md sections for citation-grounding (no orphan claims)
- **Before `/gsd-verify-work`:** Full structural check must pass (zero failed assertions) AND human reviewer signs off on success criteria 1–5
- **Max feedback latency:** 5 seconds (structural check) — human review unbounded, but the structural checks shorten the manual loop

---

## Per-Task Verification Map

> Filled in by the planner during PLAN.md task writing. Each task in PLAN.md must include either an `<automated>` block (grep/file-exists assertion against AUDIT.md or a citation file) or a Wave 0 dependency on the structural-check script. Manual-only verifications go in the table below.

| Task ID | Plan | Wave | Requirement | Threat Ref | Secure Behavior | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|------------|-----------------|-----------|-------------------|-------------|--------|
| 1-01-XX | 01 | 0 | — | — | N/A (design-only) | structural | `test -f .planning/phases/01-audit/scripts/audit-structure-check.sh` | ❌ W0 | ⬜ pending |
| 1-01-XX | 01 | N | AUDIT-0N | — | N/A (design-only) | structural | `grep -q "## AUDIT-0N:" .planning/AUDIT.md` | ❌ W0 | ⬜ pending |

*Planner: replicate one row per AUDIT-0N requirement plus one row per significant sub-finding (CONCERNS.md absorption trace; MCP probe table; per-skill matrix; etc.). Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- [ ] `.planning/phases/01-audit/scripts/audit-structure-check.sh` — bash script that runs **8 assertions** in order; uses **case-insensitive ERE (`grep -qiE`)** for prose matches so author-side capitalization drift does not break the gate; uses literal-string match (`grep -qF`) only for sentinel tokens like `2.0.0`. The 8 assertions are:
  1. `.planning/AUDIT.md` exists
  2. Every `## AUDIT-0N: <Name>` heading is present (8 sections)
  3. AUDIT-07 cosmetic-fix sentinel present — case-insensitive ERE `'scheduled for v2\.1 (foundations )?build'` (matches both lowercase `scheduled for v2.1 build` and uppercase `Scheduled for v2.1 Foundations build` per D-16)
  4. CONCERNS.md absorption claim present — case-insensitive ERE `'verified superset of|all .* (entries|sections) absorbed'`
  5. `## Executive Summary` section header present (per D-03)
  6. `## Appendix B: CONCERNS.md → AUDIT.md trace` section header present (per D-09)
  7. Appendix B has at least **14 data rows** (one per CONCERNS.md H2 section per D-09) — counted via `awk '/^## Appendix B:/,0' "$AUDIT_FILE" | grep -cE '^\| [^|]+ \|'`. The regex tolerates any row format whose first column is non-empty pipe-bounded text; Plan 09 writes a numeric-indexed trace table whose first column is `| 1 |` ... `| N |`, which matches this regex robustly.
  8. AUDIT-06 recommends `2.0.0` as synced target (literal-string match per D-17)
- [ ] Script exits 0 on all-pass, 1 on first failure with a clear `FAIL:` message
- [ ] `.planning/phases/01-audit/01-AUDIT-COVERAGE.md` (or inline in AUDIT.md preamble) — checklist mapping each ROADMAP success criterion 1–5 to the AUDIT.md section(s) that satisfy it (used by reviewer during approval gate)

*The structural-check script is the only automation in this phase — every later task either populates a section that the script asserts on, or builds the appendix B trace table.*

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| AUDIT.md is a verified superset of CONCERNS.md (no entry dropped silently) | AUDIT-02, success criterion 2 | "Verified superset" is a semantic claim — the structural check confirms >= 14 rows in Appendix B, but the reviewer must spot-check 3 random CONCERNS.md entries against the named AUDIT-* destination to confirm the entry was actually absorbed (not just listed in the trace) | (1) Open `.planning/codebase/CONCERNS.md`. (2) Pick 3 entries from different sections. (3) For each, find its row in Appendix B, jump to the named AUDIT-* section, confirm the finding is rewritten there with the original `file:line` citation preserved. |
| "What's missing for v2" callouts stay observation-led (no design moves proposed) | D-13, AUDIT-01 | The audit must describe what's missing and point at the DESIGN-* requirement; it must NOT propose how the v2 design closes the gap. Reviewer judges tone. The canonical D-13 banned-phrase ERE used by every plan's gate is `'we should\|the design will\|recommend that v2\|propose\|v2 will'` (case-insensitive). | Read each per-skill "What's missing for v2" subsection. Confirm: (a) it names the gap, (b) it points at a DESIGN-NN requirement in REQUIREMENTS.md, (c) it does NOT prescribe how DESIGN-NN should solve the gap. |
| AUDIT-07 cosmetic-fix bullets carry the v2.1 constraint per-bullet (not just at section header) | D-16, AUDIT-07 | The structural check asserts the canonical sentinel via case-insensitive ERE `'scheduled for v2\.1 (foundations )?build'` is present per bullet (count >= 6 inside AUDIT-07); the reviewer confirms no bullet was structured to defeat that check (e.g., wrapping all bullets in a single sentinel paragraph above and not in each bullet). | Read AUDIT-07 section. For every cosmetic-fix bullet, confirm the bullet itself contains "Scheduled for v2.1 Foundations build (FOUND-NN), NOT this milestone." (or the lowercase `scheduled for v2.1 build` variant — both match the gate). |
| MCP probe results are honest (probes were actually run, not hallucinated) | AUDIT-08, D-04..D-07 | The probe table records observed call outcomes — reviewer must confirm at least 3 probe calls in the table by re-running them in the live workspace and matching status. | Pick 3 rows from the AUDIT-08 probe table. For each, re-run the documented `probe call` against the live MCP. Confirm the recorded status (working / broken / missing) matches. |
| Citations resolve (every `file:line` actually exists) | D-14, all AUDIT-* | Structural check could grep but won't catch line-drift. Reviewer spot-checks. | Pick 5 random `file:line` citations from AUDIT.md. Open each and confirm the cited line/range matches the finding. |

---

## Validation Sign-Off

- [ ] All AUDIT-* sections have either a structural assertion in `audit-structure-check.sh` or a row in the Manual-Only table above
- [ ] Sampling continuity: structural check runs after every section-completing task (no AUDIT-0N section commits without its assertion firing)
- [ ] Wave 0 produces `audit-structure-check.sh` before any AUDIT.md content tasks land
- [ ] No watch-mode flags (no test runner)
- [ ] Feedback latency < 5s (structural check is grep-only)
- [ ] Reviewer attestation against ROADMAP success criteria 1–5 captured in commit message or PR description
- [ ] `nyquist_compliant: true` set in frontmatter once all of the above hold

**Approval:** pending
