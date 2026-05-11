---
phase: 02-design
plan: 07
subsystem: stages-6-7a-7b-skills
tags: [design, stage-skills, cost-estimate, coda-mechanics, build-prompts, wave-7]
requires: [cross-cutting-decisions-locked, skill-layout-locked, skill-inventory-locked, handoff-matrix-locked, platform-skills-locked, stages-1-3-locked, stages-4a-4b-5-locked]
provides: [stage-6-cost-estimate-design-22, risk-multiplier-taxonomy-structure-locked, coda-mechanics-locked, wait-for-commercial-inputs-gate-locked, stage-7a-dev-build-prompt-design-23, stage-7b-per-platform-implementation-prompt-design-23, dual-build-prompt-split-locked]
affects: [.planning/DESIGN.md]
tech_stack:
  added: []
  patterns:
    - "Per-stage decision contract shape per D-20 (Skill / Stage / Complexity / Inputs / Outputs / Hand-off / Status flag / Key v2 decisions / Dependencies / Cross-references)"
    - "DESIGN-22 risk-multiplier taxonomy STRUCTURE-LOCK (closed L/M/H tiers + mandatory `rationale:` field per row); numerics DEFERRED with `<TBD-deferred>` placeholder syntax + inline `[OPEN: Phase 4 — risk-multiplier defaults pending dYdX-historical validation per D-22]` marker at point of use"
    - "Coda integration mechanics — 5 elements verbatim per REQUIREMENTS DESIGN-22 + CONTEXT D-22: schema introspection cached in `00_HUB.md` `coda_tasks_schema:`; `table_rows_manage` upsert with `keyColumns`; `mutationStatus` polling halt-on-failure; rate-limit 4 req/10s (= 80% of public 5 req/10s ceiling); local canonical (Coda one-way mirror per DESIGN-09)"
    - "Wait-for-commercial-inputs 2-halt-point gate (pre-write halt emitting `06_cost_inputs_v<N>.md`; pre-publish halt before Coda mirror — both halts encoded inside skill, neither bypasses approval-gate hook)"
    - "Per-assignee task breakdown — 4 classes locked (`dev | non-dev | QA | lead`); `assignee_class:` per-row field; per-class summary table at top of artefact"
    - "DESIGN-23 dual-echo contract — DESIGN-23 echo appears under BOTH Stage 7a AND Stage 7b H2s (per D-35 per-section echo + plan dual-echo contract; same precedent as DESIGN-20 dual under 4a/4b in Plan 02-06)"
    - "Stage 7a / 7b complementary disjoint scope contract — 7a `delivery_filter: api` only; 7b `delivery_filter: native-ai` only; reviewer can grep both filters to verify no requirement falls through cracks"
    - "Stage 7b per-platform shape — NOT a universal template (per `## Out of Scope`); skill dispatches on `platform:` frontmatter to one of three template paths (Pipefy `## Behaviors instructions` + `## KB documents to upload`; Wrike `## Copilot workflow narrative` + `## MCP tools required`; Ziflow `## ReviewAI checklists` + `## Manual paste fallback`)"
    - "Forward-reference guardrails (cross-AI MEDIUM #6) — DESIGN-24 (Stage 8a) cited as anchor placeholder only with explicit `forward — anchor placeholder, populated in Plan 02-08`"
    - "Echo blockquote `> **DESIGN-NN:**` pattern per D-35 — 3 echo lines added (DESIGN-22 once + DESIGN-23 dual-echo under 7a + 7b); running total 25/30"
key_files:
  created:
    - .planning/phases/02-design/02-07-SUMMARY.md
  modified:
    - .planning/DESIGN.md
