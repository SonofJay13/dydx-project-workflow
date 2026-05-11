# Phase 2: Design - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-05-09
**Phase:** 02-design
**Areas discussed:** Doc structure & depth, Per-stage skill depth, Risk-multiplier (DESIGN-22), /refine-<skill> (DESIGN-05), Plugin self-test scope, Migration cutover (DESIGN-08), Hand-off contract format (DESIGN-13), Open-questions handling, Decision-ID convention, Persona contract (DESIGN-10), Test-bot detail (DESIGN-28-30), Author flow

User selected all 12 surfaced gray areas for discussion (no skips). All 12 were resolved in Claude's recommended direction.

---

## Doc structure & depth

| Option | Description | Selected |
|--------|-------------|----------|
| Single DESIGN.md, matrix+prose (Recommended) | One file. Each major section opens with a scannable matrix (where applicable), then per-item prose. Mirrors Phase 1 AUDIT.md authoring pattern (D-11/D-12). One read, one approval gate. | ✓ |
| Single DESIGN.md, decision-only | One file but every requirement = compact decision block. No long prose. Faster to draft; thinner downstream context. | |
| Split: DESIGN.md + per-stage SPEC files | DESIGN.md holds cross-cutting + skill inventory; each stage gets its own .planning/design/<stage>.md. More files, higher cross-ref burden, but cleaner per-stage diffs. | |

**User's choice:** Single DESIGN.md, matrix+prose (Recommended)
**Notes:** Carries forward Phase 1's AUDIT.md authoring pattern; reviewer sees one file, one approval gate. → CONTEXT.md D-18 + D-19.

---

## Per-stage skill depth

| Option | Description | Selected |
|--------|-------------|----------|
| Decision contract only (Recommended) | Per stage skill: purpose, inputs, outputs, downstream consumer, status flag, hand-off message shape, complexity tag, key decisions. NO full SKILL.md prose. Authoring runs in v2.1+ build phase. | ✓ |
| Full SKILL.md draft inline | DESIGN.md carries draftable SKILL.md body for each of the 11 stages. Heavy authoring this milestone but skips a step in v2.1. Risks design-vs-build phase confusion. | |
| Decision contract + 1 worked example | Decision contract for all 11 stages plus one fully-drafted SKILL.md as exemplar. Calibrates the v2.1+ author. | |

**User's choice:** Decision contract only (Recommended)
**Notes:** Honours kickoff mandate ("no skill edits in design milestone"). Build phases own SKILL.md authoring. → CONTEXT.md D-20 + D-21 (extended to platform skills).

---

## Risk-multiplier (DESIGN-22)

| Option | Description | Selected |
|--------|-------------|----------|
| Defer to OPEN-QUESTIONS (Recommended) | DESIGN-22 records: closed taxonomy (L/M/H + rationale field); defaults DEFERRED pending dYdX-historical validation. OPEN-QUESTIONS Phase 4 carries it as 'decide before Stage 6 build phase'. No premature numbers in design. | ✓ |
| Lock 1.1 / 1.3 / 1.6 now | DESIGN-22 commits the research-recommended defaults. Build phase changes them only via explicit decision. | |
| Lock structure, defer numbers explicitly | DESIGN-22 locks L/M/H structure + rationale-field requirement; numeric values explicitly listed as DEFERRED with placeholder syntax. | |

**User's choice:** Defer to OPEN-QUESTIONS (Recommended)
**Notes:** Avoids locking unvalidated numbers. → CONTEXT.md D-22. DESIGN.md uses placeholder syntax with inline `[OPEN: Phase 4]` marker; closed list at end carries the deferred item.

---

## /refine-<skill> resolution (DESIGN-05)

| Option | Description | Selected |
|--------|-------------|----------|
| Build single parameterised refine.md, /dydx-refine-* namespace (Recommended) | Single commands/refine.md takes skill name as $1. Namespace as /dydx-refine-* to avoid colliding with other plugins. Existing orphan refs resolved by the parameterised command. | ✓ |
| Build single parameterised refine.md, /refine-* namespace | Same single command, but bare /refine-* namespace. Simpler URLs but risks collision. | |
| Delete every orphan reference | No refine command shipped. Cutover task in v2.1 = grep + delete. Keeps surface minimal; loses a documented affordance. | |

**User's choice:** Build single parameterised refine.md, /dydx-refine-* namespace (Recommended)
**Notes:** Phase 4 OPEN-06 closed by this decision. Build scheduled in Phase 3 CHANGELIST.md for v2.1 Foundations. → CONTEXT.md D-23.

---

## Plugin self-test scope

| Option | Description | Selected |
|--------|-------------|----------|
| Smoke tests for hooks + frontmatter validator via pytest (Recommended) | Plugin v2.1 ships with pytest smoke tests covering validate-frontmatter hook, bump-artefact-version hook, and frontmatter parser. Self-tests run in plugin CI. | ✓ |
| Defer self-tests to v2.2+ | Plugin v2.1 ships without self-tests. OPEN-QUESTIONS notes deferral. Faster v2.1 cut; slower regression catch. | |
| Validator only, hooks tested by manual smoke | Pytest covers frontmatter validator only. Hooks rely on manual smoke. | |

