# project-commands

Write your command content here.

This command will be available in chat with /project-commands

# >>> Cursor Project Commands >>>

# ============================================
# 공통 함수
# ============================================

_cursor_common() {
  local base="${_CURSOR_ROOT_OVERRIDE:-$(pwd)}"
  ROOT_DIR="$base"
  AGENT_DIR="$ROOT_DIR/!AGENT_System"
  mkdir -p "$AGENT_DIR"
}

# ============================================
# 시간 관리 커맨드
# ============================================

# @command: sync_time
# @purpose: 현재 시각 동기화 (Clock.json 업데이트)
# @usage: 모든 쿼리 시작 시 자동 실행, 시간 동기화 요청 시
# @keywords: 시간,시각,동기화,time,sync,clock
# @triggers: "시간 동기화", "sync time", "시간 업데이트"
# @background: true
# @dependencies: common
# @output: !AGENT_System/Clock.json 업데이트

_cursor_sync_time() {
  _cursor_common
  local clock="$AGENT_DIR/Clock.json"
  local date time ts tz
  date=$(date +"%Y-%m-%d")
  time=$(date +"%H:%M:%S")
  ts=$(date +%s)
  tz=$(date +%Z)
  cat > "$clock" <<EOF
{
  "date": "$date",
  "time": "$time",
  "timestamp": $ts,
  "last_time": "$date $time",
  "timezone": "$tz",
  "format": "YYYY-MM-DD HH:mm:ss"
}
EOF
  echo "$date $time | tz=$tz" >> "$AGENT_DIR/${date}_clock-events.log"
}

# ============================================
# 프로젝트 초기화 커맨드
# ============================================

# @command: bootstrap
# @purpose: 프로젝트 초기화 (필수 파일 생성)
# @usage: 프로젝트 초기화 요청 시
# @keywords: 프로젝트,초기화,init,bootstrap,setup
# @triggers: "프로젝트 초기화", "초기화", "setup", "init"
# @background: false
# @dependencies: common
# @output: !AGENT_System/Current_Global.md 생성

_cursor_bootstrap() {
  _cursor_common
  local now=$(date +"%Y-%m-%d %H:%M:%S")
  local cg="$AGENT_DIR/Current_Global.md"
  if [ ! -f "$cg" ]; then
    cat > "$cg" <<EOF
---

title: "Current Global Context"
description: "전체 프로젝트 상태 및 맥락 관리"
type: "context"
status: "active"
version: "4.0.0"
created: "$now"
updated: "$now"
dependencies: []
provides: ["global-context"]
---

# 현재 전역 맥락

- project bootstrap in progress
EOF
  fi
}

# @command: reentry_check
# @purpose: 프로젝트 재진입 검사 (필수 파일 확인)
# @usage: 프로젝트 재진입 시 자동 실행
# @keywords: 재진입,검사,reentry,check,검증
# @triggers: "재진입 검사", "reentry check"
# @background: false
# @dependencies: common
# @output: 검사 결과 출력

_cursor_reentry() {
  _cursor_common
  local failures=0
  local clock="$AGENT_DIR/Clock.json"
  if [ ! -f "$clock" ]; then
    echo "[재진입][FAIL] Clock.json 없음"; failures=$((failures+1))
  elif command -v python3 >/dev/null 2>&1; then
    eval "$(python3 - "$clock" <<'PY'
import json, sys, pathlib
clock = pathlib.Path(sys.argv[1])
try:
    data = json.loads(clock.read_text())
except FileNotFoundError:
    data = {}
from json import dumps
print(f'C_TS={dumps(str(data.get("timestamp", "")))}')
PY
    )"
    NOW=$(date +%s)
    if [[ "$C_TS" =~ ^[0-9]+$ ]] && [ $((NOW - C_TS)) -gt 600 ]; then
      echo "[재진입][FAIL] Clock 10분 초과"; failures=$((failures+1))
    else
      echo "[재진입] Clock OK"
    fi
  fi
  [ -f "$AGENT_DIR/Current_Global.md" ] || { echo "[재진입][FAIL] Current_Global 없음"; failures=$((failures+1)); }
  local recent_log
  recent_log=$(find "$AGENT_DIR" -type f -name "*.md" -mtime -1 2>/dev/null | head -n1 || true)
  [ -n "$recent_log" ] && echo "[재진입] 최근 로그: $recent_log" || echo "[재진입][WARN] 최근 로그 없음"
  if [ "$failures" -gt 0 ]; then
    echo "[재진입] 실패 (failures=$failures)"
    return 1
  fi
  echo "[재진입] 통과"
}

