---
name: lm-reuse-discovery
description: >
  Actively hunts for the functions, hooks, components, types, factories, and
  utils that already exist in the repo and can cover the needs of a feature
  currently being designed — to avoid duplicating what is already written.
  Breaks specs down into atomic feature needs, runs a parallel search across
  4 scopes (backend Python, frontend TS, types/schemas, tests/factories), scores
  the candidates (high/medium/low), returns structured JSON + a summary grouped
  by need with `file:line` links. Use when: `/lm-reuse-discovery`,
  "qu'est-ce qu'on peut réutiliser pour X" / "what can we reuse for X",
  "y a-t-il déjà une fonction qui fait Y" / "is there already a function that does Y",
  "trouve les helpers existants pour Z" / "find the existing helpers for Z",
  "anti-duplication check sur cette feature" / "anti-duplication check on this feature",
  "find reusable code for [feature]", "before I build X what already exists".
  Also callable in **caller mode** from `lm-guided-feature-development`
  Part 2 (Reuse Discovery step, between flow walkthrough and architecture proposal).
  Do not use for: tracing an E2E flow (use `/lm-flow-walkthrough`),
  architecture overview (use `/xray`), external library documentation
  (use `/explore-lib`).
---

# Reuse Discovery

Identifies existing code that can cover the needs of a feature currently being
designed. Goal: prevent systemic duplication (helpers, hooks, factories, types)
by searching **actively** before proposing an architecture.

**Fundamental rule**: zero trust. Every proposed candidate must point to a real
line (file:line) that has been read. Never invent a function name nor infer its
existence from the naming of a neighboring file.

## Invocation modes

| Mode | Trigger | Behavior |
|---|---|---|
| **Standalone** | `/lm-reuse-discovery <input>` | Interactive, validation gate after extracting the needs |
| **Caller** | Subagent from `lm-guided-feature-development` Part 2 | Non-interactive, returns JSON + summary, no gate |

In caller mode, the prompt must contain `"caller mode"` to disable the gates.

## Step 0 — Input resolution

Possible inputs:

| Type | Example | Strategy |
|---|---|---|
| Linear ticket | `OHSET-456` | Read `.claude/plans/feature-checkpoint-OHSET-456.md` Part 1, otherwise fetch Linear |
| Free-form specs | "endpoint that lists work stoppages filtered by date" | Use the text as-is |
| Caller mode | Subagent from Part 2 | Read the specs already extracted from the Part 1 checkpoint |

If specs are missing or ambiguous in standalone: `AskUserQuestion` "Give me the
specs (or the Linear ticket) to analyze". In caller mode, return a structured
error `{"error": "no_specs_in_checkpoint"}` rather than asking a question.

## Step 1 — Breaking down into feature needs

From the specs, extract **5–12 atomic needs** (capabilities). A need = a unit
capability that we must have to ship the feature.

**Form**: verb + domain object, short. Examples:
- `fetch employment by member_id`
- `validate IBAN format`
- `render employee picker dropdown`
- `create work_stoppage factory`
- `serialize StoppageRead schema`
- `upload file to S3 with presigned URL`

**Anti-patterns**:
- Too broad: "manage work stoppages" → break it down
- Too concrete: "add `is_validated` BOOLEAN column" → that's architecture, not a need
- Implementation-bound: "write a Flask middleware" → rephrase as a need

In **standalone**, present the list to the user via `AskUserQuestion` with
options: "List OK", "Add / remove needs" (let them type). In **caller mode**,
skip the validation.

## Step 2 — Parallel search by scope

Launch **4 `Explore` subagents in parallel** (single message, 4 calls). Each
subagent receives the full list of feature needs and a specific scope.

See `references/search-strategies.md` for the exact grep patterns per scope.

### Common prompt for each subagent

```
You receive a list of "feature needs" (atomic capabilities) for a feature
currently being designed. Your mission: for each need, identify the existing
functions / hooks / components / types / factories within your scope that can
cover that need.

Assigned scope: {scope_name}
Search patterns: see `references/search-strategies.md` section {scope_name}

Feature needs:
{numbered list}

For each need, return 0 to 5 candidates. JSON format per candidate:
{
  "need": "<need string copied verbatim>",
  "file": "<path relative to the repo>",
  "line": <line of the symbol>,
  "signature": "<signature as read, not inferred>",
  "evidence": "<1 line: why it covers the need>",
  "usage_count": <approximate number of callers via grep, or null>
}

Zero trust: read every candidate before returning it. No candidate inferred
from the file name alone. If you find nothing for a need, return [] for that
need (do not invent).
```

