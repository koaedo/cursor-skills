# Cursor Skills

Cursor AI를 위한 **원클릭 설치** 규칙(Rules), 스킬(Skills), 커맨드 라이브러리 모음입니다.

## 🚀 원클릭 설치

```bash
# 1. 클론
git clone https://github.com/koaedo/cursor-skills.git
cd cursor-skills

# 2. 설치 (이것만 실행하면 끝!)
.\windows_install.ps1     # Windows
./mac_install.sh          # Mac/Linux
```

**설치되는 내용**:
- ✅ MDC 규칙 (유저룰스 포함) → `~/.cursor/rules/`
- ✅ 커맨드 라이브러리 → `~/.cursor/_COMMAND_LIBRARY/`
- ✅ MCP 서버 가이드

---

## 📦 포함된 내용

### MDC 규칙 (`.cursor/rules/`)

| 카테고리 | 설명 | 파일 수 |
|----------|------|---------|
| `00-core/` | 핵심 규칙 (유저룰스 포함, 항상 적용) | 6개 |
| `10-language/` | 언어별 규칙 (TS, JS, Python, React) | 5개 |
| `20-skills/` | 스킬 (디버깅, 보안, TDD 등) | 12개 |
| `30-project/` | 프로젝트 규칙 | 1개 |

### 핵심 규칙 (00-core/) - 기존 유저룰스 포함!

| 파일 | 설명 |
|------|------|
| `master-rules.mdc` | 마스터 룰스 (사용자 복종, MCP 활용, 검증 데이터) |
| `file-management.mdc` | 파일/폴더 관리 규칙 (파일명, 폴더명 규칙) |
| `agent-roles.mdc` | 에이전트 팀 시스템 (총괄, PM, 관리자, 감사) |
| `checkpoint.mdc` | 체크포인트 시스템 |
| `context-compress.mdc` | 컨텍스트 압축 |
| `session-management.mdc` | 세션 관리 |

### 스킬 목록 (20-skills/) - 12개

- **react-best-practices** - React 성능 최적화
- **web-design-guidelines** - UI/UX, 접근성
- **code-review** - 코드 리뷰 체크리스트
- **tdd-workflow** - 테스트 주도 개발
- **frontend-design** - 컴포넌트 설계
- **api-design** - RESTful API 설계
- **debugging-workflow** - 디버깅 프로세스
- **security-audit** - 웹 보안 감사 (OWASP Top 10)
- **documentation** - 코드 문서화
- **git-workflow** - Git 브랜치 전략
- **error-handling** - 에러 처리 패턴
- **performance-optimization** - 웹 성능 최적화

### 커맨드 라이브러리 (`_COMMAND_LIBRARY/`) - 6개

| 파일 | 설명 |
|------|------|
| `agent-external_evaluation.md` | 외부 평가 시스템 (BIG HAND/GRIM REAPER) |
| `agent-teams.md` | 에이전트 팀 생성 가이드 |
| `checkpoint-commands.md` | 체크포인트 커맨드 |
| `mcp-command.md` | MCP 서버 트리거 매핑 |
| `project-commands.md` | 프로젝트 커맨드 모음 |
| `project-endpoint.md` | 세션 핸드오프/재개 |

---

## 📁 설치 위치

| 항목 | 위치 |
|------|------|
| MDC 규칙 | `~/.cursor/rules/` |
| 커맨드 라이브러리 | `~/.cursor/_COMMAND_LIBRARY/` |
| 백업 | `~/.cursor/_backup_YYYYMMDD_HHMMSS/` |

---

## 🔄 업데이트 방법

```bash
cd cursor-skills
git pull

# 다시 설치 (기존 설정 자동 백업)
.\windows_install.ps1  # Windows
./mac_install.sh       # Mac/Linux
```

---

## ⚙️ 설치 옵션

### 규칙 & 커맨드 라이브러리 설치

```powershell
# Windows
.\windows_install.ps1           # 전체 설치 (권장)
.\windows_install.ps1 -Project  # 현재 프로젝트에만 설치
.\windows_install.ps1 -NoBackup # 백업 건너뛰기
```

```bash
# Mac/Linux
./mac_install.sh           # 전체 설치 (권장)
./mac_install.sh --project # 현재 프로젝트에만 설치
./mac_install.sh --no-backup # 백업 건너뛰기
```

### MCP 설치

```powershell
# Windows
.\windows_mcp_install.ps1       # 필수 MCP만 설치
.\windows_mcp_install.ps1 -All  # 모든 MCP 설치
.\windows_mcp_install.ps1 -List # 목록 확인
```

```bash
# Mac/Linux
./mac_mcp_install.sh        # 필수 MCP만 설치
./mac_mcp_install.sh --all  # 모든 MCP 설치
./mac_mcp_install.sh --list # 목록 확인
```

---

## 🛠️ MCP 서버 설정

### 🚀 MCP 원클릭 설치 (권장)

이미 설치된 MCP는 건너뛰고, 없는 것만 자동으로 추가합니다.

