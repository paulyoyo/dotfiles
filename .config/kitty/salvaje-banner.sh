#!/usr/bin/env bash
# ~/.config/kitty/salvaje-banner.sh
# Salvaje startup banner — prints a colored ASCII logo on new kitty sessions.
#
# Sourced from .zshrc, gated on $TERM_PROGRAM=="kitty" and $SHLVL==1 so it
# only prints on a fresh kitty window, never on subshells, zellij splits, or
# reattached tmux sessions.

# ─────────────────────────────────────────────────────────────────────
# Salvaje palette — 24-bit RGB (kitty handles true color natively)
# ─────────────────────────────────────────────────────────────────────
C_SNOW='247;247;245'
C_WISTERIA='197;153;226'
C_BRIGHT_LILAC='164;116;212'
C_LILAC='137;86;186'
C_GOLD='234;216;47'
C_ROSE='224;99;122'
C_SAGE='143;191;108'
C_TEAL='106;175;184'
C_GREY='154;142;166'
C_LILAC_GREY='92;78;106'

rgb() { printf '\033[38;2;%sm' "$1"; }
rst() { printf '\033[0m'; }

# ─────────────────────────────────────────────────────────────────────
# ASCII art — figlet "ansi_regular" (flat blocks, no 3D shadow, visually
# distinct from LazyVim's ANSI Shadow dashboard). All rows normalised to
# 57 columns wide.
# ─────────────────────────────────────────────────────────────────────
ROW1='███████  █████  ██      ██    ██  █████       ██ ███████ '
ROW2='██      ██   ██ ██      ██    ██ ██   ██      ██ ██      '
ROW3='███████ ███████ ██      ██    ██ ███████      ██ █████   '
ROW4='     ██ ██   ██ ██       ██  ██  ██   ██ ██   ██ ██      '
ROW5='███████ ██   ██ ███████   ████   ██   ██  █████  ███████ '

# Rounded frame — 63 chars outer, 61 chars inner (2-space padding)
TOP='╭─────────────────────────────────────────────────────────────╮'
BOT='╰─────────────────────────────────────────────────────────────╯'
BLANK='                                                             '

# Taglines padded to 61 inner width
TAGLINE='      ~ warm dark · purple nodes · golden connections ~      '
SUBLINE='                     salvaje · v1 · 2026                     '

# Row-by-row gradient — wisteria at top, rose at bottom
GRADIENT_1="$C_WISTERIA"
GRADIENT_2="$C_BRIGHT_LILAC"
GRADIENT_3="$C_LILAC"
GRADIENT_4="$C_GOLD"
GRADIENT_5="$C_ROSE"

# ─────────────────────────────────────────────────────────────────────
# Render
# ─────────────────────────────────────────────────────────────────────
echo
printf ' '; rgb "$C_LILAC"; printf '%s' "$TOP";   rst; echo
printf ' '; rgb "$C_LILAC"; printf '│';           rst; printf '%s' "$BLANK"; rgb "$C_LILAC"; printf '│'; rst; echo

# Row helper: side │ + 2-space pad + colored row + 2-space pad + side │
render_row() {
  local color="$1" row="$2"
  printf ' '; rgb "$C_LILAC"; printf '│'; rst
  printf '  '
  rgb "$color"; printf '%s' "$row"; rst
  printf '  '
  rgb "$C_LILAC"; printf '│'; rst
  echo
}
render_row "$GRADIENT_1" "$ROW1"
render_row "$GRADIENT_2" "$ROW2"
render_row "$GRADIENT_3" "$ROW3"
render_row "$GRADIENT_4" "$ROW4"
render_row "$GRADIENT_5" "$ROW5"

printf ' '; rgb "$C_LILAC"; printf '│'; rst; printf '%s' "$BLANK"; rgb "$C_LILAC"; printf '│'; rst; echo
printf ' '; rgb "$C_LILAC"; printf '│'; rst; rgb "$C_GREY";       printf '%s' "$TAGLINE"; rst; rgb "$C_LILAC"; printf '│'; rst; echo
printf ' '; rgb "$C_LILAC"; printf '│'; rst; rgb "$C_LILAC_GREY"; printf '%s' "$SUBLINE"; rst; rgb "$C_LILAC"; printf '│'; rst; echo
printf ' '; rgb "$C_LILAC"; printf '│'; rst; printf '%s' "$BLANK"; rgb "$C_LILAC"; printf '│'; rst; echo
printf ' '; rgb "$C_LILAC"; printf '%s' "$BOT"; rst; echo
echo
