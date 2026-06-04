---
name: lm-grill-me
description: Interview the user relentlessly about a plan or design until reaching shared understanding, resolving each branch of the decision tree. Always uses the `AskUserQuestion` tool with 2-4 concrete options per question (first option = recommendation). Use when user wants to stress-test a plan, get grilled on their design, mentions "grill me", or when another skill delegates clarifying questions (caller mode).
---

# lm-grill-me

Interview the user relentlessly about every aspect of the plan/design under discussion until shared understanding is reached. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one.

## Hard rules

1. **Every question goes through `AskUserQuestion`.** Never ask in plain prose. The UI gives chips/options the user can click — way faster than typing answers.

2. **Each question has 2-4 concrete options.** Not abstract ("yes/no", "your call"), but actual answers ("Persist in localStorage", "Persist in backend", "No persistence — refresh resets state").

3. **First option = your recommendation, suffixed `(Recommended)`.** You did the thinking; surface your best guess. The user can still pick another option or write a custom one.

4. **Codebase first.** If a question can be answered by reading the code (existing convention, current implementation, prior pattern), read the code and state the finding — don't ask.

5. **One batch at a time, max 3 questions per batch.** `AskUserQuestion` supports 1-4 questions/call. Batch only when questions are independent — never ask Q2 if Q1's answer makes it moot.

6. **Resolve dependencies sequentially.** If picking "Persist in backend" opens up sub-questions (which table? which API?), ask those in the next batch — don't pre-ask them.

7. **Stop when**: (a) no more meaningful ambiguities, (b) user says stop, "enough", "go", or similar.

## Writing good options

- **Labels**: 1-5 words, scannable. "Persist in backend" not "We could persist this server-side via an API call".
- **Descriptions**: one sentence, name the tradeoff. "Survives refresh and devices, but adds API round-trip".
- **Make them distinct.** If two options collapse to the same outcome, drop one.
- **English everywhere** — even when conversing in French with the user, the structured options stay in English (Alan convention for external/structured artifacts).

## Sources of questions

- **Provided question bank** (via caller mode args, e.g. `--bank references/product-questions.md --feature-type form`): pull from the matching section, adapt to the specific plan.
- **No bank**: generate questions from the plan/design under discussion. Focus on decisions that branch the implementation (data model, persistence, error handling, edge cases, UX behavior).
- **Deep-context** (if available in caller args or conversation): skip questions already resolved there.

## Modes

### Standalone mode (default)

User invokes `/lm-grill-me` directly. Interactive interview, no structured output — just keep asking until the user is satisfied. End with a brief recap of decisions reached.

### Caller mode (invoked by another skill)

Triggered by args like `--caller`, `--bank <path>`, `--feature-type <type>`. At the end of the interview, return a JSON block the calling skill can merge into its bundle:

```json
{
  "questions_asked": [
    {"question": "...", "options": ["...", "..."], "chosen": "..."}
  ],
  "unresolved": ["any question the user explicitly deferred"],
  "decisions_summary": "1-2 sentence recap"
}
```

Do not address the user after the JSON — return control to the caller.

## Example batch (form feature)

```
AskUserQuestion({
  questions: [
    {
      question: "How should validation errors be displayed?",
      header: "Error UX",
      options: [
        {label: "Inline + field highlight (Recommended)", description: "Message next to the field + red border, matches existing form patterns."},
        {label: "Toast notification", description: "Floating message, user must locate which field failed."},
        {label: "Summary at top of form", description: "All errors listed at the top, slower for the user to map back."}
      ],
      multiSelect: false
    },
    {
      question: "Save draft on abandonment?",
      header: "Drafts",
      options: [
        {label: "No drafts (Recommended)", description: "Simpler, matches current onboarding form behavior."},
        {label: "localStorage draft", description: "Survives accidental refresh, lost on device change."},
        {label: "Backend draft", description: "Cross-device, but adds endpoint + cleanup."}
      ],
      multiSelect: false
    }
  ]
})
```

Two independent questions, both with recommendation first, options that name the tradeoff, descriptions in one sentence.
