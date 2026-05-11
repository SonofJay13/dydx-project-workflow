#!/usr/bin/env bash
# phase7-structure-check.sh — structural verifier for Phase 7 (Stage 1 kickoff + Stage 2/3 upstream wiring) deliverables
#
# Comment-vs-code policy (carried from Phase 5 / Phase 6):
#   - Sentinel-token matches use `grep -qF` (literal-string, case-sensitive)
#   - Pattern matches use `grep -cE` / `grep -qE` (case-sensitive extended regex)
#   - Script does NOT use case-insensitive matching. GNU grep 3.0 on Git Bash for Windows
#     aborts (SIGABRT exit 134) on `-i` against UTF-8 multibyte content; assertion sentinel
#     tokens are deterministic in source files, so case-sensitive matching is sufficient
#     and portable.
#
# G-2 convention (carried from Phase 5/6): every absence-check (`! grep ...` or zero-count
# regex) excludes `scripts/`, `*.sh`, and `*~` to prevent the script's own assertion text
# from triggering false-positive failures.
#
# Per-section partition (D-77): `--section <kickoff|discovery|sow|all>` runs ONLY that
# section's assertion subset so Wave 2 plans (07-02, 07-03) can self-verify before all
# 3 skills exist on disk. Cross-section gates X1+X2 only run in `all` mode.
#
# C1 fix (cross-AI review): K4 split into K4 + K4b — K4 asserts the CONCRETE enum value
# line in kickoff-template.md; K4b asserts BOTH enum values are documented somewhere
# across the 4 kickoff-capture skill files. This closes the previous regex/template
# inconsistency where K4 alone could not verify both enum values were reachable.
#
# Invocation modes:
#   bash phase7-structure-check.sh --section kickoff     # Stage 1 (07-01 gate)
#   bash phase7-structure-check.sh --section discovery   # Stage 2 (07-02 gate)
#   bash phase7-structure-check.sh --section sow         # Stage 3 (07-03 gate)
#   bash phase7-structure-check.sh --section all         # full suite (07-04 gate)
#   bash phase7-structure-check.sh --all                 # alias for --section all
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
    --quick)   shift ;;  # accepted for parity with Phase 5/6 invocation pattern; no-op
    --help|-h)
      cat <<'USAGE'
Usage: phase7-structure-check.sh [--section <kickoff|discovery|sow|all>] [--all]

  --section kickoff       run ONLY kickoff-capture assertions (K1-K7 + K4b)
  --section discovery     run ONLY discovery-intake assertions (D1-D3)
  --section sow           run ONLY generate-sow assertions (S1-S2)
  --section all           run full suite (all per-section + cross-section X1+X2)
  --all                   alias for --section all
  (no flag)               run full suite
USAGE
      exit 0
      ;;
    *) echo "Unknown arg: $1" >&2; exit 2 ;;
  esac
done

# ============================================================================
# Per-section assertion runners (D-77 partition)
# ============================================================================

run_kickoff_section() {
  # K1 — kickoff-capture SKILL.md exists
  [ -f dydx-delivery/skills/kickoff-capture/SKILL.md ] \
    || fail "K1: dydx-delivery/skills/kickoff-capture/SKILL.md missing"
  pass "K1: kickoff-capture SKILL.md exists"

  # K2 — 3 references/ files exist
  local ref
  for ref in kickoff-template.md auto-classify-rubric.md capture-paths.md; do
    [ -f "dydx-delivery/skills/kickoff-capture/references/$ref" ] \
      || fail "K2: missing dydx-delivery/skills/kickoff-capture/references/$ref"
  done
  pass "K2: 3 references/ files exist"

  # K3 — canonical-reference pointers resolve from SKILL.md
  local canonical
  for canonical in safety-rules.md stage-numbering.md frontmatter-scheme.md glossary.md; do
    grep -qF "dydx-delivery/references/$canonical" dydx-delivery/skills/kickoff-capture/SKILL.md \
      || fail "K3: canonical pointer '$canonical' missing from kickoff-capture/SKILL.md"
    [ -f "dydx-delivery/references/$canonical" ] \
      || fail "K3: canonical target dydx-delivery/references/$canonical does not exist"
  done
  pass "K3: 4 canonical pointers resolve (safety-rules/stage-numbering/frontmatter-scheme/glossary)"

  # K4 — concrete enum value asserted in template (C1 fix — anchored regex matches CONCRETE value line)
  grep -qE '^kickoff_branch: (discovery-ready|draft-sow)$' \
    dydx-delivery/skills/kickoff-capture/references/kickoff-template.md \
    || fail "K4: concrete kickoff_branch value (discovery-ready|draft-sow) missing from kickoff-template.md frontmatter line"
  pass "K4: concrete kickoff_branch enum value present in kickoff-template.md"

  # K4b — both enum values documented across kickoff-capture skill files (C1 fix)
  local kickoff_files=(
    "dydx-delivery/skills/kickoff-capture/SKILL.md"
    "dydx-delivery/skills/kickoff-capture/references/kickoff-template.md"
    "dydx-delivery/skills/kickoff-capture/references/auto-classify-rubric.md"
    "dydx-delivery/skills/kickoff-capture/references/capture-paths.md"
  )
  if cat "${kickoff_files[@]}" 2>/dev/null | grep -qF 'discovery-ready' \
     && cat "${kickoff_files[@]}" 2>/dev/null | grep -qF 'draft-sow'; then
    pass "K4b: both enum values (discovery-ready, draft-sow) documented in kickoff-capture skill files"
  else
    fail "K4b: missing one or both enum values (discovery-ready / draft-sow) in kickoff-capture skill files"
  fi

  # K5 — [unknown — needs human classification] marker documented in SKILL.md
  grep -qF '[unknown — needs human classification]' \
    dydx-delivery/skills/kickoff-capture/SKILL.md \
    || fail "K5: marker convention '[unknown — needs human classification]' missing from kickoff-capture/SKILL.md"
  pass "K5: unknown-marker convention documented in SKILL.md"

  # K6 — processed_at IS NULL documented in capture-paths.md
  grep -qF 'processed_at IS NULL' \
    dydx-delivery/skills/kickoff-capture/references/capture-paths.md \
    || fail "K6: 'processed_at IS NULL' verbatim filter wording missing from capture-paths.md"
  pass "K6: Field Notes triage filter 'processed_at IS NULL' documented verbatim"

  # K7 — auto-classify-rubric.md referenced from SKILL.md
  grep -qF 'references/auto-classify-rubric.md' \
    dydx-delivery/skills/kickoff-capture/SKILL.md \
    || fail "K7: kickoff-capture/SKILL.md does not reference references/auto-classify-rubric.md"
  pass "K7: auto-classify-rubric.md referenced from SKILL.md"
}

