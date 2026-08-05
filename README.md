# agent-practice

Working practice for coding agents, kept separately from any project that
produced it. Nothing here is about a particular codebase: it is the part that
turned out to transfer.

Everything is written from things that were run and measured. Where a claim is
weaker than that, it says so — which is itself the first item.

## Install

```bash
git clone git@github.com:AndrewMoryakov/agent-practice.git ~/agent-practice
~/agent-practice/install.sh
```

That links `skills/` into `~/.claude/skills`. Skills are user-global, so there is
no project path to configure.

## What is here

**`skills/claim-discipline`** — every consequential claim carries how it was
established: *reproduced*, *measured*, or *read only*. It exists because stating
the rule was demonstrably not enough. A project whose onboarding document already
said "verify status against the code and tests" had three agents file claims that
measurement refuted within two days, while reading it. The difference is when it
loads: a skill is pulled in at the moment a claim is being written, not two
hundred thousand tokens earlier.

**`guards/check-cited-hashes.sh`** — the one guard here that is repo-agnostic
enough to ship rather than describe: every commit hash cited in the docs must
still exist in git. Verified against a tree with 229 citations, and against
planted fakes to be sure it can fail.

**`notes/mechanical-guards.md`** — how to stop documentation from drifting away
from code, by comparing two sources of truth that already exist in the repository
instead of asserting that a phrase appears. Includes the two ways to build such a
check wrong, both learned by shipping them.

**`notes/objective-completion.md`** — deciding that work is finished with a
command that exits zero, rather than with an agent's report. And the run that
correctly refused to finish, which is the more useful of the two results.

**`notes/memory-system-design.md`** — what a system holding an agent's knowledge has to
guarantee, derived from how that knowledge was observed to fail rather than from a
comparison of storage features. Includes the one failure mode — a process that loaded its
inputs at startup and never learns they changed — that cost the most and that none of the
tools surveyed address.

**`notes/where-knowledge-belongs.md`** — the three-way split: knowledge that must
fail loudly belongs in a check, knowledge that must arrive unbidden belongs in a
skill, knowledge someone will go looking for belongs in a reference. Most
mistakes here are about timing, not content.

## What is deliberately not here

**Anything specific to a project.** Claims about a repository's own code belong in
that repository, where a test can fail when they stop being true. A note about
somebody else's code is stale on arrival.

**Personal memory.** How a particular person likes to work, which machine has how
much RAM, which repository is which — that is real and worth keeping, but it is
someone's context rather than practice, and it lives in a private store.

**Commit hashes and project names.** The evidence is kept — the incident, the
number, the mechanism — because a practice argued without evidence is just an
opinion in the imperative mood. The identifiers are dropped because they are
useless outside the repository they came from.

## Status

Used by one person across several projects, on Linux. The practice is on trial,
not proven: the honest claim is that in one project it changed what a separate
agent wrote, once, in a way that caught a real error. Treat the notes as measured
reports, not as results that have been replicated.
