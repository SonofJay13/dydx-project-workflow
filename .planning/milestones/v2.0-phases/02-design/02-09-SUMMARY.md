---
phase: 02-design
plan: 09
subsystem: test-bot-architecture
tags: [design, test-bot-architecture, tier-boundary, client-state-schema, drift-detection, wave-9]
requires: [cross-cutting-decisions-locked, skill-layout-locked, skill-inventory-locked, handoff-matrix-locked, platform-skills-locked, stages-1-3-locked, stages-4a-4b-5-locked, stages-6-7a-7b-locked, stages-8-9-10-11-locked]
provides: [design-28-tier-boundary-locked, design-29-client-state-schema-locked, design-30-drift-detection-contract-locked, structural-check-passes]
affects: [.planning/DESIGN.md]
tech_stack:
  added: []
  patterns:
    - "DESIGN-28 tier-1 / tier-2 boundary table (Tier / Role / Owner / Asserts / Authoring / Examples) — 6-column shape with Tier-1 = Python deterministic HUMAN-AUTHORED + Tier-2 = AI orchestrator AI-GENERATED"
    - "DESIGN-28 Out-of-Scope citation in Tier-1 Authoring cell — verbatim 'Generating Python tier-1 tests from natural language alone' anti-feature reference"
    - "DESIGN-28 mixed-layer cases — `layer: mixed` flagged for human design; silent assignment FORBIDDEN"
    - "DESIGN-28 worked TC classification example (Pipefy card-create) — tier-1 status_code/id/regex + tier-2 AI Agent log interpretation with failure_class enum"
    - "DESIGN-29 client_state.yaml skeleton — 7 top-level keys (client / client_state_version / last_provisioned_at / sandbox / fixtures / integration_toggles / last_known_schema / test_cases)"
    - "DESIGN-29 sandbox 4-platform sub-blocks — pipefy / wrike / ziflow / coda (Coda CRIT-5 fix cited inline)"
    - "DESIGN-29 wrike.host: field PERSISTED from OAuth token response per DESIGN-15 — CRITICAL bug-prevention against hardcoded www.wrike.com regression"
    - "DESIGN-29 3 worked per-platform examples with concrete sandbox IDs (pipe-12345 / space-67890 / project-abcde) + concrete schema_hash placeholders + per-platform TC examples"
    - "DESIGN-29 field-by-field rationale subsection — 8-line one-line-per-key justification"
    - "DESIGN-30 drift-detection contract — interface-only per CONTEXT D-30; explicit 'WITHOUT numbered pseudocode' boundary statement"
    - "DESIGN-30 inputs: current sandbox schema + cached last_known_schema.<platform>.schema_hash"
    - "DESIGN-30 outputs: Match -> proceed; Mismatch -> HALT + emit schema_drift_report.md"
    - "DESIGN-30 hard halt — no override / no --force / no auto-acknowledge; cancelled TCs receive failure_class: harness_drift"
    - "DESIGN-30 schema_drift_report.md shape — frontmatter (client / platform / previous_schema_hash / current_schema_hash / detected_at) + body (per-column diff + recommended human action)"
    - "DESIGN-30 human-action requirement — Acknowledge (refresh last_known_schema + quarantine affected TCs) | Revert (sandbox brought back into alignment)"
    - "Echo blockquote `> **DESIGN-NN:**` pattern per D-35 — 3 echo lines added (DESIGN-28/29/30 once each); running total 32/30 (assertion #4 floor met with margin)"
    - "Structural-check assertion #4 (echo count >= 30) PASSES; all 9 assertions PASS — DESIGN.md is structurally passable (NOT yet reviewer-ready — Plan 02-10 synthesis state)"
key_files:
  created:
    - .planning/phases/02-design/02-09-SUMMARY.md
  modified:
    - .planning/DESIGN.md
