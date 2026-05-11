# Phase 6: Internalise Platform Skills — Discussion Log

**Discussion date:** 2026-05-11
**Discussion command:** `/gsd-discuss-phase 6`
**Audience:** human reference only (audit / retrospective). Downstream agents (researcher, planner, executor) consume `06-CONTEXT.md`, not this file.

## Areas Selected for Discussion

User selected all 4 presented gray areas (multiSelect):

1. Plan slicing strategy
2. Helper code shape (paginate_all / wait_for_proof / OAuth-host)
3. client-shape-gotchas.md + vocabulary.md seeding
4. OPEN-Q resolution + tier_claims_last_verified semantics

---

## Area 1: Plan slicing strategy

**Question asked:** How should Phase 6 plans be sliced?

**Options presented:**

- **A. Per-platform (3 plans) — Recommended** — 06-01 platform-pipefy / 06-02 platform-wrike / 06-03 platform-ziflow end-to-end. Atomic skill review; parallel execution (distinct dirs); synthesis folds into 06-03 or splits to 06-04.
- **B. Scaffold-then-platforms-then-synthesis (5 plans, Phase-5-style)** — 06-01 scaffold + 3 empty dirs + frontmatter stubs / 06-02..04 per-platform content / 06-05 synthesis. Mirrors Phase 5 D-60 rhythm.
- **C. Per-references-file (5 plans, shape-parity-first)** — 06-01 3×SKILL.md + scaffold / 06-02 3×api-contract.md / 06-03 3×native-ai-inventory.md / 06-04 3×(knowledge-ingestion + client-shape-gotchas + vocabulary) / 06-05 synthesis. Forces 5-file shape parity but no per-skill atomic review.

**User selection:** A. Per-platform (3 plans)

**Captured as:** D-63

**Notes:**
- Each plan touches a distinct directory; parallel execution under `/gsd-execute-phase 6` is safe.
- File-ownership conflict only on `.planning/OPEN-QUESTIONS.md` (3 row flips) — that work concentrated in synthesis (06-03 trailing or 06-04 split).
- Synthesis-folding rule (planner discretion): split to 06-04 if 06-03 content > ~400 LOC.

---

## Area 2: Helper code shape (paginate_all / wait_for_proof / OAuth-host)

**Question asked:** Helper code shape for paginate_all / wait_for_proof / OAuth-host persistence?

**Options presented:**

- **A. Doc-only contracts + pseudocode — Recommended** — Carry Phase 5 D-56 precedent. api-contract.md documents signature + behaviour + retry budget + failure modes + return shape + pseudocode + worked example. No runnable code. Test bot (v2.4 / Phase 8) authors real helpers against the contract.
- **B. Executable helpers under skills/platform-*/helpers/** — Ship actual Python (or JS) modules now alongside the doc contract. Pulls Phase 8 helper-author work earlier. Risk: language/runtime binding now; OPEN-Q22 deferred plugin self-tests to Phase 9 — shipping helpers without tests is awkward.
- **C. Hybrid — doc-only now + empty .gitkeep'd helper-stubs ear-marked** — Same doc-only api-contract.md PLUS empty dirs at skills/platform-*/helpers/ with one-line README pointing at Phase 8 owner.

**User initial response:** Asked for clarification — "what is the difference between executable helpers and the doc only option, why would you recommend the one over the other"

**Clarification given (summary):**

1. **Doc-only ships Markdown only** describing the helper interface; **executable ships runnable .py/.js files** alongside that Markdown.
2. **Phase 6 consumers are SKILL.md files** (read by Claude), not Python imports. The actual runtime consumer is the Stage 8 test bot at `<Client> Brain/test-bot/test_runner.py` per DESIGN-29 — *outside this repo*, authored in v2.4 / Phase 8.
3. **REQUIREMENTS.md PLAT-01..03 explicitly locate helpers in `api-contract.md`** (Markdown) — never require executable modules.
4. **Phase 5 D-56 precedent** chose doc-only for connector-matrix.md with explicit reasoning ("v2.1 phase ships the surface contract, not the runtime") — Phase 6 is the same shape.
5. **OPEN-Q22 deferred plugin self-tests to Phase 9.** Executable helpers without tests violate it; with tests pulls Phase 9 forward.
6. **Lift cost is small** (~30 min per helper pseudocode → Python) once Stage 8 has a sandbox tenant + `client_state.yaml`. Zero rework, just translation.

**User selection (post-clarification):** A. Doc-only contracts + pseudocode

**Captured as:** D-64

**Notes:**
- Per-platform helpers documented: Pipefy paginate_all (cursor pagination + 429 retry); Wrike OAuth-host persistence pattern (host extraction → `client_state.yaml` `wrike.host:` → base URL); Ziflow wait_for_proof (30s default / 2s interval).
- Pipefy HTML-on-auth-failure gotcha documented as separate "Auth failure detection" subsection per UAT-4.1.
- `skills/platform-*/helpers/` directories NOT created (anticipatory dirs rot).

---

## Area 3: client-shape-gotchas.md + vocabulary.md seeding

### Sub-question 3a: client-shape-gotchas.md — seed with known clients or stub-only?

**Options presented:**

- **A. Seed with DESIGN-documented worked examples — Recommended** — Lift Pipefy Vodacom custom-subdomain + Wrike VodafoneZiggo EU tenant (app-eu.wrike.com, account 5996999) + Ziflow Acme placeholder verbatim into `## Known shapes (verified per DESIGN-14, 2026-05-10)`. Plus `## Pattern slots` for variant taxonomy.
- **B. Stub-only — populated as clients onboard** — Structure only (H2 anchors, table headers, marker). DESIGN.md examples stay only in DESIGN.md.
- **C. Seed AND add a maintenance contract** — Same as A plus explicit "append-only" maintenance contract + `last_shape_added` frontmatter field.

