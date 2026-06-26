---
name: lm-babysit-pr
model: sonnet
description: Monitor a PR's CI status and auto-fix failures until green. Use whenever the user says "babysit", "watch CI", "monitor PR", "fix CI", "wait for CI", "keep CI green", "babysitt", or any request to continuously monitor a pull request's CI pipeline and fix issues automatically. Also triggers on "/babysit-pr", "/babysit", "check my PR until green", "make CI pass".
---

# Babysit PR

Continuously monitor a PR's CI checks every 3 minutes. When CI fails, analyze the failure, fix it if simple, or ask the user for permission if complex. When CI is green, notify the user and stop.

## Step 1: Identify the PR

Parse arguments for a PR number. If none provided, find the PR for the current branch:

```bash
gh pr list --head "$(git branch --show-current)" --json number,url --jq '.[0]'
```

If no PR found, tell the user and stop.

## Step 2: Create the monitoring cron

Use CronCreate with cron `*/3 * * * *`, recurring `true`, and the prompt:

```
Check CI status for PR #<NUMBER> and fix failures if possible. If CI is green, kill cron <JOB_ID> and run: /notify CI is green for PR #<NUMBER>
```

Then immediately run the first check (don't wait for the first cron fire).

## Step 3: Check CI status

Run:
```bash
gh pr checks <PR_NUMBER> 2>&1
```

### If all checks pass (no "fail", no "pending" except skipping):
1. Delete the cron with CronDelete
2. Notify: `/notify CI is green for PR #<NUMBER>`
3. Done!

### If checks are still pending:
Report briefly which key jobs are pending and wait for next cron tick.

### If checks fail:

#### 0. Delegate root-cause analysis to `lm-debug-5whys` (mandatory)

Don't grep the logs yourself trying to guess the real error. Delegate to `lm-debug-5whys` — it's purpose-built for tracing failures to their upstream cause, handles the false-signal traps (exit code 130 on parallel `tsc --build`, runner SIGINT, buried errors under repeated tooling output), and produces an evidence-backed root cause you can act on.

**Why delegate**: babysit's job is to react to CI, not to do forensic log archaeology. Surface signatures lie — especially in monorepo parallel builds where the orchestrator sends SIGINT to sibling processes the moment one project errors. A naive `grep | head -30` buries the real error under high-frequency benign output, leading to false "infra" conclusions. `lm-debug-5whys` already knows how to avoid this; reuse it instead of duplicating (and degrading) that logic here.

**How to invoke**:

```
Call: Skill(skill="lm-debug-5whys", args="CI failure on PR #<NUMBER>, job <JOB_NAME> (run id <RUN_ID>, job id <JOB_ID>). Exit code <CODE>. Find the upstream error in the logs and trace to root cause. Do NOT default to 'infra' without proving with a targeted grep that no application-level error exists.")
```

Pass it the PR number, run id, job id, and exit code. Let it fetch and analyze the logs.

**Act on its output**:
- If it returns a concrete root cause (file:line + reason) → jump to the matching priority section below to classify the fix.
- If it returns "infra / runner preemption" with evidence (empty targeted grep + non-zero exit) → notify the user; don't auto-fix.
- If it can't reach a confident root cause within 2-3 whys → treat as complex, `/notify` the user with what `lm-debug-5whys` found so far.

Once you have the root cause, classify the fix using this priority order:

#### 1. Branch sync failure (`check-branch-sync`)
This means the branch is behind its base. Fix:
- Check the PR's base branch: `gh pr view <NUMBER> --json baseRefName --jq '.baseRefName'`
- If base branch is NOT `main`, update it too:
  ```bash
  git fetch origin <base-branch>
  git checkout <base-branch>
  git pull origin <base-branch>
  # If behind main, merge main
  git fetch origin main && git merge origin/main --no-edit
  git push origin <base-branch>
  git checkout <pr-branch>
  ```
- Merge the base into the PR branch:
  ```bash
  git merge origin/<base-branch> --no-edit
  SKIP=check-mixed-change git push
  ```
This is a **simple fix** — push and notify via `/notify`.

#### 2. Frontend lint/deadcode/format/typecheck failures

You should already have the root cause from step 0 (`lm-debug-5whys`). If not, go back and invoke it — don't grep the logs ad-hoc here.

**Candidate simple fixes** (validate root cause first, see below):
- `eslint-disable` for pre-existing lint errors not introduced by the PR
- Removing unused exports flagged by deadcode (check they're truly unused with Grep first)
- Formatting issues fixable with `direnv exec frontend yarn format --write <file>`
- Lint auto-fixable with `direnv exec frontend yarn lint --fix <file>`
- **Updating dependent artifacts (fixtures, mocks, callers) to match a contract introduced by this PR** — see Honest-fix rule below

**Honest-fix rule (contract-introduced TS errors)** — read carefully before "fixing" any TS error:

Two genres of TS errors look identical on the surface but demand opposite responses. Distinguish them before reaching for a fix:

- **Pre-existing error, surfaced by the PR**: e.g. a stale `eslint-disable` revealed by a new import, a `tsc --build` cache miss. Suppressing or working around is legitimate — the PR didn't cause the underlying issue.
- **Error caused by a contract YOU introduced in this PR**: e.g. you added a required field on a type, narrowed a union, added a required prop. The error correctly reports that existing artifacts don't yet satisfy your new contract.

For the second genre, **prefer updating the dependent artifacts (fixtures, mocks, callers, stories) over weakening the contract** — even if it touches more files. The type system must keep reflecting runtime reality; weakening it to dodge a fixture update introduces a permanent lie that bites later (consumers handle `undefined` that never occurs at runtime, optimistic updates and tests drift from the real shape).

- **BAD**: make a backend-guaranteed field optional (`field?: boolean`) just so old fixtures missing that field type-check. Then sprinkle `?? false` at read sites to placate `tsc`. The type now claims the field can be absent — runtime says otherwise.
- **GOOD**: add the field to the fixtures with a sensible default (e.g. `canDeclareWorkStoppageOnPrevenir: true` for a "no blocker" baseline). Keep the contract honest.

**Why it matters**: PR reviewers will catch this and reject it (the asymmetry with sibling fields is a tell), and even if they don't, the lie compounds — every future consumer of the type has to defensively handle a case that can't happen. Fixing the fixtures is mechanical and one-shot; weakening the contract is a forever tax.

The >3 files threshold below does **not** apply to mechanical fixture/mock alignment with a contract this PR introduces — that's still a simple fix, just one that touches more files than usual.

**Complex fixes** (notify via `/notify` and ask permission):
- Actual code logic errors
- Missing translations that need real i18n work
- Type errors requiring design decisions
- Test failures requiring investigation
- Any fix touching more than 3 files **unrelated to contract alignment** (mechanical fixture/mock updates that follow a PR-introduced contract stay simple)

#### 3. Backend failures
Generally treat as complex — notify and ask permission.

## Local conventions first (mandatory before classifying a fix)

Before deciding on *any* fix — simple or complex — check how the **occupational health** application handles the same case. The simplest fix is often "align with what the surrounding code already does", not "make the failing line work as written".

**Why this matters**: a fix that's technically correct in isolation may introduce a pattern the rest of the app deliberately avoids. The CI is then green but the PR carries a foreign convention that reviewers will reject. Worse, the "fix" may be unnecessary entirely — if the OH app never uses the failing symbol, the answer is to stop using it, not to make it import correctly.

**Concrete example — UserFactory**: CI failed on an import of `UserFactory`. The naive fix is to chase down the right import path. The correct fix: grep the OH component for `UserFactory` usage — if it returns nothing, the OH convention is to not use it. Remove the usage instead of fixing the import.

**How to apply** — before proposing a fix:

1. Identify the failing symbol / pattern / lint rule.
2. Grep the OH component for prior usage:
   ```bash
   rg "<symbol>" backend/components/occupational_health/ frontend/packages/occupational-health*/ frontend/apps/admin*/src/**/occupational-health*/
   ```
3. Three outcomes:
   - **OH never uses it** → the simplest fix is to remove the usage in the PR. Default to this.
   - **OH uses it with a specific pattern** (factory, helper, wrapper) → copy that pattern exactly.
   - **OH has no precedent and the symbol is genuinely needed** → proceed with the literal fix, but flag in the notification that this is a new pattern for OH.
4. Apply the same logic to lint rules, type patterns, test helpers, imports — anything CI flags. "How does OH do this elsewhere?" comes before "how do I make this line pass?".

This check is cheap (one grep) and routinely changes the fix from "patch the symptom" to "delete the symptom". Always prefer the deletion path when OH precedent supports it.

## Root-cause already in hand

`lm-debug-5whys` was invoked at step 0, so you already have the root cause. Before pushing, just sanity-check that your candidate fix addresses *that* cause, not a symptom adjacent to it. If the candidate fix would mask the root cause 5whys identified, reclassify as **complex** and `/notify` the user instead of pushing.

## Fix workflow

When applying a fix (after **local conventions check** + root-cause validation have both cleared it):

1. Make the change
2. Run local quality checks on affected files:
   ```bash
   cd /path/to/frontend && direnv exec . yarn lint --fix <file>
   cd /path/to/frontend && direnv exec . yarn format --write <file>
   ```
3. Stage specific files (never `git add .`)
4. Commit with a descriptive message that references the root cause from 5-Whys, not just the symptom (e.g., `fix(lint): remove dead import revealed by no-unused-vars` — not just `fix lint`)
5. Push with `SKIP=check-mixed-change git push` if the branch has both backend and frontend changes
6. Notify via `/notify` what was fixed AND the root cause that 5-Whys identified

## Notification patterns

Use the `/notify` skill for all notifications:
- **Simple fix pushed**: `/notify Fixed <issue> on PR #<NUMBER>, pushed. CI re-running.`
- **Complex fix needs permission**: `/notify PR #<NUMBER> CI failing: <issue>. Need your input to fix.`
- **CI green**: `/notify PR #<NUMBER> CI is green! All checks pass.`

## Important behaviors

- When the cron fires and you're checking CI, be concise — just report status changes, not every pending job.
- If the same failure persists after 2 fix attempts, stop auto-fixing and notify the user.
- If CI has been pending for more than 15 minutes with no progress, notify the user.
- When checking logs, if the run is still in progress (`logs will be available when it is complete`), wait for the next tick.
- Remember to check both the PR branch AND its base branch for sync issues.
