---
name: spoonfeeding
description: >-
  Answer as one self-contained step-by-step walkthrough in a single place, with
  no cross-references. Use on "spoonfeed", "step by step", "스푼피딩",
  "스텝바이스텝", "하나씩", "다른 곳 참조하지 말고", "한곳에".
license: Apache-2.0
---

# Spoonfeeding

Produce ONE document the user can follow start to finish without opening
anything else. Every command, every value, every expected result lives in that
one place. The user should never have to scroll up, click a link, or hold a
prior message in their head.

## When to use

- "스텝바이스텝으로 스푼피딩해줘"
- "다른 곳 참조하지 말고 한곳에 정리해줘"
- "하나씩 알려줘" / "떠먹여줘" / "그대로 따라할 수 있게"
- "spoonfeed me" / "walk me through it step by step" / "give me the exact commands"
- The user already failed once following a scattered answer.

## The contract

Follow all nine. A walkthrough that breaks any one of them is not spoonfed.

1. **One place.** One document, one code block per step. No appendix, no
   companion file, no "see the docs".
2. **No cross-references.** Never write "as mentioned above", "same as step 3",
   "refer to the README", "use the values from earlier". If step 7 needs the
   command from step 3, write that command again in full at step 7.
3. **One action per step.** If a step contains "and then", split it.
4. **Exact payload.** Every step carries the literal text to paste, in a code
   block, with absolute paths and real values. No `<your-path-here>` unless the
   step immediately before it is how to obtain that value.
5. **Say where to run it.** Name the place before the command: which terminal,
   which directory, which file, which website, which menu.
6. **Expected result.** Every step states what the user should see when it
   worked, verbatim where possible (output line, exit code, UI change).
7. **Failure branch.** Every step that can fail states the one most likely
   failure and the exact fix. One failure, not a troubleshooting catalogue.
8. **Start from zero.** Step 1 assumes a fresh terminal, nothing installed,
   nothing configured, no memory of this conversation. Put prerequisite checks
   in the numbered flow as real steps, not as an unnumbered preamble.
9. **End with proof and undo.** The last two steps are: one command that proves
   the whole thing worked, and how to put everything back.

## Step template

Write every step in this exact shape.

```
### Step N. <imperative title>

Where: <terminal / file path / website page>

<the literal thing to paste or type>

You should see: <observable result>
If not: <the one likely failure> → <the exact fix>
```

## Instructions

1. Count the steps first. If the task takes more than about 15 steps, split it
   into labelled phases, and make each phase satisfy the contract on its own so
   the user still never looks outside the phase they are in.
2. Resolve every branch before writing. Do not hand the user an if/else. Add a
   check step whose output decides it, then write one linear path.
3. Inline every value. Read the real path, the real port, the real version, the
   real branch name and paste it in. Never make the user substitute.
4. Write the steps in execution order, never in explanation order.
5. Put the whole walkthrough in one reply. Do not promise the rest in a follow-up
   message.
6. Keep prose out. A step is a command plus its expected result. Background,
   rationale, and alternatives are not part of a spoonfed walkthrough.
7. Match the user's language.

## Do not

- Do not link to documentation as a step. Copy the needed lines in.
- Do not write "install the dependencies" — write the install command.
- Do not write "open the config file and set the value" — show the exact file
  path, the exact line before, and the exact line after.
- Do not give two ways to do one thing. Pick one.
- Do not skip a step because it is obvious. `cd` is a step.
- Do not summarize the steps at the end. The steps are the answer.
- Do not stop at the last action. Prove it worked.

## Examples

**Request:** "이 레포 로컬에서 띄우는 거 스텝바이스텝으로 스푼피딩해줘"

Bad — references elsewhere, hides values, no expected result:

> 1. README의 설치 절차를 따라 의존성을 설치하세요.
> 2. 환경변수를 설정합니다.
> 3. 개발 서버를 실행하면 됩니다.

Good — one place, literal, verifiable:

> ### Step 1. 레포 폴더로 이동
>
> 위치: 새 터미널
>
> ```bash
> cd /home/ubuntu/agent-skills
> ```
>
> 확인: `pwd`가 `/home/ubuntu/agent-skills`를 찍습니다.
> 안 되면: 폴더가 없다는 뜻입니다 → `git clone git@github.com:its-janghoon/agent-skills.git /home/ubuntu/agent-skills` 를 먼저 실행합니다.
>
> ### Step 2. Node 버전 확인
>
> 위치: 같은 터미널
>
> ```bash
> node --version
> ```
>
> 확인: `v20.` 이상이 나옵니다.
> 안 되면: 버전이 낮습니다 → `nvm install 20 && nvm use 20`.

**Request:** "spoonfeed me the deploy, one place only"

The reply is a single numbered list from a fresh shell to a live URL, with the
verifying `curl` and the rollback command as the final two steps — and no step
that says "see the deployment guide".

## As a slash command

Kiro exposes every skill folder as a slash command, so this skill runs as
`/spoonfeeding <task>` once the folder sits at `.kiro/skills/spoonfeeding/`
(workspace) or `~/.kiro/skills/spoonfeeding/` (global). The text typed after the
command name replaces `$ARGUMENTS` below.

Claude Code and Claude.ai have no equivalent: there this skill is model-invoked
from its `description`, so trigger it by saying "spoonfeed" or "스텝바이스텝"
instead of typing a slash command.

Target task: $ARGUMENTS
