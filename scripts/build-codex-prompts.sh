#!/usr/bin/env bash
#
# build-codex-prompts.sh — regenerate codex/prompts/*.md from the SKILL.md sources.
#
# Codex custom prompts are plain Markdown files in ~/.codex/prompts/. The file
# name becomes the slash command, and the whole file is sent as the user turn.
# So a Codex prompt is the SKILL.md body with the YAML frontmatter stripped and
# a short "you were invoked" preamble on top.
#
# Run this after editing any SKILL.md, then commit the regenerated prompts.
# Usage: bash scripts/build-codex-prompts.sh [--check]

set -euo pipefail
cd "$(dirname "$0")/.."

CHECK=0
[ "${1:-}" = "--check" ] && CHECK=1

mkdir -p codex/prompts

build() { # <skill-dir> <trigger sentence>
  local dir="$1" trigger="$2" out="codex/prompts/$1.md" tmp
  tmp=$(mktemp)
  {
    printf '%s\n' \
      "# /$dir" \
      "" \
      "You were invoked as the \`/$dir\` command. $trigger" \
      "Follow the instructions below for this turn. Anything the user typed after the" \
      "command is the project context — read it before you start asking questions." \
      "" \
      "---" \
      ""
    # Strip the leading YAML frontmatter block, keep the body.
    awk 'NR==1 && $0=="---" {fm=1; next} fm && $0=="---" {fm=0; skip=1; next} !fm' "$dir/SKILL.md" \
      | sed '/./,$!d'
  } > "$tmp"

  if [ "$CHECK" -eq 1 ]; then
    if ! diff -q "$tmp" "$out" >/dev/null 2>&1; then
      echo "✗ $out is stale — run: bash scripts/build-codex-prompts.sh"
      rm -f "$tmp"
      return 1
    fi
    rm -f "$tmp"
    return 0
  fi

  mv "$tmp" "$out"
  echo "wrote $out"
}

fail=0
build project-memory \
  "The user wants to create project memory in their Obsidian vault." || fail=1
build update-project-memory \
  "The user wants to update the memory of a project that already exists." || fail=1

[ "$fail" -eq 0 ] || exit 1
[ "$CHECK" -eq 1 ] && echo "codex prompts: up to date."
exit 0
