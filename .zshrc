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

# Android SDK (modern layout — `tools/` was removed in recent SDKs)
export ANDROID_HOME="$HOME/Library/Android/sdk"
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
# Salvaje startup banner is now printed by ~/.config/kitty/salvaje-shell.sh
# (configured as kitty's `shell` wrapper in kitty.conf). That way it fires
# on every new kitty OS window or tab, before zsh or zellij touch the
# screen — much more reliable than gating from .zshrc.
# ─────────────────────────────────────────────────────────────────────
