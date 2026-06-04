#!/usr/bin/env bash
# Fetch PR review comments from Bastien Landre and Mickaël Berguem on alan-eu/alan-apps
# over a rolling 4-month window. Outputs a single markdown dump.
#
# Idempotent: re-running overwrites references/raw_comments.md.
# Requires: gh CLI authenticated, python3 (for portable date math).

set -euo pipefail

REPO="alan-eu/alan-apps"
AUTHORS=("MickaelBergem" "bastien-landre-alan")

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
OUT="$SKILL_DIR/references/raw_comments.md"

CUTOFF=$(python3 -c "from datetime import date, timedelta; print((date.today() - timedelta(days=122)).isoformat())")
TODAY=$(python3 -c "from datetime import date; print(date.today().isoformat())")

echo "Cutoff: $CUTOFF (rolling 4 months)" >&2
echo "Repo: $REPO" >&2

# Step 1: collect PR numbers where any of the authors reviewed since cutoff.
PR_NUMBERS=$(mktemp)
trap 'rm -f "$PR_NUMBERS"' EXIT

for AUTHOR in "${AUTHORS[@]}"; do
  echo "Searching PRs reviewed by @$AUTHOR..." >&2
  gh search prs \
    --repo "$REPO" \
    --reviewed-by "$AUTHOR" \
    --updated ">=$CUTOFF" \
    --limit 1000 \
    --json number \
    --jq '.[].number' >> "$PR_NUMBERS"
done

# Dedup
sort -u -n "$PR_NUMBERS" -o "$PR_NUMBERS"
PR_COUNT=$(wc -l < "$PR_NUMBERS" | tr -d ' ')
echo "Found $PR_COUNT unique PRs to inspect" >&2

# Step 2: write header
{
  echo "# Raw review comments"
  echo ""
  echo "- Generated: $TODAY"
  echo "- Cutoff: $CUTOFF (rolling 4 months)"
  echo "- Repo: $REPO"
  echo "- Authors: @MickaelBergem, @bastien-landre-alan"
  echo "- PRs inspected: $PR_COUNT"
  echo ""
  echo "---"
  echo ""
} > "$OUT"

# Step 3: for each PR, fetch reviews + inline comments + issue comments, filter by author and date.
AUTHOR_FILTER='"MickaelBergem","bastien-landre-alan"'

while read -r PR; do
  [ -z "$PR" ] && continue

  # PR title + merged_at for the heading (one call per PR)
  PR_META=$(gh api "repos/$REPO/pulls/$PR" --jq '{title, merged_at, html_url, updated_at}' 2>/dev/null || echo '{}')
  TITLE=$(echo "$PR_META" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('title','') or '')")
  MERGED=$(echo "$PR_META" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('merged_at','') or d.get('updated_at','') or '')")
  PR_URL=$(echo "$PR_META" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('html_url','') or '')")

  # Buffer per-PR content; only emit if at least one comment matched.
  BUF=$(mktemp)

  EMIT="$SCRIPT_DIR/_emit_md.py"

  # Review bodies (top-level review summaries)
  gh api "repos/$REPO/pulls/$PR/reviews" --paginate \
    --jq "[.[] | select(.user.login as \$u | [$AUTHOR_FILTER] | index(\$u)) | select(.submitted_at >= \"${CUTOFF}T00:00:00Z\") | select(.body != null and .body != \"\") | {login:.user.login, at:.submitted_at, body:.body, url:.html_url, state:.state}] | .[]" 2>/dev/null \
    | python3 "$EMIT" review >> "$BUF" || true

  # Inline review comments
  gh api "repos/$REPO/pulls/$PR/comments" --paginate \
    --jq "[.[] | select(.user.login as \$u | [$AUTHOR_FILTER] | index(\$u)) | select(.created_at >= \"${CUTOFF}T00:00:00Z\") | {login:.user.login, at:.created_at, body:.body, url:.html_url, path:.path, line:(.line // .original_line)}] | .[]" 2>/dev/null \
    | python3 "$EMIT" inline >> "$BUF" || true

  # Issue comments on the PR thread
  gh api "repos/$REPO/issues/$PR/comments" --paginate \
    --jq "[.[] | select(.user.login as \$u | [$AUTHOR_FILTER] | index(\$u)) | select(.created_at >= \"${CUTOFF}T00:00:00Z\") | {login:.user.login, at:.created_at, body:.body, url:.html_url}] | .[]" 2>/dev/null \
    | python3 "$EMIT" issue >> "$BUF" || true

  if [ -s "$BUF" ]; then
    {
      echo "## PR #$PR — $TITLE"
      echo ""
      echo "_${MERGED:0:10} • ${PR_URL}_"
      echo ""
      cat "$BUF"
      echo "---"
      echo ""
    } >> "$OUT"
  fi

  rm -f "$BUF"
done < "$PR_NUMBERS"

WORDS=$(wc -w < "$OUT" | tr -d ' ')
echo "Wrote $OUT ($WORDS words)" >&2
