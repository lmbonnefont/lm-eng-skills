---
name: lm-oh-amplitude-sync
description: >
  Syncs the Occupational Health (OH) analytics events from the alan-apps codebase with
  the Amplitude dashboard "Prévenir — Dashboard Usage" (ID 8zjhveo3). Detects missing
  events, creates Amplitude charts grouped by feature, and rewrites the 🆕 New Features
  section with the Linear tickets from the last 12 weeks.
  Use when: /lm-oh-amplitude-sync, "sync the OH events in Amplitude", "update the OH
  dashboard", "which OH events are not in the dashboard", "refresh the New Features
  section of the Prévenir dashboard", "audit OH events", "which new OH events to track
  over the last 12 weeks", "sync les events OH dans Amplitude", "mets à jour le dashboard OH".
  Not for: other teams' dashboards, non-OH events, creating dashboards from scratch.
---

# lm-oh-amplitude-sync

Audite les events analytics OH du codebase, les compare au dashboard Amplitude,
crée des charts pour les events manquants, et met à jour la section "🆕 New Features".

## Constantes

| Paramètre | Valeur |
|---|---|
| Dashboard Amplitude | `8zjhveo3` (Prévenir — Dashboard Usage) |
| Project Amplitude | `249047` (Alan) |
| Rich text "New Features" | item ID `r33ot9r9` |
| Préfixe events OH | `occupational_health.` |
| Source of truth events | `frontend/shared/tracking/events.ts` |
| Dossier composants OH | `frontend/apps/fr-app/js/app/dashboard/occupationalHealth/` |
| Cutoff "new" | today − 84 jours (12 semaines) |
| Chart IDs | Fetched dynamiquement depuis le dashboard à chaque run |

---

## Phase 1 — Extraire tous les events OH du codebase

Lire `frontend/shared/tracking/events.ts` et extraire tous les noms d'events avec le préfixe `occupational_health.` :

```bash
grep -o '"occupational_health\.[^"]*"' frontend/shared/tracking/events.ts | sort -u | tr -d '"'
```

→ Produit la liste `ALL_OH_EVENTS`.

---

## Phase 2 — Dater chaque event via git

Objectif : savoir quand chaque event a été ajouté à `main` (date de merge du commit).

### 2a. Commits récents touchant events.ts

```bash
git log main --format="%H %ci %s" -- frontend/shared/tracking/events.ts | head -50
```

### 2b. Pour chaque commit < 84 jours, trouver les events ajoutés

```bash
git show --diff-filter=A COMMIT_HASH -- frontend/shared/tracking/events.ts | grep '^+.*"occupational_health\.' | grep -o '"occupational_health\.[^"]*"' | tr -d '"'
```

Si `git show` ne montre pas d'ajout clair (modification de ligne existante), utiliser `git log -S "event_name" --format="%H %ci" -- frontend/shared/tracking/events.ts` pour retrouver le premier commit mentionnant cet event.

### 2c. Extraire l'ID Linear depuis le commit

Chercher dans le message de commit et le body le pattern `OHSET-\d+` :

```bash
git log -1 --format="%s%n%b" COMMIT_HASH | grep -oE 'OHSET-[0-9]+' | sort -u
```

Si absent, vérifier le PR lié (le PR number est parfois dans le sujet `(#12345)`) :

```bash
gh pr view --json title,body,headRefName --jq '{title, body, branch: .headRefName}' -R alan-eu/alan-apps $(git log -1 --format="%s" COMMIT_HASH | grep -oE '#[0-9]+' | tr -d '#')
```

Le branch name contient souvent `ohset-\d+` (ex: `lmbonnefont/ohset-524-...`).

**Fallback** : si aucun ID OHSET trouvé → utiliser le message du commit brut comme label : `[commit] <sujet du commit>`.

→ Produit la map `EVENT_DATES : eventName → {commitHash, mergeDate, linearIds[], label}`.

---

## Phase 3 — Récupérer la couverture du dashboard (dynamique)

