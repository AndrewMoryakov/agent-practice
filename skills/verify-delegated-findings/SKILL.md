---
name: verify-delegated-findings
description: Turn findings returned by subagents, reviewers, or automated analysis into something you can act on. Use whenever work you did not perform yourself arrives as a list of conclusions, especially before those conclusions reach a plan, a commit message, or the person you work for.
---

# Verify Delegated Findings

A finding you did not establish is a hypothesis with a citation attached. It
becomes evidence when you check it, and not before.

## Why this needs a procedure

Delegated findings arrive fluent, structured and confident, and the fluency is
uncorrelated with correctness. They are also expensive to re-derive, which is the
whole reason they were delegated — so the temptation is to relay them. Relaying
one wrong finding is worse than not delegating at all: it launders an unverified
claim through your own credibility.

## Before delegating

**Give each agent a different lens, not the same task.** Identical prompts
produce correlated blind spots: three agents asked "review this plan" agree with
each other and miss the same thing. Ask one for consistency against the code, one
to attack the ordering and try to refute, one for the product and release
consequences. Disagreement between them is the output you are paying for.

State the evidence grade you require per finding, and forbid expensive side
effects explicitly — a full test run, a build, anything that consumes a shared
resource you are managing.

## When the findings arrive

1. **Sort by what acts on them.** A finding that changes a plan, a commit message
   or a recommendation to a person needs verification. A finding that only tells
   you where to look does not.
2. **Verify the load-bearing ones yourself, at the file and line.** Read the code,
   run the command. This is usually minutes, because the finding says where.
3. **Expect partial correctness.** The common shape is not a fabricated finding;
   it is a real defect with the wrong cause attached, or a correct mechanism
   attributed to code that does not do that. Both halves need checking: the
   observation and the explanation.
4. **Treat contradiction between agents as a question, never as a vote.** Two
   agents disagreeing have handed you a precise thing to check. Resolve it with
   the code, then say plainly which one was wrong — including when the wrong one
   supported the conclusion you preferred.
5. **Report the grade you have, not the grade they claimed.** "Read only,
   verified by me at file:line" and "read only, relayed" are different claims.
   See `claim-discipline`.

## What this is not

Not a reason to redo the delegated work. The value is in the search, and the
search is what you keep; verification is targeted at the handful of findings that
will actually change what you do.

## Origin

Three agents reviewed a work plan against a codebase, each with a different lens.
Their strongest findings were real and changed the plan's shape: a third input
surface nobody had named, and a slice boundary that could not compile. One agent's
top finding was partly wrong — it claimed a pre-migration validator was not wired,
and the validator was wired and correct — while the defect underneath it was real
and worse than described. Two agents contradicted each other about whether a
backlog item was touched by the work; the code settled it in one grep, and the
agent that was wrong was the one whose conclusion was more convenient.

**Confidence:** one session, three agents, roughly thirty findings, four of them
verified individually before use.