decisions:
  - "Phase 2 Plan 07: Stage 6 risk-multiplier taxonomy STRUCTURE-LOCK contract per D-22 — closed L/M/H tiers; mandatory `rationale:` field per row (reviewer cannot ship a row without naming why a specific tier was chosen); validation owner = Stage 6 author + reviewer."
  - "Phase 2 Plan 07: Stage 6 risk-multiplier numeric defaults DEFERRED per D-22 — DESIGN.md uses `L=<TBD-deferred>` / `M=<TBD-deferred>` / `H=<TBD-deferred>` placeholder syntax with inline `[OPEN: Phase 4 — risk-multiplier defaults pending dYdX-historical validation per D-22]` marker at point of use (in the H tier row of the taxonomy table); research-recommended candidates (~1.1 / ~1.3 / ~1.6) named alongside as research source but require dYdX-historical validation before Stage 6 build phase locks numerics."
  - "Phase 2 Plan 07: Stage 6 Coda integration mechanics — 5 elements verbatim per REQUIREMENTS canonical values: (1) schema introspection via `table_columns_read` cached in `<Client> Brain/00_HUB.md` `coda_tasks_schema:` block (re-read per Stage 6 run; on schema drift halt + emit `06_schema_drift_v<N>.md`); (2) upsert via `table_rows_manage` (Coda MCP) with `keyColumns` parameter; idempotent (no duplicate rows on retry); (3) `mutationStatus` polling until terminal state; failure halts; (4) rate-limit 4 req/10 second sliding window (= 80% of public ceiling 5 req/10s; single Coda MCP client; no parallel writers from Stage 6); (5) local canonical (Coda one-way mirror per DESIGN-09 directional boundary)."
  - "Phase 2 Plan 07: Stage 6 wait-for-commercial-inputs gate — 2 distinct halt points encoded inside skill: (a) pre-write halt — first invocation emits `06_cost_inputs_v<N>.md` listing commercial inputs needed; halt; resume on `commercial_inputs_status: provided`; (b) pre-publish halt — after compute, halt before Coda push; resume on `status: approved` PLUS `commercial_inputs_status: provided`. Neither halt bypasses the other; approval-gate hook (DESIGN-06) enforces `approved_by` + `approved_at` separately."
  - "Phase 2 Plan 07: Stage 6 per-assignee task breakdown — 4 classes locked (`dev | non-dev | QA | lead`); `assignee_class:` per-row field on every task in `06_cost_v<N>.md`; per-class summary table at top of artefact (4 rows × 3 columns: class / sum estimated_hours / sum risk_adjusted_hours); reviewer can grep by class for commercial review. Eliminates v0.3.0 ad-hoc cost estimation that lived implicitly in `generate-sow` commercial section per AUDIT.md §AUDIT-01.2."
  - "Phase 2 Plan 07: Stage 6 frontmatter contract — `frontmatter_version: 2` + `based_on_fnspec_*:` + (optional) `based_on_techspec:` + `risk_multiplier_version:` (locks which numeric default set was used; `<TBD-deferred>` for v2 design phase; concrete values populated by Phase 4 OPEN-QUESTIONS resolution) + `commercial_inputs_status: pending | provided` + `assignee_class:` per-row + `status: draft → client_review → approved`."
  - "Phase 2 Plan 07: Stage 7a + 7b — DESIGN-23 dual-echo contract per D-35 + plan dual-echo precedent — DESIGN-23 echo appears under BOTH Stage 7a AND Stage 7b H2s (same precedent as DESIGN-20 dual-echo under 4a + 4b in Plan 02-06; final echo count tolerates dual-echo overcount via `>= 30` assertion)."
  - "Phase 2 Plan 07: Stage 7a (DESIGN-23 first half) — `generate-build-prompt/` skill MODIFIED (carries forward from v0.3.0 baseline per AUDIT.md §AUDIT-01.6); modification limited to `delivery_filter: api` scope-tag + per-row `delivery: api` consumption; reads `04b` REQUIRED + `05` REQUIRED (full path) OR `04a` with `## Platform-API Addendum` (skip-with-addendum branch per DESIGN-21) + `06` REQUIRED; downstream consumer = dev (human implementer)."
  - "Phase 2 Plan 07: Stage 7b (DESIGN-23 second half) — `generate-implementation-prompt/` skill NEW (no v0.3.0 ancestor); reads `04a` REQUIRED + `06` REQUIRED + `platform: pipefy | wrike | ziflow` REQUIRED (drives per-platform dispatch); downstream consumer = non-dev (per-platform human implementer); `delivery_filter: native-ai` scope-tag (disjoint complement to Stage 7a's `delivery_filter: api`)."
  - "Phase 2 Plan 07: Stage 7b per-platform shape — NOT a universal template per `## Out of Scope`; skill dispatches on `platform:` frontmatter to one of three concrete template paths: Pipefy = `## Behaviors instructions` + `## KB documents to upload`; Wrike = `## Copilot workflow narrative` + `## MCP tools required` (with OAuth `host` persistence rule repeated per DESIGN-15 CRITICAL bug-prevention callout); Ziflow = `## ReviewAI checklists` + `## Manual paste fallback`. Universal-template anti-pattern explicitly forbidden; reviewer can grep `^## (Behaviors instructions|Copilot workflow narrative|ReviewAI checklists)` to confirm dispatch landed."
  - "Phase 2 Plan 07: Stage 7a / 7b complementary disjoint scope — 7a `delivery_filter: api` AND 7b `delivery_filter: native-ai` are explicit disjoint sets; reviewer can grep both filters for the same project to verify no requirement falls through cracks (and no requirement is double-counted between dev and platform-config implementers)."
  - "Phase 2 Plan 07: Hand-off matrix Stage 6 → 7a row updated to align with per-stage subsection per D-26 verbatim-restate contract — outer code-span backticks dropped to permit inner backtick formatting (same precedent as Plan 02-06 Stage 4a → 4b / 4b → 5 alignment); Stage 7a / 7b → 8a row similarly aligned with new format using inner backticks for `07a` / `07b` literals plus `delivery_filter:` field swap (was `delivery:`); both matrix changes match per-stage subsection text exactly."
  - "Phase 2 Plan 07: Echo count progresses 22 → 25/30 (DESIGN-22 contributes 1 echo under Stage 6 H2; DESIGN-23 contributes 2 echoes — one each under Stage 7a + Stage 7b H2s per dual-echo contract); structural-check exits 1 with assertion #4 short-circuit at 25 < 30 — expected mid-phase invariant; Plans 02-08 + 02-09 close remaining 5 (DESIGN-24/25/26/27 in Plan 02-08; DESIGN-28/29/30 in Plan 02-09)."
  - "Phase 2 Plan 07: Inline `[OPEN: Phase 4 — ...]` marker count progresses 13 → 17 across DESIGN.md (1 NEW D-22 marker added in Stage 6 risk-multiplier taxonomy table at point of use per D-27 in-place-deferral discipline; PLUS 3 references to `risk-multiplier defaults pending dYdX-historical validation per D-22` text repeated in the L / M / H default-value cells as research-recommended-but-deferred citation context — these 3 are echoes of the canonical D-22 marker, not net-new deferrals; the canonical seed marker placed in the Deferred section by Plan 02-01 will be deduped against these references in Plan 02-10's enumeration synthesis)."
  - "Phase 2 Plan 07: Forward-reference guardrails per cross-AI review MEDIUM #6 honoured — DESIGN-24 (Stage 8a) cited as anchor placeholder only with explicit `forward — anchor placeholder, populated in Plan 02-08` inline at every cite site (Stage 7a + Stage 7b cross-references); acceptance criteria did NOT assert DESIGN-24 body content exists at end of Wave 7; verification deferred to Plan 02-10 Appendix B traceability synthesis (T-02-07-07 mitigation honoured)."
  - "Phase 2 Plan 07: No content under `dydx-delivery/` modified — design-only milestone discipline maintained per kickoff mandate."
