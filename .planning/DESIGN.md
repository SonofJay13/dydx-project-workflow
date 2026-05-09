# Design: dydx-delivery v2.0 — Implementor Edition architecture

**Design Date:** 2026-05-09
**Branch / commit:** dydx-delivery-v2 / (record current commit at synthesis plan)
**Phase 1 Audit (ground truth):** `.planning/AUDIT.md` (approved 2026-05-09)

> **How to read this design.** This document locks the v2 architecture for the dydx-delivery plugin so the v2.1+ rebuild can execute without re-deciding. Each major section opens with a one-line success-criteria echo (`> **DESIGN-NN:** <plain-English statement>`) so reviewer can match section to REQUIREMENTS.md without cross-referencing. Inline `[OPEN: Phase 4 — ...]` markers flag undecided contracts; the closing `## Deferred to Phase 4 OPEN-QUESTIONS` section enumerates every marker for Phase 4 register handoff. Citations use `file:line` format (Phase 1 D-14 convention). DESIGN.md cites `AUDIT.md §X.Y` for v0.3.0 facts (Phase 2 D-34) — does NOT re-derive observations from v0.3.0 source.
>
> (Preamble placeholder — finalised in synthesis plan 02-10)

## Executive Summary

(Executive summary table placeholder — populated in synthesis plan 02-10. Acts as TOC: per-section page-anchor + one-line decision summary so reader can skip-to-contract.)

---

## Cross-cutting decisions

These ten cross-cutting decisions ground every later section. Each is locked here as a contract — substages that depend on a contract cite it back rather than re-arguing the decision. Per D-19, this section opens with a scannable decision-summary table; per-decision prose follows under H3 anchors below.

frontmatter_version: 2

| ID | Decision area | Locked contract (one line) | Locking decision |
|----|---------------|-----------------------------|------------------|
| DESIGN-01 | Frontmatter scheme | `frontmatter_version: 2`; status `draft → client_review → approved → archived`; underscore-snake-case keys; platform-gated identifiers | D-25 (survey) |
| DESIGN-02 | Stage numbering | File-prefix = stage number `01..11`; substages `4a/4b/7a/7b/8a..8d`; canonical at `dydx-delivery/references/stage-numbering.md` | — |
| DESIGN-03 | Hard-rules SoT | Single SoT at `dydx-delivery/references/safety-rules.md` + per-client `safety-overrides.yaml` overlay (only `overridable: true` fields) | AUDIT.md §AUDIT-05 (4 hard-rules duplicates collapsed) |
| DESIGN-04 | Plugin surfaces | `commands/`: 1 parameterised `refine.md` + 4 GSD shortcuts; `agents/`: 1 test-bot-orchestrator; `hooks/`: 2 (`validate-frontmatter` + `bump-artefact-version`, NOT auto-progression); `mcpServers` field; manifest `2.0.0`; pytest self-tests at `dydx-delivery/tests/` per D-24 | D-24 |
| DESIGN-05 | `/refine-<skill>` resolution | Single parameterised `commands/refine.md` taking skill name as `$1`; namespace `/dydx-refine-*` (NOT bare `/refine-*`) | D-23 |
| DESIGN-06 | Approval-gate enforcement | Mandatory `approved_by` + `approved_at` on `status: approved` writes; hook refuses writes lacking these fields | — |
| DESIGN-07 | Connector probe + degradation | Session-start MCP probe + per-stage fallback per AUDIT.md §AUDIT-03 PITFALLS-cited fallback table | AUDIT.md §AUDIT-03 |
| DESIGN-08 | Frontmatter migration co-existence | CR-driven opt-in; `client_review` retained (live in `generate-sow`); v0.3.0 absent → lenient mode; in-flight artefacts NEVER auto-flip | D-25 (survey result locks) |
| DESIGN-09 | Directional boundary | Local `<Client> Brain/` canonical; Coda one-way mirror; Field Notes read-only triage queue; never auto-merged | — |
| DESIGN-10 | Persona contract | ~5 senior-implementer voice principles + forbidden-phrasings list inline; 3 worked before/after examples in Appendix C | D-29 |

### Live status-lifecycle survey

