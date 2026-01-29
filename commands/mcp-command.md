# MCP 설치 및 설정 가이드

Cursor AI에서 사용하는 MCP(Model Context Protocol) 서버 설치 및 설정 가이드입니다.

---

## 🚀 빠른 시작

### 필수 조건
- **Node.js 18+** 설치 필요: https://nodejs.org/

### Cursor에서 MCP 추가 방법
1. `Ctrl + ,` (Settings) → `Features` → `MCP Servers`
2. `+ Add new global MCP server` 클릭
3. 아래 명령어 입력

---

## 📦 MCP 카테고리별 분류

### 🔴 필수 MCP (강력 권장)

모든 프로젝트에서 유용한 핵심 MCP입니다.

---

#### 1. Context7 - 라이브러리 문서 조회

```bash
npx -y @upstash/context7-mcp
```

| 항목 | 내용 |
|------|------|
| **용도** | React, Next.js, TypeScript 등 라이브러리 최신 문서 조회 |
| **API 키** | ❌ 불필요 |
| **트리거** | "최신 문서", "API 문서", "라이브러리 문서" |

**사용 예시**:
- "React 18의 useTransition 사용법 알려줘" → 최신 공식 문서 기반 답변
- "Next.js 14 App Router 문서 확인해줘" → 공식 문서에서 정확한 정보 제공
- "Tailwind CSS의 새로운 기능 찾아줘" → 최신 버전 문서 참조

**왜 필요한가?**
AI가 학습한 정보는 과거 시점이므로, 최신 라이브러리 문서를 실시간으로 조회하여 정확한 코드 제안 가능

---

#### 2. Sequential Thinking - 복잡한 문제 분석

```bash
npx -y @anthropic/mcp-sequential-thinking
```

| 항목 | 내용 |
|------|------|
| **용도** | 복잡한 문제를 단계별로 분석하고 추론 |
| **API 키** | ❌ 불필요 |
| **트리거** | "분석해줘", "단계별로", "추론", "복잡한 문제" |

**사용 예시**:
- "이 버그의 원인을 단계별로 분석해줘" → 체계적인 디버깅 프로세스
- "이 아키텍처의 장단점을 분석해줘" → 논리적인 비교 분석
- "이 알고리즘의 시간 복잡도를 추론해줘" → 단계별 계산

**왜 필요한가?**
복잡한 문제를 한번에 풀지 않고, 단계별로 나눠서 사고하면 더 정확한 결과 도출

---

#### 3. Playwright - 브라우저 자동화

```bash
npx -y @anthropic/mcp-playwright
```

| 항목 | 내용 |
|------|------|
| **용도** | 브라우저 자동화, E2E 테스트, 웹 스크래핑, 스크린샷 |
| **API 키** | ❌ 불필요 |
| **트리거** | "브라우저", "테스트", "E2E", "스크린샷", "웹페이지 확인" |

**사용 예시**:
- "이 웹사이트의 스크린샷 찍어줘" → 실제 렌더링된 화면 캡처
- "로그인 → 대시보드 이동 테스트 만들어줘" → E2E 테스트 자동 생성
- "이 페이지의 모든 링크 확인해줘" → 브라우저에서 실제 크롤링
- "모바일 화면에서 어떻게 보이는지 확인해줘" → 반응형 테스트

**왜 필요한가?**
코드만 보고 추측하지 않고, 실제 브라우저에서 동작을 확인하여 정확한 디버깅 가능

---

### 🟡 권장 MCP (유용함)

특정 작업에서 생산성을 크게 향상시키는 MCP입니다.

---

#### 4. Exa Search - 실시간 웹 검색

```bash
npx -y exa-mcp-server
```

