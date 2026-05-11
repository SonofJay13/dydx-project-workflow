#!/usr/bin/env bash
# phase6-structure-check.sh — structural verifier for Phase 6 (platform skills) deliverables
#
# Comment-vs-code policy (carried from Phase 5 phase5-structure-check.sh):
#   - Sentinel-token matches use `grep -qF` (literal-string, case-sensitive)
#   - Pattern matches use `grep -cE` / `grep -qE` (case-sensitive extended regex)
#   - Script does NOT use case-insensitive matching. GNU grep 3.0 on Git Bash for Windows
#     aborts (SIGABRT exit 134) on `-i` against UTF-8 multibyte content; assertion sentinel
#     tokens are deterministic in source files, so case-sensitive matching is sufficient
#     and portable.
#
# G-2 convention (Gemini LOW; carried from Phase 5): every absence-check (`! grep ...` or
# zero-count regex) excludes `scripts/`, `*.sh`, and `*~` to prevent the script's own
# assertion text from triggering false-positive failures. Concretely, every recursive grep
# for forbidden tokens carries:
#   --exclude-dir=scripts
#   --exclude="*.sh"
#   --exclude="*~"
#
# Per-section partition (REVIEWS C1 — HIGH): `--section <pipefy|wrike|ziflow>` runs ONLY
# that platform's assertion subset so Wave 2 plans (06-02, 06-03) can self-verify before
# all 3 platforms exist on disk. Cross-tree gates A7 + A16 only run in full mode (no
# `--section` flag). Without this partition, `--section wrike` invoked from 06-02 would
# false-fail on Ziflow files not yet created.
#
# REVIEWS C2 + C3 (HIGH/MEDIUM): A7 and A11-second-half use tightened YAML-field-assignment
# regex. A bare narrative mention of the token in prose is NOT gated — only the literal
# YAML field assignment form (`^[[:space:]]*<token>:[[:space:]]+<value>[[:space:]]*$`) is
# forbidden. Prose in plans scrubs the literal token regardless (belt-and-suspenders).
#
# REVIEWS C8 (LOW): A16 OPEN-Q row-flip verification uses awk-between-OPEN-Q-headings
# extraction instead of the brittle `grep -A 11` shape — robust against future decision-
# bullet insertions that would shift the `Status:` line beyond a fixed-line count.
#
# Invocation modes:
#   bash phase6-structure-check.sh                       # full suite (~17 assertions)
#   bash phase6-structure-check.sh --section pipefy      # Pipefy assertions only
#   bash phase6-structure-check.sh --section wrike       # Wrike assertions only
#   bash phase6-structure-check.sh --section ziflow      # Ziflow assertions only
#
set -euo pipefail

fail() { echo "FAIL: $1" >&2; exit 1; }
pass() { echo "PASS: $1"; }

# Parse args
SECTION="${SECTION:-}"
while [ $# -gt 0 ]; do
  case "$1" in
    --section) SECTION="${2:-}"; shift 2 ;;
    --quick)   shift ;;  # accepted for parity with Phase 5 invocation pattern; no-op here
    --help|-h)
      cat <<'USAGE'
Usage: phase6-structure-check.sh [--section <pipefy|wrike|ziflow>]

  --section pipefy        run ONLY Pipefy assertions (A1, A4-pipefy, A5-pipefy,
                          A6-pipefy, A8, A9, A10, A11, A14, A17-pipefy)
  --section wrike         run ONLY Wrike assertions (A2, A4-wrike, A5-wrike,
                          A6-wrike, A12, A15, A17-wrike)
  --section ziflow        run ONLY Ziflow assertions (A3, A4-ziflow, A5-ziflow,
                          A6-ziflow, A13, A17-ziflow)
  (no flag)               run full suite (all per-platform + cross-tree A7 + A16)
USAGE
      exit 0
      ;;
    *) echo "Unknown arg: $1" >&2; exit 2 ;;
  esac
done

# ============================================================================
# Per-platform assertion runners (REVIEWS C1 partition)
# ============================================================================

