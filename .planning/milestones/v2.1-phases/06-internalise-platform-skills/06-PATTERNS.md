# Phase 6: Internalise Platform Skills — Pattern Map

**Mapped:** 2026-05-11
**Files analyzed:** 19 NEW + 1 modified
**Analogs found:** 19 / 19 (all NEW platform-skill files have strong analogs in the existing 7-skill set)

> Phase 6 is a **doc-only** phase. Files are Markdown SKILL definitions and `references/` content. Analog selection ranks the 7 existing stage skills (post-Phase-5 normalisation) plus 5 Phase-5 canonical references. The phase ships zero executable code.

## File Classification

| New / Modified File | Role | Data Flow | Closest Analog | Match Quality |
|---|---|---|---|---|
| `dydx-delivery/skills/platform-pipefy/SKILL.md` | reference-skill (SKILL.md) | doc-only (no I/O) | `dydx-delivery/skills/execute-tests/SKILL.md` | exact (closest — D-59 pointer + platform-aware) |
| `dydx-delivery/skills/platform-pipefy/references/api-contract.md` | platform-reference (api contract) | doc-only | `dydx-delivery/references/connector-matrix.md` § Resolved OPEN-Q values | role-match (doc-only contract; CONTEXT §Code Examples §Example 2 is closer in shape) |
| `dydx-delivery/skills/platform-pipefy/references/native-ai-inventory.md` | platform-reference (capability matrix) | doc-only | `dydx-delivery/references/connector-matrix.md` § Stage × connector grid | role-match (matrix shape + re-verification stamp) |
| `dydx-delivery/skills/platform-pipefy/references/knowledge-ingestion.md` | platform-reference (paste-bundle shape) | doc-only | `dydx-delivery/skills/discovery-intake/references/intake-template.md` | partial (sectioned reference template) |
| `dydx-delivery/skills/platform-pipefy/references/client-shape-gotchas.md` | platform-reference (variant taxonomy) | doc-only append-only | RESEARCH.md §Code Examples §Example 3 (Wrike worked seed) | exact (CONTEXT D-65 outlined) |
| `dydx-delivery/skills/platform-pipefy/references/vocabulary.md` | platform-reference (term list) | doc-only | `dydx-delivery/references/glossary.md` | exact (entries + pointer pattern) |
| `dydx-delivery/skills/platform-wrike/SKILL.md` | reference-skill (SKILL.md) | doc-only | `dydx-delivery/skills/execute-tests/SKILL.md` | exact |
| `dydx-delivery/skills/platform-wrike/references/api-contract.md` | platform-reference (api contract) | doc-only | `dydx-delivery/references/connector-matrix.md` § Resolved OPEN-Q values | role-match |
| `dydx-delivery/skills/platform-wrike/references/native-ai-inventory.md` | platform-reference (capability matrix) | doc-only | `dydx-delivery/references/connector-matrix.md` § Stage × connector grid | role-match |
| `dydx-delivery/skills/platform-wrike/references/knowledge-ingestion.md` | platform-reference (paste-bundle shape) | doc-only | `dydx-delivery/skills/discovery-intake/references/intake-template.md` | partial |
| `dydx-delivery/skills/platform-wrike/references/client-shape-gotchas.md` | platform-reference (variant taxonomy) | doc-only append-only | RESEARCH.md §Code Examples §Example 3 (Wrike worked seed, verbatim) | exact |
| `dydx-delivery/skills/platform-wrike/references/vocabulary.md` | platform-reference (term list) | doc-only | `dydx-delivery/references/glossary.md` | exact |
| `dydx-delivery/skills/platform-ziflow/SKILL.md` | reference-skill (SKILL.md) | doc-only | `dydx-delivery/skills/execute-tests/SKILL.md` | exact |
| `dydx-delivery/skills/platform-ziflow/references/api-contract.md` | platform-reference (api contract + webhook-PRIMARY framing) | doc-only | `dydx-delivery/references/connector-matrix.md` § Resolved OPEN-Q values | role-match |
| `dydx-delivery/skills/platform-ziflow/references/native-ai-inventory.md` | platform-reference (capability matrix) | doc-only | `dydx-delivery/references/connector-matrix.md` § Stage × connector grid | role-match |
| `dydx-delivery/skills/platform-ziflow/references/knowledge-ingestion.md` | platform-reference (paste-bundle shape) | doc-only | `dydx-delivery/skills/discovery-intake/references/intake-template.md` | partial |
| `dydx-delivery/skills/platform-ziflow/references/client-shape-gotchas.md` | platform-reference (variant taxonomy) | doc-only append-only | RESEARCH.md §Code Examples §Example 3 (shape, with Acme placeholder per D-65) | role-match |
| `dydx-delivery/skills/platform-ziflow/references/vocabulary.md` | platform-reference (term list) | doc-only | `dydx-delivery/references/glossary.md` | exact |
| `.planning/phases/06-internalise-platform-skills/scripts/phase6-structure-check.sh` | verification script (synthesis) | shell stdout | `.planning/phases/05-foundations/scripts/phase5-structure-check.sh` | exact (Phase 5 carry-forward per CONTEXT §code_context) |
| `.planning/OPEN-QUESTIONS.md` (MODIFY — 3 row flips) | register edit | doc-only row-flip | Phase 5 D-57 inline-resolution row flips (already applied in same file) | exact pattern carry |

