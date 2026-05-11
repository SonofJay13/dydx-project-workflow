# dYdX Delivery — Stage numbering (canonical)

> Canonical SoT for the v2 stage-numbering scheme per DESIGN-02 (`.planning/DESIGN.md:78-89`). File-prefix is the stage number. Substages use letter suffixes (`4a/4b/7a/7b/8a-8d`). v0.3.0 in-flight artefacts NEVER renamed — readers tolerate old prefixes permanently per OPEN-Q15 decision (lenient-mode contract).

## Canonical v2 stages

| Stage | File-prefix | Skill | Output filename pattern | Downstream consumer |
|-------|-------------|-------|-------------------------|---------------------|
| Stage 1 | `01_` | `kickoff-capture` | `01_kickoff_v<N>.md` | `discovery-intake` OR `generate-sow` |
| Stage 2 | `02_` | `discovery-intake` | `02_discovery_v<N>.md` | `generate-sow` |
| Stage 3 | `03_` | `generate-sow` | `03_sow_v<N>.md` | `generate-fnspec-platform` AND/OR `generate-fnspec-integration` |
| Stage 4a | `04a_` | `generate-fnspec-platform` | `04a_fnspec-platform_v<N>.md` | `generate-fnspec-integration`, `generate-cost-estimate`, `generate-implementation-prompt`, `push-native-ai-knowledge` |
| Stage 4b | `04b_` | `generate-fnspec-integration` | `04b_fnspec-integration_v<N>.md` | `generate-technical-spec`, `generate-cost-estimate`, `generate-build-prompt` |
| Stage 5 | `05_` | `generate-technical-spec` | `05_techspec_v<N>.md` | `generate-cost-estimate`, `generate-build-prompt` |
| Stage 6 | `06_` | `generate-cost-estimate` | `06_cost_v<N>.md` (+ Coda task-table rows) | client-facing cost estimate |
| Stage 7a | `07a_` | `generate-build-prompt` | `07a_build-prompt_v<N>.md` | dev (human implementer) |
| Stage 7b | `07b_` | `generate-implementation-prompt` | `07b_implementation-prompt_v<N>.md` | non-dev per-platform human implementer |
| Stage 8a | `08a_` | `provision-test-harness` | `08a_test-harness_v<N>.md` + persistent harness | `execute-tests` |
| Stage 8b | `08b_` | `generate-test-plan` | `08b_test-plan_v<N>.md` | `execute-tests` |
| Stage 8c | `08c_` | `generate-uat-plan` | `08c_uat-plan_v<N>.md` | client |
| Stage 8d | `08d_` | `execute-tests` | `08d_test-results_v<N>.md` | `update-documentation` |
| Stage 9 | `09_` | `update-documentation` | `09_doc-diff_v<N>.md` (+ published Drive doc) | reviewer; `push-native-ai-knowledge` |
| Stage 10 | `10_` | `push-native-ai-knowledge` | (per-platform native-AI ingestion; `doc_version:` `ingested_at:` frontmatter) | client native-AI surface |
| Stage 11 | `11_` | `sign-off-and-archive` | `<Client> Brain/<spokes>/` updated + Coda mirror push + CR archived | Field Notes preserved; next CR's Stage 1 |

## Substages

### Stage 4 (split: 4a / 4b)

Per DESIGN-20, the legacy v0.3.0 `generate-functional-spec` skill is RETIRED-AND-REPLACED by a two-skill split:

- **Stage 4a — `generate-fnspec-platform`** — Platform-shaped functional spec. Output `04a_fnspec-platform_v<N>.md` carries a `delivery: native-ai | api` frontmatter switch per requirement. Downstream feeds: Stage 4b (integration spec), Stage 6 (cost estimate), Stage 7b (implementation prompt), Stage 10 (native-AI ingestion).
- **Stage 4b — `generate-fnspec-integration`** — Integration-shaped functional spec. Output `04b_fnspec-integration_v<N>.md`. Downstream feeds: Stage 5 (techspec), Stage 6 (cost estimate), Stage 7a (build prompt — dev).

Cross-spec consistency check (4a ↔ 4b) lives inside `generate-fnspec-integration`'s skill body.

### Stage 7 (split: 7a / 7b)

Per DESIGN-23, Stage 7 splits into two parallel prompt-authoring skills dispatched on `delivery_filter`:

- **Stage 7a — `generate-build-prompt`** (MODIFIED from v0.3.0) — `delivery_filter: api` path. Output `07a_build-prompt_v<N>.md`. Downstream consumer: dev human implementer.
- **Stage 7b — `generate-implementation-prompt`** (NEW, no v0.3.0 ancestor) — `delivery_filter: native-ai` path. Output `07b_implementation-prompt_v<N>.md`. Per-platform shape (NOT a universal template — dispatches on `platform:` frontmatter to one of three concrete template paths for Pipefy / Wrike / Ziflow). Downstream consumer: non-dev per-platform human implementer.

### Stage 8 (split: 8a / 8b / 8c / 8d)

Per DESIGN-24, Stage 8 is the test-bot cluster, four substages all feeding through to results:

- **Stage 8a — `provision-test-harness`** (NEW) — Harness provisioning. Output `08a_test-harness_v<N>.md` + persistent harness fixtures. Reads `client_state.yaml` + `sandbox_lock.yaml`.
- **Stage 8b — `generate-test-plan`** (MODIFIED from v0.3.0) — Output `08b_test-plan_v<N>.md`. Path also moves to `<Client> Brain/test-bot/test_cases/`.
- **Stage 8c — `generate-uat-plan`** (NEW) — Output `08c_uat-plan_v<N>.md`. Client-facing UAT plan.
- **Stage 8d — `execute-tests`** (MODIFIED from v0.3.0) — Output `08d_test-results_v<N>.md`. Resolves the AUDIT-05.5 [NEW] label collision (legacy filename was `results-YYYY-MM-DD_v*`).

## Old → new mapping table (v0.3.0 → v2)

| v0.3.0 prefix | v2 prefix | Stage | Notes |
|---|---|---|---|
| `00_discovery_*` | `02_discovery_*` | Stage 2 | discovery-intake MODIFIED |
| `01_sow_*` | `03_sow_*` | Stage 3 | generate-sow UNCHANGED-structure |
| `02_functional-spec_*` | `04a_fnspec-platform_*` | Stage 4a | SPLIT into 4a + 4b per DESIGN-20; legacy `generate-functional-spec` RETIRED |
| `03_technical-spec_*` | `05_techspec_*` | Stage 5 | generate-technical-spec MODIFIED |
| `04_build-prompt_*` | `07a_build-prompt-dev_*` | Stage 7a | generate-build-prompt MODIFIED (dev path) |
| `test-plan_v*` | `08b_test-plan_*` | Stage 8b | path also moves to `<Client> Brain/test-bot/test_cases/` |
| `results-YYYY-MM-DD_v*` | `08d_test-results_*` | Stage 8d | resolves AUDIT-05.5 [NEW] label collision |

## Lenient-mode policy (PERMANENT)

v0.3.0 artefact files already on disk in client folders are NEVER renamed. v2 readers tolerate old prefixes permanently — absent `frontmatter_version` field on an artefact means the reader assumes v0.3.0 conventions and accepts the old prefix. Migration is opt-in per Change Request; never bulk-rewritten. See DESIGN-08 (`.planning/DESIGN.md:181-193`) for the full migration co-existence contract.
