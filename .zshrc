# ~/.zshrc
# ============================================================================
# ZSH Configuration (Optimized for Speed)
# ============================================================================

# ----------------------------------------------------------------------------
# Homebrew Configuration (Must be early for PATH setup)
# ----------------------------------------------------------------------------
if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/usr/local/bin/brew" ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# ----------------------------------------------------------------------------
# History Configuration
# ----------------------------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS

# ----------------------------------------------------------------------------
# Completions 
# ----------------------------------------------------------------------------
autoload -Uz compinit

# Only regenerate compdump once per day
if [[ -n ${HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Enhanced completion settings
zstyle ':completion:*' menu select                          # Arrow-key driven menu
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'   # Case-insensitive matching
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"     # Colorful completion
zstyle ':completion:*' special-dirs true                     # Complete . and ..
zstyle ':completion:*' file-sort modification                # Sort by modification time

# Enable completion caching
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# ----------------------------------------------------------------------------
# Key Bindings (Emacs-style)
# ----------------------------------------------------------------------------
bindkey -e  # Use emacs key bindings

# Ctrl + Arrow keys for word navigation
bindkey "^[[1;5C" forward-word      # Ctrl + Right Arrow
bindkey "^[[1;5D" backward-word     # Ctrl + Left Arrow

# Additional useful bindings
bindkey "^A" beginning-of-line      # Ctrl + A: Start of line
bindkey "^E" end-of-line            # Ctrl + E: End of line
bindkey "^K" kill-line              # Ctrl + K: Delete to end of line
bindkey "^U" backward-kill-line     # Ctrl + U: Delete to start of line
bindkey "^W" backward-kill-word     # Ctrl + W: Delete word backwards
bindkey "^Y" yank                   # Ctrl + Y: Yank

# History navigation
bindkey "^P" up-line-or-history     # Ctrl + P: Previous command
bindkey "^N" down-line-or-history   # Ctrl + N: Next command


# ----------------------------------------------------------------------------
# FZF Integration (Fuzzy Finder)
# ----------------------------------------------------------------------------
# Install fzf if not already installed:
# brew install fzf
# $(brew --prefix)/opt/fzf/install

# Load fzf key bindings and completion
if [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh
elif [ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]; then
  source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
  source /opt/homebrew/opt/fzf/shell/completion.zsh
fi

# FZF default configuration
export FZF_DEFAULT_OPTS="
  --height 40%
  --layout=reverse
  --border
  --bind ctrl-/:toggle-preview
"

# Customize Ctrl+R for better history search
export FZF_CTRL_R_OPTS="
  --preview 'echo {}'
  --preview-window down:3:wrap
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'
"

# Enhanced Ctrl+T with bat and tree
export FZF_CTRL_T_OPTS="
  --preview 'bat --color=always --style=numbers --line-range=:500 {} 2>/dev/null || cat {} 2>/dev/null || 

ls -la {}'
  --preview-window right:50%
  --bind 'ctrl-/:toggle-preview'
"

# Enhanced Alt+C with tree
export FZF_ALT_C_OPTS="
  --preview 'tree -C -L 2 {} 2>/dev/null || 

ls -la {}'
  --preview-window right:50%
"

# ----------------------------------------------------------------------------
# NVM (Lazy Loaded for Speed)
# ----------------------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"

# Lazy load nvm - only initialize when first used
nvm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm "$@"
}

node() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  node "$@"
}

npm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  npm "$@"
}

npx() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  npx "$@"
}

# ----------------------------------------------------------------------------
# Functions
# ----------------------------------------------------------------------------
# Quick log viewer with fzf
logview() {
  local log_path="${1:-logs/*.log}"
  
  tail -f $log_path | fzf \
    --no-sort \
    --tac \
    --preview 'echo {}' \
    --preview-window right:60%:wrap \
    --header 'Tailing: '"$log_path"' | Ctrl-C to exit'
}

# ----------------------------------------------------------------------------
# Environment Variables
# ----------------------------------------------------------------------------
export PATH="$PATH:/Users/L100061/Library/Application Support/JetBrains/Toolbox/scripts"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="$PATH:$HOME/bin"

export XDG_CONFIG_HOME="$HOME/.config"
export EDITOR="vim"

# ----------------------------------------------------------------------------
# Aliases
# ----------------------------------------------------------------------------

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Quick CDs
alias d='cd ~/Development'

# Git
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gb='git branch'
alias glog='git log --oneline --graph --decorate'

# NVM - Manual version switching
alias nvmuse='nvm use'

# History
alias h='history'

# List files
alias ezsh='vim ~/.zshrc'
alias szsh='source ~/.zshrc'
alias ls='ls --color=auto'  # Use 'ls -G' on macOS if not using GNU ls
alias ll='ls -lah'
alias la='ls -A'

# Helpful function shortcuts
alias lv='logview'

# ----------------------------------------------------------------------------
# Prompt (Starship)
# ----------------------------------------------------------------------------
eval "$(starship init zsh)"
