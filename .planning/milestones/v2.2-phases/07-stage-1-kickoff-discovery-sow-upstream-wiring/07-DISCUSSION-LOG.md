# Phase 7: Stage 1 Kickoff + Discovery/SOW upstream wiring - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in `07-CONTEXT.md` — this log preserves the alternatives considered.

**Date:** 2026-05-11
**Phase:** 7-stage-1-kickoff-discovery-sow-upstream-wiring
**Areas discussed:** Plan slicing, kickoff template body source, kickoff-capture references shape, Field Notes Coda access path, Auto-classification rubric, discovery-intake skip emit shape, SOW body shape for single-scope, Lenient v0.3.0 reconciliation, structure-check script pattern

---

## Plan slicing + parallelism (→ D-69)

| Option | Description | Selected |
|--------|-------------|----------|
| 3 per-skill atomic plans (Recommended) | 07-01 kickoff-capture (new) + ships structure-check / 07-02 discovery-intake mods / 07-03 generate-sow mods + synthesis. 07-02/07-03 depend on 07-01; parallel-eligible (disjoint dirs). Mirrors Phase 6 D-63. | ✓ |
| 2 plans: scaffold + mods | 07-01 kickoff-capture standalone / 07-02 chained STG2+STG3 mods + synthesis. Tighter but couples discovery+sow into one atomic unit. | |
| 4 plans with synthesis split | 07-01 kickoff / 07-02 discovery / 07-03 sow / 07-04 synthesis. Maximum granularity; matches Phase 5 5-wave pattern. | |
| 1 monolithic plan | Single plan covers all 3 skills + synthesis. Loses Phase 6 D-63 atomicity benefit. | |

**User's choice:** 3 per-skill atomic plans (Recommended)
**Notes:** Synthesis-folding rule from Phase 6 retained — split to 07-04 if 07-03 exceeds ~400 LOC plan content. 07-02 + 07-03 parallel-eligible after 07-01 frontmatter contract lands.

---

## kickoff template body source + sections (→ D-70)

| Option | Description | Selected |
|--------|-------------|----------|
| Author from STG1 reqs + DESIGN-17 categories (Recommended) | Planner composes `kickoff-template.md` filling 8 STG1-04 categories into v0.3.0 SKILL.md body shape. Same authoring pattern as Phase 6 platform-* skills. | ✓ |
| Lift verbatim from DESIGN-17 (D-62 precedent) | If DESIGN-17 contains a literal template block, lift-and-fix. Falls back to option A if no block exists. | |
| Hybrid — lift any literal blocks + author the rest | Researcher reads DESIGN-17 + DESIGN-09 first; lifts what exists, authors gaps. | |

**User's choice:** Author from STG1 reqs + DESIGN-17 categories (Recommended)
**Notes:** Lift-and-fix precedence still applies (planner checks DESIGN-17 for any literal text first per D-62 precedent), but the default mental model is author-from-categories.

---

## kickoff-capture references/ shape (→ D-71)

| Option | Description | Selected |
|--------|-------------|----------|
| Template + auto-classify-rubric + capture-paths (Recommended) | 3 files: `kickoff-template.md` + `auto-classify-rubric.md` + `capture-paths.md`. Mirrors execute-tests references/ pattern. | ✓ |
| Template only (matches discovery-intake) | Single file; rubric + capture-paths inlined into SKILL.md body. | |
| Template + rubric (no capture-paths file) | 2 files; capture-paths stays inline. | |
| Full pattern + canonical-pointers stubs | Template + rubric + capture-paths + 2 pointer-stub files. Heaviest. | |

**User's choice:** Template + auto-classify-rubric + capture-paths (Recommended)
**Notes:** Keeps SKILL.md body lean. SKILL.md references each by path per FOUND-04 uniform-pointer pattern.

---

## Field Notes Coda access path (→ D-72)

| Option | Description | Selected |
|--------|-------------|----------|
| Doc-only paste protocol (Recommended) | `capture-paths.md` documents table shape + `processed_at IS NULL` filter wording + paste protocol. No code path ships. Matches connector-matrix doc-only + UAT-3.5 + UAT-6.1 + DESIGN-09. | ✓ |
| Direct Coda API curl example | curl example with CODA_API_TOKEN env var. Functional today but adds friction; not aligned with v2.6 MCP-out scope. | |
| MCP-placeholder with TODO | Notes future Coda MCP integration; today reviewer pastes manually. | |

**User's choice:** Doc-only paste protocol (Recommended)
**Notes:** Future Coda MCP captured under Deferred Ideas (v2.6 / SURF-01..03 candidate).

---

## Auto-classification rubric (STG1-04) (→ D-73)

| Option | Description | Selected |
|--------|-------------|----------|
| Explicit rules + escalation table (Recommended) | 3-5 explicit triggers + input-signal→outcome table + defensive operational principle. Operationalises STG1-04; verifiable in structure-check. | ✓ |
| Doc-only heuristic prose | Skill self-judges per-section. Lower ceremony, harder to verify. | |
| Always-mark-unknown default + reviewer accepts | Every section starts marked; auto-fill underneath. Heaviest reviewer load. | |

