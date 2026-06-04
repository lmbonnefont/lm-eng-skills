---
name: lm-review-all
description: >
  Revue complète d'une PR : lance /review (bugs, qualité, tests), /lm-local-compliance-review
  (conventions, ruler rules), /lm-ux-delight (micro-améliorations UX), /lm-reviewer-rules
  (règles extraites des reviews de Bastien Landre & Mickaël Berguem), /lm-hardcore-review
  (revue thermo-nucléaire qualité structurelle, code judo, spaghetti) en parallèle, plus
  un 6ème agent Context Walkthrough qui produit résumé non-technique + glossaire + flow via
  /lm-flow-walkthrough affiché en préambule avant les findings. Agrège les findings en
  rapport P0-P3 avec badges source. Utiliser quand : /lm-review-all, "revue complète",
  "full review", "review everything", "all reviews on PR #123", "lance toutes les revues",
  ou toute demande de lancer plusieurs revues sur les mêmes changements. Aussi utiliser
  quand l'utilisateur demande une revue approfondie avant merge ou avant de demander un
  review humain.
---

# Revue Complète (orchestrée)

Lance 6 subagents en parallèle : 5 revues (`/review`, `/lm-local-compliance-review`,
`/lm-ux-delight`, `/lm-reviewer-rules`, `/lm-hardcore-review`) en background + 1 Context
Walkthrough (glossaire + flow) en foreground.
Le walkthrough s'affiche dès qu'il finit, **avant** l'agrégation des findings, pour
que le reviewer commence à lire le contexte pendant que les reviews tournent encore.

Les findings sont ensuite fusionnés en un rapport unique classé par priorité. Chaque
finding cite son origine et inclut des références `fichier:ligne`.

Ce skill **orchestre** — il ne review pas lui-même. Il délègue, agrège, déduplique.

## Usage

- `/lm-review-all` — auto-detect (branche courante, changements non commités, dernier commit)
- `/lm-review-all PR#123` ou `/lm-review-all https://github.com/.../pull/123` — PR spécifique
- `/lm-review-all abc123f` — commit spécifique
- `full review` / `revue complète` / `review everything` — déclenchement en langage naturel

## Step 1 : Déterminer la cible

Utiliser `$ARGUMENTS` si fourni, sinon auto-détecter :

1. **PR number/URL dans les args** → stocker comme `TARGET` (ex: `PR#123`)
2. **Commit SHA dans les args** → stocker comme `TARGET`
3. **Sur feature branch** (pas `main`) → `TARGET` = branche courante (les sub-skills auto-détectent)
4. **Changements non commités** → `TARGET` = vide (les sub-skills auto-détectent)
5. **Fallback** → `TARGET` = vide

Extraire aussi le **ticket ID** depuis la branche ou le titre PR (pattern `EP-XXXX`, `OHSET-XXX`,
`SIM-XXXX`, etc.) pour `/lm-ux-delight`.

## Step 1.5 : Pré-calculer le scope PR (DIFF_FILES)

**Avant de lancer les sous-agents**, calculer la liste exacte des fichiers modifiés par la cible.
Cette liste (`DIFF_FILES`) est la seule source de vérité sur le périmètre de la PR. Elle sera injectée
dans les prompts des 5 sous-agents pour les empêcher d'analyser des fichiers hors-PR.

- Si TARGET est une PR (numéro ou URL) → `gh pr diff {PR_NUMBER} --name-only`
- Si TARGET est un commit SHA → `git show --name-only --format="" {SHA}`
- Si TARGET est une branche ou vide → `git diff main...HEAD --name-only`

Stocker le résultat comme `DIFF_FILES` (liste de chemins, un par ligne).

> **Pourquoi c'est critique :** sans ce scope explicite, chaque sous-agent s'auto-scope sur la branche
> entière (ou le repo), ce qui génère des findings et un résumé portant sur des fichiers absents du diff.
> Un sous-agent UX Delight qui voit toute la branche produira des suggestions pour des fichiers que cette
> PR ne touche pas, polluant le rapport et trompant le reviewer.

## Step 2 : Préparer le contexte UX Delight

`/lm-ux-delight` fonctionne idéalement à partir d'un checkpoint, pas d'une PR.

1. Si ticket ID trouvé → vérifier si `.claude/plans/feature-checkpoint-{ticket-id}*.md` existe
2. **Si checkpoint trouvé** → passer le ticket ID au subagent UX Delight
3. **Si pas de checkpoint** → le subagent UX Delight recevra instruction d'analyser les fichiers
   changés de la PR pour identifier les opportunités UX (mode dégradé, moins précis mais utile)

