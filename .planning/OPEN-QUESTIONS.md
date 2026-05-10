# Open questions register: dydx-delivery v2.0 → v2.x build sequence

**Register date:** 2026-05-10
**Branch / commit:** dydx-delivery-v2 / (record current commit at synthesis plan)
**Phase 1 Audit (v0.3.0 ground truth):** `.planning/AUDIT.md` (approved 2026-05-09)
**Phase 2 Design (v2 architecture ground truth):** `.planning/DESIGN.md` (approved 2026-05-10)
**Phase 3 Change list (v2.x build sequence):** `.planning/CHANGELIST.md` (approved 2026-05-10)

> (Preamble placeholder — finalised in synthesis plan 04-05.)

## Executive Summary

(Executive summary 3-table placeholder — populated by 04-05-PLAN.md / Wave 5 synthesis. Severity rollup + Owning-phase rollup + Resolution-path rollup tables.)

## How to read this register

(Populated by 04-05-PLAN.md / Wave 5 synthesis. 5 bold-headed paragraphs.)

---

## OPEN-01: Research-flagged unverified items

This section catalogues every research-flagged "couldn't verify" item surfaced from `.planning/research/SUMMARY.md` § Phase Ordering Rationale + `.planning/CHANGELIST.md` Appendix C (research-blocked phases) + `.planning/DESIGN.md` § "Deferred to Phase 4 OPEN-QUESTIONS". Three rows are HARD BLOCKER (native-AI ingestion APIs per platform — Pipefy AI KB / Wrike AI Studio / Ziflow ReviewAI; all Phase 7 owner per CHANGE-04). The remaining items are GUARDRAIL or INFORMATIONAL (resolved during owning phase but do not halt plan-creation). Per cross-AI review C6, the historic hybrid-owner rate-limit rows are split into single-owner pairs (Pipefy → Q06a Phase 1 + Q06b Phase 2; Wrike → Q07a Phase 1 + Q07b Phase 2) so both phase consumers grep their concern independently. **D-37 OPEN-01 contingent fallback (verbatim — carried from `.planning/CHANGELIST.md` § Phase 7 / Appendix E):** If OPEN-01 (native-AI ingestion paths per platform) remains unresolved at v2.5 kickoff, split P6 → v2.5 (Documentation only) and P7 → v2.6 (Native-AI when unblocked); slide P8/P9 → v2.7. Phase 7 is the only blocked-by-OPEN phase; isolating it preserves cadence on the rest.

**OPEN-Q01** — Pipefy AI KB content-upload endpoint externally verifiable?

- Question: Is the Pipefy AI KB content-upload endpoint externally verifiable, and if so via which API call (REST vs GraphQL; sync vs async; what payload shape)?
- Source citations: `.planning/REQUIREMENTS.md:90`, `.planning/CHANGELIST.md:284`, `.planning/DESIGN.md:410`
- Owning phase: Phase 7
- Verification owner: Phase 7 / dev
- Severity: BLOCKER
- Resolution path: /gsd-research-phase 7
- Proposed default: none (per REQUIREMENTS.md OPEN-01 — paths must be externally verified before Phase 7 can lock plans).
- Status: open

**OPEN-Q02** — Wrike AI Studio knowledge-ingestion API externally verifiable?

- Question: Is the Wrike AI Studio knowledge-ingestion API externally verifiable, and if so via which endpoint (sync vs async; KB-scope vs skill-scope; rate-limit per ingest job)?
- Source citations: `.planning/REQUIREMENTS.md:90`, `.planning/CHANGELIST.md:280`, `.planning/DESIGN.md:455`
- Owning phase: Phase 7
- Verification owner: Phase 7 / dev
- Severity: BLOCKER
- Resolution path: /gsd-research-phase 7
- Proposed default: none.
- Status: open

**OPEN-Q03** — Ziflow ReviewAI knowledge-ingestion API externally verifiable?

- Question: Is the Ziflow ReviewAI knowledge-ingestion API (Checklists Public Preview) externally verifiable, and if so via which endpoint?
- Source citations: `.planning/REQUIREMENTS.md:90`, `.planning/CHANGELIST.md:281`, `.planning/DESIGN.md:496`
- Owning phase: Phase 7
- Verification owner: Phase 7 / dev
- Severity: BLOCKER
- Resolution path: /gsd-research-phase 7
- Proposed default: none.
- Status: open

**OPEN-Q04** — Pipefy GraphQL pagination cursor field names current?

