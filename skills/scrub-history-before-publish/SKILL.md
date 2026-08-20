---
name: scrub-history-before-publish
description: Remove secrets and internal identifiers from a repository's whole
  history, not just its working tree, before an irreversible publish or push to a
  wider audience. Use before making a repo public, pushing to a shared remote, or
  sharing an artifact built from tracked content.
---

# Scrub History Before Publish

Publishing exposes every commit, not the current tip. Clean the history, then publish.

## Procedure

1. Before any irreversible publish, scan the full history - every commit and blob,
   not the working tree - for secrets and internal identifiers (tokens, keys,
   private hosts, addresses, personal data). Search patterns, not only known strings.
2. Treat a finding in an already-committed version as still exposed: editing the
   current file does not remove it from history. Rewrite the affected commits
   (amend for the tip, a history filter for older ones), then verify the pattern
   is absent from every commit.
3. Remove the backup refs a history rewrite leaves behind and expire the reflog,
   so the old commits are not still reachable in the published repository.
4. Generalize identifiers to placeholders at authoring time, before the first
   commit, so the scan is a backstop and not the primary control.
5. Run the scan as the last gate before the publish command, and again against the
   published result, since the publish path may differ from local.

## Record

`scope scanned | pattern | commits hit | rewrite method | post-publish re-scan`

Good: a full-history scan finds an internal address in an example file, and the
commit is rewritten before the public push.
Bad: the current file is fixed, the tip looks clean, and the address still sits
one commit back in public history.