run_pipefy_section() {
  # A1 — Pipefy SKILL.md exists
  [ -f dydx-delivery/skills/platform-pipefy/SKILL.md ] \
    || fail "A1: dydx-delivery/skills/platform-pipefy/SKILL.md missing"
  pass "A1: Pipefy SKILL.md exists"

  # A4-pipefy — 5 references/ files exist
  local ref
  for ref in api-contract.md native-ai-inventory.md knowledge-ingestion.md client-shape-gotchas.md vocabulary.md; do
    [ -f "dydx-delivery/skills/platform-pipefy/references/$ref" ] \
      || fail "A4-pipefy: missing dydx-delivery/skills/platform-pipefy/references/$ref"
  done
  pass "A4-pipefy: 5 references/ files exist"

  # A5-pipefy — tier_claims_last_verified frontmatter with ISO date
  grep -qE '^tier_claims_last_verified: [0-9]{4}-[0-9]{2}-[0-9]{2}$' dydx-delivery/skills/platform-pipefy/SKILL.md \
    || fail "A5-pipefy: tier_claims_last_verified ISO date missing/malformed"
  pass "A5-pipefy: tier_claims_last_verified ISO date present"

  # A6-pipefy — native_ai_path enum paste|none
  grep -qE '^native_ai_path: (paste|none)$' dydx-delivery/skills/platform-pipefy/SKILL.md \
    || fail "A6-pipefy: native_ai_path enum not in {paste, none}"
  pass "A6-pipefy: native_ai_path enum valid"

  # A8 — canonical endpoint + Q24 verification date in api-contract.md
  grep -qF 'api.pipefy.com/graphql' dydx-delivery/skills/platform-pipefy/references/api-contract.md \
    || fail "A8: canonical endpoint string 'api.pipefy.com/graphql' missing"
  grep -qF '2026-05-10' dydx-delivery/skills/platform-pipefy/references/api-contract.md \
    || fail "A8: Q24 verification date '2026-05-10' missing"
  pass "A8: Pipefy canonical endpoint + Q24 verification date present"

  # A9 — HTML-on-auth-failure detection
  grep -qF 'Content-Type: text/html' dydx-delivery/skills/platform-pipefy/references/api-contract.md \
    || fail "A9: 'Content-Type: text/html' literal missing"
  grep -qF 'Keycloak' dydx-delivery/skills/platform-pipefy/references/api-contract.md \
    || fail "A9: 'Keycloak' literal missing"
  pass "A9: HTML-on-auth-failure detection documented"

  # A10 — paginate_all helper contract present
  grep -qE '^## paginate_all' dydx-delivery/skills/platform-pipefy/references/api-contract.md \
    || fail "A10: '## paginate_all' heading missing"
  grep -qF 'Signature:' dydx-delivery/skills/platform-pipefy/references/api-contract.md \
    || fail "A10: 'Signature:' field missing (7-part helper contract)"
  pass "A10: paginate_all helper contract present"

  # A11 — web_host + org_id documented AND tightened second-half:
  # YAML-field-assignment form of the previously-considered host-override field
  # MUST NOT appear in api-contract.md (REVIEWS C2 regex)
  grep -qF 'web_host' dydx-delivery/skills/platform-pipefy/references/api-contract.md \
    || fail "A11: 'web_host' per-tenant variant missing"
  grep -qF 'org_id' dydx-delivery/skills/platform-pipefy/references/api-contract.md \
    || fail "A11: 'org_id' per-tenant variant missing"
  local apihost_hits
  apihost_hits=$(grep -cE '^[[:space:]]*api_host[[:space:]]*:' dydx-delivery/skills/platform-pipefy/references/api-contract.md || true)
  if [ "$apihost_hits" != "0" ]; then
    fail "A11: previously-considered API-host override YAML field assignment leaked (count=$apihost_hits)"
  fi
  pass "A11: web_host + org_id documented; YAML-field-assignment-form of removed host-override field absent"

  # A14 — Pipefy throttle (Q06.2 = 13 req/sec; 80% of 16.67)
  grep -qF '13 req/sec' dydx-delivery/skills/platform-pipefy/references/api-contract.md \
    || fail "A14: '13 req/sec' throttle missing"
  grep -qF '16.67' dydx-delivery/skills/platform-pipefy/references/api-contract.md \
    || fail "A14: '16.67' published-ceiling reference missing"
  pass "A14: Pipefy throttle (Q06.2) documented"

  # A17-pipefy — capability matrix
  grep -qE '^## Capability matrix' dydx-delivery/skills/platform-pipefy/references/native-ai-inventory.md \
    || fail "A17-pipefy: '## Capability matrix' heading missing"
  pass "A17-pipefy: Pipefy capability matrix present"
}

