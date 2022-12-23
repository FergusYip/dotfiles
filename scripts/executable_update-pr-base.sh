#!/bin/sh

GREEN='\033[0;32m'
NC='\033[0m' # No Color

revset="$1"
if [ -z "$revset" ]; then
    revset="stack()"
fi

branches=`git query -b "$revset"`

for branch in $branches; do
    # Skip branches that don't have a pull request
    gh pr view $branch &> /dev/null || continue

    old_base_branch=`gh pr view $branch --json 'baseRefName' --jq '.baseRefName'`

    base_branch=`git query -b "ancestors($branch) - $branch" | tail -1`

    if [ $old_base_branch != $base_branch ]; then
        gh pr edit $branch -B $base_branch >/dev/null
        echo Updated base of ${GREEN}$branch${NC} to ${GREEN}$base_branch${NC}
    fi
done

