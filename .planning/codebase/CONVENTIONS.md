# Coding Conventions

**Analysis Date:** 2026-05-09

> This repo is a Claude Code plugin marketplace. The "code" is markdown — skill definitions and reference templates. Conventions below describe artefact format, naming, frontmatter, structural shape, and tone observed across `dydx-delivery/skills/*` and their `references/` files.

---

## Repo-level structure

```
dydx-project-workflow/
├── README.md                              # marketplace-level README
└── dydx-delivery/                         # plugin folder
    ├── README.md                          # plugin-level README
    ├── .claude-plugin/
    │   └── plugin.json                    # plugin manifest (name, version, description)
    └── skills/
        └── <skill-name>/
            ├── SKILL.md                   # skill entry file (YAML frontmatter + body)
            └── references/                # supporting templates / rules
                └── *.md
```

One skill per directory under `skills/`. Each skill has its own `references/` subfolder; no shared references directory across skills.

---

## File and directory naming

**Skill directories:** kebab-case verb-noun, prefixed with action verb.
- `discovery-intake`
- `generate-sow`
- `generate-functional-spec`
- `generate-technical-spec`
- `generate-test-plan`
- `generate-build-prompt`
- `execute-tests`

**Skill entry file:** `SKILL.md` — uppercase, fixed name, one per skill directory.

**Reference files:** kebab-case descriptive nouns under `references/`. Examples observed:
- `intake-template.md`
- `sow-template.md`
- `functional-spec-template.md`
- `technical-spec-template.md`
- `test-plan-template.md`
- `build-prompt-template.md`
- `results-template.md`
- `safety-rules.md`
- `when-to-open-claude-code.md`

**Convention:** templates use the suffix `-template.md`; rule/guide docs use a descriptive name with no suffix.

---

## Versioning conventions

### Plugin/marketplace versioning

Documented in repo-root `README.md` under "Versioning convention":

- **Patch** (`0.1.0` → `0.1.1`): bug fixes, doc updates, no behaviour change
- **Minor** (`0.1.0` → `0.2.0`): new skill, new capability, backwards-compatible
- **Major** (`0.1.0` → `1.0.0`): breaking change to skill names, output paths, or pipeline contract

`version` field appears in:
- `dydx-delivery/.claude-plugin/plugin.json` (currently `0.3.0`)
- `.claude-plugin/marketplace.json` (matched by publish process)

### Artefact versioning ("Option B")

Used for every artefact written by skills. Documented in plugin `README.md`:

- Every skill writes `_v1.md` on first run.
- Reviewer either edits in place, or saves their reviewed version as `_v{N+1}.md`.
- Next skill reads the **highest version** it can find for its upstream artefact.
- Optional sibling `_review.md` for major iteration notes (used by `/refine-<skill>` if added later).

### Artefact filename patterns

**Build-spec stages** (numeric prefix indicates pipeline order):

```
00_discovery_v{N}.md
01_sow_v{N}.md
02_functional-spec_v{N}.md
03_technical-spec_v{N}.md
04_build-prompt_v{N}.md
04_build-prompt_v{N}_report.md       # written by Claude Code post-build
04_build-prompt_v{N}_deviations.md   # optional sibling
04a_build-prompt-config.md           # optional split (config vs code)
04b_build-prompt-code.md             # optional split
```

**Testing stages** (no numeric prefix; date stamp on results):

```
test-plan_v{N}.md
results-YYYY-MM-DD_v{N}.md
results-YYYY-MM-DD_v{N}_audit.log    # optional sibling for very large audit log
```

### Run-identifier convention

Multiple test runs on the same day increment `_v{N}` and add a run identifier in the header.

---

## Output paths

Paths are written from the perspective of a per-client workspace, not the plugin repo:

```
<Client>/
├── build-specs/
│   └── <platform>/                       # pipefy | wrike | other
│       ├── 00_discovery_v1.md
│       ├── 01_sow_v1.md
│       ├── 02_functional-spec_v1.md
│       ├── 03_technical-spec_v1.md
│       └── 04_build-prompt_v1.md
└── testing/
    └── <feature>/
        ├── test-plan_v1.md
        └── results-2026-05-05_v1.md
```

`<feature>` is kebab-case, asked for at test-plan generation time when not obvious.

---

## YAML frontmatter conventions

### SKILL.md frontmatter

Two fields, both required:

```yaml
---
name: <skill-name-kebab-case>
description: <one-paragraph trigger description; when to invoke; what it reads; what it writes>
---
```

The `description` field reads as a long single-paragraph trigger, listing user-utterance phrases in quotes (e.g. `"generate SOW"`, `"draft scope of work"`, `"write the SOW"`) followed by what the skill reads and what it writes.

### Artefact frontmatter

Every artefact template carries a YAML frontmatter block. Field set varies by stage but the shared core is:

```yaml
---
client: <CLIENT_NAME>
platform: <pipefy | wrike | other>
integrations: []
version: <integer>
status: <draft | client_review | approved>
generated_at: <YYYY-MM-DD>
---
```

Stage-specific fields:

