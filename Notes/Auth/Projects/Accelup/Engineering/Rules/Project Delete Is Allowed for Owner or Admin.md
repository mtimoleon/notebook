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

# Project Delete Is Allowed for Owner or Admin

## Current Rule
A project can be deleted by its owner or by an admin.

## Introduced By
- [[PR-feature-AC-19_Add_hide_or_delete_project Hide or Delete Project]]

## Modified By
- [[PR-feature-AC-19_Add_hide_or_delete_project Hide or Delete Project]]

## Evidence
- `Enoll/Controllers/ProjectsController.cs`
- `Enoll/Services/ProjectsService.cs::DeleteProjectAsync`
- `Enoll/Model/Entities/Project.cs::IsProjectOwner`
- `Enoll/Model/Entities/User.cs::IsAdmin`

## Edge Cases
- Authenticated non-owner, non-admin callers can reach the route but are rejected by the service.
- The same owner-or-admin pattern is reused in related project edit and upload operations.
