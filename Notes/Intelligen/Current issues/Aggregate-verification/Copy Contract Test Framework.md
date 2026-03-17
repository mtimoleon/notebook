---
categories:
  - "[[Documentation]]"
created: 2026-03-06
product:
component: Tests
tags:
  - documentation/intelligen
---
​
## Purpose
​
This folder contains test-only infrastructure for copy contract and regression testing in the Planning solution.
​
The goal is to detect copy-path regressions when the domain evolves, especially when:
​
- a new aggregate is added
- a new relevant child member is introduced (list-backed or single reference)
- a new internal reference is added between entities
- a new copy entry point is added
- rewiring logic is forgotten after a deep copy
​
The framework is intentionally isolated in unit tests. It does not require any change to production domain code.
​
## What problem this solves
​
The domain currently has multiple copy mechanisms:
​
- generic `Clone` and `CopyFrom` extension methods
- aggregate-specific `CreateCopy` methods
- import/export mapping paths
​
Those paths are easy to break in subtle ways:
​
- a child list is copied shallowly instead of deeply
- a child points back to the old parent
- an internal link still points to the old graph
- a new relevant member is added and nobody updates the copy tests
- a new `CreateCopy` or `Clone` path is introduced without any coverage
​
This framework turns those risks into explicit contracts and coverage checks.
​
## Main pieces
​
### `CopyScenario`
​
File: [Infrastructure/CopyScenario.cs](Infrastructure/CopyScenario.cs)
​
A scenario describes one concrete copy entry point, for example:
​
- `Recipe.CreateCopy`
- `SchedulingBoard.CreateCopy`
- `Batch.Clone`
- `Batch.CopyFrom`
​
Each scenario provides:
​
- `ScenarioId`
- `EntryPointId`
- `TargetType`
- `Contract`
- `CreateExecution()`
​
`CreateExecution()` returns:
​
- the source root graph
- a delegate that executes the copy and returns the target root graph
​
### `CopyContract`
​
Files:
​
- [Infrastructure/CopyContract.cs](Infrastructure/CopyContract.cs)
- [Infrastructure/CopyMemberBehavior.cs](Infrastructure/CopyMemberBehavior.cs)
- [Infrastructure/CopyMemberRule.cs](Infrastructure/CopyMemberRule.cs)
​
A contract declares how relevant members are expected to behave during copy.
​
Supported behaviors:
​
- `DeepCopyCollection`
- `DeepCopyReference`
- `SharedReference`
- `OwnerRebound`
- `InternalReferenceRemap`
- `Ignored`
​
Examples:
​
- `Recipe.Branches` -> `DeepCopyCollection`
- `SchedulingBoard.VisibilityOrderingConfiguration` -> `DeepCopyReference`
- `Branch.Recipe` -> `OwnerRebound`
- `Operation.SchedulingLinkOperation` -> `InternalReferenceRemap`
- `ProcedureEquipment.Equipment` -> `SharedReference`
​
### `CopyContractVerifier`
​
File: [Infrastructure/CopyContractVerifier.cs](Infrastructure/CopyContractVerifier.cs)
​
The verifier executes the scenario and validates the resulting graph against the contract.
​
It works in two stages.
​
Stage 1: Build a source-to-target graph map.
​
- Execute the copy entry point.
- Walk all contract members marked as `DeepCopyCollection` or `DeepCopyReference`.
- Pair each source node with the expected copied target node.
​
Stage 2: Verify the remaining rules.
​
- `SharedReference`: source member and target member must point to the same external object.
- `OwnerRebound`: target member must point to the mapped new parent.
- `InternalReferenceRemap`: target member must point to the mapped new internal node.
- `Ignored`: explicitly excluded from verification.
​
This split is what allows the framework to verify rewiring generically instead of with scenario-specific assertions.
​
### `CopyScenarioRegistry`
​
File: [CopyScenarioRegistry.cs](CopyScenarioRegistry.cs)
​
This is the central registry of supported copy scenarios.
​
It currently contains:
​
- `Recipe.CreateCopy`
- `SchedulingBoard.CreateCopy`
- `Batch.Clone`
- `Batch.CopyFrom`
​
It also declares explicit exclusions for aggregate-root copy entry points that are currently out of scope, each with a required reason.
​
### `CopyGraphFixtures`
​
File: [CopyGraphFixtures.cs](CopyGraphFixtures.cs)
​
This file builds representative domain graphs for the scenarios.
​
The fixtures intentionally include:
​
- nested collections
- owner/back-reference chains
- shared external references
- internal references between copied nodes
​
The current fixtures include representative graphs for:
​
- `Recipe`
- `SchedulingBoard`
- `Batch`
​
### `CopyCoverageTests`
​
File: [CopyCoverageTests.cs](CopyCoverageTests.cs)
​
These tests enforce coverage and drift detection.
​
They use reflection to fail when:
​
- a covered type gains a new relevant list-backed or single-reference member without contract classification
- a contract references a member that no longer exists
- an aggregate-root copy-like entry point exists without either:
  - a registered scenario
  - an explicit documented exclusion in the registry
