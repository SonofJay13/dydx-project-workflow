# Phase 6: Internalise Platform Skills — Context

**Gathered:** 2026-05-11
**Status:** Ready for planning

<domain>

## Phase Boundary

Phase 6 ships `dydx-delivery/skills/platform-{pipefy,wrike,ziflow}/` — three NEW platform skills, each with `SKILL.md` + the locked 5-file `references/` shape (`api-contract.md`, `native-ai-inventory.md`, `knowledge-ingestion.md`, `client-shape-gotchas.md`, `vocabulary.md`) per DESIGN-14/15/16. Each `api-contract.md` documents the per-platform helper that closes the known gap (Pipefy `paginate_all` for GraphQL cursor pagination per MOD-4; Wrike OAuth-host persistence per MOD-5; Ziflow `wait_for_proof` for read-after-create eventual consistency per MOD-6). Frontmatter contracts are locked: `tier_claims_last_verified:` (date stamp per MOD-7) and `native_ai_path:` enum locked to `paste | none` ONLY (UAT-6.1 — no `api` branch). 3 throttle/consistency OPEN-Qs resolve inline (Q05 Ziflow read-after-create window / Q06.2 Pipefy throttle calibration / Q07.2 Wrike throttle calibration).

**Closes milestone v2.1.** Every later v2.x phase that loads a platform skill — Stage 4 fnspec split, Stage 5 tech spec, Stage 7b implementation prompt, Stage 8 test bot, Stage 10 native-AI push — inherits clean platform-skill contracts from this phase.

**Boundary with Phase 5:** Phase 5 (✓ COMPLETE, verifier PASS 13/13 FOUND-XX, awaiting human approval gate per STATE.md @ 4f22854) landed the canonical references at `dydx-delivery/references/{safety-rules.md, stage-numbering.md, frontmatter-scheme.md, glossary.md, connector-matrix.md}`. Phase 6 platform-skill `SKILL.md` bodies point at those canonical refs (uniform pointer pattern per D-59 from Phase 5).

**Boundary with v2.0 milestone:** v2.0 (AUDIT.md / DESIGN.md / CHANGELIST.md / OPEN-QUESTIONS.md, approved 2026-05-10) provides the locked architecture. Phase 6 implements DESIGN-14 (REVISED post-UAT-4.1 — canonical-only Pipefy API endpoint + HTML-on-auth-failure gotcha) / DESIGN-15 / DESIGN-16 + the 3 Phase-6-owned OPEN-Q rows. Phase 6 does NOT re-derive scope — it executes pre-locked decisions.

**Boundary with Stage 8 / v2.4 (Phase 8 test bot):** Phase 6 ships **doc-only** helper contracts (signature + behaviour + retry/poll budget + pseudocode + worked example). Phase 6 does NOT ship executable `.py`/`.js` helper modules. The Stage 8 test bot (v2.4 / Phase 8 per CHANGELIST.md) authors `skills/platform-*/helpers/*.py` against the documented contract — that's the lift point. Carries Phase 5 D-56 precedent (connector-matrix.md = doc-only).

**Out-of-scope for Phase 6 (deferred):**
- Executable helper modules under `skills/platform-*/helpers/` (deferred to Phase 8 / v2.4)
- Stage 4a/4b/5/6/7a/7b/8/10 skill edits that *consume* these platform skills (per CHANGELIST.md Phase Ordering Rationale — milestone v2.2+)
- MCP-based platform calls (UAT-3.5 — MCPs OUT-OF-SCOPE through v2.6; api-contract.md may park MCP refs but not as adoption path)
- Native-AI ingestion API branch (UAT-6.1 — `native_ai_path: api` is FORBIDDEN; `grep -r 'native_ai_path: api' skills/platform-*/` MUST return zero hits per PLAT-05)
- Plugin self-test pytest harness for the helper pseudocode (OPEN-Q22 routes to Phase 9 owner)
- Production-tenant access for any platform (sandbox-only enforcement preserved per safety-rules.md)

</domain>

<spec_lock>

## Locked Requirements (carried from v2.0 design-lock + Phase 5 — DO NOT re-litigate)

These were decided in v2.0 milestone (AUDIT / DESIGN / CHANGELIST / OPEN-QUESTIONS, all approved 2026-05-10), during the v2.0 UAT pass on 2026-05-10, and during Phase 5 execution (2026-05-10). Phase 6 plans MUST honour them verbatim:

