---
categories:
  - "[[Documentation]]"
  - "[[Work]]"
created: 2026-04-16
product: scpCloud
component:
tags:
  - documentation/intelligen
  - topic/business-logic
  - topic/code
---
## Summary
​
Το `ConsumablesUse` είναι το interval model για resources που αντιμετωπίζονται ως rate πάνω στον χρόνο. Ο scheduler δεν μετρά "πόσα tasks κρατάνε το resource" αλλά "ποιο είναι το συνολικό rate που τρέχει την ίδια στιγμή;".
​
Κεντρικά παραδείγματα:
- labor
- material-like rate profiles στα charts
​
Βασικό class path:
​
```text
Interval<T>
└── RateUse<T>
    └── ResourceUse<T>
        └── ConsumablesUse
```
​
## Τι κρατάει
​
Το `ConsumablesUse` κρατά:
- `RateTasks : List<ProcOpRateTask>`
- `Rate`
- outage info μέσω της βάσης
​
Κάθε `ProcOpRateTask` συνδέει:
- `ProcOpTask`
- `Rate`
​
Άρα το interval δεν εκφράζει απλώς ότι "υπάρχει χρήση". Εκφράζει ότι "σε αυτό το χρονικό κομμάτι τρέχει αυτό το rate και συνεισφέρουν αυτά τα tasks".
​
## Πώς δουλεύει το merge
​
Όταν 2 consumable intervals επικαλύπτονται, το merge:
- κάνει append τα `RateTasks`
- προσθέτει το `Rate`
​
Πρακτικά:
​
```text
OpA: 10:00-12:00, rate 2
OpB: 11:00-13:00, rate 2
​
10:00-11:00 -> rate 2
11:00-12:00 -> rate 4
12:00-13:00 -> rate 2
```
​
Εδώ είναι η ουσία: δεν έχει σημασία ότι είναι 2 tasks. Σημασία έχει ότι το overlap segment έχει `Rate = 4`.
​
## Πώς γίνεται ο έλεγχος capacity
​
Το `CanAccommodateUse(...)` είναι rate-based:
​
```text
sum(rates of lower-precedence tasks) + requiredRate > rateLimit
```
​
Αν ναι:
- `AccommodationType.No`
​
Αν δεν παραβιάζει rate αλλά το interval είναι outage:
- `AccommodationType.OverOutage`
​
Αλλιώς:
- `AccommodationType.Yes`
​
## Πού χρησιμοποιείται
​
Στο core scheduling χρησιμοποιείται κυρίως για labor.
​
Flow:
​
```text
OperationEntryLabor
-> FinalRateInReferenceUnit
-> new ConsumablesUse(operationEntryTask, rate)
-> laborUtilization.Profile.AddInterval(...)
-> CreateRateTaskIntervalConflicts(...)
```
​
Στη chart/logical profiling πλευρά χρησιμοποιείται και για material stream views:
- input streams
- output streams
​
Αλλά εκεί χρησιμοποιείται για charts / profiles, όχι για storage inventory constraints.
​
## Σημαντική διαφορά από inventories
​
Τα streams μπορεί να φαίνονται "consumable-like", αλλά για inventory constraints δεν περνάνε από `ConsumablesUse`.
​
Για storage units το model είναι άλλο:
- `InventoryUse`
- `InventoryProfile`
- `StorageUnitUtilization`
​
Άρα:
- chart/profile του material flow -> συχνά `ConsumablesUse`
- inventory limit / storage behavior -> `InventoryUse`
​
## Breaks και outages
​
Το labor scheduling δεν σπάει σε working/non-working sub-intervals με τον ίδιο τρόπο που το κάνει το reusable path.
​
Πρακτικά:
- το `ConsumablesUse(task, rate)` είναι ένα ενιαίο interval από `task.Start` μέχρι `task.End`
- δεν έχει `IsWorking` flag μέσα στην task info
​
Αυτό σημαίνει ότι:
- το model είναι πιο continuous
- τα breaks δεν μοντελάρονται ως ξεχωριστά labor occupancy pieces
- το outage / slot-finding behavior περνάει μέσα από το profile search και το `OperationOutageBehavior`
​
## Slot finding
​
Το `ConsumablesProfile` χρησιμοποιεί το ίδιο generic profile engine με τα reusables:
- `FindFirstSlotForward(...)`
- `FindFirstSlotBackward(...)`
​
Η διαφορά είναι ότι στον έλεγχο χωρητικότητας:
- reusables -> count uses
- consumables -> sum rates
​
Οπότε αν ψάχνεις slot για labor:
- το engine δοκιμάζει overlap segments
- σε κάθε overlap segment ελέγχει αν χωράει το νέο required rate
- αν υπάρχει outage, το χειρίζεται μέσω `OperationOutageBehavior`
​
## Conflicts που βγάζει
​
Για consumables στο scheduling το βασικό conflict είναι:
- `LaborOveruse`
​
Και αν υπάρχει outage σε relevant interval:
- `LaborOutage`
​
Το `CreateRateTaskIntervalConflicts(...)` δουλεύει με το merged interval result και ελέγχει αν το άθροισμα των rates μέχρι το precedence του conflicting task ξεπερνά το όριο.
​
## Παράδειγμα
​
Έστω:
- labor limit = 3
- OpA rate = 2, 10:00-12:00
- OpB rate = 2, 11:00-13:00
​
Τότε:
​
```text
10:00-11:00 -> rate 2
11:00-12:00 -> rate 4
12:00-13:00 -> rate 2
```
​
Στο `11:00-12:00`:
​
```text
2 + 2 = 4 > 3
```
​
Άρα βγαίνει `LaborOveruse`.
​
## Πρακτικό mental model
​
Χρησιμοποίησε `ConsumablesUse` όταν η ερώτηση είναι:
- "πόσο συνολικό labor τρέχει την ίδια στιγμή;"
- "αν προσθέσω άλλο ένα task, το rate θα χωρέσει;"
- "το overlap πρέπει να κριθεί με sum rates και όχι count tasks;"
​
Αν η απαίτηση είναι aggregate rate over time, τότε το σωστό model είναι το `ConsumablesUse`.
## Links
