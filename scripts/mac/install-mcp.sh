#!/bin/bash
# ============================================================
# Cursor MCP Install Script (Mac/Linux)
# ============================================================
#
# Features:
#   - Skip already installed MCPs
#   - Install only missing MCPs
#   - Optional API-key MCPs with --all flag
#
# Usage:
#   ./scripts/mac/install-mcp.sh              # Essential MCPs only
#   ./scripts/mac/install-mcp.sh --all        # All MCPs (API keys needed)
#   ./scripts/mac/install-mcp.sh --list       # Show installed MCPs
#
# ============================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
GRAY='\033[0;90m'
WHITE='\033[0;37m'
NC='\033[0m'

# Options
ALL=false
LIST=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --all|-a)
            ALL=true
            shift
            ;;
        --list|-l)
            LIST=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# MCP config path
MCP_CONFIG="$HOME/.cursor/mcp.json"

# Banner
echo ""
echo -e "${CYAN}========================================================${NC}"
echo -e "${CYAN}     Cursor MCP Install Script                          ${NC}"
echo -e "${CYAN}========================================================${NC}"
echo -e "${CYAN}  [v] Skip already installed MCPs                       ${NC}"
echo -e "${CYAN}  [v] Install only missing MCPs                         ${NC}"
echo -e "${CYAN}========================================================${NC}"
echo ""

# Check jq (for JSON parsing)
if ! command -v jq &> /dev/null; then
    echo -e "${YELLOW}[!] jq not found. Installing...${NC}"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install jq
    else
        sudo apt-get install -y jq 2>/dev/null || sudo yum install -y jq 2>/dev/null
    fi
fi

# ============================================================
# Functions
# ============================================================
get_existing_mcps() {
    if [ -f "$MCP_CONFIG" ]; then
        jq -r '.mcpServers | keys[]' "$MCP_CONFIG" 2>/dev/null || echo ""
    fi
}

# Improved matching: normalize and compare (case-insensitive, ignore spaces/hyphens)
normalize_name() {
    echo "$1" | tr '[:upper:]' '[:lower:]' | tr -d ' -_'
}

is_mcp_installed() {
    local name=$1
    shift
    local aliases=("$@")
    
    local norm_name=$(normalize_name "$name")
    
    while IFS= read -r existing; do
        [ -z "$existing" ] && continue
        local norm_existing=$(normalize_name "$existing")
        
        # Check main name
        if [[ "$norm_existing" == "$norm_name" ]] || \
           [[ "$norm_existing" == *"$norm_name"* ]] || \
           [[ "$norm_name" == *"$norm_existing"* ]]; then
            return 0
        fi
        
        # Check aliases
        for alias in "${aliases[@]}"; do
            local norm_alias=$(normalize_name "$alias")
            if [[ "$norm_existing" == "$norm_alias" ]] || \
               [[ "$norm_existing" == *"$norm_alias"* ]] || \
               [[ "$norm_alias" == *"$norm_existing"* ]]; then
                return 0
            fi
        done
    done <<< "$existing_mcps"
    
    return 1
}

add_mcp() {
    local name=$1
    local config=$2
    
    local tmp=$(mktemp)
    jq ".mcpServers.\"$name\" = $config" "$MCP_CONFIG" > "$tmp" && mv "$tmp" "$MCP_CONFIG"
}

# ============================================================
# List Mode
# ============================================================
if [ "$LIST" = true ]; then
    echo -e "${CYAN}[*] Currently installed MCPs:${NC}"
    echo "-----------------------------------------------------"
    
    existing=$(get_existing_mcps)
    if [ -z "$existing" ]; then
        echo -e "   ${GRAY}(No MCPs installed)${NC}"
    else
        echo "$existing" | while read -r mcp; do
            [ -n "$mcp" ] && echo -e "   ${GREEN}[v] $mcp${NC}"
        done
    fi
    
    echo ""
    echo "-----------------------------------------------------"
    echo -e "${CYAN}[*] Available MCPs:${NC}"
    echo ""
    
    echo -e "   ${WHITE}[Essential] (No API key):${NC}"
    echo -e "      ${GRAY}• Context7 - Library docs lookup${NC}"
    echo -e "      ${GRAY}• Sequential Thinking - Step-by-step analysis${NC}"
    echo -e "      ${GRAY}• Playwright - Browser automation${NC}"
    echo -e "      ${GRAY}• Memory - Session memory${NC}"
    echo ""
    
    echo -e "   ${WHITE}[Recommended] (API key needed):${NC}"
    echo -e "      ${GRAY}• Exa Search - Web search (EXA_API_KEY)${NC}"
    echo -e "      ${GRAY}• GitHub - GitHub integration (GITHUB_TOKEN)${NC}"
    echo -e "      ${GRAY}• Notion - Notion integration (NOTION_API_KEY)${NC}"
    echo ""
    exit 0
fi

# ============================================================
# Installation
# ============================================================
echo -e "${GRAY}[*] Config file: $MCP_CONFIG${NC}"
echo "-----------------------------------------------------"

# Create ~/.cursor folder
mkdir -p "$(dirname "$MCP_CONFIG")"

# Initialize if not exists
if [ ! -f "$MCP_CONFIG" ]; then
    echo '{"mcpServers":{}}' > "$MCP_CONFIG"
fi