**User's choice:** Smoke tests for hooks + frontmatter validator via pytest (Recommended)
**Notes:** Phase 4 OPEN-07 closed by this decision. DESIGN.md adds plugin self-tests subsection under DESIGN-04. Self-tests live at `dydx-delivery/tests/`. → CONTEXT.md D-24.

---

## Migration cutover (DESIGN-08)

| Option | Description | Selected |
|--------|-------------|----------|
| CR-driven opt-in, status-lifecycle survey runs IN Phase 2 (Recommended) | DESIGN-08 locks CR-driven opt-in. Status-lifecycle survey of live <Client> Brain folders runs as part of this design phase to confirm canonical lifecycle doesn't orphan any live `status:` value. Survey result locks the contract. | ✓ |
| CR-driven opt-in, survey deferred to OPEN-QUESTIONS | DESIGN-08 locks the policy. Live-folder survey owned by Phase 4 register, listed as 'decide before v2.2 first migration'. | |
| Date-based cutover with grace period | Pick a cutover date; v2 readers strict after, lenient before. Conflicts with research recommendation. | |

**User's choice:** CR-driven opt-in, status-lifecycle survey runs IN Phase 2 (Recommended)
**Notes:** Survey runs during Plan 02-01 (Cross-cutting). Methodology + result captured in DESIGN.md as a sub-section under cross-cutting. → CONTEXT.md D-25.

---

## Hand-off contract format (DESIGN-13)

| Option | Description | Selected |
|--------|-------------|----------|
| Single transition table + per-stage prose (Recommended) | One scannable matrix (10 rows × 6 cols: From / To / Carrier file path / Frontmatter fields propagated / Gating status flag / Hand-off message). Then per-stage subsection carries hand-off message shape verbatim. | ✓ |
| Per-stage subsection only | No top-level table. Each stage's entry under skill inventory carries its own hand-off contract block. | |
| Mermaid sequence diagram + per-stage prose | Top-level diagram shows stage flow + status gates visually. Per-stage prose elsewhere. Pretty but harder to grep / diff. | |

**User's choice:** Single transition table + per-stage prose (Recommended)
**Notes:** Mirrors AUDIT.md D-11 matrix-then-prose pattern. v2.1+ build phases will cite this matrix more than any other section — built for grep-ability. → CONTEXT.md D-26.

---

## Open-questions handling

| Option | Description | Selected |
|--------|-------------|----------|
| Inline `[OPEN: Phase 4]` markers + closed list at end (Recommended) | Each undecided contract carries an inline `[OPEN: Phase 4 — <one-line summary>]` marker so a reader sees what's deferred at point of use. DESIGN.md ends with a closed list of all `[OPEN]` items for traceability into Phase 4 register. | ✓ |
| Closed list at end only, no inline markers | DESIGN.md locks every decidable contract. Closed 'Deferred to OPEN-QUESTIONS' section at end. Reader must cross-check that section. | |
| Inline markers only, no closed list | Inline `[OPEN]` markers throughout. No closed list. Risks loss-of-traceability when Phase 4 starts. | |

**User's choice:** Inline `[OPEN: Phase 4]` markers + closed list at end (Recommended)
**Notes:** Discipline: use sparingly. Phase 4 register can be built mechanically by walking the closed list. Also introduces `[MIGRATION-RISK: ...]` as a distinct inline tag for known compatibility risks. → CONTEXT.md D-27 + D-33.

---

## Decision-ID convention

| Option | Description | Selected |
|--------|-------------|----------|
| Continue D-N from Phase 1 (D-18+) (Recommended) | Phase 1 used D-1..D-17 for authoring decisions. Phase 2 picks up D-18 onwards for cross-milestone traceability. CHANGELIST.md cites D-IDs without disambiguation. | ✓ |
| New DD-N prefix for design decisions | Phase 2 uses DD-1, DD-2... distinct from Phase 1's D-N. Cleaner separation. More IDs to track. | |
| Hybrid: D-N for authoring, ARCH-N for architecture contracts | Cross-cutting + skill inventory + per-stage + test bot use ARCH-N. Authoring stays D-N. Tightest semantics, most IDs. | |

**User's choice:** Continue D-N from Phase 1 (D-18+) (Recommended)
**Notes:** Authoring decisions and architectural decisions share the same numbering pool — they coexist as decisions made during the design milestone. Phase 2 decisions land in the D-18..D-35 range. → CONTEXT.md D-28.

---

## Persona contract (DESIGN-10)

| Option | Description | Selected |
|--------|-------------|----------|
| Principles + anti-pattern list + 3 worked examples (Recommended) | DESIGN-10 carries: senior-implementer voice principles (~5 bullets), forbidden phrasings list, 3 worked before/after examples. Concrete enough that v2.1 build can lint against it; not a full style guide. | ✓ |
| Principle-only, examples deferred to skill build | DESIGN-10 records principles + forbidden-phrasing categories only. Each skill build phase produces its own examples. Risks per-skill drift. | |
| Full tone-lint rule set inline | DESIGN-10 ships a complete tone-lint rule set (regex + exceptions) plus all examples. Closes per-skill voice drift; authoring-heavy this milestone. | |

