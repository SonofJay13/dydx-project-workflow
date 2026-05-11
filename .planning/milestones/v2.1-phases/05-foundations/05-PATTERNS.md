# Phase 5: Foundations + Connector Verification — Pattern Map

**Mapped:** 2026-05-10
**Files analyzed:** 30+ (5 NEW canonical refs + 7 SKILL.md + 7 templates + 2 manifests + LICENSE + 3 scaffold dirs + 2 READMEs + OPEN-QUESTIONS.md + 1 validation script + 1 status survey)
**Analogs found:** 27 / 30 (3 genuinely new — `connector-matrix.md`, `glossary.md` plugin-runtime narrowed shape, status-survey artefact)

---

## File Classification

| New/Modified File | Role | Data Flow | Closest Analog | Match Quality |
|-------------------|------|-----------|----------------|---------------|
| `dydx-delivery/references/safety-rules.md` | canonical-reference (rules doc) | doc-load (read-at-skill-startup) | `dydx-delivery/skills/execute-tests/references/safety-rules.md` | exact (lift-and-fix per D-62) |
| `dydx-delivery/references/stage-numbering.md` | canonical-reference (mapping doc) | doc-load | `.planning/codebase/CONVENTIONS.md` (mapping-table style) | role-match |
| `dydx-delivery/references/frontmatter-scheme.md` | canonical-reference (schema doc) | doc-load | `.planning/codebase/CONVENTIONS.md` § frontmatter | role-match |
| `dydx-delivery/references/glossary.md` | canonical-reference (glossary) | doc-load | `.planning/DESIGN.md` Appendix A (per RESEARCH.md §Glossary scope) | role-match (lift-and-narrow) |
| `dydx-delivery/references/connector-matrix.md` | canonical-reference (capability matrix) | doc-load (session-start probe target) | `.planning/AUDIT.md` § AUDIT-08 (live-MCP probe table) | role-match (no exact analog — GENUINELY NEW shape) |
| `dydx-delivery/skills/execute-tests/SKILL.md` (MODIFY lines 20-30) | skill-entry (hard-rules block) | inline-edit | self (analog = same file pre-edit) | exact (in-place replacement per D-59) |
| `dydx-delivery/skills/generate-test-plan/references/test-plan-template.md` (MODIFY lines 36-44 + frontmatter line 7 + line 17) | skill-template (hard-rules block + based_on + Stage label) | inline-edit | self (analog = same file pre-edit) | exact |
| `dydx-delivery/skills/execute-tests/references/safety-rules.md` (COLLAPSE to 1-line pointer) | skill-internal (canonical-becomes-pointer) | doc-load | self pre-edit | exact (D-59 collapse) |
| `dydx-delivery/skills/generate-sow/SKILL.md` (renumber line 79 + prose refs) | skill-entry (filename refs) | inline-edit | self pre-edit | exact (find/replace per D-58 mapping) |
| `dydx-delivery/skills/generate-sow/references/sow-template.md` (renumber line 7) | skill-template (frontmatter `based_on_*`) | inline-edit | self pre-edit | exact |
| `dydx-delivery/skills/generate-functional-spec/SKILL.md` (renumber line 81 + prose refs) | skill-entry | inline-edit | self pre-edit | exact |
| `dydx-delivery/skills/generate-functional-spec/references/functional-spec-template.md` (renumber line 7 + line 13 Stage label) | skill-template | inline-edit | self pre-edit | exact |
| `dydx-delivery/skills/generate-technical-spec/SKILL.md` (renumber line 105) | skill-entry | inline-edit | self pre-edit | exact |
| `dydx-delivery/skills/generate-technical-spec/references/technical-spec-template.md` (renumber line 7 + Stage label line 13) | skill-template | inline-edit | self pre-edit | exact |
| `dydx-delivery/skills/generate-test-plan/SKILL.md` (renumber line 99) | skill-entry | inline-edit | self pre-edit | exact |
| `dydx-delivery/skills/generate-build-prompt/SKILL.md` (renumber lines 118-119) | skill-entry | inline-edit | self pre-edit | exact |
| `dydx-delivery/skills/generate-build-prompt/references/build-prompt-template.md` (renumber lines 7-8 + Stage label line 15) | skill-template | inline-edit | self pre-edit | exact |
| `dydx-delivery/skills/discovery-intake/SKILL.md` (renumber prose refs + Stage label) | skill-entry | inline-edit | self pre-edit | exact |
| `dydx-delivery/skills/discovery-intake/references/intake-template.md` (Stage label line 13) | skill-template | inline-edit | self pre-edit | exact |
| `dydx-delivery/skills/execute-tests/references/results-template.md` (renumber line 6 + Stage label line 18) | skill-template | inline-edit | self pre-edit | exact |
| `dydx-delivery/.claude-plugin/plugin.json` (line 3 version sync) | manifest (JSON) | JSON-key-edit | self pre-edit | exact (jq verifiable) |
| `.claude-plugin/marketplace.json` (lines 9, 16 version sync + add `homepage` to plugins[0]) | manifest (JSON) | JSON-key-edit | self pre-edit + `dydx-delivery/.claude-plugin/plugin.json:9` (`homepage` field shape) | exact |
| `LICENSE` (NEW at repo root) | text-asset | static-content | none (genuinely new — content is OPEN-Q23 verbatim) | no analog |
| `dydx-delivery/commands/.gitkeep` | scaffold (empty) | filesystem-marker | (any `.gitkeep` convention) | role-match |
| `dydx-delivery/agents/.gitkeep` | scaffold (empty) | filesystem-marker | same as above | role-match |
| `dydx-delivery/hooks/.gitkeep` | scaffold (empty) | filesystem-marker | same as above | role-match |
| `dydx-delivery/README.md` (line 99-105 hard-rules pointer collapse + line 126 truncation fix + B.3 step count) | doc | inline-edit | self pre-edit | exact |
| `README.md` (root, line 9 "test sheet" → "test plan" + B.3 pipeline-step count) | doc | inline-edit | self pre-edit | exact |
| `.planning/OPEN-QUESTIONS.md` (8 row Status flips: Q06.1/Q07.1/Q09/Q10/Q11/Q12/Q13/Q25 → `decided`) | register doc | inline-edit | self pre-edit (D-47 9-field schema preserved) | exact |
| `.planning/phases/05-foundations/scripts/phase5-structure-check.sh` (NEW) | validation script (Bash) | script-execution | `.planning/phases/04-open-questions/scripts/openquestions-structure-check.sh` | exact |
| `.planning/phases/05-foundations/05-STATUS-SURVEY.md` (NEW per FOUND-12) | survey artefact | doc | none direct (DESIGN-08 § Live status-lifecycle survey is closest narrative analog) | role-match (no template exists; section in `frontmatter-scheme.md` is the alternative) |

