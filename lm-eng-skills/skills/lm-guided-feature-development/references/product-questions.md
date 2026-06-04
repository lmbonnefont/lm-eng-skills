# Product Questions Bank

Question bank organized by feature type. To be enriched over time.

## Form

- Optional vs. required fields?
- Client-side validation, server-side, or both?
- Error state handling (message, field highlight, submission blocking)?
- Ability to save a draft? Behavior on abandonment?
- Expected field formats (phone, email, postal code)? Validation on input or on submission?

## List / Table

- Pagination, infinite scroll, or load-on-click?
- Available filters? Filter persistence (session or persistent)?
- Sortable? Which column(s)?
- Inline actions (edit, delete)? Confirmation required?
- Special states (loading, empty, error)?

## Multi-Step Flow (Wizard)

- Can the user go back? Validated progression or free navigation?
- State saved on abandonment? Where (session, localStorage, backend)?
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

- Automatic refresh (polling, WebSocket, refetch on focus)?
- Offline behavior (cache, retry, message)?
- Optimistic updates or wait for server response?

## Sensitive / Medical Data

- On-the-fly encryption? Partial masking (e.g., HIPAA)?
- Audit trail, access logs?
- GDPR / right to be forgotten?

## API Endpoint (Backend-only)

- Request/response format (JSON, CSV, streaming)?
- Authentication required (token, session, API key)? Authorized roles?
- Pagination (offset, cursor)? Default and maximum limit?
- Rate limiting? Per-user/organization quotas?
- Synchronous or asynchronous processing (task queue, webhook callback)?
- Idempotence required (retry-safe)?
- Error handling (HTTP codes, error format, localized messages)?

---

**Note**: This file is updated after each feature with newly discovered questions.
