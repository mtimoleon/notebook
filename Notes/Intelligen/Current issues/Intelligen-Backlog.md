---
categories:
  - "[[Work]]"
created: 2026-02-14
component:
tags:
  - issues/intelligen
status: backlog
product: scpCloud
---
- [ ] 587 Theoretical rename to  Minimum
	  - [x] AverageCycleTime rename to  ActualAverageCycleTime
      Campaign Unschedule και Campaign Recipe change clear theoretical.
      ![[Intelligen-Backlog-1781689473054.png|940x423]]
- [ ] Change over matrices θα μπουνε πάνω στα recipe attributes.
- [ ] Να μπει η σχέση BOM με adaptive input/output από τη μεριά του ΒΟΜ και αν κάποιος πάει να σβήσει κάποιο adaptive input/output να μη μπορεί να σβηστεί αν είναι σε ΒΟΜ.
- [ ] When we change recipe association in BOM we should not clear BOM streams, instead we should delete adaptive inputs/outputs associations from streams.
- [ ] Δες το τελευταίο:
	Αν το βάζεις σε μικρότερο κόβεις τα τελευταία
	Αν το βάζεις παραπάνω να μπορεί να κρατήσει τα υφιστάμενα και να κάνει schedule τα υπόλοιπα
	Στην οθόνη να δείχνει Scheduled 150 of 170 δλδ  no of scheduled from total.
	![[Intelligen-Backlog-1780642600782.png|940x398]]
- [ ] Other suggestions from Alexandros
	![[Intelligen-Backlog-1780642576596.png|940x419]]
- [ ] Διάφορες εκκρεμότητες
	![[Intelligen-Backlog-1780405576701.png|940x436]]
- [ ] Move tolerance const to scheduling service
    ![[Intelligen-Backlog-1779956706611.png|940x528]]
  This is where it was declared initially      ![[Intelligen-Backlog-1779956767083.png|940x529]]
- [ ] Planning SchedulingBoardServer.GetSchedulingBoardProductionUpdates, if for some reason the original information link is missing projectTo fails and there is no way to get the production update, only to apply all.
- [ ] Check how it is determined if a procedure entry can be modified in `MoveProcedureEntryCommandHandler` line 67 and
       `Batch.ChangeProcedureEntryEquipmentAndStartByUser` line 618, `ProcedureEntry` line 95, and `OperationEntry` line 461
      ![[Intelligen-Backlog-1777987035717.png|930x349]]
- [ ] Replace NewtonsoftJson in tests with System.Text.Json
- [ ] ==Create a mechanism to guarantee that we did not forget to add an entity into import/export service==
- [ ] Bug in production chart view?
      The same applies to planning app also.
      ![[Intelligen-Backlog-1772191097275.png]]
- [ ] To be able to change the labor rate or amount in place
      ![[intelligen-Backlog-image-8.png|877]]
- [ ] Require attention code in some cases according to setting
      ![[intelligen-Backlog-image-6.png|446]]
- [ ] Moving chart of resources to production
      We need to add resource info when sending batches to production
- [ ] Sync, update most of operations but some of them may be not confirmed and the if they are in the past they stay unspecified
      Give the opportunity to mark an entire batch as completed or set the batch state which will check current time and operations start and then mark them appropriately as completed, started, upcoming
- [ ] Maybe allow operation entry consumables edit when schedule is sent in production
- [ ] Bug where Recipe lost from Campaign in scheduling board home view. Look at the query cache for problems.
      When we read the sb we probably do not read the recipe and write it into the cache.
      Check the changes in master
- [ ] Home view of scheduling board
      Recipe change and probably show schedule info (which recipe, how many batches scheduled)

### Older

- [x] [[535-Scheduling-Horizon]]
- [x] Test locally DocumentDB in place of Mongo
- [x] Backup MongoDB on Azure shared volume
      Will not do, we will go with managed service and documentDB
- [ ] Zoom στο browser και εμφάνιση εφαρμογής σε laptops της Hovione
- [ ] Export csv for production operations all columns with the other filters (==Zlate==)
- [x] (==Zlate==) Create CRUD infrastructure for
      RecipeClassification -\> RecipeAttribute
      RecipyType -\> RecipeAttributeValue

- [x] Library show tooltip (component)
- [ ] Shifts display

![Exported image](Intelligen-Backlog-20260218%202.png)

- [x] Procedure name must have a value since we are in production operation entry modal
![Exported image|931](Intelligen-Backlog-20260218%204.png)

- [ ] Add comments in production operations columns
	![Exported image](Intelligen-Backlog-20260218%203.png)
 - [ ] Operation entry side panel new tab, like identification, that contains attention codes and comments
- [ ] 502 Fix order bug ==Zlate==
	![Exported image](Intelligen-Backlog-20260218%201.png)
- [ ] In Admin api keycloak service, use httpClient created by httpClientFactory not with new inside service
[https://learn.microsoft.com/en-us/dotnet/core/extensions/httpclient-factory](https://learn.microsoft.com/en-us/dotnet/core/extensions/httpclient-factory)
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







