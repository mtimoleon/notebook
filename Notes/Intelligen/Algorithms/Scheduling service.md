---
categories:
  - "[[Work]]"
created: 2026-01-09T11:04
tags:
  - intelligen
---

Ξ΅ΞΏΞ® Ο€ΟΞΏΞ³ΟΞ±ΞΌΞΌΞ±Ο„ΞΉΟƒΞΌΞΏΟ (scheduling)
β€Ά Ξ•Ξ―ΟƒΞΏΞ΄ΞΏΞΉ: Scheduling board Ξ® ΟƒΟ…Ξ³ΞΊΞµΞΊΟΞΉΞΌΞ­Ξ½Ξ± campaigns. ΞΞ¬ΞΈΞµ campaign Ο€ΟΞ­Ο€ΞµΞΉ Ξ½Ξ± Ξ­Ο‡ΞµΞΉ Recipe Ξ³ΞΉΞ± Ξ½Ξ± Ξ³Ξ―Ξ½ΞµΞΉ layout. ScheduleCampaigns/ScheduleFromToCampaigns/ScheduleIndependentCampaign ΞΊΞ±Ξ»ΞΏΟΞ½ campaign.Layout() ΞΊΞ±ΞΉ ΞΌΞµΟ„Ξ¬ (Ο€ΟΞΏΞ±ΞΉΟΞµΟ„ΞΉΞΊΞ¬) ΞµΟ€Ξ―Ξ»Ο…ΟƒΞ· ΟƒΟ…Ξ³ΞΊΟΞΏΟΟƒΞµΟ‰Ξ½. SchedulingService.cs
β€Ά Modes: CampaignOnly, ToCampaign, FromCampaign ΞΊΞ±ΞΈΞΏΟΞ―Ξ¶ΞΏΟ…Ξ½ Ο€ΞΏΞΉΞ± campaigns/ batches ΟƒΟ…ΞΌΞΌΞµΟ„Ξ­Ο‡ΞΏΟ…Ξ½ ΟƒΞµ conflict detection & resolution. SchedulingService.cs
β€Ά Backward scheduling: Ξ‘Ξ½ campaign.ScheduleBackward, Ο„Ξ± batches ΞµΞΎΞµΟ„Ξ¬Ξ¶ΞΏΞ½Ο„Ξ±ΞΉ Ξ±Ξ½Ξ¬Ο€ΞΏΞ΄Ξ± ΞΊΞ±ΞΉ ΞΏΞΉ Ξ±Ξ½Ξ±Ξ¶Ξ·Ο„Ξ®ΟƒΞµΞΉΟ‚ slot Ξ³Ξ―Ξ½ΞΏΞ½Ο„Ξ±ΞΉ backward ΟΟ€ΞΏΟ… Ο‡ΟΞµΞΉΞ¬Ξ¶ΞµΟ„Ξ±ΞΉ. SchedulingService.cs
Ξ•Ξ½Ο„ΞΏΟ€ΞΉΟƒΞΌΟΟ‚ ΟƒΟ…Ξ³ΞΊΟΞΏΟΟƒΞµΟ‰Ξ½ (conflict detection)
β€Ά CalculateScheduleUtilization Ο‡Ο„Ξ―Ξ¶ΞµΞΉ utilization Ξ³ΞΉΞ± ΟΞ»ΞΏΟ…Ο‚ Ο„ΞΏΟ…Ο‚ Ο€ΟΟΞΏΟ…Ο‚ (equipment, staff, labor, storage) ΞΊΞ±ΞΉ ΟƒΟ…Ξ»Ξ»Ξ­Ξ³ΞµΞΉ conflicts. Ξ ΞµΟΞΉΞ»Ξ±ΞΌΞ²Ξ¬Ξ½ΞµΞΉ CreateCampaignTimingConflicts (release/due) ΞΊΞ±ΞΉ AddBatchUses (procedure + operation ΞµΟ€Ξ―Ο€ΞµΞ΄ΞΏ). SchedulingService.cs
β€Ά Ξ¥Ο€ΞΏΟƒΟ„Ξ·ΟΞ―Ξ¶ΞΏΞ½Ο„Ξ±ΞΉ Ξ΄ΟΞΏ timing modes: Planning vs Tracking (Ξ΄ΞΉΞ±Ο†ΞΏΟΞµΟ„ΞΉΞΊΞ­Ο‚ ΞΌΞ­ΞΈΞΏΞ΄ΞΏΞΉ Add*Tracking). SchedulingService.cs
β€Ά Ξ¥Ο€Ξ¬ΟΟ‡ΞµΞΉ cache/partial recompute (ΞΌΞµ stopAtConflict) Ξ³ΞΉΞ± Ο€ΞΉΞΏ Ξ³ΟΞ®Ξ³ΞΏΟΞ· Ξ±Ξ½Ξ±Ξ¶Ξ®Ο„Ξ·ΟƒΞ· conflicts ΟƒΞµ iterations. SchedulingService.cs
Ξ’ΟΟΟ‡ΞΏΟ‚ ΞµΟ€Ξ―Ξ»Ο…ΟƒΞ·Ο‚ ΟƒΟ…Ξ³ΞΊΟΞΏΟΟƒΞµΟ‰Ξ½
β€Ά ResolveConflicts ΞΊΞ¬Ξ½ΞµΞΉ loop ΞΌΞ­Ο‡ΟΞΉ Ξ½Ξ± Ξ»Ο…ΞΈΞΏΟΞ½ ΟΞ»ΞµΟ‚ Ξ® Ξ½Ξ± Ο†Ο„Ξ¬ΟƒΞµΞΉ Ο„ΞΏ maxNumberOfIterations (50.000). SchedulingService.cs
β€Ά ΞΞ¬ΞΈΞµ iteration: Ο…Ο€ΞΏΞ»ΞΏΞ³Ξ―Ξ¶ΞµΞΉ conflicts, Ο€Ξ±Ξ―ΟΞ½ΞµΞΉ Ο„ΞΏ conflict index, ΞµΞ»Ξ­Ξ³Ο‡ΞµΞΉ Ξ±Ξ½ Ο€ΟΞ­Ο€ΞµΞΉ Ξ½Ξ± Ξ»Ο…ΞΈΞµΞ― Ξ²Ξ¬ΟƒΞµΞΉ SchedulingConfiguration.ShouldResolveConflict, ΞµΟ€ΞΉΟ‡ΞµΞΉΟΞµΞ― ΞµΟ€Ξ―Ξ»Ο…ΟƒΞ·, Ξ±Ξ»Ξ»ΞΉΟΟ‚ Ο€ΟΞΏΟ‡Ο‰ΟΞ¬ ΟƒΟ„ΞΏ ΞµΟ€ΟΞΌΞµΞ½ΞΏ conflict. SchedulingService.cs
β€Ά Ξ‘Ξ½ Ξ»Ο…ΞΈΞµΞ― conflict, reset index ΟƒΟ„ΞΏ 0. Ξ‘Ξ½ ΟΟ‡ΞΉ, index++. SchedulingService.cs

