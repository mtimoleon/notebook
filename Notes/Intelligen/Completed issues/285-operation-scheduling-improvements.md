---
categories:
 - "[[Work]]"
 - "[[Issues]]"
created: 2025-02-03T09:36
tags:
  - intelligen
status: completed
product: ScpCloud
---

- [x] ΞΒΞΒµΞβ€ΞΒ±Ξβ€ ΞΞΞΒΞΒ¬ FixedTimeShiftUnitId & FixedTimeShiftValue ΞΒ±Ξβ‚¬ΞΒ OperationTimeShiftUpdateDto ΞΖ’ΞΒµ OperationSchedulingUpdateDto & NonProcessingOperationSchedulingUpdateDto. ΞΒΞΞ‰ ΞΒ±ΞΒ»ΞΒ»ΞΒ±ΞΒ³ΞΒ­Ξβ€ ΞΞΞΒ± Ξβ€ Ξβ€ΞΒ¬ΞΖ’ΞΞΞβ€¦ΞΒ½ Ξβ€°Ξβ€ Ξβ€ΞΞ domain. 
- [x] Rename UpdateOperationTimeShift ΞΖ’ΞΒµ UpdateOperationFlexibleShiftsAndBreaks (route, dto, action, controller , domain ΞΞΞΒ»Ξβ‚¬.) 
- [x] Get OperationAdditionalSchedulingLinks operation/{id}/additional-scheduling-link LinkProcedureId LinkProcedureName LinkOperationId LinkOperationName LinkRelation TimeShiftUinitId TimeShiftUnitValue 
- [x] POST OperationAdditionalSchedulingLink (Create) operation/{id}/add-additional-scheduling-link LinkOperationId LinkRelationId TimeShiftUinitId TimeShiftUinitValue 
- [x] DELETE OperationAdditionalSchedulingLink operation/{id}/additional-scheduling-link OperationId 
- [x] POST UpdateOperationAdditionalSchedulingLinkTimeShift ΞΒ³ΞΞ‰ΞΒ± (inplace edit) operation/{id}/update-additional-scheduling-link-timeshift OperationId LinkOperationId TimeShiftUinitId TimeShiftUnitValue 
- [x] POST UpdateOperationAdditionalSchedulingLinkOperation (inplace edit) operation/{id}/update-additional-scheduling-link-operation OperationId LinkOperationId NewLinkOperationId LinkRelationId
- [ ] Renames
- [x] SchedulingReferenceOperation -\> SchedulingLinkOperation ChartsDto OperationDto OperationSchedulingUpdateDto OperationTableDto
- [x] SchedulingLinkRelation -\> SchedulingLinkRelationship OperationPanelDto OperationDto OperationSchedulingUpdateDto OperationTableDto
- [x] AdditionalSchedulingReferences -\> AdditionalSchedulingLinks OperationSchedulingReference -\> OperationSchedulingLink OperationSchedulingReferenceCreateDto
- [x] Changes should take place in OperationEntry ChartDto
- [x] Operation FixedTimeShift -\> SchedulingLinkTimeShift
- [x] NonprocessingOperation FixedTimeShift - [ ] Check for changes needed in Intelligen gantt app
- [x] In delete additional scheduling links add concurrency token







