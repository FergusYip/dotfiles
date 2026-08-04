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

custard() {
  ssh -t coder.fergus-custard 'tmux new-session -A -s main'
}

bao() {
  # --force-run-commands re-runs a resurrected session's commands instead of
  # leaving dead panes. But a workspace auto-stop can serialise tabs holding
  # only tab-bar/status-bar plugin panes and no terminal at all; resurrecting
  # that exits instantly with "Bye from Zellij!" *and status 0*, so `||` alone
  # never catches it -- and `--forget` does not clear it either, it just
  # resurrects the same broken dump. So: when we know the session was EXITED,
  # treat an instant exit as a failed resurrection, delete the dump outright,
  # and start clean.
  ssh -t coder.fergus-bao '
    exited=0
    zellij list-sessions --no-formatting 2>/dev/null \
      | grep -q "^main .*EXITED" && exited=1

    start=$SECONDS
    zellij attach --create --force-run-commands main
    rc=$?

    # Do not name this "status" -- the remote login shell is zsh, where $status
    # is a read-only alias for $? and assigning to it aborts the script.
    if [ "$rc" -ne 0 ] ||
       { [ "$exited" -eq 1 ] && [ "$(( SECONDS - start ))" -lt 3 ]; }; then
      echo "zellij: could not resurrect main, starting a clean session" >&2
      zellij delete-session --force main 2>/dev/null
      zellij attach --create main
    fi
  '
}
