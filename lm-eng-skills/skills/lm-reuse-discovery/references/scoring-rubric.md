# Scoring Rubric

Each candidate is scored on 4 axes. **Final score = min of the 4 axes** (the weakest link decides).

## Axis 1 — Coverage

How well the candidate covers the need.

| Score | Criterion |
|---|---|
| **high** | Covers the need exactly, without a wrapper. The call site writes `candidate(...)` directly. |
| **medium** | Covers the need with a light wrapper (1–3 lines) or a subset of the parameters. |
| **low** | Covers tangentially: same domain, partially useful output, requires extraction or transformation. |

**Examples**:
- Need `fetch employment by member_id`, candidate `get_employment_for_member(member_id)` → **high**
- Need `fetch employment by member_id`, candidate `get_member_with_employment(member_id)` (also brings back the member) → **medium**
- Need `fetch employment by member_id`, candidate `list_employments_for_company(company_id)` → **low** (must filter on the caller side)

## Axis 2 — Genericity

Ability to use the candidate without modifying it.

| Score | Criterion |
|---|---|
| **high** | Reusable as-is. Stable API, clear parameters, no hidden side-effects. |
| **medium** | Requires a new optional parameter to cover the use case (non-breaking extension). |
| **low** | Requires a fork or a rewrite; existing call sites assume incompatible behavior. |

## Axis 3 — Domain proximity

How well the candidate belongs to the right semantic context.

| Score | Criterion |
|---|---|
| **high** | Same component as the feature. Same bounded context. |
| **medium** | Neighboring component in the same area (e.g. OH ↔ contracting), or generic shared/utils where the usage is conventional. |
| **low** | Foreign component, or shared too low-level to carry business semantics (e.g. reusing a CSV parser to parse a structured payload). |

## Axis 4 — Maturity

Confidence in the candidate.

| Score | Criterion |
|---|---|
| **high** | Tested (tests present), used in ≥ 3 call sites, stable for several commits. |
| **medium** | Tested OR used in ≥ 1 call site, but not both. |
| **low** | No tests AND no external call site (potentially abandoned), or flagged `@deprecated`. |

## Heuristics for quick computation

1. If `usage_count >= 3` and tests exist → **maturity high**.
2. If `usage_count == 0` (zero call sites) → **maturity low**, almost always.
3. If the candidate is in a `legacy/`, `old/`, `__deprecated__/` → **low** automatically on all axes.
4. If the signature contains `**kwargs` or `Any` everywhere → **genericity low** (fuzzy API).

## When to filter out a candidate (do not propose it at all)

- The candidate is marked `@deprecated` or its docstring says "will be removed"
- It is in `migrations/`
- It is in a test (unless the scope is explicitly `tests_factories`)
- Its signature is strictly more complex than what the need requires AND a simpler option exists

## Annotated examples

### Example 1

Need: `validate IBAN format`

Candidate: `backend/shared/validators/iban.py:12 — def is_valid_iban(iban: str) -> bool`

- Coverage: high (covers exactly)
- Genericity: high (stateless, simple signature)
- Proximity: high (shared validators, the canonical place)
- Maturity: high (12 call sites, tests present)
- **Final: high** ✅

### Example 2

Need: `render employee picker dropdown`

Candidate: `frontend/packages/oh-admin/src/components/EmployeeSelect.tsx:18 — export const EmployeeSelect`

- Coverage: medium (covers, but exposes all the props of the underlying Select, leaking to the call site)
- Genericity: high (accepts `onChange`, `value`, `companyId`)
- Proximity: high (same OH admin module)
- Maturity: medium (2 call sites, no dedicated test)
- **Final: medium** 🟡

### Example 3

Need: `serialize StoppageRead schema`

Candidate: `backend/components/occupational_health/.../legacy/stoppage_schemas.py:42 — class StoppageReadSchema_old`

- Coverage: medium (the shape no longer matches the new needs)
- Genericity: low (Schema with custom post-processing)
- Proximity: high (same component)
- Maturity: low (legacy, will be removed)
- **Final: low** 🔴 → actually: **filter out** (legacy, do not propose)
