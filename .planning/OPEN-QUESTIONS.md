# Open questions register: dydx-delivery v2.0 → v2.x build sequence

**Register date:** 2026-05-10
**Branch / commit:** dydx-delivery-v2 / (record current commit at synthesis plan)
**Phase 1 Audit (v0.3.0 ground truth):** `.planning/AUDIT.md` (approved 2026-05-09)
**Phase 2 Design (v2 architecture ground truth):** `.planning/DESIGN.md` (approved 2026-05-10)
**Phase 3 Change list (v2.x build sequence):** `.planning/CHANGELIST.md` (approved 2026-05-10)

> **Reading conventions.** This register catalogues every research-flagged "couldn't verify" + design-decision-deferred item across the v2.0 design milestone. Each row carries a closed 9-field schema per D-47 (OPEN-QN / Question / Source citations / Owning phase / Verification owner / Severity / Resolution path / Proposed default / Status). Severity is one of `BLOCKER | GUARDRAIL | INFORMATIONAL` per D-48. Resolution path is one of `/gsd-research-phase <N>` / `decide-before-Phase-<N>` / `Coda-template-authoring (Phase 8)` / `policy-pending-sign-off` / `live-workstream-pointer` per D-49. Citation format is `` `path:line` `` per D-14 carried (verifiable via `grep -n` and the citation-validity full pass at Appendix C). Source-merging follows D-50 (single canonical row per dedup-on-Question-text; multi-source citation list per row). Reconciliation algorithm result lives in Appendix C — every row maps 1:1 to Appendix B traceability + has Owning phase + has >= 1 verifiable citation. Owning phase is single-owner only (`Phase [1-9]|TBD`) per cross-AI review C6.
>
> **Reviewer flow.** Read-in-order (Executive Summary → OPEN-01..07 → Appendices) for the full backlog argument; OR skip-to-contract via the Severity rollup (BLOCKER first), Owning-phase rollup (per-phase view), or Resolution-path rollup (research-blocked vs decide-before vs policy vs Coda-template vs live-workstream). v2.x build phases consume their assigned rows by `grep`-ing on the row's owning-phase field for their phase number.

## Executive Summary

**Severity rollup.**

| Severity | Count | Notes |
|---|---|---|
| BLOCKER | 3 | OPEN-Q01..Q03 native-AI ingestion APIs (Pipefy AI KB / Wrike AI Studio / Ziflow ReviewAI); all Phase 7 owner. Plan-phase for Phase 7 refuses to start while these are open. D-37 contingent fallback applies (slide P8/P9 → v2.7 if unresolved at v2.5 kickoff). |
| GUARDRAIL | 4 | Pipefy GraphQL pagination cursor (Q04 / Phase 7) / Ziflow read-after-create consistency (Q05 / Phase 2) / Coda MCP wired (Q10 / Phase 1) / Google Workspace MCP server choice (Q11 / Phase 1). Resolved during owning phase but does not halt plan-creation. |
| INFORMATIONAL | 18 | Pipefy/Wrike rate-limit splits (Q06.1/Q06.2 + Q07.1/Q07.2 post-cross-AI-C6) / Miro export endpoint (Q08) / Claude in Chrome naming (Q09) / Miro MCP wired (Q12) / Wrike host field source-of-truth (Q13) / risk-multiplier defaults (Q14) / frontmatter migration cutover (Q15) / status-lifecycle survey (Q16) / hub-link backfill (Q17) / Coda templates (Q18..Q20) / `/refine-<skill>` resolution + namespace (Q21 / Q21.1) / plugin self-test scope (Q22). Documented for awareness; recommended default acceptable. |

**Owning-phase rollup** (single-owner only per cross-AI review C6 — no hybrid `Phase 1/Phase 2` row):

| Phase | Count | Sample questions |
|---|---|---|
| Phase 1 | 12 | Coda MCP wired (Q10) / Google Workspace MCP server (Q11) / hub-link backfill (Q17) / frontmatter migration cutover (Q15) / status-lifecycle survey (Q16) / `/refine-<skill>` resolution (Q21) + namespace (Q21.1) / Pipefy 2026 rate-limit publication (Q06.1) / Wrike 2026 rate-limit publication (Q07.1) / Miro MCP wired (Q12) / Wrike host field (Q13) / Claude in Chrome naming (Q09) |
| Phase 2 | 3 | Ziflow read-after-create consistency (Q05) / Pipefy throttle calibration (Q06.2) / Wrike throttle calibration (Q07.2) |
| Phase 3 | 1 | Miro export-whole-board endpoint (Q08) |
| Phase 4 | 1 | Risk-multiplier defaults pending dYdX-historical (Q14) |
| Phase 7 | 4 | Pipefy AI KB (Q01) / Wrike AI Studio (Q02) / Ziflow ReviewAI (Q03) / Pipefy GraphQL pagination cursor (Q04) |
| Phase 8 | 3 | Coda templates: brain-mirror (Q18) / task-table (Q19) / `00_HUB.md` schema (Q20) |
| Phase 9 | 1 | Plugin self-test scope (Q22) |

