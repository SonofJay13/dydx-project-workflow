---
phase: 06-internalise-platform-skills
plan: 02
subsystem: platform-wrike
tags: [platform-skills, wrike, oauth-host, q07-2, copilot, mcp, mod-5, design-15]
dependency_graph:
  requires:
    - 06-01 (phase6-structure-check.sh --section wrike runner)
    - Phase 5 canonical references (safety-rules.md, connector-matrix.md, glossary.md)
    - DESIGN-15 OAuth-host rule (.planning/DESIGN.md:459-500)
    - D-59 / D-65 / D-66 / D-67 / D-68 (06-CONTEXT.md)
  provides:
    - dydx-delivery/skills/platform-wrike/SKILL.md (PLAT-02 base)
    - dydx-delivery/skills/platform-wrike/references/api-contract.md (MOD-5 OAuth-host pattern + Q07.2 throttle inline)
    - dydx-delivery/skills/platform-wrike/references/native-ai-inventory.md (Copilot + 16-tool MCP baseline)
    - dydx-delivery/skills/platform-wrike/references/knowledge-ingestion.md (UAT-6.1 paste-only)
    - dydx-delivery/skills/platform-wrike/references/client-shape-gotchas.md (VodafoneZiggo EU seed)
    - dydx-delivery/skills/platform-wrike/references/vocabulary.md (Wrike-specific terms, D-66 dedup)
  affects:
    - Stage 4a / 7b / 8 / 10 (downstream consumers of platform-wrike capability matrix)
    - 06-04 synthesis (OPEN-Q07.2 row flip to decided; cross-tree A7/A16 final gate)
tech_stack:
  added: []
  patterns:
    - OAuth-host 3-step persistence pattern (MOD-5 / DESIGN-15) — extract → persist client_state.yaml wrike.host: → use as base URL
    - 7-part helper-contract shape (Signature + Behaviour + Persistence + Retry/poll budget + Failure modes + Pseudocode + Worked examples) per D-64
    - Throttle = 80% of published ceiling (DESIGN-22 carried pattern: 320 req/min/user vs 400 ceiling)
    - D-59 uniform hard-rules pointer (verbatim from Pipefy sibling)
    - D-68 event-based re-verification trigger (consumer-coupled, not calendar-based)
key_files:
  created:
    - dydx-delivery/skills/platform-wrike/SKILL.md
    - dydx-delivery/skills/platform-wrike/references/api-contract.md
    - dydx-delivery/skills/platform-wrike/references/native-ai-inventory.md
    - dydx-delivery/skills/platform-wrike/references/knowledge-ingestion.md
    - dydx-delivery/skills/platform-wrike/references/client-shape-gotchas.md
    - dydx-delivery/skills/platform-wrike/references/vocabulary.md
  modified: []
key_decisions:
  - Q07.2 throttle resolved inline as 320 req/min per user (80% of 400 ceiling per DESIGN-22) — landed in api-contract.md § Rate limit + throttle; OPEN-QUESTIONS.md row flip deferred to 06-04 synthesis
  - tier_claims_last_verified left at 2026-05-09 baseline; no fresh re-verification performed during execution (16-vs-47 MCP-count delta surfaced as flag for downstream PLAT-02 manual reviewer check per VALIDATION § Manual-Only Verifications row 2)
  - Worked examples / URL refs to www.wrike.com preserved in MCP availability section per REVIEWS C5 (A12 narrowed to prohibition-phrase-presence only)
metrics:
  duration: ~25 min
  completed: 2026-05-11
  tasks_completed: 4
  files_created: 6
  commits: 4
---

# Phase 6 Plan 02: platform-wrike Summary

Wrike platform reference skill landed end-to-end — 1 SKILL.md + 5 references/ files, all per-section assertions PASS via `--section wrike`, OAuth-host persistence pattern documented as a 3-step pseudocode contract, Q07.2 throttle calibration (320 req/min/user) resolved inline.

## Tasks executed

