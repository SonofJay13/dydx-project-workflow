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

This section catalogues every research-flagged "couldn't verify" item surfaced from `.planning/research/SUMMARY.md` § Phase Ordering Rationale + `.planning/CHANGELIST.md` Appendix C (research-blocked phases) + `.planning/DESIGN.md` § "Deferred to Phase 4 OPEN-QUESTIONS". Three rows are HARD BLOCKER (native-AI ingestion APIs per platform — Pipefy AI KB / Wrike AI Studio / Ziflow ReviewAI; all Phase 7 owner per CHANGE-04). The remaining items are GUARDRAIL or INFORMATIONAL (resolved during owning phase but do not halt plan-creation). Per cross-AI review C6, the historic hybrid-owner rate-limit rows are split into single-owner pairs (Pipefy → Q06.1 Phase 1 + Q06.2 Phase 2; Wrike → Q07.1 Phase 1 + Q07.2 Phase 2) so both phase consumers grep their concern independently. **D-37 OPEN-01 contingent fallback (verbatim — carried from `.planning/CHANGELIST.md` § Phase 7 / Appendix E):** If OPEN-01 (native-AI ingestion paths per platform) remains unresolved at v2.5 kickoff, split P6 → v2.5 (Documentation only) and P7 → v2.6 (Native-AI when unblocked); slide P8/P9 → v2.7. Phase 7 is the only blocked-by-OPEN phase; isolating it preserves cadence on the rest.

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

**OPEN-Q06.1** — Pipefy 2026 rate-limit publication (cross-AI C6 split: Phase 1 publication research)

- Question: Has Pipefy published a 2026 rate-limit revision, or does the historic ~5 req/sec per token ceiling still apply?
- Source citations: `.planning/CHANGELIST.md:277`, `.planning/DESIGN.md:442`
- Owning phase: Phase 1
- Verification owner: Phase 1 / dev
- Severity: INFORMATIONAL
- Resolution path: /gsd-research-phase 1
- Proposed default: documented historic ceiling ~5 req/sec per token (per CHANGELIST.md Appendix E verbatim) until Phase 1 connector-validity research surfaces a 2026 revision.
- Status: proposed

**OPEN-Q06.2** — Pipefy 2026 rate-limit consumer-throttle calibration (cross-AI C6 split: Phase 2 helper implementation)

- Question: Given the Phase 1 published-rate-limit answer (Q06.1), what is the calibrated consumer throttle value the platform-pipefy helpers should enforce?
- Source citations: `.planning/CHANGELIST.md:277`, `.planning/DESIGN.md:442`, `.planning/DESIGN.md:795`
- Owning phase: Phase 2
- Verification owner: Phase 2 / dev
- Severity: INFORMATIONAL
- Resolution path: /gsd-research-phase 2
- Proposed default: helpers throttle at 4 req/sec (80% of historic ceiling — locked by DESIGN-22 carried throttle pattern at `.planning/DESIGN.md:795`) pending Q06.1 confirmation. Cross-references Q06.1.
- Status: proposed

**OPEN-Q07.1** — Wrike 2026 rate-limit publication (cross-AI C6 split: Phase 1 publication research)

- Question: Has Wrike published a 2026 rate-limit revision, or does the historic ~100 req/min per user still apply?
- Source citations: `.planning/CHANGELIST.md:278`, `.planning/DESIGN.md:483`
- Owning phase: Phase 1
- Verification owner: Phase 1 / dev
- Severity: INFORMATIONAL
- Resolution path: /gsd-research-phase 1
- Proposed default: documented historic ~100 req/min per user (per CHANGELIST.md Appendix E verbatim) until Phase 1 connector-validity research surfaces a 2026 revision.
- Status: proposed

**OPEN-Q07.2** — Wrike 2026 rate-limit consumer-throttle calibration (cross-AI C6 split: Phase 2 helper implementation)

- Question: Given the Phase 1 published-rate-limit answer (Q07.1), what is the calibrated consumer throttle value the platform-wrike helpers should enforce?
- Source citations: `.planning/CHANGELIST.md:278`, `.planning/DESIGN.md:483`, `.planning/DESIGN.md:795`
- Owning phase: Phase 2
- Verification owner: Phase 2 / dev
- Severity: INFORMATIONAL
- Resolution path: /gsd-research-phase 2
- Proposed default: helpers throttle at 80% of confirmed published ceiling per DESIGN-22 carried throttle pattern (`.planning/DESIGN.md:795`); pending Q07.1 confirmation. Cross-references Q07.1.
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