### The 4 scopes

| Scope | Paths | Target |
|---|---|---|
| `backend_python` | `backend/components/**`, `backend/shared/**` | BL functions, queries, controller helpers, utils |
| `frontend_ts` | `frontend/packages/**`, `frontend/shared/**`, `frontend/apps/**` (except `apps/cli`) | hooks, React components, TS utils |
| `types_schemas` | Python dataclasses, Marshmallow Schemas, shared TS types, enums | Reusable data models |
| `tests_factories` | `**/tests/factories.py`, `**/__factories__/*`, `**/fixtures/*` | Existing factories, fixtures, test helpers |

## Step 3 — Score & dedupe

See `references/scoring-rubric.md` for the full rubric.

**Score = high / medium / low** across 4 axes:
1. **Coverage**: exact (= high), partial requiring a wrapper (medium), tangential (low)
2. **Genericity**: reusable as-is (high), to extend via a parameter (medium), to fork (low)
3. **Domain proximity**: same component (high), another component in the same bounded context (medium), generic shared (medium if OK for this need)
4. **Maturity**: tested + multi-call-sites (high), single call site (medium), recent / untested (low)

Final score = min of the 4 axes (the weakest link decides).

**Dedupe**: if several subagents return the same `file:line`, keep a single entry and mention the scopes that matched.

## Step 4 — Output

### JSON output (always returned, stable structure for caller mode)

```json
{
  "feature_needs": [
    {
      "need": "fetch employment by member_id",
      "candidates": [
        {
          "file": "backend/components/.../queries/employments.py",
          "line": 42,
          "signature": "def get_employment_for_member(member_id: int) -> Employment",
          "score": "high",
          "rationale": "Exactly matches; already used in 8 call sites",
          "integration_note": "Use as-is, no wrapper needed",
          "scope": "backend_python"
        }
      ]
    },
    {
      "need": "validate IBAN format",
      "candidates": []
    }
  ],
  "stats": {
    "needs_total": 8,
    "needs_with_candidates": 6,
    "candidates_high": 4,
    "candidates_medium": 7,
    "candidates_low": 3
  }
}
```

### Text output (human)

Markdown format, grouped by need, candidates sorted `high → medium → low`. Filter
out `low` by default (mention "X low candidates hidden — `--show-low` to see
them"). Each candidate on 2 lines:

```
**fetch employment by member_id**
- 🟢 `backend/components/.../queries/employments.py:42` — `get_employment_for_member(member_id)`
  Covers exactly, 8 call sites, use as-is.
- 🟡 `backend/components/.../queries/members.py:118` — `get_member_with_employment(member_id)`
  Also loads the member; medium because it brings back more data than needed.
```

### User gate (standalone only)

`AskUserQuestion` after the display:
- "Reuse everything as proposed"
- "Exclude some candidates" (let them type)
- "Dig into a candidate" (triggers a Read of the file)

In caller mode: no gate, return JSON + summary to the parent skill.

## Output in caller mode

The calling subagent expects exactly:

```
{JSON above}

---HUMAN_SUMMARY---

{markdown above}
```

The parent skill (`lm-guided-feature-development` Part 2 Step 2bis) merges the
JSON into the `reuse_discovery` of the Part 2 bundle, and uses the markdown for
displaying to the user at the "Architecture Proposal" gate.

## Anti-patterns to avoid

- **Inventing candidates**: if grep finds nothing, return `[]` — never generate a plausible name.
- **Over-decomposing the needs**: 15+ needs = loss of focus. Aim for 5–12.
- **Promoting low candidates**: if the weakest link is low, keep it low — do not round up.
- **Skipping the read**: every candidate must have a signature that was read, not inferred from the name.
- **Ignoring the domain**: a shared `format_date` is not a good candidate for a "format sick-leave date in FR" need if the OH component already has its own local formatter.

## Resources

- `references/search-strategies.md` — grep patterns per scope, Glob shortcuts
- `references/scoring-rubric.md` — detailed scoring rubric + examples
- `evals/evals.json` — test cases
