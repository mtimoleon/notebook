---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-04-27
updated: 2026-04-27
product: RAISE
component: Access
tags:
  - documentation/raise
  - topic/business-logic
---

# Access Request Idempotency

## Current Rule
If the same user re-initiates access to the same resource and an applicable access-request row already exists, the system should reuse that row rather than create a duplicate.

## Introduced By
- [[PR-214 Usage-Based Access Request Persistence]]

## Evidence
- `CreateOrAttachDatasetAccessRequestAsync`
- `CreateOrAttachScriptAccessRequestAsync`
- `InitiateDatasetAccessAsync`
- `InitiateScriptAccessAsync`

## Edge Cases
- Repeated initiation after auto-approval should return the existing approved row.
- Re-initiation after hard-delete cancellation creates a fresh row.