- Question: Do Pipefy GraphQL pagination cursor field names in v0.3.0 helpers match the current 2026 schema (e.g., `pageInfo.hasNextPage` / `pageInfo.endCursor` vs renamed equivalents)?
- Source citations: `.planning/CHANGELIST.md:279`, `.planning/DESIGN.md:440`
- Owning phase: Phase 7
- Verification owner: Phase 7 / dev
- Severity: GUARDRAIL
- Resolution path: /gsd-research-phase 7
- Proposed default: assume documented historic field names; verify via live GraphQL introspection at Phase 7 kickoff (CHANGELIST.md Appendix E owner = Phase 7 per CHANGE-04 platform-pipefy build).
- Status: open

**OPEN-Q05** — Ziflow read-after-create consistency window

- Question: What is the actual read-after-create consistency window for Ziflow proof-create operations in 2026?
- Source citations: `.planning/CHANGELIST.md:282`, `.planning/DESIGN.md:523`
- Owning phase: Phase 2
- Verification owner: Phase 2 / dev
- Severity: GUARDRAIL
- Resolution path: /gsd-research-phase 2
- Proposed default: conservative — 30 second poll with 2s interval (per CHANGELIST.md Appendix E bullet verbatim recommendation).
- Status: proposed

**OPEN-Q06a** — Pipefy 2026 rate-limit publication (cross-AI C6 split: Phase 1 publication research)

- Question: Has Pipefy published a 2026 rate-limit revision, or does the historic ~5 req/sec per token ceiling still apply?
- Source citations: `.planning/CHANGELIST.md:277`, `.planning/DESIGN.md:442`
- Owning phase: Phase 1
- Verification owner: Phase 1 / dev
- Severity: INFORMATIONAL
- Resolution path: /gsd-research-phase 1
- Proposed default: documented historic ceiling ~5 req/sec per token (per CHANGELIST.md Appendix E verbatim) until Phase 1 connector-validity research surfaces a 2026 revision.
- Status: proposed

**OPEN-Q06b** — Pipefy 2026 rate-limit consumer-throttle calibration (cross-AI C6 split: Phase 2 helper implementation)

- Question: Given the Phase 1 published-rate-limit answer (Q06a), what is the calibrated consumer throttle value the platform-pipefy helpers should enforce?
- Source citations: `.planning/CHANGELIST.md:277`, `.planning/DESIGN.md:442`, `.planning/DESIGN.md:795`
- Owning phase: Phase 2
- Verification owner: Phase 2 / dev
- Severity: INFORMATIONAL
- Resolution path: /gsd-research-phase 2
- Proposed default: helpers throttle at 4 req/sec (80% of historic ceiling — locked by DESIGN-22 carried throttle pattern at `.planning/DESIGN.md:795`) pending Q06a confirmation. Cross-references Q06a.
- Status: proposed

**OPEN-Q07a** — Wrike 2026 rate-limit publication (cross-AI C6 split: Phase 1 publication research)

- Question: Has Wrike published a 2026 rate-limit revision, or does the historic ~100 req/min per user still apply?
- Source citations: `.planning/CHANGELIST.md:278`, `.planning/DESIGN.md:483`
- Owning phase: Phase 1
- Verification owner: Phase 1 / dev
- Severity: INFORMATIONAL
- Resolution path: /gsd-research-phase 1
- Proposed default: documented historic ~100 req/min per user (per CHANGELIST.md Appendix E verbatim) until Phase 1 connector-validity research surfaces a 2026 revision.
- Status: proposed

**OPEN-Q07b** — Wrike 2026 rate-limit consumer-throttle calibration (cross-AI C6 split: Phase 2 helper implementation)

- Question: Given the Phase 1 published-rate-limit answer (Q07a), what is the calibrated consumer throttle value the platform-wrike helpers should enforce?
- Source citations: `.planning/CHANGELIST.md:278`, `.planning/DESIGN.md:483`, `.planning/DESIGN.md:795`
- Owning phase: Phase 2
- Verification owner: Phase 2 / dev
- Severity: INFORMATIONAL
- Resolution path: /gsd-research-phase 2
- Proposed default: helpers throttle at 80% of confirmed published ceiling per DESIGN-22 carried throttle pattern (`.planning/DESIGN.md:795`); pending Q07a confirmation. Cross-references Q07a.
- Status: proposed

**OPEN-Q08** — Miro export-whole-board endpoint availability

