---
phase: 8
phase_name: Stage 4 Fnspec Split + ROUTE (incl. TD-2 inline)
audit_date: 2026-05-11
asvs_level: 1
threats_total: 12
threats_closed: 10
threats_open: 0
threats_accepted: 2
register_authored_at_plan_time: true
final_verdict: SECURED
verified_via: phase8-structure-check.sh --all (32 assertions PASS, exit 0)
---

# Phase 8 — Security Threat Verification

## Summary

Phase 8 is a documentation/skill-content phase. No new network endpoints, auth paths, database access, or trust-boundary changes were introduced. The attack surface is **content integrity only** — the SKILL.md / template / glossary / DESIGN.md content must remain canonical (no enum reversal, no token drift, no contract regression). All mitigations are structural assertions enforced by `.planning/phases/08-stage-4-fnspec-split-route/scripts/phase8-structure-check.sh`. Final `--all` run: **32/32 PASS, exit 0**.

## Threat Register

### Plan 08-01 — Stage 4a fnspec-platform (5 declared threats)

| ID | Category (STRIDE) | Component | Disposition | Status | Mitigation / Evidence |
|----|-------------------|-----------|-------------|--------|------------------------|
| T-08-01 | Tampering / Info Disclosure (content integrity) | 4a SKILL.md + template `platform:` enum drift | mitigate | CLOSED | P4 assertion (`phase8-structure-check.sh:82-86`) — `grep -qF 'pipefy \| wrike \| ziflow \| other'` in 4a SKILL.md (line 14, 16, 23) AND `fnspec-platform-template.md`. T-gate PASS. |
| T-08-02 | Tampering (canonical-order lock regression / STG4-04) | 4a SKILL.md reversed-enum literal `api \| native-ai` | mitigate | CLOSED | P5 assertion (`phase8-structure-check.sh:88-94`) — `! grep -qF 'api \| native-ai'` in 4a SKILL.md. 0 occurrences confirmed. Rule-1 auto-fix in 08-01 commit `8a213d3`. T-gate PASS. |
| T-08-03 | Tampering (re-run preservation token drift) | `[reviewer-override:]` token in 4a artefacts | mitigate | CLOSED | Literal documentation across 4 files: 4a SKILL.md (6), `fnspec-platform-template.md` (6), `addendum-template.md` (1), `auto-classify-rubric.md` (6) — 19 occurrences total. Verified via grep on `dydx-delivery/skills/generate-fnspec-platform/`. |
| T-08-04 | Tampering (D-79 contract field rename) | `has_platform_api_addendum` + `tech_spec_scope` frontmatter | mitigate | CLOSED | P8 assertion (`phase8-structure-check.sh:106-111`) — both tokens present in 4a SKILL.md (9 occurrences combined). T-gate PASS. |
| T-08-05 | Tampering / Path traversal | Reviewer-supplied artefact write paths (`<Client> Brain/<Project>/04a_*.md`) | **accept** | ACCEPTED | Reviewer-is-operator envelope (see Accepted Risks below). Compensating control: `dydx-delivery/references/safety-rules.md` sandbox-only rules. Follow-on: v2.6 SURF-01..03 hook. |

### Plan 08-02 — Stage 4b fnspec-integration (5 declared threats)

| ID | Category (STRIDE) | Component | Disposition | Status | Mitigation / Evidence |
|----|-------------------|-----------|-------------|--------|------------------------|
| T-08-06 | Tampering / Repudiation (consistency check silently skipped) | D-84 three checks in 4b skill | mitigate | CLOSED | I6 assertion (`phase8-structure-check.sh:151-158`) — `Check (a)`, `Check (b)`, `Check (c)` named verbatim in `consistency-rules.md`. I7 (`:160-165`) — halt-path filename `04b_consistency_check_v` in BOTH 4b SKILL.md AND consistency-rules.md. T-gate PASS. |
| T-08-07 | Tampering (D-85 verbatim skip-emit string drift) | em-dash unicode literal `—` in skip-emit | mitigate | CLOSED | I5 assertion (`phase8-structure-check.sh:143-149`) — `grep -qF 'Stage 4b SKIPPED — no integration work in scope'` in 4b SKILL.md OR `either-spec-skip-paths.md` (em-dash U+2014 preserved). T-gate PASS. |
| T-08-08 | Tampering (I8 cross-plan two-place declaration regression / T-02-06-02 / ROUTE-01) | 5 D-IDs in `## Key decisions` of BOTH 4a + 4b SKILL.md | mitigate | CLOSED | I8 assertion (`phase8-structure-check.sh:167-175`) — `grep -qF "$d"` loop over D-78/D-79/D-82/D-84/D-85 across BOTH 4a + 4b SKILL.md. T-gate PASS. |
| T-08-09 | Information Disclosure (halt artefact content) | `04b_consistency_check_v<N>.md` failure-row body | **accept** | ACCEPTED | Per 08-02 plan posture: failure rows contain only req IDs + delivery tags + reviewer-facing suggestions; no credentials, no PII. Operator trust boundary applies. |
| T-08-10 | DoS (pathological consistency-check input scale) | 4b consistency-check inner loop on synthetic input | **accept** | ACCEPTED | Per 08-02 plan: out of v2.2 scope. Reviewer is single operator running locally; no multi-tenant surface. |

### Plan 08-03 — Cross-cutting closeout (implicit content-integrity threats — verified via structure-check)

