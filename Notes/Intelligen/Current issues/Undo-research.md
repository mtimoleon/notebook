---
categories:
  - "[[Work]]"
  - "[[Issues]]"
created: 2025-06-24T10:24
tags:
  - intelligen
status: current
product: ScpCloud
---

### 1. Full Snapshot-Based Undo

- **Ξ ΞµΟΞΉΞ³ΟΞ±Ο†Ξ®**: ΞΞ¬ΞΈΞµ Ο†ΞΏΟΞ¬ Ο€ΞΏΟ… Ξ³Ξ―Ξ½ΞµΟ„Ξ±ΞΉ ΟƒΞ·ΞΌΞ±Ξ½Ο„ΞΉΞΊΞ® Ξ±Ξ»Ξ»Ξ±Ξ³Ξ®, ΞΊΟΞ±Ο„Ξ¬Ο‚ ΞΏΞ»ΟΞΊΞ»Ξ·ΟΞΏ Ξ±Ξ½Ο„Ξ―Ξ³ΟΞ±Ο†ΞΏ Ο„Ξ·Ο‚ ΞΏΞ½Ο„ΟΟ„Ξ·Ο„Ξ±Ο‚ ΟƒΟ„ΞΏ history schema.
- **Ξ Ξ»ΞµΞΏΞ½ΞµΞΊΟ„Ξ®ΞΌΞ±Ο„Ξ±**:
    - Ξ‘Ο€Ξ»Ο ΟƒΞµ ΞµΟ†Ξ±ΟΞΌΞΏΞ³Ξ®
    - Ξ ΞµΟΞΉΞ­Ο‡ΞµΞΉ ΞΏΞ»ΟΞΊΞ»Ξ·ΟΞ· Ο„Ξ·Ξ½ ΞµΞΉΞΊΟΞ½Ξ± (ΟƒΟ‡ΞµΞ΄ΟΞ½ Ο€Ξ¬Ξ½Ο„Ξ± "ΞµΟ€Ξ±Ξ½Ξ±Ο†Ξ­ΟΟƒΞΉΞΌΞ·")
- **ΞΞµΞΉΞΏΞ½ΞµΞΊΟ„Ξ®ΞΌΞ±Ο„Ξ±**:
    - Ξ§ΟΞ·ΟƒΞΉΞΌΞΏΟ€ΞΏΞΉΞµΞ― Ο€ΞΏΞ»Ο Ξ±Ο€ΞΏΞΈΞ·ΞΊΞµΟ…Ο„ΞΉΞΊΟ Ο‡ΟΟΞΏ
    - Ξ”ΞµΞ½ ΞµΞ―Ξ½Ξ±ΞΉ Ξ²Ξ­Ξ»Ο„ΞΉΟƒΟ„ΞΏ Ξ³ΞΉΞ± ΟƒΟ…Ο‡Ξ½Ξ­Ο‚ ΞΌΞΉΞΊΟΞ­Ο‚ Ξ±Ξ»Ξ»Ξ±Ξ³Ξ­Ο‚
 
### 2. Incremental Change Tracking (Ξ”ΞΉΞ±Ο†ΞΏΟΞ­Ο‚ Ο€ΞµΞ΄Ξ―Ο‰Ξ½ / Deltas)

- **Ξ ΞµΟΞΉΞ³ΟΞ±Ο†Ξ®**: Ξ‘Ξ½Ο„Ξ― Ξ½Ξ± Ξ±Ο€ΞΏΞΈΞ·ΞΊΞµΟΞµΞΉΟ‚ ΞΏΞ»ΟΞΊΞ»Ξ·ΟΞ· Ο„Ξ·Ξ½ ΞµΞ³Ξ³ΟΞ±Ο†Ξ®, ΞΊΟΞ±Ο„Ξ¬Ο‚ ΞΌΟΞ½ΞΏ **Ο„ΞΉ Ξ¬Ξ»Ξ»Ξ±ΞΎΞµ** (field name, Ο€Ξ±Ξ»ΞΉΞ¬ Ο„ΞΉΞΌΞ®, timestamp).
- **Ξ Ξ±ΟΞ¬Ξ΄ΞµΞΉΞ³ΞΌΞ±**:
	{ "Entity": "Product", "EntityId": 42, "Field": "Price", "OldValue": "10.00", "NewValue": "15.00", "ChangedAt": "2025-06-24" }
