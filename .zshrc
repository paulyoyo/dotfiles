# ~/.zshrc

# ─────────────────────────────────────────────────────────────────────
# Terminal capabilities
# ─────────────────────────────────────────────────────────────────────
# kitty supports full 24-bit RGB → use the hex-palette starship config.
# Apple Terminal.app silently degrades RGB escapes to xterm-256 even
# with COLORTERM set, so we switch to a starship config that uses
# named ANSI slots (yellow/blue/purple/...), which Terminal.app resolves
# through the Salvaje.terminal profile's 16-color palette.
if [[ "$TERM_PROGRAM" == "Apple_Terminal" ]]; then
  export STARSHIP_CONFIG="$HOME/.config/starship-terminal.toml"
else
  export COLORTERM=truecolor
fi

# ─────────────────────────────────────────────────────────────────────
# Variables base
# ─────────────────────────────────────────────────────────────────────
export EXTERNAL_MAC="$HOME/external-mac"
export TMUX_CONFIG="$HOME/.tmux"
export DEV_HOME="/Volumes/masterlama/dev/paul"

# ─────────────────────────────────────────────────────────────────────
# PATH
# ─────────────────────────────────────────────────────────────────────
export PATH="$EXTERNAL_MAC/bin:$HOME/.local/bin:$DEV_HOME/.local/bin:$PATH"

# Android SDK — hardcoded path avoids spaces in $HOME breaking Java classpath
export ANDROID_HOME="/Users/paulsutcliffe/android-sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/emulator"

# Node specific
export PATH="/Volumes/El Gato/External Mac/.nvm/versions/node/v20.19.4/bin:$PATH"

# ─────────────────────────────────────────────────────────────────────
# Aliases
# ─────────────────────────────────────────────────────────────────────
alias ext="cd $EXTERNAL_MAC"
alias tmux-config="cd $TMUX_CONFIG"
alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias ai="aider --model deepseek/deepseek-coder --chat-language english"

# Dotfiles bare repo alias
alias config='/opt/homebrew/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# ─────────────────────────────────────────────────────────────────────
# Historial avanzado
# ─────────────────────────────────────────────────────────────────────
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS

# ─────────────────────────────────────────────────────────────────────
# tmux tmp dir (seguro)
# ─────────────────────────────────────────────────────────────────────
export TMUX_TMPDIR="$HOME/.tmux/tmp"
[[ ! -d "$TMUX_TMPDIR" ]] && mkdir -p "$TMUX_TMPDIR"

# ─────────────────────────────────────────────────────────────────────
# FZF
# ─────────────────────────────────────────────────────────────────────
eval "$(fzf --zsh)"

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

# FZF colors — Salvaje palette
export FZF_DEFAULT_OPTS="--color=fg:#F7F7F5,bg:#060100,hl:#8956BA,fg+:#F7F7F5,bg+:#2A1A38,hl+:#C599E2,info:#6AAFB8,prompt:#EAD82F,pointer:#EAD82F,marker:#EAD82F,spinner:#C599E2,header:#C599E2"

# ─────────────────────────────────────────────────────────────────────
# Completion system
# Load order is load-bearing:
#   1. zsh-completions → added to $fpath BEFORE compinit
#   2. compinit        → builds the completion database
#   3. fzf-tab         → hooks into the completion system (must be AFTER compinit)
#   4. zsh-autosuggestions → sources its own widget (order-independent, but
#      convention is to source after completion is set up)
# ─────────────────────────────────────────────────────────────────────

# 1. zsh-completions — adds ~1000 extra completion scripts to fpath
fpath=("$(brew --prefix)/share/zsh-completions" $fpath)

# 2. Initialise zsh's native completion system
autoload -Uz compinit
compinit

# 3. fzf-tab — replaces the default Tab completion menu with an fzf picker.
#    MUST come after compinit.
source "$HOME/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh"

# fzf-tab styling — Salvaje colors, wider preview pane, group headers
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no                          # disable native menu (fzf-tab replaces it)
zstyle ':fzf-tab:complete:*' fzf-preview \
  'if [[ -d $realpath ]]; then eza -1 --color=always --icons=always "$realpath" 2>/dev/null; \
   elif [[ -f $realpath ]]; then bat -n --color=always --line-range :300 "$realpath" 2>/dev/null; \
   fi'
zstyle ':fzf-tab:*' fzf-flags --height=50% --layout=reverse --border --preview-window=right:60%:wrap
zstyle ':fzf-tab:*' switch-group '<' '>'                # alt groups with < / >
zstyle ':fzf-tab:*' use-fzf-default-opts yes            # inherit FZF_DEFAULT_OPTS (Salvaje colors)

