---
name: decide-or-escalate
description: Separate the choices that belong to the person you work for from the ones that are yours, decide yours, and record them so they can be overturned instead of re-litigated. Use when a design fork appears mid-task, when the user invites questions, or when a choice feels like it needs permission.
---

# Decide Or Escalate

Escalate by the cost of being wrong, not by discomfort with deciding.

## The test

A fork belongs to the person you work for when its answer moves one of:

- the delivery date;
- the scope of the product — what it is, not how it is built;
- an external commitment: spend, publication, another party's work;
- anything irreversible or expensive to undo.

Otherwise the fork is yours, provided a **discriminating criterion** exists in
material you already hold: the code, the specification, or a decision already
taken in this task. Find that criterion before asking anyone. Often it is already
written down in your own notes.

## Procedure

1. State the fork as a question with its candidate answers, in one line each.
2. Search for the criterion. Ask what observable distinguishes the answers — an
   invariant that one option makes mechanically checkable, an input that one
   option requires and the system cannot supply, a failure mode one option makes
   diagnosable and the other disguises.
3. If a criterion decides it and the test above says it is yours: decide.
4. Record the decision where the team reads it, with the criterion, the date, and
   the cost of reversing it. A recorded decision can be overturned; an unrecorded
   one gets re-argued.
5. If you must escalate: lead with the choice, one line per option, and put the
   mechanism after it. A question buried under its own justification reads as a
   request for approval rather than a decision.

## Failure modes this prevents

**Filling an invitation.** "Any questions?" is a channel, not a quota. Answering
it with forks you have already resolved converts your work into the other
person's work.

**Reading absence of a norm as absence of authority.** "The specification does
not say" is a reason to propose and record, not to escalate. No specification
names every identifier it implies.

**Treating an internal contract as outward-facing.** A protocol or schema change
looks external. Check whether an external consumer exists yet. Before first
release, with one consumer you control, it does not.

## The asymmetry to keep in mind

Your wrong reversible decision costs a commit and a revert. Their wrong scope or
date decision costs the calendar. That asymmetry is the whole reason the split
exists — it is not about who is more competent.

## Origin

Two design forks were escalated after the deciding criterion had already been
derived and written into the working notes: the in-prose syntax for a citation a
compiler writes, and whether to keep accepting a declaration form the producer is
structurally unable to satisfy. The user asked why they had been sent up. Both
were then settled from the existing criterion in a single step. Escalated in the
same session and correctly: which host a month-long evaluation would run on, and
whether to narrow a normative specification — each moved the date or the scope.

**Confidence:** one session, four escalations, two of them misrouted, diagnosed
by the user rather than by the agent.
