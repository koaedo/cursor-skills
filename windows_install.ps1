# ============================================================
# Cursor Skills 원클릭 설치 스크립트 (Windows PowerShell)
# ============================================================
#
# 설치 내용:
#   1. MDC 규칙 (유저룰스 포함) → ~/.cursor/rules/
#   2. 커맨드 라이브러리 → ~/.cursor/_COMMAND_LIBRARY/
#
# 사용법:
#   .\windows_install.ps1           # 전체 설치 (권장)
#   .\windows_install.ps1 -Project  # 현재 프로젝트에만 설치
#   .\windows_install.ps1 -NoBackup # 백업 건너뛰기
#
# MCP 설정:
#   MCP는 별도로 설정해야 합니다.
#   가이드: _COMMAND_LIBRARY/mcp-command.md
#
# ============================================================

param(
    [switch]$Project,   # 프로젝트에만 설치
    [switch]$NoBackup   # 백업 건너뛰기
)

$ErrorActionPreference = "Stop"

# 색상 출력 함수
function Write-Color {
    param([string]$Text, [string]$Color = "White")
    Write-Host $Text -ForegroundColor $Color
}

function Write-Line {
    Write-Host "─────────────────────────────────────────────────────" -ForegroundColor DarkGray
}

# 배너
Write-Host ""
Write-Color "╔═══════════════════════════════════════════════════════╗" "Cyan"
Write-Color "║     🚀 Cursor Skills 원클릭 설치 스크립트             ║" "Cyan"
Write-Color "╠═══════════════════════════════════════════════════════╣" "Cyan"
Write-Color "║  ✅ MDC 규칙 (유저룰스 포함)                          ║" "Cyan"
Write-Color "║  ✅ 커맨드 라이브러리                                 ║" "Cyan"
Write-Color "╚═══════════════════════════════════════════════════════╝" "Cyan"
Write-Host ""

# 경로 설정
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$CURSOR_DIR = "$env:USERPROFILE\.cursor"
$CURSOR_RULES_DIR = "$CURSOR_DIR\rules"
$CURSOR_CMD_DIR = "$CURSOR_DIR\_COMMAND_LIBRARY"
$TIMESTAMP = Get-Date -Format "yyyyMMdd_HHmmss"
$BACKUP_DIR = "$CURSOR_DIR\_backup_$TIMESTAMP"

Write-Color "📂 소스: $SCRIPT_DIR" "Gray"
Write-Color "📂 대상: $CURSOR_DIR" "Gray"
Write-Line

# ============================================================
# 1. 백업 (기존 설정이 있으면)
# ============================================================
if (-not $NoBackup) {
    $needBackup = $false
    if (Test-Path $CURSOR_RULES_DIR) { $needBackup = $true }
    if (Test-Path $CURSOR_CMD_DIR) { $needBackup = $true }
    
    if ($needBackup) {
        Write-Color "📦 기존 설정 백업 중..." "Yellow"
        New-Item -ItemType Directory -Path $BACKUP_DIR -Force | Out-Null
        
        if (Test-Path $CURSOR_RULES_DIR) {
            Copy-Item -Path $CURSOR_RULES_DIR -Destination "$BACKUP_DIR\rules" -Recurse -Force
            Write-Color "   ✅ rules/ 백업 완료" "Green"
        }
        if (Test-Path $CURSOR_CMD_DIR) {
            Copy-Item -Path $CURSOR_CMD_DIR -Destination "$BACKUP_DIR\_COMMAND_LIBRARY" -Recurse -Force
            Write-Color "   ✅ _COMMAND_LIBRARY/ 백업 완료" "Green"
        }
        Write-Color "   📁 백업 위치: $BACKUP_DIR" "Gray"
    } else {
        Write-Color "   ℹ️  기존 설정 없음 (백업 건너뜀)" "Gray"
    }
    Write-Line
}

# ============================================================
# 2. MDC 규칙 설치
# ============================================================
if ($Project) {
    $TARGET_RULES = "$(Get-Location)\.cursor\rules"
    $TARGET_CMD = "$(Get-Location)\_COMMAND_LIBRARY"
    Write-Color "📁 프로젝트 설치 모드" "Cyan"
} else {
    $TARGET_RULES = $CURSOR_RULES_DIR
    $TARGET_CMD = $CURSOR_CMD_DIR
    Write-Color "📁 전역 설치 모드" "Cyan"
}

Write-Color "📁 MDC 규칙 설치 중..." "Cyan"
New-Item -ItemType Directory -Path $TARGET_RULES -Force | Out-Null