- **Ξ¥Ξ»ΞΏΟ€ΞΏΞ―Ξ·ΟƒΞ·**:
    - Custom AuditLog table
    - Ξ‰ Entity Framework ChangeTracker hooks (Ο€.Ο‡. SaveChangesInterceptor)
- **Ξ Ξ»ΞµΞΏΞ½ΞµΞΊΟ„Ξ®ΞΌΞ±Ο„Ξ±**:
    - Ξ•ΞΎΞ±ΞΉΟΞµΟ„ΞΉΞΊΞ¬ Ξ±Ο€ΞΏΞ΄ΞΏΟ„ΞΉΞΊΟ Ξ±Ο€ΞΏΞΈΞ·ΞΊΞµΟ…Ο„ΞΉΞΊΞ¬
    - Ξ™Ξ΄Ξ±Ξ½ΞΉΞΊΟ Ξ³ΞΉΞ± audit ΞΊΞ±ΞΉ selective undo
- **ΞΞµΞΉΞΏΞ½ΞµΞΊΟ„Ξ®ΞΌΞ±Ο„Ξ±**:
    - Undo logic ΞµΞ―Ξ½Ξ±ΞΉ Ο€ΞΉΞΏ ΟƒΟΞ½ΞΈΞµΟ„ΞΏ (Ο€.Ο‡. apply all deltas in reverse)
    - Ξ”ΞµΞ½ Ο…Ο€ΞΏΟƒΟ„Ξ·ΟΞ―Ξ¶ΞµΞΉ ΞΊΞ±Ξ»Ξ¬ structural changes (Ο€.Ο‡. Ξ±Ξ»Ξ»Ξ±Ξ³Ξ® children collections)
 
### 3. Command Sourcing (Ξ® Event Sourcing-light)

- **Ξ ΞµΟΞΉΞ³ΟΞ±Ο†Ξ®**: Ξ‘Ο€ΞΏΞΈΞ·ΞΊΞµΟΞµΞΉΟ‚ Ο„ΞΉΟ‚ ΞµΞ½Ο„ΞΏΞ»Ξ­Ο‚/ΞµΟ€ΞµΞΎΞµΟΞ³Ξ±ΟƒΞ―ΞµΟ‚ Ο€ΞΏΟ… Ξ­Ξ³ΞΉΞ½Ξ±Ξ½ (Ο€.Ο‡. "Product renamed", "Price changed to X")
- **Ξ Ξ±ΟΞ¬Ξ΄ΞµΞΉΞ³ΞΌΞ±**:
	{ "Command": "UpdatePrice", "Entity": "Product", "Id": 42, "Value": 15.00 }
- **Ξ Ξ»ΞµΞΏΞ½ΞµΞΊΟ„Ξ®ΞΌΞ±Ο„Ξ±**:
    - Ξ ΞΏΞ»Ο ΞΊΞ±Ξ»Ο Ξ³ΞΉΞ± ΞµΟ€Ξ±Ξ½Ξ¬Ξ»Ξ·ΟΞ· Ξ® ΞµΟ€Ξ±Ξ½ΞµΟ†Ξ±ΟΞΌΞΏΞ³Ξ® Ξ±Ξ»Ξ»Ξ±Ξ³ΟΞ½
    - Ξ™ΟƒΟ„ΞΏΟΞΉΞΊΟ Ξ±Ξ»Ξ»Ξ±Ξ³ΟΞ½ ΞµΞ½Ο„ΞΏΟ€ΞΉΟƒΞΌΞ­Ξ½ΞΏ ΟƒΟ„ΞΉΟ‚ Ο€ΟΞ±Ξ³ΞΌΞ±Ο„ΞΉΞΊΞ­Ο‚ business ΞµΞ½Ο„ΞΏΞ»Ξ­Ο‚
