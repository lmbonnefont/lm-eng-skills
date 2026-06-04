---
name: lm-deep-context
description: >
  Gather comprehensive product context from Linear, Slack, Notion, Figma, Sentry,
  Amplitude, git history, GitHub PRs, and GitHub Discussions before starting feature
  development. Use when: /lm-deep-context,
  'gather context for EP-XXXX', 'research EP-XXXX before building', 'what do we know about
  [Linear URL]', 'deep dive on ticket', 'context for [feature name]', or any request to
  understand the full background of a Linear ticket before implementation. Also trigger when
  the user wants to enrich a ticket with cross-tool context, understand decision history,
  or find related past work. Even if the user doesn't mention "deep context" explicitly,
  use this skill whenever they want to research or understand a ticket before coding.
  Not for: implementation or code changes — use guided-feature-development after this
  skill completes.
---

# Deep Context — Product Context Gathering

Gather comprehensive product context from multiple sources before starting feature development. This skill runs in its **own session** — it never shares context with guided-feature-development. The two skills communicate exclusively via `.claude/plans/deep-context-{ticket-id}.md`.

**Question format**: Every question to the user MUST use the `AskUserQuestion` tool with predefined `options`. Never output questions as plain text.

---

## Phase 0: Input Parsing & Auth Check

### Parse Input

Accept `$ARGUMENTS` as either:
- A Linear ticket ID (e.g., `EP-1234`, `OHSET-466`)
- A Linear URL (e.g., `https://linear.app/alan/issue/EP-1234/...`)

Extract the ticket ID:
- From URL: regex `linear.app/.*/([A-Z]+-\d+)`
- Direct ID: validate format `[A-Z]+-\d+`

If no argument provided, use `AskUserQuestion`: "What's the Linear ticket ID or URL?" with a free text option.

### Auth Preflight

Before the fan-out, verify that each MCP source is authenticated. Run lightweight test calls in parallel via subagents — one per source. Each subagent attempts a single cheap call and reports success or failure:

| Source | Test Call | Auth Type |
|--------|----------|-----------|
| **Linear** | `mcp__linear__get_issue` with the ticket ID | Config-based (`.mcp.json`) |
| **Slack** | `mcp__claude_ai_Slack__slack_search_public` with ticket ID | OAuth (claude.ai) — calling the tool triggers the browser auth flow |
| **Notion** | `mcp__notion__notion-search` with ticket ID | OAuth (claude.ai) — calling the tool triggers the browser auth flow |
| **Figma** | Skip test — only used if URLs found in ticket | Config-based |
| **Sentry** | `mcp__sentry__search_issues` with a keyword | Config-based |
| **Amplitude** | `mcp__claude_ai_Amplitude__get_context` | OAuth (claude.ai) — calling the tool triggers the browser auth flow |

**How to handle auth failures:**

- **OAuth MCP tools (Slack, Notion, Amplitude)**: The first call to an unauthenticated OAuth tool automatically triggers the browser-based OAuth flow. Tell the user: "Slack/Notion needs authentication — a browser window should have opened. Please authorize, then I'll retry." After the user confirms, retry the call.
- **Config-based MCP tools (Linear, Figma, Sentry)**: These require server configuration in `.mcp.json`. If the call fails, tell the user: "{Tool} MCP is not configured or not responding. Check your `.mcp.json` configuration." Offer to skip.

After all preflight checks, if any sources failed and the user didn't authenticate:
- Use `AskUserQuestion`: "These sources are unavailable: [{list}]. Options:"
  - "Continue without them"
  - "Let me authenticate first — wait"

Track which sources are available in a `sources` dict for Phase 2.

**Linear is mandatory.** If Linear auth fails and can't be fixed, stop and ask the user to paste the ticket content manually.

---

## Phase 1: Linear Ticket Fetch

This phase is **sequential** — its output feeds into all Phase 2 subagents.

Launch a **general-purpose subagent** with this task:

