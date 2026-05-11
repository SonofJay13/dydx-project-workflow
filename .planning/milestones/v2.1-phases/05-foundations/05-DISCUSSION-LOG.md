# Phase 5: Foundations + Connector Verification — Discussion Log

**Discussed:** 2026-05-10
**Format:** Selected gray areas, options presented, user selection, follow-up notes

---

## Gray-area selection

**Question:** Which areas do you want to discuss for Phase 5?
**Options presented (multi-select):**
- Plan slicing & wave ordering
- Connector probe execution shape
- OPEN-Q resolution method (8 questions)
- Renumbering & repointing concrete scope

**User selected:** ALL 4 areas.

---

## Area 1 — Connector probe execution shape

**Frame:** DESIGN-07 says "session-start probe of each MCP" + per-stage fallback matrix. DESIGN-04 limits `hooks/` to `validate-frontmatter` + `bump-artefact-version` (probe hook EXCLUDED). FOUND-09 says `commands/` / `agents/` / `hooks/` ship as empty scaffold dirs in Phase 5.

**Options presented (single-select):**
1. **Doc-only matrix (Recommended)** — `connector-matrix.md` is static; skills read it at session start; no commands/agents/hooks content.
2. Doc + slash command — `commands/dydx-probe-connectors.md` runs on-demand.
3. Doc + agent — `agents/connector-prober/` invoked at first MCP-touching skill call.
4. Doc + lightweight probe script — `dydx-delivery/scripts/probe-connectors.sh`.

**User selected:** Option 1 — **Doc-only matrix**.

**Decision captured as:** D-56 in `05-CONTEXT.md`.

**Downstream consequence:** Re-running the probe in v2.1 use = manual `claude mcp list` + verify against `connector-matrix.md`. On-demand `/dydx-probe-connectors` slash command deferred to v2.6 / SURF-01..03 if needed (captured in Deferred Ideas).

---

## Area 2 — OPEN-Q resolution method (8 questions)

**Frame:** 8 connector OPEN-Qs assigned to Phase 5 (Q06.1 / Q07.1 / Q09 / Q10 / Q11 / Q12 / Q13 / Q25). Split: 5 web-research items (rate-limits, Claude in Chrome name, Wrike host SoT, Wrike+Ziflow auth concurrency) + 3 workspace-probe items (Coda MCP, GWorkspace MCP, Miro MCP — re-confirm AUDIT-08).

**Options presented (single-select):**
1. **Inline in Phase 5 plans (Recommended)** — dedicated wave bundles web research + workspace probe; resolved values land in `connector-matrix.md` and `OPEN-QUESTIONS.md` row flips.
2. Run `/gsd-research-phase 5` first — separate research-phase artefact, then plan-phase consumes it.
3. Split — research items via research-phase; workspace probes inline.

**User selected:** Option 1 — **Inline in Phase 5 plans**.

**Decision captured as:** D-57 in `05-CONTEXT.md`.

**Downstream consequence:** Wave 4 plan covers both web research + workspace probe + `connector-matrix.md` authoring + `OPEN-QUESTIONS.md` row flips (`open`/`proposed` → `decided` with one-line resolution citation) in one bundle.

---

## Area 3 — Renumbering & repointing concrete scope (FOUND-05, FOUND-06)

**Frame:** FOUND-06 mapping 00→02 / 01→03 / 02→04 / 03→05 / 04→07a applies to NEW artefacts only (v0.3.0 in-flight artefacts in client folders NEVER renamed per DESIGN-08). FOUND-05 hard-rules collapse hits 4 known duplicate locations per AUDIT-05.1.

**Sub-question A — Renumbering touch surface:**

Options presented (single-select):
1. **Mapping in `stage-numbering.md` only; skill bodies updated to cite new prefixes (Recommended)** — full pass on skill SKILL.md bodies + skill internal templates.
2. Mapping in `stage-numbering.md` only; skill bodies UNTOUCHED in Phase 5.
3. Mapping + skill bodies + skill templates all renumbered now (same as option 1 in scope — flagged as more invasive label).

**User selected:** Option 1 — **Mapping in stage-numbering.md + skill bodies + skill internal templates**.

