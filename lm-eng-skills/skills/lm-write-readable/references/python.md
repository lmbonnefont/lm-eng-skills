# Python readability rules (write-time)

Concrete rules for writing readable backend Python in alan-apps. Read this before coding a Python unit, then apply the self-review pass from SKILL.md.

The local source of truth is `backend/.ruler/python_guidelines.md` and `backend/.ruler/python_type_hints.md` — when in doubt, follow them. This file is the readability layer on top.

## Naming & intent

- Name for the domain concept, not the type: `active_employments`, not `emp_list` or `items`.
- Extract a named intermediate variable rather than inlining a multi-step expression. One extra line that names the result is worth more than a dense one-liner.
- Extract complex conditions into named booleans:
  ```python
  # Harder to read
  if employment.end_date is None and employment.subscriber_id == subscriber.id and not employment.is_archived:
      ...

  # Reads itself
  is_active_for_subscriber = (
      employment.end_date is None
      and employment.subscriber_id == subscriber.id
      and not employment.is_archived
  )
  if is_active_for_subscriber:
      ...
  ```

## Comprehensions vs. loops

Readability over line count (user convention). A comprehension is great when it's one clear transform. The moment it carries a condition *and* a transform *and* a nested call, a named loop reads better.

```python
# Too dense — three things at once
result = {e.id: format_visit(e) for e in visits if e.status == "done" and e.is_billable}

# Clearer as sequential steps
billable_done_visits = [v for v in visits if v.status == "done" and v.is_billable]
visits_by_id = {visit.id: format_visit(visit) for visit in billable_done_visits}
```

## Function structure

- One function, one responsibility. If the name needs "and", split it.
- Early-return / guard clauses to flatten nesting — keep the happy path at the lowest indentation:
  ```python
  # Nested
  def get_renewal(employment):
      if employment.is_active:
          if employment.contract:
              return build_renewal(employment.contract)
      return None

  # Flat
  def get_renewal(employment):
      if not employment.is_active:
          return None
      if not employment.contract:
          return None
      return build_renewal(employment.contract)
  ```
- A function long enough to need `# --- section ---` comments is two functions.

## Type hints (mandatory)

- Every function signature is fully typed (args + return). See `backend/.ruler/python_type_hints.md`.
- Return a `NamedTuple`, never a plain tuple — names make the call site readable (user convention):
  ```python
  class RenewalResult(NamedTuple):
      renewal: Renewal
      is_first_renewal: bool

  def compute_renewal(...) -> RenewalResult:
      ...
  ```

## Docstrings (mandatory, synthetic)

Every function gets a docstring, but keep it **synthetic** — describe current input/output and behavior only.

- Do: state what it takes and returns, and any non-obvious effect.
- Don't: narrate migration/bug history or why it changed (that's PR/commit territory).
- Don't: reference callers, the frontend, UI, tags, or admin (the function shouldn't know who calls it).

```python
def get_active_establishments(subscriber_id: int) -> list[Establishment]:
    """Return the non-archived establishments linked to the subscriber."""
```

## Comments

- Prefer self-documenting code; reserve comments for the *why* code can't carry (a regulatory constraint, a deliberate workaround).
- Never restate what the code already says. `# increment counter` above `counter += 1` is noise.
- Don't delete existing useful comments when editing nearby (CLAUDE.md "Surgical changes").

## Simplicity & YAGNI

- No defensive `try/except` or null-checks for cases the types already rule out. Validate at real boundaries only.
- No helper extracted for a single call site unless its name genuinely clarifies intent.
- Respect the *7 Coding Rules* in `python_guidelines.md` (anemic models, segregate queries/actions, return dataclasses not ORM entities, thin controllers, nothing in `__init__.py`) — these are structural readability too: a reader knows where to look when the layering is consistent.
