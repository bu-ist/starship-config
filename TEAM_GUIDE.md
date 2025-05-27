# Starship Configuration Guide

Technical documentation for terminal prompt configuration using Starship.

## Overview

Starship is a cross-shell prompt written in Rust that provides context-aware terminal prompts. This configuration optimizes display for PHP, JavaScript, and Python development environments.

## Architecture

### Core Components

- **Starship Binary**: Rust-based prompt generator
- **Configuration File**: TOML-based settings (`~/.config/starship.toml`)
- **Shell Integration**: Initialization in shell RC files
- **Font Support**: Nerd Fonts for symbol rendering

### Module System

Starship uses modules to display information. Each module:

- Detects context (files, environment, git status)
- Renders appropriate output
- Applies styling and formatting
- Executes within timeout constraints

## Installation

### Prerequisites

- Terminal with Unicode support
- Nerd Font (JetBrains Mono recommended)
- Shell: Bash, Zsh, Fish, or PowerShell

### System Installation

**macOS:**

```bash
brew install starship
```

**Linux:**

```bash
curl -sS https://starship.rs/install.sh | sh
```

**Windows:**

```powershell
winget install --id Starship.Starship
```

### Configuration Setup

```bash
mkdir -p ~/.config
curl -fsSL https://raw.githubusercontent.com/bu-ist/starship-config/main/starship.toml \
  -o ~/.config/starship.toml
```

### Shell Integration

**Zsh (`~/.zshrc`):**

```bash
eval "$(starship init zsh)"
```

**Bash (`~/.bashrc`):**

```bash
eval "$(starship init bash)"
```

**Fish (`~/.config/fish/config.fish`):**

```fish
starship init fish | source
```

## Configuration Details

### Module Configuration

#### Directory Module

```toml
[directory]
truncation_length = 3
truncate_to_repo = false
style = "bold blue"
format = "[$path]($style)[$read_only]($read_only_style) "

[directory.substitutions]
"Documents" = "📄"
"Downloads" = "📥"
"repos" = "📁"
```

#### Git Modules

```toml
[git_branch]
symbol = "🌱 "
format = "on [$symbol$branch]($style) "
style = "bold purple"
truncation_length = 20

[git_status]
format = '([\[$all_status$ahead_behind\]]($style) )'
conflicted = "⚡"
ahead = "⇡${count}"
behind = "⇣${count}"
untracked = "?${count}"
modified = "!${count}"
staged = "+${count}"
deleted = "✘${count}"
ignore_submodules = true
```

#### Language Detection

```toml
[nodejs]
format = "via [⬢ $version](bold green) "
detect_files = ["package.json", ".nvmrc", "node_modules"]
version_format = "v${major}.${minor}.${patch}"

[php]
format = "via [🐘 $version](147 bold) "
detect_files = ["composer.json", ".php-version", "artisan", "wp-config.php"]

[python]
format = 'via [🐍 $version](yellow bold) '
detect_files = ["requirements.txt", ".python-version", "pyproject.toml", "manage.py"]
```

### Performance Optimizations

#### Disabled Modules

```toml
[ruby]
disabled = true
[rust]
disabled = true
[golang]
disabled = true
[java]
disabled = true
```

#### Timeout Configuration

```toml
command_timeout = 2000  # 2 seconds
```

#### Git Performance

```toml
[git_status]
ignore_submodules = true
```

### Context Detection

#### Cloud Providers

```toml
[aws]
format = 'on [☁️ ($profile )(\($region\) )]($style)'
detect_files = [
    'serverless.yml',
    'cloudformation.yml',
    '.aws-sam',
    'terraform.tf'
]
```

#### Container Context

```toml
[docker_context]
format = "via [🐳 $context](blue bold) "
only_with_files = true
detect_files = ["docker-compose.yml", "Dockerfile"]
```

## Shell Configuration

### Zsh Optimizations

#### History Management

```bash
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt HIST_SAVE_NO_DUPS
setopt INC_APPEND_HISTORY
setopt HIST_FIND_NO_DUPS
setopt EXTENDED_HISTORY
```

#### Completion System

