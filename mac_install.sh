#!/bin/bash
# ============================================================
# Cursor Skills 원클릭 설치 스크립트 (Mac/Linux)
# ============================================================
#
# 설치 내용:
#   1. MDC 규칙 (유저룰스 포함) → ~/.cursor/rules/
#   2. 커맨드 라이브러리 → ~/.cursor/_COMMAND_LIBRARY/
#
# 사용법:
#   ./mac_install.sh           # 전체 설치 (권장)
#   ./mac_install.sh --project # 현재 프로젝트에만 설치
#   ./mac_install.sh --no-backup # 백업 건너뛰기
#
# MCP 설정:
#   MCP는 별도로 설정해야 합니다.
#   가이드: _COMMAND_LIBRARY/mcp-command.md
#
# ============================================================

set -e

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
GRAY='\033[0;90m'
NC='\033[0m'

# 옵션 파싱
PROJECT=false
NO_BACKUP=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --project|-p)
            PROJECT=true
            shift
            ;;
        --no-backup)
            NO_BACKUP=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# 경로 설정
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CURSOR_DIR="$HOME/.cursor"
CURSOR_RULES_DIR="$CURSOR_DIR/rules"
CURSOR_CMD_DIR="$CURSOR_DIR/_COMMAND_LIBRARY"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="$CURSOR_DIR/_backup_$TIMESTAMP"

# 배너
echo ""
echo -e "${CYAN}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║     🚀 Cursor Skills 원클릭 설치 스크립트             ║${NC}"
echo -e "${CYAN}╠═══════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║  ✅ MDC 규칙 (유저룰스 포함)                          ║${NC}"
echo -e "${CYAN}║  ✅ 커맨드 라이브러리                                 ║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${GRAY}📂 소스: $SCRIPT_DIR${NC}"
echo -e "${GRAY}📂 대상: $CURSOR_DIR${NC}"
echo "─────────────────────────────────────────────────────"

# ============================================================
# 1. 백업
# ============================================================
if [ "$NO_BACKUP" = false ]; then
    need_backup=false
    [ -d "$CURSOR_RULES_DIR" ] && need_backup=true
    [ -d "$CURSOR_CMD_DIR" ] && need_backup=true
    
    if [ "$need_backup" = true ]; then
        echo -e "${YELLOW}📦 기존 설정 백업 중...${NC}"
        mkdir -p "$BACKUP_DIR"
        
        [ -d "$CURSOR_RULES_DIR" ] && cp -r "$CURSOR_RULES_DIR" "$BACKUP_DIR/rules" && echo -e "   ${GREEN}✅ rules/ 백업 완료${NC}"
        [ -d "$CURSOR_CMD_DIR" ] && cp -r "$CURSOR_CMD_DIR" "$BACKUP_DIR/_COMMAND_LIBRARY" && echo -e "   ${GREEN}✅ _COMMAND_LIBRARY/ 백업 완료${NC}"
        echo -e "   ${GRAY}📁 백업 위치: $BACKUP_DIR${NC}"
    else
        echo -e "   ${GRAY}ℹ️  기존 설정 없음 (백업 건너뜀)${NC}"
    fi
    echo "─────────────────────────────────────────────────────"
fi

# ============================================================
# 2. MDC 규칙 설치
# ============================================================
if [ "$PROJECT" = true ]; then
    TARGET_RULES="$(pwd)/.cursor/rules"
    TARGET_CMD="$(pwd)/_COMMAND_LIBRARY"
    echo -e "${CYAN}📁 프로젝트 설치 모드${NC}"
else
    TARGET_RULES="$CURSOR_RULES_DIR"
    TARGET_CMD="$CURSOR_CMD_DIR"
    echo -e "${CYAN}📁 전역 설치 모드${NC}"
fi

echo -e "${CYAN}📁 MDC 규칙 설치 중...${NC}"
mkdir -p "$TARGET_RULES"

