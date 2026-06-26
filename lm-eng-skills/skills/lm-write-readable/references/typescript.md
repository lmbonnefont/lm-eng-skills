# TypeScript / React readability rules (write-time)

Concrete rules for writing readable frontend TypeScript and React in alan-apps. Read this before coding a TS/React unit, then apply the self-review pass from SKILL.md.

The local source of truth is `frontend/.ruler/frontend_guidelines.md` and `frontend/.ruler/typescript_documentation.md` — when in doubt, follow them. This file is the readability layer on top.

## Naming & intent

- Name for the domain concept: `activeEstablishments`, not `data` / `arr` / `res`.
- Extract a named intermediate `const` instead of inlining a multi-step expression — the name documents the step.
- Pull complex JSX conditions into named booleans so the render reads top-to-bottom:
  ```tsx
  // Hard to scan inside JSX
  {employment.endDate == null && !employment.isArchived && employment.subscriberId === subscriberId && (
    <RenewalBanner />
  )}

  // Reads itself
  const isActiveForSubscriber =
    employment.endDate == null &&
    !employment.isArchived &&
    employment.subscriberId === subscriberId

  return <>{isActiveForSubscriber && <RenewalBanner />}</>
  ```

## Component structure

Follow `frontend_guidelines.md` "Component extraction":

- Extract the **largest pure subtree**, not a tiny wrapper around one design-system component.
- Don't build wrapper chains (Footer → Link → A) — use design-system components directly.
- Don't extract a single-use component that just forwards props to one design-system component.
- One component per file, file named after the component (PascalCase). Folders camelCase.

A component whose body you have to scroll to read is doing too much — extract the cohesive subtrees.

## Hooks

- Extract non-trivial logic (state machines, derived data, effects, data fetching) into a custom `useX` hook so the component body stays declarative — it reads as "what to render", not "how to compute it".
- Keep effects single-purpose; one `useEffect` per concern beats one effect doing three things.

## Props & types

- Typed, named props. Define a `Props` type — no inline anonymous object shapes that hide intent at the call site.
- Prefer precise types over `any` / loose `Record`. A reader learns the shape from the type.
- API field casing: backend sends `snake_case`, frontend consumes `camelCase` via `useCamelCaseApi()`. Write components against camelCase. (See `frontend_guidelines.md` Naming conventions.)

## Conditional rendering & early return

- Early-return for loading / empty / error states at the top of the component, so the main JSX isn't buried in nested ternaries:
  ```tsx
  if (isLoading) return <Spinner />
  if (employments.length === 0) return <EmptyState />
  return <EmploymentList employments={employments} />
  ```
- Avoid nested ternaries in JSX — they're the TS equivalent of deep nesting. Name the branches or early-return.

## Documentation (TSDoc)

- Follow `frontend/.ruler/typescript_documentation.md`.
- Add a TSDoc docstring above React components (user convention) and on non-obvious functions.
- Keep it synthetic: describe what the component/function does and its props/return — not history, not the caller.

## Error handling

- Use the Error cause pattern, not string interpolation (from `frontend_guidelines.md`):
  ```ts
  // Good — preserves the stack
  throw new Error("Invalid token format", { cause: error })
  // Bad
  throw new Error(`Invalid token format: ${error instanceof Error ? error.message : "Unknown"}`)
  ```

## Exports & simplicity

- Inline named exports; no default exports (avoids rename drift). See `frontend_guidelines.md` Export conventions.
- YAGNI: no premature generic components, no props "in case we need them later". Build for the current screen.
- Touch only what the task needs — don't reformat or refactor adjacent components in the same pass.