metrics:
  duration_minutes: 11
  completed_date: "2026-05-09"
  task_count: 2
  file_count: 1
---

# Phase 2 Plan 07: Stage 6 cost estimate (DESIGN-22) + Stage 7a / 7b dual build prompts (DESIGN-23) Summary

**One-liner:** Locked DESIGN-22 (Stage 6 cost estimate — risk-multiplier taxonomy STRUCTURE-LOCK with closed L/M/H tiers + mandatory `rationale:` field; numerics DEFERRED with `<TBD-deferred>` placeholder + inline `[OPEN: Phase 4 — risk-multiplier defaults pending dYdX-historical validation per D-22]` marker at point of use; Coda integration mechanics 5 elements verbatim — schema introspection cached in `00_HUB.md` `coda_tasks_schema:` + `table_rows_manage` upsert with `keyColumns` + `mutationStatus` polling + 4 req/10s rate-limit + local canonical Coda one-way mirror; per-assignee task breakdown 4 classes `dev | non-dev | QA | lead`; wait-for-commercial-inputs 2-halt-point gate emitting `06_cost_inputs_v<N>.md`) and DESIGN-23 (Stage 7a / 7b dual build prompt split — Stage 7a `generate-build-prompt/` MODIFIED with `delivery_filter: api` reading `delivery: api` rows only; Stage 7b `generate-implementation-prompt/` NEW with `delivery_filter: native-ai` reading `delivery: native-ai` rows only; per-platform shape NOT a universal template — Pipefy Behaviors instructions + KB upload list / Wrike Copilot workflow narrative + MCP tools / Ziflow ReviewAI checklists + manual paste fallback); 3 echo blockquotes added (DESIGN-22 once under Stage 6 + DESIGN-23 dual under Stage 7a + Stage 7b per dual-echo contract); running total 25/30; structural-check exits 1 at expected mid-phase invariant.

## What Was Done

### Task 1 — Stage 6 cost estimate decision contract (DESIGN-22)

