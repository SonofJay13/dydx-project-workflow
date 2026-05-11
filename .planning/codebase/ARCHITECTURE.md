<!-- refreshed: 2026-05-09 -->
# Architecture

**Analysis Date:** 2026-05-09

## System Overview

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                          Marketplace (repository root)                       │
│                       `.claude-plugin/marketplace.json`                      │
│                  Manifest declaring plugins available to teammates           │
└──────────────────────────────────┬──────────────────────────────────────────┘
                                   │ references via `source: ./dydx-delivery`
                                   ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                              Plugin: dydx-delivery                           │
│                       `dydx-delivery/.claude-plugin/plugin.json`             │
│                          Plugin manifest (name, version)                     │
└──────────────────────────────────┬──────────────────────────────────────────┘
                                   │ contains
                                   ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                       Skills directory: `dydx-delivery/skills/`              │
│       Seven sibling skill folders. Each: `SKILL.md` + `references/*.md`      │
└─────────────────────────────────────────────────────────────────────────────┘

Pipeline (sequential, human-gated between every stage):

discovery-intake ──▶ generate-sow ──▶ generate-functional-spec
       │                                       │
       │                                       ▼
       │                              generate-technical-spec
       │                                       │
       │                                       ▼
       │                              generate-test-plan
       │                                       │
       │                                       ▼
       │                              generate-build-prompt ──▶ (paste into Claude Code, build runs)
       │                                                                        │
       │                                                                        ▼
       └─────────────────────────────────────────────────────────────▶ execute-tests
                                                                        (Cowork, sandbox tenant)
