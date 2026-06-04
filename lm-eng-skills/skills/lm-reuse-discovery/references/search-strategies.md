# Search Strategies par scope

Patterns concrets pour chaque sous-agent. L'objectif est de couvrir les
emplacements canoniques où la réutilisation devrait être trouvée, sans scanner
tout le monorepo (76K+ fichiers).

## backend_python

Chemins prioritaires (dans cet ordre) :

1. **Même component que la feature** (si identifiable depuis les specs)
   - `backend/components/<component>/internal/business_logic/queries/`
   - `backend/components/<component>/internal/business_logic/actions/`
   - `backend/components/<component>/internal/business_logic/services/`
   - `backend/components/<component>/public/` (interfaces inter-components)
2. **Components voisins du même bounded context** (ex: OH ↔ contracting ↔ enrollment)
3. **`backend/shared/`** — utils, helpers généralistes
4. **`backend/components/*/internal/models/`** — méthodes d'instance / classmethods réutilisables

Patterns grep :

| Need contient... | Patterns |
|---|---|
| "fetch X", "get X by Y" | `def get_<entity>`, `def fetch_<entity>`, `def <entity>_by_` |
| "create X", "build X" | `def create_<entity>`, `def build_<entity>`, `def make_<entity>` |
| "validate X" | `def validate_<x>`, `def is_valid_<x>`, `class <X>Validator` |
| "format X", "serialize X" | `def format_<x>`, `class <X>Schema`, `def serialize_<x>` |
| "send X" | `def send_<x>`, `def notify_<x>`, `def dispatch_<x>` |

Skip `backend/apps/` (entry points, peu réutilisable) et `**/migrations/`.

## frontend_ts

Chemins prioritaires :

1. **Même module/package** (si identifiable)
   - `frontend/packages/<module>/src/`
   - `frontend/apps/<app>/src/features/<feature>/`
2. **`frontend/shared/`** — composants UI, hooks transverses
3. **`frontend/packages/global-api/`** — hooks API générés / wrappers
4. **`frontend/packages/design-system/`** — primitives UI

Patterns :

| Need contient... | Patterns |
|---|---|
| "render X", "X picker", "X form" | `export const <X>`, `function <X>(`, `\.tsx` files |
| "fetch X", "use X data" | `export const use<X>`, `useQuery`, `useMutation` |
| "validate X" | `export const validate<X>`, `<X>Schema = z\.` (zod), `yup\.` |
| "navigate to X" | `useNavigate`, route definitions in `routes.tsx` |
| "format X" | `export const format<X>`, `formatters/` |

Skip `frontend/svg/`, `frontend/emojis/`, `**/__snapshots__/`, `*.lock`.

## types_schemas

Couverture :

1. **Python dataclasses** : `@dataclass` decorators, `class_schema(<X>)`
2. **Marshmallow Schemas** : `class <X>Schema(Schema)`, `class <X>Schema(ma.Schema)`
3. **SQLAlchemy models** : `class <X>(Base)`, `class <X>(db.Model)` (mais flagguer : modifier un model = breaking change)
4. **TS types** : `export type <X>`, `export interface <X>` dans `frontend/packages/*/src/types/`, `frontend/shared/*/types/`
5. **Enums** : `class <X>(Enum)`, `enum <X>`, string union types

Patterns :

| Need mentionne... | Cherche... |
|---|---|
| Entité domaine (Employment, Member, Stoppage) | Dataclass + Schema + TS type correspondant |
| Statut/état (validated, pending, rejected) | Enums Python ou string unions TS |
| Payload API request/response | Marshmallow Schema + TS type généré |

Skip migrations.

## tests_factories

Couverture :

1. **Factories Python** : `backend/components/*/internal/models/tests/factories.py`, classes `factory.Factory`
2. **Fixtures pytest** : `**/conftest.py`, fixtures decorated avec `@pytest.fixture`
3. **Factories TS** : `frontend/packages/*/src/**/__factories__/`, `frontend/shared/test/`
4. **MSW handlers** : `frontend/shared/test/msw/`, mock handlers réutilisables
5. **Helpers de tests** : `**/test/helpers/`, `**/tests/utils.py`

Patterns :

| Need... | Cherche... |
|---|---|
| Entité à instancier en test | `class <X>Factory(factory.Factory)`, `make<X>(`, `build<X>(` |
| Fixture commune | `@pytest.fixture\ndef <name>` |
| Mock API response | MSW handlers, `mock<X>Response` |

## Raccourcis Glob utiles

```bash
# Tous les factories Python
glob "backend/components/*/internal/models/tests/factories.py"

# Tous les hooks frontend
glob "frontend/packages/*/src/**/use*.ts" "frontend/packages/*/src/**/use*.tsx"

# Tous les schemas Marshmallow d'un component
glob "backend/components/<X>/**/schemas/*.py"
```

## Stratégie générale par need

1. **Identifier 2–3 tokens clés** dans le need (`fetch`, `employment`, `member_id`)
2. **Grep le token principal** dans le scope prioritaire
3. **Si > 50 résultats** : restreindre à la file pattern la plus probable (queries/, actions/, hooks/)
4. **Read les top candidats** (max 5 par need) pour vérifier signature + usage
5. **Grep usage** : `grep -r "get_employment_for_member(" backend/` → comptage approximatif de call sites

Budget par need : ~3–5 minutes max. Si rien trouvé après 2 stratégies de recherche → retourner `[]`.
