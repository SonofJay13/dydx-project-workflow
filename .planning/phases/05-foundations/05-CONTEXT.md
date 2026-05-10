# Phase 5: Foundations + Connector Verification — Context

**Gathered:** 2026-05-10
**Status:** Ready for planning

<domain>

## Phase Boundary

Phase 5 lands the **plugin-level foundation** that every later v2.x phase depends on — four canonical reference files at `dydx-delivery/references/{safety-rules.md, stage-numbering.md, frontmatter-scheme.md, glossary.md}`, the 7 v0.3.0 skills repointed at them (collapsing 4 hard-rules duplicates, fixing the sandbox-block bug, normalising `based_on_*` field names), file-prefix renumbering for NEW artefacts (00→02 / 01→03 / 02→04 / 03→05 / 04→07a), plugin manifest synced to `2.0.0` across `plugin.json` + `marketplace.json`, `LICENSE` file, empty `commands/` / `agents/` / `hooks/` scaffold dirs, a **doc-only** connector-availability matrix at `dydx-delivery/references/connector-matrix.md`, the 5 active cosmetic CONCERNS fixes (B.1 / B.2 / B.3 / B.4 / B.6 — B.5 is INTENTIONAL per UAT-3.1), a re-run of the status-lifecycle survey, and resolution of 8 connector OPEN-QUESTIONS (Q06.1 / Q07.1 / Q09 / Q10 / Q11 / Q12 / Q13 / Q25).

**This is the first build phase after v2.0 design-lock.** The v2.0 design-only mandate ENDS here — skill edits are now permitted. Phase 5 lands BEFORE Phase 6 (intra-milestone ordering — Phase 6 platform skills point at Phase 5 canonical references; landing Phase 6 first leaves dangling pointers).

**Boundary with Phase 6:** Phase 6 ships `skills/platform-{pipefy,wrike,ziflow}/` with their 5-file `references/` shape. Those references point at Phase 5 canonical refs (`safety-rules.md`, `stage-numbering.md`, `frontmatter-scheme.md`, `glossary.md`) — Phase 6 cannot land until Phase 5 references exist. Phase 6 also resolves 3 throttle/consistency OPEN-Qs (Q05 / Q06.2 / Q07.2) that depend on the Phase 5 inline OPEN-Q resolutions (Q06.1, Q07.1).

**Boundary with v2.0 milestone:** v2.0 (AUDIT.md / DESIGN.md / CHANGELIST.md / OPEN-QUESTIONS.md) is approved 2026-05-10 and provides the locked architecture, sequencing, and resolution register. Phase 5 implements DESIGN-01/02/03/04/07 + AUDIT-05.1/07 fixes + CHANGE-01 Phase 1 deliverables + the 8 Phase-5-owned OPEN-Q rows. Phase 5 does NOT re-derive scope — it executes pre-locked decisions.

**Out-of-scope for Phase 5 (deferred):**
- Skill edits beyond the canonical-references repoint (e.g., Stage 1 kickoff dual-branch, Stage 4 fnspec split) — v2.2 / Phase 7+
- Substantive content inside `commands/` / `agents/` / `hooks/` scaffold dirs — those land in later v2.x milestones (DESIGN-04 names the 2 hooks for v2.6 / SURF-01..03)
- Platform skills authoring — Phase 6
- Renumbering v0.3.0 in-flight artefacts in client folders — NEVER renumbered (lenient mode reads them at old prefixes per DESIGN-08 + OPEN-Q15)

</domain>

<spec_lock>

## Locked Requirements (carried from v2.0 design-lock — DO NOT re-litigate)

These were decided in v2.0 milestone (AUDIT / DESIGN / CHANGELIST / OPEN-QUESTIONS, all approved 2026-05-10) and during the v2.0 UAT pass on 2026-05-10. Phase 5 plans MUST honour them verbatim:

