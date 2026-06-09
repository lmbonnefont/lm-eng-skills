---
name: lm-review-all
description: >
  Full review of a PR: runs /review (bugs, quality, tests), /lm-local-compliance-review
  (conventions, ruler rules), /lm-ux-delight (UX micro-improvements), /lm-reviewer-rules
  (rules extracted from Bastien Landre & Mickaël Berguem's reviews), /lm-hardcore-review
  as the Architecture & Structure Review (abstractions, modularity, code judo, spaghetti)
  in parallel, plus a 6th Context Walkthrough agent that produces a non-technical summary +
  glossary + flow via /lm-flow-walkthrough, shown as a preamble before the findings.
  Aggregates findings into a P0-P3 report with source badges. Use when: /lm-review-all,
  "revue complète", "full review", "review everything", "all reviews on PR #123",
  "lance toutes les revues", or any request to run several reviews on the same changes.
  Also use when the user asks for an in-depth review before merge or before requesting a
  human review.
---

# Full Review (orchestrated)

Launches 6 subagents in parallel: 5 reviews (`/review`, `/lm-local-compliance-review`,
`/lm-ux-delight`, `/lm-reviewer-rules`, `/lm-hardcore-review` — the Architecture & Structure Review) in the
background + 1 Context Walkthrough (glossary + flow) in the foreground.
The walkthrough is shown as soon as it finishes, **before** aggregating the findings, so
the reviewer can start reading the context while the reviews are still running.

The findings are then merged into a single report ranked by priority. Each finding cites
its origin and includes `file:line` references.

This skill **orchestrates** — it does not review by itself. It delegates, aggregates, deduplicates.

## Usage

- `/lm-review-all` — auto-detect (current branch, uncommitted changes, last commit)
- `/lm-review-all PR#123` or `/lm-review-all https://github.com/.../pull/123` — specific PR
- `/lm-review-all abc123f` — specific commit
- `full review` / `revue complète` / `review everything` — natural-language trigger

## Step 1: Determine the target

Use `$ARGUMENTS` if provided, otherwise auto-detect:

1. **PR number/URL in the args** → store as `TARGET` (e.g. `PR#123`)
2. **Commit SHA in the args** → store as `TARGET`
3. **On a feature branch** (not `main`) → `TARGET` = current branch (the sub-skills auto-detect)
4. **Uncommitted changes** → `TARGET` = empty (the sub-skills auto-detect)
5. **Fallback** → `TARGET` = empty

Also extract the **ticket ID** from the branch or PR title (pattern `EP-XXXX`, `OHSET-XXX`,
`SIM-XXXX`, etc.) for `/lm-ux-delight`.

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

## Step 2: Prepare the UX Delight context

`/lm-ux-delight` works best from a checkpoint, not a PR.

1. If a ticket ID was found → check whether `.claude/plans/feature-checkpoint-{ticket-id}*.md` exists
2. **If a checkpoint is found** → pass the ticket ID to the UX Delight subagent
3. **If no checkpoint** → the UX Delight subagent is instructed to analyze the PR's changed files
   to identify UX opportunities (degraded mode, less precise but still useful)

## Step 3: Launch the 6 subagents in parallel (asymmetric orchestration)

**The walkthrough must not block the findings, and the Context preamble in particular
must be shown before the reviews are finished.**

In **a single message**, launch:

- Subagent 1 (Code Review) with `run_in_background: true`
- Subagent 2 (Compliance Review) with `run_in_background: true`
- Subagent 3 (UX Delight) with `run_in_background: true`
- Subagent 4 (Reviewer Rules) with `run_in_background: true`
- Subagent 5 (Architecture & Structure Review) with `run_in_background: true`
- Subagent 6 (Context Walkthrough) **in the foreground** (no `run_in_background`,
  or `run_in_background: false`)

Behavior: the message blocks only on the walkthrough. As soon as it returns, go straight
to **Step 4.4** (show the preamble). The 5 reviews keep running in the background; their
completion notifications arrive later — each carries only a content-free ack (the findings
live in a scratch file, see the file-handoff contract below) — and trigger Step 4
(aggregation) + Step 5 (findings).

**IMPORTANT**: no subagent must interact with the user. No `AskUserQuestion`, no interactive
mode. The 5 review subagents write their report to a scratch file and return only a
content-free ack; subagent 6 (foreground) returns its narrative inline because it feeds the
preamble.

### File-handoff contract (closes the per-agent findings leak)

A `run_in_background` agent's **return value is rendered verbatim in its completion
notification** — which is visible in the conversation the moment that agent finishes. So if a
review's findings travel in its return value, the reviewer sees them per-agent, un-deduplicated
and un-prioritized, *before* the aggregation in Step 4. That is precisely the noise the Hard
barrier (Step 4.5) exists to prevent, and the orchestrator staying silent in its own prose is
**not enough** to stop it — the leak comes from the agents' payloads, not the orchestrator.

The fix: route each review's report through a file, so the notification stays content-free.
Each of the **5 review subagents** (NOT subagent 6) writes its full report with the Write tool
to a dedicated scratch file, then returns only a one-line ack containing the path:

| Source | Scratch file |
|---|---|
| `/review` | `tmp/agent-scratch/review-all-review.md` |
| `/lm-local-compliance-review` | `tmp/agent-scratch/review-all-compliance.md` |
| `/lm-ux-delight` | `tmp/agent-scratch/review-all-ux-delight.md` |
| `/lm-reviewer-rules` | `tmp/agent-scratch/review-all-rules.md` |
| `/lm-hardcore-review` (Architecture & Structure Review) | `tmp/agent-scratch/review-all-architecture.md` |

The ack must contain the **path only** — no titles, no `file:line`, no priorities, not even a
finding count (a count is still a status leak the barrier forbids). A review that finds nothing
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
```

### Subagent 6: Context Walkthrough (summary + glossary + flow)

The 6th subagent runs **in parallel with the other 5 in the same Agent message**, but in
the **foreground** (the other 5 are `run_in_background: true`). Its result feeds the report
preamble (Step 4.4) and does not take part in the P0-P3 aggregation.

Subagent prompt:

```
PR scope — the ONLY files changed in this PR:
{DIFF_FILES}

Scope your outputs strictly to these files. The summary, glossary, and walkthroughs must
only describe what these files do. Do not mention or describe files outside this list.
This is especially important for the summary: if a file appears on the branch but is NOT
in DIFF_FILES, it is not part of this PR and must not appear in any output.

You are building ramp-up context for a PR reviewer. Do NOT review code quality —
that is other subagents' job. Your job: help the reviewer understand WHAT the PR
touches and HOW the current code works.

Produce 3 outputs:

---
**OUTPUT 0 — Non-technical summary** (3-5 sentences, in French)

Goal: let anyone (even a non-dev, or a dev who doesn't know the domain) understand in
20 seconds WHAT the PR does and WHY, before diving into the technical detail.

1. Collect:
   - PR title + description (if PR#N or URL): `gh pr view {N} --json title,body`
   - Otherwise inspect: branch name + latest commits (`git log -10 --oneline`)
     + changed files (list from the step below)
   - If a ticket ID is present (EP-XXXX, OHSET-XXX, etc.) in the title or branch,
     try `mcp__linear__get_issue` to enrich with the ticket's product description.
2. Write 3-5 short sentences, **without technical jargon**, IN FRENCH (this deliverable
   is for French-speaking, often non-dev readers — keep the prose French even though the
   rest of these instructions are in English):
   - Sentence 1: the user/business problem or need the PR addresses.
   - Sentences 2-3: what the PR concretely changes, from the user's or operational point
     of view (not "adds endpoint X" but "lets OH admins see Y in the dashboard").
   - Sentence 4 (optional): expected impact / scope (which country, persona, surface).
   - Avoid: function names, table names, class names, technical patterns. If you MUST
     cite a specific business term, it will be defined right after in the Glossary.
3. If you cannot infer the "why" from the sources above, mark it
   `[to confirm with the PR author]` — do not invent a product motivation.

Format:
> {3-5 sentences of prose, in French, readable by a non-dev}

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
**OUTPUT 2 — Walkthroughs** (scope PR-only)

1. From the diff file list, list every modified function/component that could
   START a flow:
   - Backend: files under `**/controllers/**`, `**/public/**` — each modified function
   - Frontend: files under `**/screens/**`, `**/hooks/**`, `**/src/pages/**` — each
     modified exported function/component
   - Ignore: tests, migrations, `__pycache__`, generated files, `.ruler/`
   This is a list of *candidates*, NOT the final entry-point list — go to step 1b.
1b. **Collapse chained candidates into independent flows.** An entry point is the
   ROOT of an *independent* flow, not merely "a modified function". Many PRs modify
   several functions that are actually different stages of ONE flow (A calls B, B
   calls C — A→B→C). In that case there is **one** entry point (A); B and C are
   internal steps of A's flow, not separate entry points.
   - Trace the call relationships between the candidates from step 1 (grep each
     candidate's name across the other modified files; read the diff to see who calls whom).
   - Whenever candidate X is reached (directly or transitively) from another candidate Y,
     X is NOT an entry point — it is a step inside Y's flow. Drop it from the entry-point
     list and remember to surface it as a hop *within* Y's walkthrough.
   - The final entry-point list contains only flow ROOTS: candidates that no other
     candidate calls. Two entry points are distinct only if neither reaches the other.
   - **Why this matters:** presenting "3 entry points" when the 3 functions are one
     chained flow is actively misleading — it tells the reviewer there are 3 independent
     surfaces to understand when there is really 1. Count and present *independent flows*,
     not touched functions.
2. Keep in memory the **SET of modified files** (from step 1 of OUTPUT 1).
   This set = "PR scope". Files outside this set = "out of scope".
3. For EACH entry point found, invoke `/lm-flow-walkthrough` in caller mode:

   Call: Skill(skill: "lm-flow-walkthrough", args: "--caller {file}:{function}")

   The skill returns both a JSON blob and a human-readable output. Keep only
   the human-readable narrative (Section A call chain + Section B evidence
   trace) — drop the JSON.
4. **Trim the narrative before returning it**:
   - For hops / call chain steps pointing to files **IN PR scope** → keep
     the detailed explanation as returned by the skill (rules, edge cases,
     deep dive).
   - For hops pointing to files **OUT of PR scope** → replace detailed
     explanation with a one-liner narrative + clickable `file:line`.
     Example: `→ calls get_subscriber_establishments in
     [establishments.py:18](backend/.../establishments.py#L18) (out of PR
     scope, not detailed).`
   - Drop `[GAP]` markers that land on out-of-scope files (noise for
     ramp-up of THIS PR).
5. If the list has more than 5 entry points, trace the top 5 by "centrality"
   (controllers before utils, new files before modified, bigger diffs first)
   and add a note: "N-5 more entry points not traced — ask if needed."

Return the 3 outputs concatenated in order (Summary → Glossary → Walkthroughs).
Do NOT use AskUserQuestion. Do NOT wait for other subagents. Do NOT produce P0-P3
findings — that's not your job.
```

## Step 4.4: Show the context preamble as soon as the walkthrough is ready

Subagent 6 (foreground) returns `Summary` + `Glossary` + `Walkthroughs`.
**Show this block immediately** to the user, without waiting for the 5 background reviews.
The Summary comes **first**: it's the non-technical angle that aligns the reviewer on the
"why" before diving into the "how".

Note: the Summary text itself is produced in French (it's the user-facing artifact, written
for French-speaking, often non-dev readers); the report skeleton and section titles below are
in English.

```
## Full review — {target}

### 📚 PR context (ramp-up)

**Summary**
{non-technical summary from subagent 6, 3-5 sentences of prose}

**Glossary**
{glossary list from subagent 6}

**Walkthroughs**
{walkthroughs from subagent 6, one per independent flow}

---
_Reviews running in the background (/review, /lm-local-compliance-review, /lm-ux-delight, /lm-reviewer-rules, Architecture & Structure Review)..._
```

No merge/dedup, no re-prioritization. Plain relay.

## Step 4.5: Wait for the background notifications

Don't poll. The completion notifications of the 5 subagents arrive via the runtime.
When all have returned, proceed to Step 4 (P0-P3 aggregation) then Step 5 (showing the
findings under the already-posted preamble).

> **Hard barrier — aggregate first, emit once.** Between the preamble (Step 4.4, already
> posted) and the consolidated findings block (Step 5), stay **completely silent**. As long
> as the 5 review subagents have not ALL returned, emit **no** finding and **no** progress
> status. A PR's findings appear only **once**, as a fully aggregated + deduplicated P0-P3
> block.
>
> **The barrier has two leak channels, not one.** Your own prose is the obvious one. The
> second — easy to miss — is the **agents' return values**: a `run_in_background` agent's
> final message is rendered verbatim in its completion notification, visible in the
> conversation the instant it finishes. Staying silent yourself does nothing about that. The
> file-handoff contract (Step 3) is what closes it: each review writes its report to a scratch
> file and returns only a content-free ack, so the notifications carry no findings. If a
> notification ever contains actual findings (titles, `file:line`, priorities), the agent
> ignored the contract — do NOT relay it; read the scratch file in Step 4 instead.
>
> Concretely, between the preamble and the final block the following are **forbidden**:
> - pushing an agent's findings the moment it finishes (per-agent output, as it streams in);
> - any status line like "3/5 returned", "waiting for the Architecture & Structure Review", "X has finished";
> - any partial report or visible pre-aggregation.
>
> **Why:** findings shown per-agent as they trickle in are neither deduplicated nor
> prioritized — the reviewer sees the same problem flagged 3 times by 3 sources, without
> the merged `[review + architecture]` badge or the final P0-P3 priority. The merge work (Step 4)
> is precisely what sets this skill apart from a raw fan-out. Emitting before the merge
> destroys that value and produces a noisy, misleading report. The early preamble, however,
> stays useful (ramp-up context independent of the findings) — it is the only output allowed
> before the consolidated block.

## Step 4: Aggregate and map the priorities

Only **start** this step once the **5** review subagents have returned (see the Step 4.5
barrier). All the merging below happens in memory, displaying nothing — the first findings
output is the consolidated block in Step 5.

**Read the findings from the scratch files, not from the agents' acks.** Each review wrote its
report to its `tmp/agent-scratch/review-all-*.md` file (see the Step 3 file-handoff contract);
the acks in the notifications carry only paths. Read all 5 files, then merge per this table.
If a file is missing (an agent failed to write it), note it explicitly in the Sources line of
Step 5 rather than silently dropping that source.

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

## Step 5: Output the findings (under the preamble)

The Context PR preamble was already posted in Step 4.4. Step 5 shows **only** the findings
sections, as **a single consolidated block** posted at once under the preamble (never
finding-by-finding nor source-by-source). Do not re-render the `## Full review — {target}`
title nor the Context section.

```
### P0 — Blocking
{numbered findings or "None"}

### P1 — Must fix
{numbered findings or "None"}

### P2 — Consider
{numbered findings or "None"}

### P3 — Bonus
{numbered findings or "None"}

---
Sources: /review ({N} findings), /lm-local-compliance-review ({N} findings), /lm-reviewer-rules ({N} findings), /lm-ux-delight ({N} suggestions), Architecture & Structure Review (/lm-hardcore-review) ({N} findings), /lm-flow-walkthrough ({N_flows} independent flows)

---
**Actions?** Type a number to dig deeper, "fix all P0-P1" to fix the urgent ones,
"fix N" for a specific fix, or "done" to finish.
```

### Format of each finding

```
**{N}. [{source}] {short title}**
**File:** [`path/to/file:line`](path/to/file#Lline)
{description — 1-2 sentences max}
{Learn section if source = compliance}
{Fix: snippet, 3 lines max, if applicable}
```

### "No problem detected" case

If all 5 scratch files say "No issues found" / "No suggestions.", still show the Context PR
preamble (already posted in Step 4.4 — it has ramp-up value on its own), then:

```
No problems detected by the automated reviews.
```

No compliment. Silence is approval.

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
