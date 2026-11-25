---
name: parallelize-a-sequential-suite
description: Turn a test or check suite that runs its independent parts one after another into one that uses the machine's cores, without trading speed for flakiness. Use when a suite takes tens of minutes on a many-core machine and its parts (games, packages, levels, targets) do not depend on each other.
---

# Parallelize a Sequential Suite

A suite written as a loop over independent parts runs on one core no matter how
many the machine has. The tempting fix, "run the parts in the background and
wait", is the easy half. The hard half is what the parts shared without anyone
noticing, because running alone hid it.

## Before changing anything

1. **Measure the sequential run.** Total time, and the time of each part. The
   parts' times decide how many workers are worth having: when one part is half
   the total, more than two workers buy little. Write the numbers down; the
   result is reported against them.
2. **List what a part touches outside itself**, and read the scripts to find it:
   - temporary directories and the free space under them (a full temporary
     directory times parts out at random places, which reads as a flaky test);
   - ports, sockets and servers a part starts;
   - browser or tool profiles, caches and lock files;
   - output files with fixed names;
   - external side effects that count per launch: a sign-in, a licence check,
     an operating-system logon event, an API rate limit. Some of these lock an
     account after N events in M minutes; running parts at once can cross a
     limit that the sequential run never reached.
3. **Find the timing-sensitive checks.** Waits of fixed length, screenshots taken
   at a moment, "the animation is over by now". Under load they get slower and
   their results change. A suite that compares two runs pixel for pixel or
   byte for byte is the sharpest case: both runs must see the same conditions.

## The change

- Give every worker its own temporary directory, ports and profile; derive them
  from the worker's index, never from the time.
- Cap the workers below the core count when parts start browsers or compilers
  that are themselves multi-threaded; start with half the cores and measure.
- Keep each part's output in its own file and print a summary in a fixed order,
  so a failure is attributable and the log does not interleave.
- Keep the exit status honest: the suite fails if any part failed, and says
  which. Waiting for all children and collecting their statuses is the part
  most often written wrong (`wait` without the PIDs loses failures).
- Leave the sequential path available behind a switch, for debugging one part
  and for comparing results.

## Proving it

Run the parallel suite twice and the sequential one once on the same commit.
The result is accepted when the same parts pass and fail in all three, and the
timing-sensitive checks did not change verdict. Report the speed-up as the pair
of measured times, not as a ratio alone. A suite that got faster and started to
flake has not been parallelized; it has been broken in a way that is harder to
see.

## Exclusions

Parts that share state by design (a migration then the tests that need it, a
server started once for all) are ordered work, not independent parts: keep the
order and parallelize only inside each stage.

## Origin

A game project's full check suite (walks of eleven series at three levels,
online tests, screenshot comparisons) ran sequentially for about 40 minutes on a
32-thread machine (2026-11-14). The same project had already met two of the
traps above while still sequential: random timeouts from a full shared
temporary directory, and an account lockout caused by one logon event per
browser launch (10 in 10 minutes). The speed-up itself has **not been measured
yet**: this procedure is untested until a parallel run is compared with the
sequential one as described in "Proving it".

**Confidence:** medium for the traps (observed), low for the gain (not measured).
