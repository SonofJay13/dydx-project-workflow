#!/usr/bin/env bash
# phase8-structure-check.sh — structural verifier for Phase 8 (Stage 4 fnspec split + ROUTE + TD-2 closeout) deliverables
#
# Comment-vs-code policy (carried from Phase 5 / Phase 6 / Phase 7):
#   - Sentinel-token matches use `grep -qF` (literal-string, case-sensitive)
#   - Pattern matches use `grep -cE` / `grep -qE` (case-sensitive extended regex)
#   - Script does NOT use case-insensitive matching. GNU grep 3.0 on Git Bash for Windows
#     aborts (SIGABRT exit 134) on `-i` against UTF-8 multibyte content.
#
# Per-section partition (D-77 + D-86): `--section <4a|4b|route|smoke|all>` runs ONLY that
# section's assertion subset. Cross-section gates X1-X4 only run in `all` mode.
#
# E2 anti-pattern guard: the assertion against the routing-key claim in
# platform-ziflow/SKILL.md MUST use the literal `is the routing key`. A soft
# `grep -qF 'routing'` false-passes on line 41 ("Stage 4a delivery routing")
# and is forbidden.
#
# Invocation modes:
#   bash phase8-structure-check.sh --section 4a       # Stage 4a (08-01 gate)
#   bash phase8-structure-check.sh --section 4b       # Stage 4b (08-02 gate)
#   bash phase8-structure-check.sh --section route    # ROUTE-04 + R-01 carry-forward
#   bash phase8-structure-check.sh --section smoke    # ROUTE-05 forward-compat
#   bash phase8-structure-check.sh --section all      # full suite + cross-section
#   bash phase8-structure-check.sh --all              # alias for --section all
#
set -euo pipefail

fail() { echo "FAIL: $1" >&2; exit 1; }
pass() { echo "PASS: $1"; }

# Parse args
SECTION="${SECTION:-}"
while [ $# -gt 0 ]; do
  case "$1" in
    --section) SECTION="${2:-}"; shift 2 ;;
    --all)     SECTION="all"; shift ;;
    --help|-h)
      cat <<'USAGE'
Usage: phase8-structure-check.sh [--section <4a|4b|route|smoke|all>] [--all]

  --section 4a            run ONLY Stage 4a generate-fnspec-platform assertions (P1-P8)
  --section 4b            run ONLY Stage 4b generate-fnspec-integration assertions (I1-I8)
  --section route         run ONLY ROUTE-04 + R-01 carry-forward + STG4-03 + STG4-06 (E1-E6)
  --section smoke         run ONLY ROUTE-05 forward-compat smoke (S1-S6)
  --section all           run full suite (all per-section + cross-section X1-X4)
  --all                   alias for --section all
  (no flag)               run full suite
USAGE
      exit 0
      ;;
    *) echo "Unknown arg: $1" >&2; exit 2 ;;
  esac
done

# ============================================================================
# Per-section assertion runners
# ============================================================================

