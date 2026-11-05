---
name: trust-a-measurement
description: >-
  Load before reporting a number produced by a benchmark, profiler, counter or
  instrumented run, and before comparing two such numbers. A measurement fails
  differently from a check: it can be precise and wrong, or honest and useless,
  and neither shows up as a red result. Five questions separate a number you can
  act on from one that only looks like data.
---

# Trust a measurement

A check answers yes or no, and [[verify-the-check-can-fail]] covers how it lies.
A measurement answers *how much*, and lies in ways that leave the check green:
the harness runs, the artifacts appear, the number is printed, and it means
something other than what you will say it means.

## 1. Is the measured phase longer than the noise?

Repeating a too-short measurement does not make it reliable. If each repetition
is shorter than the timescale of scheduler jitter, turbo transitions and
background work, every repetition samples the same noise and the spread stays.

Measured on 2026-09-10: comparing two builds with `-p 512 -r 3` gave
`285.00 ± 72.27` against `316.33 ± 81.54`. The spread was a quarter of the
value and the comparison was worthless. The prompt phase lasted under two
seconds. Lengthening the phase fourfold and raising repeats to ten gave
`272.74 ± 11.43` against `328.76 ± 23.22` — the same experiment, now decisive.

Fix the duration first, then the repeat count. Order matters.

## 2. Does the harness still parse what the program prints?

An instrumentation harness that reads a program's stdout has a contract no test
covers. Compilers do not check it, unit tests do not exercise it, and the
program's own internal validation passes while the harness reads the wrong line.

Measured the same week: after an upstream merge, `llama-cli` gained its own
timing summary line and stopped calling `llama_print_timings`. The harness regex
accepted both `runs` and `tokens`, so it began matching a line reporting
generated tokens where it wanted decode calls — a permanent off-by-one. The
sidecar's own footer was internally consistent and marked `complete: true`.
Build, `ctest` and every internal check passed.

So after any dependency upgrade, run the measurement pipeline itself, including
the modes a smoke run does not touch. Ours was rehearsed without the timing
flag and therefore missed exactly this branch.

## 3. How much does the instrument perturb what it measures?

Measure the perturbation instead of assuming it is small. The same MiniMax run
gave 3.02 t/s and 164 MB per token unobserved, 2.56 t/s and 222 MB per token
under an ETW capture, and 1.22 t/s with routing tracing enabled. Roughly a third
and roughly a factor of two.

That does not make the instrumented run useless — it makes its *proportions*
usable and its *absolute values* not. Attribution shares held up; throughput did
not. State which half you are quoting.

## 4. Was the number measured, or reconstructed?

Instruments frequently derive a quantity from others and label it. Read the
label. The same harness reported `phase_method =
reconstructed_estimate_from_end_and_reported_tps`, meaning the decode window was
inferred from the end time and the reported rate, not observed at token
boundaries. Throughput was measured; bytes per token was an estimate over an
inferred window. They came from one run, in one CSV, and are not the same
quality of evidence.

## 5. Is there a negative control?

Before trusting that a metric distinguishes two states, show it reading the
uninteresting state correctly. A rehearsal on a model that fits in RAM reported
`steady 0 B/tok`. That zero is what made the later 164 MB per token mean
something: the metric was shown able to say "no traffic" before it was asked to
quantify traffic.

A control run is usually cheap, usually skipped, and is the difference between a
number and a number that argues for something.

## 6. Are the two runs reading the same input? Then pair them

The ± printed next to a single run is the uncertainty *of that run's mean*. Using
it to compare two runs over the same input throws away the thing that makes the
comparison sharp: both sides saw the same items, so their per-item differences
cancel the between-item spread.

Measured on 2026-11-05: two builds of the same program, same model, same 29-chunk
corpus slice, printed `10.7452 ± 0.36233` and `10.7082 ± 0.35996`. Read as
intervals that is "overlapping, probably fine". Paired per chunk — reconstructing
per-chunk nats from the running estimates — the difference was `+0.00345` with a
paired standard error of `0.00691`, so |t| = 0.50. The paired statement is fifty
times tighter and says something the intervals cannot: the two builds do not
differ, rather than "we could not tell".

The same arithmetic protects against the opposite error. A gap that survives
pairing is real: in the same session, two different quantizations of one model
differed by 2.6967 against a combined uncertainty of 0.45 — six sigma, not a
margin to argue about.

So: when the inputs are shared, compute the per-item differences and their paired
SE. When they are not shared, say so, because then the wide interval really is
the right yardstick.

### Cross-read the instrument on a case where it must not matter

Question 5's negative control applies to the **tool**, not only to the metric.
Before trusting a number from a new build of a measuring program, run it against
an input where theory says it cannot differ from the old build, and check that it
doesn't.

On 2026-11-05 an upstream fix touched the AVX-512 path for a specific family of
quantization types. One of the two models under test contained none of those
types, so a cross-read of both binaries on that model had to come out flat. It
did (the paired numbers above), and only then was the second model — which does
contain 14 tensors of an affected type — measured with the new binary. The run
that produced no new knowledge about the models is what turned the other run into
evidence. It cost eleven minutes.

## When the answer is uncomfortable

If a measurement will not survive these five questions, say so and name which
one it fails. A caveated number that is then quoted without its caveat does more
damage than a missing number, because the caveat does not travel with it —
see [[assumption-in-metafile-becomes-fact]].
