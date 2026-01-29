# 커맨드 라이브러리 활용

> 재사용 가능한 명령어 시스템

---

## 📋 커맨드 라이브러리란?

재사용 가능한 명령어 모음으로, `~/.cursor/_COMMAND_LIBRARY/`에 저장됩니다.

---

## 🔍 커맨드 검색 프로세스

1. 요청 분석 → 키워드 추출
2. 커맨드 라이브러리에서 `@keywords` 매칭
3. 가장 적합한 커맨드 선택 및 실행

**매칭 점수**:
- @triggers 정확 매칭: 100점
- @keywords 부분 매칭: 50점
- @purpose 유사도: 30점

---

## 📁 주요 커맨드

| 파일 | 기능 |
|------|------|
| `mcp-command.md` | MCP 설치/사용 가이드 |
| `checkpoint-commands.md` | 체크포인트 저장/복원 |
| `agent-teams.md` | 에이전트 팀 생성 |
| `project-commands.md` | 프로젝트 관리 |

---

## 📝 커맨드 헤더 형식

```bash
# @command: [커맨드명]
# @purpose: [목적]
# @keywords: [키워드]
# @triggers: [트리거 패턴]
```
