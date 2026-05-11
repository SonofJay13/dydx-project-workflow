---
name: kickoff-capture
description: Capture a kickoff for a new engagement or change request. Use when the user says "kickoff for X", "start kickoff", "capture meeting notes for X", "run kickoff", or pastes raw meeting notes / Miro / Field Notes content needing structuring. Stage 1 of the dydx-delivery pipeline — produces 01_kickoff_v<N>.md with a kickoff_branch routing field.
---

# kickoff-capture

Capture the operational reality of a new engagement or change request at the very front of the dydx-delivery pipeline. This is **Stage 1**. The skill writes `01_kickoff_v<N>.md`, the artefact every downstream stage either consumes (Stage 2 `discovery-intake`, Stage 3 `generate-sow`) or routes around. The routing decision is encoded in a single frontmatter field, `kickoff_branch:`, whose enum values are `discovery-ready` (Stage 2 runs against the kickoff) and `draft-sow` (Stage 2 is SKIPPED — the kickoff feeds Stage 3 directly). Both values are valid per DESIGN-17; the reviewer chooses one at write time.

> **Hard rules:** Sandbox-only operations. Refuses destructive actions on production tenants and on the Field Notes Coda table. See `dydx-delivery/references/safety-rules.md` for the canonical ruleset.

> **Stage numbering:** This skill writes `01_kickoff_v<N>.md` per the canonical file-prefix scheme. See `dydx-delivery/references/stage-numbering.md` for the canonical Stage 1 placement + old→new mapping table.

> **Frontmatter scheme:** This skill emits `kickoff_branch:` (enum: `discovery-ready | draft-sow`) + `based_on_*` fields per the canonical underscore-snake-case convention. See `dydx-delivery/references/frontmatter-scheme.md` for the canonical scheme + lenient-mode contract.

> **Glossary:** `kickoff_branch:` (enum: `discovery-ready | draft-sow`) and `[unknown — needs human classification]` are canonical terms defined in `dydx-delivery/references/glossary.md`.

## Inputs

Three capture paths feed kickoff. All are paste-only per UAT-3.5 / UAT-6.1 — no MCP, no API calls in v2.2. See `references/capture-paths.md` for the full per-path protocol.

- **Meeting-notes paste (freeform)** — reviewer pastes raw meeting notes, transcript snippet, brief, or email thread directly into the invocation. No format requirements.
- **Miro paste fallback** — reviewer pastes an image of a Miro board + a prose narration of what the diagram shows (per DESIGN-07 / AUDIT-08). The skill does NOT OCR; the narration is the canonical source.
- **Field Notes (Coda) paste** — reviewer queries the Field Notes Coda table manually, filtered by default to `processed_at IS NULL`, and pastes selected rows. Each row is triaged keep / drop / edit-and-keep (MOD-8 prevention — kickoff never auto-merges).

No raw-notes-direct-to-discovery shortcut exists; kickoff is the sole upstream for `discovery-intake` (the v0.3.0 raw-notes path was RETIRED at STG2-01).

## Output

`<Client> Brain/<Project>/01_kickoff_v<N>.md` per DESIGN-02 file-prefix scheme + DESIGN-17 line 561. The artefact carries the frontmatter block documented in `references/kickoff-template.md` (including the chosen concrete `kickoff_branch:` enum value) and the 8 H2 category sections from STG1-04.

If `<Client>` or `<Project>` is unclear from context, ask the reviewer once before drafting.

## How to run

### Step 1 — Locate or establish capture entry point

Start-at-any-point triage. Determine which of the three capture paths the reviewer is using:

- If the reviewer pasted freeform text → **Path 1 (meeting-notes)**.
- If the reviewer pasted an image + a prose description → **Path 2 (Miro paste fallback)**.
- If the reviewer pasted rows from the Field Notes Coda table → **Path 3 (Field Notes paste)**. Default Coda filter is `processed_at IS NULL` (verbatim) — confirm with reviewer if any rows fall outside this filter.

Multiple paths in the same kickoff session are fine; merge inputs into the same `01_kickoff_v<N>.md` artefact.

### Step 2 — Classify captured inputs into 8 sections