## Step 3 : Lancer les 6 subagents en parallèle (orchestration asymétrique)

**Le walkthrough ne doit pas bloquer les findings, et surtout le préambule
Contexte doit s'afficher avant que les reviews soient terminées.**

Dans **un seul message**, lancer :

- Subagent 1 (Code Review) avec `run_in_background: true`
- Subagent 2 (Compliance Review) avec `run_in_background: true`
- Subagent 3 (UX Delight) avec `run_in_background: true`
- Subagent 4 (Reviewer Rules) avec `run_in_background: true`
- Subagent 5 (Hardcore Review) avec `run_in_background: true`
- Subagent 6 (Context Walkthrough) **en foreground** (pas de `run_in_background`,
  ou `run_in_background: false`)

Comportement : le message se bloque uniquement sur le walkthrough. Dès qu'il
retourne, passer directement au **Step 4.4** (afficher le préambule). Les 5
reviews continuent à tourner en background ; leurs notifications de fin
arriveront plus tard, déclenchant Step 4 (agrégation) + Step 5 (findings).

**IMPORTANT** : aucun subagent ne doit interagir avec l'utilisateur. Pas de
`AskUserQuestion`, pas de mode interactif. Ils retournent leur rapport et c'est tout.

### Subagent 1 : Code Review

```
PR scope — the ONLY files changed in this PR:
{DIFF_FILES}

Scope your analysis strictly to these files. Do not analyze, mention, or make claims about
files outside this list. If a skill you invoke returns findings on other files, discard them.

You MUST use the Skill tool to invoke the /review skill. Do NOT review the code yourself.

Call: Skill(skill: "review", args: "{TARGET}")

Return ONLY the structured report (P0, P1, P2 sections) as produced by the skill.
Do not summarize or rephrase. Each finding must include file:line.

If the skill produces "No issues found.", return exactly that.

Do NOT use AskUserQuestion. Do NOT ask questions. Just execute and return.
```

### Subagent 2 : Compliance Review

```
PR scope — the ONLY files changed in this PR:
{DIFF_FILES}

Scope your analysis strictly to these files. Do not analyze, mention, or make claims about
files outside this list. If a skill you invoke returns findings on other files, discard them.

You MUST use the Skill tool to invoke the /lm-local-compliance-review skill. Do NOT review conventions yourself.

Call: Skill(skill: "lm-local-compliance-review", args: "{TARGET}")

Return ONLY the structured report (P1, P2, P3 sections) with Learn sections as produced by the skill.
Do not summarize or rephrase. Each finding must include file:line.

If the skill finds nothing, return "No issues found."

Do NOT use AskUserQuestion. Do NOT ask questions. Just execute and return.
```

### Subagent 3 : UX Delight

**Si checkpoint trouvé :**
```
PR scope — the ONLY files changed in this PR:
{DIFF_FILES}

Scope your analysis strictly to these files. Do not analyze, mention, or make claims about
files outside this list. If the skill returns suggestions for files not in this list, discard them.

You MUST use the Skill tool to invoke the /lm-ux-delight skill. Do NOT analyze UX yourself.

Call: Skill(skill: "lm-ux-delight", args: "{ticket_id}")

Return ONLY the list of recommendations as produced by the skill.
Do not summarize or rephrase. Do not modify the checkpoint.

Do NOT use AskUserQuestion. Just execute and return.
```

**Si pas de checkpoint :**
```
PR scope — the ONLY files changed in this PR:
{DIFF_FILES}

Scope your analysis strictly to these files. Do not analyze, mention, or make claims about
files outside this list. If the skill returns suggestions for files not in this list, discard them.

You MUST use the Skill tool to invoke the /lm-ux-delight skill. Do NOT analyze UX yourself.

Call: Skill(skill: "lm-ux-delight")

The skill will auto-detect the current branch. If the skill asks for a ticket ID via
AskUserQuestion, answer with the branch name so it can attempt auto-detection.

If the skill cannot proceed, then — and ONLY then — analyze the changed frontend files
from the PR scope above for 3-5 UX opportunities: fewer clicks, smarter defaults,
direct outcome links. Only suggest improvements for files listed in DIFF_FILES.
For each recommendation, include:
- Short title
- What: 1 sentence
- Effort: Trivial or Moyen
- File: file:line reference (must be a file in DIFF_FILES)

Do NOT use AskUserQuestion with the end user.
```

