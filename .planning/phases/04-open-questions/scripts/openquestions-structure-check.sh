#!/usr/bin/env bash
# openquestions-structure-check.sh — structural verifier for .planning/OPEN-QUESTIONS.md
#
# Comment-vs-code policy (carried from Phase 3 changelist-structure-check.sh per cross-AI LOW #8):
#   - Sentinel-token matches use `grep -qF` (literal-string, case-sensitive). Used for exact D-IDs,
#     OPEN-NN, exact H2 anchor strings, severity / resolution-path / status enum literals.
#   - Pattern matches use `grep -cE` (case-sensitive extended regex). Used for register row counts,
#     citation backtick-pattern, Appendix B / C traceability cardinality.
#   - This script does NOT use case-insensitive matching (no -i flag). Capitalisation MUST be exact.
#
# Section-range extraction (carried from Phase 2 cross-AI HIGH #1 / Phase 3 03-01):
#   The naive `awk '/^## X/,/^## /'` range pattern is broken because the start H2 also matches
#   the end H2 regex on the same line — the range captures only the header line. The stateful
#   helper section_between() exits only on the NEXT H2.
#
# Phase 4 cross-AI review fixes (per .planning/phases/04-open-questions/04-REVIEWS.md):
#   - C1: A13 narrowed regex. Targets ACTUAL stubs only (`Populated by 04-0[1-9]`, `Preamble placeholder`,
#     literal word `placeholder`). Does NOT reject bare `04-0[1-9]` — Plan 04-05 Appendix C cites
#     algorithm precedents (`Phase 3 03-07`, `Phase 2 02-10`, `synthesis Plan 04-05`) and those are
#     legitimate narrative references.
#   - C2: A4 / A10 / A14 row regexes use `OPEN-Q[0-9]+(\.[0-9]+)?` (decimal-ID-aware) so OPEN-Q21.1
#     (OPEN-06 namespace sub-decision row, Plan 04-04) is counted, not silently dropped.
#   - C4: A4 register-row floor is `>= 21` (replaces brittle hard-floor 22). Wave 4 baseline is 21
#     rows minimum (without OPEN-Q21.1 sub-row); the floor is robust to whether the sub-row exists.
#     Appendix B 1:1 cardinality (A10) + Appendix C 5-condition block (A11) carry the rest of the
#     count discipline; ROADMAP success-criteria coverage is checked at synthesis time in Plan 04-05.
#   - C5: A14 new citation-validity SAMPLE assertion. For the first 20 backtick-wrapped citations,
#     confirm (i) cited file exists AND (ii) cited line number is a valid line of that file. The
#     FULL pass runs at synthesis time in Plan 04-05's reconciliation algorithm.
#   - C6: A8 owner enum tightened to `Phase [1-9]|TBD` only. Hybrid `Phase 1/Phase 2` removed because
#     downstream consumers `grep 'Owning phase: Phase <N>'` and would miss hybrid rows. Plan 04-02
#     splits OPEN-Q06 + OPEN-Q07 each into TWO single-owner rows (one Phase 1, one Phase 2).
set -euo pipefail
OPENQ_FILE=".planning/OPEN-QUESTIONS.md"
fail() { echo "FAIL: $1" >&2; exit 1; }

section_between() {
  local heading="$1"
  awk -v hdr="$heading" '
    f && /^## /{exit}
    f{print}
    index($0, hdr) == 1 && /^## /{f=1}
  ' "$OPENQ_FILE"
}

[ -f "$OPENQ_FILE" ] || fail "$OPENQ_FILE not found"

# A1. Required H2 anchors per D-53 (12 sections — verbatim)
declare -a required_h2=(
  "## Executive Summary"
  "## How to read this register"
  "## OPEN-01: Research-flagged unverified items"
  "## OPEN-02: Connector-availability uncertainties"
  "## OPEN-03: Design-decision-deferred items"
  "## OPEN-04: Hub-link backfill rollout coordination"
  "## OPEN-05: Standard Coda templates v2 must author"
  "## OPEN-06: /refine-<skill> resolution"
  "## OPEN-07: Plugin self-test scope"
  "## Appendix A: Per-phase rollup index"
  "## Appendix B: Source traceability"
  "## Appendix C: Reconciliation algorithm result"
)
for h in "${required_h2[@]}"; do
  grep -qF "$h" "$OPENQ_FILE" || fail "missing required H2 anchor: $h"
done

# A2. H2 uniqueness loop (per cross-AI C6 carried from Phase 3 — codex MEDIUM):
#   every required H2 must appear EXACTLY once. Duplicates break section_between.
for h in "${required_h2[@]}"; do
  count=$(grep -cF "$h" "$OPENQ_FILE" || true)
  [ "$count" = "1" ] || fail "H2 anchor '$h' appears $count times (expected exactly 1)"
done

