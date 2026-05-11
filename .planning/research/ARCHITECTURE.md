# Architecture Research

**Domain:** Claude Code plugin (markdown-only skills + per-client artefact pipeline) — v2.0 "Implementor Edition" rebuild on top of an existing 7-skill v0.3.0 plugin.
**Researched:** 2026-05-09
**Confidence:** HIGH for plugin-surface mechanics and existing v0.3.0 contracts (verified against repo files), MEDIUM for the test-harness state-model and Coda doc-ID location (these are project decisions not yet shipped), LOW for nothing — all v2 surfaces are derivable from kickoff + existing skills.

> Scope: this document answers the **integration architecture** for v2 NEW capabilities. It does **not** redesign the three-tier (marketplace → plugin → skills) hierarchy, the stage-gated artefact pipeline, the Cowork/Claude-Code seat split, or the sandbox-only test execution model — those are validated baseline. Every decision below is expressed as **NEW**, **MODIFIED**, **RETIRED**, or **UNCHANGED** against v0.3.0 so the roadmap can scope phases cleanly.

---

## Standard Architecture

### System Overview (v2 target)

```
┌──────────────────────────────────────────────────────────────────────────────┐
│  Marketplace                .claude-plugin/marketplace.json                  │
│  (UNCHANGED — single plugin entry, source: ./dydx-delivery)                  │
└──────────────────────────────────────┬───────────────────────────────────────┘
                                       │ source
                                       ▼
┌──────────────────────────────────────────────────────────────────────────────┐
│  Plugin: dydx-delivery       dydx-delivery/.claude-plugin/plugin.json        │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐  ┌────────────┐              │
│  │  skills/   │  │ commands/  │  │  agents/   │  │  hooks/    │              │
│  │ (existing) │  │  (NEW)     │  │  (NEW)     │  │  (NEW)     │              │
│  └─────┬──────┘  └─────┬──────┘  └─────┬──────┘  └─────┬──────┘              │
└────────┼───────────────┼───────────────┼───────────────┼─────────────────────┘
         │               │               │               │
         ▼               ▼               ▼               ▼
   13 skills         5 slash-cmds     1 agent        2 hooks
   (10 stage         (/refine-* +     (test-bot      (validate-frontmatter,
    skills + 3        /gsd-test-      orchestrator   bump-artefact-version)
    platform)         bot-run +
                     /publish-docs +
                     /push-native-ai)

         │
         ▼
┌──────────────────────────────────────────────────────────────────────────────┐
│  Per-client workspace (canonical, OUTSIDE this repo)                         │
│                                                                              │
│  <Client> Brain/                                                             │
│  ├── 00_HUB.md                  ← carries Documentation: Drive link,         │
│  │                                Coda doc IDs, test-bot pointer             │
│  ├── ChangeRequests/                                                         │
│  │   ├── YYYY-MM_<Project>/   ← active CR — kickoff, discovery, SOW,         │
│  │   │   ├── 01_kickoff_v1.md     fnspecs, techspec, costing, prompts,       │
│  │   │   ├── 02_discovery_v1.md   docs, doc-diff, native-AI, signoff         │
│  │   │   ├── ...                                                             │
│  │   │   └── doc-diff.md                                                     │
│  │   └── Archive/             ← completed CRs                                │
│  └── test-bot/                ← persistent per-client harness (NEW)          │
│      ├── client_state.yaml                                                   │
│      ├── test_runner.py                                                      │
│      └── test_cases/                                                         │
│                                                                              │
│  Google Drive <Client>/                                                      │
│  ├── 00_Index (Doc)         ← canonical Drive index                          │
│  └── <doc-tree mirroring local Brain shape>                                  │
│                                                                              │
│  Coda <Client> Brain doc                                                     │
│  ├── Section per Brain spoke (one-way mirror of <Client> Brain/)             │
│  └── Field Notes table       ← read-only triage queue (input, not output)    │
└──────────────────────────────────────────────────────────────────────────────┘
```

### Component Responsibilities

| Component | Responsibility | Status |
|-----------|----------------|--------|
| Marketplace manifest | Declares plugin, version, source | UNCHANGED |
| Plugin manifest | Declares plugin name, version, surfaces (`commands`, `agents`, `hooks` directories implied by presence) | MODIFIED — version bump, no manifest schema change |
| `skills/` directory | Holds 13 skill folders (10 stage skills + 3 platform skills) | EXTENDED — 7 → 13 |
| `commands/` directory | Holds slash commands wrapping skills with prefilled args | NEW |
| `agents/` directory | Holds the test-bot orchestrator agent | NEW |
| `hooks/` directory | Holds validation/automation hooks fired on file events | NEW |
| Stage skills (10) | One skill per lifecycle stage; each reads upstream highest-version artefact, writes versioned output, emits handoff message | 4 NEW + 4 MODIFIED + 2 UNCHANGED + 1 RETIRED-AND-REPLACED (see Skill layout below) |
| Platform skills (3) | Internalised vocabulary, API contracts, native-AI inventory, ingestion path, gotchas — loaded by `platform:` frontmatter | NEW (referenced today, not present) |
| Per-client test bot | Persistent hybrid (Python + AI orchestrator) harness in `<Client> Brain/test-bot/`. Updated each ship, never recreated | NEW |
| Coda integration surface | Two roles: scope/cost task table (Stage 5) + brain mirror (Stage 10) | NEW (no Coda surface today) |
| Drive doc surface | Stage 8 publishing target; `Documentation:` link lives in `00_HUB.md` | NEW (no Drive surface today) |
| Native-AI knowledge surface | Stage 9 publishing target; per-platform direct API or copy-paste fallback | NEW |
| `references/safety-rules.md` (SoT) | Single canonical source for hard rules; every other surface points at it | MODIFIED (one canonical, three duplicates collapse to references) |

---

## Plugin Surface Decisions

For each surface, decision + rationale + concrete additions:

### `skills/` — EXTENDED 7 → 13

**Decision:** add 6 NEW stage skills + 3 NEW platform skills, modify 4 existing skills, retire 1 existing skill (the v0.3.0 single-fnspec skill is split into two).

**NEW stage skills (6):**

