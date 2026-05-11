---
phase: 6
reviewers: [gemini, codex]
reviewed_at: 2026-05-11T05:08:40Z
plans_reviewed: [06-01-PLAN.md, 06-02-PLAN.md, 06-03-PLAN.md, 06-04-PLAN.md]
skipped: [claude — running inside Claude Code, kept independent]
---

# Cross-AI Plan Review — Phase 6

## Gemini Review

# Implementation Plan Review: Phase 6 — Internalise Platform Skills

**Reviewer:** Gemini CLI
**Date:** 2026-05-11
**Phase:** 6
**Status:** **APPROVED**

---

## 1. Summary
The implementation plans for Phase 6 are exceptionally well-structured and rigorously aligned with the v2.0 DESIGN locks and Phase 5 Foundations. The decision to slice the work by platform (D-63) while centralising cross-platform synthesis (06-04) effectively manages file-ownership concurrency and allows for atomic, domain-aligned reviews. The documentation of helper contracts (Pipefy `paginate_all`, Wrike OAuth-host, Ziflow `wait_for_proof`) is technically precise, providing the exact level of detail—including failure modes and pseudocode—required for the Stage 8 test bot generation in Phase 8. The plans strictly adhere to the "doc-only" mandate while building robust structural verifications that ensure zero regressions on critical UAT scope-locks (e.g., Pipefy canonical-only host and the `native_ai_path: api` exclusion).

## 2. Strengths
- **Rigorous Alignment with UAT Locks:** Plan 06-01 (Task 3) and Plan 06-02 (Task 2) translate UAT-4.1 and DESIGN-15 into concrete documentation requirements, specifically addressing the Pipefy HTML-on-auth-failure gotcha and the Wrike per-tenant regional host requirement.
- **Pedagogical Helper Framing:** Plan 06-03 (Task 2) correctly prioritises vendor-recommended webhook usage for Ziflow over the polling helper specified in DESIGN-16, framing `wait_for_proof` as an explicit fallback.
- **Robust Synthesis Validation:** Plan 06-04 Task 2 implements the D-66 vocabulary dedup gate and T-06-02/T-06-04 grep gates, ensuring the single-source-of-truth pattern established in Phase 5 is not undermined by per-platform sprawl.
- **High-Fidelity Contracts:** The 7-part structure for helper contracts (D-64) is consistently applied, ensuring that the "doc-only" output functions as a reliable specification for future code-generation phases.
- **Scaffold Efficiency:** Landing the `phase6-structure-check.sh` in Wave 1 (06-01) provides immediate feedback for the subsequent parallel waves (06-02/06-03).

## 3. Concerns

- **Manual Verification Delta (LOW):** Plan 06-02 Task 3 and RESEARCH.md §Vendor Doc Landscape note a material delta in Wrike MCP tool counts (16 vs 47). While the plan allows for execution-time re-verification, there is a minor risk that the `tier_claims_last_verified` date is bumped forward without a corresponding vendor-doc citation in the commit message if the executor isn't diligent.
- **Grep Pattern False Positives (LOW):** Plan 06-02 Task 2 includes a "CRITICAL anti-pattern" callout for `www.wrike.com`. While the validation logic (A12) is designed to be context-aware (regex for assignment vs mention), there is a slight risk of flakiness on some shell environments if regex quoting differs. This is mitigated by the script's use of `set -euo pipefail`.

## 4. Suggestions
- **Commit Message Discipline:** In Plan 06-01/02/03 Task 4 (Native-AI inventory), ensure the executor is reminded that if they perform an optional re-verification and bump the ISO date, the **commit message MUST cite the specific vendor URL** used for the check to preserve the audit trail (as required by D-68).
- **Ziflow High-Churn Awareness:** In Plan 06-03 Task 3, the "High-churn note" for Ziflow ReviewAI is a valuable addition. I suggest ensuring this note specifically highlights that **"Checklist Templates API"** was added in Phase 6 as a post-DESIGN-16 GA feature, demonstrating active maintenance.

## 5. Risk Assessment
**Overall Risk: LOW**

The phase is purely documentation and structural verifications. The high quality of the RESEARCH.md grounded the plans in verified 2026 vendor reality, and the architectural boundaries are well-guarded by the 17 assertions in `phase6-structure-check.sh`. There is zero runtime impact or migration risk to existing artefacts.

---
**Ready for execution.** Proceed with `/gsd-execute-phase 6`.

---

## Codex Review

## Summary

Overall plan quality is strong: the phase is well-sliced by platform, the ROADMAP success criteria are traceable, the known architectural decisions are carried through, and the helper contracts are detailed enough for a later implementation phase to code from. The main risks are in the validation mechanics and a few wording contradictions that could either block execution falsely or accidentally reintroduce out-of-scope semantics.