**Resolution-path rollup** (5 enum values per D-49 — full coverage at Wave 4):

| Path | Count | Notes |
|---|---|---|
| /gsd-research-phase <N> | 15 | OPEN-01 + OPEN-02 research-flagged items; resolved by `/gsd-research-phase` invocation against owning phase |
| decide-before-Phase-<N> | 3 | OPEN-Q14 (Phase 4) / OPEN-Q15 + OPEN-Q16 (Phase 1) design-decision-deferred items |
| Coda-template-authoring (Phase 8) | 3 | OPEN-Q18 / OPEN-Q19 / OPEN-Q20 Coda templates authored during Phase 8 build |
| policy-pending-sign-off | 3 | OPEN-Q21 + OPEN-Q21.1 `/refine-<skill>` resolution + namespace; OPEN-Q22 plugin self-test scope |
| live-workstream-pointer | 1 | OPEN-Q17 hub-link backfill (Jason's parallel workstream tracker) |

## How to read this register

**Document purpose.** This register catalogues every "couldn't verify" item from research + every design-decision-deferred item across the v2.0 design milestone. Owning phases are assigned per `.planning/CHANGELIST.md` CHANGE-01 sequence; v2.x build phases consume their assigned rows as their resolution backlog. Approval of this register signals milestone-design-complete; v2.1 milestone definition can begin afterward.

**Reading conventions.** Each H2 (`OPEN-01..07`) corresponds 1:1 to a `.planning/REQUIREMENTS.md` requirement ID. Each register row uses the closed 9-field schema per D-47. Closed enums per D-48 (severity), D-49 (resolution path), D-47 (status), and tightened single-owner per cross-AI review C6 (owning phase = `Phase [1-9]|TBD` only) are structurally checked by `.planning/phases/04-open-questions/scripts/openquestions-structure-check.sh`. Citations use `` `path:line` `` format per D-14 — verifiable via `grep -n` AND the full citation-validity pass run at Appendix C reconciliation (cross-AI C5). Source merging follows D-50 (single canonical row per dedup-on-Question-text; multi-source citation list).

**Reviewer flow.** Two paths through this document. **Read-in-order** (Executive Summary → OPEN-01..07 → Appendices) gives the full backlog argument with severity reasoning. **Skip-to-contract** uses the Executive Summary as a TOC: Severity rollup (Table 1) for BLOCKER-first scanning; Owning-phase rollup (Table 2) for per-v2.x-phase planning; Resolution-path rollup (Table 3) for research-vs-decide-vs-policy-vs-Coda-vs-workstream classification. v2.x build phases find their assigned backlog by grepping the per-row owning-phase field for their phase number (e.g., `grep -B1 'Phase 1' OPEN-QUESTIONS.md` from the row context). Appendix A is the "what does my phase own?" lookup; Appendix B is the "where did this question come from?" traceability lookup (sorted numerically by OPEN-QNN per cross-AI G2); Appendix C is the reconciliation proof (REAL multiset comparison per cross-AI C3 + ROADMAP SC 1-5 walk + full citation-validity pass per cross-AI C5).

**Source-of-truth pointers.** Phase 1 Audit (v0.3.0 ground truth) → `.planning/AUDIT.md`. Phase 2 Design (v2 architecture) → `.planning/DESIGN.md`. Phase 3 Change list (v2.x sequence) → `.planning/CHANGELIST.md`. Requirements → `.planning/REQUIREMENTS.md` § "Open questions register (OPEN-QUESTIONS.md)" (OPEN-01..07 verbatim). Roadmap success criteria → `.planning/ROADMAP.md` Phase 4 section. Pitfalls → `.planning/research/PITFALLS.md` (CRIT/MOD/MIN families). Research summary → `.planning/research/SUMMARY.md` § Phase Ordering Rationale (Phase 1 + Phase 7 research-blocked detail).

**Phase boundary.** This is the terminal phase of the v2.0 Implementor Edition milestone (design-only mandate per kickoff; no skill files edited). Approval of this register = milestone-design-complete; v2.1+ build milestones inherit it as the resolution backlog. v2.x build phases resolve their assigned BLOCKER rows BEFORE locking plans (per D-48); GUARDRAIL rows are resolved DURING the owning phase (warning, not halt); INFORMATIONAL rows ship with the recommended default unless explicit override.

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

This section catalogues the policy decision on `/refine-<skill>` resolution per REQUIREMENTS.md OPEN-06. Per D-52 carried, both rows in this section use `Resolution path: policy-pending-sign-off` (Jason approves the recommended default; no further work needed beyond an acceptance signal). The recommended default is lifted verbatim from REQUIREMENTS.md OPEN-06: build single parameterised command (option a); namespace `/dydx-refine-<skill>` (plugin-prefixed; avoids clash). Each row's Proposed-default field embeds the D-52 sub-fields (Decision deadline / Acceptance signal / Fallback-if-undecided) in markdown-list form. The namespace sub-decision is emitted as decimal-ID OPEN-Q21.1 (per cross-AI C2 decimal-ID-aware regex in structural-check A4/A10/A14).

**OPEN-Q21** — `/refine-<skill>` resolution: build-single-parameterised-command vs delete-orphan-references

- Question: Should the v0.3.0 `/refine-<skill>` orphan references be (a) collapsed into a single parameterised `commands/refine.md` per DESIGN-05 carried, OR (b) deleted entirely (no refine workflow shipped)?
- Source citations: `.planning/REQUIREMENTS.md:95`, `.planning/DESIGN.md:132`, `.planning/AUDIT.md:287`
- Owning phase: Phase 1
- Verification owner: Phase 1 / Jason
- Severity: INFORMATIONAL
- Resolution path: policy-pending-sign-off
- Proposed default:
  - **Recommendation:** "build single parameterised command" (option a) per `.planning/REQUIREMENTS.md:95` OPEN-06 verbatim — collapses the 3 orphan references catalogued in `.planning/AUDIT.md:287` § 4.2 into a single parameterised `commands/refine.md` per DESIGN-05 (`.planning/DESIGN.md:132`).
  - **Decision deadline:** before Phase 1 plan-phase locks Foundations build (v2.1).
  - **Acceptance signal:** Jason explicit go-ahead in chat or commit message ("approved" or equivalent — same pattern as Phase approval gates).
  - **Fallback-if-undecided:** v2.1 ships with `/refine-<skill>` orphan references intact but undocumented (option c — punt); revisit at v2.2 kickoff.
- Status: proposed

**OPEN-Q21.1** — `/refine-<skill>` namespace decision (sub-row; only relevant if OPEN-Q21 = build)

- Question: If OPEN-Q21 = build (option a), what is the canonical command namespace — `/dydx-refine-<skill>` (plugin-prefixed; recommended) OR `/refine-<skill>` (unprefixed; risks clash with other plugins)?
- Source citations: `.planning/REQUIREMENTS.md:95`, `.planning/DESIGN.md:132`, `.planning/DESIGN.md:139`
- Owning phase: Phase 1
- Verification owner: Phase 1 / Jason
- Severity: INFORMATIONAL
- Resolution path: policy-pending-sign-off
- Proposed default:
  - **Recommendation:** `/dydx-refine-<skill>` (plugin-prefixed; avoids clash with other plugins' `/refine-*` commands) per CONTEXT.md D-52 + DESIGN-05 namespace lock at `.planning/DESIGN.md:139` ("Namespace: `/dydx-refine-*` (NOT bare `/refine-*` — D-23)").
  - **Decision deadline:** before Phase 1 plan-phase locks Foundations build (v2.1).
  - **Acceptance signal:** Jason explicit go-ahead in chat or commit message.
  - **Fallback-if-undecided:** unprefixed `/refine-<skill>`; revisit if clash detected post-ship.
  - **Conditional:** only relevant if OPEN-Q21 = build; if OPEN-Q21 = delete, this row is superseded.
- Status: proposed

## OPEN-07: Plugin self-test scope

This section catalogues the policy decision on plugin self-test scope per REQUIREMENTS.md OPEN-07. Per D-52 carried, the row uses `Resolution path: policy-pending-sign-off` (Jason approves recommended default). The recommended default is lifted verbatim from REQUIREMENTS.md OPEN-07: smoke tests for hooks + frontmatter validator via `pytest` on the plugin's own correctness; owning phase = Phase 9 (Surfaces) per CHANGE-04. The Proposed-default field embeds the D-52 sub-fields (Decision deadline / Acceptance signal / Fallback-if-undecided) in markdown-list form.

> **Cross-reference:** This row (OPEN-Q22) is the canonical home for plugin self-test scope. OPEN-03 (REQUIREMENTS.md OPEN-03 4th sub-item — `plugin self-test scope (smoke tests for hooks + frontmatter validator vs none)` mention) cross-references here per D-50 source-merging discipline (single canonical row; multi-source citation).

**OPEN-Q22** — Plugin self-test scope: smoke tests vs defer

- Question: Should v2.1 ship with plugin self-tests (smoke tests for hooks + frontmatter validator via `pytest` on the plugin's own correctness, target `dydx-delivery/tests/`) OR defer (v2.1 ships without self-tests; revisit at v2.2)?
- Source citations: `.planning/REQUIREMENTS.md:96`, `.planning/DESIGN.md:122`, `.planning/CHANGELIST.md:160`
- Owning phase: Phase 9
- Verification owner: Phase 9 / dev
- Severity: INFORMATIONAL
- Resolution path: policy-pending-sign-off
- Proposed default:
  - **Recommendation:** "smoke tests for hooks + frontmatter validator via `pytest` on the plugin's own correctness" (recommended; pytest at `dydx-delivery/tests/` per DESIGN-04 carried at `.planning/DESIGN.md:122`). Owning phase = Phase 9 (Surfaces) per CHANGE-04 (CHANGELIST.md Phase 9 mini-table Deliverables item g at `.planning/CHANGELIST.md:160`).
  - **Decision deadline:** before Phase 9 plan-phase locks Surfaces build (v2.6).
  - **Acceptance signal:** Jason explicit go-ahead in chat or commit message ("approved" or equivalent — same pattern as Phase approval gates).
  - **Fallback-if-undecided:** v2.1 ships without self-tests; revisit at v2.2 kickoff.
- Status: proposed

---

## Appendix A: Per-phase rollup index

This index lets a v2.x build phase look up the rows it owns. One row per v2.x phase that owns ≥ 1 question; single-owner only per cross-AI review C6 (no hybrid `Phase 1/Phase 2` row — the historic hybrid rate-limit rows were split into Q06.1/Q06.2 and Q07.1/Q07.2).

| Phase | Question IDs (OPEN-QNN) | BLOCKER count | GUARDRAIL count | INFORMATIONAL count |
|---|---|---|---|---|
| Phase 1 | OPEN-Q06.1, OPEN-Q07.1, OPEN-Q09, OPEN-Q10, OPEN-Q11, OPEN-Q12, OPEN-Q13, OPEN-Q15, OPEN-Q16, OPEN-Q17, OPEN-Q21, OPEN-Q21.1 | 0 | 2 | 10 |
| Phase 2 | OPEN-Q05, OPEN-Q06.2, OPEN-Q07.2 | 0 | 1 | 2 |
| Phase 3 | OPEN-Q08 | 0 | 0 | 1 |
| Phase 4 | OPEN-Q14 | 0 | 0 | 1 |
| Phase 7 | OPEN-Q01, OPEN-Q02, OPEN-Q03, OPEN-Q04 | 3 | 1 | 0 |
| Phase 8 | OPEN-Q18, OPEN-Q19, OPEN-Q20 | 0 | 0 | 3 |
| Phase 9 | OPEN-Q22 | 0 | 0 | 1 |

Total: 25 register rows = 3 BLOCKER + 4 GUARDRAIL + 18 INFORMATIONAL across 7 single-owner phases.

## Appendix B: Source traceability

One row per register row; 1:1 cardinality with register-total (25 rows) per D-53; SORTED NUMERICALLY by OPEN-QNN per cross-AI G2 (sort key: numeric prefix, then decimal portion — Q06 < Q06.1 < Q06.2 < Q07 < Q07.1 < Q07.2 < Q08 < ... < Q21 < Q21.1 < Q22). Citations lifted verbatim from each register row's Source citations field.

| OPEN-QN | Source citations |
|---|---|
| OPEN-Q01 | `.planning/REQUIREMENTS.md:90`, `.planning/CHANGELIST.md:284`, `.planning/DESIGN.md:410` |
| OPEN-Q02 | `.planning/REQUIREMENTS.md:90`, `.planning/CHANGELIST.md:280`, `.planning/DESIGN.md:455` |
| OPEN-Q03 | `.planning/REQUIREMENTS.md:90`, `.planning/CHANGELIST.md:281`, `.planning/DESIGN.md:496` |
| OPEN-Q04 | `.planning/CHANGELIST.md:279`, `.planning/DESIGN.md:440` |
| OPEN-Q05 | `.planning/CHANGELIST.md:282`, `.planning/DESIGN.md:523` |
| OPEN-Q06.1 | `.planning/CHANGELIST.md:277`, `.planning/DESIGN.md:442` |
| OPEN-Q06.2 | `.planning/CHANGELIST.md:277`, `.planning/DESIGN.md:442`, `.planning/DESIGN.md:795` |
| OPEN-Q07.1 | `.planning/CHANGELIST.md:278`, `.planning/DESIGN.md:483` |
| OPEN-Q07.2 | `.planning/CHANGELIST.md:278`, `.planning/DESIGN.md:483`, `.planning/DESIGN.md:795` |
| OPEN-Q08 | `.planning/REQUIREMENTS.md:90`, `.planning/AUDIT.md:241` |
| OPEN-Q09 | `.planning/REQUIREMENTS.md:90`, `.planning/AUDIT.md:266` |
| OPEN-Q10 | `.planning/REQUIREMENTS.md:91`, `.planning/AUDIT.md:543`, `.planning/DESIGN.md:795` |
| OPEN-Q11 | `.planning/REQUIREMENTS.md:91`, `.planning/AUDIT.md:543` |
| OPEN-Q12 | `.planning/REQUIREMENTS.md:91`, `.planning/AUDIT.md:543` |
| OPEN-Q13 | `.planning/REQUIREMENTS.md:91`, `.planning/DESIGN.md:455`, `.planning/AUDIT.md:233` |
| OPEN-Q14 | `.planning/REQUIREMENTS.md:92`, `.planning/CHANGELIST.md:283`, `.planning/DESIGN.md:795` |
| OPEN-Q15 | `.planning/REQUIREMENTS.md:92`, `.planning/DESIGN.md:181`, `.planning/CHANGELIST.md:260` |
| OPEN-Q16 | `.planning/REQUIREMENTS.md:92`, `.planning/DESIGN.md:270`, `.planning/AUDIT.md:38` |
| OPEN-Q17 | `.planning/REQUIREMENTS.md:93`, `.planning/DESIGN.md:619`, `.planning/research/PITFALLS.md:201` |
| OPEN-Q18 | `.planning/REQUIREMENTS.md:94`, `.planning/DESIGN.md:1072`, `.planning/DESIGN.md:1122` |
| OPEN-Q19 | `.planning/REQUIREMENTS.md:94`, `.planning/DESIGN.md:795` |
| OPEN-Q20 | `.planning/REQUIREMENTS.md:94`, `.planning/DESIGN.md:795` |
| OPEN-Q21 | `.planning/REQUIREMENTS.md:95`, `.planning/DESIGN.md:132`, `.planning/AUDIT.md:287` |
| OPEN-Q21.1 | `.planning/REQUIREMENTS.md:95`, `.planning/DESIGN.md:132`, `.planning/DESIGN.md:139` |
| OPEN-Q22 | `.planning/REQUIREMENTS.md:96`, `.planning/DESIGN.md:122`, `.planning/CHANGELIST.md:160` |

## Appendix C: Reconciliation algorithm result

(Populated by 04-05-PLAN.md / Wave 5 synthesis. Terminal-state proof block: INPUT_COUNT_AFTER_DEDUP / REGISTER_ROW_COUNT / CARDINALITY_MATCH=TRUE / ALL_CITATIONS_VERIFIED=TRUE / ALL_OWNERS_ASSIGNED=TRUE. Reproduces Phase 2 02-10 / Phase 3 03-07 reconciliation precedent — REAL multiset comparison per cross-AI C3, NOT assumed equality.)

---

*Open questions register produced 2026-05-10; catalogues every "couldn't verify" + "needs human decision" item across `.planning/AUDIT.md` (v0.3.0 ground truth) → `.planning/DESIGN.md` (v2 architecture) → `.planning/CHANGELIST.md` (v2.x sequence). Owning phases assigned per CHANGELIST.md CHANGE-01 sequence; v2.x build phases inherit assigned rows as their resolution backlog.*
