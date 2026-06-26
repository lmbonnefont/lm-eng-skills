---
name: lm-v1-options
description: >-
  Helps scope the V1/V0 of a feature: takes a step back to separate the user JOB
  from the MECHANISM, explores the real codebase via codegraph, then proposes 5
  versions (bold → conservative) each with explicit tradeoffs, technical
  complexity, and how easy it is to iterate on later. Use this whenever the user
  is scoping a feature's first version or weighing how to slice it — "what should
  the V1 be", "how do I scope this", "what's the smallest / MVP version", "I need
  to ship a V1 of X in N days", "help me find the V0", "quelle V1 pour X",
  "cadrer la V1", "la plus petite version", "défendre ma V0", "options pour
  construire X", or when they're about to start a feature and the slice isn't
  nailed down yet — even if they don't say "V1" explicitly. Triggers in French
  and English. Do NOT use for: executing an already-decided scope (use
  guided-feature-development), tracing existing code flows (lm-flow-walkthrough),
  or hunting reusable code (lm-reuse-discovery).
---

# V1 Options

Help the user find the right first slice of a feature, weigh five concrete
versions against the real codebase, and own the tradeoffs of whichever they pick.

## Why this skill exists

The expensive scoping mistake is not "too big" vs "too small" — it's anchoring
on a **mechanism** before naming the **job**. The user's own example: for
"declare employee exposures" he first imagined the V1 as *a banner that catches
all newly-declared employees*. But the job was *let HR update the concerned
employees so the right monitoring is deduced*. The banner is a flashy mechanism
that may not even deliver the job. Anchoring on a mechanism makes you generate
five flavors of the same wrong thing.

There's a second, deeper step-back that matters even more, and it's the one
people miss: **exploiting the operational reality to shrink the problem itself.**
Same example — step back further and you realize the monitoring type is the
default (SI) for the vast majority of workers, and the existing stock has
*already* been classified by the doctor during their visit. So HR doesn't need a
tool to process every employee at all — they only need to flag the handful they
*know* carry a particular risk. The "stock" problem evaporates; what's left is a
tiny exception-flagging job. That insight doesn't come from the code — it comes
from product/operational facts the user holds (the distribution of cases, who
already does what, stock vs flow). It's exactly what asking the right questions
(grill-me) surfaces.

So this skill works two levers, in order:

- **Lever A — Job, not mechanism.** Climb until the V1 statement names an outcome,
  not a UI/table/banner. (Phase 1.)
- **Lever B — Shrink the problem, not just the build.** Use operational reality —
  the default case, the existing actors/processes, stock vs flow — to question
  whether you even need to handle most of the space. The cheapest V1 is often the
  one that *takes on dramatically less of the problem*, not the one that builds a
  smaller version of the whole thing.

Then it grounds technical complexity in the actual code (codegraph, no
hand-waving) and lays out a spectrum so the user chooses with eyes open.

Three principles run through everything:

- **Ambition ≠ value.** A bold-looking option can deliver *less* of the job than
  a humble one. Score "does it deliver the job to who-hurts-now" separately from
  "how ambitious it looks", so the trap is visible on the page. Never list an
  option that doesn't deliver the job as if it were a real contender.
- **The smartest move is often to handle less.** Exploit defaults, existing
  actors, and the stock-vs-flow split to carve the problem down before sizing any
  build. At least one option must be this kind of product-level scope collapse.
- **Iterability is a first-class axis.** The best V1 is often the one that's
  cheapest to *grow*, not the one that does most on day one. Always ask: does
  this slice paint us into a corner, or is V2 a clean extension?

## Workflow

Four phases. Phase 1 is a hard gate — do not generate options until it is
explicitly confirmed by the user. The reasoning matters more than the ritual:
without a mechanism-free job statement, the five options are just five guesses.

### Phase 1 — Frame & operational reality (GATE)

Goal: a crisp frame the user signs off on, covering both levers.

**Lever A — the mechanism-free frame.** Produce these four items:

1. **The job-to-be-done** — the user outcome, stated with zero implementation.
   If your sentence contains a UI element, a table, a button, a banner, a job, a
   cron — it's a mechanism, rewrite it. Test: "X can now Y so that Z."
2. **Who hurts now** — the specific population that has this problem *today*
   (not the eventual full audience). This is what right-sizes the V1. The banner
   trap dissolves the moment you ask "whose pain are we removing first?".
3. **Done-when signal** — one observable thing that proves the job is delivered
   (a state change, a number that moves, a manual step that disappears).
4. **Mechanisms set aside** — explicitly list the implementation(s) the user
   walked in assuming (banner, modal, endpoint…) and park them. They become
   *candidates* in Phase 3, not the frame.

**Lever B — the operational reality that can shrink the problem.** This is the
step most people skip, and it's where the biggest wins hide. These facts live in
the user's head and the product/ops context, *not* in the code — so this is what
lm-grill-me is for. Probe until you can answer:

- **Distribution** — what's the default / most-common case, and what fraction is
  the exception? (If 95% land on a safe default, you may not need to build for
  the 95% at all.)
- **Existing coverage** — who or what *already* handles part of this today? Is the
  existing **stock** already taken care of by another actor or process? (E.g. the
  doctor already sets the monitoring type during the visit → the stock is done.)
- **Stock vs flow** — is the pain about the *existing stock* of cases, or the
  ongoing *flow* of new ones? They often need completely different (or no) builds.