> Fetch the Linear ticket {ticket-id} via `mcp__linear__get_issue`.
> Extract and return this JSON structure:
> ```json
> {
>   "identifier": "EP-1234",
>   "title": "...",
>   "description": "...",
>   "state": "...",
>   "priority": "...",
>   "labels": ["..."],
>   "assignee": "...",
>   "team": { "name": "...", "key": "..." },
>   "project": { "name": "...", "id": "..." },
>   "parent": { "identifier": "...", "title": "..." },
>   "children": [{ "identifier": "...", "title": "...", "state": "..." }],
>   "relations": [{ "identifier": "...", "title": "...", "type": "..." }],
>   "linked_urls": ["figma.com/...", "notion.so/...", "..."],
>   "search_keywords": ["keyword1", "keyword2", "keyword3"],
>   "component_hints": ["module_name", "directory_name"]
> }
> ```
>
> **Keyword extraction**: Derive 3-5 search keywords from:
> 1. The ticket title — strip common verbs (Add, Fix, Update, Implement, Create)
> 2. Entity/component names in the description (e.g., "SIRET", "enrollment", "intercom")
> 3. Technical identifiers: API endpoint names, component names, file paths
> 4. The team key (e.g., "OHSET", "EP")
>
> **Component hints**: Identify likely codebase directories from the description (e.g., "occupational_health", "member_lifecycle", "contracting").
>
> Return ONLY the JSON — no commentary.

---

## Phase 2: Parallel Fan-Out

Launch subagents **in parallel** for each authenticated source. Each subagent receives the ticket JSON and search keywords from Phase 1. Each has a **120-second timeout** — if it doesn't complete, its results are marked as "timed out" in the final document.

Read `references/subagent-prompts.md` for the exact prompt template for each subagent.

### Subagent A — Linear Deep-Dive

**Tools**: `mcp__linear__list_comments`, `mcp__linear__research`, `mcp__linear__search_issues`, `mcp__linear__get_project`

**Task**: Find the full picture around this ticket in Linear:
- All comments on the ticket (discussion thread, decisions, blockers)
- Related issues via semantic search (`research` tool) using the ticket title
- Issues with similar labels in the same team
- Project context if the ticket belongs to a project

**Returns**: Related issues (with status + summary), comment thread highlights, project context, similar past items.

### Subagent B — Slack Search

**Tools**: `mcp__claude_ai_Slack__slack_search_public_and_private`, `mcp__claude_ai_Slack__slack_read_thread`

**Task**: Find discussions about this ticket or feature area in Slack:
- Search for the ticket identifier (e.g., "EP-1234")
- Search for 2-3 keywords from the ticket
- For the top 3 most relevant thread hits: read the full thread

**Returns**: Key discussions, decisions made in Slack, participating stakeholders, links shared.

### Subagent C — Notion Search

**Tools**: `mcp__notion__notion-search`, `mcp__notion__notion-query-meeting-notes`, `mcp__notion__notion-fetch`

**Task**: Find related documentation in Notion:
- Search for the ticket identifier
- Search for feature keywords
- Query meeting notes that mention the feature/area
- For top 3 relevant pages: fetch full content

**Returns**: Related specs, decision records, meeting notes excerpts, key product decisions.

### Subagent D — Code History & GitHub Discussions

**Tools**: `git log`, `gh pr list`, `gh pr view`, `git shortlog`, `gh api graphql` (via Bash)

**Task**: Understand the code history and community discussions around the affected area:
- `git log --since="90 days ago" --oneline --name-only -- {component_hints dirs}` (cap: 200 lines)
- `git log --all --oneline --grep="{ticket-id}"` for commits referencing the ticket
- `gh pr list --search "{keywords}" --state all --limit 10` for related PRs
- `gh pr list --search "{ticket-id}" --state all --limit 5` for directly linked PRs
- For top 2-3 relevant PRs: `gh pr view {number}` for description and review comments
- `git shortlog -sn --since="90 days ago" -- {component_hints dirs}` for contributor map
- **GitHub Discussions**: Search via GraphQL — discussions are often **not linked to tickets or PRs**, so explore broadly:
  - Search by ticket ID: `search(query: "repo:alan-eu/alan-apps is:discussion {identifier}")`
  - Search by keywords (component names, product terms, feature name): `search(query: "repo:alan-eu/alan-apps is:discussion {keyword1} OR {keyword2}")`
  - For top 3 relevant discussions: read body + first comments, extract decisions and participants

