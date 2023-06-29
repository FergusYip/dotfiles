exists () {
    type "$1" >/dev/null 2>/dev/null
}

alias_if_exists () {
    name="$1"
    shift 1;
    for i in "$@"; do
	if exists "$i"; then
            alias "$name"="$i"
            return 0
	fi
    done
    return 1
}

alias_if_exists ls exa
alias ll='ls -alh'
alias la='ls -a'

alias_if_exists v lvim nvim vim vi
alias_if_exists vim lvim nvim vi

alias_if_exists code codium

alias open-deep="xcrun simctl openurl booted"

alias y="yarn"
alias yw="yarn workspace"
alias 'ypad'="yarn ios --simulator 'iPad Pro (11-inch) (3rd generation)'"

gch () {
    query="$@"
    branches=$(git branch -a)
    if [ -n "$branches" ]; then
        branch="$(echo "$branches" | sed 's/..//' | fzf -q "$query")"
        if [ ! -z "$branch" ]; then
            git checkout "$branch"
        fi
    fi
    
}


git_parent () {
    branch=`git rev-parse --abbrev-ref HEAD`
    git show-branch -a 2>/dev/null | grep '\*' | grep -v "$branch" | head -n1 | sed 's/.*\[\(.*\)\].*/\1/' | sed 's/[\^~].*//'
}

alias gs="git status"
alias gc="git checkout"
alias gcb="git checkout -b"
alias gcd="git checkout -d"

report () {
    $@ && say "Done" || say "Failed"
}

[ -f ~/.config/aliases/canva.sh ] && source ~/.config/aliases/canva.sh