- **ΞΞµΞΉΞΏΞ½ΞµΞΊΟ„Ξ®ΞΌΞ±Ο„Ξ±**:
    - ΞΞ­Ξ»ΞµΞΉ Ξ΄ΞΉΞΊΟ Ο„ΞΏΟ… pattern (CQRS, event replay)
    - Ξ”ΞµΞ½ ΞµΞ―Ξ½Ξ±ΞΉ Ο€Ξ¬Ξ½Ο„Ξ± ΞΊΞ±ΞΈΞ±ΟΟ Ο„ΞΏ reverse ΞµΞ½ΟΟ‚ command
 
### 4. Temporal Tables (SQL Server)

- **Ξ ΞµΟΞΉΞ³ΟΞ±Ο†Ξ®**: SQL Server Ο…Ο€ΞΏΟƒΟ„Ξ·ΟΞ―Ξ¶ΞµΞΉ **system-versioned temporal tables**, ΟΟ€ΞΏΟ… ΞΊΞ¬ΞΈΞµ Ξ±Ξ»Ξ»Ξ±Ξ³Ξ® ΞΊΟΞ±Ο„Ξ¬ snapshot ΟƒΟ„ΞΏΞ½ Ξ―Ξ΄ΞΉΞΏ Ο€Ξ―Ξ½Ξ±ΞΊΞ± (ΞΌΞµ system columns Ξ³ΞΉΞ± valid time range).
- **Ξ Ξ»ΞµΞΏΞ½ΞµΞΊΟ„Ξ®ΞΌΞ±Ο„Ξ±**:
    - Native SQL Server Ο…Ο€ΞΏΟƒΟ„Ξ®ΟΞΉΞΎΞ·
    - ΞΟ€ΞΏΟΞµΞ―Ο‚ ΞΌΞµ Ξ­Ξ½Ξ± query Ξ½Ξ± Ο€ΞµΞΉΟ‚ "Ο€ΟΟ‚ Ξ®Ο„Ξ±Ξ½ Ξ±Ο…Ο„Ο Ο„ΞΏ row Ο„Ξ·Ξ½ 01/01/2024"
- **ΞΞµΞΉΞΏΞ½ΞµΞΊΟ„Ξ®ΞΌΞ±Ο„Ξ±**:
    - Ξ›ΞµΞΉΟ„ΞΏΟ…ΟΞ³ΞµΞ― ΟƒΞµ ΞµΟ€Ξ―Ο€ΞµΞ΄ΞΏ raw rows, ΟΟ‡ΞΉ Ο€Ξ»Ξ®ΟΟ‰Ο‚ ΟƒΟ…Ξ½Ξ΄ΞµΞ΄ΞµΞΌΞ­Ξ½Ο‰Ξ½ entities
    - ΞΟ‡ΞΉ undo, Ξ±Ξ»Ξ»Ξ¬ "Ο€ΞµΟ‚ ΞΌΞΏΟ… Ο€ΟΟ‚ Ξ®Ο„Ξ±Ξ½ Ο„ΟΟ„Ξµ"
 
### 5. Memento Pattern (In-memory Undo only)

- **Ξ ΞµΟΞΉΞ³ΟΞ±Ο†Ξ®**: ΞΞ±Ο„Ξ±Ξ³ΟΞ¬Ο†ΞµΞΉΟ‚ Ο„ΞΏ Ο€ΟΞΏΞ·Ξ³ΞΏΟΞΌΞµΞ½ΞΏ state ΟƒΟ„ΞΏ memory cache Ο€ΟΞΉΞ½ Ξ±Ξ»Ξ»Ξ¬ΞΎΞµΞΉ Ο„ΞΏ object, ΞΌΟΞ½ΞΏ Ξ³ΞΉΞ± runtime undo (Ο€.Ο‡. UI changes Ξ® draft changes).
- **Ξ Ξ»ΞµΞΏΞ½ΞµΞΊΟ„Ξ®ΞΌΞ±Ο„Ξ±**:
    - Ξ•ΟΞΊΞΏΞ»ΞΏ, lightweight
    - Ξ™Ξ΄Ξ±Ξ½ΞΉΞΊΟ Ξ³ΞΉΞ± Ο€ΟΞΏΟƒΟ‰ΟΞΉΞ½Ξ­Ο‚ Ξ±Ξ»Ξ»Ξ±Ξ³Ξ­Ο‚
