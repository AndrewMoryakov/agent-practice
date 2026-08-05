# A memory system designed around how knowledge fails

Written from two days of measurement, not from a survey of tools. Every
principle below is followed by the observation that forces it; where an
observation is weak, it says so.

This expands [`where-knowledge-belongs.md`](where-knowledge-belongs.md), which
gives the three-way split. That note says where knowledge goes. This one says
what the system holding it has to guarantee.

## The question that is usually asked, and the better one

"Where should this knowledge live" invites a comparison of storage features —
graph or flat, vector or lexical, local or hosted. Every candidate wins on some
axis and the choice comes down to taste.

The question that discriminates is:

> **How will this become false, and will anyone find out?**

Sort by failure mode and most of the storage debate disappears, because the
categories want different machinery rather than a better version of the same
machinery.

---

## 1. Route by failure mode, not by subject

- **Can become false** → somewhere its falsity breaks a build. A test, not a
  sentence.
- **Needed at a moment nobody will think to search** → somewhere that loads at
  that moment. An instruction that fires on the work, not a page.
- **Neither** → a store.

*Observed:* nine drift incidents in two days, where documentation asserted
something the code contradicted. Every one belonged in the first category and
was sitting in the third. Rewriting them more carefully would have bought
nothing; the ones that stopped recurring became checks.

## 2. A claim carries how it was established **and against which version**

Grade alone is not enough. A reproduction is a fact about a build, and if the
build is unnamed the grade overstates itself.

*Observed:* a defect was filed as reproduced — the call was made, the rejection
came back, the transcript is real — against a long-running server started three
and a half hours before the code on disk changed. The behaviour had already been
removed. Two people reached the same wrong diagnosis from the same symptom on
consecutive days. **~3.5 hours.**

## 3. A statement that cannot say when it would be false does not get written

Every durable entry names the date or the event after which it stops holding.
No such condition means either an eternal truth or an unfinished thought, and
the second is far more common.

*Observed:* entries with an explicit expiry are the only ones that can be swept
mechanically. Everything else accumulates and is believed indefinitely, because
nothing re-reads it against reality.

## 4. Two independent records of anything important, compared by a machine

This is the only mechanism here that catches an error **nobody anticipated**.
Every other check catches what it was built from.

The shape: derive the same fact two ways and let a checker compare. In one
implementation a transcript's hash is taken over the original text so it stays
comparable with a hash the event log computes independently for the same
message. If they diverge, something dropped or altered content — and the alarm
does not depend on anyone having predicted that failure.

*Observed:* every guard written from a known incident caught that incident and
nothing else. Guards fitted to observed failures are overfitted by construction.

## 5. Loaded state must be able to notice it went stale

The most expensive failure measured, and the one no storage tool addresses,
because it is a property of process lifecycle rather than of a store.

A process reads its inputs once at startup. The inputs change. Nothing tells it,
and it keeps answering confidently from a world that no longer exists.

The mechanism that does not exist anywhere I have looked:

- an artifact records the content hash of what it loaded, at load time
- a cheap comparison against disk runs at **decision points**, not on a timer
- divergence is **surfaced, not silently reloaded** — whether to trust the old
  reading is a judgement, and the holder may have good reason to keep it

*Observed:* four occurrences in two days — a server holding pre-rebuild code, a
working copy three commits behind the tree that live symlinks pointed at, a
session acting on an instruction that had been corrected hours earlier, and a
person's own summary of a rule contradicting the document it cited. A file-level
expiry sweep finds the first kind on disk and is blind to all four in memory.

## 6. Admission cheap, canonisation deliberate

Manual writing produces an empty store: over a long, dense working day only
three entries were eligible, and a formal trial of the store's usefulness
recorded zero coverage on its first three tasks — the knowledge simply was not
there.

Automatic capture fixes that and introduces a worse problem: it canonises
fast-moving project state that is false within hours — task statuses, current
baselines, "this is ready".

Resolution: **capture automatically into a staging area with no authority;
promote to canonical through review.** The staging layer is allowed to be lossy
and is labelled as such wherever it is read.

*Observed:* an observation page built this accidentally. A poller archived
agent messages before the next run erased them, and said on its own face that it
is a stopgap that can only keep what it happened to see. That honesty is what
makes it safe to use.

## 7. Retrieval is triggered by the shape of the work, not remembered by the agent

A store that must be consulted deliberately will not be consulted. The trigger
belongs on the work: an external tool, a runtime limit, a cost figure, an
approach that may already have been tried.

*Observed:* over a full day of work with a store available and a standing
instruction to use it, it was queried once — and only because someone asked
directly.

## 8. The store must be able to say it has nothing

Lexical search always returns something. A system that cannot answer "I don't
know" produces confident noise, and — worse — makes an empty corpus
indistinguishable from a broken search. Those two call for opposite responses:
one wants more writing, the other wants better retrieval.

Practical form: judge by the **gap** between the top result and the next. Flat
scores mean no answer, and that has to be reported rather than papered over with
the top hit.

---

## What such a system deliberately does not get

- **A semantic layer as a cure for low coverage.** If the knowledge was never
  written, better ranking finds nothing.
- **Automatic canonisation.** See §6.
- **New entity or edge types while an experiment is measuring it.** The
  instrument does not change mid-measurement, and it does not get retuned after
  each result either.

## What this design is worth

Two days, one machine, one person. Half the observations are that person's own
mistakes, noticed by them — so the ones that went unnoticed cannot be in the
sample and are, by construction, the more dangerous half.

Of the eight principles, three were already in place in some form, four exist in
various shipped tools, and **§5 was not found in any of them** — while being the
one that cost the most.