| Stage | Adds |
|---|---|
| Discovery | `captured_by`, `captured_at` (no `based_on_*`) |
| SOW | `based_on_discovery: 00_discovery_v<N>.md` |
| Functional spec | `based_on_sow: 01_sow_v<N>.md` |
| Technical spec | `based_on_functional_spec: 02_functional-spec_v<N>.md` |
| Build prompt | `based_on_technical_spec`, `based_on_test_plan`, `build_components: [platform_config, custom_code]` |
| Test plan | `feature`, `based_on_technical_spec`, `sandbox: { pipe_id, space_id, tenant }` |
| Results | `feature`, `run_started_at`, `run_finished_at`, `runner: dydx-delivery/execute-tests v<X>`, `based_on_test_plan`, `sandbox: { ... }` |

**Status values observed:** `draft`, `client_review`, `approved`.

**Date format in frontmatter:** `<YYYY-MM-DD>` for `generated_at` / `captured_at`; ISO datetime for `run_started_at` / `run_finished_at`.

**`integrations:`** is a YAML list. Examples in templates: `[ziflow, workato, frontify, slack]`.

**`platform:`** is the routing key for downstream skills. Values observed: `pipefy`, `wrike`, `other`.

---

## SKILL.md body structure

Every SKILL.md follows the same shape after the frontmatter:

1. `# <skill-name>` — H1 matching the directory name.
2. **One-paragraph purpose statement** — what the skill does and where it sits in the pipeline (often references "Stage N of the dydx-delivery pipeline").
3. `## Inputs` — bulleted list of required and optional inputs (always specifies highest-version filename pattern of upstream artefact).
4. `## Output` — single path, e.g. `<Client>/build-specs/<platform>/01_sow_vN.md`.
5. `## How to run` — numbered step sections (`### Step 1 — ...`, `### Step 2 — ...`).
   - Step 1 is always **Locate upstream artefact** with start-at-any-point triage block.
   - Middle steps draft using the template at `references/<name>-template.md`.
   - A late step is **Senior-level challenge** — explicit pressure-test bullets.
   - Final step is **Write and hand off** with frontmatter block + exact handoff message.
6. `## What this skill does not do` — explicit non-responsibilities (negative scope).
7. `## Quality bar` — bulleted list of what "good" looks like for the artefact.

Some skills add extra sections after Quality bar (e.g. `## Failure modes to expect`, `## Hard rules — enforced regardless of test plan content`, `## Iterating between Cowork and Claude Code`, `## Start-at-any-point handling`, `## Platform-specific behaviour`).

---

## Start-at-any-point triage convention

Any skill whose upstream artefact is missing emits a fixed three-option prompt:

```
> I don't see a <artefact> for `<Client>` at `<expected path>`. How do you want to proceed?
>
> **(a) Paste an existing <artefact>** — I'll save it as `<expected filename>` and continue
> **(b) Walk through <relevant scope> inline** — I'll capture the essentials and stub the file
> **(c) Cancel**
```

Used in: `generate-sow`, `generate-functional-spec`, `generate-technical-spec`, `generate-test-plan`, `generate-build-prompt`, `execute-tests`.

`discovery-intake` is the entry skill so it does not run triage; instead it has a `## Start-at-any-point handling` section noting it accepts shortcut inputs ("I already have a brief", "Just structure these notes").

---

## Existing-artefact revision convention

When an artefact already exists, every skill prompts:

```
> Found `<filename>_v{N}.md`. Do you want to (a) revise it as `_v{N+1}`, (b) extend in place, or (c) start fresh?
```

---

## Handoff message convention

Every skill ends its run with an "exact handoff message" — a markdown blockquote containing:

1. One-line confirmation: `> <Artefact> drafted at \`<path>\`.`
2. **Review steps:** numbered list (typically 4-6 items), often ending with "save as `_v{N+1}.md`" and "Update `status:` to `approved` when ready".
3. Pointer to the next skill in bold backticks: `**`generate-functional-spec`**`.
4. Sometimes a "Next stage reads:" line noting which file the next skill picks up.

---

## Reference table conventions

Tabular content in templates uses these column patterns:

**Field-level requirements:**
| Field | Type | Mandatory | Validation | Default | Source |

**Business rules:**
| # | Rule | Triggered by |  (with IDs `BR-1`, `BR-2`, …)

**Edge cases:**
| # | Scenario | Expected behaviour |  (with IDs `EC-1`, `EC-2`, …)

**Acceptance criteria:**
| # | Criterion | Maps to | Verifies |  (with IDs `AC-1`, `AC-2`, …)

**Test cases:**
| TC-ID | Title | Maps to | Setup | Action | Expected | Assertion type | Sandbox-safe? | Priority | Notes |  (with IDs `TC-001`, `TC-002`, …)

**Risks/dependencies:**
| # | Item | Type | Owner | Mitigation |  (with IDs `R1`, `D1`, …)

**Open questions:**
| # | Question |  (with IDs `OQ-1`, `OQ-2`, …) — or rendered as `- [ ]` checklist.

---

## Identifier conventions across artefacts

