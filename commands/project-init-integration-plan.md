# 프로젝트 초기화 3단계 연동 계획서

**목적**: 유저룰스, 유저커맨더, 프로젝트룰스의 완전한 연동을 통한 최고의 전문기법 기반 프로젝트 초기화 시스템

**상태**: 계획 단계 (사용자 승인 대기)

---

## 🎯 핵심 목표

1. **3단계 모두에서 티키타카 (대화) 필수**
2. **인류 최고의 전문기법 적용** (Belbin, Adversarial Collaboration, Red Team/Blue Team, NASA Mission Control)
3. **완전한 연동**: 유저룰스 → 유저커맨더 → 프로젝트룰스

---

## 📋 시스템 아키텍처

### 계층 구조

```
🏛️ 유저룰스 (절대적 상급 팀 - 하나님 역할)
├── 00_MASTER_RULES.md (트리거 감지, 절대적 권위)
└── 05_AGENT_ROLES.md (상급 팀 정의)
    ↓ (지도 및 감독)
🔧 유저커맨더 (실행 계층)
├── project-commands.md (실행 코드)
├── project-init-guide.md (대화 프로세스 가이드)
└── agent-teams.md (팀 생성 가이드)
    ↓ (실행 및 생성)
📁 프로젝트룰스 (프로젝트별 설정)
├── .cursor/rules/AGENT_Teams.mdc (에이전트 팀 구성)
├── .cursor/rules/PROJECT_SETTINGS.mdc (프로젝트 세부 설정)
├── .cursor/rules/TECH_STACK.mdc (기술 스택 상세)
└── .cursor/rules/ARCHITECTURE.mdc (아키텍처 설계)
```

---

## 📋 3단계 상세 연동 계획

### 1단계: 범주와 방향성 파악 (티키타카 필수)

#### 질문 체계 (사용자 중심 - 비즈니스/목적 중심)

**핵심 원칙**: 사용자가 답할 수 있는 비즈니스/목적 질문만, 기술적 결정은 AI가 제안

**1. 프로젝트 목적 (Why)**
- "이 프로젝트가 해결하려는 핵심 문제는 무엇인가요?"
- "사용자가 이 프로젝트를 통해 달성하고 싶은 것은 무엇인가요?"

**2. 프로젝트 범주 (What)**
- "이 프로젝트는 어떤 종류인가요?" (웹사이트/앱/API/데이터 등)
- "비슷한 사이트/앱이 있나요?"

**3. 핵심 기능 (What)**
- "필수로 들어가야 하는 기능은 무엇인가요?"
- "나중에 추가해도 되는 기능은 무엇인가요?"

**4. 대상 사용자 (Who)**
- "주로 누가 사용하나요?"
- "사용자들이 어떤 기기를 주로 사용하나요?"

**5. 프로젝트 규모 (Scale)**
- "얼마나 큰 규모인가요?"
- "단계별로 진행할 계획인가요?"

**6. 제약사항 (Constraints)**
- "기존에 사용 중인 시스템이 있나요?"
- "특별한 제약사항이 있나요?"

---

### 2단계: 프로젝트 에이전트 팀 설정 (AI 최고 실력자 주도)

#### 인류 최고 기법 적용

- **Belbin Team Roles**: 9가지 팀 역할 이론으로 최적 팀 구성
- **Adversarial Collaboration**: 논쟁 기반 협업 구조 설계
- **Red Team/Blue Team**: 적대적 검증 팀 포함
- **NASA Mission Control**: VETO 권한 시스템 설계

#### 프로젝트 타입별 최적 팀 구성

**웹사이트/홈페이지**: Frontend, Content, SEO, Infrastructure, Testing, Security 팀
**웹 애플리케이션**: Frontend, Backend, Database, Infrastructure, Testing, Security, UX 팀
**API/서비스**: API Design, Backend, Infrastructure, Testing, Security, Monitoring 팀

---

### 3단계: 팀 관점에서 세부 룰스 구축 (유저와 에이전트 팀 티키타카)

#### 티키타카 체계

**프로세스**:
1. 각 팀이 순차적으로 유저와 대화
2. 팀별 비즈니스 질문 → 유저 답변
3. 팀이 인류 최고 기법으로 제안
4. 유저와 대화로 최종 확정

**각 팀의 제안 형식**:
- "Frontend Team 제안: React + TypeScript + Tailwind CSS를 사용합니다"
  - "이유: [인류 최고 기법 기반 설명]"

---

## 📋 출력 파일

**2단계**: `.cursor/rules/AGENT_Teams.mdc`
**3단계**: 
- `.cursor/rules/PROJECT_SETTINGS.mdc`
- `.cursor/rules/TECH_STACK.mdc`
- `.cursor/rules/ARCHITECTURE.mdc`

---

**이 계획서는 프로젝트 초기화 3단계 연동의 완전한 설계를 제공합니다.**
