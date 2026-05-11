# Either-spec-skip paths — STG4-06 + D-85

This file documents the STG4-06 three valid topologies (4a-only / 4b-only / both) and the D-85 either-spec-skip detection mechanics for Stage 4b. Cited from `generate-fnspec-integration/SKILL.md` Step 2.

## Three topologies (STG4-06)

### Topology 1 — `both` (typical case)

**Definition.** 4a is in scope AND 4b is in scope. `04a_fnspec-platform_v*.md` exists AND SOW `## Integration Scope` H2 has content.

**Behaviour.** Stage 4b runs normally:

1. Step 2 detects `both` topology — no skip.
2. Step 3 runs all three consistency checks (a / b / c) against approved 4a output.
3. On clean checks, Step 5 drafts the 4b body using 4a's `delivery:` tags as input (no re-classification).
4. Step 7 writes `04b_fnspec-integration_v<N>.md` with `based_on_fnspec_platform:` present in frontmatter.

Stage 5 v2.3 reads BOTH 4a + 4b via the `based_on_*` chain.

### Topology 2 — `4a-only` (no integration scope)

**Definition.** 4a is in scope, 4b is OUT of scope. `04a_fnspec-platform_v*.md` exists; SOW `## Integration Scope` H2 is empty / "n/a" / absent.

**Behaviour.** Stage 4b emits the verbatim D-85 skip-emit string to stdout and exits — NO `04b_*` artefact written, NO consistency check run.

**Forward-compat note.** On the `4a-only-with-API-rows` sub-path, 4a authors the `## Platform-API Addendum` H2 body inline per D-79 (ROUTE-03 forward-compat). Stage 5 v2.3 reads the addendum via `has_platform_api_addendum: true` + `tech_spec_scope: platform-api-addendum-only` frontmatter. On the `4a-only-with-NO-API-rows` sub-path, Stage 5 v2.3 skips entirely.

### Topology 3 — `4b-only` (no platform configuration scope)

**Definition.** 4a is OUT of scope, 4b is in scope. `04a_fnspec-platform_v*.md` does NOT exist in the project folder; SOW `## Integration Scope` H2 has content but `## Platform Scope` H2 is empty / "n/a" / absent.

**Behaviour.** Stage 4b runs normally BUT:

1. Consistency check (a) runs vacuously — no 4a to conflict with, so no (req_id, delivery_value) pairs from 4a side. (a) trivially passes.
2. Consistency check (b) runs vacuously — no 4a requirements to cite into. The 4b template `Cites 4a req` column may be omitted OR filled with `n/a`. (b) trivially passes.
3. Consistency check (c) runs vacuously — same reasoning as (b). (c) trivially passes.
4. `based_on_fnspec_platform:` frontmatter field is ABSENT from the 4b output (not commented out — entirely omitted).
5. Step 7 writes `04b_fnspec-integration_v<N>.md` normally with the conditional frontmatter field absent.

Stage 5 v2.3 reads only 4b (no 4a chain).

## Three-topology summary table

| Topology | 4a present? | SOW `## Platform Scope` | SOW `## Integration Scope` | 4b behaviour | `based_on_fnspec_platform:` in 4b frontmatter |
|----------|-------------|-------------------------|----------------------------|--------------|----------------------------------------------|
| both     | yes         | content                 | content                    | normal       | present                                       |
| 4a-only  | yes         | content                 | empty / n/a / absent       | skip-emit    | n/a (no 4b output)                            |
| 4b-only  | no          | empty / n/a / absent    | content                    | normal (vacuous checks) | absent (field omitted)                |

## Topology detection signals (D-85)

Three combined signals, in priority order — highest priority wins:

### Signal 1 (highest priority) — Explicit reviewer signal at invocation

The reviewer can declare topology at skill invocation. Examples: "integration is out of scope" / "no platform fnspec for this engagement" / "this is a 4b-only engagement". An explicit reviewer signal overrides every other signal below — Stage 4b honours the reviewer's declared topology immediately.

### Signal 2 — SOW H2 content

Read `## Platform Scope` + `## Integration Scope` H2s in the highest-version approved `03_sow_v*.md`. Phase 7 D-75 locked these H2s as ALWAYS present in the SOW (both H2s exist in every approved SOW); emptiness is the topology signal.

- `## Platform Scope` body = empty / "n/a" / "not in scope" / "TBD" → platform side is OUT of scope.
- `## Integration Scope` body = empty / "n/a" / "not in scope" / "TBD" → integration side is OUT of scope.
- Both H2s with content → `both` topology.

### Signal 3 — Presence/absence of 4a artefact

Check the project folder for `04a_fnspec-platform_v*.md`. If absent at Stage 4b invocation, 4a is OUT of scope → `4b-only` topology candidate (combined with signal 2 confirming `## Platform Scope` is empty).

## D-85 verbatim skip-emit string (locked)

When Stage 4b is determined OUT of scope (Topology 2 / `4a-only`), emit this verbatim string to stdout:

```
Stage 4b SKIPPED — no integration work in scope
```

- Em-dash `—` (U+2014) verbatim — NOT hyphen `-`, NOT en-dash `–`, NOT double-hyphen `--`.
- Stdout ONLY — write NO `04b_fnspec-integration_v*.md`, NO `04b_consistency_check_v*.md`, NO halt artefact.
- Consistency checks are NOT run on the skip path — there is nothing to check.

## Reviewer-override path for ambiguous SOW signal

When SOW H2 content is ambiguous (e.g., `## Integration Scope` contains only `TBD` / `to be confirmed` / a single placeholder sentence with no concrete touchpoints), Stage 4b PROMPTS the reviewer:

> SOW Integration Scope is ambiguous — is integration in scope (y/N)?

The reviewer's answer becomes signal 1 (explicit reviewer signal at invocation) and Stage 4b proceeds based on that. The skill does NOT silently assume on ambiguous SOW content — D-81 reviewer-authority invariant requires explicit declaration.

## Forward-compat note (ROUTE-03 + ROUTE-05)

- **Topology 1 (both)** — Stage 5 v2.3 reads BOTH 4a + 4b via the `based_on_*` chain (`based_on_discovery` + `based_on_sow` + `based_on_fnspec_platform`).
- **Topology 2 (4a-only with API rows)** — Stage 5 v2.3 reads 4a's `## Platform-API Addendum` H2 body verbatim per `has_platform_api_addendum: true` + `tech_spec_scope: platform-api-addendum-only` (D-79). No `05_techspec_v<N>.md` is written — the addendum body IS the tech spec.
- **Topology 2 (4a-only with NO API rows)** — Stage 5 v2.3 skips entirely. No tech spec written, no addendum, no frontmatter change (ROADMAP Phase 8 success criterion #4 branch c).
- **Topology 3 (4b-only)** — Stage 5 v2.3 reads only 4b (no 4a chain).

## How this rubric is consumed

`generate-fnspec-integration/SKILL.md` Step 2 references this file by relative path. Structure-check assertion I5 grep-asserts the verbatim D-85 skip-emit string `Stage 4b SKIPPED — no integration work in scope` (with unicode em-dash) is present in SKILL.md OR in this file — either location satisfies I5. The em-dash is locked per CONTEXT.md `<specifics>` line 178.