- **ΞΞµΞΉΞΏΞ½ΞµΞΊΟ„Ξ®ΞΌΞ±Ο„Ξ±**:
    - Ξ”ΞµΞ½ ΞµΟ€ΞΉΞ²ΞΉΟΞ½ΞµΞΉ restart Ξ® crash
    - Ξ”ΞµΞ½ Ο€ΟΞΏΟƒΟ†Ξ­ΟΞµΞΉ persistence/ΞΉΟƒΟ„ΞΏΟΞΉΞΊΟ
 
### 6. Audit Log + Rehydrate (Hybrid)

- **Ξ ΞµΟΞΉΞ³ΟΞ±Ο†Ξ®**: ΞΟΞ±Ο„Ξ¬Ο‚ audit log ΞΌΞµ field-level changes Ξ±Ξ»Ξ»Ξ¬ Ξ­Ο‡ΞµΞΉΟ‚ Ξ΄Ο…Ξ½Ξ±Ο„ΟΟ„Ξ·Ο„Ξ± Ξ½Ξ± "Ο‡Ο„Ξ―ΟƒΞµΞΉΟ‚" Ο„ΞΏ entity Ο€Ξ―ΟƒΟ‰ ΟƒΟ„ΞΏ Ο€Ξ±Ξ»ΞΉΟ state ΞΌΞµ aggregation.
- **Ξ§ΟΞ®ΟƒΞΉΞΌΞΏ Ξ³ΞΉΞ±**:
    - Business-critical audit trails
    - Selective revert (Ο€.Ο‡. ΞΌΟΞ½ΞΏ Price Ο€Ξ―ΟƒΟ‰ ΟƒΟ„ΞΏ Ο€ΟΞΏΞ·Ξ³ΞΏΟΞΌΞµΞ½ΞΏ)
 
**Ξ•Ο€ΞΉΞ»ΞΏΞ³Ξ® Ξ¤ΞµΟ‡Ξ½ΞΉΞΊΞ®Ο‚ Ξ‘Ξ½Ξ¬Ξ»ΞΏΞ³Ξ± ΞΌΞµ Use Case**

| **Ξ§Ξ±ΟΞ±ΞΊΟ„Ξ·ΟΞΉΟƒΟ„ΞΉΞΊΞ¬**     | **ΞΞ±Ο„Ξ¬Ξ»Ξ»Ξ·Ξ»Ξ· Ξ¤ΞµΟ‡Ξ½ΞΉΞΊΞ®**                 |
| ---------------------- | ------------------------------------- |
| Ξ Ξ»Ξ®ΟΞµΟ‚ Undo ΞΌΞµ Restore | Full Snapshot (ΞΉΟƒΟ„ΞΏΟΞΉΞΊΟ schema)       |
| Ξ ΞµΟΞΉΞΏΟΞΉΟƒΞΌΞ­Ξ½ΞΏΟ‚ Ο‡ΟΟΞΏΟ‚    | Incremental (Ξ”ΞΉΞ±Ο†ΞΏΟΞ­Ο‚ Ξ±Ξ½Ξ¬ Ο€ΞµΞ΄Ξ―ΞΏ)      |
| Ξ§ΟΞµΞΉΞ¬Ξ¶ΞµΟƒΞ±ΞΉ audit trail | Audit Log Ξ® Temporal Tables           |
| Business Events (DDD)  | Command Ξ® Event Sourcing              |
| In-memory Undo ΟƒΟ„ΞΏ UI  | Memento Pattern / Memory Cache        |
| Selective undo         | Audit + Rehydrate Ξ® Hybrid ΞΌΞµ mapping |
   