​
This is the part that prevents silent drift.
​
### `CopyContractTests`
​
File: [CopyContractTests.cs](CopyContractTests.cs)
​
These are the end-to-end tests that run all registered scenarios through the generic verifier.
​
### `CopyContractVerifierTests`
​
File: [CopyContractVerifierTests.cs](CopyContractVerifierTests.cs)
​
These are focused tests for the verifier itself.
​
They exist to validate tricky framework behavior such as:
​
- owner rebinding
- internal remapping
- failure when rewiring is broken
​
## Mental model
​
The framework treats a copy path as:
​
1. Build a representative source graph.
2. Execute one copy entry point.
3. Describe expected structural behavior declaratively.
4. Verify the copied graph generically.
5. Enforce that new relevant members and new entry points cannot slip in uncovered.
​
In short:
​
- scenarios define "what to copy"
- contracts define "how each member should behave"
- verifier checks "did the actual graph obey the contract"
- coverage tests check "did we forget to classify something new"
​
## Behavior definitions
​
### `DeepCopyCollection`
​
Use this when:
​
- the collection instance must be new
- the items in the collection must be new instances
- the items are part of the copied graph
​
Typical examples:
​
- `Recipe.Branches`
- `Procedure.Operations`
- `Batch.ProcedureEntries`
​
### `DeepCopyReference`
​
Use this when:
​
- a single owned reference should be a new instance
- it is not represented as a collection
​
Typical examples:
​
- `SchedulingBoard.VisibilityOrderingConfiguration`
- `SchedulingBoard.SchedulingConfiguration`
​
### `SharedReference`
​
Use this when:
​
- the reference points outside the copied graph
- the copied object should still point to the same external object
​
Typical examples:
​
- `Equipment`
- `Staff`
- `Material`
- `Labor`
- `Workspace`
- `Recipe` referenced from a copied campaign
​
### `OwnerRebound`
​
Use this when:
​
- a copied child must point to its new copied parent
​
Typical examples:
​
- `Branch.Recipe`
- `Section.Branch`
- `Operation.Procedure`
- `OperationEntry.ProcedureEntry`
- `OperationEntryStream.OperationEntry`
​
### `InternalReferenceRemap`
​
Use this when:
​
- a member points to another object inside the copied graph
- that pointer must be rewired to the corresponding copied object
​
Typical examples:
​
- `Operation.SchedulingLinkOperation`
- `Operation.DurationStartSingleReferenceOperation`
- `ProcedureEntry.MainEquipmentCompatibilityProcedureEntry`
- `Campaign.ReleaseTimeReferenceCampaign`
​
### `Ignored`
​
Use this when:
​
- the member is relevant enough to require an explicit decision
- but it is intentionally not part of the current contract scope
​
This is important. `Ignored` is not "forgotten". It is an explicit statement that the member was reviewed.
​
## How the current scenarios are structured
​
### `Recipe.CreateCopy`
​
Checks:
​
- deep-copied branch, section, procedure, operation, stream, and many-to-many collections
- owner rebinding throughout the copied recipe graph
- internal remapping of operation-to-operation links
- shared references for external resources like equipment, material, staff, labor, workspace, and recipe type
​
### `SchedulingBoard.CreateCopy`
​
Checks:
​
- deep-copied campaigns, projects, display profiles, batches, procedure entries, operation entries, configuration objects, and operation-entry additional scheduling links
- nested coverage for `Project` and `DisplayProfile` graphs, including:
  - `Project.Campaigns`
  - `DisplayProfile.SelectedEquipment`
  - `DisplayProfile.SelectedStaff`
  - `DisplayProfile.DisplayProfileFilterRules`
  - `DisplayProfile.DisplayProfileSortings`
  - `DisplayProfile.DisplayProfileColumns`