---

## Pattern Assignments

### NEW: `dydx-delivery/references/safety-rules.md` (canonical-reference, lift-and-fix)

**Analog:** `dydx-delivery/skills/execute-tests/references/safety-rules.md` (lines 1-101) — lift VERBATIM per D-62, then add CRIT-5 Coda-sandbox clause inside §3 + DESIGN-03 cross-ref preamble.

**Imports / preamble pattern** (existing file lines 1-3):
```markdown
# execute-tests — Safety rules

> These rules are hardcoded into the runner. They override anything in the test plan. They are not configurable per run.
```

**Phase 5 transformation:** rename heading from `# execute-tests — Safety rules` to `# dYdX Delivery — Safety rules (canonical)`; preamble blockquote gains a DESIGN-03 cross-ref line:

```markdown
# dYdX Delivery — Safety rules (canonical)

> Canonical SoT for hard rules per DESIGN-03 (`.planning/DESIGN.md:93-104`). These rules are hardcoded into the runner. They override anything in the test plan. They are not configurable per run.
> Override resolution: skill loads canonical SoT → loads per-client `<Client> Brain/safety-overrides.yaml` overlay if present → applies overrides only to fields tagged `overridable: true`. Rule 1 (sandbox enforcement) and Rule 3 (destructive-integrations) are non-overridable.
```

**Core rule-block pattern** (existing file lines 5-17 — Rule 1 example to copy):
```markdown
## 1. Sandbox enforcement

The runner must verify before every API call that the target IDs (pipe ID, space ID, project ID) match the `sandbox:` block in the test plan frontmatter.

**Implementation:**

- On startup, read the test plan frontmatter `sandbox:` block
- Build an allowlist of (resource_type, resource_id) pairs
- Before every API call, check that the call targets a resource in the allowlist
- If the call would target a non-allowlisted resource, refuse and log `REFUSED: out_of_sandbox`

**Explicit denylist:** never call APIs against production tenant identifiers, even if the test plan sets `sandbox:` to those IDs (the user should not do this, but the runner should still refuse).
```

**CRIT-5 Coda-allowlist insertion** — append the new bullet inside §3 enumerated list at existing file lines 33-38:

```markdown
- Coda writes ARE permitted against the per-client sandbox doc/table identified in the test plan
  frontmatter `sandbox.coda_doc:` block. Coda writes targeting any other doc are refused
  (treated as "out_of_sandbox" per Rule 1).
```

**Structural conventions to preserve:**
- 10 numbered H2 rules (`## 1.` through `## 10.`); keep every rule heading verbatim.
- Per-rule structure: short narrative paragraph → `**Implementation:**` or `**Detection:**` bold-label → bullet list OR table.
- Tables for platform-specific lists (existing file lines 22-26 + 73-77).
- Code-block format for log-line examples (existing file lines 60-67).

