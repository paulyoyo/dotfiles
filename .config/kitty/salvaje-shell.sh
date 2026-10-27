#!/bin/bash
# ~/.config/kitty/salvaje-shell.sh
#
# kitty shell wrapper — prints the Salvaje banner, then execs the real
# login shell. Configured as `shell` in kitty.conf so kitty invokes this
# instead of /bin/zsh directly for every new window/tab.
#
# Running at the kitty layer (not inside .zshrc) guarantees:
#   1. The banner prints before zsh/anything else touches the screen
#   2. It fires on every fresh kitty window, regardless of $SHLVL
#   3. Removing it is one kitty.conf line, not a zsh config surgery
#
# zellij is NOT auto-started. Run `zellij` manually when you want it.

"$HOME/.config/kitty/salvaje-banner.sh"

exec /bin/zsh -il
