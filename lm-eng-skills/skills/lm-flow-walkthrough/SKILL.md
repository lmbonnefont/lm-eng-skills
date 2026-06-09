---
name: lm-flow-walkthrough
description: >
  Trace and explain end-to-end code flows with annotated call chains and narrative
  explanations. Every claim is proven by a file:line reference.
  Use when: /lm-flow-walkthrough, "trace the flow of X", "how does X work",
  "walk me through X", "explain the flow from endpoint Y to the DB",
  "what happens when Z", "how does X work in the codebase",
  "trace le flow de X", "comment fonctionne X", "explique le flow de l'endpoint Y jusqu'à la DB",
  "qu'est-ce qui se passe quand Z".
  Also callable in caller mode from other skills (e.g. lm-guided-feature-development Part 2).
  Not for: static architecture overviews (use /xray), library documentation (use /explore-lib).
---

# Flow Walkthrough

Trace un flow de code de bout en bout et produit deux outputs :
- **Section A** : Call chain annotée avec `fichier:ligne` cliquable à chaque hop
- **Section B** : Explication narrative style "Evidence trace" — chaque claim prouvée par une référence

**Règle fondamentale** : ne jamais présenter une hypothèse comme un fait. Si un hop n'est pas vérifiable (dispatch dynamique, code untyped), le flagguer comme `[GAP]` avec les candidats possibles.

## Modes d'invocation

| Mode | Déclencheur | Comportement |
|---|---|---|
| **Standalone** | `/lm-flow-walkthrough <input>` | Interactif, gate de confirmation à la fin |
| **Caller** | Invoqué depuis un autre skill (subagent) | Non-interactif, retourne JSON structuré + output lisible |

En mode caller, le prompt du subagent doit contenir `"caller mode"` pour désactiver les gates interactives.

---

## Step 0 — Résolution de l'input

`$ARGUMENTS` est l'un de ces trois types. Détecter et normaliser :

| Pattern d'input | Type | Exemple | Stratégie |
|---|---|---|---|
| Méthode HTTP + path, ou URL path | endpoint | `POST /api/v1/proposals`, `/proposals` | Grep route decorators |
| fichier.py:nom_fonction ou fichier:ligne | file-function | `contracting/public/proposal.py:approve_proposal` | Read direct du fichier |
| Texte libre décrivant un concept | concept | "renewal tacit approval", "comment l'enrollment marche" | Grep termes-clés, identifier entry points |

Si ambigu (plusieurs candidats), utiliser `AskUserQuestion` :
"J'ai trouvé plusieurs points d'entrée possibles. Lequel tracer ?" avec chaque candidat comme option (`fichier:ligne — description`).

---

## Step 1 — Localisation du point d'entrée

### Pour un endpoint

1. Grep le path dans les route decorators :
   - `backend/apps/*/` et `backend/components/**/controllers/` pour `@blueprint.route`, `@*.get`, `@*.post`, etc.
   - `frontend/modules/global-api/src/` pour les hooks API côté client
2. Si trouvé des deux côtés (backend + frontend), présenter les deux et demander quelle direction tracer
3. Si plusieurs matches (même path dans FR et BE apps), présenter les options via `AskUserQuestion`

### Pour un fichier:fonction

1. Read le fichier, localiser la fonction
2. Déterminer la couche depuis le path :
   - `public/` → API publique cross-component
   - `internal/controllers/` → controller HTTP
   - `internal/business_logic/` → logique métier
   - `internal/models/` → ORM / DB
   - `external/` → anti-corruption layer
   - `frontend/modules/*/src/screens/` → écran frontend
3. Proposer la direction de trace via `AskUserQuestion` : DOWN (callees), UP (callers), ou BOTH

### Pour un concept

1. Grep les termes-clés dans `backend/` et `frontend/`
2. Ranking par pertinence de couche : `public/` > `controllers/` > `business_logic/` > `models/` > reste
3. Filtrer les tests, migrations, `__pycache__`
4. Présenter les top 5 candidats avec `fichier:ligne` et contexte 1 ligne
5. L'utilisateur confirme le point d'entrée via `AskUserQuestion`

---

## Step 2 — Trace du call chain

