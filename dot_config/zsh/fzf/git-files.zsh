fzf-changed-file-widget() {
  if ! command git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    zle -M 'Not inside a Git repository'
    return 1
  fi

  local file
  file="$(
    {
      command git diff --name-only -z
      command git diff --cached --name-only -z
      command git ls-files --others --exclude-standard -z
    } |
      command sort -zu |
      command fzf \
        --read0 \
        --height=60% \
        --layout=reverse \
        --border \
        --scheme=path \
        --prompt='Changed files> '
  )"

  if [[ -n $file ]]; then
    LBUFFER+=${(q)file}
  fi

  zle reset-prompt
}

zle -N fzf-changed-file-widget

for keymap in emacs viins vicmd; do
  bindkey -M $keymap '^Xf' fzf-changed-file-widget
done
unset keymap