---

### NEW: `dydx-delivery/references/stage-numbering.md` (canonical-reference, mapping table)

**Analog:** `.planning/codebase/CONVENTIONS.md` (file-and-directory-naming section style) for table-driven mapping; AND `.planning/DESIGN.md:78-89` (DESIGN-02 contract) for the canonical mapping content (lift verbatim per RESEARCH.md item 4).

**Mapping-table pattern** to use (RESEARCH.md §Stage Numbering / lines 287-296):

```markdown
| v0.3.0 prefix | v2 prefix | Stage | Notes |
|---|---|---|---|
| `00_discovery_*` | `02_discovery_*` | Stage 2 | discovery-intake MODIFIED |
| `01_sow_*` | `03_sow_*` | Stage 3 | generate-sow UNCHANGED-structure |
| `02_functional-spec_*` | `04a_fnspec-platform_*` | Stage 4a | SPLIT into 4a + 4b per DESIGN-20; legacy `generate-functional-spec` RETIRED |
| `03_technical-spec_*` | `05_techspec_*` | Stage 5 | generate-technical-spec MODIFIED |
| `04_build-prompt_*` | `07a_build-prompt-dev_*` | Stage 7a | generate-build-prompt MODIFIED (dev path) |
| `test-plan_v*` | `08b_test-plan_*` | Stage 8b | path also moves to `<Client> Brain/test-bot/test_cases/` |
| `results-YYYY-MM-DD_v*` | `08d_test-results_*` | Stage 8d | resolves AUDIT-05.5 [NEW] label collision |
```

**Structural conventions to preserve:**
- H1 title: `# dYdX Delivery — Stage numbering (canonical)`.
- Open with a DESIGN-02 cross-ref preamble (mirror the safety-rules.md preamble shape).
- Substages section with H2 headings per DESIGN-12 (e.g., `## Stage 4 (split: 4a / 4b)`).
- Lenient-mode policy as a final H2 closing the file with cross-ref to OPEN-Q15 + DESIGN-08.

---

### NEW: `dydx-delivery/references/frontmatter-scheme.md` (canonical-reference, schema)

**Analog:** `.planning/codebase/CONVENTIONS.md` § frontmatter (extracted in `.planning/codebase/CONVENTIONS.md` lines 1-30 above; the file documents the v0.3.0 frontmatter shape that v2 narrows). DESIGN-01 contract at `.planning/DESIGN.md:62-74` is the source-of-truth for canonical fields.

**Frontmatter snippet pattern** (lift from existing skill template — `dydx-delivery/skills/generate-test-plan/references/test-plan-template.md:1-13`):

```yaml
---
client: <CLIENT_NAME>
feature: <feature-slug>
platform: <pipefy | wrike | other>
version: 1
status: draft
based_on_technical_spec: 03_technical-spec_v<N>.md
generated_at: <YYYY-MM-DD>
sandbox:
  pipe_id: <id>
  space_id: <id>
  tenant: <name>
---
```

**Phase 5 v2.0 reference frontmatter** (RESEARCH.md §Frontmatter Scheme — DESIGN-01 + DESIGN-08 + DESIGN-06 merged):

```yaml
---
client: <CLIENT_NAME>
feature: <feature-slug>
platform: <pipefy | wrike | ziflow | other>
version: 1
status: draft | client_review | approved | archived
based_on_technical_spec: 05_techspec_v<N>.md
frontmatter_version: 2
generated_at: <YYYY-MM-DD>
approved_by: <human-name>            # required when status: approved
approved_at: <ISO-8601 timestamp>    # required when status: approved
sandbox:
  pipe_id: <id>                      # only when platform: pipefy
  space_id: <id>                     # only when platform: wrike
  project_id: <id>                   # only when platform: ziflow
  tenant: <name>
---
```

**Lenient-mode contract block** (NEW — no existing analog; cite OPEN-Q15 directly):

```markdown
## Lenient-mode contract (PERMANENT)

v2 readers tolerate v0.3.0 frontmatter that is missing the `frontmatter_version` field. When `frontmatter_version` is absent, the reader assumes v0.3.0 conventions: do not raise on missing `archived` status / `approved_by` / `approved_at`. v0.3.0 in-flight artefacts are NEVER auto-flipped (per DESIGN-08); migration is opt-in per CR. This is not tied to a cutover date — it is the permanent reader contract per OPEN-Q15.
```

**Structural conventions to preserve:**
- DESIGN-01 cross-ref preamble.
- Status lifecycle as a state-machine diagram or ordered list (`draft → client_review → approved → archived`).
- Field-name convention sub-section (snake_case keys, kebab-case file paths).
- Status-lifecycle survey results either embedded as a section OR cross-referenced to `05-STATUS-SURVEY.md` (planner choice per FOUND-12).

