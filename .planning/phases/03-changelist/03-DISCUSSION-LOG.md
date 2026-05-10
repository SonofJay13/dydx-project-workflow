# Phase 3: Change list - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in `03-CONTEXT.md` — this log preserves the alternatives considered and the user's selection rationale.

**Date:** 2026-05-10
**Phase:** 3-changelist
**Areas discussed:** Milestone-sizing (CHANGE-01); Document structure (top-level H2 shape); 9-phase plan presentation depth; Per-skill delta presentation (CHANGE-02 → Appendix A)

---

## Pre-discussion: gray-area selection

Eight gray areas were identified during analysis. The user was offered the top 4 (highest impact) for explicit discussion; the lower 4 (cosmetic-fix treatment, research-blocked flag visibility, migration cutover treatment, skill-delta tagging granularity) were resolved by Claude defaults documented in `03-CONTEXT.md` § Implementation Decisions and surfaced under "Claude default — auto-applied" markers per decision (D-40 through D-43).

**User selected (multiSelect):** all 4 offered → milestone-sizing, document structure, 9-phase plan depth, per-skill delta presentation.

---

## Milestone-sizing call (CHANGE-01) — D-37

| Option | Description | Selected |
|--------|-------------|----------|
| Example bundling from CHANGE-01 | 6 milestones: v2.1=P1+P2; v2.2=P3; v2.3=P4; v2.4=P5; v2.5=P6+P7; v2.6=P8+P9. Caveat sentence: 'user may re-bundle at start of any v2.x kickoff'. | ✓ |
| One phase = one milestone | Most granular: v2.1=P1, v2.2=P2 ... v2.9=P9. Smallest releases, most kickoff/UAT overhead, fastest individual ship. Best if research-blocked phases (P1, P7) might shift sequencing. | |
| Bigger chunks (4 milestones) | Larger-grain: v2.1=P1+P2+P3; v2.2=P4+P5; v2.3=P6+P7; v2.4=P8+P9. Fewer kickoffs, longer cycles, larger blast radius per ship. | |
| Defer milestone-sizing entirely | CHANGELIST.md presents the 9 phases without bundling; milestone groupings get decided at start of each post-v2.0 milestone. | |

**User's choice:** Example bundling from CHANGE-01 (Recommended).
**Notes:** User selected the preview verbatim, including the OPEN-01 contingent fallback ("If OPEN-01 unresolved at v2.5 start, split P6 → v2.5 / P7 → v2.6, slide"). Both the re-bundling caveat AND the OPEN-01 fallback are mandatory verbatim sentences in CHANGELIST.md per D-37.

---

## Document structure (top-level H2 shape) — D-36

| Option | Description | Selected |
|--------|-------------|----------|
| Hybrid — 9-phase backbone + appendices | 9-phase plan is the spine; CHANGE-02..05 deliverables become Appendix A..D; Appendix E for closed `[OPEN]` marker list. Optimised for "what's in v2.X ship?" reader query. | ✓ |
| 5 H2 sections matching CHANGE-01..05 | Maintains authoring continuity with AUDIT.md (8 H2s matching AUDIT-01..08). Reviewer maps requirement → section trivially. Per-skill delta becomes its own peer section. | |
| Reader-narrative (no requirement-IDs in H2) | Optimised for outside-reader / new-team-member onboarding. Section names tell a story; CHANGE-N IDs cited inline only. Friendliest read; weakest traceability. | |

**User's choice:** Hybrid — 9-phase backbone + appendices (Recommended).
**Notes:** User selected the preview which locked the full 16-H2 list (Executive Summary; How to read; Phase 1..9 with milestone tags inline; Appendix A..E). Phase 7's H2 carries `[BLOCKED — see Appendix C]` inline so a casual scan surfaces the only at-risk phase.

---

## 9-phase plan presentation depth — D-38

