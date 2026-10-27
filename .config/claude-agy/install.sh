#!/usr/bin/env bash
# Install the Claude Code + Antigravity (agy) kit by symlinking it from this folder,
# so the folder (e.g. inside ~/.dotfiles) stays the single source of truth.
set -euo pipefail

KIT="$(cd "$(dirname "$0")" && pwd)"
CMD_DIR="$HOME/.claude/commands"
BIN_DIR="$HOME/.local/bin"
stamp=$(date +%Y%m%d%H%M%S)

say()  { printf '  %s\n' "$*"; }
warn() { printf '  ! %s\n' "$*"; }

link() {  # link SRC DEST, backing up a real file that is in the way
  local src=$1 dest=$2
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    mv "$dest" "$dest.bak-$stamp"
    warn "existing $(basename "$dest") moved to $(basename "$dest").bak-$stamp"
  fi
  ln -sfn "$src" "$dest"
  say "linked $dest"
}

echo "Installing claude-agy kit from $KIT"
mkdir -p "$CMD_DIR" "$BIN_DIR"
chmod +x "$KIT"/bin/*

for b in "$KIT"/bin/*; do
  link "$b" "$BIN_DIR/$(basename "$b")"
done
for f in "$KIT"/commands/*.md; do
  link "$f" "$CMD_DIR/$(basename "$f")"
done

echo
echo "Checks"
case ":$PATH:" in
  *":$BIN_DIR:"*) say "~/.local/bin is in PATH" ;;
  *) warn "~/.local/bin is not in PATH. Add to ~/.zshrc:  export PATH=\"\$HOME/.local/bin:\$PATH\"" ;;
esac

if command -v agy >/dev/null 2>&1; then
  say "agy found: $(agy --version 2>/dev/null | head -1 || echo 'version unknown')"
else
  warn "agy not installed. Install it, then run 'agy' once to sign in with your Google AI Pro account:"
  warn "  curl -fsSL https://antigravity.google/cli/install.sh | bash"
fi

if command -v python3 >/dev/null 2>&1 || command -v jq >/dev/null 2>&1; then
  say "JSON parser available ($(command -v python3 >/dev/null 2>&1 && echo python3 || echo jq))"
else
  warn "neither python3 nor jq found: install one (brew install jq) so agy-ask can parse agy's JSON output"
fi

if command -v claude >/dev/null 2>&1; then say "claude found"; else warn "claude (Claude Code) not found in PATH"; fi

echo
echo "Done. Per project: paste CLAUDE.md.snippet into the project's CLAUDE.md and create a plans/ folder."
