DisplayProfile under scheduling board or workspace?
 
Specify resources tab -\> opos to Specify equipment/staff sto production  
Specify filter tab
   

DisplayProfile  
int WorkspaceId  
bool ShowEquipment  
enum AllUsed/SpecifyResource  
bool ShowStaff  
SelectedEquipment  
SelectedStaff
 
FilterRelationship  
List\<FilterRule\> FilterRules
   

DisplayProfile\<-\>Equipment  
DisplayProfile\<-\>Staff
   

updateDisplayProfileName  
updateDisplayProfileResources  
updateDisplayProfileFilters
 
getDisplayProfilesFilteredOrdered  
getDisplatProfilePanelById  
deleteDisplayProfiles  
createDisplayProfile
   

- [x] Schedulingboard na exei mia lista apo display profiles
 
- [x] Change read dto structure  
- [x] Validation
 
- [x] Add a service FilterLookupService