```bash
autoload -Uz compinit
# Cache completions daily
cache_file="$HOME/.zcompdump"
if [[ -n "$cache_file"(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi
```

#### Directory Navigation

```bash
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
```

### Aliases

#### Development Shortcuts

```bash
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'

alias art='php artisan'
alias composer='php -d memory_limit=-1 /usr/local/bin/composer'

alias nr='npm run'
alias ni='npm install'
alias py='python3'
```

#### System Utilities

```bash
alias ll='ls -alF'
alias la='ls -A'
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'
alias ports='netstat -tuln'
```

## Font Configuration

### Installation

**macOS:**

```bash
brew tap homebrew/cask-fonts
brew install font-jetbrains-mono-nerd-font
```

**Linux:**

```bash
mkdir -p ~/.local/share/fonts
curl -fLo ~/.local/share/fonts/JetBrainsMono.ttf \
  https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip
fc-cache -fv
```

### Terminal Configuration

1. Set font to "JetBrains Mono Nerd Font"
2. Use 12pt or larger size
3. Enable Unicode/UTF-8 support
4. Test symbol rendering: `echo -e "\ue0b0 \u00b1 \ue0a0 \u27a6"`

## Performance Tuning

### Benchmarking

```bash
# Test prompt generation speed
time starship prompt

# Test individual modules
time starship module directory
time starship module git_status
time starship module nodejs
```

### Optimization Strategies

#### Large Repository Handling

```bash
# Git configuration
git config status.submodulesummary 0
git config diff.ignoreSubmodules dirty

# Starship configuration
[git_status]
ignore_submodules = true
```

#### Module Selection

- Disable unused language modules
- Use `detect_files` for smart activation
- Set appropriate timeouts

#### Memory Management

- Starship binary: ~3MB RAM
- Configuration parsing: <1MB
- Module execution: Variable based on context

## Troubleshooting

### Symbol Display Issues

**Problem:** Symbols appear as boxes or question marks

**Diagnosis:**

```bash
# Check font installation
fc-list | grep -i nerd
fc-list | grep -i jetbrains

# Test symbol rendering
echo -e "\ue0b0 \ue0b1 \ue0b2 \ue0b3"
```

**Solutions:**

1. Install Nerd Font
2. Configure terminal font settings
3. Verify Unicode support

### Performance Issues

**Problem:** Slow prompt generation (>100ms)

**Diagnosis:**

```bash
# Measure performance
time starship prompt

# Check repository size
du -sh .git

# Profile modules
starship timings
```

**Solutions:**

1. Increase timeout: `command_timeout = 5000`
2. Disable problematic modules
3. Optimize Git configuration
4. Use `.gitignore` effectively

### Configuration Problems

**Problem:** Configuration changes not applied

**Diagnosis:**

```bash
# Verify file location
ls -la ~/.config/starship.toml
echo $STARSHIP_CONFIG

# Validate TOML syntax
starship config

# Test specific modules
starship module git_branch
```

**Solutions:**

1. Check file path and permissions
2. Validate TOML syntax
3. Restart shell session
4. Clear shell cache

### Git Integration Issues

**Problem:** Git information not displaying

**Diagnosis:**

```bash
# Verify Git repository
git status
git rev-parse --git-dir

# Test Git modules
starship module git_branch
starship module git_status
```

**Solutions:**

1. Ensure valid Git repository
2. Check module configuration
3. Verify Git installation
4. Test with simple repository

## Integration Tools

### FZF (Fuzzy Finder)

```bash
# Installation
brew install fzf  # macOS
apt install fzf   # Linux

# Configuration
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always {}'"
```

### Zoxide (Smart cd)

```bash
# Installation
brew install zoxide  # macOS
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

# Integration
eval "$(zoxide init zsh)"
alias cd='z'
```

### Additional Tools

```bash
# Better cat
brew install bat

# Better ls
brew install exa

# Better top
brew install htop

# Better grep
brew install ripgrep
```

## Testing and Validation

### Automated Testing

```bash
#!/bin/bash
# test-config.sh

echo "Testing Starship installation..."
starship --version || exit 1

echo "Testing configuration..."
starship config || exit 1

echo "Testing modules..."
starship module character
starship module directory
starship module git_branch

echo "Performance test..."
time starship prompt

echo "All tests passed"
```