# ============================================
# 로그 관리 커맨드
# ============================================

# @command: new_log
# @purpose: 새 로그 파일 생성 또는 기존 로그 업데이트
# @usage: 로그 작성 요청 시
# @keywords: 로그,작성,log,new,기록
# @triggers: "로그 작성", "new log", "로그 만들어"
# @background: false
# @dependencies: common
# @output: !AGENT_System/YYYYMMDD_HHMMSS_LOG_system_[토픽].MD 생성/업데이트

_cursor_new_log() {
  _cursor_common
  local topic="${1:-context}"
  topic=$(echo "$topic" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd 'a-z0-9-_')
  [ -z "$topic" ] && topic="context"
  local date=$(date +"%Y-%m-%d")
  local time=$(date +"%H:%M:%S")
  local timestamp=$(date +"%Y%m%d_%H%M%S")
  local file="$AGENT_DIR/${timestamp}_LOG_system_${topic}.MD"
  if [ -f "$file" ]; then
    cat >> "$file" <<EOF

## 업데이트 - $time

- TODO: 작업 내용을 추가하세요.
EOF
    echo "[로그] 업데이트 추가: $file"
  else
    cat > "$file" <<EOF

---

title: "${date} $ Log"
description: "$ 작업 기록"
type: "log"
status: "active"
version: "1.0.0"
created: "${date} $"
updated: "${date} $"
dependencies: []
provides: ["daily-log"]
-----------------------

# ${date} $ 로그

## 실행 요약

- TODO: 오늘 수행한 주요 작업을 bullet로 기록하세요.

## 세부 내용

- TODO: 결정/이슈/설명 등 세부 내용을 추가하세요.

## 미해결/후속

- TODO: 다음 액션이나 남은 위험 요소를 명시하세요.
EOF
    echo "[로그] 새 로그 생성: $file"
  fi
}

# ============================================
# 자동 유지보수 커맨드
# ============================================

# @command: auto_maintain
# @purpose: 자동 유지보수 (시간 동기화, 로그 생성, 재진입 검사)
# @usage: 백그라운드에서 주기적으로 실행
# @keywords: 자동,유지보수,auto,maintain,maintenance
# @triggers: 주기적 실행 (watch_loop)
# @background: true
# @dependencies: common, sync_time, new_log, reentry_check
# @output: !AGENT_System/YYYYMMDD_HHMMSS_LOG_system_auto.MD 업데이트

