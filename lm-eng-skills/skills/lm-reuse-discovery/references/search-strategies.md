# Search Strategies by scope

Concrete patterns for each subagent. The goal is to cover the canonical
locations where reuse should be found, without scanning the entire monorepo
(76K+ files).

## backend_python

Priority paths (in this order):

1. **Same component as the feature** (if identifiable from the specs)
   - `backend/components/<component>/internal/business_logic/queries/`
   - `backend/components/<component>/internal/business_logic/actions/`
   - `backend/components/<component>/internal/business_logic/services/`
   - `backend/components/<component>/public/` (inter-component interfaces)
2. **Neighboring components in the same bounded context** (e.g. OH ↔ contracting ↔ enrollment)
3. **`backend/shared/`** — generic utils, helpers
4. **`backend/components/*/internal/models/`** — reusable instance methods / classmethods

Grep patterns:

| Need contains... | Patterns |
|---|---|
| "fetch X", "get X by Y" | `def get_<entity>`, `def fetch_<entity>`, `def <entity>_by_` |
| "create X", "build X" | `def create_<entity>`, `def build_<entity>`, `def make_<entity>` |
| "validate X" | `def validate_<x>`, `def is_valid_<x>`, `class <X>Validator` |
| "format X", "serialize X" | `def format_<x>`, `class <X>Schema`, `def serialize_<x>` |
| "send X" | `def send_<x>`, `def notify_<x>`, `def dispatch_<x>` |

Skip `backend/apps/` (entry points, rarely reusable) and `**/migrations/`.

## frontend_ts

Priority paths:

1. **Same module/package** (if identifiable)
   - `frontend/packages/<module>/src/`
   - `frontend/apps/<app>/src/features/<feature>/`
2. **`frontend/shared/`** — UI components, cross-cutting hooks
3. **`frontend/packages/global-api/`** — generated API hooks / wrappers
4. **`frontend/packages/design-system/`** — UI primitives

Patterns:

| Need contains... | Patterns |
|---|---|
| "render X", "X picker", "X form" | `export const <X>`, `function <X>(`, `\.tsx` files |
| "fetch X", "use X data" | `export const use<X>`, `useQuery`, `useMutation` |
| "validate X" | `export const validate<X>`, `<X>Schema = z\.` (zod), `yup\.` |
| "navigate to X" | `useNavigate`, route definitions in `routes.tsx` |
| "format X" | `export const format<X>`, `formatters/` |

Skip `frontend/svg/`, `frontend/emojis/`, `**/__snapshots__/`, `*.lock`.

## types_schemas

Coverage:

1. **Python dataclasses**: `@dataclass` decorators, `class_schema(<X>)`
2. **Marshmallow Schemas**: `class <X>Schema(Schema)`, `class <X>Schema(ma.Schema)`
3. **SQLAlchemy models**: `class <X>(Base)`, `class <X>(db.Model)` (but flag: modifying a model = breaking change)
4. **TS types**: `export type <X>`, `export interface <X>` in `frontend/packages/*/src/types/`, `frontend/shared/*/types/`
5. **Enums**: `class <X>(Enum)`, `enum <X>`, string union types

Patterns:

| Need mentions... | Look for... |
|---|---|
| Domain entity (Employment, Member, Stoppage) | Corresponding dataclass + Schema + TS type |
| Status/state (validated, pending, rejected) | Python enums or TS string unions |
| API request/response payload | Marshmallow Schema + generated TS type |

Skip migrations.

## tests_factories

Coverage:

1. **Python factories**: `backend/components/*/internal/models/tests/factories.py`, `factory.Factory` classes
2. **pytest fixtures**: `**/conftest.py`, fixtures decorated with `@pytest.fixture`
3. **TS factories**: `frontend/packages/*/src/**/__factories__/`, `frontend/shared/test/`
4. **MSW handlers**: `frontend/shared/test/msw/`, reusable mock handlers
5. **Test helpers**: `**/test/helpers/`, `**/tests/utils.py`

Patterns:

| Need... | Look for... |
|---|---|
| Entity to instantiate in a test | `class <X>Factory(factory.Factory)`, `make<X>(`, `build<X>(` |
| Common fixture | `@pytest.fixture\ndef <name>` |
| Mock API response | MSW handlers, `mock<X>Response` |

## Useful Glob shortcuts

```bash
# All Python factories
glob "backend/components/*/internal/models/tests/factories.py"

# All frontend hooks
glob "frontend/packages/*/src/**/use*.ts" "frontend/packages/*/src/**/use*.tsx"

# All Marshmallow schemas of a component
glob "backend/components/<X>/**/schemas/*.py"
```

## General strategy per need

1. **Identify 2–3 key tokens** in the need (`fetch`, `employment`, `member_id`)
2. **Grep the main token** in the priority scope
3. **If > 50 results**: narrow to the most likely file pattern (queries/, actions/, hooks/)
4. **Read the top candidates** (max 5 per need) to verify signature + usage
5. **Grep usage**: `grep -r "get_employment_for_member(" backend/` → rough count of call sites

Budget per need: ~3–5 minutes max. If nothing found after 2 search strategies → return `[]`.