### Manual Verification

1. Navigate to Git repository - verify branch display
2. Change to project directory - verify language detection
3. Run long command - verify duration display
4. Trigger error - verify error indication
5. Test in various directory depths - verify truncation

## Maintenance

### Configuration Updates

```bash
# Backup current configuration
cp ~/.config/starship.toml ~/.config/starship.toml.backup

# Update configuration
curl -fsSL https://raw.githubusercontent.com/bu-ist/starship-config/main/starship.toml \
  -o ~/.config/starship.toml

# Test new configuration
starship config
```

### Version Management

```bash
# Check Starship version
starship --version

# Update Starship
brew upgrade starship  # macOS
curl -sS https://starship.rs/install.sh | sh  # Linux
```

### Monitoring

- Monitor prompt generation time
- Track memory usage
- Review module effectiveness
- Collect user feedback

## Reference

### Configuration Files

- `starship.toml`: Main configuration
- `.zshrc`: Shell configuration
- `install.sh`: Installation automation
- Font files: Symbol rendering

### Environment Variables

- `STARSHIP_CONFIG`: Configuration file path
- `STARSHIP_CACHE`: Cache directory location

### Command Reference

```bash
starship --version          # Show version
starship config            # Validate configuration
starship module <name>     # Test specific module
starship explain           # Show configuration explanation
starship timings          # Show performance metrics
starship bug-report       # Generate bug report
```

### External Resources

- **Starship Documentation**: https://starship.rs/
- **Configuration Reference**: https://starship.rs/config/
- **Module Documentation**: https://starship.rs/config/#modules
- **Nerd Fonts**: https://nerdfonts.com/

## Installation Guide

### Automated Installation (Recommended)

```bash
# One-command installation
curl -fsSL https://raw.githubusercontent.com/bu-ist/starship-config/main/install.sh | bash
```

### Manual Installation

#### Step 1: Install Starship

**macOS:**

```bash
brew install starship
```

**Linux:**

```bash
curl -sS https://starship.rs/install.sh | sh
```

**Windows:**

```powershell
winget install --id Starship.Starship
```

#### Step 2: Install Nerd Font

**macOS:**

```bash
brew tap homebrew/cask-fonts
brew install font-jetbrains-mono-nerd-font
```

**Linux:**

```bash
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -fLo "JetBrains Mono Nerd Font Complete.ttf" \
  https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/JetBrainsMono/Ligatures/Regular/complete/JetBrains%20Mono%20Regular%20Nerd%20Font%20Complete.ttf
fc-cache -fv
```

#### Step 3: Install Configuration

```bash
# Download BU IST configuration
curl -fsSL https://raw.githubusercontent.com/bu-ist/starship-config/main/starship.toml \
  -o ~/.config/starship.toml

# Configure shell initialization
echo 'eval "$(starship init zsh)"' >> ~/.zshrc
source ~/.zshrc
```

### Verification

```bash
# Test installation
starship --version
echo $STARSHIP_CONFIG

# Test prompt functionality
cd /path/to/git/repository
# Should show git branch and status
```

## Configuration Details

### Optimized Modules

Our configuration enables these modules with performance optimizations:

#### Core Information

- **Directory**: Smart truncation, substitutions for common paths
- **Git Branch**: Branch name with truncation for long names
- **Git Status**: Comprehensive status with performance optimizations
- **Character**: Success/error indication with color coding

#### Development Context

- **Node.js**: Version display when package.json detected
- **PHP**: Version display when composer.json detected
- **Python**: Version display when requirements.txt detected
- **Docker**: Context when Docker files detected

#### Infrastructure Context

- **AWS**: Profile and region when AWS files detected
- **Kubernetes**: Context when K8s files detected
- **Command Duration**: Execution time for commands >1 second

### Performance Optimizations

#### Disabled Modules

We've disabled unused language modules to improve performance:

```toml
[ruby]
disabled = true
[rust]
disabled = true
[golang]
disabled = true
[java]
disabled = true
```

#### Git Optimizations

```toml
[git_status]
ignore_submodules = true  # Faster in large repos
```

#### Smart Detection

