### 407-BE-Resource-ordering-and-visibility
 - UI

- Lista ordering me equipment poy tha toys vzeis to order me drag and drop  
- Lista me non visible equipment
   
- EquipmentVisibilityOrdering se diko toy Aggregate
	- [x] owned entities  
	- [x] IncludeOrderEquipment FK ston parent toy kai FK sto Equipment  
	- [x] Property orderNumber  
	- [x] ExcludeEquipment me FK ston parent toy kai FK sto Equipment  
	- [x] (one-to-one) me ta schedulingBoards (opos einai to Campaign me to PostChangeOverOperations)  
	dld sto create toy sb na balo ena EquipmentVisibilityOrdering san new opos sto Campaign kai  
	[https://learn.microsoft.com/en-us/ef/core/modeling/relationships/one-to-one](https://learn.microsoft.com/en-us/ef/core/modeling/relationships/one-to-one)  
	- [x] Property Exclude equipment if used in main eq pool  
	- [x] Property Exclude equipment if used in aux eq pool

- [x] Add endpoint POST /options/scheduling-board/{id}/update-equipment-visibility  
List\<int\> Ids, ExcludeFromAuxEquipmentPool, ExcludeFromMainEquipmentPool  
- [x] Consume EquipmentOrderingVisibility in EOC chart data for planning and tracking data  
- [x] Consume StaffOrderingVisibility in EOC chart data for planning and tracking data  
- [x] Remove equipment show in charts  
- [x] Remove staff show in charts  
- [x] Missing aux Equipment and aux staff in Eoc chart -\> look at schedule utilization where we set main equipment pool  
- [x] VisibilityOrdering, one property one to one with sb  
- [x] include extension kai use ayto gia to visibility kai na pernaeo sto get eoc data anexartita  
- [x] Remove endpoint GET /scheduling-board/{id}/equipment-with-facility - na parei apo to workspac kai pithanon exoyme idi endpoint  
- [x] Remove endpoint GET /scheduling-board/{id}/staff-with-facility - na parei apo to workspac kai pithanon exoyme idi endpoint
     
   

- [x] Add endpoint GET /scheduling-board/{id}/equipment-with-facility  
searchString, offset, limit, excludedIds ==NEEDS Cleanup==  
- [x] Add endpoint GET /scheduling-board/{id}/staff-with-facility  
searchString, offset, limit, excludedIds ==NEEDS Cleanup==  
- [x] Add endpoint GET /options/scheduling-board/{id}/equipment-ordering  
Returns IncludeOrderEquipment as EquipmentFacilityDto  
- [x] Add endpoint GET /options/scheduling-board/{id}/staff-ordering  
Returns IncludeOrderStaff as StaffFaciltyDto  
- [x] Add endpoint POST /options/scheduling-board/{id}/update-equipment-ordering  
List\<int\> Ids  
- [x] Add endpoint POST /options/scheduling-board/{id}/update-staff-ordering  
List\<int\> Ids  
- [x] Add endpoint GET /options/scheduling-board/{id}/equipment-visibility  
Returns ExcludeEquipment as ExcludeEquipment  
ExcludeFromAuxEquipmentPool  
ExcludeFromMainEquipmentPool  
- [x] Add endpoint GET /options/scheduling-board/{id}/staff-visibility  
Returns ExcludeStaff as ExcludeStaff  
ExcludeFromStaffPool  
- [x] Add endpoint POST /options/scheduling-board/{id}/update-staff-visibility  
List\<int\> Ids, ExcludeFromStaffPool
 
- [x] Rename controller

![Exported image](Exported%20image%2020260209135750-0.png)      
**Questions/Tasks:**

1. - [ ] Check triggers that needed, an sviso ena equipment ti tha ginei? Gia na sviso ena equipment den prepei na einai used se scheduling board I kapoio recipe. An pao na to sviso skaei me error sto pool (einai used) an to vgalo apo to pool toy recipe pali den me afinei na to sviso giati einai sto pool toy operation entry sto sb. An kano reschedule tha fygei apo to pool toy oe toy sb opote kai tha svisei kanonika
2. - [x] Check what happens when cloning schedulingBoard. During cloning we need to take care the visibility ordring clone (IDeepCopy ?) Currently it is getting copied.
3. - [x] PlanningDomainContext add filter for options
4. - [x] Check what happens when deleting SchdulingBoard or Workspace
5. - [ ] Added staffpool in cache query for scheduling board (GetCampaignForConflictResolutionQueryable), do not know if we need to add it somewhere else, some other query.    
![Exported image](Exported%20image%2020260209135752-1.png)     
![Exported image](Exported%20image%2020260209135756-2.png)



![[Drawing 2026-02-09 16.58.02.excalidraw|800]]