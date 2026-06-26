# Altitude check — separating the job from the mechanism

This is the heart of the skill. Read it whenever Phase 1 feels fuzzy or the user
pushes back on the gate. The job here is to help the user climb to the right
altitude *before* generating options, because a wrong frame produces five wrong
options.

## The core distinction

| | Job (outcome) | Mechanism (implementation) |
|---|---|---|
| Question it answers | What changes for the user? | How do we make it change? |
| Contains | a who, a capability, a so-that | UI, tables, endpoints, jobs, banners |
| Lifespan | stable | disposable, swappable |
| Example | "HR can declare a worker's exposures so the right monitoring is deduced before the first visit" | "a banner", "a modal", "a cron that scans new affiliations" |

If your "V1 statement" names a thing on the screen or in the DB, you've stated a
mechanism. Climb up one level and ask "what does that let the user accomplish?"
until the sentence is implementation-free.

## The worked example (the banner trap)

The user came in believing: **V1 = a banner that catches all newly-declared
employees.**

Climbing the ladder:

- "A banner" → mechanism. What does it let someone do? → "notice employees who
  need attention."
- Who hurts *today*? → HR, who can't tell the system which workers are exposed,
  so everyone defaults to basic monitoring (SI) and the wrong visits get planned.
- Done-when? → a manually-added worker's monitoring level (SI/SIA/SIR) reflects
  their real exposures *before* the first visit.

Re-stated job: **"HR can declare the exposures/situations of the concerned
workers so the right monitoring is deduced before the first visit."**

Now compare to the banner:

- The banner catches *newly-declared* employees — but the job is about *concerned*
  employees, which is a different (and possibly overlapping-but-not-equal) set.
- The banner is a notification surface; it doesn't, by itself, let HR *declare*
  anything. It's a mechanism attached to the wrong population.

That mismatch is invisible if you start from "banner" and only ask "where should
the banner go / what color / which employees does it list". It's obvious the
moment you ask "whose pain, and what capability removes it." That's why the gate
exists.

## Questions that climb to the right altitude

Use these to drive lm-grill-me (only on genuine gaps):

- "If this works perfectly, what can someone do on Monday that they can't do on
  Friday?" (forces capability, not UI)
- "Who is in pain *right now* because this doesn't exist? Name the smallest group
  whose pain we could remove first." (right-sizes who-hurts-now)
- "How would we *see* it worked — what state changes, or what manual step
  disappears?" (forces an observable done-when)
- "You said [mechanism]. Suppose we couldn't build that — what's another way to
  deliver the same outcome?" (detaches outcome from mechanism; if the user can't
  answer, they're still anchored)

## Anti-patterns to catch

- **Mechanism-as-frame**: the whole brief is "build the modal / the banner / the
  endpoint". → ask what it's *for*.
- **Whole-audience-on-day-one**: the V1 targets every future user instead of the
  group hurting now. → narrow who-hurts-now.
- **No observable done-when**: success is described as "users are happy" or "it's
  shipped". → demand a state change or a number.
- **Vision creep**: the job statement secretly bundles three jobs. → split, pick
  the one that hurts most now.

## Lever B — operational reality (shrinking the problem)

Lever A gets you the right *job*. Lever B asks whether you even need to handle
most of the *problem*. This is where the biggest V1 wins hide, and it's pure
product/ops reasoning — the facts live in the user's head, not the code, so this
is what grill-me must extract.

### Operational question bank

- **Distribution**: "What's the default / most-common outcome here, and roughly
  what fraction of cases is the exception?" A heavily-skewed default means the
  bulk may need *zero* new work.
- **Existing coverage**: "Who or what already handles part of this today? Is the
  existing stock already taken care of by another actor or an existing process?"
- **Stock vs flow**: "Is the pain about the existing stock of cases, or the
  ongoing flow of new ones?" These usually need different builds — or the stock
  needs none.
- **Cost of skipping**: "If the V1 ignores segment X, what's the fallback, and is
  it acceptable?" A safe default + a rare, low-stakes miss = ignore that segment.
- **Reversibility of the default**: "If a case is wrongly left on the default, who
  catches it later, and how bad is the delay?" If a human downstream catches it,
  the V1 can lean on that safety net.

### Worked example — the SI-default scope collapse

Same exposures feature. Lever A gave us the job ("HR can declare exposures so the
right monitoring is deduced"). Now run Lever B:

- Distribution → the monitoring type is **SI (basic) for the vast majority** of
  workers; only a minority carry a particular risk (SIA/SIR).
- Existing coverage → workers who've already had a visit have **already been
  classified by the doctor**. The existing *stock* is done.
- Stock vs flow → the real gap is the *flow* of workers HR knows carry a risk
  before any visit — not the stock.
- Cost of skipping the default → leaving someone on SI who's truly SI costs
  nothing; the only thing that matters is catching the rare known-risk case.

**Collapse:** the V1 doesn't need to process every employee, and doesn't need to
touch the stock at all. It only needs to let HR **flag the handful they know
carry a particular risk**. A feature that looked like "manage monitoring for the
whole workforce" becomes "an exception-flagging affordance for a small minority."

That option is invisible if you only vary engineering effort on "process all
employees." It only appears once you ask the distribution/stock questions. This
is why Phase 3 *requires* at least one Lever-B option.

## When the gate is satisfied

You have four lines the user confirmed: job, who-hurts-now, done-when, mechanisms
set aside. Only then do the five options mean anything — each becomes a different
*slice of that job*, not a different decoration of a mechanism.
