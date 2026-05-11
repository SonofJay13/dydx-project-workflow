# Pipefy — Vocabulary

> For project-wide terms see `dydx-delivery/references/glossary.md`.

## Platform-specific terms

**pipe** — A Pipefy workflow container. Each pipe holds one or more phases and a set of cards moving through those phases. Maps to `pipe_id` in GraphQL queries.

**phase** — A stage within a pipe (e.g., "Backlog", "In progress", "Review", "Done"). Cards transition between phases via API or UI actions. Maps to `phase_id`.

**card** — An individual work-item record within a phase. Carries field values, attachments, comments, and transition history. Maps to `card_id`.

**connection** — A Pipefy concept linking two records (e.g., a card to a database record). Connections are typed and bidirectional.

**org_id** — Per-tenant organisation identifier; required path segment in web URLs (`<host>/<org_id>/...`) but NOT required in GraphQL API calls (API endpoint is canonical-only per UAT-4.1).

**web_host** — Per-tenant web host (e.g., `app.pipefy.com`, `vodacom.pipefy.com`). Used for web URLs only — distinct from the canonical API host `api.pipefy.com/graphql`.

**pipe_id** — Identifier for a pipe (workflow container). Required in GraphQL queries targeting pipe-scoped operations.

**phase_id** — Identifier for a phase within a pipe. Required in GraphQL queries targeting phase-scoped operations.

**card_id** — Identifier for an individual card. Required in GraphQL queries targeting card-scoped operations.

**Behaviors** — Pipefy AI Agents capability: pre-authored instruction blocks that steer agent behaviour in workflows. Stage 10 paste bundle includes a Behaviors block per UAT-6.1.

**Pipefy AI Agents** — Pipefy's 2026 AI capability surface (launched Nov 2025). Includes KB, Skills, MCP integration, IDP, Web Search, BYO-LLM. Capability matrix tracked in `references/native-ai-inventory.md`.

> Verification gate: synthesis-plan grep dedup confirms zero of these terms
> are ALSO defined in `dydx-delivery/references/glossary.md`. Cross-cutting
> terms (frontmatter / sandbox / native_ai_path / status: lifecycle) live in
> glossary.md, NOT here.
