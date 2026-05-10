#!/usr/bin/env bash
# phase5-structure-check.sh — structural verifier for Phase 5 deliverables
#
# Comment-vs-code policy (carried from Phase 4 openquestions-structure-check.sh):
#   - Sentinel-token matches use `grep -qF` (literal-string, case-sensitive)
#   - Pattern matches use `grep -cE` / `grep -qE` (case-sensitive extended regex)
#   - Script does NOT use case-insensitive matching. GNU grep 3.0 on Git Bash for Windows
#     aborts (SIGABRT exit 134) on `-i` against UTF-8 multibyte content; AUDIT-07 sentinel
#     tokens ("test sheet", "lenient") are deterministic lowercase in the source files, so
#     case-sensitive matching is sufficient and portable.
#
# G-2 convention (Gemini LOW): every absence-check (`! grep ...`) excludes scripts/, *.sh,
# and *~ to prevent the script's own assertion text from triggering false-positive failures.
# Concretely, every `grep -r` / `grep -rn` line that searches for forbidden tokens carries
# all three of:
#   --exclude-dir=scripts
#   --exclude="*.sh"
#   --exclude="*~"
#
# Phase 5 cross-AI review fixes (per .planning/phases/05-foundations/05-REVIEWS.md):
#   - C-2 (Codex HIGH): A35/A36 absence checks, plus future-facing phrasing assertion in A35
#   - W-01 / W-02: VALIDATION.md path correction + Wave 0 deferral footnote (asserted in A?-Validation)
#   - W-04: B.3 default = "13 stages" with future-facing phrasing — A35 enforces both anchors
#
# Invocation modes:
#   bash phase5-structure-check.sh              # full suite (~40 assertions)
#   bash phase5-structure-check.sh --quick      # smoke test (subset)
#   bash phase5-structure-check.sh --section <FOUND-NN | name>
#
set -euo pipefail

ROOT_FOR_DOCS="$(pwd)"  # informational only

fail() { echo "FAIL: $1" >&2; exit 1; }
pass() { echo "PASS: $1"; }

# Parse args
MODE="full"
SECTION=""
while [ $# -gt 0 ]; do
  case "$1" in
    --quick)   MODE="quick"; shift ;;
    --section) SECTION="${2:-}"; shift 2 ;;
    --help|-h)
      cat <<'USAGE'
Usage: phase5-structure-check.sh [--quick] [--section <FOUND-NN | name>]

  --quick                run smoke-test subset (FOUND-01, FOUND-07, FOUND-11)
  --section <name>       run a specific section (e.g. FOUND-07, FOUND-11, FOUND-13)
  (no flag)              run full suite (~40 assertions)
USAGE
      exit 0
      ;;
    *) echo "Unknown arg: $1" >&2; exit 2 ;;
  esac
done

run_section() {
  local s="$1"
  if [ -z "$SECTION" ]; then
    if [ "$MODE" = "quick" ]; then
      case "$s" in FOUND-01|FOUND-07|FOUND-11) return 0 ;; *) return 1 ;; esac
    fi
    return 0
  fi
  [ "$s" = "$SECTION" ]
}

# ============================================================================
# A1..A4 — FOUND-01 safety-rules.md (canonical hard-rules SoT)
# ============================================================================
if run_section FOUND-01; then
  # A1
  test -f dydx-delivery/references/safety-rules.md \
    || fail "FOUND-01 A1: dydx-delivery/references/safety-rules.md missing"
  pass "FOUND-01 A1: safety-rules.md exists"

  # A2 — CRIT-5 Coda authorising clause present
  grep -qF "Coda writes ARE permitted" dydx-delivery/references/safety-rules.md \
    || fail "FOUND-01 A2: CRIT-5 'Coda writes ARE permitted' clause missing"
  pass "FOUND-01 A2: CRIT-5 Coda clause present"

  # A3 — DESIGN-03 cross-reference
  grep -qF "DESIGN-03" dydx-delivery/references/safety-rules.md \
    || fail "FOUND-01 A3: DESIGN-03 cross-ref missing"
  pass "FOUND-01 A3: DESIGN-03 cross-ref present"

  # A4 — at least 10 numbered H2 sections
  h2_count=$(grep -cE "^## [0-9]+\. " dydx-delivery/references/safety-rules.md || true)
  [ "$h2_count" -ge 10 ] \
    || fail "FOUND-01 A4: numbered-H2 count $h2_count < 10"
  pass "FOUND-01 A4: $h2_count numbered-H2 sections (>=10)"
fi

