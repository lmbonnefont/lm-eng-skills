---
name: lm-flow-walkthrough
description: >
  Trace and explain code flows end-to-end with annotated call chains and narrative
  explanations. Every claim is backed by a file:line reference.
  Use when: /lm-flow-walkthrough, "trace le flow de X" / "trace the flow of X",
  "comment fonctionne X" / "how does X work", "walk me through X",
  "explique le flow de l'endpoint Y jusqu'à la DB" / "explain the flow from endpoint Y down to the DB",
  "qu'est-ce qui se passe quand Z" / "what happens when Z", "how does X work in the codebase".
  Also callable in caller mode from other skills (e.g. lm-guided-feature-development Part 2).
  Do not use for: static architecture overviews (use /xray),
  library documentation (use /explore-lib).
---

# Flow Walkthrough

Trace a code flow end-to-end and produce two outputs:
- **Section A**: Annotated call chain with clickable `file:line` at each hop
- **Section B**: "Evidence trace" style narrative explanation — every claim backed by a reference

**Core rule**: never present a hypothesis as a fact. If a hop is not verifiable (dynamic dispatch, untyped code), flag it as `[GAP]` with the possible candidates.

## Invocation modes

| Mode | Trigger | Behavior |
|---|---|---|
| **Standalone** | `/lm-flow-walkthrough <input>` | Interactive, confirmation gate at the end |
| **Caller** | Invoked from another skill (subagent) | Non-interactive, returns structured JSON + readable output |

In caller mode, the subagent prompt must contain `"caller mode"` to disable the interactive gates.

---

## Step 0 — Input resolution

`$ARGUMENTS` is one of these three types. Detect and normalize:

| Input pattern | Type | Example | Strategy |
|---|---|---|---|
| HTTP method + path, or URL path | endpoint | `POST /api/v1/proposals`, `/proposals` | Grep route decorators |
| file.py:function_name or file:line | file-function | `contracting/public/proposal.py:approve_proposal` | Read the file directly |
| Free text describing a concept | concept | "renewal tacit approval", "how enrollment works" | Grep key terms, identify entry points |

If ambiguous (multiple candidates), use `AskUserQuestion`:
"I found several possible entry points. Which one should I trace?" with each candidate as an option (`file:line — description`).

---

## Step 1 — Entry point localization

### For an endpoint

1. Grep the path in the route decorators:
   - `backend/apps/*/` and `backend/components/**/controllers/` for `@blueprint.route`, `@*.get`, `@*.post`, etc.
   - `frontend/modules/global-api/src/` for the client-side API hooks
2. If found on both sides (backend + frontend), present both and ask which direction to trace
3. If multiple matches (same path in FR and BE apps), present the options via `AskUserQuestion`

### For a file:function

1. Read the file, locate the function
2. Determine the layer from the path:
   - `public/` → cross-component public API
   - `internal/controllers/` → HTTP controller
   - `internal/business_logic/` → business logic
   - `internal/models/` → ORM / DB
   - `external/` → anti-corruption layer
   - `frontend/modules/*/src/screens/` → frontend screen
3. Propose the trace direction via `AskUserQuestion`: DOWN (callees), UP (callers), or BOTH

### For a concept

1. Grep the key terms in `backend/` and `frontend/`
2. Rank by layer relevance: `public/` > `controllers/` > `business_logic/` > `models/` > the rest
3. Filter out tests, migrations, `__pycache__`
4. Present the top 5 candidates with `file:line` and 1-line context
5. The user confirms the entry point via `AskUserQuestion`

---

## Step 2 — Call chain trace

Starting from the resolved entry point, trace the flow hop by hop.

### Trace procedure

1. **Read** the current function
2. **Identify** all outgoing calls (function calls, imports)
3. For each call: **resolve** to `file:line` via Grep + Read
4. **Record**: caller `file:line` → callee `file:line`, with a 1-line summary
5. If resolution is impossible: **flag** `[GAP: reason]` with the possible candidates
6. **Parallelize** the Greps when possible (search for callers and callees simultaneously)

### Backend trace patterns (alan-apps architecture)

The backend follows a layered architecture. The typical trace descends as follows:

```
apps/{country}_api/config/components_config.py  (blueprint registration)
  → components/{name}/bootstrap/bootstrap.py  (component bootstrap)
    → components/{name}/internal/controllers/*.py  (HTTP handler, @use_args)
      → components/{name}/internal/business_logic/actions/*.py  (mutations)
         or /queries/*.py  (reads → return dataclasses)
        → components/{name}/internal/models/*.py  (SQLAlchemy ORM)
        → components/{name}/external/*.py  (external service calls)
        → shared/*  (cross-cutting helpers)
      → components/{name}/public/*.py  (public API if cross-component)
```

