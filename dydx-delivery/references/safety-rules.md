# dYdX Delivery — Safety rules (canonical)

> Canonical SoT for hard rules per DESIGN-03 (`.planning/DESIGN.md:93-104`). These rules are hardcoded into the runner. They override anything in the test plan. They are not configurable per run.
>
> **Override resolution:** skill loads canonical SoT → loads per-client `<Client> Brain/safety-overrides.yaml` overlay if present → applies overrides only to fields tagged `overridable: true`. Rule 1 (sandbox enforcement) and Rule 3 (no destructive integrations outside scope) are non-overridable.

## 1. Sandbox enforcement

The runner must verify before every API call that the target IDs (pipe ID, space ID, project ID) match the `sandbox:` block in the test plan frontmatter.

**Implementation:**

- On startup, read the test plan frontmatter `sandbox:` block
- Build an allowlist of (resource_type, resource_id) pairs
- Before every API call, check that the call targets a resource in the allowlist
- If the call would target a non-allowlisted resource, refuse and log `REFUSED: out_of_sandbox`

**Explicit denylist:** never call APIs against production tenant identifiers, even if the test plan sets `sandbox:` to those IDs (the user should not do this, but the runner should still refuse).

## 2. No deletions

Refuse any API operation whose method maps to a delete:

| Platform | Refused operations |
|---|---|
| Pipefy GraphQL | `deleteCard`, `deletePipe`, `deletePhase`, `deleteOrganization`, `deleteTable`, `deleteTableRecord`, `deleteWebhook` |
| Wrike REST | `DELETE /tasks/{id}`, `DELETE /folders/{id}`, `DELETE /workflows/{id}`, any `DELETE` HTTP verb |
| Generic | Any operation containing `delete_`, `remove_`, or `destroy_` |

Logged as `REFUSED: delete_blocked` with the operation name.

## 3. No destructive integrations outside scope

These actions are refused unless the test plan explicitly lists them in scope AND the integration is pointed at a sandbox / mock endpoint:

- Sending real emails to non-test recipients
- Posting to real Slack channels (only `#test-*` channels permitted)
- Triggering real Ziflow proofs (sandbox project only)
- Triggering real billing or invoice generation
- Calling third-party publishing APIs (social, CMS push)
- Coda writes ARE permitted against the per-client sandbox doc/table identified in the test plan frontmatter `sandbox.coda_doc:` block. Coda writes targeting any other doc are refused (treated as "out_of_sandbox" per Rule 1).

**Detection:** runner inspects the action description and target endpoint. If a known production integration endpoint is targeted, refuse.

## 4. Read-write only

Permitted operations:

- `create_*` / `POST` — create new resources
- `update_*` / `PATCH` / `PUT` — update existing resources
- `read_*` / `GET` — read resources
- `transition_*` / phase moves — permitted but check rule 3 for any auto-firing webhooks

Refused:

- `delete_*` (rule 2)
- Anything that fires a destructive integration (rule 3)

## 5. Audit trail

Every API call must be logged. Every refusal must be logged. Format:

```
[timestamp] TC-XXX | <PASS | FAIL | REFUSED:<reason> | ERROR:<class>>
  request:  <method> <url>
            <payload>
  response: <status>
            <body>
  notes:    <retry count, etc.>
```

The audit trail must include refused operations — silent refusals are not allowed.

## 6. Rate limiting

| Platform | Default limit | Runner behaviour |
|---|---|---|
| Pipefy GraphQL | 100 req/min per token | Buffer at 80; back off on 429 |
| Wrike REST | 200 req/min per token | Buffer at 160; back off on 429 |
| Generic | (read from platform skill) | Buffer at 80% |

On `429 Too Many Requests`: wait per `Retry-After` header (or 5s if absent), retry once, then continue to next test.

## 7. Stop conditions

The runner stops the entire run (writes partial results, exits cleanly) if:

- 3 consecutive tests fail with infrastructure errors (5xx, timeout, network)
- Auth failure (401/403) on any call
- Sandbox unreachable on pre-flight check
- User cancellation
- Any operation attempts to escape sandbox enforcement (rule 1) — this is treated as a critical bug, run aborted

## 8. Concurrency

Tests run sequentially by default. Parallel execution is not supported in v1 (avoids state contention in shared sandboxes).

## 9. Cleanup

The runner does not delete test data. Sandbox housekeeping is a separate concern — the team manages sandbox state on a cadence. If tests rely on a clean state, the test plan must include setup steps that reset the relevant fixtures (without using delete operations).

## 10. Reporting

Every refusal goes into the results file with enough context for a human to understand why and decide what to do. The runner does not silently fix or work around refusals — it logs them and moves on.
