#!/bin/sh

commit_id="$1"

if [ -z "$commit_id" ]; then
    commit_msg=`git show -s --format=%s`
else
    commit_msg=`git show -s --format=%s $commit_id`
fi


echo $commit_msg | sed -E 's/[[:space:]]+/-/g' | vipe

