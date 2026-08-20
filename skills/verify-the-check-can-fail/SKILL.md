---
name: verify-the-check-can-fail
description: Confirm a diagnostic, guard, or health check actually fails when the
  thing it inspects is broken, before trusting its pass. Use when authoring or
  relying on any automated check whose green result gates a decision.
---

# Verify The Check Can Fail

A check that can report success without running its checks is worse than no check.

## Procedure

1. Name the invariant the check claims, and the decision its green result gates.
2. Force the inspected condition to be broken; confirm the check goes red and
   exits non-zero. If it still passes, the check is decorative.
3. Trace every path reaching the pass/exit-0 line. Any early return, swallowed
   error, or unentered branch that skips inspection is a false-pass path:
   - a try block without a catch turns a mid-check exception into a silent pass;
   - a filter that matches nothing reports "all clear", not "nothing inspected";
   - a status surface next to the real path (health endpoint, registration flag)
     can be green while the used path fails.
4. Separate "ran and found nothing wrong" from "did not run". Make the second an
   explicit failure, not a pass.
5. For a check gating an irreversible or destructive action, require it to prove
   liveness of what it inspected, not merely the absence of a negative signal.

## Record

`invariant | broken-condition injected | result | exit status | false-pass paths`

Good: with the subject deliberately broken, the check goes red and exits non-zero.
Bad: syntax parses, "all passed" prints, seven inspections never executed.
