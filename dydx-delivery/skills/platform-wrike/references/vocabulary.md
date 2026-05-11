# Wrike — Vocabulary

> For project-wide terms see `dydx-delivery/references/glossary.md`.

## Platform-specific terms

**space** — Top-level workspace partition in Wrike. A tenant may have one or many spaces; spaces are the outermost container for folders, projects, and tasks. Maps to `space_id` in REST queries.

**folder** — Nested container within a space (or within another folder). Holds projects and tasks. Maps to `folder_id`.

**project** — A Wrike project within a space or folder. Carries tasks, custom fields, and a workflow state. Maps to `project_id`.

**task** — Individual work-item record. Carries title, description, assignees, custom field values, attachments, comments, and transition history. The lowest-grain Wrike entity.

**custom field** — Per-tenant typed field attached to projects or tasks. IDs do NOT match across tenants — per-client mapping lives in `<Client> Brain/00_HUB.md`.

**host** — Per-tenant Wrike regional host (e.g., `app-us2.wrike.com`, `app-eu.wrike.com`). MUST be persisted from the OAuth token response — NEVER hardcoded (per MOD-5 / DESIGN-15). Read at session start from `client_state.yaml` `wrike.host:`.

**account_id** — Per-tenant integer identifier surfaced in entry URLs (`?acc=<account_id>`). Used for tenant disambiguation.

**space_id** — Identifier for a Wrike space. Required in REST queries targeting space-scoped operations.

**Wrike Copilot** — Wrike's 2026 real-time AI capability surface in the workspace UI. Capability matrix tracked in `references/native-ai-inventory.md`.

**MCP Server** — Wrike MCP Server (`developers.wrike.com/wrike-mcp/`) providing tool-based programmatic access. Available but parked through v2.6 (UAT-3.5).

> Verification gate: synthesis-plan grep dedup confirms zero of these terms
> are ALSO defined in `dydx-delivery/references/glossary.md`. Cross-cutting
> terms (frontmatter / sandbox / native_ai_path / status: lifecycle) live in
> glossary.md, NOT here.
