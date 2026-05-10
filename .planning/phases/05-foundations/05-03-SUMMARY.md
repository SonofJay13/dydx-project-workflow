---
phase: 05-foundations
plan: 03
subsystem: foundations
tags: [foundations, manifest-sync, license, scaffold-dirs, b6-homepage, FOUND-07, FOUND-08, FOUND-09]
status: complete
wave: 3
depends_on: []
requires:
  - jq (1.7+) on PATH
  - bash 4+ / Git Bash / WSL
  - 2-space JSON indent + trailing newline convention
provides:
  - "Plugin manifest 2.0.0 sync (plugin.json + marketplace.json metadata.version + marketplace.json plugins[0].version)"
  - "Plugin manifest cross-symmetry: plugin.json homepage == marketplace.json plugins[0].homepage (B.6 closure)"
  - "Plugin manifest cross-symmetry: plugin.json author.email == marketplace.json owner.email (UAT-3.1 LOCK held)"
  - "Repo-root LICENSE file (54 bytes, LF-only, byte-exact OPEN-Q23 boilerplate)"
  - ".gitattributes with `LICENSE text eol=lf` directive (W-03 fix; Windows CRLF auto-conversion neutralised)"
  - "Three empty scaffold dirs at dydx-delivery/ root (commands/, agents/, hooks/) each with a 0-byte .gitkeep marker (FOUND-09 + DESIGN-11)"
affects:
  - "Every downstream phase that reads plugin version (now sees 2.0.0)"
  - "Phase 6 platform skills (now has plugin scaffold to land into)"
  - "Plan 05-04 (records mcpServers deferral; cross-AI flag 5 closure)"
  - "Plan 05-05 (B.6 cosmetic fix retrospectively footnoted as completed-by-W3 inline; B.4 LICENSE cross-reference satisfied)"
tech-stack:
  added: []
  patterns:
    - "JSON manifest in-place key edits (no schema/structure change)"
    - "Repo-root LICENSE convention (matches standard OSS layout, not the dydx-delivery/ sub-tree)"
    - "Empty-dir tracking via .gitkeep (DESIGN-11)"
    - ".gitattributes LF pin for byte-exact cross-platform files"
key-files:
  created:
    - LICENSE
    - .gitattributes
    - dydx-delivery/commands/.gitkeep
    - dydx-delivery/agents/.gitkeep
    - dydx-delivery/hooks/.gitkeep
  modified:
    - dydx-delivery/.claude-plugin/plugin.json
    - .claude-plugin/marketplace.json
decisions:
  - "FOUND-07 narrow scope honoured: ONLY version sync + B.6 homepage; mcpServers DEFERRED per cross-AI flag 5 (acceptance criterion enforced)"
  - "UAT-3.1 owner/author email LOCK held: both manifests carry jasonmichaelb@gmail.com unchanged (dYdX-approved private email, NOT a defect)"
  - "OPEN-Q23 LICENSE byte-exactness met: 54 bytes, LF-only, no copyright year, no permissive boilerplate"
  - "Cross-AI flag 2 closure: B.6 marketplace.json homepage landed in W3 inline with version sync (single-pass on marketplace.json; W5 will footnote 'completed by W3')"
  - "C-5 (Codex MEDIUM) compliance for .gitattributes: file did not pre-exist (baseline 0 lines); created with single LF directive; idempotent assertion `grep -c '^LICENSE text eol=lf$' .gitattributes == 1` holds; no-clobber sentinel (wc -l non-decrease) holds; no conflicting LICENSE rule present"
  - "C-6 (Codex MEDIUM) canonical empty-dir definition met: `ls -A <dir>` equals `.gitkeep` for all three scaffold dirs (consumed by Plan 05-05 Task 4 structure-check)"
  - "W-03 LF-pin defence: LICENSE 54-byte assertion stable across Windows checkouts because of .gitattributes; LICENSE staged blob verified at 54 bytes via `git cat-file -p :LICENSE | wc -c`"
metrics:
  duration_seconds: 141
  duration_human: "~2 min"
  started: "2026-05-10T21:14:03Z"
  completed: "2026-05-10T21:16:23Z"
  tasks_completed: 4
  files_modified: 7
  commits: 4