---

### NEW: `dydx-delivery/references/glossary.md` (canonical-reference, glossary)

**Analog:** `.planning/DESIGN.md` Appendix A (per RESEARCH.md §Glossary scope — lift verbatim, then narrow to plugin-runtime terms; drop design-process-only entries like `structural-check.sh`).

**Entry pattern** (standard Markdown definition list):

```markdown
**Term** — Definition. Cross-ref `<file>:<line>` if applicable.

**Stage 8b** — Test plan generation substage of Stage 8 (test bot). Output: `08b_test-plan_v<N>.md` per `stage-numbering.md`.
```

**Structural conventions:**
- H2 grouping by category: `## Pipeline / Stage terms`, `## Frontmatter terms`, `## Platform terms (Pipefy / Wrike / Ziflow / Coda / Miro / Google Workspace)`, `## Test-bot terms`, `## Plugin-surface terms (commands / agents / hooks)`, `## Doc + sign-off terms`.
- Add 2 entries surfaced by FOUND-13 OPEN-Q research (per RESEARCH.md): `Claude for Chrome` (Q09) + `Wrike host field` (Q13).
- Alphabetise within each H2.

---

### NEW: `dydx-delivery/references/connector-matrix.md` (canonical-reference, capability matrix — GENUINELY NEW shape)

**Analog:** `.planning/AUDIT.md` § AUDIT-08 (live-MCP probe table) is the closest narrative analog — table-driven probe-result rows. The matrix shape itself is new.

**Required structure** (RESEARCH.md §Connector Matrix Schema):

1. Preamble — D-56 doc-only contract + DESIGN-07 cross-ref + UAT-3.5 / UAT-6.1 lock summary.
2. **Connectors table** (6 rows × 4 cols):
   ```markdown
   | Connector | Probe method | Endpoint / cheap-read | Owner phase |
   |---|---|---|---|
   | Coda MCP | `claude mcp list` + `whoami` | `apis/v1` | Phase 6+ |
   | Google Workspace MCP | `claude mcp list` + `list_recent_files` etc. | `drivemcp.googleapis.com/mcp/v1` (+ Gmail / Calendar) | Phase 8+ |
   | Miro MCP | `claude mcp list` + `board_search_boards` | `https://mcp.miro.com` | Phase 7+ |
   | Pipefy API | HTTP GET `https://api.pipefy.com/graphql` | 200/401 response | Phase 6 PLAT-01 |
   | Wrike API | OAuth token-exchange dry-run | per-tenant `host` from token response | Phase 6 PLAT-02 |
   | Ziflow API | OAuth token-exchange dry-run | per-tenant | Phase 6 PLAT-03 |
   ```
3. **Stage × connector grid** (11 stages × 6 connectors = 66 cells; cell value `REQUIRED | GRACEFUL | N/A`).
4. **Per-stage fallback narrative** — one bullet block per stage; 7 stages have non-trivial fallback rows per RESEARCH.md table.
5. **Resolved Q values inline** — Pipefy 500 req / 30s @ 13 req/sec throttle (Q06.1); Wrike 400 req/min per user @ 320 req/min (Q07.1); Wrike auth-concurrency = `exclusive` default (Q25); etc.

**Structural conventions to invent (no existing analog):**
- H1 title: `# dYdX Delivery — Connector availability matrix`
- Cell-value enum legend at top (REQUIRED / GRACEFUL / N/A definitions).
- Probe-cache section flags `connector_probe.yaml` schema as deferred to v2.6 / SURF-01..03 per CONTEXT D-56.

---

### MODIFIED: 7 SKILL.md files — hard-rules pointer + `based_on_*` filename renumber

**Analog:** `dydx-delivery/skills/execute-tests/SKILL.md` (the file most affected — lines 20-30 hard-rules block + frontmatter pattern preamble). Use this file as the canonical SKILL.md shape.

**SKILL.md frontmatter convention** (lines 1-4 of every skill — preserve verbatim):
```yaml
---
name: execute-tests
description: <one-line trigger phrase + verb-led summary>
---
```

**Hard-rules pointer replacement pattern** — replace existing `## Hard rules — enforced regardless of test plan content` block (lines 20-30) with the D-59 verbatim one-liner:

```markdown
> **Hard rules:** Sandbox-only operations. Read-write only against named sandbox tenants. Refuses destructive actions. See `dydx-delivery/references/safety-rules.md` for the canonical ruleset.
```

**`based_on_*` filename renumber pattern** — find/replace per RESEARCH.md table (lines 351-365). Example: `dydx-delivery/skills/generate-sow/SKILL.md:79`:
- BEFORE: `based_on_discovery: 00_discovery_v{N}.md`
- AFTER: `based_on_discovery: 02_discovery_v{N}.md`

