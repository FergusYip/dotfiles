branch_or_pr="$1"

# Get branch_name from PR number
if [ `echo $branch_or_pr | egrep '^\s*#?\d+\s*$'` ]; then
    if command -v gh >/dev/null; then
        :
    else 
        echo "GitHub CLI missing: Install it at https://cli.github.com/" >&2
        exit 1
    fi
    branch_name=`gh pr view $branch_or_pr --json headRefName -q '.headRefName' 2&>/dev/null`
    if [ -z $branch_name ]; then
        echo "Invalid PR: $branch_or_pr" >&2
        exit 1
    fi
elif [ -z $branch_or_pr ]; then
    branch_name=`git branch --show-current`
else
    branch_name=$branch_or_pr
fi

if git show-ref --quiet "$branch_name"; then
    :
else
    echo "Branch does not exist" >&2
    exit 1
fi

commit_hash=`git rev-parse $branch_name`

echo "https://e2.canva.tech/branch/$branch_name/$commit_hash"

