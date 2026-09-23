#!/usr/bin/env bash
# Install skills from its-janghoon/agent-skills into an agent's skills directory.
#
#   curl -sL https://raw.githubusercontent.com/its-janghoon/agent-skills/main/scripts/install.sh | bash -s -- spoon
#
# No sudo, no git, no clone: downloads the repo tarball to a temp dir and copies
# the requested skill folders out of it. An existing skill folder is moved aside
# to <name>.bak-<timestamp> rather than deleted, so every install is undoable.
set -euo pipefail

REPO="${AGENT_SKILLS_REPO:-its-janghoon/agent-skills}"
REF="${AGENT_SKILLS_REF:-main}"
TARGET="kiro"
DEST=""
EXPLICIT_DIR=0
LIST_ONLY=0
SKILLS=()

usage() {
  cat <<'USAGE'
Usage: install.sh [options] [skill ...]

Skills default to all skills in the repo.

Options:
  -t, --target <name>  Where to install (default: kiro)
                         kiro         ~/.kiro/skills          (global, /command works everywhere)
                         kiro-local   ./.kiro/skills          (this project only)
                         claude       ~/.claude/skills        (Claude Code, global)
                         claude-local ./.claude/skills        (Claude Code, this project)
                         opencode     ./.opencode/skills      (opencode, this project)
  -d, --dir <path>     Install into an explicit directory, ignoring --target
  -r, --ref <ref>      Branch or tag to install from (default: main)
  -l, --list           List the skills available in the repo and exit
  -h, --help           Show this help

Examples:
  install.sh spoon
  install.sh --target claude spoon voice
  install.sh --list
  install.sh                      # every skill, into ~/.kiro/skills
USAGE
}

while [ $# -gt 0 ]; do
  case "$1" in
    -t|--target) TARGET="${2:?--target needs a value}"; shift 2 ;;
    -d|--dir)    DEST="${2:?--dir needs a value}"; EXPLICIT_DIR=1; shift 2 ;;
    -r|--ref)    REF="${2:?--ref needs a value}"; shift 2 ;;
    -l|--list)   LIST_ONLY=1; shift ;;
    -h|--help)   usage; exit 0 ;;
    -*)          echo "install.sh: unknown option $1" >&2; usage >&2; exit 2 ;;
    *)           SKILLS+=("$1"); shift ;;
  esac
done

if [ -z "$DEST" ]; then
  case "$TARGET" in
    kiro)         DEST="$HOME/.kiro/skills" ;;
    kiro-local)   DEST=".kiro/skills" ;;
    claude)       DEST="$HOME/.claude/skills" ;;
    claude-local) DEST=".claude/skills" ;;
    opencode)     DEST=".opencode/skills" ;;
    *) echo "install.sh: unknown target '$TARGET' (see --help)" >&2; exit 2 ;;
  esac
fi

for cmd in curl tar; do
  command -v "$cmd" >/dev/null 2>&1 || { echo "install.sh: '$cmd' is required but not installed" >&2; exit 1; }
done

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

echo "Fetching $REPO@$REF ..."
curl -fsSL "https://codeload.github.com/$REPO/tar.gz/refs/heads/$REF" \
  | tar -xz -C "$WORK" --strip-components=1 \
  || { echo "install.sh: could not download $REPO@$REF" >&2; exit 1; }

SRC="$WORK/skills"
[ -d "$SRC" ] || { echo "install.sh: no skills/ directory in $REPO@$REF" >&2; exit 1; }

available=()
for d in "$SRC"/*/; do
  [ -f "$d/SKILL.md" ] && available+=("$(basename "$d")")
done

if [ "$LIST_ONLY" -eq 1 ]; then
  printf '%s\n' "${available[@]}"
  exit 0
fi

if [ "${#SKILLS[@]}" -eq 0 ]; then
  SKILLS=("${available[@]}")
fi

for name in "${SKILLS[@]}"; do
  if [ ! -f "$SRC/$name/SKILL.md" ]; then
    echo "install.sh: no skill named '$name'. Available: ${available[*]}" >&2
    exit 1
  fi
done

mkdir -p "$DEST"
stamp="$(date +%Y%m%d%H%M%S)"
for name in "${SKILLS[@]}"; do
  if [ -e "$DEST/$name" ]; then
    mv "$DEST/$name" "$DEST/$name.bak-$stamp"
    echo "  kept old copy at $DEST/$name.bak-$stamp"
  fi
  cp -R "$SRC/$name" "$DEST/$name"
  echo "  installed $name -> $DEST/$name"
done

echo
echo "Done. ${#SKILLS[@]} skill(s) in $DEST"
case "$TARGET" in
  kiro|kiro-local)
    if [ "$EXPLICIT_DIR" -eq 1 ]; then
      echo "These load however the agent reading $DEST is configured."
    else
      echo "Kiro invokes these as slash commands: $(printf '/%s ' "${SKILLS[@]}")"
      echo "If a command does not autocomplete, run /context to check the skill:// resource is loaded."
    fi
    ;;
  *)
    echo "These are model-invoked: describe the task and the agent loads the matching skill."
    ;;
esac
echo "To undo: delete the folders above (a .bak-$stamp copy is next to any skill you replaced)."
