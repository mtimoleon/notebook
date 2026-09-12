---
categories:
  - "[[Work]]"
created: 2026-02-26
product:
component: Docker
tags:
  - documentation/intelligen
---
### 602
![[Intelligen-Notes-1789117978103.png|1010x560]]

### 614
- Simplify handler reusable code
- ~~Move enumeration locator to helpers~~
- ~~Resource type enumeration property write to db~~
- ~~FE does not need to send ordering~~
- Refactoring ChartService

### 632-Operation-duration-based-on-recipe-attribute
#### george
Recipe Operation duration depends from recipe attributes through change over matrices  only, for now.
![[Intelligen-Notes-1788423828972.png|823]]

Add  **Based on recipe attribute** kai apo kato epilegeis paromoia me ayto
![[Intelligen-Notes-1788424218212.png|1010x295]]


### fix examples list

Tabs: Tutorials, Examples, Experimental


![[Intelligen-Notes-1788421702046.png|547]]

Στο example θα βλέπεις μόνο ένα εντρυ που θα έχει όλες τις παραλλαγές.
Δηλαδή με βάση το παρακάτω το example θα είναι Polymer Resin
![[Intelligen-Notes-1788421816421.png|1010x474]]

Άρα πίσω 3 λίστες και θα επιστρέφουμε ένα αντικέιμενο
```json
{
	tutorials:[],
	examples:[],
	experiments:[]
}
```





### error messages display


![[Intelligen-Notes-1787048022189.png]]

Add more error categories 
- Otan recipe based -> is missing recipe
- Otan material based -> is missing pp 
-  -"-                             -> BOM missing recipe
- 

![[Intelligen-Notes-1787048212471.png|646]]


Kaleitai sto layout
![[Intelligen-Notes-1787048232547.png|1010x488]]

![[Intelligen-Notes-1787048296930.png|1010x439]]

Mallon prin mpoyme sti diadiaksia toy layout
![[Intelligen-Notes-1787048332866.png|998]]


![[Intelligen-Notes-1787048437163.png]]


![[Intelligen-Notes-1787049016226.png]]













```
public partial class _600suinventorytracking : Migration
{
    /// <inheritdoc />
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.RenameColumn(
            name: "TrackInventory",
            table: "StorageUnits",
            newName: "EnforceInventoryConstraints");
    }
    /// <inheritdoc />
    protected override void Down(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.RenameColumn(
            name: "EnforceInventoryConstraints",
            table: "StorageUnits",
            newName: "TrackInventory");
    }
}
```


- [x] Entity resolvers
      Change message in delete
      Resolver should return 2 groups of entries blocking and non blocking
      ```
- [ ] ```
  using Common.Dtos;