- **UAT-3.1 — Owner-email INTENTIONAL.** `plugin.json` / `marketplace.json` keep `jasonmichaelb@gmail.com`. AUDIT-07 §7.5 is NOT a defect. FOUND-11 explicitly excludes B.5 from the cosmetic-fix list.
- **UAT-3.5 — MCPs OUT-OF-SCOPE through v2.6.** Connector matrix codifies API-first patterns for Pipefy / Wrike / Ziflow. Pipedream Pipefy MCP and Wrike MCP are parked references only.
- **UAT-6.1 — Native-AI ingestion APIs OUT-OF-SCOPE entirely.** Stage 10 (later v2.5) = paste bundle + audit log. Phase 5 connector matrix MUST NOT carry an `api` branch for native-AI ingestion paths.
- **OPEN-Q23 — LICENSE = two-line boilerplate.** Exact content: `All rights reserved.\nNot licensed for redistribution.` (FOUND-08). No alternative licence text considered.
- **OPEN-Q15 — Frontmatter migration = opt-in per CR; v2 readers permanently lenient on absent `frontmatter_version`.** Phase 5 `frontmatter-scheme.md` MUST document the lenient-read contract.
- **OPEN-Q16 — Re-run status-lifecycle survey at Phase 5 kickoff.** Survey lives in Wave 1 (before scaffold authoring) so any drift surfaces before the canonical scheme is locked.
- **DESIGN-04 — `hooks/` scope = `validate-frontmatter` + `bump-artefact-version` ONLY.** Phase 5 `hooks/` ships EMPTY (scaffold-only). NO probe-hook, NO approval-gate hook, NO auto-progression hook. Those 2 listed hooks themselves land in v2.6 / SURF-01..03 — NOT Phase 5.
- **DESIGN-08 — v0.3.0 in-flight artefacts NEVER auto-rewritten.** File renumbering (FOUND-06) applies to NEW artefacts only — i.e., skill body / template references to artefact filenames. v0.3.0 artefact files already on disk in client folders stay at old prefixes; v2 readers tolerate them via lenient mode.
- **OPEN-Q21 + Q21.1 — `commands/` resolution = single parameterised `commands/refine.md` taking skill name as `$1`, `/dydx-refine-*` namespace.** Phase 5 `commands/` ships EMPTY (substantive `refine.md` lands later per CHANGELIST CHANGE-04 / SURF-01..03).
- **OPEN-Q22 — Plugin self-test scope deferred to Phase 9 owner.** Phase 5 does NOT ship pytest harness for plugin correctness.
- **OPEN-Q24 — Pipefy API canonical-only (`api.pipefy.com/graphql` for ALL tenants).** Phase 5 connector matrix MUST document this; no `api_host` per-tenant field.

</spec_lock>

<decisions>

## Implementation Decisions

D-N numbering picks up at **D-56** (Phase 4 ended D-55). All Phase 5 implementation decisions are D-56..D-62.

### D-56 — Connector probe shape: doc-only matrix

`dydx-delivery/references/connector-matrix.md` is a **static reference document**. NO slash command, NO agent, NO probe hook ships in Phase 5. Each stage skill carries inline "check MCP availability before X" instructions referencing the matrix. Agents/skills read `connector-matrix.md` at session start.

**Rationale:** DESIGN-04 limits `hooks/` to `validate-frontmatter` + `bump-artefact-version` — a probe hook is explicitly excluded. FOUND-09 says `commands/`, `agents/`, `hooks/` scaffold dirs ship EMPTY in Phase 5. Doc-only is the minimum-viable surface that satisfies DESIGN-07's "session-start probe + per-stage fallback matrix" contract without inflating Phase 5 scope.

**Downstream consequence:** Re-running the probe (e.g., after MCP install/uninstall) is a manual step in v2.1 — humans/agents re-run `claude mcp list` and verify against `connector-matrix.md`. An on-demand `/dydx-probe-connectors` slash command can be considered for v2.6 / SURF-01..03 if needed; not in scope here.

### D-57 — OPEN-Q resolution method: inline in Phase 5 plans (no separate research phase)

All 8 Phase-5-owned OPEN-Qs (Q06.1 / Q07.1 / Q09 / Q10 / Q11 / Q12 / Q13 / Q25) resolve **inline as part of Phase 5 Wave 4** — no separate `/gsd-research-phase 5` cycle.

- **Web research items** (Q06.1 Pipefy 2026 rate-limit / Q07.1 Wrike 2026 rate-limit / Q09 Claude in Chrome canonical name / Q13 Wrike host source-of-truth / Q25 Wrike+Ziflow auth-concurrency class) → web research happens as plan-task work; resolved values land directly in `connector-matrix.md` cells.
- **Workspace probe items** (Q10 Coda MCP wired+pin / Q11 Google Workspace MCP server choice / Q12 Miro MCP wired vs paste-only) → re-confirm via `claude mcp list` against the AUDIT-08 baseline; resolved values land in `connector-matrix.md`.
- **OPEN-QUESTIONS.md row flips** — for each resolved Q, the Phase 4 register row gets its Status field flipped from `open` (or `proposed`) to `decided`, with a one-line resolution citing `connector-matrix.md` and the resolved value.