- **UAT-3.5 — MCPs OUT-OF-SCOPE through v2.6.** `api-contract.md` files are API-first across all 3 platforms. Pipedream Pipefy MCP and Wrike MCP are parked references only (may be cited as "available but not adopted"). Ziflow has no MCP.
- **UAT-6.1 — Native-AI ingestion APIs OUT-OF-SCOPE entirely.** `native_ai_path:` enum is `paste | none` ONLY across all 3 platform skills. `api` branch is FORBIDDEN (PLAT-05 grep gate). Stage 10 (v2.5) = paste bundle + audit log only.
- **UAT-4.1 — Pipefy API canonical-only (Q24 verified 2026-05-10).** `api.pipefy.com/graphql` for ALL tenants. `web_host` + `org_id` vary per tenant; `api_host` field is NOT present. DNS verified: `api.<subdomain>.pipefy.com` does not resolve for custom-subdomain tenants. (DESIGN-14 REVISED.)
- **UAT-4.1 bonus — Pipefy HTML-on-auth-failure gotcha.** Pipefy GraphQL returns Keycloak login HTML (`Content-Type: text/html`), NOT JSON 401, on auth fail. `platform-pipefy/references/api-contract.md` MUST document this. Skills MUST check `Content-Type` before parsing JSON.
- **UAT-4.2 — Pipefy auth-concurrency = `exclusive`.** Cannot auth to two Pipefy tenants simultaneously. Wrike + Ziflow class TBD per OPEN-Q25 (resolved in Phase 5 connector-matrix.md).
- **DESIGN-15 — Wrike `host` field MUST be persisted from OAuth token response.** NEVER hardcode `www.wrike.com`. Worked examples: US-2 region → `app-us2.wrike.com`; EU region (VodafoneZiggo, account 5996999) → `app-eu.wrike.com`.
- **DESIGN-16 — Ziflow `wait_for_proof` helper required.** 30s poll budget / 2s interval default for read-after-create eventual consistency (MOD-6).
- **MOD-7 — `tier_claims_last_verified:` frontmatter required on each platform SKILL.md.** Date stamp records when the native-AI capability matrix was last verified against vendor docs.
- **PLAT-03 / DESIGN-16 — Ziflow native-AI capability matrix grounded in 2026 ReviewAI** (Checklists Public Preview; Change Verification + Brand Standards Coming Soon).
- **DESIGN-14 / 15 / 16 — 5-file `references/` shape parity.** All 3 platform skills carry identical file list: `api-contract.md`, `native-ai-inventory.md`, `knowledge-ingestion.md`, `client-shape-gotchas.md`, `vocabulary.md`. Shape parity is a Phase 6 verification gate.
- **DESIGN-03 / Phase 5 D-59 — Hard-rules pointer.** Each new platform `SKILL.md` includes the uniform one-line pointer to `dydx-delivery/references/safety-rules.md` (sandbox allowlist contract).
- **Phase 5 canonical refs are LIVE.** `dydx-delivery/references/{safety-rules.md, stage-numbering.md, frontmatter-scheme.md, glossary.md, connector-matrix.md}` all exist and are authoritative. Phase 6 platform skills MUST point at them, not re-author content.

</spec_lock>

<decisions>

## Implementation Decisions

D-N numbering picks up at **D-63** (Phase 5 ended D-62). All Phase 6 implementation decisions are D-63..D-68.

### D-63 — Plan slicing: 3 plans, per-platform (one platform skill per plan)

Phase 6 ships as **3 plans, one per platform skill**:

| Plan | Scope | Addresses | OPEN-Q resolved |
|---|---|---|---|
| `06-01-PLAN.md` | `skills/platform-pipefy/` SKILL.md + all 5 `references/` files end-to-end | PLAT-01 (full), PLAT-04 (pipefy), PLAT-05 (pipefy) | Q06.2 inline |
| `06-02-PLAN.md` | `skills/platform-wrike/` SKILL.md + all 5 `references/` files end-to-end | PLAT-02 (full), PLAT-04 (wrike), PLAT-05 (wrike) | Q07.2 inline |
| `06-03-PLAN.md` | `skills/platform-ziflow/` SKILL.md + all 5 `references/` files end-to-end + synthesis (shape-parity gate + structure-check + 3 OPEN-Q row flips in OPEN-QUESTIONS.md) | PLAT-03 (full), PLAT-04 (ziflow), PLAT-05 (ziflow), PLAT-06 (full) | Q05 inline; Q06.2/Q07.2/Q05 row flips |

