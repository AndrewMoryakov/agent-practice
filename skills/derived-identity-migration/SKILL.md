---
name: derived-identity-migration
description: Handle a schema or format change that alters what a stored derived identifier identifies. Use before writing a migration that touches any field feeding a hash, primary key, or content address, and when an upgrade "succeeds" but later operations fail claiming corruption.
---

# Migrating What An Identifier Identifies

Data can be migrated. Identity cannot always be, and the failure is silent.

## The mechanism

A stored identifier derived from a set of fields — a content hash, a hash-derived
primary key, a manifest digest — is a claim about those fields. Change what the
fields mean and the identifier is stale, not wrong: it still parses, still joins,
still looks healthy.

Restating it is usually impossible rather than merely awkward, because everything
else references it. So the migration silently splits: the rows upgrade, and the
first operation that recomputes the identifier fails.

That failure lands with a message about mismatched or corrupt identity, which is
**true about the comparison and wrong about the cause**. Whoever reads it goes
looking for data corruption that never happened.

## Procedure

0. **Audit before any schema statement.** Recompute every existing identifier
   from the fields still stored and compare with what is recorded. A gap here is
   a finding, not a stop: it tells you whether the old identity is reproducible
   at all, which decides whether a compatible redefinition is even available.
1. **Enumerate the derived identifiers** that consume any field the change
   touches. Search for the hash inputs, not the hash names — a domain string, a
   list of columns fed into a digest, a manifest serializer. Note that the input
   is usually a *rendering* rather than a value: `100.5` and `100.50` hash
   differently, so the format is part of the identity and has to be established
   by measurement rather than assumed.
2. For each, ask two questions in order:
   - does this change alter the value it would now compute?
   - can the migration restate the stored value?
   It cannot when the value feeds a primary key, or is referenced by other
   tables, or was published outside the system.
3. **Where it cannot be restated, the upgrade must refuse** — before applying,
   in the same transaction, for the affected rows. Refusing is not a lesser
   outcome than migrating; it is the only outcome that does not lie.
4. **Write the refusal to be actionable**: how many rows, one concrete example,
   what to do instead, and why doing that is cheap. "Delete and recreate them
   from the same inputs" is a remedy; "cannot upgrade" is not.
5. **Refuse ambiguity too.** A backfill written as a scalar subquery yields null
   for none and an arbitrary row for several. A value chosen arbitrarily
   determines nothing, which defeats the point of adding the column.
6. **Test the refusal**, asserting that version history does not advance and the
   new structure does not appear. A refused upgrade must leave the store exactly
   as it was.

## Two hazards that are not the migration

**The lookup path changes meaning silently.** If intake deduplicates by
computing the identifier, a scheme change gives the same logical item a new
identifier and creates a second copy — no error anywhere. Put the uniqueness
where it belongs, on the natural key, rather than relying on the identifier to
carry it.

**A superseded field becomes a frozen input.** The old column stops being the
operational value and starts being the only evidence of what the stored
identifier means. Keep it, in its original rendering, and say in the schema why
it may not be dropped.

## Safety boundary

Refusal is cheap only while nothing depends on the stored identities — before
first release, or where the artifact is reconstructible from inputs the system
still holds. Say which of those applies, in the message itself. Where neither
holds, this is a data-migration design problem and needs a versioned identity
scheme, not a refusal.

## Origin

A schema step added a per-member selector so a frozen snapshot would determine
exactly which derived document a build reads. The pre-migration check validated
that half and was silent about the other: the stored materialization manifest
hash had been computed under an older domain string and was not recomputed,
because it feeds the snapshot hash and therefore the snapshot's primary key.
A snapshot with an unambiguous answer upgraded cleanly, looked healthy, and then
failed materialization with "manifest no longer matches canonical identity".
The repair was to refuse the upgrade while any snapshot existed at all.

**Confidence:** one system, one migration pair; the mechanism is generic to
content-addressed and hash-derived identity.