## Strengths

- Clear per-platform ownership: `06-01`, `06-02`, and `06-03` each produce one complete `platform-*` skill tree, which makes review practical.
- Good dependency shape: `06-01` lands the structure-check scaffold first, `06-02` and `06-03` can then work in separate directories, and `06-04` correctly owns `.planning/OPEN-QUESTIONS.md`.
- The helper contracts are implementation-ready: Pipefy `paginate_all`, Wrike OAuth-host persistence, and Ziflow `wait_for_proof` all include signature, behaviour, failure modes, retry/poll budgets, pseudocode, and worked examples.
- The plans correctly avoid executable platform helper modules and `helpers/` directories, keeping Phase 6 doc-only apart from the validation script.
- OPEN-Q closure is coherent: values land in each `api-contract.md`, and `06-04` flips Q05/Q06.2/Q07.2 with citations back to those files.

## Concerns

- **HIGH**: The `phase6-structure-check.sh --section <platform>` semantics are unclear and may fail mid-phase. In `06-01 Task 1`, A4 loops all three platforms, but later `06-01` expects `--section pipefy` to pass once only Pipefy references exist. The script needs per-platform A4/A5/A6/A17 partitioning, otherwise `06-01`, `06-02`, and `06-03` section checks will produce false failures.

- **HIGH**: Several grep gates conflict with required documentation text. `06-01 Task 3` requires zero `api_host` hits in Pipefy `api-contract.md`, but the same task instructs authors to include “`api_host` field-name reference is REMOVED” and “Skills MUST NOT introduce `api_host` configuration”. That will fail A11/T-06-04 unless the script allows negative-context mentions or the prose avoids the exact token.

- **MEDIUM**: `native_ai_path: api` is forbidden by grep, but the plans repeatedly include the exact forbidden token in narrative sections such as “`native_ai_path: paste | none` ONLY — `api` branch is FORBIDDEN”. That is safe. However any later author copying the full forbidden YAML-looking string into documentation would fail A7. Keep the exact banned string out of all docs, including examples.

- **MEDIUM**: Wrike’s `www.wrike.com` prohibition gate is fragile. The plan intentionally requires the phrase `NEVER hardcode \`www.wrike.com\``, but also says hardcoded examples must not trip greps. This is fine only if A12 checks for the prohibition phrase, not a blanket absence of `www.wrike.com`.

- **MEDIUM**: `06-02` and `06-03` depend on `06-01` only for scaffold and placeholders, not actual content. That is workable, but the placeholder `.gitkeep` files add unnecessary churn and conflict surface. Each platform plan can create its own directories without needing 06-01 to pre-create them.

- **LOW**: `tier_claims_last_verified:` is described as “per-platform distinct” in several places, but all three default to `2026-05-09`. The broader context allows same baseline if no fresh re-verification happens, so the wording should say “per-platform maintained” rather than “distinct”.

- **LOW**: The Ziflow `api-contract.md` says 429 becomes a `ZiflowServerError` “5xx-equivalent treatment”. That is technically imprecise. Better to document a separate `ZiflowRateLimitExceeded` failure class.

## Suggestions

- Make `phase6-structure-check.sh` section-aware explicitly:
  - `--section pipefy` checks only Pipefy A1/A4/A5/A6/A8/A9/A10/A11/A14/A17.
  - `--section wrike` checks only Wrike A2/A4/A5/A6/A12/A15/A17.
  - `--section ziflow` checks only Ziflow A3/A4/A5/A6/A13/A17.
  - Full run checks A7/A16 and cross-platform parity.

- Fix the Pipefy `api_host` contradiction by avoiding the literal token in docs. Use wording like “removed API-host configuration field” instead of writing `api_host`, or change the final grep to allow “removed/forbidden” context.

- Drop `.gitkeep` placeholders from 06-01 unless the executor genuinely needs them. Let `06-02` and `06-03` create their own directories; this keeps file ownership cleaner.

- Add one validation assertion for “no `helpers/` directories exist” across all three platform trees, because D-64 makes that a clear phase boundary.

- Add one validation assertion that each `SKILL.md` has `frontmatter_version: 2` and `platform: pipefy|wrike|ziflow`. The plans mention this, but A1..A17 currently only imply parts of it.

- Update the OPEN-Q row flip verification to avoid `grep -A 11`; inserted decision bullets can shift the status line beyond 11 lines. Use an awk/sed block between OPEN-Q headings instead.

## Risk Assessment

**Overall risk: MEDIUM.** The content design is solid and likely achieves ROADMAP success criteria 1-5. The main risk is not scope or missing platform detail; it is brittle validation. A few grep rules currently contradict required documentation text, and the section-mode structure-check could block otherwise correct intermediate work. Tightening those gates before execution would reduce the phase to LOW risk.

