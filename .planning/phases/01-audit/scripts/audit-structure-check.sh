#!/usr/bin/env bash
# audit-structure-check.sh — structural verifier for .planning/AUDIT.md
# All prose-matching greps use case-insensitive ERE (`grep -qiE`) so capitalization
# drift between author variants (e.g. "v2.1 build" vs "v2.1 Foundations build") does
# not break the gate. The canonical D-16 phrase is `scheduled for v2\.1 (foundations )?build`
# (case-insensitive ERE) — both the lowercase and the uppercase "Foundations" variant pass.
# Sentinel tokens like `2.0.0` use literal-string match (`grep -qF`).
# Appendix B row regex is tolerant: `^\| [^|]+ \|` counts any pipe-delimited row whose
# first column is non-empty (works for numeric-indexed `| 1 |` rows or any other format).
set -euo pipefail
AUDIT_FILE=".planning/AUDIT.md"
fail() { echo "FAIL: $1" >&2; exit 1; }

# 1. AUDIT.md exists
[ -f "$AUDIT_FILE" ] || fail "$AUDIT_FILE not found"

# 2. All 8 AUDIT-0N H2 sections present
expected_sections=8
actual_sections=$(grep -cE '^## AUDIT-0[1-8]:' "$AUDIT_FILE" || true)
[ "$actual_sections" -eq "$expected_sections" ] || \
  fail "expected $expected_sections AUDIT-0N H2 sections, found $actual_sections"

# 3. AUDIT-07 cosmetic-fix v2.1 constraint phrase present (D-16)
# Canonical pattern: case-insensitive ERE matching both 'scheduled for v2.1 build'
# and 'scheduled for v2.1 Foundations build' so D-16's per-bullet enforcement holds
# regardless of which capitalization variant Plan 07 ends up writing.
grep -qiE 'scheduled for v2\.1 (foundations )?build' "$AUDIT_FILE" || \
  fail "D-16 v2.1 constraint phrase not found (expected case-insensitive ERE 'scheduled for v2\\.1 (foundations )?build')"

# 4. CONCERNS.md superset claim present (AUDIT-02, D-08)
grep -qiE 'verified superset of|all .* (entries|sections) absorbed' "$AUDIT_FILE" || \
  fail "CONCERNS.md absorption claim not found"

# 5. Executive Summary section header present (D-03)
grep -qE '^## Executive Summary' "$AUDIT_FILE" || \
  fail "Executive Summary section header not found (D-03 requires '## Executive Summary' anchor)"

# 6. Appendix B trace section present (D-09)
grep -qE '^## Appendix B:' "$AUDIT_FILE" || \
  fail "Appendix B trace section header not found"

# 7. Appendix B has at least 14 data rows (one per CONCERNS.md H2 section, per D-09)
# Counts ANY pipe-delimited row inside the Appendix B section whose first column is
# non-empty. Plan 09 writes a 7-column trace table; the regex tolerates any first column
# format and counts data rows by leading-pipe + content + pipe.
appendix_rows=$(awk '/^## Appendix B:/,0' "$AUDIT_FILE" | grep -cE '^\| [^|]+ \|' || true)
[ "$appendix_rows" -ge 14 ] || \
  fail "Appendix B trace has fewer than 14 rows ($appendix_rows found) — CONCERNS.md absorption coverage incomplete"

# 8. AUDIT-06 recommends 2.0.0 as synced target (D-17)
grep -qF '2.0.0' "$AUDIT_FILE" || \
  fail "AUDIT-06 must recommend 2.0.0 as synced target"

echo "OK: all structural checks passed"
exit 0
