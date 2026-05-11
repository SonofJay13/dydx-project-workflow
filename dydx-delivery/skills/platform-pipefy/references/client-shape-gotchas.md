# Pipefy — Client shape gotchas

> Append-only — new client shapes added per first-engagement; existing rows
> preserved for audit trail.

## Known shapes (verified)

### Vodacom (custom-subdomain — verified per DESIGN-14 REVISED, 2026-05-10)

- **web_host:** `vodacom.pipefy.com/{org_id}` (custom-subdomain pattern)
- **API host:** `api.pipefy.com/graphql` (canonical-only for ALL tenants per UAT-4.1 / Q24 — verified via DNS test 2026-05-10; `api.vodacom.pipefy.com` does NOT resolve)
- **org_id:** required path segment for web URLs; NOT required in GraphQL API calls
- **Source artefact:** DESIGN-14 REVISED at `.planning/DESIGN.md:408-457`

## Pattern slots (variant taxonomy)

### Web host variants
- **Default:** `app.pipefy.com/{org_id}` (most tenants)
- **Custom-subdomain:** `<subdomain>.pipefy.com/{org_id}` (Vodacom and similar — enterprise white-label)

### org_id semantics
- Required path segment in web URLs
- NOT required in GraphQL API calls (API endpoint is canonical-only)
- Per-tenant — stored in `<Client> Brain/00_HUB.md` Pipefy block

### Identifier distinction
- `pipe_id` — a Pipefy "pipe" (workflow); pipes contain phases
- `phase_id` — a phase within a pipe; phases contain cards
- `card_id` — an individual card (work-item) within a phase
- These three identifiers MUST NOT be conflated — every GraphQL query targets one of the three explicitly.

## How to add a new shape

When onboarding a new client, append a verified row to `## Known shapes (verified)`
citing the engagement date + source artefact. Pattern slots are append-only;
existing rows are preserved for audit trail.
