# ============================================================
# Cursor MCP Install Script (Windows PowerShell)
# ============================================================
#
# Features:
#   - Skip already installed MCPs
#   - Install only missing MCPs
#   - Optional API-key MCPs with -All flag
#
# Usage:
#   .\windows_mcp_install.ps1              # Essential MCPs only
#   .\windows_mcp_install.ps1 -All         # All MCPs (API keys needed)
#   .\windows_mcp_install.ps1 -List        # Show installed MCPs
#
# ============================================================

param(
    [switch]$All,
    [switch]$List
)

$ErrorActionPreference = "Stop"

function Write-Color {
    param([string]$Text, [string]$Color = "White")
    Write-Host $Text -ForegroundColor $Color
}

function Write-Line {
    Write-Host "-----------------------------------------------------" -ForegroundColor DarkGray
}

# Banner
Write-Host ""
Write-Color "========================================================" "Cyan"
Write-Color "     Cursor MCP Install Script                          " "Cyan"
Write-Color "========================================================" "Cyan"
Write-Color "  [v] Skip already installed MCPs                       " "Cyan"
Write-Color "  [v] Install only missing MCPs                         " "Cyan"
Write-Color "========================================================" "Cyan"
Write-Host ""

# MCP Config path
$MCP_CONFIG = "$env:USERPROFILE\.cursor\mcp.json"

# ============================================================
# MCP Definitions (names match common Cursor conventions)
# ============================================================

# Essential MCPs (No API key needed)
$ESSENTIAL_MCPS = @{
    "Context7" = @{
        type = "url"
        url = "https://mcp.context7.com/mcp"
        description = "Library docs lookup"
        apiKey = $false
        aliases = @("context7", "Context-7")
    }
    "Sequential Thinking" = @{
        type = "command"
        command = "npx"
        args = @("-y", "@anthropic/mcp-sequential-thinking")
        description = "Step-by-step analysis"
        apiKey = $false
        aliases = @("Sequential-Thinking", "sequential-thinking", "SequentialThinking")
    }
    "Playwright" = @{
        type = "command"
        command = "npx"
        args = @("-y", "@anthropic/mcp-playwright")
        description = "Browser automation"
        apiKey = $false
        aliases = @("playwright", "MCP-Playwright")
    }
    "Memory" = @{
        type = "command"
        command = "npx"
        args = @("-y", "@modelcontextprotocol/server-memory")
        description = "Session memory"
        apiKey = $false
        aliases = @("memory", "MCP-Memory")
    }
}

# Recommended MCPs (API key needed)
$RECOMMENDED_MCPS = @{
    "Exa Search" = @{
        type = "command"
        command = "npx"
        args = @("-y", "exa-mcp-server")
        description = "Web search"
        apiKey = $true
        envVar = "EXA_API_KEY"
        getKeyUrl = "https://exa.ai"
        aliases = @("Exa-Search", "exa-search", "ExaSearch", "exa")
    }
    "GitHub" = @{
        type = "command"
        command = "npx"
        args = @("-y", "@anthropic/mcp-github")
        description = "GitHub integration"
        apiKey = $true
        envVar = "GITHUB_TOKEN"
        getKeyUrl = "https://github.com/settings/tokens"
        aliases = @("github", "MCP-GitHub")
    }
    "Notion" = @{
        type = "url"
        url = "https://mcp.notion.com/mcp"
        description = "Notion integration"
        apiKey = $true
        envVar = "NOTION_API_KEY"
        getKeyUrl = "https://www.notion.so/my-integrations"
        aliases = @("notion", "MCP-Notion")
    }
}

# ============================================================
# Functions
# ============================================================
function Get-ExistingMCPs {
    if (Test-Path $MCP_CONFIG) {
        try {
            $config = Get-Content $MCP_CONFIG -Raw -Encoding UTF8 | ConvertFrom-Json
            if ($config.mcpServers) {
                return $config.mcpServers.PSObject.Properties.Name
            }
        } catch {
            Write-Color "   [!] Failed to parse existing config" "Yellow"
        }
    }
    return @()
}

