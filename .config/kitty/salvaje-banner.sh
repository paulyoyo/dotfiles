#!/usr/bin/env bash
# ~/.config/kitty/salvaje-banner.sh
# Salvaje startup banner — prints a colored braille-art sigil on fresh
# kitty sessions.
#
# Reads the 19×100 braille art from ~/.config/kitty/salvaje-banner.txt
# and applies a 5-band Salvaje gradient down the rows:
#   rows 1-4   wisteria       #C599E2
#   rows 5-8   bright lilac   #A474D4
#   rows 9-12  deep lilac     #8956BA
#   rows 13-16 golden glow    #EAD82F
#   rows 17-19 rose           #E0637A
#
# Sourced from .zshrc, gated on $TERM_PROGRAM=="kitty" and $SHLVL==1
# so it only prints on a fresh kitty window — not subshells, zellij
# splits, tmux reattaches, or non-kitty terminals.

BANNER_FILE="${BASH_SOURCE%/*}/salvaje-banner.txt"
[[ -r "$BANNER_FILE" ]] || exit 0

rgb() { printf '\033[38;2;%sm' "$1"; }
rst() { printf '\033[0m'; }

# Salvaje palette — 24-bit RGB (kitty handles true color natively)
C_WISTERIA='197;153;226'
C_BRIGHT_LILAC='164;116;212'
C_LILAC='137;86;186'
C_GOLD='234;216;47'
C_ROSE='224;99;122'
C_GREY='154;142;166'
C_LILAC_GREY='92;78;106'

# 5-band gradient for 19 rows (4+4+4+4+3)
ROW_COLORS=(
  "$C_WISTERIA"     "$C_WISTERIA"     "$C_WISTERIA"     "$C_WISTERIA"
  "$C_BRIGHT_LILAC" "$C_BRIGHT_LILAC" "$C_BRIGHT_LILAC" "$C_BRIGHT_LILAC"
  "$C_LILAC"        "$C_LILAC"        "$C_LILAC"        "$C_LILAC"
  "$C_GOLD"         "$C_GOLD"         "$C_GOLD"         "$C_GOLD"
  "$C_ROSE"         "$C_ROSE"         "$C_ROSE"
)

# ─────────────────────────────────────────────────────────────────────
# Render
# ─────────────────────────────────────────────────────────────────────
echo
i=0
while IFS= read -r line; do
  color="${ROW_COLORS[$i]:-$C_LILAC}"
  printf ' '
  rgb "$color"
  printf '%s' "$line"
  rst
  echo
  i=$((i + 1))
done < "$BANNER_FILE"

echo
# Tagline + subline padded to 100 content chars (matches braille row width)
printf ' '
rgb "$C_GREY"
printf '                    ~ salvaje · warm dark · purple nodes · golden connections ~                     '
rst
echo
printf ' '
rgb "$C_LILAC_GREY"
printf '                                        salvaje · v1 · 2026                                         '
rst
echo
echo