```toml
[aws]
# Only show when working with AWS files
detect_files = ['serverless.yml', 'cloudformation.yml', '.aws-sam']
```

### Configuration Architecture

```
~/.config/starship.toml
├── General Settings (timeout, newlines)
├── Prompt Format (order of modules)
├── Character Configuration (success/error symbols)
├── Directory Settings (truncation, substitutions)
├── Git Configuration (branch, status, performance)
├── Language Detection (PHP, Node.js, Python)
├── Cloud Context (AWS, K8s)
├── System Information (duration, hostname)
└── Disabled Modules (unused languages)
```

## Team Rollout Plan

### Phase 1: Preparation (Week 1)

**Objectives:**

- Validate configuration with pilot group
- Prepare documentation and training materials
- Set up support channels

**Activities:**

- [ ] Test configuration on representative development environments
- [ ] Create internal documentation wiki pages
- [ ] Set up #dev-tools Slack channel for support
- [ ] Prepare FAQ document
- [ ] Schedule team demo session

**Success Criteria:**

- Configuration works on all target platforms (macOS, Linux)
- No performance issues identified
- Documentation reviewed by team leads

### Phase 2: Pilot Implementation (Week 2)

**Objectives:**

- Roll out to 3-4 volunteer developers
- Gather feedback and iterate
- Identify edge cases and compatibility issues

**Activities:**

- [ ] Install on pilot systems using automation script
- [ ] Collect usage feedback via survey
- [ ] Monitor for performance or compatibility issues
- [ ] Refine configuration based on feedback
- [ ] Update documentation with learnings

**Success Criteria:**

- Pilot users report positive experience
- No blocking issues identified
- Performance meets expectations (<50ms prompt generation)

### Phase 3: Team Rollout (Week 3)

**Objectives:**

- Deploy to entire development team
- Provide support and training
- Ensure consistent adoption

**Activities:**

- [ ] Send team announcement with installation instructions
- [ ] Host team demo/training session
- [ ] Provide 1-on-1 support for installation issues
- [ ] Update onboarding documentation
- [ ] Monitor adoption rates and gather feedback

**Success Criteria:**

- 90% of team successfully installed and using configuration
- Support requests handled within 24 hours
- Positive team feedback on productivity improvements

### Phase 4: Optimization and Maintenance (Week 4)

**Objectives:**

- Fine-tune configuration based on usage patterns
- Establish ongoing maintenance procedures
- Plan for future improvements

**Activities:**

- [ ] Analyze usage patterns and performance metrics
- [ ] Implement requested customizations
- [ ] Document maintenance procedures
- [ ] Plan quarterly review process
- [ ] Create feedback collection mechanism

**Success Criteria:**

- Team satisfied with final configuration
- Maintenance procedures documented
- Feedback process established

## Troubleshooting

### Common Issues and Solutions

#### Symbols Not Displaying Correctly

**Problem:** Seeing boxes, question marks, or broken symbols
**Symptoms:**

```
□ ~/project on □ main [!2 +1] via □ v18.0.0
```

**Solutions:**

1. **Install Nerd Font:**

   ```bash
   # macOS
   brew install font-jetbrains-mono-nerd-font

   # Linux
   ./fonts/install-fonts.sh
   ```

2. **Configure Terminal:**

   - Set terminal font to "JetBrains Mono Nerd Font"
   - Ensure font size is 12pt or larger
   - Enable Unicode support in terminal settings

3. **Verify Font Installation:**
   ```bash
   # Test font rendering
   echo -e "\ue0b0 \u00b1 \ue0a0 \u27a6 \u2718 \u26a1 \u2699"
   ```

#### Slow Prompt Performance

**Problem:** Noticeable delay when pressing Enter
**Symptoms:** >100ms delay between command and new prompt

**Solutions:**

1. **Check Repository Size:**

   ```bash
   # Large repos can slow git status
   du -sh .git
   ```

2. **Increase Timeout:**

   ```toml
   # ~/.config/starship.toml
   command_timeout = 5000
   ```

3. **Disable Git Status Temporarily:**

   ```toml
   [git_status]
   disabled = true
   ```

