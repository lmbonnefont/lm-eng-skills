---
name: lm-local-compliance-review
description: >
  Review code changes for local context compliance — conventions, naming consistency
  with sibling files, ruler rules, and production-readiness patterns. Produces educational
  findings ranked by severity with "Learn" sections pointing to real codebase examples.
  Use when the user asks to "check compliance", "review conventions", "local review",
  "check before PR", "pre-PR check", or any request to verify code matches surrounding
  patterns. Also triggered by /lm-local-compliance-review. Use this proactively as part of
  the guided feature development workflow (step 6c) after /review.
---

# Local Compliance Review

Review code changes for **local context compliance** using 3 parallel sub-agents.
This is NOT a bug finder — it catches inconsistencies with surrounding code, project
conventions, and patterns in neighboring files.

Every finding must include a **Learn** section pointing to a real file in the codebase
that demonstrates the correct pattern. If no real example can be found, do not report it.

## Usage

- `/lm-local-compliance-review` — auto-detect target (feature branch diff, uncommitted changes, or last commit)
- `/lm-local-compliance-review PR#123` — review a specific PR
- `/lm-local-compliance-review abc123f` — review a specific commit
- `check my code for convention issues` — natural language trigger

## Step 1: Determine Review Target

Use `$ARGUMENTS` if provided, otherwise auto-detect:

1. **PR number/URL in args** → **checkout the PR locally first** with `gh pr checkout <number>`, then use `git diff` against the base branch for the diff and `git diff --name-only` for changed files. This ensures sub-agents read the actual files at the correct line numbers (not stale `main` versions). Changed files: `gh pr diff <number> --name-only`
2. **Commit SHA in args** → `git show <sha>`. Changed files: `git show --name-only --format="" <sha>`
3. **On feature branch** (not `main`) → diff vs base branch:
   ```bash
   BRANCH=$(git branch --show-current)
   # Try git-spice metadata first (read-only, doesn't change HEAD)
   PARENT=$(git cat-file -p "refs/spice/data:branches/$BRANCH" 2>/dev/null | python3 -c "import sys,json; print(json.load(sys.stdin)['base']['name'])" 2>/dev/null)
   if [ -n "$PARENT" ]; then
     BASE=$(git merge-base HEAD "$PARENT")
   else
     BASE=$(git merge-base HEAD @{upstream} 2>/dev/null)
     if [ -z "$BASE" ]; then
       echo "WARNING: no upstream or git-spice metadata, falling back to main"
       BASE=$(git merge-base HEAD main)
     fi
   fi
   git diff $BASE..HEAD
   ```
   Changed files: `git diff --name-only $BASE..HEAD`
4. **Uncommitted changes exist** → `git diff` + `git diff --cached` + untracked files via `git ls-files --others --exclude-standard`
5. **Fallback** → `git diff HEAD~1..HEAD`

Store the diff output and the list of changed files.

## Step 2: Gather Context (Extended)

Before spawning sub-agents, collect more context than a standard review:

1. **The diff and changed files list** (from step 1)
2. **Ruler files** — for each changed file, walk up the directory tree and collect all `.ruler/*.md` files found. Pass these to every agent.
3. **Sibling files** — for each changed file, list 2-3 other files in the same directory (prefer files with similar names or the same extension, sorted by recency). Read their content — these are the "local context" agents will compare against.
4. **Parent module README** — if a `README.md` exists in the parent component/module directory, read it.
5. **Focus guidance** — any `$ARGUMENTS` text beyond the target (e.g., "focus on the controller changes").

## Step 3: Spawn 3 Sub-Agents in Parallel

Launch all 3 using the Agent tool simultaneously in a **single message** with 3 parallel
tool calls. Each agent is `subagent_type: "general"`.

Pass each agent:
- The full diff
- The list of changed files
- Instruction to Read each changed file in full AND its 2-3 sibling files
- All applicable `.ruler/` rules collected in step 2
- Their assigned section from [compliance-rubric.md](references/compliance-rubric.md)
- The full content of [alan-conventions-checklist.md](references/alan-conventions-checklist.md)
- Focus guidance (if any)

### Agent prompt template

> You are a local compliance reviewer for the Alan codebase. Your job is NOT to find
> bugs or logic errors — it's to find inconsistencies with surrounding code, project
> conventions, and patterns in neighboring files.
>
> Read each changed file AND its 2-3 closest sibling files before analyzing. The diff
> alone is not enough — you must compare against the local context.
>
> For every finding, you MUST include a "Learn" section pointing to a real file in the
> codebase where the correct pattern is used. If you cannot find a concrete example,
> do not report the finding.
>
> **IMPORTANT:** All file references MUST use clickable markdown links:
> `[file.py:42](path/to/file.py#L42)`. Line numbers must match the actual file on disk
> (we checked out the PR branch), not diff offsets. Never use bare backtick paths.
>
> Read references/compliance-rubric.md and follow your assigned section under
> "Agent Focus Areas."
>
> Read references/alan-conventions-checklist.md for the full list of conventions to check.
>
> You are **Agent {1,2,3}** — follow your assigned focus area.
>
> **Output format for each finding:**
> ```
> ### [P{1,2,3}] Short title
> **File:** [path/to/file:line](path/to/file#Lline)
>
> **What:** Factual description of the inconsistency.
>
> **Why:** Why this convention exists — historical context, past incident, or technical reason.
>
> **Learn:** See the correct pattern in:
> - `path/to/example_file:line` — does X correctly
> - Rule: `backend/.ruler/python_guidelines.md` section Y
>
> **Fix:** Concrete code snippet (3 lines max)
> ```
>
> If nothing is wrong in your focus area, return "No issues found."

## Step 4: Consolidate Results

After all 3 agents return, merge their findings:

1. **Deduplicate** — if two agents flag the same location, keep the one with the better Learn section
2. **Group by severity** — P1 first, then P2, then P3
3. **Verify Learn sections** — quick check that referenced files exist (use Glob if unsure)
4. **Number findings** — assign sequential numbers (1, 2, 3...) across all severities for interactive reference

## Step 5: Output

```
## Revue de conformité locale

### P1 — Must fix (le reviewer va flag)
[numbered findings or "Aucun"]

### P2 — Should fix (incohérent avec les voisins)
[numbered findings or "Aucun"]

### P3 — Consider (opportunité d'apprentissage)
[numbered findings or "Aucun"]

---
**Approfondir ?** Tape un numéro pour voir plus d'exemples du bon pattern dans le repo,
"fix all" pour appliquer les corrections, ou "continue" pour passer à la suite.
```

If all 3 agents returned "No issues found":

```
Aucun problème de conformité. Ton code est cohérent avec le contexte local.
```

Do NOT pad with flattery. Silence is approval.

## Step 6: Interactive Mode

When the user responds after the output:

### User types a finding number (e.g., "3")
1. Read 3-5 more files in the codebase showing the correct pattern (expand beyond the initial Learn examples)
2. Explain the history/rationale of the convention if available in ruler files or comments
3. Show the diff between what they wrote and what the convention expects
4. Offer to apply the fix automatically

### User types "fix all"
1. Apply all P1 fixes automatically
2. For each P2 fix, show the change and ask for confirmation before applying
3. Skip P3 fixes (informational only)
4. After all fixes, run the relevant linter/formatter on modified files

### User types "continue"
1. End the compliance review — proceed to whatever comes next in the workflow

### User types "fix N" (e.g., "fix 3")
1. Apply that specific finding's fix
2. Show what was changed
3. Return to the findings list
