# Technology Stack

**Analysis Date:** 2026-05-09

## Languages

**Primary:**
- Markdown — all skill definitions, references, and templates (`dydx-delivery/skills/**/SKILL.md`, `dydx-delivery/skills/**/references/*.md`)
- JSON — manifest files (`.claude-plugin/marketplace.json`, `dydx-delivery/.claude-plugin/plugin.json`)
- YAML — frontmatter blocks inside `SKILL.md` files (skill metadata: `name`, `description`) and inside generated client artefacts (`client`, `platform`, `integrations`, `version`, `status`, `captured_at`, `generated_at`, `based_on_*`, `build_components`)

**Secondary:**
- None detected. No source code files (`.ts`, `.js`, `.py`, `.go`, `.rs`, `.java`) exist in the repo.

## Runtime

**Environment:**
- Claude Code (plugin host) — plugin distributed for use in both Claude Code and Cowork (per `dydx-delivery/README.md`)
- No language runtime (Node, Python, etc.) used by this repo itself

**Package Manager:**
- None. No `package.json`, `requirements.txt`, `Cargo.toml`, `go.mod`, `pyproject.toml`, `Gemfile`, or lockfile present.
- Distribution mechanism: Claude Code plugin marketplace (`/plugin marketplace add` / `/plugin install`)

## Frameworks

**Core:**
- Claude Code Plugin Framework — plugin defined by:
  - `.claude-plugin/marketplace.json` (marketplace manifest at repo root)
  - `dydx-delivery/.claude-plugin/plugin.json` (plugin manifest)
  - Skills under `dydx-delivery/skills/<skill-name>/SKILL.md` with YAML frontmatter (`name`, `description`)

**Testing:**
- None. No test runner or test files exist. The plugin contains a skill named `execute-tests` that operationally runs *client-supplied* test plans against external sandbox tenants — this is plugin behaviour, not a project-level test framework.

**Build/Dev:**
- None. No build pipeline, bundler, transpiler, or CI config detected.

## Key Dependencies

**Critical:**
- None. No runtime dependencies. The plugin is pure markdown skill content + JSON manifests consumed by the Claude Code skill loader.

**Infrastructure:**
- None bundled. External integrations (Pipefy, Wrike, Ziflow, Workato, Slack) are referenced by skill content as platforms the plugin's generated artefacts target — they are not dependencies of this repo.

## Configuration

**Repo-level config files present:**
- `.claude-plugin/marketplace.json` — marketplace identity (name `dydx-digital`, owner, version `1.2.0`, plugin list)
- `dydx-delivery/.claude-plugin/plugin.json` — plugin identity (name `dydx-delivery`, version `0.3.0`, author, license `Proprietary`, homepage, keywords)
- `README.md` (repo root) — install/publish instructions
- `dydx-delivery/README.md` — pipeline documentation

**Environment:**
- No `.env`, `.env.example`, or environment configuration in this repo.
- Skill content references env-var conventions used at *consumer time* (in client repos): `<PLATFORM>_API_TOKEN`, `<PLATFORM>_TENANT_ID`, `.env.example` in the client's repo (per `dydx-delivery/skills/generate-build-prompt/references/build-prompt-template.md` lines 109–120 and `dydx-delivery/skills/generate-build-prompt/references/when-to-open-claude-code.md` line 88).

**Build:**
- None.

## Platform Requirements

**Development:**
- Git (repository version-controlled; current branch `dydx-delivery-v2`, main branch `main`)
- A markdown-aware editor for skill authoring
- Claude Code installed for testing skill loading

**Production / Distribution:**
- GitHub-hosted private repo (`https://github.com/SonofJay13/dydx-project-workflow`, per `dydx-delivery/.claude-plugin/plugin.json` `homepage`)
- Claude Code plugin marketplace mechanism (`/plugin marketplace add <repo-url>`, `/plugin install dydx-delivery`)

## Repository Layout (file inventory)

