# dYdX Delivery Runtime Stage Map

Use this file for normal stage execution. The larger `stage-numbering.md` remains the detailed maintenance reference.

| Stage | Skill | Output |
|---|---|---|
| Stage 1 | `kickoff-capture` | `01_kickoff_v<N>.md` |
| Stage 2 | `discovery-intake` | `02_discovery_v<N>.md` |
| Stage 3 | `generate-sow` | `03_sow_v<N>.md` |
| Stage 4a | `generate-fnspec-platform` | `04a_fnspec-platform_v<N>.md` |
| Stage 4b | `generate-fnspec-integration` | `04b_fnspec-integration_v<N>.md` |
| Stage 5 | `generate-technical-spec` | `05_techspec_v<N>.md` |
| Stage 6 | `generate-cost-estimate` | `06_cost_v<N>.md` |
| Stage 7a | `generate-build-prompt` | `07a_build-prompt_v<N>.md` |
| Stage 7b | `generate-implementation-prompt` | `07b_implementation-prompt_v<N>.md` |
| Stage 8b | `generate-test-plan` | `08b_test-plan_v<N>.md` |
| Stage 8d | `execute-tests` | `08d_test-results_v<N>.md` |

## Early-stage routing

- Stage 1 always writes a kickoff artefact first.
- `kickoff_branch: discovery-ready` means Stage 2 runs after the kickoff is approved.
- `kickoff_branch: draft-sow` means Stage 2 is skipped and Stage 3 reads the approved kickoff directly.
- No stage auto-runs the next stage. Human approval is the gate.