**Stage-N self-label renumber** — example `dydx-delivery/skills/generate-test-plan/references/test-plan-template.md:17`:
- BEFORE: `> Stage 5 of the dydx-delivery pipeline. Executable test plan derived from the technical spec.`
- AFTER: `> Stage 8b of the dydx-delivery pipeline. Executable test plan derived from the technical spec.`

**Structural conventions to preserve across all 7 skill edits:**
- `## Inputs` / `## Output` / `## How to run` / `## What this skill does not do` / `## Failure modes to expect` / `## Quality bar` H2 ordering.
- Numbered Step pattern (`### Step 1 — ...` through `### Step N — ...`) inside `## How to run`.
- Block-quoted user-facing prompts (lines 38-44 of `execute-tests/SKILL.md` — start-at-any-point triage form).

---

### MODIFIED: `dydx-delivery/skills/execute-tests/references/safety-rules.md` (collapse to 1-line pointer)

**Analog:** the file itself, 101 lines, pre-edit. Per D-62: the existing 10-rule content is LIFTED to plugin-level `dydx-delivery/references/safety-rules.md`; this file then collapses to:

```markdown
# execute-tests — Safety rules

> Pointer-only. The canonical hard-rules ruleset has moved to `dydx-delivery/references/safety-rules.md` (per D-62 / FOUND-01). This pointer is preserved for cite-anchor stability — do not delete.
```

**Convention preserved:** keep the H1 `# execute-tests — Safety rules` so external cites like `dydx-delivery/skills/execute-tests/references/safety-rules.md:1` still resolve to a sensible header.

---

### MODIFIED: `dydx-delivery/.claude-plugin/plugin.json` (single key edit)

**Analog:** self pre-edit (file shown in full above, 25 lines).

**Single key edit** — line 3:
- BEFORE: `"version": "0.3.0",`
- AFTER: `"version": "2.0.0",`

**All other keys preserved verbatim** — including `author.email: "jasonmichaelb@gmail.com"` per UAT-3.1 (DO NOT TOUCH lines 5-8). `homepage` field at line 9 already correct.

---

### MODIFIED: `.claude-plugin/marketplace.json` (3 edits — version sync + B.6 homepage add)

**Analog:** self pre-edit (file shown in full above, 21 lines) + plugin.json line 9 (`homepage` field shape).

**Three edits:**
- Line 9: `"version": "1.2.0"` → `"version": "2.0.0"` (metadata version sync)
- Line 16: `"version": "0.3.0",` → `"version": "2.0.0",` (plugins[0] version sync)
- NEW field added to plugins[0] object (insert after line 18 `tags` array, before closing `}`):
  ```json
  "homepage": "https://github.com/SonofJay13/dydx-project-workflow"
  ```
  Match shape exactly to `dydx-delivery/.claude-plugin/plugin.json:9`.

**`owner.email` at line 5 PRESERVED VERBATIM per UAT-3.1.** No `description` or `tags` edits.

**Validation:** `jq -r '.metadata.version' .claude-plugin/marketplace.json` returns `2.0.0`; `jq -r '.plugins[0].homepage' .claude-plugin/marketplace.json` returns the GitHub URL.

---

### NEW: `LICENSE` (repo root, two-line boilerplate)

**Analog:** none — content is OPEN-Q23 verbatim text.

**Exact byte content:**
```
All rights reserved.
Not licensed for redistribution.
```

**Conventions:** Plain UTF-8, 2 lines, no frontmatter, no markdown headers, no copyright year line. Trailing newline conventional but not strictly required.

---

### NEW: `dydx-delivery/{commands,agents,hooks}/.gitkeep` (3 empty scaffold dirs)

**Analog:** none in this repo (no current `.gitkeep` precedent), but this is a near-universal Git convention.

**Pattern:** zero-byte file named `.gitkeep` inside each empty directory (`dydx-delivery/commands/.gitkeep`, `dydx-delivery/agents/.gitkeep`, `dydx-delivery/hooks/.gitkeep`).

**Per FOUND-09 + RESEARCH.md §Scaffold Dirs:** dirs at plugin root (siblings of `skills/`), NOT inside `.claude-plugin/`.

---

### MODIFIED: `dydx-delivery/README.md` (3 edits — hard-rules pointer + B.1 truncation + B.3 step count)

**Analog:** self pre-edit. Lines 99-105 currently carry the hard-rules duplicate block (5 condensed bullets); line 126 is the truncated changelog entry.

**Hard-rules pointer replacement** — replace existing lines 97-107 with D-59 one-liner pattern (already shown above). Heading `## Test execution — safety rules (hard)` collapses to:

