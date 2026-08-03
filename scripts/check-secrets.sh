#!/usr/bin/env bash
#
# check-secrets.sh — refuse to commit personal paths, emails, or key material.
# Run manually (`bash scripts/check-secrets.sh`) or install as a pre-commit hook:
#   ln -s ../../scripts/check-secrets.sh .git/hooks/pre-commit
#
# Scans only git-tracked files — never .git internals (commit messages, hooks)
# and never untracked cruft. Exit 0 = clean. Exit 1 = fix before committing.

set -uo pipefail
cd "$(dirname "$0")/.." || exit 2

# File list: git-tracked files, minus this guard itself (it holds the patterns).
FILES=$(git ls-files 2>/dev/null | grep -vx 'scripts/check-secrets.sh')
[ -z "$FILES" ] && FILES=$(find . -type f -not -path './.git/*' -not -name 'check-secrets.sh' | sed 's#^\./##')

scan() { # <pattern> -> "file:line:match" across FILES
  local pat="$1" f
  while IFS= read -r f; do
    [ -f "$f" ] || continue
    grep -EnI "$pat" "$f" 2>/dev/null | sed "s#^#$f:#"
  done <<< "$FILES"
}

fail=0
report() { [ -n "$2" ] && { printf '✗ %s\n%s\n\n' "$1" "$2"; fail=1; }; return 0; }

# 1. Absolute home paths — a real path leaks a username. Placeholders are allowed.
home=$(scan '(/Users/|/home/)[A-Za-z0-9._-]+' \
  | grep -vE '/(Users|home)/(you|<name>|username|USER)\b' \
  | grep -vE '<VAULT_ROOT>|/path/to/' || true)
report "home path (possible username leak)" "$home"

# 2. Email addresses (allow known noreply / example domains).
mail=$(scan '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' \
  | grep -vE 'users\.noreply\.github\.com|noreply@anthropic\.com|example\.(com|org)' || true)
report "email address" "$mail"

# 3. Key / token material.
keys=$(scan 'BEGIN [A-Z ]*PRIVATE KEY|AKIA[0-9A-Z]{16}|AIza[0-9A-Za-z_-]{35}|ghp_[0-9A-Za-z]{36}|"type": *"service_account"' || true)
report "key or token material" "$keys"

if [ "$fail" -ne 0 ]; then
  echo "check-secrets: FAILED — remove the items above before committing."
  exit 1
fi
echo "check-secrets: clean."