À partir du point d'entrée résolu, tracer le flow hop par hop.

### Procédure de trace

1. **Read** la fonction courante
2. **Identifier** tous les appels sortants (appels de fonction, imports)
3. Pour chaque appel : **résoudre** vers `fichier:ligne` via Grep + Read
4. **Enregistrer** : caller `fichier:ligne` → callee `fichier:ligne`, avec un résumé 1 ligne
5. Si résolution impossible : **flagguer** `[GAP: raison]` avec les candidats possibles
6. **Paralléliser** les Grep quand possible (chercher callers et callees simultanément)

### Patterns de trace backend (architecture alan-apps)

Le backend suit une architecture en couches. La trace typique descend ainsi :

```
apps/{country}_api/config/components_config.py  (enregistrement blueprint)
  → components/{name}/bootstrap/bootstrap.py  (bootstrap du composant)
    → components/{name}/internal/controllers/*.py  (handler HTTP, @use_args)
      → components/{name}/internal/business_logic/actions/*.py  (mutations)
         ou /queries/*.py  (lectures → retournent des dataclasses)
        → components/{name}/internal/models/*.py  (SQLAlchemy ORM)
        → components/{name}/external/*.py  (appels services externes)
        → shared/*  (helpers cross-cutting)
      → components/{name}/public/*.py  (API publique si cross-component)
```

**Conventions à connaître pour tracer correctement** :
- Les controllers importent la BL **inline** (dans le corps de la fonction), jamais en haut du fichier — chercher les imports dans le body, pas en tête
- La BL accepte des IDs, pas des objets ORM — utilise `get_or_raise_missing_resource()`
- Les queries retournent des **dataclasses**, pas des entités ORM
- `@use_args` avec Marshmallow schemas pour le parsing de requêtes
- Logique country-specific dans `app_specifics/{country}/` — **toujours flagguer comme GAP** car résolu au runtime
- Système de plugins : dispatch runtime via `get_plugin()` — **toujours flagguer comme GAP**
- Event subscribers (signaux Flask) — vérifier `bootstrap.py` pour les listeners enregistrés

### Patterns de trace frontend

```
frontend/apps/{app}/routes.tsx  (définition de route)
  → frontend/modules/{module}/src/screens/*.tsx  (composant écran)
    → frontend/modules/{module}/src/components/*.tsx  (composants UI)
    → frontend/modules/global-api/src/*.ts  (hooks API : useQuery/useMutation)
      → endpoint backend  (lien vers trace backend)
```

### Cross-stack (frontend → backend)

Si le flow traverse le frontend et le backend, tracer les deux en séquence :
1. Frontend jusqu'au hook API (`useQuery`/`useMutation` dans `global-api/`)
2. Marquer la frontière HTTP clairement : `--- HTTP boundary: GET /api/... ---`
3. Backend depuis le controller correspondant jusqu'à la DB/service externe

### End-to-end flows (output visible par l'utilisateur)

Pour les changements qui affectent ce que l'utilisateur voit/reçoit (filename téléchargé, contenu email, texte affiché), tracer le **pipeline complet** du trigger utilisateur jusqu'au point de sortie final. Le point de sortie (ex: header `Content-Disposition` du download) est souvent distinct du point de production (ex: upload S3). Toujours identifier les deux.

### Table de mapping path → domain

| Path Pattern | Domain | Backend App | Frontend App |
|---|---|---|---|
| `apps/fr_api/` ou `components/fr/` | France | `fr_api` | `fr-server` |
| `apps/be_api/` ou `components/be/` | Belgium | `be_api` | `be-server` |
| `apps/es_api/` ou `components/es/` | Spain | `es_api` | `es-server` |
| `apps/ca_api/` ou `components/ca/` | Canada | `ca_api` | `ca-server` |
| `apps/eu_tools/` | Internal Tools | `eu_tools` | `eng-tools-server` ou `eu-home-server` |

### Limites

- **Profondeur max** : 8 hops. Au-delà, flagguer et demander si l'utilisateur veut continuer.
- **Nœuds terminaux** : DB query (SQLAlchemy), appel HTTP externe, render React. Arrêter la trace à ces points.

---

## Step 3 — Production de l'output

