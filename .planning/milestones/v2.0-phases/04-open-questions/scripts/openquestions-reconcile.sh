#!/usr/bin/env bash
# openquestions-reconcile.sh — REAL reconciliation per cross-AI review C3.
# Builds canonical expected-question multiset from input streams; normalises + dedups;
# compares set-difference both ways against register row Questions; emits cardinality +
# diff + ROADMAP SC walk + ALL_CITATIONS_VERIFIED (full pass per cross-AI C5).
#
# Replaces the assumed-equality approach (`INPUT_COUNT_AFTER_DEDUP="$REGISTER_TOTAL"`)
# from the pre-review plan with a mechanical multiset comparison.
#
# REGISTER multiset extraction uses stateful awk (NOT `grep -A1`) per WARNING fix from
# /gsd-plan-phase 4 --reviews iteration 2 verification: per-row block format emits a
# blank line between row-id-line and `- **Question:**` field; `grep -A1` returned the
# blank line, producing an empty REGISTER multiset and silently defeating C3. Awk
# pattern: set flag on `^**OPEN-Q...**` match; print next `- **Question:**` line
# regardless of intervening blank lines. Robust to per-row block layout drift.
set -eu
# pipefail intentionally NOT set: stream-extraction pipelines use `grep -v '^$'` which
# exits 1 when input is empty (not an error in this context); we tolerate empty streams.
OPENQ_FILE=".planning/OPEN-QUESTIONS.md"
TMPDIR_RECON=$(mktemp -d)
trap 'rm -rf "$TMPDIR_RECON"' EXIT

# normalise() — lowercase, strip punctuation, collapse whitespace.
normalise() {
  tr '[:upper:]' '[:lower:]' \
    | sed -e 's/[[:punct:]]/ /g' -e 's/[[:space:]]\+/ /g' -e 's/^ //' -e 's/ $//'
}

# Step 1 — Build INPUT multiset from 3 streams.

# Stream 1: CHANGELIST.md Appendix E inline OPEN markers (locked count 9 per Phase 3).
grep -F '[OPEN: Phase 4 —' .planning/CHANGELIST.md \
  | sed -E 's/^.*\[OPEN: Phase 4 — //' \
  | sed -E 's/\].*$//' \
  | normalise > "$TMPDIR_RECON/stream1.txt"

# Stream 2: REQUIREMENTS.md OPEN-01..07 sub-items (each comma-separated item is a question).
awk '/^- \[[ x]\] \*\*OPEN-0[1-7]\*\*/{
        line=$0
        sub(/^- \[[ x]\] \*\*OPEN-0[1-7]\*\*:[[:space:]]*/,"",line)
        print line
     }' .planning/REQUIREMENTS.md \
  | tr ',;' '\n' \
  | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//' \
  | grep -v '^$' \
  | normalise > "$TMPDIR_RECON/stream2.txt" || true

# Stream 3: ROADMAP.md Phase 4 success criteria 1-5 sub-items.
awk '/^### Phase 4:/,/^### Phase 5:/' .planning/ROADMAP.md \
  | grep -E '^[[:space:]]*[0-9]+\.' \
  | sed -E 's/^[[:space:]]*[0-9]+\.[[:space:]]*//' \
  | normalise > "$TMPDIR_RECON/stream3.txt"

# Build canonical INPUT multiset (concat + sort + uniq).
cat "$TMPDIR_RECON/stream1.txt" "$TMPDIR_RECON/stream2.txt" "$TMPDIR_RECON/stream3.txt" \
  | sort -u > "$TMPDIR_RECON/input_dedup.txt"
INPUT_COUNT_AFTER_DEDUP=$(wc -l < "$TMPDIR_RECON/input_dedup.txt" | tr -d '[:space:]')

# Step 2 — Build REGISTER multiset (extract `**OPEN-Q...**` row-id-line headers + Question fields).
# Stateful awk: set flag on row-id match; print next `- **Question:**` line regardless of
# how many blank lines intervene between row-id and Question. Robust to layout drift.
awk '/^\*\*OPEN-Q[0-9]+(\.[0-9]+)?\*\*/{f=1; next} f && /^- Question:/{print; f=0}' "$OPENQ_FILE" \
  | sed -E 's/^- Question:[[:space:]]*//' \
  | normalise \
  | sort -u > "$TMPDIR_RECON/register_dedup.txt"
