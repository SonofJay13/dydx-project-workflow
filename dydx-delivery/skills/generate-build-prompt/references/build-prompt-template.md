---
client: <CLIENT_NAME>
platform: <pipefy | wrike | other>
integrations: []
version: 1
status: draft
based_on_technical_spec: 03_technical-spec_v<N>.md
based_on_test_plan: test-plan_v<N>.md
build_components: [platform_config, custom_code]
generated_at: <YYYY-MM-DD>
---

# Build Prompt — <CLIENT_NAME> · <ENGAGEMENT_NAME>

> Stage 6 of the dydx-delivery pipeline. **Paste this into a fresh Claude Code session to execute the build.**
> Cowork is the strategy seat; Claude Code is the build seat.

---

## 1. Context

You are Claude Code, executing a build for **<CLIENT_NAME>** on the **<PLATFORM>** platform. This build implements <ENGAGEMENT_NAME> — <ONE-PARAGRAPH DESCRIPTION>.

**Business outcome:** <One sentence — what the client gets out of this.>

**Build components in this prompt:** <platform_config | custom_code | both>

---

## 2. Read these first (in this order)

Before doing anything, read these files:

1. `<Client>/build-specs/<platform>/00_discovery_v<N>.md` — operational context
2. `<Client>/build-specs/<platform>/01_sow_v<N>.md` — scope and exclusions
3. `<Client>/build-specs/<platform>/02_functional-spec_v<N>.md` — what the system must do
4. `<Client>/build-specs/<platform>/03_technical-spec_v<N>.md` — **source of truth** for how it should be built
5. `<Client>/testing/<feature>/test-plan_v<N>.md` — what passing looks like (you'll self-check against this)

The technical spec is the source of truth. If anything in this prompt contradicts it, follow the spec and flag the contradiction back to the user.

---

## 3. Build scope

In scope for this build:

- <Item 1 — e.g. Pipefy pipe + phases for Brief Intake>
- <Item 2 — e.g. Approver Roster database>
- <Item 3 — e.g. Routing automation (BR-3)>

Out of scope (do not touch):

- <e.g. Existing pipes for unrelated workflows>
- <e.g. Production tenant — sandbox only>
- <e.g. Migration of historical data — separate engagement>

---

## 4. Build instructions

Follow the build sequence from section 12 of the technical spec. For each step:

| # | Build item | Construct / Module | Maps to | Acceptance check |
|---|---|---|---|---|
| 1 | Provision pipes, phases, fields | Pipe: Brief Intake; Phases: Draft, Submitted, In Review, Approved, Rejected, Done | D1 | Phases visible in Pipefy UI; field types match spec |
| 2 | Build start form + validation | Form fields per spec section 3 | BR-1 | Form rejects submissions missing mandatory fields |
| 3 | Set up Approver Roster database | Database: Approver Roster with seed records | BR-5 | Roster table created; sample approver + delegate visible |
| 4 | Build automation: routing by value | Automation per spec section 4.2 | BR-3 | Card with value > 50000 routes to Director Queue |
| 5 | Build automation: OoO delegate routing | Automation per spec section 4.4 | BR-5 | OoO approver bypassed in test card |
| 6 | Build Ziflow integration | Webhook + payload per spec section 5.1 | EC-3 | Test card transitioning to Approved fires Ziflow webhook |
| 7 | Build SLA escalation automation | Scheduled automation per spec section 4.3 | BR-4 | Card aged >48h escalates to delegate |

> Use the platform's exact vocabulary throughout (Pipefy "phase" not "stage"; Wrike "blueprint" not "template").

---

## 5. Constraints (hard rules)

**Do not:**

- Deviate from the technical spec without surfacing the change to the user first
- Touch production tenants — sandbox / dev environment only
- Delete existing client data or files
- Add features outside the SOW scope (section 2 of the SOW)
- Include credentials in code, configs, or commit messages — env vars only
- Use platform features that require a higher tier than the client has (see technical spec section 9)
- Push directly to `main` — work on a build branch and hand back a PR / change summary

**Always:**

- Read the technical spec before starting each build item
- After each major build item, run the relevant test plan rows (smoke subset)
- Log generated identifiers (automation IDs, webhook IDs, etc.) in the build report
- Stop and ask the user if a spec ambiguity blocks progress

---

## 6. Tools and access

### Working directory

`<absolute path — e.g. ~/Work/Clients/<Client>/>` for spec/artefact reads
`<absolute path — e.g. ~/Work/Clients/<Client>/code-repo/>` for custom code work (if applicable)

### For platform configuration

- Required skill: `platform-<platform>` (Pipefy or Wrike)
- API credentials env vars:
  - `<PLATFORM>_API_TOKEN` — sandbox token
  - `<PLATFORM>_TENANT_ID` — sandbox tenant
- API endpoint: <from technical spec>
- Sandbox identifiers:
  - Pipe ID / Space ID: `<from technical spec section 9 or test plan sandbox block>`

### For custom code

- Repo: `<repo URL>`
- Branch to work on: `<branch name — e.g. feature/<feature-slug>>`
- Required env vars: `<list>` (see repo `.env.example`)
- Run tests with: `<test command>`
- Build/deploy with: `<build command>`

### Where to write outputs

- Build report: `<Client>/build-specs/<platform>/04_build-prompt_v<N>_report.md`
- Generated identifiers: appended to build report
- Code (if applicable): committed to the build branch only
- Deviation log (if any): `<Client>/build-specs/<platform>/04_build-prompt_v<N>_deviations.md`

---

## 7. Self-test loop

After each major build item:

1. Run the relevant rows from the test plan against the sandbox
2. If any fail, stop, log the failure in the build report, and:
   - If it's a build issue → fix and re-run
   - If it's a spec gap → stop, log, surface to user

Smoke subset of the test plan to run after each item: <list of TC-IDs from test plan, e.g. TC-001, TC-003, TC-005>.

Full test plan runs separately via the `execute-tests` skill in Cowork — not your job.

---

## 8. Done criteria + handoff

Build is complete when ALL of the following are true:

- [ ] Every row in section 4 (Build instructions) has its acceptance check passing
- [ ] Smoke test subset runs green in the sandbox tenant
- [ ] Generated identifiers (automation IDs, webhook IDs) recorded in build report
- [ ] No deviations from technical spec, OR every deviation logged with reasoning
- [ ] Build report written at `<Client>/build-specs/<platform>/04_build-prompt_v<N>_report.md` containing:
  - Build summary (what shipped)
  - Identifiers list
  - Deviations (if any)
  - Outstanding items / blockers
- [ ] PR opened (for custom code) or change summary attached (for platform config)
- [ ] Posted back to the Cowork user with a one-line summary so they can run `execute-tests`

---

## 9. Stop and ask if

Pause the build and surface the question to the Cowork user if you encounter:

- A spec ambiguity with more than one reasonable interpretation
- A platform construct the technical spec calls for that doesn't exist on the client's tier
- A required integration credential that isn't available
- A test failing in a way that suggests a spec gap, not an implementation gap
- Anything that would cause irreversible changes (data writes outside sandbox, anything touching billing/external publishing)
- A deletion that the spec calls for (deletion is outside this skill's safe envelope — refer back to user)
