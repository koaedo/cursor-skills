# 프로젝트 세션 엔드포인트 관리

**참조 문서**: 이 파일은 세션 종료/시작 시 에이전트 팀이 프로젝트 상태를 정리하고 복원하는 가이드를 제공합니다.

## 🎯 목적

세션 종료 시 에이전트 팀이 각자 영역을 정리하고, 새 세션 시작 시 맥락을 복원하여 작업 연속성 보장

---

## 📋 Cursor AI 세션 특성

### 유지되는 것 ✅
- `.cursorrules`, `.cursor/rules/` 파일 (프로젝트 룰스)
- `!AGENT_System/` 폴더의 모든 로그/보고서
- 프로젝트 소스 파일, Git 히스토리

### 손실되는 것 ❌
- 현재 대화 컨텍스트 (이전 대화 내용)
- 임시 메모리 (대화 중 파악한 맥락)
- 진행 중이던 작업의 상태/맥락

---

## 📋 세션 종료 커맨드 (session_handoff)

### 유저커맨드 헤더

```bash
# @command: session_handoff
# @purpose: 세션 종료 전 에이전트 팀별 정리 및 핸드오프 문서 생성
# @usage: 세션 종료 전, "끝내자", "마무리", "오늘은 여기까지" 요청 시
# @keywords: 핸드오프,인수인계,세션종료,handoff,끝,마무리,종료,여기까지,끝내기
# @triggers: "끝내자", "마무리", "오늘은 여기까지", "세션 종료", "핸드오프", "여기서 끝"
# @background: false
# @dependencies: common, sync_time, agent_teams
# @output: !AGENT_System/YYYYMMDD_HHMMSS_HANDOFF.MD 생성
```

---

## 📋 세션 시작 커맨드 (session_resume)

### 유저커맨드 헤더

```bash
# @command: session_resume
# @purpose: 새 세션 시작 시 이전 핸드오프 로드 및 에이전트 팀 브리핑
# @usage: 새 세션 시작 시, "이어서", "계속", "어디까지 했지" 요청 시
# @keywords: 재개,이어서,계속,resume,복원,어디까지,시작,브리핑
# @triggers: "이어서", "계속 진행", "어디까지 했지", "resume", "시작", "브리핑"
# @background: false
# @dependencies: common, reentry_check, agent_teams
# @output: 이전 맥락 요약 출력, 팀별 브리핑
```

---

## 📋 트리거 매핑

### 세션 종료 트리거

| 사용자 입력 | 매핑 커맨드 | 동작 |
|------------|------------|------|
| "끝내자" | `session_handoff` | 에이전트 팀 정리 → 핸드오프 생성 |
| "마무리" | `session_handoff` | 에이전트 팀 정리 → 핸드오프 생성 |
| "오늘은 여기까지" | `session_handoff` | 에이전트 팀 정리 → 핸드오프 생성 |

### 세션 시작 트리거

| 사용자 입력 | 매핑 커맨드 | 동작 |
|------------|------------|------|
| "이어서" | `session_resume` | 핸드오프 로드 → 팀 브리핑 |
| "계속" | `session_resume` | 핸드오프 로드 → 팀 브리핑 |
| "어디까지 했지" | `session_resume` | 핸드오프 로드 → 팀 브리핑 |

---

**이 문서는 세션 종료/시작 시 에이전트 팀이 프로젝트 상태를 정리하고 복원하는 가이드를 제공합니다.**