# ============================================================================
# A5..A8 — FOUND-02 stage-numbering.md
# ============================================================================
if run_section FOUND-02; then
  # A5
  test -f dydx-delivery/references/stage-numbering.md \
    || fail "FOUND-02 A5: stage-numbering.md missing"
  pass "FOUND-02 A5: stage-numbering.md exists"

  # A6 — both old and new prefixes documented (lenient-mode contract)
  grep -qF "00_discovery_" dydx-delivery/references/stage-numbering.md \
    || fail "FOUND-02 A6: old-prefix '00_discovery_' missing from migration table"
  grep -qF "02_discovery_" dydx-delivery/references/stage-numbering.md \
    || fail "FOUND-02 A6: new-prefix '02_discovery_' missing"
  pass "FOUND-02 A6: both 00_discovery_ and 02_discovery_ prefixes documented"

  # A7 — substage example
  grep -qF "04a_fnspec-platform_" dydx-delivery/references/stage-numbering.md \
    || fail "FOUND-02 A7: substage '04a_fnspec-platform_' not documented"
  pass "FOUND-02 A7: substage 04a_fnspec-platform_ documented"

  # A8 — OPEN-Q15 lenient-mode authority cited
  grep -qF "OPEN-Q15" dydx-delivery/references/stage-numbering.md \
    || fail "FOUND-02 A8: OPEN-Q15 lenient-mode authority not cited"
  pass "FOUND-02 A8: OPEN-Q15 cited"
fi

# ============================================================================
# A9..A12 — FOUND-03 frontmatter-scheme.md
# ============================================================================
if run_section FOUND-03; then
  # A9
  test -f dydx-delivery/references/frontmatter-scheme.md \
    || fail "FOUND-03 A9: frontmatter-scheme.md missing"
  pass "FOUND-03 A9: frontmatter-scheme.md exists"

  # A10 — lenient mode documented (lowercase 'lenient' deterministic in source)
  grep -qF "lenient" dydx-delivery/references/frontmatter-scheme.md \
    || fail "FOUND-03 A10: lenient-mode contract missing"
  pass "FOUND-03 A10: lenient-mode contract present"

  # A11 — client_review status retained
  grep -qF "client_review" dydx-delivery/references/frontmatter-scheme.md \
    || fail "FOUND-03 A11: client_review status missing"
  pass "FOUND-03 A11: client_review status present"

  # A12 — frontmatter_version: 2 declared
  grep -qF "frontmatter_version: 2" dydx-delivery/references/frontmatter-scheme.md \
    || fail "FOUND-03 A12: frontmatter_version: 2 declaration missing"
  pass "FOUND-03 A12: frontmatter_version: 2 declared"
fi

# ============================================================================
# A13..A14 — FOUND-04 glossary.md
# ============================================================================
if run_section FOUND-04; then
  # A13
  test -f dydx-delivery/references/glossary.md \
    || fail "FOUND-04 A13: glossary.md missing"
  pass "FOUND-04 A13: glossary.md exists"

  # A14 — FOUND-13 Wave 4 ratified entries (provisional markers stripped, terms canonical)
  grep -qF "Claude for Chrome" dydx-delivery/references/glossary.md \
    || fail "FOUND-04 A14: 'Claude for Chrome' entry missing"
  grep -qF "Wrike host field" dydx-delivery/references/glossary.md \
    || fail "FOUND-04 A14: 'Wrike host field' entry missing"
  pass "FOUND-04 A14: both FOUND-13 ratified entries present"
fi

# ============================================================================
# A15..A17 — FOUND-05 hard-rules dedup (Wave 2)
# ============================================================================
if run_section FOUND-05; then
  # A15 — pointer wording in 3 files
  pointer_files=(
    dydx-delivery/skills/execute-tests/SKILL.md
    dydx-delivery/skills/generate-test-plan/references/test-plan-template.md
    dydx-delivery/README.md
  )
  pointer_hits=0
  for f in "${pointer_files[@]}"; do
    if grep -qF "See \`dydx-delivery/references/safety-rules.md\` for the canonical ruleset" "$f"; then
      pointer_hits=$((pointer_hits + 1))
    fi
  done
  [ "$pointer_hits" = "3" ] \
    || fail "FOUND-05 A15: pointer-wording present in $pointer_hits/3 files (expected 3)"
  pass "FOUND-05 A15: pointer wording present in all 3 files"

  # A16 — collapse stub at execute-tests/references/safety-rules.md
  test -f dydx-delivery/skills/execute-tests/references/safety-rules.md \
    || fail "FOUND-05 A16: collapse-stub safety-rules.md missing"
  grep -qF "Pointer-only" dydx-delivery/skills/execute-tests/references/safety-rules.md \
    || fail "FOUND-05 A16: 'Pointer-only' marker missing in collapse stub"
  pass "FOUND-05 A16: collapse-stub Pointer-only marker present"

  # A17 — zero based_on_* old-prefix survivors (G-2: exclude scripts/, *.sh, *~)
  if grep -rn --exclude-dir=scripts --exclude="*.sh" --exclude="*~" \
       "based_on_discovery: 00_discovery_\|based_on_sow: 01_sow_\|based_on_functional_spec: 02_functional-spec_\|based_on_technical_spec: 03_technical-spec_\|based_on_test_plan: test-plan_v" \
       dydx-delivery/skills/ >/dev/null 2>&1; then
    fail "FOUND-05 A17: legacy based_on_* old-prefix survivors detected in dydx-delivery/skills/"
  fi
  pass "FOUND-05 A17: zero based_on_* old-prefix survivors"
