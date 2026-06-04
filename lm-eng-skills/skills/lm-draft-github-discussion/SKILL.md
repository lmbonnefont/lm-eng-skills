---
name: lm-draft-github-discussion
description: >
  Rédige une GitHub Discussion sur alan-eu/Topics dans la voix de Louis-Marie, après
  avoir cadré le contenu via /lm-grill-me. Applique la Problem-Solving Method d'Alan
  (Scoping / Framing / Making) + la critique reçue le 2026-06-01 de Marion Doumeingts
  sur la discussion Work Stoppage : la clarté doit apparaître DANS LES 3 PREMIÈRES
  LIGNES (problem / measure / options / decision needed). Adapte la longueur au type :
  Quick need = 5-8 lignes, Framing = long-form structuré, Scoping = 10-15 lignes,
  Making = medium avec split product/tech.
  Utiliser quand : /lm-draft-github-discussion, "create a GH discussion", "draft a
  framing discussion for [project]", "open a discussion on alan-eu/Topics about X",
  "scoping discussion pour [topic]", "écris une discussion Making pour [feature]",
  "GitHub Discussion sur [Linear ticket]", "frame [problem] for the team", "discussion
  pour cadrer [besoin]", "draft a problem statement for [topic]", "rédige une
  discussion pour aligner sur [decision]".
  Aussi quand l'utilisateur partage une URL Linear/Slack/Notion et dit "fais-en une
  GH discussion".
  Ne pas utiliser pour : Slack messages (utiliser /lm-draft-message), Notion updates
  (utiliser /lm-draft-message), PR descriptions (utiliser /update-pr-description),
  commit messages, replies dans une discussion existante (juste rédiger directement).
---

# lm-draft-github-discussion

Cadre puis rédige une GitHub Discussion qui passe le test de clarté de Marion :
**dans les 3 premières lignes, le lecteur sait quel problème, comment on mesure,
quelles options, et quelle décision est demandée**.

## Pourquoi ce skill

