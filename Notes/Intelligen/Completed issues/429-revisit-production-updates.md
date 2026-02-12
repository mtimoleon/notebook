---
categories:
  - "[[Work]]"
  - "[[Issues]]"
created: 2025-09-08T10:44
tags:
  - intelligen
status: completed
product: ScpCloud
---

- [x] Tracking updates 1/9/2025  
Reset tracking update button in production FE  
Use OperationEntry RevertTrackingUpdate method  
Allagi toy ypologismoy gia to Status toy tracking update, na paei sto UI  
Sto view toy operation entry  
Na stelnei ta TimingStatus otan kanei populate to modal toy operation entry  
na dinei kai to lastUpdate user
 
Operation entry planning na mpei timing status?
   

As part of our ongoing efforts to enhance the user experience within the production application, we are introducing improvements to how updates are tracked and displayed. Our primary objectives are:

- To clearly indicate which update is currently applied to an operation.
- To enable the ability to revert updates (applicable only to production updates).
- To refine the behavior and handling of theΒ StatusΒ field.
 
To support these changes, please note the following implementation steps:
 
1. WebProductionBff β†’ OperationEntryController β†’ GetTrackingOperationEntryModalById()  
- [x] Update TrackingOperationEntryModalDto to include a list of TrackingUpdateTypes  
- [x] Update TrackingOperationEntryDto to include: LastUpdatedAt, LastUpdatedByUser & TrackingUpdateType  
2. Introduce a new endpoint in WebProductionBff.  
- [x] This should mirror the functionality of RevertOperationEntriesTrackingUpdates from WebPlanningBff  
3. WebProductionBff β†’ OperationEntryController β†’ UpdateOperationEntryTrackingTiming()  
- [x] Modify OperationEntryTrackingTimingUpdateDto to accept Status from the FE  
- [x] Remove BE logic for calculating Status, as it will now be provided directly
   

- [x] Add timing status in batch contents planning/tracking  
- [x]

UpdateOperationEntryTrackingTiming_DataExist_UpdatesSuccessfully
check the timing status
```
builder.Subscribe\<CommandStartedEvent\>(e =\>
	{
		if (e.CommandName is "insert" or "update" or "delete" or "bulkWrite" or "commitTransaction" or "abortTransaction")
		{
			var name = e.CommandName;<br>var Lsid = e.Command.TryGetValue("lsid", out var lsid) ? lsid.ToJson() : null;
			var Txn = e.Command.TryGetValue("txnNumber", out var txn) ? txn.ToJson() : null;
			var payload = e.Command.ToJson();
			Console.WriteLine($"\n\n\n\nCMD {name} lsid={Lsid} txn={Txn} payload={payload}");
			}
		});
```




