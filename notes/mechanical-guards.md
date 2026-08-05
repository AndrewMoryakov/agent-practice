# Mechanical guards against documentation drift

Documentation says one thing, the code does another. In one project, over two
days, that happened **nine times**: a guide describing a stub the code no longer
had; two tasks marked blocked that were finished; one marked done that did not
work; a document naming a file the program had stopped writing; roadmap lines
that were false an hour after the commit that wrote them.

None of it was carelessness. The rule *"verify status against the code and the
tests"* was already in that project's `AGENTS.md`. Agents read it and broke it in
the same session.

So the useful move is not a better-worded rule. It is a check that fails.

## The shape that works

Compare **two sources of truth that already exist in the repository**, and let
the build fail when they disagree. Not "does this document contain the right
sentence" — that only catches what somebody remembered to look for in advance.

Four that earned their place:

- **Every flag the argument parser accepts must appear in the help text.** The
  first run found nine flags that existed and were documented nowhere.
- **Every commit hash cited in a plan must exist in git.** Plans accumulate
  references to work that was rebased away.
- **A task row marked "ready to start" must not already have a commit carrying
  its key.** This is how "blocked" and "done" go stale in opposite directions.
- **Two documents that both state a number must state the same one.** Mark one
  as canonical with a comment the check can find, and compare the rest to it.

Each of these is three lines of shell or a short test. Each fails loudly, which
is the only property that matters: prose cannot notice it has become false.

**Three of the four are patterns to reimplement, not code you can install.** They
have to know your parser, your task-file format, your canonical number, so they
live in the repository they guard. The fourth is repo-agnostic and ships here:

```bash
~/agent-practice/guards/check-cited-hashes.sh [path ...]
```

It reads hashes written in backticks and fails when one does not resolve. Run
against a real documentation tree of 229 citations it took under a second. It
refuses outright on a shallow clone, where absence would prove nothing. And it
deliberately ignores bare words, because `succeeded` is seven hex characters and
a broader scan cries wolf — the same lesson as the next section.

## Two ways to build the check wrong

Both were learned by shipping them.

**Do not match prose.** A short-form copy of a rule legitimately rephrases it —
"version matters too" where the original says "name the build". A check looking
for the phrase reports drift that is not there. In one sitting this produced
three confident, wrong drift reports in ten minutes. When two texts must agree by
intent rather than by letter, put a stable marker in each — `<!-- mirror-of: x -->`
— and compare the sets of markers. Rewording cannot break it; a missing entry can.

**Check the artifact that is actually loaded.** The same sitting produced two more
wrong findings from grepping a checkout three commits behind the tree the live
symlinks pointed at. A command was named and run — the discipline was satisfied —
and it answered about a file nothing loads. Make the check resolve the symlink and
**refuse to run** in the wrong tree, with a non-zero exit distinct from "found
drift".

## The precondition everyone skips

A verification gate nobody can pass does not produce refusal. It produces
**silent reinterpretation**, differently by each person who meets it.

One suite had 37 permanent failures on a developer machine. Red therefore carried
no information, and two independent agents filed runs that had not happened at the
scope claimed. The fix was not stricter instruction; it was making the gate
passable — every failure keyed to a task, and the check comparing the failure
*list* rather than its count, so a new failure cannot hide behind a fixed one.

Before adding a guard, make sure the existing ones are green. A red suite is a
place for defects to hide.

## Where to run it

A check nothing invokes is prose with a shebang. Wire it to the moment the
content leaves the machine — the push, the sync, the commit hook — not to a
command someone has to remember.
