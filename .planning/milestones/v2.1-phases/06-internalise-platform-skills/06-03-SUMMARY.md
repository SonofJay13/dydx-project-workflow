---
phase: 06-internalise-platform-skills
plan: 03
subsystem: platform-skills
tags: [platform-skills, ziflow, wait_for_proof, webhook-primary, q05, reviewai]
dependency_graph:
  requires:
    - 06-01 (phase6-structure-check.sh + --section partition + Pipefy sibling shape)
  provides:
    - dydx-delivery/skills/platform-ziflow/ (complete tree — SKILL.md + 5 references/)
    - Q05 inline resolution (webhook-PRIMARY + wait_for_proof 30s/2s fallback defaults)
    - REVIEWS C7 ZiflowRateLimitExceeded 429 failure class fix
  affects:
    - 06-04 synthesis plan (OPEN-Q05 row flip + cross-tree A7 gate + A16 confirmation)
tech_stack:
  added: []
  patterns:
    - "D-59 verbatim hard-rules pointer (carry-forward from 06-01 + 06-02)"
    - "D-65 client-shape-gotchas seed: verified worked example + TBD-at-first-engagement stubs for documented Coda-brain clients"
    - "D-66 vocabulary.md: glossary pointer first, platform-specific terms only"
    - "D-68 tier_claims_last_verified per-platform maintained date + event-based re-verification trigger"
    - "7-part D-64 helper contract (signature + behaviour + retry/poll budget + failure modes + return shape + pseudocode + worked example)"
    - "Webhook-PRIMARY framing ordering: vendor-recommended pattern surfaces ABOVE helper FALLBACK"
key_files:
  created:
    - dydx-delivery/skills/platform-ziflow/SKILL.md
    - dydx-delivery/skills/platform-ziflow/references/api-contract.md
    - dydx-delivery/skills/platform-ziflow/references/native-ai-inventory.md
    - dydx-delivery/skills/platform-ziflow/references/knowledge-ingestion.md
    - dydx-delivery/skills/platform-ziflow/references/client-shape-gotchas.md
    - dydx-delivery/skills/platform-ziflow/references/vocabulary.md
  modified: []
decisions:
  - "Q05 read-after-create consistency window resolved INLINE as webhook-PRIMARY + 30s/2s polling fallback defaults; OPEN-QUESTIONS.md row flip itself deferred to 06-04 synthesis plan per D-67"
  - "REVIEWS C7 429 failure class fix landed: dedicated ZiflowRateLimitExceeded for 429 (rate-limiting) distinct from ZiflowServerError for 5xx (server errors)"
  - "D-65 client-shape-gotchas seeded with Acme placeholder + TBD-at-first-engagement stubs for Up & Up Group + VodafoneZiggo per .claude/memory/reference_client_brain_coda_docs.md"
  - "REVIEWS C4 directory ownership: this plan's Task 1 created dydx-delivery/skills/platform-ziflow/references/ via mkdir -p (no .gitkeep placeholders left behind)"
metrics:
  duration: ~4 min
  completed: 2026-05-11
  tasks_completed: 4
  files_created: 6
  commits: 4
---

# Phase 6 Plan 03: platform-ziflow Skill Tree Summary

Ziflow platform reference skill landed end-to-end (1 SKILL.md + 5 references/) per D-63 per-platform slicing, with webhook-PRIMARY framing surfaced above the `wait_for_proof` FALLBACK helper per Q05 vendor research (vendor explicitly recommends webhooks over polling).

## What Shipped

| File | Lines | Purpose |
|---|---|---|
| `dydx-delivery/skills/platform-ziflow/SKILL.md` | 54 | Platform reference skill with locked frontmatter (`platform: ziflow`, `tier_claims_last_verified: 2026-05-09`, `native_ai_path: paste`, `frontmatter_version: 2`), D-59 hard-rules pointer, D-68 re-verification trigger with high-churn note |
| `references/api-contract.md` | 116 | Webhook-PRIMARY framing (Q05 resolution) → `wait_for_proof` FALLBACK 7-part contract (max_wait_s=30 / interval_s=2) → REVIEWS C7 ZiflowRateLimitExceeded 429 class → MCP availability "no MCP" parked ref |
| `references/native-ai-inventory.md` | 40 | 5-row ReviewAI capability matrix (Checklists Public Preview HIGH + Change Verification "Coming Soon" MEDIUM + Brand Standards "Coming Soon" MEDIUM + Checklist Templates API GA April 2026 HIGH + knowledge-ingestion API CLOSED) |
| `references/knowledge-ingestion.md` | 23 | UAT-6.1 paste-only Stage 10 path with ReviewAI Checklist criteria + per-client target ID; audit log shape |
| `references/client-shape-gotchas.md` | 41 | D-65 seed: Acme placeholder + TBD stubs for Up & Up Group + VodafoneZiggo + 3 pattern slots |
| `references/vocabulary.md` | 31 | D-66 glossary pointer + 10 Ziflow-specific terms (proof / review / decision / stage / version / project_id / ReviewAI / Checklist / Change Verification / Brand Standards) |

## Verification Results

`bash .planning/phases/06-internalise-platform-skills/scripts/phase6-structure-check.sh --section ziflow` exits 0 with ALL ASSERTIONS PASSED:

