# Cursor Skills & Commands

**Cursor AI 코딩 어시스턴트**를 위한 전역 설정 모음입니다.

새 컴퓨터에서도 동일한 AI 행동 규칙과 스킬을 빠르게 설정할 수 있습니다.

---

## 🤔 이 프로젝트는 무엇인가요?

### Cursor란?

[Cursor](https://cursor.sh)는 AI가 내장된 코드 에디터입니다. VS Code를 기반으로 하며, Claude/GPT 같은 AI와 대화하면서 코드를 작성할 수 있습니다.

### 왜 이 프로젝트가 필요한가요?

Cursor AI는 기본적으로 범용적인 응답을 합니다. 하지만 다음과 같은 **커스터마이징**을 하면 훨씬 효율적으로 사용할 수 있습니다:

| 문제 | 해결책 |
|------|--------|
| AI가 매번 다른 스타일로 코드를 작성함 | **유저룰스**로 일관된 규칙 적용 |
| 반복적인 작업을 매번 설명해야 함 | **커맨드**로 재사용 가능한 명령어 정의 |
| 특정 언어/프레임워크 지식이 부족함 | **스킬**로 전문 지식 제공 |
| 새 컴퓨터마다 설정을 다시 해야 함 | **이 저장소**로 한 번에 설정 |

### 이 프로젝트의 구성

```
┌─────────────────────────────────────────────────────────────┐
│                    Cursor AI 설정                            │
├─────────────────────────────────────────────────────────────┤
│  1. User Rules (유저룰스)                                    │
│     → AI의 기본 행동 규칙                                    │
│     → Settings > Rules에 수동 붙여넣기                       │
│                                                              │
│  2. Commands (커맨드 라이브러리)                             │
│     → 재사용 가능한 명령어 모음                              │
│     → ~/.cursor/_COMMAND_LIBRARY/에 자동 설치               │
│                                                              │
│  3. Skills (스킬)                                            │
│     → 특정 작업을 위한 전문 가이드                           │
│     → ~/.cursor/skills-cursor/에 자동 설치                  │
└─────────────────────────────────────────────────────────────┘
```

---

## 📁 폴더 구조

```
cursor-skills/
├── user-rules/              # 유저룰스 (7개 파일)
│   ├── _combined.md         # 👉 합친 버전 (이것을 Settings > Rules에 복사)
│   ├── 00-master-rules.md   # 핵심 원칙
│   ├── 01-file-management.md
│   ├── 02-project-operations.md
│   ├── 03-agent-roles.md
│   ├── 04-command-library.md
│   ├── 05-file-link.md
│   └── 06-checkpoint.md
│
├── commands/                # 커맨드 라이브러리 (10개 파일)
│   ├── mcp-command.md
│   ├── checkpoint-commands.md
│   ├── agent-teams.md
│   └── ...
│
├── skills/                  # 스킬 (28개 폴더)
│   ├── javascript/SKILL.md
│   ├── typescript/SKILL.md
│   ├── react/SKILL.md
│   └── ...
│
├── _archive/                # 이전 버전 백업
│
├── windows_install.ps1      # Windows 전체 설치
├── mac_install.sh           # Mac/Linux 전체 설치
├── install-commands.ps1     # Windows 커맨드만 설치
├── install-commands.sh      # Mac/Linux 커맨드만 설치
├── install-skills.ps1       # Windows 스킬만 설치
├── install-skills.sh        # Mac/Linux 스킬만 설치
├── windows_mcp_install.ps1  # Windows MCP 설치
└── mac_mcp_install.sh       # Mac/Linux MCP 설치
```

---

## 🚀 설치 방법

### 1단계: 저장소 클론

```bash
git clone https://github.com/yourusername/cursor-skills.git
cd cursor-skills
```

### 2단계: 커맨드 & 스킬 설치 (자동)

**Windows (PowerShell):**
```powershell
# 전체 설치 (커맨드 + 스킬)
.\windows_install.ps1

# 또는 개별 설치
.\install-commands.ps1    # 커맨드만
.\install-skills.ps1      # 스킬만
```

**Mac/Linux (Terminal):**
```bash
# 전체 설치 (커맨드 + 스킬)
chmod +x mac_install.sh
./mac_install.sh

# 또는 개별 설치
chmod +x install-commands.sh install-skills.sh
./install-commands.sh     # 커맨드만
./install-skills.sh       # 스킬만
```

**설치 옵션:**
| 옵션 | Windows | Mac/Linux | 설명 |
|------|---------|-----------|------|
| 기본 | (없음) | (없음) | 파일별로 덮어쓸지 물어봄 |
| 모두 덮어쓰기 | `-Force` | `--force` | 기존 파일 모두 덮어쓰기 |
| 모두 건너뛰기 | `-Skip` | `--skip` | 기존 파일 모두 유지 |

### 3단계: 유저룰스 설정 (수동)

> ⚠️ **중요**: 유저룰스는 Cursor 설정에서 수동으로 붙여넣어야 합니다.

1. `user-rules/_combined.md` 파일 열기
2. 전체 내용 복사 (Ctrl+A → Ctrl+C)
3. Cursor 열기 → **Settings** (Ctrl+,) → **Rules** 탭
4. 내용 붙여넣기 (Ctrl+V)
5. 저장 (자동)

### 4단계: Cursor 재시작

설치 후 Cursor를 재시작하면 새로운 스킬이 인식됩니다.

### 5단계: MCP 설치 (선택사항)

MCP(Model Context Protocol)는 AI에게 외부 도구를 연결해주는 기능입니다.

```powershell
# Windows
.\windows_mcp_install.ps1

# Mac/Linux
./mac_mcp_install.sh
```

---

## 📋 유저룰스 상세 설명 (7개)

**유저룰스**는 AI의 기본 행동 규칙입니다. 모든 대화에 적용됩니다.

### 00-master-rules.md - 핵심 원칙

AI가 따라야 할 최우선 규칙입니다.

```markdown
주요 내용:
- 사용자 의도 최우선 존중
- 검증된 데이터만 사용 (뇌피셜 금지)
- 환각 방지 (추측으로 응답 금지)
- 기본 언어 한국어
```

**적용 예시:**
```
❌ Before: AI가 추측으로 라이브러리 버전을 알려줌
✅ After:  AI가 MCP로 최신 문서를 확인 후 응답
```

### 01-file-management.md - 파일/폴더 관리

일관된 파일 네이밍 규칙을 정의합니다.

```markdown
파일명 형식: [번호]_[기능명]_[YYYYMMDD_HHMMSS].확장자
예시: 0001_메인컴포넌트_20241129_143022.tsx

폴더명 형식: [번호]_[카테고리명]
예시: 00_code/, 01_문서/, 02_데이터/
```

### 02-project-operations.md - 프로젝트 운영 관리

AI가 백그라운드에서 프로젝트 상태를 모니터링합니다.

```markdown
주요 기능:
- 파일 변경 시 자동 로그 기록
- 진행상황 보고 (사용자 요청 시)
- !AGENT_System/ 폴더에 로그 저장
```

### 03-agent-roles.md - 에이전트 팀 시스템

AI가 여러 역할(팀)로 분리되어 협업합니다.

```markdown
상급 팀:
- 총괄 팀 (Chief): 전체 모니터링
- PM 팀: 일정 관리
- 관리자 팀: 효율성 분석
- 감사 팀: 품질 감사

이론적 배경:
- Belbin Team Roles (9가지 팀 역할)
- Red Team/Blue Team (적대적 검증)
- NASA Mission Control (VETO 권한)
```

### 04-command-library.md - 커맨드 라이브러리 활용

커맨드 라이브러리 검색 및 실행 방법입니다.

```markdown
검색 프로세스:
1. 사용자 요청 분석
2. @keywords 매칭으로 커맨드 검색
3. 가장 적합한 커맨드 실행
```

### 05-file-link.md - 파일 링크 종속관계

보고서/로그에 관련 파일 링크를 추가합니다.

```markdown
목적:
- 맥락관리: 어떤 파일을 참조했는지 추적
- 환각관리: 실제 파일 참조로 검증 가능
- 버전관리: 파일 버전과 보고서 연결
```

### 06-checkpoint.md - 체크포인트 시스템

작업 상태를 저장하고 복원합니다.

```markdown
사용법:
- "체크포인트 저장해줘" → 현재 상태 저장
- "체크포인트 복원해줘" → 이전 상태로 복원

권장 시점:
- 대규모 리팩토링 전
- 실험적 변경 전
- 중요 기능 완료 후
```

---

## 📋 커맨드 상세 설명 (10개)

**커맨드**는 재사용 가능한 명령어입니다. AI가 `@keywords`로 검색해서 실행합니다.

| 파일 | 용도 | 트리거 예시 |
|------|------|------------|
| `mcp-command.md` | MCP 서버 설치/사용 가이드 | "MCP 설치해줘", "Context7 연결" |
| `checkpoint-commands.md` | 체크포인트 저장/복원 | "작업 상태 저장", "롤백해줘" |
| `agent-teams.md` | 프로젝트 에이전트 팀 생성 | "에이전트 팀 만들어줘" |
| `agent-external_evaluation.md` | 외부 평가 시스템 | "외부 감사해줘" |
| `project-commands.md` | 프로젝트 관리 명령어 | "프로젝트 초기화" |
| `project-endpoint.md` | 프로젝트 종료점 관리 | "프로젝트 마무리" |
| `project-init-integration-plan.md` | 프로젝트 초기화 계획 | "새 프로젝트 시작" |
| `project-rules-templates.md` | 프로젝트 룰스 템플릿 | "룰스 템플릿 보여줘" |
| `user_command_guide.md` | 커맨드 생성 가이드 | "커맨드 만드는 법" |
| `README.md` | 커맨드 라이브러리 안내 | - |

**저장 위치:** `~/.cursor/_COMMAND_LIBRARY/`

---

## 📋 스킬 상세 설명 (28개)

**스킬**은 특정 작업을 위한 전문 가이드입니다. AI가 필요할 때 자동으로 참조합니다.

### 언어 (6개)

| 스킬 | 설명 | 사용 예시 |
|------|------|----------|
| `javascript` | ES6+ 문법, 비동기 처리, 모듈 시스템 | "JS로 API 호출 코드 작성해줘" |
| `typescript` | 타입 시스템, 제네릭, 인터페이스 | "TS 타입 정의해줘" |
| `python` | PEP 8 스타일, 가상환경, 패키지 관리 | "Python 클래스 만들어줘" |
| `php` | PSR-12 스타일, PDO, 보안 (XSS/SQL Injection 방지) | "PHP 클래스 만들어줘" |
| `sql` | 쿼리 최적화, JOIN, 인덱스, 트랜잭션 | "SQL 쿼리 작성해줘" |
| `bash-shell` | 스크립트 작성, 텍스트 처리, 자동화 | "Bash 스크립트 만들어줘" |

### 프레임워크 (5개)

| 스킬 | 설명 | 사용 예시 |
|------|------|----------|
| `react` | 컴포넌트 패턴, Hooks, 상태 관리 | "React 컴포넌트 만들어줘" |
| `react-best-practices` | 성능 최적화, 메모이제이션 | "React 성능 개선해줘" |
| `nextjs` | App Router, 서버 컴포넌트, API Routes | "Next.js 페이지 만들어줘" |
| `graphql` | 스키마 설계, Apollo Client, 프론트엔드 연동 | "GraphQL 쿼리 작성해줘" |
| `docker` | Dockerfile, Docker Compose, 멀티스테이지 빌드 | "Docker 설정해줘" |

### 스타일링 (3개)

| 스킬 | 설명 | 사용 예시 |
|------|------|----------|
| `css-scss` | BEM 네이밍, CSS 변수, Flexbox/Grid, SCSS 믹스인 | "CSS 스타일 작성해줘" |
| `tailwind` | 유틸리티 클래스, 반응형, 커스터마이징 | "Tailwind로 UI 만들어줘" |
| `frontend-design` | UI/UX 원칙, 접근성 | "UI 개선해줘" |

### 개발 워크플로우 (5개)

| 스킬 | 설명 | 사용 예시 |
|------|------|----------|
| `tdd-workflow` | Red-Green-Refactor 사이클 | "TDD로 개발해줘" |
| `git-workflow` | 브랜치 전략, 커밋 컨벤션 | "Git 브랜치 정리해줘" |
| `code-review` | 리뷰 체크리스트, 피드백 방법 | "이 코드 리뷰해줘" |
| `debugging-workflow` | 체계적 디버깅 프로세스 | "이 버그 찾아줘" |
| `documentation` | 문서화 가이드, JSDoc | "문서 작성해줘" |

### 품질/보안 (3개)

| 스킬 | 설명 | 사용 예시 |
|------|------|----------|
| `security-audit` | OWASP Top 10, 보안 체크리스트 | "보안 검사해줘" |
| `error-handling` | 에러 처리 패턴, 로깅 | "에러 처리 추가해줘" |
| `performance-optimization` | 성능 측정, 최적화 기법 | "성능 개선해줘" |

### API/문서 (3개)

| 스킬 | 설명 | 사용 예시 |
|------|------|----------|
| `api-design` | RESTful 설계, 버전 관리 | "API 설계해줘" |
| `web-design-guidelines` | 반응형 디자인, 색상 시스템 | "웹 디자인 가이드 적용해줘" |
| `markdown` | 문서 작성, README 템플릿, GFM | "README 작성해줘" |

### 시스템/관리 (3개)

| 스킬 | 설명 | 사용 예시 |
|------|------|----------|
| `checkpoint` | 상태 저장/복원 시스템 | "체크포인트 만들어줘" |
| `session-management` | 세션 상태 관리 | "세션 정리해줘" |
| `context-compress` | 토큰 절약, 컨텍스트 압축 | "대화 압축해줘" |

**저장 위치:** `~/.cursor/skills-cursor/`

---

## 🔧 MCP 서버 (선택사항)

**MCP(Model Context Protocol)**는 AI에게 외부 도구를 연결해주는 기능입니다.

| MCP | 용도 | 설명 |
|-----|------|------|
| Context7 | 문서 검색 | 최신 라이브러리 공식 문서 조회 |
| Exa Search | 웹 검색 | 실시간 웹 검색, 논문/GitHub 검색 |
| Playwright | 브라우저 | 웹 브라우저 자동화, 테스트 |
| Sequential Thinking | 추론 | 복잡한 문제 단계별 분석 |
| Memory | 기억 | 대화 간 컨텍스트 유지 |

상세 설치 가이드: `commands/mcp-command.md`

---

## 🔄 새 컴퓨터 설정 (5분 완료)

```bash
# 1. 저장소 클론
git clone https://github.com/yourusername/cursor-skills.git
cd cursor-skills

# 2. 커맨드 & 스킬 설치
.\windows_install.ps1      # Windows
./mac_install.sh           # Mac/Linux

# 3. 유저룰스 설정 (수동)
# user-rules/_combined.md 내용을
# Cursor > Settings > Rules에 붙여넣기

# 4. Cursor 재시작

# 5. (선택) MCP 설치
.\windows_mcp_install.ps1  # Windows
./mac_mcp_install.sh       # Mac/Linux
```

---

## 📚 이론적 배경

이 프로젝트의 에이전트 팀 시스템은 다음 연구를 기반으로 합니다:

### Belbin Team Roles
Meredith Belbin의 9가지 팀 역할 이론. 팀 내 다양한 역할(조정자, 실행자, 완결자 등)이 균형을 이룰 때 최고의 성과를 낸다는 연구.

### Adversarial Collaboration
서로 다른 견해를 가진 전문가들이 함께 연구하는 방법론. 논쟁을 통해 더 나은 결론에 도달.

### Red Team / Blue Team
사이버 보안에서 유래한 적대적 검증 방법. Red Team이 공격자 역할, Blue Team이 방어자 역할.

### NASA Mission Control
우주 임무 관제 시스템. 중요 결정에 대한 VETO(거부권) 시스템으로 안전성 확보.

---

## ❓ FAQ

### Q: 유저룰스는 왜 수동으로 설정해야 하나요?
Cursor의 Settings > Rules는 UI에서만 접근 가능합니다. 파일로 직접 접근할 수 없어서 수동 복사가 필요합니다.

### Q: 스킬이 Settings > Skills에 안 보여요
정상입니다. `~/.cursor/skills-cursor/`에 설치된 스킬은 "Agent Skills"로, Settings UI가 아닌 시스템 프롬프트에 자동 포함됩니다.

### Q: 기존 설정이 있는데 덮어써도 되나요?
`-Skip` 옵션으로 기존 파일을 유지하거나, 기본 모드에서 파일별로 선택할 수 있습니다.

### Q: 특정 스킬만 설치하고 싶어요
`install-skills.ps1`/`install-skills.sh` 실행 후, 각 스킬별로 `O`(덮어쓰기) 또는 `S`(건너뛰기)를 선택하세요.

---

## 🤝 기여하기

새로운 스킬이나 커맨드를 추가하고 싶다면:

1. 이 저장소를 Fork
2. 새 스킬: `skills/[스킬명]/SKILL.md` 생성
3. 새 커맨드: `commands/[커맨드명].md` 생성
4. Pull Request 제출

---

## 📝 라이선스

MIT License