```markdown
## Test execution — safety rules

> **Hard rules:** Sandbox-only operations. Read-write only against named sandbox tenants. Refuses destructive actions. See `dydx-delivery/references/safety-rules.md` for the canonical ruleset.
```

**B.1 truncation fix at line 126** — current file ends mid-word with `now c`. Suggested completion (RESEARCH.md §B.1):

```markdown
- **0.3.0** — Renamed `generate-test-sheet` → `generate-test-plan` (and `test-sheet_v*.md` → `test-plan_v*.md`) for clearer team-facing language. The bot-run terminal stage (`execute-tests`) now carries explicit sandbox-enforcement rules in `references/safety-rules.md`; results are written to versioned `results-YYYY-MM-DD_vN.md` files.
```

**B.3 step count fix** — re-count `dydx-delivery/README.md` skill rows (lines 33-41 — 7 skills); update any prose claiming "5 pipeline steps" to 7 (RESEARCH.md recommendation Option (i)).

---

### MODIFIED: `README.md` (root, 2 edits — B.2 wording + B.3 step count)

**Analog:** self pre-edit (file lines 1-25 shown above).

**B.2 fix at line 9** — single literal substitution:
- BEFORE: `... → technical spec → **test sheet** → execution`
- AFTER: `... → technical spec → **test plan** → execution`

**B.3 fix at line 9** — same line; recount arrows. Currently 6 steps separated by 5 arrows: `discovery → SOW → functional spec → technical spec → test sheet → execution`. AUDIT-07 flags as "5 steps" — actually 6 if counting destinations. Per RESEARCH.md recommendation: explicit numbered list OR "Six-stage pipeline:" prefix. Surface decision to user during W5.

---

### MODIFIED: `.planning/OPEN-QUESTIONS.md` (8 row Status flips)

**Analog:** self pre-edit. The D-47 9-field schema is already locked; only the `Status:` field changes per row.

**Per-row edit pattern** — for each of Q06.1 / Q07.1 / Q09 / Q10 / Q11 / Q12 / Q13 / Q25:
- Locate row block beginning `**OPEN-Q06.1**` (or table-form `| OPEN-Q06.1 |`).
- Find the `Status:` field within that row.
- Change value from `open` or `proposed` → `decided`.
- Append a one-line resolution citation referencing `connector-matrix.md` and the resolved value (RESEARCH.md per-Q answer text).

**Citation format per D-14** — `` `path:line` `` backtick-wrapped:
```
Status: decided — Re-confirmed wired + working 2026-05-10 (`dydx-delivery/references/connector-matrix.md:<line>` ; AUDIT-08 baseline unchanged).
```

**Conventions to preserve:**
- 9-field schema verbatim (OPEN-QN / Question / Source citations / Owning phase / Verification owner / Severity / Resolution path / Proposed default / Status).
- Severity / Resolution path / Status closed enums per A5/A6/A7 of `openquestions-structure-check.sh`.
- Backtick `path:line` citation format per D-14 carried.

---

### NEW: `.planning/phases/05-foundations/scripts/phase5-structure-check.sh`

**Analog:** `.planning/phases/04-open-questions/scripts/openquestions-structure-check.sh` (192 lines, A1..A14 assertions). EXACT structural match required.

**Header pattern to copy** (`openquestions-structure-check.sh:1-33`):
```bash
#!/usr/bin/env bash
# phase5-structure-check.sh — structural verifier for Phase 5 deliverables
#
# Comment-vs-code policy (carried from Phase 4 openquestions-structure-check.sh):
#   - Sentinel-token matches use `grep -qF` (literal-string, case-sensitive)
#   - Pattern matches use `grep -cE` (case-sensitive extended regex)
#   - Script does NOT use case-insensitive matching (no -i flag)
#
set -euo pipefail
fail() { echo "FAIL: $1" >&2; exit 1; }
```

**Section-extraction helper** (`openquestions-structure-check.sh:37-44` — lift verbatim if needed for grepping subsections of the new canonical-reference files):
```bash
section_between() {
  local heading="$1"
  awk -v hdr="$heading" '
    f && /^## /{exit}
    f{print}
    index($0, hdr) == 1 && /^## /{f=1}
  ' "$FILE"
}
```

**Assertion pattern (A1-style, file-exists)** — `openquestions-structure-check.sh:46`:
```bash
[ -f "$FILE" ] || fail "$FILE not found"
```

**Assertion pattern (grep-qF for sentinel literals)** — `openquestions-structure-check.sh:63-65`:
```bash
for h in "${required_h2[@]}"; do
  grep -qF "$h" "$OPENQ_FILE" || fail "missing required H2 anchor: $h"
done
```

**Assertion pattern (grep-cE for count floors)** — `openquestions-structure-check.sh:75-76`:
```bash
open_nn_count=$(grep -cE '^## OPEN-0[1-7]: ' "$OPENQ_FILE" || true)
[ "$open_nn_count" = "7" ] || fail "expected exactly 7 '## OPEN-0N: ' H2 anchors, found $open_nn_count"
```