4. **Optimize Git Configuration:**
   ```bash
   # Speed up git status in large repos
   git config status.submodulesummary 0
   git config diff.ignoreSubmodules dirty
   ```

#### Configuration Not Loading

**Problem:** Changes to starship.toml not appearing
**Symptoms:** Prompt unchanged after configuration edits

**Solutions:**

1. **Verify File Location:**

   ```bash
   ls -la ~/.config/starship.toml
   echo $STARSHIP_CONFIG
   ```

2. **Check TOML Syntax:**

   ```bash
   starship config
   ```

3. **Restart Shell:**

   ```bash
   source ~/.zshrc
   # or restart terminal
   ```

4. **Debug Configuration:**
   ```bash
   starship explain
   ```

#### Git Information Not Showing

**Problem:** Git branch/status not displayed in git repositories
**Symptoms:** Missing git information in known repositories

**Solutions:**

1. **Verify Git Repository:**

   ```bash
   git status
   git rev-parse --git-dir
   ```

2. **Check Git Module Configuration:**

   ```toml
   [git_branch]
   disabled = false

   [git_status]
   disabled = false
   ```

3. **Test Git Detection:**
   ```bash
   starship module git_branch
   starship module git_status
   ```

### Platform-Specific Issues

#### macOS Issues

**Homebrew Path Issues:**

```bash
# Add to ~/.zshrc
eval "$(/opt/homebrew/bin/brew shellenv)"
```

**Font Installation Issues:**

```bash
# Manual font installation
open ~/Downloads/JetBrainsMono.zip
# Drag fonts to Font Book
```

#### Linux Issues

**Font Cache Issues:**

```bash
fc-cache -fv
fc-list | grep -i jetbrains
```

**Permission Issues:**

```bash
# Ensure config directory exists
mkdir -p ~/.config
chmod 755 ~/.config
```

#### WSL/Windows Issues

**Path Issues:**

```bash
# Ensure Windows paths don't interfere
export PATH="/usr/local/bin:/usr/bin:/bin:$PATH"
```

**Unicode Support:**

- Enable UTF-8 support in Windows Terminal
- Use Windows Terminal or WSL2 for best experience

### Performance Debugging

#### Measuring Prompt Performance

```bash
# Benchmark prompt generation
time starship prompt

# Detailed timing
starship timings
```

#### Profiling Module Performance

```bash
# Test individual modules
time starship module directory
time starship module git_status
time starship module nodejs
```

#### Optimizing Large Repositories

```bash
# Skip untracked files in status
git config status.showUntrackedFiles no

# Use sparse checkout for large repos
git config core.sparseCheckout true
```

## Best Practices

### Team Standardization

#### Configuration Management

1. **Version Control**: Keep team configuration in Git repository
2. **Branching Strategy**: Use feature branches for configuration changes
3. **Code Review**: Require review for team configuration updates
4. **Testing**: Test changes on multiple platforms before deployment

#### Documentation Standards

1. **Change Log**: Document all configuration changes
2. **Migration Guides**: Provide upgrade instructions
3. **Troubleshooting**: Maintain known issues database
4. **Training Materials**: Keep setup guides current

### Development Workflow Integration

#### Git Workflow Optimization

```toml
# Optimize for team's git workflow
[git_status]
format = '([\[$all_status$ahead_behind\]]($style) )'
ahead = "⇡${count}"
behind = "⇣${count}"
diverged = "⇕⇡${ahead_count}⇣${behind_count}"
```

#### Environment-Specific Configuration

```toml
# Show relevant contexts for team projects
[nodejs]
detect_files = ["package.json", ".nvmrc"]

[php]
detect_files = ["composer.json", "artisan", "wp-config.php"]

[python]
detect_files = ["requirements.txt", "manage.py", "pyproject.toml"]
```

### Security Considerations

#### Sensitive Information

- Never display API keys or secrets in prompt
- Be cautious with AWS profile information in shared screens
- Consider hiding hostname in certain environments

#### Access Control

```toml
# Limit AWS information display
[aws]
format = 'on [☁️ $region]($style) '  # Hide profile names
```

### Performance Best Practices

#### Module Selection

- Only enable modules relevant to team's tech stack
- Disable unused language detectors
- Use smart detection with `detect_files`