function Get-MCPConfig {
    if (Test-Path $MCP_CONFIG) {
        try {
            return Get-Content $MCP_CONFIG -Raw -Encoding UTF8 | ConvertFrom-Json
        } catch {
            return [PSCustomObject]@{ mcpServers = [PSCustomObject]@{} }
        }
    }
    return [PSCustomObject]@{ mcpServers = [PSCustomObject]@{} }
}

# Improved matching: check name + aliases (case-insensitive, ignore spaces/hyphens)
function Test-MCPInstalled {
    param(
        [string]$MCPName,
        [array]$Aliases,
        [array]$ExistingMCPs
    )
    
    # Normalize function: lowercase, remove spaces/hyphens
    $normalize = { param($s) $s.ToLower() -replace '[\s\-_]', '' }
    
    $normalizedName = & $normalize $MCPName
    $normalizedAliases = @($normalizedName)
    if ($Aliases) {
        $normalizedAliases += $Aliases | ForEach-Object { & $normalize $_ }
    }
    
    foreach ($existing in $ExistingMCPs) {
        $normalizedExisting = & $normalize $existing
        
        # Check exact match or alias match
        foreach ($alias in $normalizedAliases) {
            if ($normalizedExisting -eq $alias) {
                return $true
            }
            # Also check contains (for partial matches like "exa" in "Exa Search")
            if ($normalizedExisting.Contains($alias) -or $alias.Contains($normalizedExisting)) {
                return $true
            }
        }
    }
    return $false
}

# ============================================================
# List Mode
# ============================================================
if ($List) {
    Write-Color "[*] Currently installed MCPs:" "Cyan"
    Write-Line
    
    $existingMCPs = Get-ExistingMCPs
    if ($existingMCPs.Count -eq 0) {
        Write-Color "   (No MCPs installed)" "Gray"
    } else {
        foreach ($mcp in $existingMCPs) {
            Write-Color "   [v] $mcp" "Green"
        }
    }
    
    Write-Host ""
    Write-Line
    Write-Color "[*] Available MCPs:" "Cyan"
    Write-Host ""
    
    Write-Color "   [Essential] (No API key):" "White"
    foreach ($key in $ESSENTIAL_MCPS.Keys) {
        $mcp = $ESSENTIAL_MCPS[$key]
        $isInstalled = Test-MCPInstalled -MCPName $key -Aliases $mcp.aliases -ExistingMCPs $existingMCPs
        $status = if ($isInstalled) { "[v]" } else { "[ ]" }
        Write-Color "      $status $key - $($mcp.description)" "Gray"
    }
    
    Write-Host ""
    Write-Color "   [Recommended] (API key needed):" "White"
    foreach ($key in $RECOMMENDED_MCPS.Keys) {
        $mcp = $RECOMMENDED_MCPS[$key]
        $isInstalled = Test-MCPInstalled -MCPName $key -Aliases $mcp.aliases -ExistingMCPs $existingMCPs
        $status = if ($isInstalled) { "[v]" } else { "[ ]" }
        Write-Color "      $status $key - $($mcp.description) (ENV: $($mcp.envVar))" "Gray"
    }
    
    Write-Host ""
    exit 0
}

# ============================================================
# Installation
# ============================================================
Write-Color "[*] Config file: $MCP_CONFIG" "Gray"
Write-Line

# Get existing MCPs
$existingMCPs = Get-ExistingMCPs
Write-Color "[*] Currently installed: $($existingMCPs.Count) MCPs" "Cyan"
foreach ($mcp in $existingMCPs) {
    Write-Color "   [v] $mcp" "Green"
}
Write-Line

# Load config
$config = Get-MCPConfig

# Ensure mcpServers exists
if (-not $config.mcpServers) {
    $config | Add-Member -NotePropertyName "mcpServers" -NotePropertyValue ([PSCustomObject]@{}) -Force
}

$installed = 0
$skipped = 0

# ============================================================
# Install Essential MCPs
# ============================================================
Write-Color "[Essential] Installing (No API key)..." "Cyan"

