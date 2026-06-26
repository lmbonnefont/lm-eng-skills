# lm-eng-skills

Engineering workflow skills for **alan-apps**, packaged as a Claude Code plugin — code review, feature development, debugging, and project comms. Built on the [Agent Skills](https://agentskills.io) standard.

> Sibling to [`alan-eu/alan-skills`](https://github.com/alan-eu/alan-skills) (recruiting / people / non-coding workflows). This repo focuses on **engineering**.

## Setup (2 commands)

In Claude Code, from any project (these install globally — available everywhere):

```
/plugin marketplace add lmbonnefont/lm-eng-skills
/plugin install lm-eng-skills@lm-eng-skills
```

> The install reference is `<plugin>@<marketplace>`, both named `lm-eng-skills`. If your Claude Code version derives the marketplace name differently, run `/plugin marketplace list` to see the exact reference, then `/plugin install lm-eng-skills@<that-name>`.

That's it — all 24 skills are now available. Trigger one by typing `/lm-<name>` (e.g. `/lm-review-all`) or just describe your task and Claude picks the right skill.

### The Zero Trust Didactic output style (applied automatically)

This plugin also ships an output style that makes Claude back **every** factual claim about the codebase with a clickable `file:line` reference. It is **applied automatically** while the plugin is enabled (`force-for-plugin: true`) — no setup needed.

To opt out without uninstalling, switch styles with `/output-style default` (or pick another), or disable the plugin with `/plugin disable lm-eng-skills@lm-eng-skills`.

### Optional: faster code navigation (codegraph)

Several skills explore the codebase faster when [codegraph](https://github.com/colbymchenry/codegraph) — a local code-intelligence index — is installed. It is **optional**: the skills detect it and fall back to `grep` if it's absent.

```
curl -fsSL https://raw.githubusercontent.com/colbymchenry/codegraph/main/install.sh | sh
```

## Update

The marketplace cache is a managed git clone. Pull the latest skills with:

```
/plugin marketplace update lm-eng-skills
```

## Uninstall (clean — restores your `~/.claude` exactly)

```
/plugin uninstall lm-eng-skills@lm-eng-skills
/plugin marketplace remove lm-eng-skills
```

This purges the plugin from the cache and forgets the marketplace. Nothing is left in `~/.claude/skills/` and no symlinks are created — your `~/.claude` returns to its prior state.

## The 24 skills

| Skill | What it does |
|-------|--------------|
| `lm-babysit-pr` | Monitor a PR's CI and auto-fix failures until green |
| `lm-clone-marmotte` | Extract a Marmot (admin) feature's surface implementation as a replicable blueprint |
| `lm-create-woodchuck-ticket` | Create / enrich newcomer-ready Woodchuck Linear tickets |
| `lm-debug-5whys` | Debug bugs via 5 Whys root-cause analysis, then rank fixes by risk/impact |
| `lm-deep-context` | Gather cross-tool product context (Linear, Slack, Notion, Figma, Sentry, Amplitude, git, GitHub) before building |
| `lm-draft-github-discussion` | Draft a GitHub Discussion on alan-eu/Topics in LM's voice (Problem-Solving Method) |
| `lm-flow-walkthrough` | Trace end-to-end code flows with annotated call chains, every claim proven by `file:line` |
| `lm-grill-me` | Interview the user relentlessly to stress-test a plan or design |
| `lm-guided-feature-development` | Guided 6-part feature workflow from Linear ticket to production |
| `lm-hardcore-review` | Thermonuclear structural-quality review (spaghetti, code judo) |
| `lm-impact-read` | Measure a shipped OH announcement's W+4 usage impact via Amplitude (instrument + read modes, Notion tracker) |
| `lm-local-compliance-review` | Review changes for local conventions, ruler rules, production-readiness |
| `lm-merge-conflict` | Merge/rebase branches and resolve conflicts interactively |
| `lm-notify` | Send a macOS desktop notification with sound |
| `lm-oh-amplitude-sync` | Sync Occupational Health analytics events with the Amplitude "Prévenir" dashboard |
| `lm-prototype` | Build a throwaway prototype (terminal app or toggleable UI variations) to flesh out a design |
| `lm-reuse-discovery` | Hunt existing functions/hooks/components/types to avoid duplicating what already exists |
| `lm-review-all` | Run all reviews in parallel (/review + compliance + UX + reviewer-rules + hardcore) into one P0–P3 report |
| `lm-reviewer-rules` | Review against rules extracted from Bastien Landre & Mickaël Berguem's PR reviews |
| `lm-skill-retro` | Five Whys post-mortem on a skill that misfired, then patch it |
| `lm-teach` | Teach you a new skill or concept across sessions, using the current dir as a stateful learning workspace |
| `lm-ux-delight` | Recommend UX micro-improvements (fewer clicks, smarter defaults) during feature dev |
| `lm-v1-options` | Scope a feature's V1/V0 — separate the JOB from the MECHANISM, explore the codebase via codegraph, propose 5 versions (bold→conservative) with tradeoffs |
| `lm-write-readable` | Write-time readability — apply clean-code rules while coding + one self-critique pass (not a reviewer) |

## How it's packaged

Single bundled plugin (one install/uninstall for everything):

```
lm-eng-skills/                       # marketplace repo
├── .claude-plugin/
│   └── marketplace.json             # declares the marketplace + the plugin
└── lm-eng-skills/                   # the plugin
    ├── .claude-plugin/
    │   └── plugin.json
    ├── skills/                      # 24 SKILL.md directories
    └── output-styles/
        └── zero-trust-didactic.md   # auto-applied (force-for-plugin: true)
```

Why a plugin and not symlinks into `~/.claude/skills/`? Clean, native uninstall (no manifest of symlinks to track), no collision with personal skills of the same name (skills are namespaced under the plugin), and versioned updates via `/plugin marketplace update`.
