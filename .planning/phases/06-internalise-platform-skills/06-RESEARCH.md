# Phase 6: Internalise Platform Skills — Research

**Researched:** 2026-05-11
**Domain:** Markdown-only platform-skill authoring — Pipefy GraphQL / Wrike REST / Ziflow REST API surface contracts + 2026 native-AI capability matrices + per-platform helper documentation contracts
**Confidence:** HIGH (locked architecture from v2.0 DESIGN + Phase 5 connector-matrix; Q06.2 / Q07.2 derive from Phase 5-resolved Q06.1 / Q07.1; Q05 has authoritative vendor guidance — webhooks-over-polling)

## Summary

Phase 6 is **doc-only** authoring of 18 markdown files (3 × `SKILL.md` + 3 × 5-file `references/`) plus a synthesis structure-check script and 3 `.planning/OPEN-QUESTIONS.md` row flips. There is no executable code. The architecture is fully locked: DESIGN-14 / DESIGN-15 / DESIGN-16 specify the 5-file `references/` shape and per-platform helper contracts; UAT-3.5 locks API-first (no MCP adoption through v2.6); UAT-4.1 locks Pipefy canonical-only API endpoint (`api.pipefy.com/graphql`) + HTML-on-auth-failure gotcha; UAT-6.1 locks `native_ai_path:` enum to `paste | none` ONLY. Phase 5's connector-matrix.md already resolved the published-rate-limit half of the throttle questions (Q06.1 = 500 req/30s ≈ 16.67 req/sec per token throttled to 13 req/sec; Q07.1 = 400 req/min per user throttled to 320 req/min); Q06.2 / Q07.2 are the per-helper retry/backoff derivations consuming those numbers.

The single piece of genuine new web research is Q05 (Ziflow read-after-create consistency window). Vendor guidance is unambiguous: **Ziflow explicitly recommends webhooks instead of polling**, with the canonical pattern being "subscribe to the `processed` event webhook before creating the proof so your app knows when proofs are ready." The DESIGN-16 default of 30s budget / 2s interval is a **conservative fallback for environments where webhooks aren't wired**, not the primary recommended path. The `api-contract.md` for Ziflow should document webhooks as PRIMARY and `wait_for_proof` polling as the documented FALLBACK helper.

**Primary recommendation:** Per-platform-skill authoring follows the locked 5-file shape; planner can decompose 3 plans (per-platform, per CONTEXT D-63) with synthesis (shape-parity + OPEN-Q row flips + structure-check) folded into 06-03 or split to 06-04 per the ~400 LOC threshold. Pipefy = lift DESIGN-14 verbatim + document HTML-on-auth-failure + author `paginate_all` contract. Wrike = lift DESIGN-15 verbatim + document OAuth-host persistence pattern. Ziflow = lift DESIGN-16 verbatim + document `wait_for_proof` polling **as fallback** plus webhook-primary path + flip Q05 to `decided` with 30s/2s default. All 3 platform SKILL.md files carry the locked frontmatter contract (`platform:` + `tier_claims_last_verified:` + `native_ai_path: paste | none`) and the D-59 uniform-pointer to `dydx-delivery/references/safety-rules.md`.

## User Constraints (from CONTEXT.md)

### Locked Decisions

- **D-63 — Plan slicing:** 3 plans, per-platform (`06-01-PLAN.md` Pipefy / `06-02-PLAN.md` Wrike / `06-03-PLAN.md` Ziflow + synthesis). Synthesis-folding rule: if 06-03 exceeds ~400 LOC of plan content, planner splits synthesis to `06-04-PLAN.md`. Plans CAN execute in parallel (distinct directories); file-ownership conflict only on `.planning/OPEN-QUESTIONS.md` (3 row flips) — that work is concentrated in the synthesis plan.
- **D-64 — Helper code shape:** Doc-only contracts + pseudocode in `api-contract.md`. NO executable `.py` / `.js` files in Phase 6. NO `skills/platform-*/helpers/` directories (not even empty `.gitkeep`). Stage 8 test bot (v2.4 / Phase 8) authors real helpers against the doc contract.
- **D-65 — `client-shape-gotchas.md` seeding:** Two sections per platform: `## Known shapes (verified)` (concrete examples lifted verbatim from DESIGN.md — Vodacom Pipefy custom-subdomain / VodafoneZiggo Wrike EU `app-eu.wrike.com` account `5996999` / Ziflow Acme placeholder) + `## Pattern slots` (variant taxonomy). One-line append-only preamble. NO `last_shape_added` frontmatter field.
- **D-66 — `vocabulary.md` scope:** Platform-specific terms only. Opens with one-line pointer to `dydx-delivery/references/glossary.md`. NO duplication of project-wide terms. Synthesis grep gate confirms zero duplicate-defines against glossary.md.
- **D-67 — OPEN-Q resolution:** Inline per-platform plan-wave. Q05 → 06-03 (Ziflow); Q06.2 → 06-01 (Pipefy); Q07.2 → 06-02 (Wrike). Resolved values land in respective `api-contract.md`. OPEN-QUESTIONS.md row flips concentrated in synthesis (single-plan ownership).
- **D-68 — `tier_claims_last_verified:` semantics:** Per-platform last-vendor-docs-check date (DISTINCT per platform, NOT shared). Default baseline `2026-05-09` (DESIGN.md native-AI matrix authoring date). Each SKILL.md carries explicit `## Re-verification trigger` subsection naming downstream consumers (Stage 4a / 7b / 10).
- **UAT-3.5 — MCPs OUT-OF-SCOPE through v2.6.** All 3 `api-contract.md` files are API-first. Pipedream Pipefy MCP + Wrike MCP are parked references only. Ziflow has no MCP.
- **UAT-6.1 — Native-AI ingestion APIs OUT-OF-SCOPE entirely.** `native_ai_path:` enum LOCKED to `paste | none` ONLY across all 3 platform skills. `api` branch is FORBIDDEN. `grep -r 'native_ai_path: api' skills/platform-*/` MUST return zero hits.
- **UAT-4.1 — Pipefy API canonical-only (Q24 verified 2026-05-10).** `api.pipefy.com/graphql` for ALL tenants. Only `web_host` + `org_id` vary per tenant. NO `api_host` field. **HTML-on-auth-failure gotcha** (Keycloak login HTML, `Content-Type: text/html`, NOT JSON 401) MUST be documented in `platform-pipefy/references/api-contract.md`.
- **MOD-4 / MOD-5 / MOD-6 / MOD-7 helper + frontmatter contracts** as listed in CONTEXT.

### Claude's Discretion

- **Synthesis-plan split threshold (~400 LOC)** — planner discretion at `/gsd-plan-phase` time.
- **Parallel execution scheduling** under `/gsd-execute-phase 6` — executor discretion; safe per D-63 file-ownership analysis.
- **Exact line citations to DESIGN.md sections** in the canonical_refs section — line numbers verified at write time against current DESIGN.md.
- **Optional fresh re-verification of native-AI matrices** at execution time (D-68): if a plan task does a fresh vendor-docs check, `tier_claims_last_verified:` is updated to the execution date.

### Deferred Ideas (OUT OF SCOPE)

- Executable helper modules at `skills/platform-*/helpers/*.py` → Phase 8 / v2.4 (DESIGN-28..30 Stage 8 test bot rebuild).
- `skills/platform-*/helpers/` empty-stub directories → rejected entirely.
- Calendar-based `tier_claims_last_verified:` re-verification trigger (">90 days") → re-evaluate post-v2.6.
- MCP adoption for Pipefy / Wrike (Pipedream MCP / Wrike MCP) → UAT-3.5 parks through v2.6.
- Native-AI ingestion API branch (`native_ai_path: api`) → UAT-6.1 closes entirely.
- Plugin self-test pytest harness for helper pseudocode → OPEN-Q22 routes to Phase 9.
- Q05 / Q06.2 / Q07.2 deep-research escalation → D-67 inline resolution assumes items are small and self-contained; escalate via spawned `gsd-phase-researcher` agent against a single question if inline surfaces unexpected depth — NOT by widening Phase 6 scope.

## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| PLAT-01 | `skills/platform-pipefy/SKILL.md` + 5-file `references/` shape per (REVISED) DESIGN-14 — canonical-only `api.pipefy.com/graphql` + HTML-on-auth-failure gotcha + `paginate_all` helper contract + 2026 AI Agents 2.0 capability matrix | §Standard Stack (Pipefy row), §Helper-Function Specs (paginate_all), §5-File References Outline (Pipefy column), §Native-AI Capability Matrices (Pipefy table) |
| PLAT-02 | `skills/platform-wrike/SKILL.md` + 5-file `references/` shape per DESIGN-15 — OAuth-host persistence pattern + Copilot + 47-tool MCP server inventory + attach-doc-via-MCP knowledge ingestion | §Standard Stack (Wrike row), §Helper-Function Specs (OAuth host persistence), §5-File References Outline (Wrike column), §Native-AI Capability Matrices (Wrike table) |
| PLAT-03 | `skills/platform-ziflow/SKILL.md` + 5-file `references/` shape per DESIGN-16 — `wait_for_proof` helper (as FALLBACK; webhook-primary documented) + ReviewAI Checklists Public Preview + Change Verification + Brand Standards 2026 matrix | §Standard Stack (Ziflow row), §Helper-Function Specs (wait_for_proof), §Q05 Resolution, §Native-AI Capability Matrices (Ziflow table) |
| PLAT-04 | `tier_claims_last_verified:` frontmatter on each platform SKILL.md (per-platform distinct date per D-68) | §Frontmatter Schema, §Re-verification Trigger Boilerplate |
| PLAT-05 | `native_ai_path:` enum locked to `paste \| none` ONLY (no `api` branch) across all 3 platform skills | §Frontmatter Schema (enum lock), §Validation Architecture (grep gate A8) |
| PLAT-06 | Resolve Q05 / Q06.2 / Q07.2 inline | §Q05 Resolution, §Q06.2 Resolution, §Q07.2 Resolution, §Validation Architecture (OPEN-Q row-flip assertions) |

## Project Constraints (from CLAUDE.md)

No project-level `CLAUDE.md` file is present at the repo root. The Phase 6 constraints derive entirely from `.planning/` (CONTEXT / DESIGN / CHANGELIST / OPEN-QUESTIONS / REQUIREMENTS / ROADMAP) and the Phase 5 canonical references at `dydx-delivery/references/`. Memory files (`feedback_platform_skills_api_first.md` / `reference_client_brain_coda_docs.md`) encode UAT-3.5 and the 2-documented-clients context per CONTEXT `<canonical_refs>`.

## Architectural Responsibility Map

| Capability | Primary Tier | Secondary Tier | Rationale |
|------------|-------------|----------------|-----------|
| Platform-skill content (SKILL.md + 5 references files) | Plugin skill content (Claude Code agent skill surface) | — | Skills are consumed by Claude Code agents at session start when `platform:` frontmatter matches. Pure Markdown — no runtime. |
| API contract specification (`api-contract.md`) | Plugin skill content | Stage 8 test bot (downstream consumer, v2.4 / Phase 8) | Doc-only contract per D-64 / D-56 precedent; test bot translates pseudocode → Python in Phase 8. |
| Helper pseudocode (`paginate_all` / `wait_for_proof` / OAuth-host persistence) | Documentation contract (Markdown) | Stage 8 test bot (executable consumer) | Phase 6 ships interface signature + behaviour + retry budget + pseudocode + worked example. NO executable code. |
| Native-AI capability matrix (`native-ai-inventory.md`) | Plugin skill content (human-readable reference) | Stage 4a (delivery routing), Stage 7b (implementation prompt), Stage 10 (paste bundle) | Read by Claude at session start to inform routing decisions; `native_ai_path:` enum drives Stage 10 paste-only behaviour per UAT-6.1. |
| Frontmatter contract (`platform:` / `tier_claims_last_verified:` / `native_ai_path:`) | Plugin skill metadata | `validate-frontmatter` hook (substantive impl deferred to v2.6 / SURF-01..03) | Hook validates enum membership + platform-gated identifier rules. Phase 6 establishes the schema; v2.6 enforces. |
| OPEN-QUESTIONS.md row-flip (Q05 / Q06.2 / Q07.2) | Project planning state | Synthesis plan (single-owner write) | Concentrated in 06-03 trailing or 06-04 split per D-67 — avoids inter-plan conflict on `.planning/OPEN-QUESTIONS.md`. |
| Shape-parity verification | Phase 6 structure-check script | — | `scripts/phase6-structure-check.sh` (synthesis-plan deliverable) — mirrors Phase 5 pattern (~40 PASS assertions). |

## Standard Stack

### Core

Phase 6 is **doc-only Markdown** — there is no library stack to install. The "stack" is the locked content contracts from v2.0 DESIGN + Phase 5 canonical references.

| Asset | Version / Date | Purpose | Why Standard |
|---|---|---|---|
| `dydx-delivery/references/safety-rules.md` | Phase 5 LIVE (FOUND-01) | Canonical hard-rules SoT; pointed at by every platform SKILL.md via D-59 uniform-pointer | Single SoT pattern per DESIGN-03; AUDIT-05.1 hard-rules-duplication anti-pattern prevention |
| `dydx-delivery/references/stage-numbering.md` | Phase 5 LIVE (FOUND-02) | Canonical 11-stage list + substage scheme `4a/4b/7a/7b/8a-8d`; platform skills cite downstream consumer stages by canonical prefix | DESIGN-02 stage-numbering scheme |
| `dydx-delivery/references/frontmatter-scheme.md` | Phase 5 LIVE (FOUND-03) | Canonical frontmatter scheme (status lifecycle / field-name conventions / platform-gated identifiers / `frontmatter_version: 2`) | DESIGN-01 frontmatter scheme; platform SKILL.md frontmatter conforms |
| `dydx-delivery/references/glossary.md` | Phase 5 LIVE (FOUND-04) | Project-wide vocabulary; per-platform `vocabulary.md` points at this for cross-cutting terms | DESIGN-01 + D-66 single-SoT-for-vocabulary |
| `dydx-delivery/references/connector-matrix.md` | Phase 5 LIVE (FOUND-10) | Per-platform API auth contract + throttle ceilings (Q06.1 / Q07.1 / Q25 inline-resolved); Phase 6 Q06.2 / Q07.2 throttle CALIBRATION reads from this | FOUND-10 / D-56 doc-only pattern |
| Existing v0.3.0 SKILL.md frontmatter shape | `dydx-delivery/skills/discovery-intake/SKILL.md` + 6 siblings (normalised to `frontmatter_version: 2` by Phase 5 FOUND-05) | Frontmatter scheme template — Phase 6 NEW platform SKILL.md uses same shape + adds `platform:` / `tier_claims_last_verified:` / `native_ai_path:` per-platform fields | DESIGN-01 + Phase 5 FOUND-05 normalisation |

### Vendor Doc Landscape (2026 — verification anchors for native-AI matrices)

