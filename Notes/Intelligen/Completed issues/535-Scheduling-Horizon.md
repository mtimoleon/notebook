---
categories:
  - "[[Work]]"
created: 2026-02-24
product:
component:
status: completed
tags:
  - issues/intelligen
---
## Context
```
Examples/Tutorial 9/Create->Update Scheduling Horizon set start time now and save -> Select yes in modal ->  Unable to save changes because a circular dependency was detected in the data to be saved: 'ProcedureEntry { 'Id': 4377 } [Deleted] ForeignKeyConstraint { 'MainEquipmentCompatibilityProcedureEntryId': 4378 } <- ProcedureEntry { 'Id': 4378 } [Deleted] ForeignKeyConstraint { 'MainEquipmentCompatibilityProcedureEntryId': 4377 } <- ProcedureEntry { 'Id': 4377 } [Deleted]'.
```

## Notes

[[EF Delete Behavior]]

1. Need to remove the operation entries FK to the operation entries for database to be able to remove them.
2. ProcedureEntry needs removal of internal FK to main equipment procedure entry also.

## Links
