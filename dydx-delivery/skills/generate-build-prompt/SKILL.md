---
name: generate-build-prompt
description: Generate a Claude Code build prompt from an approved Technical Specification. Use when the user says "generate build prompt", "create the Claude Code prompt", "produce the build brief", "draft the prompt for Claude Code", or asks for a build-ready instruction set after the tech spec is signed off. Reads the highest-version technical spec, loads the matching platform skill for vocabulary, and produces a contextually rich prompt the team will paste into a fresh Claude Code session to execute the build.
---

# generate-build-prompt

Translate an approved technical spec into a Claude-Code-ready build prompt. The team produces this in Cowork (with full context loaded) and switches to Claude Code to execute. Cowork is for thinking and planning; Claude Code is for building.

## Inputs

- The latest `<Client>/build-specs/<platform>/05_techspec_v*.md` (required, must be `status: approved` for production builds)
- The latest `<Client>/testing/<feature>/08b_test-plan_v*.md` if generated — referenced in the prompt so the build self-checks against it
- Functional spec + SOW for context

## Output

`<Client>/build-specs/<platform>/07a_build-prompt-dev_vN.md`

## How to run

### Step 1 — Locate upstream artefacts

Find the highest-version `05_techspec_v*.md`. Pull the latest test plan if it exists.

**If technical spec not found**, run start-at-any-point triage:

> I don't see a technical spec for `<Client>` at `<expected path>`. How do you want to proceed?
>
> **(a) Paste an existing technical spec** — I'll save it as `05_techspec_v1.md`
> **(b) Walk through the implementation plan inline** — I'll capture enough to draft a build prompt, stub the technical spec
> **(c) Cancel**

### Step 2 — Determine what's being built

Read the technical spec and identify the build scope. Most engagements split into one or both of:

| Build component | Examples | Where Claude Code runs |
|---|---|---|
| **Platform configuration** | Pipefy pipes/automations, Wrike blueprints, Workato recipes, Ziflow setup | Claude Code with platform skill loaded + API credentials in env |
| **Custom code** | FastAPI endpoints, Supabase functions, integration scripts, custom apps, webhooks | Claude Code in the target repo |

Both components produce a Claude Code prompt. They can be combined into one build-prompt artefact (with two sections) or split into siblings (`04a_build-prompt-config.md`, `04b_build-prompt-code.md`) — ask the user if unclear.

### Step 3 — Load the platform skill

Based on `platform:` frontmatter, load `platform-pipefy`, `platform-wrike`, etc. The platform skill provides:

- Construct vocabulary the prompt should use verbatim
- API operation patterns Claude Code will execute
- Tier / licence requirements

Reference the platform skill explicitly in the prompt so Claude Code loads it on the other side.

### Step 4 — Check for existing build prompt

Look for `07a_build-prompt-dev_v*.md`. If found, ask whether to revise (`_v{N+1}`), extend, or start fresh.

### Step 5 — Draft the build prompt

Use the template at `references/build-prompt-template.md`. The prompt has eight standard sections. Write each one assuming Claude Code is the reader, with no prior context from the Cowork conversation:

**1. Context** — what's being built, for whom, why. One paragraph. Lifted from SOW + technical spec.

**2. Inputs to read first** — explicit list of artefacts Claude Code must read before acting. Include exact paths and version numbers (e.g. `05_techspec_v3.md` not "the latest tech spec").

**3. Build scope** — bulleted list of what's in scope for THIS build prompt. Excludes anything outside scope.