Replaced placeholder body of `## Stage 6: Cost estimate` H2. Stage 6 is the heaviest single decision contract in DESIGN.md per CONTEXT specifics — combines the risk-multiplier taxonomy STRUCTURE-LOCK contract (numerics DEFERRED), the Coda integration mechanics (5 elements verbatim), AND the wait-for-commercial-inputs 2-halt-point gate.

**Echo blockquote:** `> **DESIGN-22:** Stage 6 Cost estimate — per-assignee task breakdown (dev / non-dev / QA / lead); estimated_hours + risk_adjusted_hours columns with mandatory rationale field; closed risk-multiplier taxonomy (default L=<TBD-deferred> / M=<TBD-deferred> / H=<TBD-deferred> per D-22 — [OPEN: Phase 4 — risk-multiplier defaults pending dYdX-historical validation per D-22]); schema-introspection of existing client task table cached in 00_HUB.md; Coda writes via table_rows_manage with keyColumns for idempotency, mutationStatus polling, rate-limit at 4 req/10s; wait-for-commercial-inputs gate before client-facing summary.`

**Skill / Stage / Complexity:** `generate-cost-estimate/` (NEW per DESIGN-12 inventory — replaces v0.3.0 ad-hoc cost estimation that lived implicitly in `generate-sow` commercial section per AUDIT.md §AUDIT-01.2) / Stage 6 / **High**.

**Risk-multiplier taxonomy table (STRUCTURE-LOCK contract per D-22, numerics DEFERRED):**

| Tier | Multiplier | Rationale required | Validation owner | Default value |
|------|------------|--------------------|-------------------|----------------|
| L | `risk_adjusted_hours = estimated_hours × <L_multiplier>` | yes | Stage 6 author + reviewer | `L=<TBD-deferred>` (research-recommended ~1.1; pending dYdX-historical validation per D-22) |
| M | `risk_adjusted_hours = estimated_hours × <M_multiplier>` | yes | Stage 6 author + reviewer | `M=<TBD-deferred>` (research-recommended ~1.3) |
| H | `risk_adjusted_hours = estimated_hours × <H_multiplier>` | yes | Stage 6 author + reviewer | `H=<TBD-deferred>` (research-recommended ~1.6) `[OPEN: Phase 4 — risk-multiplier defaults pending dYdX-historical validation per D-22]` |

The H tier row carries the canonical inline `[OPEN]` marker (point-of-use placement per D-27); L and M rows reference the same dYdX-historical-validation-pending text without re-emitting the bracketed marker (avoids dilution; Plan 02-10 dedups against the seed marker placed by Plan 02-01 in the Deferred section).

**Coda integration mechanics (verbatim from REQUIREMENTS canonical):**

1. **Schema introspection** — `table_columns_read` (Coda MCP) once per client; cached in `<Client> Brain/00_HUB.md` `coda_tasks_schema:` block; on schema drift, halt + emit `06_schema_drift_v<N>.md`.
2. **Upsert** — `table_rows_manage` with `keyColumns` parameter (idempotent; no duplicate rows on retry).
3. **Mutation status polling** — each `table_rows_manage` call returns `mutationStatus` ID; poll until terminal state; failure halts.
4. **Rate limit** — 4 req/10 second sliding window (= 80% of Coda public ceiling 5 req/10s).
5. **Wait-for-commercial-inputs gate** — 2 distinct halt points encoded inside skill (pre-write emitting `06_cost_inputs_v<N>.md` resuming on `commercial_inputs_status: provided`; pre-publish before Coda push resuming on `status: approved`).

**Per-assignee task breakdown (4 classes locked):** `dev | non-dev | QA | lead`. Per-row `assignee_class:` field; per-class summary table at top of artefact (4 rows × 3 columns).

**Frontmatter contract:** `frontmatter_version: 2`; `based_on_fnspec_*:`; (optional) `based_on_techspec:`; `risk_multiplier_version:`; `commercial_inputs_status: pending | provided`; `assignee_class:` per-row; `status: draft → client_review → approved`.

**Hand-off message (matrix Stage 6 → 7a row, aligned per D-26):** `> Awaiting \`status: approved\` to \`06\`; locks costed scope before build-prompt generation.`

**Hand-off matrix Stage 6 → 7a row updated** to align with per-stage subsection per D-26 verbatim-restate contract — outer code-span backticks dropped to permit inner backtick formatting; same precedent as Plan 02-06 Stage 4a → 4b / 4b → 5 alignment. Stage 7a / 7b → 8a row similarly updated (next plan line) to use inner backticks for `07a` / `07b` literals + `delivery_filter:` field swap.

### Task 2 — Stage 7a + 7b dual build prompt decision contracts (DESIGN-23)