decisions:
  - "Phase 2 Plan 09: ## Test bot architecture H2 opening framing paragraph cites CONTEXT D-30 — 3 architectural commitments (DESIGN-28/29/30) ship interface-level + skeleton-schema fidelity; algorithmic detail deferred to v2.1+ Phase 5 Stage 8 build per CHANGE-01 9-phase plan; Stage 8 overview (DESIGN-24 / Plan 02-08) declared stage-level architecture; this section provides per-DESIGN architectural detail."
  - "Phase 2 Plan 09: DESIGN-28 tier boundary table uses 6-column shape (Tier / Role / Owner / Asserts / Authoring / Examples) — first cell content is bare 'Tier-1' / 'Tier-2' (Role split into separate column 'deterministic' / 'AI orchestrator') so Plan acceptance regex `^\\| (Tier-1|Tier-2) \\|` matches both data rows. The original 5-column shape with combined first cell `| Tier-1 (deterministic) |` failed the row-count assertion — Rule 1 fix during verification before Task 1 commit."
  - "Phase 2 Plan 09: DESIGN-28 Tier-1 Authoring cell explicitly cites the verbatim Out-of-Scope anti-feature 'Generating Python tier-1 tests from natural language alone' — T-02-09-01 / T-02-09-03 mitigation; AI-tier-2 cell cites test-bot-orchestrator agent (DESIGN-04) as Owner."
  - "Phase 2 Plan 09: DESIGN-28 mixed-layer cases — when a single TC needs both tier-1 AND tier-2 assertions, the test plan marks it `layer: mixed` AND flags it for human design; silent assignment FORBIDDEN. Reviewer must consciously choose split-vs-mixed before TC enters <Client> Brain/test-bot/test_cases/."
  - "Phase 2 Plan 09: DESIGN-28 worked TC example — Pipefy card-create scenario split: tier-1 assertions (status_code == 201 + id presence + regex match) + tier-2 invocation (AI Agent log read + classify failure: ingest_lag | agent_skip | log_silence | unknown). Demonstrates concrete `layer: mixed` classification with reviewer sign-off precondition."
  - "Phase 2 Plan 09: DESIGN-29 client_state.yaml — 7 top-level keys locked (client / client_state_version / sandbox / fixtures / integration_toggles / last_known_schema / test_cases) + last_provisioned_at as audit-trail field; full per-test fixtures NOT scoped to this DESIGN slice per CONTEXT D-30."
  - "Phase 2 Plan 09: DESIGN-29 sandbox 4 platform sub-blocks — pipefy / wrike / ziflow / coda. Coda sub-block carries CRIT-5 fix inline comment (sandbox allowlist extension per DESIGN-24); v0.3.0 omitted Coda from sandbox tenant inventory."
  - "Phase 2 Plan 09: DESIGN-29 wrike.host: field — PERSISTED from OAuth token response per DESIGN-15; T-02-09-06 mitigation. Worked Wrike example uses concrete `host: https://app-us2.wrike.com/api/v4` to demonstrate the PERSISTED contract; CRITICAL bug-prevention against hardcoded `www.wrike.com` regression."
  - "Phase 2 Plan 09: DESIGN-29 3 worked per-platform examples ground the skeleton in concrete sandbox IDs — pipe-12345 (pipefy) + space-67890 (wrike) + project-abcde (ziflow); each example shows sandbox sub-block + last_known_schema sub-block + 1 representative TC entry. T-02-09-04 mitigation honoured (concrete IDs, not placeholders only)."
  - "Phase 2 Plan 09: DESIGN-29 Ziflow worked example uses `state: quarantined` with inline comment 'flaky read-after-create within 30s consistency window' — demonstrates lifecycle state contract from DESIGN-24 in worked example context (read-after-create flake is the canonical example for Ziflow per DESIGN-16)."
  - "Phase 2 Plan 09: DESIGN-29 field-by-field rationale — 8 one-line justifications (one per top-level key + last_provisioned_at), each citing the locking decision (DESIGN-15 wrike host / DESIGN-24 sandbox lifecycle / DESIGN-30 drift-detection input shape / etc)."
  - "Phase 2 Plan 09: DESIGN-30 drift-detection contract — interface-only per CONTEXT D-30; explicit 'WITHOUT numbered pseudocode' boundary statement (T-02-09-03 mitigation literal-substring assertion). Algorithmic detail (schema-fetch transport, hash canonicalisation, per-column diff format, frontmatter validation, idempotent re-runs) explicitly deferred to v2.1+ Phase 5 Stage 8 build per CHANGE-01 9-phase plan."
  - "Phase 2 Plan 09: DESIGN-30 halt condition is HARD — no override flag, no --force, no auto-acknowledge. Stage 8d emits schema_drift_report.md and exits non-zero; cancelled TCs receive failure_class: harness_drift (DESIGN-24 5th canonical class). Drift requires explicit human action before next Stage 8d run for affected platform / client."
  - "Phase 2 Plan 09: DESIGN-30 schema_drift_report.md shape — frontmatter (client / platform / previous_schema_hash / current_schema_hash / detected_at) + body (per-column diff: added / removed / type-changed / renamed columns + recommended human action which-of-two-paths). T-02-09-03 mitigation honoured (interface-only; no algorithm)."
  - "Phase 2 Plan 09: DESIGN-30 human-action 2 paths — (1) Acknowledge: human runs Stage 8a (provision-test-harness) to refresh last_known_schema.<platform> + reviews per-TC impact + marks affected TCs as `quarantined` (per DESIGN-24 lifecycle) until tier-1 assertions updated; Stage 8a writes new schema_hash + fetched_at + schema_snapshot_path + bumps client_state_version; (2) Revert: human reverts sandbox to match last_known_schema (un-applies sandbox migration that introduced drift) + reruns Stage 8d; no client_state.yaml change required."
  - "Phase 2 Plan 09: Echo count progresses 29 -> 32/30 (DESIGN-28 + DESIGN-29 + DESIGN-30 — 3 single-stage echoes, no dual-echo). Final count exceeds 30 floor because two prior plans had dual-echo IDs (DESIGN-20 under 4a/4b in Plan 02-06 + DESIGN-23 under 7a/7b in Plan 02-07); structural-check assertion #4 uses `>= 30` which tolerates overcount."
  - "Phase 2 Plan 09: Structural-check NOW PASSES (exit 0) — all 9 assertions pass. DESIGN.md is **structurally passable** per cross-AI review MEDIUM #7 wording revision. Reviewer-ready / 'complete and ready for Phase 2 approval gate' is reserved for Plan 02-10's terminal state after synthesis (executive summary + Appendix A glossary + Appendix B DESIGN-* traceability table + finalised preamble + full enumerated [OPEN] list reconciliation)."
  - "Phase 2 Plan 09: No new inline [OPEN: Phase 4 — ...] markers added in this plan — all DESIGN-28/29/30 contracts LOCKED with closed enums (tier-boundary 2 tiers + mixed; sandbox 4 platforms; lifecycle 3 states; drift outcomes 2 paths). Inline marker count unchanged from Plan 02-08 baseline (= 17 across DESIGN.md)."
  - "Phase 2 Plan 09: Cross-AI review fixes applied — HIGH #2 (added .planning/phases/02-design/02-09-SUMMARY.md to files_modified per plan revision_log; verified before execution); MEDIUM #7 (wording revised throughout — `<done>`/`<verification>`/`<output>`/SUMMARY pointer all use 'structurally passable' instead of implying full reviewer-readiness; 'reviewer-ready' / 'complete and ready for Phase 2 approval gate' reserved for Plan 02-10's terminal state)."
  - "Phase 2 Plan 09: T-02-09-07 mitigation — wording precision honoured throughout: SUMMARY.md uses 'structurally passable' verbatim; 'reviewer-ready' is forbidden in Plan 02-09 (reserved for Plan 02-10)."
  - "Phase 2 Plan 09: No content under dydx-delivery/ modified — design-only milestone discipline maintained per kickoff mandate."
  - "Phase 2 Plan 09: Tasks 1 + 2 split into 2 atomic commits (one per task) — Task 1 wrote DESIGN-28 + opening framing; Task 2 wrote DESIGN-29 + DESIGN-30. The DESIGN-29 → DESIGN-30 cross-reference (DESIGN-30 inputs cite DESIGN-29 last_known_schema as data shape) is internal to Task 2's edit so commit-splitting is safe; intermediate state after Task 1 has DESIGN-28 fully populated + DESIGN-29/30 still placeholders, which is structurally valid (assertion #4 echo count = 30 after Task 1; passes the >= 30 floor)."
  - "Phase 2 Plan 09: Plan 02-10 (Wave 10 synthesis) handles executive summary + Appendix A glossary + Appendix B DESIGN-* traceability table (30 rows) + finalising the closed `[OPEN: Phase 4 — ...]` enumeration list (currently 1 seed marker; Plan 02-10 expands to full enumerated reconciliation). After Plan 02-10, DESIGN.md is reviewer-ready for Phase 2 approval gate."
