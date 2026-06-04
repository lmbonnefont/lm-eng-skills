# Subagent Prompt Templates

Use these templates when launching Phase 2 subagents. Replace `{placeholders}` with actual values from Phase 1.

---

## Subagent A — Linear Deep-Dive

```
You are researching Linear ticket {identifier} ("{title}") for context gathering.

Your tools: mcp__linear__list_comments, mcp__linear__research, mcp__linear__search_issues, mcp__linear__get_project

Tasks (in order):
1. Call list_comments for issue {identifier} — summarize the discussion thread: key decisions, blockers raised, questions asked
2. Call research with query: "{title}" — find semantically related issues
3. Call search_issues with keywords: {search_keywords} — find issues matching these terms
4. If the ticket belongs to project "{project_name}": call get_project to get project context (goals, milestones, members)

IMPORTANT: Include URLs for every item so the synthesis can produce clickable links.
- Comment URLs: construct from issue identifier + comment context (e.g., "https://linear.app/alan/issue/{identifier}#comment-{id}")
- Issue URLs: "https://linear.app/alan/issue/{identifier}"

Return ONLY this JSON (no commentary):
{
  "comments_summary": [
    { "author": "...", "date": "...", "key_point": "...", "url": "https://linear.app/alan/issue/{identifier}" }
  ],
  "related_issues": [
    { "identifier": "...", "title": "...", "state": "...", "relevance": "why it's related", "url": "https://linear.app/alan/issue/{identifier}" }
  ],
  "project_context": {
    "name": "...",
    "description": "...",
    "milestones": ["..."]
  },
  "key_decisions": ["decisions extracted from comments or related issues"],
  "blockers": ["any blockers mentioned"]
}

Cap: max 10 related issues, max 20 comments summarized. If a tool fails, set that field to null and continue.
```

---

## Subagent B — Slack Search

```
You are searching Slack for context about Linear ticket {identifier} ("{title}").

Your tools: mcp__claude_ai_Slack__slack_search_public_and_private, mcp__claude_ai_Slack__slack_read_thread

Tasks:
1. Search for "{identifier}" (the exact ticket ID)
2. Search for these keywords (one search per keyword): {search_keywords[0:3]}
3. From all search results, identify the top 3 most relevant threads
4. Read each of those 3 threads in full using slack_read_thread

IMPORTANT: Include thread URLs for clickable links in the final document. Construct them so they open the **thread context**, not the standalone message:
- Format: `https://alanhealth.slack.com/archives/{channel_id}/p{msg_ts_no_dot}?thread_ts={thread_ts}&cid={channel_id}`
- `msg_ts_no_dot` = the timestamp with the dot removed (e.g. `1774953783.874329` → `p1774953783874329`)
- `thread_ts` = the parent message's timestamp **with the dot preserved** (e.g. `1774953737.777729`). This is exposed by `slack_search_*` results either in the parent's `Message_ts` field, or directly in the permalink's `thread_ts` query param — reuse it verbatim.
- Both `thread_ts` AND `cid` are MANDATORY when the message belongs to a thread. Without `thread_ts`, the user lands on an isolated message and cannot find the surrounding discussion.
- For root messages outside any thread (or DMs), `?cid={channel_id}` alone is fine — omit `thread_ts`.

Return ONLY this JSON:
{
  "threads": [
    {
      "channel": "...",
      "channel_id": "...",
      "thread_ts": "1774953737.777729",
      "thread_url": "https://alanhealth.slack.com/archives/{channel_id}/p{msg_ts_no_dot}?thread_ts={thread_ts}&cid={channel_id}",
      "date": "...",
      "participants": ["..."],
      "summary": "2-3 sentence summary of the discussion",
      "key_decisions": ["any decisions made"],
      "links_shared": ["URLs shared in the thread"]
    }
  ],
  "stakeholders": ["people who discussed this topic — name and role if visible"],
  "overall_sentiment": "brief note on how the team feels about this work"
}

Cap: max 3 threads read in full, max 10 search results scanned. If Slack returns no results for a query, skip it and try the next.
```

---

## Subagent C — Notion Search

```
You are searching Notion for documentation related to Linear ticket {identifier} ("{title}").

Your tools: mcp__notion__notion-search, mcp__notion__notion-query-meeting-notes, mcp__notion__notion-fetch

Tasks:
1. Search for "{identifier}" (exact ticket ID)
2. Search for each keyword: {search_keywords[0:3]}
3. Query meeting notes mentioning these keywords
4. For the top 3 most relevant pages found: fetch their full content

