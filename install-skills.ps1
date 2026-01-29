# Cursor Skills Installer for Windows
# Usage:
#   .\install-skills.ps1           # 기본: 스킬별로 물어봄
#   .\install-skills.ps1 -Force    # 모두 덮어쓰기
#   .\install-skills.ps1 -Skip     # 기존 스킬 모두 건너뛰기

param(
    [switch]$Force,     # 기존 스킬 모두 덮어쓰기
    [switch]$Skip       # 기존 스킬 모두 건너뛰기
)

# ============================================
# Configuration
# ============================================
$ErrorActionPreference = "Stop"
$CURSOR_DIR = "$env:USERPROFILE\.cursor"
$SKILLS_DIR = "$CURSOR_DIR\skills-cursor"
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
    Write-Color "  Cursor Skills Installer" "Cyan"
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
    param([string]$SkillName)
    
    if ($Force) { return "overwrite" }
    if ($Skip) { return "skip" }
    
    Write-Color "[?] Skill '$SkillName' already exists. What to do?" "Yellow"
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
$sourceSkills = Join-Path $SCRIPT_DIR "skills"

if (-not (Test-Path $sourceSkills)) {
    Write-Color "[!] Skills folder not found: $sourceSkills" "Red"
    Write-Color "[i] Make sure you're running this from the repository root" "Yellow"
    exit 1
}

# Ensure directories exist
Test-Directory $CURSOR_DIR
Test-Directory $SKILLS_DIR

# Get all skill folders
$skillFolders = Get-ChildItem -Path $sourceSkills -Directory
$installedCount = 0
$skippedCount = 0

Write-Color "[*] Installing Skills..." "Yellow"
Write-Color "[i] Source: $sourceSkills" "Cyan"
Write-Color "[i] Target: $SKILLS_DIR" "Cyan"
Write-Host ""

foreach ($skill in $skillFolders) {
    $targetPath = Join-Path $SKILLS_DIR $skill.Name
    
    if (Test-Path $targetPath) {
        $choice = Get-UserChoice -SkillName $skill.Name
        
        if ($choice -eq "skip") {
            Write-Color "[-] Skipped: $($skill.Name)" "DarkGray"
            $skippedCount++
            continue
        }
        
        # Remove existing skill folder before copying
        Remove-Item -Path $targetPath -Recurse -Force
    }
    
    Copy-Item -Path $skill.FullName -Destination $targetPath -Recurse -Force
    Write-Color "[+] Installed: $($skill.Name)" "Green"
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
Write-Color "    Installed: $installedCount skills" "Green"
Write-Color "    Skipped:   $skippedCount skills" "DarkGray"
Write-Color "    Location:  $SKILLS_DIR" "White"
Write-Host ""

# List installed skills
Write-Color "[i] Installed skills:" "Cyan"
$installedSkills = Get-ChildItem -Path $SKILLS_DIR -Directory | ForEach-Object { $_.Name }
foreach ($skillName in $installedSkills) {
    Write-Color "    - $skillName" "White"
}
Write-Host ""

Write-Color "[i] Usage options:" "Cyan"
Write-Color "    -Force  : Overwrite all existing skills" "White"
Write-Color "    -Skip   : Skip all existing skills" "White"
Write-Host ""
