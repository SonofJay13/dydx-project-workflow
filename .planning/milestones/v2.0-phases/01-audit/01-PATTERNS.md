# Phase 1: Audit - Pattern Map

**Mapped:** 2026-05-09
**Files analyzed:** 3 deliverables (1 markdown audit doc + 1 bash script + 1 optional reviewer checklist)
**Analogs found:** 2 / 3 (script has no analog — vanilla bash recommended)

## File Classification

| New/Modified File | Role | Data Flow | Closest Analog | Match Quality |
|-------------------|------|-----------|----------------|---------------|
| `.planning/AUDIT.md` | document (audit deliverable) | citation-driven inventory / file-grounded synthesis | `.planning/codebase/CONCERNS.md` | exact (same role: citation-grounded inventory of v0.3.0 surfaces; absorbed-and-superseded relationship) |
| `.planning/AUDIT.md` (severity-tag + cross-ref pattern) | document (severity-tagged findings) | per-finding tag + ID cross-ref | `.planning/research/PITFALLS.md` | role-match (severity-style ID-tagged finding cards with cross-refs to other docs) |
| `.planning/phases/01-audit/scripts/audit-structure-check.sh` | utility (structural verifier) | shell script — grep/file-exists assertions, exit-code aggregation | (no analog — repo has zero `.sh` files at any path) | no analog |
| `.planning/phases/01-audit/01-AUDIT-COVERAGE.md` (optional) | document (reviewer checklist) | requirement-ID → section trace | `.planning/codebase/STRUCTURE.md` (table-heavy reference doc) | partial (table format only) |

---

## Pattern Assignments

### `.planning/AUDIT.md` — Primary deliverable (document, citation-driven inventory)

**Primary analog:** `.planning/codebase/CONCERNS.md`
**Secondary analog (for severity-tagging + ID cross-refs):** `.planning/research/PITFALLS.md`

The two analogs cover complementary surfaces — CONCERNS.md is the prose-and-citation style ancestor (same domain, same `file:line` discipline, same negative-finding callout convention); PITFALLS.md is the ID-tagged finding-card / severity-style ancestor (same `[BLOCKING] / [STRUCTURAL] / [COSMETIC]` triage instinct, same cross-ref-to-other-doc-IDs habit).

#### Pattern 1 — Frontmatter / preamble convention (CONCERNS.md:1-7)

```markdown
# Codebase Concerns

**Analysis Date:** 2026-05-09

> Structural inventory only. Observations of facts in the repo at the current commit (`8805379 chore: initial marketplace + dydx-delivery 0.3.0`, branch `dydx-delivery-v2`). No remediation suggestions — read each item as "X is the case", not "X should change".

---
```

**Apply to AUDIT.md:** Open with H1, single-line `**Field:** value` metadata block (per D-03 add executive summary table here), then a blockquote-style "How to read" preamble (per D-03), then `---`. CONCERNS.md's "no remediation suggestions" stance is the exact precedent for AUDIT.md's "audit names the gap; design doesn't propose the fix" rule (D-13). The audit's preamble blockquote should mirror this voice — it tells the reader what AUDIT.md *is not* (not a v2 design doc; not a fix list; cosmetic items NOT in this milestone).

**Note on analog drift:** CONCERNS.md uses `**Analysis Date:**` (not `**Audit Date:**`). AUDIT.md should pick whichever phrasing reads cleanest — the precedent is "single bold-keyed line", not the specific key name.

---

#### Pattern 2 — Section structure: H2 heading + thematic body + `---` separator (CONCERNS.md:9-26)

```markdown
## Version string mismatches across manifests and docs

**Plugin version disagreement between root README and manifests:**
- `README.md` line 9 lists `dydx-delivery` at version **0.1.0**.
- `.claude-plugin/marketplace.json` line 16 lists `dydx-delivery` at version **0.3.0**.
- `dydx-delivery/.claude-plugin/plugin.json` line 3 lists version **0.3.0**.
- `dydx-delivery/README.md` line 126 begins a `0.3.0` changelog entry.

**Hardcoded runner version diverges from plugin version:**
- `dydx-delivery/skills/execute-tests/references/results-template.md` line 9 hardcodes `runner: dydx-delivery/execute-tests v0.1.0` in the frontmatter while `plugin.json` declares the plugin at `0.3.0`.

---
```

