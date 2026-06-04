---
name: lm-merge-conflict
description: Merge two git branches (or rebase) and resolve conflicts interactively, with auto-resolution for trivial cases and human confirmation for ambiguous ones. Use whenever the user wants to "merge X into Y", "rebase on main", "résoudre les conflits", "fix conflicts on this branch", "merger cette branche", or any request involving git merge/rebase conflict resolution. Triggers on /lm-merge-conflict, "merge conflict", "git conflict", "resolve conflicts", "j'ai des conflits", or shared output containing `CONFLICT (content)` / `<<<<<<< HEAD`. Even if the user just says "I have conflicts" without naming a branch, use this skill.
---

# lm-merge-conflict

Help the user merge two git branches (or rebase) and resolve conflicts. The goal is to do the boring, mechanical parts autonomously and stop the user only for decisions that genuinely need their judgment — and when stopping them, give them the **intent** of both sides (what each PR was trying to do) so the choice is informed, not a coin flip on raw diff.

## Modes

The skill accepts up to three modifiers from the user request:

- **Target branch** (positional, optional): the branch to merge in (e.g. `main`, `develop`). If absent, ask.
- **`--rebase`**: rebase current branch onto target instead of merging. Only used if the user explicitly says "rebase".
- **`--dry-run`**: simulate, list what would happen, do not leave any changes in the working tree.

Octopus merges (more than two branches at once) are out of scope. If asked, say so and stop.

### Strategy: rebuild from main + replay HEAD changes

Sometimes the cleanest path is not to edit the `<<<<<<<` markers in place, but to reset the conflicted file(s) to the incoming side and replay only the HEAD changes that still make sense. Use this when conflict surface in a file is large, or when the incoming side has refactored heavily and the markers are noisy.

This strategy is **dangerous in a specific way**: it tempts you to summarize HEAD's intent ("HEAD added the email feature") and replay only that summary, silently dropping unrelated HEAD changes that happened to live in the same file. The retro-failure mode is real — see below.

When using this strategy, the protocol is strict:

- **Force a full file-level diff on both sides** before deciding anything: `git diff $MB..HEAD -- <file>` AND `git diff $MB..<target> -- <file>`. **Never** rely on conflict markers alone — markers only show overlapping regions, not HEAD-only hunks that incoming didn't touch. Those HEAD-only hunks are exactly the ones that get silently dropped.
- **Tag every hunk individually** with one of:
  - `stale-gating-drop` — HEAD keeps a feature flag / impersonation / admin gate that incoming explicitly removes. Drop.
  - `independent-feature` — HEAD change orthogonal to incoming's subject (e.g. comparator refactor, variable rename, equality-check fix, typo). Keep as-is.
  - `comment-only` — comment / doc, no runtime impact. Keep.
  - `noise` — formatting, blank lines, re-ordered imports. Ignore.
  - `feature-core` — implements the headline feature of the HEAD branch (e.g. the new mutable email field). Keep.
- **Hard rule: one hunk = one tag = one decision.** Never group adjacent hunks under a single intent, even if they sit inside the same 10-line block. If two distinct intents share a block (e.g. drop a gating prop **and** change `affiliationId ===` to `employee ===`), split mentally and tag separately. Grouping is the failure mode that causes "I optimized for the dominant signal and overwrote the other in the same decision."
- **Show the tagged inventory before writing.** Output a per-file table: `hunk @@ -X,Y +A,B | tag | fate (kept | dropped | merged-with-incoming)`. Wait for the user to confirm before producing the final file.

## Workflow

### 1. Pre-flight

Run `git status` first.

