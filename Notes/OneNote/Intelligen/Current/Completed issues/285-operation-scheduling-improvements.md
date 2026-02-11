- [x] Μεταφορά FixedTimeShiftUnitId & FixedTimeShiftValue 
		από OperationTimeShiftUpdateDto σε OperationSchedulingUpdateDto
		& NonProcessingOperationSchedulingUpdateDto. Οι αλλαγές θα φτάσουν ως το domain.
 
- [x] Rename UpdateOperationTimeShift σε UpdateOperationFlexibleShiftsAndBreaks (route, dto, action, controller , domain κλπ.)
 
- [x] Get OperationAdditionalSchedulingLinks  
		operation/{id}/additional-scheduling-link  
		LinkProcedureId  
		LinkProcedureName  
		LinkOperationId  
		LinkOperationName  
		LinkRelation  
		TimeShiftUinitId  
		TimeShiftUnitValue  
- [x] POST OperationAdditionalSchedulingLink (Create)  
		operation/{id}/add-additional-scheduling-link  
		LinkOperationId  
		LinkRelationId  
		TimeShiftUinitId  
		TimeShiftUinitValue  
- [x] DELETE OperationAdditionalSchedulingLink  
		operation/{id}/additional-scheduling-link  
		OperationId  
- [x] POST UpdateOperationAdditionalSchedulingLinkTimeShift για (inplace edit)  
		operation/{id}/update-additional-scheduling-link-timeshift  
		OperationId  
		LinkOperationId  
		TimeShiftUinitId  
		TimeShiftUnitValue  
- [x] POST UpdateOperationAdditionalSchedulingLinkOperation (inplace edit)  
		operation/{id}/update-additional-scheduling-link-operation  
		OperationId  
		LinkOperationId  
		NewLinkOperationId  
		LinkRelationId
 
- [ ] Renames  
	- [x] SchedulingReferenceOperation -\> SchedulingLinkOperation  
			ChartsDto  
			OperationDto  
			OperationSchedulingUpdateDto  
			OperationTableDto
	 
	- [x] SchedulingLinkRelation -\> SchedulingLinkRelationship  
			OperationPanelDto  
			OperationDto  
			OperationSchedulingUpdateDto  
			OperationTableDto
	 
	- [x] AdditionalSchedulingReferences -\> AdditionalSchedulingLinks  
			OperationSchedulingReference -\> OperationSchedulingLink  
			OperationSchedulingReferenceCreateDto
	 
	- [x] Changes should take place in OperationEntry  
			ChartDto
	 
	- [x] Operation  
			FixedTimeShift -\> SchedulingLinkTimeShift  
	- [x] NonprocessingOperation  
			FixedTimeShift  
	- [ ] Check for changes needed in Intelligen gantt app
	 
	- [x] In delete additional scheduling links add concurrency token