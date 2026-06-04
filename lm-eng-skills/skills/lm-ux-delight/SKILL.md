---
name: lm-ux-delight
description: >
  Recommend UX micro-improvements ("delight") during feature development — fewer clicks,
  smarter defaults, anticipatory behaviors, direct outcome links. Reads product specs and
  codebase exploration from a checkpoint or plan, matches against a catalog of proven UX
  patterns, and outputs 3-5 concise recommendations with effort estimates. Use when:
  /lm-ux-delight, 'delight pass', 'UX delight for EP-XXXX', 'suggest UX improvements',
  or when invoked between Part 2 and Part 3 of /lm-guided-feature-development. Also use
  proactively when reviewing any user-facing feature that involves forms, lists, wizards,
  or navigation flows — even if the user doesn't explicitly ask for UX suggestions.
  Not for: visual design (colors, spacing, animations), accessibility audits, or performance.
---

# UX Delight Pass

Analyze a feature's user flow and recommend micro-improvements that reduce friction — fewer
clicks, smarter defaults, anticipatory behaviors, direct links to outcomes. These are UX flow
improvements, not visual changes.

Recommendations are suggestions only. The user decides what to adopt.

## Input

Accept `$ARGUMENTS` as:
- A ticket ID (e.g., `EP-1234`) → look up `.claude/plans/feature-checkpoint-{ticket-id}.md`
- A path to a checkpoint or plan file
- Nothing → check if a checkpoint exists for the current branch's ticket

If nothing found, use `AskUserQuestion` to ask for the ticket ID.

## Step 1: Read Context

Read the checkpoint file. Extract from two sections — no additional codebase exploration needed:

**From `## Part 1: Product Requirements`:**
- Feature description and acceptance criteria
- UI pattern type (form, list, wizard, dashboard, etc.)
- Figma specs if present

**From `## Part 2: Technical Architecture`:**
- `relevant_files` — the screens/components being modified
- `patterns` — existing code patterns in the affected area
- `reuse_candidates` — components already available
- `all_usages` — scope of impact

**From deep-context (if `.claude/plans/deep-context-{ticket-id}.md` exists):**
- "Usage Data" section — real user behavior insights from Amplitude
- "How to Test" section — navigation context and user flows

The Part 2 exploration already mapped the codebase. Reuse it entirely — do not spawn
additional Explore agents or Grep searches. The checkpoint has everything needed.

## Step 2: Match Against Patterns Catalog

Read `references/ux-patterns.md`. For each pattern in the catalog, evaluate relevance based on:
- The UI pattern type from Part 1 (form → smart inputs; create action → direct outcome links)
- The code patterns and components found in Part 2
- The user flow described in the acceptance criteria

Score each pattern: **high** (directly applicable), **medium** (could apply with slight adaptation),
or **low** (not relevant). Only recommend high and medium patterns.

## Step 3: Identify New Opportunities

Beyond the catalog, reason about the specific feature flow:
- Count the clicks in the happy path described by the specs. Can any be eliminated?
- After the main action (submit, create, send), where does the user land? Can they be taken
  directly to the result?
- Are there inputs that could have smarter defaults based on context already available?
- Is there a "dead end" in the flow where the user has to navigate back manually?

If you spot an opportunity not covered by the catalog, include it as "Nouvelle observation".

## Step 4: Generate Recommendations

Produce **3 to 5** recommendations. Each follows this format:

```
### {N}. {Titre court}
**Pattern** : {nom du catalogue, ou "Nouvelle observation"}
**Quoi** : Une phrase décrivant l'amélioration.
**Pourquoi** : Bénéfice utilisateur concret (moins de clics, task completion plus rapide, moins d'erreurs).
**Effort** : Trivial / Moyen
**Exemple dans le repo** : {chemin fichier + ligne, ou réf PR — seulement si applicable}
```

Rules:
- Minimum 3, maximum 5
- At least 1 must be "Trivial" effort
- Sort by effort (trivial first), then by estimated impact
- Never recommend visual changes (colors, fonts, spacing, animations, icons)
- "Moyen" means it needs backend changes or touches multiple files. "Trivial" means frontend-only, single file
- If a recommendation matches a catalog pattern, reference it. If new, mark as "Nouvelle observation"

## Step 5: Present to User

Display a header:

```
## Suggestions UX Delight pour {ticket-id}

Feature : {résumé 1 ligne}
Flow actuel estimé : {nombre de clics} clics pour le happy path

{recommendations}

---
Ces suggestions sont optionnelles. Choisis celles qui valent le coup, ou passe.
```

Then use `AskUserQuestion` with `multiSelect: true`:
- One option per recommendation (label: `"{N}. {titre court}"`, description: the "Quoi" line)
- "Adopter toutes"
- "Passer — continuer"

## Step 6: Update Checkpoint

**If any recommendations adopted**: Append to the checkpoint file:

```markdown
## UX Delight (optionnel)
{list of adopted recommendations, each as a short bullet}
```

Insert between `## Part 2` and `## Part 3` (or at the end if Part 3 doesn't exist yet).

**If skipped**: Append `## UX Delight (optionnel)\nPassé.`

When used within the guided workflow, the adopted suggestions will be carried into the plan file
so that Part 6 (Implementation) can account for them.

## Step 7: Enrich Catalog

If any "Nouvelle observation" was adopted, ask:

"Ajouter ce pattern au catalogue UX pour les futures features ?"

If yes, append the new pattern to `references/ux-patterns.md` following the existing format.

## Principles

- **Recommander, jamais imposer** — the user picks what matters
- **UX flow only** — clicks, navigation, defaults, feedback. Never visual design
- **Réutiliser le contexte existant** — the checkpoint already has the code exploration. Don't re-explore
- **Rester léger** — 3-5 suggestions, not a research report
- **Référencer du concret** — link to real files, PRs, or patterns when possible
