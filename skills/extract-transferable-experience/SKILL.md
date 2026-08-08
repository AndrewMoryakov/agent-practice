---
name: extract-transferable-experience
description: Extract evidence-backed, reusable agent skills from concrete project work. Use after a substantial task, incident, review cycle, failed approach, user correction, or repeated engineering difficulty when the goal is to preserve transferable procedure without coupling it to the source project.
---

# Extract Transferable Experience

Preserve the mechanism learned from real work. Remove accidental project details,
not the evidence or difficulty that made the lesson valuable.

## 1. Reconstruct experience from artifacts

Inspect the available timeline, commands, logs, diffs, tests, review findings,
failed hypotheses, reversals, and user corrections. Do not rely on a polished
final summary alone.

Record each high-information episode as:

`context | attempted action | surprising observation | establishing evidence | correction | consequence`

Prioritize episodes where:

- a plausible approach failed;
- two checks contradicted each other;
- an agent asserted more than its evidence established;
- documentation or memory failed to preserve an invariant;
- behaviour changed across builds, clients, environments, or process boundaries;
- shared state or authorization constrained the safe solution;
- the user had to correct a recurring mode of reasoning.

## 2. Extract the causal mechanism

Explain what made the episode difficult before generalizing it. Separate:

- project fact: true only for this system;
- external constraint: imposed by a runtime, protocol, tool, or environment;
- engineering mechanism: the causal pattern that can recur;
- corrective procedure: the repeatable actions that improve the outcome.

Do not turn “we used command X” into a skill. Ask why X was needed, what wrong
conclusion it prevented, and which observable distinguished the explanations.

## 3. Apply the skill-worthiness gate

Create a candidate only when all are true:

- the trigger is recognizable before or during future work;
- the procedure is non-obvious and actionable;
- recurrence would be costly, risky, or likely;
- the lesson is supported by an observed episode, not only preference;
- the procedure plausibly helps in at least one unrelated project or domain.

Reject or store elsewhere:

- one-off commands, paths, versions, and configuration facts;
- generic virtues such as “test carefully” without a decision procedure;
- project policy that should remain in that project’s instructions;
- domain reference material without a reusable workflow;
- a renamed copy of an existing skill.

## 4. Generalize without hollowing out

Replace project nouns with roles only after the mechanism is clear: server,
client, artifact, build, workspace, invariant, external system. Preserve concrete
decision points, evidence requirements, failure modes, and safety boundaries.

Run three checks:

1. Removal: does the procedure still work when project names and paths disappear?
2. Transfer: can an unrelated scenario use the same trigger and steps?
3. Specificity: would a fresh agent know what to inspect, decide, and report?

If removal makes the lesson a platitude, restore the causal detail. If transfer
requires the original architecture, keep it as project knowledge rather than a
universal skill.

## 5. Design the candidate

For each surviving candidate, define:

`name | trigger | inputs | procedure | safety boundary | output | exclusions | origin evidence | confidence`

Keep the canonical procedure agent-neutral. Put installation syntax, UI metadata,
and product-specific invocation in adapters. Keep source-project provenance in
the retrospective record; mention it in the canonical skill only when needed to
explain a transferable example.

Search the existing skill catalog before creating a new skill. Extend an existing
procedure when the mechanism and trigger already match.

## 6. Validate transfer

Test the candidate on a fresh scenario that does not expose the source project or
the intended conclusion. Check whether the agent recognizes the trigger, follows
the evidence boundary, avoids the original failure mode, and produces the defined
output. Revise or reject a candidate that works only with leaked context.

Do not create or install skill files unless the user requested implementation;
an extraction-only task may end with reviewed candidates.

## Example

Episode: a client persisted a server configuration, but its health check failed.
Weak lesson: “check configuration carefully.”
Transferable skill: distinguish `configured`, `initialized`, `tools-listed`, and
`safe-call-succeeded`, and report evidence for each state.

Non-skill: “version 4.2 requires flag `--legacy`.” That is versioned reference
material unless it reveals a reusable procedure for detecting compatibility.
