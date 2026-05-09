# Audit: dydx-delivery v0.3.0 — v2.0 Implementor Edition baseline

**Audit Date:** 2026-05-09
**Branch / commit:** dydx-delivery-v2 / (record current commit at AUDIT-08 wave)

## How to read this audit

(preamble placeholder — written in final synthesis Wave 9)

## Executive Summary

(executive summary table placeholder — populated in Wave 9)

---

## AUDIT-01: Per-Skill Inventory

Catalogues all 7 v0.3.0 skills shipped under `dydx-delivery/skills/`. Each skill has a matrix row below plus a focused prose subsection covering hand-off contract, observed brittleness, and what's missing for v2 — observation-led; design moves are deferred to DESIGN-* requirements in `.planning/REQUIREMENTS.md`. Every brittleness bullet carries a `file:line` citation and a severity tag (`[BLOCKING]` / `[STRUCTURAL]` / `[COSMETIC]`); every "What's missing for v2" subsection ends with a `**Closes via:** DESIGN-NN` trailer that names the requirement closing the gap without prescribing the fix.

| Skill | Purpose (1 line) | Inputs | Outputs | Downstream consumer | Deps | Status flag(s) |
|---|---|---|---|---|---|---|
| `discovery-intake` | Capture system, users, triggers, data, rules, integrations, exceptions, failure points | Free-form context; optional existing `00_discovery_v*.md` | `<Client>/build-specs/<platform>/00_discovery_v{N}.md` | `generate-sow` | — | `status: draft` (no follow-up status documented) |
| `generate-sow` | Draft a stage-2 scope of work from approved discovery | Latest `00_discovery_v*.md`; inline commercial framing | `<Client>/build-specs/<platform>/01_sow_v{N}.md` | `generate-functional-spec` | — | `draft → client_review → approved` (sole skill documenting `client_review`) |
| `generate-functional-spec` | Single fnspec per project, platform-tagged via `platform:` frontmatter | Latest `01_sow_v*.md` (required); discovery for context | `<Client>/build-specs/<platform>/02_functional-spec_v{N}.md` | `generate-technical-spec` | — | `draft → approved` (no `client_review`) |
| `generate-technical-spec` | Translate fnspec into platform constructs | Latest `02_functional-spec_v*.md`; reads `platform:` frontmatter to dispatch | `<Client>/build-specs/<platform>/03_technical-spec_v{N}.md` | `generate-test-plan` | platform-pipefy / platform-wrike (referenced; missing — see AUDIT-04) | `draft → approved` |
| `generate-test-plan` | Produce table-format test plan against sandbox tenant | Latest `03_technical-spec_v*.md`; functional spec for AC; user-supplied `<feature>` name | `<Client>/testing/<feature>/test-plan_v{N}.md` | `generate-build-prompt` | — | `draft → approved` |
| `generate-build-prompt` | Emit Claude-Code-ready build prompt for developers | Latest `03_technical-spec_v*.md` (must be `approved` for production); latest `test-plan_v*.md`; fnspec + SOW for context | `<Client>/build-specs/<platform>/04_build-prompt_v{N}.md` | `execute-tests` (after dev build) | platform-pipefy / platform-wrike (referenced; missing — see AUDIT-04) | `draft` (no follow-up status documented) |
| `execute-tests` | Run the approved test plan, enforce sandbox-only safety rules | Latest `test-plan_v*.md` (`approved`); sandbox credentials; matching platform skill | `<Client>/testing/<feature>/results-YYYY-MM-DD_v{N}.md` | (terminal — results summary) | platform-pipefy / platform-wrike (referenced; missing — see AUDIT-04) | (no `status:` field on results-template) |

---

## AUDIT-02: CONCERNS.md absorption (verified superset)

(populated by Wave 9 — synthesis after Waves 2-8 land)

---

## AUDIT-03: Per-Stage Connector Dependencies

(populated by 01-03-PLAN.md / Wave 3)

---

## AUDIT-04: Referenced-but-Missing Artefacts

(populated by 01-04-PLAN.md / Wave 4)

---

## AUDIT-05: Duplicated Content Blocks

(populated by 01-05-PLAN.md / Wave 5)

---

## AUDIT-06: Version-String Mismatches

(populated by 01-06-PLAN.md / Wave 6)

---

## AUDIT-07: Cosmetic-but-Client-Visible Issues

(populated by 01-07-PLAN.md / Wave 7)

---

## AUDIT-08: Live MCP Wiring Probe

(populated by 01-08-PLAN.md / Wave 8)

---

## Appendix A: Glossary

(populated by Wave 9)

---

## Appendix B: CONCERNS.md → AUDIT.md trace

(populated by Wave 9)

---

*Audit produced 2026-05-09; CONCERNS.md becomes "historical input — superseded by AUDIT.md" after this milestone approves.*
