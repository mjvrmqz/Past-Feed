#!/bin/bash

cd "$(dirname "$0")"

if [ -f .env ]; then
    set -o allexport
    source .env
    set +o allexport
fi

git remote set-url origin https://github.com/mjvrmqz/Past-Feed.git
git stash --include-untracked
git fetch origin
git rebase origin/main
git stash pop

python3 past_feed_to_ics.py

git add "Past Feed.ics"
git diff --cached --quiet && echo "No changes to ICS, skipping commit." && exit 0
git commit -m "Update ICS feed $(date -u +"%Y%m%dT%H%M%SZ")"
git push origin main

echo ""
echo "=== Updating Personal Feed ==="
bash "/Users/mjvrmqz/Personal/Scripts/Notion/Jarwix/Calendar Feeds/Personal Feed/update_ics.sh"

echo ""
echo "=== Updating Work Feed ==="
bash "/Users/mjvrmqz/Personal/Scripts/Notion/Jarwix/Calendar Feeds/Work Feed/update_ics.sh"