run_wrike_section() {
  # A2 — Wrike SKILL.md exists
  [ -f dydx-delivery/skills/platform-wrike/SKILL.md ] \
    || fail "A2: dydx-delivery/skills/platform-wrike/SKILL.md missing"
  pass "A2: Wrike SKILL.md exists"

  # A4-wrike — 5 references/ files exist
  local ref
  for ref in api-contract.md native-ai-inventory.md knowledge-ingestion.md client-shape-gotchas.md vocabulary.md; do
    [ -f "dydx-delivery/skills/platform-wrike/references/$ref" ] \
      || fail "A4-wrike: missing dydx-delivery/skills/platform-wrike/references/$ref"
  done
  pass "A4-wrike: 5 references/ files exist"

  # A5-wrike
  grep -qE '^tier_claims_last_verified: [0-9]{4}-[0-9]{2}-[0-9]{2}$' dydx-delivery/skills/platform-wrike/SKILL.md \
    || fail "A5-wrike: tier_claims_last_verified ISO date missing/malformed"
  pass "A5-wrike: tier_claims_last_verified ISO date present"

  # A6-wrike
  grep -qE '^native_ai_path: (paste|none)$' dydx-delivery/skills/platform-wrike/SKILL.md \
    || fail "A6-wrike: native_ai_path enum not in {paste, none}"
  pass "A6-wrike: native_ai_path enum valid"

  # A12 — OAuth-host persistence + literal prohibition phrase
  # (REVIEWS C5 narrowed: phrase-presence only; worked examples + URL refs to www.wrike.com allowed)
  grep -qF 'OAuth token response' dydx-delivery/skills/platform-wrike/references/api-contract.md \
    || fail "A12: 'OAuth token response' persistence text missing"
  grep -qF 'NEVER hardcode `www.wrike.com`' dydx-delivery/skills/platform-wrike/references/api-contract.md \
    || fail "A12: literal prohibition phrase 'NEVER hardcode \`www.wrike.com\`' missing"
  pass "A12: Wrike OAuth-host persistence + prohibition phrase present"

  # A15 — Wrike throttle (Q07.2 = 320 req/min; 80% of 400)
  grep -qF '320 req/min' dydx-delivery/skills/platform-wrike/references/api-contract.md \
    || fail "A15: '320 req/min' throttle missing"
  grep -qF '400' dydx-delivery/skills/platform-wrike/references/api-contract.md \
    || fail "A15: '400' published-ceiling reference missing"
  pass "A15: Wrike throttle (Q07.2) documented"

  # A17-wrike
  grep -qE '^## Capability matrix' dydx-delivery/skills/platform-wrike/references/native-ai-inventory.md \
    || fail "A17-wrike: '## Capability matrix' heading missing"
  pass "A17-wrike: Wrike capability matrix present"
}

