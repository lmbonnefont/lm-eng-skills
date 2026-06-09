---
name: lm-clone-marmotte
description: >
  Extracts the surface implementation (frontend + backend) of a Marmot feature
  (Alan admin tool) to enable replicating it elsewhere — typically in the
  Occupational Health admin. Produces a shallow markdown blueprint with
  clickable file:line links for the route, screen, components, API hooks,
  endpoints, schemas and the BL it calls.
  Use when: `/lm-clone-marmotte`, "clone marmotte de [feature]" / "clone marmotte of [feature]",
  "extrait l'implémentation de [X] dans Marmot" / "extract the implementation of [X] in Marmot",
  "blueprint Marmot pour [URL]" / "Marmot blueprint for [URL]", a pasted `marmot.alan.com/...` URL,
  "comment est fait [écran admin] que je veux répliquer" / "how is [admin screen] built that I want to replicate",
  "donne-moi le code source de [feature Marmot]" / "give me the source code of [Marmot feature]",
  "je veux copier [feature] de Marmot vers OH admin" / "I want to copy [feature] from Marmot to OH admin".
  Also generic for other apps (fr-app, be-app...) if the user specifies the app
  — Marmot by default.
  Do not use for: tracing an E2E flow (use `/lm-flow-walkthrough`),
  static architecture overview (use `/xray`).
---

# Clone Marmotte

Extracts the **shallow** implementation skeleton of a Marmot feature (or other admin app) to make replicating it easier. Coverage: route → screen → components → API hooks → controllers → schemas → the BL it calls. **We stop at the BL function** (no descent into queries, models, ORM). If the user wants a deep dive, redirect to `/lm-flow-walkthrough`.

**Fundamental rule**: every reference is a clickable `path/file.ext:LINE`, outside of code blocks. If an element cannot be proven by reading/grep, flag it `[GAP: reason]`.

---

## Marmot conventions to know

- Marmot frontend: `frontend/apps/fr-marmot/`
  - Routes: `frontend/apps/fr-marmot/routes/`
  - Screens: under `frontend/apps/fr-marmot/.../screens/` or `pages/`
  - API client: `AdminCamelCaseApi` (alias `camelCaseAdminApi`) defined in `frontend/apps/fr-marmot/backend.ts`
    - Methods: `get(path)`, `post(path, body)`, `patch(path, body)`, `delete(path)`
    - Automatic snake_case ↔ camelCase conversion
- Marmot backend: controllers in `backend/components/*/internal/*/controllers/marmot/`
  - Route prefix: `/api/...`
  - Flask decorators + `@use_args` with Marshmallow schemas `Marmot*Args`
  - BL imported **inline** (in the function body), not at the top of the file
  - BL accepts IDs (not ORM objects), returns dataclasses

---

## Step 0 — Input resolution

`$ARGUMENTS` can be:

| Pattern | Type | Strategy |
|---|---|---|
| URL `marmot.alan.com/...` | URL | Parse the path, grep in `frontend/apps/fr-marmot/routes/` |
| Free text ("contract edit page") | concept | Grep keywords in `frontend/apps/fr-marmot/`, ranking screens > routes > components |
| Explicit file path | file | Read directly |
| Mention of another app ("in fr-app", "be-marmot") | scope override | Replace `fr-marmot` with the target app |

If multiple plausible candidates, use `AskUserQuestion`:
"I found several possible entries. Which one?" — each option = `file:line — one-line description`.

---

## Step 1 — Scope pre-filter

Before extraction, ask via `AskUserQuestion`:
- **Frontend only** — extract only the UI part
- **Backend only** — extract only the endpoints + BL
- **Frontend + backend** (default) — extract everything

Remember the choice for Step 2 and Step 3. No re-filtering after extraction — what is extracted is delivered as is.

---

## Step 2 — Shallow extraction

Parallelize as much as possible (multiple Greps in parallel).

### Frontend (if in scope)

