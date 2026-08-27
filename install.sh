#!/usr/bin/env bash
#
# Links the skills in this repository into Claude, Codex, and MiniMax user-global
# skill directories.
#
#   ./install.sh
#
# Skills are user-global — one directory, no per-project path encoding — so this
# is deliberately much simpler than installing a memory store. Links rather than
# copies: a copy forks from the repository the moment either side is edited, and
# then you have two versions of a practice and no way to know which one loaded.
#
# Targets Linux and macOS. Tested with bash 3.2 (the version Apple ships
# with macOS, pre-Homebrew) and bash 4+ / 5+ on Linux. The script avoids
# GNU-only features: `mktemp -d`, `readlink` without flags, and case
# patterns that work on both GNU and BSD variants. Symlinks on macOS do
# not need any privilege elevation.
#
# On macOS the default user shell is zsh since Catalina (10.15); either
# `bash install.sh` explicitly, or `chmod +x install.sh && ./install.sh`.
# The shebang routes through env, so whatever bash is on PATH wins.
#
# Windows users: this script is the wrong tool. Use install.ps1 instead �
# symlinks on Windows need Developer Mode or an elevated shell, and Git
# Bash silently copies when it cannot create one, which would defeat the
# point.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"
# Claude, Codex, and MiniMax Code all keep user-global skills under
# $HOME/.…/skills with the same shape. Add a new host here when its
# skill directory convention matches.
DESTS=("$HOME/.claude/skills" "$HOME/.codex/skills" "$HOME/.minimax/skills")

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
      # Backups live OUTSIDE the skills directory. Inside it they would be
      # indistinguishable from active skills: a host that indexes by
      # `name:` from frontmatter (rather than by directory name) would
      # find the backup, not the live link, and serve a frozen copy
      # after the next `git pull` updates the live link.
      backup_root="$(dirname "$dest")/skill-install-backups"
      mkdir -p "$backup_root"
      mv "$target" "$backup_root/$STAMP-$name"
      say "    existing copy kept as $backup_root/$STAMP-$name"
    fi
    ln -s "$REPO/skills/$name" "$target"
    say "    linked → $REPO/skills/$name"
  done
done

say
say "Loaded when what you are about to do matches the skill's description —"
say "not at session start. That timing is the point; see notes/."
