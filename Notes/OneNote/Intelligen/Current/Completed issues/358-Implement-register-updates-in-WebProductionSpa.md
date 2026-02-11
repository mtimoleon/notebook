- [x] Να δω το ct για το operation entry και batch , trackingupdate ct, se καποια δτο πρέπει να καταργηθούν  
	- [x] ConcurrencyToken in EocBatchDto in EocDataTrackingDto from GetSchedulingBoardEoctDataTracking  
	- [x] ConcurrencyToken in TrackingOperationEntryDto from GetTrackingOperationEntryPanelById  
	- [x] BatchConcurrencyToken in TrackingOperationEntryDto from GetTrackingOperationEntryPanelById
 
- [x] Αλλάζω ένα operation entry από το production αλλαζει στο πλαννιγκ αλλά den kanei sync sto production.
 
- [x]

```
var metadata = new Metadata
{
        new Metadata.Entry("schedulingboardid", schedulingBoardId.ToString())
};
var callOptions = new CallOptions(metadata);
var callContext = new CallContext(callOptions);
```
 
- [x] Rename, remove tracking from url

![Exported image](Exported%20image%2020260209135807-0.png)  

- [x] TrackingUpdateConcurrencyToken να γίνει ConcurrencyToken