**Returns**: Recent changes summary, related PRs (status + key review comments), contributor expertise, past attempts at similar work, related GitHub Discussions (decisions, architectural proposals).

### Subagent E — Figma (conditional)

**Only launch if** `linked_urls` from Phase 1 contains `figma.com` URLs.

**Tools**: `mcp__figma__get_design_context`, `mcp__figma__get_screenshot`

**Task**: For each Figma URL found:
- Get the design context (code reference + screenshot)
- Extract component specs

**Returns**: Design descriptions, component specs, screenshot references.

### Subagent F — Sentry

**Tools**: `mcp__sentry__search_issues`, `mcp__sentry__search_events`

**Task**: Check production health in the affected area:
- Search for error issues matching component/module keywords
- Search events for relevant endpoint paths (if identifiable from the ticket)

**Returns**: Recent errors in the area, error frequency, affected user count, or "no errors found."

### Subagent G — Amplitude Usage Data

**Tools**: `mcp__claude_ai_Amplitude__get_context`, `mcp__claude_ai_Amplitude__search`, `mcp__claude_ai_Amplitude__get_charts`, `mcp__claude_ai_Amplitude__query_chart`, `mcp__claude_ai_Amplitude__get_event_properties`, `mcp__claude_ai_Amplitude__get_session_replays`, `mcp__claude_ai_Amplitude__list_session_replays`, plus `Grep` (for light code exploration)

**Timeout: 180 seconds** (longer than other subagents — Amplitude requires sequential bootstrapping and chart exploration is slower).

**Task**: Find usage analytics related to the feature area:
- **Step 1 (mandatory, sequential)**: Call `get_context` to discover organization and accessible projects. Select the most relevant project using this heuristic:
  - Team key `ES` → Alan-Spain (299386), `BE` → Alan-Belgium (311120), `CA` → Alan-Canada (659169)
  - Ticket mentions "mind" or "santé mentale" → Alan Mind (357857)
  - Default → Alan (249047) — the main FR project
- **Step 2**: Search for charts/dashboards matching feature keywords
- **Step 3**: For the top 3 relevant charts, query them to get actual data
- **Step 4**: Discover event properties related to the feature area
- **Step 5**: Light code exploration — use `Grep` to find event names pushed to Amplitude in the affected component directories (e.g., search for `track_event`, `analytics.track`, `amplitude` patterns). Cap at 2-3 minutes of exploration. This surfaces the exact event names used in the codebase.
- **Step 6**: If the ticket involves user-facing UI, search for session replays in the affected area

**Returns**: Key usage metrics, relevant charts with data summaries, events from Amplitude + events found in code, session replay links if available.

---

## Phase 3: Synthesis

Receive all subagent results. Synthesize into a structured document.

Write to `.claude/plans/deep-context-{ticket-id}.md`:

