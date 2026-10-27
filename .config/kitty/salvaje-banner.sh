#!/usr/bin/env bash
# ~/.config/kitty/salvaje-banner.sh
# Salvaje startup banner — prints the colored braille logo on fresh
# kitty sessions.
#
# Reads the 18x98 braille art from ~/.config/kitty/salvaje-banner.txt
# (generated from the Salvaje logo SVG: bull sigil + Stomic wordmark +
# GT Pressura "PLAY WILD") and applies a 5-band Salvaje gradient down
# the rows:
#   rows 1-4   wisteria       #C599E2
#   rows 5-8   bright lilac   #A474D4
#   rows 9-12  deep lilac     #8956BA
#   rows 13-15 golden glow    #EAD82F
#   rows 16-18 rose           #E0637A
#
# Invoked by salvaje-shell.sh, which kitty runs as its `shell` wrapper,
# so this fires once per fresh kitty window or tab, before zsh starts.
#
# NOTE: macOS ships bash 3.2, and kitty runs this through /bin/bash.
# Keep it 3.2-compatible — no mapfile, no associative arrays.

HERE="${BASH_SOURCE%/*}"
[ "$HERE" = "$BASH_SOURCE" ] && HERE="."
BANNER_FILE="$HERE/salvaje-banner.txt"
QUOTES_FILE="$HERE/salvaje-quotes.txt"
[[ -r "$BANNER_FILE" ]] || exit 0

BANNER_W=98        # character width of every line in salvaje-banner.txt

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

# 5-band gradient across the 18 rows of the logo (4+4+4+3+3)
ROW_COLORS=(
  "$C_WISTERIA"     "$C_WISTERIA"     "$C_WISTERIA"     "$C_WISTERIA"
  "$C_BRIGHT_LILAC" "$C_BRIGHT_LILAC" "$C_BRIGHT_LILAC" "$C_BRIGHT_LILAC"
  "$C_LILAC"        "$C_LILAC"        "$C_LILAC"        "$C_LILAC"
  "$C_GOLD"         "$C_GOLD"         "$C_GOLD"
  "$C_ROSE"         "$C_ROSE"         "$C_ROSE"
)

# ─────────────────────────────────────────────────────────────────────
# Render the logo
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

# ─────────────────────────────────────────────────────────────────────
# Rotating quote
# ─────────────────────────────────────────────────────────────────────
# One quote per line in salvaje-quotes.txt; `#` comments and blank lines
# are skipped. Everything after a `|` is printed as a dim attribution on
# the next line, right-aligned. The attribution is optional, so quotes
# from different books each carry their own source.
echo
LINE=""
if [ -s "$QUOTES_FILE" ]; then
  LINE=$(grep -v '^[[:space:]]*#' "$QUOTES_FILE" | grep -v '^[[:space:]]*$' | \
    awk 'BEGIN{srand()} {a[NR]=$0} END{if(NR>0) print a[int(rand()*NR)+1]}')
fi
[ -z "$LINE" ] && LINE="(populate ~/.config/kitty/salvaje-quotes.txt with one quote per line)"

QUOTE="${LINE%%|*}"
AUTHOR=""
case "$LINE" in *'|'*) AUTHOR="${LINE#*|}" ;; esac

# trim surrounding whitespace
QUOTE=$(printf '%s' "$QUOTE" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')
AUTHOR=$(printf '%s' "$AUTHOR" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')

# Truncate to the banner width; count characters (not bytes) for UTF-8 safety
Q_LEN=$(printf '%s' "$QUOTE" | wc -m | tr -d ' ')
if [ "$Q_LEN" -gt "$BANNER_W" ]; then
  QUOTE=$(printf '%s' "$QUOTE" | cut -c1-$((BANNER_W - 3)))...
  Q_LEN=$BANNER_W
fi

PAD_L=$(( (BANNER_W - Q_LEN) / 2 ))
printf ' '
rgb "$C_GREY"
printf '%*s%s' "$PAD_L" "" "$QUOTE"
rst
echo

if [ -n "$AUTHOR" ]; then
  A_LEN=$(printf '%s' "$AUTHOR" | wc -m | tr -d ' ')
  PAD_A=$(( BANNER_W - A_LEN - 2 ))
  [ "$PAD_A" -lt 0 ] && PAD_A=0
  printf ' '
  rgb "$C_LILAC_GREY"
  printf '%*s— %s' "$PAD_A" "" "$AUTHOR"
  rst
  echo
fi
echo