```

## Component Responsibilities

| Component | Responsibility | File |
|-----------|----------------|------|
| Marketplace manifest | Declares available plugins, versions, sources | `.claude-plugin/marketplace.json` |
| Plugin manifest | Declares plugin name, version, author, keywords | `dydx-delivery/.claude-plugin/plugin.json` |
| Plugin README | Pipeline diagram, skill table, file location convention, versioning rules | `dydx-delivery/README.md` |
| Repo README | Marketplace install commands, publishing flow, repo layout | `README.md` |
| `discovery-intake` skill | Captures business outcome, users, systems, triggers, data, rules, integrations, exceptions; sets `platform:` frontmatter | `dydx-delivery/skills/discovery-intake/SKILL.md` |
| `generate-sow` skill | Produces scope, deliverables, exclusions, assumptions, risks, dependencies, commercial framing from approved discovery | `dydx-delivery/skills/generate-sow/SKILL.md` |
| `generate-functional-spec` skill | Produces user journeys, business rules, field-level requirements, edge cases, acceptance criteria; platform-agnostic | `dydx-delivery/skills/generate-functional-spec/SKILL.md` |
| `generate-technical-spec` skill | Loads platform skill by `platform:` frontmatter; produces pipes/blueprints, automation logic, field mappings, integration contracts, error handling | `dydx-delivery/skills/generate-technical-spec/SKILL.md` |
| `generate-test-plan` skill | Derives test cases from acceptance criteria, edge cases, business rules; writes structured markdown table | `dydx-delivery/skills/generate-test-plan/SKILL.md` |
| `generate-build-prompt` skill | Produces a Claude-Code-ready build prompt referencing upstream artefacts by exact filename + version | `dydx-delivery/skills/generate-build-prompt/SKILL.md` |
| `execute-tests` skill | Runs the test plan against the sandbox tenant via platform API; enforces safety rules; writes dated results file | `dydx-delivery/skills/execute-tests/SKILL.md` |

## Pattern Overview

**Overall:** Three-tier hierarchy (marketplace → plugin → skills) plus a sequential, stage-gated artefact pipeline.

**Key Characteristics:**

- Marketplace is a single `marketplace.json` manifest at repo root listing plugin folders by relative path.
- Plugin is a single folder containing `.claude-plugin/plugin.json` + `skills/` + `README.md`.
- Each skill is a self-contained folder: one `SKILL.md` (instructions for Claude) + a `references/` subfolder (templates and supporting docs).
- Pipeline stages are sequential and numbered (`00_` through `04_`); each stage reads the highest-version artefact from the prior stage and writes a versioned artefact for the next.
- No skill auto-runs the next skill. The human is the gate between every stage.
- The `platform:` frontmatter field set by `discovery-intake` is read by downstream skills to dynamically load a matching platform skill (`platform-pipefy`, `platform-wrike`).
- Cowork is the strategy seat (discovery, specs, test runs); Claude Code is the build seat (executes the build prompt).

## Layers

**Marketplace layer:**
- Purpose: Distribute plugins to teammates via `/plugin marketplace add` and `/plugin install`.
- Location: `.claude-plugin/marketplace.json`
- Contains: `name`, `owner`, `metadata.version`, `plugins[]` array referencing plugin folders by `source`.
- Depends on: nothing.
- Used by: Cowork / Claude Code clients that subscribe to the marketplace URL.

**Plugin layer:**
- Purpose: Group of skills published as a single versioned unit.
- Location: `dydx-delivery/`
- Contains: `.claude-plugin/plugin.json` manifest, `skills/` directory, `README.md`.
- Depends on: nothing internal; the manifest is referenced by the marketplace.
- Used by: marketplace consumers running `/plugin install dydx-delivery`.

**Skill layer:**
- Purpose: Single capability invokable by Claude (e.g. "generate SOW").
- Location: `dydx-delivery/skills/<skill-name>/`
- Contains: `SKILL.md` with YAML frontmatter (`name`, `description`) + body of instructions; `references/` folder with templates and supporting docs.
- Depends on: artefacts produced by the prior pipeline stage (read from the client's folder, not from the plugin).
- Used by: invoked by the user via the trigger phrases in each skill's `description` field.

**Artefact layer (external to plugin, in client folders):**
- Purpose: Versioned outputs of each pipeline stage, consumed by the next stage.
- Location: `<Client>/build-specs/<platform>/` and `<Client>/testing/<feature>/` (outside this repo).
- Contains: `00_discovery_vN.md` … `04_build-prompt_vN.md`, plus `04_build-prompt_vN_report.md`, `test-plan_vN.md`, `results-YYYY-MM-DD_vN.md`.
- Depends on: prior-stage artefact in the same folder.
- Used by: next pipeline skill.

## Data Flow

### Primary Pipeline Path

1. **Discovery** — user invokes `discovery-intake` (`dydx-delivery/skills/discovery-intake/SKILL.md`). Skill confirms `<Client>` and `<platform>`, walks eight discovery dimensions, drafts using `references/intake-template.md`, writes `<Client>/build-specs/<platform>/00_discovery_vN.md` with frontmatter (`client`, `platform`, `integrations`, `version`, `status`, `captured_by`, `captured_at`).
2. **SOW** — user invokes `generate-sow` (`dydx-delivery/skills/generate-sow/SKILL.md`). Skill reads highest-version `00_discovery_v*.md`, drafts using `references/sow-template.md`, writes `<Client>/build-specs/<platform>/01_sow_vN.md` with frontmatter (`based_on_discovery: 00_discovery_v{N}.md`).
3. **Functional spec** — user invokes `generate-functional-spec` (`dydx-delivery/skills/generate-functional-spec/SKILL.md`). Skill reads highest `01_sow_v*.md` (and `00_discovery_v*.md` for context), drafts using `references/functional-spec-template.md`, writes `02_functional-spec_vN.md` with frontmatter (`based_on_sow: 01_sow_v{N}.md`). Platform-agnostic; produces numbered business rules (BR-X), edge cases (EC-Y), acceptance criteria (AC-Z).
4. **Technical spec** — user invokes `generate-technical-spec` (`dydx-delivery/skills/generate-technical-spec/SKILL.md`). Skill reads highest `02_functional-spec_v*.md`, reads its `platform:` frontmatter, loads matching platform skill (`platform-pipefy`, `platform-wrike`), drafts using `references/technical-spec-template.md`, writes `03_technical-spec_vN.md` with frontmatter (`based_on_functional_spec: 02_functional-spec_v{N}.md`). Maps every BR/EC/AC to platform constructs.
5. **Test plan** — user invokes `generate-test-plan` (`dydx-delivery/skills/generate-test-plan/SKILL.md`). Skill reads highest `03_technical-spec_v*.md` and related `02_functional-spec_v*.md` for AC reference, asks for `<feature>` name and sandbox tenant identifiers, drafts using `references/test-plan-template.md`, writes `<Client>/testing/<feature>/test-plan_vN.md` with frontmatter (`based_on_technical_spec`, `sandbox: { pipe_id, space_id, tenant }`). Each row: TC-ID, Title, Maps-to (AC/EC/BR refs), Setup, Action, Expected, Assertion type, Sandbox-safe?, Priority.
6. **Build prompt** — user invokes `generate-build-prompt` (`dydx-delivery/skills/generate-build-prompt/SKILL.md`). Skill reads highest `03_technical-spec_v*.md` (and `test-plan_v*.md` if present), loads platform skill, drafts using `references/build-prompt-template.md`, writes `04_build-prompt_vN.md` with frontmatter (`based_on_technical_spec`, `based_on_test_plan`, `build_components: [platform_config, custom_code]`). Eight standard sections: Context, Inputs to read first, Build scope, Build instructions, Constraints, Tools and access, Self-test loop, Done criteria + handoff.
7. **Build execution** — user pastes `04_build-prompt_vN.md` contents into a fresh Claude Code session. Claude Code executes the build, runs the smoke subset of the test plan after each major build item, writes a sibling report at `<Client>/build-specs/<platform>/04_build-prompt_vN_report.md`.
8. **Test execution** — user invokes `execute-tests` (`dydx-delivery/skills/execute-tests/SKILL.md`) in Cowork. Skill reads highest `test-plan_v*.md`, verifies `status: approved` and sandbox identifiers, loads platform skill, runs pre-flight checks, requests explicit "go", executes each row applying safety rules from `references/safety-rules.md`, writes `<Client>/testing/<feature>/results-YYYY-MM-DD_vN.md` using `references/results-template.md`.

### Start-at-any-point Triage

Every skill from `generate-sow` onward implements the same triage block when its expected upstream artefact is missing: offers (a) paste an existing artefact and save as `_v1`, (b) walk through inline and stub the upstream artefact, or (c) cancel.

### Iteration Path

After a skill writes `_vN.md`, the human reviewer either (1) edits in place, or (2) saves the reviewed version as `_v{N+1}.md`. The next skill always reads the highest version it can find.

**Frontmatter `status:`** progresses `draft` → `client_review` → `approved` (and is gated by the next skill where required, e.g. `execute-tests` requires `status: approved` on the test plan).

## Key Abstractions

**Pipeline stage:**
- Purpose: A single delivery step that reads one artefact and produces another.
- Examples: `dydx-delivery/skills/generate-sow/SKILL.md`, `dydx-delivery/skills/generate-functional-spec/SKILL.md`.
- Pattern: Read upstream → triage if missing → check existing output → draft using `references/<template>.md` → senior-level challenge → write with frontmatter → emit handoff message naming the next skill.

**Versioned artefact:**
- Purpose: Output of a stage, immutable once written; new versions written as siblings with incremented suffix.
- Examples: `00_discovery_v1.md`, `00_discovery_v2.md`, `01_sow_v1.md`.
- Pattern: Numeric stage prefix (`00_` … `04_`) + slug + `_vN` + `.md`. Test artefacts use `test-plan_vN.md` and `results-YYYY-MM-DD_vN.md` (no numeric stage prefix).

**Platform skill (referenced, not contained):**
- Purpose: External skill loaded by name (`platform-pipefy`, `platform-wrike`) providing platform vocabulary, API contracts, tier requirements.
- Pattern: Selected via the `platform:` frontmatter field on the upstream artefact.

**Frontmatter contract:**
- Purpose: Structured metadata block at the top of every artefact, carrying `client`, `platform`, `integrations`, `version`, `status`, and `based_on_*` references back to the previous stage.
- Pattern: YAML between `---` fences, mandatory in every artefact written by every skill.

## Entry Points

**Marketplace install:**
- Location: `.claude-plugin/marketplace.json`
- Triggers: `/plugin marketplace add https://github.com/SonofJay13/dydx-project-workflow` followed by `/plugin install dydx-delivery`.
- Responsibilities: Surfaces plugin to the client, points client at `./dydx-delivery` source folder.