```markdown
# Deep Context: {ticket-id} — {title}

_Generated on {date} by /lm-deep-context_

## Ticket Summary
- **Status**: {state} | **Priority**: {priority} | **Team**: {team}
- **Assignee**: {assignee}
- **Project**: {project name}
- **Labels**: {labels}
- **Created**: {date} | **Updated**: {date}

## Narrative

The opening of the document. Tells the reader, in their own narrative voice, **where this work currently stands**, **what we know with confidence**, and **what is still unclear** — every factual claim backed by a clickable source link (zero-trust). A reader who only reads this section should walk away knowing what the ticket is really about.

### Where we are
{2-3 sentences. Current state of the topic — who is pushing it, since when, what momentum exists. Every factual claim must include at least one clickable source link in-line. Example: "This work was prioritized after [a Slack escalation from the Care Ops crew](https://alanhealth.slack.com/archives/CXXXXXX/pXXXXXXX) on 2026-04-12, and is now blocking [the Q2 Prévenir launch milestone](https://linear.app/alan/project/xxx)."}

### What we know
{3-5 dense bullets — the solid conclusions that emerge from cross-referencing the sources. Each bullet must end with one or more clickable source links. No bullet without a link.}
- {Conclusion stated plainly} ([source label](url), [other source](url))
- ...

### What's still unclear
{2-4 bullets — contradictions, grey areas, gaps detected across sources. Point to the specific passages.}
- {Ambiguity} — [source A says X](url) but [source B says Y](url)
- ...

**Inference rule**: if any synthesis sentence is an inference rather than directly sourced, mark it explicitly: `_(inference, not directly sourced)_`. Better to flag than to assert silently.

## Problem Statement
{1-2 paragraph synthesis combining the Linear ticket description with context
discovered in Slack and Notion. Not just the ticket — the enriched understanding
of WHY this work is needed and WHAT problem it solves for users.}

## Decision History
{Chronological list of decisions found across sources:}
- **{date}** ({source: Slack/Notion/Linear}): {decision or discussion point}
  - Source: {link if available}
- ...

## Past Attempts & Related Work
{From git history, closed PRs, related Linear issues:}
- **{PR/issue identifier}**: {what was tried, outcome, why closed/merged}
- ...
{If nothing found: "No prior attempts found in the last 90 days."}

## Related Issues
| Identifier | Title | Status | Relationship |
|-----------|-------|--------|-------------|
| ... | ... | ... | parent/blocks/related |

## Production State
### Sentry Errors
{Recent errors in the affected area, frequency, user impact — or "No errors found."}

### Usage Data
{From Amplitude: key usage metrics, chart summaries with data highlights, relevant events
(both from Amplitude discovery and from code grep), session replay links if available.
If Amplitude was unavailable or returned no results: "Amplitude: not available / no relevant data found."}

## Design Context
{Figma links with descriptions — or "No designs found/linked."}

## Key Stakeholders
{People identified from Linear comments, Slack threads, Notion docs, git blame.
Format: Name — where they appeared (e.g., "Alice — active in Slack discussion, main reviewer on past PRs")}

## Next Steps

The closing section. Turns the gathered context into concrete moves the reader can take **before writing any code**. Every item must cite its source.

### Decisions to make before coding
{Trade-offs surfaced in Slack/Notion/Linear that haven't been resolved yet. Each item names the decision, the competing options, and where it was last discussed.}
- **{Decision title}**: {option A} vs {option B} — last discussed in [Slack thread title](url) on {date}
- ...

### Risks & red flags
{Production errors in the affected area, past attempts that failed, technical debt known in the zone. Each item links to evidence.}
- **[BLOCKING] {Risk title}**: {one-sentence description} — [source](url)
- **[MINOR] {Risk title}**: {one-sentence description} — [source](url)
- ...

### Open questions (prioritized)
{Classify by impact: `[BLOCKING]` (must answer before kickoff) vs `[NICE-TO-CLARIFY]` (can be resolved during implementation). For each: who to ask (a stakeholder identified in the sources, with link to where they appeared) and where to look first.}
- **[BLOCKING] {Question}** — Ask: {Stakeholder name} ([context](url)). Look in: [Notion page](url) / [Linear ticket](url) / [Slack channel](url).
- **[NICE-TO-CLARIFY] {Question}** — ...

If a category yields nothing, write `_None identified._` rather than omitting the heading.

## Source Availability
{Which sources were queried, which returned results, which were skipped:}
- Linear: {OK / unavailable / no results}
- Slack: {OK / unavailable / skipped (not authenticated) / no results}
- Notion: {OK / unavailable / skipped (not authenticated) / no results}
- Git/GitHub/Discussions: {OK / no results}
- Figma: {OK / skipped (no URLs) / unavailable}
- Sentry: {OK / unavailable / no results}
- Amplitude: {OK / unavailable / skipped (not authenticated) / no results}

## Search Queries Used
{The keywords and queries used — useful for manual follow-up:}
- Keywords: {list}
- Slack searches: {queries}
- Notion searches: {queries}
- Git searches: {commands}
- GitHub Discussions searches: {queries}
- Amplitude searches: {queries}
```