| Platform | Vendor doc anchor | Verified content (2026-05-11) | Confidence |
|---|---|---|---|
| Pipefy | `https://www.pipefy.com/` + Pipefy Community + Pipefy Help Center | AI Agents 2.0 launched Nov 2025; KB + Skills + MCP + IDP + Web Search + BYO-LLM tiers per `globenewswire.com/news-release/2025/11/12/3186348` + `processexcellencenetwork.com/ai/news/pipefy-launches-ai-agents-20`. **GraphQL rate limit:** 500 requests per 30-second window per token = 16.67 req/sec ceiling per `community.pipefy.com/customs-apps-integrations-75/what-are-the-graphql-api-limits-958`. Pipe Reports Export sub-limit 25 req / 24h per pipe. | HIGH for rate limit; HIGH for AI Agents 2.0 launch announcement; **LOW for "MCP integration: yes" claim** — DESIGN-14 lifted from research that pre-dates AI Agents 2.0; one 2026 secondary source (`kore.ai/blog/best-ai-agent-management-platforms`) states "Pipefy is not designed to ingest agents built on third-party frameworks through standard protocols like A2A or MCP" — flag for fresh re-verification at PLAT-01 execution. |
| Wrike | `https://developers.wrike.com/` + `https://help.wrike.com/` + `https://www.wrike.com/ai/mcp/` | **REST rate limit:** 400 req/min per user + 5000 req/min per IP; 429 status above that per `help.wrike.com/hc/en-us/articles/23908384596631-Resolve-Common-REST-API-Errors`. **Wrike MCP Server:** GA per `wrike.com/newsroom/wrike-launches-mcp-server-empowering-third-party-ai-agents`; **47 tools** per `stackone.com/connectors/wrike/mcp/` (NB: DESIGN-15 lists "16 MCP tools" — number has grown since DESIGN authoring; re-verification recommended at PLAT-02). Copilot real-time AI assistance for enterprise teams per `reworked.co/collaboration-productivity/wrike-expands-copilot-with-real-time-ai-assistance`. | HIGH for rate limit; HIGH for MCP server GA; MEDIUM for tool count (DESIGN-15 = 16; current stack vendor = 47; reconcile at execution) |
| Ziflow | `https://api-docs.ziflow.com/` + `https://www.ziflow.com/reviewai` + Ziflow Help Center | **ReviewAI Checklists:** Public Preview status confirmed per `help.ziflow.com/hc/en-us/articles/41711066855956-Use-ReviewAI` + `ziflow.com/blog/introducing-checklists-more-creative-reviews`. **Change Verification + Brand Standards:** Coming Soon — features announced; not yet GA per `ziflow.com/reviewai` + `ziflow.com/blog/take-control-of-your-review-and-approval-process`. **April 2026 release notes (26.08):** Checklist Templates API endpoints shipped per `help.ziflow.com/hc/en-us/articles/48181732374676-April-2026-release-notes-26-08`. **Read-after-create / polling:** Ziflow officially recommends **webhooks instead of polling** per `help.ziflow.com/hc/en-us/articles/30725068740244-Webhooks` + `help.ziflow.com/hc/en-us/articles/30721919730836-Embedded-Review-Approval` — the canonical pattern is subscribe to `processed` event webhook BEFORE proof creation. | HIGH for ReviewAI feature states; HIGH for webhook-vs-polling guidance; the 30s/2s polling defaults are documented as conservative fallback for webhook-unavailable environments |

### Alternatives Considered (and rejected at v2.0 design-lock)

| Instead of | Could Use | Tradeoff | Rejection rationale |
|---|---|---|---|
| Doc-only `api-contract.md` with pseudocode | Executable `.py` / `.js` helper modules at `skills/platform-*/helpers/` | Real code with tests now | D-64 + OPEN-Q22 — no caller, no harness, no tests in Phase 6; Stage 8 test bot is the runtime consumer (v2.4 / Phase 8). Shipping helpers without a caller creates dead code that drifts. |
| API-first `api-contract.md` | MCP-first (Pipedream Pipefy MCP / Wrike MCP) | Use vendor-blessed MCP servers as adoption path | UAT-3.5 — MCPs OUT-OF-SCOPE through v2.6; re-evaluated post-first-real-client-engagement. MCPs may be cited as parked references but never as adoption path. Ziflow has no MCP. |
| `native_ai_path: paste \| none` only | `native_ai_path: api \| paste \| none` | Direct-API ingestion path | UAT-6.1 — Native-AI ingestion APIs OUT-OF-SCOPE entirely; Q01/Q02/Q03 closed; Stage 10 paste-bundle + audit log only; humans upload manually via each platform's UI. |
| Per-tenant `pipefy_web_host:` + `pipefy_org_id:` (no api_host) | Per-tenant `pipefy_api_host:` field | Multi-tenant API endpoint variation | UAT-4.1 — Q24 DNS verification 2026-05-10: `api.<subdomain>.pipefy.com` does NOT resolve for custom-subdomain tenants; all GraphQL traffic routes through canonical `api.pipefy.com/graphql`. `api_host` field REMOVED from DESIGN-29. |
| Wrike OAuth-host-persisted | Hardcoded `www.wrike.com` | Simpler client | MOD-5 / DESIGN-15 — hardcoding breaks multi-tenant; OAuth token response carries customer's regional host (e.g., `app-us2.wrike.com` / `app-eu.wrike.com`); the persisted `host` MUST be the base URL for every subsequent API call. |
| Per-platform `vocabulary.md` (lean) | Duplicate cross-cutting terms in each vocabulary.md | Skill self-containment | D-66 — re-introduces AUDIT-05 hard-rules duplication anti-pattern at vocabulary layer; Phase 5 D-59 / FOUND-04 made glossary.md the project-wide SoT. |

**Installation:**
```bash
# Phase 6 is doc-only. No installation required.
# Plans create directories + write Markdown files only.
mkdir -p dydx-delivery/skills/platform-pipefy/references
mkdir -p dydx-delivery/skills/platform-wrike/references
mkdir -p dydx-delivery/skills/platform-ziflow/references
mkdir -p .planning/phases/06-internalise-platform-skills/scripts
```

**Version verification:** No package versions to verify. Vendor doc anchor dates verified above in §Vendor Doc Landscape table (publication dates checked against current help-center URLs as of 2026-05-11).

## Architecture Patterns

### System Architecture Diagram

```
                       ┌─ User says: "kick off Stage 7b for Acme on Pipefy" ──┐
                       │                                                       │
                       v                                                       │
        ┌──────────────────────────────────┐    reads frontmatter              │
        │ Claude Code agent (session start)│ ───────► artefact `platform:` ────┘
        └──────────────────────────────────┘
                       │
                       │ loads matching platform skill
                       v
   ┌────────────────────────────────────────────────────────┐
   │ skills/platform-{pipefy | wrike | ziflow}/SKILL.md     │  (Phase 6 OUTPUT)
   │ + frontmatter: platform / tier_claims_last_verified /  │
   │   native_ai_path: paste | none / D-59 hard-rules ptr   │
   └────────────────────────────────────────────────────────┘
                       │
                       │ on-demand reference reads
                       v
   ┌──────────────────────────────────────────────────────────────────────────┐
   │ references/                                                              │
   │ ├── api-contract.md          ◄── Stage 8 test bot (v2.4 / Phase 8) reads │
   │ │   • endpoints / auth shape / rate-limit ceiling + throttle             │
   │ │   • per-platform helper contract (signature + pseudocode + retry)      │
   │ │   • [Pipefy] HTML-on-auth-failure gotcha (UAT-4.1)                     │
   │ │   • [Pipefy] paginate_all(query, cursor_field) contract (MOD-4)        │
   │ │   • [Wrike]  OAuth-host persistence pattern (MOD-5)                    │
   │ │   • [Ziflow] webhook-PRIMARY + wait_for_proof FALLBACK (MOD-6)         │
   │ ├── native-ai-inventory.md   ◄── Stage 4a routing / Stage 7b prompt /    │
   │ │                                Stage 10 paste bundle all read this     │
   │ │   • 2026-grounded capability matrix per DESIGN-14 / 15 / 16            │
   │ │   • tier_claims_last_verified: per D-68                                │
   │ ├── knowledge-ingestion.md   ◄── Stage 10 (v2.5) paste-bundle author     │
   │ │   • UAT-6.1: paste-only path documented; no API branch                 │
   │ ├── client-shape-gotchas.md  ◄── Stage 4a / Stage 7b read for shape      │
   │ │   • ## Known shapes (verified) — DESIGN.md examples verbatim per D-65  │
   │ │   • ## Pattern slots — variant taxonomy (append-only per first eng.)   │
   │ └── vocabulary.md            ◄── Skill author / human reviewer reads     │
   │     • Platform-specific terms only (per D-66)                            │
   │     • Pointer to glossary.md for project-wide terms                      │
   └──────────────────────────────────────────────────────────────────────────┘
                       │
                       │ structural verifications at synthesis
                       v
   ┌──────────────────────────────────────────────────────┐
   │ scripts/phase6-structure-check.sh (synthesis output) │  (mirror Phase 5)
   │ ~40 PASS assertions:                                 │
   │ • per-file existence (18 files)                      │
   │ • 5-file shape parity across 3 platforms             │
   │ • uniform hard-rules pointer present in each SKILL.md│
   │ • zero hits: `grep -r 'native_ai_path: api' ...`     │
   │ • `tier_claims_last_verified:` present in each SK    │
   │ • OPEN-QUESTIONS.md Q05/Q06.2/Q07.2 = `decided`      │
   │ • vocabulary dedup (zero hits for glossary terms)    │
   └──────────────────────────────────────────────────────┘
```

### Recommended Project Structure

```
dydx-delivery/skills/platform-pipefy/
├── SKILL.md
└── references/
    ├── api-contract.md           # GraphQL + paginate_all + HTML-auth gotcha + rate limit
    ├── native-ai-inventory.md    # AI Agents 2.0 matrix (KB / Skills / MCP / IDP / Web Search / BYO-LLM)
    ├── knowledge-ingestion.md    # Paste-only path (UAT-6.1); KB upload list shape
    ├── client-shape-gotchas.md   # Vodacom custom-subdomain seed + pattern slots
    └── vocabulary.md             # pipe / phase / card / connection / org_id / web_host

dydx-delivery/skills/platform-wrike/
├── SKILL.md
└── references/
    ├── api-contract.md           # REST + OAuth-host persistence + rate limit (400 req/min/user)
    ├── native-ai-inventory.md    # Copilot + MCP server (47 tools per 2026 stackone vendor count)
    ├── knowledge-ingestion.md    # attach-doc-via-MCP path + paste fallback
    ├── client-shape-gotchas.md   # VodafoneZiggo EU app-eu.wrike.com seed + pattern slots
    └── vocabulary.md             # space / folder / project / task / custom field / host / account_id

dydx-delivery/skills/platform-ziflow/
├── SKILL.md
└── references/
    ├── api-contract.md           # REST + webhook-PRIMARY + wait_for_proof FALLBACK
    ├── native-ai-inventory.md    # ReviewAI Checklists Public Preview + Change Verification / Brand Standards Coming Soon
    ├── knowledge-ingestion.md    # Checklist-generation path + copy-paste fallback (UAT-6.1)
    ├── client-shape-gotchas.md   # Acme placeholder seed + <TBD at first engagement> pattern slot
    └── vocabulary.md             # proof / review / decision / stage / version / project_id

.planning/phases/06-internalise-platform-skills/scripts/
└── phase6-structure-check.sh    # ~40 PASS assertions (synthesis plan deliverable)
```

### Pattern 1: D-59 Uniform Hard-Rules Pointer (Phase 5 carried verbatim)

**What:** Every new platform SKILL.md carries the identical one-line pointer to the Phase 5 canonical `safety-rules.md`. No inline duplication of rules.

**When to use:** In every platform SKILL.md immediately after the `# Skill Name` H1 and `## Inputs` / `## Output` boilerplate.

**Example:**
```markdown
## Hard rules

> **Hard rules:** Sandbox-only operations. Read-write only against named sandbox tenants. Refuses destructive actions. See `dydx-delivery/references/safety-rules.md` for the canonical ruleset.
```

**Source:** Phase 5 D-59 (`.planning/phases/05-foundations/05-CONTEXT.md`) + verified in existing `dydx-delivery/skills/execute-tests/SKILL.md:22` post-Phase-5 normalisation.

### Pattern 2: Locked Frontmatter Schema (per-platform SKILL.md)

**What:** Each platform SKILL.md frontmatter conforms to the Phase 5 `frontmatter-scheme.md` canonical + adds 3 platform-skill-specific fields.

**Locked fields (all 3 platforms):**
```yaml
---
name: platform-{pipefy | wrike | ziflow}
description: <one-paragraph trigger sentence + platform-context summary; mirrors discovery-intake/SKILL.md pattern>
frontmatter_version: 2
platform: {pipefy | wrike | ziflow}                  # closed enum per glossary.md
tier_claims_last_verified: 2026-05-09                # ISO date — D-68 baseline; per-platform DISTINCT date
native_ai_path: paste                                # closed enum: {paste | none} — UAT-6.1 LOCK; `api` FORBIDDEN
---
```

**Anti-pattern (FORBIDDEN):**
- `native_ai_path: api` — UAT-6.1 grep gate (PLAT-05); zero hits required
- Single shared `tier_claims_last_verified:` across all 3 — D-68 requires per-platform distinct dates
- Missing `platform:` field — DESIGN-01 closed-enum field required
- Missing `frontmatter_version: 2` — DESIGN-01 / Phase 5 FOUND-03 contract

### Pattern 3: Doc-Only Helper Contract Structure (per D-64 / D-56 precedent)

**What:** Each per-platform helper documented in `api-contract.md` using a uniform 7-part structure.

**Structure:**
```markdown
## <helper_name>

**Signature:** `<helper_name>(<params with types>) -> <return shape>`

**Behaviour:** <1-3 sentences — what the helper does + why it exists (cite MOD-N)>

**Retry / poll budget:** <e.g. "max_wait_s=30 default, interval_s=2 default — bounded retry budget">

**Failure modes:**
- <mode 1>: <detection + return / raise shape>
- <mode 2>: <detection + return / raise shape>

**Return shape:** <typed return — e.g., `list[dict]` or `dict | None` or raise pattern>

**Pseudocode:**
```python
# Phase 6 ships pseudocode only — Stage 8 (v2.4 / Phase 8) authors the real implementation
# against this contract per D-64 / D-56 doc-only precedent.
def <helper_name>(<params>):
    ...
```

**Worked example:** <inputs + expected output for one canonical case>
```

**Source:** Phase 5 D-56 connector-matrix.md doc-only pattern; CONTEXT D-64 mandates this exact structure for all 3 helpers.

### Anti-Patterns to Avoid