1. **Route**: from the URL or the screen, identify the route definition in `frontend/apps/fr-marmot/routes/` → `file:LINE` + path
2. **Screen**: component pointed to by the route → `file:LINE` + 1-line description
3. **UI components**: grep the component imports from the screen (1 level only). List each component with its role. Do not trace deep.
4. **API hooks**: grep `camelCaseAdminApi.(get|post|patch|delete)\(` in the screen's subtree and its direct children. For each match: capture method + path + `file:LINE`
5. If a custom hook (e.g. `useFooData`) wraps the API call, resolve it once (no more)

### Backend (if in scope)

For each identified endpoint (from the frontend OR provided as direct input):

1. **Controller**: grep the path in `backend/components/*/internal/*/controllers/marmot/` (route decorators) → `file:LINE` of the handler function
2. **Schema args**: identify the `@use_args(MarmotXxxArgs)` or equivalent → `file:LINE`
3. **BL called**: find the inline import in the body + the call site → `file:LINE` of the BL function with its signature (parameters + return type)

**Stop here**: we do not descend into the BL itself, we do not inspect the models, we do not follow sub-calls. The goal is a skeleton to imitate, not a complete audit.

If a step is not resolvable (dynamic dispatch, country-specific via plugin), flag it `[GAP: reason]`.

---

## Step 3 — Output production

### File save

Path: `tmp/agent-scratch/clone-marmotte-{slug}.md` (slug derived from the feature name, kebab-case).

If `tmp/agent-scratch/` does not exist (outside the alan-apps monorepo), fall back to `/tmp/clone-marmotte-{slug}.md`.

### Markdown structure

```
# Clone Marmotte — {Feature name}

**Source**: {provided URL or description}
**Extracted scope**: frontend | backend | both
**Date**: {YYYY-MM-DD}

## Frontend

### Route
- frontend/apps/fr-marmot/routes/Foo.tsx:42 — pattern `/admin/foo/:id`

### Screen
- frontend/apps/fr-marmot/.../FooEditScreen.tsx:18 — Foo edit screen

### Components used
| Component | File | Role |
|---|---|---|
| FooTable | frontend/.../FooTable.tsx:12 | table of Foo entries |
| FooForm | frontend/.../FooForm.tsx:8 | edit form |

### API calls (HTTP boundaries)
| Method | Path | Call site |
|---|---|---|
| GET | /admin/foo/:id | frontend/.../FooEditScreen.tsx:34 |
| PATCH | /admin/foo/:id | frontend/.../FooEditScreen.tsx:67 |

## Backend

### `GET /admin/foo/:id` — backend/components/fr/internal/foo/controllers/marmot/foo.py:45
- Schema args: `MarmotFooGetArgs` → backend/.../schemas/marmot.py:23
- BL called: `get_foo(foo_id: int) -> FooEntity` → backend/.../business_logic/queries/foo.py:18

### `PATCH /admin/foo/:id` — backend/components/fr/internal/foo/controllers/marmot/foo.py:78
- Schema args: `MarmotFooPatchArgs` → backend/.../schemas/marmot.py:56
- BL called: `update_foo(foo_id: int, args: MarmotFooPatchArgs) -> FooEntity` → backend/.../business_logic/actions/foo.py:42

## Observed patterns
- Inline BL imports in controllers (alan-apps convention)
- ...

## Gaps
- [GAP] The computation of X goes through `get_plugin()` — runtime resolution, see candidates: ...
```

**Important for clickable links**:
- Format `path/file.ext:LINE` **outside** of code blocks (otherwise not rendered)
- In tables, write paths as plain text (not backticked). The Claude Code terminal renders them as clickable.
- See feedback memory: `feedback_no_links_in_codeblocks.md`

### Display in the conversation

In addition to the saved file, display a **condensed summary** (~30 lines max) with:
- The absolute path of the saved file
- A numbered list of key entries (route, screen, top 3 endpoints) with links
- A note "See the full file for details"