**Rationale:** Items are small and self-contained — a dedicated research phase would inflate cycle time without adding rigour. Inline keeps the milestone tight and avoids `/clear`+re-context overhead.

### D-58 — Renumbering scope: stage-numbering.md + skill bodies + skill internal templates

The file-prefix renumber (00→02 / 01→03 / 02→04 / 03→05 / 04→07a per FOUND-03) lands in **three places**:

1. **`dydx-delivery/references/stage-numbering.md`** — canonical old→new mapping table (authoritative source).
2. **Skill SKILL.md bodies** — any reference to artefact filenames (e.g., `01_discovery_v*.md` → `03_discovery_v*.md`) gets the new prefix. Affects all 7 v0.3.0 skills.
3. **Skill internal templates** (`skills/<name>/references/*-template.md`) — example output filenames updated to new prefixes.

**Out of scope:** v0.3.0 in-flight artefact files already in client folders — never renamed; lenient mode reads them at old prefixes per DESIGN-08.

**Rationale:** Renaming both skill bodies AND templates ensures skills consistently produce new-prefix artefacts from v2.1 onward, with `stage-numbering.md` as the single point of authority. Skipping skill bodies (option 2 from discussion) would leave v0.3.0 skills producing old-prefix artefacts until v2.2 — defeating the FOUND-06 intent.

### D-59 — Hard-rules pointer format: single uniform sentence + relative path

Each of the 4 affected files (`skills/discovery-intake/SKILL.md`, `skills/generate-sow/SKILL.md`, `skills/execute-tests/SKILL.md`, `skills/execute-tests/references/safety-rules.md`) replaces its inlined hard-rules block with the **same one-line pointer**:

```
> **Hard rules:** Sandbox-only operations. Read-write only against named sandbox tenants. Refuses destructive actions. See `dydx-delivery/references/safety-rules.md` for the canonical ruleset.
```

**Rationale:** Uniform wording is `grep`-verifiable (Wave 2 plan can include a sentinel-line check). The pre-existing `execute-tests/references/safety-rules.md` content lifts to the new plugin-level `dydx-delivery/references/safety-rules.md` with the sandbox-block bug fixed (Coda added to sandbox allowlist per CRIT-5) — the skill-internal file then becomes a one-line pointer to the plugin-level canonical, NOT a deletion (preserves cite-anchor stability).

**`based_on_*` normalisation** also lands in Wave 2 — any skill template currently using `based_on_discovery`, `based_on_sow`, etc. with inconsistent casing or hyphenation gets normalised to snake_case-with-underscore-prefix per DESIGN-01 frontmatter-scheme contract.

### D-60 — Plan slicing: 5 waves by domain

Phase 5 ships as **5 plans, one per wave**. File-ownership conflicts on `plugin.json` / `marketplace.json` / `OPEN-QUESTIONS.md` / `connector-matrix.md` force serialization within those waves but waves themselves run sequentially:

| Wave | Plan | Scope | Addresses |
|---|---|---|---|
| W1 | `05-01-PLAN.md` | Status-lifecycle survey (kickoff) + 4 canonical references authored in parallel: `safety-rules.md`, `stage-numbering.md`, `frontmatter-scheme.md`, `glossary.md` | FOUND-01, FOUND-02, FOUND-03, FOUND-04, FOUND-12 |
| W2 | `05-02-PLAN.md` | 7 v0.3.0 skills repointed at canonical refs (single uniform hard-rules pointer per D-59); file-prefix renumber applied to skill bodies + internal templates per D-58; `based_on_*` normalisation | FOUND-05, FOUND-06 |
| W3 | `05-03-PLAN.md` | Plugin manifest 2.0.0 sync across `plugin.json` + `marketplace.json` (owner-email UNCHANGED per UAT-3.1); `LICENSE` file at repo root (two-line boilerplate per OPEN-Q23); empty `commands/` / `agents/` / `hooks/` scaffold dirs created at plugin root | FOUND-07, FOUND-08, FOUND-09 |
| W4 | `05-04-PLAN.md` | `connector-matrix.md` authored (doc-only per D-56); 8 OPEN-Q resolved inline (web research + workspace probe per D-57); `OPEN-QUESTIONS.md` row flips (`open`/`proposed` → `decided`) | FOUND-10, FOUND-13 |
| W5 | `05-05-PLAN.md` | 5 cosmetic CONCERNS fixes per AUDIT-07: B.1 README truncation / B.2 'test sheet' wording / B.3 pipeline-step count → 13 / B.4 LICENSE (cross-references W3) / B.6 homepage asymmetry. **B.5 owner-email = NO FIX** per UAT-3.1. | FOUND-11 |

