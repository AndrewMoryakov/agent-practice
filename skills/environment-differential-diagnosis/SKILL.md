---
name: environment-differential-diagnosis
description: Diagnose behaviour that differs across equivalent launches in shells, CI, test runners, containers, hosts, or agent clients. Use after a working and failing observation of the same artifact have been established.
---

# Diagnose Environment Differences

Compare launches, not assumptions about launches.

## Procedure

1. Capture one known-working and one known-failing invocation of the same artifact.
2. Compare executable, arguments, cwd, parent process, identity and permissions,
   stdin/stdout/stderr wiring, timeout, resource limits, filesystem, and network.
3. Compare environment values by class:
   - show safe operational values such as runtime flags, locale, and normalized paths;
   - show secrets as present/absent or a non-reversible fingerprint;
   - exclude or label volatile session identifiers.
4. Use a transparent wrapper to record whether the child starts, receives the
   first request, responds, and how it exits.
5. Recreate the failing launch profile and vary one factor per experiment.
6. Separate the observed delta from the hypothesized mechanism.

## Delta record

`factor | working value | failing value | controlled run | outcome`

Good: prove that changing one runtime flag changes the outcome.
Bad: compare only environment variable names and declare environments equal.
