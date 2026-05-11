---
name: generate-fnspec-platform
description: Generate the Stage 4a platform functional spec. Use when the user says "generate fnspec-platform for X", "draft 4a", "platform fnspec", or asks for a functional spec scoped to platform configuration after discovery + SOW are approved. Reads approved 02_discovery_v* + approved 03_sow_v* + the loaded platform skill's references/native-ai-inventory.md. Writes 04a_fnspec-platform_v<N>.md with every requirement row carrying the delivery: native-ai | api routing key. On the platform-only-with-API-rows topology, also authors the ## Platform-API Addendum H2 body inline per ROUTE-03.
---

# generate-fnspec-platform

Stage 4a of the dydx-delivery pipeline. Translate an approved discovery + approved SOW + the loaded platform skill's `references/native-ai-inventory.md` into a platform-side functional spec where every business-rule / field-level-requirement / acceptance-criterion row carries the `delivery: native-ai | api` routing key per D-82 (canonical enum order, never reversed — STG4-04 lock). Inputs are: approved `02_discovery_v<N>.md`, approved `03_sow_v<N>.md`, the loaded platform skill's `references/native-ai-inventory.md`, and (on the draft-sow path) approved `01_kickoff_v<N>.md`. Output is `04a_fnspec-platform_v<N>.md`. On the platform-only-with-API-rows topology (no 4b in scope AND this 4a has any `delivery: api` rows), this skill also authors the `## Platform-API Addendum` H2 body INLINE per D-79 / ROUTE-03 and emits `has_platform_api_addendum: true` + `tech_spec_scope: platform-api-addendum-only` in frontmatter.

> **Hard rules:** Sandbox-only operations. Refuses destructive actions on production tenants. Approval gate is non-negotiable per DESIGN-06. See `dydx-delivery/references/safety-rules.md` for the canonical ruleset.

> **Stage numbering:** This skill writes `04a_fnspec-platform_v<N>.md` per the canonical file-prefix scheme — Stage 4a in the dydx-delivery pipeline. See `dydx-delivery/references/stage-numbering.md` for the canonical Stage 4a placement + old→new mapping table.

> **Frontmatter scheme:** This skill emits `platform: <pipefy | wrike | ziflow | other>` + `based_on_discovery:` + `based_on_sow:` + (conditional) `based_on_kickoff:` + `has_platform_api_addendum:` + `tech_spec_scope:` per the canonical underscore-snake-case convention. See `dydx-delivery/references/frontmatter-scheme.md` for the canonical scheme + lenient-mode contract.

> **Glossary:** `delivery: native-ai | api`, `platform: pipefy | wrike | ziflow | other`, `[reviewer-override:]`, and `has_platform_api_addendum` are canonical terms defined in `dydx-delivery/references/glossary.md`.

## Inputs

- **Approved `02_discovery_v<N>.md`** — `status: approved` enforced. Highest-version approved discovery is the normal Stage 4a upstream.
- **Approved `03_sow_v<N>.md`** — `status: approved` enforced. MANDATORY (single-SOW path per STG3-02). The SOW's `platform:` value drives which platform skill's native-AI inventory loads at Step 2.
- **Approved `01_kickoff_v<N>.md`** — CONDITIONAL substitute for discovery on the `kickoff_branch: draft-sow` path (Phase 7 D-74 carry-forward). When this path is in use, `based_on_kickoff:` is set in frontmatter and `based_on_discovery:` is omitted.
- **Loaded platform skill's `references/native-ai-inventory.md`** — the classifier input. Loaded based on the SOW's `platform:` value. Path: `dydx-delivery/skills/platform-<platform>/references/native-ai-inventory.md` where `<platform>` is one of `pipefy | wrike | ziflow | other` (D-78 expanded 4-enum). HIGH / MEDIUM / LOW / `[OPEN]` confidence rows feed the Step 4 classifier per DESIGN-14/15/16.

## Output

`<Client> Brain/<Project>/04a_fnspec-platform_v<N>.md` per DESIGN-02 file-prefix scheme. Frontmatter contract:

```yaml
---
client: <CLIENT_NAME>
project: <PROJECT_NAME>
frontmatter_version: 2
platform: <pipefy | wrike | ziflow | other>           # D-78 — 4-enum
based_on_discovery: 02_discovery_v<N>.md              # MANDATORY when discovery exists
based_on_sow: 03_sow_v<N>.md                          # MANDATORY (single SOW path per STG3-02)
based_on_kickoff: 01_kickoff_v<N>.md                  # CONDITIONAL — only on draft-sow path
status: draft                                         # canonical 4-state: draft → client_review → approved → archived
has_platform_api_addendum: <true | false>             # D-79 — present only when 4b is OUT of scope AND 4a has any delivery: api rows
tech_spec_scope: platform-api-addendum-only           # D-79 — present only when has_platform_api_addendum: true
approved_by: <name-or-handle>                         # MANDATORY on status: approved writes (DESIGN-06)
approved_at: <ISO date>                               # MANDATORY on status: approved writes (DESIGN-06)
generated_at: <ISO date>
---
```