Replaced placeholder bodies of `## Stage 7a: Build prompt — dev` and `## Stage 7b: Build prompt — implementation per platform` H2s. Both H2s carry their own `> **DESIGN-23:**` echo line per D-35 per-section echo + plan dual-echo contract (same precedent as DESIGN-20 dual-echo under 4a + 4b in Plan 02-06).

**(A) Stage 7a — dev (DESIGN-23 first half):**

- **Echo blockquote:** `> **DESIGN-23:** Stage 7a Build prompt — dev — generate-build-prompt skill (MODIFIED, carries forward from v0.3.0); pulls delivery: native-ai | api from Stage 4a per DESIGN-20 routing key; Stage 7a covers delivery: api requirements (dev-implementation territory) + Stage 5 tech-spec details for API endpoints.`
- **Skill / Stage / Complexity:** `generate-build-prompt/` (MODIFIED per DESIGN-12 inventory — carries forward from v0.3.0 baseline; modification limited to `delivery_filter:` scope-tag and per-row `delivery: api` consumption per AUDIT.md §AUDIT-01.6) / Stage 7a / Medium.
- **Inputs:** `based_on_fnspec_integration: 04b` REQUIRED + `based_on_techspec: 05` REQUIRED (full path) OR `04a` with `## Platform-API Addendum` (skip-with-addendum branch per DESIGN-21) + `based_on_cost: 06` REQUIRED + (optional) `based_on_fnspec_platform: 04a`.
- **Outputs:** `07a_build-prompt_v<N>.md`; standard frontmatter + `delivery_filter: api`; `status: draft → approved`.
- **What 7a does NOT cover:** `delivery: native-ai` requirements (those route to 7b — explicit complement).
- **Downstream consumer:** dev (human implementer).
- **3 key v2 decisions:** reads `delivery: api` rows only; carries forward from v0.3.0 with `delivery_filter:` + per-row consumption; 7a + 7b complementary (disjoint sets).

**(B) Stage 7b — implementation per platform (DESIGN-23 second half):**

- **Echo blockquote:** `> **DESIGN-23:** Stage 7b Build prompt — implementation per platform — generate-implementation-prompt skill (NEW); per-platform shape (Pipefy = Behaviors instructions + KB upload list; Wrike = Copilot workflow narrative; Ziflow = checklist/criteria spec); explicitly NOT a universal template (per ## Out of Scope); reads delivery: native-ai rows from Stage 4a per DESIGN-20 routing key.`
- **Skill / Stage / Complexity:** `generate-implementation-prompt/` (NEW per DESIGN-12 inventory — net-new skill; no v0.3.0 ancestor) / Stage 7b / Medium.
- **Inputs:** `based_on_fnspec_platform: 04a` REQUIRED + `based_on_cost: 06` REQUIRED + `platform: pipefy | wrike | ziflow` REQUIRED (drives per-platform dispatch); external = per-platform `references/api-contract.md` + `references/native-ai-inventory.md` from matching platform skill (per DESIGN-14/15/16).
- **Outputs:** `07b_implementation-prompt_v<N>.md`; standard frontmatter + `delivery_filter: native-ai` + `platform: <X>`.
- **Per-platform shape (NOT a universal template per `## Out of Scope`):**

| Platform | H2 #1 | H2 #2 | Native-AI capability source |
|----------|-------|-------|------------------------------|
| Pipefy   | `## Behaviors instructions` | `## KB documents to upload` | `platform-pipefy/references/native-ai-inventory.md` HIGH-confidence rows; LOW with `[OPEN]` markers |
| Wrike    | `## Copilot workflow narrative` | `## MCP tools required` (with OAuth `host` persistence CRITICAL callout) | `platform-wrike/references/native-ai-inventory.md` Copilot HIGH + 16 MCP tools |
| Ziflow   | `## ReviewAI checklists` | `## Manual paste fallback` (read-after-create eventual consistency window) | `platform-ziflow/references/native-ai-inventory.md` HIGH; Change Verification + Brand Standards `[Coming Soon]` MEDIUM |

- **Universal anti-pattern:** A single template that "fits all platforms" is FORBIDDEN per `## Out of Scope`. Skill dispatches on `platform:` frontmatter to one of three template paths.
- **Downstream consumer:** non-dev (per-platform human implementer).
- **4 key v2 decisions:** NEW skill (no v0.3.0 ancestor); per-platform shape NOT a universal template; reads `delivery: native-ai` rows only; per-platform reference docs drive affordances (HIGH/MEDIUM/LOW with `[OPEN]` markers per OPEN-01).