- owner rebinding through `SchedulingBoard -> Campaign -> Batch -> ProcedureEntry -> OperationEntry`
- internal remapping for campaign references and entry-to-entry dependencies
- owner/shared reference assertions for display-profile nested members (`DisplayProfileEquipment`/`DisplayProfileStaff` owner links, shared resource refs, and current shared back-links for filter/sorting/column entities)
- shared references for external domain resources like recipe, equipment, staff, labor, material, and current shared board refs on project/display-profile nodes
- explicit `Ignored` classifications for known production gaps that are intentionally not enforced yet
​
### `Batch.Clone`
​
Checks:
​
- new copied batch graph
- deep-copied procedure entry, operation entry, and additional scheduling-link collections
- shared references for external domain objects and current extension-copy parent/internal references
- owner rebinding for entry-owned children
​
### `Batch.CopyFrom`
​
Checks:
​
- restoring an existing live batch from a backup graph
- final structure still obeys the same contract expectations (including additional scheduling-link collection shape and explicit shared parent/internal links)
- copied content is restored without requiring production code changes
​
The important distinction is:
​
- `Clone` creates a new graph
- `CopyFrom` restores state into an existing graph
​
The verifier still treats both as "source graph -> resulting target graph" and applies the same structural rules.
​
## Developer workflow
​
This is the section to follow when the domain changes.
​
### If you add a new relevant member to a covered type
​
Example:
​
- new `List<T>` backing field
- new `IReadOnlyList<T>` property
- new entity reference such as owner/back-reference or internal cross-link
​
What to do:
​
1. Decide whether the new member is part of the copy contract for the relevant scenario.
2. Open [CopyScenarioRegistry.cs](CopyScenarioRegistry.cs).
3. Add a rule for that member in every affected scenario contract.
4. Pick the correct behavior:
   - `DeepCopyCollection`
   - `DeepCopyReference`
   - `SharedReference`
   - `OwnerRebound`
   - `InternalReferenceRemap`
   - `Ignored`
5. If the new member needs representative data, update [CopyGraphFixtures.cs](CopyGraphFixtures.cs).
6. Run the test project.
​
If you do nothing, `CopyCoverageTests` should fail and tell you which member is unclassified.
​
### If you add a new internal reference between copied nodes
​
Examples:
​
- a procedure now references another procedure in the same copied graph
- an operation entry points to another operation entry
​
What to do:
​
1. Add representative wiring in [CopyGraphFixtures.cs](CopyGraphFixtures.cs).
2. Add an `InternalReferenceRemap` rule in the relevant scenario contract.
3. Run tests.
​
If the production copy code forgets to rewire the new member, the scenario test should fail.
​
### If you add a new owner/back-reference
​
Examples:
​
- a child now stores a pointer to its parent
- a copied owned item must point to the new owner
​
What to do:
​
1. Add representative objects in the fixture if needed.
2. Add an `OwnerRebound` rule for the member.
3. Run tests.
​
### If you add a new external shared reference
​
Examples:
​
- copied node now keeps a reference to `Equipment`, `Staff`, `Material`, `Workspace`, or another external aggregate
​
What to do:
​
1. Add representative data to the fixture if the current graph does not exercise it.
2. Add a `SharedReference` rule for the member.
3. Run tests.
​
### If you add a new copy entry point
​
Examples:
​
- a new aggregate method called `CreateCopy`
- a newly supported `Clone` or `CopyFrom` path
​
What to do:
​
1. Add a new `CopyScenario` to [CopyScenarioRegistry.cs](CopyScenarioRegistry.cs).
2. Create or reuse fixture data in [CopyGraphFixtures.cs](CopyGraphFixtures.cs).
3. Define a `CopyContract` for the scenario.
4. If the entry point is intentionally out of scope, add an explicit exclusion with a concrete reason in the registry.
5. Run tests.
​
If you do nothing, `CopyCoverageTests` should fail because the entry point has no registered scenario.
​
### If you add a brand new aggregate that has copy behavior
​
Recommended workflow:
​
1. Decide whether the aggregate should be covered now or later.
2. If now:
   - add representative fixture data
   - add a scenario
   - add a contract
   - ensure coverage tests pass without adding exclusions
3. If later:
   - add an explicit aggregate-root entry-point exclusion with a technical reason
   - leave a clear follow-up item
