---
name: lm-reuse-discovery
description: >
  Actively hunts for functions, hooks, components, types, factories, and utils that
  already exist in the repo and could cover the needs of a feature being designed —
  to avoid duplicating what is already written. Breaks the specs into atomic feature
  needs, runs a parallel search across 4 scopes (backend Python, frontend TS,
  types/schemas, tests/factories), scores candidates (high/medium/low), and returns
  structured JSON + a summary grouped by need with `file:line` links.
  Use when: `/lm-reuse-discovery`, "what can we reuse for X", "is there already a
  function that does Y", "find existing helpers for Z", "anti-duplication check on this
  feature", "find reusable code for [feature]", "before I build X what already exists",
  "qu'est-ce qu'on peut réutiliser pour X", "y a-t-il déjà une fonction qui fait Y",
  "trouve les helpers existants pour Z". Also callable in **caller mode** from
  `lm-guided-feature-development` Part 2 (Reuse Discovery step, between flow walkthrough
  and architecture proposal).
  Not for: E2E flow tracing (use `/lm-flow-walkthrough`), architecture overview (use
  `/xray`), external library documentation (use `/explore-lib`).
---

# Reuse Discovery

Identifie le code existant qui peut couvrir les besoins d'une feature en cours
de design. Objectif : empêcher la duplication systémique (helpers, hooks,
factories, types) en cherchant **activement** avant de proposer une architecture.

**Règle fondamentale** : zero trust. Chaque candidat proposé doit pointer une
ligne réelle (fichier:ligne) qu'on a lue. Ne jamais inventer un nom de fonction
ni inférer son existence depuis le naming d'un fichier voisin.

## Modes d'invocation

| Mode | Déclencheur | Comportement |
|---|---|---|
| **Standalone** | `/lm-reuse-discovery <input>` | Interactif, gate de validation après extraction des needs |
| **Caller** | Subagent depuis `lm-guided-feature-development` Part 2 | Non-interactif, retourne JSON + résumé, pas de gate |

En caller mode, le prompt doit contenir `"caller mode"` pour désactiver les gates.

## Step 0 — Résolution de l'input

Input possibles :

| Type | Exemple | Stratégie |
|---|---|---|
| Ticket Linear | `OHSET-456` | Lire `.claude/plans/feature-checkpoint-OHSET-456.md` Part 1, sinon fetch Linear |
| Specs libres | "endpoint qui liste les arrêts de travail filtrés par date" | Utiliser le texte tel quel |
| Caller mode | Subagent depuis Part 2 | Lire les specs déjà extraites du checkpoint Part 1 |

Si specs introuvables ou ambiguës en standalone : `AskUserQuestion` "Donne-moi
les specs (ou le ticket Linear) à analyser". En caller mode, retourner une
erreur structurée `{"error": "no_specs_in_checkpoint"}` plutôt que poser une
question.

## Step 1 — Décomposition en feature needs

Depuis les specs, extraire **5–12 besoins atomiques** (capacités). Un besoin =
une capacité unitaire qu'on doit avoir pour livrer la feature.

**Forme** : verbe + objet domaine, court. Exemples :
- `fetch employment by member_id`
- `validate IBAN format`
- `render employee picker dropdown`
- `create work_stoppage factory`
- `serialize StoppageRead schema`
- `upload file to S3 with presigned URL`

**Anti-patterns** :
- Trop large : "gérer les arrêts de travail" → décomposer
- Trop concret : "ajouter colonne `is_validated` BOOLEAN" → c'est de l'archi, pas un besoin
- Lié à l'implémentation : "écrire un middleware Flask" → reformuler en besoin

En **standalone**, présenter la liste à l'utilisateur via `AskUserQuestion` avec
options : "Liste OK", "Ajoute / retire des besoins" (laisser saisir). En
**caller mode**, skip la validation.

## Step 2 — Recherche parallèle par scope

Lancer **4 sous-agents `Explore` en parallèle** (un seul message, 4 appels). Chaque
sous-agent reçoit la liste complète de feature needs et un scope précis.

Voir `references/search-strategies.md` pour les patterns grep exacts par scope.

### Prompt commun à chaque sous-agent

```
Tu reçois une liste de "feature needs" (capacités atomiques) pour une feature
en cours de design. Ta mission : pour chaque need, identifier les fonctions /
hooks / composants / types / factories existants dans ton scope qui peuvent
couvrir ce besoin.

Scope assigné : {scope_name}
Patterns de recherche : voir `references/search-strategies.md` section {scope_name}

Feature needs :
{liste numérotée}

Pour chaque need, retourner 0 à 5 candidats. Format JSON par candidat :
{
  "need": "<need string copié verbatim>",
  "file": "<chemin relatif au repo>",
  "line": <ligne du symbol>,
  "signature": "<signature lue, pas inférée>",
  "evidence": "<1 ligne : pourquoi ça couvre le need>",
  "usage_count": <nombre approximatif d'appelants via grep, ou null>
}

Zero trust : lis chaque candidat avant de le retourner. Pas de candidat
inféré du nom de fichier seul. Si tu ne trouves rien pour un need, retourne
[] pour ce need (ne pas inventer).
```

