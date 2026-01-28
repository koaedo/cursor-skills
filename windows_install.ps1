# ============================================================
# Cursor Skills Install Script (Windows PowerShell)
# ============================================================
#
# What gets installed:
#   1. MDC Rules (includes user rules) -> ~/.cursor/rules/
#   2. Command Library -> ~/.cursor/_COMMAND_LIBRARY/
#
# Usage:
#   .\windows_install.ps1           # Full install (recommended)
#   .\windows_install.ps1 -Project  # Install to current project only
#   .\windows_install.ps1 -NoBackup # Skip backup
#
# MCP Setup:
#   MCP must be configured separately.
#   Guide: _COMMAND_LIBRARY/mcp-command.md
#
# ============================================================

param(
    [switch]$Project,   # Install to project only
    [switch]$NoBackup   # Skip backup
)

$ErrorActionPreference = "Stop"

# Color output function
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
Write-Color "     [*] Cursor Skills Install Script                   " "Cyan"
Write-Color "========================================================" "Cyan"
Write-Color "  [+] MDC Rules (includes user rules)                   " "Cyan"
Write-Color "  [+] Command Library                                   " "Cyan"
Write-Color "========================================================" "Cyan"
Write-Host ""

# Path setup
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$CURSOR_DIR = "$env:USERPROFILE\.cursor"
$CURSOR_RULES_DIR = "$CURSOR_DIR\rules"
$CURSOR_CMD_DIR = "$CURSOR_DIR\_COMMAND_LIBRARY"
$TIMESTAMP = Get-Date -Format "yyyyMMdd_HHmmss"
$BACKUP_DIR = "$CURSOR_DIR\_backup_$TIMESTAMP"

Write-Color "[i] Source: $SCRIPT_DIR" "Gray"
Write-Color "[i] Target: $CURSOR_DIR" "Gray"
Write-Line

# ============================================================
# 1. Backup (if existing settings exist)
# ============================================================
if (-not $NoBackup) {
    $needBackup = $false
    if (Test-Path $CURSOR_RULES_DIR) { $needBackup = $true }
    if (Test-Path $CURSOR_CMD_DIR) { $needBackup = $true }
    
    if ($needBackup) {
        Write-Color "[*] Backing up existing settings..." "Yellow"
        New-Item -ItemType Directory -Path $BACKUP_DIR -Force | Out-Null
        
        if (Test-Path $CURSOR_RULES_DIR) {
            Copy-Item -Path $CURSOR_RULES_DIR -Destination "$BACKUP_DIR\rules" -Recurse -Force
            Write-Color "   [+] rules/ backup complete" "Green"
        }
        if (Test-Path $CURSOR_CMD_DIR) {
            Copy-Item -Path $CURSOR_CMD_DIR -Destination "$BACKUP_DIR\_COMMAND_LIBRARY" -Recurse -Force
            Write-Color "   [+] _COMMAND_LIBRARY/ backup complete" "Green"
        }
        Write-Color "   [i] Backup location: $BACKUP_DIR" "Gray"
    } else {
        Write-Color "   [i] No existing settings (skipping backup)" "Gray"
    }
    Write-Line
}

# ============================================================
# 2. Install MDC Rules
# ============================================================
if ($Project) {
    $TARGET_RULES = "$(Get-Location)\.cursor\rules"
    $TARGET_CMD = "$(Get-Location)\_COMMAND_LIBRARY"
    Write-Color "[*] Project install mode" "Cyan"
} else {
    $TARGET_RULES = $CURSOR_RULES_DIR
    $TARGET_CMD = $CURSOR_CMD_DIR
    Write-Color "[*] Global install mode" "Cyan"
}

Write-Color "[*] Installing MDC rules..." "Cyan"
New-Item -ItemType Directory -Path $TARGET_RULES -Force | Out-Null

$SOURCE_RULES = "$SCRIPT_DIR\.cursor\rules"
if (Test-Path $SOURCE_RULES) {
    Get-ChildItem -Path $SOURCE_RULES -Directory | ForEach-Object {
        $folderName = $_.Name
        $destPath = "$TARGET_RULES\$folderName"
        
        New-Item -ItemType Directory -Path $destPath -Force | Out-Null
        Copy-Item -Path "$($_.FullName)\*" -Destination $destPath -Recurse -Force
        
        $fileCount = (Get-ChildItem -Path $destPath -Filter "*.mdc" -File -Recurse).Count
        Write-Color "   [+] $folderName/ ($fileCount files)" "Green"
    }
} else {
    Write-Color "   [!] Source rules folder not found" "Yellow"
}
Write-Line

# ============================================================
# 3. Install Command Library
# ============================================================
Write-Color "[*] Installing command library..." "Cyan"
New-Item -ItemType Directory -Path $TARGET_CMD -Force | Out-Null

$SOURCE_CMD = "$SCRIPT_DIR\_COMMAND_LIBRARY"
if (Test-Path $SOURCE_CMD) {
    Copy-Item -Path "$SOURCE_CMD\*" -Destination $TARGET_CMD -Recurse -Force
    $cmdCount = (Get-ChildItem -Path $TARGET_CMD -Filter "*.md" -File).Count
    Write-Color "   [+] Command library ($cmdCount files)" "Green"
} else {
    Write-Color "   [!] Source command library not found" "Yellow"
}
Write-Line

# ============================================================
# 4. Completion Message
# ============================================================
Write-Host ""
Write-Color "========================================================" "Green"
Write-Color "              [+] Installation Complete!                " "Green"
Write-Color "========================================================" "Green"
Write-Host ""

Write-Color "[i] Installed locations:" "White"
Write-Color "   - MDC Rules: $TARGET_RULES" "Gray"
Write-Color "   - Command Library: $TARGET_CMD" "Gray"
if (-not $NoBackup -and (Test-Path $BACKUP_DIR)) {
    Write-Color "   - Backup: $BACKUP_DIR" "Gray"
}

Write-Host ""
Write-Color "[i] Next steps:" "White"
Write-Color "   1. Restart Cursor (to apply rules)" "Gray"
Write-Color "   2. Configure MCP (guide: _COMMAND_LIBRARY/mcp-command.md)" "Gray"
Write-Color "   3. Clear old user rules (Settings > Rules > clear content)" "Gray"
Write-Host ""

# ============================================================
# 5. Installed Rules Summary
# ============================================================
Write-Line
Write-Color "[i] Installed content summary:" "Cyan"

# MDC Rules
Write-Color "" "White"
Write-Color "   MDC Rules:" "White"
$categories = @{
    "00-core" = "Core rules (always apply)"
    "10-language" = "Language rules (by file type)"
    "20-skills" = "Skills (manual/@mention)"
    "30-project" = "Project rules"
}

foreach ($cat in $categories.Keys | Sort-Object) {
    $catPath = "$TARGET_RULES\$cat"
    if (Test-Path $catPath) {
        $files = Get-ChildItem -Path $catPath -Filter "*.mdc" -File
        Write-Color "      $cat/ - $($categories[$cat])" "White"
        foreach ($file in $files) {
            Write-Color "         - $($file.BaseName)" "DarkGray"
        }
    }
}

# Command Library
Write-Color "" "White"
Write-Color "   Command Library:" "White"
if (Test-Path $TARGET_CMD) {
    Get-ChildItem -Path $TARGET_CMD -Filter "*.md" -File | ForEach-Object {
        Write-Color "      - $($_.BaseName)" "DarkGray"
    }
}

Write-Host ""
Write-Color "[+] All settings complete!" "Green"
Write-Color "    You can now work with the same environment on any computer." "Gray"
Write-Host ""