fi

# ============================================================================
# A18..A20 — FOUND-06 file renumbering (Wave 2)
# ============================================================================
if run_section FOUND-06; then
  # A18 — positive cover for new prefix '02_discovery_v'
  hits18=$(grep -rcE "02_discovery_v" --exclude-dir=scripts --exclude="*.sh" --exclude="*~" dydx-delivery/ 2>/dev/null \
    | awk -F: '{s+=$2} END{print s+0}')
  [ "$hits18" -ge 2 ] \
    || fail "FOUND-06 A18: '02_discovery_v' positive-cover hits $hits18 < 2"
  pass "FOUND-06 A18: '02_discovery_v' positive cover ($hits18 hits)"

  # A19 — positive cover for '08b_test-plan_v'
  hits19=$(grep -rcE "08b_test-plan_v" --exclude-dir=scripts --exclude="*.sh" --exclude="*~" dydx-delivery/ 2>/dev/null \
    | awk -F: '{s+=$2} END{print s+0}')
  [ "$hits19" -ge 3 ] \
    || fail "FOUND-06 A19: '08b_test-plan_v' positive-cover hits $hits19 < 3"
  pass "FOUND-06 A19: '08b_test-plan_v' positive cover ($hits19 hits)"

  # A20 — Stage-N self-label updated
  grep -qF "Stage 8b of the dydx-delivery pipeline" dydx-delivery/skills/generate-test-plan/references/test-plan-template.md \
    || fail "FOUND-06 A20: 'Stage 8b of the dydx-delivery pipeline' self-label missing"
  pass "FOUND-06 A20: Stage 8b self-label present"
fi

# ============================================================================
# A21..A26 — FOUND-07 manifest 2.0.0 sync (Wave 3)
# ============================================================================
if run_section FOUND-07; then
  # A21
  v_plugin=$(jq -r '.version' dydx-delivery/.claude-plugin/plugin.json)
  [ "$v_plugin" = "2.0.0" ] \
    || fail "FOUND-07 A21: plugin.json .version = $v_plugin (expected 2.0.0)"
  pass "FOUND-07 A21: plugin.json .version = 2.0.0"

  # A22
  v_meta=$(jq -r '.metadata.version' .claude-plugin/marketplace.json)
  [ "$v_meta" = "2.0.0" ] \
    || fail "FOUND-07 A22: marketplace.json .metadata.version = $v_meta (expected 2.0.0)"
  pass "FOUND-07 A22: marketplace.json .metadata.version = 2.0.0"

  # A23
  v_plug0=$(jq -r '.plugins[0].version' .claude-plugin/marketplace.json)
  [ "$v_plug0" = "2.0.0" ] \
    || fail "FOUND-07 A23: marketplace.json .plugins[0].version = $v_plug0 (expected 2.0.0)"
  pass "FOUND-07 A23: marketplace.json .plugins[0].version = 2.0.0"

  # A24 — UAT-3.1 plugin email unchanged
  e_plugin=$(jq -r '.author.email' dydx-delivery/.claude-plugin/plugin.json)
  [ "$e_plugin" = "jasonmichaelb@gmail.com" ] \
    || fail "FOUND-07 A24: plugin.json .author.email = $e_plugin (UAT-3.1 expects jasonmichaelb@gmail.com)"
  pass "FOUND-07 A24: plugin.json author.email unchanged (UAT-3.1)"

  # A25 — UAT-3.1 marketplace email unchanged
  e_owner=$(jq -r '.owner.email' .claude-plugin/marketplace.json)
  [ "$e_owner" = "jasonmichaelb@gmail.com" ] \
    || fail "FOUND-07 A25: marketplace.json .owner.email = $e_owner (UAT-3.1 expects jasonmichaelb@gmail.com)"
  pass "FOUND-07 A25: marketplace.json owner.email unchanged (UAT-3.1)"

  # A26 — cross-manifest equality
  [ "$v_plugin" = "$v_plug0" ] \
    || fail "FOUND-07 A26: plugin.json .version ($v_plugin) != marketplace.json .plugins[0].version ($v_plug0)"
  pass "FOUND-07 A26: cross-manifest version equality ($v_plugin == $v_plug0)"
