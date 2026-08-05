# Let a predicate decide when work is done, not the agent

An agent reporting "done" is reporting an intention. It is not lying so much as
grading its own homework with the answer key it wrote. The fix is cheap and
mechanical: **decide completion with a command, before the work starts.**

## The shape

1. Write the failing check first — a test, a script, anything with an exit code.
2. Hand it to the loop as the completion criterion.
3. The loop ends when the command exits 0. Nothing an agent says ends it.

Observed twice on small tasks: the worker wrote the change, the test went green,
the loop stopped, and an independent run found no regressions. The interesting
property is not that it succeeded — it is that success was **decidable without
reading the transcript**.

This inverts the usual order. Writing the test first is normally advice about
design; here it is a hard requirement, because the criterion has to exist before
there is anything to be tempted by.

## The run that refused to finish is the better evidence

One run reached its goal — the predicate passed — and the system still did not
mark it complete, because a second required participant had never contributed.

That is the rule worth keeping: **work that nobody checked does not count as done
by a pair.** A goal predicate answers "is the result right". It cannot answer "was
this reviewed", and a system that conflates the two will happily report a solo
run as a reviewed one. If your process claims review, gate on participation
separately from the goal.

## What this does not establish

Small tasks, with an objective test already available, on one machine, with a
person watching, and the result checked by hand afterwards. It is evidence that
completion can be made decidable — not that long unattended runs work. That is a
different claim needing a different experiment.

## The related trap: budgets that are not ceilings

An outer token budget cannot bound a nested agentic CLI. The wrapper sees one
call; the CLI runs its own loop inside it and resends accumulated context every
internal turn. Measured: a 677-token prompt produced a reported 10.1M input
tokens in a single invocation.

So a pre-call check knows only the prompt size, and a post-call check fires after
the money is spent. Treat such a budget as a **tripwire, not a cap** — one CLI's
own budget flag is documented by its integrators as a post-run accounting guard
rather than a guaranteed pre-request limit. The one control observed to stop
spending mid-run is a process timeout; that is what was tried, not a survey of
everything that might work. And a timeout
set too low reports ordinary work as needing a human, which trains everyone to
raise it. Pick it from a measured distribution of run times, not from a guess.
