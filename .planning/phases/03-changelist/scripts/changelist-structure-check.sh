#!/usr/bin/env bash
# changelist-structure-check.sh — structural verifier for .planning/CHANGELIST.md
#
# Comment-vs-code policy (carried from Phase 2 design-structure-check.sh per cross-AI review LOW #8):
#   - Sentinel-token matches use `grep -qF` (literal-string, case-sensitive). Used for exact D-IDs,
#     CHANGE-IDs, version strings, frontmatter field names, and exact H2 anchor strings.
#   - Pattern matches use `grep -cE` (case-sensitive extended regex). Used for echo-line patterns,
#     phase H3 counts, hand-off matrix row prefixes, [OPEN: Phase 4] markers.
#   - This script does NOT use case-insensitive matching (no -i flag). Capitalisation MUST be exact.
#     Author tooling is responsible for emitting canonical capitalisation.
#
# Section-range extraction (carried from Phase 2 cross-AI review HIGH #1):
#   The naive `awk '/^## X/,/^## /'` range pattern is broken because the start H2 also matches
#   the end H2 regex on the same line — the range captures only the header line. We use a stateful
#   helper section_between() that exits only on the NEXT H2, capturing the full body.
set -euo pipefail
CHANGELIST_FILE=".planning/CHANGELIST.md"
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
  ' "$CHANGELIST_FILE"
}

[ -f "$CHANGELIST_FILE" ] || fail "$CHANGELIST_FILE not found"

# Required H2 anchors per D-36 (16 sections — verbatim, with inline milestone tags)
declare -a required_h2=(
  "## Executive Summary"
  "## How to read this change list"
  "## Phase 1: Foundations + Connector Verification (v2.1)"
  "## Phase 2: Internalise Platform Skills (v2.1)"
  "## Phase 3: Stage 1 + Stage 4 split (v2.2)"
  "## Phase 4: Tech spec + Cost + Implementation prompt (v2.3)"
  "## Phase 5: Test bot rebuild (v2.4)"
  "## Phase 6: Documentation publishing (v2.5)"
  "## Phase 7: Native-AI upload bundle + audit log (v2.5)"
  "## Phase 8: Sign-off + Coda mirror (v2.6)"
  "## Phase 9: Surfaces (v2.6)"
  "## Appendix A: Per-skill delta matrix (CHANGE-02)"
  "## Appendix B: Cosmetic-fix list (CHANGE-03)"
  "## Appendix C: Research-blocked phases (CHANGE-04)"
  "## Appendix D: Migration cutover rules (CHANGE-05)"
  "## Appendix E: Deferred to Phase 4 OPEN-QUESTIONS"
)
for h in "${required_h2[@]}"; do
  grep -qF "$h" "$CHANGELIST_FILE" || fail "missing required H2 anchor: $h"
done

# H2 uniqueness check (per cross-AI C6 — codex MEDIUM): every required H2 must appear EXACTLY once.
# Duplicate H2s break section_between (start H2 emitted under itself extends the section); the
# `grep -qF` presence loop above does NOT catch duplicates. This loop does.
for h in "${required_h2[@]}"; do
  count=$(grep -cF "$h" "$CHANGELIST_FILE" || true)
  [ "$count" = "1" ] || fail "H2 anchor '$h' appears $count times (expected exactly 1)"
done

# Phase H2 anchors carry inline milestone tag (v2.X) per D-37 — at least 9 phase H2s
phase_count=$(grep -cE '^## Phase [1-9]: .* \(v2\.[1-6]\)' "$CHANGELIST_FILE" || true)
[ "$phase_count" -ge 9 ] || fail "expected >= 9 'Phase N: <name> (v2.X)' H2 anchors, found $phase_count"

# Phase 7 H2 anchor — REVISED under UAT-6.1 (2026-05-10). Native-AI API ingestion OUT OF SCOPE entirely;
# Phase 7 unblocked, scope reduced to "paste bundle + upload audit log." [BLOCKED] tag REMOVED.
grep -qF '## Phase 7: Native-AI upload bundle + audit log (v2.5)' "$CHANGELIST_FILE" \
  || fail "Phase 7 H2 must match revised UAT-6.1 anchor 'Native-AI upload bundle + audit log (v2.5)'"

# Appendix B opening-sentence sentinel (D-41 verbatim-lift opening — partial match on stable substring)
grep -qF 'Lifted verbatim from `.planning/AUDIT.md` § AUDIT-07' "$CHANGELIST_FILE" \
  || fail "Appendix B must open with verbatim-lift sentinel (D-41) — substring 'Lifted verbatim from \`.planning/AUDIT.md\` § AUDIT-07'"

# Appendix D opening-sentence sentinel (D-43 citation header)
grep -qF 'Authoritative contract: `.planning/DESIGN.md` § DESIGN-08' "$CHANGELIST_FILE" \
  || fail "Appendix D must open with citation-header sentinel (D-43) — substring 'Authoritative contract: \`.planning/DESIGN.md\` § DESIGN-08'"

