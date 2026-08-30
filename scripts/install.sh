#!/usr/bin/env bash
#
# install.sh — install project-memory / update-project-memory for Claude Code,
# Codex, or both.
#
#   bash scripts/install.sh --claude    # symlink both skills into ~/.claude/skills/
#   bash scripts/install.sh --codex     # copy both prompts into ~/.codex/prompts/
#   bash scripts/install.sh --both
#   bash scripts/install.sh --both --copy   # copy instead of symlink (Claude side)
#
# Nothing is overwritten without asking. No network calls.

set -euo pipefail
cd "$(dirname "$0")/.."
REPO=$(pwd)

WANT_CLAUDE=0 WANT_CODEX=0 COPY=0
for arg in "$@"; do
  case "$arg" in
    --claude) WANT_CLAUDE=1 ;;
    --codex)  WANT_CODEX=1 ;;
    --both)   WANT_CLAUDE=1; WANT_CODEX=1 ;;
    --copy)   COPY=1 ;;
    *) echo "unknown flag: $arg"; exit 2 ;;
  esac
done

if [ "$WANT_CLAUDE" -eq 0 ] && [ "$WANT_CODEX" -eq 0 ]; then
  sed -n '3,12p' "$0" | sed 's/^# \{0,1\}//'
  exit 2
fi

confirm() { # <path> -> 0 to proceed
  [ -e "$1" ] || [ -L "$1" ] || return 0
  printf '%s already exists. Replace it? [y/N] ' "$1"
  read -r reply
  case "$reply" in [yY]*) rm -rf "$1"; return 0 ;; *) echo "  skipped $1"; return 1 ;; esac
}

if [ "$WANT_CLAUDE" -eq 1 ]; then
  dest="$HOME/.claude/skills"
  mkdir -p "$dest"
  for skill in project-memory update-project-memory; do
    if confirm "$dest/$skill"; then
      if [ "$COPY" -eq 1 ]; then
        cp -R "$REPO/$skill" "$dest/$skill"
        echo "  copied  $dest/$skill"
      else
        ln -s "$REPO/$skill" "$dest/$skill"
        echo "  linked  $dest/$skill -> $REPO/$skill"
      fi
    fi
  done
  echo "Claude Code picks the skills up on the next session."
fi

if [ "$WANT_CODEX" -eq 1 ]; then
  dest="$HOME/.codex/prompts"
  mkdir -p "$dest"
  bash scripts/build-codex-prompts.sh >/dev/null
  for p in project-memory update-project-memory; do
    if confirm "$dest/$p.md"; then
      cp "$REPO/codex/prompts/$p.md" "$dest/$p.md"
      echo "  copied  $dest/$p.md"
    fi
  done
  echo "Codex exposes /project-memory and /update-project-memory on the next session."
  echo "Optional auto-trigger without the slash command: see codex/AGENTS-snippet.md."
fi

cfg="$HOME/.config/project-memory/config.yaml"
if [ ! -f "$cfg" ]; then
  echo
  echo "No config yet at $cfg."
  echo "The skill asks you on first run, or copy the template now:"
  echo "  mkdir -p ~/.config/project-memory"
  echo "  cp $REPO/project-memory-config.example.yaml $cfg"
fi
