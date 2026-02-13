---
categories:
  - "[[Work]]"
  - "[[Issues]]"
created: 2025-06-18T10:44
tags:
  - intelligen
status: completed
product: ScpCloud
---


395-BE: Eoc filters in production
• (string) CampaignName, BatchName 
	Operators = ["is", "isNot", "contains", "doesNotContain", "startsWith",  "endsWith",  "isEmpty", "isNotEmpty"]
	CampaignName: filter batches collection
		Path = Batch.CampaignName
	BatchName: filter batches collection
		Path = Batch.BatchName
		
	This can be solved with the filter extension on queryable
		
• (datetime) TaskStart, TaskEnd  
	Operators = ["is", "isNot", "inTheNext", "inTheLast", "isBetween", "isOnOrAfter", "isAfter", "isOnOrBefore", 
			    "isBefore",  "isEmpty", "isNotEmpty"]
	TaskStart,TaskEnd:
		○ Fisrt Approach
		Step-1: filter batches collection - linq
				Path = Batch.BatchContentsTracking.Start | End
		Step-2: filter in memory oprations | procedures whether where the task belong
				Path = Batch.EocResourceDataTracking.Equipment.OpEntryTasks.StartDate | EndDate
				Path = Batch.EocResourceDataTracking.Equipment.ProcEntryTasks.StartDate | EndDate
		○ Alternative
		Create aggregation using the above paths with match conditions
		
• (list string) Equipment, Staff, OperationEntryTypes, 
	Operators= [isIn, isNotIn]  (takes many names of the object)
	Equipment: break rule to filter on equipment name 
		Path = Batch.EocResourceDataTracking.Equipment .EquipmentName
	Staff: break rule to filter on staff name 
		Path = Batch.EocResourceDataTracking.Staff.StaffName
	OperationEntryType:  break the rule to filter on many operation entry tasks
		Path = Batch.EocResourceDataTracking.Equipment.OperationEntryTasks.OperationType
		Path = Batch.EocResourceDataTracking.Equipment.ProcEntryTasks.OpEntryTasks.OperationType
		
• (object) Task 
	
![[Attachments/Notes/Intelligen/Completed issues/408-Eoc-filters-in-production/image 1.png]]




	 
From FE I get rules where the rule has the following format:

```

{
        column: "some-name",
        operator: "<operator relative to the type of column>" 
        values: [<some-values>]
}
```


In the filters extension I should have a dictionary  with kvp matching the column names with the actual path in dto like:

```
{ 
        "TaskStart", 
        [
                "Batch.EocResourceDataTracking.Equipment.OpEntryTasks.StartDate", 
                "Batch.EocResourceDataTracking.Equipment.ProcEntryTasks.OpEntryTasks.StartDate"
        ]
}
```

#### Dedicated code for TaskStart and TaskEnd

```
var filteredBatches = collection.AsQueryable()
    .Select(batch => new BatchType
    {
        Id = batch.Id,
        // . . .
        // copy the rest of batch fields


        // Filter Equipment
        EocResourceDataTracking = new EocResourceDataTrackingType
        {
            Equipment = batch.EocResourceDataTracking.Equipment
                .Where(eq =>
                    eq.OpEntryTasks.Any(task => task.StartDate >= fromDate && task.EndDate <= toDate)
                    ||
                    eq.ProcEntryTasks.Any(procTask => task.StartDate >= fromDate && task.EndDate <= toDate)
                    )
                ) 
               
               // Instead the above use expression
                  .Where(equipmentFilter)


                .Select(eq => new EquipmentType
                {
                    // Copy the rest of equipment fileds
                    Id = eq.Id,
                    
                    // Filter OpEntryTasks
                    OpEntryTasks = eq.OpEntryTasks
                        .Where(task => task.StartDate >= fromDate && task.EndDate <= toDate)
                        .ToList(),
                    
                    // Filter ProcEntryTasks
                    ProcEntryTasks = eq.ProcEntryTasks
                        .Where(task => task.StartDate >= fromDate && task.EndDate <= toDate)
                        .ToList()
                })
                .ToList()
        }
        // if batch has other properties, copy them here
    })

    // Filter batches that have at least one equipment that fulfill the criteria
    .Where(batch => batch.EocResourceDataTracking.Equipment.Any()) 

    .ToList();


Expression<Func<EquipmentType, bool>> equipmentFilter = eq =>
    eq.OpEntryTasks.Any(task => task.StartDate >= fromDate && task.EndDate <= toDate)
    ||
    eq.ProcEntryTasks.Any(task => task.StartDate >= fromDate && task.EndDate <= toDate)
    );

```


GetEocResoureData

Example of linq and mongo filter used together

```
var filter = Builders<Places>
                .Filter
                .Near(x => x.Point, point, 1000);

return Database
    .GetCollection<Places>("Places")
    .AsQueryable()
    .Where(x => x.StartDate.Date <= date)
    .Where(x => x.EndDate.Date >= date)
    .Where(x => keys.Contains(selectedKeys))
    .Where(x => filter.Inject())
    .ToList();

```


Start: 2021-12-31T22:00:00.000+00:00
End: 2022-01-01T07:20:00.000+00:00


- [ ] If there is equipment "in" then give only that equipment and filter the tasks in projection
- [ ] If there is not any equipment "in" then give all the equipment that have tasks fullfiling the rule

Για να μην μπερδευτούμε γράφω τι συμφωνήσαμε οι 3 μας προχτες:
• Αν δεν υπαρχουν equip/staff φιλτρα τότε στο EOC δείχνουμε μόνο τα equip/staff που εχουν tasks. Όσα δεν έχουν δεν τα δείχνουμε καθολου
• Αν υπάρχουν equip/staff φίλτρα τότε στο EOC δείχνουμε μονο τα equip/staff που υπαρχουν στα φιλτρα ασχέτως αν εχουν ή όχι tasks

1. string isEmpty/isNotEmpty we check for null also, is this right?


![[Attachments/Notes/Intelligen/Completed issues/408-Eoc-filters-in-production/image 1.png]]







