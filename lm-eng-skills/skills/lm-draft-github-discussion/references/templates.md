# GitHub Discussion templates (Alan convention)

Templates aligned with the official Alan format. Sources:
- Notion: [Making decisions on Github](https://www.notion.so/alaninsurance/Making-decisions-on-Github-ec89a8f05c954f4cbdf5ecd3663d2763) (canonical guide)
- Notion: [Methodological tips](https://www.notion.so/alaninsurance/Methodological-tips-ce3dc3e49cbf4b9ab8bf219d5e8e13be) (driving + writing tips — see `alan-methodology.md`)
- Real examples:
  - [#32972 Granularity needs and constraints](https://github.com/alan-eu/Topics/discussions/32972)
  - [#33030 Standalone subscribers Framing](https://github.com/alan-eu/Topics/discussions/33030)

Alan convention is **6 H1 sections** with emoji prefixes + a `### Threads`
checkbox at the end. Don't deviate from this skeleton — readers expect it
and notifications previews depend on it.

All output in **English**. Domain terms FR (DSN, SIRET, AMT, Prévenir, etc.)
stay inline in French — Alan convention.

## Use `<details>` toggles to compress long content

When a section starts feeling long (especially `# 🌐 Context & Materials`
or `# 💡 Proposal` rationale), wrap the deep dive in a `<details>` toggle.
Keeps the top of the discussion scannable while still putting the substance
on-page. See `alan-methodology.md` Rule 21 for the canonical pattern and
when-to-apply table.

```html
<details>
<summary>Short verb-phrase title</summary>

Markdown content with a blank line above and below.

</details>
```

The blank lines around the body are mandatory — without them GitHub
suppresses markdown rendering inside the toggle.

## Title format (canonical — from Notion guide)

```
[<Crew/Area/Community/Unit>] <Subject> - <STEP> - <Title>
```

- **Crew/Area/Community/Unit**: e.g. `[OccHealth Setup]`, `[Occupational Health]`,
  `[Health Partner XP]`, `[Prévenir]`.
- **Subject**: try to make it 1 word. Caps only for acronyms (should be rare).
- **STEP** (optional, skip if it fits no specific step):
  - `Scoping` — understand the problem to solve
  - `Framing` — identify solutions to solve the problem
  - `Making` — deliver the agreed solutions
  - `Monitoring` — assess whether the delivered solution is solving the problem
- **Title**: descriptive title.

**Proper case, not all-caps.** Use `Framing`, not `FRAMING`.

**Example** (from the official Notion guide):
`[Health Partner XP] Back Pain - Making - Program enrollment experience`

## Labels (replaces categories — from Notion guide)

> "As we will no longer have categories, it is crucial to be diligent in
> applying the right labels so all Alaners can easily find what they are
> looking for!"

Apply at least one label from this list (based on the unit):

- 🇧🇪 Belgium
- ✨ Corporate and People
- 💼 Customer
- 🧱 Foundation
- 🇫🇷 France
- 🌍 International Expansion
- 🧑 Member
- 🇪🇸 Spain
- 🛤️ Transversal
- 🇨🇦 Canada

For LM's Occupational Health work → 🇫🇷 France (and optionally 🧑 Member
if member-facing).

---

## Common skeleton — every type

````markdown
<!-- 
* Should you open a discussion? In doubt check: https://www.notion.so/alaninsurance/How-we-make-decisions-9db7efd39c794f5faff5c645848d863f
* Full documentation: https://www.notion.so/alaninsurance/Issues-on-Github-ec89a8f05c954f4cbdf5ecd3663d2763#0c64466f756a496399d69afce718c5f9
-->

# 🔭 Scope

- The goal of this issue is to align on **<topic>**
- This issue is **NOT** about: <out-of-scope items>

# 🕐 Why I'm opening this discussion

<2-4 sentences. Link to the Linear project / quarter goal that triggered this.>

# 📅 Timeline

<Decision expected by <date>. Or: I want to close this issue by <date>.>

# ℹ️ LOCI

- **Lead & Owner**: @<your-github-handle>
- **Consulted**: @<name1> @<name2> @<team-handle>
- **Informed**: <audience description, e.g. "OccHealth area">

# 🌐 Context & Materials

- <links to prior discussions, Linear projects, specs, Google Docs>
- **<bold note about a load-bearing dependency or risk>**

<Optional H2 sub-sections for deeper context:>
## <Sub-topic 1>
## <Sub-topic 2>

# 💡 Proposal

<Per-type — see sections below.>

### Threads
- [X] Please use threads
- [ ] Do not use threads
````

The `### Threads` block at the very end is the **format declaration** —
verbatim, with the appropriate checkbox ticked. Default to `[X] Please use
threads` (Alan convention for most discussions). Use `[ ] Do not use threads`
only when the discussion is highly linear (e.g. an announcement, or a short
Quick need).

### Common rules

1. **Keep the HTML comment at the top** — verbatim, helps newcomers calibrate.
2. **Title format**: see "Title format" section above. `[<Area>] <Subject> -
   <STEP> - <Title>`. Proper-case STEP (`Framing`, not `FRAMING`). STEP is
   optional.
3. **Labels** (replaces categories): see "Labels" section above. Apply at
   least one from the canonical list.
4. **LOCI is mandatory.** Lead & Owner = one person (not a team handle).
   Consulted = named people whose input is a **must-have**. Informed =
   broader audience; ping them **only at conclusion**, not in the OP (Alan
   methodology rule).
5. **Emoji prefixes are part of the H1.** `# 🔭 Scope`, not `## 🔭 Scope`
   or `# Scope 🔭`. Position matters for scannability.
6. **`### Threads` checkbox at the end**, verbatim with one box ticked.
7. **No em-dashes.** Use `:`, `.`, `,`.
8. **No double-ping in Slack** when opening (Alan rule from "Making
   decisions on Github" Notion). GitHub notifications cover the LOCI.

---

## 1. Scoping discussion

**When**: very early — is this worth investing in?

**Length**: short. The Scope + Why sections + a tight Proposal listing open
questions. Don't pad.

**Title**: `[<Area>] <Subject> - Scoping - <Topic>`

### Type-specific content

#### `# 🔭 Scope`

- The goal of this issue is to **assess whether \<topic\> is worth investing more time in**
- This issue is **NOT** about defining the solution — just sizing the
  opportunity and the cost

#### `# 💡 Proposal`

````markdown
# 💡 Proposal

**Problem signal**: <1 sentence — what we're observing>
**Cost order-of-magnitude (T-shirt)**: <S / M / L / XL>
**Decision I'm asking for**: green-light to spend <X days> on Framing, or drop.

## What I've explored so far

- <bullet — existing experience reference>
- <bullet — prior ticket / discussion>
- <bullet — closest flow in the codebase>

## Open questions before committing

- <question 1>
- <question 2>
````

### Example title

`[Occupational Health] Work Stoppages - Scoping - Auto-close on return date`

---

## 2. Framing discussion

**When**: problem is validated. Align on the angle + surface options +
get input. **This is where Marion 2026-06-01's feedback applies most.**

**Length**: long-form. All 6 H1 sections filled out. Proposal is the heaviest.

**Title**: `[<Area>] <Subject> - Framing - <Problem statement in plain English>`

### Type-specific content

#### `# 🔭 Scope`

- The goal of this issue is to align on **\<the angle for solving \<problem\>\>**
- This issue is **NOT** about: <what's deliberately out of scope, e.g. "the
  technical implementation — that comes in a separate Making discussion">

#### `# 🌐 Context & Materials` — required sub-sections

````markdown
# 🌐 Context & Materials

- <link to Linear project>
- <link to prior discussions>
- **<bold dependency note>**

## Existing experience (what we already do)

<Marion 2026-06-01: "On admin topics, we are rarely building from zero.">
Keep 3-5 bullets inline. Wrap the deeper dive in a toggle.

- <closest existing flow + screenshot or link>
- <what works in it, what doesn't>
- <constraints inherited from it>

<details>
<summary>Deep dive on the existing experience</summary>

<Detailed walkthrough, edge cases observed, internal Slack threads,
links to admin screenshots. Markdown works inside as long as blank lines
surround this content.>

</details>

## How we'll measure progress

<Outcome statement: Direction + Unit of measure + Object + Context.
Example: "Minimize the number of clicks to declare a single work stoppage
while on the OH admin dashboard.">
````

#### `# 💡 Proposal`

````markdown
# 💡 Proposal

**Problem (JTBD format)**: <Verb> <Object> <Context>
> Example: Help OH admins **declare a work stoppage** for an employee
> **without leaving the dashboard**.

**Recommendation**: I'd go with **Option \<N\>** — see rationale below.

## Options I see

| # | Option | Trade-offs (product) | Effort |
|---|---|---|---|
| 1 | <Option A> | <product-level pros / cons> | S/M/L |
| 2 | <Option B> | <product-level pros / cons> | S/M/L |
| 3 | <Option C — usually a do-nothing baseline> | <product-level pros / cons> | S/M/L |

<!-- For mixed audiences, technical trade-offs go in a toggle so PMs see
     only the product trade-offs in the main table (Rule 22). -->

<details>
<summary>Technical trade-offs per option</summary>

| # | Backend impact | Frontend impact | Data model | Migration risk |
|---|---|---|---|---|
| 1 | <details> | <details> | <details> | <details> |
| 2 | <details> | <details> | <details> | <details> |
| 3 | <details> | <details> | <details> | <details> |

</details>

## Why Option \<N\>

- <reason 1 — top-level, decision-driving>
- <reason 2 — top-level, decision-driving>
- <reason 3 — top-level, decision-driving>

<details>
<summary>Detailed rationale and ruled-out alternatives</summary>

<Longer rationale: cost breakdowns, why options A and B were ruled out,
edge cases the recommendation handles. Inline-able if short — toggle
once it crosses ~6 bullets or 10 lines.>

</details>

## Decision / input I'm asking for

- @<consulted-1>: <specific question or sign-off needed>
- @<consulted-2>: <specific question or sign-off needed>

## Open questions (not blocking the decision)

- <Q1>
- <Q2>
````

### Critical rules for Framing

1. **Always 3 options minimum**, including a do-nothing baseline. Single-option
   framing = no real decision being made.
2. **State the recommendation explicitly.** Marion 2026-06-01: openness to
   revisit ≠ no conviction. Take a position.
3. **Per-person questions in Decision section** — not "thoughts?". Each
   Consulted person from LOCI gets a specific ask.
4. **Outcome statement in Context & Materials** — it's the measurable success
   criterion. Don't bury it.

### Threaded variant (multiple sub-decisions)

When a Framing carries **≥2 independent sub-decisions** (each with its own legal basis,
data, or option set), don't cram them into one inline Proposal. Switch to the **thread
architecture**: `# 💡 Proposal` becomes a thin index, and each sub-decision lives in its own
top-level comment, ordered for progressivity (foundation → narrowing → mechanism → edge cases
→ artifact → `Other` last). Canonical example:
[#33399](https://github.com/alan-eu/Topics/discussions/33399). Full pattern, thread skeleton,
and posting sequence: `thread-architecture.md`. The inline template above stays the default
for single-decision Framings.

### Example title

`[OccHealth Setup] Work Stoppages - Framing - Re-open a wrongly-closed stoppage`

---

## 3. Making discussion

**When**: angle chosen (post-Framing). Align on V0 scope + plan.

**Length**: medium. All 6 H1 sections, but Proposal is structured around V0
cuts rather than options.

**Title**: `[<Area>] <Subject> - Making - <Feature/Project name> V0 scope and plan`

### Type-specific content

#### `# 🔭 Scope`

- The goal of this issue is to align on **the V0 scope and plan for \<feature\>**
- This issue is **NOT** about: <re-opening the framing decision, V1 features>

#### `# 💡 Proposal`

````markdown
# 💡 Proposal

**Building**: <1 sentence>
**Why V0 is this and not more**: <constraint that bounds the scope>

## V0 scope

### In scope
- <bullet>
- <bullet>

### Out of scope (deliberate)
- <bullet — why deferred to V1>
- <bullet — why deferred to V1>

## Product side

<For PMs, designers, ops. No jargon. Top-level — stays inline regardless of audience.>
- User-facing flow: <describe>
- Edge cases handled: <list>
- Edge cases NOT handled in V0: <list with reason>

<!-- If audience is "both" (mixed product + technical), wrap Technical side
     in a <details> toggle so PMs/designers can ignore it (Rule 22 of
     alan-methodology.md). If audience is pure-technical, leave inline. -->

<details>
<summary>Technical side</summary>

<For engineers. OK to go deep — but stay scannable.>
- Backend: <touched components, new endpoints, migrations>
- Frontend: <touched modules, new screens>
- Data model: <new tables / columns, if any>
- Feature flag: <FF name + ramp plan>
- Risks: <bullets>

</details>

## Milestones

| Date | Milestone | Owner |
|---|---|---|
| <date> | <milestone> | @<owner> |
| <date> | <milestone> | @<owner> |

## Acceptance criteria

- [ ] <criterion>
- [ ] <criterion>

## What I need from you

- @<consulted-1>: <approval / heads-up / specific input>
- @<consulted-2>: <approval / heads-up / specific input>
````

### Critical rules for Making

1. **Product/Technical strata (asymmetric)** — see Rule 22 in
   `alan-methodology.md`. When audience is mixed (eng + product), Product
   side stays inline (top-level), Technical side is wrapped in a `<details>`
   toggle so PMs/designers aren't asked to scan eng jargon. Tech-side
   readers always read product as context, so the inverse wrapping never
   applies. Skip the toggle entirely for eng-only audiences.
2. **"Out of scope (deliberate)" is louder than "In scope".** That's where
   misalignment surfaces.
3. **Acceptance criteria as a checkbox list** — readers can verify, not just
   nod.

### Example title

`[Occupational Health] Work Stoppages - Making - Auto-close V0 scope and plan`

---

## 4. Monitoring discussion

**When**: post-ship — assess whether the delivered solution is actually
solving the original problem.

**Length**: short to medium. Driven by data, not by options.

**Title**: `[<Area>] <Subject> - Monitoring - <Feature> N weeks after ship`

### Type-specific content

#### `# 🔭 Scope`

- The goal of this issue is to assess whether **\<feature\>** is solving the
  problem we framed in [link to original Framing discussion]
- This issue is **NOT** about: building a V2 yet — we decide V2 only if the
  data says we should

#### `# 🌐 Context & Materials` — required sub-sections

````markdown
# 🌐 Context & Materials

- <link to original Framing discussion>
- <link to original Making discussion>
- <link to Amplitude dashboard / Grafana board / SQL query>

## Original success metric

<Copy verbatim the Outcome statement from the Framing discussion.>

## What we shipped vs what we framed

- Shipped in V0: <bullet>
- Deferred to V2 (as planned): <bullet>
- Unexpected cuts during execution: <bullet>
````

#### `# 💡 Proposal`

````markdown
# 💡 Proposal

**Verdict**: <one of: Working / Partially working / Not working / Too early to tell>

## Data

| Metric | Target (from Framing) | Actual | Status |
|---|---|---|---|
| <metric 1> | <target> | <actual> | ✅ / 🟡 / ❌ |
| <metric 2> | <target> | <actual> | ✅ / 🟡 / ❌ |

## What I'm seeing

- <observation 1 — with link to chart>
- <observation 2 — with link to chart>

<details>
<summary>Raw data and breakdowns</summary>

<Full data tables, per-cohort splits, screenshots of Amplitude charts.
Toggle these so the verdict and the 2-3 headline observations stay
above the fold.>

</details>

## What I propose next

- <option A: keep monitoring / option B: open a V2 Framing / option C: roll back>

## Decision / input I'm asking for

- @<consulted-1>: <specific question>
````

### Critical rules for Monitoring

1. **Compare against the original framing's metric**, not a new one
   invented post-hoc. If the original metric was unmeasurable, that's a
   lesson for the next Framing — name it explicitly.
2. **State a verdict upfront** in the Proposal. Vague "data is interesting"
   wastes readers' time.
3. **Link the charts.** Screenshots are OK as a backup but live links let
   readers verify.

### Example title

`[Occupational Health] Work Stoppages - Monitoring - Auto-close 4 weeks after ship`

---

## 5. Quick need

**When**: open question to the team. No options yet, no decision request — just
"here's what I'm wondering, what do you think?".

**Length**: short. The 6 H1 sections collapse — Scope, Why, LOCI minimal,
Proposal is the question itself.

**Title**: `[<Area>] <Subject> - <Open question in plain English>` (no STEP — Quick needs don't fit a specific phase)

### Type-specific content

#### Compressed skeleton

````markdown
<!-- 
* Should you open a discussion? In doubt check: https://www.notion.so/alaninsurance/How-we-make-decisions-9db7efd39c794f5faff5c645848d863f
* Full documentation: https://www.notion.so/alaninsurance/Issues-on-Github-ec89a8f05c954f4cbdf5ecd3663d2763#0c64466f756a496399d69afce718c5f9
-->

# 🔭 Scope

- The goal of this issue is to **get the team's input on \<the open question\>**
- This issue is **NOT** about: making a decision yet

# 🕐 Why I'm opening this discussion

<1-2 sentences. What triggered the question.>

# ℹ️ LOCI

- **Lead & Owner**: @<your-github-handle>
- **Consulted**: @<name1> @<name2>
- **Informed**: <audience>

# 💡 Proposal

**My open question**: <the actual question>

<Optional: 2-3 bullets of context or what I've already considered>

Curious what you all think — especially @<closest-person> who's closest to this.
````

### Critical rules for Quick need

1. **No fake structure.** Skip `# 📅 Timeline` and `# 🌐 Context & Materials`
   unless they add real value. The 6-section skeleton is a guideline, not a
   straitjacket — Quick needs are the exception.
2. **Still LOCI.** Even open questions need a clear "who decides if we go
   somewhere with this".
3. **No TYPE prefix in the title** — Quick needs look weird with "FRAMING" or
   "MAKING" in the title.

### Example title

`[Occupational Health] AMT - Should declare-reason map differently for self-employed (TNS)?`

---

## Choosing the right template — decision tree

```
Has the feature already shipped?
├── Yes → MONITORING template (is it solving the problem?)
└── No
    │
    Is the problem itself validated?
    ├── No → SCOPING template
    └── Yes
        │
        Has the angle / approach been chosen?
        ├── No → FRAMING template (Marion test target — biggest)
        └── Yes
            │
            Are you asking for V0 sign-off / plan approval?
            ├── Yes → MAKING template
            └── No (open question, vague need) → QUICK NEED template
```

When unsure between two — go shorter. Marion 2026-06-01: "starting from a
blank page can be tough" — better to ship a Quick need today than spend 2
days on a Framing that should have been a Scoping.

---

## Marion test mapping (where clarity lives in the Alan template)

Marion's feedback ("clarity in first 3 lines") maps onto the Alan template
this way:

| Marion test item | Where it lives in the Alan template |
|---|---|
| **What problem are we solving?** | `# 🔭 Scope` bullet 1 ("The goal of this issue is to align on **X**") |
| **What's NOT the problem?** | `# 🔭 Scope` bullet 2 ("This issue is **NOT** about Y") |
| **Why now?** | `# 🕐 Why I'm opening this discussion` |
| **By when?** | `# 📅 Timeline` |
| **Who decides? Whose input?** | `# ℹ️ LOCI` |
| **How will we measure progress?** | `# 🌐 Context & Materials > ## How we'll measure progress` (Framing only) |
| **What do I recommend?** | `# 💡 Proposal > ## Why Option N` (Framing) or `# 💡 Proposal > **Building**` (Making) |
| **What input do I need?** | `# 💡 Proposal > ## Decision / input I'm asking for` with per-person asks |

If a reader stops after `# ℹ️ LOCI`, they should already know: problem, why
now, by when, who decides. The Proposal is the depth — but the top 4 sections
are the **Marion clarity line**.
