---
fixture: true
fixture_for: phase-7-e2e-smoke
client: VodafoneZiggo
project: triage-friction-cleanup
capture_path: field-notes
---

# Field Notes — unprocessed rows (Coda paste)

Filter applied: `processed_at IS NULL`

| row_id | observed_at | observer        | observation                                                                | processed_at |
|--------|-------------|-----------------|----------------------------------------------------------------------------|--------------|
| FN-101 | 2026-05-02  | studio lead     | Ticket 12345 stuck in Triage 3 days — no SLA timer on Triage Phase.        | NULL         |
| FN-102 | 2026-05-04  | director        | Two CRs landed with same `customer_tier` but routed to different queues.   | NULL         |
| FN-103 | 2026-05-05  | platform engr   | NOTE TO SELF — try the new Pipefy beta UI; nothing to do with this CR.     | NULL         |

Reviewer note: FN-103 is a personal todo (off-topic for the CR) and is the
expected "drop" candidate during the kickoff keep/drop/edit-and-keep prompt
(MOD-8 prevention validation). FN-101 + FN-102 are operational signal —
keep.