**Skill invocation:**
- Location: `dydx-delivery/skills/<skill-name>/SKILL.md` (the `description:` frontmatter field lists trigger phrases).
- Triggers: User says one of the documented trigger phrases (e.g. "generate SOW", "run discovery").
- Responsibilities: Skill body defines the steps Claude executes.

**Build prompt paste-in:**
- Location: `<Client>/build-specs/<platform>/04_build-prompt_vN.md` (consumed in Claude Code, not produced by the plugin at runtime).
- Triggers: User pastes prompt body into a fresh Claude Code session.
- Responsibilities: Drives the build phase outside the plugin's runtime.

## Architectural Constraints

- **Sequential ordering:** Pipeline stages run in fixed order. Each stage hard-requires the prior stage's artefact (or a triage stub).
- **Highest-version read:** Every skill reads the highest-numbered `_vN.md` it finds in the target folder.
- **Frontmatter as contract:** `platform:` and `integrations:` flow from `discovery-intake` through every downstream stage; `based_on_*` fields cite the source artefact by exact filename.
- **Human gate between stages:** No skill auto-runs the next; the handoff message names the next skill but the human invokes it.
- **Cowork vs Claude Code split:** Discovery, specs, test plan, build prompt, and test execution run in Cowork. The build itself runs in Claude Code. Documented in `dydx-delivery/skills/generate-build-prompt/references/when-to-open-claude-code.md`.
- **Sandbox-only test execution:** `execute-tests` enforces the sandbox identifier match in test plan frontmatter; refuses runs against non-sandbox tenants.
- **No deletions during test execution:** Hard rule in `dydx-delivery/skills/execute-tests/references/safety-rules.md`.
- **Read-write only during test execution:** Create/update/read allowed; deletes refused; destructive automations outside scope refused.
- **Rate limit ceiling:** `execute-tests` defaults to 80% of platform documented rate limit; backs off on 429.
- **Stop on infra failure:** `execute-tests` aborts run after 3 consecutive infrastructure errors.
- **Explicit "go" before test run:** `execute-tests` requires explicit user confirmation after pre-flight checks before executing.
- **Build prompt safety constraints:** No production tenant access, no deletion of client data/files, no additions outside SOW scope, no credentials in code or commits — listed in `dydx-delivery/skills/generate-build-prompt/SKILL.md` Step 5 section 5.
- **Audit trail:** Every API call (and refusal) logged in the dated results file.
- **No skill modifies upstream artefacts:** A spec gap surfaces and pauses; spec changes happen in the upstream skill, not the downstream one.

