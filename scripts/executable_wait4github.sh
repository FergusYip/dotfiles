#!/bin/sh
# Wait for a Pull Request to be processed by GitHub
#
#  $ wait4github.sh <branch-name>
#

time_interval=5

wait4github () {
  branch="$1"

  if [ -z "$branch" ]
  then
    branch=`git rev-parse --abbrev-ref HEAD`
    if [ "$branch" == "HEAD" ]
    then
      echo "Error: You are not on any branch. Please checkout to a branch." 1>&2
      return 1
    fi
  fi

  current_commit=$(git rev-parse "$branch")

  while true
  do
    latest_commit=$(gh pr view "$branch" --json 'commits' | jq -r '.commits[-1].oid')
    if [ "$current_commit" == "$latest_commit" ]
    then
      break
    fi
    sleep $time_interval
  done
}

wait4github $@