# A3. Exactly 7 OPEN-NN H2 anchors (per D-46 — REQUIREMENTS.md OPEN-01..07 1:1)
open_nn_count=$(grep -cE '^## OPEN-0[1-7]: ' "$OPENQ_FILE" || true)
[ "$open_nn_count" = "7" ] || fail "expected exactly 7 '## OPEN-0N: ' H2 anchors, found $open_nn_count"

# A4. Register-row count floor (per cross-AI C4 — was hard-22, now robust >= 21).
#   Each register row is identified by `**OPEN-Q<NN>**` per D-47 (per-row block form) OR
#   `| OPEN-Q<NN> |` (table-form). Cross-AI C2: regex is decimal-ID-aware to count OPEN-Q21.1.
register_rows=$(grep -cE '^\| OPEN-Q[0-9]+(\.[0-9]+)? \|' "$OPENQ_FILE" || true)
register_blocks=$(grep -cE '^\*\*OPEN-Q[0-9]+(\.[0-9]+)?\*\*' "$OPENQ_FILE" || true)
register_total=$(( register_rows + register_blocks ))
[ "$register_total" -ge 21 ] || fail "register row/block count $register_total < 21 (expected >= 21 per cross-AI C4 — Wave 4 baseline; Appendix B 1:1 cardinality + Appendix C reconciliation carry the rest)"

# A5. Severity closed enum (per D-48): every severity field must match BLOCKER|GUARDRAIL|INFORMATIONAL.
#   Disallow any severity literal outside the closed enum.
bad_severity=$(grep -nE 'Severity:[[:space:]]*[A-Z]+' "$OPENQ_FILE" \
  | grep -vE 'Severity:[[:space:]]*(BLOCKER|GUARDRAIL|INFORMATIONAL)' || true)
[ -z "$bad_severity" ] || fail "Severity field outside closed enum (D-48): $bad_severity"
sev_total=$(grep -cE 'Severity:[[:space:]]*(BLOCKER|GUARDRAIL|INFORMATIONAL)' "$OPENQ_FILE" || true)
[ "$sev_total" -ge 21 ] || fail "Severity field count $sev_total < 21 (expected one per register row; floor follows A4)"

# A6. Resolution-path closed enum (per D-49): every Resolution-path field must match one of 5 enum values.
bad_resolution=$(grep -nE 'Resolution path:[[:space:]]' "$OPENQ_FILE" \
  | grep -vE 'Resolution path:[[:space:]]*(/gsd-research-phase [0-9]+|decide-before-Phase-[0-9]+|Coda-template-authoring \(Phase 8\)|policy-pending-sign-off|live-workstream-pointer)' || true)
[ -z "$bad_resolution" ] || fail "Resolution path field outside closed enum (D-49): $bad_resolution"
res_total=$(grep -cE 'Resolution path:[[:space:]]*(/gsd-research-phase [0-9]+|decide-before-Phase-[0-9]+|Coda-template-authoring \(Phase 8\)|policy-pending-sign-off|live-workstream-pointer)' "$OPENQ_FILE" || true)
[ "$res_total" -ge 21 ] || fail "Resolution path field count $res_total < 21 (expected one per register row; floor follows A4)"

# A7. Status closed enum (per D-47): every status field must match open|proposed|decided|closed.
bad_status=$(grep -nE 'Status:[[:space:]]' "$OPENQ_FILE" \
  | grep -vE 'Status:[[:space:]]*(open|proposed|decided|closed)' || true)
[ -z "$bad_status" ] || fail "Status field outside closed enum (D-47): $bad_status"

# A8. Owning-phase enum tightened per cross-AI C6: `Phase [1-9]|TBD` only (no hybrid).
#   Hybrid `Phase 1/Phase 2` removed because downstream consumers grep `Owning phase: Phase <N>` and
#   would miss hybrid rows. Plan 04-02 splits OPEN-Q06 (Pipefy rate-limit) + OPEN-Q07 (Wrike rate-limit)
#   each into TWO single-owner rows (one Phase 1, one Phase 2).
bad_owner=$(grep -nE 'Owning phase:[[:space:]]' "$OPENQ_FILE" \
  | grep -vE 'Owning phase:[[:space:]]*(Phase [1-9]|TBD)[[:space:]]*$' || true)
[ -z "$bad_owner" ] || fail "Owning phase field outside enum (D-47 + cross-AI C6 — single-owner only): $bad_owner"

# A9. Citation backtick-pattern (per D-14 carried): every register row carries >= 1 backtick-wrapped
#   `path:line` citation in its Source citations field. Floor: total citation occurrences >= register_total.
citations=$(grep -cE '`\.planning/[A-Za-z0-9_./-]+\.md:[0-9]+`' "$OPENQ_FILE" || true)
[ "$citations" -ge "$register_total" ] || fail "citation count $citations < register_total $register_total (D-14: every row needs >= 1 backtick-wrapped path:line citation)"

# A10. Appendix B traceability table cardinality (per D-53): Appendix B row count == register_total.
#   Cross-AI C2: decimal-ID-aware regex.
appendix_b_rows=$(section_between "## Appendix B: Source traceability" \
  | grep -cE '^\| OPEN-Q[0-9]+(\.[0-9]+)? \|' || true)
