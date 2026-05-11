# Auto-classification rubric — Stage 4a `delivery:` routing key

Decide when to emit `delivery: native-ai` vs `delivery: api` against every business-rule / field-level-requirement / acceptance-criterion row in `04a_fnspec-platform_v<N>.md`. The rubric is consumed by `generate-fnspec-platform/SKILL.md` Step 4. Classifier input is the loaded platform skill's `references/native-ai-inventory.md` per DESIGN-14/15/16 — confidence levels HIGH / MEDIUM / LOW / `[OPEN]` drive the suggestion. Canonical enum order is `native-ai | api` per STG4-04 (the reversed form is forbidden). The `[reviewer-override:]` token in a row is the re-run preservation trigger — overridden rows are NEVER re-classified.

## Explicit triggers

Apply the rubric per row. The 5 triggers below are evaluated in order; the first match wins. Per D-81 + STG4-05 (verbatim authority):

1. **Row matches a HIGH-confidence entry in the loaded platform's `native-ai-inventory.md`** → suggest `delivery: native-ai [HIGH, src: platform-<platform>]`. HIGH means the platform skill's verified MCP probes confirm the capability is reachable via native-AI surface (≥3 distinct verified probes per Phase 6 canon).
2. **Row matches a MEDIUM-confidence entry in the loaded platform's `native-ai-inventory.md`** → suggest `delivery: native-ai [MEDIUM, src: platform-<platform>]`. MEDIUM means ≥2 distinct verified MCP probes confirm reachability. (Threshold is `≥2 distinct verified MCP probes`; matches Phase 6 native-ai-inventory HIGH/MEDIUM/LOW canon. Tighten to `≥3` only if the loaded platform's inventory states a stricter cutoff.)
3. **Row matches a LOW-confidence entry in the loaded platform's `native-ai-inventory.md`** → default to `delivery: api [LOW → default api, src: platform-<platform>]`. Default-to-api avoids optimistic native-AI claims when only copy-paste or weak signal exists (per D-81 + STG4-05 rationale).
4. **Row matches an `[OPEN]`-flagged entry in the loaded platform's `native-ai-inventory.md`** → default to `delivery: api [LOW → default api, src: platform-<platform>]`. Treat `[OPEN]` as LOW per D-81 — open questions are NOT a signal for native-AI delivery.
5. **Row does NOT appear in the loaded platform's `native-ai-inventory.md`** → default to `delivery: api` with no `src:` reference. Inventory absence == evidence absence; do not assume native-AI applies. Reviewer can promote to native-ai via the override mechanic below if the row genuinely belongs to a native-AI surface that the inventory has not yet documented.

## Input-signal → outcome escalation

| Inventory level | Outcome |
|---|---|
| HIGH | `delivery: native-ai [HIGH, src: platform-<platform>]` |
| MEDIUM | `delivery: native-ai [MEDIUM, src: platform-<platform>]` |
| LOW | `delivery: api [LOW → default api, src: platform-<platform>]` |
| `[OPEN]` | `delivery: api [LOW → default api, src: platform-<platform>]` |
| absent | `delivery: api` (no `src:` reference) |

Unicode arrow `→` verbatim in the markup (never `->`). `<platform>` is resolved at write time to one of `pipefy | wrike | ziflow | other` per the D-78 4-enum.

## Reviewer-override mechanics (D-82)

Reviewer edits a classified row to read one of:

```
delivery: native-ai [reviewer-override: native-ai]
delivery: api [reviewer-override: api]
```

The literal `[reviewer-override:` token is the re-run preservation trigger. On every re-run of `generate-fnspec-platform`:

- The skill MUST scan every existing row in sections 4 (Business rules) / 5 (Field-level requirements) / 8 (Acceptance criteria) for the `[reviewer-override:` substring.
- Rows carrying the token are PRESERVED verbatim — the classifier rubric is NOT re-applied.
- The reviewer's choice is final. The skill does not warn, does not surface alternatives, does not silently re-classify.

Reference: `generate-fnspec-platform/SKILL.md` Step 3 (re-run policy — detect existing artefact, scan for override tokens) and Step 4 (classifier draft pass — skip overridden rows).

## Re-run preservation rule

> Rows carrying the `[reviewer-override:]` token are NEVER re-classified on re-run. The reviewer's choice is final.

This rule supersedes every trigger above for rows where it applies. The rubric does not "second-guess" the human after override; that is the explicit contract per D-81 + D-82.

## Operational principle (backstop)

> When the inventory entry confidence is borderline OR the reviewer has not pre-flagged the row, default to `delivery: api`.

Native-AI claims should be defensible against the loaded platform's verified MCP probes (DESIGN-14/15/16). Optimistic native-AI claims downstream of LOW confidence inventory rows produce false routing decisions in Stage 5 / 6 / 7b / 10 (per ROUTE-05). The cost of mis-classifying api → native-ai is downstream stages assuming a capability that does not actually work; the cost of mis-classifying native-ai → api is at worst an extra API call that succeeds anyway. Asymmetry favours defaulting to api when in doubt.

## How this rubric is consumed

`generate-fnspec-platform/SKILL.md` Step 4 references this file by relative path (`references/auto-classify-rubric.md`) — that reference is asserted by the phase8 structure-check at assertion P6. The literal `delivery: native-ai | api` canonical enum order is documented in the SKILL.md body (asserted at P5), not here; this rubric only documents the per-trigger outcome strings.

The rubric is invoked once per row in sections 4 / 5 / 8 of the platform fnspec. Sections 6 (State model) and 7 (Edge cases) are not row-tagged with `delivery:` markup — state transitions are workflow-level and edge cases are scenario-level, not requirement-level. Re-run preservation applies whenever an existing `04a_fnspec-platform_v*.md` is detected at SKILL.md Step 3.
