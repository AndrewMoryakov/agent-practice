---
name: observe-long-running-work
description: Run work whose duration you have not measured so that its outcome stays observable — no invented deadline, no buffering filter, and a result read from the artifact rather than from an exit code. Use before starting an install, build, test suite, migration, or any command you cannot confidently time.
---

# Observe Long-Running Work

The failure is not that the work takes long. It is that you replaced its signal
with a wrapper's signal, and the wrapper lies convincingly.

## Three ways the signal gets replaced

**An invented deadline.** Wrapping an unmeasured command in a timeout sets a
number you guessed. When it fires you learn nothing about the work — only that
your guess was smaller than reality. Bound work whose duration you have measured;
otherwise let it run and watch it instead.

**A pipeline's exit code.** In most shells the status of `a | b | c` is `c`'s.
Append anything after the real command — a filter, a formatter, a second
diagnostic — and a killed or failed job can report success. The status you read
belongs to the last thing in the line, not to the thing you care about.

**A buffering filter.** `tail`, `head`, `sort` and friends emit nothing until the
stream ends. Kill the job and the partial output — the part that would have told
you where it got to — never arrives. While work is in flight, unfiltered output is
the useful kind; filtering is for what has already finished.

## Procedure

1. **Start it detached and unbounded** when you cannot time it. Let the runner
   notify you rather than racing a deadline.
2. **Send raw output to a file.** No filter in the pipeline while it runs. Read
   the file when you want to know where it is.
3. **Decide the artifact that proves completion** before starting — a binary on
   disk, a row in a table, a file with content, a service answering. Write it
   down; it is what you will check.
4. **Verify by that artifact, never by the exit code.** They disagree exactly when
   it matters.
5. **If you must wait, wait on the condition**, not on a duration: loop until the
   artifact exists or the process is gone.
6. **When it looks stuck, look at movement** — file size, log lines, a counter —
   rather than concluding from elapsed time. Silence from a buffered filter and a
   hung process look identical, and only one of them is a problem.

## What this prevents downstream

A false completion signal does not merely waste the run. It seeds a wrong
diagnosis: the next thing you observe gets explained by a plausible theory that
has nothing to do with the actual cause, and you act on it. The cost of the lost
run is small next to the cost of the theory.

## Origin

Two runs in one session, both blocked on the same substitution.

An install wrapped in a timeout reported exit code 0 while the installer had been
killed — the zero came from the disk-usage command that followed it in the
pipeline. The missing build tool was noticed only afterwards, and the absent
directory it left behind produced a confident, wrong diagnosis: that the install
had run in the wrong directory. It had not. A second look at the process list
refuted it.

A test suite wrapped the same way was killed at the deadline and left an output
file containing one word: `Terminated`. The filter at the end of the pipeline had
been holding everything else.

Both were then run detached and unbounded, and verified by artifact — the build
tool on disk, the runner's own progress lines in the file.

**Confidence:** one session, two runs, both diagnosed after the fact; the
mechanism is generic to any shell and any long job.
