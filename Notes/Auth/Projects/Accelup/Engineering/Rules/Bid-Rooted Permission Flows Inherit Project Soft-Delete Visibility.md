---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-06-11
updated: 2026-06-11
product: Accelup
component: Projects
tags:
  - documentation/accelup
  - topic/business-logic
---

# Bid-Rooted Permission Flows Inherit Project Soft-Delete Visibility

## Current Rule
Permission checks that start from `_context.Bids` inherit project soft-delete visibility because `Bid` rows are filtered out when their project is soft deleted.

## Introduced By
- [[PR-feature-AC-19_Add_hide_or_delete_project Hide or Delete Project]]

## Modified By
- [[PR-feature-AC-19_Add_hide_or_delete_project Hide or Delete Project]]

## Evidence
- `Enoll/Model/APIContext.cs`
- `Enoll/Services/MessageService.cs::SendMessageAsync`
- `Enoll/Services/ReviewService.cs::AddReviewAsync`

## Edge Cases
- Reads that intentionally bypass EF query filters can still surface deleted-project relationships.
- New bid-rooted workflows need the same default-filter assumption validated in tests.
