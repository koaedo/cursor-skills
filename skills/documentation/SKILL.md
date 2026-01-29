# Documentation Skill

코드 및 프로젝트 문서화 가이드

## When to Use
- 코드 주석 작성 시
- README 작성 시
- API 문서화 시
- CHANGELOG 작성 시
- 아키텍처 결정 기록 시

---

## 📋 문서화 원칙

```
┌─────────────────────────────────────────────────────────────┐
│                    문서화 피라미드                           │
│                                                             │
│                    ┌───────────┐                            │
│                    │  왜 (Why) │  ← 가장 중요               │
│                  ┌─┴───────────┴─┐                          │
│                  │  무엇 (What)   │                          │
│                ┌─┴───────────────┴─┐                        │
│                │   어떻게 (How)     │  ← 코드가 대신         │
│                └───────────────────┘                        │
└─────────────────────────────────────────────────────────────┘
```

**핵심**: 코드는 "어떻게"를 설명하므로, 주석은 "왜"를 설명해야 함

---

## 📋 코드 주석 가이드

### 좋은 주석 vs 나쁜 주석

```typescript
// ❌ 나쁜 주석: 코드를 그대로 설명
// i를 1 증가
i++;

// ✅ 좋은 주석: 이유/맥락 설명
// 레거시 시스템 호환을 위해 1-based 인덱스 사용
i++;
```

### 주석이 필요한 경우

```typescript
// 1. 비즈니스 로직 설명
// 주문 금액이 50,000원 이상이면 무료 배송
// (마케팅팀 요청, 2024-01 프로모션)
if (orderTotal >= 50000) {
  shippingFee = 0;
}

// 2. 복잡한 알고리즘
// Fisher-Yates 셔플 알고리즘
// 시간복잡도 O(n), 공간복잡도 O(1)

// 3. 비직관적인 코드
// iOS Safari에서 100vh가 주소창을 포함하는 버그 우회
// https://bugs.webkit.org/show_bug.cgi?id=141832

// 4. TODO/FIXME
// TODO: 다국어 지원 추가 예정 (Q2 2024)
// FIXME: 대용량 데이터에서 성능 저하 (#234)
```

### JSDoc 스타일

```typescript
/**
 * 사용자의 구매 이력을 기반으로 추천 상품을 계산합니다.
 * 
 * @param userId - 사용자 ID
 * @param options - 추천 옵션
 * @param options.limit - 최대 추천 수 (기본: 10)
 * 
 * @returns 추천 상품 배열
 * 
 * @example
 * ```ts
 * const recommendations = await getRecommendations('user123', {
 *   limit: 5,
 *   category: 'electronics'
 * });
 * ```
 * 
 * @throws {UserNotFoundError} 사용자가 존재하지 않을 때
 */
async function getRecommendations(
  userId: string,
  options?: RecommendationOptions
): Promise<Product[]> {
  // ...
}
```

---

## 📋 README 작성 가이드

### 필수 섹션

```markdown
# 프로젝트명

> 한 줄 설명 (프로젝트가 무엇인지)

## 소개

프로젝트의 목적과 주요 기능을 2-3 문단으로 설명

## 주요 기능

- ✅ 기능 1
- ✅ 기능 2

## 시작하기

### 요구사항
- Node.js >= 18

### 설치
git clone / npm install

### 실행
npm run dev

## 환경 변수

| 변수명 | 설명 | 필수 | 기본값 |
|--------|------|------|--------|
| DATABASE_URL | DB 연결 | ✅ | - |

## 프로젝트 구조

src/
├── components/
├── hooks/
└── utils/

## 라이선스
MIT License
```

---

## 📋 변경 로그 (CHANGELOG)

### Keep a Changelog 형식

```markdown
# Changelog

## [Unreleased]

### Added
- 다크모드 지원

## [1.2.0] - 2024-01-15

### Added
- 사용자 프로필 이미지 업로드 기능

### Changed
- 로그인 페이지 UI 개선

### Fixed
- 모바일에서 메뉴가 안 닫히는 버그 (#123)

### Deprecated
- v1 API (v2.0에서 제거 예정)

### Security
- XSS 취약점 수정 (CVE-2024-XXXX)
```

---

## 📋 아키텍처 문서 (ADR)

### Architecture Decision Record

```markdown
# ADR-001: 상태 관리 라이브러리 선택

## 상태
승인됨 (2024-01-15)

## 맥락
애플리케이션의 전역 상태 관리가 필요합니다.

## 고려한 옵션

### 1. Redux Toolkit
- ✅ 대규모 앱에 검증됨
- ❌ 보일러플레이트 많음

### 2. Zustand
- ✅ 간단한 API
- ❌ 미들웨어 생태계 제한적

## 결정
**Zustand** 선택

## 이유
- 프로젝트 규모에 적합 (중소규모)
- 팀의 빠른 적응 가능
```

---

## 📋 문서화 체크리스트

```
코드:
[ ] 복잡한 로직에 주석?
[ ] 공개 API에 JSDoc?
[ ] TODO/FIXME 정리?

프로젝트:
[ ] README 완성?
[ ] 설치/실행 방법 명확?
[ ] 환경 변수 문서화?

API:
[ ] 엔드포인트 문서화?
[ ] 요청/응답 예시?
[ ] 에러 코드 설명?
```

---

## 🚫 문서화 안티패턴

```
❌ 코드를 그대로 반복하는 주석
❌ 오래되어 코드와 맞지 않는 문서
❌ 너무 상세하여 유지보수 불가능한 문서
❌ 설치 방법 없는 README
❌ 예시 코드 없는 API 문서
```
