---
purpose: User Acceptance Testing brief for milestone v2.0 Implementor Edition
milestone: v2.0
status: ready-for-uat
created: 2026-05-10
---

# Milestone v2.0 — Reviewer UAT Brief

## What's being reviewed

Milestone v2.0 (Implementor Edition) is a **design-only** milestone. No code was written. Four markdown deliverables are the entire output:

1. `.planning/AUDIT.md` — observed reality of the v0.3.0 plugin
2. `.planning/DESIGN.md` — locked v2 architecture (cross-cutting + 13 skills + test bot)
3. `.planning/CHANGELIST.md` — sequenced v0.3.0 → v2 delta as the v2.1+ build plan
4. `.planning/OPEN-QUESTIONS.md` — 25-row register of unresolved items with owning phase + verification owner

All four passed automated structural-checks + reviewer-ready synthesis + cross-AI peer review + gsd-verifier. They're approved. UAT now is a **human sanity-check** before committing to v2.1 build work.

**Goal of UAT:** confirm the design artefacts will hold up when you start writing v2.1 skills against them. Catch anything that reads fine on its own but breaks when you simulate a real client engagement.

---

## Walkthrough order (recommended)

Total time: ~45-90 min depending on depth. Each step builds on the previous — don't skip.

### Step 1 — Re-run the structural gates (5 min, mechanical)

Confirm nothing rotted between approval and now.

```bash
bash .planning/phases/01-audit/scripts/audit-structure-check.sh
bash .planning/phases/02-design/scripts/design-structure-check.sh
bash .planning/phases/03-changelist/scripts/changelist-structure-check.sh
bash .planning/phases/04-open-questions/scripts/openquestions-structure-check.sh
bash .planning/phases/04-open-questions/scripts/openquestions-reconcile.sh
```

All five should exit 0. If any fail, stop UAT and investigate before continuing.

**Pass criterion:** every script exits 0.

---

### Step 2 — Walk the original kickoff against deliverables (10-15 min)

The kickoff for v2.0 lived in `PROJECT.md` + the original `REQUIREMENTS.md`. Re-read both, then ask: *do the four deliverables fully discharge what was promised?*

**Files to read:**
- `.planning/PROJECT.md`
- `.planning/REQUIREMENTS.md` (especially the AUDIT-NN, DESIGN-NN, CHANGE-NN, OPEN-NN sections)

**Questions to answer:**
1. Is there anything in the original kickoff that didn't land in any artefact?
2. Did the scope drift in either direction (broader or narrower than intended)?
3. Are there v2.0 promises that should have been deferred to v2.1+ but weren't?

**Pass criterion:** every kickoff line item has a home in one of the four deliverables OR is explicitly deferred in OPEN-QUESTIONS.md.

---

### Step 3 — AUDIT.md sanity-check (10 min)

Read `.planning/AUDIT.md` end-to-end. You wrote v0.3.0 — your memory is the validator here.

**Questions to answer:**
1. The 7-row skill matrix (AUDIT-01) — any skill missing? Any brittleness I called out wrongly?
2. The connector dependency table (AUDIT-03) — does the per-stage required vs. graceful-degradation column match how the plugin actually behaves today?
3. The missing-artefact list (AUDIT-04) — anything I flagged as missing that's actually present? Anything genuinely missing that I didn't catch?
4. The version-mismatch table (AUDIT-06) — are the version pins still accurate?
5. AUDIT-07 cosmetic fixes — anything in the v0.3.0 codebase that bothers you that's not on this list?

**Pass criterion:** AUDIT.md is a faithful inventory of v0.3.0 as you remember it.

---

### Step 4 — DESIGN.md mental simulation (15-20 min)

This is the highest-leverage step. Read DESIGN.md by **simulating a real client engagement** end-to-end and asking: at each stage, do I have enough to build the skill?

**Walk this scenario:**
1. New client lands. Stage 1 (Kickoff) runs. Read `## Stage 1: Kickoff` — is the dual-branch + Field Notes triage filter (`processed_at IS NULL`) concrete enough that you could write the skill from scratch?
2. Stage 2 (Discovery) → Stage 3 (SOW) → Stage 4a/4b (Fnspec split) → Stage 5 (Tech spec) → Stage 6 (Cost estimate) → Stage 7a/7b (Build prompts). For each: imagine writing the SKILL.md. Does the design tell you the inputs / outputs / hand-off / closed enums / failure modes?
3. Stage 8a-8d (Test bot) — the `client_state.yaml` schema (DESIGN-29) and drift-detection contract (DESIGN-30) are interface-level only. Comfortable with that level of specificity for v2.1 build, or do you need more before you can start?
4. Stage 9 (Doc publishing) → Stage 10 (Native-AI) → Stage 11 (Sign-off). Same lens.

**Specific things to spot-check:**
- Risk-multiplier defaults in Stage 6 (DESIGN-22) carry `<TBD-deferred>` placeholder + `[OPEN: Phase 4 — risk-multiplier defaults pending dYdX-historical validation per D-22]` marker. That's an OPEN-QUESTIONS row. Are you OK shipping v2.1 Stage 6 with the placeholder, or do you need the defaults locked first?
- Wrike `host` field persistence (DESIGN-15 CRITICAL bug-prevention callout) — is that callout placed where someone implementing Stage 7b will actually read it?
- The `## Out of Scope` sections per stage — anything in the "out of scope" list that you'd actually want in scope for v2.1?

