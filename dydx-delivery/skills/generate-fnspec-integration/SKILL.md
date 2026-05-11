---
name: generate-fnspec-integration
description: Generate the Stage 4b integration functional spec. Use when the user says "generate fnspec-integration for X", "draft 4b", "integration fnspec", or asks for a functional spec scoped to system-to-system integrations after discovery + SOW + 4a are approved. Reads approved 02_discovery_v* + approved 03_sow_v* + approved 04a_fnspec-platform_v*. Runs three cross-spec consistency checks FIRST before any write; halts with 04b_consistency_check_v<N>.md on failure. On either-spec-skip topology, emits the verbatim skip-emit string to stdout and writes no artefact. Writes 04b_fnspec-integration_v<N>.md on clean check + integration-in-scope path with every row carrying the delivery: native-ai | api routing key.
---

# generate-fnspec-integration

Stage 4b of the dydx-delivery pipeline. This skill carries three responsibilities: (1) **consistency-check ownership** — runs the three D-84 cross-spec checks FIRST, before any write, halting with `04b_consistency_check_v<N>.md` on any failure; (2) **either-spec-skip detection** — when SOW + 4a signals indicate no integration work is in scope, emits the verbatim string `Stage 4b SKIPPED — no integration work in scope` to stdout and writes NO artefact (D-85); (3) **integration fnspec authorship** — on the clean, in-scope path, writes `04b_fnspec-integration_v<N>.md` with every integration-touchpoint / API-endpoint / acceptance-criteria row carrying the `delivery: native-ai | api` routing key in canonical enum order (D-82). Stage 4b reads 4a's per-row classifications as-is (no re-classification — D-81 closing clause).

> **Hard rules — read first.** Honour every constraint in `dydx-delivery/references/safety-rules.md`. Reviewer is the authoritative operator; this skill writes drafts into the reviewer's working area only.

> **Stage numbering.** This skill writes `04b_fnspec-integration_v<N>.md` on the clean path and `04b_consistency_check_v<N>.md` on the halt path. The version suffix follows the canonical scheme in `dydx-delivery/references/stage-numbering.md`. The 4b artefact is one of the inputs Stage 5 v2.3 will consume via the `based_on_*` chain.

> **Frontmatter scheme.** Both output artefacts honour the canonical frontmatter contract in `dydx-delivery/references/frontmatter-scheme.md`. The 4b fnspec emits `platform: <pipefy | wrike | ziflow | other>` + `based_on_discovery:` + `based_on_sow:` + `based_on_fnspec_platform:` (CONDITIONAL — present when 4a exists; absent on 4b-only topology) + the canonical 4-state `status:` lifecycle.

> **Glossary.** Canonical terms used throughout: `delivery: native-ai | api`, `platform: pipefy | wrike | ziflow | other`, `based_on_fnspec_platform`, `Stage 4b SKIPPED — no integration work in scope`. Definitions live in `dydx-delivery/references/glossary.md`.

## Inputs

- Approved `02_discovery_v<N>.md` — `status: approved` enforced. Read for data-flow narrative + system landscape (Step 6 senior-level challenge cross-checks against this).
- Approved `03_sow_v<N>.md` — `status: approved` enforced. MANDATORY per STG3-02 (single SOW path). Read `## Platform Scope` and `## Integration Scope` H2s for topology signal (Step 2) and walked touchpoint-by-touchpoint in Step 5.
- Approved `04a_fnspec-platform_v<N>.md` — CONDITIONAL. Present on the 'both' topology; absent on the 4b-only topology. When present, drives the three consistency checks in Step 3 (the per-row `delivery:` tags are the canonical routing-key source).
- Explicit reviewer signal at invocation — fallback per D-85 when SOW H2 topology signal is ambiguous (Step 2 prompts the reviewer in that case).

## Output

