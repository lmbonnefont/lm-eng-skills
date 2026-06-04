# Compliance Rubric

## Severity Levels

Calibrated on "how embarrassing would this be in code review" — not on bug severity.

| Level | Name | Criteria | Analogy |
|-------|------|----------|---------|
| **P1** | Must fix | Violates a `.ruler/` rule or codified Alan convention. The reviewer **will** flag this. | "You should have known this" |
| **P2** | Should fix | Inconsistent with surrounding code patterns. The reviewer will **likely** flag. Not a rule violation, but clearly out of place. | "Did you look at the neighboring files?" |
| **P3** | Consider | Opportunity to use a better pattern that exists in the codebase. An experienced reviewer **might** mention it. | "Nice-to-know for next time" |

**Severity floor**: if confidence is too low for P3, don't report it.

## The Learn Requirement

This is the key differentiator from a standard code review. Every finding MUST include a
**Learn** section with:

1. **At least one real file path** in the codebase where the correct pattern is used
2. **Optionally**, a reference to the `.ruler/` rule or convention source

The Learn section serves two purposes:
- It **eliminates false positives** — if no real example exists, the "convention" may not actually exist
- It **teaches the developer** where to look, building their mental map of the codebase

**If you cannot find a concrete example of the correct pattern: do not report the finding.**

## Finding Format

Every finding uses this exact structure:

```markdown
### [P{severity}] Short descriptive title
**File:** `path/to/file:line_number`

**What:** Factual description of the inconsistency — what the code does vs what the
local context expects.

**Why:** Why this convention exists. Reference historical context, past incidents,
or technical reasons. Explain the tradeoff so the developer understands the reasoning,
not just the rule.

**Learn:** See the correct pattern in:
- `path/to/sibling_file:line` — does X correctly
- Rule: `backend/.ruler/python_guidelines.md` section Y (if applicable)

**Fix:** Concrete code snippet showing the correction (3 lines max)
```

## Agent Focus Areas

### Agent 1: Alan Conventions & Ruler Compliance

Check whether the diff violates codified rules from `.ruler/` files and the
`alan-conventions-checklist.md`. These are the most deterministic checks — rules
have clear right/wrong answers.

**Review for:**
- Import layering: inline imports in controllers/commands, top-level in business logic
- Structured logging: keyword arguments, no f-string interpolation of IDs/objects in log messages
- `mandatory()` usage instead of manual `if x is None: raise` patterns
- `get_or_raise_missing_resource()` instead of `get_or_404()` or manual fetch+raise
- `@use_args` with Marshmallow schemas, not deprecated `@request_argument`
- SQLAlchemy 2.0 syntax only (no legacy Query API)
- Empty `__init__.py` files (Rule #7)
- Queries return dataclasses, not ORM entities (Rule #6)
- Object IDs as business logic arguments, not object instances (Rule #4)
- Frontend: `toISODateFormat()` not `toISOString()`
- Frontend: Error cause pattern `new Error("msg", { cause: error })`
- Frontend: Named inline exports, no default exports
- Frontend: PascalCase component files, camelCase folders

**Do NOT report:**
- Generic code quality issues unrelated to Alan conventions
- Bugs or logic errors (that's /review's job)
- Formatting/style issues handled by linters (ruff, eslint, prettier)
- Pre-existing violations not introduced in this diff

### Agent 2: Local Code Consistency

Check whether the diff is consistent with the patterns in its immediate neighborhood —
sibling files in the same directory, the parent module's conventions, and the component's
established patterns.

**You MUST read 2-3 sibling files** in the same directory as each changed file before
analyzing. Compare naming, structure, exports, error handling, and patterns.

**Review for:**
- Naming inconsistency with siblings: variable names, function names, file names that
  break the pattern established by neighboring files
- Single-letter variables or vague names where siblings use descriptive names
- Name-functionality mismatches (function named "get X" that actually loads Y)
- React patterns: functions defined inside render body when siblings define them outside,
  variables declared in JSX return block
- Export style inconsistent with siblings (default export where siblings use named exports)
- Code reuse opportunities: similar dataclasses that should share a base class, duplicate
  logic across siblings, existing utilities not used (mandatory(), toISODateFormat(), useCamelCaseApi())
- Missing method extraction: overly long functions where siblings keep methods focused
- Inconsistent error handling patterns within the same module

**Do NOT report:**
- Convention violations (that's Agent 1's job)
- Production-readiness gaps (that's Agent 3's job)
- Subjective preferences without evidence from sibling files
- Patterns that the MAJORITY of siblings also don't follow (see anti-noise rule #3)

### Agent 3: Production-Readiness

Check whether the diff includes the "finishing touches" that experienced reviewers
expect on production-ready code. These are the things that distinguish a complete
feature from a draft.

**Review for:**
- Analytics/Amplitude tracking: new user-facing interactions (buttons, links, form
  submissions, navigation) without tracking events — check if sibling components have
  tracking to calibrate expectations
- Loading/empty states: data-fetching components without skeleton, spinner, or placeholder
  UI — check if sibling components handle loading states
- i18n: hardcoded strings in components that should be translated — check if the module
  uses translation functions
- Structured logging: new backend actions/queries without adequate logging
- Docstrings: new Python business logic methods without docstrings
- TSDoc: exported React components without documentation (only when the component's
  purpose is non-obvious from its name and props)
- Test coverage signals: new business logic file without a corresponding test file when
  every other file in the directory has one; new component without a story when siblings
  have stories
- Missing `useCamelCaseApi()` when the component fetches from the backend API

**Do NOT report:**
- Bugs or logic errors
- Convention violations already covered by Agent 1
- Local consistency issues already covered by Agent 2
- Test philosophy debates — only flag obvious gaps evidenced by sibling files
- Aspirational patterns not yet established in the codebase (e.g., actor arguments
  when no sibling uses them)

## Anti-Noise Rules

All agents MUST follow these rules:

1. **Only flag what's introduced in the diff.** Pre-existing violations are out of scope.
   Exception: if the diff extends a legacy pattern, note as P3: "This file uses a
   deprecated pattern — not your fault, but FYI for context."

2. **The Learn section is mandatory.** If you cannot point to a real file in the codebase
   where the correct pattern is used, do not report the finding. This eliminates
   theoretical or aspirational findings.

3. **Majority rules for local context.** If 4 out of 5 sibling files use pattern A and
   the diff also uses pattern A, don't flag it — even if `.ruler/` says pattern B.
   Instead, note as P3: "This area uses legacy pattern A. Target is pattern B (see ruler).
   No action needed on this PR."

4. **No formatting or style issues.** Linters and formatters handle these (ruff, eslint,
   prettier, oxlint). Do not flag indentation, whitespace, import ordering, etc.

5. **No test philosophy debates.** Only flag missing tests when a sibling file's test
   pattern makes the gap obvious (e.g., every other action in the folder has a test file,
   this one doesn't).

6. **No hypothetical downstream effects.** "This might cause issues if someone later..."
   is not a finding.

7. **Conventions must be verifiable.** Each convention must be traceable to either a
   `.ruler/` file or a strong local pattern (4+ files in the same directory following it).
   Do not invent conventions from a single example.
