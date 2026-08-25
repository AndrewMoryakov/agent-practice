# Green tests that stopped proving anything

Missing coverage is visible: nobody wrote the test. A test that has stopped
proving its claim is invisible, because it reports the same colour as one that
still works — and it reports it while you read the summary line and move on.

Three shapes turned up in a single session's work on one codebase. They have
different causes and one detection habit.

## 1. The test pins a claim that became false

A CLI printed `Initialized schema: v7` while the code's latest schema version was
8. An integration test asserted that exact string. So the suite was green, and
what it was green about was a false statement to the user.

Note the trap for whoever finds it: fixing the banner alone turns the suite red,
and fixing the assertion alone keeps the lie. Neither half is a defensible commit.
**A user-visible claim and the test that pins it are one edit.**

Generalizes to anything a test asserts verbatim: version banners, error text,
generated headers, API strings.

## 2. The test's subject moved out from under it

`Materialization_rejects_a_same_length_corrupted_raw_blob` corrupted a raw blob
and required the operation to refuse. Then the operation changed to read
normalized documents from a different store. The raw blob it corrupts is no
longer read by anything, so nothing is detected, and the test passes.

It did fail here — but only because the same change also broke an assertion about
file names. Had the change been narrower, it would have gone on passing while
guarding nothing.

**When you change what a component reads or writes, the fixtures that target the
old artifact are suspects, not bystanders.**

## 3. The test's name claims more than its body

`The_materialization_hash_distinguishes_different_normalized_documents` asserted
that a column was populated. Nothing in it distinguished anything. The name was
load-bearing: it is what a reader greps for when asking whether that property is
covered.

**A test name is an assertion in the same sense the body is.** Either make the
body match the name, or rename the test to what it checks — and then write the
one the name promised, if the property matters.

## The detection habit

When you change what a component reads, writes, or claims:

1. grep the test tree for the **old artifact** and the **old literal string**;
2. for each hit, ask what would now fail if the guarantee were deleted;
3. where the answer is "nothing", retarget the test or delete it — a retargeted
   test needs its comment rewritten too, because the comment explains a hazard
   that also moved;
4. for anything you claim is now fixed, disable the fix and watch the test fail
   before believing it.

Step 4 is the general case of the other three: the question is never "is it
green", it is "what would make it red".

## The adjacent case

`skills/verify-the-check-can-fail` covers the same hazard one level up: a
diagnostic or guard whose green result gates a decision, and which can exit
success without inspecting anything. This note is about tests that once proved
something and stopped; that skill is about checks that never could. Both are
answered by the same question — what would make this red?

