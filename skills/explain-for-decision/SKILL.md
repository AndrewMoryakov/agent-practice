---
name: explain-for-decision
description: Explain a technical situation to the person who has to decide, in applied language first, with technical detail after it and shorter. Lead with what changed for them, say what is not verified or cannot be undone, and name the one open question with its cost in their units. Use before any report of finished, stopped or failed work, and whenever they say they lost the thread, mention juggling other work, ask for plain or applied language, or a decision has sat unanswered across turns.
---

# Explain For a Decision

The failure is not that the explanation was too long. It is that it was a log of
what I did, arranged in the order I did it, when what the person needed was a
statement of what is now true and what they must choose.

An owner running several projects at once has no spare attention for my
chronology. Every identifier I put first — a commit hash, a file path, a flag name —
costs them a lookup they will not perform, and each one pushes the actual
question further down the page.

## When it applies

Every report that closes a piece of work: finished, stopped, or failed. Waiting
for a sign of overload means the first few reports go out in the wrong register.

And, without being asked twice, whenever any of these appear:

- "я не понял", "объясни прикладным языком", "слишком много технической информации";
- they mention running other projects in parallel, or say they lost the details;
- a decision I asked for has gone unanswered for more than one exchange — that is
  usually not reluctance, it is that the question was never put in answerable form;
- I am about to write a third paragraph of what I did before the first sentence of
  what it means.

**Do not restate more carefully.** A second attempt at the same register fails the
same way. Change the register: concrete case first, their units, no identifiers.
(See the standing instruction in memory: `explain-concretely`.)

## The shape that works

Five parts, in this order, then the technical part if it helps:

1. **What changed for you.** Not what I did. "Your fork was two months behind the
   main project; now it has everything the project has and nothing of yours is
   lost." One paragraph.
2. **What it means practically.** Especially: what did *not* change. The thing they
   use every day, the tool they run, the file they open — say explicitly that it
   still works, and that I checked.
3. **The one open question**, in their vocabulary. One question, not a list. If
   there are genuinely two, the second is usually mine to decide, not theirs.
4. **What it costs**, in units they feel: minutes of their machine being unusable,
   risk of having to redo work, what stays blocked while it runs. Never in tokens,
   never in commits.
5. **What I need from you** — a word, not an analysis — and **what I will do
   without you**: the safe part I can get on with while they think.

## What goes second

Technical detail is not forbidden; it is subordinate. It goes after the applied
part, under its own short heading, and is shorter than it. A reader who skips it
must not lose the point.

- Commit hashes, branch names, file paths, flag names, test names, counts: in the
  technical part, or left out when they add nothing.
- The chronology. They do not need to know what I tried first.
- My reasoning about tooling. "I had to work around a credential store" is my
  problem, not theirs, unless it changes what they must do.
- Tables of measurements. One number they act on beats six they skim.

## What never to strip

- Which part is a guess. "I expect it is small, nobody has measured it" keeps
  their trust when the number lands differently.
- The irreversible bits. If something cannot be undone, that belongs in the
  explanation even if it makes it longer.
- The fact that their own hypothesis was right or wrong, said plainly. If they
  reason out loud ("82 should be smarter than 80, no?"), answer that directly with
  the evidence before adding anything of my own — their hypothesis is the thing
  they can act on.

## Length

An overloaded reader gets about 400 words, most of them applied. If it will not fit, the explanation is
carrying work that belongs elsewhere: the technical version goes into the
repository record, the artifact page, or a follow-up they can ask for. Offer it in
one line; do not deliver it unasked.

## When not to use this

When they asked for the detail. "Покажи порядок работ", "покажи запись" and
"проверь, не потеряли ли" are requests for precision, and answering them in plain
language is its own failure. This skill is for reports that close a piece of work
and for the moment a decision stalls, not for every message.

## Origin

2026-11-05, the closing day of a long upstream-merge intake in a C++ fork. After
a day of correct but dense reporting — seven conflict regions, twelve gates,
three review agents, a workflow — the person it was written for said they could
not make the decision: too much technical information, and the details had been
lost while several other projects ran in parallel. The same facts re-stated in
five plain parts produced an immediate decision on the next step, plus a
hypothesis of their own that turned out to be verifiable in two commands. Nothing had been missing from the technical version;
what was missing was the form.

2026-11-08, the same owner, after a day of reports written as logs: technical
detail may stay, as long as applied, product language dominates. Stripping every
identifier over-corrects; the rule is order and proportion, not removal. The same
day showed why the skill had not fired: it waited for a sign of overload, while
an always-on instruction asking for more technical explanation was active.

**Confidence:** two sessions, one owner, one strong signal and one refinement. The shape above is
worth following; the 400-word figure is a heuristic, not a measurement.
