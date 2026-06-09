# UX Patterns Catalog

Proven UX patterns in the alan-apps codebase. Referenced by `/lm-ux-delight` to
generate contextual recommendations.

Each pattern follows the format: Name, When, What, Evidence, Effort, Key detail.

---

## 1. Anticipated suggestions

**When**: Dropdown or autocomplete with a small dataset (<20 items).
**What**: Show the first N options on focus, before the user types anything. For small
lists, the user can choose visually without having to remember the exact value.
**Evidence**: PR #87355 — NIC dropdown for DSN establishments. Shows 5 suggestions by default
on focus. Implementation: remove the `!searchInput` guard in useMemo, add
`slice(0, MAX_DEFAULT_NIC_SUGGESTIONS)` for the default state.
**Effort**: Trivial
**Key detail**: Use a blur delay of 200ms to give the click on a suggestion time
to register before the dropdown closes.

---

## 2. Direct links to the result

**When**: Any action that creates, triggers, or modifies a resource the user will want
to see immediately (create an entity, send a message, trigger an export, etc.).
**What**: After the action succeeds, provide a direct link to the result instead of leaving
the user to find it manually. Replace "Success!" toasts with
"Success! [View the conversation →]".
**Evidence**: Pattern from PR #87071 — Intercom conversation creation for member changes.
The backend returns the conversation URL so the frontend can link directly
instead of asking the admin to open Intercom and search.
**Effort**: Medium (requires the backend to return the identifier/URL of the created resource)
**Key detail**: The link must be the primary action of the success feedback, not a
secondary element hidden in a toast that disappears.

---

## 3. Smart input behaviors

**When**: Forms with text fields, especially when there is a primary action field.
**What**: Auto-focus the first meaningful input on mount. Auto-select the text content
when the user focuses a pre-filled field (so they can overwrite without triple-clicking).
Blur delays on dropdowns to avoid accidental closures.
**Evidence**: Various admin dashboard forms.
**Effort**: Trivial
**Key detail**: Don't auto-focus if the page has a scroll — an auto-focus that triggers a scroll
down is disorienting for the user.

---

## 4. Hide empty sections

**When**: Component that displays N grouped sections (DrawerCollection, tabbed list, accordion) where some sections can be empty depending on context.
**What**: Condition the render of each section on `items.length > 0`. Never display a group title without content underneath.
**Evidence**: OHSET-521 — plural side modal with DrawerCollection Doctors / Nurses. If all the non-responders are of the same type, the empty section looks like a bug.
**Effort**: Trivial
**Key detail**: Also check the case where ALL sections would be empty — add a global empty state in that case rather than showing nothing at all.

---

## 5. Distinct empty states: no data vs. filtered result

**When**: Filterable list or table where the user can reach zero results either because there is no data, or because their filters match nothing.
**What**: Display two distinct empty states. No data → neutral message ("No X yet"). Empty filtered result → message + "Reset filters" link.
**Evidence**: OHSET-586 — read-only table of workplace actions (Occupational Health employer dashboard).
**Effort**: Trivial
**Key detail**: Distinguishing the two cases prevents the user from thinking they have no data when it's just their filter. The reset link should clear all filters in one click (useful with multi-dimension filters).

---

_This catalog grows over time. After each `/lm-ux-delight`, the new patterns
discovered and adopted are added here._