# 4. zsh-autosuggestions — ghost text from history
source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
# Style the ghost text with Salvaje lilac-grey so it's clearly dim
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#5C4E6A'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# 5. Prefix-based history search on up/down arrows.
# Type "zellij" then press ↑ to cycle through only history entries
# starting with "zellij". Built-in zsh — no plugin needed.
# The -end widgets jump the cursor to end-of-line after matching.
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end  history-search-end
bindkey "^[[A" history-beginning-search-backward-end   # ↑
bindkey "^[[B" history-beginning-search-forward-end    # ↓
bindkey "^[OA" history-beginning-search-backward-end   # ↑ (alt termcap)
bindkey "^[OB" history-beginning-search-forward-end    # ↓ (alt termcap)

# ─────────────────────────────────────────────────────────────────────
# Bat
# ─────────────────────────────────────────────────────────────────────
export BAT_THEME=tokyonight_night

# ─────────────────────────────────────────────────────────────────────
# NVM
# ─────────────────────────────────────────────────────────────────────
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# ─────────────────────────────────────────────────────────────────────
# rbenv
# ─────────────────────────────────────────────────────────────────────
export RBENV_ROOT="/opt/rbenv"
eval "$(rbenv init - zsh)"

# ─────────────────────────────────────────────────────────────────────
# direnv
# ─────────────────────────────────────────────────────────────────────
eval "$(direnv hook zsh)"

# ─────────────────────────────────────────────────────────────────────
# zoxide — smarter cd that learns your most-used directories
# Usage: `z foo` jumps to the highest-ranked dir matching "foo"
#        `zi foo` opens an fzf picker if there are multiple matches
# ─────────────────────────────────────────────────────────────────────
eval "$(zoxide init zsh)"

# ─────────────────────────────────────────────────────────────────────
# AMP Config
# ─────────────────────────────────────────────────────────────────────
export AMPCODE_LLM_PROVIDER=ollama
export AMPCODE_OLLAMA_BASE_URL=http://localhost:11434
export AMPCODE_MODEL=qwen2.5-coder:1.5b

# ─────────────────────────────────────────────────────────────────────
# Secrets (gitignored, not in dotfiles repo)
# ─────────────────────────────────────────────────────────────────────
[[ -f "$HOME/.secrets" ]] && source "$HOME/.secrets"

# ─────────────────────────────────────────────────────────────────────
# Window title — user@host: cwd  (runs before each prompt)
# ─────────────────────────────────────────────────────────────────────
autoload -Uz add-zsh-hook
function _set_window_title() {
  print -Pn "\e]0;%n@%m: %~\a"
}
add-zsh-hook precmd _set_window_title

# ─────────────────────────────────────────────────────────────────────
# Starship prompt  (https://starship.rs/)
# ─────────────────────────────────────────────────────────────────────
eval "$(starship init zsh)"

# ─────────────────────────────────────────────────────────────────────
# Transient prompt — replaces p10k's POWERLEVEL9K_TRANSIENT_PROMPT
# When you press Enter, the current full starship prompt collapses to a
# minimal `❯ ` (in Sage green). Only the NEXT prompt stays full with all
# segments. Keeps scrollback clean and readable.
#
# Technique: zle-line-init captures Enter via .recursive-edit, rewrites
# the displayed prompt to the minimal version, then accepts the line.
# Starship's precmd regenerates the full prompt for the next command.
# This is the same mechanism powerlevel10k used internally.
# ─────────────────────────────────────────────────────────────────────
function zle-line-init() {
  emulate -L zsh
  [[ $CONTEXT == start ]] || return 0

  # Enter the recursive edit loop — user types normally, loop returns
  # when they press Enter (ret=0) or Ctrl-D (ret=0, KEYS=\4).
  while true; do
    zle .recursive-edit
    local -i ret=$?
    [[ $ret == 0 && $KEYS == $'\4' ]] || break
    [[ -o ignore_eof ]] || exit 0
  done

  # Save current prompt, replace with minimal transient version
  local saved_prompt=$PROMPT
  local saved_rprompt=$RPROMPT
  # Sage green ❯ matching starship's success_symbol color
  PROMPT=$'%{\e[1;38;2;143;191;108m%}❯%{\e[0m%} '
  RPROMPT=''
  zle .reset-prompt

  # Restore so starship's precmd regenerates the full prompt next time
  PROMPT=$saved_prompt
  RPROMPT=$saved_rprompt

  if (( ret )); then
    zle .send-break
  else
    zle .accept-line
  fi
  return ret
}
zle -N zle-line-init

# ─────────────────────────────────────────────────────────────────────
# Salvaje startup banner is now printed by ~/.config/kitty/salvaje-shell.sh
# (configured as kitty's `shell` wrapper in kitty.conf). That way it fires
# on every new kitty OS window or tab, before zsh or zellij touch the
# screen — much more reliable than gating from .zshrc.
# ─────────────────────────────────────────────────────────────────────

# Flutter: Chrome on external drive
export CHROME_EXECUTABLE="/Volumes/El Gato/External Mac/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
