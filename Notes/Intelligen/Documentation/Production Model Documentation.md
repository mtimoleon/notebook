---
categories:
  - "[[Documentation]]"
created: 2026-04-21
product: ScpCloud
component:
tags:
  - documentation/intelligen
  - topic/business-logic
  - topic/code
---
### Summary
​
The main idea of the model is:
​
production behavior is not determined only by the recipe.
​
It is determined by:
​
- recipe
- resolved product identity
- selected BOM
- equipment-specific attribute behavior
- transition behavior between attribute values
​
That is why we introduce recipe attributes, BOM coupling, adaptive streams, attribute-aware rates, and changeover matrices as a connected set of concepts rather than isolated features.

### Details
#### Scope
​
This document explains the main production-model concepts introduced and used by the app.
​
The goal is to describe how the model works:
​
- how product identity is represented
- how a recipe becomes product-aware
- how BOMs participate in scheduling
- how equipment-specific behavior is resolved
- how changeovers are calculated
- how dynamic scheduling behavior emerges from these concepts
​
#### Big Picture
​
The model moves from a generic "recipe schedules operations" approach to a more explicit "recipe plus product context schedules operations" approach.
​
The product context is defined by a combination of:
​
- recipe attributes and their values
- the produced material
- the BOM selected for the campaign
- equipment-specific rates for particular attribute values
- changeover behavior between different attribute values
​
In practice, this means that the same recipe can behave differently depending on what it is producing.
​
#### Core Concepts
​
The main concepts are:
​
1. `RecipeAttribute`
2. `RecipeAttributeValue`
3. `Material`
4. `Bom`
5. `AdaptiveInput` and `AdaptiveOutput`
6. `Campaign`
7. `Batch`
8. `EquipmentRecipeAttributeValue`
9. `ChangeoverMatrix`
10. dynamic `OperationEntry` behavior
​
These concepts are not independent. They form a pipeline.
​
#### 1. Recipe Attributes
​
##### What they are
​
A `RecipeAttribute` is a configurable product dimension that matters to production behavior.
​
Typical examples are:
​
- SKU
- grade
- viscosity class
- product family
- color
​
The important idea is that a recipe attribute is not just metadata. It is something that can influence:
​
- equipment rates
- changeovers
- batch identity
- stream selection through adaptive recipe logic
​
##### Where they live
​
Recipe attributes are workspace-level definitions.
​
That means:
​
- a workspace defines the available attributes
- each attribute has a controlled set of values
- recipes, materials, equipment, and changeover rules refer back to these shared definitions
​
##### Why they exist
​
Without recipe attributes, the system can represent that a recipe exists, but it cannot represent product-specific differences cleanly.
​
Recipe attributes solve that by giving the model a shared vocabulary for product variation.
​
#### 2. Recipe Attribute Values
​
##### What they are
​
A `RecipeAttributeValue` is one allowed value of a `RecipeAttribute`.
​
Examples:
​
- attribute `SKU` -> values `A`, `B`, `C`
- attribute `Color` -> values `White`, `Blue`, `Red`
​
##### Important rule
​
A value belongs to exactly one attribute.
​
The model assumes that a value is meaningful only in the context of its parent attribute.
​
##### Why this matters
​
This allows the system to say things like:
​
- a material has SKU A
- a recipe defaults to SKU B
- equipment runs faster for SKU C
- changeover from SKU A to SKU B takes 60 minutes
​
#### 3. Materials as Product Identity Carriers
​
##### What a material does in this model
​
`Material` is no longer just a passive inventory or catalog entity.
​
It can now carry recipe attribute values.
​
This means a material can represent a concrete produced product configuration.
​
##### Practical meaning
​
If a material has:
​
- `SKU = A`
- `Color = White`
​
then that material expresses a concrete product identity.
​
When a batch is built from a BOM that produces this material, the batch can inherit these attribute values.
​
##### Why material-level attributes matter
​
This is the bridge between:
​
- the product catalog side
- and the scheduling side
​
The scheduler does not need a special one-off "campaign material name" shortcut anymore. It can work from structured product identity.
​
#### 4. Recipe Defaults
​
##### What a recipe can define
​
A `Recipe` can have default `RecipeAttributeValue` assignments.
​
These defaults express the base product context for the recipe.
​
##### Why recipe defaults exist
​
Not every scheduled batch must come from a BOM-driven product material.
​
Sometimes the recipe alone should provide the product context.
​
In that case:
​
- the recipe supplies the default attribute values
- the batch uses those defaults directly
​
##### Result
​
There are two possible sources of product context for a batch:
​
1. from the selected BOM and its product material
2. from the recipe defaults if no BOM overrides them
​
#### 5. BOM
​
##### What a BOM represents
​
A `Bom` represents a concrete bill of materials for producing a specific material.
​
It contains:
​
- the produced product material
- optional recipe association
- input streams
- output streams
​
##### Why BOM is important here
​
The BOM is the explicit runtime choice of "what this campaign is actually making".
​
The recipe describes the process structure.
The BOM describes the concrete product instance of that process.
​
##### Relationship to recipe
​
A BOM may be associated with a recipe.
​
That association means:
​
- this BOM is valid in the context of that recipe
- the adaptive recipe streams can bind against the BOM streams
- the campaign can use the BOM safely with the recipe
​
##### Product resolution through BOM
​
When a campaign uses a BOM:
​
- the batch points to that BOM
- the batch sees the BOM product
- the batch inherits the product material's recipe attribute values
​
So the BOM is the main mechanism that turns a generic recipe into a product-specific execution.
​
#### 6. Adaptive Inputs and Adaptive Outputs
​
##### Why adaptive streams exist
​
In a generic recipe model, operation streams are fixed.
​
That is too rigid when the same recipe can produce different products or use different material mappings depending on the BOM.
​
`AdaptiveInput` and `AdaptiveOutput` solve that problem.
​
##### What they do
​
They let a recipe define stream placeholders at the operation level.
​
Those placeholders are later connected to BOM streams.
​
This means:
​
- the recipe says "this operation consumes an adaptive input"
- the BOM says which concrete material and amount that input corresponds to
​
The same applies to outputs.
​
##### Practical effect
​
The recipe stays reusable.
The BOM provides the concrete material realization.
​
So:
​
- recipe = process logic
- BOM = material realization of that logic
​
#### 7. Campaign
​
##### What a campaign represents
​
A `Campaign` is the scheduling-level production request.
​
It selects:
​
- the recipe
- optionally the BOM
- the number of batches
- timing rules
​
##### Why the BOM on campaign matters
​
The campaign is where the system decides the actual product context for execution.
​
If a campaign has a BOM:
​
- the campaign is not just scheduling the recipe
- it is scheduling that recipe for a specific BOM-defined product
​
##### Validation role
​
The campaign also validates key consistency rules before scheduling, such as:
​
- a recipe must exist
- the selected BOM must match the selected recipe
- reference campaigns used for timing must already be scheduled when required
​
#### 8. Batch
​
##### What the batch does
​
The `Batch` is where the product context becomes operational.
​
When a batch is filled, it resolves its attribute values.
​
##### Resolution order
​
The batch obtains its effective recipe attribute values as follows:
​
1. if there is a BOM, use the BOM product material's attribute values
2. otherwise use the recipe's default attribute values
​
##### Why this is important
​
From this point on, the batch has a concrete product identity.
​
That identity is then used by:
​
- operation duration calculations
- equipment-dependent rates
- changeover calculations
- scheduling conflict resolution
​
##### Clean attribute values
​
The batch exposes a clean list of resolved attribute values.
​
That list acts as the effective product context for scheduling logic.
​
#### 9. Equipment Rates by Attribute Value
​
##### The basic problem
​
An equipment often does not process all products at the same speed.
​
Without attribute-aware rates, the model can only say:
​
- this equipment runs at X
​
That is too coarse.
​
##### The solution
​
`Equipment` can now define rates tied to a specific `RecipeAttribute` and its values.
​
This allows:
​
- one default equipment rate
- plus overrides for specific attribute values
​
##### Example
​
Suppose a mixer supports attribute `SKU`.
​
It may define:
​
- default rate = 1000 kg/h
- SKU A = 900 kg/h
- SKU B = 700 kg/h
​
Now operation duration on that mixer depends on the batch's resolved attribute value.
​
##### Why this matters
​
The scheduler can now distinguish between:
​
- the same operation on the same equipment
- but for different products
​
That is one of the central reasons the branch exists.
​
#### 10. Changeover Matrix
​
##### What a changeover matrix expresses
​
A `ChangeoverMatrix` defines the changeover duration between two values of the same recipe attribute.
​
It is attached to one `RecipeAttribute`.
​
##### Example
​
For attribute `SKU`:
​
- from `A` to `A` = 0
- from `A` to `B` = 60 min
- from `B` to `A` = 45 min
- from `null` to `A` = 0
​
##### Why this model is useful
​
This captures product-transition costs explicitly.
​
The system no longer assumes a single constant changeover duration.
​
Instead, it can say:
​
- changeover depends on what was running before
- and what will run next
​
##### Symmetry
​
A matrix may be treated as symmetrical.
​
If it is symmetrical, then:
​
- from A to B
- and from B to A
​
can share the same rule when only one direction is defined.
​
##### Idle-state handling
​
The matrix can also define an idle-state threshold.
​
This is used for logic such as:
​
- if equipment has been idle long enough, treat the transition differently
​
That gives more realistic changeover behavior.
​
#### 11. Operation Duration Based on Changeover Matrix
​
##### New duration mode
​
An operation can use the duration mode:
​
- `BasedOnChangeoverMatrix`
​
This means its duration is not fixed and not purely rate-based.
​
It is derived from changeover context.
​
##### What this implies
​
The duration of the operation depends on:
​
- the relevant recipe attribute
- the value before
- the value after
- possibly idle-state rules
​
So the same operation entry can have different durations in different schedule contexts.
​
##### Why this makes operations dynamic
​
Because the duration depends on surrounding schedule state, the operation becomes dynamic.
​
This is why the branch adds explicit dynamic task recalculation behavior.
​
#### 12. Dynamic Operations
​
##### What counts as dynamic
​
An `OperationEntry` is treated as dynamic when its behavior is not fully static from the recipe definition alone.
​
This includes cases such as:
​
- conditional operations
- changeover-matrix-based durations
​
##### Why dynamic tasks matter
​
If an operation is dynamic, then a timing shift somewhere else can force this operation to change duration or activation state.
​
That means scheduling cannot assume a one-time duration calculation.
​
It must be able to:
​
- recalculate duration
- propagate timing again
- reevaluate occupancy and conflicts
​
#### 13. Procedure and Operation Timing Semantics
​
Because dynamic and non-processing tasks now exist more explicitly, the model distinguishes between several timing views.
​
Examples include:
​
- start excluding conditional tasks
- start excluding dynamic operations
- end excluding dynamic operations
- end excluding non-processing tasks
​
##### Why these views are needed
​
If you use raw procedure start and end all the time, you mix together:
​
- real processing
- changeovers
- conditional tasks
- post-processing tasks
​
That produces incorrect slot search and overlap logic.
​
These alternative timing views let the scheduler answer more precise questions, such as:
​
- when does actual processing start
- how long does the procedure occupy the equipment excluding dynamic changeover behavior
- what is the stable core duration of the procedure
​
#### 14. How Scheduling Uses These Concepts
​
##### Step 1: campaign validation
​
Before scheduling, the campaign checks:
​
- recipe validity
- BOM and recipe consistency
- timing-reference consistency
​
##### Step 2: sample batch creation
​
The recipe can generate a sample batch.
​
That sample batch is built using the same product context rules:
​
- BOM-driven if a BOM exists
- recipe-default-driven otherwise
​
This allows realistic cycle-time estimation.
​
##### Step 3: batch fill
​
When the actual batch is created, it:
​
- resolves product context
- creates procedure entries
- creates operation entries
- binds adaptive operation streams to BOM streams
​
##### Step 4: duration resolution
​
Operation durations are then resolved from:
​
- fixed duration settings
- rate-based settings
- equipment-dependent rates
- changeover matrices
​
##### Step 5: conflict resolution
​
When the scheduler looks for equipment slots or resolves conflicts, it now uses richer timing semantics.
​
It can consider:
​
- dynamic task boundaries
- changeover-induced durations
- equipment-specific product context
​
That makes conflict resolution more realistic, but also more complex.
​
#### 15. End-to-End Data Flow
​
This is the conceptual flow from configuration to scheduling result:
​
1. The workspace defines recipe attributes and values.
2. A recipe defines its process structure and may define default attribute values.
3. A material defines the concrete product identity through attribute values.
4. A BOM says this recipe instance produces that material and exposes concrete streams.
5. A campaign selects a recipe and optionally a BOM.
6. A batch resolves its effective attribute values from the BOM product or the recipe defaults.
7. Operation entries use that context to resolve streams, durations, and equipment-specific rates.
8. Changeover operations use matrices to calculate transition durations.
9. The scheduler recalculates dynamic tasks and resolves conflicts based on the resulting timing model.
​
#### 16. Example Scenario
​
Consider this simplified scenario.
​
##### Configuration
​
- Recipe attribute: `SKU`
- Values: `A`, `B`
- Recipe `MixingRecipe`
- Material `ProductA` has `SKU = A`
- Material `ProductB` has `SKU = B`
- BOM `BomA` produces `ProductA`
- BOM `BomB` produces `ProductB`
- Equipment `Mixer1`:
  - default rate = 1000 kg/h
  - rate for `SKU A` = 900 kg/h
  - rate for `SKU B` = 700 kg/h