**Synthesis-folding rule.** If 06-03 grows past ~400 LOC of plan content (rough threshold matching Phase 5 Wave 5), the planner SPLITS synthesis out to `06-04-PLAN.md` (shape-parity gate + OPEN-Q row flips + `phase6-structure-check.sh`). Planner discretion at /gsd-plan-phase time.

**Parallelism.** Each plan touches a distinct directory (`skills/platform-pipefy/` vs `skills/platform-wrike/` vs `skills/platform-ziflow/`), so the 3 plans CAN execute in parallel under `/gsd-execute-phase 6`. File-ownership conflict only on `.planning/OPEN-QUESTIONS.md` (3 row flips in 06-03 / 06-04) — that work is sequential within the synthesis plan, not across the platform plans.

**Rationale:** Per-platform atomic review (a reviewer can grade `platform-pipefy` end-to-end in one cut) beats per-references-file slicing (which would force a reviewer to cross-cut 3 platforms × 5 files = 15 cells to grade one skill). Phase 5's domain-aligned-waves intuition (D-60) is preserved here — the domain *is* the platform.

### D-64 — Helper code shape: doc-only contracts + pseudocode in `api-contract.md`

Each `references/api-contract.md` documents its platform's helper(s) using a uniform structure: **signature + behaviour + retry/poll budget + failure modes + return shape + pseudocode + worked example**. NO executable `.py` / `.js` files ship in Phase 6. `skills/platform-*/helpers/` directories are NOT created (not even as empty stubs — anticipatory directories rot).

**Per-platform helpers documented:**
- **Pipefy `paginate_all(query, cursor_field)`** — GraphQL cursor pagination across multi-page result sets (MOD-4). Retry budget on 429 documented with backoff curve.
- **Wrike OAuth-host persistence pattern** — `host` field extraction from OAuth token response + storage in `client_state.yaml` `wrike.host:`; usage as base URL for every subsequent call. Anti-pattern (hardcoded `www.wrike.com`) called out explicitly (MOD-5).
- **Ziflow `wait_for_proof(proof_id, max_wait_s=30, interval_s=2)`** — eventual consistency poll for read-after-create (MOD-6). 30s default budget per DESIGN-16; final value confirmed via Q05 resolution in 06-03.

**Pipefy HTML-on-auth-failure gotcha** documented as a separate "Auth failure detection" subsection in `platform-pipefy/references/api-contract.md` per UAT-4.1 — `Content-Type: text/html` indicates auth failure (Keycloak login redirect), NOT a JSON 401.

**Rationale:** REQUIREMENTS.md PLAT-01..03 explicitly locate the helpers in `api-contract.md` (a Markdown file) — never require executable modules. Phase 5 D-56 set the doc-only precedent (connector-matrix.md). The actual runtime consumer is the Stage 8 test bot (v2.4 / Phase 8 per CHANGELIST.md / DESIGN-28..30), which lives outside this repo at `<Client> Brain/test-bot/` per DESIGN-29 — that's where helpers become real code with tests + a tenant + `client_state.yaml`. Shipping helpers in Phase 6 without a caller, harness, or tests would create dead code that drifts. Lift cost pseudocode → real Python in Phase 8 is small (~30 min per helper); zero rework, just translation.

**OPEN-Q22 alignment:** Plugin self-test pytest harness is deferred to Phase 9 owner. Shipping executable helpers in Phase 6 would either violate this (untested code) or pull Phase 9 scope forward (tests for code that has no caller).

### D-65 — `client-shape-gotchas.md` seeded with DESIGN-documented worked examples + pattern slots

Each `references/client-shape-gotchas.md` carries two sections:

1. **`## Known shapes (verified)`** — concrete examples lifted from DESIGN.md verbatim:
   - **Pipefy:** Vodacom custom-subdomain (`vodacom.pipefy.com/{org_id}`; API canonical `api.pipefy.com/graphql`).
   - **Wrike:** VodafoneZiggo EU tenant (`app-eu.wrike.com`, account `5996999`, entry URL pattern `<host>/workspace.htm?acc=<account_id>`).
   - **Ziflow:** generic Acme placeholder (DESIGN-16 worked example) — one entry stub, marked `<TBD at first engagement>` for the 2 real client-brain-doc clients from memory (Up & Up Group + VodafoneZiggo).

