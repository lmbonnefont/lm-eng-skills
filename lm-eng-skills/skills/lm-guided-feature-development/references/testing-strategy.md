# Testing Strategy Guide

Testing strategy guide organized by layer (frontend, backend). To be enriched over time with patterns used in real features.

## Frontend Testing

### Navigation & Integration

**URL Testing**

- What URL to access the feature? (e.g., `/profile/edit`, `/claims/new`)
- Required state before accessing? (onboarded, logged in, specific role, active feature flag)
- Behavior if condition not met? (redirect, 404, message)
- URL parameters (search, hash, params) to test?

**Example**

```
Feature: Edit profile
- URL: /profile/edit
- Conditions: logged in + user.isOnboarded === true
- Redirect if: !user || !user.isOnboarded → /onboarding
- Test: navigate with/without conditions, verify redirect behavior
```

### Unit Tests (Jest + Testing Library)

Use the `jest-unit-test` skill for writing Jest tests. It contains all patterns, conventions, and examples needed.

### Storybook Stories

Use the `storybook-stories` skill for creating Storybook stories. It covers variants, play functions, and accessibility testing.

## Backend Testing

### Integration Tests (pytest + Flask test client)

**Endpoint Testing**

- Method & path (GET /api/users, POST /api/users)
- Request body validation (required fields, types)
- Authorization (authenticated vs. public, role-based)
- Response codes (200, 201, 400, 403, 500)
- Response payload structure

**Example**

```python
def test_create_user_authorized(client):
    response = client.post(
        '/api/users',
        json={'email': 'test@example.com'},
        headers={'Authorization': f'Bearer {valid_token}'}
    )
    assert response.status_code == 201
    assert response.json['id'] is not None
```

### Unit Tests (pytest)

**Service Layer Tests**

- Business logic isolated (no API calls)
- Edge cases (empty input, None values, large datasets)
- Error handling (exceptions raised, proper messages)
- Database state (transaction rollback on error)

**Fixtures**

- Sample data factories (user, claim, contract)
- Mocked external services
- Isolated database per test

**Example**

```python
def test_eligibility_calculation(user_fixture):
    result = calculate_eligibility(user_fixture, contract)
    assert result.is_eligible == True
    assert result.reason == "within window"
```

### Database Tests

- Schema validation (foreign keys, constraints)
- Migration testing (forward & rollback)
- Data integrity checks

---

## Test Checklist

### Frontend

- [ ] Component renders without errors
- [ ] Conditional rendering per state (loading, error, empty, success)
- [ ] User interactions (click, type, submit) work as expected
- [ ] Accessibility (keyboard, screen reader, contrast)
- [ ] Error states display proper messages
- [ ] Feature flag behavior (enabled vs disabled)
- [ ] Mobile responsive (if applicable)

### Backend

- [ ] Endpoint returns correct status code
- [ ] Request validation (missing fields, invalid types)
- [ ] Authorization (correct role, token validation)
- [ ] Response structure matches spec
- [ ] Database changes are persisted correctly
- [ ] Error messages are clear & secure (no leaking data)
- [ ] Concurrent requests don't cause race conditions

---

**Note**: This file is updated after each feature with test patterns used and pitfalls encountered.
