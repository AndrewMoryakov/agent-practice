#!/usr/bin/env pwsh
#
# Links the skills in this repository into Claude, Codex, and MiniMax Code
# user-global skill directories on Windows.
#
#   .\install.ps1
#
# Skills are user-global — one directory, no per-project path encoding — so
# this is deliberately much simpler than installing a memory store.
#
# Links are the default: a copy forks from the repository the moment either
# side is edited, and then you have two versions of a practice and no way to
# know which one loaded.
#
# Link selection, in order:
#   1. Directory junction (`mklink /J`, `New-Item -ItemType Junction`). A
#      reparse point, supported since Windows 2000 on NTFS, and unlike a
#      symbolic link it does NOT require Developer Mode or an elevated shell.
#      Read-through is transparent to file APIs, so Mavis, Claude, and Codex
#      see no difference. This is the default for ordinary Windows users.
#   2. Symbolic link (`mklink`, `New-Item -ItemType SymbolicLink`). Same
#      shape as on Linux, but on Windows needs Developer Mode (Settings,
#      then Privacy and security, then For developers) or an elevated
#      shell. Used when the filesystem refuses junctions (rare; mostly
#      non-NTFS volumes).
#   3. Copy — last resort, when the filesystem refuses both. A copy drifts
#      from `git pull`; re-run this script after each pull to refresh.

$ErrorActionPreference = 'Stop'

$REPO = (Resolve-Path $PSScriptRoot).Path
$STAMP = (Get-Date -Format 'yyyyMMdd-HHmmss')

$HOME_WIN = $env:USERPROFILE
if (-not $HOME_WIN) { throw 'USERPROFILE is not set; cannot resolve skill directories.' }

# All three hosts keep user-global skills under %USERPROFILE%\.…\skills with
# the same shape. Add a new host here when its skill directory convention
# matches.
$DESTS = @(
    (Join-Path $HOME_WIN '.claude\skills'),
    (Join-Path $HOME_WIN '.codex\skills'),
    (Join-Path $HOME_WIN '.minimax\skills')
)

function Test-ReparsePoint {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return $false }
    $attrs = (Get-Item -LiteralPath $Path -Force).Attributes
    return ($attrs -band [System.IO.FileAttributes]::ReparsePoint) -ne 0
}

function Test-SymlinkCapable {
    $probe = Join-Path ([System.IO.Path]::GetTempPath()) ("probe-" + [System.IO.Path]::GetRandomFileName())
    New-Item -ItemType Directory -Path $probe | Out-Null
    try {
        $targetFile = Join-Path $probe 'target'
        $linkFile = Join-Path $probe 'link'
        '' | Set-Content -LiteralPath $targetFile -Encoding utf8
        try {
            New-Item -ItemType SymbolicLink -Path $linkFile -Target $targetFile -ErrorAction Stop | Out-Null
            $ok = (Test-ReparsePoint $linkFile)
            return $ok
        } catch {
            return $false
        }
    } finally {
        Remove-Item -LiteralPath $probe -Recurse -Force -ErrorAction SilentlyContinue
    }
}

function Test-JunctionCapable {
    $probe = Join-Path ([System.IO.Path]::GetTempPath()) ("probe-" + [System.IO.Path]::GetRandomFileName())
    New-Item -ItemType Directory -Path $probe | Out-Null
    try {
        $targetDir = Join-Path $probe 'target'
        $linkDir = Join-Path $probe 'link'
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        'probe' | Set-Content -LiteralPath (Join-Path $targetDir 'probe.txt') -Encoding utf8
        try {
            New-Item -ItemType Junction -Path $linkDir -Target $targetDir -ErrorAction Stop | Out-Null
            if (-not (Test-ReparsePoint $linkDir)) { return $false }
            # Read-through is the property the agents depend on; verify it
            # here so a malformed reparse point that pretends to be a junction
            # but does not redirect is detected before we commit to it.
            $read = Get-Content -LiteralPath (Join-Path $linkDir 'probe.txt') -Raw -ErrorAction SilentlyContinue
            return ($null -ne $read)
        } catch {
            return $false
        }
    } finally {
        Remove-Item -LiteralPath $probe -Recurse -Force -ErrorAction SilentlyContinue
    }
}