**Phase 5 assertion targets** (per RESEARCH.md §Validation Architecture — ~40 assertions A1..A40):
- A1: `test -f dydx-delivery/references/safety-rules.md`
- A2: `grep -q "Coda writes ARE permitted" dydx-delivery/references/safety-rules.md`
- A3: `grep -q "DESIGN-03" dydx-delivery/references/safety-rules.md`
- A4: `test -f dydx-delivery/references/stage-numbering.md`
- ... (continue per RESEARCH.md req → assertion table, 13 FOUND-* groups)
- A37+: `jq -r '.version' dydx-delivery/.claude-plugin/plugin.json` returns `2.0.0`
- A38+: `! grep -i "test sheet" README.md` (zero-hits negative assertion)
- A39+: `[ "$(ls -1 dydx-delivery/commands/ | grep -v '.gitkeep' | wc -l)" -eq 0 ]`
- A40: `diff <(printf 'All rights reserved.\nNot licensed for redistribution.\n') LICENSE` returns empty

**Closing pattern** (`openquestions-structure-check.sh:190-191`):
```bash
echo "OK: all structural checks passed"
exit 0
```

---

### NEW: `.planning/phases/05-foundations/05-STATUS-SURVEY.md` (FOUND-12 deliverable)

**Analog:** none direct. `.planning/DESIGN.md` § "Live status-lifecycle survey" (DESIGN-08 lines 245-274 per RESEARCH.md item 10) is the closest narrative analog — re-use its methodology section structure.

**Required content (RESEARCH.md §Status Survey Re-run / Deliverable):**
1. Methodology block (Option A Coda MCP `page_read` against 2 known brains OR Option B SKILL.md fallback). Recommendation per RESEARCH = Option A.
2. Sample sources — cite the 2 Coda brain doc URLs (Up & Up Group + VodafoneZiggo per `reference_client_brain_coda_docs.md` memory).
3. Distinct `status:` values found in live data.
4. Reconciliation against canonical `{draft, client_review, approved, archived}`.
5. Conclusion line: literal `no drift` OR `drift detected — adjudication required` (grep-asserted by structure-check A12 per RESEARCH.md).

**Alternative location:** RESEARCH.md flags option to embed survey as a section in `frontmatter-scheme.md` instead of a separate file. Planner adjudicates in W1.

---

## Shared Patterns

### Canonical-reference preamble (apply to all 5 NEW `references/*.md` files)

**Source pattern:** `dydx-delivery/skills/execute-tests/references/safety-rules.md:1-3` (current canonical safety-rules preamble).

**Apply to:** `safety-rules.md`, `stage-numbering.md`, `frontmatter-scheme.md`, `glossary.md`, `connector-matrix.md`.

**Pattern:**
```markdown
# dYdX Delivery — <Reference Name> (canonical)

> Canonical SoT per <DESIGN-NN> (`.planning/DESIGN.md:<lines>`). <One-line statement of authority + lifecycle>. Override / lenient-mode contract: <one-line cross-ref to OPEN-Q15 or DESIGN-NN>.
```

### Hard-rules pointer one-liner (apply to 4 files per AUDIT-05.1, NOT 4 per D-59)

**Source:** D-59 verbatim wording (CONTEXT.md decision).

**Apply to (per AUDIT-05.1 — overrides D-59 nominees per RESEARCH.md item 5):**
1. `dydx-delivery/skills/execute-tests/SKILL.md` lines 20-30
2. `dydx-delivery/skills/generate-test-plan/references/test-plan-template.md` lines 36-44
3. `dydx-delivery/README.md` lines 99-105
4. `dydx-delivery/skills/execute-tests/references/safety-rules.md` (full file collapse to header + pointer)

**Pattern (verbatim):**
```markdown
> **Hard rules:** Sandbox-only operations. Read-write only against named sandbox tenants. Refuses destructive actions. See `dydx-delivery/references/safety-rules.md` for the canonical ruleset.
```

**Validation:** `grep -l "See \`dydx-delivery/references/safety-rules.md\` for the canonical ruleset" <4 files> | wc -l` returns `4`.

**RESEARCH.md flag:** D-59 nominates `discovery-intake/SKILL.md` and `generate-sow/SKILL.md` as 2 of the 4, but grep verification shows those files do NOT carry hard-rules duplicates — AUDIT-05.1 ground truth is the table above. Surface this discrepancy to user before W2 if uncertain.

### Filename renumber (apply to all 13 `based_on_*` value strings + all prose filename refs)

**Source:** RESEARCH.md §Skill Repoint Mechanics (`based_on_*` filename renumber table) + DESIGN-02 mapping.