$SOURCE_RULES = "$SCRIPT_DIR\.cursor\rules"
if (Test-Path $SOURCE_RULES) {
    Get-ChildItem -Path $SOURCE_RULES -Directory | ForEach-Object {
        $folderName = $_.Name
        $destPath = "$TARGET_RULES\$folderName"
        
        New-Item -ItemType Directory -Path $destPath -Force | Out-Null
        Copy-Item -Path "$($_.FullName)\*" -Destination $destPath -Recurse -Force
        
        $fileCount = (Get-ChildItem -Path $destPath -Filter "*.mdc" -File -Recurse).Count
        Write-Color "   ✅ $folderName/ ($fileCount 파일)" "Green"
    }
} else {
    Write-Color "   ⚠️  소스 규칙 폴더 없음" "Yellow"
}
Write-Line

# ============================================================
# 3. 커맨드 라이브러리 설치
# ============================================================
Write-Color "📚 커맨드 라이브러리 설치 중..." "Cyan"
New-Item -ItemType Directory -Path $TARGET_CMD -Force | Out-Null

$SOURCE_CMD = "$SCRIPT_DIR\_COMMAND_LIBRARY"
if (Test-Path $SOURCE_CMD) {
    Copy-Item -Path "$SOURCE_CMD\*" -Destination $TARGET_CMD -Recurse -Force
    $cmdCount = (Get-ChildItem -Path $TARGET_CMD -Filter "*.md" -File).Count
    Write-Color "   ✅ 커맨드 라이브러리 ($cmdCount 파일)" "Green"
} else {
    Write-Color "   ⚠️  소스 커맨드 라이브러리 없음" "Yellow"
}
Write-Line

# ============================================================
# 4. 완료 메시지
# ============================================================
Write-Host ""
Write-Color "╔═══════════════════════════════════════════════════════╗" "Green"
Write-Color "║              ✅ 설치 완료!                            ║" "Green"
Write-Color "╚═══════════════════════════════════════════════════════╝" "Green"
Write-Host ""

Write-Color "📍 설치된 위치:" "White"
Write-Color "   📁 MDC 규칙: $TARGET_RULES" "Gray"
Write-Color "   📁 커맨드 라이브러리: $TARGET_CMD" "Gray"
if (-not $NoBackup -and (Test-Path $BACKUP_DIR)) {
    Write-Color "   📁 백업: $BACKUP_DIR" "Gray"
}

Write-Host ""
Write-Color "📌 다음 단계:" "White"
Write-Color "   1. Cursor 재시작 (규칙 적용)" "Gray"
Write-Color "   2. MCP 설정 (가이드: _COMMAND_LIBRARY/mcp-command.md)" "Gray"
Write-Color "   3. 유저룰스 삭제 (Settings → Rules → 내용 비우기)" "Gray"
Write-Host ""

# ============================================================
# 5. 설치된 규칙 요약
# ============================================================
Write-Line
Write-Color "📋 설치된 내용 요약:" "Cyan"

# MDC 규칙
Write-Color "" "White"
Write-Color "   📁 MDC 규칙:" "White"
$categories = @{
    "00-core" = "핵심 규칙 (유저룰스 포함, 항상 적용)"
    "10-language" = "언어별 규칙 (파일 타입별)"
    "20-skills" = "스킬 (수동/@mention)"
    "30-project" = "프로젝트 규칙"
}

foreach ($cat in $categories.Keys | Sort-Object) {
    $catPath = "$TARGET_RULES\$cat"
    if (Test-Path $catPath) {
        $files = Get-ChildItem -Path $catPath -Filter "*.mdc" -File
        Write-Color "      $cat/ - $($categories[$cat])" "White"
        foreach ($file in $files) {
            Write-Color "         └─ $($file.BaseName)" "DarkGray"
        }
    }
}

# 커맨드 라이브러리
Write-Color "" "White"
Write-Color "   📚 커맨드 라이브러리:" "White"
if (Test-Path $TARGET_CMD) {
    Get-ChildItem -Path $TARGET_CMD -Filter "*.md" -File | ForEach-Object {
        Write-Color "      └─ $($_.BaseName)" "DarkGray"
    }
}

Write-Host ""
Write-Color "🎉 모든 설정이 완료되었습니다!" "Green"
Write-Color "   어느 컴퓨터에서든 동일한 환경으로 작업할 수 있습니다." "Gray"
Write-Host ""
