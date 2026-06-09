---
name: lm-oh-amplitude-sync
description: >
  Synchronizes the Occupational Health (OH) analytics events from the alan-apps codebase
  with the Amplitude dashboard "Prévenir — Dashboard Usage" (ID 8zjhveo3).
  Detects missing events, creates Amplitude charts grouped by feature,
  and rewrites the 🆕 New Features section with the Linear tickets from the last 12 weeks.
  Use when: /lm-oh-amplitude-sync, "sync les events OH dans Amplitude" / "sync OH events into Amplitude",
  "mets à jour le dashboard OH" / "update the OH dashboard", "quels events OH ne sont pas dans le dashboard" / "which OH events are missing from the dashboard",
  "refresh la section New Features du dashboard Prévenir" / "refresh the New Features section of the Prévenir dashboard", "audit events OH" / "audit OH events",
  "quels nouveaux events OH tracker depuis 12 semaines" / "which new OH events to track over the last 12 weeks".
  Do not use for: other teams' dashboards, non-OH events, creating dashboards from scratch.
---

# lm-oh-amplitude-sync

Audits the codebase's OH analytics events, compares them to the Amplitude dashboard,
creates charts for the missing events, and updates the "🆕 New Features" section.

## Constants

| Parameter | Value |
|---|---|
| Amplitude dashboard | `8zjhveo3` (Prévenir — Dashboard Usage) |
| Amplitude project | `249047` (Alan) |
| "New Features" row | **Found dynamically**: the row whose rich_text item contains `## 🆕 New Features` (DO NOT hardcode the ID — see below) |
| OH events prefix | `occupational_health.` |
| Events source of truth | **The components** `frontend/apps/fr-app/js/app/dashboard/occupationalHealth/` (NOT `events.ts` — see below) |
| "new" cutoff | today − 84 days (12 weeks) |
| Chart IDs | Fetched dynamically from the dashboard on each run |

> **⚠️ Two pitfalls learned in prod (do not repeat):**
>
> 1. **`events.ts` is NOT the source of truth for OH.** Only a single OH event is typed there; the ~30 others are inline string literals passed as `properties.name` in the components. Grepping `events.ts` misses 30 events out of 31. The real source = the OH components folder. Moreover the event type is not always `button_clicked` (also `banner_viewed`, `form_submitted`) — you must read it in the code, never assume it.
> 2. **The rich_text IDs are regenerated on EVERY dashboard edit** (observed: `ha3idzlv → fu0axs0o → sipqgzl0 → dyden0j0` across 3 edits). A hardcoded ID can never work. Always relocate the New Features row by its **content** right before editing.

---

## Phase 1 — Extract all OH events from the codebase

OH events are inline string literals passed as `properties.name` in the OH components (not typed in `events.ts`). Scan the **components folder**:

```bash
cd frontend
grep -rn '"occupational_health\.' apps/fr-app/js/app/dashboard/occupationalHealth/ \
  | grep -o '"occupational_health\.[^"]*"' | sort -u | tr -d '"'
```

Safety net (in case an event lives elsewhere): widen to the scoped frontend, excluding svg/emojis:

```bash
grep -rn '"occupational_health\.' apps/fr-app/js/ packages/ shared/ 2>/dev/null \
  | grep -o '"occupational_health\.[^"]*"' | sort -u | tr -d '"'
```

→ Produces the `ALL_OH_EVENTS` list. (In prod the components folder yielded 31 events vs only 1 in `events.ts` — hence this change.)

---

## Phase 2 — Date each event via git

