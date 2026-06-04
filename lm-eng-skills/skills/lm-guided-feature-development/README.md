# Guided Feature Development Skill (`/guided-feature-development`)

Structured and guided workflow to develop a complete feature, from product specification to production. The AI asks questions, you validate and decide, together we build.

## Overview

The `/guided-feature-development` skill guides 6 parts across **2 separate sessions** to preserve the context window:

| Part | Session | Objective |
|------|---------|-----------|
| **1** | 1 | Product Specification — Clarify requirements, confirm understanding |
| **2** | 1 | Technical Plan — Propose architecture, list dependencies |
| **3** | 1 | Tracking (opt.) — Define success metrics |
| **4** | 1 | Scope & Split — Estimate size, decide if multi-ticket split needed |
| **5** | 1 | Create Sub-Tickets — Create Linear tickets if necessary |
| **6** | 2 | Implementation — Code, test, review, create PR |

---

## Key Workflow

### Session 1: Research (Parts 1–5)

```bash
/guided-feature-development EP-1234  # or /guided-feature-development <linear_ticket_url>
```

The skill asks clarifying questions, you validate each part, and produces a comprehensive plan.

**Result**: `.claude/plans/feature-plan-EP-1234.md`

### Session 2: Implementation (Part 6)

Start a new conversation:
```bash
/guided-feature-development --from-plan .claude/plans/feature-plan-EP-1234.md
```

Implement the feature based on the plan.

---

## Key Features

### Checkpoints & Resume

If Session 1 is interrupted, checkpoints save progress after each completed part. Resume without redoing work.

**When checkpoint is written**:
- After Part 1 (product requirements confirmed)
- After Part 2 (architecture approved)
- After Part 3 (tracking defined or skipped)
- After Part 4 (split decision made)
- After Part 5 (sub-tickets created)

On resume: the skill reads the checkpoint and proposes to continue from the next part.

### Smart Questions

All questions use multiple-choice options, not free-form text. Fast, bounded, unambiguous decisions.

```
Q: Does this feature touch the database?
Options: [Yes, new tables] [Yes, migrations] [No, logic only]
```

### Control the Pace

After each part, the skill pauses:
- "Yes, proceed" → continue
- "Skip this part" → move to next
- "Stop here" → pause

You're always in control.

### Efficient Context Use

- **Figma designs** are fetched once and referenced throughout
- **Codebase exploration** happens once in Part 2, results included in the plan
- **Code review** happens via subagent — you get only findings, not raw diffs
- **Search**: uses ripgrep (`rg`) when available for faster searches, falls back to `grep -r` otherwise
- No re-work between sessions

---

## Typical Flow

### Session 1

```bash
/guided-feature-development EP-2854
```

1. **Part 1**: Fetch ticket, clarify ambiguities
   - "Is it a form or a list?" → You choose
   - "Pagination or infinite scroll?" → You choose
   - AI synthesizes understanding → You confirm

2. **Part 2**: Explore codebase, propose architecture
   - Identify reusable components
   - List dependencies and breaking changes
   - You approve the proposal

3. **Parts 3–5**: Define metrics, estimate scope, create sub-tickets in Linear
   - Checkpoint updated at each step
   - Final plan written: `.claude/plans/feature-plan-EP-2854.md`

### Session 2

```bash
/guided-feature-development --from-plan .claude/plans/feature-plan-EP-2854.md
```

**For each ticket**:
1. Define test strategy
2. Write code + tests
3. Code review (subagent finds issues)
4. Create PR
5. Summary of what was built

---

## When to Use

Use `/guided-feature-development` for:
- New product features
- Multi-layer features (frontend + backend)
- Tickets with clear acceptance criteria

Don't use for:
- Urgent hotfixes
- Pure refactoring
- Documentation-only changes
- Simple bug fixes

---

## Key Principles

- **Ask, don't guess** — Questions guide the process
- **Bounded choices** — Fast decisions with clear options
- **You control the pace** — Gates after each part
- **Small PRs** — ~500 LOC max
- **Tests first** — Strategy before coding
- **No re-work** — Plan includes everything for implementation

---

**Ready? Launch a feature:**
```bash
/guided-feature-development <linear-ticket-url-or-id>
```
