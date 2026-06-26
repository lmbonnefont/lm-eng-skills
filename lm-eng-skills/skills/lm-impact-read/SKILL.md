---
name: lm-impact-read
description: >-
  Measure the real impact of an Occupational Health product announcement at W+4
  using Amplitude usage (unique users + event volume + week-over-week trend). Two
  modes: INSTRUMENT a new announcement (paste a #product_announcements Slack URL →
  the skill captures the feature, suggests Amplitude events from the linked PR, and
  writes a row to the "Feature Impact Tracker" Notion DB with a W+4 due date), and
  READ the announcements that are now due (query Amplitude, print the usage read,
  mark them done). Use this whenever Louis-Marie says "/lm-impact-read", "instrument
  this announcement", "track the impact of [feature]", "do the W+4 read", "how many
  people used [feature]", "what's due for an impact read", or pastes a Slack product
  announcement URL with any intent to follow up on its impact. Also trigger when he
  wants to know whether a shipped OH feature actually got used. Do NOT use for
  generic Amplitude charting (that's lm-oh-amplitude-sync) or for grading success
  with a verdict — V1 reports numbers + trend only, no success/not-yet judgment.
---

# lm-impact-read

Close the loop on OH product announcements: did the thing we shipped actually get
used? This skill instruments an announcement when it ships, then comes back at W+4
and reports the usage from Amplitude. It deliberately reports **numbers, not a
verdict** — counting usage is the smallest honest signal, and a human reads the
meaning. (This is the "start even more basic" altitude chosen for V1.)

## The two modes

You are in **INSTRUMENT** mode if the user gives you a Slack announcement URL (or
asks to instrument / track / follow up on a specific announcement).

You are in **READ** mode if the user invokes the skill with no announcement (e.g.
"/lm-impact-read", "what's due", "do the reads") — you process the DB rows that are
now due.

If genuinely ambiguous, ask which one. Don't guess and create a spurious row.

## Shared facts

- **Notion DB**: "Feature Impact Tracker" — data source `1a51daf9-7bd8-4933-a8c6-25fa712a31ed`.
  Exact field names and write/query payloads are in `references/notion-db.md` — read it
  before any Notion write or query.
- **W+4** = launch date + 28 days (the default; honor an explicit override if the user states one).
- **Amplitude project**: Alan, `projectId 249047` (prod fr-app). Use directly.
- Every run appends to the **JOURNAL** (`journal.jsonl` in this skill dir). This is how
  the skill improves — see "Self-logging" at the bottom. Do this even when the run succeeds.

---

## INSTRUMENT mode

Goal: turn a Slack announcement into one DB row, with the Amplitude event(s) to watch
already captured, so READ mode can run unattended later.

### 1. Read the announcement

Parse the Slack URL into `channel_id` + `message_ts` (the `pXXXXXXXXXXXXXXXX` segment is
the ts with a dot inserted before the last 6 digits). Read the thread (parent + replies)
with `slack_read_thread`. Extract:
- **Feature** — a short human name for what shipped.
- **Author** — the poster (resolve to a Notion person if you can; otherwise leave Author empty and note the name in Last read).
- **Crew** — `setup` or `medical-software`, inferred from the author/content. If unclear, ask.
- **Launch date** — the announcement date, unless the post states a different go-live.
- **Success definition** — if the author stated a metric/target/horizon, capture it verbatim into the row's notes. If they didn't, that's fine for V1; we still track usage.

### 2. Resolve the linked PR(s)

Look for GitHub PR links in the post and its thread (and any linked Linear issue that in
turn links PRs). The PR is **agent-side context** — it is how we find the right Amplitude
event, not something the announcement should be written around. If you find no PR:
- Ask the user for the PR URL, OR
- Skip auto-suggest and let the user name the event(s) directly.
Don't block the whole instrument step on a missing PR.

### 3. Suggest Amplitude event(s) from the PR

Read `references/tracking-events.md` first — extracting the right event name is the part
that goes wrong most often, because in fr-app most UI events are a single `button_clicked`
event discriminated by `properties.name`, not distinct top-level events. A suggestion of
"button_clicked" alone is useless; you need the `properties.name` value.

Crucially, repo-grep only finds explicit `button_clicked` calls in component code. For a
"view / see / consult a tab" feature on the admin dashboard, the right signal is usually the
shell-level **`Loaded a Page`** event (filtered by `path`), which grep never surfaces — see
`references/tracking-events.md` section 0 (which event for which surface). A read-only view
often has no button events at all, so `Loaded a Page` is the only signal.

Present 1-3 candidate events (with their `properties.name` or `path` where relevant) and let
the user confirm or correct. The user's judgment wins — they know the events. You can also
cross-check against the OH events known to the `lm-oh-amplitude-sync` skill.

**Then verify the chosen event has data** (query the post-launch window, project `249047`,
expect > 0) BEFORE writing the row. A 0 here almost always means wrong event/surface, not a
dead feature — recheck against `Loaded a Page` / the Prévenir chart `5lwnfzbq`. Committing a
dead event makes the W+4 read silently show 0 and falsely read as "not a success".

### 4. Write the row

Per `references/notion-db.md`, create one page under the data source with: Feature,
Announcement URL, Author, Crew, Amplitude event(s) (confirmed), Launch date, W+4 due
(= launch + 28d), Status = `instrumented`. Confirm back to the user with the Notion link
and the W+4 due date.

---

## READ mode

Goal: for every announcement now due, report usage and mark it read.

### 1. Find due rows

Query the data source for rows where `Status = "instrumented"` and `W+4 due <= today`.
See `references/notion-db.md` for the query. If none are due, say so plainly and stop
(still write a journal entry).

### 2. Amplitude project

Use Alan, `projectId 249047` (prod fr-app, holds OH events + `Loaded a Page`). No lookup needed.

### 3. Query usage per row

For each due row, for each Amplitude event (and `properties.name` filter where the event is
`button_clicked`), over the window `[launch, launch + 28d]`:
- **Unique users** — distinct users who triggered it.
- **Event volume** — total count.
- **Week-over-week trend** — 4 weekly buckets across the window.

See `references/tracking-events.md` for the querying approach. Multiple events on one row:
report each event separately (don't silently merge — merging unique-user counts double-counts).

### 4. Print the read

Print in the conversation (no Slack post in V1). One block per feature:

```
🔮 W+4 read — <Feature>  (launched <date>, crew <crew>)
   events: <event> (properties.name=<name>)
   unique users: <N>        volume: <M>
   weekly: W1 <a> · W2 <b> · W3 <c> · W4 <d>  (<rising/flat/falling>)
   announcement: <slack url>
```

No verdict line. Numbers + trend only.

### 5. Mark done

Update each row: Status = `read done`, Last read = the numbers, Last read date = today.

---

## Self-logging (the improvement loop)

After every run, in both modes, append one JSON line per notable issue to
`journal.jsonl` in this skill dir. This is what feeds the weekly `/lm-skill-retro`.
Tag each entry so the retro knows what to do with it:

- `gap` — the skill itself fell short (e.g. suggested `button_clicked` without a
  `properties.name`; mis-parsed the Slack URL; Amplitude query returned nothing because
  the event name was wrong). These are bugs to patch.
- `ambiguity` — a limit of the data, not a bug (e.g. no PR linked so the event was a
  guess; crew unclear; no success definition in the post). These are signals about the
  design's limits.

Entry shape (one line, compact JSON):
```json
{"timestamp":"<ISO8601>","verb":"instrument|read","type":"gap|ambiguity","what_i_tried":"...","what_failed":"...","assumption_made":"..."}
```

Write nothing to the journal that you wouldn't want a teammate to read. If a run is fully
clean, still append one entry with `type:"gap"`, empty `what_failed`, noting it ran clean —
absence of entries should never be ambiguous between "clean" and "skill crashed".

Never auto-edit this skill based on the journal. Correction is a deliberate human step
(`/lm-skill-retro`), same discipline as drafting Slack replies instead of auto-posting.
