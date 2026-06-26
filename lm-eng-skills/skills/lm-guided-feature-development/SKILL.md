---
name: lm-guided-feature-development
description: "Guided 6-part feature development workflow from Linear ticket to production. Use when: /lm-guided-feature-development command, 'develop EP-XXXX', 'start working on [Linear URL]', 'new feature from ticket', or any explicit request to follow the guided feature workflow. Also use when invoked with --from-plan PATH to start directly at Part 6 from a saved plan. Not for: hotfixes, refactors, documentation-only changes, or simple bug fixes."
---

# Feature Development Workflow

AI-guided workflow for building features from specs to production. The AI drives the process by asking clarifying questions at every stage — you validate, decide, and implement.

**Question format**: Every question to the user MUST use the `AskUserQuestion` tool with predefined `options`. Never output questions as plain text with bullet-point choices. This ensures the user gets a clickable selector UI instead of having to type responses.

## Context Window Strategy

This skill is split into **two sessions** to preserve context window:

- **Session 1** (Parts 1–5): Research, planning, architecture → writes `.claude/plans/feature-plan-{ticket-id}.md`
- **Session 2** (Part 6): Implementation → started with `/lm-guided-feature-development --from-plan .claude/plans/feature-plan-{ticket-id}.md`

**Subagents are used for all costly operations** (Linear fetch, Figma fetch, codebase exploration, code review). The main thread only receives structured summaries — never raw file contents or raw API responses.

### Detecting Session Mode

On invocation:
- **`--from-plan PATH`** → Session 2: read the plan file, jump directly to Part 6. The plan already contains all context from Session 1 — re-exploring or re-fetching would waste tokens reproducing work that's already done.
- **Ticket ID provided, checkpoint exists** at `.claude/plans/feature-checkpoint-{ticket-id}.md` → ask: "Checkpoint found (Part X complete). Resume from Part Y?" If yes, read checkpoint and resume. If no, start fresh.
- **No checkpoint** → Session 1, start at Part 1.

### Checkpoint File

The checkpoint file `.claude/plans/feature-checkpoint-{ticket-id}.md` is written (or updated) **immediately after each Part completes and receives user confirmation** in Session 1. It accumulates state progressively so the session can be resumed if interrupted.

Structure (sections are added as Parts complete):
```markdown
# Checkpoint: {ticket-id}
last_completed_part: {1|2|3|4|5}

## Part 1: Product Requirements
{synthesis from Step 4}
{figma_specs JSON from subagent}

## Part 2: Technical Architecture
{all_usages counts from Step 1}
{breaking_changes list from Step 1}
{reuse_discovery JSON from Step 2 — feature needs + scored candidates}
{subagent JSON output + confirmed proposals from Step 3}
{alternatives considered + rationale for choice (from Step 4, if run)}

## UX Delight (optional)
{adopted recommendations from /lm-ux-delight, or "Skipped" / "Not run"}

## Part 3: Tracking
{metrics + code, or "skipped"}

## Part 4: Global Plan
{LOC estimates, split decision}

## Part 5: Sub-tickets
{Linear URLs created, or "no split"}
```

**Write rule**:
- **Immediately after user validates each Part** (Part 1 Step 4, Part 2 Step 4, Part 3 confirmation, Part 4 confirmation, Part 5 creation), write/update the checkpoint
- Never rewrite the whole file — only add/update the section that just completed, and update `last_completed_part` field
- Write the checkpoint only after the user confirms a Part is complete. If you write it too early (before confirmation), a crash or rejection would leave stale state that corrupts the resume flow.

**On resume**: read the checkpoint, skip already-completed Parts, continue from the next one.

---

## Overview: 6 Parts

1. **Product Specs** — Fetch Linear ticket via subagent, clarify ambiguities, confirm understanding
2. **Technical Plan** — Explore codebase via subagent, **walk through existing flow with user**, propose architecture, list dependencies
3. **Tracking** (optional) — Define success metrics, suggest implementation
4. **Global Plan** — Estimate scope, decide if split is needed
5. **Split Tickets** (conditional) — Create sub-tickets if frontend + backend or >500L
6. **Implementation** — For each part: test strategy → code → review (subagent) → PR → present

