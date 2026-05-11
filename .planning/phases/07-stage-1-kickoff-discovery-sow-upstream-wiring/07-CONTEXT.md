# Phase 7: Stage 1 Kickoff + Discovery/SOW upstream wiring - Context

**Gathered:** 2026-05-11
**Status:** Ready for planning

<domain>
## Phase Boundary

A reviewer can run a kickoff-to-SOW pipeline end-to-end against a sample CR — produce an approved `01_kickoff_v<N>.md` artefact, watch the downstream stages route correctly on either `kickoff_branch: discovery-ready` (Stage 2 runs) or `kickoff_branch: draft-sow` (Stage 2 skips), and end with an approved single-scope `03_sow_v<N>.md` carrying the canonical 4-state lifecycle. Phase 7 lands **10 requirements** (STG1-01..05 + STG2-01..03 + STG3-01..02), all design-locked in `.planning/DESIGN.md` DESIGN-17/18/19.

**In scope:**
- NEW skill `dydx-delivery/skills/kickoff-capture/` (Stage 1) — `SKILL.md` + `references/{kickoff-template,auto-classify-rubric,capture-paths}.md`, points at canonical references per FOUND-01..04
- MODIFIED `dydx-delivery/skills/discovery-intake/SKILL.md` — consume `01_kickoff_v<N>.md` as sole upstream; raw-notes entry path RETIRED; verbatim skip-message on `draft-sow` branch
- MODIFIED `dydx-delivery/skills/generate-sow/SKILL.md` — lock canonical 4-state lifecycle; explicit dual-scope (`## Platform Scope` + `## Integration Scope` H2s) in SOW template
- Phase-7 structure-check script with `--section <kickoff|discovery|sow>` partitioning
- Inline OPEN-Q resolution per D-67 (any STG1/STG2/STG3 rows flipped in the synthesis plan)

**Out of scope (LOCKED at milestone level — do NOT re-litigate):**
- Stage 4/5/6/7/8/9/10/11 work — sequenced for Phase 8 + v2.3+ milestones per CHANGELIST CHANGE-01
- MCP-backed Field Notes / Coda integration — UAT-3.5 keeps MCPs out through v2.6 (paste-only)
- Native-AI ingestion APIs — UAT-6.1 LOCKED through v2.6 (paste-only)
- Auto-migration of legacy v0.3.0 `00_discovery_v*.md` / `01_sow_v*.md` artefacts — DESIGN-08 lenient-mode reads them; no migration ships in v2.2
- Auto-progression hooks between Stage 1 → Stage 2/3 — DESIGN-06 approval gates non-negotiable
- New platform skills — v2.1 sealed catalogue at Pipefy + Wrike + Ziflow
- `validate-frontmatter` / `bump-artefact-version` hook implementation — deferred to v2.6 (SURF-01..03)

</domain>

<decisions>
## Implementation Decisions

D-N numbering picks up at **D-69** (Phase 6 ended D-68).

### D-69 — Plan slicing: 3 per-skill atomic plans (D-63 precedent)

Phase 7 ships as **3 plans, one per skill**:

| Plan | Scope | Requirements covered | Depends on | Parallel-eligible |
|---|---|---|---|---|
| `07-01-PLAN.md` | `skills/kickoff-capture/` SKILL.md + 3 `references/` files end-to-end + ships `scripts/phase7-structure-check.sh` with `--section <kickoff\|discovery\|sow>` (Wave 0-equivalent) | STG1-01..05 | — | — |
| `07-02-PLAN.md` | `skills/discovery-intake/SKILL.md` modifications — consume kickoff, RETIRE raw-notes path, verbatim skip-message on `draft-sow` | STG2-01..03 | 07-01 (kickoff frontmatter contract + structure-check `--section discovery`) | Yes (disjoint dir from 07-03) |
| `07-03-PLAN.md` | `skills/generate-sow/SKILL.md` modifications — lock canonical lifecycle + dual-scope H2s + synthesis (OPEN-Q row flips + e2e smoke against sample CR + `--all` structure-check) | STG3-01..02 + synthesis | 07-01 | Yes (disjoint dir from 07-02) |

**Synthesis-folding rule.** If 07-03 grows past ~400 LOC of plan content (matches Phase 6 threshold), planner SPLITS synthesis out to `07-04-PLAN.md` (OPEN-Q flips + e2e smoke + `--all` structure-check). Planner discretion at `/gsd-plan-phase` time.