### 3a. Fetch le dashboard pour avoir la liste actuelle des charts

```
Call: Skill(mcp__claude_ai_Amplitude__get_dashboard) avec dashboardIds: ["8zjhveo3"]
```

Extraire `chartIds` de la réponse — cette liste évolue à chaque ajout/suppression de chart, ne jamais la hardcoder.

### 3b. Fetch les définitions de tous les charts courants

```
Call: Skill(mcp__claude_ai_Amplitude__get_charts) avec les chartIds extraits en 3a
```

Pour chaque chart, parser sa définition pour extraire les events référencés :
- Chercher dans les champs `metrics`, `segments`, `filters`, `events` tout string correspondant au pattern `occupational_health.*`

→ Produit `COVERED_EVENTS : Set<eventName>` = events déjà dans au moins un chart.

---

## Phase 4 — Identifier les gaps

```
UNCOVERED = ALL_OH_EVENTS − COVERED_EVENTS
NEW_UNCOVERED = UNCOVERED ∩ {events dont mergeDate > cutoff}
OLD_UNCOVERED = UNCOVERED ∩ {events dont mergeDate ≤ cutoff}
```

Si `mergeDate` est inconnue pour un event (commit non trouvé), le classer dans `NEW_UNCOVERED` par prudence.

---

## Phase 5 — Grouper par feature (semantic grouping)

Pour chaque event dans `UNCOVERED` (new ET old), grouper par feature :

1. **Grouper par `linearIds`** : events partageant le même ticket vont ensemble
2. **Regrouper sémantiquement** les tickets liés : si deux tickets couvrent la même fonctionnalité (ex: OHSET-500 = "No-response banner display" + OHSET-521 = "No-response banner CTA clicks"), les fusionner en un seul groupe. Critères de fusion sémantique :
   - Même composant source (`NoResponseBanner.tsx` → même bannière)
   - Même domaine fonctionnel dans le nom de l'event (ex: `no_response_banner` commun)
   - Tickets apparaissant dans la même PR ou branch
3. **Fallback** (events sans ticket) : groupe `[commit] <message>` individuel

Pour chaque groupe, récupérer le titre du ticket Linear :

```
Call: Skill(mcp__linear__get_issue) avec l'ID du ticket principal du groupe
```

→ Produit `FEATURE_GROUPS : [{linearIds, title, events[], isNew, latestMergeDate}]`

---

## Phase 5.5 — Gate de confirmation humaine (READ-ONLY jusqu'ici)

Avant toute modification du dashboard, présenter un résumé complet de ce qui va être fait et demander confirmation.

Afficher :

```
📊 Audit terminé — voici ce qui va être appliqué :

EVENTS TROUVÉS : N dans le codebase, M déjà couverts par un chart

CHARTS À CRÉER (K au total) :
  🆕 [OHSET-524] Observation feature  (nouveau, < 12 sem.)
       events: occupational_health.observation_viewed, occupational_health.observation_submitted
  🆕 [OHSET-500/521] No-response banner  (nouveau, < 12 sem.)
       events: occupational_health.no_response_banner_viewed, occupational_health.no_response_banner_cta_clicked
  ⏳ [OHSET-450] Pending affiliations  (ancien, > 12 sem. — chart créé, pas dans New Features)
       events: occupational_health.affiliation_decision_made

SECTION 🆕 NEW FEATURES (sera réécrite) :
  Nouveau contenu :
  **OHSET-524** — Observation feature · **OHSET-500/521** — No-response banner

Procéder ? (oui / non / modifier)
```

Utiliser `AskUserQuestion` avec les options :
- **"Oui, appliquer"** → continuer vers Phase 6
- **"Non, annuler"** → stopper, rien n'est modifié
- **"Modifier avant d'appliquer"** → demander ce que l'utilisateur veut changer (groupements, noms de charts, events à exclure)