## Anti-Patterns

### Bypassing the review gate inside Claude Code

**What happens:** Editing the technical spec on the fly inside Claude Code while the build is running.
**Why it's wrong:** Bypasses the Cowork review gate; breaks the audit trail and the spec-as-source-of-truth contract.
**Do this instead:** Make spec changes in Cowork, regenerate the build prompt if material, hand back to Claude Code (`dydx-delivery/skills/generate-build-prompt/SKILL.md` lines 163-171).

### Hand-waved error paths in the technical spec

**What happens:** Listing an integration without specifying retries, circuit breaker, dead letter, idempotency.
**Why it's wrong:** Spec is not buildable; implementation partner needs a workshop.
**Do this instead:** Fill section 6 (Integration contracts) and section 7 (Error handling and observability) per `dydx-delivery/skills/generate-technical-spec/SKILL.md` Step 4.

### Platform vocabulary in the functional spec

**What happens:** Writing "Pipefy phase" or "Wrike custom field" inside `02_functional-spec_vN.md`.
**Why it's wrong:** Functional spec is platform-agnostic by contract; platform mapping happens in the technical spec.
**Do this instead:** Use neutral terms ("approval state", "priority field"); platform binding occurs in `dydx-delivery/skills/generate-technical-spec/SKILL.md` Step 4 section 2.