**Conventions to know in order to trace correctly**:
- Controllers import the BL **inline** (in the function body), never at the top of the file — look for imports in the body, not in the header
- The BL accepts IDs, not ORM objects — uses `get_or_raise_missing_resource()`
- Queries return **dataclasses**, not ORM entities
- `@use_args` with Marshmallow schemas for request parsing
- Country-specific logic in `app_specifics/{country}/` — **always flag as GAP** because it is resolved at runtime
- Plugin system: runtime dispatch via `get_plugin()` — **always flag as GAP**
- Event subscribers (Flask signals) — check `bootstrap.py` for the registered listeners

### Frontend trace patterns

```
frontend/apps/{app}/routes.tsx  (route definition)
  → frontend/modules/{module}/src/screens/*.tsx  (screen component)
    → frontend/modules/{module}/src/components/*.tsx  (UI components)
    → frontend/modules/global-api/src/*.ts  (API hooks: useQuery/useMutation)
      → backend endpoint  (link to backend trace)
```

### Cross-stack (frontend → backend)

If the flow spans the frontend and the backend, trace both in sequence:
1. Frontend down to the API hook (`useQuery`/`useMutation` in `global-api/`)
2. Mark the HTTP boundary clearly: `--- HTTP boundary: GET /api/... ---`
3. Backend from the corresponding controller down to the DB/external service

### End-to-end flows (user-visible output)

