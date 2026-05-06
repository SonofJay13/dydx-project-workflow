# When to open Claude Code

> A quick guide for the dYdX Digital team. Cowork is the strategy seat. Claude Code is the build seat. Use this to decide which one to be in.

## Quick decision

| You are doing... | Use |
|---|---|
| Capturing context, running discovery, drafting specs | **Cowork** |
| Reviewing or refining a spec, test plan, or build prompt | **Cowork** |
| Generating the prompt to give Claude Code | **Cowork** |
| Running platform API calls (configuring Pipefy / Wrike / Workato) | **Claude Code** |
| Writing or modifying code in a repo | **Claude Code** |
| Running shell commands, tests, or build scripts | **Claude Code** |
| Executing the full test plan (`execute-tests`) | **Cowork** (it uses platform skills, not the filesystem) |
| Asking "is this spec good?" or "what should this rule be?" | **Cowork** (the spec lives there) |

## The full flow with tool transitions

```
┌──────────────── Cowork ────────────────┐    ┌──── Claude Code ────┐    ┌──── Cowork ────┐
│                                        │    │                      │    │                │
│  discovery-intake                      │    │  Read inputs         │    │  execute-tests │
│         ↓                              │    │  Run build sequence  │    │  (against the  │
│  generate-sow                          │    │  Run smoke tests     │    │   sandbox)     │
│         ↓                              │    │  Write build report  │    │                │
│  generate-functional-spec              │    │  Open PR / summary   │    │                │
│         ↓                              │    │                      │    │                │
│  generate-technical-spec               │    └──────────┬───────────┘    └────────────────┘
│         ↓                              │               │
│  generate-test-plan                   │   ←───────────┘
│         ↓                              │   (if Claude Code asks for spec clarification,
│  generate-build-prompt  ───┐           │    answer here, update the spec/prompt, re-paste)
│                            │           │
└────────────────────────────┼───────────┘
                             │
                             ↓
                        Open Claude Code
                        (paste build prompt)
```

## Why two tools?

Cowork is great for unstructured input — meeting notes, transcripts, briefs, pasted screenshots. It has the connectors (Slack, calendar, email) and the workspace context. It's where you think.

Claude Code is great for executing — it has full filesystem access, runs shell commands, can write code and apply diffs cleanly, integrates with your editor. It's where you build.

Mixing the two — building in Cowork, planning in Claude Code — works against the strengths of each. Keeping them separate gives you a cleaner audit trail (the build prompt artefact is the contract between the two) and lets the team work in whichever tool fits the task.

## What about starting in Claude Code instead?

You can. The plugin works identically in either tool — every skill is portable. If you want to run discovery from inside a code session (e.g. you're already in a repo and want to capture a feature request), invoke `discovery-intake` in Claude Code and walk the same flow.

But for most engagements your discovery input is messy human text (notes, transcripts, briefs). Cowork handles that better. Claude Code is sharper when the work has a filesystem or shell shape.

## The "stay in Cowork while Claude Code builds" pattern

When you've handed a build prompt to Claude Code, don't close Cowork. Use it to:

- Hold the spec in context — if Claude Code asks "what should `priority` be ordered as?", you can answer from the functional spec without context-switching
- Refine the prompt mid-build — if you spot a gap, update the prompt or spec in Cowork, then ask Claude Code to re-read
- Generate sibling artefacts in parallel — e.g. drafting the handover doc while the build runs
- Run `execute-tests` at the end — once Claude Code reports the build done, switch back to Cowork and run the full test plan

The two tools are complementary, not sequential. Treat the Cowork session as your control room.

## Quick rules

1. **Specs live in Cowork.** If you change a spec inside a Claude Code session, the change isn't in the audit trail. Update specs in Cowork, regenerate downstream artefacts, hand back to Claude Code.
2. **Builds happen in Claude Code.** Even if Cowork could call the API, don't use it for that. The build prompt is the contract.
3. **Tests run in Cowork.** `execute-tests` uses platform skills against APIs — no filesystem needed. Keep it in Cowork so the results live alongside the specs.
4. **When in doubt, stay where the artefact you need is.** Switch tools only when the next action is a different shape.

## When NOT to open Claude Code

- The build is platform configuration only AND you don't have an MCP that lets Claude Code hit the platform API → hand the prompt to the implementation partner instead
- The work is a small spec change, not a build → stay in Cowork, regenerate the relevant artefacts, no Claude Code needed
- You haven't reviewed the technical spec yet → the build prompt isn't ready; keep iterating in Cowork

## Setting up Claude Code (one-time per teammate)

1. Install Claude Code: see [docs.claude.com/claude-code](https://docs.claude.com/en/docs/claude-code/overview)
2. Install the dydx-delivery plugin in Claude Code:
   ```
   /plugin marketplace add https://github.com/SonofJay13/dydx-project-workflow
   /plugin install dydx-delivery
   ```
3. Set up env vars for sandbox API access (Pipefy token, Wrike token, etc.) — see your client folder's `.env.example`
4. You're ready. When a teammate hands you a build prompt, `cd` to the working directory, run `claude code`, and paste.