```bash
# 필수 MCP만 설치 (API 키 불필요)
.\windows_mcp_install.ps1     # Windows
./mac_mcp_install.sh          # Mac/Linux

# 모든 MCP 설치 (API 키 필요한 것 포함)
.\windows_mcp_install.ps1 -All
./mac_mcp_install.sh --all

# 설치된 MCP 목록 확인
.\windows_mcp_install.ps1 -List
./mac_mcp_install.sh --list
```

### 📋 수동 설정 방법

1. Cursor Settings (`Ctrl+,`) → Features → MCP Servers
2. `+ Add new global MCP server` 클릭
3. 아래 명령어 입력

### 🔴 필수 MCP (API 키 불필요)

```bash
npx -y @upstash/context7-mcp              # 라이브러리 최신 문서
npx -y @anthropic/mcp-sequential-thinking # 복잡한 추론/분석
npx -y @anthropic/mcp-playwright          # 브라우저 자동화/테스트
npx -y @modelcontextprotocol/server-memory # 대화 기억 유지
```

### 🟡 권장 MCP (API 키 필요)

```bash
npx -y exa-mcp-server          # 실시간 웹 검색 (EXA_API_KEY)
npx -y @anthropic/mcp-github   # GitHub 연동 (GITHUB_TOKEN)
npx -y @anthropic/mcp-notion   # 노션 연동 (NOTION_API_KEY)
```

### MCP 카테고리

| 분류 | MCP | 용도 |
|------|-----|------|
| 🔴 필수 | Context7 | 라이브러리 최신 문서 조회 |
| 🔴 필수 | Sequential Thinking | 복잡한 문제 단계별 분석 |
| 🔴 필수 | Playwright | 브라우저 자동화/E2E 테스트 |
| 🔴 필수 | Memory | 세션 간 대화 기억 (server-memory) |
| 🟡 권장 | Exa Search | 실시간 웹 검색 |
| 🟡 권장 | GitHub | 이슈/PR 관리 |
| 🟡 권장 | Notion | 노션 문서 연동 |
| 🟢 선택 | Figma | 디자인 파일 연동 |
| 🟢 선택 | Supabase | 데이터베이스 연동 |

> 📖 **상세 가이드**: `_COMMAND_LIBRARY/mcp-command.md`
> 
> 각 MCP별 설치 방법, 사용 예시, API 키 설정 방법이 포함되어 있습니다.

---

## 📋 폴더 구조

```
cursor-skills/
├── .cursor/
│   └── rules/
│       ├── 00-core/           # 핵심 규칙 (유저룰스 포함!)
│       ├── 10-language/       # 언어별 규칙
│       ├── 20-skills/         # 스킬
│       └── 30-project/        # 프로젝트 규칙
│
├── _COMMAND_LIBRARY/          # 커맨드 라이브러리
├── 룰스모음/                   # 유저룰스 원본 (참고용)
│
├── windows_install.ps1        # 규칙/커맨드 설치 (Windows)
├── mac_install.sh             # 규칙/커맨드 설치 (Mac/Linux)
├── windows_mcp_install.ps1    # MCP 설치 (Windows)
├── mac_mcp_install.sh         # MCP 설치 (Mac/Linux)
└── README.md
```

---

## ❓ FAQ

### Q: 유저룰스는 어떻게 되나요?

**기존 유저룰스는 MDC 규칙 (`00-core/`)에 포함되어 있습니다.**

- `master-rules.mdc` ← 마스터 룰스
- `file-management.mdc` ← 파일/폴더 관리 규칙
- `agent-roles.mdc` ← 에이전트 팀 시스템

Settings > Rules에 따로 설정할 필요 없이, 설치만 하면 자동 적용됩니다.

### Q: 기존 설정은 어떻게 되나요?

설치 시 자동으로 백업됩니다 (`~/.cursor/_backup_YYYYMMDD_HHMMSS/`).

### Q: 다른 컴퓨터에서 사용하려면?

```bash
git clone https://github.com/koaedo/cursor-skills.git
cd cursor-skills
.\windows_install.ps1      # 규칙/커맨드 설치
.\windows_mcp_install.ps1  # MCP 설치
```

### Q: MCP가 이미 설치되어 있으면?

**이미 설치된 MCP는 자동으로 건너뜁니다.**

MCP 설치 스크립트는 `~/.cursor/mcp.json`을 확인하여 중복 설치를 방지합니다.

```bash
# 현재 설치된 MCP 확인
.\windows_mcp_install.ps1 -List
```

### Q: MCP가 설치 안 되어 있으면 어떻게 되나요?

**AI가 대체 방법으로 작업하고, 설치를 권장합니다.**

예시:
- Exa 미설치 + "검색해줘" → 내장 WebSearch 사용 + "Exa 설치 권장" 안내
- Context7 미설치 + "문서 확인해줘" → AI 기존 지식 사용 + "최신 문서 아님" 안내

---

## 📝 라이선스

MIT License
