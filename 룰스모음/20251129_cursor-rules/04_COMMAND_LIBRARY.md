# 확장 가능한 커맨드 라이브러리

**독립 모듈**: 이 룰스는 독립적으로 유저룰스에 붙여넣을 수 있습니다. 파일 종속성 없음.

## 🎯 목적

**확장 가능한 커맨드 라이브러리**: 유저 요청이나 자동화된 트리거에 의해 백그라운드에서 실행되는 커맨드 모음

---

## 📋 커맨드 분류

### 1. 파일 관리
**예시**: `git_auto_commit`, `track_file_change`, `ensure_changed_comment`

### 2. 폴더 관리
**예시**: `create_folder_structure`, `ensure_folder_exists`

### 3. 운영 관리
**예시**: `get_current_time`, `sync_current_time`, `log_entry`, `update_project_status`, `generate_progress_report`

### 4. 에이전트 커맨드
**예시**: `chief_agent_monitor`, `pm_agent_report`, `admin_agent_analysis`, `auditor_agent_review`

### 5. MCP 활용 커맨드
**예시**: `exa_search`, `context7_docs`, `browser_verify`, `mcp_check`

### 6. 프로젝트 특화
**예시**: `initialize_project`, `setup_project_type`

---

## 📋 백그라운드 실행 규칙

**자동 트리거**: 파일 변경, 시간 경과, 상태 변경 등 → 백그라운드 실행
**수동 트리거**: 사용자 요청 → 즉시 실행

---

## 📋 커맨드 확장 방법

1. **헤더 작성** (필수 필드 포함)
2. **커맨드 코드 작성**
3. **자동으로 검색 시스템에 통합**

**헤더 형식**:
```bash
#!/bin/bash
# @command: [커맨드명]
# @purpose: [목적]
# @usage: [사용 시나리오]
# @keywords: [키워드]
# @triggers: [트리거 패턴]
# @background: [true/false]
# @dependencies: [의존성]
# @output: [출력 형식]
```

---

## 📋 커맨드 검색 및 실행

**프로세스**: 요청/트리거 → 헤더 검색(@keywords, @triggers 매칭) → 가장 적합한 커맨드 선택 → 백그라운드 여부 확인 → 실행

**백그라운드 실행**: `@background: true`인 커맨드 → 사용자 작업에 방해되지 않도록 백그라운드 실행

---

## 📋 커맨드 체인

**원칙**: 의존성이 있는 커맨드들을 순차적으로 실행

**예시**: 파일 변경 감지 → get_current_time(백그라운드) → log_file_change(백그라운드) → update_project_status(백그라운드) → generate_progress_report(백그라운드, 조건 만족 시) → chief_agent_monitor(백그라운드, 주기적)

---

**이 모듈은 확장 가능한 커맨드 라이브러리를 제공하며, 백그라운드 실행을 지원합니다.**