fi

# ============================================================================
# A27..A28 — FOUND-08 LICENSE
# ============================================================================
if run_section FOUND-08; then
  # A27
  test -f LICENSE || fail "FOUND-08 A27: LICENSE missing"
  pass "FOUND-08 A27: LICENSE exists"

  # A28 — byte-exact content (LF-only; W-03 cross-platform CR check)
  if diff <(printf 'All rights reserved.\nNot licensed for redistribution.\n') LICENSE >/dev/null 2>&1; then
    pass "FOUND-08 A28: LICENSE content byte-exact"
  else
    fail "FOUND-08 A28: LICENSE content does not match canonical 2-line text (or has CR pollution)"
  fi
  # W-03 — explicit CR absence check (cross-platform safety)
  if grep -lU $'\r' LICENSE >/dev/null 2>&1; then
    fail "FOUND-08 A28: LICENSE contains CR characters (W-03 — must be LF-only)"
  fi
  pass "FOUND-08 A28: LICENSE is LF-only (no CR)"
fi

# ============================================================================
# A29..A31 — FOUND-09 scaffold dirs
# ============================================================================
if run_section FOUND-09; then
  # A29
  for d in dydx-delivery/commands dydx-delivery/agents dydx-delivery/hooks; do
    test -d "$d" || fail "FOUND-09 A29: scaffold dir $d missing"
  done
  pass "FOUND-09 A29: all 3 scaffold dirs present"

  # A30 — each contains exactly .gitkeep only
  # (grep -v exits 1 when no lines match; pipefail-safe via `|| true`)
  for d in dydx-delivery/commands dydx-delivery/agents dydx-delivery/hooks; do
    extra=$(ls -1A "$d" | { grep -v '\.gitkeep' || true; } | wc -l | tr -d ' ')
    [ "$extra" = "0" ] || fail "FOUND-09 A30: $d has $extra non-.gitkeep entries"
  done
  pass "FOUND-09 A30: all scaffold dirs contain only .gitkeep"

  # A31 — each .gitkeep is zero-byte
  for d in dydx-delivery/commands dydx-delivery/agents dydx-delivery/hooks; do
    sz=$(wc -c < "$d/.gitkeep" | tr -d ' ')
    [ "$sz" -eq 0 ] || fail "FOUND-09 A31: $d/.gitkeep is $sz bytes (expected 0)"
  done
  pass "FOUND-09 A31: all .gitkeep files are zero-byte"
fi

# ============================================================================
# A32..A34 — FOUND-10 connector matrix
# ============================================================================
if run_section FOUND-10; then
  # A32
  test -f dydx-delivery/references/connector-matrix.md \
    || fail "FOUND-10 A32: connector-matrix.md missing"
  pass "FOUND-10 A32: connector-matrix.md exists"

  # A33 — all 6 connectors named
  for c in "Coda MCP" "Google Workspace MCP" "Miro MCP" "Pipefy API" "Wrike API" "Ziflow API"; do
    grep -qF "$c" dydx-delivery/references/connector-matrix.md \
      || fail "FOUND-10 A33: connector '$c' missing"
  done
  pass "FOUND-10 A33: all 6 connectors named"

  # A34 — UAT-6.1 + UAT-3.5 locks honoured (G-2: exclude scripts/, *.sh, *~)
  if grep -F --exclude-dir=scripts --exclude="*.sh" --exclude="*~" \
       "native_ai_path: api" dydx-delivery/references/connector-matrix.md >/dev/null 2>&1; then
    fail "FOUND-10 A34: 'native_ai_path: api' present (UAT-6.1 lock violated)"
  fi
  if grep -F --exclude-dir=scripts --exclude="*.sh" --exclude="*~" \
       "Pipefy MCP" dydx-delivery/references/connector-matrix.md >/dev/null 2>&1; then
    fail "FOUND-10 A34: 'Pipefy MCP' present (UAT-3.5 lock — Pipefy is API-only)"
  fi
  pass "FOUND-10 A34: UAT-6.1 + UAT-3.5 locks honoured"
fi