---

## Pattern Assignments

### `dydx-delivery/skills/platform-{pipefy,wrike,ziflow}/SKILL.md` (reference-skill, doc-only)

**Primary analog:** `dydx-delivery/skills/execute-tests/SKILL.md` (Phase 5-normalised — D-59 hard-rules pointer applied at line 22; platform-aware skill that loads platform skills downstream).

**Secondary analog (frontmatter shape baseline):** `dydx-delivery/skills/discovery-intake/SKILL.md:1-4` — 3-line YAML frontmatter style (no v0.3.0 verbosity).

**Frontmatter pattern** (`execute-tests/SKILL.md:1-4`, extended per Phase-6 RESEARCH.md §Frontmatter Schema lines 678-713):
```yaml
---
name: execute-tests
description: Execute an approved test plan against a client's sandbox tenant. Use when the user says "execute tests", "run test plan", "run regression", "run the QA plan", or asks to test a feature whose test plan is already drafted. Reads the highest-version test plan, loads the matching platform skill for API access, executes each test row in the sandbox, and writes a versioned results file. Read-write only — refuses deletes and destructive actions.
---
```

Phase 6 extends this with the 3 platform-skill-specific fields per CONTEXT spec_lock + RESEARCH.md §Frontmatter Schema. Per-platform locked frontmatter (lift from RESEARCH.md:678-713 verbatim — three templates already drafted, one per platform; reproduced in §Shared Patterns below).

**Title + intro pattern** (`execute-tests/SKILL.md:6-8`):
```markdown
# execute-tests

Run an approved test plan against the client's sandbox tenant and write the results. This is the terminal stage of the dydx-delivery pipeline.
```

Phase 6 mirrors:
```markdown
# platform-pipefy

Pipefy platform reference for the dydx-delivery plugin. Any stage skill operating
against a Pipefy tenant loads this skill alongside the stage-specific skill;
artefact frontmatter `platform: pipefy` is the routing key.
```

(Lift verbatim from RESEARCH.md:996-1000 §Code Examples §Example 1.)

**`## Inputs` + `## Output` pattern** (`execute-tests/SKILL.md:10-18`):
```markdown
## Inputs

- The latest `<Client>/testing/<feature>/08b_test-plan_v*.md` (required, must have `status: approved`)
- Sandbox tenant credentials (loaded from the client's secrets store or provided by user)
- Platform skill loaded based on `platform:` frontmatter

## Output

`<Client>/testing/<feature>/08d_test-results_vN.md`
```

Phase 6 platform SKILL.md adapts this — Inputs = artefact carrying `platform: <name>` + sandbox block; Output = "This skill produces NO artefacts. It is a reference skill" (per RESEARCH.md:1010-1012). Distinct from stage skills which produce versioned artefacts.

**Hard-rules pointer pattern (D-59 uniform — MANDATORY)** (`execute-tests/SKILL.md:20-22`):
```markdown
## Hard rules

> **Hard rules:** Sandbox-only operations. Read-write only against named sandbox tenants. Refuses destructive actions. See `dydx-delivery/references/safety-rules.md` for the canonical ruleset.
```

**Copy this block VERBATIM** into each of the 3 platform SKILL.md files. Phase 5 D-59 / FOUND-05 enforced this in the existing 7 skills; Phase 6 platform SKILL.md MUST carry it identically. Synthesis structure-check greps for the exact string.

**`## What this skill provides` pattern** (RESEARCH.md:1018-1028 — no existing analog because platform skills are NEW; the section enumerates the 5 references/ files):
```markdown
## What this skill provides

- `references/api-contract.md` — GraphQL endpoint (canonical-only `api.pipefy.com/graphql`),
  auth header shape, rate limit (500 req/30s ceiling; 13 req/sec throttle), HTML-on-auth-failure
  detection (UAT-4.1), `paginate_all` helper contract (MOD-4).
- `references/native-ai-inventory.md` — 2026 AI Agents 2.0 capability matrix
  (KB / Skills / MCP / IDP / Web Search / BYO-LLM).
- `references/knowledge-ingestion.md` — Paste-only Stage 10 path (UAT-6.1).
- `references/client-shape-gotchas.md` — Per-client pipe shape variations
  (Vodacom custom-subdomain verified seed).
- `references/vocabulary.md` — Pipefy-specific terms.
```

