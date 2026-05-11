---
phase: 06-internalise-platform-skills
plan: 01
subsystem: platform-skills / phase6-scaffold
tags: [platform-skills, pipefy, scaffold, phase6-structure-check, paginate_all, q06-2]
requires:
  - phase-05-foundations-complete  # canonical refs at dydx-delivery/references/
  - 06-CONTEXT.md / 06-RESEARCH.md / 06-VALIDATION.md / 06-REVIEWS.md locked
provides:
  - dydx-delivery/skills/platform-pipefy/ (1 SKILL.md + 5 references/)
  - phase6-structure-check.sh with --section pipefy|wrike|ziflow partition (unblocks Wave 2 parallel self-verify)
  - Q06.2 throttle calibration resolved inline (13 req/sec; row flip deferred to 06-04)
affects:
  - 06-02 (Wrike) + 06-03 (Ziflow): inherit the per-section partition pattern, the D-59 hard-rules pointer pattern, the auth-shape secret-handling note pattern
tech-stack:
  added: [bash + awk per-section structure-check script]
  patterns:
    - REVIEWS C1 per-section assertion partitioning
    - REVIEWS C2/C3 tightened YAML-field-assignment regex
    - REVIEWS C8 awk-between-OPEN-Q-headings extraction
    - D-59 uniform hard-rules pointer block (verbatim from execute-tests/SKILL.md)
    - D-64 7-part helper contract structure (signature + behaviour + retry + failure modes + return shape + pseudocode + worked example)
    - D-65 client-shape-gotchas append-only seeded with DESIGN-verified worked example
    - D-66 lean vocabulary opening with glossary pointer
key-files:
  created:
    - .planning/phases/06-internalise-platform-skills/scripts/phase6-structure-check.sh
    - dydx-delivery/skills/platform-pipefy/SKILL.md
    - dydx-delivery/skills/platform-pipefy/references/api-contract.md
    - dydx-delivery/skills/platform-pipefy/references/native-ai-inventory.md
    - dydx-delivery/skills/platform-pipefy/references/knowledge-ingestion.md
    - dydx-delivery/skills/platform-pipefy/references/client-shape-gotchas.md
    - dydx-delivery/skills/platform-pipefy/references/vocabulary.md
  modified: []
decisions:
  - "D-63 confirmed in practice: Pipefy as one atomic plan reviews cleanly end-to-end (6 deliverables; reviewer grades one platform at a time)."
  - "D-64 7-part helper contract structure works well for paginate_all — pseudocode is small (16 lines) and easy to lift to Phase 8 test bot."
  - "Q06.2 resolved inline: 13 req/sec per token (80% of 16.67 published ceiling = 500 req / 30s); landed in api-contract.md § Rate limit + throttle; OPEN-QUESTIONS.md row flip deferred to synthesis plan 06-04."
  - "tier_claims_last_verified: stays at 2026-05-09 baseline; no fresh re-verification performed in this execution (manual VALIDATION row 3 MCP re-verify deferred)."
metrics:
  duration: ~25min wall-clock
  completed: 2026-05-11
---

# Phase 06 Plan 01: Pipefy Platform Skill + Phase 6 Scaffold Summary

One-liner: Ships the complete platform-pipefy skill tree (1 SKILL.md + 5 references/ files) end-to-end plus the Wave-0 phase6-structure-check.sh with per-section assertion partitioning (REVIEWS C1) that unblocks parallel Wave-2 self-verify for 06-02 and 06-03.

## What landed

**Wave 0 scaffold:**
- `.planning/phases/06-internalise-platform-skills/scripts/phase6-structure-check.sh` (280 LOC, executable). Mirrors Phase 5 phase5-structure-check.sh shape: `set -euo pipefail`, fail/pass helpers, G-2 exclude convention. Implements A1..A17 from 06-VALIDATION.md plus all REVIEWS refinements: C1 per-section partition (`--section pipefy|wrike|ziflow`), C2/C3 tightened YAML-field-assignment regex for A7+A11, C8 awk-between-OPEN-Q-headings extraction for A16. Validated pre-content: `--section pipefy/wrike/ziflow` each FAIL at A1/A2/A3 respectively without leaking cross-platform assertions.