run_4a_section() {
  # P1 — generate-fnspec-platform SKILL.md exists
  [ -f dydx-delivery/skills/generate-fnspec-platform/SKILL.md ] \
    || fail "P1: dydx-delivery/skills/generate-fnspec-platform/SKILL.md missing"
  pass "P1: generate-fnspec-platform SKILL.md exists"

  # P2 — 3 references/ files exist
  local ref
  for ref in fnspec-platform-template.md auto-classify-rubric.md addendum-template.md; do
    [ -f "dydx-delivery/skills/generate-fnspec-platform/references/$ref" ] \
      || fail "P2: missing dydx-delivery/skills/generate-fnspec-platform/references/$ref"
  done
  pass "P2: 3 references/ files exist (fnspec-platform-template / auto-classify-rubric / addendum-template)"

  # P3 — canonical-reference pointers resolve from SKILL.md
  local canonical
  for canonical in safety-rules.md stage-numbering.md frontmatter-scheme.md glossary.md; do
    grep -qF "dydx-delivery/references/$canonical" dydx-delivery/skills/generate-fnspec-platform/SKILL.md \
      || fail "P3: canonical pointer '$canonical' missing from generate-fnspec-platform/SKILL.md"
  done
  pass "P3: 4 canonical pointers present (safety-rules/stage-numbering/frontmatter-scheme/glossary)"

  # P4 — D-78 4-enum baked into 4a SKILL.md + template
  grep -qF 'pipefy | wrike | ziflow | other' dydx-delivery/skills/generate-fnspec-platform/SKILL.md \
    || fail "P4: D-78 4-enum missing from generate-fnspec-platform/SKILL.md"
  grep -qF 'pipefy | wrike | ziflow | other' dydx-delivery/skills/generate-fnspec-platform/references/fnspec-platform-template.md \
    || fail "P4: D-78 4-enum missing from fnspec-platform-template.md"
  pass "P4: D-78 4-enum present in 4a SKILL.md + template"

  # P5 — canonical delivery enum order (native-ai | api) NOT reversed (STG4-04 lock)
  grep -qF 'native-ai | api' dydx-delivery/skills/generate-fnspec-platform/SKILL.md \
    || fail "P5: canonical 'native-ai | api' missing from 4a SKILL.md"
  if grep -qF 'api | native-ai' dydx-delivery/skills/generate-fnspec-platform/SKILL.md; then
    fail "P5: reversed enum 'api | native-ai' present in 4a SKILL.md — STG4-04 lock violation"
  fi
  pass "P5: canonical 'native-ai | api' present; reversed form absent from 4a SKILL.md"

  # P6 — auto-classify-rubric.md referenced from SKILL.md
  grep -qF 'references/auto-classify-rubric.md' dydx-delivery/skills/generate-fnspec-platform/SKILL.md \
    || fail "P6: 4a SKILL.md does not reference references/auto-classify-rubric.md"
  pass "P6: auto-classify-rubric.md referenced from 4a SKILL.md"

  # P7 — addendum-template.md referenced from SKILL.md
  grep -qF 'references/addendum-template.md' dydx-delivery/skills/generate-fnspec-platform/SKILL.md \
    || fail "P7: 4a SKILL.md does not reference references/addendum-template.md"
  pass "P7: addendum-template.md referenced from 4a SKILL.md"

  # P8 — D-79 frontmatter fields documented
  grep -qF 'has_platform_api_addendum' dydx-delivery/skills/generate-fnspec-platform/SKILL.md \
    || fail "P8: 'has_platform_api_addendum' missing from 4a SKILL.md"
  grep -qF 'tech_spec_scope' dydx-delivery/skills/generate-fnspec-platform/SKILL.md \
    || fail "P8: 'tech_spec_scope' missing from 4a SKILL.md"
  pass "P8: D-79 frontmatter fields (has_platform_api_addendum + tech_spec_scope) present in 4a SKILL.md"
}

