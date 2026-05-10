---
phase: 5
slug: foundations
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-05-10
---

# Phase 5 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

> **Note:** Phase 5 is a foundations + canonical-references phase — no application code, no test framework needed. "Validation" = grep/jq/file-existence assertions baked into a single shell script (`scripts/validation/phase5-structure-check.sh`) that mirrors the Phase 1–4 pattern. The Validation Architecture details live in `05-RESEARCH.md` and will be hoisted into per-task `<acceptance_criteria>` blocks by the planner.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | bash + grep + jq + diff (no JS/Python test framework — docs/config phase) |
| **Config file** | none — assertions are inline in the structure-check script |
| **Quick run command** | `bash scripts/validation/phase5-structure-check.sh --quick` |
| **Full suite command** | `bash scripts/validation/phase5-structure-check.sh` |
| **Estimated runtime** | ~3 seconds |

---

## Sampling Rate

- **After every task commit:** Run `bash scripts/validation/phase5-structure-check.sh --quick` (only the section relevant to the task — script supports `--section <name>` for per-criterion runs)
- **After every plan wave:** Run `bash scripts/validation/phase5-structure-check.sh` (full grep/jq matrix)
- **Before `/gsd-verify-work`:** Full suite must exit 0
- **Max feedback latency:** 3 seconds

---

## Per-Task Verification Map

> Populated by the planner. Each task's `<acceptance_criteria>` block must include the grep/jq command from the matrix below.

| Task ID | Plan | Wave | Requirement | Secure Behavior | Test Type | Automated Command | Status |
|---------|------|------|-------------|-----------------|-----------|-------------------|--------|
| TBD | TBD | TBD | TBD | TBD | grep / jq / file-exists | TBD | ⬜ pending |

*Populated by gsd-planner from the Validation Architecture in `05-RESEARCH.md`.*

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Validation Architecture (lifted from `05-RESEARCH.md`)

The planner MUST copy these assertions verbatim into per-task `<acceptance_criteria>` blocks. Source of truth: `05-RESEARCH.md ## Validation Architecture`.

**Categories of assertions for Phase 5:**

1. **Canonical references exist + content equality** — `test -f dydx-delivery/references/{safety-rules,stage-numbering,frontmatter-scheme,glossary}.md` AND `grep -c` patterns matching the DESIGN-01/02/03 contract sections.
2. **Hard-rules deduplication** — `! grep -rE 'destructive ops|read-only.*Coda|safety.*rules' dydx-delivery/skills/ --include=SKILL.md` (zero hits — content moved out).
3. **Sandbox-block bug fix** — `grep -E 'sandbox.coda_doc' dydx-delivery/references/safety-rules.md` AND specific authorising clause text present.
4. **`based_on_*` field-name normalisation** — every artefact template references the canonical name; `grep -r 'based_on_' dydx-delivery/skills/ --include='*.md'` shows only the canonical variant per artefact type.
5. **File renumbering applied** — file existence checks for `02_*`, `03_*`, `04*_*`, `05_*`, `07a_*` patterns per FOUND-03 mapping table; absence of old `00_*`, `01_*`, etc. for renumbered artefacts.
6. **Manifest 2.0.0 sync** — `jq -r .version plugin.json == "2.0.0"`, `jq -r '.plugins[0].version' marketplace.json == "2.0.0"`, `jq -r .metadata.version marketplace.json == "2.0.0"`, AND `jq -r .author marketplace.json` retains `jasonmichaelb@gmail.com` (UAT-3.1).
7. **LICENSE byte-exact** — `diff <(printf 'All rights reserved.\nNot licensed for redistribution.\n') LICENSE` returns 0.
8. **Scaffold dirs present** — `test -d dydx-delivery/{commands,agents,hooks}`; `.gitkeep` files tracked.
9. **Connector matrix completeness** — `test -f dydx-delivery/references/connector-matrix.md`; `grep -c` for each of the 6 connectors (Coda MCP, Google Workspace MCP, Miro MCP, Pipefy API, Wrike API, Ziflow API) AND each of the 11 stages with fallback behaviour.
10. **OPEN-Q resolution** — every Q-id (Q06.1, Q07.1, Q09, Q10, Q11, Q12, Q13, Q25) has its answer recorded either in `connector-matrix.md` (Q06.1/Q07.1/Q09/Q10/Q11/Q12/Q13/Q25) AND mirrored to `OPEN-QUESTIONS.md` as RESOLVED with cite.
11. **AUDIT-07 cosmetic fixes** — `! grep -i 'test sheet' README.md` (B.2); `grep -E '13.step pipeline|13 stages' README.md` (B.3); `jq -r .homepage marketplace.json` non-null (B.6); LICENSE present (B.4); README truncation completed (B.1 — completion text approved by user). B.5 owner-email NOT modified — assertion: `jq -r .author marketplace.json == "jasonmichaelb@gmail.com"`.
12. **Status-lifecycle survey re-run** — survey output file at `.planning/phases/05-foundations/05-STATUS-SURVEY.md` exists; references the 2 known Coda brain folders (Up & Up Group, VodafoneZiggo); confirms zero drift OR documents drift with cite.

---

## Wave 0 Requirements

- [ ] `scripts/validation/phase5-structure-check.sh` — single bash script with all assertions above (no test framework install needed)
- [ ] Script exits 0 only when every assertion passes; prints `[PASS] <criterion>` per success and `[FAIL] <criterion>: <why>` per failure
- [ ] Script supports `--section <name>` for per-section runs and `--quick` for fastest subset

*If none: "Existing infrastructure covers all phase requirements."* — N/A; this script is new.

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Canonical-reference content fidelity (semantic match against DESIGN-01/02/03 intent, not just keyword presence) | FOUND-01, FOUND-02 | Grep proves keywords exist but cannot prove content faithfully captures the contract intent | Read each of the 4 canonical-reference files end-to-end and compare against DESIGN-01/02/03 sections; record approval in commit message |
| Connector matrix per-stage fallback table semantic correctness | FOUND-08 | Grep proves rows exist; semantic correctness (e.g., "Stage 6 → manual mode if Coda missing" actually models the right fallback) needs human review | Read the `## Per-Stage Fallback Behaviour` table; confirm each row matches the lifecycle in `dydx-delivery/skills/<stage>/SKILL.md`; record approval |
| Status-lifecycle survey result interpretation (drift vs no-drift judgement) | FOUND-12 | Survey output requires human judgement to classify "drift" vs "intentional update" | Read `05-STATUS-SURVEY.md`; compare against 2026-05-10 baseline sample; record explicit approval-or-flag |

---

## Validation Sign-Off

- [ ] All tasks have `<acceptance_criteria>` with grep/jq/file-exists commands or Wave 0 dependency on the structure-check script
- [ ] Sampling continuity: every plan wave ends with a full structure-check run
- [ ] Wave 0 delivers `scripts/validation/phase5-structure-check.sh` before any other plan wave runs assertions against it
- [ ] No watch-mode flags
- [ ] Feedback latency < 3s
- [ ] `nyquist_compliant: true` set in frontmatter once all per-task entries are populated and verified

**Approval:** pending