**Rationale:** Domain-aligned waves keep each plan small enough to review atomically while preventing same-file conflicts. Wave 1 status-lifecycle survey running BEFORE scaffold authoring lets any drift surface before `frontmatter-scheme.md` is canonically locked (per D-61).

### D-61 — Status-lifecycle survey runs BEFORE scaffold (Wave 1)

The OPEN-Q16 re-survey of live `<Client> Brain/` folders (FOUND-12) runs as the **first task of Wave 1**, before any canonical reference is written. If drift is detected from the 2026-05-10 sample (any new `status:` value or schema change), Wave 1 surfaces it as a deviation, the user adjudicates, and `frontmatter-scheme.md` reflects the adjudicated state.

**Rationale:** Survey output informs the canonical scheme — running it AFTER scaffold would create rework risk if drift is found. Pre-scaffold timing also matches the OPEN-Q16 wording "at Phase 5 kickoff".

### D-62 — `safety-rules.md` migration: lift-and-fix, not author-from-scratch

The plugin-level `dydx-delivery/references/safety-rules.md` (FOUND-01) lifts content from the existing `dydx-delivery/skills/execute-tests/references/safety-rules.md` **verbatim**, with **one targeted fix**: Coda added to the sandbox allowlist per CRIT-5 (resolves the v0.3.0 sandbox-block bug). The skill-internal file then becomes a one-line pointer per D-59 (NOT deleted — preserves cite-anchor stability with downstream references).

**Rationale:** v0.3.0 safety rules are validated reality. Authoring from scratch risks dropping a clause silently. Lift-and-fix is the minimum-change path that satisfies FOUND-01 + CRIT-5 fix together.

</decisions>

<canonical_refs>

## Canonical References — MANDATORY reads for downstream agents

Every Phase 5 plan author MUST consult these before authoring:

- `.planning/ROADMAP.md` — Phase 5 section (lines 184-195) — 5 success criteria + Requirements list (FOUND-01..13)
- `.planning/REQUIREMENTS.md` — § "Phase 5 — Foundations + Connector Verification" (lines 104-120) — 13 FOUND-* spec rows
- `.planning/PROJECT.md` — § "Current Milestone: v2.1 Foundations + Platform Skills" — target features list + UAT scope locks
- `.planning/DESIGN.md` — § DESIGN-01 (frontmatter scheme), DESIGN-02 (stage numbering), DESIGN-03 (hard-rules SoT), DESIGN-04 (plugin surfaces), DESIGN-07 (connector probe + graceful-degradation matrix), DESIGN-08 (frontmatter migration co-existence)
- `.planning/CHANGELIST.md` — § "Phase 1: Foundations + Connector Verification (v2.1)" (lines 50-61) — deliverables + dependencies + pitfalls table
- `.planning/AUDIT.md` — § AUDIT-05 (4-file hard-rules duplication; canonical-source recommendations), § AUDIT-06 (8 version-bearing locations; 2.0.0 sync target), § AUDIT-07 (cosmetic-fix list; B.5 reclassified as INTENTIONAL per UAT-3.1)
- `.planning/OPEN-QUESTIONS.md` — rows for OPEN-Q06.1 / Q07.1 / Q09 / Q10 / Q11 / Q12 / Q13 / Q15 / Q16 / Q21 / Q21.1 / Q22 / Q23 / Q24 / Q25 (8 to resolve inline + 7 locked-context)
- `.planning/codebase/CONCERNS.md` — original concern inventory (superset absorbed into AUDIT.md; cross-ref only)
- `.planning/codebase/CONVENTIONS.md` — frontmatter / file-naming conventions (informs Wave 1 + Wave 2 authoring)
- `.planning/phases/04-open-questions/04-CONTEXT.md` — D-46..D-55 decisions on register-row schema (informs Wave 4 row-flip discipline)
- `.claude/memory/` (3 user-locked memories) — `feedback_platform_skills_api_first.md` (UAT-3.5 lock) / `user_email_approved.md` (UAT-3.1 lock) / `reference_client_brain_coda_docs.md` (client brain context for FOUND-12 survey scope)

**Source files modified during Phase 5:**