**Parallelism.** 07-02 + 07-03 touch disjoint skill directories (`skills/discovery-intake/` vs `skills/generate-sow/`) and both depend only on 07-01's frontmatter contract — can execute in parallel under `/gsd-execute-phase 7`. File-ownership conflict only on `.planning/OPEN-QUESTIONS.md` (any synthesis row flips); that work is sequential within 07-03 (or 07-04 if split).

**Rationale.** Mirrors Phase 6 D-63 (per-platform atomic). Locks the kickoff frontmatter contract once before downstream consumers light up. Lets 07-02/07-03 self-verify against `--section <discovery|sow>` before all 3 skills exist on disk.

### D-70 — kickoff-capture template source: author from STG1 reqs + DESIGN-17 categories

`references/kickoff-template.md` is composed by the planner from the 8 category list locked in STG1-04 (system / users / triggers / data / rules / integrations / exceptions / failure points), the `kickoff_branch:` routing field (STG1-02), the `processed_at IS NULL` Field Notes triage (STG1-03), and the `[unknown — needs human classification]` marker convention (STG1-04).

Template body follows the existing v0.3.0 SKILL.md body shape (frontmatter block → 8 H2 sections → ROUTING → provenance + sign-off). Mirrors how the platform-* skill bodies were composed in Phase 6 from DESIGN-14/15/16. Planner reads `.planning/DESIGN.md` DESIGN-17 during research and lifts any literal template blocks it contains (D-62 lift-and-fix precedent) — falls back to author-from-categories if none.

**Rationale.** Avoids re-litigating sections already locked in STG1-04. Keeps source-of-truth alignment with the existing skill body conventions documented in `.planning/codebase/STRUCTURE.md` § "SKILL.md body structure".

### D-71 — kickoff-capture references/ shape: 3 files

```
dydx-delivery/skills/kickoff-capture/references/
├── kickoff-template.md       # artefact body template (STG1-01, STG1-02, STG1-04, STG1-05)
├── auto-classify-rubric.md   # confidence rubric per D-73 (STG1-04 operationalisation)
└── capture-paths.md          # meeting-notes / Miro paste / Field Notes paste protocols (STG1-05 + D-72)
```

Mirrors `execute-tests/references/` pattern (multiple supporting refs alongside the template) rather than `discovery-intake/references/` (template-only). Three files keep the SKILL.md body lean: it references each file by relative path per FOUND-04 single-uniform-pointer-sentence convention.

**Rationale.** Operationalising STG1-04 (rubric) and STG1-05 (capture-paths) inline in SKILL.md would balloon the body past the v0.3.0 norm; splitting to `references/` matches the established convention.

### D-72 — Field Notes Coda access path: doc-only paste protocol

`references/capture-paths.md` documents the Field Notes Coda table shape (column names, the `processed_at IS NULL` view filter wording, the MOD-8 prevention rule — kickoff quotes the note + asks human keep/drop/edit-and-keep) and the reviewer paste protocol. **No code path ships in v2.2**: no MCP call, no Coda API curl, no probe hook.

Matches:
- Phase 5 D-56 connector-matrix doc-only pattern (no probe hook ships)
- UAT-3.5 MCPs OUT through v2.6
- UAT-6.1 native-AI / external-system ingestion paste-only spirit
- DESIGN-09 directional boundary — Field Notes table is read-only input queue; kickoff never auto-merges

A future Coda MCP integration is captured under Deferred Ideas (v2.6 / SURF-01..03 candidate).

**Rationale.** Doc-only is the minimum-viable surface that satisfies STG1-05(c) without breaching the v2.6 MCP-out scope-lock. Reviewer queries Coda manually (web app + filter), pastes rows into the kickoff session.

### D-73 — Auto-classification rubric: explicit rules + escalation table

`references/auto-classify-rubric.md` carries:

1. **3-5 explicit triggers** that force the `[unknown — needs human classification]` marker:
   - Category not named verbatim in any source input (meeting notes / Miro paste / Field Notes paste)
   - `< 2 distinct source mentions` (would require synthesising from a single witness)
   - Source contains explicit `TBD` / `?` / `unclear` / `come back to this` text against this category
   - Source mentions cross conflicting alternatives without resolution
   - Reviewer-pre-flagged TBD section in the kickoff template input
