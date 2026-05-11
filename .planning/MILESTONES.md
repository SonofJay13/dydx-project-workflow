# Milestones

Record of shipped milestones and the requirements they validated.

---

## v2.2 Stage 1 Kickoff + Stage 4 Fnspec Split (Shipped: 2026-05-11)

**Phases completed:** 2 phases (Phase 7 + Phase 8), 7 plans
**Requirements satisfied:** 21/21 (5 STG1 + 3 STG2 + 2 STG3 + 6 STG4 + 5 ROUTE)
**Branch:** `main` (PR #1 merged ahead of close)
**Archive:** [`milestones/v2.2-ROADMAP.md`](./milestones/v2.2-ROADMAP.md) · [`milestones/v2.2-REQUIREMENTS.md`](./milestones/v2.2-REQUIREMENTS.md) · [`milestones/v2.2-MILESTONE-AUDIT.md`](./milestones/v2.2-MILESTONE-AUDIT.md)
**Phase directories:** archived to `.planning/milestones/v2.2-phases/`

### Key accomplishments

- **Stage 1 Kickoff skill landed.** `kickoff-capture/` NEW (no v0.3.0 ancestor) — SKILL.md + 3 references/ files (kickoff-template.md with concrete `kickoff_branch:` + 8 H2 categories; auto-classify-rubric.md per D-73 triggers + escalation + backstop; capture-paths.md with 3 paste protocols + MOD-8 prevention). Reviewer can run the kickoff against meeting-notes / Miro paste / Field Notes (`processed_at IS NULL` triage default) and end with an approved `01_kickoff_v<N>.md` carrying a single-field `kickoff_branch: discovery-ready | draft-sow` enum that branches both Stage 2 and Stage 3.
- **Pipeline lights up end-to-end on both routing branches.** `discovery-intake/` MODIFIED to consume `01_kickoff_v*` as sole upstream (raw-notes entry path RETIRED per STG2-01); verbatim skip-emit on `draft-sow` branch (Stage 2 SKIPPED → Stage 3 reads kickoff directly via `based_on_kickoff:`). `generate-sow/` MODIFIED to canonical 4-state lifecycle `draft → client_review → approved → archived` per DESIGN-08 (sole skill retaining `client_review` per AUDIT-01.2); single-SOW dual-scope H2 split (Platform + Integration sections per D-75 — no Stage 3 split). E2e smoke against both `discovery-ready` and `draft-sow` fixtures green at Phase 7 close.
- **Stage 4 Fnspec split shipped.** `generate-functional-spec/` RETIRED → SPLIT into `generate-fnspec-platform/` (Stage 4a, NEW) + `generate-fnspec-integration/` (Stage 4b, NEW). 4a reads approved discovery + approved SOW + per-platform `references/native-ai-inventory.md`; 4b reads same plus 4a output. Both skills authored with full SKILL.md + 3 references/ files each (templates + classifier rubric + addendum template + consistency rules + either-spec-skip paths). `delivery: native-ai | api` routing key emitted on every requirement row in both 4a and 4b artefacts; canonical enum order locked (anti-pattern scan returns 0 matches of reversed `api | native-ai` across all `dydx-delivery/`).
- **Cross-spec consistency check landed.** Stage 4b OWNS three checks per D-84 — (a) no conflicting `delivery:` tags across 4a/4b, (b) every integration touchpoint cites a referenced 4a platform requirement ID (no dangling refs), (c) no orphan API endpoints in 4b (every endpoint maps to a requirement). Halt-on-failure runs FIRST before fnspec-integration write; failure emits dedicated `04b_consistency_check_v<N>.md` for human triage. No silent write of an inconsistent fnspec.
- **Stage 5 scope-gate forward-compat documented.** Three explicit branches per DESIGN-21 — (a) full path (4b exists with `delivery: api` rows), (b) skip-with-addendum (no 4b but 4a carries `## Platform-API Addendum` H2 + `has_platform_api_addendum: true` + `tech_spec_scope: platform-api-addendum-only`), (c) skip-entirely (no 4b AND no `delivery: api` rows anywhere). 4a/4b emit the necessary frontmatter and addendum H2 in v2.2; actual Stage 5 consumption ships in v2.3. 3 fixture-output artefacts in 08-03 prove all 3 branches resolve cleanly from frontmatter alone.
- **TD-2 closed inline as D-78 path-(a) — `ziflow` ADDED to stage-skill `platform:` 4-enum.** Carryover from v2.1 audit RESOLVED. `pipefy | wrike | other` → `pipefy | wrike | ziflow | other` across 10 files / 11 lines in 08-03 (1aee081). `platform-ziflow/SKILL.md:14` routing-key claim now aligned. DESIGN-20 D-78 sub-decision recorded + `dydx-delivery/references/glossary.md` routing-key entry landed (c6d05dc).
- **Forward-compat smoke check passes.** `delivery:` routing key declared in 4a/4b propagates forward through `based_on_*` chains to Stage 5/6/7b/10 consumers (forward-compatible interface only in v2.2; actual consumption in v2.3+). T-smoke 5-step walkthrough against T5 fixtures (documentation-mode per fixture stubs) + `phase8-structure-check.sh --section smoke` PASS exit 0 + 3 fixture-output artefacts authored (41d4eff).
- **Phase-level structure-check harness extended.** Phase 7 `phase7-structure-check.sh` with `--section <kickoff|discovery|sow|all>` dispatch (5df4566); 15/15 PASS at Phase 7 close. Phase 8 `phase8-structure-check.sh` with 5 section runners (P/I/E/S/X) + 4 cross-cutting X assertions + locked-literal grep on E2 (line 216 uses `grep -qF "is the routing key"` per anti-soft-grep guard); 32/32 PASS at Phase 8 close.
- **R-02 + R-01 glossary alignment.** DESIGN.md glossary entry for `kickoff_branch` aligned to authoritative `discovery-ready` / `draft-sow` (b038995). `dydx-delivery/references/glossary.md` lines 47+66 cleaned of legacy `discovery-via` / `kickoff-direct` spellings; both carry the authoritative spelling (c6d05dc).
- **3 hygiene TD items closed pre-archive.** TD-v2.2-01 (`kickoff-capture` missing `platform:` frontmatter), TD-v2.2-02 (`when-to-open-claude-code.md:27` ASCII pipeline named retired `generate-functional-spec`), TD-v2.2-03 (`plugin.json` description stale "Seven skills" — now 12) all closed in one atomic hygiene commit (`e9c69cf`) before milestone archive per user choice "Address TD inline first" at `/gsd-complete-milestone v2.2` pre-flight. Audit verdict flipped `tech_debt` → `passed`.

### Tech debt / deferred (non-blocking)

- **All 3 audit-flagged hygiene items closed inline pre-archive** — no carryover.
- **Nyquist VALIDATION.md flag drift (informational only).** Phase 7 + Phase 8 VALIDATION.md docs have `nyquist_compliant: false` (Phase 7) / absent frontmatter (Phase 8); but structure-check harnesses both run exit 0 with full PASS — so the *actual* Nyquist coverage is verified green. The PARTIAL status reflects flag/frontmatter drift in the VALIDATION.md docs themselves, not a coverage gap in the implementation. Optional retroactive normalization via `/gsd-validate-phase 7` + `/gsd-validate-phase 8` if clean Nyquist signaling needed; not blocking.

### Cross-AI review pattern reused

Phase 7 plan-phase ran a cross-AI review convergence loop (C1-C8 incorporated into replan; 5a5fcb1). Phase 8 plan-phase iter-1 found 1 BLOCKER + 2 WARNINGS in 08-03; planner revised; plan-checker iter-2 PASS (e452c03 → ae520c5). Pattern: plan-checker as a separate iter loop after the planner authors initial plans, with explicit BLOCKER / WARNING / NOTE severity classification.

### Carryover into v2.3

Key v2.2 decisions that lock baseline for v2.3 planning:
- **D-78 path (a)** — `ziflow` as routing-key value is now canonical baseline; any new platform-skill must follow `pipefy | wrike | ziflow | other` precedent (extend to 5-enum only via a new D-XX decision).
- **D-79** — Stage 4a authors `## Platform-API Addendum` inline on platform-only-with-API-rows topology; Stage 5 v2.3 will consume `has_platform_api_addendum:` + `tech_spec_scope:` frontmatter.
- **D-84** — Stage 4b owns three consistency checks (run FIRST before write); Stage 5 v2.3 will inherit similar "consistency-first" discipline for its scope-gate decisions.
- **D-85** — Either-spec-skip with verbatim em-dash skip-emit; Stage 5 v2.3 will face the analogous "either-spec-skip" topology on its three scope-gate paths (full / addendum-only / skip-entirely).

---

## v2.1 Foundations + Platform Skills (Shipped: 2026-05-11)

**Phases completed:** 2 phases (Phase 5 + Phase 6), 9 plans
**Requirements satisfied:** 19/19 (13 FOUND-XX + 6 PLAT-XX)
**Branch:** `dydx-delivery-v2`
**Archive:** [`milestones/v2.1-ROADMAP.md`](./milestones/v2.1-ROADMAP.md) · [`milestones/v2.1-REQUIREMENTS.md`](./milestones/v2.1-REQUIREMENTS.md) · [`milestones/v2.1-MILESTONE-AUDIT.md`](./milestones/v2.1-MILESTONE-AUDIT.md)
**Phase directories:** archived to `.planning/milestones/v2.1-phases/`

### Key accomplishments

- **Plugin foundations locked.** Plugin-level canonical references created at `dydx-delivery/references/{safety-rules,stage-numbering,frontmatter-scheme,glossary,connector-matrix}.md`; 7 v0.3.0 stage skills repointed to single SoT (4 hard-rules duplicates collapsed per AUDIT-05.1; sandbox-block bug fixed; `based_on_*` field-name drift normalised).
- **Plugin shipped at version 2.0.0.** `plugin.json` + `marketplace.json` synced; LICENSE in place; empty `commands/`, `agents/`, `hooks/` scaffold dirs created. File renumbering 00→02 / 01→03 / 02→04 / 03→05 / 04→07a applied. 5 cosmetic CONCERNS fixes landed (B.5 owner-email INTENTIONAL per UAT-3.1).
- **Connector probe matrix codified.** `connector-matrix.md` documents 6 connectors × 11 stages probe baseline 2026-05-09 (Coda MCP / Google Workspace MCP / Miro MCP / Pipefy API / Wrike API / Ziflow API) with per-stage graceful-degradation fallback narrative. 8 connector OPEN-Q rows resolved inline.
- **3 platform reference skills shipped.** `platform-pipefy/` + `platform-wrike/` + `platform-ziflow/` each with 5-file `references/` shape — D-63 per-platform atomic slicing executed (06-02/06-03 ran in parallel after 06-01 scaffold).
- **Pipefy:** `paginate_all` helper (7-part contract avoids MOD-4 silent truncation) + canonical `api.pipefy.com/graphql` endpoint for ALL tenants (UAT-4.1; no `api_host` field) + HTML-on-auth-failure detection (Keycloak login HTML, not JSON 401) + Q06.2 throttle 13 req/sec per token resolved.
- **Wrike:** OAuth-host persistence pattern (extract from token → persist `client_state.yaml wrike.host:` → use as base URL; never hardcode `www.wrike.com` per MOD-5; T-06-03 prohibition phrase enforced) + 16 Copilot MCP tools matrix baseline + Q07.2 throttle 320 req/min per user resolved.
- **Ziflow:** webhook-PRIMARY framing (vendor-recommended) + `wait_for_proof` fallback helper (max_wait_s=30 / interval_s=2 per Q05 resolution) + 4-row ReviewAI matrix (Checklists Public Preview HIGH / Change Verification + Brand Standards "Coming Soon" MEDIUM / Checklist Templates API GA April 2026) + dedicated `ZiflowRateLimitExceeded` class for 429 (REVIEWS C7).
- **Frontmatter contracts locked.** `tier_claims_last_verified: 2026-05-09` baseline on all 3 platform SKILL.md (MOD-7 / D-68 per-platform re-verification trigger). `native_ai_path: paste | none` enum locked across all platforms — T-06-02 grep gate green (zero `native_ai_path: api` field assignments).
- **D-66 vocabulary dedup gate green.** Zero project-wide glossary terms (frontmatter / sandbox / native_ai_path / status: lifecycle) duplicated across the 3 platform vocabulary.md files.
- **3 OPEN-Q row flips synthesized.** Q05 (Ziflow read-after-create), Q06.2 (Pipefy throttle), Q07.2 (Wrike throttle) flipped `proposed` → `decided` in `.planning/OPEN-QUESTIONS.md` via single-owner write (plan 06-04) avoiding inter-plan file-ownership conflict per D-67 precedent.
- **Phase 6 structure-check authored.** `.planning/phases/06-internalise-platform-skills/scripts/phase6-structure-check.sh` with 17 assertions A1..A17 and `--section <pipefy|wrike|ziflow>` per-platform partition flag — final full-suite run exits 0 (27 PASS lines, A1..A17 all green).

### Tech debt / deferred (non-blocking)

- **TD-1 (closed at milestone close):** REQUIREMENTS.md FOUND-01..FOUND-13 rows flipped Pending → Complete per Phase 5 VERIFICATION.md evidence.
- **TD-2 (deferred to v2.2):** Stage-skill `platform:` enum (`pipefy | wrike | other`) does not include `ziflow`; `platform-ziflow/SKILL.md:14` claims `platform: ziflow` is the routing key but stage-side wiring never maps that value. Resolution scheduled for v2.2 Stage 4 Fnspec split work per DESIGN-20.
- **v2.0 carryover acknowledged at close:** 2 items from Phase 02 (Design) — `02-HUMAN-UAT.md status=resolved` (false-positive) + `02-VERIFICATION.md status=human_needed` (lingering marker). Deferred to a future v2.0-cleanup pass; not blocking v2.1 close.

### Known deferred items

`2 items acknowledged at close — see STATE.md → Deferred Items section.`

---

## v0.3.0 — Inherited baseline (pre-GSD)

**Status:** Shipped. Not formally a GSD milestone — captured here for traceability.
**Shipped:** 2026-05-09 (initial commit `8805379` on branch `dydx-delivery-v2`)

### What shipped

A stage-gated client delivery pipeline as a single Claude Code plugin (`dydx-delivery`) inside the `dydx-digital@1.2.0` marketplace. Seven markdown-only skills running on Cowork (strategy) and Claude Code (build):

1. `discovery-intake` — captures system, users, triggers, data, rules, integrations, exceptions, failure points
2. `generate-sow` — drafts scope of work from approved discovery
3. `generate-functional-spec` — single fnspec per project, `platform:` tagged
4. `generate-technical-spec` — translates fnspec into platform constructs (Pipefy/Wrike/other)
5. `generate-test-plan` — table-format test plan against sandbox tenant
6. `generate-build-prompt` — Claude-Code-ready build prompt for developers
7. `execute-tests` — runs approved test plan against sandbox, enforces hard safety rules

### Conventions established

- Versioned artefacts (`_v{N}.md` Option B versioning)
- Frontmatter scheme (`client`, `platform`, `integrations`, `version`, `status`, `based_on_*`) — *inconsistent across templates, flagged in CONCERNS.md*
- Stage-gated, human-reviewed, no auto-progression
- Sandbox-only test execution with hardcoded safety rules at `references/safety-rules.md`

### Known issues carried into v2.0

Catalogued in `.planning/codebase/CONCERNS.md`. Structural items in v2.0 scope:

- Frontmatter scheme inconsistencies
- Two-scheme stage numbering (file-prefix vs Stage-N)
- Hard-rules content duplicated across four files
- Missing `commands/`, `agents/`, `hooks/` directories
- `/refine-<skill>` references with no implementation
- `platform-pipefy`/`platform-wrike` referenced but not in this repo

Cosmetic items deferred (will be cleaned during v2.0 build):

- `plugin.json` version-string mismatches between manifests and docs
- README content truncation
- Residual "test sheet" wording
- Missing `LICENSE` file
- Email/domain mismatch (`gmail.com` vs `dydx.digital`)

---

## v2.0 — Implementor Edition (design-only — implicitly accepted, not CLI-archived)

**Status:** Design-complete 2026-05-10 (all 4 deliverables approved); never formally closed via `/gsd-complete-milestone v2.0`.
**Started:** 2026-05-09 · **Design-complete:** 2026-05-10
**Phases:** 1-4 (Audit / Design / Change list / Open questions register) · 31 plans total · 50 requirements satisfied (8 AUDIT + 30 DESIGN + 5 CHANGE + 7 OPEN)

### Deliverables (locked)

- `.planning/AUDIT.md` ✓ APPROVED 2026-05-09 — citation-grounded inventory of v0.3.0 plugin
- `.planning/DESIGN.md` ✓ APPROVED 2026-05-10 — locked v2 architecture (cross-cutting structure + 13-skill inventory + 3 platform skills + every stage skill + test bot architecture)
- `.planning/CHANGELIST.md` ✓ APPROVED 2026-05-10 — sequenced v0.3.0 → v2 delta with per-skill NEW/MODIFIED/RETIRED + cosmetic-fix list + research-blocked phase flags + migration cutover rules
- `.planning/OPEN-QUESTIONS.md` ✓ APPROVED 2026-05-10 — register of all deferred questions with owners + target phases

Phase directories archived to `.planning/milestones/v2.0-phases/` on 2026-05-11 at v2.2 kickoff (deferred archive of design-only milestone that was never CLI-closed via `/gsd-complete-milestone v2.0`).

---
*Last updated: 2026-05-11 after v2.2 milestone close*
