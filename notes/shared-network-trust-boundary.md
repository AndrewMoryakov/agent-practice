# A shared network's gateway trusts every member

To put a private admin surface behind a reverse proxy, a service was published on
the gateway address of the network the proxy lived on. It worked, and it looked
local: the port answered only on that internal address, not the public one.

The network had about seventeen other members, some of them internet-facing apps.
Their traffic to the gateway was translated by the runtime into a single source
address — the very address the service had been told to trust as "the proxy". So
every neighbour reached the unauthenticated surface without the password, by doing
nothing more than a plain request to the gateway. A check run from an unrelated
neighbour returned the protected content.

The mistake was reading "reachable via the gateway" as "local". A shared bridge,
subnet, or gateway is not local. It is every host attached to it.

## The shape that works

Before exposing a service to a proxy or a peer, answer two questions and test the
third:

1. **What trust does reaching the service grant?** An injected credential, an
   unauthenticated admin page, a "trusted proxy" address that skips auth — name it,
   because that is what every reachable host now holds.
2. **Who is actually on this network?** Enumerate the members, not the one you had
   in mind. A "trusted" address that is a subnet or a shared gateway trusts the
   whole subnet, and address translation can map any neighbour into it.
3. **Can an unintended member reach it?** Test the negative from a host that should
   *not* have access, not only that the intended one can. The negative is the check
   that would have caught this.

The fix is scope, not a stronger password: a dedicated network containing exactly
the intended peers, and a trusted address that is one peer rather than a range.
After the change, the same request from a neighbour returns nothing.

## Why it recurs

Every layer offers a "local-ish" address that is not local: a container bridge
gateway, a host-only network, a VPC subnet, an `X-Forwarded-For` a proxy will
happily set. Each reads like a boundary and is actually a membership list. The
question is never "is this address internal" but "who else is inside it".