2. **Input-signal → outcome escalation table** — maps each trigger to whether the section keeps the marker, partially fills + retains marker, or proceeds without marker
3. **Operational principle** — "mark unknown when you'd hesitate to defend the classification to a reviewer" (final defensive backstop on top of the explicit triggers)

SKILL.md body Step N references the rubric by path. `phase7-structure-check.sh --section kickoff` asserts the rubric file exists and that SKILL.md references it.

**Rationale.** STG1-04 says "where confidence is low" but doesn't operationalise it. Explicit triggers + escalation make the rubric inspectable in structure-check and reproducible across reviewers. Heuristic-only would be hard to verify; always-mark-default adds reviewer load disproportionate to the signal.

### D-74 — discovery-intake skip emit: pure stdout, no file written

When `kickoff_branch: draft-sow`, `discovery-intake` SKILL.md Step N emits exactly:

```
Stage 2 SKIPPED — kickoff branch = draft-sow
```

…to stdout / handoff message, then exits without writing any `02_discovery_v<N>.md` artefact (no marker file, no Coda log row). Stage 3 (`generate-sow`) reads the kickoff directly via `based_on_kickoff:` from the approved `01_kickoff_v<N>.md`.

Audit trail lives in **git** (kickoff approval commit) and **the SKILL.md handoff log** — not in a marker file. Matches roadmap success criterion #3 verbatim ("writes no `02_discovery_v<N>.md` artefact").

**Rationale.** Literal reading of the locked roadmap criterion. Cleanest contract; avoids inventing a new artefact pattern (`*_v0_SKIPPED.md`) not present anywhere else in the pipeline. `phase7-structure-check.sh --section discovery` asserts the skip-message string is present verbatim in SKILL.md (single source of truth on the literal text).

### D-75 — SOW body for STG3-02: explicit `## Platform Scope` + `## Integration Scope` H2 sections

`generate-sow` SKILL.md + `references/sow-template.md` get two top-level scope H2 sections inside the single SOW artefact:

- `## Platform Scope` — what ships as platform configuration on Pipefy/Wrike/Ziflow
- `## Integration Scope` — what ships as inbound/outbound integration work

Both lists live in the same `03_sow_v<N>.md`. No frontmatter change; no `scope:` array field added (would require DESIGN-19 to author a new frontmatter field — out of scope). Lenient-mode reads v0.3.0 SOWs that only had a single narrative `## Scope` per DESIGN-08.