ΞΞ»ΞµΟ‚ ΞΏΞΉ Ο€ΞµΟΞΉΟ€Ο„ΟΟƒΞµΞΉΟ‚ ΟƒΟ…Ξ³ΞΊΟΞΏΟΟƒΞµΟ‰Ξ½ ΞΊΞ±ΞΉ ΟƒΟ„ΟΞ±Ο„Ξ·Ξ³ΞΉΞΊΞ­Ο‚ ΞµΟ€Ξ―Ξ»Ο…ΟƒΞ·Ο‚
1) Campaign timing conflicts (release/due)
β€Ά ConflictType.CampaignTiming: ΟΟ„Ξ±Ξ½ start Ο€ΟΞΉΞ½ Ξ±Ο€Ο release Ξ® end ΞΌΞµΟ„Ξ¬ Ξ±Ο€Ο due.
β€Ά Ξ•Ο€Ξ―Ξ»Ο…ΟƒΞ·: TryCampaignShiftingForConflict ΞΊΞ¬Ξ½ΞµΞΉ SetCampaignTiming(), ΞΌΞµΟ„Ξ¬ shift Ο€ΟΞΏΟ‚ Ο„Ξ± ΞΌΟ€ΟΞΏΟ‚ Ξ³ΞΉΞ± release, ΞΊΞ±ΞΉ Ξ±Ξ½ Ξ³Ξ―Ξ½ΞµΟ„Ξ±ΞΉ Ο‡Ο‰ΟΞ―Ο‚ Ξ½Ξ± Ο€Ξ±ΟΞ±Ξ²ΞΉΞ±ΟƒΟ„ΞµΞ― release, shift Ο€ΟΞΏΟ‚ Ο„Ξ± Ο€Ξ―ΟƒΟ‰ Ξ³ΞΉΞ± due. SchedulingService.cs
2) Main equipment
β€Ά Overuse / Outage / Incompatibility
β€Ά Ξ£Ο„ΟΞ±Ο„Ξ·Ξ³ΞΉΞΊΞ­Ο‚ (ΟƒΞµΞΉΟΞ¬ Ο€ΟΞΏΟ„ΞµΟΞ±ΞΉΟΟ„Ξ·Ο„Ξ±Ο‚):
3. Resource reallocation: Ξ±Ξ»Ξ»Ξ±Ξ³Ξ® main equipment ΟƒΞµ compatible (Ξ±Ξ½ Ο‡Ο‰ΟΞ¬ΞµΞΉ ΞΊΞ±ΞΈΞ±ΟΞ¬). TryResourceReallocationForConflict
4. Breaks ΟƒΞµ operations Ξ±Ξ½ Ο„ΞΏ ΞµΟ€ΞΉΟ„ΟΞ­Ο€ΞΏΟ…Ξ½ Ο„Ξ± flags (ShiftOrBreakForEquipment) ΞΊΞ±ΞΉ Ο„ΞΏ conflict Ξ΄ΞµΞ½ ΞΎΞµΞΊΞΉΞ½Ξ¬/Ο„ΞµΞ»ΞµΞΉΟΞ½ΞµΞΉ ΞΌΞ­ΟƒΞ± ΟƒΞµ operation. TryAddingBreaksForConflict
5. Flex shifting: ΞΌΞµΟ„Ξ±ΞΊΞ―Ξ½Ξ·ΟƒΞ· procedure/operation ΟƒΞµ Ξ΄ΞΉΞ±ΞΈΞ­ΟƒΞΉΞΌΞΏ slot forward/backward. TryFlexShiftingForConflict
6. Batch shifting: Ξ±Ξ½Ξ±Ξ¶Ξ®Ο„Ξ·ΟƒΞ· equipment Ο€ΞΏΟ… Ξ±Ο€Ξ±ΞΉΟ„ΞµΞ― ΞµΞ»Ξ¬Ο‡ΞΉΟƒΟ„Ξ· ΞΌΞµΟ„Ξ±Ο„ΟΟ€ΞΉΟƒΞ· batch. TryBatchShiftingForConflict
β€Ά Ξ“ΞΉΞ± backward campaigns ΞΏΞΉ Ξ±Ξ½Ξ±Ξ¶Ξ·Ο„Ξ®ΟƒΞµΞΉΟ‚ slot Ξ±Ξ½Ο„ΞΉΟƒΟ„ΟΞ­Ο†ΞΏΞ½Ο„Ξ±ΞΉ. SchedulingService.cs
7) Aux equipment
β€Ά Overuse / Outage / Incompatibility
β€Ά Resource reallocation: Ξ±Ξ½ UseAllCompatibleAuxEquipment == false, ΞµΟ€ΞΉΞ»Ξ­Ξ³ΞµΞΉ Ξ¬Ξ»Ξ»ΞΏ compatible aux equipment ΞΌΞµ ΞΊΞ±ΞΈΞ±ΟΟ slot.
β€Ά Incompatibility: Ξ±Ξ½ Ο€ΟΞ­Ο€ΞµΞΉ Ξ½Ξ± Ο‡ΟΞ·ΟƒΞΉΞΌΞΏΟ€ΞΏΞΉΞ·ΞΈΞΏΟΞ½ ΟΞ»Ξ±, ΞΊΞ¬Ξ½ΞµΞΉ update ΟƒΞµ all compatible.
β€Ά Breaks: Ξ±Ξ½ ΞµΟ€ΞΉΟ„ΟΞ­Ο€ΞµΟ„Ξ±ΞΉ ShiftOrBreakForEquipment.
β€Ά Flex shifting: slot forward/backward ΞΌΞµ FindFirstEquipmentSlot*.
β€Ά Batch shifting: Ο…Ο€ΞΏΞ»ΞΏΞ³ΞΉΟƒΞΌΟΟ‚ batch shift ΟΟ€Ο‰Ο‚ ΟƒΟ„Ξ± main equipment.
SchedulingService.cs
8) Staff
β€Ά Overuse / Outage
β€Ά Resource reallocation: Ξ±Ξ½ RequiredNumberOfStaffType == SpecificNumber, Ξ±Ξ½Ο„ΞΉΞΊΞ±ΞΈΞΉΟƒΟ„Ξ¬ staff ΞΌΞµ Ξ¬Ξ»Ξ»ΞΏ Ξ±Ο€Ο staff pool Ο€ΞΏΟ… Ο‡Ο‰ΟΞ¬ΞµΞΉ ΞΊΞ±ΞΈΞ±ΟΞ¬.
β€Ά Breaks: Ξ±Ξ½ ShiftOrBreakForStaff.
β€Ά Flex shifting: slot forward/backward ΟƒΟ„ΞΏ Ξ―Ξ΄ΞΉΞΏ staff.
β€Ά Batch shifting: Ξ±Ξ½Ξ±Ξ¶Ξ®Ο„Ξ·ΟƒΞ· slot (Ξ® ΟƒΞµ pool ΟΟ„Ξ±Ξ½ Ο‡ΟΞµΞΉΞ¬Ξ¶ΞµΟ„Ξ±ΞΉ).
SchedulingService.cs
9) Labor (consumable)
β€Ά Overuse / Outage
β€Ά Breaks: Ξ±Ξ½ ShiftOrBreakForLabor.
β€Ά Flex shifting: slot forward/backward ΞΌΞµ rate.
β€Ά Batch shifting: Ξ±Ξ½Ξ±Ξ»ΞΏΞ³ΞΉΞΊΞ¬ ΞΌΞµ staff/equipment, Ξ±Ξ»Ξ»Ξ¬ ΞΌΞµ rate.
SchedulingService.cs
10) Storage unit (inventory)
β€Ά Overuse / Inventory limit / Batch integrity
β€Ά Ξ§ΟΞ®ΟƒΞ· InventoryProfile (high/low) Ξ±Ξ½Ξ¬Ξ»ΞΏΞ³Ξ± ΞΌΞµ rate ΞΊΞ±ΞΉ Ο„ΟΟ€ΞΏ conflict.
β€Ά Flex shifting: FindFirstSlotForward ΞΊΞ±ΞΉ shift operation.
β€Ά Batch shifting: Ο€Ξ±ΟΟΞΌΞΏΞΉΞ± Ξ»ΞΏΞ³ΞΉΞΊΞ®, ΞΌΞµ ΟƒΞµΞ²Ξ±ΟƒΞΌΟ MaintainBatchIntegrity.
SchedulingService.cs

