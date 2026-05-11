---
client: <CLIENT_NAME>
project: <PROJECT_NAME>
platform: <pipefy | wrike | ziflow | other>
integrations: []
version: 1
status: draft
frontmatter_version: 2
based_on_kickoff: 01_kickoff_v<N>.md
captured_by: <USER>
captured_at: <YYYY-MM-DD>
---

# Discovery — <CLIENT_NAME> · <FEATURE_OR_ENGAGEMENT>

> Stage 2 of the dydx-delivery pipeline. Captures the operational reality so downstream stages (SOW, functional spec, technical spec, test plan) have a real foundation. Mark every unknown explicitly — do not guess.

---

## 1. Business outcome

**Why this matters:**
<What measurable outcome does the client want? What changes if it doesn't get done?>

**Success in 3 months looks like:**
<Concrete, observable indicators>

**Success in 12 months looks like:**
<Longer-horizon outcome — useful for scoping decisions>

---

## 2. Users and ownership

| Role | What they do | Technical level | Owner / decision-maker |
|---|---|---|---|
| <e.g. Brief Requester> | <Submits creative briefs> | <Low / Med / High> | <Name or TBC> |
| <e.g. Studio Lead> | <Reviews and assigns> | <Low / Med / High> | <Name or TBC> |

**Workflow owner (single throat to choke):** <Name or TBC>

**Adoption risk:** <Who might resist this and why?>

---

## 3. Systems

**Primary platform:** <pipefy | wrike | ziflow | other>

**Supporting systems:**

| System | Purpose | System of record? | Notes |
|---|---|---|---|
| <e.g. Ziflow> | <Proofing> | <Yes / No> | <e.g. Stores final approved files> |

**What's already automated vs manual:**
- Automated: <list>
- Manual: <list>

---

## 4. Triggers

| Trigger | Type | Frequency | Notes |
|---|---|---|---|
| <e.g. Brief submitted via form> | <User action / Time / Event / Integration> | <Daily / Weekly / Ad-hoc> | <Volume estimate> |

**Multiple entry points?** <Yes / No — describe>

---

## 5. Data

| Data field / object | Origin system | Destination system | Sensitivity |
|---|---|---|---|
| <Brief title> | <Pipefy form> | <Pipefy card + Ziflow> | <None / PII / Financial / Health> |

**Sensitive data handling notes:**
<Any compliance or regulatory considerations>

---

## 6. Rules

**Decision logic:**
- <e.g. Briefs over R50k go to Director approval queue, all others to Studio Lead>

**Approvals:**

| Decision | Approver | Trigger | SLA |
|---|---|---|---|
| <Final creative sign-off> | <Brand Manager> | <Proof at v3 or later> | <48h> |

**Deadlines / SLAs:**
- <First response within 4h>
- <Standard turnaround 5 business days>

---

## 7. Integrations

| System | Direction | Auth | Frequency | Error handling today |
|---|---|---|---|---|
| <e.g. Ziflow> | <Outbound> | <API key> | <On phase transition> | <Manual retry> |

---

## 8. Exceptions and failure points

**What goes wrong today:**
- <e.g. Briefs missing required fields slip through and block the studio>
- <e.g. Approvers go on leave with no delegate, work stalls>

**What's manually patched up that shouldn't be:**
- <e.g. Ops team copies data between Pipefy and a separate spreadsheet>

**What happens if a system goes down mid-workflow:**
- <Current recovery process or "no plan exists">

---

## 9. Constraints

**Technical:**
- <e.g. No write access to legacy CRM>

**Commercial:**
- <e.g. Can't add seats on Pipefy beyond 25>

**Time:**
- <e.g. Hard deadline of Q3 launch>

---

## 10. Open questions

> Items the client must answer before we can scope cleanly.

- [ ] <Question 1>
- [ ] <Question 2>

---

## 11. Assumptions made in this discovery

> Sensible assumptions filled in to avoid getting stuck. Each must be validated.

- <Assumption 1 — to be confirmed by <name>>
- <Assumption 2 — to be confirmed by <name>>

---

## Handoff

When this artefact is reviewed and approved:

1. Bump status to `status: approved` in frontmatter (or save edited version as `_v{N+1}.md`)
2. Run `generate-sow` to produce the scope of work

**Next stage reads:** the highest-version `02_discovery_v*.md` in this folder.