- **Clean path (integration in scope + consistency checks pass):** `<Client> Brain/<Project>/04b_fnspec-integration_v<N>.md` per DESIGN-02. Body shape per `references/fnspec-integration-template.md`.
- **Halt path (any consistency check fails):** `<Client> Brain/<Project>/04b_consistency_check_v<N>.md` per ROUTE-02 + D-84. Frontmatter contract: `artefact_type: consistency_check_failure` + `checks_run: 3` + `checks_failed: <N>` + `status: halt`. Body lists every failure row in a `Check ID | Failure type | Row reference | Detail | Suggested resolution` table. NO `04b_fnspec-integration_v<N>.md` is written on the halt path.
- **Skip path (either-spec-skip topology — D-85):** Emit the verbatim string `Stage 4b SKIPPED — no integration work in scope` to stdout. Write NO artefact. No consistency check runs. Exit.

## How to run

### Step 1 — Locate approved upstream artefacts

Find the highest-version `02_discovery_v*.md` with `status: approved`. Find the highest-version `03_sow_v*.md` with `status: approved` — MANDATORY input. Find the highest-version `04a_fnspec-platform_v*.md` if it exists in the project folder; presence is one of the topology signals consumed in Step 2.

If any MANDATORY input is missing or not approved, do start-at-any-point triage per `dydx-delivery/references/safety-rules.md`: name the missing input, point at the upstream skill that produces it, halt.

### Step 2 — Either-spec-skip detection (D-85 + STG4-06)

Combine three signals to determine topology, in this priority order:

1. **Explicit reviewer signal at invocation** — highest priority. Overrides everything below.
2. **SOW `## Platform Scope` + `## Integration Scope` H2 content** — Phase 7 D-75 locked these H2s as always-present-but-emptiable. Empty / "n/a" / absent body under either H2 == that side is out of scope.
3. **Presence/absence of `04a_fnspec-platform_v*.md`** — if 4a does not exist in the project folder, 4a is out of scope (4b-only topology).

Topology rules detailed in `references/either-spec-skip-paths.md`.

If the combined signal determines integration is OUT of scope (4a-only topology), emit the verbatim string to stdout and exit — write NO `04b_*` artefact and run NO consistency check:

```
Stage 4b SKIPPED — no integration work in scope
```

If SOW H2 content is ambiguous (only "TBD" or a single placeholder sentence), prompt the reviewer: "SOW Integration Scope is ambiguous — is integration in scope (y/N)?" The reviewer's answer becomes signal 1 (explicit reviewer signal). Proceed based on that.

### Step 3 — Run consistency checks FIRST (D-84 + ROUTE-01, before any write)

Three cross-spec checks. Run all three against approved 4a output + draft 4b plan, BEFORE writing any `04b_fnspec-integration_v<N>.md`:

- **Check (a)** — no requirement ID with conflicting `delivery:` tags across 4a and 4b. For every requirement ID appearing in BOTH 4a and 4b, the routing key MUST match.
- **Check (b)** — every 4b integration touchpoint cites a referenced platform requirement ID from 4a in its `Cites 4a req` column (no dangling refs). Dangling = empty cite OR cite to a req_id that does not exist in 4a.
- **Check (c)** — no orphan API endpoints in 4b. Every row in 4b section 5a (API endpoints) MUST map to a 4a requirement ID via the `Cites 4a req` column.

Trigger logic + halt-on-failure protocol detailed in `references/consistency-rules.md`.

On ANY failure (any of (a), (b), or (c) fails on any row): write `04b_consistency_check_v<N>.md` to `<Client> Brain/<Project>/` (frontmatter per the `references/consistency-rules.md` halt-path contract; body lists failure rows in a `Check ID | Failure type | Row reference | Detail | Suggested resolution` table). Emit halt message to stdout. EXIT — do NOT write `04b_fnspec-integration_v<N>.md` on this run.

On clean checks (all three pass on every row), continue to Step 4. No clean-run audit artefact is written; clean checks leave no footprint per D-84.

### Step 4 — Check for existing 4b artefact + re-run policy

If `04b_fnspec-integration_v*.md` already exists in the project folder, ask the reviewer: revise / extend / fresh? Preserve any `[reviewer-override:]` tokens in existing rows per D-82 (these are the canonical re-run preservation trigger — never silently re-classify a reviewer-overridden row).