| Option | Description | Selected |
|--------|-------------|----------|
| H3 + mini-table per attribute | Each phase = H3 + brief narrative paragraph (rationale only) + 5-row mini-table (deliverables / depends-on / addresses REQ-IDs / avoids pitfalls / skills introduced+modified). Best skim-and-deep-dive balance; matches matrix-then-prose pattern (D-11/D-12 from Phase 1). | ✓ |
| Free-form narrative + bold-key labels (ROADMAP.md-shape) | Each phase = H3 + paragraphs with bold-key inline labels. Matches ROADMAP.md authoring shape exactly; no tables. Easier to author, denser to scan. | |
| Single 9-row master table + H3 rationale callouts only | One master table at top with 9 rows × 6 columns. H3 sections under it carry only the ordering-rationale narrative + risk callouts. Densest; good for at-a-glance. | |

**User's choice:** H3 + mini-table per attribute (Recommended).
**Notes:** User accepted the 6-row mini-table shape (deliverables / depends-on / addresses / avoids pitfalls / skills introduced/modified / research-blocked). Narrative paragraph is bounded — *ordering rationale only*. Source for ordering rationale: `.planning/research/SUMMARY.md` § "Phase Ordering Rationale".

---

## Per-skill delta presentation (CHANGE-02 → Appendix A) — D-39

| Option | Description | Selected |
|--------|-------------|----------|
| Single matrix — one row per v2 skill | 13 rows (one per v2 skill), columns: v0.3.0 origin / v2 name / status / change description / introducing phase / DESIGN-NN anchor. RETIRED-AND-REPLACED skills get a footnote row tying old→new mapping. Single source-of-truth. | ✓ |
| Status-grouped sub-tables (mirrors AUDIT-07 by-severity layout) | Four sub-tables under Appendix A: NEW / MODIFIED / RETIRED-AND-REPLACED / UNCHANGED. Easier to count 'how many net-new'; harder to find a specific skill. | |
| Two tables — v0.3.0 transitions + net-new | Table 1 = the 7 v0.3.0 skills with status. Table 2 = the net-new v2 skills with introducing phase. Mid-density; reader sees 'what happens to existing stuff' separately from 'what's new'. | |

**User's choice:** Single matrix — one row per v2 skill (Recommended).
**Notes:** User accepted the matrix preview which lays out the matrix ordering by introducing milestone (v2.1 first → v2.6 last), with status enum `NEW / NEW (split) / MODIFIED / RETIRED / RETIRED → SPLIT / UNCHANGED`. Required count totals at the bottom of Appendix A; mismatch indicates a missing or duplicated row.

---

## Claude's Discretion (auto-applied; not surfaced to user but documented in CONTEXT.md)

The 4 lower-priority gray areas resolved by strongest default — see `03-CONTEXT.md` § Implementation Decisions for full rationale:

- **D-40** — Skill-delta tagging granularity: cited bullets in the Change column with `(per DESIGN-NN)` cite.
- **D-41** — Cosmetic-fix list (Appendix B): verbatim lift from `.planning/AUDIT.md` § AUDIT-07 with per-bullet sentinel preserved (single-source-of-truth discipline; no drift risk).
- **D-42** — Research-blocked flag (Appendix C): both inline `⚠` markers in 9-phase mini-tables AND dedicated Appendix C with full unknown-list per blocked phase + recommended `/gsd-research-phase` invocation.
- **D-43** — Migration cutover (Appendix D): citation header pointing to DESIGN-08 / D-25 as authoritative + reader-friendly numbered checklist (5-7 rules from D-25).

Plus the standard Claude's-discretion items inside each decision (internal ordering, exact wording, callout placement, etc.) — see `03-CONTEXT.md` § Implementation Decisions § "Claude's Discretion".

---

## Deferred Ideas

No new deferrals discovered during the discussion. All deferred items were inherited from Phase 1 / Phase 2 deferred lists or from REQUIREMENTS.md OPEN-01..07 — see `03-CONTEXT.md` § Deferred Ideas for the full list with placement guidance for inline `[OPEN]` markers and Appendix E entries.
