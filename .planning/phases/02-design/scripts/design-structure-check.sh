#!/usr/bin/env bash
# design-structure-check.sh — structural verifier for .planning/DESIGN.md
#
# Comment-vs-code policy (per cross-AI review LOW #8):
#   - Sentinel-token matches use `grep -qF` (literal-string, case-sensitive). Used for exact D-IDs,
#     version strings, frontmatter field names, and exact H2 anchor strings.
#   - Pattern matches use `grep -cE` (case-sensitive extended regex). Used for echo-line patterns,
#     stage-skill counts, hand-off matrix row prefixes, [OPEN: Phase 4] markers.
#   - This script does NOT use case-insensitive matching (no -i flag). Capitalisation MUST be exact.
#     Author tooling is responsible for emitting canonical capitalisation.
#
# Section-range extraction (per cross-AI review HIGH #1):
#   The naive `awk '/^## X/,/^## /'` range pattern is broken because the start H2 also matches
#   the end H2 regex on the same line — the range captures only the header line. We use a stateful
#   helper section_between() that exits only on the NEXT H2, capturing the full body.
set -euo pipefail
DESIGN_FILE=".planning/DESIGN.md"
fail() { echo "FAIL: $1" >&2; exit 1; }

# section_between "## Heading text" — emits the body lines AFTER the matching H2 up to (but not
# including) the NEXT line that starts with `## `. Uses a stateful flag, not a regex range, so
# the start H2 cannot be re-matched as the end H2 on the same line.
section_between() {
  local heading="$1"
  awk -v hdr="$heading" '
    f && /^## /{exit}
    f{print}
    index($0, hdr) == 1 && /^## /{f=1}
  ' "$DESIGN_FILE"
}

[ -f "$DESIGN_FILE" ] || fail "$DESIGN_FILE not found"

# Required H2 anchors per D-31 author-flow plan groupings + D-26 hand-off matrix + D-27 closed list
declare -a required_h2=(
  "## Cross-cutting decisions"
  "## Skill layout"
  "## 13-skill inventory"
  "## Stage-by-stage hand-off contract"
  "## Platform skills"
  "## Test bot architecture"
  "## Live status-lifecycle survey"
  "## Deferred to Phase 4 OPEN-QUESTIONS"
  "## Appendix A: Glossary"
  "## Appendix B:"
  "## Appendix C:"
)
for h in "${required_h2[@]}"; do
  grep -qF "$h" "$DESIGN_FILE" || fail "missing required H2 anchor: $h"
done

# Stage-skill H2 anchors (Stage 1 through Stage 11) — single check, one regex (case-sensitive ERE)
stage_count=$(grep -cE '^## Stage [0-9]+[ab]?[a-d]?( |:)' "$DESIGN_FILE" || true)
[ "$stage_count" -ge 11 ] || fail "expected >= 11 Stage-N H2 anchors, found $stage_count"

# Per-DESIGN success-criteria echo lines per D-35 — at least 30 (one per DESIGN-01..30)
echo_count=$(grep -cE '^> \*\*DESIGN-[0-9]{2}:\*\*' "$DESIGN_FILE" || true)
[ "$echo_count" -ge 30 ] || fail "expected >= 30 'DESIGN-NN:' success-criteria echo blockquote lines (D-35), found $echo_count"

# D-22 risk-multiplier section sentinel: literal "D-22" reference + [OPEN] marker
grep -qF 'D-22' "$DESIGN_FILE" || fail "DESIGN-22 risk-multiplier section must reference D-22 (CONTEXT decision anchor)"

# [OPEN: Phase 4 — ...] inline marker discipline (D-27 / D-33) — at least 1 marker present
open_markers=$(grep -cE '\[OPEN: Phase 4' "$DESIGN_FILE" || true)
[ "$open_markers" -ge 1 ] || fail "expected >= 1 inline '[OPEN: Phase 4 — ...]' marker per D-27/D-33"

# Closed deferred-list section has at least 1 enumerated [OPEN] item (D-27).
# Use awk '/.../,0' (start-to-EOF) which is a SAFE range pattern — `0` never matches a line so the
# range continues to end-of-file; not subject to the start-matches-end bug.
closed_list_items=$(awk '/^## Deferred to Phase 4 OPEN-QUESTIONS/,0' "$DESIGN_FILE" | grep -cE '\[OPEN: Phase 4' || true)
[ "$closed_list_items" -ge 1 ] || fail "Deferred list section must enumerate the inline [OPEN] markers (D-27)"

# Frontmatter scheme sentinel (DESIGN-01) — frontmatter_version: 2
grep -qF 'frontmatter_version: 2' "$DESIGN_FILE" || fail "DESIGN-01 must specify 'frontmatter_version: 2'"

# Hand-off transition matrix has at least 10 transitions (D-26 — 10 stage transitions).
# Uses section_between() helper (stateful awk) — extracts body of the hand-off H2 up to next H2.
handoff_rows=$(section_between "## Stage-by-stage hand-off contract" | grep -cE '^\| Stage' || true)
[ "$handoff_rows" -ge 10 ] || fail "Stage-by-stage hand-off contract matrix must have >= 10 transition rows (D-26), found $handoff_rows"

echo "OK: all structural checks passed"
exit 0
