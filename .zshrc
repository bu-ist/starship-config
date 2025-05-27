# ~/.zshrc - BU IST Optimized Zsh Configuration
# Optimized for PHP, JavaScript, Python development and server management

# ============================================================================
# PERFORMANCE OPTIMIZATIONS
# ============================================================================

# Disable unnecessary features for speed
DISABLE_AUTO_UPDATE="true"
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_COMPFIX="true"

# Cache completions aggressively - only rebuild once per day
autoload -Uz compinit
cache_file="$HOME/.zcompdump"
if [[ -n "$cache_file"(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

# ============================================================================
# HISTORY CONFIGURATION
# ============================================================================

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# History options for better management
setopt HIST_SAVE_NO_DUPS     # Don't save duplicate commands
setopt INC_APPEND_HISTORY    # Append to history immediately
setopt HIST_FIND_NO_DUPS     # Don't show duplicates when searching
setopt HIST_REDUCE_BLANKS    # Remove extra blanks from commands
setopt EXTENDED_HISTORY      # Save timestamp and duration
setopt HIST_VERIFY           # Show command before executing from history

# ============================================================================
# DIRECTORY AND NAVIGATION
# ============================================================================

# Auto change directory without typing cd
setopt AUTO_CD

# Directory stack configuration
setopt AUTO_PUSHD            # Automatically push directories to stack
setopt PUSHD_IGNORE_DUPS     # Don't push duplicates
setopt PUSHD_SILENT          # Don't print directory stack

# Better globbing
setopt EXTENDED_GLOB         # Enable extended globbing
setopt NULL_GLOB             # Don't error on no matches

# ============================================================================
# KEY BINDINGS
# ============================================================================

# Emacs-style key bindings (more familiar for most users)
bindkey -e

# Use up/down arrows for history search based on current input
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

# Ctrl+R for reverse history search (enhanced by fzf if available)
bindkey "^R" history-incremental-search-backward

# Alt+. to insert last argument
bindkey "^[." insert-last-word

# ============================================================================
# TERMINAL TITLE
# ============================================================================

# Set terminal title to current directory
function precmd() {
    print -Pn "\e]2;%~\a"
}

# ============================================================================
# ALIASES - OPTIMIZED FOR BU IST WORKFLOWS
# ============================================================================

# File operations
alias ls='ls --color=auto -h'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lsa='ls -lah'

# Directory operations
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'  # Go to previous directory

# Grep with color
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Network tools (useful for server management)
alias ip='ip -c=auto'
alias ping='ping -c 5'
alias ports='netstat -tuln'
alias myip='curl -s ifconfig.me'

# System information
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias top='htop'
alias ps='ps aux'

# Safe operations
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ln='ln -i'

# Development shortcuts
alias g='git'
alias v='vim'
alias e='nano'
alias c='code'

# Git shortcuts (common workflows)
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'

# PHP/Composer shortcuts
alias composer='php -d memory_limit=-1 /usr/local/bin/composer'
alias art='php artisan'
alias phpunit='./vendor/bin/phpunit'

# Node/NPM shortcuts
alias nr='npm run'
alias ni='npm install'
alias nid='npm install --save-dev'
alias nig='npm install -g'

# Python shortcuts
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv'

# Quick config edits
alias zshconfig='code ~/.zshrc'
alias zshreload='source ~/.zshrc && echo "ZSH config reloaded!"'
alias starconfig='code ~/.config/starship.toml'

# System shortcuts
alias ports='lsof -i -P -n | grep LISTEN'
alias cleanup='brew cleanup && npm cache clean --force'

# ============================================================================
# FUNCTIONS - USEFUL UTILITIES
# ============================================================================

# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract various archive formats
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Quick server for current directory
serve() {
    local port="${1:-8000}"
    python3 -m http.server "$port"
}

# Find process by name
psgrep() {
    ps aux | grep -v grep | grep "$1"
}

# ============================================================================
# EXTERNAL TOOLS INTEGRATION
# ============================================================================

# Homebrew path (for Apple Silicon Macs)
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# FZF integration (if installed)
if command -v fzf >/dev/null 2>&1; then
    # Key bindings for fzf
    if [[ -f ~/.fzf.zsh ]]; then
        source ~/.fzf.zsh
    elif [[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]]; then
        source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
        source /opt/homebrew/opt/fzf/shell/completion.zsh
    fi

    # Better fzf defaults
    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --ansi'
    export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range=:50 {}'"
    export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -100'"
fi

# Zoxide integration (if installed) - smarter cd
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
    alias cd='z'
fi

# ============================================================================
# DEVELOPMENT ENVIRONMENT MANAGERS
# ============================================================================

# Node.js version manager (nvm)
export NVM_DIR="$HOME/.nvm"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    # Lazy load nvm for faster shell startup
    nvm() {
        unset -f nvm
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
        nvm "$@"
    }
fi

# PHP version manager (phpbrew) - if using multiple PHP versions
if [[ -f ~/.phpbrew/bashrc ]]; then
    source ~/.phpbrew/bashrc
fi

# Python version manager (pyenv)
if command -v pyenv >/dev/null 2>&1; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi

# ============================================================================
# COMPLETION ENHANCEMENTS
# ============================================================================

# Better completion display
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

# Better completion for kill command
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
        clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
        gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
        ldap lp mail mailman mailnull man messagebus mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
        operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
        usbmux uucp vcsa wwwrun xfs '_*'

# ============================================================================
# STARSHIP PROMPT
# ============================================================================

if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
else
    echo "⚠️  Starship not found. Install with: brew install starship"
    # Fallback to simple prompt
    PROMPT='%F{green}%n@%m%f %F{blue}%~%f %# '
fi

# ============================================================================
# LOCAL CUSTOMIZATIONS
# ============================================================================

# Source local customizations if they exist
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Print startup message with useful info
echo "🚀 BU IST Zsh Environment Loaded"
echo "📁 Current directory: $(pwd)"
if command -v starship >/dev/null 2>&1; then
    echo "⭐ Starship prompt active"
fi
if command -v git >/dev/null 2>&1 && git rev-parse --git-dir >/dev/null 2>&1; then
    echo "🌱 Git repository: $(git branch --show-current 2>/dev/null || echo 'unknown branch')"
fi