**User selection:** A. Seed with DESIGN-documented worked examples (preview confirmed)

**Captured as:** D-65 (with append-only maintenance note adopted as a one-line preamble, but `last_shape_added` frontmatter field rejected as over-engineered)

### Sub-question 3b: vocabulary.md scope vs Phase 5 glossary.md?

**Options presented:**

- **A. Lean — platform-specific terms only — Recommended** — vocabulary.md opens with pointer to `dydx-delivery/references/glossary.md`. Body = only platform-specific terms not in glossary.md (Pipefy: pipe / phase / card / connection / etc.). Synthesis grep gate confirms zero duplicate-defines.
- **B. Duplicate-cite key terms for skill self-containment** — vocabulary.md duplicates cross-cutting terms (frontmatter, sandbox, native_ai_path) for skill self-containment. Drift risk between vocabulary and glossary.
- **C. Pointer-only with per-platform appendix back to glossary.md** — vocabulary.md = stub + pointer. Platform-specific terms have nowhere to live (would pollute central glossary).

**User selection:** A. Lean — platform-specific terms only (preview confirmed)

**Captured as:** D-66

**Notes:**
- grep -r dedup gate lives in synthesis plan (06-03 trailing or 06-04 split).
- Phase 5 D-59 / FOUND-04 made glossary.md the project-wide SoT; D-66 preserves that boundary.

---

## Area 4: OPEN-Q resolution + tier_claims_last_verified semantics

### Sub-question 4a: How should Q05 / Q06.2 / Q07.2 be resolved during Phase 6?

**Options presented:**

- **A. Inline in per-platform plan-wave (Phase 5 D-57 precedent) — Recommended** — Q05 in 06-03 (Ziflow); Q06.2 in 06-01 (Pipefy); Q07.2 in 06-02 (Wrike). OPEN-QUESTIONS.md row flips in synthesis.
- **B. Separate /gsd-research-phase 6 first, then plan** — Dedicated research pass before /gsd-plan-phase 6. Cleaner separation but inflates cycle time.
- **C. Hybrid — Q05 inline + Q06.2/Q07.2 lifted from Phase 5 connector-matrix** — Q06.2/Q07.2 derive from Phase 5's already-resolved Q06.1/Q07.1 in connector-matrix.md.

**User selection:** A. Inline in per-platform plan-wave

**Captured as:** D-67 (with implicit hybrid lift — Q06.2/Q07.2 read Phase 5 connector-matrix.md throttle defaults as a starting point, then derive per-helper retry/backoff budgets)

### Sub-question 4b: tier_claims_last_verified date semantics + re-verification trigger?

**Options presented:**

- **A. Per-platform last-vendor-docs-check date + event-based trigger — Recommended** — Distinct per-platform date matching when native-ai-inventory.md was last checked. Default baseline: 2026-05-09 (DESIGN.md authoring); plan tasks may update if fresh re-verification happens during 06-NN execution. Re-verify trigger: BEFORE any v2.x phase that consumes native-ai-inventory.md (Stage 4a / Stage 7b / Stage 10).
- **B. Single Phase 6 authoring date + date-based trigger (>90 days)** — Single date for all 3; calendar-based threshold. Arbitrary; decouples check from consumer need.
- **C. DESIGN.md research date (2026-05-09) for all three + manual re-verification note** — Frozen timestamp with no maintenance contract.

**User selection:** A. Per-platform last-vendor-docs-check date + event-based trigger (preview confirmed)

**Captured as:** D-68

**Notes:**
- Each SKILL.md carries an explicit `## Re-verification trigger` subsection naming the 3 downstream consumers (Stage 4a / 7b / 10).
- Update protocol: cite source doc URL + date in commit message when bumping the field.

---

## Scope-creep redirects

None during this discussion — user stayed strictly within Phase 6 boundary (3 platform skills + 5-file references shape + helpers + frontmatter + 3 OPEN-Qs).

## Deferred ideas captured

All captured in `06-CONTEXT.md` `<deferred>` section:

- Executable helper modules → Phase 8 / v2.4
- helpers/ empty stub dirs → rejected entirely
- Calendar-based tier_claims re-verification → re-evaluate post-v2.6
- MCP adoption for Pipefy / Wrike → re-evaluate post-v2.6
- native_ai_path: api branch → closed entirely (UAT-6.1)
- Plugin self-test pytest harness → Phase 9 owner (OPEN-Q22)
- Q05/Q06.2/Q07.2 deep-research escalation → spawn `gsd-phase-researcher` per single question if inline surfaces unexpected depth

## Claude's discretion items (no user input requested)

- Synthesis-plan split threshold (~400 LOC) — planner discretion at `/gsd-plan-phase` time.
- Parallel execution scheduling under `/gsd-execute-phase 6` — executor discretion; safe per D-63 file-ownership analysis.
- Exact line citations to DESIGN.md sections in the canonical_refs section — line numbers verified at write time against current DESIGN.md.

## Final decision count

6 net-new decisions: D-63 (plan slicing) / D-64 (helper shape) / D-65 (gotchas seed) / D-66 (vocabulary scope) / D-67 (OPEN-Q method) / D-68 (tier_claims semantics).

D-N pool was at D-62 (end of Phase 5); Phase 6 pool now extends to D-68.
