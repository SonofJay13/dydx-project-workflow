# Ziflow — Native-AI inventory

> `tier_claims_last_verified:` matches SKILL.md frontmatter value (2026-05-09 baseline per D-68; updated to execution date if fresh re-verification happens during this plan).
>
> **High-churn note:** Ziflow ReviewAI is in active expansion — Change Verification + Brand Standards are listed as "Coming Soon", while ReviewAI Checklists Public Preview is the only AI surface in Public Preview today. Expect this date to drift forward earlier than the Pipefy / Wrike matrices.

## Re-verification trigger

Re-verify this capability matrix against current Ziflow ReviewAI documentation
(`https://api-docs.ziflow.com/` + `https://www.ziflow.com/reviewai`) BEFORE any
v2.x phase that consumes the matrix:
- Stage 4a delivery routing (consumes confidence ratings)
- Stage 7b implementation prompt (consumes capability surface list)
- Stage 10 native-AI paste bundle (consumes paste targets — ReviewAI Checklist criteria)

Update `tier_claims_last_verified:` on `dydx-delivery/skills/platform-ziflow/SKILL.md`
frontmatter after each re-verification, citing the source doc URL + date in commit
message.

## Capability matrix (2026-grounded)

| Capability | Available? | Surface | Confidence |
|---|---|---|---|
| ReviewAI Checklists | yes (Public Preview, Enterprise plan) | Ziflow ReviewAI → Checklists | HIGH — confirmed Public Preview per DESIGN-16 |
| Change Verification | **Coming Soon** | Ziflow ReviewAI → Change Verification | MEDIUM — vendor-announced future; PLAT-03 execution MAY check current GA status |
| Brand Standards | **Coming Soon** | Ziflow ReviewAI → Brand Standards | MEDIUM — vendor-announced future; PLAT-03 execution MAY check current GA status |
| Checklist Templates API | GA (April 2026 — Ziflow release notes 26.08) | Ziflow API → checklist-templates | HIGH — confirmed GA per 2026-05-11 vendor docs |
| ReviewAI knowledge-ingestion API | **CLOSED (UAT-6.1)** | n/a | UAT-6.1 — OPEN-Q03 closed; no API ingestion path through v2.6 |

## Paste-only delivery (UAT-6.1)

`native_ai_path:` accepts the closed enum `paste | none` ONLY — the previously-considered API ingestion path (the forbidden third enum value) is FORBIDDEN. The Stage 10 paste bundle is the only supported ingestion path through v2.6; humans upload ReviewAI Checklist criteria manually via the Ziflow UI. See `references/knowledge-ingestion.md` for the paste-bundle shape.

## Active maintenance — High-churn awareness

Ziflow ReviewAI is currently in active expansion. Phase 6 PLAT-03 noted these post-DESIGN-16 GA features as of 2026-05-11:
- **Checklist Templates API** — GA April 2026 (Ziflow release notes 26.08).
- **Change Verification** + **Brand Standards** — listed "Coming Soon" per vendor docs; PLAT-03 execution MAY check current GA status.

**Commit-message audit-trail requirement (REVIEWS C6 / D-68):** If you bump `tier_claims_last_verified:` during execution, the commit message MUST cite the specific vendor URL used for the re-verification (e.g., `https://api-docs.ziflow.com/` or `https://www.ziflow.com/reviewai` or a specific Ziflow release-notes anchor). Format: a one-line `Verified-Against: <URL>` trailer in the commit body.