- **A3** Ziflow SKILL.md exists
- **A4-ziflow** 5 references/ files exist
- **A5-ziflow** tier_claims_last_verified ISO date present (2026-05-09)
- **A6-ziflow** native_ai_path enum valid (paste)
- **A13** wait_for_proof helper (max_wait_s=30, interval_s=2) + webhook PRIMARY documented
- **A17-ziflow** Ziflow capability matrix present

Full-suite run (no `--section`) reaches the cross-tree gates:
- **A7** PASS — no forbidden `native_ai_path: api` YAML field assignments across any of `platform-{pipefy,wrike,ziflow}/` trees (T-06-02 mitigation; REVIEWS C3 tightened regex)
- **A16** FAIL (expected — OPEN-Q05/Q06.2/Q07.2 row flips are owned by 06-04 synthesis plan, not this plan)

Pipefy (A1, A4, A5, A6, A8, A9, A10, A11, A14, A17) and Wrike (A2, A4, A5, A6, A12, A15, A17) sections also PASS — all 3 platform trees now complete.

## Q05 Resolution (Inline per D-67)

OPEN-Q05 "Ziflow read-after-create consistency window" resolved inline in `api-contract.md`:

- **Primary path (vendor-recommended):** Subscribe to the `processed` event webhook BEFORE proof creation; Ziflow notifies caller when proof is ready. Vendor docs cited: `help.ziflow.com/hc/en-us/articles/30725068740244-Webhooks` and `help.ziflow.com/hc/en-us/articles/30721919730836-Embedded-Review-Approval` ("use webhooks instead of polling").
- **Fallback (no webhook URL):** `wait_for_proof(proof_id, max_wait_s=30, interval_s=2)` — up to ~15 polls per call.

The OPEN-QUESTIONS.md row flip itself is deferred to 06-04 synthesis plan per D-67 — single-point ownership of `.planning/OPEN-QUESTIONS.md` avoids inter-plan write conflicts.

## REVIEWS C7 429 Classification Fix

The `wait_for_proof` 7-part contract now uses dedicated `ZiflowRateLimitExceeded` for HTTP 429 (rate-limiting), distinct from `ZiflowServerError` reserved for HTTP 5xx (server errors). Previous shape collapsed both under `ZiflowServerError` — REVIEWS C7 split them because 429 is a client-throttle signal, not a server fault. Both failure classes documented in failure-modes block and exercised in pseudocode.

## Deviations from Plan

None. Plan executed exactly as written. One minor addition: a contiguous-string prose mention of `Checklists Public Preview` was added to `native-ai-inventory.md` (the matrix-row form `| ReviewAI Checklists | yes (Public Preview, ...)` splits the phrase across table cells, and the plan acceptance criterion `grep -qF 'Checklists Public Preview'` requires the literal contiguous token). This is content reinforcement, not a structural change — same fact, single grep-able phrase.

## Threat Mitigations Verified

| Threat | Mitigation | Verified |
|---|---|---|
| T-06-01 (`tier_claims_last_verified:` tampering — Ziflow most likely to drift first) | A5-ziflow ISO-date format gate + REVIEWS C6 `Verified-Against: <URL>` commit-trailer requirement documented in `native-ai-inventory.md` and SKILL.md re-verification trigger | YES — frontmatter format passes; trailer requirement present in body |
| T-06-02 (forbidden `native_ai_path: api` enum leak via copy-paste) | A7 cross-tree YAML-field-assignment regex gate; per-file file-level zero-hit check | YES — all 6 files have zero matches; A7 PASS in full-suite run |

## Carry-Forward Patterns

- **D-59 hard-rules pointer** copied verbatim from 06-01 + 06-02 siblings
- **D-68 re-verification trigger** mirrored from sibling SKILL.md files with Ziflow-specific doc URL anchors
- **7-part helper contract** structure matches Pipefy `paginate_all` and Wrike OAuth-host pattern
- **REVIEWS C4 directory ownership** — Task 1 ran `mkdir -p dydx-delivery/skills/platform-ziflow/references/` (no `.gitkeep` placeholders pre-created in 06-01 per REVIEWS C4)

## Threat Flags

None. No new security-relevant surface introduced beyond the documented `<threat_model>`.

## Known Stubs

D-65 TBD-at-first-engagement stubs in `client-shape-gotchas.md` for Up & Up Group + VodafoneZiggo are **intentional, plan-mandated** seed stubs — not defects. They are populated when those clients enter Ziflow engagement (first-engagement append-only contract per the file's preamble).

## Commits

| # | Hash | Message |
|---|---|---|
| 1 | `ec1b15d` | feat(06-03): scaffold platform-ziflow/SKILL.md with D-59 pointer + D-68 trigger |
| 2 | `6f4b426` | feat(06-03): add platform-ziflow/references/api-contract.md (Q05 webhook-PRIMARY + wait_for_proof FALLBACK) |
| 3 | `c2c485c` | feat(06-03): add platform-ziflow/references/native-ai-inventory.md (DESIGN-16 ReviewAI matrix) |
| 4 | `0bb6859` | feat(06-03): add platform-ziflow/references/{knowledge-ingestion,client-shape-gotchas,vocabulary}.md (D-65/D-66 shape parity) |

## Next Up

- **06-04 synthesis plan** can now run: all 3 platform trees complete; OPEN-Q05/Q06.2/Q07.2 row flips + vocabulary dedup grep gate + confirm full structure-check exits 0 (A16 will then PASS as well).

## Self-Check: PASSED

All 6 created files exist on disk; all 4 commits present in `git log`; structure-check `--section ziflow` exits 0 with 6 PASS lines.