metrics:
  duration_minutes: 10
  completed_date: "2026-05-09"
  task_count: 2
  file_count: 1
---

# Phase 2 Plan 09: Test bot architecture — DESIGN-28 (tier boundary) + DESIGN-29 (client_state.yaml) + DESIGN-30 (drift-detection) Summary

**One-liner:** Locked DESIGN-28 (Python tier-1 deterministic HUMAN-AUTHORED ↔ AI tier-2 orchestrator AI-GENERATED hard layer-separation contract — 6-column tier boundary table + verbatim Out-of-Scope anti-feature citation 'Generating Python tier-1 tests from natural language alone' + mixed-layer cases flagged for human design no silent assignment + 1 worked Pipefy card-create TC classification example demonstrating tier-1 assertions + tier-2 AI Agent log interpretation with failure_class enum) + DESIGN-29 (`client_state.yaml` skeleton — 7 top-level keys client / client_state_version / sandbox / fixtures / integration_toggles / last_known_schema / test_cases + 4 sandbox sub-blocks pipefy / wrike / ziflow / coda Coda per CRIT-5 fix + wrike.host: PERSISTED from OAuth per DESIGN-15 CRITICAL bug-prevention + 3 worked per-platform examples with concrete sandbox IDs pipe-12345 / space-67890 / project-abcde + field-by-field rationale 8-line) + DESIGN-30 (drift-detection contract — interface-only per CONTEXT D-30 explicit 'WITHOUT numbered pseudocode' boundary; inputs current sandbox schema + cached last_known_schema.<platform>.schema_hash; outputs Match → proceed / Mismatch → HALT + emit schema_drift_report.md hard halt no override; report frontmatter client / platform / previous_schema_hash / current_schema_hash / detected_at + body per-column diff + recommended action; human-action 2 paths Acknowledge run Stage 8a refresh schema + quarantine affected TCs OR Revert sandbox brought back into alignment); 3 echo blockquotes added (DESIGN-28/29/30 once each); running total 32/30 — assertion #4 NOW PASSES with margin; **structural-check exits 0 — DESIGN.md is structurally passable** (NOT yet reviewer-ready per cross-AI MEDIUM #7 wording revision; reviewer-ready is Plan 02-10 terminal state after synthesis).