- **Inlining safety-rules content into platform SKILL.md** — re-introduces AUDIT-05.1 hard-rules duplication anti-pattern; D-59 uniform pointer is the only correct pattern.
- **Hardcoding `www.wrike.com` in Wrike `api-contract.md`** — MOD-5 violation; OAuth-host persistence pattern is mandatory.
- **Documenting `pipefy_api_host:` per-tenant variation** — UAT-4.1 / Q24 verified canonical-only; only `web_host` + `org_id` vary per tenant.
- **Adding `native_ai_path: api` examples anywhere in platform skills** — UAT-6.1 grep gate; PLAT-05 enforcement (zero hits required).
- **Creating `skills/platform-*/helpers/` directories** — D-64 explicitly rejects even empty `.gitkeep`'d stubs; anticipatory dirs rot.
- **Duplicating project-wide terms in `vocabulary.md`** — D-66 requires platform-specific terms only; synthesis grep gate enforces dedup.
- **Polling-first `wait_for_proof` documentation without naming webhooks as primary** — Ziflow vendor guidance explicitly recommends webhooks; polling is the documented FALLBACK for webhook-unavailable environments.
- **Cross-platform `tier_claims_last_verified:` value sharing** — D-68 requires per-platform distinct dates so the 3 platforms can drift at different rates (Ziflow ReviewAI in active expansion).

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---|---|---|---|
| Cursor pagination across Pipefy GraphQL endpoints | A bespoke pagination loop in each consumer skill | `paginate_all(query, cursor_field)` contract in `platform-pipefy/references/api-contract.md` | MOD-4 — silent truncation bug; centralised contract prevents per-stage re-implementation drift |
| Per-tenant Wrike API base URL discovery | Hardcoded `www.wrike.com` or per-call host detection | OAuth-host persistence pattern in `platform-wrike/references/api-contract.md` (`host` from OAuth token response → `client_state.yaml` `wrike.host:` → base URL for every call) | MOD-5 — hardcoding breaks multi-tenant; tenants like VodafoneZiggo run on `app-eu.wrike.com` |
| Read-after-create polling for Ziflow proofs | Naive `while True` retry against the new proof_id | Webhook-PRIMARY path (subscribe to `processed` event before create) + `wait_for_proof(proof_id, max_wait_s=30, interval_s=2)` documented FALLBACK in `platform-ziflow/references/api-contract.md` | MOD-6 — eventual consistency window; webhooks are vendor-recommended; polling is bounded-budget fallback |
| Pipefy auth-failure detection | `try / except JSONDecodeError` (which masks the real signal) | Explicit `Content-Type` check before parsing JSON; HTML response → `auth_failed` failure class per DESIGN-14 REVISED `api-contract.md` Auth-failure-detection subsection | UAT-4.1 bonus finding — Pipefy returns Keycloak login HTML, not JSON 401, on auth fail; non-standard |
| Pipefy throttle in helpers | Per-skill-author throttle math | Stage-8-test-bot reads canonical throttle (13 req/sec = 80% of 16.67 ceiling) from `platform-pipefy/references/api-contract.md` rate-limit section (resolved Q06.2) | Phase 5 connector-matrix.md `:72` set 13 req/sec ceiling; Phase 6 PLAT-01 derives per-helper retry/backoff budget from this single source |
| Wrike throttle in helpers | Per-skill-author throttle math | Stage-8-test-bot reads canonical throttle (320 req/min per user = 80% of 400 ceiling) from `platform-wrike/references/api-contract.md` rate-limit section (resolved Q07.2) | Phase 5 connector-matrix.md `:73` set 320 req/min ceiling; Phase 6 PLAT-02 derives per-helper retry/backoff budget from this single source |
| Per-skill native-AI capability matrix re-derivation | Per-stage research of Pipefy AI Agents / Wrike Copilot / Ziflow ReviewAI capabilities | Single `platform-*/references/native-ai-inventory.md` consumed by Stage 4a routing + Stage 7b implementation prompt + Stage 10 paste bundle | DESIGN-14 / 15 / 16 + D-68 single-source-with-re-verification-trigger pattern |

**Key insight:** Phase 6 ships interface contracts, not implementations. The "don't hand-roll" rule applies at TWO levels — (1) consumer skills don't hand-roll the helper logic (they read the api-contract.md contract; Phase 8 implements it once); (2) PLATFORM authors don't hand-roll the structural patterns (they follow DESIGN-14 / 15 / 16 + the 5-file shape + the D-59 uniform pointer + the D-64 helper-contract structure). The whole phase is anti-bespoke.

## Helper-Function Specs

These are **documentation contracts**, not executable code. Each lives in its platform's `api-contract.md` per D-64.

### Pipefy `paginate_all(query, cursor_field)` — MOD-4 (PLAT-01)

**Signature:** `paginate_all(query: str, cursor_field: str = "endCursor", page_size: int = 50) -> list[dict]`

**Behaviour:** Iterates Pipefy GraphQL cursor pagination across multi-page result sets until `pageInfo.hasNextPage == false`. Returns the accumulated flat list of records across all pages. Prevents the silent-truncation bug (MOD-4) that occurs when consumer skills assume a single-page response covers all records.

**Retry / poll budget:** Per-page request retries on HTTP 429 with exponential backoff. Throttle ceiling: **13 req/sec per token (80% of 16.67 ceiling = 500 req / 30s per token; resolves Q06.2 per Phase 5 connector-matrix.md `:72`)**. Max retries per page = 3; backoff curve `[1s, 2s, 4s]`. Total budget per page = ~7s before raising.

**Failure modes:**
- HTML response with `Content-Type: text/html` (Keycloak login HTML, UAT-4.1) → raise `PipefyAuthFailed` (NOT a JSON 401 — this is the Pipefy-specific auth-failure shape).
- HTTP 429 after max retries → raise `PipefyRateLimitExhausted`.
- Cursor field missing in response → raise `PipefyPaginationContractError` (signals API contract drift).
- Empty first page → return `[]` (not an error).

**Return shape:** `list[dict]` — flat accumulation of `result.edges[].node` payloads across all pages.

**Pseudocode:**
```python
def paginate_all(query: str, cursor_field: str = "endCursor", page_size: int = 50) -> list[dict]:
    results = []
    cursor = None
    while True:
        page = _execute_with_throttle(query, cursor=cursor, page_size=page_size,
                                       throttle_req_per_sec=13)  # 80% of 16.67 ceiling
        # Auth-failure detection (UAT-4.1 — non-standard Pipefy shape)
        if page.headers.get("Content-Type", "").startswith("text/html"):
            raise PipefyAuthFailed("Keycloak login HTML received; token invalid or expired")
        data = page.json()
        results.extend(node for node in data["result"]["edges"])
        page_info = data["result"]["pageInfo"]
        if not page_info["hasNextPage"]:
            break
        cursor = page_info[cursor_field]
    return results
```

**Worked example:** Querying all cards in a pipe with 247 cards (5 pages × 50 + final page × 47) → returns flat `list[dict]` of length 247. Single per-page HTTP 429 → 1s backoff → retry → succeeds; surface result identical to clean-path.

**Source:** DESIGN-14 helper spec at `.planning/DESIGN.md:440` + UAT-4.1 HTML-auth gotcha at `.planning/DESIGN.md:447` + Phase 5 connector-matrix.md `:72` throttle ceiling.

### Wrike OAuth-Host Persistence Pattern — MOD-5 (PLAT-02)

**Signature:** This is a **pattern**, not a single-callable helper. The pattern has three parts: (1) extract `host` from OAuth token response; (2) persist to `client_state.yaml` `wrike.host:`; (3) use as base URL for every subsequent API call.

**Behaviour:** Replaces the hardcoded `www.wrike.com` base URL with the per-tenant host value carried in the OAuth token response. Wrike's OAuth handshake returns a tenant-specific `host` field (e.g., `app-us2.wrike.com` for US-2 region, `app-eu.wrike.com` for EU region). Hardcoding `www.wrike.com` breaks multi-tenant per MOD-5.

**Persistence:** `client_state.yaml` `wrike.host:` field (per DESIGN-29 schema). Read at session start; written on initial OAuth + on host-change events (rare; typically only on regional migration).

**Retry / poll budget:** N/A (pattern, not a network call). Per-call throttle ceiling: **320 req/min per user (80% of 400 ceiling; resolves Q07.2 per Phase 5 connector-matrix.md `:73`)**.

**Failure modes:**
- OAuth token response missing `host` field → raise `WrikeContractDrift("OAuth response missing host field — multi-tenant guarantee broken")`.
- `wrike.host:` absent from `client_state.yaml` at runtime → refuse to operate; surface "Wrike host not provisioned — re-run OAuth handshake" to caller.
- Hardcoded `www.wrike.com` detected in any helper module → CI-level lint failure (Stage 8 test-bot tier-1 assertion).

**Pseudocode:**
```python
# Step 1 — Extract on OAuth completion
def on_oauth_complete(token_response: dict, client_state_path: Path) -> None:
    host = token_response.get("host")
    if not host:
        raise WrikeContractDrift("OAuth response missing host field")
    cs = load_client_state(client_state_path)
    cs["wrike"]["host"] = host
    save_client_state(client_state_path, cs)

# Step 2 — Read at every API call
def wrike_base_url(client_state: dict) -> str:
    host = client_state.get("wrike", {}).get("host")
    if not host:
        raise RuntimeError("wrike.host not provisioned — re-run OAuth handshake")
    return f"https://{host}/api/v4"

# Step 3 — Use as base URL
def list_tasks(client_state: dict, params: dict) -> dict:
    url = f"{wrike_base_url(client_state)}/tasks"
    return _execute_with_throttle(url, params=params,
                                   throttle_req_per_min=320)  # 80% of 400 ceiling per user
```

**Worked examples:**
- US-2 region tenant: `token_response.host == "app-us2.wrike.com"` → base URL `https://app-us2.wrike.com/api/v4`.
- VodafoneZiggo EU tenant (account `5996999`): `token_response.host == "app-eu.wrike.com"` → base URL `https://app-eu.wrike.com/api/v4`; entry URL pattern `https://app-eu.wrike.com/workspace.htm?acc=5996999`.

**Source:** DESIGN-15 OAuth-host rule at `.planning/DESIGN.md:488` + Phase 5 OPEN-Q13 resolution at `dydx-delivery/references/connector-matrix.md:78` (canonical persistence destination = `<Client> Brain/00_HUB.md` Coda block per DESIGN-29; final destination at PLAT-02 author discretion) + Phase 5 connector-matrix.md `:73` throttle ceiling.

### Ziflow `wait_for_proof(proof_id, max_wait_s=30, interval_s=2)` — MOD-6 (PLAT-03)

**Signature:** `wait_for_proof(proof_id: str, max_wait_s: int = 30, interval_s: int = 2) -> dict`

**IMPORTANT — Documentation framing:** Per 2026-05-11 vendor research, **Ziflow officially recommends webhooks over polling** (per `help.ziflow.com/hc/en-us/articles/30725068740244-Webhooks` + `help.ziflow.com/hc/en-us/articles/30721919730836-Embedded-Review-Approval`). The canonical pattern is to subscribe to the `processed` event webhook BEFORE proof creation, so the platform notifies the caller when the proof is ready. `wait_for_proof` is the documented **FALLBACK** for environments where webhook delivery is unavailable (e.g., local dev, sandbox tests without exposed webhook URLs, harness runs).

**Behaviour:** Polls Ziflow's proof-get endpoint until the proof becomes readable (HTTP 200 + valid proof payload) or `max_wait_s` is exceeded. Handles the read-after-create eventual-consistency window (MOD-6) where Ziflow's proof-create call returns success before the proof is fully readable; subsequent reads within the consistency window may 404.

**Retry / poll budget:** `max_wait_s=30` total / `interval_s=2` between polls = up to ~15 polls per call. Defaults match DESIGN-16 conservative baseline. Q05 resolution: defaults **CONFIRMED** at 30s/2s for fallback path; webhook-primary path has no polling budget (event-driven).

**Failure modes:**
- HTTP 404 on each poll until `max_wait_s` exceeded → raise `ZiflowProofNotReady(proof_id, polls_attempted, total_wait_s)`.
- HTTP 401 / 403 on poll → raise `ZiflowAuthFailed` (NOT eventual-consistency; auth issue).
- HTTP 5xx on poll → 1 retry with `interval_s` backoff; subsequent 5xx → raise `ZiflowServerError`.
- Webhook delivery available + subscribed → caller should NOT use this helper; document the webhook path at the top of `api-contract.md`.

**Return shape:** `dict` — proof payload (id, status, version, project_id, urls, etc. per Ziflow proof-get response shape).

**Pseudocode:**
```python
def wait_for_proof(proof_id: str, max_wait_s: int = 30, interval_s: int = 2) -> dict:
    """
    FALLBACK ONLY — primary path is webhook subscription to 'processed' event.
    Use this helper when webhook delivery is unavailable (local dev / harness / sandbox).
    """
    deadline = time.time() + max_wait_s
    polls = 0
    while time.time() < deadline:
        polls += 1
        response = _get(f"/proofs/{proof_id}")
        if response.status_code == 200:
            return response.json()
        if response.status_code == 404:
            time.sleep(interval_s)
            continue
        if response.status_code in (401, 403):
            raise ZiflowAuthFailed(f"Auth failed at poll {polls}")
        if response.status_code >= 500:
            time.sleep(interval_s)
            response = _get(f"/proofs/{proof_id}")
            if response.status_code == 200:
                return response.json()
            raise ZiflowServerError(f"5xx persisted at poll {polls}")
    raise ZiflowProofNotReady(proof_id, polls, max_wait_s)
```

**Worked example:** Proof created at t=0; first read at t=2s → 404 (eventual consistency); read at t=4s → 404; read at t=6s → 200 + proof payload. Helper returns at poll #3 (total wait ~6s, well within 30s budget). Test-bot tier-1 verifies the wait completed within budget.

**Source:** DESIGN-16 helper spec at `.planning/DESIGN.md:531` + Q05 vendor research 2026-05-11 (`help.ziflow.com/hc/en-us/articles/30725068740244-Webhooks` webhook-PRIMARY guidance + `help.ziflow.com/hc/en-us/articles/30721919730836-Embedded-Review-Approval` "use webhooks instead of polling" canonical statement).

## 5-File `references/` Outline (per-platform section sketch for plan decomposition)

Planner can decompose each per-platform plan into ~5 reference-file sub-tasks + 1 SKILL.md sub-task + 1 OPEN-Q resolution sub-task using this outline.

### `api-contract.md` (all 3 platforms)

```markdown
# {Pipefy | Wrike | Ziflow} — API contract

## Endpoint(s) + auth shape
- Base URL: {canonical for Pipefy; OAuth-host for Wrike; per-tenant for Ziflow}
- Auth header: `Authorization: Bearer <token>` (NEVER log real tokens)
- Sandbox tenant only — see `dydx-delivery/references/safety-rules.md` Rule 1

## Rate limit + throttle
- Published ceiling: {Pipefy 500 req / 30s per token = 16.67 req/sec ceiling ;
                     Wrike 400 req/min per user + 5000 req/min per IP ;
                     Ziflow [Phase 1 not researched — read from connector-matrix.md or N/A]}
- Helper throttle: {Pipefy 13 req/sec (80% — Q06.2) ;
                    Wrike 320 req/min per user (80% — Q07.2) ;
                    Ziflow N/A polling-bounded by max_wait_s}
- 429 handling: exponential backoff `[1s, 2s, 4s]`; max retries = 3 per call

## Auth-failure detection
- [Pipefy ONLY] HTML-on-auth-failure gotcha (UAT-4.1) — Keycloak login HTML,
  `Content-Type: text/html`, NOT JSON 401. Skills MUST check Content-Type before
  parsing JSON.
- [Wrike / Ziflow] Standard 401 / 403 JSON shape.

## Helper contract(s)
- [Pipefy] `paginate_all(query, cursor_field)` — see §Helper-Function Specs above
- [Wrike] OAuth-host persistence pattern — see §Helper-Function Specs above
- [Ziflow] `wait_for_proof(proof_id, max_wait_s=30, interval_s=2)` — FALLBACK ONLY;
  webhook-PRIMARY documented at top of file

## Multi-tenant auth concurrency
- [Pipefy] `exclusive` — locked per UAT-4.2; cannot auth to two tenants simultaneously
- [Wrike / Ziflow] Default `exclusive` per Pipefy precedent; LOW confidence; live tenant
  test deferred to PLAT-02 / PLAT-03 kickoff per Q25 resolution

## MCP availability (UAT-3.5 — PARKED REFERENCE)
- [Pipefy] Pipedream Pipefy MCP available but not adopted through v2.6
- [Wrike] Wrike MCP Server available (per `developers.wrike.com/wrike-mcp/`) but not
  adopted through v2.6 — current vendor count = 47 tools per stackone.com (2026-05-11)
- [Ziflow] No MCP — direct REST only
```

### `native-ai-inventory.md` (all 3 platforms)