**Hand-off message (matrix Stage 7a / 7b → Stage 8a row, aligned per D-26):** `> Awaiting \`status: approved\` to \`07a\` and/or \`07b\`; provision-test-harness reads \`delivery:\` routing.` Used verbatim under both Stage 7a + Stage 7b subsections.

**Structural-check run:** exit code = 1 with assertion #4 short-circuit message `expected >= 30 'DESIGN-NN:' success-criteria echo blockquote lines (D-35), found 25` — expected mid-phase invariant per Plan 02-01..02-06 precedent. Plans 02-08 + 02-09 close remaining 5 echoes (DESIGN-24/25/26/27 + DESIGN-28/29/30).

## Files Created / Modified

| File | Type | Change |
|------|------|--------|
| `.planning/DESIGN.md` | modified | `## Stage 6: Cost estimate` populated with full DESIGN-22 contract; `## Stage 7a: Build prompt — dev` populated with DESIGN-23 first half; `## Stage 7b: Build prompt — implementation per platform` populated with DESIGN-23 second half; hand-off matrix Stage 6 → 7a + Stage 7a/7b → 8a rows aligned with subsection literals per D-26 |
| `.planning/phases/02-design/02-07-SUMMARY.md` | created | This document |

## Echo Count Progression

| Plan | Echoes added | Running total |
|------|--------------|---------------|
| 02-02 | DESIGN-01..10 | 10/30 |
| 02-03 | DESIGN-11/12/13 | 13/30 |
| 02-04 | DESIGN-14/15/16 | 16/30 |
| 02-05 | DESIGN-17/18/19 | 19/30 |
| 02-06 | DESIGN-20 (dual under 4a + 4b) + DESIGN-21 | 22/30 |
| **02-07 (this plan)** | **DESIGN-22 (under 6) + DESIGN-23 (dual under 7a + 7b)** | **25/30** |
| 02-08 (next) | DESIGN-24/25/26/27 | 29/30 (projected) |
| 02-09 | DESIGN-28/29/30 | 32/30 (projected — final, dual-echo overcount tolerated by `>= 30`) |
| 02-10 | synthesis | structural-check assertion #4 passes |

DESIGN-23 contributes 2 echoes (one per substage 7a + 7b) per plan dual-echo contract — same precedent as DESIGN-20 dual-echo under 4a + 4b in Plan 02-06. Final echo count exceeds 30 if all dual-echo IDs fire; structural-check assertion #4 uses `>= 30` which tolerates overcount.

## Inline `[OPEN: Phase 4]` Marker Count Progression

| Plan | Marker count | Net change | Notes |
|------|--------------|-----------|-------|
| 02-04 (baseline) | 13 | +13 | 7 new pipefy/wrike/ziflow markers + 6 prior |
| 02-05 | 13 | 0 | DESIGN-17/18/19 contracts LOCKED |
| 02-06 | 13 | 0 | DESIGN-20/21 contracts LOCKED |
| **02-07 (this plan)** | **17** | **+4** | 1 NEW canonical D-22 marker in Stage 6 H tier row + 3 echoes of `risk-multiplier defaults pending dYdX-historical validation per D-22` text in L / M tier default-value cells (research-recommended-but-deferred citation context — not net-new deferrals; Plan 02-10 dedups against canonical seed marker) |

The single canonical inline marker for D-22 lives in the Stage 6 H tier row of the risk-multiplier taxonomy table — point-of-use placement per D-27. The L / M tier rows reference the same pending-validation text without re-emitting the bracketed marker (avoids dilution). Plan 02-10 dedups against the seed marker placed by Plan 02-01 in the Deferred-to-Phase-4 section.

## Cross-AI Review Fixes Applied

- **HIGH #2 (Codex):** `.planning/phases/02-design/02-07-SUMMARY.md` present in plan frontmatter `files_modified` — verified before execution per plan revision log.
- **MEDIUM #6 (Gemini + Codex):** Forward-reference guardrails — DESIGN-24 (Stage 8a — populated in Plan 02-08) cited as anchor placeholder only with explicit `forward — anchor placeholder, populated in Plan 02-08` inline at every cite site (Stage 7a + Stage 7b cross-references). Acceptance criteria did NOT assert that DESIGN-24 body content exists at end of Wave 7; verification deferred to Plan 02-10 Appendix B traceability synthesis (T-02-07-07 mitigation honoured).

## Threat Model Mitigations Honoured