**Apply to AUDIT.md:** Each AUDIT-0N section is `## AUDIT-0N: <Name>` per D-02 (analog uses descriptive H2; AUDIT-* prefix is the v2-specific extension). Within each section, group findings under `**Bold finding label:**` mini-headers (CONCERNS.md uses bold-paragraph subdividers, NOT H3). Bullets carry the actual citations. End each section with `---` separator. **Reuse this exact rhythm.**

**Where to deviate:** D-15 requires `[BLOCKING] / [STRUCTURAL] / [COSMETIC]` inline severity tags — CONCERNS.md does not tag severity (this is the AUDIT-only extension). PITFALLS.md (next pattern) is the severity-tag analog.

---

#### Pattern 3 — Citation style: `` `file:line` `` and `` `file:start-end` `` with backtick wrapping (CONCERNS.md:13-18)

```markdown
- `README.md` line 9 lists `dydx-delivery` at version **0.1.0**.
- `dydx-delivery/skills/generate-build-prompt/SKILL.md` line 47.
- `dydx-delivery/skills/generate-technical-spec/SKILL.md` lines 38–39.
- `dydx-delivery/README.md` lines 33–41 list **seven skills** in a table.
```

**Apply to AUDIT.md (per D-14):** Backtick-wrap the file path. Two acceptable phrasings observed in CONCERNS.md:
1. **Prose form** (CONCERNS.md throughout): `` `path/to/file.md` line 9 `` or `` lines 38–39 ``.
2. **Compact form** (D-14 canonical): `` `path/to/file.md:9` `` or `` `path/to/file.md:38-39` ``.

D-14 locks the **compact form** for AUDIT.md (`file:line` with `:`-separator, ASCII hyphen for ranges). CONCERNS.md uses the prose form — AUDIT.md is intentionally tighter for grep-ability and reviewer-navigation. **Do NOT inherit the prose form.** When absorbing CONCERNS.md citations into AUDIT.md (per D-08), rewrite each one into the compact form.

**Range separator:** CONCERNS.md uses en-dash (`–`); D-14 implies ASCII hyphen (`-`) given how `file:start-end` parses. Use ASCII hyphen in AUDIT.md.

---

#### Pattern 4 — Severity-tag style (PITFALLS.md ID convention adapted)

PITFALLS.md tags every finding with a structured ID: `### CRIT-1 — Coda formula column overwrite via plain row write` (PITFALLS.md:21). The pattern is "tier-prefix + sequence + em-dash + headline".

**Excerpt** (PITFALLS.md:21-22):
```markdown
### CRIT-1 — Coda formula column overwrite via plain row write

**What goes wrong:** Stage 5 cost-generation writes per-assignee task rows. Any column flagged `calculated: true` (has a `formula:`) cannot be set via row write — the call returns `202 Accepted` regardless...
```

**Apply to AUDIT.md (per D-15):** Inline severity tag format — `[BLOCKING]` / `[STRUCTURAL]` / `[COSMETIC]`. Bracketed all-caps token, placed at the **end of the bullet** (RESEARCH.md §2 table column "Severity" demonstrates the exact form). Example synthesized for AUDIT.md:

```markdown
- `dydx-delivery/skills/generate-technical-spec/SKILL.md:38-39` references missing `platform-pipefy` skill via `platform:` dispatch. Three downstream skills depend on this contract; today the contract is broken in-repo. **[BLOCKING]**
```

**Why bracketed-all-caps not PITFALLS-style ID:** Severity is a triage axis, not a finding ID. AUDIT findings are already located by section (`AUDIT-0N`) and citation (`file:line`); a separate ID number would be noise. Bracketed all-caps scans visually at the end of the bullet without competing with backticked file paths.

**Net-new tag:** `[NEW]` (per D-10) marks findings beyond CONCERNS.md scope. Place **before** the severity tag: `[NEW] [STRUCTURAL]`.

**`v2.1` constraint phrase (per D-16) for cosmetic items:** Cosmetic findings carry the literal phrase `**Scheduled for v2.1 build, NOT this milestone.**` per-bullet. RESEARCH.md §8 demonstrates the phrasing exactly:
```markdown
- **Fix:** Complete the truncated sentence in changelog entry. **Scheduled for v2.1 Foundations build (FOUND-07), NOT this milestone.**
```
Bold-wrapped, sentence-final, references the FOUND-* requirement that closes it.

