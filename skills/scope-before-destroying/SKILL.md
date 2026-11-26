---
name: scope-before-destroying
description: Establish what a deleting, pruning, killing, truncating or overwriting command will
  actually touch before running it, because its real scope comes from the tool's semantics, not from
  how the command line reads. Use before any rm/find -delete/prune/vacuum/clean/kill/pkill/truncate,
  an overwrite in place, or a stop that may cascade, and always on a host or resource that other
  people, sessions or services share.
---

# Scope Before Destroying

A destructive command is judged by what it removed, not by what it was meant to remove. The two
differ more often than the command line suggests, and the difference is usually silent.

## How the real scope diverges

- **A filter accepted but not honoured.** A subcommand can parse a selector and ignore it. A log
  vacuum given a unit filter deletes every archived log file of the host; the unit flag only
  narrows *reading*. The command exits 0 and looks scoped.
- **A pattern that matches more than the target.** `pkill -f <pattern>` matches the shell that
  carries the pattern in its own command line, kills it, and everything after it in that command
  silently does not run.
- **Expansion in the wrong context.** `sudo rm -rf /protected/dir/*` expands the glob in the
  unprivileged shell, which cannot list the directory: nothing is removed, exit status says success.
- **A side effect beyond the object.** Stopping the last process of a managed VM or container lets
  the manager shut it down, and its temporary storage goes with it. Truncate-then-write (`open(path,
  "w")`) on a full disk leaves an empty file where the original was.
- **Success that measures the wrong thing.** A cache-clean command exits 0 and frees nothing; a stop
  command returns when the signal is sent, not when the process is gone.

## Procedure

1. **Ask whether the removal is needed at all.** If the goal is tidiness (debug lines, stale
   files, old copies) and leaving it is harmless, leave it. Most destruction regretted later was
   optional.
2. **Name the intended scope** in one line: which objects, owned by whom, and what must survive.
   On a shared host, list the neighbours explicitly (other services' data, other sessions'
   processes, other users' files).
3. **Establish the real scope from the tool, not from the flags you typed.** Read the help or
   manual of that exact subcommand for how selectors apply to the destructive action. If the tool
   does not say that a selector restricts deletion, assume it does not.
4. **Preview in the same context the command will run in.** Same user, same privileges, same
   working directory: list what would be affected and count it. Examples: `find … -print` before
   `-delete`, `git clean -n`, `rsync -n`, `pgrep -a` before `pkill`, a file listing of what a vacuum
   would remove, `sudo sh -c 'ls …'` for a privileged glob. A preview run in a different context
   proves nothing about the real one.
5. **Prefer a reversible form.** Disable instead of delete (a flag, a config switch), move aside
   instead of remove, rename instead of overwrite, write to a temporary file and rename over the
   original, copy before editing in place. Target by exact identifier (a pid read from `pgrep -a`
   with its full command line checked, an absolute path) rather than by pattern.
6. **Run with the output kept.** Never discard the output of a destructive command; its report of
   what it removed is often the only early sign of overreach. Measure the quantity you care about
   before and after, and look at one neighbour that should be untouched.
7. **If the effect was wider than intended, stop and report it at once:** what went, whether it
   can be recovered, what is still intact. Do not attempt a repair that destroys more; do not let
   the report wait until someone asks.

## Record

`target | intended scope | real scope and how it was established | preview count | reversible form or backup | before/after | neighbour checked`

Good: "vacuum would remove 14 archived files of all units, not only mine; the lines are harmless,
left in place." Bad: "cleaned up my debug logs" after a command that emptied the host's journal.

## Boundaries

- Overwriting someone else's changes in a version-controlled workspace: see
  `agent-worktree-boundaries`.
- Removing secrets from published history: see `scrub-history-before-publish`.
- This skill does not authorize destruction. Who may delete what remains a question for the person
  who owns the resource.

## Origin

A log vacuum run with a unit filter, to drop a few debug lines of one service on a server shared
with another person's live work, deleted every archived journal file of the host; its output had
been discarded, and the loss surfaced only when a reviewer asked about scope. The same mechanism had
appeared before in recorded work: a `pkill -f` that killed its own shell, a privileged `rm` whose
glob expanded unprivileged and removed nothing, a truncating write on a full disk, and a process
kill that let a managed VM shut down and clear its temporary storage.

**Confidence:** one primary episode with four earlier ones of the same mechanism. Transfer test, one
run: an agent without this context, given a label-filtered `docker system prune -af --volumes` on a
shared daemon, declined to run it, read each subcommand's help for how the filter applies, previewed
with filtered and unfiltered counts, removed by exact identifier, kept the unattributable build cache,
and marked the filter behaviour unverified instead of asserting it.
