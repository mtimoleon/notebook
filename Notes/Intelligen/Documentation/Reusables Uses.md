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
Το `ReusablesUse` είναι το interval model για resources που αντιμετωπίζονται ως "occupancy" και όχι ως "rate". Ο scheduler δεν ρωτά "πόσο rate τρέχει;" αλλά "πόσα tasks κρατάνε το ίδιο resource την ίδια στιγμή;".
​
Κεντρικά παραδείγματα:
- equipment
- aux equipment
- staff
​
Βασικό class path:
​
```text
Interval<T>
└── RateUse<T>
    └── ResourceUse<T>
        └── ReusablesUse
```
​
## Τι κρατάει
​
Το `ReusablesUse` κρατά:
- `Tasks : List<ProcOpUseTask>`
- outage info μέσω `LatestOutage` / `IsOutage` από τη βάση
​
Το `ProcOpUseTask` κρατά:
- `ProcOpTask`
- `IsWorking`
- `OperationEntry`
​
Το `IsWorking` είναι σημαντικό γιατί τα breaks δεν αντιμετωπίζονται ως ξεχωριστό resource type. Αντίθετα, το ίδιο operation σπάει σε working / non-working intervals και αυτό περνάει μέσα στα reusable intervals.
​
## Ποια είναι η σημασιολογία
​
Το model είναι occupancy-based:
- κάθε task μετράει ως 1 use
- το `requiredRate` στο reusable path σημαίνει πρακτικά "πόσα concurrent uses χρειάζομαι"
- για equipment/staff το σύστημα συνήθως ψάχνει με `requiredRate = 1`
​
Άρα το conflict criterion είναι:
​
```text
active lower-precedence uses + required uses > MaxUses
```
​
## Πώς γίνεται το timeline
​
Το `IntervalList.AddInterval(...)` σπάει τα overlaps σε ομοιογενή κομμάτια. Για reusable resource:
​
```text
OpA: 10:00-12:00
OpB: 11:00-13:00
​
10:00-11:00 -> [OpA]
11:00-12:00 -> [OpA, OpB]
12:00-13:00 -> [OpB]
```
​
Σε αυτό το μοντέλο δεν υπάρχει `sum(rate)`. Υπάρχει `count(tasks)`.
​
## Πώς γεμίζει από το scheduling flow
​
Για aux equipment και staff, το scheduler παίρνει τα `OperationEntry.GetIntervals()` και δημιουργεί `ReusablesUse` για κάθε υποδιάστημα:
​
```text
OperationEntry interval
-> ReusablesUse(start, end, task, isWorking)
-> AddIntervalRange(...)
```
​
Σημασία έχει ότι το `GetIntervals()` δίνει:
- working intervals
- break intervals
​
Οπότε το reusable profile ξέρει πότε ένα operation όντως χρησιμοποιεί το resource και πότε είναι σε break.
​
## Breaks και outages
​
Εδώ βρίσκεται η μεγαλύτερη διαφορά από τα consumables.
​
Αν ένα operation έχει:
- work 10:00-11:30
- break 11:30-12:00
- work 12:00-14:00
​
τότε για ένα equipment θα μπουν 3 intervals:
​
```text
10:00-11:30 -> task, isWorking=true
11:30-12:00 -> task, isWorking=false
12:00-14:00 -> task, isWorking=true
```
​
Αν πέσει outage πάνω σε break interval:
- το interval έχει `IsOutage = true`
- το task έχει `IsWorking = false`
- το outage conflict logic το αγνοεί
​
Άρα:
- break = εσωτερικό non-working κομμάτι της operation
- outage = εξωτερικός περιορισμός του resource
​
Και το reusable path ξέρει να τα συνδυάζει.
​
## Slot finding
​
Τα reusable resources χρησιμοποιούν `ReusablesProfile`, το οποίο κληρονομεί από το generic `ResourceProfile<TInterval>`.
​
Το slot-finding:
- ελέγχει overlap ανά interval
- ρωτά `CanAccommodateUse(...)`
- λαμβάνει υπόψη `OperationOutageBehavior`
- μπορεί να επιτρέπει breaks πάνω σε outage ανάλογα με:
  - `maxTotalBreakTime`
  - `maxBreakInstances`
  - `minTimeBetweenBreaks`
​
Το mental model είναι:
- overlap με άλλα tasks higher priority -> δεν χωράει
- overlap με outage -> ίσως χωράει ως "dirty slot", ανάλογα με outage behavior
​
## Conflicts που βγάζει
​
Για reusables το scheduling flow βγάζει κυρίως:
- overuse conflicts
- outage conflicts
- για aux equipment και compatibility conflicts
​
Παραδείγματα conflict types:
- `AuxEquipmentOveruse`
- `StaffOveruse`
- `MainAuxEquipmentIncompatibility`
- `AuxEquipmentOutage`
- `StaffOutage`
​
## Πρακτικό mental model
​
Χρησιμοποίησε `ReusablesUse` όταν η ερώτηση είναι:
- "μπορούν 2 operations να κρατάνε το ίδιο equipment μαζί;"
- "μπορεί ο ίδιος άνθρωπος να είναι σε 2 places την ίδια ώρα;"
- "σε break, το operation έχει ακόμα conflict με outage;"
​
Αν η απάντηση πρέπει να βγει με concurrent occupancy, τότε το σωστό model είναι το `ReusablesUse`.
​

## Links
