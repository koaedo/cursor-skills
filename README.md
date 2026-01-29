# Cursor Skills & Commands

Cursor AI 개발 환경을 위한 유저룰스, 커맨드 라이브러리, 스킬 모음입니다.

---

## 📁 폴더 구조

```
cursor-skills/
├── user-rules/           # 유저룰스 (Settings > Rules에 붙여넣기)
│   ├── _combined.md      # 👉 합친 버전 (이것을 복사)
│   ├── 00-master-rules.md       # 핵심 원칙
│   ├── 01-file-management.md    # 파일/폴더 관리
│   ├── 02-project-operations.md # 프로젝트 운영 관리
│   ├── 03-agent-roles.md        # 에이전트 팀 시스템
│   ├── 04-command-library.md    # 커맨드 라이브러리
│   ├── 05-file-link.md          # 파일 링크 종속관계
│   └── 06-checkpoint.md         # 체크포인트 시스템
├── commands/             # 커맨드 라이브러리 (~/.cursor/_COMMAND_LIBRARY/)
│   ├── mcp-command.md
│   ├── checkpoint-commands.md
│   └── ...
├── skills/               # Cursor Skills (~/.cursor/skills-cursor/)
│   ├── javascript/
│   ├── typescript/
│   ├── react/
│   ├── python/
│   ├── tdd-workflow/
│   ├── security-audit/
│   ├── code-review/
│   └── checkpoint/
├── windows_install.ps1   # Windows 설치 스크립트
├── mac_install.sh        # Mac/Linux 설치 스크립트
├── windows_mcp_install.ps1  # MCP 설치 스크립트 (Windows)
└── mac_mcp_install.sh       # MCP 설치 스크립트 (Mac/Linux)
```

---

## 🚀 설치 방법

### 1. 저장소 클론

```bash
git clone https://github.com/koaedo/cursor-skills.git
cd cursor-skills
```

### 2. 자동 설치 (Commands & Skills)

**Windows (PowerShell):**
```powershell
.\windows_install.ps1
```

**Mac/Linux:**
```bash
chmod +x mac_install.sh
./mac_install.sh
```

### 3. 유저룰스 설정 (수동)

> **중요**: 유저룰스는 자동 설치가 불가능합니다. 수동으로 설정해야 합니다.

1. `user-rules/_combined.md` 파일을 열기
2. 전체 내용 복사
3. **Cursor > Settings > Rules**에 붙여넣기

### 4. MCP 설치 (선택)

**Windows:**
```powershell
.\windows_mcp_install.ps1
```

**Mac/Linux:**
```bash
chmod +x mac_mcp_install.sh
./mac_mcp_install.sh
```

---

## 📋 구성 요소

### 1. 유저룰스 (User Rules)

Cursor AI의 기본 행동 규칙입니다. **Settings > Rules**에서 설정합니다.

| 기능 | 설명 |
|------|------|
| 사용자 복종 원칙 | 사용자 의도 최우선 존중 |
| 검증 데이터 기반 | MCP 활용, 환각 방지 |
| 에이전트 팀 시스템 | 역할별 팀 협업 |
| 파일/폴더 관리 | 네이밍 규칙, 버전 관리 |

**저장 위치**: Cursor 클라우드 동기화 (자동)

### 2. 커맨드 라이브러리 (Commands)

재사용 가능한 명령어 모음입니다.

| 파일 | 기능 |
|------|------|
| `mcp-command.md` | MCP 설치/사용 가이드 |
| `checkpoint-commands.md` | 체크포인트 저장/복원 |
| `agent-teams.md` | 에이전트 팀 생성 |
| `project-commands.md` | 프로젝트 관리 |

**저장 위치**: `~/.cursor/_COMMAND_LIBRARY/`

### 3. 스킬 (Skills)

특정 작업을 위한 전문 가이드입니다.

| 스킬 | 설명 |
|------|------|
| `javascript` | JavaScript 모범 사례 |
| `typescript` | TypeScript 타입 시스템 |
| `react` | React 컴포넌트 패턴 |
| `python` | Python PEP 8 스타일 |
| `tdd-workflow` | 테스트 주도 개발 |
| `security-audit` | 보안 감사 체크리스트 |
| `code-review` | 코드 리뷰 가이드 |
| `checkpoint` | 체크포인트 시스템 |

**저장 위치**: `~/.cursor/skills-cursor/`

---

## 🔧 MCP 서버

권장 MCP 서버 목록입니다. 상세 가이드는 `commands/mcp-command.md` 참조.

| MCP | 용도 |
|-----|------|
| Context7 | 최신 라이브러리 문서 |
| Exa Search | 웹 검색, 리서치 |
| Playwright | 브라우저 테스트 |
| Sequential Thinking | 복잡한 추론 |
| Memory | 컨텍스트 기억 |

---

## 📚 리서치 출처 및 기능 정리

### 기존 룰스모음에서 계승

- **마스터 룰스**: 사용자 복종 원칙, 검증 데이터 기반 작업
- **파일/폴더 관리**: 네이밍 규칙, 버전 관리
- **에이전트 팀 시스템**: 총괄/PM/관리자/감사 팀

### 학술 연구 기반 추가

- **Belbin Team Roles**: 9가지 팀 역할 이론
- **Adversarial Collaboration**: 논쟁 기반 협업
- **Red Team/Blue Team**: 적대적 검증
- **NASA Mission Control**: VETO 권한 시스템

### 신규 기능

- **체크포인트 시스템**: 작업 상태 저장/복원
- **MCP 가이드**: 설치 및 폴백 로직
- **언어별 스킬**: JavaScript, TypeScript, Python, React
- **워크플로우 스킬**: TDD, 보안 감사, 코드 리뷰

---

## 🔄 새 컴퓨터 설정 순서

1. **저장소 클론** → `git clone`
2. **설치 스크립트 실행** → Commands & Skills 설치
3. **유저룰스 설정** → `_combined.md` 복사 → Settings > Rules
4. **MCP 설치** (선택) → 필요한 MCP만 설치

---

## 📝 라이선스

MIT License
