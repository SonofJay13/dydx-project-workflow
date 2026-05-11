# Phase 5: Foundations + Connector Verification — Research

**Researched:** 2026-05-10
**Branch / commit:** `dydx-delivery-v2`
**Domain:** Plugin-level canonical-references foundation + manifest sync + connector matrix + cosmetic CONCERNS cleanup
**Confidence:** HIGH (CONTEXT.md is fully locked; codebase audited verbatim; web research for OPEN-Qs completed)

> Phase 5 ships the **plugin-level foundation** every later v2.x phase depends on. v2.0 design-only mandate ENDS here — skill edits become permitted. 13 FOUND-* requirements split across 5 waves per D-60. CONTEXT.md is dense and pre-locks 7 decisions (D-56..D-62); this research adds **operational ground-truth** the planner needs: exact `file:line` citations for every edit surface, byte-exact text for canonical content, current 2026 vendor data for the 8 inline OPEN-Q resolutions, and Validation Architecture grep assertions.

---

## Research Summary

1. **CONTEXT.md is the planner's bible.** D-56..D-62 lock the substantive design moves. This RESEARCH supplies tactical citations, not strategic alternatives. Plans MUST treat D-56 (doc-only matrix), D-58 (renumber surface = stage-numbering.md + skill bodies + templates), D-59 (uniform hard-rules pointer wording), D-61 (status survey FIRST in W1), and D-62 (lift-and-fix safety-rules) as non-negotiable.

