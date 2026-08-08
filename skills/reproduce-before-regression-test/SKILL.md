---
name: reproduce-before-regression-test
description: Convert a field failure into a deterministic or explicitly probabilistic reproducer before adding a regression test. Use for flaky CLI, process, network, concurrency, timing, or environment-dependent failures.
---

# Reproduce Before Regression Test

A failing test is useful only when it represents the reported failure rather
than an accidental property of its runner.

## Procedure

1. Preserve the original command, artifact, inputs, environment, expected result,
   actual result, exit status, and stderr.
2. Make a standalone reproducer with one observable success/failure condition.
3. Repeat it enough to characterize stability; report the run count and outcomes
   rather than inventing a universal repetition threshold.
4. Add a negative or comparison control that changes one relevant condition.
5. Verify the test fails on the affected build and passes on the fixed build. For
   nondeterministic bugs, encode and justify the statistical acceptance rule.
6. Remove temporary probes and speculative production changes.

Good: a black-box test uses the same process boundary as the field failure.
Bad: a test-runner-only failure is committed as proof of a production defect.