- Changeover matrix for `SKU`:
  - `A -> A = 0`
  - `A -> B = 60 min`
  - `B -> A = 45 min`
  - `B -> B = 0`
​
##### Scheduling meaning
​
If Campaign 1 uses `MixingRecipe + BomA`, then its batches resolve to `SKU A`.
​
If Campaign 2 uses `MixingRecipe + BomB`, then its batches resolve to `SKU B`.
​
Consequences:
​
- the same mixing operation may take different durations on the same equipment
- switching from Campaign 1 to Campaign 2 on the same equipment may insert a 60-minute changeover
- switching from Campaign 2 back to Campaign 1 may insert a 45-minute changeover
​
This is the core behavior the model is trying to support.
​
#### 17. Design Principles Behind the Model
​
##### Recipe is process logic
​
The recipe should define the generic process shape.
​
##### BOM is concrete product realization
​
The BOM selects the actual product embodiment of the recipe.
​
##### Material carries product identity
​
The material provides the resolved attribute-value combination that characterizes the produced product.
​
##### Batch is the effective runtime context
​
The batch is where the abstract configuration becomes concrete scheduling behavior.
​
##### Equipment behavior may be product-specific
​
Rates are not assumed to be globally constant.
​
##### Changeovers are transitions, not constants
​
Changeover duration depends on product transition context.
​
#### 18. Operational Consequences
​
The model enables:
​
- one recipe producing multiple SKUs
- equipment rates that vary by SKU
- realistic transition times between product variants
- adaptive stream mapping through BOMs
- more accurate schedule simulation for product-specific production
​
The tradeoff is that the scheduling model becomes more stateful and context-sensitive.
​
This is intentional.
​

## Links
