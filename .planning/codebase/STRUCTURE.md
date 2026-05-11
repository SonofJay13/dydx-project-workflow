# Codebase Structure

**Analysis Date:** 2026-05-09

## Directory Layout

```
dydx-project-workflow/                          # repo root (marketplace)
├── .claude-plugin/
│   └── marketplace.json                        # Marketplace manifest: lists plugins, versions, sources
├── .planning/
│   └── codebase/                               # GSD codebase mapping outputs (this analysis)
├── README.md                                   # Marketplace overview, install + publish instructions
└── dydx-delivery/                              # Plugin folder (one folder per plugin)
    ├── .claude-plugin/
    │   └── plugin.json                         # Plugin manifest: name, version, author, keywords
    ├── README.md                               # Plugin overview, pipeline diagram, skill table, file conventions
    └── skills/                                 # All skills for this plugin (siblings)
        ├── discovery-intake/
        │   ├── SKILL.md                        # Stage 00 instructions (148 lines)
        │   └── references/
        │       └── intake-template.md          # Discovery artefact template (157 lines)
        ├── generate-sow/
        │   ├── SKILL.md                        # Stage 01 instructions (110 lines)
        │   └── references/
        │       └── sow-template.md             # SOW template (155 lines)
        ├── generate-functional-spec/
        │   ├── SKILL.md                        # Stage 02 instructions (112 lines)
        │   └── references/
        │       └── functional-spec-template.md # Functional spec template (165 lines)
        ├── generate-technical-spec/
        │   ├── SKILL.md                        # Stage 03 instructions (148 lines)
        │   └── references/
        │       └── technical-spec-template.md  # Technical spec template (213 lines)
        ├── generate-test-plan/
        │   ├── SKILL.md                        # Stage 03b (testing) instructions (136 lines)
        │   └── references/
        │       └── test-plan-template.md       # Test plan template (149 lines)
        ├── generate-build-prompt/
        │   ├── SKILL.md                        # Stage 04 instructions (171 lines)
        │   └── references/
        │       ├── build-prompt-template.md    # Build prompt template (175 lines)
        │       └── when-to-open-claude-code.md # Decision matrix Cowork ↔ Claude Code (89 lines)
        └── execute-tests/
            ├── SKILL.md                        # Terminal stage instructions (145 lines)
            └── references/
                ├── results-template.md         # Test results template (141 lines)
                └── safety-rules.md             # Hard rules enforced at runtime (101 lines)
```

## Directory Purposes

**Repo root (`dydx-project-workflow/`):**
- Purpose: Marketplace container. One folder per plugin plus the marketplace manifest.
- Contains: `.claude-plugin/marketplace.json`, `README.md`, `.planning/`, plugin folders (`dydx-delivery/`).
- Key files: `.claude-plugin/marketplace.json`, `README.md`.

**`.claude-plugin/` (root):**
- Purpose: Holds the marketplace manifest read by Claude clients when teammates run `/plugin marketplace add`.
- Contains: `marketplace.json` only.
- Key files: `.claude-plugin/marketplace.json`.

**`.planning/codebase/`:**
- Purpose: GSD codebase mapping outputs (architecture, structure, conventions, etc.).
- Contains: This document and `ARCHITECTURE.md`.

**`dydx-delivery/`:**
- Purpose: The single plugin currently published from this marketplace.
- Contains: `.claude-plugin/plugin.json`, `README.md`, `skills/`.
- Key files: `dydx-delivery/.claude-plugin/plugin.json`, `dydx-delivery/README.md`.

**`dydx-delivery/.claude-plugin/`:**
- Purpose: Plugin-level manifest folder.
- Contains: `plugin.json` only.
- Key files: `dydx-delivery/.claude-plugin/plugin.json`.

**`dydx-delivery/skills/`:**
- Purpose: Container for all skills in this plugin. Each subfolder is one invokable skill.
- Contains: Seven skill subfolders (`discovery-intake`, `generate-sow`, `generate-functional-spec`, `generate-technical-spec`, `generate-test-plan`, `generate-build-prompt`, `execute-tests`).
- Key files: each skill's `SKILL.md`.

**`dydx-delivery/skills/<skill-name>/`:**
- Purpose: A single skill: instructions plus its supporting reference material.
- Contains: `SKILL.md` (always present, mandatory) + `references/` subfolder.
- Key files: `SKILL.md`.