---

# Phase 5 Plan 03: Wave 3 — Manifest Sync + LICENSE + Scaffold Dirs Summary

## One-liner

Plugin manifests synced to 2.0.0 (plugin.json + marketplace.json), repo-root LICENSE created with byte-exact OPEN-Q23 boilerplate and LF-pinned via .gitattributes, three empty scaffold dirs (commands/, agents/, hooks/) materialised at dydx-delivery/ root with .gitkeep markers.

## What landed

### Task 1 — plugin.json version sync (FOUND-07)

**Single-line diff:**

```diff
-  "version": "0.3.0",
+  "version": "2.0.0",
```

- Line 3 only — every other line preserved verbatim.
- `author.email = "jasonmichaelb@gmail.com"` UNCHANGED (UAT-3.1 LOCK).
- No `mcpServers` field added (cross-AI flag 5 deferred to v2.6 / SURF-01..03).
- 25 lines (no growth). Valid JSON via `jq '.'`.

**Commit:** `2925b60`

### Task 2 — marketplace.json: 3 edits (FOUND-07 + B.6)

**Edit 1 — metadata.version (line 9):**

```diff
-    "version": "1.2.0"
+    "version": "2.0.0"
```

**Edit 2 — plugins[0].version (line 16):**

```diff
-      "version": "0.3.0",
+      "version": "2.0.0",
```

**Edit 3 — plugins[0].homepage (new key, line 19):**

```diff
       "tags": ["sow", "spec", "test-plan", "build-prompt", "claude-code", "automated-testing", "pipefy", "wrike", "solutions-architecture"],
+      "homepage": "https://github.com/SonofJay13/dydx-project-workflow"
     }
```

- `owner.email = "jasonmichaelb@gmail.com"` UNCHANGED (UAT-3.1 LOCK).
- Cross-manifest equality verified:
  - plugin.json `.version` == marketplace.json `.plugins[0].version` == `2.0.0`
  - plugin.json `.author.email` == marketplace.json `.owner.email` == `jasonmichaelb@gmail.com`
  - plugin.json `.homepage` == marketplace.json `.plugins[0].homepage` == `https://github.com/SonofJay13/dydx-project-workflow`
- B.6 cross-AI flag 2 closure: landed in W3, NOT W5. W5 plan (05-05) will footnote "completed by W3".

**Commit:** `7cc8b1d`

### Task 3 — LICENSE (FOUND-08) + .gitattributes LF pin (W-03)

**LICENSE (created, 54 bytes, LF-only):**

```
All rights reserved.
Not licensed for redistribution.
```

**Byte-count proof:**

```
$ wc -c LICENSE
54
$ diff <(printf 'All rights reserved.\nNot licensed for redistribution.\n') LICENSE
(empty — byte-exact)
$ grep -lU $'\r' LICENSE   # CR detection
(empty — no CR characters)
```

Staged blob also verified at 54 bytes via `git cat-file -p :LICENSE | wc -c`.

**.gitattributes (created, single line):**

```
LICENSE text eol=lf
```

C-5 (Codex MEDIUM) compliance:

| Check | Result |
|---|---|
| Pre-task baseline `wc -l .gitattributes` | 0 (file absent) |
| Post-task `wc -l .gitattributes` | 1 (non-decrease ✓) |
| `grep -c '^LICENSE text eol=lf$' .gitattributes` | 1 (idempotent ✓) |
| `grep -E '^LICENSE ' \| grep -vE '^LICENSE text eol=lf$' \| wc -l` | 0 (no conflicting rule ✓) |
| Decision-tree case applied | Case 1 (file absent → create) |

**Commit:** `b6f62ac`

A benign `warning: in the working copy of '.gitattributes', LF will be replaced by CRLF the next time Git touches it` was emitted by `git add` — this warning targets `.gitattributes` itself (which is NOT pinned by any rule), not LICENSE. LICENSE itself is properly pinned and the staged blob is verified LF-only.

### Task 4 — 3 scaffold dirs with .gitkeep (FOUND-09 + DESIGN-11)

