# Raw review comments

- Generated: 2026-04-28
- Cutoff: 2025-12-27 (rolling 4 months)
- Repo: alan-eu/alan-apps
- Authors: @MickaelBergem, @bastien-landre-alan
- PRs inspected: 327

---

## PR #75203 — feat(occupational_health): build Affiliator v1

_2025-12-23 • https://github.com/alan-eu/alan-apps/pull/75203_

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/affiliation_tool.py:17` (2026-01-05)
> Thanks for the context!

[link](https://github.com/alan-eu/alan-apps/pull/75203#discussion_r2661891094)

---

## PR #75301 — [Medical Secrecy] Add command to import Thesaurus Mean

_2025-12-29 • https://github.com/alan-eu/alan-apps/pull/75301_

### @MickaelBergem — review summary (APPROVED, 2025-12-29)
> Good 👌 
> 
> Should running this command be part of the onboarding for engineers?

[link](https://github.com/alan-eu/alan-apps/pull/75301#pullrequestreview-3615508417)

### @MickaelBergem on `backend/components/occupational_health/internal/commands/import_thesaurus_means.py:72` (2025-12-29)
> nit: I'd use a `flush` here instead to ensure all DB constraints are enforced. Rollback is supposed to be automatically executed.

[link](https://github.com/alan-eu/alan-apps/pull/75301#discussion_r2650620555)

---

## PR #75378 — fix(occupational_health): port controllers to @use_args pattern

_2025-12-29 • https://github.com/alan-eu/alan-apps/pull/75378_

### @MickaelBergem on `backend/components/fr/internal/marmot/controllers/occupational_health/affiliated_members.py:38` (2025-12-29)
> `@request_argument` is deprecated, [see eng_announcement](https://alanhealth.slack.com/archives/CB55CK36Y/p1764674557022119) ;)

[link](https://github.com/alan-eu/alan-apps/pull/75378#discussion_r2650491733)

### @MickaelBergem — issue comment (2025-12-27)
> This change is part of the following stack:
> 
> - #75378 ◀
>     - #75379
>         - #75381
>             - #75382
> 
> <sub>Change managed by [git-spice](https://abhinav.github.io/git-spice/).</sub>
> <!-- gs:navigation comment -->
> 

[link](https://github.com/alan-eu/alan-apps/pull/75378#issuecomment-3693972198)

### @MickaelBergem — issue comment (2025-12-29)
> > I think we should align on how to write Controllers. Schema are great but we are using use_args here and `@medical_app_endpoint.arguments` in other part of medical_secrecy
> 
> Good point, we're using `flask_smorest` already on the `medical_secrecy` side, but aren't yet on the `fr_api` side. Is the long-term vision is to switch to `flask_smorest` for `fr_api` and co. @vrialland ?

[link](https://github.com/alan-eu/alan-apps/pull/75378#issuecomment-3695888388)

---

## PR #75379 — feat(occupational_health): enable Ops to edit strategy rules

_2025-12-29 • https://github.com/alan-eu/alan-apps/pull/75379_

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/affiliationStrategy/index.tsx:516` (2025-12-29)
> Cursor didn't use one and I was too lazy to change it 🤷 