## What Was Done

### Task 1 — `## Test bot architecture` opening + DESIGN-28 tier-1 / tier-2 boundary

Replaced placeholder body of `## Test bot architecture` H2 opening + `### DESIGN-28: tier-1 / tier-2 boundary` H3.

**(A) Section opening.** Under the `## Test bot architecture` H2, framing paragraph added: "The test bot architecture comprises three architectural commitments locked here as decision contracts: DESIGN-28 (tier-1 / tier-2 boundary); DESIGN-29 (`client_state.yaml` skeleton); DESIGN-30 (drift-detection contract). Per CONTEXT D-30, these contracts ship interface-level + skeleton-schema fidelity — algorithmic detail is implemented in v2.1+ Phase 5 Stage 8 build per CHANGE-01 9-phase plan. Stage 8 overview (above) declared the stage-level architecture; this section provides the per-DESIGN architectural detail."

**(B) DESIGN-28 tier boundary.**

- **Echo blockquote:** `> **DESIGN-28:** Python ↔ AI orchestrator boundary — Python tier-1 asserts state, schema, presence/absence, equality, regex, retry-count, status-code class; AI tier-2 interprets free-form output, classifies failure causes, suggests remediation. Test plans mark each TC with the layer it belongs to. Mixed-layer cases flagged for human design.`
- **Tier boundary table — 6-column shape:** `Tier | Role | Owner | Asserts | Authoring | Examples`. Two data rows: Tier-1 (Python `test_runner.py`, HUMAN-AUTHORED, concrete `assert` examples) + Tier-2 (`test-bot-orchestrator` agent per DESIGN-04, AI-GENERATED via Stage 8d, free-form classification example returning `failure_class:` per DESIGN-24 enum).
- **Out-of-Scope citation:** Tier-1 Authoring cell explicitly cites verbatim 'Generating Python tier-1 tests from natural language alone' anti-feature.
- **Mixed-layer cases subsection:** `layer: mixed` flagged for human design; silent assignment FORBIDDEN; reviewer chooses split-vs-mixed consciously.
- **1 worked TC classification example:** Pipefy card-create scenario split into tier-1 (status_code 201 + id presence + regex `^[0-9]+$`) + tier-2 (Wait 30s for AI Agent picker + invoke agent for log interpretation + classify failure: `ingest_lag | agent_skip | log_silence | unknown`).
- **Cross-references:** DESIGN-04 (test-bot-orchestrator agent location); DESIGN-24 (Stage 8 overview + failure_class enum incl. harness_drift); DESIGN-29 (client_state.yaml per-test-case `layer:` field); REQUIREMENTS `## Out of Scope`.
- **Implementing decisions:** D-20, D-32, D-35.