2. **`## Pattern slots`** — variant taxonomy (e.g. for Pipefy: `web_host` default vs custom-subdomain; `org_id` semantics; `pipe_id` vs `phase_id` vs `card_id` distinction). Slots, not rows — populated as new clients onboard.

**Maintenance contract.** `client-shape-gotchas.md` opens with a one-line note: "Append-only — new client shapes added per first-engagement; existing rows preserved for audit trail." No `last_shape_added` frontmatter field (rejected as over-engineered for current scale).

**Rationale:** DESIGN.md already verified the worked examples (UAT-4.1 / DESIGN-15 / DESIGN-16). Lifting verbatim avoids re-verification cost and gives reviewers a concrete shape to grade against on day one. Stub-only would force reviewer cross-reads back to DESIGN.md; pollutes the platform-skill self-containment goal.

### D-66 — `vocabulary.md` lean: platform-specific terms only, opens with pointer to glossary.md

Each `references/vocabulary.md` opens with: `> For project-wide terms see ` `dydx-delivery/references/glossary.md` `.` Body carries ONLY platform-specific terms not in glossary.md:

- **Pipefy:** `pipe`, `phase`, `card`, `connection`, `org_id`, `web_host` (per-tenant variant), `pipe_id`, `phase_id`, `card_id`.
- **Wrike:** `space`, `folder`, `project`, `task`, `custom field`, `host` (OAuth-persisted), `account_id`, `space_id`.
- **Ziflow:** `proof`, `review`, `decision`, `stage`, `version`, `project_id`.

**Verification gate.** `grep -r '<term-already-in-glossary>' skills/platform-*/references/vocabulary.md` MUST return zero hits for terms defined in `dydx-delivery/references/glossary.md` (`frontmatter`, `sandbox`, `native_ai_path`, `status:` lifecycle terms, etc.). Synthesis plan (06-03 or 06-04) includes the dedup grep gate.

**Rationale:** Phase 5 D-59 / FOUND-04 made `dydx-delivery/references/glossary.md` the single project-wide SoT for shared vocabulary. Duplicating cross-cutting terms into each `vocabulary.md` would re-introduce the AUDIT-05 hard-rules duplication anti-pattern at the vocabulary layer. Pointer-only (option C) was rejected because it leaves platform-specific terms without a home — they would have to pollute the central glossary, breaking the "per-platform vocabulary, per-platform skill" boundary.

### D-67 — OPEN-Q resolution: inline in per-platform plan-wave (Phase 5 D-57 precedent)

3 Phase-6-owned OPEN-Qs resolve **inline as part of their owning per-platform plan** — no separate `/gsd-research-phase 6` cycle:

- **Q05 Ziflow read-after-create consistency window** → resolved in `06-03-PLAN.md` (platform-ziflow). Web/doc research happens as plan-task work; resolved value lands directly in `platform-ziflow/references/api-contract.md` as the `wait_for_proof` default (`max_wait_s` + `interval_s`).
- **Q06.2 Pipefy throttle calibration** → resolved in `06-01-PLAN.md` (platform-pipefy). Builds on Phase 5's already-resolved Q06.1 (Pipefy 2026 rate-limit publication research) — Phase 5 connector-matrix.md is the read source; Phase 6 derives the per-helper retry/backoff budget from that. Resolved value lands in `platform-pipefy/references/api-contract.md` rate-limit section.
- **Q07.2 Wrike throttle calibration** → resolved in `06-02-PLAN.md` (platform-wrike). Builds on Phase 5's Q07.1. Resolved value lands in `platform-wrike/references/api-contract.md` rate-limit section.

**OPEN-QUESTIONS.md row flips** — for each resolved Q, the Phase 4 register row gets its Status field flipped from `open` / `proposed` to `decided` with a one-line resolution citing the platform skill's `api-contract.md` path and the resolved value. All 3 row flips land **in the synthesis plan** (06-03 trailing section, or 06-04 if synthesis is split out) — single point of `.planning/OPEN-QUESTIONS.md` ownership avoids inter-plan conflict.