### Subagent 4 : Reviewer Rules (Bastien & Mickaël)

```
PR scope — the ONLY files changed in this PR:
{DIFF_FILES}

Scope your analysis strictly to these files. Do not analyze, mention, or make claims about
files outside this list. If a skill you invoke returns findings on other files, discard them.

You MUST use the Skill tool to invoke the /lm-reviewer-rules skill. Do NOT apply rules yourself.

Call: Skill(skill: "lm-reviewer-rules", args: "{TARGET}")

Return ONLY the structured report (P1, P2, P3 sections) as produced by the skill.
Each finding must include file:line and the source PR link.
If nothing matches, return "No issues found."

Do NOT use AskUserQuestion. Do NOT ask questions. Just execute and return.
```

### Subagent 5 : Hardcore Review (qualité structurelle, code judo, spaghetti)

```
PR scope — the ONLY files changed in this PR:
{DIFF_FILES}

Scope your analysis strictly to these files. Do not analyze, mention, or make claims about
files outside this list. If a skill you invoke returns findings on other files, discard them.

You MUST use the Skill tool to invoke the /lm-hardcore-review skill. Do NOT review the code yourself.

Call: Skill(skill: "lm-hardcore-review", args: "{TARGET}")

The skill performs a thermo-nuclear maintainability review focused on:
- Structural code-quality regressions and missed "code judo" simplification opportunities
- Files growing past 1000 lines without strong justification
- Spaghetti growth (ad-hoc conditionals, scattered special cases, one-off branches)
- Thin/magical abstractions, unnecessary wrappers, cast-heavy contracts
- Feature logic leaking into shared paths instead of dedicated abstractions
- Non-atomic updates and unnecessarily sequential orchestration

Return ONLY the structured findings as produced by the skill. Each finding must include
file:line and a clear "preferred remedy" (delete a layer, reframe state, extract helper,
split file, move to canonical layer, etc.).

If the skill produces "No issues found." or its equivalent ("PR meets the approval bar"),
return exactly that.

Do NOT use AskUserQuestion. Do NOT ask questions. Just execute and return.
```

### Subagent 6 : Context Walkthrough (résumé + glossaire + flow)

Le 6ème subagent tourne **en parallèle des 5 autres dans le même message Agent**,
mais en **foreground** (les 5 autres sont `run_in_background: true`). Son résultat
alimente le préambule du rapport (Step 4.4) et ne participe pas à l'agrégation
P0-P3.

Prompt du subagent :

