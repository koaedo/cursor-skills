#!/bin/bash

# Cursor Skills Installer for Mac/Linux
# Usage:
#   ./install-skills.sh           # 기본: 스킬별로 물어봄
#   ./install-skills.sh --force   # 모두 덮어쓰기
#   ./install-skills.sh --skip    # 기존 스킬 모두 건너뛰기

set -e

# ============================================
# Configuration
# ============================================
CURSOR_DIR="$HOME/.cursor"
SKILLS_DIR="$CURSOR_DIR/skills-cursor"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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
    print_color "  Cursor Skills Installer" "$CYAN"
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
    local skillname="$1"
    
    if [ "$FORCE" = true ]; then echo "overwrite"; return; fi
    if [ "$SKIP" = true ]; then echo "skip"; return; fi
    
    print_color "[?] Skill '$skillname' already exists. What to do?" "$YELLOW"
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
SOURCE_SKILLS="$SCRIPT_DIR/skills"

if [ ! -d "$SOURCE_SKILLS" ]; then
    print_color "[!] Skills folder not found: $SOURCE_SKILLS" "$RED"
    print_color "[i] Make sure you're running this from the repository root" "$YELLOW"
    exit 1
fi

# Ensure directories exist
ensure_directory "$CURSOR_DIR"
ensure_directory "$SKILLS_DIR"

# Install skills
print_color "[*] Installing Skills..." "$YELLOW"
print_color "[i] Source: $SOURCE_SKILLS" "$CYAN"
print_color "[i] Target: $SKILLS_DIR" "$CYAN"
echo ""

INSTALLED_COUNT=0
SKIPPED_COUNT=0

for skill_dir in "$SOURCE_SKILLS"/*/; do
    [ -d "$skill_dir" ] || continue
    
    skill_name=$(basename "$skill_dir")
    target_path="$SKILLS_DIR/$skill_name"
    
    if [ -d "$target_path" ]; then
        choice=$(get_user_choice "$skill_name")
        
        if [ "$choice" = "skip" ]; then
            print_color "[-] Skipped: $skill_name" "$GRAY"
            ((SKIPPED_COUNT++)) || true
            continue
        fi
        
        rm -rf "$target_path"
    fi
    
    cp -r "$skill_dir" "$target_path"
    print_color "[+] Installed: $skill_name" "$GREEN"
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
print_color "    Installed: $INSTALLED_COUNT skills" "$GREEN"
print_color "    Skipped:   $SKIPPED_COUNT skills" "$GRAY"
echo "    Location:  $SKILLS_DIR"
echo ""

# List installed skills
print_color "[i] Installed skills:" "$CYAN"
for skill in "$SKILLS_DIR"/*/; do
    [ -d "$skill" ] || continue
    echo "    - $(basename "$skill")"
done
echo ""

print_color "[i] Usage options:" "$CYAN"
echo "    --force, -f  : Overwrite all existing skills"
echo "    --skip, -s   : Skip all existing skills"
echo ""
