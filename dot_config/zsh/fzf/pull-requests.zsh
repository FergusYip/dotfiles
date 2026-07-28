_fzf-pr-picker-ready() {
  if (( ! $+commands[gh] )); then
    zle -M 'gh is not installed'
    return 1
  fi

  if ! command git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    zle -M 'Not inside a Git repository'
    return 1
  fi
}

_fzf-pr-number() {
  local prompt=$1
  shift

  command gh pr list "$@" |
    command fzf \
      --height=60% \
      --layout=reverse \
      --border \
      --prompt="$prompt" \
      --header=$'PR\tTitle' \
      --delimiter=$'\t' \
      --with-nth=1,2 \
      --accept-nth=1
}

fzf-my-pr-widget() {
  _fzf-pr-picker-ready || return

  local pr_number
  pr_number="$(
    _fzf-pr-number \
      'My PRs> ' \
      --state all \
      --author '@me' \
      --limit 1000 \
      --json number,title \
      --template '{{range .}}{{printf "%v\t%s\n" .number .title}}{{end}}'
  )"

  if [[ -n $pr_number ]]; then
    LBUFFER+=$pr_number
  fi

  zle reset-prompt
}

fzf-open-pr-widget() {
  _fzf-pr-picker-ready || return

  local pr_number
  pr_number="$(
    _fzf-pr-number \
      'Open PRs> ' \
      --state open \
      --author '@me' \
      --limit 1000 \
      --json number,title \
      --template '{{range .}}{{printf "%v\t%s\n" .number .title}}{{end}}'
  )"

  if [[ -n $pr_number ]]; then
    LBUFFER+=$pr_number
  fi

  zle reset-prompt
}

zle -N fzf-my-pr-widget
zle -N fzf-open-pr-widget

for keymap in emacs viins vicmd; do
  bindkey -M $keymap '^Xp' fzf-my-pr-widget
  bindkey -M $keymap '^Xo' fzf-open-pr-widget
done
unset keymap