**`## Re-verification trigger` pattern (D-68 — MANDATORY)** (RESEARCH.md:1030-1041 + 717-735):
```markdown
## Re-verification trigger

Re-verify `references/native-ai-inventory.md` against current {Pipefy AI Agents |
Wrike Copilot | Ziflow ReviewAI} documentation BEFORE any v2.x phase that consumes
the capability matrix:
- Stage 4a delivery routing (consumes confidence ratings)
- Stage 7b implementation prompt (consumes capability surface list)
- Stage 10 native-AI paste bundle (consumes paste targets — Behaviors / Copilot
  workflow narratives / ReviewAI Checklist criteria)

Update `tier_claims_last_verified:` on this SKILL.md frontmatter after each
re-verification, citing the source doc URL + date in commit message.
```

Per-platform doc URL anchor (RESEARCH.md:731-735):
- Pipefy: `https://www.pipefy.com/` + Pipefy Help Center
- Wrike: `https://developers.wrike.com/wrike-mcp/` + `https://www.wrike.com/ai/mcp/`
- Ziflow: `https://api-docs.ziflow.com/` + `https://www.ziflow.com/reviewai`

**Anti-patterns (forbidden)** — repeated from RESEARCH.md:284-294:
- DO NOT inline safety-rules content (D-59 violation; AUDIT-05.1 anti-pattern).
- DO NOT use `native_ai_path: api` anywhere (PLAT-05 grep gate; zero hits required).
- DO NOT share a single `tier_claims_last_verified:` date across the 3 platforms (D-68 violation — per-platform distinct dates).
- DO NOT omit `platform:` or `frontmatter_version: 2` (Phase 5 FOUND-03 contract).

---

### `dydx-delivery/skills/platform-{pipefy,wrike,ziflow}/references/api-contract.md` (platform-reference, doc-only)

**Primary analog:** `dydx-delivery/references/connector-matrix.md` (Phase-5-shipped, doc-only canonical reference — same role: per-platform API contract documentation; same data flow: doc-only consumed at session start by skills downstream).

**Secondary analog (helper-contract structure, verbatim):** RESEARCH.md §Code Examples §Example 2 lines 1048-1098 (Pipefy `paginate_all` worked example, already drafted in research).

**Title + scope-lock callouts pattern** (`connector-matrix.md:1-10`):
```markdown
# dYdX Delivery — Connector availability matrix (canonical)

> Canonical SoT per DESIGN-07 (`.planning/DESIGN.md:162-178`). Documents session-start probe behaviour for each MCP/API the plugin depends on, plus per-stage graceful-degradation fallback when a connector is missing. **Doc-only per D-56** — no slash command, no agent, no probe hook ships in Phase 5; skills read this matrix at session start. Manual re-run via `claude mcp list` against the matrix.
>
> **Scope locks (UAT 2026-05-10):** Pipefy/Wrike/Ziflow are API-only through v2.6 (UAT-3.5) — no MCP path branches for those 3 platforms. Native-AI ingestion APIs are OUT-OF-SCOPE entirely (UAT-6.1) — Stage 10 = paste-only. Pipefy API endpoint canonical-only `api.pipefy.com/graphql` (UAT-4.1 / Q24 verified 2026-05-10).
```

Phase 6 mirrors this: open `api-contract.md` with a top-block scope-lock note (cite DESIGN-14/15/16 + UAT-4.1/3.5/6.1) + the UAT scope-lock callouts so downstream consumers see the constraint immediately.

**Auth header & secret-handling note** (`connector-matrix.md:31`):
```markdown
> **Auth header & secret-handling note (T-3 — security_threat_model):** All endpoint rows above document the auth header NAME + value SHAPE only (e.g., `Authorization: Bearer <token>`). NEVER paste real tokens, API keys, OAuth refresh tokens, or session cookies into this file. Tokens live in per-tenant `client_state.yaml` (gitignored) or env vars — never in the canonical reference set.
```

Phase 6 api-contract.md MUST carry an equivalent block (auth-shape only — never paste real tokens). Lift the wording near-verbatim.