L'output est structuré en **3 sections**, toujours dans cet ordre. Les 3 sections utilisent systématiquement le format `` `path/to/file:LINE` `` pour chaque référence — pas d'exception.

### Section A : Narratif high-level

Le but est de donner une **vision d'ensemble** du flow en langage simple, comme si on l'expliquait à un collègue qui découvre la feature. Chaque grande étape est une phrase avec un lien cliquable vers le fichier principal de cette étape. On ne rentre pas dans le détail des fonctions ici — on décrit le parcours et les grandes règles métier.

**Format** :

```
## Comment fonctionne [description] — Vue d'ensemble

Quand [trigger utilisateur], voici ce qui se passe :

1. **[Nom de l'étape]** — Le frontend affiche [quoi] via le composant `ComponentName`
   → `frontend/modules/.../screens/VisitScreen.tsx:42`

2. **[Nom de l'étape]** — L'utilisateur [action], ce qui appelle l'API `[METHOD /path]`
   → `frontend/modules/global-api/src/visits/useNextVisit.ts:18`

   --- HTTP boundary: GET /api/visits/next-deadline ---

3. **[Nom de l'étape]** — Le backend reçoit la requête et délègue à la business logic
   → `backend/components/.../controllers/visit.py:67`

4. **[Nom de l'étape]** — La BL applique [règle métier principale : ex "calcule la prochaine deadline selon le type de visite et les contraintes réglementaires"]
   → `backend/components/.../queries/next_visit_deadline.py:34`

5. **[Nom de l'étape]** — [Règle métier secondaire ou étape de données]
   → `backend/components/.../models/visit.py:89`

### Règles métier clés
- **[Règle 1]** : [description simple, ex: "une visite d'embauche doit avoir lieu dans les 3 mois suivant la date d'entrée"] → `fichier:ligne`
- **[Règle 2]** : [description] → `fichier:ligne`
- [GAP] [Règle incertaine] : [hypothèse à vérifier] — non prouvée dans le code
```

**Principes du narratif** :
- Écrire comme si on racontait une histoire : "quand X fait Y, le système Z"
- Chaque étape = **une phrase**, pas une liste de fonctions
- Nommer les **règles métier**, pas les détails techniques ("calcule la deadline" > "appelle `compute_deadline()`")
- Toujours un lien cliquable vers le fichier **principal** de l'étape
- Les règles métier clés sont listées séparément à la fin — ce sont les invariants du système

### Section B : Deep dive par fonction

Après le narratif, on plonge dans **chaque fonction traversée**, dans l'ordre du call chain. Pour chaque fonction, on explique :
- Ce qu'elle fait (1-2 phrases)
- Les règles métier qu'elle encode (avec liens cliquables vers les lignes exactes)
- Les inputs/outputs importants
- Les edge cases ou branches conditionnelles notables

**Format** :

```
## Deep dive

### 1. `ComponentName` — `frontend/modules/.../screens/VisitScreen.tsx:42`

Affiche la page de suivi des visites médicales. Récupère les données via le hook
`useNextVisitDeadline()` (`frontend/modules/global-api/src/.../useNextVisit.ts:18`).

**Règles** :
- Affiche un badge d'alerte si la deadline est < 30 jours → `:67`
- Masque la section si le membre n'a pas de suivi OH actif → `:52`

---

### 2. `GET /api/visits/next-deadline` — `backend/components/.../controllers/visit.py:67`

Controller HTTP. Reçoit `member_id` en query param (`@use_args` avec `VisitDeadlineQuerySchema` → `:64`).
Délègue à `get_next_visit_deadline()` via import inline → `:79`.

---

### 3. `get_next_visit_deadline()` — `backend/components/.../queries/next_visit_deadline.py:34`

Calcule la prochaine deadline de visite médicale pour un membre donné.

**Règles** :
- Visite d'embauche : deadline = date_entree + 3 mois → `:56`
- Visite périodique : deadline = dernière_visite + intervalle (dépend du poste) → `:78`
- Suivi renforcé : intervalle réduit à 12 mois → `:92`
- [GAP] Le calcul d'intervalle pour les travailleurs de nuit passe par `get_plugin()` → résolution runtime

**Inputs** : `member_id: int`, `account_id: int`
**Output** : `NextVisitDeadlineEntity` (dataclass) → `:23`

---

### 4. `Visit` model — `backend/components/.../models/visit.py:89`

Modèle SQLAlchemy. Query avec `selectinload` sur `visit_type` et `member` → `:102`.
Table PostgreSQL : `occupational_health_visit`.
```

