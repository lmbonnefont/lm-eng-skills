---
name: lm-skill-retro
description: Run a Five Whys post-mortem on a skill that made a mistake, then hand off to skill-creator to patch the skill so it doesn't repeat. Use whenever the user reports that a skill produced a wrong result, missed a signal, made a bad recommendation, or otherwise failed — phrases like "le skill X a fait une erreur", "/lm-skill-retro", "/skill-retro", "post-mortem du skill", "pourquoi le skill a raté", "améliore le skill X avec ce retour", "le skill a oublié Y", "skill failure", "skill mistake", "retro on skill", or any honest retrospective the user shares about a recent skill output that was wrong. Also trigger proactively right after the user describes a skill failure even if they don't explicitly ask for a retro — this is the right next step. Do NOT use for: code bugs (use /lm-debug-5whys), feature design issues, or first-time skill creation (use /skill-creator directly).
---

# lm-skill-retro

Post-mortem a skill failure with the Five Whys, then patch the skill. The aim is to convert one painful retro into a durable rule the skill carries forward, so the same class of mistake doesn't repeat.

This is a **meta-skill**: the artifact under analysis is another skill's `SKILL.md`, and the "code" being debugged is the prompt that drove the failure. Five Whys works here for the same reason it works on code bugs — surface symptoms point at one thing, the actual cause lives upstream.

## When to invoke

- User explicitly asks for a retro on a skill: `/lm-skill-retro`, "post-mortem du skill X", "pourquoi le skill a raté"
- User shares an honest retro of a recent skill output ("Retro honnête, deux causes : 1. … 2. …") — this is the strongest signal
- User says "améliore le skill X avec ce retour" — the retro has already been written, jump straight to step 3 (extract root causes) and skip the interview
- User reports a skill produced a wrong/missed/dangerous result, even without using the word "retro"

If the user just wants to add a feature to a skill without a failure context, use `/skill-creator` directly. This skill is specifically for the failure → root-cause → patch loop.

## Workflow

### 1. Identify the skill and capture the failure

Ask (or extract from context):
- **Which skill failed?** Path to the `SKILL.md` if you can locate it, or the slash command name.
- **What did the skill output / decide?** Concrete: the file written, the recommendation given, the action taken.
- **What was the correct outcome?** What should have happened instead.
- **What context was the skill operating in?** The user's original prompt, relevant files, the conversation that led to the failure.

If the user already wrote a retro (multi-paragraph "here's what went wrong"), parse it directly. Don't make them re-explain — extract the failure description, expected vs actual, and any root causes they already named.

### 2. Run the Five Whys

Use the same investigation discipline as `/lm-debug-5whys`. You may invoke that skill explicitly via the Skill tool if you want its interactive cadence — pass it the failure as if it were a bug. But for skill retros the analysis is usually faster, so often you can run it inline.

Adapt the questions to the meta-context. Each "why" should target the **skill's instructions or absence thereof**, not the model's reasoning in the moment:

- *Why did the skill produce this output?* → Because it followed step N of the SKILL.md, which says X.
- *Why does the skill say X at step N?* → Because the original author optimized for the dominant case, didn't anticipate this branch, or compressed two distinct decisions into one.
- *Why was that compression possible?* → Because the skill has no rule forcing the model to split intents, or no probe for the secondary signal.
- *Why isn't there such a rule?* → Because the failure mode hadn't been observed yet, or the rule existed but in a section the model skipped.
- *Why did the model skip it?* → (often the terminal "why" — section ordering, lack of a hard trigger, ambiguous wording).

The terminal "why" is what the patch needs to address. Stop asking when the next answer would be "the skill author didn't think of it" — that's not actionable; the previous level is.

If the user already named root causes in their retro (like the lm-merge-conflict case: "1. Inventaire incomplet… 2. J'ai loupé un signal explicite dans main"), validate them rather than re-derive. Run one or two whys to make sure each named cause is the **terminal** why, not an intermediate symptom.

### 3. Map root causes to skill changes

For each root cause, name the **kind of patch** needed. Be specific — vague patches produce vague skills.

- **Missing rule** — add an explicit rule with a why and a how-to-apply.
- **Compression of decisions** — add a "never group X and Y" hard rule with an example of the failure mode.
- **Missing probe** — add a step that runs a specific search/check (grep, diff, file read) before the model commits to a recommendation.
- **Ordering / discoverability** — move a rule earlier, add a trigger phrase, or surface it in a checklist.
- **Stale heuristic** — update an existing rule that fires on the wrong signal.
- **Missing checklist** — add a pre-finalize checklist of contracts to verify.

Output the mapping as a short table:

```
| # | Root cause                                      | Patch kind            | Target section in SKILL.md         |
|---|-------------------------------------------------|-----------------------|------------------------------------|
| 1 | Hunks grouped by dominant signal, sub-intent    | Missing rule + probe  | New "rebuild from main" sub-mode   |
|   | overwritten                                     |                       |                                    |
| 2 | Memo comparator assumption invisible to merge   | Missing probe         | New step 4f. Stale-comparator      |
|   | tool                                            |                       | probe                              |
```

Show this to the user and confirm before handing off.

### 4. Hand off to skill-creator

Once the user agrees with the diagnosis and patch kinds, invoke the skill-creator skill explicitly:

```
Call: Skill(skill="skill-creator", args="améliore <skill-name> avec ces patches : <copy the table from step 3>")
```

The handoff prompt to skill-creator must include:
- The skill path being patched.
- The full original retro text from the user (don't summarize — skill-creator benefits from the raw signal).
- The root-cause → patch-kind table from step 3.
- A note that the user has already validated the diagnosis, so skill-creator can go straight to drafting the SKILL.md changes (skip the "interview" phase).

Skill-creator then handles the actual edits, eval drafting if relevant, and packaging. This skill stops here — don't duplicate skill-creator's work.

### 5. Optional — capture the failure pattern in memory

If the failure mode is a generalizable pattern (not specific to one skill), suggest saving it as a feedback memory so future skill drafting avoids the same trap. Examples worth saving:

- "When a skill makes recommendations from raw diffs, force per-hunk tagging."
- "When a skill resolves merges, add an invalidated-contracts pass before declaring done."

Don't auto-save — propose, let the user confirm.

## Why this skill exists

Skills accumulate value when their failures get encoded. Without this loop, the same retro happens monthly: the user catches a bad recommendation, fixes it manually, moves on — and the skill keeps making the same mistake for the next user / next session. The cost of one structured 10-minute retro is paid back the first time the patched skill avoids the same pothole.

The Five Whys here isn't ceremony — it's the discipline that prevents the patch from being shallow. "Add a check for X" is not a fix if the reason X was missed is structural (e.g. step ordering, no trigger, compression of decisions). The terminal why tells you which **shape** of patch is needed.

## Guardrails

- **Don't blame the model.** "The model didn't notice" is not a terminal why — it's an intermediate. Keep asking until you reach a structural answer about the SKILL.md itself (missing rule, missing probe, bad ordering).
- **Don't over-patch.** One failure = one or two targeted patches. If the retro surfaces 6 issues, address the top 2 and leave the rest as questions for the user — over-stuffing the skill makes future invocations heavier without proportional gains.
- **Don't skip the handoff.** This skill diagnoses; skill-creator patches. Keeping the boundary clean means the diagnosis is reusable across skills, and skill-creator's edit/eval machinery is reused everywhere.
- **Validate user-supplied root causes.** If the user already named the causes, run a quick why-pass to make sure they're terminal, not symptoms. Patching a symptom feels productive but doesn't prevent recurrence.
