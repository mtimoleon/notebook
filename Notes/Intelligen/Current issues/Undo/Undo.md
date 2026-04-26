---
categories:
  - "[[Work]]"
created: 2026-02-14
tags:
  - issues/intelligen
status: open
product: scpCloud
component:
ticket:
---
[[Undo-research]]

### Use a history schema

Keep versions of the full scheduling board.
O στόχος είναι **replace** ενός entity από snapshot
	- dbo schema με κανονικά δεδομένα
	- history schema με "ιστορικά στιγμιότυπα" των entities
	- MemoryCache που κρατά το τρέχον entity

Possible **implications**:
	1. Τα Id είναι auto-increment στο dbo
         Άρα αν πας να "επαναφέρεις" ένα entity από history, δεν μπορείς να ξαναχρησιμοποιήσεις το ίδιο Id **αν υπάρχει ήδη**.
     2. Τα FK entities μπορεί να έχουν διαγραφεί
        Αν π.χ. ένα entity A έχει FK -\> B, και το B έχει διαγραφεί από το dbo, τότε κατά την αποκατάσταση δεν θα μπορείς να κάνεις attach/reference.

#### Πιθανές Στρατηγικές

##### ==1. Τα ιστορικά entities κρατούν το Id, αλλά αυτό δεν χρησιμοποιείται για insert==
**Στον history schema:**

- Κρατάς τα Id, FK Ids, και όλα τα navigation properties _όπως ήταν_.
- Οπότε είναι **read-only snapshots**.

**Κατά το Undo:**

- Παίρνεις το entity από history
- **ΔΕΝ** επαναφέρεις το Id
- Κάνεις:
```
original.Id = 0;
context.Entry(original).State = EntityState.Added;
```
ή
```
var restored = mapper.Map\<OriginalEntity\>(historyEntity);
restored.Id = 0;
dboContext.Add(restored);
```

Αν χρησιμοποιείς ==AutoMapper, χρησιμοποίησε projection== χωρίς να μεταφέρεις το Id.

##### 2. Πριν το undo, ελέγχεις αν τα related entities υπάρχουν

- Αν κάποιο related entity (π.χ. CategoryId) έχει σβηστεί, είτε:
    - Το ξαναδημιουργείς από το history (αν έχεις snapshot του)
    - Ή καθαρίζεις το FK field και αφήνεις null (αν επιτρέπεται)

##### 3. Εναλλακτικά: χρησιμοποιείς soft deletes
Αν έχεις soft delete (π.χ. IsDeleted flag) αντί για hard delete, τότε τα related entities παραμένουν στο dbo, άρα μπορείς να τα κάνεις restore χωρίς conflict.

**🏗️** **Παράδειγμα: Restore Entity από history**
 ```csharp
var historyEntity = historyContext.Entities.Find(historyId);

// Detach from history context
historyContext.Entry(historyEntity).State = EntityState.Detached;

// Create new copy
var restored = new OriginalEntity
{
 // manually copy fields, excluding ID
 Name = historyEntity.Name,
 CategoryId = historyEntity.CategoryId,
 // ...
};

dboContext.Entities.Add(restored);
await dboContext.SaveChangesAsync();
 ```


**Προσοχή στα εξής**

1. **Validation των FK πριν restore**
	Αν restored.CategoryId δείχνει σε κατηγορία που έχει διαγραφεί, πρέπει να χειριστείς την απώλεια (error ή nullify ή re-create).
2. **Consistency**
	Αν κάνεις undo ενός parent entity, αλλά child entities λείπουν, χρειάζεσαι full recursive restore.
3. **Versioning**
	Αν θέλεις πολλαπλά undo βήματα, πρόσθεσε VersionNumber ή CreatedAt στο history schema.
4. **Snapshots όχι μόνο entity αλλά και relations**
	Αν κάνεις restore Order, μπορεί να πρέπει να κάνεις restore και OrderItems.

####  Συμπερασματικά

- Use second context και schema
- Μην ξαναχρησιμοποιείς Id
- Στο history κράτα τα Id, αλλά μη τα ξανακάνεις insert
- Πριν restore, έλεγξε αν τα related data υπάρχουν
- Καθάρισε ή επαναδημιούργησε τα απαραίτητα relations
- Χρησιμοποίησε mapping (π.χ. AutoMapper) ή manual copy για να χτίσεις νέο entity χωρίς Id

^f32b05