| Task | Name | Commit | Files |
|---|---|---|---|
| 1 | Scaffold SKILL.md + mkdir tree | 138c62b | `dydx-delivery/skills/platform-wrike/SKILL.md` (+ `references/` dir) |
| 2 | api-contract.md — OAuth-host 3-step + Q07.2 throttle | db1f9e7 | `dydx-delivery/skills/platform-wrike/references/api-contract.md` |
| 3 | native-ai-inventory.md — 4-row Copilot + MCP matrix | b168687 | `dydx-delivery/skills/platform-wrike/references/native-ai-inventory.md` |
| 4 | knowledge-ingestion + client-shape-gotchas + vocabulary | 43aa4ef | `references/{knowledge-ingestion.md, client-shape-gotchas.md, vocabulary.md}` |

## Must-haves landed (per plan frontmatter)

1. **SKILL.md frontmatter** — `name: platform-wrike`, `platform: wrike`, `frontmatter_version: 2`, `tier_claims_last_verified: 2026-05-09`, `native_ai_path: paste` — all 5 required fields present and grep-verifiable. ✓
2. **OAuth-host persistence pattern (MOD-5)** — 3-step pseudocode (`on_oauth_complete` → persist `wrike.host:` → `wrike_base_url` → `list_tasks` example), failure modes (3 explicit raises), worked examples (US-2 + VodafoneZiggo EU). ✓
3. **Q07.2 throttle inline** — 320 req/min/user (80% of 400 ceiling per DESIGN-22) landed in § Rate limit + throttle of api-contract.md. ✓
4. **Capability matrix** — 4 rows (Wrike Copilot HIGH / MCP Server 16-tool baseline / Attach-doc-via-MCP MEDIUM / AI Studio API CLOSED per UAT-6.1) with 16-vs-47 delta flagged for manual re-verify. ✓
5. **VodafoneZiggo EU seed** (D-65) — verbatim from DESIGN-15: `app-eu.wrike.com`, account `5996999`, entry URL `https://app-eu.wrike.com/workspace.htm?acc=5996999`. ✓
6. **D-66 vocabulary** — 10 Wrike-specific terms (space / folder / project / task / custom field / host / account_id / space_id / Wrike Copilot / MCP Server); zero collision with project glossary cross-cutting terms (frontmatter / sandbox / native_ai_path / status: lifecycle). ✓
7. **D-59 hard-rules pointer** — verbatim from Pipefy sibling 06-01 (one-line `dydx-delivery/references/safety-rules.md` reference inside blockquote). ✓
8. **D-68 re-verification trigger** — H2 with Wrike doc URLs (`developers.wrike.com/wrike-mcp/` + `www.wrike.com/ai/mcp/`). ✓

## Threat mitigations verified

- **T-06-02 (banned-token leakage):** `grep -rE '^[[:space:]]*native_ai_path:[[:space:]]+api[[:space:]]*$' dydx-delivery/skills/platform-wrike/` returns ZERO hits across all 6 files. Forbidden third-enum YAML field assignment NEVER written. Plans-level prose scrub successful (referred to as "the forbidden third enum value" / "the previously-considered API ingestion path" throughout).
- **T-06-03 (hardcoded host):** Literal prohibition phrase ``NEVER hardcode `www.wrike.com` `` present in api-contract.md (3 occurrences in distinct contexts: scope-lock callout, endpoint-section CRITICAL note, anti-pattern callout). REVIEWS C5 narrowing honoured — worked examples + URL refs to `www.wrike.com` ARE preserved (MCP availability section).

## Verification

```
$ bash .planning/phases/06-internalise-platform-skills/scripts/phase6-structure-check.sh --section wrike
PASS: A2: Wrike SKILL.md exists
PASS: A4-wrike: 5 references/ files exist
PASS: A5-wrike: tier_claims_last_verified ISO date present
PASS: A6-wrike: native_ai_path enum valid
PASS: A12: Wrike OAuth-host persistence + prohibition phrase present
PASS: A15: Wrike throttle (Q07.2) documented
PASS: A17-wrike: Wrike capability matrix present
ALL ASSERTIONS PASSED
```