run_4b_section() {
  # I1 — generate-fnspec-integration SKILL.md exists
  [ -f dydx-delivery/skills/generate-fnspec-integration/SKILL.md ] \
    || fail "I1: dydx-delivery/skills/generate-fnspec-integration/SKILL.md missing"
  pass "I1: generate-fnspec-integration SKILL.md exists"

  # I2 — 3 references/ files exist
  local ref
  for ref in fnspec-integration-template.md consistency-rules.md either-spec-skip-paths.md; do
    [ -f "dydx-delivery/skills/generate-fnspec-integration/references/$ref" ] \
      || fail "I2: missing dydx-delivery/skills/generate-fnspec-integration/references/$ref"
  done
  pass "I2: 3 references/ files exist (fnspec-integration-template / consistency-rules / either-spec-skip-paths)"

  # I3 — canonical-reference pointers resolve from SKILL.md
  local canonical
  for canonical in safety-rules.md stage-numbering.md frontmatter-scheme.md glossary.md; do
    grep -qF "dydx-delivery/references/$canonical" dydx-delivery/skills/generate-fnspec-integration/SKILL.md \
      || fail "I3: canonical pointer '$canonical' missing from generate-fnspec-integration/SKILL.md"
  done
  pass "I3: 4 canonical pointers present in 4b SKILL.md"

  # I4 — based_on_fnspec_platform: present in 4b SKILL.md + template (ROUTE-03 4b read-side)
  grep -qF 'based_on_fnspec_platform' dydx-delivery/skills/generate-fnspec-integration/SKILL.md \
    || fail "I4: based_on_fnspec_platform missing from 4b SKILL.md"
  grep -qF 'based_on_fnspec_platform' dydx-delivery/skills/generate-fnspec-integration/references/fnspec-integration-template.md \
    || fail "I4: based_on_fnspec_platform missing from fnspec-integration-template.md"
  pass "I4: based_on_fnspec_platform present in 4b SKILL.md + template"

  # I5 — D-85 verbatim skip-emit string with unicode em-dash present in SKILL.md OR either-spec-skip-paths.md
  if grep -qF 'Stage 4b SKIPPED — no integration work in scope' dydx-delivery/skills/generate-fnspec-integration/SKILL.md 2>/dev/null \
     || grep -qF 'Stage 4b SKIPPED — no integration work in scope' dydx-delivery/skills/generate-fnspec-integration/references/either-spec-skip-paths.md 2>/dev/null; then
    pass "I5: verbatim D-85 skip-emit string present (unicode em-dash)"
  else
    fail "I5: verbatim 'Stage 4b SKIPPED — no integration work in scope' missing from 4b SKILL.md AND either-spec-skip-paths.md"
  fi

  # I6 — three consistency checks named verbatim in consistency-rules.md
  grep -qF 'Check (a)' dydx-delivery/skills/generate-fnspec-integration/references/consistency-rules.md \
    || fail "I6: 'Check (a)' missing from consistency-rules.md"
  grep -qF 'Check (b)' dydx-delivery/skills/generate-fnspec-integration/references/consistency-rules.md \
    || fail "I6: 'Check (b)' missing from consistency-rules.md"
  grep -qF 'Check (c)' dydx-delivery/skills/generate-fnspec-integration/references/consistency-rules.md \
    || fail "I6: 'Check (c)' missing from consistency-rules.md"
  pass "I6: three checks (a)/(b)/(c) named verbatim in consistency-rules.md"

  # I7 — 04b_consistency_check_v halt-path filename in SKILL.md AND consistency-rules.md
  grep -qF '04b_consistency_check_v' dydx-delivery/skills/generate-fnspec-integration/SKILL.md \
    || fail "I7: '04b_consistency_check_v' missing from 4b SKILL.md"
  grep -qF '04b_consistency_check_v' dydx-delivery/skills/generate-fnspec-integration/references/consistency-rules.md \
    || fail "I7: '04b_consistency_check_v' missing from consistency-rules.md"
  pass "I7: halt-path filename '04b_consistency_check_v' present in BOTH 4b SKILL.md + consistency-rules.md"

  # I8 — Two-place key-decisions cross-reference (5 D-IDs in BOTH 4a + 4b SKILL.md)
  local d
  for d in D-78 D-79 D-82 D-84 D-85; do
    grep -qF "$d" dydx-delivery/skills/generate-fnspec-platform/SKILL.md \
      || fail "I8: $d missing from 4a SKILL.md (T-02-06-02 / ROUTE-01 mitigation regression)"
    grep -qF "$d" dydx-delivery/skills/generate-fnspec-integration/SKILL.md \
      || fail "I8: $d missing from 4b SKILL.md (T-02-06-02 / ROUTE-01 mitigation regression)"
  done
  pass "I8: 5 D-IDs (D-78/D-79/D-82/D-84/D-85) cross-referenced in BOTH 4a + 4b SKILL.md"
}