| Prefix | Meaning | First introduced in |
|---|---|---|
| `D1`, `D2` | Deliverable | SOW |
| `BR-1`, `BR-2` | Business rule | Functional spec |
| `EC-1`, `EC-2` | Edge case | Functional spec |
| `AC-1`, `AC-2` | Acceptance criterion | Functional spec |
| `R1` | Risk | SOW |
| `D1` (in risks/deps table) | Dependency | SOW |
| `OQ-1`, `OQ-2` | Open technical question | Technical spec |
| `TC-001`, `TC-002` | Test case | Test plan |

IDs are **stable** — the test plan template explicitly states "Stable, never renumbered." Cross-references between artefacts use these IDs (e.g. test case "Maps to: AC-1, BR-2").

---

## Assertion-type vocabulary (test plan)

Closed set used in the test plan `Assertion type` column:

- `state_check`
- `field_check`
- `integration_called`
- `error_raised`
- `audit_log`

## Test status vocabulary (results)

Closed set used in results files:

- `PASS`
- `FAIL`
- `REFUSED:<reason>`
- `SETUP_FAILED`
- `SKIPPED`
- `ERROR:<class>`

Refusal reasons: `delete_blocked`, `out_of_sandbox`, `destructive_integration`.

## Verdict vocabulary (results)

Closed set in results summary:

- `GREEN — all critical pass`
- `YELLOW — non-critical failures only`
- `RED — critical failures`

## Priority vocabulary (test plan)

- `Critical`
- `Important`
- `Nice-to-have`

## Sandbox-safe vocabulary (test plan)

- `Yes`
- `No`

---

## Architecture-overview convention (technical spec)

Architecture diagrams use mermaid `flowchart LR` or ASCII boxes. Followed by a one-paragraph narrative describing trigger points and data flow.

State models use ASCII arrow diagrams:

```
Draft → Submitted → In Review → (Approved | Rejected) → Done
```

Pipeline-shape diagrams use ASCII box art with three swimlanes (Cowork / Claude Code / Cowork) — see `dydx-delivery/README.md` and `references/when-to-open-claude-code.md`.

---

## Citation / cross-reference conventions

- File paths in backticks: `` `<Client>/build-specs/<platform>/01_sow_v1.md` ``
- Skill names in backticks: `` `generate-sow` ``
- Cross-stage references use the exact filename pattern with version placeholder: `` `02_functional-spec_v{N}.md` ``
- "Maps to" columns reference IDs by prefix-and-number (e.g. `AC-1, BR-2`).
- Inline platform-construct names use the platform's vocabulary verbatim (e.g. Pipefy "phase" not "stage"; Wrike "blueprint" not "template"). This rule is stated explicitly in `generate-technical-spec` and `generate-build-prompt`.

---

## Tone and writing style

Observed across all SKILL.md and reference files:

- **Sentence-form, short paragraphs.** No bullet-heavy summaries; prose explanations followed by tables for structured content.
- **Imperative voice for instructions:** "Read the frontmatter", "Write to `<path>`", "Refuse the call".
- **Direct framing.** "Cowork is the strategy seat. Claude Code is the build seat." Plugin README opens with a one-sentence positioning statement.
- **Explicit non-responsibilities.** Every SKILL.md has a `## What this skill does not do` section.
- **"Senior-level challenge" sections** — bullet-list pressure-tests phrased as questions ("Is anything in scope actually three things in a trench coat? Split it.").
- **Quality bar sections** — bullet list of observable properties of a "good" artefact.
- **Hard rules called out as `> blockquotes`** with bold prefixes (e.g. `**Sandbox only**`, `**No deletions**`).
- **Placeholders use angle brackets:** `<CLIENT_NAME>`, `<feature-slug>`, `<id>`, `<YYYY-MM-DD>`.
- **Unknowns are flagged inline:** `**Unknown — needs client input**` (discovery), `**TBC**` (commercial framing in SOW).
- **Pipeline-stage breadcrumb at top of templates:** `> Stage N of the dydx-delivery pipeline.`

---

## Section numbering

Reference templates use H2 numbered sections (`## 1. Business outcome`, `## 2. Users and ownership`, …). SKILL.md instruction steps use the `### Step N — <Title>` pattern.

---

## Output formatting in skill instructions

When a SKILL.md tells the model what to do at completion, it uses these recurring blocks:

- **A YAML code-fenced frontmatter block** showing the exact frontmatter to write.
- **A blockquote for the user-facing handoff message** (verbatim text the skill emits).
- **Numbered review-steps lists** inside the handoff quote.
- **Backticked next-skill-name** at the end of the handoff (e.g. `**`generate-sow`**`).

---

## Plugin manifest conventions

`dydx-delivery/.claude-plugin/plugin.json`:

```json
{
  "name": "<plugin-name>",
  "version": "<semver>",
  "description": "<one-paragraph description>",
  "author": { "name": "...", "email": "..." },
  "homepage": "<repo url>",
  "license": "Proprietary",
  "keywords": [ "..." ]
}
```

Marketplace-level manifest lives at `.claude-plugin/marketplace.json` (referenced in repo README; not present at time of this analysis).

---

*Convention analysis: 2026-05-09*