**Per-platform section outline (mandatory headers, locked per RESEARCH.md:456-494):**
```markdown
# {Pipefy | Wrike | Ziflow} — API contract

## Endpoint(s) + auth shape
## Rate limit + throttle
## Auth-failure detection
## Helper contract(s)
## Multi-tenant auth concurrency
## MCP availability (UAT-3.5 — PARKED REFERENCE)
```

**Helper-contract sub-structure (D-64 — 7-part uniform structure per RESEARCH.md:255-280):**
```markdown
## <helper_name>

**Signature:** `<helper_name>(<params with types>) -> <return shape>`

**Behaviour:** <1-3 sentences — what the helper does + why it exists (cite MOD-N)>

**Retry / poll budget:** <e.g. "max_wait_s=30 default, interval_s=2 default — bounded retry budget">

**Failure modes:**
- <mode 1>: <detection + return / raise shape>
- <mode 2>: <detection + return / raise shape>

**Return shape:** <typed return — e.g., `list[dict]` or `dict | None` or raise pattern>

**Pseudocode:**
```python
# Phase 6 ships pseudocode only — Stage 8 (v2.4 / Phase 8) authors the real implementation
# against this contract per D-64 / D-56 doc-only precedent.
def <helper_name>(<params>):
    ...
```

**Worked example:** <inputs + expected output for one canonical case>
```

**Per-platform helper content (already drafted in RESEARCH.md — lift verbatim):**
- Pipefy `paginate_all` → RESEARCH.md:313-351 (full 7-part block); add `## Auth-failure detection` subsection for HTML-on-auth-failure gotcha (UAT-4.1) before the helper.
- Wrike OAuth-host persistence pattern → RESEARCH.md:353-397 (3-step pseudocode); call out hardcoded `www.wrike.com` as forbidden anti-pattern.
- Ziflow `wait_for_proof` → RESEARCH.md:399-447 (full 7-part block); **MUST open with webhook-PRIMARY framing** per Q05 resolution (RESEARCH.md:403 IMPORTANT block) — `wait_for_proof` is documented as FALLBACK only.

**Rate-limit / throttle subsection content (resolves Q06.2 / Q07.2 inline):**
- Pipefy: 16.67 req/sec ceiling → 13 req/sec throttle (80% buffer); backoff `[1s, 2s, 4s]`; lift from RESEARCH.md:642-656.
- Wrike: 400 req/min/user ceiling → 320 req/min/user throttle (80%); lift from RESEARCH.md:658-672.
- Ziflow: polling-bounded by `max_wait_s` (no per-call rate-limit calibration needed); webhook-primary path is event-driven.

**MCP-availability parked-reference subsection (UAT-3.5):**
- Pipefy: "Pipedream Pipefy MCP available but not adopted through v2.6" (RESEARCH.md:490)
- Wrike: "Wrike MCP Server available (per `developers.wrike.com/wrike-mcp/`) but not adopted through v2.6 — current vendor count = 47 tools per stackone.com (2026-05-11)" (RESEARCH.md:491-492; reconcile with DESIGN-15 16-tool baseline at PLAT-02)
- Ziflow: "No MCP — direct REST only" (RESEARCH.md:493)

---

### `dydx-delivery/skills/platform-{pipefy,wrike,ziflow}/references/native-ai-inventory.md` (capability-matrix reference)

**Primary analog:** `dydx-delivery/references/connector-matrix.md` § Stage × connector grid (lines 37-51 — table-driven capability matrix; same role).

**Table shape pattern** (`connector-matrix.md:37-39`):
```markdown
| Stage | Coda MCP | Google Workspace MCP | Miro MCP | Pipefy API | Wrike API | Ziflow API |
|---|---|---|---|---|---|---|
| Stage 1 Kickoff | GRACEFUL | N/A | GRACEFUL | N/A | N/A | N/A |
```

Phase 6 capability matrix shape (already drafted in RESEARCH.md:741-771 — lift verbatim):
```markdown
| Capability | Available? | Surface | Confidence |
|---|---|---|---|
| Knowledge base | yes | Pipefy AI Agents → KB | HIGH |
| Skills | yes | AI Agents → Skills | HIGH |
| MCP integration | **flag for re-verify** | AI Agents → MCP | **DESIGN-14 = HIGH; current research = MEDIUM** — one secondary 2026 source contradicts ... |
```

**Section outline (locked per RESEARCH.md:499-526):**
```markdown
# {Pipefy | Wrike | Ziflow} — Native-AI inventory

> `tier_claims_last_verified:` matches SKILL.md frontmatter value (2026-05-09 baseline
> per D-68; updated to execution date if fresh re-verification happens during this plan).

## Re-verification trigger
## Capability matrix (2026-grounded)
## Paste-only delivery (UAT-6.1)
```