- **Cost of skipping a segment** — if the V1 ignores some cases, what's the
  fallback, and is it acceptable? (A safe default + a rare, low-stakes miss means
  you can ignore that whole segment for V1.)

The payoff of Lever B is a candidate that *takes on far less of the problem* —
e.g. "let HR flag only the known-risk exceptions; ignore the stock because it's
already classified and the default is safe." Always carry at least one such
insight into Phase 3.

**Driving the questions:** use **lm-grill-me** to fill the gaps in BOTH levers —
but only the genuine gaps. If the user already gave rich context (a Slack thread,
a ticket, a prior trace), extract what you can first and grill only on what's
missing or ambiguous — especially the Lever B facts, which are easy to assume
wrong. See [references/altitude-check.md](references/altitude-check.md) for the
pattern library, the operational-question bank, and two worked examples (the
banner trap and the SI-default scope collapse).

**Gate:** state Lever A's four items + a short "operational reality" summary back
in one block and ask the user to confirm or correct. Do not proceed to options
until they say it's right. (In a non-interactive run, state these as explicit
assumptions and proceed.)

### Phase 2 — Ground in the real code (codegraph-first)

Estimates of complexity and iterability are worthless unless they're tied to
what the codebase actually looks like. Before generating options, explore:

- If the target area is **codegraph-indexed** (a `.codegraph/` exists, or the
  user's setup lists an index), use `codegraph_explore` / `codegraph_node` with
  an **absolute** `projectPath`. One `codegraph_explore` on the seam you'll touch
  usually returns the verbatim source + call paths you need.
- Otherwise fall back to grep + read, scoped to the component.

You're looking for the **seams**: where would each candidate mechanism plug in?
What already exists that a conservative option could reuse (low complexity)? What
would a bold option have to build or migrate (high complexity, possible lock-in)?
Capture concrete `file:line` anchors — every complexity/iterability claim in
Phase 3 must cite one, so the user can trust it (zero-trust: prove it, don't
assert it).

### Phase 3 — Generate the five options

The spectrum is **how much of the problem you take on**, from boldest (handle the
whole space for everyone) to most conservative (exploit the operational reality
from Lever B to handle only the true exception, or even handle it manually). It
is *not* a ladder of engineering effort on the same idea — five sizes of the same
build is exactly the failure mode to avoid. The most conservative option may be
manual / ops / no-code if that genuinely removes today's pain.

Hard requirements for the set of five:

- **Every option must deliver the job** to who-hurts-now. An option that doesn't
  is not a contender — cut it. (You may keep one clearly labelled "❌ does not
  deliver the job — shown to flag the trap" if it's the user's instinct and worth
  warning against, but it doesn't count toward the five.)
- **At least one option must be a Lever-B scope collapse**: a real *product* move
  that takes on far less of the problem by exploiting the default, an existing
  actor, or the stock-vs-flow split (e.g. "HR flags only known-risk exceptions;
  the stock is left to the doctor's existing classification"). This is the option
  the user said was missing — never omit it.
- **Options are product moves first, engineering slices second.** Two options that
  differ only in implementation of the same scope should collapse into one;
  replace the freed slot with a genuinely different product bet.

For each option, fill this card:

```
### Option <N> — <short name>  ·  <Bold | Ambitious | Balanced | Lean | Conservative>
- **Slice**: what's IN. One or two lines.
- **Problem taken on**: how much of the space this handles vs deliberately
  exploits away (name the Lever-B move if this option uses one).
- **Out of scope**: what's deliberately NOT in this slice, and why that's safe.
- **Delivers the job?**: does it remove the pain for *who-hurts-now* (Phase 1)?
  Be blunt.
- **Technical complexity**: Low / Medium / High, justified with real refs
  (`file:line`). What gets reused vs newly built vs migrated.
- **Iterability**: how cleanly does V2 extend this? Does it create lock-in,
  migration debt, or a one-way door? (Low effort to grow = a big plus.)
- **Assumed tradeoffs**: what you knowingly give up by shipping this.
```

### Phase 4 — Present neutrally, then help defend the pick

1. **Present all five neutrally, sorted by technical complexity (simplest
   first).** The user usually comes with a time budget, so the cheapest-to-ship
   options must be visible at a glance. Lead with a comparison table whose rows
   are ordered low → high complexity, columns: option · ambition · job delivered?
   · complexity · iterability. (Generation still spans the full ambition
   spectrum — you just present them ranked by cost, not by ambition.) Then the
   detailed cards. Do **not** pick for the user — the choice is theirs. You may
   surface tensions ("Option 2 is cheapest to grow but leaves night-workers out")
   without choosing.
2. **Write the doc.** Generate an English markdown artifact using
   [assets/v1-options-doc-template.md](assets/v1-options-doc-template.md). It's a
   shareable artifact (review, Slack, ticket) — English, not a `.claude/plans/`
   French plan. Default path: `tmp/agent-scratch/v1-options-<feature>.md` unless
   the user gives one.
3. **Defend the chosen one.** Once the user picks, fill the doc's "Decision &
   defense" section: restate the job, the slice, **what's explicitly OUT**, the
   **assumed tradeoffs owned out loud**, the **iteration path** (V1 → V2 → …),
   and the **risks**. The point is to make the V0 defensible precisely because
   its tradeoffs are named and accepted, not hidden.

## Output language & tone

- The skill's instructions and the generated **doc** are in **English**
  (shareable artifact).
- Talk to the user in **French** if they write in French.
- Be concrete and concise. Tables over prose for the comparison. Every technical
  claim carries a `file:line`.