Si l'utilisateur choisit "Modifier" : ajuster `FEATURE_GROUPS` selon ses instructions, re-présenter le résumé, re-demander confirmation.

Ne jamais passer à la Phase 6 sans confirmation explicite.

---

## Phase 6 — Créer les charts manquants

Pour chaque `featureGroup` dans `FEATURE_GROUPS` :

1. **Vérifier** s'il n'existe pas déjà un chart avec un nom similaire dans le dashboard (éviter les doublons)
2. **Créer** un chart Event Segmentation dans le projet `249047` :
   - Nom : `[OHSET-XXX/YYY] <titre Linear>` (ou `[commit] <message>` si pas de ticket)
   - Type : Event Segmentation (count d'occurrences dans le temps)
   - Events : tous les events du groupe en série sur le même chart
   - Période : 90 jours glissants

```
Call: Skill(mcp__claude_ai_Amplitude__verify_chart_definition) pour valider
Call: Skill(mcp__claude_ai_Amplitude__save_chart_edits) pour créer
```

3. **Ajouter le chart au dashboard** `8zjhveo3` via `mcp__claude_ai_Amplitude__edit_dashboard`
   - Placement : avant le rich_text `r33ot9r9` (section New Features)
   - Width 12 (pleine largeur) ou 6 si plusieurs charts ajoutés

Note : créer des charts pour **tous** les groups (`isNew = true` ET `isNew = false`). Seuls les charts `isNew = true` entrent dans la section New Features (Phase 8).

---

## Phase 7 — Réécrire la section New Features

Construire le contenu markdown de la section :

```markdown
## 🆕 New Features

**OHSET-XXX/YYY** — Titre du ticket Linear · **OHSET-ZZZ** — Titre du ticket · **[commit] message** — Event: occupational_health.xxx
```

Règles de construction :
- Inclure **uniquement** les feature groups avec `isNew = true` (mergeDate > cutoff)
- Trier par `latestMergeDate` décroissant (le plus récent d'abord)
- Séparateur entre entrées : ` · ` (espace-point-espace)
- Si un groupe a plusieurs tickets : `OHSET-500/521` (barre oblique)
- Si fallback commit : `[commit] <message tronqué à 60 chars>`

Mettre à jour via `mcp__claude_ai_Amplitude__edit_dashboard` en remplaçant le contenu du rich_text `r33ot9r9`.

---

## Phase 8 — Afficher le résumé

```
✓ N events OH trouvés dans le codebase
✓ M events déjà couverts par le dashboard
⚠ K events non couverts :
    - J nouveaux (< 12 sem.) → charts créés + ajoutés à New Features
    - L anciens (> 12 sem.) → charts créés, pas dans New Features

Charts créés :
  • [OHSET-524] Observation feature — events: [liste]
  • [OHSET-500/521] No-response banner — events: [liste]

Section 🆕 New Features mise à jour :
  → dashboard: https://app.amplitude.com/analytics/alanlytics/dashboard/8zjhveo3
```

---

## Règles de cas particuliers

| Cas | Comportement |
|---|---|
| Event sans ID OHSET dans le commit | Label `[commit] <sujet du commit>` — créer quand même le chart |
| Events > 12 sem. non couverts | Créer le chart dans le dashboard, NE PAS les mettre dans New Features |
| Plusieurs tickets pour une même feature | Fusionner sémantiquement → un seul chart, label `OHSET-X/Y` |
| Chart déjà existant avec nom similaire | Skip la création, logger "déjà couvert par chart existant" |
| Échec `get_issue` Linear | Utiliser l'ID du ticket comme title fallback : `OHSET-XXX` |

---

## Vérification post-exécution

1. `mcp__claude_ai_Amplitude__get_dashboard` avec `8zjhveo3` → vérifier que les nouveaux charts apparaissent dans `chartIds`
2. Vérifier le contenu du rich_text `r33ot9r9` dans la réponse
3. Ouvrir le dashboard : https://app.amplitude.com/analytics/alanlytics/dashboard/8zjhveo3
