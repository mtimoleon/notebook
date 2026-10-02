---
categories:
  - "[[Work]]"
created: 2026-02-26
product:
component: Docker
tags:
  - documentation/intelligen
---
Current size = Standard D2s v3
vCpus = 2
RAM = 8 GiB
Threads per core = 2

![[Intelligen-Notes-1790944197308.png|1010x31]]




![[Intelligen-Notes-1790677942839.png|1010x762]]

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





​

​


## Docker


 
> [!IINFO] Docker
> 192.168.56.1 host.docker.internal
> ​192.168.56.1 gateway.docker.internal
> ​127.0.0.1 kubernetes.docker.internal


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