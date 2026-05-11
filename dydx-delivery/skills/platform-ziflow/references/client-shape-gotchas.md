# Ziflow — Client shape gotchas

> Append-only — new client shapes added per first-engagement; existing rows
> preserved for audit trail.

## Known shapes (verified)

### Acme (DESIGN-16 worked example — placeholder, NOT a live tenant)

- **project_id:** `<acme-project-id>` (placeholder — replaced at first-engagement)
- **Source artefact:** DESIGN-16 at `.planning/DESIGN.md:502-543`
- **Note:** This row exists as a structural placeholder. The first real client engagement populates a verified row above this one and demotes Acme to "example" status.

### Up & Up Group (TBD at first Ziflow engagement)

- **project_id:** `<TBD at first engagement>`
- **review_workflow_stages:** `<TBD>`
- **review_decision_labels:** `<TBD>`
- **Source artefact:** `<TBD — populate from first engagement>`
- **Per `.claude/memory/reference_client_brain_coda_docs.md`:** Up & Up Group is one of the two documented Coda-brain clients; first Ziflow engagement may not coincide with first plugin engagement.

### VodafoneZiggo (TBD at first Ziflow engagement)

- **project_id:** `<TBD at first engagement>`
- **review_workflow_stages:** `<TBD>`
- **review_decision_labels:** `<TBD>`
- **Source artefact:** `<TBD — populate from first engagement>`
- **Per `.claude/memory/reference_client_brain_coda_docs.md`:** VodafoneZiggo is the second documented Coda-brain client (Wrike-verified at `app-eu.wrike.com`; Ziflow tenant TBD).

## Pattern slots (variant taxonomy)

### Workflow stage names per client
- Ziflow workflow stages are customisable per tenant (e.g., "In Review", "Approved", "Rejected", "On Hold")
- Per-client mapping lives in `<Client> Brain/00_HUB.md` `ziflow_workflow_stages:` block
- Stage 4a fnspec MUST cite per-tenant stage names explicitly

### Project naming conventions
- Tenant-defined naming patterns (e.g., `<Client> - <Campaign> - <Asset Type>` or `<Brand> / <Year> / <Quarter>`)
- Captured per-client in `<Client> Brain/00_HUB.md` for consistency across Stage 4a / Stage 8 / Stage 10

### Review-decision label customisations
- Default Ziflow labels: "Approve", "Approve with changes", "Send for revisions", "Not relevant"
- Tenants may customise label text and add per-stage labels
- Test bot tier-1 assertions consume the canonical label set from `<Client> Brain/00_HUB.md`

## How to add a new shape

When onboarding a new client, append a verified row to `## Known shapes (verified)`
citing the engagement date + source artefact. Pattern slots are append-only;
existing rows are preserved for audit trail.
