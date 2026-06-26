---
name: lm-review-all
model: sonnet  # orchestration only (read scratch, dedup, format) — subagents keep their own model via the table below
description: >
  Full review of a PR: runs /review (bugs, quality, tests), /lm-local-compliance-review
  (conventions, ruler rules), /lm-ux-delight (UX micro-improvements), /lm-reviewer-rules
  (rules extracted from Bastien Landre & Mickaël Berguem's reviews), /lm-hardcore-review
  as the Architecture & Structure Review (abstractions, modularity, code judo, spaghetti)
  in parallel, plus a 6th Context Walkthrough agent that produces a non-technical summary,
  glossary, and a layer-grouped file-by-file walkthrough, shown as a preamble before the findings.
  Aggregates findings into a P0-P3 report with source badges. Use when: /lm-review-all,
  "revue complète", "full review", "review everything", "all reviews on PR #123",
  "lance toutes les revues", or any request to run several reviews on the same changes.
  Also use when the user asks for an in-depth review before merge or before requesting a
  human review.
---

# Full Review (orchestrated)

This skill **orchestrates** — it never reviews by itself. It delegates to a subset of 6
subagents you pick, aggregates their findings, deduplicates, and emits **one** consolidated
block: a Context preamble (summary + glossary + file-by-file walkthrough) followed by P0-P3
findings with source badges.

The subagents (any subset, picked in Step 2):

| # | Subagent | Skill it runs | Lane | `model` |
|---|---|---|---|---|
| 1 | Code Review | `/review` | bugs, quality, tests | `opus` |
| 2 | Compliance | `/lm-local-compliance-review` | conventions, ruler rules | `sonnet` |
| 3 | UX Delight | `/lm-ux-delight` | UX micro-improvements (frontend) | `sonnet` |
| 4 | Reviewer Rules | `/lm-reviewer-rules` | Bastien & Mickaël's patterns | `sonnet` |
| 5 | Architecture & Structure | `/lm-hardcore-review` | abstractions, modularity, spaghetti | `sonnet` |
| 6 | Context Walkthrough | (no skill) | summary + glossary + file-by-file walkthrough | `sonnet` |

Model tiering (benchmarked opus-vs-sonnet on PR #97925, 2026-06-22): only **Code Review** (the
bug lane) runs on `opus`. The other five run on `sonnet` — the benchmark showed sonnet matched
opus on compliance/rules/architecture/UX at ~⅓–¾ the tokens with no false positives, but on the
bug lane it emitted a confidently-wrong false-positive P1 (inverted a Python import/mock rule), so
`/review` stays on `opus`. The orchestrator itself also runs on `sonnet` (frontmatter `model:`) —
it only reads scratch files, dedups, and formats. Subagent 5 is **behavior-preserving**
maintainability review (structure, simplification, codebase health) — not runtime bugs or test
coverage; those are Subagent 1's lane.

## The silence barrier (the core contract — read once, applies everywhere)

**From launch (Step 3) until the consolidated block (Step 5), the run is completely silent.**
Nothing reaches the reviewer until *every launched subagent* has finished — not findings, not a
status line ("3/6 done", "waiting for X"), not the Context preamble, not "staying silent" itself.
Your first output token of the entire run is the `## Full review` title in Step 5.

**Why:** a half-streamed report is noise. Findings shown per-agent as they trickle in are neither
deduplicated nor prioritized — the reviewer sees the same problem flagged 3× by 3 sources, with
no merged badge and no final P0-P3 priority. The merge (Step 4) is exactly what sets this skill
apart from a raw fan-out. One quiet wait, one complete deliverable, is calmer and more useful.

**The barrier has two leak channels, not one:**
1. *Your own prose* — obvious; just stay silent.
2. *The agents' return values* — a `run_in_background` agent's final message is rendered verbatim
   in its completion notification, visible the instant it finishes. Staying silent yourself does
   nothing about this. The fix is the **file-handoff contract**: every subagent writes its full
   output to a scratch file and returns only a content-free ack (the path), so notifications carry
   nothing. If a notification ever contains real content (findings, narrative, `file:line`), that
   agent ignored the contract — do NOT relay it; read its scratch file in Step 4 instead.

Capturing token/timing from notifications (Step 4.5) is silent bookkeeping — it produces **zero**
output tokens and does not break the barrier.

## Usage

- `/lm-review-all` — auto-detect (current branch, uncommitted changes, last commit)
- `/lm-review-all PR#123` or a PR URL — specific PR
- `/lm-review-all abc123f` — specific commit
- `full review` / `revue complète` / `review everything` — natural-language trigger

**Token cost.** All 6 ≈ 6 subagents × ~80k tokens. Untick subagents at the Step 2 prompt to cut
cost (dropping Reviewer Rules + UX Delight saves ~30%); model tiering is always on.

## Step 1: Determine the target

Use `$ARGUMENTS` if provided, else auto-detect into `TARGET`:

1. PR number/URL in args → `TARGET` = e.g. `PR#123`
2. Commit SHA in args → `TARGET` = the SHA
3. On a feature branch (not `main`) → `TARGET` = current branch (sub-skills auto-detect)
4. Uncommitted changes / fallback → `TARGET` = empty (sub-skills auto-detect)

Also extract the **ticket ID** from the branch or PR title (`EP-XXXX`, `OHSET-XXX`, `SIM-XXXX`…)
for `/lm-ux-delight`. The set of subagents (`SELECTED`) is NOT derived from args — it is asked in
Step 2.

## Step 1.5: Pre-compute the PR scope (DIFF_FILES)

Before launching, compute the exact list of files changed by the target — the single source of
truth on the PR's perimeter, injected into every subagent prompt.

- PR (number/URL) → `gh pr diff {PR_NUMBER} --name-only`
- Commit SHA → `git show --name-only --format="" {SHA}`
- Branch or empty → `git diff main...HEAD --name-only`

Store as `DIFF_FILES` (one path per line).

> **Why critical:** without explicit scope, each subagent auto-scopes onto the whole branch or
> repo and produces findings about files absent from the diff, polluting the report.

## Step 2: Ask which subagents to launch

**Always ask — no flag, no default set.** This is the **only** interactive moment in the run.
**Do NOT use `AskUserQuestion`** (its 4-option cap can't show all 6). Print this menu as a normal
message and wait for the reply:

```
Which subagents do you want to launch? Reply with numbers (e.g. `1 3 6`), `all`, or names.

1. Code Review — /review (bugs, quality, tests)
2. Compliance — /lm-local-compliance-review (conventions, ruler rules)
3. UX Delight — /lm-ux-delight (UX micro-improvements, frontend PRs)
4. Reviewer Rules — /lm-reviewer-rules (Bastien & Mickaël's review patterns)
5. Architecture & Structure — /lm-hardcore-review (abstractions, modularity, spaghetti)
6. Context Walkthrough — summary + glossary + file-by-file walkthrough preamble (cheap, on sonnet)
```

The menu numbers are the **same** as the top table and the Subagent N sections below — one
scheme everywhere, so `1 2 5` always means the same three subagents.

Parse the reply into `SELECTED`:
- `all` or empty reply → all 6.
- numbers and/or names → exactly those.
- a clear decline / nothing valid → launch nothing, say so, stop.

Everything downstream keys off `SELECTED`: the launch (Step 3), the barrier count (Step 4.5),
which scratch files to read (Step 4), and which rows appear in the Sources line + token table
(Step 5). A subagent not in `SELECTED` is simply absent — not a missing source. After the user
replies, the run goes silent until Step 5.

## Step 2.5: Prepare the UX Delight context

Skip entirely if UX Delight is not in `SELECTED`. `/lm-ux-delight` works best from a checkpoint:

1. If a ticket ID was found → check whether `.claude/plans/feature-checkpoint-{ticket-id}*.md` exists.
2. Checkpoint found → pass the ticket ID to the UX Delight subagent (use the checkpoint prompt).
3. No checkpoint → use the degraded-mode prompt (analyze changed frontend files directly).

## Step 3: Launch the subagents in parallel

In **a single message**, launch **only the subagents in `SELECTED`** with `run_in_background: true`
and the `model` from the table at the top. They run concurrently, each writing its output to its
scratch file and returning a content-free ack; their notifications arrive over time. Stay silent
(see the barrier above) until **all launched** subagents return, then go to Step 4 → Step 5.

**Scratch files (file-handoff contract):**

| Source | Scratch file |
|---|---|
| `/review` | `tmp/agent-scratch/review-all-review.md` |
| `/lm-local-compliance-review` | `tmp/agent-scratch/review-all-compliance.md` |
| `/lm-ux-delight` | `tmp/agent-scratch/review-all-ux-delight.md` |
| `/lm-reviewer-rules` | `tmp/agent-scratch/review-all-rules.md` |
| `/lm-hardcore-review` (Architecture & Structure) | `tmp/agent-scratch/review-all-architecture.md` |
| Context Walkthrough | `tmp/agent-scratch/review-all-context.md` |

### Shared subagent prompt template

Subagents 1, 2, 4, 5 use this template verbatim — fill `{INVOKE}`, `{REPORT}`, `{SCRATCH}` from
the table below. Subagents 3 and 6 use it as a base but replace the body with their own spec
(see the two boxes after the table).

```
PR scope — the ONLY files changed in this PR:
{DIFF_FILES}

Scope your analysis strictly to these files. Do not analyze, mention, or claim anything about
files outside this list. If a skill you invoke returns findings on other files, discard them.

{INVOKE}

Write {REPORT} to {SCRATCH} with the Write tool. Do not summarize or rephrase; every finding
keeps its file:line. If the skill finds nothing, write "No issues found." into the file.

Your final message must be ONLY this content-free ack — no titles, file:line, priorities, or a
count (a count is itself a status leak): WROTE {SCRATCH}
Putting content in your message would surface it in your completion notification before the
orchestrator aggregates. Do NOT use AskUserQuestion. Work silently: no narration, plan, progress,
or "the file already has content…" notes. Write the file, return the ack — nothing else.
```

| # | `{INVOKE}` | `{REPORT}` |
|---|---|---|
| 1 | `You MUST use the Skill tool: Skill(skill: "review", args: "{TARGET}"). Do NOT review yourself.` | the full structured report (P0, P1, P2 sections) |
| 2 | `You MUST use the Skill tool: Skill(skill: "lm-local-compliance-review", args: "{TARGET}"). Do NOT review conventions yourself.` | the full structured report (P1, P2, P3) with Learn sections |
| 4 | `You MUST use the Skill tool: Skill(skill: "lm-reviewer-rules", args: "{TARGET}"). Do NOT apply rules yourself.` | the full report (P1, P2, P3), each finding citing the source PR link |
| 5 | `You MUST use the Skill tool: Skill(skill: "lm-hardcore-review", args: "{TARGET}"). Do NOT review yourself.` | the full findings, each with file:line and a clear "preferred remedy" (delete a layer, reframe state, extract helper, split file, move to canonical layer) |

For Subagent 5, `/lm-hardcore-review` may conclude "PR meets the approval bar" instead of "No
issues found." — treat that as the no-issues case (write it into the file).

### Subagent 3: UX Delight (replaces `{INVOKE}` + body)

**If a checkpoint was found** (Step 2.5): `{INVOKE}` = `You MUST use the Skill tool:
Skill(skill: "lm-ux-delight", args: "{ticket_id}"). Do NOT analyze UX yourself. Do not modify the
checkpoint.` `{REPORT}` = `the full list of recommendations`. `{SCRATCH}` =
`tmp/agent-scratch/review-all-ux-delight.md`.

**If no checkpoint** — same wrapper, but body: `Call Skill(skill: "lm-ux-delight") (it auto-detects
the branch; if it asks for a ticket ID via AskUserQuestion, answer with the branch name). If it
cannot proceed, then — and ONLY then — analyze the changed frontend files from the PR scope for
3-5 UX opportunities (fewer clicks, smarter defaults, direct outcome links), each with: short
title, What (1 sentence), Effort (Trivial/Medium), File (a file:line in DIFF_FILES). Write "No
suggestions." if none.`

### Subagent 6: Context Walkthrough (replaces body — produces the preamble, not P0-P3 findings)

Same wrapper, but **replace the template's middle "Write {REPORT}…" line** with the body below
(this agent runs no skill, has no "findings", and produces no P0-P3 output — so the
finding-centric write line doesn't apply). Keep only the scope clause, the ack-only rule, and the
silence rule. End the body with: `Write the 3 outputs (Summary → Glossary → Walkthrough) to
tmp/agent-scratch/review-all-context.md with the Write tool.` Body:

```
You are building ramp-up context for a PR reviewer. Do NOT review code quality — help the
reviewer understand WHAT the PR touches. Produce 3 outputs, concatenated in order, IN ENGLISH:

OUTPUT 0 — Non-technical summary (3-5 sentences of prose, no technical jargon):
- Collect: `gh pr view {N} --json title,body` (if PR), else branch name + `git log -10 --oneline`
  + the changed-file list. If a ticket ID is present, try `mcp__linear__get_issue` to enrich.
- Sentence 1: the user/business problem the PR addresses. Sentences 2-3: what it concretely
  changes from the user's/operational view ("lets OH admins see Y", not "adds endpoint X").
  Sentence 4 (optional): impact/scope (country, persona, surface). Avoid function/table/class
  names. If you can't infer the "why", mark it [to confirm with the PR author] — don't invent.

OUTPUT 1 — Glossary (3-5 business/domain terms from PR title, branch, file paths, diff function
names; skip generic terms like User/Config/Service). For each, ONE sentence defined from code
context (grep READMEs, docstrings, type defs). Format: **{TERM}** — {definition}. Ref: `file:line`.
If you can't find a definition, mark [unverified] — don't invent.

OUTPUT 2 — File-by-file walkthrough (the ramp-up centerpiece: it lets the reviewer read the diff
in the order the data flows, not alphabetically — so each file builds on the previous one).
- Group the DIFF_FILES by **architectural layer** and present the layers in **dependency order**
  (the order to open them so the change explains itself), not the order `git` lists them.
  - Backend (Alan layered monolith) canonical order: types → enums → business logic (write, then
    read) → dependency / DB → public surface (re-exports, public queries) → controller / blueprint
    → wiring (bootstrap, conftest, blueprint registration) → tests.
  - Frontend: types/schemas → API hooks → state/store → components → screens → routes → tests.
  - If the PR fits neither, infer the layers from the paths; the goal is "open in this order and it
    builds on itself". Put anything you can't place under a final "Other" group.
- For each file: ONE short narrative line — what changed and its **role in the flow** ("writes the
  subscription row", "re-exports the action across the component boundary") — NOT a line-by-line
  restatement of the diff. Link the file and its key new symbol(s) as `file:line` (grep the file
  for the symbol's line); prefer linking the symbol over the bare file. Flag the file with a ⚠️ +
  the finding number if a review lane flagged it — but you don't have the findings, so instead just
  note non-obvious risk you can see from the code itself in ≤8 words (e.g. "dead code — no caller").
- Collapse purely mechanical files — blueprint registration, re-exports, test-registration, a lone
  blank-line change — into a single grouped bullet or a 3-column table, not one entry each. A wiring
  line doesn't deserve a paragraph; the reviewer needs the shape, not the boilerplate.
- End with one or two **mental-map flow diagrams**: a tiny ASCII call chain for the PR's main
  path(s), each hop a `file:line`, so the reviewer sees how the layers connect. Example:
    POST /siret_contract  [siret_contract.py:96]
      └─ create_siret_level_contract  [actions.py:66]
           ├─ _initialize_…  (writes the subscription row)  [actions.py:169]
           └─ get_company_id_from_siret → publishes 2 events  [dependencies:245]
- Stay strictly within DIFF_FILES. For a large diff (>25 files), keep one line per file but lean
  hard on the grouped-table collapse so the section stays scannable, not a wall.
```

## Step 4.5: Wait silently for all launched notifications

Don't poll — completion notifications arrive via the runtime. Wait for **exactly** `count(SELECTED)`
to return (not 6 if you launched fewer, or the run hangs), then go to Step 4.

**Capture token + timing as each notification arrives** (silent bookkeeping — zero output). Each
`<task-notification>` ends with:

```
<usage><subagent_tokens>18622</subagent_tokens><tool_uses>0</tool_uses><duration_ms>1883</duration_ms></usage>
```

Record per source: `<subagent_tokens>` (the field to sum — NOT `total_tokens`, which does not
exist), `<duration_ms>` (÷1000 for the seconds column), `<tool_uses>` (informational). If a
notification lacks `<usage>`, mark that source `n/a` — never guess. This total covers subagents
only; the orchestrator's own context usage is not exposed and is excluded (state this in Step 5).

## Step 4: Aggregate and map priorities

Start only once **all launched** subagents return. Read every output **from the scratch files**,
not the acks (acks carry only paths). The review files feed the P0-P3 merge; the Context
Walkthrough file becomes the Step 5 preamble (it does NOT take part in aggregation — just relay
it). A subagent not in `SELECTED` wrote no file — expected. A launched subagent whose file is
missing (failed to write) → note it explicitly in the Step 5 Sources line, don't silently drop it.

| Aggregated priority | Source → original priority |
|---|---|
| **P0 — Blocking** | `/review` P0 |
| **P1 — Must fix** | `/review` P1 · `/lm-local-compliance-review` P1 · `/lm-reviewer-rules` P1 · `/lm-hardcore-review`: structural regression, spaghetti growth, file >1k lines, abstraction-boundary leak, canonical-helper duplication ("presumptive blocker") |
| **P2 — Consider** | `/review` P2 · `/lm-local-compliance-review` P2 · `/lm-reviewer-rules` P2 · `/lm-ux-delight` Effort=Trivial · `/lm-hardcore-review`: missed "code judo", type/boundary cleanup, non-atomic/sequential-orchestration flag (no presumptive-blocker) |
| **P3 — Bonus** | `/lm-local-compliance-review` P3 · `/lm-reviewer-rules` P3 · `/lm-ux-delight` Effort=Medium · `/lm-hardcore-review`: legibility/maintainability nit, thin wrapper |

**Merge rules:**
1. **Deduplicate** — same `file:line` (±5 lines) from several sources → keep the most detailed
   finding, list all sources in the badge: `[review + compliance]`, `[architecture + rules]`.
   Architecture & code review often overlap on structure — merging avoids the duplicate.
2. **Number** sequentially (1, 2, 3…) across all priorities.
3. **Tag** each finding: `[review]`, `[compliance]`, `[rules]`, `[ux-delight]`, `[architecture]`.

## Step 5: Output everything as one consolidated block

The **first and only** thing the reviewer sees — post it all at once (title → preamble →
findings), never streamed. Entire report is in English. Drop Sources/token rows for any subagent
not in `SELECTED` and append `— {count} of 6 subagents` to the Sources line.

```
## Full review — {target}

### 📚 PR context (ramp-up)

**Summary**
{non-technical summary from the Context Walkthrough, 3-5 sentences}

**Glossary**
{glossary list from the Context Walkthrough}

**File-by-file walkthrough**
{the layer-grouped walkthrough + mental-map flow diagram(s) from the Context Walkthrough, verbatim}

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
Sources: /review ({N} findings), /lm-local-compliance-review ({N}), /lm-reviewer-rules ({N}), /lm-ux-delight ({N} suggestions), Architecture & Structure (/lm-hardcore-review) ({N})

💰 **Token usage (subagents only — orchestrator overhead excluded):**
| Subagent | Tokens | Wall-clock |
|---|---|---|
| Code Review (/review) | {subagent_tokens or n/a} | {duration}s |
| Compliance (/lm-local-compliance-review) | {…} | {…}s |
| UX Delight (/lm-ux-delight) | {…} | {…}s |
| Reviewer Rules (/lm-reviewer-rules) | {…} | {…}s |
| Architecture & Structure (/lm-hardcore-review) | {…} | {…}s |
| Context Walkthrough | {…} | {…}s |
| **Total** | **{sum} tokens** | — |

---
**Actions?** Type a number to dig deeper, "fix all P0-P1" to fix the urgent ones,
"fix N" for a specific fix, or "done" to finish.
```

When summing **Total**, skip `n/a` sources and append `({k}/6 reported)` so a partial measurement
isn't mistaken for full cost.

**Format of each finding.** Keep it scannable: terse bullets, no prose paragraphs, a blank line
and a `---` spacer between findings so each one reads as its own card.

```
**{N}. [{source}] {short title}**
[`file:line`](path/to/file#Lline)

- **Issue:** {what's wrong — ≤15 words}
- **Why:** {impact or risk — ≤15 words}
- **Fix:** {the change in one line, or a ≤3-line snippet below}
- **Learn:** {only if source = compliance — the pattern + a linked example}

---
```

Rules that keep findings synthetic:
- **Bullets, not sentences.** Each bullet ≤15 words, one idea. Drop a bullet if it has nothing to
  add — never pad. A 1-line finding is fine.
- **No restating the title** in the bullets, and no "this PR…" preamble.
- **One blank line + `---` between findings** so the eye can separate them at a glance.
- **Fix snippet** only when code is faster to read than words; cap at 3 lines.

**Every code reference is a clickable link.** Any function, class, method, hook, component,
type, constant, or file mentioned anywhere in a finding — in the title, any bullet, or the
Fix — must be a markdown link to its definition, not bare backtick text. This lets the reviewer
jump straight to the code instead of grepping for it. Use the symbol as the link text and its
`file#Lline` as the target:

- `[`getEstablishments`](app/bl/establishments.py#L18)` — not `` `getEstablishments` ``
- `[`<DashboardTab>`](app/components/DashboardTab.tsx#L42)`, `[`OHSubscriber`](app/models.py#L210)`

Get the line from the scratch file's `file:line` (each subagent already cites it); if a symbol's
exact line is unknown, link to the file's top (`#L1`) rather than dropping the link. The `**File:**`
line stays as-is — the new rule is about the inline symbols in the prose.

**"No problem detected":** if every launched review scratch file says "No issues found." /
"No suggestions.", still emit the full block — title + Context preamble (if selected; it has
ramp-up value alone) + the Token usage table — and replace the P0-P3 sections with:
`No problems detected by the automated reviews.` No compliment; silence is approval.

## Step 6: Interactive mode

- **A number** → expand that finding: `[compliance]` → extended Learn examples (3-5 files with the
  right pattern); `[review]` → detailed trigger + root cause; `[ux-delight]` → pattern catalog +
  effort; `[architecture]` → full "preferred remedy" + structural rationale.
- **"fix all P0-P1"** → apply P0 fixes automatically; for each P1 show the change and ask to
  confirm; then re-run formatters/linters on the changed files.
- **"fix N"** → apply that specific fix, show the change.
- **"done"** → end the review.
