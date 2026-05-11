# Codebase Concerns

**Analysis Date:** 2026-05-09

> Structural inventory only. Observations of facts in the repo at the current commit (`8805379 chore: initial marketplace + dydx-delivery 0.3.0`, branch `dydx-delivery-v2`). No remediation suggestions — read each item as "X is the case", not "X should change".

---

## Version string mismatches across manifests and docs

**Plugin version disagreement between root README and manifests:**
- `README.md` line 9 lists `dydx-delivery` at version **0.1.0**.
- `.claude-plugin/marketplace.json` line 16 lists `dydx-delivery` at version **0.3.0**.
- `dydx-delivery/.claude-plugin/plugin.json` line 3 lists version **0.3.0**.
- `dydx-delivery/README.md` line 126 begins a `0.3.0` changelog entry.

**Hardcoded runner version diverges from plugin version:**
- `dydx-delivery/skills/execute-tests/references/results-template.md` line 9 hardcodes `runner: dydx-delivery/execute-tests v0.1.0` in the frontmatter while `plugin.json` declares the plugin at `0.3.0`.

**`v1` reference of unclear scope:**
- `dydx-delivery/skills/execute-tests/references/safety-rules.md` line 93 reads "Parallel execution is not supported in v1" — no companion versioning anchor found in the file.

**Marketplace metadata version vs plugin version:**
- `.claude-plugin/marketplace.json` line 9 sets the marketplace `metadata.version` to **1.2.0** while the only listed plugin sits at **0.3.0**. Whether the marketplace version is intended to track plugins or be independent is not stated in the README.

---

## References to skills/files that do not exist in the repo

**`platform-pipefy` and `platform-wrike` skills referenced but absent:**
The text describes a dynamic-load mechanism that selects a platform skill based on frontmatter. No `platform-pipefy/` or `platform-wrike/` directory exists under `dydx-delivery/skills/`. References:
- `dydx-delivery/README.md` line 89.
- `dydx-delivery/skills/generate-build-prompt/SKILL.md` line 47.
- `dydx-delivery/skills/execute-tests/SKILL.md` line 55.
- `dydx-delivery/skills/generate-technical-spec/SKILL.md` lines 38–39.

**`/refine-<skill>` slash commands referenced but absent:**
No `commands/` directory exists in the plugin and no `refine-*` skills exist. References:
- `README.md` (root) line 56.
- `dydx-delivery/README.md` line 51.
- `dydx-delivery/README.md` line 85 ("…used by `/refine-<skill>` if added later").

**Workspace `hub.md` referenced but not in repo:**
- `dydx-delivery/README.md` line 57 ("see workspace `hub.md`").
- `dydx-delivery/skills/discovery-intake/SKILL.md` lines 27–28 ("match it against the workspace `hub.md` client index" and "see `hub.md`").

**Client folder `.env.example` referenced but not in repo:**
- `dydx-delivery/skills/generate-build-prompt/references/when-to-open-claude-code.md` line 88 ("see your client folder's `.env.example`").

---

## Truncated / cut-off content

**`dydx-delivery/README.md` ends mid-sentence at line 126:**
The Changelog entry for `0.3.0` reads: "The bot-run terminal stage (`execute-tests`) now c" and the file terminates. No closing punctuation, no further entries.

---

## Pipeline stage numbering inconsistencies

The seven skills are described in `dydx-delivery/README.md` lines 33–41 in pipeline order. The reference templates self-label with "Stage N" annotations, and those labels do not form a consistent sequence:

| Skill / template | File:line | Stage label |
|---|---|---|
| discovery-intake / intake-template | `dydx-delivery/skills/discovery-intake/references/intake-template.md:13` | Stage 0 |
| generate-sow / sow-template | `dydx-delivery/skills/generate-sow/references/sow-template.md` | (no Stage label) |
| generate-functional-spec / functional-spec-template | `dydx-delivery/skills/generate-functional-spec/references/functional-spec-template.md:13` | Stage 2 |
| generate-technical-spec / technical-spec-template | `dydx-delivery/skills/generate-technical-spec/references/technical-spec-template.md:13` | Stage 3 |
| generate-test-plan / test-plan-template | `dydx-delivery/skills/generate-test-plan/references/test-plan-template.md:17` | Stage 5 |
| generate-build-prompt / build-prompt-template | `dydx-delivery/skills/generate-build-prompt/references/build-prompt-template.md:15` | Stage 6 |
| execute-tests / results-template | `dydx-delivery/skills/execute-tests/references/results-template.md:18` | Stage 6 |

Observations:
- No template is labelled Stage 1 or Stage 4.
- Two distinct templates are both labelled "Stage 6" (`build-prompt-template.md` and `results-template.md`).
- The output file-name prefixes elsewhere use `00_…04_…` (e.g. `00_discovery`, `01_sow`, `02_functional-spec`, `03_technical-spec`, `04_build-prompt` — see `dydx-delivery/README.md` lines 62–72 and the `Output` sections of each SKILL.md), giving a separate numbering scheme that differs from the "Stage N" labels above.