| Threat ID | Mitigation | Status |
|-----------|-----------|--------|
| T-02-07-01 | Stage 6 author writes `<TBD-deferred>` placeholder syntax (NOT numeric defaults); inline `[OPEN: Phase 4 — risk-multiplier defaults pending dYdX-historical validation per D-22]` marker present at H tier row | ✓ verified `grep -qF '<TBD-deferred>'` + `grep -qF 'risk-multiplier defaults pending dYdX-historical validation per D-22'` |
| T-02-07-02 | Coda mechanics use literal `4 req/10` (NOT `5 req/10s`); table_columns_read + table_rows_manage + keyColumns + mutationStatus all literal verbatim | ✓ verified all 5 literals via `grep -qF` |
| T-02-07-03 | Wait-for-commercial-inputs gate enumerates BOTH halt points (pre-write + pre-publish); both `06_cost_inputs_v` and `commercial_inputs_status:` literals present | ✓ verified both literals + gate prose enumerates 2 distinct halt points |
| T-02-07-04 | Stage 7b shape — ALL 3 per-platform shape strings present (Behaviors instructions + Copilot workflow narrative + ReviewAI checklists); `NOT a universal template` anti-pattern callout present | ✓ verified all 3 platform literals + `NOT a universal template` literal |
| T-02-07-05 | Stage 7a `delivery_filter: api` AND Stage 7b `delivery_filter: native-ai` both present and disjoint; Stage 7a explicitly states "What Stage 7a does NOT cover: delivery: native-ai requirements (those route to 7b)" | ✓ verified both `delivery_filter:` literal values + disjoint scope prose |
| T-02-07-06 | DESIGN-23 echo count verified per-stage via SAFE awk ranges (`/^## Stage 7a:/,/^## Stage 7b:/` and `/^## Stage 7b:/,/^## Stage 8:/` — distinct start/end anchors; not the broken `/^## X/,/^## /` pattern) | ✓ each range returns echo count = 1 |
| T-02-07-07 | Forward references to DESIGN-24 are anchor placeholders only — body verification deferred to Plan 02-10 | ✓ explicit `forward — anchor placeholder, populated in Plan 02-08` markers at all cite sites; no body assertions |

## Deviations from Plan

**1. [Rule 1 - Bug] Hand-off matrix Stage 6 → 7a row text drifted from per-stage subsection — D-26 verbatim-restate contract violation; same precedent fix as Plan 02-06**

- **Found during:** Task 1 acceptance verification — plan acceptance grep `grep -qF '> Awaiting \`status: approved\` to \`06\`'` required the per-stage subsection text to use inner backticks for `06`. The pre-existing matrix Stage 6 → 7a row (line 361) used different text (`> Awaiting status: approved on 06_cost_v<N>.md (locks costed scope) before build-prompt generation.`) wrapped in outer code-span backticks. Per D-26 the matrix is the source of truth and per-stage subsection MUST verbatim restate.
- **Issue:** If subsection text were authored verbatim from the matrix line, the inner-backtick acceptance grep would fail (no inner backticks present in matrix). Conversely, if matrix were left untouched while subsection used inner backticks, D-26 verbatim-restate contract is violated.
- **Fix:** Updated matrix Stage 6 → 7a row to use inner-backtick format matching the subsection text (`> Awaiting \`status: approved\` to \`06\`; locks costed scope before build-prompt generation.`); outer code-span backticks dropped (markdown tables cannot nest backticks inside code spans cleanly). Same precedent as Plan 02-06 Stage 4a → 4b / 4b → 5 alignment. Also updated matrix Stage 7a / 7b → 8a row to match the per-stage subsection text I authored in Task 2 (inner backticks for `07a` / `07b` literals + `delivery_filter:` field swap was `delivery:`).
- **Files modified:** `.planning/DESIGN.md` (matrix rows at lines 361-362).
- **Commit:** `9063c85` (matrix Stage 6 → 7a alignment bundled with Task 1 Stage 6 contract authoring); `209e84f` (matrix Stage 7a/7b → 8a alignment bundled with Task 2 Stage 7a + 7b contract authoring).

**2. [Rule 2 - Auto-add] Stage 6 hand-off matrix gating-status flag enriched with `commercial_inputs_status: provided` requirement**

