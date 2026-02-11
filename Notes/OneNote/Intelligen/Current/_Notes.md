
- [ ] Library to have a scroll to date functionality on demand  
- [ ] Scroll to follow current time: instead of moving current time line, scroll the chart  
- [ ] if soy edose current time kai einai mesa sto display kai einai entos min/max orion to chart time kai einai to proto render ki egine to layout tote pigenai to scrolling 
      sto current time,
      na mpei ena bool prop display current time
	- Update gantt library  
	- Update initial scroll position calculation by first using prop `scrollLeft`.  
		If scrollLeft is null we use prop `timelineTime`.  
		If timelineTime is null we set effective scroll to 0.  
	- Separate the display of current time by using a dedicated prop `showTimeline` instead of checking if prop `timelineTime` is null.  
	- Set PlanningEocChart to use stored scrollLeft for chart initial scroll.  
	- Set PlanningEocChart to use separate prop for timelineTime and showTimelinet.  
	- Set TrackingEocChart to use stored scrollLeft for chart initial scroll.  
	- Set TrackingEocChart to use separate prop for timelineTime and showTimelinet.  
	- Set production EocChart to use timelineTime for chart initial scrll.  
	- Update planning TrackingEocChart to have similar behaviour with PlanningEocChart
	- ![Exported image](Exported%20image%2020260209135616-0.png)

- [ ] Export csv for production operations all columns with the other filters (==Zlate==)  
- [ ] Create CRUD infrastructure for 
      RecipeClassification -\> RecipeAttribute
      RecipyType -\> RecipeAttributeValue
 
- [ ] Library show tooltip (component)  
- [ ] Shifts display

![Exported image](Exported%20image%2020260209135617-1.png)

- [ ] Procedure name must have a value since we are in production operation entry modal￼

![Exported image](Exported%20image%2020260209135619-2.png)  

- [ ] Add comments in production operations columns

![Exported image](Exported%20image%2020260209135622-3.png)
 - [ ] Operation entry side panel new tab, like identification, that contains attention codes and comments
   

- [x] Revisit admin registration server, ExcludeFromInterceptor logic. Why do we do the transaction inside server method and then exclude it from the interceptor? Because we want to hanlde transaction and do toher things after.
 
- [x] Check tests in Master
 
- [ ] 502 Fix order bug ==Zlate==