**Rationale:** Items are small and self-contained (one rate-limit number per platform; one consistency window for Ziflow). A dedicated research phase would inflate cycle time without adding rigour — Phase 5's inline pattern (D-57) for the 8 connector OPEN-Qs validated this. Inline keeps the milestone tight and avoids `/clear` + re-context overhead.

### D-68 — `tier_claims_last_verified:` = per-platform last-vendor-docs-check date + event-based re-verification trigger

Each platform SKILL.md frontmatter carries a **distinct** `tier_claims_last_verified:` date matching when that platform's `native-ai-inventory.md` was last verified against current vendor documentation. Default baseline: **2026-05-09** (the DESIGN.md native-AI matrix authoring date). If 06-NN execution does a fresh re-verification against current vendor docs as a plan task, the field is updated to the execution date.

**Re-verification trigger** documented in each SKILL.md as an explicit subsection (event-based, NOT calendar-based):

```markdown
## Re-verification trigger

Re-verify `references/native-ai-inventory.md` against current <Platform> AI
documentation BEFORE any v2.x phase that consumes the capability matrix:
- Stage 4a delivery routing (consumes confidence ratings)
- Stage 7b implementation prompt (consumes capability surface list)
- Stage 10 native-AI paste bundle (consumes paste targets + Behaviors / Copilot / Checklist surfaces)

Update `tier_claims_last_verified:` on this SKILL.md frontmatter after each
re-verification, citing the source doc URL + date in commit message.
```

**Rationale:** Event-based trigger ties re-verification to actual downstream consumption — the field protects against stale capability claims at the moment they matter. Calendar-based ("re-verify if >90 days") is arbitrary and decouples the check from the consumer's need. Single-date-for-all-three was rejected because the 3 platforms may drift at different rates (Ziflow ReviewAI is in active expansion — Change Verification + Brand Standards "Coming Soon" per DESIGN-16 — so its date will move more often than Pipefy's, which is more stable).

**MOD-7 alignment:** PITFALLS.md MOD-7 requires the field as a maintenance hook; event-based trigger is the maintenance contract.

</decisions>

<canonical_refs>

## Canonical References — MANDATORY reads for downstream agents

Every Phase 6 plan author MUST consult these before authoring:

- `.planning/ROADMAP.md` — Phase 6 section (lines 213-224) — 5 success criteria + Requirements list (PLAT-01..06)
- `.planning/REQUIREMENTS.md` — § "Phase 6 — Internalise Platform Skills" (lines 122-131) — 6 PLAT-* spec rows
- `.planning/PROJECT.md` — § "Current Milestone: v2.1 Foundations + Platform Skills" — target features list + UAT scope locks
- `.planning/DESIGN.md` — § DESIGN-14 (lines 408-457) platform-pipefy (REVISED — canonical-only endpoint + HTML-on-auth-failure gotcha), § DESIGN-15 (lines 459-500) platform-wrike (OAuth-host persistence), § DESIGN-16 (lines 502-543) platform-ziflow (`wait_for_proof` helper); cross-cutting DESIGN-01 (frontmatter scheme), DESIGN-03 (hard-rules SoT — uniform pointer pattern)
- `.planning/CHANGELIST.md` — § "Phase 2: Internalise Platform Skills (v2.1)" — deliverables + dependencies + pitfalls table
- `.planning/AUDIT.md` — § AUDIT-04.1 (v0.3.0 platform-skill orphan references) — context for what NEW means here
- `.planning/OPEN-QUESTIONS.md` — rows for Q05, Q06.2, Q07.2 (3 to resolve inline); Q24 (Pipefy API canonical — locked-context); Q25 (auth-concurrency class — resolved in Phase 5 connector-matrix.md, locked-context)
- `.planning/phases/05-foundations/05-CONTEXT.md` — D-56..D-62 (especially D-56 doc-only pattern + D-59 uniform-pointer pattern + D-60 plan-slicing pattern + D-62 lift-and-fix pattern)
- `.planning/phases/05-foundations/05-VERIFICATION.md` — Phase 5 verifier PASS 13/13 FOUND-XX (signals Phase 5 contracts are stable to build on)
- `dydx-delivery/references/safety-rules.md` — Phase 5 canonical (FOUND-01); each new platform SKILL.md points at this via the D-59 uniform-pointer
- `dydx-delivery/references/stage-numbering.md` — Phase 5 canonical (FOUND-02); platform skills cite per-stage consumers (Stage 4a/4b/5/6/7a/7b/8/10) by canonical stage prefix
- `dydx-delivery/references/frontmatter-scheme.md` — Phase 5 canonical (FOUND-03); platform SKILL.md frontmatter (`platform:`, `tier_claims_last_verified:`, `native_ai_path:`) MUST conform
- `dydx-delivery/references/glossary.md` — Phase 5 canonical (FOUND-04); platform `vocabulary.md` files point at this for project-wide terms (D-66)
- `dydx-delivery/references/connector-matrix.md` — Phase 5 canonical (FOUND-10); Phase 5 inline-resolved Q06.1 / Q07.1 / Q25 — Phase 6 Q06.2 / Q07.2 calibration reads throttle defaults from here
- `.claude/memory/` — `feedback_platform_skills_api_first.md` (UAT-3.5 lock — informs api-contract.md MCP-parking) / `reference_client_brain_coda_docs.md` (Up & Up Group + VodafoneZiggo are the 2 documented clients for D-65 gotchas seeding)