**Rationale.** Makes the dual-scope contract visibly auditable at client_review time (reviewer sees both lists side-by-side). Stage 4a/4b downstream can deterministically pick out their inputs (4a reads ## Platform Scope; 4b reads ## Integration Scope). Frontmatter array would maximise machine-readability but blocks on DESIGN-19 amendment; H2 split achieves 90% of the value with zero design changes.

### D-76 — Lenient v0.3.0 reconciliation: lenient-read OK, enforce `based_on_kickoff:` on NEW writes only

`discovery-intake` lenient-mode reads existing v0.3.0 `00_discovery_v*.md` and `02_discovery_v*.md` artefacts per DESIGN-08 — treats absence of `based_on_kickoff:` as legacy-permitted. STG2-01 contract applies to **writes from v2.2+ only**: any new `02_discovery_v<N>.md` written by the modified skill MUST carry `based_on_kickoff:`.

The eventual `validate-frontmatter` hook (deferred to v2.6 / SURF-01..03 substantive implementation) enforces the MANDATORY rule on the write-path only — never on the read-path.

**Rationale.** Reconciles STG2-01 ("MANDATORY") with DESIGN-08 ("lenient-mode") without amending either. Matches DESIGN-08 verbatim. `phase7-structure-check.sh --section discovery` asserts the SKILL.md body documents the write-path rule and the read-path lenient policy.

### D-77 — structure-check: single `phase7-structure-check.sh` with `--section` partitioning

`scripts/phase7-structure-check.sh` ships in 07-01 (Wave 0-equivalent inside the kickoff-capture plan) with three section modes plus `--all`:

- `--section kickoff` — kickoff-capture skill + 3 ref files exist; canonical-reference pointers at `safety-rules.md` / `stage-numbering.md` / `frontmatter-scheme.md` / `glossary.md` resolve; `kickoff_branch:` enum present in template; `[unknown — needs human classification]` marker convention documented; `processed_at IS NULL` documented in capture-paths; auto-classify-rubric.md exists and is referenced from SKILL.md.
- `--section discovery` — `based_on_kickoff:` MANDATORY documented for write-path; raw-notes RETIRED error message present; verbatim skip-message string present.
- `--section sow` — canonical `draft → client_review → approved → archived` enum present; `## Platform Scope` + `## Integration Scope` H2s present in template.
- `--all` — runs every section + cross-section asserts (e.g., the kickoff frontmatter contract referenced from discovery + sow body matches the canonical field name).

07-02 / 07-03 self-verify their own section before the other skill exists. Synthesis (07-03 or split 07-04) runs `--all` as the e2e smoke gate.

**Rationale.** Mirrors Phase 6 D-63 partitioned pattern. Single script = single source of truth on phase shape; `--section` keeps plan-local verification cheap.

### Claude's Discretion

- Detailed template body wording inside `kickoff-template.md` — planner authors from STG1 + DESIGN-17 categories per D-70; only the H2 section list is locked, not the prose.
- Specific trigger thresholds inside `auto-classify-rubric.md` (e.g., whether "< 2 distinct source mentions" should be "< 3" instead) — planner picks during research, can be adjusted at execute time.
- Exact wording of the `## Platform Scope` / `## Integration Scope` section descriptions in the SOW template — planner authors.
- Plan-task counts inside each per-skill plan — planner discretion at `/gsd-plan-phase` time.
- Whether 07-03 splits to 07-04 — planner enforces the ~400 LOC threshold from D-69.
- Existence of any STG1/STG2/STG3 OPEN-Q rows in `.planning/OPEN-QUESTIONS.md` — researcher checks during 07-01 / 07-03 research; resolved inline per D-67.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Locked design contracts
- `.planning/DESIGN.md` — DESIGN-17 (kickoff-capture skill), DESIGN-18 (discovery-intake modification), DESIGN-19 (SOW single-scope + lifecycle), DESIGN-09 (Field Notes directional boundary + MOD-8 prevention), DESIGN-07 + AUDIT-08 (Miro paste fallback shape), DESIGN-08 (lenient-mode read contract + status-lifecycle survey), DESIGN-06 (approval-gate fields), DESIGN-02 (file-prefix scheme)
- `.planning/REQUIREMENTS.md` — v2.2 STG1-01..05 + STG2-01..03 + STG3-01..02 (10 reqs covered by Phase 7)
- `.planning/ROADMAP.md` § "Phase 7" — 5 success criteria (verbatim from roadmap lock 2026-05-11)
- `.planning/CHANGELIST.md` CHANGE-01 Phase 3 — v2.2 milestone sequencing authority

### Plugin canonical references (FOUND-01..04 outputs)
- `dydx-delivery/references/safety-rules.md` — hard-rules pointer target
- `dydx-delivery/references/stage-numbering.md` — Stage 1 placement, `01_kickoff_v*` filename mapping, old→new mapping table
- `dydx-delivery/references/frontmatter-scheme.md` — `based_on_kickoff:` field convention (underscore-snake-case), canonical status lifecycle, approval-gate fields, lenient-mode contract
- `dydx-delivery/references/glossary.md` — terminology pointer target

### Prior phase context (carried forward — do NOT re-derive)
- `.planning/milestones/v2.1-phases/05-foundations/05-CONTEXT.md` — D-56 (connector-matrix doc-only), D-57 (inline OPEN-Q resolution = D-67 precedent), D-58 (renumbering scope), D-59 (uniform pointer sentence), D-60 (5-wave domain slicing), D-62 (lift-and-fix precedent)
- `.planning/milestones/v2.1-phases/06-internalise-platform-skills/06-CONTEXT.md` — D-63 (3 per-platform atomic plans = Phase 7 D-69 precedent), D-67 (per-phase OPEN-Q resolution = inherited)
- `.planning/milestones/v2.1-RETROSPECTIVE.md` — v2.1 lessons applied to v2.2 plan-wiring (auto-flip REQUIREMENTS.md trace; cross-AI review at plan time verifies downstream consumers; per-phase structure-check with `--section` for parallel waves)

### Existing skill targets (the things this phase WRITES TO)
- `dydx-delivery/skills/discovery-intake/SKILL.md` — current v0.3.0 body; Phase 7 MODIFIES (consume kickoff; RETIRE raw-notes; verbatim skip-message)
- `dydx-delivery/skills/discovery-intake/references/intake-template.md` — body unchanged per STG2-03 (only upstream input contract + skip behaviour change)
- `dydx-delivery/skills/generate-sow/SKILL.md` — current v0.3.0 body; Phase 7 MODIFIES (lock lifecycle; dual-scope H2s)
- `dydx-delivery/skills/generate-sow/references/sow-template.md` (or current name) — gets `## Platform Scope` + `## Integration Scope` H2 sections added

### Codebase intel
- `.planning/codebase/STRUCTURE.md` § "SKILL.md body structure" — body shape conventions kickoff-capture SKILL.md must follow
- `.planning/codebase/CONCERNS.md` — v0.3.0 inventory baseline (raw-notes path appears here; confirms retirement scope)
- `.planning/codebase/PATTERNS.md` — bash skeleton for structure-check.sh script (Phase 5 + Phase 6 precedent script)

### Project-level locks (carried forward — DO NOT re-litigate)
- `.planning/PROJECT.md` § "Out of Scope" — UAT-3.5 (MCPs out v2.6), UAT-6.1 (native-AI APIs out), UAT-3.1 (private email intentional), D-65 (client-shape-gotchas seed list), D-67 (per-phase OPEN-Q resolution)

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `.planning/phases/06-internalise-platform-skills/scripts/phase6-structure-check.sh` (in archived v2.1-phases) — direct template for D-77 `phase7-structure-check.sh`. Lift-and-adapt: replace `--section <pipefy|wrike|ziflow>` partitioning with `--section <kickoff|discovery|sow>`, swap assertion blocks per D-77 spec.
- `dydx-delivery/skills/discovery-intake/SKILL.md` v0.3.0 body — the modification target for 07-02; existing body sections (Inputs, Output, How to run, What this skill does not do, Quality bar) stay; surgical edits to Step 1 (upstream artefact triage), Step N (skip-branch behaviour), and Inputs (RETIRE raw-notes; require `01_kickoff_v<N>.md`).
- `dydx-delivery/skills/discovery-intake/references/intake-template.md` — body UNCHANGED per STG2-03 (only upstream contract changes).
- `dydx-delivery/skills/generate-sow/SKILL.md` v0.3.0 body — the modification target for 07-03; existing body stays; surgical edits to status-lifecycle block (lock to canonical 4-state per STG3-01) and Scope section (add ## Platform Scope + ## Integration Scope H2s per D-75).
- `dydx-delivery/skills/execute-tests/references/` shape (multiple supporting refs alongside template) — direct analog for D-71 kickoff-capture references/ shape.
- `dydx-delivery/skills/platform-pipefy/SKILL.md` (Phase 6 output) — exemplar for the FOUND-04 canonical-pointer sentence pattern kickoff-capture must follow.

### Established Patterns
- **SKILL.md body shape** (`.planning/codebase/STRUCTURE.md`) — H1 → one-paragraph purpose → ## Inputs → ## Output → ## How to run (numbered Steps; Step 1 = Locate upstream artefact with start-at-any-point triage; late Step = Senior-level challenge; final Step = Write and hand off) → ## What this skill does not do → ## Quality bar. kickoff-capture SKILL.md follows this exactly.
- **Canonical-pointer sentence** (FOUND-04 / D-59) — single uniform sentence + relative path for each of safety-rules / stage-numbering / frontmatter-scheme / glossary. Lift verbatim from any Phase 5/6 skill output.
- **Per-skill atomic plan slicing with synthesis fold** (D-63 from Phase 6) — direct template for D-69. Synthesis stays inside last plan unless plan content exceeds ~400 LOC.
- **`--section`-partitioned structure-check** (D-63 partition semantics) — direct template for D-77.
- **Inline OPEN-Q resolution** (D-57 + D-67) — researcher reads `.planning/OPEN-QUESTIONS.md` during 07-01 / 07-03 research; any STG1/STG2/STG3 rows resolved inline in those plans; synthesis flips the register row.
- **Lift-and-fix template authoring** (D-62) — planner attempts to lift any DESIGN-17 literal blocks before authoring from scratch per D-70.
- **Lenient-mode read contract** (DESIGN-08) — applied per D-76; new writes enforce, reads stay lenient.

### Integration Points
- **Upstream connection**: kickoff-capture's `01_kickoff_v<N>.md` becomes the sole upstream input to discovery-intake (`based_on_kickoff:` MANDATORY). The kickoff frontmatter contract is established in 07-01 before 07-02/07-03 lock against it.
- **Branch-routing fan-out**: a single `kickoff_branch:` enum field in kickoff frontmatter drives both discovery-intake (`discovery-ready` → run; `draft-sow` → skip with verbatim message) AND generate-sow (`draft-sow` → read kickoff directly via `based_on_kickoff:`). Both downstream skills MUST read the same field name from the same canonical position.
- **Lenient-mode read-path**: discovery-intake's modified Step 1 reads `01_kickoff_v<N>.md` strictly (MANDATORY contract) but legacy v0.3.0 `00_discovery_v*.md` reads stay lenient per DESIGN-08 + D-76.
- **Forward connection to Phase 8**: Phase 8 (Stage 4 fnspec split) reads approved `02_discovery_v*` (from 07-02 output when `discovery-ready` branch) + approved `03_sow_v*` (from 07-03 output). The `## Platform Scope` + `## Integration Scope` H2 split in the SOW per D-75 gives Stage 4a/4b clean inputs.
- **Field Notes Coda integration**: doc-only paste protocol per D-72; no MCP/API connection ships. Future Coda MCP integration deferred to v2.6 / SURF-01..03.

</code_context>

<specifics>
## Specific Ideas

- **Verbatim skip-message** — discovery-intake must emit exactly `Stage 2 SKIPPED — kickoff branch = draft-sow` on the `draft-sow` branch. No paraphrase. `phase7-structure-check.sh --section discovery` asserts this string is present verbatim in SKILL.md.
- **Single source of truth for the routing field** — `kickoff_branch:` enum lives only in `01_kickoff_v<N>.md` frontmatter. Both discovery-intake and generate-sow READ it; neither owns it. No duplicate enums elsewhere.
- **`based_on_kickoff:` field name** — underscore-snake-case per `frontmatter-scheme.md` Field-name conventions (mirrors `based_on_discovery`, `based_on_sow`, `based_on_techspec`, etc.).
- **8 kickoff template categories** (STG1-04 verbatim, in order) — system / users / triggers / data / rules / integrations / exceptions / failure points. Template H2s in this order.
- **Lift-and-fix precedence** — planner checks `.planning/DESIGN.md` DESIGN-17 for any literal template / rubric / capture-paths text first; lifts what's there; authors the rest per D-70 / D-73.
- **`processed_at IS NULL` filter wording** — verbatim per DESIGN-09; documented in `capture-paths.md` Field Notes section.
- **`[unknown — needs human classification]` marker** — verbatim per STG1-04; auto-classify-rubric defines when it appears; structure-check asserts the marker convention is documented.
- **MOD-8 prevention** — kickoff never auto-merges Field Notes entries into the brain; quotes the note + asks human keep/drop/edit-and-keep. Documented in `capture-paths.md` Field Notes section per STG1-03.

</specifics>

<deferred>
## Deferred Ideas

- **Coda MCP integration for Field Notes** — captured as v2.6 / SURF-01..03 candidate. Today's `capture-paths.md` documents paste-only protocol per D-72; a future Coda MCP would replace the manual paste step. Not in v2.2 scope (UAT-3.5).
- **Stage 1 → Stage 2/3 auto-progression hook** — explicitly out per `.planning/REQUIREMENTS.md` v2.2 "Out of Scope" (approval gates non-negotiable per DESIGN-06). Defer indefinitely.
- **Auto-migration of legacy v0.3.0 `00_discovery_v*.md` artefacts** — opt-in per CR per DESIGN-08; not in v2.2 scope. Could ship a one-shot migrator in a future milestone if reviewer demand emerges.
- **Frontmatter `scope:` array on SOW** — considered for STG3-02 (would maximise machine-readability for Stage 4a/4b). Rejected for v2.2 because it requires a DESIGN-19 amendment. If Stage 4 split work surfaces a real need, revisit in v2.3+.
- **Always-mark-default rubric mode** — considered for STG1-04 (heaviest-handed enforcement). Rejected because it adds reviewer load disproportionate to signal. Could be revisited if low-confidence escapes the rubric in production use.
- **Marker file on `draft-sow` skip** (`02_discovery_v0_SKIPPED.md`) — considered for audit trail. Rejected per D-74 (violates verbatim "writes no artefact"); git history + handoff log carry the audit trail instead.

</deferred>

---

*Phase: 7-stage-1-kickoff-discovery-sow-upstream-wiring*
*Context gathered: 2026-05-11*