**Principes du deep dive** :
- Chaque fonction = un bloc avec son propre heading `### N. nom — fichier:ligne`
- Les **règles métier** sont en gras et chacune a un lien vers la ligne exacte
- Si une fonction n'a pas de règle métier notable (pur plumbing), le dire en une ligne et passer au suivant
- Les inputs/outputs ne sont mentionnés que quand ils sont utiles pour comprendre les connexions
- Les edge cases et branches conditionnelles sont listés comme règles

### Section C : Gaps et assumptions

Regrouper tous les gaps et assumptions à la fin pour une vue consolidée :

```
## Gaps & Assumptions

### Gaps (non vérifiés dans le code)
- **[GAP 1]** à l'étape N : [raison] — candidats possibles : `fichier:ligne`, `fichier:ligne`
- **[GAP 2]** à l'étape N : [raison]

### Assumptions (non prouvées)
- L'utilisateur est authentifié (decorator `@requires_auth` à `fichier:ligne` le suggère)
- La config existe en base (pas de guard clause trouvée à `fichier:ligne` — potentiel bug ?)
```

### Mode caller : JSON structuré additionnel

En mode caller, retourner **en plus** des 3 sections lisibles un bloc JSON :

```json
{
  "entry_point": {
    "file": "path/to/entry.py",
    "line": 67,
    "type": "endpoint"
  },
  "narrative": {
    "summary": "Quand X fait Y, le système Z...",
    "steps": [
      { "name": "Affichage écran visite", "description": "Le frontend affiche...", "main_file": "path:line" },
      { "name": "Appel API", "description": "L'utilisateur clique...", "main_file": "path:line" }
    ],
    "business_rules": [
      { "rule": "Visite d'embauche dans les 3 mois", "file": "path/to/file.py", "line": 56 }
    ]
  },
  "call_chain": [
    {
      "step": 1,
      "layer": "route|controller|business_logic|model|external|frontend_screen|frontend_api",
      "file": "path/to/file.py",
      "line": 42,
      "function": "function_name",
      "summary": "description 1 ligne",
      "rules": ["règle métier encodée ici"]
    }
  ],
  "gaps": [
    {
      "at_step": 4,
      "reason": "dynamic dispatch via get_plugin()",
      "candidates": ["path/to/candidate1.py:89", "path/to/candidate2.py:67"]
    }
  ],
  "relevant_files": [
    { "path": "...", "line": 67, "reason": "controller principal" }
  ],
  "patterns_observed": ["inline imports in controllers", "dataclass return from queries"],
  "potential_issues": ["no null guard on campaign config lookup"],
  "all_usages": {
    "concept_name": { "total_count": 18, "top_files": ["..."] }
  },
  "e2e_flows": [
    {
      "what_user_sees": "downloaded filename",
      "trigger": "user clicks Download button",
      "pipeline": ["frontend calls GET /exports/{id}/download", "controller fetches from S3", "controller sets Content-Disposition header"],
      "output_point": { "file": "path/to/controller.py", "line": 481, "what_it_controls": "Content-Disposition filename" }
    }
  ]
}
```

Les champs `relevant_files`, `patterns_observed`, `potential_issues`, `all_usages`, `e2e_flows` sont directement consommables par `lm-guided-feature-development` Step 3 (Architecture Proposal).

---

## Step 4 — Gate de confirmation

### Mode standalone

Utiliser `AskUserQuestion` avec :
- "Je comprends le flow, merci" → fin du skill
- "Trace plus profond dans l'étape [X]" → re-enter Step 2 au nœud spécifié
- "Explique l'étape [X] plus en détail" → lire le fichier concerné et expliquer
- "Montre-moi le contenu du fichier [Y]" → Read et présenter

### Mode caller

Skip cette étape — le skill appelant gère l'interaction utilisateur.
