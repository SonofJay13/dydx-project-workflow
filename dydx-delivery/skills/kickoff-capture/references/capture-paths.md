# Capture paths

Three paths feed `kickoff-capture`. All are paste-only per UAT-3.5 / UAT-6.1 — no MCP, no API calls in v2.2. Future Coda MCP integration is captured as a Deferred Idea (v2.6 / SURF-01..03 candidate). Each path produces a kickoff whose `kickoff_branch:` value is either `discovery-ready` or `draft-sow`, chosen at SKILL.md Step 4.

## Path 1 — Meeting notes paste (freeform)

**Protocol:** the reviewer pastes raw text into the `kickoff-capture` invocation — meeting notes, transcript snippet, brief, email thread, or any other freeform context describing the engagement.

**Triage:** `kickoff-capture` classifies the pasted content into the 8 STG1-04 sections per `references/auto-classify-rubric.md`. Where a section is under-evidenced, the section keeps the `[unknown — needs human classification]` marker.

**Format requirements:** none. Freeform text is the contract; the skill is responsible for imposing structure, not the input.

## Path 2 — Miro paste fallback

**Protocol** (per DESIGN-07 + AUDIT-08): the reviewer pastes a screenshot or image of a Miro board into the invocation alongside a prose narration describing the workflow the board depicts. No "render the whole board" assumption — `kickoff-capture` cannot crawl Miro.

**Triage:** the reviewer's prose narration is the canonical source. `kickoff-capture` classifies the narrated content into the 8 STG1-04 sections. The image itself is reference material for the reviewer; it does not feed the classifier directly.

**Explicit limit:** `kickoff-capture` does NOT OCR images. If the reviewer pastes an image without narration, the skill asks for the narration first; it does not attempt to read the diagram.

## Path 3 — Field Notes (Coda) paste

The Field Notes Coda table is a **read-only input queue**. Kickoff never auto-merges entries into the client brain — every row is quoted and the human is asked keep / drop / edit-and-keep (MOD-8 prevention per DESIGN-09).

**Triage filter (default):** `processed_at IS NULL`. This is the verbatim filter the reviewer applies in the Coda web app before selecting rows to paste. Rows that have already been processed (`processed_at` populated) are out of scope by default; the reviewer can override on a per-session basis if a specific re-look is needed.

**Protocol:**

1. The reviewer opens the Field Notes Coda table in the web app and applies the `processed_at IS NULL` filter manually.
2. The reviewer selects the rows in scope for this kickoff and pastes them into the `kickoff-capture` invocation.
3. For each pasted row, `kickoff-capture` quotes the row content verbatim and asks the human: **keep / drop / edit-and-keep**. This is the MOD-8 prevention loop — the skill cannot auto-merge.
4. On `keep` or `edit-and-keep`, `kickoff-capture` classifies the row content into the 8 STG1-04 sections per the auto-classify rubric. On `drop`, the skill records the rejection inline in the kickoff artefact so the audit trail captures both kept and dropped rows.
5. The `field_notes_processed_count:` frontmatter field on the resulting `01_kickoff_v<N>.md` artefact records how many rows the reviewer touched — kept, dropped, and edit-and-kept all count. The count is the audit signal that the reviewer worked through the batch, not a tally of accepted rows.

## Deferred — Coda MCP integration

Replacing the manual Coda web-app filter + paste step with a programmatic Coda MCP call is captured under v2.6 / SURF-01..03 evaluation. Out of scope for v2.2 through v2.6 per UAT-3.5 (paste-only) and UAT-6.1 (no native-AI ingestion APIs). The deferral is intentional; reviewer-in-the-loop is the v2.2 contract for the Field Notes path.
