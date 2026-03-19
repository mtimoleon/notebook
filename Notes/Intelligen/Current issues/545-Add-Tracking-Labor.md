---
categories:
  - "[[Work]]"
created: 2026-03-11
product:
component:
status:
tags:
  - issues/intelligen
---
## Context
#### Labor chart in production
Currently when an operator updates labor amount from 2 person hours to 4 person hours there is no way to depict this in production app. We need to add similar logic with tracking update to operationEntryLabor so when operator changes the value this goes to planning app and then comes back updated because we now keep the new value in tracking update.

[[Tracking updates]]
[[Operation Entry tracking update]]

- [x] Add OperationEntryLaborTracking class
- [x] When syncing need to sync the trackingLabor also so it is visible in production app
- [x] When applying the update need to add operation entry labor update from tracking

- [ ] Nullable LastUpdatedAt kai sta 2 tracking updates
- [ ] Na mpei User sto Labor tracking update
- [ ] Remove concurrency token from config of operation entry labor tracking update, see inside operation entry config
- [ ] ![[545-Add-Tracking-Labor-1773830616609.png|510]]
- [ ] Na pane mesa sto set
![[545-Add-Tracking-Labor-1773833186093.png]]
## Notes
Tracking labor uses

- [x] otan allazei to duration toy operation entry prepei na allazei kai to finalAmount
- [x] OperationEntryLaborTrackingUpdate παρόμοιο 
- [x] Otan allazei to tracking duration toy operation entry, Δες operationEntry SetResources , UpdateTrackingTiming


OperationEntryLaborTrackingUpdate m;esa sto OperationEntry
![[Intelligen-Notes-1773229486796.png|542]]
tha exei mono to amount
![[Intelligen-Notes-1773229680588.png|543]]
SetResources in OperationEntry
SetTrackingResources
==SetTrackingDuration==


Tα σημεία παρέμβασης είναι αυτά:
**Domain**
- [OperationEntryLaborTrackingUpdate.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Aggregates/OperationEntryAggregate/OperationEntryLaborTrackingUpdate.cs): να το φέρεις στο ίδιο lifecycle με το `OperationEntryTrackingUpdate`. Θέλει τουλάχιστον baseline `Reset()`, σωστό initial copy από `OperationEntryLabor.FinalAmount`.
- [OperationEntryLabor.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Aggregates/OperationEntryAggregate/OperationEntryLabor.cs): να αποκτήσει tracking-facing surface. Πρακτικά ένα `TrackingFinalAmount` getter και, αν χρειάζεται, method για auto recalculation με βάση το `OperationEntry.TrackingDuration`.
- [OperationEntry.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Aggregates/OperationEntryAggregate/OperationEntry.cs): εδώ είναι το βασικό integration point. Θέλει:
  - να κάνει `sync/reset/apply/revert` και για labor tracking updates μαζί με το main tracking update,
  - να ξαναϋπολογίζει tracked labor final amounts όταν αλλάζει tracked duration (`UpdateTrackingTiming`, `SetTrackingDuration`),
  - να περνάει tracked labor final amounts στο planning όταν γίνει `ApplyTrackingUpdate`, αν αυτό είναι το επιθυμητό behavior.
**Persistence / loading**
- `PlanningDbContext` και ό,τι EF configuration υπάρχει για `OperationEntry`/`OperationEntryLabor`: να χαρτογραφηθεί σωστά η νέα σχέση.
- Όπου φορτώνεται cached `SchedulingBoard` / `OperationEntry` με includes, να μπουν και τα labor tracking updates. Αλλιώς το domain logic θα τα βλέπει `null`.
  Χρήσιμα σημεία: [IncludeExtension.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Api/Extensions/IncludeExtension.cs), [OperationEntryServer.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Api/GrpcServers/OperationEntryServer.cs).
- Migration για νέο table / relation.
**Application handlers**
- Αν το labor tracking θα αλλάζει μόνο έμμεσα από tracking duration, δεν χρειάζεσαι νέο production endpoint.
- Αν θέλεις και direct user edit από production, τότε θέλει νέο DTO + command + handler + BFF endpoint, αντίστοιχα με timing/staff/aux.
- Ο υπάρχων planning handler [UpdateOperationEntryLaborAmountCommandHandler.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Api/Application/Commands/OperationEntryCommands/UpdateOperationEntryLaborAmountCommandHandler.cs) είναι planning-only. Δεν μπαίνει αυτόματα στο tracking flow.
**DTOs / mapping / UI**
- [OperationEntryDto.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Grpc/Dtos/OperationEntryDto.cs): αν θέλεις να φαίνεται στο production modal ή στο planning updates tab, πρέπει να προσθέσεις tracked labor fields/dtos.
- [AutoMapperCoreProfile.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Api/Helpers/AutoMapperCoreProfile.cs): να χαρτογραφήσεις tracked labor στο `TrackingOperationEntryDto` και, αν το θες visible στα updates, και στο `OperationEntryTrackingUpdateDto`.
- [UpdatesGroup.jsx](C:/Users/michael/developer/scpCloud/WebApps/WebPlanningSpa/src/pages/updates/updatesTab/UpdatesGroup.jsx): μόνο αν θέλεις labor diff να φαίνεται στο grid των pending updates.
- Production modal/pages: μόνο αν θέλεις να εμφανίζεται tracked labor εκεί.
**Sync προς Production**
- [AutomapperProductionProfile.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Api/Helpers/AutomapperProductionProfile.cs): εδώ είναι κρίσιμο σημείο. Σήμερα το production payload για labor τραβάει `OperationEntryLabor.FinalAmount`, δηλαδή planning value. Αν θέλεις το tracking publish να στέλνει tracked labor, εδώ πρέπει να γίνει timing-aware mapping.
- [SyncService.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Api/Services/SyncService.cs): λογικά δεν θέλει νέο flow, αλλά θα επηρεαστεί έμμεσα μόλις τα tracking batch contents αρχίσουν να περιέχουν tracked labor values.
**Tests**
- Domain tests για `sync/reset/apply/revert` του labor tracking update.
- Functional test: tracking timing update αλλάζει tracked duration και επανυπολογίζει tracked labor final amount.
- Functional test: `apply-production-updates` περνάει και labor final amounts στο planning, αν αυτό επιλέξεις.
- Functional test: republish/sync στέλνει το σωστό labor amount στο production tracking payload.
Τα 2 design decisions που πρέπει να κλειδώσεις πριν ξεκινήσεις είναι:
- Το `OperationEntryLaborTrackingUpdate` θα είναι μόνο derived από tracking duration ή και user-editable;
- Στο `apply`, το tracked labor final amount θα γίνεται νέο planning `FinalAmount` ή θα μένει μόνο tracking concern;