**4. Build instructions** — work broken down by sequence (use the technical spec's section 12). For each step:
- What to build
- Which platform construct or code module
- Which BR-X / EC-Y from the functional spec it satisfies
- The acceptance check (how Claude Code verifies it's done)

**5. Constraints (hard rules for Claude Code)** —
- No deviation from the technical spec without flagging
- No production tenant / production repo access — sandbox / dev branch only
- No deletion of existing client data or files
- No additions outside the SOW scope
- No credentials in code, configs, or commit messages — env vars only
- Stop and ask if a construct isn't supported on the licence tier

**6. Tools and access** — what Claude Code needs:
- Working directory: `<absolute path>`
- For platform config: the `platform-<platform>` skill must be available; sandbox API credentials in env vars (named explicitly)
- For custom code: repo URL, branch to work on, env var names, build/test commands
- For both: where to write build artefacts, where to log identifiers (automation IDs, webhook IDs)

**7. Self-test loop** — instruct Claude Code to run the smoke subset of the test plan after each major build item, not just at the end. Reference the test plan path explicitly.

**8. Done criteria + handoff** — what "complete" looks like and what to hand back:
- All build sequence items checked off
- Smoke tests green
- Build report at `<Client>/build-specs/<platform>/07a_build-prompt-dev_v<N>_report.md` listing what shipped, generated identifiers, and any deviations
- Posted back to Cowork conversation as a summary

### Step 6 — Senior-level challenge

Before finalising:

- Is the prompt self-contained? Could a Claude Code session with no prior context execute it?
- Does it reference all upstream artefacts by exact filename + version?
- Does it list every constraint explicitly, including the safety rules?
- Are done criteria observable, not vibes-based?
- Does it tell Claude Code exactly where to write build outputs and the build report?

### Step 7 — Write and hand off

Write to `<Client>/build-specs/<platform>/07a_build-prompt-dev_v{N}.md` with frontmatter:

```yaml
---
client: <Client>
platform: <pipefy | wrike | other>
integrations: [<...>]
version: 1
status: draft
based_on_technical_spec: 05_techspec_v{N}.md
based_on_test_plan: 08b_08b_test-plan_v{N}.md
build_components: [platform_config, custom_code]
generated_at: <ISO date>
---
```

End with this exact handoff message:

> Build prompt drafted at `<path>`.
>
> **To execute:**
>
> 1. Open Claude Code in a fresh terminal session (see `references/when-to-open-claude-code.md` if you're unsure whether this is the right step)
> 2. `cd <working directory from the prompt>`
> 3. Run `claude code`
> 4. Paste the contents of `<path>` as your first message
>
> **Before pasting:**
> - Confirm sandbox / dev environment credentials are loaded in env
> - Confirm the technical spec is `status: approved`
> - Make sure you're not in a production repo branch
>
> **While the build runs in Claude Code:** keep this Cowork session open. If Claude Code asks for clarification or hits a spec ambiguity, you can refine the prompt here and re-paste, or update the technical spec and regenerate.
>
> **When the build finishes:** Claude Code writes a build report at `07a_build-prompt-dev_v{N}_report.md`. Review it, then run `execute-tests` here in Cowork to run the full test plan against the sandbox.

## What this skill does not do

- Does not execute the build — produces a prompt; the team runs it in Claude Code
- Does not modify the technical spec; if drafting reveals a spec gap, surfaces it and pauses
- Does not include credentials in the prompt — references env var names only

## Quality bar

A good build prompt:

- Reads like Claude Code has everything it needs, with no follow-up to the Cowork user
- Names every platform construct in the platform's vocabulary
- Makes constraints explicit
- Has observable done criteria
- References upstream artefacts by exact filename + version
- Survives being read in isolation (six months later, by someone who wasn't in the conversation)
- Tells the user when and how to switch from Cowork to Claude Code

## Iterating between Cowork and Claude Code

Cowork is the strategy seat; Claude Code is the build seat. While Claude Code is executing:

- Keep the Cowork session open with the technical spec, functional spec, and build prompt all in context
- If Claude Code asks "what should this field be called?" or "is this rule correct?" — work through it in Cowork (where the spec lives), update the prompt or spec if needed, then either re-paste the relevant section or have Claude Code re-read the updated file
- Don't switch tools to "fix the spec on the fly" inside Claude Code — that bypasses the review gate. Make spec changes in Cowork, regenerate the build prompt if material, hand back to Claude Code

This protects the audit trail and keeps the spec as the source of truth.
