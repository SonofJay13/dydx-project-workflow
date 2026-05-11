# dydx-delivery

Stage-gated client delivery pipeline for dYdX Digital. Turns a discovery conversation into a fully tested implementation through seven skills, each gated by human review.

**Cowork is the strategy seat. Claude Code is the build seat.** The plugin runs in both — discovery, specs, and test runs happen in Cowork; the build itself happens in Claude Code, executed from a prompt this plugin generates.

## The pipeline

```
┌──────────────── Cowork ────────────────┐    ┌──── Claude Code ────┐    ┌─── Cowork ──┐
│                                        │    │                      │    │             │
│  discovery-intake                      │    │  (Build executes     │    │ execute-    │
│         ↓                              │    │   from build prompt) │    │  tests      │
│  generate-sow                          │    │                      │    │             │
│         ↓                              │    │  • Reads spec        │    │             │
│  generate-functional-spec              │    │  • Runs build steps  │    │             │
│         ↓                              │    │  • Self-tests        │    │             │
│  generate-technical-spec               │    │  • Writes report     │    │             │
│         ↓                              │    │                      │    │             │
│  generate-test-plan                    │    └──────────┬───────────┘    └─────────────┘
│         ↓                              │               │
│  generate-build-prompt  ───┐           │   ←───────────┘
│                            │           │   (Cowork stays open during the build —
└────────────────────────────┼───────────┘    refines prompts, answers spec questions)
                             │
                             ↓
                       Switch to Claude Code,
                       paste build prompt
```

## Skills

| Skill | What it does | Runs in |
|---|---|---|
| `discovery-intake` | Captures business outcome, users, systems, triggers, data, rules, integrations, exceptions, failure points. Sets `platform:` frontmatter. | Cowork |
| `generate-sow` | Produces scope, deliverables, exclusions, assumptions, risks, dependencies, commercial framing. | Cowork |
| `generate-functional-spec` | Produces user journeys, business rules, field-level requirements, edge cases, acceptance criteria. Platform-agnostic. | Cowork |
| `generate-technical-spec` | Loads the right platform skill (pipefy or wrike) by frontmatter. Produces pipes/blueprints, automation logic, field mappings, integration contracts, error handling. | Cowork |
| `generate-test-plan` | Produces a structured markdown test plan: scenario, setup, action, expected, assertion type. Maps every row to an acceptance criterion. | Cowork |
| `generate-build-prompt` | Produces a Claude-Code-ready build prompt — context, inputs to read, build sequence, constraints, self-test loop, done criteria. | Cowork (generates), Claude Code (executes) |
| `execute-tests` | A bot runs the test plan against the client's sandbox tenant via platform API. Read-write only, no deletes, no destructive actions. | Cowork |

> The plugin works in both tools — every skill is portable. But for typical dYdX engagements, Cowork is the entry point (better at handling messy human input) and Claude Code is the build target (better at filesystem and shell work). See `skills/generate-build-prompt/references/when-to-open-claude-code.md` for the full guide.

## Every stage runs the same loop

1. Read the highest-version artefact from the previous stage
2. If missing, run the **start-at-any-point triage**: paste it, walk through inline, or cancel
3. Draft the next artefact at `_v1.md`
4. Hand back to the human for review
5. Reviewer either edits in place (then bumps to `_v2.md`) or runs `/refine-<skill>` to regenerate

No skill auto-runs the next skill. The human is always the gate.

## File locations

Artefacts land in the standard client folder shape (see workspace `hub.md`):

```
<Client>/
├── build-specs/
│   └── <platform>/                       # pipefy | wrike | ziflow
│       ├── 00_discovery_v1.md
│       ├── 01_sow_v1.md
│       ├── 02_functional-spec_v1.md
│       ├── 03_technical-spec_v1.md
│       └── 04_build-prompt_v1.md          # ← Claude Code reads this
└── testing/
    └── <feature>/
        ├── test-plan_v1.md
        └── results-2026-05-05_v1.md
```

After Claude Code executes the build, it writes a sibling report:

```
<Client>/build-specs/<platform>/04_build-prompt_v1_report.md
```

## Versioning (Option B)

- Every skill writes `_v1.md` on first run
- Reviewer either edits the file in place, or saves their reviewed version as `_v2.md`
- Next skill always reads the highest version it can find
- Optional sibling `_review.md` for major iteration notes (used by `/refine-<skill>` if added later)

## Platform handling

`discovery-intake` sets a `platform:` field in the frontmatter (e.g. `pipefy`, `wrike`). Downstream skills (`generate-technical-spec`, `generate-build-prompt`, `execute-tests`) read this and dynamically load the matching platform skill (`platform-pipefy` or `platform-wrike`). Integration tools (Ziflow, Workato, etc.) are tagged in the same frontmatter under `integrations:` and handled inside the technical spec, not as primary platforms.

## When to switch from Cowork to Claude Code

Short answer: when the build prompt is ready and you're going to execute the build.

Long answer: see `skills/generate-build-prompt/references/when-to-open-claude-code.md`. Includes the decision matrix, the full flow with tool transitions, and the "stay in Cowork while Claude Code builds" pattern.

## Test execution — safety rules

> **Hard rules:** Sandbox-only operations. Read-write only against named sandbox tenants. Refuses destructive actions. See `dydx-delivery/references/safety-rules.md` for the canonical ruleset.

## Installing

This plugin is distributed via the dYdX Digital private marketplace. Install via:

```
/plugin marketplace add https://github.com/SonofJay13/dydx-project-workflow
/plugin install dydx-delivery
```

Install in **both** Cowork and Claude Code so the team can use it in either tool.

## Author

Jason Blignaut — Solutions Architect, dYdX Digital

## Changelog

- **0.3.0** — Renamed `generate-test-sheet` → `generate-test-plan` (and `test-sheet_v*.md` → `test-plan_v*.md`) for clearer team-facing language. The bot-run terminal stage (`execute-tests`) now carries explicit sandbox-enforcement rules in `references/safety-rules.md`; results are written to versioned `results-YYYY-MM-DD_vN.md` files.