---

## Naming inconsistency: "test plan" vs "test sheet"

Per `dydx-delivery/README.md` line 126, version 0.3.0 renamed `generate-test-sheet` → `generate-test-plan`. Residual "test sheet" wording in the root README has not followed the rename:
- `README.md` (root) line 9 describes the pipeline as "discovery → SOW → functional spec → technical spec → **test sheet** → execution".
- All other surfaces (skill names, skill descriptions, file prefixes, marketplace.json description, dydx-delivery README diagram and table) use "test plan" / `test-plan_v*.md`.

---

## Pipeline-step count mismatch in root README

- `README.md` (root) line 9 enumerates 5 pipeline steps ("discovery → SOW → functional spec → technical spec → test sheet → execution").
- `marketplace.json` line 15 and `dydx-delivery/.claude-plugin/plugin.json` line 4 describe **seven skills**.
- `dydx-delivery/README.md` lines 33–41 list **seven skills** in a table.

---

## Empty / missing scaffold directories typical of Claude Code plugins

The `dydx-delivery/.claude-plugin/` directory contains only `plugin.json`. Adjacent plugin convention directories are absent in the repo:
- No `dydx-delivery/commands/` directory.
- No `dydx-delivery/agents/` directory.
- No `dydx-delivery/hooks/` directory.
- No top-level `.claude/` or `.agents/` skills directories.
- `.planning/codebase/` exists and is empty before this run.

(The plugin uses a `skills/`-only structure; the README does not state which Claude Code plugin surfaces are intentionally not used.)

---

## Cross-references between docs

**`dydx-delivery/README.md` line 95** points to `skills/generate-build-prompt/references/when-to-open-claude-code.md` for the decision matrix. The file exists at that path.

**`dydx-delivery/skills/execute-tests/SKILL.md` line 23** points to `references/safety-rules.md`. The file exists at that path.

**`dydx-delivery/skills/generate-test-plan/SKILL.md` line 49** points to `references/test-plan-template.md`. The file exists at that path.

(No broken intra-plugin file references found beyond the unfollowed `platform-pipefy` / `platform-wrike` / `hub.md` references already listed above.)

---

## Duplicated content across skills

**Hard-rules block duplicated three places:**
The sandbox / no-deletions / read-write-only / audit-trail rules appear, in similar wording, in:
- `dydx-delivery/README.md` lines 99–105 ("Test execution — safety rules (hard)").
- `dydx-delivery/skills/execute-tests/SKILL.md` lines 21–31 ("Hard rules — enforced regardless of test plan content").
- `dydx-delivery/skills/execute-tests/references/safety-rules.md` (full file, the canonical version).
- `dydx-delivery/skills/generate-test-plan/references/test-plan-template.md` lines 36–44 ("Hard rules (enforced by `execute-tests`)").

The four copies do not match exactly (e.g. `safety-rules.md` lists 10 numbered rules including rate limiting, stop conditions, concurrency, cleanup, reporting; the other surfaces list 4–7 rules).

**Start-at-any-point triage block duplicated per skill:**
Near-identical "(a) Paste / (b) Walk through inline / (c) Cancel" prompt text appears in:
- `dydx-delivery/skills/generate-sow/SKILL.md` lines 27–33.
- `dydx-delivery/skills/generate-functional-spec/SKILL.md` lines 28–32.
- `dydx-delivery/skills/generate-technical-spec/SKILL.md` lines 28–32.
- `dydx-delivery/skills/generate-test-plan/SKILL.md` lines 30–34.
- `dydx-delivery/skills/generate-build-prompt/SKILL.md` lines 28–32.
- `dydx-delivery/skills/execute-tests/SKILL.md` lines 40–44.

Each copy carries small wording variations.

**Cowork-vs-Claude-Code positioning duplicated:**
- `dydx-delivery/README.md` lines 5, 9–29.
- `dydx-delivery/skills/generate-build-prompt/SKILL.md` lines 8, 163–171.
- `dydx-delivery/skills/generate-build-prompt/references/when-to-open-claude-code.md` (full file).

**Pipeline diagram / table duplicated:**
- `dydx-delivery/README.md` lines 9–29 (ASCII diagram + skills table).
- `dydx-delivery/skills/generate-build-prompt/references/when-to-open-claude-code.md` lines 18–40 (similar ASCII diagram with tool transitions).

---

## TODO / FIXME / HACK / XXX markers

No `TODO`, `FIXME`, or `HACK` markers found in any file in the repo.

`XXX` matches found are template placeholders, not concern markers:
- `dydx-delivery/skills/execute-tests/references/safety-rules.md:61` — `TC-XXX` format example in audit log block.
- `dydx-delivery/skills/execute-tests/references/results-template.md:44, 58` — `TC-XXX — <Title>` placeholder in failures/refusals sections.

