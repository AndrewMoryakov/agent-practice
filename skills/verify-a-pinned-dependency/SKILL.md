---
name: verify-a-pinned-dependency
description: Treat a version pin — a commit, tag, digest or release — as a claim about an artifact rather than a record of one, and verify it by running the capability it was pinned for. Use before depending on a pinned external artifact, when adopting a pin someone else recorded, and when a pinned dependency is about to enter a critical path.
---

# Verify A Pinned Dependency

A pin says "this version delivers X". Nobody checked.

## Why this is not obvious

Pinning feels clerical — copy a hash, write it down, move on. The plan says
*packaging, not design*, and that framing is what lets an unverified claim through
wearing the clothes of a decision already made.

Two things then make it worse.

**A good commit message raises confidence without supplying evidence.** A commit
can explain precisely why its design is right, name the properties it enforces,
and be worth reading twice — and still not run. Prose quality and executability
are independent. The better the writing, the more likely you verify the
*properties* it describes and never ask whether the thing can be reached at all.

**Pins go stale toward more capability, not only less.** The branch a pin was cut
from keeps moving, and the commits after it are often the ones that solve the
problem you are about to hit.

## Procedure

0. **Compare the promise against your acceptance criterion, on paper, first.**
   They are two texts written by different people for different purposes, and they
   often describe different behaviours. "Duplicate requests are rejected" and "a
   repeat returns the same response id" are not the same feature; if the artifact
   only does the first, no configuration of it passes your test. This costs
   minutes and can end the integration before it starts.
1. **Resolve the pin to an immutable identity.** A tag is a label, not a version:
   it can be moved, and a package published under it can be built from a later
   state of the branch. Record the commit hash and check that the artifact you
   installed came from it - otherwise you verify one thing and depend on another.
2. **Pin and exercise in one step.** The pin is not delivered until the capability
   it was pinned for has run once, on that exact version, in your environment.
   Recording the hash and running it are not two tasks.
3. **Check that a wrong value is refused.** Configure something deliberately
   invalid and confirm it fails loudly. If the artifact silently falls back to a
   default, then your correct setting could equally have applied to nothing, and
   every green result below this line proves nothing about it.
4. **Check reachability before properties.** Can the thing be selected, loaded,
   invoked at all? A feature list, an enum, a factory and a preflight guard are
   four different registries, and a capability added to three of them is
   unreachable. Verifying the elegant internals of something you cannot call is
   the trap.
5. **Run the acceptance test with the capability turned off**, and require it to
   fail. A dedupe that also comes from a unique index, a retry in the client, or
   the test harness itself will show green either way. See `claim-discipline`.
6. **Read the commits after the pin.** Not for a version bump — for work that
   changes what you are about to attempt. Ask specifically: does anything here
   affect the property my acceptance test asserts?
7. **Prefer the earliest failure.** An artifact that refuses at selection time
   costs minutes. The same artifact failing later, deep in your integration, sends
   you looking in your own code for a defect that is not there.
8. **Record what you ran**, not what you read. "Pinned at `<hash>`; recording pass
   executed on it" is a different claim from "pinned at `<hash>`" and only one of
   them is evidence.

## Safety boundary

Fixing the dependency is a separate decision from verifying it. A patch to
someone else's artifact moves the pin, and moving a pin is a change to what your
build is made of — surface it rather than absorbing it into the verification
step. Verify in a working copy first; the evidence is what makes the case for the
fix.

## Origin

A plan pinned a compiler fork by exact commit, with the note that this was "a
packaging question, not a design one". The commit's message was exemplary: it
explained why exchanges are keyed by request hash rather than call order, and why
a replay miss must fail rather than fall back to a live call. Both properties were
real and present in the code.

The provider still could not be selected. It had been added to the supported-names
list and to the factory, and not to the table a preflight guard reads to decide
whether a name is known — so the error was self-contradicting: *unknown provider
"record"*, followed by a supported list containing `record`.

Two commits further along the same branch, untouched by the pin, froze output
timestamps and derived an identifier from content instead of randomness. The
acceptance test for the whole integration was byte-identical output across two
passes. On the pinned commit that test could not have passed for reasons that had
nothing to do with the integration being written — and the early refusal, which
looked like an obstacle, prevented an hour of looking for the defect in the wrong
codebase.

**Confidence:** one integration, one dependency; the mechanism is generic to any
pinned external artifact.