Ξ¤ΞΏ ΟƒΞµΞ½Ξ¬ΟΞΉΞΏ ΟƒΞΏΟ… ΞµΞ―Ξ½Ξ±ΞΉ ΞΏΟ…ΟƒΞΉΞ±ΟƒΟ„ΞΉΞΊΞ¬ **complex hierarchical entity versioning ΞΌΞµ undo** Ξ³ΞΉΞ± Ξ­Ξ½Ξ± **scheduling board**, ΟΟ€ΞΏΟ…:

- ΞΟ‡ΞµΞΉΟ‚ Ξ΄ΞΏΞΌΞ® Ο„ΟΟ€ΞΏΟ…:

Campaign
 β””β”€β”€ Batches
	 β””β”€β”€ ProcedureEntries
		 β””β”€β”€ OperationEntries

- Ξ Ο‡ΟΞ®ΟƒΟ„Ξ·Ο‚ ΞΌΟ€ΞΏΟΞµΞ― Ξ½Ξ±:
    - Ξ±Ξ»Ξ»Ξ¬ΞΎΞµΞΉ **Ο‡ΟΞΏΞ½ΞΉΞΊΞ¬ Ο€ΞµΞ΄Ξ―Ξ±** (start/end time)
    - Ξ±Ξ»Ξ»Ξ¬ΞΎΞµΞΉ **resource assignment** (Ο€.Ο‡. FK ΟƒΞµ Ξ¬Ξ»Ξ»ΞΏ resource)
    - **Ξ΄ΞΉΞ±Ξ³ΟΞ¬ΟΞµΞΉ** operation entries Ξ® procedure entries
    - ΞΌΞµΟ„Ξ±ΞΊΞΉΞ½Ξ®ΟƒΞµΞΉ (reorder/shift) Ο„ΞΌΞ®ΞΌΞ±Ο„Ξ±
 
### Ξ‘Ξ½Ξ¬Ξ»Ο…ΟƒΞ· Ο„ΟΟ€ΞΏΟ… Ξ±Ξ»Ξ»Ξ±Ξ³ΟΞ½
Ξ‘Ο…Ο„Ο Ο€ΞΏΟ… Ξ­Ο‡ΞµΞΉ ΟƒΞ·ΞΌΞ±ΟƒΞ―Ξ± ΞµΞ―Ξ½Ξ±ΞΉ ΟΟ„ΞΉ Ο„ΞΏ Undo Ο€ΟΞ­Ο€ΞµΞΉ Ξ½Ξ± Ξ΄ΞΏΟ…Ξ»ΞµΟΞµΞΉ:

- ΟƒΞµ **ΞΏΞ»ΟΞΊΞ»Ξ·ΟΞ· Ξ΄ΞΏΞΌΞ®** (batch ΞΌΞ±Ξ¶Ξ― ΞΌΞµ procedure/operations)
- ΟƒΞµ **ΟƒΟ…Ξ³ΞΊΞµΞΊΟΞΉΞΌΞ­Ξ½ΞΏ ΟƒΞ·ΞΌΞµΞ―ΞΏ ΟƒΟ„ΞΏ Ο‡ΟΟΞ½ΞΏ** (ΟƒΞ±Ξ½ snapshot)
- ΞΌΞµ **ΟƒΟ‡Ξ­ΟƒΞµΞΉΟ‚ ΞΌΞµΟ„Ξ±ΞΎΟ entities** (ΟΟ‡ΞΉ flat row-level restore)
 
### ΞΞ±Ο„Ξ±Ξ»Ξ»Ξ·Ξ»ΟΟ„ΞµΟΞ· Ο„ΞµΟ‡Ξ½ΞΉΞΊΞ® Ξ³ΞΉΞ± Undo  
**Full Hierarchical Snapshot Ξ±Ξ½Ξ¬ Batch (Ξ® Campaign)**  
Ξ— **ΞµΞ½Ξ΄ΞµΞΉΞΊΞ½Ο…ΟΞΌΞµΞ½Ξ· Ο„ΞµΟ‡Ξ½ΞΉΞΊΞ®** ΞµΞ―Ξ½Ξ±ΞΉ:

