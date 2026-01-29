# Cursor Command Library Installer for Windows
# Usage:
#   .\install-commands.ps1           # 기본: 파일별로 물어봄
#   .\install-commands.ps1 -Force    # 모두 덮어쓰기
#   .\install-commands.ps1 -Skip     # 기존 파일 모두 건너뛰기

param(
    [switch]$Force,     # 기존 파일 모두 덮어쓰기
    [switch]$Skip       # 기존 파일 모두 건너뛰기
)

# ============================================
# Configuration
# ============================================
$ErrorActionPreference = "Stop"
$CURSOR_DIR = "$env:USERPROFILE\.cursor"
$COMMANDS_DIR = "$CURSOR_DIR\_COMMAND_LIBRARY"
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path

# ============================================
# Helper Functions
# ============================================
function Write-Color {
    param([string]$Text, [string]$Color = "White")
    Write-Host $Text -ForegroundColor $Color
}

function Write-Header {
    Write-Host ""
    Write-Color "============================================" "Cyan"
    Write-Color "  Cursor Command Library Installer" "Cyan"
    Write-Color "============================================" "Cyan"
    Write-Host ""
}

function Test-Directory {
    param([string]$Path)
    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
        Write-Color "[+] Created directory: $Path" "Green"
    }
}

function Get-UserChoice {
    param([string]$FileName)
    
    if ($Force) { return "overwrite" }
    if ($Skip) { return "skip" }
    
    Write-Color "[?] '$FileName' already exists. What to do?" "Yellow"
    Write-Host "    [O] Overwrite  [S] Skip  [A] Overwrite All  [N] Skip All"
    $response = Read-Host "    Choice (O/S/A/N)"
    
    switch ($response.ToUpper()) {
        "O" { return "overwrite" }
        "S" { return "skip" }
        "A" { $script:Force = $true; return "overwrite" }
        "N" { $script:Skip = $true; return "skip" }
        default { return "skip" }
    }
}

# ============================================
# Main Installation
# ============================================
Write-Header

# Check source directory exists
$sourceCommands = Join-Path $SCRIPT_DIR "commands"

if (-not (Test-Path $sourceCommands)) {
    Write-Color "[!] Commands folder not found: $sourceCommands" "Red"
    Write-Color "[i] Make sure you're running this from the repository root" "Yellow"
    exit 1
}

# Ensure directories exist
Test-Directory $CURSOR_DIR
Test-Directory $COMMANDS_DIR

# Get all command files
$commandFiles = Get-ChildItem -Path $sourceCommands -Filter "*.md"
$installedCount = 0
$skippedCount = 0

Write-Color "[*] Installing Command Library..." "Yellow"
Write-Color "[i] Source: $sourceCommands" "Cyan"
Write-Color "[i] Target: $COMMANDS_DIR" "Cyan"
Write-Host ""

foreach ($file in $commandFiles) {
    $targetPath = Join-Path $COMMANDS_DIR $file.Name
    
    if (Test-Path $targetPath) {
        $choice = Get-UserChoice -FileName $file.Name
        
        if ($choice -eq "skip") {
            Write-Color "[-] Skipped: $($file.Name)" "DarkGray"
            $skippedCount++
            continue
        }
    }
    
    Copy-Item -Path $file.FullName -Destination $targetPath -Force
    Write-Color "[+] Installed: $($file.Name)" "Green"
    $installedCount++
}

# ============================================
# Summary
# ============================================
Write-Host ""
Write-Color "============================================" "Cyan"
Write-Color "  Installation Complete!" "Green"
Write-Color "============================================" "Cyan"
Write-Host ""

Write-Color "[i] Summary:" "Yellow"
Write-Color "    Installed: $installedCount files" "Green"
Write-Color "    Skipped:   $skippedCount files" "DarkGray"
Write-Color "    Location:  $COMMANDS_DIR" "White"
Write-Host ""

Write-Color "[i] Usage options:" "Cyan"
Write-Color "    -Force  : Overwrite all existing files" "White"
Write-Color "    -Skip   : Skip all existing files" "White"
Write-Host ""