Conditionally — when D-79 conditions hold — this skill also authors the `## Platform-API Addendum` H2 body inline within the same artefact using `references/addendum-template.md`. The addendum body is the v2.3 Stage 5 input on the platform-only-with-API-rows topology per ROUTE-03.

If `<Client>` or `<Project>` is unclear from context, ask the reviewer once before drafting.

## How to run

### Step 1 — Locate approved upstream artefacts

Find the highest-version approved `02_discovery_v*.md` AND approved `03_sow_v*.md` in the client folder. Both must carry `status: approved`. If discovery is absent (the `kickoff_branch: draft-sow` path), substitute the highest-version approved `01_kickoff_v*.md` and record it under `based_on_kickoff:` in frontmatter; omit `based_on_discovery:`.

**If a required upstream is missing**, run start-at-any-point triage:

> I don't see an approved `<artefact>` for `<Client>` at `<expected path>`. How do you want to proceed?
>
> **(a) Paste an existing approved artefact** — I'll save it at the canonical path and continue
> **(b) Walk through the contents inline** — I'll stub the upstream and proceed
> **(c) Cancel**

### Step 2 — Load platform skill's native-AI inventory

Read the SOW's `platform:` frontmatter value (one of `pipefy | wrike | ziflow | other` per D-78). Load `dydx-delivery/skills/platform-<platform>/references/native-ai-inventory.md`. Cache the HIGH / MEDIUM / LOW / `[OPEN]` confidence rows in memory — these are the classifier input for Step 4 per DESIGN-14/15/16. If `platform: other`, the inventory load is skipped and every row defaults to `delivery: api` (no `src:` reference); document this in the artefact's open-questions section.

### Step 3 — Check for existing 4a artefact + re-run policy

Look for `04a_fnspec-platform_v*.md` in the client folder. If found, ask the reviewer: revise (`_v{N+1}`), extend, or start fresh. On the revise path, scan every existing row in sections 4 (Business rules) / 5 (Field-level requirements) / 8 (Acceptance criteria) for the literal `[reviewer-override:` token. Rows carrying that token MUST be preserved verbatim — do NOT re-apply the classifier rubric. This is the D-81 + D-82 re-run preservation rule.

### Step 4 — Draft the platform fnspec body

Use the template at `references/fnspec-platform-template.md`. Walk the SOW's `## Platform Scope` section deliverable-by-deliverable; produce sections 1 through 10 of the template. For every row in sections 4 (Business rules) / 5 (Field-level requirements) / 8 (Acceptance criteria), apply the classifier rubric in `references/auto-classify-rubric.md` (D-81 + STG4-05) and emit the D-82 routing markup verbatim:

```
delivery: native-ai [HIGH, src: platform-pipefy]
delivery: native-ai [MEDIUM, src: platform-wrike]
delivery: api [LOW → default api, src: platform-ziflow]
```

Canonical enum order is `native-ai | api` — the reversed form is forbidden per STG4-04 lock. The unicode arrow `→` is verbatim (never `->`). Rows already carrying `[reviewer-override:]` (from Step 3 re-run preservation) are skipped — do NOT re-classify them. See `references/auto-classify-rubric.md` for the 5 explicit triggers, the escalation table, and the operational-principle backstop.

**Important — keep it platform-agnostic in the row prose.** Do not write "Pipefy phase" or "Wrike custom field" in the rule body. Write "approval state" or "priority field." The `src: platform-<X>` marker in the D-82 suffix is the only place platform names appear at row level. Platform-implementation detail belongs in the technical spec (Stage 5), not here.

### Step 5 — Scope-gate branch decision (ROUTE-03 / D-79)

Determine the 4b topology from the SOW's `## Integration Scope` section AND whether this 4a has any `delivery: api` rows after Step 4:

- **If no-4b-in-scope (SOW omits `## Integration Scope` OR the section is empty) AND 4a has any `delivery: api` rows** → set `has_platform_api_addendum: true` AND `tech_spec_scope: platform-api-addendum-only` in frontmatter, AND author the `## Platform-API Addendum` H2 body INLINE within `04a_fnspec-platform_v<N>.md`, using `references/addendum-template.md` as the body skeleton. Apply full error-paths discipline (concrete, not generic) per D-79. Every row in the addendum's API surface inventory table continues to carry D-82 markup.

- **Else** (4b is in scope, OR 4a has no `delivery: api` rows) → omit both frontmatter fields AND omit the `## Platform-API Addendum` H2 body. Stage 4b (08-02 product) will consume this 4a as upstream and run its own three cross-spec consistency checks per D-84.