- **ΞΊΞ¬ΞΈΞµ Ο†ΞΏΟΞ¬ Ο€ΞΏΟ… ΞΏ Ο‡ΟΞ®ΟƒΟ„Ξ·Ο‚ ΞΊΞ¬Ξ½ΞµΞΉ commit ΟƒΞµ Ξ±Ξ»Ξ»Ξ±Ξ³Ξ­Ο‚ layout**, Ξ½Ξ± Ξ±Ο€ΞΏΞΈΞ·ΞΊΞµΟΞµΞΉΟ‚ **ΞΏΞ»ΟΞΊΞ»Ξ·ΟΞΏ Ο„ΞΏ Ο…Ο€ΞΏΞ΄Ξ­Ξ½Ο„ΟΞΏ****
**Ο€.Ο‡. Campaign + Batches + ProcedureEntries + OperationEntries ΟƒΞµ Ξ­Ξ½Ξ± versioned snapshot ΟƒΟ„ΞΏ history schema

ΞΟ€ΞΏΟΞµΞ―Ο‚ Ξ½Ξ± Ξ­Ο‡ΞµΞΉΟ‚:

- CampaignSnapshot
    - ΞΌΞµ navigation BatchesSnapshot
        - ProcedureEntriesSnapshot
            - OperationEntriesSnapshot

ΞΞ±ΞΉ Ξ½Ξ± Ξ­Ο‡ΞµΞΉΟ‚:

- SnapshotId Ξ® VersionNumber
- CreatedBy, CreatedAt
- SourceCampaignId Ξ³ΞΉΞ± Ξ±Ξ½Ξ±Ο†ΞΏΟΞ¬
 
##### **β•** Ξ ΟΞΏΞ±ΞΉΟΞµΟ„ΞΉΞΊΞ¬:  
Ξ‘Ξ½ ΞΈΞµΟ‚ Ξ½Ξ± ΞΌΞµΞΉΟΟƒΞµΞΉΟ‚ Ο‡ΟΟΞΏ:

- **Serialize Ο„Ξ·Ξ½ ΞΉΞµΟΞ±ΟΟ‡Ξ―Ξ± ΟƒΞµ JSON** (Ο€.Ο‡. nvarchar(max) column)
    - Ο€.Ο‡. JsonSerializedCampaignSnapshot
    - ΞΞµ Ο‡ΟΞ®ΟƒΞ· System.Text.Json Ξ® Newtonsoft.Json
- ΞΟ„ΟƒΞΉ Ο„ΞΏ undo Ξ³Ξ―Ξ½ΞµΟ„Ξ±ΞΉ:
    - deserialize -\> map to new entities -\> save to dbo context
 
#### Undo Flow (Ο€Ξ»Ξ®ΟΞµΟ‚)

