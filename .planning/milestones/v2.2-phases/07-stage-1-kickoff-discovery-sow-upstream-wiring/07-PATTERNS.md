# Phase 7: Stage 1 Kickoff + Discovery/SOW upstream wiring — Pattern Map

**Mapped:** 2026-05-11
**Files analyzed:** 8 (5 NEW + 3 MODIFIED)
**Analogs found:** 7 / 8 (1 file = `auto-classify-rubric.md` has no direct analog — author from D-73 spec)

---

## File Classification

| File | New/Mod | Role | Data Flow | Closest Analog | Match Quality |
|---|---|---|---|---|---|
| `dydx-delivery/skills/kickoff-capture/SKILL.md` | NEW | skill body | write-path (artefact author) | `dydx-delivery/skills/discovery-intake/SKILL.md` (v0.3.0 body shape) + `dydx-delivery/skills/platform-pipefy/SKILL.md` (FOUND-04 pointer sentence) | exact (body shape) + exact (pointer pattern) |
| `dydx-delivery/skills/kickoff-capture/references/kickoff-template.md` | NEW | template body | write-path (artefact shape) | `dydx-delivery/skills/discovery-intake/references/intake-template.md` | exact (template convention) |
| `dydx-delivery/skills/kickoff-capture/references/auto-classify-rubric.md` | NEW | reference doc (rubric) | read-path (operational protocol) | none — author from D-73 + STG1-04 | no-analog |
| `dydx-delivery/skills/kickoff-capture/references/capture-paths.md` | NEW | reference doc (protocol) | read-path (operational protocol) | none direct — closest shape is `dydx-delivery/skills/execute-tests/references/safety-rules.md` (local-supporting-ref shape only); author body from STG1-05 + D-72 | shape-only |
| `.planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/scripts/phase7-structure-check.sh` | NEW | verification harness | harness (read-only filesystem asserts) | `.planning/milestones/v2.1-phases/06-internalise-platform-skills/scripts/phase6-structure-check.sh` | exact (direct lift) |
| `dydx-delivery/skills/discovery-intake/SKILL.md` | MOD | skill body | write-path (artefact author) | itself (surgical edits to v0.3.0 body) | self |
| `dydx-delivery/skills/generate-sow/SKILL.md` | MOD | skill body | write-path (artefact author) | itself (surgical edits to v0.3.0 body) | self |
| `dydx-delivery/skills/generate-sow/references/sow-template.md` | MOD | template body | write-path (artefact shape) | itself (H2 split + frontmatter dual-input edit) | self |

---

## Pattern Assignments

### 1. `dydx-delivery/skills/kickoff-capture/SKILL.md` (skill body, write-path)

**Primary analog:** `dydx-delivery/skills/discovery-intake/SKILL.md` (149 lines) — body shape
**Secondary analog:** `dydx-delivery/skills/platform-pipefy/SKILL.md` lines 1-27 — FOUND-04 canonical-pointer sentence

**Frontmatter shape** — lift from `discovery-intake/SKILL.md` lines 1-4:

```yaml
---
name: discovery-intake
description: Capture client discovery for a new engagement or feature. Use when the user says "start discovery for X", "capture intake for X", ...
---
```

Adapt for kickoff: replace `name:` value, replace `description:` with kickoff-specific triggers ("kickoff for X", "start kickoff", "capture meeting notes for X", "run kickoff"). DESIGN-17 line 562 supplies the kickoff frontmatter fields the SKILL.md Step 5 frontmatter block must emit verbatim (lift target — see RESEARCH §2 DESIGN-17 table).

**Body shape** — lift skeleton from `discovery-intake/SKILL.md` per `.planning/codebase/CONVENTIONS.md` lines 185-201:

```markdown
# kickoff-capture

<One-paragraph purpose statement referencing "Stage 1 of the dydx-delivery pipeline">

## Inputs
- <bulleted list>

## Output
`<Client>/build-specs/<platform>/01_kickoff_vN.md` — versioned, frontmatter-tagged.

## How to run

### Step 1 — Locate upstream / capture entry point
<start-at-any-point triage>

### Step 2..N — <middle steps including senior-level challenge>

### Step N — Write and hand off
<frontmatter block + exact handoff message verbatim from DESIGN-17 line 574>

## What this skill does not do
<negative scope bullets>

## Quality bar
<bulleted "good looks like">
```

