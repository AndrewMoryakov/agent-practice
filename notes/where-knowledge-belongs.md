# Three kinds of knowledge, three homes

Knowledge a project accumulates splits three ways, and the split is decided by
**how it has to reach someone**, not by what it is about.

| The knowledge | Its home | Why not elsewhere |
|---|---|---|
| must **fail loudly** when it becomes false | an executable check | a document cannot notice it went stale; a test fails the build |
| must arrive **unbidden at a decision** | a skill or instruction | nobody queries a reference they did not think to query |
| someone will **go looking** for it | a reference or knowledge store | it stays out of the way and is still findable |

The middle row is the one usually got wrong, and the failure is about timing
rather than content:

> **A rule read at session start does not fire at a decision made two hundred
> thousand tokens later.**

That is not hypothetical. A project whose onboarding document already carried
"verify status against the code and tests" had three agents file claims that
measurement refuted within two days — while reading it. The rule was correct,
present, and inert. Moving the same words into something loaded *at the moment a
claim is written* is the whole intervention.

## Consequences worth taking seriously

**Never keep claims about a repository's own code outside that repository.** Such
a note is stale on arrival: the code is the truth about its own behaviour and it
moves. The nine drift incidents behind
[`mechanical-guards.md`](mechanical-guards.md) were all of this shape. A test can
be less wrong than a note, because it runs.

**What genuinely travels is measured facts about the outside world** — external
tool limits, costs, environment behaviour — things belonging to no single
repository. Two that earned their keep:

- an outer token budget cannot bound a nested agentic CLI's spend; measured at
  10.1M reported input tokens from a 677-token prompt
- `git status --porcelain` carries no content, so it cannot detect a change to a
  file already shown as modified — five successive edits produce one distinct
  fingerprint by porcelain, five once `git diff` is included

**Duplication across harnesses is sometimes unavoidable, and then it needs a
guard.** Different agents read different files, so one rule may have to exist in
two places. Do not rely on discipline to keep them together — mark each copy with
a stable identifier and compare the sets mechanically. Never compare the wording:
the copies are supposed to differ.

## A caution about the third row

A knowledge store is read at the start and believed. A wrong entry is worse than a
missing one, because nothing re-checks it against reality — the same failure mode
as documentation describing code. Put there only what does not rot: how someone
works, what was measured, what was tried and failed, and decisions with their
reasons.