---

## Global Gate Rule

**CRITICAL — applies everywhere in this skill:**

After completing any Part or sub-step, always stop and use the `AskUserQuestion` tool with these options:
- "Yes, proceed" → continue to next step
- "Skip [next step name]" → skip it, ask about the one after
- "Stop here" → pause

Pausing between parts lets the user course-correct early — if you auto-proceed, wasted work compounds because the user might have wanted to skip or change direction.

Applies to: every Part transition (1→2, 2→3, …, 5→6), every sub-step within Part 6 (6a→6b, …, 6e→6f), and after each batch of clarifying questions in Part 1.

---

## Part 1: Product Specs

**Goal**: Extract complete product requirements, identify edge cases, confirm understanding.

### Step 0: Check for Deep Context

Before fetching the Linear ticket, check if a file matching `.claude/plans/deep-context-{ticket-id}*.md` exists (where `{ticket-id}` is the ticket identifier, e.g., `EP-1234`). The deep-context skill appends a slug to the filename (e.g., `deep-context-EP-1234-user-dashboard.md`), so always use a **glob/prefix match**, not an exact match. In zsh, use `ls .claude/plans/deep-context-{ticket-id}* 2>/dev/null` or the Glob tool with pattern `deep-context-{ticket-id}*` to avoid "no matches found" errors.

**If the file exists**, read it and use its contents to:
- **Skip re-fetching** the Linear ticket in Step 1 — the deep-context file already contains the ticket summary, description, labels, team, etc.
- **Pre-populate clarifying questions** in Step 3 — if the deep-context file's "Decision History" or "Open Questions" sections already answer a question you would have asked, skip that question
- **Enrich the synthesis** in Step 4 — include decision history, past attempts, stakeholder context, and production state from the deep-context file

**If the file does not exist**, proceed normally to Step 1. Do not suggest running `/deep-context` — the user may have intentionally skipped it.

**Important**: Still run Step 2 (classify) and Step 3 (clarify) even when deep-context exists. Deep-context provides background research, not implementation decisions.

### Step 1: Fetch & Extract (via subagent)

**If Step 0 found a deep-context file**: Skip the Linear MCP call. Extract the structured data from the deep-context file's "Ticket Summary" section and any Figma URLs from the "Design Context" section. Still scan for `figma.com` URLs and fetch Figma specs for any URLs not already covered.

**If no deep-context file**: Launch a **general-purpose subagent** with the following task:
- Fetch the Linear ticket via Linear MCP (`get_issue`)
- Extract: title, description, acceptance criteria, linked docs
- Scan ticket body and attachments for `figma.com` URLs
- For each Figma URL found: invoke `/figma-to-murray-code` and capture the full output
- Return a structured JSON:
  ```json
  {
    "title": "...",
    "description": "...",
    "acceptance_criteria": ["..."],
    "linked_docs": ["..."],
    "figma_specs": [
      { "url": "https://figma.com/...", "specs": "<full /figma-to-murray-code output>" }
    ]
  }
  ```

**CRITICAL — Figma rule**: Figma is fetched **once and only once**, here in Part 1, via the subagent. The specs are written to the plan file at the end of Part 5. Session 2 NEVER re-fetches Figma — the specs are in the plan.

**If Linear MCP fails**: Ask user to paste ticket content manually.
**If a Figma URL is broken**: Note it and proceed without it.

### Step 2: Classify Feature Type

From the JSON received, classify:
- **Layer**: frontend-only, backend-only, or full-stack
- **UI pattern** (if frontend): form, list, wizard, empty state, notification, etc.

This drives: question selection (Step 3), Part 3 activation, Part 4 split logic, Part 6 tool selection.

### Step 3: Ask Clarifying Questions (via `/lm-grill-me`)

Delegated to `/lm-grill-me`, which drives the interview with `AskUserQuestion` (2-4 concrete options per question, first option = recommendation). It centralizes the interview logic and guarantees the structured format.

Invoke the skill in caller mode with the classification context (Step 2) + a pointer to the question bank:

```
Call: Skill(skill: "lm-grill-me", args: "--caller --bank references/product-questions.md --feature-type {classified_type}")
```