For changes that affect what the user sees/receives (downloaded filename, email content, displayed text), trace the **full pipeline** from the user trigger to the final exit point. The exit point (e.g. the download's `Content-Disposition` header) is often distinct from the production point (e.g. S3 upload). Always identify both.

### path → domain mapping table

| Path Pattern | Domain | Backend App | Frontend App |
|---|---|---|---|
| `apps/fr_api/` or `components/fr/` | France | `fr_api` | `fr-server` |
| `apps/be_api/` or `components/be/` | Belgium | `be_api` | `be-server` |
| `apps/es_api/` or `components/es/` | Spain | `es_api` | `es-server` |
| `apps/ca_api/` or `components/ca/` | Canada | `ca_api` | `ca-server` |
| `apps/eu_tools/` | Internal Tools | `eu_tools` | `eng-tools-server` or `eu-home-server` |

### Limits

- **Max depth**: 8 hops. Beyond that, flag it and ask whether the user wants to continue.
- **Terminal nodes**: DB query (SQLAlchemy), external HTTP call, React render. Stop the trace at these points.

---

## Step 3 — Output production

The output is structured into **3 sections**, always in this order. All 3 sections consistently use the `` `path/to/file:LINE` `` format for every reference — no exceptions.

### Section A: High-level narrative

The goal is to give an **overall picture** of the flow in plain language, as if explaining it to a colleague discovering the feature. Each major step is a sentence with a clickable link to the main file for that step. We don't go into function-level detail here — we describe the journey and the main business rules.

**Format**:

```
## How [description] works — Overview

When [user trigger], here is what happens:

1. **[Step name]** — The frontend displays [what] via the `ComponentName` component
   → `frontend/modules/.../screens/VisitScreen.tsx:42`

2. **[Step name]** — The user [action], which calls the `[METHOD /path]` API
   → `frontend/modules/global-api/src/visits/useNextVisit.ts:18`

   --- HTTP boundary: GET /api/visits/next-deadline ---

3. **[Step name]** — The backend receives the request and delegates to the business logic
   → `backend/components/.../controllers/visit.py:67`

4. **[Step name]** — The BL applies [main business rule: e.g. "computes the next deadline based on the visit type and regulatory constraints"]
   → `backend/components/.../queries/next_visit_deadline.py:34`

5. **[Step name]** — [Secondary business rule or data step]
   → `backend/components/.../models/visit.py:89`

### Key business rules
- **[Rule 1]**: [simple description, e.g. "an onboarding visit must take place within 3 months of the start date"] → `file:line`
- **[Rule 2]**: [description] → `file:line`
- [GAP] [Uncertain rule]: [hypothesis to verify] — not proven in the code
```

**Narrative principles**:
- Write as if telling a story: "when X does Y, the system Z"
- Each step = **one sentence**, not a list of functions
- Name the **business rules**, not the technical details ("computes the deadline" > "calls `compute_deadline()`")
- Always a clickable link to the **main** file for the step
- The key business rules are listed separately at the end — these are the system's invariants

### Section B: Per-function deep dive

After the narrative, we dive into **each function traversed**, in call chain order. For each function, we explain:
- What it does (1-2 sentences)
- The business rules it encodes (with clickable links to the exact lines)
- The important inputs/outputs
- The notable edge cases or conditional branches

**Format**:

```
## Deep dive

### 1. `ComponentName` — `frontend/modules/.../screens/VisitScreen.tsx:42`

Displays the medical visit tracking page. Fetches the data via the
`useNextVisitDeadline()` hook (`frontend/modules/global-api/src/.../useNextVisit.ts:18`).

**Rules**:
- Displays an alert badge if the deadline is < 30 days → `:67`
- Hides the section if the member has no active OH follow-up → `:52`

---

### 2. `GET /api/visits/next-deadline` — `backend/components/.../controllers/visit.py:67`

HTTP controller. Receives `member_id` as a query param (`@use_args` with `VisitDeadlineQuerySchema` → `:64`).
Delegates to `get_next_visit_deadline()` via inline import → `:79`.

---

### 3. `get_next_visit_deadline()` — `backend/components/.../queries/next_visit_deadline.py:34`

Computes the next medical visit deadline for a given member.

**Rules**:
- Onboarding visit: deadline = start_date + 3 months → `:56`
- Periodic visit: deadline = last_visit + interval (depends on the role) → `:78`
- Enhanced follow-up: interval reduced to 12 months → `:92`
- [GAP] The interval computation for night workers goes through `get_plugin()` → runtime resolution

**Inputs**: `member_id: int`, `account_id: int`
**Output**: `NextVisitDeadlineEntity` (dataclass) → `:23`

---

### 4. `Visit` model — `backend/components/.../models/visit.py:89`

SQLAlchemy model. Query with `selectinload` on `visit_type` and `member` → `:102`.
PostgreSQL table: `occupational_health_visit`.
```

**Deep dive principles**:
- Each function = a block with its own heading `### N. name — file:line`
- The **business rules** are in bold and each one has a link to the exact line
- If a function has no notable business rule (pure plumbing), say so in one line and move on
- Inputs/outputs are mentioned only when they are useful for understanding the connections
- Edge cases and conditional branches are listed as rules

### Section C: Gaps and assumptions

Group all gaps and assumptions at the end for a consolidated view:

```
## Gaps & Assumptions

### Gaps (not verified in the code)
- **[GAP 1]** at step N: [reason] — possible candidates: `file:line`, `file:line`
- **[GAP 2]** at step N: [reason]

### Assumptions (not proven)
- The user is authenticated (the `@requires_auth` decorator at `file:line` suggests so)
- The config exists in the database (no guard clause found at `file:line` — potential bug?)
```

### Caller mode: additional structured JSON

In caller mode, return — **in addition** to the 3 readable sections — a JSON block:

```json
{
  "entry_point": {
    "file": "path/to/entry.py",
    "line": 67,
    "type": "endpoint"
  },
  "narrative": {
    "summary": "When X does Y, the system Z...",
    "steps": [
      { "name": "Visit screen display", "description": "The frontend displays...", "main_file": "path:line" },
      { "name": "API call", "description": "The user clicks...", "main_file": "path:line" }
    ],
    "business_rules": [
      { "rule": "Onboarding visit within 3 months", "file": "path/to/file.py", "line": 56 }
    ]
  },
  "call_chain": [
    {
      "step": 1,
      "layer": "route|controller|business_logic|model|external|frontend_screen|frontend_api",
      "file": "path/to/file.py",
      "line": 42,
      "function": "function_name",
      "summary": "1-line description",
      "rules": ["business rule encoded here"]
    }
  ],
  "gaps": [
    {
      "at_step": 4,
      "reason": "dynamic dispatch via get_plugin()",
      "candidates": ["path/to/candidate1.py:89", "path/to/candidate2.py:67"]
    }
  ],
  "relevant_files": [
    { "path": "...", "line": 67, "reason": "main controller" }
  ],
  "patterns_observed": ["inline imports in controllers", "dataclass return from queries"],
  "potential_issues": ["no null guard on campaign config lookup"],
  "all_usages": {
    "concept_name": { "total_count": 18, "top_files": ["..."] }
  },
  "e2e_flows": [
    {
      "what_user_sees": "downloaded filename",
      "trigger": "user clicks Download button",
      "pipeline": ["frontend calls GET /exports/{id}/download", "controller fetches from S3", "controller sets Content-Disposition header"],
      "output_point": { "file": "path/to/controller.py", "line": 481, "what_it_controls": "Content-Disposition filename" }
    }
  ]
}
```

The `relevant_files`, `patterns_observed`, `potential_issues`, `all_usages`, `e2e_flows` fields are directly consumable by `lm-guided-feature-development` Step 3 (Architecture Proposal).

---

## Step 4 — Confirmation gate

### Standalone mode

Use `AskUserQuestion` with:
- "I understand the flow, thanks" → end the skill
- "Trace deeper into step [X]" → re-enter Step 2 at the specified node
- "Explain step [X] in more detail" → read the relevant file and explain
- "Show me the contents of file [Y]" → Read and present

### Caller mode

Skip this step — the calling skill handles the user interaction.