# Appendix E opening-sentence sentinel (D-27 carried mechanical-walk hint)
grep -qF 'Closed list of every' "$CHANGELIST_FILE" \
  || fail "Appendix E must open with mechanical-walk sentinel (D-27) — substring 'Closed list of every'"

# Appendix B per-bullet sentinel count (D-16 carried). AUDIT-07 carried 6 fixes originally; under
# UAT-3.1 (2026-05-10) §7.5 owner-email was reclassified as intentional (NOT a fix), reducing the
# active scheduled-fix count to 5. Floor lowered from 6 → 5 to match.
appendix_b_sentinels=$(section_between "## Appendix B: Cosmetic-fix list (CHANGE-03)" \
  | grep -cE 'Scheduled for v2\.1 Foundations build \(FOUND-[0-9]+\), NOT this milestone' || true)
[ "$appendix_b_sentinels" -ge 5 ] || fail "Appendix B per-bullet sentinel count must be >= 5 (matches AUDIT-07's 5 active fixes after UAT-3.1 reclassification of §7.5; per D-16/D-41), found $appendix_b_sentinels"

# Appendix A row count (per CONTEXT specifics — 13 v2 skills + 2 RETIRED → SPLIT minimum = 15 rows).
# Per cross-AI C1 (codex HIGH / gemini MEDIUM): anchor on the Status-column closed enum (per D-39)
# rather than the v0.3.0-origin first column. The Status column is the locked enum (D-39); the
# origin column has too much variation (`<skill>`, `none`, `derived from`, `referenced-but-missing`)
# for a reliable first-column regex. Matching on Status enum is the source-of-truth check.
appendix_a_rows=$(section_between "## Appendix A: Per-skill delta matrix (CHANGE-02)" \
  | grep -cE '^\| .+ \| .+ \| (NEW|NEW \(split\)|MODIFIED|UNCHANGED|RETIRED|RETIRED → SPLIT) \|' || true)
[ "$appendix_a_rows" -ge 15 ] || fail "Appendix A row count $appendix_a_rows < 15 (expected >= 15: 13 v2 skills + 2 RETIRED → SPLIT per CONTEXT — closed Status enum per D-39)"

# Appendix E [OPEN: Phase 4] enumeration (D-27 carried) — at least 8 bullets matching the
# DESIGN.md inline-marker count locked in Phase 2 02-10 SUMMARY (Pipefy AI KB / Pipefy pagination /
# Pipefy rate-limit / Wrike AI / Wrike rate-limit / Ziflow ReviewAI / Ziflow read-after-create /
# risk-multiplier defaults). New Phase 3 deferrals may add additional bullets.
appendix_e_bullets=$(section_between "## Appendix E: Deferred to Phase 4 OPEN-QUESTIONS" \
  | grep -cE '^- \*\*`\[OPEN: Phase 4' || true)
[ "$appendix_e_bullets" -ge 8 ] || fail "Appendix E must enumerate >= 8 [OPEN: Phase 4 — ...] bullets (matches DESIGN.md baseline + any new Phase 3 deferrals), found $appendix_e_bullets"

# Per-phase mini-table row count (D-38 — Attribute / Detail 6-row mini-tables, one per phase H3 / H2).
# Each phase section must carry rows starting with '| Deliverables' / '| Depends on' / '| Addresses' /
# '| Avoids pitfalls' / '| Skills introduced/modified' / '| Research-blocked' = 6 rows minimum per phase.
# Aggregate count across all 9 phases >= 54.
deliverables_rows=$(grep -cE '^\| Deliverables \|' "$CHANGELIST_FILE" || true)
[ "$deliverables_rows" -ge 9 ] || fail "expected >= 9 '| Deliverables |' rows (one per phase mini-table per D-38), found $deliverables_rows"

addresses_rows=$(grep -cE '^\| Addresses \|' "$CHANGELIST_FILE" || true)
[ "$addresses_rows" -ge 9 ] || fail "expected >= 9 '| Addresses |' rows (one per phase mini-table per D-38), found $addresses_rows"

avoids_rows=$(grep -cE '^\| Avoids pitfalls \|' "$CHANGELIST_FILE" || true)
[ "$avoids_rows" -ge 9 ] || fail "expected >= 9 '| Avoids pitfalls |' rows (one per phase mini-table per D-38), found $avoids_rows"

# No-placeholder assertion (per cross-AI C9 — codex MEDIUM). Catches leftover skeleton stubs like
# "Populated by 03-04", "placeholder", or any plan-ID string "03-0N" the planner/executor leaves
# behind. Tagged as final-only — EXPECTED to fail in Waves 0..6 (placeholders are progressively
# replaced); Plan 03-07 synthesis MUST leave the document clean and this assertion MUST pass at
# end of synthesis. Emitted unconditionally per REVIEWS.md "simpler" recommendation; mid-phase
# failures join the existing count-floor failures.
! grep -qE 'Populated by|placeholder|03-0[1-9]' "$CHANGELIST_FILE" \
  || fail "leftover placeholder/plan-ID strings detected (final-only assertion — expected to fail in Waves 0..6, MUST pass at end of Plan 03-07 synthesis)"

echo "OK: all structural checks passed"
exit 0
