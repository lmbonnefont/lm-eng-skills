# Alan Conventions Checklist

Conventions codified from real PR review feedback (analysis of ~30 merged PRs, Feb-Apr 2026).
Each convention includes its source and detection pattern.

---

## Backend Conventions

### 1. Import Layering

**Rule:** Controllers and commands import business logic **inline (in function body)**.
Business logic uses **top-level imports**.

**Source:** `backend/.ruler/python_guidelines.md` — Layered Architecture, Key Rule #1

**Detection:** In a controller/command file, check if business logic imports are at the
top of the file instead of inside the function body. In a BL file, check if imports are
unnecessarily inlined.

**Example of correct pattern:**
```python
# In a controller — inline import at start of function
def create_user(json_args):
    from components.user.internal.business_logic.actions import create_user_action
    return create_user_action(name=json_args["name"])
```

---

### 2. Structured Logging

**Rule:** Use keyword arguments for log data. Never embed IDs or objects in f-strings —
this prevents Sentry/Datadog grouping.

**Source:** `backend/.ruler/python_guidelines.md` — Structured Logging section

**Detection:** Look for `current_logger.info(f"...{variable}...")` patterns where the
variable is an ID, object, or dynamic value.

**Correct:**
```python
current_logger.info("Processing contract", contract_id=contract_id, status=status)
```

**Incorrect:**
```python
current_logger.info(f"Processing contract {contract_id} with status {status}")
```

---

### 3. mandatory() Utility

**Rule:** Use `mandatory()` from `shared.helpers.typing` instead of manual None-assertion
patterns. It narrows the type for mypy and provides consistent error messages.

**Source:** Widespread pattern (60+ files). Defined in `backend/shared/helpers/typing.py`

**Detection:** `if x is None: raise ValueError(...)` or `assert x is not None` patterns
where `mandatory(x)` would suffice.

**Correct:**
```python
from shared.helpers.typing import mandatory
contract = mandatory(optional_contract, "Contract must exist at this point")
```

---

### 4. get_or_raise_missing_resource()

**Rule:** Use `get_or_raise_missing_resource()` to fetch by ID and raise on missing.
Never use `get_or_404()` or manual fetch + raise patterns.

**Source:** `backend/.ruler/python_guidelines.md` — Rule #4, Specs of a business logic method

**Detection:** `Model.query.get_or_404(id)` or `obj = session.get(Model, id); if obj is None: raise...`

**Correct:**
```python
from shared.helpers.resource import get_or_raise_missing_resource
contract = get_or_raise_missing_resource(Contract, contract_id)
# With eager loading:
doc = get_or_raise_missing_resource(
    InsuranceDocument, doc_id,
    options=[selectinload(InsuranceDocument.parsed_document_contents)]
)
```

---

### 5. @use_args with Marshmallow

**Rule:** New endpoints use `@use_args` with Marshmallow schemas. Never use deprecated
`@request_argument` / `@request_arguments` or `reqparse.RequestParser`.

**Source:** `backend/.ruler/controller_request_handling.md`

**Detection:** `@request_argument` or `@request_arguments` decorator on new code.

---

### 6. N+1 Query Prevention

**Rule:** Never execute DB queries inside a loop. Use eager loading
(`selectinload`, `joinedload`) or batch fetching.

**Source:** `backend/.ruler/python_guidelines.md` — Rule #4 (eager loading with get_or_raise_missing_resource)

**Detection:** `for item in items:` followed by a query/relationship access without
prior eager loading.

---

### 7. SQLAlchemy 2.0 Syntax

**Rule:** Exclusively use SQLAlchemy 2.0 querying syntax. Never use the legacy Query API.

**Source:** `backend/.ruler/python_guidelines.md` — SQLAlchemy section

**Detection:** `Model.query.filter(...)` instead of `select(Model).where(...)`

---

### 8. Empty __init__.py

**Rule:** `__init__.py` files must be empty. No imports, no code.

**Source:** `backend/.ruler/python_guidelines.md` — Rule #7. Enforced by linter ALN018.

---

### 9. Queries Return Dataclasses

**Rule:** Query functions return Python dataclasses, not ORM entities.

**Source:** `backend/.ruler/python_guidelines.md` — Rule #6

**Detection:** A query function that returns a SQLAlchemy model instance directly.

---

### 10. Business Logic Method Specs

**Rule:** BL methods accept object IDs (not instances), include docstrings,
and optionally accept an `actor` argument for permissions.

**Source:** `backend/.ruler/python_guidelines.md` — Specs of a business logic method

**Detection:** A new BL method that takes a model instance as argument instead of its ID.

---

## Frontend Conventions

### 11. toISODateFormat() for Dates

**Rule:** Never use `Date.toISOString()` to extract a date string — it converts to UTC
and silently shifts the date by ±1 day. Use `toISODateFormat()` from `date-utils`.

**Source:** `frontend/.ruler/date_formatting.md` — caused production bugs.

**Detection:** `.toISOString().split("T")[0]` or `.toISOString().slice(0, 10)`

---

### 12. Error Cause Pattern

**Rule:** Use `new Error("msg", { cause: error })` instead of string interpolation
in Error constructors.

**Source:** `frontend/.ruler/frontend_guidelines.md` — Error Handling section

---

### 13. Named Inline Exports

**Rule:** Use inline `export` on declarations. Never use `export default`.

**Source:** `frontend/.ruler/frontend_guidelines.md` — Export conventions

---

### 14. File & Folder Naming

**Rule:** React component files in PascalCase. Folders in camelCase.
One component per file, named after the component.

**Source:** `frontend/.ruler/frontend_guidelines.md` — Naming conventions

---

### 15. TSDoc on Components

**Rule:** Add documentation above exported React components, but only when the
component's purpose is non-obvious from its name and props. No boilerplate JSDoc.

**Source:** `frontend/.ruler/typescript_documentation.md`

---

### 16. useCamelCaseApi()

**Rule:** Use `useCamelCaseApi()` for backend API responses. Backend sends snake_case,
frontend uses camelCase — the hook handles conversion.

**Source:** `frontend/.ruler/frontend_guidelines.md` — Naming conventions, API responses

---

### 17. Loading & Empty States

**Rule:** Components that fetch data should handle loading state (skeleton/spinner)
and empty state. No flash of empty content.

**Source:** Recurring PR feedback (Mickael Bergem). Check if sibling components have
loading states to calibrate expectations.

---

### 18. Functions Outside Render Body

**Rule:** Define functions outside the component body or use useCallback. Don't declare
functions or complex variables inside the JSX return block.

**Source:** Recurring PR feedback. React re-creates inline functions on every render.

---

### 19. Analytics/Amplitude Tracking

**Rule:** Every new user-facing interaction (button click, navigation, form submit)
should have an Amplitude tracking event.

**Source:** Recurring PR feedback (Mickael Bergem). Check sibling components for tracking
patterns to calibrate.

---

### 20. i18n — No Hardcoded Strings

**Rule:** No hardcoded user-facing strings in components that use translations.
Admin dashboards serve both French and English-speaking admins.

**Source:** Recurring PR feedback (Mickael Bergem).

**Detection:** Raw string literals in JSX where the module uses `useTranslation()` or
similar i18n functions.