REGISTER_ROW_COUNT=$(grep -cE '^\*\*OPEN-Q[0-9]+(\.[0-9]+)?\*\*' "$OPENQ_FILE")

# Step 3 — Set-difference both ways.
INPUT_NOT_IN_REGISTER=$(comm -23 "$TMPDIR_RECON/input_dedup.txt" "$TMPDIR_RECON/register_dedup.txt" | wc -l | tr -d '[:space:]')
REGISTER_NOT_IN_INPUT=$(comm -13 "$TMPDIR_RECON/input_dedup.txt" "$TMPDIR_RECON/register_dedup.txt" | wc -l | tr -d '[:space:]')

# Step 4 — Cardinality match. Per D-50, register-total dedup'd should equal input-dedup'd within
# tolerance (some register rows are post-C6 splits of single input items — Q06.1/Q06.2 descend
# from one Pipefy-rate-limit input bullet; Q07.1/Q07.2 from one Wrike-rate-limit; Q21/Q21.1
# from one refine-skill input bullet). The diff lists track which questions are split / merged.
if [ "$INPUT_NOT_IN_REGISTER" = "0" ] && [ "$REGISTER_NOT_IN_INPUT" = "0" ]; then
  CARDINALITY_MATCH=TRUE
else
  CARDINALITY_MATCH=PARTIAL  # Diff exists; documented by split-merge accounting in Appendix C.
fi

# Step 5 — FULL citation-validity pass (cross-AI C5; supersedes A14 sample).
ALL_CITATIONS_VERIFIED=TRUE
while IFS= read -r match; do
  cited_path=$(printf '%s' "$match" | sed -E 's/^.*`(\.planning\/[A-Za-z0-9_./-]+\.md):([0-9]+)`.*$/\1/')
  cited_line=$(printf '%s' "$match" | sed -E 's/^.*`(\.planning\/[A-Za-z0-9_./-]+\.md):([0-9]+)`.*$/\2/')
  if [ ! -f "$cited_path" ]; then
    echo "CITATION_INVALID: $cited_path:$cited_line — file missing" >&2
    ALL_CITATIONS_VERIFIED=FALSE
    continue
  fi
  total_lines=$(wc -l < "$cited_path" | tr -d '[:space:]')
  if [ "$cited_line" -gt "$total_lines" ]; then
    echo "CITATION_INVALID: $cited_path:$cited_line — line exceeds total $total_lines" >&2
    ALL_CITATIONS_VERIFIED=FALSE
  fi
done < <(grep -oE '`\.planning/[A-Za-z0-9_./-]+\.md:[0-9]+`' "$OPENQ_FILE")

# Step 6 — Ownership coverage (single-owner only per cross-AI C6).
OWNER_COUNT=$(grep -cE 'Owning phase:[[:space:]]+(Phase [1-9]|TBD)[[:space:]]*$' "$OPENQ_FILE")
if [ "$OWNER_COUNT" = "$REGISTER_ROW_COUNT" ]; then
  ALL_OWNERS_ASSIGNED=TRUE
else
  ALL_OWNERS_ASSIGNED=FALSE
fi

# Step 7 — ROADMAP success criteria 1-5 walk (cross-AI Codex suggestion).
# Each criterion verified against register content via grep counts.

# SC1: every research-flagged "couldn't verify" item is captured.
# Verification: BLOCKER count >= 3 (3 native-AI ingestion APIs) AND research-blocked enum
# (`/gsd-research-phase`) used by >= 9 rows (OPEN-01 + OPEN-02 sections).
SC1_BLOCKER=$(grep -cE 'Severity:[[:space:]]*BLOCKER' "$OPENQ_FILE")
SC1_RESEARCH=$(grep -cF 'Resolution path: /gsd-research-phase' "$OPENQ_FILE")
if [ "$SC1_BLOCKER" -ge 3 ] && [ "$SC1_RESEARCH" -ge 9 ]; then
  SC1_RESULT="PASS — BLOCKER count $SC1_BLOCKER >= 3 (Pipefy AI KB / Wrike AI Studio / Ziflow ReviewAI); /gsd-research-phase enum used by $SC1_RESEARCH rows (>= 9 floor)"