existing_mcps=$(get_existing_mcps)
count=$(echo "$existing_mcps" | grep -c . 2>/dev/null || echo "0")
echo -e "${CYAN}[*] Currently installed: $count MCPs${NC}"
echo "$existing_mcps" | while read -r mcp; do
    [ -n "$mcp" ] && echo -e "   ${GREEN}[v] $mcp${NC}"
done
echo "-----------------------------------------------------"

installed=0
skipped=0

# ============================================================
# Essential MCPs (No API key)
# ============================================================
echo -e "${CYAN}[Essential] Installing (No API key)...${NC}"

# Context7
if is_mcp_installed "Context7" "context7" "Context-7"; then
    echo -e "   ${GRAY}[skip] Context7 - Already installed${NC}"
    ((skipped++)) || true
else
    add_mcp "Context7" '{"url":"https://mcp.context7.com/mcp","headers":{}}'
    echo -e "   ${GREEN}[+] Context7 - Added (Library docs)${NC}"
    ((installed++)) || true
fi

# Sequential Thinking
if is_mcp_installed "Sequential Thinking" "Sequential-Thinking" "sequential-thinking" "SequentialThinking"; then
    echo -e "   ${GRAY}[skip] Sequential Thinking - Already installed${NC}"
    ((skipped++)) || true
else
    add_mcp "Sequential Thinking" '{"command":"npx","args":["-y","@anthropic/mcp-sequential-thinking"]}'
    echo -e "   ${GREEN}[+] Sequential Thinking - Added (Step-by-step)${NC}"
    ((installed++)) || true
fi

# Playwright
if is_mcp_installed "Playwright" "playwright" "MCP-Playwright"; then
    echo -e "   ${GRAY}[skip] Playwright - Already installed${NC}"
    ((skipped++)) || true
else
    add_mcp "Playwright" '{"command":"npx","args":["-y","@anthropic/mcp-playwright"]}'
    echo -e "   ${GREEN}[+] Playwright - Added (Browser automation)${NC}"
    ((installed++)) || true
fi

# Memory
if is_mcp_installed "Memory" "memory" "MCP-Memory"; then
    echo -e "   ${GRAY}[skip] Memory - Already installed${NC}"
    ((skipped++)) || true
else
    add_mcp "Memory" '{"command":"npx","args":["-y","@modelcontextprotocol/server-memory"]}'
    echo -e "   ${GREEN}[+] Memory - Added (Session memory)${NC}"
    ((installed++)) || true
fi

echo "-----------------------------------------------------"

# ============================================================
# Recommended MCPs (API key needed)
# ============================================================
if [ "$ALL" = true ]; then
    echo -e "${CYAN}[Recommended] Installing (API key needed)...${NC}"
    echo -e "   ${YELLOW}[!] MCPs without API keys may not work${NC}"
    
    # Exa Search
    if is_mcp_installed "Exa Search" "Exa-Search" "exa-search" "ExaSearch" "exa"; then
        echo -e "   ${GRAY}[skip] Exa Search - Already installed${NC}"
        ((skipped++)) || true
    else
        add_mcp "Exa Search" '{"command":"npx","args":["-y","exa-mcp-server"]}'
        echo -e "   ${GREEN}[+] Exa Search - Added (ENV: EXA_API_KEY)${NC}"
        ((installed++)) || true
    fi
    
    # GitHub
    if is_mcp_installed "GitHub" "github" "MCP-GitHub"; then
        echo -e "   ${GRAY}[skip] GitHub - Already installed${NC}"
        ((skipped++)) || true
    else
        add_mcp "GitHub" '{"command":"npx","args":["-y","@anthropic/mcp-github"]}'
        echo -e "   ${GREEN}[+] GitHub - Added (ENV: GITHUB_TOKEN)${NC}"
        ((installed++)) || true
    fi
    
    # Notion
    if is_mcp_installed "Notion" "notion" "MCP-Notion"; then
        echo -e "   ${GRAY}[skip] Notion - Already installed${NC}"
        ((skipped++)) || true
    else
        add_mcp "Notion" '{"url":"https://mcp.notion.com/mcp","headers":{}}'
        echo -e "   ${GREEN}[+] Notion - Added (ENV: NOTION_API_KEY)${NC}"
        ((installed++)) || true
    fi
    
    echo "-----------------------------------------------------"
fi

# ============================================================
# Done
# ============================================================
echo ""
echo -e "${GREEN}========================================================${NC}"
echo -e "${GREEN}     MCP Installation Complete!                         ${NC}"
echo -e "${GREEN}========================================================${NC}"
echo ""

echo -e "[*] Result:"
echo -e "   ${GREEN}[+] Installed: $installed${NC}"
echo -e "   ${GRAY}[skip] Skipped: $skipped${NC}"

echo ""
echo -e "[*] Next steps:"
echo -e "   ${GRAY}1. Restart Cursor${NC}"

if [ "$ALL" = true ]; then
    echo ""
    echo -e "${YELLOW}[!] API keys needed:${NC}"
    echo -e "   • Exa Search: export EXA_API_KEY=\"your_key\""
    echo -e "   • GitHub: export GITHUB_TOKEN=\"your_token\""
    echo -e "   • Notion: export NOTION_API_KEY=\"your_key\""
else
    echo ""
    echo -e "[*] To install recommended MCPs:"
    echo -e "   ${GRAY}./scripts/mac/install-mcp.sh --all${NC}"
fi

echo ""
echo -e "${GRAY}[*] Guide: commands/mcp-command.md${NC}"
echo ""
