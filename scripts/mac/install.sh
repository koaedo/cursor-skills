#!/bin/bash

# Cursor Skills & Commands Installer for Mac/Linux
# Usage:
#   ./scripts/mac/install.sh                    # 기본: 파일별로 물어봄
#   ./scripts/mac/install.sh --force            # 모두 덮어쓰기
#   ./scripts/mac/install.sh --skip-commands    # 커맨드 설치 건너뛰기
#   ./scripts/mac/install.sh --skip-skills      # 스킬 설치 건너뛰기

set -e

# ============================================
# Configuration
# ============================================
CURSOR_DIR="$HOME/.cursor"
COMMANDS_DIR="$CURSOR_DIR/_COMMAND_LIBRARY"
SKILLS_DIR="$CURSOR_DIR/skills-cursor"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ============================================
# Helper Functions
# ============================================
print_color() {
    echo -e "${2}${1}${NC}"
}

print_header() {
    echo ""
    print_color "============================================" "$CYAN"
    print_color "  Cursor Skills & Commands Installer" "$CYAN"
    print_color "============================================" "$CYAN"
    echo ""
}

ensure_directory() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
        print_color "[+] Created directory: $1" "$GREEN"
    fi
}

# ============================================
# Parse Arguments
# ============================================
SKIP_COMMANDS=false
SKIP_SKILLS=false
FORCE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --skip-commands)
            SKIP_COMMANDS=true
            shift
            ;;
        --skip-skills)
            SKIP_SKILLS=true
            shift
            ;;
        --force|-f)
            FORCE=true
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

# Check source directories exist
SOURCE_COMMANDS="$ROOT_DIR/commands"
SOURCE_SKILLS="$ROOT_DIR/skills"

if [ ! -d "$SOURCE_COMMANDS" ]; then
    print_color "[!] Commands folder not found: $SOURCE_COMMANDS" "$RED"
    print_color "[i] Make sure you're running this from the repository root" "$YELLOW"
    exit 1
fi

if [ ! -d "$SOURCE_SKILLS" ]; then
    print_color "[!] Skills folder not found: $SOURCE_SKILLS" "$RED"
    print_color "[i] Make sure you're running this from the repository root" "$YELLOW"
    exit 1
fi

# Ensure Cursor directory exists
ensure_directory "$CURSOR_DIR"

# ============================================
# Install Command Library
# ============================================
if [ "$SKIP_COMMANDS" = false ]; then
    print_color "[*] Installing Command Library..." "$YELLOW"
    
    if [ -d "$COMMANDS_DIR" ] && [ "$FORCE" = false ]; then
        print_color "[i] Command Library already exists at: $COMMANDS_DIR" "$CYAN"
        read -p "    Overwrite? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_color "[i] Skipping Command Library installation" "$YELLOW"
            SKIP_COMMANDS=true
        fi
    fi
    
    if [ "$SKIP_COMMANDS" = false ]; then
        # Remove existing and copy new
        rm -rf "$COMMANDS_DIR"
        cp -r "$SOURCE_COMMANDS" "$COMMANDS_DIR"
        
        COMMAND_COUNT=$(find "$COMMANDS_DIR" -name "*.md" | wc -l | tr -d ' ')
        print_color "[+] Installed $COMMAND_COUNT command files to: $COMMANDS_DIR" "$GREEN"
    fi
fi

# ============================================
# Install Skills
# ============================================
if [ "$SKIP_SKILLS" = false ]; then
    print_color "[*] Installing Skills..." "$YELLOW"
    
    ensure_directory "$SKILLS_DIR"
    
    INSTALLED_COUNT=0
    
    for skill_dir in "$SOURCE_SKILLS"/*/; do
        skill_name=$(basename "$skill_dir")
        target_path="$SKILLS_DIR/$skill_name"
        
        if [ -d "$target_path" ] && [ "$FORCE" = false ]; then
            print_color "[i] Skill '$skill_name' already exists" "$CYAN"
            continue
        fi
        
        rm -rf "$target_path"
        cp -r "$skill_dir" "$target_path"
        print_color "[+] Installed skill: $skill_name" "$GREEN"
        ((INSTALLED_COUNT++)) || true
    done
    
    print_color "[+] Installed $INSTALLED_COUNT skills to: $SKILLS_DIR" "$GREEN"
fi

# ============================================
# Summary
# ============================================
echo ""
print_color "============================================" "$CYAN"
print_color "  Installation Complete!" "$GREEN"
print_color "============================================" "$CYAN"
echo ""

print_color "[i] Installed locations:" "$YELLOW"
echo "    Commands: $COMMANDS_DIR"
echo "    Skills:   $SKILLS_DIR"
echo ""

print_color "[!] IMPORTANT: User Rules must be set manually" "$YELLOW"
echo "    1. Open file: user-rules/_combined.md"
echo "    2. Copy the entire content"
echo "    3. Paste into: Cursor Settings > Rules"
echo ""

print_color "[i] To install MCPs, run: ./scripts/mac/install-mcp.sh" "$CYAN"
echo ""
