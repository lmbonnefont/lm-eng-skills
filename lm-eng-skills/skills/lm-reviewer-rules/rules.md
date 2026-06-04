# Reviewer Rules — Bastien Landre & Mickaël Berguem

> Source: aggregated from `references/raw_comments.md` (rolling 4-month window).
> Refresh: `bash scripts/fetch_review_comments.sh` then re-synthesize.

---

## Architecture & layering

### Public interfaces must accept plain UUIDs alongside internal ID types
**Why:** "Since this is a public interface and `AccountId` is an internal type, let's also accept a plain `UUID` to avoid type errors" — public APIs should not force callers from other components to know internal typed-ID names.
**Sources:** [@MickaelBergem PR#76918](https://github.com/alan-eu/alan-apps/pull/76918#discussion_r2697786450), [@MickaelBergem PR#78226](https://github.com/alan-eu/alan-apps/pull/78226#discussion_r2740663747), [@MickaelBergem PR#82345](https://github.com/alan-eu/alan-apps/pull/82345#discussion_r2863606256)
**Trigger:** `backend/components/**/public/**`
**Severity:** P2

### Never return raw SQLAlchemy models from public interfaces
**Why:** "We should not return _models_ in public interfaces: either dataclasses or scalars."
**Sources:** [@MickaelBergem PR#77207](https://github.com/alan-eu/alan-apps/pull/77207#discussion_r2709128706)
**Trigger:** `backend/components/**/public/**`
**Severity:** P1

### Inline imports of business logic in controllers/commands; top-level OK in BL
**Why:** "Let's inline import of business logic from controllers file. It allows not importing business logic at app boot time (otherwise import time grows a lot)." Inside `internal/` business logic files, top-of-file imports are fine. Shared code must always be imported top-level.
**Sources:** [@MickaelBergem PR#77841](https://github.com/alan-eu/alan-apps/pull/77841#discussion_r2727190385), [@MickaelBergem PR#78187](https://github.com/alan-eu/alan-apps/pull/78187#discussion_r2753317385), [@MickaelBergem PR#83329](https://github.com/alan-eu/alan-apps/pull/83329#discussion_r2894810327), [@MickaelBergem PR#86369](https://github.com/alan-eu/alan-apps/pull/86369#discussion_r3022225853), [@MickaelBergem PR#87848](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3079115749)
**Trigger:** `backend/components/**/{controllers,commands}/**` and `backend/components/**/models/**`
**Severity:** P2

### Move business logic out of controller bodies into dedicated BL files
**Why:** "I tend to move business logic to dedicated files (out of the component file, which is more for presentational purposes)" / "This smells like it could be moved to a dedicated business logic action."
**Sources:** [@MickaelBergem PR#76291](https://github.com/alan-eu/alan-apps/pull/76291#discussion_r2676546695), [@MickaelBergem PR#82985](https://github.com/alan-eu/alan-apps/pull/82985#discussion_r2889342024)
**Trigger:** `backend/components/**/controllers/**`, `frontend/**/*.tsx`
**Severity:** P2

### Keep cross-component logic in the owning component, not in caller's component
**Why:** "I would prefer we keep owning it on our side, without having `fr` making any assumption over the structure of the contract_ref." Avoid leaking another component's internals — expose a query in the owning component.
**Sources:** [@MickaelBergem PR#79879](https://github.com/alan-eu/alan-apps/pull/79879#discussion_r2791930846), [@bastien-landre-alan PR#79345](https://github.com/alan-eu/alan-apps/pull/79345#discussion_r2773516926)
**Trigger:** `backend/components/**`
**Severity:** P1

### Test factories should not be made public — leaks models across components
**Why:** "Making a test factory public means leaking the model to other components (which is something we try to avoid, models are supposed to remain 'private' to the component)."
**Sources:** [@MickaelBergem PR#87968](https://github.com/alan-eu/alan-apps/pull/87968#discussion_r3078658753)
**Trigger:** `backend/components/**/public/testing.py`
**Severity:** P2

### Dedicated PR per concern: split migrations from business logic, persistence from POC
**Why:** "This PR is not forward-compatible (mix migration + business logic update)..." / "I'd prefer if we kept the persistence code in a dedicated PR." Smaller PRs are safer to deploy and easier to review.
**Sources:** [@MickaelBergem PR#83066](https://github.com/alan-eu/alan-apps/pull/83066#discussion_r2883178876), [@MickaelBergem PR#87848](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3079110750)
**Trigger:** `*`
**Severity:** P2

---

## Tests

### Use the `faker.Dataclass` / faker fixtures instead of hand-rolled factories
**Why:** "Can't we just use faker for this, following this announcement?" New convention pushed in eng_announcement.
**Sources:** [@MickaelBergem PR#78216](https://github.com/alan-eu/alan-apps/pull/78216#discussion_r2736717029), [@MickaelBergem PR#87443](https://github.com/alan-eu/alan-apps/pull/87443#discussion_r3057198644)
**Trigger:** `backend/components/**/tests/**`
**Severity:** P3

### Prefer function-based unit tests over class-based test grouping
**Why:** "Class-based tests :o ... I thought our convention was functions only?" Convention historically is function-only test files.
**Sources:** [@MickaelBergem PR#78216](https://github.com/alan-eu/alan-apps/pull/78216#discussion_r2736727990)
**Trigger:** `backend/components/**/tests/**`
**Severity:** P3

### Test the actual implementation, don't test only your own diff
**Why:** "Hmmm so you aren't testing the actual implementation? 🤔" — when the calling function changes, ensure the integration is covered.
**Sources:** [@MickaelBergem PR#78216](https://github.com/alan-eu/alan-apps/pull/78216#discussion_r2736738331)
**Trigger:** `backend/components/**/tests/**`
**Severity:** P2

### Don't write tests on logger output — they are painful to maintain
**Why:** "Not sure it's worth testing (maintaining tests over loggers is painful from experience)."
**Sources:** [@MickaelBergem PR#78216](https://github.com/alan-eu/alan-apps/pull/78216#discussion_r2736740819)
**Trigger:** `**/tests/**`
**Severity:** P3

### Use existing pytest fixtures for Slack, mailers, etc. — don't patch yourself
**Why:** "There is an existing Slack pytest fixture I believe (something we wrote), so that you don't have to do this patch yourself."
**Sources:** [@MickaelBergem PR#79017](https://github.com/alan-eu/alan-apps/pull/79017#discussion_r2769164922)
**Trigger:** `backend/components/**/tests/**`
**Severity:** P3

### Test against real component APIs (e.g. `affiliate_member()`) instead of crafting raw DB state
**Why:** "I wonder if calling the other component's API directly wouldn't be more robust."
**Sources:** [@MickaelBergem PR#78216](https://github.com/alan-eu/alan-apps/pull/78216#discussion_r2736732415)
**Trigger:** `backend/components/**/tests/**`
**Severity:** P3

### Tests are optional for internal tools, but must cover externally-facing features
**Why:** "For internal tools I find it acceptable to not write tests... For external-facing features I'm more nuanced: if it's easy to test then let's cover the main cases." Critical user-facing features deserve full coverage; internal tools can ship without tests.
**Sources:** [@MickaelBergem PR#87394](https://github.com/alan-eu/alan-apps/pull/87394#discussion_r3056890318)
**Trigger:** `*`
**Severity:** P3

### Test boundary cases (cross-period, cross-year) when behavior depends on dates
**Why:** "Can you test the case where the three days are across a billing frontier (eg 2 days in 2025 and 2 days in 2026, or cross-quarter)?"
**Sources:** [@MickaelBergem PR#78377](https://github.com/alan-eu/alan-apps/pull/78377#pullrequestreview-3722654670)
**Trigger:** `backend/components/**/tests/**`
**Severity:** P2

---

## Naming & conventions

### Avoid acronyms like `oh`, `OH`, `nic` (when ambiguous) — readability wins
**Why:** "In the code, we prefer avoiding acronyms like `oh` that aren't easy to understand for the majority of engineers. `occupational_health` is longer but with modern tools it's easy enough to type/autocomplete."
**Sources:** [@MickaelBergem PR#77207](https://github.com/alan-eu/alan-apps/pull/77207#discussion_r2709111317), [@MickaelBergem PR#82540](https://github.com/alan-eu/alan-apps/pull/82540#discussion_r2882985191), [@MickaelBergem PR#88526](https://github.com/alan-eu/alan-apps/pull/88526#discussion_r3094815557)
**Trigger:** `*`
**Severity:** P3

### Avoid single-letter / 1-2-letter variable names (`e`, `n`, `v`)
**Why:** "I tend to dislike single-char variable names, with modern IDEs it's practically identical to expand to `error`... Single-letters are harder to read and aren't much easier to type."
**Sources:** [@MickaelBergem PR#76898](https://github.com/alan-eu/alan-apps/pull/76898#discussion_r2698130242), [@MickaelBergem PR#79017](https://github.com/alan-eu/alan-apps/pull/79017#discussion_r2769148471), [@MickaelBergem PR#80304](https://github.com/alan-eu/alan-apps/pull/80304#discussion_r2804192048), [@MickaelBergem PR#82395](https://github.com/alan-eu/alan-apps/pull/82395#discussion_r2865362907), [@MickaelBergem PR#86540](https://github.com/alan-eu/alan-apps/pull/86540#discussion_r3022285745), [@MickaelBergem PR#87848](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3079148742)
**Trigger:** `*`
**Severity:** P3

### URLs use underscores, not dashes
**Why:** "I think the convention is to use underscores in URL." / "Convention is to use underscores in URL, not dashes."
**Sources:** [@MickaelBergem PR#82345](https://github.com/alan-eu/alan-apps/pull/82345#discussion_r2863554366), [@MickaelBergem PR#87071](https://github.com/alan-eu/alan-apps/pull/87071#discussion_r3043421453), [@MickaelBergem PR#87079](https://github.com/alan-eu/alan-apps/pull/87079#discussion_r3043592561), [@MickaelBergem PR#88526](https://github.com/alan-eu/alan-apps/pull/88526#discussion_r3094846398)
**Trigger:** `backend/components/**/controllers/**`, `frontend/**/use*Mutation.ts`, `frontend/**/use*Query.ts`
**Severity:** P3

### Name amounts with their unit (`amount_in_cents`, `amount_in_euros`)
**Why:** "I prefer to always name my amounts `amount_in_cents` as _explicit is better than implicit_."
**Sources:** [@MickaelBergem PR#85787](https://github.com/alan-eu/alan-apps/pull/85787#discussion_r2976230273)
**Trigger:** `backend/components/**`, `frontend/**`
**Severity:** P2

### Use existing taxonomies (e.g. "resumption" not "cancel termination", "subscriber" not "customer")
**Why:** "'cancel the termination' is better known (at least in the Employment taxonomy) as a 'resumption'." / "Prévenir doesn't have 'customers', it has 'subscribers'."
**Sources:** [@MickaelBergem PR#79191](https://github.com/alan-eu/alan-apps/pull/79191#discussion_r2770062121), [@MickaelBergem PR#87848](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3079152185)
**Trigger:** `*`
**Severity:** P2

### Match existing factory terminology: `build` = in-memory, `create` = persisted
**Why:** "I tend to align with the existing factory terminology (build = build the entity in memory / create = build and persist it to the DB)."
**Sources:** [@MickaelBergem PR#78216](https://github.com/alan-eu/alan-apps/pull/78216#discussion_r2736711715)
**Trigger:** `backend/components/**/tests/**`
**Severity:** P3

### Use "ignore" for read-only filtering and "skip" for actions
**Why:** "I tend to understand 'skip' as meaning some entries will not be 'processed' (they are skipped), implying some _action_. Here I would have chosen 'ignore' since we're just _reading_ data."
**Sources:** [@MickaelBergem PR#81796](https://github.com/alan-eu/alan-apps/pull/81796#discussion_r2865199208)
**Trigger:** `*`
**Severity:** P3

---

## Python typing

### Use typed IDs (`UserId`, `AccountId`, `ProfileId`, `CompanyId`) instead of `str`/`int`/`UUID`
**Why:** "Why a `str` and not `ProfileId`?" / "Why don't you directly declare `row.account_id` as an `AccountId` type? You wouldn't have to convert it to a str."
**Sources:** [@MickaelBergem PR#76918](https://github.com/alan-eu/alan-apps/pull/76918#discussion_r2697782177), [@MickaelBergem PR#77841](https://github.com/alan-eu/alan-apps/pull/77841#discussion_r2727192293), [@MickaelBergem PR#78216](https://github.com/alan-eu/alan-apps/pull/78216#discussion_r2736780160), [@MickaelBergem PR#78247](https://github.com/alan-eu/alan-apps/pull/78247#discussion_r2736799258), [@MickaelBergem PR#87071](https://github.com/alan-eu/alan-apps/pull/87071#discussion_r3043434273), [@MickaelBergem PR#87848](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3079185649), [@MickaelBergem PR#88526](https://github.com/alan-eu/alan-apps/pull/88526#discussion_r3094837977)
**Trigger:** `backend/components/**`
**Severity:** P2

### Use enums, not raw strings, for finite-set fields (statuses, gender, kinds)
**Why:** "Should this be an enum somehow to enforce we don't get other values?" / "Let's use an enum here." / "If 'profile gender' is an enum, let's use the enum directly instead of the `'male'` and `'female'` strings."
**Sources:** [@MickaelBergem PR#82985](https://github.com/alan-eu/alan-apps/pull/82985#discussion_r2889360164), [@MickaelBergem PR#87848](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3072102419), [@MickaelBergem PR#87917](https://github.com/alan-eu/alan-apps/pull/87917#discussion_r3079810591)
**Trigger:** `backend/components/**`
**Severity:** P2

### Prefer dataclasses (or TypedDict) over plain dicts for structured data
**Why:** "Should we use a TypedDict if they keys are always there? Or even better, a dedicated dataclass?" / "Let's use a dataclass instead of a dict. It'll make many things easier: accessing fields, typing, ensuring you don't mistype the field name."
**Sources:** [@MickaelBergem PR#77841](https://github.com/alan-eu/alan-apps/pull/77841#discussion_r2727198845), [@MickaelBergem PR#87848](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3072094370)
**Trigger:** `backend/components/**`
**Severity:** P2

### Use `date` vs `datetime` accurately (no time → `date`)
**Why:** "If this includes a time, it should be `datetime` (if not then `date` is correct)."
**Sources:** [@MickaelBergem PR#87848](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3079183621)
**Trigger:** `backend/components/**`
**Severity:** P3

### Avoid `Any` in return types — make returned shape explicit
**Why:** "Making the return type more explicit, at least by removing the `Any`."
**Sources:** [@MickaelBergem PR#87848](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3072059294)
**Trigger:** `backend/components/**`
**Severity:** P3

### Allow only `None` OR `undefined` for optional values, not both
**Why:** "So `initialTarget` can be `InitialTarget`, `null`, or `undefined`. Can we only allow one of `undefined` or `null`?"
**Sources:** [@MickaelBergem PR#75542](https://github.com/alan-eu/alan-apps/pull/75542#discussion_r2653319846)
**Trigger:** `frontend/**/*.tsx`, `frontend/**/*.ts`
**Severity:** P3

### Don't pretend an empty string is a valid ID — use `mandatory()` or `None`
**Why:** "But never pass an empty string pretending it's a user ID."
**Sources:** [@MickaelBergem PR#80304](https://github.com/alan-eu/alan-apps/pull/80304#discussion_r2804147040)
**Trigger:** `backend/**`
**Severity:** P1

---

## Alan-specific patterns

### Use `mapped_column_with_privacy` + `PrivacyProperties` for sensitive fields (PII, emails)
**Why:** "Since these contain emails, we'll need to anonymize them when exporting the data (eg to Turing/Metabase)."
**Sources:** [@MickaelBergem PR#77905](https://github.com/alan-eu/alan-apps/pull/77905#discussion_r2727230518), [@MickaelBergem PR#76897](https://github.com/alan-eu/alan-apps/pull/76897#discussion_r2698147433)
**Trigger:** `backend/components/**/models/**`
**Severity:** P1

### Use `AlanBaseEnumTypeDecorator` (with `.create_validator()`) for enum columns
**Why:** "Please use an enum — see `AlanBaseEnumTypeDecorator` (and the mandatory `.create_validator()` that comes with it) for how to make it happen."
**Sources:** [@MickaelBergem PR#87917](https://github.com/alan-eu/alan-apps/pull/87917#discussion_r3079810591)
**Trigger:** `backend/components/**/models/**`
**Severity:** P2

### Add `validates_siret` / `validates_siren` validators on those fields
**Why:** "Please add a `validates_siret` to ensure we always store valid SIRETs."
**Sources:** [@MickaelBergem PR#87917](https://github.com/alan-eu/alan-apps/pull/87917#discussion_r3079818812)
**Trigger:** `backend/components/**/models/**`
**Severity:** P2

### Use DB constraints + DB-level uniqueness — design data model to prevent invalid states
**Why:** "We definitely should have done that from the data model design stage... but we should use DB constraints all the time." / "Why not `one_or_none()` since we have a DB constraint? At least if the assumption breaks it will raise an exception."
**Sources:** [@MickaelBergem PR#87958](https://github.com/alan-eu/alan-apps/pull/87958#pullrequestreview-4098609855), [@MickaelBergem PR#76918](https://github.com/alan-eu/alan-apps/pull/76918#discussion_r2697796205), [@MickaelBergem PR#80304](https://github.com/alan-eu/alan-apps/pull/80304#discussion_r2804168319)
**Trigger:** `backend/components/**/models/**`
**Severity:** P1

### Make columns non-nullable by default, document why if nullable
**Why:** "What would it mean to have an EmploymentData without a profile? Unless there is a good reason I would make it non-nullable." / "Should we instead have a default to an empty list and have `nullable=False`?"
**Sources:** [@MickaelBergem PR#76897](https://github.com/alan-eu/alan-apps/pull/76897#discussion_r2698152227), [@MickaelBergem PR#77905](https://github.com/alan-eu/alan-apps/pull/77905#discussion_r2727232214), [@MickaelBergem PR#88378](https://github.com/alan-eu/alan-apps/pull/88378#discussion_r3091346901)
**Trigger:** `backend/components/**/models/**`
**Severity:** P2

### Document data-model assumptions in the `doc=` argument and module docstring
**Why:** "I like documenting the assumption made when designing the data model directly in the code." / "Let's also document what happens if the company needs an installment plan for only some years."
**Sources:** [@MickaelBergem PR#76897](https://github.com/alan-eu/alan-apps/pull/76897#discussion_r2698162977), [@MickaelBergem PR#77593](https://github.com/alan-eu/alan-apps/pull/77593#discussion_r2716864438), [@MickaelBergem PR#80304](https://github.com/alan-eu/alan-apps/pull/80304#discussion_r2804153077)
**Trigger:** `backend/components/**/models/**`
**Severity:** P2

### Avoid `noqa` in new code
**Why:** "Let's avoid adding `noqa`s in new code? 🥺"
**Sources:** [@MickaelBergem PR#76897](https://github.com/alan-eu/alan-apps/pull/76897#discussion_r2698153590)
**Trigger:** `*`
**Severity:** P2

### `@request_argument` is deprecated — use `@use_args` (or `flask_smorest`)
**Why:** "`@request_argument` is deprecated, see eng_announcement."
**Sources:** [@MickaelBergem PR#75378](https://github.com/alan-eu/alan-apps/pull/75378#discussion_r2650491733)
**Trigger:** `backend/components/**/controllers/**`
**Severity:** P2

### Use Marshmallow / smorest schemas to deserialize into dataclasses, not in controller body
**Why:** "Is there a way to directly have Marshmallow deserialize the dict into a Dmst dataclass? Now we are doing it from within the controller body and I feel it's a missed opportunity (also would 500 instead of 400 if the data is invalid)."
**Sources:** [@MickaelBergem PR#82410](https://github.com/alan-eu/alan-apps/pull/82410#discussion_r2863539689), [@MickaelBergem PR#85783](https://github.com/alan-eu/alan-apps/pull/85783#discussion_r2976138562)
**Trigger:** `backend/components/**/controllers/**`
**Severity:** P2

### Prefer `aff["personal_email"]` (KeyError on missing) over `aff.get(...)` for required fields
**Why:** "I tend to prefer the `aff['personal_email']` form that will raise if the argument is _missing_, helping spot the issue sooner than later. We still allow `None` values, but not missing ones."
**Sources:** [@MickaelBergem PR#76898](https://github.com/alan-eu/alan-apps/pull/76898#discussion_r2698097699)
**Trigger:** `backend/components/**/controllers/**`
**Severity:** P3

### Always require backend params from frontend rather than defaulting silently
**Why:** "I would prefer we keep the responsibility of sending the value to the frontend (and always require the value). Otherwise it opens the door to a bug the day the frontend fails to send the proper key name."
**Sources:** [@MickaelBergem PR#81796](https://github.com/alan-eu/alan-apps/pull/81796#discussion_r2865203601)
**Trigger:** `backend/components/**/controllers/**`
**Severity:** P2

### Use the Employment Component (extended values, queries) instead of legacy `Employment` model
**Why:** "You should use the Employment Component to query the list of employments, instead of the legacy `Employment` model."
**Sources:** [@MickaelBergem PR#79789](https://github.com/alan-eu/alan-apps/pull/79789#discussion_r2788952992), [@MickaelBergem PR#87848](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3079127375)
**Trigger:** `backend/components/**`
**Severity:** P2

### Use `csv.DictReader` for CSV parsing instead of indexed `fields[2]` access
**Why:** "Can't you use `csv.DictReader` instead? It takes care of everything directly... You can probably pass the list of header fields, which will allow you to use `fields['married_name']` instead of `fields[21]`."
**Sources:** [@MickaelBergem PR#79789](https://github.com/alan-eu/alan-apps/pull/79789#discussion_r2788935976), [@MickaelBergem PR#87848](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3072071193)
**Trigger:** `backend/components/**`
**Severity:** P3

### Use `flush()` not `commit()` to verify DB constraints in commands; rollbacks are automatic
**Why:** "I'd use a `flush` here instead to ensure all DB constraints are enforced. Rollback is supposed to be automatically executed."
**Sources:** [@MickaelBergem PR#75301](https://github.com/alan-eu/alan-apps/pull/75301#discussion_r2650620555)
**Trigger:** `backend/components/**/commands/**`
**Severity:** P3

### Migrations that DELETE production data must be guarded against running in prod
**Why:** "This delete statement is scary, if it doesn't target prod can you add a 'if not is_prod()' guard and not execute the DELETE in prod?"
**Sources:** [@MickaelBergem PR#87958](https://github.com/alan-eu/alan-apps/pull/87958#discussion_r3072905524)
**Trigger:** `backend/apps/**/migrations/**`
**Severity:** P1

### Use shared validators (`SIRET_LENGTH`, `siren_siret_validator`) — don't redefine
**Why:** "You could use `SIRET_LENGTH` from `shared.validators.siren_siret_validator`."
**Sources:** [@MickaelBergem PR#87917](https://github.com/alan-eu/alan-apps/pull/87917#discussion_r3079815863)
**Trigger:** `backend/**`
**Severity:** P3

---

## Performance & DB

### Watch for N+1 queries — preload relationships, batch lookups
**Why:** "It really smells like N+1 queries... However you should really use the employment component instead of this, it's more future proof." / "This looks very inefficient 🤔 (N+1 query)."
**Sources:** [@MickaelBergem PR#79789](https://github.com/alan-eu/alan-apps/pull/79789#discussion_r2788952992), [@MickaelBergem PR#83352](https://github.com/alan-eu/alan-apps/pull/83352#discussion_r2894753035)
**Trigger:** `backend/components/**`
**Severity:** P2

### Only load needed columns when querying for one field
**Why:** "If it'll be called often we could also speed things up by only reading the SIREN field from Company."
**Sources:** [@MickaelBergem PR#86369](https://github.com/alan-eu/alan-apps/pull/86369#discussion_r3022230927)
**Trigger:** `backend/components/**`
**Severity:** P3

### Use read-only sessions where it makes sense
**Why:** "Can't we keep the read-only session everywhere where it makes sense?"
**Sources:** [@MickaelBergem PR#82822](https://github.com/alan-eu/alan-apps/pull/82822#pullrequestreview-3881137696)
**Trigger:** `backend/components/**`
**Severity:** P3

---

## Error handling & defensive code

### Distinguish "expected" errors (400 + body) from "unexpected" ones (500 + Sentry)
**Why:** "So we never send anything to Sentry if something breaks? Ideally you should make the difference between 'expected' errors (leading to a 400) and 'unexpected' ones (500 + log to Sentry, which you can do by just not catching them)."
**Sources:** [@MickaelBergem PR#79789](https://github.com/alan-eu/alan-apps/pull/79789#discussion_r2788901817)
**Trigger:** `backend/components/**/controllers/**`
**Severity:** P2

### Don't silently swallow errors — log a warning or `current_logger.exception(...)`
**Why:** "Let's never silently ignore errors without explaining why... I would either completely crash the execution, or at least `current_logger.exception(...)` so that we have a stacktrace sent to Sentry." Prefer `.exception()` over `.warning()` when you want Sentry surfacing.
**Sources:** [@MickaelBergem PR#87848](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3072082603), [@MickaelBergem PR#87071](https://github.com/alan-eu/alan-apps/pull/87071#discussion_r3043452999)
**Trigger:** `backend/components/**`
**Severity:** P2

### Avoid catchall `except Exception` blocks; let exceptions bubble up
**Why:** "Removing this catchall `except` block, because there is already a large except in the called function over most of the business logic code." / "nit: Exception is too broad."
**Sources:** [@MickaelBergem PR#76473](https://github.com/alan-eu/alan-apps/pull/76473#discussion_r2683313362), [@MickaelBergem PR#78187](https://github.com/alan-eu/alan-apps/pull/78187#discussion_r2753330907)
**Trigger:** `backend/components/**`
**Severity:** P2

### Avoid `assert` outside of tests — raise explicit exceptions or use `mandatory()`
**Why:** "We should also try avoiding `assert` outside of tests. Either raise an explicit exception, or assume it's good (`mandatory(event_bus)` can be your friend if `mypy` is complaining)."
**Sources:** [@MickaelBergem PR#79017](https://github.com/alan-eu/alan-apps/pull/79017#discussion_r2769175578)
**Trigger:** `backend/**` (excluding tests)
**Severity:** P2

### "Fail loudly" preference: prefer raising over half-completing operations
**Why:** "By allowing to continue, we take the risk of having half-affiliated subscribers :/" — favors raising on inconsistencies. Mickaël notes he leans this way; explicit acceptance of `fail-silent` is OK if justified.
**Sources:** [@MickaelBergem PR#76898 (1)](https://github.com/alan-eu/alan-apps/pull/76898#discussion_r2698107083), [@MickaelBergem PR#76898 (2)](https://github.com/alan-eu/alan-apps/pull/76898#discussion_r2698178937)
**Trigger:** `backend/components/**`
**Severity:** P2

### Make error messages actionable for Ops (mention what to do, who to ping)
**Why:** "I'm afraid this will be hard to debug (for you and for Ops), if there is an easy way to tweak the error message to make it more actionable it would be super helpful." Include tooltips/explanations on disabled buttons too.
**Sources:** [@MickaelBergem PR#82345](https://github.com/alan-eu/alan-apps/pull/82345#discussion_r2863587869), [@MickaelBergem PR#79191](https://github.com/alan-eu/alan-apps/pull/79191#discussion_r2770104773), [@MickaelBergem PR#82922](https://github.com/alan-eu/alan-apps/pull/82922#discussion_r2882614172)
**Trigger:** `backend/**`, `frontend/**`
**Severity:** P3

---

## Frontend / React

### Use the `isLoading` from the mutation/query, don't track loading manually
**Why:** "I don't understand why you are not using the isLoading from the mutation 🤔"
**Sources:** [@MickaelBergem PR#79789](https://github.com/alan-eu/alan-apps/pull/79789#discussion_r2788990474)
**Trigger:** `frontend/**/*.tsx`
**Severity:** P3

### Display API errors in the UI when actionable for end users
**Why:** "Why don't you display the error here? Some errors are easy to fix directly by Ops..."
**Sources:** [@MickaelBergem PR#79789](https://github.com/alan-eu/alan-apps/pull/79789#discussion_r2788992237)
**Trigger:** `frontend/**/*.tsx`
**Severity:** P2

### Show success feedback (toaster, Mantine notification) on mutations
**Why:** "Can we add a Mantine notification when the update is successful? Here there is no visual feedback so we don't know if it really worked or not." / "I would use a toaster instead so that the user can read the notification."
**Sources:** [@MickaelBergem PR#77977](https://github.com/alan-eu/alan-apps/pull/77977#issuecomment-3800894123), [@MickaelBergem PR#87079](https://github.com/alan-eu/alan-apps/pull/87079#discussion_r3043590640)
**Trigger:** `frontend/**/*.tsx`
**Severity:** P2

### Add Amplitude tracking on user actions (clicks, suggestion picks, resets)
**Why:** "Can you add tracking so that we get events in Amplitude when such a suggestion is clicked?"
**Sources:** [@MickaelBergem PR#86540](https://github.com/alan-eu/alan-apps/pull/86540#discussion_r3022298964), [@MickaelBergem PR#86540](https://github.com/alan-eu/alan-apps/pull/86540#discussion_r3022300474), [@MickaelBergem PR#82439](https://github.com/alan-eu/alan-apps/pull/82439#pullrequestreview-3888467838)
**Trigger:** `frontend/**/*.tsx`
**Severity:** P3

### Add TSDoc docstrings above React components
**Why:** "I tend to add docstrings (`/*** .. **/`) above such components to explain quickly what the component does. It helps other engineers discovering the component."
**Sources:** [@MickaelBergem PR#86540](https://github.com/alan-eu/alan-apps/pull/86540#discussion_r3022268047), [@MickaelBergem PR#79789](https://github.com/alan-eu/alan-apps/pull/79789#discussion_r2788982130)
**Trigger:** `frontend/**/*.tsx`
**Severity:** P3

### Use CSS for visual concerns (truncation, ellipsis) instead of JS string manipulation
**Why:** "Just do it with CSS ;) [text-overflow]."
**Sources:** [@MickaelBergem PR#76916](https://github.com/alan-eu/alan-apps/pull/76916#discussion_r2695042514)
**Trigger:** `frontend/**/*.tsx`
**Severity:** P3

### Use the typed `UUID` for IDs in TS, not bare strings
**Why:** "I'd prefer using a string for the `user_id` as it's what we're doing across all of Occupational Health + I'm always scared of what JS will do with number-indexed arrays." Use `UUID` type alias when applicable.
**Sources:** [@MickaelBergem PR#79789](https://github.com/alan-eu/alan-apps/pull/79789#discussion_r2788986911), [@MickaelBergem PR#77983](https://github.com/alan-eu/alan-apps/pull/77983#discussion_r2728631706)
**Trigger:** `frontend/**/*.tsx`, `frontend/**/*.ts`
**Severity:** P3

### Use existing currency/date helpers, not raw `* 100` math
**Why:** "There are already helpers to manipulate currency like this, please use them directly." / "I just checked and `// 4` is not safe if `amount` is a `float`."
**Sources:** [@MickaelBergem PR#82508](https://github.com/alan-eu/alan-apps/pull/82508#discussion_r2865265950), [@MickaelBergem PR#85787](https://github.com/alan-eu/alan-apps/pull/85787#discussion_r2976230273)
**Trigger:** `frontend/**`, `backend/**`
**Severity:** P2

### Translate all strings: French admin dashboards still need English translations
**Why:** "We might have English-speaking admins in the FR admin dashboard 👉 let's make sure we translate all strings."
**Sources:** [@MickaelBergem PR#86540](https://github.com/alan-eu/alan-apps/pull/86540#discussion_r3022252672)
**Trigger:** `frontend/apps/fr-app/**/*.tsx`
**Severity:** P2

### Don't store derived state in React state — pass it directly
**Why:** "Why can't you just pass this value directly to `<RecordPaymentModal>` on L175? I don't see the point of storing it in the react state 🤔"
**Sources:** [@MickaelBergem PR#82508](https://github.com/alan-eu/alan-apps/pull/82508#discussion_r2865263116)
**Trigger:** `frontend/**/*.tsx`
**Severity:** P3

---

## Readability & simplicity

### Deduplicate `if/else` branches that share assignment lines
**Why:** "I prefer the opposite form... This way we deduplicate the code setting the value (reduced risk of bug if we update the code one day and forget to update the other branch)."
**Sources:** [@MickaelBergem PR#76898](https://github.com/alan-eu/alan-apps/pull/76898#discussion_r2698120006)
**Trigger:** `*`
**Severity:** P3

### Don't add comments that restate what the code does
**Why:** "This comment will not be interesting for future engineers reading the code." Add comments only when they convey *why* — not *what*.
**Sources:** [@MickaelBergem PR#87071](https://github.com/alan-eu/alan-apps/pull/87071#discussion_r3043448505)
**Trigger:** `*`
**Severity:** P3

### Document non-obvious code with a comment explaining the *why*
**Why:** "Worth a comment then." / "Can you add a comment in the code explaining why we need a timeout (and why 200ms)?" / "In those cases it's worth adding a comment to explain why it's needed."
**Sources:** [@MickaelBergem PR#77841](https://github.com/alan-eu/alan-apps/pull/77841#discussion_r2727266020), [@MickaelBergem PR#87355](https://github.com/alan-eu/alan-apps/pull/87355#discussion_r3050030854), [@MickaelBergem PR#87918](https://github.com/alan-eu/alan-apps/pull/87918#discussion_r3086668373)
**Trigger:** `*`
**Severity:** P3

### Don't leave commented-out code or dead branches
**Why:** "Just seeing the commented out code, can we remove it? 🤔"
**Sources:** [@MickaelBergem PR#77983](https://github.com/alan-eu/alan-apps/pull/77983#discussion_r2728638645)
**Trigger:** `*`
**Severity:** P3

### Add timed `TODO @user YYYY-MM-DD` reminders for temporary code
**Why:** "Add a TODO with a reminder in the code `# TODO: @david.barthelemy 2026-09-01 let's remove this now!` so that you at least get pinged by Beaver in the future about it."
**Sources:** [@MickaelBergem PR#79789](https://github.com/alan-eu/alan-apps/pull/79789#discussion_r2788931209), [@MickaelBergem PR#78187](https://github.com/alan-eu/alan-apps/pull/78187#discussion_r2753342978)
**Trigger:** `backend/**`
**Severity:** P3

### Empty list `[]` is preferable to `None` when no semantic difference
**Why:** "Should it just always be an empty list instead of None? I think we can simplify the interface as there is no semantic difference between `[]` and `None`."
**Sources:** [@MickaelBergem PR#83352](https://github.com/alan-eu/alan-apps/pull/83352#discussion_r2894711925)
**Trigger:** `backend/**`, `frontend/**`
**Severity:** P3

### Boolean parameters should be keyword-only or named clearly (`only_cancelled=True`)
**Why:** "I would have preferred to have a `only_cancelled=True` — much simpler and leaner."
**Sources:** [@MickaelBergem PR#83352](https://github.com/alan-eu/alan-apps/pull/83352#discussion_r2894718237)
**Trigger:** `backend/components/**`
**Severity:** P3

### Use `kwargs` (`extra={}`) for structured logging context, not f-string concat
**Why:** "Other option: use `extra={ the dict here }`."
**Sources:** [@MickaelBergem PR#76711](https://github.com/alan-eu/alan-apps/pull/76711#pullrequestreview-3660555279)
**Trigger:** `backend/**`
**Severity:** P3

---

## Security & privacy

### Don't send PII (emails, names) to Datadog logs
**Why:** "If we think about GDPR, we have no need to 'store' them in datadog. Better safe than sorry."
**Sources:** [@bastien-landre-alan PR#88451](https://github.com/alan-eu/alan-apps/pull/88451#pullrequestreview-4127355310), [@bastien-landre-alan PR#88451](https://github.com/alan-eu/alan-apps/pull/88451#discussion_r3091300378)
**Trigger:** `backend/**`
**Severity:** P1

### Don't put unrelated cross-component config in another component's bootstrap
**Why:** "I am concerned by this: we are now executing more 3rd-party libraries and writing to a GSheet from the medical secrecy component, for a purpose unrelated to `medical_secrecy`."
**Sources:** [@MickaelBergem PR#81724](https://github.com/alan-eu/alan-apps/pull/81724#discussion_r2842488990)
**Trigger:** `backend/apps/**/config/**`, `backend/components/**/bootstrap/**`
**Severity:** P2

### Block dangerous frontend actions on undo windows; otherwise commit + cancel button
**Why:** "If the user closes the browser during the 5s undo window, the action is lost — this is not OK: we should either block closing the window, or commit first and implement a cancel button, or just drop the idea."
**Sources:** [@MickaelBergem PR#88610](https://github.com/alan-eu/alan-apps/pull/88610#issuecomment-)
**Trigger:** `frontend/**/*.tsx`
**Severity:** P2

---

## Process & PR hygiene

### Resolve closed review threads + re-request review when ready
**Why:** "'resolve the conversation' for the threads where the discussion is closed (eg reviewer asked for something, you implemented it)... re-request review once the PR is ready to be reviewed again."
**Sources:** [@MickaelBergem PR#87848](https://github.com/alan-eu/alan-apps/pull/87848#issuecomment-4243157875)
**Trigger:** `*`
**Severity:** P3

### Share screenshots/videos for any UI/UX change
**Why:** "For frontend work, we usually welcome screenshots or videos so that reviewers can see what this is about." / "When changing display, it's nice to add a 'before'/'after' screenshot."
**Sources:** [@MickaelBergem PR#87918](https://github.com/alan-eu/alan-apps/pull/87918#issuecomment-4244316161), [@bastien-landre-alan PR#84904](https://github.com/alan-eu/alan-apps/pull/84904#pullrequestreview-3965832407), [@MickaelBergem PR#87443](https://github.com/alan-eu/alan-apps/pull/87443#discussion_r3057218440)
**Trigger:** `frontend/**`
**Severity:** P3

### Fill out the PR description — don't leave it empty
**Why:** "@lmbonnefont the PR description is empty, can you fill it out?"
**Sources:** [@MickaelBergem PR#81376](https://github.com/alan-eu/alan-apps/pull/81376#issuecomment-3945216608)
**Trigger:** `*`
**Severity:** P3

### Self-review AI-generated PRs before requesting human review
**Why:** "Looks good but the code looks AI-generated and there were many small things you could have caught yourself before review ;)"
**Sources:** [@MickaelBergem PR#87071](https://github.com/alan-eu/alan-apps/pull/87071#pullrequestreview-4066360526)
**Trigger:** `*`
**Severity:** P2

### Test risky changes in shared `Kay` (or acceptance) before deploying
**Why:** "Hmm I would prefer if we could test first. Can you test with this spreadsheet against Kay?" / "I would feel more confident if we did heavy testing before releasing this."
**Sources:** [@MickaelBergem PR#79735](https://github.com/alan-eu/alan-apps/pull/79735#pullrequestreview-3778006789), [@MickaelBergem PR#79511](https://github.com/alan-eu/alan-apps/pull/79511#pullrequestreview-3790148599)
**Trigger:** `*`
**Severity:** P2