![Exported image](Exported%20image%2020260209135627-4.png)   
- [ ] In Admin api keycloak service, use httpClient created by httpClientFactory not with new inside service￼[https://learn.microsoft.com/en-us/dotnet/core/extensions/httpclient-factory](https://learn.microsoft.com/en-us/dotnet/core/extensions/httpclient-factory)  
- [ ] Fix the names of contracts to contain the api name. Ayto na ginei oste na min mperdeyoyme ta contracts kai toys clients
    otan kaloyme dyo από διαγορετικό project  
- [ ] Integrate microsoft clarity in front end app
    [https://learn.microsoft.com/en-us/clarity/mobile-sdk/react-native-sdk](https://learn.microsoft.com/en-us/clarity/mobile-sdk/react-native-sdkhttps://www.npmjs.com/package/@microsoft/clarity)
    https://www.npmjs.com/package/@microsoft/clarity  
- [ ] Create application documentation, look at docfx [https://dotnet.github.io/docfx/index.html](https://dotnet.github.io/docfx/index.html)  
- [ ] Find a way to extract database error values from structured data and not from message. Also in UI, post a console info or error with data from the request error result /
    Na do to error poy vgainei sto duplicate name, an mporo na paro ta values apo kapoy
- [ ] Actions that should disable components or parents when called:
	- Production app, 
		- operation entry update
	- Planning app 
		scheduling board horizon edit, move scheduling board to new horizon
- [ ] Add a button in Admin that syncs users from registrations to planning, calling planning service method from admin bff  
- [ ] <mark style="background:#ff4d4f; font-color:#ffffff">BUG</mark> cursor change when moving-dragging bars out of grid (to the upper side)  
- [ ] Missing outages in production eoc data, check why the do not update from planning. Normally if an outage exists for an equipment, this outage should appear for this equipment in all the batches equipment appearances  
- [ ] Check ti ginetai otan peirazo sto planning pragmata (px allazo aggregate structure) kai ayta kanoyn affect ti mongo (to structure), ti tha vgalei I mongo sto eoc chart data, tha mporesei na dosei dedomena I tha skasei
 - [ ] When we delete sb production data in production UI we still see the sb in available sbs as we should. Selecting to see eoc chart data we see no data message. In others menu there is a forced tracking sync but this syncs only tracking info. Aka it assumed that batches are in db and not deleted. Need to decide what to do when no data exist in production db. Maybe republish-all is better to use for the others menu entry.
 - [ ] UNDO
	2 context ena to kanoniko ki ena to history. Sto history sozeis to sb me ta esoterika toy ids midenismena. Ta ids ton exoterikon dependecies ta karatame oste sto restore na einai symbata. Otan einai na kano restore adeiazo to current sb kai ferno mesa ta periexomena apo to ayto toy history
	
	ypostirixi undo se aples allages operations, allagi resources, eoc me dragging kai operation/procedure sidepanels resource kai timing updates
	giayta exoyme to batch memento poy krataei mono ayta poy allazoyn (gia timings kalos)

	
	- Undo Scheduling board
		base line sto planning EOC na vlepeis tin proigoymeni katastasi apo to history
	- Round duration time to 1 sec or 1 minute
	- Na mporoyme na ksexorisoyme bars poy exoyn pano toys update mallon me kapoio border?

- [ ] 192.168.56.1 host.docker.internal
	192.168.56.1 gateway.docker.internal
	127.0.0.1    kubernetes.docker.internal
- [ ] Να βάλουμε σύντομα το renaming στο πρόγραμμα.
	Έχουμε τις παρακάτω περιπτώσεις
	 - Sync from planning to production
	 - Production dto to serve UI

- [ ] Να γράψουμε κάποια **functional** τεστ για ta examples, δλδ να κάνει το schedule του example και να ζητάμε να πάρουμε το eoc και να βλέπουμε αν έχει δεδομένα. Ο σκοπός είναι να δούμε αν έχουμε τα σωστά includes.
 
- [ ] procedure report options color int =\> unint

 - ### StorageUnits
    Αυτή τη στιγμή στον StorageUnitController έχουμε UpdateStorageUnitReplenishDischargeStrategy() και UpdateStorageUnitContinuousReplenishDischargeDetails(). Αυτά πρέπει να συγχωνευτούν σε ένα function.
	Στο μέλλον στο παραπανω function θα πρέπει να συγχωνευτεί και το functionality UpdateCalendarEntries() από το StorageUnit.cs. Αυτή τη στιγμή δεν υπάρχει καθόλου στον controller. Αν επιλέξετε να το βάλετε από τώρα (αρα συγχωνευουμε 3 πραγματα) φροντίστε να μην σκάει αν η λίστα είναι null ή length = 0 γιατί το FE δε θα το υλοποιήσει.  
	Οι αλλαγές να φτασουν ως το domain
	\> From \< [https://app.slack.com/client/T02V40ZQGKG/later](https://app.slack.com/client/T02V40ZQGKG/later)\>   - ## Implement events deduplicate mechanism
    

## Implement events deduplicate mechanism
   
From publisher a background service to publish unpublished events
From subscriber a check for duplicate events coming. (Use mediatr integrationeventhandler)

- Currently there are 2 types of operations, `operation` and `nonProcessingOperation`
  In create operation labor command handler we use only `operation` type. We need to enhance the relative endpoint to include operation type on which we will create the new operation labor.
  This may affect other types with generics too, like streams.
- Όταν είμαι στο section και κάνω create procedure, δεν περνάμε το facility (έχει τρόπο άραγε;)
- στο create των input/output streams we return create at action pointing to get operation panel, when we will implement get stream by id we need to change these 2 pointing to get stream by id action. 

- Campaign Projects
	 - Στέλνω τα campaigns με το order που εχουν
	 - endpoints
		- add project
		- delete project
		- update campaign's project
		- change create campaign to accept the project to be in (nullable projectId)
			in handler find the project get the last campaing in project order and then create the new campaign with sfina order
		- show project ins campaign side panel identification