​
Do not silently add a copy path and assume existing scenarios will cover it.
​
### If a test starts failing after a domain change
​
Read the failure category first.
​
Unclassified member failure:
​
- a covered type changed and the contract was not updated
​
Missing scenario failure:
​
- a supported copy entry point exists but no scenario was registered
​
Contract verifier failure:
​
- the production copy behavior no longer matches the declared contract
- either the production behavior is wrong, or the contract is outdated
​
Before changing the contract, confirm whether the new production behavior is actually intended.
​
## Recommended checklist before merging domain copy changes
​
Use this checklist whenever you touch copy behavior or graph structure.
​
- Does the affected type already have a copy scenario?
- Did you add or remove any list-backed members?
- Did you add any new parent/owner reference?
- Did you add any new internal cross-link inside the copied graph?
- Did you add any new external shared reference?
- Did you add a new `CreateCopy`, `Clone`, or `CopyFrom` entry point?
- Did you update the fixture so the new path is actually exercised?
- Did you run `Planning.UnitTests`?
​
## Running the tests
​
Run the full Planning unit test project:
​
```powershell
dotnet test Services/Planning/Planning.UnitTests/Planning.UnitTests.csproj
```
​
Run only the copy contract area:
​
```powershell
dotnet test Services/Planning/Planning.UnitTests/Planning.UnitTests.csproj --filter "FullyQualifiedName~CopyContracts"
```
​
## Discovery scope and intentional limitations
​
- Aggregate-root instance copy-like entry points (`CreateCopy`, `Clone`, `CopyFrom`) are discovered via reflection from `Planning.Domain` and must have a scenario or explicit exclusion.
- `CloneExtension` method-name coverage is enforced for target types that already have clone-extension scenarios registered.
- `CloneExtension` call-site entry points are also discovered from loaded production `Planning.*` assemblies (`Planning.Domain`, `Planning.Api`, `Planning.Infrastructure`, and similar non-test assemblies) and must have either:
  - a registered clone-extension scenario entry point
  - an explicit exclusion with reason in `CopyScenarioRegistry.CloneExtensionEntryPointExclusions`
- The call-site heuristic is intentionally pragmatic and bounded to direct extension invocations from production `Planning.*` methods (excluding test assemblies and `CloneExtension` internals), to avoid high-noise transitive inference.
​
Intentional `Ignored` members in current contracts include:
​
- `Recipe.MainEquipmentCompatibilityProcedure`: current `Recipe.CreateCopy` keeps compatibility links as-is instead of remapping to copied procedures.
- `Campaign.DueTimeReferenceCampaign` in `SchedulingBoard.CreateCopy`: current production path rewires release-time campaign references but not due-time campaign references.
- `Project.SchedulingBoard` and `DisplayProfile.SchedulingBoard` in `SchedulingBoard.CreateCopy`: current production path clones these nodes but does not rebind them to the copied scheduling board.
- `DisplayProfileFilterRule.DisplayProfile`, `DisplayProfileSorting.DisplayProfile`, and `DisplayProfileColumn.DisplayProfile`: current production path clones these children but leaves their back-links on the source display profile.
- `ProcedureEntry.Batch`, `OperationEntry.ProcedureEntry`, `OperationEntrySchedulingLink.OperationEntry`, and `OperationEntrySchedulingLink.LinkOperationEntry` in batch clone/copy scenarios: generic extension-based batch copy currently preserves source/backup parent links instead of rebinding them.
- `ProcedureEntry.MainEquipmentCompatibilityProcedureEntry` and `OperationEntry` internal reference members (`SchedulingLinkOperationEntry`, `DurationStartSingleReferenceOperationEntry`, `DurationEndReferenceOperationEntry`) in batch clone/copy scenarios: current generic extension-based batch copy does not remap these internal links.
- `OperationEntry.NonProcessingOperation` in scheduling/batch scenarios: current production behavior is not consistently remapped to copied non-processing operations.
- `OperationEntry.TrackingUpdate` and `ProcedureEntry.MainEquipmentUpdate` in scheduling/batch scenarios: these update snapshots are intentionally outside the current generic copy contract scope.
​
## Current scope and known next steps
​
Current scope:
​
- `Recipe.CreateCopy`
- `SchedulingBoard.CreateCopy`
- `Batch.Clone`
- `Batch.CopyFrom`
​
Natural next scenarios to add:
​
- import/export roundtrip contracts
- additional aggregate-specific copy paths
- other copy-sensitive graphs once the team decides they should be enforced
​
## Maintenance principle
​
When the domain evolves, this framework should fail loudly unless the new structure has been explicitly reviewed.
​
That is the intended behavior.
​
If a new relevant member appears, the developer should have to make a deliberate choice:
​
- copy deeply
- keep shared
- rebind owner
- remap internal reference
- ignore explicitly
​
The framework is not just checking correctness. It is forcing classification.
​
​