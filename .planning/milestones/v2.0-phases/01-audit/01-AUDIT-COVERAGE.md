# Phase 1 Audit — Reviewer Coverage Checklist

**Created:** 2026-05-09
**Companion to:** `.planning/AUDIT.md`
**Purpose:** Reviewer punch-list for the Phase 1 approval gate. Each ROADMAP success criterion (1–5) is mapped to the AUDIT.md section(s) that satisfy it. Reviewer ticks each box after spot-checking the cited section.

---

## Success criterion 1 — Per-skill inventory complete

> "AUDIT.md exists at .planning/AUDIT.md and catalogues every v0.3.0 skill (`discovery-intake`, `generate-sow`, `generate-functional-spec`, `generate-technical-spec`, `generate-test-plan`, `generate-build-prompt`, `execute-tests`) with purpose, inputs, outputs, hand-off contract, dependencies, observed brittleness, and what's missing for v2 — readable as a self-contained reference without consulting the v0.3.0 source files."

- [ ] AUDIT.md §AUDIT-01 — open with the 7-row skill matrix (one row per skill)
- [ ] AUDIT.md §AUDIT-01 — 7 H3 subsections (`### 1.1` through `### 1.7`) with Hand-off contract / Observed brittleness / What's missing for v2 mini-headers
- [ ] AUDIT.md §AUDIT-01 — every brittleness bullet cited in `file:line` form
- [ ] AUDIT.md §AUDIT-01 — every "What's missing for v2" points at a DESIGN-* requirement (no design move proposed)

---

## Success criterion 2 — Verified superset of CONCERNS.md

> "AUDIT.md is a verified superset of `.planning/codebase/CONCERNS.md` (every existing entry absorbed) and adds any new structural issues found during the audit pass; auditor confirms in the document that no CONCERNS.md entry was dropped silently."

- [ ] AUDIT.md §AUDIT-02 — explicit "verified superset of" / canonical sentinel `**All CONCERNS.md sections absorbed; zero entries dropped silently.**` / running-prose form `all 15 sections absorbed`
- [ ] AUDIT.md §Appendix B — row-per-CONCERNS.md-section trace table; one numeric-indexed row per actual `^## ` heading in CONCERNS.md (15 rows; assertion #7 requires >= 14)
- [ ] AUDIT.md §Appendix B closing summary — "All 15 sections absorbed" + named [NEW] findings (4.6 / 5.5 / 7.6 / Slack in 8)
- [ ] **Reviewer spot-check:** Pick 3 CONCERNS.md entries; confirm each is rewritten in its AUDIT-* destination with original `file:line` preserved

---

## Success criterion 3 — Per-stage connector deps + live MCP probe

> "AUDIT.md contains a per-stage connector dependency table...marking each connector required vs graceful-degradation per stage, AND a live-wiring probe table recording present-and-working / present-but-broken / missing for each MCP in this workspace with version pins where present."

- [ ] AUDIT.md §AUDIT-03 — 7-stage × 9-connector dependency matrix with `REQUIRED` / `optional (graceful)` / `(none)` / `(referenced in artefact only)` cells
- [ ] AUDIT.md §AUDIT-03 — research-derived fallback hint sub-table with explicit DESIGN-07 pointer
- [ ] AUDIT.md §AUDIT-08 — 5-row live MCP probe table with status / server identity / endpoint / probe call / result / version pin
- [ ] AUDIT.md §AUDIT-08 — Slack [NEW] row + 4-row verification-deferred sub-table
- [ ] AUDIT.md §AUDIT-08 — probe-time timestamp recorded
- [ ] **Reviewer spot-check:** Pick 3 probe rows; re-run the documented probe call against the live MCP; confirm status matches

---

## Success criterion 4 — Missing artefacts + duplicated content catalogued

> "AUDIT.md catalogues every referenced-but-missing artefact (`platform-pipefy`/`platform-wrike` skills, `/refine-<skill>` slash commands, workspace `hub.md`, client-folder `.env.example`) with exact citations from v0.3.0 docs, AND every duplicated content block...with a canonical-source recommendation per duplicate."

- [ ] AUDIT.md §AUDIT-04 — 5 missing-artefact subsections (4.1 platform skills; 4.2 /refine-<skill>; 4.3 hub.md; 4.4 .env.example; 4.5 commands/agents/hooks scaffold) + 4.6 verified-clean
- [ ] AUDIT.md §AUDIT-04 §4.1 — [BLOCKING] tag (3 downstream skills depend on platform-pipefy/wrike)
- [ ] AUDIT.md §AUDIT-05 — 4 duplicate-content categories (5.1 hard-rules; 5.2 start-at-any-point; 5.3 Cowork-vs-Claude-Code; 5.4 pipeline diagram) + 5.5 [NEW] Stage-6 label collision
- [ ] AUDIT.md §AUDIT-05 — every duplicate has a `**Canonical source:**` line
- [ ] AUDIT.md §AUDIT-05 §5.2 — all 6 start-at-any-point copies cited
- [ ] AUDIT.md §AUDIT-05 §5.1 — `safety-rules.md` named as canonical for hard-rules
- [ ] **Reviewer spot-check:** Pick one duplicate from §5.1–5.4; confirm canonical source resolves and the divergent copies are accurately cited

---

## Success criterion 5 — Version mismatches + cosmetic issues

> "AUDIT.md lists every version-string mismatch across `plugin.json`, `marketplace.json`, root README, plugin README and hardcoded version strings (recommending `2.0.0` as the synced target) AND flags every cosmetic-but-client-visible issue...with each cosmetic fix scheduled for v2.1 build, NOT this design milestone."

- [ ] AUDIT.md §AUDIT-06 — 8-row version-string-mismatch table
- [ ] AUDIT.md §AUDIT-06 — `2.0.0` recommended as synced target (per D-17)
- [ ] AUDIT.md §AUDIT-06 — FOUND-04 referenced as v2.1 build target
- [ ] AUDIT.md §AUDIT-07 — 6 cosmetic-fix subsections (7.1 README truncation; 7.2 "test sheet" residual; 7.3 pipeline-step count mismatch; 7.4 LICENSE; 7.5 owner-email; 7.6 [NEW] homepage asymmetry)
- [ ] AUDIT.md §AUDIT-07 — **every** cosmetic-fix bullet contains the canonical sentinel "Scheduled for v2.1 Foundations build (FOUND-NN), NOT this milestone." per D-16 (case-insensitive ERE `'scheduled for v2\.1 (foundations )?build'` matches >= 6 times in AUDIT-07)
- [ ] AUDIT.md §AUDIT-07 — the v2.1 sentinel does NOT appear outside AUDIT-07 (case-insensitive leakage check returns 0)

---

## Reviewer attestation

- [ ] All 5 ROADMAP success criteria met
- [ ] Manual spot-check of citations resolves (5 random `file:line` entries)
- [ ] Manual spot-check of MCP probe results matches a re-probe (3 random rows)
- [ ] No CONCERNS.md entry dropped silently (Appendix B trace verified exhaustive)
- [ ] Approve Phase 1 → Phase 2 (Design) may begin

**Reviewer attests:** ☐ All criteria met
**Reviewer name:** _____________
**Date:** _____________