using Microsoft.Extensions.DependencyInjection;
using Newtonsoft.Json;
using Planning.Api.Helpers;
using Planning.Api.Services;
using Planning.Domain.Aggregates.AttentionCodeAggregate;
using Planning.Domain.Aggregates.BomAggregate;
using Planning.Domain.Aggregates.BranchAggregate;
using Planning.Domain.Aggregates.ChangeoverMatrixAggregate;
using Planning.Domain.Aggregates.CompatibilityTagAggregate;
using Planning.Domain.Aggregates.DisplayProfileAggregate;
using Planning.Domain.Aggregates.EquipmentAggregate;
using Planning.Domain.Aggregates.EquipmentTypeAggregate;
using Planning.Domain.Aggregates.FacilityAggregate;
using Planning.Domain.Aggregates.LaborAggregate;
using Planning.Domain.Aggregates.MaterialAggregate;
using Planning.Domain.Aggregates.OperationAggregate;
using Planning.Domain.Aggregates.OperationEntryAggregate;
using Planning.Domain.Aggregates.OperationLaborAggregate;
using Planning.Domain.Aggregates.OperationStreamAggregate;
using Planning.Domain.Aggregates.OperationTypeAggregate;
using Planning.Domain.Aggregates.ProcedureAggregate;
using Planning.Domain.Aggregates.ProcedureEntryAggregate;
using Planning.Domain.Aggregates.RecipeAggregate;
using Planning.Domain.Aggregates.RecipeAttributeAggregate;
using Planning.Domain.Aggregates.RecipeAttributeValueAggregate;
using Planning.Domain.Aggregates.SectionAggregate;
using Planning.Domain.Aggregates.StaffAggregate;
using Planning.Domain.Aggregates.StorageUnitAggregate;
using Planning.Domain.Aggregates.UserAggregate;
using Planning.Domain.Aggregates.VisibilityOrderingConfigurationAggregate;
using Planning.Domain.Aggregates.WorkspaceAggregate;
using Planning.Domain.Enumerations;
using Planning.Domain.Services;
using Planning.Domain.SharedValueObjects;
using Planning.FunctionalTests.Helpers;
using Planning.Grpc.Dtos;
using Planning.Infrastructure;
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using TestsCommon.Helpers;
using Xunit;
namespace Planning.FunctionalTests
{
	[Collection("SUT1")]
	public class EntityDependencyGraphResolverTests :
		IClassFixture<SutFixture>,
		IClassFixture<SchedulingServiceFixture>
	{
		private PlanningDbContext _context { get; }
		private SutFixture _sutFixture;
		private HttpClient _httpClient;
		private SchedulingService _schedulingService;
		private EntityDependencyGraphResolver _entityDependencyResolver;
		public EntityDependencyGraphResolverTests(SutFixture sutFixture, SchedulingServiceFixture schedulingServiceFixture)
		{
			_sutFixture = sutFixture;
			_schedulingService = schedulingServiceFixture.Service;
			var services = sutFixture.PlanningApiFactory.Services;
			_context = services.CreateScope()
				.ServiceProvider.GetService<PlanningDbContext>(); // Api test context
			// Clear context
			_context.ClearDatabaseForTesting();
			_context.Workspaces.RemoveRange(_context.Workspaces);
			_context.Users.RemoveRange(_context.Users);
			_context.SaveChanges();
			// Restore tests user role to admin
			AuthHandler.ClaimsPrincipal = null;
			_entityDependencyResolver = services.CreateScope()
				.ServiceProvider.GetRequiredService<EntityDependencyGraphResolver>();
			_httpClient = _sutFixture.HttpClient;
		}
		[Fact]
		public async Task ResolveEquipmentDependencies_CompleteWorkspace_ReturnsEveryUsage()
		{
			// Arrange
			Workspace workspace = await CreateWorkspaceWithSchedulingBoard();
			Equipment equipment = workspace.Facilities[0].Equipment[0];
			Staff staff = workspace.Facilities[0].Staff[0];
			var schedulingBoard = workspace.SchedulingBoards[0];
			DisplayProfile displayProfile = schedulingBoard.DisplayProfiles[0];
			var procedureEntry = schedulingBoard.Campaigns[0].Batches[0].ProcedureEntries[0];
			OperationEntry operationEntry = procedureEntry.OperationEntries[1];
			displayProfile.UpdateResources(
				showEquipment: true,
				displayProfile.EquipmentIncludeType,
				[equipment],
				showStaff: true,
				displayProfile.StaffIncludeType,
				[staff]);
			procedureEntry.UpdateMainEquipment(equipment);
			operationEntry.UpdateAuxEquipment([equipment]);
			operationEntry.UpdateTrackingAuxEquipment(
				workspace.User,
				[equipment],
				workspace.AttentionCodes[0],
				"Equipment dependency test");
			await _context.SaveChangesAsync();
			// Act
			IReadOnlyList<DependencyReference> dependencies =
				await _entityDependencyResolver.ResolveAsync(equipment);
			// Assert
			AssertDependency(dependencies, nameof(Procedure), nameof(Procedure.MainEquipmentPool), true);
			AssertDependency(dependencies, nameof(Operation), nameof(Operation.AuxEquipmentPool), true);
			AssertDependency(dependencies, nameof(NonProcessingOperation), nameof(NonProcessingOperation.AuxEquipmentPool), true);
			AssertDependency(dependencies, nameof(OperationEntry), nameof(OperationEntry.AuxEquipment), true);
			AssertDependency(dependencies, nameof(OperationEntry), nameof(OperationEntry.AuxEquipmentPool), true);
			AssertDependency(dependencies, nameof(OperationEntry), "OriginalInformation.AuxEquipment", true);
			AssertDependency(dependencies, nameof(OperationEntry), "TrackingUpdate.AuxEquipment", true);
			AssertDependency(dependencies, nameof(ProcedureEntry), nameof(ProcedureEntry.MainEquipment), true);
			AssertDependency(dependencies, nameof(ProcedureEntry), nameof(ProcedureEntry.MainEquipmentPool), true);
			AssertDependency(dependencies, nameof(ProcedureEntry), "MainEquipmentUpdate.MainEquipment", false);
			AssertDependency(dependencies, nameof(VisibilityOrderingConfiguration), nameof(VisibilityOrderingConfiguration.IncludeOrderEquipment), false);
			AssertDependency(dependencies, nameof(DisplayProfile), nameof(DisplayProfile.SelectedEquipment), false);
		}
		private static void AssertDependency(
			IReadOnlyList<DependencyReference> dependencies,
			string type,
			string memberName,
			bool isDeleteBlocking)
		{
			Assert.Contains(
				dependencies,
				dependency =>
					dependency.Type == type &&
					dependency.MemberName == memberName &&
					dependency.IsDeleteBlocking == isDeleteBlocking);
		}
		[Fact]
		public async Task DeleteEntity()
		{
			// Arrange
			Workspace workspace = await CreateWorkspaceWithSchedulingBoard();
			Equipment equipment1 = workspace.Facilities[0].Equipment[0];
			Equipment equipment2 = workspace.Facilities[0].Equipment[1];
			// Act
			var request = new RequestByIdListDto()
			{
				Requests = new List<RequestByIdDto>()
				{
					new RequestByIdDto() { Id =equipment1.Id, ConcurrencyToken = equipment1.ConcurrencyToken },
					new RequestByIdDto() { Id =equipment2.Id, ConcurrencyToken = equipment2.ConcurrencyToken },
				}
			};
			string requestBody = JsonConvert.SerializeObject(request);
			var httpMessage = new HttpRequestMessage(HttpMethod.Delete, $"planning/{workspace.Id}/equipment/")
			{
				Content = new StringContent(requestBody, Encoding.UTF8, "application/json")
			};
			var response = await _httpClient.SendAsync(httpMessage);
			var contentString = await response.Content.ReadAsStringAsync();
			CommandStatus result = JsonConvert.DeserializeObject<CommandStatus>(contentString);
			// Assert
			Assert.False(result.Success);
			Assert.Equal(Common.Errors.CommonDomainError.ReferenceResourceIsInUseOrNotFoundError.Code, result.ErrorCode);
			Assert.Contains(result.Params, item => item.StartsWith("[Delete blocking]"));
			Assert.Contains(result.Params, item => item.StartsWith("[Non-delete blocking]"));
		}
		private async Task<Workspace> CreateWorkspaceWithSchedulingBoard()
		{
			User user = new User(Guid.Empty, "admin@domain.com");
			Workspace workspace = new Workspace("Workspace", null, user);
			_context.Add(workspace);
			EquipmentType equipmentType = workspace.CreateEquipmentType("EquipmentType");
			RecipeAttribute recipeAttribute1 = workspace.CreateRecipeAttribute("RecipeAttribute1");
			RecipeAttribute recipeAttribute2 = workspace.CreateRecipeAttribute("RecipeAttribute2");
			RecipeAttributeValue recipeAttributeValue1 = recipeAttribute1.CreateRecipeAttributeValue("RecipeAttributeValue1", "RecipeAttributeValue1Description");
			ChangeoverMatrix changeoverMatrix = recipeAttribute1.CreateChangeoverMatrix("ChangeoverMatrix1");
			AttentionCode attentionCode1 = workspace.CreateAttentionCode("AttentionCode1");
			AttentionCode attentionCode2 = workspace.CreateAttentionCode("AttentionCode2");
			CompatibilityTag compatibilityTag1 = workspace.CreateCompatibilityTag("CompatibilityTag1");
			CompatibilityTag compatibilityTag2 = workspace.CreateCompatibilityTag("CompatibilityTag2");
			OperationType operationType = workspace.CreateOperationType("OperationType");
			Material material = workspace.CreateMaterial("Material");
			Facility facility = workspace.CreateFacility("Facility");
			Equipment equipment = facility.CreateEquipment("Equipment");
			equipment.UpdateIdentification(equipment.Name, equipmentType, "EquipmentDescription");
			equipment.UpdateCompatibilityTags([compatibilityTag1, compatibilityTag2]);
			Equipment auxEquipment = facility.CreateEquipment("AuxEquipment");
			auxEquipment.UpdateIdentification(auxEquipment.Name, equipmentType, "AuxEquipmentDescription");
			Labor labor = facility.CreateLabor("Labor");
			Staff staff = facility.CreateStaff("Staff");
			StorageUnit storageUnit = facility.CreateStorageUnit("StorageUnit");
			storageUnit.UpdateType(StorageUnitType.Intermediate);
			Recipe recipe = workspace.CreateRecipe("Recipe");
			recipe.UpdateRecipeAttributeValues(new List<RecipeAttributeValue>() { recipeAttributeValue1 });
			Bom bom = material.CreateBom("Bom");
			bom.AssociateWithRecipe(recipe);
			Branch branch = recipe.CreateBranch("Branch");
			Section section = branch.CreateSection("Section");
			Procedure procedure = section.CreateProcedure("Procedure");
			procedure.UpdateEquipmentCompatibilities(
				false,
				equipmentType,
				new List<Equipment>() { equipment }, false, compatibilityProcedure: null);
			Operation operation1 = procedure.CreateOperation("Operation1", null);
			Operation operation2 = procedure.CreateOperation("Operation2", operation1);
			Operation operation3 = procedure.CreateOperation("Operation3", operation1);
			Operation operation4 = procedure.CreateOperation("Operation4", operation1);
			Time timeShift = Time.FromValue(TimeUnit.h, 1);
			OperationStream operationStream1 = new OperationStream("OperationStream1", material, new SizeAmount(MassUnit.kg, 1));
			operationStream1.UpdateMaterials(true, storageUnit, operationStream1.SizeBasis, operationStream1.Density, new List<OperationStreamIngredient>());
			operationStream1.UpdateSizeBasis(new SizeBasis(PhysicalQuantity.Mass));
			OperationStream operationStream2 = new OperationStream("OperationStream2", material, new SizeAmount(MassUnit.kg, 1));
			operationStream2.UpdateMaterials(true, storageUnit, operationStream2.SizeBasis, operationStream2.Density, new List<OperationStreamIngredient>());
			operationStream1.UpdateSizeBasis(new SizeBasis(PhysicalQuantity.Volume));
			OperationLabor operationLabor = new OperationLabor(
				"OperationLabor",
				labor,
				new LaborBasis(PhysicalQuantity.LaborRate),
				new LaborRate(LaborRateUnit.persons, 1),
				new LaborAmount(LaborAmountUnit.personHours, 1),
				false);
			operation2.UpdateAuxiliaryEquipment(false, equipmentType, false, new List<Equipment>() { equipment }, requiredNumberOfAuxiliaryEquipmentType: RequiredNumberOfItemsType.All, 1);
			operation2.UpdateAuxiliaryEquipment(false, equipmentType, false, new List<Equipment>() { auxEquipment }, requiredNumberOfAuxiliaryEquipmentType: RequiredNumberOfItemsType.All, 1);
			operation2.UpdateDuration(
				OperationDurationMode.EqualToAnotherOperation,
				TimeUnit.h,
				false,
				Time.FromValue(TimeUnit.h, 1),
				false,
				false,
				new FlowBasis(PhysicalQuantity.MassFlow),
				new SizeAmount(MassUnit.kg, 1),
				false,
				new FlowAmount(MassFlowUnit.kg_per_h, 1),
				OperationRateType.Fixed,
				operation1,
				operation1,
				true,
				changeoverMatrix);
			operation2.UpdateGeneral(operation2.Name, operationType, "OperationDescription");
			operation2.UpdateInputStreams([operationStream1]);
			operation2.UpdateInterruptibility(
				true,
				true,
				true,
				true,
				true,
				Time.FromValue(TimeUnit.h, 1),
				false,
				1,
				false,
				Time.FromValue(TimeUnit.h, 1));
			operation2.UpdateLaborResources([operationLabor]);
			operation2.UpdateOutageBehavior(OperationOutageBehavior.Consider);
			operation2.UpdateOutputStreams([operationStream2]);
			operation2.UpdateScheduling(Time.FromValue(TimeUnit.h, 1), OperationSchedulingMode.AnotherOperation, SchedulingLinkRelationship.SS, operation1);
			operation2.UpdateStaff([staff], RequiredNumberOfItemsType.All);
			operation2.UpdateAuxiliaryEquipment(false, equipmentType, true, [equipment],
			requiredNumberOfAuxiliaryEquipmentType: RequiredNumberOfItemsType.All, 1);
			OperationSchedulingLinkBase schedulingLink = new OperationSchedulingLinkBase(operation1, SchedulingLinkRelationship.FS, new Time());
			operation2.UpdateAdditionalSchedulingLinks([schedulingLink]);
			operation2.UpdateFlexibleShiftsAndBreaks(
				false,
				false,
				false,
				false,
				false,
				Time.FromValue(TimeUnit.h, 1),
				false,
				Time.FromValue(TimeUnit.h, 1),
				false,
				1,
				false,
				Time.FromValue(TimeUnit.h, 1));
			var schedulingBoard = workspace.CreateSchedulingBoard("SchedulingBoard-1");
			var campaign1 = schedulingBoard.CreateCampaign("Campaign-1", recipe, 1);
			campaign1.PostChangeoverOperation.UpdateGeneral(operationType, "Post Changeover Operation");
			campaign1.PostChangeoverOperation.UpdateStaff([staff], RequiredNumberOfItemsType.All);
			campaign1.PostChangeoverOperation.UpdateAuxiliaryEquipment(false, equipmentType, false, new List<Equipment>() { equipment }, requiredNumberOfAuxiliaryEquipmentType: RequiredNumberOfItemsType.All, 1);
			campaign1.PostChangeoverOperation.UpdateLaborResources([operationLabor]);
			campaign1.PostChangeoverOperation.UpdateOutputStreams([operationStream2]);
			campaign1.PostChangeoverOperation.UpdateInputStreams([operationStream1]);
			campaign1.UpdateBom(bom);
			schedulingBoard.SchedulingConfiguration.UpdateSchedulingConfiguration(OperationEntryTimingPropagationMode.Full,
				ConstraintHandlingMode.Resolve,
				ConstraintHandlingMode.Resolve,
				ConstraintHandlingMode.Resolve,
				ConstraintHandlingMode.Resolve,
				ConstraintHandlingMode.Resolve,
				ConstraintHandlingMode.Resolve,
				ConstraintHandlingMode.Resolve,
				ConstraintHandlingMode.Resolve,
				ConstraintHandlingMode.Resolve,
				ConstraintHandlingMode.Ignore);
			schedulingBoard.ProductionTrackingConfiguration.UpdateProductionTrackingConfiguration(AttentionCodeRequirementMode.Required, 10, 20);
			var staffDisplayName = "New Staff Display Name";
			var updateStaffDisplayNameData = new List<(Staff Staff, string DisplayName)>()
			{
				new(staff, staffDisplayName)
			};
			schedulingBoard.StaffDisplayNameConfiguration.UpdateStaffDisplayNameConfiguration(updateStaffDisplayNameData);
			schedulingBoard.UpdateProductionEnabled(true);
			schedulingBoard.VisibilityOrderingConfiguration.UpdateVisibilityOrderingConfiguration([equipment],
				[staff],
				includeMainEquipmentUses: true,
				includeMainEquipmentPool: true,
				includeAuxiliaryEquipmentUses: true,
				includeAuxiliaryEquipmentPool: true,
				includeStaffUses: true,
				includeStaffPool: true);
			var project = schedulingBoard.CreateProject("Project 1");
			campaign1.UpdateProject(project);
			var displayProfile1 = schedulingBoard.CreateDisplayProfile("Display Profile 1");
			displayProfile1.UpdateSortings(new List<DisplayProfileSorting>()
			{
				new DisplayProfileSorting("CampaignId", "asc", 1)
			});
			displayProfile1.UpdateColumns(new List<DisplayProfileColumn>()
			{
				new DisplayProfileColumn("CampaignId", 1)
			});
			_schedulingService.ScheduleSchedulingBoard(schedulingBoard);
			schedulingBoard.Campaigns[0].Batches[0].ProcedureEntries[0].UpdateMainEquipmentUpdate(user, equipment, attentionCode1, "updated");
			schedulingBoard.Campaigns[0].UpdateOverrideRecipeAttributeValues(new List<RecipeAttributeValue>() { recipeAttributeValue1 });
			OperationEntry operationEntry1 = schedulingBoard.Campaigns[0].Batches[0].ProcedureEntries[0].OperationEntries[1];
			operationEntry1.UpdateTrackingTiming(
				user,
				operationEntry1.Start + Time.FromValue(TimeUnit.h, 1).TimeSpan,
				Time.FromValue(TimeUnit.h, 1),
				CompletionStatus.Started,
				attentionCode2,
				string.Empty);
			await _context.SaveChangesAsync();
			return workspace;
		}
	}
}
```
      
    
- [x] 600-Storage unit
1. To track inventory θα φύγει απο το others kai tha paei mesa sto inventory limits me  rename se EnforceInventoryConstraints
2. An capacity einai 0 na mi ginetai save apo inventory limits
3. external transfer mode na mi kanei save an capacity einai 0 kai continues
4. capacity info apagoreyetai save me 0 an inventory limits enforceinventoryConstraints = checked kai external trasnfer mode exei capacity
	![[Intelligen-Notes-1783933015143.png|940x493]]
- [x] Otan ayjano ta batches enos campaign kai bazei nea prepei to ordering na pairnei timi meta to teleytaio oxi proto.
	![[Intelligen-Notes-1783689636440.png|940x496]]
- [x] Na mpei sto unscheduleCampaignsFromTo o diaxorismos me to method


- [x] NoAction na g;inei pantoy ClientNoAction
VisibilityOrdering na ginei cascade

- [x] Na diavaso ti diafora NoAction, ClientNoAction



![[Intelligen-Notes-1783667209181.png|940x551]]

```
        

    const retrieveRecipe = async (recipe, dragPathObject, showBranches, showSections) => {
        let showBranchesLocal = false;
        let showSectionsLocal = false;
        let forceShowSectionsLocal = false;
​
        submitBatchTimeAndValidationStatusRequests();
​
        let recipeContentResponse = await recipeService.getRecipeContentById(recipeId);
​
        let transformedEntityList = [];
        let transformedEntityDictionary = {};
        let retrievedRecipe = null;
​
        // Transform data from the server.
        if (recipeContentResponse.success && recipeContentResponse.successfulResult !== null) {
            retrievedRecipe = recipeContentResponse.successfulResult;
		...
	}​
	
	   
    
    
    
    const submitBatchTimeAndValidationStatusRequests = async () => {
        const [timesResponse, validityResponse] = await Promise.all([
            recipeService.getBatchTimeAndCycleTime(recipeId),
            recipeService.getValidationStatus(recipeId)
        ]);
​
        let batchTime = null;
        let cycleTime = null;
        let validationStatus = null;
​
        // Transform data from the server.
        if (timesResponse && timesResponse.successfulResult !== null) {
​
            batchTime = timesResponse.successfulResult.batchTime;
            cycleTime = timesResponse.successfulResult.cycleTime;
        }
​
        //Transform data from the server.
        if (validityResponse.success && validityResponse.successfulResult !== null)
            validationStatus = validityResponse.successfulResult;
​
        setState(prevState => ({
            ...prevState,
            validationStatus: validationStatus,
            batchTime: batchTime,
            cycleTime: cycleTime
        }))
    }
    
    
                        <div
                        style={{ display: "flex", alignItems: "baseline", gap: "10px" }}
                    >
                        <label className="simple-label">Status</label>
​
                        {state.validationStatus !== null
                            ? state.validationStatus.isValid === true
                                ? <span style={{ color: "#05C706", fontWeight: "bold" }}>
                                    Valid
                                </span>
                                : <span>
                                    <button
                                        type="button"
                                        className={"link " + ((state.activeEntity.type === "validity" && state.activeEntity.id === state.recipe.entity.id) ? "active" : "") + (isEnabledPropertyFunctions.recipeStatusLink() ? "" : " disabled")}
                                        style={{ color: "#E02020", fontWeight: "bold" }}
​
                                        onClick={(event) => {
                                            if ((state.activeEntity.type === "validity" && state.activeEntity.id === state.recipe.entity.id) || !isEnabledPropertyFunctions.recipeStatusLink())
                                                return;
​
                                            handleEntityClick(event, state.recipe, state.recipe.entity.id, "validity");
                                        }}
                                    >
                                        Invalid ({state.validationStatus.validityError.length} {state.validationStatus.validityError.length === 1 ? "error" : "errors"})
                                    </button>
                                </span>
                            : <span></span>
                        }
                    </div>
                    
     
     
                 <RecipeValidityInformationSidePanel
                recipeId={state.activeEntity.type === "validity" ? state.activeEntity.id : null}
                validityError={state.activeEntity.type === "validity" ? state.validationStatus.validityError : []}
​
                onCloseClick={handleSidePanelCloseClick}
            />
​
​
```



# Review Notes για Findings 
​
## Πλαίσιο
Το note αυτό συγκεντρώνει με πλήρη εξήγηση τα τρία βασικά σημεία που προέκυψαν από το review του branch:
​
- branch υπό review: `feature/578-Adaptive-recipes-pt.4`
- base branch: `master`
- merge base: `82ea4e39fbcce72917c692a0f878b05e65d7d5aa`
​
Ο στόχος του note δεν είναι απλώς να πει "υπάρχει bug", αλλά να εξηγήσει:
​
- ποια ακριβώς είναι η ροή του κώδικα
- γιατί η συμπεριφορά που βλέπουμε είναι προβληματική
- πότε το κάθε finding είναι ισχυρό και πότε είναι πιο αδύναμο
- ποια είναι η πρακτική επίπτωση στο scheduling
​

---
​
## Finding 1
​
### Σύντομη διατύπωση
Το branch εισάγει per-equipment recipe-attribute-value configuration με δύο διαφορετικές έννοιες:
​
- ειδικό `ProcessingRate`
- flag `IsIncompatible`
​
Όμως το scheduling χρησιμοποιεί το πρώτο και αγνοεί το δεύτερο. Άρα ένα equipment/value pair που έχει δηλωθεί ως incompatible παραμένει πρακτικά schedulable.
​
### Πού φαίνεται στον κώδικα
Το νέο entity που κρατάει τα per-value στοιχεία του equipment είναι εδώ:
​
- [EquipmentRecipeAttributeValue.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Aggregates/EquipmentAggregate/EquipmentRecipeAttributeValue.cs)
​
Κρίσιμο πεδίο:
​
```csharp
public bool IsIncompatible { get; private set; }
```
​
Η ανάκτηση του processing rate γίνεται εδώ:
​
- [Equipment.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Aggregates/EquipmentAggregate/Equipment.cs:323)
​
```csharp
public FlowAmount GetEquipmentProcessingRate(RecipeAttributeValue recipeAttributeValue)
{
    if (recipeAttributeValue != null)
    {
        EquipmentRecipeAttributeValue equipmentRecipeAttributeValue =
            _recipeAttributeValues.FirstOrDefault(rav => rav.RecipeAttributeValue == recipeAttributeValue);
​
        if (equipmentRecipeAttributeValue != null)
            return equipmentRecipeAttributeValue.ProcessingRate;
    }
​
    return ProcessingRate;
}
```
​
Και το rate αυτό χρησιμοποιείται απευθείας στον υπολογισμό duration εδώ:
​
- [OperationEntry.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Aggregates/OperationEntryAggregate/OperationEntry.cs:921)
​
```csharp
durationInRefUnit += ScaledAmountInReferenceUnit / equipment.GetEquipmentProcessingRate(attributeValue).ReferenceUnitValue;
```
​
### Γιατί είναι bug
Το feature μοιάζει να θέλει να υποστηρίξει δύο ξεχωριστούς κανόνες:
​
1. "Για αυτό το attribute value, το equipment τρέχει με διαφορετική ταχύτητα."
2. "Για αυτό το attribute value, το equipment δεν πρέπει να χρησιμοποιείται καθόλου."
​
Στο σημερινό code path εφαρμόζεται μόνο ο πρώτος κανόνας.
​
Η ροή είναι:
​
3. Βρίσκεται το `RecipeAttributeValue` του batch.
4. Ζητείται από το equipment το rate για αυτό το value.
5. Αν υπάρχει override, επιστρέφεται κανονικά.
6. Ο υπολογισμός διάρκειας συνεχίζει.
​
Πουθενά σε αυτό το flow δεν ελέγχεται το `IsIncompatible`.
​
### Παράδειγμα
Έστω:
​
- Recipe Attribute: `Packing Size`
- Values: `200g`, `500g`
- Equipment: `Filler A`
- Batch: έχει `Packing Size = 200g`
​
Ο χρήστης δηλώνει:
​
- `Filler A` + `200g`
  - `ProcessingRate = 300 kg/h`
  - `IsIncompatible = true`
​
Η φυσική ανάγνωση του κανόνα είναι:
​
- το `Filler A` δεν πρέπει να θεωρείται επιτρεπτό για batch με `200g`
​
Αυτό που κάνει τώρα το σύστημα είναι:
​
1. βρίσκει το `200g`
2. καλεί `GetEquipmentProcessingRate(200g)`
3. παίρνει `300 kg/h`
4. συνεχίζει κανονικά το scheduling
​
Άρα το incompatible pair δεν απορρίπτεται. Απλώς διαβάζεται και χρησιμοποιείται το rate του.
​
### Γιατί έχει σημασία
Αυτό είναι καθαρό issue ορθότητας του domain:
​
- ο χρήστης δηλώνει incompatibility
- το σύστημα το αποθηκεύει
- το scheduling το αγνοεί
​
Άρα το UI/API υπόσχεται rule που το domain behavior δεν εφαρμόζει.
​
### Πιθανές κατευθύνσεις για fix
Το fix μπορεί να μπει σε διαφορετικό σημείο, αρκεί να εφαρμοστεί σε scheduling-critical path:
​
1. να αποκλείεται το equipment από τα compatible candidates
2. να απορρίπτεται στο default assignment
3. να απορρίπτεται στο scheduling/duration path
4. να πετάει explicit error όταν ζητηθεί rate για incompatible pair
​
Το κρίσιμο δεν είναι ποιο ακριβώς σημείο θα διαλεγεί. Το κρίσιμο είναι ότι σήμερα το `IsIncompatible` δεν έχει πραγματικό behavioral effect.
​

---
​
## Finding 2
​
### Σύντομη διατύπωση
Το branch αφαίρεσε το παλιό validation που προστάτευε τη σωστή σειρά procedures όταν υπάρχει `MainEquipmentCompatibilityProcedureEntry`, αλλά δεν άλλαξε τον αλγόριθμο default equipment assignment που εξακολουθεί να βασίζεται στο order.
​
Άρα μπορεί πλέον να περάσει configuration που παλιότερα κοβόταν, και μετά το default assignment να καταλήξει σε invalid equipment pairing.
​
### Τι αφαιρέθηκε
Στο `Campaign.Layout()` δεν υπάρχει πια το παλιό validation που προστάτευε αυτό το scenario:
​
- [Campaign.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Aggregates/CampaignAggregate/Campaign.cs:441)
​
Στο προηγούμενο flow υπήρχε λογικά αυτό:
​
```csharp
if (IsProcedurePrecedenceViolated())
    throw new PlanningDomainException(CampaignError.ProcedureMustPrecedeMaster);
```
​
Η ουσία αυτού του validation ήταν:
​
- αν ένα procedure εξαρτάται από main equipment άλλου procedure
- τότε πρέπει η σειρά να είναι τέτοια ώστε το "master" procedure να είναι ήδη γνωστό όταν γίνεται assign το dependent
​
### Τι παραμένει ίδιο
Ο default assignment αλγόριθμος παραμένει σειριακός:
​
- [Batch.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Aggregates/BatchAggregate/Batch.cs:275)
​
```csharp
public void AssignDefaultEquipment()
{
    for (int i = 0; i < ProcedureEntries.Count; i++)
    {
        ProcedureEntries[i].UpdateMainEquipment(
            ProcedureEntries[i].GetCompatibleMainEquipment()[0]
        );
    }
}
```
​
Και το compatibility filter ενεργοποιείται μόνο αν το referenced procedure έχει ήδη επιλεγμένο main equipment:
​
- [ProcedureEntry.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Aggregates/ProcedureEntryAggregate/ProcedureEntry.cs:265)
​
```csharp
if (EnforceMainEquipmentCompatibility && MainEquipmentCompatibilityProcedureEntry.MainEquipment != null)
{
    var referenceEquipment = MainEquipmentCompatibilityProcedureEntry.MainEquipment;
    equipmentList = equipmentList.Where(e => referenceEquipment.IsCompatibleWith(e));
}
```
​
Άρα αν το referenced procedure δεν έχει ακόμα `MainEquipment`, το φίλτρο δεν τρέχει καθόλου.
​
### Παράδειγμα
Έστω δύο procedures:
​
- `Blend`
- `Fill`
​
και ας πούμε ότι:
​
- το `Blend` πρέπει να είναι compatible με το equipment του `Fill`
- αλλά στη σειρά των procedures το `Blend` έρχεται πρώτο
​
Equipment pools:
​
- `Blend`: `Mixer A`, `Mixer B`
- `Fill`: `Filler X`
​
Compatibility:
​
- το `Filler X` είναι compatible μόνο με `Mixer B`
- δεν είναι compatible με `Mixer A`
​
Τι γίνεται τώρα:
​
1. Το `AssignDefaultEquipment()` επεξεργάζεται πρώτο το `Blend`.
2. Το `Blend.GetCompatibleMainEquipment()` κοιτάζει αν το `Fill` έχει ήδη `MainEquipment`.
3. Δεν έχει ακόμα, γιατί δεν έχει γίνει assign.
4. Το compatibility φίλτρο παραλείπεται.
5. Το `Blend` μπορεί να πάρει το πρώτο available equipment, π.χ. `Mixer A`.
6. Μετά το `Fill` παίρνει `Filler X`.
7. Το τελικό pairing είναι incompatible.
​
Με το παλιό validation αυτό το setup κοβόταν νωρίτερα.
​
### Γιατί είναι regression αυτού του branch
Δεν είναι αφηρημένη παρατήρηση πάνω σε παλιό code.
​
Το branch έκανε δύο πράγματα μαζί:
​
1. αφαίρεσε ένα protection rule
2. άφησε ίδιο τον assignment αλγόριθμο που εξακολουθεί να χρειάζεται αυτή την προστασία
​
Άρα έχουμε καθαρή regression εισαγόμενη από αυτή την αλλαγή.
​
### Γιατί έχει σημασία
Το αποτέλεσμα είναι ότι το σύστημα μπορεί:
​
- να μην απορρίπτει invalid procedure configuration
- να παράγει default assignments που εξαρτώνται από τη σειρά
- να δίνει scheduling αποτέλεσμα που παραβιάζει declared compatibility rules
​
### Πιθανά fixes
​
1. επαναφορά του validation
2. redesign του assignment ώστε να λύνει πρώτα τα referenced procedures
3. δεύτερο pass που ξαναφιλτράρει όταν έχουν πλέον γίνει known τα master assignments
​
Αν ζητείται η ελάχιστη ασφαλής διόρθωση, η επαναφορά του validation είναι το πιο άμεσο fix.
​

---
​
## Finding 3
​
### Σύντομη διατύπωση
Το `ScheduleIndependentCampaign()` φαίνεται να εκτελεί scheduling με πιο αδύναμο validation path από άλλα campaign scheduling flows. Αυτό σημαίνει ότι ένα campaign μπορεί να περάσει από scheduling entry point χωρίς να έχει ελεγχθεί το ίδιο σύνολο domain validations που ελέγχεται αλλού.
​
Το σημαντικό caveat είναι ότι στο σημερινό repo δεν βρήκα ξεκάθαρο production call site που να χρησιμοποιεί αυτό το entry point. Άρα το `3` είναι ισχυρό ως inconsistency του domain/API surface, αλλά πιο αδύναμο ως αποδεδειγμένο production bug.
​
### Ποια ήταν η αρχική ανησυχία
Στο branch έχει προστεθεί campaign-level validation που ουσιαστικά απαιτεί η συνταγή του campaign να ταιριάζει με τη συνταγή του BOM:
​
- [Campaign.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Aggregates/CampaignAggregate/Campaign.cs:1074)
​
Η ύπαρξη αυτού του validation σημαίνει ότι το domain πλέον θεωρεί αυτόν τον έλεγχο απαραίτητο για να είναι το campaign valid πριν γίνει scheduling.
​
Το πρόβλημα που εντοπίστηκε ήταν ότι το `ScheduleIndependentCampaign()` δεν φαίνεται να περνάει από το ίδιο validation flow που περνούν άλλες scheduling ροές.
​
### Πού φαίνεται αυτό στον κώδικα
Το public entry point υπάρχει εδώ:
​
- [ISchedulingService.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/ISchedulingService.cs:16)
​
και η υλοποίηση εδώ:
​
- [SchedulingService.cs](C:/Users/michael/developer/scpCloud/Services/Planning/Planning.Domain/Services/SchedulingService.cs:166)
​
Η βασική παρατήρηση ήταν ότι στη ροή του `ScheduleIndependentCampaign()` δεν φαίνεται να προηγείται `Campaign.CheckValidationStatus()` με τον ίδιο τρόπο που γίνεται σε άλλα flows όπου το campaign "στήνεται", "γίνεται layout" ή "προετοιμάζεται" πριν το scheduling.
​
Με απλά λόγια:
​
- υπάρχει νέο validation rule στο campaign
- αλλά υπάρχει scheduling entry point που μοιάζει να το παρακάμπτει
​
### Γιατί αυτό είναι πρόβλημα σε επίπεδο design
Ακόμα και αν αγνοήσουμε για λίγο το αν καλείται ή όχι από production code, υπάρχει μια καθαρή ασυνέπεια στο domain surface:
​
1. Το domain δηλώνει ότι κάποια campaigns είναι invalid.
2. Κάποια scheduling flows σέβονται αυτό το invalid state.
3. Τουλάχιστον ένα public scheduling flow φαίνεται να είναι πιο permissive.
​
Αυτό είναι προβληματικό γιατί αφήνει το contract του service ασαφές.
​
Ένας developer που κοιτάζει το `ISchedulingService` εύλογα θα υποθέσει ότι:
​
- όλα τα scheduling methods εφαρμόζουν το ίδιο baseline validation
​
Αν όμως ένα method είναι λιγότερο αυστηρό, τότε:
​
- ή το contract είναι λάθος
- ή λείπει validation
- ή το method είναι intended μόνο για εσωτερική/ειδική χρήση αλλά αυτό δεν είναι ξεκάθαρο από το API
​
### Παράδειγμα για να γίνει πιο συγκεκριμένο
Έστω campaign `C1` με:
​
- `Campaign.Recipe = Recipe A`
- `Bom.Recipe = Recipe B`
​
και ας θεωρήσουμε ότι το νέο domain rule λέει ότι αυτό είναι invalid setup.
​
Τότε υπάρχουν δύο πιθανά scheduling paths:
​
1. Path A:
   - γίνεται πρώτα το validation/lifecycle του campaign
   - το invalid state εντοπίζεται
   - το scheduling απορρίπτεται
​
2. Path B:
   - καλείται `ScheduleIndependentCampaign()`
   - το validation δεν εφαρμόζεται στο ίδιο επίπεδο
   - το scheduling συνεχίζει
​
Αν ισχύει αυτό, τότε το ίδιο invalid campaign:
​
- σε ένα path απορρίπτεται
- σε άλλο path προχωράει
​
Αυτό είναι ασυνέπεια συμπεριφοράς ανεξάρτητα από το αν σήμερα το path B εκτίθεται σε τελικό χρήστη.
​
### Τι έλεγξα για τη χρήση του
Έψαξα τα call sites του `ScheduleIndependentCampaign()`.
​
Το αποτέλεσμα ήταν:
​
- βρέθηκε στο public interface `ISchedulingService`
- βρέθηκε στην υλοποίηση του service
- βρέθηκε σε tests
​
Δεν βρήκα καθαρό production caller όπως:
​
- command handler
- gRPC endpoint
- application service flow
- background job orchestration
​
που να το καλεί άμεσα στο σημερινό codebase.
​
Αυτό είναι πολύ σημαντικό, γιατί αλλάζει το πόσο "βαρύ" είναι το finding.
​
### Τι σημαίνει αυτό για τη βαρύτητα του finding
Το `3` δεν είναι στο ίδιο confidence level με τα `1` και `2`.
​
Για τα `1` και `2` μπορούμε να πούμε:
​
- υπάρχει σαφές code path
- υπάρχει σαφής behavioral επίπτωση
- το branch εισάγει ή αφήνει ενεργό το bug σε ρεαλιστική ροή
​
Για το `3` μπορούμε να πούμε με σιγουριά μόνο ότι:
​
- υπάρχει public scheduling entry point με διαφορετικό validation behavior
​
Αλλά δεν μπορούμε να πούμε με την ίδια σιγουριά ότι:
​
- αυτό το path είναι σήμερα production-reachable από UI/API flow
​
### Άρα είναι bug ή όχι;
Η σωστή απάντηση είναι:
​
- ως domain/API inconsistency: ναι, είναι πραγματική και αξίζει παρατήρηση
- ως high-confidence production regression: όχι με τα σημερινά στοιχεία, δεν είναι τόσο ισχυρό
​
Αν το `ScheduleIndependentCampaign()` είναι όντως intended μόνο για εσωτερική χρήση, tests ή ειδικά controlled scenarios, τότε είναι πιθανό το χαλαρότερο validation να είναι αποδεκτό ή έστω λιγότερο επικίνδυνο.
​
Αν όμως στο μέλλον χρησιμοποιηθεί από πραγματικό application flow, τότε η ασυνέπεια αυτή μπορεί εύκολα να μετατραπεί σε κανονικό production bug.
​
### Πρακτικό συμπέρασμα
Το σωστό framing για το `3` είναι το εξής:
​
- δεν είναι τόσο ισχυρό finding όσο τα `1` και `2`
- δεν το πετάμε τελείως, γιατί δείχνει ασυνέπεια στο domain contract
- αν το review θέλει μόνο αποδεδειγμένα production-impact issues, το `3` μάλλον πρέπει να υποβαθμιστεί ή να μείνει εκτός
- αν το review θέλει και API/domain consistency risks, τότε το `3` αξίζει να μείνει ως χαμηλότερης βαρύτητας παρατήρηση
​
### Τι θα το έκανε ισχυρότερο
Το finding θα γινόταν πολύ πιο ισχυρό αν βρίσκαμε έστω ένα από τα παρακάτω:
​
1. production handler που καλεί `ScheduleIndependentCampaign()`
2. UI/API flow που καταλήγει εκεί
3. test που δείχνει ότι invalid campaign περνάει από εκεί ενώ απορρίπτεται αλλού
4. explicit comment ή contract που λέει ότι το method πρέπει να εφαρμόζει ίδιο validation με τα υπόλοιπα scheduling flows
​
Χωρίς αυτά, το `3` πρέπει να παρουσιάζεται με προσοχή και όχι στο ίδιο severity με τα άλλα δύο.
​

---
​
## Τελικό συμπέρασμα
​
### Για το 1
Ισχυρό behavioral bug. Το branch αποθηκεύει incompatibility rule αλλά το scheduling δεν το εφαρμόζει.
​
### Για το 2
Ισχυρό behavioral bug. Αφαιρέθηκε validation που ο σημερινός assignment αλγόριθμος εξακολουθεί να χρειάζεται.
​
### Για το 3
Πλήρως έγκυρη παρατήρηση ως inconsistency του public scheduling surface, αλλά όχι εξίσου ισχυρό production-impact finding χωρίς επιπλέον απόδειξη ότι το `ScheduleIndependentCampaign()` χρησιμοποιείται από πραγματική εφαρμοστική ροή.
​


```
docker exec -it sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "password" -Q "BACKUP DATABASE [database-name] TO DISK='/var/opt/mssql/backup/keycloak.bak'"
```


Discussion
[BOM-material changes in regard of Storage units, concurrency problems](file:///D:/develop-tasks/Recordings/Recording%202026-05-13%20113639-Storage-uints-BOM-materials-chenges.mp4)

Naming test methods: `<Method name>_<Condition or arrange part of test description>_<Outcome or what we assert>`


Create a new ConsumableUse into production application as inherit from RateUse

![[Intelligen-Notes-1774515864301.png|930x387]]

TimingInfoType = Planning/Tracking/Original
And then we need to implement OriginalAuxiliaryEquipment/Staff in OperationEntry
And then we need to change the scheduling algorithm to take the original



![[Intelligen-Notes-1773318667345.png|719]]

 
> [!IINFO] Docker
> 192.168.56.1 host.docker.internal
> ​192.168.56.1 gateway.docker.internal
> ​127.0.0.1 kubernetes.docker.internal



- Στο library έχουμε useUTC αλλά στο caption text δεν το λαμβάνει υπόψη.
- Νομίζω ότι δείχνεις tooltip και σε break bars; Το θέλουμε αυτό;



Όταν ένα tooltip εμφανίζεται *πάνω* από το element που “hover-άρεις”, μπορεί να “κλέψει” τα pointer events.
Στο δικό σου `Tooltip.jsx` έχεις:
- όταν φαίνεται: `pointerEvents: "auto"` (`WebApps/CommonSpa/libraries/fluidence-gantt/components/Tooltip.jsx:209`)
- όταν κρύβεται: `pointerEvents: "none"`
Τι πάει στραβά:
1) Ο χρήστης έχει τον κέρσορα πάνω σε bar → γίνεται `onPointerMove/onPointerEnter` στο bar και καλείς `tooltipRef.current.show(...)`.
2) Το tooltip εμφανίζεται με `position: fixed` και μεγάλο `z-index` (CSS `z-index: 99999` στο `gantt.css`), άρα μπορεί να βρεθεί *κάτω από τον κέρσορα*.
3) Επειδή έχει `pointer-events: auto`, ο browser θεωρεί ότι τώρα ο κέρσορας είναι “πάνω στο tooltip”, όχι “πάνω στο bar”.
4) Το bar παίρνει `pointerleave` → εσύ καλείς `hide()` στο `onPointerLeave`.
5) Το tooltip εξαφανίζεται, ο κέρσορας ξαναβρίσκεται πάνω στο bar → ξαναεμφανίζεται.
Αυτό δημιουργεί flicker/τρέμουλο και “σπασμένο” hover.
Για tooltips που είναι καθαρά display (όχι clickable), η συνήθης λύση είναι:
- να έχει το tooltip **πάντα** `pointer-events: none` ώστε να μη μπορεί ποτέ να intercept-άρει hover/move/leave από το bar.
Αν κάποια στιγμή θες tooltip με clickable περιεχόμενο, τότε χρειάζεται διαφορετικό interaction model (π.χ. open on click, ή delay + hover state που λαμβάνει υπόψη και tooltip, κτλ.).


**Code quality / Performance**
- onPointerMove καλεί αρκετά “βαριά” computations σε κάθε mouse move (merge/subtract intervals + πολλαπλά getBoundingClientRect) μέσα στο BarChart.jsx (WebApps/CommonSpa/libraries/fluidence-gantt/components/BarChart.jsx:373 και χρήση στο :913), κάτι που μπορεί να κοστίσει σε μεγάλους πίνακες. Συνήθως θες throttle με requestAnimationFrame ή να κάνεις update μόνο όταν αλλάζει target bar / segment.
- Στο Tooltip.jsx χρησιμοποιείς autoUpdate μόνο σαν “scheduler” (ok), αλλά το positioning logic είναι custom και αρκετά “tight” (π.χ. const left = maxLeft; WebApps/CommonSpa/libraries/fluidence-gantt/components/Tooltip.jsx:110) → το tooltip θα “κολλάει” προς μια πλευρά, όχι ιδανικό οπτικά.


​```
c:\Code\ScpCloud>docker compose -f "C:\Code\ScpCloud\docker-compose.yml" -f "C:\Code\ScpCloud\docker-compose. override.yml" -f "C:\Code\ScpCloud\docker-compose.azure.yml" build nosqldata
c:\Code\ScpCloud>docker compose -f "C:\Code\ScpCloud\docker-compose.yml" -f "C:\Code\ScpCloud\docker-compose.override.yml" -f "C:\Code\ScpCloud\docker-compose.azure.yml" build sqldata
c:\Code\ScpCloud>docker compose -f "C:\Code\ScpCloud\docker-compose.yml" - "C:\Code\ScpCloud\docker-compose.override.yml" -f "C:\Code\ScpCloud\docker-compose.azure.yml" build sqldata
```
`docker push scpcloud.azurecr.io/nosqldata`
`az storage file copy --help`
​
`az storage file delete --share-name scpnosqldata-new --path "/_tmp"`




Docker compose command to build BE:

```bash
docker compose  -f "C:\Users\michael\developer\scpCloud\docker-compose.yml" -f "C:\Users\michael\developer\scpCloud\docker-compose.override.yml" -f "C:\Users\michael\developer\scpCloud\obj\Docker\docker-compose.vs.debug.g.yml" -f "C:\Users\michael\developer\scpCloud\docker-compose.vs.debug.yml" -p dockercompose15380257336922976358 --ansi never build admin-api keycloak mssqlscripts nosqldata planning-api production-api rabbitmq sqldata webadminbff webplanningbff webproductionbff
```

και μετά για up:
```shell
docker compose  -f "C:\Users\michael\developer\scpCloud\docker-compose.yml" -f "C:\Users\michael\developer\scpCloud\docker-compose.override.yml" -f "C:\Users\michael\developer\scpCloud\obj\Docker\docker-compose.vs.debug.g.yml" -f "C:\Users\michael\developer\scpCloud\docker-compose.vs.debug.yml" -p dockercompose15380257336922976358 up -d
```

### Μεταβλητή για να μη γράφεις συνέχεια paths
Σε PowerShell:
```
$ComposeFiles = @(​  "-f", "C:\Users\michael\developer\ScpCloud\docker-compose.yml",​  "-f", "C:\Users\michael\developer\ScpCloud\docker-compose.override.yml",​  "-f", "C:\Users\michael\developer\ScpCloud\docker-compose.azure.yml"​)
```
Μετά όλα τα commands γίνονται πιο καθαρά.
### Έλεγχος τελικού merged compose
```
docker compose @ComposeFiles config
```
Για να δεις μόνο το `keycloak` service:
```
docker compose @ComposeFiles config keycloak
```
Κοίτα να έχεις:
```
command:​  - start​  - --optimized
```
και όχι `start-dev`.
### Build
Κανονικό build:
```
docker compose @ComposeFiles build keycloak
```
Force rebuild χωρίς cache:
```
docker compose @ComposeFiles build --no-cache keycloak
```
Με plain progress για να βλέπεις καθαρά το `kc.sh build`:
```
docker compose @ComposeFiles build --no-cache --progress=plain keycloak
```
### Up τοπικά
Build και start:
```
docker compose @ComposeFiles up --build keycloak
```
Force recreate:
```
docker compose @ComposeFiles up --build --force-recreate keycloak
```
Detached mode:
```
docker compose @ComposeFiles up -d --build --force-recreate keycloak
```
### Logs
```
docker compose @ComposeFiles logs -f keycloak
```
Τελευταίες 200 γραμμές:
```
docker compose @ComposeFiles logs --tail=200 keycloak
```
Θες να **μην** βλέπεις αυτό:
```
Changes detected in configuration. Updating the server image.
```
### Show config μέσα από Keycloak
Αν το container τρέχει:
```
docker compose @ComposeFiles exec keycloak /opt/keycloak/bin/kc.sh show-config
```
Αν θες one-off container:
```
docker compose @ComposeFiles run --rm keycloak show-config
```
Έλεγξε ότι υπάρχουν:
```
kc.db = mssql​kc.transaction-xa-enabled = false
```
### Stop / down
Stop χωρίς διαγραφή containers:
```
docker compose @ComposeFiles stop keycloak
```
Down για τα services του compose:
```
docker compose @ComposeFiles down
```
Down και διαγραφή volumes:
```
docker compose @ComposeFiles down -v
```
Προσοχή: το `-v` σβήνει volumes. Αν έχεις local DB volume, θα χαθούν τα δεδομένα.
### Clean μόνο για Keycloak container/image
Σταμάτημα και αφαίρεση container:
```
docker compose @ComposeFiles rm -sf keycloak
```
Καθάρισμα dangling images/build cache:
```
docker builder prune
```
Πιο επιθετικό καθάρισμα build cache:
```
docker builder prune -a
```
Προσοχή: το `-a` πετάει περισσότερη cache και τα επόμενα builds θα αργήσουν.
### Full local clean test
```
docker compose @ComposeFiles down​docker compose @ComposeFiles rm -sf keycloak​docker builder prune -f​docker compose @ComposeFiles build --no-cache --progress=plain keycloak​docker compose @ComposeFiles up --force-recreate keycloak
```
### Push μετά το build
Αν το `image:` είναι δηλωμένο στο compose:
```
docker compose @ComposeFiles push keycloak
```
Αλλιώς με explicit tag:
```
docker tag <local-keycloak-image> <your-registry>.azurecr.io/keycloak:<tag>​docker push <your-registry>.azurecr.io/keycloak:<tag>
```
### Χρήσιμο debug command
Για να δεις ποια env περνάνε τελικά:
```
docker compose @ComposeFiles config | Select-String -Pattern "KC_DB|KC_TRANSACTION_XA_ENABLED|KC_DB_URL|KC_PROXY_HEADERS|command"
```