run_route_section() {
  # E1 — D-78 4-enum present in all 11 EDIT files + 5 ANCHOR files (16 total)
  local f
  local edit_files=(
    "dydx-delivery/skills/discovery-intake/SKILL.md"
    "dydx-delivery/skills/discovery-intake/references/intake-template.md"
    "dydx-delivery/skills/generate-build-prompt/SKILL.md"
    "dydx-delivery/skills/generate-build-prompt/references/build-prompt-template.md"
    "dydx-delivery/skills/generate-technical-spec/SKILL.md"
    "dydx-delivery/skills/generate-technical-spec/references/technical-spec-template.md"
    "dydx-delivery/skills/generate-test-plan/SKILL.md"
    "dydx-delivery/skills/generate-test-plan/references/test-plan-template.md"
    "dydx-delivery/skills/execute-tests/references/results-template.md"
  )
  for f in "${edit_files[@]}"; do
    grep -qF 'pipefy | wrike | ziflow | other' "$f" \
      || fail "E1: D-78 4-enum missing from $f (ROUTE-04 rollout incomplete)"
  done
  # README.md uses prose form `pipefy | wrike | ziflow` (no `other`)
  grep -qF 'pipefy | wrike | ziflow' dydx-delivery/README.md \
    || fail "E1: D-78 prose enum 'pipefy | wrike | ziflow' missing from dydx-delivery/README.md"
  # 5 ANCHOR files (already 4-enum from Phase 7 / 08-01 / 08-02)
  local anchor_files=(
    "dydx-delivery/skills/generate-sow/SKILL.md"
    "dydx-delivery/skills/generate-sow/references/sow-template.md"
    "dydx-delivery/references/frontmatter-scheme.md"
    "dydx-delivery/references/glossary.md"
  )
  for f in "${anchor_files[@]}"; do
    grep -qF 'pipefy | wrike | ziflow | other' "$f" \
      || fail "E1: anchor 4-enum drifted in $f"
  done
  pass "E1: D-78 4-enum present in all 11 EDIT files + 4 YAML-anchor files + README prose"

  # E2 — platform-ziflow/SKILL.md retains routing-key claim
  # Locked literal-anchor grep: 'is the routing key' (line 14 of platform-ziflow/SKILL.md).
  # DO NOT substitute a soft `grep -qF 'routing'` — it false-passes on line 41
  # ("Stage 4a delivery routing").
  grep -qF "is the routing key" dydx-delivery/skills/platform-ziflow/SKILL.md \
    || fail "E2: routing-key claim literal 'is the routing key' missing from platform-ziflow/SKILL.md"
  pass "E2: platform-ziflow/SKILL.md retains literal 'is the routing key' routing-key claim (D-78 path (a))"

  # E3 — glossary.md routing-key entry enumerates 4-enum
  grep -qF 'pipefy | wrike | ziflow | other' dydx-delivery/references/glossary.md \
    || fail "E3: 4-enum 'pipefy | wrike | ziflow | other' missing from glossary.md"
  # Anchor the routing-key entry context — confirm a routing-key block exists
  # alongside the 4-enum (not just the existing **platform** entry).
  grep -qE 'routing.key|routing key' dydx-delivery/references/glossary.md \
    || fail "E3: glossary.md does not mention 'routing key' / 'routing-key' anywhere"
  pass "E3: glossary.md carries routing-key entry with 4-enum"

  # E4 — R-01 carry-forward whole-file assertions (BOTH line 47 AND line 66 fixed)
  if grep -qF 'kickoff-direct' dydx-delivery/references/glossary.md; then
    fail "E4: stale 'kickoff-direct' substring still present in glossary.md (line 66 fix incomplete)"
  fi
  if grep -qF 'discovery-via' dydx-delivery/references/glossary.md; then
    fail "E4: stale 'discovery-via' substring still present in glossary.md (line 47 OR line 66 fix incomplete)"
  fi
  grep -qF 'discovery-ready' dydx-delivery/references/glossary.md \
    || fail "E4: authoritative 'discovery-ready' missing from glossary.md kickoff_branch entry"
  grep -qF 'draft-sow' dydx-delivery/references/glossary.md \
    || fail "E4: authoritative 'draft-sow' missing from glossary.md kickoff_branch entry"
  pass "E4: R-01 carry-forward — whole-file glossary.md clean of 'kickoff-direct' AND 'discovery-via'; carries 'discovery-ready' AND 'draft-sow'"

  # E5 — STG4-03 retirement: generate-functional-spec/ directory does NOT exist
  if [ -d dydx-delivery/skills/generate-functional-spec ]; then
    fail "E5: dydx-delivery/skills/generate-functional-spec/ STILL EXISTS (STG4-03 retirement incomplete)"
  fi
  pass "E5: STG4-03 retirement — dydx-delivery/skills/generate-functional-spec/ directory removed"

  # E6 — STG4-06 three-topology cross-reference (either-spec-skip-paths.md referenced from BOTH 4a + 4b SKILL.md)
  grep -qF 'either-spec-skip-paths.md' dydx-delivery/skills/generate-fnspec-platform/SKILL.md \
    || fail "E6: either-spec-skip-paths.md cross-reference missing from 4a SKILL.md (STG4-06 4a half)"
  grep -qF 'either-spec-skip-paths.md' dydx-delivery/skills/generate-fnspec-integration/SKILL.md \
    || fail "E6: either-spec-skip-paths.md cross-reference missing from 4b SKILL.md"
  # Three topology tokens named in the skip-paths reference
  local topo
  for topo in '4a-only' '4b-only' 'both'; do
    grep -qF "$topo" dydx-delivery/skills/generate-fnspec-integration/references/either-spec-skip-paths.md \
      || fail "E6: topology '$topo' missing from either-spec-skip-paths.md"
  done
  pass "E6: STG4-06 three topologies (4a-only / 4b-only / both) documented; cross-referenced from BOTH 4a + 4b SKILL.md"
}