**Per-platform matrix content (verbatim lift from DESIGN.md / RESEARCH.md):**
- Pipefy: 6-row matrix (KB / Skills / MCP / IDP / Web Search / BYO-LLM) — RESEARCH.md:742-748; PLAT-01 MAY re-verify MCP row against current Pipefy AI Agents 2.0 launch docs (`globenewswire.com/news-release/2025/11/12/3186348`).
- Wrike: 4-row Copilot + MCP matrix per DESIGN-15; reconcile 16-tool baseline against current 47-tool count (RESEARCH.md:615) at PLAT-02 execution.
- Ziflow: 4-row ReviewAI matrix (Checklists Public Preview + Change Verification / Brand Standards "Coming Soon" + Checklist Templates API GA April 2026) per DESIGN-16 + RESEARCH.md:615.

---

### `dydx-delivery/skills/platform-{pipefy,wrike,ziflow}/references/knowledge-ingestion.md` (paste-bundle reference)

**Primary analog:** `dydx-delivery/skills/discovery-intake/references/intake-template.md` (sectioned doc template, no executable behaviour).

**Section outline (locked per RESEARCH.md:531-547):**
```markdown
# {Pipefy | Wrike | Ziflow} — Knowledge ingestion

## Primary path (paste-only per UAT-6.1)
## Audit log shape
## Fallback (manual paste via UI)
```

**Per-platform content (RESEARCH.md:616 cross-platform parity row):**
- Pipefy: Pipefy Behaviors instructions + KB upload list (manual upload via Pipefy UI per UAT-6.1).
- Wrike: Wrike Copilot workflow narrative + MCP tool config + attach-doc-via-MCP instructions (manual via Wrike UI).
- Ziflow: ReviewAI Checklist criteria (manual via Ziflow UI); copy-paste fallback per DESIGN-16.

**Audit-log shape pattern** — cite Stage 10 audit-log fields: `ingested_at:`, `doc_version:`, `target_id:`, manual-upload acknowledgement. No code shipped; cite DESIGN-26 / Stage 10 contract.

---

### `dydx-delivery/skills/platform-{pipefy,wrike,ziflow}/references/client-shape-gotchas.md` (variant-taxonomy reference)

**Primary analog:** RESEARCH.md §Code Examples §Example 3 lines 1104-1157 (Wrike VodafoneZiggo worked seed — drafted in full, lift verbatim).

**Section outline (locked per RESEARCH.md:552-583 + D-65):**
```markdown
# {Pipefy | Wrike | Ziflow} — Client shape gotchas

> Append-only — new client shapes added per first-engagement; existing rows
> preserved for audit trail.

## Known shapes (verified)

### <Client name> (<region / variant> — verified per <DESIGN-N / source>, <date>)

- **<Field 1>:** <value>
- **<Field 2>:** <value>
- **Source artefact:** <DESIGN-N at file:line>

## Pattern slots (variant taxonomy)

### <Variant axis 1>
### <Variant axis 2>
### <Variant axis 3>

## How to add a new shape

[One-line maintenance contract from RESEARCH.md:580-582]
```

**Per-platform seed content (D-65 verbatim lifts from DESIGN.md):**
- Pipefy: Vodacom custom-subdomain (`web_host: vodacom.pipefy.com/{org_id}`; API canonical `api.pipefy.com/graphql`); pattern slots: `web_host` default vs custom-subdomain; `org_id` semantics; `pipe_id` vs `phase_id` vs `card_id` distinction. Source: DESIGN-14 REVISED at `.planning/DESIGN.md:408-457`.
- Wrike: VodafoneZiggo EU tenant (host `app-eu.wrike.com`, account `5996999`, entry URL `app-eu.wrike.com/workspace.htm?acc=5996999`); pattern slots: regional host variants (us / us-2 / eu), account_id per tenant, space + project nesting, custom field IDs per tenant. **VERBATIM lift from RESEARCH.md:1105-1156 (already drafted).** Source: DESIGN-15 at `.planning/DESIGN.md:488`.
- Ziflow: Acme placeholder (DESIGN-16 worked example) + `<TBD at first engagement>` markers for Up & Up Group + VodafoneZiggo (per `.claude/memory/reference_client_brain_coda_docs.md`); pattern slots: workflow stage names per client, project naming conventions, review-decision label customisations. Source: DESIGN-16 at `.planning/DESIGN.md:502-543`.

---

### `dydx-delivery/skills/platform-{pipefy,wrike,ziflow}/references/vocabulary.md` (term-list reference)

**Primary analog:** `dydx-delivery/references/glossary.md` (sectioned alphabetical term list; same role — vocabulary reference).