**Decision captured as:** D-58 in `05-CONTEXT.md`.

**Sub-question B — Hard-rules pointer format:**

Options presented (single-select):
1. **Single sentence + relative path (Recommended)** — same one-liner across all 4 affected files.
2. Frontmatter field + body pointer — add `safety_rules_ref:` to frontmatter.
3. Body pointer only, custom per-skill.

**User selected:** Option 1 — **Single uniform sentence + relative path**.

**Decision captured as:** D-59 in `05-CONTEXT.md`.

**Locked pointer wording:**
```
> **Hard rules:** Sandbox-only operations. Read-write only against named sandbox tenants. Refuses destructive actions. See `dydx-delivery/references/safety-rules.md` for the canonical ruleset.
```
Applies to: `skills/discovery-intake/SKILL.md`, `skills/generate-sow/SKILL.md`, `skills/execute-tests/SKILL.md`, `skills/execute-tests/references/safety-rules.md`.

---

## Area 4 — Plan slicing & wave ordering

**Frame:** 13 FOUND-* requirements + 8 OPEN-Q inline resolutions. File-ownership conflicts on `plugin.json` / `marketplace.json` / `OPEN-QUESTIONS.md` / `connector-matrix.md` force serialization.

**Sub-question A — Wave granularity:**

Options presented (single-select):
1. **5 waves by domain (Recommended)** — W1 canonical refs scaffold; W2 skill repoint+renumber; W3 manifest+LICENSE+scaffold dirs; W4 connector probe + OPEN-Qs; W5 cosmetic CONCERNS + status survey. (Status-lifecycle survey moved to W1 per Sub-question B.)
2. Finer slice — 7–8 plans.
3. Coarser slice — 3 mega-plans.

**User selected:** Option 1 — **5 waves by domain**.

**Decision captured as:** D-60 in `05-CONTEXT.md`.

**Sub-question B — Status-lifecycle survey (FOUND-12) timing:**

Options presented (single-select):
1. **Before scaffold — in W1 (Recommended)** — survey runs at Phase 5 kickoff per OPEN-Q16 wording; informs lenient-mode contract specifics.
2. After scaffold — in final wave.

**User selected:** Option 1 — **Before scaffold, in W1**.

**Decision captured as:** D-61 in `05-CONTEXT.md`.

**Final wave plan** (per D-60 + D-61):

| Wave | Plan | Scope | FOUND-* |
|---|---|---|---|
| W1 | 05-01-PLAN.md | Status-lifecycle survey + 4 canonical refs in parallel | 01, 02, 03, 04, 12 |
| W2 | 05-02-PLAN.md | 7 skills repointed + renumber + `based_on_*` normalisation | 05, 06 |
| W3 | 05-03-PLAN.md | Manifest 2.0.0 + LICENSE + scaffold dirs | 07, 08, 09 |
| W4 | 05-04-PLAN.md | `connector-matrix.md` + 8 OPEN-Q resolution | 10, 13 |
| W5 | 05-05-PLAN.md | 5 cosmetic CONCERNS fixes (B.1/B.2/B.3/B.4/B.6) | 11 |

---

## Implicit decisions (no AskUserQuestion — derived from upstream locks)

- **D-62 — `safety-rules.md` migration = lift-and-fix** — derived from FOUND-01 + CRIT-5 + AUDIT-05.1 (preserves v0.3.0 validated content; adds Coda to sandbox allowlist). Not explicitly asked because it's the minimum-change path consistent with locked requirements.

---

## Deferred ideas (captured for later phases)

- On-demand `/dydx-probe-connectors` slash command — evaluate for v2.6 / SURF-01..03 if manual probe re-check proves cumbersome.
- Probe hook (session-start automatic probe) — DESIGN-04 excludes; not revisited.
- Renumbering v0.3.0 in-flight artefacts — DESIGN-08 + OPEN-Q15 lock the lenient-mode permanent contract.
- Plugin self-test (pytest harness) — OPEN-Q22 routes to Phase 9 owner.
- Substantive `commands/refine.md` — OPEN-Q21 + Q21.1 lock the shape; authoring lands in v2.6 / SURF-01.

---

*Discussion completed: 2026-05-10*
