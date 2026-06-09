# Alan methodology tips for GitHub discussions

Extracted from the official Alan Notion page
[🪄 Methodological tips](https://www.notion.so/alaninsurance/Methodological-tips-ce3dc3e49cbf4b9ab8bf219d5e8e13be).
These rules are **applied automatically by the skill** during drafting and
listed in the clarity audit at the end.

The 3 sections below map to the 3 phases of an issue: opening, driving,
writing.

---

## 📭 Framing / Opening — when drafting

### Rule 1 — Framing is not achieving

An opened issue is a **stepping stone**, not a deliverable. Drafting one
should accelerate the team, not become a blocker.

**Applied by skill**: never inflate a draft to look more "finished". When
between two template lengths, pick the shorter one. A 5-line Quick need
that ships today beats a perfect Framing that takes 2 days.

### Rule 2 — Smaller pieces solve faster

"The smaller pieces you break a problem into, the faster you reach your
final aim."

**Applied by skill**: if the grill surfaces 3+ distinct sub-problems, the
skill suggests **splitting into multiple discussions** and adds them as
linked threads in the Proposal section (pattern from #32972). Don't draft
one mega-discussion when 3 small ones would be faster.

### Rule 3 — Longer issue = slower participation

"The longer the issue, the more time it takes from people to participate."

**Applied by skill**: in `# 🌐 Context & Materials`, put **only key points
inline** and link to a Gdoc / Notion page for deeper details. Never paste
a 2-page context block.

### Rule 4 — Refer to the legal base, not what is usually done

Specific to Alan (regulated company). "The law goes rarely into details and
it's up to each one to make their own interpretation, not copy-paste the
usual way."

**Applied by skill**: when grilling for Context, ask "Is there a legal base
that constrains this?" — and if yes, link it directly (Code du travail,
AFNOR spec, etc., as in #32972).

### Rule 5 — Fewer people = faster closure

"The more people in an issue, the more difficult it becomes to close it fast."

**Applied by skill**: when populating LOCI:
- **Consulted**: only Alaners whose view is a **must-have** to solve the
  problem. If unsure, leave out.
- **Informed**: ping them **only once the issue is concluded** — not in
  the OP. So in the initial draft, the Informed line stays vague
  ("OccHealth area" rather than @-mentioning everyone).

### Rule 6 — Ambitious timelines

"We used to say an issue is to be closed in 4 days; now we open some with
10-day timelines."

**Applied by skill**: `# 📅 Timeline` defaults:
- Quick need: **2-3 working days**
- Scoping: **3-5 working days**
- Framing: **5-10 working days** (ambitious, not "by end of quarter")
- Making: **3-5 working days** (V0 sign-off shouldn't drag)

If LM proposes a longer timeline → flag in audit checklist and suggest the
default.

### Rule 7 — Beware multiple threads

"If the issue is hard to navigate, contributors will postpone their
contributions. At times it can be better to open 2 small discussions."

**Applied by skill**: if the Proposal section is shaping up to have 4+
distinct decision points, **propose splitting** before finalizing the
draft. Show the proposed split as separate discussions in the output.

### Rule 8 — Done > perfect, mention V2

"Never aim to get the best version at first shot, this is the recipe for
failure. Iteration should be part and parcel of the proposal — clearly
explain what will potentially be the V2 once we have more step back and
time."

**Applied by skill**: for Framing and Making, the Proposal section includes
a **`## V2 / iteration plan`** sub-section that names what's deliberately
deferred. Aligns with Marion 2026-06-01's "go deeper on the existing
experience" — V2 plan is part of that depth.

---

## 🚗 Driving the discussion — after publishing (mentioned to LM in output)

These rules apply post-publish — the skill mentions them as **tips in the
"Open questions for you before publishing" section** when relevant.

### Rule 9 — Distributed ownership ≠ ownership dilution

Don't spread the load so wide that no one is accountable. LOCI's "Lead &
Owner" is **one** person, not a team handle.

**Mentioned when**: LM tries to put two names as Lead & Owner.

### Rule 10 — Sequence, don't parallelize

"Do not have four issues per person opened in parallel."

**Mentioned when**: LM has 3+ active GH discussions already. (Skill should
check this via `gh api` if practical, otherwise note the rule generically.)

### Rule 11 — Funnel pattern

"After a few people have contributed, propose a first tentative conclusion
and wrap up the pending questions so we keep moving forward and new
contributors can use this as a new starting point."

**Mentioned in output**: as a follow-up tip — "Plan to post a 'tentative
conclusion' comment 48h after publishing to funnel the discussion forward."

### Rule 12 — Reversible decisions OK with less info

"Take risks / propose simplifications and make decisions with less
information. As long as you check that the decision is reversible it's OK."

**Applied by skill**: in Framing's Recommendation section, the skill
encourages naming a reversibility level ("This is reversible — we can swap
to Option 2 in V2 if signals are wrong") to reduce decision friction.

---

## 🖊️ Writing tips — applied throughout

### Rule 13 — Structure: problem first, conclusions upfront

"Organize information logically, starting with the problem. Put key points
and conclusions upfront."

**Already applied**: the Marion test + the Alan template (Scope → Why →
Timeline → LOCI in the first 4 sections) enforce this.

### Rule 14 — Kill adjectives. Kill ALL adverbs.

"You can kill as many adjectives and adverbs (actually ALL adverbs) from
your sentences. It makes your sentences shorter, more factual and it gives
less the impression you're trying to impress/intimidate."

**Applied by skill**: Pass 2 audit specifically scans for adverbs ending in
`-ly` (English) and adjective stacks. Examples to kill:
- ❌ "really critical issue" → ✅ "blocker"
- ❌ "we should probably consider" → ✅ "we should"
- ❌ "extremely important context" → ✅ "context"
- ❌ "currently being discussed" → ✅ "being discussed" (or simpler: "in
  discussion")

### Rule 15 — Bold full sentences only

"Use bold to highlight full sentences only. Highlighting only key words
makes it harder to read."

**Applied by skill**: when bolding for emphasis, bold the whole sentence,
not just keywords. Exception: standalone field labels (e.g.
`**Problem**:`, `**Recommendation**:`) — those are labels, not in-prose
emphasis.

### Rule 16 — Avoid acronyms

"Avoid acronyms."

**Tension with LM's preference** (acronyms expanded at first use). The skill
applies a hybrid:
- **First use**: spell out fully + acronym in parentheses (e.g.
  "Occupational Health (OH)").
- **Subsequent uses**: acronym OK.
- **Title and 🔭 Scope section**: spell out fully, no acronyms at all —
  these are the entry points and must be readable cold by anyone who lands
  on the discussion.

### Rule 17 — Alan tone of voice — official lexicon

Alan-specific vocabulary that must be respected:

| Avoid | Use |
|---|---|
| customers | **members** |
| HR | **People** |
| company / org (referring to Alan) | **Alan**, **Communities** |
| departments | **teams** |
| employees of Alan | **Alaners** |
| users (of internal tools) | **Alaners** or named role (e.g. OH admin) |

**Applied by skill**: Pass 2 audit greps for the forbidden terms. Replaces
them silently in the draft and flags the replacement in the audit checklist.

### Rule 18 — Numbers convention

- Numbers under twelve → **letters** (one, two, ..., twelve).
- Numbers 13 and above → **figures**.
- Exception: dates and addresses always in figures.
- **If one number in a sentence is in figures, all numbers in that
  sentence are in figures** (e.g. "I bought 4 pears and 24 apples", not
  "I bought four pears and 24 apples").

**Applied by skill**: Pass 2 audit converts numbers per these rules.

### Rule 19 — Audience perspective

"Write with your audience in mind, making content easily understandable
and relevant."

**Applied by skill**: the grill captures the audience composition (eng-only
vs cross-discipline) and adapts:
- Cross-discipline → Product / Technical split (Making), no eng jargon in
  Scope and Why sections.
- Eng-only → can be more direct with implementation details in Proposal.

### Rule 20 — Pay attention to details

"Maintain consistency in formatting, punctuation, and language throughout
your document."

**Applied by skill**: Pass 2 final scan for inconsistencies — bullet style
(`-` vs `*`), trailing whitespace, mixed period-then-no-period in lists,
inconsistent header capitalization.

---

### Rule 22 — Product/technical strata (asymmetric)

LM preference, 2026-06-01:

> "Ne pas envoyer d'informations techniques à des gens qui font du produit.
> L'inverse est faux car le produit sert de contexte au technique."

**Applied by skill**: Step 1.5 of the workflow asks the user whether the
discussion is *product*, *technical*, or *both*. When *both*, the draft
enforces:

| Stratum | Visibility | Examples |
|---|---|---|
| **Product (top-level, inline)** | Always visible to all readers | User-facing flow, outcomes, decision points, options as PM/design sees them, member impact |
| **Technical (inside `<details>` toggle)** | Collapsed by default | Endpoints, data model, migrations, feature flags, infra, eng risks, code snippets |

**Why asymmetric**: an engineer reading a discussion can absorb the product
context cheaply (it's the "why"). A PM or designer reading a discussion
shouldn't have to scan through endpoint names, table schemas, or FF ramp
plans to find the product decision they need to weigh in on.

**Never wrap product in a toggle if technical content stays inline.** That
inversion is the failure mode.

**Single-stratum cases**:
- Pure-product discussion → no toggles for technical (there is none).
- Pure-technical discussion (eng-only audience confirmed) → no toggles; the
  whole audience is technical.
- Quick need with mixed audience → keep product surface, toggle a technical
  reference only if unavoidable.

**Default for ambiguous cases**: assume *both*. Erring on the side of
toggling tech content is cheap; the inverse failure (jargon-bombing a PM)
is expensive.

---

### Rule 21 — Use `<details>` toggles to hide long detail

From the official Alan [Github best practices](https://www.notion.so/alaninsurance/Github-best-practices-641a77a5f73042a1a10b20e499711282):

> "Useful for sharing further details or an image on a topic without creating
> a discouraging lengthy discussion."

GitHub Discussions supports collapsible toggles via HTML:

```html
<details>
<summary>Toggle title</summary>

Amazing but hidden content 🎉

</details>
```

(Or type `/details` in the GitHub text field.)

**Critical formatting**: leave a **blank line** before and after the toggle
body. Without it, GitHub renders the body as raw HTML, not as markdown — and
your bullets, links, and tables die.

**Applied by skill**: this is the structural answer to Rule 3 ("longer issue
= slower participation"). The skill applies toggles automatically when:

| Situation | Wrap in `<details>` |
|---|---|
| Detailed implementation notes in a Framing's Context section | Yes |
| 4+ rows of historical data in a Monitoring discussion | Yes |
| Code snippets longer than 8 lines | Yes |
| Long screenshots or design mockup links | Yes |
| The "go deeper on existing experience" details (Marion 2026-06-01) | Yes — keep 3-5 bullets inline, toggle the rest |
| The 70% rationale that supports a recommendation | Yes — top-level stays the decision, toggle the why |
| Quick need — the whole point is to be short | No, toggles defeat the purpose |
| LOCI, Timeline, Scope, top of Why | No — these must stay surface |

**Suggested title format for toggle summaries**: short verb-phrase, no
markdown — e.g. `Existing Prévoyance flow details`, `Why we ruled out
Option 4`, `Raw Amplitude data (4 weeks)`. Skip "click to expand" — readers
know.

---

## Anti-pattern: the "wall of context" Framing

The combination of Rules 2, 3, 7, and 14 surfaces a specific anti-pattern
the skill must reject:

> A Framing discussion where `# 🌐 Context & Materials` is 1500+ words of
> background, with 4+ stacked H2 sub-sections, before the reader reaches
> any decision point.

**Detection**: if the Context section is longer than the Proposal section,
the discussion is upside-down.

**Fix**: extract long context into a linked Gdoc and keep only 3-5 key
bullets + the metric statement inline. The Proposal should be the heavy
section, not the Context.
