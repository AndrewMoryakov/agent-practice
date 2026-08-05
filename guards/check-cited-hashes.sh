#!/usr/bin/env bash
#
# Every commit hash cited in the documentation must exist in this repository.
#
#   ./check-cited-hashes.sh [path ...]     # default: the whole repo
#
# Plans and roadmaps accumulate references to commits that were rebased away,
# amended, or invented. The document keeps saying them; nothing notices. This
# notices, which is the only property that separates a check from a sentence.
#
# It reads only hashes written inside backticks — `a1b2c3d` — because that is how
# commits are cited in prose, and because scanning bare words finds hex-looking
# English ("succeeded" is seven hex characters) and reports drift that is not
# there. Narrow and silent beats broad and crying wolf.
#
# Exit 0 all cited hashes resolve, 1 some do not, 2 refused to run.
set -euo pipefail

git rev-parse --git-dir >/dev/null 2>&1 || {
  echo "REFUSED: not inside a git repository"
  exit 2
}

# Shallow clones cannot answer the question, and would report every hash missing.
if [ "$(git rev-parse --is-shallow-repository 2>/dev/null || echo false)" = "true" ]; then
  echo "REFUSED: shallow clone — history is incomplete, so absence proves nothing."
  echo "         Run 'git fetch --unshallow' first."
  exit 2
fi

paths=("$@")
[ ${#paths[@]} -eq 0 ] && paths=(.)

missing=0
checked=0

while IFS=: read -r file line hash; do
  [ -n "${hash:-}" ] || continue
  checked=$((checked + 1))
  if ! git cat-file -e "${hash}^{commit}" 2>/dev/null; then
    [ "$missing" -eq 0 ] && echo "Cited commits that do not exist here:"
    echo "  $file:$line  $hash"
    missing=$((missing + 1))
  fi
done < <(
  grep -rInoE '`[0-9a-f]{7,40}`' --include='*.md' "${paths[@]}" 2>/dev/null \
    | sed 's/`//g' || true
)

if [ "$missing" -gt 0 ]; then
  echo
  echo "$missing of $checked cited hashes are unreachable."
  echo "Either the commit was rewritten — update the citation — or it never existed."
  exit 1
fi

echo "ok — $checked cited hashes all resolve"
