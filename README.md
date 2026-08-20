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

**`skills/verify-the-check-can-fail`** — a diagnostic or guard whose green
result gates a decision must be shown to go red when its subject is broken. It
traces the paths that let a check exit success without inspecting anything — a
catch-less try that turns a mid-check error into a silent pass, a filter that
matches nothing and reports all-clear, a status surface next to the real path
that stays green while the used path fails. From a health check that exited zero
having skipped most of its own checks.

**`skills/scrub-history-before-publish`** — an irreversible publish exposes every
commit, not the working tree. Scan the whole history for secrets and internal
identifiers, rewrite the commits that carry them, drop the backup refs a rewrite
leaves behind, and re-scan the published result. From a full-history scan that
caught an internal address in an example file one commit back, before a public
push.

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

**`notes/shared-network-trust-boundary.md`** — a service reachable through a
shared network's gateway is reachable by every member of it, and address
translation can map a neighbour into the address the service trusts. Verify the
negative — that an unintended member cannot reach it — and scope exposure to the
intended peers rather than strengthening the password. From a neighbour that
read a protected surface with no credential at all.

**`notes/destructive-selection-by-invariant.md`** — choose the targets of a
destructive batch action by the property that defines a bad target, not a
correlate a healthy item can share, and exclude the actor's own context. From a
cleanup filter keyed on a port number that would have killed the live process
and spared the dead one.

**`notes/verify-redundancy-before-discarding.md`** — before deleting a copy you
believe is redundant or superseded, compare its content against the authoritative
version rather than trusting your account of where it came from; an unexpected
difference is the finding. From a stale working copy that matched the last push in
twelve of thirteen files and diverged in the thirteenth.

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
not proven: individual skills report their own evidence and limitations. The nine
new engineering skills are candidates derived from observed work; they still need
independent forward-tests outside the projects that produced them. Treat the notes
as measured reports, not as results that have been replicated.

## License

Licensed under the Apache License, Version 2.0. See [LICENSE](LICENSE).
