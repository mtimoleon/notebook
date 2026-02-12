---
abandonded:
categories:
  - "[[Work]]"
  - "[[Issues]]"
created: 2026-01-30T15:19
tags:
  - intelligen
status: completed
product: ScpCloud
---

#### Code update that consolidates batch overlapping calculations:
[SyncService.SyncTrackingWithProductionAsync.patch](file:///D:\develop-tasks\525-Sync-after-planning-update\SyncService.SyncTrackingWithProductionAsync.patch.diff)
    
Ξ¤ΞΏΒ [syncService.SyncTrackingWithProductionAsync(...)](https://file+.vscode-resource.vscode-cdn.net/c%3A/Users/michael/.vscode/extensions/openai.chatgpt-0.4.68-win32-x64/webview/#)Β ΞΊΞ¬Ξ½ΞµΞΉΒ **ΞΌΞµΟΞΉΞΊΟ sync β€trackingβ€ Ξ΄ΞµΞ΄ΞΏΞΌΞ­Ξ½Ο‰Ξ½**Β Ξ±Ο€Ο Ο„ΞΏ Planning Ο€ΟΞΏΟ‚ Ο„ΞΏ Production, ΞΌΞµ ΟƒΟ„ΟΟ‡ΞΏ:

1. Ξ½Ξ± ΞµΞ½Ξ·ΞΌΞµΟΟΟƒΞµΞΉΒ **Ο„ΞΏ batch**Β ΟƒΟ„ΞΏ ΞΏΟ€ΞΏΞ―ΞΏ Ξ±Ξ½Ξ®ΞΊΞµΞΉ Ο„ΞΏΒ `OperationEntry`Β Ο€ΞΏΟ… Ξ¬Ξ»Ξ»Ξ±ΞΎΞµ (contents tracking + EOC tracking) ΞΊΞ±ΞΉ
2. Ξ½Ξ± ΞµΞ½Ξ·ΞΌΞµΟΟΟƒΞµΞΉΒ **ΞΌΟΞ½ΞΏ EOC tracking**Β Ξ³ΞΉΞ± Ξ¬Ξ»Ξ»Ξ± batches Ο€ΞΏΟ… ΞΈΞµΟ‰ΟΞΏΟΞ½Ο„Ξ±ΞΉ β€ΞµΟ€Ξ·ΟΞµΞ±Ξ¶ΟΞΌΞµΞ½Ξ±β€ Ξ»ΟΞ³Ο‰Β **overlap**.
   (Ξ²Ξ».Β [SyncService.cs (line 191)](https://file+.vscode-resource.vscode-cdn.net/c%3A/Users/michael/.vscode/extensions/openai.chatgpt-0.4.68-win32-x64/webview/#))

**Ξ ΞΏΟ ΞΊΞ±Ξ»ΞµΞ―Ο„Ξ±ΞΉ**

- ΞΞµΟ„Ξ¬ Ξ±Ο€Ο Ξ±Ξ»Ξ»Ξ±Ξ³Ξ­Ο‚ tracking (timing/staff/aux equipment) ΟƒΟ„ΞΏΟ…Ο‚ handlers:
- [UpdateOperationEntryTrackingTimingCommandHandler.cs (line 128)](https://file+.vscode-resource.vscode-cdn.net/c%3A/Users/michael/.vscode/extensions/openai.chatgpt-0.4.68-win32-x64/webview/#)
- [UpdateOperationEntryTrackingStaffCommandHandler.cs (line 116)](https://file+.vscode-resource.vscode-cdn.net/c%3A/Users/michael/.vscode/extensions/openai.chatgpt-0.4.68-win32-x64/webview/#)
- [UpdateOperationEntryTrackingAuxEquipmentCommandHandler.cs (line 120)](https://file+.vscode-resource.vscode-cdn.net/c%3A/Users/michael/.vscode/extensions/openai.chatgpt-0.4.68-win32-x64/webview/#)
- ΞΞΉ handlers Ο€ΟΟΟ„Ξ± ΞΊΞ¬Ξ½ΞΏΟ…Ξ½Β `SaveChangesAsync`, ΞΌΞµΟ„Ξ¬ Ο€Ξ±Ξ―ΟΞ½ΞΏΟ…Ξ½Β `productionBatches`Β Ξ±Ο€Ο Production (`GetLatestBatchesInfoAsync`) ΞΊΞ±ΞΉ ΞΌΞµΟ„Ξ¬ ΞΊΞ±Ξ»ΞΏΟΞ½ Ο„ΞΏ sync.

**Ξ’Ξ®ΞΌΞ±-Ξ²Ξ®ΞΌΞ± Ο„ΞΉ ΞΊΞ¬Ξ½ΞµΞΉ ΞΌΞ­ΟƒΞ±**

1. **Ξ’ΟΞ―ΟƒΞΊΞµΞΉ**Β Ο„ΞΏΒ `OperationEntry`Β ΞΌΞ­ΟƒΞ± ΟƒΟ„ΞΏΒ `SchedulingBoard`Β Ξ±Ο€Ο Ο„ΞΏΒ `operationEntryId`Β (LINQ chain Ο€Ξ¬Ξ½Ο‰ ΟƒΞµ Campaigns β†’ Batches β†’ ProcedureEntries β†’ OperationEntries). Ξ‘Ξ½ Ξ΄ΞµΞ½ Ξ²ΟΞµΞΈΞµΞ―, ΞµΟ€ΞΉΟƒΟ„ΟΞ­Ο†ΞµΞΉΒ `CommandStatus`Β ResourceNotFound. (`SyncService.cs:191+`)
2. **Ξ•Ξ»Ξ­Ξ³Ο‡ΞµΞΉ**Β ΟΟ„ΞΉ Ο…Ο€Ξ¬ΟΟ‡ΞΏΟ…Ξ½Β `ProcedureEntry`Β ΞΊΞ±ΞΉΒ `Batch`Β (Ξ±Ξ»Ξ»ΞΉΟΟ‚ ResourceNotFound). (`SyncService.cs:191+`)
3. Ξ§Ο„Ξ―Ξ¶ΞµΞΉΒ `productionBatchesDict`Β (`Id -\> BatchInfoDto`) Ξ±Ο€Ο Ο„ΞΏΒ `productionBatches`Β Ο€ΞΏΟ… Ο„ΞΏΟ… Ξ­Ξ΄Ο‰ΟƒΞµ ΞΏ caller. (`SyncService.cs:191+`)
4. ΞΟΞ―Ξ¶ΞµΞΉΒ `trackingUpdateBatch = operationEntry.ProcedureEntry.Batch`Β (Ο„ΞΏ batch Ο€ΞΏΟ… β€Ξ±Ξ»Ξ»Ξ¬Ξ¶ΞµΞΉβ€). (`SyncService.cs:191+`)
5. Ξ§Ο„Ξ―Ξ¶ΞµΞΉΒ `planningBatchesDict`Β ΞΌΞµΒ **ΟΞ»Ξ± Ο„Ξ± Ξ¬Ξ»Ξ»Ξ±**Β batches ΟƒΟ„ΞΏ scheduling board ΞµΞΊΟ„ΟΟ‚ Ξ±Ο€Ο Ο„ΞΏΒ `trackingUpdateBatch`. (`SyncService.cs:191+`)
6. Ξ¥Ο€ΞΏΞ»ΞΏΞ³Ξ―Ξ¶ΞµΞΉΒ `overlappingBatches`Β ΞΌΞµ 2 Ο„ΟΟΟ€ΞΏΟ…Ο‚:
   -  **Planning-side overlap**: Ξ³ΞΉΞ± ΞΊΞ¬ΞΈΞµ Ξ¬Ξ»Ξ»ΞΏ planning batch, Ξ±Ξ½Β `batch.TrackingOverlapsWith(trackingUpdateBatch)`Β Ο„ΟΟ„Ξµ Ο„ΞΏ Ο€ΟΞΏΟƒΞΈΞ­Ο„ΞµΞΉ. ([SyncService.cs (line 227)](https://file+.vscode-resource.vscode-cdn.net/c%3A/Users/michael/.vscode/extensions/openai.chatgpt-0.4.68-win32-x64/webview/#), ΞΏ ΞΏΟΞΉΟƒΞΌΟΟ‚ ΞµΞ―Ξ½Ξ±ΞΉ ΟƒΟ„ΞΏΒ [Batch.cs (line 910)](https://file+.vscode-resource.vscode-cdn.net/c%3A/Users/michael/.vscode/extensions/openai.chatgpt-0.4.68-win32-x64/webview/#))
   - **Production-side overlap chaining**: Ξ³ΞΉΞ± ΞΊΞ¬ΞΈΞµ planning batch Ο€ΞΏΟ… Ο…Ο€Ξ¬ΟΟ‡ΞµΞΉ ΞΊΞ±ΞΉ ΟƒΟ„ΞΏ production ([productionBatchesDict.TryGetValue(batch.Id, out ...)](https://file+.vscode-resource.vscode-cdn.net/c%3A/Users/michael/.vscode/extensions/openai.chatgpt-0.4.68-win32-x64/webview/#)), Ξ²ΟΞ―ΟƒΞΊΞµΞΉ Ο€ΞΏΞΉΞ± production batches overlap ΞΌΞ±Ξ¶Ξ― Ο„ΞΏΟ… ΞΌΞµΒ [GetOverlappingProductionBatchIds(...)](https://file+.vscode-resource.vscode-cdn.net/c%3A/Users/michael/.vscode/extensions/openai.chatgpt-0.4.68-win32-x64/webview/#)Β (Ξ²Ξ¬ΟƒΞµΞΉΒ `TrackingStart/TrackingEnd`) ΞΊΞ±ΞΉ ΞΌΞ±Ξ¶ΞµΟΞµΞΉ Ο„Ξ± IDs ΟƒΞµΒ `overlappingProductionBatchIds`. ([SyncService.cs (line 235)](https://file+.vscode-resource.vscode-cdn.net/c%3A/Users/michael/.vscode/extensions/openai.chatgpt-0.4.68-win32-x64/webview/#),Β [SyncService.cs (line 394)](https://file+.vscode-resource.vscode-cdn.net/c%3A/Users/michael/.vscode/extensions/openai.chatgpt-0.4.68-win32-x64/webview/#))
   - ΞΞµΟ„Ξ¬, Ξ³ΞΉΞ± ΞΊΞ¬ΞΈΞµΒ `productionBatchId`Β Ο€ΞΏΟ… Ξ²Ξ³Ξ®ΞΊΞµ, Ξ±Ξ½ Ο…Ο€Ξ¬ΟΟ‡ΞµΞΉ Ξ±Ξ½Ο„Ξ―ΟƒΟ„ΞΏΞΉΟ‡ΞΏ batch ΟƒΟ„ΞΏ planning ([planningBatchesDict.TryGetValue(...)](https://file+.vscode-resource.vscode-cdn.net/c%3A/Users/michael/.vscode/extensions/openai.chatgpt-0.4.68-win32-x64/webview/#)), Ο„ΞΏ Ο€ΟΞΏΟƒΞΈΞ­Ο„ΞµΞΉ ΟƒΟ„Ξ±Β `overlappingBatches`. (`SyncService.cs:240+`)
7. Ξ¥Ο€ΞΏΞ»ΞΏΞ³Ξ―Ξ¶ΞµΞΉ EOC Ξ΄ΞµΞ΄ΞΏΞΌΞ­Ξ½Ξ± Ξ³ΞΉΞ± tracking Ξ³ΞΉΞ±Β **ΟΞ»Ξ±**Β Ο„Ξ± batches Ο„ΞΏΟ… board:Β `batchesTrackingEocDataDic = GetBatchesTrackingEocDataDic(schedulingBoard)`Β Ο€ΞΏΟ… internally ΞΊΞ±Ξ»ΞµΞ―Β `_schedulingService.CalculateEocDataForBatches(..., TimingInfoType.Tracking)`. ([SyncService.cs (line 248)](https://file+.vscode-resource.vscode-cdn.net/c%3A/Users/michael/.vscode/extensions/openai.chatgpt-0.4.68-win32-x64/webview/#),Β [SyncService.cs (line 408)](https://file+.vscode-resource.vscode-cdn.net/c%3A/Users/michael/.vscode/extensions/openai.chatgpt-0.4.68-win32-x64/webview/#))
8. Ξ¦Ο„ΞΉΞ¬Ο‡Ξ½ΞµΞΉ DTO Ξ³ΞΉΞ±Β **Ο„ΞΏ batch Ο€ΞΏΟ… Ξ¬Ξ»Ξ»Ξ±ΞΎΞµ**:
	- `updateBatchPublishDto = _mapper.Map\<BatchPublishDto\>(trackingUpdateBatch)`
	- `BatchContentsTracking = Map\<BatchContentsDto\>(..., TimingInfoType.Tracking)`
	- `EocResourceDataTracking`Β Ξ±Ο€ΟΒ `_chartService.CreateEoc...`Β Ξ³ΞΉΞ± equipment+staff ΞΌΞµΒ  TimingInfoType.Tracking
	  (`SyncService.cs:250+`)
	- Ξ¦Ο„ΞΉΞ¬Ο‡Ξ½ΞµΞΉ listΒ `batchesToUpdateEocDataFor`Β Ξ³ΞΉΞ± ΞΊΞ¬ΞΈΞµ batch ΟƒΟ„ΞΏΒ `overlappingBatches`, Ξ±Ξ»Ξ»Ξ¬Β **ΞΌΟΞ½ΞΏ**Β ΞΌΞµΒ `EocResourceDataTracking`Β (Ο‡Ο‰ΟΞ―Ο‚ contents). (`SyncService.cs:276+`)
9. ΞΞ±Ξ»ΞµΞ― Production ΞΌΞ­ΟƒΟ‰ gRPC contract:
- [_productionSchedulingBoardServiceContract.TrackingSyncSchedulingBoardAsync(new TrackingSyncDto { ... })](https://file+.vscode-resource.vscode-cdn.net/c%3A/Users/michael/.vscode/extensions/openai.chatgpt-0.4.68-win32-x64/webview/#)
- ΟΟ€ΞΏΟ… ΟƒΟ„Ξ­Ξ»Ξ½ΞµΞΉ:
- `BatchToUpdateTrackingContentsAndEocDataFor`Β (Ο„ΞΏ β€mainβ€ batch)
- `BatchesToUpdateEocDataFor`Β (Ο„Ξ± ΞµΟ€Ξ·ΟΞµΞ±Ξ¶ΟΞΌΞµΞ½Ξ± batches)οΏΌ(`SyncService.cs:296+`)

**Ξ£Ξ·ΞΌΞµΞΉΟΟƒΞµΞΉΟ‚/ΟƒΟ…ΞΌΟ€ΞµΟΞΉΟ†ΞΏΟΞ¬**

- Ξ¤Ξ± overlaps Ξ³ΞΉΞ± tracking Ξ²Ξ±ΟƒΞ―Ξ¶ΞΏΞ½Ο„Ξ±ΞΉ ΟƒΞµΒ `TrackingStart/TrackingEnd`Β (planning ΞΊΞ±ΞΉ production). Ξ‘Ξ½ ΞΊΞ¬Ο€ΞΏΞΉΞΏ ΞµΞ―Ξ½Ξ±ΞΉΒ `null`, Ο„ΞΏ overlap check Ο„ΞµΞ―Ξ½ΞµΞΉ Ξ½Ξ± Ξ²Ξ³Ξ±Ξ―Ξ½ΞµΞΉΒ `false`Β (Ξ»ΟΞ³Ο‰ nullable ΟƒΟ…Ξ³ΞΊΟΞ―ΟƒΞµΟ‰Ξ½), Ξ¬ΟΞ± ΞΌΟ€ΞΏΟΞµΞ― Ξ½Ξ± ΞΌΞ· ΞΈΞµΟ‰ΟΞ·ΞΈΞµΞ― β€overlappingβ€ ΞΊΞ±ΞΉ Ξ½Ξ± ΞΌΞ· Ξ³Ξ―Ξ½ΞµΞΉ EOC update.    