Goal: know when each event was added to `main` (the commit's merge date).

Since the events live as inline literals (not in `events.ts`), date each event with `git log -S` (pickaxe) scoped to the OH components folder. A full scan of all events across the entire frontend is slow (monorepo); only date the events to be classified (in practice: the **uncovered** ones, identified in Phase 4 — but you can date everything if needed). Scoping to the OH folder speeds this up a lot.

### 2a. Date an event (first commit that introduces the literal)

```bash
cd frontend
ohdir="apps/fr-app/js/app/dashboard/occupationalHealth/"
git log main -S "\"$EVENT\"" --format="%h|%cs|%s" -- "$ohdir" | tail -1
```

`tail -1` = the oldest commit = the introduction. Compare `%cs` (date) to the cutoff (`today − 84d`). If no commit is found (event outside the OH folder), retry without the `-- "$ohdir"`.

### 2b. Extract the Linear ID from the commit

Search the commit message and body for the `OHSET-\d+` pattern:

```bash
git log -1 --format="%s%n%b" COMMIT_HASH | grep -oE 'OHSET-[0-9]+' | sort -u
```

If absent, check the linked PR (the PR number is sometimes in the subject `(#12345)`):

```bash
gh pr view --json title,body,headRefName --jq '{title, body, branch: .headRefName}' -R alan-eu/alan-apps $(git log -1 --format="%s" COMMIT_HASH | grep -oE '#[0-9]+' | tr -d '#')
```

The branch name often contains `ohset-\d+` (e.g. `lmbonnefont/ohset-524-...`).

**Fallback**: if no OHSET ID is found → use the raw commit message as the label: `[commit] <commit subject>`.

→ Produces the map `EVENT_DATES : eventName → {commitHash, mergeDate, linearIds[], label}`.

---

## Phase 3 — Fetch the dashboard's coverage (dynamic)

### 3a. Fetch the dashboard to get the current list of charts

```
Call: Skill(mcp__claude_ai_Amplitude__get_dashboard) with dashboardIds: ["8zjhveo3"]
```

Extract from the response:
- `chartIds` — this list changes with every add/remove, never hardcode it.
- `lastModified` — required for any `edit_dashboard` (optimistic concurrency).
- **The New Features row**: iterate over `rows[]`, find the one whose `items[]` includes a `rich_text` whose `content` contains `## 🆕 New Features`. Keep its **rowIndex** (position in `rows[]`) and the item's `id`. ⚠️ This `id` changes on every edit — re-read it right before each use, never memorize it between two edits.

### 3b. Fetch the definitions of all current charts

```
Call: Skill(mcp__claude_ai_Amplitude__get_charts) with the chartIds extracted in 3a
```

For each chart, parse its definition to extract the referenced events:
- In the `metrics`, `segments`, `filters`, `events` fields, look for any string matching the `occupational_health.*` pattern

→ Produces `COVERED_EVENTS : Set<eventName>` = events already in at least one chart.

---

## Phase 4 — Identify the gaps

```
UNCOVERED = ALL_OH_EVENTS − COVERED_EVENTS
NEW_UNCOVERED = UNCOVERED ∩ {events whose mergeDate > cutoff}
OLD_UNCOVERED = UNCOVERED ∩ {events whose mergeDate ≤ cutoff}
```

If `mergeDate` is unknown for an event (commit not found), classify it in `NEW_UNCOVERED` to be safe.

---

## Phase 5 — Group by feature (semantic grouping)

For each event in `UNCOVERED` (new AND old), group by feature:

1. **Group by `linearIds`**: events sharing the same ticket go together
2. **Semantically regroup** related tickets: if two tickets cover the same functionality (e.g. OHSET-500 = "No-response banner display" + OHSET-521 = "No-response banner CTA clicks"), merge them into a single group. Semantic merge criteria:
   - Same source component (`NoResponseBanner.tsx` → same banner)
   - Same functional domain in the event name (e.g. shared `no_response_banner`)
   - Tickets appearing in the same PR or branch
3. **Fallback** (events without a ticket): individual `[commit] <message>` group

For each group, fetch the Linear ticket title:

```
Call: Skill(mcp__linear__get_issue) with the ID of the group's main ticket
```

→ Produces `FEATURE_GROUPS : [{linearIds, title, events[], isNew, latestMergeDate}]`

---

## Phase 5.5 — Human confirmation gate (READ-ONLY up to here)

Before any modification to the dashboard, present a complete summary of what will be done and ask for confirmation.

Display:

```
📊 Audit complete — here is what will be applied:

EVENTS FOUND: N in the codebase, M already covered by a chart

CHARTS TO CREATE (K total):
  🆕 [OHSET-524] Observation feature  (new, < 12 wk.)
       events: occupational_health.observation_viewed, occupational_health.observation_submitted
  🆕 [OHSET-500/521] No-response banner  (new, < 12 wk.)
       events: occupational_health.no_response_banner_viewed, occupational_health.no_response_banner_cta_clicked
  ⏳ [OHSET-450] Pending affiliations  (old, > 12 wk. — chart created, not in New Features)
       events: occupational_health.affiliation_decision_made

🆕 NEW FEATURES SECTION (will be rewritten):
  New content:
  **OHSET-524** — Observation feature · **OHSET-500/521** — No-response banner

Proceed? (yes / no / modify)
```

Use `AskUserQuestion` with the options:
- **"Yes, apply"** → continue to Phase 6
- **"No, cancel"** → stop, nothing is modified
- **"Modify before applying"** → ask what the user wants to change (groupings, chart names, events to exclude)

If the user chooses "Modify": adjust `FEATURE_GROUPS` per their instructions, re-present the summary, ask for confirmation again.

Never proceed to Phase 6 without explicit confirmation.

---

## Phase 6 — Create the missing charts

### 6a. Determine the real event_type of EACH event (mandatory)

Never assume `button_clicked`. Each event is emitted under a type that depends on the component: `button_clicked`, `banner_viewed`, `form_submitted`… Building the series with the wrong type → the chart silently displays 0 data.

For each event in the group, read the `trackEvent({ name: ... })` in the code and note the `name` field (= the Amplitude event type):

```bash
cd frontend
grep -rn -B6 '"occupational_health\.<EVENT_SUFFIX>"' apps/fr-app/js/app/dashboard/occupationalHealth/ \
  | grep -E 'name:|properties:' | head
```

The `name:` of the nearby `trackEvent` is the event type. Cases seen in prod: `pending_affiliation_alert` → `banner_viewed`; `professional_email_updated` → `form_submitted` (filtered on `form_name`, not `name`); the rest → `button_clicked` filtered on `name`. A chart can mix several event types (one series per event).

### 6b. Create the chart

For each `featureGroup`:

1. **Check** whether a chart with a similar name already exists (avoid duplicates).
2. **Create** an Event Segmentation chart in project `249047`:
   - Name: `[OHSET-XXX/YYY] <Linear title>` (or `[commit] <message>` if no ticket)
   - One series per event, each with its **real event_type** (6a) and the appropriate filter (`name` or `form_name`)
   - Period: rolling 90 days — `range: "Last 90 Days"`, `metric: "totals"`, `interval: 1`

```
Call: Skill(mcp__claude_ai_Amplitude__verify_chart_definition) to validate
Call: Skill(mcp__claude_ai_Amplitude__query_dataset)  → returns a chartEditId
Call: Skill(mcp__claude_ai_Amplitude__save_chart_edits) with the editIds → permanent chartIds
```

While at it, look at the data returned by `query_dataset`: a series that is all 0 over 90d is a signal of either zero usage (to flag in Phase 8) or a wrong event_type (re-check 6a).

### 6c. Add the charts to the dashboard

**Placement: BELOW the New Features header**, at the top of the per-feature charts (most recent first). The New Features row is a separator: above = general usage charts, below = one chart per recent feature (this is where the existing charts already live, like qwyzogcn/OHSET-460, c32bd0z6/OHSET-504…). DO NOT place them above the header (error seen in prod: the charts land in the usage zone, not in New Features). Width 6 if several charts per row, otherwise 12.

Two ways to do it:
- **Simple (recommended) — `set_rows` in a single edit**: rebuild the entire `rows[]` array with the new chart-rows inserted right after the New Features row. A single edit, no problem with `lastModified` or a shifted rowIndex.
- **Incremental — `insert_row`**: insert at `rowIndex(New Features) + 1`. But then, beware:

⚠️ **`edit_dashboard` returns a STALE `lastModified`** in its compact response (≈ the value sent, not the new one), and each insert shifts the rowIndex. So after EACH `insert_row`: **re-fetch `get_dashboard`** to get the real `lastModified` AND the up-to-date rowIndex of the New Features row (by content, cf. 3a) before the next edit. Never chain two `edit_dashboard` calls without re-fetching in between (otherwise an optimistic-concurrency conflict).

Note: create charts for **all** groups (`isNew = true` AND `isNew = false`). Only the `isNew = true` charts go into the New Features section (Phase 7).

---

## Phase 7 — Rewrite the New Features section

Build the section's markdown content:

```markdown
## 🆕 New Features

**OHSET-XXX/YYY** — Linear ticket title · **OHSET-ZZZ** — Ticket title · **[commit] message** — Event: occupational_health.xxx
```

Build rules:
- Include **only** the feature groups with `isNew = true` (mergeDate > cutoff)
- Sort by `latestMergeDate` descending (most recent first)
- Separator between entries: ` · ` (space-dot-space)
- If a group has several tickets: `OHSET-500/521` (slash)
- If commit fallback: `[commit] <message truncated to 60 chars>`

Update via `mcp__claude_ai_Amplitude__edit_dashboard`:

1. **Re-fetch `get_dashboard`** (the Phase 6c inserts changed `lastModified` AND the rowIndex of the New Features row). Relocate the row by content `## 🆕 New Features` (cf. 3a).
2. `edit_dashboard` with `type: "update_row"`, the up-to-date `rowIndex`, the up-to-date `lastModified`, and a `rich_text` item (width 12) containing the new markdown.

Do not reuse a rich_text `id` or a `lastModified` captured before the inserts — they are stale.

---

## Phase 8 — Display the summary

```
✓ N OH events found in the codebase
✓ M events already covered by the dashboard
⚠ K uncovered events:
    - J new (< 12 wk.) → charts created + added to New Features
    - L old (> 12 wk.) → charts created, not in New Features

Charts created:
  • [OHSET-524] Observation feature — events: [list]
  • [OHSET-500/521] No-response banner — events: [list]

🆕 New Features section updated:
  → dashboard: https://app.amplitude.com/analytics/alanlytics/dashboard/8zjhveo3
```

---

## Edge-case rules

| Case | Behavior |
|---|---|
| Event with no OHSET ID in the commit | Label `[commit] <commit subject>` — create the chart anyway |
| Uncovered events > 12 wk. | Create the chart in the dashboard, do NOT put them in New Features |
| Several tickets for the same feature | Merge them semantically → a single chart, label `OHSET-X/Y` |
| Chart with a similar name already exists | Skip creation, log "already covered by an existing chart" |
| Linear `get_issue` failure | Use the ticket ID as the title fallback: `OHSET-XXX` |

---

## Post-execution verification

1. `mcp__claude_ai_Amplitude__get_dashboard` with `8zjhveo3` → check that the new charts appear in `chartIds`
2. Relocate the New Features row by content (`## 🆕 New Features`) and check that its markdown was indeed rewritten
3. Open the dashboard: https://app.amplitude.com/analytics/alanlytics/dashboard/8zjhveo3
