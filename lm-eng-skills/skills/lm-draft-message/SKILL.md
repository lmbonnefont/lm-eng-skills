---
name: lm-draft-message
description: >
  Rédige un message de communication projet (Slack post, GitHub Discussion, Notion update)
  dans la voix de Louis-Marie, en appliquant les règles structurelles extraites des comms
  projet de Mickaël Bergem et des feedbacks reçus par Louis-Marie sur sa communication écrite.
  Affiche TOUJOURS une checklist d'audit des règles appliquées, même sur les messages
  courts, pour ancrer l'apprentissage (objectif growth C1→D).
  Utiliser quand : /lm-draft-message, "draft a project update", "écris un message projet",
  "comm pour #channel sur X", "prepare Slack post for X", "écris un decision thread",
  "frame this for GitHub Discussion", "draft a kickoff post for [project]",
  "rédige un message pour annoncer [feature/decision]", "publie un update sur [projet]",
  "post pour mid-quarter checkin", "annonce le release de X".
  Ne pas utiliser pour : messages généraux non-projet (utiliser draft-message),
  réécriture stylistique sans contexte projet (utiliser draft-message),
  notes de meeting ou transcripts (utiliser meeting-review).
---

# lm-draft-message

Rédige un message de communication projet dans la voix de Louis-Marie, avec audit visible
des règles appliquées.

## Pourquoi ce skill existe

Feedback récurrent reçu par Louis-Marie sur sa communication écrite :
- *2026-05-18* : « could be more concise, takes a bit more energy to understand the point.
  Leverage more titles and bullet points for same-level ideas. »
- *2026-04 Joachim Lis* : « consolidate communication — too many threads for same topic. »

Ce skill applique ces règles automatiquement à chaque draft + affiche une checklist
explicite pour que Louis-Marie internalise les patterns par répétition.

## Dépendances runtime (à lire à chaque invocation)

| Fichier | Rôle |
|---|---|
| `~/Code/second-brain/wiki/concepts/project-comm-best-practices.md` | Source-of-truth — 20 règles + 8 anti-patterns LM-specific. **Obligatoire** : le skill ne peut pas tourner sans. |
| `~/Code/second-brain/wiki/people/louis-marie-bonnefont-voice-profile.md` | Voix, ton, conventions (bilingue, emojis, préfixes). |
| `~/Code/second-brain/wiki/people/louis-marie-bonnefont-communication-coaching.md` | Growth edges C1→D à appliquer (push back, état explicite des positions, etc). |

Si `project-comm-best-practices.md` est absent : flag à l'utilisateur de lancer
`/lm-comm-research` d'abord. Ne pas tenter de drafter sans le catalogue.

## Workflow

### Étape 1 — Charger les références

Lire les 3 fichiers de dépendances dans l'ordre. Garder la checklist du catalogue
(section "Checklist d'audit") en mémoire pour le Pass 2.

