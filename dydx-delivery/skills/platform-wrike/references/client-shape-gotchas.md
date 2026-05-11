# Wrike — Client shape gotchas

> Append-only — new client shapes added per first-engagement; existing rows
> preserved for audit trail.

## Known shapes (verified)

### VodafoneZiggo (EU region — verified per DESIGN-15, 2026-05-10)

- **host:** `app-eu.wrike.com` (persisted from OAuth token response per DESIGN-15 / MOD-5)
- **account_id:** `5996999`
- **Entry URL pattern:** `https://app-eu.wrike.com/workspace.htm?acc=5996999`
- **Base URL for API calls:** `https://app-eu.wrike.com/api/v4`
- **Source artefact:** DESIGN-15 at `.planning/DESIGN.md:459-500`
- **Persistence:** `<Client> Brain/00_HUB.md` Coda block carries the host (per DESIGN-29 schema)

## Pattern slots (variant taxonomy)

### Regional host variants
- **US default:** `app.wrike.com` (US tenants without regional sharding)
- **US-2:** `app-us2.wrike.com` (US-2 region tenants)
- **EU:** `app-eu.wrike.com` (EU region tenants — e.g., VodafoneZiggo)
- All three are PERSISTED from OAuth token response — NEVER hardcoded.

### account_id per tenant
- Per-tenant integer identifier surfaced in entry URLs (`?acc=<account_id>`)
- Used for tenant disambiguation in multi-account Wrike workspaces
- Stored in `<Client> Brain/00_HUB.md` Wrike block

### Space + project nesting
- `space_id` — top-level workspace partition (per-tenant; may have multiple spaces)
- `folder_id` — nested folder within a space
- `project_id` — a project within a space or folder (carries tasks)
- Nesting depth varies per client — Pattern slot for "shallow vs deep nesting" awaits first-engagement data

### Custom field IDs per tenant
- Wrike custom fields are tenant-scoped — IDs do NOT match across clients
- Per-client mapping lives in `<Client> Brain/00_HUB.md` `wrike_custom_fields:` block
- Stage 4a fnspec MUST cite per-tenant custom field IDs explicitly, never assume cross-tenant consistency

## How to add a new shape

When onboarding a new client, append a verified row to `## Known shapes (verified)`
citing the engagement date + source artefact. Pattern slots are append-only;
existing rows are preserved for audit trail.