Context to pass in the invocation prompt:
- Classified feature type (form, list, wizard, etc.)
- JSON from Part 1 Step 1 (deep-context if present — `/lm-grill-me` skips questions that are already resolved)
- Acceptance criteria from the ticket

**Scope = product/UX only.** Explicitly pass this instruction to `/lm-grill-me`: never ask an implementation/code/technical question (data model, API shape, persistence/storage mechanism, auth mechanism, pagination strategy, encryption, sync/async, idempotence). These decisions are made in Part 2 (Technical Plan), not here. If a technical ambiguity arises, note it for Part 2 rather than asking about it now.

At the end, `/lm-grill-me` returns a JSON `{questions_asked, unresolved, decisions_summary}` to merge into the Part 1 bundle before Step 4 (Synthesis).

### Step 4: Synthesis & Confirmation

Write a summary: feature description, edge cases, acceptance criteria (original + discovered), assumptions clarified.

**User confirms** or flags issues.

**Immediately after user confirms**: Write/create the checkpoint file `.claude/plans/feature-checkpoint-{ticket-id}.md` with the `## Part 1` section. If the file already exists, append or update only the Part 1 section.

---

## Part 2: Technical Translation

**Goal**: Propose architecture, identify reusable components, list dependencies, find ALL impacted locations.

**After Part 2 completes**: You MUST propose the UX delight pass to the user via the Part 2 gate options below — never silently skip it. The user decides whether to run it or not. If chosen, invoke `/lm-ux-delight {ticket-id}`. The delight skill reads the checkpoint (Part 1 specs + Part 2 exploration) to recommend UX micro-improvements without any additional codebase exploration. Adopted recommendations are written to the checkpoint as `## UX Delight (optional)` and carried into the plan file.

### Step 1: Flow Walkthrough (via `/lm-flow-walkthrough`)

**Goal**: Trace the existing flow end-to-end and make sure the user understands how the current system works before proposing changes. Delegated to `/lm-flow-walkthrough` which produces annotated call chains + narrative explanations with `file:line` references.

For each key entry point identified in Part 1 (endpoints, components, entities), launch a **subagent** that runs `/lm-flow-walkthrough` in **caller mode**:

1. Gather the list of entry points from Part 1 classification:
   - API endpoints mentioned in the ticket
   - Component names / entity names involved
   - Existing features being modified

2. For each entry point, launch a subagent with this prompt (adapt {entry_point} and {feature_classification}):
   ```
   You MUST use the Skill tool to invoke the /lm-flow-walkthrough skill. Do NOT trace the flow yourself — delegate to the skill.

   Call: Skill(skill: "lm-flow-walkthrough", args: "--caller {entry_point}")

   Context from Part 1: {feature_classification}

   After the skill returns, also count ALL usages of key concepts with Grep (total occurrences, top 10 by impact, report full count).

   Return the structured JSON output + human-readable call chain and narrative. Do not interact with the user.
   ```

3. Merge subagent outputs into a single combined result:
   ```json
   {
     "call_chains": [ ... all annotated chains from flow-walkthrough ... ],
     "all_usages": { ... merged from all runs ... },
     "relevant_files": [ ... deduplicated, sorted by frequency across chains ... ],
     "breaking_changes": [ ... derived from gaps + potential_issues across all chains ... ],
     "patterns": [ ... deduplicated patterns_observed ... ],
     "reuse_candidates": [ ... files appearing in multiple chains ... ],
     "dependencies": [ ... external/ calls found across chains ... ],
     "e2e_flows": [ ... end-to-end flows from all runs ... ]
   }
   ```

4. **Present the flow(s) to the user**: show the annotated call chain(s) from the subagent(s) using the `` `path/to/file:LINE` `` format. Use `AskUserQuestion`:
   - "Yes, I understand the existing flow — let's move on to the changes"
   - "Explain step [X] in more detail"
   - "Show me the contents of file [Y]"

**Do not proceed to Step 2 until the user confirms they understand the current system.**

### Step 2: Reuse Discovery (via `/lm-reuse-discovery`)