- `dydx-delivery/references/` — NEW directory; 5 NEW files: `safety-rules.md`, `stage-numbering.md`, `frontmatter-scheme.md`, `glossary.md`, `connector-matrix.md`
- `dydx-delivery/skills/{discovery-intake,execute-tests,generate-build-prompt,generate-functional-spec,generate-sow,generate-technical-spec,generate-test-plan}/SKILL.md` — all 7 v0.3.0 skill files MODIFIED (canonical-refs repoint + renumber + hard-rules collapse)
- `dydx-delivery/skills/*/references/*-template.md` — internal templates MODIFIED (new-prefix examples)
- `dydx-delivery/skills/execute-tests/references/safety-rules.md` — collapses to one-line pointer (content lifts to plugin-level canonical)
- `dydx-delivery/plugin.json` — version 0.3.0 → 2.0.0 (owner-email UNCHANGED)
- `.claude-plugin/marketplace.json` — version sync to 2.0.0; B.6 homepage asymmetry fix
- `LICENSE` — NEW file at repo root (two-line boilerplate)
- `dydx-delivery/commands/` — NEW empty dir
- `dydx-delivery/agents/` — NEW empty dir
- `dydx-delivery/hooks/` — NEW empty dir
- `README.md` (repo root) — B.1 truncation + B.2 'test sheet' wording fixes
- `dydx-delivery/README.md` — B.3 pipeline-step count → 13
- `.planning/OPEN-QUESTIONS.md` — 8 row Status field flips (`open`/`proposed` → `decided`)

</canonical_refs>

<code_context>

## Reusable Assets & Patterns

- **`dydx-delivery/skills/execute-tests/references/safety-rules.md`** — already an authoritative hard-rules file scoped to one skill. Wave 1 (FOUND-01) lifts this content verbatim to the new plugin-level `dydx-delivery/references/safety-rules.md` and adds Coda to the sandbox allowlist (CRIT-5 fix). The skill-internal file then becomes a one-line pointer per D-59 (preserves cite-anchor stability).
- **Existing 7 skill SKILL.md files** — all follow the same SKILL.md + `references/<name>-template.md` shape. Wave 2 repoint pattern is identical across all 7 skills: replace inlined hard-rules block with the D-59 one-liner, replace artefact filename prefixes per D-58 stage-numbering mapping, normalise `based_on_*` field names per DESIGN-01.
- **`.claude-plugin/marketplace.json`** — existing manifest; FOUND-07 adds `homepage` field (B.6 fix) + version sync.
- **`.planning/AUDIT.md` § AUDIT-08 live-MCP probe table** — Wave 4 workspace probes (Q10 / Q11 / Q12) re-confirm against this baseline rather than probing from scratch. AUDIT-08 carries probe-time timestamps; Wave 4 logs new timestamps and notes deltas.
- **`.planning/OPEN-QUESTIONS.md` register row schema (D-47)** — Wave 4 row flips reuse the existing schema; only the Status field changes (`open`/`proposed` → `decided`) plus a one-line resolution citation. No row structural rewrites.
- **`.planning/codebase/CONVENTIONS.md` + `STRUCTURE.md`** — existing conventions docs inform what `frontmatter-scheme.md` and `stage-numbering.md` must codify. Wave 1 authoring leans on these for consistency with v0.3.0 reality.

</code_context>

<deferred>

## Deferred Ideas (captured for later phases)

- **On-demand `/dydx-probe-connectors` slash command** — D-56 explicitly defers this; if manual `claude mcp list` re-check proves cumbersome in v2.1 use, evaluate for v2.6 / SURF-01..03 milestone.
- **Probe hook running automatically at session start** — DESIGN-04 explicitly excludes from `hooks/` scope; not revisited in Phase 5.
- **Renumbering v0.3.0 in-flight artefacts in client folders** — explicitly NEVER per DESIGN-08 + OPEN-Q15. Lenient mode is the permanent reader contract.
- **Plugin self-test (pytest harness for hooks + frontmatter-validator)** — OPEN-Q22 routes this to Phase 9 owner; Phase 5 ships no self-tests.
- **Substantive `commands/refine.md` parameterised slash command** — OPEN-Q21 + Q21.1 lock the shape (`/dydx-refine-*` namespace), but authoring lands in v2.6 / SURF-01.

</deferred>

<next_steps>

## Next Up

- **`/gsd-plan-phase 5`** — author 5 wave plans (`05-01-PLAN.md` through `05-05-PLAN.md`) per D-60 slicing.
- After plan-phase completes and plan-checker passes: `/gsd-execute-phase 5` — execute Wave 1 first (status-lifecycle survey + canonical references), then Waves 2–5 sequentially.

</next_steps>