Name both branches explicitly when reasoning aloud during the run so reviewers can audit which branch fired.

### Step 6 — Senior-level challenge

Before finalising, pressure-test:

- Is every business rule numbered and unambiguous? Reword anything that can be read two ways.
- Does every SOW platform deliverable have at least one user journey + at least one acceptance-criteria row? If not, the SOW is incomplete — flag back to Stage 3.
- Are edge cases concrete? "Handle errors gracefully" is not an edge case — "If the platform returns 429, queue the request with exponential backoff up to 3 retries" is.
- Is anything in here secretly a platform-implementation detail (config trees, screen layouts, vendor field types)? Move it to the technical spec.
- When the addendum branch fired (Step 5), does every row in the addendum's Error paths table carry a concrete per-platform error mapping AND a reviewer-facing message? Generic prose fails the D-79 discipline check.

### Step 7 — Write and hand off

Write the artefact to `<Client> Brain/<Project>/04a_fnspec-platform_v<N>.md`. Set the frontmatter block exactly as documented in `references/fnspec-platform-template.md` with concrete enum values (NOT placeholders). On `status: approved` writes (per DESIGN-06) `approved_by` and `approved_at` are mandatory.

Then emit the verbatim handoff:

```
Awaiting status: approved on 04a_fnspec-platform_v<N>.md. Stage 4b (generate-fnspec-integration) reads this artefact when integration scope exists. If integration is out-of-scope AND this 4a carries delivery: api rows, this artefact's `## Platform-API Addendum` H2 body is the v2.3 Stage 5 input via has_platform_api_addendum: true + tech_spec_scope: platform-api-addendum-only frontmatter.
```

Approval is a hard gate per DESIGN-06; do not auto-progress to Stage 4b or Stage 5.

## Key decisions

- **D-78 — TD-2 resolution.** Stage-skill `platform:` enum is `pipefy | wrike | ziflow | other`. Ziflow is wired through as a routing-key value per `platform-ziflow/SKILL.md`.
- **D-79 — Platform-API Addendum carrier (ROUTE-03).** When no 4b is in scope AND this 4a has any `delivery: api` rows, this skill authors the FULL `## Platform-API Addendum` H2 body inline + emits `has_platform_api_addendum: true` + `tech_spec_scope: platform-api-addendum-only`. v2.3 Stage 5 reads these frontmatter fields and consumes the addendum body verbatim.
- **D-82 — Per-row routing markup.** Every business-rule / field-req / acceptance-criteria row carries `delivery: native-ai | api [<confidence>, src: <platform>]` in canonical enum order. `[reviewer-override:]` token is the re-run preservation trigger.
- **D-84 — Consistency check ownership.** Stage 4b OWNS the three cross-spec consistency checks; this 4a does NOT run them. 4a's contract is to emit clean, classified rows that 4b can verify.
- **D-85 — Either-spec-skip mechanics.** Stage 4a runs normally regardless of 4b topology; there is no "skip 4a" path. 4b detects either-spec-skip via SOW H2s + presence/absence of this 4a output. See `dydx-delivery/skills/generate-fnspec-integration/references/either-spec-skip-paths.md` for the three-topology rules (4a-only / 4b-only / both) and the verbatim D-85 skip-emit string (STG4-06).

## What this skill does not do

- Does NOT run the cross-spec consistency checks — those are owned by Stage 4b (D-84).
- Does NOT auto-progress to Stage 4b — approval gate non-negotiable per DESIGN-06.
- Does NOT re-classify rows carrying `[reviewer-override:]` token on re-run (D-81 + D-82 preservation rule).
- Does NOT consume the addendum body downstream — v2.3 Stage 5 reads `has_platform_api_addendum:` + `tech_spec_scope:` frontmatter to decide whether to skip writing `05_techspec_v<N>.md` (forward-compat interface only per ROUTE-03 + ROUTE-05).
- Does NOT call any Coda / native-AI ingestion APIs — DESIGN-14/15/16 native-ai-inventory is read-only file content; native-AI consumption ships in v2.5+ (Stage 10) per ROUTE-05.

## Quality bar

- Every row in sections 4 / 5 / 8 carries the D-82 `delivery:` markup (no row missing the routing key).
- Canonical enum order `native-ai | api` (never reversed) — STG4-04 lock.
- `[reviewer-override:]` tokens are preserved verbatim across re-runs.
- Addendum body (when present) per D-79 contract — error-paths discipline matching a full tech spec, API portions only.
- All 4 canonical references (`safety-rules.md`, `stage-numbering.md`, `frontmatter-scheme.md`, `glossary.md`) resolve at the paths above.
- Handoff message emitted verbatim (forms a structure-check anchor in 08-03's `phase8-structure-check.sh`).
