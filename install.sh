#!/bin/bash
# BU IST Starship Configuration Installation Script
# Automated setup for the team's optimized terminal configuration

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO_URL="https://raw.githubusercontent.com/bu-ist/starship-config/main"
BACKUP_DIR="$HOME/.bu-ist-backup-$(date +%Y%m%d_%H%M%S)"

# Helper functions
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detect operating system
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        OS="windows"
    else
        OS="unknown"
    fi
    print_status "Detected OS: $OS"
}

# Create backup directory
create_backup() {
    print_status "Creating backup directory: $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"

    # Backup existing configurations
    [[ -f ~/.zshrc ]] && cp ~/.zshrc "$BACKUP_DIR/zshrc.backup"
    [[ -f ~/.config/starship.toml ]] && cp ~/.config/starship.toml "$BACKUP_DIR/starship.toml.backup"

    print_success "Backup created at $BACKUP_DIR"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Starship
install_starship() {
    if command_exists starship; then
        print_success "Starship already installed"
        starship --version
        return
    fi

    print_status "Installing Starship..."

    case $OS in
        "macos")
            if command_exists brew; then
                brew install starship
            else
                print_warning "Homebrew not found. Installing via script..."
                curl -sS https://starship.rs/install.sh | sh
            fi
            ;;
        "linux")
            # Try package managers first
            if command_exists apt; then
                print_status "Attempting installation via apt..."
                if ! sudo apt update && sudo apt install -y starship 2>/dev/null; then
                    print_warning "Package manager installation failed. Using script..."
                    curl -sS https://starship.rs/install.sh | sh
                fi
            elif command_exists yum; then
                print_status "Attempting installation via yum..."
                if ! sudo yum install -y starship 2>/dev/null; then
                    curl -sS https://starship.rs/install.sh | sh
                fi
            elif command_exists pacman; then
                print_status "Attempting installation via pacman..."
                if ! sudo pacman -S starship 2>/dev/null; then
                    curl -sS https://starship.rs/install.sh | sh
                fi
            else
                print_status "Using universal installer..."
                curl -sS https://starship.rs/install.sh | sh
            fi
            ;;
        *)
            print_status "Using universal installer..."
            curl -sS https://starship.rs/install.sh | sh
            ;;
    esac

    if command_exists starship; then
        print_success "Starship installed successfully"
        starship --version
    else
        print_error "Starship installation failed"
        exit 1
    fi
}

# Install Nerd Font
install_nerd_font() {
    print_status "Checking for Nerd Font..."

    case $OS in
        "macos")
            if command_exists brew; then
                print_status "Installing JetBrains Mono Nerd Font..."
                brew tap homebrew/cask-fonts 2>/dev/null || true
                brew install font-jetbrains-mono-nerd-font 2>/dev/null || print_warning "Font may already be installed"
                print_success "Font installation completed"
            else
                print_warning "Homebrew not found. Please install JetBrains Mono Nerd Font manually from:"
                echo "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip"
            fi
            ;;
        "linux")
            print_status "Installing JetBrains Mono Nerd Font..."
            mkdir -p ~/.local/share/fonts
            cd ~/.local/share/fonts
            if curl -fLo "JetBrains Mono Nerd Font Complete.ttf" \
                https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/JetBrainsMono/Ligatures/Regular/complete/JetBrains%20Mono%20Regular%20Nerd%20Font%20Complete.ttf; then
                fc-cache -fv
                print_success "Font installed successfully"
            else
                print_warning "Font download failed. Please install manually."
            fi
            ;;
        *)
            print_warning "Please install a Nerd Font manually:"
            echo "https://www.nerdfonts.com/font-downloads"
            ;;
    esac
}

# Install additional tools
install_tools() {
    print_status "Installing additional productivity tools..."

    case $OS in
        "macos")
            if command_exists brew; then
                print_status "Installing fzf, zoxide, and other tools..."
                brew install fzf zoxide bat exa htop 2>/dev/null || print_warning "Some tools may already be installed"

                # Install fzf key bindings
                if [[ -f /opt/homebrew/opt/fzf/install ]]; then
                    /opt/homebrew/opt/fzf/install --key-bindings --completion --no-update-rc
                elif [[ -f /usr/local/opt/fzf/install ]]; then
                    /usr/local/opt/fzf/install --key-bindings --completion --no-update-rc
                fi

                print_success "Additional tools installed"
            fi
            ;;
        "linux")
            if command_exists apt; then
                sudo apt update
                sudo apt install -y fzf bat htop 2>/dev/null || true

                # Install zoxide
                if ! command_exists zoxide; then
                    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
                fi

                # Install exa
                if ! command_exists exa; then
                    if command_exists cargo; then
                        cargo install exa
                    fi
                fi
            fi
            ;;
    esac
}