- If a merge or rebase is **already in progress** (presence of `.git/MERGE_HEAD` or `.git/rebase-merge/`), skip directly to step 3 — the merge has already been started, just resolve.
- If the working tree is **dirty** (uncommitted changes that aren't part of an in-progress merge), stop and ask: stash, commit, or abort. Don't pick for the user — losing in-progress work is the failure mode we care most about.
- Confirm the target branch. If the user request didn't name one, ask.
- If the target tracks a remote, run `git fetch <remote> <target>` so we merge against the up-to-date version. Mention it; don't silently pull.

### 2. Start the merge (skip if already in progress)

- Default: `git merge <target>`.
- With `--rebase`: `git rebase <target>` from current branch.
- With `--dry-run`: `git merge --no-commit --no-ff <target>`, do the inventory in step 3, then `git merge --abort` and report. Do not proceed past inventory.

If the merge completes with no conflicts, confirm with a short recap (files changed, no commit yet if merge needs one) and stop.

### 3. Inventory & classify

`git diff --name-only --diff-filter=U` gives the conflicted file list. Compute the merge-base once: `MB=$(git merge-base HEAD <target>)`.

Classify each file:

- **Trivial** — safe to resolve without asking, no context gathering needed:
  - Lockfiles (`yarn.lock`, `package-lock.json`, `pnpm-lock.yaml`, `Pipfile.lock`, `poetry.lock`, `Cargo.lock`) → regenerate, don't hand-merge.
  - Pure additive conflicts where both sides add at non-overlapping locations (e.g. each branch adds a different import to a list, each adds a different entry to an enum).
  - Whitespace / formatting only (verify with `git diff --check` and inspection).

- **Structural** — too divergent to recommend on:
  - File was massively refactored on the incoming side (heuristic: `git diff --stat $MB..<target> -- <file>` shows the file rewritten, renamed, or HEAD's hunks land in regions that no longer exist incoming-side). Flag as `structural conflict — manual review required`. Do not propose a default; let the user open the file and decide.

- **Ambiguous** — needs context gathering (step 4) before resolution:
  - Anything that's neither trivial nor structural.
  - When in doubt, classify here. Cost of asking is small; cost of silently picking wrong is real.

After classification, output a **suspicion matrix**. This is the artifact the user reads to triage the merge before drilling in:

```
| File                    | Hunks | Class       | Incoming PR     | Intent      | HEAD signals       | Default reco  |
|-------------------------|-------|-------------|-----------------|-------------|--------------------|---------------|
| EmployeeSideModal.tsx   | 4     | ambiguous   | #90161 (2h ago) | release/    | useIsImpersonating | keep incoming |
|                         |       |             |                 | ungating    |                    |               |
| Affiliations.tsx        | 2     | ambiguous   | —               | feature add | —                  | ask           |
| yarn.lock               | 1     | trivial     | —               | —           | —                  | regenerate    |
| LegacyForm.tsx          | 1     | structural  | #89901 (rewrite)| —           | —                  | manual review |
```

The `Incoming PR`, `Intent`, `HEAD signals`, `Default reco` columns are filled by step 4 below for ambiguous files. For trivial / structural, leave as `—`.

### 4. Conflict context gathering (ambiguous files only)

Skip this step for trivial and structural files — for trivial we just resolve, for structural we hand to the user.

For each ambiguous file, gather the **intent of each side** before showing a resolution prompt. The point: a diff alone tells you *what* each side wrote, not *why*. PR titles and bodies tell you why, and that's what makes the choice obvious in cases like "incoming is a release that explicitly removes a feature flag HEAD reintroduces."

#### 4a. Find the commits that touch the conflicted regions

```bash
# Commits on the incoming side since the merge base, for this file
git log --oneline $MB..<target> -- <file>

# Commits on the HEAD side since the merge base, for this file
git log --oneline $MB..HEAD -- <file>
```

Narrow further if useful: `git blame $MB..<target> -- <file>` on the conflicting line ranges, to find which incoming commit actually authored the conflicting hunk. (Same for HEAD-side blame.)

#### 4b. Resolve commits to PR intent

For each relevant commit:
- Squash-merge commits end with `(#NNNNN)` in the subject. Extract that.
- `gh pr view <N> --json title,body,mergedAt,url` for incoming-side PRs, same for HEAD-side if available.
- Compute age from `mergedAt` (e.g. "merged 2h ago", "merged 3 days ago").

If `gh` is unavailable, the repo has no GitHub remote, or the PR can't be fetched (private fork, offline), **degrade gracefully**: skip the PR fetch for that commit and proceed with just the commit subject as intent. Don't crash; don't block resolution. Note "PR context unavailable" in the matrix.

#### 4c. Apply semantic heuristics

These flip or strengthen the default recommendation. Keep them general — the spirit is "incoming explicitly removes what HEAD keeps adding back."

**Incoming-side signals → default `keep incoming`** (PR title or body matches, case-insensitive):
- `release`, `GA`, `ship`, `open the release`
- `cleanup`, `remove gating`, `remove feature flag`, `remove FF`
- `remove impersonation`, `unimpersonate`
- `delete deprecated`, `drop legacy`

**HEAD-side signals in the conflicting hunks → "high suspicion" that HEAD is stale**. Grep the HEAD side of the conflict region for:
- Feature flags / gating: `useBooleanFlagVariation`, `useFeatureFlag`, `is.*Enabled`, `LaunchDarkly`, FF-named constants
- Impersonation: `useIsImpersonating`, `isImpersonating`, `impersonating`
- Alan admin gates: `is_admin_alan`, `is_alan_user`
- Conditional rendering of whole components: `cond ? <X /> : null`, `if (!cond) return null` wrapping a screen
- Comments betraying temporariness: `// temporary`, `// will be removed`, `// behind FF`, `// impersonation-only`, `// TODO remove when * is GA`

If an incoming-side signal **and** a HEAD-side signal coincide on the same hunk, the recommendation is `keep incoming` with **strong** confidence. Always source it: include the PR URL, the HEAD comment/identifier that triggered the flag, and the commit hash.

#### 4d. Temporal recency

If the incoming PR was merged **less than 24h ago** AND matches a release/cleanup pattern, prepend this banner to the resolution prompt for that file:

```
⚠️  Incoming PR #<N> merged <X>h ago and explicitly <removes the gating | ships the release>
   that HEAD adds back.
   Default recommendation: keep incoming. Override only if you intentionally want to revert this.
```

The banner exists because recent release merges are the highest-information signal we have: someone just decided this code should ship, and HEAD predates that decision.

#### 4e. Cross-reference memory & conversation

Before showing the resolution prompt:
- Skim `~/.claude/memory/MEMORY.md` (already in context) for PR / ticket numbers.
- Skim the parent conversation for `#NNNNN` mentions.

If any match a PR identified in 4b, append a one-liner to the prompt: `Note: PR #90161 was discussed earlier in this conversation / appears in memory.` This is so the skill doesn't reason in a silo while the user already had the answer five minutes ago.

#### 4f. Stale-comparator probe (mutation-vs-memo hazard)

The merge tool sees text-level conflicts. It does **not** see implicit contracts in unrelated files that the merge silently invalidates. The classic case: HEAD adds a mutation on a field (e.g. inline-edit email), an upstream `React.memo` / custom comparator in main was written assuming that field never changes, and after merge the feature works in isolation but the list view doesn't refresh in prod. No conflict marker fires because the two files don't textually conflict.

**Trigger this probe when** HEAD adds a feature that mutates data displayed in a list/table. Heuristic: HEAD diff introduces a `update*` / `edit*` / `set*` handler (or a `useMutation` / `PATCH` call) on a field, AND the same field appears in a sibling file containing `.map(`, `<List`, `<Table`, `<FlatList`, `<DataGrid`, or similar.

**Probe**: on the same feature directory in the post-merge tree, run:

```bash
grep -rnE "memo|prevProps|React\.memo|useMemo|useCallback|areEqual" <feature-dir>
```

For each hit:
- Read the comparator. If it compares a subset of props and **omits** the field HEAD just made mutable → flag `stale-comparator-hazard`.
- Read surrounding comments. Killer pattern: `// we assume that <X> never change(s)` or `// other props are stable`. Flag even if no explicit comparator matches — the comment alone is the contract.
- Same for `useEffect` / `useCallback` / `useMemo` deps arrays that consume the now-mutable field.

Report each hazard as a row in the suspicion matrix:
```
| File              | Line | Hazard                    | Why                                                                |
|-------------------|------|---------------------------|--------------------------------------------------------------------|
| MemberRow.tsx     | 88   | stale-comparator-hazard   | HEAD now mutates `email` (PR #X), but memoizes on `[id, status]`   |
| MemberList.tsx    | 142  | stale-comment-contract    | Comment "// other props never change" predates email mutation      |
```

If `<feature-dir>` has 0 hits, widen to the parent module before giving up.

### 5. Resolve

**Trivial** — resolve directly, then report one short line per file:
```
✓ src/foo.ts: kept both imports (additive)
✓ yarn.lock: regenerated via `yarn install`
```

**Structural** — open the file location for the user, state "structural conflict, manual review required", do not pick a side.

**Ambiguous** — for each conflict block, present this format and wait for choice. Always show the sourced recommendation; never auto-resolve, even when confidence is strong.

```
File: path/to/file.ts:42
Context: <1 sentence on what this code does>

[optional temporal-recency banner from 4d]

HEAD (<current branch>):
  <code>
  HEAD signal flagged: useIsImpersonating (line 44) — looks like gating

Incoming (<target branch>):
  <code>
  From: PR #90161 "release Observation feature, removes all isImpersonating gates"
        merged 2h ago — https://github.com/.../pull/90161

Recommendation: keep incoming — release PR explicitly removes the gating HEAD adds back.
[1] keep HEAD   [2] keep incoming   [3] use recommendation   [4] custom
```

If the user picks `4 custom`, ask what they want, write it, move on. Group small adjacent conflicts in the same file into one prompt when reasonable — don't make the user answer 10 prompts for what is effectively one decision.

### 6. Validation

After resolutions:
- `git diff --check` to catch leftover conflict markers.
- Lockfiles: if `yarn.lock` / `package-lock.json` / etc. were conflicted and not yet regenerated, regenerate now.
- If the project has obvious lint config (`package.json` lint script, `.pre-commit-config.yaml`, `pyproject.toml` with ruff/mypy), **suggest** running it. Don't run it unprompted — the user may want to commit first and let CI catch issues.

### 6.5. Invalidated-contracts check

Textual resolution can be clean while semantics are silently broken. Before declaring resolved, materialize the implicit contracts that re-applied HEAD changes might have invalidated, and verify each one. Output an explicit checklist — every item must be cocked (✓) or fixed (loop back to step 5) before moving to finalize.

For every field / variable / API touched by HEAD's re-applied hunks, check:

- **Memo comparators** — grep `React.memo|memo(|areEqual|prevProps|isEqual` in the module for components consuming this field. If a comparator omits the now-mutable field (or a comment says "we assume X never changes"), the list won't re-render. Either add the field to the comparator, drop the comparator, or document why it's safe.
- **Hooks deps** — for variables now mutable, grep `useEffect|useCallback|useMemo` in the module. The variable must be in the deps array of any hook that consumes it.
- **Cache invalidation / refetch** — if HEAD added a mutation API, grep the query key on consumers and confirm `queryClient.invalidateQueries` / `mutate` / `refetch` is wired. Otherwise the UI shows stale data after the mutation succeeds.
- **Type contracts** — if a field changed required ↔ optional, or its type narrowed/widened, grep call sites for usages that assume the old shape (non-narrowed access, default values).

Format the output as:

```
Invalidated-contracts check for `email` (re-applied via PR #X):
[✓] memo: MemberRow.tsx:88 comparator includes `email`
[✗] hooks: MemberList.tsx:142 useEffect deps missing `email` → fix before finalize
[✓] cache: useMembers query invalidated in updateEmail mutation
[✓] types: email stays string, no shape change
```

If any `✗` remains, **return to step 5** rather than proceeding. The cost of a stale-list bug in prod is much higher than the cost of one more resolve loop.

### 7. Finalize

- `git add <file>` for each resolved file, **by name**. Never `git add .` or `git add -A` — too easy to pull in unrelated dirty files.
- Recap: `N files resolved (X auto, Y manual, Z structural skipped)`.
- Ask before committing. Use the default merge commit message unless the user wants something different.
- **Never** use `--no-verify`. If a pre-commit hook fails, surface it and let the user decide.
- **Never** push automatically. Stop after the commit.

For rebase: after resolving, `git rebase --continue`. If more commits conflict, loop back to step 3 for the next commit. If a commit becomes empty after resolution, ask before `--skip`.

## Guardrails

These exist because the failure mode of merge tooling is silently destroying user work.

- **Never auto-resolve ambiguous conflicts**, even when the recommendation is strong (e.g. "keep incoming, release PR merged 2h ago"). Always show the prompt with the sourced recommendation (PR URL, HEAD signal location, commit hash) and wait for the user. Strong confidence shortens the user's decision time; it doesn't remove the decision.
- Never `git checkout <file>` to "reset" a conflicted file without explicit confirmation — it discards the user's side.
- Never `git reset --hard` without explicit confirmation.
- Never `git merge --abort` or `git rebase --abort` without confirmation, even if things look bad — abort is the user's call.
- If the conflict surface is huge (say >50 conflicted files, or the same file with >20 conflict regions), stop and flag it. That usually means the wrong base, a stale branch, or that the merge should be split. Better to surface this than to grind through it.
- For lockfiles: prefer regenerate over hand-merge. Hand-merging lockfiles produces broken installs.

## Why these defaults

The model behind this skill is good at pattern recognition (additive imports, lockfiles, whitespace) and bad at intuiting product intent across two diverging branches **from a raw diff alone**. The fix is not to trust the model harder — it's to feed it the artifacts that contain the intent (PR titles, bodies, merge dates, gating-pattern comments) so the recommendation is sourced rather than guessed. Auto-resolving the trivial category buys speed; gathering context for the ambiguous category buys good recommendations; refusing to auto-resolve the ambiguous category buys safety. The user's time is the scarce resource — spend it on the decisions that actually need them, with the receipts in front of them.
