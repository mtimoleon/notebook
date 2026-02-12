---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2021-11-19T21:50
tags:
  - intelligen
---

While a recipe describes a process in general, a _schedule_ is a specific plan that specifies which recipes are executed when and with what resources.Β   
The relationship between recipes and the schedule is shown below:Β   
Β   
Β   
Β   
**Campaigns**Β   
A _campaign_ is a series of batches of a particular recipe. In SchedulePro a campaign may be planned or scheduled. A planned campaign does not have any scheduled batches but contains the information for scheduling them, e.g. number of batches, start time, due date etc. A campaign is _scheduled_ when all its batches are created.Β   
Campaigns have a release date representing their earliest start time and several scheduling options including due date, start relative to the start or end of some other campaign.Β   
Campaigns contain options on how to size and schedule their batches. A scale factor or target batch size may be specified for all batches of campaign. Cycle time for campaign (i.e. time interval between the start of two consecutive batches) can either be fixed by the user or can be set to (an estimated) minimum value plus some user-defined slack.Β   
Campaigns may also contain optional preproduction and postproduction steps to represent time spent setting up or cleaning out the equipment. These non-production steps are treated as regular operations that may consume materials and resources.Β   
**Batches**Β   
A _batch_ represents the execution of a single recipe at specific time and with specific resources. Procedures and operations in a recipe have corresponding entries in each batch. A batch has specific start and end times. [Batch](mailto:mk:@MSITStore:D:\Program%20Files%20\(x86\)\Intelligen\SchedulePro10.1\SchedulePro.CHM::/Batch.html) procedure entries are assigned a specific main equipment unit. [Batch](mailto:mk:@MSITStore:D:\Program%20Files%20\(x86\)\Intelligen\SchedulePro10.1\SchedulePro.CHM::/Batch.html) operation entries define the utilization of other resources.Β   
**Scheduler**Β   
Most users begin a scheduling exercise by defining the recipes, planning the campaigns, and allowing SchedulePro to generate a preliminary schedule. When generating a schedule, SchedulePro handles each campaign in the order listed. It then proceeds batch-by-batch calculating timing, assigning resources on a first-available basis and resolving conflicts.Β   
There are _modes_ that control the behavior of the scheduler in all its actions. These modes are presented in section 2.2.1.Β   
After the initial schedule is laid out, the user may edit the schedule by adjusting durations, shifts or start times for particular batches. These adjustments may be made by β€dragging and droppingβ€ in the interactive occupancy charts or by precisely specifying a start time. After a manual edit, SchedulePro readjusts the batch to conform to the master recipe (e.g. resets the start time of operations whose start time depends on the edited one) and recalculates conflicts. SchedulePro will not attempt to resolve any resulting conflicts unless invoked by the user.Β   
SchedulePro offers options to reschedule unschedule or resolve conflicts on a batch, a campaign or a portion of the entire schedule starting or ending at a specific batch or campaign. With these options the user has full control on the pace at which the entire schedule is generated and corrected.Β   
**Note:** Because campaigns are handled in order, their order determines their priority for getting resources. Campaigns that appear later in the list are more likely to have to wait for resources.Β   
**Schedule Start**Β   
TheΒ   
**Current Time**Β   
SchedulePro supports the concept of **current time** to separate past from future activities. Batches or campaigns ending before the current time are labeled as _completed_ while those starting before the current time but finishing later are labeled as _started_.Β   
These assignments get modified as the user resets the current time. Completed batches and campaigns can be deleted from the schedule; in this way, the schedule gets updated and the actual plant production process is simulated more realistically.Β   
Batches can also be labeled as _locked_ implying that their timing and resources are fixed and should not be modified. Non-locked batches should try to resolve own conflicts with locked batches even if they have higher priority according to the campaign definition sequence. [Batch](mailto:mk:@MSITStore:D:\Program%20Files%20\(x86\)\Intelligen\SchedulePro10.1\SchedulePro.CHM::/Batch.html) locking is essentially a way to assign highest priority to a scheduled batch.