2. **`plugin.json` is at `dydx-delivery/.claude-plugin/plugin.json`, NOT `dydx-delivery/plugin.json`.** ROADMAP and CONTEXT both say "`plugin.json`" without path — the actual file lives one level deeper inside `.claude-plugin/`. **The empty scaffold dirs (`commands/`, `agents/`, `hooks/`) land at `dydx-delivery/<dir>/` — NOT inside `.claude-plugin/`** (DESIGN-11 tree at `DESIGN.md:284-329` confirms this — they're siblings of `skills/`, not children of `.claude-plugin/`).

3. **The "based_on_* normalisation" surface is small and the keys are ALREADY snake_case.** Grep of the entire `dydx-delivery/` tree finds 13 occurrences of `based_on_*`; all use `based_on_<word>` snake_case (`based_on_discovery`, `based_on_sow`, `based_on_functional_spec`, `based_on_technical_spec`, `based_on_test_plan`). DESIGN-01 confirms the canonical convention is underscore-snake-case keys (`DESIGN.md:70`). **The "normalisation" mentioned in FOUND-05 is therefore a NO-OP for casing**; the operational interpretation is: renumber the **artefact filenames** referenced inside the values (e.g., `based_on_discovery: 00_discovery_v{N}.md` → `based_on_discovery: 02_discovery_v{N}.md`) per the FOUND-06 mapping. Planner should verify with the user OR treat as filename-only.

4. **FOUND-06 mapping in REQUIREMENTS.md is shorthand; DESIGN-02 carries the substage-aware truth.** REQUIREMENTS says "00→02 / 01→03 / 02→04 / 03→05 / 04→07a". DESIGN-02 at `.planning/DESIGN.md:84-87` resolves this as: `00_discovery_*` → `02_discovery_*`; `01_sow_*` → `03_sow_*`; `02_functional-spec_*` → `04a_fnspec-platform_*` (Stage 4 SPLIT — so the "→04" in shorthand is really "→04a"); `03_technical-spec_*` → `05_techspec_*`; `04_build-prompt_*` → `07a_build-prompt-dev_*`. Plus: `test-plan_v*` → `08b_test-plan_*`; `results-YYYY-MM-DD_v*` → `08_test-results_*`. **Use DESIGN-02 wording verbatim in `stage-numbering.md`; FOUND-06 shorthand is for changelog optics only.**

5. **The 4 hard-rules duplicate surfaces are concrete and grep-citable.** AUDIT-05.1 at `.planning/AUDIT.md:362-381` names them exactly: (canonical) `execute-tests/references/safety-rules.md` full file; (dup 1) `dydx-delivery/README.md:99-105`; (dup 2) `dydx-delivery/skills/execute-tests/SKILL.md:21-31`; (dup 3) `dydx-delivery/skills/generate-test-plan/references/test-plan-template.md:36-44`. D-59 nominates a specific 4-file pointer-replace list but it diverges from AUDIT-05.1 — see §Codebase Reality.

6. **The sandbox-block bug (CRIT-5) is content-level, not config-level.** There is no sandbox "allowlist config file" to edit. The "bug" is that the existing `safety-rules.md §3 "No destructive integrations outside scope"` (`safety-rules.md:30-40`) restricts destructive integrations to email/Slack/Ziflow/billing/publishing without explicitly authorising Coda as a SAFE sandbox target. CRIT-5 fix = **extend the SAFETY narrative to authorise Coda sandbox writes** (the Stage 6 cost-estimate + Stage 11 brain-mirror flows need Coda writes; without explicit allowlisting the runner refuses). The fix lands as an additional clause in the new plugin-level `dydx-delivery/references/safety-rules.md` (per FOUND-01 + D-62).

7. **The connector-matrix has 6 connectors but 10 stages need fallback rows.** Per CONTEXT D-56: Coda MCP / Google Workspace MCP / Miro MCP / Pipefy API / Wrike API / Ziflow API. DESIGN-07 (`DESIGN.md:162-178`) names 4 example fallback rows (Stage 1 Miro paste / Stage 6 Coda manual / Stage 9 Drive halt / Stage 10 native-AI paste). The matrix must cover all 11 stages × 6 connectors = a connector × stage cell grid with "REQUIRED / GRACEFUL / N/A" per cell + a fallback-behaviour column.

8. **6 of 8 OPEN-Qs resolve to concrete answers in this RESEARCH; 2 are workspace-probe (live MCP re-confirm).** Q06.1 (Pipefy = 500 req/30s ≈ 16.67 req/sec — supersedes the historic ~5 req/sec ceiling); Q07.1 (Wrike = 400 req/min per user / 5000 req/min per IP); Q09 (canonical = "Claude for Chrome" per product page, but "Claude in Chrome" is interchangeable per Help Center); Q13 (Wrike host = OAuth token response `host` field — base URL built per-tenant from this); Q25 (Wrike + Ziflow auth-concurrency = INSUFFICIENT EVIDENCE — recommend default `exclusive` per Pipefy precedent until live tenant test). Q10/Q11/Q12 require live `claude mcp list` re-probe at Wave 4 — AUDIT-08 baseline shows Coda + Miro working at 2026-05-09.

9. **5 cosmetic AUDIT-07 fixes have byte-exact targets.** B.1: `dydx-delivery/README.md:126` (changelog truncated mid-word "now c"). B.2: `README.md:9` literal "test sheet" → "test plan". B.3: `README.md:9` says "5 pipeline steps" implicitly (need to recount). B.4: LICENSE = covered by FOUND-08 (cross-ref). B.6: `.claude-plugin/marketplace.json` missing `homepage` field (currently 21 lines, no `homepage` key). **B.5 (owner-email) — DO NOT TOUCH** per UAT-3.1 / `user_email_approved.md` memory.

10. **The status-lifecycle survey re-run (FOUND-12) has NO live `<Client> Brain/` folders accessible from this workspace.** DESIGN-08's original survey at `DESIGN.md:245-274` documented the fallback explicitly: only v0.3.0 SKILL.md sources were sampled. The Wave 1 re-run faces the same constraint; the 2 known-live brains (Up & Up Group, VodafoneZiggo per `user_email_approved.md` cross-ref + OPEN-Q17 decision at `OPEN-QUESTIONS.md:288-289`) live in Coda, not local filesystem. **Planner choice:** (a) survey via Coda MCP `page_read` against the 2 brains' Field Notes + Change History sections to extract live `status:` values; (b) reuse the DESIGN-08 SKILL.md-only fallback methodology and just timestamp it 2026-05-10. Option (a) is more rigorous but requires Coda MCP probe (now wired per AUDIT-08).

---

## Project Constraints (from CLAUDE.md)

No `CLAUDE.md` at repo root or in `.claude/` (verified by `ls`). No project-level skill files at `.claude/skills/` or `.agents/skills/`. **Project constraints inherit from `.planning/` documents and `.claude/memory/`:**

- **`user_email_approved.md`** — `jasonmichaelb@gmail.com` on plugin manifests is INTENTIONAL. Phase 5 plans MUST NOT touch the email anywhere (B.5 explicit exclusion).
- **`feedback_platform_skills_api_first.md`** — Pipefy/Wrike/Ziflow direct API only through v2.6; MCPs deferred. Connector matrix must NOT carry an "MCP path" branch for these 3 platforms.
- **`reference_client_brain_coda_docs.md`** — Up & Up Group + VodafoneZiggo are the 2 established Coda brain doc clients (live URLs in OPEN-Q17 decision); other clients are TBD until first archive bootstraps.
- **All "decided" OPEN-Q statuses are locked** (`.planning/OPEN-QUESTIONS.md` rows for Q14/15/16/17/21/21.1/22/23/24). Planner does NOT re-litigate.

---

## Phase Requirements

| ID | Description | Wave | Research support |
|----|-------------|------|------------------|
| FOUND-01 | `dydx-delivery/references/safety-rules.md` plugin-level canonical, sandbox allowlist extended to Coda | W1 | §Canonical References Content + §Safety Rules Migration |
| FOUND-02 | `dydx-delivery/references/stage-numbering.md` canonical, DESIGN-02 substages + old→new mapping | W1 | §Canonical References Content + §Stage Numbering |
| FOUND-03 | `dydx-delivery/references/frontmatter-scheme.md` canonical, DESIGN-01 + lenient mode | W1 | §Canonical References Content + §Frontmatter Scheme |
| FOUND-04 | `dydx-delivery/references/glossary.md` canonical | W1 | §Canonical References Content + §Glossary scope |
| FOUND-05 | 7 v0.3.0 skills repointed; 4 hard-rules duplicates collapsed; sandbox-block bug fixed; `based_on_*` normalised | W2 | §Skill Repoint Mechanics |
| FOUND-06 | File renumbering 00→02 / 01→03 / 02→04 / 03→05 / 04→07a applied to skill bodies + templates | W2 | §File Renumbering Surface |
| FOUND-07 | Plugin manifest `2.0.0` synced across `plugin.json` + `marketplace.json` | W3 | §Manifest Sync |
| FOUND-08 | `LICENSE` file at repo root, two-line boilerplate per OPEN-Q23 | W3 | §LICENSE Content |
| FOUND-09 | Empty `commands/` / `agents/` / `hooks/` scaffold dirs at plugin root | W3 | §Scaffold Dirs |
| FOUND-10 | `connector-matrix.md` doc-only, 6 connectors × 11 stages fallback grid | W4 | §Connector Matrix Schema |
| FOUND-11 | 5 cosmetic CONCERNS fixes (B.1/B.2/B.3/B.4/B.6); B.5 NO FIX | W5 | §AUDIT-07 Cosmetic Fixes |
| FOUND-12 | Status-lifecycle survey re-run at kickoff, confirms no drift | W1 (first task per D-61) | §Status Survey Re-run |
| FOUND-13 | 8 OPEN-Qs resolved inline (Q06.1/Q07.1/Q09/Q10/Q11/Q12/Q13/Q25) | W4 | §Open Questions Resolution |

---

## Codebase Reality

### Plugin file layout (current state, verified 2026-05-10)

```
dydx-project-workflow/                          (repo root)
├── .claude-plugin/
│   └── marketplace.json                        ← marketplace manifest (21 lines, version "1.2.0" metadata + "0.3.0" plugins[0])
├── README.md                                   ← root README (88 lines; B.1 fix doesn't live here)
├── dydx-delivery/                              (plugin root)
│   ├── .claude-plugin/
│   │   └── plugin.json                         ← plugin manifest (25 lines, version "0.3.0", author.email INTENTIONAL)
│   ├── README.md                               ← plugin README (126 lines, TRUNCATED at "now c" — B.1 target)
│   └── skills/
│       ├── discovery-intake/SKILL.md
│       │   └── references/intake-template.md
│       ├── execute-tests/SKILL.md
│       │   └── references/{results-template.md, safety-rules.md}
│       ├── generate-build-prompt/SKILL.md
│       │   └── references/{build-prompt-template.md, when-to-open-claude-code.md}
│       ├── generate-functional-spec/SKILL.md
│       │   └── references/functional-spec-template.md
│       ├── generate-sow/SKILL.md
│       │   └── references/sow-template.md
│       ├── generate-technical-spec/SKILL.md
│       │   └── references/technical-spec-template.md
│       └── generate-test-plan/SKILL.md
│           └── references/test-plan-template.md
└── conductor/                                  (out-of-scope for Phase 5)
```

**Missing dirs that Phase 5 creates:**
- `dydx-delivery/references/` (NEW — holds 5 canonical files: safety-rules.md / stage-numbering.md / frontmatter-scheme.md / glossary.md / connector-matrix.md)
- `dydx-delivery/commands/` (NEW empty scaffold per FOUND-09)
- `dydx-delivery/agents/` (NEW empty scaffold per FOUND-09)
- `dydx-delivery/hooks/` (NEW empty scaffold per FOUND-09)
- `LICENSE` at REPO ROOT (NEW per FOUND-08 — `.planning/CHANGELIST.md:223` and OPEN-Q23 both put it at repo root, NOT `dydx-delivery/LICENSE`)

### Current `plugin.json` state — `dydx-delivery/.claude-plugin/plugin.json`

```json
{
  "name": "dydx-delivery",
  "version": "0.3.0",                                          ← FOUND-07 target: "2.0.0"
  "description": "...Seven skills that turn a discovery conversation into a SOW, functional spec, technical spec, test plan, and a Claude-Code-ready build prompt...",
  "author": {
    "name": "Jason Blignaut",
    "email": "jasonmichaelb@gmail.com"                         ← UAT-3.1 LOCKED — DO NOT TOUCH (B.5)
  },
  "homepage": "https://github.com/SonofJay13/dydx-project-workflow",
  "license": "Proprietary",                                    ← FOUND-08 backs this with actual LICENSE file
  "keywords": [...]
}
```

**Notably absent:** No `mcpServers` field. DESIGN-04 (`.planning/DESIGN.md:119`) says v2 should add `mcpServers` listing 5 wired MCPs. **Phase 5 is silent on this** — neither FOUND-07 nor the W3 plan slice mentions it. Planner decision needed: add `mcpServers` in W3 (consistent with DESIGN-04 contract) OR defer to a later v2.x phase. **Recommendation: defer** — FOUND-07 scope is narrow ("`2.0.0` synced") and DESIGN-04 `mcpServers` is a NEW field unrelated to version sync. Add an `[OPEN]` marker if the planner wants to surface for user adjudication.

### Current `marketplace.json` state — `.claude-plugin/marketplace.json`

```json
{
  "name": "dydx-digital",
  "owner": {
    "name": "dYdX Digital",
    "email": "jasonmichaelb@gmail.com"                         ← UAT-3.1 LOCKED — DO NOT TOUCH (B.5)
  },
  "metadata": {
    "description": "...",
    "version": "1.2.0"                                          ← FOUND-07 target: "2.0.0" (drifts from plugin)
  },
  "plugins": [
    {
      "name": "dydx-delivery",
      "source": "./dydx-delivery",
      "description": "...Seven skills: discovery-intake, generate-sow, generate-functional-spec, generate-technical-spec, generate-test-plan, generate-build-prompt (for Claude Code), execute-tests...",
      "version": "0.3.0",                                       ← FOUND-07 target: "2.0.0"
      "category": "delivery",
      "tags": ["sow", "spec", "test-plan", "build-prompt", "claude-code", ...]
    }
  ]
}
```

**No `homepage` field at the plugin-entry level** — B.6 fix is to add `"homepage": "https://github.com/SonofJay13/dydx-project-workflow"` matching the plugin.json key.

### AUDIT-05.1 duplicate-content surfaces — `file:line` verified 2026-05-10

| # | File | Lines | Current role | Phase 5 action |
|---|------|-------|--------------|----------------|
| 1 | `dydx-delivery/skills/execute-tests/references/safety-rules.md` | 1-101 (full file) | CANONICAL — 10 numbered rules | LIFT verbatim to `dydx-delivery/references/safety-rules.md` + add Coda-sandbox clause (D-62); collapse skill-internal file to one-line pointer |
| 2 | `dydx-delivery/README.md` | 99-105 | DUPLICATE — 5 condensed bullets in `## Test execution — safety rules (hard)` section | Replace block with one-line pointer per D-59 wording |
| 3 | `dydx-delivery/skills/execute-tests/SKILL.md` | 20-30 (heading `## Hard rules — enforced regardless of test plan content` at line 20; 7-rule block lines 24-30) | DUPLICATE — 7 numbered rules | Replace with D-59 one-line pointer |
| 4 | `dydx-delivery/skills/generate-test-plan/references/test-plan-template.md` | 36-44 (heading `## Hard rules (enforced by execute-tests)` at line 36) | DUPLICATE — 5 condensed bullets | Replace with D-59 one-line pointer |

**Critical discrepancy:** CONTEXT D-59 nominates 4 files: `skills/discovery-intake/SKILL.md` / `skills/generate-sow/SKILL.md` / `skills/execute-tests/SKILL.md` / `skills/execute-tests/references/safety-rules.md`. **Grep verifies discovery-intake/SKILL.md and generate-sow/SKILL.md DO NOT contain hard-rules duplicate content** (verified by `grep "Sandbox only\|No deletions\|No destructive" dydx-delivery/skills/discovery-intake/SKILL.md dydx-delivery/skills/generate-sow/SKILL.md` — zero hits in body of those skills' hard-rules blocks per AUDIT-05.1 / `AUDIT.md:362-381`).

**Reconciliation:** The 4 files in AUDIT-05.1 (above table) are the ground truth. D-59's nomination appears to be a CONTEXT.md error — discovery-intake and generate-sow don't carry hard-rules duplicates per AUDIT-05.1 evidence. **Planner action:** ignore D-59's named files; use AUDIT-05.1's 4 files (or 3 files + 1 canonical lift). Surface this discrepancy to the user before W2 kickoff if uncertain. The D-59 *wording* of the one-line pointer is still authoritative.

### Skill `based_on_*` field state — already snake_case (grep verified 2026-05-10)

```
SKILL.md files (5 occurrences):
  generate-sow/SKILL.md:79                     based_on_discovery: 00_discovery_v{N}.md       ← filename needs renumber to 02_discovery_v{N}.md
  generate-functional-spec/SKILL.md:81         based_on_sow: 01_sow_v{N}.md                   ← filename needs renumber to 03_sow_v{N}.md
  generate-technical-spec/SKILL.md:105         based_on_functional_spec: 02_functional-spec_v{N}.md  ← filename needs renumber to 04a_fnspec-platform_v{N}.md
  generate-build-prompt/SKILL.md:118-119       based_on_technical_spec: 03_technical-spec_v{N}.md / based_on_test_plan: test-plan_v{N}.md  ← renumber to 05_techspec / 08b_test-plan
  generate-test-plan/SKILL.md:99               based_on_technical_spec: 03_technical-spec_v{N}.md   ← renumber to 05_techspec_v{N}.md

Template files (8 occurrences):
  generate-sow/references/sow-template.md:7                          based_on_discovery: 00_discovery_v<N>.md
  generate-functional-spec/references/functional-spec-template.md:7  based_on_sow: 01_sow_v<N>.md
  generate-technical-spec/references/technical-spec-template.md:7    based_on_functional_spec: 02_functional-spec_v<N>.md
  generate-test-plan/references/test-plan-template.md:7              based_on_technical_spec: 03_technical-spec_v<N>.md
  generate-build-prompt/references/build-prompt-template.md:7-8      based_on_technical_spec / based_on_test_plan
  execute-tests/references/results-template.md:6                     based_on_test_plan: test-plan_v<N>.md
```

**KEY FINDING:** All 13 `based_on_*` keys are already snake_case. The "normalisation" in FOUND-05 is **filename-value renumbering, not key-name casing**. The renumber surface and the `based_on_*` normalisation surface are the **same surface**.

### Templates' "Stage N" self-labels — DESIGN-02 substage-aware corrections

```
intake-template.md:13                "Stage 0 of the dydx-delivery pipeline"          → "Stage 2" (Discovery)
sow-template.md                       (no Stage N label — sole template without one)   → optionally add "Stage 3"
functional-spec-template.md:13       "Stage 2 of the dydx-delivery pipeline"          → "Stage 4a" (fnspec-platform per DESIGN-20)
technical-spec-template.md:13        "Stage 3 of the dydx-delivery pipeline"          → "Stage 5" (techspec)
test-plan-template.md:17             "Stage 5 of the dydx-delivery pipeline"          → "Stage 8b" (per DESIGN-02)
build-prompt-template.md:15          "Stage 6 of the dydx-delivery pipeline"          → "Stage 7a" (per DESIGN-02)
results-template.md:18               "Stage 6 of the dydx-delivery pipeline"          → "Stage 8d" (per DESIGN-02) — resolves AUDIT-05.5 [NEW] label collision
```

### Sandbox-block bug — content-level, not config-level

`dydx-delivery/skills/execute-tests/references/safety-rules.md:30-40` (the current §3 block):

```
## 3. No destructive integrations outside scope

These actions are refused unless the test plan explicitly lists them in scope AND the integration is pointed at a sandbox / mock endpoint:

- Sending real emails to non-test recipients
- Posting to real Slack channels (only `#test-*` channels permitted)
- Triggering real Ziflow proofs (sandbox project only)
- Triggering real billing or invoice generation
- Calling third-party publishing APIs (social, CMS push)
```

**Bug:** Coda is not in this enumerated list of integration types. The runner's intent is "refuse destructive integrations unless explicitly scoped"; the absence of Coda means **the Stage 6 cost-estimate writes + Stage 11 brain-mirror Coda upserts have no positive authorisation** in the sandbox-rules narrative. CRIT-5 / D-62 fix = add a positive authorisation clause:

```
- Coda writes ARE permitted against the per-client sandbox doc/table identified in the test plan
  frontmatter `sandbox.coda_doc:` block. Coda writes targeting any other doc are refused
  (treated as "out_of_sandbox" per Rule 1).
```

This is a content edit to the new plugin-level `safety-rules.md`, NOT a code/config change. There is no sandbox-allowlist *config file* to patch — the allowlist is text inside the rules document.

### `commands/` / `agents/` / `hooks/` location — `dydx-delivery/<dir>/`, NOT inside `.claude-plugin/`

DESIGN-11 layout at `.planning/DESIGN.md:284-329` puts `commands/`, `agents/`, `hooks/` as siblings of `skills/` directly under `dydx-delivery/`. CONTEXT D-56 + canonical_refs file list confirms (`dydx-delivery/commands/`, `dydx-delivery/agents/`, `dydx-delivery/hooks/`). **`.gitkeep` is required** to ship them empty (Git does not track empty dirs). DESIGN-04 says `mcpServers` field lives in `dydx-delivery/.claude-plugin/plugin.json` — that's a manifest field, not a directory.

---

## Approach

### Recommended sequencing — already locked by D-60 + D-61

| Wave | Plan | Requirements | Builds on | Natural plan groupings |
|------|------|--------------|-----------|------------------------|
| W1 | `05-01-PLAN.md` | FOUND-01, 02, 03, 04, 12 | nothing (root) | (1) Status-lifecycle survey re-run FIRST (D-61) → (2) author 4 canonical refs in parallel (no shared file-ownership conflicts since each ref is a distinct new file) |
| W2 | `05-02-PLAN.md` | FOUND-05, 06 | W1 (canonical refs must exist before skills repoint at them) | 7 skills serialized by file-ownership (each SKILL.md + its template is one task); D-58 renumber + D-59 pointer + filename `based_on_*` renumber all batched per skill |
| W3 | `05-03-PLAN.md` | FOUND-07, 08, 09 | W1 (independent of W2 — different files) | `plugin.json` + `marketplace.json` version sync serialized (same file family); LICENSE + 3 scaffold dirs parallel |
| W4 | `05-04-PLAN.md` | FOUND-10, 13 | W1 (references/ dir must exist) | Web research items (Q06.1 / Q07.1 / Q09 / Q13 / Q25) → live MCP probe (Q10 / Q11 / Q12) → `connector-matrix.md` authoring → `OPEN-QUESTIONS.md` row flips |
| W5 | `05-05-PLAN.md` | FOUND-11 | W3 (LICENSE = B.4 cross-ref) | 5 cosmetic fixes: B.1 + B.2 + B.3 + B.6 (B.4 cross-references W3) — distinct files, can parallelise |

### Cross-wave dependencies (file-ownership locks)

- `.planning/OPEN-QUESTIONS.md` — W4 mutates 8 rows (Q06.1 / Q07.1 / Q09 / Q10 / Q11 / Q12 / Q13 / Q25 status flips). Sole writer is W4.
- `dydx-delivery/.claude-plugin/plugin.json` — W3 (version sync only).
- `.claude-plugin/marketplace.json` — W3 (version sync + homepage add — B.6 cosmetic fix actually lands in W3, NOT W5; W5 just documents the closure).
- `dydx-delivery/README.md` — W2 (hard-rules pointer replacement) + W5 (B.1 truncation fix + B.3 pipeline-step-count fix). Force serial W2 → W5 OR scope-split (W2 only touches the hard-rules block at lines 99-105; W5 touches different lines).
- `dydx-delivery/skills/execute-tests/references/safety-rules.md` — W1 (lift content out per D-62) + W2 (collapse to one-line pointer per D-59). Two distinct edits — sequence W1 → W2.

### CONTEXT D-60 quirk: B.6 timing

D-60's wave table puts B.6 (homepage asymmetry) in W5 under FOUND-11. But B.6 = "add `homepage` field to `marketplace.json`", and W3 already opens `marketplace.json` for version sync. **Two options:**
1. W3 lands B.6 too (one-shot edit to marketplace.json) — minimum touches, but B.6 attribution moves from FOUND-11 to FOUND-07.
2. W5 lands B.6 separately (per D-60) — two passes on same file.

**Recommendation:** Option 1 (W3 handles B.6 inline with version sync); W5's FOUND-11 task list still references B.6 with "completed by W3 — see commit X" footnote. Planner adjudicates with user if uncertain.

---

## Canonical References Content Design

### `dydx-delivery/references/safety-rules.md` (FOUND-01)

**Source:** D-62 = lift-and-fix from `dydx-delivery/skills/execute-tests/references/safety-rules.md` (current 101 lines, 10 numbered rules).

**Required content (mapped to DESIGN-03 at `.planning/DESIGN.md:93-104`):**

1. **All 10 existing rules from the source file, verbatim** (Rules 1-10 covering: sandbox enforcement, no deletions, no destructive integrations, read-write only, audit trail, rate limiting, stop conditions, concurrency, cleanup, reporting).
2. **CRIT-5 fix — add Coda-sandbox positive authorisation** inside Rule 3 (or as new Rule 3.1). Text:
   ```
   - Coda writes ARE permitted against the per-client sandbox doc/table identified in the test
     plan frontmatter `sandbox.coda_doc:` block. Coda writes targeting any other doc are refused
     (treated as "out_of_sandbox" per Rule 1).
   ```
3. **Per-client override mechanism reference** per DESIGN-03: a paragraph naming `<Client> Brain/safety-overrides.yaml` and the `overridable: true` field gate. Non-overridable rules listed explicitly (Rule 1 sandbox enforcement + Rule 3 hard-stop integration safety).
4. **DESIGN-03 cross-reference block** at top — "Canonical SoT for hard rules per DESIGN-03 (`.planning/DESIGN.md:93-104`). Override resolution: skill loads canonical SoT → loads per-client overlay if present → applies overrides only to `overridable: true` fields."
5. **Confidence: HIGH** [VERIFIED: existing `execute-tests/references/safety-rules.md` lines 1-101]

### `dydx-delivery/references/stage-numbering.md` (FOUND-02)

**Source:** DESIGN-02 contract at `.planning/DESIGN.md:78-89`.

**Required content (mapped to DESIGN-02):**

1. **Canonical v2 stage table:** Stage 1 through Stage 11 with file-prefix, skill name, output filename pattern, downstream consumer. Use the exact DESIGN-02 wording.
2. **Substage suffix policy:** `4a` / `4b` / `7a` / `7b` / `8a` / `8b` / `8c` / `8d` with the per-substage skill assignments (per DESIGN-12 inventory matrix at `.planning/DESIGN.md:341-364`).
3. **Old → new mapping table** (verbatim from DESIGN-02):
   | v0.3.0 prefix | v2 prefix | Stage | Notes |
   |---|---|---|---|
   | `00_discovery_*` | `02_discovery_*` | Stage 2 | discovery-intake MODIFIED |
   | `01_sow_*` | `03_sow_*` | Stage 3 | generate-sow UNCHANGED-structure |
   | `02_functional-spec_*` | `04a_fnspec-platform_*` | Stage 4a | SPLIT into 4a + 4b per DESIGN-20; legacy `generate-functional-spec` RETIRED |
   | `03_technical-spec_*` | `05_techspec_*` | Stage 5 | generate-technical-spec MODIFIED |
   | `04_build-prompt_*` | `07a_build-prompt-dev_*` | Stage 7a | generate-build-prompt MODIFIED (dev path) |
   | `test-plan_v*` | `08b_test-plan_*` | Stage 8b | path also moves to `<Client> Brain/test-bot/test_cases/` |
   | `results-YYYY-MM-DD_v*` | `08d_test-results_*` | Stage 8d | resolves AUDIT-05.5 [NEW] label collision |
4. **Lenient-mode policy** (DESIGN-08 cross-ref): v0.3.0 in-flight artefacts NEVER renamed — readers tolerate old prefixes permanently per OPEN-Q15 decision.
5. **Confidence: HIGH** [CITED: `.planning/DESIGN.md:78-89` + `.planning/DESIGN.md:341-364`]

### `dydx-delivery/references/frontmatter-scheme.md` (FOUND-03)

**Source:** DESIGN-01 contract at `.planning/DESIGN.md:62-74` + DESIGN-08 at `.planning/DESIGN.md:181-193`.

**Required content (mapped to DESIGN-01 + DESIGN-08):**

1. **Status lifecycle:** `draft → client_review → approved → archived`. `client_review` is retained per the live status-lifecycle survey (DESIGN.md `### Live status-lifecycle survey`).
2. **Field-name convention:** underscore-snake-case for keys (`based_on_kickoff`, `pipe_id`, `approved_by`, `approved_at`, `tier_claims_last_verified`); hyphen-kebab-case for file paths inside `based_on_*` values.
3. **Platform-gated identifiers rule:** `pipe_id` / `space_id` / `project_id` may only appear when the artefact's `platform:` value is active for that identifier.
4. **`frontmatter_version: 2` semantics:** mandatory on new v2 artefacts; absent → v0.3.0 lenient mode per DESIGN-08.
5. **Lenient-mode contract** (OPEN-Q15 decision — PERMANENT, not tied to a cutover date): v2 readers tolerate v0.3.0 frontmatter absent `frontmatter_version` field; do not raise on missing `archived` status / `frontmatter_version: 2` / `approved_by` / `approved_at` on pre-v2.1 artefacts.
6. **In-flight artefacts NEVER auto-flip** per DESIGN-08; migration is opt-in per CR.
7. **Approval-gate fields:** `status: approved` writes carry mandatory `approved_by: <human-name>` (NOT `Claude` / `AI` / `system`) + `approved_at: <ISO-8601 timestamp>` per DESIGN-06.
8. **Confidence: HIGH** [CITED: `.planning/DESIGN.md:62-74` + `.planning/DESIGN.md:181-193` + `.planning/DESIGN.md:147-158`]

### `dydx-delivery/references/glossary.md` (FOUND-04)

**Source:** DESIGN.md Appendix A glossary (69 entries per Phase 2 02-10 plan, per ROADMAP line 233 last-update note).

**Required content scope:**

- Terms covering: frontmatter fields / status lifecycle states / stage prefixes / platform terms (Pipefy / Wrike / Ziflow) / test-bot terms / plugin surfaces (commands / agents / hooks) / doc + sign-off terms.
- Recommend **lifting DESIGN.md Appendix A verbatim** as the v2 baseline, then narrow scope to plugin-runtime terms (drop design-process-only terms like "structural-check.sh").
- Add entries surfaced by FOUND-13 OPEN-Q research: "Claude for Chrome" / "Claude in Chrome" canonical naming (Q09); `host` field source-of-truth for Wrike (Q13).
- **Confidence: MEDIUM** — DESIGN.md Appendix A was scoped for the design milestone; Phase 5 glossary should narrow to plugin-runtime terms. Planner should re-scope during W1.

---

## Skill Repoint Mechanics

### Hard-rules pointer wording (locked by D-59 — verbatim)

```
> **Hard rules:** Sandbox-only operations. Read-write only against named sandbox tenants. Refuses destructive actions. See `dydx-delivery/references/safety-rules.md` for the canonical ruleset.
```

This wording lands at:

| File | Line range to replace | Current content |
|------|----------------------|----------------|
| `dydx-delivery/skills/execute-tests/SKILL.md` | 20-30 (heading `## Hard rules — enforced regardless of test plan content` + 7-rule numbered list) | 11 lines |
| `dydx-delivery/skills/generate-test-plan/references/test-plan-template.md` | 36-44 (heading `## Hard rules (enforced by execute-tests)` + 5 condensed bullets) | 9 lines |
| `dydx-delivery/README.md` | 99-105 (heading `## Test execution — safety rules (hard)` + 5 condensed bullets at 101-105) | 7 lines |
| `dydx-delivery/skills/execute-tests/references/safety-rules.md` | full file (101 lines) | REPLACE with one-line pointer per D-59 — preserves cite-anchor stability for any external reference |

**The 4th file is the canonical-becoming-pointer.** D-62 says: lift content to plugin-level `dydx-delivery/references/safety-rules.md`, then collapse skill-internal file to one-line pointer (NOT delete — keeps existing references from skill SKILL.md prose like `execute-tests/SKILL.md:22` "Read these in `references/safety-rules.md`" still resolvable).

### `based_on_*` filename renumber (per D-58 — applies to BOTH skill bodies AND templates)

13 `based_on_*` value-strings to update (all verified `file:line` in §Codebase Reality). Apply DESIGN-02 mapping:

| File:line | Old value | New value |
|-----------|-----------|-----------|
| `generate-sow/SKILL.md:79` | `based_on_discovery: 00_discovery_v{N}.md` | `based_on_discovery: 02_discovery_v{N}.md` |
| `generate-sow/references/sow-template.md:7` | `based_on_discovery: 00_discovery_v<N>.md` | `based_on_discovery: 02_discovery_v<N>.md` |
| `generate-functional-spec/SKILL.md:81` | `based_on_sow: 01_sow_v{N}.md` | `based_on_sow: 03_sow_v{N}.md` |
| `generate-functional-spec/references/functional-spec-template.md:7` | `based_on_sow: 01_sow_v<N>.md` | `based_on_sow: 03_sow_v<N>.md` |
| `generate-technical-spec/SKILL.md:105` | `based_on_functional_spec: 02_functional-spec_v{N}.md` | `based_on_functional_spec: 04a_fnspec-platform_v{N}.md` |
| `generate-technical-spec/references/technical-spec-template.md:7` | `based_on_functional_spec: 02_functional-spec_v<N>.md` | `based_on_functional_spec: 04a_fnspec-platform_v<N>.md` |
| `generate-test-plan/SKILL.md:99` | `based_on_technical_spec: 03_technical-spec_v{N}.md` | `based_on_technical_spec: 05_techspec_v{N}.md` |
| `generate-test-plan/references/test-plan-template.md:7` | `based_on_technical_spec: 03_technical-spec_v<N>.md` | `based_on_technical_spec: 05_techspec_v<N>.md` |
| `generate-build-prompt/SKILL.md:118` | `based_on_technical_spec: 03_technical-spec_v{N}.md` | `based_on_technical_spec: 05_techspec_v{N}.md` |
| `generate-build-prompt/SKILL.md:119` | `based_on_test_plan: test-plan_v{N}.md` | `based_on_test_plan: 08b_test-plan_v{N}.md` |
| `generate-build-prompt/references/build-prompt-template.md:7` | `based_on_technical_spec: 03_technical-spec_v<N>.md` | `based_on_technical_spec: 05_techspec_v<N>.md` |
| `generate-build-prompt/references/build-prompt-template.md:8` | `based_on_test_plan: test-plan_v<N>.md` | `based_on_test_plan: 08b_test-plan_v<N>.md` |
| `execute-tests/references/results-template.md:6` | `based_on_test_plan: test-plan_v<N>.md` | `based_on_test_plan: 08b_test-plan_v<N>.md` |

### Other renumber surfaces in skill bodies (non-`based_on_*` references to filenames)

Grep candidates per skill (cross-check before W2):
- `discovery-intake/SKILL.md` — references `00_discovery_v*.md` in prose (e.g., line 33 "files matching `00_discovery_v*.md`"). Renumber to `02_discovery_v*.md`.
- `generate-sow/SKILL.md` — references `00_discovery_v*.md`, `01_sow_v*.md` prose. Renumber.
- All 7 skills — output path references in `## Output` sections need renumbering.

### Template "Stage N" self-labels (per renumber section above)

7 templates carry "Stage N" self-labels; 5 need updating (sow-template.md has none; intake/functional-spec/technical-spec/test-plan/build-prompt/results all need new labels per the §Codebase Reality table).

---

## File Renumbering Surface — what counts as "in-flight" (DESIGN-08)

**In scope (Phase 5 renumbers):**
- Skill SKILL.md prose references to artefact filenames
- Skill internal template example filenames (`*-template.md` files in `skills/<name>/references/`)
- `based_on_*` value strings (per table above)
- Template "Stage N" self-labels
- `stage-numbering.md` canonical mapping table (NEW file)

**Out of scope (NEVER renumbered):**
- v0.3.0 artefact files already on disk in client folders (`<Client> Brain/<Project>/00_discovery_v3.md` etc.)
- Filesystem renames of skill internal templates themselves (e.g., the file `00_discovery_v1.md` example INSIDE a template documentation file stays as a textual example unchanged — though the rendered example text gets renumbered)
- Historical commit messages, PRs, docs in `.planning/` that reference old prefixes

**Lenient-mode contract:** v2 readers (the validate-frontmatter hook, future skills) tolerate old prefixes via the `frontmatter_version` field. Absent value → assume v0.3.0 conventions. **This is permanent**, not a cutover-driven transition (per OPEN-Q15 decision).

---

## Manifest Sync to 2.0.0 (FOUND-07)

### `dydx-delivery/.claude-plugin/plugin.json` — exact key updates

| Line | Key | Current | New |
|------|-----|---------|-----|
| 3 | `version` | `"0.3.0"` | `"2.0.0"` |

**Single key edit. All other keys preserved verbatim, including `author.email: "jasonmichaelb@gmail.com"` per UAT-3.1.**

### `.claude-plugin/marketplace.json` — exact key updates

| Line | Key | Current | New |
|------|-----|---------|-----|
| 9 | `metadata.version` | `"1.2.0"` | `"2.0.0"` |
| 16 | `plugins[0].version` | `"0.3.0"` | `"2.0.0"` |
| — | `plugins[0].homepage` (NEW field, B.6 fix) | (absent) | `"https://github.com/SonofJay13/dydx-project-workflow"` |

**Owner-email at `marketplace.json:5` preserved verbatim per UAT-3.1.**

### Out-of-scope (deferred, not in FOUND-07):

- `mcpServers` field on `plugin.json` (DESIGN-04 contract calls for it — defer to later v2.x phase OR add inline if planner adjudicates).
- `plugins[0].description` text on `marketplace.json:15` (currently mentions "Seven skills" — accurate for v0.3.0; v2.0.0 is 13-skill end-state but FOUND-07 scope is narrow). Defer.
- `keywords` array updates. Defer.
- `dydx-delivery/.claude-plugin/plugin.json:4` `description` text. Defer.
- `dydx-delivery/.claude-plugin/plugin.json:10` `license: "Proprietary"` — backed by FOUND-08 LICENSE file; no change needed.

---

## LICENSE Content (FOUND-08)

**Exact byte content (locked by OPEN-Q23 decision):**

```
All rights reserved.
Not licensed for redistribution.
```

**File path:** repo root — `C:/Users/Jason Blignaut/Documents/Coding/dydx-project-workflow/LICENSE`. NOT `dydx-delivery/LICENSE`. Per CHANGELIST.md `:223` Appendix B item B.4 and OPEN-Q23 resolution at `OPEN-QUESTIONS.md:407-409`.

**Format:** Plain UTF-8 text, 2 lines, no trailing newline strictly required but conventional. No frontmatter, no markdown headers, no copyright year line.

**Verification (byte-exact):**
```
$ wc -l LICENSE       # → 2 lines (or 1 if no trailing newline)
$ cat LICENSE
All rights reserved.
Not licensed for redistribution.
```

---

## Scaffold Dirs (FOUND-09)

**Three new empty directories at plugin root:**

```
dydx-delivery/commands/
dydx-delivery/agents/
dydx-delivery/hooks/
```

**Each carries a `.gitkeep`** (zero-byte file) to make the empty dir trackable by git. Alternative: a single-line `README.md` in each explaining the scaffold-only status; D-60's W3 plan slice says "empty `commands/` / `agents/` / `hooks/` scaffold dirs" — `.gitkeep` is minimal and conventional.

**Confidence: HIGH** [VERIFIED: dirs do not currently exist; DESIGN-11 puts them at plugin-root level]

---

## Connector Matrix Schema (FOUND-10)

### Location

`dydx-delivery/references/connector-matrix.md` (per CONTEXT D-56 + canonical_refs list).

### Doc-only (per D-56)

NO slash command. NO agent. NO probe hook. Skills read it at session start by simple file include. Manual re-run via `claude mcp list` against the matrix.

### Required matrix dimensions

**6 connectors × 11 stages = 66-cell grid** plus per-stage fallback narrative.

**The 6 connectors (per FOUND-10 + UAT-3.5 lock):**

| Connector | Probe method | Owner phase for in-depth integration |
|-----------|--------------|--------------------------------------|
| Coda MCP | `claude mcp list` + `whoami` cheap-read | Phase 6+ (Stage 6 cost / Stage 11 brain mirror) |
| Google Workspace MCP (Drive / Gmail / Calendar) | `claude mcp list` + `list_recent_files` / `list_labels` / `list_calendars` | Phase 8+ (Stage 9 doc publish) |
| Miro MCP | `claude mcp list` + `board_search_boards` | Phase 7+ (Stage 1 Kickoff workflow ingest) |
| Pipefy API (GraphQL) | HTTP GET probe `https://api.pipefy.com/graphql` (returns 200/401) | Phase 6 PLAT-01 |
| Wrike API (REST) | OAuth token-exchange dry-run | Phase 6 PLAT-02 |
| Ziflow API (REST) | OAuth token-exchange dry-run | Phase 6 PLAT-03 |

### Cell value enum

| Value | Meaning |
|-------|---------|
| REQUIRED | Stage cannot run without this connector |
| GRACEFUL | Stage degrades to fallback if connector missing |
| N/A | Stage does not use this connector |

### Per-stage fallback narrative — required rows (per DESIGN-07 + FOUND-10)

| Stage | Connector dependency | Fallback if missing |
|-------|---------------------|---------------------|
| Stage 1 Kickoff | Miro MCP (GRACEFUL) | Paste-fallback mode — workflow-map ingest via copy-paste |
| Stage 1 Kickoff | Coda MCP (GRACEFUL) | Field Notes triage via paste-from-Coda |
| Stage 6 Cost estimate | Coda MCP (GRACEFUL) | Manual mode — cost estimate emitted as local `.md` only; Coda upsert deferred |
| Stage 9 Documentation | Google Drive MCP (REQUIRED) | HALT with explicit error; Stage 9 cannot complete without Drive |
| Stage 10 Native-AI | Pipefy/Wrike/Ziflow API (N/A — UAT-6.1 locked native-AI to paste-only) | N/A — humans paste manually per UAT-6.1 lock |
| Stage 11 Sign-off | Coda MCP (GRACEFUL) | Local brain only — Coda one-way mirror push skipped; logged for retry |
| Stage 8 Test bot | Pipefy/Wrike/Ziflow API (REQUIRED for execute-tests against sandbox) | HALT — runner cannot execute sandbox tests without platform API |

### Session-start probe schema (per DESIGN-07)

The matrix documents probe behaviour textually; actual probe runtime is later phase. Document:
- `claude mcp list` returns transport status (`✓ Connected` / `! Needs authentication` / not-listed)
- Per-MCP cheap-read endpoint (table in §FOUND-10 above)
- Probe cache: `connector_probe.yaml` session-scoped file (per DESIGN-07 — schema specification deferred to v2.6 / SURF-01..03 per CONTEXT D-56)

---

## Status Survey Re-run (FOUND-12, OPEN-Q16)

### What OPEN-Q16 requires

Re-confirm no drift in `status:` values across live `<Client> Brain/` folders since the 2026-05-10 DESIGN-08 sample. Sample at that date showed `{draft, client_review, approved}`; canonical lifecycle adds `archived` (additive only; Stage 11 writes only).

### Survey scope

**Established Coda brain doc clients (per OPEN-Q17 decision):**
- **The Up & Up Group** (M&C Saatchi Process Automation): https://coda.io/d/M-C-Saatchi-Process-Automation_dITb4lVmQ67/The-Up-Up-Brain_sux7GT-N#_luUaEH88
- **VodafoneZiggo:** https://coda.io/d/VodafoneZiggo_dUW9wD-EKrb/VFZ-Brain-Do-Not-Delete-speak-to-Jason_suHgD2Jd
- **Other clients:** TBD — no Coda brain doc yet; bootstrapped at first Stage 11 archive.

### Methodology (two options for planner adjudication)

**Option A (rigorous):** Use Coda MCP `page_read` against the 2 known brains' subpages (Overview / Workflows / Platforms / Integrations / Operating Model / Change History / Field Notes per DESIGN-27 spoke layout). Extract any `status:` token from page YAML/frontmatter or table cells. Log per-brain distinct values found.

**Option B (DESIGN-08 fallback):** Re-run the DESIGN-08 SKILL.md-only survey methodology — sample all `status:` literals in v0.3.0 + (new) v2.0 SKILL.md sources. Documents the no-live-folder fallback transparently and timestamps it 2026-05-10.

**Recommendation: Option A** — Coda MCP is wired and working per AUDIT-08; the 2 brain URLs are known; data-driven survey is strictly more rigorous than the SKILL.md fallback. **Confidence: MEDIUM** — Coda MCP probe success depends on per-doc permission; Wave 1 runner needs read access to both brains. If access denied → fall back to Option B with documented "no-access" deviation.

### Deliverable

A `status-lifecycle-survey-2026-05-10.md` file (or section in `frontmatter-scheme.md`) documenting:
1. Methodology + sample sources (per option chosen)
2. Distinct values found
3. Reconciliation against canonical `{draft, client_review, approved, archived}`
4. Conclusion: "no drift" or "drift detected — adjudication required"

---

## AUDIT-07 Cosmetic Fixes (FOUND-11)

### B.1 — README truncation (plugin-level)

- **Citation:** `dydx-delivery/README.md:126` — Changelog reads `**0.3.0** — Renamed `generate-test-sheet` → `generate-test-plan` (and `test-sheet_v*.md` → `test-plan_v*.md`) for clearer team-facing language. The bot-run terminal stage (`execute-tests`) now c` and terminates mid-word.
- **Fix:** Complete the sentence. Suggested completion (subject to user confirmation):
  ```
  ...The bot-run terminal stage (`execute-tests`) now carries explicit sandbox-enforcement
  rules in `references/safety-rules.md`; results are written to versioned
  `results-YYYY-MM-DD_vN.md` files.
  ```
  Alternative minimal completion: just close with `.` after `now c` (clarity-incomplete; not recommended).
- **Confidence: HIGH** [VERIFIED: `dydx-delivery/README.md:126` reads "now c" with no further entries]

### B.2 — Residual "test sheet" wording

- **Citation:** `README.md:9` (root) — "Stage-gated client delivery pipeline (discovery → SOW → functional spec → technical spec → **test sheet** → execution)".
- **Fix:** Replace `test sheet` with `test plan`. Single literal substitution.
- **Confidence: HIGH** [VERIFIED: `README.md:9`]

### B.3 — Pipeline-step count mismatch (root README)

- **Citation:** `README.md:9` lists 5 steps ("discovery → SOW → functional spec → technical spec → test sheet → execution") — actually 6 arrows = 6 steps, not 5 as flagged in AUDIT-07. Plugin README (`dydx-delivery/README.md:33-41`) lists 7 skills (rows). marketplace.json:15 says "Seven skills".
- **Fix:** AUDIT-07 says "correct to 13" (v2 end-state). But the v2.0 README description in marketplace.json says "Seven skills" still. **Two valid choices:**
  - (i) Match v0.3.0 reality (7 skills): rewrite the pipeline line to enumerate all 7 stages
  - (ii) Match v2 end-state (13 skills per DESIGN-12): forward-state the README to "13 skills"
- **Recommendation:** Option (i) for v2.1 — the plugin still SHIPS 7 v0.3.0 skills until Phase 6+ adds platforms (`generate-functional-spec` still exists; gets RETIRED in v2.2 per DESIGN-12). v2.1 README change should reflect current v2.1 shipped reality. Re-update root README in v2.2+ once 13-skill end-state lands.
- **Confidence: MEDIUM** — choice between v0.3.0 vs v2 end-state requires user adjudication. Surface as decision in W5.

### B.4 — LICENSE creation

- **Cross-ref:** Covered by FOUND-08. W5 documentation only — actual fix in W3.

### B.5 — Owner-email — **NO FIX** (UAT-3.1)

- **Citation:** `dydx-delivery/.claude-plugin/plugin.json:7` and `.claude-plugin/marketplace.json:5` both list `jasonmichaelb@gmail.com`. INTENTIONAL per dYdX Digital approval.
- **Action:** Document the no-fix decision in W5 SUMMARY. Verify no plan touches the email keys.

### B.6 — Homepage asymmetry

- **Citation:** `dydx-delivery/.claude-plugin/plugin.json:9` carries `"homepage": "https://github.com/SonofJay13/dydx-project-workflow"`. `.claude-plugin/marketplace.json` has no `homepage` field on `plugins[0]`.
- **Fix:** Add `"homepage": "https://github.com/SonofJay13/dydx-project-workflow"` to the `plugins[0]` object in `.claude-plugin/marketplace.json`. Insert as last key of the plugins[0] object (line ~17 before closing `}`).
- **Timing:** Recommended W3 (single edit pass on marketplace.json) per §Approach Cross-wave dependencies; W5 documents closure.
- **Confidence: HIGH** [VERIFIED: marketplace.json has no `homepage` key]

---

## Validation Architecture (Nyquist Dimension 8)

> Required because there is no explicit `nyquist_validation: false` config — default treats validation as enabled. Test infrastructure: this is a documentation/scaffold phase, NOT a code phase — assertions are **grep-based**, **file-exists-based**, and **JSON-key-equality-based**, NOT pytest. Plugin self-test pytest suite is OPEN-Q22 deferred to Phase 9. Phase 5 validation runs via shell/PowerShell assertions in a `structural-check.sh` (or `.ps1`) sibling pattern of Phase 1-4 (see e.g. `.planning/phases/04-open-questions/scripts/openquestions-structure-check.sh`).

### Test Framework

| Property | Value |
|----------|-------|
| Framework | Shell assertions (Bash on macOS/Linux; PowerShell on Windows). Phase 1-4 used Bash via WSL; Phase 5 should reuse the convention. |
| Config file | None (per-wave script in `.planning/phases/05-foundations/scripts/`) |
| Quick run command | `bash .planning/phases/05-foundations/scripts/phase5-structure-check.sh` (per-wave script TBD) |
| Full suite command | `bash .planning/phases/05-foundations/scripts/phase5-structure-check.sh` (single script gates all 5 waves) |
| Phase gate | Script exits 0 (all assertions pass) before `/gsd-verify-work` |

### Phase Requirements → Assertion Map

| Req | Behaviour | Assertion type | Command / grep pattern | File exists? |
|-----|-----------|----------------|-----------------------|--------------|
| FOUND-01 | safety-rules.md plugin-level exists | file-exists | `test -f dydx-delivery/references/safety-rules.md` | ❌ Wave 0 |
| FOUND-01 | Coda sandbox clause present | grep | `grep -q "Coda writes ARE permitted" dydx-delivery/references/safety-rules.md` | ❌ Wave 0 |
| FOUND-01 | DESIGN-03 cross-ref present | grep | `grep -q "DESIGN-03" dydx-delivery/references/safety-rules.md` | ❌ Wave 0 |
| FOUND-02 | stage-numbering.md exists | file-exists | `test -f dydx-delivery/references/stage-numbering.md` | ❌ Wave 0 |
| FOUND-02 | Old→new mapping table present | grep | `grep -q "00_discovery_" dydx-delivery/references/stage-numbering.md && grep -q "02_discovery_" dydx-delivery/references/stage-numbering.md` | ❌ Wave 0 |
| FOUND-02 | Substages documented | grep | `grep -qE "4a.+4b" dydx-delivery/references/stage-numbering.md` | ❌ Wave 0 |
| FOUND-03 | frontmatter-scheme.md exists | file-exists | `test -f dydx-delivery/references/frontmatter-scheme.md` | ❌ Wave 0 |
| FOUND-03 | Lenient mode documented | grep | `grep -qi "lenient" dydx-delivery/references/frontmatter-scheme.md` | ❌ Wave 0 |
| FOUND-03 | client_review retained | grep | `grep -q "client_review" dydx-delivery/references/frontmatter-scheme.md` | ❌ Wave 0 |
| FOUND-04 | glossary.md exists | file-exists | `test -f dydx-delivery/references/glossary.md` | ❌ Wave 0 |
| FOUND-05 | Hard-rules duplicates collapsed | grep ZERO-HITS | `! grep -rln "Sandbox only.*No deletions" dydx-delivery/skills/ dydx-delivery/README.md` (excluding the canonical) — assert ZERO lines of multi-line duplicate blocks survive | ❌ Wave 0 |
| FOUND-05 | Uniform pointer wording present in 4 files | grep COUNT | `grep -l "See \`dydx-delivery/references/safety-rules.md\` for the canonical ruleset" dydx-delivery/skills/execute-tests/SKILL.md dydx-delivery/skills/generate-test-plan/references/test-plan-template.md dydx-delivery/README.md dydx-delivery/skills/execute-tests/references/safety-rules.md \| wc -l` returns `4` | ❌ Wave 0 |
| FOUND-05 | Coda allowlist in canonical safety-rules | grep | `grep -q "Coda writes ARE permitted" dydx-delivery/references/safety-rules.md` | ❌ Wave 0 (covered by FOUND-01) |
| FOUND-05 | based_on_* values renumbered (sample assertion) | grep ZERO-HITS | `! grep -rn "based_on_discovery: 00_discovery" dydx-delivery/skills/` (old prefix gone) | ❌ Wave 0 |
| FOUND-05 | based_on_* values renumbered (positive) | grep | `grep -rn "based_on_discovery: 02_discovery" dydx-delivery/skills/generate-sow/` returns ≥ 2 hits (SKILL.md + sow-template.md) | ❌ Wave 0 |
| FOUND-06 | All old-prefix filename references replaced in skill bodies | grep ZERO-HITS | `! grep -rn "01_sow_v\|02_functional-spec_v\|03_technical-spec_v\|04_build-prompt_v" dydx-delivery/skills/` (none of the old patterns survive in v2 prose) | ❌ Wave 0 |
| FOUND-06 | "Stage N" template self-labels updated | grep | per-template grep for new stage label (e.g., `grep -q "Stage 4a" dydx-delivery/skills/generate-functional-spec/references/functional-spec-template.md`) | ❌ Wave 0 |
| FOUND-07 | plugin.json version 2.0.0 | jq | `jq -r '.version' dydx-delivery/.claude-plugin/plugin.json` returns `2.0.0` | ❌ Wave 0 |
| FOUND-07 | marketplace.json metadata version 2.0.0 | jq | `jq -r '.metadata.version' .claude-plugin/marketplace.json` returns `2.0.0` | ❌ Wave 0 |
| FOUND-07 | marketplace.json plugins[0] version 2.0.0 | jq | `jq -r '.plugins[0].version' .claude-plugin/marketplace.json` returns `2.0.0` | ❌ Wave 0 |
| FOUND-07 | plugin.json author.email UNCHANGED | jq | `jq -r '.author.email' dydx-delivery/.claude-plugin/plugin.json` returns `jasonmichaelb@gmail.com` | ❌ Wave 0 |
| FOUND-07 | marketplace.json owner.email UNCHANGED | jq | `jq -r '.owner.email' .claude-plugin/marketplace.json` returns `jasonmichaelb@gmail.com` | ❌ Wave 0 |
| FOUND-08 | LICENSE file exists at repo root | file-exists | `test -f LICENSE` | ❌ Wave 0 |
| FOUND-08 | LICENSE content byte-exact | diff | `diff <(printf 'All rights reserved.\nNot licensed for redistribution.\n') LICENSE` returns empty | ❌ Wave 0 |
| FOUND-09 | commands/ dir exists | file-exists | `test -d dydx-delivery/commands` | ❌ Wave 0 |
| FOUND-09 | agents/ dir exists | file-exists | `test -d dydx-delivery/agents` | ❌ Wave 0 |
| FOUND-09 | hooks/ dir exists | file-exists | `test -d dydx-delivery/hooks` | ❌ Wave 0 |
| FOUND-09 | Each scaffold dir is empty (no substantive files) | shell | `[ "$(ls -1 dydx-delivery/commands/ \| grep -v '.gitkeep' \| wc -l)" -eq 0 ]` (repeat for agents/ hooks/) | ❌ Wave 0 |
| FOUND-10 | connector-matrix.md exists | file-exists | `test -f dydx-delivery/references/connector-matrix.md` | ❌ Wave 0 |
| FOUND-10 | 6 connectors documented | grep | All 6 connector names appear: `for c in "Coda MCP" "Google Workspace MCP" "Miro MCP" "Pipefy API" "Wrike API" "Ziflow API"; do grep -q "$c" dydx-delivery/references/connector-matrix.md \|\| exit 1; done` | ❌ Wave 0 |
| FOUND-10 | 11 stages addressed | grep COUNT | `grep -cE "^[\|\\| ]+Stage (1\|2\|3\|4\|5\|6\|7\|8\|9\|10\|11)" dydx-delivery/references/connector-matrix.md` returns ≥ 11 | ❌ Wave 0 |
| FOUND-10 | Fallback narrative present per stage | grep | grep for "fallback\|degrade\|HALT" per stage | ❌ Wave 0 |
| FOUND-11 | B.1 fix — README truncation closed | grep ZERO-HITS | `! grep -q "execute-tests\`) now c$" dydx-delivery/README.md` (no line ending in "now c") | ❌ Wave 0 |
| FOUND-11 | B.2 fix — "test sheet" wording removed | grep ZERO-HITS | `! grep -i "test sheet" README.md` | ❌ Wave 0 |
| FOUND-11 | B.3 fix — pipeline-step count updated | grep | `grep -q "pipeline" README.md` AND step count matches v2.1 reality | ❌ Wave 0 |
| FOUND-11 | B.6 fix — homepage in marketplace.json | jq | `jq -r '.plugins[0].homepage' .claude-plugin/marketplace.json` returns `https://github.com/SonofJay13/dydx-project-workflow` | ❌ Wave 0 |
| FOUND-11 | B.5 — owner-email UNCHANGED (negative assertion) | jq | (Covered by FOUND-07 assertions) | ❌ Wave 0 |
| FOUND-12 | Survey artefact exists | file-exists | `test -f dydx-delivery/references/frontmatter-scheme.md` (survey embedded as section) OR `.planning/phases/05-foundations/status-survey-2026-05-10.md` | ❌ Wave 0 |
| FOUND-12 | Survey conclusion present | grep | `grep -qi "no drift\|drift detected" <survey artefact>` | ❌ Wave 0 |
| FOUND-13 | 8 OPEN-Q rows flipped to `decided` | grep COUNT | For each of Q06.1/Q07.1/Q09/Q10/Q11/Q12/Q13/Q25: `grep -A1 "OPEN-Q06.1" .planning/OPEN-QUESTIONS.md \| grep -q "Status: decided"` (8 separate assertions OR a loop) | ❌ Wave 0 |
| FOUND-13 | Each resolved Q value present in connector-matrix.md | grep | E.g., Pipefy rate-limit value present; Wrike host SoT documented | ❌ Wave 0 |

### Sampling Rate

- **Per task commit:** Run targeted grep for that task's deliverable (e.g., after FOUND-08 commit, just `test -f LICENSE && diff <(...) LICENSE`).
- **Per wave merge:** Run full structure-check script for that wave's req IDs.
- **Phase gate:** Full structure-check passes (script exits 0) before `/gsd-verify-work`.

### Wave 0 Gaps

- [ ] Create `.planning/phases/05-foundations/scripts/phase5-structure-check.sh` (bash; mirrors Phase 1-4 pattern at `.planning/phases/<N>/scripts/`)
- [ ] No pytest needed — OPEN-Q22 defers plugin self-tests to Phase 9
- [ ] No framework install needed (bash + jq + grep are baseline)
- [ ] **Pattern reference:** `.planning/phases/04-open-questions/scripts/openquestions-structure-check.sh` (14 assertions A1..A14) — Phase 5 script structure should mirror, with ~40 assertions A1..A40 across all 13 FOUND-* requirements

---

## Open Questions Resolution (FOUND-13)

### Q06.1 — Pipefy 2026 rate-limit publication

**Question:** Has Pipefy published a 2026 rate-limit revision, or does the historic ~5 req/sec per token ceiling still apply?

**Answer (web research 2026-05-10):** Pipefy's current published GraphQL API rate limit is **500 requests per 30-second window** ≈ **16.67 requests/sec per token**. This is materially MORE generous than the historic ~5 req/sec figure cited in CHANGELIST and DESIGN-22. The "Pipe Reports Export" sub-limit is 50 requests / 24 hours / per pipe — separate, narrower limit.

**Source:** [Pipefy Community: What are the GraphQL API Limits?](https://community.pipefy.com/customs-apps-integrations-75/what-are-the-graphql-api-limits-958) — primary citation. Cross-ref: [Pipefy Help Center: How to use Pipefy's API](https://help.pipefy.com/en/articles/5580799-how-to-use-pipefy-s-api) and [Pipefy Developers](https://developers.pipefy.com/).

**Confidence:** MEDIUM [VERIFIED via web search; should be re-verified by direct API probe at Phase 6 PLAT-01 kickoff per Q06.2]

**Downstream impact:** DESIGN-22 (`.planning/DESIGN.md:795`) and PLAT-01 helper throttle target should recalibrate to 80% of 16.67 req/sec ≈ **13 req/sec** (NOT the previous 4 req/sec at 80% of 5 req/sec). This is a substantial freedom-increase for the Pipefy GraphQL client.

**`connector-matrix.md` cell value:** Pipefy API rate-limit: 500 req / 30s window (≈ 16.67 req/sec); throttle at 13 req/sec (80% buffer).

### Q07.1 — Wrike 2026 rate-limit publication

**Question:** Has Wrike published a 2026 rate-limit revision, or does the historic ~100 req/min per user still apply?

**Answer (web research 2026-05-10):** Wrike's current published REST API rate limits are **5000 requests/minute from the same IP** AND **400 requests/minute per user**. The lower (per-user) limit is the binding constraint for v2.1 helper design. Historic ~100 req/min per user is **outdated by 4×**.

**Source:** [Wrike Help Center: Resolve Common REST API Errors](https://help.wrike.com/hc/en-us/articles/23908384596631-Resolve-Common-REST-API-Errors). Cross-ref: [Wrike API Documentation](https://developers.wrike.com/) (primary), [Wrike: Rate Limiting API During Development](https://help.wrike.com/hc/en-us/community/posts/360017948653-Rate-Limiting-API-During-Development).

**Confidence:** MEDIUM [VERIFIED via web search; re-verify at Phase 6 PLAT-02 kickoff per Q07.2]

**Downstream impact:** DESIGN-22 (`DESIGN.md:795`) and PLAT-02 helper throttle: 80% of 400 req/min = **320 req/min per user** (≈ 5.3 req/sec) buffer.

**`connector-matrix.md` cell value:** Wrike API rate-limit: 400 req/min per user (5000 req/min per IP); throttle at 320 req/min per user.

### Q09 — Claude in Chrome canonical product naming

**Question:** What is the canonical 2026 product name?

**Answer (web research 2026-05-10):** **Both names are in active use by Anthropic.** Marketing/product page is "Claude for Chrome" (https://claude.com/claude-for-chrome). Help Center article is "Get started with Claude in Chrome" (https://support.claude.com/en/articles/12012173-get-started-with-claude-in-chrome). Chrome Web Store publisher page lists Anthropic with the extension. Status as of May 2026: in beta on all paid plans (Pro / Max / Team / Enterprise).

**Source:** [Claude for Chrome marketing page](https://claude.com/claude-for-chrome) ; [Claude Help Center: Get started with Claude in Chrome](https://support.claude.com/en/articles/12012173-get-started-with-claude-in-chrome) ; [Anthropic: Piloting Claude in Chrome](https://www.anthropic.com/news/claude-for-chrome) — note: Anthropic's own news post URL uses "claude-for-chrome" while the post title uses "Claude in Chrome", confirming interchangeable usage.

**Recommendation for the v2 glossary:** Use **"Claude for Chrome"** as primary (product page is canonical) with a glossary cross-reference noting "also Claude in Chrome (Help Center usage)". Confidence: HIGH that both are valid; LOW that Anthropic has formally declared one canonical over the other.

**`connector-matrix.md` cell value:** Not directly relevant to the matrix (Claude for Chrome is not a delivery-pipeline MCP). Glossary entry only.

### Q10 — Coda MCP wired + version pin

**Question:** Is Coda MCP wired at canonical version pin?

**Answer (live MCP probe via this session 2026-05-10):** **WIRED, WORKING.** This session's MCP instructions block at the top of the conversation confirms `claude.ai Coda` MCP server is active with full tool surface (document_create, page_*, table_*, formula_execute, search, whoami, url_convert, etc.). AUDIT-08 probe at 2026-05-09T17:05Z confirmed `whoami` returned authenticated user. Version pin endpoint: `apis/v1` per Coda public API path. **No drift since 2026-05-09 baseline.**

**Source:** AUDIT-08 (`.planning/AUDIT.md:543`); live session MCP instructions (this conversation).

**Confidence:** HIGH [VERIFIED in this session]

**`connector-matrix.md` cell value:** Coda MCP: WIRED + AUTHENTICATED; endpoint `apis/v1`; capabilities = full (document_create, page_read/create/update/delete, table_rows_manage/read/delete, table_create/delete, content_modify, formula_execute, comment_*, controls_*, whoami, search, url_convert).

**OPEN-QUESTIONS.md row flip:** Q10 status `proposed` → `decided` with citation "Re-confirmed wired + working 2026-05-10 (Phase 5 W4 probe; AUDIT-08 baseline unchanged)".

### Q11 — Google Workspace MCP server choice

**Question:** Is Google Workspace MCP wired? Which server (`taylorwilsdon` / `piotr-agier` / Anthropic-maintained)?

**Answer (probe required at Wave 4 — AUDIT-08 baseline guidance):** AUDIT-08 at `.planning/AUDIT.md:543` shows three separate Google MCP servers wired in this workspace at 2026-05-09 baseline:
- **Google Drive**: `claude.ai Google Drive` (tool prefix `mcp__claude_ai_Google_Drive__*`); endpoint `https://drivemcp.googleapis.com/mcp/v1` — Anthropic-maintained (Google-hosted `googleapis.com` domain confirms first-party).
- **Gmail**: `claude.ai Gmail`; endpoint `https://gmailmcp.googleapis.com/mcp/v1` — Anthropic-maintained.
- **Google Calendar**: `claude.ai Google Calendar`; endpoint `https://calendarmcp.googleapis.com/mcp/v1` — Anthropic-maintained.

**Answer:** **Anthropic-maintained (claude.ai-prefixed)** is the wired choice — NOT `taylorwilsdon` or `piotr-agier`. The three Google services run as separate MCP servers, not a unified "Google Workspace" server.

**Source:** AUDIT-08 (`.planning/AUDIT.md:543`).

**Confidence:** HIGH [VERIFIED via AUDIT-08 at 2026-05-09; Wave 4 should re-confirm via `claude mcp list` for drift]

**`connector-matrix.md` cell value:** Google Workspace = 3 separate Anthropic-maintained MCP servers (Drive / Gmail / Calendar) at `drivemcp.googleapis.com/mcp/v1`, `gmailmcp.googleapis.com/mcp/v1`, `calendarmcp.googleapis.com/mcp/v1`. Each WIRED + AUTHENTICATED per 2026-05-09 baseline.

### Q12 — Miro MCP wired vs paste-only

**Question:** Is Miro MCP wired or is the workflow paste-from-screenshot?

**Answer (AUDIT-08 baseline):** **WIRED + WORKING** at 2026-05-09T17:05Z. `board_search_boards` cheap-read returned 5 boards out of `total=920`. Server: `claude.ai Miro` (tool prefix `mcp__claude_ai_Miro__*`); endpoint `https://mcp.miro.com`.

**Source:** AUDIT-08 (`.planning/AUDIT.md:543`).

**Confidence:** HIGH [VERIFIED via AUDIT-08; Wave 4 re-probe for drift]

**`connector-matrix.md` cell value:** Miro MCP: WIRED + AUTHENTICATED; endpoint `https://mcp.miro.com`; fallback for clients without per-tenant Miro access = paste-from-screenshot (DESIGN-07 Stage 1 row).

### Q13 — Wrike host field source-of-truth

**Question:** Where is the per-tenant Wrike `host` field (from OAuth token exchange) persisted? Is it the same source-of-truth Stage 7b reads from?

**Answer (web research 2026-05-10):** Wrike's OAuth 2.0 token endpoint returns a `host` parameter as part of the token response (e.g., `"host": "www.wrike.com"`). This host identifies the regional data center for the tenant (USA / EU). **All subsequent API calls (including token refresh) MUST use the base URL built from this `host` value** — hardcoding `www.wrike.com` breaks multi-tenant deployments. The initial `https://login.wrike.com/oauth2/token` exchange is the ONLY non-regional endpoint; refresh-token calls go to the per-tenant host.

**Source:** [Wrike Developers: OAuth 2.0 Authorization](https://developers.wrike.com/oauth-20-authorization/). DESIGN-15 already locks this contract at `.planning/DESIGN.md:455`; AUDIT.md §AUDIT-01 catalogues `www.wrike.com` hardcoding as MOD-5 pitfall.

**Recommendation for v2 SoT:** Persist `wrike_host` alongside `coda_brain_doc:` in the per-client `<Client> Brain/00_HUB.md` Coda block (per DESIGN-29 schema at `.planning/DESIGN.md:795`); Stage 7b implementation prompt and Stage 8 test-bot `client_state.yaml.wrike.host:` both read from this single SoT. **Exact storage destination is Phase 6 PLAT-02 owner discretion** (per OPEN-Q13 non-binding recommendation note at `OPEN-QUESTIONS.md:229`).

**Confidence:** HIGH [VERIFIED via developers.wrike.com OAuth docs]

**`connector-matrix.md` cell value:** Wrike API: per-tenant `host` field from OAuth token response is canonical SoT; persisted at `<Client> Brain/00_HUB.md` Coda block (final destination TBD by Phase 6 PLAT-02).

### Q25 — Wrike + Ziflow auth-concurrency class

**Question:** Are Wrike and/or Ziflow auth sessions mutually `exclusive` (like Pipefy per UAT-4.2) or `shared`?

**Answer (web research 2026-05-10):** **INSUFFICIENT EVIDENCE.** Public Wrike + Ziflow docs do not explicitly document per-token concurrent-session class. Wrike's OAuth 2.0 spec implies one access-token-per-session pattern (standard OAuth 2.0); no explicit exclusivity rule documented. Ziflow's API auth supports per-user API keys + SSO (SAML 2.0) but does not document per-token exclusivity.

**Recommendation (per CONTEXT carry-through from OPEN-Q25 proposed default):** Assume **`exclusive`** for both, mirroring Pipefy precedent (UAT-4.2). Conservative — serialization-by-default is safer than concurrent-by-default. Stage 8 test-bot tier-1 should serialize per-tenant operations + emit `auth_switch_required` retry signals at tenant-boundary crossings per DESIGN-24 multi-tenant auth-concurrency serialization contract.

**Caveat:** This is a **default assumption pending live tenant test at Phase 6 PLAT-02 / PLAT-03 kickoff**. If concurrent Wrike API calls against 2 different tenants succeed without auth-switch in a live test, downgrade to `shared` for that platform.

**Source:** [Wrike Developers: OAuth 2.0 Authorization](https://developers.wrike.com/oauth-20-authorization/) ; [Ziflow API Documentation](https://api-docs.ziflow.com/) — neither explicitly documents per-token concurrent-session exclusivity.

**Confidence:** LOW [Web docs do not explicitly resolve; default `exclusive` is conservative inheritance from Pipefy precedent]

**`connector-matrix.md` cell value:** Wrike auth-concurrency: `exclusive` (DEFAULT — pending live tenant test). Ziflow auth-concurrency: `exclusive` (DEFAULT — pending live tenant test).

**OPEN-QUESTIONS.md row flip:** Q25 status `proposed` → `decided` with citation: "Default `exclusive` per Pipefy precedent + UAT-4.2 conservative-default policy; live tenant test deferred to Phase 6 PLAT-02 / PLAT-03 kickoff."

---

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | "Normalisation" of `based_on_*` field names = filename-value renumbering, NOT key-casing change | §Skill Repoint Mechanics / Summary item 3 | Plans miss a casing-related edit; mitigated by W2 grep assertion verifying all 13 `based_on_*` keys are snake_case (currently all are) |
| A2 | The 4 hard-rules duplicate files in AUDIT-05.1 supersede D-59's nominated file list | §Codebase Reality / Summary item 5 | Plans edit wrong files; mitigated by surfacing this discrepancy to the user before W2 |
| A3 | The sandbox-block bug (CRIT-5) is a content edit to the safety-rules narrative, not a code/config patch | §Codebase Reality / §Canonical Safety-rules | Plans look for a config file that doesn't exist; mitigated by ASSUMED tag + explicit grep audit during W1 |
| A4 | B.6 (marketplace.json homepage) should land in W3 alongside version sync, not W5 alongside B.1/B.2/B.3 | §Approach Cross-wave / B.6 detail | Two-pass edits on marketplace.json; planner can adjudicate either way without harm |
| A5 | Status-lifecycle survey via Coda MCP (Option A) is preferred over DESIGN-08 SKILL.md fallback (Option B) | §Status Survey Re-run | Survey is less rigorous if planner picks Option B; both options documented |
| A6 | Glossary scope = lift DESIGN.md Appendix A verbatim, narrow to plugin-runtime terms | §Canonical References / glossary.md | Glossary too broad/narrow; mitigated by W1 in-review with user |
| A7 | `mcpServers` field addition (per DESIGN-04) is deferred from Phase 5 scope (not in FOUND-07) | §Manifest Sync / Out-of-scope | Plugin manifest is incomplete vs DESIGN-04 contract; mitigated by adding `[OPEN]` marker if planner wants user input |
| A8 | Q06.1 + Q07.1 web research results (16.67 req/s Pipefy, 400 req/min Wrike) supersede the historic 5 req/s + 100 req/min ceilings cited in DESIGN-22 | §Open Questions Resolution Q06.1 / Q07.1 | DESIGN-22 throttle targets become 3× too conservative; minor inefficiency, not a defect — re-verify at Phase 6 |
| A9 | Q09 "Claude for Chrome" preferred over "Claude in Chrome" as glossary primary | §Open Questions Resolution Q09 | Glossary may contradict future Anthropic canonical declaration; mitigated by cross-reference entry |
| A10 | Q25 default `exclusive` for Wrike + Ziflow auth-concurrency is conservative — public docs don't explicitly resolve | §Open Questions Resolution Q25 | Stage 8 test-bot may serialize unnecessarily; conservative default safer than concurrent-default failure mode |
| A11 | "B.3 pipeline-step count" should target v2.1 reality (7 skills) not v2 end-state (13 skills) | §AUDIT-07 / B.3 | README forward-states or backward-states inconsistently; mitigated by surfacing to user in W5 |
| A12 | Q11 GWorkspace MCP answer = Anthropic-maintained (claude.ai-prefixed) servers per AUDIT-08 baseline | §Open Questions Resolution Q11 | Wave 4 re-probe finds drift since 2026-05-09 baseline; HIGH-confidence answer absent drift |
| A13 | The B.1 truncation completion text is suggested, not user-approved | §AUDIT-07 / B.1 | Suggested completion text may not match user's intent; mitigated by surfacing as W5 user-decision point |

---

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|------------|-----------|---------|----------|
| Coda MCP | FOUND-12 survey (Option A) + FOUND-13 Q10 probe | ✓ | endpoint `apis/v1` per AUDIT-08 | Option B SKILL.md-only fallback for FOUND-12 |
| Miro MCP | FOUND-13 Q12 probe | ✓ | `https://mcp.miro.com` | paste-from-screenshot documented in matrix |
| Google Drive/Gmail/Calendar MCP | FOUND-13 Q11 probe | ✓ (3 separate servers) | `mcp/v1` | none — confirms wiring |
| `claude mcp list` CLI | FOUND-13 Q10/Q11/Q12 re-probe | (assumed available in Claude Code session) | — | Re-use AUDIT-08 baseline |
| Web search (Brave/WebSearch/Exa) | FOUND-13 Q06.1/Q07.1/Q09/Q13/Q25 | ✓ (WebSearch tool used in this research) | — | none |
| `jq` | Validation Architecture JSON assertions | ✓ (standard tool) | — | `python -c 'import json; ...'` |
| `bash` / PowerShell | Validation Architecture structure-check script | ✓ (Phase 1-4 pattern) | — | none |
| Git (`.gitkeep` tracking) | FOUND-09 scaffold dirs | ✓ | — | — |

**No external dependencies are missing.** All probe surfaces (Coda / Miro / GWorkspace MCPs) are wired and working per AUDIT-08 + this session's MCP instructions block.

---

## Sources

### Primary (HIGH confidence)

- **`.planning/phases/05-foundations/05-CONTEXT.md`** — D-56..D-62 locked decisions; canonical_refs file list; sources modified by Phase 5
- **`.planning/phases/05-foundations/05-DISCUSSION-LOG.md`** — Q&A trail backing D-56..D-62
- **`.planning/REQUIREMENTS.md:104-120`** — FOUND-01..FOUND-13 verbatim requirement text
- **`.planning/ROADMAP.md:184-195`** — Phase 5 5-criterion success table
- **`.planning/AUDIT.md`** — §AUDIT-05.1 (`362-381`) hard-rules duplicate inventory; §AUDIT-06 (`460-481`) version-string mismatches; §AUDIT-07 (`485-540`) cosmetic CONCERNS B.1-B.6; §AUDIT-08 (`543-589`) live MCP probe baseline
- **`.planning/DESIGN.md`** — DESIGN-01 (`62-74`) frontmatter scheme; DESIGN-02 (`78-89`) stage-numbering; DESIGN-03 (`93-104`) hard-rules SoT; DESIGN-04 (`108-128`) plugin surfaces; DESIGN-07 (`162-178`) connector matrix; DESIGN-08 (`181-193`) frontmatter migration co-existence; DESIGN-11 (`280-329`) folder layout; DESIGN-12 (`335-369`) skill inventory; DESIGN-13 (`373-392`) stage hand-off contract
- **`.planning/OPEN-QUESTIONS.md`** — Q06.1/Q07.1/Q09/Q10/Q11/Q12/Q13/Q15/Q16/Q17/Q23/Q25 row definitions
- **`.planning/CHANGELIST.md:50-61`** — Phase 1 deliverables verbatim
- **Live `dydx-delivery/` codebase files** — `plugin.json`, `marketplace.json`, README.md (root + plugin), all 7 SKILL.md + 7 template files (verified 2026-05-10)

### Secondary (MEDIUM confidence — web research, single-source verified)

- [Pipefy Community: GraphQL API Limits](https://community.pipefy.com/customs-apps-integrations-75/what-are-the-graphql-api-limits-958) — Q06.1 answer (500 req/30s)
- [Pipefy Help Center: How to use Pipefy's API](https://help.pipefy.com/en/articles/5580799-how-to-use-pipefy-s-api)
- [Wrike Help Center: Resolve Common REST API Errors](https://help.wrike.com/hc/en-us/articles/23908384596631-Resolve-Common-REST-API-Errors) — Q07.1 answer (400 req/min per user, 5000 req/min per IP)
- [Wrike Developers: OAuth 2.0 Authorization](https://developers.wrike.com/oauth-20-authorization/) — Q13 answer (`host` field from token response)
- [Claude for Chrome marketing page](https://claude.com/claude-for-chrome) — Q09 primary canonical name
- [Claude Help Center: Get started with Claude in Chrome](https://support.claude.com/en/articles/12012173-get-started-with-claude-in-chrome) — Q09 interchangeable name

### Tertiary (LOW confidence — insufficient public docs)

- [Ziflow API Documentation](https://api-docs.ziflow.com/) — Q25: did not explicitly resolve auth-concurrency class. Default `exclusive` assumption is conservative inheritance from Pipefy precedent (UAT-4.2).

---

## Metadata

**Confidence breakdown:**
- Canonical reference content design (FOUND-01..04): **HIGH** — directly mappable to locked DESIGN-01/02/03 + AUDIT-05.1 content; D-62 lift-and-fix is straightforward
- Skill repoint mechanics (FOUND-05): **HIGH** — 4 duplicate surfaces grep-verified; D-59 pointer wording locked; 13 `based_on_*` value-renumbers enumerated
- File renumber surface (FOUND-06): **HIGH** — DESIGN-02 mapping authoritative; in-flight-exclusion via DESIGN-08 lenient mode
- Manifest sync (FOUND-07): **HIGH** — exact key paths + line numbers verified
- LICENSE (FOUND-08): **HIGH** — byte-exact content from OPEN-Q23 decision
- Scaffold dirs (FOUND-09): **HIGH** — paths verified; `.gitkeep` is conventional
- Connector matrix (FOUND-10): **MEDIUM** — schema mostly inferred from DESIGN-07 examples; the 11-stage grid will require iteration with user during W4
- Cosmetic fixes (FOUND-11): **HIGH** for B.1/B.2/B.6; **MEDIUM** for B.3 (v0.3.0 reality vs v2 end-state choice needs user input)
- Status survey (FOUND-12): **MEDIUM** — Option A (Coda MCP) vs Option B (SKILL.md fallback) requires planner adjudication
- OPEN-Q resolutions (FOUND-13): **HIGH** for Q10/Q11/Q12/Q13 (AUDIT-08 / web docs definitive); **MEDIUM** for Q06.1/Q07.1/Q09 (web search verified but Phase 6 re-confirms); **LOW** for Q25 (insufficient public evidence, conservative default)

**Research date:** 2026-05-10
**Valid until:** 2026-05-20 (10 days for rate-limit publications which can change; AUDIT-08 baseline 2026-05-09 still authoritative for MCP wiring)

**Next step:** `/gsd-plan-phase 5` — author 5 wave plans (`05-01-PLAN.md` through `05-05-PLAN.md`) per D-60 slicing. Plans MUST embed the Validation Architecture grep assertions verbatim per the §Validation Architecture / Phase Requirements → Assertion Map table.