[link](https://github.com/alan-eu/alan-apps/pull/75379#discussion_r2650520064)

### @MickaelBergem — issue comment (2025-12-27)
> This change is part of the following stack:
> 
> - #75378
>     - #75379 ◀
>         - #75381
>             - #75382
> 
> <sub>Change managed by [git-spice](https://abhinav.github.io/git-spice/).</sub>
> <!-- gs:navigation comment -->
> 

[link](https://github.com/alan-eu/alan-apps/pull/75379#issuecomment-3693972199)

---

## PR #75381 — enh(employment): support get_employment_values_batch_on

_2025-12-29 • https://github.com/alan-eu/alan-apps/pull/75381_

### @MickaelBergem on `backend/components/employment/public/business_logic/queries/extended_employment_update.py:14` (2025-12-29)
> Excellent question, I think it's never been really decided and enforced, for now it's more "best practice" but still causing confusion :(
> 
> We should limit the top-level imports in controllers (as they get imported at boot time), but for public interfaces it should be fine indeed, I'll fix.

[link](https://github.com/alan-eu/alan-apps/pull/75381#discussion_r2650496844)

### @MickaelBergem — issue comment (2025-12-28)
> This change is part of the following stack:
> 
> - #75378
>     - #75379
>         - #75381 ◀
>             - #75382
> 
> <sub>Change managed by [git-spice](https://abhinav.github.io/git-spice/).</sub>
> <!-- gs:navigation comment -->
> 

[link](https://github.com/alan-eu/alan-apps/pull/75381#issuecomment-3694956670)

### @MickaelBergem — issue comment (2025-12-29)
> > In order to avoid the duplication, how about having `get_extended_employment_values_on` call your new function and get the extended values from there? (it would also magically get the new function tested ✨ )
> 
> Excellent idea, I love free tests 🤩 

[link](https://github.com/alan-eu/alan-apps/pull/75381#issuecomment-3695903367)

---

## PR #75382 — feat(occupational_health): support easy creation of SIRET rules

_2025-12-29 • https://github.com/alan-eu/alan-apps/pull/75382_

### @MickaelBergem on `backend/components/occupational_health/public/marmot/queries.py:550` (2025-12-29)
> Hmm interesting, yes! I'll try it.

[link](https://github.com/alan-eu/alan-apps/pull/75382#discussion_r2650675432)

### @MickaelBergem on `backend/components/occupational_health/public/marmot/queries.py:550` (2025-12-29)
> I'll also hide the user_id conversion layer in a helper

[link](https://github.com/alan-eu/alan-apps/pull/75382#discussion_r2650687675)

### @MickaelBergem on `backend/components/occupational_health/public/marmot/queries.py:550` (2025-12-29)
> Given the scope of the change to introduce explicit typing, I'll open a dedicated PR.

[link](https://github.com/alan-eu/alan-apps/pull/75382#discussion_r2650764846)

### @MickaelBergem on `backend/components/occupational_health/public/marmot/queries.py:575` (2025-12-29)
> I think I'll just burn this, Cursor was being too cautious.

[link](https://github.com/alan-eu/alan-apps/pull/75382#discussion_r2650765608)

### @MickaelBergem on `backend/components/occupational_health/public/marmot/queries.py:575` (2025-12-29)
> Actually I'll keep but I'll raise an exception, better safe than sorry.

[link](https://github.com/alan-eu/alan-apps/pull/75382#discussion_r2650767691)

### @MickaelBergem on `backend/components/occupational_health/public/marmot/queries.py:586` (2025-12-29)
> I've ensured that `nic_per_employment_id` always return all employment IDs it's given (will return `None`) so it's equivalent.

[link](https://github.com/alan-eu/alan-apps/pull/75382#discussion_r2650768980)

### @MickaelBergem on `backend/components/occupational_health/public/marmot/queries.py:589` (2025-12-29)
> Same here, the dict will hold `None` already

[link](https://github.com/alan-eu/alan-apps/pull/75382#discussion_r2650769580)

### @MickaelBergem on `backend/components/occupational_health/public/marmot/queries.py:631` (2025-12-29)
> same but fixed in case of `siret` values being `None`

[link](https://github.com/alan-eu/alan-apps/pull/75382#discussion_r2650787017)

### @MickaelBergem on `backend/components/occupational_health/public/marmot/queries.py:594` (2025-12-29)
> same here

[link](https://github.com/alan-eu/alan-apps/pull/75382#discussion_r2650793440)

### @MickaelBergem on `backend/components/occupational_health/public/marmot/queries.py:550` (2025-12-29)
> https://github.com/alan-eu/alan-apps/pull/75423

[link](https://github.com/alan-eu/alan-apps/pull/75382#discussion_r2651127397)

### @MickaelBergem — issue comment (2025-12-28)
> This change is part of the following stack:
> 
> - #75378
>     - #75379
>         - #75382 ◀
>             - #75423
> 
> <sub>Change managed by [git-spice](https://abhinav.github.io/git-spice/).</sub>
> <!-- gs:navigation comment -->
> 

[link](https://github.com/alan-eu/alan-apps/pull/75382#issuecomment-3694963292)

---

## PR #75414 — [Medical secrecy] Remove occupational_health dependency when creating a note

_2026-02-19 • https://github.com/alan-eu/alan-apps/pull/75414_

### @MickaelBergem — review summary (APPROVED, 2025-12-29)
> Aaaah it will cause conflicts with my big type refactoring 😭 
> 
> If you are OK with waiting an extra 24h before merging it I might ask you to rebase and solve the conflicts (or I can take care of it), as it might be much easier to resolve the conflict here than in the other PR I think.

[link](https://github.com/alan-eu/alan-apps/pull/75414#pullrequestreview-3616274044)

---

## PR #75423 — enh(occupational_health): add typing of IDs

_2025-12-29 • https://github.com/alan-eu/alan-apps/pull/75423_

### @MickaelBergem on `backend/components/fr/bootstrap/dependencies/occupational_health.py:43` (2025-12-29)
> Wrapping with the type object doesn't change anything at runtime, and it's more readable than a full `cast()` call.

[link](https://github.com/alan-eu/alan-apps/pull/75423#discussion_r2651401152)

### @MickaelBergem on `backend/components/occupational_health/external/company.py:37` (2025-12-29)
> Sometimes I still accepted extra types to not force typing in low-risk functions (vs the `get_profile` functions or `user_id_mapping` dicts)

[link](https://github.com/alan-eu/alan-apps/pull/75423#discussion_r2651403601)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/admin_dashboard/admin_dashboard.py:334` (2025-12-29)
> New helper that returns the _correct_ mapping

[link](https://github.com/alan-eu/alan-apps/pull/75423#discussion_r2651406702)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/admin_dashboard/admin_dashboard.py:440` (2025-12-29)
> This was incorrect, now fixed (or at least coherent)

[link](https://github.com/alan-eu/alan-apps/pull/75423#discussion_r2651407217)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/customers/get_pretty_company_name.py:23` (2025-12-29)
> Indeed no longer used! You have really good eyes, you're even better than Claude! 

[link](https://github.com/alan-eu/alan-apps/pull/75423#discussion_r2651492128)

### @MickaelBergem — issue comment (2025-12-29)
> This change is part of the following stack:
> 
> - #75378
>     - #75379
>         - #75382
>             - #75423 ◀
> 
> <sub>Change managed by [git-spice](https://abhinav.github.io/git-spice/).</sub>
> <!-- gs:navigation comment -->
> 

[link](https://github.com/alan-eu/alan-apps/pull/75423#issuecomment-3696718720)

---

## PR #75540 — enh: create validates_siren and validates_siret

_2025-12-30 • https://github.com/alan-eu/alan-apps/pull/75540_

### @MickaelBergem on `backend/components/fr/internal/dsn/models/dsn_prevoyance_history.py:118` (2025-12-30)
> Field is not nullable, so even though there was no explicit check against `None` values, add one. The exception will differ and I am making the assumption it won't break anything.

[link](https://github.com/alan-eu/alan-apps/pull/75540#discussion_r2653302639)

### @MickaelBergem on `backend/components/fr/internal/models/company_onboarding_config.py:41` (2025-12-30)
> Same here: non-nullable without any existing check against `None`...

[link](https://github.com/alan-eu/alan-apps/pull/75540#discussion_r2653304552)

### @MickaelBergem — issue comment (2025-12-30)
> This change is part of the following stack:
> 
> - #75539
>     - #75540 ◀
> 
> <sub>Change managed by [git-spice](https://abhinav.github.io/git-spice/).</sub>
> <!-- gs:navigation comment -->
> 

[link](https://github.com/alan-eu/alan-apps/pull/75540#issuecomment-3699782180)

---

## PR #75542 — [Medical secrecy] Add sidemodal to add a workspace action for a member

_2026-01-05 • https://github.com/alan-eu/alan-apps/pull/75542_

### @MickaelBergem on `frontend/apps/medical-software/app/components/TargetSearchField.tsx:26` (2025-12-30)
> Shouldn't it be the responsibility to initialize `value` with an `initialValue`, instead of asking the `TargetSearchField` to do it? I don't know the code so no idea if I'm relevant here or not.

[link](https://github.com/alan-eu/alan-apps/pull/75542#discussion_r2653318185)

### @MickaelBergem on `frontend/apps/medical-software/app/modals/AddWorkspaceActionSidebarModal.tsx:30` (2025-12-30)
> so `initialTarget` can be `InitialTarget`, `null`, or `undefined`. Can we only allow one of `undefined` or `null` by any chance?

[link](https://github.com/alan-eu/alan-apps/pull/75542#discussion_r2653319846)

### @MickaelBergem on `frontend/apps/medical-software/app/modals/AddWorkspaceActionSidebarModal.tsx:45` (2025-12-30)
> Should you also use the same comment / move the comment over all fields? Or does it not apply here

[link](https://github.com/alan-eu/alan-apps/pull/75542#discussion_r2653320561)

### @MickaelBergem on `frontend/apps/medical-software/app/modals/EditWorkspaceActionSidebarModal.tsx:91` (2025-12-30)
> Why is this needed? 🤔 

[link](https://github.com/alan-eu/alan-apps/pull/75542#discussion_r2653321392)

---

## PR #75572 — feat: GLO2-1878 - Add logic to void the personal contribution if the member has a base coverage level

_2026-01-06 • https://github.com/alan-eu/alan-apps/pull/75572_

### @bastien-landre-alan — review summary (COMMENTED, 2025-12-31)
> you don't use coverage_level_voids_personal_contribution yet ? in the personal contribution computation ?

[link](https://github.com/alan-eu/alan-apps/pull/75572#pullrequestreview-3620620809)

### @bastien-landre-alan — issue comment (2025-12-31)
> > No I didn't. I made the choice to not create this property in the health coverage. Indeed, all properties of `HealthCoverage` are stored in DB. This new property would be only computed instead. For that reason, I'm using the coverage level directly here.
> > 
> > I have no strong opinion on this. Let me know if you want me to change it. It's just that it didn't feel that bad using it like that in the frontend too so I left it like that.
> 
> @NaAbAsD are you using severe_illness_voids_personal_contribution for the computation (I don't remember where it's done).
> For me it's ok but maybe it's easier if we use the same thing everywhere (computation and frontend)

[link](https://github.com/alan-eu/alan-apps/pull/75572#issuecomment-3701939815)

---

## PR #75583 — feat(occupational_health): use dynamic list of billing entities

_2025-12-31 • https://github.com/alan-eu/alan-apps/pull/75583_

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/billing/pricing.py:1` (2025-12-31)
> Alaners simplify (was already hardcoded)

[link](https://github.com/alan-eu/alan-apps/pull/75583#discussion_r2655323569)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/billing.py:1` (2025-12-31)
> Moved to other places

[link](https://github.com/alan-eu/alan-apps/pull/75583#discussion_r2655326160)

### @MickaelBergem — issue comment (2025-12-31)
> This change is part of the following stack:
> 
> - #75584
>     - #75585
>         - #75583 ◀
> 
> <sub>Change managed by [git-spice](https://abhinav.github.io/git-spice/).</sub>
> <!-- gs:navigation comment -->
> 

[link](https://github.com/alan-eu/alan-apps/pull/75583#issuecomment-3702097862)

---

## PR #75584 — occupational_health: backfill billed entities

_2025-12-31 • https://github.com/alan-eu/alan-apps/pull/75584_

### @MickaelBergem on `backend/apps/fr_api/migrations/scripts/20251230161311778196_historical_list_of_hardcoded_billed_.py:600` (2025-12-31)
> will fail (non-nullable destination column) if no subscription exists: it's on purpose

[link](https://github.com/alan-eu/alan-apps/pull/75584#discussion_r2655319911)

### @MickaelBergem — issue comment (2025-12-31)
> This change is part of the following stack:
> 
> - #75584 ◀
>     - #75585
>         - #75583
> 
> <sub>Change managed by [git-spice](https://abhinav.github.io/git-spice/).</sub>
> <!-- gs:navigation comment -->
> 

[link](https://github.com/alan-eu/alan-apps/pull/75584#issuecomment-3702097858)

---

## PR #75585 — enh(occupational_health): move conftest higher

_2025-12-31 • https://github.com/alan-eu/alan-apps/pull/75585_

### @bastien-landre-alan — review summary (APPROVED, 2025-12-31)
> LGTM

[link](https://github.com/alan-eu/alan-apps/pull/75585#pullrequestreview-3620889978)

### @MickaelBergem — issue comment (2025-12-31)
> This change is part of the following stack:
> 
> - #75584
>     - #75585 ◀
>         - #75583
> 
> <sub>Change managed by [git-spice](https://abhinav.github.io/git-spice/).</sub>
> <!-- gs:navigation comment -->
> 

[link](https://github.com/alan-eu/alan-apps/pull/75585#issuecomment-3702097865)

---

## PR #75608 — feat: GLO2-1837 - Implement blocked severe illness journal items

_2026-01-08 • https://github.com/alan-eu/alan-apps/pull/75608_

### @bastien-landre-alan on `frontend/apps/be-mobile/src/dashboard/journal/hooks/useJournalItems.tsx:34` (2025-12-31)
> should we have 2 different model for severeIllness and severeIllnessRequest ? (and blockedSevereIllnessRequest)
> Could it not be only severeIllness with a status requested/blocked ?

[link](https://github.com/alan-eu/alan-apps/pull/75608#discussion_r2655603947)

### @bastien-landre-alan on `frontend/apps/be-mobile/src/dashboard/journal/journalListItems/BlockedSevereIllnessRequestListItem.tsx:18` (2025-12-31)
> could you not use frontend/modules/claim-management/src/components/blocked-severe-illness-request/BlockedSevereIllnessRequestItem.tsx ? 

[link](https://github.com/alan-eu/alan-apps/pull/75608#discussion_r2655610852)

---

## PR #75613 — enh(occupational_health): better selection logic in Affiliator

_2026-01-05 • https://github.com/alan-eu/alan-apps/pull/75613_

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/affiliationTool/AffiliationScreen.tsx:477` (2025-12-31)
> <img width="1511" height="148" alt="Image" src="https://github.com/user-attachments/assets/6a2d813e-d904-40d4-93f1-964b603fd546" />

[link](https://github.com/alan-eu/alan-apps/pull/75613#discussion_r2655602366)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/affiliation_tool.py:90` (2025-12-31)
> instead of an empty string

[link](https://github.com/alan-eu/alan-apps/pull/75613#discussion_r2655602631)

---

## PR #75772 — fix: beneficiary_insurance_profile.user_id property access raising an exception in compute_coverage_amounts

_2026-01-05 • https://github.com/alan-eu/alan-apps/pull/75772_

### @bastien-landre-alan — review summary (APPROVED, 2026-01-05)
> 🙏 

[link](https://github.com/alan-eu/alan-apps/pull/75772#pullrequestreview-3626988931)

---

## PR #75778 — upd 🇫🇷 Remove Notification usage in backend

_2026-01-05 • https://github.com/alan-eu/alan-apps/pull/75778_

### @bastien-landre-alan on `backend/components/fr/internal/notifications/queries/get_visible_notifications_for_user.py:984` (2026-01-05)
> nit: I think it's a bit useless to have `get_visible_notifications_for_user` only calling `_get_request_notifications`

[link](https://github.com/alan-eu/alan-apps/pull/75778#discussion_r2661847970)

---

## PR #75815 — del 🇫🇷 drop notification table

_2026-01-12 • https://github.com/alan-eu/alan-apps/pull/75815_

### @bastien-landre-alan — review summary (APPROVED, 2026-01-08)
> :burn: 
> 

[link](https://github.com/alan-eu/alan-apps/pull/75815#pullrequestreview-3640063447)

---

## PR #75825 — enh(occupational_health): Add link from personal dashboard to occh_Admin

_2026-01-06 • https://github.com/alan-eu/alan-apps/pull/75825_

### @MickaelBergem — review summary (APPROVED, 2026-01-05)
> nit: I find it a bit weird that "espace pro" leads to the Occupational Health dashboard (not really "pro") but it's better than not allowing access at all, for users with no health pro dashboard access
> 
> (cc @aizeadesign if you want to take a look at the demo videos)

[link](https://github.com/alan-eu/alan-apps/pull/75825#pullrequestreview-3627813502)

### @bastien-landre-alan — issue comment (2026-01-05)
> > nit: I find it a bit weird that "espace pro" leads to the Occupational Health dashboard (not really "pro") but it's better than not allowing access at all, for users with no health pro dashboard access
> > 
> > (cc @aizeadesign if you want to take a look at the demo videos)
> 
> I agree that it's a quick implem to fix the issue. If we want a specific link for Occupational Health dashboard we would also need a new animated icon.
> cc @cmozzati Do we have a "process" if we need to add something in the menu for those icons ?
> Also I didn't want to add 2 links for "pro" dashboard if member has both.
> 
> :meta: Is is not pro ? For me the member has his personal dashboard to handle his personal care and a dashboard related to his "work" as admin, so a "pro" one (but maybe there is a subtlety for Occupational Health)

[link](https://github.com/alan-eu/alan-apps/pull/75825#issuecomment-3711553173)

---

## PR #75829 — enh(occupational_health): pretty date in dashboard

_2026-01-05 • https://github.com/alan-eu/alan-apps/pull/75829_

### @MickaelBergem — issue comment (2026-01-05)
> This change is part of the following stack:
> 
> - #75824
>     - #75829 ◀
> 
> <sub>Change managed by [git-spice](https://abhinav.github.io/git-spice/).</sub>
> <!-- gs:navigation comment -->
> 

[link](https://github.com/alan-eu/alan-apps/pull/75829#issuecomment-3711448446)

---

## PR #76005 — enh(occh): Affiliator - Add all visit type from log

_2026-01-07 • https://github.com/alan-eu/alan-apps/pull/76005_

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/affiliation_tool.py:263` (2026-01-07)
> Good catch indeed

[link](https://github.com/alan-eu/alan-apps/pull/76005#discussion_r2668720212)

---

## PR #76047 — fix(occupational_health): allow None values for risk category

_2026-01-07 • https://github.com/alan-eu/alan-apps/pull/76047_

### @bastien-landre-alan on `backend/components/fr/internal/marmot/controllers/occupational_health/affiliation_tool.py:225` (2026-01-07)
> Will this work here with empty string ?
> I updated this to pass the Enum type and not a string

[link](https://github.com/alan-eu/alan-apps/pull/76047#discussion_r2668963071)

### @MickaelBergem on `backend/components/fr/internal/marmot/controllers/occupational_health/affiliation_tool.py:225` (2026-01-07)
> Good catch!

[link](https://github.com/alan-eu/alan-apps/pull/76047#discussion_r2668964376)

### @bastien-landre-alan on `backend/components/fr/internal/marmot/controllers/occupational_health/affiliation_tool.py:225` (2026-01-07)
> I approve and let you handle it

[link](https://github.com/alan-eu/alan-apps/pull/76047#discussion_r2668967304)

### @MickaelBergem on `backend/components/fr/internal/marmot/controllers/occupational_health/affiliation_tool.py:225` (2026-01-07)
> Fixed and confirmed working

[link](https://github.com/alan-eu/alan-apps/pull/76047#discussion_r2668972500)

---

## PR #76169 — fix(fr-app): personal dashboard - Display self invite page for occupational_health admin

_2026-01-08 • https://github.com/alan-eu/alan-apps/pull/76169_

### @MickaelBergem — review summary (APPROVED, 2026-01-08)
> LGTM

[link](https://github.com/alan-eu/alan-apps/pull/76169#pullrequestreview-3639385436)

### @bastien-landre-alan on `frontend/modules/member-dashboard/src/internal/components/MemberDashboard.tsx:28` (2026-01-08)
> check company admin && occupational_health admin

[link](https://github.com/alan-eu/alan-apps/pull/76169#discussion_r2672305982)

### @MickaelBergem — issue comment (2026-01-08)
> Let's make sure it doesn't impact the regular Alan experience before merging (timebox 10-15 minutes max)

[link](https://github.com/alan-eu/alan-apps/pull/76169#issuecomment-3723840286)

---

## PR #76291 — enh(occh): Admin - Update visit alert display for late employee

_2026-01-12 • https://github.com/alan-eu/alan-apps/pull/76291_

### @MickaelBergem — review summary (APPROVED, 2026-01-09)
> The screenshot you shared show a deadline date in the future which is super confusing 🤔 
> 
> Also, can you share on Slack (for engs) how to access / use Storybook? I don't know, and I think it'll be helpful for the entire crew!

[link](https://github.com/alan-eu/alan-apps/pull/76291#pullrequestreview-3644337003)

### @MickaelBergem on `frontend/apps/fr-app/js/app/dashboard/occupationalHealth/employees/EmployeeSideModal.tsx:233` (2026-01-09)
> nit: I tend to move business logic to dedicated files (out of the component file, which is more for presentational purposes)

[link](https://github.com/alan-eu/alan-apps/pull/76291#discussion_r2676546695)

### @MickaelBergem on `frontend/apps/fr-app/js/app/dashboard/occupationalHealth/employees/EmployeeSideModal.tsx:289` (2026-01-09)
> now the phone number is hidden: let's make just mention the email address? Also longer-term we should provide admins with a way to act if they see the email is wrong (Intercom button)

[link](https://github.com/alan-eu/alan-apps/pull/76291#discussion_r2676590369)

### @MickaelBergem on `frontend/apps/fr-app/js/app/dashboard/occupationalHealth/employees/EmployeeSideModal.tsx:319` (2026-01-09)
> ```suggestion
>   // This is not really the last reminder but the first email we sent.
> ```

[link](https://github.com/alan-eu/alan-apps/pull/76291#discussion_r2676590585)

### @bastien-landre-alan — issue comment (2026-01-12)
> > The screenshot you shared show a deadline date in the future which is super confusing 🤔
> > 
> > Also, can you share on Slack (for engs) how to access / use Storybook? I don't know, and I think it'll be helpful for the entire crew!
> 
> @MickaelBergem 
> For the weird date, it's because I didn't find employee with the 4 different case, so I updated manually the data to have a screenshot.
> We should have a storybook URL to be able to see the change on the PR but we had an issue with the CI (see [thread](https://alanhealth.slack.com/archives/C19FZEB41/p1767957435036699)). 
> Once the PR is merged I will send a message with the storybook link

[link](https://github.com/alan-eu/alan-apps/pull/76291#issuecomment-3737237088)

---

## PR #76379 — infra(occupational_health): add missing HPs to ZeroTrust

_2026-01-12 • https://github.com/alan-eu/alan-apps/pull/76379_

### @bastien-landre-alan — review summary (APPROVED, 2026-01-12)
> I trust you on the list

[link](https://github.com/alan-eu/alan-apps/pull/76379#pullrequestreview-3649782119)

---

## PR #76396 — enh(occupational_health): custom UserIdNotFound exception

_2026-01-12 • https://github.com/alan-eu/alan-apps/pull/76396_

### @MickaelBergem — issue comment (2026-01-12)
> > @MickaelBergem I'm a bit confused by your message - for clarity we do update the user_id in the employment when a user merge happens. It's implemented [here](https://github.com/alan-eu/alan-apps/blob/9fff583037e4991225fdf2a3b4a3f51ac7828bf1/backend/components/employment/public/business_logic/actions/merge_users.py#L45) but it does not send out an EmploymentChange.
> > 
> > The expectation is that other components that wish to plug into the "user merge" event should do so by themselves, and not rely on the Employment Component for that. I don't think we have a single "user merge" system, we have one in each country, so we just manually plug ourselves into each country's mechanism (currently only done for FR but we'll do something similar in BE).
> 
> @mstmb-alan I was mentioning employment **changes** - that are stuck while the user merge event is received:
> 
> * some change is stuck and queued somewhere on your side
> * user change event is received: you update existing employments, we update existing affiliations
> * when the stuck employment change is retried, it still contains the old user_id

[link](https://github.com/alan-eu/alan-apps/pull/76396#issuecomment-3738104122)

### @MickaelBergem — issue comment (2026-01-12)
> > > that are stuck while the user merge event is received
> > 
> > Ah good point - I'm assuming this means blocked movements where the user_id is not updated. This is indeed something we could improve, I've filed a ticket [here](https://linear.app/alan-eu/issue/SIM-1268/user-merge-should-update-blocked-movement-user-ids).
> 
> Thanks a lot! Yes sorry I wasn't sure about the terminology. Is there a semantic difference between stuck and blocked?

[link](https://github.com/alan-eu/alan-apps/pull/76396#issuecomment-3738553997)

---

## PR #76473 — enh(occupational_health): bubble up UserIdNotFound errs to employment component

_2026-01-12 • https://github.com/alan-eu/alan-apps/pull/76473_

### @MickaelBergem on `backend/components/occupational_health/public/employment/employment_consumer.py:46` (2026-01-12)
> Ah good to know, I'll subclass my exception on that existing one

[link](https://github.com/alan-eu/alan-apps/pull/76473#discussion_r2683110179)

### @MickaelBergem on `backend/components/fr_health_insurance_affiliation/internal/exceptions.py:148` (2026-01-12)
> cc @mstmb-alan it's not super clean but it'll have a consistent interface like other exceptions

[link](https://github.com/alan-eu/alan-apps/pull/76473#discussion_r2683300332)

### @MickaelBergem on `backend/components/occupational_health/public/employment/employment_consumer.py:42` (2026-01-12)
> ⚠️ Removing this catchall `except` block, because:
> 
> * there is already a large except in the called function over most of the business logic code
> * the only times it got executed in the past 2 days are for problems unrelated to Occupational Health, they should have bubbled up to the Employment Component team (and I believe they did eventually):
>   * `new row for relation "core_employment_version" violates check constraint "start_date_before_end_date"` ([Sentry](https://alan-eu.sentry.io/issues/6603236997/?query=%22Failed%20to%20handle%20employment%20changes%22&referrer=issue-stream))
>   * deadlock detected ([Sentry](https://alan-eu.sentry.io/issues/7048290598/?project=5628106&query=%22Failed%20to%20handle%20employment%20changes%22&referrer=issue-stream))

[link](https://github.com/alan-eu/alan-apps/pull/76473#discussion_r2683313362)

### @MickaelBergem on `backend/components/occupational_health/public/dependencies.py:25` (2026-01-12)
> moved to a dedicated file

[link](https://github.com/alan-eu/alan-apps/pull/76473#discussion_r2683314485)

---

## PR #76616 — enh(occupational_health): another variant of VIP naming

_2026-01-13 • https://github.com/alan-eu/alan-apps/pull/76616_

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/affiliation_tool.py:227` (2026-01-13)
> I just moved this one

[link](https://github.com/alan-eu/alan-apps/pull/76616#discussion_r2687067415)

---

## PR #76711 — fix(occ-health): use kwargs instead of dict in log

_2026-01-14 • https://github.com/alan-eu/alan-apps/pull/76711_

### @MickaelBergem — review summary (APPROVED, 2026-01-14)
> Other option: use `extra={ the dict here }`

[link](https://github.com/alan-eu/alan-apps/pull/76711#pullrequestreview-3660555279)

---

## PR #76716 — enh(occh): Admin - Update warning on visit type issue

_2026-01-14 • https://github.com/alan-eu/alan-apps/pull/76716_

### @MickaelBergem — review summary (APPROVED, 2026-01-14)
> Fix and merge

[link](https://github.com/alan-eu/alan-apps/pull/76716#pullrequestreview-3660816177)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/affiliation_tool.py:293` (2026-01-14)
> please fix the comment

[link](https://github.com/alan-eu/alan-apps/pull/76716#discussion_r2690491516)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/affiliation_tool.py:299` (2026-01-14)
> Indeed let's delete 🤔 

[link](https://github.com/alan-eu/alan-apps/pull/76716#discussion_r2690491966)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/affiliation_tool.py:330` (2026-01-14)
> Any chance you can also use the normalization step for the risk category column ([here](https://github.com/alan-eu/alan-apps/blob/788a070b736e0ff77b856d37af0ce7f14fc8b7f4/backend/components/occupational_health/internal/business_logic/queries/affiliation_tool.py#L403))? 🥺 

[link](https://github.com/alan-eu/alan-apps/pull/76716#discussion_r2690496889)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/affiliationTool/ReviewAffiliationMatches.tsx:164` (2026-01-14)
> seen in sync: let's push to first (and maybe always) ask an eng (replacing still mentioned as it would save them some time until eng pushes the new name to prod)

[link](https://github.com/alan-eu/alan-apps/pull/76716#discussion_r2690500348)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/affiliationTool/useParseSpreadsheetMutation.ts:70` (2026-01-14)
> 🙇 

[link](https://github.com/alan-eu/alan-apps/pull/76716#discussion_r2690502071)

---

## PR #76726 — enh(employment): doc on core_employment_version.start_date

_2026-01-14 • https://github.com/alan-eu/alan-apps/pull/76726_

### @MickaelBergem on `backend/components/employment/public/entities.py:398` (2026-01-14)
> Super clear thanks!

[link](https://github.com/alan-eu/alan-apps/pull/76726#discussion_r2690833963)

---

## PR #76784 — fix(occupational_health): don't crash if unknown user_id in spreadsheet

_2026-01-14 • https://github.com/alan-eu/alan-apps/pull/76784_

### @MickaelBergem on `backend/components/medical_secrecy/internal/controllers/medical_app.py:271` (2026-01-14)
> let's pass an actual UUID here

[link](https://github.com/alan-eu/alan-apps/pull/76784#discussion_r2691331441)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/visits/medical_app.py:169` (2026-01-14)
> this instruction was split below

[link](https://github.com/alan-eu/alan-apps/pull/76784#discussion_r2691335404)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/visits/medical_app.py:185` (2026-01-14)
> I'll try to configure Sentry fingerprinting rules to have a dedicated Sentry _error_ per invalid user ID. This way we'll get notified once per invalid user ID, and won't risk to miss the alert if we forgot to resolve the issue the last time.

[link](https://github.com/alan-eu/alan-apps/pull/76784#discussion_r2691339713)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/visits/medical_app.py:237` (2026-01-14)
> we're now passing a UUID from the controller

[link](https://github.com/alan-eu/alan-apps/pull/76784#discussion_r2691340645)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/visits/medical_app.py:188` (2026-01-14)
> Because the visit will still need to take place, and I want to make it easier to distinguish between the following cases:
> 
> * we're missing the visit in the spreadsheet
> * the visit is in the spreadsheet but the user ID is missing

[link](https://github.com/alan-eu/alan-apps/pull/76784#discussion_r2691348386)

---

## PR #76819 — fix(occupational_health): don't crash if profile not affiliated in spreadsheet

_2026-01-15 • https://github.com/alan-eu/alan-apps/pull/76819_

### @MickaelBergem — issue comment (2026-01-15)
> > Is it a fix that we want to keep in long term? if not I'll had a todo
> 
> Yes as long as Ops will be feeding us `user_id`s.

[link](https://github.com/alan-eu/alan-apps/pull/76819#issuecomment-3753487757)

---

## PR #76897 — enh(occupational_health): Admin - Add perso/pro emails for occupational_health profiles 

_2026-01-16 • https://github.com/alan-eu/alan-apps/pull/76897_

### @MickaelBergem on `backend/components/occupational_health/internal/models/occupational_health_profile.py:76` (2026-01-16)
> Let's add a bit of context, this is just a proposal:
> 
> ```suggestion
>     personal_email: Mapped[Optional[str]] = mapped_column_with_privacy(
>         String,
>         # This is currently not editable by members, in the long-term we'll want to let members edit it / somehow sync it with the email managed on the Alan side. For now, it hasn't been framed so we store it separately.
>         doc="The personal email, as provided by the HR.",
>         privacy_properties=PrivacyProperties(
> ```

[link](https://github.com/alan-eu/alan-apps/pull/76897#discussion_r2698147433)

### @MickaelBergem on `backend/components/occupational_health/internal/models/occupational_health_profile_employment_data.py:26` (2026-01-16)
> We haven't really defined what a "subscriber ID" is
> 
> ```suggestion
>     This model stores employment-specific information such as account ID and professional email.
> ```

[link](https://github.com/alan-eu/alan-apps/pull/76897#discussion_r2698148431)

### @MickaelBergem on `backend/components/occupational_health/internal/models/occupational_health_profile_employment_data.py:31` (2026-01-16)
> ✨ 
> 
> ```suggestion
>     profile_id: Mapped[Optional[ProfileId]] = mapped_column(
> ```

[link](https://github.com/alan-eu/alan-apps/pull/76897#discussion_r2698150206)

### @MickaelBergem on `backend/components/occupational_health/internal/models/occupational_health_profile_employment_data.py:34` (2026-01-16)
> What would it mean to have an EmploymentData without a profile? Unless there is a good reason I would make it non-nullable.

[link](https://github.com/alan-eu/alan-apps/pull/76897#discussion_r2698152227)

### @MickaelBergem on `backend/components/occupational_health/internal/models/occupational_health_profile_employment_data.py:40` (2026-01-16)
> Let's avoid adding `noqa`s in new code? 🥺 

[link](https://github.com/alan-eu/alan-apps/pull/76897#discussion_r2698153590)

### @MickaelBergem on `backend/components/occupational_health/internal/models/occupational_health_profile_employment_data.py:40` (2026-01-16)
> But OK to add a backref here, it'll make it easier to navigate the data model in Flask Admin

[link](https://github.com/alan-eu/alan-apps/pull/76897#discussion_r2698154866)

### @MickaelBergem on `backend/components/occupational_health/internal/models/occupational_health_profile_employment_data.py:44` (2026-01-16)
> 👍 

[link](https://github.com/alan-eu/alan-apps/pull/76897#discussion_r2698155795)

### @MickaelBergem on `backend/components/occupational_health/internal/models/occupational_health_profile_employment_data.py:47` (2026-01-16)
> ```suggestion
>     account_id: Mapped[AccountId] = mapped_column(
> ```

[link](https://github.com/alan-eu/alan-apps/pull/76897#discussion_r2698156522)

### @MickaelBergem on `backend/components/occupational_health/internal/models/occupational_health_profile_employment_data.py:51` (2026-01-16)
> Less sure about the need of an index here but why not

[link](https://github.com/alan-eu/alan-apps/pull/76897#discussion_r2698158001)

### @MickaelBergem on `backend/components/occupational_health/internal/models/occupational_health_profile_employment_data.py:26` (2026-01-16)
> Also it doesn't "store" the subscriber ID, at this point is only stores the pro email.
> 
> Let's also mention that we assume a single member can have multiple pro_emails over time at different employers, but we assume they have a single email for a single employer.
> 
> (I like documenting the assumption made when designing the data model directly in the code)

[link](https://github.com/alan-eu/alan-apps/pull/76897#discussion_r2698162977)

### @bastien-landre-alan — issue comment (2026-01-15)
> This change is part of the following stack:
> 
> - #76897 ◀
>     - #76898
> 
> <sub>Change managed by [git-spice](https://abhinav.github.io/git-spice/).</sub>
> <!-- gs:navigation comment -->
> 

[link](https://github.com/alan-eu/alan-apps/pull/76897#issuecomment-3755366370)

---

## PR #76898 — OHSET-178: enh(occupational_health): Affiliator - parse and save perso/pro emails

_2026-01-16 • https://github.com/alan-eu/alan-apps/pull/76898_

### @MickaelBergem — review summary (APPROVED, 2026-01-16)
> Looks good!

[link](https://github.com/alan-eu/alan-apps/pull/76898#pullrequestreview-3670360906)

### @MickaelBergem on `backend/components/fr/internal/marmot/controllers/occupational_health/affiliation_tool.py:240` (2026-01-16)
> nit: to prevent future bugs in case we rename the argument in the frontend but somehow forget to do here, I tend to prefer the `aff["personal_email"]` form that will raise if the argument is _missing_, helping spot the issue sooner than later.
> 
> We still allow `None` values (`null` in JS), but not missing ones (`undefined` in JS).
> 
> (I assume marshmallow will flag it as well, but I'm never sure) 

[link](https://github.com/alan-eu/alan-apps/pull/76898#discussion_r2698097699)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/actions/occupational_health_profile.py:38` (2026-01-16)
> nit: I would log.info something

[link](https://github.com/alan-eu/alan-apps/pull/76898#discussion_r2698101690)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/actions/occupational_health_profile.py:49` (2026-01-16)
> my man 🤩 

[link](https://github.com/alan-eu/alan-apps/pull/76898#discussion_r2698103444)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/actions/occupational_health_profile.py:52` (2026-01-16)
> I'm curious: why aren't we raising in those cases?
> 
> By allowing to continue, we take the risk of having half-affiliated subscribers :/

[link](https://github.com/alan-eu/alan-apps/pull/76898#discussion_r2698107083)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/actions/occupational_health_profile_employment_data.py:27` (2026-01-16)
> Aligned to rename the field to `account_id` so that we know what's in the field.

[link](https://github.com/alan-eu/alan-apps/pull/76898#discussion_r2698110354)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/actions/occupational_health_profile_employment_data.py:24` (2026-01-16)
> ```suggestion
>     professional_email: str | None,
>     commit: bool = True,
> ) -> None:
>     """
>     Update professional email for an occupational health profile.
> 
> 	If `professional_email` is None, removes the currently stored value.
>     Gets or creates an OccupationalHealthProfileEmploymentData record and updates the professional email.
> ```

[link](https://github.com/alan-eu/alan-apps/pull/76898#discussion_r2698114184)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/actions/occupational_health_profile_employment_data.py:47` (2026-01-16)
> Small nit: I prefer the opposite form
> 
> ```python
> if not employment_data:
>     employment_data = OccupationalHealthProfileEmploymentData(profile_id=profile_id, subscriber_id=account_id)
>     current_session.add(employment_data)
> 
> employment_data.professional_email = pro_email
> ```
> 
> This way we deduplicate the code setting the value (reduced risk of bug if we update the code one day and forget to update the other branch).

[link](https://github.com/alan-eu/alan-apps/pull/76898#discussion_r2698120006)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/affiliation_tool.py:771` (2026-01-16)
> You can move the comment above your new code

[link](https://github.com/alan-eu/alan-apps/pull/76898#discussion_r2698122599)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/affiliation_tool.py:484` (2026-01-16)
> micro nit: I tend to dislike single-char variable names, with modern IDEs it's practically identical to expand to `error`, and more readable when reading `{email} - {e}`

[link](https://github.com/alan-eu/alan-apps/pull/76898#discussion_r2698130242)

### @bastien-landre-alan on `backend/components/occupational_health/internal/business_logic/actions/occupational_health_profile.py:52` (2026-01-16)
> I thought that the personal email update was less important and we should not stop the affiliation because of it.
> We would have the sentry failing and check later, but I will update for a raise (it should not happen so I agree)

[link](https://github.com/alan-eu/alan-apps/pull/76898#discussion_r2698153237)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/actions/occupational_health_profile.py:52` (2026-01-16)
> Trusting you on the final decision!
> 
> I agree I have a very personal tendency to favor "fail loudly" over "fail silently", which tends to create chaos sometimes as I iterate after learning the failure modes of the system (eg invalid input by Ops, etc). I won't fight if you prefer to make things "fail silently" as it also means being more robust when it actually happens.

[link](https://github.com/alan-eu/alan-apps/pull/76898#discussion_r2698178937)

### @bastien-landre-alan on `backend/components/occupational_health/internal/business_logic/actions/occupational_health_profile.py:52` (2026-01-16)
> Agree with you I updated the code using `get_or_raise_missing_resource` to get the profile

[link](https://github.com/alan-eu/alan-apps/pull/76898#discussion_r2698477961)

### @bastien-landre-alan — issue comment (2026-01-15)
> This change is part of the following stack:
> 
> - #76897
>     - #76898 ◀
> 
> <sub>Change managed by [git-spice](https://abhinav.github.io/git-spice/).</sub>
> <!-- gs:navigation comment -->
> 

[link](https://github.com/alan-eu/alan-apps/pull/76898#issuecomment-3755366366)

---

## PR #76902 — [Prevenir] Add contextual link from Flask Admin to member dashboard

_2026-01-15 • https://github.com/alan-eu/alan-apps/pull/76902_

### @MickaelBergem — review summary (APPROVED, 2026-01-15)
> Not sure this is really what you want?

[link](https://github.com/alan-eu/alan-apps/pull/76902#pullrequestreview-3666275806)

### @MickaelBergem on `backend/shared/blueprints/alan_admin/admin_model_view.py:1400` (2026-01-15)
> Do you need the trailing space? I would maybe rename to "DMST" since that's what you are opening?

[link](https://github.com/alan-eu/alan-apps/pull/76902#discussion_r2694915881)

### @MickaelBergem on `backend/shared/blueprints/alan_admin/admin_model_view.py:1393` (2026-01-15)
> I think this will break when executed from `fr_api`'s Flask Admin no?

[link](https://github.com/alan-eu/alan-apps/pull/76902#discussion_r2694917184)

---

## PR #76916 — feat(occ-health): display first and last name in menu bar [OHMED-41]

_2026-01-16 • https://github.com/alan-eu/alan-apps/pull/76916_

### @MickaelBergem — review summary (APPROVED, 2026-01-15)
> Fix and merge! 🚀 

[link](https://github.com/alan-eu/alan-apps/pull/76916#pullrequestreview-3666435947)

### @MickaelBergem on `frontend/apps/medical-software/app/hooks/useUserQuery.ts:12` (2026-01-15)
> In which case could this be `null`? 🤔 
> 
> Could we simplify and say we always get a `User`?

[link](https://github.com/alan-eu/alan-apps/pull/76916#discussion_r2695040952)

### @MickaelBergem on `frontend/apps/medical-software/app/layout/TopLeftMenu.tsx:9` (2026-01-15)
> Just do it with CSS ;)
> 
> https://developer.mozilla.org/en/docs/Web/CSS/Reference/Properties/text-overflow

[link](https://github.com/alan-eu/alan-apps/pull/76916#discussion_r2695042514)

---

## PR #76918 — feat(occ-health): handle account merge/deletion

_2026-01-26 • https://github.com/alan-eu/alan-apps/pull/76918_

### @MickaelBergem — review summary (APPROVED, 2026-01-16)
> Looking good so far! 

[link](https://github.com/alan-eu/alan-apps/pull/76918#pullrequestreview-3669927134)

### @MickaelBergem on `backend/components/affiliation_occ_health/public/api.py:296` (2026-01-16)
> Let's be consistent in the interface + keep it as agnostic of Occupational Health as possible
> 
> ```suggestion
>     affiliation_id: UUID,
> ```

[link](https://github.com/alan-eu/alan-apps/pull/76918#discussion_r2697782177)

### @MickaelBergem on `backend/components/occupational_health/public/actions/account.py:24` (2026-01-16)
> Since this is a public interface and `AccountId` is an internal type, let's also accept a plain `UUID` to avoid type errors
> ```suggestion
>     new_account_id: AccountId | UUID,
>     old_account_id: AccountId | UUID,
> ```

[link](https://github.com/alan-eu/alan-apps/pull/76918#discussion_r2697786450)

### @MickaelBergem on `backend/components/occupational_health/public/actions/account.py:24` (2026-01-16)
> Also nit I would swap the parameters so that we have `move(source_account_id, target_account_id)`

[link](https://github.com/alan-eu/alan-apps/pull/76918#discussion_r2697788511)

### @MickaelBergem on `backend/components/occupational_health/public/actions/account.py:33` (2026-01-16)
> nit: ideally we would add a lock, but it's not important here as the function will be rarely be called

[link](https://github.com/alan-eu/alan-apps/pull/76918#discussion_r2697792289)

### @MickaelBergem on `backend/components/occupational_health/public/actions/account.py:47` (2026-01-16)
> I feel we could also let the DB constraint do its job and rollback our session when it happens

[link](https://github.com/alan-eu/alan-apps/pull/76918#discussion_r2697796205)

### @MickaelBergem on `backend/components/occupational_health/public/actions/account.py:83` (2026-01-16)
> If you're short a time, please focus on:
> * `affiliation_strategy_rule`
> * `occupational_health_dashboard_admin`
> * `occupational_health_visit`
> * `occupational_health_workspace_action`
> 
> The other ones could remain in TODO for little longer.

[link](https://github.com/alan-eu/alan-apps/pull/76918#discussion_r2698068121)

### @MickaelBergem on `backend/components/occupational_health/public/actions/account.py:107` (2026-01-16)
> nit: use 🔀 instead so it's easier to see in the stream of messages

[link](https://github.com/alan-eu/alan-apps/pull/76918#discussion_r2698071095)

---

## PR #76919 — Add medical secrecy access to s3 bucket

_2026-01-16 • https://github.com/alan-eu/alan-apps/pull/76919_

### @MickaelBergem — review summary (COMMENTED, 2026-01-15)
> This would make all previous recordings available to all engineers with a shell access to `medical_secrecy`. Do we really need _read_ access to the bucket? 🤔 

[link](https://github.com/alan-eu/alan-apps/pull/76919#pullrequestreview-3666488105)

### @MickaelBergem on `infra/src/stacks/main/qovery-env-backend-medical-secrecy--prod/environment.tf:83` (2026-01-15)
> the new item is NOT "duplicated from qovery-env-backend-fr--prod"

[link](https://github.com/alan-eu/alan-apps/pull/76919#discussion_r2695073701)

### @MickaelBergem on `infra/src/stacks/main/qovery-env-backend-medical-secrecy--prod/environment.tf:79` (2026-01-15)
> There are probably some buckets we should clean...

[link](https://github.com/alan-eu/alan-apps/pull/76919#discussion_r2695076629)

### @MickaelBergem — issue comment (2026-01-15)
> Check the existing "uploader" role, you might be able to reuse the same IAM policy (I think that's the name??)

[link](https://github.com/alan-eu/alan-apps/pull/76919#issuecomment-3755968240)

---

## PR #77012 — fix(occupational_health): ignore visits without date

_2026-01-16 • https://github.com/alan-eu/alan-apps/pull/77012_

### @bastien-landre-alan — review summary (APPROVED, 2026-01-16)
> ok, but in your example the date was not None but wrong, is the clean done earlier so that the field is empty in turing ?

[link](https://github.com/alan-eu/alan-apps/pull/77012#pullrequestreview-3671043986)

---

## PR #77143 — fix(medsec): enforce Occupational Health profile ID to be UUID

_2026-01-19 • https://github.com/alan-eu/alan-apps/pull/77143_

### @MickaelBergem on `backend/components/medical_secrecy/internal/controllers/medical_app.py:235` (2026-01-19)
> note: I'll let the MedSec team also update it for `document_id`, etc as I didn't check if it was actually UUID or plain strings

[link](https://github.com/alan-eu/alan-apps/pull/77143#discussion_r2704208330)

---

## PR #77207 — [Prevenir] Add Prevenir admin link in Marmot

_2026-01-22 • https://github.com/alan-eu/alan-apps/pull/77207_

### @MickaelBergem — review summary (APPROVED, 2026-01-20)
> Interesting approach!
> 
> I am a bit surprised that we have to edit the `fr` stack, and I wonder how this fits within the broader global admin management topic. Did you talk with the crew owning this topic / are they aware they need to review this PR?
> 
> In the end it reuses the current code so it might be better than doing every from scratch as I initially imagined.
> 
> A few issues worth fixing as far as I'm concerned.

[link](https://github.com/alan-eu/alan-apps/pull/77207#pullrequestreview-3683096535)

### @MickaelBergem on `backend/components/fr/internal/business_logic/company/queries/admined_entity.py:208` (2026-01-20)
> nit: not super fan of the abbreviation `oh` as it's not super readable

[link](https://github.com/alan-eu/alan-apps/pull/77207#discussion_r2709111317)

### @MickaelBergem on `backend/components/fr/internal/business_logic/company/queries/admined_entity.py:210` (2026-01-20)
> Why the leading `_`? Is it because of name conflicts with the rest of the function body? If yes one solution would be to extract the implem to dedicated `_get_occupational_health_admined_entities(user_id) -> list[AdminedEntityForAlaneradmin]` function

[link](https://github.com/alan-eu/alan-apps/pull/77207#discussion_r2709124154)

### @MickaelBergem on `backend/components/occupational_health/public/marmot/queries.py:677` (2026-01-20)
> We should not return _models_ in public interfaces: either dataclasses or scalars :(

[link](https://github.com/alan-eu/alan-apps/pull/77207#discussion_r2709128706)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/users/UserInfo/states/AdminDetails.tsx:174` (2026-01-20)
> Not sure if this will be displayed to users, in which case it should be `Prévenir`, or if it's just some internal code, in which case it should be lowercase for consistency?

[link](https://github.com/alan-eu/alan-apps/pull/77207#discussion_r2709137523)

### @MickaelBergem on `frontend/apps/fr-marmot/shared/admins/adminTypes.ts:31` (2026-01-20)
> ```suggestion
>   [ApiEnums.AdminedEntityType.OccupationalHealthAccount, "Prévenir Admin"],
> ```

[link](https://github.com/alan-eu/alan-apps/pull/77207#discussion_r2709139152)

### @MickaelBergem — issue comment (2026-01-20)
> @Universemul can you share a screenshot in the result for this kind of changes?

[link](https://github.com/alan-eu/alan-apps/pull/77207#issuecomment-3773789018)

---

## PR #77417 — fix(oh): set risk category as not nullable

_2026-01-21 • https://github.com/alan-eu/alan-apps/pull/77417_

### @MickaelBergem on `backend/components/occupational_health/internal/models/occupational_health_administrative_profile.py:71` (2026-01-21)
> Can't you do it at the same time, since typing doesn't affect the runtime?

[link](https://github.com/alan-eu/alan-apps/pull/77417#discussion_r2711719992)

### @MickaelBergem on `backend/components/occupational_health/internal/models/occupational_health_administrative_profile.py:71` (2026-01-21)
> Meh, it's a false positive from the linter as long as we only change typing. I would feel comfortable force-merging in spite of the linter, but you can also do a second PR on top to keep things green.
> 
> cc @dams it's an acceptable edge case for me but maybe you'll have a better idea to fix it

[link](https://github.com/alan-eu/alan-apps/pull/77417#discussion_r2711732240)

---

## PR #77527 — fix: resume_enrollment metadata

_2026-01-21 • https://github.com/alan-eu/alan-apps/pull/77527_

### @MickaelBergem — review summary (APPROVED, 2026-01-21)
> 🙏 

[link](https://github.com/alan-eu/alan-apps/pull/77527#pullrequestreview-3688554063)

---

## PR #77530 — feat(occupational_health): add user merge handler for dashboard admins

_2026-01-22 • https://github.com/alan-eu/alan-apps/pull/77530_

### @MickaelBergem on `backend/components/occupational_health/public/business_logic/actions/merge_users.py:16` (2026-01-21)
> At this point we don't have other references of `user_id` in our codebase (only `global_profile_id`s which are handled as an event listener).

[link](https://github.com/alan-eu/alan-apps/pull/77530#discussion_r2713632683)

### @MickaelBergem on `backend/components/occupational_health/public/business_logic/actions/merge_users.py:16` (2026-01-22)
> Yes but it's imported every hour so it's a read-only table on our end. But it's a good point we should add a slack alert to tell Ops to update the user ID. Possible woodchuck cc @universemul

[link](https://github.com/alan-eu/alan-apps/pull/77530#discussion_r2716918456)

### @MickaelBergem on `backend/components/occupational_health/public/business_logic/actions/merge_users.py:16` (2026-01-27)
> https://linear.app/alan-eu/issue/OHSET-243/flag-existing-spreadsheet-visits-that-need-to-be-updated

[link](https://github.com/alan-eu/alan-apps/pull/77530#discussion_r2731950197)

---

## PR #77593 — feat(oh): add an employee count per year to the billed entity model (OHSET-56)

_2026-01-22 • https://github.com/alan-eu/alan-apps/pull/77593_

### @MickaelBergem — review summary (APPROVED, 2026-01-22)
> LGTM, with one thing to change on naming + documentation.
> 
> Otherwise very good first PR 👏 

[link](https://github.com/alan-eu/alan-apps/pull/77593#pullrequestreview-3692383229)

### @MickaelBergem — review summary (APPROVED, 2026-01-22)
> Looks good with one minor documentation change!

[link](https://github.com/alan-eu/alan-apps/pull/77593#pullrequestreview-3692587375)

### @MickaelBergem on `backend/components/occupational_health/internal/models/occupational_health_billed_entity.py:77` (2026-01-22)
> I think it would be clearer to mention - in the column name - that this is used for installment plans, otherwise new engineers or Ops seeing the model would have a hard time understanding what it's for.
> 
> The `doc=` can be used to provide more information but let's make sure it mentions it is used _for installment plans_ ("échéanciers" in French)

[link](https://github.com/alan-eu/alan-apps/pull/77593#discussion_r2716857383)

### @MickaelBergem on `backend/components/occupational_health/internal/models/occupational_health_billed_entity.py:77` (2026-01-22)
> In the doc, let's also document what it means if the value is `None`: this entity will not use an installment plan.

[link](https://github.com/alan-eu/alan-apps/pull/77593#discussion_r2716860036)

### @MickaelBergem on `backend/components/occupational_health/internal/models/occupational_health_billed_entity.py:77` (2026-01-22)
> Let's also document what happens if the company needs an installment plan for only some years (eg 2025 and 2027 but not 2026). Here I would just not mention 2026 as a key of the dict, but let's be super clear on the behavior / how to represent each case.

[link](https://github.com/alan-eu/alan-apps/pull/77593#discussion_r2716864438)

### @MickaelBergem on `backend/components/occupational_health/internal/models/occupational_health_billed_entity.py:76` (2026-01-22)
> > when count ≥ 20
> 
> Not necessarily all the time, let's remove it.
> ```suggestion
>         doc="Year-specific employee count used to compute the installment plans. Format: {'2025': 450, '2026': 460}. If not set or there is no key for the target year, will disable installment plan for this entity.",
> ```

[link](https://github.com/alan-eu/alan-apps/pull/77593#discussion_r2717029964)

### @MickaelBergem — issue comment (2026-01-22)
> Documenting this here: for that field it is fine to do the migration in one step as the data model is not used in production at this point, so we have little risk of breaking something.

[link](https://github.com/alan-eu/alan-apps/pull/77593#issuecomment-3784379584)

---

## PR #77624 — enh(occh): Affiliator - Update pro email from emmployment update event

_2026-01-23 • https://github.com/alan-eu/alan-apps/pull/77624_

### @MickaelBergem — review summary (APPROVED, 2026-01-22)
> 👍 
> 
> You could also ask Claude to generate a unit test just to make it more robust

[link](https://github.com/alan-eu/alan-apps/pull/77624#pullrequestreview-3692615455)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/actions/employment/invitation.py:156` (2026-01-22)
> might be worth documenting the assumption we're making: "there is at most a single relevant `invite_email` per employment change"
> 
> (I'm fine with this assumption at this point)

[link](https://github.com/alan-eu/alan-apps/pull/77624#discussion_r2717053688)

---

## PR #77841 — enh(occh): Marmot - Billing entities and PDF preview in billing tower

_2026-01-26 • https://github.com/alan-eu/alan-apps/pull/77841_

### @MickaelBergem on `backend/components/billing_occupational_health/bootstrap/blueprint.py:14` (2026-01-26)
> I'm always disappointed that we *-allow CORS but hey at least we're consistent :(

[link](https://github.com/alan-eu/alan-apps/pull/77841#discussion_r2727187377)

### @MickaelBergem on `backend/components/fr/internal/marmot/controllers/occupational_health/billing.py:15` (2026-01-26)
> Let's inline import of business logic from controllers file 🙏 
> 
> It allows not importing business logic at app boot time (otherwise import time grows a lot). There's an ongoing debate about this so it's not yet linted.

[link](https://github.com/alan-eu/alan-apps/pull/77841#discussion_r2727190385)

### @MickaelBergem on `backend/components/fr/internal/marmot/controllers/occupational_health/billing.py:33` (2026-01-26)
> 👌 

[link](https://github.com/alan-eu/alan-apps/pull/77841#discussion_r2727190922)

### @MickaelBergem on `backend/components/fr/internal/marmot/controllers/occupational_health/billing.py:49` (2026-01-26)
> ```suggestion
>     account_id: AccountId, query_args: dict[str, Any]
> ```
> 
> this way you don't need to cast it in the function body (OK since we know we're getting a UUID and this UUID is expected to be an account ID)

[link](https://github.com/alan-eu/alan-apps/pull/77841#discussion_r2727192293)

### @MickaelBergem on `backend/components/occupational_health/public/queries/billing.py:155` (2026-01-26)
> Should we use a TypedDict if they key are always there? Or even better, a dedicated dataclass?

[link](https://github.com/alan-eu/alan-apps/pull/77841#discussion_r2727198845)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/billing/BilledEntities.tsx:47` (2026-01-26)
> nit: maybe having a single column { entity.siret ?? entity.siren } <Tag color={...}>SIRET-level</Tag> would be more readable (just an idea for a future iteration)

[link](https://github.com/alan-eu/alan-apps/pull/77841#discussion_r2727202916)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/billing/BilledEntitiesSection.tsx:35` (2026-01-26)
> ```suggestion
>     <Accordion.Item value="billing-entities">
> ```

[link](https://github.com/alan-eu/alan-apps/pull/77841#discussion_r2727204306)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/billing/BillingDataSection.tsx:62` (2026-01-26)
> ```suggestion
>     <Accordion.Item value="billing-data">
> ```

[link](https://github.com/alan-eu/alan-apps/pull/77841#discussion_r2727207207)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/billing/BillingDataSection.tsx:73` (2026-01-26)
> ```suggestion
>               Find billing issues
> ```
> 
> I also considered "compute" as we're not just fetching data

[link](https://github.com/alan-eu/alan-apps/pull/77841#discussion_r2727208603)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/billing/BillingInvoices.tsx:22` (2026-01-26)
> It's not clear it will handle a contract ref, maybe we can rename?

[link](https://github.com/alan-eu/alan-apps/pull/77841#discussion_r2727212806)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/billing/BillingInvoices.tsx:40` (2026-01-26)
> Might be worth `Logger.error()` it as well, easier for debugging?

[link](https://github.com/alan-eu/alan-apps/pull/77841#discussion_r2727214039)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/billing/GlobalBillingData.tsx:35` (2026-01-26)
> I think you can usually display the account ID under the name (in a smaller font + with a copy ID button if needed)

[link](https://github.com/alan-eu/alan-apps/pull/77841#discussion_r2727218012)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/billing/GlobalBillingData.tsx:37` (2026-01-26)
> Are these the "already generated" invoices?

[link](https://github.com/alan-eu/alan-apps/pull/77841#discussion_r2727218697)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/billing/index.tsx:107` (2026-01-26)
> ```suggestion
> ```

[link](https://github.com/alan-eu/alan-apps/pull/77841#discussion_r2727219855)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/billing/index.tsx:116` (2026-01-26)
> ```suggestion
> ```

[link](https://github.com/alan-eu/alan-apps/pull/77841#discussion_r2727220118)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/billing/index.tsx:125` (2026-01-26)
> ```suggestion
> ```

[link](https://github.com/alan-eu/alan-apps/pull/77841#discussion_r2727220307)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/billing/index.tsx:138` (2026-01-26)
> Why can `selectedYear` be `undefine`?
> ```suggestion
>               value={selectedYear.toString()}
> ```

[link](https://github.com/alan-eu/alan-apps/pull/77841#discussion_r2727222753)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/billing/useGetBillingDataQuery.ts:28` (2026-01-26)
> Does that work? :o

[link](https://github.com/alan-eu/alan-apps/pull/77841#discussion_r2727224860)

### @bastien-landre-alan on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/billing/BillingDataSection.tsx:62` (2026-01-26)
> this is a "dirty" hack because of the Way Accordion is displayed.
> When we load the data, the "height" is not recompute and the table is not displayed. You have to close/reopen the accordion to see it.
> With this, as the key changed, the re-render is forced. 
> 
> I wanted to work on it to find a better solution but not prio

[link](https://github.com/alan-eu/alan-apps/pull/77841#discussion_r2727254933)

### @bastien-landre-alan on `backend/components/occupational_health/public/queries/billing.py:155` (2026-01-26)
> yes will change this in a next PR (as I will change a bit the return format)

[link](https://github.com/alan-eu/alan-apps/pull/77841#discussion_r2727260162)

### @bastien-landre-alan on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/billing/BilledEntities.tsx:47` (2026-01-26)
> I thought it will be easier to see which entity is siret based (if the column if filled)

[link](https://github.com/alan-eu/alan-apps/pull/77841#discussion_r2727262805)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/billing/BilledEntities.tsx:47` (2026-01-26)
> Yeah no strong opinion! You spent more time looking at the dashboard than me ;)

[link](https://github.com/alan-eu/alan-apps/pull/77841#discussion_r2727264762)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/billing/BillingDataSection.tsx:62` (2026-01-26)
> Oh wow! Worth a comment then.

[link](https://github.com/alan-eu/alan-apps/pull/77841#discussion_r2727266020)

### @bastien-landre-alan on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/billing/BillingInvoices.tsx:22` (2026-01-26)
> Bot sure to understand, are you talking about the pdf generation ? There is a line for each contract ref, we generate the pdf for the specific contract ref

[link](https://github.com/alan-eu/alan-apps/pull/77841#discussion_r2727266728)

### @bastien-landre-alan on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/billing/GlobalBillingData.tsx:37` (2026-01-26)
> This is the number of InvoiceData return, so the number of invoice that could be generated.
> Renamed it to "Possible Invoice count"

[link](https://github.com/alan-eu/alan-apps/pull/77841#discussion_r2727271091)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/billing/BillingInvoices.tsx:22` (2026-01-26)
> I meant renaming `loadingPdfFor` to something like `loadingPdfForContractRef` or `contractRefPdfBeingLoaded`

[link](https://github.com/alan-eu/alan-apps/pull/77841#discussion_r2727271414)

### @bastien-landre-alan on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/billing/useGetBillingDataQuery.ts:28` (2026-01-26)
> yes but it's dirty :D 
> fixed it to used account_id

[link](https://github.com/alan-eu/alan-apps/pull/77841#discussion_r2727279348)

---

## PR #77905 — feat(oh): add emails_to_notify to the billed entity model

_2026-01-26 • https://github.com/alan-eu/alan-apps/pull/77905_

### @MickaelBergem — review summary (APPROVED, 2026-01-26)
> Fix and merge

[link](https://github.com/alan-eu/alan-apps/pull/77905#pullrequestreview-3705605889)

### @MickaelBergem on `backend/components/occupational_health/internal/models/occupational_health_billed_entity.py:77` (2026-01-26)
> Since these contain emails, we'll need to anonymize them when exporting the data (eg to Turing/Metabase). Check out `mapped_column_with_privacy` and `PrivacyProperties()`

[link](https://github.com/alan-eu/alan-apps/pull/77905#discussion_r2727230518)

### @MickaelBergem on `backend/components/occupational_health/internal/models/occupational_health_billed_entity.py:79` (2026-01-26)
> Should we instead have a default to an empty list and have `nullable=False`? You can make it work easily with a `default` + `server_default` (beware the syntax)

[link](https://github.com/alan-eu/alan-apps/pull/77905#discussion_r2727232214)

---

## PR #77977 — feat(oh-marmot): display company nic and employment nic in marmot and enable edition

_2026-01-27 • https://github.com/alan-eu/alan-apps/pull/77977_

### @MickaelBergem — review summary (APPROVED, 2026-01-26)
> LGTM! 🚀 
> 
> (with one big caveat on the multiple-NICs-in-employment case)
> 
> You might also be interested one day by [this](https://github.com/alan-eu/alan-apps/blob/15af357a83664fafe8b228a34f2e8dcef6d05db5/backend/components/fr/bootstrap/dependencies/occupational_health.py#L174) that gives access to the ZIP code / city name associated with the SIRET, for displaying it more prettily.

[link](https://github.com/alan-eu/alan-apps/pull/77977#pullrequestreview-3707286560)

### @MickaelBergem on `backend/components/occupational_health/public/marmot/actions.py:431` (2026-01-26)
> Indeed, and intra-SIREN moves are possible though we didn't see many last year. And for some companies it means we'll affiliate them depending on the extendedvalue timeline (just for when they are on that specific NIC).
> 
> @Thomas-Mollard Maybe we should at least display a warning / block writing it if there is more than one NIC found?

[link](https://github.com/alan-eu/alan-apps/pull/77977#discussion_r2728655485)

### @MickaelBergem on `backend/components/occupational_health/public/marmot/actions.py:412` (2026-01-26)
> Let's also log what we're doing

[link](https://github.com/alan-eu/alan-apps/pull/77977#discussion_r2728671366)

### @MickaelBergem on `backend/components/occupational_health/public/marmot/actions.py:431` (2026-01-26)
> Thinking about it I would be tempted to remain scrappy for now and:
> 
> * assume that there is a single NIC per employment (at least 95% of the cases I've seen, probably closer to 99.5%)
> * and, if when writing it we notice the existing NIC doesn't fully overlap the employment (let's maybe check how frequent it is), raise here saying to call EngOncall _à la rescousse_
> 
> I think it's a strategic reason to create tech debt today 🙈 

[link](https://github.com/alan-eu/alan-apps/pull/77977#discussion_r2728679098)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/affiliatedMembers/MemberDetailsDrawer.tsx:52` (2026-01-26)
> nit
> ```suggestion
>   const [nicValues, setNicValues] = useState<Record<UUID, string | null>>({});
> ```

[link](https://github.com/alan-eu/alan-apps/pull/77977#discussion_r2728683294)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/affiliatedMembers/useUpdateEmploymentMutation.ts:8` (2026-01-26)
> 🙏 super clear

[link](https://github.com/alan-eu/alan-apps/pull/77977#discussion_r2728685579)

### @MickaelBergem — issue comment (2026-01-26)
> Looking at the recording: can we add a Mantine notification when the update is successful? Here there is no visual feedback so we don't know if it really worked or not.

[link](https://github.com/alan-eu/alan-apps/pull/77977#issuecomment-3800894123)

---

## PR #77983 — enh(occh): Marmot - Add list of affiliation in billing tower

_2026-01-27 • https://github.com/alan-eu/alan-apps/pull/77983_

### @MickaelBergem — review summary (APPROVED, 2026-01-26)
> Looks great to me, thanks a lot! 🙇 

[link](https://github.com/alan-eu/alan-apps/pull/77983#pullrequestreview-3707240079)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/affiliatedMembers/index.tsx:53` (2026-01-26)
> ```suggestion
>   filterProfileIds?: UUID[];
> ```

[link](https://github.com/alan-eu/alan-apps/pull/77983#discussion_r2728631706)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/billing/BillingDataSection.tsx:24` (2026-01-26)
> Super clear thanks! 👌 

[link](https://github.com/alan-eu/alan-apps/pull/77983#discussion_r2728635261)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/billing/BillingInvoices.tsx:12` (2026-01-26)
> ```suggestion
>   accountId?: UUID;
> ```

[link](https://github.com/alan-eu/alan-apps/pull/77983#discussion_r2728636891)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/billing/BillingInvoices.tsx:13` (2026-01-26)
> Is that string a contract ref? The name is unclear.

[link](https://github.com/alan-eu/alan-apps/pull/77983#discussion_r2728637711)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/billing/BillingInvoices.tsx:28` (2026-01-26)
> Just seeing the commented out code, can we remove it? 🤔 

[link](https://github.com/alan-eu/alan-apps/pull/77983#discussion_r2728638645)

### @MickaelBergem — issue comment (2026-01-26)
> Looking at the recording: can you add a button to copy to clipboard? It will help Clémence build the invoice PDF.
> 
> (can be in a follow up PR)

[link](https://github.com/alan-eu/alan-apps/pull/77983#issuecomment-3800868459)

### @bastien-landre-alan — issue comment (2026-01-27)
> Merge it this morning to be deployed at 8am but will fix the comment afterward
> I already added the button but didn't record it (add it after the recording)

[link](https://github.com/alan-eu/alan-apps/pull/77983#issuecomment-3803442410)

---

## PR #78187 — [Occupational health] Add new command to create OccupationalHealthBilledEntity

_2026-03-03 • https://github.com/alan-eu/alan-apps/pull/78187_

### @MickaelBergem on `backend/components/occupational_health/internal/commands/generate_billed_entity_by_year.py:12` (2026-02-02)
> Let's keep business logic imports inside command body to ensure the business logic doesn't get imported at Flask app boot time (there used to be a linter...)

[link](https://github.com/alan-eu/alan-apps/pull/78187#discussion_r2753317385)

### @MickaelBergem on `backend/components/occupational_health/internal/commands/generate_billed_entity_by_year.py:125` (2026-02-02)
> nit: might be worth adding a comment on the _why_ we do that

[link](https://github.com/alan-eu/alan-apps/pull/78187#discussion_r2753327779)

### @MickaelBergem on `backend/components/occupational_health/internal/commands/generate_billed_entity_by_year.py:130` (2026-02-02)
> nit: Exception is too broad

[link](https://github.com/alan-eu/alan-apps/pull/78187#discussion_r2753330907)

### @MickaelBergem on `backend/components/occupational_health/internal/commands/generate_billed_entity_by_year.py:162` (2026-02-02)
> This will spam Sentry, not sure it's the right level for a command executed by a human?

[link](https://github.com/alan-eu/alan-apps/pull/78187#discussion_r2753334554)

### @MickaelBergem on `backend/components/occupational_health/internal/commands/generate_billed_entity_by_year.py:180` (2026-02-02)
> Hmmm ok

[link](https://github.com/alan-eu/alan-apps/pull/78187#discussion_r2753339222)

### @MickaelBergem on `backend/components/occupational_health/internal/commands/generate_billed_entity_by_year.py:180` (2026-02-02)
> Let's add a timed TODO reminder in the comment to ensure we remove the command

[link](https://github.com/alan-eu/alan-apps/pull/78187#discussion_r2753342978)

### @MickaelBergem on `backend/components/occupational_health/internal/commands/generate_billed_entity_by_year.py:325` (2026-02-02)
> Not technically possible - we'll have to do one invoice per SIREN at let the customer know + remind @ArthurSeres-Alan that we cannot do an invoice for multiple SIRENs, as mentioned [in this issue](https://github.com/alan-eu/Topics/discussions/30344?sort=old#discussioncomment-13912345):
> 
> > Each Company can elect to either SIREN-based billing or SIRET-based billing, meaning we could have several invoices for a same Company object.

[link](https://github.com/alan-eu/alan-apps/pull/78187#discussion_r2753350292)

---

## PR #78216 — enh(billing): Occh: update computation of billing data to based on pr…

_2026-01-28 • https://github.com/alan-eu/alan-apps/pull/78216_

### @MickaelBergem on `backend/components/occupational_health/public/queries/billing.py:323` (2026-01-28)
> ```suggestion
> ) -> tuple["CustomerInternalData", ProfileId]:
> ```

[link](https://github.com/alan-eu/alan-apps/pull/78216#discussion_r2735839209)

### @MickaelBergem on `backend/components/occupational_health/public/queries/billing.py:323` (2026-01-28)
> Not sure why you need to return it 🤔 
> 
> If you need it in the calling function and want to optimize for speed (not sure it makes a lot of difference) you can also compute it in the parent function and pass it as parameter

[link](https://github.com/alan-eu/alan-apps/pull/78216#discussion_r2735844736)

### @bastien-landre-alan on `backend/components/occupational_health/public/queries/billing.py:323` (2026-01-28)
> I don't understand this, it was already computed in the function, the performance should not change.
> I return it because I want to deduplicate customer on profile_id and not on affiliation (that's the whole point of the change)

[link](https://github.com/alan-eu/alan-apps/pull/78216#discussion_r2736272962)

### @MickaelBergem on `backend/components/occupational_health/public/queries/tests/test_billing.py:31` (2026-01-28)
> nano-nit: I tend to align with the existing factory terminology (build = build the entity in memory / create = build and persist it to the DB)
> 
> ```suggestion
> def _build_customer(
> ```

[link](https://github.com/alan-eu/alan-apps/pull/78216#discussion_r2736711715)

### @MickaelBergem on `backend/components/occupational_health/public/queries/tests/test_billing.py:39` (2026-01-28)
> Can't we just use faker for this, [following this announcement](https://alanhealth.slack.com/archives/CB55CK36Y/p1767368902229769)?

[link](https://github.com/alan-eu/alan-apps/pull/78216#discussion_r2736717029)

### @MickaelBergem on `backend/components/occupational_health/public/queries/tests/test_billing.py:77` (2026-01-28)
> Class-based tests :o
> 
> @tony-sanchez do you know why AI gents (Claude here I believe @bastien-landre-alan?) sometimes write unit tests using classes while I thought our convention was functions only? Or is it totally fine using classes? (I would be fine with relaxing that convention)

[link](https://github.com/alan-eu/alan-apps/pull/78216#discussion_r2736727990)

### @MickaelBergem on `backend/components/occupational_health/public/queries/tests/test_billing.py:110` (2026-01-28)
> I wonder if calling the other component's API directly wouldn't be more robust (no idea) - eg `affiliate_member()` IIRC

[link](https://github.com/alan-eu/alan-apps/pull/78216#discussion_r2736732415)

### @MickaelBergem on `backend/components/occupational_health/public/queries/tests/test_billing.py:187` (2026-01-28)
> Hmmm so you aren't testing the actual implementation? 🤔 

[link](https://github.com/alan-eu/alan-apps/pull/78216#discussion_r2736738331)

### @MickaelBergem on `backend/components/occupational_health/public/queries/tests/test_billing.py:207` (2026-01-28)
> Not sure it's worth testing (maintaining tests over loggers is painful from experience)

[link](https://github.com/alan-eu/alan-apps/pull/78216#discussion_r2736740819)

### @MickaelBergem on `backend/components/occupational_health/public/queries/billing.py:247` (2026-01-28)
> ```suggestion
>     # Index customers by profile_id to detect duplicates
> ```

[link](https://github.com/alan-eu/alan-apps/pull/78216#discussion_r2736743355)

### @MickaelBergem on `backend/components/occupational_health/public/queries/billing.py:251` (2026-01-28)
> I wonder if we shouldn't call that `billed_entity_by_profile`, though it's easy to understand based on the type

[link](https://github.com/alan-eu/alan-apps/pull/78216#discussion_r2736749201)

### @MickaelBergem on `backend/components/occupational_health/public/queries/billing.py:263` (2026-01-28)
> nit: my point was to compute the `profile_id` from the `affiliation` in this block, not inside the `_find_customer_to_bill_for_affiliation` function, as it's not something that really gets computed by the function itself.
> 
> From a signature perspective it feels weird to call `find_customer`, give it an affiliation=profile and get more than a `customer` as a result

[link](https://github.com/alan-eu/alan-apps/pull/78216#discussion_r2736759785)

### @MickaelBergem on `backend/components/occupational_health/public/queries/billing.py:287` (2026-01-28)
> @bastien-landre-alan can you remove this TODO since you fixed it? ;)

[link](https://github.com/alan-eu/alan-apps/pull/78216#discussion_r2736767236)

### @MickaelBergem on `backend/components/occupational_health/public/queries/billing.py:301` (2026-01-28)
> Would it be easy to list the affiliations for the given member in the logs? So that we can easily debug when it happens.

[link](https://github.com/alan-eu/alan-apps/pull/78216#discussion_r2736778136)

### @MickaelBergem on `backend/components/occupational_health/public/queries/billing.py:295` (2026-01-28)
> Why a `str` and not `ProfileId`?

[link](https://github.com/alan-eu/alan-apps/pull/78216#discussion_r2736780160)

### @MickaelBergem on `backend/components/occupational_health/public/queries/billing.py:307` (2026-01-28)
> Why not using a `ProfileId`?

[link](https://github.com/alan-eu/alan-apps/pull/78216#discussion_r2736780772)

### @MickaelBergem on `backend/components/occupational_health/public/queries/billing.py:333` (2026-01-28)
> I don't understand why we need to change the signature / what it brings vs just returning the customer data.

[link](https://github.com/alan-eu/alan-apps/pull/78216#discussion_r2736784089)

### @bastien-landre-alan on `backend/components/occupational_health/public/queries/tests/test_billing.py:187` (2026-01-28)
> As said I only test my change (made in the parent as I didn't change _find_customer_to_bill_for_affiliation)
> But will try to add new unit test

[link](https://github.com/alan-eu/alan-apps/pull/78216#discussion_r2736858767)

### @bastien-landre-alan on `backend/components/occupational_health/public/queries/billing.py:263` (2026-01-28)
> ok I understand now I agree

[link](https://github.com/alan-eu/alan-apps/pull/78216#discussion_r2736860002)

### @bastien-landre-alan on `backend/components/occupational_health/public/queries/billing.py:307` (2026-01-28)
> because references_of_employees_affiliated_over_the_year is a list of string so I can it it to avoid looping on it again ti cast it

[link](https://github.com/alan-eu/alan-apps/pull/78216#discussion_r2736888921)

### @bastien-landre-alan on `backend/components/occupational_health/public/queries/billing.py:287` (2026-01-28)
> I would wait for real test on _find_customer_to_bill_for_affiliation

[link](https://github.com/alan-eu/alan-apps/pull/78216#discussion_r2736899116)

### @MickaelBergem on `backend/components/occupational_health/public/queries/billing.py:307` (2026-01-28)
> Can't we store a ProfileId everywhere instead? The original dataclass was created before we added types for these IDs.

[link](https://github.com/alan-eu/alan-apps/pull/78216#discussion_r2737316809)

---

## PR #78226 — Improve Occupational health invoice template

_2026-02-02 • https://github.com/alan-eu/alan-apps/pull/78226_

### @MickaelBergem on `backend/components/billing_occupational_health/internal/business_logic/actions/generate.py:62` (2026-01-29)
> Our public interface should always accept UUID without you needing to type it to AccountId (which is internal). If that's not the case please let us know or directly change it to accept both types ;)

[link](https://github.com/alan-eu/alan-apps/pull/78226#discussion_r2740663747)

### @MickaelBergem on `backend/components/fr/internal/billing/business_logic/actions/create_installment_plans.py:39` (2026-01-29)
> Also update the error message 

[link](https://github.com/alan-eu/alan-apps/pull/78226#discussion_r2740680936)

### @MickaelBergem on `backend/shared/blueprints/content/static/css/2023_style/style.css:1791` (2026-01-29)
> You might want to rework the z-index setup for your templates 😅

[link](https://github.com/alan-eu/alan-apps/pull/78226#discussion_r2740688441)

### @MickaelBergem on `backend/shared/blueprints/content/templates/pdf/breathable_invoice.html:28` (2026-01-29)
> No quarterly periodicity for us? 🤔

[link](https://github.com/alan-eu/alan-apps/pull/78226#discussion_r2740692030)

### @MickaelBergem on `backend/shared/blueprints/content/static/css/2023_style/style.css:1791` (2026-02-02)
> Having more than 4-5 z-index values is usually an anti-pattern. Absolutely nothing urgent of course but it's debt making working with templates a bit harder over time.

[link](https://github.com/alan-eu/alan-apps/pull/78226#discussion_r2753907139)

---

## PR #78233 — feat: Remove Belfius feature flags

_2026-01-28 • https://github.com/alan-eu/alan-apps/pull/78233_

### @bastien-landre-alan on `backend/components/be/internal/claim_management/business_logic/reimbursement/queries/reimbursement_request.py:640` (2026-01-28)
> 😱 thanks for finding and fixing this 🙏 

[link](https://github.com/alan-eu/alan-apps/pull/78233#discussion_r2736046705)

---

## PR #78238 — enh(occupational_health): hide NICs by default

_2026-01-28 • https://github.com/alan-eu/alan-apps/pull/78238_

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/affiliatedMembers/index.tsx:484` (2026-01-28)
> Reduced a bit the label to save space

[link](https://github.com/alan-eu/alan-apps/pull/78238#discussion_r2736067515)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/shared/EmploymentsSection.tsx:41` (2026-01-28)
> I'm now using a non-breaking space to avoid ending up with the following on smaller screens:
> 
> ```
> (NIC:
> 00124)
> ```

[link](https://github.com/alan-eu/alan-apps/pull/78238#discussion_r2736069800)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/affiliatedMembers/index.tsx:489` (2026-01-28)
> I removed it as I wanted to save space + it's a power-user tool (many trained users, few people onboarding on the tool) unlike the admin dashboard or the mobile app

[link](https://github.com/alan-eu/alan-apps/pull/78238#discussion_r2737494884)

---

## PR #78247 — enh(billing): Occh: Marmot - display list of all profile to be used for 2025 comparaison

_2026-01-28 • https://github.com/alan-eu/alan-apps/pull/78247_

### @MickaelBergem on `backend/components/fr/internal/marmot/controllers/occupational_health/billing.py:50` (2026-01-28)
> Why the comment?

[link](https://github.com/alan-eu/alan-apps/pull/78247#discussion_r2736796147)

### @MickaelBergem on `backend/components/occupational_health/public/queries/billing.py:541` (2026-01-28)
> Should we store the UUID/ProfileId directly instead of a str?

[link](https://github.com/alan-eu/alan-apps/pull/78247#discussion_r2736799258)

### @MickaelBergem on `backend/components/occupational_health/public/queries/billing.py:553` (2026-01-28)
> Instead of using the `user_compat` layer, let's just directly get the global_profile_ids instead of the user_ids and use them directly on the ProfileService

[link](https://github.com/alan-eu/alan-apps/pull/78247#discussion_r2736861656)

### @MickaelBergem on `backend/components/occupational_health/public/queries/billing.py:565` (2026-01-28)
> not sure why we need to serialize it? UUIDs are supposed be serialized to string anyway when returned from the backend

[link](https://github.com/alan-eu/alan-apps/pull/78247#discussion_r2736864291)

### @MickaelBergem on `backend/components/occupational_health/public/queries/billing.py:568` (2026-01-28)
> ```suggestion
>                 "customer_name": profile_to_customer_name[profile_id],
> ```

[link](https://github.com/alan-eu/alan-apps/pull/78247#discussion_r2736866067)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/billing/BillingProfiles.tsx:110` (2026-01-28)
> nit: you could build something a tiny bit nicer if it was longer-term, like what I did for discrepancies
> 
> <img width="517" height="511" alt="Image" src="https://github.com/user-attachments/assets/066162c6-ab2a-4d9b-97d3-2510eeba044c" />
> 
> (eg no need to have a column for profile IDs)

[link](https://github.com/alan-eu/alan-apps/pull/78247#discussion_r2736878063)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/billing/useGetBillingDataQuery.ts:67` (2026-01-28)
> I thought we were returning ⁉️ if the first name was empty?
> ```suggestion
>   firstName: string;
>   lastName: string;
> ```

[link](https://github.com/alan-eu/alan-apps/pull/78247#discussion_r2736879584)

### @bastien-landre-alan on `backend/components/occupational_health/public/queries/billing.py:541` (2026-01-28)
> for me InvoiceToGenerateData could be pretty generic, maybe employee reference will not always be profileId

[link](https://github.com/alan-eu/alan-apps/pull/78247#discussion_r2736931764)

---

## PR #78262 — feat(occupational_health): display employments in discrepancies too

_2026-01-28 • https://github.com/alan-eu/alan-apps/pull/78262_

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/marmot.py:269` (2026-01-28)
> @Thomas-Mollard I deduped your code building the data for company with NICs

[link](https://github.com/alan-eu/alan-apps/pull/78262#discussion_r2736686410)

---

## PR #78294 — enh(billing): Occh: Marmot - Fix ci

_2026-01-28 • https://github.com/alan-eu/alan-apps/pull/78294_

### @bastien-landre-alan on `backend/components/occupational_health/public/queries/billing.py:37` (2026-01-28)
> already line 27

[link](https://github.com/alan-eu/alan-apps/pull/78294#discussion_r2737433615)

---

## PR #78304 — enh(billing): Occh: Marmot - Fix unit tests

_2026-01-29 • https://github.com/alan-eu/alan-apps/pull/78304_

### @MickaelBergem — review summary (APPROVED, 2026-01-29)
> I didn't look closely, two thoughts:
> 
> * it looks like a good opportunity to try out Behave
> * I'd like to get rid of the mocks but we don't have proper dependency injection unfortunately

[link](https://github.com/alan-eu/alan-apps/pull/78304#pullrequestreview-3721768193)

---

## PR #78313 — feat(occupational_health): distinguish date_mismatch from date_ended discrepancies

_2026-01-29 • https://github.com/alan-eu/alan-apps/pull/78313_

### @bastien-landre-alan on `backend/components/occupational_health/internal/business_logic/queries/affiliation/discrepancies.py:51` (2026-01-29)
> nit: but reading this I don't understand what does date_ended mean (how can a date end). termination_mismatch is more clear

[link](https://github.com/alan-eu/alan-apps/pull/78313#discussion_r2740886864)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/affiliation/discrepancies.py:51` (2026-01-29)
> Good point will change.

[link](https://github.com/alan-eu/alan-apps/pull/78313#discussion_r2740969243)

### @MickaelBergem — issue comment (2026-01-28)
> This change is part of the following stack:
> 
> - #78308
>     - #78313 ◀
> 
> <sub>Change managed by [git-spice](https://abhinav.github.io/git-spice/).</sub>
> <!-- gs:navigation comment -->
> 

[link](https://github.com/alan-eu/alan-apps/pull/78313#issuecomment-3812599147)

---

## PR #78346 — clean(starter guide): removing deprecated tasks

_2026-01-29 • https://github.com/alan-eu/alan-apps/pull/78346_

### @MickaelBergem — review summary (COMMENTED, 2026-01-29)
> Oh wow I have no idea why Occupational Health owns the file `backend/components/fr/internal/models/enums/admin_onboarding_education_flow_task_type.py` 🤔 
> 
> Do you think you could take it back? 🥺 

[link](https://github.com/alan-eu/alan-apps/pull/78346#pullrequestreview-3723545267)

---

## PR #78377 — enh(occh): Billing - Remove affiliation shorter than 4 days in billing

_2026-01-29 • https://github.com/alan-eu/alan-apps/pull/78377_

### @MickaelBergem — review summary (APPROVED, 2026-01-29)
> Nice! 
> 
> * Check out the slice_timeline helper
> * Can you test the case where the three days are across a billing frontier (eg 2 days in 2025 and 2 days in 2026, or cross-quarter)? : 🙏

[link](https://github.com/alan-eu/alan-apps/pull/78377#pullrequestreview-3722654670)

### @bastien-landre-alan — issue comment (2026-01-29)
> > Nice!
> > 
> >     * Check out the slice_timeline helper
> > 
> >     * Can you test the case where the three days are across a billing frontier (eg 2 days in 2025 and 2 days in 2026, or cross-quarter)? : 🙏
> Right I will update the test, I won't use slice_timeline as I don't have a timeline I think it will be harder to understand why I'm using something with multiple periods
> 

[link](https://github.com/alan-eu/alan-apps/pull/78377#issuecomment-3817669454)

---

## PR #78491 — feat(oh-marmot): enable update and creation of billed entity from marmot

_2026-01-30 • https://github.com/alan-eu/alan-apps/pull/78491_

### @bastien-landre-alan on `backend/components/fr/internal/marmot/controllers/occupational_health/billing.py:130` (2026-01-30)
> The only difference with  CreateBilledEntitySchema is the required ? Maybe we could merge to not have to duplicate each field

[link](https://github.com/alan-eu/alan-apps/pull/78491#discussion_r2745731053)

---

## PR #78674 — enh(occupational_health): ignore eligibility=MANUAL employments in discrepancies

_2026-02-03 • https://github.com/alan-eu/alan-apps/pull/78674_

### @bastien-landre-alan — review summary (APPROVED, 2026-02-02)
> LGTM,
> It's a bit more confusing to have now the elligibilities compute in compute_eligibility_for_affiliation_from_employment but then used also in the discrepancies check. But I think it's fine

[link](https://github.com/alan-eu/alan-apps/pull/78674#pullrequestreview-3741413097)

### @bastien-landre-alan on `backend/components/occupational_health/internal/business_logic/queries/affiliation/discrepancies.py:298` (2026-02-02)
> very nit, I would prefer affiliation_period than aff_period 

[link](https://github.com/alan-eu/alan-apps/pull/78674#discussion_r2755879249)

### @bastien-landre-alan on `backend/components/occupational_health/internal/business_logic/queries/affiliation/discrepancies.py:307` (2026-02-02)
> you could remove (joker behavior), has it's not explain what is a joker
> The description without joker (here and next line) is understandable enough

[link](https://github.com/alan-eu/alan-apps/pull/78674#discussion_r2755883028)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/affiliation/discrepancies.py:298` (2026-02-03)
> Good point

[link](https://github.com/alan-eu/alan-apps/pull/78674#discussion_r2757909143)

---

## PR #78698 — doc: clarify that transfers can include end date

_2026-02-02 • https://github.com/alan-eu/alan-apps/pull/78698_

### @MickaelBergem — review summary (APPROVED, 2026-02-02)
> Thanks! 🙇 
> 
> The documentation is started to be super robust!

[link](https://github.com/alan-eu/alan-apps/pull/78698#pullrequestreview-3739570579)

### @MickaelBergem on `backend/components/employment/public/enums.py:100` (2026-02-02)
> ```suggestion
>     NB: A transfer can also have an end_date in the new company in case it's already known.
> ```

[link](https://github.com/alan-eu/alan-apps/pull/78698#discussion_r2754468760)

---

## PR #78927 — feat(oh): display affiliated members table in billing affiliation errors

_2026-02-03 • https://github.com/alan-eu/alan-apps/pull/78927_

### @bastien-landre-alan — review summary (APPROVED, 2026-02-03)
> Some comments. I thinks affiliationTable start to be a bit big, but ok to merge it (to unblock error) and iterate if needed 

[link](https://github.com/alan-eu/alan-apps/pull/78927#pullrequestreview-3746148773)

### @bastien-landre-alan on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/affiliatedMembers/index.tsx:71` (2026-02-03)
> If you remove useGetAffiliatedMembersQuery should you not pass affiliatedMembers for the affiliation tower ?
> 
> And I don't understand why it's now a parameters, I thinks it's easier to keep AffiliatedMembersTable fetching the affiliated member and filter from parameters in it's props

[link](https://github.com/alan-eu/alan-apps/pull/78927#discussion_r2759830292)

### @bastien-landre-alan on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/affiliatedMembers/index.tsx:55` (2026-02-03)
> This is not affiliation error but BillingError here

[link](https://github.com/alan-eu/alan-apps/pull/78927#discussion_r2759839650)

### @bastien-landre-alan on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/affiliatedMembers/index.tsx:307` (2026-02-03)
> as said handling billing error is  is a bit weird, as this table start to handle a lot of different things.
> But ok to start like this for now

[link](https://github.com/alan-eu/alan-apps/pull/78927#discussion_r2759859693)

---

## PR #79017 — Notify occupational health on call when merging users

_2026-02-05 • https://github.com/alan-eu/alan-apps/pull/79017_

### @bastien-landre-alan — review summary (COMMENTED, 2026-02-05)
> LGTM for the code/
> 
> But @MickaelBergem when merging user should we not also merge occupational_health profile, occupationalhealthvisit (other visit data model).

[link](https://github.com/alan-eu/alan-apps/pull/79017#pullrequestreview-3756978085)

### @MickaelBergem — review summary (APPROVED, 2026-02-05)
> LGTM, with a few comments to address (including the point of having a second event bus 🤔)

[link](https://github.com/alan-eu/alan-apps/pull/79017#pullrequestreview-3757054598)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/actions/merge_users.py:157` (2026-02-04)
> Can you post on `#test` when not in prod? It'll allow you to actually test.
> 
> Check for other occurrences in the `occupational_health` component, we've been doing that a lot.

[link](https://github.com/alan-eu/alan-apps/pull/79017#discussion_r2763434266)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/actions/merge_users.py:157` (2026-02-04)
> You should not read the spreadsheets directly. The same data is available through the two `Turing*` models I mentioned in Linear, saving you a connection to GSheet. It should also fix the test as things will be simpler.

[link](https://github.com/alan-eu/alan-apps/pull/79017#discussion_r2763451908)

### @bastien-landre-alan on `backend/components/occupational_health/public/business_logic/actions/merge_users.py:39` (2026-02-05)
> Why are we doing this assert ? internal_event_bus can be None ?

[link](https://github.com/alan-eu/alan-apps/pull/79017#discussion_r2769070316)

### @bastien-landre-alan on `backend/components/occupational_health/public/business_logic/actions/merge_users.py:34` (2026-02-05)
> Why do you handle 2 buses ? Could we not only used internal one or make the parameter mandatory ?
> (I don't know this part so it's more to understand than to challenge)

[link](https://github.com/alan-eu/alan-apps/pull/79017#discussion_r2769086735)

### @bastien-landre-alan on `backend/components/occupational_health/public/business_logic/actions/merge_users.py:21` (2026-02-05)
> You should say that you are merging visits also

[link](https://github.com/alan-eu/alan-apps/pull/79017#discussion_r2769097813)

### @bastien-landre-alan on `backend/components/occupational_health/internal/business_logic/actions/merge_users.py:99` (2026-02-05)
> Here you are not realy merging visit, but only send notification if we should do it in files

[link](https://github.com/alan-eu/alan-apps/pull/79017#discussion_r2769111722)

### @MickaelBergem on `backend/components/fr/internal/business_logic/company/actions/employment.py:1495` (2026-02-05)
> I think we should apply in all cases, but pass `commit=save` to let the other end know what it's about.
> 
> Amiright @mstmb-alan ?

[link](https://github.com/alan-eu/alan-apps/pull/79017#discussion_r2769137162)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/actions/merge_users.py:24` (2026-02-05)
> cc @Universemul let us know if there is a better place to store these URLs, they are used for Slack messages only

[link](https://github.com/alan-eu/alan-apps/pull/79017#discussion_r2769139466)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/actions/merge_users.py:99` (2026-02-05)
> Good point, let's rename the function (`notify_about_...`?)

[link](https://github.com/alan-eu/alan-apps/pull/79017#discussion_r2769141410)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/actions/merge_users.py:123` (2026-02-05)
> Let's avoid one-letter variable names: with modern IDEs there is little reason to keep short variable names.
> 
> Here I'm confused as an engineer, as I don't know what `n` is. Is it the index of the row? The user ID? The name of the spreadsheet?

[link](https://github.com/alan-eu/alan-apps/pull/79017#discussion_r2769148471)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/actions/merge_users.py:147` (2026-02-05)
> First time I see this syntax. We don't need to provide the table name against which we do the SELECT? 🤔 

[link](https://github.com/alan-eu/alan-apps/pull/79017#discussion_r2769152745)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/actions/merge_users.py:165` (2026-02-05)
> 👍 the screenshot in the PR description said eng_oncall, happy to see it's prevenir_oncall (Ops) instead 🙏 

[link](https://github.com/alan-eu/alan-apps/pull/79017#discussion_r2769157605)

### @MickaelBergem on `backend/components/occupational_health/public/business_logic/actions/tests/test_merge_users.py:177` (2026-02-05)
> There is an existing Slack pytest fixture I believe (something we wrote), so that you don't have to do this patch yourself.

[link](https://github.com/alan-eu/alan-apps/pull/79017#discussion_r2769164922)

### @MickaelBergem on `backend/components/occupational_health/public/business_logic/actions/merge_users.py:21` (2026-02-05)
> We are not merging visits

[link](https://github.com/alan-eu/alan-apps/pull/79017#discussion_r2769168853)

### @MickaelBergem on `backend/components/occupational_health/public/business_logic/actions/merge_users.py:34` (2026-02-05)
> Same question

[link](https://github.com/alan-eu/alan-apps/pull/79017#discussion_r2769170596)

### @MickaelBergem on `backend/components/occupational_health/public/business_logic/actions/merge_users.py:39` (2026-02-05)
> We should also try avoiding `assert` outside of tests. Either raise an explicit exception, or assume it's good (`mandatory(event_bus)` can be your friend if `mypy` is complaining and you are sure the value will never be `None`).

[link](https://github.com/alan-eu/alan-apps/pull/79017#discussion_r2769175578)

### @bastien-landre-alan on `backend/components/occupational_health/public/business_logic/actions/merge_users.py:21` (2026-02-05)
> Yes sorry, added this commend before checking `merge_occupational_health_user_visits` content 

[link](https://github.com/alan-eu/alan-apps/pull/79017#discussion_r2769184558)

---

## PR #79049 — Clarify installment plan on Occ health invoices

_2026-02-04 • https://github.com/alan-eu/alan-apps/pull/79049_

### @bastien-landre-alan — review summary (APPROVED, 2026-02-04)
> 🎉 

[link](https://github.com/alan-eu/alan-apps/pull/79049#pullrequestreview-3751047390)

### @bastien-landre-alan on `backend/components/billing_occupational_health/internal/business_logic/queries/invoices_data.py:161` (2026-02-04)
> nit: it's not automatic, the customer can ask for installment plan if more than 20 employees.
> In your can I think you should only say "the customer requested one for the billed year" (something like that) and not talk about 20 employees as it's not a hard rule

[link](https://github.com/alan-eu/alan-apps/pull/79049#discussion_r2764002860)

---

## PR #79191 — enh(occh): Affiliation : Enable aligning affiliation date

_2026-02-06 • https://github.com/alan-eu/alan-apps/pull/79191_

### @bastien-landre-alan on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/affiliatedMembers/AffiliationDiscrepanciesModal.tsx:92` (2026-02-05)
> very big diff but only because I added <> that updated formating

[link](https://github.com/alan-eu/alan-apps/pull/79191#discussion_r2769145034)

### @bastien-landre-alan on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/affiliatedMembers/AffiliationDiscrepanciesModal.tsx:260` (2026-02-05)
> I added this modal

[link](https://github.com/alan-eu/alan-apps/pull/79191#discussion_r2769146578)

### @bastien-landre-alan on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/affiliatedMembers/AffiliationDiscrepanciesModal.tsx:243` (2026-02-05)
> I added this button

[link](https://github.com/alan-eu/alan-apps/pull/79191#discussion_r2769147714)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/affiliatedMembers/AlignAffiliationDatesAction.tsx:91` (2026-02-05)
> "cancel the termination" is better known (at least in the Employment taxonomy) as a "resumption" ([see here](https://mkdocs.alan.com/components/employment/api_reference/?h=resumption#components.employment.public.enums.EmploymentChangeType.resumption)).
> 
> Today Ops don't really know/use this wording, and we could either push it so that they learn what it is, or try to explain it simply for them (like what you did). No strong opinion.

[link](https://github.com/alan-eu/alan-apps/pull/79191#discussion_r2770062121)

### @MickaelBergem on `backend/components/fr/internal/marmot/controllers/occupational_health/affiliated_members.py:406` (2026-02-05)
> Doing a quick check [here](https://alanhealth.slack.com/archives/C19FZEB41/p1770309065222669) to ensure it's still the recommended way to get the user moving forward

[link](https://github.com/alan-eu/alan-apps/pull/79191#discussion_r2770084124)

### @MickaelBergem on `backend/components/fr/internal/marmot/controllers/occupational_health/affiliated_members.py:394` (2026-02-05)
> I think it would make more sense to pass the `affiliation_id` you want to edit directly, but I don't think we have it on the frontend side right? Just the timeline of all affiliations?

[link](https://github.com/alan-eu/alan-apps/pull/79191#discussion_r2770089764)

### @MickaelBergem on `backend/components/occupational_health/public/marmot/actions.py:213` (2026-02-05)
> You should explain what's the behavior when more than one non-cancelled affiliation exists.

[link](https://github.com/alan-eu/alan-apps/pull/79191#discussion_r2770091362)

### @MickaelBergem on `backend/components/occupational_health/public/marmot/actions.py:256` (2026-02-05)
> How is this handled in the frontend? Do Ops get a proper and actionable error message (ping Eng)? Is this sent to Sentry (I'd prefer we don't).

[link](https://github.com/alan-eu/alan-apps/pull/79191#discussion_r2770095229)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/affiliatedMembers/AffiliationDiscrepanciesModal.tsx:92` (2026-02-05)
> In those cases I recommend reviewers to review with whitespace diff off:
> 
> <img width="2263" height="1027" alt="Image" src="https://github.com/user-attachments/assets/fa292dac-47dd-4812-892d-442a47b11324" />

[link](https://github.com/alan-eu/alan-apps/pull/79191#discussion_r2770100770)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/affiliatedMembers/AffiliationDiscrepanciesModal.tsx:243` (2026-02-05)
> I would disable the button if we detect multiple affiliations as it won't work (but keep the button displayed for consistency). And add a tooltip to explain why it's disabled and more importantly, what Ops should do instead.

[link](https://github.com/alan-eu/alan-apps/pull/79191#discussion_r2770104773)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/affiliatedMembers/AlignAffiliationDatesAction.tsx:1` (2026-02-05)
> I'm starting to think it would make sense to move discrepancy-related code to a subfolder

[link](https://github.com/alan-eu/alan-apps/pull/79191#discussion_r2770106705)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/affiliatedMembers/AlignAffiliationDatesAction.tsx:40` (2026-02-05)
> Ah nice! You could have showcased it in the video

[link](https://github.com/alan-eu/alan-apps/pull/79191#discussion_r2770108410)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/affiliatedMembers/AffiliationDiscrepanciesModal.tsx:243` (2026-02-05)
> Ok I saw you're disabling a button further inside the modal. Both work.

[link](https://github.com/alan-eu/alan-apps/pull/79191#discussion_r2770114922)

### @MickaelBergem on `backend/components/occupational_health/public/marmot/actions.py:256` (2026-02-05)
> Ok I saw.

[link](https://github.com/alan-eu/alan-apps/pull/79191#discussion_r2770115533)

### @bastien-landre-alan on `backend/components/fr/internal/marmot/controllers/occupational_health/affiliated_members.py:394` (2026-02-05)
> yes we only have the timeline, and it's "ok" because the action is only available if you have one affiliation (so current one), you can't update a past one (we also check on the backend)

[link](https://github.com/alan-eu/alan-apps/pull/79191#discussion_r2770226740)

---

## PR #79234 — enh(occh): Billing tower: Add button to generate fees and generate invoice

_2026-02-10 • https://github.com/alan-eu/alan-apps/pull/79234_

### @bastien-landre-alan on `backend/components/billing_occupational_health/internal/controllers/invoices.py:93` (2026-02-05)
> @gagnadref is it ok here to call this instead of get_invoice_data (that will recompute everything)
> I could have a billed entities that didn't had any billing data so no fees. No invoice should be generated and that's all no ?

[link](https://github.com/alan-eu/alan-apps/pull/79234#discussion_r2769962294)

### @bastien-landre-alan on `backend/components/billing_occupational_health/internal/controllers/generate_invoices.py:26` (2026-02-06)
> @gagnadref 
> The thing is PreviewInvoice target only one invoice so take a contract ref as parameter, and GenerateInvoices handle multiple invoice and take an account_id
> We are not handling the same thing.
> I didn't want to create an "account" endpoint (because we don't handle account in billing) but maybe I should have (to group generate invoice and update fees)

[link](https://github.com/alan-eu/alan-apps/pull/79234#discussion_r2773713014)

---

## PR #79242 — fix(employment): don't load ALL ExtendedEmploymentUpdateModel...

_2026-02-05 • https://github.com/alan-eu/alan-apps/pull/79242_

### @MickaelBergem on `backend/components/employment/internal/business_logic/queries/extended_employment_updates.py:76` (2026-02-05)
> This had only be tested on members who had at least one employment, so the dict was never empty. But when it is, we just don't add any filter 😅 

[link](https://github.com/alan-eu/alan-apps/pull/79242#discussion_r2770025291)

---

## PR #79345 — feat(occupational-health): add issued invoices view for admin dashboard and marmot

_2026-02-09 • https://github.com/alan-eu/alan-apps/pull/79345_

### @bastien-landre-alan — review summary (APPROVED, 2026-02-06)
> Ok, but some comments.
> On marmot it's ok like this but I think it would be easier to display invoice on the billed entities table (too many accordion on the page, and yes it's part my fault :D )

[link](https://github.com/alan-eu/alan-apps/pull/79345#pullrequestreview-3762343269)

### @bastien-landre-alan on `backend/components/fr/internal/marmot/controllers/occupational_health/billing.py:336` (2026-02-06)
> I would put this in `backend/components/billing_occupational_health ` component.
> Even the API I think

[link](https://github.com/alan-eu/alan-apps/pull/79345#discussion_r2773516926)

### @bastien-landre-alan on `backend/components/occupational_health/internal/queries/invoices.py:31` (2026-02-06)
> you could use get_billed_entities_for_account

[link](https://github.com/alan-eu/alan-apps/pull/79345#discussion_r2773527492)

### @bastien-landre-alan on `backend/components/occupational_health/internal/queries/invoices.py:48` (2026-02-06)
> Sad that there is no public api to get invoices

[link](https://github.com/alan-eu/alan-apps/pull/79345#discussion_r2773546565)

### @bastien-landre-alan on `backend/components/fr/internal/marmot/controllers/occupational_health/billing.py:349` (2026-02-06)
> why do you rename it ?

[link](https://github.com/alan-eu/alan-apps/pull/79345#discussion_r2773551976)

### @bastien-landre-alan on `frontend/apps/fr-app/js/app/dashboard/occupationalHealth/invoices/Invoices.tsx:22` (2026-02-06)
> not sure to understand, we are getting invoice data but return Billed entities ?
> why are we needing this ?

[link](https://github.com/alan-eu/alan-apps/pull/79345#discussion_r2773563141)

### @bastien-landre-alan on `frontend/apps/fr-app/js/app/dashboard/occupationalHealth/invoices/Invoices.tsx:40` (2026-02-06)
> rename selectedEntity in selectedContractRef ?

[link](https://github.com/alan-eu/alan-apps/pull/79345#discussion_r2773565343)

### @bastien-landre-alan on `frontend/apps/fr-app/js/app/dashboard/occupationalHealth/invoices/Invoices.tsx:22` (2026-02-06)
> ok understand more now,
> Should we not call API to get the list of entities here ? Do at least be able to display that there is no invoice for this entity

[link](https://github.com/alan-eu/alan-apps/pull/79345#discussion_r2773569738)

### @bastien-landre-alan on `frontend/apps/fr-app/js/app/dashboard/occupationalHealth/invoices/InvoicesTable.tsx:20` (2026-02-06)
> not sure about the impact about pagination, as everything is loaded and it's simple to display.
> maybe a bit more than 10 as big mamma has 22 entities
> 

[link](https://github.com/alan-eu/alan-apps/pull/79345#discussion_r2773581689)

### @bastien-landre-alan on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/billing/IssuedInvoicesSection.tsx:30` (2026-02-06)
> As we already get the billed entities in this page, I think it could be easier to merge both table (maybe display invoices under each entities ?)

[link](https://github.com/alan-eu/alan-apps/pull/79345#discussion_r2773591801)

---

## PR #79352 — fix(occh): Billing : filter employment on period we want to bill

_2026-02-06 • https://github.com/alan-eu/alan-apps/pull/79352_

### @bastien-landre-alan on `backend/components/occupational_health/public/queries/billing.py:463` (2026-02-06)
> Thanks will merge as is and work on readability 

[link](https://github.com/alan-eu/alan-apps/pull/79352#discussion_r2774005379)

---

## PR #79360 — fix(oh): remove returning contract start and end date and remove args in endpoint

_2026-02-06 • https://github.com/alan-eu/alan-apps/pull/79360_

### @bastien-landre-alan — review summary (APPROVED, 2026-02-06)
> In this case could you update marmot page to display billed entities on top of the period selection (and maybe directly call the api to display the table)

[link](https://github.com/alan-eu/alan-apps/pull/79360#pullrequestreview-3762471592)

---

## PR #79382 — infra(occupational_health): whitelist new HPs in ZeroTrust

_2026-02-06 • https://github.com/alan-eu/alan-apps/pull/79382_

### @MickaelBergem — issue comment (2026-02-06)
> I'm applying my own change before it's merged.
> 
> @BenjaminAlan it looks like the Krys whitelist isn't applied though ([see above](https://github.com/alan-eu/alan-apps/pull/79382#issuecomment-3860328084)) - I don't care but maybe you could be interested

[link](https://github.com/alan-eu/alan-apps/pull/79382#issuecomment-3860341481)

---

## PR #79511 — Medical Secrecy: setup Flask-smorest and auth context providers

_2026-03-09 • https://github.com/alan-eu/alan-apps/pull/79511_

### @MickaelBergem — review summary (APPROVED, 2026-02-12)
> Code looks OK but I would feel more confident if we did heavy testing before releasing this, as now downtimes on the medical software have a big impact...

[link](https://github.com/alan-eu/alan-apps/pull/79511#pullrequestreview-3790148599)

### @MickaelBergem on `backend/components/occupational_health/internal/blueprint.py:6` (2026-02-12)
> nit @AdamSelene it would be helpful to use the kw args to explicit why we need to pass this string twice, something like this would be more readable and would help teams understand better Flask Smorest
> ```suggestion
>     name="occupational_health", url_prefix="occupational_health"
> ```

[link](https://github.com/alan-eu/alan-apps/pull/79511#discussion_r2798111548)

### @MickaelBergem on `backend/components/medical_secrecy/bootstrap/blueprint.py:39` (2026-02-12)
> I'm surprised these prefixes are added here but not removed anywhere else. Have you double checked it works?

[link](https://github.com/alan-eu/alan-apps/pull/79511#discussion_r2798119581)

### @MickaelBergem on `backend/apps/medical_secrecy/__init__.py:49` (2026-02-12)
> Curiosity: can you explain why this is now before the `fast_exit`? Is there an impact on the app boot time?

[link](https://github.com/alan-eu/alan-apps/pull/79511#discussion_r2798124869)

---

## PR #79513 — [BUSINESS] - Medical Secrecy: setup transaction auth context table

_2026-02-17 • https://github.com/alan-eu/alan-apps/pull/79513_

### @MickaelBergem on `backend/apps/medical_secrecy/__init__.py:37` (2026-02-13)
> nit: @AdamSelene can you document why we need to load these models early? Can we just import them right before building `medical_secrecy_admin_config`? It will help engineers be more confident when reworking the code.

[link](https://github.com/alan-eu/alan-apps/pull/79513#discussion_r2803633097)

---

## PR #79594 — Display error when affiliation decision fails

_2026-02-09 • https://github.com/alan-eu/alan-apps/pull/79594_

### @MickaelBergem — review summary (APPROVED, 2026-02-09)
> Did you actually test with an overlapping affiliation?

[link](https://github.com/alan-eu/alan-apps/pull/79594#pullrequestreview-3772885729)

### @MickaelBergem — issue comment (2026-02-09)
> > > Did you actually test with an overlapping affiliation?
> > 
> > @MickaelBergem I created fake data with overlapping affiliation in the screencast shared in the PR description, did you see it ? If so, I'm not sure I understand your question :/
> 
> My bad 🤦 Not sure how I missed it... sorry for the noise.

[link](https://github.com/alan-eu/alan-apps/pull/79594#issuecomment-3871390863)

---

## PR #79655 — enh(occupational_health): always use proper Slack handle for affiliation alerts

_2026-02-09 • https://github.com/alan-eu/alan-apps/pull/79655_

### @MickaelBergem — issue comment (2026-02-09)
> Tested directly on the real Slack workspace:
> 
> <img width="878" height="279" alt="image" src="https://github.com/user-attachments/assets/1da2ec85-54b1-4da9-a70a-44e29b29027a" />
> 
> 
> <img width="530" height="118" alt="image" src="https://github.com/user-attachments/assets/ca8f405f-daa4-423b-97ce-e3c20783f88a" />
> 

[link](https://github.com/alan-eu/alan-apps/pull/79655#issuecomment-3872536678)

---

## PR #79686 — Skip mid-career visit for newcomers without initial VIP

_2026-02-16 • https://github.com/alan-eu/alan-apps/pull/79686_

### @MickaelBergem — review summary (COMMENTED, 2026-02-09)
> @Universemul I wonder if we shouldn't be smarter about this and flag that the mid-career visit needs to be grouped with the VIP. How do you feel about this?
> 
> I think in the long term we would want the visit engine to return a grouped visit so that HPs know they are supposed to do **both the VIP and the mid-career visit**. We would then handle hiding the mid-career visit requirement when displaying it in the admin dashboard (at display time instead of at computing time). But I don't think we'll have grouped visit types anytime soon, right?
> 
> In a shorter term, maybe we should have a flag `hide_mid_career_visits_if_before_initial_vip` defaulting to `False` unless it's called from the admin dashboard code?

[link](https://github.com/alan-eu/alan-apps/pull/79686#pullrequestreview-3774464625)

### @MickaelBergem — review summary (APPROVED, 2026-02-13)
> @Universemul do you confirm you are OK with this change and you will own the next steps?

[link](https://github.com/alan-eu/alan-apps/pull/79686#pullrequestreview-3796619650)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/visits/tests/test_next_visit_deadline.py:57` (2026-02-13)
> Hmm I still think in this case, the mid-career visit should be listed no? 🤔 

[link](https://github.com/alan-eu/alan-apps/pull/79686#discussion_r2803607774)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/visits/next_visit_deadline.py:281` (2026-02-13)
> at this point HPs won't know they have to do it 😬 but OK in the short term
> 
> (cc @Universemul)

[link](https://github.com/alan-eu/alan-apps/pull/79686#discussion_r2803617056)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/visits/tests/test_next_visit_deadline.py:57` (2026-02-13)
> I know _why_ this was removed, I just don't agree. The function is supposed to return the next deadlines: here it'd be both the VIP (now) and the mid-career visit (in a few years).
> 
> I think we should only hide the mid-career visit if its deadline is _before_ the VIP deadline but _after_ the employment/affiliation start, no?

[link](https://github.com/alan-eu/alan-apps/pull/79686#discussion_r2804499127)

### @MickaelBergem — issue comment (2026-02-09)
> > **Employee over 45, VIP done and mid-career in the future**
> 
> @williamoccelli This is not what the screenshot shows. We should see the VIP as "last visit" no?
> 
> Can you also clarify in the headers of the screenshots if there is supposed to be a difference or if you're showing us that it's unchanged?

[link](https://github.com/alan-eu/alan-apps/pull/79686#issuecomment-3873001478)

### @MickaelBergem — issue comment (2026-02-10)
> @Universemul gentle ping on this PR 😇 

[link](https://github.com/alan-eu/alan-apps/pull/79686#issuecomment-3878801834)

---

## PR #79690 — feat(oh): add download invoice button in marmot and admin dashboard

_2026-02-10 • https://github.com/alan-eu/alan-apps/pull/79690_

### @bastien-landre-alan — review summary (APPROVED, 2026-02-10)
> LGTM but I still think the code should be in billing_occupational_health component (weird that to preview an invoice everything is there, but not to download it)

[link](https://github.com/alan-eu/alan-apps/pull/79690#pullrequestreview-3777417756)

### @bastien-landre-alan on `backend/components/occupational_health/internal/queries/invoices.py:92` (2026-02-10)
> ```suggestion
> def get_invoice_file_for_account(account_id: AccountId, invoice_id: int) -> InvoiceFileData:
> ```

[link](https://github.com/alan-eu/alan-apps/pull/79690#discussion_r2786484259)

### @bastien-landre-alan on `backend/components/occupational_health/internal/queries/invoices.py:110` (2026-02-10)
> billed_entities_query => contract_ref_query ?

[link](https://github.com/alan-eu/alan-apps/pull/79690#discussion_r2786490366)

---

## PR #79735 — enh(ohset): replace RuntimeError with BaseErrorCode

_2026-02-10 • https://github.com/alan-eu/alan-apps/pull/79735_

### @MickaelBergem — review summary (APPROVED, 2026-02-10)
> Hmm I would prefer if we could test first. Can you test with [this spreadsheet](https://docs.google.com/spreadsheets/d/1GNQE53I2kRKHcPhpNVvvsavh62zSQ2XdBMziTfR445o/edit?gid=1085694854#gid=1085694854) against Kay? You can try adding an invalid user ID to see the behavior before/after.

[link](https://github.com/alan-eu/alan-apps/pull/79735#pullrequestreview-3778006789)

---

## PR #79772 — [Chore] Remove Mind momo component

_2026-03-02 • https://github.com/alan-eu/alan-apps/pull/79772_

### @MickaelBergem — review summary (APPROVED, 2026-03-02)
> YES! Thanks A LOT for doing this @tchapi.
> 
> One additional question: did you check with Data if the models weren't used in some important question / queries / data lake fed back to the product?

[link](https://github.com/alan-eu/alan-apps/pull/79772#pullrequestreview-3875328519)

---

## PR #79789 — Occupational health internal tool doctolib user matching

_2026-02-11 • https://github.com/alan-eu/alan-apps/pull/79789_

### @MickaelBergem — review summary (APPROVED, 2026-02-10)
> Beware of one edge case: where there is a cell with a comma, or a newline in it, it messes up with the entire spreadsheet. In the affiliator, we check for structure and we let the user know (with the row number, etc) so they can fix it. The best solution is to "export as TSV / CSV" and then paste but it's painful and we don't do it usually.
> 
> I hope it won't bite you here.

[link](https://github.com/alan-eu/alan-apps/pull/79789#pullrequestreview-3779988735)

### @MickaelBergem on `backend/components/fr/internal/marmot/business_logic/queries/visit_management/doctolib_export_matching.py:1` (2026-02-10)
> Is this file empty? 🤔 

[link](https://github.com/alan-eu/alan-apps/pull/79789#discussion_r2788868297)

### @MickaelBergem on `backend/components/fr/internal/marmot/controllers/occupational_health/visit_management.py:44` (2026-02-10)
> Here let's raise if we don't have it, the `MatchUsersSchema` is supposed to ensure it's never empty / falsy.
> 
> ```suggestion
>     data = body["data"]
> ```

[link](https://github.com/alan-eu/alan-apps/pull/79789#discussion_r2788895086)

### @MickaelBergem on `backend/components/fr/internal/marmot/controllers/occupational_health/visit_management.py:60` (2026-02-10)
> So we never send anything to Sentry if something breaks? Ideally you should make the difference between "expected" errors (leading to a 400) and "unexpected" ones (500 + log to Sentry, which you can do by just not catching them)

[link](https://github.com/alan-eu/alan-apps/pull/79789#discussion_r2788901817)

### @MickaelBergem on `backend/components/occupational_health/internal/entities/visit_management/doctolib_user_matching.py:8` (2026-02-10)
> If an Ops renames one of the columns, this will break right? Is there a way to only specify the ones we actually need? Or is it needed anyway to paste it back?

[link](https://github.com/alan-eu/alan-apps/pull/79789#discussion_r2788907682)

### @MickaelBergem on `backend/components/occupational_health/public/queries/doctolib_user_matching.py:16` (2026-02-10)
> 😢 
> 
> Ok but let's:
> 
> 1. try to inline the imports so that we don't need to load too much of `fr` if running unrelated tests
> 2. add a TODO with a reminder in the code `# TODO: @david.barthelemy 2026-09-01 let's remove this now!` so that you at least get pinged by Beaver in the future about it
> 
> For the company IDs and employments, I think we already have queries in `occupational_health` (or directly in the `employment` component). For the search I don't think we can easily reuse the matching logic I'm using in the Affiliator unfortunately (requires the SSN, etc) so OK to keep using `perform_search`.

[link](https://github.com/alan-eu/alan-apps/pull/79789#discussion_r2788931209)

### @MickaelBergem on `backend/components/occupational_health/public/queries/doctolib_user_matching.py:54` (2026-02-10)
> Can't you use `csv.DictReader` instead? It takes care of everything directly, check out the implementation in the affiliator...

[link](https://github.com/alan-eu/alan-apps/pull/79789#discussion_r2788935976)

### @MickaelBergem on `backend/components/occupational_health/public/queries/doctolib_user_matching.py:71` (2026-02-10)
> the DictReader will give you a `dict` directly so that you don't have to build it yourself, and you can then use `UserVisitData.from_dict(data)`, which performs some type conversion / checking (here you have only strings so we don't care but it's a good habit to take)

[link](https://github.com/alan-eu/alan-apps/pull/79789#discussion_r2788942016)

### @MickaelBergem on `backend/components/occupational_health/public/queries/doctolib_user_matching.py:86` (2026-02-10)
> It really smells like N+1 queries, but I assume the code from `fr` is already preloading the relationship.
> 
> However you should really use the employment component instead of this, it's more future proof.
> 
> And why are you taking the health enrollment, instead of the Prévenir affiliation? 🤔 

[link](https://github.com/alan-eu/alan-apps/pull/79789#discussion_r2788952992)

### @MickaelBergem on `backend/components/occupational_health/public/queries/doctolib_user_matching.py:101` (2026-02-10)
> "The user in account because" is not super clear

[link](https://github.com/alan-eu/alan-apps/pull/79789#discussion_r2788963207)

### @MickaelBergem on `backend/components/occupational_health/public/queries/doctolib_user_matching.py:101` (2026-02-10)
> Why not returning an array and letting Ops sort this out? At least it'll be easier/possible to make the difference between "no employment" and "several employments"

[link](https://github.com/alan-eu/alan-apps/pull/79789#discussion_r2788965424)

### @MickaelBergem on `backend/components/occupational_health/public/queries/doctolib_user_matching.py:132` (2026-02-10)
> nit: same here `UserVisitData.from_dict(data)` would help serializing the UUIDs, etc

[link](https://github.com/alan-eu/alan-apps/pull/79789#discussion_r2788976452)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/visitManagementMatching/index.tsx:18` (2026-02-10)
> Let's add a docstring to document what this tool is for

[link](https://github.com/alan-eu/alan-apps/pull/79789#discussion_r2788982130)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/visitManagementMatching/index.tsx:18` (2026-02-10)
> nit: I'd prefer using a string for the `user_id` as it's what we're doing across all of Occupational Health + I'm always scared of what JS will do with number-indexed arrays 😅 

[link](https://github.com/alan-eu/alan-apps/pull/79789#discussion_r2788986911)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/visitManagementMatching/index.tsx:55` (2026-02-10)
> I don't understand why you are not using the isLoading from the mutation 🤔 

[link](https://github.com/alan-eu/alan-apps/pull/79789#discussion_r2788990474)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/visitManagementMatching/index.tsx:51` (2026-02-10)
> Why don't you display the error here? Some errors are easy to fix directly by Ops...

[link](https://github.com/alan-eu/alan-apps/pull/79789#discussion_r2788992237)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/visitManagementMatching/index.tsx:73` (2026-02-10)
> How come we have snake_case properties in the JS world? 🤔 

[link](https://github.com/alan-eu/alan-apps/pull/79789#discussion_r2788997653)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/visitManagementMatching/index.tsx:73` (2026-02-10)
> Ah ok you chose to keep a datastructure aligned with the TSV headers, makes sense.

[link](https://github.com/alan-eu/alan-apps/pull/79789#discussion_r2789005641)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/visitManagementMatching/useMatchUsersQuery.ts:15` (2026-02-10)
> instead of camelCaseApi 👌 

[link](https://github.com/alan-eu/alan-apps/pull/79789#discussion_r2789007587)

---

## PR #79840 — doc: add more details on how to use the validity_period of ExtendedInformation

_2026-02-10 • https://github.com/alan-eu/alan-apps/pull/79840_

### @MickaelBergem on `backend/components/employment/public/entities.py:171` (2026-02-10)
> ```suggestion
>     💡 `validity_period=None` doesn't mean "the value is valid for the whole employment for now",
>     it means it can never change during the employment, even in the future.
>     This is an important distinction for the way the Employment Component handles updates to extended values.
>     For instance, in 🇫🇷 the NIC extended value can change over time so it should always have a validity period (not checked at runtime as it's country-specific).
> ```

[link](https://github.com/alan-eu/alan-apps/pull/79840#discussion_r2789198270)

### @MickaelBergem on `backend/components/employment/public/entities.py:171` (2026-02-10)
> I wonder if replacing the 🇫🇷 TypedDict for ExtendedValues to always check if `nic` as a validity period would be too hacky or not...

[link](https://github.com/alan-eu/alan-apps/pull/79840#discussion_r2789209181)

---

## PR #79879 — fix(oh-invoice): fix contract link for occupational health invoice

_2026-02-12 • https://github.com/alan-eu/alan-apps/pull/79879_

### @MickaelBergem — review summary (APPROVED, 2026-02-11)
> One small note on ownership of the complexity

[link](https://github.com/alan-eu/alan-apps/pull/79879#pullrequestreview-3783376653)

### @MickaelBergem on `backend/components/fr/internal/billing/models/invoice.py:295` (2026-02-11)
> Is there a way to move this logic inside `occupational_health` through some public `get_flask_admin_url_for_contract(contract_ref)` query? I would prefer we keep owning it on our side, without having `fr` making any assumption over the structure of the contract_ref.

[link](https://github.com/alan-eu/alan-apps/pull/79879#discussion_r2791930846)

### @MickaelBergem on `backend/components/fr/internal/billing/models/invoice.py:298` (2026-02-11)
> ```suggestion
>                     f"Incorrect siret or siren on invoice {self.id} from contract_ref {self.contract_ref}"
> ```

[link](https://github.com/alan-eu/alan-apps/pull/79879#discussion_r2791931468)

### @MickaelBergem on `backend/components/occupational_health/internal/models/occupational_health_billed_entity.py:19` (2026-02-11)
> 🙏 

[link](https://github.com/alan-eu/alan-apps/pull/79879#discussion_r2791932369)

---

## PR #79961 — feat(oh): add analyze discrepancy fixes endpoint

_2026-02-16 • https://github.com/alan-eu/alan-apps/pull/79961_

### @bastien-landre-alan on `backend/components/fr/internal/marmot/controllers/occupational_health/affiliated_members.py:749` (2026-02-11)
> I struggled to find a good way to receive DiscrepancyForMarmot directly but could not find something.
> Timeline are not handled and date are converted to string

[link](https://github.com/alan-eu/alan-apps/pull/79961#discussion_r2793466483)

### @bastien-landre-alan on `backend/components/occupational_health/internal/business_logic/queries/affiliation/discrepancy_fix_analysis.py:41` (2026-02-16)
> yes the idea is to start only on one issue, and add some in the future if needed

[link](https://github.com/alan-eu/alan-apps/pull/79961#discussion_r2811793253)

### @bastien-landre-alan on `backend/components/occupational_health/internal/business_logic/queries/affiliation/discrepancy_fix_analysis.py:68` (2026-02-16)
> yes thanks, will compare to contract start date 

[link](https://github.com/alan-eu/alan-apps/pull/79961#discussion_r2811814421)

### @bastien-landre-alan on `backend/components/occupational_health/internal/business_logic/queries/affiliation/discrepancy_fix_analysis.py:78` (2026-02-16)
> it's checked [here](https://github.com/alan-eu/alan-apps/pull/79961/changes#diff-63779b5cceb8afa745e850e6c014899947f25c8b92f16063306ca8e0fb89d6c5R751)

[link](https://github.com/alan-eu/alan-apps/pull/79961#discussion_r2811858398)

### @bastien-landre-alan on `backend/components/occupational_health/public/marmot/queries.py:842` (2026-02-16)
> We don't have that much (less than 100). I thought it was easier to read

[link](https://github.com/alan-eu/alan-apps/pull/79961#discussion_r2811866200)

### @bastien-landre-alan on `backend/components/occupational_health/internal/business_logic/queries/affiliation/discrepancy_fix_analysis.py:104` (2026-02-16)
> yes we can have multiple format of date (because it's from our admin excel file)
> I updated the code in the last commit to handle this

[link](https://github.com/alan-eu/alan-apps/pull/79961#discussion_r2811974682)

---

## PR #79966 — feat(oh): command and logic to generate invoice appendix

_2026-02-11 • https://github.com/alan-eu/alan-apps/pull/79966_

### @bastien-landre-alan on `backend/components/billing_occupational_health/internal/business_logic/actions/invoice_appendix.py:19` (2026-02-11)
> What is NTT ? is is known enough to use acronyms ?

[link](https://github.com/alan-eu/alan-apps/pull/79966#discussion_r2794036773)

### @bastien-landre-alan on `backend/components/billing_occupational_health/internal/business_logic/actions/invoice_appendix.py:106` (2026-02-11)
> are you sure about this comment ? IT should never happen (but ok to skip because #ceinture_bretelle)

[link](https://github.com/alan-eu/alan-apps/pull/79966#discussion_r2794086434)

### @bastien-landre-alan on `backend/components/billing_occupational_health/internal/commands/invoice.py:150` (2026-02-11)
> Why do you rename here ? I see that you do that multiple time (no challenging only to understand)

[link](https://github.com/alan-eu/alan-apps/pull/79966#discussion_r2794096098)

### @bastien-landre-alan on `backend/components/fr/bootstrap/dependencies/occupational_health.py:268` (2026-02-11)
> do you realy need this if you also created get_ssn_and_ntt_for_users ?

[link](https://github.com/alan-eu/alan-apps/pull/79966#discussion_r2794103645)

### @bastien-landre-alan on `backend/components/billing_occupational_health/internal/business_logic/actions/invoice_appendix.py:106` (2026-02-12)
> yes of course, thanks for the explanation

[link](https://github.com/alan-eu/alan-apps/pull/79966#discussion_r2797591104)

### @bastien-landre-alan — issue comment (2026-02-11)
> Forgot one comment. You could also update the API to generate invoice called in marmot to generate the appending right after ?

[link](https://github.com/alan-eu/alan-apps/pull/79966#issuecomment-3885396467)

---

## PR #79986 — update invoice handling in billing tower

_2026-02-12 • https://github.com/alan-eu/alan-apps/pull/79986_

### @MickaelBergem — review summary (APPROVED, 2026-02-12)
> Thanks!

[link](https://github.com/alan-eu/alan-apps/pull/79986#pullrequestreview-3790173234)

---

## PR #80007 — fix: only send changed dates in discrepancies PATCH, escape slack handle

_2026-02-11 • https://github.com/alan-eu/alan-apps/pull/80007_

### @MickaelBergem on `backend/components/occupational_health/public/marmot/actions.py:277` (2026-02-11)
> Hmm how can you be sure it's always called by the discrepancy code? This function's name is `update_affiliation_dates_for_marmot`. If you are sure it's only used from here let's rename the function to mention it's only for discrepancies?

[link](https://github.com/alan-eu/alan-apps/pull/80007#discussion_r2794342259)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/affiliatedMembers/useUpdateAffiliationDatesMutation.ts:25` (2026-02-11)
> nit: next time you can also use the URLSearchParam syntax (takes care of escaping, etc)

[link](https://github.com/alan-eu/alan-apps/pull/80007#discussion_r2794345173)

### @bastien-landre-alan on `backend/components/occupational_health/public/marmot/actions.py:277` (2026-02-11)
> For now it is, but you're right that it could change, I will only update the message to "Update made by {slack_id} fixing affiliation in marmot", as don't need to ping if it's made in marmot with a tool I think

[link](https://github.com/alan-eu/alan-apps/pull/80007#discussion_r2794357273)

---

## PR #80090 — feat(oh): update command to generate appendixes for multiple invoices

_2026-02-12 • https://github.com/alan-eu/alan-apps/pull/80090_

### @bastien-landre-alan — review summary (APPROVED, 2026-02-12)
> It could be good idea to take an account_id as parameter of the command and generate all invoice for this account ?

[link](https://github.com/alan-eu/alan-apps/pull/80090#pullrequestreview-3791004428)

---

## PR #80125 — feat(oh): generate invoice appendix when generating invoice

_2026-02-12 • https://github.com/alan-eu/alan-apps/pull/80125_

### @bastien-landre-alan on `backend/components/billing_occupational_health/internal/business_logic/actions/generate.py:149` (2026-02-12)
> Why commit=False if not dry run ?
> And should you not pass dry run after this [PR](https://github.com/alan-eu/alan-apps/pull/80090/changes) is merged ?

[link](https://github.com/alan-eu/alan-apps/pull/80125#discussion_r2798869334)

---

## PR #80128 — feat(oh): add link to flask admin in issued invoices

_2026-02-19 • https://github.com/alan-eu/alan-apps/pull/80128_

### @bastien-landre-alan — review summary (COMMENTED, 2026-02-12)
> Did you tested it, I think we can't open detail for occupational_health invoice on flask admin (at least I have an exception)
> I talked about it [here](https://alanhealth.slack.com/archives/C0AA1MZFB29/p1770802744337759?thread_ts=1770801999.983379&cid=C0AA1MZFB29)

[link](https://github.com/alan-eu/alan-apps/pull/80128#pullrequestreview-3791020017)

---

## PR #80159 — fix(oh): sort rows in invoice appendix by lower name and first name

_2026-02-12 • https://github.com/alan-eu/alan-apps/pull/80159_

### @bastien-landre-alan — issue comment (2026-02-12)
> @Thomas-Mollard LGTM, but why to lowering name and surname will handle "de" particule ?

[link](https://github.com/alan-eu/alan-apps/pull/80159#issuecomment-3891581318)

---

## PR #80166 — feat(oh): display factures item in admin dashboard in prod

_2026-02-12 • https://github.com/alan-eu/alan-apps/pull/80166_

### @bastien-landre-alan — review summary (APPROVED, 2026-02-12)
> Did you fixed the order of invoices in a previous PR ?

[link](https://github.com/alan-eu/alan-apps/pull/80166#pullrequestreview-3791764697)

---

## PR #80304 — [MIGRATION] - feat: add discrepancy notes in Marmot affiliation discrepancies

_2026-02-16 • https://github.com/alan-eu/alan-apps/pull/80304_

### @MickaelBergem on `backend/components/fr/internal/marmot/controllers/occupational_health/affiliated_members.py:682` (2026-02-13)
> ```suggestion
>         noted_by_user_id=UserId(str(user.id)) if user else None,
> ```
> 
> Or 
> 
> ```suggestion
>         noted_by_user_id=UserId(str(mandatory(user).id)),
> ```
> 
> But never pass an empty string pretending it's a user ID

[link](https://github.com/alan-eu/alan-apps/pull/80304#discussion_r2804147040)

### @MickaelBergem on `backend/components/occupational_health/internal/models/occupational_health_discrepancy_note.py:13` (2026-02-13)
> We do not link it at all with a discrepancy, so I would just rename it to `OccupationalHealthProfileNote` while mentioning in the docstring that it's only used for discrepancies at this point, but feel free to disregard.

[link](https://github.com/alan-eu/alan-apps/pull/80304#discussion_r2804151249)

### @MickaelBergem on `backend/components/occupational_health/internal/models/occupational_health_discrepancy_note.py:31` (2026-02-13)
> Please also document the **why** we store a `user_id` instead of a `profile_id`

[link](https://github.com/alan-eu/alan-apps/pull/80304#discussion_r2804153077)

### @MickaelBergem on `backend/components/occupational_health/internal/models/occupational_health_discrepancy_note.py:44` (2026-02-13)
> What will this represent if the note was added by you and updated by me?
> 
> Please document that in the data model directly

[link](https://github.com/alan-eu/alan-apps/pull/80304#discussion_r2804155219)

### @MickaelBergem on `backend/components/occupational_health/internal/models/occupational_health_discrepancy_note.py:52` (2026-02-13)
> So we cannot have multiple notes added by multiple people... ok why not

[link](https://github.com/alan-eu/alan-apps/pull/80304#discussion_r2804165999)

### @MickaelBergem on `backend/components/occupational_health/public/marmot/actions.py:519` (2026-02-13)
> Why not `one_or_none()` since we have a DB constraint? At least if the assumption "there is always at most one note" breaks it will raise an exception, which would avoid silent bugs.

[link](https://github.com/alan-eu/alan-apps/pull/80304#discussion_r2804168319)

### @MickaelBergem on `backend/components/occupational_health/public/marmot/entities.py:215` (2026-02-13)
> nit: you could return the full name directly

[link](https://github.com/alan-eu/alan-apps/pull/80304#discussion_r2804170819)

### @MickaelBergem on `backend/components/occupational_health/public/marmot/entities.py:215` (2026-02-13)
> I also don't understand why it can be None

[link](https://github.com/alan-eu/alan-apps/pull/80304#discussion_r2804171843)

### @MickaelBergem on `backend/components/occupational_health/public/marmot/entities.py:216` (2026-02-13)
> ```suggestion
>     noted_at: datetime
> ```

[link](https://github.com/alan-eu/alan-apps/pull/80304#discussion_r2804173219)

### @MickaelBergem on `backend/components/occupational_health/public/marmot/queries.py:729` (2026-02-13)
> ```suggestion
>     noter_profile_mapping = (
>         profile_service.user_compat.get_user_profile_mapping(user_ids=noter_user_ids)
>     )
> ```

[link](https://github.com/alan-eu/alan-apps/pull/80304#discussion_r2804175929)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/affiliatedMembers/AffiliationDiscrepanciesModal.tsx:126` (2026-02-13)
> ```suggestion
>                   {notedCount > 0 && ` (${notedCount} with a note)`}
> ```

[link](https://github.com/alan-eu/alan-apps/pull/80304#discussion_r2804181377)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/affiliatedMembers/DiscrepancyNoteAction.tsx:93` (2026-02-13)
> nit
> 
> ```suggestion
>             Add note
> ```

[link](https://github.com/alan-eu/alan-apps/pull/80304#discussion_r2804184367)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/affiliatedMembers/useAddDiscrepancyNoteMutation.ts:24` (2026-02-13)
> There is a helper to transform the object key from camelCase to snake_case, you could just convertKeysBlablabla(params)

[link](https://github.com/alan-eu/alan-apps/pull/80304#discussion_r2804187512)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/affiliatedMembers/useAddDiscrepancyNoteMutation.ts:36` (2026-02-13)
> nit: avoid single-letter variable numbers
> 
> @TimPetricola should we add this to the rules for agents? Single-letters are harder to read and aren't much easier to type...

[link](https://github.com/alan-eu/alan-apps/pull/80304#discussion_r2804192048)

### @bastien-landre-alan on `backend/components/occupational_health/internal/models/occupational_health_discrepancy_note.py:13` (2026-02-13)
> It's not attached to a ccupationalHealthProfile either.
> I used discrepancy here because it's only use here (read/write) and I thought it would be easier to understand reading model/function without going into comments

[link](https://github.com/alan-eu/alan-apps/pull/80304#discussion_r2804339854)

### @bastien-landre-alan on `backend/components/occupational_health/internal/models/occupational_health_discrepancy_note.py:52` (2026-02-13)
> yes I chose this for simplicity but it can be changed later

[link](https://github.com/alan-eu/alan-apps/pull/80304#discussion_r2804349429)

### @bastien-landre-alan on `backend/components/occupational_health/public/marmot/entities.py:215` (2026-02-13)
> None just in case we don't find the user profile while reading the note

[link](https://github.com/alan-eu/alan-apps/pull/80304#discussion_r2804362101)

---

## PR #80343 — fix(oh): use same filters in invoices page as other pages

_2026-02-13 • https://github.com/alan-eu/alan-apps/pull/80343_

### @bastien-landre-alan — review summary (COMMENTED, 2026-02-13)
> Not sure to understand, can we have multiple entities in the filter ?
> From `appliedFilters` it seem that we can from `data.filter((invoice) => invoice.contractRef === selectedEntity);` it seem we can't

[link](https://github.com/alan-eu/alan-apps/pull/80343#pullrequestreview-3797586278)

---

## PR #80384 — enh(occh): Affiliator: Use start_date from excel file

_2026-02-16 • https://github.com/alan-eu/alan-apps/pull/80384_

### @bastien-landre-alan on `backend/components/occupational_health/internal/business_logic/queries/affiliation/affiliation_tool.py:861` (2026-02-16)
> For your first point. We already do a max [here](https://github.com/alan-eu/alan-apps/pull/80384/changes#diff-fffc050eee7a0e9fea1b4b6ec4f90313b86313b68569b3c1130be4ab1bc37f1cR680) between affiliation_start_date and contract_start_date.
> So we would not change the affiliation to before the contract based on the employment. We only update the affiliation date if the employment start after the date we picked.
> 
> For your second point, at this time I don't have much info on employment SIRET, and here I take the earliest employment to check that it's before the current affiliation. If the earlier employment is after the affiliation we have and issue and should not affiliation before any employment
> 
> :meta: here I don't change the affiliation date in the past, but only in the future

[link](https://github.com/alan-eu/alan-apps/pull/80384#discussion_r2811783108)

---

## PR #80411 — enh(occh): Affiliator: use end_date from excel file

_2026-02-16 • https://github.com/alan-eu/alan-apps/pull/80411_

### @bastien-landre-alan on `backend/components/occupational_health/internal/business_logic/queries/affiliation/affiliation_tool.py:694` (2026-02-16)
> yes it's planned after the rebase 👍 

[link](https://github.com/alan-eu/alan-apps/pull/80411#discussion_r2811945616)

---

## PR #80567 — fix(oh): retrieve billed entities by default in marmot

_2026-02-16 • https://github.com/alan-eu/alan-apps/pull/80567_

### @bastien-landre-alan — review summary (APPROVED, 2026-02-16)
> I was sure we already did this ...
> Thanks

[link](https://github.com/alan-eu/alan-apps/pull/80567#pullrequestreview-3809170019)

### @bastien-landre-alan on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/billing/BilledEntitiesSection.tsx:121` (2026-02-16)
> I think we still need this, as the accordion size can be wrong (don't understand why it works in your video ...)

[link](https://github.com/alan-eu/alan-apps/pull/80567#discussion_r2812911655)

### @bastien-landre-alan on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/billing/BilledEntitiesSection.tsx:121` (2026-02-16)
> By the way (not related to the PR), but maybe we should remove the accordion if we always load it, it mean it's important and should always be display

[link](https://github.com/alan-eu/alan-apps/pull/80567#discussion_r2812929701)

---

## PR #80576 — OHSET-380: feat(occh): add manual payment registration endpoint

_2026-02-19 • https://github.com/alan-eu/alan-apps/pull/80576_

### @bastien-landre-alan on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/billing/EntityInvoiceSubRow.tsx:171` (2026-02-18)
> To stop the click on the line to open/close the subline

[link](https://github.com/alan-eu/alan-apps/pull/80576#discussion_r2822491058)

---

## PR #81017 — chore: burn dead code I spotted that popped in circular import error stack trace

_2026-02-19 • https://github.com/alan-eu/alan-apps/pull/81017_

### @MickaelBergem — review summary (APPROVED, 2026-02-19)
> Thanks!

[link](https://github.com/alan-eu/alan-apps/pull/81017#pullrequestreview-3824995406)

### @MickaelBergem on `backend/components/fr/internal/business_logic/company/actions/invite.py:149` (2026-02-19)
> Why is this needed? 🤔 

[link](https://github.com/alan-eu/alan-apps/pull/81017#discussion_r2827071960)

---

## PR #81335 — [OccupationalHealth] Add logic to retrieve the stored deadline

_2026-02-23 • https://github.com/alan-eu/alan-apps/pull/81335_

### @bastien-landre-alan on `backend/components/occupational_health/internal/models/brokers/occupational_health_next_visit.py:15` (2026-02-23)
> should it be get_active_by_profile_and_account_id ?

[link](https://github.com/alan-eu/alan-apps/pull/81335#discussion_r2840060095)

---

## PR #81376 — [Occupational-Health] - Backend - Display ex employees or ex affiliated members

_2026-02-24 • https://github.com/alan-eu/alan-apps/pull/81376_

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/admin_dashboard/admin_dashboard.py:310` (2026-02-23)
> Check out `backend/components/occupational_health/internal/business_logic/queries/affiliation/affiliations.py`: it already takes care of building the Occupational Health profile IDs and helps deduplicating code. I think it would make sense to add the `only_ended` flag to `get_all_affiliations_for_account` maybe?

[link](https://github.com/alan-eu/alan-apps/pull/81376#discussion_r2841332874)

### @MickaelBergem — issue comment (2026-02-23)
> @lmbonnefont the PR description is empty, can you fill it out?

[link](https://github.com/alan-eu/alan-apps/pull/81376#issuecomment-3945216608)

---

## PR #81651 — feat(occ-health): Kill the modal when clicking on "Planifier une visite"

_2026-03-03 • https://github.com/alan-eu/alan-apps/pull/81651_

### @MickaelBergem — review summary (APPROVED, 2026-03-02)
> Looks perfect, thanks a lot @dangminhtran! 🙇 
> 
> And sorry again for the lack of clarity in the original Linear task + thanks for pushing the PR through the finish line even after leaving the crew.

[link](https://github.com/alan-eu/alan-apps/pull/81651#pullrequestreview-3876933153)

### @MickaelBergem on `frontend/apps/fr-app/js/app/dashboard/occupationalHealth/visits/RequestVisitButton.tsx:25` (2026-02-27)
> I think we are storing this URL somewhere else already, no? If yes, let's avoid duplicating it as it will make it harder to maintain.

[link](https://github.com/alan-eu/alan-apps/pull/81651#discussion_r2865392344)

### @MickaelBergem on `frontend/apps/fr-app/js/app/dashboard/occupationalHealth/visits/RequestVisitButton.tsx:13` (2026-02-27)
> It looks like you are no longer using the result of this query. Should we remove the code entirely?
> 
> Should we even remove the associated backend code if it's no longer useful?

[link](https://github.com/alan-eu/alan-apps/pull/81651#discussion_r2865397624)

### @MickaelBergem — issue comment (2026-02-23)
> Coucou @dangminhtran, I don't know if it's intentional but you added a couple lines at the top of the PR, you'll probably want to remove them for the next PRs ;)
> 
> <img width="894" height="224" alt="image" src="https://github.com/user-attachments/assets/16906af1-13d9-42fb-b07b-92dd4a3ef223" />
> 

[link](https://github.com/alan-eu/alan-apps/pull/81651#issuecomment-3946316070)

### @MickaelBergem — issue comment (2026-02-23)
> @aizeadesign looking at the video, I thought the plan was only to remove the main button on the Visit page, not the one per-member (in the sidemodal). Are we aligned on this or not?
> 
> The reasoning was that we sometimes "forget" to send emails for predictable visits (Ops logic being different from ours, some edge cases not covered, manual mistakes, etc), and allowing admins to send the link to members made sense after a couple weeks of the member being late on visits.

[link](https://github.com/alan-eu/alan-apps/pull/81651#issuecomment-3946332270)

---

## PR #81724 — [OccupationalHealth] Add new service to interact with predictable and on-demand gsheet

_2026-02-24 • https://github.com/alan-eu/alan-apps/pull/81724_

### @MickaelBergem — review summary (APPROVED, 2026-02-23)
> Looking good! You'll need to fix the `uncalled` check (ignore list in the file)

[link](https://github.com/alan-eu/alan-apps/pull/81724#pullrequestreview-3842887230)

### @MickaelBergem on `backend/apps/medical_secrecy/config/dev_config.py:37` (2026-02-23)
> @dubreuia I am concerned by this: we are now executing more 3rd-party libraries and writing to a GSheet from the medical secrecy component, for a purpose unrelated to `medical_secrecy`: this is "just" visit management which should be in the sole scope of `occupational_health`.
> 
> I don't have a good solution for now but I understand you are developing a vision for a better architecture: there is no urgency but we'll need to address this IMO. Happy to discuss if you disagree!
> 
> @Universemul can you add a comment like this?
> 
> ```suggestion
>     # Unrelated to Medical Secrecy but required as part of the medical software
>     GOOGLE_GSPREAD_SERVICE_ACCOUNT_SECRET_NAME = (
>         "fr-api-staging/env/google_gspread_service_account_json"
>     )
> ```

[link](https://github.com/alan-eu/alan-apps/pull/81724#discussion_r2842488990)

### @MickaelBergem on `backend/components/occupational_health/internal/helpers/gsheet_service.py:20` (2026-02-23)
> Love it 😂 

[link](https://github.com/alan-eu/alan-apps/pull/81724#discussion_r2842492115)

### @MickaelBergem on `backend/components/occupational_health/internal/helpers/gsheet_service.py:44` (2026-02-23)
> super useful comment thanks 🙏 

[link](https://github.com/alan-eu/alan-apps/pull/81724#discussion_r2842493654)

### @MickaelBergem on `backend/components/occupational_health/internal/helpers/gsheet_service.py:14` (2026-02-23)
> Any chance we can inline the imports of the GSheet-related libraries, so that they only load when needed but not every time the file is imported? In theory this helper file itself should only be imported when it's necessary but we never know.

[link](https://github.com/alan-eu/alan-apps/pull/81724#discussion_r2842503699)

### @MickaelBergem on `backend/components/occupational_health/internal/helpers/gsheet_service.py:173` (2026-02-23)
> Not sure what this means, it could benefit from a lil' comment

[link](https://github.com/alan-eu/alan-apps/pull/81724#discussion_r2842510117)

---

## PR #81734 — feat(occupational_health): add BillingAffiliationOverride model

_2026-02-24 • https://github.com/alan-eu/alan-apps/pull/81734_

### @bastien-landre-alan — review summary (APPROVED, 2026-02-24)
> Should we add it in turring if we want to track it's evolution ?

[link](https://github.com/alan-eu/alan-apps/pull/81734#pullrequestreview-3845859860)

### @bastien-landre-alan on `backend/components/occupational_health/internal/models/billing_affiliation_override.py:40` (2026-02-24)
> no relationship with affiliation_id ?

[link](https://github.com/alan-eu/alan-apps/pull/81734#discussion_r2845195272)

### @MickaelBergem on `backend/components/occupational_health/internal/models/billing_affiliation_override.py:40` (2026-02-24)
> No it's from a different component: no foreign key

[link](https://github.com/alan-eu/alan-apps/pull/81734#discussion_r2845448930)

### @MickaelBergem — issue comment (2026-02-23)
> This change is part of the following stack:
> 
> - #81734 ◀
>     - #81735
> 
> <sub>Change managed by [git-spice](https://abhinav.github.io/git-spice/).</sub>
> <!-- gs:navigation comment -->
> 

[link](https://github.com/alan-eu/alan-apps/pull/81734#issuecomment-3947017316)

---

## PR #81735 — feat(occupational_health): override affiliations with no employments in billing

_2026-02-24 • https://github.com/alan-eu/alan-apps/pull/81735_

### @bastien-landre-alan — review summary (APPROVED, 2026-02-24)
> Will you also update the discrepancies to display that there is an override ?
> I agree that discrepancies are not only for billing but I think it's a usefull information

[link](https://github.com/alan-eu/alan-apps/pull/81735#pullrequestreview-3849473063)

### @bastien-landre-alan on `backend/components/occupational_health/public/queries/billing.py:288` (2026-02-24)
> I agree that it's working like that, but I would check billing_overrides before calling _find_customer_to_bill_for_affiliation.
> As the name, it override the billing we could find so we should not event call the function

[link](https://github.com/alan-eu/alan-apps/pull/81735#discussion_r2848561493)

### @MickaelBergem on `backend/components/occupational_health/public/queries/billing.py:288` (2026-02-24)
> > As the name, it override the billing we could find so we should not event call the function
> 
> Good point. I'll merge and try to come up with a better naming (like a "Fallback").

[link](https://github.com/alan-eu/alan-apps/pull/81735#discussion_r2848613430)

### @MickaelBergem — issue comment (2026-02-23)
> This change is part of the following stack:
> 
> - #81734
>     - #81735 ◀
> 
> <sub>Change managed by [git-spice](https://abhinav.github.io/git-spice/).</sub>
> <!-- gs:navigation comment -->
> 

[link](https://github.com/alan-eu/alan-apps/pull/81735#issuecomment-3947017298)

### @MickaelBergem — issue comment (2026-02-24)
> > Will you also update the discrepancies to display that there is an override ?
> > I agree that discrepancies are not only for billing but I think it's a usefull information
> 
> Good point. Do you think you could own doing this / write a woodchuck for it?

[link](https://github.com/alan-eu/alan-apps/pull/81735#issuecomment-3953692730)

---

## PR #81796 — fix(occh): skip missing_affiliation discrepancy for terminated employments

_2026-03-02 • https://github.com/alan-eu/alan-apps/pull/81796_

### @MickaelBergem — review summary (CHANGES_REQUESTED, 2026-02-24)
> This will ignore issues with end dates in the future, such as 1-y contracts ending at the end of 2026. We at the very least want to filter out the employments ended _in the past_.

[link](https://github.com/alan-eu/alan-apps/pull/81796#pullrequestreview-3846993433)

### @MickaelBergem — review summary (APPROVED, 2026-02-27)
> Only one important comment, there might be a bug.

[link](https://github.com/alan-eu/alan-apps/pull/81796#pullrequestreview-3867909726)

### @MickaelBergem on `backend/components/fr/internal/marmot/controllers/occupational_health/affiliated_members.py:612` (2026-02-27)
> very small nit: I tend to understand "skip" as meaning some entries will not be "processed" (they are skipped), implying some _action_. Here I would have chosen "ignore" since we're just _reading_ data.
> 
> No need to change the code but I'm just sharing my thought process.

[link](https://github.com/alan-eu/alan-apps/pull/81796#discussion_r2865199208)

### @MickaelBergem on `backend/components/fr/internal/marmot/controllers/occupational_health/affiliated_members.py:613` (2026-02-27)
> I would prefer we keep the responsibility of sending the value to the frontend (and always require the value). Otherwise it opens the door to a bug the day the frontend fails to send the proper key name for some reason (we'd be silently always hiding some discrepancies even when the checkbox is unticked).

[link](https://github.com/alan-eu/alan-apps/pull/81796#discussion_r2865203601)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/affiliation/tests/test_discrepancies.py:391` (2026-02-27)
> I would remove this entire section and do two "act + assert" based on the same initial data (+rename the test case), it would make the test slightly easier to read as we're testing against the same initial data.

[link](https://github.com/alan-eu/alan-apps/pull/81796#discussion_r2865211240)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/affiliation/discrepancies.py:97` (2026-02-27)
> We're missing `compute_eligibility` in this doc, can you add it when you get a chance? 😇 

[link](https://github.com/alan-eu/alan-apps/pull/81796#discussion_r2865214151)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/affiliatedMembers/useGetAffiliationDiscrepanciesQuery.ts:73` (2026-02-27)
> Have you tested locally? I suspect Python will evaluate `"false"` as truthy since it's a non-empty string...

[link](https://github.com/alan-eu/alan-apps/pull/81796#discussion_r2865221186)

### @bastien-landre-alan on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/affiliatedMembers/useGetAffiliationDiscrepanciesQuery.ts:73` (2026-02-27)
> yes I tested, and it's working. like the previous one ` params.set("compute_eligibility", "true");`

[link](https://github.com/alan-eu/alan-apps/pull/81796#discussion_r2865383514)

### @MickaelBergem — issue comment (2026-02-24)
> > a missing affiliation for someone who no longer works there is not actionable.
> 
> I see the point, but I would probably add a filter (auto-selected by default) in the UI, so that we can still see them if we want to. It would help when debugging. Not a big deal if you decide not to follow my advice.

[link](https://github.com/alan-eu/alan-apps/pull/81796#issuecomment-3950996075)

### @bastien-landre-alan — issue comment (2026-02-24)
> > > a missing affiliation for someone who no longer works there is not actionable.
> > 
> > I see the point, but I would probably add a filter (auto-selected by default) in the UI, so that we can still see them if we want to. It would help when debugging. Not a big deal if you decide not to follow my advice.
> 
> @MickaelBergem do you see a value with it ? I think that we already have option that we check by default (check elligibility) I would think it's bettwe to have a simple tool if we don't know when/how we will use certain options.
> 
> I don't know how we could use the knowledge that an employee should have been affiliated but we missed it

[link](https://github.com/alan-eu/alan-apps/pull/81796#issuecomment-3951157631)

### @MickaelBergem — issue comment (2026-02-24)
> > @MickaelBergem do you see a value with it ? I think that we already have option that we check by default (check elligibility) I would think it's bettwe to have a simple tool if we don't know when/how we will use certain options.
> > 
> > I don't know how we could use the knowledge that an employee should have been affiliated but we missed it
> 
> I do, even though we're playing the "will it be useful in the future" game. Here my point is also about simplicity: a new engineer or Ops could wrongly assume that there weren't any discrepancy in the past while we did forget to affiliate dozens of members.
> 
> I agree that if the Affiliation Discrepancies feature was only useful for billing purposes, then we could implement as is.

[link](https://github.com/alan-eu/alan-apps/pull/81796#issuecomment-3951536611)

---

## PR #81927 — fix(occh): update date on which we get NIC for eligibility in discrepancy

_2026-02-24 • https://github.com/alan-eu/alan-apps/pull/81927_

### @MickaelBergem — review summary (APPROVED, 2026-02-24)
> Sounds good to me! Let's monitor the impact on employment changes as this eligibility code is mostly used there.

[link](https://github.com/alan-eu/alan-apps/pull/81927#pullrequestreview-3849435351)

### @bastien-landre-alan — issue comment (2026-02-24)
> > Sounds good to me! Let's monitor the impact on employment changes as this eligibility code is mostly used there.
> 
> @MickaelBergem it should be ok, in the employment change we use compute_eligibility directly, here I'm changing only the function used for discrepancies (compute_eligibility_for_affiliation_from_employment)
> 

[link](https://github.com/alan-eu/alan-apps/pull/81927#issuecomment-3953975788)

---

## PR #82172 — chore: migrate controllers from @request_argument to @use_args

_2026-03-11 • https://github.com/alan-eu/alan-apps/pull/82172_

### @MickaelBergem on `backend/components/customer_health_partner/wellbeing_assessment/public/controllers/customer_dashboard.py:90` (2026-02-27)
> It used to be a `type=list` argument (I think `company_id=1&company_id=2&...`). I haven't checked closely to be honest.

[link](https://github.com/alan-eu/alan-apps/pull/82172#discussion_r2863346084)

### @MickaelBergem on `backend/components/customer_health_partner/wellbeing_assessment/public/controllers/customer_dashboard.py:333` (2026-02-27)
> Good point, not sure why Claude did that.

[link](https://github.com/alan-eu/alan-apps/pull/82172#discussion_r2863348453)

### @MickaelBergem on `backend/components/customer_health_partner/wellbeing_assessment/public/controllers/customer_dashboard.py:426` (2026-02-27)
> Yes that would make sense 🤔 

[link](https://github.com/alan-eu/alan-apps/pull/82172#discussion_r2863350207)

### @MickaelBergem on `backend/components/customer_health_partner/wellbeing_assessment/public/controllers/tests/test_customer_dashboard.py:210` (2026-03-02)
> ⚠️ 

[link](https://github.com/alan-eu/alan-apps/pull/82172#discussion_r2873942758)

### @MickaelBergem on `backend/components/customer_health_partner/wellbeing_assessment/public/controllers/tests/test_customer_dashboard.py:210` (2026-03-11)
> Actually it's fine, frontend calls ` resultsViewedAt.toISOString()`

[link](https://github.com/alan-eu/alan-apps/pull/82172#discussion_r2917090541)

### @MickaelBergem on `backend/components/customer_health_partner/wellbeing_assessment/public/controllers/tests/test_customer_dashboard.py:210` (2026-03-11)
> I thought I had added a comment already: the initial test was wrong, the frontend seems to be passing the full datetime 🤷 

[link](https://github.com/alan-eu/alan-apps/pull/82172#discussion_r2918884748)

### @MickaelBergem on `backend/components/customer_health_partner/wellbeing_assessment/public/controllers/customer_dashboard.py:555` (2026-03-11)
> No indeed, even though there wasn't a single hit in the past month (the feature is now hidden).

[link](https://github.com/alan-eu/alan-apps/pull/82172#discussion_r2918920571)

### @MickaelBergem on `backend/components/customer_health_partner/wellbeing_assessment/public/controllers/customer_dashboard.py:555` (2026-03-11)
> Actually we don't even read this parameter in the controller body... I'll clean.

[link](https://github.com/alan-eu/alan-apps/pull/82172#discussion_r2918924739)

### @MickaelBergem on `backend/components/customer_health_partner/wellbeing_assessment/public/controllers/customer_dashboard.py:608` (2026-03-11)
> I think it's just not used if GET no?

[link](https://github.com/alan-eu/alan-apps/pull/82172#discussion_r2918971746)

### @MickaelBergem — issue comment (2026-02-27)
> > I'm surprised by a few things in the PR (duplicated identical schemas, several `Field` used...). How did you run the migration? Via the codemod only? Or with the LLM command (and in this case, which model did you use)?
> 
> With the LLM (latest Opus, effort high), it needed to iterate. I'll try to clean it and will request another review from you.

[link](https://github.com/alan-eu/alan-apps/pull/82172#issuecomment-3971607745)

### @MickaelBergem — issue comment (2026-03-11)
> @vrialland this PR is ready for review - again 😇 

[link](https://github.com/alan-eu/alan-apps/pull/82172#issuecomment-4038511127)

---

## PR #82204 — chore(rules): normalize branchprefix

_2026-03-11 • https://github.com/alan-eu/alan-apps/pull/82204_

### @MickaelBergem — review summary (APPROVED, 2026-02-26)
> This looks complex, I wonder if there is an easier way to compute it once and store it somewhere (memory? local file?)

[link](https://github.com/alan-eu/alan-apps/pull/82204#pullrequestreview-3860893261)

---

## PR #82227 — occupational_health: display consent timestamps in admin profile

_2026-02-26 • https://github.com/alan-eu/alan-apps/pull/82227_

### @MickaelBergem on `frontend/apps/medical-software/app/pages/AdministrativeProfileModal.tsx:47` (2026-02-26)
> Indeed I don't like it either, will change my Claude rules for next time.

[link](https://github.com/alan-eu/alan-apps/pull/82227#discussion_r2859668006)

---

## PR #82345 — feat(occh): add invoice email sending with confirmation modal

_2026-02-27 • https://github.com/alan-eu/alan-apps/pull/82345_

### @MickaelBergem — review summary (APPROVED, 2026-02-27)
> I read only half of the PR but I understand you are in a rush: I trust you to test appropriately the feature in acceptance / Kay before triggering it in prod 😇 

[link](https://github.com/alan-eu/alan-apps/pull/82345#pullrequestreview-3866086552)

### @MickaelBergem on `backend/components/fr/internal/marmot/controllers/occupational_health/billing.py:402` (2026-02-27)
> Please remain consistent with URL naming: we're using `_` instead of `-`

[link](https://github.com/alan-eu/alan-apps/pull/82345#discussion_r2863554366)

### @MickaelBergem on `backend/components/fr/public/templates/mail/occupational_health/billing/billing_invoice_multiple.html:19` (2026-02-27)
> <img width="571" height="274" alt="Image" src="https://github.com/user-attachments/assets/48e719c6-4b20-4bf7-b499-48abbccbeeb2" />
> 
> I feel we're missing a `Pour` so that it read `Pour Alan Tech, le montant est...`

[link](https://github.com/alan-eu/alan-apps/pull/82345#discussion_r2863557205)

### @MickaelBergem on `backend/components/fr/public/templates/mail/occupational_health/_footer.html:5` (2026-02-27)
> This is not actionable: there should be a link (on `On est là pour vous aider.` IMO) leading at the very least to the FAQ or a `mailto:secretariat@prevenir.fr?Subject=Question%20sur%20ma%20facture`. Or maybe a "répondez directement à cet e-mail" mention otherwise.
> 
> Otherwise admins/accountants might not know how to contact us.

[link](https://github.com/alan-eu/alan-apps/pull/82345#discussion_r2863564075)

### @MickaelBergem on `backend/components/fr/public/templates/mail/occupational_health/_layout.html:62` (2026-02-27)
> Can you add UTM tracking links so that we know where they arrived on the dashboard from?

[link](https://github.com/alan-eu/alan-apps/pull/82345#discussion_r2863573346)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/billing/send_invoice_email.py:48` (2026-02-27)
> nit
> 
> ```suggestion
>             message="All {len(all_invoices)} invoices have already been emailed"
> ```

[link](https://github.com/alan-eu/alan-apps/pull/82345#discussion_r2863577667)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/billing/send_invoice_email.py:63` (2026-02-27)
> nit: I'm afraid this will be hard to debug (for you and for Ops), if there is an easy way to tweak the error message to make it more actionable it would be super helpful

[link](https://github.com/alan-eu/alan-apps/pull/82345#discussion_r2863587869)

### @MickaelBergem on `backend/components/fr/public/templates/mail/occupational_health/_header.html:1` (2026-02-27)
> nit: this is typically a layout we will want to have inside Customerio in the end so that the backend can focus on the content and customerio on the mandatory mentions, injecting unsubscribe links, etc

[link](https://github.com/alan-eu/alan-apps/pull/82345#discussion_r2863596834)

### @MickaelBergem on `backend/components/occupational_health/internal/mailers/billing_invoice.py:241` (2026-02-27)
> 🤩 

[link](https://github.com/alan-eu/alan-apps/pull/82345#discussion_r2863599300)

### @MickaelBergem on `backend/components/occupational_health/internal/mailers/billing_invoice.py:239` (2026-02-27)
> Any chance we can build a better interface? Something like a public method `mark_invoices_as_sent(invoice_ids)`?

[link](https://github.com/alan-eu/alan-apps/pull/82345#discussion_r2863603740)

### @MickaelBergem on `backend/components/occupational_health/public/actions/billing.py:6` (2026-02-27)
> ```suggestion
> def send_billing_invoices_email(account_id: AccountId | UUID) -> None:
> ```

[link](https://github.com/alan-eu/alan-apps/pull/82345#discussion_r2863606256)

### @bastien-landre-alan on `backend/components/fr/public/templates/mail/occupational_health/_header.html:1` (2026-02-27)
> Are you sure ? Checking customerIO I see that the full body is sent from the backend, that's what I found [here](https://www.notion.so/alaninsurance/Create-a-new-transactional-message-2c368fd504584b59af62072d6f7320be)

[link](https://github.com/alan-eu/alan-apps/pull/82345#discussion_r2863697595)

### @MickaelBergem on `backend/components/fr/public/templates/mail/occupational_health/_header.html:1` (2026-02-27)
> There are different ways to do it indeed and the historical 🇫🇷 managed transactional campaign indeed has everything in the backend template. My personal preference (today) is to have the layout in Customerio as it can be reused by workflows and WYSIWYG editors if emails are sent from journeys defined in Customerio.

[link](https://github.com/alan-eu/alan-apps/pull/82345#discussion_r2864204185)

### @bastien-landre-alan on `backend/components/fr/public/templates/mail/occupational_health/_header.html:1` (2026-02-27)
> I asked the question [here](https://alanhealth.slack.com/archives/C19FZEB41/p1772098862627489?thread_ts=1772098859.777629&cid=C19FZEB41) the feedback was to use backend template.
> I think that it's because it's much easier to update common part of all email (updating all Prevenir footer for example)

[link](https://github.com/alan-eu/alan-apps/pull/82345#discussion_r2864218067)

---

## PR #82393 — Add has_installment_plan_per_year column to occupational_health_billed_entity

_2026-03-02 • https://github.com/alan-eu/alan-apps/pull/82393_

### @MickaelBergem — review summary (APPROVED, 2026-02-27)
> I would wait for Thomas' answer before merging

[link](https://github.com/alan-eu/alan-apps/pull/82393#pullrequestreview-3868020270)

### @MickaelBergem on `backend/apps/fr_api/migrations/scripts/20260225151104814607_update_occupational_health_billed_.py:1` (2026-02-27)
> This is a migration where you add a column (`has_installment_plan_per_year`) without the associated model change (adding the column in the model file) 👉 it won't work

[link](https://github.com/alan-eu/alan-apps/pull/82393#discussion_r2863638276)

### @MickaelBergem on `backend/apps/fr_api/migrations/scripts/20260225151104814607_update_occupational_health_billed_.py:46` (2026-02-27)
> @Thomas-Mollard do you confirm we should no longer have `0` values in installment plans nowadays?
> 
> And if there are remaining cases we are fine with **not** enabling an installment plan for them?

[link](https://github.com/alan-eu/alan-apps/pull/82393#discussion_r2865293509)

---

## PR #82394 — Use contract_has_installment_plan field

_2026-03-02 • https://github.com/alan-eu/alan-apps/pull/82394_

### @MickaelBergem — review summary (APPROVED, 2026-02-27)
> I would ensure any update to the old field is propagated to the new one, so that they stay in sync.

[link](https://github.com/alan-eu/alan-apps/pull/82394#pullrequestreview-3868066853)

### @MickaelBergem on `backend/components/fr/internal/marmot/controllers/occupational_health/billing.py:102` (2026-02-27)
> There is a `@deprecated` decorator that you might love ;)

[link](https://github.com/alan-eu/alan-apps/pull/82394#discussion_r2865339935)

### @MickaelBergem on `backend/components/occupational_health/public/actions/billing_entity.py:28` (2026-02-27)
> I think you could keep a single parameter here for the interface and write to both columns, to ensure the data stays in sync. You don't want someone editing the old value while this PR is deployed in prod.

[link](https://github.com/alan-eu/alan-apps/pull/82394#discussion_r2865349461)

---

## PR #82395 — Use contract_has_installment_plan field in frontend

_2026-03-03 • https://github.com/alan-eu/alan-apps/pull/82395_

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/billing/BilledEntities.tsx:108` (2026-02-27)
> As a general rule, avoid 1-2-letters variable names. With modern IDEs it's easy to just type the full name (it'll autocomplete) but it's still hard to understand what is `v` without reading the code around.

[link](https://github.com/alan-eu/alan-apps/pull/82395#discussion_r2865362907)

---

## PR #82404 — Remove deprecated number_of_employees_per_year_for_installment_plan from backend code

_2026-03-03 • https://github.com/alan-eu/alan-apps/pull/82404_

### @MickaelBergem on `backend/components/fr/internal/marmot/controllers/occupational_health/billing.py:280` (2026-03-02)
> Why is `has_installment_plan_per_year` not required by the controller, now that the frontend got updated?

[link](https://github.com/alan-eu/alan-apps/pull/82404#discussion_r2873547452)

### @MickaelBergem on `backend/components/occupational_health/internal/models/occupational_health_billed_entity.py:82` (2026-03-02)
> I think you're missing the `evaluates_none()` like [mentioned here](https://www.notion.so/alaninsurance/Database-Migrations-fb0639431985432397b45795d894f31c?source=copy_link#bc406ec76c424f6d8bc3b160d7c1129f), on top of using `deferred`?

[link](https://github.com/alan-eu/alan-apps/pull/82404#discussion_r2873557109)

### @MickaelBergem on `backend/components/fr/internal/marmot/controllers/occupational_health/billing.py:280` (2026-03-03)
> Ah interesting. It can probably be done in a dedicated PR but I would tend to think that if it's always sent by the frontend (not sure if that's the case!) then we should enforce it in the backend (removing a class of bug, when the frontend param is renamed but the backend still expects the old one and we silently stop storing the changes).
> 
> Not a big deal for such a rarely used tool.

[link](https://github.com/alan-eu/alan-apps/pull/82404#discussion_r2877082611)

---

## PR #82410 — chore: migrate medical software endpoints to @use_args

_2026-03-02 • https://github.com/alan-eu/alan-apps/pull/82410_

### @MickaelBergem on `backend/components/occupational_health/internal/controllers/medical_app.py:102` (2026-02-27)
> @vrialland is there a way to directly have Marshmallow deserialize the dict into a Dmst dataclass? Now we are doing it from within the controller body and I feel it's a missed opportunity (also would 500 instead of 400 if the data is invalid)

[link](https://github.com/alan-eu/alan-apps/pull/82410#discussion_r2863539689)

---

## PR #82418 — [Occ Health] Use contract start date to avoid importing visit in the future during affiliation

_2026-02-27 • https://github.com/alan-eu/alan-apps/pull/82418_

### @bastien-landre-alan on `backend/components/occupational_health/internal/business_logic/contracting/queries/contracting.py:114` (2026-02-27)
> nice 

[link](https://github.com/alan-eu/alan-apps/pull/82418#discussion_r2863830829)

### @bastien-landre-alan on `backend/components/occupational_health/internal/commands/import_visits_from_csv.py:89` (2026-02-27)
> nit, but I like contract_start_date_by_account_id
> and how can we have None as date ?

[link](https://github.com/alan-eu/alan-apps/pull/82418#discussion_r2863834867)

### @bastien-landre-alan on `backend/components/occupational_health/internal/business_logic/actions/tests/test_affiliation_tool.py:39` (2026-02-27)
> should we allow this ? should contract start not be mandatory ?

[link](https://github.com/alan-eu/alan-apps/pull/82418#discussion_r2863837895)

---

## PR #82439 — feat(oh): release past employees tab in admin dashboard

_2026-03-04 • https://github.com/alan-eu/alan-apps/pull/82439_

### @MickaelBergem — review summary (APPROVED, 2026-03-04)
> @Thomas-Mollard Will we be able to measure usage in Amplitude?

[link](https://github.com/alan-eu/alan-apps/pull/82439#pullrequestreview-3888467838)

---

## PR #82508 — enh(occh): record payment input in euros instead of cents

_2026-03-02 • https://github.com/alan-eu/alan-apps/pull/82508_

### @MickaelBergem — review summary (APPROVED, 2026-02-27)
> I'm always wary when manipulating currency floats 🙈 

[link](https://github.com/alan-eu/alan-apps/pull/82508#pullrequestreview-3867982490)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/billing/BilledEntities.tsx:162` (2026-02-27)
> nit: why can't you just pass this value directly to `<RecordPaymentModal>` on L175? I don't see the point of storing it in the react state 🤔 

[link](https://github.com/alan-eu/alan-apps/pull/82508#discussion_r2865263116)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/billing/RecordPaymentModal.tsx:32` (2026-02-27)
> There are already helpers to manipulate currency like this, please use them directly (I think you have the correct implementation but still).

[link](https://github.com/alan-eu/alan-apps/pull/82508#discussion_r2865265950)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/billing/RecordPaymentModal.tsx:37` (2026-02-27)
> Why not zero?

[link](https://github.com/alan-eu/alan-apps/pull/82508#discussion_r2865266796)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/billing/RecordPaymentModal.tsx:53` (2026-02-27)
> I remember the last gazette's article about currency values computation. Is this `* 100` safe?

[link](https://github.com/alan-eu/alan-apps/pull/82508#discussion_r2865270104)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/billing/RecordPaymentModal.tsx:21` (2026-02-27)
> Should this be a string, to ensure we don't have float weirdness?

[link](https://github.com/alan-eu/alan-apps/pull/82508#discussion_r2865272882)

### @bastien-landre-alan — issue comment (2026-02-27)
> > 'm always wary when manipulating currency floats
> 
> @MickaelBergem I agree, that's why at first I requested an amont in cent
> 
> Do you think I should put back an amount in cent, but be more thorough in the test (display the same warning if the amount is too low or if they is a comma) to avoid any issue ?
> :meta: as Clemence didn't see it was in cent I thought it was not a good practice and not used by ops

[link](https://github.com/alan-eu/alan-apps/pull/82508#issuecomment-3974293930)

---

## PR #82540 — Allow admins to request changes about a members information

_2026-03-04 • https://github.com/alan-eu/alan-apps/pull/82540_

### @MickaelBergem — review summary (APPROVED, 2026-03-04)
> Looking great! Will you hide the button behind a feature flag in the end?

[link](https://github.com/alan-eu/alan-apps/pull/82540#pullrequestreview-3888500767)

### @MickaelBergem on `frontend/apps/fr-app/js/app/dashboard/occupationalHealth/employees/EmployeeSideModal.tsx:77` (2026-03-04)
> nit: in the code, we prefer avoiding acronyms like `oh` that aren't easy to understand for the majority of engineers. `occupational_health` is longer but with modern tools it's easy enough to type/autocomplete, and it's much more readable.

[link](https://github.com/alan-eu/alan-apps/pull/82540#discussion_r2882985191)

### @MickaelBergem on `frontend/apps/fr-app/js/app/dashboard/occupationalHealth/employees/EmployeeSideModal.tsx:83` (2026-03-04)
> nit: you could have passed the full name at once (concatenating the first and last name here in the JS world and passing a single `full_name` attribute). No need to change the code as it's not important.

[link](https://github.com/alan-eu/alan-apps/pull/82540#discussion_r2882988069)

### @MickaelBergem on `frontend/apps/fr-app/js/app/dashboard/occupationalHealth/employees/EmployeeSideModal.tsx:207` (2026-03-04)
> ```suggestion
>           // Don't change this attribute, it triggers an Intercom workflow when the button is pressed
> ```

[link](https://github.com/alan-eu/alan-apps/pull/82540#discussion_r2882989174)

---

## PR #82566 — fix(occupational_health): tests leaking FR models on CI

_2026-02-27 • https://github.com/alan-eu/alan-apps/pull/82566_

### @MickaelBergem on `backend/components/occupational_health/internal/mailers/tests/test_billing_invoice.py:360` (2026-02-27)
> This test was calling 🇫🇷 logic so cannot be tested here unfortunately

[link](https://github.com/alan-eu/alan-apps/pull/82566#discussion_r2865697634)

### @bastien-landre-alan — issue comment (2026-02-27)
> Thanks, but as you said I will work on using the global mailer as it's not usable when we will have lot of mails 🙏 

[link](https://github.com/alan-eu/alan-apps/pull/82566#issuecomment-3974507965)

---

## PR #82686 — Refine log error to warning

_2026-03-02 • https://github.com/alan-eu/alan-apps/pull/82686_

### @MickaelBergem — review summary (APPROVED, 2026-03-02)
> Thinking out loud, should we pass the userId explicitly when calling the mutation?
> 
> I'm curious if there is a world where we display the DMST but we don't log the access.

[link](https://github.com/alan-eu/alan-apps/pull/82686#pullrequestreview-3876084833)

---

## PR #82696 — 📊 tracking: Add Amplitude and Customer.io SDKs on web (on Acceptance only for now)

_2026-03-12 • https://github.com/alan-eu/alan-apps/pull/82696_

### @MickaelBergem — review summary (APPROVED, 2026-03-05)
> Ok for files owned by us.

[link](https://github.com/alan-eu/alan-apps/pull/82696#pullrequestreview-3895726088)

---

## PR #82718 — feat(ohmed): add dsn companies search by siren

_2026-03-02 • https://github.com/alan-eu/alan-apps/pull/82718_

### @MickaelBergem — review summary (APPROVED, 2026-03-02)
> Looks good!

[link](https://github.com/alan-eu/alan-apps/pull/82718#pullrequestreview-3876891343)

### @MickaelBergem on `backend/components/fr/public/dsn/company.py:71` (2026-03-02)
> I never know when we're supposed to be explicit about the JOIN condition (`LEFT JOIN other_table ON yy`) but if it works and you don't get any warning then let's gooo!
> 
> Did you test against shared Kay?

[link](https://github.com/alan-eu/alan-apps/pull/82718#discussion_r2873051064)

---

## PR #82822 — [Occ Health] Add read only session when retrieving members subscribers

_2026-03-03 • https://github.com/alan-eu/alan-apps/pull/82822_

### @MickaelBergem — review summary (APPROVED, 2026-03-03)
> Can't we keep the read-only session everywhere where it makes sense?

[link](https://github.com/alan-eu/alan-apps/pull/82822#pullrequestreview-3881137696)

---

## PR #82922 — [Occ health] Manual import the doctolib export in the Visit Management Matching tool v2

_2026-03-04 • https://github.com/alan-eu/alan-apps/pull/82922_

### @MickaelBergem on `backend/components/fr/internal/marmot/controllers/occupational_health/visit_management_v2.py:38` (2026-03-04)
> I would have `raise NotImplementedError(json_args)` but that works as well

[link](https://github.com/alan-eu/alan-apps/pull/82922#discussion_r2882608778)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/visitManagementMatchingV2/index.tsx:51` (2026-03-04)
> ```suggestion
>         message: `Error matching users. Please ask an eng for logs: ${error}`,
> ```

[link](https://github.com/alan-eu/alan-apps/pull/82922#discussion_r2882614172)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/visitManagementMatchingV2/useMatchUsersV2Query.ts:10` (2026-03-04)
> 👍 

[link](https://github.com/alan-eu/alan-apps/pull/82922#discussion_r2882616714)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/visitManagementMatchingV2/useMatchUsersV2Query.ts:6` (2026-03-04)
> Ah because currently it's empty and you will replace it in the next PR?

[link](https://github.com/alan-eu/alan-apps/pull/82922#discussion_r2882618876)

---

## PR #82985 — [OccupationalHealth] Improve visit management v2 tooling

_2026-03-05 • https://github.com/alan-eu/alan-apps/pull/82985_

### @MickaelBergem — review summary (APPROVED, 2026-03-05)
> Didn't review all code, approving to unblock you. Let me know if there are parts you want to be challenged on.
> 
> Also maybe try a `/pr-review` just to see if it finds issues.

[link](https://github.com/alan-eu/alan-apps/pull/82985#pullrequestreview-3895767995)

### @MickaelBergem on `backend/components/fr/internal/marmot/controllers/occupational_health/visit_management.py:57` (2026-03-05)
> This smells like it could be move to a dedicated business logic action 😇 

[link](https://github.com/alan-eu/alan-apps/pull/82985#discussion_r2889342024)

### @MickaelBergem on `backend/components/fr/internal/marmot/controllers/occupational_health/visit_management.py:63` (2026-03-05)
> We don't have an enum for this status, do we?

[link](https://github.com/alan-eu/alan-apps/pull/82985#discussion_r2889343435)

### @MickaelBergem on `backend/components/fr/internal/marmot/controllers/occupational_health/visit_management.py:63` (2026-03-05)
> Should we raise if `len(normalized) == 0`? Or will it be obvious to Ops that something is broken?

[link](https://github.com/alan-eu/alan-apps/pull/82985#discussion_r2889346378)

### @MickaelBergem on `backend/components/occupational_health/internal/entities/visit_management/doctolib_matching_v2.py:44` (2026-03-05)
> Should this be an enum somehow to enforce we don't get other values?

[link](https://github.com/alan-eu/alan-apps/pull/82985#discussion_r2889360164)

### @MickaelBergem on `backend/components/occupational_health/internal/entities/visit_management/doctolib_matching_v2.py:101` (2026-03-05)
> ```suggestion
>     user_id: UserId
> ```

[link](https://github.com/alan-eu/alan-apps/pull/82985#discussion_r2889361015)

### @MickaelBergem on `backend/components/occupational_health/public/queries/doctolib_user_matching.py:82` (2026-03-05)
> No, use the queries in `external/` instead.

[link](https://github.com/alan-eu/alan-apps/pull/82985#discussion_r2889378674)

---

## PR #83066 — [MIGRATION] - enh: add postal_country to OccupationalHealthBilledEntity

_2026-03-05 • https://github.com/alan-eu/alan-apps/pull/83066_

### @MickaelBergem — review summary (APPROVED, 2026-03-04)
> Approving to unblock you but the frontend changes likely don't belong here + migration split might be required.

[link](https://github.com/alan-eu/alan-apps/pull/83066#pullrequestreview-3888730213)

### @MickaelBergem on `backend/apps/fr_api/migrations/scripts/20260303135917602607_add_country_to_occupational_health_billed_entity.py:1` (2026-03-04)
> Should we also UPDATE all existing ones to FR and then make the field non-nullable?

[link](https://github.com/alan-eu/alan-apps/pull/83066#discussion_r2883175478)

### @MickaelBergem on `backend/components/billing_occupational_health/internal/business_logic/queries/invoices_data.py:87` (2026-03-04)
> This PR is not forward-compatible (mix migration + business logic update) but since it's not often used it might be OK. Don't forget it's probably also used in the admin dashboard so could affect admins.

[link](https://github.com/alan-eu/alan-apps/pull/83066#discussion_r2883178876)

### @MickaelBergem on `backend/components/fr/internal/marmot/controllers/occupational_health/billing.py:86` (2026-03-04)
> Interesting choice of name, why not `country_code`?

[link](https://github.com/alan-eu/alan-apps/pull/83066#discussion_r2883180234)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/billing/BilledEntities.tsx:26` (2026-03-04)
> I don't think this change belongs here?

[link](https://github.com/alan-eu/alan-apps/pull/83066#discussion_r2883183029)

### @bastien-landre-alan on `backend/apps/fr_api/migrations/scripts/20260303135917602607_add_country_to_occupational_health_billed_entity.py:1` (2026-03-04)
> yes I will do that in a shell and in another PR as I will update the model also

[link](https://github.com/alan-eu/alan-apps/pull/83066#discussion_r2883591189)

### @bastien-landre-alan on `backend/components/fr/internal/marmot/controllers/occupational_health/billing.py:86` (2026-03-04)
> you're right, it's simpler to understand that't is FR/BE I will rename country to country_code everywhere

[link](https://github.com/alan-eu/alan-apps/pull/83066#discussion_r2883594737)

---

## PR #83150 — [BUSINESS] - enh: add postal_country to OccupationalHealthBilledEntity

_2026-03-05 • https://github.com/alan-eu/alan-apps/pull/83150_

### @MickaelBergem — review summary (APPROVED, 2026-03-04)
> Read _en diagonale_, trusting you ;)

[link](https://github.com/alan-eu/alan-apps/pull/83150#pullrequestreview-3890582632)

---

## PR #83206 — [Occ Health] Add acceptable lag of 10min when getting visits

_2026-03-05 • https://github.com/alan-eu/alan-apps/pull/83206_

### @MickaelBergem — review summary (APPROVED, 2026-03-05)
> Thanks a lot!

[link](https://github.com/alan-eu/alan-apps/pull/83206#pullrequestreview-3895259527)

---

## PR #83250 — occupational_health: new CLAUDE.md file

_2026-03-05 • https://github.com/alan-eu/alan-apps/pull/83250_

### @bastien-landre-alan — review summary (APPROVED, 2026-03-05)
> 🚀 

[link](https://github.com/alan-eu/alan-apps/pull/83250#pullrequestreview-3896322308)

---

## PR #83267 — fix(billing): skip installment plans for occupational health contracts for email

_2026-03-05 • https://github.com/alan-eu/alan-apps/pull/83267_

### @bastien-landre-alan — review summary (APPROVED, 2026-03-05)
> where does this installment_plan list come from ? to understand how we could have occupational_health one here 

[link](https://github.com/alan-eu/alan-apps/pull/83267#pullrequestreview-3896317856)

---

## PR #83329 — Add account_name to OccupationalHealthDashboardConfig controller response

_2026-03-06 • https://github.com/alan-eu/alan-apps/pull/83329_

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/admin_dashboard/admin_dashboard.py:614` (2026-03-06)
> I know it's tricky and we're not doing a great job at linting this, but can you move this import top-of-file. The main point of local imports is to save time (and memory footprint in rare cases) when booting the Flask app, as it starts by importing all the necessary files. Business logic files are rarely required at import time, so we inline the imports in the `commands/` and `controllers/` + never import business logic from `models/` files.
> 
> But inside an `internal/` business logic file, it is fine to have imports top of file, unless you're importing some gigantic library.

[link](https://github.com/alan-eu/alan-apps/pull/83329#discussion_r2894810327)

---

## PR #83334 — Add form to send email for requesting member information change

_2026-03-06 • https://github.com/alan-eu/alan-apps/pull/83334_

### @MickaelBergem — review summary (APPROVED, 2026-03-06)
> Looks good! Don't forget to archive the feature flag `release-oh-admin-request-member-changes` and to remove the unused Intercom workflows in both the test and the prod environments.

[link](https://github.com/alan-eu/alan-apps/pull/83334#pullrequestreview-3902666806)

### @MickaelBergem on `frontend/apps/fr-app/js/app/dashboard/occupationalHealth/employees/EmployeeSideModal.tsx:66` (2026-03-06)
> Two nits:
> 
> * since we cover public sector actors for health, we try to have the habit of naming employees "collaborateurs" instead of "salariés". The day we cover public sector subscribers, it'll work without requiring us to change all the copy
> * we still haven't cracked _écriture inclusive_ in our copy and I don't have a good suggestion to avoid "un salarié". Maybe `des informations pour Alice Breton` with the full name?

[link](https://github.com/alan-eu/alan-apps/pull/83334#discussion_r2894824900)

### @MickaelBergem on `frontend/apps/fr-app/js/app/dashboard/occupationalHealth/employees/EmployeeSideModal.tsx:69` (2026-03-06)
> ```suggestion
>       `Bonjour,\n\nJe souhaite modifier les informations suivantes pour ${memberName} :\n${message}\n\nID du profil : ${memberProfileId}\n\nCordialement,\n\n${adminName}\n\n—\nEnvoyé depuis le tableau de bord Médecine du Travail Prévenir`,
> ```

[link](https://github.com/alan-eu/alan-apps/pull/83334#discussion_r2894826907)

---

## PR #83352 — enh(marmot): enrich discrepancies with cancelled affiliations & decisions

_2026-03-06 • https://github.com/alan-eu/alan-apps/pull/83352_

### @MickaelBergem on `backend/components/occupational_health/public/marmot/entities.py:227` (2026-03-06)
> Should it just always be an empty list instead of None? I think we can simplify the interface as there is no semantic difference between `[]` and `None`.

[link](https://github.com/alan-eu/alan-apps/pull/83352#discussion_r2894711925)

### @MickaelBergem on `backend/components/occupational_health/public/marmot/queries.py:694` (2026-03-06)
> I would have preferred to have a `only_cancelled=True` - much simpler and leaner. Do you think you could simplify and edit the original `get_affiliation_list` to support this + add a TODO to build a repository later, as the number of edge cases is growing?

[link](https://github.com/alan-eu/alan-apps/pull/83352#discussion_r2894718237)

### @MickaelBergem on `backend/components/occupational_health/public/marmot/queries.py:689` (2026-03-06)
> Let's directly use the `get_all_affiliations` query, instead of the raw API from `affiliation_occ_health`. It should greatly simplify the code as you won't need to manipulate affiliable refs.

[link](https://github.com/alan-eu/alan-apps/pull/83352#discussion_r2894727805)

### @MickaelBergem on `backend/components/occupational_health/public/marmot/queries.py:699` (2026-03-06)
> Not needed if you use `get_all_affiliations` - and super weird not to directly use `build_profile_id_from_affiliable_ref`

[link](https://github.com/alan-eu/alan-apps/pull/83352#discussion_r2894729889)

### @MickaelBergem on `backend/components/occupational_health/public/marmot/queries.py:718` (2026-03-06)
> No biggie, but any reason to not put the model import top of file? 🤔 

[link](https://github.com/alan-eu/alan-apps/pull/83352#discussion_r2894732860)

### @MickaelBergem on `backend/components/occupational_health/public/marmot/queries.py:769` (2026-03-06)
> This looks very inefficient 🤔 (N+1 query)

[link](https://github.com/alan-eu/alan-apps/pull/83352#discussion_r2894753035)

### @bastien-landre-alan on `backend/components/occupational_health/public/marmot/queries.py:769` (2026-03-06)
> this doesn't do a db call
> The profile mapping is loaded previously with 
> ```
> profile_mapping = profile_service.user_compat.get_user_profile_mapping(
>         user_ids=user_ids
>     )
> ```
> then `profile_mapping.get_profile_for_user(int(user_id))` just use the loaded mapping without db call

[link](https://github.com/alan-eu/alan-apps/pull/83352#discussion_r2894854452)

### @MickaelBergem on `backend/components/occupational_health/public/marmot/queries.py:769` (2026-03-06)
> Oh interesting! Thanks.

[link](https://github.com/alan-eu/alan-apps/pull/83352#discussion_r2894857776)

---

## PR #83361 — Fix mediscribe visit matching: naming + timezone offset

_2026-03-06 • https://github.com/alan-eu/alan-apps/pull/83361_

### @MickaelBergem on `backend/components/medical_secrecy/internal/mediscribe/actions/create_mediscribe_audio_files_from_s3.py:82` (2026-03-05)
> What about winter time, where the offset is 2h with UTC? 😱 

[link](https://github.com/alan-eu/alan-apps/pull/83361#discussion_r2891325805)

---

## PR #83403 — [MIGRATION] enh: make postal_country_code mandatory & add country selector

_2026-03-09 • https://github.com/alan-eu/alan-apps/pull/83403_

### @MickaelBergem — review summary (APPROVED, 2026-03-06)
> Excellent if we don't need to add a new dependency on the JS side

[link](https://github.com/alan-eu/alan-apps/pull/83403#pullrequestreview-3902601691)

---

## PR #83496 — occupational_health: move billing buttons to same row as selects

_2026-03-06 • https://github.com/alan-eu/alan-apps/pull/83496_

### @bastien-landre-alan — review summary (APPROVED, 2026-03-06)
> ok for me, I didn't put it there because it's related to the year but not the period
> You don't generate fees for 2026 Q1 but for all 2026 (that's why I display the year near the button).
> 
> But I agree that it's not clear :D 

[link](https://github.com/alan-eu/alan-apps/pull/83496#pullrequestreview-3904087371)

---

## PR #83602 — Add account ID information in email for information update request

_2026-03-09 • https://github.com/alan-eu/alan-apps/pull/83602_

### @MickaelBergem — review summary (APPROVED, 2026-03-09)
> nit: I would move the IDs below the `Cordialement`

[link](https://github.com/alan-eu/alan-apps/pull/83602#pullrequestreview-3913740791)

---

## PR #83702 — occupational_health: add analyze-employment-sources command

_2026-03-10 • https://github.com/alan-eu/alan-apps/pull/83702_

### @bastien-landre-alan on `backend/components/occupational_health/internal/commands/analyze_employment_sources.py:54` (2026-03-10)
> nit I would explain quickly the data we return.
> Saying only `Analyze` we don't know what the usage of the command

[link](https://github.com/alan-eu/alan-apps/pull/83702#discussion_r2910316411)

---

## PR #83803 — OHSET-394: enh(occh): Billing - Use right NIC to find customer to bill

_2026-03-10 • https://github.com/alan-eu/alan-apps/pull/83803_

### @MickaelBergem — review summary (APPROVED, 2026-03-10)
> Implem looks good, I didn't look at the test.
> 
> Any chance you can refactor the code in a sub-function and deduplicate the check, to improve readability? Something like
> 
> ```
> def _find_nic_from_employment():
>   nic = None
>   for lookup_date in [to_bill_period.start_date, utctoday()]:
>     current_logger.debug(...)
>     nic = ...
>     if nic:
>       break
>   return nic

[link](https://github.com/alan-eu/alan-apps/pull/83803#pullrequestreview-3921063097)

---

## PR #83936 — occupational_health: replace 'affiliation error(s)' with 'billing issue(s)'

_2026-03-10 • https://github.com/alan-eu/alan-apps/pull/83936_

### @bastien-landre-alan — review summary (APPROVED, 2026-03-10)
> 🙏 

[link](https://github.com/alan-eu/alan-apps/pull/83936#pullrequestreview-3923795716)

---

## PR #83945 — occupational_health: add backfill NIC from affiliation logs command

_2026-03-11 • https://github.com/alan-eu/alan-apps/pull/83945_

### @bastien-landre-alan — review summary (APPROVED, 2026-03-11)
> only one real question on multiple NIC per employment

[link](https://github.com/alan-eu/alan-apps/pull/83945#pullrequestreview-3927610330)

### @MickaelBergem on `backend/components/occupational_health/internal/commands/backfill_nic_from_affiliation_logs.py:401` (2026-03-10)
> @mstmb-alan (as oncall): I went with the APIv2 since the other approach looked deprecated. I don't recall a specific announcement but figured that if the old one was deprecated I should use the new one.
> 
> Let me know if you see something bad! It seems to work perfectly locally.
> 

[link](https://github.com/alan-eu/alan-apps/pull/83945#discussion_r2913690559)

### @bastien-landre-alan on `backend/components/occupational_health/internal/commands/backfill_nic_from_affiliation_logs.py:37` (2026-03-11)
> What is a normalized siret ? 
> (should it be explained here ?)

[link](https://github.com/alan-eu/alan-apps/pull/83945#discussion_r2916568148)

### @bastien-landre-alan on `backend/components/occupational_health/internal/commands/backfill_nic_from_affiliation_logs.py:143` (2026-03-11)
> I would add a parameter to use Affiliation logs, to be able to run the command with only a file. and be explicit to use affiliation log

[link](https://github.com/alan-eu/alan-apps/pull/83945#discussion_r2916580137)

### @bastien-landre-alan on `backend/components/occupational_health/internal/commands/backfill_nic_from_affiliation_logs.py:309` (2026-03-11)
> What happen is the NIC changed during the employment ? or if we have multiple valid NIC for the same employment.
> Should we check this and display a warning ?

[link](https://github.com/alan-eu/alan-apps/pull/83945#discussion_r2916625407)

### @MickaelBergem on `backend/components/occupational_health/internal/commands/backfill_nic_from_affiliation_logs.py:37` (2026-03-11)
> It's just the name of the column Arthur used to build "clean" affiliation spreadsheets - before they get sent to the affiliator. Since the data comes from here, I'm just using the same header column.

[link](https://github.com/alan-eu/alan-apps/pull/83945#discussion_r2916639689)

### @MickaelBergem on `backend/components/occupational_health/internal/commands/backfill_nic_from_affiliation_logs.py:143` (2026-03-11)
> Maybe for a future iteration, let's see if we ever need to completely bypass affiliation logs.

[link](https://github.com/alan-eu/alan-apps/pull/83945#discussion_r2916642260)

### @MickaelBergem on `backend/components/occupational_health/internal/commands/backfill_nic_from_affiliation_logs.py:309` (2026-03-11)
> Good point. I'll iterate on this locally and push a new commit.

[link](https://github.com/alan-eu/alan-apps/pull/83945#discussion_r2916644708)

### @bastien-landre-alan on `backend/components/occupational_health/internal/commands/backfill_nic_from_affiliation_logs.py:309` (2026-03-11)
> If you want to test, this user ([employment](https://metabase.alan.com/dashboard/2358-employment-component-inspector?employment_id=&employment_source_data_id=b15f26c2-6ba1-4fbb-b5e9-66be42c3de59&show_cancelled%253F=true&source_type_pattern=&tab=693-%F0%9F%87%AB%F0%9F%87%B7-france-%28via-user-id%29&user_id=387702954), [values](https://api.alan.com/admin/extendedemploymentupdatemodel/?flt0_employment_id_equals=8c6e36ad-0e2d-4ba5-9b72-41b507ae874e)) have multiple NIC

[link](https://github.com/alan-eu/alan-apps/pull/83945#discussion_r2916691544)

### @MickaelBergem — issue comment (2026-03-11)
> This change is part of the following stack:
> 
> - #84024
>     - #83945 ◀
> 
> <sub>Change managed by [git-spice](https://abhinav.github.io/git-spice/).</sub>
> <!-- gs:navigation comment -->
> 

[link](https://github.com/alan-eu/alan-apps/pull/83945#issuecomment-4038139704)

---

## PR #84024 — employment: expose get_employment_value_timeline

_2026-03-11 • https://github.com/alan-eu/alan-apps/pull/84024_

### @MickaelBergem on `backend/components/employment/public/business_logic/queries/extended_employment_update.py:60` (2026-03-11)
> Good point. I'll just re-export without moving the definition, it keeps the original entities where they belong.

[link](https://github.com/alan-eu/alan-apps/pull/84024#discussion_r2917801918)

### @MickaelBergem — issue comment (2026-03-11)
> This change is part of the following stack:
> 
> - #84024 ◀
>     - #84037
>     - #83945
> 
> <sub>Change managed by [git-spice](https://abhinav.github.io/git-spice/).</sub>
> <!-- gs:navigation comment -->
> 

[link](https://github.com/alan-eu/alan-apps/pull/84024#issuecomment-4038009845)

---

## PR #84037 — occupational_health: display NIC timeline in member drawer

_2026-03-11 • https://github.com/alan-eu/alan-apps/pull/84037_

### @MickaelBergem — issue comment (2026-03-11)
> This change is part of the following stack:
> 
> - #84024
>     - #84037 ◀
> 
> <sub>Change managed by [git-spice](https://abhinav.github.io/git-spice/).</sub>
> <!-- gs:navigation comment -->
> 

[link](https://github.com/alan-eu/alan-apps/pull/84037#issuecomment-4038514146)

---

## PR #84380 — feat(🌐occ-health): Implement invoice preview

_2026-03-17 • https://github.com/alan-eu/alan-apps/pull/84380_

### @bastien-landre-alan on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/billing/BilledEntities.tsx:174` (2026-03-13)
> it would be nicer (easy to read) to build the preview invoice outside of the props I think. Could you extract it ?

[link](https://github.com/alan-eu/alan-apps/pull/84380#discussion_r2931485063)

### @bastien-landre-alan on `backend/components/billing_occupational_health/internal/controllers/invoices.py:81` (2026-03-13)
> to understand: Why did you change from send_pdf ?

[link](https://github.com/alan-eu/alan-apps/pull/84380#discussion_r2931487288)

### @bastien-landre-alan on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/billing/BillingInvoices.tsx:53` (2026-03-13)
> removing this mean that we can't preview "real invoice" in this table now ? It's important to use it mean we are able to check the final invoice and see if we have the same data as what we compute on the table
> 
> Could you put the action back ?

[link](https://github.com/alan-eu/alan-apps/pull/84380#discussion_r2931504177)

### @bastien-landre-alan on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/billing/BillingInvoices.tsx:53` (2026-03-13)
> yes of course I didn't see in the video the year and the regular selection 🤦 

[link](https://github.com/alan-eu/alan-apps/pull/84380#discussion_r2932213836)

---

## PR #84838 — fix(🌐occ-health/invoicing): force recompute option during preview

_2026-03-17 • https://github.com/alan-eu/alan-apps/pull/84838_

### @bastien-landre-alan — review summary (APPROVED, 2026-03-17)
> Is it only because of the "force recompute premiums" that we timeout ? Should we check this before starting the async workflow ?

[link](https://github.com/alan-eu/alan-apps/pull/84838#pullrequestreview-3960549400)

### @bastien-landre-alan — issue comment (2026-03-17)
> @ade-sede Does it mean that our API to generate invoice should also be async ? (it's not right now)

[link](https://github.com/alan-eu/alan-apps/pull/84838#issuecomment-4075043579)

---

## PR #84904 — feat(occ-health): display an alert when convocation has been sent but still not booked

_2026-03-18 • https://github.com/alan-eu/alan-apps/pull/84904_

### @bastien-landre-alan — review summary (APPROVED, 2026-03-18)
> small comments but LGTM
> small nit: when changing display (as you did for visit list), it's nice to add a "before"/"after" screenshot

[link](https://github.com/alan-eu/alan-apps/pull/84904#pullrequestreview-3965832407)

### @bastien-landre-alan on `frontend/apps/fr-app/js/app/dashboard/occupationalHealth/employees/useProfileVisitsHistory.ts:32` (2026-03-18)
> you could do this in the select no ?

[link](https://github.com/alan-eu/alan-apps/pull/84904#discussion_r2951624273)

### @bastien-landre-alan on `frontend/apps/fr-app/js/app/dashboard/occupationalHealth/employees/useProfileVisitsHistory.ts:10` (2026-03-18)
> I think the name is a bit miss-leading, we could think it's a react query.
> I think you could "transform" this to a react--query hook by returning useProfileDetailsQuery with specific select (and move it to the queries folder). Or maybe rename is to be more clear that it's a util around useProfileDetailsQuery

[link](https://github.com/alan-eu/alan-apps/pull/84904#discussion_r2951631635)

### @bastien-landre-alan on `frontend/apps/fr-app/js/app/dashboard/occupationalHealth/employees/EmployeeSideModal.tsx:151` (2026-03-18)
> isLate is not used anymore (except in next line) maybe not usefull now.

[link](https://github.com/alan-eu/alan-apps/pull/84904#discussion_r2951634847)

---

## PR #85325 — fix(occh): Fix installment plan in preview invoice

_2026-03-19 • https://github.com/alan-eu/alan-apps/pull/85325_

### @bastien-landre-alan on `backend/components/billing_occupational_health/internal/business_logic/actions/generate.py:244` (2026-03-19)
> you're right and logically we should not have installment plan in corrective invoice, I will remove it.

[link](https://github.com/alan-eu/alan-apps/pull/85325#discussion_r2960538568)

### @bastien-landre-alan on `backend/components/billing_occupational_health/internal/business_logic/actions/generate.py:244` (2026-03-19)
> Not possible for occupational_health at least, the should_create_installment_plan function check if there was no pevious invoice for this period, if there was it return False. So I don't think we should have corrective invoice as the first invoice of the preiod

[link](https://github.com/alan-eu/alan-apps/pull/85325#discussion_r2960621048)

---

## PR #85759 — occupational_health: return display names from accounts endpoint

_2026-03-23 • https://github.com/alan-eu/alan-apps/pull/85759_

### @bastien-landre-alan — review summary (APPROVED, 2026-03-23)
> LGTM, but will it not breack the front during deployments ? (I don't know how this API is used right now)

[link](https://github.com/alan-eu/alan-apps/pull/85759#pullrequestreview-3992941971)

### @MickaelBergem — issue comment (2026-03-23)
> This change is part of the following stack:
> 
> - #85759 ◀
>     - #85763
> 
> <sub>Change managed by [git-spice](https://abhinav.github.io/git-spice/).</sub>
> <!-- gs:navigation comment -->
> 

[link](https://github.com/alan-eu/alan-apps/pull/85759#issuecomment-4111693892)

### @MickaelBergem — issue comment (2026-03-23)
> > LGTM, but will it not breack the front during deployments ? (I don't know how this API is used right now)
> 
> It will, my assumption is that very few admins are using it + I will deploy soon but after hours, minimizing the risk 😇 

[link](https://github.com/alan-eu/alan-apps/pull/85759#issuecomment-4111882764)

---

## PR #85763 — occupational_health: add account switcher to dashboard sidebar

_2026-03-23 • https://github.com/alan-eu/alan-apps/pull/85763_

### @MickaelBergem on `frontend/apps/fr-app/js/app/dashboard/occupationalHealth/context/OccupationalHealthSelectedAccountContext.tsx:1` (2026-03-23)
> @lionelarmanet I would love to have a "makeSessionStorageContext(storageKey: string)" helper to save me the boilerplate in this file

[link](https://github.com/alan-eu/alan-apps/pull/85763#discussion_r2975786197)

### @MickaelBergem — issue comment (2026-03-23)
> This change is part of the following stack:
> 
> - #85759
>     - #85763 ◀
> 
> <sub>Change managed by [git-spice](https://abhinav.github.io/git-spice/).</sub>
> <!-- gs:navigation comment -->
> 

[link](https://github.com/alan-eu/alan-apps/pull/85763#issuecomment-4111693884)

---

## PR #85783 — [Occ health] Add endpoint to create on demand visit

_2026-03-23 • https://github.com/alan-eu/alan-apps/pull/85783_

### @MickaelBergem on `backend/components/fr/internal/marmot/controllers/occupational_health/visit_management.py:177` (2026-03-23)
> Who is the automation platform authenticating as?

[link](https://github.com/alan-eu/alan-apps/pull/85783#discussion_r2976135766)

### @bastien-landre-alan on `backend/components/fr/internal/marmot/controllers/occupational_health/visit_management.py:151` (2026-03-23)
> Why do we need email and phone number ? is it not linked to a ooccupational_health profile ?

[link](https://github.com/alan-eu/alan-apps/pull/85783#discussion_r2976137515)

### @MickaelBergem on `backend/components/fr/internal/marmot/controllers/occupational_health/visit_management.py:170` (2026-03-23)
> Any chance we can do the parameter parsing at the marshmallow level? Like date parsing, etc.

[link](https://github.com/alan-eu/alan-apps/pull/85783#discussion_r2976138562)

### @MickaelBergem on `backend/components/fr/internal/marmot/controllers/occupational_health/visit_management.py:187` (2026-03-23)
> Should we warn/raise, so that it breaks if Ops adds new questions we are notified quickly?

[link](https://github.com/alan-eu/alan-apps/pull/85783#discussion_r2976142550)

### @MickaelBergem on `backend/components/fr/internal/marmot/controllers/occupational_health/visit_management.py:199` (2026-03-23)
> I though the `load_default` was always setting a value, why do you need the `.get()`?

[link](https://github.com/alan-eu/alan-apps/pull/85783#discussion_r2976145616)

### @bastien-landre-alan on `backend/components/occupational_health/internal/business_logic/actions/on_demand_visit.py:45` (2026-03-23)
> feel a bit redundant to have both _parse_date_dd_mm_yyyy and _parse_datetime_iso that are nealy the same

[link](https://github.com/alan-eu/alan-apps/pull/85783#discussion_r2976146692)

### @MickaelBergem on `backend/components/fr/internal/marmot/controllers/occupational_health/visit_management.py:177` (2026-03-23)
> > `alan-fr-staging` 
> 
> That has access to the prod environment? 🤔 

[link](https://github.com/alan-eu/alan-apps/pull/85783#discussion_r2976173669)

---

## PR #85787 — OHSET-421 : enh(occh): Billing : Add corrective invoice email templates

_2026-03-31 • https://github.com/alan-eu/alan-apps/pull/85787_

### @MickaelBergem on `backend/components/fr/public/templates/mail/occupational_health/billing/billing_corrective_invoice_multiple.html:12` (2026-03-23)
> ```suggestion
>                 Elles correspondent à la cotisation annuelle de vos nouveaux collaborateurs arrivés pendant le 1e trimestre.
> ```
> 
> Looks clearer no?

[link](https://github.com/alan-eu/alan-apps/pull/85787#discussion_r2976187298)

### @MickaelBergem on `backend/components/fr/public/templates/mail/occupational_health/billing/billing_corrective_invoice_multiple.html:28` (2026-03-23)
> This assumes we generate the invoice on the first day of the billing cycle? Or is it the invoice "event date" and not the generation date?

[link](https://github.com/alan-eu/alan-apps/pull/85787#discussion_r2976192023)

### @MickaelBergem on `backend/components/occupational_health/internal/mailers/billing_invoice.py:195` (2026-03-23)
> I think in this specific case, moving the import at the top of the file would be better (I got bitten in the past as the import might trigger issues during tests, like leaking models etc)

[link](https://github.com/alan-eu/alan-apps/pull/85787#discussion_r2976210364)

### @MickaelBergem on `backend/components/occupational_health/dependencies.yml:16` (2026-03-23)
> Do we now have a circular dependency? 🤔 

[link](https://github.com/alan-eu/alan-apps/pull/85787#discussion_r2976213221)

### @MickaelBergem on `backend/components/occupational_health/internal/mailers/billing_invoice.py:189` (2026-03-23)
> I just checked and `// 4` is not safe if `amount` is a `float`. Is it an amount in euros or in cents? (I prefer to always name my amounts `amount_in_cents` as _[explicit is better than implicit](https://peps.python.org/pep-0020/)_)

[link](https://github.com/alan-eu/alan-apps/pull/85787#discussion_r2976230273)

### @bastien-landre-alan on `backend/components/fr/public/templates/mail/occupational_health/billing/billing_corrective_invoice_multiple.html:12` (2026-03-24)
> I will update to "arrivés pendant ce trimestre" to have something generic

[link](https://github.com/alan-eu/alan-apps/pull/85787#discussion_r2980002689)

### @bastien-landre-alan on `backend/components/fr/public/templates/mail/occupational_health/billing/billing_corrective_invoice_multiple.html:28` (2026-03-24)
> You're right, I should use event_Date, but have to fix it as for not it's still January 1st

[link](https://github.com/alan-eu/alan-apps/pull/85787#discussion_r2980005498)

### @bastien-landre-alan on `backend/components/occupational_health/dependencies.yml:16` (2026-03-24)
> yes thanks I will remove it's it's not usefull

[link](https://github.com/alan-eu/alan-apps/pull/85787#discussion_r2980007266)

### @bastien-landre-alan on `backend/components/occupational_health/internal/mailers/billing_invoice.py:189` (2026-03-24)
> It's in cent, I will rename them thanks

[link](https://github.com/alan-eu/alan-apps/pull/85787#discussion_r2980008811)

### @bastien-landre-alan on `backend/components/occupational_health/internal/mailers/billing_invoice.py:195` (2026-03-24)
> I keep it as lazy import to avoid the circular dependency you told me about.
> Don't know how we could have a better way to do it 

[link](https://github.com/alan-eu/alan-apps/pull/85787#discussion_r2980073149)

### @MickaelBergem on `backend/components/occupational_health/internal/mailers/billing_invoice.py:195` (2026-03-24)
> Ah, in that case what prevents us from killing the circular dependency issue?

[link](https://github.com/alan-eu/alan-apps/pull/85787#discussion_r2980255857)

---

## PR #85843 — fix(occupational_health): tests missing fixture

_2026-03-24 • https://github.com/alan-eu/alan-apps/pull/85843_

### @bastien-landre-alan — review summary (APPROVED, 2026-03-24)
> Thanks, do you know what changed ?

[link](https://github.com/alan-eu/alan-apps/pull/85843#pullrequestreview-3997481149)

### @MickaelBergem — issue comment (2026-03-24)
> > Thanks, do you know what changed ?
> 
> I think the tests were ran in an order that made the app somewhat available while it shouldn't.

[link](https://github.com/alan-eu/alan-apps/pull/85843#issuecomment-4116636141)

---

## PR #85993 — enh(Billing): OccH - Display balance breakdown on one-off invoice summary

_2026-03-25 • https://github.com/alan-eu/alan-apps/pull/85993_

### @bastien-landre-alan on `backend/shared/invoicing/templates/breathable/base.py:511` (2026-03-25)
> @axel-nemeth should we really use due_date here ? It seem weird, in the [template](https://www.figma.com/design/RdvZfD0sSkkQNj0EP9DVtc/Billing---global-billing?node-id=6672-5068&t=dIhQxC25xUlAlZZH-0) we display issued_date.

[link](https://github.com/alan-eu/alan-apps/pull/85993#discussion_r2987357391)

### @bastien-landre-alan on `backend/shared/invoicing/templates/breathable/translations/en.py:41` (2026-03-25)
> I moved it to the [bottom line ](https://github.com/alan-eu/alan-apps/pull/85993/changes#diff-21d8c1ada835fb502cf426420ccca266cc0fe2456cc1a33921bdd8a31b02bd64R54) to follow the [template](https://www.figma.com/design/RdvZfD0sSkkQNj0EP9DVtc/Billing---global-billing?node-id=6672-5068&t=dIhQxC25xUlAlZZH-0)

[link](https://github.com/alan-eu/alan-apps/pull/85993#discussion_r2988022726)

### @bastien-landre-alan — issue comment (2026-03-25)
> > Very nice thanks for this! I think it's missing one tiny logic. When the due amount differs from invoiced amount the payment summary (main text in bold) should be similar too: PAYMENT_SUMMARY_AMOUNT_TO_CHARGE = ( "On {due_date}, the due amount{marker} is {amount_to_charge}." This is working on non "on-off" invoices. So I think a small part might be missed as in your screenshot it stil uses ONE_OFF_INVOICE_PAYMENT_TEXT = ( "On {issue_date}, your invoice amounts to {invoice_amount}"
> > 
> > What we aim for the user point of view is to showcase what they need to pay (e.g to wire, or the amount that will be debited).
> 
> 
> 
> > Very nice thanks for this! I think it's missing one tiny logic. When the due amount differs from invoiced amount the payment summary (main text in bold) should be similar too: PAYMENT_SUMMARY_AMOUNT_TO_CHARGE = ( "On {due_date}, the due amount{marker} is {amount_to_charge}." This is working on non "on-off" invoices. So I think a small part might be missed as in your screenshot it stil uses ONE_OFF_INVOICE_PAYMENT_TEXT = ( "On {issue_date}, your invoice amounts to {invoice_amount}"
> > 
> > What we aim for the user point of view is to showcase what they need to pay (e.g to wire, or the amount that will be debited).
> 
> @axel-nemeth I update the PR, so the only change should be the (1) ?
> because the amount was already the total to pay and not the new invoice amount without balance
> 
> @ade-sede if you have a bit of time could you check the PR, to be honest it feel a bit redundant what I'm doing for one_off invoice that look like the same as classic invoice, but as I don't have the big picture maybe it's ok

[link](https://github.com/alan-eu/alan-apps/pull/85993#issuecomment-4124568923)

### @bastien-landre-alan — issue comment (2026-03-25)
> > This change is taking us in the wrong direction IMO
> > 
> > A few pointers to get you going in the right direction
> > 
> >     * anything that has to do with the summary should be encapsulated in [build_payment_summary_section](https://github.com/alan-eu/alan-apps/blob/d6cb410affed8bafda1803c4c515614a5bd163cc/backend/shared/invoicing/templates/breathable/base.py#L480-L484) (it was merged yesterday, you couldn't have known 😛)
> > 
> >     * I see no reason to limit this change to 'one off' invoices
> > 
> >     * the predicate is `if InvoicePremiumBreakdown.invoice_amount != InvoicePremiumBreakdown.amount_to_charge
> >       
> >       * you can add the 'breakdown' to the base class
> > 
> > 
> > On another note, I thought we already have these copy somewhere in the codebase. I feel like Axel introduced them in a previous PR
> 
> @ade-sede I updated the code, mainly remove the one_off text as it's quite the same as classic invoice except the way we display dates sometime.

[link](https://github.com/alan-eu/alan-apps/pull/85993#issuecomment-4125537127)

---

## PR #86046 — affiliator: warn on contract start date >3 months from today

_2026-03-31 • https://github.com/alan-eu/alan-apps/pull/86046_

### @bastien-landre-alan — review summary (APPROVED, 2026-03-30)
> So nice, thanks 🙏 

[link](https://github.com/alan-eu/alan-apps/pull/86046#pullrequestreview-4030420851)

---

## PR #86117 — implementing empty state when no employee

_2026-03-31 • https://github.com/alan-eu/alan-apps/pull/86117_

### @MickaelBergem — issue comment (2026-03-25)
> <img width="1724" height="910" alt="image" src="https://github.com/user-attachments/assets/166054ce-bd5e-4c6e-91bf-7ec31fabad9b" />
> 
> @lmbonnefont ideally we would go the extra mile and make the "add a new employee" more actionable. There is no easy solution (nothing that works fine for both standalone and non-standalone subscribers) so we can keep it like this for now, but let's keep in mind it's not optimal.

[link](https://github.com/alan-eu/alan-apps/pull/86117#issuecomment-4128627007)

### @MickaelBergem — issue comment (2026-03-25)
> Should we also replace the first sentence "0 collaborateur affilié, dont 0 SIA et 0 SIR" by just "Aucun collaborateur n'est affilié à Prévenir à ce jour"?

[link](https://github.com/alan-eu/alan-apps/pull/86117#issuecomment-4128633517)

### @MickaelBergem — issue comment (2026-03-30)
> 
> > I assume we have a different Intercom workflow for:
> > - companies standalone: where we ask them required info
> > - companies non-standalone: where we ask admin if they added the employee to health first
> > 
> > Can we trigger the right Intercom workflow based on if they have Alan health or not? 
> 
> We do not. Better affiliation for standalone was on the Q1 roadmap but got deprioritized. Nothing has been framed yet but I agree it's not very complex.

[link](https://github.com/alan-eu/alan-apps/pull/86117#issuecomment-4154111604)

---

## PR #86369 — feat(fr): add DSN establishments endpoint for SIRET dropdown

_2026-04-02 • https://github.com/alan-eu/alan-apps/pull/86369_

### @MickaelBergem — review summary (APPROVED, 2026-04-01)
> Ok to not add performance tracking, let's iterate if we notice it's slow.

[link](https://github.com/alan-eu/alan-apps/pull/86369#pullrequestreview-4044339878)

### @MickaelBergem on `backend/components/fr/internal/business_logic/company/queries/dsn_establishments.py:12` (2026-04-01)
> I don't think inlining imports in business logic files is useful, except for large 3rd-party libs.
> 
> Usually we recomment inlining imports when in controllers, commands, or anything that gets loaded publicly or at app boot time.

[link](https://github.com/alan-eu/alan-apps/pull/86369#discussion_r3022225853)

### @MickaelBergem on `backend/components/fr/internal/business_logic/company/queries/dsn_establishments.py:14` (2026-04-01)
> nit: if it'll be called often we could also speed things up by only reading the SIREN field from Company.

[link](https://github.com/alan-eu/alan-apps/pull/86369#discussion_r3022230927)

### @MickaelBergem on `backend/components/fr/internal/business_logic/company/entities/dsn_establishment.py:13` (2026-04-01)
> Shouldn't we also store the SIREN as part of the dataclass itself?

[link](https://github.com/alan-eu/alan-apps/pull/86369#discussion_r3022234482)

---

## PR #86423 — Remove tstring translation

_2026-03-31 • https://github.com/alan-eu/alan-apps/pull/86423_

### @MickaelBergem — review summary (APPROVED, 2026-03-30)
> @lottebijlsma will love that 🫣 

[link](https://github.com/alan-eu/alan-apps/pull/86423#pullrequestreview-4031099177)

---

## PR #86521 — fix(occh) : Billing - Update how we display date in invoice billing

_2026-04-01 • https://github.com/alan-eu/alan-apps/pull/86521_

### @MickaelBergem — review summary (CHANGES_REQUESTED, 2026-03-31)
> 1. Can we go the extra mile and display the exact start date?
> 2. Will this still work next year? Because if my contract starts on 2026-01-01, my Q1 2027 invoice will reflect members on 2027-01-01, not at the contract start date

[link](https://github.com/alan-eu/alan-apps/pull/86521#pullrequestreview-4035768367)

### @MickaelBergem — review summary (APPROVED, 2026-04-01)
> What about end-of-year regul invoices? Will we need to send them manually?
> 
> I would recommend adding a unit test just to make sure, or raising a NotImplementedError() to be scrappy and solve it later.

[link](https://github.com/alan-eu/alan-apps/pull/86521#pullrequestreview-4043992114)

### @bastien-landre-alan on `backend/components/occupational_health/internal/mailers/billing_invoice.py:258` (2026-04-01)
> moved from " if is_corrective:" as it will be used in both template

[link](https://github.com/alan-eu/alan-apps/pull/86521#discussion_r3020797996)

### @bastien-landre-alan on `backend/components/occupational_health/internal/mailers/billing_invoice.py:271` (2026-04-01)
> Update from event_date to issued_date

[link](https://github.com/alan-eu/alan-apps/pull/86521#discussion_r3021379792)

### @MickaelBergem on `backend/components/fr/public/templates/mail/occupational_health/billing/billing_corrective_invoice_multiple.html:27` (2026-04-01)
> this is no longer a date, I would rename the variable to ACTIVE_PERIOD_STR or something like that

[link](https://github.com/alan-eu/alan-apps/pull/86521#discussion_r3021909467)

### @MickaelBergem on `backend/components/occupational_health/internal/mailers/tests/test_billing_invoice.py:243` (2026-04-01)
> ```suggestion
> def test_wording_for_q2_invoice(
> ```

[link](https://github.com/alan-eu/alan-apps/pull/86521#discussion_r3021912057)

### @MickaelBergem on `backend/components/occupational_health/internal/mailers/billing_invoice.py:47` (2026-04-01)
> I would say the end of year regul invoice is generated on the 01/01 (much like the Q1 invoice...)

[link](https://github.com/alan-eu/alan-apps/pull/86521#discussion_r3021922535)

### @MickaelBergem on `backend/components/occupational_health/public/entities/billing.py:68` (2026-04-01)
> Can you clarify that we will never return end-of-year-regul billing periods?

[link](https://github.com/alan-eu/alan-apps/pull/86521#discussion_r3021930002)

### @bastien-landre-alan — issue comment (2026-03-31)
> > 1. Can we go the extra mile and display the exact start date?
> > 
> >     2. Will this still work next year? Because if my contract starts on 2026-01-01, my Q1 2027 invoice will reflect members on 2027-01-01, not at the contract start date
> 
> @MickaelBergem 
> >Can we go the extra mile and display the exact start date?
> 
> The issue we have is that as it's not the Q1 flow (checking people actif on 01/01) but the Q2 flow (people actif between 01/01 and 31/03 We don't list only people actif on the contract start date.
> I think it's ok for our 7 new client but to be sure I didn't want to add a specific date.
> 
> >Will this still work next year? Because if my contract starts on 2026-01-01, my Q1 2027 invoice will reflect members on 2027-01-01, not at the contract start date
> 
> You're right that it will not work on 2027/01/01. The thing is I don't have an easy solution as those invoices are a mix of Q1 and regularization and I wanted something quick to fix the email for April 01 when I will send the email.
> 
> I will try to find a better solution

[link](https://github.com/alan-eu/alan-apps/pull/86521#issuecomment-4161082169)

### @bastien-landre-alan — issue comment (2026-04-01)
> thanks @MickaelBergem Agree with end of year regule, I will merge as is to be able to send invoice today and to another PR from your comment

[link](https://github.com/alan-eu/alan-apps/pull/86521#issuecomment-4169927000)

---

## PR #86540 — feat: SIRET autocomplete for employee invitation

_2026-04-02 • https://github.com/alan-eu/alan-apps/pull/86540_

### @MickaelBergem on `frontend/apps/fr-app/js/app/dashboard/v2/pro/employees/modals/invites/CoverByDefaultInviteForm.tsx:1` (2026-04-01)
> We might have English-speaking admins in the FR admin dashboard 👉 let's make sure we translate all strings in the 🇫🇷 admin dashboard.

[link](https://github.com/alan-eu/alan-apps/pull/86540#discussion_r3022252672)

### @MickaelBergem on `frontend/apps/fr-app/js/app/dashboard/v2/pro/employees/modals/invites/CoverByDefaultInviteForm.tsx:437` (2026-04-01)
> When the list is not loaded, I would display a placeholder instead. I don't know how the component renders but it could flash with the "empty list" state before displaying the right one, while we could use a react-skeleton instead.

[link](https://github.com/alan-eu/alan-apps/pull/86540#discussion_r3022256787)

### @MickaelBergem on `frontend/apps/fr-app/js/app/dashboard/v2/pro/employees/modals/invites/CoverByDefaultInviteForm.tsx:553` (2026-04-01)
> nit: I tend to add docstrings (`/*** .. **/`) above such components to explain quickly what the component does. It helps other engineers discovering the component + understanding what it does.

[link](https://github.com/alan-eu/alan-apps/pull/86540#discussion_r3022268047)

### @MickaelBergem on `frontend/apps/fr-app/js/app/dashboard/v2/pro/employees/modals/invites/CoverByDefaultInviteForm.tsx:514` (2026-04-01)
> Please avoid single-letter variables: modern IDEs + AI agents can easily use more verbose names, and it makes reading it so much easier. Here it's not immediately clear what `e` is for without looking at the context.

[link](https://github.com/alan-eu/alan-apps/pull/86540#discussion_r3022285745)

### @MickaelBergem on `frontend/apps/fr-app/js/app/dashboard/v2/pro/employees/modals/invites/CoverByDefaultInviteForm.tsx:514` (2026-04-01)
> Can we move `toSuggestion` out of the component render function? It'll marginally improve perf but also will prevent unnecessary re-renders in some cases.

[link](https://github.com/alan-eu/alan-apps/pull/86540#discussion_r3022292625)

### @MickaelBergem on `frontend/apps/fr-app/js/app/dashboard/v2/pro/employees/modals/invites/CoverByDefaultInviteForm.tsx:596` (2026-04-01)
> Can you add tracking so that we get events in Amplitude when such a suggestion is clicked?

[link](https://github.com/alan-eu/alan-apps/pull/86540#discussion_r3022298964)

### @MickaelBergem on `frontend/apps/fr-app/js/app/dashboard/v2/pro/employees/modals/invites/CoverByDefaultInviteForm.tsx:622` (2026-04-01)
> I would also track reset events

[link](https://github.com/alan-eu/alan-apps/pull/86540#discussion_r3022300474)

### @MickaelBergem on `frontend/shared/fr-api-sdk/companyApi/useCompanyDsnEstablishmentsQuery.ts:13` (2026-04-01)
> I don't understand the name: "get query options" while you're loading DSN establishments 🤔 

[link](https://github.com/alan-eu/alan-apps/pull/86540#discussion_r3022304636)

### @MickaelBergem on `frontend/shared/fr-api-sdk/companyApi/useCompanyDsnEstablishmentsQuery.ts:15` (2026-04-01)
> is this common pattern? 😱 
> 
> I would have added a fixed `company` prefix for instance to avoid collisions, but let's remain consistent with other queries 🤷 

[link](https://github.com/alan-eu/alan-apps/pull/86540#discussion_r3022307863)

### @MickaelBergem on `frontend/apps/fr-app/js/app/dashboard/v2/pro/employees/modals/invites/CoverByDefaultInviteForm.tsx:1` (2026-04-01)
> See [this very recent product announcement](https://alanhealth.slack.com/archives/C017M1KQ57U/p1774965787002539) (you're supposed to have read it)

[link](https://github.com/alan-eu/alan-apps/pull/86540#discussion_r3022316918)

---

## PR #86654 — chore: cleanup backend side reference of Mind contracts in subscriptions code

_2026-04-03 • https://github.com/alan-eu/alan-apps/pull/86654_

### @MickaelBergem — review summary (APPROVED, 2026-04-03)
> Do you confirm we are OK with losing the information of who had a contract with Mind + not being able to link it to past payments (eg Finance and the Finance data are 👍)?

[link](https://github.com/alan-eu/alan-apps/pull/86654#pullrequestreview-4054837578)

---

## PR #86756 — Fix backend health professional referrent reassign sandra

_2026-04-01 • https://github.com/alan-eu/alan-apps/pull/86756_

### @MickaelBergem on `backend/components/occupational_health/internal/constants/health_professional_mapping.py:113` (2026-04-01)
> Not sure this will age well

[link](https://github.com/alan-eu/alan-apps/pull/86756#discussion_r3021686534)

---

## PR #86785 — fix(occupational_health): billing email review fixes + END_OF_YEAR_REGUL

_2026-04-14 • https://github.com/alan-eu/alan-apps/pull/86785_

### @MickaelBergem on `backend/components/occupational_health/internal/mailers/billing_invoice.py:50` (2026-04-07)
> So calling it with `END_OF_YEAR_REGUL` will... raise I assume? ("not supported")

[link](https://github.com/alan-eu/alan-apps/pull/86785#discussion_r3043535262)

---

## PR #87062 — remove now useless relationship event->mind_contract and company->mind_contracts type hint

_2026-04-07 • https://github.com/alan-eu/alan-apps/pull/87062_

### @MickaelBergem on `backend/components/fr/internal/models/event.py:137` (2026-04-07)
> Should we also defer + evaluate_none this field? 🤔 

[link](https://github.com/alan-eu/alan-apps/pull/87062#discussion_r3043413518)

### @MickaelBergem on `backend/components/fr/internal/models/event.py:137` (2026-04-07)
> I have no idea what `Event` is for (and I don't want to know) so I totally trust you

[link](https://github.com/alan-eu/alan-apps/pull/87062#discussion_r3043558152)

---

## PR #87071 — feat(occupational_health): add Intercom conversation endpoint for member changes

_2026-04-07 • https://github.com/alan-eu/alan-apps/pull/87071_

### @MickaelBergem — review summary (APPROVED, 2026-04-07)
> Looks good but the code looks AI-generated and there were many small things you could have caught yourself before review ;)

[link](https://github.com/alan-eu/alan-apps/pull/87071#pullrequestreview-4066360526)

### @MickaelBergem on `backend/components/occupational_health/internal/controllers/admin_dashboard.py:289` (2026-04-07)
> I think the convention is to use underscores in URL, no? Maybe there is a way to tell Claude to do it if it's not already documented

[link](https://github.com/alan-eu/alan-apps/pull/87071#discussion_r3043421453)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/actions/request_member_changes.py:24` (2026-04-07)
> I would use a `UserId` here instead of an `int` and convert to int right before passing it to the fr-specific action.

[link](https://github.com/alan-eu/alan-apps/pull/87071#discussion_r3043434273)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/actions/request_member_changes.py:45` (2026-04-07)
> Good point!

[link](https://github.com/alan-eu/alan-apps/pull/87071#discussion_r3043436196)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/actions/request_member_changes.py:53` (2026-04-07)
> I wonder if there is a preferred way between getting the profile_service through the decorator vs intializing it like this @Diaoul ?

[link](https://github.com/alan-eu/alan-apps/pull/87071#discussion_r3043443958)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/actions/request_member_changes.py:71` (2026-04-07)
> ```suggestion
>     # Build conversation body
> ```
> 
> This comment will not be interesting for future engineers reading the code

[link](https://github.com/alan-eu/alan-apps/pull/87071#discussion_r3043448505)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/actions/request_member_changes.py:135` (2026-04-07)
> Should we `.exception()` instead of `.warning()` so that it gets surfaced in Sentry?
> 
> ```suggestion
>         current_logger.exception(
>             "Failed to leave note on conversation",
>             conversation_id=conversation_id,
>         )
> ```

[link](https://github.com/alan-eu/alan-apps/pull/87071#discussion_r3043452999)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/actions/request_member_changes.py:132` (2026-04-07)
> * Not `Compte` in French 😅 
> * It will be much easier for Ops to click on links: can you make the account name clickable (leading to the affiliation tower)?
> 
> 

[link](https://github.com/alan-eu/alan-apps/pull/87071#discussion_r3043457733)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/actions/request_member_changes.py:132` (2026-04-08)
> > Why not Compte in French? It's for ops for FR no? :)
> 
> Sure but then why mix "Compte" and "Account ID"? I think in French Ops always use the word "account" but maybe I'm wrong.
> 
> No biggie, as long as it's easy for Ops newjoiners to understand what we're talking about ;)

[link](https://github.com/alan-eu/alan-apps/pull/87071#discussion_r3049833102)

### @MickaelBergem — issue comment (2026-04-07)
> > Hey @MickaelBergem thank you so much for your review!
> > 
> > You are right, I should have caught some of the little things before review (mainly the comment and the url format). I won't have this kind of mistake in the next PRs :)
> > 
> > Some other little things are still hard to catch for me as they linked to the project and its history (UserID, Warning, links for care). I'll promise I'll ramp up on the specificities of the code base and will not have this kind of mistake in the coming weeks.
> > 
> > For other (Compte), I was simply mistaken as the message is in French :)
> 
> No worries, it's part of the normal onboarding process ;) 🤗 

[link](https://github.com/alan-eu/alan-apps/pull/87071#issuecomment-4200341018)

---

## PR #87079 — feat(occupational_health): replace mailto with API call in admin dashboard

_2026-04-07 • https://github.com/alan-eu/alan-apps/pull/87079_

### @MickaelBergem on `frontend/apps/fr-app/js/app/dashboard/occupationalHealth/employees/EmployeeSideModal.tsx:65` (2026-04-07)
> When sharing about the feature on Slack, can you mention how many times this button had been clicked / by how many admins, based on the Amplitude data? (data is missing for the admins who didn't accept cookies but still gives an order of magnitude)

[link](https://github.com/alan-eu/alan-apps/pull/87079#discussion_r3043585375)

### @MickaelBergem on `frontend/apps/fr-app/js/app/dashboard/occupationalHealth/employees/EmployeeSideModal.tsx:86` (2026-04-07)
> This will immediately disappear right? I would use a toaster instead so that the user can read the notification (visual feedback that message was sent is important, esp. as nothing else will change on the page).

[link](https://github.com/alan-eu/alan-apps/pull/87079#discussion_r3043590640)

### @MickaelBergem on `frontend/apps/fr-app/js/app/dashboard/occupationalHealth/queries/useRequestMemberChangesMutation.ts:21` (2026-04-07)
> Convention is to use underscores in URL, not dashes.

[link](https://github.com/alan-eu/alan-apps/pull/87079#discussion_r3043592561)

---

## PR #87355 — feat: show 5 default DSN establishment suggestions without typing

_2026-04-09 • https://github.com/alan-eu/alan-apps/pull/87355_

### @MickaelBergem — review summary (APPROVED, 2026-04-08)
> Ok but would need to be tested extensively

[link](https://github.com/alan-eu/alan-apps/pull/87355#pullrequestreview-4073686646)

### @MickaelBergem on `frontend/apps/fr-app/js/app/dashboard/v2/pro/employees/modals/invites/CoverByDefaultInviteForm.tsx:575` (2026-04-08)
> Will this still work if the focus moved to the suggestion instead of the field itself? Eg if we control the field with the keyboard vs the mouse.

[link](https://github.com/alan-eu/alan-apps/pull/87355#discussion_r3050018938)

### @MickaelBergem on `frontend/apps/fr-app/js/app/dashboard/v2/pro/employees/modals/invites/CoverByDefaultInviteForm.tsx:660` (2026-04-08)
> Can you add a comment in the code explaining why we need a timeout (and why 200ms)?

[link](https://github.com/alan-eu/alan-apps/pull/87355#discussion_r3050030854)

### @MickaelBergem on `frontend/apps/fr-app/js/app/dashboard/v2/pro/employees/modals/invites/CoverByDefaultInviteForm.tsx:660` (2026-04-08)
> Can you add a comment in the code explaining why we need a timeout (and why 200ms)?

[link](https://github.com/alan-eu/alan-apps/pull/87355#discussion_r3050031758)

### @MickaelBergem on `frontend/apps/fr-app/js/app/dashboard/v2/pro/employees/modals/invites/CoverByDefaultInviteForm.tsx:575` (2026-04-08)
> lol hello Claude

[link](https://github.com/alan-eu/alan-apps/pull/87355#discussion_r3051868657)

### @MickaelBergem on `frontend/apps/fr-app/js/app/dashboard/v2/pro/employees/modals/invites/CoverByDefaultInviteForm.tsx:575` (2026-04-08)
> Feel free to huddle if you need clarification!

[link](https://github.com/alan-eu/alan-apps/pull/87355#discussion_r3051937845)

---

## PR #87394 — occupational_health: add cancelled affiliations modal in Marmot

_2026-04-09 • https://github.com/alan-eu/alan-apps/pull/87394_

### @MickaelBergem on `backend/components/occupational_health/public/marmot/queries.py:146` (2026-04-09)
> > what is your policy on unit testing?
> 
> Depending on the streams we need to prioritize aggressively and for internal tools I find it acceptable to not write tests. This also saves time when iterating on the code because we don't have to maintain the tests.
> 
> For external-facing features I'm more nuanced: if it's easy to test then let's cover the main cases.
> 
> I will only go to 100% test coverage for critical features that are sufficiently mature, or when unit testing actually makes it easier/faster to build the feature.

[link](https://github.com/alan-eu/alan-apps/pull/87394#discussion_r3056890318)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/affiliatedMembers/index.tsx:561` (2026-04-09)
> Aligned the UX could be simplified.
> 
> This is work that I did on the side and that isn't prioritized = we aren't supposed to spend much time on it. I find that the current UX is better than before (=nothing). If you want to dedicate time to improving the UX, then be my guest, but be mindful of how you prioritize your time vs roadmap commitments.
> 
> Keep in mind that we're talking about an internal tool used by 1-3 Alaners every day maximum, so the prioritization and UX standards are different vs an externally-facing product used by customers.

[link](https://github.com/alan-eu/alan-apps/pull/87394#discussion_r3056917322)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/affiliatedMembers/CancelledAffiliationsModal.tsx:19` (2026-04-09)
> Yes indeed we should

[link](https://github.com/alan-eu/alan-apps/pull/87394#discussion_r3056918441)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/affiliatedMembers/CancelledAffiliationsModal.tsx:38` (2026-04-09)
> Yes and it's acceptable for this iteration I think

[link](https://github.com/alan-eu/alan-apps/pull/87394#discussion_r3056921188)

### @MickaelBergem — issue comment (2026-04-09)
> @lmbonnefont thanks for the push on quality, I really appreciate the mindset and it's important to keep it for the admin dashboard. For internal tools it's less important, especially since this is on-the-side work that wasn't prioritized in the roadmap.
> 
> I won't iterate further on the feature, can you approve as-is?

[link](https://github.com/alan-eu/alan-apps/pull/87394#issuecomment-4213218182)

---

## PR #87424 — [Occ health] Remove fr import and use occ health dependency

_2026-04-08 • https://github.com/alan-eu/alan-apps/pull/87424_

### @MickaelBergem — review summary (APPROVED, 2026-04-08)
> Thanks! Was this written entirely by you (vs Claude)?

[link](https://github.com/alan-eu/alan-apps/pull/87424#pullrequestreview-4075681082)

---

## PR #87443 — feat(occupational_health): polish Prévenir employee export

_2026-04-13 • https://github.com/alan-eu/alan-apps/pull/87443_

### @MickaelBergem on `backend/components/occupational_health/internal/controllers/admin_dashboard.py:485` (2026-04-09)
> How confident are you that it's enough? Should we replace all non-ASCII characters? What if there is a `%` in my account name, or a `?`?

[link](https://github.com/alan-eu/alan-apps/pull/87443#discussion_r3057182160)

### @MickaelBergem on `backend/components/occupational_health/internal/controllers/admin_dashboard.py:486` (2026-04-09)
> This is a UTC date, not a local date, for us it's not a huge deal (wrong date if export created between 10pm and midnight) but ideally we would first convert the UTC date to local time first. This could become an issue the day we open the product in other timezones (eg DOM/TOM etc).

[link](https://github.com/alan-eu/alan-apps/pull/87443#discussion_r3057191292)

### @MickaelBergem on `backend/components/occupational_health/public/actions/tests/test_employee_export.py:109` (2026-04-09)
> Can we use `faker.Dataclass` instead? [See here](https://alanhealth.slack.com/archives/CB55CK36Y/p1767368902229769).

[link](https://github.com/alan-eu/alan-apps/pull/87443#discussion_r3057198644)

### @MickaelBergem on `frontend/modules/async-exports/src/internal/components/ExportModal.tsx:83` (2026-04-09)
> What's the impact of this change? Do you own migrating the potentially existing Amplitude dashboards?

[link](https://github.com/alan-eu/alan-apps/pull/87443#discussion_r3057210461)

### @MickaelBergem on `frontend/modules/async-exports/src/internal/components/ExportModal.tsx:211` (2026-04-09)
> In general, we appreciate if you share a screenshot of the resulting UI/UX, it helps reviewers understand the new state.
> 
> Here I wonder if we're left with a tab bar with a single tab or not 🤔 

[link](https://github.com/alan-eu/alan-apps/pull/87443#discussion_r3057218440)

### @MickaelBergem on `backend/components/occupational_health/internal/controllers/admin_dashboard.py:485` (2026-04-13)
> I renamed the Glitter account in acceptance just to make sure and it looks like it's working 🆗 
> 
> You can impersonate (act as) https://acceptance.alan.com/marmot/fr/user/11941291

[link](https://github.com/alan-eu/alan-apps/pull/87443#discussion_r3074191604)

### @MickaelBergem on `frontend/modules/async-exports/src/internal/components/ExportModal.tsx:211` (2026-04-13)
> Sounds good to me! 👌 

[link](https://github.com/alan-eu/alan-apps/pull/87443#discussion_r3074196052)

---

## PR #87771 — fix(post-visit): delete sub-field when field unchecked

_2026-04-10 • https://github.com/alan-eu/alan-apps/pull/87771_

### @MickaelBergem on `frontend/apps/medical-software/app/modals/postVisit/ConclusionStep.tsx:213` (2026-04-10)
> This looks hacky, is there not another way? Like having the field be a `string | null`? I have little context over the existing codebase but I'm wondering if there isn't a simpler solution.

[link](https://github.com/alan-eu/alan-apps/pull/87771#discussion_r3064485062)

---

## PR #87848 — feat(occupational_health): DPAE matching tool POC

_2026-04-15 • https://github.com/alan-eu/alan-apps/pull/87848_

### @MickaelBergem — review summary (COMMENTED, 2026-04-13)
> I didn't have time to review all of this, re-request a review from me once you handled the feedback I shared ;)

[link](https://github.com/alan-eu/alan-apps/pull/87848#pullrequestreview-4097692077)

### @MickaelBergem — review summary (COMMENTED, 2026-04-14)
> Partial review - I'll finish after lunch!

[link](https://github.com/alan-eu/alan-apps/pull/87848#pullrequestreview-4105199237)

### @MickaelBergem — review summary (APPROVED, 2026-04-14)
> Many small things to improve, fix them and then merge your PR 🤗 
> 
> Since it's an internal tool that's well-scoped and cannot break much, I'm OK to relax our quality standards and get the PR merged before you end your woodchuck period with us.

[link](https://github.com/alan-eu/alan-apps/pull/87848#pullrequestreview-4105573076)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/dpae/parse_csv.py:21` (2026-04-13)
> Let's move these to a dedicated `dpae/helpers.py` file

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3072048888)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/dpae/parse_csv.py:273` (2026-04-13)
> small feedback on terminology: I think `classify` is clearer and more conventional than `categorize`. Reading the signature_docstring alone, it's unclear what's being returned and how rows are "categorized" by company status.
> 
> I'd recommend:
> * making the return type more explicit, at least by removing the `Any`
> * once the implementation is mature, adding one extra line to describe exactly what's going on

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3072059294)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/dpae/parse_csv.py:251` (2026-04-13)
> I find `defaultdict` easier to manipulate than using `setdefault`.
> 
> ```suggestion
>     lookup: dict[str, dict[str | None, UUID]] = defaultdict(dict)
>     for siren, nic, account_id in results:
>         lookup[siren][nic] = account_id
> ```

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3072064797)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/dpae/parse_csv.py:58` (2026-04-13)
> I think using `csv` and maybe even `csv.DictReader` could simplify your code?
> 
> You can probably pass the list of header fields, which will allow you to use `fields["married_name"]` instead of `fields[21]`.

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3072071193)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/dpae/parse_csv.py:68` (2026-04-13)
> Let's never silently ignore errors without explaining why.
> 
> Here do you expect to find invalid SIRETs? I think "this is not supposed to happen" so I would either completely crash the execution, or at least `current_logger.exception("Invalid SIRET found in DPAE CSV")` so that we have a stacktrace sent to Sentry (check this tool out if you haven't yet!).
> 
> If there is a valid reason to find invalid SIRETs and it's OK to ignore the row, I would at least log a warning.

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3072082603)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/dpae/parse_csv.py:72` (2026-04-13)
> Let's use a dataclass instead of a dict. It'll make many things easier: accessing fields, typing, ensuring you don't mistype the field name, etc.

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3072094370)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/dpae/parse_csv.py:83` (2026-04-13)
> ```suggestion
>                 "contract_start_date": _format_date(fields[25]),
> ```

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3072095173)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/dpae/parse_csv.py:80` (2026-04-13)
> I don't think we're using `married_name` anywhere already, are we? If not, let's maybe check the semantic behind `given_name` and rename the other `birth_name`?

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3072099210)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/dpae/parse_csv.py:81` (2026-04-13)
> Let's also use an enum here instead of a string. Beware of the difference between sex vs gender.

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3072102419)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/dpae/parse_csv.py:96` (2026-04-13)
> I'm curious how this will perform as soon as we have composed names or names with a _particule_ ("de la tour" could match with "tour" while they are different last names).

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3072107313)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/dpae/parse_csv.py:111` (2026-04-13)
> Indeed let's not do that - use OccupationalHealthDependency and/or the ProfileService

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3072109693)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/dpae/parse_csv.py:115` (2026-04-13)
> You don't need to inline the imports from `shared` ;)

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3072112167)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/dpae/parse_csv.py:68` (2026-04-14)
> > if it is just a user mistake?
> 
> Good point. I would at least log a warning, but yes ideally we would run a sanity check on the columns we expect to be present.

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3078758109)

### @MickaelBergem on `backend/components/occupational_health/public/dependencies.py:234` (2026-04-14)
> I don't think matching against unordered sets of name chunks is a good tradeoff as I'm afraid it will increase the number of false positive matches. Do you know what portion of the data is concerned at this point?
> 
> I sent you the latest data (overlaps with the previously-sent export) if you want to dig in the data.
> 
> We can keep things like this, but maybe add a note that this logic might need to be reworked as it opens the door to false positives.

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3078795553)

### @MickaelBergem on `backend/components/occupational_health/public/dependencies.py:243` (2026-04-14)
> What does the `None` NIC mean?
> 
> Also from the name I would expect you'd return "companies" but you're returning a mapping of NICs to account_ids. Maybe `get_nic_mapping_by_sirens()`?

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3078801744)

### @MickaelBergem on `backend/components/occupational_health/public/entities/dpae.py:15` (2026-04-14)
> Please use an enum here

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3078803735)

### @MickaelBergem on `backend/components/occupational_health/public/entities/dpae.py:11` (2026-04-14)
> Let's use the `UserId` type

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3078804691)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/dpae/persist.py:17` (2026-04-14)
> I'd prefer if we kept the persistence code in a dedicated PR 🙈 

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3079110750)

### @MickaelBergem on `backend/components/fr/bootstrap/dependencies/occupational_health.py:395` (2026-04-14)
> Shared code should always be imported at top-level (not inline in a function body), unless they load a massive dependency - which is not the case here.

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3079115749)

### @MickaelBergem on `backend/components/fr/bootstrap/dependencies/occupational_health.py:412` (2026-04-14)
> You are assuming that the parameters `last_names` and `first_names` have been lowered and unaccented, and you're not doing it inside this function.
> 
> Why don't you lower + unaccent the input names directly in this function? It would help keep the string processing logic in the same place.

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3079121860)

### @MickaelBergem on `backend/components/fr/bootstrap/dependencies/occupational_health.py:408` (2026-04-14)
> You should use the Employment Component to query the list of employments, instead of the legacy `Employment` model. For this PR it's OK - let's keep things simple and iterate later - but let's add a TODO to remember to migrate the code (we'll probably do it after your woodchuck ends).

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3079127375)

### @MickaelBergem on `backend/components/fr/bootstrap/dependencies/occupational_health.py:455` (2026-04-14)
> I don't understand why this method is in `FrOccupationalHealthDependency` since you're using something that already comes from `occupational_health` - in that case instead of using `dependency.get_dpae_employees()` you could directly use `load_dpae_employees` 🤔 

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3079135655)

### @MickaelBergem on `backend/components/fr/bootstrap/dependencies/occupational_health.py:450` (2026-04-14)
> Let's keep the persistence layer for a dedicated PR :(

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3079136845)

### @MickaelBergem on `backend/components/fr/internal/marmot/controllers/occupational_health/dpae.py:25` (2026-04-14)
> Why is there a single `csv_content` and a plural `file_names`? If it's a list, you should use a different field (not `fields.Str()` I guess) no?

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3079141667)

### @MickaelBergem on `backend/components/fr/internal/marmot/controllers/occupational_health/dpae.py:35` (2026-04-14)
> nit: we tend to use `r.to_dict()` vs `asdict()` - it requires DataClassJsonMixin IIRC on the dataclass

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3079145377)

### @MickaelBergem on `backend/components/fr/internal/marmot/controllers/occupational_health/dpae.py:35` (2026-04-14)
> nit: please avoid single-letter variables, today's IDEs and AI agents can easily expand the variable into something clearer
> ```suggestion
>         "prevenir_customers": [asdict(customer) for customer in result.prevenir_customers],
> ```

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3079148742)

### @MickaelBergem on `backend/components/fr/internal/marmot/controllers/occupational_health/dpae.py:35` (2026-04-14)
> nit: from a terminology point of view, Prévenir doesn't have "customers", it has "subscribers" (companies who subscribed to Prévenir), because Prévenir is a non-profit (so no "clients" but just "adhérents" in French).

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3079152185)

### @MickaelBergem on `backend/components/fr/internal/marmot/controllers/occupational_health/dpae.py:67` (2026-04-14)
> 👍 ok to keep an `.exception()` for now and we'll iterate if it's too noisy

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3079155679)

### @MickaelBergem on `backend/components/fr/internal/marmot/controllers/occupational_health/dpae.py:72` (2026-04-14)
> You can also `raise BadRequest()` (with additional content) if needed - let's make sure to keep the error mentioned in the response body either way

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3079158304)

### @MickaelBergem on `backend/components/fr/internal/marmot/controllers/occupational_health/dpae.py:26` (2026-04-14)
> I see the parameter is optional: when is it provided and when is it not? 🤔 

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3079162899)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/dpae/helpers.py:14` (2026-04-14)
> nit: let's maybe ensure the raw string is the right length?

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3079167374)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/dpae/helpers.py:25` (2026-04-14)
> Thanks for the clear docstrings! You might also be interested in learning more about `doctest` - we don't use it much but it's another way to represent what you wrote, and can even be unit tested!

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3079172902)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/dpae/parse_csv.py:57` (2026-04-14)
> Please add a comment explaining what this means / is for

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3079175828)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/dpae/parse_csv.py:63` (2026-04-14)
> Isn't there an existing Gender enum we could reuse? I'm OK with keeping our own enum if we have good reason 

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3079179025)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/dpae/parse_csv.py:67` (2026-04-14)
> If "profile gender" is an enum, let's use the enum directly instead of the `"male"` and `"female"` strings.

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3079181116)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/dpae/parse_csv.py:76` (2026-04-14)
> If this includes a time, it should be `datetime` (if not then `date` is correct)

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3079183621)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/dpae/parse_csv.py:90` (2026-04-14)
> ```suggestion
>     account_id: AccountId | None = None
> ```

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3079185649)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/dpae/parse_csv.py:88` (2026-04-14)
> ```suggestion
>     matched_user_id: UserId | None = None
> ```
> 
> (you will need to convert the user_id as a `str` though but it will be clearer everywhere what we're manipulating)

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3079187924)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/dpae/parse_csv.py:89` (2026-04-14)
> nit: it's not immediately clear what `str` will be contained. Is it a matching status (`success`, `only_on_health`, `no_match`)? If yes an enum would be better. If it's a company name, I would expect we also return the `company_id`.

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3079191849)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/dpae/parse_csv.py:115` (2026-04-14)
> Excellent! 👌 

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3079194067)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/dpae/parse_csv.py:126` (2026-04-14)
> so no DictReader, and we keep reading as `fields[2]` instead of `fields['created_at']`?

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3079197518)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/dpae/parse_csv.py:158` (2026-04-14)
> nit: I would split the matching logic in a dedicated file, but maybe it's overkill

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3079200094)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/dpae/parse_csv.py:272` (2026-04-14)
> let's use an enum for these statuses + document what they mean: it's not clear to me what `ambiguous` means.

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3079205797)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/dpae/parse_csv.py:295` (2026-04-14)
> Why don't you directly declare `row.account_id` as an `AccountId` type? You wouldn't have to convert it to a str, nor to cast it on L296

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3079210618)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/dpae/parse_csv.py:126` (2026-04-15)
> Check out [the documentation of DictReader](https://docs.python.org/fr/3/library/csv.html#csv.DictReader) to see what I meant:
> 
> ```
>     reader = csv.DictReader(csvfile, fieldnames=['created_at', 'first_name', 'last_name'])
>     for row in reader:
>         print(row['first_name'], row['last_name'])
> ```
> 
> This allows you to explicit what is the expected column order in the CSV (through `fieldnames=`).

[link](https://github.com/alan-eu/alan-apps/pull/87848#discussion_r3084842861)

### @MickaelBergem — issue comment (2026-04-14)
> @marinbouanchaud in these cases, to make the second review easier, can you:
> 
> 1. "resolve the conversation" for the threads where the discussion is closed (eg reviewer asked for something, you implemented it)? Let's keep the ones asking a question and where you posted an answer open.
> <img width="811" height="1082" alt="image" src="https://github.com/user-attachments/assets/13cf46e6-4db3-476e-a8dd-d577af582553" />
> 
> 
> 
> 2. re-request review once the PR is ready to be reviewed again
> <img width="432" height="137" alt="image" src="https://github.com/user-attachments/assets/78e6dfe7-abcd-4d2c-8463-d595b40ec05c" />
> 

[link](https://github.com/alan-eu/alan-apps/pull/87848#issuecomment-4243157875)

---

## PR #87917 — feat(occupational_health): add Dpae and DpaeEmployee models

_2026-04-15 • https://github.com/alan-eu/alan-apps/pull/87917_

### @MickaelBergem — review summary (APPROVED, 2026-04-14)
> Looks good to me! You might want to also expose them in the Flask Admin configuration, so that we can see them in Flask Admin.

[link](https://github.com/alan-eu/alan-apps/pull/87917#pullrequestreview-4106277408)

### @MickaelBergem on `backend/components/occupational_health/internal/models/dpae.py:19` (2026-04-14)
> "Upload session" is unclear. Is this an uploaded file? If yes, check out `BaseRemoteFile` - it would allow you to store the CSV on AWS S3 as part of the model in the DB, so that we can later reprocess it if needed, etc.
> 
> Then you should rename the model to something like `DpaeExportFile` or `DpaeCsvFile` for instance.

[link](https://github.com/alan-eu/alan-apps/pull/87917#discussion_r3079796979)

### @MickaelBergem on `backend/components/occupational_health/internal/models/dpae_employee.py:39` (2026-04-14)
> Please use an enum - see `AlanBaseEnumTypeDecorator` (and the mandatory `.create_validator()` that comes with it) for how to make it happen. It'll ensure the data we store is one of the enum fields + make it easier to edit in Flask Admin if ever, etc.

[link](https://github.com/alan-eu/alan-apps/pull/87917#discussion_r3079810591)

### @MickaelBergem on `backend/components/occupational_health/internal/models/dpae_employee.py:31` (2026-04-14)
> nit: you could use `SIRET_LENGTH` from `shared.validators.siren_siret_validator`

[link](https://github.com/alan-eu/alan-apps/pull/87917#discussion_r3079815863)

### @MickaelBergem on `backend/components/occupational_health/internal/models/dpae_employee.py:31` (2026-04-14)
> also nit: please add a `validates_siret` to ensure we always store valid SIRETs

[link](https://github.com/alan-eu/alan-apps/pull/87917#discussion_r3079818812)

### @MickaelBergem on `backend/components/occupational_health/internal/models/dpae_employee.py:41` (2026-04-14)
> For consistency, should we write `birth_date`?

[link](https://github.com/alan-eu/alan-apps/pull/87917#discussion_r3079821441)

### @MickaelBergem on `backend/components/occupational_health/internal/models/dpae_employee.py:47` (2026-04-14)
> I don't think we should allow edition in Flask Admin for the crew members, let's remove this line

[link](https://github.com/alan-eu/alan-apps/pull/87917#discussion_r3079824412)

### @MickaelBergem on `backend/components/occupational_health/internal/models/dpae_employee.py:18` (2026-04-14)
> So we don't store the computed matching? In the mid-term, having a link to the `profile_id` or `user_id` would be great (for later).

[link](https://github.com/alan-eu/alan-apps/pull/87917#discussion_r3079828284)

---

## PR #87918 — feat(occupational_health): DPAE matching marmot frontend

_2026-04-15 • https://github.com/alan-eu/alan-apps/pull/87918_

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/dpae/index.tsx:47` (2026-04-14)
> If it's a function, maybe rename it to `computeUniqueSiretCount` or `countUniqueSirets`? Otherwise it looks like a variable.

[link](https://github.com/alan-eu/alan-apps/pull/87918#discussion_r3079855256)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/dpae/index.tsx:112` (2026-04-14)
> Please add `{ }` for readability 🙈 
> 
> We should enforce it with a linter I believe.

[link](https://github.com/alan-eu/alan-apps/pull/87918#discussion_r3079897645)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/dpae/index.tsx:170` (2026-04-14)
> Is there not already a component that links to Flask Admin and does just that? Also why do you need to stop the propagation of the onclick? 🤔 

[link](https://github.com/alan-eu/alan-apps/pull/87918#discussion_r3079902506)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/dpae/index.tsx:242` (2026-04-14)
> nit: you could move the result display to a dedicated component for better readability (smaller files are easier to read)

[link](https://github.com/alan-eu/alan-apps/pull/87918#discussion_r3079912615)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/MarmotIndex.tsx:649` (2026-04-14)
> Thanks a lot 👌 

[link](https://github.com/alan-eu/alan-apps/pull/87918#discussion_r3079916091)

### @MickaelBergem on `frontend/apps/fr-marmot/components/fr/OccupationalHealth/dpae/index.tsx:170` (2026-04-15)
> Got it! In those cases it's worth adding a comment to explain why it's needed

[link](https://github.com/alan-eu/alan-apps/pull/87918#discussion_r3086668373)

### @MickaelBergem — issue comment (2026-04-14)
> Note: for frontend work, we usually welcome screenshots or videos so that reviewers can see what this is about
> 
> Here I found the page [in the preview](https://pr-87918-web-fr.alan.reviews/marmot/fr/occupational-health/dpae) but I can't see past the initial upload page since the backend isn't deployed yet 

[link](https://github.com/alan-eu/alan-apps/pull/87918#issuecomment-4244316161)

---

## PR #87958 — OHSET-476 : fix(occupational_health): prevent duplicate employment data rows

_2026-04-14 • https://github.com/alan-eu/alan-apps/pull/87958_

### @MickaelBergem — review summary (APPROVED, 2026-04-13)
> Thanks! We definitely should have done that from the data model design stage. I don't have any idea how we can get better at this beyond just repeating the message but we should use DB constraints all the time

[link](https://github.com/alan-eu/alan-apps/pull/87958#pullrequestreview-4098609855)

### @bastien-landre-alan on `backend/components/occupational_health/internal/models/occupational_health_profile.py:128` (2026-04-13)
> I don't remember why I accepted multiple row in the get but it's an error (on the upsert I update the current line)

[link](https://github.com/alan-eu/alan-apps/pull/87958#discussion_r3072714658)

### @bastien-landre-alan on `backend/apps/fr_api/migrations/scripts/20260413122540000000_add_unique_constraint_oh_profile_employment_data.py:25` (2026-04-13)
> This is mostly for Kay/local DB as there is no duplicate in prod anymore

[link](https://github.com/alan-eu/alan-apps/pull/87958#discussion_r3072736896)

### @MickaelBergem on `backend/apps/fr_api/migrations/scripts/20260413122540000000_add_unique_constraint_oh_profile_employment_data.py:25` (2026-04-13)
> This delete statement is scary, if it doesn't target prod can you add a "if not is_prod()" guard and not execute the DELETE in prod?

[link](https://github.com/alan-eu/alan-apps/pull/87958#discussion_r3072905524)

### @MickaelBergem on `backend/components/occupational_health/public/actions/account.py:503` (2026-04-13)
> Should we be smarter and "merge" the fields instead of deleting the duplicate? Eg if email is set in one but not the other?

[link](https://github.com/alan-eu/alan-apps/pull/87958#discussion_r3072916976)

### @bastien-landre-alan on `backend/components/occupational_health/public/actions/account.py:503` (2026-04-13)
> As the only information in the employment data is the email, we should not have empty email.
> I prefer not add complexity for a case that should not exist

[link](https://github.com/alan-eu/alan-apps/pull/87958#discussion_r3073096168)

---

## PR #87968 — fix(occupational_health): use Turing data for SIRET dropdown

_2026-04-14 • https://github.com/alan-eu/alan-apps/pull/87968_

### @MickaelBergem — review summary (COMMENTED, 2026-04-13)
> I don't understand what are the guarantees behind that model from Turing. Can you explain why you believe it'll be more complete, and esp. for companies that are partially with Prévenir, why it will include the SIRETs not covered by Prévenir?

[link](https://github.com/alan-eu/alan-apps/pull/87968#pullrequestreview-4099465706)

### @MickaelBergem on `backend/components/occupational_health/public/testing.py:9` (2026-04-13)
> I'm not a huge fan of making test factories public but I guess we don't have a better solution to do integration tests 🤔 

[link](https://github.com/alan-eu/alan-apps/pull/87968#discussion_r3073701888)

### @MickaelBergem on `backend/components/occupational_health/public/testing.py:9` (2026-04-14)
> Factories are better than crafting the object yourself (otherwise if someone else adds a new field in the model, they'd have to update all the tests creating an instance of the model, vs just updating the factory to provide a default value).
> 
> But making a test factory public means leaking the model to other components (which is something we try to avoid, models are supposed to remain "private" to the component).

[link](https://github.com/alan-eu/alan-apps/pull/87968#discussion_r3078658753)

---

## PR #88137 — feat(occupational_health): display pending affiliations in admin dashboard

_2026-04-16 • https://github.com/alan-eu/alan-apps/pull/88137_

### @bastien-landre-alan on `backend/components/occupational_health/internal/business_logic/queries/admin_dashboard/admin_dashboard.py:765` (2026-04-14)
> I thought about it, but as we should not have much companies here (just the subset of company from an account that have current pending affiliation).
> I thought that I didn't want to add a new method that we have to be maintain to avoid 2/3 calls

[link](https://github.com/alan-eu/alan-apps/pull/88137#discussion_r3079657936)

### @bastien-landre-alan on `frontend/apps/fr-app/js/app/dashboard/occupationalHealth/pendingAffiliations/PendingAffiliationsPage.tsx:142` (2026-04-14)
> It's read only for now (first PR), but we will have action available in the next PR

[link](https://github.com/alan-eu/alan-apps/pull/88137#discussion_r3079660159)

### @bastien-landre-alan on `frontend/apps/fr-app/js/app/dashboard/occupationalHealth/employees/Affiliations.tsx:188` (2026-04-14)
> The load of the next page will be track (automatically), I think it's enough as it's the only way to access it.

[link](https://github.com/alan-eu/alan-apps/pull/88137#discussion_r3079668264)

### @bastien-landre-alan — issue comment (2026-04-14)
> This change is part of the following stack:
> 
> - #88137 ◀
>     - #88246
> 
> <sub>Change managed by [git-spice](https://abhinav.github.io/git-spice/).</sub>
> <!-- gs:navigation comment -->
> 

[link](https://github.com/alan-eu/alan-apps/pull/88137#issuecomment-4245737106)

---

## PR #88246 — feat(occupational_health): accept/reject pending affiliation decisions

_2026-04-16 • https://github.com/alan-eu/alan-apps/pull/88246_

### @bastien-landre-alan on `backend/components/occupational_health/internal/business_logic/actions/affiliation_decision/update.py:27` (2026-04-14)
> This is moved from public/marmot, I just added some check/raise

[link](https://github.com/alan-eu/alan-apps/pull/88246#discussion_r3081197259)

### @bastien-landre-alan on `backend/components/occupational_health/internal/business_logic/actions/affiliation_decision/update.py:89` (2026-04-15)
> we. are calling `affiliate_member` from affiliation.py, so it will be log here

[link](https://github.com/alan-eu/alan-apps/pull/88246#discussion_r3086586304)

### @bastien-landre-alan on `frontend/apps/fr-app/js/app/dashboard/occupationalHealth/pendingAffiliations/PendingAffiliationsPage.tsx:122` (2026-04-15)
> There is a ticket (less prio) to add a "revert" button on the success toast that I will work on later

[link](https://github.com/alan-eu/alan-apps/pull/88246#discussion_r3086589413)

### @bastien-landre-alan on `frontend/apps/fr-app/js/app/dashboard/occupationalHealth/pendingAffiliations/PendingAffiliationsPage.tsx:75` (2026-04-15)
> We could, but the next PR will be to handle this case, and as it's behind a feature flag it's ok for now (don't want to add code I will remove in a few hours)

[link](https://github.com/alan-eu/alan-apps/pull/88246#discussion_r3086595002)

### @bastien-landre-alan — issue comment (2026-04-14)
> This change is part of the following stack:
> 
> - #88137
>     - #88246 ◀
>         - #88526
> 
> <sub>Change managed by [git-spice](https://abhinav.github.io/git-spice/).</sub>
> <!-- gs:navigation comment -->
> 

[link](https://github.com/alan-eu/alan-apps/pull/88246#issuecomment-4245737096)

---

## PR #88307 — Add ins model component

_2026-04-17 • https://github.com/alan-eu/alan-apps/pull/88307_

### @MickaelBergem — review summary (APPROVED, 2026-04-16)
> LGTM, I wonder how you see the future of the existing `shared` code (at least `icanopee`). It would stay there? Move here?

[link](https://github.com/alan-eu/alan-apps/pull/88307#pullrequestreview-4118878512)

### @MickaelBergem on `backend/components/clinic/internal/models/insi/ins_identity.py:36` (2026-04-16)
> I assume it works well but I've seen cases in the past where it didn't: I'd recommend you quickly check if it's still taken into account now that it's moved in the parent

[link](https://github.com/alan-eu/alan-apps/pull/88307#discussion_r3091317349)

### @MickaelBergem on `backend/components/ins/bootstrap/bootstrap.py:10` (2026-04-16)
> But you are defining it in `backend/components/ins/bootstrap/load_all_models.py` (empty as well) - should we directly kill the `backend/components/ins/bootstrap/load_all_models.py` file?

[link](https://github.com/alan-eu/alan-apps/pull/88307#discussion_r3091322328)

### @MickaelBergem on `backend/components/ins/public/enums/identity_status.py:26` (2026-04-16)
> ```suggestion
>         """Return True if an INS has been retrieved from the INSi service."""
> ```

[link](https://github.com/alan-eu/alan-apps/pull/88307#discussion_r3091324400)

### @MickaelBergem on `backend/components/ins/public/enums/identity_status.py:31` (2026-04-16)
> ```suggestion
>         """Return True if the INS is fully qualified (= validated AND retrieved)."""
> ```

[link](https://github.com/alan-eu/alan-apps/pull/88307#discussion_r3091325856)

---

## PR #88355 — Add ins model backend logic

_2026-04-17 • https://github.com/alan-eu/alan-apps/pull/88355_

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/ins/queries.py:46` (2026-04-16)
> This is the first time I read "INS number" - I wonder if it's official terminology or if we added a new "concept / name", adding complexity and possible sources of confusion for newjoiners (cc @emmagoldblum)

[link](https://github.com/alan-eu/alan-apps/pull/88355#discussion_r3091357276)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/profiles/profiles.py:98` (2026-04-16)
> Out of curiosity, what is the unicode char?

[link](https://github.com/alan-eu/alan-apps/pull/88355#discussion_r3091362910)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/profiles/profiles.py:102` (2026-04-16)
> I don't understand why we have to explicitly cast `occupational_health_profile.id` as `ProfileId`, it should already be the case
> 
> <img width="477" height="249" alt="Image" src="https://github.com/user-attachments/assets/2912e270-95f1-4d5b-ab10-614f423d9ee2" />

[link](https://github.com/alan-eu/alan-apps/pull/88355#discussion_r3091367330)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/profiles/profiles.py:116` (2026-04-16)
> Answered [here](https://github.com/alan-eu/Topics/discussions/32641#discussioncomment-16581784): OK to remove it 👌 

[link](https://github.com/alan-eu/alan-apps/pull/88355#discussion_r3091384429)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/ins/queries.py:46` (2026-04-16)
> @emmagoldblum I think this terminology is inconsistent with [what the ANS is using](https://esante.gouv.fr/sites/default/files/media_entity/documents/rniv-1-principes-communs.pdf) 🤔 
> 
> * "matricule" is 15 chars
> * composed of the "numéro NIR" (13) + key (2)
> 
> It's weird - I would push to keep using the same terminology as the ANS or to remain as close as possible to them.
> 
> <img width="773" height="271" alt="image" src="https://github.com/user-attachments/assets/da2bcc03-d3d4-40a3-8df4-a7773826af98" />
> 
> <img width="731" height="102" alt="image" src="https://github.com/user-attachments/assets/ef7bccc1-6f20-4693-80c7-323194929601" />
> 

[link](https://github.com/alan-eu/alan-apps/pull/88355#discussion_r3092126237)

---

## PR #88356 — Add ins model frontend

_2026-04-17 • https://github.com/alan-eu/alan-apps/pull/88356_

### @MickaelBergem on `frontend/apps/medical-software/app/hooks/types.ts:460` (2026-04-16)
> Why don't you use the more readable French characters directly? 🤔 

[link](https://github.com/alan-eu/alan-apps/pull/88356#discussion_r3091399223)

---

## PR #88378 — Add ins model for occupational health migration

_2026-04-17 • https://github.com/alan-eu/alan-apps/pull/88378_

### @MickaelBergem on `backend/components/occupational_health/internal/models/occupational_health_ins_identity.py:19` (2026-04-16)
> Can you document what it means to have an INS Identity but no associated profile? When would this happen? Can we make it non-nullable?

[link](https://github.com/alan-eu/alan-apps/pull/88378#discussion_r3091346901)

---

## PR #88451 — occupational_health: add import_member_emails_from_csv CLI command

_2026-04-17 • https://github.com/alan-eu/alan-apps/pull/88451_

### @bastien-landre-alan — review summary (CHANGES_REQUESTED, 2026-04-16)
> LGTM except for the log that display email. Not 100% sure about the criticity but I would not send them to datadog.

[link](https://github.com/alan-eu/alan-apps/pull/88451#pullrequestreview-4118837626)

### @bastien-landre-alan — review summary (APPROVED, 2026-04-17)
> Thanks for the "email log" change.
> To be honest I'm not 100% sure that we should not send them to datadog. But if we think about GDPR, we have no need to "store" them in datadog. 
> Better safe than sorry :D 

[link](https://github.com/alan-eu/alan-apps/pull/88451#pullrequestreview-4127355310)

### @bastien-landre-alan on `backend/components/occupational_health/internal/commands/import_member_emails_from_csv.py:38` (2026-04-16)
> I would say that the required column is pro email as it should be the default one (as it's given by the admin it should be consider the "pro" email)

[link](https://github.com/alan-eu/alan-apps/pull/88451#discussion_r3091279376)

### @bastien-landre-alan on `backend/components/occupational_health/internal/commands/import_member_emails_from_csv.py:41` (2026-04-16)
> why do we have 2 column name for pro email ? 
> it's not referenced here: https://www.notion.so/alaninsurance/Mass-update-member-email-addresses-from-CSV-3431426e8be781f4b26bd6551e622d08

[link](https://github.com/alan-eu/alan-apps/pull/88451#discussion_r3091291290)

### @bastien-landre-alan on `backend/components/occupational_health/internal/commands/import_member_emails_from_csv.py:124` (2026-04-16)
> we should log employee email (will be sent to datadog)

[link](https://github.com/alan-eu/alan-apps/pull/88451#discussion_r3091300378)

### @bastien-landre-alan on `backend/components/occupational_health/internal/commands/import_member_emails_from_csv.py:171` (2026-04-16)
> personal question: I used to add `current_session.rollback()` on dry_run command to be sure  ("ceinture + bretelle"). Do you think it's useless ?

[link](https://github.com/alan-eu/alan-apps/pull/88451#discussion_r3091310604)

### @MickaelBergem on `backend/components/occupational_health/internal/commands/import_member_emails_from_csv.py:41` (2026-04-16)
> I accept two possible names, the first one was what Ops had given me for the spreadsheet they had sent. "Guessed" because he had tried to guess the email addresses of the employees based on their name.

[link](https://github.com/alan-eu/alan-apps/pull/88451#discussion_r3094562169)

### @MickaelBergem on `backend/components/occupational_health/internal/commands/import_member_emails_from_csv.py:124` (2026-04-16)
> we should NOT* right?
> 
> Here I wonder what's the impact, as anything showed in stdout will land in Datadog, but not showing the emails makes it harder to work with the command. Given how rarely we run this command I'm tempted to still merge as-is... :/

[link](https://github.com/alan-eu/alan-apps/pull/88451#discussion_r3094586391)

### @MickaelBergem on `backend/components/occupational_health/internal/commands/import_member_emails_from_csv.py:171` (2026-04-16)
> I expect the dry_run decorator to take care of it, doesn't it already do it? 🤷 

[link](https://github.com/alan-eu/alan-apps/pull/88451#discussion_r3094589688)

### @MickaelBergem on `backend/components/occupational_health/internal/commands/import_member_emails_from_csv.py:38` (2026-04-16)
> Both are required, we just keep things dynamic to support multiple possible names for the pro one.
> 
> Only the column is required, not the values.

[link](https://github.com/alan-eu/alan-apps/pull/88451#discussion_r3094639334)

### @MickaelBergem on `backend/components/occupational_health/internal/commands/import_member_emails_from_csv.py:124` (2026-04-16)
> Allez, I'm redacting partially the addresses 🤷 

[link](https://github.com/alan-eu/alan-apps/pull/88451#discussion_r3094641231)

### @bastien-landre-alan on `backend/components/occupational_health/internal/commands/import_member_emails_from_csv.py:41` (2026-04-17)
> Do you think we will always use both ? Maybe update the notion page to explain it (not a big deal)

[link](https://github.com/alan-eu/alan-apps/pull/88451#discussion_r3098969273)

### @bastien-landre-alan on `backend/components/occupational_health/internal/commands/import_member_emails_from_csv.py:171` (2026-04-17)
> yes sorry I was thinking about script without the dry_run decorator

[link](https://github.com/alan-eu/alan-apps/pull/88451#discussion_r3098973458)

---

## PR #88526 — feat(occupational_health): SIRET display + establishment selection on pending affiliations

_2026-04-22 • https://github.com/alan-eu/alan-apps/pull/88526_

### @MickaelBergem — review summary (COMMENTED, 2026-04-16)
> The PR is quite long, I'll continue reviewing tomorrow.

[link](https://github.com/alan-eu/alan-apps/pull/88526#pullrequestreview-4122677877)

### @MickaelBergem on `backend/components/fr/internal/controllers/company.py:2879` (2026-04-16)
> I had added a rule in `occupational_health` for Claude to never use the acronym `OH` but it looks like it wasn't picked up :(
> 
> Can you replace to Occupational Health instead? OH is not clear to anybody at Alan unfortunately :(

[link](https://github.com/alan-eu/alan-apps/pull/88526#discussion_r3094815557)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/admin_dashboard/entities.py:77` (2026-04-16)
> ```suggestion
>     company_id: CompanyId
> ```

[link](https://github.com/alan-eu/alan-apps/pull/88526#discussion_r3094837977)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/admin_dashboard/entities.py:77` (2026-04-16)
> The docstring feels weird ("company-based or SIRET-based" while `company_id` is always mandatory)

[link](https://github.com/alan-eu/alan-apps/pull/88526#discussion_r3094842797)

### @MickaelBergem on `backend/components/occupational_health/internal/controllers/admin_dashboard.py:218` (2026-04-16)
> I think the convention is to use `_` in URLs no? I personnally love dashes in URL, but I value consistency more (no guessing of which `_` or `-` to use)

[link](https://github.com/alan-eu/alan-apps/pull/88526#discussion_r3094846398)

### @MickaelBergem on `backend/components/occupational_health/internal/controllers/admin_dashboard.py:225` (2026-04-16)
> Aren't we already exposing an endpoint for this (maybe in `fr` directly)?
> 
> If changing this endpoint would break something in `fr` then the endpoint should live in `fr` directly

[link](https://github.com/alan-eu/alan-apps/pull/88526#discussion_r3094850035)

### @bastien-landre-alan on `backend/components/occupational_health/internal/controllers/admin_dashboard.py:225` (2026-04-22)
> here we are taking an account_if, the fr one is taking a company_id (fr scopped) 

[link](https://github.com/alan-eu/alan-apps/pull/88526#discussion_r3123680429)

### @bastien-landre-alan — issue comment (2026-04-16)
> This change is part of the following stack:
> 
> - #88137
>     - #88246
>         - #88526 ◀
>             - #88610
>                 - #88800
>                     - #88900
> 
> <sub>Change managed by [git-spice](https://abhinav.github.io/git-spice/).</sub>
> <!-- gs:navigation comment -->
> 

[link](https://github.com/alan-eu/alan-apps/pull/88526#issuecomment-4259158130)

### @MickaelBergem — issue comment (2026-04-16)
> Oof 😅 
> <img width="167" height="71" alt="image" src="https://github.com/user-attachments/assets/d3b77781-4f36-4f4e-a1b2-37234b4ecc1c" />
> 

[link](https://github.com/alan-eu/alan-apps/pull/88526#issuecomment-4261760065)

### @bastien-landre-alan — issue comment (2026-04-17)
> > The PR is quite long, I'll continue reviewing tomorrow.
> 
> @MickaelBergem you could review the PR commit by commit it would be simpler, as I change multiple time the same code.
> Don't hesitate if you need a sync review.

[link](https://github.com/alan-eu/alan-apps/pull/88526#issuecomment-4265943467)

---

## PR #88610 — feat(occupational_health): dry-run + undo toast for pending affiliation decisions

_2026-04-22 • https://github.com/alan-eu/alan-apps/pull/88610_

### @bastien-landre-alan on `frontend/apps/fr-app/js/app/dashboard/occupationalHealth/queries/useResolvePendingAffiliationMutation.ts:133` (2026-04-22)
> Thanks I will remove the unload on unmount I found another fix

[link](https://github.com/alan-eu/alan-apps/pull/88610#discussion_r3124622553)

### @bastien-landre-alan — issue comment (2026-04-16)
> This change is part of the following stack:
> 
> - #88137
>     - #88246
>         - #88526
>             - #88610 ◀
>                 - #88800
>                     - #88900
> 
> <sub>Change managed by [git-spice](https://abhinav.github.io/git-spice/).</sub>
> <!-- gs:navigation comment -->
> 

[link](https://github.com/alan-eu/alan-apps/pull/88610#issuecomment-4260975352)

### @MickaelBergem — issue comment (2026-04-16)
> > * If the user closes the browser during the 5s undo window, the action is lost (safe default — nothing was committed)
> 
> This is not OK: we should either block closing the window, or commit first and implement a cancel button, or just drop the idea of allowing to cancel an action.

[link](https://github.com/alan-eu/alan-apps/pull/88610#issuecomment-4261757135)

### @bastien-landre-alan — issue comment (2026-04-17)
> > > * If the user closes the browser during the 5s undo window, the action is lost (safe default — nothing was committed)
> > 
> > This is not OK: we should either block closing the window, or commit first and implement a cancel button, or just drop the idea of allowing to cancel an action.
> 
> @MickaelBergem Sorry I didn't think you would review the PR that quickly :D 
> I saw this issue, wanted to comment that I would work on it but moved to a sync.
> 
> I put the PR as draft to work on it 🙏 
> 
> For information: It work if I close the modale, or if we do "back" with the browser as the toast is still displayed. Only when closing completly the browser/tab it doesn't work

[link](https://github.com/alan-eu/alan-apps/pull/88610#issuecomment-4265939324)

### @MickaelBergem — issue comment (2026-04-17)
> > For information: It work if I close the modale, or if we do "back" with the browser as the toast is still displayed. Only when closing completly the browser/tab it doesn't work
> 
> If there is a way for it to fail silently, it will eventually fail 😇 

[link](https://github.com/alan-eu/alan-apps/pull/88610#issuecomment-4266216818)

### @bastien-landre-alan — issue comment (2026-04-17)
> @MickaelBergem I found a fix to handle component unmount/refresh/closing browser.
> 
> I tested it multiple time and it works well.
> 
> I prefer doing this instead of 1 call with a real commit and another call to cancel to avoid side effect (slack message, update nic on employment that could fire event, ...)

[link](https://github.com/alan-eu/alan-apps/pull/88610#issuecomment-4266603799)

---

## PR #88974 — [OHSET-483] Expose professional_category on OH admin dashboard

_2026-04-22 • https://github.com/alan-eu/alan-apps/pull/88974_

### @bastien-landre-alan — review summary (APPROVED, 2026-04-22)
> LGTM, some comment about naming 

[link](https://github.com/alan-eu/alan-apps/pull/88974#pullrequestreview-4153372776)

### @bastien-landre-alan on `backend/components/occupational_health/internal/business_logic/queries/employments.py:203` (2026-04-22)
> nit: pick is kind of weird as I don't understand, what we are doing, why not select (as you select 1 employment)

[link](https://github.com/alan-eu/alan-apps/pull/88974#discussion_r3122763917)

### @bastien-landre-alan on `backend/components/occupational_health/internal/business_logic/queries/employments.py:206` (2026-04-22)
> why do you need a new model _PickedEmployment ?
> would it not be easier to have a map of picked_employment_by_key ?
> 

[link](https://github.com/alan-eu/alan-apps/pull/88974#discussion_r3122770097)

### @bastien-landre-alan on `backend/components/occupational_health/internal/business_logic/queries/employments.py:221` (2026-04-22)
> nit: I prefer named that explain what we have. here it would be effective_date_per_employment_id

[link](https://github.com/alan-eu/alan-apps/pull/88974#discussion_r3122794176)

### @bastien-landre-alan on `backend/components/occupational_health/internal/business_logic/queries/employments.py:231` (2026-04-22)
> same for naming, raw is generic, maybe raw_professional_category

[link](https://github.com/alan-eu/alan-apps/pull/88974#discussion_r3122799960)

### @bastien-landre-alan on `backend/components/occupational_health/internal/business_logic/queries/employments.py:157` (2026-04-22)
> I don't understand this filter could you add a comment 
> it's to have the active employment (no end date) ? in this case we take the first ?

[link](https://github.com/alan-eu/alan-apps/pull/88974#discussion_r3122849279)

### @bastien-landre-alan on `backend/components/occupational_health/internal/business_logic/queries/employments.py:157` (2026-04-22)
> other question but don't we have this logic elswhere ? (find current_employment ?)

[link](https://github.com/alan-eu/alan-apps/pull/88974#discussion_r3122855698)

---

## PR #88975 — [OHSET-483] Add cadres/non-cadres filter on OH admin dashboard

_2026-04-22 • https://github.com/alan-eu/alan-apps/pull/88975_

### @bastien-landre-alan — review summary (APPROVED, 2026-04-22)
> LGTM as it's working.
> But It feel a bit complex for simple filter. Maybe we don't have to create everything generic, or maybe we should extract the filter component directly
> (approving as it's working and don't want to bloc you)

[link](https://github.com/alan-eu/alan-apps/pull/88975#pullrequestreview-4153519102)

### @bastien-landre-alan on `frontend/apps/fr-app/js/app/dashboard/occupationalHealth/helpers/useUrlSyncedArrayState.ts:5` (2026-04-22)
> nit, but maybe we should move useUrlSyncedState also (maybe in the same file) to be sure to find it ?
> not related to this PR 

[link](https://github.com/alan-eu/alan-apps/pull/88975#discussion_r3122890931)

### @bastien-landre-alan on `frontend/apps/fr-app/js/app/dashboard/occupationalHealth/employees/CurrentEmployeesTab.tsx:91` (2026-04-22)
> I don't understand why we are using useProfessionalCategoryChangeHandler here. The filter should be handle in the component

[link](https://github.com/alan-eu/alan-apps/pull/88975#discussion_r3122917448)

### @bastien-landre-alan on `frontend/apps/fr-app/js/app/dashboard/occupationalHealth/visits/useFilterByProfessionalCategory.ts:52` (2026-04-22)
> to be honest I don't understand this.
> It seem quite complex for a simple filter. 
> maybe it should not be in visits folder if it's generic for employees also.
> maybe add comments to explain the usage

[link](https://github.com/alan-eu/alan-apps/pull/88975#discussion_r3122940368)

---

## PR #89108 — Add observation status to admin dashboard backend

_2026-04-22 • https://github.com/alan-eu/alan-apps/pull/89108_

### @MickaelBergem — review summary (APPROVED, 2026-04-21)
> LGTM with minor comments + I would move most of the filtering to the query itself (you'll load less data)

[link](https://github.com/alan-eu/alan-apps/pull/89108#pullrequestreview-4149680171)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/visits/observation.py:9` (2026-04-21)
> This is missing a comment to explain what it represents

[link](https://github.com/alan-eu/alan-apps/pull/89108#discussion_r3119275750)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/visits/observation.py:13` (2026-04-21)
> If it's "to compute an observation" it shouldn't be named "observation data", right?
> 
> Also why would it necessarily be a "predictable" and not work for other types of visits?
> 
> ```suggestion
> class VisitData:
>     """Raw data from a predictable visit needed to compute observation status."""
> ```
> 
> Also if we only care about upcoming visits (date_planned >= today) can we just filter them out when querying the data source?

[link](https://github.com/alan-eu/alan-apps/pull/89108#discussion_r3119281982)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/visits/observation.py:18` (2026-04-21)
> Why do you need to return cancelled visits? Can we just exclude them from the beginning?

[link](https://github.com/alan-eu/alan-apps/pull/89108#discussion_r3119283802)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/visits/observation.py:23` (2026-04-21)
> Today will always be "today" and it will be confusing to pass another date - let's instead use `on_date`
> 
> ```suggestion
>     on_date: date,
> ```

[link](https://github.com/alan-eu/alan-apps/pull/89108#discussion_r3119289756)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/visits/observation.py:30` (2026-04-21)
> Any reason to not exclude these cases when doing the query directly?

[link](https://github.com/alan-eu/alan-apps/pull/89108#discussion_r3119296138)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/visits/observation.py:36` (2026-04-21)
> "active booking" is not terminology we've used so far and it looks like a new concept. `has_upcoming_visit` is clearer.

[link](https://github.com/alan-eu/alan-apps/pull/89108#discussion_r3119299401)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/visits/observation.py:40` (2026-04-21)
> Not sure why you need a dedicated function for this?

[link](https://github.com/alan-eu/alan-apps/pull/89108#discussion_r3119301808)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/visits/observation.py:46` (2026-04-21)
> very small nit (please ignore): I find the following to be more readable
> ```suggestion
>     if today >=  date_sent + NO_RESPONSE_THRESHOLD:
>         return ObservationStatus.NO_RESPONSE
> ```

[link](https://github.com/alan-eu/alan-apps/pull/89108#discussion_r3119304834)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/visits/visits.py:204` (2026-04-21)
> no need to inline such imports

[link](https://github.com/alan-eu/alan-apps/pull/89108#discussion_r3119307734)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/visits/visits.py:236` (2026-04-21)
> You should also filter by `account_id` no? We don't want to show visits done with another company.

[link](https://github.com/alan-eu/alan-apps/pull/89108#discussion_r3119311440)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/visits/observation.py:23` (2026-04-22)
> Then why pass it as a parameter vs calling `utctoday()` directly in this function?

[link](https://github.com/alan-eu/alan-apps/pull/89108#discussion_r3123591538)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/visits/observation.py:23` (2026-04-22)
> > It's just that we are already doing a today in the parent function so we are re-using it but we could do it here too.
> 
> Do you think the code would be clearer if "fixed it" upstream as well - in a dedicated PR? Either renaming it or just calling `today()` when needed.

[link](https://github.com/alan-eu/alan-apps/pull/89108#discussion_r3124012930)

---

## PR #89123 — add observation column to OH admin dashboard

_2026-04-22 • https://github.com/alan-eu/alan-apps/pull/89123_

### @bastien-landre-alan on `frontend/apps/fr-app/js/app/dashboard/occupationalHealth/employees/CurrentEmployeesTab.tsx:465` (2026-04-22)
> maybe keep the comment as you will remove the showObservationColumn later on

[link](https://github.com/alan-eu/alan-apps/pull/89123#discussion_r3122961059)

---

## PR #89209 — add no-response banner with mailto CTA on employee dashboard

_2026-04-24 • https://github.com/alan-eu/alan-apps/pull/89209_

### @bastien-landre-alan — review summary (APPROVED, 2026-04-22)
> lgtm except question on lateCount not displayed

[link](https://github.com/alan-eu/alan-apps/pull/89209#pullrequestreview-4153611838)

### @bastien-landre-alan on `frontend/apps/fr-app/js/app/dashboard/occupationalHealth/employees/CurrentEmployeesTab.tsx:396` (2026-04-22)
> so we will not display this in case of !showObservationColumn ?

[link](https://github.com/alan-eu/alan-apps/pull/89209#discussion_r3122980580)

### @bastien-landre-alan on `frontend/apps/fr-app/js/app/dashboard/occupationalHealth/employees/NoResponseBanner.tsx:248` (2026-04-23)
> I would not call is siSelected as it's the list of profiloId  and you don't understand it in the name

[link](https://github.com/alan-eu/alan-apps/pull/89209#discussion_r3132033997)

---

## PR #89270 — [Occ Health] For some account and company, we have a specific folder_id

_2026-04-23 • https://github.com/alan-eu/alan-apps/pull/89270_

### @MickaelBergem on `backend/components/occupational_health/internal/helpers/post_visit_google_drive_folder.py:8` (2026-04-23)
> Oh my - have you flagged this as input for the granularity framing? I think it falls completely in the same bucket.
> 
> Let's continue on Slack (please open a thread), I'm curious what you think the right granularity should be.

[link](https://github.com/alan-eu/alan-apps/pull/89270#discussion_r3129378564)

### @MickaelBergem on `backend/components/occupational_health/internal/helpers/post_visit_google_drive_folder.py:56` (2026-04-23)
> This triggers one new SQL request every time `get_post_visit_google_drive_folder_id` is called (I guess it will be called for all profiles in an account?) unless the relationship was preloaded.
> 
> Is this OK?

[link](https://github.com/alan-eu/alan-apps/pull/89270#discussion_r3129388254)

### @MickaelBergem on `backend/components/occupational_health/internal/helpers/post_visit_google_drive_folder.py:59` (2026-04-23)
> You are assuming the list you get is returned ordered. How can you be sure that this is correct today and will remain correct in the future?

[link](https://github.com/alan-eu/alan-apps/pull/89270#discussion_r3129393638)

### @MickaelBergem on `backend/components/occupational_health/internal/helpers/post_visit_google_drive_folder.py:67` (2026-04-23)
> There is this warning in the function body: `NOTE: if there are multiple current employments, we discard the others`. What is the impact of this on your feature?

[link](https://github.com/alan-eu/alan-apps/pull/89270#discussion_r3129409595)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/employments.py:303` (2026-04-23)
> Since you wrote a docstring, let's add this important caveat in there. I also wonder if we shouldn't just always return an array and let consumers decide what to do when they get a list... what do you think?

[link](https://github.com/alan-eu/alan-apps/pull/89270#discussion_r3129421151)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/employments.py:265` (2026-04-23)
> @Universemul @lmbonnefont I'm curious what's your intent behind tracing this function? Do you expect it to be a performance issue one day? I don't see any SQL query nor complex logic so I'm curious.

[link](https://github.com/alan-eu/alan-apps/pull/89270#discussion_r3129427083)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/employments.py:281` (2026-04-23)
> The function is named `pick_current_or_last_employment` - I think the "current" makes it clear we take "today" as the reference. The naming convention at Alan if we want to customize the date would be `get_current_or_last_employment_on(on_date: date, ...)`.

[link](https://github.com/alan-eu/alan-apps/pull/89270#discussion_r3129450692)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/employments.py:281` (2026-04-23)
> > Currently >= will only select employment that start in the future.
> Isn't it a bug?
> Should we not have the opposite? Does that really make sense to filter on the start date (they should all be in the past no?)
> 
> Oooh you are completely right... can you do a dedicated PR and (have Claude) scan all the users of this function to identify what was broken until now and should now start working? It'll help monitor these aspects and react if they suddenly start misbehaving.

[link](https://github.com/alan-eu/alan-apps/pull/89270#discussion_r3130524000)

### @MickaelBergem on `backend/components/occupational_health/internal/helpers/post_visit_google_drive_folder.py:59` (2026-04-23)
> Yes but you're assuming it won't change in the future. It's fine (less probability of changing) but a bit more fragile / less robust in the long-term than explicit SQLAlchemy requests ;)

[link](https://github.com/alan-eu/alan-apps/pull/89270#discussion_r3131658299)

### @MickaelBergem on `backend/components/occupational_health/internal/business_logic/queries/employments.py:303` (2026-04-23)
> @Universemul  Hmm you [did](https://github.com/alan-eu/alan-apps/pull/89270/changes/aed4c39faabb0fd39b62c4ee5acd1ef331513651) write the docstring no? 😅 

[link](https://github.com/alan-eu/alan-apps/pull/89270#discussion_r3131664053)

---

## PR #89494 — chore(oh): remove redundant employee count next to Collaborateurs

_2026-04-23 • https://github.com/alan-eu/alan-apps/pull/89494_

### @bastien-landre-alan — review summary (APPROVED, 2026-04-23)
> meta. for this type of change I like adding "before/after" screenshot to understand quickly the changes

[link](https://github.com/alan-eu/alan-apps/pull/89494#pullrequestreview-4161443857)

---

## PR #89705 — feat(fr): contextual employee side modal header per observation state (OHSET-520)

_2026-04-24 • https://github.com/alan-eu/alan-apps/pull/89705_

### @bastien-landre-alan on `frontend/apps/fr-app/js/app/dashboard/occupationalHealth/employees/ObservationModalHeader.tsx:18` (2026-04-24)
> best if we have english comment :) 

[link](https://github.com/alan-eu/alan-apps/pull/89705#discussion_r3137988337)

### @bastien-landre-alan on `frontend/apps/fr-app/js/app/dashboard/occupationalHealth/employees/ObservationModalHeader.tsx:44` (2026-04-24)
> can't we do observation === "no_response" ?

[link](https://github.com/alan-eu/alan-apps/pull/89705#discussion_r3137995952)

---

## PR #89929 — enh(occh): Add privacy setting on affiliation decision table

_2026-04-27 • https://github.com/alan-eu/alan-apps/pull/89929_

### @MickaelBergem on `backend/components/occupational_health/internal/models/occupational_health_affiliation_decision.py:77` (2026-04-27)
> This will make it super hard to work with prod data on Kay 😢 

[link](https://github.com/alan-eu/alan-apps/pull/89929#discussion_r3145901964)

### @bastien-landre-alan on `backend/components/occupational_health/internal/models/occupational_health_affiliation_decision.py:77` (2026-04-27)
> Yes I agree but I didn't find a working solution to handle jsonb
> As you did the same for affiliator log I think there is none

[link](https://github.com/alan-eu/alan-apps/pull/89929#discussion_r3145915475)

---

## PR #90081 — feat(fr-occh): allow HR admins to edit member professional_email (OHSET-525)

_2026-04-28 • https://github.com/alan-eu/alan-apps/pull/90081_

### @bastien-landre-alan on `backend/components/occupational_health/internal/controllers/admin_dashboard.py:492` (2026-04-28)
> Why do you need this ?

[link](https://github.com/alan-eu/alan-apps/pull/90081#discussion_r3153967171)

### @bastien-landre-alan on `frontend/apps/fr-app/js/app/dashboard/occupationalHealth/employees/CurrentEmployeesTab.tsx:543` (2026-04-28)
> This update is to rerender is the email change, do we need it as we already have the new value ?

[link](https://github.com/alan-eu/alan-apps/pull/90081#discussion_r3153981289)

### @bastien-landre-alan on `frontend/apps/fr-app/js/app/dashboard/occupationalHealth/queries/useUpdateProfessionalEmailMutation.ts:27` (2026-04-28)
> This is for the employee list that we see on background ?

[link](https://github.com/alan-eu/alan-apps/pull/90081#discussion_r3153993970)

### @MickaelBergem — issue comment (2026-04-28)
> I believe "E-mail professionnel" will be confusing for companies who do not provide a pro email to their employee. For instance, a Vitalliance or Big Mamma HR will have to input `@hotmail.fr` addresses in this field.
> 
> Can we simplify to "e-mail" to avoid the confusion? I agree that admins might get confused if they remember they had provided a personal email in the initial GSheet but since we currently don't collect nor allow to edit the "perso" email it might be simpler.
> 
> cc @aizeadesign 

[link](https://github.com/alan-eu/alan-apps/pull/90081#issuecomment-4335177033)

---