Ξ•Ξ½Ξ΄ΞΏ-batch vs Ξ΄ΞΉΞ±-batch conflicts
β€Ά conflict.IsIntrabatch Ξ±Ξ»Ξ»Ξ¬Ξ¶ΞµΞΉ ΟƒΟ„ΟΞ±Ο„Ξ·Ξ³ΞΉΞΊΞ®:
β€Ά Ξ•Ο€ΞΉΟ‡ΞµΞΉΟΞµΞ― ΞΌΞΉΞΊΟΞ­Ο‚ ΞΌΞµΟ„Ξ±ΞΊΞΉΞ½Ξ®ΟƒΞµΞΉΟ‚ ΞΌΞ­ΟƒΞ± ΟƒΟ„ΞΏ Ξ―Ξ΄ΞΉΞΏ batch (TryResolvingOperationEntryIntraBatch / TryResolvingOperationEntryIntraBatchDueDate)
β€Ά Ξ‘Ο€ΞΏΟ†ΞµΟΞ³ΞµΞΉ Ξ»ΟΟƒΞµΞΉΟ‚ Ο€ΞΏΟ… ΞΌΞµΟ„Ξ±ΞΊΞΉΞ½ΞΏΟΞ½ precedent task ΟΟ„Ξ±Ξ½ Ξ΄ΞµΞ½ Ο€ΟΞ­Ο€ΞµΞΉ.
SchedulingService.cs
Ξ ΞµΟΞΉΞΏΟΞΉΟƒΞΌΞΏΞ― ΞΊΞ±ΞΉ Ξ±ΟƒΟ†Ξ±Ξ»ΞΉΟƒΟ„ΞΉΞΊΞ­Ο‚ Ξ΄ΞΉΞΊΞ»ΞµΞ―Ξ΄ΞµΟ‚
β€Ά maxNumberOfIterations Ο€ΟΞΏΟƒΟ„Ξ±Ο„ΞµΟΞµΞΉ Ξ±Ο€Ο Ξ±Ο„Ξ­ΟΞΌΞΏΞ½Ξ± loops. SchedulingService.cs
β€Ά ΞΞ¬ΞΈΞµ Ξ±Ο€ΟΟ€ΞµΞΉΟΞ± ΞΌΞµΟ„Ξ±ΞΊΞ―Ξ½Ξ·ΟƒΞ·Ο‚ Ξ³Ξ―Ξ½ΞµΟ„Ξ±ΞΉ Ο€Ξ¬Ξ½Ο‰ ΟƒΞµ BatchMemento ΞΊΞ±ΞΉ rollback Ξ±Ξ½ Ο€Ξ±ΟΞ±Ξ²ΞΉΞ±ΟƒΟ„ΞµΞ― release/due Ξ® Ξ±Ξ½ Ξ΄ΞµΞ½ Ο‡Ο‰ΟΞ¬ΞµΞΉ.
β€Ά ΞΞµΟ„Ξ¬ Ξ±Ο€Ο ΞµΟ€ΞΉΟ„Ο…Ο‡Ξ® ΞµΟ€Ξ―Ξ»Ο…ΟƒΞ·, Ξ³Ξ―Ξ½ΞµΟ„Ξ±ΞΉ UpdatePostProcessingTasks + UpdateConditionalTasks.
SchedulingService.cs




