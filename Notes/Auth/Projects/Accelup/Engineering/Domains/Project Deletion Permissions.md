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
  - topic/domain
---

# Project Deletion Permissions

## Overview
Project deletion is available to the project owner and to admins, and that permission is aligned across the controller and service layers.

## Current Behavior
- The delete endpoint is reachable by authenticated product roles.
- `DeleteProjectAsync` permits the operation when `project.IsProjectOwner(user)` or `user.IsAdmin()` is true.
- The same owner-or-admin rule also appears in related project modification flows such as uploads and project edits.

## Business Meaning
Owners can self-manage project removal, while admins retain an explicit moderation and recovery-control path.

## Rules
- [[Project Delete Is Allowed for Owner or Admin]]

## Risks
- [[No Visible Restore or Undelete Flow for Soft-Deleted Projects]]

## Related PRs
- [[PR-feature-AC-19_Add_hide_or_delete_project Hide or Delete Project]]
