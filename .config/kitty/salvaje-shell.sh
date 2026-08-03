#!/bin/bash
# ~/.config/kitty/salvaje-shell.sh
#
# kitty shell wrapper — prints the Salvaje banner, then execs the real
# login shell. Configured as `shell` in kitty.conf so kitty invokes this
# instead of /bin/zsh directly for every new window/tab.
#
# Running at the kitty layer (not inside .zshrc) guarantees:
#   1. The banner prints before zsh/zellij/anything else touches the screen
#   2. It fires on every fresh kitty window, regardless of $SHLVL or $ZELLIJ
#   3. Removing it is one kitty.conf line, not a zsh config surgery

"$HOME/.config/kitty/salvaje-banner.sh"

# Auto-attach zellij on fresh kitty windows. Guard $ZELLIJ so nested
# shells (zellij's own panes) don't recurse. attach -c = attach default
# session, create if missing → one persistent session across kitty opens.
if [ -z "$ZELLIJ" ] && [ -x /opt/homebrew/bin/zellij ]; then
  exec /opt/homebrew/bin/zellij attach -c
fi

exec /bin/zsh -il
