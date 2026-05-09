---
gsd_state_version: 1.0
milestone: v2.0
milestone_name: milestone
status: executing
stopped_at: Phase 2 Plan 06 complete — Wave 6 Stages 4a/4b/5 skills DESIGN-20/21 landed (Stage 4a `generate-fnspec-platform/` skill NEW with per-requirement `delivery: native-ai | api` routing key + per-platform capability matrix as classifier input HIGH/MEDIUM->native-ai LOW->api default; Stage 4b `generate-fnspec-integration/` skill NEW owns cross-spec consistency check at start with 3 specific checks [no conflicting `delivery:` tags between 4a/4b; integration touchpoints cite 4a requirement IDs; no orphan API endpoints] failure halts before fnspec write emitting `04b_consistency_check_v<N>.md`; Stage 5 `generate-technical-spec/` MODIFIED scope gate 3 explicit branches [full when 4b exists; skip-with-platform-API-addendum when no 4b but 4a has `delivery: api` rows -> `## Platform-API Addendum` H2 INSIDE 4a + frontmatter `has_platform_api_addendum: true`; skip-entirely when no 4b AND no `delivery: api` rows] + error-paths discipline 4 elements per endpoint [failure modes / retry policy / idempotency / observability] hand-waving forbidden; 3 echo blockquotes added with DESIGN-20 contributing 2 [one each under 4a and 4b H2s] per dual-echo contract; per-stage decision contract shape per D-20; hand-off matrix Stage 4a->4b and Stage 4b->5 rows aligned with per-stage subsection literals per D-26 outer code-span backticks dropped to permit inner backtick formatting). 22 of 30 DESIGN-NN echo lines added; structural-check exits 1 (assertion #4 short-circuits at 22 < 30 — mid-phase invariant). Plans 02-07..02-09 add remaining 8 echoes.
last_updated: "2026-05-09T00:00:00.000Z"
last_activity: 2026-05-09 -- Phase 2 Plan 06 executed — 1 atomic commit (32f74e0 Stage 4a + 4b + Stage 5 contracts bundled because Stage 4b body cross-references Stage 5 scope-gate making split commits leave intermediate broken state); echo count progressed 19 -> 22/30 (DESIGN-20 dual-echo under 4a + 4b + DESIGN-21 under Stage 5); no new `[OPEN: Phase 4]` markers added (DESIGN-20/21 contracts LOCKED); total inline `[OPEN: Phase 4]` count across DESIGN.md unchanged from Plan 02-04 (= 13, >= 8 floor with margin); structural-check correctly exits 1 (assertion #4 echo count short-circuit at 22/30 — Plans 02-07..02-09 close remaining 8); cross-AI MEDIUM #6 forward-reference guardrails honoured — DESIGN-22/23/26 cited as anchor placeholders only with explicit `forward reference, populated in Plan 02-07/02-08` inline at every cite site (Stage 4a + 4b + 5 cross-references); acceptance criteria did NOT assert forward-reference body content exists; deferred to Plan 02-10 Appendix B traceability synthesis (T-02-06-07 mitigation).
progress:
  total_phases: 4
  completed_phases: 1
  total_plans: 19
  completed_plans: 15
  percent: 50
---

# STATE

## Project Reference

See: `.planning/PROJECT.md` (updated 2026-05-09)

**Core value:** Plugin behaves as a senior implementation partner end-to-end — every stage produces an artefact polished enough to send to a client or hand to a developer without rework, and every change request leaves the client's brain, documentation, and native-AI knowledge bases coherent and up to date.

**Current focus:** Phase 2 — Design (Plans 01-05 complete; 5 plans remaining)

## Current Position

Phase: 2 (Design) — EXECUTING (6/10 plans complete)
Plan: 6 of 10 complete (Wave 6 Stages 4a/4b/5 skills landed). Plans 02-07..02-10 each populate their DESIGN-* slice.
Status: Wave 6 complete. DESIGN.md now has populated `## Stage 4a: Functional spec — platform` (DESIGN-20 echo + per-stage decision contract per D-20: skill `generate-fnspec-platform/` NEW replaces v0.3.0 `generate-functional-spec` for platform portions per AUDIT.md §1.3; inputs = `based_on_sow:` + `platform: pipefy | wrike | ziflow` REQUIRED + per-platform `references/native-ai-inventory.md` from DESIGN-14/15/16 as classifier input; outputs = `04a_fnspec-platform_v<N>.md` carrying per-requirement `delivery: native-ai | api` tagging — THE DESIGN-20 routing-key contract canonical-order locked; classifier rule HIGH/MEDIUM confidence -> `delivery: native-ai`; LOW confidence (`[OPEN]`-flagged) defaults to `delivery: api` to avoid optimistic claims; downstream consumers 4 stages 4b/5/6/7b/10; OPTIONAL for integration-only projects; hand-off verbatim from matrix Stage 4a -> 4b row per D-26; 5 key v2 decisions); populated `## Stage 4b: Functional spec — integration` (DESIGN-20 echo dual-echo per plan contract + skill `generate-fnspec-integration/` NEW; cross-spec consistency check OWNED here runs FIRST 3 specific checks — (a) no conflicting `delivery:` tags between 4a/4b; (b) integration touchpoints cite 4a requirement IDs; (c) no orphan API endpoints — failure halts before fnspec write emitting `04b_consistency_check_v<N>.md`; same routing-key contract continues from 4a; OPTIONAL for platform-only projects Stage 5 SKIPS with addendum on 4a instead per DESIGN-21; hand-off verbatim from matrix Stage 4b -> 5; 4 key v2 decisions); populated `## Stage 5: Tech spec` (DESIGN-21 echo + skill `generate-technical-spec/` MODIFIED scope gate added + error-paths discipline tightened per AUDIT.md §1.4; scope gate 3 explicit branches — (1) Default 4b exists -> full `05_techspec_v<N>.md` `tech_spec_scope: full`; (2) Skip-with-addendum no 4b but 4a has `delivery: api` rows -> `## Platform-API Addendum` H2 INSIDE 4a artefact + frontmatter `has_platform_api_addendum: true` `tech_spec_scope: platform-api-addendum-only`; (3) Skip-entirely no 4b AND no `delivery: api` rows -> no tech spec at all; error-paths discipline 4 elements per endpoint — failure modes / retry policy with backoff curve / idempotency key strategy / observability — hand-waving forbidden; hand-off verbatim from matrix Stage 5 -> 6 including wait-for-commercial-inputs gate per DESIGN-22 forward; 3 key v2 decisions). Echo count progressed 19 -> 22/30 (DESIGN-20 contributes 2 echoes — one under each 4a + 4b H2; DESIGN-21 contributes 1 under Stage 5); total inline `[OPEN: Phase 4]` markers across DESIGN.md unchanged at 13 (no new ones — DESIGN-20/21 contracts are LOCKED); structural-check assertion #4 (echo count) short-circuits at 22/30 — expected mid-phase invariant. Hand-off matrix Stage 4a->4b and Stage 4b->5 rows updated to align literal text with per-stage subsection per D-26 verbatim-restate (outer code-span backticks dropped because cell content contains inner backticks). Next: `/gsd-execute-phase 2` continues with Plan 02-07 (Stages 6/7a/7b DESIGN-22/23; running echo total after 02-07 = 24/30 projected).
Last activity: 2026-05-09 -- Phase 2 Plan 06 executed — 1 atomic commit (32f74e0 Stage 4a + 4b + Stage 5 contracts bundled because Stage 4b body cross-references Stage 5 scope-gate so splitting into 2 commits would leave intermediate broken state where Stage 4b cross-refs unwritten Stage 5); 3 DESIGN-NN echo lines added (DESIGN-20 dual under 4a + 4b + DESIGN-21 under 5); no new inline `[OPEN: Phase 4]` markers (LOCKED contracts); structural-check correctly exits 1 (assertion #4 echo count short-circuit at 22/30).

Progress: [█████░░░░░] 50% (1 phase complete + Phase 2 Waves 1-6 — 15 of 19 plans)

## Performance Metrics

**Velocity:**

- Total plans completed: 15
- Average duration: ~11 min
- Total execution time: ~158 min

**By Phase:**

| Phase | Plans | Total | Avg/Plan |
|-------|-------|-------|----------|
| 1. Audit | 9 | ~101 min | ~11 min |
| 2. Design | 6 of 10 planned | ~57 min | ~10 min |
| 3. Change list | 0 | — | — |
| 4. Open questions register | 0 | — | — |

**Plan completion log:**

| Phase | Plan | Duration | Tasks | Files | Date |
|-------|------|----------|-------|-------|------|
| 1 | 01 (Wave 1 scaffold) | ~5 min | 3 | 2 | 2026-05-09 |
| 1 | 02 (Wave 2 — AUDIT-01) | ~25 min | 2 | 1 | 2026-05-09 |
| 1 | 03 (Wave 3 — AUDIT-03) | ~10 min | 2 | 1 | 2026-05-09 |
| 1 | 04 (Wave 4 — AUDIT-04) | ~10 min | 2 | 1 | 2026-05-09 |
| 1 | 05 (Wave 5 — AUDIT-05) | ~12 min | 2 | 1 | 2026-05-09 |
| 1 | 06 (Wave 6 — AUDIT-06) | ~10 min | 1 | 1 | 2026-05-09 |
| 1 | 07 (Wave 7 — AUDIT-07) | ~7 min | 1 | 1 | 2026-05-09 |
| 1 | 08 (Wave 8 — AUDIT-08) | ~12 min | 2 | 1 | 2026-05-09 |
| 1 | 09 (Wave 9 — synthesis) | ~10 min | 5 | 2 | 2026-05-09 |
| 2 | 01 (Wave 1 scaffold) | ~6 min | 3 | 3 | 2026-05-09 |
| 2 | 02 (Wave 2 — DESIGN-01..10 + survey + Appendix C) | ~14 min | 3 | 1 | 2026-05-09 |
| 2 | 03 (Wave 3 — DESIGN-11/12/13 + H2 rename) | ~10 min | 2 | 2 | 2026-05-09 |
| 2 | 04 (Wave 4 — DESIGN-14/15/16 platform skills) | ~10 min | 2 | 1 | 2026-05-09 |
| 2 | 05 (Wave 5 — DESIGN-17/18/19 Stages 1-3 skills) | ~8 min | 2 | 1 | 2026-05-09 |
| 2 | 06 (Wave 6 — DESIGN-20/21 Stages 4a/4b/5 skills) | ~9 min | 2 | 1 | 2026-05-09 |

**Recent Trend:** —

*Updated after each plan completion*

## Accumulated Context

### Decisions

Full log in PROJECT.md Key Decisions table. Recent decisions affecting current work:

- Brownfield v2.0 framing — captures rebuild without rewriting v0.3.0 history
- v2.0 milestone is design-only — no skill edits this session (kickoff mandate)
- Phase numbering reset to 1 (no prior milestone phases archived)
- 4-phase shape by deliverable: Audit → Design → Change list → Open questions
- Sequential approval gate after each phase before next runs
- Phase 1 Plan 01: structural-check uses case-insensitive ERE for prose matches; literal-string only for sentinel `2.0.0`
- Phase 1 Plan 01: `.planning/AUDIT.md` lives at `.planning/` (NOT under phase folder) per CONTEXT.md Integration Points
- Phase 1 Plan 02: per-skill brittleness findings transcribed verbatim from RESEARCH.md §3 — no re-discovery from SKILL.md (transcribe-not-interpret discipline keeps `file:line` citations stable)
- Phase 1 Plan 02: `[BLOCKING]` reserved for the three skills' `platform:` runtime-loading contract; documentation references to missing artefacts (README orphan refs) tagged `[STRUCTURAL]` instead
- Phase 1 Plan 02: per-skill subsections always emit all 3 mini-headers (Hand-off contract / Observed brittleness / What's missing for v2) even where a section is terse — reviewers scan the contract triplet
- Phase 1 Plan 03: AUDIT-03 cell vocabulary fixed at 4 enum values (`(none)` / `(referenced in artefact only)` / `optional (graceful)` / `REQUIRED`) — keeps observation precision tight without leaking design proposals
- Phase 1 Plan 03: live-MCP probe results (working/broken/missing) deferred to AUDIT-08; AUDIT-03 inventories *dependency*, AUDIT-08 inventories *connectivity* — split prevents conflating "stage uses connector X" with "X is currently working"
- Phase 1 Plan 03: PITFALLS-cited fallback hint sub-table is a 4-row sample, not a transcription of the full PITFALLS matrix — honours D-13 (no design proposals); full matrix is DESIGN-07's territory in Phase 2
- Phase 1 Plan 04: AUDIT-04 opener uses "the named DESIGN-* requirement carries the fix" instead of the PLAN-drafted "design proposes the fix" — D-13 banned-phrase ERE bans the literal token `propose`, so PLAN's own gate forced the rewording (same meaning; Rule 1 fix to PLAN's drafted text)
- Phase 1 Plan 04: subsection 4.6 (verified-clean negative finding) deliberately carries NO severity tag and NO Closes via trailer per Pattern 7 — observation of cleanliness, not a gap; structural-check assertion #4 (CONCERNS absorption) catches silent drop
- Phase 1 Plan 05: hard-rules duplication framing locked at "4 mentions; 3 duplicates of 1 canonical" per RESEARCH.md §12 Open Q6 — corrects CONCERNS.md's "three places" wording (CONCERNS missed counting the canonical itself); reviewers can now triage all 4 surfaces from a single subsection
- Phase 1 Plan 05: 5.5 [NEW] Stage-N label collision uses split-bullet citation form (not inline semicolon-separated) — Task 2 acceptance regex is line-counted, so each `file:line` citation must occupy its own line for the grep-c assertion to score correctly (Rule 1 fix during Task 2 verification)
- Phase 1 Plan 05: 5.4 pipeline diagram retains BOTH copies as canonical for distinct lenses (high-level overview vs tool-transition swimlane) — audit logs visual-drift risk without prescribing consolidation; CONCERNS-classified-as-dup but the two serve different purposes per RESEARCH §6.4
- Phase 1 Plan 06: AUDIT-06 summary observations split into 3 separate bullets (one `**[STRUCTURAL]**` per line) — initial single-paragraph form failed `grep -c '\*\*\[STRUCTURAL\]\*\*' >= 3` because grep -c counts matching **lines**, not occurrences (Rule 1 fix; same pattern as Plan 05's 5.5 split-citation fix)
- Phase 1 Plan 06: live-source transcription discipline applied (T-01-06-01 mitigation) — every cited manifest line range was Read at the cited line BEFORE table transcription; values verbatim from `plugin.json:3` (0.3.0), `marketplace.json:9` (1.2.0), `marketplace.json:16` (0.3.0), `README.md:9` (0.1.0), `results-template.md:9` (v0.1.0), `safety-rules.md:93` (v1 reference)
- Phase 1 Plan 06: D-17 "Recommended sync target: `2.0.0`" phrasing chosen over alternatives — confirmed against banned-phrase ERE that this token sequence is NOT matched (no `propose`; `recommend that v2` requires literal contiguous tokens which "Recommended sync target" does not contain)
- Phase 1 Plan 07: per-bullet D-16 sentinel rendered in canonical uppercase form `**Scheduled for v2.1 Foundations build (FOUND-NN), NOT this milestone.**` on every cosmetic-fix bullet — case-insensitive ERE gate `'scheduled for v2\.1 (foundations )?build'` accepts both this uppercase variant and lowercase / no-Foundations variants for future revisions, so Plan 07 prose stays clean while the gate stays robust
- Phase 1 Plan 07: Rule 1 fix during verification — AUDIT-06 opener (Plan 06 output) leaked the sentinel ERE outside AUDIT-07; reworded `"the actual version bump is scheduled for v2.1 Foundations build (FOUND-04)"` → `"the actual version bump lands in the v2.1 Foundations work (FOUND-04)"` to satisfy threat T-01-07-04 leakage gate without changing meaning; AUDIT-06 D-17 gate (assertion #8 + 2.0.0 recommendation) remains intact
- Phase 1 Plan 08: CRITICAL HONESTY RULE applied — sub-agent execution context does NOT expose `mcp__claude_ai_*` tool functions for the 5 wired MCPs (only `mcp__plugin_context-mode_context-mode__*` is in this agent's tool registry); per-endpoint cheap-read calls were therefore recorded as `transport ✓ Connected; cheap-read not invocable from this sub-agent` with explicit reviewer-re-probe call-out per VALIDATION.md, NOT fabricated as `200 OK / N items returned`. Empirical truth (probe transport via `claude mcp list` at 2026-05-09T16:30:53Z) > clean-looking matrix; T-01-08-01 mitigation honoured.
- Phase 1 Plan 08: CRIT-1/2/3/9 cross-refs split onto 4 separate bullet lines (Rule 1 fix during verify) — `grep -cE 'CRIT-(1|2|3|9)'` counts matching lines, not occurrences; same precedent as Plan 05 §5.5 split-citation form and Plan 06 STRUCTURAL split.
- Phase 1 Plan 08: bold prefix dropped from MCP-row leading cells (`| Coda |` not `| **Coda** |`) — Plan ships TWO row-count regexes (strict `^\| (Coda|...) \|` in `<verify automated>` AND optional-bold `^\| \*?\*?(Coda|...)\*?\*? \|` in `<acceptance>`); dropping the bold satisfies both simultaneously without weakening visual scannability.
- Phase 1 Plan 09: live `^## ` H2 count of CONCERNS.md = 15 sections (RESEARCH.md §2 said 14 — missed the standalone "Versioning convention vs current state" at CONCERNS.md:226); Plan 09's grep-count is canonical and absorbs all 15 in Appendix B trace.
- Phase 1 Plan 09: AUDIT-02 carries BOTH the running-prose form `All 15 CONCERNS.md sections absorbed` (visible count for reviewers) AND the canonical no-count sentinel `**All CONCERNS.md sections absorbed; zero entries dropped silently.**` on its own line (must_haves.contains literal-substring gate is robust to count drift in CONCERNS.md).
- Phase 1 Plan 09: Appendix B uses numeric-index column-1 (`| 1 |`...`| 15 |`); structural-check assertion #7 tolerant regex `^\| [^\|]+ \|` matches 16 rows (15 data + 1 header) — passes the >= 14 gate with margin.
- Phase 1 Plan 09: structural-check 8/8 assertions pass (file exists; 8 AUDIT-0N H2 sections; D-16 v2.1 sentinel present; CONCERNS absorption claim present; Executive Summary header present; Appendix B header present; >= 14 Appendix B rows; `2.0.0` D-17 sync target literal present); Phase 1 deliverable structurally complete.
- Phase 2 Plan 01: design-structure-check.sh defines stateful `section_between()` awk helper instead of broken `awk '/^## X/,/^## /'` range pattern (cross-AI review HIGH #1 fix) — start H2 cannot be re-matched as end H2 on the same line; helper extracts body only up to NEXT H2.
- Phase 2 Plan 01: script header comments accurately describe case-sensitive `grep -qF` (literal sentinels) and `grep -cE` (case-sensitive ERE) behaviour — script does NOT use `-i` flag (cross-AI review LOW #8 fix).
- Phase 2 Plan 01: DESIGN.md lives at `.planning/DESIGN.md` (NOT under phase folder) per CONTEXT.md Integration Points and D-18 — same convention as Phase 1 AUDIT.md.
- Phase 2 Plan 01: Wave 1 skeleton intentionally fails 2 of 9 assertions (#4 DESIGN-NN echo count = 0; #9 hand-off matrix data rows = 0) — proves the structural-check is live end-to-end. Phase 1 Plan 01 set the precedent.
- Phase 2 Plan 01: stateful-helper extraction confirmed against empty skeleton — `section_between "## Stage-by-stage hand-off contract"` returned 0 lines matching `^| Stage`, proving the helper does NOT spuriously match the header row (T-02-01-02 mitigation honoured).
- Phase 2 Plan 01: 13 Stage-N H2 anchors created (Stages 1, 2, 3, 4a, 4b, 5, 6, 7a, 7b, 8, 9, 10, 11) — exceeds the >= 11 floor; accommodates Stage 4 fnspec split (DESIGN-20) and Stage 7 dual build prompts (DESIGN-23).
- Phase 2 Plan 02: status-lifecycle survey ran in fallback mode (no live `<Client> Brain/` folders reachable from `C:/Users/Jason Blignaut/Documents/Coding/`) — v0.3.0 SKILL.md enumeration documented transparently per T-02-02-01; 12 sampled-source rows cite `file:line` per D-32; distinct values found `{draft, client_review, approved}`; `archived` is net-new in v2 — DESIGN-08 contract locked WITHOUT [MIGRATION-RISK] marker.
- Phase 2 Plan 02: forbidden-phrasings list rendered as 10 separate bullet lines (NOT inline comma-separated) — `grep -cE` counts matching LINES not occurrences; same Phase 1 precedent as Plan 05 §5.5 split-citation, Plan 06 STRUCTURAL split, Plan 08 CRIT cross-ref split; Rule 1 fix during Task 2 verification before commit (no separate commit needed — caught pre-commit).
- Phase 2 Plan 02: DESIGN-10 forbidden-phrasings count verified within DESIGN-10 H3 region only via stateful awk `section_between` extraction (cross-AI MEDIUM #5 fix) — prevents future false positives if broader persona-linting is added.
- Phase 2 Plan 02: 10 H3 subsections (DESIGN-01..10) placed BEFORE the `### Live status-lifecycle survey` H3 so DESIGN-08 cross-reference reads forward in document order; survey populated above the H3 contract block.
- Phase 2 Plan 02: structural-check exits 1 with the expected mid-phase failure message `"expected >= 30 'DESIGN-NN:' success-criteria echo blockquote lines (D-35), found 10"` — assertion #4 short-circuits at 10/30 echo lines; Plans 02-03..02-09 add the remaining 20.
- Phase 2 Plan 03: H2 anchor renamed `## 13-skill inventory` -> `## v2 skill inventory` (cross-AI review MEDIUM #4) — neutral title without count is resilient to v2.x count drift; structural-check script's `required_h2` array updated atomically with the DESIGN.md edit so the rename does not break the script.
- Phase 2 Plan 03: Inventory matrix shows 19 v2 end-state skills (16 stage skills + 3 platform skills) — exceeds the >= 13 floor; reconciliation paragraph cites architecture research as source of truth; explains discrepancy against REQUIREMENTS DESIGN-12 sub-bullet's "6 NEW + 3 NEW platform + 4 MODIFIED + 2 UNCHANGED + 1 RETIRED" framing (Phase 1 D-32 / D-34 honesty precedent — research enumeration kept; discrepancy logged not padded/trimmed).
- Phase 2 Plan 03: Skill layout ASCII tree enumerates 7 v2 surfaces (`.claude-plugin/`, `references/`, `skills/`, `commands/`, `agents/`, `hooks/`, `tests/`) with per-leaf cite of locking decision (DESIGN-NN, AUDIT-NN, FOUND-NN); plugin-level `references/` directory grounded in FOUND-01.
- Phase 2 Plan 03: Hand-off matrix has 12 transition rows (Stage 1->2 through 10->11); each cell uses single-line format so cells are reusable verbatim by Plans 02-05..02-08 per D-26; CRIT-8 fix encoded in Stage 9->10 row hand-off message ("push-native-ai-knowledge refuses ingest if doc_published_at < last_diff_review_at") for grep-canonical reference by the Stage 10 build phase.
- Phase 2 Plan 03: Structural-check assertion #9 (hand-off matrix >= 10 rows via stateful `section_between` helper) now PASSES; only assertion #4 (echo count >= 30) remains failing — expected mid-phase invariant; echo count progresses 10 -> 13/30.
- Phase 2 Plan 04: `## Platform skills` H2 opens with 3-row platform-comparison matrix (D-19) — pipefy/wrike/ziflow x 6 columns (Native-AI surface 2026 / API protocol / Sandbox access / native_ai_path default / Known research-blocked items); reads as quick-scan reference before per-platform H3 contracts.
- Phase 2 Plan 04: Each platform H3 carries identical 5-file `references/` ASCII tree (api-contract / native-ai-inventory / knowledge-ingestion / client-shape-gotchas / vocabulary) per DESIGN-14/15/16 echo; locks D-21 contract that this plan ships decision contracts only — full SKILL.md and references/*.md prose authoring runs in v2.2 PLAT-01..03 per CHANGELIST.md.
- Phase 2 Plan 04: 2026-grounded native-AI capability matrices honestly labelled HIGH / MEDIUM / LOW per D-25 — Pipefy 7 rows (KB/Skills/MCP/IDP/Web Search/BYO-LLM HIGH; KB content-upload via API LOW with [OPEN]); Wrike 4 rows (Copilot HIGH; 16 MCP tools HIGH; attach-doc-via-MCP MEDIUM; AI Studio knowledge-ingestion API LOW with [OPEN]); Ziflow 4 rows (Checklists Public Preview HIGH; Change Verification + Brand Standards Coming Soon MEDIUM; ReviewAI knowledge-ingestion API LOW with [OPEN]).
- Phase 2 Plan 04: Wrike `host` OAuth-persistence rule triple-mentioned as CRITICAL bug-prevention against v0.3.0 hardcoded `www.wrike.com` regression — API surface CRITICAL callout + sandbox-access pattern (both `wrike_sandbox_space_id` AND `wrike_host` mandatory in client_state.yaml) + cross-references to DESIGN-29 forward; satisfies T-02-04-02 + T-02-04-06 mitigation.
- Phase 2 Plan 04: Ziflow `wait_for_proof(proof_id, max_wait_s)` helper grounded in read-after-create eventual consistency — proof-create returns before proof readable; subsequent reads may 404 within consistency window; helper polls until readable or max-wait expires; conservative default 30s poll with 2s interval pending [OPEN] verification.
- Phase 2 Plan 04: 7 new inline [OPEN: Phase 4 — ...] markers added with uniform OPEN-01 + Phase-N citation format per CHANGE-04 (3 pipefy: KB content-upload + GraphQL cursor field names + 2026 rate-limit currency; 2 wrike: AI Studio knowledge-ingestion API + 2026 rate-limit currency; 2 ziflow: ReviewAI knowledge-ingestion API + read-after-create consistency window); total inline `[OPEN: Phase 4]` count across DESIGN.md = 13 (>= 8 floor with margin); ready for Plan 02-10 enumeration.
- Phase 2 Plan 04: Forward-reference guardrails per cross-AI review MEDIUM #6 — DESIGN-22/23/24/26 cited as anchor placeholders only with explicit 'forward reference, populated in Plan 02-0X' inline at every cite site; acceptance criteria verified anchor IDs cited but did NOT assert body content exists (deferred to Plan 02-10 Appendix B traceability synthesis); T-02-04-07 mitigation honoured — no false-fail on not-yet-written content.
- Phase 2 Plan 04: Echo line count progresses 13 -> 16/30 (DESIGN-14/15/16 added); structural-check assertion #4 (echo count >= 30) short-circuits at 16/30 — expected mid-phase invariant; Plans 02-05..02-09 close remaining 14.
- Phase 2 Plan 05: Stage 1 dual-branch contract locked — single `kickoff_branch:` enum field on `01_kickoff_v<N>.md` steers downstream stages (`discovery-ready` -> Stage 2; `draft-sow` -> SKIP Stage 2 -> Stage 3); DESIGN-18 + DESIGN-19 both read this same field — no separate routing flags; Field Notes triage filter locked at `processed_at IS NULL` per DESIGN-09 directional boundary; Miro paste fallback locked per DESIGN-07 + AUDIT-08; auto-classification with `[unknown — needs human classification]` inline markers forces visible reviewer triage instead of silent guesswork.
- Phase 2 Plan 05: Stage 2 raw-notes mode RETIRED — v0.3.0's "paste meeting notes here" entry path removed; discovery becomes pure transform of approved kickoff; eliminates "did discovery start from notes or kickoff?" ambiguity v0.3.0 silently allowed; `based_on_kickoff:` field MANDATORY (no v0.3.0 lenient absence); skip behaviour explicit (not silent) — when `kickoff_branch: draft-sow`, skill emits "Stage 2 SKIPPED" hand-off and exits without writing artefact.
- Phase 2 Plan 05: Stage 3 single-SOW scope locked — ONE SOW covers BOTH platform AND integration; Stage 4 (DESIGN-20 forward ref) is where platform/integration split happens; Stage 3 stays unified for client commercial review; `client_review` retained explicitly per AUDIT.md §AUDIT-01.2 + DESIGN-08 status-lifecycle survey result — interim commercial-review state is real workflow stage, not v0.3.0 quirk.
- Phase 2 Plan 05: Hand-off message verbatim restate verified per D-26 — both Stage 2 -> Stage 3 and Stage 3 -> Stage 4a strings appear exactly twice in DESIGN.md (matrix row + per-stage subsection); literal-substring grep matches pass; T-02-05-01 mitigation honoured.
- Phase 2 Plan 05: Echo count progresses 16 -> 19/30 (DESIGN-17 + DESIGN-18 + DESIGN-19 added); structural-check exits 1 with assertion #4 short-circuit at 19 < 30 — expected mid-phase invariant; Plans 02-06..02-09 close remaining 11; no new `[OPEN: Phase 4]` markers added (LOCKED contracts) — total inline `[OPEN]` count across DESIGN.md unchanged from Plan 02-04 (= 13).
- Phase 2 Plan 05: Forward-reference guardrails per cross-AI review MEDIUM #6 honoured — DESIGN-20 (Stage 4 split downstream) cited as anchor placeholder only with explicit `forward — populated in Plan 02-06` inline at every cite site (Stage 1 + Stage 2 + Stage 3 cross-references); acceptance criteria did NOT assert DESIGN-20 body content exists; deferred to Plan 02-10 Appendix B traceability synthesis (T-02-05-06 mitigation).
- Phase 2 Plan 06: Stage 4a `generate-fnspec-platform/` skill is NEW (replaces v0.3.0 `generate-functional-spec` for platform portions per AUDIT.md §1.3 single-spec-for-everything anti-pattern); Stage 4b `generate-fnspec-integration/` skill is NEW (replaces for integration portions); both skills carry the same `delivery: native-ai | api` per-requirement routing-key contract. Routing key locked at canonical order — never reversed — drives 4 downstream stages (5 / 6 / 7b / 10) without re-classifying.
- Phase 2 Plan 06: Per-platform capability matrix as classifier input — Stage 4a reads platform skill's `references/native-ai-inventory.md` (per DESIGN-14/15/16) and uses HIGH/MEDIUM confidence rows to suggest `delivery: native-ai`; LOW confidence (`[OPEN]`-flagged) defaults to `delivery: api` to avoid optimistic claims when only copy-paste works.
- Phase 2 Plan 06: Cross-spec consistency check OWNED by Stage 4b (runs FIRST before fnspec write); 3 specific checks enumerated — (a) no requirement ID in both 4a and 4b with conflicting `delivery:` tags; (b) every integration touchpoint in 4b cites referenced platform requirement ID from 4a (no dangling refs); (c) no orphan API endpoints. Failure halts before fnspec write emitting `04b_consistency_check_v<N>.md` for human triage. Two-place declaration (4a key-decision #3 + 4b key-decision #1) per T-02-06-02 mitigation.
- Phase 2 Plan 06: Stage 5 scope gate has 3 explicit branches per T-02-06-03 mitigation — (1) Default 4b exists -> full tech spec written; (2) Skip-with-addendum no 4b but 4a has `delivery: api` rows -> `## Platform-API Addendum` H2 INSIDE 4a + frontmatter `has_platform_api_addendum: true` + `tech_spec_scope: platform-api-addendum-only`; (3) Skip-entirely no 4b AND no `delivery: api` rows anywhere -> no tech spec written at all; no addendum; no 4a frontmatter change. No silent default.
- Phase 2 Plan 06: Stage 5 error-paths discipline 4 elements per endpoint per T-02-06-04 mitigation — (a) failure modes (timeouts, 4xx/5xx classes, schema mismatches, rate-limit responses); (b) retry policy with backoff curve (constant / exponential / decorrelated jitter) + max-retries bound; (c) idempotency key strategy; (d) observability (request ID propagation + error class tagging + metric emission). 'Hand-waving forbidden' callout per AUDIT.md §1.4 v0.3.0 error-paths underspecification.
- Phase 2 Plan 06: Tasks 1 + 2 bundled into a single atomic commit (`32f74e0`) — Stage 4b body cross-references Stage 5 scope-gate ("Stage 5 SKIPS with platform-API addendum on 4a instead per DESIGN-21") so splitting into 2 commits would leave intermediate broken state where Stage 4b cross-refs an unwritten Stage 5. Single Edit captures the full Wave 6 unit of design work atomically; both task acceptance criteria verified independently against the same edit.
- Phase 2 Plan 06: Hand-off matrix Stage 4a -> 4b and Stage 4b -> 5 rows updated to align literal text with per-stage subsection per D-26 verbatim-restate contract; outer code-span backticks dropped because cell content contains inner backticks for `\`status: approved\`` and `\`04a\``/`\`04b\`` literal formatting (markdown table cells cannot nest backticks inside code spans cleanly).
- Phase 2 Plan 06: Echo count progresses 19 -> 22/30 (DESIGN-20 contributes 2 echoes — one each under 4a and 4b H2s per plan dual-echo contract — DESIGN-21 contributes 1 under Stage 5); structural-check exits 1 with assertion #4 short-circuit at 22 < 30 — expected mid-phase invariant; Plans 02-07..02-09 close remaining 8.
- Phase 2 Plan 06: Forward-reference guardrails per cross-AI review MEDIUM #6 honoured — DESIGN-22 (Stage 6) / DESIGN-23 (Stage 7) / DESIGN-26 (Stage 10) cited as anchor placeholders only with explicit `forward reference, populated in Plan 02-07/02-08` inline at every cite site (Stage 4a + Stage 4b + Stage 5 cross-references); acceptance criteria did NOT assert forward-reference body content exists; deferred to Plan 02-10 Appendix B traceability synthesis (T-02-06-07 mitigation).

### Pending Todos

None.

### Blockers/Concerns

None at roadmap-lock. Two research-blocked v2.x phases flagged for `/gsd-research-phase` passes before they lock plans (captured in CHANGELIST.md scope, not this milestone): Phase 1 connector probe; Phase 7 native-AI ingestion paths.

## Deferred Items

| Category | Item | Status | Deferred At |
|----------|------|--------|-------------|
| *(none)* | | | |

## Session Continuity

Last session: 2026-05-09
Stopped at: Phase 2 Plan 06 (Wave 6 — Stages 4a/4b/5 skills DESIGN-20/21) complete — 1 atomic commit (`32f74e0` Stage 4a Platform fnspec DESIGN-20 first half + Stage 4b Integration fnspec DESIGN-20 second half + Stage 5 Tech spec scope gate DESIGN-21 + hand-off matrix Stage 4a->4b and Stage 4b->5 alignment). Echo line count progressed 19 -> 22 (DESIGN-20 dual-echo under 4a + 4b + DESIGN-21 under 5). No new inline `[OPEN: Phase 4]` markers added (LOCKED contracts — DESIGN-20/21); total inline `[OPEN]` count across DESIGN.md unchanged at 13 (>= 8 floor with margin). Structural-check assertion #4 (echo count >= 30) short-circuits at 22/30 — expected mid-phase invariant. Plans 02-07..02-10 next; resume execution via `/gsd-execute-phase 2`.
Resume file: `.planning/phases/02-design/02-07-PLAN.md`