All 7 Wrike-section assertions PASS. Cross-tree assertions A7 + A16 remain owned by 06-04 (synthesis) and may continue to FAIL until that plan runs (expected per plan frontmatter).

## Deviations from Plan

None — plan executed exactly as written. No bugs, missing functionality, or blockers encountered. The 4-task structure landed atomically with no Rule 1/2/3 auto-fixes required.

## REVIEWS carry-forward confirmations

- **REVIEWS C4 (directory ownership):** Task 1 ran `mkdir -p dydx-delivery/skills/platform-wrike/references/` — no `.gitkeep` placeholders pre-created in 06-01, no leftover artefacts in the Wrike tree.
- **REVIEWS C5 (A12 narrowing):** A12 gate is phrase-presence only. Worked examples (US-2 + VodafoneZiggo EU host strings) + URL references to `www.wrike.com/ai/mcp/` in the MCP availability section preserved without triggering false-positive.
- **REVIEWS C3 (T-06-02 tightened regex):** Cross-tree A7 gate uses YAML-field-assignment regex `^[[:space:]]*native_ai_path:[[:space:]]+api[[:space:]]*$` — no narrative mentions in committed prose, plus belt-and-suspenders scrub (prose refers to "the forbidden third enum value" throughout).
- **REVIEWS C6 (audit-trail reminder):** Audit-trail requirement (`Verified-Against: <URL>` commit trailer) carried into native-ai-inventory.md tail; not exercised this plan (no re-verification bump performed).
- **REVIEWS C9 (per-platform-maintained wording):** Plan frontmatter said "per-platform maintained" (same baseline as Pipefy + Ziflow allowed) — baseline 2026-05-09 preserved as-is from D-68 default.

## Carry-forward notes for 06-03 (Ziflow)

- The 3-step OAuth-host pseudocode pattern (vs. a single callable helper) works for "pattern" shapes — Ziflow `wait_for_proof` is a single helper so will use the standard 7-part contract shape, not the pattern variant.
- A12 prohibition-phrase grep gate proves mid-phase under REVIEWS C5 narrowed semantics — worked examples + URL refs to `www.wrike.com` in MCP-availability sections are demonstrably allowed.
- Task-1 `mkdir -p` pattern (REVIEWS C4) works — 06-03 should likewise own the `platform-ziflow/references/` mkdir in its Task 1, not depend on placeholder scaffolding.

## Known Stubs

None. All matrix rows are 2026-vendor-grounded (HIGH confidence for Wrike Copilot; MCP Server marked with 16-vs-47 delta flag and explicit MEDIUM/CLOSED disposition rather than placeholder content).

## Self-Check: PASSED

**Files verified exist:**
- ✓ `dydx-delivery/skills/platform-wrike/SKILL.md`
- ✓ `dydx-delivery/skills/platform-wrike/references/api-contract.md`
- ✓ `dydx-delivery/skills/platform-wrike/references/native-ai-inventory.md`
- ✓ `dydx-delivery/skills/platform-wrike/references/knowledge-ingestion.md`
- ✓ `dydx-delivery/skills/platform-wrike/references/client-shape-gotchas.md`
- ✓ `dydx-delivery/skills/platform-wrike/references/vocabulary.md`

**Commits verified in git log:**
- ✓ 138c62b (Task 1 — SKILL.md scaffold)
- ✓ db1f9e7 (Task 2 — api-contract.md)
- ✓ b168687 (Task 3 — native-ai-inventory.md)
- ✓ 43aa4ef (Task 4 — knowledge-ingestion + client-shape-gotchas + vocabulary)

**Structure check `--section wrike`:** PASS (7/7 assertions green).

**Cross-tree T-06-02 sweep across `dydx-delivery/skills/platform-wrike/`:** zero YAML-field-assignment hits.
