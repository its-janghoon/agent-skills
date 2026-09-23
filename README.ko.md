# Agent Skills

오픈소스 [Agent Skills](https://agentskills.io/) 모음입니다. 호환 에이전트 도구가 작업에 맞을 때 불러오는 지침·스크립트 폴더로, Agent Skills는 오픈 표준이라 여기 담긴 스킬은 Kiro, Claude Code, opencode 같은 여러 코딩 에이전트에서 동작하며, 일부는 Claude.ai 업로드 zip으로도 제공됩니다.

[English README](./README.md)

## 목차

- [스킬](#스킬)
- [설치](#설치)
  - [한 줄 설치](#한-줄-설치)
  - [직접 설치](#직접-설치)
  - [Claude.ai (zip 업로드)](#claudeai-zip-업로드)
- [기여하기](#기여하기)
- [링크](#링크)
- [라이선스](#라이선스)

## 스킬

| 스킬 | 이런 때 사용 | Claude.ai zip |
| --- | --- | --- |
| [gov-one-pager](./skills/gov-one-pager/) | 정부지원 사업 요약서 / 추진계획(안) / 1페이지 요약서 | [다운로드](./dist/gov-one-pager.zip) |
| [exec-one-pager](./skills/exec-one-pager/) | 영문 경영·피치·스타트업 원페이저 | [다운로드](./dist/exec-one-pager.zip) |
| [voice](./skills/voice/) | 문서·슬랙·이메일·PDF용 이장훈 말투 | [다운로드](./dist/voice.zip) |
| [demo-recorder](./skills/demo-recorder/) | 웹 앱의 데모 영상을 보기 좋게 녹화(마우스 커서 표시·슬로 모션)하고 UI 클릭 흐름을 검증 | [다운로드](./dist/demo-recorder.zip) |
| [spoon](./skills/spoon/) | 다른 곳 참조 없이 한곳에서 그대로 따라할 수 있는 스텝바이스텝 안내 (Kiro: `/spoon`) | [다운로드](./dist/spoon.zip) |

형식이 서로 다르니 만들려는 결과물로 고르세요. 일반 영문 "one-pager" → `exec-one-pager`. 한국 정부·제안 표 양식 → `gov-one-pager`. 한국어 비즈니스 말투 → `voice`. UI 데모 영상 녹화 또는 클릭 흐름 확인 → `demo-recorder`. 다른 곳 안 보고 그대로 붙여넣을 수 있는 단계별 지시 → `spoon`.

## 설치

각 스킬은 [`skills/`](./skills/) 아래의 독립 폴더입니다. 설치는 그 폴더를 에이전트가 스킬을 찾는 위치에 두는 것이 전부이고, 빌드는 필요 없습니다.

| 도구 | 디렉터리 | 호출 방식 |
| --- | --- | --- |
| Kiro (전역) | `~/.kiro/skills/<name>/` | 슬래시 커맨드, 예: `/spoon` |
| Kiro (프로젝트 한정) | `.kiro/skills/<name>/` | 슬래시 커맨드, 예: `/spoon` |
| Claude Code | `.claude/skills/<name>/` 또는 `~/.claude/skills/<name>/` | `description` 으로 모델이 호출 |
| opencode | `.opencode/skills/<name>/` (`.claude/skills`, `.agents/skills` 도 읽음) | `description` 으로 모델이 호출 |
| Claude.ai | zip 업로드, 디렉터리 없음 | `description` 으로 모델이 호출 |

### 한 줄 설치

[`scripts/install.sh`](./scripts/install.sh) 가 레포 tarball을 받아 스킬 폴더만 꺼내 복사합니다. sudo·git·clone 모두 필요 없습니다.

```bash
curl -sL https://raw.githubusercontent.com/its-janghoon/agent-skills/main/scripts/install.sh | bash -s -- spoon
```

스킬 하나를 `~/.kiro/skills/` 에 설치합니다. 다른 형태:

```bash
# 레포의 모든 스킬
curl -sL https://raw.githubusercontent.com/its-janghoon/agent-skills/main/scripts/install.sh | bash

# 여러 개를 Claude Code 쪽에
curl -sL https://raw.githubusercontent.com/its-janghoon/agent-skills/main/scripts/install.sh | bash -s -- --target claude spoon voice

# 뭐가 있는지 먼저 보기
curl -sL https://raw.githubusercontent.com/its-janghoon/agent-skills/main/scripts/install.sh | bash -s -- --list
```

`--target` 은 `kiro`(기본값, `~/.kiro/skills`), `kiro-local`, `claude`, `claude-local`, `opencode` 를 받습니다. `--dir <path>` 는 지정한 디렉터리에 설치하고, `--ref <브랜치나-태그>` 는 `main` 이 아닌 곳에서 설치합니다. 전체 옵션은 `--help` 로 봅니다.

다시 실행해도 안전합니다. 이미 있는 스킬 폴더는 `<name>.bak-<시각>` 으로 옮겨둔 뒤 새 복사본이 들어가므로 언제든 되돌릴 수 있습니다. 삭제는 스킬 폴더를 지우면 됩니다.

### 직접 설치

스크립트 없이 스킬 하나만:

```bash
mkdir -p ~/.kiro/skills/spoon
curl -sL -o ~/.kiro/skills/spoon/SKILL.md \
  https://raw.githubusercontent.com/its-janghoon/agent-skills/main/skills/spoon/SKILL.md
```

파일 하나로 된 스킬(`spoon`, `voice`)에서만 됩니다. `gov-one-pager`·`exec-one-pager`·`demo-recorder` 는 `SKILL.md` 옆에 `scripts/` 를 함께 싣기 때문에 클론해서 폴더째 복사합니다:

```bash
git clone https://github.com/its-janghoon/agent-skills.git
mkdir -p ~/.kiro/skills
cp -r agent-skills/skills/* ~/.kiro/skills/
```

`~/.kiro/skills` 자리는 쓰는 도구의 디렉터리로 바꾸면 됩니다(위 표 참고). `demo-recorder` 는 실제 브라우저를 구동하므로 몇 단계가 더 필요합니다. 해당 스킬의 [SKILL.md](./skills/demo-recorder/SKILL.md)를 참고하세요.

### Claude.ai (zip 업로드)

1. 위 [스킬](#스킬) 표(또는 [`dist/`](./dist/))에서 스킬 zip을 받습니다.
2. [claude.ai](https://claude.com/) → **Settings** → **Capabilities** / **Skills**(문구는 다를 수 있음) → **Upload skill**.
3. `.zip` 파일을 선택합니다.

zip은 Claude.ai가 요구하는 구조(`skill-name/SKILL.md`가 압축 루트)로 이미 맞춰 두었습니다. [Claude에서 스킬 사용하기](https://support.claude.com/en/articles/12512180-using-skills-in-claude)를 참고하세요.

원페이저 스킬로 `.docx`를 만들 때는 Node.js와 `docx`(`npm install docx`)가 필요합니다.

## 기여하기

새 스킬과 개선 기여를 환영합니다. 스킬을 추가하려면:

1. [`template/`](./template/)를 `skills/<name>/`으로 복사
2. `name` + `description` 작성 (무엇을·언제; Claude.ai용 description은 **200자** 이하)
3. `python scripts/package-skills.py`(또는 `bash scripts/package-skills.sh`)로 `dist/<name>.zip` 갱신
4. 이 README와 [`README.md`](./README.md)의 스킬 표 모두 수정

전체 가이드라인은 [CONTRIBUTING.md](./CONTRIBUTING.md)를 참고하세요. README.md와 README.ko.md를 항상 동기화해야 한다는 규칙도 포함되어 있습니다.

## 링크

- [Agent Skills](https://agentskills.io/)
- [커스텀 스킬 만들기](https://support.claude.com/en/articles/12512198-creating-custom-skills)
- [anthropics/skills](https://github.com/anthropics/skills)

## 라이선스

Copyright 2026 이장훈 (Janghoon Lee). [Apache-2.0](./LICENSE) 라이선스로 배포됩니다.
