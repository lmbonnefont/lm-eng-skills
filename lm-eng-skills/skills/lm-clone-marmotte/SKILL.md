---
name: lm-clone-marmotte
description: >
  Extract the surface implementation (frontend + backend) of a Marmot feature
  (Alan's admin tool) so it can be replicated elsewhere — typically in the
  Occupational Health admin. Produces a shallow markdown blueprint with clickable
  file:line links for the route, screen, components, API hooks, endpoints, schemas,
  and the business logic called.
  Use when: `/lm-clone-marmotte`, "clone the [feature] from Marmot",
  "extract the implementation of [X] in Marmot", "Marmot blueprint for [URL]",
  a `marmot.alan.com/...` URL pasted, "how is [admin screen] built so I can replicate it",
  "give me the source code of [Marmot feature]", "I want to copy [feature] from Marmot to OH admin",
  "clone marmotte de [feature]", "extrait l'implémentation de [X] dans Marmot",
  "comment est fait [écran admin] que je veux répliquer",
  "je veux copier [feature] de Marmot vers OH admin".
  Also generic for other apps (fr-app, be-app...) if the user specifies the app —
  Marmot by default.
  Not for: E2E flow tracing (use `/lm-flow-walkthrough`), static architecture overview (use `/xray`).
---

# Clone Marmotte

Extrait le squelette d'implémentation **shallow** d'une feature Marmot (ou autre app admin) pour faciliter sa réplication. Couverture : route → screen → composants → hooks API → controllers → schemas → BL appelée. **On s'arrête à la fonction BL** (pas de descente dans queries, models, ORM). Si l'utilisateur veut deep dive, rediriger vers `/lm-flow-walkthrough`.

**Règle fondamentale** : chaque référence est `chemin/fichier.ext:LIGNE` cliquable, en dehors des code blocks. Si un élément ne peut pas être prouvé par lecture/grep, le flagguer `[GAP: raison]`.

---

## Conventions Marmot à connaître

- Frontend Marmot : `frontend/apps/fr-marmot/`
  - Routes : `frontend/apps/fr-marmot/routes/`
  - Screens : sous `frontend/apps/fr-marmot/.../screens/` ou `pages/`
  - API client : `AdminCamelCaseApi` (alias `camelCaseAdminApi`) défini dans `frontend/apps/fr-marmot/backend.ts`
    - Méthodes : `get(path)`, `post(path, body)`, `patch(path, body)`, `delete(path)`
    - Conversion auto snake_case ↔ camelCase
- Backend Marmot : controllers dans `backend/components/*/internal/*/controllers/marmot/`
  - Route prefix : `/api/...`
  - Décorateurs Flask + `@use_args` avec schemas Marshmallow `Marmot*Args`
  - BL importée **inline** (dans le corps de la fonction), pas en haut du fichier
  - BL accepte des IDs (pas des objets ORM), retourne des dataclasses

---

## Step 0 — Résolution input

`$ARGUMENTS` peut être :

| Pattern | Type | Stratégie |
|---|---|---|
| URL `marmot.alan.com/...` | URL | Parse path, grep dans `frontend/apps/fr-marmot/routes/` |
| Texte libre ("page édition contrats") | concept | Grep keywords dans `frontend/apps/fr-marmot/`, ranking screens > routes > components |
| Chemin fichier explicite | file | Read direct |
| Mention d'autre app ("dans fr-app", "be-marmot") | scope override | Remplacer `fr-marmot` par l'app cible |

Si plusieurs candidats plausibles, utiliser `AskUserQuestion` :
"J'ai trouvé plusieurs entrées possibles. Laquelle ?" — chaque option = `fichier:ligne — description 1 ligne`.

---

## Step 1 — Pré-filtre scope

Avant l'extraction, demander via `AskUserQuestion` :
- **Frontend uniquement** — extrait seulement la partie UI
- **Backend uniquement** — extrait seulement les endpoints + BL
- **Frontend + backend** (défaut) — extrait tout

Mémoriser le choix pour Step 2 et Step 3. Pas de re-filtrage après l'extraction — ce qui est extrait est livré tel quel.

---

## Step 2 — Extraction shallow

Paralléliser autant que possible (Grep multiples en parallèle).

### Frontend (si dans le scope)

1. **Route** : depuis l'URL ou le screen, identifier la définition de route dans `frontend/apps/fr-marmot/routes/` → `fichier:LIGNE` + path
2. **Screen** : composant pointé par la route → `fichier:LIGNE` + 1 ligne de description
3. **Composants UI** : grep les imports de composants depuis le screen (1 niveau seulement). Lister chaque composant avec son rôle. Ne pas trace deep.
4. **Hooks API** : grep `camelCaseAdminApi.(get|post|patch|delete)\(` dans le sous-arbre du screen et ses enfants directs. Pour chaque match : capturer méthode + path + `fichier:LIGNE`
5. Si un hook custom (ex `useFooData`) wrappe l'appel API, le résoudre une fois (pas plus)

### Backend (si dans le scope)

Pour chaque endpoint identifié (depuis le frontend OU fourni en input direct) :

1. **Controller** : grep le path dans `backend/components/*/internal/*/controllers/marmot/` (route decorators) → `fichier:LIGNE` de la fonction handler
2. **Schema args** : identifier le `@use_args(MarmotXxxArgs)` ou équivalent → `fichier:LIGNE`
3. **BL appelée** : repérer l'import inline dans le corps + le call site → `fichier:LIGNE` de la fonction BL avec sa signature (paramètres + type retour)

**Stop ici** : on ne descend pas dans la BL elle-même, on n'inspecte pas les models, on ne suit pas les sous-appels. Le but est un squelette à imiter, pas un audit complet.

Si une étape n'est pas résolvable (dispatch dynamique, country-specific via plugin), flagguer `[GAP: raison]`.

---

## Step 3 — Production de l'output

### Sauvegarde fichier

Path : `tmp/agent-scratch/clone-marmotte-{slug}.md` (slug dérivé du nom de feature, kebab-case).

Si `tmp/agent-scratch/` n'existe pas (hors monorepo alan-apps), fallback `/tmp/clone-marmotte-{slug}.md`.

### Structure du markdown

```
# Clone Marmotte — {Feature name}

**Source** : {URL ou description fournie}
**Scope extrait** : frontend | backend | les deux
**Date** : {YYYY-MM-DD}

## Frontend

### Route
- frontend/apps/fr-marmot/routes/Foo.tsx:42 — pattern `/admin/foo/:id`

### Screen
- frontend/apps/fr-marmot/.../FooEditScreen.tsx:18 — écran d'édition de Foo

### Composants utilisés
| Composant | Fichier | Rôle |
|---|---|---|
| FooTable | frontend/.../FooTable.tsx:12 | tableau des entrées Foo |
| FooForm | frontend/.../FooForm.tsx:8 | form d'édition |

### Appels API (HTTP boundaries)
| Method | Path | Call site |
|---|---|---|
| GET | /admin/foo/:id | frontend/.../FooEditScreen.tsx:34 |
| PATCH | /admin/foo/:id | frontend/.../FooEditScreen.tsx:67 |

## Backend

### `GET /admin/foo/:id` — backend/components/fr/internal/foo/controllers/marmot/foo.py:45
- Schema args : `MarmotFooGetArgs` → backend/.../schemas/marmot.py:23
- BL appelée : `get_foo(foo_id: int) -> FooEntity` → backend/.../business_logic/queries/foo.py:18

### `PATCH /admin/foo/:id` — backend/components/fr/internal/foo/controllers/marmot/foo.py:78
- Schema args : `MarmotFooPatchArgs` → backend/.../schemas/marmot.py:56
- BL appelée : `update_foo(foo_id: int, args: MarmotFooPatchArgs) -> FooEntity` → backend/.../business_logic/actions/foo.py:42

## Patterns observés
- Imports inline BL dans controllers (convention alan-apps)
- ...

## Gaps
- [GAP] Le calcul de X passe par `get_plugin()` — résolution runtime, voir candidats : ...
```

**Important pour les liens cliquables** :
- Format `chemin/fichier.ext:LINE` **en dehors** des code blocks (sinon non-rendu)
- Dans les tableaux, écrire les paths comme texte simple (pas backtickés). Le terminal Claude Code les rend cliquables.
- Voir feedback memory : `feedback_no_links_in_codeblocks.md`

### Affichage dans la conversation

En plus du fichier sauvegardé, afficher un **résumé condensé** (~30 lignes max) avec :
- Le path absolu du fichier sauvegardé
- Liste numérotée des entrées clés (route, screen, top 3 endpoints) avec liens
- Note "Voir le fichier complet pour les détails"

---

## Step 4 — Recommandations UX (via `/lm-ux-delight`)

Si le scope inclut le frontend, **invoquer la skill `lm-ux-delight`** en lui passant le path du blueprint markdown généré au Step 3.

```
Skill(skill="lm-ux-delight", args="--from-blueprint <path-absolu-du-md>")
```

L'agent UX produit 3-5 micro-améliorations qui **préservent l'expérience source** mais rendent le flow plus fluide pour les admins OH. Récupérer son output et l'**appender** dans le markdown sauvegardé sous une section `## Améliorations UX suggérées` (avec note "préservent l'expérience Marmot existante, à discuter avant d'implémenter").

Si scope = backend uniquement, **skipper Step 4**.

Si `lm-ux-delight` n'est pas disponible ou échoue, fallback : produire 2-3 suggestions inline simples (defaults, moins de clics, feedback après action) et flagguer `[lm-ux-delight indisponible]`.

---

## Step 5 — Recommandations techniques anti-dette

But : pendant la réplication OH, **ne pas copier la dette technique** de la source. Identifier les patterns qui datent et proposer la version moderne.

**Cadre** :
- 2-4 suggestions max
- Cibler les patterns observés dans le blueprint qui sont **dépréciés ou contournés** par les conventions actuelles d'alan-apps
- Vérifier les `.ruler/` files (`.ruler/`, `backend/.ruler/`, `frontend/.ruler/`) pour les conventions actuelles
- Préférer les patterns documentés dans CLAUDE.md (voir "Conventions over existing code")

**Patterns rouges typiques à détecter** :

| Pattern source (potentiellement dette) | Recommandation actuelle |
|---|---|
| `Schema(Marshmallow)` classes | Migration vers `dataclass` + `class_schema()` (voir `/migrate-schema-to-dataclass`) |
| `request_argument` / `request_arguments` | `@use_args` (voir `/migrate-request-argument`) |
| `BaseController` (flask-restful) | `CustomMethodView` flask-smorest (voir `/migrate-base-controller`) |
| Feature flags custom non LaunchDarkly | LaunchDarkly (voir `/migration-ff-to-launchdarkly`) |
| Imports BL en haut de controller | Imports inline dans le corps (convention alan-apps) |
| BL acceptant des objets ORM | BL doit accepter des IDs uniquement |
| Queries retournant des entités ORM | Doivent retourner des dataclasses |
| Tuples de retour anonymes | `NamedTuple` (préférence user) |
| Composants frontend sans docstring TSDoc | Ajouter TSDoc au-dessus du composant (préférence user) |
| Propriétés CSS physiques (`marginLeft`) | Logiques (`marginInlineStart`) si scope RTL |
| Tests qui mockent la DB | Hit la vraie DB en tests d'intégration |

**Format dans le markdown** :

```
## Améliorations techniques suggérées (éviter la dette en répliquant)

> Note : la source utilise des patterns qui ont évolué dans alan-apps. Pour la réplique OH, préférer les conventions actuelles.

1. **[Pattern source détecté]** → **[recommandation moderne]**
   - Fichier source : path:LINE
   - Pourquoi : [raison courte, lien vers ruler ou skill de migration si applicable]
   - Effort : XS / S / M

2. ...
```

Si **aucune dette détectée**, écrire : "Aucune dette technique flagrante détectée — la source suit les conventions actuelles."

---

Le skill se termine ici. Pas de re-filtrage post-extraction.

---

## Notes pour les autres apps

Si l'utilisateur précise une app autre que Marmot (ex : `fr-app`, `be-app`, `eng-tools-server`) :
- Remplacer `frontend/apps/fr-marmot/` par `frontend/apps/{app}/`
- Backend : les controllers ne sont plus dans `controllers/marmot/` mais dans `controllers/` directement (ou `controllers/v2/`, etc.)
- Adapter le client API : `fr-app` utilise `global-api` hooks (`useQuery`/`useMutation`), pas `AdminCamelCaseApi`
- Marquer dans le frontmatter "Scope extrait" l'app utilisée

---

## Limites

- **Shallow uniquement** : on s'arrête à la signature de la BL côté back, à 1 niveau de composants côté front. Pas de récursion. Pour deep dive, suggérer `/lm-flow-walkthrough` sur l'endpoint concerné.
- **Pas de scaffold** : ce skill produit un blueprint à lire, pas du code généré pour la cible.
- **Pas de tests** dans le blueprint.