**Pass criterion:** for every stage, you can answer "yes, I could write the skill from this contract without re-opening the design doc 10 times."

---

### Step 5 — CHANGELIST.md sequencing (10 min)

Read `.planning/CHANGELIST.md` — specifically the Executive Summary table + the 9-phase mini-tables.

**Questions to answer:**
1. The v2.1 → v2.6 milestone bundling — does this match how you'd want to ship? (v2.1 = Foundations + Platform skills; v2.2 = Stage 1 + Stage 4 split; v2.3 = Tech spec + Cost + Implementation prompt; v2.4 = Test bot rebuild; v2.5 = Documentation publishing; v2.6 = Native-AI knowledge push + Sign-off + Coda mirror + Surfaces)
2. Phase 7 (native-AI ingestion) is HARD BLOCKED on OPEN-01 native-AI research. The contingent fallback says "slide P8/P9 → v2.7 if unresolved at v2.5 kickoff." Comfortable with that escape hatch?
3. Phase 1 (Foundations + Connector probe) — the connector probe needs to land BEFORE platform skills can be built. Does the dependency hold?
4. The per-skill delta matrix (Appendix A) — 13 NEW + 6 MODIFIED + 1 RETIRED→SPLIT = 13-skill v2 universe. Match your mental model?
5. Appendix B cosmetic fixes (verbatim AUDIT-07 lift) — each carries "Scheduled for v2.1 Foundations build (FOUND-NN), NOT this milestone." Are those FOUND-NN slots realistic for v2.1?

**Pass criterion:** the v2.1 sequence reads as buildable, and you'd start with v2.1 Phase 1 tomorrow if asked.

---

### Step 6 — OPEN-QUESTIONS.md row-by-row (15-20 min)

This is the register that v2.1+ phases inherit. Every row must be answerable, owned, and timed.

Read all 25 rows. For each, answer:

1. **Severity calibration** — Severity is BLOCKER / GUARDRAIL / INFORMATIONAL. Does the level match your gut? If a BLOCKER row stays unresolved, what concretely breaks at v2.1 build time?
2. **Ownership realism** — the Owning phase + Verification owner fields name a phase or person. Is the person actually in a position to resolve it by then?
3. **Resolution path realism** — closed enum (`/gsd-research-phase` / `live-workstream-pointer` / `Coda-template-authoring (Phase 8)` / `policy-pending-sign-off` / etc.). Is the named path actually viable?
4. **Anything missing** — walking your engagement simulation from Step 4, did anything come up that's not in the register? If yes, that's a Phase 4 gap.
5. **Anything overscoped** — any row that's tagged for a later phase but should actually be locked NOW before v2.1 starts? (E.g., risk-multiplier defaults — should these be researched + locked before v2.1 Stage 6 build, or is "build with placeholder + revisit" acceptable?)

**Spot-check 3 random citations** — pick 3 rows, follow the `path:line` citation in the Source citations field, confirm the cited line actually says what the row claims it cites.

**Pass criterion:** every row reads as actionable; nothing is missing; nothing should have been resolved earlier.

---

### Step 7 — Cross-doc consistency spot-check (5 min)

Three quick consistency sweeps:

1. **Open markers consistent** — DESIGN.md has 17 inline `[OPEN: Phase 4 — ...]` markers. CHANGELIST.md Appendix E has 9 bullet enumerations. OPEN-QUESTIONS.md has 25 register rows. The reconciliation script (Wave 5) confirmed they reconcile. Spot-check: pick 1 inline marker in DESIGN.md, find its register row in OPEN-QUESTIONS.md, confirm the wording / owner aligns.
2. **Stage handoff matrix** — DESIGN.md's stage-by-stage handoff matrix (DESIGN-13) names per-transition carrier files + propagated frontmatter fields + gating status flags. Pick one transition (e.g., Stage 4b → Stage 5). Read both stages and confirm the matrix matches the actual Stage 4b output / Stage 5 input contracts.
3. **Per-skill delta matrix consistency** — CHANGELIST.md Appendix A's 20-row matrix should match DESIGN.md's 13-skill inventory (DESIGN-12). Bottom-row totals: 13 NEW + 6 MODIFIED + 1 RETIRED→SPLIT = 20 entries representing 13-skill universe. Quick eyeball check.

**Pass criterion:** no contradictions surface.

---

## Reporting back

After UAT, tell me:

1. **Pass / Fail** per step (1-7).
2. **Findings** — anything surprising, broken, or missing.
3. **Decision** — proceed to v2.1, or fix something first?

If everything passes, next move is `/gsd-new-milestone` to scope v2.1 (Foundations + Platform skills per CHANGE-01).

If something fails, options are:
- **Patch in place** — small fix to one of the four deliverables (a row, a citation, a contract clause). Re-run the relevant structure-check.
- **Add an OPEN row** — if it's a "not-yet-decided" issue, append to OPEN-QUESTIONS.md and re-run reconciliation.
- **Re-open a phase** — if a deliverable has a structural gap, that's a `/gsd-phase` re-open against the affected phase.

---

## Resume context

When you `/clear` and start a fresh session, paste this:

> Read `.planning/MILESTONE-V2-UAT.md` and walk me through it step by step. Start with Step 1.

I'll have full context from the brief alone — no need to re-explain the milestone.
