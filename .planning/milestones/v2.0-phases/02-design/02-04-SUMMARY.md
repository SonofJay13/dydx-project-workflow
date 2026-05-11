---
phase: 02-design
plan: 04
subsystem: platform-skills-internalisation
tags: [design, platform-skills, native-ai, internalisation, wave-4]
requires: [cross-cutting-decisions-locked, skill-layout-locked, skill-inventory-locked, handoff-matrix-locked]
provides: [platform-pipefy-design-14, platform-wrike-design-15, platform-ziflow-design-16, platform-comparison-matrix]
affects: [.planning/DESIGN.md]
tech_stack:
  added: []
  patterns:
    - 5-file `references/` shape per platform skill (api-contract / native-ai-inventory / knowledge-ingestion / client-shape-gotchas / vocabulary)
    - 2026-grounded native-AI capability matrix with HIGH / MEDIUM / LOW Confidence column (per D-25 honesty)
    - `tier_claims_last_verified: <ISO date>` frontmatter contract — v2.x build's hook for re-verifying capability matrix against then-current platform reality
    - `native_ai_path: api | paste | none` flag with confidence — DESIGN-26 routing input
    - inline `[OPEN: Phase 4 — ...]` marker template citing OPEN-01 + Phase-N owner per CHANGE-04
    - forward-reference guardrails (cross-AI MEDIUM #6) — DESIGN-22/23/24/26 cited as anchor placeholders only; body verification deferred to Plan 02-10 Appendix B
key_files:
  created:
    - .planning/phases/02-design/02-04-SUMMARY.md
  modified:
    - .planning/DESIGN.md
    - .planning/ROADMAP.md
decisions:
  - "Phase 2 Plan 04: Platform-comparison matrix opens `## Platform skills` H2 (D-19) — 3 rows × 6 columns (Platform | Native-AI surface 2026 | API protocol | Sandbox access | native_ai_path default | Known research-blocked items); reads as quick-scan reference before per-platform H3 contracts"
  - "Phase 2 Plan 04: Each platform H3 carries identical 5-file `references/` ASCII tree (`api-contract.md`, `native-ai-inventory.md`, `knowledge-ingestion.md`, `client-shape-gotchas.md`, `vocabulary.md`) per DESIGN-14/15/16 echo; locks D-21 contract that decision-only — full SKILL.md and references/*.md prose authoring runs in v2.2 PLAT-01..03"
  - "Phase 2 Plan 04: Pipefy native-AI matrix = 7 rows (KB / Skills / MCP / IDP / Web Search / BYO-LLM all HIGH; KB content-upload via API LOW with [OPEN] marker citing OPEN-01 Phase 7 owner per CHANGE-04); native_ai_path: api default with paste fallback for KB content-upload UNTIL [OPEN] resolves"
  - "Phase 2 Plan 04: Wrike native-AI matrix = 4 rows (Copilot HIGH / 16 MCP tools HIGH / attach-doc-via-MCP MEDIUM / AI Studio knowledge-ingestion API LOW with [OPEN]); native_ai_path: api default with paste fallback for AI Studio ingestion"
  - "Phase 2 Plan 04: Wrike `host` persistence rule called out as CRITICAL bug-prevention — wrike_host: must be persisted from OAuth response (NOT hardcoded www.wrike.com per RESEARCH/PITFALLS); triple-mention (API surface CRITICAL callout, sandbox-access pattern, cross-references to DESIGN-29 forward); satisfies T-02-04-02 + T-02-04-06 mitigation"
  - "Phase 2 Plan 04: Ziflow native-AI matrix = 4 rows (Checklists Public Preview HIGH / Change Verification Coming Soon MEDIUM / Brand Standards Coming Soon MEDIUM / ReviewAI knowledge-ingestion API LOW with [OPEN]); native_ai_path: paste DEFAULT (Checklists Public Preview is documented copy-paste path; api upgrade IF [OPEN] resolves an ingestion API)"
  - "Phase 2 Plan 04: Ziflow `wait_for_proof(proof_id, max_wait_s)` helper grounded in read-after-create eventual consistency — proof-create returns before proof readable; subsequent reads may 404 within consistency window; helper polls until readable or max-wait expires; conservative default 30s poll with 2s interval pending [OPEN] verification"
  - "Phase 2 Plan 04: 7 new inline [OPEN: Phase 4 — ...] markers added (3 pipefy: KB content-upload endpoint + GraphQL pagination cursor field names + 2026 rate-limit currency; 2 wrike: AI Studio knowledge-ingestion API + 2026 rate-limit currency; 2 ziflow: ReviewAI knowledge-ingestion API + read-after-create consistency window); all cite OPEN-01 + Phase-N owner per CHANGE-04 uniform format for Plan 02-10 enumeration; total inline `[OPEN: Phase 4]` count across DESIGN.md = 13 (>= 8 floor with margin)"
  - "Phase 2 Plan 04: Forward-reference guardrails per cross-AI review MEDIUM #6 — DESIGN-22 (Stage 6 cost) / DESIGN-23 (Stage 7b implementation prompt) / DESIGN-24 (Stage 8a test harness) / DESIGN-26 (Stage 10 native-AI push) cited as anchor placeholders only; explicitly noted 'forward reference, populated in Plan 02-0X' inline; acceptance criteria do NOT assert those sections' body content exists at end of Wave 4 (deferred to Plan 02-10 Appendix B traceability)"
  - "Phase 2 Plan 04: Echo line count progresses 13 → 16/30 (DESIGN-14, DESIGN-15, DESIGN-16 added); structural-check exits 1 with assertion #4 short-circuit at 16/30 — expected mid-phase invariant; Plans 02-05..02-09 close remaining 14 echoes"
metrics:
  duration: ~10 min
  completed_date: 2026-05-09
---

# Phase 2 Plan 04: Platform skills DESIGN-14 / DESIGN-15 / DESIGN-16 Summary

Wave 4 — populated `.planning/DESIGN.md` `## Platform skills` H2 with the 3-row platform-comparison matrix opener (D-19) plus the three per-platform H3 subsections (`### platform-pipefy`, `### platform-wrike`, `### platform-ziflow`) carrying identical 5-file `references/` shape, 2026-grounded native-AI capability matrices, API surfaces with platform-specific helpers, sandbox access patterns, `native_ai_path` flags, and `tier_claims_last_verified` frontmatter contracts. Echo line count progressed 13 → 16/30. Total inline `[OPEN: Phase 4]` markers across DESIGN.md now 13.

## What Was Built

**One-liner:** 3 platform skill decision contracts locked under DESIGN-14/15/16 with grep-canonical 5-file `references/` shape, 2026-grounded native-AI matrices honestly labelled HIGH / MEDIUM / LOW per D-25, and 7 new inline `[OPEN]` markers flagging research-blocked items for Phase 4 register handoff; Wrike `host` OAuth-persistence rule triple-mentioned as CRITICAL bug-prevention against the v0.3.0 hardcoded `www.wrike.com` regression.

### `.planning/DESIGN.md` — populated regions

**`## Platform skills` H2 — opening matrix + framing populated** (was: stub placeholder):

- One-paragraph framing citing AUDIT.md §AUDIT-04.1 (v0.3.0 missing-artefact references) + DESIGN-04 (plugin-level surfaces) + 5-file `references/` shape + RESEARCH.md / FEATURES.md (2026 grounding) + D-21 (decision contracts only — full SKILL.md prose deferred to v2.2 PLAT-01..03 per CHANGELIST.md).
- Mention of `tier_claims_last_verified: <ISO date>` discipline as the v2.x build's re-verification hook against silent capability drift.
- **Platform-comparison matrix** — 3 rows × 6 columns. Columns: Platform | Native-AI surface (2026) | API protocol | Sandbox access | `native_ai_path` default | Known research-blocked items. Rows: pipefy / wrike / ziflow.

**`### platform-pipefy` H3 — populated** (was: `(populated by 02-04-PLAN.md)` placeholder):

- `> **DESIGN-14:** ...` echo blockquote (D-35).
- 5-file `references/` ASCII tree at `dydx-delivery/skills/platform-pipefy/`.
- 7-row native-AI capability matrix: KB / Skills / MCP / IDP / Web Search / BYO-LLM all HIGH; KB content-upload via API LOW with inline `[OPEN: Phase 4 — Pipefy AI KB content-upload endpoint not externally verified per OPEN-01 — Phase 7 owner per CHANGE-04]`.
- API surface: GraphQL via Pipefy public API; `paginate_all(query, cursor_field)` helper for cursor pagination; cursor field names `[OPEN]` (Phase 2 owner); 2026 rate-limit currency `[OPEN]` (Phase 1/Phase 2 owner; documented historic ~5 req/sec per token); Bearer token auth; sandbox token distinct from production.
- Sandbox pattern: tenant per client; `pipefy_sandbox_pipe_id:` in `client_state.yaml` (DESIGN-29 forward).
- `native_ai_path: api` default for Behaviors/Skills (HIGH); `paste` fallback for KB content-upload until LOW [OPEN] resolves.
- Frontmatter contract: `tier_claims_last_verified: <ISO date>` + `platform: pipefy`.
- Cross-references: DESIGN-22 / DESIGN-23 / DESIGN-24 / DESIGN-26 (all anchor placeholders only — forward references populated in later waves) + AUDIT.md §AUDIT-04.1 (backward reference, populated).

**`### platform-wrike` H3 — populated** (was: `(populated by 02-04-PLAN.md)` placeholder):

- `> **DESIGN-15:** ...` echo blockquote (D-35).
- 5-file `references/` ASCII tree at `dydx-delivery/skills/platform-wrike/`.
- 4-row native-AI capability matrix: Copilot HIGH / 16 MCP tools HIGH / attach-doc-via-MCP MEDIUM / AI Studio knowledge-ingestion API LOW with `[OPEN: Phase 4 — Wrike AI Studio knowledge-ingestion API ... Phase 7 owner per CHANGE-04]`.
- API surface: REST; **CRITICAL** `host` persistence rule — `wrike_host:` MUST be persisted from OAuth token response and used as API base URL for every subsequent call (hardcoding `www.wrike.com` is the v0.3.0 bug per RESEARCH/PITFALLS — Wrike returns tenant-specific host per OAuth handshake; the persisted host differs per client). Rate limit `[OPEN]` (Phase 1/Phase 2 owner; historic ~100 req/min per user); OAuth token auth; sandbox space distinct from production.
- Sandbox pattern: space per client; `wrike_sandbox_space_id:` AND `wrike_host:` BOTH mandatory in `client_state.yaml` (DESIGN-29 forward).
- `native_ai_path: api` default for Copilot + 16 MCP tools (HIGH); `paste` fallback for AI Studio ingestion until LOW [OPEN] resolves.
- Frontmatter contract: `tier_claims_last_verified: <ISO date>` + `platform: wrike`.
- Cross-references: DESIGN-22 / DESIGN-23 / DESIGN-24 / DESIGN-26 / DESIGN-29 (all forward) + AUDIT.md §AUDIT-04.1 (backward).

**`### platform-ziflow` H3 — populated** (was: `(populated by 02-04-PLAN.md)` placeholder):

- `> **DESIGN-16:** ...` echo blockquote (D-35).
- 5-file `references/` ASCII tree at `dydx-delivery/skills/platform-ziflow/`.
- 4-row native-AI capability matrix: ReviewAI Checklists (Public Preview) HIGH / Change Verification (Coming Soon — announced not yet GA) MEDIUM / Brand Standards (Coming Soon — announced not yet GA) MEDIUM / ReviewAI knowledge-ingestion API LOW with `[OPEN: Phase 4 — Ziflow ReviewAI knowledge-ingestion API ... Phase 7 owner per CHANGE-04]`.
- API surface: REST; `wait_for_proof(proof_id, max_wait_s)` helper for read-after-create eventual consistency; consistency window `[OPEN]` (Phase 2 owner; conservative helper default 30s poll with 2s interval); API key in header; sandbox project distinct from production.
- Sandbox pattern: project per client; `ziflow_sandbox_project_id:` in `client_state.yaml` (DESIGN-29 forward).
- `native_ai_path: paste` DEFAULT (Checklists Public Preview is documented copy-paste path); `api` upgrade IF [OPEN] resolves an ingestion API.
- Frontmatter contract: `tier_claims_last_verified: <ISO date>` + `platform: ziflow`.
- Cross-references: DESIGN-22 / DESIGN-23 / DESIGN-24 / DESIGN-26 (all forward) + AUDIT.md §AUDIT-04.1 (backward).

## Tasks Executed

| Task | Name | Commit | Files |
|------|------|--------|-------|
| 1 | Write `## Platform skills` opening matrix + DESIGN-14 platform-pipefy subsection | e7495b3 | `.planning/DESIGN.md` |
| 2 | Write `### platform-wrike` (DESIGN-15) + `### platform-ziflow` (DESIGN-16) subsections + run structural-check | e14a8e4 | `.planning/DESIGN.md` |

## Inline `[OPEN]` Markers Added

7 new markers, all citing OPEN-01 + Phase-N owner per CHANGE-04 uniform format:

| # | Section | Marker text (truncated) | Owner phase |
|---|---------|-------------------------|-------------|
| 1 | platform-pipefy | Pipefy AI KB content-upload endpoint not externally verified | Phase 7 |
| 2 | platform-pipefy | Pipefy GraphQL pagination cursor field names need verification | Phase 2 |
| 3 | platform-pipefy | Pipefy 2026 rate-limit currency unverified (historic ~5 req/sec) | Phase 1/Phase 2 |
| 4 | platform-wrike | Wrike AI Studio knowledge-ingestion API not externally verified | Phase 7 |
| 5 | platform-wrike | Wrike 2026 rate-limit currency unverified (historic ~100 req/min) | Phase 1/Phase 2 |
| 6 | platform-ziflow | Ziflow ReviewAI knowledge-ingestion API not externally verified | Phase 7 |
| 7 | platform-ziflow | Ziflow read-after-create consistency window unverified (default 30s/2s) | Phase 2 |

Total inline `[OPEN: Phase 4]` count across DESIGN.md after Plan 02-04: 13 (1 preamble + 1 Deferred-section seed + 1 risk-multiplier + 3 inventory matrix abbreviated + 7 new platform markers). Floor was >= 8 — cleared with margin.

## Cross-AI Review Fixes Applied

| ID | Type | Fix |
|----|------|-----|
| HIGH #2 | Process / traceability | `02-04-SUMMARY.md` listed in plan frontmatter `files_modified` (this file). |
| MEDIUM #6 | Documentation alignment / forward-reference correctness | Cross-references to DESIGN-22 / DESIGN-23 / DESIGN-24 / DESIGN-26 explicitly noted as "forward reference, populated in Plan 02-0X" inline at every cite site. Acceptance criteria verified the anchor IDs are cited (`grep -qF 'DESIGN-22'` / `grep -qF 'DESIGN-26'` succeed) but did NOT assert those sections' body content exists at end of Wave 4 (deferred to Plan 02-10 Appendix B traceability synthesis). T-02-04-07 mitigation honoured — no false-fail on not-yet-written content. |

## Deviations from Plan

None. Plan executed exactly as written. Both tasks landed on first verification pass; no Rule 1/2/3 fixes required during execution. All acceptance criteria met on first run.

## Verification Snapshot

```
$ grep -cE '^> \*\*DESIGN-[0-9]{2}:\*\*' .planning/DESIGN.md
16
$ grep -cE '\[OPEN: Phase 4' .planning/DESIGN.md
13
$ awk '/^## Platform skills/,/^### platform-pipefy/' .planning/DESIGN.md | grep -cE '^\| (pipefy|wrike|ziflow) \|'
3
$ awk '/^### platform-pipefy/,/^### platform-wrike/' .planning/DESIGN.md | grep -cE '\[OPEN: Phase 4'
3
$ awk '/^### platform-wrike/,/^### platform-ziflow/' .planning/DESIGN.md | grep -cE '\[OPEN: Phase 4'
2
$ awk -v hdr='### platform-ziflow' 'f && /^### /{exit} f && /^## /{exit} f{print} index($0,hdr)==1 && /^### /{f=1}' .planning/DESIGN.md | grep -cE '\[OPEN: Phase 4'
2
$ grep -qF 'wrike_host' .planning/DESIGN.md && grep -qF 'wait_for_proof' .planning/DESIGN.md && grep -qF 'paginate_all' .planning/DESIGN.md && grep -qF 'tier_claims_last_verified' .planning/DESIGN.md && grep -qF 'native_ai_path' .planning/DESIGN.md && echo OK
OK
$ grep -qF 'Checklists Public Preview' .planning/DESIGN.md && grep -qF 'Change Verification' .planning/DESIGN.md && grep -qF 'Brand Standards' .planning/DESIGN.md && echo OK
OK
$ bash .planning/phases/02-design/scripts/design-structure-check.sh
FAIL: expected >= 30 'DESIGN-NN:' success-criteria echo blockquote lines (D-35), found 16
EXIT_CODE=1   # mid-phase state — Plans 02-05..02-09 close remaining 14 echoes
```

Structural-check assertion #4 short-circuits at 16/30 — exactly the predicted mid-phase invariant.

## Pointer

**Next:** Plan 02-05 (Wave 5) populates Stages 1-3 skills next (DESIGN-17 Kickoff dual-branch + DESIGN-18 Discovery refactor + DESIGN-19 SOW refactor). Running echo total after 02-05 = 19/30. Plans 02-06..02-09 close the remaining 11 echoes; Plan 02-10 lands the synthesis pass (Appendix B 30-row DESIGN-* traceability + closed `[OPEN]` enumeration + Executive Summary + glossary + preamble) and structural-check should exit 0 at the end of Wave 10.

## Self-Check: PASSED

Verified files exist:

- `.planning/DESIGN.md` — MODIFIED (populated `## Platform skills` body with framing + 3-row comparison matrix; populated `### platform-pipefy` H3 with DESIGN-14 echo + 5-file tree + 7-row native-AI matrix + GraphQL API surface + sandbox + native_ai_path + frontmatter contract; populated `### platform-wrike` H3 with DESIGN-15 echo + 5-file tree + 4-row native-AI matrix + REST API surface with CRITICAL host persistence rule + sandbox + native_ai_path + frontmatter; populated `### platform-ziflow` H3 with DESIGN-16 echo + 5-file tree + 4-row native-AI matrix + REST API surface with wait_for_proof helper + sandbox + native_ai_path + frontmatter).
- `.planning/ROADMAP.md` — MODIFIED (02-04 checkbox flipped → [x] complete 2026-05-09 + SUMMARY pointer; Progress table Phase 1 row 9/9 Complete; Phase 2 row 4/10 In progress).
- `.planning/phases/02-design/02-04-SUMMARY.md` — FOUND (this file).

Verified commits exist on `dydx-delivery-v2`:

- `e7495b3` — FOUND (Task 1: Platform skills opening matrix + DESIGN-14 platform-pipefy).
- `e14a8e4` — FOUND (Task 2: DESIGN-15 platform-wrike + DESIGN-16 platform-ziflow + structural-check run).

Structural-check script: exits 1 against the populated state (assertion #4 fails with `FAIL: expected >= 30 'DESIGN-NN:' ... found 16` — expected and correct mid-phase invariant; Plans 02-05..02-09 close the remaining 14 echoes).
