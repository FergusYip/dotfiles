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

  pnpm fin --compact --reduceAnimations $@
}

protogaps() {                                                            
  grep -oEi '(=\s*\d+[ ;])|(reserved\s+\d+)' "$1" | grep -oE '\d+' | sort -h | awk '$1!=n+1&&$1>n{print n+1"-"$1-1}{n=$1}'
}

PSEUDO_MANGLE_PROPERTIES=true

alias ownership=~/work/canva/tools/code_review/ownership

# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
# End Nix

# CoderEnv
# DO NOT EDIT: Added by Coder CLI installer (https://coder.canva-internal.com/install.sh)
[ -e "/Users/fergus/.coder.sh" ] && . "/Users/fergus/.coder.sh"
# EndCoderEnv

