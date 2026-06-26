# Finding the Amplitude event + querying usage

This is the part that breaks most often. Two jobs: (1) suggest the right event from a PR,
(2) query its usage over the W+4 window.

## 0. Which event for which surface (read this first)

The single biggest mistake: querying the wrong event and concluding "no signal" when the
data is just under a different event. The OH product spans two surfaces that emit page-views
**differently**:

- **Employer/admin web dashboard (Prévenir)** — the `dashboard/occupationalHealth` screens.
  Page-views are emitted as **`Loaded a Page`** with `path` + `url` properties, fired at the
  web router/shell level. This is **invisible to a repo-grep** of OH component code (the grep
  only finds explicit `button_clicked` calls devs added). For any "view / see / consult a tab"
  feature on the admin dashboard, the right signal is `Loaded a Page` filtered by `path`
  (e.g. `path is "/app/dashboard/occupational-health/actions-de-prevention"`).
- **Member mobile app** — emits **`screen_viewed`**. This does **not** fire for the admin
  dashboard. Never use `screen_viewed` for an employer/admin feature; it returns 0 and looks
  like "dead feature" when usage is actually healthy.

So: a feature's explicit `button_clicked` events (from the PR) measure *actions taken*; the
`Loaded a Page` event measures *the tab being seen*. Pick the one that matches what the
announcement claims. If the announced feature is "admins can now see X", the view event is
usually the honest signal — and it may be the ONLY one (a read-only view often has no
button events at all). Reference: Prévenir "Page Views par Section" chart `5lwnfzbq` in
dashboard `8zjhveo3` lists every OH dashboard `path` and its weekly uniques.

**Verify-has-data at INSTRUMENT time, not just at read.** Before committing an event to a
Notion row, run a quick query over the post-launch window to confirm it returns > 0. If it's
0, you've likely got the wrong event/surface — recheck against `Loaded a Page` / the chart
above before concluding the feature is unmeasurable.

## 1. Suggest the event from a PR

The PR is agent-side context for finding the event — don't expect the announcement to name it.

Steps:
- Get the PR diff: `gh pr diff <pr-number>` (or `gh pr view <pr-number> --json files`).
- Grep the changed frontend files for tracking calls. In alan-apps fr-app the common shapes are
  `useTrackingClick`, `trackEvent(`, `track(`, `logEvent(`, and `sendTrackingEvent(`.

### The button_clicked trap (critical)

In fr-app, **most UI events are a single top-level event `button_clicked`, discriminated by
`properties.name`** — they are NOT distinct top-level Amplitude events. So a tracking call
usually looks like:
```
trackButtonClicked({ name: "prevenir_employees_export_clicked", ... })
```
The Amplitude event is `button_clicked`; the thing that identifies *this* feature is
`properties.name = "prevenir_employees_export_clicked"`. If you suggest just `button_clicked`,
the query will count every button in the app — useless. Always carry the `properties.name`
value through to the suggestion and the Notion row.

Some features do fire a dedicated top-level event (page views, custom domain events). For those
there's no `properties.name` to extract — the event name itself is enough.

Present candidates like:
- `button_clicked` · `properties.name = prevenir_employees_export_clicked`
- `prevenir_dashboard_viewed` (dedicated event, no name filter)

Let the user confirm/correct. Cross-check against events the `lm-oh-amplitude-sync` skill knows
for OH if you're unsure a name exists in Amplitude.

## 2. Query usage over the window

Window = `[launch, launch + 28d]`. The OH project is **Alan, `projectId 249047`** (prod fr-app,
holds both the `button_clicked`/OH events and `Loaded a Page`). Use it directly — no need to
call `get_context` for OH announcements.

Before querying, confirm the event/property names actually exist with `get_events` /
`get_event_properties` — never assume a name. (Amplitude MCP guidance: discover names, don't guess.)

For each event on the row, get three things:
- **Unique users (window total)**: distinct users, measure = uniques. ⚠️ Uniques are
  NON-ADDITIVE — do not sum the weekly buckets (a user active in 2 weeks is counted twice).
  For the deduped window total, either read `overallSeries` from the response, or run a
  separate query with a single bucket covering the whole window (interval ≥ window length).
- **Event volume (window total)**: total count, measure = totals. This IS additive — summing
  weekly buckets is fine.
- **Weekly trend**: the same metric bucketed into weekly intervals (`interval: 7`) across the
  window, for the rising/flat/falling read.

When the event is `button_clicked`, **filter by `properties.name = <value>`** or the numbers
are meaningless. Use `query_chart` for a single event (it renders an interactive chart too),
or the aggregate/segmentation tools if you only need the raw numbers.

Multiple events on one row → query and report each separately. Do not sum unique-user counts
across events: the same person using two features would be counted twice.

## 3. What to hand back

Plain numbers, no verdict (V1 is count + trend only):
- unique users (window total)
- event volume (window total)
- weekly buckets W1..W4 + a one-word trend (rising / flat / falling)
