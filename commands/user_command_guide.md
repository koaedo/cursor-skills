# 유저커맨드 생성 가이드

**커서 AI 공식 형식**: 이 가이드는 커서 AI의 유저 커맨드 생성 방법을 설명합니다.

---

## 🎯 커서 AI 유저 커맨드 구조

### 파일 위치 및 이름

**파일명**: `project-commands.md` (프로젝트 루트에 위치)

**접근 방법**: 채팅에서 `/project-commands` 명령으로 접근

### 기본 구조

```bash
# >>> Cursor Project Commands >>>

_cursor_common() {
  local base="${_CURSOR_ROOT_OVERRIDE:-$(pwd)}"
  ROOT_DIR="$base"
  # 공통 변수 설정
}

_cursor_[커맨드명]() {
  _cursor_common
  # 커맨드 로직
}

cursor_command() {
  local action="$1"; shift || true
  case "$action" in
    [액션명])
      _cursor_[커맨드명]
      ;;
    *)
      echo "사용 가능한 명령: ..."
      ;;
  esac
}

alias [별칭]='cursor_command [액션명]'

# <<< Cursor Project Commands <<<
```

---

## 📋 커맨드 헤더 주석 (유저룰스 연동용)

각 커맨드 함수 위에 헤더 주석을 추가하여 유저룰스에서 검색 가능하게 합니다:

```bash
# @command: [커맨드명]
# @purpose: [목적]
# @usage: [사용 시나리오]
# @keywords: [키워드] # 최소 3개
# @triggers: [트리거 패턴]
# @background: [true/false]
# @dependencies: [의존성]
# @output: [출력 형식]

_cursor_[커맨드명]() {
  _cursor_common
  # 커맨드 로직
  # 반드시 파일을 생성/업데이트해야 함
}
```

**중요**: 헤더 주석은 유저룰스에서 `@keywords` 검색으로 커맨드를 찾기 위해 필요합니다.

---

## 📋 필수 원칙

### 1. 파일 생성/업데이트 필수

**모든 커맨드는 반드시 파일을 생성하거나 업데이트해야 합니다**

```bash
_cursor_get_current_time() {
  _cursor_common
  local clock="$CONTEXT_DIR/Clock.json"
  # 파일 생성/업데이트
  cat > "$clock" <<EOF
{
  "date": "$date",
  "time": "$time"
}
EOF
}
```

### 2. 에러 처리

```bash
_cursor_[커맨드명]() {
  _cursor_common
  if [ ! -d "$TARGET_DIR" ]; then
    echo "[오류] 디렉토리가 없습니다: $TARGET_DIR"
    return 1
  fi
  # 커맨드 로직
}
```

### 3. 로그 기록

```bash
_cursor_[커맨드명]() {
  _cursor_common
  # 커맨드 실행
  echo "[커맨드명] 완료: $result" >> "$LOGS_DIR/command.log"
}
```

---

## 📋 예시: get_current_time 커맨드

```bash
# @command: get_current_time
# @purpose: 현재 시각 가져오기 (파일명 생성용)
# @usage: 파일 생성/수정 시 자동 실행
# @keywords: 시간,시각,time,timestamp,now
# @triggers: 파일 생성/수정 감지 → "@keywords: 시간,시각" 검색
# @background: true
# @dependencies: []
# @output: YYYYMMDD_HHMMSS 형식 시간 문자열

_cursor_get_current_time() {
  _cursor_common
  local date=$(date +"%Y-%m-%d")
  local time=$(date +"%H:%M:%S")
  local timestamp=$(date +"%Y%m%d_%H%M%S")
  
  # 결과를 파일로 저장 (필수)
  local output_file="$CONTEXT_DIR/.current_time.txt"
  echo "$timestamp" > "$output_file"
  
  echo "$timestamp"
}

# cursor_command에 등록
cursor_command() {
  case "$1" in
    get-current-time) _cursor_get_current_time ;;
  esac
}
```

---

## 📋 유저룰스 연동

### 검색 키워드 매칭

유저룰스에서 `@keywords`를 검색하여 커맨드를 찾습니다:

```bash
# @keywords: 시간,시각,time,timestamp
# → "@keywords: 시간,시각" 검색 시 이 커맨드가 매칭됨
```

### 트리거 패턴

```bash
# @triggers: 파일 생성/수정 감지
# → 파일 생성/수정 시 자동 실행
```

---

**이 가이드는 커서 AI의 유저 커맨드 생성 방법을 설명합니다.**