**Apply to:** all 7 SKILL.md + all 7 `references/*-template.md` (where filename references appear).

**Mapping (DESIGN-02 verbatim):**
| Old prefix | New prefix |
|---|---|
| `00_discovery_*` | `02_discovery_*` |
| `01_sow_*` | `03_sow_*` |
| `02_functional-spec_*` | `04a_fnspec-platform_*` |
| `03_technical-spec_*` | `05_techspec_*` |
| `04_build-prompt_*` | `07a_build-prompt-dev_*` |
| `test-plan_v*` | `08b_test-plan_*` |
| `results-YYYY-MM-DD_v*` | `08d_test-results_*` |

**Validation:** zero-hits assertion `! grep -rn "01_sow_v\|02_functional-spec_v\|03_technical-spec_v\|04_build-prompt_v" dydx-delivery/skills/`.

### Stage-N self-label renumber (apply to 6 of 7 templates)

**Source:** RESEARCH.md §Codebase Reality / Templates' "Stage N" self-labels.

**Apply to:**
- `intake-template.md:13` "Stage 0" → "Stage 2"
- `functional-spec-template.md:13` "Stage 2" → "Stage 4a"
- `technical-spec-template.md:13` "Stage 3" → "Stage 5"
- `test-plan-template.md:17` "Stage 5" → "Stage 8b"
- `build-prompt-template.md:15` "Stage 6" → "Stage 7a"
- `results-template.md:18` "Stage 6" → "Stage 8d"
- `sow-template.md` — no Stage label currently; optionally add "Stage 3"

### OPEN-Q row-flip (apply to 8 rows in `.planning/OPEN-QUESTIONS.md`)

**Source:** D-47 9-field schema (Phase 4 lock) + RESEARCH.md §Open Questions Resolution per-Q answers.

**Apply to:** Q06.1, Q07.1, Q09, Q10, Q11, Q12, Q13, Q25.

**Pattern (per row):**
- Status: `open` or `proposed` → `decided`.
- Append one-line resolution with backtick `path:line` citation per D-14.
- Preserve all other 8 schema fields verbatim.

**Validation per A14 of phase4 script:** for first 20 backtick-wrapped citations, confirm cited file exists AND cited line is within file's line count.

### JSON manifest editing convention

**Source:** `dydx-delivery/.claude-plugin/plugin.json` (existing 25-line file) + `.claude-plugin/marketplace.json` (existing 21-line file).

**Apply to:** plugin.json + marketplace.json edits in W3.

**Conventions:**
- 2-space indentation (verified in both files).
- Trailing newline at EOF.
- Key ordering preserved exactly — insert new keys at end of object (e.g., `homepage` last in plugins[0]).
- Strings double-quoted; no trailing commas.
- `jq -r '<query>' <file>` for validation (RESEARCH.md §Validation Architecture).

---

## No Analog Found

| File | Role | Reason |
|------|------|--------|
| `LICENSE` | text-asset | Genuinely new — content is OPEN-Q23 verbatim two-line boilerplate; no template needed |
| `dydx-delivery/references/connector-matrix.md` | capability matrix | Shape is new — no existing 6×11 stage/connector grid in this repo. AUDIT-08 probe table is closest narrative cousin but structurally different |
| `.planning/phases/05-foundations/05-STATUS-SURVEY.md` | survey artefact | No template precedent — DESIGN-08 § "Live status-lifecycle survey" prose is closest analog. Methodology section can mirror it |

---

## Metadata

**Analog search scope:** `dydx-delivery/` (skills + manifests + READMEs), `.planning/` (DESIGN.md, AUDIT.md, OPEN-QUESTIONS.md, codebase/, phases/04-open-questions/scripts/), `README.md` (root), `.claude-plugin/`.

**Files scanned:** ~25 files read or grep-verified during pattern extraction (per CONTEXT.md + RESEARCH.md citations).

**Pattern extraction date:** 2026-05-10.

**Cross-AI risk flags surfaced for planner:**
- D-59 nominates 2 wrong files (discovery-intake / generate-sow); AUDIT-05.1 ground truth = 4 different files. Confirm with user before W2.
- B.6 (homepage) timing — W3 vs W5. RESEARCH recommends W3 inline with version sync; W5 documents closure.
- B.3 step-count semantics — 7 skills (v0.3.0 reality) vs 13 skills (v2 end-state). RESEARCH recommends Option (i) = current shipped reality. Surface to user in W5.
- Status-survey method — Option A (Coda MCP probe of 2 live brains) vs Option B (SKILL.md fallback). RESEARCH recommends A; falls back to B if Coda permission denied.
- `mcpServers` field on plugin.json — DESIGN-04 calls for it; Phase 5 silent. RESEARCH recommends defer to later v2.x phase.