**Checklist**
1. **Κλείδωσε το behavior**
- Αποφάσισε αν το `OperationEntryLaborTrackingUpdate` είναι μόνο auto-derived από `TrackingDuration` ή και user-editable από production.
- Αποφάσισε αν το `ApplyTrackingUpdate` θα περνάει το tracked labor `FinalAmount` στο planning `OperationEntryLabor.FinalAmount`.
2. **Σύνδεσε το domain model**
- Ενσωμάτωσε το νέο labor tracking state στο [OperationEntry.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Aggregates/OperationEntryAggregate/OperationEntry.cs).
- Πρόσθεσε tracking-aware accessors/methods για labor στο [OperationEntryLabor.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Aggregates/OperationEntryAggregate/OperationEntryLabor.cs).
- Ολοκλήρωσε το lifecycle στο [OperationEntryLaborTrackingUpdate.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Aggregates/OperationEntryAggregate/OperationEntryLaborTrackingUpdate.cs): baseline copy, reset, auto recalculation, production/manual state, metadata.
3. **Δέσε το με το υπάρχον tracking lifecycle**
- Στο `SyncTrackingUpdate()` να δημιουργούνται/resetάρονται και τα labor tracking updates.
- Στο `ResetAutoTrackingUpdate()` να ξαναχτίζονται σωστά όταν δεν υπάρχει production override.
- Στο `ResetTrackingUpdate()` να γίνεται revert και των labor tracking updates.
- Στο `ApplyTrackingUpdate()` να γίνεται apply και για labor, αν αυτό είναι ο κανόνας.
- Στα `UpdateTrackingTiming()` και `SetTrackingDuration()` να επανυπολογίζονται tracked labor final amounts.
4. **Persistence / EF**
- Πρόσθεσε relation/configuration στο EF model και migration για το νέο entity/table.
- Βεβαιώσου ότι τα query graphs που φορτώνουν `OperationEntry`/`SchedulingBoard` φέρνουν και labor tracking updates.
- Κοίτα κυρίως [IncludeExtension.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Api/Extensions/IncludeExtension.cs) και τα relevant load points στο [OperationEntryServer.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Api/GrpcServers/OperationEntryServer.cs).
5. **DTOs / mapping**
- Αν το production modal πρέπει να δείχνει tracked labor, πρόσθεσε fields στα DTOs στο [OperationEntryDto.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Grpc/Dtos/OperationEntryDto.cs).
- Αν το planning updates list πρέπει να δείχνει labor diffs, επέκτεινε και το `OperationEntryTrackingUpdateDto`.
- Ενημέρωσε mappings στο [AutoMapperCoreProfile.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Api/Helpers/AutoMapperCoreProfile.cs).
6. **Sync προς production**
- Ενημέρωσε το tracking-aware mapping στο [AutomapperProductionProfile.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Api/Helpers/AutomapperProductionProfile.cs), γιατί σήμερα το labor publish τραβάει planning `FinalAmount`.
- Έλεγξε ότι το existing flow του [SyncService.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Api/Services/SyncService.cs) αρκεί μόλις τα batch contents περιέχουν tracked labor.
7. **API / handlers μόνο αν χρειάζεται direct edit**
- Αν το labor tracking αλλάζει μόνο από tracked duration, δεν χρειάζεσαι νέο production endpoint.
- Αν θέλεις direct production edit, τότε πρόσθεσε νέο DTO, command handler, grpc server method, production BFF endpoint/service και SPA call, αντίστοιχα με timing/staff/aux.
8. **Planning-side labor edit interaction**
- Έλεγξε πώς συνυπάρχει με το υπάρχον planning labor update στο [UpdateOperationEntryLaborAmountCommandHandler.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Api/Application/Commands/OperationEntryCommands/UpdateOperationEntryLaborAmountCommandHandler.cs).
- Απόφαση: planning labor edit πρέπει να ξαναχτίζει το labor tracking baseline ή να αφήνει pending production labor update ανεπηρέαστο;
9. **UI μόνο όπου χρειάζεται**
- Production modal/pages αν θέλεις προβολή ή edit του tracked labor.
- Planning updates tab αν θέλεις να φαίνεται labor diff στο review/apply/revert flow.
- Αλλιώς μπορείς να το κρατήσεις backend-only αρχικά.
10. **Tests**
- Domain tests για sync/reset/apply/revert του labor tracking state.
- Functional test: tracking timing change => tracked labor final amount recalculated.
- Functional test: apply => planning labor final amount updated, αν αυτό είναι το rule.
- Functional test: revert => tracked labor ξαναγίνεται ίσο με planning.
- Functional test: sync/republish => production tracking payload έχει σωστό labor amount.


## Links