_cursor_auto_maintain() {
  local root="$1"
  local now_date=$(date +"%Y-%m-%d")
  local now_time=$(date +"%H:%M:%S")
  local timestamp=$(date +"%Y%m%d_%H%M%S")
  local actions=()
  _CURSOR_ROOT_OVERRIDE="$root" _cursor_common
  local auto_log="$AGENT_DIR/${timestamp}_LOG_system_auto.MD"

  local clock="$AGENT_DIR/Clock.json"
  local need_sync=0
  local clock_ts=""
  if [ -f "$clock" ] && command -v python3 >/dev/null 2>&1; then
    clock_ts=$(python3 - "$clock" <<'PY'
import json, sys, pathlib
clock = pathlib.Path(sys.argv[1])
try:
    data = json.loads(clock.read_text())
    print(data.get("timestamp", ""))
except FileNotFoundError:
    print("")
PY
    )
    if [[ "$clock_ts" =~ ^[0-9]+$ ]]; then
      local now_ts=$(date +%s)
      if [ $((now_ts - clock_ts)) -gt 600 ]; then
        need_sync=1
      fi
    else
      need_sync=1
    fi
  else
    need_sync=1
  fi
  if [ "$need_sync" -eq 1 ]; then
    (_CURSOR_ROOT_OVERRIDE="$root"; _cursor_sync_time)
    actions+=("sync_time")
  fi

  local recent_log=$(find "$AGENT_DIR" -type f -name "*_LOG_system_*.MD" -mtime -1 2>/dev/null | head -n1 || true)
  if [ -z "$recent_log" ]; then
    (_CURSOR_ROOT_OVERRIDE="$root"; _cursor_new_log "context")
    actions+=("log_context")
  fi

  if ! (_CURSOR_ROOT_OVERRIDE="$root"; _cursor_reentry > /dev/null 2>&1); then
    actions+=("reentry_warn")
  fi

  if [ ${#actions[@]} -eq 0 ]; then
    actions=("idle")
  fi
  cat > "$auto_log" <<EOF
---
title: "Auto Maintenance Log"
type: "log"
created: "$now_date $now_time"
---

# 자동 유지보수 로그

## 실행 시간
$now_date $now_time

## 실행된 작업
${actions[*]}

EOF
}

# @command: watch_loop
# @purpose: 백그라운드 감시 루프 (주기적으로 auto_maintain 실행)
# @usage: start_watcher에서 호출
# @keywords: 감시,루프,watch,loop,monitor
# @triggers: start_watcher에서 호출
# @background: true
# @dependencies: auto_maintain
# @output: 백그라운드 프로세스로 실행

_cursor_watch_loop() {
  local root="$1"
  local interval="${2:-300}"
  local pid_file="$root/!AGENT_System/.cursor_watch.pid"
  mkdir -p "$(dirname "$pid_file")"
  echo $$ > "$pid_file"
  trap 'rm -f "$pid_file"; exit 0' INT TERM EXIT
  while true; do
    _CURSOR_ROOT_OVERRIDE="$root" _cursor_auto_maintain "$root"
    sleep "$interval"
  done
}

# @command: start_watcher
# @purpose: 백그라운드 감시 프로세스 시작
# @usage: 프로젝트 생성 시 자동 실행
# @keywords: 감시시작,watcher,start,monitor
# @triggers: "프로젝트 생성", "watcher 시작"
# @background: false
# @dependencies: watch_loop
# @output: 백그라운드 프로세스 시작

_cursor_start_watcher() {
  _cursor_common
  local pid_file="$AGENT_DIR/.cursor_watch.pid"
  if [ -f "$pid_file" ]; then
    local existing_pid
    existing_pid=$(cat "$pid_file" 2>/dev/null || true)
    if [ -n "$existing_pid" ] && kill -0 "$existing_pid" 2>/dev/null; then
      echo "[watcher] 이미 실행 중 (pid=$existing_pid)"
      return
    fi
  fi
  local root="$ROOT_DIR"
  nohup bash -c "source ~/.bashrc >/dev/null 2>&1 && _cursor_watch_loop '$root'" >/dev/null 2>&1 &
  echo $! > "$pid_file"
  echo "[watcher] 시작 (pid=$!)"
}

# ============================================
# 프로젝트 에이전트 팀 생성 커맨드
# ============================================

# @command: create_project_agent_teams
# @purpose: 프로젝트 성격에 맞는 최고의 에이전트 팀 생성 및 프로젝트 룰스 등록
# @usage: 프로젝트 초기화 시 또는 "에이전트 팀 생성" 요청 시
# @keywords: 에이전트팀,프로젝트팀,팀생성,agent,team,project,구성
# @triggers: "에이전트 팀 생성", "프로젝트 팀 구성", "agent teams", "팀 만들기"
# @background: false
# @dependencies: common, sync_time
# @output: .cursor/rules/AGENT_Teams.mdc 생성

_cursor_create_project_agent_teams() {
  _cursor_common
  local rules_dir="$ROOT_DIR/.cursor/rules"
  local agent_teams_file="$rules_dir/AGENT_Teams.mdc"
  local timestamp=$(date +"%Y%m%d_%H%M%S")
  local date=$(date +"%Y-%m-%d")
  local time=$(date +"%H:%M:%S")
  
  mkdir -p "$rules_dir"
  
  # 프로젝트 분석 (README.md, package.json 확인)
  local project_type="일반"
  local project_name=$(basename "$ROOT_DIR")
  
  if [ -f "$ROOT_DIR/README.md" ]; then
    # README에서 프로젝트 타입 추론 시도
    if grep -qi "투자\|금융\|trading\|investment" "$ROOT_DIR/README.md"; then
      project_type="투자/금융"
    elif grep -qi "웹\|web\|frontend\|backend" "$ROOT_DIR/README.md"; then
      project_type="웹 개발"
    elif grep -qi "데이터\|data\|ml\|ai\|machine" "$ROOT_DIR/README.md"; then
      project_type="데이터 분석"
    elif grep -qi "api\|service\|microservice" "$ROOT_DIR/README.md"; then
      project_type="API/서비스"
    fi
  fi
  
  # 참조 문서 읽기
  local agent_teams_guide="$ROOT_DIR/_COMMAND_LIBRARY/agent-teams.md"
  if [ ! -f "$agent_teams_guide" ]; then
    # 상위 디렉토리에서 찾기 (cursor-rules 프로젝트)
    agent_teams_guide="$(dirname "$ROOT_DIR")/20251129_cursor-rules/_COMMAND_LIBRARY/agent-teams.md"
  fi
  
  # 기본 팀 구성 생성 (질문 기반은 AI가 대화로 진행)
  cat > "$agent_teams_file" <<EOF
---
description: "프로젝트별 에이전트 팀 구성 및 논쟁 기반 협업 규칙"
globs: ["**/*"]
alwaysApply: false
---

# 🏆 프로젝트 에이전트 팀 구성

**프로젝트**: $project_name
**타입**: $project_type
**생성일**: $date $time

## 📋 이론적 기반

### 1. Belbin Team Roles (1981)
- 9가지 팀 역할 이론: 각 역할의 강점과 약점이 상호 보완
- **핵심**: 다양한 역할이 있어야 팀이 고성능 발휘

### 2. Adversarial Collaboration (Kahneman & Klein, 2009)
- 상반된 관점의 전문가들이 **논쟁**을 통해 더 나은 결론 도출
- **핵심**: 논쟁은 성장의 원동력

### 3. Red Team / Blue Team (군사/보안)
- Red Team: 공격자 관점에서 취약점 발견
- Blue Team: 방어자 관점에서 시스템 보호
- **핵심**: 적대적 검증이 품질을 높임

### 4. NASA Mission Control (Apollo 시대)
- Flight Director + 분야별 전문가 팀
- **핵심**: 각 전문가가 자기 영역에서 VETO 권한

---

## 📋 프로젝트 에이전트 팀

**참고**: 이 팀 구성은 프로젝트 성격에 맞게 질문을 통해 최적화됩니다.
상세 팀 구성은 AI와의 대화를 통해 완성됩니다.

**참조 문서**: \`_COMMAND_LIBRARY/agent-teams.md\`

---

## 논쟁 규칙 (Adversarial Collaboration)

### 1. 건설적 논쟁 원칙
- 인신공격 금지, 아이디어만 공격
- 반드시 **증거 기반** 주장
- 상대방 논점 먼저 요약 후 반박

### 2. 논쟁 해결 프로세스
1. 양측 주장 명확화
2. 증거 제시 (코드, 데이터, 논문)
3. 제3의 팀 중재 (필요시)
4. 실험/테스트로 검증
5. 결과 기반 합의

### 3. VETO 권한
| 팀 | VETO 조건 |
|----|----------|
| Risk & Compliance | 하드 리미트 위반 |
| Testing & QA | 백테스트 미통과 |
| Red Team | 치명적 취약점 발견 |

---

**생성 시각**: $date $time
**버전**: 1.0.0
EOF

  echo "[에이전트팀] 프로젝트 룰스 파일 생성: $agent_teams_file"
  echo "[에이전트팀] 참고: 상세 팀 구성은 AI와의 대화를 통해 완성됩니다."
  echo "[에이전트팀] 참조 문서: $agent_teams_guide"
}

# ============================================
# 프로젝트 초기화 대화 프로세스 (상태 관리)
# ============================================

# @command: init_state_save
# @purpose: 프로젝트 초기화 상태 저장
# @usage: 각 단계 완료 시 상태 저장
# @keywords: 초기화,상태,저장,init,state,save
# @triggers: 각 단계 완료 시
# @background: false
# @dependencies: common
# @output: !AGENT_System/INIT_STATE.json 업데이트

_cursor_init_state_save() {
  _cursor_common
  local state_file="$AGENT_DIR/INIT_STATE.json"
  local step="$1"
  local data="$2"
  local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  
  if [ ! -f "$state_file" ]; then
    cat > "$state_file" <<EOF
{
  "step": "$step",
  "created": "$timestamp",
  "updated": "$timestamp",
  "data": $data
}
EOF
  else
    # 기존 파일 업데이트 (jq가 있으면 사용, 없으면 간단히 덮어쓰기)
    if command -v jq >/dev/null 2>&1; then
      jq --arg step "$step" --arg updated "$timestamp" --argjson data "$data" \
        '.step = $step | .updated = $updated | .data = $data' \
        "$state_file" > "$state_file.tmp" && mv "$state_file.tmp" "$state_file"
    else
      cat > "$state_file" <<EOF
{
  "step": "$step",
  "updated": "$timestamp",
  "data": $data
}
EOF
    fi
  fi
  echo "[초기화] 상태 저장: step=$step"
}

# @command: init_state_load
# @purpose: 프로젝트 초기화 상태 로드
# @usage: 각 단계 시작 시 상태 확인
# @keywords: 초기화,상태,로드,init,state,load
# @triggers: 각 단계 시작 시
# @background: false
# @dependencies: common
# @output: 상태 정보 출력

_cursor_init_state_load() {
  _cursor_common
  local state_file="$AGENT_DIR/INIT_STATE.json"
  
  if [ -f "$state_file" ]; then
    if command -v jq >/dev/null 2>&1; then
      jq '.' "$state_file"
    else
      cat "$state_file"
    fi
  else
    echo "{}"
  fi
}

# @command: init_step1_summary
# @purpose: 1단계 요약 문서 생성 (임시, 확인용)
# @usage: 1단계 완료 시
# @keywords: 초기화,1단계,요약,init,step1,summary
# @triggers: 1단계 완료 시
# @background: false
# @dependencies: common
# @output: .cursor/rules/INIT_STEP1_SUMMARY.md 생성

_cursor_init_step1_summary() {
  _cursor_common
  local rules_dir="$ROOT_DIR/.cursor/rules"
  local summary_file="$rules_dir/INIT_STEP1_SUMMARY.md"
  local timestamp=$(date +"%Y%m%d_%H%M%S")
  local date=$(date +"%Y-%m-%d")
  local time=$(date +"%H:%M:%S")
  
  mkdir -p "$rules_dir"
  
  cat > "$summary_file" <<EOF
---
description: "프로젝트 초기화 1단계 요약 (임시, 확인용)"
globs: ["**/*"]
alwaysApply: false
---

# 프로젝트 초기화 1단계 요약

**생성일**: $date $time

## 범주와 방향성

[1단계 대화에서 파악한 내용이 여기에 기록됩니다]

## AI 기술 제안

[AI가 제안한 기술 스택 및 아키텍처가 여기에 기록됩니다]

---

**참고**: 이 파일은 확인용 임시 파일입니다. 2단계 진행 후 삭제될 수 있습니다.
EOF

  echo "[초기화] 1단계 요약 생성: $summary_file"
}

# ============================================
# 메인 라우터
# ============================================

# @command: cursor_command
# @purpose: 커맨드 라우터 (모든 커맨드를 여기서 라우팅)
# @usage: 채팅에서 /project-commands 명령으로 접근
# @keywords: 커맨드,라우터,command,router
# @triggers: /project-commands 명령
# @background: false
# @dependencies: 모든 커맨드 함수
# @output: 선택된 커맨드 실행

cursor_command() {
  local action="$1"; shift || true
  case "$action" in
    project:create)
      _cursor_bootstrap
      _cursor_sync_time
      _cursor_reentry
      _cursor_new_log "context"
      _cursor_start_watcher
      ;;
    project:reentry-check)
      _cursor_reentry
      ;;
    project:new-log)
      _cursor_new_log "${1:-context}"
      ;;
    project:sync-time)
      _cursor_sync_time
      ;;
    project:agent-teams)
      _cursor_create_project_agent_teams
      ;;
    project:init-state-save)
      _cursor_init_state_save "$1" "$2"
      ;;
    project:init-state-load)
      _cursor_init_state_load
      ;;
    project:init-step1-summary)
      _cursor_init_step1_summary
      ;;
    *)
      echo "사용 가능한 명령: project:create | project:reentry-check | project:new-log \`<topic>\` | project:sync-time | project:agent-teams | project:init-state-save \`<step>\` \`<data>\` | project:init-state-load | project:init-step1-summary"
      ;;
  esac
}

alias 프로젝트생성='cursor_command project:create'
alias 재진입검사='cursor_command project:reentry-check'
alias 로그작성='cursor_command project:new-log'
alias 시간동기화='cursor_command project:sync-time'
alias 에이전트팀생성='cursor_command project:agent-teams'

# <<< Cursor Project Commands <<<
