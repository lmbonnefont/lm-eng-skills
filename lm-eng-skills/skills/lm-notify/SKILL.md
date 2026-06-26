---
name: lm-notify
model: haiku
effort: low
description: Send a macOS desktop notification with sound. Use whenever the user says "/notify", "notify me", "send me a notification", "alert me", or when a long-running task completes and the user previously asked to be notified. Also use proactively at the end of babysitting tasks (CI monitoring, deploy watching) to alert the user.
---

# macOS Notification

Send a native macOS notification that appears in the top-right notification center with a sound.

## Usage

The user provides a message as arguments. Run this command:

```bash
osascript << 'APPLESCRIPT'
display notification "<message>" with title "Claude Code" sound name "Glass"
APPLESCRIPT
```

Replace `<message>` with the user's argument text. If no message is provided, use "Task complete" as default.

## Examples

- `/notify CI is green` → notification with "CI is green"
- `/notify Deploy finished` → notification with "Deploy finished"
- `/notify` → notification with "Task complete"
