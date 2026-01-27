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

2. **핵심 기능 영역** (복수 선택 가능):
   - 전략/로직 (비즈니스 로직, 알고리즘)
   - 리스크 관리 (안전성, 검증, 컴플라이언스)
   - AI/ML (모델, 예측, 학습)
   - 데이터 (ETL, 파이프라인, 품질)
   - 실행/주문 (트랜잭션, 최적화)
   - 테스트/QA (백테스트, 검증, 품질)
   - 인프라 (DevOps, 배포, 모니터링)
   - UX/시각화 (대시보드, 인터페이스)
   - 보안/검증 (Red Team, 취약점)

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
- Execution & Order Team (실행 & 주문)
- Testing & QA Team (테스트 & 품질보증) - VETO 권한
- Infrastructure & DevOps Team (인프라 & 데브옵스)
- UX & Visualization Team (사용자 경험 & 시각화)
- Red Team (적대적 검증) - VETO 권한

#### 웹 개발 프로젝트
- Frontend Team (프론트엔드)
- Backend Team (백엔드)
- API Team (API 설계)
- Data Team (데이터 관리)
- Testing & QA Team (테스트 & 품질보증) - VETO 권한
- Infrastructure & DevOps Team (인프라 & 데브옵스)
- UX & Design Team (사용자 경험 & 디자인)
- Security Team (보안) - VETO 권한

#### 데이터 분석 프로젝트
- Data Engineering Team (데이터 엔지니어링)
- ML/AI Team (머신러닝 & AI)
- Analysis Team (분석)
- Visualization Team (시각화)
- Testing & QA Team (테스트 & 품질보증) - VETO 권한
- Infrastructure Team (인프라)
- Red Team (적대적 검증) - VETO 권한

### 단계 3: 팀 역할 정의

각 팀은 다음 정보를 포함:

```markdown
### 🧠 Team N: [팀명]

**역할**: [역할 설명]
**전문성**: [전문 분야]
**관점**: [핵심 관점]
**담당 영역**: [코드/폴더 경로]

**논쟁 포인트**:
- [다른 팀과의 논쟁 포인트]

**VETO 권한** (해당 시):
- [VETO 조건]
```

### 단계 4: 논쟁 규칙 정의

```markdown
## 논쟁 규칙 (Adversarial Collaboration)

### 1. 건설적 논쟁 원칙
- 인신공격 금지, 아이디어만 공격
- 반드시 **증거 기반** 주장
- 상대방 논점 먼저 요약 후 반박

### 2. 논쟁 해결 프로세스
1. 양측 주장 명확화
2. 증거 제시 (코드, 데이터, 논문)
3. 제3의 팀 중재 (필요시)
4. 실험/테스트로 검증
5. 결과 기반 합의

### 3. VETO 권한
| 팀 | VETO 조건 |
|----|----------|
| [팀명] | [조건] |
```

### 단계 5: 프로젝트 룰스 파일 생성

**파일 경로**: `.cursor/rules/AGENT_Teams.mdc`

**파일 형식**:
```markdown
---
description: "프로젝트별 에이전트 팀 구성 및 논쟁 기반 협업 규칙"
globs: ["**/*"]
alwaysApply: false
---

# 🏆 프로젝트 에이전트 팀 구성

[생성된 팀 구성 내용]

## 논쟁 규칙

[논쟁 규칙 내용]

## 팀 간 의존 관계

[의존 관계 다이어그램/설명]
```

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

## 📋 실행 프로세스

1. **프로젝트 분석**:
   - README.md, package.json, 폴더 구조 확인
   - 프로젝트 타입 자동 감지 (가능한 경우)

2. **질문 기반 팀 구성**:
   - 사용자에게 순차적으로 질문
   - 답변 기반으로 팀 구성 결정

3. **팀 역할 정의**:
   - 각 팀의 역할, 전문성, 관점 정의
   - 논쟁 포인트 및 VETO 권한 설정

4. **논쟁 규칙 생성**:
   - Adversarial Collaboration 규칙
   - VETO 권한 테이블

5. **프로젝트 룰스 파일 생성**:
   - `.cursor/rules/AGENT_Teams.mdc` 생성
   - 프로젝트 룰스에 자동 등록

6. **검증**:
   - 생성된 파일 검증
   - 팀 구성 완료 로그 기록

---

## 📋 예시

### 투자 프로젝트 예시

```markdown
# 🏆 7+ 에이전트 팀 구성

### 🧠 Team 1: Quant Strategy (퀀트 전략)
**역할**: 투자 전략 설계 및 검증
**전문성**: 팩터 투자, 모멘텀, 밸류, 퀄리티
**관점**: "수익률 극대화"
**담당 영역**: engine/strategy/, engine/quant_core/

**논쟁 포인트**:
- Risk Team과 "수익 vs 안전" 논쟁
- AI Team과 "규칙 vs 학습" 논쟁

### ⚠️ Team 2: Risk & Compliance (리스크 & 컴플라이언스)
**역할**: 리스크 관리, 규제 준수, VETO 권한
**전문성**: VaR/CVaR, Kelly Criterion, 하드 리미트
**관점**: "손실 최소화"
**담당 영역**: engine/risk/

**VETO 권한**: 하드 리미트 위반 시 즉시 거부
```

---

**이 문서는 프로젝트별 에이전트 팀 생성 가이드를 제공합니다.**