1. **Ξ Ο‡ΟΞ®ΟƒΟ„Ξ·Ο‚ ΞΊΞ¬Ξ½ΞµΞΉ Ξ±Ξ»Ξ»Ξ±Ξ³Ξ­Ο‚ ΟƒΟ„ΞΏ scheduling board**
2. Ξ ΟΞΉΞ½ Ξ±Ο€ΞΏΞΈΞ·ΞΊΞµΟΟƒΞµΞΉΟ‚ (Ξ® ΞΊΞ±Ο„Ξ¬ Ο„ΞΏ save), Ξ±Ο€ΞΏΞΈΞ·ΞΊΞµΟΞµΞΉΟ‚ snapshot ΟƒΟ„ΞΏ history schema: 4. ΞΟ„Ξ±Ξ½ Ξ¶Ξ·Ο„Ξ®ΟƒΞµΞΉ undo:
    - Ο†Ξ­ΟΞ½ΞµΞΉΟ‚ Ο„ΞΏ Ο„ΞµΞ»ΞµΟ…Ο„Ξ±Ξ―ΞΏ snapshot
    - ΞΊΞ¬Ξ½ΞµΞΉΟ‚ deserialize
    - Ξ±Ξ½Ο„ΞΉΞΊΞ±ΞΈΞΉΟƒΟ„Ξ¬Ο‚ Ο„Ξ·Ξ½ Ο„ΟΞ­Ο‡ΞΏΟ…ΟƒΞ± ΞΊΞ±Ο„Ξ¬ΟƒΟ„Ξ±ΟƒΞ· ΞΌΞµ Ο„Ξ·Ξ½ Ξ±Ο€ΞΏΞΈΞ·ΞΊΞµΟ…ΞΌΞ­Ξ½Ξ· (ΞΌΟ€ΞΏΟΞµΞ―Ο‚ Ξ½Ξ± ΟƒΞ²Ξ®ΟƒΞµΞΉΟ‚ Ο„Ξ± current ΞΊΞ±ΞΉ Ξ½Ξ± ΞΊΞ¬Ξ½ΞµΞΉΟ‚ insert Ξ±Ο€Ο Ο„ΞΏ snapshot)
	
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
3. ΞΟ„Ξ±Ξ½ Ξ¶Ξ·Ο„Ξ®ΟƒΞµΞΉ undo:
		β—‹ Ο†Ξ­ΟΞ½ΞµΞΉΟ‚ Ο„ΞΏ Ο„ΞµΞ»ΞµΟ…Ο„Ξ±Ξ―ΞΏ snapshot
		β—‹ ΞΊΞ¬Ξ½ΞµΞΉΟ‚ deserialize
		β—‹ Ξ±Ξ½Ο„ΞΉΞΊΞ±ΞΈΞΉΟƒΟ„Ξ¬Ο‚ Ο„Ξ·Ξ½ Ο„ΟΞ­Ο‡ΞΏΟ…ΟƒΞ± ΞΊΞ±Ο„Ξ¬ΟƒΟ„Ξ±ΟƒΞ· ΞΌΞµ Ο„Ξ·Ξ½ Ξ±Ο€ΞΏΞΈΞ·ΞΊΞµΟ…ΞΌΞ­Ξ½Ξ· (ΞΌΟ€ΞΏΟΞµΞ―Ο‚ Ξ½Ξ± ΟƒΞ²Ξ®ΟƒΞµΞΉΟ‚ Ο„Ξ± current ΞΊΞ±ΞΉ Ξ½Ξ± ΞΊΞ¬Ξ½ΞµΞΉΟ‚ insert Ξ±Ο€Ο Ο„ΞΏ snapshot)


##### Ξ Ξ»ΞµΞΏΞ½ΞµΞΊΟ„Ξ®ΞΌΞ±Ο„Ξ±
- Ξ”ΞµΞ½ ΞµΞΎΞ±ΟΟ„Ξ¬ΟƒΞ±ΞΉ Ξ±Ο€Ο Ο„Ξ± IDs β€” ΞΌΟ€ΞΏΟΞµΞ―Ο‚ Ξ½Ξ± ΞΊΞ¬Ξ½ΞµΞΉΟ‚ Id = 0 Ξ³ΞΉΞ± Ξ½Ξ­Ξ± inserts
- Ξ‘Ξ½ Ξ­Ο‡ΞµΞΉΟ‚ navigation properties, ΞΊΞ¬Ξ½ΞµΞΉΟ‚ restore ΟΞ»Ξ· Ο„Ξ· Ξ΄ΞΏΞΌΞ® (ΞΊΞ±ΞΉ operation entries Ο€ΞΏΟ… ΞΌΟ€ΞΏΟΞµΞ― Ξ½Ξ± Ξ­Ο‡ΞΏΟ…Ξ½ Ξ΄ΞΉΞ±Ξ³ΟΞ±Ο†ΞµΞ―)
- Ξ•Ξ―ΟƒΞ±ΞΉ Ξ±Ξ½ΞµΞΎΞ¬ΟΟ„Ξ·Ο„ΞΏΟ‚ Ξ±Ο€Ο Ο„ΞΏ ΟƒΟ‡Ξ®ΞΌΞ± Ο„ΞΏΟ… dbo β€” ΞΌΟ€ΞΏΟΞµΞ―Ο‚ Ξ½Ξ± Ξ±Ξ»Ξ»Ξ¬ΞΎΞµΞΉΟ‚ Ο„ΞΏ schema Ο‡Ο‰ΟΞ―Ο‚ Ξ½Ξ± ΟƒΟ€Ξ¬ΟƒΞµΞΉΟ‚ Ο„ΞΏ undo mechanism (Ξ±Ξ½ Ξ­Ο‡ΞµΞΉΟ‚ JSON-based snapshots)
 
