---
categories:
  - "[[Work]]"
created: 2026-02-17
tags:
  - issues/intelligen
status:
product: scpCloud
component:
ticket:
---
[[Undo]]

Το σενάριο σου είναι ουσιαστικά **complex hierarchical entity versioning με undo** για ένα **scheduling board**, όπου:

- Έχεις δομή τύπου:

Campaign
 └── Batches
	 └── ProcedureEntries
		 └── OperationEntries

- Ο χρήστης μπορεί να:
    - [ ] αλλάξει **χρονικά πεδία** (start/end time)
    - αλλάξει **resource assignment** (π.χ. FK σε άλλο resource)
    - **διαγράψει** operation entries ή procedure entries
    - μετακινήσει (reorder/shift) τμήματα

### Ανάλυση τύπου αλλαγών
Αυτό που έχει σημασία είναι ότι το Undo πρέπει να δουλεύει:

- σε **ολόκληρη δομή** (batch μαζί με procedure/operations)
- σε **συγκεκριμένο σημείο στο χρόνο** (σαν snapshot)
- με **σχέσεις μεταξύ entities** (όχι flat row-level restore)

### Καταλληλότερη τεχνική για Undo

**Full Hierarchical Snapshot ανά scheduling board**

Η **ενδεικνυόμενη τεχνική** είναι:

![[Undo#^f32b05]]


#### Undo Flow (full)

##### Steps for test

- [ ] Create board → S0
- [ ] Persist current(S0)
- [ ] Read current → C0, assert C0 == S0
- [ ] Create history entry from S0 → H0, Persist history(H0)
- [ ] Apply updates/schedule → S1
- [ ] Persist current(S1)
- [ ] Read current → C1, assert C1 == S1
- [ ] Read history(H0) → HR0, assert HR0 == S0
- [ ] Restore from historyId=H0 (ή from HR0) → current becomes S2
- [ ] Persist current(S2)
- [ ] Read current → C2, assert C2 == S0, and assert C2 != S1

- [ ] Update test with the proper comments/steps
- [ ] Fix the error below so test can run

**Response about the error on running the test**
This isn’t coming from `Undo_simple_restore()` yet — the test host fails to build the **HistoryDbContext model** during `PlanningApiWebApplicationFactory` startup.

- Your stack shows the crash at `PlanningApiWebApplicationFactory.cs:123`, which is `historyDbContext.Database.EnsureDeleted();` (not the planning db).
- In `HistoryDbContext`, `BatchHistoryConfig` ignores `DependencyGraph` but **does not ignore** `ReverseStartOnlyDependencyGraph`, so EF tries to map the whole dependency graph object model and eventually treats `Dependency<OperationEntry>` as an entity and can’t bind its ctor params `type`/`node`.

Where to see it:
- `Services/Planning/Planning.Infrastructure/HistoryDbContext.cs:393` (`BatchHistoryConfig`)
- Missing ignore next to the existing one at `Services/Planning/Planning.Infrastructure/HistoryDbContext.cs:410`

(Separate issue: `Undo_simple_restore()` also currently references `storedHistoryCampaign` without defining it at `Tests/Planning.FunctionalTests/SchedulingBoardTests.cs:6018`, so even after the host starts, the test won’t compile/run cleanly.)


![[Drawing 2026-02-17 13.03.32.excalidraw]]












