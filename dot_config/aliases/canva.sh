# Git
alias gcgp="git checkout green && git pull"
alias gcgm="git checkout master && git pull"

# Lunch
lunch() {
    open "https://canv.am/lunch-sydney"
}

alias wp="bin/webpack-dev-server"
alias sb="bin/storybook_single.sh"

fin() {
  cur_dir=$(basename "$PWD")

  if [ "$cur_dir" != "web" ]; then
    if [ -d "web" ]; then
      cd web
    else
      echo 'not in web and web does not exist' >&2
      return 1
    fi
  fi

  yarn fin $@
}

PSEUDO_MANGLE_PROPERTIES=true

alias ownership=~/work/canva/tools/code_review/ownership

