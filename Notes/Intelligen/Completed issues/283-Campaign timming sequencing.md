---
categories:
  - "[[Work]]"
  - "[[Issues]]"
created: 2025-01-21T11:26
tags:
  - intelligen
status: completed
product: ScpCloud
---

- [x] --\> getCampaignPanelById
 
	ΞΒ ΞΒΞΞΞΖ’ΞΞΞΒ®ΞΞΞΒµΞβ€ CampaignPanelDto  
	Ξβ€ΊΞβ€•ΞΖ’Ξβ€ΞΒ± ΞΞΞΒµ CampaignReleaseTimeOwnOperationsType (batch startall ,user defined etc.)  
	Ξβ€ΊΞβ€•ΞΖ’Ξβ€ΞΒ± ΞΞΞΒµ CampaignDueTimeOwnOperationsType (all ,user defined etc.)  
	Ξβ€ΊΞβ€•ΞΖ’Ξβ€ΞΒ± ΞΞΞΒµ CampaignTimingModes (fixed,BatchStartOfAnotherCampaign etc.)
   

- [x] ΞΒ ΞΒΞΞΞΖ’ΞΞΞΒ®ΞΞΞΒµΞβ€ CampaignDto  
	TimeShift value  
	timeUnit
	 
	ReleaseTimeOwnOperationsType (one of campaignReleaseTimeOwnOperationsTypes)  
	ReleaseTimeReferenceCampaign  
	ReleaseTimingMode (one of CampaignTimingModes)  
	DueTimeOwnOperationsType (one of CampaignDueTimeOwnOperationsTypes)  
	DueTimeReferenceCampaign  
	DueTimingMode (one of CampaignTimingModes)
   

- [x] --\> ΞΒ¥ΞΒ»ΞΞΞβ‚¬ΞΞΞβ€•ΞΒ·ΞΖ’ΞΒ· Getcampaigns ΞΞΞΒµ searchString (ΞΞ„ΞΒµΞβ€ GetEquipmentTypes) (edited)
 
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
		Ξ’Β Ξ’Β Ξ’Β Ξ’Β ReleaseTimeMustBeBeforeDueTime
	 
		if (releaseTime \< new Date(scpCloudContext.selectedSchedulingBoard.start))  
			ReleaseTimeMustBeAfterSBStart
	 
		if (releaseTime === null)  
			FieldRequired  
	}
 
	if (releaseTimeMode !== 1) 
	{Ξ’Β Ξ’Β Ξ’Β Ξ’Β Ξ’Β Ξ’Β Ξ’Β Ξ’Β Ξ’Β Ξ’Β Ξ’Β Ξ’Β Ξ’Β Ξ’Β Ξ’Β Ξ’Β   
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
	  	 
	if (dueTimeMode !== 1)Ξ’Β Ξ’Β  
	{  
		if (dueTimeReferenceCampaign === null)  
			FieldRequired  
	}  
}
```

\> Ξβ€Ξβ‚¬ΞΒ \<[https://app.slack.com/client/T02V40ZQGKG/D02VAN5L9DH](https://app.slack.com/client/T02V40ZQGKG/D02VAN5L9DH)\>







