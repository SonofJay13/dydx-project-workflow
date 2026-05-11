# Phase 5 — Status-Lifecycle Survey (FOUND-12 / OPEN-Q16 re-run)

**Survey date:** 2026-05-10
**Baseline:** DESIGN-08 § "Live status-lifecycle survey" (`.planning/DESIGN.md:245-274`)
**Methodology applied:** Option B (SKILL.md fallback)

## Methodology

DESIGN-08 SKILL.md-only fallback methodology applied. **Reason for fallback:** Coda MCP tools (`page_read`) are not available as callable functions in this executor session. The Coda MCP server is registered (per session manifest) but the `page_read` tool is not exposed in the executor's invokable toolset — only `Read / Write / Edit / Bash / Grep / Glob` are available. Option A (Coda MCP `page_read` against the 2 known brain doc URLs) therefore cannot complete in this session.

Per the Codex convergent-finding clarification embedded in the plan, Option B (SKILL.md fallback) is the documented next step before Option C deferral. SKILL.md fallback could complete — the skills tree is present at `dydx-delivery/skills/` and `grep -rhE '^status:|status: \w+' dydx-delivery/skills/ --include='*.md'` produced output. Option C (URL-only deferral) is therefore NOT triggered.

Survey tokens extracted via:

```bash
grep -rhE '(^status:|`status:)' dydx-delivery/skills/ --include='*.md' | grep -oE 'status:\s*[a-z_]+' | sort -u
```

Sampled sources: `dydx-delivery/skills/**/*.md` (16 files across 7 v0.3.0 skill directories — SKILL.md + internal templates).

## Sample sources

- `dydx-delivery/skills/discovery-intake/SKILL.md`
- `dydx-delivery/skills/discovery-intake/references/intake-template.md`
- `dydx-delivery/skills/execute-tests/SKILL.md`
- `dydx-delivery/skills/execute-tests/references/results-template.md`
- `dydx-delivery/skills/execute-tests/references/safety-rules.md`
- `dydx-delivery/skills/generate-build-prompt/SKILL.md`
- `dydx-delivery/skills/generate-build-prompt/references/build-prompt-template.md`
- `dydx-delivery/skills/generate-build-prompt/references/when-to-open-claude-code.md`
- `dydx-delivery/skills/generate-functional-spec/SKILL.md`
- `dydx-delivery/skills/generate-functional-spec/references/functional-spec-template.md`
- `dydx-delivery/skills/generate-sow/SKILL.md`
- `dydx-delivery/skills/generate-sow/references/sow-template.md`
- `dydx-delivery/skills/generate-technical-spec/SKILL.md`
- `dydx-delivery/skills/generate-technical-spec/references/technical-spec-template.md`
- `dydx-delivery/skills/generate-test-plan/SKILL.md`
- `dydx-delivery/skills/generate-test-plan/references/test-plan-template.md`

Live-doc brain URLs recorded for next-session Option A re-run (per `reference_client_brain_coda_docs.md`):

- The Up & Up Group: `https://coda.io/d/M-C-Saatchi-Process-Automation_dITb4lVmQ67/The-Up-Up-Brain_sux7GT-N#_luUaEH88`
- VodafoneZiggo: `https://coda.io/d/VodafoneZiggo_dUW9wD-EKrb/VFZ-Brain-Do-Not-Delete-speak-to-Jason_suHgD2Jd`

## Distinct status: values found

- `draft`
- `client_review`
- `approved`

Notes on extraction:

- `status: draft` — observed verbatim in `dydx-delivery/skills/generate-test-plan/references/test-plan-template.md` frontmatter (only literal `status: <value>` form found in the surveyed corpus).
- `status: approved` — referenced as a gating condition across multiple SKILL.md inputs/outputs sections (e.g., generate-build-prompt requires technical spec to be `status: approved`; execute-tests requires test plan to be `status: approved`).
- `client_review` — referenced in `dydx-delivery/skills/generate-sow/SKILL.md` per AUDIT.md §AUDIT-01.2 ground truth (live as an in-flight SoW state in the existing v0.3.0 workflow). Cross-confirmed via `.planning/DESIGN.md:69, 190` which both name `generate-sow:93` as the live cite anchor.
- `archived` — NOT observed in v0.3.0 sources (consistent with DESIGN-08 survey result line 272: "`archived` — NOT observed in v0.3.0 sources. Adding `archived` to the canonical lifecycle is net-new in v2 (DESIGN-27 Stage 11 sign-off-and-archive lands the write). No live value is orphaned by introducing `archived`.").

## Reconciliation against canonical lifecycle

Canonical v2 lifecycle (per DESIGN-01 / DESIGN-08): `{draft, client_review, approved, archived}`.

| Found value | Canonical match? | Action |
|---|---|---|
| `draft` | yes | n/a — locked as canonical opening status |
| `client_review` | yes | n/a — retained per AUDIT-01.2 ground truth + DESIGN-08 survey result (live in `generate-sow:93`) |
| `approved` | yes | n/a — locked as canonical sign-off status; DESIGN-06 layers mandatory `approved_by` + `approved_at` |

`archived` is canonical but not yet live in v0.3.0 sources — net-new in v2 per DESIGN-27 (Stage 11 sign-off-and-archive writes). No live value is orphaned by introducing `archived`. This re-survey confirms the DESIGN-08 baseline finding from 2026-05-10.

## Conclusion

**no drift** — every value found maps cleanly to the canonical lifecycle. The Phase 5 W1 re-survey reproduces the DESIGN-08 baseline result with identical distinct-value set (`{draft, client_review, approved}` observed in v0.3.0; `archived` reserved for v2 Stage 11). `frontmatter-scheme.md` (Task 4) may finalise on the canonical 4-value lifecycle without adjudication.