**Methodology.** No live `<Client> Brain/` folders are reachable from this workspace at probe time (2026-05-09; checked sibling directories under `C:/Users/Jason Blignaut/Documents/Coding/` — only non-client project folders present: `AWS`, `Anaconda`, `Ardit Sluice` (non-dYdX project subfolders), `dydx-project-workflow`). Per D-25 fallback, the survey enumerates every `status:` value visible in v0.3.0 SKILL.md sources: every literal `status:` token (frontmatter sample, `status:` flow assignment, prose status-flag reference, hand-off-message status reference) is captured with `file:line` per D-32. Fallback is documented transparently rather than fabricating live-folder results (T-02-02-01 mitigation).

**Sampled sources.**

| Source | Type | `status:` values observed |
|--------|------|---------------------------|
| `dydx-delivery/skills/discovery-intake/SKILL.md:103` | v0.3.0 frontmatter sample | `draft` |
| `dydx-delivery/skills/generate-sow/SKILL.md:78` | v0.3.0 frontmatter sample | `draft` |
| `dydx-delivery/skills/generate-sow/SKILL.md:93` | v0.3.0 hand-off prose | `client_review`, `approved` |
| `dydx-delivery/skills/generate-functional-spec/SKILL.md:80` | v0.3.0 frontmatter sample | `draft` |
| `dydx-delivery/skills/generate-functional-spec/SKILL.md:95` | v0.3.0 hand-off prose | `approved` |
| `dydx-delivery/skills/generate-build-prompt/SKILL.md:12` | v0.3.0 input requirement | `approved` |
| `dydx-delivery/skills/generate-build-prompt/SKILL.md:117` | v0.3.0 frontmatter sample | `draft` |
| `dydx-delivery/skills/generate-build-prompt/SKILL.md:138` | v0.3.0 prose | `approved` |
| `dydx-delivery/skills/execute-tests/SKILL.md:12` | v0.3.0 input requirement | `approved` |
| `dydx-delivery/skills/execute-tests/SKILL.md:50` | v0.3.0 prompt fallback | `approved` |
| `.planning/AUDIT.md §AUDIT-01.2` | Phase 1 ground truth — generate-sow lifecycle | `draft → client_review → approved` |
| `.planning/AUDIT.md §AUDIT-01.3` | Phase 1 ground truth — generate-functional-spec lifecycle | `draft → approved` (no `client_review`) |

**Distinct values found:** `{draft, client_review, approved}`.

**Reconciliation against canonical `{draft, client_review, approved, archived}`:**
- `draft` — observed; locked as canonical opening status. No reconciliation required.
- `client_review` — observed only in `generate-sow:93` (per AUDIT.md §AUDIT-01.2, the sole skill carrying `client_review` in its hand-off prose). Locked as canonical. DESIGN-08 mandates retention so in-flight `client_review` artefacts NEVER auto-flip on migration.
- `approved` — observed; locked as canonical sign-off status. DESIGN-06 layers `approved_by` + `approved_at` mandatory fields on every `status: approved` write.
- `archived` — NOT observed in v0.3.0 sources. Adding `archived` to the canonical lifecycle is net-new in v2 (DESIGN-27 Stage 11 sign-off-and-archive lands the write). No live value is orphaned by introducing `archived`.

**Conclusion.** Canonical lifecycle `draft → client_review → approved → archived` does not orphan any observed `status:` value. Every value present in v0.3.0 (`draft`, `client_review`, `approved`) is preserved unchanged; `archived` is additive and writes only at Stage 11. DESIGN-08 contract is locked: v2 readers tolerate v0.3.0 frontmatter via `frontmatter_version` (absent → lenient), CR-driven opt-in upgrade, no auto-flip. No `[MIGRATION-RISK]` marker required from this survey result.

---

## Skill layout

(Populated by 02-03-PLAN.md / Wave 3. Covers DESIGN-11 — v2 folder layout: `skills/`, `commands/`, `agents/`, `hooks/`, `.claude-plugin/`, plugin-level `references/`.)

---

## 13-skill inventory

(Populated by 02-03-PLAN.md / Wave 3. Covers DESIGN-12 — 13-skill inventory matrix-then-prose: 6 NEW stage + 3 NEW platform + 4 MODIFIED + 2 UNCHANGED + 1 RETIRED-AND-REPLACED.)

---

## Stage-by-stage hand-off contract