This section catalogues connector-availability uncertainties surfaced from `.planning/AUDIT.md` § AUDIT-08 (live MCP probe in this workspace) and `.planning/REQUIREMENTS.md` OPEN-02. Every row is owned by Phase 1 (Foundations + Connector Verification per CHANGELIST.md CHANGE-01) — Phase 1 connector probe is the resolution path for all rows in this section. Severity is GUARDRAIL when missing wiring blocks a downstream stage (Coda / Google Workspace) and INFORMATIONAL when a documented fallback exists (Miro paste-only).

**OPEN-Q10** — Coda MCP wired in this workspace at canonical version pin?

- Question: Is Coda MCP wired in this workspace, at what version pin, and does the wiring carry the live-edit + table-rows-manage capabilities Stage 6 + Stage 11 require?
- Source citations: `.planning/REQUIREMENTS.md:91`, `.planning/AUDIT.md:543`, `.planning/DESIGN.md:795`
- Owning phase: Phase 1
- Verification owner: Phase 1 / dev
- Severity: GUARDRAIL
- Resolution path: /gsd-research-phase 1
- Proposed default: assume Coda MCP wired (AUDIT-08 records present-and-working as of probe date `2026-05-09T17:05Z` per `.planning/AUDIT.md:543`); Phase 1 connector probe re-confirms version pin + capability-set at v2.1 kickoff. If absent: Stage 6 cost estimate Coda mirror writes degrade to manual-paste fallback.
- Status: proposed

**OPEN-Q11** — Google Workspace MCP wired (which server)?

- Question: Is Google Workspace MCP wired in this workspace, and which specific server (`taylorwilsdon` vs `piotr-agier` vs Anthropic-maintained)? Different servers expose different tool surfaces (Drive read-vs-write; Gmail send vs read-only; Calendar event-create vs read).
- Source citations: `.planning/REQUIREMENTS.md:91`, `.planning/AUDIT.md:543`
- Owning phase: Phase 1
- Verification owner: Phase 1 / dev
- Severity: GUARDRAIL
- Resolution path: /gsd-research-phase 1
- Proposed default: confirm via `claude mcp list` plus per-MCP cheap-read probe at Phase 1 kickoff (mirroring the AUDIT-08 methodology at `.planning/AUDIT.md:543`). If absent: Stage 9 doc-publish degrades to manual-upload to Drive (graceful per MOD-1 prevention). *(Non-binding suggestion per cross-AI C8 — capturing the chosen server in `dydx-delivery/references/connectors.md` (FOUND-06) is recommended; Phase 1 owner finalises destination — this register does not own that destination.)*
- Status: proposed

**OPEN-Q12** — Miro MCP wired (or paste-only)?

- Question: Is Miro MCP wired in this workspace, or does the Stage 3 SOW capture flow rely on paste-from-screenshot?
- Source citations: `.planning/REQUIREMENTS.md:91`, `.planning/AUDIT.md:543`
- Owning phase: Phase 1
- Verification owner: Phase 1 / dev
- Severity: INFORMATIONAL
- Resolution path: /gsd-research-phase 1
- Proposed default: AUDIT-08 records Miro MCP wired and working at probe date (per `.planning/AUDIT.md:543` — `board_search_boards` returned 5 boards / total 920); paste-from-screenshot remains the documented fallback for clients without per-tenant Miro access. Stage 3 design must function without it.
- Status: proposed

**OPEN-Q13** — Wrike auth header / `host` field source-of-truth across multi-tenant deployments

- Question: Where is the per-tenant Wrike `host` field (returned from OAuth token exchange) persisted in this workspace's pattern, and is it the same source-of-truth Stage 7b will read from for `platform-wrike` API calls?
- Source citations: `.planning/REQUIREMENTS.md:91`, `.planning/DESIGN.md:455`, `.planning/AUDIT.md:233`
- Owning phase: Phase 1
- Verification owner: Phase 1 / dev
- Severity: INFORMATIONAL
- Resolution path: /gsd-research-phase 1
- Proposed default: persist `wrike_host` alongside `coda_brain_doc:` cache per DESIGN-15 carried (`.planning/DESIGN.md:455`). *(Non-binding suggestion per cross-AI C8 — exact storage location (e.g., `<Client> Brain/00_HUB.md` Coda block) is Phase 1 owner discretion; this register does not own that destination.)*
- Status: proposed

## OPEN-03: Design-decision-deferred items

