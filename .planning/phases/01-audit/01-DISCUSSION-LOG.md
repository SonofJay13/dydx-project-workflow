# Phase 1: Audit - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-05-09
**Phase:** 1-audit
**Areas discussed:** Document structure, MCP probe methodology, CONCERNS.md absorption, Per-skill audit shape

---

## Document structure (top-level)

| Option | Description | Selected |
|--------|-------------|----------|
| By AUDIT-* requirement | One major section per AUDIT-01..08; reviewer verifies success criteria 1:1 against the doc; familiar to GSD verifiers; some cross-referencing where a finding spans two reqs | ✓ |
| By subject area | Skills / Manifests & Versioning / Connectors / Content Health / Cosmetics; reads more like an audit report; needs a traceability table back to AUDIT-* | |
| By severity | Blocking / Structural / Cosmetic; drives what gets fixed when; scatters skills/connectors/manifests across sections | |
| By phase-of-fix | Sections labelled by which v2.x phase will fix the finding; ties audit to CHANGELIST.md early; sequencing belongs in Phase 3, not Phase 1 | |

**User's choice:** By AUDIT-* requirement (recommended)
**Notes:** Cross-cutting findings handled by primary-section + cross-reference; severity carried as inline tag (`[BLOCKING] / [STRUCTURAL] / [COSMETIC]`) so reviewers can still scan by severity within an AUDIT-* section.

---

## MCP probe methodology (AUDIT-08)

| Option | Description | Selected |
|--------|-------------|----------|
| Smoke-test + version pin | One cheap read-only call per MCP (list-pages / list-files / list-calendars / list-labels / list-boards) + capture server identity + version. Catches "wired but auth-broken" | ✓ |
| Config inspection only | Read MCP config; list servers by name + version. No live calls. Misses "wired-and-broken" | |
| Smoke + functional probe | Smoke-test plus the v2-relevant operation per MCP (Coda mutationStatus poll, Drive folder-create, Miro export-board). Heavy; better suited to v2.x build connector-probe | |
| Defer to v2.1 build phase | AUDIT.md only inventories config-declared MCPs and flags 'verification deferred'. Violates AUDIT-08 success criterion | |

**User's choice:** Smoke-test + version pin (recommended)
**Notes:** User mid-session connected the Miro and Coda MCPs and confirmed proceeding with the recommended depth. Pipefy / Wrike / Ziflow APIs are separate (no MCP for these in this workspace) and Claude in Chrome's canonical product naming is deferred to Phase 4 OPEN-QUESTIONS.

---

## CONCERNS.md absorption (AUDIT-02)

| Option | Description | Selected |
|--------|-------------|----------|
| Inline + supersede | Every CONCERNS.md entry rewritten into the relevant AUDIT-* section with citation preserved; AUDIT.md becomes self-contained; Appendix B traces CONCERNS.md → AUDIT.md mapping proving no entry was dropped | ✓ |
| Reference + delta | AUDIT.md cites CONCERNS.md by section and only writes new findings inline; less duplication; violates "self-contained reference" success criterion | |
| Quote-block import | Paste each CONCERNS.md section as block quote, then add audit verdict; preserves wording exactly; AUDIT.md becomes a wrapper, not a superset | |

**User's choice:** Inline + supersede (recommended)
**Notes:** Net-new findings get an explicit `[NEW]` tag so the appendix mapping is honest about what's superset vs what's import.

---

## Per-skill audit shape (AUDIT-01)

| Option | Description | Selected |
|--------|-------------|----------|
| Hybrid: matrix + per-skill brittleness/v2-gap | Scannable matrix (7 rows × 6 cols) + focused per-skill subsection for prose-heavy fields (hand-off contract, brittleness, v2-gap). Best of both | ✓ |
| Pure narrative sections | Full section per skill with all 7 fields as prose. Richest read but ~49 paragraphs total; can't compare skills at a glance | |
| Pure matrix table | Single wide table covering all 7 fields per skill. Maximum scannability but loses brittleness and v2-gap nuance in cell-sized prose | |

**User's choice:** Hybrid (recommended)
**Notes:** "What's missing for v2" stays observation-led — name the gap, point at the relevant DESIGN-* req, do not propose the design move (Phase 2's territory).

---

## Claude's Discretion

- Internal ordering within each AUDIT-* section (chronological vs grouped-by-file vs by-severity within section).
- Exact wording and length per skill subsection — match the depth the underlying material justifies, no padding.
- Whether to include code/text excerpts inline or only cite — default to citation; quote only when wording itself is the finding (truncated changelog sentence; "test sheet" residual wording).

## Deferred Ideas

- Per-stage connector graceful-degradation behaviour rules → Phase 2 (DESIGN-07).
- Status-lifecycle survey of live client folders → Phase 4 OPEN-QUESTIONS (OPEN-03).
- Plugin self-test scope decision → Phase 4 OPEN-QUESTIONS (OPEN-07).
- `/refine-<skill>` resolution → Phase 4 OPEN-QUESTIONS (OPEN-06); Phase 1 only inventories the orphan references.
- Pipefy / Wrike / Ziflow live API probing → v2.1+ build phase per CHANGE-04.
