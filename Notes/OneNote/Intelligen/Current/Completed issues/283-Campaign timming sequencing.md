- [x] --\> getCampaignPanelById
 
	Προσθήκες CampaignPanelDto  
	Λίστα με CampaignReleaseTimeOwnOperationsType (batch startall ,user defined etc.)  
	Λίστα με CampaignDueTimeOwnOperationsType (all ,user defined etc.)  
	Λίστα με CampaignTimingModes (fixed,BatchStartOfAnotherCampaign etc.)
   

- [x] Προσθήκες CampaignDto  
	TimeShift value  
	timeUnit
	 
	ReleaseTimeOwnOperationsType (one of campaignReleaseTimeOwnOperationsTypes)  
	ReleaseTimeReferenceCampaign  
	ReleaseTimingMode (one of CampaignTimingModes)  
	DueTimeOwnOperationsType (one of CampaignDueTimeOwnOperationsTypes)  
	DueTimeReferenceCampaign  
	DueTimingMode (one of CampaignTimingModes)
   

- [x] --\> Υλοποίηση Getcampaigns με searchString (δες GetEquipmentTypes) (edited)
 
- [x] **TimeShift**: Denotes that the campaign start must be shifted by a given  
	We need to initalize the time shift in constructor of campaign to 0 hours
 
- [x] **Rules**  
```csharp
if (hasReleaseTime) 
{
	// releaseTimeMode 1 = Fixed  
	// releaseTimeMode !==1 = Based on another campaign.  
	if (releaseTimeMode === 1) 
	{  
		if (scheduleBackward && releaseTime \> dueTime)  
		    ReleaseTimeMustBeBeforeDueTime
	 
		if (releaseTime \< new Date(scpCloudContext.selectedSchedulingBoard.start))  
			ReleaseTimeMustBeAfterSBStart
	 
		if (releaseTime === null)  
			FieldRequired  
	}
 
	if (releaseTimeMode !== 1) 
	{                  
		if(releaseTimeReferenceCampaign === null)  
			FieldRequired  
	}  
}
 
if (scheduleBackward) 
{  
	// dueTimeMode 1 = Fixed  
	// dueTimeMode !== 1 = Based on another campaign.  
	if (dueTimeMode === 1 && dueTime === null)  
		FieldRequired
	  	 
	if (dueTimeMode !== 1)   
	{  
		if (dueTimeReferenceCampaign === null)  
			FieldRequired  
	}  
}
```

\> Από \<[https://app.slack.com/client/T02V40ZQGKG/D02VAN5L9DH](https://app.slack.com/client/T02V40ZQGKG/D02VAN5L9DH)\>