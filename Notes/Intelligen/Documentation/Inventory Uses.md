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
Το `InventoryUse` είναι ξεχωριστό interval model για storage inventory behavior. Δεν είναι `ResourceUse<T>` όπως τα `ReusablesUse` και `ConsumablesUse`. Αντίθετα, κληρονομεί απευθείας από `RateUse<InventoryUse>` και μοντελoποιεί:
- continuous transfers
- instantaneous transfers
- opening inventory
- QA completion
- expiration
- receiving / discharging effects πάνω σε storage limits
​
Αυτό είναι το σωστό model για storage constraints.
​
Βασικό class path:
​
```text
Interval<T>
└── RateUse<T>
    └── InventoryUse
```
​
## Γιατί δεν είναι απλώς άλλο ένα consumable
​
Το inventory problem δεν είναι μόνο "αθροίζω rates". Πρέπει να ξέρεις:
- πόσο actual amount υπάρχει στο tank/storage
- πόσο available amount υπάρχει μετά από QA rules
- πότε μία εισροή γίνεται διαθέσιμη
- πότε μία ποσότητα λήγει
- αν υπάρχει batch mixing
- αν υπάρχουν external periodic ή continuous transfer events
​
Για αυτό το system έχει άλλο subsystem:
- `InventoryUse`
- `InventoryProfile`
- `StorageUnitUtilization`
​
## Τι κρατάει το InventoryUse
​
Το `InventoryUse` κρατά:
- `Rate` ή `Amount` ανάλογα με το αν το interval είναι continuous ή instantaneous
- `InventoryTransfers`
- `TotalAvailableAmountStart`
- `TotalAvailableAmountEnd`
- `ContributingBatches`
- optional `TransferCalendarInstance`
​
Έχει επίσης derived semantics:
- `HasReceipts`
- `HasDischarges`
- `HasFillEmptyEvent`
- `HasInventoryTransferWithQa`
- `HasInventoryTransferWithExpiration`
​
Άρα ένα inventory interval δεν περιγράφει απλώς "task με rate". Περιγράφει όλα τα transfers που συνθέτουν το state του storage σε εκείνο το χρονικό κομμάτι.
​
## Δύο profiles ανά storage unit
​
Το `StorageUnitUtilization` δεν έχει ένα profile. Έχει δύο:
- `HighLimitInventoryProfile`
- `LowLimitInventoryProfile`
​
Πρακτικά:
- output streams φορτώνουν το `HighLimitInventoryProfile`
  - γιατί προσθέτουν υλικά και μπορεί να χτυπήσεις high inventory limit
- input streams φορτώνουν το `LowLimitInventoryProfile`
  - γιατί τραβάνε υλικά και μπορεί να πέσεις κάτω από low inventory limit