| Skill | Purpose | Reads | Writes |
|-------|---------|-------|--------|
| `kickoff-capture` | Stage 1 entry. Pulls Miro, meeting notes, feedback into a structured kickoff brief that branches into either full discovery or a draft SOW. | Free-form context (Miro MCP, pasted notes, gmail thread) + `<Client> Brain/00_HUB.md` for Coda Field-Notes triage | `ChangeRequests/<CR>/01_kickoff_v{N}.md` |
| `generate-fnspec-platform` | Stage 4a. Native-AI-buildable inventory + per-feature platform constructs. Tagged native-AI vs API-dependent. | Highest `03_sow_v*` + platform skill | `ChangeRequests/<CR>/04a_fnspec-platform_v{N}.md` |
| `generate-fnspec-integration` | Stage 4b. Cross-system flows, contracts, retries, idempotency, error handling — only emitted if integration work exists. | Highest `03_sow_v*` + `04a_fnspec-platform_v*` | `ChangeRequests/<CR>/04b_fnspec-integration_v{N}.md` |
| `generate-cost-estimate` | Stage 6. Reads tech spec + fnspecs, derives per-assignee task list with risk-adjusted hours, writes a Coda task table + a client-facing cost summary. Schema-maps existing client task table first. | Highest `04*_fnspec*` + `05_techspec_v*` (if exists) + Coda MCP (read existing client task table schema) | `ChangeRequests/<CR>/06_cost-estimate_v{N}.md` + Coda task rows |
| `generate-implementation-prompt` | Stage 7b. Non-dev companion to the existing dev build prompt — for client-side admins/PMs configuring native-AI features in-platform. | Highest `04a_fnspec-platform_v*` + platform skill | `ChangeRequests/<CR>/07b_implementation-prompt_v{N}.md` |
| `provision-test-harness` | Stage 8a. Bootstraps `<Client> Brain/test-bot/` once per client. Materialises `client_state.yaml`, `test_runner.py`, `test_cases/`. Subsequent runs **update**, do not recreate. | Highest `06_techspec_v*` + (if exists) `<Client> Brain/test-bot/client_state.yaml` | `<Client> Brain/test-bot/*` |
| `generate-uat-plan` | Stage 8c. Generates UAT (User Acceptance Test) plan tied to AC/EC IDs from fnspecs. Distinct from the bot-run technical test plan. | Highest `04*_fnspec*` + `06_techspec_v*` | `<Client> Brain/test-bot/test_cases/uat_plan_v{N}.md` |
| `update-documentation` | Stage 9. Generates `doc-diff.md` against current Drive docs, requires reviewer approval, then publishes via Drive MCP. Halts if `00_HUB.md` lacks `Documentation:` link. | Shipped CR artefacts + current Drive doc tree | `ChangeRequests/<CR>/doc-diff.md` + Drive doc updates |
| `push-native-ai-knowledge` | Stage 10. Direct API ingestion into platform native-AI (Pipefy AI, Wrike AI Studio, Ziflow AI) or copy-paste fallback per-platform skill. | Approved fnspec-platform + new/changed runbook fragments | Platform native-AI knowledge base + log line in CR |
| `sign-off-and-archive` | Stage 11. Brain update (local canonical), one-way push to Coda mirror, CR move from active to `Archive/`, Field-Notes triage delta queued for next kickoff. | Approved CR | `<Client> Brain/<spokes>/*.md` + Coda push + `ChangeRequests/Archive/<CR>/` |

**MODIFIED stage skills (4):**

| Skill | Change |
|-------|--------|
| `discovery-intake` | Now Stage 2. Consumes `01_kickoff_v*` instead of raw notes (kickoff has already done the structuring). Triage block trims because kickoff did Step 1. |
| `generate-sow` | Now Stage 3. Reads `02_discovery_v*` (path unchanged in shape, prefix changes). |
| `generate-technical-spec` | Now Stage 5. **Scope-gated** — only emitted if integration work exists in `04b_fnspec-integration_v*`. For platform-only CRs, a lightweight platform-API addendum is appended to `04a_fnspec-platform`. |
| `generate-build-prompt` | Now Stage 7a. Renamed conceptually to "dev build prompt" (paired with the new `generate-implementation-prompt` for non-dev work). |

**UNCHANGED stage skills (2):**

