---
name: claim-discipline
description: >-
  Load before writing any consequential claim — a finding, a task status, a
  review conclusion, a test result, a "this is fixed / this is safe / this
  cannot happen", or a commit message asserting what was verified. Also before
  marking work delivered, or reporting numbers from a run. Turns "be careful"
  into a required field: every claim carries how it was established. Read at the
  moment of writing, not at session start — that gap is why the equivalent rule
  sitting in a project's AGENTS.md failed while being read.
---

# Claim discipline

A rule read at session start does not fire at a decision made two hundred
thousand tokens later. That gap — not ignorance of the rule — is how this was
learned: a project whose `AGENTS.md` already said "verify status in code and
tests" had three different agents file claims that measurement refuted within
two days, while reading it.

So this is written to be loaded *at* the moment of writing a claim. Where a
project also needs its non-Claude agents to see it, mirror this text into that
repository and route them to it there; a rule only one harness can see does not
transfer a habit to the others.

If the repository you are working in carries its own
`docs/CLAIM_DISCIPLINE.md`, read that too — a project may add its own failures
and its own mechanical checks. This text stands alone without it.

## The practice

Every consequential claim carries one of three grades, stated or obvious:

| Grade | Means | What you must be able to show |
|---|---|---|
| **reproduced** | You made it happen, deliberately | The commands and the observed output |
| **measured** | You read it off a real run | The run, at the scope you name |
| **read only** | You concluded it from source | The file and line — and the word "unverified" |

A claim with no grade defaults to **read only**. Say so. "Read only" is a
respectable grade; a read-only claim presented as measured is the defect.

Before you write it:

1. **Name the command that establishes it.** If you cannot, the grade is *read
   only* — write that word.
2. **Did you run that command, at that scope, in this session?** If not, do not
   report it.
3. **Compare lists, not counts.** A new failure hiding behind a fixed one keeps
   the count flat.
4. **For "X is now fixed": is the test non-vacuous?** Disable the fix and watch
   the test fail. A test that passes with the code removed proves nothing.
5. **For a status change: does the record already contradict you?**

If a claim can be checked mechanically, write the check instead of the sentence.
It is the only documentation that fails loudly when it becomes false.

When you are wrong: say which claim, what refuted it, and correct the record in
the same breath.

## A grade answers two questions, not one

*How* it was established, and **against what**. Reproduction against an unknown
version is `read only` about the current state.

Learned by getting it wrong: a defect was filed as *reproduced* — the call was
made, the rejection came back, the transcript is real — against a long-running
server process started three and a half hours before the build on disk. The rule
in question had been relaxed in the meantime. The finding was true and useless,
and two agents on consecutive days reached the same wrong diagnosis from the
same symptom.

So when the subject is a running process, a service, an external CLI or anything
else that holds code in memory: **name the build, not just the run.** If you
cannot determine it, say so — that is the honest grade. A symptom that
contradicts the source is a staleness question before it is a bug report.