| Dir | `.gitkeep` size | `ls -A` |
|---|---|---|
| `dydx-delivery/commands/` | 0 bytes | `.gitkeep` |
| `dydx-delivery/agents/` | 0 bytes | `.gitkeep` |
| `dydx-delivery/hooks/` | 0 bytes | `.gitkeep` |

C-6 canonical empty-dir definition holds for all three: `ls -A <dir>` equals exactly `.gitkeep`. This is the assertion consumed by Plan 05-05 Task 4's structure-check.

Negative-location assertions pass: `! test -d dydx-delivery/.claude-plugin/{commands,agents,hooks}` — none were placed inside `.claude-plugin/` (per DESIGN-11, the surface dirs are siblings of `skills/`, not children of `.claude-plugin/`).

Substantive content explicitly deferred to v2.6 / SURF-01..03 per OPEN-Q21 + Q21.1 + DESIGN-04 + D-56:
- `commands/refine.md` (parameterised slash command, `/dydx-refine-*` namespace) — DEFERRED
- `agents/<probe-agent>` — DEFERRED
- `hooks/validate-frontmatter` + `hooks/bump-artefact-version` — DEFERRED

**Commit:** `c462d43`

## Cross-AI flag closures

| Flag | Decision | Where it landed |
|---|---|---|
| Flag 2 (B.6 homepage timing — D-60 wave table puts it in W5, RESEARCH recommends W3 inline) | LAND IN W3 inline with marketplace.json version sync | Task 2 Edit 3 — single-pass on marketplace.json; W5 plan footnotes "completed by W3" |
| Flag 5 (mcpServers per DESIGN-04 vs FOUND-07 narrow scope) | DEFER to v2.6 / SURF-01..03 | Task 1 acceptance criterion `jq -e 'has("mcpServers")' returns false` enforced; Plan 05-04 records the deferral row |

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking issue] Installed jq locally**

- **Found during:** Pre-Task 1 environment check.
- **Issue:** Plan acceptance criteria require `jq` but it was not on PATH (Plan 05-01 Task 0 prerequisite gate was nominally passed but jq was not actually present in this Git-Bash session). Without jq, the per-task assertions cannot run.
- **Fix:** Downloaded `jq-windows-amd64.exe` (v1.7.1) from upstream releases via Node.js https module to `C:\tmp\jq.exe`; copied to `C:\Users\Jason Blignaut\bin\jq.exe`; added that dir to PATH for the session.
- **Files modified:** none in the repo (jq binary lives outside the repo at `C:\Users\Jason Blignaut\bin\jq.exe`).
- **Commit:** none (out-of-repo tooling install; not a code change).
- **Carry-forward note for future plans:** if future executors run on this machine, jq is now at `C:\Users\Jason Blignaut\bin\jq.exe`. Ensure `$HOME/bin` is on PATH or fall back to the locally-installed binary path.

### Non-issues classified as deviations

**A. [Plan-text artefact, NOT a real failure] `ls -1 | wc -l` returned 0 on Git-Bash for dotfile-only dirs**

The plan literally asserted `[ "$(ls -1 dydx-delivery/commands/ | wc -l)" = "1" ]` for each scaffold dir. On this Git-Bash, `ls -1` (without `-A`) does NOT list dotfiles, so the count returned 0 instead of 1 for dirs that contain only `.gitkeep`. **This is not a real failure** — the spirit of the criterion is "the dir contains exactly one entry (the .gitkeep)", which is met. The C-6 canonical form (`ls -A <dir>` == `.gitkeep`) is the authoritative empty-dir definition per the plan itself and PASSES for all three dirs. `ls -1A | wc -l` also returns 1 for all three.

**Recommendation for future plans / Plan 05-05 Task 4 structure-check:** use `ls -A` or `ls -1A` (dotfile-inclusive forms) in assertion text. The C-6 canonical form is already correct — only the auxiliary literal text in the criteria block needs the `-A` flag.

No commit / no file change — purely a plan-text observation.

## Authentication gates

None. Plan was fully autonomous.

## Verification evidence