Si la vault n'est pas à `~/Code/second-brain/`, demander à l'utilisateur le chemin
correct (rare — c'est le default Louis-Marie).

### Étape 1.5 — Enrich from linked artifacts (probe obligatoire)

Avant d'aller plus loin, scanner le prompt utilisateur (et tout input ultérieur) pour
des URLs / IDs vers des artifacts vivants, et **fetch leur dernier état complet** —
pas juste le body initial.

**Pourquoi cette étape existe** : les décisions de projet vivent dans les comments et
threads, pas dans l'OP. Un message de status qui reflète seulement le framing initial
sera factuellement faux. Échec observé 2026-05-22 : draft basé sur l'OP d'une
Discussion alors que 3 reframings majeurs (gating drop, scope per-(member, account),
auto-close) vivaient dans les comments. L'utilisateur a dû demander une réécriture.

**Patterns à détecter et commandes à lancer**

| Pattern dans l'input | Commande à lancer |
|---|---|
| `github.com/<org>/Topics/discussions/<N>` ou `github.com/.../discussions/<N>` | `gh api graphql -f query='query { repository(owner:"<org>", name:"<repo>") { discussion(number:<N>) { title body comments(first:50) { nodes { author{login} body createdAt replies(first:20) { nodes { author{login} body createdAt } } } } } } }'` |
| `github.com/<org>/<repo>/pull/<N>` ou mention `PR #<N>` | `gh pr view <N> --repo <org>/<repo> --comments` |
| `linear.app/.../issue/<KEY-N>` ou mention `OHSET-N`, `EP-N`, `PAY-N` | `mcp__claude_ai_Linear__get_issue` puis `mcp__claude_ai_Linear__list_comments` |
| URL Notion (`notion.so/...` ou `app.notion.com/...`) | `mcp__claude_ai_Notion__notion-fetch` avec l'URL |
| URL Quill (`quillmeetings.com/share?id=...`) | `mcp__quill__get_meeting` ou `mcp__quill__get_transcript` |
| URL Slack (`slack.com/archives/...`) | `mcp__claude_ai_Slack__slack_read_thread` |

Si plusieurs artifacts sont liés, fetch-les **en parallèle** dans un seul message.

**Que faire des résultats** : extraire la timeline des reframings, les décisions
agréées, les questions encore ouvertes, les stakeholders qui se sont prononcés. C'est
ce matériau (et pas l'OP) qui doit alimenter le draft. Le résumé interne est court
mais doit explicitement mentionner : "Le scope initial X a été remplacé par Y dans
le comment de Z du <date>" si applicable.

**Quand sauter cette étape** : si l'utilisateur fournit zéro URL et zéro mention
d'artifact, ou si le draft demandé est un quick-sync 1-liner sans contexte projet.
Dans ce cas, mentionner explicitement "no linked artifacts to enrich from" dans la
section "Règles appliquées" pour que ce soit traçable.

### Étape 2 — Collecter les inputs (AskUserQuestion)

Poser **3 questions** via `AskUserQuestion`, max 4 options chacune :

**Q1 — Type de comm**
- Project update / framing (long-form, structure 7 sections)
- Decision thread (options + recommandation)
- Quick sync (Slack court, 1-3 lignes)
- Weekly pulse / standup (préfixes `:check:`/`:done:`/`:todo:`/`:hand:`)

**Q2 — Canal cible**
- Slack — préciser channel (#area_occhealth, #occhealth_setup_crew, autre)
- GitHub Discussion
- Notion
- Autre (texte libre)

**Q3 — Audience principale**
- Crew (Setup, ~5 personnes proches)
- Area (Occupational Health, ~20 personnes)
- Eng-wide
- Cross-team / non-eng

Puis demander en texte libre (un seul message, pas via AskUserQuestion) :
- Brouillon brut ou 3-5 points clés
- Liens dispos (Linear, Discussion, Notion, PR) — **obligatoire** si référence à un artifact
- Personnes à pinger nommément

Si l'utilisateur a déjà fourni un brouillon dans le prompt initial, sauter les questions
qui sont déjà répondues implicitement et confirmer le reste en une seule question.

### Étape 3 — Pass 1 : Draft naturel

Rédiger dans la voix Louis-Marie (cf. voice-profile.md) :

**Conventions de voix**
- **Langue de sortie : 100 % anglais. Toujours. Sans exception.** Le message produit par
  ce skill est en anglais quels que soient l'audience, le canal, la langue du prompt
  utilisateur, ou la composition de la crew cible. Pas d'auto-switch vers le FR si
  l'audience semble FR (Ops, crew Setup, etc.) — l'utilisateur l'a confirmé explicitement
  le 2026-05-22. Si l'utilisateur veut une version FR il doit le **demander explicitement
  dans le turn courant** (ex : "donne-moi la version FR pour Mélina"). Sinon, par défaut,
  EN end-to-end, y compris pour les drafts à destination d'audiences entièrement
  francophones. Domain terms FR sans équivalent anglais naturel (DSN, SIRET, Cadres /
  Non-Cadres, visite de reprise, AMT, IDEST, IPRP) restent en français inline dans le
  texte anglais — c'est la convention Alan.
- **Pas de code-switching.** Pas de "Au top", "dans mon coin", "donc", "alors", "déjà",
  "voilà", "ça" mélangés dans un draft EN. Si une expression FR du voice profile te
  vient naturellement, traduis-la : "Au top" → "Sweet" / "Sounds good", "pas de panique"
  → "no worries", "dans mon coin" → "on my side" / "solo".
- Emojis signature : `:slightly_smiling_face:`, `:wave:`, `:tada:`, `:rocket:`,
  `:check:`, `:done:`, `:todo:`, `:hand:`, `:thinking_face:`.
- Phrases courtes. Pas de subordinations à rallonge.
- Acronymes **toujours expandés** au premier usage : DSN → Déclaration Sociale Nominative,
  PR → Pull Request. Convention forte de Louis-Marie. Les termes domain-specific qui
  n'ont pas d'équivalent anglais naturel (DSN, SIRET, AMT, IDEST, IPRP) restent en
  français même dans le message anglais — c'est la convention Alan.
- **Pas de tirets cadratins (—)**. Utiliser `:` ou `.` ou `,`.

**Structure selon le type**
- **Project update / framing** : suivre le template Mickaël à 7 sections
  (🔭 Scope avec NOT explicite / 🕐 Why / 📅 Timeline / ℹ️ LOCI / 🌐 Context / 💡 Proposal / ❓ Questions).
- **Decision thread** : options numérotées avec pros/cons, recommandation explicite.
- **Quick sync** : 1-3 lignes, 1 ping, 1 question, lien obligatoire si artifact référencé.
- **Weekly pulse / standup** : mood emoji + préfixes greppables, `:hand:` avec lien obligatoire.

**Format Slack spécifique : split parent / thread**

Si le canal cible est **Slack** (et pas un DM), structurer la sortie en **deux blocs distincts** :

1. **Parent message** (posté dans le canal) — uniquement un *titre/preview* scannable :
   - 1 ligne, ~10-20 mots maximum.
   - Capture l'essentiel : le sujet + l'ask principal ou la conclusion.
   - Aucun détail. Le lecteur sait s'il doit ouvrir le thread ou non.
   - Emoji d'ouverture optionnel (`:wave:`, `:rocket:`, `:red_dot:` selon le ton).
2. **Thread reply** (posté en réponse au parent) — le **vrai message complet** :
   - Tout le contenu structuré (TLDR, sections, bullets, options, pings, liens).
   - C'est là que vivent les détails — le canal reste lisible.

**Pourquoi** : convention adoptée pour garder les canaux Setup / Area scannables. Le
parent porte le titre, le thread porte la substance. Évite la pollution du canal et
respecte l'attention des lecteurs qui ne sont pas concernés.

**Exemples de parent message**
- Quick sync : *":wave: Bastien — review needed on 2 work-stoppage PRs (#91726 + #91731)"*
- Decision thread : *"OHSET-536 routing — standalone vs fold into O2KR7, leaning (b), input needed before tomorrow's backlog review :thread:"*
- Project update : *"Mid-quarter checkin reply on Discussion #33152 — O2KR7 ready for review + 3 new items :thread:"*

**Exception** : pour les standups (`:check:`/`:done:`/`:todo:`/`:hand:`), garder le format
existant — un seul post complet, pas de split. Convention de la crew Setup.

**Growth edges à appliquer** (cf. coaching-pass)
- Lead with conviction : si l'input est ambigu, énoncer **ton interprétation** d'abord
  puis demander confirmation. Pas "Not sure I understand", mais "Je lis ça comme [X],
  si c'est ça je propose [Y]".
- Sur les slippages : donner la nouvelle ETA avant l'apologie. Pas "sorry for the delay",
  mais "heads-up: ETA repoussée à [date], flag if you need earlier".

### Étape 3.5 — Voice fingerprint check (avant Pass 2)

Le voice profile a été lu à l'étape 1, mais le draft Pass 1 a tendance à dériver vers
une voix générique AI-polished. Cette étape force une **re-vérification du draft contre
les marqueurs concrets de la voix LM**.

**Checks à passer** (tous, sinon réécrire le draft) :

1. **Emoji signature présent.** Si le draft fait >30 mots, `:slightly_smiling_face:`
   apparaît au moins 1 fois. Pour les standups, vérifier aussi la présence d'un mood
   emoji en tête (`:mostly_sunny:`, `:rocket:`, `:tada:`, etc.) et au moins un préfixe
   greppable (`:check:` / `:done:` / `:todo:` / `:hand:`).

2. **Longueur moyenne de phrase < 15 mots.** Compter les mots entre les `.` `!` `?`.
   Si moyenne ≥ 15, casser les subordinations en deux phrases courtes. LM écrit punchy,
   pas littéraire.

3. **Absence des AI tells.** Aucun de ces mots ne doit apparaître dans le draft :
   `essentially`, `approximately`, `leverage`, `robust`, `comprehensive`, `seamless`,
   `delve`, `underscores`, `noteworthy`, `in summary`, `it's worth noting`, `furthermore`,
   `moreover`, `nevertheless`, `additionally`, `crucial`, `pivotal`, `intricate`. Si
   présent, remplacer par un mot simple (e.g. `leverage` → `use`, `comprehensive` →
   `full` ou supprimer).

4. **Au moins un marqueur d'ownership.** Le draft doit contenir au moins une occurrence
   de `I'll`, `I need`, `I plan`, `with me`, `I'm going to`, `I own`, `let me`. C'est
   la signature LM de prise de responsabilité explicite.

5. **Pas de phrasing AI-polished.** Pas de "I wanted to share an update on...",
   "Just a quick note to inform you that...", "I'm reaching out to..." en ouverture.
   LM ouvre par l'emoji + le sujet (`:wave: Update on X` ou `TLDR: ...`).

**Comment exécuter** : pour les checks 1, 3, 4 utiliser `grep -i` via Bash sur un
fichier temporaire contenant le draft. Pour le check 2, lancer un petit awk/python
one-liner. Pour le check 5, lecture humaine ciblée des 2 premières lignes.

Si **un** check échoue, **réécrire le passage incriminé puis re-runner tous les
checks**. Ne pas livrer un draft qui a échoué un check.

### Étape 4 — Pass 2 : Audit règles (TOUJOURS visible)

Pour chaque règle pertinente du catalogue, indiquer :
- ✅ Appliquée correctement
- ⚠️ Ajustée — expliquer ce qui a été changé vs le brouillon utilisateur
- ➖ N/A pour ce type de comm

**Règles à toujours vérifier** (R1-R7 transverses + R21) :
- R1 Lead with the point (TLDR/conclusion en première ligne si >3 idées)
- R2 **Produce the shortest version that still conveys the point.** Pas de bypass
  "justification écrite". Si le message doit dépasser 120 mots, c'est un signal que
  la structure est mauvaise (sous-sections cachées, infos redondantes), pas que le
  budget doit être relevé. Le default est le format compact ; étendre seulement si
  l'utilisateur pousse back avec "ajoute du contexte sur X".
- R3 Titres si >5 bullets
- R4 Bullets co-égaux uniquement
- R5 Lien vers source-of-truth présent
- R6 Ping par question, pas en bloc
- R7 Pas d'em-dashes
- **R21 Audience-appropriate framing.** Pas de PR numbers (`#NNNNN`) dans le body
  prose, pas de file paths (`backend/components/...`), pas de noms de classes Python
  (`InternalizedWorkStoppage`) ou de fonctions (`get_prevoyance_eligibilities`). Si
  l'audience inclut du non-eng (product, ops, design, leadership), traduire chaque
  concept tech en capability user-visible ("admins can now declare X", "the dashboard
  will show Y"). Garder les liens Linear / Discussion / Notion qui sont shared
  currency cross-team. Si vraiment besoin d'exposer des PRs, les regrouper sous un
  footer "Tech context" en fin de message, jamais dans le corps. Pour audience
  100 % eng (channel `#occhealth_engineering`, DM avec Bastien), les PR numbers
  sont autorisés inline.

**Règles conditionnelles selon le type**
- Project update : R8-R12 (why-now en 2e position, scope NOT explicite, LOCI, timeline datée)
- Decision thread : R13-R15 (options numérotées, recommandation, must/nice-to-have)
- Quick sync : R16-R17 (une question / un ping, urgence en tête)
- Weekly pulse : R18-R20 (mood en tête, préfixes greppables, `:hand:` avec lien)

**Scan d'anti-patterns LM**
À chaque draft, vérifier l'absence de :
- A1 ping en bloc · A2 ouverture sur incertitude · A3 apologie sans ETA
- A4 threads multiples · A5 bullets plats sans titre · A6 conclusion en fin
- A7 URL nue ou ping sans lien · A8 em-dashes

Pour chaque anti-pattern **évité** par rapport au brouillon utilisateur, le mentionner
explicitement dans la checklist (c'est de la valeur pédagogique).

### Étape 4.5 — Pass 2.5 : Hard scans (probe littéral obligatoire)

Pass 2 produit une checklist déclarative. Pass 2.5 vérifie **mécaniquement** que les
règles que le modèle a cochées sont effectivement respectées. Échec observé 2026-05-22 :
checklist affirmait "R7/A8 em-dashes avoided" alors que 2 em-dashes étaient dans le
draft. La règle générale est **les checklists déclaratives sans probe littéral mentent**.

**Procédure** : écrire le contenu du draft (parent + thread reply, ou message unique)
dans un fichier temporaire `/tmp/lm-draft-current.txt`, puis lancer ces scans :

```bash
# Scan 1 — em-dashes U+2014 et en-dashes U+2013
grep -nP '[\x{2014}\x{2013}]' /tmp/lm-draft-current.txt && echo "FAIL: em/en-dashes detected" || echo "PASS: no dashes"

# Scan 2 — PR numbers dans le body prose (à ne lancer QUE si audience non-eng)
grep -nP '#[0-9]{4,}' /tmp/lm-draft-current.txt && echo "FAIL: PR numbers in body" || echo "PASS: no PR numbers"

# Scan 3 — mots FR mélangés dans un draft EN
grep -niwE '(au top|dans mon coin|donc|alors|voilà|ça|déjà|ainsi|toutefois|cependant|Pull Request)' /tmp/lm-draft-current.txt && echo "FAIL: FR words leaked into EN draft" || echo "PASS: no FR leak"

# Scan 4 — AI tells
grep -niwE '(essentially|approximately|leverage|robust|comprehensive|seamless|delve|underscores|noteworthy|furthermore|moreover|nevertheless|additionally|crucial|pivotal|intricate)' /tmp/lm-draft-current.txt && echo "FAIL: AI tells detected" || echo "PASS: no AI tells"

# Scan 5 — emoji signature présent si draft >30 mots
wc -w /tmp/lm-draft-current.txt
grep -c ':slightly_smiling_face:' /tmp/lm-draft-current.txt
# Si word count >30 et compte = 0, FAIL
```

**Règle de blocage** : si **un seul scan échoue**, réécrire le passage incriminé et
**re-runner tous les scans**. Ne pas livrer un draft qui a échoué un scan. Ne pas
afficher de checklist Pass 2 qui contredit un scan Pass 2.5.

**Reporting** : afficher le résultat des scans dans une mini-section "Hard scans"
après la checklist Pass 2, pour que LM voie que les rules ont été vérifiées
mécaniquement et pas juste déclarées.

### Étape 5 — Pass 3 : Compact-first (default)

**Le default est le format compact.** Toujours produire d'abord la version courte
(~60-100 mots pour un Slack post, ~150-200 mots pour un project framing). Le modèle
ne doit pas commencer par la version longue puis "proposer une alternative courte" —
c'est l'inverse. La version courte est la livraison principale.

Si l'utilisateur push back avec "ajoute du contexte sur X", "détaille le point Y",
"plus long c'est ok", alors et seulement alors produire une version expanded. La
version expanded doit toujours être justifiée par un push-back concret de
l'utilisateur, jamais auto-déclenchée par le modèle.

But : éviter la verbosité par défaut. Échec observé 2026-05-22 : 3 passes utilisateur
ont été nécessaires pour passer de 270 mots à 190 mots. Le default doit être le
format final, pas un point de départ à compresser.

## Format de sortie (fixe)

Toujours produire cette structure exacte :

```markdown
## Draft proposé

### Parent message (à poster dans le canal)
<1 ligne titre/preview — uniquement si canal = Slack et pas un DM ou standup>

### Thread reply (à poster en réponse au parent)
<message final complet, prêt à copier-coller>

## Règles appliquées

- ✅ R1 Lead with the point, TLDR en première ligne
- ⚠️ R3 Titres ajoutés, brouillon avait 8 bullets plats, scindé en 2 sections H3
- ✅ R5 Lien source-of-truth, Discussion #33112 inline
- ➖ R6 Ping par question, N/A, message info-only
- ✅ A7 évité, chaque mention de PR a son lien direct
- ...

## Hard scans (Pass 2.5)

- ✅ em/en-dashes: 0
- ✅ PR numbers in body: 0 (audience product+ops)
- ✅ FR words in EN draft: 0
- ✅ AI tells: 0
- ✅ `:slightly_smiling_face:` present (draft = 92 words)

## Version expanded
<uniquement si l'utilisateur a poussé back demandant plus de détail, sinon ne pas afficher>

## Référence
Catalogue : `wiki/concepts/project-comm-best-practices.md`
Voice profile : `wiki/people/louis-marie-bonnefont-voice-profile.md`
```

**Quand le canal n'est pas Slack** (GitHub Discussion, Notion, autre), ne produire qu'un
seul bloc sous `### Message` à la place du split parent/thread.

## Cas particuliers

### L'utilisateur fournit un brouillon brut

Comparer le brouillon utilisateur au draft final. Dans la section "Règles appliquées",
expliciter chaque correction structurelle effectuée — c'est le cœur de la valeur
pédagogique du skill.

### L'utilisateur veut un message déjà très court (1 ligne)

Skipper le Pass 3 (alternative courte) mais **garder le Pass 2** (audit règles).
Même sur 30 mots, on peut violer R5 (lien manquant) ou R6 (ping mal placé).

### L'utilisateur demande explicitement une version FR

Le default est EN strict (cf. Conventions de voix). Le seul cas où le skill produit
du FR est si l'utilisateur le demande **explicitement dans le turn courant** : "donne
la version FR pour Mélina", "traduis ce draft en FR pour le DM avec Bertille",
"écris-le en français". Dans ce cas seulement, produire la version FR demandée et
faire tourner les Hard scans (Pass 2.5) avec une variante adaptée (le scan FR-words-in-EN
devient un scan EN-words-in-FR : surveiller `actually`, `basically`, `update`, `meeting`,
`scope`, etc. qui auraient échappé à la traduction). La checklist d'audit reste en
français.

### Le brouillon utilise des em-dashes (—)

Les remplacer silencieusement par `:` ou `.` ou `,` dans le draft, puis mentionner
A8 dans la checklist comme anti-pattern évité.

## Refresh du catalogue

Le catalogue `project-comm-best-practices.md` doit être rafraîchi chaque début de quarter
via `/lm-comm-research`. Si la date du catalogue est >100 jours, suggérer à l'utilisateur
de le re-générer avant de drafter.

## Notes pour le maintainer

- Ce skill **dépend** de `project-comm-best-practices.md`. Si tu modifies le catalogue,
  vérifie que les références aux numéros de règles (R1-R21, A1-A8) restent cohérentes.
  R21 (Audience-appropriate framing) est ajoutée par ce skill et peut ne pas exister
  dans le catalogue source.
- **Pass 2.5 (Hard scans) est non-négociable.** L'expérience 2026-05-22 a montré qu'une
  checklist déclarative sans probe littéral ment. Si tu refactores, garde les scans
  Bash réels, ne les remplace pas par de l'auto-attestation du modèle.
- Le skill coexiste avec `draft-message` (général). Ne pas fusionner — ils ont des
  champs d'application distincts (projet vs général).