**User's choice:** Explicit rules + escalation table (Recommended)
**Notes:** `phase7-structure-check.sh --section kickoff` asserts the rubric file exists and is referenced from SKILL.md.

---

## discovery-intake skip emit shape (STG2-02) (→ D-74)

| Option | Description | Selected |
|--------|-------------|----------|
| Pure stdout, no file (Recommended) | Verbatim `Stage 2 SKIPPED — kickoff branch = draft-sow` message; no marker file; audit trail = git + handoff log. Matches roadmap criterion #3 verbatim. | ✓ |
| Stdout + thin marker file `02_discovery_v0_SKIPPED.md` | Preserves client-folder file-trail pattern but violates "writes no artefact" criterion text. | |
| Stdout + Coda audit log row | Heaviest; needs Coda API access. Out-of-line with UAT-3.5. | |

**User's choice:** Pure stdout, no file (Recommended)
**Notes:** Marker-file option captured under Deferred Ideas (revisit if audit pressure emerges).

---

## SOW body shape for single-scope (STG3-02) (→ D-75)

| Option | Description | Selected |
|--------|-------------|----------|
| Explicit ## Platform Scope + ## Integration Scope H2s (Recommended) | Dual-scope visibly auditable at client_review. Stage 4a/4b can deterministically pick inputs. No frontmatter change. | ✓ |
| Narrative-only restructure | Body prose covers both scopes inside existing ## Scope. Loses visible separation. | |
| Frontmatter scope: [platform, integration] array | Most machine-readable but blocks on DESIGN-19 amendment. | |

**User's choice:** Explicit ## Platform Scope + ## Integration Scope H2s (Recommended)
**Notes:** Frontmatter array option captured under Deferred Ideas (revisit in v2.3+ if Stage 4 split surfaces real need).

---

## Lenient-mode v0.3.0 reconciliation (STG2-01 vs DESIGN-08) (→ D-76)

| Option | Description | Selected |
|--------|-------------|----------|
| Lenient-read OK, enforce on NEW writes only (Recommended) | Reads stay lenient per DESIGN-08. New v2.2+ writes MUST carry `based_on_kickoff:`. Future validate-frontmatter hook (v2.6) enforces write-path only. | ✓ |
| Hard-reject any read without based_on_kickoff: | Forces explicit migration; violates DESIGN-08. | |
| Lenient-read + warning header in stdout | Soft nudge toward migration without breaking reads. | |

**User's choice:** Lenient-read OK, enforce on NEW writes only (Recommended)
**Notes:** Reconciles STG2-01 "MANDATORY" with DESIGN-08 lenient-mode without amending either.

---

## structure-check script pattern (→ D-77)

| Option | Description | Selected |
|--------|-------------|----------|
| Single phase7-structure-check.sh with --section (Recommended) | One script with `--section <kickoff\|discovery\|sow>` + `--all`. Ships in 07-01. Matches Phase 6 D-63 partitioned pattern. | ✓ |
| Three independent scripts per plan | Per-plan ownership but loses shape-parity gate Phase 6 used. | |
| Inline bash per plan (no script file) | Cheapest but no reusable artefact. | |

**User's choice:** Single phase7-structure-check.sh with --section (Recommended)
**Notes:** 07-02 / 07-03 self-verify their own section before all 3 skills exist on disk; synthesis runs `--all`.

---

## Claude's Discretion

Areas where planner has flexibility at `/gsd-plan-phase` time:

- Detailed wording inside `kickoff-template.md` body (only H2 list is locked per D-70).
- Specific numeric thresholds inside `auto-classify-rubric.md` (e.g., "< 2 vs < 3 distinct source mentions").
- Exact phrasing of `## Platform Scope` / `## Integration Scope` descriptions in the SOW template.
- Plan-task counts inside each per-skill plan.
- Whether 07-03 splits to 07-04 (per ~400 LOC threshold from D-69).
- Existence and resolution shape of any STG1/STG2/STG3 OPEN-Q rows (researcher checks during 07-01/07-03; inline resolution per D-67).

## Deferred Ideas

- Coda MCP integration for Field Notes — v2.6 / SURF-01..03 candidate.
- Stage 1 → Stage 2/3 auto-progression hook — explicitly out (approval gates non-negotiable per DESIGN-06).
- Auto-migration of legacy v0.3.0 `00_discovery_v*.md` artefacts — opt-in per CR per DESIGN-08.
- Frontmatter `scope:` array on SOW — revisit in v2.3+ if Stage 4 surfaces real need.
- Always-mark-default rubric mode — revisit if low-confidence escapes the explicit rubric in production.
- Marker file on `draft-sow` skip — revisit if audit pressure emerges.