### Synthesis Guidelines

- **Narrative (top of doc)**: This is the most important section — write it last, after all other sections are populated, so it can synthesize across them. It must read like a briefing, not a list of facts. Three sub-sections: *Where we are* (status + momentum), *What we know* (solid conclusions), *What's still unclear* (gaps + contradictions). Every factual sentence must carry at least one clickable source link. If a synthesis is an inference rather than direct evidence, mark it `_(inference, not directly sourced)_`.
- **Next Steps (bottom of doc)**: Drive action, not reading. *Decisions to make before coding* surfaces unresolved trade-offs from the discussions. *Risks & red flags* surfaces production errors and failed past attempts. *Open questions* are prioritized `[BLOCKING]` vs `[NICE-TO-CLARIFY]` and each one names a stakeholder to ask + a place to look first.
- **Problem Statement**: Don't just copy the ticket description. Enrich it with context from Slack discussions, Notion specs, and related issues. Explain the "why" — what user problem or business need drives this work. **Explain every technical term, acronym, component name, and product concept on first use.** Don't write "using async_exports with XLSX format" — write "using the async_exports component (a backend system that generates files in the background and emails them to the requester) with XLSX format (an Excel spreadsheet format)".
- **Decision History**: Be chronological. Include source and link. Highlight decisions that constrain the implementation (e.g., "Decided in Slack to NOT use X approach because Y").
- **Past Attempts**: Focus on what was tried and WHY it succeeded or failed — this prevents repeating mistakes.
- **Why this structure works**: Sections in the middle (Decision History, Past Attempts, Production State, etc.) are the *evidence base*. Narrative and Next Steps are the *interpretation*. The reader who has 30 seconds reads Narrative + Next Steps; the reader who needs to verify a claim drills into the middle sections via the clickable links.

### Plain Language & Didactic Guidelines

The deep-context document will be read by people who may have **no prior knowledge** of the product, codebase, or domain. Every section must be self-contained and understandable without external context. Before writing, compile a glossary of all acronyms, component names, product terms, and jargon found across all subagent results. Use this glossary consistently — expand each term on **first use**, then use the short form afterward.

**Acronyms**: On first use, always expand AND explain in plain language.
- Example: "NTT (Numéro Technique Temporaire — a temporary technical ID assigned to members before they receive their permanent Social Security number)"
- Do NOT assume any acronym is well-known — even common ones like "BL" or "PR" deserve expansion in this context.

**Component/module names**: When first mentioning a codebase component, explain what it does.
- Example: "the async_exports component (a backend system that handles background file generation and email delivery for large data exports)"
- Apply to: backend components (e.g., "occupational_health", "member_lifecycle"), frontend modules (e.g., "AffiliationsPage"), infrastructure patterns (e.g., "ExportRequestBroker"), external integrations (e.g., "Intercom — a customer messaging platform used for admin notifications").

**Product terms**: Explain product-specific terms on first use.
- Examples: "Prévenir (Alan's occupational health / workplace wellness product)", "woodchucker (Alan's term for a small, self-contained task suitable for newcomers)", "affiliation (the process of linking a company employee to a Prévenir subscription)".

**Technical jargon**: Clarify terms that have project-specific meaning.
- Examples: "BL (Business Logic — the core domain code that implements business rules, separate from API controllers)", "acceptance testing (manual QA in a staging environment before production release)".

**How to discover explanations**: Use context from Notion, Slack, Linear, and code gathered by subagents to infer what things mean. If a component's purpose is unclear from gathered data, say so: "async_exports (purpose not fully clear from gathered context — appears to handle background file generation)".

**Rule of thumb**: If you would need to read code or ask a colleague to understand a term, it needs explanation in the document.

### Clickable Sources

Every source cited in the document MUST be a **clickable markdown link**. Never cite a source as plain text in parentheses — always use `[label](url)` format. Subagents return URLs for each item; use them consistently.