SOURCE_RULES="$SCRIPT_DIR/.cursor/rules"
if [ -d "$SOURCE_RULES" ]; then
    for folder in "$SOURCE_RULES"/*/; do
        if [ -d "$folder" ]; then
            folder_name=$(basename "$folder")
            dest_path="$TARGET_RULES/$folder_name"
            
            mkdir -p "$dest_path"
            cp -r "$folder"* "$dest_path/" 2>/dev/null || true
            
            file_count=$(find "$dest_path" -type f -name "*.mdc" | wc -l | tr -d ' ')
            echo -e "   ${GREEN}✅ $folder_name/ ($file_count 파일)${NC}"
        fi
    done
else
    echo -e "   ${YELLOW}⚠️  소스 규칙 폴더 없음${NC}"
fi
echo "─────────────────────────────────────────────────────"

# ============================================================
# 3. 커맨드 라이브러리 설치
# ============================================================
echo -e "${CYAN}📚 커맨드 라이브러리 설치 중...${NC}"
mkdir -p "$TARGET_CMD"

SOURCE_CMD="$SCRIPT_DIR/_COMMAND_LIBRARY"
if [ -d "$SOURCE_CMD" ]; then
    cp -r "$SOURCE_CMD"/* "$TARGET_CMD/" 2>/dev/null || true
    cmd_count=$(find "$TARGET_CMD" -type f -name "*.md" | wc -l | tr -d ' ')
    echo -e "   ${GREEN}✅ 커맨드 라이브러리 ($cmd_count 파일)${NC}"
else
    echo -e "   ${YELLOW}⚠️  소스 커맨드 라이브러리 없음${NC}"
fi
echo "─────────────────────────────────────────────────────"

# ============================================================
# 4. 완료 메시지
# ============================================================
echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              ✅ 설치 완료!                            ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "📍 설치된 위치:"
echo -e "   ${GRAY}📁 MDC 규칙: $TARGET_RULES${NC}"
echo -e "   ${GRAY}📁 커맨드 라이브러리: $TARGET_CMD${NC}"
[ -d "$BACKUP_DIR" ] && echo -e "   ${GRAY}📁 백업: $BACKUP_DIR${NC}"

echo ""
echo -e "📌 다음 단계:"
echo -e "   ${GRAY}1. Cursor 재시작 (규칙 적용)${NC}"
echo -e "   ${GRAY}2. MCP 설정 (가이드: _COMMAND_LIBRARY/mcp-command.md)${NC}"
echo -e "   ${GRAY}3. 유저룰스 삭제 (Settings → Rules → 내용 비우기)${NC}"
echo ""

# ============================================================
# 5. 설치된 규칙 요약
# ============================================================
echo "─────────────────────────────────────────────────────"
echo -e "${CYAN}📋 설치된 내용 요약:${NC}"

echo ""
echo -e "   📁 MDC 규칙:"
declare -A categories
categories["00-core"]="핵심 규칙 (유저룰스 포함, 항상 적용)"
categories["10-language"]="언어별 규칙 (파일 타입별)"
categories["20-skills"]="스킬 (수동/@mention)"
categories["30-project"]="프로젝트 규칙"

for cat in $(echo "${!categories[@]}" | tr ' ' '\n' | sort); do
    cat_path="$TARGET_RULES/$cat"
    if [ -d "$cat_path" ]; then
        echo -e "      $cat/ - ${categories[$cat]}"
        for file in "$cat_path"/*.mdc; do
            if [ -f "$file" ]; then
                filename=$(basename "$file" .mdc)
                echo -e "         ${GRAY}└─ $filename${NC}"
            fi
        done
    fi
done

echo ""
echo -e "   📚 커맨드 라이브러리:"
if [ -d "$TARGET_CMD" ]; then
    for file in "$TARGET_CMD"/*.md; do
        if [ -f "$file" ]; then
            filename=$(basename "$file" .md)
            echo -e "      ${GRAY}└─ $filename${NC}"
        fi
    done
fi

echo ""
echo -e "${GREEN}🎉 모든 설정이 완료되었습니다!${NC}"
echo -e "${GRAY}   어느 컴퓨터에서든 동일한 환경으로 작업할 수 있습니다.${NC}"
echo ""