(Populated by 02-03-PLAN.md / Wave 3. Covers DESIGN-13 — single transition matrix per D-26: From | To | Carrier file path | Frontmatter fields propagated | Gating status flag | Hand-off message. >= 10 transition rows.)

| From | To | Carrier file path | Frontmatter fields propagated | Gating status flag | Hand-off message |
|------|-----|-------------------|-------------------------------|--------------------|--------------------|

---

## Platform skills

(Populated by 02-04-PLAN.md / Wave 4. Covers DESIGN-14, 15, 16 — `platform-pipefy/`, `platform-wrike/`, `platform-ziflow/` with identical 5-file `references/` shape.)

### platform-pipefy
(populated by 02-04-PLAN.md)

### platform-wrike
(populated by 02-04-PLAN.md)

### platform-ziflow
(populated by 02-04-PLAN.md)

---

## Stage 1: Kickoff capture
(Populated by 02-05-PLAN.md / Wave 5. Covers DESIGN-17.)

## Stage 2: Discovery refactor
(Populated by 02-05-PLAN.md / Wave 5. Covers DESIGN-18.)

## Stage 3: SOW refactor
(Populated by 02-05-PLAN.md / Wave 5. Covers DESIGN-19.)

## Stage 4a: Functional spec — platform
(Populated by 02-06-PLAN.md / Wave 6. Covers DESIGN-20 first half.)

## Stage 4b: Functional spec — integration
(Populated by 02-06-PLAN.md / Wave 6. Covers DESIGN-20 second half.)

## Stage 5: Tech spec
(Populated by 02-06-PLAN.md / Wave 6. Covers DESIGN-21.)

## Stage 6: Cost estimate
(Populated by 02-07-PLAN.md / Wave 7. Covers DESIGN-22 — risk-multiplier taxonomy structure; numeric defaults DEFERRED per D-22.)

## Stage 7a: Build prompt — dev
(Populated by 02-07-PLAN.md / Wave 7. Covers DESIGN-23 first half.)

## Stage 7b: Build prompt — implementation per platform
(Populated by 02-07-PLAN.md / Wave 7. Covers DESIGN-23 second half.)

## Stage 8: Test bot — overview
(Populated by 02-08-PLAN.md / Wave 8. Covers DESIGN-24.)

## Stage 9: Documentation publishing
(Populated by 02-08-PLAN.md / Wave 8. Covers DESIGN-25.)

## Stage 10: Native-AI enablement
(Populated by 02-08-PLAN.md / Wave 8. Covers DESIGN-26.)

## Stage 11: Sign-off, brain update, archive
(Populated by 02-08-PLAN.md / Wave 8. Covers DESIGN-27.)

---

## Test bot architecture

(Populated by 02-09-PLAN.md / Wave 9. Covers DESIGN-28, 29, 30 — Python↔AI orchestrator boundary, `client_state.yaml` skeleton, drift-detection contract.)

### DESIGN-28: tier-1 / tier-2 boundary
(populated by 02-09-PLAN.md)

### DESIGN-29: client_state.yaml skeleton
(populated by 02-09-PLAN.md)

### DESIGN-30: drift-detection contract
(populated by 02-09-PLAN.md)

---

## Deferred to Phase 4 OPEN-QUESTIONS

(Populated by 02-10-PLAN.md / Wave 10 synthesis. Closed enumerated list of every inline `[OPEN: Phase 4 — ...]` marker, in document order, with source section reference. Phase 4 register builds against this list.)

- [OPEN: Phase 4 — risk-multiplier numeric defaults pending dYdX-historical validation per D-22]

---

## Appendix A: Glossary
(Populated by 02-10-PLAN.md / Wave 10 synthesis.)

---

## Appendix B: DESIGN-* → DESIGN.md section traceability
(Populated by 02-10-PLAN.md / Wave 10 synthesis. 30-row table: DESIGN-NN | section anchor | locking decision IDs.)

---

## Appendix C: Persona contract worked examples
(Populated by 02-02-PLAN.md alongside DESIGN-10. 3 before/after examples per D-29.)

---

*Design produced 2026-05-09; supersedes ad-hoc v0.3.0 architecture. Phase 3 CHANGELIST.md sequences the v2.x build against this design; Phase 4 OPEN-QUESTIONS.md catalogues every inline [OPEN] marker.*