---

#### Pattern 5 — Cross-reference style (PITFALLS.md inter-section refs; CONCERNS.md "see X" pattern)

**PITFALLS.md** uses bold-keyed `**Owning phase:** P5 Integrations (Coda schema contract); P1 Architecture (write-path safety contract).` (PITFALLS.md:32) and `**Source:** Context7 ...` (PITFALLS.md:34). This is a "structured trailing metadata block per finding" pattern.

**CONCERNS.md** uses inline parenthetical for cross-refs and a separate H2 section for negative-findings ("Cross-references between docs", lines 109–117).

**Apply to AUDIT.md:** Two cross-ref motions are needed:
1. **Within-doc cross-ref** (e.g. an AUDIT-06 finding that's also AUDIT-07 cosmetic per D-01): inline parenthetical, e.g. `(see AUDIT-07)` or `Cross-ref: AUDIT-07`.
2. **Out-of-doc cross-ref** to DESIGN-* / CRIT-* / MOD-* / MIN- IDs: bold-keyed trailer line, mirroring PITFALLS' `**Owning phase:**` and `**Source:**` shape:
   ```markdown
   **Closes via:** DESIGN-17 (Stage 1 Kickoff capture skill); DESIGN-18 (Stage 2 Discovery refactor); DESIGN-01 (frontmatter scheme).
   **Pitfall ref:** CRIT-6 (frontmatter migration).
   ```

This keeps the audit anchored without proposing the design move (D-13).

---

#### Pattern 6 — Tables: pipe-style markdown with citation column (CONCERNS.md:63-72)

```markdown
| Skill / template | File:line | Stage label |
|---|---|---|
| discovery-intake / intake-template | `dydx-delivery/skills/discovery-intake/references/intake-template.md:13` | Stage 0 |
| generate-sow / sow-template | `dydx-delivery/skills/generate-sow/references/sow-template.md` | (no Stage label) |
| generate-functional-spec / functional-spec-template | `dydx-delivery/skills/generate-functional-spec/references/functional-spec-template.md:13` | Stage 2 |
| generate-technical-spec / technical-spec-template | `dydx-delivery/skills/generate-technical-spec/references/technical-spec-template.md:13` | Stage 3 |
| generate-test-plan / test-plan-template | `dydx-delivery/skills/generate-test-plan/references/test-plan-template.md:17` | Stage 5 |
| generate-build-prompt / build-prompt-template | `dydx-delivery/skills/generate-build-prompt/references/build-prompt-template.md:15` | Stage 6 |
| execute-tests / results-template | `dydx-delivery/skills/execute-tests/references/results-template.md:18` | Stage 6 |
```

**Apply to AUDIT.md:**
- Header rows use plain `|---|---|---|` (no alignment colons) — CONCERNS.md uses minimal alignment.
- Citation column **always backtick-wraps the path** including line number.
- Empty / negative cells use parenthetical English (`(no Stage label)`) not blank or `N/A`.
- Use this format for: AUDIT-01 skill matrix (per D-11); AUDIT-02 CONCERNS.md trace; AUDIT-03 connector dependency; AUDIT-06 version-mismatch; AUDIT-08 MCP probe; Appendix B trace.

**RESEARCH.md §2** (lines 80-95) is the closest table-with-many-columns analog the planner has already produced; the AUDIT-02 absorption table can copy its column structure (`Section | Lines | Entries | Primary AUDIT-* destination | Cross-ref | Severity`). Reuse it.

---

#### Pattern 7 — Negative-finding callouts (CONCERNS.md:108-117, 154-162)

```markdown
## Cross-references between docs

**`dydx-delivery/README.md` line 95** points to `skills/generate-build-prompt/references/when-to-open-claude-code.md` for the decision matrix. The file exists at that path.

**`dydx-delivery/skills/execute-tests/SKILL.md` line 23** points to `references/safety-rules.md`. The file exists at that path.

(No broken intra-plugin file references found beyond the unfollowed `platform-pipefy` / `platform-wrike` / `hub.md` references already listed above.)
```

```markdown
## TODO / FIXME / HACK / XXX markers

No `TODO`, `FIXME`, or `HACK` markers found in any file in the repo.
```

**Apply to AUDIT.md:** When a candidate finding category turns out clean (e.g. AUDIT-04 §5.6 "verified working refs", AUDIT-05 "no TODO markers"), CONCERNS.md's discipline is to keep the section anyway with explicit "verified clean" sentences. Reviewer can't read absence-of-mention as "not checked". Mirror this pattern verbatim — explicit negative-finding statements, plain English, parenthetical scope-clarifier at end.

---

#### Pattern 8 — Frontmatter-list / inventory style (CONCERNS.md:166-188)

```markdown
**`status:` lifecycle vocabulary is not uniform across templates:**
- `intake-template.md` frontmatter line 6: `status: draft`. SKILL.md line 104 frontmatter sample also `status: draft`. Discovery flow does not specify a final status word.
- `sow-template.md` frontmatter line 6: `status: draft`. SKILL.md handoff line 93 mentions `status:` values `client_review` and `approved`.
- `functional-spec-template.md` line 6 / SKILL.md line 95: `draft` → `approved`.
```

**Apply to AUDIT.md per-skill subsections (D-12 prose-heavy fields):** When listing per-template / per-skill micro-findings inside a prose subsection, CONCERNS.md's pattern is bold-keyed paragraph header → bullet list with `file:line` first, finding-text after. Each bullet is a single observation. AUDIT-01's per-skill subsections (Hand-off contract / Observed brittleness / What's missing for v2) should mirror this — keep individual observations as bullets, not run-on prose.

---

### Trailing-section pattern: appendices and trace tables

**Analog:** CONCERNS.md ends with a single line `*Concerns audit: 2026-05-09*` (line 234) — no formal appendix.
**RESEARCH.md analog (better fit):** RESEARCH.md §2 "CONCERNS.md absorption map" is the structural ancestor of AUDIT.md's planned `Appendix B: CONCERNS.md → AUDIT.md trace` (D-09).

**RESEARCH.md §2 table excerpt** (RESEARCH.md:79-96):
```markdown
| CONCERNS.md section | Lines | Entries | Primary AUDIT-* destination | Cross-ref | Severity (D-15) |
|---------------------|-------|---------|----------------------------|-----------|-----------------|
| Version string mismatches across manifests and docs | `CONCERNS.md:9-24` | 5 entries | **AUDIT-06** | AUDIT-07 (cosmetic) | `[STRUCTURAL]` + `[COSMETIC]` |
| References to skills/files that do not exist in the repo | `CONCERNS.md:28-48` | 4 categories | **AUDIT-04** | AUDIT-01; MOD-2 | `[STRUCTURAL]` |
```

**Apply to AUDIT.md Appendix B:** Reuse this exact column shape. Add a final summary line below the table (per D-09): `**Total CONCERNS.md sections:** 14. **All 14 absorbed.**` — the "all N entries absorbed" phrasing is locked by D-09; format the count statement as a bold-keyed sentence so it scans clean.

**Appendix A (glossary / acronym list) per RESEARCH.md §1 implication:** Place above Appendix B. Use a simple two-column table `| Term | Meaning |` with one row per acronym (`SOW`, `MCP`, `Coda`, `BLOCKING`, `STRUCTURAL`, `COSMETIC`, `NEW`, `DESIGN-*`, `CRIT-*`, etc.). No analog file in the repo for this — the format is conventional markdown.

---

### `.planning/phases/01-audit/scripts/audit-structure-check.sh` (utility, shell-script)

**Analog:** None. `Glob("**/*.sh")` returned zero files in the repo at the time of this mapping. The repo has no precedent for shell scripts.

**Recommendation:** Vanilla POSIX bash with the following shape — derived from VALIDATION.md §"Wave 0 Requirements" (lines 52-60) and the structural-check assertions implied throughout VALIDATION.md:

```bash
#!/usr/bin/env bash
# audit-structure-check.sh — structural verifier for .planning/AUDIT.md
# Asserts: file exists; all 8 AUDIT-0N H2 sections present; all 7 H3
# skill subsections under AUDIT-01; "scheduled for v2.1 build, NOT this
# milestone" phrase appears at least once in AUDIT-07; appendix B trace
# table present. Exit 0 if all checks pass; exit 1 on first failure with
# the failing assertion echoed to stderr.

set -euo pipefail

AUDIT_FILE=".planning/AUDIT.md"

fail() {
  echo "FAIL: $1" >&2
  exit 1
}

# 1. File exists
[ -f "$AUDIT_FILE" ] || fail "$AUDIT_FILE not found"

# 2. All 8 AUDIT-0N sections present
expected_sections=8
actual_sections=$(grep -cE '^## AUDIT-0[1-8]:' "$AUDIT_FILE" || true)
[ "$actual_sections" -eq "$expected_sections" ] \
  || fail "expected $expected_sections AUDIT-0N H2 sections, found $actual_sections"

# 3. v2.1 cosmetic-fix constraint phrase present (D-16)
grep -qF 'Scheduled for v2.1' "$AUDIT_FILE" \
  || fail "D-16 constraint phrase 'Scheduled for v2.1' not found"

# 4. CONCERNS.md superset claim present
grep -qiE 'verified superset of|all .* (entries|sections) absorbed' "$AUDIT_FILE" \
  || fail "CONCERNS.md absorption claim not found"

# 5. Appendix B trace section present
grep -qE '^## Appendix B:' "$AUDIT_FILE" \
  || fail "Appendix B trace section header not found"

echo "OK: all structural checks passed"
exit 0
```

**Rationale for vanilla shape:**
- `set -euo pipefail` — defensive default; one assertion failure aborts (matches the "exit 1 on first failure" assertion in VALIDATION.md feedback-latency target).
- `fail()` helper — single point of stderr-echo + exit. Reviewer reads which assertion failed without scrolling.
- `grep -c` for count assertions; `grep -q` for boolean. `-F` for fixed-string ("Scheduled for v2.1") avoids regex escaping; `-E` for the ID-pattern regex.
- No external dependencies (no `jq`, no `yq`, no Python). Pure POSIX shell + grep — runs on macOS / Linux / Git Bash on Windows.
- Each assertion has a human-readable failure message; passing run prints one OK line.

**Where the planner can extend:** add per-skill assertion `grep -cE '^### 3\.[1-7]' "$AUDIT_FILE"` if the 7-skill matrix sub-headers in AUDIT-01 use that depth; add a Appendix-B-row-count check; add MCP-probe-row-count check on AUDIT-08.

---

### `.planning/phases/01-audit/01-AUDIT-COVERAGE.md` (optional, reviewer checklist)

**Analog (partial):** `.planning/codebase/STRUCTURE.md` — table-heavy, requirement-anchored reference document. Closer match than CONCERNS.md because the coverage doc is *not* a citation-driven audit, it's a checklist trace.

**Apply pattern:** Single H2 section per ROADMAP success criterion (1–5). Each section: one-sentence quote of the criterion, then a bullet list of `- [ ] AUDIT.md §<section> — <what to look for>`. Trailing summary: `Reviewer attests: ☐ All 5 criteria met` checkbox. Keep terse (the doc is a checklist, not prose).

This file is **optional** per CONTEXT.md framing; planner decides whether to include it. If included, single page max — its only job is to give the human reviewer a punch list.

---

## Shared Patterns

### Citation discipline (per D-14)

**Source:** `.planning/codebase/CONCERNS.md` (entire file demonstrates the discipline at the prose-form variant; D-14 locks the compact form).

**Apply to:** Every finding bullet in AUDIT.md, including appendix tables.

**Concrete contract for executor:**
- Always backtick-wrap the path: `` `path/to/file.md:9` ``
- Single line: `:9`. Range: `:9-15` (ASCII hyphen).
- File-only (no specific line): `` `path/to/file.md` `` — acceptable when the whole file is the subject (e.g. "the canonical version of `safety-rules.md`").
- When citing **two** files in one sentence, two backtick spans: `` `marketplace.json:5` and `plugin.json:7` `` (CONCERNS.md:194 demonstrates this).

### Severity tagging (per D-15)

**Source contract:** Synthesized from PITFALLS.md ID-tag style adapted to D-15's bracketed-token convention. RESEARCH.md §2 column "Severity (D-15)" demonstrates the values.

**Apply to:** Every finding bullet. Tags: `[BLOCKING]` (contract is broken — downstream skills can't load), `[STRUCTURAL]` (architectural debt — schema / scaffold / consistency), `[COSMETIC]` (client-visible polish issue, scheduled for v2.1).

**Placement:** End of bullet, after the citation and the description, bold-wrapped: `... contract is broken in-repo. **[BLOCKING]**`.

**Co-tags:**
- `[NEW]` precedes severity: `**[NEW]** **[STRUCTURAL]**` (RESEARCH.md §4 "Net-new finding" line 242 demonstrates).
- Multi-severity findings (one finding tagged BLOCKING for one stakeholder, COSMETIC for another) use both tags space-separated in order of urgency: `**[BLOCKING]** **[COSMETIC]**`.

### Cross-reference IDs (per D-13)

**Source:** PITFALLS.md `**Owning phase:**` / `**Source:**` trailer-block convention, adapted to AUDIT-01..08 / DESIGN-* / CRIT- vocabulary.

**Apply to:** Every per-skill subsection in AUDIT-01 (D-12 "What's missing for v2" must point at DESIGN-* without proposing the move). Trailer-block format:
```markdown
**Closes via:** DESIGN-NN (one-line description); DESIGN-MM (one-line description).
**Pitfall ref:** CRIT-X (one-line description); MOD-Y.
**Cross-ref within audit:** AUDIT-07 (cosmetic aspect); AUDIT-04 (referenced-but-missing aspect).
```

Bold-keyed line. Semicolon-separated within a single key. ID first, parenthetical description second. **Never propose the design move** — only point at the requirement that closes the gap.

### `v2.1` constraint phrase (per D-16) — only AUDIT-07

**Source phrase (locked by D-16):** `**Scheduled for v2.1 build, NOT this milestone.**` (or the more specific variant `**Scheduled for v2.1 Foundations build (FOUND-NN), NOT this milestone.**` — RESEARCH.md §8 demonstrates the variant).

**Apply to:** Every cosmetic-issue bullet in AUDIT-07. Per-bullet (D-16: "phrasing carried per-bullet, not just at the section header"). Bold-wrapped, sentence-final.

**Forbidden anywhere else:** AUDIT-01..06 and AUDIT-08 must NOT use this phrase. Phrase appearing in non-AUDIT-07 sections triggers reviewer concern that a cosmetic finding leaked sideways.

---

## No Analog Found

| File | Role | Data Flow | Reason / Recommended Fallback |
|------|------|-----------|--------------------------------|
| `.planning/phases/01-audit/scripts/audit-structure-check.sh` | utility (bash) | shell assertions | Repo has zero `.sh` files at any path (verified by `Glob("**/*.sh")`). No internal precedent for shell scripts, no shebang convention to inherit, no `set -e` discipline established. **Fallback:** vanilla POSIX bash with `set -euo pipefail` + `grep -c` / `grep -q` / `[ -f ]` assertions and a single `fail()` helper for stderr-echo + exit-1. Full skeleton given in the Pattern Assignments section above. |

The optional `01-AUDIT-COVERAGE.md` is *partially-no-analog*: STRUCTURE.md provides the table convention, but a "reviewer punch-list" document type doesn't exist elsewhere in the repo. Planner can synthesize from STRUCTURE.md table style + ROADMAP success-criteria phrasing.

---

## Metadata

**Analog search scope:**
- `.planning/codebase/` (CONCERNS, STRUCTURE, ARCHITECTURE, CONVENTIONS, INTEGRATIONS, STACK, TESTING)
- `.planning/research/` (PITFALLS, SUMMARY, ARCHITECTURE, FEATURES, STACK)
- `.planning/` root (PROJECT, REQUIREMENTS, ROADMAP, STATE, MILESTONES)
- `.planning/phases/01-audit/` (CONTEXT, RESEARCH, VALIDATION, DISCUSSION-LOG)
- Repo-wide `Glob("**/*.sh")` for bash analog (zero matches)

**Files scanned:** 4 closely (CONCERNS.md full; PITFALLS.md preamble + first 4 critical-pitfall cards; STRUCTURE.md preamble; VALIDATION.md grep-targeted) + 2 referenced (RESEARCH.md, CONTEXT.md as upstream input)

**Pattern extraction date:** 2026-05-09

**Phase:** 1-audit

## PATTERN MAPPING COMPLETE