Sort every captured input into exactly one of the 8 STG1-04 sections, in this order:

1. **System** — what's being built/changed; current state vs target state.
2. **Users** — primary actors + secondary stakeholders.
3. **Triggers** — manual vs scheduled vs event-driven entry points.
4. **Data** — inputs the workflow consumes; outputs it produces; persistence boundaries.
5. **Rules** — business logic; conditional branches; approval gates.
6. **Integrations** — external systems involved (platforms / SaaS / APIs / paste-fed surfaces).
7. **Exceptions** — non-happy paths; error states; reviewer overrides.
8. **Failure points** — known fragility; integration boundaries; observability gaps.

When confidence in a classification is low, leave the literal marker `[unknown — needs human classification]` inline rather than guessing. The full triggers + escalation table for this decision live in `references/auto-classify-rubric.md` — consult it whenever the source signal is sparse, conflicting, or pre-flagged TBD by the reviewer.

### Step 3 — Senior-level challenge

Before drafting the artefact, push back on the input. Name gaps explicitly: which of the 8 sections is under-evidenced? Which TBDs did the reviewer flag that need resolution before downstream stages can proceed? Surface anything that smells handwaved. The kickoff is the place where unknowns become defensible — not the place where unknowns become forgotten.

### Step 4 — Classify `kickoff_branch`

Decide whether this kickoff feeds Stage 2 (discovery) or skips directly to Stage 3 (SOW). Both enum values are valid:

- `discovery-ready` — material unknowns remain after Step 2 + Step 3. Stage 2 `discovery-intake` will run against the kickoff to fill them.
- `draft-sow` — the engagement is well-enough understood from the kickoff alone to draft a SOW directly. Stage 2 is SKIPPED.

Document the rationale visibly inline in the artefact's `## Routing` block (see `references/kickoff-template.md`). The `kickoff_branch:` frontmatter value is read by both Stage 2 and Stage 3; downstream skips/runs branch on this single field.

### Step 5 — Write and hand off

Emit `01_kickoff_v<N>.md` at the output path. Set the frontmatter block exactly as documented in `references/kickoff-template.md`, with `kickoff_branch:` resolved to the concrete enum value chosen in Step 4 (NOT a placeholder). Per DESIGN-19 / D-76, `based_on_kickoff:` is the field downstream artefacts will use to point back to this kickoff — make sure the artefact identifier is stable.

Then emit the verbatim handoff:

```
Awaiting status: approved write to 01_kickoff_v<N>.md. Branch routing on kickoff_branch: value (discovery-ready -> Stage 2; draft-sow -> SKIP Stage 2 -> Stage 3).
```

Approval is a hard gate per DESIGN-06; do not auto-progress.

## What this skill does not do

- Does NOT call any Coda / Miro MCP or API. All inputs are paste-only per D-72. Future Coda MCP integration is captured under Deferred Ideas (v2.6 / SURF-01..03 candidate).
- Does NOT auto-merge Field Notes entries into the client brain. Every row is quoted and the human is asked keep / drop / edit-and-keep (MOD-8 prevention per DESIGN-09).
- Does NOT auto-progress to Stage 2 / Stage 3. The `status: approved` gate is non-negotiable per DESIGN-06.
- Does NOT accept raw-notes input that bypasses the kickoff. The v0.3.0 raw-notes intake path was RETIRED at STG2-01; kickoff is the sole upstream for `discovery-intake`.

## Quality bar

- Every `[unknown — needs human classification]` marker is intentional and defensible — left there because the source signal was genuinely thin, not because the reviewer skimmed.
- `kickoff_branch:` value is documented with a one-paragraph rationale in the `## Routing` block of the artefact — a reviewer reading 6 months later can reconstruct why discovery did or did not run.
- Field Notes rows are traceable to their Coda source row; `field_notes_processed_count:` frontmatter field matches the number of rows touched (kept + dropped + edited).
- All 4 canonical references (`safety-rules.md`, `stage-numbering.md`, `frontmatter-scheme.md`, `glossary.md`) resolve at the paths above; the kickoff doesn't redefine concepts those references own.
- The 8 H2 section list matches `references/kickoff-template.md` verbatim — no drift, no renaming.
