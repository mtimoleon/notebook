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

# Deleting a Project Hides It Instead of Removing It

## Current Rule
Deleting a project sets `IsSoftDeleted = true` through `UpdateSoftDeleted(true)` and returns success without physically removing the project row.

## Introduced By
- [[PR-feature-AC-19_Add_hide_or_delete_project Hide or Delete Project]]

## Modified By
- [[PR-feature-AC-19_Add_hide_or_delete_project Hide or Delete Project]]

## Evidence
- `Enoll/Model/Entities/Project.cs`
- `Enoll/Services/ProjectsService.cs::DeleteProjectAsync`
- `Enoll/Model/APIContext.cs`

## Edge Cases
- A second delete attempt behaves like not-found in normal flows because the default project query filter hides the row.
- Related bids, visits, invoices, and uploads remain persisted even though default reads stop returning them.
