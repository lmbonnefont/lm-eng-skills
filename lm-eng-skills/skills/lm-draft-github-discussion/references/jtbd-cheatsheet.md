# JTBD cheatsheet for Framing discussions

Distilled from "8 things to use in Jobs-To-Be-Done framework for product
development" (Zbignev Gecis, UX Collective, 2015). Adapted for Alan GitHub
Discussions.

**When to apply**: Framing discussions only. Skip JTBD for Scoping (too heavy)
and Quick need (too formal). Making discussions can borrow the Outcome
statement format but don't need the full framework.

---

## The 1-line theory

> "What job is this product hired to do?"

People don't buy products. They hire solutions to get a job done. A lawnmower
is hired for "keeping the grass low and beautiful", not "cutting grass" — and
that reframing opens new solution spaces (genetically engineered grass that
doesn't grow).

For Alan: an OH admin doesn't hire "the declare-work-stoppage modal". They
hire it for "keeping my workforce data current in my HR system without
context-switching to a second tool".

---

## The 8 things — Alan adaptation

### 1. Identify the job

**Question**: what is the customer ACTUALLY trying to accomplish, beyond the
surface action?

**Alan signal**: when you find yourself describing the solution ("a modal with
a dropdown") before the job, you've inverted the framework. Restate the job
first.

**Use in discussion**: opens the `## Why this matters now` section.

### 2. Categorize the job

Two axes:
- **Main vs Related**: the main job + the related jobs the customer expects
  to do in conjunction.
- **Functional vs Emotional** (Emotional further splits into Personal vs
  Social).

**Alan signal**: most admin features have a main *functional* job ("declare
the stoppage") AND a related *emotional/personal* job ("feel in control of my
workforce data") that's invisible if you only look at clicks.

**Use in discussion**: only if the emotional/social dimension is load-bearing
for the decision. Otherwise, skip — don't pad.

### 3. Define competitors

**Question**: what would the admin "hire" if our feature didn't exist? Excel?
Email to ops? Phone call? Doing nothing?

**Alan signal**: when the answer is "doing nothing", you have an under-served
opportunity. When it's "another Alan tool that's adjacent", you may have a
consistency problem rather than a missing feature.

**Use in discussion**: in `## Why this matters now`, mention what admins
currently hire when our flow is absent.

### 4. Job statement format

```
Verb + Object + Contextual modifier
```

Example:
- **Job**: "Declare a work stoppage for an employee without leaving the dashboard"
- **Verb**: Declare
- **Object**: a work stoppage for an employee
- **Context**: without leaving the dashboard

**Use in discussion**: this IS your `## Problem` statement. Plug it into the
blockquote at the top of the Framing template.

**Anti-pattern**: "Build a work stoppage modal" — that's the solution, not
the job. Solution-neutral framing keeps you open to better solutions during
the discussion.

### 5. Prioritize via Importance × Satisfaction

Two-axis chart:
- **X-axis**: how important is the job to the customer?
- **Y-axis**: how satisfied are they with current solutions?

Three zones:
- **Under-served** (high importance, low satisfaction) → core growth play
- **Over-served** (low importance, high satisfaction) → disruption candidate
- **Served right** (middle) → focus on related jobs

**Alan signal**: most admin features sit in Under-served territory — admins
report needing X but tolerate the workaround. That's the green-light signal.
Over-served is rarer in admin tools.

**Use in discussion**: in `## Why this matters now`, name the zone explicitly
if you have signal ("admin satisfaction with current declare flow: 2/5 in
last NPS — under-served").

### 6. List outcome expectations

What criteria would the customer use to decide which solution to hire?

Four types:
1. Desired outcomes customer wants to achieve
2. Undesired outcomes customer wants to avoid
3. Desired outcomes provider (Alan) wants to achieve
4. Undesired outcomes provider wants to avoid

**Use in discussion**: each option in the `## Options` table should be scored
against these outcomes implicitly. The trade-offs column = which outcomes
the option hits vs misses.

### 7. Outcome statement format

```
Direction of improvement + Unit of measure + Object of control + Context
```

Example:
- **Outcome**: "Minimize the number of clicks to declare a single work stoppage
  while on the OH admin dashboard"
- **Direction**: Minimize
- **Unit**: number of clicks
- **Object**: to declare a single work stoppage
- **Context**: while on the OH admin dashboard

**Use in discussion**: this IS your `## How we'll measure progress` statement.
Plug it into the blockquote at the top of the Framing template.

**Anti-pattern**: "Improve the UX of the declare flow" — not measurable, not
solution-neutral, not falsifiable.

### 8. Jobs evolve slowly

The job is stable; the solution should change at strategic intervals.

**Alan signal**: if you're tempted to write "previously we did X, now we do Y"
in the problem section, you're describing solution evolution, not job
evolution. The job ("declare a stoppage") hasn't changed — only the solution.

**Use in discussion**: NOT in the discussion itself. Internal reminder: stay
solution-neutral in the Problem section. Solution choices come later in
`## Options`.

---

## Quick application checklist

When drafting a Framing, ask yourself:

- [ ] Is the Problem statement in the Job statement format (Verb + Object + Context)?
- [ ] Is the Progress metric in the Outcome statement format (Direction + Unit + Object + Context)?
- [ ] Are the Options solution-neutral enough that I'm not just picking
      between flavors of the same solution?
- [ ] Have I named the competitor (what admins hire when we're absent)?
- [ ] Have I located the job on the Importance × Satisfaction grid (even
      qualitatively)?

If 3+ are unchecked → go back to grilling. The Framing isn't ready.

---

## When NOT to apply JTBD

- **Tech-debt / refactor discussions**: there's no customer job, just an
  internal job. Use the templates without JTBD framing.
- **Bug-fix discussions**: usually no Framing needed at all — just a Linear
  ticket. If it's escalated to a discussion, the framing is "this bug is
  costing us X, here's the fix" — not a JTBD analysis.
- **Eng-internal RFCs** (new lib choice, deployment strategy, etc.): use
  Framing template structure but skip the JTBD vocabulary — the audience
  doesn't expect it.