**Entry-style pattern** (`glossary.md:44-49`):
```markdown
**approved_at** — ISO-8601 timestamp recording sign-off time; mandatory on `status: approved` writes per DESIGN-06. Hook refuses write if missing.
**approved_by** — Human author name recording sign-off identity; mandatory on `status: approved` writes per DESIGN-06. Hook refuses literal `Claude` / `AI` / `system` values.
**based_on_cost** — Frontmatter field on `07a_*` / `07b_*` artefacts pointing at the upstream `06_cost_v<N>.md` per DESIGN-22 / DESIGN-23.
```

Phase 6 vocabulary.md uses the same `**term** — definition.` entry pattern.

**Section outline (locked per RESEARCH.md:588-606 + D-66):**
```markdown
# {Pipefy | Wrike | Ziflow} — Vocabulary

> For project-wide terms see `dydx-delivery/references/glossary.md`.

## Platform-specific terms

**<term-1>** — <platform-specific definition>.
**<term-2>** — <platform-specific definition>.

> Verification gate: synthesis-plan grep dedup confirms zero of these terms
> are ALSO defined in `dydx-delivery/references/glossary.md`. Cross-cutting
> terms (frontmatter / sandbox / native_ai_path / status: lifecycle) live in
> glossary.md, NOT here.
```

**Per-platform term lists (D-66 — platform-specific ONLY; do NOT duplicate glossary entries):**
- Pipefy: `pipe`, `phase`, `card`, `connection`, `org_id`, `web_host` (per-tenant variant), `pipe_id`, `phase_id`, `card_id`, `Behaviors`, `Pipefy AI Agents`.
- Wrike: `space`, `folder`, `project`, `task`, `custom field`, `host` (OAuth-persisted), `account_id`, `space_id`, `Wrike Copilot`, `MCP Server`.
- Ziflow: `proof`, `review`, `decision`, `stage`, `version`, `project_id`, `ReviewAI`, `Checklist`, `Change Verification`, `Brand Standards`.

**Dedup gate (synthesis plan):** `grep -r '<glossary-term>' skills/platform-*/references/vocabulary.md` MUST return zero hits for: `frontmatter`, `sandbox`, `native_ai_path`, `status:` lifecycle terms. See `glossary.md` § Frontmatter terms (lines 44-60+) for the canonical SoT list.

---

### `.planning/phases/06-internalise-platform-skills/scripts/phase6-structure-check.sh` (verification script — synthesis-plan deliverable)

**Primary analog:** `.planning/phases/05-foundations/scripts/phase5-structure-check.sh` (421 LOC, ~40 PASS assertions per CONTEXT §code_context).

**Phase 6 assertion set (mirror Phase 5 shape):**
- Per-file existence: 18 files (3 platforms × 6 files = 18 — SKILL.md + 5 references each).
- 5-file `references/` shape parity: every platform carries identical file list.
- Uniform hard-rules pointer present in each platform SKILL.md (grep for D-59 exact string).
- `grep -r 'native_ai_path: api' skills/platform-*/` returns zero hits (PLAT-05 / UAT-6.1 grep gate).
- `tier_claims_last_verified:` frontmatter present on each SKILL.md.
- `frontmatter_version: 2` present on each SKILL.md.
- `platform:` field present with closed-enum value (`pipefy | wrike | ziflow`) on each SKILL.md.
- Vocabulary dedup grep: zero hits for `frontmatter` / `sandbox` / `native_ai_path` / `status:` in `skills/platform-*/references/vocabulary.md`.
- `.planning/OPEN-QUESTIONS.md` Q05 / Q06.2 / Q07.2 Status = `decided`.

**Pattern carry:** Phase 5 script's `PASS: <assertion>` / `FAIL: <assertion>` stdout protocol is preserved verbatim. Caller pipes to grep for `FAIL` to exit non-zero.

---

### `.planning/OPEN-QUESTIONS.md` (MODIFY — 3 row Status flips)

**Pattern carry:** Phase 5 D-57 inline-resolution row flips (8 connector OPEN-Qs Q06.1/Q07.1/Q09/Q10/Q11/Q12/Q13/Q25) already exist in this file as a verbatim model.

