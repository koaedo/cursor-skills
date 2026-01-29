#!/bin/bash

# Cursor Command Library Installer for Mac/Linux
# Usage:
#   ./scripts/mac/install-commands.sh           # 기본: 파일별로 물어봄
#   ./scripts/mac/install-commands.sh --force   # 모두 덮어쓰기
#   ./scripts/mac/install-commands.sh --skip    # 기존 파일 모두 건너뛰기

set -e

# ============================================
# Configuration
# ============================================
CURSOR_DIR="$HOME/.cursor"
COMMANDS_DIR="$CURSOR_DIR/_COMMAND_LIBRARY"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
GRAY='\033[0;90m'
NC='\033[0m'

# Options
FORCE=false
SKIP=false

# ============================================
# Helper Functions
# ============================================
print_color() {
    echo -e "${2}${1}${NC}"
}

print_header() {
    echo ""
    print_color "============================================" "$CYAN"
    print_color "  Cursor Command Library Installer" "$CYAN"
    print_color "============================================" "$CYAN"
    echo ""
}

ensure_directory() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
        print_color "[+] Created directory: $1" "$GREEN"
    fi
}

get_user_choice() {
    local filename="$1"
    
    if [ "$FORCE" = true ]; then echo "overwrite"; return; fi
    if [ "$SKIP" = true ]; then echo "skip"; return; fi
    
    print_color "[?] '$filename' already exists. What to do?" "$YELLOW"
    echo "    [O] Overwrite  [S] Skip  [A] Overwrite All  [N] Skip All"
    read -p "    Choice (O/S/A/N): " -n 1 -r
    echo
    
    case "${REPLY^^}" in
        O) echo "overwrite" ;;
        S) echo "skip" ;;
        A) FORCE=true; echo "overwrite" ;;
        N) SKIP=true; echo "skip" ;;
        *) echo "skip" ;;
    esac
}

# ============================================
# Parse Arguments
# ============================================
while [[ $# -gt 0 ]]; do
    case $1 in
        --force|-f)
            FORCE=true
            shift
            ;;
        --skip|-s)
            SKIP=true
            shift
            ;;
        *)
            shift
            ;;
    esac
done

# ============================================
# Main Installation
# ============================================
print_header

# Check source directory exists
SOURCE_COMMANDS="$ROOT_DIR/commands"

if [ ! -d "$SOURCE_COMMANDS" ]; then
    print_color "[!] Commands folder not found: $SOURCE_COMMANDS" "$RED"
    print_color "[i] Make sure you're running this from the repository root" "$YELLOW"
    exit 1
fi

# Ensure directories exist
ensure_directory "$CURSOR_DIR"
ensure_directory "$COMMANDS_DIR"

# Install command files
print_color "[*] Installing Command Library..." "$YELLOW"
print_color "[i] Source: $SOURCE_COMMANDS" "$CYAN"
print_color "[i] Target: $COMMANDS_DIR" "$CYAN"
echo ""

INSTALLED_COUNT=0
SKIPPED_COUNT=0

for file in "$SOURCE_COMMANDS"/*.md; do
    [ -e "$file" ] || continue
    
    filename=$(basename "$file")
    target_path="$COMMANDS_DIR/$filename"
    
    if [ -f "$target_path" ]; then
        choice=$(get_user_choice "$filename")
        
        if [ "$choice" = "skip" ]; then
            print_color "[-] Skipped: $filename" "$GRAY"
            ((SKIPPED_COUNT++)) || true
            continue
        fi
    fi
    
    cp "$file" "$target_path"
    print_color "[+] Installed: $filename" "$GREEN"
    ((INSTALLED_COUNT++)) || true
done

# ============================================
# Summary
# ============================================
echo ""
print_color "============================================" "$CYAN"
print_color "  Installation Complete!" "$GREEN"
print_color "============================================" "$CYAN"
echo ""

print_color "[i] Summary:" "$YELLOW"
print_color "    Installed: $INSTALLED_COUNT files" "$GREEN"
print_color "    Skipped:   $SKIPPED_COUNT files" "$GRAY"
echo "    Location:  $COMMANDS_DIR"
echo ""

print_color "[i] Usage options:" "$CYAN"
echo "    --force, -f  : Overwrite all existing files"
echo "    --skip, -s   : Skip all existing files"
echo ""