**Goal**: Actively hunt for the functions/hooks/components/types/factories already present in the repo that can cover the feature's needs, **before** proposing the architecture. Avoids the systemic duplication that the flow walkthrough (Step 1) does not catch — the flow only traverses existing paths, not the side utilities.

Launch a subagent that invokes the skill in caller mode:

```
You MUST use the Skill tool to invoke the /lm-reuse-discovery skill. Do NOT search the codebase yourself — delegate to the skill.

Call: Skill(skill: "lm-reuse-discovery", args: "caller mode --ticket {ticket-id}")

Context : Part 1 specs are in `.claude/plans/feature-checkpoint-{ticket-id}.md`. The skill will read it.

Return the structured JSON output + human-readable summary. Do not interact with the user.
```

Merge the JSON into the Part 2 bundle under `reuse_discovery`. Present the text summary to the user via `AskUserQuestion`:
- "Reuse validated — continue to the architecture"
- "Exclude some candidates" (let them type)
- "Skip Reuse Discovery, build from scratch"

**The `reuse_discovery` JSON is passed to the Architecture Alternatives subagent (Step 4) so it knows the reusable building blocks.**

### Step 3: Architecture Proposal

From the subagent outputs (flow walkthrough + reuse discovery) :
1. Identify reuse vs. new build — **explicitly use the high/medium candidates from `reuse_discovery`**
2. List dependencies (backend APIs, database changes, new packages)
3. **List all breaking changes** from the subagent
4. Propose tech stack with rationale
5. **Propose update strategy**: "These N files use {concept} and will need updates. Order: [migration] → [backend] → [frontend]"

**User confirms** or suggests alternatives.

### Step 4: Architecture Alternatives Review (via subagent)

Before locking in the architecture, use `AskUserQuestion` with: "Want to explore alternative approaches before committing?" Options: `["Yes, review alternatives", "Skip, I'm happy with this approach"]`.

If **skip**: proceed directly to checkpoint.

If **yes**: Launch a **general-purpose subagent** that acts as a devil's advocate. Give it:
- The product requirements from Part 1
- The confirmed architecture from Step 3
- The codebase exploration results from Step 1 (relevant_files, patterns, reuse_candidates)
- The `reuse_discovery` JSON from Step 2 (feature needs + scored candidates)

The subagent must propose **3 alternative approaches**, each optimizing for a different axis:

1. **Cleaner** — Better design patterns, less coupling, more maintainable. Looks for: unnecessary abstractions in the proposed approach, missed opportunities to use established patterns (e.g., existing hooks, shared components, service layers), ways to reduce the surface area of changes.

2. **Faster** — Ships sooner with less code. Looks for: existing utilities or components that could be stretched to cover the use case, parts of the proposed architecture that are over-engineered for the actual requirements, ways to reuse more and build less.

3. **Bolder** — Fundamentally different angle. Looks for: a completely different decomposition of the problem, an approach the main thread might not have considered because it was anchored to the first viable solution (e.g., solving it with configuration instead of code, leveraging a different existing system, inverting the data flow).

The subagent returns a structured comparison:
```json
{
  "alternatives": [
    {
      "name": "Cleaner",
      "summary": "one-liner",
      "approach": "what changes vs. the original",
      "tradeoffs": "what you gain, what you lose",
      "estimated_loc_delta": "+/- vs original"
    },
    { "name": "Faster", ... },
    { "name": "Bolder", ... }
  ],
  "recommendation": "which one (if any) the subagent thinks beats the original, and why — or 'stick with original' if none do"
}
```

Present the 3 alternatives to the user with `AskUserQuestion`. Options: `["Stick with original", "Dig into Cleaner", "Dig into Faster", "Dig into Bolder"]`.

If the user picks an alternative: rework the architecture proposal from Step 3 to incorporate it, then re-confirm with the user before proceeding.

**Immediately after user confirms final architecture**: Update the checkpoint file `.claude/plans/feature-checkpoint-{ticket-id}.md` with the `## Part 2` section. Include both the chosen architecture and a brief note on which alternatives were considered and why they were accepted/rejected — this context helps Session 2 understand the reasoning.

