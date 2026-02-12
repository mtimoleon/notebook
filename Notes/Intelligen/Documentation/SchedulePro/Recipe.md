---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2021-11-19T21:36
tags:
  - intelligen
---

**Organization**Β   
SchedulePro addresses the need to represent repetitive batch manufacturing by providing the concept of a **recipe**. A recipe is a template or description of how to make one batch of something.Β   
Β   
Β   
Β   
Recipes are organized into branches and sections. Recipe **branches** are supported in SchedulePro to maintain compatibility with SuperPro Designer. Branches do not have any function in SchedulePro.Β   
Recipe **sections** are intended to represent a distinct portion of a process. For example, a recipe may have a bulk mixing section and a filling and packaging section. Sections may optionally be assigned to a suite or a set of equipment that must be used together.Β   
Sections contain **unit procedures**. A unit procedureβ€”_procedure_ for shortβ€”is a distinct manufacturing step that utilizes at least one primary piece of equipment for its entire duration. For example, a mixing procedure might utilize a blending tank.Β   
Unit procedures are further divided into **operations**. Operations describe distinct sub-steps in a unit procedure. Operations may require other resources such as labor, materials, utilities, auxiliary equipment and staff.Β   
The relative timing of the various operations is determined by the operationβ€™s duration and by scheduling relationships among operations. An operation may have the following duration specifications:

- Fixed duration (default): The operations duration is set by the user.
- Rate based duration: The duration is based on a rate and is therefore dependent on the amount. For example the duration of a filling operation may be dependent on the filling rate.
- Dependent duration: The duration is equal to that of another operation or series of operations.
- Inventory-dependent duration: The duration of the operation is related to the time it takes for a storage unit inventory to reach a specified level (in other words, the operation β€holdsβ€™ until that specified level is reached)
- Changeover dependent duration: The duration of an operation depends on the change from or to a different product type.
- Zero-duration operations: Operations with a duration of zero are assumed not to occur. They may be included in a recipe and duration for specific instances added.
- Conditional Operations: These take place only when certain conditions are met.

An operation may have the following scheduling relative timing relationships:

- Start of batch: The operation starts relative to the start of the batch.
- Start of another operation: The operation starts relative to the beginning of another operation.
- End of another operation: The operation starts relative to the end of another operation.
- Start to finish: The operation finishes relative to the start of another operation.
- Finish to finish: The operation ends relative to the end of another operation.

In addition to the above specifications, an operation may have a fixed or flexible shift time. A fixed shift is a delay (or advance) that is always applied. A flexible shift is only applied if the operation needs to wait for a resource to become available. An operation can also be declared as β€interruptibleβ€™ meaning that it can stop and resume operation when the resources it needs become again available. The maximum number of breaks and the total break duration are user-defined.Β   
Β   
Further, operations may be condition on how much or how often the equipment has been used.Β   
All resources other than primary equipment or work areas are specified at the operation level. Operations may require resources including:

- Auxiliary equipment
- Materials (input or output)
- Utilities (heating/cooling)
- Power or Duty
- Labor (pooled labor resource)
- Staff (for scheduling individuals)

**Recipe Resources**Β   
Resources in SchedulePro represent the physical items that are necessary to execute a recipe, i.e. create a batch. Scheduled entities (operations, procedures, batches) might need to delay their execution until the resources they need become available.Β   
For organization, all resources (except materials) are organized into _facilities_. Facilities and their resources are equipped with calendars where their outages, downtimes etc can be declared.Β   
Resources act as constraints that the scheduler tries to satisfy, otherwise they generate conflicts. SchedulePro attempts to schedule in a way that does not exceed the supply of resources.Β   
**Equipment**Β   
Equipment is intended to represent the manufacturing equipment needed to carry out a specific process step, for example a tank, a reactor or a filling machine. From a scheduling point of view, an equipment item is a non-consumable reusable resource.Β   
Every unit-procedure requires an equipment resource. Each operation may _optionally_ require an auxiliary equipment resource. Any equipment may be assigned as either main equipment or auxiliary equipment.Β   
Main equipment and auxiliary equipment are assigned in _pools_. For example if a mixing step may be carried out in Tank-1 or Tank-2 both tanks may be listed in the pool. SchedulePro will pick the first available tank for a given batch.Β   
**Tip:** If multiple equipment units are used in a step you may either (1) create separate procedures in the recipe or (2) create an equipment unit that represents the combined equipment.Β   
Equipment in SchedulePro is a simple resource, however, equipment may (optionally) have a _size_ and a _rate._ SchedulePro uses the size to determine whether the equipment is appropriate for a given procedure or operation. The rate may be used to calculate the duration of rate-dependent operations.Β   
Equipment can optionally be declared able to accommodate multiple simultaneous procedures with user-defined limitations.Β   
Besides facilities, equipment may be further organized into _suites_. A suite is a set of equipment that must be used together.Β   
**Work Areas**Β   
Work areas represent rooms or places where procedures are carried out. Like equipment, work areas can accommodate multiple simultaneous procedures with user-defined limitations.Β   
**Materials**Β   
Materials in SchedulePro are a non-reusable resource. They may be _bulk_ (measured in mass or volume) or discrete (measured in number of individual entities).Β   
Materials are assigned to _streams_, when they either enter or leave an operation. Streams may be assigned to _storage units_ to aid in tracking or limiting certain material flows. Storage units may be used to place a limit on the rate at which a material may be used. Storage units may also track the inventory of the materials that they handle.Β   
**Labor**Β   
The labor resource in SchedulePro is a pool of a specific type of labor. The total size of the pool may be set by the user.Β   
**Staff**Β   
Staff resources are individuals that may be assigned to an operation. Both the number of individuals required and the allowable individuals may be specified.Β   
**Utilities**Β   
Utilities in SchedulePro are non-reusable resources which cannot be stored or inventoried. Utilities may include electrical power, heating agents such as steam, or cooling utilities like cooling water.Β   
Utilities are assigned to operations and may have user-defined limits. They may also be associated with materials in which case the materials consumed for the generation of a utility and the waste generated by the use of that utility can be accounted for.Β   
**Work Areas**Β   
Work areas are assigned at the equipment level. They differ from equipment in that multiple activities may take place in a work area, but there may be constraints on these activities.
 \> ΞΞ³ΞΉΞ½Ξµ ΞµΞΉΟƒΞ±Ξ³Ο‰Ξ³Ξ® Ξ±Ο€Ο \<mk:@MSITStore:D:\Program%20Files%20(x86)\Intelligen\SchedulePro10.1\SchedulePro.CHM::/2_1_2__Recipes.html\>