**Pipefy skill (PLAT-01 + PLAT-04 + PLAT-05 + partial PLAT-06):**
- `SKILL.md` — YAML frontmatter locks (`platform: pipefy`, `tier_claims_last_verified: 2026-05-09`, `native_ai_path: paste`, `frontmatter_version: 2`); D-59 uniform hard-rules pointer block verbatim; D-68 `## Re-verification trigger` section with Stage 4a/7b/10 consumers + doc URL anchors; `## What this skill provides` enumeration of all 5 references files.
- `references/api-contract.md` — canonical `api.pipefy.com/graphql` for ALL tenants (UAT-4.1 / Q24 verified 2026-05-10); auth-shape secret-handling note (NEVER paste real tokens); rate-limit subsection resolving Q06.2 inline at 13 req/sec / 80% of 16.67 ceiling; HTML-on-auth-failure detection subsection (Content-Type: text/html / Keycloak login redirect); `paginate_all` 7-part contract with pseudocode containing `throttle_req_per_sec=13` literal; multi-tenant auth-concurrency = exclusive (UAT-4.2); MCP availability parked reference (UAT-3.5).
- `references/native-ai-inventory.md` — 7-row 2026 Pipefy AI Agents 2.0 capability matrix verbatim from DESIGN-14; re-verification trigger; `## Paste-only delivery (UAT-6.1)` section.
- `references/knowledge-ingestion.md` — UAT-6.1 paste-only contract; Behaviors + KB upload list + per-client target ID; audit log shape; fallback subsection.
- `references/client-shape-gotchas.md` — D-65 seeded with Vodacom custom-subdomain (verified per DESIGN-14 REVISED 2026-05-10); pattern slots for web-host variants / org_id semantics / pipe_id-phase_id-card_id identifier distinction; append-only protocol.
- `references/vocabulary.md` — D-66 lean: opens with glossary pointer; 11 Pipefy-specific terms (pipe / phase / card / connection / org_id / web_host / pipe_id / phase_id / card_id / Behaviors / Pipefy AI Agents); dedup gate pre-check confirms cross-cutting terms (frontmatter / sandbox / native_ai_path) are NOT redefined here.

## Commits

| Task | Commit | Description |
|------|--------|-------------|
| 1 | `7a0e762` | feat(06-01): add phase6-structure-check.sh with per-section partition |
| 2 | `80bb3da` | feat(06-01): add platform-pipefy/SKILL.md (frontmatter + D-59 + D-68) |
| 3 | `80ba034` | feat(06-01): add platform-pipefy/references/api-contract.md |
| 4 | `13ff7cf` | feat(06-01): add platform-pipefy/references/native-ai-inventory.md |
| 5 | `d83e1ee` | feat(06-01): add Pipefy knowledge-ingestion + client-shape-gotchas + vocabulary |

## Assertion status (post-plan)

`bash phase6-structure-check.sh --section pipefy` exits 0 with all 10 Pipefy assertions PASS:
- A1 (Pipefy SKILL.md exists)
- A4-pipefy (5 references/ files exist)
- A5-pipefy (tier_claims_last_verified ISO date)
- A6-pipefy (native_ai_path enum in {paste, none})
- A8 (canonical endpoint + Q24 date 2026-05-10)
- A9 (HTML-on-auth-failure detection)
- A10 (paginate_all helper contract)
- A11 (web_host + org_id documented; tightened api_host: YAML-field-assignment-form absent)
- A14 (Pipefy throttle 13 req/sec Q06.2)
- A17-pipefy (capability matrix heading)

Full-suite run fails at A2 (Wrike SKILL.md not yet created — expected mid-phase state; owned by 06-02). A3 / A4-wrike / A4-ziflow / A12 / A13 / A15 / A16 / A17-wrike / A17-ziflow are gated until 06-02 + 06-03 + 06-04 land.

## Threat mitigations verified

- **T-06-02 (PLAT-05; native_ai_path: api banned-value leak):** `grep -rEn '^[[:space:]]*native_ai_path:[[:space:]]+api[[:space:]]*$' dydx-delivery/skills/platform-pipefy/ --exclude-dir=scripts --exclude='*.sh' --exclude='*~'` returns ZERO hits. Tightened REVIEWS C3 regex.
- **T-06-04 (UAT-4.1; api_host: removed-field regression):** `grep -rEn '^[[:space:]]*api_host[[:space:]]*:' dydx-delivery/skills/platform-pipefy/ --exclude-dir=scripts --exclude='*.sh' --exclude='*~'` returns ZERO hits. Tightened REVIEWS C2 regex. Prose scrub also avoids the bare token throughout api-contract.md (belt-and-suspenders per REVIEWS C2 (a)+(b)).

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 — Bug] native-ai-inventory.md IDP row label**
- **Found during:** Task 4 acceptance verification
- **Issue:** The plan body specified verbatim content for the capability matrix that read `| IDP (Intelligent Document Processing) | yes | AI Agents → IDP (Agents 2.0 native) | HIGH...` but the plan's own acceptance regex `^\| (Knowledge base|Skills|MCP integration|IDP|Web Search|BYO-LLM|KB content-upload via API) \|` requires the cell to be exactly the alternative (e.g., `| IDP |`). With the parenthetical present in the row label, only 6 of the required 7 rows matched, falling short of the acceptance criterion `>= 7`.
- **Fix:** Renamed the row label to `| IDP |` and moved the parenthetical "(Intelligent Document Processing)" into the Surface column where the same information already lived. Zero information loss; row count now 7/7.
- **Files modified:** `dydx-delivery/skills/platform-pipefy/references/native-ai-inventory.md`
- **Commit:** `13ff7cf`

No Rule 2/3/4 deviations.

## Q06.2 throttle resolution (inline per D-67)