# Download and install configurations
install_configs() {
    print_status "Installing BU IST configurations..."

    # Create config directory
    mkdir -p ~/.config

    # Download Starship configuration
    if curl -fsSL "$REPO_URL/starship.toml" -o ~/.config/starship.toml; then
        print_success "Starship configuration installed"
    else
        print_error "Failed to download Starship configuration"
        exit 1
    fi

    # Download optimized .zshrc
    if curl -fsSL "$REPO_URL/.zshrc" -o ~/.zshrc.bu-ist; then
        print_success "Zsh configuration downloaded"

        # Ask user if they want to replace their .zshrc
        if [[ -f ~/.zshrc ]]; then
            echo
            print_warning "Existing .zshrc found. Choose an option:"
            echo "1) Replace with BU IST configuration (recommended)"
            echo "2) Append BU IST configuration to existing"
            echo "3) Skip .zshrc installation (manual setup required)"
            read -p "Enter choice (1-3): " choice

            case $choice in
                1)
                    mv ~/.zshrc.bu-ist ~/.zshrc
                    print_success "Replaced .zshrc with BU IST configuration"
                    ;;
                2)
                    echo "" >> ~/.zshrc
                    echo "# BU IST Configuration" >> ~/.zshrc
                    cat ~/.zshrc.bu-ist >> ~/.zshrc
                    rm ~/.zshrc.bu-ist
                    print_success "Appended BU IST configuration to existing .zshrc"
                    ;;
                3)
                    print_warning "Skipped .zshrc installation. Manual setup required."
                    print_status "BU IST .zshrc saved as ~/.zshrc.bu-ist"
                    ;;
            esac
        else
            mv ~/.zshrc.bu-ist ~/.zshrc
            print_success "Installed BU IST .zshrc configuration"
        fi
    else
        print_error "Failed to download .zshrc configuration"
    fi
}

# Configure shell
configure_shell() {
    print_status "Configuring shell integration..."

    # Check if starship init is already in shell config
    if ! grep -q "starship init" ~/.zshrc 2>/dev/null; then
        echo "" >> ~/.zshrc
        echo "# Initialize Starship prompt" >> ~/.zshrc
        echo 'eval "$(starship init zsh)"' >> ~/.zshrc
        print_success "Added Starship initialization to .zshrc"
    else
        print_success "Starship initialization already configured"
    fi

    # Set zsh as default shell if not already
    if [[ "$SHELL" != *"zsh"* ]]; then
        print_status "Setting zsh as default shell..."
        if command_exists zsh; then
            chsh -s "$(which zsh)"
            print_success "Default shell changed to zsh"
            print_warning "Please restart your terminal for changes to take effect"
        else
            print_error "zsh not found. Please install zsh first."
        fi
    fi
}

# Verify installation
verify_installation() {
    print_status "Verifying installation..."

    local issues=0

    if ! command_exists starship; then
        print_error "Starship not found in PATH"
        ((issues++))
    fi

    if [[ ! -f ~/.config/starship.toml ]]; then
        print_error "Starship configuration not found"
        ((issues++))
    fi

    if [[ ! -f ~/.zshrc ]]; then
        print_error ".zshrc not found"
        ((issues++))
    fi

    if [[ $issues -eq 0 ]]; then
        print_success "Installation verification completed successfully!"
        return 0
    else
        print_error "Installation verification found $issues issue(s)"
        return 1
    fi
}

# Show post-installation instructions
show_instructions() {
    echo
    echo "=========================================="
    echo "🎉 BU IST Starship Configuration Installed"
    echo "=========================================="
    echo
    echo "Next steps:"
    echo "1. Restart your terminal or run: source ~/.zshrc"
    echo "2. Configure your terminal to use JetBrains Mono Nerd Font"
    echo "3. Enjoy your new optimized terminal experience!"
    echo
    echo "Configuration files:"
    echo "  • Starship: ~/.config/starship.toml"
    echo "  • Zsh: ~/.zshrc"
    echo "  • Backup: $BACKUP_DIR"
    echo
    echo "Resources:"
    echo "  • Team Guide: https://github.com/bu-ist/starship-config/blob/main/TEAM_GUIDE.md"
    echo "  • Issues: https://github.com/bu-ist/starship-config/issues"
    echo "  • Slack: #dev-tools"
    echo
    echo "Troubleshooting:"
    echo "  • If symbols don't display: Install and configure Nerd Font in terminal"
    echo "  • If slow performance: Check if in large Git repository"
    echo "  • For help: Open issue on GitHub or ask in #dev-tools Slack"
    echo
}

# Main installation function
main() {
    echo "🚀 BU IST Starship Configuration Installer"
    echo "=========================================="
    echo

    # Detect OS
    detect_os

    # Create backup
    create_backup

    # Install components
    install_starship
    install_nerd_font
    install_tools
    install_configs
    configure_shell

    # Verify and finish
    if verify_installation; then
        show_instructions
        exit 0
    else
        print_error "Installation completed with issues. Please check the output above."
        echo "Backup available at: $BACKUP_DIR"
        exit 1
    fi
}

# Run main function
main "$@"