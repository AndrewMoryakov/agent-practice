---
name: agent-worktree-boundaries
description: Make scoped changes safely in a shared or already-modified workspace. Use when another person or agent may own existing changes, regardless of version-control system, or when a task touches only part of an active workspace.
---

# Protect Shared Workspaces

Treat existing changes as owned by someone else until established otherwise.

## Procedure

1. Detect the workspace and version-control system. Inspect status and relevant
   diffs when supported; otherwise inventory timestamps and scoped files.
2. Separate pre-existing state from paths required by the current task.
3. Avoid overlapping edits. Do not create a parallel copy of a canonical file to
   evade coordination; create a new file only when it is a distinct artifact.
4. Make task-local changes without formatting or rewriting unrelated files.
5. Before handoff, report changed paths, preserved pre-existing state, and exact
   validation methods.

## Guardrails

- Never reset, revert, delete, overwrite, or submit shared changes to simplify a task.
- Do not include another owner’s changes in a commit or external write.
- When overlap is unavoidable, identify the exact region and request coordination.

Good: preserve an unrelated dirty file and commit only scoped paths.
Bad: create a second “canonical” backlog because the real one is modified.
