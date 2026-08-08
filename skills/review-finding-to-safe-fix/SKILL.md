---
name: review-finding-to-safe-fix
description: Turn a verified review or field finding into the smallest authorized change that protects the affected invariant. Use after the failing mechanism is established and the user has asked to implement a fix.
---

# Turn Review Finding Into Safe Fix

Fix the decision point that allowed the bad outcome.

## Procedure

1. Restate input, observed result, expected invariant, and user-visible consequence.
   Verify them against the current subject or build.
2. Identify the boundary where the invariant must be enforced or made visible.
3. Choose the response by consequence:
   - refuse or roll back when safety, authorization, atomicity, or data integrity
     would be violated;
   - return explicit incomplete/partial status when the operation is legitimate
     but unfinished;
   - warn or instrument when the condition is diagnostic only.
4. Add a durable guard at the same boundary: test, assertion, validation,
   monitor, or policy check appropriate to the system.
5. Update the public contract and dependent instructions. Preserve unrelated
   valid flows.

Good: callers can no longer mistake an incomplete result for completion.
Bad: add documentation while the machine continues to report false success.
