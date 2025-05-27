# BU IS&T Starship Configuration

Terminal prompt configuration for PHP, JavaScript, and Python development with server management tools.

## Overview

Starship is a cross-shell prompt written in Rust. This configuration provides context-aware information display with optimized performance.

## Display Format

```
~ via 🐘 v7.4.33 via ⬢ v23.11.0 via 🐍 v3.13.3 on ☁️  (us-east-1)
➤ cd repos/my-project

~/repos/my-project on 🌱 main [!2 +1] via 🐘 v8.1.0 via ⬢ v18.0.0
➤
```

**Elements:**

- 🐘 PHP version (when `composer.json` detected)
- ⬢ Node.js version (when `package.json` detected)
- 🐍 Python version (when `requirements.txt` detected)
- 🌱 Git branch with status (when in Git repository)
- ☁️ AWS context (when AWS files detected)
- ➤ Prompt indicator (green=success, red=error)

## 🚀 Quick Install

### Prerequisites

1. **Terminal with color support** (iTerm2, Terminal.app, Windows Terminal, etc.)
2. **Nerd Font** for proper symbol display (we recommend JetBrains Mono Nerd Font)

### Installation Script

```bash
# Download and run our installation script
curl -fsSL https://raw.githubusercontent.com/bu-ist/starship-config/blob/main/install.sh | bash
```

### Manual Installation

```bash
# 1. Install Starship
# macOS
brew install starship

# Linux
curl -sS https://starship.rs/install.sh | sh

# 2. Install our configuration
curl -fsSL https://raw.githubusercontent.com/bu-ist/starship-config/main/starship.toml -o ~/.config/starship.toml

# 3. Update your shell configuration
echo 'eval "$(starship init zsh)"' >> ~/.zshrc
source ~/.zshrc
```

## 📁 Repository Contents

```
starship-config/
├── README.md                    # This file
├── TEAM_GUIDE.md               # Comprehensive team documentation
├── install.sh                   # Automated installation script
├── starship.toml               # Optimized Starship configuration
├── .zshrc                      # Optimized Zsh configuration
├── fonts/                      # Recommended fonts
│   └── install-fonts.sh       # Font installation script
└── examples/                   # Configuration examples
    ├── minimal.toml            # Minimal configuration
    └── advanced.toml           # Advanced configuration
```

## ⚙️ Configuration Details

### Optimizations Applied

- **Performance**: Disabled unused language modules (Ruby, Rust, Go, etc.)
- **Git**: Optimized for large repositories with `ignore_submodules = true`
- **Command Duration**: Shows execution time for commands > 1 second
- **AWS Context**: Only shows when working with AWS-related files
- **Language Detection**: Optimized for our primary stack (PHP, Node.js, Python)

### Key Features

- **Directory Truncation**: Smart path display that adapts to terminal width
- **Git Status**: Comprehensive git information with performance optimizations
- **Cloud Context**: AWS region and profile information when relevant
- **Language Versions**: Automatic detection of PHP, Node.js, and Python versions
- **Docker Context**: Shows Docker context when working with containers

## 🎨 Customization

### Standard Configuration

The provided `starship.toml` is a standard configuration. It balances information density with performance and visual clarity.

### Personal Customizations

If you need personal modifications:

1. Copy `starship.toml` to `starship-personal.toml`
2. Make your changes
3. Use: `export STARSHIP_CONFIG=~/.config/starship-personal.toml`

### Common Customizations

```toml
# Hide AWS context entirely
[aws]
disabled = true

# Change prompt symbol
[character]
success_symbol = "[→](bold green)"
error_symbol = "[→](bold red)"

# Show more git information
[git_status]
format = '([\[$all_status$ahead_behind\]]($style) )'
```

## 🔧 Troubleshooting

### Symbols Not Displaying

**Problem**: Seeing boxes or question marks instead of symbols
**Solution**: Install a Nerd Font

```bash
# macOS
brew tap homebrew/cask-fonts
brew install font-jetbrains-mono-nerd-font

# Linux
./fonts/install-fonts.sh
```

### Slow Performance

**Problem**: Prompt feels sluggish
**Solutions**:

1. Check if you're in a very large Git repository
2. Increase command timeout: `command_timeout = 5000`
3. Disable git status temporarily: `[git_status] disabled = true`

### Configuration Not Loading

**Problem**: Changes not appearing
**Solutions**:

1. Verify file location: `~/.config/starship.toml`
2. Check TOML syntax: `starship config`
3. Restart terminal session

## 📚 Documentation

- **[TEAM_GUIDE.md](TEAM_GUIDE.md)**: Comprehensive guide for team leads and developers
- **[Starship Documentation](https://starship.rs/)**: Official Starship documentation
- **[Configuration Reference](https://starship.rs/config/)**: Complete configuration options
