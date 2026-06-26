---
name: lm-create-woodchuck-ticket
model: sonnet
description: Create or enrich a Woodchuck-ready Linear ticket targeting Alan newcomers with zero codebase knowledge. Supports three modes — **create** (from a product problem description), **enrich** (an existing Linear ticket already labelled Woodchuck), and **convert** (an existing Linear ticket without the label, to be made woodchuck-ready). Woodchuck tickets stay at the product/UX level — no implementation details — and always include the exact interface, audience, success criteria, and click-by-click access steps backed by real code references. Use whenever the user asks to "create a woodchuck ticket", "draft a woodchuck issue", "new woodchuck for [project]", "améliore le woodchuck OHSET-XXX", "enrichis ce ticket woodchuck", "rends ce ticket woodchuck-ready", or pastes a Linear URL alone with a request to make it newcomer-friendly. Triggered by /lm-create-woodchuck-ticket. Different from woodchuck-assess (which audits batches of tickets per team) — this skill works on a single ticket at a time.
---

# Create or Enrich a Woodchuck Ticket

Produce a Linear issue formatted for Alan's woodchuck program — small, well-framed tasks that a newcomer with zero codebase knowledge can pick up autonomously. Works in three modes: build one from scratch, enrich an existing Woodchuck-labelled ticket, or convert a regular ticket into a Woodchuck-ready one.

## Core principle

**Always write the ticket in English** — title, description, success criteria, all sections. Even if the user describes the problem in French or another language, translate to English when drafting. Newcomers come from many countries; English is the lingua franca.

The reader is a newcomer who has just joined Alan. They don't know:
- Which app/admin/screen the problem is on
- Who the impacted audience is (e.g. what's an ANI member, what's a B2C subscriber)
- Where the code lives or how the stack is organized

So **stay at the product/UX level**. Describe the problem the way a PM would describe it to another PM. Don't dive into file paths, function names, table names, or implementation hints. Let the newcomer discover the technical landscape themselves — that's part of the value.

## Workflow

### 0. Check Linear MCP

Call `list_teams` via Linear MCP. If it fails, stop and tell the user:

> **Linear MCP is not connected.** Add the Linear MCP server to your Claude Code config before running this skill. When prompted to select a workspace, choose **"Alan EU"** — NOT "Alan".

### 0.5. Detect the mode (create / enrich / convert)

Before doing anything else, look at what the user gave you. The skill operates in three modes; pick the right one *before* drafting anything.

**Inputs that point to an existing ticket**: a Linear URL (`https://linear.app/alan-eu/issue/...`), an issue identifier (`OHSET-489`, `PAY-1234`), or a phrase like "améliore ce ticket / enrich this woodchuck / make this newcomer-friendly". When you see one of those, fetch the ticket via `get_issue` and inspect its current state.

| Signal | Mode | What it means |
|---|---|---|
| URL/identifier given AND label `Woodchuck` already present | **enrich** | The ticket is already in the woodchuck program but the description is too thin/technical/unclear for a newcomer. Rewrite the description (and optionally the title), keep everything else. |
| URL/identifier given AND label `Woodchuck` absent | **convert** | The ticket exists but isn't yet a woodchuck. Add the `Woodchuck` label and rewrite the description. Confirm the conversion intent with the user before saving. |
| No URL/identifier — just a problem description | **create** | New ticket. Run the full original workflow. |

Why this matters: **enrich** and **convert** must call `save_issue` with the existing `id` to preserve state, project, parent, and other relations — never create a duplicate. **create** uses `save_issue` without an `id`, with an explicit `team` and `state: Backlog`.

Once the mode is decided, state it briefly to the user (one sentence: "Detected mode: **enrich** OHSET-489 (Woodchuck label already present, will rewrite the description and keep state/labels)") and continue.

### 1. Resolve the team and starting state

