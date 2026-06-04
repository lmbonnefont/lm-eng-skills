# Scoring Rubric

Chaque candidat est scoré sur 4 axes. **Score final = min des 4 axes** (le maillon le plus faible décide).

## Axe 1 — Couverture

À quel point le candidat couvre le need.

| Score | Critère |
|---|---|
| **high** | Couvre le need exactement, sans wrapper. Le call site écrit `candidate(...)` directement. |
| **medium** | Couvre le need avec un wrapper léger (1–3 lignes) ou un sous-set des paramètres. |
| **low** | Couvre tangentiellement : même domaine, sortie partiellement utile, nécessite de l'extraction ou de la transformation. |

**Exemples** :
- Need `fetch employment by member_id`, candidat `get_employment_for_member(member_id)` → **high**
- Need `fetch employment by member_id`, candidat `get_member_with_employment(member_id)` (ramène aussi le member) → **medium**
- Need `fetch employment by member_id`, candidat `list_employments_for_company(company_id)` → **low** (faut filtrer côté caller)

## Axe 2 — Généricité

Capacité à utiliser le candidat sans le modifier.

| Score | Critère |
|---|---|
| **high** | Réutilisable as-is. API stable, paramètres clairs, pas de side-effects cachés. |
| **medium** | Nécessite un nouveau paramètre optionnel pour couvrir le cas d'usage (extension non-breaking). |
| **low** | Nécessite un fork ou une refonte ; les call sites existants supposent un comportement incompatible. |

## Axe 3 — Proximité domaine

À quel point le candidat appartient au bon contexte sémantique.

| Score | Critère |
|---|---|
| **high** | Même component que la feature. Même bounded context. |
| **medium** | Component voisin du même area (ex: OH ↔ contracting), ou shared/utils généraliste où l'usage est conventionnel. |
| **low** | Component étranger, ou shared trop bas-niveau pour porter sémantique métier (ex: réutiliser un parser CSV pour parser un payload structuré). |

## Axe 4 — Maturité

Confiance dans le candidat.

| Score | Critère |
|---|---|
| **high** | Testé (présence de tests), utilisé ≥ 3 call sites, stable depuis plusieurs commits. |
| **medium** | Testé OU utilisé ≥ 1 call site, mais pas les deux. |
| **low** | Sans tests ET sans call site externe (potentiellement abandonné), ou flaggé `@deprecated`. |

## Heuristiques pour calcul rapide

1. Si `usage_count >= 3` et tests existants → **maturité high**.
2. Si `usage_count == 0` (zero call sites) → **maturité low**, presque toujours.
3. Si le candidat est dans un `legacy/`, `old/`, `__deprecated__/` → **low** automatique sur tous les axes.
4. Si la signature contient `**kwargs` ou `Any` partout → **généricité low** (API floue).

## Quand filtrer un candidat (ne pas le proposer du tout)

- Le candidat est marqué `@deprecated` ou son docstring dit "will be removed"
- Il est dans `migrations/`
- Il est dans un test (sauf si le scope est explicitement `tests_factories`)
- Sa signature est strictement plus complexe que ce que le besoin requiert ET il existe une option plus simple

## Exemples annotés

### Exemple 1

Need : `validate IBAN format`

Candidat : `backend/shared/validators/iban.py:12 — def is_valid_iban(iban: str) -> bool`

- Couverture : high (couvre exactement)
- Généricité : high (stateless, signature simple)
- Proximité : high (shared validators, l'endroit canonique)
- Maturité : high (12 call sites, tests présents)
- **Final : high** ✅

### Exemple 2

Need : `render employee picker dropdown`

Candidat : `frontend/packages/oh-admin/src/components/EmployeeSelect.tsx:18 — export const EmployeeSelect`

- Couverture : medium (couvre, mais expose toutes les props de Select sous-jacent, propret au call site)
- Généricité : high (accepte `onChange`, `value`, `companyId`)
- Proximité : high (même module OH admin)
- Maturité : medium (2 call sites, pas de test dédié)
- **Final : medium** 🟡

### Exemple 3

Need : `serialize StoppageRead schema`

Candidat : `backend/components/occupational_health/.../legacy/stoppage_schemas.py:42 — class StoppageReadSchema_old`

- Couverture : medium (la shape ne correspond plus aux nouveaux besoins)
- Généricité : low (Schema avec post-processing custom)
- Proximité : high (même component)
- Maturité : low (legacy, sera removed)
- **Final : low** 🔴 → en fait : **filtrer** (legacy, ne pas proposer)
