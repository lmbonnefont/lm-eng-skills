---
name: lm-review-all
description: >
  Full review of a PR: runs /review (bugs, quality, tests), /lm-local-compliance-review
  (conventions, ruler rules), /lm-ux-delight (UX micro-improvements), /lm-reviewer-rules
  (rules extracted from Bastien Landre & Mickaël Berguem's reviews), /lm-hardcore-review
  as the Architecture & Structure Review (abstractions, modularity, code judo, spaghetti)
  in parallel, plus a 6th Context Walkthrough agent that produces a non-technical summary +
  glossary, shown as a preamble before the findings.
  Aggregates findings into a P0-P3 report with source badges. Use when: /lm-review-all,
  "revue complète", "full review", "review everything", "all reviews on PR #123",
  "lance toutes les revues", or any request to run several reviews on the same changes.
  Also use when the user asks for an in-depth review before merge or before requesting a
  human review.
---

# Full Review (orchestrated)

Launches the subagents you select at the start (any subset of 6) in parallel: 5 reviews (`/review`,
`/lm-local-compliance-review`, `/lm-ux-delight`, `/lm-reviewer-rules`, `/lm-hardcore-review` —
the Architecture & Structure Review) + 1 Context Walkthrough (summary + glossary). **All launched
subagents run in the background and stay completely silent.** Nothing is shown to the reviewer
until every one of them has finished — not even the Context preamble.

Once they are all done, the skill emits **a single block, posted at once**: the Context preamble
(summary + glossary) first, then the merged findings ranked by priority. Each
finding cites its origin and includes `file:line` references.

> **Why fully deferred (not the old "show the preamble early" design):** a half-streamed report
> is noise. Showing the ramp-up context first, then later interrupting with findings, fragments
> the reviewer's attention and makes the run feel like it's talking to itself. One quiet wait,
> one complete deliverable, is calmer and easier to act on. The early-preamble optimization
> (start reading context while reviews run) was not worth the cost of a chatty, multi-part
> output — so the whole run is now silent until the consolidated block is ready.

This skill **orchestrates** — it does not review by itself. It delegates, aggregates, deduplicates.

## Usage

- `/lm-review-all` — auto-detect (current branch, uncommitted changes, last commit)
- `/lm-review-all PR#123` or `/lm-review-all https://github.com/.../pull/123` — specific PR
- `/lm-review-all abc123f` — specific commit
- `full review` / `revue complète` / `review everything` — natural-language trigger

At the start of **every** run, the skill prints a numbered menu of the 6 subagents and waits for
your reply (numbers / `all` / names) — see Step 2. There is no flag; the selection is always explicit.

> **Token cost.** Running all 6 is ~6 subagents × ~80k tokens. Two levers keep it down:
> - **Unticking subagents** at the Step 2 prompt — e.g. dropping Reviewer Rules + UX Delight saves ~30%.
> - **Model tiering** (always on): the 2 non-reasoning subagents — Context Walkthrough and
>   UX Delight — run on a cheaper model (`sonnet`), the 4 bug/structure reviewers stay on `opus`.

## Step 1: Determine the target

Use `$ARGUMENTS` if provided, otherwise auto-detect:

1. **PR number/URL in the args** → store as `TARGET` (e.g. `PR#123`)
2. **Commit SHA in the args** → store as `TARGET`
3. **On a feature branch** (not `main`) → `TARGET` = current branch (the sub-skills auto-detect)
4. **Uncommitted changes** → `TARGET` = empty (the sub-skills auto-detect)
5. **Fallback** → `TARGET` = empty

Also extract the **ticket ID** from the branch or PR title (pattern `EP-XXXX`, `OHSET-XXX`,
`SIM-XXXX`, etc.) for `/lm-ux-delight`.

The **set of subagents to launch** (`SELECTED`) is not derived from args — it is asked
explicitly via checkboxes in Step 2 just below.

## Step 1.5: Pre-compute the PR scope (DIFF_FILES)

**Before launching the subagents**, compute the exact list of files changed by the target.
This list (`DIFF_FILES`) is the single source of truth on the PR's perimeter. It is injected
into the 5 subagents' prompts to prevent them from analyzing files outside the PR.

- If TARGET is a PR (number or URL) → `gh pr diff {PR_NUMBER} --name-only`
- If TARGET is a commit SHA → `git show --name-only --format="" {SHA}`
- If TARGET is a branch or empty → `git diff main...HEAD --name-only`

Store the result as `DIFF_FILES` (list of paths, one per line).

> **Why this is critical:** without this explicit scope, each subagent auto-scopes onto the
> whole branch (or repo), producing findings and a summary about files absent from the diff.
> A UX Delight subagent that sees the whole branch will produce suggestions for files this PR
> does not touch, polluting the report and misleading the reviewer.

## Step 2: Ask the user which subagents to launch

**Always ask — there is no flag and no default set.** This is the **only** interactive moment in
the whole run; the orchestrator asks it (the subagents never interact with the user).

**Do NOT use `AskUserQuestion`** — its hard cap of 4 options per question can't present all 6
subagents in one flat list. Instead, print the menu below as a normal message and **wait for the
user's reply**:

```
Which subagents do you want to launch? Reply with the numbers (e.g. `1 3 6`), `all`, or names.

1. Code Review — /review (bugs, quality, tests)
2. Compliance — /lm-local-compliance-review (conventions, ruler rules)
3. Reviewer Rules — /lm-reviewer-rules (Bastien & Mickaël's review patterns)
4. Architecture & Structure — /lm-hardcore-review (abstractions, modularity, spaghetti)
5. UX Delight — /lm-ux-delight (UX micro-improvements, frontend PRs)
6. Context Walkthrough — summary + glossary preamble (cheap, on sonnet)
```

Parse the reply into the set `SELECTED`:
- `all` (or an empty reply) → all 6.
- numbers and/or names → exactly those subagents.
- a clear decline / nothing valid → launch nothing, say so, and stop (nothing to wait for).

`SELECTED` may be any subset of the 6 — launch only those, in one parallel message (Step 3).
Everything downstream keys off `SELECTED`: the launch (Step 3), the barrier count (Step 4.5),
which scratch files to read (Step 4), and which rows appear in the Sources line + token table
(Step 5). A subagent not in `SELECTED` is simply absent everywhere — not a missing source.

This menu message is allowed (it is before the Step 4.5 barrier, which starts at launch). After
the user replies, the run goes **silent** — no further questions or narration until Step 5.

After this single question, the run goes **silent** per the Step 4.5 barrier — no further
questions, no narration, until the consolidated block.

## Step 2.5: Prepare the UX Delight context

**Skip this step entirely if UX Delight is not in `SELECTED`** (it was not launched).

`/lm-ux-delight` works best from a checkpoint, not a PR.

1. If a ticket ID was found → check whether `.claude/plans/feature-checkpoint-{ticket-id}*.md` exists
2. **If a checkpoint is found** → pass the ticket ID to the UX Delight subagent
3. **If no checkpoint** → the UX Delight subagent is instructed to analyze the PR's changed files
   to identify UX opportunities (degraded mode, less precise but still useful)

## Step 3: Launch the subagents in parallel (all background, all silent)

**No output of any kind before all the launched subagents have finished — including the Context
Walkthrough.** There is no early preamble anymore.

In **a single message**, launch **only the subagents in `SELECTED`** (from Step 2) with
`run_in_background: true`. Pass each one the `model` shown below via the Agent tool's `model`
parameter (model tiering — the cheap-cognition subagents do not need Opus):

| # | Subagent | `model` |
|---|---|---|
| 1 | Code Review | `opus` |
| 2 | Compliance Review | `opus` |
| 3 | UX Delight | `sonnet` |
| 4 | Reviewer Rules | `opus` |
| 5 | Architecture & Structure Review | `opus` |
| 6 | Context Walkthrough | `sonnet` |

Launch the rows that are in `SELECTED` and skip the rest. The model tiering is fixed regardless
of selection: Context Walkthrough and UX Delight on `sonnet`, the bug/structure reviewers on
`opus`. (If summary/glossary quality on `sonnet` proves too thin, bump those two back to `opus` —
but tiering is the default.)

Behavior: the launching message blocks on nothing. The launched subagents run concurrently and
write their output to a scratch file (see the file-handoff contract below), each returning only
a content-free ack. Their completion notifications arrive over time; you stay silent through all
of them (Step 4.5 barrier). Only once **all launched subagents** have returned do you read the
scratch files and emit the single consolidated block (Step 4 → Step 5).

**IMPORTANT**: no subagent must interact with the user. No `AskUserQuestion`, no interactive
mode. **Every launched subagent** — including the Context Walkthrough — writes its output to a
scratch file and returns only a content-free ack.

### File-handoff contract (closes the per-agent output leak)

A `run_in_background` agent's **return value is rendered verbatim in its completion
notification** — which is visible in the conversation the moment that agent finishes. So if an
agent's findings (or the walkthrough narrative) travel in its return value, the reviewer sees
them per-agent, *before* the consolidated block in Step 5. That is precisely the noise the Hard
barrier (Step 4.5) exists to prevent, and the orchestrator staying silent in its own prose is
**not enough** to stop it — the leak comes from the agents' payloads, not the orchestrator.

This is exactly why subagent 6 cannot just be "background": if it returned its narrative inline,
that narrative would surface in its completion notification and break the "stay silent until all
launched subagents finish" guarantee. So it follows the same contract as the others.

The fix: route every agent's output through a file, so the notification stays content-free.
Each launched subagent writes its full output with the Write tool to a dedicated scratch
file, then returns only a one-line ack containing the path:

| Source | Scratch file |
|---|---|
| `/review` | `tmp/agent-scratch/review-all-review.md` |
| `/lm-local-compliance-review` | `tmp/agent-scratch/review-all-compliance.md` |
| `/lm-ux-delight` | `tmp/agent-scratch/review-all-ux-delight.md` |
| `/lm-reviewer-rules` | `tmp/agent-scratch/review-all-rules.md` |
| `/lm-hardcore-review` (Architecture & Structure Review) | `tmp/agent-scratch/review-all-architecture.md` |
| Context Walkthrough | `tmp/agent-scratch/review-all-context.md` |

The ack must contain the **path only** — no titles, no `file:line`, no priorities, not even a
finding count (a count is still a status leak the barrier forbids). An agent that finds nothing
writes `No issues found.` into its file and still returns only the ack.

### Subagent 1: Code Review

```
PR scope — the ONLY files changed in this PR:
{DIFF_FILES}

Scope your analysis strictly to these files. Do not analyze, mention, or make claims about
files outside this list. If a skill you invoke returns findings on other files, discard them.

You MUST use the Skill tool to invoke the /review skill. Do NOT review the code yourself.

Call: Skill(skill: "review", args: "{TARGET}")

Write the full structured report (P0, P1, P2 sections) to tmp/agent-scratch/review-all-review.md
with the Write tool. Do not summarize or rephrase. Each finding must include file:line.
If the skill produces "No issues found.", write exactly that into the file.

Do NOT put the report in your final message: that would surface it in your completion
notification before the orchestrator aggregates. Your final message must be ONLY this
content-free ack (no titles, no file:line, no priorities, no count), nothing else:

WROTE tmp/agent-scratch/review-all-review.md

Do NOT use AskUserQuestion. Do NOT ask questions. Just write the file and return the ack.
Stay completely silent while you work: emit NO intermediate prose, narration, plan, or
"the file already has content…" notes. Work quietly, write the file, return the ack — nothing else.
```

### Subagent 2: Compliance Review

```
PR scope — the ONLY files changed in this PR:
{DIFF_FILES}

Scope your analysis strictly to these files. Do not analyze, mention, or make claims about
files outside this list. If a skill you invoke returns findings on other files, discard them.

You MUST use the Skill tool to invoke the /lm-local-compliance-review skill. Do NOT review conventions yourself.

Call: Skill(skill: "lm-local-compliance-review", args: "{TARGET}")

Write the full structured report (P1, P2, P3 sections) with Learn sections to
tmp/agent-scratch/review-all-compliance.md with the Write tool. Do not summarize or rephrase.
Each finding must include file:line. If the skill finds nothing, write "No issues found." into the file.

Do NOT put the report in your final message: that would surface it in your completion
notification before the orchestrator aggregates. Your final message must be ONLY this
content-free ack (no titles, no file:line, no priorities, no count), nothing else:

WROTE tmp/agent-scratch/review-all-compliance.md

Do NOT use AskUserQuestion. Do NOT ask questions. Just write the file and return the ack.
Stay completely silent while you work: emit NO intermediate prose, narration, plan, or
"the file already has content…" notes. Work quietly, write the file, return the ack — nothing else.
```

### Subagent 3: UX Delight

**If a checkpoint is found:**
```
PR scope — the ONLY files changed in this PR:
{DIFF_FILES}

Scope your analysis strictly to these files. Do not analyze, mention, or make claims about
files outside this list. If the skill returns suggestions for files not in this list, discard them.

You MUST use the Skill tool to invoke the /lm-ux-delight skill. Do NOT analyze UX yourself.

Call: Skill(skill: "lm-ux-delight", args: "{ticket_id}")

Write the full list of recommendations to tmp/agent-scratch/review-all-ux-delight.md with the
Write tool. Do not summarize or rephrase. Do not modify the checkpoint.

Do NOT put the recommendations in your final message: that would surface them in your
completion notification before the orchestrator aggregates. Your final message must be ONLY
this content-free ack (path only, nothing else):

WROTE tmp/agent-scratch/review-all-ux-delight.md

Do NOT use AskUserQuestion. Just write the file and return the ack.
Stay completely silent while you work: emit NO intermediate prose, narration, plan, or
"the file already has content…" notes. Work quietly, write the file, return the ack — nothing else.
```

**If no checkpoint:**
```
PR scope — the ONLY files changed in this PR:
{DIFF_FILES}

Scope your analysis strictly to these files. Do not analyze, mention, or make claims about
files outside this list. If the skill returns suggestions for files not in this list, discard them.

You MUST use the Skill tool to invoke the /lm-ux-delight skill. Do NOT analyze UX yourself.

Call: Skill(skill: "lm-ux-delight")

The skill will auto-detect the current branch. If the skill asks for a ticket ID via
AskUserQuestion, answer with the branch name so it can attempt auto-detection.

If the skill cannot proceed, then — and ONLY then — analyze the changed frontend files
from the PR scope above for 3-5 UX opportunities: fewer clicks, smarter defaults,
direct outcome links. Only suggest improvements for files listed in DIFF_FILES.
For each recommendation, include:
- Short title
- What: 1 sentence
- Effort: Trivial or Medium
- File: file:line reference (must be a file in DIFF_FILES)

Write the full list of recommendations to tmp/agent-scratch/review-all-ux-delight.md with the
Write tool (write "No suggestions." if you have none). Do NOT put them in your final message:
that would surface them in your completion notification before the orchestrator aggregates.
Your final message must be ONLY this content-free ack (path only, nothing else):

WROTE tmp/agent-scratch/review-all-ux-delight.md

Do NOT use AskUserQuestion with the end user.
Stay completely silent while you work: emit NO intermediate prose, narration, plan, or
"the file already has content…" notes. Work quietly, write the file, return the ack — nothing else.
```

### Subagent 4: Reviewer Rules (Bastien & Mickaël)

```
PR scope — the ONLY files changed in this PR:
{DIFF_FILES}

Scope your analysis strictly to these files. Do not analyze, mention, or make claims about
files outside this list. If a skill you invoke returns findings on other files, discard them.

You MUST use the Skill tool to invoke the /lm-reviewer-rules skill. Do NOT apply rules yourself.

Call: Skill(skill: "lm-reviewer-rules", args: "{TARGET}")

Write the full structured report (P1, P2, P3 sections) to tmp/agent-scratch/review-all-rules.md
with the Write tool. Each finding must include file:line and the source PR link.
If nothing matches, write "No issues found." into the file.

Do NOT put the report in your final message: that would surface it in your completion
notification before the orchestrator aggregates. Your final message must be ONLY this
content-free ack (path only, nothing else):

WROTE tmp/agent-scratch/review-all-rules.md

Do NOT use AskUserQuestion. Do NOT ask questions. Just write the file and return the ack.
Stay completely silent while you work: emit NO intermediate prose, narration, plan, or
"the file already has content…" notes. Work quietly, write the file, return the ack — nothing else.
```

### Subagent 5: Architecture & Structure Review (abstractions, modularity, code judo, spaghetti)

This subagent runs the `/lm-hardcore-review` skill. Note: it is a **behavior-preserving**
maintainability review — it does NOT hunt runtime bugs or test coverage (that is Subagent 1's
job via `/review`). Its lane is structural quality, simplification, and codebase health.

```
PR scope — the ONLY files changed in this PR:
{DIFF_FILES}

Scope your analysis strictly to these files. Do not analyze, mention, or make claims about
files outside this list. If a skill you invoke returns findings on other files, discard them.

You MUST use the Skill tool to invoke the /lm-hardcore-review skill. Do NOT review the code yourself.

Call: Skill(skill: "lm-hardcore-review", args: "{TARGET}")

The skill performs a thermo-nuclear maintainability review focused on:
- Structural code-quality regressions and missed "code judo" simplification opportunities
- Files growing past 1000 lines without strong justification
- Spaghetti growth (ad-hoc conditionals, scattered special cases, one-off branches)
- Thin/magical abstractions, unnecessary wrappers, cast-heavy contracts
- Feature logic leaking into shared paths instead of dedicated abstractions
- Non-atomic updates and unnecessarily sequential orchestration

Write the full structured findings to tmp/agent-scratch/review-all-architecture.md with the Write
tool. Each finding must include file:line and a clear "preferred remedy" (delete a layer,
reframe state, extract helper, split file, move to canonical layer, etc.).
If the skill produces "No issues found." or its equivalent ("PR meets the approval bar"),
write exactly that into the file.

Do NOT put the findings in your final message: that would surface them in your completion
notification before the orchestrator aggregates. Your final message must be ONLY this
content-free ack (path only, nothing else):

WROTE tmp/agent-scratch/review-all-architecture.md

Do NOT use AskUserQuestion. Do NOT ask questions. Just write the file and return the ack.
Stay completely silent while you work: emit NO intermediate prose, narration, plan, or
"the file already has content…" notes. Work quietly, write the file, return the ack — nothing else.
```

### Subagent 6: Context Walkthrough (summary + glossary)

The 6th subagent runs **in parallel with the other 5 in the same Agent message**, also in the
**background** (`run_in_background: true`, like the other 5). Its output feeds the report
preamble (Step 5) and does not take part in the P0-P3 aggregation. Like the reviews, it writes
its output to a scratch file and returns only a content-free ack — so nothing it produces leaks
into its completion notification before the consolidated block.

Subagent prompt:

```
PR scope — the ONLY files changed in this PR:
{DIFF_FILES}

Scope your outputs strictly to these files. The summary and glossary must
only describe what these files do. Do not mention or describe files outside this list.
This is especially important for the summary: if a file appears on the branch but is NOT
in DIFF_FILES, it is not part of this PR and must not appear in any output.

You are building ramp-up context for a PR reviewer. Do NOT review code quality —
that is other subagents' job. Your job: help the reviewer understand WHAT the PR
touches.

**Stay completely silent until you have finished.** While you gather context (running
`gh`/`git`, grepping, calling MCP tools), emit NO intermediate text: no narration, no
progress notes, no "here is what I found so far", no partial summary or glossary. Work
quietly from start to end. The ONLY thing you ever emit is, at the very end, the
content-free ack below — after the file is fully written. Everything you produce goes
into the scratch file, nothing into the conversation before you are done.

Produce 2 outputs:

---
**OUTPUT 0 — Non-technical summary** (3-5 sentences, in English)

Goal: let anyone (even a non-dev, or a dev who doesn't know the domain) understand in
20 seconds WHAT the PR does and WHY, before diving into the technical detail.

1. Collect:
   - PR title + description (if PR#N or URL): `gh pr view {N} --json title,body`
   - Otherwise inspect: branch name + latest commits (`git log -10 --oneline`)
     + changed files (list from the step below)
   - If a ticket ID is present (EP-XXXX, OHSET-XXX, etc.) in the title or branch,
     try `mcp__linear__get_issue` to enrich with the ticket's product description.
2. Write 3-5 short sentences, **without technical jargon**, IN ENGLISH (consistent with the
   rest of the report — skeleton, findings, and section titles are all English):
   - Sentence 1: the user/business problem or need the PR addresses.
   - Sentences 2-3: what the PR concretely changes, from the user's or operational point
     of view (not "adds endpoint X" but "lets OH admins see Y in the dashboard").
   - Sentence 4 (optional): expected impact / scope (which country, persona, surface).
   - Avoid: function names, table names, class names, technical patterns. If you MUST
     cite a specific business term, it will be defined right after in the Glossary.
3. If you cannot infer the "why" from the sources above, mark it
   `[to confirm with the PR author]` — do not invent a product motivation.

Format:
> {3-5 sentences of prose, in English, readable by a non-dev}

---
**OUTPUT 1 — Glossary** (3-5 terms)

1. Get the PR diff file list (TARGET = "{TARGET}"):
   - If PR#N or URL → `gh pr diff {N} --name-only`
   - If commit SHA → `git show --name-only {SHA}`
   - If branch (empty TARGET) → `git diff main...HEAD --name-only` then
     `git diff --name-only` for uncommitted
2. Extract 3-5 business/domain terms from: PR title, branch name, modified
   file paths (component names, module names), and function names in the diff.
   Skip generic terms (User, Config, Service).
3. For each term, write ONE sentence defining it based on code context
   (grep the term in README.md files, component docstrings, or type defs).
   If you can't find a definition, mark it `[unverified]` — don't invent.

Format:
- **{TERM}** — {1-sentence definition}. Ref: `path/to/file:line`

---

Write the 2 outputs concatenated in order (Summary → Glossary) to
tmp/agent-scratch/review-all-context.md with the Write tool. Do NOT produce P0-P3
findings — that's not your job.

Do NOT put the outputs in your final message: that would surface them in your completion
notification before the orchestrator is ready to emit the consolidated block. Your final
message must be ONLY this content-free ack (path only, nothing else):

WROTE tmp/agent-scratch/review-all-context.md

Do NOT use AskUserQuestion. Do NOT wait for other subagents (they run in parallel) — just
write your file and return the ack. Remember: nothing leaves this agent until you are
finished — silent throughout, then the ack only.
```

## Step 4.5: Wait — in total silence — for all launched background notifications

Don't poll. The completion notifications of the launched subagents arrive via the runtime.
Know how many you launched (= the count of `SELECTED`) and wait for **exactly that many** to
return — do not wait for 6 if you launched fewer, or the run hangs. When all launched subagents
have returned, proceed to Step 4 (P0-P3 aggregation) then Step 5 (the single consolidated block:
preamble + findings together).

**Capture token + timing data as each notification arrives.** Every subagent's `<task-notification>`
— the 5 reviews AND the Context Walkthrough (subagent 6) — ends with a `<usage>` block in this
exact shape:

```
<usage><subagent_tokens>18622</subagent_tokens><tool_uses>0</tool_uses><duration_ms>1883</duration_ms></usage>
```

Parse the three fields from that block the instant the notification arrives, keyed by source:
- `<subagent_tokens>` → the token count for that subagent (this is the field to sum — NOT
  `total_tokens`, which does not exist in the notification).
- `<duration_ms>` → wall-clock in milliseconds (divide by 1000 for the table's seconds column).
- `<tool_uses>` → number of tool calls (optional, informational).

Record each value in memory immediately so you can report the total in Step 5. This is **silent
bookkeeping**: it does NOT violate the Hard barrier below, which forbids emitting *findings* or
*progress status* — not internal note-taking. The numbers surface only once, in the Step 5
consolidated block. If a notification truly lacks the `<usage>` block, mark that source's tokens
as `n/a` rather than guessing — never invent a count. Note: this total covers the **subagents
only**; the orchestrator's own context-window usage is not exposed to it and is therefore
excluded (state this in the summary).

> **"Record in memory" means produce ZERO output tokens — do not narrate the bookkeeping.**
> "In memory" is literal: as each notification arrives, parse its `<usage>` and move on WITHOUT
> writing a single word. The following are **violations**, even though they feel like harmless
> status:
> - `Context Walkthrough done (2/6). Recording: 100654 tokens, 66s.`
> - `Recording tokens…`, `Captured X/6`, `Staying silent.`
>
> Announcing that you are staying silent is itself breaking silence. There is no "noting"
> turn between notifications: you emit nothing at all until the Step 5 block. Your first output
> token of the entire run is the `## Full review` title.

> **Hard barrier — say nothing until all launched subagents are done, then emit once.** From the
> moment you launch the subagents (Step 3) until the consolidated block (Step 5), stay
> **completely silent**. As long as the launched subagents have not ALL returned, emit **no**
> preamble, **no** finding, and **no** progress status. The entire deliverable — Context preamble
> *and* findings — appears only **once**, as a single block.
>
> **The barrier has two leak channels, not one.** Your own prose is the obvious one. The
> second — easy to miss — is the **agents' return values**: a `run_in_background` agent's
> final message is rendered verbatim in its completion notification, visible in the
> conversation the instant it finishes. Staying silent yourself does nothing about that. The
> file-handoff contract (Step 3) is what closes it: each subagent (including the Context
> Walkthrough) writes its output to a scratch file and returns only a content-free ack, so the
> notifications carry nothing. If a notification ever contains actual content (findings, the
> walkthrough narrative, `file:line`, priorities), that agent ignored the contract — do NOT
> relay it; read the scratch file in Step 4 instead.
>
> Concretely, before the consolidated block the following are **forbidden**:
> - showing the Context preamble early (it now waits for the findings — no exception);
> - pushing an agent's findings the moment it finishes (per-agent output, as it streams in);
> - any status line like "3/6 returned", "waiting for the Architecture & Structure Review", "X has finished";
> - any partial report or visible pre-aggregation.
>
> **Why:** a half-streamed report is noise. Findings shown per-agent as they trickle in are
> neither deduplicated nor prioritized — the reviewer sees the same problem flagged 3 times by
> 3 sources, without the merged `[review + architecture]` badge or the final P0-P3 priority.
> The merge work (Step 4) is precisely what sets this skill apart from a raw fan-out. And the
> preamble, posted early, would fragment the reviewer's attention before the findings even
> arrive. One quiet wait, one complete deliverable, is calmer and more useful — so everything
> waits for the consolidated block.

## Step 4: Aggregate and map the priorities

Only **start** this step once **all launched** subagents have returned (see the Step 4.5
barrier). All the merging below happens in memory, displaying nothing — the first output of any
kind is the consolidated block in Step 5.

**Read every output from the scratch files, not from the agents' acks.** Each subagent wrote to
its `tmp/agent-scratch/review-all-*.md` file (see the Step 3 file-handoff contract); the acks in
the notifications carry only paths. Read the files for the subagents you launched: the **review
files** feed the P0-P3 merge below, and the **Context Walkthrough file** (`review-all-context.md`)
becomes the preamble at the top of Step 5 (it does NOT take part in the P0-P3 aggregation — just
relay it). Subagents not in `SELECTED` wrote no file — that is expected, not a missing source.
If a file from a subagent you **did** launch is missing (it failed to write), note it explicitly
in the Sources line of Step 5 rather than silently dropping that source.

| Aggregated priority | Source | Original priority |
|---|---|---|
| **P0 — Blocking** | `/review` | P0 |
| **P1 — Must fix** | `/review` | P1 |
| | `/lm-local-compliance-review` | P1 (Must fix) |
| | `/lm-reviewer-rules` | P1 |
| | `/lm-hardcore-review` (Architecture & Structure Review) | Structural regression, spaghetti growth, file >1k lines, abstraction-boundary leak, canonical-helper duplication (= "presumptive blocker" per the skill) |
| **P2 — Consider** | `/review` | P2 |
| | `/lm-local-compliance-review` | P2 (Should fix) |
| | `/lm-reviewer-rules` | P2 |
| | `/lm-ux-delight` | Effort = Trivial |
| | `/lm-hardcore-review` (Architecture & Structure Review) | Missed "code judo" simplification, type/boundary cleanliness suggestion, orchestration / non-atomic update flag (without presumptive-blocker) |
| **P3 — Bonus** | `/lm-local-compliance-review` | P3 (Consider) |
| | `/lm-reviewer-rules` | P3 |
| | `/lm-ux-delight` | Effort = Medium |
| | `/lm-hardcore-review` (Architecture & Structure Review) | Legibility / maintainability nit, thin wrapper without major structural impact |

### Merge rules

1. **Deduplicate** — if several sources flag the same `file:line` (same file, lines within
   ±5 of the same spot), keep the most detailed finding and note all sources in the badge:
   `[review + compliance]`, `[architecture + rules]`, etc. The Architecture & Structure Review and the
   code review often overlap on structural topics — merging avoids the duplicate.
2. **Number** — sequential numbers (1, 2, 3...) across all priorities
3. **Tag** — each finding carries a badge: `[review]`, `[compliance]`, `[rules]`,
   `[ux-delight]`, or `[architecture]`

## Step 5: Output everything as one consolidated block

This is the **first and only** thing the reviewer sees. Post it **all at once** — title, then
Context preamble, then findings — in one message. Never stream it finding-by-finding or
source-by-source, and never post the preamble as its own earlier message ahead of the findings
(that was the old behavior; it's gone). The preamble comes from the Context Walkthrough scratch
file (`review-all-context.md`, read in Step 4); the findings come from the merge.

The entire report — Summary, Glossary, findings, skeleton, and section titles — is in English,
for consistency.

```
## Full review — {target}

### 📚 PR context (ramp-up)

**Summary**
{non-technical summary from the Context Walkthrough, 3-5 sentences of prose, in English}

**Glossary**
{glossary list from the Context Walkthrough}

---

### P0 — Blocking
{numbered findings or "None"}

### P1 — Must fix
{numbered findings or "None"}

### P2 — Consider
{numbered findings or "None"}

### P3 — Bonus
{numbered findings or "None"}

---
Sources: /review ({N} findings), /lm-local-compliance-review ({N} findings), /lm-reviewer-rules ({N} findings), /lm-ux-delight ({N} suggestions), Architecture & Structure Review (/lm-hardcore-review) ({N} findings)

> Show only the subagents in `SELECTED`: drop the Sources entries and token-table rows for any
> subagent that was not launched, and append `— {count} of 6 subagents` to the Sources line.

💰 **Token usage (subagents only — orchestrator overhead excluded):**
| Subagent | Tokens | Wall-clock |
|---|---|---|
| Code Review (/review) | {subagent_tokens or n/a} | {duration}s |
| Compliance (/lm-local-compliance-review) | {subagent_tokens or n/a} | {duration}s |
| UX Delight (/lm-ux-delight) | {subagent_tokens or n/a} | {duration}s |
| Reviewer Rules (/lm-reviewer-rules) | {subagent_tokens or n/a} | {duration}s |
| Architecture & Structure (/lm-hardcore-review) | {subagent_tokens or n/a} | {duration}s |
| Context Walkthrough | {subagent_tokens or n/a} | {duration}s |
| **Total** | **{sum} tokens** | — |

---
**Actions?** Type a number to dig deeper, "fix all P0-P1" to fix the urgent ones,
"fix N" for a specific fix, or "done" to finish.
```

When summing the **Total**, skip any source marked `n/a` and add a `({k}/6 reported)` note next
to the total so a partial measurement is not mistaken for the full cost.

### Format of each finding

```
**{N}. [{source}] {short title}**
**File:** [`path/to/file:line`](path/to/file#Lline)
{description — 1-2 sentences max}
{Learn section if source = compliance}
{Fix: snippet, 3 lines max, if applicable}
```

### "No problem detected" case

If every launched review scratch file says "No issues found" / "No suggestions.", still emit the
full block — title + Context preamble (if Context Walkthrough was selected; it has ramp-up value
on its own) — and replace the P0-P3 sections with:

```
No problems detected by the automated reviews.
```

No compliment. Silence is approval. Still append the **Token usage** table (same format as
Step 5) below this line — the cost summary is reported on every run, findings or not.

## Step 6: Interactive mode

### A number (e.g. "3")
- Source `[compliance]` → show the extended Learn examples (3-5 files with the right pattern)
- Source `[review]` → show the detailed trigger and root cause
- Source `[ux-delight]` → show the pattern catalog and the detailed effort
- Source `[architecture]` → show the full "preferred remedy" (delete a layer, reframe state, extract helper, split file, move to canonical layer) and the structural rationale

### "fix all P0-P1"
1. Apply the P0 fixes automatically
2. For each P1, show the change and ask for confirmation
3. After the fixes, re-run formatters/linters on the changed files

### "fix N"
Apply the specific fix, show the change.

### "done"
End the review.