**Rule 1 fix during verification.** Initial table used 5-column shape with combined first cell `| Tier-1 (deterministic) |` — failed the Plan acceptance regex `^\| (Tier-1|Tier-2) \|` (which requires bare `| Tier-1 |`). Restructured to 6-column shape splitting Role into a separate column ('deterministic' / 'AI orchestrator'); both data rows now match the regex. No second commit needed — caught pre-commit during Task 1 acceptance verification.

### Task 2 — DESIGN-29 client_state.yaml skeleton + DESIGN-30 drift-detection contract

Replaced placeholder bodies of `### DESIGN-29: client_state.yaml skeleton` + `### DESIGN-30: drift-detection contract` H3 sections.

**(A) DESIGN-29 client_state.yaml skeleton.**

- **Echo blockquote:** `> **DESIGN-29:** \`client_state.yaml\` schema — sandbox tenant IDs gated by platform; fixtures; integration toggles; \`wrike_host\`; \`last_known_schema\` per platform; \`last_passed_at\` per test case; \`targets_artefact\` per test case for obsolescence detection.`
- **Skeleton YAML in fenced code block** with 7 top-level keys: `client:` + `client_state_version:` + `last_provisioned_at:` + `sandbox:` (with pipefy/wrike/ziflow/coda sub-blocks) + `fixtures:` + `integration_toggles:` + `last_known_schema:` + `test_cases:`.
- **4 sandbox sub-blocks:** pipefy (pipe_id + api_token_ref) / wrike (space_id + host: PERSISTED + api_token_ref) / ziflow (project_id + api_token_ref) / coda (doc_id + api_token_ref) — Coda per CRIT-5 fix cited inline.
- **Wrike `host:` field** PERSISTED from OAuth token response per DESIGN-15 — inline comment "PERSISTED per DESIGN-15"; CRITICAL bug-prevention against hardcoded www.wrike.com regression.
- **3 worked per-platform examples:** Pipefy (client `acme-inc`, sandbox `pipe-12345`, schema fetched 2026-04-15, tier-1 active TC) + Wrike (sandbox `space-67890`, host `https://app-us2.wrike.com/api/v4` PERSISTED, tier-2 active TC) + Ziflow (sandbox `project-abcde`, mixed quarantined TC with read-after-create flake comment).
- **Field-by-field rationale subsection** — 8 one-line justifications (one per top-level key + last_provisioned_at audit field), each citing the locking decision.
- **Cross-references:** DESIGN-15 (wrike host); DESIGN-24 (sandbox_lock + lifecycle states + CRIT-5 Coda); DESIGN-30 (drift-detection consumes last_known_schema); DESIGN-14/15/16 (per-platform sandbox access patterns).

**(B) DESIGN-30 drift-detection contract.**