Feedback Marion Doumeingts (2026-06-01) sur
[Work stoppages - Framing - V0 scope](https://github.com/alan-eu/Topics/discussions/33112) :

> "the writing initially felt quite technical, which made it hard for me to quickly
> understand the options, the trade-offs, and what input you expected from me. The
> next step is to make that clarity visible earlier in the written framing."

Une discussion sert un de 4 jobs Alan ([Problem-Solving Method](https://www.notion.so/alaninsurance/Problem-Solving-Method-52dab6d4c35b46c185b6990c19bc416d)) :
Scoping, Framing, Making, Monitoring. Le format s'adapte au job. Un Scoping qui
adopte le format Framing échoue : trop long, trop tôt.

Skill séparé de `lm-draft-message` (générique Slack/Notion/GH) car : le grill amont
est obligatoire ici, les templates par phase sont propres à Alan, et le test de Marion
est l'unique critère de succès.

## Workflow (5 étapes)

### Étape 1 — Type de discussion

Une question `AskUserQuestion`, 5 options :

| Type | STEP titre | Quand | Longueur |
|---|---|---|---|
| **Scoping** | `Scoping` | Tôt — comprendre le problème, ça vaut le coup ? | 10-15 lignes |
| **Framing** | `Framing` | Identifier les solutions. Type le plus exigeant, cible du test Marion. | Long-form |
| **Making** | `Making` | Aligner sur V0 et plan d'exécution. | Medium, structured |
| **Monitoring** | `Monitoring` | Post-ship — la solution résout-elle le problème ? | Short-medium, data-driven |
| **Quick need** | *(skip)* | Cadrer un besoin / poser une question ouverte. | 5-8 lignes |

STEP dans le titre en **proper-case**, pas all-caps (source : Notion
[Making decisions on Github](https://www.notion.so/alaninsurance/Making-decisions-on-Github-ec89a8f05c954f4cbdf5ecd3663d2763)).

Si le prompt contient déjà un signal clair ("framing discussion", "V0 scope", "4 semaines
après le ship") → saute la question, confirme inline en une phrase.

### Étape 1.5 — Nature du contenu (product / technical / both)

Deuxième question `AskUserQuestion`, sauf signal explicite :

| Option | Quand | Effet |
|---|---|---|
| **Product** | Décision produit pure. Audience PM/design/ops. | Pas de section technique. |
| **Technical** | Décision techno pure. Audience eng-only. | Tout inline, pas de toggle. |
| **Both (mixed)** | Le cas le plus fréquent. | Produit inline, technique dans `<details>` toggles. |

**Règle de strates (asymétrique)** : le produit reste top-level (un eng le lit comme
contexte), le technique va dans des `<details>` toggles (un PM peut l'ignorer sans
manquer la décision). Jamais l'inverse.

```markdown
# 💡 Proposal

<Product framing — outcomes, user-facing flow, decision points>

<details>
<summary>Technical details</summary>

<Tech framing — endpoints, data model, FF, migrations, risques>

</details>
```

Cas particuliers : Pure-product/technical → tout inline. Quick need mixte → produit en
surface, toggle UNE réf technique si nécessaire. Making mixte → `## Product side` inline
+ `<details> Technical side </details>` (voir `references/templates.md`).

### Étape 2 — Enrich from linked artifacts

Si l'input contient des URLs/IDs, probe obligatoire : les décisions vivent dans les
comments, pas les OPs. Une discussion bâtie sur l'OP seul sera factuellement décalée.

| Pattern | Commande |
|---|---|
| `github.com/alan-eu/.../discussions/<N>` | `gh api graphql -f query='query { repository(owner:"alan-eu", name:"<repo>") { discussion(number:<N>) { title body comments(first:50) { nodes { author{login} body createdAt replies(first:20) { nodes { author{login} body createdAt } } } } } } }'` |
| `github.com/alan-eu/.../pull/<N>` ou `PR #<N>` | `gh pr view <N> --repo alan-eu/<repo> --comments` |
| `linear.app/...` ou `OHSET-N` / `EP-N` / `PAY-N` / `OHST-N` | `mcp__claude_ai_Linear__get_issue` puis `mcp__claude_ai_Linear__list_comments` |
| `notion.so/...` ou `app.notion.com/...` | `mcp__claude_ai_Notion__notion-fetch` |
| `alanhealth.slack.com/archives/...` | `mcp__claude_ai_Slack__slack_read_thread` |
| `quillmeetings.com/share?id=...` | `mcp__quill__get_meeting` ou `mcp__quill__get_transcript` |

Fetch en parallèle. Extraire : timeline des reframings, décisions agréées vs en
discussion, questions ouvertes, stakeholders déjà prononcés. Si zéro URL → noter "no
linked artifacts to enrich from" dans l'audit final.

### Étape 3 — Caller `/lm-grill-me`

Invoque `lm-grill-me` en caller mode avec la bank du type :

```
Skill(lm-grill-me) avec args :
  --caller lm-draft-github-discussion
  --bank references/grill-bank.md
  --section <scoping|framing|making|quick-need>
```

Retourne `{questions_asked, unresolved, decisions_summary}` → alimente le draft (Étape 4).

**Exception** : si l'utilisateur a déjà fourni le contenu détaillé (brouillon, transcript,
link enrichi avec décisions explicites), confirme en 1 question : "I have enough to draft
directly, or grill you first to sharpen the framing?". Recommande skip si le contenu passe
déjà le test des 3 premières lignes.

**Toujours grill pour les Framing** — phase la plus risquée, là où Marion s'applique le plus.

### Étape 4 — Draft selon template

Lire `references/templates.md` et appliquer le template du type. Squelette commun aux 4
types, **6 sections H1 avec emoji** (scannabilité GitHub) :

```
# 🔭 Scope                          → ce que c'est + ce que ce n'est PAS
# 🕐 Why I'm opening this discussion → trigger + lien Linear project
# 📅 Timeline                        → decision by <date>
# ℹ️ LOCI                            → Lead & Owner / Consulted / Informed
# 🌐 Context & Materials             → links + bold dependencies + sub-H2
# 💡 Proposal                        → contenu type-specific
```

Header : **HTML comment Alan** verbatim (copie depuis templates.md, réf docs Notion).
Fin du body : bloc `### Threads` verbatim avec checkbox cochée (`[X] Please use threads`).

**Title format** (Notion guide) : `[<Crew/Area/Community/Unit>] <Subject> - <STEP> - <Title>`

- Area : `[OccHealth Setup]`, `[Occupational Health]`, `[Prévenir]`, etc.
- Subject : 1 mot si possible, caps réservés aux acronymes.
- STEP : proper-case, optionnel (Quick need l'omet).

Ex : `[Occupational Health] Work Stoppages - Framing - Re-open a wrongly-closed stoppage`

#### Règle d'or — Marion test mappé sur le template

Si un lecteur s'arrête après `# ℹ️ LOCI` (4 premières sections), il sait déjà :

| Marion test | Section |
|---|---|
| What problem? | `# 🔭 Scope` bullet 1 |
| What's NOT? | `# 🔭 Scope` bullet 2 |
| Why now? | `# 🕐 Why I'm opening this discussion` |
| By when? | `# 📅 Timeline` |
| Who decides? | `# ℹ️ LOCI > Lead & Owner` |
| Whose input? | `# ℹ️ LOCI > Consulted` |

Métrique de progression et reco viennent ensuite (`# 🌐 Context & Materials > ## How
we'll measure progress`, `# 💡 Proposal`). Le squelette Alan EST le Marion test.

#### Conventions de voix

- **Output 100% anglais, toujours.** Domain terms FR sans équivalent (DSN, SIRET, AMT,
  IDEST, IPRP, visite de reprise, Cadres/Non-Cadres) restent inline en français.
- **Pas de tirets cadratins (—)**. Utiliser `:`, `.`, `,`.
- **Pas de code-switching FR/EN** ("Au top" → "Sounds good").
- **Acronymes expandés au premier usage** (PR → Pull Request, OH → Occupational Health).
- **Headings explicites** : `## Problem`, `## Options`, `## Decision I need` — pas `## Context`.
- **Bullets pour idées same-level**, pas de paragraphes denses pour énumérer (feedback Joachim Lis 2026-04).
- **`<details>` toggles pour le contenu long** (blank lines obligatoires avant/après le body
  du toggle, sinon GitHub ne parse pas le markdown). Détail : `references/alan-methodology.md` Rule 21.
- Emojis avec parcimonie : :rocket:, :tada:, :hand:, :wave:, :hammer_and_wrench:.

#### Concision (objectif principal de ce skill)

- **Phrases pleines, chaque phrase porte une info.** Pas de transition décorative, pas de
  recap, pas de formule de politesse. Si une phrase peut sauter sans perte d'info, elle saute.
- **Pas d'effet de style.** Pas de tournure rhétorique ni d'emphase gratuite. Pas d'adverbe
  (rule 14, alan-methodology.md). Le ton reste celui de LM (direct, conversationnel) mais sans ornement.
- **Sections optionnelles omises quand vides.** Pour Scoping / Quick need / Monitoring, une
  section H1 qui n'aurait qu'un placeholder ou du boilerplate est supprimée, pas remplie de vide.
  **Exception : Framing garde les 6 H1** (le squelette EST le test de Marion).
- **Préambule minimal.** La réponse mène avec le preview du draft. Pas de "voici le draft que
  j'ai préparé", pas de méta-commentaire. Les confirmations de type (Étape 1/1.5) restent inline
  en une phrase.

### Étape 5 — Pass 2 : Audit de clarté visible

Output **toujours** cette checklist après le draft (ancre les patterns par répétition,
objectif growth C1→D sur "audience-aware writing") :

```markdown
## Clarity audit (Marion test + Alan template compliance)

Alan template compliance:
- [x] HTML comment Alan in header (verbatim)
- [x] Title format: `[<Area>] <Subject> - <STEP> - <Title>`
- [x] All 6 H1 sections present (Scope, Why, Timeline, LOCI, Context & Materials, Proposal)
- [x] Emoji prefixes on H1s (🔭, 🕐, 📅, ℹ️, 🌐, 💡) — Unicode literal, not Slack notation
- [x] LOCI complete: Lead & Owner + Consulted + Informed all populated

Marion test (clarity in first 4 sections):
- [x] `# 🔭 Scope` says what it IS and what it is NOT
- [x] `# 🕐 Why` links to Linear project / quarter goal
- [x] `# 📅 Timeline` has an explicit date
- [x] `# ℹ️ LOCI` names specific people for Consulted
- [x] Progress metric visible in `# 🌐 Context & Materials > ## How we'll measure progress` (Framing only)
- [x] Options laid out with trade-offs table (Framing only)
- [x] Recommendation stated with rationale (Framing/Making)
- [x] Existing experience referenced (Framing/Making — Marion 2026-06-01)
- [x] Product vs Technical split (Making only, if cross-discipline audience)

Product/Technical strata (Rule 22, asymmetric):
- [x] Audience asked at Étape 1.5 (product / technical / both)
- [x] If "both": product inline + technical in `<details>` toggle
- [x] No inversion: product is never wrapped while technical stays inline
- [x] If pure-product or pure-technical: no toggle, all inline

Voice & conventions:
- [x] No em-dashes
- [x] EN throughout (FR domain terms inline OK)
- [x] Acronyms expanded at first use
- [x] No filler sentences — every sentence carries info
- [x] Optional H1 sections omitted when empty (non-Framing)
- [x] All adverbs killed (rule 14)
- [x] Bold = full sentences only, not keywords
- [x] Alan tone of voice respected (members not customers, Alaners not employees)
- [x] Numbers convention (letters under twelve, figures from 13 — or all figures if mixed)
- [x] Long detail wrapped in `<details>` toggles where helpful (rule 21)
- [x] Threads checkbox set at the end of the body

## Rules applied
- <conventions hit, e.g. "Job statement format for Problem", "Outcome statement for metric">

## Rules deliberately skipped
- <if any, with reason — e.g. "No Options section: Quick need, not a decision request">

## Open questions for you before publishing
- <unresolved items from grill, with the right person to ping for each>
```

## Quand JTBD aide (Framing surtout)

Pour formuler **Problem** et **Progress metric** en Framing (détails
`references/jtbd-cheatsheet.md`) :

- **Job statement** (`Verb + Object + Contextual modifier`), solution-neutre. Ex : "Help OH
  admins **declare a work stoppage** for an employee **without leaving the dashboard**".
- **Outcome statement** (`Direction + Unit of measure + Object`). Ex : "Minimize the number
  of clicks to declare a single work stoppage".

Skip JTBD pour Scoping et Quick need — trop lourd.

## Output final attendu

Trois blocs de draft + audit + open questions. GitHub Discussions parse le markdown brut,
pas le rendu : sans le code block, copier le rendu du chat casse listes/tables/emojis.

### 1. Preview (rendu lisible dans le chat)

Le draft en markdown normal, rendu par le terminal, pour relecture confortable avant copy-paste.

### 2. Raw markdown for GitHub (copy-paste block)

Ré-émettre le même draft dans une seule fence ` ```markdown ` :

````
```markdown
<!-- 
* Should you open a discussion? In doubt check: https://www.notion.so/alaninsurance/How-we-make-decisions-9db7efd39c794f5faff5c645848d863f
* Full documentation: https://www.notion.so/alaninsurance/Issues-on-Github-ec89a8f05c954f4cbdf5ecd3663d2763#0c64466f756a496399d69afce718c5f9
-->

# [<Area>] <Subject> - <STEP> - <Title>

# 🔭 Scope
...

# 🕐 Why I'm opening this discussion
...

# 📅 Timeline
...

# ℹ️ LOCI
...

# 🌐 Context & Materials
...

# 💡 Proposal
...
```
````

Règles du raw block :
- Une seule fence ` ```markdown ` englobe tout.
- HTML comment Alan en tête, verbatim.
- Titre avec `# ` (le champ Title GitHub prend juste le texte — voir Section 3).
- Emojis Unicode literal dans les H1 (`🔭`, `🕐`, `📅`, `ℹ️`, `🌐`, `💡`), pas notation Slack
  `:telescope:` (GitHub ne la convertit pas).
- Aucun commentaire ni "voici le draft :" autour du contenu.

### 3. Posting instructions GitHub

- **Repository** : `alan-eu/Topics`
- **Category** : "Discussions" (default). Alan a abandonné les catégories granulaires : le
  STEP vit dans le titre, le scope vit dans les labels.
- **Labels** : au moins un de la liste canonique (🇧🇪 Belgium, ✨ Corporate and People,
  💼 Customer, 🧱 Foundation, 🇫🇷 France, 🌍 International Expansion, 🧑 Member, 🇪🇸 Spain,
  🛤️ Transversal, 🇨🇦 Canada). OH de LM → 🇫🇷 France (+ 🧑 Member si member-facing).
- **Title field** : la ligne `# ...` du code block, sans le `#` initial.
- **Body field** : tout le reste (HTML comment + 6 H1 + bloc `### Threads`).
- **No double-ping** : ne pas annoncer sur Slack, les notifications GitHub couvrent les LOCI.

### 4. Clarity audit + Open questions

Comme défini à l'Étape 5, APRÈS le raw markdown block pour ne pas polluer la copie.

### Ne pas publier automatiquement

LM relit, ajuste, publie lui-même via l'UI GitHub (ou `gh api graphql` s'il le demande
explicitement). Le skill produit le draft, pas le publish.

## Tips meta (si pertinent)

- **Scoping/Framing depuis page blanche** : suggérer "Have you paired with [stakeholder]
  before drafting? Marion's tip 2026-06-01 : 1-2h async exploration → 30min pair → use the
  transcript to draft." Ne pas insister si LM dit avoir déjà du contexte.
- **Making fait d'un coup** : suggérer de splitter product vs technical en 2 sections (son
  framework du 2026-06-01, validé par Marion comme "good but keep it flexible").
