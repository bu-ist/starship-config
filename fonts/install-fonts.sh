#!/bin/bash
# Font installation script for Starship configuration

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
else
    OS="unknown"
fi

print_status "Detected OS: $OS"

install_fonts_macos() {
    print_status "Installing fonts for macOS..."

    if command -v brew >/dev/null 2>&1; then
        print_status "Using Homebrew to install fonts..."
        brew tap homebrew/cask-fonts 2>/dev/null || true

        # Install multiple Nerd Font options
        fonts=(
            "font-jetbrains-mono-nerd-font"
            "font-fira-code-nerd-font"
            "font-hack-nerd-font"
            "font-meslo-lg-nerd-font"
        )

        for font in "${fonts[@]}"; do
            print_status "Installing $font..."
            brew install "$font" 2>/dev/null || print_warning "$font may already be installed"
        done

        print_success "Fonts installed via Homebrew"
    else
        print_warning "Homebrew not found. Installing manually..."
        install_fonts_manual
    fi
}

install_fonts_linux() {
    print_status "Installing fonts for Linux..."

    # Create fonts directory
    mkdir -p ~/.local/share/fonts
    cd ~/.local/share/fonts

    # Download JetBrains Mono Nerd Font
    print_status "Downloading JetBrains Mono Nerd Font..."
    if curl -fLo "JetBrainsMono.zip" \
        "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip"; then

        unzip -o JetBrainsMono.zip
        rm JetBrainsMono.zip

        # Download Fira Code Nerd Font
        print_status "Downloading Fira Code Nerd Font..."
        curl -fLo "FiraCode.zip" \
            "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip"
        unzip -o FiraCode.zip
        rm FiraCode.zip

        # Download Hack Nerd Font
        print_status "Downloading Hack Nerd Font..."
        curl -fLo "Hack.zip" \
            "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Hack.zip"
        unzip -o Hack.zip
        rm Hack.zip

        # Refresh font cache
        print_status "Refreshing font cache..."
        fc-cache -fv

        print_success "Fonts installed successfully"
    else
        print_error "Failed to download fonts"
        return 1
    fi
}

install_fonts_manual() {
    print_warning "Manual installation required"
    echo
    echo "Please download and install Nerd Fonts manually:"
    echo "1. Visit: https://github.com/ryanoasis/nerd-fonts/releases"
    echo "2. Download: JetBrainsMono.zip"
    echo "3. Extract and install fonts to your system"
    echo
    echo "Recommended fonts:"
    echo "- JetBrains Mono Nerd Font"
    echo "- Fira Code Nerd Font"
    echo "- Hack Nerd Font"
    echo "- Meslo LG Nerd Font"
}

test_font_rendering() {
    print_status "Testing font rendering..."
    echo "Symbol test: "
    echo -e "  Git branch: \ue0a0"
    echo -e "  Folder: \uf115"
    echo -e "  Node.js: \ue718"
    echo -e "  PHP: \ue73d"
    echo -e "  Python: \ue73c"
    echo -e "  Docker: \uf308"
    echo -e "  AWS: \uf270"
    echo -e "  Arrow: \ue0b0"
    echo
    echo "If you see boxes or question marks, the font is not properly configured."
}

show_terminal_instructions() {
    print_status "Terminal configuration instructions:"
    echo

    case $OS in
        "macos")
            echo "For iTerm2:"
            echo "1. Open iTerm2 > Preferences > Profiles > Text"
            echo "2. Set Font to 'JetBrainsMono Nerd Font'"
            echo "3. Set size to 12pt or larger"
            echo
            echo "For Terminal.app:"
            echo "1. Open Terminal > Preferences > Profiles > Text"
            echo "2. Click 'Change' next to Font"
            echo "3. Select 'JetBrainsMono Nerd Font'"
            echo "4. Set size to 12pt or larger"
            ;;
        "linux")
            echo "For GNOME Terminal:"
            echo "1. Open Terminal > Preferences > Profiles"
            echo "2. Select your profile > Text"
            echo "3. Uncheck 'Use system fixed width font'"
            echo "4. Set font to 'JetBrainsMono Nerd Font'"
            echo
            echo "For other terminals:"
            echo "1. Look for Font/Text settings"
            echo "2. Set font to 'JetBrainsMono Nerd Font'"
            echo "3. Ensure size is 12pt or larger"
            ;;
    esac

    echo
    echo "After configuring:"
    echo "1. Restart your terminal"
    echo "2. Run: starship config"
    echo "3. Test with: echo -e '\\ue0a0 \\uf115 \\ue718'"
}

main() {
    echo "🔤 Nerd Font Installation for Starship"
    echo "======================================"
    echo

    case $OS in
        "macos")
            install_fonts_macos
            ;;
        "linux")
            install_fonts_linux
            ;;
        *)
            install_fonts_manual
            ;;
    esac

    echo
    test_font_rendering
    echo
    show_terminal_instructions

    print_success "Font installation completed!"
    print_status "Remember to configure your terminal to use the installed Nerd Font"
}

main "$@"