**Per-row flip content (drafted in RESEARCH.md:640, 656, 672):**
- Q05 → `decided`. One-liner: "Webhook-primary per vendor guidance (`help.ziflow.com/hc/en-us/articles/30725068740244-Webhooks`); `wait_for_proof` fallback defaults confirmed at `max_wait_s=30` / `interval_s=2`. Cited at `dydx-delivery/skills/platform-ziflow/references/api-contract.md` § wait_for_proof."
- Q06.2 → `decided`. One-liner: "Helpers throttle at 13 req/sec per token (80% of 16.67 req/sec ceiling per Phase 5 Q06.1 = `dydx-delivery/references/connector-matrix.md:72`). Cited at `dydx-delivery/skills/platform-pipefy/references/api-contract.md` § Rate limit + throttle."
- Q07.2 → `decided`. One-liner: "Helpers throttle at 320 req/min per user (80% of 400 ceiling per Phase 5 Q07.1 = `dydx-delivery/references/connector-matrix.md:73`). Cited at `dydx-delivery/skills/platform-wrike/references/api-contract.md` § Rate limit + throttle."

**Sequential within synthesis plan** (per CONTEXT D-63) — single-owner write to avoid inter-plan conflict.

---

## Shared Patterns

### D-59 Uniform Hard-Rules Pointer (MANDATORY across all 3 platform SKILL.md)

**Source:** `dydx-delivery/skills/execute-tests/SKILL.md:20-22` (Phase 5-normalised; FOUND-05 carried).

**Apply to:** Every platform SKILL.md (3 files).

**Block (COPY VERBATIM):**
```markdown
## Hard rules

> **Hard rules:** Sandbox-only operations. Read-write only against named sandbox tenants. Refuses destructive actions. See `dydx-delivery/references/safety-rules.md` for the canonical ruleset.
```

**Verification:** Synthesis-plan structure-check greps for the exact pointer string in each platform SKILL.md.

---

### Locked Frontmatter Schema (per-platform SKILL.md)

**Source:** RESEARCH.md:678-713 + `dydx-delivery/references/frontmatter-scheme.md:1-55` + CONTEXT spec_lock UAT-6.1 + D-68.

**Apply to:** Every platform SKILL.md (3 files).

**Template (Pipefy — adapt name/description/platform per file):**
```yaml
---
name: platform-pipefy
description: Provide Pipefy GraphQL API contract + 2026 AI Agents capability matrix + per-client shape gotchas + vocabulary for any stage skill that targets a Pipefy tenant. Use when artefact frontmatter carries `platform: pipefy`. Documents the `paginate_all` helper contract for cursor pagination; the HTML-on-auth-failure detection rule (Pipefy returns Keycloak login HTML, not JSON 401); the canonical-only API endpoint (`api.pipefy.com/graphql` for ALL tenants); paste-only native-AI ingestion path per UAT-6.1. Does NOT execute API calls — pure reference content for skills + Stage 8 test bot.
frontmatter_version: 2
platform: pipefy
tier_claims_last_verified: 2026-05-09
native_ai_path: paste
---
```

**Wrike + Ziflow templates:** RESEARCH.md:692-713 verbatim.

**Locked invariants (synthesis structure-check gates):**
- `frontmatter_version: 2` (FOUND-03 contract).
- `platform:` closed-enum {pipefy | wrike | ziflow}.
- `native_ai_path:` closed-enum {paste | none} — `api` FORBIDDEN (PLAT-05 grep gate).
- `tier_claims_last_verified:` ISO-date present + per-platform distinct (D-68).

---

### D-68 Re-verification Trigger Block (per-platform SKILL.md)

**Source:** RESEARCH.md:717-735 (drafted boilerplate; per-platform doc URL anchor differs).

**Apply to:** Every platform SKILL.md (3 files).

**Block:**
```markdown
## Re-verification trigger

Re-verify `references/native-ai-inventory.md` against current {Pipefy AI Agents |
Wrike Copilot | Ziflow ReviewAI} documentation BEFORE any v2.x phase that consumes
the capability matrix:
- Stage 4a delivery routing (consumes confidence ratings)
- Stage 7b implementation prompt (consumes capability surface list)
- Stage 10 native-AI paste bundle (consumes paste targets — Behaviors / Copilot
  workflow narratives / ReviewAI Checklist criteria)

Update `tier_claims_last_verified:` on this SKILL.md frontmatter after each
re-verification, citing the source doc URL + date in commit message.
```

Doc URL anchor (per platform):
- Pipefy: `https://www.pipefy.com/` + Pipefy Help Center
- Wrike: `https://developers.wrike.com/wrike-mcp/` + `https://www.wrike.com/ai/mcp/`
- Ziflow: `https://api-docs.ziflow.com/` + `https://www.ziflow.com/reviewai`

---

### D-64 Helper-Contract 7-Part Structure (api-contract.md)

**Source:** CONTEXT D-64 + RESEARCH.md:255-280 + worked example at RESEARCH.md:1048-1098.

**Apply to:** Every platform `references/api-contract.md` (3 files — Pipefy `paginate_all`; Wrike OAuth-host persistence 3-step pattern; Ziflow `wait_for_proof` FALLBACK).

