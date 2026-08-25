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

That links `skills/` into both `~/.claude/skills` and `~/.codex/skills`. Links,
rather than copies, leave one canonical version of each practice. Skills are
user-global, so there is no project path to configure.

## What is here

**`skills/claim-discipline`** — every consequential claim carries how it was
established: *reproduced*, *measured*, or *read only*. It exists because stating
the rule was demonstrably not enough. A project whose onboarding document already
said "verify status against the code and tests" had three agents file claims that
measurement refuted within two days, while reading it. The difference is when it
loads: a skill is pulled in at the moment a claim is being written, not two
hundred thousand tokens earlier.

**`skills/diagnose-runtime-failure`** — routes a runtime or integration failure
through evidence capture, reproducibility, environment comparison, and client
integration checks rather than treating these as competing workflows.

**`skills/mcp-client-integration-review`** — distinguishes a persisted MCP
configuration from a completed handshake, discovered tools, and a safe successful
call. Each client gets its own result.

**`skills/reproduce-before-regression-test`** — turns a field failure into a
deterministic or explicitly probabilistic reproducer before it becomes a test.

**`skills/environment-differential-diagnosis`** — compares real launch
conditions, including redacted environment values and stdio/process boundaries,
when the same artifact behaves differently.

**`skills/review-finding-to-safe-fix`** — turns an established finding into the
smallest authorized change that protects its invariant, choosing refusal, partial
status, or warning by consequence.

**`skills/agent-worktree-boundaries`** — keeps an agent from overwriting or
silently incorporating another owner's changes in a shared workspace.

**`skills/extract-transferable-experience`** — extracts reusable procedure from
measured project experience while leaving project facts and private provenance in
their proper home.

**`skills/decide-or-escalate`** — which forks belong to the person you work for
and which are yours. Escalate what moves the date, the scope, an external
commitment, or cannot be undone; decide the rest from a criterion already present
in the code or the specification, and record it so it can be overturned rather
than re-argued. Written after two forks were sent up whose deciding criterion the
agent had already derived and written down.

**`skills/verify-delegated-findings`** — a finding returned by a subagent or
reviewer is a hypothesis with a citation attached. Give agents different lenses so
their disagreement is informative, verify only the findings that will change what
you do, and treat two agents contradicting each other as a thing to check rather
than a vote. Written after one agent's top finding turned out to be half wrong
with a worse real defect underneath it.

**`skills/derived-identity-migration`** — a schema change that alters what a
hash-derived identifier identifies cannot always restate it, because everything
else references it. The half-migrated outcome is the dangerous one: rows upgrade
cleanly and the first recomputation fails claiming corruption, which is true
about the comparison and wrong about the cause.

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

**`notes/skill-adapters.md`** — separates agent-neutral skill procedures from
the discovery, UI, and installation adapters required by different agent hosts.

**`notes/green-tests-that-stopped-proving.md`** — three ways a test keeps
reporting green after it stopped guarding anything: it pins a claim that became
false, its subject moved to another artifact, or its name asserts more than its
body. Missing coverage is visible; this is not.

**`notes/slice-boundaries.md`** — a slice boundary is only real if the tree can
stop there compiling, with something to assert, and revertible alone. A change to
a shared protocol type is atomic whether or not the plan says so.

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
not proven: individual skills report their own evidence and limitations. The seven
new engineering skills are candidates derived from observed work; they still need
independent forward-tests outside the projects that produced them. Treat the notes
as measured reports, not as results that have been replicated.

## License

Licensed under the Apache License, Version 2.0. See [LICENSE](LICENSE).