- **Echo blockquote:** `> **DESIGN-30:** Drift detection — pre-flight fetches current sandbox schema and diffs against \`client_state.yaml.last_known_schema\`; mismatch halts + emits \`schema_drift_report.md\` instead of executing; drift requires explicit human action (acknowledge or revert).`
- **Inputs subsection:** Current sandbox schema (fetched fresh by Stage 8d at pre-flight) + cached `last_known_schema.<platform>.schema_hash` from `<Client> Brain/test-bot/client_state.yaml` (DESIGN-29).
- **Outputs subsection:** Match → proceed to test execution; Mismatch → HALT + emit `<Client> Brain/test-bot/schema_drift_report.md`; no tests run.
- **Halt condition subsection:** Hard halt — no override flag, no `--force`, no auto-acknowledge. Stage 8d exits non-zero; cancelled TCs receive `failure_class: harness_drift` (DESIGN-24 5th canonical class).
- **`schema_drift_report.md` shape subsection:** Frontmatter (client / platform / previous_schema_hash / current_schema_hash / detected_at) + body (per-column diff: added / removed / type-changed / renamed columns + recommended human action which-of-two-paths).
- **Human-action requirement subsection — 2 paths:** Acknowledge (human runs Stage 8a `provision-test-harness/` to refresh `last_known_schema.<platform>`; reviews per-TC impact; marks affected TCs as `quarantined` per DESIGN-24 lifecycle until tier-1 assertions updated; Stage 8a writes new schema_hash + fetched_at + schema_snapshot_path: + bumps client_state_version:) | Revert (human reverts sandbox to match `last_known_schema`; reruns Stage 8d; no client_state.yaml change required).
- **Algorithmic detail boundary subsection:** Per CONTEXT D-30, contract specifies inputs / outputs / halt condition / report shape / human-action requirement WITHOUT numbered pseudocode. Algorithm — schema-fetch transport, hash canonicalisation rules, per-column diff format, frontmatter validation, idempotent re-runs — implemented in v2.1+ Phase 5 Stage 8 build per CHANGE-01 9-phase plan.
- **Cross-references:** DESIGN-24 (`harness_drift` failure-class); DESIGN-29 (`last_known_schema` data shape input + `client_state_version:` bumps on acknowledge); platform-pipefy/-wrike/-ziflow (per-platform schema-fetch surface).

**Structural-check run.** Exit code = **0** (all 9 assertions PASS) — DESIGN.md is **structurally passable**.

## Files Created / Modified

| File | Type | Change |
|------|------|--------|
| `.planning/DESIGN.md` | modified | `## Test bot architecture` H2 opening framing paragraph added; `### DESIGN-28: tier-1 / tier-2 boundary` populated with 6-column tier boundary table + Out-of-Scope citation + mixed-layer cases + 1 worked Pipefy TC classification example; `### DESIGN-29: client_state.yaml skeleton` populated with 7-top-level-key YAML skeleton + 4 sandbox sub-blocks (incl. Coda CRIT-5) + Wrike host PERSISTED per DESIGN-15 + 3 worked per-platform examples (pipe-12345 / space-67890 / project-abcde) + field-by-field rationale; `### DESIGN-30: drift-detection contract` populated with inputs / outputs / halt condition / report shape / 2-path human-action / algorithmic-detail-deferred boundary statement |
| `.planning/phases/02-design/02-09-SUMMARY.md` | created | This document |

## Echo Count Progression

| Plan | Echoes added | Running total |
|------|--------------|---------------|
| 02-02 | DESIGN-01..10 | 10/30 |
| 02-03 | DESIGN-11/12/13 | 13/30 |
| 02-04 | DESIGN-14/15/16 | 16/30 |
| 02-05 | DESIGN-17/18/19 | 19/30 |
| 02-06 | DESIGN-20 (dual under 4a + 4b) + DESIGN-21 | 22/30 |
| 02-07 | DESIGN-22 + DESIGN-23 (dual under 7a + 7b) | 25/30 |
| 02-08 | DESIGN-24 + DESIGN-25 + DESIGN-26 + DESIGN-27 | 29/30 |
| **02-09 (this plan)** | **DESIGN-28 + DESIGN-29 + DESIGN-30** | **32/30** |
| 02-10 (next) | synthesis | structural-check assertion #4 PASSED in 02-09 |

DESIGN-28/29/30 each contribute 1 echo (single-stage echoes — no dual). Final count 32 exceeds 30 floor because two prior plans had dual-echo IDs (DESIGN-20 under 4a/4b in Plan 02-06 + DESIGN-23 under 7a/7b in Plan 02-07); structural-check assertion #4 uses `>= 30` which tolerates the overcount per plan contract.

## Inline `[OPEN: Phase 4]` Marker Count Progression

| Plan | Marker count | Net change | Notes |
|------|--------------|-----------|-------|
| 02-04 (baseline) | 13 | +13 | 7 new pipefy/wrike/ziflow markers + 6 prior |
| 02-05 | 13 | 0 | DESIGN-17/18/19 LOCKED |
| 02-06 | 13 | 0 | DESIGN-20/21 LOCKED |
| 02-07 | 17 | +4 | 1 NEW canonical D-22 marker + 3 echo references |
| 02-08 | 17 | 0 | DESIGN-24/25/26/27 LOCKED — closed enums |
| **02-09 (this plan)** | **17** | **0** | DESIGN-28/29/30 LOCKED — closed enums (tier-boundary 2 tiers + mixed; sandbox 4 platforms; lifecycle 3 states; drift outcomes 2 paths); no new inline `[OPEN]` markers needed |