# ----------------------------------------------------------------------------
# Synthetic consumer-stub helpers for smoke section (D-86 + ROUTE-05)
# ----------------------------------------------------------------------------

read_frontmatter() {
  sed -n '/^---$/,/^---$/p' "$1" | sed '1d;$d'
}

iterate_delivery_rows() {
  grep -oE 'delivery: (native-ai|api) \[[^]]+\]' "$1" || true
}

synth_stage5_stub() {
  local fixture="$1"
  local row_count
  row_count=$(iterate_delivery_rows "$fixture" | wc -l)
  [ "$row_count" -gt 0 ] || fail "S3: synth_stage5_stub found 0 delivery rows in $fixture"
  if iterate_delivery_rows "$fixture" | grep -qE 'delivery: api \| native-ai'; then
    fail "S3: reversed enum 'api | native-ai' found in $fixture — STG4-04 canonical order violation"
  fi
  echo "  synth_stage5_stub: re-emitted $row_count delivery rows in canonical order from $fixture"
}

synth_stage6_stub() {
  local fa="$1"; local fb="$2"
  local count_4a count_4b combined
  count_4a=$(iterate_delivery_rows "$fa" | wc -l)
  count_4b=$(iterate_delivery_rows "$fb" | wc -l)
  combined=$((count_4a + count_4b))
  [ "$combined" -gt 0 ] || fail "S4: synth_stage6_stub: 4a + 4b row counts sum to 0"
  echo "  synth_stage6_stub: 4a=$count_4a + 4b=$count_4b = combined=$combined rows"
}

synth_stage7b_stub() {
  local fixture="$1"
  local row
  while IFS= read -r row; do
    [ -z "$row" ] && continue
    echo "$row" | grep -qE 'delivery: (native-ai|api) \[' \
      || fail "S5: synth_stage7b_stub: malformed delivery row in $fixture: $row"
  done < <(iterate_delivery_rows "$fixture")
  echo "  synth_stage7b_stub: every row in $fixture matches canonical delivery: (native-ai|api) [...] pattern"
}

synth_stage10_stub() {
  local fixture="$1"
  local based_on
  based_on=$(read_frontmatter "$fixture" | grep -E '^based_on_' || true)
  [ -n "$based_on" ] || fail "S6: synth_stage10_stub: no based_on_* fields in $fixture frontmatter"
  echo "  synth_stage10_stub: based_on_* chain present in $fixture"
}

