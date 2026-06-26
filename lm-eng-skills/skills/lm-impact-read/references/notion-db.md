# Feature Impact Tracker — Notion DB reference

Data source: `collection://1a51daf9-7bd8-4933-a8c6-25fa712a31ed`
(use the bare id `1a51daf9-7bd8-4933-a8c6-25fa712a31ed` as `data_source_id`).
Page (human view): https://app.notion.com/p/f67af1da339a4adda8c991221e946ff9

## Fields (SQLite-expanded names — use these exact keys)

| Logical field | Write key | Notes |
|---|---|---|
| Feature | `Feature` | title (string) |
| Announcement URL | `Announcement URL` | url (string) |
| Author | `Author` | JSON array of Notion user IDs, e.g. `["2fcd872b-594c-8102-972d-0002592597fc"]`. Empty `[]` if unresolved. |
| Crew | `Crew` | one of `setup`, `medical-software` |
| Amplitude event(s) | `Amplitude event(s)` | free text; include `properties.name` values |
| Launch date | `date:Launch date:start` | ISO-8601 date `YYYY-MM-DD` |
| W+4 due | `date:W+4 due:start` | ISO-8601 date = launch + 28d |
| Status | `Status` | `instrumented` or `read done` |
| Last read | `Last read` | free text: uniques / volume / weekly trend |
| Last read date | `date:Last read date:start` | ISO-8601 date |

Dates also accept `:end` and `:is_datetime` keys — leave them unset for single dates.

## Write a row (INSTRUMENT)

`notion-create-pages` with:
```
parent: { type: "data_source_id", data_source_id: "1a51daf9-7bd8-4933-a8c6-25fa712a31ed" }
pages: [{
  properties: {
    "Feature": "<short name>",
    "Announcement URL": "<slack url>",
    "Author": "[\"<notion-user-id>\"]",
    "Crew": "setup",
    "Amplitude event(s)": "button_clicked (properties.name=prevenir_xxx_clicked)",
    "date:Launch date:start": "2026-06-23",
    "date:W+4 due:start": "2026-07-21",
    "Status": "instrumented"
  }
}]
```
Optionally put the captured success definition (if the author stated one) in the page
**content**, not a property — properties stay structured, the prose context goes in the body.

## Find due rows (READ)

Use `notion-query-data-sources` against `1a51daf9-7bd8-4933-a8c6-25fa712a31ed` with a
SQLite-style filter:
```sql
SELECT * FROM "collection://1a51daf9-7bd8-4933-a8c6-25fa712a31ed"
WHERE "Status" = 'instrumented' AND "date:W+4 due:start" <= '<today YYYY-MM-DD>'
```
Read back `url` (the page id, needed to update), Feature, Announcement URL, Crew,
`Amplitude event(s)`, `date:Launch date:start`.

## Mark a row done (READ)

`notion-update-page` on the row's page id:
```
properties: {
  "Status": "read done",
  "Last read": "uniques 142 · volume 318 · weekly 20/35/41/46 (rising)",
  "date:Last read date:start": "<today>"
}
```

## Resolving the Author to a Notion user

Use `notion-get-users` with a name/email query to map the Slack author to a Notion user id.
Known: Louis-Marie Bonnefont = `2fcd872b-594c-8102-972d-0002592597fc`. If you can't resolve
it confidently, leave `Author` as `[]` and put the name in the page body — don't guess a wrong id.