**`dydx-delivery/skills/<skill-name>/references/`:**
- Purpose: Templates and supporting documents the skill loads or instructs Claude to load.
- Contains: At least one `*-template.md` file. Some skills carry additional reference docs (`safety-rules.md`, `when-to-open-claude-code.md`).
- Key files: the template file named in the skill's body.

## Key File Locations

**Marketplace and plugin manifests:**
- `.claude-plugin/marketplace.json` — top-level marketplace manifest (`name: dydx-digital`, `metadata.version: 1.2.0`, `plugins[]` array).
- `dydx-delivery/.claude-plugin/plugin.json` — plugin manifest (`name: dydx-delivery`, `version: 0.3.0`).

**Documentation:**
- `README.md` — marketplace install, publish, version conventions.
- `dydx-delivery/README.md` — plugin pipeline diagram, skill table, file location convention, versioning (Option B), platform handling, safety rules summary.

**Skill instructions (one per pipeline stage):**
- `dydx-delivery/skills/discovery-intake/SKILL.md`
- `dydx-delivery/skills/generate-sow/SKILL.md`
- `dydx-delivery/skills/generate-functional-spec/SKILL.md`
- `dydx-delivery/skills/generate-technical-spec/SKILL.md`
- `dydx-delivery/skills/generate-test-plan/SKILL.md`
- `dydx-delivery/skills/generate-build-prompt/SKILL.md`
- `dydx-delivery/skills/execute-tests/SKILL.md`

