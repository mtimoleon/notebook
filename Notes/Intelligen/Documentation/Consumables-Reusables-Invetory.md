---
categories:
  - "[[Documentation]]"
  - "[[Work]]"
created: 2026-03-26
product: ScpCloud
component:
tags:
  - documentation/intelligen
  - topic/business-logic
  - topic/code
---
## Summary

Consumables / Reusables / Inventory explanation.

## Details

`public class ConsumablesUse : ResourceUse<ConsumablesUse>` σημαίνει ότι το `ConsumablesUse` είναι η εξειδίκευση του γενικού μηχανισμού “χρήση πόρου στον χρόνο”. Δεν είναι απλό inheritance μόνο για data. Είναι self-referencing generic pattern: η βάση δουλεύει με τον πραγματικό derived τύπο ώστε να μπορεί να κάνει `Create`, `MergeInfoWith`, `RemoveInfo`, `HasSameInfoWith` χωρίς casts. Αυτό φαίνεται στη βάση [Interval.cs](C:/Users/michael/developer/scpCloud/Common/Common/Helpers/Interval.cs#L8), στη planning βάση [Interval.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Helpers/Interval.cs#L9), και στις υλοποιήσεις [ConsumablesUse.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/ConsumablesUse.cs#L14), [ReusablesUse.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/ReusablesUse.cs#L13).

### 1. Η βασική ιδέα του μοντέλου
- Όλα αποθηκεύονται ως χρονικά intervals.
- Η κοινή βάση `RateUse<T>` έχει `Start`, `End`, `Rate`, `Amount`, `LatestOutage`, `IsOutage` [Interval.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Helpers/Interval.cs#L9).
- Το `ResourceUse<T>` προσθέτει το βασικό ερώτημα του scheduler: “χωράει άλλη χρήση εδώ ή όχι;” μέσω `CanAccommodateUse(...)` [Interval.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Helpers/Interval.cs#L39).
- Το `IntervalList.AddInterval(...)` σπάει και ενώνει intervals ώστε το timeline να γίνεται κομμάτια με ομοιογενές state [IntervalLists.cs](C:/Users/michael/developer/scpCloud/Common/Common/Helpers/IntervalLists.cs#L76).
Παράδειγμα:
```text
A: 10:00-12:00
B: 11:00-13:00
Γίνεται:
10:00-11:00 -> μόνο A
11:00-12:00 -> A + B
12:00-13:00 -> μόνο B
```

### 2. Τι είναι Reusables
- Reusable = resource που “δεσμεύεται” και μετράς concurrent uses, όχι άθροισμα ρυθμών.
- Στο project αυτά είναι κυρίως equipment και staff. Στο UI φαίνονται στο tab [OperationEntryReusablesTab.jsx](C:/Users/michael/developer/scpCloud/WebApps/WebPlanningSpa/src/pages/operationEntry/reusablesTab/OperationEntryReusablesTab.jsx#L5).
- Το `ReusablesUse` κρατά `Tasks` (`List<ProcOpUseTask>`) και όχι ποσότητες [ReusablesUse.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/ReusablesUse.cs#L15).
- Ο έλεγχος γίνεται με count: αν τα ήδη ενεργά tasks χαμηλότερου precedence + το νέο required use ξεπερνούν το `rateLimit`/`maxUses`, έχεις overuse [ReusablesUse.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/ReusablesUse.cs#L79).
- Το wrapper τους είναι `ReusableResourceUtilization` με `ReusablesProfile` [ScheduleUtilizationClasses.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/ScheduleUtilizationClasses.cs#L549).
- Χρησιμοποιούνται για main equipment, aux equipment και staff στο scheduling flow [SchedulingService.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/SchedulingService.cs#L548), [SchedulingService.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/SchedulingService.cs#L785), [SchedulingService.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/SchedulingService.cs#L843).
Σημαντικό: τα `OperationEntry` breaks μπαίνουν κι αυτά στο timeline μέσω `GetIntervals()`, άρα reusable resources ξέρουν ποια κομμάτια είναι working και ποια break [OperationEntry.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Aggregates/OperationEntryAggregate/OperationEntry.cs#L1198).

### 3. Τι είναι Consumables
- Consumable = resource που το μοντέλο το βλέπει σαν ρυθμό κατανάλωσης/χρήσης ανά χρόνο.
- Στο UI το tab περιέχει labor, input streams, output streams [OperationEntryConsumablesTab.jsx](C:/Users/michael/developer/scpCloud/WebApps/WebPlanningSpa/src/pages/operationEntry/consumablesTab/OperationEntryConsumablesTab.jsx#L6).
- Το `ConsumablesUse` κρατά `RateTasks` και συνολικό `Rate` [ConsumablesUse.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/ConsumablesUse.cs#L16).
- Όταν δύο intervals επικαλύπτονται, στο merge κάνει άθροισμα ρυθμών: `Rate += interval.Rate` [ConsumablesUse.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/ConsumablesUse.cs#L45).
- Ο έλεγχος γίνεται με sum: αν το άθροισμα των rates ως το precedence του task ξεπερνά το `maxRate`, έχεις conflict [ConsumablesUse.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/ConsumablesUse.cs#L75).
- Το wrapper τους είναι `ConsumableResourceUtilization` με `ConsumablesProfile` [ScheduleUtilizationClasses.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/ScheduleUtilizationClasses.cs#L639), [ResourceProfiles.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/ResourceProfiles.cs#L380).

### 4. Ποια domain objects μπαίνουν εδώ
- `LaborResources` είναι consumables στο scheduling. Το labor rate βγαίνει από `FinalAmount / OperationEntry.Duration` στο [OperationEntryLabor.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Aggregates/OperationEntryAggregate/OperationEntryLabor.cs#L109), και προστίθεται ως `new ConsumablesUse(...)` στο [SchedulingService.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/SchedulingService.cs#L899).
- `InputStreams` και `OutputStreams` είναι “consumable-like” για charts/material profiles μέσω `ConsumablesProfile` στο [CalculateChartDataService.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/CalculateChartDataService.cs#L24).
- Για inventory constraints όμως τα streams δεν περνάνε από `ConsumablesUse`, αλλά από `InventoryProfile`/`StorageUnitUtilization` [SchedulingService.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/SchedulingService.cs#L916).
- `AuxEquipment` και `Staff` είναι reusables στο `OperationEntry` [OperationEntry.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Aggregates/OperationEntryAggregate/OperationEntry.cs#L154), [OperationEntry.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Aggregates/OperationEntryAggregate/OperationEntry.cs#L158). Τα defaults μπαίνουν από `AssignDefaultReusableResources()` [OperationEntry.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Aggregates/OperationEntryAggregate/OperationEntry.cs#L1245).

### 5. Τι είναι Inventory / Storage Units
- Το inventory path είναι ξεχωριστό από τα `ReusablesUse` και `ConsumablesUse`. Δεν χρησιμοποιεί `ResourceUse<T>`, αλλά το δικό του interval type `InventoryUse : RateUse<InventoryUse>` [InventoryUse.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/InventoryUse.cs#L16).
- Εδώ το μοντέλο δεν απαντά μόνο “πόσα concurrent uses υπάρχουν;” ή “ποιο είναι το συνολικό rate;”. Απαντά “πόσο actual και πόσο available inventory υπάρχει μέσα στον χρόνο;”, μαζί με QA, expiration και transfer events.
- Το wrapper είναι `StorageUnitUtilization`, το οποίο κρατά 2 profiles:
  - `LowLimitInventoryProfile`
  - `HighLimitInventoryProfile`
  [ScheduleUtilizationClasses.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/ScheduleUtilizationClasses.cs#L691)
- Τα `InputStreams` προστίθενται στο `LowLimitInventoryProfile`, γιατί τραβάνε υλικό από storage και μπορεί να ρίξουν το amount κάτω από low limit [SchedulingService.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/SchedulingService.cs#L928).
- Τα `OutputStreams` προστίθενται στο `HighLimitInventoryProfile`, γιατί βάζουν υλικό στο storage και μπορεί να ξεπεράσουν το high limit [SchedulingService.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/SchedulingService.cs#L980).
- Το `InventoryProfile.AddInventoryUse(...)` δεν βάζει μόνο ένα απλό rate interval. Μπορεί να δημιουργήσει και επιπλέον instantaneous intervals για:
  - `QaCompletion`
  - `Expiration`
  ανάλογα με το storage behavior [InventoryProfile.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/InventoryProfile.cs#L112).
- Το τελικό inventory state βγαίνει από `GetFinalInventoryProfile()`, που κάνει post-processing του timeline και χειρίζεται continuous ή calendar-based transfer logic [InventoryProfile.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/InventoryProfile.cs#L90), [InventoryProfile.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/InventoryProfile.cs#L161), [InventoryProfile.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/InventoryProfile.cs#L345).
- Άρα τα inventory conflicts δεν είναι consumable conflicts με άλλο όνομα. Είναι ξεχωριστή κατηγορία και περιλαμβάνουν:
  - `StorageUnitOveruse` για reception/supply rate limits
  - `StorageUnitInventory` για high/low amount violations
  - `StorageUnitBatchIntegrity` όταν ανακατεύονται batches σε storage που απαιτεί integrity
  [SchedulingService.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/SchedulingService.cs#L947), [SchedulingService.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/SchedulingService.cs#L959), [SchedulingService.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/SchedulingService.cs#L1000), [SchedulingService.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/SchedulingService.cs#L1012), [SchedulingService.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/SchedulingService.cs#L1022).
**Mental model**
- `Reusable` = concurrent occupancy
- `Consumable` = summed rate over time
- `Inventory` = evolving storage state over time (amounts, availability, QA, expiration, transfer limits, batch integrity)

### 6. Πώς προκύπτουν conflicts
- Reusables: `CreateOveruseConflicts(...)` και `CreateOutageConflicts(...)` [SchedulingService.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/SchedulingService.cs#L1178), [SchedulingService.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/SchedulingService.cs#L1219).
- Consumables: `CreateRateTaskIntervalConflicts(...)` [SchedulingService.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/SchedulingService.cs#L1266).
- Και οι δύο κατηγορίες χρησιμοποιούν το ίδιο profile engine για slot finding forward/backward [ResourceProfiles.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/ResourceProfiles.cs#L82), [ResourceProfiles.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/ResourceProfiles.cs#L243).
- Inventory uses: εδώ το conflict engine δεν ελέγχει απλώς concurrent uses ή summed rates, αλλά την εξέλιξη του storage state μέσα στον χρόνο. Τα streams ενημερώνουν τα `InventoryProfile`s του storage unit και μετά το σύστημα ελέγχει:
  - αν παραβιάζονται reception/supply rate limits (`StorageUnitOveruse`)
  - αν το inventory amount βγαίνει εκτός low/high ορίων (`StorageUnitInventory`)
  - αν σπάει το batch integrity (`StorageUnitBatchIntegrity`)

### Δομή
```text
Interval<T>
└── RateUse<T>
    ├── Rate
    ├── Amount
    ├── LatestOutage / IsOutage
    ├── ResourceUse<T>
	|   ├── CanAccommodateUse(...)
	|	​├── CanAccommodateUseIntraBatch(...)
    │   ├── ReusablesUse
    │   │   ├── Tasks : List<ProcOpUseTask>
    │   │   ├── semantics: concurrent occupancy
    │   │   └── used by: MainEquipment, AuxEquipment, Staff
    │   └── ConsumablesUse
    │       ├── RateTasks : List<ProcOpRateTask>
    │       ├── semantics: summed rate over time
    │       └── used by: Labor
    │           and by charts for Input/Output Streams
    └── InventoryUse
        ├── InventoryTransfers : List<InventoryTransfer>
        ├── semantics: evolving storage state over time
        ├── supports: actual/available amount, QA, expiration
        └── used by: StorageUnit inventory constraints
Profiles / Utilization
ReusablesUse   -> ReusablesProfile   -> ReusableResourceUtilization
ConsumablesUse -> ConsumablesProfile -> ConsumableResourceUtilization
InventoryUse   -> InventoryProfile   -> StorageUnitUtilization
```

### Παραδείγματα
#### Παράδειγμα με 2 operations πάνω στο ίδιο `Equipment` και το ίδιο `Labor`
Έστω:
- `OpA`: `10:00 - 12:00`
- `OpB`: `11:00 - 13:00`
- ίδιο `Equipment E1` με `MaxUses = 1`
- ίδιο `Labor L1` με `NumberOfPersons = 3`
- `OpA` χρειάζεται labor rate `2`
- `OpB` χρειάζεται labor rate `2`
Οι reusable χρήσεις μπαίνουν σαν `ReusablesUse` intervals για equipment/staff [ReusablesUse.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/ReusablesUse.cs#L13), ενώ οι consumable χρήσεις μπαίνουν σαν `ConsumablesUse` με rate [ConsumablesUse.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/ConsumablesUse.cs#L14).

**1. Reusable παράδειγμα: Equipment**
Για το `E1`, το σύστημα δεν αθροίζει rate. Μετράει πόσα tasks το χρησιμοποιούν ταυτόχρονα.
Αρχικά:
```text
OpA on E1: 10:00-12:00
```
Μετά προσθέτεις το `OpB`:
```text
OpB on E1: 11:00-13:00
```
Το `AddInterval` σπάει τη γραμμή χρόνου [IntervalLists.cs](C:/Users/michael/developer/scpCloud/Common/Common/Helpers/IntervalLists.cs#L76):
```text
10:00-11:00 -> [OpA]
11:00-12:00 -> [OpA, OpB]
12:00-13:00 -> [OpB]
```
Επειδή `MaxUses = 1`, το κομμάτι `11:00-12:00` είναι conflict.
Αυτό εντοπίζεται από `CreateOveruseConflicts(...)` [SchedulingService.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/SchedulingService.cs#L1178).
Σκέψη του engine:
- πριν το `OpB`, υπάρχει ήδη 1 active use
- το `OpB` θέλει άλλο 1 use
- `1 + 1 > 1` => overuse

**2. Consumable παράδειγμα: Labor**
Για το `L1`, το σύστημα αθροίζει rates, όχι πλήθος tasks.
Αρχικά:
```text
OpA on L1: rate = 2, 10:00-12:00
```
Μετά:
```text
OpB on L1: rate = 2, 11:00-13:00
```
Το profile γίνεται:
```text
10:00-11:00 -> rate 2   [OpA]
11:00-12:00 -> rate 4   [OpA + OpB]
12:00-13:00 -> rate 2   [OpB]
```
Επειδή το labor limit είναι `3`, το κομμάτι `11:00-12:00` είναι conflict.
Αυτό ελέγχεται από `CreateRateTaskIntervalConflicts(...)` [SchedulingService.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/SchedulingService.cs#L1266).
Σκέψη του engine:
- ήδη τρέχει rate `2`
- νέο task ζητά `2`
- `2 + 2 = 4 > 3` => labor overuse

**3. Άρα η ουσιαστική διαφορά**
- `Reusable`: “πόσοι το κρατάνε ταυτόχρονα;”
- `Consumable`: “πόσο συνολικό rate περνάει ταυτόχρονα;”

**4. Πού το βλέπεις στο scheduling flow**
- Aux equipment / staff μπαίνουν σαν `ReusablesUse` [SchedulingService.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/SchedulingService.cs#L785), [SchedulingService.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/SchedulingService.cs#L843)
- Labor μπαίνει σαν `ConsumablesUse` [SchedulingService.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/SchedulingService.cs#L899)

**5. Mini διάγραμμα**
```text
        ίδιο χρονικό overlap / ίδιο scheduling question
                                |
          +---------------------+---------------------+
          |                     |                     |
     Reusable resource     Consumable resource   Inventory / Storage
     (equipment/staff)     (labor/rates)         (storage units)
          |                     |                     |
   metráo concurrent uses   athroízo rates      ypologízo amounts/state
          |                     |                     |
   [OpA, OpB] => 2 uses      2 + 2 => 4 rate     opening + flows + QA
          |                     |                     |
   MaxUses check            RateLimit check       high/low inventory,
MaxUses = 1 -> conflict   Limit = 3 -> conflict   reception/supply,
                                                  batch integrity
```

**6. Πρακτικό mental model**
Αν ρωτάς:
- “μπορούν 2 operations να έχουν τον ίδιο άνθρωπο/ίδιο μηχάνημα μαζί;” => `Reusable`
- “μπορούν 2 operations να τραβάνε συνολικά τόσο labor/material flow μαζί;” => `Consumable`

#### Παραδείγματα με `breaks` και `outages`.
Το `OperationEntry` δεν θεωρείται πάντα ένα ενιαίο interval. Η `GetIntervals()` το σπάει σε κομμάτια `working` και `non-working` [OperationEntry.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Aggregates/OperationEntryAggregate/OperationEntry.cs#L1198). Αυτό είναι κρίσιμο για reusable resources, γιατί το σύστημα ξέρει πότε το operation δουλεύει και πότε είναι σε παύση.

##### 1. Παράδειγμα με break
Έστω operation:
- `OpA: 10:00 - 14:00`
- break: `11:30 - 12:00`
Τότε το `GetIntervals()` επιστρέφει ουσιαστικά:
```text
10:00-11:30 -> working = true
11:30-12:00 -> working = false
12:00-14:00 -> working = true
```
Για reusable resource, π.χ. `Equipment E1`, αυτό μπαίνει σαν:
- `ReusablesUse(..., isWorking: true)`
- `ReusablesUse(..., isWorking: false)`
- `ReusablesUse(..., isWorking: true)`
στο scheduling flow [SchedulingService.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/SchedulingService.cs#L783), [SchedulingService.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/SchedulingService.cs#L841).
**Τι σημαίνει αυτό πρακτικά;**
Το operation συνεχίζει να “υπάρχει” χρονικά, αλλά στο break interval δεν θεωρείται ενεργή παραγωγική χρήση. Γι’ αυτό στο outage conflict logic υπάρχει ειδικός έλεγχος:
- non-working tasks δεν δημιουργούν outage conflicts [SchedulingService.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/SchedulingService.cs#L1243).
Άρα αν πέσει outage ακριβώς πάνω στο break, δεν θα βγει conflict για εκείνο το κομμάτι.

##### 2. Break + reusable example
Έστω:
- `OpA`: `10:00-14:00`
- break: `11:30-12:00`
- `Equipment outage`: `11:40-11:50`
Timeline:
```text
Operation A:
10:00         11:30 12:00                    14:00
|--------------work---break---work-------------|
Equipment outage:
                   11:40----11:50
```
Εδώ το outage πέφτει μέσα στο break.
Άρα:
- για `11:40-11:50`, το task είναι `isWorking = false`
- το `CreateOutageConflicts(...)` το αγνοεί
- δεν έχεις equipment outage conflict για αυτό το κομμάτι

##### 3. Αν το outage πέσει σε working interval
Ίδιο operation, αλλά outage `12:15-12:30`:
```text
Operation A:
10:00         11:30 12:00                    14:00
|--------------work---break---work-------------|
Equipment outage:
                         12:15-----12:30
```
Τώρα το outage πέφτει πάνω σε `working = true`, άρα βγαίνει conflict, εκτός αν το `OutageBehavior` επιτρέπει εξαίρεση.

#### Τι είναι outage στο μοντέλο
Το outage αποθηκεύεται μέσα στο ίδιο interval μοντέλο μέσω `LatestOutage` / `IsOutage` [Interval.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Helpers/Interval.cs#L17).
Άρα ένα interval μπορεί να κουβαλάει:
- task info
- rate info
- και ταυτόχρονα outage info
Για equipment/staff outages, το utilization αρχικοποιείται ήδη με outage intervals [ScheduleUtilizationClasses.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/ScheduleUtilizationClasses.cs#L141), [ScheduleUtilizationClasses.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/ScheduleUtilizationClasses.cs#L173), [ScheduleUtilizationClasses.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/ScheduleUtilizationClasses.cs#L556).

##### OutageBehavior
Το `OperationEntry` έχει `OutageBehavior` [OperationEntry.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Aggregates/OperationEntryAggregate/OperationEntry.cs#L151).
Στο scheduling/search το profile κοιτάει 3 βασικές περιπτώσεις [ResourceProfiles.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/ResourceProfiles.cs#L82), [ResourceProfiles.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/ResourceProfiles.cs#L243):
- `Consider`
  - outage = κανονικό εμπόδιο
- `Ignore`
  - το outage δεν εμποδίζει το slot
- `IgnoreIfStarted`
  - αν η operation έχει αρχίσει εκτός outage, μπορεί να συνεχίσει και πάνω από outage

##### 6. Παράδειγμα `IgnoreIfStarted`
Έστω:
- operation duration: `2h`
- search starts: `10:00`
- outage: `11:00-11:20`
Αν η operation ξεκινήσει `10:00`, τότε έχει ήδη αρχίσει πριν το outage.
Με `IgnoreIfStarted`:
```text
10:00------11:00====11:20-----------12:20
 work        outage allowed           end
```
Το slot μπορεί να θεωρηθεί αποδεκτό, και το τέλος να πάει αργότερα αν το outage μετράει σαν break/παύση ανάλογα με τους κανόνες.
Αν όμως η operation προσπαθεί να ξεκινήσει μέσα στο outage:
```text
       11:05 start
11:00====11:20
```
τότε δεν ισχύει η εξαίρεση “if started”.

##### 7. Τι γίνεται στα consumables με break
Στο labor scheduling, το `ConsumablesUse(operationEntryTask, rate)` μπαίνει ως ένα ενιαίο interval από `task.Start` μέχρι `task.End` [ConsumablesUse.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/ConsumablesUse.cs#L27), [SchedulingService.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/SchedulingService.cs#L899).
Άρα:
- για labor conflicts το μοντέλο είναι πιο “continuous”
- δεν κουβαλά `isWorking` flag όπως το reusable
- τα breaks επηρεάζουν περισσότερο το slot-finding μέσω duration/outage behavior παρά με explicit `working/non-working` labor sub-intervals
Αυτό είναι μια βασική διαφορά σχεδιασμού.

#### 8. Συνολικό διάγραμμα
```text
OperationEntry
└── GetIntervals()
    ├── working interval
    ├── break interval
    └── working interval
Reusable path
OperationEntry interval
└── ReusablesUse(task, isWorking)
    ├── if overlap with other tasks -> overuse check
    └── if overlap with outage and isWorking=true -> outage conflict
Consumable path
OperationEntry / task
└── ConsumablesUse(task, rate)
    ├── overlapping rates are summed
    └── if sum(rate) > limit -> rate conflict
Inventory path
OperationEntry working intervals + stream
└── InventoryProfile.AddInventoryUse(...)
    ├── input stream -> LowLimitInventoryProfile
    ├── output stream -> HighLimitInventoryProfile
    ├── may add QA / expiration instantaneous intervals
    └── final profile -> inventory, rate, and batch-integrity conflicts
```

#### 9. Mental model
- `Break` = εσωτερικό κομμάτι της operation όπου το operation δεν δουλεύει
- `Outage` = εξωτερικός περιορισμός του resource
- `Reusable` resources ξέρουν ακριβώς αν το operation είναι σε work ή break
- `Consumable` resources δουλεύουν κυρίως με rate accumulation
Αν θέλεις, στο επόμενο μπορώ να σου κάνω ένα πλήρες end-to-end example με:
- `1 equipment`
- `1 staff`
- `1 labor`
- `1 break`
- `1 outage`
- και να σου δείξω ακριβώς ποια intervals θα υπάρχουν τελικά στο profile.

## Links
[[Consumables Uses]]
[[Inventory Uses]]
[[Reusables Uses]]
