# Product Questions Bank

Question bank organized by feature type. **Product/UX only** — these are asked during Part 1 grilling.
Implementation/technical decisions (data model, API shape, persistence mechanism, auth mechanism, pagination strategy, encryption, sync/async, idempotence) are NOT here — they are decided in Part 2 (Technical Plan).

## Form

- Optional vs. required fields?
- What validation rules, and when does the user see the error (on input vs. on submission)?
- Error state handling (message, field highlight, submission blocking)?
- Ability to save a draft? Behavior on abandonment?
- Expected field formats the user must follow (phone, email, postal code)?

## List / Table

- Pagination, infinite scroll, or load-on-click?
- Available filters? Filter persistence (session or persistent)?
- Sortable? Which column(s)?
- Inline actions (edit, delete)? Confirmation required?
- Special states (loading, empty, error)?

## Multi-Step Flow (Wizard)

- Can the user go back? Validated progression or free navigation?
- Is progress preserved if the user leaves and comes back?
- Optional steps or all required?
- Final summary before confirmation?
- Behavior after success (redirect, modal, message)?

## Empty State

- Different display depending on context (first use vs. filter returning no results)?
- Illustration, explanatory text, suggested primary action?
- Link to create/import the first data entry?

## Notifications / Alerts

- Type (success, warning, error, info)?
- Channel (in-app toast, email, push, banner)?
- Trigger (user action, backend event)?
- Display duration (auto-dismiss or user dismiss)?
- Rate limiting (avoid notification spam)?

## Permissions / Restrictions

- Who can access this feature (role, state, onboarded)?
- Behavior if access denied (redirect, message, disabled button)?
- Associated feature flags or A/B experiments?

## Data State

- Do the data update live for the user (and how fresh must they be)?
- Offline behavior the user sees (cached view, retry, message)?
- Should the UI reflect a change instantly or only after server confirmation?

## Sensitive / Medical Data

- Should sensitive data be partially masked in the UI (e.g., only last digits shown)?
- Any user-facing consent / GDPR flow (right to be forgotten, data export)?
- Who is allowed to view this data, and what does a non-authorized user see?

## API Endpoint (Backend-only)

- What business capability does this endpoint enable?
- Who/what consumes it, and what do they need back to do their job?
- Which outcomes and error cases matter to the consumer?
- Who is authorized to use it, and what happens when they are not?

---

**Note**: Product/UX questions only. This file is updated after each feature with newly discovered product questions. Technical questions belong to Part 2, not here.
