---
categories:
  - "[[Work]]"
tags:
  - intelligen
---

**Ροή προγραμματισμού (scheduling)**

- **Είσοδοι**: Scheduling board ή συγκεκριμένα campaigns. Κάθε campaign πρέπει να έχει `Recipe` για να γίνει layout. `ScheduleCampaigns`/`ScheduleFromToCampaigns`/`ScheduleIndependentCampaign` καλούν `campaign.Layout()` και μετά (προαιρετικά) επίλυση συγκρούσεων. SchedulingService.cs
- **Modes**: `CampaignOnly`, `ToCampaign`, `FromCampaign` καθορίζουν ποια campaigns/ batches συμμετέχουν σε conflict detection & resolution. SchedulingService.cs
- **Backward scheduling**: Αν `campaign.ScheduleBackward`, τα batches εξετάζονται ανάποδα και οι αναζητήσεις slot γίνονται backward όπου χρειάζεται. SchedulingService.cs

**Εντοπισμός συγκρούσεων (conflict detection)**

- `CalculateScheduleUtilization` χτίζει utilization για όλους τους πόρους (equipment, staff, labor, storage) και συλλέγει conflicts. Περιλαμβάνει `CreateCampaignTimingConflicts` (release/due) και `AddBatchUses` (procedure + operation επίπεδο). SchedulingService.cs
- Υποστηρίζονται δύο timing modes: `Planning` vs `Tracking` (διαφορετικές μέθοδοι `Add*Tracking`). SchedulingService.cs
- Υπάρχει cache/partial recompute (με `stopAtConflict`) για πιο γρήγορη αναζήτηση conflicts σε iterations. SchedulingService.cs

**Βρόχος επίλυσης συγκρούσεων**

- `ResolveConflicts` κάνει loop μέχρι να λυθούν όλες ή να φτάσει το `maxNumberOfIterations` (50.000). SchedulingService.cs
- Κάθε iteration: υπολογίζει conflicts, παίρνει το conflict index, ελέγχει αν πρέπει να λυθεί βάσει `SchedulingConfiguration.ShouldResolveConflict`, επιχειρεί επίλυση, αλλιώς προχωρά στο επόμενο conflict. SchedulingService.cs
- Αν λυθεί conflict, reset index στο 0. Αν όχι, index++. SchedulingService.cs 
Όλες οι περιπτώσεις συγκρούσεων και στρατηγικές επίλυσης  
1) Campaign timing conflicts (release/due)

- **ConflictType.CampaignTiming**: όταν start πριν από release ή end μετά από due.
- **Επίλυση**: `TryCampaignShiftingForConflict` κάνει `SetCampaignTiming()`, μετά shift προς τα μπρος για release, και αν γίνεται χωρίς να παραβιαστεί release, shift προς τα πίσω για due. SchedulingService.cs

2) Main equipment

- **Overuse / Outage / Incompatibility**
- Στρατηγικές (σειρά προτεραιότητας):
- **Resource reallocation**: αλλαγή main equipment σε compatible (αν χωράει καθαρά). `TryResourceReallocationForConflict`
- **Breaks** σε operations αν το επιτρέπουν τα flags (`ShiftOrBreakForEquipment`) και το conflict δεν ξεκινά/τελειώνει μέσα σε operation. `TryAddingBreaksForConflict`
- **Flex shifting**: μετακίνηση procedure/operation σε διαθέσιμο slot forward/backward. `TryFlexShiftingForConflict`
- **Batch shifting**: αναζήτηση equipment που απαιτεί ελάχιστη μετατόπιση batch. `TryBatchShiftingForConflict`
- Για backward campaigns οι αναζητήσεις slot αντιστρέφονται. SchedulingService.cs

3) Aux equipment

- **Overuse / Outage / Incompatibility**
- **Resource reallocation**: αν `UseAllCompatibleAuxEquipment == false`, επιλέγει άλλο compatible aux equipment με καθαρό slot.
- **Incompatibility**: αν πρέπει να χρησιμοποιηθούν όλα, κάνει update σε all compatible.
- **Breaks**: αν επιτρέπεται `ShiftOrBreakForEquipment`.
- **Flex shifting**: slot forward/backward με `FindFirstEquipmentSlot*`.
- **Batch shifting**: υπολογισμός batch shift όπως στα main equipment.￼SchedulingService.cs

4) Staff

- **Overuse / Outage**
- **Resource reallocation**: αν `RequiredNumberOfStaffType == SpecificNumber`, αντικαθιστά staff με άλλο από staff pool που χωράει καθαρά.
- **Breaks**: αν `ShiftOrBreakForStaff`.
- **Flex shifting**: slot forward/backward στο ίδιο staff.
- **Batch shifting**: αναζήτηση slot (ή σε pool όταν χρειάζεται).￼SchedulingService.cs

5) Labor (consumable)

- **Overuse / Outage**
- **Breaks**: αν `ShiftOrBreakForLabor`.
- **Flex shifting**: slot forward/backward με rate.
- **Batch shifting**: αναλογικά με staff/equipment, αλλά με rate.￼SchedulingService.cs

6) Storage unit (inventory)

- **Overuse / Inventory limit / Batch integrity**
- Χρήση `InventoryProfile` (high/low) ανάλογα με rate και τύπο conflict.
- **Flex shifting**: `FindFirstSlotForward` και shift operation.
- **Batch shifting**: παρόμοια λογική, με σεβασμό `MaintainBatchIntegrity`.￼SchedulingService.cs 
Ενδο-batch vs δια-batch conflicts

- `conflict.IsIntrabatch` αλλάζει στρατηγική:
- Επιχειρεί μικρές μετακινήσεις μέσα στο ίδιο batch (`TryResolvingOperationEntryIntraBatch` / `TryResolvingOperationEntryIntraBatchDueDate`)
- Αποφεύγει λύσεις που μετακινούν precedent task όταν δεν πρέπει.￼SchedulingService.cs

Περιορισμοί και ασφαλιστικές δικλείδες

- `maxNumberOfIterations` προστατεύει από ατέρμονα loops. SchedulingService.cs
- Κάθε απόπειρα μετακίνησης γίνεται πάνω σε `BatchMemento` και rollback αν παραβιαστεί release/due ή αν δεν χωράει.
- Μετά από επιτυχή επίλυση, γίνεται `UpdatePostProcessingTasks` + `UpdateConditionalTasks`.￼SchedulingService.cs