**User's choice:** Principles + anti-pattern list + 3 worked examples (Recommended)
**Notes:** Worked examples drawn from real audit findings (truncated changelog, "test sheet" residual, AI-style hedging). → CONTEXT.md D-29.

---

## Test-bot detail (DESIGN-28/29/30)

| Option | Description | Selected |
|--------|-------------|----------|
| Interface contract + skeleton schema (Recommended) | DESIGN-28 names tier-1/tier-2 boundary in prose + 1 worked test-case classification. DESIGN-29 ships skeleton client_state.yaml (top-level keys + 1 worked example per platform). DESIGN-30 ships drift-detection contract (inputs / outputs / halt condition / report shape) without pseudocode. Stage 8 build phase fills detail. | ✓ |
| Full schema + drift pseudocode | DESIGN-29 ships complete client_state.yaml schema with every field typed. DESIGN-30 ships drift algorithm as numbered pseudocode. Build phase implements verbatim. Heavy this phase. | |
| Decision-only, schema in build phase | DESIGN-28/29/30 record only architectural commitments. No schema or algorithm. Lightest; risks Stage 8 build re-deciding. | |

**User's choice:** Interface contract + skeleton schema (Recommended)
**Notes:** Sweet spot — enough to lock contract, not so much that this design milestone bleeds into build territory. → CONTEXT.md D-30.

---

## Author flow

| Option | Description | Selected |
|--------|-------------|----------|
| Section-by-section iterative with review checkpoints (Recommended) | Plans grouped: cross-cutting (DESIGN-01..10) → skill inventory + hand-offs → platform skills → stage skills → test bot → synthesis. Each grouping is its own plan(s). Single approval gate (final DESIGN.md). | ✓ |
| Single straight-through draft | One big plan drafts all sections sequentially. Faster planning; harder to review incrementally; harder to retry. | |
| Parallel waves where independent | Cross-cutting first (sequential). Then platform skills + stage skills drafted in parallel waves. Faster wall-clock; more coordination cost. | |

**User's choice:** Section-by-section iterative with review checkpoints (Recommended)
**Notes:** Indicative plan groupings: 02-01 Cross-cutting → 02-02 Skill inventory + hand-offs → 02-03 Platform skills → 02-04 Stage skills 1–4 → 02-05 Stage skills 5–8 → 02-06 Stage skills 9–11 → 02-07 Test bot → 02-08 Synthesis. Planner may adjust granularity. → CONTEXT.md D-31.

---

## Claude's Discretion

User did not defer any specific decisions to Claude during this discussion. The following items are explicitly Claude's call during execution (per CONTEXT.md `Claude's Discretion`):

- Internal ordering within each DESIGN-* section (decision-first vs context-first).
- Exact wording and length per stage-skill subsection (Stage 4 / 6 / 7 / 8 likely longer than Stage 2 / 3).
- Inline worked example vs. citation (default: inline if <10 lines and clarifies).
- Status-lifecycle survey methodology (which client folders sampled, recording shape) — Claude executes during Plan 02-01.
- Whether the closed `[OPEN]` list is a section or appendix — Claude picks at synthesis time.

## Deferred Ideas

Items mentioned or implied during discussion that belong to later phases (mirrored from CONTEXT.md `Deferred Ideas`):

- Risk-multiplier numeric defaults (1.1 / 1.3 / 1.6) — Phase 4 OPEN-QUESTIONS, decide before Stage 6 build phase.
- Pipefy GraphQL pagination cursor field names — Phase 4 OPEN-QUESTIONS / Phase 2 owner.
- Ziflow read-after-create consistency window — Phase 4 OPEN-QUESTIONS / Phase 2 owner.
- Pipefy / Wrike 2026 rate-limit currency — Phase 4 OPEN-QUESTIONS / Phase 1 or Phase 2 owner.
- Pipefy AI KB content-upload endpoint, Wrike AI Studio knowledge-ingestion API, Ziflow ReviewAI knowledge-ingestion API — Phase 4 OPEN-QUESTIONS / Phase 7 owner. SINGLE BIGGEST research-blocked unknown.
- Per-skill NEW/MODIFIED/RETIRED/UNCHANGED tagging — Phase 3 CHANGELIST.md.
- Cosmetic-fix scheduling for v2.1 build — Phase 3 CHANGELIST.md per CHANGE-03.
- Standard Coda templates (brain-mirror, task-table, default 00_HUB.md schema) — Phase 4 OPEN-QUESTIONS / Phase 8 owner.
- Hub-link backfill rollout coordination — Phase 4 OPEN-QUESTIONS register.
- Stage 1 Miro workflow-map ingest API + swimlane-reconstruction algorithm — DESIGN-17 records contract; algorithm is build-phase research.
- Pipefy / Wrike / Ziflow live API probing — requires sandbox tenant credentials; v2.1+ build per CHANGE-04.
