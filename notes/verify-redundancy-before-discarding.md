# A copy that looks redundant can still have diverged

Two copies of the same project existed: a tracked clone, and a separate working
copy that had been the edit surface earlier. The working copy was plainly stale —
it lacked a feature the clone had just received, and everything in it had been
authored there and copied into the clone before being pushed. By provenance it was
a strict subset of the clone: nothing to keep, safe to delete.

Before deleting it, its files were compared, one by one, against the last state
that had actually been pushed. Twelve of thirteen matched byte for byte. One did
not. The difference turned out to be benign — an editor had rewritten that file's
encoding and the code was identical — but that was learned by looking. The
provenance argument, specific and confident and true for twelve files, was wrong
about the thirteenth.

Deleting on the strength of "I know where this came from" would have dropped
whatever the difference was, unseen. This time it was nothing. It does not have to be.

## The rule

Before discarding an artifact you believe is a redundant or superseded copy — a
stale working tree, a backup, a duplicate, an "old" export:

1. Compare its content against the authoritative version, not against your account
   of where it came from. Provenance reasoning is usually right, which is exactly
   why the one case it is wrong about slips through.
2. Treat any difference you did not predict as the finding, and explain it before
   proceeding. "The copy differs, and here is why" is a result; "the copy should be
   identical" is an assumption.
3. Separate "no difference" from "a difference I looked at and judged harmless".
   Only those two are grounds to discard without a second thought.

The comparison is cheap. The silent loss it prevents is not, and it lands exactly
on the item the reasoning was most sure about.

## Why it recurs

A confident provenance story feels like proof — "I authored every file here and
pushed it, so this is an older subset". It is usually accurate, and the accuracy
is the trap: skipping the check costs nothing almost every time, until the once it
hides a divergence that was worth seeing.
