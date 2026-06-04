---
name: lm-reviewer-rules
description: >
  Review code changes against best-practice rules extracted from Bastien Landre and
  Mickaël Berguem's PR reviews on alan-eu/alan-apps over a rolling 4-month window.
  Loads aggregated rules grouped by theme (architecture, tests, naming, performance,
  typing, Alan patterns, security, readability) and applies them as a checklist on the
  target diff, producing P1/P2/P3 findings each citing the source PR comments. Use when
  the user asks "what would Bastien/Mickaël flag", "review like Bastien", "team review
  rules", "team rules check", "check against reviewer patterns", or refreshes the rules
  dataset. Also called automatically by /lm-review-all as one of the parallel reviewers.
  Triggered by /lm-reviewer-rules.
---

# Reviewer Rules — Bastien & Mickaël

Apply rules extracted from the recurring review feedback of two trusted reviewers
(Bastien Landre `@bastien-landre-alan`, Mickaël Berguem `@MickaelBergem`) on
`alan-eu/alan-apps` PRs. The rules live in `rules.md` and are derived from a rolling
4-month window of their actual review comments — they reflect what these reviewers
*actually* push back on, not generic best practices.

This skill is a **reviewer**: it produces structured findings on a target diff. It
does NOT modify code.

## Usage

- `/lm-reviewer-rules` — auto-detect target (current branch vs `main`, or uncommitted changes)
- `/lm-reviewer-rules PR#123` or `/lm-reviewer-rules https://github.com/.../pull/123`
- `/lm-reviewer-rules abc123f` — specific commit
- `/lm-reviewer-rules refresh` — re-run the fetch script and ask the user to regenerate `rules.md`
- Natural language: "review like Bastien", "what would Mickaël flag here"

Also invoked automatically by `/lm-review-all` as Subagent 5.

## Step 1 — Determine target

Use `$ARGUMENTS` if provided, otherwise auto-detect:

1. `PR#N` / PR URL → `gh pr diff <n>` for the diff, `gh pr view <n> --json files` for file list
2. Commit SHA → `git show <sha>`
3. On feature branch (not `main`) with no args → `git diff main...HEAD`
4. Uncommitted changes → `git diff HEAD`
5. Nothing → return "No target detected" and exit

Save the diff to a temp variable. Extract the list of changed files.

## Step 2 — Load rules

Read `rules.md` (sibling file). It is the source of truth — never invent rules that
aren't in this file.

If `rules.md` is missing or empty: tell the user to run
`bash scripts/fetch_review_comments.sh` then synthesize `rules.md` from
`references/raw_comments.md` (see "Refresh" below). Exit without findings.

## Step 3 — Match rules to diff

For each rule, check its `**Trigger:**` field (a glob or path pattern, e.g.
`backend/components/**/controllers.py`). Keep only rules whose trigger matches at
least one file in the diff. This filtering keeps the model focused on relevant
rules — there is no point checking a frontend rule on a backend-only diff.

For rules with `Trigger: *` (universal), always include them.

## Step 4 — Evaluate each candidate rule

For every candidate rule, read the diff hunks for the matching files and decide:

- **Violated** → emit a finding
- **Respected** or **not applicable in this hunk** → skip silently

Do not emit a finding unless you can point to a specific `file:line` in the diff
that violates the rule. Speculation ("this might be an issue") is not allowed —
that is the zero-trust principle, and these reviewers value precision.

## Step 5 — Report

Output format, compatible with `/lm-review-all` aggregation:

```
# Reviewer Rules findings (Bastien & Mickaël)

## P1 — <rule headline>
**File:** path/to/file.py:42
**Sources:** [@MickaelBergem PR#12345](url), [@bastien-landre-alan PR#67890](url)
**Why:** <reason from the rule's Why field>
**Suggestion:** <concrete fix>

## P2 — ...

## P3 — ...
```

Severity guide:
- **P1** — pattern the reviewers consistently block on (architecture, security, data integrity)
- **P2** — pattern they push back on but accept after explanation (tests, typing, naming)
- **P3** — preference / style (readability tweaks, comment phrasing)

Severity per rule is set in `rules.md`. Default to P2 if not specified.

If no findings: output exactly `No issues found.` (so `/lm-review-all` can tell).

## Refresh

The dataset is a rolling 4-month window. To refresh:

1. Run `bash scripts/fetch_review_comments.sh` — overwrites `references/raw_comments.md`
2. Re-synthesize `rules.md` from the raw comments. Group by theme; dedup; keep
   the source PR links. Existing rules whose evidence still appears can stay; new
   recurring patterns become new rules; rules whose only evidence has aged out of
   the window should be removed.
3. Each rule entry follows the format documented in `rules.md` itself
   (`### headline`, `**Why:**`, `**Sources:**`, `**Trigger:**`, `**Severity:**`).

The script is idempotent — re-running with the same cutoff produces the same
output. The cutoff slides forward each day (`date - 4 months`).

## Files

- `rules.md` — aggregated rules (the source of truth at runtime)
- `scripts/fetch_review_comments.sh` — gh CLI fetcher
- `references/raw_comments.md` — raw dump (audit trail; not loaded by default,
  read it only when refreshing or when LM asks for the source quote of a rule)

## Tone

These rules are LM's two reviewers' actual patterns — cite them with their
GitHub handle and a PR link. The point is to make their implicit knowledge
explicit, not to invent abstract best practices. If a rule doesn't fit the
context, say so rather than forcing it.