$HAS_JUNCTION = Test-JunctionCapable
$HAS_SYMLINK = Test-SymlinkCapable

if ($HAS_JUNCTION) {
    $LINK_MODE = 'junction'
    'Junction capability: OK'
} elseif ($HAS_SYMLINK) {
    $LINK_MODE = 'symlink'
    'Junction not available; falling back to symlink (requires Developer Mode or admin).'
} else {
    $LINK_MODE = 'copy'
    ''
    'WARNING: this filesystem refuses both directory junctions and symbolic links.'
    'Falling back to copy. A copy forks from the repository the moment either'
    'side is edited, and after that you have two versions of a practice and no'
    'way to know which one loaded. Re-run this script after `git pull` to refresh.'
    ''
}

$REPO_SKILLS = Join-Path $REPO 'skills'
if (-not (Test-Path -LiteralPath $REPO_SKILLS)) {
    throw "no skills directory at $REPO_SKILLS"
}

foreach ($dest in $DESTS) {
    if (-not (Test-Path -LiteralPath $dest)) {
        New-Item -ItemType Directory -Path $dest -Force | Out-Null
    }
    "Skills -> $dest"

    foreach ($skill in Get-ChildItem -LiteralPath $REPO_SKILLS -Directory) {
        $name = $skill.Name
        $src = $skill.FullName
        $target = Join-Path $dest $name

        "  $name"

        if (Test-Path -LiteralPath $target) {
            if (Test-ReparsePoint $target) {
                $existing = (Get-Item -LiteralPath $target -Force).Target
                if ($existing -eq $src) {
                    '    already linked, leaving alone'
                    continue
                }
                # A link already pointing at some *other* clone of this same
                # repository is the drift condition: two clones means two
                # versions of a practice and no way to tell which one loaded.
                # Refuse and let a person choose.
                # Use -Regex with a character class because the path separator
                # is `/` on Unix and `\` on Windows, and `switch -Wildcard`
                # does not accept character classes.
                $otherClonePattern = '[\\/]skills[\\/]' + $name + '$'
                $isOtherClone = $false
                switch -Regex ($existing) {
                    $otherClonePattern { $isOtherClone = $true }
                }
                if ($isOtherClone) {
                    "    REFUSED: already linked to a different clone of this repository"
                    "               $existing"
                    "             Two clones drift. Remove one, or relink by hand."
                    throw "drift detected for $name"
                }
            }
            # Existing non-link copy — keep it as a backup so the user can
            # compare or revert by hand. The backup lives OUTSIDE the skills
            # directory. Inside it, the backup would be indistinguishable from
            # an active skill: a host that indexes by `name:` from frontmatter
            # (rather than by directory name) would find the backup, not the
            # live link, and serve a frozen copy after the next `git pull`
            # updates the live link.
            $hostConfigRoot = Split-Path -Path $dest -Parent
            $backupRoot = Join-Path $hostConfigRoot 'skill-install-backups'
            if (-not (Test-Path -LiteralPath $backupRoot)) {
                New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null
            }
            $backup = Join-Path $backupRoot "$STAMP-$name"
            Move-Item -LiteralPath $target -Destination $backup -Force
            "    existing copy kept as skill-install-backups/$STAMP-$name"
        }

        switch ($LINK_MODE) {
            'junction' {
                New-Item -ItemType Junction -Path $target -Target $src | Out-Null
                "    junction -> $src"
            }
            'symlink' {
                New-Item -ItemType SymbolicLink -Path $target -Target $src | Out-Null
                "    linked -> $src"
            }
            default {
                Copy-Item -LiteralPath $src -Destination $target -Recurse -Force
                '    copied (drift risk: re-run after `git pull` to refresh)'
            }
        }
    }
}

''
'Loaded when what you are about to do matches the skill''s description —'
'not at session start. That timing is the point; see notes/.'