foreach ($key in $ESSENTIAL_MCPS.Keys) {
    $mcp = $ESSENTIAL_MCPS[$key]
    
    # Check if already installed (improved matching with aliases)
    $isInstalled = Test-MCPInstalled -MCPName $key -Aliases $mcp.aliases -ExistingMCPs $existingMCPs
    
    if ($isInstalled) {
        Write-Color "   [skip] $key - Already installed" "Gray"
        $skipped++
        continue
    }
    
    # Create new MCP config
    $newMCP = @{}
    if ($mcp.type -eq "url") {
        $newMCP = [PSCustomObject]@{
            url = $mcp.url
            headers = @{}
        }
    } else {
        $newMCP = [PSCustomObject]@{
            command = $mcp.command
            args = $mcp.args
        }
    }
    
    $config.mcpServers | Add-Member -NotePropertyName $key -NotePropertyValue $newMCP -Force
    Write-Color "   [+] $key - Added ($($mcp.description))" "Green"
    $installed++
}

Write-Line

# ============================================================
# Install Recommended MCPs (with -All flag)
# ============================================================
if ($All) {
    Write-Color "[Recommended] Installing (API key needed)..." "Cyan"
    Write-Color "   [!] MCPs without API keys may not work" "Yellow"
    
    foreach ($key in $RECOMMENDED_MCPS.Keys) {
        $mcp = $RECOMMENDED_MCPS[$key]
        
        # Check if already installed (improved matching with aliases)
        $isInstalled = Test-MCPInstalled -MCPName $key -Aliases $mcp.aliases -ExistingMCPs $existingMCPs
        
        if ($isInstalled) {
            Write-Color "   [skip] $key - Already installed" "Gray"
            $skipped++
            continue
        }
        
        # Create new MCP config
        $newMCP = @{}
        if ($mcp.type -eq "url") {
            $newMCP = [PSCustomObject]@{
                url = $mcp.url
                headers = @{}
            }
        } else {
            $newMCP = [PSCustomObject]@{
                command = $mcp.command
                args = $mcp.args
            }
        }
        
        $config.mcpServers | Add-Member -NotePropertyName $key -NotePropertyValue $newMCP -Force
        Write-Color "   [+] $key - Added (ENV: $($mcp.envVar))" "Green"
        $installed++
    }
    
    Write-Line
}

# ============================================================
# Save Config
# ============================================================
if ($installed -gt 0) {
    Write-Color "[*] Saving config..." "Cyan"
    
    # Create ~/.cursor folder if needed
    $cursorDir = Split-Path $MCP_CONFIG -Parent
    if (-not (Test-Path $cursorDir)) {
        New-Item -ItemType Directory -Path $cursorDir -Force | Out-Null
    }
    
    # Save JSON
    $config | ConvertTo-Json -Depth 10 | Set-Content $MCP_CONFIG -Encoding UTF8
    Write-Color "   [v] Saved: $MCP_CONFIG" "Green"
}

Write-Line

# ============================================================
# Done
# ============================================================
Write-Host ""
Write-Color "========================================================" "Green"
Write-Color "     MCP Installation Complete!                         " "Green"
Write-Color "========================================================" "Green"
Write-Host ""

Write-Color "[*] Result:" "White"
Write-Color "   [+] Installed: $installed" "Green"
Write-Color "   [skip] Skipped: $skipped" "Gray"

Write-Host ""
Write-Color "[*] Next steps:" "White"
Write-Color "   1. Restart Cursor" "Gray"

if ($All) {
    Write-Host ""
    Write-Color "[!] API keys needed for:" "Yellow"
    foreach ($key in $RECOMMENDED_MCPS.Keys) {
        $mcp = $RECOMMENDED_MCPS[$key]
        Write-Color "   - $key : $($mcp.envVar)" "Gray"
    }
    Write-Host ""
    Write-Color "   Set env var:" "White"
    Write-Color '   [System.Environment]::SetEnvironmentVariable("KEY", "value", "User")' "DarkGray"
} else {
    Write-Host ""
    Write-Color "[*] To install recommended MCPs:" "White"
    Write-Color "   .\windows_mcp_install.ps1 -All" "Gray"
}

Write-Host ""
Write-Color "[*] Guide: _COMMAND_LIBRARY/mcp-command.md" "Gray"
Write-Host ""