**Source files created during Phase 6 (all NEW):**

- `dydx-delivery/skills/platform-pipefy/SKILL.md`
- `dydx-delivery/skills/platform-pipefy/references/api-contract.md`
- `dydx-delivery/skills/platform-pipefy/references/native-ai-inventory.md`
- `dydx-delivery/skills/platform-pipefy/references/knowledge-ingestion.md`
- `dydx-delivery/skills/platform-pipefy/references/client-shape-gotchas.md`
- `dydx-delivery/skills/platform-pipefy/references/vocabulary.md`
- `dydx-delivery/skills/platform-wrike/SKILL.md`
- `dydx-delivery/skills/platform-wrike/references/api-contract.md`
- `dydx-delivery/skills/platform-wrike/references/native-ai-inventory.md`
- `dydx-delivery/skills/platform-wrike/references/knowledge-ingestion.md`
- `dydx-delivery/skills/platform-wrike/references/client-shape-gotchas.md`
- `dydx-delivery/skills/platform-wrike/references/vocabulary.md`
- `dydx-delivery/skills/platform-ziflow/SKILL.md`
- `dydx-delivery/skills/platform-ziflow/references/api-contract.md`
- `dydx-delivery/skills/platform-ziflow/references/native-ai-inventory.md`
- `dydx-delivery/skills/platform-ziflow/references/knowledge-ingestion.md`
- `dydx-delivery/skills/platform-ziflow/references/client-shape-gotchas.md`
- `dydx-delivery/skills/platform-ziflow/references/vocabulary.md`
- `.planning/phases/06-internalise-platform-skills/scripts/phase6-structure-check.sh` — synthesis-plan deliverable (D-63 if synthesis splits to 06-04)

**Source files modified during Phase 6:**

- `.planning/OPEN-QUESTIONS.md` — 3 row Status field flips (Q05 / Q06.2 / Q07.2 → `decided`), single-plan-owned in synthesis

</canonical_refs>

<code_context>

## Reusable Assets & Patterns

