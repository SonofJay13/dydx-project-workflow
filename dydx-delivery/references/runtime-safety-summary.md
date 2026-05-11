# dYdX Delivery Runtime Safety Summary

Use this file for normal early-stage execution. The larger `safety-rules.md` and `connector-matrix.md` remain the detailed maintenance references.

## Stage 1 and Stage 2

- Paste-only inputs are valid for kickoff capture.
- Do not call Coda, Miro, Pipefy, Wrike, Ziflow, or Google APIs during kickoff or discovery unless a later skill explicitly requires it.
- Miro content is accepted only as a pasted image plus human narration; do not OCR or infer beyond the narration.
- Field Notes content is accepted as pasted rows. Keep, drop, and edit-and-keep decisions must remain traceable in the artefact.
- Never write to production tenants from these stages.

## Connector fallback

- Missing Coda or Miro access does not block Stage 1. Ask the user to paste the relevant content.
- Platform APIs are not needed for Stage 1 or Stage 2.
- Later test and publishing stages may have stricter connector requirements.