```
PR scope — the ONLY files changed in this PR:
{DIFF_FILES}

Scope your outputs strictly to these files. The résumé, glossaire, and walkthroughs must
only describe what these files do. Do not mention or describe files outside this list.
This is especially important for the résumé: if a file appears on the branch but is NOT
in DIFF_FILES, it is not part of this PR and must not appear in any output.

You are building ramp-up context for a PR reviewer. Do NOT review code quality —
that is other subagents' job. Your job: help the reviewer understand WHAT the PR
touches and HOW the current code works.

Produce 3 outputs:

---
**OUTPUT 0 — Résumé non-technique** (3-5 phrases, en français)

Le but : permettre à n'importe qui (même non-dev, ou dev qui ne connaît pas le
domaine) de comprendre en 20 secondes CE QUE la PR fait et POURQUOI, avant de
plonger dans le détail technique.

1. Collecte :
   - PR title + description (si PR#N ou URL) : `gh pr view {N} --json title,body`
   - Sinon, inspecter : branch name + derniers commits (`git log -10 --oneline`)
     + fichiers modifiés (list du step 1 plus bas)
   - Si un ticket ID est présent (EP-XXXX, OHSET-XXX, etc.) dans le titre ou
     la branche, essayer `mcp__linear__get_issue` pour enrichir avec la
     description produit du ticket.
2. Rédige 3-5 phrases courtes, **sans jargon technique** :
   - Phrase 1 : problème ou besoin utilisateur/métier que la PR adresse.
   - Phrase 2-3 : ce que la PR change concrètement, du point de vue utilisateur
     ou opérationnel (pas "ajoute un endpoint X" mais "permet aux admins OH
     de voir Y dans le dashboard").
   - Phrase 4 (optionnelle) : impact attendu / périmètre (quel pays, quel
     persona, quelle surface).
   - Évite : noms de fonctions, noms de tables, noms de classes, patterns
     techniques. Si tu DOIS citer un terme métier spécifique, il sera défini
     juste après dans le Glossaire.
3. Si tu ne peux pas inférer le "pourquoi" depuis les sources ci-dessus,
   marque-le `[à confirmer avec l'auteur de la PR]` — ne pas inventer une
   motivation produit.

Format :
> {3-5 phrases en prose, en français, lisibles par un non-dev}

---
**OUTPUT 1 — Glossaire** (3-5 termes)

1. Get the PR diff file list (TARGET = "{TARGET}"):
   - If PR#N or URL → `gh pr diff {N} --name-only`
   - If commit SHA → `git show --name-only {SHA}`
   - If branch (empty TARGET) → `git diff main...HEAD --name-only` then
     `git diff --name-only` for uncommitted
2. Extract 3-5 business/domain terms from: PR title, branch name, modified
   file paths (component names, module names), and function names in the diff.
   Skip generic terms (User, Config, Service).
3. For each term, write ONE sentence defining it based on code context
   (grep the term in README.md files, component docstrings, or type defs).
   If you can't find a definition, mark it `[unverified]` — don't invent.

Format:
- **{TERM}** — {1-sentence definition}. Ref: `path/to/file:line`

---
**OUTPUT 2 — Walkthroughs** (scope PR-only)

1. From the diff file list, identify ALL entry points touched by the PR:
   - Backend: files under `**/controllers/**`, `**/public/**` — each modified
     function = an entry point
   - Frontend: files under `**/screens/**`, `**/hooks/**`, `**/src/pages/**`
     — each modified exported function/component = an entry point
   - Ignore: tests, migrations, `__pycache__`, generated files, `.ruler/`
2. Keep in memory the **SET of modified files** (from step 1 of OUTPUT 1).
   This set = "PR scope". Files outside this set = "out of scope".
3. For EACH entry point found, invoke `/lm-flow-walkthrough` in caller mode:

   Call: Skill(skill: "lm-flow-walkthrough", args: "--caller {file}:{function}")

   The skill returns both a JSON blob and a human-readable output. Keep only
   the human-readable narrative (Section A call chain + Section B evidence
   trace) — drop the JSON.
4. **Trim the narrative before returning it** :
   - For hops / call chain steps pointing to files **IN PR scope** → keep
     the detailed explanation as returned by the skill (rules, edge cases,
     deep dive).
   - For hops pointing to files **OUT of PR scope** → replace detailed
     explanation with a one-liner narrative + clickable `fichier:ligne`.
     Example: `→ calls get_subscriber_establishments in
     [establishments.py:18](backend/.../establishments.py#L18) (out of PR
     scope, not detailed).`
   - Drop `[GAP]` markers that land on out-of-scope files (noise for
     ramp-up of THIS PR).
5. If the list has more than 5 entry points, trace the top 5 by "centrality"
   (controllers before utils, new files before modified, bigger diffs first)
   and add a note: "N-5 more entry points not traced — ask if needed."

Return les 3 outputs concaténés dans l'ordre (Résumé → Glossaire → Walkthroughs).
Do NOT use AskUserQuestion. Do NOT wait for other subagents. Do NOT produce P0-P3
findings — that's not your job.
```

## Step 4.4 : Afficher le préambule contexte dès que le walkthrough est prêt

Le subagent 6 (foreground) retourne `Résumé` + `Glossaire` + `Walkthroughs`.
**Afficher tout de suite** ce bloc à l'utilisateur, sans attendre les 5 reviews
en background. Le Résumé vient **en premier** : c'est l'angle non-technique qui
permet d'aligner le reviewer sur le "pourquoi" avant de plonger dans le "comment".

```
## Revue complète — {cible}

### 📚 Contexte PR (ramp-up)

**Résumé**
{résumé non-technique du subagent 6, 3-5 phrases en prose}

**Glossaire**
{liste glossaire du subagent 6}

**Walkthroughs**
{walkthroughs du subagent 6, un par entry point}

---
_Revues en cours en arrière-plan (/review, /lm-local-compliance-review, /lm-ux-delight, /lm-reviewer-rules, /lm-hardcore-review)..._
```

Aucune fusion/déduplication, pas de re-priorisation. Simple relai.

## Step 4.5 : Attendre les notifications background

Ne pas polling. Les notifications de fin des 5 subagents arrivent via le runtime.
Quand tous sont revenus, passer au Step 4 (agrégation P0-P3) puis Step 5
(affichage des findings sous le préambule déjà posté).

## Step 4 : Agréger et mapper les priorités

Quand les 5 subagents ont retourné leurs résultats, fusionner selon cette table :

| Priorité agrégée | Source | Priorité originale |
|---|---|---|
| **P0 — Bloquant** | `/review` | P0 |
| **P1 — À corriger** | `/review` | P1 |
| | `/lm-local-compliance-review` | P1 (Must fix) |
| | `/lm-reviewer-rules` | P1 |
| | `/lm-hardcore-review` | Structural regression, spaghetti growth, fichier >1k lignes, abstraction-boundary leak, canonical-helper duplication (= "presumptive blocker" selon le skill) |
| **P2 — À considérer** | `/review` | P2 |
| | `/lm-local-compliance-review` | P2 (Should fix) |
| | `/lm-reviewer-rules` | P2 |
| | `/lm-ux-delight` | Effort = Trivial |
| | `/lm-hardcore-review` | Missed "code judo" simplification, type/boundary cleanliness suggestion, orchestration / non-atomic update flag (sans presumptive-blocker) |
| **P3 — Bonus** | `/lm-local-compliance-review` | P3 (Consider) |
| | `/lm-reviewer-rules` | P3 |
| | `/lm-ux-delight` | Effort = Moyen |
| | `/lm-hardcore-review` | Legibility / maintainability nit, thin wrapper sans impact structurel majeur |

### Règles de fusion

1. **Dédupliquer** — si plusieurs sources flaggent le même `fichier:ligne` (même fichier,
   lignes à ±5 du même endroit), garder le finding le plus détaillé et noter toutes les
   sources dans le badge : `[review + compliance]`, `[hardcore + rules]`, etc. Le hardcore
   review et le code review se recouvrent souvent sur les sujets structurels — la fusion
   évite le doublon.
2. **Numéroter** — numéros séquentiels (1, 2, 3...) à travers toutes les priorités
3. **Taguer** — chaque finding porte un badge : `[review]`, `[compliance]`, `[rules]`,
   `[ux-delight]`, ou `[hardcore]`

## Step 5 : Output des findings (sous le préambule)

Le préambule Contexte PR a déjà été posté au Step 4.4. Step 5 n'affiche **que**
les sections findings, qui se greffent sous le préambule en streaming. Ne pas
re-render le titre `## Revue complète — {cible}` ni la section Contexte.

```
### P0 — Bloquant
{findings numérotés ou "Aucun"}

### P1 — À corriger
{findings numérotés ou "Aucun"}

### P2 — À considérer
{findings numérotés ou "Aucun"}

### P3 — Bonus
{findings numérotés ou "Aucun"}

---
Sources : /review ({N} findings), /lm-local-compliance-review ({N} findings), /lm-reviewer-rules ({N} findings), /lm-ux-delight ({N} suggestions), /lm-hardcore-review ({N} findings), /lm-flow-walkthrough ({N_entry_points} flows)

---
**Actions ?** Tape un numéro pour approfondir, "fix all P0-P1" pour corriger les urgents,
"fix N" pour un fix spécifique, ou "done" pour terminer.
```

### Format de chaque finding

```
**{N}. [{source}] {titre court}**
**Fichier :** [`path/to/file:ligne`](path/to/file#Lligne)
{description — 1-2 phrases max}
{section Learn si source = compliance}
{Fix : snippet 3 lignes max si applicable}
```

### Cas "aucun problème détecté"

Si les 5 subagents review retournent "No issues found" / "Aucune suggestion",
afficher quand même le préambule Contexte PR (déjà posté au Step 4.4 — il a
de la valeur ramp-up en soi), puis :

```
Aucun problème détecté par les revues automatiques.
```

Pas de compliment. Le silence est approbation.

## Step 6 : Mode interactif

### Numéro (ex: "3")
- Source `[compliance]` → afficher les exemples Learn étendus (3-5 fichiers du bon pattern)
- Source `[review]` → afficher le trigger et le root cause détaillés
- Source `[ux-delight]` → afficher le pattern catalogue et l'effort détaillé
- Source `[hardcore]` → afficher le "preferred remedy" complet (delete a layer, reframe state, extract helper, split file, move to canonical layer) et la justification structurelle

### "fix all P0-P1"
1. Appliquer les fixes P0 automatiquement
2. Pour chaque P1, montrer le changement et demander confirmation
3. Après les fixes, relancer formatters/linters sur les fichiers modifiés

### "fix N"
Appliquer le fix spécifique, montrer le changement.

### "done"
Terminer la revue.