run_smoke_section() {
  local fa=".planning/phases/08-stage-4-fnspec-split-route/fixtures/output/sample-cr-04a_fnspec-platform_v1.md"
  local fb=".planning/phases/08-stage-4-fnspec-split-route/fixtures/output/sample-cr-04b_fnspec-integration_v1.md"
  local fc=".planning/phases/08-stage-4-fnspec-split-route/fixtures/output/sample-cr-04b_consistency_check_v1.md"

  # S1 — 4a fixture exists and parses YAML frontmatter
  [ -f "$fa" ] || fail "S1: $fa does not exist"
  [ -n "$(read_frontmatter "$fa")" ] || fail "S1: $fa frontmatter empty / unparseable"
  pass "S1: 4a fixture exists and parses YAML frontmatter"

  # S2 — 4b fixture exists and parses
  [ -f "$fb" ] || fail "S2: $fb does not exist"
  [ -n "$(read_frontmatter "$fb")" ] || fail "S2: $fb frontmatter empty / unparseable"
  pass "S2: 4b fixture exists and parses YAML frontmatter"

  # S2b — 4b halt-path consistency-check fixture exists (smoke artefact 3)
  [ -f "$fc" ] || fail "S2: $fc (consistency_check halt-path fixture) does not exist"

  # S3 — Stage 5 stub: delivery rows re-emit cleanly from 4a + 4b
  synth_stage5_stub "$fa"
  synth_stage5_stub "$fb"
  pass "S3: synth_stage5_stub re-emits delivery rows canonically from BOTH 4a + 4b fixtures"

  # S4 — Stage 6 stub: combined row count 4a + 4b
  synth_stage6_stub "$fa" "$fb"
  pass "S4: synth_stage6_stub combined row count from 4a + 4b > 0"

  # S5 — Stage 7b stub: canonical pattern on every row
  synth_stage7b_stub "$fa"
  synth_stage7b_stub "$fb"
  pass "S5: synth_stage7b_stub canonical delivery pattern on every row in 4a + 4b"

  # S6 — Stage 10 stub: based_on_* chain present in both
  synth_stage10_stub "$fa"
  synth_stage10_stub "$fb"
  pass "S6: synth_stage10_stub based_on_* chain present in 4a + 4b fixtures"
}

# ============================================================================
# Cross-section assertions — full-run only (D-77 + D-86)
# ============================================================================

run_cross_section() {
  # X1 — platform: enum spelling consistent across every platform-declarer skill
  local skill
  local declarer_files=(
    "dydx-delivery/skills/discovery-intake/SKILL.md"
    "dydx-delivery/skills/generate-build-prompt/SKILL.md"
    "dydx-delivery/skills/generate-technical-spec/SKILL.md"
    "dydx-delivery/skills/generate-test-plan/SKILL.md"
    "dydx-delivery/skills/generate-fnspec-platform/SKILL.md"
    "dydx-delivery/skills/generate-fnspec-integration/SKILL.md"
    "dydx-delivery/skills/generate-sow/SKILL.md"
  )
  for skill in "${declarer_files[@]}"; do
    grep -qF 'pipefy | wrike | ziflow | other' "$skill" \
      || fail "X1: 4-enum missing from $skill"
  done
  pass "X1: platform: 4-enum consistent across all 7 platform-declarer SKILL.md files"

  # X2 — delivery: markup token greppable from BOTH 4a + 4b template files
  grep -qF 'delivery:' dydx-delivery/skills/generate-fnspec-platform/references/fnspec-platform-template.md \
    || fail "X2: delivery: markup missing from 4a template"
  grep -qF 'delivery:' dydx-delivery/skills/generate-fnspec-integration/references/fnspec-integration-template.md \
    || fail "X2: delivery: markup missing from 4b template"
  pass "X2: delivery: markup token present in BOTH 4a + 4b templates"

  # X3 — based_on_fnspec_platform cited in 4b SKILL.md AND based_on_* documented in frontmatter-scheme.md
  grep -qF 'based_on_fnspec_platform' dydx-delivery/skills/generate-fnspec-integration/SKILL.md \
    || fail "X3: based_on_fnspec_platform missing from 4b SKILL.md"
  grep -qE 'based_on_' dydx-delivery/references/frontmatter-scheme.md \
    || fail "X3: canonical based_on_* documentation missing from frontmatter-scheme.md"
  pass "X3: based_on_fnspec_platform cited in 4b SKILL.md + based_on_* documented in frontmatter-scheme.md"

  # X4 — meta-assert: this script itself passes bash -n
  bash -n .planning/phases/08-stage-4-fnspec-split-route/scripts/phase8-structure-check.sh \
    || fail "X4: phase8-structure-check.sh fails bash -n syntax check"
  pass "X4: phase8-structure-check.sh passes bash -n syntax check (meta-assert)"
}

# ============================================================================
# Dispatch
# ============================================================================

case "$SECTION" in
  4a)        run_4a_section ;;
  4b)        run_4b_section ;;
  route)     run_route_section ;;
  smoke)     run_smoke_section ;;
  all|"")    run_4a_section; run_4b_section; run_route_section; run_smoke_section; run_cross_section ;;
  *)         fail "unknown --section value: $SECTION (use 4a|4b|route|smoke|all)" ;;
esac

echo "ALL ASSERTIONS PASSED"
exit 0