​
Αυτό είναι βασικό. Χωρίς αυτό, το inventory δεν περιγράφεται σωστά.
​
## Initialization
​
Το `InventoryProfile` χτίζεται με:
- base empty interval στο scheduling horizon
- opening inventory
- possible QA completion από opening inventory
- possible expiration από opening inventory
- possible periodic external transfer calendar intervals
​
Οπότε το profile δεν ξεκινάει κενό. Ξεκινάει με ήδη προσυπολογισμένο state του storage unit.
​
## Πώς προστίθενται τα operation streams
​
Το `AddInventoryUse(...)` κάνει διαφορετική λογική για input και output streams.
​
### Input stream
​
Το input stream σημαίνει ότι το operation τραβάει από το storage.
​
Άρα:
- μπαίνει αρνητικό rate
- επηρεάζει το `LowLimitInventoryProfile`
- ελέγχεται για discharge/supply rate και low inventory amount
​
### Output stream
​
Το output stream σημαίνει ότι το operation κάνει deposit στο storage.
​
Άρα:
- μπαίνει θετικό rate
- επηρεάζει το `HighLimitInventoryProfile`
- ελέγχεται για receiving rate και high inventory amount
​
Αν υπάρχει QA ή expiration:
- δημιουργούνται και έξτρα instantaneous intervals
- ένα για QA completion
- ένα για expiration
​
Άρα ένα operation μπορεί να βάλει περισσότερα από ένα inventory intervals στο profile.
​
## Actual vs available amount
​
Το inventory model ξεχωρίζει:
- actual inventory amount
- available inventory amount
​
Για αυτό το `AddInventoryUse(...)` δέχεται `AmountType`.
​
Ενδεικτικά:
- `IncludeActualOnly`
- `IncludeAvailableOnly`
- `IncludeAll`
​
Αυτό χρειάζεται επειδή μία ποσότητα με QA δεν είναι αμέσως available, αν και είναι actual inventory.
​
## Final inventory profile
​
Το `GetFinalInventoryProfile()` δεν επιστρέφει απλώς τα raw overlaps. Παράγει τελικό amount trajectory.
​
Έχει 2 διαφορετικά modes:
- continuous external transfer mode
- calendar / periodic mode
​
Σε continuous mode:
- το profile μπορεί να ενεργοποιεί automatic transfer event όταν το amount πέσει/ξεπεράσει thresholds
- χρησιμοποιεί `onAmount`, `offAmount`, `continuousTransferRate`
​
Σε calendar mode:
- χειρίζεται τα fill/empty calendar events και τα amount transitions με βάση τα merged intervals
​
Άρα το τελικό inventory state είναι αποτέλεσμα simulation-like processing, όχι απλού summation.
​
## Conflicts που βγάζει
​
Το scheduling flow βγάζει 3 βασικές κατηγορίες storage conflicts:
- `StorageUnitOveruse`
- `StorageUnitInventory`
- `StorageUnitBatchIntegrity`
​
### StorageUnitOveruse
​
Αφορά rate limits:
- reception rate limit για positive receiving rates
- supply rate limit για negative discharging rates
​
Δηλαδή, ακόμα κι αν το τελικό amount δεν χτυπάει high/low limit, μπορεί να υπάρχει conflict επειδή ο στιγμιαίος ρυθμός μεταφοράς είναι πολύ μεγάλος.
​
### StorageUnitInventory
​
Αφορά amount violations:
- πάνω από `HighInventoryLimitAmount`
- κάτω από `LowInventoryLimitAmount`
​
Το system δεν ελέγχει απλώς σε ένα point. Βρίσκει και το χρονικό interval της παραβίασης μέσω:
- `GetHighAmountLimitViolation(...)`
- `GetLowAmountLimitViolation(...)`
​
### StorageUnitBatchIntegrity
​
Αν το storage unit απαιτεί batch integrity:
- και στο τελικό profile υπάρχουν `ContributingBatches.Count > 1`
- βγαίνει conflict mixing
​
## Breaks
​
Τα inventories δεν δουλεύουν με τον ίδιο τρόπο με τα [consumables](obsidian://open?vault=Notebook&file=Notes%2FIntelligen%2FDocumentation%2FConsumables%20Uses) ούτε με τον ίδιο τρόπο με τα [reusables](obsidian://open?vault=Notebook&file=Notes%2FIntelligen%2FDocumentation%2FReusables%20Uses).
​
Όταν μπαίνει ένα stream στο scheduling flow:
- ο scheduler παίρνει `OperationEntry.GetIntervals()`
- προσθέτει inventory uses μόνο για τα `IsWorking` intervals
​
Άρα:
- τα breaks δεν γίνονται ξεχωριστό storage conflict type
- απλώς δεν προστίθεται transfer κατά τη διάρκεια του non-working interval
​
Πρακτικά, σε ένα break το storage δεν έχει receiving/discharging από εκείνο το operation.
​
## Relationship με charts
​
Για material charts υπάρχει και το `CalculateMaterialProfile(...)` που χρησιμοποιεί `ConsumablesUse`.
​
Για storage inventory chart όμως υπάρχει ξεχωριστό `CalculateInventoryProfile(...)` με `InventoryProfile`.
​
Αυτό επιβεβαιώνει ότι:
- material flow profile != storage inventory profile
​
Το πρώτο είναι rate-oriented.
Το δεύτερο είναι amount-and-transfer-oriented.
​
## Παράδειγμα
​
Έστω storage unit με:
- high limit = 100
- low limit = 20
- opening inventory = 50
​
Και operation streams:
- OpA output στο storage: +30 από 10:00 έως 11:00
- OpB input από το storage: -40 από 10:30 έως 11:30
​
Το system δεν θα κάνει μόνο ένα merged rate graph. Θα κρατήσει transfers, θα υπολογίσει amount evolution και μετά θα ελέγξει:
- αν το receiving/discharging rate ξεπερνάει τα όρια
- αν το συνολικό amount πηγαίνει πάνω από 100 ή κάτω από 20
- αν η available ποσότητα διαφέρει από την actual λόγω QA
​
## Πρακτικό mental model
​
Χρησιμοποίησε `InventoryUse` όταν η ερώτηση είναι:
- "πόση ποσότητα θα υπάρχει στο storage σε κάθε σημείο;"
- "είναι available ή μόνο actual;"
- "θα χτυπήσω low/high inventory limits;"
- "θα έχω reception/supply overuse;"
- "μπλέκονται διαφορετικά batches;"
​
Αν το πρόβλημα είναι storage state, amounts, QA, expiration, transfer calendars ή batch integrity, τότε το σωστό model είναι το `InventoryUse`.
​
## Links