```markdown
# {Pipefy | Wrike | Ziflow} — Native-AI inventory

> `tier_claims_last_verified:` matches SKILL.md frontmatter value (2026-05-09 baseline
> per D-68; updated to execution date if fresh re-verification happens during this plan).

## Re-verification trigger

Re-verify against current {Pipefy AI Agents | Wrike Copilot | Ziflow ReviewAI}
documentation BEFORE any v2.x phase that consumes the capability matrix:
- Stage 4a delivery routing (consumes confidence ratings)
- Stage 7b implementation prompt (consumes capability surface list)
- Stage 10 native-AI paste bundle (consumes paste targets)

Update `tier_claims_last_verified:` in the SKILL.md frontmatter after each
re-verification, citing source doc URL + date in commit message.

## Capability matrix (2026-grounded)

[Lift verbatim from DESIGN-14 table (Pipefy) / DESIGN-15 table (Wrike) /
 DESIGN-16 table (Ziflow). PLAT-NN execution MAY re-verify against current
 vendor docs and bump the `tier_claims_last_verified:` date.]

## Paste-only delivery (UAT-6.1)

`native_ai_path: paste | none` ONLY — `api` branch is FORBIDDEN. The Stage 10
paste bundle is the only supported ingestion path; humans upload manually via
the platform UI.
```

### `knowledge-ingestion.md` (all 3 platforms)

```markdown
# {Pipefy | Wrike | Ziflow} — Knowledge ingestion

## Primary path (paste-only per UAT-6.1)

[Per-platform paste-bundle shape — describe what Stage 10 produces for this
 platform. Pipefy = Behaviors instructions + KB upload list; Wrike = Copilot
 workflow narrative + MCP tool config; Ziflow = ReviewAI checklist criteria.]

## Audit log shape

[Reference Stage 10 audit log fields — `ingested_at:`, `doc_version:`,
 `target_id:`, manual-upload acknowledgement.]

## Fallback (manual paste via UI)

[Default; UAT-6.1 enforces this for all 3 platforms through v2.6.]
```

### `client-shape-gotchas.md` (all 3 platforms, per D-65)

```markdown
# {Pipefy | Wrike | Ziflow} — Client shape gotchas

> Append-only — new client shapes added per first-engagement; existing rows
> preserved for audit trail.

## Known shapes (verified)

[Lift DESIGN.md worked examples verbatim per D-65:
 - Pipefy: Vodacom custom-subdomain (web_host `vodacom.pipefy.com/{org_id}`;
   API canonical `api.pipefy.com/graphql`)
 - Wrike: VodafoneZiggo EU tenant (host `app-eu.wrike.com`, account `5996999`,
   entry URL `app-eu.wrike.com/workspace.htm?acc=5996999`)
 - Ziflow: Acme placeholder (DESIGN-16 worked example) — one entry stub,
   marked `<TBD at first engagement>` for Up & Up Group + VodafoneZiggo per
   `.claude/memory/reference_client_brain_coda_docs.md`]

## Pattern slots (variant taxonomy)

[Per-platform variant taxonomy:
 - Pipefy: `web_host` default vs custom-subdomain; `org_id` semantics;
   `pipe_id` vs `phase_id` vs `card_id` distinction
 - Wrike: regional host variants (us / us-2 / eu); `account_id` per tenant;
   `space_id` per client/project; custom field IDs per tenant
 - Ziflow: workflow stage names per client; project naming conventions;
   review-decision label customisations]

## How to add a new shape

[One-line maintenance contract: "When onboarding a new client, append a verified
 row to `## Known shapes (verified)` citing the engagement date + source artefact.
 Pattern slots are append-only; existing rows are preserved for audit trail."]
```

### `vocabulary.md` (all 3 platforms, per D-66)

```markdown
# {Pipefy | Wrike | Ziflow} — Vocabulary

> For project-wide terms see `dydx-delivery/references/glossary.md`.

## Platform-specific terms

[ONLY platform-specific terms NOT defined in glossary.md:
 - Pipefy: `pipe`, `phase`, `card`, `connection`, `org_id`, `web_host` (per-tenant
   variant), `pipe_id`, `phase_id`, `card_id`, `Behaviors`, `Pipefy AI Agents`
 - Wrike: `space`, `folder`, `project`, `task`, `custom field`, `host`
   (OAuth-persisted), `account_id`, `space_id`, `Wrike Copilot`, `MCP Server`
 - Ziflow: `proof`, `review`, `decision`, `stage`, `version`, `project_id`,
   `ReviewAI`, `Checklist`, `Change Verification`, `Brand Standards`]

> Verification gate: synthesis-plan grep dedup confirms zero of these terms
> are ALSO defined in `dydx-delivery/references/glossary.md`. Cross-cutting
> terms (frontmatter / sandbox / native_ai_path / status: lifecycle) live in
> glossary.md, NOT here.
```

## Cross-Platform Parity Table (5-file shape × 3 platforms)

Shows where content diverges across the platforms — useful for planner decomposition.

| File | Pipefy specifics | Wrike specifics | Ziflow specifics |
|---|---|---|---|
| `api-contract.md` | GraphQL endpoint canonical-only (UAT-4.1) + HTML-on-auth-failure gotcha + `paginate_all` (MOD-4) + 13 req/sec throttle (Q06.2) | REST endpoint per-tenant from OAuth host (MOD-5) + OAuth-host persistence pattern + 320 req/min/user throttle (Q07.2) | REST endpoint per-tenant + **webhook-PRIMARY** (vendor-recommended per Q05 research) + `wait_for_proof` FALLBACK (MOD-6) + 30s/2s defaults |
| `native-ai-inventory.md` | AI Agents 2.0 (Nov 2025 launch): KB + Skills + MCP + IDP + Web Search + BYO-LLM (HIGH confidence per launch announcement; MCP claim is MEDIUM — flag for re-verification at PLAT-01) | Wrike Copilot real-time AI + MCP Server (47 tools per stackone vendor count 2026-05-11; DESIGN-15 says 16 — reconcile at PLAT-02) + attach-doc-via-MCP path | ReviewAI Checklists Public Preview (Enterprise plan) + Change Verification "Coming Soon" + Brand Standards "Coming Soon" + Checklist Templates API GA April 2026 (release notes 26.08) |
| `knowledge-ingestion.md` | Paste bundle = Pipefy Behaviors instructions + KB upload list (manual upload via Pipefy UI per UAT-6.1) | Paste bundle = Wrike Copilot workflow narrative + MCP tool config + attach-doc-via-MCP instructions (manual via Wrike UI) | Paste bundle = ReviewAI Checklist criteria (manual via Ziflow UI); copy-paste fallback per DESIGN-16 |
| `client-shape-gotchas.md` | Verified: Vodacom custom-subdomain `vodacom.pipefy.com/{org_id}` | Verified: VodafoneZiggo `app-eu.wrike.com` account `5996999` | Placeholder: Acme stub + `<TBD>` markers for Up & Up Group + VodafoneZiggo |
| `vocabulary.md` | pipe / phase / card / connection / org_id / web_host / pipe_id / phase_id / card_id / Behaviors / Pipefy AI Agents | space / folder / project / task / custom field / host / account_id / space_id / Wrike Copilot / MCP Server | proof / review / decision / stage / version / project_id / ReviewAI / Checklist / Change Verification / Brand Standards |
| `SKILL.md` frontmatter | `platform: pipefy`, `tier_claims_last_verified: 2026-05-09`, `native_ai_path: paste` | `platform: wrike`, `tier_claims_last_verified: 2026-05-09`, `native_ai_path: paste` | `platform: ziflow`, `tier_claims_last_verified: 2026-05-09`, `native_ai_path: paste` |
| `SKILL.md` re-verification trigger | Names Stage 4a / 7b / 10 downstream consumers + per-platform doc URL (Pipefy AI Agents) | Names Stage 4a / 7b / 10 + Wrike Copilot doc URL | Names Stage 4a / 7b / 10 + Ziflow ReviewAI doc URL (high-churn surface — Change Verification + Brand Standards "Coming Soon") |

**Symmetry observation:** Structure is identical across 3 platforms (5 files + 1 SKILL.md, same H2 anchors per the outlines above). **Asymmetry concentrates** in api-contract.md (3 distinct helper patterns) and client-shape-gotchas.md (verified-vs-placeholder seed differences). This validates D-63 per-platform slicing — each plan is self-contained on its directory.

## Q05 / Q06.2 / Q07.2 Resolutions (inline per D-67)

### Q05 — Ziflow read-after-create consistency window

**Question:** What is the actual read-after-create consistency window for Ziflow proof-create operations in 2026?

**Resolution (2026-05-11 research):**

- **Primary vendor guidance:** Ziflow officially recommends **webhooks over polling** for proof-ready signalling. The canonical pattern is to subscribe to the `processed` event webhook BEFORE proof creation. (Sources: `help.ziflow.com/hc/en-us/articles/30725068740244-Webhooks`, `help.ziflow.com/hc/en-us/articles/30721919730836-Embedded-Review-Approval` — direct vendor quote: "Use webhooks instead of polling the Ziflow API for updates.")
- **Fallback (when webhook delivery unavailable):** `wait_for_proof(proof_id, max_wait_s=30, interval_s=2)` polling helper. Defaults confirmed at 30s budget / 2s interval per DESIGN-16 baseline. Conservative — most proof-ready transitions occur within 4-10s based on vendor "files are downloaded by our systems" architecture description.
- **Documentation framing in `platform-ziflow/references/api-contract.md`:** Webhook path documented at top as PRIMARY; `wait_for_proof` documented below as FALLBACK with explicit "use this only when webhook delivery is unavailable (local dev / harness / sandbox without exposed webhook URL)" note.

**Confidence:** HIGH — vendor guidance is unambiguous (multiple vendor doc sources state webhook-primary explicitly); the 30s/2s polling default is the conservative DESIGN-16 baseline for the fallback path.

**Lands at:** `dydx-delivery/skills/platform-ziflow/references/api-contract.md` § Helper contract / `wait_for_proof` subsection + § Webhook-primary documentation at top.

**OPEN-QUESTIONS.md row flip (in synthesis plan):** Q05 Status `proposed` → `decided`. Resolution one-liner: "Webhook-primary per vendor guidance (`help.ziflow.com/hc/en-us/articles/30725068740244-Webhooks`); `wait_for_proof` fallback defaults confirmed at `max_wait_s=30` / `interval_s=2`. Cited at `dydx-delivery/skills/platform-ziflow/references/api-contract.md` § wait_for_proof."

### Q06.2 — Pipefy throttle calibration (consumer-throttle)

**Question:** Given the Phase 1 published-rate-limit answer (Q06.1), what is the calibrated consumer throttle value the platform-pipefy helpers should enforce?

**Resolution (2026-05-11):**

- **Phase 5 published-rate-limit baseline (Q06.1 — already `decided`):** 500 req / 30s per token = 16.67 req/sec per token ceiling. Source: `dydx-delivery/references/connector-matrix.md:72` (re-confirmed via 2026-05-11 web search at `community.pipefy.com/customs-apps-integrations-75/what-are-the-graphql-api-limits-958`).
- **Phase 6 PLAT-01 derivation:** Helpers throttle at **13 req/sec per token (80% buffer)**. Matches DESIGN-22 carried throttle pattern (`.planning/DESIGN.md:795` — "80% of ceiling" rule of thumb for all platforms). Per-page retry budget: max 3 retries on 429 with backoff `[1s, 2s, 4s]`; total budget per call = ~7s before raising `PipefyRateLimitExhausted`.
- **Pipe Reports Export sub-limit:** 25 req / 24h per pipe — helpers MUST be aware of this separate sub-ceiling; consumer skills using `paginate_all` against pipe-report endpoints carry a per-day budget tracker. Out-of-budget → return cached / partial result with warning, NOT raise.

**Confidence:** HIGH — single source (Pipefy Community) cross-verified across 2 search-result rounds (2026-05-10 Phase 5 + 2026-05-11 Phase 6 re-confirm); 80% throttle rule is DESIGN-22 locked.

**Lands at:** `dydx-delivery/skills/platform-pipefy/references/api-contract.md` § Rate limit + throttle subsection.

**OPEN-QUESTIONS.md row flip (in synthesis plan):** Q06.2 Status `proposed` → `decided`. Resolution one-liner: "Helpers throttle at 13 req/sec per token (80% of 16.67 req/sec ceiling per Phase 5 Q06.1 = `dydx-delivery/references/connector-matrix.md:72`). Cited at `dydx-delivery/skills/platform-pipefy/references/api-contract.md` § Rate limit + throttle."

### Q07.2 — Wrike throttle calibration (consumer-throttle)

**Question:** Given the Phase 1 published-rate-limit answer (Q07.1), what is the calibrated consumer throttle value the platform-wrike helpers should enforce?

**Resolution (2026-05-11):**

- **Phase 5 published-rate-limit baseline (Q07.1 — already `decided`):** 400 req/min per user + 5000 req/min per IP. Source: `dydx-delivery/references/connector-matrix.md:73` (re-confirmed via 2026-05-11 web search at `help.wrike.com/hc/en-us/articles/23908384596631-Resolve-Common-REST-API-Errors`).
- **Phase 6 PLAT-02 derivation:** Helpers throttle at **320 req/min per user (80% of 400 ceiling)**. Per-IP ceiling (5000/min) is not a per-helper constraint (multiple users may share the IP); IP-level rate-limit-aware behaviour is a Stage-8-test-bot concern, not a per-helper concern. Per-call retry budget: max 3 retries on 429 with backoff `[1s, 2s, 4s]`.
- **Headers:** Wrike returns `X-RateLimit-*` headers on every response; helpers SHOULD parse these to dynamically adjust throttle when the API surfaces server-side remaining-quota. Per-call adaptive-throttle is a P2 enhancement; static 320 req/min/user is the P1 baseline.

**Confidence:** HIGH — Wrike Help Center is the authoritative source (cross-verified across Wrike vendor docs + Nango docs + Wrike Developer FAQ); 80% throttle rule is DESIGN-22 locked.

**Lands at:** `dydx-delivery/skills/platform-wrike/references/api-contract.md` § Rate limit + throttle subsection.

**OPEN-QUESTIONS.md row flip (in synthesis plan):** Q07.2 Status `proposed` → `decided`. Resolution one-liner: "Helpers throttle at 320 req/min per user (80% of 400 ceiling per Phase 5 Q07.1 = `dydx-delivery/references/connector-matrix.md:73`). Cited at `dydx-delivery/skills/platform-wrike/references/api-contract.md` § Rate limit + throttle."

## Frontmatter Schema (per-platform SKILL.md)

### Template (Pipefy)

```yaml
---
name: platform-pipefy
description: Provide Pipefy GraphQL API contract + 2026 AI Agents capability matrix + per-client shape gotchas + vocabulary for any stage skill that targets a Pipefy tenant. Use when artefact frontmatter carries `platform: pipefy`. Documents the `paginate_all` helper contract for cursor pagination; the HTML-on-auth-failure detection rule (Pipefy returns Keycloak login HTML, not JSON 401); the canonical-only API endpoint (`api.pipefy.com/graphql` for ALL tenants); paste-only native-AI ingestion path per UAT-6.1. Does NOT execute API calls — pure reference content for skills + Stage 8 test bot.
frontmatter_version: 2
platform: pipefy
tier_claims_last_verified: 2026-05-09
native_ai_path: paste
---
```

### Template (Wrike)

```yaml
---
name: platform-wrike
description: Provide Wrike REST API contract + 2026 Copilot + MCP Server capability matrix + per-client shape gotchas + vocabulary for any stage skill that targets a Wrike tenant. Use when artefact frontmatter carries `platform: wrike`. Documents the OAuth-host persistence pattern (the `host` field MUST be persisted from the OAuth token response; hardcoding `www.wrike.com` breaks multi-tenant); the attach-doc-via-MCP knowledge-ingestion path; paste-only native-AI ingestion per UAT-6.1. Does NOT execute API calls — pure reference content for skills + Stage 8 test bot.
frontmatter_version: 2
platform: wrike
tier_claims_last_verified: 2026-05-09
native_ai_path: paste
---
```

### Template (Ziflow)

```yaml
---
name: platform-ziflow
description: Provide Ziflow REST API contract + 2026 ReviewAI capability matrix + per-client shape gotchas + vocabulary for any stage skill that targets a Ziflow tenant. Use when artefact frontmatter carries `platform: ziflow`. Documents the webhook-PRIMARY pattern for read-after-create signalling (vendor-recommended) + `wait_for_proof` fallback helper for environments without webhook delivery; ReviewAI Checklists Public Preview + Change Verification + Brand Standards capability tracking; paste-only native-AI ingestion per UAT-6.1. Does NOT execute API calls — pure reference content for skills + Stage 8 test bot.
frontmatter_version: 2
platform: ziflow
tier_claims_last_verified: 2026-05-09
native_ai_path: paste
---
```

### Re-verification Trigger Boilerplate (per D-68; identical structure across 3 platforms; per-platform doc URL differs)

```markdown
## Re-verification trigger

