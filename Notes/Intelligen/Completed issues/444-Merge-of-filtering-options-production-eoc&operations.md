---
categories:
  - "[[Work]]"
  - "[[Issues]]"
created: 2025-09-25T11:46
tags:
  - intelligen
status: completed
product: ScpCloud
---

"TaskStart"
"TaskEnd" 
"OperationEntryType" 
"Task"
"CampaignName"
"BatchName"
"CampaignId"
"BatchId"
"ProcedureName"
"OperationName"u
"Status"
"AttentionDate"

```
public static BsonDocument BuildOperationEntryFilterMatchStage(FilterOrderDto filterOrderDto)
{
FilterDto filterDto = filterOrderDto.Filter;
if (filterDto.Rules.Count == 0)
{
	return new BsonDocument("$match", new BsonDocument());
}

List conditions = [];
string rootOperator = GetRootOperator(filterDto.RootOperator);

foreach (FilterRule rule in filterDto.Rules)
{
BsonDocument condition = rule.Column switch
{
	// Missing from operation entries
		"TaskEnd"
		"OperationEntryType"
		"Task"

		"CampaignName" =\> BuildStringFilter("CampaignName", rule),
		"BatchName" =\> BuildStringFilter("Name", rule),
		"CampaignId" =\> BuildArrayFilter("CampaignId", rule),
		"BatchId" =\> BuildArrayFilter("Id", rule),
		"ProcedureName" =\> BuildStringFilter("BatchContentsTracking.ProcedureEntries.Name", rule),
		"OperationName" =\> BuildStringFilter("BatchContentsTracking.ProcedureEntries.OperationEntries.Name", rule),
		"Status" =\> BuildTimingStatusFilter("BatchContentsTracking.ProcedureEntries.OperationEntries.TimingStatusId", rule),
		"AttentionDate" =\> BuildDateFilter(rule, "BatchContentsTracking.ProcedureEntries.OperationEntries.AttentionDate"),

		//Change this to TaskStart
		"TaskStart" \<----  "Start" =\> BuildDateFilter(rule, "BatchContentsTracking.ProcedureEntries.OperationEntries.Start"),

		// These are in resource selection as in eoc and should be used from there
		// they will not exist in columns anymore
		"AuxEquipment" =\> BuildNestedArrayFilter("BatchContentsTracking.ProcedureEntries.OperationEntries.AuxEquipment", rule),
		"Staff" =\> BuildNestedArrayFilter("BatchContentsTracking.ProcedureEntries.OperationEntries.Staff", rule),
					_ =\> null
	};
```
      

<font color="#ff0000">Task overlap should be gt,lt or gte,lte in comparisons?  </font>
<font color="#ff0000">Should be gt,lt according to D</font>
 
`Implemented`
 
```
ShowEquipmentΒ =Β true,
ShowEquipmentModeΒ =Β 1,
ShowStaffΒ =Β false
------------------------------------
ShowEquipmentΒ =Β true,
ShowEquipmentModeΒ =Β 2,
SelectedEquipmentΒ =
[
new()Β {Β IdΒ =Β 10Β },
new()Β {Β IdΒ =Β 11Β }
],
ShowStaffΒ =Β false
------------------------------------
ShowEquipmentΒ =Β true,
ShowEquipmentModeΒ =Β 1,
ShowStaffΒ =Β true,
ShowStaffModeΒ =Β 1
```
 ------------------------------------------------  

```
ShowEquipmentΒ =Β false,
ShowStaffΒ =Β true,
ShowStaffModeΒ =Β 1
------------------------------------
ShowEquipmentΒ =Β false,
ShowStaffΒ =Β true,
ShowStaffModeΒ =Β 2,
SelectedStaffΒ =
[
new()Β {Β IdΒ =Β 101Β }
]
```
 -----------------------------------------------  

```
ShowEquipmentΒ =Β true,
ShowEquipmentModeΒ =Β 2,
SelectedEquipmentΒ =
[
new()Β {Β IdΒ =Β 11Β }
],
ShowStaffΒ =Β true,
ShowStaffModeΒ =Β 2,
SelectedStaffΒ =
[
new()Β {Β IdΒ =Β 101Β }
]
```
   

```
What we should implement

ShowEquipmentΒ =Β true,
ShowEquipmentModeΒ =Β 1,
ShowStaffΒ =Β false

ShowEquipmentΒ =Β true,
ShowEquipmentModeΒ =Β 2,
ShowStaffΒ =Β false

ShowEquipmentΒ =Β false,
ShowStaffΒ =Β true,
ShowStaffModeΒ =Β 1

ShowEquipmentΒ =Β false,
ShowStaffΒ =Β true,
ShowStaffModeΒ =Β 2
```