### Step 5 — Draft the integration fnspec body

Walk the SOW `## Integration Scope` section touchpoint-by-touchpoint. Produce sections 1-10 per `references/fnspec-integration-template.md`. Sections 4 (Integration touchpoints), 5 (Integration business rules), 5a (API endpoints), and 8 (Acceptance criteria) all carry the `Delivery` column with per-row D-82 markup.

Apply D-82 row markup using 4a's classifications as input — Stage 4b reads 4a's per-row tags AS-IS per D-81 closing clause. 4b does NOT re-classify. Canonical enum order is `native-ai | api` — the reversed form is forbidden per STG4-04 lock.

### Step 6 — Senior-level challenge

Cross-check integration touchpoints against the discovery's data-flow narrative — does every touchpoint correspond to a real system-to-system arrow in discovery? Verify every API endpoint has explicit error-path rules. Surface any orphan touchpoints that don't appear in the SOW.

### Step 7 — Write and hand off

Write to `<Client> Brain/<Project>/04b_fnspec-integration_v<N>.md`. Emit the verbatim handoff message:

```
Awaiting status: approved on 04b_fnspec-integration_v<N>.md. Stage 5 v2.3 reads both 4a + 4b via the based_on_* chain (based_on_discovery + based_on_sow + based_on_fnspec_platform).
```

## Key decisions

- **D-78 — TD-2 resolution.** Stage-skill `platform:` enum is `pipefy | wrike | ziflow | other`. Ziflow is wired through as a routing-key value per `platform-ziflow/SKILL.md`.
- **D-79 — Platform-API Addendum carrier (ROUTE-03).** Stage 4a owns the addendum body authorship; this 4b reads `has_platform_api_addendum:` + `tech_spec_scope:` from 4a frontmatter on the read-side (no write-side responsibility here).
- **D-82 — Per-row routing markup.** Every integration-touchpoint / API-endpoint / acceptance-criteria row carries `delivery: native-ai | api [<confidence>, src: <platform>]` in canonical enum order. 4b does NOT re-classify rows — reads 4a's per-row tags as-is per D-81 closing clause.
- **D-84 — Consistency check ownership.** This 4b OWNS the three cross-spec consistency checks; runs them FIRST before any fnspec write. On any failure → emit `04b_consistency_check_v<N>.md` + HALT.
- **D-85 — Either-spec-skip mechanics.** This 4b detects either-spec-skip via SOW H2s + presence/absence of 4a output. When out-of-scope → emit verbatim `Stage 4b SKIPPED — no integration work in scope` to stdout, write NO artefact, exit.

## What this skill does not do

- Does NOT re-classify rows — reads 4a's per-row `delivery:` tags as-is per D-81 closing clause.
- Does NOT author the Platform-API Addendum body — that is 4a's responsibility per D-79.
- Does NOT auto-progress to Stage 5 — approval gate non-negotiable per DESIGN-06.
- Does NOT write `04b_fnspec-integration_v*.md` when consistency checks fail — halt-path emits `04b_consistency_check_v*.md` ONLY (D-84 halt-on-failure).
- Does NOT write any `04b_*` artefact on either-spec-skip topology — stdout skip-emit only (D-85).

## Quality bar

- Three consistency checks run FIRST before any fnspec write (D-84).
- Every row in integration-touchpoints / API-endpoints / acceptance-criteria tables carries D-82 `delivery:` markup in canonical enum order (`native-ai | api`).
- Halt-path artefact `04b_consistency_check_v<N>.md` lists every failure row with a Suggested resolution column (no generic "fix it" prose).
- Skip-path emits the verbatim D-85 string `Stage 4b SKIPPED — no integration work in scope` (em-dash `—` verbatim, not hyphen) and writes NO file.
- 4 canonical references all resolve (`safety-rules.md`, `stage-numbering.md`, `frontmatter-scheme.md`, `glossary.md`).
- Handoff message emitted verbatim on clean path.