Return ONLY this JSON:
{
  "specs": [
    {
      "title": "...",
      "url": "...",
      "summary": "2-3 sentence summary of what this page covers",
      "key_decisions": ["decisions documented in this page"],
      "figma_urls": ["any Figma URLs found in the page"]
    }
  ],
  "meeting_notes": [
    {
      "title": "...",
      "url": "...",
      "date": "...",
      "summary": "what was discussed about this topic",
      "action_items": ["relevant action items"]
    }
  ],
  "decision_records": ["any formal decisions documented about this area"]
}

Cap: max 3 pages fetched in full, max 5 meeting notes summarized. Focus on RECENT documents first.
```

---

## Subagent D — Code History & GitHub Discussions

```
You are researching the code history AND GitHub Discussions related to Linear ticket {identifier} ("{title}").
The affected codebase areas are likely: {component_hints}

Your tools: Bash (for git and gh commands), Grep, Glob

Tasks (run these commands):

Git & PRs:
1. git log --since="90 days ago" --oneline --name-only -- {component_hint_dirs} | head -200
2. git log --all --oneline --grep="{identifier}"
3. gh pr list --search "{search_keywords[0]} {search_keywords[1]}" --state all --limit 10
4. gh pr list --search "{identifier}" --state all --limit 5
5. For the top 2-3 most relevant PRs: gh pr view {number} (get description + review highlights)
6. git shortlog -sn --since="90 days ago" -- {component_hint_dirs}

GitHub Discussions (IMPORTANT: discussions are often NOT linked to tickets or PRs — explore broadly):
7. Search by ticket ID:
   gh api graphql -f query='{ search(query: "repo:alan-eu/alan-apps is:discussion {identifier}", type: DISCUSSION, first: 5) { discussionCount nodes { ... on Discussion { title number url body comments(first:5) { nodes { body author { login } } totalCount } category { name } createdAt } } } }'
8. Search by keywords (component names, product terms, feature name — use broad terms):
   gh api graphql -f query='{ search(query: "repo:alan-eu/alan-apps is:discussion {search_keywords[0]} OR {search_keywords[1]}", type: DISCUSSION, first: 5) { discussionCount nodes { ... on Discussion { title number url body comments(first:5) { nodes { body author { login } } totalCount } category { name } createdAt } } } }'
9. For the top 3 most relevant discussions: extract key decisions, proposals, and participants from body + comments

Return ONLY this JSON:
{
  "recent_changes": [
    { "commit": "...", "date": "...", "summary": "...", "files_changed": ["..."] }
  ],
  "related_prs": [
    {
      "number": 123,
      "title": "...",
      "url": "https://github.com/alan-eu/alan-apps/pull/123",
      "state": "merged/open/closed",
      "author": "...",
      "summary": "what this PR did",
      "key_review_comments": ["notable review feedback"],
      "outcome": "merged successfully / closed because X"
    }
  ],
  "contributors": [
    { "name": "...", "commits": 10, "expertise": "main contributor to this area" }
  ],
  "past_attempts": ["any PRs that were closed without merging — what went wrong"],
  "discussions": [
    {
      "number": 12345,
      "title": "...",
      "url": "...",
      "category": "...",
      "date": "...",
      "summary": "what was proposed/decided",
      "key_decisions": ["decisions made in this discussion"],
      "participants": ["people involved"]
    }
  ]
}

Cap: max 5 PRs detailed, max 10 contributors listed, max 3 discussions read in detail. Focus on PRs that CHANGED the same files/directories. For discussions, prioritize recent ones with decisions or architectural proposals.
```

---

## Subagent E — Figma

```
You are fetching design context for Linear ticket {identifier} ("{title}").

Figma URLs found: {figma_urls}

Your tools: mcp__figma__get_design_context, mcp__figma__get_screenshot

Tasks (for each Figma URL):
1. Extract fileKey and nodeId from the URL:
   - figma.com/design/:fileKey/:fileName?node-id=:nodeId → convert "-" to ":" in nodeId
   - figma.com/design/:fileKey/branch/:branchKey/:fileName → use branchKey as fileKey
2. Call get_design_context with fileKey and nodeId
3. Call get_screenshot with fileKey and nodeId

Return ONLY this JSON:
{
  "designs": [
    {
      "url": "...",
      "description": "what this design shows",
      "components": ["component names used"],
      "design_tokens": ["colors, spacing, typography noted"],
      "annotations": ["any designer notes or annotations"]
    }
  ]
}
```

---

## Subagent F — Sentry

```
You are checking production health related to Linear ticket {identifier} ("{title}").
The affected areas are likely: {component_hints}

Your tools: mcp__sentry__search_issues, mcp__sentry__search_events