```
dydx-project-workflow/
├── .claude-plugin/
│   └── marketplace.json
├── .git/
├── .planning/
│   └── codebase/                    (this directory)
├── README.md
└── dydx-delivery/
    ├── .claude-plugin/
    │   └── plugin.json
    ├── README.md
    └── skills/
        ├── discovery-intake/
        │   ├── SKILL.md
        │   └── references/
        │       └── intake-template.md
        ├── execute-tests/
        │   ├── SKILL.md
        │   └── references/
        │       ├── results-template.md
        │       └── safety-rules.md
        ├── generate-build-prompt/
        │   ├── SKILL.md
        │   └── references/
        │       ├── build-prompt-template.md
        │       └── when-to-open-claude-code.md
        ├── generate-functional-spec/
        │   ├── SKILL.md
        │   └── references/
        │       └── functional-spec-template.md
        ├── generate-sow/
        │   ├── SKILL.md
        │   └── references/
        │       └── sow-template.md
        ├── generate-technical-spec/
        │   ├── SKILL.md
        │   └── references/
        │       └── technical-spec-template.md
        └── generate-test-plan/
            ├── SKILL.md
            └── references/
                └── test-plan-template.md
```

## Manifest Inventory

### `.claude-plugin/marketplace.json`

- `name`: `dydx-digital`
- `owner.name`: `dYdX Digital`
- `owner.email`: `jasonmichaelb@gmail.com`
- `metadata.description`: "Private plugin marketplace for the dYdX Digital team..."
- `metadata.version`: `1.2.0`
- `plugins[0].name`: `dydx-delivery`
- `plugins[0].source`: `./dydx-delivery`
- `plugins[0].version`: `0.3.0`
- `plugins[0].category`: `delivery`
- `plugins[0].tags`: `["sow", "spec", "test-plan", "build-prompt", "claude-code", "automated-testing", "pipefy", "wrike", "solutions-architecture"]`

### `dydx-delivery/.claude-plugin/plugin.json`

- `name`: `dydx-delivery`
- `version`: `0.3.0`
- `description`: "Stage-gated client delivery pipeline for dYdX Digital. Seven skills..."
- `author.name`: `Jason Blignaut`
- `author.email`: `jasonmichaelb@gmail.com`
- `homepage`: `https://github.com/SonofJay13/dydx-project-workflow`
- `license`: `Proprietary`
- `keywords`: `["delivery", "solutions-architecture", "sow", "functional-spec", "technical-spec", "test-plan", "build-prompt", "claude-code", "automated-testing", "pipefy", "wrike", "dydx-digital"]`

## Skills Inventory

Seven skills under `dydx-delivery/skills/`, each with a `SKILL.md` (YAML frontmatter `name` + `description`, then markdown body) and a `references/` subdirectory holding markdown templates.

| Skill | SKILL.md path | References |
|---|---|---|
| `discovery-intake` | `dydx-delivery/skills/discovery-intake/SKILL.md` | `intake-template.md` |
| `generate-sow` | `dydx-delivery/skills/generate-sow/SKILL.md` | `sow-template.md` |
| `generate-functional-spec` | `dydx-delivery/skills/generate-functional-spec/SKILL.md` | `functional-spec-template.md` |
| `generate-technical-spec` | `dydx-delivery/skills/generate-technical-spec/SKILL.md` | `technical-spec-template.md` |
| `generate-test-plan` | `dydx-delivery/skills/generate-test-plan/SKILL.md` | `test-plan-template.md` |
| `generate-build-prompt` | `dydx-delivery/skills/generate-build-prompt/SKILL.md` | `build-prompt-template.md`, `when-to-open-claude-code.md` |
| `execute-tests` | `dydx-delivery/skills/execute-tests/SKILL.md` | `results-template.md`, `safety-rules.md` |

## Versioning

- Marketplace version: `1.2.0` (in `.claude-plugin/marketplace.json`)
- Plugin version: `0.3.0` (in `dydx-delivery/.claude-plugin/plugin.json`, also mirrored in `marketplace.json` `plugins[0].version`)
- Convention documented in repo `README.md` lines 81–84: patch / minor / major semver bumps mapped to behaviour-change scope
- Update mechanism: bump version in *both* `plugin.json` and `marketplace.json`, commit, push (per repo `README.md` lines 53–58)

---

*Stack analysis: 2026-05-09*