run_discovery_section() {
  # D1 — based_on_kickoff MANDATORY documented for write-path
  grep -qF 'based_on_kickoff' dydx-delivery/skills/discovery-intake/SKILL.md \
    || fail "D1: based_on_kickoff field reference missing from discovery-intake/SKILL.md"
  grep -qE '(MANDATORY|required|REQUIRED|Required)' dydx-delivery/skills/discovery-intake/SKILL.md \
    || fail "D1: write-path enforcement policy (MANDATORY/required) missing from discovery-intake/SKILL.md"
  pass "D1: based_on_kickoff MANDATORY documented in discovery-intake/SKILL.md"

  # D2 — raw-notes RETIRED message present
  grep -qE 'raw[- ]notes.*(RETIRED|retired|removed|no longer)' \
    dydx-delivery/skills/discovery-intake/SKILL.md \
    || fail "D2: raw-notes RETIRED message missing from discovery-intake/SKILL.md"
  pass "D2: raw-notes RETIRED documented in discovery-intake/SKILL.md"

  # D3 — verbatim skip-message present (STG2-02 / D-74 / Roadmap authoritative spelling)
  grep -qF 'Stage 2 SKIPPED — kickoff branch = draft-sow' \
    dydx-delivery/skills/discovery-intake/SKILL.md \
    || fail "D3: verbatim skip-message 'Stage 2 SKIPPED — kickoff branch = draft-sow' missing from discovery-intake/SKILL.md"
  pass "D3: verbatim skip-message present in discovery-intake/SKILL.md"
}

run_sow_section() {
  # S1 — canonical 4-state lifecycle present in SKILL.md OR sow-template.md
  if grep -qF 'draft → client_review → approved → archived' \
       dydx-delivery/skills/generate-sow/SKILL.md 2>/dev/null \
     || grep -qF 'draft → client_review → approved → archived' \
        dydx-delivery/skills/generate-sow/references/sow-template.md 2>/dev/null; then
    pass "S1: canonical 4-state lifecycle 'draft → client_review → approved → archived' present"
  else
    fail "S1: canonical 4-state lifecycle string 'draft → client_review → approved → archived' missing from generate-sow/SKILL.md and sow-template.md"
  fi

  # S2 — ## Platform Scope + ## Integration Scope H2s in template
  grep -qE '^## Platform Scope' \
    dydx-delivery/skills/generate-sow/references/sow-template.md \
    || fail "S2: '## Platform Scope' H2 missing from sow-template.md"
  grep -qE '^## Integration Scope' \
    dydx-delivery/skills/generate-sow/references/sow-template.md \
    || fail "S2: '## Integration Scope' H2 missing from sow-template.md"
  pass "S2: dual-scope H2s ('## Platform Scope' + '## Integration Scope') present in sow-template.md"
}

# ============================================================================
# Cross-section assertions — full-run only (D-77)
# ============================================================================

run_cross_section() {
  # X1 — kickoff_branch field name consistent across kickoff template + discovery + sow
  local skill
  for skill in kickoff-capture/references/kickoff-template.md \
               discovery-intake/SKILL.md \
               generate-sow/SKILL.md; do
    grep -qF 'kickoff_branch' "dydx-delivery/skills/$skill" \
      || fail "X1: kickoff_branch reference missing in dydx-delivery/skills/$skill"
  done
  pass "X1: kickoff_branch field name consistent across kickoff template + discovery + sow"

  # X2 — based_on_kickoff field name consistent across discovery + sow consumers
  grep -qF 'based_on_kickoff' dydx-delivery/skills/discovery-intake/SKILL.md \
    || fail "X2: based_on_kickoff missing from discovery-intake/SKILL.md"
  grep -qF 'based_on_kickoff' dydx-delivery/skills/generate-sow/SKILL.md \
    || fail "X2: based_on_kickoff missing from generate-sow/SKILL.md (draft-sow path)"
  pass "X2: based_on_kickoff consistent across discovery + sow consumers"
}

# ============================================================================
# Dispatch
# ============================================================================

case "$SECTION" in
  kickoff)    run_kickoff_section ;;
  discovery)  run_discovery_section ;;
  sow)        run_sow_section ;;
  all|"")     run_kickoff_section; run_discovery_section; run_sow_section; run_cross_section ;;
  *)          fail "unknown --section value: $SECTION (use kickoff|discovery|sow|all)" ;;
esac

echo "ALL ASSERTIONS PASSED"
exit 0
