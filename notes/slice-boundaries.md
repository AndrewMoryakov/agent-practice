# A slice boundary is only real if the tree can stop there

Work gets cut into slices so each one can land, be verified, and be reverted
alone. That property is easy to assume and cheap to check, and assuming it is how
a three-slice plan becomes one commit that cannot be reviewed.

## What made a boundary illusory

A plan split a change into three: materialize a different input, change the shape
of the citation record, then build the mapping that interprets it. Two reviews,
run independently against the code, returned the same objection about the middle
slice — and it was stronger than "some tests will fail".

Changing the shape of a record that appears in a wire protocol **breaks
compilation of the whole test assembly**. Not "N tests go red": zero tests run.
And even once every call site is updated, the slice cannot be meaningfully green,
because the thing that gives the new shape meaning — the mapping — arrives in the
next slice. Verification has no subject.

The plan collapsed to two slices. The zero-skip rule the project holds survives
on two; it never could have survived on three.

## The check, before committing to a cut

For each proposed boundary, ask three questions in order. Any "no" merges the
slice with its neighbour.

1. **Does it compile?** Shared types, protocol records and public signatures
   propagate across the whole tree. A change to one is atomic whether you planned
   it that way or not.
2. **Is there something to assert?** A slice that introduces a form without its
   interpreter can be green only vacuously. Vacuous green is worse than red: it
   is a claim of verification.
3. **Can it be reverted alone?** If reverting it requires reverting its
   successor, they were one change.

## What can still go first

Something usually can, and it is worth finding, because it shrinks the
unavoidable commit. Here it was the citation grammar: a shared constant replacing
two independently written regular expressions that had silently diverged in what
they accepted. Self-contained, testable on its own, and it removed a hazard the
big slice would otherwise have had to carry.

**Look for the part that is a precondition rather than a component** — a
definition both sides need, a guard that is wrong today, a fix that stands
independent of the design being changed.