```
=== <verification> block from plan ===
1. plugin.json version == marketplace.plugins[0].version   PASS (both 2.0.0)
2. plugin.json author.email == marketplace.owner.email     PASS (jasonmichaelb@gmail.com)
3. plugin.json homepage == marketplace.plugins[0].homepage PASS (https://github.com/SonofJay13/dydx-project-workflow)
4. LICENSE byte-diff against expected                      PASS (byte-exact, 54 bytes LF-only)
5. .gitattributes carries LICENSE text eol=lf              PASS
6. LICENSE contains zero CR characters                     PASS (no CR)
7. 3 scaffold dirs each contain exactly .gitkeep (C-6)     PASS x3 (commands, agents, hooks)
8. No mcpServers field on plugin.json                      PASS (mcpServers absent)
```

## Commits (chronological)

| # | Hash      | Type | Task | Description |
|---|-----------|------|------|-------------|
| 1 | `2925b60` | feat | T1   | sync plugin.json version to 2.0.0 (FOUND-07) |
| 2 | `7cc8b1d` | feat | T2   | sync marketplace.json to 2.0.0 + add plugins[0].homepage (FOUND-07 + B.6) |
| 3 | `b6f62ac` | feat | T3   | add LICENSE (OPEN-Q23) and .gitattributes LF pin (FOUND-08 + W-03) |
| 4 | `c462d43` | feat | T4   | create empty scaffold dirs commands/agents/hooks (FOUND-09 + DESIGN-11) |

## Threat-model coverage

All 8 STRIDE threats from the plan's `<threat_model>` were addressed by acceptance criteria that PASSED:

| Threat ID | Status |
|---|---|
| T-05W3-01 (version drift) | mitigated — cross-manifest equality enforced |
| T-05W3-02 (email accidental change) | mitigated — both manifests verified unchanged at `jasonmichaelb@gmail.com` |
| T-05W3-03 (LICENSE content drift to permissive) | mitigated — byte-exact diff + negative grep against MIT/Apache/GPL/BSD/copyright(c) |
| T-05W3-04 (scaffold-dir content leak) | mitigated — C-6 canonical assertion holds for all three dirs |
| T-05W3-05 (accidental mcpServers add) | mitigated — `has("mcpServers")` returns false |
| T-05W3-06 (scaffold in wrong location) | mitigated — negative `! test -d .claude-plugin/<dir>` x3 |
| T-05W3-07 (Windows CRLF break LICENSE) | mitigated — `.gitattributes` LF pin + CR-grep gate + staged-blob byte verify |
| T-05W3-08 / T-6 (.gitattributes clobber) | mitigated — C-5 compliance: idempotent, no-clobber, no-conflicting-rule all PASS |

## Known Stubs

None. All three scaffold dirs are intentional empty placeholders per OPEN-Q21, DESIGN-04, D-56, with explicit deferral documentation in this Summary's "Task 4" section and in the plan body. No data-source wiring is expected — substantive content lands v2.6 / SURF-01..03.

## Downstream consequences

- **Plan 05-04 (Wave 4):** must add the `mcpServers` deferral row referencing cross-AI flag 5 closure (this Summary, "Task 1" section).
- **Plan 05-05 (Wave 5):** B.6 cosmetic-fix row gets footnoted "completed by W3 inline" rather than re-executed. B.4 LICENSE cosmetic row is satisfied by Task 3 of this plan.
- **Phase 6 (platform skills):** can now land inside `dydx-delivery/skills/` knowing the plugin-root scaffold (`commands/`, `agents/`, `hooks/`) is in place and version is 2.0.0.

## Self-Check: PASSED

- LICENSE exists at repo root (FOUND, 54 bytes)
- .gitattributes exists at repo root (FOUND, 20 bytes, LF-only, 1 line)
- dydx-delivery/commands/.gitkeep (FOUND, 0 bytes)
- dydx-delivery/agents/.gitkeep (FOUND, 0 bytes)
- dydx-delivery/hooks/.gitkeep (FOUND, 0 bytes)
- dydx-delivery/.claude-plugin/plugin.json modified (FOUND, version 2.0.0)
- .claude-plugin/marketplace.json modified (FOUND, 2.0.0 + B.6 homepage)
- Commit 2925b60 (FOUND in git log)
- Commit 7cc8b1d (FOUND in git log)
- Commit b6f62ac (FOUND in git log)
- Commit c462d43 (FOUND in git log)