`<...>`-style placeholder markers (`<TBC>`, `**TBC**`, `**Unknown — needs client input**`, `<id>`, `<name>`) are widespread in the templates and are the documented "unknown" convention (see `dydx-delivery/skills/discovery-intake/SKILL.md` line 93 and `dydx-delivery/skills/generate-sow/SKILL.md` line 99).

---

## Frontmatter / template structural inconsistencies

**`status:` lifecycle vocabulary is not uniform across templates:**
- `intake-template.md` frontmatter line 6: `status: draft`. SKILL.md line 104 frontmatter sample also `status: draft`. Discovery flow does not specify a final status word.
- `sow-template.md` frontmatter line 6: `status: draft`. SKILL.md handoff line 93 mentions `status:` values `client_review` and `approved`.
- `functional-spec-template.md` line 6 / SKILL.md line 95: `draft` → `approved`.
- `technical-spec-template.md` line 6 / SKILL.md line 119: `draft` → `approved`.
- `test-plan-template.md` line 6 / SKILL.md line 118: `draft` → `approved`.
- `build-prompt-template.md` line 6: `draft`. The `generate-build-prompt` SKILL does not document a follow-up status value.
- `results-template.md` does not include a `status:` field at all.

**Sandbox block always carries both `pipe_id` and `space_id` regardless of platform:**
- `test-plan-template.md` lines 9–13 and `results-template.md` lines 10–13 both list `pipe_id` and `space_id` together. `pipe_id` is Pipefy vocabulary; `space_id` is Wrike vocabulary. The frontmatter does not gate them by `platform:` value.

**`based_on_*` field naming is not uniform:**
- `intake-template.md`: no `based_on_*` (entry stage).
- `sow-template.md` line 7: `based_on_discovery: 00_discovery_v<N>.md`.
- `functional-spec-template.md` line 7: `based_on_sow: 01_sow_v<N>.md`.
- `technical-spec-template.md` line 7: `based_on_functional_spec: 02_functional-spec_v<N>.md` (underscore in `functional_spec`).
- `test-plan-template.md` line 7: `based_on_technical_spec: 03_technical-spec_v<N>.md` (underscore in `technical_spec` whereas the file path uses a hyphen `technical-spec`).
- `build-prompt-template.md` lines 7–8: `based_on_technical_spec` AND `based_on_test_plan`.
- `results-template.md` line 6: `based_on_test_plan: test-plan_v<N>.md`.

---

## Identifiers / contact details

**Email address mismatch with stated org:**
- `marketplace.json` line 5 (`owner.email`) and `plugin.json` line 7 (`author.email`) both list `jasonmichaelb@gmail.com`. The README and marketplace metadata describe the team as "dYdX Digital" (e.g. `marketplace.json` line 4, `plugin.json` line 4). No `@dydx.digital` or organisational domain appears in the manifests.

**Homepage link is one-way:**
- `plugin.json` line 9: `homepage` is `https://github.com/SonofJay13/dydx-project-workflow`.
- `marketplace.json` has no `homepage` field.
- `README.md` (root) line 21 instructs `/plugin marketplace add https://github.com/SonofJay13/dydx-project-workflow` (matches `plugin.json` homepage).

---

## Build artefact path references in spec text

**`04_build-prompt_v1_report.md` referenced in two locations with same convention:**
- `dydx-delivery/README.md` line 78: `<Client>/build-specs/<platform>/04_build-prompt_v1_report.md`.
- `dydx-delivery/skills/generate-build-prompt/SKILL.md` line 95 / line 144: `04_build-prompt_v<N>_report.md`.
- `build-prompt-template.md` lines 126, 156: `04_build-prompt_v<N>_report.md`.

**`04_build-prompt_v<N>_deviations.md` referenced only in the build-prompt template:**
- `build-prompt-template.md` line 129. No mention of a deviations file in the SKILL.md or the README.

**Sibling-prompt convention `04a_build-prompt-config.md` / `04b_build-prompt-code.md`:**
- Mentioned only in `dydx-delivery/skills/generate-build-prompt/SKILL.md` line 43. Not reflected in the build-prompt template's output path nor in the README's file-shape diagram (which lists only `04_build-prompt_v1.md`).

---

## License field

- `plugin.json` line 10: `"license": "Proprietary"`.
- No `LICENSE` or `LICENSE.md` file at the repo root or in `dydx-delivery/`.
- `marketplace.json` has no `license` field.

---

## Versioning convention vs current state

- `README.md` (root) lines 81–83 define the semver convention used for plugins in this marketplace.
- `marketplace.json` line 9 sets marketplace `metadata.version` to `1.2.0` despite the README presenting this commit as the "initial marketplace + dydx-delivery 0.3.0" (per the recent commit message).
- The repo has a single commit (`8805379`) on `dydx-delivery-v2`; no prior 1.0.0 / 1.1.0 marketplace tags or commits are visible from the supplied state.

---

*Concerns audit: 2026-05-09*