[ "$appendix_b_rows" = "$register_total" ] || fail "Appendix B row count $appendix_b_rows != register total $register_total (D-53 1:1 cardinality)"

# A11. Appendix C reconciliation algorithm result block (per D-53): all 5 conditions present + TRUE.
appendix_c_body=$(section_between "## Appendix C: Reconciliation algorithm result")
echo "$appendix_c_body" | grep -qF 'INPUT_COUNT_AFTER_DEDUP' \
  || fail "Appendix C missing 'INPUT_COUNT_AFTER_DEDUP' assertion line"
echo "$appendix_c_body" | grep -qF 'REGISTER_ROW_COUNT' \
  || fail "Appendix C missing 'REGISTER_ROW_COUNT' assertion line"
echo "$appendix_c_body" | grep -qF 'CARDINALITY_MATCH = TRUE' \
  || fail "Appendix C missing 'CARDINALITY_MATCH = TRUE' result line"
echo "$appendix_c_body" | grep -qF 'ALL_CITATIONS_VERIFIED = TRUE' \
  || fail "Appendix C missing 'ALL_CITATIONS_VERIFIED = TRUE' result line"
echo "$appendix_c_body" | grep -qF 'ALL_OWNERS_ASSIGNED = TRUE' \
  || fail "Appendix C missing 'ALL_OWNERS_ASSIGNED = TRUE' result line"

# A12. D-37 OPEN-01 contingent fallback wording (verbatim where Phase 7 BLOCKER rows are described).
#   Phase 4 carries the verbatim D-37 sentence in the OPEN-01 section preamble or the Phase 7 register rows.
grep -qF 'slide P8/P9 → v2.7' "$OPENQ_FILE" \
  || fail "missing D-37 OPEN-01 contingent fallback verbatim sentence (substring 'slide P8/P9 → v2.7')"

# A13. No-placeholder synthesis-end assertion (per cross-AI review C1 — NARROWED regex).
#   Targets ACTUAL skeleton stubs only:
#     - `Populated by 04-0[1-9]` (skeleton populated-by notes)
#     - `Preamble placeholder` (skeleton preamble line)
#     - literal word `placeholder` (any leftover stub text)
#   Does NOT reject bare `04-0[1-9]` plan-IDs — Plan 04-05 Appendix C narratively cites algorithm
#   precedents (`Phase 3 03-07`, `Phase 2 02-10`, `synthesis Plan 04-05`) and those are legitimate.
#   EXPECTED to fail in Waves 1..4; Plan 04-05 synthesis MUST leave the document clean of stubs.
#   The legitimate `owner: TBD` literal is permitted and not matched here.
! grep -qE 'Populated by 04-0[1-9]|Preamble placeholder|\bplaceholder\b' "$OPENQ_FILE" \
  || fail "leftover skeleton stub strings detected — A13 narrowed regex (Populated by 04-0[1-9] | Preamble placeholder | placeholder); EXPECTED to fail in Waves 1..4, MUST pass at end of Plan 04-05 synthesis"

# A14. Citation-validity SAMPLE pass (per cross-AI review C5).
#   For the first 20 backtick-wrapped `path:line` citations encountered, confirm:
#     (i) the cited file exists, AND
#     (ii) the cited line number is a valid line in that file (i.e., NR >= line_number).
#   Pattern-only validation (A9) is too weak for D-14/D-50; this gives mechanical proof that
#   citations actually point to real lines. The FULL pass runs at synthesis time in Plan 04-05's
#   reconciliation algorithm (Appendix C ALL_CITATIONS_VERIFIED = TRUE).
#   In Waves 1..3 the document may have 0 citations — the sample is empty and A14 passes vacuously.
sample_count=0
sample_max=20
while IFS= read -r match; do
  [ "$sample_count" -ge "$sample_max" ] && break
  cited_path=$(printf '%s' "$match" | sed -E 's/^.*`(\.planning\/[A-Za-z0-9_./-]+\.md):([0-9]+)`.*$/\1/')
  cited_line=$(printf '%s' "$match" | sed -E 's/^.*`(\.planning\/[A-Za-z0-9_./-]+\.md):([0-9]+)`.*$/\2/')
  [ -f "$cited_path" ] || fail "A14 citation-validity: cited file missing: $cited_path (line $cited_line)"
  total_lines=$(wc -l < "$cited_path" | tr -d '[:space:]')
  if [ "$cited_line" -gt "$total_lines" ]; then
    fail "A14 citation-validity: cited line $cited_line exceeds total lines $total_lines in $cited_path"
  fi
  sample_count=$((sample_count + 1))
done < <(grep -oE '`\.planning/[A-Za-z0-9_./-]+\.md:[0-9]+`' "$OPENQ_FILE" || true)

echo "OK: all structural checks passed"
exit 0