IMPORTANT: Do NOT use analyze_issue_with_seer — it is a paid feature.

Tasks:
1. Search issues with keywords from: {search_keywords}
2. If endpoint paths are identifiable from the ticket, search events for those paths

Return ONLY this JSON:
{
  "errors": [
    {
      "title": "...",
      "count": 123,
      "first_seen": "...",
      "last_seen": "...",
      "affected_users": 45,
      "url": "sentry link"
    }
  ],
  "health_summary": "brief assessment: is this area healthy, degraded, or broken?"
}

Cap: max 5 most relevant errors. If no errors found, return { "errors": [], "health_summary": "No errors found in this area." }
```

---

## Subagent G — Amplitude Usage Data

```
You are researching usage analytics related to Linear ticket {identifier} ("{title}").
The affected codebase areas are likely: {component_hints}
The team key is: {team_key}

Your tools: mcp__claude_ai_Amplitude__get_context, mcp__claude_ai_Amplitude__search, mcp__claude_ai_Amplitude__get_charts, mcp__claude_ai_Amplitude__query_chart, mcp__claude_ai_Amplitude__get_event_properties, mcp__claude_ai_Amplitude__get_session_replays, mcp__claude_ai_Amplitude__list_session_replays, Grep, Glob

Tasks (steps 1-2 are SEQUENTIAL — step 1 must complete before anything else):

1. Call get_context to discover the organization and accessible projects. Select the most relevant project using this mapping:
   - Team key "ES" → Alan-Spain (appId: 299386)
   - Team key "BE" → Alan-Belgium (appId: 311120)
   - Team key "CA" → Alan-Canada (appId: 659169)
   - Ticket mentions "mind" or "santé mentale" → Alan Mind (appId: 357857)
   - Default → Alan (appId: 249047) — the main FR project

2. Using the selected projectId, search for charts/dashboards matching: {search_keywords}

3. Call get_charts to list charts in the project — filter for ones matching: {search_keywords}

4. For the top 3 most relevant charts found: call query_chart to get their actual data. Summarize key metrics (e.g., "1.2k daily active users", "85% completion rate").

5. Call get_event_properties to discover events related to: {search_keywords}

6. Light code exploration — use Grep to find Amplitude event names pushed from the affected code areas:
   - Search for patterns like "track_event", "analytics.track", "amplitude", "track(" in {component_hint_dirs}
   - Cap this exploration at 2-3 minutes — just find the event name strings, don't analyze the full code
   - This helps cross-reference what events exist in code vs what Amplitude reports

7. If the ticket involves user-facing UI (dashboard, page, screen, modal, form): call list_session_replays or get_session_replays to find recent sessions in the affected area

Return ONLY this JSON:
{
  "project": { "name": "...", "appId": "..." },
  "charts": [
    {
      "name": "...",
      "description": "what this chart measures",
      "key_metrics": "summary of the data (e.g., '1.2k daily active users', '85% completion rate')",
      "url": "amplitude link if available"
    }
  ],
  "events_from_amplitude": [
    { "name": "...", "description": "...", "properties": ["relevant properties"] }
  ],
  "events_from_code": [
    { "event_name": "...", "file_path": "...", "context": "brief context of where/how this event is tracked" }
  ],
  "session_replays": [
    { "url": "...", "summary": "what this replay shows" }
  ],
  "usage_summary": "2-3 sentence summary of how users interact with this feature area based on the data"
}

Cap: max 3 charts queried in detail, max 5 events from Amplitude, max 5 events from code, max 3 session replays. If no relevant data found, return { "charts": [], "events_from_amplitude": [], "events_from_code": [], "session_replays": [], "usage_summary": "No relevant usage data found for this feature area." }
```

---

## Common Instructions for All Subagents

Every subagent prompt should end with:

```
IMPORTANT:
- Return ONLY the JSON structure specified above. No commentary, no markdown.
- If a tool call fails or returns an error, set that field to null and continue with the other tasks.
- If a tool is not available (MCP not configured), return: { "status": "unavailable", "source": "{source_name}" }
- Cap your results as specified — don't return more items than the limits.
- Prefer recent information over old information.
- Timeout: you have 120 seconds to complete all tasks (180s for Amplitude). If running low on time, return what you have.
- ALWAYS include a "url" field for every item that has a linkable source. The synthesis phase needs URLs to produce clickable links. Construct URLs from known patterns if the API doesn't return them directly (e.g., PR number → "https://github.com/alan-eu/alan-apps/pull/{number}", Linear identifier → "https://linear.app/alan/issue/{identifier}").
```