run_ziflow_section() {
  # A3 — Ziflow SKILL.md exists
  [ -f dydx-delivery/skills/platform-ziflow/SKILL.md ] \
    || fail "A3: dydx-delivery/skills/platform-ziflow/SKILL.md missing"
  pass "A3: Ziflow SKILL.md exists"

  # A4-ziflow — 5 references/ files exist
  local ref
  for ref in api-contract.md native-ai-inventory.md knowledge-ingestion.md client-shape-gotchas.md vocabulary.md; do
    [ -f "dydx-delivery/skills/platform-ziflow/references/$ref" ] \
      || fail "A4-ziflow: missing dydx-delivery/skills/platform-ziflow/references/$ref"
  done
  pass "A4-ziflow: 5 references/ files exist"

  # A5-ziflow
  grep -qE '^tier_claims_last_verified: [0-9]{4}-[0-9]{2}-[0-9]{2}$' dydx-delivery/skills/platform-ziflow/SKILL.md \
    || fail "A5-ziflow: tier_claims_last_verified ISO date missing/malformed"
  pass "A5-ziflow: tier_claims_last_verified ISO date present"

  # A6-ziflow
  grep -qE '^native_ai_path: (paste|none)$' dydx-delivery/skills/platform-ziflow/SKILL.md \
    || fail "A6-ziflow: native_ai_path enum not in {paste, none}"
  pass "A6-ziflow: native_ai_path enum valid"

  # A13 — wait_for_proof helper + webhook PRIMARY note
  grep -qF 'max_wait_s=30' dydx-delivery/skills/platform-ziflow/references/api-contract.md \
    || fail "A13: 'max_wait_s=30' default missing"
  grep -qF 'interval_s=2' dydx-delivery/skills/platform-ziflow/references/api-contract.md \
    || fail "A13: 'interval_s=2' default missing"
  grep -qF 'webhook' dydx-delivery/skills/platform-ziflow/references/api-contract.md \
    || fail "A13: 'webhook' PRIMARY-guidance reference missing"
  pass "A13: wait_for_proof helper + webhook PRIMARY documented"

  # A17-ziflow
  grep -qE '^## Capability matrix' dydx-delivery/skills/platform-ziflow/references/native-ai-inventory.md \
    || fail "A17-ziflow: '## Capability matrix' heading missing"
  pass "A17-ziflow: Ziflow capability matrix present"
}

# ============================================================================
# Cross-tree assertions — full-run only (REVIEWS C1: do NOT run under --section)
# ============================================================================

run_cross_tree_section() {
  # A7 — cross-tree forbidden-token gate (tightened YAML-field-assignment regex per REVIEWS C3)
  # Catches the forbidden third enum value only as a YAML field assignment; narrative
  # mentions in prose are not gated. G-2 excludes: scripts/, *.sh, *~.
  local skip_dirs=()
  [ -d dydx-delivery/skills/platform-pipefy ] && skip_dirs+=(dydx-delivery/skills/platform-pipefy)
  [ -d dydx-delivery/skills/platform-wrike  ] && skip_dirs+=(dydx-delivery/skills/platform-wrike)
  [ -d dydx-delivery/skills/platform-ziflow ] && skip_dirs+=(dydx-delivery/skills/platform-ziflow)
  if [ "${#skip_dirs[@]}" -eq 0 ]; then
    fail "A7: no platform-*/ trees present to scan"
  fi
  if grep -rEn '^[[:space:]]*native_ai_path:[[:space:]]+api[[:space:]]*$' \
        "${skip_dirs[@]}" \
        --exclude-dir=scripts --exclude='*.sh' --exclude='*~' >/dev/null 2>&1; then
    fail "A7: forbidden native_ai_path YAML field assignment leaked into platform-*/ tree"
  fi
  pass "A7: no forbidden native_ai_path YAML field assignments across platform-*/ trees"

  # A16 — OPEN-QUESTIONS.md row flips (awk-between-OPEN-Q-headings extraction per REVIEWS C8)
  local Q STATUS
  for Q in Q05 Q06.2 Q07.2; do
    STATUS=$(awk -v q="$Q" '
      $0 ~ "^\\*\\*OPEN-"q"\\*\\* " {p=1; next}
      p && /^\*\*OPEN-Q/ {p=0}
      p && /^- Status:/ {print; exit}
    ' .planning/OPEN-QUESTIONS.md)
    case "$STATUS" in
      "- Status: decided") pass "A16: OPEN-$Q status decided" ;;
      *) fail "A16: OPEN-$Q status is not 'decided' (found: '$STATUS')" ;;
    esac
  done
}

# ============================================================================
# Dispatch
# ============================================================================

case "$SECTION" in
  pipefy)  run_pipefy_section ;;
  wrike)   run_wrike_section ;;
  ziflow)  run_ziflow_section ;;
  "")      run_pipefy_section; run_wrike_section; run_ziflow_section; run_cross_tree_section ;;
  *)       fail "unknown --section value: $SECTION (use pipefy|wrike|ziflow or omit for full run)" ;;
esac

echo "ALL ASSERTIONS PASSED"
exit 0
