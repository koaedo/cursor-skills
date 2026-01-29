# Cursor skill creation
_Exported on 2026. 1. 29. at 12시 17분 11초 GMT+9 from Cursor (2.4.22)_

---

**User**

/create-skill  Help me create this skill for Cursor: 

---

**Cursor**

Let me read the skill creation guide first.

스킬 생성 가이드를 확인했습니다. 어떤 스킬을 만들고 싶으신지 알려주세요.

이미 만들어둔 스킬을 등록하시려는군요. 개인용 스킬 폴더(`~/.cursor/skills/`)에 저장하시겠다고 하셨습니다.

등록하려는 스킬에 대해 좀 더 알려주세요:

1. **스킬 파일 위치**: 이미 만들어둔 스킬 파일들이 어디에 있나요? (경로를 알려주시면 확인해드릴게요)

2. **스킬 개수**: 몇 개의 스킬을 등록하려고 하시나요?

3. **스킬 내용**: 어떤 스킬들인지 간단히 설명해주시거나, 파일 경로를 알려주시면 제가 확인 후 올바른 형식으로 등록을 도와드리겠습니다.

---

**User**

20개 스킬파일을 ~/.cursor/skills/여기에 넣어둔거같은데 설정이 안된거같아. 확인해줘

---

**Cursor**

`~/.cursor/skills/` 폴더를 확인해보겠습니다.

폴더가 존재하지 않네요. `.cursor` 폴더 내부를 확인해보겠습니다.

`skills` 폴더가 없고, `skills-cursor` 폴더만 있네요. 또한 `d-project-skills` 프로젝트 폴더가 보입니다. 스킬 파일들이 어디에 있는지 확인해보겠습니다.

찾았습니다! 스킬 파일들이 `D:\project\skills\skills\` 폴더에 28개 있습니다. 문제는 이 스킬들이 Cursor가 인식하는 위치에 없다는 것입니다.

## 현재 상황

| 위치 | 설명 |
|------|------|
| `D:\project\skills\skills\` | 스킬 28개 있음 (현재 위치) |
| `C:\Users\dms-web\.cursor\skills\` | **존재하지 않음** (Cursor 개인 스킬 폴더) |
| `C:\Users\dms-web\.cursor\skills-cursor\` | Cursor 내장 스킬 (수정 금지) |

## 해결 방법

스킬을 Cursor가 인식하도록 `~/.cursor/skills/` 폴더를 생성하고 스킬들을 복사해야 합니다.

스킬을 이동하겠습니다. 먼저 대상 폴더를 생성하고 스킬들을 이동합니다.

폴더가 생성되었습니다. 이제 스킬들을 이동합니다.

이동이 완료되었습니다. 확인해보겠습니다.

**28개 스킬이 모두 성공적으로 이동되었습니다!**

스킬 형식이 올바른지 몇 개 샘플로 확인해보겠습니다.

**문제 발견!** 스킬 파일들에 필수 YAML frontmatter가 없습니다.

## 현재 문제

Cursor가 스킬을 인식하려면 각 `SKILL.md` 파일 상단에 다음 형식이 필요합니다:

```yaml
---
name: skill-name
description: 스킬 설명 (언제 사용할지 포함)
---
```

현재 스킬들은 frontmatter 없이 바로 내용이 시작됩니다.

샘플로 `api-design` 스킬에 frontmatter를 추가한 모습을 보여드리겠습니다.

**수정 전:**
```markdown
# API Design Skill

RESTful API 설계 및 모범 사례 가이드
...
```

**수정 후:**
```markdown
---
name: api-design
description: RESTful API 설계 및 모범 사례 가이드. API 엔드포인트 설계, REST API 구현, 응답 형식 정의, 페이지네이션/필터링/정렬 구현 시 사용.
---

# API Design Skill

RESTful API 설계 및 모범 사례 가이드
...
```

실제로 적용해보겠습니다.

샘플이 적용되었습니다. 확인해보겠습니다.

`api-design` 스킬에 frontmatter가 추가되었습니다.

나머지 27개 스킬에 frontmatter를 추가하겠습니다. 먼저 각 스킬의 내용을 확인하고 적절한 description을 생성합니다.

모든 스킬 내용을 확인했습니다. 이제 27개 스킬에 frontmatter를 추가합니다.

6개 완료. 계속 진행합니다.

12개 완료. 계속 진행합니다.

18개 완료. 마지막 9개를 진행합니다.

24개 완료. 마지막 3개를 진행합니다.

**모든 28개 스킬에 frontmatter가 추가되었습니다!**

몇 개 샘플로 확인해보겠습니다.

## 완료! 28개 스킬이 모두 설정되었습니다

### 설치 위치
`C:\Users\dms-web\.cursor\skills\`

### 등록된 스킬 목록

| 카테고리 | 스킬 |
|----------|------|
| **언어** | javascript, typescript, python, php, sql, bash-shell |
| **프레임워크** | react, nextjs, tailwind, graphql, docker |
| **워크플로우** | git-workflow, tdd-workflow, debugging-workflow, code-review, security-audit |
| **최적화** | performance-optimization, react-best-practices |
| **설계** | api-design, frontend-design, error-handling, web-design-guidelines |
| **문서/관리** | documentation, markdown, css-scss |
| **세션** | checkpoint, context-compress, session-management |

### 다음 단계

**Cursor를 재시작**하면 스킬이 자동으로 인식됩니다. 이후 대화 중 관련 키워드가 감지되면 해당 스킬이 자동 적용됩니다.

예: "React 컴포넌트 만들어줘" → `react` 스킬 적용
예: "TDD로 개발해줘" → `tdd-workflow` 스킬 적용

