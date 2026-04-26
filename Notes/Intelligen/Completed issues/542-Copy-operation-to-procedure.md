---
categories:
  - "[[Work]]"
created: 2026-03-06
product: scpCloud
component:
status: completed
tags:
  - issues/intelligen
---

## Context

Modal με duplicate/move
name by default to palio onoma Copy
se poio procedure tha paei
checkbox remove source

duplicate mono me operationId  den epistrefei tpt mono success
move me operationId, procedureId, ct, den epistrefei tpt mono success 'move-to-procedure'
## Notes

Add IManyToMany here so in cloning takes care references

![[542-Copy-operation-to-procedure-20260312 1.png|696]]


Alternative solution that solves the deps deletion from EF during procedure update.
```
_context.Entry(sourceOperation).State = EntityState.Detached;

Procedure sourceProcedure = sourceOperation.Procedure;
sourceProcedure.RemoveOperation(sourceOperation);

_context.Entry(sourceProcedure).Property("ConcurrencyToken").OriginalValue =
	command.OperationMoveToProcedureDto.SourceProcedureConcurrencyToken;
_context.Update(sourceProcedure);

_context.Attach(sourceOperation);

targetProcedure.AddOperation(sourceOperation, operationName);

_context.Entry(targetProcedure).Property("ConcurrencyToken").OriginalValue =
	command.OperationMoveToProcedureDto.TargetProcedureConcurrencyToken;
_context.Update(targetProcedure);
```


Με βάση τον κώδικά σου, τα `Clone(resetId: ...)` και `CopyFrom(...)` **δεν είναι ισοδύναμα** — έχουν άλλη πρόθεση και (πολύ σημαντικό) άλλες παρενέργειες λόγω reflection.
**Τι κάνει ποιοτικά το `Clone(resetId)` (Planning.Domain.Helpers.CloneExtension.Clone)**
- Φτιάχνει **νέο instance** του ίδιου runtime type (`Activator.CreateInstance`).
- Αντιγράφει **όλες τις writable properties**.
  - `ValueObject` → παίρνει `GetCopy()`.
  - `IDeepCopy` → κάνει `Clone(true)`.
  - Άλλες κλάσεις με setter → τις αντιγράφει **by reference** (δηλ. κρατάει ίδιες αναφορές).
- Για private fields `List<>`:
  - Αν τα items είναι `IManyToMany` → κλωνοποιεί items και **ξαναδένει OwnerReference/OwnerReferenceId** στο νέο owner (σωστό για `OperationInputStream/OutputStream`, `OperationLabor<T>`, `OperationStaff<T>`, `OperationEquipment<T>` κλπ).
  - Για άλλα lists (π.χ. `Operation._additionalSchedulingLinks`) → τα κλωνοποιεί επίσης, **αλλά χωρίς ειδικό remap** των references (άρα κινδυνεύεις να μείνουν links που “δείχνουν” σε λάθος operations).
**Τι κάνει ποιοτικά το `CopyFrom` (CloneExtension.CopyFrom)**
- Δεν δημιουργεί νέο αντικείμενο: **μεταλλάσσει** ένα ήδη υπάρχον instance.
- Αντιγράφει επίσης **ό,τι έχει setter** (ακόμα και με `private set`) ⇒ αυτό είναι το μεγάλο “αγκάθι”.
- Για `IManyToMany` lists: κάνει clear και ξαναφτιάχνει items, δένοντας OwnerReference/Id στο “input” (καλό).
- Για “άλλα” lists: **δεν τα ξαναχτίζει**, απλά κάνει `list[i].CopyFrom(backupList[i])` μέχρι `list.Count` ⇒ αν το target είναι καινούριο/άδειο, πρακτικά δεν αντιγράφονται.



## Links