**Templates (under each skill's `references/`):**
- `dydx-delivery/skills/discovery-intake/references/intake-template.md`
- `dydx-delivery/skills/generate-sow/references/sow-template.md`
- `dydx-delivery/skills/generate-functional-spec/references/functional-spec-template.md`
- `dydx-delivery/skills/generate-technical-spec/references/technical-spec-template.md`
- `dydx-delivery/skills/generate-test-plan/references/test-plan-template.md`
- `dydx-delivery/skills/generate-build-prompt/references/build-prompt-template.md`
- `dydx-delivery/skills/execute-tests/references/results-template.md`

**Non-template reference docs:**
- `dydx-delivery/skills/generate-build-prompt/references/when-to-open-claude-code.md` — decision matrix for switching from Cowork to Claude Code.
- `dydx-delivery/skills/execute-tests/references/safety-rules.md` — hard runtime rules (sandbox-only, no deletes, no destructive actions, audit trail, rate limiting, stop-on-infra-failure).

## Naming Conventions

**Plugin folder:**
- Lowercase kebab-case at repo root (`dydx-delivery/`).

**Skill folders:**
- Lowercase kebab-case under `skills/` (`discovery-intake`, `generate-sow`, `generate-functional-spec`, `generate-technical-spec`, `generate-test-plan`, `generate-build-prompt`, `execute-tests`).
- Verb-led for action skills (`generate-*`, `execute-*`); noun-led for capture skills (`discovery-intake`).

**Skill instruction file:**
- Always `SKILL.md` (uppercase, exact). One per skill folder.

**Template files:**
- Lowercase kebab-case ending in `-template.md` (`intake-template.md`, `sow-template.md`, `functional-spec-template.md`, `technical-spec-template.md`, `test-plan-template.md`, `build-prompt-template.md`, `results-template.md`).
- Located in the skill's `references/` subfolder.

**Other reference files:**
- Lowercase kebab-case `.md` (`safety-rules.md`, `when-to-open-claude-code.md`).
- Located in the skill's `references/` subfolder.

**Manifest files:**
- `marketplace.json` (root marketplace manifest).
- `plugin.json` (plugin manifest).

**Artefact filenames produced by skills (written outside this repo, into client folders):**
- Stage-prefixed in `<Client>/build-specs/<platform>/`:
  - `00_discovery_v{N}.md`
  - `01_sow_v{N}.md`
  - `02_functional-spec_v{N}.md`
  - `03_technical-spec_v{N}.md`
  - `04_build-prompt_v{N}.md`
  - `04_build-prompt_v{N}_report.md` (sibling, written by Claude Code after build)
- Optional siblings: `04a_build-prompt-config.md`, `04b_build-prompt-code.md` (when build splits into platform config vs custom code).
- Test artefacts in `<Client>/testing/<feature>/`:
  - `test-plan_v{N}.md`
  - `results-YYYY-MM-DD_v{N}.md`
- Versioning suffix: `_v{N}` integer, starting at `_v1`. Increments per Option B (`README.md` lines 79-83 and `dydx-delivery/README.md` lines 80-85).

**Frontmatter field names (artefact metadata):**
- `client`, `platform`, `integrations`, `version`, `status`, `captured_by`, `captured_at`, `generated_at`.
- `based_on_discovery`, `based_on_sow`, `based_on_functional_spec`, `based_on_technical_spec`, `based_on_test_plan` — chain of custody references, value is the exact filename.
- `sandbox: { pipe_id, space_id, tenant }` — block in `test-plan_v*.md`.
- `feature` — in test plan frontmatter only.
- `build_components: [platform_config, custom_code]` — in build prompt frontmatter only.

**Status values:** `draft`, `client_review`, `approved` (referenced across multiple SKILL.md files).

**Identifier patterns inside artefacts:**
- Business rules: `BR-1`, `BR-2`, … (functional spec).
- Edge cases: `EC-1`, `EC-2`, … (functional spec).
- Acceptance criteria: `AC-1`, `AC-2`, … (functional spec).
- Test cases: `TC-001`, `TC-002`, … (test plan; stable, never renumbered).

## Where Templates Live vs SKILL.md Instructions

**`SKILL.md` (one per skill folder):**
- Contents: YAML frontmatter (`name`, `description` with trigger phrases) + body.
- Body sections (consistent across skills): `# <skill-name>`, `## Inputs`, `## Output`, `## How to run` (numbered Steps), `## What this skill does not do`, `## Quality bar`. Some skills add `## Start-at-any-point handling`, `## Platform-specific behaviour`, `## Hard rules`, `## Failure modes to expect`, `## Iterating between Cowork and Claude Code`.
- Role: The instruction set Claude executes when the skill is invoked. Names the template path it will fill (`Use the template at references/<file>.md`). Names the upstream artefact and the output artefact path.

**`references/<name>-template.md` (one or more per skill folder):**
- Contents: The literal markdown template the skill fills in. Includes the YAML frontmatter block, section headers, placeholder text, and structural conventions.
- Role: The structural contract for the artefact the skill produces. Loaded by name from the `SKILL.md` body (`Use the template at references/<name>-template.md`).

**`references/<other>.md` (supporting documents):**
- `dydx-delivery/skills/execute-tests/references/safety-rules.md` — hard runtime rules referenced by `SKILL.md` (`Read these in references/safety-rules.md`).
- `dydx-delivery/skills/generate-build-prompt/references/when-to-open-claude-code.md` — decision matrix for tool switching, referenced from both the plugin README and the build prompt skill's handoff message.

## Where to Add New Code

**New skill in the existing plugin:**
- Folder: `dydx-delivery/skills/<new-skill-name>/`
- Required files: `SKILL.md` with `name:` and `description:` frontmatter; `references/<template>.md` if the skill writes an artefact.
- Plugin version bump: `dydx-delivery/.claude-plugin/plugin.json` `version` field.
- Marketplace version bump: `.claude-plugin/marketplace.json` matching plugin entry.

**New template or reference for an existing skill:**
- Folder: `dydx-delivery/skills/<existing-skill>/references/`
- File: lowercase kebab-case `.md`.
- Reference from: the skill's `SKILL.md` body.

**New plugin in this marketplace:**
- Folder: repo root, sibling of `dydx-delivery/`. Name: lowercase kebab-case (`<plugin-name>/`).
- Required files: `<plugin-name>/.claude-plugin/plugin.json`, `<plugin-name>/README.md`, `<plugin-name>/skills/`.
- Marketplace registration: append entry to `.claude-plugin/marketplace.json` `plugins[]` with `name`, `source: ./<plugin-name>`, `description`, `version`, `category`, `tags`.

**Updating an existing plugin version:**
- Bump `version` in `<plugin-name>/.claude-plugin/plugin.json` (semver per `README.md` lines 79-83).
- Bump matching `version` in `.claude-plugin/marketplace.json`.

## Special Directories

**`.claude-plugin/` (at repo root and at plugin root):**
- Purpose: Manifests read by Claude marketplace / plugin tooling.
- Generated: No — hand-edited.
- Committed: Yes.

**`.planning/`:**
- Purpose: GSD planning outputs (codebase maps, plans).
- Generated: Yes — written by GSD commands.
- Committed: present in working tree; subfolder `codebase/` exists.

**`.git/`:**
- Purpose: Git internals.
- Generated: Yes.
- Committed: No (the directory itself is git).

**`references/` (one per skill):**
- Purpose: Templates and supporting docs loaded by name from the parent `SKILL.md`.
- Generated: No — hand-authored.
- Committed: Yes.

---

*Structure analysis: 2026-05-09*
