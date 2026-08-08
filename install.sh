#!/usr/bin/env bash
#
# Links the skills in this repository into Claude and Codex user-global skill
# directories.
#
#   ./install.sh
#
# Skills are user-global — one directory, no per-project path encoding — so this
# is deliberately much simpler than installing a memory store. Links rather than
# copies: a copy forks from the repository the moment either side is edited, and
# then you have two versions of a practice and no way to know which one loaded.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"
DESTS=("$HOME/.claude/skills" "$HOME/.codex/skills")

say() { printf '%s\n' "$*"; }

# Git Bash on Windows silently copies when it cannot create a symlink, which
# would defeat the point without saying so. Fail here instead.
probe="$(mktemp -d)"
: > "$probe/target"
if ! ln -s "$probe/target" "$probe/link" 2>/dev/null || [ ! -L "$probe/link" ]; then
  rm -rf "$probe"
  say "This system cannot create symbolic links."
  say "On Windows that needs Developer Mode, an elevated shell, or WSL."
  say "Refusing to copy instead: copies drift apart silently."
  exit 1
fi
rm -rf "$probe"

for dest in "${DESTS[@]}"; do
  mkdir -p "$dest"
  say "Skills → $dest"

  for skill in "$REPO"/skills/*/; do
    [ -d "$skill" ] || continue
    name="$(basename "$skill")"
    target="$dest/$name"
    say "  $name"

    if [ -L "$target" ] && [ "$(readlink "$target")" = "$REPO/skills/$name" ]; then
      say "    already linked, leaving alone"
      continue
    fi
    # A link already pointing at some *other* clone of this same repository is the
    # drift condition, not a pre-existing foreign file: two clones means two
    # versions of a practice and no way to tell which one loaded. Backing it up
    # silently would hide exactly that. Refuse and let a person choose.
    if [ -L "$target" ]; then
      existing="$(readlink "$target")"
      case "$existing" in
        */skills/"$name")
          say "    REFUSED: already linked to a different clone of this repository"
          say "               $existing"
          say "             Two clones drift. Remove one, or relink by hand."
          exit 1
          ;;
      esac
    fi

    if [ -e "$target" ] || [ -L "$target" ]; then
      mv "$target" "$target.backup-$STAMP"
      say "    existing copy kept as $name.backup-$STAMP"
    fi
    ln -s "$REPO/skills/$name" "$target"
    say "    linked → $REPO/skills/$name"
  done
done

say
say "Loaded when what you are about to do matches the skill's description —"
say "not at session start. That timing is the point; see notes/."
