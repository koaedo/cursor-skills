# Cursor Skills & Commands Installer for Windows
# Usage:
#   .\scripts\windows\install.ps1                    # 기본: 파일별로 물어봄
#   .\scripts\windows\install.ps1 -Force             # 모두 덮어쓰기
#   .\scripts\windows\install.ps1 -Skip              # 기존 파일 모두 건너뛰기
#   .\scripts\windows\install.ps1 -SkipCommands      # 커맨드 설치 건너뛰기
#   .\scripts\windows\install.ps1 -SkipSkills        # 스킬 설치 건너뛰기

param(
    [switch]$SkipCommands,  # 커맨드 설치 건너뛰기
    [switch]$SkipSkills,    # 스킬 설치 건너뛰기
    [switch]$Force,         # 기존 파일 모두 덮어쓰기
    [switch]$Skip           # 기존 파일 모두 건너뛰기
)

# ============================================
# Configuration
# ============================================
$ErrorActionPreference = "Stop"
$CURSOR_DIR = "$env:USERPROFILE\.cursor"
$COMMANDS_DIR = "$CURSOR_DIR\_COMMAND_LIBRARY"
$SKILLS_DIR = "$CURSOR_DIR\skills-cursor"
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$ROOT_DIR = (Resolve-Path "$SCRIPT_DIR\..\..").Path

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
    Write-Color "  Cursor Skills & Commands Installer" "Cyan"
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
    param([string]$ItemName, [string]$ItemType = "file")
    
    if ($Force) { return "overwrite" }
    if ($Skip) { return "skip" }
    
    Write-Color "[?] $ItemType '$ItemName' already exists. What to do?" "Yellow"
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

# Check source directories exist
$sourceCommands = Join-Path $ROOT_DIR "commands"
$sourceSkills = Join-Path $ROOT_DIR "skills"

if (-not $SkipCommands -and -not (Test-Path $sourceCommands)) {
    Write-Color "[!] Commands folder not found: $sourceCommands" "Red"
    Write-Color "[i] Make sure you're running this from the repository root" "Yellow"
    exit 1
}

if (-not $SkipSkills -and -not (Test-Path $sourceSkills)) {
    Write-Color "[!] Skills folder not found: $sourceSkills" "Red"
    Write-Color "[i] Make sure you're running this from the repository root" "Yellow"
    exit 1
}

# Ensure Cursor directory exists
Test-Directory $CURSOR_DIR

$totalInstalled = 0
$totalSkipped = 0

# ============================================
# Install Command Library
# ============================================
if (-not $SkipCommands) {
    Write-Color "[*] Installing Command Library..." "Yellow"
    Write-Color "[i] Source: $sourceCommands" "Cyan"
    Write-Color "[i] Target: $COMMANDS_DIR" "Cyan"
    Write-Host ""
    
    Test-Directory $COMMANDS_DIR
    
    $commandFiles = Get-ChildItem -Path $sourceCommands -Filter "*.md"
    
    foreach ($file in $commandFiles) {
        $targetPath = Join-Path $COMMANDS_DIR $file.Name
        
        if (Test-Path $targetPath) {
            $choice = Get-UserChoice -ItemName $file.Name -ItemType "Command"
            
            if ($choice -eq "skip") {
                Write-Color "[-] Skipped: $($file.Name)" "DarkGray"
                $totalSkipped++
                continue
            }
        }
        
        Copy-Item -Path $file.FullName -Destination $targetPath -Force
        Write-Color "[+] Installed: $($file.Name)" "Green"
        $totalInstalled++
    }
    Write-Host ""
}

# ============================================
# Install Skills
# ============================================
if (-not $SkipSkills) {
    Write-Color "[*] Installing Skills..." "Yellow"
    Write-Color "[i] Source: $sourceSkills" "Cyan"
    Write-Color "[i] Target: $SKILLS_DIR" "Cyan"
    Write-Host ""
    
    Test-Directory $SKILLS_DIR
    
    $skillFolders = Get-ChildItem -Path $sourceSkills -Directory
    
    foreach ($skill in $skillFolders) {
        $targetPath = Join-Path $SKILLS_DIR $skill.Name
        
        if (Test-Path $targetPath) {
            $choice = Get-UserChoice -ItemName $skill.Name -ItemType "Skill"
            
            if ($choice -eq "skip") {
                Write-Color "[-] Skipped: $($skill.Name)" "DarkGray"
                $totalSkipped++
                continue
            }
            
            Remove-Item -Path $targetPath -Recurse -Force
        }
        
        Copy-Item -Path $skill.FullName -Destination $targetPath -Recurse -Force
        Write-Color "[+] Installed: $($skill.Name)" "Green"
        $totalInstalled++
    }
    Write-Host ""
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
Write-Color "    Installed: $totalInstalled items" "Green"
Write-Color "    Skipped:   $totalSkipped items" "DarkGray"
Write-Host ""

Write-Color "[i] Installed locations:" "Yellow"
if (-not $SkipCommands) {
    Write-Color "    Commands: $COMMANDS_DIR" "White"
}
if (-not $SkipSkills) {
    Write-Color "    Skills:   $SKILLS_DIR" "White"
}
Write-Host ""

Write-Color "[!] IMPORTANT: User Rules must be set manually" "Yellow"
Write-Color "    1. Open file: user-rules\_combined.md" "White"
Write-Color "    2. Copy the entire content" "White"
Write-Color "    3. Paste into: Cursor Settings > Rules" "White"
Write-Host ""

Write-Color "[i] Usage options:" "Cyan"
Write-Color "    -Force         : Overwrite all existing files" "White"
Write-Color "    -Skip          : Skip all existing files" "White"
Write-Color "    -SkipCommands  : Skip command installation" "White"
Write-Color "    -SkipSkills    : Skip skills installation" "White"
Write-Host ""

Write-Color "[i] To install MCPs, run: .\scripts\windows\install-mcp.ps1" "Cyan"
Write-Host ""
