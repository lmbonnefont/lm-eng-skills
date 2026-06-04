# Grill bank — questions per discussion type

Consumed by `lm-grill-me` in caller mode. The caller passes `--section <type>`
and `lm-grill-me` pulls questions from the matching section.

All questions are designed for `AskUserQuestion` — short prompt, 2-4 concrete
options, first option = recommendation when relevant.

**Codebase-first rule applies** (from `lm-grill-me`) — if a question is
answerable by reading the code (existing convention, current implementation,
prior pattern, related Linear/GH thread), read it first and state the finding
instead of asking.

---

## Section: scoping

Goal: assess whether the topic is worth investing more time in. Keep it light
— 3-4 questions max, never more.

### Q1 — What triggered this?
- "Admin complaint(s) in a Slack thread or ticket" (Recommended if signal exists)
- "Internal observation while shipping something else"
- "Stakeholder request (specific person)"
- "Strategic / quarter goal"

### Q2 — Cost order-of-magnitude you suspect?
- "M (1-2 weeks dev)" (Recommended default)
- "S (under a week)"
- "L (3-4 weeks)"
- "XL (more than a month — probably needs Framing not Scoping)"

### Q3 — What's the green-light cost?
- "3 days on Framing" (Recommended)
- "1 day of pairing then re-decide"
- "Already enough to skip to Framing"

### Q4 — Closest existing experience in the codebase?
*Only ask if you couldn't find it via grep / xray. State the finding if you did
find one.*
- Free text — name the closest flow (e.g., "Prévoyance auto-close cron")

---

## Section: framing

The heaviest grill. Walk down the JTBD + Marion-test branches. 8-12 questions
across 3-4 batches.

### Batch 1 — Problem framing

**Q1.1 — Who has the job-to-be-done?**
- "OH admin (employer HR)" (Recommended if context suggests)
- "OH employee (the worker stopped)"
- "Alan ops (internal user)"
- "Multiple — split the discussion per persona"

**Q1.2 — What's the JOB (verb + object + context)?**
*State your best guess as Option 1.*
- "<Verb> <object> <context>" (Recommended — your draft)
- "Different verb suggested by user"
- "Different scope suggested by user"

**Q1.3 — How will we measure progress on this job?**
- "Adoption rate of the new flow" (Recommended for new features)
- "Reduction in time-to-complete-task"
- "Reduction in error rate / ops tickets"
- "Qualitative feedback only (NPS, Slack threads)"

### Batch 2 — Existing experience (Marion 2026-06-01)

**Q2.1 — Closest existing flow in admin?**
*Try to answer via xray / grep first. If you found one, state the finding and
ask Q2.2 instead.*
- Free text or pre-filled if found

**Q2.2 — What works / doesn't work in that existing flow?**
*Open-ended — single textbox answer.*

**Q2.3 — Constraints inherited from the existing flow?**
- "Same data model (extend existing tables)" (Recommended default)
- "New parallel data model (existing stays untouched)"
- "Migration of existing data needed"
- "No data constraint — pure UI"

### Batch 3 — Options

**Q3.1 — How many distinct options should I lay out?**
- "3 options including a do-nothing baseline" (Recommended — Marion test)
- "2 options (the only two that make sense)"
- "More than 3 — pick top 3 to surface"

**Q3.2 — For each option, what's the dimension that differentiates them?**
- "User-facing flow shape (single vs multi-step)" (common)
- "Where the data lives (existing model vs new)"
- "Sync vs async (instant vs backgrounded)"
- "Manual vs automated"

**Q3.3 — Your recommended option?**
*Don't accept "happy to discuss" — Marion test requires a position.*
- "Option 1" / "Option 2" / "Option 3"

### Batch 4 — Ask

**Q4.1 — What kind of input do you need?**
- "Decision sign-off on the recommended option" (Recommended)
- "Specific input on a sub-question"
- "Heads-up only (FYI, no action expected)"
- "Sanity-check before I start building"

**Q4.2 — Who specifically needs to weigh in?**
*Open-ended — names, not roles. "Marion, Elodie" not "EM + designer".*

**Q4.3 — By when do you need the answer?**
- "End of week" (default for Framing)
- "Next standup"
- "End of next week"
- "No hard deadline"

---

## Section: making

V0 alignment grill. 6-8 questions, focused on cuts and acceptance.

### Q1 — Is the audience cross-discipline?
- "Yes — eng + design + ops + PM" (triggers Product/Tech split)
- "Eng only"
- "Eng + 1 non-eng stakeholder"

### Q2 — V0 cuts you're worried about?
*Open-ended.*

### Q3 — Out-of-scope decisions (deliberate cuts)?
*Multi-select, 2-4 items.*
- "Edge case X (deferred to V1)"
- "Persona Y (V0 covers only persona A)"
- "Channel Z (V0 web only, no app)"
- "Metric M (no tracking in V0)"

### Q4 — Feature flag strategy?
- "Single FF, ramp to 100% over 1 week" (Recommended default)
- "Multiple FFs (one per sub-feature)"
- "No FF — direct ship"
- "FF + cohort gating (specific accounts first)"

### Q5 — Acceptance criteria — how do we know V0 is done?
*Open-ended, expect 3-5 checklist items.*

### Q6 — Whose sign-off is blocking ship?
*Open-ended, names.*

### Q7 — Risk you most want surfaced?
*Open-ended. One risk, not five.*

---

## Section: quick-need

Minimum viable grill — 1-2 questions, no batching.

### Q1 — What kind of need is this?
- "Open question to the team — no decision expected" (Recommended)
- "Heads-up — I'm doing X, flag if you disagree"
- "Small ask — specific micro-decision"

### Q2 — Who's the closest person to weigh in?
*Open-ended, names. If user already named someone in the prompt, skip this Q.*

---

## Caller mode contract

After the grill, return JSON:

```json
{
  "questions_asked": [
    {"question": "...", "options": ["...", "..."], "chosen": "..."}
  ],
  "unresolved": ["any question the user explicitly deferred"],
  "decisions_summary": "1-2 sentence recap, e.g. 'Framing for OH admins to declare WS in <5 clicks. Recommended Option 2 (modal in dashboard). Ping Marion + Elodie by EoW.'"
}
```

The caller (`lm-draft-github-discussion`) uses `decisions_summary` to seed the
Problem and Ask sections, and `questions_asked` to seed the Options section.