# ============================================================================
# A35..A36 — FOUND-11 cosmetic fixes
# ============================================================================
if run_section FOUND-11; then
  # A35 — B.2: 'test sheet' fully removed (lowercase deterministic); G-2 exclusions for safety
  if grep -F --exclude-dir=scripts --exclude="*.sh" --exclude="*~" \
       "test sheet" README.md >/dev/null 2>&1; then
    fail "FOUND-11 A35: B.2 — 'test sheet' wording still present in README.md"
  fi
  pass "FOUND-11 A35: B.2 'test sheet' wording removed from root README"

  # B.3 numeric anchor + future-facing token (C-2 Codex HIGH fix)
  grep -qE "13.stage|13 stages" README.md \
    || fail "FOUND-11 A35b: B.3 numeric-13 anchor missing in root README"
  grep -qE "targets|roadmap|v2\.x" README.md \
    || fail "FOUND-11 A35c: B.3 future-facing token (targets/roadmap/v2.x) missing in root README"
  pass "FOUND-11 A35b/c: B.3 numeric-13 + future-facing tokens both present (C-2 fix)"

  # B.3 same-commit consistency: ROADMAP SC-4 + REQUIREMENTS FOUND-11 verbatim still '13'
  grep -qF "B.3 pipeline-step count corrected to 13" .planning/REQUIREMENTS.md \
    || fail "FOUND-11 A35d: REQUIREMENTS FOUND-11 verbatim '13' text drifted"
  grep -qF "B.3 pipeline-step count corrected to 13" .planning/ROADMAP.md \
    || fail "FOUND-11 A35e: ROADMAP SC-4 verbatim '13' text drifted"
  pass "FOUND-11 A35d/e: ROADMAP SC-4 + REQUIREMENTS FOUND-11 verbatim '13' preserved"

  # A36 — B.1: changelog truncation closed (no line ends in 'now c'); G-2 exclusions
  if grep -E --exclude-dir=scripts --exclude="*.sh" --exclude="*~" \
       " now c$" dydx-delivery/README.md >/dev/null 2>&1; then
    fail "FOUND-11 A36: B.1 truncation still present (line ends in ' now c')"
  fi
  pass "FOUND-11 A36: B.1 changelog truncation closed"
fi

# ============================================================================
# A37 — FOUND-12 status survey
# ============================================================================
if run_section FOUND-12; then
  test -f .planning/phases/05-foundations/05-STATUS-SURVEY.md \
    || fail "FOUND-12 A37: 05-STATUS-SURVEY.md missing"
  grep -qE "no drift|drift detected" .planning/phases/05-foundations/05-STATUS-SURVEY.md \
    || fail "FOUND-12 A37: drift verdict ('no drift' or 'drift detected') missing"
  pass "FOUND-12 A37: status survey present + drift verdict recorded"
fi

# ============================================================================
# A38..A40 — FOUND-13 OPEN-Q row flips + B.5 cross-check
# ============================================================================
if run_section FOUND-13; then
  # A38 — every Q-id has 'Status: decided' within its row block
  for q in Q06.1 Q07.1 Q09 Q10 Q11 Q12 Q13 Q25; do
    found=$(awk -v q="OPEN-${q}" 'BEGIN{f=0; n=0} index($0,q){f=1; n=0} f && /Status: decided/{print "yes"; exit} f{n++; if(n>30){f=0}}' .planning/OPEN-QUESTIONS.md)
    [ "$found" = "yes" ] \
      || fail "FOUND-13 A38: OPEN-${q} 'Status: decided' missing"
  done
  pass "FOUND-13 A38: all 8 OPEN-Q row flips show 'Status: decided'"

  # A39 — connector-matrix.md cited at least 8 times
  cm_cites=$(grep -c "dydx-delivery/references/connector-matrix.md" .planning/OPEN-QUESTIONS.md || true)
  [ "$cm_cites" -ge 8 ] \
    || fail "FOUND-13 A39: connector-matrix.md cited only $cm_cites times (expected >=8)"
  pass "FOUND-13 A39: connector-matrix.md cited $cm_cites times in OPEN-QUESTIONS.md"

  # A40 — B.5 sentinel: UAT-3.1 plugin email unchanged (intentional duplicate of A24)
  e_plugin_b5=$(jq -r '.author.email' dydx-delivery/.claude-plugin/plugin.json)
  [ "$e_plugin_b5" = "jasonmichaelb@gmail.com" ] \
    || fail "FOUND-13 A40: B.5 plugin.json author.email mutated ($e_plugin_b5 != jasonmichaelb@gmail.com)"
  pass "FOUND-13 A40: B.5 cross-wave invariant honoured (plugin.json email unchanged)"
fi

echo "OK: all structural checks passed"
exit 0