| ID | Category (STRIDE) | Component | Disposition | Status | Mitigation / Evidence |
|----|-------------------|-----------|-------------|--------|------------------------|
| T-08-1b | Tampering (4b enum drift) | 4b SKILL.md + template `platform:` enum | mitigate | CLOSED | I3 canonical pointers (`phase8-structure-check.sh:128-134`) + supplementary D-78-baked-in check from 08-02 T5. X1 cross-section (`:357-372`) enforces 4-enum across all 7 platform-declarer SKILLs. T-gate PASS. |
| T-08-2b | Tampering (4b reversed-enum) | 4b SKILL.md `api \| native-ai` literal | mitigate | CLOSED | 08-02 T5 supplementary `canonical-enum-order` (`! grep -qF 'api \| native-ai'`) PASS at plan close. Forward implication from 08-01 honoured (anti-pattern-free phrasing). |
| T-08-3c | Tampering (D-78 enum drift across 11 ROUTE-04 rollout files) | 9 EDIT files + 4 anchor files + README prose | mitigate | CLOSED | E1 assertion (`phase8-structure-check.sh:179-210`) — 4-enum present in all 11 EDIT files + 4 YAML-anchor files + README. T-gate PASS. |
| T-08-4c | Tampering (E2 soft-grep false-pass on `routing` substring) | `phase8-structure-check.sh:216` literal `is the routing key` | mitigate | CLOSED | E2 locked literal grep (`phase8-structure-check.sh:212-218`) — `grep -qF "is the routing key"` matches `dydx-delivery/skills/platform-ziflow/SKILL.md:14`. Soft `'routing'` variant explicitly forbidden in script header comment (lines 13-16). T-gate PASS. |
| T-08-5c | Tampering (R-01 partial-fix — line 47 fixed but line 66 missed) | `dydx-delivery/references/glossary.md` whole-file | mitigate | CLOSED | E4 whole-file assertions (`phase8-structure-check.sh:229-240`) — `! grep -qF 'kickoff-direct'` AND `! grep -qF 'discovery-via'` AND positive `'discovery-ready'` AND `'draft-sow'`. T-gate PASS. |

### Plan 08-03 — Explicit declaration

08-03-SUMMARY.md `## Threat Flags` explicitly states: *"None. No new network endpoints, auth paths, file access patterns, or trust-boundary changes introduced by this plan. All changes are documentation/skill-content/structure-check infrastructure."* No unregistered flags.

## Accepted Risks

### T-08-05 — Path traversal on reviewer-supplied artefact paths

- **Rationale (per 08-01 plan threat model):** The Stage 4a write target `<Client> Brain/<Project>/04a_*.md` is reviewer-controlled. The reviewer IS the operator invoking the skill locally; there is no untrusted-input boundary. Path traversal would require the operator to deliberately construct a malicious path against their own machine.
- **Compensating controls:**
  - `dydx-delivery/references/safety-rules.md` — sandbox-only write rules (skill writes only under approved project workspace roots).
  - Single-operator local execution model (no multi-tenant / no server-side invocation).
  - Reviewer reviews every write at the `status: approved` gate before downstream stages consume.
- **Follow-on:** v2.6 SURF-01..03 path-canonicalization hook will add explicit prefix-check on every emitted artefact path. Tracked in ROADMAP.md.

### T-08-09 — Halt artefact information disclosure

- **Rationale (per 08-02 plan):** `04b_consistency_check_v<N>.md` failure-row table contains only requirement IDs, delivery tags, and reviewer-facing suggestions. No credentials, tokens, PII, or network secrets ever traverse the consistency-check loop (it reads only 4a/4b artefacts which are themselves contract-locked to non-secret content).
- **Compensating controls:** D-84 contract limits failure-row payload to the 5-column schema (`Check ID | Failure type | Row reference | Detail | Suggested resolution`). No free-text dump.
- **Follow-on:** None. Posture is stable.

### T-08-10 — Pathological consistency-check input scale (DoS)

- **Rationale (per 08-02 plan):** Out of v2.2 scope. Reviewer is single local operator; consistency-check runs on bounded artefact input (4a + 4b requirement rows, O(N) on row count). No remote attacker can submit inputs.
- **Compensating controls:** Local-execution-only model. Reviewer can Ctrl-C if a run misbehaves.
- **Follow-on:** Revisit if/when 4b consistency-check is exposed via server-side invocation (not on the v2.x roadmap).

## Final Structure-Check Re-Run

Command:

```
bash .planning/phases/08-stage-4-fnspec-split-route/scripts/phase8-structure-check.sh --all
```

Result: **ALL ASSERTIONS PASSED**, exit code 0, 32 assertions green (8 P + 8 I + 6 E + 6 S + 4 X).

Per-assertion mapping to threats:
- T-08-01 → P4; T-08-02 → P5; T-08-04 → P8 (4a contract)
- T-08-06 → I6 + I7; T-08-07 → I5; T-08-08 → I8 (4b contract)
- T-08-1b → I3 + X1; T-08-3c → E1; T-08-4c → E2; T-08-5c → E4 (cross-cutting)

## Audit Trail

### Security Audit 2026-05-11

| Metric | Count |
|--------|-------|
| Threats found (register) | 12 |
| Closed (mitigation verified) | 10 |
| Open (BLOCKERS) | 0 |
| Accepted (with documented rationale) | 3 (T-08-05, T-08-09, T-08-10) |
| Unregistered flags | 0 |

**Final structure-check `--all` re-run:** PASS, exit 0. 32/32 assertions green.

**Verdict:** SECURED. Phase 8 ships with `threats_open: 0`. No implementation gap detected. No new attack surface beyond content-integrity envelope, which is fully enforced by `phase8-structure-check.sh`.