#### Git Repository Optimization

- Use `.gitignore` effectively to reduce file count
- Consider `git config status.showUntrackedFiles no` for large repos
- Use Git LFS for large binary files

### Customization Guidelines

#### Personal vs Team Configuration

1. **Team Standard**: Use shared configuration as base
2. **Personal Additions**: Layer personal customizations on top
3. **Sharing**: Contribute useful customizations back to team
4. **Documentation**: Document personal modifications

#### Configuration Hierarchy

```bash
# Team configuration
~/.config/starship.toml

# Personal overrides (if needed)
export STARSHIP_CONFIG=~/.config/starship-personal.toml
```

## Performance Metrics

### Benchmark Results

Based on team testing across various development environments:

#### Prompt Generation Speed

- **BU IST Configuration**: 15-25ms average
- **Oh My Zsh (default)**: 150-250ms average
- **Powerlevel10k**: 20-40ms average
- **Basic shell prompt**: 5-10ms average

#### Memory Usage

- **Starship binary**: ~2-3MB RAM
- **Configuration loading**: <1MB additional
- **Total overhead**: <5MB per terminal session

#### Startup Time Impact

- **Additional shell startup time**: 10-20ms
- **Configuration parsing**: 5-10ms -**Module initialization**: 5-15ms

### Performance Testing Methodology

#### Test Environment

- **Hardware**: MacBook Pro M1, 16GB RAM
- **Repositories**: Various sizes (small: <100 files, large: >10,000 files)
- **Network**: Local development (no remote Git operations)

#### Benchmarking Script

```bash
#!/bin/bash
# Performance testing script

echo "Testing prompt performance..."
for i in {1..10}; do
    time starship prompt >/dev/null
done

echo "Testing individual modules..."
time starship module directory
time starship module git_status
time starship module nodejs
```

### Scaling Considerations

#### Large Repository Performance

- Git repositories >10,000 files: 30-50ms prompt generation
- Repositories with many submodules: Consider `ignore_submodules = true`
- Repositories with large histories: Performance remains consistent

#### Team Size Scaling

- Configuration management complexity increases with team size
- Support overhead scales linearly with team size
- Standardization benefits increase with team size

## References

### Official Documentation

- **Starship Website**: https://starship.rs/
- **Configuration Guide**: https://starship.rs/config/
- **Installation Instructions**: https://starship.rs/guide/
- **Advanced Configuration**: https://starship.rs/advanced-config/

### Community Resources

- **GitHub Repository**: https://github.com/starship/starship
- **Community Discussions**: https://github.com/starship/starship/discussions
- **Configuration Examples**: https://github.com/starship/starship/discussions/1107
- **Preset Configurations**: https://starship.rs/presets/

### Font Resources

- **Nerd Fonts Website**: https://nerdfonts.com/
- **JetBrains Mono**: https://jetbrains.com/mono/
- **Installation Guide**: https://github.com/ryanoasis/nerd-fonts#font-installation
- **Font Preview**: https://www.programmingfonts.org/

### Performance Resources

- **Benchmark Tools**: https://github.com/romkatv/zsh-prompt-benchmark
- **Performance Discussion**: https://github.com/starship/starship/discussions/580
- **Optimization Guide**: https://starship.rs/faq/#starship-is-slow

### Related Tools

- **fzf (Fuzzy Finder)**: https://github.com/junegunn/fzf
- **zoxide (Smart cd)**: https://github.com/ajeetdsouza/zoxide
- **bat (Better cat)**: https://github.com/sharkdp/bat
- **exa (Better ls)**: https://github.com/ogham/exa

### BU IST Resources

- **Slack Channel**: #dev-tools
- **Configuration Repository**: https://github.com/bu-ist/starship-config
- **Issue Tracking**: https://github.com/bu-ist/starship-config/issues

### Training Resources

- **Terminal Basics**: https://missing.csail.mit.edu/2020/shell-tools/
- **Zsh Guide**: https://zsh.sourceforge.io/Guide/
- **Git Integration**: https://git-scm.com/book/en/v2/Appendix-A%3A-Git-in-Other-Environments-Git-in-Zsh
