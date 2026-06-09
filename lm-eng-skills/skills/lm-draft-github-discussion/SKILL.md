---
name: lm-draft-github-discussion
description: >
  Drafts a GitHub Discussion on alan-eu/Topics in Louis-Marie's voice, after
  framing the content via /lm-grill-me. Applies Alan's Problem-Solving Method
  (Scoping / Framing / Making) + the feedback received on 2026-06-01 from Marion
  Doumeingts on the Work Stoppage discussion: clarity must appear IN THE FIRST 3
  LINES (problem / measure / options / decision needed). Adapts the length to the
  type: Quick need = 5-8 lines, Framing = structured long-form, Scoping = 10-15
  lines, Making = medium with product/tech split.
  Use when: /lm-draft-github-discussion, "create a GH discussion", "draft a
  framing discussion for [project]", "open a discussion on alan-eu/Topics about X",
  "scoping discussion pour [topic]" / "scoping discussion for [topic]", "écris une
  discussion Making pour [feature]" / "write a Making discussion for [feature]",
  "GitHub Discussion sur [Linear ticket]" / "GitHub Discussion on [Linear ticket]",
  "frame [problem] for the team", "discussion pour cadrer [besoin]" / "discussion to
  frame [need]", "draft a problem statement for [topic]", "rédige une discussion pour
  aligner sur [decision]" / "draft a discussion to align on [decision]".
  Also when the user shares a Linear/Slack/Notion URL and says "fais-en une GH
  discussion" / "turn it into a GH discussion".
  Do not use for: Slack messages (use /lm-draft-message), Notion updates
  (use /lm-draft-message), PR descriptions (use /update-pr-description),
  commit messages, replies in an existing discussion (just draft directly).
---

# lm-draft-github-discussion

Frame then draft a GitHub Discussion that passes Marion's clarity test:
**in the first 3 lines, the reader knows which problem, how we measure,
which options, and which decision is being asked for**.

## Why this skill

