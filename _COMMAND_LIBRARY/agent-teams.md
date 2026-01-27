# 프로젝트 에이전트 팀 생성 커맨드

**참조 문서**: 이 파일은 프로젝트별 에이전트 팀 생성 가이드를 제공합니다.

## 🎯 목적

프로젝트 성격에 맞는 최고의 에이전트 팀을 질문 기반으로 생성하고, 프로젝트 룰스에 자동 등록

---

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

## 📋 프로젝트 에이전트 팀 생성 프로세스

### 단계 1: 프로젝트 성격 분석 (질문 기반)

**질문 목록** (순차적으로 질문):

1. **프로젝트 타입**:
   - 투자/금융 (퀀트, 트레이딩, 포트폴리오)
   - 웹 개발 (프론트엔드, 백엔드, 풀스택)
   - 데이터 분석 (ML, AI, 데이터 파이프라인)
   - API/서비스 (마이크로서비스, REST API, GraphQL)
   - 일반 (기타)

2. **핵심 기능 영역** (복수 선택 가능)

3. **복잡도 레벨**:
   - 단순 (1-3개 팀)
   - 중간 (4-6개 팀)
   - 복잡 (7-9개 팀)

4. **특수 요구사항**:
   - VETO 권한 필요 팀 (Risk, QA, Red Team)
   - 논쟁 기반 협업 필요 여부
   - 실시간 모니터링 필요 여부

### 단계 2: 팀 구성 생성

**팀 템플릿** (프로젝트 타입별):

#### 투자/금융 프로젝트
- Quant Strategy Team (퀀트 전략)
- Risk & Compliance Team (리스크 & 컴플라이언스) - VETO 권한
- AI & ML Team (인공지능 & 머신러닝)
- Data Engineering Team (데이터 엔지니어링)
- Testing & QA Team (테스트 & 품질보증) - VETO 권한
- Red Team (적대적 검증) - VETO 권한

#### 웹 개발 프로젝트
- Frontend Team (프론트엔드)
- Backend Team (백엔드)
- API Team (API 설계)
- Testing & QA Team (테스트 & 품질보증) - VETO 권한
- UX & Design Team (사용자 경험 & 디자인)
- Security Team (보안) - VETO 권한

---

## 📋 유저커맨드 헤더

```bash
# @command: create_project_agent_teams
# @purpose: 프로젝트 성격에 맞는 최고의 에이전트 팀 생성 및 프로젝트 룰스 등록
# @usage: 프로젝트 초기화 시 또는 "에이전트 팀 생성" 요청 시
# @keywords: 에이전트팀,프로젝트팀,팀생성,agent,team,project,구성
# @triggers: "에이전트 팀 생성", "프로젝트 팀 구성", "agent teams", "팀 만들기"
# @background: false
# @dependencies: common, sync_time
# @output: .cursor/rules/AGENT_Teams.mdc 생성
```

---

**이 문서는 프로젝트별 에이전트 팀 생성 가이드를 제공합니다.**