| 항목 | 내용 |
|------|------|
| **용도** | 실시간 웹 검색, 논문/코드 검색, 최신 정보 조회 |
| **API 키** | ✅ 필요 (https://exa.ai) |
| **트리거** | "검색", "찾아줘", "최신 정보", "인터넷에서" |

**환경 변수 설정**:
```powershell
# Windows
[System.Environment]::SetEnvironmentVariable("EXA_API_KEY", "your_key", "User")

# Mac/Linux
export EXA_API_KEY="your_key"
```

**사용 예시**:
- "2024년 React 트렌드 검색해줘" → 최신 블로그/뉴스 검색
- "이 에러 메시지 해결법 찾아줘" → Stack Overflow, GitHub Issues 검색
- "비슷한 오픈소스 프로젝트 찾아줘" → GitHub 검색
- "이 기술에 대한 논문 찾아줘" → 학술 자료 검색

**왜 필요한가?**
AI의 지식은 학습 시점까지만 유효하므로, 실시간 웹 검색으로 최신 정보 보완

---

#### 5. Memory - 대화 기억 유지

```bash
npx -y @modelcontextprotocol/server-memory
```

| 항목 | 내용 |
|------|------|
| **용도** | 세션 간 대화 기억, 프로젝트 컨텍스트 저장 |
| **API 키** | ❌ 불필요 |
| **트리거** | "기억해줘", "저장해줘", "이전에 말한 거" |

**사용 예시**:
- "이 프로젝트 설정 기억해줘" → 다음 세션에서도 유지
- "내가 선호하는 코딩 스타일 저장해줘" → 일관된 코드 생성
- "이전에 논의한 아키텍처 뭐였지?" → 과거 대화 참조

**왜 필요한가?**
새 세션마다 처음부터 설명하지 않아도, 이전 맥락을 기억하여 연속적인 작업 가능

---

#### 6. GitHub - GitHub 연동

```bash
npx -y @anthropic/mcp-github
```

| 항목 | 내용 |
|------|------|
| **용도** | GitHub 이슈, PR, 코드 검색, 저장소 관리 |
| **API 키** | ✅ 필요 (GitHub Personal Access Token) |
| **트리거** | "GitHub", "이슈", "PR", "저장소" |

**환경 변수 설정**:
```powershell
# Windows
[System.Environment]::SetEnvironmentVariable("GITHUB_TOKEN", "your_token", "User")
```

**사용 예시**:
- "이 저장소의 열린 이슈 확인해줘" → 이슈 목록 조회
- "PR 리뷰 코멘트 작성해줘" → PR에 직접 코멘트
- "비슷한 이슈 있는지 검색해줘" → 중복 이슈 확인
- "이 저장소의 README 분석해줘" → 저장소 구조 파악

**왜 필요한가?**
GitHub UI를 오가지 않고, 대화하면서 바로 이슈/PR 관리 가능

---

#### 7. Notion - 노션 연동

```bash
npx -y @anthropic/mcp-notion
```

| 항목 | 내용 |
|------|------|
| **용도** | 노션 페이지 읽기/쓰기, 데이터베이스 조회 |
| **API 키** | ✅ 필요 (https://www.notion.so/my-integrations) |
| **트리거** | "노션", "Notion", "페이지", "문서" |

**환경 변수 설정**:
```powershell
# Windows
[System.Environment]::SetEnvironmentVariable("NOTION_API_KEY", "your_key", "User")
```

**사용 예시**:
- "노션에서 프로젝트 문서 가져와줘" → 기획서/설계서 참조
- "이 내용 노션에 정리해줘" → 자동 문서화
- "노션 데이터베이스에서 할일 목록 확인해줘" → 태스크 관리

**왜 필요한가?**
노션에 정리해둔 기획서, 설계서, 요구사항을 직접 참조하여 정확한 구현

---

### 🟢 선택 MCP (특정 용도)

특정 기술 스택이나 서비스를 사용할 때 유용한 MCP입니다.

---

#### 8. Figma - 디자인 파일 연동

Figma 연동 URL (Cursor에 직접 추가):
```
https://mcp.figma.com/mcp
```

| 항목 | 내용 |
|------|------|
| **용도** | Figma 디자인 파일 읽기, 스타일 추출, UI 코드 생성 |
| **API 키** | ✅ 필요 (Figma Personal Access Token) |
| **트리거** | "피그마", "Figma", "디자인", "UI" |

**사용 예시**:
- "피그마 디자인대로 컴포넌트 만들어줘" → 디자인 → 코드 변환
- "이 디자인의 색상 팔레트 추출해줘" → 스타일 가이드 생성
- "디자인과 현재 구현 비교해줘" → 디자인 검증

---

#### 9. TalkToFigma - Figma 실시간 편집

```bash
npx cursor-talk-to-figma-mcp@latest
```

| 항목 | 내용 |
|------|------|
| **용도** | Figma 플러그인과 연동하여 디자인을 실시간으로 편집, 요소 생성/수정 |
| **API 키** | ❌ 불필요 (Figma 플러그인 설치 필요) |
| **트리거** | "피그마 편집", "디자인 수정", "요소 추가" |

**설치 방법**:
1. Cursor에 MCP 추가: `npx cursor-talk-to-figma-mcp@latest`
2. Figma에서 "Cursor Talk" 플러그인 설치 (Community에서 검색)
3. Figma에서 플러그인 실행 → WebSocket 연결 대기
4. Cursor에서 "피그마에 연결해줘" 요청

**사용 예시**:
- "피그마에 버튼 컴포넌트 추가해줘" → Figma에 직접 요소 생성
- "선택한 요소의 색상을 파란색으로 바꿔줘" → 실시간 스타일 변경
- "이 디자인 요소들을 정렬해줘" → 레이아웃 자동 조정
- "텍스트 내용을 '새로운 제목'으로 변경해줘" → 텍스트 실시간 편집

**Figma vs TalkToFigma 차이**:
| | Figma MCP | TalkToFigma |
|---|-----------|-------------|
| **기능** | 읽기 전용 (디자인 정보 조회) | 읽기 + 쓰기 (실시간 편집) |
| **API 키** | ✅ 필요 | ❌ 불필요 |
| **플러그인** | 불필요 | ✅ 필요 (Figma 플러그인) |
| **용도** | 디자인 → 코드 변환 | 코드 → 디자인 생성/편집 |

**왜 필요한가?**
Figma MCP는 디자인을 읽기만 하지만, TalkToFigma는 AI가 디자인을 직접 만들고 수정할 수 있어 디자인-개발 워크플로우 혁신

---

#### 10. Supabase - 데이터베이스 연동

```bash
npx -y @anthropic/mcp-supabase
```

| 항목 | 내용 |
|------|------|
| **용도** | Supabase 데이터베이스 쿼리, 테이블 관리, Edge Functions |
| **API 키** | ✅ 필요 (Supabase Project API Key) |
| **트리거** | "Supabase", "DB", "데이터베이스", "쿼리" |

**사용 예시**:
- "users 테이블 구조 확인해줘" → 스키마 조회
- "이 쿼리 실행해줘" → 직접 SQL 실행
- "Edge Function 배포해줘" → 서버리스 함수 관리

---

#### 11. Slack - 슬랙 연동

```bash
npx -y @anthropic/mcp-slack
```

| 항목 | 내용 |
|------|------|
| **용도** | Slack 메시지 전송, 채널 조회, 알림 |
| **API 키** | ✅ 필요 (Slack Bot Token) |
| **트리거** | "슬랙", "Slack", "메시지", "채널" |

**사용 예시**:
- "이 내용 #dev 채널에 공유해줘" → 메시지 전송
- "오늘 논의된 내용 요약해서 슬랙에 올려줘" → 자동 요약 및 공유

---

#### 12. Brave Search - 무료 웹 검색 (Exa 대안)

```bash
npx -y @anthropic/mcp-brave-search
```

| 항목 | 내용 |
|------|------|
| **용도** | 웹 검색 (Exa의 무료 대안) |
| **API 키** | ✅ 필요 (https://brave.com/search/api/) - 무료 티어 있음 |
| **트리거** | "검색", "찾아줘" |

**왜 사용하나?**
Exa가 유료라면, Brave Search는 무료 티어로 기본적인 웹 검색 가능

---

---

#### 13. Filesystem - 로컬 파일 시스템 확장

```bash
npx -y @anthropic/mcp-filesystem
```

| 항목 | 내용 |
|------|------|
| **용도** | 로컬 파일 시스템 접근 확장 (특정 폴더 외부 접근) |
| **API 키** | ❌ 불필요 |
| **트리거** | "파일", "폴더", "디렉토리" |

**왜 사용하나?**
Cursor의 기본 파일 접근 범위를 넘어서 시스템 전체 파일에 접근 필요시

---

#### 14. PostgreSQL - PostgreSQL 직접 연결

```bash
npx -y @anthropic/mcp-postgres
```

| 항목 | 내용 |
|------|------|
| **용도** | PostgreSQL 데이터베이스 직접 연결 및 쿼리 |
| **API 키** | ✅ 필요 (DB 연결 정보) |
| **트리거** | "PostgreSQL", "DB", "쿼리" |

**환경 변수**:
```bash
export DATABASE_URL="postgresql://user:password@host:port/database"
```

---

#### 15. Docker - 컨테이너 관리

```bash
npx -y @anthropic/mcp-docker
```

| 항목 | 내용 |
|------|------|
| **용도** | Docker 컨테이너 관리, 이미지 빌드 |
| **API 키** | ❌ 불필요 (Docker 설치 필요) |
| **트리거** | "Docker", "컨테이너", "이미지" |

**사용 예시**:
- "현재 실행 중인 컨테이너 확인해줘"
- "이 Dockerfile 빌드해줘"
- "컨테이너 로그 확인해줘"

---

## ⚠️ MCP 활성화 제한 및 전략

### 제한 사항

**Cursor는 동시에 약 6-7개 MCP만 안정적으로 활성화 가능합니다.**
- 그 이상 활성화 시 성능 저하, 충돌, 에러 발생 가능
- 모든 MCP를 항상 켜두는 것은 권장하지 않음

### 권장 전략

#### 항상 활성화 (핵심 5개)
| MCP | 이유 |
|-----|------|
| **Context7** | 최신 라이브러리 문서 조회 (AI 지식 보완 필수) |
| **Exa Search** | 실시간 웹 검색 (최신 정보) |
| **Sequential Thinking** | 복잡한 문제 분석 |
| **Playwright** | 브라우저 테스트/스크린샷 |
| **Memory** | 세션 간 컨텍스트 유지 |

#### 상황별 활성화 (필요시 ON/OFF)
| MCP | 언제 활성화 |
|-----|------------|
| **GitHub** | 이슈/PR 작업 시 |
| **Notion** | 노션 문서 연동 시 |
| **Figma** | 디자인 파일 참조 시 |
| **TalkToFigma** | 디자인 직접 편집 시 |
| **Supabase/PostgreSQL** | DB 작업 시 |
| **Slack** | 팀 커뮤니케이션 시 |

#### 프로젝트 타입별 조합 예시
```
웹 프론트엔드:
  ✅ Context7, Exa, Sequential Thinking, Playwright, Memory
  + Figma (디자인 참조 시)

풀스택:
  ✅ Context7, Exa, Sequential Thinking, Playwright, Memory
  + Supabase 또는 PostgreSQL (DB 작업 시)

협업/문서화:
  ✅ Context7, Exa, Sequential Thinking, Memory
  + Notion, GitHub, Slack (필요시)

디자인 시스템:
  ✅ Context7, Sequential Thinking, Playwright, Memory
  + Figma, TalkToFigma
```

---

## 🔄 MCP 트리거 매핑 요약

| 사용자 입력 | 매핑되는 MCP |
|-------------|--------------|
| "최신 React 문서" | Context7 |
| "검색해줘", "찾아줘" | Exa Search |
| "분석해줘", "단계별로" | Sequential Thinking |
| "브라우저로", "스크린샷" | Playwright |
| "기억해줘", "저장해줘" | Memory |
| "GitHub 이슈" | GitHub |
| "노션에서", "노션으로" | Notion |
| "피그마 디자인" | Figma |
| "피그마 편집", "요소 추가" | TalkToFigma |
| "DB에서", "쿼리" | Supabase/PostgreSQL |
| "슬랙으로" | Slack |

---

## 🎯 권장 설치 순서

### Phase 1: 필수 (API 키 불필요) - 4개
```bash
npx -y @upstash/context7-mcp              # 또는 URL: https://mcp.context7.com/mcp
npx -y @anthropic/mcp-sequential-thinking
npx -y @anthropic/mcp-playwright
npx -y @modelcontextprotocol/server-memory
```

### Phase 2: 권장 (API 키 필요) - 3개
```bash
npx -y exa-mcp-server          # Exa API 키
npx -y @anthropic/mcp-github   # GitHub Token
npx -y @anthropic/mcp-notion   # Notion API 키
```

### Phase 3: 디자인 작업시 - 2개
```bash
# Figma (읽기 전용) - URL로 추가
# https://mcp.figma.com/mcp

# TalkToFigma (실시간 편집)
npx cursor-talk-to-figma-mcp@latest
```

### Phase 4: 기타 필요시
```bash
npx -y @anthropic/mcp-supabase # Supabase API 키
npx -y @anthropic/mcp-slack    # Slack Bot Token
npx -y @anthropic/mcp-postgres # PostgreSQL 연결
```

---

## ❓ 문제 해결

### MCP가 작동하지 않을 때

1. **Node.js 확인**: `node --version` (18+ 필요)
2. **Cursor 재시작**: MCP 추가 후 재시작 필요
3. **환경 변수 확인**: API 키가 필요한 MCP는 환경 변수 설정 필요
4. **MCP 로그 확인**: Cursor 개발자 도구에서 에러 확인

### 특정 MCP 비활성화

Settings → Features → MCP Servers → 해당 서버 토글 OFF

---

**이 가이드를 따라 MCP를 설치하면 Cursor AI의 기능을 최대한 활용할 수 있습니다.**