| Skill | Notes |
|-------|-------|
| `generate-test-plan` | Now Stage 8b ("technical test plan" — the bot's input). Reads `06_techspec_v*` + fnspecs. Body is unchanged but the file path shifts: it lives inside `<Client> Brain/test-bot/test_cases/` instead of `<Client>/testing/<feature>/`. |
| `execute-tests` | Stays the terminal "run the bot" skill. Reorganised internally: it now invokes the agent (see `agents/` below) which drives `test_runner.py` — but the user-facing skill, safety rules, results format, and approval gate are unchanged. |

**RETIRED skill (1):**

| Skill | Replacement |
|-------|-------------|
| `generate-functional-spec` (single-fnspec, platform-tagged) | Replaced by `generate-fnspec-platform` + `generate-fnspec-integration`. The native-AI vs API-dependent split cannot be expressed as a single artefact — each fnspec serves a different downstream consumer (platform fnspec drives the implementation prompt; integration fnspec drives the technical spec). |

**NEW platform skills (3):** `platform-pipefy/`, `platform-wrike/`, `platform-ziflow/` — all inside `dydx-delivery/skills/`. Each contains:

```
skills/platform-<name>/
├── SKILL.md                   # name, description, body
└── references/
    ├── api-contract.md        # auth, base URL, rate limits, common ops, error shapes
    ├── native-ai-inventory.md # what's natively buildable (forms, automations,
    │                          #   AI fields, knowledge), what requires API
    ├── knowledge-ingestion.md # direct-API path (if any) + copy-paste fallback
    ├── client-shape-gotchas.md # tier/licence quirks, multi-org pitfalls,
    │                           #   sandbox identifier conventions
    └── vocabulary.md          # construct names — Pipefy "phase" not "stage" etc.
```

What each platform skill must answer (per kickoff):

1. **Native-AI buildable inventory** — forms, AI fields, automations, knowledge bases that can be configured in-platform without code.
2. **API gap inventory** — anything the native UI cannot do that requires the API.
3. **Sandbox access** — conventions for sandbox tenant IDs, environment isolation.
4. **Knowledge ingestion path** — direct API for `push-native-ai-knowledge`, or documented copy-paste fallback.
5. **Client-shape gotchas** — licence-tier limits, multi-org constraints, rate limits, idiosyncratic vocabulary.

**Skill-loading mechanism (UNCHANGED contract):** `platform:` frontmatter on the upstream artefact resolves to `platform-<value>` — already conceptually wired in v0.3.0; v2 makes the targets present in the repo so the references stop dangling.

---

### `commands/` — NEW

**Decision:** add slash commands for high-frequency loops. Slash commands are thin wrappers that pre-fill a skill invocation; they are not a substitute for skills.

**Add (5):**

| Command | Wraps | Purpose |
|---------|-------|---------|
| `/refine-<skill>` | The skill of the same suffix | Bumps artefact to `_v{N+1}` and re-runs the skill with a "what to change" prompt. Already referenced in v0.3.0 docs as future work; v2 ships it. Concretely: `/refine-discovery`, `/refine-sow`, `/refine-fnspec-platform`, `/refine-fnspec-integration`, `/refine-techspec`, `/refine-cost`, `/refine-build-prompt`, `/refine-implementation-prompt`, `/refine-test-plan`, `/refine-uat-plan` — generated mechanically from the skill list. |
| `/gsd-test-bot-run` | `execute-tests` skill via the test-bot agent | One-shot: load test plan, invoke agent, write results. Lower-friction than typing the trigger phrase. |
| `/gsd-publish-docs` | `update-documentation` skill | Triggers diff-then-review-then-publish flow. |
| `/gsd-push-native-ai` | `push-native-ai-knowledge` skill | Triggers per-platform ingestion. |
| `/gsd-archive-cr` | `sign-off-and-archive` skill | Triggers signoff → Coda push → archive move. |

**Why commands exist as a surface:** slash commands are the lowest-friction entry point in Claude Code. Skills require a trigger phrase that sometimes ambiguates. Commands are unambiguous and discoverable in the slash-menu. They are stateless wrappers — all logic stays in the underlying skill.

**Why not put the refine-pattern logic in skills:** keeping refine as a command lets every stage skill stay focused on the forward path; the command supplies the "load latest, increment version, re-run with delta prompt" wrapper once.

---

### `agents/` — NEW

**Decision:** one agent — the **test-bot orchestrator**. Not a skill.

**Pros vs skill:**

- An agent has its own session/context lifecycle — useful for the long-running test run that interleaves Python execution, AI judgement calls, log inspection, and partial-results writes.
- Sub-agents in Claude Code can hold platform credentials and a working directory across many tool calls without polluting the parent skill's context.
- A skill is meant to be invoked, run a finite set of steps, and hand off. The test bot doesn't hand off — it iterates against state until done or aborted.

**Cons vs skill:**

- Agents are heavier ceremony for the marketplace consumer to understand. An agent feels like infrastructure; a skill feels like a tool.
- Cross-platform consistency: if Cowork and Claude Code differ on agent semantics, the agent surface is more fragile than the skill surface. (The kickoff says skills are portable across both seats; agents may not be.)

**Resolution:** keep the **user-facing entry** as the existing `execute-tests` skill (and the new `/gsd-test-bot-run` command). Internally, that skill invokes the agent. Users never call the agent directly. This preserves the skills-only mental model for consumers while letting the agent handle the long-running orchestration internally.

**Agent contract:**

```
agents/
└── test-bot-orchestrator/
    ├── AGENT.md              # behaviour, tools allowed, exit criteria
    └── references/
        ├── safety-rules.md   # → references safety-rules.md from execute-tests
        │                     #   (no duplication; either symlink or relative
        │                     #    pointer in the AGENT.md body)
        └── orchestrator-loop.md  # the AI judgement loop + Python harness contract
```

The agent's job: load `client_state.yaml`, drive `test_runner.py` through the test cases, apply AI judgement on ambiguous results (fuzzy state checks, integration-called inference), write results in real time, return summary.

---

### `hooks/` — NEW

**Decision:** add two hooks — one validation, one safety-net automation. Resist the temptation to add post-stage progression hooks.

**Add (2):**

| Hook | Fires on | Action |
|------|----------|--------|
| `validate-frontmatter` | `PostToolUse` of `Write` / `Edit` to a file matching `**/build-specs/**.md`, `**/test-bot/**.md`, `**/ChangeRequests/**/*.md` | Parses frontmatter; refuses commit-state if required fields for the inferred stage are missing. Surfaces error inline. |
| `bump-artefact-version` | `PreToolUse` of `Write` targeting an existing `*_v{N}.md` file | Prompts: "This file exists. Save as `_v{N+1}.md` instead?" — enforces Option B versioning automatically rather than relying on every skill to remember. |

**Why not auto-progression hooks (e.g. "on `status: approved`, automatically run next skill"):** the kickoff and constraints are explicit — no auto-progression. Humans gate every stage. A hook that auto-runs the next skill would violate the core architectural constraint.

**Why hooks at all:** the v0.3.0 audit found two structural issues that hooks neutralise — frontmatter inconsistencies between templates and SKILL.md instructions (validation hook catches drift), and accidental in-place edits where Option B intended a new version (bump hook catches it). Both are quality-of-life, not load-bearing.

---

## Recommended Project Structure (v2 plugin)

```
dydx-project-workflow/                                    # marketplace root
├── .claude-plugin/
│   └── marketplace.json                                  # UNCHANGED schema; version bump
├── README.md                                             # MODIFIED (rewrite — fix concerns)
└── dydx-delivery/                                        # plugin
    ├── .claude-plugin/
    │   └── plugin.json                                   # MODIFIED (version → 2.0.0)
    ├── README.md                                         # MODIFIED (rewrite — fix concerns)
    ├── references/                                       # NEW (plugin-level shared refs)
    │   ├── safety-rules.md                               # CANONICAL (moved from
    │   │                                                 #   skills/execute-tests/references)
    │   ├── stage-numbering.md                            # NEW canonical reference
    │   ├── frontmatter-scheme.md                         # NEW canonical reference
    │   └── glossary.md                                   # NEW: stage names, status values,
    │                                                     #   identifier prefixes
    ├── skills/
    │   ├── kickoff-capture/                              # NEW (Stage 1)
    │   ├── discovery-intake/                             # MODIFIED (Stage 2)
    │   ├── generate-sow/                                 # MODIFIED (Stage 3)
    │   ├── generate-fnspec-platform/                     # NEW (Stage 4a)
    │   ├── generate-fnspec-integration/                  # NEW (Stage 4b)
    │   ├── generate-technical-spec/                      # MODIFIED (Stage 5, scope-gated)
    │   ├── generate-cost-estimate/                       # NEW (Stage 6)
    │   ├── generate-build-prompt/                        # MODIFIED (Stage 7a)
    │   ├── generate-implementation-prompt/               # NEW (Stage 7b)
    │   ├── provision-test-harness/                       # NEW (Stage 8a)
    │   ├── generate-test-plan/                           # UNCHANGED body, MODIFIED path (Stage 8b)
    │   ├── generate-uat-plan/                            # NEW (Stage 8c)
    │   ├── execute-tests/                                # UNCHANGED user-facing; internally
    │   │                                                 #   invokes test-bot agent (Stage 8d)
    │   ├── update-documentation/                         # NEW (Stage 9)
    │   ├── push-native-ai-knowledge/                     # NEW (Stage 10)
    │   ├── sign-off-and-archive/                         # NEW (Stage 11)
    │   ├── platform-pipefy/                              # NEW (loaded by frontmatter)
    │   ├── platform-wrike/                               # NEW
    │   └── platform-ziflow/                              # NEW
    ├── commands/                                         # NEW
    │   ├── refine.md                                     # /refine-<skill> — single command
    │   │                                                 #   that takes the skill name as arg,
    │   │                                                 #   avoids 10+ separate files
    │   ├── gsd-test-bot-run.md                           # /gsd-test-bot-run
    │   ├── gsd-publish-docs.md                           # /gsd-publish-docs
    │   ├── gsd-push-native-ai.md                         # /gsd-push-native-ai
    │   └── gsd-archive-cr.md                             # /gsd-archive-cr
    ├── agents/                                           # NEW
    │   └── test-bot-orchestrator/
    │       ├── AGENT.md
    │       └── references/
    │           └── orchestrator-loop.md
    └── hooks/                                            # NEW
        ├── validate-frontmatter.md
        └── bump-artefact-version.md
```

### Structure Rationale

- **Plugin-level `references/`:** v0.3.0 had no shared references because nothing was shared. v2 introduces three canonical documents (safety rules, stage numbering, frontmatter scheme) that multiple skills must point at. Putting them at the plugin root prevents the "duplicated four places" pattern flagged in the audit.
- **Single `refine.md` command instead of one-per-skill:** the v0.3.0 docs hint at `/refine-<skill>` as a per-skill family. With 10+ skills that pattern bloats `commands/`. A single command that takes the skill name as an argument is cleaner and reads the artefact path generically.
- **`platform-*` skills inside `skills/`:** they are siblings to stage skills, not a separate directory. The `platform:` frontmatter resolution rule already assumes this (`platform: pipefy` → `skills/platform-pipefy/`).
- **`test-bot-orchestrator/AGENT.md` parallels `SKILL.md` shape:** keeps the mental model consistent — skills and agents are both folders with a single instruction file plus references.
- **Hooks as `.md` instructions:** Claude Code hooks are markdown configurations describing when to fire and what to enforce; no Python/JS for these two hooks.

---

## Architectural Patterns

### Pattern 1: Plugin-level canonical reference (single source of truth)

**What:** A single canonical file at `dydx-delivery/references/<topic>.md`. Skills point at it instead of duplicating its content.

**When to use:** any rule, vocabulary, or scheme referenced by 2+ skills (safety rules, frontmatter scheme, stage numbering, glossary).

**Trade-offs:** consumers reading a single SKILL.md must follow a pointer to understand a hard rule — slightly worse for self-containment. Mitigation: SKILL.md inlines a one-line summary plus a pointer ("Hard rules apply — see `../../references/safety-rules.md` for the full list").

**Example skill body fragment:**

```markdown
## Hard rules — enforced regardless of test plan content

> Sandbox-only, no deletes, no destructive integrations, audit trail.
> The full and authoritative list is in `../../references/safety-rules.md`.
> If you are reading this skill body and the canonical file disagrees,
> the canonical file wins.
```

**Why this pattern not "just inline everywhere":** the v0.3.0 audit found four near-identical copies of the safety-rules block — three of them disagreed on rule count and wording. Centralisation is the only structural fix.

### Pattern 2: Stage skill as a "pipe stage"

**What:** Every stage skill follows the same shape (Locate upstream → Triage if missing → Check existing output → Draft from template → Senior-level challenge → Write with frontmatter → Handoff message naming next skill). v2 keeps this UNCHANGED.

**When to use:** every stage skill in the 10-stage lifecycle.

**Trade-offs:** rigid shape feels constraining; consumers want to skip steps. Mitigation: the triage block already supports "paste an existing artefact and continue" — start-at-any-point is built in.

**Why preserve:** v0.3.0 already validated this shape across 7 skills; keeping it for v2 means the new 6 skills inherit a working contract instead of inventing one.

### Pattern 3: Frontmatter-as-contract for stage hand-off

**What:** Every artefact carries YAML frontmatter with required fields (`client`, `platform`, `version`, `status`, `based_on_*`). The next stage skill validates these before drafting.

**When to use:** every artefact written by every skill.

**Trade-offs:** adds ceremony to every file. Mitigation: frontmatter is already universal in v0.3.0; v2 only **resolves inconsistencies** (see Frontmatter Scheme section).

### Pattern 4: Highest-version read

**What:** A stage skill reading its upstream artefact always picks the highest `_vN.md` it finds. Iteration writes new versions as siblings.

**When to use:** every stage skill that has an upstream artefact.

**Trade-offs:** disk grows. Mitigation: `Archive/` move at signoff collapses old versions into a single archived CR.

### Pattern 5: Agent invoked from skill, not from user (v2 NEW pattern)

**What:** The test-bot agent is never called directly by the user. The user invokes `execute-tests` (skill) or `/gsd-test-bot-run` (command); the skill dispatches to the agent.

**When to use:** any long-running, stateful workflow that needs an agent loop. Right now this is only the test bot.

**Trade-offs:** users can't tune agent behaviour without going through the skill. Mitigation: the agent's loop document (`agents/test-bot-orchestrator/references/orchestrator-loop.md`) is referenced from the skill so behaviour is auditable.

### Pattern 6: Per-client persistent harness with delta-update semantics (v2 NEW pattern)

**What:** `<Client> Brain/test-bot/` is bootstrapped once via `provision-test-harness` and **updated** on every subsequent ship — never recreated. State (sandbox identifiers, fixture seed data, baseline test cases, integration toggles) lives in `client_state.yaml`. Code (`test_runner.py`) is regenerated when its inputs change. Test cases (`test_cases/`) accumulate; new cases are added per-CR, never deleted.

**When to use:** anything where deterministic state checks across multiple ships matter — e.g. "every Up & Up release re-runs the regression bot, which already knows the client's sandbox tenants and fixture seeds".

**Delta semantics:**

```
NEW ship arrives → provision-test-harness skill runs:
  1. Load existing <Client> Brain/test-bot/client_state.yaml
  2. Compute delta: new sandbox IDs? new integrations? changed fixtures?
  3. Append new test cases to test_cases/ (new file, new TC-IDs)
  4. Update client_state.yaml in place (versioned via git history, not _vN suffix)
  5. Regenerate test_runner.py if and only if its template inputs changed
  6. Never delete or rename existing test cases
```

**State model:**

| Element | Persisted | Regenerated each ship | Versioned |
|---------|-----------|----------------------|-----------|
| `client_state.yaml` (sandbox IDs, fixtures, integration toggles) | Yes | No (only updated on delta) | git history |
| `test_runner.py` (Python orchestrator code) | Yes | Yes if template-inputs changed | git history |
| `test_cases/<feature>/test-plan_v{N}.md` | Yes | Per-CR, additive | Option B `_vN` |
| `test_cases/<feature>/uat_plan_v{N}.md` | Yes | Per-CR, additive | Option B `_vN` |
| `test_cases/<feature>/results-YYYY-MM-DD_v{N}.md` | Yes | Each run writes a new file | Date + Option B `_vN` |
| Sandbox credentials | Never in repo — env var names listed in `client_state.yaml` only | n/a | n/a |

**Why this pattern:** kickoff explicitly says the bot is updated each ship, never recreated. Computing delta against `client_state.yaml` instead of regenerating from scratch preserves accumulated test history (results files survive) and stable TC-IDs across releases.

**Sandbox guardrail propagation:** the agent's `references/safety-rules.md` is **the same file** as the skills' canonical (Pattern 1). `provision-test-harness` writes the sandbox identifiers into `client_state.yaml`; `test_runner.py` reads them; the agent enforces them per the existing 10 hard rules from `references/safety-rules.md`. No new safety code path.

### Pattern 7: Drive-canonical published docs, local-canonical drafts

**What:** Working `.md` drafts live in `ChangeRequests/<CR>/`. Published documentation lives in Google Drive Docs. Local-to-Drive mapping is deterministic — same folder shape, same file titles. Doc updates flow local → Drive only after diff review.

**Mapping rule:**

```
<Client> Brain/<Spoke>/<Subspoke>/<doc-name>.md   (local Markdown draft)
                            ↓
<Client> Drive/<Spoke>/<Subspoke>/<doc-name>      (Google Doc)
```

**`Documentation:` link:** lives in `<Client> Brain/00_HUB.md` frontmatter:

```yaml
---
client: <Client>
documentation: https://drive.google.com/drive/folders/<id>
coda_brain_doc: <coda doc id>
test_bot_root: ./test-bot/
---
```

**Diff-and-review surface:** `update-documentation` skill writes `ChangeRequests/<CR>/doc-diff.md` showing each proposed Drive change as a side-by-side block. Reviewer approves; skill applies via Drive MCP.

**`00_Index.md`:** canonical in Drive (Drive doc, not markdown). Local snapshot regenerated by `update-documentation` on each push so reviewers can read it locally; the snapshot is **not** the source of truth and is excluded from `sign-off-and-archive`'s Coda push.

**Halt condition:** if `00_HUB.md` frontmatter lacks `documentation:`, `update-documentation` halts and surfaces the gap. The rest of the pipeline still runs.

### Pattern 8: One-way local→Coda mirror with Field Notes triage queue

**What:** Local `<Client> Brain/` is canonical. Coda is a published mirror. Field Notes table in Coda is the **input** queue (clients/PMs add notes between engagements). At next kickoff, `kickoff-capture` reads the Field Notes table and queues unprocessed entries.

**Coda doc IDs:** stored in `<Client> Brain/00_HUB.md` frontmatter (`coda_brain_doc: <id>`). Per-client. One Coda doc per client; the doc has section per Brain spoke.

**Brain-mirror Coda doc template:**

```
<Client> Brain (Coda doc)
├── Overview                  (mirrors <Client> Brain/00_HUB.md narrative)
├── Workflows                 (mirrors <Client> Brain/Workflows/)
├── Platforms                 (mirrors <Client> Brain/Platforms/)
├── Integrations              (mirrors <Client> Brain/Integrations/)
├── Operating Model           (mirrors <Client> Brain/OperatingModel/)
├── Change History            (timeline of CRs from ChangeRequests/Archive/)
└── Field Notes (table)       (READ-ONLY surface for the plugin —
                               clients/PMs write here between engagements;
                               kickoff-capture reads the table at next kickoff)
```

**Read-from-Coda surface:** **only the Field Notes table**. The plugin never reads brain content from Coda (which would create a two-way sync risk).

### Pattern 9: Schema-mapped Coda task table (Stage 6)

**What:** `generate-cost-estimate` first reads the existing client task table in Coda (column names, type, dropdown values), then writes new rows that match. Avoids the "every client has different columns" problem.

**Schema-map step:**

```
1. Coda MCP read: list tables in <Client> task doc
2. Identify task table by name (configurable in 00_HUB.md frontmatter:
   coda_tasks_table: <table-id>)
3. Introspect columns: { name, type, options }
4. Map cost-estimate fields → existing columns:
   - assignee → first column matching {People|Lookup, name~"assignee|owner"}
   - hours → first numeric column matching name~"hours|estimate"
   - risk-adjusted hours → next numeric column matching name~"adjusted|risk"
   - description → first text column
5. Surface unmapped fields to user; ask "create new column or skip?"
6. Write rows; record row IDs in 06_cost-estimate_v{N}.md frontmatter
   for change tracking
```

**Trade-offs:** introspection cost on every cost-estimate run. Mitigation: cache schema in `<Client> Brain/00_HUB.md` frontmatter under `coda_tasks_schema:` and refresh only when introspection mismatches the cache.

---

## Data Flow

### End-to-end pipeline (v2)

```
[Stage 1 — kickoff-capture]
   reads:  Miro MCP, pasted notes, Coda Field Notes table (via 00_HUB.md)
   writes: ChangeRequests/<CR>/01_kickoff_v1.md
              ↓
[Stage 2 — discovery-intake]
   reads:  01_kickoff_v*
   writes: ChangeRequests/<CR>/02_discovery_v1.md
              ↓
[Stage 3 — generate-sow]
   reads:  02_discovery_v*
   writes: ChangeRequests/<CR>/03_sow_v1.md
              ↓
[Stage 4a — generate-fnspec-platform]
   reads:  03_sow_v*, platform-<x> skill
   writes: ChangeRequests/<CR>/04a_fnspec-platform_v1.md
              ↓
[Stage 4b — generate-fnspec-integration]   (only if integration work exists)
   reads:  03_sow_v*, 04a_fnspec-platform_v*
   writes: ChangeRequests/<CR>/04b_fnspec-integration_v1.md
              ↓
[Stage 5 — generate-technical-spec]    (scope-gated — only if 04b emitted)
   reads:  04a, 04b, platform-<x> skill
   writes: ChangeRequests/<CR>/05_techspec_v1.md
              ↓                                        platform-only path:
              ↓                                          adds platform-API addendum
              ↓                                          to 04a_fnspec-platform_v{N+1}.md
              ↓
[Stage 6 — generate-cost-estimate]
   reads:  04a, 04b (if), 05 (if), Coda MCP (existing client task schema)
   writes: ChangeRequests/<CR>/06_cost-estimate_v1.md + Coda task rows
              ↓
[Stage 7a — generate-build-prompt]      (dev path)
   reads:  04b, 05, 08b test plan (if), platform-<x> skill
   writes: ChangeRequests/<CR>/07a_build-prompt_v1.md  (dev paste-in)
              ↓
[Stage 7b — generate-implementation-prompt]   (non-dev path)
   reads:  04a, platform-<x> skill
   writes: ChangeRequests/<CR>/07b_implementation-prompt_v1.md
              ↓
              ↓ (build executes — Claude Code or client admin in-platform)
              ↓
[Stage 8a — provision-test-harness]    (first time per client)
   reads:  05 (or 04a addendum), <Client> Brain/test-bot/ (if exists)
   writes: <Client> Brain/test-bot/{client_state.yaml, test_runner.py, test_cases/}
              ↓
[Stage 8b — generate-test-plan]
   reads:  04a, 04b, 05 (if), client_state.yaml
   writes: <Client> Brain/test-bot/test_cases/<feature>/test-plan_v1.md
              ↓
[Stage 8c — generate-uat-plan]
   reads:  04a, 04b, 05 (if)
   writes: <Client> Brain/test-bot/test_cases/<feature>/uat_plan_v1.md
              ↓
[Stage 8d — execute-tests]   (skill, internally invokes test-bot-orchestrator agent)
   reads:  test-plan_v* (status: approved), client_state.yaml, safety-rules.md
   writes: <Client> Brain/test-bot/test_cases/<feature>/results-YYYY-MM-DD_v1.md
              ↓
[Stage 9 — update-documentation]
   reads:  shipped CR artefacts, current Drive doc tree, 00_HUB.md (Documentation: link)
   writes: ChangeRequests/<CR>/doc-diff.md  → reviewer approval  → Drive MCP push
              ↓
[Stage 10 — push-native-ai-knowledge]
   reads:  04a, doc-diff approved fragments, platform-<x>/native-ai-inventory.md
   writes: native-AI knowledge base via API (or copy-paste fallback per platform)
              ↓
[Stage 11 — sign-off-and-archive]
   reads:  approved CR
   writes: <Client> Brain/<spokes>/*.md          (local brain update, canonical)
           Coda mirror push                       (one-way, via Coda MCP)
           ChangeRequests/Archive/<CR>/           (move from active)
              ↓
[next ship]
   kickoff-capture reads Coda Field Notes table for new triage entries → loops
```

### Hand-off contracts (what carries forward)

| From → To | Carrier | Mechanism |
|-----------|---------|-----------|
| Stage 1 → 2 | `01_kickoff_v*.md` | Frontmatter `client`, `platform`, `cr_slug`. `discovery-intake` reads kickoff body for branched-discovery starters. |
| Stage 2 → 3 | `02_discovery_v*.md` | Frontmatter `based_on_kickoff: 01_kickoff_v{N}.md` |
| Stage 3 → 4a/4b | `03_sow_v*.md` | Frontmatter `based_on_discovery`. Stage 4b decision driven by SOW body field "integrations:" — if non-empty, 4b is required. |
| Stage 4a → 5 | `04a_fnspec-platform_v*.md` | Frontmatter `based_on_sow`. Stage 5 scope gate: if `04b_fnspec-integration_v*` exists, 5 runs full; else 5 emits a platform-API addendum appended to `04a` and increments its version. |
| Stage 5 → 6, 7a | `05_techspec_v*.md` | Frontmatter `based_on_fnspec_platform`, `based_on_fnspec_integration` |
| Stage 6 → (no downstream skill) | `06_cost-estimate_v*.md` + Coda row IDs | Coda row IDs recorded in cost-estimate frontmatter for traceability |
| Stage 7a/b → build (external) | Build prompt body | Build report (`*_report.md`) written back to CR by Claude Code |
| Stage 8a → 8b/c/d | `<Client> Brain/test-bot/client_state.yaml` | Sandbox IDs, fixture refs, integration toggles |
| Stage 8b → 8d | `test-plan_v*.md` | Frontmatter `status: approved` required |
| Stage 8d → 9 | `results-YYYY-MM-DD_v*.md` | Verdict (`GREEN`/`YELLOW`/`RED`) gates whether 9 runs |
| Stage 9 → 10 | Approved doc-diff fragments | `doc-diff.md` `status: approved` |
| Stage 10 → 11 | Native-AI ingestion log | Log line in CR confirming each platform's KB updated |
| Stage 11 → next-ship's Stage 1 | Coda Field Notes table | One-way push from local brain; clients write into Field Notes between engagements |

### Frontmatter Scheme — Canonical (resolves v0.3.0 inconsistencies)

**Status lifecycle (canonical):** `draft → client_review → approved → archived`.

- `archived` is NEW for v2 — set by `sign-off-and-archive` when the CR moves to `Archive/`.
- Every artefact's `status:` MUST be one of these four values. Any other value is invalid.
- `execute-tests` requires `status: approved` on the test plan; other gates are advisory.

**`based_on_*` field naming (canonical — UNDERSCORE):**

```yaml
based_on_kickoff:           01_kickoff_v{N}.md
based_on_discovery:         02_discovery_v{N}.md
based_on_sow:               03_sow_v{N}.md
based_on_fnspec_platform:   04a_fnspec-platform_v{N}.md
based_on_fnspec_integration: 04b_fnspec-integration_v{N}.md
based_on_technical_spec:    05_techspec_v{N}.md          # underscore in field; hyphen in path
based_on_cost_estimate:     06_cost-estimate_v{N}.md
based_on_build_prompt:      07a_build-prompt_v{N}.md
based_on_test_plan:         test-plan_v{N}.md
based_on_uat_plan:          uat_plan_v{N}.md
```

Resolution: **field names use underscore-snake-case**. **File paths use hyphen-kebab-case**. The two are independent and the mismatch in v0.3.0 (`based_on_technical_spec` referencing `03_technical-spec_v*.md`) is **correct** under this rule and stays.

**Platform-gated identifiers:**

```yaml
# Always present
client: <Client>
platform: <pipefy | wrike | ziflow | other>
integrations: [<...>]
version: <int>
status: <draft | client_review | approved | archived>
created_date: <YYYY-MM-DD>
version_date: <YYYY-MM-DD>

# Stage-specific carriers (entry stage only writes captured_by/captured_at;
# every downstream stage writes one or more based_on_* fields)
captured_by: <user>
captured_at: <YYYY-MM-DD>

# Only on test-plan and results
sandbox:
  pipe_id:    <id>     # ONLY when platform: pipefy
  space_id:   <id>     # ONLY when platform: wrike
  project_id: <id>     # ONLY when platform: ziflow
  tenant:     <name>   # always present
```

**Resolution of v0.3.0 sandbox bug:** `pipe_id` and `space_id` only appear when their platform is active. v0.3.0 unconditionally listed both regardless of `platform:`; v2 makes them platform-gated. The `validate-frontmatter` hook enforces this.

**Versioning fields (NEW per kickoff):** `version`, `version_date` (date this version written), `created_date` (date the CR opened — same across all artefacts for the CR). Distinct from artefact filename `_vN`: filename version is the iteration counter; frontmatter `version` is the integer of the same.

### Stage-numbering Scheme — Canonical (resolves the v0.3.0 dual-scheme bug)

**Single canonical scheme — file prefix IS the stage number; one-to-one with the lifecycle stage:**

| Stage | File prefix | Skill | Stage label in template body |
|-------|-------------|-------|------------------------------|
| 1 | `01_kickoff_` | `kickoff-capture` | "Stage 1 of the dydx-delivery pipeline" |
| 2 | `02_discovery_` | `discovery-intake` | "Stage 2" |
| 3 | `03_sow_` | `generate-sow` | "Stage 3" |
| 4a | `04a_fnspec-platform_` | `generate-fnspec-platform` | "Stage 4a" |
| 4b | `04b_fnspec-integration_` | `generate-fnspec-integration` | "Stage 4b" |
| 5 | `05_techspec_` | `generate-technical-spec` | "Stage 5" |
| 6 | `06_cost-estimate_` | `generate-cost-estimate` | "Stage 6" |
| 7a | `07a_build-prompt_` | `generate-build-prompt` | "Stage 7a" |
| 7b | `07b_implementation-prompt_` | `generate-implementation-prompt` | "Stage 7b" |
| 8a | (no artefact — provisions a directory) | `provision-test-harness` | "Stage 8a" |
| 8b | `test-plan_` (in `<Client> Brain/test-bot/test_cases/`) | `generate-test-plan` | "Stage 8b" |
| 8c | `uat_plan_` (in `<Client> Brain/test-bot/test_cases/`) | `generate-uat-plan` | "Stage 8c" |
| 8d | `results-YYYY-MM-DD_` | `execute-tests` | "Stage 8d" |
| 9 | `doc-diff.md` (single per CR, not versioned by `_vN`) | `update-documentation` | "Stage 9" |
| 10 | (log line in CR — `09_native-ai-push.log`) | `push-native-ai-knowledge` | "Stage 10" |
| 11 | (CR move + Coda push — no new artefact) | `sign-off-and-archive` | "Stage 11" |

**Stages run 1–11 inclusive.** No Stage 0. Counted from 1, including 4a/4b/7a/7b/8a/8b/8c/8d as substages.

**Mapping from old (v0.3.0) → new (v2):**

| Old prefix | Old skill | New prefix | New skill |
|------------|-----------|------------|-----------|
| `00_discovery_` | `discovery-intake` | `02_discovery_` | `discovery-intake` (Stage 2) |
| `01_sow_` | `generate-sow` | `03_sow_` | `generate-sow` (Stage 3) |
| `02_functional-spec_` | `generate-functional-spec` | `04a_fnspec-platform_` + `04b_fnspec-integration_` | split into two new skills |
| `03_technical-spec_` | `generate-technical-spec` | `05_techspec_` | `generate-technical-spec` (Stage 5) |
| `04_build-prompt_` | `generate-build-prompt` | `07a_build-prompt_` | `generate-build-prompt` (Stage 7a) |
| `test-plan_` | `generate-test-plan` | `test-plan_` (path moves to `<Client> Brain/test-bot/test_cases/`) | unchanged body (Stage 8b) |
| `results-YYYY-MM-DD_` | `execute-tests` | `results-YYYY-MM-DD_` (path moves) | unchanged user-facing (Stage 8d) |

**Where the canonical scheme lives:** `dydx-delivery/references/stage-numbering.md`. Skills MUST quote it ("see `../../references/stage-numbering.md`") rather than re-list. Templates put `> Stage N of the dydx-delivery pipeline.` at the top of the body using the value from the canonical doc.

---

## Scaling Considerations

| Scale | Architecture Adjustments |
|-------|--------------------------|
| 1 client, 1 active CR | All v2 patterns work as-is. Single client folder, single test-bot. |
| 5 clients, 5 active CRs in parallel | Each client has its own `<Client> Brain/test-bot/`. No cross-client coupling. The plugin handles arbitrarily many clients because nothing in the plugin caches client state — every skill resolves the client folder per-invocation. |
| 20+ clients, multiple CRs each, multiple ships per quarter per client | First bottleneck is **Coda MCP rate limits** during Stage 6 schema introspection and Stage 11 brain-mirror push. Mitigation: cache Coda task-table schema in `00_HUB.md` (Pattern 9), batch Stage 11 push into a single Coda transaction per CR. Second bottleneck is **Drive MCP** during Stage 9 — same mitigation pattern (batch). |
| 100+ clients (hypothetical) | Plugin still scales because it's stateless, but human review capacity becomes the constraint, not the plugin. At this scale the question is "should the plugin become an automated middle layer with audit logs", not "should the plugin's architecture change". |

### Scaling Priorities

1. **First bottleneck:** human review throughput. Every stage requires a human gate; with 20+ active CRs at once, reviewer attention becomes the constraint. Mitigation: `/refine-<skill>` pattern lowers the cost of iteration so reviewers spend less time on "this isn't quite right, redo from start".
2. **Second bottleneck:** Coda MCP for Stage 6 + Stage 11. Both require reads (Stage 6 introspection) and writes (Stage 11 mirror) per CR. Mitigation: schema caching, batched writes.
3. **Third bottleneck:** test-bot run duration if `client_state.yaml` accumulates large fixture seed data. Mitigation: archive old fixtures from `client_state.yaml` after N ships; runner can refresh from sandbox.

---

## Anti-Patterns

### Anti-Pattern 1: Auto-progressing stages on `status: approved`

**What people do:** wire a hook that detects `status: approved` and fires the next skill automatically.

**Why it's wrong:** the kickoff and constraints are explicit — humans gate every stage. A hook bypassing this violates the audit trail and the "no auto-progression" architectural constraint.

**Do this instead:** the human runs the next skill (or types the slash command). Hooks are limited to validation and Option B versioning enforcement.

### Anti-Pattern 2: Two-way sync between local Brain and Coda

**What people do:** "improve" the Coda mirror by syncing reviewer edits in Coda back into local files.

**Why it's wrong:** the architecture is **explicitly** one-way. Two-way sync invites merge conflicts and undermines the local-canonical contract. Field Notes is the controlled exception (read-only triage queue, never auto-merged).

**Do this instead:** if a reviewer edits in Coda, they must paste their edit into the local file. Coda is a viewing layer, not an editing layer.

### Anti-Pattern 3: Recreating the test-bot on each ship

**What people do:** "the easiest way to get a clean test bot is to delete `<Client> Brain/test-bot/` and re-provision."

**Why it's wrong:** destroys accumulated TC-IDs, results history, fixture seed state. Every prior ship's test results become orphaned.

**Do this instead:** `provision-test-harness` always runs in update-or-create mode. It computes delta against `client_state.yaml` and adds; it never deletes. If a test case is obsolete, mark it so in the test plan but do not remove the row.

### Anti-Pattern 4: Inlining hard rules in every skill

**What people do:** copy the safety-rules block into every SKILL.md "for self-containment".

**Why it's wrong:** v0.3.0 audit found four near-identical copies that **already disagreed**. Self-containment loses to drift every time.

**Do this instead:** one canonical file at `dydx-delivery/references/safety-rules.md`. SKILL.md inlines a one-line summary plus a pointer.

### Anti-Pattern 5: Putting platform-specific identifiers in shared frontmatter

**What people do:** every test plan carries both `pipe_id` and `space_id` regardless of platform "so the schema is uniform".

**Why it's wrong:** `pipe_id` is meaningless for Wrike, `space_id` is meaningless for Pipefy. Carrying both invites accidentally populating the wrong one. v0.3.0 audit found this exact issue.

**Do this instead:** gate by `platform:` value. The `validate-frontmatter` hook refuses an artefact that lists `pipe_id` when `platform: wrike`.

### Anti-Pattern 6: Splitting fnspec by platform vs integration along feature lines

**What people do:** "Feature A is platform, Feature B is integration, so I'll put A in fnspec-platform and B in fnspec-integration."

**Why it's wrong:** the split is by **buildable surface** (native-AI vs API) not by feature. A single feature usually has both — the form lives in fnspec-platform, the integration that fires when the form is submitted lives in fnspec-integration. The two fnspecs are layered, not partitioned.

**Do this instead:** for each feature, decompose into "what is buildable in-platform with native AI" (goes to 04a) and "what crosses platforms or requires API code" (goes to 04b). Cross-reference between them with shared BR/EC/AC IDs.

### Anti-Pattern 7: Letting per-stage version numbers diverge

**What people do:** SKILL.md says "Stage 3" but the file prefix is `01_sow_` and the template body says "Stage 1".

**Why it's wrong:** v0.3.0 audit found exactly this — three numbering schemes that didn't agree. Consumers can't tell which is canonical.

**Do this instead:** stage number = file prefix = template-body stage label = single canonical doc at `references/stage-numbering.md`. The audit doc and the new docs disagree → the canonical doc wins; both surfaces update.

---

## Integration Points

### External Services

| Service | Integration Pattern | Notes |
|---------|---------------------|-------|
| Miro MCP | Read-only at Stage 1 (kickoff capture) | Optional — kickoff also accepts pasted notes |
| Coda MCP | Read at Stage 6 (task schema introspection) + Stage 1 (Field Notes triage); write at Stage 6 (task rows) + Stage 11 (brain mirror) | Required for Stage 6 and 11; design fails gracefully if MCP missing — surfaces gap and pauses |
| Google Drive MCP | Read at Stage 9 (current doc tree); write at Stage 9 (publish approved diff) | Required for Stage 9; if missing, Stage 9 halts and surfaces |
| Gmail MCP | Read-only at Stage 1 (kickoff context) and Stage 11 (signoff confirmations) | Optional |
| Calendar MCP | Read-only at Stage 1 (recent meeting notes) | Optional |
| Claude in Chrome | Stage 10 fallback for native-AI ingestion when API path doesn't exist | Optional per platform — see `platform-<x>/references/knowledge-ingestion.md` |
| Pipefy GraphQL API | Stage 8d (test runs), Stage 10 (knowledge push if available) | Auth via env var; per `platform-pipefy` |
| Wrike REST API | Same | Per `platform-wrike` |
| Ziflow API | Same | Per `platform-ziflow` |

### Internal Boundaries

| Boundary | Communication | Notes |
|----------|---------------|-------|
| Skill ↔ skill | Frontmatter on artefact (no direct call) | Highest-version read; `based_on_*` chain of custody |
| Skill ↔ platform skill | Dynamic load by `platform:` frontmatter value | Resolves to `skills/platform-<value>/SKILL.md` |
| Skill ↔ test-bot agent | `execute-tests` skill → `agents/test-bot-orchestrator/AGENT.md` | Skill is the only invoker; users do not call agent directly |
| Skill ↔ canonical references | Markdown pointer (`see ../../references/<file>.md`) | One-way; skills read references, never write |
| Hook ↔ skill | `validate-frontmatter` runs on file write events; `bump-artefact-version` runs on write to existing `_vN.md` | Hooks do not call skills |
| Plugin ↔ client workspace | File system reads/writes to `<Client> Brain/...` and `<Client>/ChangeRequests/...` | Plugin holds no state about clients between invocations |
| Plugin ↔ Coda | MCP at well-defined stages (6, 11) reading/writing well-defined tables | One-way out for brain mirror; bidirectional for tasks; read-only for Field Notes |
| Plugin ↔ Drive | MCP at Stage 9 only | One-way out (publish) after diff review |

---

## Build Order Recommendation

Architecture decisions impose dependencies on the v2 build phases:

1. **Phase A — Foundations (resolves v0.3.0 structural debt + scaffolds new surfaces).**
   - Single canonical references (`safety-rules.md`, `stage-numbering.md`, `frontmatter-scheme.md`, `glossary.md`) at `dydx-delivery/references/`.
   - Existing 7 skills updated to point at canonical references (collapse the four duplicate copies, fix sandbox-block bug, normalise `based_on_*` field names, normalise stage labels).
   - Renumber existing files to the canonical scheme (00→02, 01→03, 02→04, 03→05, 04→07a).
   - Scaffold (empty) `commands/`, `agents/`, `hooks/` directories.
   - **Why first:** every later phase depends on these references existing and being authoritative. Renumbering after adding new skills is more painful than renumbering before.

2. **Phase B — Internalise platform skills (`platform-pipefy`, `platform-wrike`, `platform-ziflow`).**
   - These unblock every later phase that calls a platform skill (the existing v0.3.0 skills already reference them; today the references dangle).
   - **Why second:** Stage 5 tech spec rework (Phase D) and the new fnspec split (Phase C) both load platform skills. Without internalised platform skills, the dangling references stay broken and the new skills inherit the broken contract.

3. **Phase C — Stage 1 + Stage 4 split (kickoff-capture, fnspec-platform, fnspec-integration).**
   - Kickoff is the new entry; discovery-intake updates to consume kickoff artefact.
   - Fnspec split retires `generate-functional-spec` and replaces it with the two new skills.
   - **Why third:** these are the two largest "shape changes" to the existing pipeline. Deferring them means later phases inherit the broken single-fnspec contract.

4. **Phase D — Tech spec scope-gate, Stage 6 cost-estimate, Stage 7b implementation prompt.**
   - Tech spec becomes scope-gated against fnspec-integration existence.
   - Cost estimate adds Coda integration (depends on Coda MCP being verified).
   - Implementation prompt is a sibling of the existing build prompt.

5. **Phase E — Test bot rebuild (Stage 8a/8b/8c/8d + agent + provision skill).**
   - Self-contained: depends only on `<Client> Brain/test-bot/` shape and the existing `execute-tests` safety contract.
   - The agent is added here.
   - **Why this late:** the test bot needs the new fnspec-platform + fnspec-integration to derive test cases properly. Building it before Phase C means rebuilding it again to handle the split.

6. **Phase F — Documentation publishing (Stage 9 update-documentation + diff/review surface).**
   - Drive MCP integration.
   - Depends on shipped CRs to diff against.

7. **Phase G — Native-AI knowledge push (Stage 10 push-native-ai-knowledge).**
   - Per-platform path; depends on platform skills (Phase B) and approved doc fragments (Phase F).

8. **Phase H — Sign-off, brain update, archive (Stage 11) + Coda mirror.**
   - Depends on Coda MCP verification and stable brain shape.
   - Closes the loop: next ship's kickoff reads Field Notes table populated since the last archive.

9. **Phase I — Surfaces (commands/, agents/ wrapping, hooks/).**
   - `/refine-*` family, `/gsd-test-bot-run`, `/gsd-publish-docs`, `/gsd-push-native-ai`, `/gsd-archive-cr`.
   - `validate-frontmatter` and `bump-artefact-version` hooks.
   - **Why last:** these are quality-of-life on top of fully-shipped skills. Building them before the underlying skills means rewriting them as the skills shift.

**Critical dependencies the build order resolves:**

- Phase B (platform skills internalisation) must happen before any phase that loads them (C, D, E, G).
- Phase A (foundations) must happen before B (because platform skills also point at canonical references).
- Phase C (fnspec split) must happen before E (test bot derives cases from fnspecs) and D (tech spec reads fnspec-integration).
- Phase H (Coda mirror) depends on Coda MCP verification — flag this as a hard prerequisite for Phase D and H both.

---

## Sources

- `.planning/PROJECT.md` — v2.0 milestone scope, validated v0.3.0 baseline, constraints, key decisions (HIGH confidence — canonical project doc).
- `.planning/codebase/ARCHITECTURE.md` — v0.3.0 system overview, component responsibilities, pattern overview, data flow, constraints, anti-patterns (HIGH confidence — repo audit).
- `.planning/codebase/STRUCTURE.md` — directory layout, naming conventions, frontmatter fields, identifier patterns (HIGH confidence — repo audit).
- `.planning/codebase/CONVENTIONS.md` — markdown shape, SKILL.md body structure, triage block, handoff message, status vocabulary (HIGH confidence — repo audit).
- `.planning/codebase/CONCERNS.md` — version mismatches, missing skills referenced in docs, frontmatter inconsistencies, duplicated hard-rules, two-scheme stage numbering (HIGH confidence — repo audit; v2 architecture explicitly resolves these).
- `dydx-delivery/README.md` — pipeline diagram, skill table, file conventions, safety-rules summary (HIGH confidence — current shipped doc).
- `dydx-delivery/skills/discovery-intake/SKILL.md`, `generate-functional-spec/SKILL.md`, `generate-build-prompt/SKILL.md`, `generate-test-plan/SKILL.md`, `execute-tests/SKILL.md`, `execute-tests/references/safety-rules.md` — current skill bodies and contracts (HIGH confidence — repo source).
- Claude Code plugin surface conventions (`commands/`, `agents/`, `hooks/`) — knowledge from project context kickoff prompt (MEDIUM confidence — not verified against external docs in this session; conventions named align with what's used elsewhere in this repo's tooling like `.planning/`).

---

*Architecture research for: dydx-delivery v2.0 "Implementor Edition" rebuild on top of v0.3.0*
*Researched: 2026-05-09*