**Part 2 gate options** (override the default gate for this transition — always present ALL options via `AskUserQuestion`, never silently skip any):
- "Run UX delight pass" (recommended) → invoke `/lm-ux-delight {ticket-id}`. The delight skill reads the checkpoint (Part 1 + Part 2) to suggest UX micro-improvements. Adopted suggestions are written to the checkpoint as `## UX Delight (optional)`.
- "Skip UX delight, proceed to Part 3"
- "Skip to Part 4"
- "Stop here"

---

## Part 3: Tracking (optional)

**Activated if**: Feature is user-facing (has frontend layer). **Auto-skipped** for backend-only features — still apply Gate Rule: announce "Part 3 skipped (backend-only, not user-facing). Proceed to Part 4?"

1. Recommend key metrics (conversion, usage, error rate)
2. Show implementation code (DataDog event, Sentry breadcrumb)

**User confirms** or skips.

**Immediately after user confirms/skips**: Update the checkpoint file `.claude/plans/feature-checkpoint-{ticket-id}.md` with the `## Part 3` section (or note if skipped).

---

## Part 4: Global Plan

1. Estimate LOC per component (frontend, backend, tests)
2. **Split required if**: feature touches **both frontend AND backend**, OR estimated >500L total
3. **No split if**: single-layer (frontend-only OR backend-only) AND estimated ≤500L

### If Split Required → Part 5
Propose breakdown: Backend (~LOC), Frontend (~LOC), Migration (~LOC if needed).

**Immediately after user confirms**: Update the checkpoint file `.claude/plans/feature-checkpoint-{ticket-id}.md` with the `## Part 4` section.

### If No Split → Write Plan & Jump to Part 6
**Immediately after user confirms no split**: Update the checkpoint file with the `## Part 4` section, then write the plan file (see below) and announce Session 2.

---

## Part 5: Split Tickets

**Goal**: Create sub-tickets in Linear for independent work.

1. Propose breakdown: Backend, Frontend, Migration (if needed)
2. Create each via Linear MCP (`save_issue`) with parent link, title, description, acceptance criteria, estimated size
3. Display created ticket URLs

**Order**: Migration (if any) → Backend → Frontend

**Immediately after tickets are created**: Update the checkpoint file `.claude/plans/feature-checkpoint-{ticket-id}.md` with the `## Part 5` section (list of Linear URLs).

After Part 5: Write the plan file and announce Session 2.

---

## Writing the Plan File (end of Session 1)

After Part 4 (no split) or Part 5 (split), write `.claude/plans/feature-plan-{ticket-id}.md`:

```markdown
# Feature Plan: {ticket-id}

## Product Requirements
{synthesis from Part 1 Step 4 — not the raw ticket}

## Figma Specs
{for each design:}
### {figma_url}
{full /figma-to-murray-code output from the subagent}

## Technical Architecture
{output from Part 2 subagent + confirmed proposals}

## Reuse Discovery
{reuse_discovery JSON from Part 2 Step 2 — feature needs + accepted candidates with file:line references}

## UX Delight
{adopted recommendations from /lm-ux-delight, or "N/A"}

## Breaking Changes
{list from Part 2 Step 1 — files that will break if component signature changes}

## Flow Traces
{for each flow traced in Part 2 Step 1 via /lm-flow-walkthrough:}
### {entry point description}
{annotated call chain with `file:LINE` clickable references}
{gaps flagged}

## Search Queries for Session 2
{pre-built search commands to find usages — use ripgrep (rg) when available, fall back to grep otherwise:}
- `rg "mobile_instructions_fr" frontend/`
- `rg "DocumentRequestUploadContext" .`
{if ripgrep is not installed, equivalent grep commands:}
- `grep -r "mobile_instructions_fr" frontend/`
- `grep -r "DocumentRequestUploadContext" .`

## All Usages (counts)
{from Part 2 subagent all_usages — for reference}
- DocumentRequestUploadContext: 18 total occurrences
- mobile_instructions_fr: 5 total occurrences

## Tracking
{metrics and implementation code if Part 3 was run, else "N/A"}

## Implementation Plan
{list of tickets/tasks with LOC estimates}
{if split: include Linear URLs of sub-tickets}

## Key Files
{relevant_files array from Part 2 subagent (top 10 by impact)}

## Implementation Order
{migration (if any) → backend → frontend}
{note: start with breaking changes, end with dependent code}
```

