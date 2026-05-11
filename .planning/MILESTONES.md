# Milestones

Record of shipped milestones and the requirements they validated.

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

Phase directories remain in `.planning/phases/01-audit/` through `04-open-questions/` (not retroactively archived).

---
*Last updated: 2026-05-11 after v2.1 milestone close*