### Vague edge cases

**What happens:** Functional spec contains "Handle errors gracefully".
**Why it's wrong:** Not testable; no test row can be derived.
**Do this instead:** Concrete edge case with system, condition, and response (e.g. "If Ziflow returns 401, queue the request for retry up to 3 times then raise a support ticket"), per `dydx-delivery/skills/generate-functional-spec/SKILL.md` Step 4.

### Destructive test rows

**What happens:** Test plan row uses a `delete_*` API call or fires real external integrations outside scope.
**Why it's wrong:** `execute-tests` refuses these and logs `REFUSED: destructive action` (`dydx-delivery/skills/execute-tests/SKILL.md` Hard rules block).
**Do this instead:** Mark `Sandbox-safe? No` in the test plan row, per `dydx-delivery/skills/generate-test-plan/SKILL.md` Step 4.

### Inventing answers for unknown discovery items

**What happens:** Skill fills in a discovery dimension by guessing.
**Why it's wrong:** Downstream specs anchor on discovery; an invented answer propagates.
**Do this instead:** Write `**Unknown — needs client input**` literal, per `dydx-delivery/skills/discovery-intake/SKILL.md` Step 5.

## Error Handling

**Strategy:** Surface gaps explicitly; refuse to fabricate; pause for human input.

**Patterns:**

- Missing upstream artefact → start-at-any-point triage with three options (paste / inline capture / cancel).
- Unknown discovery answer → literal `**Unknown — needs client input**` marker.
- Spec gap discovered downstream → skill surfaces it and pauses; does not modify upstream artefact.
- Test row violates safety rule → log `REFUSED: <reason>` and continue to next row.
- Setup fails → log `SETUP_FAILED`, skip the test, continue.
- Sandbox unreachable / auth failure → abort run, write partial results.
- 3 consecutive infrastructure errors → abort run, log `INFRA_DEGRADED`, write partial results.
- Rate limited (429) → back off, retry, continue.
- User cancels mid-run → stop on next test boundary, write partial results.
- Sandbox identifier mismatch in test plan frontmatter → refuse to run, explain.
- Test plan `status:` not `approved` → ask user "proceed anyway? (y/n)".
- Platform skill unavailable for named platform → refuse to run; ask user to provide API contract inline or skip.

## Cross-Cutting Concerns

**Logging:** `execute-tests` writes every API call, request payload, response, and assertion result in real-time to the dated results file (no buffering — partial results survive abort).

**Validation:** Frontmatter is mandatory on every artefact; each skill validates required fields before drafting (`platform:`, `status:`, `based_on_*`).

**Authentication:** Sandbox API credentials loaded from environment variables, never in code or commits, named explicitly in the build prompt (`dydx-delivery/skills/generate-build-prompt/SKILL.md` Step 5 section 6).

**Versioning (semver) for the plugin:** Patch = bug fix or doc update; Minor = new skill or backward-compatible capability; Major = breaking change to skill names, output paths, or pipeline contract (`README.md` lines 79-83). Plugin version bumped in `dydx-delivery/.claude-plugin/plugin.json` and matched in `.claude-plugin/marketplace.json`.

**Versioning (Option B) for artefacts:** First run writes `_v1.md`. Reviewer either edits in place or saves as `_v{N+1}.md`. Next skill reads highest. Optional sibling `_review.md` for major iteration notes.

**Audit trail:** Every artefact carries `based_on_*` frontmatter pointing back to the source artefact by exact filename. Test results carry the test plan version reference.

---

*Architecture analysis: 2026-05-09*