Re-verify `references/native-ai-inventory.md` against current {Pipefy AI Agents |
Wrike Copilot | Ziflow ReviewAI} documentation BEFORE any v2.x phase that consumes
the capability matrix:
- Stage 4a delivery routing (consumes confidence ratings)
- Stage 7b implementation prompt (consumes capability surface list)
- Stage 10 native-AI paste bundle (consumes paste targets — Behaviors / Copilot
  workflow narratives / ReviewAI Checklist criteria)

Update `tier_claims_last_verified:` on this SKILL.md frontmatter after each
re-verification, citing the source doc URL + date in commit message.

Doc URL anchor:
- Pipefy: https://www.pipefy.com/ + Pipefy Help Center
- Wrike:  https://developers.wrike.com/wrike-mcp/ + https://www.wrike.com/ai/mcp/
- Ziflow: https://api-docs.ziflow.com/ + https://www.ziflow.com/reviewai
```

## Native-AI Capability Matrices (verbatim lifts from DESIGN.md per CONTEXT `<code_context>`; flag re-verification deltas)

### Pipefy AI Agents 2.0 (LIFT from DESIGN-14 at `.planning/DESIGN.md:425-435`)

| Capability | Available? | Surface | Confidence |
|---|---|---|---|
| Knowledge base | yes | Pipefy AI Agents → KB | HIGH |
| Skills | yes | AI Agents → Skills | HIGH |
| MCP integration | **flag for re-verify** | AI Agents → MCP | **DESIGN-14 = HIGH; current research = MEDIUM** — one secondary 2026 source contradicts ("Pipefy is not designed to ingest agents built on third-party frameworks through standard protocols like MCP"). PLAT-01 execution MUST re-verify against Pipefy.com / Pipefy AI Agents 2.0 launch docs (`globenewswire.com/news-release/2025/11/12/3186348`). |
| IDP (Intelligent Document Processing) | yes | AI Agents → IDP (Agents 2.0 native) | HIGH — confirmed via 2025-11 launch announcement |
| Web Search | yes | AI Agents → Web Search | HIGH |
| BYO-LLM | yes | AI Agents config (multi-LLM routing per workflow step) | HIGH — confirmed via 2025-11 launch announcement |
| KB content-upload via API | **CLOSED (UAT-6.1)** | n/a | UAT-6.1 — OPEN-Q01 closed; no API ingestion path through v2.6 |

**Re-verification delta if executed 2026-05-11:** `tier_claims_last_verified: 2026-05-11`; MCP row flipped to MEDIUM with note "vendor messaging contradictory — Pipefy AI Agents 2.0 launch mentions MCP support; secondary AI-agent-platform-comparison articles question MCP-server availability for inbound third-party agents. Re-confirm BEFORE Stage 7b implementation prompt consumes this row."

### Wrike Copilot + MCP (LIFT from DESIGN-15 at `.planning/DESIGN.md:478-484`)

| Capability | Available? | Surface | Confidence |
|---|---|---|---|
| Copilot (chat-style assistant) | yes | Wrike Copilot | HIGH |
| MCP tools | yes | Wrike MCP integration | **DESIGN-15 = "16 MCP tools"; current vendor count (2026-05-11) = 47 tools per stackone.com/connectors/wrike/mcp/** — tool count has grown since DESIGN authoring; PLAT-02 execution SHOULD re-count + cite `developers.wrike.com/wrike-mcp/` for canonical |
| Knowledge ingestion via attach-doc-via-MCP | yes | MCP attach-doc tool | MEDIUM (per DESIGN-15) — re-verify against current MCP tool list at PLAT-02 |
| AI Studio knowledge-ingestion API | **CLOSED (UAT-6.1)** | n/a | UAT-6.1 — OPEN-Q02 closed; no API ingestion path through v2.6 |

### Ziflow ReviewAI (LIFT from DESIGN-16 at `.planning/DESIGN.md:521-526`)

| Capability | Available? | Surface | Confidence |
|---|---|---|---|
| ReviewAI Checklists (Public Preview) | yes | ReviewAI → Checklists | HIGH — confirmed 2026-05-11 via `help.ziflow.com/hc/en-us/articles/41711066855956-Use-ReviewAI` + `ziflow.com/blog/introducing-checklists-more-creative-reviews` (Public Preview on Enterprise plan) |
| Checklist Templates API | **NEW April 2026** | ReviewAI checklist template endpoints (release 26.08) | HIGH — confirmed per `help.ziflow.com/hc/en-us/articles/48181732374676-April-2026-release-notes-26-08`. **This row is a Phase 6 addition** (post-DESIGN-16 authoring); PLAT-03 SHOULD add it. |
| Change Verification | coming soon | ReviewAI → Change Verification | MEDIUM — vendor confirms "Coming Soon" status as of 2026-05-11 |
| Brand Standards | coming soon | ReviewAI → Brand Standards | MEDIUM — vendor confirms "Coming Soon" status as of 2026-05-11 |
| ReviewAI knowledge-ingestion API | **CLOSED (UAT-6.1)** | n/a | UAT-6.1 — OPEN-Q03 closed; no API ingestion path through v2.6 |

## Plan Decomposition Recommendation

Given the locked D-63 (3 plans, per-platform) and the symmetry observed in §Cross-Platform Parity Table, recommend the following plan decomposition for `/gsd-plan-phase 6`:

### `06-01-PLAN.md` — platform-pipefy (end-to-end)

**Tasks (recommended decomposition):**
1. Create directory `dydx-delivery/skills/platform-pipefy/references/`.
2. Write `SKILL.md` (frontmatter per §Frontmatter Schema template Pipefy; D-59 uniform-pointer; re-verification trigger; inputs/outputs/how-to-run boilerplate following `discovery-intake/SKILL.md` shape).
3. Write `references/api-contract.md` (canonical-only endpoint + HTML-on-auth-failure detection + `paginate_all` contract per §Helper-Function Specs + Q06.2 throttle resolution at 13 req/sec).
4. Write `references/native-ai-inventory.md` (lift DESIGN-14 table verbatim; flag MCP row for re-verify; add re-verification trigger subsection).
5. Write `references/knowledge-ingestion.md` (paste-only path; Behaviors + KB upload list shape; audit log fields).
6. Write `references/client-shape-gotchas.md` (Vodacom custom-subdomain verified seed + pattern slots; append-only preamble).
7. Write `references/vocabulary.md` (Pipefy-specific terms only; pointer to glossary.md).

**Addresses:** PLAT-01 (full), PLAT-04 (Pipefy `tier_claims_last_verified:`), PLAT-05 (Pipefy `native_ai_path:` lock).

**OPEN-Q resolved inline:** Q06.2 (lands in api-contract.md § Rate limit + throttle); row flip in synthesis.

**Estimated LOC:** ~350-450 LOC across 6 files.

### `06-02-PLAN.md` — platform-wrike (end-to-end)

**Tasks (recommended decomposition):**
1. Create directory `dydx-delivery/skills/platform-wrike/references/`.
2. Write `SKILL.md` (frontmatter per §Frontmatter Schema template Wrike; D-59 uniform-pointer; re-verification trigger; boilerplate following `discovery-intake/SKILL.md`).
3. Write `references/api-contract.md` (OAuth-host persistence pattern + 320 req/min/user throttle Q07.2; X-RateLimit-* header parsing note as P2 enhancement).
4. Write `references/native-ai-inventory.md` (lift DESIGN-15 table verbatim; flag tool count for re-verify against current 47; add re-verification trigger).
5. Write `references/knowledge-ingestion.md` (paste-only path; Copilot workflow narrative + MCP tool config shape).
6. Write `references/client-shape-gotchas.md` (VodafoneZiggo EU verified seed `app-eu.wrike.com` account `5996999` + pattern slots; append-only preamble).
7. Write `references/vocabulary.md` (Wrike-specific terms only; pointer to glossary.md).

**Addresses:** PLAT-02 (full), PLAT-04 (Wrike `tier_claims_last_verified:`), PLAT-05 (Wrike `native_ai_path:` lock).

**OPEN-Q resolved inline:** Q07.2 (lands in api-contract.md § Rate limit + throttle); row flip in synthesis.

**Estimated LOC:** ~350-450 LOC across 6 files.

### `06-03-PLAN.md` — platform-ziflow + synthesis (end-to-end + cross-cutting)

**Tasks (recommended decomposition):**
1. Create directory `dydx-delivery/skills/platform-ziflow/references/`.
2. Write `SKILL.md` (frontmatter per §Frontmatter Schema template Ziflow; D-59 uniform-pointer; re-verification trigger; boilerplate).
3. Write `references/api-contract.md` (webhook-PRIMARY documentation + `wait_for_proof` FALLBACK helper per §Helper-Function Specs + Q05 resolution: 30s/2s defaults confirmed for fallback path).
4. Write `references/native-ai-inventory.md` (lift DESIGN-16 table verbatim; ADD Checklist Templates API row per April 2026 release; add re-verification trigger).
5. Write `references/knowledge-ingestion.md` (Checklist criteria paste bundle + copy-paste fallback).
6. Write `references/client-shape-gotchas.md` (Acme placeholder + `<TBD>` markers for Up & Up Group + VodafoneZiggo per `.claude/memory/reference_client_brain_coda_docs.md`).
7. Write `references/vocabulary.md` (Ziflow-specific terms only; pointer to glossary.md).
8. **Synthesis sub-task A — Shape parity gate:** Verify 5-file `references/` shape parity across the 3 platforms; assert via structure-check (preview).
9. **Synthesis sub-task B — Authoring `phase6-structure-check.sh`** (~40 PASS assertions; mirror Phase 5 pattern).
10. **Synthesis sub-task C — `.planning/OPEN-QUESTIONS.md` row flips:** Q05 / Q06.2 / Q07.2 Status fields `proposed` → `decided` with one-line resolutions citing per-platform api-contract.md paths.
11. **Synthesis sub-task D — Vocabulary dedup grep gate:** assert zero terms duplicate-defined across `dydx-delivery/references/glossary.md` and any `skills/platform-*/references/vocabulary.md`.

**Addresses:** PLAT-03 (full), PLAT-04 (Ziflow `tier_claims_last_verified:`), PLAT-05 (Ziflow `native_ai_path:` lock), PLAT-06 (full — all 3 OPEN-Q row flips).

**OPEN-Q resolved inline:** Q05 (lands in api-contract.md webhook-primary + `wait_for_proof` fallback section); row flips in synthesis sub-task C.

**Split threshold (per D-63):** If 06-03 exceeds ~400 LOC of plan content (rough threshold), planner SPLITS synthesis sub-tasks 8-11 out to `06-04-PLAN.md` (shape-parity gate + OPEN-Q row flips + `phase6-structure-check.sh` + vocabulary dedup). At that point, 06-03 ships only platform-ziflow content (tasks 1-7); 06-04 is synthesis-only.

**Estimated LOC:** ~450-650 LOC if monolithic (likely exceeds 400 threshold → recommend split to 06-04 at /gsd-plan-phase time).

### Parallelism scheduling under `/gsd-execute-phase 6`

- **Phase 1 of execution (parallel):** 06-01 + 06-02 + 06-03 (platform-ziflow part only, tasks 1-7) run in parallel. All 3 plans touch distinct directories; no file-ownership conflict.
- **Phase 2 of execution (sequential):** Synthesis (06-03 tasks 8-11 OR 06-04 if split) runs after all 3 platform plans complete. Sequential because synthesis depends on all 3 platform skills existing for shape-parity verification AND owns the single-writer `.planning/OPEN-QUESTIONS.md` row flips.

## Runtime State Inventory

Phase 6 ships 18 NEW Markdown files plus 1 NEW shell script. NO existing runtime state is renamed, mutated, or migrated.

| Category | Items Found | Action Required |
|----------|-------------|------------------|
| Stored data | None — Phase 6 creates NEW directories under `dydx-delivery/skills/platform-*/`; no existing collections / user_ids / databases / queues touched. Verified: no `platform-pipefy` / `platform-wrike` / `platform-ziflow` directories exist pre-Phase-6 (`AUDIT-04.1` confirmed these are orphan-referenced-but-missing as of v0.3.0). | None |
| Live service config | None — Phase 6 is doc-only; no external services (n8n / Datadog / Coda / Drive / Pipefy tenant / Wrike tenant / Ziflow tenant) are reconfigured. The 3 platform skills DOCUMENT API contracts; they do not call APIs. | None |
| OS-registered state | None — no Task Scheduler / pm2 / launchd / systemd / cron entries. Phase 6 is markdown authoring. | None |
| Secrets / env vars | None — Phase 6 documents auth header SHAPE only (e.g., `Authorization: Bearer <token>`); NEVER paste real tokens / OAuth refresh tokens / API keys / session cookies into any platform skill or reference. Tokens live in per-tenant `client_state.yaml` (gitignored) or env vars per Phase 5 connector-matrix.md security note. | Verify (synthesis grep gate): zero hits for `Bearer [a-zA-Z0-9_-]{20,}` or `api_key=[a-zA-Z0-9]+` patterns across `skills/platform-*/`. |
| Build artifacts / installed packages | None — Phase 6 is plugin-content-only; no Python eggs, no npm builds, no Docker images. | None |

**Canonical question check:** *After every file in the repo is updated, what runtime systems still have the old string cached, stored, or registered?* — **Nothing**. Phase 6 introduces NEW content; no rename / refactor / migration semantics apply.

## Environment Availability

Phase 6 has minimal external dependencies — the work is markdown authoring against locked vendor-doc anchors. Bash + grep are used for the synthesis structure-check.

| Dependency | Required By | Available | Version | Fallback |
|---|---|---|---|---|
| `bash` (Git Bash for Windows / native bash) | `phase6-structure-check.sh` (synthesis plan deliverable) | ✓ | 5.2+ on Git Bash for Windows (verified via Phase 5 script execution) | — |
| `grep` (GNU 3.0+) | All grep gates (shape-parity, vocabulary dedup, `native_ai_path: api` zero-hit, frontmatter presence) | ✓ | GNU grep 3.0 (per Phase 5 phase5-structure-check.sh comment-vs-code policy header) | — |
| Web search (verification of vendor docs) | Q05 / Q06.2 / Q07.2 inline resolutions during execution | ✓ | Built-in WebSearch tool + Brave Search if configured | — (vendor docs already verified during Phase 6 research; execution-time re-verify is optional per D-68) |
| Context7 / WebFetch | Optional fresh re-verification of native-AI matrices at D-68 trigger | ✓ | Built-in MCP / WebFetch tools | Defer re-verification; ship with `tier_claims_last_verified: 2026-05-09` baseline |
| `git` | Per-task commits during plan execution | ✓ | 2.40+ | — |

**Missing dependencies with no fallback:** None.

**Missing dependencies with fallback:** None — Phase 6 has no hard external dependencies.

## Validation Architecture

> `workflow.nyquist_validation` configuration not explicitly set in `.planning/config.json`; treat as enabled.

### Test Framework

Phase 6 is doc-only — there is no application code to unit-test. The validation framework is **bash + grep structural assertions** mirroring the Phase 5 pattern.

| Property | Value |
|----------|-------|
| Framework | bash + GNU grep (no JS / Python test runner) |
| Config file | None — `phase6-structure-check.sh` is self-contained per Phase 5 D-56 pattern |
| Quick run command | `bash .planning/phases/06-internalise-platform-skills/scripts/phase6-structure-check.sh --quick` |
| Full suite command | `bash .planning/phases/06-internalise-platform-skills/scripts/phase6-structure-check.sh` |
| Section run | `bash .../phase6-structure-check.sh --section PLAT-01` (mirrors Phase 5 `--section FOUND-NN`) |

### Phase Requirements → Test Map

| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|---|---|---|---|---|
| PLAT-01 | `platform-pipefy/SKILL.md` + 5 references/ files exist with shape parity | structural | `bash .../phase6-structure-check.sh --section PLAT-01` | ❌ Wave 0 (sub-task in synthesis plan) |
| PLAT-01 | `paginate_all` helper contract present with signature + pseudocode in api-contract.md | structural | `grep -qE '^## paginate_all\b' dydx-delivery/skills/platform-pipefy/references/api-contract.md` | ❌ Wave 0 |
| PLAT-01 | HTML-on-auth-failure gotcha documented (UAT-4.1) | structural | `grep -qF 'Content-Type: text/html' dydx-delivery/skills/platform-pipefy/references/api-contract.md` | ❌ Wave 0 |
| PLAT-01 | Canonical-only endpoint documented (no `api_host` field; per-tenant variants are `web_host` + `org_id` only) | structural | `grep -qF 'api.pipefy.com/graphql' .../api-contract.md` AND `! grep -qF 'pipefy_api_host:' .../api-contract.md` | ❌ Wave 0 |
| PLAT-02 | `platform-wrike/SKILL.md` + 5 references/ files exist | structural | `bash .../phase6-structure-check.sh --section PLAT-02` | ❌ Wave 0 |
| PLAT-02 | OAuth-host persistence pattern documented; no hardcoded `www.wrike.com` | structural | `grep -qF 'OAuth' .../platform-wrike/references/api-contract.md` AND `! grep -qE 'hardcode.*www\.wrike\.com' .../api-contract.md` (the rule must be DOCUMENTED, with `www.wrike.com` appearing only inside an anti-pattern callout) | ❌ Wave 0 |
| PLAT-03 | `platform-ziflow/SKILL.md` + 5 references/ files exist | structural | `bash .../phase6-structure-check.sh --section PLAT-03` | ❌ Wave 0 |
| PLAT-03 | `wait_for_proof` helper contract present | structural | `grep -qE '^## wait_for_proof\b' dydx-delivery/skills/platform-ziflow/references/api-contract.md` | ❌ Wave 0 |
| PLAT-03 | Webhook-PRIMARY framing present (Q05 resolution) | structural | `grep -qiE 'webhook.*(primary|recommended)' dydx-delivery/skills/platform-ziflow/references/api-contract.md` | ❌ Wave 0 |
| PLAT-04 | `tier_claims_last_verified:` frontmatter on all 3 SKILL.md | structural | `for p in pipefy wrike ziflow; do grep -qE '^tier_claims_last_verified: [0-9]{4}-[0-9]{2}-[0-9]{2}' dydx-delivery/skills/platform-$p/SKILL.md || exit 1; done` | ❌ Wave 0 |
| PLAT-05 | `native_ai_path:` enum LOCKED to `paste \| none` (zero `api` hits) | structural | `! grep -r 'native_ai_path: api' dydx-delivery/skills/platform-*/` (zero hits required) | ❌ Wave 0 |
| PLAT-05 | `native_ai_path:` value present + valid on all 3 SKILL.md | structural | `for p in pipefy wrike ziflow; do grep -qE '^native_ai_path: (paste\|none)$' dydx-delivery/skills/platform-$p/SKILL.md \|\| exit 1; done` | ❌ Wave 0 |
| PLAT-06 | Q05 / Q06.2 / Q07.2 Status flipped to `decided` in OPEN-QUESTIONS.md | structural | `for q in Q05 Q06.2 Q07.2; do grep -A 20 "^\*\*OPEN-$q\*\*" .planning/OPEN-QUESTIONS.md \| grep -qE '^- Status: decided' \|\| exit 1; done` | ❌ Wave 0 |
| Cross-cutting | D-59 uniform hard-rules pointer present in all 3 SKILL.md | structural | `for p in pipefy wrike ziflow; do grep -qF 'dydx-delivery/references/safety-rules.md' dydx-delivery/skills/platform-$p/SKILL.md \|\| exit 1; done` | ❌ Wave 0 |
| Cross-cutting (D-66) | Vocabulary dedup: zero glossary-defined terms duplicated in vocabulary.md | structural | Iterate glossary.md term headings; assert each appears 0 times in `skills/platform-*/references/vocabulary.md` as a `**term**` definition | ❌ Wave 0 |
| Cross-cutting | 5-file shape parity across 3 platforms | structural | `for p in pipefy wrike ziflow; do for f in api-contract native-ai-inventory knowledge-ingestion client-shape-gotchas vocabulary; do test -f dydx-delivery/skills/platform-$p/references/$f.md \|\| exit 1; done; done` | ❌ Wave 0 |
| Cross-cutting | `frontmatter_version: 2` on all 3 SKILL.md | structural | `for p in pipefy wrike ziflow; do grep -qE '^frontmatter_version: 2$' dydx-delivery/skills/platform-$p/SKILL.md \|\| exit 1; done` | ❌ Wave 0 |
| Cross-cutting (security) | No real tokens / API keys committed | structural | `! grep -rE '(Bearer [a-zA-Z0-9_-]{20,}\|api[_-]?key[ =:]+[a-zA-Z0-9]{20,})' dydx-delivery/skills/platform-*/` | ❌ Wave 0 |

### Sampling Rate

- **Per task commit:** `bash phase6-structure-check.sh --section <PLAT-NN>` for the section being worked on.
- **Per wave merge:** `bash phase6-structure-check.sh` (full suite, ~40 assertions, expect ~5-10s runtime on Git Bash for Windows mirroring Phase 5 timing).
- **Phase gate:** Full suite green before `/gsd-verify-work`; all PLAT-01..06 sections passing; OPEN-QUESTIONS.md row flips verified.

### Wave 0 Gaps

- [ ] `.planning/phases/06-internalise-platform-skills/scripts/phase6-structure-check.sh` — new file authored by synthesis plan (06-03 trailing or 06-04 split per D-63); mirrors Phase 5 `phase5-structure-check.sh` pattern (~40 PASS assertions; same comment-vs-code policy header; same `--quick` / `--section` invocation modes; same `--exclude-dir=scripts` / `--exclude="*.sh"` / `--exclude="*~"` triple for all absence-checks per G-2 convention).
- [ ] No framework install required — bash + GNU grep are pre-existing per Phase 5 toolchain.

## Common Pitfalls

### Pitfall 1: Treating `wait_for_proof` polling as primary path

**What goes wrong:** Phase 6 author writes `platform-ziflow/references/api-contract.md` documenting the polling helper as the canonical proof-ready detection mechanism, omitting or burying the webhook-primary guidance.

**Why it happens:** DESIGN-16 (authored 2026-05-09) specified the `wait_for_proof` helper as a MOD-6 prevention without naming webhooks as alternative; Q05's name ("read-after-create consistency window") implies polling-frame; vendor research at Phase 6 surfaces webhook-primary as Q05 resolution.

**How to avoid:** `platform-ziflow/references/api-contract.md` § Helper contract section MUST open with a "Primary path: webhook subscription to `processed` event before proof creation" framing, citing `help.ziflow.com/hc/en-us/articles/30725068740244-Webhooks`. The `wait_for_proof` helper appears AFTER that as "FALLBACK ONLY — use when webhook delivery is unavailable (local dev / harness / sandbox)." Validation grep gate (PLAT-03) asserts both phrases present.

**Warning signs:** Section header is `## wait_for_proof` at the top of the helper-contract subsection; missing "webhook" mentions; Q05 resolution one-liner does not cite the webhook URL.