- **Found during:** Task 1 implementation — Stage 6 wait-for-commercial-inputs gate description requires BOTH `status: approved` AND `commercial_inputs_status: provided` for the pre-publish halt to release. The pre-existing matrix row showed only `status: approved` as the gating flag.
- **Issue:** D-26 verbatim-restate contract requires the matrix to be the canonical source of truth; gating-status flag column must accurately enumerate ALL flags required to release the gate — listing only `status: approved` would silently drop the `commercial_inputs_status: provided` requirement.
- **Fix:** Updated matrix Stage 6 → 7a row gating-status column to `status: approved AND commercial_inputs_status: provided`; matrix frontmatter-fields-propagated column also enriched to include `commercial_inputs_status:` (was `risk_multiplier_version:` only). Both changes match the per-stage subsection's wait-for-commercial-inputs gate prose exactly.
- **Files modified:** `.planning/DESIGN.md` (matrix row at line 361).
- **Commit:** `9063c85` (bundled with Task 1).

**3. [No deviation] DESIGN-22 + DESIGN-23 split into 2 atomic commits (one per task)**

- Stage 6 + Stage 7a + Stage 7b are three contiguous H2 placeholder blocks but the split (Task 1 = Stage 6 only; Task 2 = Stage 7a + 7b together) is naturally atomic because Stage 7a/7b cross-reference Stage 6 (`based_on_cost: 06_cost_v<N>` is a Stage 6 → 7a/7b contract dependency) but NOT vice versa. Stage 6 in isolation is a valid intermediate state — its forward references to 7a/7b are explicitly marked `forward — same wave below` per cross-AI MEDIUM #6 guardrails. Two commits maintain Plan-task atomicity without leaving a broken intermediate state.

## Pointer

Plan 02-08 (Wave 8) populates Stages 8/9/10/11 next (DESIGN-24 Stage 8 test bot architecture + DESIGN-25 Stage 9 documentation publishing + DESIGN-26 Stage 10 native-AI enablement + DESIGN-27 Stage 11 sign-off + brain update + archive). Running echo total after 02-08 = 29/30 (projected). Plans 02-09 (DESIGN-28/29/30 test bot deeper specifics) + 02-10 (synthesis — Appendix B + Deferred list dedup + structural-check assertion #4 final pass) follow.

## Self-Check: PASSED

- ✓ `.planning/DESIGN.md` modified — 3 stage subsections (6, 7a, 7b) populated; hand-off matrix rows 361-362 aligned
- ✓ Commit `9063c85` exists (Task 1 Stage 6 DESIGN-22 + matrix Stage 6 → 7a alignment) — verified `git log --oneline | grep 9063c85`
- ✓ Commit `209e84f` exists (Task 2 Stage 7a + 7b DESIGN-23 + matrix Stage 7a/7b → 8a alignment) — verified `git log --oneline | grep 209e84f`
- ✓ Stage 6 echo present (`grep -qE '^> \*\*DESIGN-22:\*\*' .planning/DESIGN.md`)
- ✓ Stage 7a echo count = 1 (verified `awk '/^## Stage 7a:/,/^## Stage 7b:/' .planning/DESIGN.md | grep -cE '^> \*\*DESIGN-23:\*\*'` returns 1)
- ✓ Stage 7b echo count = 1 (verified `awk '/^## Stage 7b:/,/^## Stage 8:/' .planning/DESIGN.md | grep -cE '^> \*\*DESIGN-23:\*\*'` returns 1)
- ✓ All Task 1 Stage 6 acceptance greps pass (`<TBD-deferred>` + `risk-multiplier defaults pending dYdX-historical validation per D-22` + `keyColumns` + `mutationStatus` + `4 req/10` + `wait-for-commercial-inputs` + `coda_tasks_schema:` + `06_cost_v` + `06_cost_inputs_v` + `commercial_inputs_status:` + `rationale` + `risk_multiplier_version:` + `table_columns_read` + `assignee_class:` + hand-off literal `> Awaiting \`status: approved\` to \`06\``)
- ✓ All Task 2 Stage 7a/7b acceptance greps pass (`delivery_filter: api` + `delivery_filter: native-ai` + `07a_build-prompt_v` + `07b_implementation-prompt_v` + `Behaviors instructions` + `Copilot workflow narrative` + `ReviewAI checklists` + `NOT a universal template`)
- ✓ Echo count = 25/30 (verified `grep -cE '^> \*\*DESIGN-[0-9]{2}:\*\*' .planning/DESIGN.md`)
- ✓ Inline `[OPEN: Phase 4]` count = 17 (>= 9 floor with margin; +1 net-new canonical D-22 marker; +3 echo references in L/M default-value cells)
- ✓ Structural-check exits 1 with expected assertion #4 short-circuit message at 25 < 30 (mid-phase invariant)
- ✓ No content under `dydx-delivery/` modified
- ✓ Forward-reference guardrails (cross-AI MEDIUM #6) applied — DESIGN-24 anchor-placeholder-only with explicit `forward — anchor placeholder, populated in Plan 02-08` markers