- **`.planning/DESIGN.md` § DESIGN-14 / 15 / 16** — already contain populated native-AI capability matrices for all 3 platforms (Pipefy AI Agents 6-row table; Wrike Copilot + 16 MCP tools 4-row table; Ziflow ReviewAI 4-row table). Phase 6 `native-ai-inventory.md` lifts these tables verbatim, then re-verifies against current vendor docs (D-68 fresh re-verification optional per plan).
- **`.planning/DESIGN.md` worked examples** — Vodacom Pipefy custom-subdomain / VodafoneZiggo Wrike EU tenant / Ziflow Acme placeholder are pre-verified and used directly in D-65 `client-shape-gotchas.md` seed content.
- **Phase 5 canonical references at `dydx-delivery/references/`** — 5 files (`safety-rules.md`, `stage-numbering.md`, `frontmatter-scheme.md`, `glossary.md`, `connector-matrix.md`) are LIVE; Phase 6 SKILL.md bodies use the Phase 5 D-59 uniform-pointer pattern verbatim (`> **Hard rules:** Sandbox-only operations. ... See ` `dydx-delivery/references/safety-rules.md` `for the canonical ruleset.`).
- **Phase 5 connector-matrix.md** — already documents per-platform API auth contract + throttle ceilings post-Q06.1 / Q07.1 / Q25 resolution. Phase 6 Q06.2 / Q07.2 throttle CALIBRATION reads from this file; per-helper retry/backoff budgets are derived (not re-researched from scratch).
- **Phase 5 `phase5-structure-check.sh` pattern** (`.planning/phases/05-foundations/scripts/phase5-structure-check.sh`, 421 LOC, ~40 PASS assertions) — Phase 6 synthesis plan authors `scripts/phase6-structure-check.sh` against the same shape: per-file existence assertions + 5-file `references/` shape parity grep + uniform-pointer presence in each SKILL.md + `native_ai_path: api` zero-hit grep gate (PLAT-05) + `tier_claims_last_verified:` frontmatter present on each SKILL.md.
- **Existing v0.3.0 skill SKILL.md frontmatter shape** (`dydx-delivery/skills/discovery-intake/SKILL.md` + 6 siblings) — Phase 5 normalised these to `frontmatter_version: 2` + canonical scheme; Phase 6 NEW platform SKILL.md files use the same scheme + add `platform:` / `tier_claims_last_verified:` / `native_ai_path:` per-platform fields.
- **`.claude/memory/feedback_platform_skills_api_first.md`** — encodes UAT-3.5 (MCPs OUT-OF-SCOPE through v2.6) verbatim; informs api-contract.md "MCP available but not adopted" parking refs.
- **`.claude/memory/reference_client_brain_coda_docs.md`** — names Up & Up Group + VodafoneZiggo as the 2 documented clients with Coda brain docs; informs D-65 gotchas seeding (Up & Up Group = `<TBD>` placeholder; VodafoneZiggo = pre-verified Wrike EU tenant per DESIGN-15).

</code_context>

<deferred>

## Deferred Ideas (captured for later phases)

- **Executable helper modules at `skills/platform-*/helpers/*.py`** — D-64 explicitly defers to Phase 8 / v2.4. Stage 8 test bot rebuild (DESIGN-28..30) is where helpers become real code with tests, a tenant, and `client_state.yaml`.
- **`skills/platform-*/helpers/` empty-stub directories** — rejected even as anticipatory `.gitkeep`'d dirs; D-64 chooses zero filesystem footprint over premature signalling.
- **Calendar-based `tier_claims_last_verified:` re-verification trigger (">90 days")** — D-68 rejects in favour of event-based trigger; the calendar threshold can be re-evaluated post-first-real-client-ship in v2.6.
- **MCP adoption for Pipefy / Wrike (Pipedream MCP / Wrike MCP)** — UAT-3.5 parks through v2.6; api-contract.md may cite as "available but not adopted" but ingestion path stays REST/GraphQL. Adoption re-evaluated post-v2.6 gated on first-real-client-engagement-practice-run.
- **Native-AI ingestion API branch (`native_ai_path: api`)** — UAT-6.1 closes entirely; not revisited in Phase 6 or any planned v2.x phase.
- **Plugin self-test pytest harness for helper pseudocode** — OPEN-Q22 routes to Phase 9 owner; Phase 6 ships no harness.
- **Q05 / Q06.2 / Q07.2 deep-research escalation** — D-67 inline resolution assumes items are small and self-contained. If inline research surfaces an item that needs deeper investigation (e.g., Ziflow read-after-create window varies materially by region or proof type), the plan author escalates by spawning a `gsd-phase-researcher` agent against that single question — not by widening Phase 6 scope.

</deferred>

<next_steps>

## Next Up

- **Approval gate (precondition):** Phase 5 awaits human approval gate per STATE.md. Phase 6 plan-phase is unblocked technically (Phase 5 ✓ COMPLETE, verifier PASS 13/13 FOUND-XX) but the explicit human approval is the ROADMAP-defined trigger. Confirm Phase 5 approval before running plan-phase.
- **`/gsd-plan-phase 6`** — author 3 wave plans (`06-01-PLAN.md` through `06-03-PLAN.md`; planner may split synthesis to `06-04-PLAN.md` per D-63) following the per-platform slicing.
- After plan-phase completes and plan-checker passes: `/gsd-execute-phase 6` — the 3 per-platform plans can execute in parallel (distinct directories); synthesis plan executes last (single-owner `.planning/OPEN-QUESTIONS.md` write).
- Phase 6 closes milestone v2.1. After Phase 6 approval, the next milestone (v2.2 Stage 1 Kickoff + Stage 4 Fnspec split per CHANGELIST CHANGE-01) begins.

</next_steps>