Then announce:

> **Session 1 complete. Plan written to `.claude/plans/feature-plan-{ticket-id}.md`.**
> Start a new session with: `/lm-guided-feature-development --from-plan .claude/plans/feature-plan-{ticket-id}.md`

---

## Part 6: Implementation Loop

**Entry**: Read the plan file. Session 2 has a smaller context budget. The plan already contains all the context from Session 1 — re-exploring or re-fetching would waste tokens reproducing work that's already done.

**Figma in Session 2**: The plan contains Figma specs. Use them as-is.
**Exception**: If a Figma URL is found in Session 2 that is absent from the plan, do NOT re-fetch — signal to the user that this is abnormal and ask them to update the plan.

### Search Tool Strategy: ripgrep preferred

When running search commands via Bash (not the built-in Grep tool), prefer **ripgrep (`rg`)** — it's faster, respects `.gitignore` by default, and has better output formatting. Fall back to `grep -r` only if `rg` is not available.

Quick detection: run `command -v rg` at the start of Session 2. If it returns a path, use `rg` for all Bash searches. If not, use `grep -r`.

Key `rg` advantages over `grep -r`:
- Automatically skips `.git/`, `node_modules/`, and other gitignored paths
- `--type` flag for language filtering (e.g., `rg --type py "pattern"`)
- `--context` / `-C` for surrounding lines
- Faster on large codebases

### Tool Selection Guide: When to Use Which

**Check a single concept** (e.g., "Where is DocumentRequestUploadContext used?")
→ Use **Grep tool** or **ripgrep (`rg`)** directly with the plan's pre-built search queries (cheap, <1sec, no context cost). Prefer `rg` in Bash when you need advanced filtering (e.g., `--type`, `--glob`, `--context`); use the built-in Grep tool for simple searches.

**Understand architectural patterns or multi-file dependencies**
→ Use **Explore agent** only if the plan's "Key Files" don't cover your current task (expensive, context cost)

**Modify a file but need to understand its structure**
→ Use **Read tool** directly, don't spawn Explore

**Plan's "Breaking Changes" or "Search Queries" don't match what you're seeing**
→ Flag to user: "Plan might be outdated" (ask if they want to update before proceeding)

If the plan doesn't cover something you need, ask the user rather than re-exploring. Re-exploration in Part 6 is expensive and usually means the plan was incomplete — better to surface that than silently compensate.

**For each ticket (or single ticket if no split):**

### 6a: Test Strategy Validation

Consult `references/testing-strategy.md` and confirm. Apply only the relevant section(s) based on feature layer:

**Frontend tickets**: Navigation URL + conditions, unit test scenarios, Storybook variants
**Backend tickets**: Integration test endpoints (pytest + Flask test client), unit test scenarios, migration validation

> Gate → [6b]

### 6b: Implementation

Code the feature + tests following the test plan. Use Figma specs from the plan (section "Figma Specs") as reference for component structure and styling.

**Write-time readability** — Before writing the implementation, invoke `/lm-write-readable` in caller mode so readability rules are loaded up front and a self-critique pass runs on the just-written code (before the 6c reviews catch it):

```
Call: Skill(skill: "lm-write-readable", args: "--caller")
```

This is write-time only (it does not review the diff, hunt bugs, or audit conventions — that stays in 6c). It returns a short readability summary, then control returns here. Skip it for trivial one-line changes.

