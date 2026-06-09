# Thread architecture (model: discussion #33399)

Some discussions carry several **independent sub-decisions**. Cramming them into one
inline `# 💡 Proposal` makes the discussion hard to navigate and impossible to resolve
piece by piece: a single comment stream mixes population-level questions with edge-case
flags, and nobody can tell which reply answers which decision.

The fix LM wants (canonical example:
[#33399 Enabling HR to declare risks & exposures](https://github.com/alan-eu/Topics/discussions/33399))
is a **thread architecture**: the OP `# 💡 Proposal` becomes a thin **index**, and each
sub-decision lives in its own top-level comment ("thread"). Discussion then accretes inside
the relevant thread, not in one global pile.

## When to thread (vs inline)

Use threads when **all** of these hold:

- There are **≥2 sub-decisions** that are independent enough that each could almost be its
  own discussion.
- Each has its **own context** (a distinct legal basis, dataset, or option set).
- You want each sub-decision's discussion to **stay contained** so it can be resolved on its
  own timeline.

Stay inline (current default behaviour) when:

- There is **one** decision and **one** set of options. Threading a single decision just adds
  ceremony. Use the inline Framing/Making templates in `templates.md`.

Threading is offered mainly for **Framing** (and large **Scoping**). It is **orthogonal** to
the product/technical split: inside a single thread you can still keep product framing
top-level and wrap technical detail in a `<details>` toggle (Rule 22).

## Progressivity - the ordering principle

This is the heart of the model. **Order the threads so understanding builds top to bottom.**
A reader who reads the threads in order accumulates context; each later thread assumes the
earlier ones are understood. Each thread is still self-contained (readable on its own), but
the *sequence* tells a story.

The canonical progression from #33399:

| # | Layer | Thread (#33399) |
|---|---|---|
| 1 | **Broad scope / foundation** - the widest frame, sets shared vocabulary | 💼 Risks & exposures for a **population** |
| 2 | **Narrowing** - zoom to the specific unit the rest depends on | 👤 Risks & exposures for an **employee** |
| 3 | **Mechanism / options** - *how* we'd actually do it | ☝️ **Options** to help HR select risks |
| 4 | **Edge cases / special flags** - the long tail, only sensible once 1-3 are clear | 🏡 Individual situation flags |
| 5 | **Artifact** - prototype, mock, spike | 💻 Prototype |
| 6 | **Other** - catch-all, always last | Other |

The rule, not the literal labels: **foundation → narrowing → mechanism → edge cases →
artifact → catch-all `Other` last.** Adapt the layers to the topic, but never start with edge
cases or options before the reader knows the scope they apply to.

## Thread top-comment skeleton

Each thread is a top-level comment with a consistent shape (derived from #33399). Self-contained:
a reader who jumps straight to it still gets the legal/data anchor, the options, and the open
question.

```markdown
# <emoji> <Thread title>

<1-2 lines anchoring the sub-decision: the legal basis, the data, or the constraint.
Link the sources inline.>

<Optional table when the sub-decision maps situations to outcomes:>

Situation | Monitoring / Outcome | What it enables | Source
:-- | -- | :-- | :--
<row> | <row> | <row> | <link>

## Option 1️⃣ - <name>

🔵 Pros: <one line>
🟠 Cons: <one line>

## Option 2️⃣ - <name>

🔵 Pros: <one line>
🟠 Cons: <one line>

<Close with an open question that invites discussion, e.g.
"Do you see other options to consider?" or a specific ask to a Consulted person.>
```

Notes:

- The numbered-option emojis (`1️⃣`, `2️⃣`, `3️⃣`) and `🔵`/`🟠` for pros/cons are the #33399
  convention. Keep them - they make trade-offs scannable.
- Not every thread needs options. A pure-context thread (e.g. a population-level legal
  obligation that just needs acknowledgement) can be anchor + open question only.
- Decisions accrete in **replies** to the thread (sync recaps like `# Sync Friday June 5`,
  follow-up questions). The skill drafts only the **top comment**; replies happen live.

## OP index format

The OP `# 💡 Proposal` lists one bullet per thread, same emoji as the thread title:

```markdown
# 💡 Proposal

- 💼 <Sub-topic 1, broadest> - [Thread](<discussion-url>#discussioncomment-<id>)
- 👤 <Sub-topic 2, narrower> - [Thread](<discussion-url>#discussioncomment-<id>)
- ☝️ <Mechanism / options> - [Thread](<discussion-url>#discussioncomment-<id>)
- 🏡 <Edge cases> - [Thread](<discussion-url>#discussioncomment-<id>)
- 💻 Prototype - [Thread](<discussion-url>#discussioncomment-<id>)
- Other - [Thread](<discussion-url>#discussioncomment-<id>)
```

The anchor IDs (`#discussioncomment-<id>`) **only exist once the comments are posted**. In a
draft, leave them as `[Thread](TODO: link after posting)` placeholders, and fill them via the
posting sequence below.

Set the closing `### Threads` block to `[X] Please use threads` whenever the discussion uses
this architecture (the format declaration must match the structure).

## Posting sequence (gh api - only on explicit request)

Default stays "don't auto-publish": produce the drafts + this sequence, LM posts and backfills.
Run it only if LM explicitly asks the skill to post.

Order matters: the index can only link to comments that already exist.

1. **Get the discussion node id** (existing discussion):
   ```bash
   gh api graphql -f query='
   { repository(owner:"alan-eu", name:"Topics") {
       discussion(number:<N>) { id } } }'
   ```
   Or create it first (`createDiscussion` mutation - needs `repositoryId` + `categoryId`).

2. **Post each thread as a top-level comment**, in progression order, capturing each `url`:
   ```bash
   gh api graphql -f query='
   mutation($d:ID!, $b:String!) {
     addDiscussionComment(input:{discussionId:$d, body:$b}) {
       comment { id url }
     }
   }' -f d='<discussion-node-id>' -f b='<thread-markdown-body>'
   ```
   The returned `comment.url` already contains the `#discussioncomment-<id>` anchor.

3. **Build the index** from the captured URLs.

4. **Update the OP body** to insert the filled index:
   ```bash
   gh api graphql -f query='
   mutation($d:ID!, $b:String!) {
     updateDiscussion(input:{discussionId:$d, body:$b}) {
       discussion { id }
     }
   }' -f d='<discussion-node-id>' -f b='<OP-markdown-with-filled-index>'
   ```