**Canonical-pointer sentence pattern** — lift verbatim shape from `platform-pipefy/SKILL.md` line 27:

```markdown
> **Hard rules:** Sandbox-only operations. Read-write only against named sandbox tenants. Refuses destructive actions. See `dydx-delivery/references/safety-rules.md` for the canonical ruleset.
```

The pattern is: `> **<topic>:** <one-line context>. See \`dydx-delivery/references/<file>.md\` for the canonical <noun>.`

**Deviation from analog:** kickoff-capture must carry **all 4 canonical pointer sentences inline** (safety-rules / stage-numbering / frontmatter-scheme / glossary) per STG1-01. Existing Phase 6 platform skills carry only the safety-rules pointer inline (other 3 transitive via `references/`). RESEARCH §6 supplies the 4-block draft block for direct lift. Structure-check K3 asserts presence of all 4 `dydx-delivery/references/<canonical>.md` substrings.

**Step structure deviation from discovery-intake:** kickoff-capture is the entry skill (no upstream artefact). Step 1 = locate/establish capture entry point (paste / Miro / Field Notes), not "locate upstream". Add a dedicated routing step (Step 4 per Open Question #3 in RESEARCH §11) that classifies `kickoff_branch:` value before Step 5 (Write).

**Handoff message** — lift verbatim from DESIGN-17 line 574:

```
Awaiting status: approved write to 01_kickoff_v<N>.md. Branch routing on kickoff_branch: value (discovery-ready -> Stage 2; draft-sow -> SKIP Stage 2 -> Stage 3).
```

---

### 2. `dydx-delivery/skills/kickoff-capture/references/kickoff-template.md` (template body, write-path)

**Analog:** `dydx-delivery/skills/discovery-intake/references/intake-template.md` (157 lines)

**Frontmatter block** — lift shape from `intake-template.md` lines 1-9:

```yaml
---
client: <CLIENT_NAME>
platform: <pipefy | wrike | other>
integrations: []
version: 1
status: draft
captured_by: <USER>
captured_at: <YYYY-MM-DD>
---
```

**Deviation:** replace fields per DESIGN-17 line 562 verbatim:

```yaml
---
client: <CLIENT_NAME>
project: <PROJECT_NAME>
frontmatter_version: 2
kickoff_branch: <discovery-ready | draft-sow>
field_notes_processed_count: <N>
status: draft
---
```

Per R-02 (RESEARCH §11): use `discovery-ready | draft-sow` enum spelling (DESIGN-17 line 562 + STG1-02 + Roadmap — authoritative); do NOT lift glossary line 1482's `kickoff-direct | discovery-via` outlier.

**Body opening pattern** — lift shape from `intake-template.md` lines 11-13:

```markdown
# Discovery — <CLIENT_NAME> · <FEATURE_OR_ENGAGEMENT>

> Stage 2 of the dydx-delivery pipeline. Captures the operational reality so downstream stages (SOW, functional spec, technical spec, test plan) have a real foundation. Mark every unknown explicitly — do not guess.
```

Adapt to: `# Kickoff — <CLIENT_NAME> · <ENGAGEMENT_NAME>` + Stage 1 blurb + the `[unknown — needs human classification]` marker convention statement (verbatim per STG1-04 / DESIGN-17 line 566).

**H2 sections** — DEVIATE from `intake-template.md`'s 9-section layout (Business outcome / Users / Systems / Triggers / Data / Rules / Integrations / Exceptions / Open Questions). Use the locked 8-category list verbatim from STG1-04 / DESIGN-17 line 581 **in this order**:

1. `## 1. System`
2. `## 2. Users`
3. `## 3. Triggers`
4. `## 4. Data`
5. `## 5. Rules`
6. `## 6. Integrations`
7. `## 7. Exceptions`
8. `## 8. Failure points`

Per RESEARCH §11 R-04: the 9-vs-8 mismatch with discovery is intentional per STG2-03 body-unchanged contract. Do not "fix" discovery to align.

**Section body shape** — each H2 section's body should mirror `intake-template.md` lines 17-26 (mix of prose prompts, tables for enumerated lists, italic placeholders). Each section MUST support the `[unknown — needs human classification]` marker inline (STG1-04 + structure-check K5).

**Routing block** — add a `## Routing` section before `## Sign-off` that documents which `kickoff_branch:` value applies and the rationale. No analog — author from STG1-02 + DESIGN-17 lines 563-565.

---

### 3. `dydx-delivery/skills/kickoff-capture/references/auto-classify-rubric.md` (reference doc, read-path)

**Analog:** none direct — D-73 is novel rubric authorship.

**Body shape guidance** (author from D-73 + STG1-04):

```markdown
# Auto-classification rubric

> When to emit `[unknown — needs human classification]` in a kickoff section.

## Explicit triggers

The classifier MUST emit the `[unknown — needs human classification]` marker when ANY of these apply:

1. **Category not named verbatim** in any source input (meeting notes / Miro paste / Field Notes paste).
2. **< 2 distinct source mentions** — would require synthesising from a single witness.
3. **Source contains explicit `TBD` / `?` / `unclear` / `come back to this`** text against this category.
4. **Source mentions cross conflicting alternatives** without resolution.
5. **Reviewer pre-flagged TBD** in the kickoff template input.

## Input-signal → outcome escalation

| Trigger | Section keeps marker | Section partially fills + retains marker | Section proceeds without marker |
|---|---|---|---|
| Trigger 1 (not named) | X | | |
| Trigger 2 (< 2 mentions) | | X | |
| ... | | | |

## Operational principle

> Mark unknown when you'd hesitate to defend the classification to a reviewer.

This is the final defensive backstop on top of the explicit triggers above.
```

**Structure-check coupling:** structure-check K5 + K7 assertions check (a) the marker convention is documented in SKILL.md and (b) SKILL.md references `references/auto-classify-rubric.md` by relative path.

---

### 4. `dydx-delivery/skills/kickoff-capture/references/capture-paths.md` (reference doc, read-path)

**Analog:** shape-only — `dydx-delivery/skills/execute-tests/references/safety-rules.md` is a local-supporting-ref alongside the template (mirrors the D-71 multi-ref shape). Body content is novel — author from STG1-05 + D-72.

**Body shape guidance** (author from STG1-05 + D-72):

```markdown
# Capture paths

> Three paths feed kickoff-capture. All are paste-only per UAT-3.5 / UAT-6.1 (no MCP, no API calls).

## Path 1 — Meeting notes paste (freeform)

<protocol>

## Path 2 — Miro paste fallback

<DESIGN-07 / AUDIT-08 shape: image-paste with text describing workflow>

## Path 3 — Field Notes (Coda) paste

The Field Notes Coda table is a **read-only input queue**. Kickoff never auto-merges entries.

**Triage filter (default):** `processed_at IS NULL`

**Protocol:**
1. Reviewer queries Coda manually (web app + filter).
2. Pastes rows into the kickoff session.
3. For each row, kickoff quotes the note + asks human: **keep / drop / edit-and-keep** (MOD-8 prevention per DESIGN-09).
```

**Verbatim strings required (structure-check coupling):**
- `processed_at IS NULL` — verbatim per DESIGN-09 (structure-check K6 asserts).
- `[unknown — needs human classification]` may appear here referring to the marker rubric (not asserted here — K5 asserts on SKILL.md).

**Deferred ideas surfaced:** future Coda MCP integration captured under Deferred Ideas (v2.6 / SURF-01..03). Today's body says paste-only verbatim.

---

### 5. `.planning/phases/07-stage-1-kickoff-discovery-sow-upstream-wiring/scripts/phase7-structure-check.sh` (verification harness)

**Analog:** `.planning/milestones/v2.1-phases/06-internalise-platform-skills/scripts/phase6-structure-check.sh` (281 lines — direct lift)

**Shebang + banner pattern** — lift shape from phase6 lines 1-40, adapt title + partition values:

```bash
#!/usr/bin/env bash
# phase7-structure-check.sh — structural verifier for Phase 7 (Stage 1 kickoff + Stage 2/3 upstream wiring) deliverables
#
# Comment-vs-code policy (carried from Phase 5 / Phase 6):
#   - Sentinel-token matches use `grep -qF` (literal-string, case-sensitive)
#   - Pattern matches use `grep -cE` / `grep -qE` (case-sensitive extended regex)
#   - Script does NOT use case-insensitive matching ...
#
# Per-section partition (D-77): `--section <kickoff|discovery|sow>` runs ONLY that
# section's assertion subset so plans 07-02 / 07-03 can self-verify before all 3
# skills exist on disk. Cross-section gate runs in full mode (`--all` or no flag).
#
# Invocation modes:
#   bash phase7-structure-check.sh                       # full suite
#   bash phase7-structure-check.sh --section kickoff
#   bash phase7-structure-check.sh --section discovery
#   bash phase7-structure-check.sh --section sow
#   bash phase7-structure-check.sh --all                 # alias for no-flag
```

**Helpers + set flags** — lift verbatim from phase6 lines 41-44:

```bash
set -euo pipefail

fail() { echo "FAIL: $1" >&2; exit 1; }
pass() { echo "PASS: $1"; }
```

**Arg parser** — lift shape from phase6 lines 46-68, adapt USAGE block to list `kickoff|discovery|sow|all`. Add `--all` branch (Phase 7 deviation: 4 dispatch modes vs phase6's 3):

```bash
SECTION="${SECTION:-}"
while [ $# -gt 0 ]; do
  case "$1" in
    --section) SECTION="${2:-}"; shift 2 ;;
    --all)     SECTION="all"; shift ;;
    --quick)   shift ;;
    --help|-h) cat <<'USAGE'
Usage: phase7-structure-check.sh [--section <kickoff|discovery|sow|all>]
  ...
USAGE
      exit 0 ;;
    *) echo "Unknown arg: $1" >&2; exit 2 ;;
  esac
done
```

**Per-section assertion runner shape** — lift shape from phase6 `run_pipefy_section()` (lines 74-144). RESEARCH §3 carries the complete D-77 assertion bodies (K1..K7, D1..D3, S1..S2, X1..X2) for direct lift. Example pattern from phase6 lines 76-78:

```bash
run_kickoff_section() {
  # K1 — kickoff-capture SKILL.md exists
  [ -f dydx-delivery/skills/kickoff-capture/SKILL.md ] \
    || fail "K1: dydx-delivery/skills/kickoff-capture/SKILL.md missing"
  pass "K1: kickoff-capture SKILL.md exists"
  ...
}
```

**Multi-file existence check pattern** — lift from phase6 lines 80-86 (Pipefy A4):

```bash
local ref
for ref in kickoff-template.md auto-classify-rubric.md capture-paths.md; do
  [ -f "dydx-delivery/skills/kickoff-capture/references/$ref" ] \
    || fail "K2: missing references/$ref"
done
pass "K2: 3 references/ files exist"
```

**Verbatim literal-string assertion pattern** — lift from phase6 lines 99-103 (Pipefy A8 canonical endpoint):

```bash
grep -qF 'Stage 2 SKIPPED — kickoff branch = draft-sow' \
  dydx-delivery/skills/discovery-intake/SKILL.md \
  || fail "D3: verbatim skip-message missing"
pass "D3: verbatim skip-message present"
```

**Regex-enum assertion pattern** — lift from phase6 lines 89-91 (Pipefy A5 ISO date) / lines 93-96 (Pipefy A6 enum):

```bash
grep -qE '^kickoff_branch: (discovery-ready|draft-sow)$' \
  dydx-delivery/skills/kickoff-capture/references/kickoff-template.md \
  || fail "K4: kickoff_branch enum missing/malformed"
pass "K4: kickoff_branch enum present"
```

**Cross-section runner pattern** — lift shape from phase6 `run_cross_tree_section()` (lines 234-265). **Deviation:** Phase 7 does NOT need the `awk`-between-headings OPEN-Q row-flip extraction (phase6 lines 252-264) because RESEARCH §1 confirms zero STG-prefixed OPEN-Q rows exist. Replace A16 body with X1 (`kickoff_branch:` cross-skill consistency) + X2 (`based_on_kickoff:` cross-consumer consistency) per RESEARCH §3.

**Dispatch case** — lift shape from phase6 lines 271-277, add `all` branch + `--all` flag handling:

```bash
case "$SECTION" in
  kickoff)   run_kickoff_section ;;
  discovery) run_discovery_section ;;
  sow)       run_sow_section ;;
  all|"")    run_kickoff_section; run_discovery_section; run_sow_section; run_cross_section ;;
  *)         fail "unknown --section value: $SECTION (use kickoff|discovery|sow|all)" ;;
esac

echo "ALL ASSERTIONS PASSED"
exit 0
```

**Deviations from phase6:**
- 4 dispatch modes (`kickoff|discovery|sow|all`) vs phase6's 3 (`pipefy|wrike|ziflow`).
- No A7-style forbidden-token cross-tree gate needed (no enum-value drift to guard against in Phase 7 — the `kickoff_branch` enum is asserted positively via K4).
- No A16-style OPEN-Q row-flip awk extraction needed (zero STG rows per RESEARCH §1).
- 3 per-section + 1 cross-section runner (matches phase6 structurally; per-section assertion counts differ).

---

### 6. `dydx-delivery/skills/discovery-intake/SKILL.md` (skill body, write-path) — SURGICAL EDITS

**Analog:** itself (v0.3.0 body) — line-numbered landmarks from RESEARCH §4.

**Surgical edits required** (verbatim from RESEARCH §4 table):

| Section | Current lines | Edit |
|---|---|---|
| Frontmatter `description:` | 3 | Drop "pasted meeting notes / transcript" trigger phrasing; replace with "consume approved kickoff artefact". |
| `## Inputs` | 10-13 | REPLACE bullets. Drop "Free-form context: chat, pasted meeting notes, transcript, brief, email thread". Add: "Approved `01_kickoff_v<N>.md` (sole upstream artefact) carrying `status: approved` + `kickoff_branch:` enum". |
| `### Step 1 — Establish target location` | 23-29 | Insert sub-step reading `kickoff_branch:` from kickoff frontmatter. If `draft-sow` → emit verbatim skip-message + exit (D-74 branch, no writes). |
| `### Step 5 — Draft the artefact` frontmatter block | 97-107 | ADD MANDATORY field `based_on_kickoff: 01_kickoff_v<N>.md` to the YAML block. Keep `captured_by` / `captured_at` (STG2-03 body-unchanged). |
| `### Step 6 — Write and hand off` | 109-122 | Replace bulleted review-steps block with DESIGN-18 line 612 verbatim handoff. |
| `## Start-at-any-point handling` | 124-130 | DELETE entirely (raw-notes path RETIRED per STG2-01). |
| `## What this skill does not do` | 132-138 | ADD bullet: "Does not accept raw notes — that path is RETIRED. Discovery is a pure transform of an approved kickoff artefact." |

**Verbatim skip-message** (D-74 / STG2-02 / Roadmap criterion #3 — authoritative per R-01 in RESEARCH §11):

```
Stage 2 SKIPPED — kickoff branch = draft-sow
```

Do NOT lift DESIGN-18 line 604's drift spelling. Structure-check D3 asserts this exact string via `grep -qF`.

**Structure-check coupling:** D1 asserts `based_on_kickoff` literal + (MANDATORY|required) keyword in SKILL.md; D2 asserts raw-notes RETIRED marker; D3 asserts verbatim skip-message.

---

### 7. `dydx-delivery/skills/generate-sow/SKILL.md` (skill body, write-path) — SURGICAL EDITS

**Analog:** itself (v0.3.0 body) — line-numbered landmarks from RESEARCH §4.

**Surgical edits required** (verbatim from RESEARCH §4 table):

| Section | Current lines | Edit |
|---|---|---|
| `## Inputs` | 11-14 | UPDATE per DESIGN-19 line 635-636: dual upstream input — approved `02_discovery_v<N>.md` (normal path) OR approved `01_kickoff_v<N>.md` (draft-sow path). Note `based_on_kickoff:` is read when Stage 2 was skipped. |
| `### Step 1 — Locate upstream artefact` | 22-34 | UPDATE triage prompt: read kickoff first; on `draft-sow` use kickoff directly; on `discovery-ready` look for approved `02_discovery_v*.md`. |
| `### Step 3 — Draft the SOW` Subsection 2 | 41-56 | UPDATE the "In-scope deliverables" narrative to reflect dual-H2 split (`## Platform Scope` + `## Integration Scope`) per D-75. Body narrative largely intact; template carries the H2 split. |
| `### Step 5 — Write and hand off` frontmatter block | 72-82 | UPDATE: SKILL.md body documents canonical 4-state lifecycle `draft → client_review → approved → archived` (STG3-01); add `based_on_kickoff:` (draft-sow path) OR `based_on_discovery:` (normal path) — one or the other, not both (DESIGN-19 line 643). |
| `### Step 5 — Write and hand off` handoff message | 84-95 | REPLACE with DESIGN-19 line 653 verbatim. Update from `generate-functional-spec` reference to Stage 4a/4b nomenclature per RESEARCH §11 R-05 recommendation. |
| `## What this skill does not do` | 97-101 | ADD: "Does not split scope by platform vs integration at the artefact level; that split happens at Stage 4 (Fnspec) — single SOW carries both as ## Platform Scope + ## Integration Scope H2s." |

**Verbatim canonical lifecycle string** (STG3-01 + DESIGN-19 lines 643 + 657):

```
draft → client_review → approved → archived
```

Structure-check S1 asserts this exact string via `grep -qF` against SKILL.md OR sow-template.md (either location satisfies).

**Verbatim handoff** (DESIGN-19 line 653):

```
Awaiting status: approved on 03_sow_v<N>.md; routing to Stage 4a (platform fnspec) and/or Stage 4b (integration fnspec) per project scope.
```

---

### 8. `dydx-delivery/skills/generate-sow/references/sow-template.md` (template body, write-path) — SURGICAL EDITS

**Analog:** itself (v0.3.0 body — 155 lines) — line-numbered landmarks from RESEARCH §5.

**Surgical edits required** (verbatim from RESEARCH §5 table):

| Line | Current | Edit |
|---|---|---|
| 6 | `status: draft` | Keep value. Add comment/nearby narrative documenting canonical lifecycle `draft → client_review → approved → archived` (STG3-01). |
| 7 | `based_on_discovery: 02_discovery_v<N>.md` | Replace with dual policy per DESIGN-19 line 643: `based_on_discovery:` OR `based_on_kickoff:` (one or the other, not both). |
| 26-33 | `## 2. In-scope deliverables` block (single table) | SPLIT into two H2 sections: `## Platform Scope` + `## Integration Scope` per D-75. Section numbering at planner discretion — the canonical assertion checks for literal H2 headers `## Platform Scope` and `## Integration Scope` substrings. |
| 147-155 | `## Handoff` block (current text references `generate-functional-spec`) | Update to Stage 4a/4b nomenclature per RESEARCH §11 R-05 (recommendation: bundle into Phase 7 to avoid Phase 8 follow-up). |

**Structure-check coupling:** S2 asserts presence of `^## Platform Scope` AND `^## Integration Scope` H2 headers via `grep -qE` (anchored at line start).

**Deviation from analog (itself):** original template's `## 2. In-scope deliverables` single-table form is split to two H2 sections with dedicated tables. Sections 3-11 renumbered down by one, OR planner keeps "## 2. In-scope deliverables" as a wrapper with two H2s underneath — planner discretion. Structure-check is renumber-agnostic (checks literal H2 substrings, not numbering).

---

## Shared Patterns

### Pattern: Canonical-pointer sentence (FOUND-04 / D-59)

**Source:** `dydx-delivery/skills/platform-pipefy/SKILL.md` line 27 (cross-verified at `platform-wrike/SKILL.md:28` + `platform-ziflow/SKILL.md:27` — uniform shape).

**Form:**

```markdown
> **<topic>:** <one-line context>. See `dydx-delivery/references/<canonical-file>.md` for the canonical <noun>.
```

**Apply to:** `kickoff-capture/SKILL.md` — must carry all 4 pointer sentences inline (STG1-01 requirement; stronger than v2.1 platform-skill precedent which carries only safety-rules inline). 4-block draft in RESEARCH §6 ready for direct lift.

---

### Pattern: SKILL.md body shape (CONVENTIONS.md lines 185-201)

**Source:** `.planning/codebase/CONVENTIONS.md` § "SKILL.md body structure" (lines 185-201). Cross-verified against all v0.3.0 stage skills + 3 Phase 6 platform skills.

**Sections in order:**
1. H1 matching directory name
2. One-paragraph purpose statement referencing pipeline stage
3. `## Inputs`
4. `## Output` (single path with `<N>` versioned)
5. `## How to run` — numbered `### Step N — <title>` blocks; Step 1 = Locate upstream artefact w/ start-at-any-point triage; late step = Senior-level challenge; final step = Write and hand off (frontmatter block + exact handoff message)
6. `## What this skill does not do`
7. `## Quality bar`

**Apply to:** `kickoff-capture/SKILL.md` (full body authorship); discovery-intake/generate-sow SKILL.md surgical edits preserve this shape.

---

### Pattern: Bash structure-check script skeleton

**Source:** `.planning/milestones/v2.1-phases/06-internalise-platform-skills/scripts/phase6-structure-check.sh` (281 lines)

**Lift verbatim:**
- Shebang line + comment-vs-code policy banner shape (lines 1-40, retitled)
- `set -euo pipefail` (line 41)
- `fail()` / `pass()` helpers (lines 43-44)
- Arg parser case-statement (lines 46-68)
- Per-section runner function shape (lines 74-228)
- Dispatch case (lines 271-277, adapt to 4 modes)
- Exit conventions: `fail` → `exit 1`; success → `echo "ALL ASSERTIONS PASSED" + exit 0` (lines 279-280)

**Apply to:** `scripts/phase7-structure-check.sh` (full file lift-and-adapt).

---

### Pattern: Verbatim literal-string assertion (single-source-of-truth contracts)

**Source:** phase6-structure-check.sh `grep -qF` usage throughout (e.g. lines 99-100, 106-107, 174-175).

**Form:**

```bash
grep -qF '<exact verbatim string>' <path-to-file> \
  || fail "<assertion-ID>: <human description>"
pass "<assertion-ID>: <human description>"
```

**Apply to:**
- D3 — `Stage 2 SKIPPED — kickoff branch = draft-sow` (discovery-intake/SKILL.md)
- K5 — `[unknown — needs human classification]` (kickoff-capture/SKILL.md)
- K6 — `processed_at IS NULL` (kickoff-capture/references/capture-paths.md)
- S1 — `draft → client_review → approved → archived` (generate-sow/SKILL.md or sow-template.md)

`grep -qF` (literal, case-sensitive) is the correct tool. Avoid `-i` (RESEARCH §3 notes Git Bash GNU grep 3.0 SIGABRTs on `-i` against UTF-8 multibyte content; em-dash + arrow chars are multibyte).

---

### Pattern: Lift-and-fix template authoring (D-62 precedent, applied per D-70)

**Source:** Phase 5 D-62 precedent — planner attempts to lift any DESIGN-N literal blocks before authoring from scratch.

**Apply to:** `kickoff-template.md` body — RESEARCH §2 confirms DESIGN-17 contains NO literal template body, only frontmatter shape + 8-category list + verbatim handoff message + marker convention. Planner authors prose from those locked landmarks; lifts the frontmatter block + handoff + marker verbatim.

---

### Pattern: Inline OPEN-Q resolution (D-57 / D-67)

**Source:** Phase 5 D-57 / Phase 6 D-67 precedent.

**Apply to:** Phase 7 — **vacuously satisfied**. RESEARCH §1 confirms zero STG1/STG2/STG3-prefixed rows exist in `.planning/OPEN-QUESTIONS.md`. Synthesis section (in 07-03 or 07-04) does NOT need to flip any STG-named register row. Synthesis instead handles: (a) glossary spelling fix per R-02 (optional planner choice — recommend bundle), (b) e2e smoke against sample CR, (c) `--all` structure-check, (d) REQUIREMENTS.md trace checkbox flips (10 boxes).

---

## No Analog Found

| File | Role | Data Flow | Reason | Authoring source |
|---|---|---|---|---|
| `kickoff-capture/references/auto-classify-rubric.md` | reference doc (rubric) | read-path | First confidence rubric in the plugin — no analog in v0.3.0 or v2.1 skill catalogue. | Author from CONTEXT.md D-73 (3-5 explicit triggers + escalation table + operational principle) + STG1-04 marker convention. |
| `kickoff-capture/references/capture-paths.md` | reference doc (operational protocol) | read-path | First multi-path capture protocol in plugin. The closest shape match (`execute-tests/references/safety-rules.md`) is a local-supporting-ref by shape only — body content is unrelated (safety enforcement vs capture protocol). | Author from CONTEXT.md D-72 (doc-only paste protocol) + STG1-05 (3 capture paths: meeting notes / Miro / Field Notes) + DESIGN-09 (`processed_at IS NULL` filter + MOD-8 prevention). |

---

## Metadata

**Analog search scope:**
- `dydx-delivery/skills/**/SKILL.md` (all 10 plugin skills) — verified
- `dydx-delivery/skills/**/references/**.md` (template + supporting refs) — verified
- `.planning/milestones/v2.1-phases/05-foundations/scripts/` + `.planning/milestones/v2.1-phases/06-internalise-platform-skills/scripts/` (bash skeletons) — verified
- `.planning/codebase/CONVENTIONS.md` (SKILL.md body structure canon)
- `.planning/DESIGN.md` (DESIGN-17/18/19 literal-content extraction per RESEARCH §2)

**Files scanned for analog selection:** 14 (3 platform SKILL.md + 7 stage SKILL.md + 2 template refs + 1 phase6 bash + 1 CONVENTIONS doc)

**Files Read in full for excerpt extraction:** 5
- `dydx-delivery/skills/discovery-intake/SKILL.md` (149 lines)
- `dydx-delivery/skills/generate-sow/SKILL.md` (110 lines)
- `dydx-delivery/skills/generate-sow/references/sow-template.md` (155 lines)
- `dydx-delivery/skills/platform-pipefy/SKILL.md` (lines 1-60 — pointer pattern)
- `.planning/milestones/v2.1-phases/06-internalise-platform-skills/scripts/phase6-structure-check.sh` (281 lines)

**Files Read partial for excerpt extraction:** 2
- `dydx-delivery/skills/discovery-intake/references/intake-template.md` (lines 1-60 — frontmatter + opening body)
- `.planning/codebase/CONVENTIONS.md` (lines 180-201 — SKILL.md body structure section)

**Risk register (carried from RESEARCH §11):**
- R-01 (HIGH): Verbatim skip-message conflict between DESIGN-18 and STG2-02 — STG2-02 spelling authoritative.
- R-02 (MEDIUM): Glossary spelling drift for `kickoff_branch` enum — `discovery-ready | draft-sow` authoritative (4 sources vs 1 outlier glossary).
- R-03 (LOW): CONTEXT.md references non-existent `.planning/codebase/PATTERNS.md` — use phase6 script + CONVENTIONS.md actual paths.
- R-04 (LOW): Discovery 9-section vs kickoff 8-section dimension mismatch — intentional per STG2-03 body-unchanged contract.
- R-05 (LOW): generate-sow handoff references about-to-retire `generate-functional-spec` — recommend pre-emptive update to Stage 4a/4b in Phase 7.

**Pattern extraction date:** 2026-05-11