Formats by source:
- Linear comment: `[Linear, 2026-03-30](https://linear.app/alan/issue/OHSET-456#comment-xxxxx)`
- Linear issue: `[OHSET-276](https://linear.app/alan/issue/OHSET-276)`
- Slack thread: `[Slack #channel-name, 2026-03-18](https://alanhealth.slack.com/archives/{CHANNEL}/p{MSG_TS}?thread_ts={THREAD_TS}&cid={CHANNEL})` — **MANDATORY**: include both `thread_ts` AND `cid` query params so the link opens the thread context, not the standalone message. Without `thread_ts`, the user lands on an isolated message and can't find the surrounding discussion. For root messages outside a thread (or DMs), `?cid={CHANNEL}` alone is fine. The `slack_search_*` MCP tools expose `thread_ts` in the parent's `Message_ts` field and in permalinks — reuse those values verbatim.
- Notion page: `[Notion "Page Title"](https://www.notion.so/alan/xxxxx)`
- GitHub PR: `[PR #85124](https://github.com/alan-eu/alan-apps/pull/85124)`
- GitHub Discussion: `[Discussion #32356](https://github.com/alan-eu/alan-apps/discussions/32356)`
- Amplitude chart: `[Amplitude "Chart Name"](https://app.amplitude.com/analytics/alan-health/chart/xxxxx)`
- Sentry issue: `[Sentry WEB-2EQ5](https://sentry.io/organizations/alan/issues/xxxxx/)`
- Figma design: `[Figma "Design Name"](https://www.figma.com/design/xxxxx)`
- **Code reference**: `[workspace_action.py:40](../../backend/components/.../workspace_action.py#L40)` — **MANDATORY** prefix with `../../` because the doc lives in `.claude/plans/` and VSCode resolves markdown links relative to the file location, not the workspace root. Without `../../`, clicking the link tries to open `.claude/plans/backend/...` and fails. Range: `#L40-L51`. Folder: `[src/utils/](../../src/utils/)`.

If a subagent didn't return a URL for an item, construct it from known patterns (e.g., PR number → `https://github.com/alan-eu/alan-apps/pull/{number}`, Linear identifier → `https://linear.app/alan/issue/{identifier}`). If no URL can be constructed, use the plain text label as fallback.

---

## Phase 4: Handoff

Present a concise summary of the key findings to the user. Mirror the new doc shape — narrative first, action items second:

1. **Where we are** (2-3 sentences pulled verbatim from the Narrative section)
2. **Top 3 decisions to make before coding** (from Next Steps → Decisions)
3. **Top 3 risks** (from Next Steps → Risks & red flags, blocking ones first)
4. **Top open questions marked [BLOCKING]** (from Next Steps → Open questions)

Then display the handoff command:

> **Context gathered and saved to `.claude/plans/deep-context-{ticket-id}.md`.**
>
> To start development in a fresh session, run in a new terminal:
> ```
> claude "/guided-feature-development {ticket-id}"
> ```

Use `AskUserQuestion` with options:
- "Done — I'll start guided-feature-development in a new session"
- "Dig deeper on a specific area"
- "Save context and stop here"

If "Dig deeper": ask which area (Linear, Slack, Notion, Code, Sentry, Amplitude, GitHub Discussions), then re-run that specific subagent with more targeted queries. Append findings to the existing deep-context document.

---

## Key Principles

- **Auth first, skip second**: Always try to authenticate before giving up on a source. The user gets the most value when all sources are available.
- **Summaries, not raw data**: Subagents return structured summaries. Never dump raw API responses or full file contents into the context document.
- **120s timeout per subagent** (180s for Amplitude): Better to get most sources than wait forever for a slow one.
- **Linear is the anchor**: Everything else enriches the Linear ticket. If only Linear works, the skill still produces useful output.
- **Separate sessions**: This skill and guided-feature-development NEVER run in the same session. The deep-context file is the only communication channel.
- **Narrative + Next Steps are the highest-value sections**: The middle sections are the evidence base. The opening Narrative tells the reader where things stand, the closing Next Steps tells them what to do. Both are zero-trust — every claim links to its source.
- **No "How to Test" here**: This skill runs *before* code is written. Local navigation, role discovery, and test-entity finding belong to `/how-to-test`, called separately when implementation begins.
