# Milestones

Record of shipped milestones and the requirements they validated.

---

## v0.3.0 — Inherited baseline (pre-GSD)

**Status:** Shipped. Not formally a GSD milestone — captured here for traceability.
**Shipped:** 2026-05-09 (initial commit `8805379` on branch `dydx-delivery-v2`)

### What shipped

A stage-gated client delivery pipeline as a single Claude Code plugin (`dydx-delivery`) inside the `dydx-digital@1.2.0` marketplace. Seven markdown-only skills running on Cowork (strategy) and Claude Code (build):

1. `discovery-intake` — captures system, users, triggers, data, rules, integrations, exceptions, failure points
2. `generate-sow` — drafts scope of work from approved discovery
3. `generate-functional-spec` — single fnspec per project, `platform:` tagged
4. `generate-technical-spec` — translates fnspec into platform constructs (Pipefy/Wrike/other)
5. `generate-test-plan` — table-format test plan against sandbox tenant
6. `generate-build-prompt` — Claude-Code-ready build prompt for developers
7. `execute-tests` — runs approved test plan against sandbox, enforces hard safety rules

### Conventions established

- Versioned artefacts (`_v{N}.md` Option B versioning)
- Frontmatter scheme (`client`, `platform`, `integrations`, `version`, `status`, `based_on_*`) — *inconsistent across templates, flagged in CONCERNS.md*
- Stage-gated, human-reviewed, no auto-progression
- Sandbox-only test execution with hardcoded safety rules at `references/safety-rules.md`

### Known issues carried into v2.0

Catalogued in `.planning/codebase/CONCERNS.md`. Structural items in v2.0 scope:
- Frontmatter scheme inconsistencies
- Two-scheme stage numbering (file-prefix vs Stage-N)
- Hard-rules content duplicated across four files
- Missing `commands/`, `agents/`, `hooks/` directories
- `/refine-<skill>` references with no implementation
- `platform-pipefy`/`platform-wrike` referenced but not in this repo

Cosmetic items deferred (will be cleaned during v2.0 build):
- `plugin.json` version-string mismatches between manifests and docs
- README content truncation
- Residual "test sheet" wording
- Missing `LICENSE` file
- Email/domain mismatch (`gmail.com` vs `dydx.digital`)

---

## v2.0 — Implementor Edition (in progress)

**Status:** Planning — design-only milestone (no skill edits).
**Started:** 2026-05-09

**Goal:** Lock audit and v2 design for the dydx-delivery plugin rebuild — full ten-stage lifecycle, internalised platform skills, Coda integration, per-client persistent test harness, resolved structural decisions.

See `.planning/PROJECT.md` for current-milestone scope and `.planning/REQUIREMENTS.md` for the requirements list.

---
*Last updated: 2026-05-09 after v2.0 milestone start*
