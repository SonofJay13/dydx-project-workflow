# Ziflow — Vocabulary

> For project-wide terms see `dydx-delivery/references/glossary.md`.

## Platform-specific terms

**proof** — A Ziflow review unit — a single asset (or a related set of assets) submitted for stakeholder review. Identified by `proof_id`. Subject to read-after-create eventual consistency (MOD-6 / Q05 — use webhook-PRIMARY framing per `references/api-contract.md`).

**review** — The process of reviewing a proof — comments, annotations, decisions captured against the proof.

**decision** — A reviewer's verdict on a proof at a particular stage (e.g., "Approve", "Approve with changes", "Send for revisions", "Not relevant"). Per-tenant label customisations live in `<Client> Brain/00_HUB.md`.

**stage** — A workflow step in a Ziflow review (distinct from dydx-delivery 11-stage pipeline; "stage" in Ziflow vocab is project-internal). Maps to ReviewAI Checklist application per project.

**version** — A revision of a proof. Each new uploaded version receives an incrementing version number; reviewers can decision against a specific version.

**project_id** — Identifier for a Ziflow project (per-tenant container for proofs).

**ReviewAI** — Ziflow's 2026 AI capability surface. Includes Checklists (Public Preview), Change Verification ("Coming Soon"), Brand Standards ("Coming Soon"), Checklist Templates API (GA April 2026). Capability matrix tracked in `references/native-ai-inventory.md`.

**Checklist** — A pre-authored set of pass/fail criteria applied to a proof during review. ReviewAI Checklists (Public Preview) provide AI-assisted evaluation; Stage 10 paste bundle authors per-client Checklist criteria.

**Change Verification** — A "Coming Soon" ReviewAI capability for verifying that a new proof version applies the requested changes from prior decisions.

**Brand Standards** — A "Coming Soon" ReviewAI capability for verifying that a proof meets per-client brand-standard rules.

> Verification gate: synthesis-plan grep dedup confirms zero of these terms
> are ALSO defined in `dydx-delivery/references/glossary.md`. Cross-cutting
> terms (frontmatter / sandbox / native_ai_path / status: lifecycle) live in
> glossary.md, NOT here.
