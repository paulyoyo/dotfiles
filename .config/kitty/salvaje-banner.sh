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

# 5-band gradient across 17 rows of the bull/Salvaje logo (4+3+3+3+4)
ROW_COLORS=(
  "$C_WISTERIA"     "$C_WISTERIA"     "$C_WISTERIA"     "$C_WISTERIA"
  "$C_BRIGHT_LILAC" "$C_BRIGHT_LILAC" "$C_BRIGHT_LILAC"
  "$C_LILAC"        "$C_LILAC"        "$C_LILAC"
  "$C_GOLD"         "$C_GOLD"         "$C_GOLD"
  "$C_ROSE"         "$C_ROSE"         "$C_ROSE"         "$C_ROSE"
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
# Random quote from ~/.config/kitty/salvaje-quotes.txt — one line per quote,
# # for comments, blank lines ignored. Centered to 100 chars. Falls back to
# a hint message if file is missing or empty.
QUOTES_FILE="${BASH_SOURCE%/*}/salvaje-quotes.txt"
QUOTE=""
if [ -s "$QUOTES_FILE" ]; then
  QUOTE=$(grep -v '^[[:space:]]*#' "$QUOTES_FILE" | grep -v '^[[:space:]]*$' | \
    awk 'BEGIN{srand()} {a[NR]=$0} END{if(NR>0) print a[int(rand()*NR)+1]}')
fi
[ -z "$QUOTE" ] && QUOTE="(populate ~/.config/kitty/salvaje-quotes.txt with one quote per line)"

# Truncate to 100 chars max; count characters (not bytes) for UTF-8 safety
Q_LEN=$(printf '%s' "$QUOTE" | wc -m | tr -d ' ')
if [ "$Q_LEN" -gt 100 ]; then
  QUOTE=$(printf '%s' "$QUOTE" | cut -c1-97)...
  Q_LEN=100
fi
PAD_L=$(( (100 - Q_LEN) / 2 ))
PAD_R=$(( 100 - Q_LEN - PAD_L ))

printf ' '
rgb "$C_GREY"
printf '%*s%s%*s' "$PAD_L" "" "$QUOTE" "$PAD_R" ""
rst
echo
printf ' '
rgb "$C_LILAC_GREY"
printf '                              — Jeff Olson, The Slight Edge                                         '
rst
echo
echo
