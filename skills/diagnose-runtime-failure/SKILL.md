---
name: diagnose-runtime-failure
description: Orchestrate evidence-first diagnosis of a runtime, CLI, process, or integration failure. Use when a reported failure is not yet deterministic, differs by client or environment, or may involve a stale or different build.
---

# Diagnose Runtime Failure

Use the narrow skills in this library as stages, not as competing workflows.

## Route

1. Use `verify-runtime-claim` to identify the claim, observation method, artifact,
   process, and configuration actually under test.
2. Use `reproduce-before-regression-test` when the failure is intermittent or
   has not been isolated outside its original caller.
3. Use `environment-differential-diagnosis` only when equivalent artifacts behave
   differently across parents, hosts, shells, CI, containers, or test runners.
4. Use `mcp-client-integration-review` when the boundary is MCP. Keep every client
   as a separate result.
5. State the proven cause, or state what remains unverified and name the next
   observation that would distinguish the remaining explanations.
6. Use `review-finding-to-safe-fix` only when the user authorized a change and the
   failing mechanism is established.

## Handoff

Report the claim, evidence, tested artifact, reproduction status, environment
delta, bounded conclusion, and next discriminating check.

Example: `registered=true, initialized=false` is a result. “The MCP integration
works because its configuration exists” is not.