Resolved **13 req/sec per token** (80% of 16.67 ceiling = 500 req / 30s per token, DESIGN-22 carried throttle pattern at `.planning/DESIGN.md:795`). Landed in `dydx-delivery/skills/platform-pipefy/references/api-contract.md § Rate limit + throttle` and reproduced literally as `throttle_req_per_sec=13` in the `paginate_all` pseudocode. Source: Pipefy Community + Pipefy Help Center (re-confirmed 2026-05-11) + Phase 5 connector-matrix.md `:72` baseline.

The OPEN-QUESTIONS.md row Status flip from `proposed` to `decided` is DEFERRED to synthesis plan 06-04 per D-67 single-plan-owner rule. 06-04 should:
- Locate `**OPEN-Q06.2**` row in `.planning/OPEN-QUESTIONS.md`
- Flip `- Status: proposed` → `- Status: decided`
- Add a one-line resolution citing `dydx-delivery/skills/platform-pipefy/references/api-contract.md § Rate limit + throttle` and the 13 req/sec value

## tier_claims_last_verified status

No fresh re-verification was performed during this execution. The baseline `2026-05-09` value remains in both SKILL.md frontmatter and native-ai-inventory.md. The manual VALIDATION § Manual-Only Verifications row 3 (Pipefy MCP tier claim re-verify vs current Pipefy AI Agents 2.0 docs) is deferred — the matrix's MCP row already flags itself for re-verify (`DESIGN-14 = HIGH; current research = MEDIUM`). If a reviewer performs that re-verify in a follow-up, the commit MUST include a `Verified-Against: <URL>` trailer per REVIEWS C6.

## Carry-forward notes for 06-02 (Wrike) and 06-03 (Ziflow)

1. **D-59 hard-rules pointer block** — copy verbatim from `dydx-delivery/skills/platform-pipefy/SKILL.md`'s `## Hard rules` block (it matches `dydx-delivery/skills/execute-tests/SKILL.md:20-22` verbatim, confirming the analog).
2. **Auth-shape secret-handling note** — lifted near-verbatim from `dydx-delivery/references/connector-matrix.md:31` and now landed at the top of `platform-pipefy/references/api-contract.md`; mirror the same block in `platform-wrike/references/api-contract.md` and `platform-ziflow/references/api-contract.md`.
3. **Per-section partition unblocks parallel Wave 2:** 06-02 should run `bash phase6-structure-check.sh --section wrike` for incremental self-verify (does NOT touch Ziflow files). 06-03 mirrors with `--section ziflow`. The cross-tree A7 + A16 gates only fire in full-run mode (no `--section` flag) — that's intentional and is owned by 06-04 synthesis.
4. **Capability-matrix row-label-vs-regex collision (deviation #1 above):** when seeding native-ai-inventory.md from DESIGN/RESEARCH text, prefer plain row labels (e.g. `| IDP |`, `| Copilot |`) over parenthetical expansions in the label cell — push expansions into the Surface column. The acceptance regex pattern is `^\| (capability-name) \|` so a parenthetical adjacent to the label breaks the match. 06-02 + 06-03 should pre-check their own row counts against the planned acceptance regex BEFORE commit.
5. **REVIEWS C4:** 06-01 deliberately did NOT pre-create `.gitkeep` placeholders for `platform-wrike/` or `platform-ziflow/`. Those directories are owned by 06-02 Task 1 + 06-03 Task 1 `mkdir -p` respectively.
6. **OPEN-QUESTIONS.md row flips:** all 3 (Q05 / Q06.2 / Q07.2) are deferred to synthesis plan 06-04 per D-67 single-plan-owner rule — DO NOT flip them inside 06-02 / 06-03.

## Self-Check: PASSED

Created files verified to exist:
- FOUND: `.planning/phases/06-internalise-platform-skills/scripts/phase6-structure-check.sh`
- FOUND: `dydx-delivery/skills/platform-pipefy/SKILL.md`
- FOUND: `dydx-delivery/skills/platform-pipefy/references/api-contract.md`
- FOUND: `dydx-delivery/skills/platform-pipefy/references/native-ai-inventory.md`
- FOUND: `dydx-delivery/skills/platform-pipefy/references/knowledge-ingestion.md`
- FOUND: `dydx-delivery/skills/platform-pipefy/references/client-shape-gotchas.md`
- FOUND: `dydx-delivery/skills/platform-pipefy/references/vocabulary.md`

Commits verified to exist in `git log --oneline -6`:
- FOUND: `7a0e762` (Task 1 — phase6-structure-check.sh)
- FOUND: `80bb3da` (Task 2 — SKILL.md)
- FOUND: `80ba034` (Task 3 — api-contract.md)
- FOUND: `13ff7cf` (Task 4 — native-ai-inventory.md)
- FOUND: `d83e1ee` (Task 5 — 3 remaining references/* files)

Structure check `--section pipefy` exits 0 with all 10 Pipefy assertions PASS. Full-suite run fails at A2 as expected (Wrike owned by 06-02).
