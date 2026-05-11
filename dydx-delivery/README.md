# dydx-delivery

Stage-gated client delivery pipeline for dYdX Digital. It turns a kickoff into approved delivery artefacts, then into a build prompt and sandbox test execution. Every stage is human-reviewed before the next stage runs.

**Cowork is the strategy seat. Claude Code is the build seat.** Cowork handles messy discovery, specs, and test planning. Claude Code executes the generated build prompt when implementation work is ready.

## Main Flow

```text
kickoff-capture
  -> discovery-intake OR generate-sow
  -> generate-sow
  -> generate-fnspec-platform
  -> generate-fnspec-integration, when integration scope exists
  -> generate-technical-spec
  -> generate-test-plan
  -> generate-build-prompt
  -> Claude Code build
  -> execute-tests
```

No skill auto-runs the next skill. The human approval gate is always explicit.

## Skills

| Skill | What it does | Runs in |
|---|---|---|
| `kickoff-capture` | Structures raw kickoff notes, Miro narration, or Field Notes rows into `01_kickoff_v<N>.md`. Sets `kickoff_branch:`. | Cowork |
| `discovery-intake` | Expands an approved kickoff into `02_discovery_v<N>.md` when `kickoff_branch: discovery-ready`. | Cowork |
| `generate-sow` | Produces scope, deliverables, exclusions, assumptions, risks, dependencies, and commercial framing. | Cowork |
| `generate-fnspec-platform` | Produces platform-shaped functional requirements with per-row `delivery: native-ai | api` routing. | Cowork |
| `generate-fnspec-integration` | Produces integration-shaped functional requirements and cross-checks them against the platform spec. | Cowork |
| `generate-technical-spec` | Loads the relevant platform skill and produces implementation-level technical detail. | Cowork |
| `generate-test-plan` | Produces structured test cases mapped to acceptance criteria. | Cowork |
| `generate-build-prompt` | Produces a Claude-Code-ready build prompt. | Cowork generates; Claude Code executes |
| `execute-tests` | Runs the approved test plan against the named sandbox tenant. Read-write only; no destructive actions. | Cowork |

## Runtime References

Early-stage skills use compact runtime references to keep token use down:

- `references/runtime-stage-map.md`
- `references/runtime-frontmatter.md`
- `references/runtime-safety-summary.md`

The larger canonical references remain available for maintenance and later-stage work:

- `references/stage-numbering.md`
- `references/frontmatter-scheme.md`
- `references/safety-rules.md`
- `references/glossary.md`
- `references/connector-matrix.md`

## File Locations

Typical artefacts land in this shape:

```text
<Client> Brain/
├── <Project>/
│   └── 01_kickoff_v1.md
├── build-specs/
│   └── <platform>/
│       ├── 02_discovery_v1.md
│       ├── 03_sow_v1.md
│       ├── 04a_fnspec-platform_v1.md
│       ├── 04b_fnspec-integration_v1.md
│       ├── 05_techspec_v1.md
│       └── 07a_build-prompt_v1.md
└── test-bot/
    └── test_cases/
        └── 08b_test-plan_v1.md
```

After Claude Code executes the build prompt, it writes a sibling report next to the prompt:

```text
<Client> Brain/build-specs/<platform>/07a_build-prompt_v1_report.md
```

## Versioning

- First drafts write `_v1.md`.
- Reviewed revisions write `_v2.md`, `_v3.md`, and so on.
- Downstream stages read the highest approved upstream version.
- Optional `_review.md` siblings may capture major review notes.

## Platform Handling

`kickoff-capture` and `discovery-intake` carry `platform:` in frontmatter: `pipefy`, `wrike`, `ziflow`, or `other`. Downstream technical stages use that value to load the matching platform skill.

Supporting tools such as Ziflow, Workato, Frontify, and Slack belong in `integrations:` unless they are the primary platform.

## Test Execution Safety

Sandbox-only operations. Test execution is read-write against named sandbox tenants only. Destructive actions are refused.

## Installing

```text
/plugin marketplace add https://github.com/SonofJay13/dydx-project-workflow
/plugin install dydx-delivery
```

Install in both Cowork and Claude Code if you want the same delivery language available in both tools.