**Helper skills** (use only when relevant to the ticket's layer):
- Frontend: `jest-unit-test`, `storybook-stories`
- Backend: no special skill — use pytest directly

> Gate → [6c]

### 6c: Review (via subagent)

**Step 1: Bug & quality review** — Launch a **subagent** invoking `/review` on current changes.

The subagent returns **only the P0/P1/P2 findings report** — the main thread does not see the raw diff.

Use `AskUserQuestion` with the findings list as options (one option per finding, labeled by ID + summary), plus "All" and "None" as additional options. Set `multiSelect=true`.

Fix selected findings. Re-run review subagent if fixes were made.

**Step 2: Local compliance review (user-chosen)** — Before launching, use `AskUserQuestion` to propose this step: "Want to run a local compliance review? It catches convention violations and naming inconsistencies before the PR — the kind of feedback reviewers would flag." Options: `["Yes, run compliance review", "Skip, proceed to PR"]`. Never silently skip this step.

If the user chooses yes: Launch a **subagent** invoking `/lm-local-compliance-review` on current changes.

The subagent returns **P1/P2/P3 compliance findings** with educational "Learn" sections pointing to real codebase examples.

Present findings interactively: the user can dive deeper into any finding (type the number), apply fixes ("fix all" or "fix N"), or continue.

> Gate → [6d]

### 6d: Create PR

Invoke `create-pr` to create branch, commit, submit PR with template, tag `ai-generated`.

> Gate → [6e]

### 6e: Presentation

Provide: summary of what was built, test coverage, known limitations/follow-ups.

> Gate → [6a] (next ticket)

Loop back to 6a for next ticket until all complete.

---

## Enriching the Skill

After Part 1: "Discovered new product questions? Add to `references/product-questions.md`?"
After Part 6: "Found test patterns worth remembering? Add to `references/testing-strategy.md`?"

---

## Key Principles

- **Questions over assumptions**: Ask, don't guess product intent
- **Multi-choice over open-ended**: Faster decisions with bounded options
- **Gates between parts**: User controls the pace
- **Living references**: Question bank and test patterns grow with each feature
- **Small PRs**: ~500L max per PR
- **Test-first**: Every implementation starts with test strategy
- **Subagents for cost**: Linear, Figma, codebase exploration, code review all run in subagents — main thread sees only structured summaries
- **Two sessions**: Research (1–5) and execution (6) are separate conversations to keep each context window lean
- **Code references with line numbers**: When mentioning any piece of code, always use `` `path/to/file:LINE` `` format — never just a file name. This creates clickable links in terminals and IDEs so the user can navigate directly without searching.

## Gotchas

- **Re-exploration in Session 2**: Claude tends to spawn Explore agents in Part 6 despite the plan having all needed context. The plan's "Key Files" and "Search Queries" sections exist precisely to avoid this — re-exploring wastes context budget.
- **Plain text questions**: Claude sometimes outputs questions as bullet points in text instead of using AskUserQuestion. The user then has to type a response instead of clicking. Always use the tool.
- **Checkpoint timing**: Claude may forget to write/update the checkpoint after user confirms a Part. If the session crashes, progress is lost. Write the checkpoint immediately after each Part confirmation.
- **Subagent context bloat**: Subagents sometimes return raw file contents or full API responses instead of structured summaries. This bloats the main thread's context. Subagent instructions must explicitly say "return only a structured summary."
- **Premature implementation**: Claude may start coding before the user confirms the architecture in Part 2. Always wait for explicit confirmation.
- **Vague file references**: Claude may mention a file without a line number (e.g. "see `member_service.py`"). Always include the line number: `` `member_service.py:203` ``. The user should never have to search manually.
- **Skipping flow walkthrough**: Claude may jump straight from Step 1 flow-walkthrough to architecture proposals without presenting the call chain to the user. The user needs to understand the current system before reviewing proposed changes — always present the flow-walkthrough output and wait for confirmation.
- **Subagent does exploration instead of invoking the skill**: The flow-walkthrough subagent may do the codebase exploration itself (Grep, Read, Glob) instead of calling `Skill(skill: "lm-flow-walkthrough", ...)`. The subagent MUST use the Skill tool to invoke `/lm-flow-walkthrough` — that skill has specific output structure and quality guarantees that raw exploration cannot replicate.
- **Fixing the wrong layer (production vs output)**: When a feature changes what the user sees (filename, email, displayed text), Claude tends to modify the *production* point (e.g., S3 upload) instead of the *output* point (e.g., download endpoint's `Content-Disposition`). Always trace the full end-to-end flow from user trigger to visible output, and fix the output point. The `e2e_flows` field in the Explore subagent response exists to prevent this.