Feedback from Marion Doumeingts (2026-06-01) on
[Work stoppages - Framing - V0 scope](https://github.com/alan-eu/Topics/discussions/33112):

> "the writing initially felt quite technical, which made it hard for me to quickly
> understand the options, the trade-offs, and what input you expected from me. The
> next step is to make that clarity visible earlier in the written framing."

A discussion serves one of Alan's 4 jobs ([Problem-Solving Method](https://www.notion.so/alaninsurance/Problem-Solving-Method-52dab6d4c35b46c185b6990c19bc416d)):
Scoping, Framing, Making, Monitoring. The format adapts to the job. A Scoping that
adopts the Framing format fails: too long, too early.

A separate skill from `lm-draft-message` (generic Slack/Notion/GH) because: the upstream
grill is mandatory here, the per-phase templates are specific to Alan, and Marion's test
is the sole success criterion.

## Workflow (5 steps)

### Step 1 — Discussion type

One `AskUserQuestion`, 5 options:

| Type | STEP title | When | Length |
|---|---|---|---|
| **Scoping** | `Scoping` | Early — understand the problem, is it worth it? | 10-15 lines |
| **Framing** | `Framing` | Identify the solutions. The most demanding type, target of the Marion test. | Long-form |
| **Making** | `Making` | Align on V0 and execution plan. | Medium, structured |
| **Monitoring** | `Monitoring` | Post-ship — does the solution solve the problem? | Short-medium, data-driven |
| **Quick need** | *(skip)* | Frame a need / ask an open question. | 5-8 lines |

STEP in the title in **proper-case**, not all-caps (source: Notion
[Making decisions on Github](https://www.notion.so/alaninsurance/Making-decisions-on-Github-ec89a8f05c954f4cbdf5ecd3663d2763)).

If the prompt already contains a clear signal ("framing discussion", "V0 scope", "4 weeks
after ship") → skip the question, confirm inline in one sentence.

### Step 1.5 — Content nature (product / technical / both)

Second `AskUserQuestion`, unless there is an explicit signal:

| Option | When | Effect |
|---|---|---|
| **Product** | Pure product decision. PM/design/ops audience. | No technical section. |
| **Technical** | Pure tech decision. Eng-only audience. | All inline, no toggle. |
| **Both (mixed)** | The most frequent case. | Product inline, technical in `<details>` toggles. |

**Strata rule (asymmetric)**: product stays top-level (an engineer reads it as
context), technical goes into `<details>` toggles (a PM can ignore it without
missing the decision). Never the reverse.

```markdown
# 💡 Proposal

<Product framing — outcomes, user-facing flow, decision points>

<details>
<summary>Technical details</summary>

<Tech framing — endpoints, data model, FF, migrations, risques>

</details>
```

Special cases: Pure-product/technical → all inline. Mixed Quick need → product on the
surface, toggle ONE technical reference if needed. Mixed Making → `## Product side` inline
+ `<details> Technical side </details>` (see `references/templates.md`).

### Step 1.6 — Proposal structure (inline vs threaded)

**Only if the type is Framing (or a large Scoping).** The other types stay
inline at all times. Ask an `AskUserQuestion`, 2 options:

| Option | When | Effect |
|---|---|---|
| **Inline proposal** | A single decision, a single set of options. | `# 💡 Proposal` inline (current behavior: options table, product/technical split). |
| **Threaded sub-decisions** | ≥2 independent sub-decisions, each with its own frame/data/options. | `# 💡 Proposal` = thread index; each sub-decision = self-contained top-level comment. Model [#33399](https://github.com/alan-eu/Topics/discussions/33399). |

Skip the question + confirm inline in one sentence if the signal is clear: input that already
contains ≥2 distinct parallel topics → propose threaded; a single decision axis → inline.

**Orthogonality**: threaded ≠ alternative to the product/technical split. Inside a
thread, product stays top-level and technical goes into a `<details>` toggle (Rule 22).
The two axes coexist.

If threaded → read `references/thread-architecture.md` before Step 4.

### Thread architecture (model #33399)

When a discussion carries **several independent sub-decisions**, the inline `# 💡 Proposal`
becomes unreadable: a single comment stream mixes everything. Model #33399 answers
with a **thread architecture**: the Proposal is only an **index**, each sub-decision
lives in its own top-level comment, and the discussion accumulates in the relevant thread.

**The central point: progressivity.** The threads are ordered so understanding
builds from top to bottom: `foundation/broad scope → narrowing → mechanism/options →
edge cases → artifact (prototype) → Other last`. A reader who reads in order
accumulates the context; each thread stays readable alone but the sequence tells a story.

Full details (usage criterion, thread skeleton, index format, `gh api` posting
sequence): `references/thread-architecture.md`.

### Step 2 — Enrich from linked artifacts

If the input contains URLs/IDs, probing is mandatory: decisions live in the
comments, not the OPs. A discussion built on the OP alone will be factually off.

| Pattern | Command |
|---|---|
| `github.com/alan-eu/.../discussions/<N>` | `gh api graphql -f query='query { repository(owner:"alan-eu", name:"<repo>") { discussion(number:<N>) { title body comments(first:50) { nodes { author{login} body createdAt replies(first:20) { nodes { author{login} body createdAt } } } } } } }'` |
| `github.com/alan-eu/.../pull/<N>` or `PR #<N>` | `gh pr view <N> --repo alan-eu/<repo> --comments` |
| `linear.app/...` or `OHSET-N` / `EP-N` / `PAY-N` / `OHST-N` | `mcp__claude_ai_Linear__get_issue` then `mcp__claude_ai_Linear__list_comments` |
| `notion.so/...` or `app.notion.com/...` | `mcp__claude_ai_Notion__notion-fetch` |
| `alanhealth.slack.com/archives/...` | `mcp__claude_ai_Slack__slack_read_thread` |
| `quillmeetings.com/share?id=...` | `mcp__quill__get_meeting` or `mcp__quill__get_transcript` |

Fetch in parallel. Extract: timeline of reframings, agreed decisions vs ones still in
discussion, open questions, stakeholders who already weighed in. If zero URLs → note "no
linked artifacts to enrich from" in the final audit.

### Step 3 — Call `/lm-grill-me`

Invoke `lm-grill-me` in caller mode with the bank for the type:

```
Skill(lm-grill-me) with args:
  --caller lm-draft-github-discussion
  --bank references/grill-bank.md
  --section <scoping|framing|making|quick-need>
```

Returns `{questions_asked, unresolved, decisions_summary}` → feeds the draft (Step 4).

**Exception**: if the user has already provided detailed content (draft, transcript,
link enriched with explicit decisions), confirm with 1 question: "I have enough to draft
directly, or grill you first to sharpen the framing?". Recommend skipping if the content
already passes the first-3-lines test.

**Always grill for Framings** — the riskiest phase, where Marion applies the most.

### Step 4 — Draft per template

Read `references/templates.md` and apply the template for the type. Skeleton common to the 4
types, **6 H1 sections with emoji** (GitHub scannability):

```
# 🔭 Scope                          → what it is + what it is NOT
# 🕐 Why I'm opening this discussion → trigger + Linear project link
# 📅 Timeline                        → decision by <date>
# ℹ️ LOCI                            → Lead & Owner / Consulted / Informed
# 🌐 Context & Materials             → links + bold dependencies + sub-H2
# 💡 Proposal                        → type-specific content
```

Header: **Alan HTML comment** verbatim (copy from templates.md, ref Notion docs).
End of body: `### Threads` block verbatim with the checkbox ticked (`[X] Please use threads`).

**If threaded (Step 1.6)**: the `# 💡 Proposal` becomes an **index** (one bullet per thread,
same emoji as the thread title, `[Thread](TODO: link after posting)` link as placeholder).
In addition to the OP, draft **N top-level comments**, one per sub-decision, per the skeleton
in `references/thread-architecture.md`. Order by progressivity (broad → precise → mechanism →
edge cases → artifact → `Other` last). Force `[X] Please use threads`.

**Title format** (Notion guide): `[<Crew/Area/Community/Unit>] <Subject> - <STEP> - <Title>`

- Area: `[OccHealth Setup]`, `[Occupational Health]`, `[Prévenir]`, etc.
- Subject: 1 word if possible, caps reserved for acronyms.
- STEP: proper-case, optional (Quick need omits it).

E.g.: `[Occupational Health] Work Stoppages - Framing - Re-open a wrongly-closed stoppage`

#### Golden rule — Marion test mapped onto the template

If a reader stops after `# ℹ️ LOCI` (first 4 sections), they already know:

| Marion test | Section |
|---|---|
| What problem? | `# 🔭 Scope` bullet 1 |
| What's NOT? | `# 🔭 Scope` bullet 2 |
| Why now? | `# 🕐 Why I'm opening this discussion` |
| By when? | `# 📅 Timeline` |
| Who decides? | `# ℹ️ LOCI > Lead & Owner` |
| Whose input? | `# ℹ️ LOCI > Consulted` |

The progress metric and recommendation come next (`# 🌐 Context & Materials > ## How
we'll measure progress`, `# 💡 Proposal`). The Alan skeleton IS the Marion test.

#### Voice conventions

- **Output 100% English, always.** FR domain terms with no equivalent (DSN, SIRET, AMT,
  IDEST, IPRP, visite de reprise, Cadres/Non-Cadres) stay inline in French.
- **No em-dashes (—)**. Use `:`, `.`, `,`.
- **No FR/EN code-switching** ("Au top" → "Sounds good").
- **Acronyms expanded at first use** (PR → Pull Request, OH → Occupational Health).
- **Explicit headings**: `## Problem`, `## Options`, `## Decision I need` — not `## Context`.
- **Bullets for same-level ideas**, not dense paragraphs to enumerate (feedback Joachim Lis 2026-04).
- **`<details>` toggles for long content** (blank lines mandatory before/after the toggle
  body, otherwise GitHub doesn't parse the markdown). Detail: `references/alan-methodology.md` Rule 21.
- Emojis sparingly: :rocket:, :tada:, :hand:, :wave:, :hammer_and_wrench:.

#### Concision (the main goal of this skill)

- **Full sentences, each sentence carries information.** No decorative transition, no
  recap, no courtesy formula. If a sentence can be dropped without information loss, it goes.
- **No stylistic flourish.** No rhetorical turns of phrase or gratuitous emphasis. No adverbs
  (rule 14, alan-methodology.md). The tone stays LM's (direct, conversational) but without ornament.
- **Optional sections omitted when empty.** For Scoping / Quick need / Monitoring, an H1
  section that would carry only a placeholder or boilerplate is removed, not filled with emptiness.
  **Exception: Framing keeps the 6 H1s** (the skeleton IS the Marion test).
- **Minimal preamble.** The response leads with the draft preview. No "here's the draft I
  prepared", no meta-commentary. The type confirmations (Step 1/1.5) stay inline
  in one sentence.

### Step 5 — Pass 2: Visible clarity audit

**Always** output this checklist after the draft (anchors the patterns by repetition,
growth objective C1→D on "audience-aware writing"):

```markdown
## Clarity audit (Marion test + Alan template compliance)

Alan template compliance:
- [x] HTML comment Alan in header (verbatim)
- [x] Title format: `[<Area>] <Subject> - <STEP> - <Title>`
- [x] All 6 H1 sections present (Scope, Why, Timeline, LOCI, Context & Materials, Proposal)
- [x] Emoji prefixes on H1s (🔭, 🕐, 📅, ℹ️, 🌐, 💡): Unicode literal, not Slack notation
- [x] LOCI complete: Lead & Owner + Consulted + Informed all populated

Marion test (clarity in first 4 sections):
- [x] `# 🔭 Scope` says what it IS and what it is NOT
- [x] `# 🕐 Why` links to Linear project / quarter goal
- [x] `# 📅 Timeline` has an explicit date
- [x] `# ℹ️ LOCI` names specific people for Consulted
- [x] Progress metric visible in `# 🌐 Context & Materials > ## How we'll measure progress` (Framing only)
- [x] Options laid out with trade-offs table (Framing only)
- [x] Recommendation stated with rationale (Framing/Making)
- [x] Existing experience referenced (Framing/Making, Marion 2026-06-01)
- [x] Product vs Technical split (Making only, if cross-discipline audience)

Product/Technical strata (Rule 22, asymmetric):
- [x] Audience asked at Step 1.5 (product / technical / both)
- [x] If "both": product inline + technical in `<details>` toggle
- [x] No inversion: product is never wrapped while technical stays inline
- [x] If pure-product or pure-technical: no toggle, all inline

Thread architecture (if threaded — Step 1.6):
- [x] `# 💡 Proposal` is a thread index (one bullet per thread, emoji matches thread title)
- [x] Progressivity respected: foundation → narrowing → mechanism → edge cases → artifact → Other last
- [x] Each thread is self-contained (legal/data anchor + options/open question, readable alone)
- [x] Each thread closes with an open question inviting discussion
- [x] Index covers every drafted thread; `Other` thread present and last
- [x] `### Threads` set to `[X] Please use threads`

Voice & conventions:
- [x] No em-dashes
- [x] EN throughout (FR domain terms inline OK)
- [x] Acronyms expanded at first use
- [x] No filler sentences — every sentence carries info
- [x] Optional H1 sections omitted when empty (non-Framing)
- [x] All adverbs killed (rule 14)
- [x] Bold = full sentences only, not keywords
- [x] Alan tone of voice respected (members not customers, Alaners not employees)
- [x] Numbers convention (letters under twelve, figures from 13 — or all figures if mixed)
- [x] Long detail wrapped in `<details>` toggles where helpful (rule 21)
- [x] Threads checkbox set at the end of the body

## Rules applied
- <conventions hit, e.g. "Job statement format for Problem", "Outcome statement for metric">

## Rules deliberately skipped
- <if any, with reason — e.g. "No Options section: Quick need, not a decision request">

## Open questions for you before publishing
- <unresolved items from grill, with the right person to ping for each>
```

## When JTBD helps (Framing especially)

To phrase the **Problem** and **Progress metric** in a Framing (details
`references/jtbd-cheatsheet.md`):

- **Job statement** (`Verb + Object + Contextual modifier`), solution-neutral. E.g.: "Help OH
  admins **declare a work stoppage** for an employee **without leaving the dashboard**".
- **Outcome statement** (`Direction + Unit of measure + Object`). E.g.: "Minimize the number
  of clicks to declare a single work stoppage".

Skip JTBD for Scoping and Quick need — too heavy.

## Expected final output

Three draft blocks + audit + open questions. GitHub Discussions parses the raw markdown,
not the rendering: without the code block, copying the chat rendering breaks lists/tables/emojis.

### 1. Preview (readable rendering in the chat)

The draft in normal markdown, rendered by the terminal, for comfortable proofreading before copy-paste.

### 2. Raw markdown for GitHub (copy-paste block)

Re-emit the same draft in a single ` ```markdown ` fence:

````
```markdown
<!-- 
* Should you open a discussion? In doubt check: https://www.notion.so/alaninsurance/How-we-make-decisions-9db7efd39c794f5faff5c645848d863f
* Full documentation: https://www.notion.so/alaninsurance/Issues-on-Github-ec89a8f05c954f4cbdf5ecd3663d2763#0c64466f756a496399d69afce718c5f9
-->

# [<Area>] <Subject> - <STEP> - <Title>

# 🔭 Scope
...

# 🕐 Why I'm opening this discussion
...

# 📅 Timeline
...

# ℹ️ LOCI
...

# 🌐 Context & Materials
...

# 💡 Proposal
...
```
````

Raw block rules:
- A single ` ```markdown ` fence wraps everything.
- Alan HTML comment at the top, verbatim.
- Title with `# ` (the GitHub Title field takes just the text — see Section 3).
- Unicode literal emojis in the H1s (`🔭`, `🕐`, `📅`, `ℹ️`, `🌐`, `💡`), not Slack notation
  `:telescope:` (GitHub doesn't convert it).
- No comment, no "here's the draft:" around the content.

### 3. GitHub posting instructions

- **Repository**: `alan-eu/Topics`
- **Category**: "Discussions" (default). Alan dropped granular categories: the
  STEP lives in the title, the scope lives in the labels.
- **Labels**: at least one from the canonical list (🇧🇪 Belgium, ✨ Corporate and People,
  💼 Customer, 🧱 Foundation, 🇫🇷 France, 🌍 International Expansion, 🧑 Member, 🇪🇸 Spain,
  🛤️ Transversal, 🇨🇦 Canada). LM's OH → 🇫🇷 France (+ 🧑 Member if member-facing).
- **Title field**: the `# ...` line of the code block, without the leading `#`.
- **Body field**: everything else (HTML comment + 6 H1 + `### Threads` block).
- **No double-ping**: don't announce on Slack, GitHub notifications cover the LOCI.

### 4. Clarity audit + Open questions

As defined in Step 5, AFTER the raw markdown block so the copy stays clean.

### Threaded variant (if Step 1.6 = threaded)

Output, in order:

1. **OP preview** (readable rendering) — the `# 💡 Proposal` is the index, `[Thread](…)` links as
   placeholders.
2. **Raw OP markdown** (a single ` ```markdown ` fence) with the index as placeholder
   `[Thread](TODO: link after posting)`.
3. **N raw markdown blocks, one per thread**, in progressivity order. Each block = a single
   ` ```markdown ` fence, titled `Thread 1 — 💼 <subject>`, etc. Skeleton from
   `references/thread-architecture.md`.
4. **Posting sequence**: post OP → post each thread (capture the `comment.url`) →
   backfill the OP index → update OP. The `gh api graphql` recipe is in
   `references/thread-architecture.md` (only run it if LM asks).
5. **Clarity audit + Open questions**.

### Do not publish automatically

LM proofreads, adjusts, and publishes himself via the GitHub UI (or `gh api graphql` if he
asks explicitly). The skill produces the draft, not the publish. For the threaded variant, the
backfill of the `#discussioncomment-<id>` anchors requires the posting: only run it on explicit request.

## Meta tips (if relevant)

- **Scoping/Framing from a blank page**: suggest "Have you paired with [stakeholder]
  before drafting? Marion's tip 2026-06-01: 1-2h async exploration → 30min pair → use the
  transcript to draft." Don't insist if LM says he already has context.
- **Making done in one go**: suggest splitting product vs technical into 2 sections (his
  framework from 2026-06-01, validated by Marion as "good but keep it flexible").