All three DESIGN-28/29/30 contracts LOCKED with closed enums; no inline deferrals required.

## Cross-AI Review Fixes Applied

- **HIGH #2 (Codex):** `.planning/phases/02-design/02-09-SUMMARY.md` present in plan frontmatter `files_modified` — verified before execution per plan revision_log entry 2026-05-09.
- **MEDIUM #7 (Codex):** Wording revised throughout — `<done>` block, `<verification>` block, `<success_criteria>`, `<output>`/SUMMARY pointer all use "structurally passable" instead of implying full reviewer-readiness; "reviewer-ready" / "complete and ready for Phase 2 approval gate" reserved for Plan 02-10's terminal state after synthesis (executive summary + Appendix A glossary + Appendix B DESIGN-* traceability table + finalised preamble + full enumerated `[OPEN]` list reconciliation). T-02-09-07 mitigation honoured.

## Threat Model Mitigations Honoured

| Threat ID | Mitigation | Status |
|-----------|-----------|--------|
| T-02-09-01 | Tampering: DESIGN-29 YAML omits a top-level key — acceptance criteria assert all 7 top-level keys + key sub-block fields | ✓ verified all 7: client / client_state_version / sandbox / fixtures / integration_toggles / last_known_schema / test_cases (plus last_provisioned_at audit field) |
| T-02-09-02 | Tampering: DESIGN-29 forgets the Coda sandbox block (CRIT-5 fix) — acceptance criteria explicitly assert `coda:` AND CRIT-5 cited | ✓ verified `coda:` sub-block present in skeleton + CRIT-5 inline comment + cross-reference to DESIGN-24 sandbox allowlist extension |
| T-02-09-03 | Tampering: DESIGN-30 ships pseudocode despite D-30 saying "WITHOUT numbered pseudocode" — acceptance criteria assert literal substring | ✓ verified literal `WITHOUT numbered pseudocode` present in DESIGN-30 algorithmic-detail-boundary subsection |
| T-02-09-04 | Tampering: DESIGN-29 worked examples use placeholder IDs only — acceptance criteria require concrete sandbox IDs | ✓ verified concrete IDs `pipe-12345` + `space-67890` + `project-abcde` present in three worked examples |
| T-02-09-05 | Tampering: Plan 02-09 leaves the structural-check failing — acceptance criteria require `bash design-structure-check.sh` exits 0 | ✓ verified — structural-check exits 0; all 9 assertions PASS |
| T-02-09-06 | Tampering: DESIGN-29 wrike sub-block hardcodes `host: www.wrike.com` — worked example explicitly shows `host: https://app-us2.wrike.com/api/v4` | ✓ verified — Wrike worked example uses `host: https://app-us2.wrike.com/api/v4` PERSISTED + inline comment "PERSISTED from OAuth token response"; no www.wrike.com hardcoding present |
| T-02-09-07 | Tampering: Plan 02-09 wording overclaims "reviewer-ready" when only structurally-passable (cross-AI review MEDIUM #7) — all `<done>`, `<verification>`, `<output>` text uses "structurally passable" verbatim | ✓ verified — SUMMARY.md uses "structurally passable" throughout; "reviewer-ready" / "complete and ready for Phase 2 approval gate" not used in Plan 02-09 (reserved for Plan 02-10) |

## Deviations from Plan

**1. [Rule 1 - Bug] DESIGN-28 tier boundary table column count adjusted from 5 to 6 to satisfy acceptance regex**

- **Found during:** Task 1 verification — initial Edit shipped a 5-column table with combined first cell `| Tier-1 (deterministic) |` and `| Tier-2 (AI orchestrator) |`; the Plan acceptance criterion `awk '/^### DESIGN-28:/,/^### DESIGN-29:/' .planning/DESIGN.md | grep -cE '^\| (Tier-1|Tier-2) \|'` returned 0 (the regex requires bare `| Tier-1 |` / `| Tier-2 |` with literal space-pipe boundaries).
- **Issue:** Combined first cell embedded the role descriptor inline, so the regex didn't match either row.
- **Fix:** Restructured to a 6-column shape `Tier | Role | Owner | Asserts | Authoring | Examples` — split the role descriptor ('deterministic' / 'AI orchestrator') into a dedicated `Role` column. Both data rows now have bare `| Tier-1 |` / `| Tier-2 |` first cells; `grep -cE` returns 2 as expected.
- **Files modified:** `.planning/DESIGN.md` (DESIGN-28 tier table — 5→6 columns; semantically identical content, structurally passable for the acceptance regex).
- **Commit:** Caught pre-commit during Task 1 verification; no separate commit; the corrected table shipped in Task 1 commit `9e05a5e`.

**2. [Rule 2 - Auto-add] Field-by-field rationale subsection added to DESIGN-29**

- **Found during:** Task 2 implementation.
- **Issue:** Plan acceptance criteria require a "field-by-field rationale subsection" but the plan's `<interfaces>` block only specified the top-level keys list without a rationale paragraph. Reviewer needs the rationale to understand WHY each field is canonical (locking-decision citation per key).
- **Fix:** Added 8-line one-line-per-key rationale subsection citing the locking decision per field (DESIGN-15 wrike host / DESIGN-24 sandbox lifecycle + CRIT-5 / DESIGN-30 drift-detection input shape).
- **Files modified:** `.planning/DESIGN.md` (DESIGN-29 H3 — added Field-by-field rationale subsection).
- **Commit:** `752e85c` (Task 2 commit — included rationale alongside YAML skeleton + 3 examples).

## Pointer

Plan 02-10 (Wave 10 synthesis) handles executive summary + Appendix A glossary + Appendix B DESIGN-* traceability table (30 rows) + finalising the closed `[OPEN: Phase 4 — ...]` enumeration list (currently 1 seed marker placed by Plan 02-01; Plan 02-10 expands to full enumerated reconciliation against all 17 inline markers). After Plan 02-10, DESIGN.md is reviewer-ready for Phase 2 approval gate.

## Self-Check: PASSED

- ✓ `.planning/DESIGN.md` modified — `## Test bot architecture` H2 opening + DESIGN-28/29/30 H3 sections populated
- ✓ Commit `9e05a5e` exists (Task 1 — opening + DESIGN-28) — verified `git log --oneline | grep 9e05a5e`
- ✓ Commit `752e85c` exists (Task 2 — DESIGN-29 + DESIGN-30) — verified `git log --oneline | grep 752e85c`
- ✓ DESIGN-28 echo present (`grep -qE '^> \*\*DESIGN-28:\*\*' .planning/DESIGN.md`)
- ✓ DESIGN-29 echo present (`grep -qE '^> \*\*DESIGN-29:\*\*' .planning/DESIGN.md`)
- ✓ DESIGN-30 echo present (`grep -qE '^> \*\*DESIGN-30:\*\*' .planning/DESIGN.md`)
- ✓ All Task 1 acceptance greps pass (test_runner.py + test-bot-orchestrator + HUMAN-AUTHORED + AI-GENERATED + Generating Python tier-1 tests from natural language alone + failure_class: + layer: mixed + tier boundary table 2 rows)
- ✓ All Task 2 acceptance greps pass (yaml fence + 7 top-level keys + 4 sandbox sub-blocks + host: PERSISTED + targets_artefact + last_passed_at + last_known_schema + 3 concrete sandbox IDs pipe-12345/space-67890/project-abcde + schema_drift_report.md + previous_schema_hash + current_schema_hash + acknowledge or revert + WITHOUT numbered pseudocode)
- ✓ Echo count = 32/30 (verified `grep -cE '^> \*\*DESIGN-[0-9]{2}:\*\*' .planning/DESIGN.md` returns 32; >= 30 floor met with margin)
- ✓ Structural-check exits 0 — all 9 assertions PASS — DESIGN.md is structurally passable
- ✓ No content under `dydx-delivery/` modified
- ✓ Wording precision (cross-AI MEDIUM #7) — SUMMARY.md uses "structurally passable" verbatim; "reviewer-ready" / "complete and ready for Phase 2 approval gate" not used (reserved for Plan 02-10)
- ✓ All STRIDE threats T-02-09-01..07 mitigations verified
