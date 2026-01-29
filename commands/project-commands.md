# project-commands

프로젝트 커맨드 모음입니다.

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

# @command: reentry_check
# @purpose: 프로젝트 재진입 검사 (필수 파일 확인)
# @usage: 프로젝트 재진입 시 자동 실행
# @keywords: 재진입,검사,reentry,check,검증
# @triggers: "재진입 검사", "reentry check"
# @background: false
# @dependencies: common
# @output: 검사 결과 출력

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

# @command: watch_loop
# @purpose: 백그라운드 감시 루프 (주기적으로 auto_maintain 실행)
# @usage: start_watcher에서 호출
# @keywords: 감시,루프,watch,loop,monitor
# @triggers: start_watcher에서 호출
# @background: true
# @dependencies: auto_maintain
# @output: 백그라운드 프로세스로 실행

# @command: start_watcher
# @purpose: 백그라운드 감시 프로세스 시작
# @usage: 프로젝트 생성 시 자동 실행
# @keywords: 감시시작,watcher,start,monitor
# @triggers: "프로젝트 생성", "watcher 시작"
# @background: false
# @dependencies: watch_loop
# @output: 백그라운드 프로세스 시작

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

# @command: init_state_load
# @purpose: 프로젝트 초기화 상태 로드
# @usage: 각 단계 시작 시 상태 확인
# @keywords: 초기화,상태,로드,init,state,load
# @triggers: 각 단계 시작 시
# @background: false
# @dependencies: common
# @output: 상태 정보 출력

# @command: init_step1_summary
# @purpose: 1단계 요약 문서 생성 (임시, 확인용)
# @usage: 1단계 완료 시
# @keywords: 초기화,1단계,요약,init,step1,summary
# @triggers: 1단계 완료 시
# @background: false
# @dependencies: common
# @output: .cursor/rules/INIT_STEP1_SUMMARY.md 생성

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

# 사용 가능한 명령:
# - project:create       # 프로젝트 생성
# - project:reentry-check # 재진입 검사
# - project:new-log <topic> # 로그 생성
# - project:sync-time    # 시간 동기화
# - project:agent-teams  # 에이전트 팀 생성
# - project:init-state-save <step> <data>  # 상태 저장
# - project:init-state-load                 # 상태 로드
# - project:init-step1-summary              # 1단계 요약

# <<< Cursor Project Commands <<<