**Locked 7-part structure (per helper):**
1. **Signature** — typed function/pattern signature.
2. **Behaviour** — 1-3 sentences, cite MOD-N.
3. **Retry / poll budget** — bounded budget (per-platform throttle ceiling + backoff curve).
4. **Failure modes** — bulleted list of detection → raise/return shape.
5. **Return shape** — typed return.
6. **Pseudocode** — Python pseudocode block (NOT executable; doc-only per D-64).
7. **Worked example** — inputs + expected output for one canonical case.

**Anti-pattern:** Skipping pseudocode (the 7th part) — Stage 8 test bot is the downstream consumer; without pseudocode the contract is under-specified.

---

### Vocabulary Pointer Pattern (vocabulary.md)

**Source:** D-66 + `glossary.md` (Phase 5 canonical SoT for project-wide terms).

**Apply to:** Every platform `references/vocabulary.md` (3 files).

**Opening line (verbatim):**
```markdown
> For project-wide terms see `dydx-delivery/references/glossary.md`.
```

**Closing verification block (verbatim):**
```markdown
> Verification gate: synthesis-plan grep dedup confirms zero of these terms
> are ALSO defined in `dydx-delivery/references/glossary.md`. Cross-cutting
> terms (frontmatter / sandbox / native_ai_path / status: lifecycle) live in
> glossary.md, NOT here.
```

---

### Auth-Shape Secret-Handling Note (api-contract.md)

**Source:** `connector-matrix.md:31` — T-3 security_threat_model lock.

**Apply to:** Every platform `references/api-contract.md` (3 files).

**Block (lift near-verbatim, swap "endpoint rows above" for "helper contracts below"):**
```markdown
> **Auth header & secret-handling note:** All helper contracts below document the auth header NAME + value SHAPE only (e.g., `Authorization: Bearer <token>`). NEVER paste real tokens, API keys, OAuth refresh tokens, or session cookies into this file. Tokens live in per-tenant `client_state.yaml` (gitignored) or env vars — never in the canonical reference set.
```

---

### Append-Only Maintenance Contract (client-shape-gotchas.md)

**Source:** CONTEXT D-65 + RESEARCH.md:553-555.

**Apply to:** Every platform `references/client-shape-gotchas.md` (3 files).

**Opening note (verbatim):**
```markdown
> Append-only — new client shapes added per first-engagement; existing rows
> preserved for audit trail.
```

**Closing maintenance section (verbatim per RESEARCH.md:578-582):**
```markdown
## How to add a new shape

When onboarding a new client, append a verified row to `## Known shapes (verified)`
citing the engagement date + source artefact. Pattern slots are append-only;
existing rows are preserved for audit trail.
```

---

## No Analog Found

No files in this phase lack analogs. All 19 NEW files and 1 MODIFIED file map to existing project artefacts:

- The 7 existing stage skills (`dydx-delivery/skills/{discovery-intake, generate-sow, generate-functional-spec, generate-technical-spec, generate-build-prompt, generate-test-plan, execute-tests}/SKILL.md` + their `references/`) supply the SKILL.md + references/-shape patterns.
- The 5 Phase-5 canonical references (`dydx-delivery/references/{safety-rules.md, stage-numbering.md, frontmatter-scheme.md, glossary.md, connector-matrix.md}`) supply the canonical-reference patterns (table shapes, scope-lock callouts, term-list entries, auth-shape secret-handling note).
- RESEARCH.md §Code Examples §Example 1/2/3 supplies the Phase-6-specific worked content (already drafted; lift verbatim).
- Phase 5 structure-check script supplies the verification-script pattern.

> **Confidence note:** Two analogs are "role-match" rather than "exact" — `knowledge-ingestion.md` analogs to `intake-template.md` (partial; both are sectioned doc templates, but intake-template carries form-style placeholders whereas knowledge-ingestion carries narrative paragraphs). Planner should treat the RESEARCH.md outline (lines 531-547) as the authoritative shape, not the intake-template structure.

---

## Metadata

**Analog search scope:**
- `dydx-delivery/skills/**/SKILL.md` (7 files — all Phase-5-normalised stage skills)
- `dydx-delivery/skills/**/references/*.md` (9 files)
- `dydx-delivery/references/*.md` (5 Phase-5 canonical files)
- `.planning/phases/05-foundations/scripts/phase5-structure-check.sh` (verification-script pattern)
- `.planning/phases/06-internalise-platform-skills/06-RESEARCH.md` (drafted worked content)

**Files scanned:** 22

**Pattern extraction date:** 2026-05-11

## PATTERN MAPPING COMPLETE