### Pitfall 2: Hardcoding `www.wrike.com` inside a "DO NOT DO THIS" example (false-positive in grep)

**What goes wrong:** PLAT-02 grep gate (`! grep -rF 'www.wrike.com' platform-wrike/`) would trip on a correctly-authored anti-pattern callout — e.g., `"❌ BAD: client.base_url = 'www.wrike.com'  # hardcoded — multi-tenant broken"`.

**Why it happens:** Anti-pattern callouts are pedagogically essential — they're the strongest signal to future Stage 8 helper authors. Naive `grep -F` doesn't distinguish anti-pattern context from real hardcode.

**How to avoid:** Grep gate uses CONTEXT-AWARE pattern — `! grep -E 'base_url\s*=\s*[\"'\''"]https?://www\.wrike\.com' .../api-contract.md` (assert no `base_url = "www.wrike.com"` assignment), allowing `www.wrike.com` to appear inside `❌ ANTI-PATTERN` blockquotes. The validation table row above uses this pattern.

**Warning signs:** Synthesis grep gate fails on a freshly-correct file; verification spent ~30 min on a false-positive.

### Pitfall 3: `tier_claims_last_verified:` shared across all 3 platforms

**What goes wrong:** Phase 6 author sets `tier_claims_last_verified: 2026-05-11` (today) on all 3 SKILL.md frontmatters as a "consistent date" — breaking D-68's per-platform-distinct rule.

**Why it happens:** Authoring on the same day feels uniform; "same date for all three" is mentally tidier than tracking 3 separate dates.

