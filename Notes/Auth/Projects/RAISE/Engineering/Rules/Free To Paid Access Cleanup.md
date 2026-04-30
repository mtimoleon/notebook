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

# Free To Paid Access Cleanup

## Current Rule
When a resource moves from a free latest price definition to a paid model, stale free grants and related free-path access artifacts must be removed or unbound so paid access cannot be granted for free.

## Introduced By
- [[PR-209 Credit System Foundations]]

## Evidence
- `Documentation/Credits.md`
- `RemoveDatasetFreeAccessArtifactsAsync`
- `RemoveScriptFreeAccessArtifactsAsync`

## Edge Cases
- Free to `PermanentAccess` or `Lease` deletes pending free-path requests.
- Free to `UsageBased` keeps the request path but removes stale free-grant bindings.
