# brew shellenv here (not .zprofile) so non-login shells (zellij panes,
# scripts, etc.) also get /opt/homebrew/bin on PATH.
[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
