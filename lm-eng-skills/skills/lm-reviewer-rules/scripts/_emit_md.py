#!/usr/bin/env python3
"""Emit markdown for a stream of JSON comment objects from gh api --jq.

Usage: cat stream | _emit_md.py <kind>
where kind is 'review' | 'inline' | 'issue'.
"""
import json
import sys


def main() -> None:
    kind = sys.argv[1] if len(sys.argv) > 1 else "review"
    for line in sys.stdin:
        line = line.strip()
        if not line:
            continue
        try:
            d = json.loads(line)
        except json.JSONDecodeError:
            continue
        body = d.get("body", "").replace("\n", "\n> ")
        login = d.get("login", "?")
        at = d.get("at", "")[:10]
        url = d.get("url", "")
        if kind == "review":
            state = d.get("state", "")
            header = f"### @{login} — review summary ({state}, {at})"
        elif kind == "inline":
            path = d.get("path", "")
            line_no = d.get("line")
            loc = f"{path}:{line_no}" if line_no else path
            header = f"### @{login} on `{loc}` ({at})"
        else:  # issue
            header = f"### @{login} — issue comment ({at})"
        print(header)
        print(f"> {body}")
        print()
        print(f"[link]({url})")
        print()


if __name__ == "__main__":
    main()
