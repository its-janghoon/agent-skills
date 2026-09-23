# Agent Skills

A small, open-source collection of [Agent Skills](https://agentskills.io/): folders of instructions and scripts that a compatible agent tool loads on demand when a task matches. Agent Skills is an open standard, so the skills here work across coding agents such as Kiro, Claude Code, and opencode, and several also ship as Claude.ai upload zips.

[한국어 README](./README.ko.md)

## Contents

- [Skills](#skills)
- [Install](#install)
  - [One-line install](#one-line-install)
  - [Install by hand](#install-by-hand)
  - [Claude.ai (zip upload)](#claudeai-zip-upload)
- [Contributing](#contributing)
- [Links](#links)
- [License](#license)

## Skills

| Skill | Use when | Claude.ai zip |
| --- | --- | --- |
| [gov-one-pager](./skills/gov-one-pager/) | Korean government-style one-page project summary (grant / proposal table format) | [Download](./dist/gov-one-pager.zip) |
| [exec-one-pager](./skills/exec-one-pager/) | English exec, pitch, or startup one-pager | [Download](./dist/exec-one-pager.zip) |
| [voice](./skills/voice/) | Janghoon Lee Korean voice for docs, Slack, email, PDF | [Download](./dist/voice.zip) |
| [demo-recorder](./skills/demo-recorder/) | Record a watchable demo video of a web app (visible cursor, slow motion) and verify a UI click-through | [Download](./dist/demo-recorder.zip) |
| [spoon](./skills/spoon/) | Answer as one self-contained step-by-step walkthrough in a single place, with no cross-references (Kiro: `/spoon`) | [Download](./dist/spoon.zip) |

These are different formats, so pick by what you are producing. Generic English "one-pager" → `exec-one-pager`. Korean government proposal table → `gov-one-pager`. Korean business tone → `voice`. Recorded UI demo video or click-through check → `demo-recorder`. Exact copy-paste instructions the user can follow without looking anywhere else → `spoon`.

## Install

Each skill is a self-contained folder under [`skills/`](./skills/). Installing one means putting that folder where your agent looks for skills. Nothing to build.

| Tool | Directory | Invocation |
| --- | --- | --- |
| Kiro (global) | `~/.kiro/skills/<name>/` | slash command, e.g. `/spoon` |
| Kiro (one project) | `.kiro/skills/<name>/` | slash command, e.g. `/spoon` |
| Claude Code | `.claude/skills/<name>/` or `~/.claude/skills/<name>/` | model-invoked from `description` |
| opencode | `.opencode/skills/<name>/` (also reads `.claude/skills`, `.agents/skills`) | model-invoked from `description` |
| Claude.ai | zip upload, no directory | model-invoked from `description` |

### One-line install

[`scripts/install.sh`](./scripts/install.sh) downloads the repo tarball and copies the skill folders out of it. No sudo, no git, no clone.

```bash
curl -fsSL https://raw.githubusercontent.com/its-janghoon/agent-skills/main/scripts/install.sh | bash -s -- spoon
```

That installs one skill into `~/.kiro/skills/`. Other forms:

```bash
# every skill in the repo
curl -fsSL https://raw.githubusercontent.com/its-janghoon/agent-skills/main/scripts/install.sh | bash

# several skills, into Claude Code instead
curl -fsSL https://raw.githubusercontent.com/its-janghoon/agent-skills/main/scripts/install.sh | bash -s -- --target claude spoon voice

# see what is available first
curl -fsSL https://raw.githubusercontent.com/its-janghoon/agent-skills/main/scripts/install.sh | bash -s -- --list
```

`--target` takes `kiro` (default, `~/.kiro/skills`), `kiro-local`, `claude`, `claude-local`, or `opencode`. `--dir <path>` installs into an explicit directory, and `--ref <branch-or-tag>` installs from somewhere other than `main`. Run with `--help` for the full list.

Re-running is safe: an existing skill folder is moved aside to `<name>.bak-<timestamp>` before the new copy lands, so you can always put the old one back. To uninstall, delete the skill folder.

### Install by hand

One skill, without the script:

```bash
mkdir -p ~/.kiro/skills/spoon
curl -fsSL -o ~/.kiro/skills/spoon/SKILL.md \
  https://raw.githubusercontent.com/its-janghoon/agent-skills/main/skills/spoon/SKILL.md
```

That works for single-file skills (`spoon`, `voice`). `gov-one-pager`, `exec-one-pager`, and `demo-recorder` ship `scripts/` alongside `SKILL.md`, so clone and copy the whole folder instead:

```bash
git clone https://github.com/its-janghoon/agent-skills.git
mkdir -p ~/.kiro/skills
cp -r agent-skills/skills/* ~/.kiro/skills/
```

Swap `~/.kiro/skills` for the directory your tool uses (see the table above). `demo-recorder` drives a real browser and needs a few extra steps; see its [SKILL.md](./skills/demo-recorder/SKILL.md).

### Claude.ai (zip upload)

1. Download a skill zip from the [Skills](#skills) table above (or from [`dist/`](./dist/)).
2. Open [claude.ai](https://claude.com/) → **Settings** → **Capabilities** / **Skills** (wording varies) → **Upload skill**.
3. Select the `.zip` file.

Each zip already has the correct layout (`skill-name/SKILL.md` at the archive root). See [Using skills in Claude](https://support.claude.com/en/articles/12512180-using-skills-in-claude).

The one-pager skills need Node.js and `docx` (`npm install docx`) when Claude generates the `.docx`.

## Contributing

Contributions of new skills and improvements are welcome. To add a skill:

1. Copy [`template/`](./template/) to `skills/<name>/`
2. Set `name` + `description` (what + when; keep description ≤ **200** characters for Claude.ai)
3. Run `python scripts/package-skills.py` (or `bash scripts/package-skills.sh`) to refresh `dist/<name>.zip`
4. Update the skills table in this README and in [`README.ko.md`](./README.ko.md)

See [CONTRIBUTING.md](./CONTRIBUTING.md) for the full guidelines, including the rule that README.md and README.ko.md must stay in sync.

## Links

- [Agent Skills](https://agentskills.io/)
- [Creating custom skills](https://support.claude.com/en/articles/12512198-creating-custom-skills)
- [anthropics/skills](https://github.com/anthropics/skills)

## License

Copyright 2026 Janghoon Lee (이장훈). Released under the [Apache-2.0](./LICENSE) license.