This section catalogues design-decision-deferred items needing human input before the owning phase locks plans. Severity is INFORMATIONAL across all rows because each carries a Proposed-default that is shippable; resolution requires Jason's explicit acceptance signal (per D-49 `decide-before-Phase-<N>` enum value) within the named phase deadline. Plugin self-test scope (4th sub-item in `.planning/REQUIREMENTS.md` OPEN-03) is section-canonicalised under the `OPEN-07` H2 below per D-50 dedup discipline; cross-reference at end of this section.

**OPEN-Q14** — risk-multiplier defaults validated against dYdX historicals?

- Question: Are the default risk multipliers (L=1.1 / M=1.3 / H=1.6 — locked structure per DESIGN-22 carried) validated against dYdX historical project costs, or imported from generic delivery-estimate research?
- Source citations: `.planning/REQUIREMENTS.md:92`, `.planning/CHANGELIST.md:283`, `.planning/DESIGN.md:795`
- Owning phase: Phase 4
- Verification owner: Phase 4 / Jason
- Severity: INFORMATIONAL
- Resolution path: decide-before-Phase-4
- Proposed default: 1.1 / 1.3 / 1.6 (per DESIGN-22 carried structure-locked defaults at `.planning/DESIGN.md:795`). Decision-deadline: before Phase 4 plan-phase locks Stage 6 cost estimate plans.
- Status: proposed

**OPEN-Q15** — Frontmatter migration cutover date

- Question: When is the migration v0.3.0 → v2 frontmatter contract triggered? Is it tied to a specific v2.x ship date OR purely opt-in per change request (per DESIGN-08)?
- Source citations: `.planning/REQUIREMENTS.md:92`, `.planning/DESIGN.md:181`, `.planning/CHANGELIST.md:260`
- Owning phase: Phase 1
- Verification owner: Phase 1 / Jason
- Severity: INFORMATIONAL
- Resolution path: decide-before-Phase-1
- Proposed default: opt-in per CR (no global cutover) per DESIGN-08 + CHANGELIST.md Appendix D rule 2 (`.planning/CHANGELIST.md:260`); v2 readers tolerate v0.3.0 lenient mode permanently. No artefacts auto-flip on a calendar trigger.
- Status: proposed

**OPEN-Q16** — Status-lifecycle survey orphan check

- Question: Has the status-lifecycle survey confirmed no live `status:` value gets orphaned by the v2 lifecycle (`draft → client_review → approved → archived`)?
- Source citations: `.planning/REQUIREMENTS.md:92`, `.planning/DESIGN.md:270`, `.planning/AUDIT.md:38`
- Owning phase: Phase 1
- Verification owner: Phase 1 / Jason
- Severity: INFORMATIONAL
- Resolution path: decide-before-Phase-1
- Proposed default: per DESIGN-08 status-lifecycle survey (`.planning/DESIGN.md:270`) — sampled v0.3.0 sources show only `{draft, client_review, approved}`; `archived` is additive (Stage 11 write only); no live values orphaned. Phase 1 re-runs the survey at v2.1 kickoff to confirm no drift since 2026-05-10 sample date.
- Status: proposed

> **Plugin self-test scope** (REQUIREMENTS.md OPEN-03 4th sub-item) is section-canonicalised under the `OPEN-07` H2 anchor (Plugin self-test scope) per D-50 source-merging discipline. See OPEN-Q22 (assigned at Wave 4 / Plan 04-04).

## OPEN-04: Hub-link backfill rollout coordination

This section catalogues the rollout coordination invariant for the per-client hub-link backfill (the `Documentation:` Drive link in each `<Client> Brain/00_HUB.md`). Per D-51 (CONTEXT.md), Phase 4 does NOT enumerate clients in this register — that is a moving target on Jason's parallel workstream. The single canonical row records the invariant + pointer source-of-truth + proposed default verbatim from `.planning/REQUIREMENTS.md` OPEN-04. A sub-row may be added later when the live tracker source-of-truth materialises during v2.1 Foundations build kickoff.

**OPEN-Q17** — Hub-link backfill rollout coordination