#### Ξ•Ξ½Ξ±Ξ»Ξ»Ξ±ΞΊΟ„ΞΉΞΊΟ: Structured Ξ”Ξ­Ξ½Ο„ΟΞΏ ΟƒΟ„ΞΏ **history** **schema**  
Ξ‘Ξ½ ΞΈΞ­Ξ»ΞµΞΉΟ‚ ΞΊΞ±Ξ½ΞΏΞ½ΞΉΞΊΞΏΟΟ‚ Ο€Ξ―Ξ½Ξ±ΞΊΞµΟ‚ (ΟΟ‡ΞΉ JSON):

- Ξ¦Ο„ΞΉΞ¬Ο‡Ξ½ΞµΞΉΟ‚ CampaignHistory, BatchHistory, ProcedureEntryHistory, OperationEntryHistory
- Ξ’Ξ¬Ξ¶ΞµΞΉΟ‚ Version, SourceEntityId, ΞΊΞ±ΞΉ FK ΞΌΞµΟ„Ξ±ΞΎΟ Ο„ΞΏΟ…Ο‚
- Ξ§ΟΞ·ΟƒΞΉΞΌΞΏΟ€ΞΏΞΉΞµΞ―Ο‚ custom restore service Ξ³ΞΉΞ± rehydrate ΞΊΞ±ΞΉ insert ΟƒΟ„ΞΏ dbo
 
**Ξ ΟΞΏΟ„ΞµΞΉΞ½ΟΞΌΞµΞ½Ξ· Ξ¥Ξ»ΞΏΟ€ΞΏΞ―Ξ·ΟƒΞ·**

- **Ξ“ΞΉΞ± Ξ±Ο€Ξ»Ο Undo ΞΌΞµ ΞµΞ»Ξ¬Ο‡ΞΉΟƒΟ„ΞΏ dev overhead** β†’ **JSON snapshot Ξ±Ξ½Ξ¬ Campaign**
- **Ξ“ΞΉΞ± granular audit/undo ΞΊΞ±ΞΉ ΞµΟΟ‰Ο„Ξ®ΞΌΞ±Ο„Ξ± Ο„ΟΟ€ΞΏΟ… "Ο„ΞΉ Ξ¬Ξ»Ξ»Ξ±ΞΎΞµ;"** β†’ ΟƒΟ…Ξ½Ξ΄Ο…Ξ±ΟƒΞΌΟΟ‚ structured + field-level audit log
 
![[image-14.png|544x435]]


**Ξ ΟΞΏΟ„ΞµΞ―Ξ½ΞµΟ„Ξ±ΞΉ Ξ±ΞΊΟΞΌΞ± ΞΊΞ±ΞΉ schema-level:**  
Ξ“ΞΉΞ± Ξ½Ξ± Ξ²ΞΏΞ·ΞΈΞ¬Ο‚ Ο„Ξ± queries:

- Ξ ΟΟΟƒΞΈΞµΟƒΞµ Ξ­Ξ½Ξ± flag IsSchedulingRoot ΟƒΟ„ΞΏ UndoHistoryEntry
    - true ΞΌΟΞ½ΞΏ Ξ³ΞΉΞ± Ξ±ΟΟ‡ΞΉΞΊΞ¬ Schedule Ξ® UnSchedule
    - (Ξ® ΞΊΟΞ¬Ο„Ξ± ΞΊΞ±ΞΉ RescheduleRootId Ξ±Ξ½ ΞΈΞµΟ‚ group identifier Ξ³ΞΉΞ± undo blocks)

![[image-15.png]]