**Create mode**: team is always OHSET (<https://linear.app/alan-eu/team/OHSET/all>). Never ask which team — never use any other team. Resolve the team ID by calling `list_teams` and picking the one with key `OHSET`. Do NOT assign a project — tickets are created at the team level only. Skip any `list_projects` step.

**Enrich / convert mode**: skip the team resolution. Read the ticket you fetched in Step 0.5 — note its current `id`, `state`, `project`, `parent`, `labels`, `team`, attachments, and existing description (especially screenshots and links you may want to preserve). When you save later, you only pass the fields you want to change (`title`, `description`, and for `convert` also `labels` with `Woodchuck` added) — leave team/state/project/parent untouched so they're preserved.

### 2. Collect the problem

The goal of this step is to have enough information to fill the Woodchuck sections. The source of that information depends on the mode:

- **Create mode**: ask the user to describe the problem if they haven't already.
- **Enrich / convert mode**: extract the problem from the existing description. Often the original ticket already contains the answers (often phrased technically) — your job is to translate, not re-interview. If the existing description is genuinely missing pieces (no audience, no screen named, no expected behaviour), then ask the user.

Either way, you need answers — explicit or extracted — for these slots. If anything is still missing after reading the existing ticket, ask **one batched question** for all gaps (don't drip-feed):

- **The interface**: Which screen/URL/admin/page does the problem appear on? (mandatory)
- **The audience**: Who sees it / who is impacted? (employee, admin, broker, BE/FR/CA member, etc.)
- **The actual problem**: What's wrong, confusing, missing, or broken from the user's perspective?
- **The expected behavior**: What should happen instead?
- **Success criteria**: How will we know the task is done?
- **Origin (optional)**: Slack link, Intercom feedback, screenshot, Marmot screen, etc.

Don't accept vague answers. If the user says "the page is buggy", ask which page and what specifically.

### 2.5. Locate the interface in the codebase before drafting access steps

This step is the difference between a draft that ships and a draft that has to be rewritten three times.

The newcomer reading your ticket is going to follow the `🧭 How to access the interface` section literally. If the URL is wrong, or the modal opens from a different button, or the screen lives in a different app than you assumed, they'll bounce. Worse, you'll discover the mistake only when the user reading your draft corrects you — at which point you've already shown them a wrong version.

**Trigger this step whenever the ticket (or the user's input) names a specific screen, URL, page, modal, banner, admin section, or feature** — anything precise enough that a real route or component file should exist. Examples that demand the probe:

- "the pending affiliations page"
- "the SIRET selection modal"
- "the banner at the top of the OH admin dashboard"
- "the admin Marmot Movements page"
- a URL fragment like `/dashboard/occupational-health/...`

Examples where you can skip the probe (the screen is generic enough that recipes alone are fine):

- "the signup form"
- "the homepage"
- "fix a typo on the success screen after signup" (only if the codebase has one obvious version)

**What to find** (in alan-apps unless context says otherwise):

1. **The route file** — the React Router definition that maps the URL to a component. Find the *exact* URL path, not your guess (route paths use kebab-case, often in French — `revue-affiliations`, not `pending-affiliations`).
2. **The screen component** — the file that renders the page. Note the file path and the line range of the relevant section (e.g. the table cell where the incomplete address is rendered).
3. **The trigger for any modal/banner/CTA mentioned** — which button click opens the modal? On which row condition? What's the banner's CTA wording? File path + line number.
4. **The condition for the screen to be reachable** — banners and modals often only appear when some data condition is met. Note the condition explicitly (e.g. "rows with motif 'SIRET manquant' show 'Corriger', others show 'Ajouter' which doesn't open the modal"). Newcomers waste hours on empty states they can't trigger.

**How to find them**: launch an Explore agent with a tight, context-rich prompt (give it the ticket excerpt, name the screen and the modal, ask for route + component + trigger + conditions, request file:line links and a < 350-word answer). Or grep directly if you know roughly where to look. Don't draft from inference.

**What to do with the findings**: cite them as `file:line` links in the access section, use the *real* URL (not the one you guessed), and write the click-path that matches the real component. Keep technical names (component names, table names) out of the *user-facing description* — those still don't belong in `📍 Context`, `👩‍💻 The task`, or `✅ Success criteria`. They belong only as evidence in the `🧭 How to access` flow (e.g. "click the **Corriger** button" — that's the literal UI label, not a code identifier) and in your internal verification.

If after a reasonable search you can't find the route or the component, **say so to the user** and ask them to confirm the URL/screen before drafting. Don't fabricate.

### 3. Draft the ticket

Build a Linear-ready description using **exactly** these h2 sections, in this order:

```markdown
## 📍 Context

[1-3 short paragraphs describing the problem at the product level.]

[MUST include: the exact screen / URL / interface where the problem occurs, and a short reminder of who the impacted audience is. Write as if the reader has never opened the app.]

[NO file paths, NO function names, NO table names, NO references to backend components or frontend modules. If the original input contains technical hints, strip them.]

## 👩‍💻 The task

[Describe the expected outcome from a user perspective: "When the admin clicks X, they should see Y instead of Z."]

[Optional: hint at which app the work touches at a high level, e.g. "this is on the FR member app" or "this is in the Marmot admin tool" — but no deeper than that.]

## ✅ Success criteria

- [Concrete, observable criterion 1 — phrased as something the newcomer can verify in the UI]
- [Criterion 2]
- [Criterion 3]

## 🪓 Why is it an interesting woodchuck?

[1-3 bullets on what the newcomer will learn / discover by doing this: a part of the stack, a domain concept, a user flow, etc. Keep it inspiring and concrete.]

## 🧭 How to access the interface

[Step-by-step instructions for a newcomer to actually open the screen mentioned above. See the access recipes below — pick the one matching the interface, or write a new one if none fits.]

## Original Feedback

[Only if the problem originates from a Slack message, Intercom ticket, or other feedback. Paste the original verbatim, with link.]
```

#### Access recipes

Always include the `🧭 How to access the interface` section. Use one of these recipes verbatim (in English, adapted to the specific screen) when the interface matches. If the interface is something else, write your own short numbered steps from a fresh-newcomer perspective — assume they have nothing set up and need to know exactly where to click.

**Occupational Health admin dashboard** (any screen under `https://alan.com/app/dashboard/occupational-health` or the "Espace médecine du travail" admin space). Newcomers don't have an HR account themselves, so they impersonate one via Marmot:

```markdown
You don't have your own admin account, so you'll impersonate a real one through Marmot:

1. Open Marmot.
2. Scroll to the very bottom of the page, to the **Occupational Health** section.
3. Click **Admins**.
4. Pick an account.
5. Pick an administrator within that account.
6. On the administrator's user page, click **Login as**.
7. You're redirected to the Alan Health / Prévoyance dashboard. Click the user's name in the top-right corner.
8. Select **Espace médecine du travail**.

You're now in the OH admin dashboard, viewing the data the way an HR sees it.
```

### 4. Title

Propose a short, action-oriented title (≤70 chars). Format: `[area emoji or country flag] short imperative`. Examples:
- `🇫🇷 Fix typo on employee onboarding success screen`
- `🪓 Allow admin to clear the search filter in one click`
- `🇧🇪 Show clearer error when broker uploads invalid SIRET`

### 5. Show the draft and get approval

Present the title + full description. Tailor the question to the mode:

- **Create mode**: "Here's the draft. Shall I create the issue in the **OHSET** team (Backlog) with the `Woodchuck` label? You can also ask me for adjustments first."
- **Enrich mode**: "Here's the rewritten version of [TICKET-ID]. Shall I update the existing ticket (`Woodchuck` label and state preserved)? Adjustments possible before saving."
- **Convert mode**: "Here's the rewrite of [TICKET-ID] in Woodchuck format. Shall I save it and add the `Woodchuck` label (the ticket stays in its current state)? Adjustments possible before saving."

**NEVER save without explicit approval.**

### 6. Save the issue (mode-dependent)

On approval, call `save_issue` via Linear MCP. The arguments depend on the mode:

**Create mode** (new ticket):
- `team`: resolved OHSET team ID
- **No `project`** — tickets are created at the team level only, never inside a project. Do not pass a project parameter.
- `title`: approved title
- `description`: approved markdown
- `labels`: **MUST include `Woodchuck`** (capitalized — only correct spelling). This label is what makes the ticket appear in the canonical view <https://linear.app/alan-eu/view/woodchuck-tasks-13266edfecc5>. Look up the label ID via `list_issue_labels` (workspace-level or OHSET team-level). If it doesn't exist on OHSET, create it at the team level. Do NOT create without this label, and never use the lowercase `woodchuck` variant.
- `state`: **`Backlog`** — always.

**Enrich mode** (existing ticket already labelled Woodchuck):
- `id`: the existing ticket identifier (e.g. `OHSET-489`) — this is what tells Linear MCP to update instead of create. Critical: omit `team`, `project`, `state`, `parent`, `labels` to preserve them. Pass only what you're changing (`title` if changed, `description`).

**Convert mode** (existing ticket without the Woodchuck label):
- `id`: the existing ticket identifier.
- `title`: new title (if you're rewriting it).
- `description`: new markdown.
- `labels`: the existing labels array **plus** `Woodchuck`. You read the existing labels in Step 1 — re-pass all of them so they survive (Linear's `labels` field is replace-all, not append). Don't pass `team`, `project`, `state`, or `parent`.

After saving, verify the issue appears in <https://linear.app/alan-eu/view/woodchuck-tasks-13266edfecc5> and return the issue URL to the user along with a one-line confirmation of what changed (created / enriched / converted) and that it's visible in the woodchuck view.

## Self-check before showing the draft

Before presenting the draft, verify:

1. ✅ The Context section names the **screen / URL / interface** explicitly.
2. ✅ The Context section reminds **who the audience is** in plain language.
3. ✅ Zero technical implementation details (no file paths, function names, component names, table names, API routes) **in the user-facing description sections** (Context, Task, Success criteria, Why interesting).
4. ✅ Success criteria are **observable in the UI**, not in the code.
5. ✅ A newcomer with zero context could read this and understand the problem.
6. ✅ The `🧭 How to access the interface` section is present and gives concrete click-by-click steps a newcomer can follow with no prior setup.
7. ✅ **The access section's URL and click-path are backed by a code reference (route file + component file, with file:line).** If the ticket named a specific screen/modal/banner, you ran the Step 2.5 probe and the URL, button labels, and conditions you wrote come from the code — not from a generic recipe. Recipes are scaffolding for unfamiliar interfaces only; once a real component is identified, the recipe must be replaced or augmented with the real path.
8. ✅ The whole ticket is in English.
9. ✅ For enrich/convert modes: existing screenshots, attachments, and useful links from the original ticket are **preserved** in the new description (don't drop the original visuals just because you're rewriting the prose).

If any check fails, rewrite before showing.

## Common pitfalls to avoid

- **Don't** write "fix the bug in `EmployeeOnboardingScreen.tsx`" — write "fix the bug on the employee onboarding success screen (visible at `/onboarding/success` after signup)".
- **Don't** assume the reader knows what an "ANI member" or "B2B2C broker" is — define it in one short clause.
- **Don't** prescribe the implementation. The newcomer's job includes finding where the code lives.
- **Don't** include "you'll need to update the X table" — that's a technical hint that defeats the discovery value.
- **Don't** make success criteria like "the unit test passes" — make them like "the success message appears in French when the user's locale is fr-FR".
- **Don't** write the access section from a generic recipe when the ticket names a specific screen. Recipes are starting points — once you know the real route file and the real component, the access section must reflect *those*, not the recipe's defaults. Wrong URLs and wrong click-paths are the #1 reason an enriched ticket has to be redone.
- **Don't** pass `team`/`state`/`project`/`parent` to `save_issue` in enrich/convert modes — Linear treats these as overwrites, and you'll silently move the ticket out of its project or reset its workflow state. Pass `id` + only the fields you're explicitly changing.
- **Don't** drop existing screenshots and attachments from the original description in enrich/convert modes. They're often the most valuable signal in the ticket — preserve their markdown image links in your rewritten description.