- Question: Which clients have `<Client> Brain/00_HUB.md` carrying the `Documentation:` Drive link, and which need backfill before v2.x ship gates? Where is the live workstream tracker (Coda doc / shared spreadsheet / GitHub issue / TBD)?
- Source citations: `.planning/REQUIREMENTS.md:93`, `.planning/DESIGN.md:619`, `.planning/research/PITFALLS.md:201`
- Owning phase: Phase 1
- Verification owner: Phase 1 / Jason
- Severity: INFORMATIONAL
- Resolution path: live-workstream-pointer
- Proposed default: graceful halt at Stage 9 only — does not halt other stages, per MOD-1 prevention (verbatim from `.planning/REQUIREMENTS.md` OPEN-04). Pointer source-of-truth: live `00_HUB.md` files in client folders + Jason's parallel workstream tracker (location TBD; sub-row to be added when tracker materialises during v2.1 Foundations build kickoff per D-51). *(Non-binding suggestion per cross-AI C8 — tracker format/destination is Phase 1 owner discretion; this register does not own that destination.)*
- Status: proposed

**Sub-row reservation:** A second row (OPEN-Q17.1 or similar) may be added during v2.1 Foundations build kickoff to name the live workstream tracker source-of-truth (Coda doc / shared spreadsheet / GitHub issue / external URL). Phase 4 explicitly does NOT snapshot this because it is a moving target; D-51 carry-forward applies (pointer-only + invariant). The reconciliation algorithm in Plan 04-05 accommodates 1-row OR 2-row OPEN-04 cardinality cleanly.

## OPEN-05: Standard Coda templates v2 must author

This section catalogues the standard Coda templates v2 must author during Phase 8 (Sign-off + Coda mirror per CHANGELIST.md CHANGE-01). All rows owner=Phase 8; resolution=`Coda-template-authoring (Phase 8)` per D-49 enum. Severity is INFORMATIONAL across — defaults are author-as-built; no row halts plan creation in any earlier phase. Templates are emitted into `dydx-delivery/skills/sign-off-and-archive/references/` per DESIGN-26/27 carried. Templates do not exist in v0.3.0; this is a NEW Phase 8 deliverable.

**OPEN-Q18** — brain-mirror doc Coda template (section-per-spoke + Field Notes table)

- Question: What is the canonical Coda doc template structure for the per-client brain mirror — section-per-spoke layout (one section per stage spoke), Field Notes table schema (input-only per DESIGN-27), and approval-watermark field shape?
- Source citations: `.planning/REQUIREMENTS.md:94`, `.planning/DESIGN.md:1072`, `.planning/DESIGN.md:1122`
- Owning phase: Phase 8
- Verification owner: Phase 8 / non-dev
- Severity: INFORMATIONAL
- Resolution path: Coda-template-authoring (Phase 8)
- Proposed default: author-as-built during Phase 8 Sign-off + Coda mirror skill build; section-per-spoke layout per DESIGN-26 carried (`.planning/DESIGN.md:1072`); Field Notes table is input-only (read-by-skill, never written-by-skill) per DESIGN-27 carried (`.planning/DESIGN.md:1122`).
- Status: proposed

**OPEN-Q19** — task-table Coda template (column names + types + keyColumns upsert key)

- Question: What is the canonical Coda task-table schema (column names + types + `keyColumns` upsert key)? How does the plugin auto-introspect the existing schema for clients with a pre-existing task table?
- Source citations: `.planning/REQUIREMENTS.md:94`, `.planning/DESIGN.md:795`
- Owning phase: Phase 8
- Verification owner: Phase 8 / non-dev
- Severity: INFORMATIONAL
- Resolution path: Coda-template-authoring (Phase 8)
- Proposed default: author-as-built during Phase 8; `keyColumns` = (client_slug, project_slug, task_slug) triple per DESIGN-22 carried (`.planning/DESIGN.md:795`); plugin schema-introspection cached in `00_HUB.md` Coda block per DESIGN-22 (cross-reference OPEN-Q20).
- Status: proposed

**OPEN-Q20** — Default `00_HUB.md` Coda block schema

- Question: What is the canonical `00_HUB.md` Coda block YAML schema (`coda_brain_doc:` / `coda_tasks_table:` / `coda_tasks_schema:` cache)?
- Source citations: `.planning/REQUIREMENTS.md:94`, `.planning/DESIGN.md:795`
- Owning phase: Phase 8
- Verification owner: Phase 8 / non-dev
- Severity: INFORMATIONAL
- Resolution path: Coda-template-authoring (Phase 8)
- Proposed default: author-as-built during Phase 8; YAML keys per DESIGN-22 carried (`.planning/DESIGN.md:795`); defines the persistent Stage 6 ↔ Stage 11 contract — Stage 6 cost-estimate writes the schema cache, Stage 11 sign-off-and-archive reads it on every brain-mirror push.
- Status: proposed

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