### Les 4 scopes

| Scope | Chemins | Cible |
|---|---|---|
| `backend_python` | `backend/components/**`, `backend/shared/**` | BL functions, queries, controllers helpers, utils |
| `frontend_ts` | `frontend/packages/**`, `frontend/shared/**`, `frontend/apps/**` (sauf `apps/cli`) | hooks, composants React, utils TS |
| `types_schemas` | dataclasses Python, Marshmallow Schemas, types TS partagés, enums | Modèles de données réutilisables |
| `tests_factories` | `**/tests/factories.py`, `**/__factories__/*`, `**/fixtures/*` | Factories existantes, fixtures, helpers de tests |

## Step 3 — Score & dedupe

Voir `references/scoring-rubric.md` pour la rubrique complète.

**Score = high / medium / low** sur 4 axes :
1. **Couverture** : exacte (= high), partielle nécessitant wrapper (medium), tangentielle (low)
2. **Généricité** : réutilisable as-is (high), à étendre via paramètre (medium), à forker (low)
3. **Proximité domaine** : même component (high), autre component même bounded context (medium), shared généraliste (medium si OK pour ce besoin)
4. **Maturité** : testé + multi-call-sites (high), un seul call site (medium), récent / non testé (low)

Score final = min des 4 axes (le maillon faible décide).

**Dedupe** : si plusieurs sous-agents retournent le même `file:line`, garder une seule entrée et mentionner les scopes qui ont matché.

## Step 4 — Output

### Output JSON (toujours retourné, structure stable pour caller mode)

```json
{
  "feature_needs": [
    {
      "need": "fetch employment by member_id",
      "candidates": [
        {
          "file": "backend/components/.../queries/employments.py",
          "line": 42,
          "signature": "def get_employment_for_member(member_id: int) -> Employment",
          "score": "high",
          "rationale": "Exactly matches; already used in 8 call sites",
          "integration_note": "Use as-is, no wrapper needed",
          "scope": "backend_python"
        }
      ]
    },
    {
      "need": "validate IBAN format",
      "candidates": []
    }
  ],
  "stats": {
    "needs_total": 8,
    "needs_with_candidates": 6,
    "candidates_high": 4,
    "candidates_medium": 7,
    "candidates_low": 3
  }
}
```

### Output textuel (humain)

Format markdown, groupé par need, candidats triés `high → medium → low`. Filtrer
les `low` par défaut (mentionner "X low candidates hidden — `--show-low` pour
voir"). Chaque candidat sur 2 lignes :

```
**fetch employment by member_id**
- 🟢 `backend/components/.../queries/employments.py:42` — `get_employment_for_member(member_id)`
  Couvre exactement, 8 call sites, use as-is.
- 🟡 `backend/components/.../queries/members.py:118` — `get_member_with_employment(member_id)`
  Charge aussi le member ; medium car ramène plus de data que nécessaire.
```

### Gate utilisateur (standalone uniquement)

`AskUserQuestion` après affichage :
- "Tout réutiliser comme proposé"
- "Exclure certains candidats" (laisser saisir)
- "Approfondir un candidat" (déclenche un Read du fichier)

En caller mode : pas de gate, retourner JSON + résumé au parent skill.

## Output en caller mode

Le subagent appelant attend exactement :

```
{JSON ci-dessus}

---HUMAN_SUMMARY---

{markdown ci-dessus}
```

Le parent skill (`lm-guided-feature-development` Part 2 Step 2bis) merge le
JSON dans `reuse_discovery` du bundle Part 2, et utilise le markdown pour
l'affichage à l'utilisateur lors de la gate "Architecture Proposal".

## Anti-patterns à éviter

- **Inventer des candidats** : si grep ne trouve rien, retourner `[]` — jamais générer un nom plausible.
- **Sur-décomposer les needs** : 15+ needs = perte de focus. Viser 5–12.
- **Promouvoir des low candidates** : si le maillon faible est low, garder low — ne pas arrondir au-dessus.
- **Skipper la lecture** : chaque candidat doit avoir une signature lue, pas inférée du nom.
- **Ignorer le domaine** : un `format_date` shared n'est pas un bon candidat pour un besoin "format date d'arrêt maladie en FR" si l'OH component a déjà son propre formatter local.

## Ressources

- `references/search-strategies.md` — patterns grep par scope, raccourcis Glob
- `references/scoring-rubric.md` — rubrique de scoring détaillée + exemples
- `evals/evals.json` — test cases