**How to avoid:** D-68 explicitly requires per-platform distinct dates so the 3 platforms can drift at different rates (Ziflow ReviewAI is in active expansion — Change Verification + Brand Standards "Coming Soon" — so its date will move more often than Pipefy's, which is more stable post-2025-11 Agents 2.0 launch). Default baseline `2026-05-09` (DESIGN.md authoring) is acceptable for all 3 IF no fresh re-verification happens in Phase 6 execution. If a fresh re-verification happens during PLAT-NN execution, update ONLY that platform's date. Validation: structural-check asserts presence + ISO format but does NOT require dates to differ (that's a semantic check, not structural).

**Warning signs:** All 3 SKILL.md show `tier_claims_last_verified: <today>` after execution, but no fresh re-verification grep-evidence in any of the 3 native-ai-inventory.md files; commit message lacks per-platform vendor-doc-URL citations.

### Pitfall 4: Mistakenly creating `helpers/` directories as anticipatory stubs

**What goes wrong:** Phase 6 author creates `dydx-delivery/skills/platform-pipefy/helpers/.gitkeep` (or similar) as a "ready-for-Phase-8" signal.

**Why it happens:** Anticipatory directory creation feels organised; the future Phase 8 location is named in DESIGN-29 / D-64 rationale; visible-empty-stub feels like "good documentation."

**How to avoid:** D-64 explicitly rejects this — "anticipatory directories rot" + "zero filesystem footprint over premature signalling." Phase 6 ships ZERO `helpers/` directories. Phase 8 authors them when the test bot needs them. Validation: structural-check assertion `! test -d dydx-delivery/skills/platform-pipefy/helpers/` (and analogues for wrike + ziflow).

**Warning signs:** Phase 6 execution commit includes `git add dydx-delivery/skills/platform-pipefy/helpers/.gitkeep`; synthesis structure-check fails on the new "helpers/ directory exists" assertion.

### Pitfall 5: Duplicating cross-cutting terms in `vocabulary.md`

**What goes wrong:** Phase 6 author defines `frontmatter`, `sandbox`, `native_ai_path`, or `status: lifecycle` terms inside `vocabulary.md` "for skill self-containment" — re-introducing the AUDIT-05.1 duplication anti-pattern at the vocabulary layer.

**Why it happens:** Each platform skill feels like it should "stand alone"; cross-references-to-glossary.md feel like indirection cost; including the term feels safer than pointing.

**How to avoid:** D-66 requires platform-specific terms only; project-wide terms live in `glossary.md`. Synthesis vocabulary-dedup grep gate iterates glossary.md term headings and asserts each appears zero times as a `**term**` definition pattern in `vocabulary.md`. The pointer line at the top of each `vocabulary.md` (`> For project-wide terms see ` `dydx-delivery/references/glossary.md` `.`) is the only place cross-cutting terms are referenced.

**Warning signs:** `vocabulary.md` length > ~100 LOC; defines terms like `frontmatter_version` / `sandbox:` / `native_ai_path` / status lifecycle values that already appear in `glossary.md`.

### Pitfall 6: Pipefy MCP capability claim drift between DESIGN-14 and 2026 vendor messaging

**What goes wrong:** PLAT-01 author lifts DESIGN-14's "MCP integration: yes / HIGH" row verbatim into `platform-pipefy/references/native-ai-inventory.md` without re-verifying against current Pipefy AI Agents 2.0 launch docs (Nov 2025).

**Why it happens:** DESIGN-14 was authored 2026-05-09 with HIGH confidence; CONTEXT D-65 / D-68 says "lift verbatim then optionally re-verify"; the row reads coherent.

**How to avoid:** Phase 6 research (this document) flagged the MCP row as "vendor messaging contradictory" — one secondary 2026 source states Pipefy is not designed to ingest agents via MCP. PLAT-01 SHOULD re-verify against pipefy.com + Pipefy AI Agents 2.0 launch announcement (`globenewswire.com/news-release/2025/11/12/3186348`) and either (a) confirm HIGH and leave row unchanged, or (b) downgrade to MEDIUM with a footnote citing the contradiction. If a fresh re-verification happens, bump `tier_claims_last_verified:` to the execution date and cite the source URL in commit message.

**Warning signs:** Pipefy `native-ai-inventory.md` shows MCP row at HIGH confidence with no footnote / no citation, AND `tier_claims_last_verified: 2026-05-09` (unchanged from baseline) — signals lift-without-re-verify.

## Code Examples

These are illustrative Markdown patterns for the platform skills. None are executable code.

### Example 1: `SKILL.md` opening boilerplate (Pipefy template)

```markdown
---
name: platform-pipefy
description: Provide Pipefy GraphQL API contract + 2026 AI Agents capability matrix + per-client shape gotchas + vocabulary for any stage skill that targets a Pipefy tenant. Use when artefact frontmatter carries `platform: pipefy`. Documents the `paginate_all` helper contract for cursor pagination; the HTML-on-auth-failure detection rule (Pipefy returns Keycloak login HTML, not JSON 401); the canonical-only API endpoint (`api.pipefy.com/graphql` for ALL tenants); paste-only native-AI ingestion path per UAT-6.1. Does NOT execute API calls — pure reference content for skills + Stage 8 test bot.
frontmatter_version: 2
platform: pipefy
tier_claims_last_verified: 2026-05-09
native_ai_path: paste
---

# platform-pipefy

Pipefy platform reference for the dydx-delivery plugin. Any stage skill operating
against a Pipefy tenant loads this skill alongside the stage-specific skill;
artefact frontmatter `platform: pipefy` is the routing key.

## Inputs

- An artefact carrying `platform: pipefy` frontmatter
- A `sandbox:` block naming the sandbox `pipe_id`, `org_id`, and `tenant:` per
  `dydx-delivery/references/frontmatter-scheme.md` § Platform-gated identifiers

## Output

This skill produces NO artefacts. It is a reference skill — consumed by other
stage skills (Stage 4a / 7b / 8 / 10) and by the Stage 8 test bot (v2.4 / Phase 8)
for API client construction.

## Hard rules

> **Hard rules:** Sandbox-only operations. Read-write only against named sandbox tenants. Refuses destructive actions. See `dydx-delivery/references/safety-rules.md` for the canonical ruleset.

## What this skill provides

- `references/api-contract.md` — GraphQL endpoint (canonical-only `api.pipefy.com/graphql`),
  auth header shape, rate limit (500 req/30s ceiling; 13 req/sec throttle), HTML-on-auth-failure
  detection (UAT-4.1), `paginate_all` helper contract (MOD-4).
- `references/native-ai-inventory.md` — 2026 AI Agents 2.0 capability matrix
  (KB / Skills / MCP / IDP / Web Search / BYO-LLM).
- `references/knowledge-ingestion.md` — Paste-only Stage 10 path (UAT-6.1).
- `references/client-shape-gotchas.md` — Per-client pipe shape variations
  (Vodacom custom-subdomain verified seed).
- `references/vocabulary.md` — Pipefy-specific terms.

## Re-verification trigger

Re-verify `references/native-ai-inventory.md` against current Pipefy AI Agents
documentation BEFORE any v2.x phase that consumes the capability matrix:
- Stage 4a delivery routing (consumes confidence ratings)
- Stage 7b implementation prompt (consumes capability surface list)
- Stage 10 native-AI paste bundle (consumes paste targets — Behaviors instructions
  + KB upload list)

Update `tier_claims_last_verified:` on this SKILL.md frontmatter after each
re-verification, citing the source doc URL + date in commit message.
Doc URL anchor: https://www.pipefy.com/ + Pipefy Help Center.
```

**Source:** Pattern derived from `dydx-delivery/skills/discovery-intake/SKILL.md:1-9` (frontmatter) + `dydx-delivery/skills/execute-tests/SKILL.md:22` (D-59 uniform pointer) + CONTEXT D-68 re-verification trigger boilerplate.

### Example 2: `api-contract.md` helper-contract structure (Pipefy `paginate_all`)

```markdown
## paginate_all

**Signature:** `paginate_all(query: str, cursor_field: str = "endCursor", page_size: int = 50) -> list[dict]`

**Behaviour:** Iterates Pipefy GraphQL cursor pagination across multi-page result
sets until `pageInfo.hasNextPage == false`. Returns the accumulated flat list of
records across all pages. Prevents the silent-truncation bug (MOD-4) that occurs
when consumer skills assume a single-page response covers all records.

**Retry / poll budget:** Per-page request retries on HTTP 429 with exponential
backoff. Throttle ceiling: **13 req/sec per token (80% of 16.67 req/sec ceiling
= 500 req / 30s per token)**. Max retries per page = 3; backoff curve `[1s, 2s, 4s]`.
Total budget per page = ~7s before raising.

**Failure modes:**
- HTML response with `Content-Type: text/html` (Keycloak login HTML; UAT-4.1) →
  raise `PipefyAuthFailed` (NOT a JSON 401 — this is the Pipefy-specific
  auth-failure shape; see § Auth-failure detection above).
- HTTP 429 after max retries → raise `PipefyRateLimitExhausted`.
- Cursor field missing in response → raise `PipefyPaginationContractError`
  (signals API contract drift).
- Empty first page → return `[]` (not an error).

**Return shape:** `list[dict]` — flat accumulation of `result.edges[].node`
payloads across all pages.

**Pseudocode (doc-only; Stage 8 test bot authors real implementation per D-64):**

\`\`\`python
def paginate_all(query: str, cursor_field: str = "endCursor", page_size: int = 50) -> list[dict]:
    results = []
    cursor = None
    while True:
        page = _execute_with_throttle(query, cursor=cursor, page_size=page_size,
                                       throttle_req_per_sec=13)
        if page.headers.get("Content-Type", "").startswith("text/html"):
            raise PipefyAuthFailed("Keycloak login HTML received; token invalid or expired")
        data = page.json()
        results.extend(node for node in data["result"]["edges"])
        page_info = data["result"]["pageInfo"]
        if not page_info["hasNextPage"]:
            break
        cursor = page_info[cursor_field]
    return results
\`\`\`

**Worked example:** Querying all cards in a pipe with 247 cards (5 pages × 50 +
final page × 47) → returns flat `list[dict]` of length 247. Single per-page
HTTP 429 → 1s backoff → retry → succeeds; surface result identical to clean-path.
```

**Source:** Derived from DESIGN-14 (`.planning/DESIGN.md:440`) + UAT-4.1 HTML-auth detection (`.planning/DESIGN.md:447`) + Phase 5 connector-matrix.md `:72` throttle ceiling + CONTEXT D-64 helper-contract structure (signature + behaviour + retry/poll budget + failure modes + return shape + pseudocode + worked example).

### Example 3: `client-shape-gotchas.md` seed structure (Wrike — VodafoneZiggo verified)

```markdown
# Wrike — Client shape gotchas

> Append-only — new client shapes added per first-engagement; existing rows
> preserved for audit trail.

## Known shapes (verified)

### VodafoneZiggo (EU region — verified per DESIGN-15 + UAT-4.1, 2026-05-10)

- **Host (OAuth-persisted):** `app-eu.wrike.com`
- **Account ID:** `5996999`
- **Entry URL pattern:** `https://app-eu.wrike.com/workspace.htm?acc=5996999`
- **Regional context:** EU region — confirms regional host variation; hardcoding
  `www.wrike.com` would route to US-1 region and fail auth.
- **Source artefact:** DESIGN-15 `.planning/DESIGN.md:488` (worked example).

## Pattern slots (variant taxonomy)

### Regional host variants

Wrike returns different OAuth `host` values per tenant's region:
- US-1 region: `www.wrike.com` (the canonical default; do NOT hardcode — must
  still come from OAuth response)
- US-2 region: `app-us2.wrike.com`
- EU region: `app-eu.wrike.com`
- Future regions: handled by reading whatever value OAuth returns; no code
  changes required if Wrike adds new regional hosts.

### Account ID per tenant

Every Wrike tenant has a unique `account_id` (e.g., VodafoneZiggo = `5996999`).
The entry URL `<host>/workspace.htm?acc=<account_id>` requires both the
OAuth-persisted host AND the per-tenant account_id.

### Space + project nesting

Wrike's hierarchy is Space → Folder → Task. Per-client space_id varies; per-CR
project may be a Folder within the space OR a separate Space depending on client
preference. `client_state.yaml.wrike.sandbox_space_id:` captures the per-CR
working space.

### Custom field IDs per tenant

Each Wrike tenant defines custom fields by ID, not by name. Per-client mapping
table (custom field name → custom field ID) is captured at `<Client> Brain/00_HUB.md`
Coda block per DESIGN-29.

## How to add a new shape

When onboarding a new client, append a verified row to `## Known shapes (verified)`
citing the engagement date + source artefact. Pattern slots are append-only;
existing rows are preserved for audit trail.
```

**Source:** DESIGN-15 worked example (`.planning/DESIGN.md:488`) + Phase 5 OPEN-Q13 resolution (`dydx-delivery/references/connector-matrix.md:78`) + CONTEXT D-65 seeding rule.

## State of the Art

| Old Approach (v0.3.0 / pre-Phase-5) | Current Approach (Phase 6 ships) | When Changed | Impact |
|---|---|---|---|
| Hard-rules inlined into 4 separate skill files | Single SoT at `dydx-delivery/references/safety-rules.md` + D-59 uniform-pointer in every skill | Phase 5 (AUDIT-05.1 + FOUND-01 + FOUND-05) | Phase 6 platform SKILL.md inherit the pattern — they POINT, never INLINE. |
| `native_ai_path: api \| paste \| none` (3-value enum per DESIGN-26 baseline) | `native_ai_path: paste \| none` ONLY (2-value enum per UAT-6.1) | 2026-05-10 UAT-6.1 lock | Phase 6 ships the 2-value enum across all 3 platform skills; `grep -r 'native_ai_path: api'` zero-hit gate enforces. |
| Per-tenant `pipefy_api_host:` field (assumed multi-host per DESIGN-14 baseline) | Canonical-only `api.pipefy.com/graphql` for ALL tenants (per Q24 DNS verification) | 2026-05-10 UAT-4.1 lock | Phase 6 DESIGN-14 is REVISED — `api_host` field REMOVED from DESIGN-29 schema; only `web_host` + `org_id` are per-tenant. |
| Polling-first read-after-create (DESIGN-16 baseline framing) | Webhook-PRIMARY + polling FALLBACK (per 2026-05-11 vendor research; Q05 resolution) | 2026-05-11 (this research) | Phase 6 ships api-contract.md with webhook-primary framing; `wait_for_proof` is documented as bounded-budget fallback. |
| 16 Wrike MCP tools (per DESIGN-15 baseline) | 47 Wrike MCP tools (per current vendor count 2026-05-11 — stackone.com) | Sometime between 2026-05-09 (DESIGN authoring) and 2026-05-11 (Phase 6 research) | PLAT-02 SHOULD re-count + cite `developers.wrike.com/wrike-mcp/` for canonical count; if confirmed, bump `tier_claims_last_verified:` to execution date. |
| Pipefy AI Agents (pre-2.0 — v2.x framing in DESIGN-14) | Pipefy AI Agents 2.0 + IDP (per Nov 2025 launch announcement) | Nov 2025 (vendor launch) | DESIGN-14 capability matrix may need IDP row enhancement to "Agents 2.0 native" subtitle; MCP row may need re-verify (see §Common Pitfalls #6). |

**Deprecated / outdated:**
- **`native_ai_path: api` branch** — Removed entirely per UAT-6.1. Any reference to this enum value in a platform skill is a PLAT-05 violation.
- **Hardcoded Wrike `www.wrike.com` base URL** — Multi-tenant-broken per MOD-5. Phase 6 documents the OAuth-host persistence pattern as the only correct approach.
- **`pipefy_api_host:` per-tenant field** — Removed from DESIGN-29 per UAT-4.1 / Q24. Per-tenant variation is `web_host` + `org_id` ONLY.

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|---|---|---|
| A1 | Pipefy AI Agents 2.0 retains MCP support in 2026-05 | §Native-AI Capability Matrices (Pipefy MCP row) + §Common Pitfalls #6 | If MCP support has been deprecated or never shipped as inbound-third-party-agent-ingestion, the DESIGN-14 row needs downgrade to "no / N/A" rather than HIGH. Impact: PLAT-01 native-ai-inventory.md MCP row reads stale; Stage 7b implementation prompt later proposes MCP integration that fails. Mitigation: PLAT-01 execution re-verifies against `pipefy.com` + `globenewswire.com/news-release/2025/11/12/3186348` (Nov 2025 launch) and either confirms HIGH or downgrades. |
| A2 | Wrike MCP Server tool count = 47 (per stackone.com 2026-05-11) is canonical | §Standard Stack (Wrike row) + §Native-AI Capability Matrices (Wrike MCP row) | Tool count from a third-party integration vendor's MCP listing may not match `developers.wrike.com/wrike-mcp/` canonical. Could be over-count (stackone groups tools) or under-count (stackone hasn't synced latest). Impact: native-ai-inventory.md MCP row cites wrong count. Mitigation: PLAT-02 execution re-counts from `developers.wrike.com/wrike-mcp/` directly. |
| A3 | Q05 resolution (30s/2s polling defaults) is correct for the fallback path | §Q05 Resolution + §Helper-Function Specs (wait_for_proof) | Actual Ziflow proof-ready time could exceed 30s in some sandbox regions or proof types, OR be uniformly under ~5s (making 2s interval too coarse). Impact: `wait_for_proof` falls back to raising `ZiflowProofNotReady` more than expected, or wastes poll budget unnecessarily. Mitigation: DESIGN-16 explicitly tagged this as "conservative default"; Stage 8 test bot can override `max_wait_s` per test case. The defaults are documented, not enforced. |
| A4 | Pipefy 13 req/sec helper-throttle (80% of 16.67 ceiling) is appropriate for `paginate_all` use cases | §Q06.2 Resolution + §Helper-Function Specs (paginate_all) | If `paginate_all` is called concurrently from multiple workers sharing a token, aggregate throughput exceeds the ceiling. Impact: 429 cascade in production-like sandbox runs. Mitigation: 80% buffer absorbs some concurrency; Stage 8 test bot serialises per-token per `auth_concurrency_class: exclusive`. |
| A5 | Phase 5 connector-matrix.md throttle ceilings (13 req/sec Pipefy / 320 req/min/user Wrike) are still current at Phase 6 execution time | §Standard Stack (Vendor Doc Landscape) | Vendors may revise rate limits between Phase 5 (2026-05-10) and Phase 6 execution. Impact: helpers throttle at wrong rate. Mitigation: 2026-05-11 web search re-confirmed both numbers via independent vendor docs; <2 day gap. PLAT-01 / PLAT-02 execution can re-verify cheaply. |
| A6 | The 2 documented clients per `.claude/memory/reference_client_brain_coda_docs.md` (Up & Up Group + VodafoneZiggo) cover the seed cases for D-65 Ziflow gotchas | §5-File References Outline (client-shape-gotchas Ziflow) | Other clients may have established Ziflow tenants that should seed `client-shape-gotchas.md`. Impact: PLAT-03 ships with placeholder-only Ziflow gotchas. Mitigation: Memory file is canonical per CONTEXT `<code_context>`; D-65 explicitly accepts `<TBD at first engagement>` placeholder. Real shapes added per-engagement append-only. |

**Assumptions Log status:** 6 assumed claims; all surface for planner / discuss-phase / execute-phase review BEFORE the assumed value becomes a locked artefact decision. None of A1-A6 block planning — all are "could be verified at execution time" rather than "must be resolved before planning."

## Open Questions

1. **Does PLAT-01 need to add an `IDP-Agents 2.0` distinguishing subtitle to the Pipefy native-AI capability matrix?**
   - What we know: Pipefy AI Agents 2.0 launched Nov 2025; IDP is described as "embedded as a native workflow capability" with 46% of agents already using IDP/OCR per launch announcement.
   - What's unclear: Whether DESIGN-14's "IDP / HIGH" row needs revision to call out Agents 2.0 native vs Agents 1.x add-on.
   - Recommendation: Treat as PLAT-01 execution discretion (D-68 fresh re-verification path). If PLAT-01 author re-verifies and the Agents 2.0 IDP integration is materially different from DESIGN-14 baseline, update the row + bump `tier_claims_last_verified:`.

2. **Is the Pipe Reports Export sub-limit (25 req / 24h per pipe) relevant for any `paginate_all` use case in Phase 6 / Phase 8?**
   - What we know: Pipefy Community confirms a separate sub-ceiling for Pipe Reports Export endpoints (25 req / 24h per pipe; tighter than the general 500/30s).
   - What's unclear: Whether any Stage 4a / 7b / 8 use case actually calls a Pipe Reports Export endpoint, or whether `paginate_all` is only used against Cards / Phases / Pipes list endpoints.
   - Recommendation: Document in `api-contract.md` § Rate limit + throttle subsection as "be aware of sub-ceiling for Pipe Reports Export; consumer skills MUST track per-day budget when targeting these endpoints"; Stage 8 test bot can add a per-day-budget assertion later. Not blocking Phase 6.

3. **Should `wait_for_proof` accept an optional `webhook_listener_url` parameter for the rare case where polling is the chosen path despite webhook availability?**
   - What we know: D-64 says doc-only contracts; the helper signature shipped is what Stage 8 will implement.
   - What's unclear: Whether the helper should expose an explicit "webhook unavailable" flag, or whether webhook-vs-polling routing happens above the helper layer (in the caller).
   - Recommendation: Keep helper signature minimal (no webhook param). Document at `api-contract.md` top: "Webhook path is the caller's responsibility — `wait_for_proof` is the explicit fallback when caller has not subscribed to the `processed` event webhook." PLAT-03 execution discretion.

## Security Domain

> `security_enforcement` defaults to enabled when absent from `.planning/config.json`.

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---|---|---|
| V2 Authentication | yes | Document auth header SHAPE only (`Authorization: Bearer <token>`); NEVER real tokens. Per-platform auth-failure detection (Pipefy HTML / Wrike+Ziflow JSON 401). |
| V3 Session Management | no | No session state in platform SKILL.md content. Tokens live in per-tenant `client_state.yaml` (gitignored) per Phase 5 connector-matrix.md security note. |
| V4 Access Control | yes (indirect) | Sandbox-only enforcement via D-59 uniform pointer to `safety-rules.md` Rule 1 (allowlist); Rule 2 (no deletions); Rule 3 (no destructive integrations outside scope). Reinforces in each platform SKILL.md. |
| V5 Input Validation | partial | `validate-frontmatter` hook (substantive impl deferred to v2.6) validates `platform:` enum membership, platform-gated identifier rules, `native_ai_path:` enum lock. Phase 6 establishes the schema; v2.6 enforces. |
| V6 Cryptography | no | No cryptographic operations in Phase 6 (doc-only). |

### Known Threat Patterns for {Phase 6 doc-only platform-skill content}

| Pattern | STRIDE | Standard Mitigation |
|---|---|---|
| Real token / API key committed to platform skill content (e.g., copied from a working example) | Information Disclosure | Validation grep gate: `! grep -rE '(Bearer [a-zA-Z0-9_-]{20,}\|api[_-]?key[ =:]+[a-zA-Z0-9]{20,})' dydx-delivery/skills/platform-*/`. Synthesis structure-check enforces zero hits. Platform skills document auth SHAPE only. |
| Pipefy auth-failure parsed as JSON (the HTML response triggers `JSONDecodeError`, masked as a generic error) | Tampering / Repudiation | `api-contract.md` § Auth-failure detection subsection (UAT-4.1) documents the `Content-Type` check BEFORE JSON parse. Stage 8 test bot tier-1 enforces HTML-detect → `auth_failed` failure class. |
| Hardcoded `www.wrike.com` routes auth + reads to wrong region (e.g., EU tenant data leaks if non-EU US-1 has a same-named tenant) | Information Disclosure / Repudiation | OAuth-host persistence pattern (MOD-5) prevents; validation grep gate asserts no `base_url = "www.wrike.com"` assignment in `api-contract.md`. Anti-pattern callouts permitted (must be visibly framed). |
| `native_ai_path: api` accidentally re-introduced (e.g., copied from DESIGN-26 baseline before UAT-6.1 lock) | Repudiation | Validation grep gate (PLAT-05): `! grep -r 'native_ai_path: api' dydx-delivery/skills/platform-*/`. Zero hits required. |
| Cross-platform identifier leak in frontmatter (e.g., Wrike artefact carrying Pipefy `pipe_id`) | Confidentiality | Platform-gated identifiers per DESIGN-01 / Phase 5 `frontmatter-scheme.md` § Platform-gated identifiers. `validate-frontmatter` hook (v2.6 substantive impl) rejects mismatches. Phase 6 establishes the schema; hook enforces. |
| Stale `tier_claims_last_verified:` (>6 months) leads to consumer skill acting on outdated capability claims | Tampering (via stale data) | D-68 event-based re-verification trigger (not calendar) ties freshness to consumer-stage invocation; Stage 4a / 7b / 10 skills MUST re-verify before consuming the matrix. |

### Sandbox enforcement boundary (carried from Phase 5)

Platform skills DO NOT call APIs in Phase 6 — they document them. The sandbox enforcement boundary (Phase 5 `safety-rules.md` Rule 1) applies to the Stage 8 test bot (v2.4 / Phase 8) when it implements the helpers; Phase 6 ships the references the bot reads. Documenting auth header SHAPE only (no real tokens) means there is no secret-leak surface in the platform skills themselves.

## Sources

### Primary (HIGH confidence)

- `.planning/phases/06-internalise-platform-skills/06-CONTEXT.md` — 241 lines; locked D-63..D-68 + 8 spec_lock items; full canonical-refs list; deferred items
- `.planning/phases/06-internalise-platform-skills/06-DISCUSSION-LOG.md` — 161 lines; 4 area decisions + scope-creep redirects (none)
- `.planning/REQUIREMENTS.md` § Phase 6 (lines 122-131) — PLAT-01..06 spec rows
- `.planning/ROADMAP.md` § Phase 6 (lines 213-224) — 5 success criteria + approval gate
- `.planning/DESIGN.md` § DESIGN-14 / 15 / 16 (lines 408-543) — locked platform-skill structure + worked examples + helper specs + frontmatter contracts
- `.planning/OPEN-QUESTIONS.md` Q05 / Q06.1 / Q06.2 / Q07.1 / Q07.2 (lines 107-162) — proposed defaults + Phase 5 Q06.1 / Q07.1 resolutions cited at connector-matrix.md `:72-73`
- `dydx-delivery/references/connector-matrix.md` — 8 OPEN-Q inline resolutions (FOUND-13); throttle ceilings 13 req/sec Pipefy `:72` + 320 req/min/user Wrike `:73`; Q13 OAuth-host persistence at `:78`
- `dydx-delivery/references/safety-rules.md` — Phase 5 FOUND-01 LIVE; Rule 1 sandbox enforcement (per-call allowlist check)
- `dydx-delivery/references/frontmatter-scheme.md` — Phase 5 FOUND-03 LIVE; canonical scheme that platform SKILL.md frontmatter conforms to + extends
- `dydx-delivery/references/glossary.md` — Phase 5 FOUND-04 LIVE; project-wide vocabulary that `vocabulary.md` files point at
- `dydx-delivery/skills/discovery-intake/SKILL.md` + `dydx-delivery/skills/execute-tests/SKILL.md` — existing v0.3.0 skill SKILL.md shape templates; D-59 uniform-pointer instance at execute-tests:22
- `dydx-delivery/.claude-plugin/plugin.json` — manifest at `2.0.0` per Phase 5 FOUND-07; `dydx-delivery/skills/` is the plugin skill discovery path
- `.claude/memory/feedback_platform_skills_api_first.md` — UAT-3.5 verbatim (Pipefy/Wrike/Ziflow API-only through v2.6; MCP parked)
- `.claude/memory/reference_client_brain_coda_docs.md` — Up & Up Group + VodafoneZiggo named as 2 established clients with Coda brain docs (Stage 11 mirror targets); informs D-65 Ziflow seeding

### Secondary (HIGH confidence — vendor docs cross-verified)

- Pipefy GraphQL rate limit: `community.pipefy.com/customs-apps-integrations-75/what-are-the-graphql-api-limits-958` — 500 req/30s per token + Pipe Reports Export sub-limit (25 req / 24h per pipe). Cross-verified via Phase 5 2026-05-10 search + Phase 6 2026-05-11 re-search.
- Wrike REST rate limit: `help.wrike.com/hc/en-us/articles/23908384596631-Resolve-Common-REST-API-Errors` — 400 req/min per user + 5000 req/min per IP. Cross-verified via Phase 5 2026-05-10 search + Phase 6 2026-05-11 re-search.
- Ziflow webhook-vs-polling guidance: `help.ziflow.com/hc/en-us/articles/30725068740244-Webhooks` + `help.ziflow.com/hc/en-us/articles/30721919730836-Embedded-Review-Approval` — direct vendor recommendation: "Use webhooks instead of polling the Ziflow API for updates."
- Ziflow ReviewAI feature status: `help.ziflow.com/hc/en-us/articles/41711066855956-Use-ReviewAI` + `ziflow.com/blog/introducing-checklists-more-creative-reviews` (Checklists Public Preview on Enterprise plan) + `ziflow.com/reviewai` + `ziflow.com/blog/take-control-of-your-review-and-approval-process` (Change Verification + Brand Standards "Coming Soon").
- Ziflow April 2026 release notes 26.08: `help.ziflow.com/hc/en-us/articles/48181732374676-April-2026-release-notes-26-08` — Checklist Templates API endpoints shipped.
- Pipefy AI Agents 2.0 launch: `globenewswire.com/news-release/2025/11/12/3186348` + `processexcellencenetwork.com/ai/news/pipefy-launches-ai-agents-20-intelligent-document-processing-idp` (Nov 2025 launch announcement; KB + Skills + MCP + IDP + Web Search + BYO-LLM capabilities).
- Wrike MCP Server: `wrike.com/newsroom/wrike-launches-mcp-server-empowering-third-party-ai-agents-with-real-time-work-management-intelligence` + `developers.wrike.com/wrike-mcp/` + `wrike.com/ai/mcp/` (Wrike MCP Server GA; Microsoft Copilot + Claude + ChatGPT + Cursor compatible).
- Wrike Copilot real-time AI: `reworked.co/collaboration-productivity/wrike-expands-copilot-with-real-time-ai-assistance-for-enterprise-teams/`.

### Tertiary (MEDIUM-LOW confidence — flag for re-verify at execution)

- Wrike MCP tool count = 47 per `stackone.com/connectors/wrike/mcp/` (2026-05-11) — third-party integration vendor MCP listing; canonical count should be re-verified against `developers.wrike.com/wrike-mcp/` direct at PLAT-02.
- Pipefy MCP support contradiction: one secondary AI-agent-platform-comparison article (`kore.ai/blog/best-ai-agent-management-platforms`) states "Pipefy is not designed to ingest agents built on third-party frameworks through standard protocols like A2A or MCP" — contradicts DESIGN-14 / launch announcement. PLAT-01 MUST re-verify directly against `pipefy.com` documentation.

## Metadata

**Confidence breakdown:**
- **Locked architecture (DESIGN-14 / 15 / 16; D-63..D-68; UAT-3.5 / 4.1 / 4.2 / 6.1):** HIGH — CONTEXT.md is the source-of-truth and locks all structural decisions.
- **Standard stack (Phase 5 canonical references; existing SKILL.md frontmatter shape; vendor doc anchors):** HIGH — Phase 5 references are LIVE on disk; vendor doc URLs cross-verified 2026-05-11.
- **Q05 / Q06.2 / Q07.2 resolutions:** HIGH — Q05 has unambiguous vendor webhook-primary guidance; Q06.2 / Q07.2 are derivations from Phase 5 already-resolved Q06.1 / Q07.1 + the DESIGN-22 80%-of-ceiling rule.
- **Native-AI capability matrices:** MIXED — Ziflow ReviewAI surfaces confirmed (HIGH); Wrike MCP tool count delta flagged for re-verify (MEDIUM); Pipefy MCP row flagged for re-verify due to vendor messaging contradiction (MEDIUM).
- **Common pitfalls + anti-patterns:** HIGH — derived from CONTEXT.md locks + Phase 5 D-59 / D-66 patterns + AUDIT-05.1 anti-pattern catalogue.

**Research date:** 2026-05-11

**Valid until:** ~2026-06-11 (30 days for the rate-limit + native-AI capability matrices given the active Ziflow ReviewAI "Coming Soon" feature flow); ~2026-08-11 (90 days for the locked architecture decisions). **Re-verify trigger** is event-based per D-68 — re-verify when any v2.x phase consuming the matrix begins (Stage 4a / 7b / 10).

## RESEARCH COMPLETE

**Phase:** 6 — Internalise Platform Skills
**Confidence:** HIGH (locked architecture + Phase 5 canonical references + vendor docs cross-verified 2026-05-11)

### Key Findings

- **Q05 (Ziflow read-after-create) resolved with webhook-PRIMARY framing.** Vendor explicitly recommends webhooks; `wait_for_proof(max_wait_s=30, interval_s=2)` is the documented FALLBACK for webhook-unavailable environments.
- **Q06.2 (Pipefy throttle) = 13 req/sec per token** (80% of 16.67 ceiling = 500 req / 30s; resolves Q06.2 by reading Phase 5 connector-matrix.md `:72` and applying DESIGN-22 80%-rule).
- **Q07.2 (Wrike throttle) = 320 req/min per user** (80% of 400 ceiling; resolves Q07.2 by reading Phase 5 connector-matrix.md `:73` and applying DESIGN-22 80%-rule).
- **Pipefy MCP capability row needs re-verify at PLAT-01 execution** — DESIGN-14 says HIGH; one 2026 secondary source contradicts. Not blocking; flag for execution-time check against `pipefy.com` / Nov 2025 launch announcement.
- **Wrike MCP Server tool count grew from 16 (DESIGN-15) to 47 (stackone.com 2026-05-11)** — PLAT-02 should re-count from `developers.wrike.com/wrike-mcp/` and update `tier_claims_last_verified:` if confirmed.
- **3-plan per-platform decomposition is the right grain** (per CONTEXT D-63); 06-03 likely splits to 06-04 at ~400 LOC threshold per CONTEXT discretion.
- **Phase 6 is structurally identical to Phase 5 in shape** (~40-assertion structure-check; doc-only; 5-file references shape; uniform pointer pattern; single-owner synthesis for `.planning/OPEN-QUESTIONS.md` row flips).

### File Created

`.planning/phases/06-internalise-platform-skills/06-RESEARCH.md` (this file)

### Confidence Assessment

| Area | Level | Reason |
|---|---|---|
| Locked architecture (DESIGN + CONTEXT) | HIGH | All structural decisions locked in v2.0 + Phase 5 + CONTEXT D-63..D-68 |
| Standard stack (Phase 5 refs + vendor doc anchors) | HIGH | Phase 5 LIVE on disk; vendor URLs cross-verified 2026-05-11 |
| Q05 / Q06.2 / Q07.2 inline resolutions | HIGH | Webhook-primary unambiguous; throttle derivations apply locked DESIGN-22 80%-rule |
| Native-AI capability matrices | MEDIUM (mixed) | Ziflow HIGH; Wrike tool count MEDIUM (delta); Pipefy MCP row MEDIUM (contradiction) — all flagged for execution-time re-verify per D-68 |
| Common pitfalls + validation architecture | HIGH | Derived from CONTEXT locks + Phase 5 D-59 / D-66 patterns; structure-check pattern mirrors Phase 5 (~40 assertions) |

### Open Questions

1. Pipefy IDP-Agents 2.0 row enhancement (PLAT-01 execution discretion per D-68 fresh re-verify path)
2. Pipe Reports Export sub-limit relevance for any `paginate_all` use case (document in api-contract.md; not blocking)
3. `wait_for_proof` optional webhook_listener_url parameter (PLAT-03 execution discretion; recommend keeping signature minimal)

### Ready for Planning

Research complete. Planner can now create 3 plans per CONTEXT D-63 (or 4 with synthesis split per D-63 LOC threshold). All locked decisions surfaced; all 3 OPEN-Q resolutions have concrete values to land in respective `api-contract.md` files; validation architecture mapped to ~17 structural assertions across 6 PLAT requirements + 5 cross-cutting checks.