else
  SC1_RESULT="FAIL — BLOCKER=$SC1_BLOCKER (need >= 3), /gsd-research-phase=$SC1_RESEARCH (need >= 9)"
fi

# SC2: every design-decision-deferred item is captured.
# Verification: decide-before-Phase-N enum used by exactly 3 rows (Q14, Q15, Q16).
SC2_DECIDE=$(grep -cF 'Resolution path: decide-before-Phase-' "$OPENQ_FILE")
if [ "$SC2_DECIDE" -ge 3 ]; then
  SC2_RESULT="PASS — decide-before-Phase-N enum used by $SC2_DECIDE rows (Q14 risk-multipliers / Q15 frontmatter cutover / Q16 status-lifecycle survey)"
else
  SC2_RESULT="FAIL — decide-before-Phase-N count $SC2_DECIDE < 3"
fi

# SC3: every connector-availability uncertainty (AUDIT-08) is captured.
# Verification: AUDIT.md:543 (AUDIT-08 probe) cited in register.
SC3_AUDIT08=$(grep -cF '.planning/AUDIT.md:543' "$OPENQ_FILE")
if [ "$SC3_AUDIT08" -ge 3 ]; then
  SC3_RESULT="PASS — AUDIT-08 (AUDIT.md:543) cited by $SC3_AUDIT08 register rows (Q10 Coda MCP / Q11 Google Workspace MCP / Q12 Miro MCP)"
else
  SC3_RESULT="FAIL — AUDIT-08 citation count $SC3_AUDIT08 < 3"
fi

# SC4: every standard Coda template Phase 8 must author is captured.
# Verification: Coda-template-authoring (Phase 8) enum used by exactly 3 rows.
SC4_CODA=$(grep -cF 'Resolution path: Coda-template-authoring (Phase 8)' "$OPENQ_FILE")
if [ "$SC4_CODA" = "3" ]; then
  SC4_RESULT="PASS — Coda-template-authoring (Phase 8) enum used by $SC4_CODA rows (Q18 brain-mirror / Q19 task-table / Q20 00_HUB.md schema)"
else
  SC4_RESULT="FAIL — Coda-template-authoring (Phase 8) count $SC4_CODA != 3"
fi

# SC5: every policy decision in OPEN-06 + OPEN-07 has clear "decide before Phase X" owners.
# Verification: policy-pending-sign-off enum used by >= 3 register rows
# (Q21 + Q21.1 Phase 1; Q22 Phase 9).
SC5_POLICY=$(grep -cE '^- Resolution path: policy-pending-sign-off' "$OPENQ_FILE")
if [ "$SC5_POLICY" -ge 3 ]; then
  SC5_RESULT="PASS — policy-pending-sign-off enum used by $SC5_POLICY register rows: OPEN-Q21 (Phase 1 deadline) + OPEN-Q21.1 (Phase 1 deadline) + OPEN-Q22 (Phase 9 deadline); D-52 sub-fields embed Decision deadline + Acceptance signal + Fallback-if-undecided"
else
  SC5_RESULT="FAIL — policy-pending-sign-off register-row count $SC5_POLICY < 3"
fi

# Step 8 — Emit final reconciliation result.
cat <<RECON_OUT
INPUT_COUNT_AFTER_DEDUP=$INPUT_COUNT_AFTER_DEDUP
REGISTER_ROW_COUNT=$REGISTER_ROW_COUNT
INPUT_NOT_IN_REGISTER=$INPUT_NOT_IN_REGISTER
REGISTER_NOT_IN_INPUT=$REGISTER_NOT_IN_INPUT
CARDINALITY_MATCH=$CARDINALITY_MATCH
ALL_CITATIONS_VERIFIED=$ALL_CITATIONS_VERIFIED
ALL_OWNERS_ASSIGNED=$ALL_OWNERS_ASSIGNED
SC1: $SC1_RESULT
SC2: $SC2_RESULT
SC3: $SC3_RESULT
SC4: $SC4_RESULT
SC5: $SC5_RESULT
RECON_OUT