---

## Consensus Summary

**Verdict split:** Gemini APPROVED (risk LOW). Codex flagged risk MEDIUM with 2 HIGH concerns. Both agree on content quality; disagreement is entirely about validation mechanics in `phase6-structure-check.sh`.

### Agreed Strengths (both reviewers)

- **Per-platform slicing (D-63) is the right call** — each `06-0N` produces one complete `platform-*/` tree; review is practical; concurrency is clean.
- **Helper contracts are implementation-ready** — Pipefy `paginate_all`, Wrike OAuth-host persistence, and Ziflow `wait_for_proof` all carry signature + behaviour + failure-modes + retry budget + pseudocode + worked example. Phase 8 test-bot generation can code from this.
- **Dependency shape is correct** — Wave 0 scaffold in 06-01 → parallel platform waves → 06-04 synthesis owning OPEN-QUESTIONS.md flips.
- **Doc-only mandate respected** — no `helpers/` directories created, no executable platform helper modules.
- **Webhook-PRIMARY framing for Ziflow** — vendor-recommended path called out above the polling fallback (RESEARCH §Q05 resolution).

### Agreed Concerns (raised by 2+ reviewers OR raised by 1 with HIGH severity)

| # | Severity | Concern | Source |
|---|---|---|---|
| C1 | **HIGH** | `phase6-structure-check.sh --section <platform>` semantics are not yet defined — A4/A5/A6/A17 currently loop all 3 platforms, so Wave 1 (Pipefy only) running `--section pipefy` could falsely fail on missing Wrike/Ziflow files. | Codex (gemini did not flag) |
| C2 | **HIGH** | Pipefy `api_host` zero-grep gate (A11 second half) collides with required prose in 06-01 Task 3 like "`api_host` field-name reference is REMOVED" — author cannot satisfy both. | Codex (gemini did not flag) |
| C3 | MEDIUM | The exact forbidden YAML token `native_ai_path: api` appears in narrative ("`paste \| none` ONLY — `api` branch is FORBIDDEN") which is fine, BUT any future author copy-pasting that string verbatim into docs would trip A7. Token must never appear in committed files. | Codex |
| C4 | MEDIUM | `.gitkeep` placeholders pre-created in 06-01 add churn and conflict surface — 06-02 and 06-03 can mkdir their own directories. | Codex |
| C5 | MEDIUM | Wrike `www.wrike.com` prohibition gate (A12) requires the literal prohibition phrase AND zero hardcoded host literals — A12 must check for the *phrase*, not blanket absence of the host string. | Codex |
| C6 | LOW | Wrike MCP tool count delta (DESIGN-15 says 16; one secondary source claims 47) — re-verify at execution time AND if `tier_claims_last_verified:` is bumped, commit message MUST cite the vendor URL. | Gemini (corroborates RESEARCH §Open Questions) |
| C7 | LOW | Ziflow 429 mapped to `ZiflowServerError` (5xx-equivalent) is imprecise — should be its own `ZiflowRateLimitExceeded` class. | Codex |
| C8 | LOW | OPEN-Q row-flip verification uses `grep -A 11` — inserted decision bullets could shift the `Status:` line beyond 11 lines and false-negative. Use awk/sed between OPEN-Q heading anchors instead. | Codex |
| C9 | LOW | "tier_claims_last_verified per-platform distinct" wording is misleading when all three default to the same baseline date — change to "per-platform maintained". | Codex |

### Divergent Views

- **Risk level:** Gemini says LOW (content quality drives the read); Codex says MEDIUM (validation mechanics could brick execution). Both views are defensible — Gemini is right that the docs themselves are sound; Codex is right that the structure-check script as currently specified has internal contradictions.
- **Wave 0 placeholder strategy:** Gemini implicitly endorses pre-created `.gitkeep` placeholders as enabling parallel Wave 2. Codex argues they are churn. Either works; Codex's path is cleaner if 06-02/06-03 can mkdir their own dirs without race conditions on the file-ownership check.

### Recommended Next Step

The 2 HIGH concerns (C1 + C2) are real execution blockers in their current form. Recommend running:

```
/gsd-plan-phase 6 --reviews
```

…to replan with this REVIEWS.md as input. The planner should:
1. Define `--section <platform>` semantics in 06-01 Task 1 explicitly (per-platform assertion partitioning per Codex's suggestion).
2. Resolve the Pipefy `api_host` prose-vs-grep collision (either re-word the prose to use "removed API-host configuration field" without the literal token, OR change A11 to allow negative-context mentions).
3. Optionally absorb the MEDIUM/LOW items (C3-C9) — most are 1-2 line edits.

After replanning, the existing PASSED checker verdict should be re-confirmed.

