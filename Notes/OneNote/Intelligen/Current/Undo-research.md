### 1. Full Snapshot-Based Undo

- **Περιγραφή**: Κάθε φορά που γίνεται σημαντική αλλαγή, κρατάς ολόκληρο αντίγραφο της οντότητας στο history schema.
- **Πλεονεκτήματα**:
    - Απλό σε εφαρμογή
    - Περιέχει ολόκληρη την εικόνα (σχεδόν πάντα "επαναφέρσιμη")
- **Μειονεκτήματα**:
    - Χρησιμοποιεί πολύ αποθηκευτικό χώρο
    - Δεν είναι βέλτιστο για συχνές μικρές αλλαγές
 
### 2. Incremental Change Tracking (Διαφορές πεδίων / Deltas)

- **Περιγραφή**: Αντί να αποθηκεύεις ολόκληρη την εγγραφή, κρατάς μόνο **τι άλλαξε** (field name, παλιά τιμή, timestamp).
- **Παράδειγμα**:
	{ "Entity": "Product", "EntityId": 42, "Field": "Price", "OldValue": "10.00", "NewValue": "15.00", "ChangedAt": "2025-06-24" }
- **Υλοποίηση**:
    - Custom AuditLog table
    - Ή Entity Framework ChangeTracker hooks (π.χ. SaveChangesInterceptor)
- **Πλεονεκτήματα**:
    - Εξαιρετικά αποδοτικό αποθηκευτικά
    - Ιδανικό για audit και selective undo
- **Μειονεκτήματα**:
    - Undo logic είναι πιο σύνθετο (π.χ. apply all deltas in reverse)
    - Δεν υποστηρίζει καλά structural changes (π.χ. αλλαγή children collections)
 
### 3. Command Sourcing (ή Event Sourcing-light)

- **Περιγραφή**: Αποθηκεύεις τις εντολές/επεξεργασίες που έγιναν (π.χ. "Product renamed", "Price changed to X")
- **Παράδειγμα**:
	{ "Command": "UpdatePrice", "Entity": "Product", "Id": 42, "Value": 15.00 }
- **Πλεονεκτήματα**:
    - Πολύ καλό για επανάληψη ή επανεφαρμογή αλλαγών
    - Ιστορικό αλλαγών εντοπισμένο στις πραγματικές business εντολές
- **Μειονεκτήματα**:
    - Θέλει δικό του pattern (CQRS, event replay)
    - Δεν είναι πάντα καθαρό το reverse ενός command
 
### 4. Temporal Tables (SQL Server)

- **Περιγραφή**: SQL Server υποστηρίζει **system-versioned temporal tables**, όπου κάθε αλλαγή κρατά snapshot στον ίδιο πίνακα (με system columns για valid time range).
- **Πλεονεκτήματα**:
    - Native SQL Server υποστήριξη
    - Μπορείς με ένα query να πεις "πώς ήταν αυτό το row την 01/01/2024"
- **Μειονεκτήματα**:
    - Λειτουργεί σε επίπεδο raw rows, όχι πλήρως συνδεδεμένων entities
    - Όχι undo, αλλά "πες μου πώς ήταν τότε"
 
### 5. Memento Pattern (In-memory Undo only)

- **Περιγραφή**: Καταγράφεις το προηγούμενο state στο memory cache πριν αλλάξει το object, μόνο για runtime undo (π.χ. UI changes ή draft changes).
- **Πλεονεκτήματα**:
    - Εύκολο, lightweight
    - Ιδανικό για προσωρινές αλλαγές
- **Μειονεκτήματα**:
    - Δεν επιβιώνει restart ή crash
    - Δεν προσφέρει persistence/ιστορικό
 
### 6. Audit Log + Rehydrate (Hybrid)

- **Περιγραφή**: Κρατάς audit log με field-level changes αλλά έχεις δυνατότητα να "χτίσεις" το entity πίσω στο παλιό state με aggregation.
- **Χρήσιμο για**:
    - Business-critical audit trails
    - Selective revert (π.χ. μόνο Price πίσω στο προηγούμενο)
 
**Επιλογή Τεχνικής Ανάλογα με Use Case**

| **Χαρακτηριστικά**     | **Κατάλληλη Τεχνική**                 |
| ---------------------- | ------------------------------------- |
| Πλήρες Undo με Restore | Full Snapshot (ιστορικό schema)       |
| Περιορισμένος χώρος    | Incremental (Διαφορές ανά πεδίο)      |
| Χρειάζεσαι audit trail | Audit Log ή Temporal Tables           |
| Business Events (DDD)  | Command ή Event Sourcing              |
| In-memory Undo στο UI  | Memento Pattern / Memory Cache        |
| Selective undo         | Audit + Rehydrate ή Hybrid με mapping |
   

Το σενάριο σου είναι ουσιαστικά **complex hierarchical entity versioning με undo** για ένα **scheduling board**, όπου:

- Έχεις δομή τύπου:

Campaign
 └── Batches
	 └── ProcedureEntries
		 └── OperationEntries

- Ο χρήστης μπορεί να:
    - αλλάξει **χρονικά πεδία** (start/end time)
    - αλλάξει **resource assignment** (π.χ. FK σε άλλο resource)
    - **διαγράψει** operation entries ή procedure entries
    - μετακινήσει (reorder/shift) τμήματα
 
### Ανάλυση τύπου αλλαγών
Αυτό που έχει σημασία είναι ότι το Undo πρέπει να δουλεύει:

- σε **ολόκληρη δομή** (batch μαζί με procedure/operations)
- σε **συγκεκριμένο σημείο στο χρόνο** (σαν snapshot)
- με **σχέσεις μεταξύ entities** (όχι flat row-level restore)
 
### Καταλληλότερη τεχνική για Undo  
**Full Hierarchical Snapshot ανά Batch (ή Campaign)**  
Η **ενδεικνυόμενη τεχνική** είναι:

- **κάθε φορά που ο χρήστης κάνει commit σε αλλαγές layout**, να αποθηκεύεις **ολόκληρο το υποδέντρο****
**π.χ. Campaign + Batches + ProcedureEntries + OperationEntries σε ένα versioned snapshot στο history schema

Μπορείς να έχεις:

- CampaignSnapshot
    - με navigation BatchesSnapshot
        - ProcedureEntriesSnapshot
            - OperationEntriesSnapshot

Και να έχεις:

- SnapshotId ή VersionNumber
- CreatedBy, CreatedAt
- SourceCampaignId για αναφορά
 
##### **➕** Προαιρετικά:  
Αν θες να μειώσεις χώρο:

- **Serialize την ιεραρχία σε JSON** (π.χ. nvarchar(max) column)
    - π.χ. JsonSerializedCampaignSnapshot
    - Με χρήση System.Text.Json ή Newtonsoft.Json
- Έτσι το undo γίνεται:
    - deserialize -\> map to new entities -\> save to dbo context
 
#### Undo Flow (πλήρες)

1. **Ο χρήστης κάνει αλλαγές στο scheduling board**
2. Πριν αποθηκεύσεις (ή κατά το save), αποθηκεύεις snapshot στο history schema: 4. Όταν ζητήσει undo:
    - φέρνεις το τελευταίο snapshot
    - κάνεις deserialize
    - αντικαθιστάς την τρέχουσα κατάσταση με την αποθηκευμένη (μπορείς να σβήσεις τα current και να κάνεις insert από το snapshot)
	
		```csharp
		var snapshot = new CampaignSnapshot
		{
		 SourceCampaignId = campaign.Id,
		 CreatedAt = DateTime.UtcNow,
		 SnapshotJson = JsonSerializer.Serialize(campaign)
		};
		historyContext.CampaignSnapshots.Add(snapshot);
		await historyContext.SaveChangesAsync();
		```
3. Όταν ζητήσει undo:
		○ φέρνεις το τελευταίο snapshot
		○ κάνεις deserialize
		○ αντικαθιστάς την τρέχουσα κατάσταση με την αποθηκευμένη (μπορείς να σβήσεις τα current και να κάνεις insert από το snapshot)


##### Πλεονεκτήματα
- Δεν εξαρτάσαι από τα IDs — μπορείς να κάνεις Id = 0 για νέα inserts
- Αν έχεις navigation properties, κάνεις restore όλη τη δομή (και operation entries που μπορεί να έχουν διαγραφεί)
- Είσαι ανεξάρτητος από το σχήμα του dbo — μπορείς να αλλάξεις το schema χωρίς να σπάσεις το undo mechanism (αν έχεις JSON-based snapshots)
 
#### Εναλλακτικό: Structured Δέντρο στο **history** **schema**  
Αν θέλεις κανονικούς πίνακες (όχι JSON):

- Φτιάχνεις CampaignHistory, BatchHistory, ProcedureEntryHistory, OperationEntryHistory
- Βάζεις Version, SourceEntityId, και FK μεταξύ τους
- Χρησιμοποιείς custom restore service για rehydrate και insert στο dbo
 
**Προτεινόμενη Υλοποίηση**

- **Για απλό Undo με ελάχιστο dev overhead** → **JSON snapshot ανά Campaign**
- **Για granular audit/undo και ερωτήματα τύπου "τι άλλαξε;"** → συνδυασμός structured + field-level audit log
 
![[image-14.png|544x435]]


**Προτείνεται ακόμα και schema-level:**  
Για να βοηθάς τα queries:

- Πρόσθεσε ένα flag IsSchedulingRoot στο UndoHistoryEntry
    - true μόνο για αρχικά Schedule ή UnSchedule
    - (ή κράτα και RescheduleRootId αν θες group identifier για undo blocks)

![[image-15.png]]