- Question: Does Miro 2026 expose an export-whole-board endpoint usable from Stage 3 SOW capture, or does the workflow remain paste-from-screenshot?
- Source citations: `.planning/REQUIREMENTS.md:90`, `.planning/AUDIT.md:241`
- Owning phase: Phase 3
- Verification owner: Phase 3 / dev
- Severity: INFORMATIONAL
- Resolution path: /gsd-research-phase 3
- Proposed default: paste-from-screenshot remains the supported path; export-whole-board endpoint is opportunistic.
- Status: proposed

**OPEN-Q09** — Claude in Chrome canonical product naming

- Question: What is the canonical 2026 product name for Anthropic's browser-resident Claude (Claude in Chrome / Claude for Chrome / something else)?
- Source citations: `.planning/REQUIREMENTS.md:90`, `.planning/AUDIT.md:266`
- Owning phase: Phase 1
- Verification owner: Phase 1 / non-dev
- Severity: INFORMATIONAL
- Resolution path: /gsd-research-phase 1
- Proposed default: use whichever name appears canonically on https://claude.ai or the official Anthropic site at Phase 1 kickoff. *(Non-binding suggestion per cross-AI C8 — Phase 1 owner finalises whether to capture the resolution in `dydx-delivery/references/glossary.md` (FOUND-01) or elsewhere; this register does not own that destination.)*
- Status: proposed

## OPEN-02: Connector-availability uncertainties

(Populated by 04-02-PLAN.md / Wave 2. ~3-4 rows for connector probes — Coda MCP / Google Workspace MCP / Miro MCP / Wrike auth header. All Phase 1 owner; resolution = `/gsd-research-phase 1`.)

## OPEN-03: Design-decision-deferred items

(Populated by 04-03-PLAN.md / Wave 3. ~3-4 rows: risk-multiplier defaults / frontmatter migration cutover date / status-lifecycle survey / plugin self-test scope cross-link to OPEN-07.)

## OPEN-04: Hub-link backfill rollout coordination

(Populated by 04-03-PLAN.md / Wave 3. Single canonical row per D-51 — pointer-only + invariant.)

## OPEN-05: Standard Coda templates v2 must author

(Populated by 04-03-PLAN.md / Wave 3. ~3 rows: brain-mirror template / task-table template / 00_HUB.md Coda block schema. All Phase 8 owner; resolution = `Coda-template-authoring (Phase 8)`.)

## OPEN-06: /refine-<skill> resolution

(Populated by 04-04-PLAN.md / Wave 4. 1-2 rows: namespace decision + parameterised-vs-orphan-delete. Phase 1 deadline; resolution = `policy-pending-sign-off`.)

## OPEN-07: Plugin self-test scope

(Populated by 04-04-PLAN.md / Wave 4. 1 row: smoke tests scope. Phase 9 owner; resolution = `policy-pending-sign-off`.)

---

## Appendix A: Per-phase rollup index

(Populated by 04-05-PLAN.md / Wave 5 synthesis. `| Phase | Question IDs | BLOCKER | GUARDRAIL | INFORMATIONAL |` — one row per v2.x phase that owns >= 1 question.)

## Appendix B: Source traceability

(Populated by 04-05-PLAN.md / Wave 5 synthesis. `| OPEN-QN | Source citations |` — one row per register row; 1:1 cardinality with register-total per D-53. Sorted numerically by OPEN-QNN per cross-AI G2.)

## Appendix C: Reconciliation algorithm result

(Populated by 04-05-PLAN.md / Wave 5 synthesis. Terminal-state proof block: INPUT_COUNT_AFTER_DEDUP / REGISTER_ROW_COUNT / CARDINALITY_MATCH=TRUE / ALL_CITATIONS_VERIFIED=TRUE / ALL_OWNERS_ASSIGNED=TRUE. Reproduces Phase 2 02-10 / Phase 3 03-07 reconciliation precedent — REAL multiset comparison per cross-AI C3, NOT assumed equality.)

---

*Open questions register produced 2026-05-10; catalogues every "couldn't verify" + "needs human decision" item across `.planning/AUDIT.md` (v0.3.0 ground truth) → `.planning/DESIGN.md` (v2 architecture) → `.planning/CHANGELIST.md` (v2.x sequence). Owning phases assigned per CHANGELIST.md CHANGE-01 sequence; v2.x build phases inherit assigned rows as their resolution backlog.*
