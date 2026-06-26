---
name: lm-write-readable
description: "Write-time readability guidance — applies clean-code rules WHILE coding, not as a post-hoc review. Loads readability rules before writing, then runs one self-critique pass on the just-written code and applies fixes. Use whenever you are about to write or are writing non-trivial backend Python or frontend TypeScript/React in alan-apps: 'write this cleanly', 'make this readable', 'code this feature', 'implement X readably', or any implementation where human-readability matters. Also invoked in caller mode from lm-guided-feature-development step 6b (between implementation and the 6c reviews). NOT a reviewer: it never scans a diff, hunts bugs, or audits conventions — /review and /lm-local-compliance-review own that. Skip for one-line edits, config tweaks, or generated code."
---

# Write Readable

## North star: this code will be read by a human

Every line you write here will be read, out loud in review and silently months later, by a human who does not have your context. **The supreme value is how fast that human understands the code.** Not how clever it is, not how few lines it takes, not how elegant the abstraction feels — how quickly a tired teammate at 5pm grasps what it does and trusts it's correct.

This reframes the whole job. You are not writing instructions for a machine that happens to be readable. You are writing an explanation, for a person, that happens to execute. The reader is the customer. Optimize for their first-read comprehension above all else.

Concretely, this means:

- **When two correct versions exist, ship the one a stranger understands faster** — even if it's longer, even if it repeats a little, even if the "smart" version would impress.
- **When a rule below conflicts with comprehension, comprehension wins.** The rules are heuristics that usually produce understandable code; they are not the goal. The goal is the human's understanding.
- **The test is literal**: could you paste this function to a teammate and have them explain it back correctly, on first read, without you narrating? If not, it's not done — rewrite it until they could.

Make this readable **as you write it**, not in review afterward. The earlier comprehension is baked in, the less the reviewer (and future-you) has to untangle. This skill front-loads a small set of rules, then makes you re-read your own output once — through the eyes of that human reader — before moving on.

## Scope — what this skill is and is not

This is a **write-time** skill. It runs in two moments only: just before you code, and right after. It deliberately does **not**:

- scan a diff or a branch
- hunt for bugs or logic errors
- audit Alan conventions or naming consistency against sibling files

Those belong to `/review` (bugs/quality) and `/lm-local-compliance-review` (conventions). Trying to do them here just duplicates work and bloats the pass. Stay in your lane: the single question is *"is this code easy for a human to read?"*

## The mechanism

### Phase 1 — Load before coding

Before writing the implementation, read the rule reference for the layer you're about to touch:

- Backend Python → `references/python.md`
- Frontend TypeScript / React → `references/typescript.md`
- Both layers in one task → read both.

These hold the concrete, language-specific rules. The four rule families below are the shared spine; the references make them actionable per language.

Then write the code with those rules in mind. The goal is not to slow down — it's to avoid the default LLM failure mode of dense, clever, deeply-nested code that technically works but reads like a puzzle.

### Phase 2 — Self-review pass (the core of this skill)

Right after you finish a coherent unit (a function, a component, a module — not after every line), re-read it once asking only: *would a teammate understand this on first read?*

Apply fixes **directly** — don't ask permission, don't list options. Then print a short summary so the user sees what changed and learns the pattern:

```
Readability pass: <2-3 lines, what you improved and why>
```

Example:
```
Readability pass:
- Extracted the nested establishment-lookup into `find_active_establishment()` (was 3 levels deep).
- Named the `is_eligible_for_renewal` boolean instead of inlining the condition in the `if`.
```

If nothing needed changing, say so in one line — that's a valid outcome, don't invent changes to look busy.

Keep the pass proportional: a 5-line helper doesn't need a summary paragraph. Readability is the goal, not ceremony.

## The four rule families

These are the shared principles. The language references turn each into concrete guidance.

### 1. Naming & self-documented intent

The strongest readability lever. Code should explain itself through names, so comments become rare.

- Names state intent, not mechanism: `active_establishments`, not `data` or `result`.
- Extract a named intermediate variable instead of inlining a complex expression — even if it adds a line. Readability beats line count.
- Extract a boolean condition into a named variable: `is_eligible = ...` then `if is_eligible:` reads better than a 3-clause `if`.
- Prefer self-documenting code over inline comments. Reserve comments for the *why* that code can't express (a non-obvious constraint, a workaround rationale) — never to restate *what* the code does.

### 2. Function & component structure

Small, single-purpose units read faster than large multi-purpose ones.

- One function does one thing. If you need "and" to describe it, split it.
- Early-return to flatten nesting. Guard clauses at the top beat an `else` ladder.
- Keep the happy path at the lowest indentation level.
- A function long enough to need section comments is two functions.

### 3. Simplicity & YAGNI

Less code is less to read. Build only what the task needs (aligned with the repo's "Surgical changes" and "Code quality" rules in CLAUDE.md).

- No abstraction for single-use code. A helper called once is usually just inline code with a name — only extract if the name genuinely clarifies.
- No defensive code for cases the types/framework already rule out. Validate only at real boundaries (user input, external APIs, file I/O).
- No unrequested flexibility or configurability.
- Touch only what the task requires. Don't "improve" adjacent code in the same pass.

### 4. Frontend-specific (React)

See `references/typescript.md` for the full set; the headline moves:

- Extract logic into hooks; extract the largest *pure* subtree into components (not tiny prop-passthrough wrappers).
- Readable conditional rendering: pull complex JSX conditions into named booleans.
- Typed, named props — no inline anonymous prop shapes that hide intent.

## Alan-specific rules to honor (pointers, not duplication)

This skill is Alan-aware. While writing, respect these — they live in the repo / your memory, so follow the source of truth rather than a stale copy:

- **Backend**: `backend/.ruler/python_guidelines.md` (esp. the *7 Coding Rules* and *Specs of a business logic method*), `backend/.ruler/python_type_hints.md`. Type hints + docstrings are mandatory.
- **Frontend**: `frontend/.ruler/frontend_guidelines.md` (Component extraction, Naming conventions, Export conventions), `frontend/.ruler/typescript_documentation.md`.
- **Docstrings (Python)**: mandatory on every function, but **synthetic** — describe current I/O only. No migration/bug history, no reference to callers/frontend/UI/tags. (User memory: synthetic docstrings.)
- **No plain tuples** — return a `NamedTuple`. (User memory.)
- **Readability over line count** — named intermediate variables + sequential steps beat compact comprehensions, even when longer. (User memory.)

When this skill's generic rule and an Alan ruler rule both apply, the Alan rule wins — it's the local convention.

## Caller mode (from lm-guided-feature-development step 6b)

When invoked with `--caller` from the guided feature workflow, you run *inside* the implementation step, on code being written in this same session (not a saved diff). Behavior:

1. Run Phase 1 + Phase 2 as above on the code just implemented in 6b.
2. Apply fixes directly.
3. Return one consolidated readability summary (the Phase 2 block), then hand control back. Do not address the user further or start the 6c review — that's the caller's next step.

No structured JSON is needed; the summary text is the contract.

## Why this exists

Reviews catch what's already wrong; they don't make you write it right the first time. By the time `/review` flags a 4-level-deep function, the cost is already paid — the reviewer read it, you re-read it, you rewrite it. Baking readability in at write-time collapses that loop. This skill is the cheap upstream habit that makes the downstream reviews shorter.
