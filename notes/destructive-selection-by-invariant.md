# Select destructive targets by the invariant, not a correlate

A cleanup script existed to remove hung tunnel processes. It picked its targets by
matching a port number in the command line. That looked reasonable: the hung ones
did carry that port. But a *healthy* tunnel carried the same port, and a genuinely
hung one carried a different port. Run as written, the script would have killed the
working process and spared the dead one — the exact inverse of its purpose. A dry
run made it plain: one live process holding the port, marked for death; one dead
process, invisible to the filter.

The port number was a **correlate** of "hung", not what defines it. What actually
defines a hung tunnel is that it holds no live resource — it forwards a port but
does not own a listener on it. Selecting by that invariant sorts the two apart
immediately; selecting by the correlate confuses them.

A second script in the same family had a related flaw: it enumerated processes to
terminate without excluding its own. Run interactively, it could kill the shell it
was running in and never reach its final step.

## The rule

For any destructive batch action — kill, delete, reset — chosen by a filter:

1. **State the property that defines a bad target**, then check it is the defining
   invariant and not a correlate a healthy item can also match. A name, a port, an
   age, a label are correlates. "Holds no live resource", "has no referrer",
   "past its lease" are invariants.
2. **Select by the invariant.** Verify the selection against one known-good and one
   known-bad item before trusting it. A correlate-based filter spares some real
   targets and hits some healthy ones; a dry run shows which.
3. **Exclude the actor's own context** — the current process and its ancestry — so
   the action cannot end the thing performing it before it finishes.
4. **Exclude critical siblings** that share the correlate but must survive: a
   working peer on the same port, a supervised process, a resource still in use.
5. **Read the actual target list on a dry run** and gate the destructive step on
   that reviewed list, not on the filter alone.

## Why it recurs

The correlate is usually easier to match than the invariant — a port number is one
regex, "owns a live listener on that port" takes a lookup. Under time pressure the
easy filter ships, and it is right often enough to pass a casual test, because the
correlate and the invariant coincide for most items most of the time. They diverge
exactly on the cases the destructive action exists to handle.