---

## Step 4 — UX recommendations (via `/lm-ux-delight`)

If the scope includes the frontend, **invoke the `lm-ux-delight` skill**, passing it the path of the markdown blueprint generated in Step 3.

```
Skill(skill="lm-ux-delight", args="--from-blueprint <absolute-path-of-the-md>")
```

The UX agent produces 3-5 micro-improvements that **preserve the source experience** but make the flow smoother for OH admins. Retrieve its output and **append** it to the saved markdown under a section `## Suggested UX improvements` (with the note "preserve the existing Marmot experience, to be discussed before implementing").

If scope = backend only, **skip Step 4**.

If `lm-ux-delight` is not available or fails, fall back: produce 2-3 simple inline suggestions (defaults, fewer clicks, feedback after an action) and flag `[lm-ux-delight unavailable]`.

---

## Step 5 — Technical anti-debt recommendations

Goal: during the OH replication, **do not copy the technical debt** of the source. Identify outdated patterns and propose the modern version.

**Framing**:
- 2-4 suggestions max
- Target the patterns observed in the blueprint that are **deprecated or worked around** by the current alan-apps conventions
- Check the `.ruler/` files (`.ruler/`, `backend/.ruler/`, `frontend/.ruler/`) for current conventions
- Prefer the patterns documented in CLAUDE.md (see "Conventions over existing code")

**Typical red-flag patterns to detect**:

| Source pattern (potentially debt) | Current recommendation |
|---|---|
| `Schema(Marshmallow)` classes | Migrate to `dataclass` + `class_schema()` (see `/migrate-schema-to-dataclass`) |
| `request_argument` / `request_arguments` | `@use_args` (see `/migrate-request-argument`) |
| `BaseController` (flask-restful) | `CustomMethodView` flask-smorest (see `/migrate-base-controller`) |
| Custom feature flags not on LaunchDarkly | LaunchDarkly (see `/migration-ff-to-launchdarkly`) |
| BL imports at the top of a controller | Inline imports in the body (alan-apps convention) |
| BL accepting ORM objects | BL must accept IDs only |
| Queries returning ORM entities | Must return dataclasses |
| Anonymous return tuples | `NamedTuple` (user preference) |
| Frontend components without a TSDoc docstring | Add TSDoc above the component (user preference) |
| Physical CSS properties (`marginLeft`) | Logical (`marginInlineStart`) if RTL scope |
| Tests that mock the DB | Hit the real DB in integration tests |

**Format in the markdown**:

```
## Suggested technical improvements (avoid debt when replicating)

> Note: the source uses patterns that have evolved in alan-apps. For the OH replica, prefer the current conventions.

1. **[detected source pattern]** → **[modern recommendation]**
   - Source file: path:LINE
   - Why: [short reason, link to ruler or migration skill if applicable]
   - Effort: XS / S / M

2. ...
```

If **no debt is detected**, write: "No blatant technical debt detected — the source follows the current conventions."

---

The skill ends here. No post-extraction re-filtering.

---

## Notes for other apps

If the user specifies an app other than Marmot (e.g. `fr-app`, `be-app`, `eng-tools-server`):
- Replace `frontend/apps/fr-marmot/` with `frontend/apps/{app}/`
- Backend: the controllers are no longer in `controllers/marmot/` but in `controllers/` directly (or `controllers/v2/`, etc.)
- Adapt the API client: `fr-app` uses `global-api` hooks (`useQuery`/`useMutation`), not `AdminCamelCaseApi`
- Mark the app used in the frontmatter "Extracted scope"

---

## Limits

- **Shallow only**: we stop at the BL signature on the backend, at 1 level of components on the frontend. No recursion. For a deep dive, suggest `/lm-flow-walkthrough` on the relevant endpoint.
- **No scaffold**: this skill produces a blueprint to read, not generated code for the target.
- **No tests** in the blueprint.
