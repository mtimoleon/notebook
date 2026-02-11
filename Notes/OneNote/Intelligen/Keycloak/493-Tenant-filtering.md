- [x] Add tenantId to keycloak users during registration  
- [x] Update realm setting ScpCloud-realm.json users  
- [x] Update realm setting ScpCloud-realm.json ==scpCloud-client-scope== (not the dedicated) mappers  
- [x] Update postman collection for production keycloak migration  
- [x] Update keycloak token claims in code (client scope mappers)  
- [x] Rename OrganizationId to TenantId in Workspace entity (needs migration)  
- [x] Check how tenantId goes to production db to create db in mongo  
- [x] In mongo remove the o-… from database names  
- [x] _productionSchedulingBoardServiceContract.PublishSchedulingBoardAsync  
- [x] _productionSchedulingBoardServiceContract.RepublishTrackingToProductionSchedulingBoardAsync  
- [x] _productionSchedulingBoardServiceContract.TrackingSyncSchedulingBoardAsync  
- [x] Schduling board deletion handler and also relative events  
- [x] During sync pass the workspaceUserId, workspaceTenantId in the relative dto and utilize it in the db creation  
- [x] In mongo metadata rename tenantId to workspacetenantId  
- [x] In mongo metadata add workspaceUserId (is the user who created the workspace)
   

|   |   |   |   |   |
|---|---|---|---|---|
|User|TenantId|Workspace-SchedulingBoard|WorkspaceUser|WorkspaceTenant|
|Admin2||Admin2|Admin2||
|User|1||||
|User1|1|User1|User1|1|
|User2||User2|User2||
   

|   |   |   |   |   |
|---|---|---|---|---|
|User|TenantId|Workspace-SchedulingBoard|Action|Result|
|Admin2||Admin2|Read|Admin2, User1, User2|
|Admin2|||Enable production for any sb|Creates database with sb worskpace creator workspaceUser|
|Admin2|||Sync any sb|Sync|
|Admin2|||Delete any sb|Deletes|
|User|1|User1|Enable production|Creates database with user1 workspaceUser|
|User|1|User2|Enable production|CANNOT|
|User|1||Reads same tenant sb|Reads database of User1|
|User|1||Sync User1 sb|Syncs database of User1|
|User|1||Delete production User1|deletes|
|User|1||Delete production User2|CANNOT|
|User|1||Enable production, sync, delete datbase, sync|Return error for database not exist|
|User1|1|User1|Sync|syncs|
|User1|1|User1|Delete production User1|deletes|
|User2||User2|Read||
|Service|1||Read|reads operation entries|
   

Inside providers we get **organizationId** from token organizationId claim, but when it comes to user update info we are searching for **organizationName**
 
|   |   |   |   |   |
|---|---|---|---|---|
|**ADMIN REGISTRATION**|**PLANNING DB****￼****USER**|**PLANNING API RequestInfoProvider**|**PRODUCTION API****￼****RequestInfoProvider**|**TOKEN**|
|Id|||||
|==UserId==|==Id==|||==sub==|
||ConcurrencyToken||||
||==Username==|==username==||==username==|
|FirstName|FirstName|==firstName==||==firstName==|
|MiddleName|MiddleName||||
|LastName|LastName|==lastName==||==lastName==|
|JobTitle|JobTitle|==jobTitle==||==jobTitle==|
|Industry|Industry||||
|OrganizationType|OrganizationType||||
|OrganizationName|OrganizationName|==organizationName==||==organizationName==|
|OrganizationWebsite|OrganizationWebsite||||
|AddressLine|AddressLine||||
|ZipCode|ZipCode||||
|City|City||||
|Country|country|==country==||==country==|
|Email|Email|==email==||==email==|
|PhoneNumber|PhoneNumber||||
|RegistrationStatus|||||
||||==isAdmin==|==isAdmin==|
||||==tenantId==|==tenantId==|
|||||exp|
|||||iat|
|||||auth_time|
|||||jti|
|||||iss|
|||||aud|
|||||typ|
|||||azp|
|||||nonce|
|||||session_state|
|||||allowed-origins|
|||||scope|
|||||sid|

```
                        //if (typeof(T) == typeof(Workspace))
                        //{
                        //        workspaceExpression = parameter;
                        //}
                        //else if (typeof(T) == typeof(SchedulingBoard))
                        //{
                        //        // e.SchedulingBoard.Workspace

                        //        workspaceExpression = Expression.PropertyOrField(parameter, nameof(SchedulingBoard.Workspace));
                        //}
                        //else if (typeof(T) == typeof(Project))
                        //{
                        //        // e.SchedulingBoard
                        //        var schedulingBoardExpr = Expression.PropertyOrField(parameter, nameof(Project.SchedulingBoard));

                        //        // e.SchedulingBoard.Workspace
                        //        workspaceExpression = Expression.PropertyOrField(schedulingBoardExpr, nameof(SchedulingBoard.Workspace));
                        //}
                        //else if (typeof(T) == typeof(Campaign))
                        //{
                        //        // e.SchedulingBoard
                        //        var schedulingBoardExpr =
                        //                Expression.PropertyOrField(parameter, nameof(Campaign.SchedulingBoard));

                        //        // e.SchedulingBoard.Workspace
                        //        workspaceExpression =
                        //                Expression.PropertyOrField(schedulingBoardExpr, nameof(SchedulingBoard.Workspace));
                        //}

                        //BinaryExpression finalBodyExpression = GetWorkspaceBodyExpression(workspaceExpression, workspaceIdOptional);

                        //Expression\<Func\> filterSchedulingBoardExpression =
                        //        Expression.Lambda\<Func\>(
                        //                finalBodyExpression,
                        //                parameter
                        //        );

                        //return filterSchedulingBoardExpression;
```
                  

```
if (ServiceContractName == nameof(SchedulingBoard))￼{￼        modelBuilder.Entity\<SchedulingBoard\>().HasQueryFilter(_entityQueryFilterFactory.GetQueryFilter\<SchedulingBoard\>(workspaceIdOptional: true));￼}￼else￼{￼        modelBuilder.Entity\<Workspace\>().HasQueryFilter(_entityQueryFilterFactory.GetQueryFilter\<Workspace\>());￼ ￼        modelBuilder.Entity\<SchedulingBoard\>().HasQueryFilter(_entityQueryFilterFactory.GetQueryFilter\<SchedulingBoard\>(workspaceIdOptional: true));￼ ￼        modelBuilder.Entity\<Project\>().HasQueryFilter(_entityQueryFilterFactory.GetQueryFilter\<Project\>(workspaceIdOptional:true));￼        modelBuilder.Entity\<Campaign\>().HasQueryFilter(_entityQueryFilterFactory.GetQueryFilter\<Campaign\>());￼        modelBuilder.Entity\<Batch\>().HasQueryFilter(_entityQueryFilterFactory.GetQueryFilter\<Batch\>());￼                e =\>
```
   

```
			if (ServiceContractName != null)
			{
				if (ServiceContractName == nameof(SchedulingBoard))
				{
					modelBuilder.Entity().HasQueryFilter(e =\>
						(_requestInfoProvider.WorkspaceId == null || e.Workspace.Id == _requestInfoProvider.WorkspaceId)
						&& (e.Workspace.UserId == _requestInfoProvider.UserId
							|| e.Workspace.OrganizationId == _requestInfoProvider.OrganizationId
							|| _requestInfoProvider.UserIsAdmin));
				}
				else
				{
					modelBuilder.Entity().HasQueryFilter(e =\>
						e.UserId == _requestInfoProvider.UserId
						|| e.OrganizationId == _requestInfoProvider.OrganizationId
						|| _requestInfoProvider.UserIsAdmin);

					modelBuilder.Entity().HasQueryFilter(e =\>
						(_requestInfoProvider.WorkspaceId == null || e.Workspace.Id == _requestInfoProvider.WorkspaceId)
						&& (e.Workspace.UserId == _requestInfoProvider.UserId
							|| e.Workspace.OrganizationId == _requestInfoProvider.OrganizationId
							|| _requestInfoProvider.UserIsAdmin));

					modelBuilder.Entity().HasQueryFilter(e =\>
						(_requestInfoProvider.WorkspaceId == null || e.SchedulingBoard.Workspace.Id == _requestInfoProvider.WorkspaceId)
						&& (e.SchedulingBoard.Workspace.UserId == _requestInfoProvider.UserId
							|| e.SchedulingBoard.Workspace.OrganizationId == _requestInfoProvider.OrganizationId
							|| _requestInfoProvider.UserIsAdmin));

					modelBuilder.Entity().HasQueryFilter(e =\>
						(e.SchedulingBoard.Workspace.Id == _requestInfoProvider.WorkspaceId)
						&& (e.SchedulingBoard.Workspace.UserId == _requestInfoProvider.UserId
							|| e.SchedulingBoard.Workspace.OrganizationId == _requestInfoProvider.OrganizationId
							|| _requestInfoProvider.UserIsAdmin));
					modelBuilder.Entity().HasQueryFilter(e =\>
						(e.Campaign.SchedulingBoard.Workspace.Id == _requestInfoProvider.WorkspaceId)
						&& (e.Campaign.SchedulingBoard.Workspace.UserId == _requestInfoProvider.UserId
							|| e.Campaign.SchedulingBoard.Workspace.OrganizationId == _requestInfoProvider.OrganizationId
							|| _requestInfoProvider.UserIsAdmin));
					modelBuilder.Entity().HasQueryFilter(e =\>
						(e.Batch.Campaign.SchedulingBoard.Workspace.Id == _requestInfoProvider.WorkspaceId)
						&& (e.Batch.Campaign.SchedulingBoard.Workspace.UserId == _requestInfoProvider.UserId
							|| e.Batch.Campaign.SchedulingBoard.Workspace.OrganizationId == _requestInfoProvider.OrganizationId
							|| _requestInfoProvider.UserIsAdmin));
					modelBuilder.Entity().HasQueryFilter(e =\>
						(e.ProcedureEntry.Batch.Campaign.SchedulingBoard.Workspace.Id == _requestInfoProvider.WorkspaceId)
						&& (e.ProcedureEntry.Batch.Campaign.SchedulingBoard.Workspace.UserId == _requestInfoProvider.UserId
						|| e.ProcedureEntry.Batch.Campaign.SchedulingBoard.Workspace.OrganizationId == _requestInfoProvider.OrganizationId
						|| _requestInfoProvider.UserIsAdmin));

					modelBuilder.Entity().HasQueryFilter(e =\>
						(e.Workspace.Id == _requestInfoProvider.WorkspaceId)
						&& (e.Workspace.UserId == _requestInfoProvider.UserId
							|| e.Workspace.OrganizationId == _requestInfoProvider.OrganizationId
							|| _requestInfoProvider.UserIsAdmin));
					modelBuilder.Entity().HasQueryFilter(e =\>
						(e.Facility.Workspace.Id == _requestInfoProvider.WorkspaceId)
						&& (e.Facility.Workspace.UserId == _requestInfoProvider.UserId
							|| e.Facility.Workspace.OrganizationId == _requestInfoProvider.OrganizationId
							|| _requestInfoProvider.UserIsAdmin));
					modelBuilder.Entity().HasQueryFilter(e =\>
						(e.Facility.Workspace.Id == _requestInfoProvider.WorkspaceId)
						&& (e.Facility.Workspace.UserId == _requestInfoProvider.UserId
							|| e.Facility.Workspace.OrganizationId == _requestInfoProvider.OrganizationId
							|| _requestInfoProvider.UserIsAdmin));
					modelBuilder.Entity().HasQueryFilter(e =\>
						(e.Facility.Workspace.Id == _requestInfoProvider.WorkspaceId)
						&& (e.Facility.Workspace.UserId == _requestInfoProvider.UserId
							|| e.Facility.Workspace.OrganizationId == _requestInfoProvider.OrganizationId
							|| _requestInfoProvider.UserIsAdmin));
					modelBuilder.Entity().HasQueryFilter(e =\>
						(e.Facility.Workspace.Id == _requestInfoProvider.WorkspaceId)
						&& (e.Facility.Workspace.UserId == _requestInfoProvider.UserId
							|| e.Facility.Workspace.OrganizationId == _requestInfoProvider.OrganizationId
							|| _requestInfoProvider.UserIsAdmin));
```
   

```
					modelBuilder.Entity().HasQueryFilter(e =\>
						(e.Workspace.Id == _requestInfoProvider.WorkspaceId)
						&& (e.Workspace.UserId == _requestInfoProvider.UserId
							|| e.Workspace.OrganizationId == _requestInfoProvider.OrganizationId
							|| _requestInfoProvider.UserIsAdmin));
					modelBuilder.Entity().HasQueryFilter(e =\>
						(e.Recipe.Workspace.Id == _requestInfoProvider.WorkspaceId)
						&& (e.Recipe.Workspace.UserId == _requestInfoProvider.UserId
							|| e.Recipe.Workspace.OrganizationId == _requestInfoProvider.OrganizationId
							|| _requestInfoProvider.UserIsAdmin));
					modelBuilder.Entity().HasQueryFilter(e =\>
						(e.Branch.Recipe.Workspace.Id == _requestInfoProvider.WorkspaceId)
						&& (e.Branch.Recipe.Workspace.UserId == _requestInfoProvider.UserId
							|| e.Branch.Recipe.Workspace.OrganizationId == _requestInfoProvider.OrganizationId
							|| _requestInfoProvider.UserIsAdmin));
					modelBuilder.Entity().HasQueryFilter(e =\>
						(e.Section.Branch.Recipe.Workspace.Id == _requestInfoProvider.WorkspaceId)
						&& (e.Section.Branch.Recipe.Workspace.UserId == _requestInfoProvider.UserId
							|| e.Section.Branch.Recipe.Workspace.OrganizationId == _requestInfoProvider.OrganizationId
							|| _requestInfoProvider.UserIsAdmin));
					modelBuilder.Entity().HasQueryFilter(e =\>
						(e.Procedure.Section.Branch.Recipe.Workspace.Id == _requestInfoProvider.WorkspaceId)
						&& (e.Procedure.Section.Branch.Recipe.Workspace.UserId == _requestInfoProvider.UserId
							|| e.Procedure.Section.Branch.Recipe.Workspace.OrganizationId == _requestInfoProvider.OrganizationId
							|| _requestInfoProvider.UserIsAdmin));

					modelBuilder.Entity().HasQueryFilter(e =\>
						(e.Workspace.Id == _requestInfoProvider.WorkspaceId)
						&& (e.Workspace.UserId == _requestInfoProvider.UserId
							|| e.Workspace.OrganizationId == _requestInfoProvider.OrganizationId
							|| _requestInfoProvider.UserIsAdmin));

					modelBuilder.Entity().HasQueryFilter(e =\>
						(e.Workspace.Id == _requestInfoProvider.WorkspaceId)
						&& (e.Workspace.UserId == _requestInfoProvider.UserId
							|| e.Workspace.OrganizationId == _requestInfoProvider.OrganizationId
							|| _requestInfoProvider.UserIsAdmin));

					modelBuilder.Entity().HasQueryFilter(e =\>
						(e.Workspace.Id == _requestInfoProvider.WorkspaceId)
						&& (e.Workspace.UserId == _requestInfoProvider.UserId
							|| e.Workspace.OrganizationId == _requestInfoProvider.OrganizationId
							|| _requestInfoProvider.UserIsAdmin));

					modelBuilder.Entity().HasQueryFilter(e =\>
						(e.Workspace.Id == _requestInfoProvider.WorkspaceId)
						&& (e.Workspace.UserId == _requestInfoProvider.UserId
							|| e.Workspace.OrganizationId == _requestInfoProvider.OrganizationId
							|| _requestInfoProvider.UserIsAdmin));

					modelBuilder.Entity().HasQueryFilter(e =\>
						(e.Workspace.Id == _requestInfoProvider.WorkspaceId)
						&& (e.Workspace.UserId == _requestInfoProvider.UserId
							|| e.Workspace.OrganizationId == _requestInfoProvider.OrganizationId
							|| _requestInfoProvider.UserIsAdmin));
					modelBuilder.Entity().HasQueryFilter(e =\>
						(e.RecipeClassification.Workspace.Id == _requestInfoProvider.WorkspaceId)
						&& (e.RecipeClassification.Workspace.UserId == _requestInfoProvider.UserId
							|| e.RecipeClassification.Workspace.OrganizationId == _requestInfoProvider.OrganizationId
							|| _requestInfoProvider.UserIsAdmin));

					modelBuilder.Entity().HasQueryFilter(e =\>
						(e.Workspace.Id == _requestInfoProvider.WorkspaceId)
						&& (e.Workspace.UserId == _requestInfoProvider.UserId
							|| e.Workspace.OrganizationId == _requestInfoProvider.OrganizationId
							|| _requestInfoProvider.UserIsAdmin));

					modelBuilder.Entity().HasQueryFilter(e =\>
						(e.Workspace.Id == _requestInfoProvider.WorkspaceId)
						&& (e.Workspace.UserId == _requestInfoProvider.UserId
							|| e.Workspace.OrganizationId == _requestInfoProvider.OrganizationId
							|| _requestInfoProvider.UserIsAdmin));

					modelBuilder.Entity().HasQueryFilter(e =\>
						(e.SchedulingBoard.Workspace.Id == _requestInfoProvider.WorkspaceId)
						&& (e.SchedulingBoard.Workspace.UserId == _requestInfoProvider.UserId
							|| e.SchedulingBoard.Workspace.OrganizationId == _requestInfoProvider.OrganizationId
							|| _requestInfoProvider.UserIsAdmin));

					modelBuilder.Entity().HasQueryFilter(e =\>
						(e.SchedulingBoard.Workspace.Id == _requestInfoProvider.WorkspaceId)
						&& (e.SchedulingBoard.Workspace.UserId == _requestInfoProvider.UserId
							|| e.SchedulingBoard.Workspace.OrganizationId == _requestInfoProvider.OrganizationId
							|| _requestInfoProvider.UserIsAdmin));

					modelBuilder.Entity().HasQueryFilter(e =\>
						(e.SchedulingBoard.Workspace.Id == _requestInfoProvider.WorkspaceId)
						&& (e.SchedulingBoard.Workspace.UserId == _requestInfoProvider.UserId
							|| e.SchedulingBoard.Workspace.OrganizationId == _requestInfoProvider.OrganizationId
							|| _requestInfoProvider.UserIsAdmin));

					modelBuilder.Entity().HasQueryFilter(e =\>
						(e.SchedulingBoard.Workspace.Id == _requestInfoProvider.WorkspaceId)
						&& (e.SchedulingBoard.Workspace.UserId == _requestInfoProvider.UserId
							|| e.SchedulingBoard.Workspace.OrganizationId == _requestInfoProvider.OrganizationId
							|| _requestInfoProvider.UserIsAdmin));

					modelBuilder.Entity().HasQueryFilter(e =\>
						(e.SchedulingBoard.Workspace.Id == _requestInfoProvider.WorkspaceId)
						&& (e.SchedulingBoard.Workspace.UserId == _requestInfoProvider.UserId
							|| e.SchedulingBoard.Workspace.OrganizationId == _requestInfoProvider.OrganizationId
							|| _requestInfoProvider.UserIsAdmin));
```
      

```
                    modelBuilder.Entity\<Workspace\>().HasQueryFilter(_entityQueryFilterFactory.GetQueryFilter\<Workspace\>());
                    //modelBuilder.Entity\<Workspace\>().HasQueryFilter(e =\>
                    //    e.UserId == _requestInfoProvider.GetUserId()
                    //    || e.OrganizationId == _requestInfoProvider.GetTenantId()
                    //    || _requestInfoProvider.UserIsAdmin());

                    modelBuilder.Entity\<SchedulingBoard\>().HasQueryFilter(_entityQueryFilterFactory.GetQueryFilter\<SchedulingBoard\>(workspaceIdOptional: true));
                    //modelBuilder.Entity\<SchedulingBoard\>().HasQueryFilter(e =\>
                    //    (_requestInfoProvider.GetWorkspaceId() == null || e.Workspace.Id == _requestInfoProvider.GetWorkspaceId())
                    //    && (e.Workspace.UserId == _requestInfoProvider.GetUserId()
                    //        || e.Workspace.OrganizationId == _requestInfoProvider.GetTenantId()
                    //        || _requestInfoProvider.UserIsAdmin()));
```
    
```
                    //modelBuilder.Entity\<Project\>().HasQueryFilter(_entityQueryFilterFactory.GetQueryFilter\<Project\>(workspaceIdOptional:true));
                    //modelBuilder.Entity\<Campaign\>().HasQueryFilter(_entityQueryFilterFactory.GetQueryFilter\<Campaign\>());
                    //modelBuilder.Entity\<Batch\>().HasQueryFilter(_entityQueryFilterFactory.GetQueryFilter\<Batch\>());
                    //modelBuilder.Entity\<ProcedureEntry\>().HasQueryFilter(_entityQueryFilterFactory.GetQueryFilter\<ProcedureEntry\>());
                    //modelBuilder.Entity\<OperationEntry\>().HasQueryFilter(_entityQueryFilterFactory.GetQueryFilter\<OperationEntry\>());

                    //modelBuilder.Entity\<Facility\>().HasQueryFilter(_entityQueryFilterFactory.GetQueryFilter\<Facility\>());
                    //modelBuilder.Entity\<Equipment\>().HasQueryFilter(_entityQueryFilterFactory.GetQueryFilter\<Equipment\>());
                    //modelBuilder.Entity\<Staff\>().HasQueryFilter(_entityQueryFilterFactory.GetQueryFilter\<Staff\>());
                    //modelBuilder.Entity\<Labor\>().HasQueryFilter(_entityQueryFilterFactory.GetQueryFilter\<Labor\>());
                    //modelBuilder.Entity\<StorageUnit\>().HasQueryFilter(_entityQueryFilterFactory.GetQueryFilter\<StorageUnit\>());

                    //modelBuilder.Entity\<Recipe\>().HasQueryFilter(_entityQueryFilterFactory.GetQueryFilter\<Recipe\>());
                    //modelBuilder.Entity\<Branch\>().HasQueryFilter(_entityQueryFilterFactory.GetQueryFilter\<Branch\>());
                    //modelBuilder.Entity\<Section\>().HasQueryFilter(_entityQueryFilterFactory.GetQueryFilter\<Section\>());
                    //modelBuilder.Entity\<Procedure\>().HasQueryFilter(_entityQueryFilterFactory.GetQueryFilter\<Procedure\>());
                    //modelBuilder.Entity\<Operation\>().HasQueryFilter(_entityQueryFilterFactory.GetQueryFilter\<Operation\>());

                    //modelBuilder.Entity\<Material\>().HasQueryFilter(_entityQueryFilterFactory.GetQueryFilter\<Material\>());

                    //modelBuilder.Entity\<OperationType\>().HasQueryFilter(_entityQueryFilterFactory.GetQueryFilter\<OperationType\>());

                    //modelBuilder.Entity\<EquipmentType\>().HasQueryFilter(_entityQueryFilterFactory.GetQueryFilter\<EquipmentType\>());

                    //modelBuilder.Entity\<CompatibilityTag\>().HasQueryFilter(_entityQueryFilterFactory.GetQueryFilter\<CompatibilityTag\>());

                    //modelBuilder.Entity\<RecipeClassification\>().HasQueryFilter(_entityQueryFilterFactory.GetQueryFilter\<RecipeClassification\>());
                    //modelBuilder.Entity\<RecipeType\>().HasQueryFilter(_entityQueryFilterFactory.GetQueryFilter\<RecipeType\>());

                    //modelBuilder.Entity\<OutageTemplate\>().HasQueryFilter(_entityQueryFilterFactory.GetQueryFilter\<OutageTemplate\>());

                    //modelBuilder.Entity\<AttentionCode\>().HasQueryFilter(_entityQueryFilterFactory.GetQueryFilter\<AttentionCode\>());

                    //modelBuilder.Entity\<VisibilityOrderingConfiguration\>().HasQueryFilter(_entityQueryFilterFactory.GetQueryFilter\<VisibilityOrderingConfiguration\>());

                    //modelBuilder.Entity\<StaffDisplayNameConfiguration\>().HasQueryFilter(_entityQueryFilterFactory.GetQueryFilter\<StaffDisplayNameConfiguration\>());
                    //modelBuilder.Entity\<SchedulingConfiguration\>().HasQueryFilter(_entityQueryFilterFactory.GetQueryFilter\<SchedulingConfiguration\>());

                    //modelBuilder.Entity\<ProductionTrackingConfiguration\>().HasQueryFilter(_entityQueryFilterFactory.GetQueryFilter\<ProductionTrackingConfiguration\>());

                    //modelBuilder.Entity\<DisplayProfile\>().HasQueryFilter(_entityQueryFilterFactory.GetQueryFilter\<DisplayProfile\>());
```
                   
```
using Elastic.CommonSchema;￼using Planning.Api.Exceptions;￼using Planning.Domain.Aggregates.AttentionCodeAggregate;￼using Planning.Domain.Aggregates.BatchAggregate;￼using Planning.Domain.Aggregates.BranchAggregate;￼using Planning.Domain.Aggregates.CampaignAggregate;￼using Planning.Domain.Aggregates.CompatibilityTagAggregate;￼using Planning.Domain.Aggregates.DisplayProfileAggregate;￼using Planning.Domain.Aggregates.EquipmentAggregate;￼using Planning.Domain.Aggregates.EquipmentTypeAggregate;￼using Planning.Domain.Aggregates.FacilityAggregate;￼using Planning.Domain.Aggregates.LaborAggregate;￼using Planning.Domain.Aggregates.MaterialAggregate;￼using Planning.Domain.Aggregates.OperationAggregate;￼using Planning.Domain.Aggregates.OperationEntryAggregate;￼using Planning.Domain.Aggregates.OperationTypeAggregate;￼using Planning.Domain.Aggregates.OutageTemplateAggregate;￼using Planning.Domain.Aggregates.ProcedureAggregate;￼using Planning.Domain.Aggregates.ProcedureEntryAggregate;￼using Planning.Domain.Aggregates.ProductionTrackingConfigurationAggregate;￼using Planning.Domain.Aggregates.ProjectAggregate;￼using Planning.Domain.Aggregates.RecipeAggregate;￼using Planning.Domain.Aggregates.RecipeClassificationAggregate;￼using Planning.Domain.Aggregates.RecipeTypeAggregate;￼using Planning.Domain.Aggregates.SchedulingBoardAggregate;￼using Planning.Domain.Aggregates.SchedulingConfigurationAggregate;￼using Planning.Domain.Aggregates.SectionAggregate;￼using Planning.Domain.Aggregates.StaffAggregate;￼using Planning.Domain.Aggregates.StaffDisplayNameConfigurationAggregate;￼using Planning.Domain.Aggregates.StorageUnitAggregate;￼using Planning.Domain.Aggregates.UserAggregate;￼using Planning.Domain.Aggregates.VisibilityOrderingConfigurationAggregate;￼using Planning.Domain.Aggregates.WorkspaceAggregate;￼using Planning.Infrastructure.Interfaces;￼using System;￼using System.Collections.Generic;￼using System.Linq.Expressions;￼ ￼namespace Planning.Api.Helpers￼{￼	public class EntityQueryFilterFactory : IEntityQueryFilterFactory￼	{￼		private readonly IPlanningApiGrpcRequestInfoProvider _requestInfoProvider;￼ ￼		private readonly IReadOnlyDictionary\<Type, Func\<ParameterExpression, Expression\>\> _workspaceSelectors = new Dictionary\<Type, Func\<ParameterExpression, Expression\>\>￼		{￼			{ typeof(Workspace), p =\> p },￼			{ typeof(SchedulingBoard), p =\> Expression.PropertyOrField(p, nameof(SchedulingBoard.Workspace)) },￼			{ typeof(Project), p =\> {￼					Expression schedulingBoardExpr = Expression.PropertyOrField(p, nameof(Project.SchedulingBoard));￼					return Expression.PropertyOrField(schedulingBoardExpr, nameof(SchedulingBoard.Workspace));￼				}￼			},￼			{ typeof(Campaign), p =\> {￼					Expression schedulingBoardExpr = Expression.PropertyOrField(p, nameof(Campaign.SchedulingBoard));￼					return Expression.PropertyOrField(schedulingBoardExpr, nameof(SchedulingBoard.Workspace));￼				}￼			},￼			{ typeof(Batch), p =\> {￼					Expression campaignExpr = Expression.PropertyOrField(p, nameof(Batch.Campaign));￼					Expression schedulingBoardExpr = Expression.PropertyOrField(campaignExpr, nameof(Campaign.SchedulingBoard));￼					return Expression.PropertyOrField(schedulingBoardExpr, nameof(SchedulingBoard.Workspace));￼				}￼			},￼			{ typeof(ProcedureEntry), p =\> {￼					Expression batchExpr = Expression.PropertyOrField(p, nameof(ProcedureEntry.Batch));￼					Expression campaignExpr = Expression.PropertyOrField(batchExpr, nameof(Batch.Campaign));￼					Expression schedulingBoardExpr = Expression.PropertyOrField(campaignExpr, nameof(Campaign.SchedulingBoard));￼					return Expression.PropertyOrField(schedulingBoardExpr, nameof(SchedulingBoard.Workspace));￼				}￼			},￼			{ typeof(OperationEntry), p =\> {￼ ￼					Expression procedureEntryExpr = Expression.PropertyOrField(p, nameof(OperationEntry.ProcedureEntry));￼					Expression batchExpr = Expression.PropertyOrField(procedureEntryExpr, nameof(ProcedureEntry.Batch));￼					Expression campaignExpr = Expression.PropertyOrField(batchExpr, nameof(Batch.Campaign));￼					Expression schedulingBoardExpr = Expression.PropertyOrField(campaignExpr, nameof(Campaign.SchedulingBoard));￼					return Expression.PropertyOrField(schedulingBoardExpr, nameof(SchedulingBoard.Workspace));￼				}￼			},￼			{ typeof(Facility), p =\> Expression.PropertyOrField(p, nameof(Facility.Workspace)) },￼			{ typeof(Equipment), p =\> {￼					Expression facilityExpr = Expression.PropertyOrField(p, nameof(Equipment.Facility));￼					return Expression.PropertyOrField(facilityExpr, nameof(Facility.Workspace));￼				}￼			},￼			{ typeof(Staff), p =\> {￼					Expression facilityExpr = Expression.PropertyOrField(p, nameof(Staff.Facility));￼					return Expression.PropertyOrField(facilityExpr, nameof(Facility.Workspace));￼				}￼			},￼			{ typeof(Labor), p =\> {￼					Expression facilityExpr = Expression.PropertyOrField(p, nameof(Labor.Facility));￼					return Expression.PropertyOrField(facilityExpr, nameof(Facility.Workspace));￼				}￼			},￼			{ typeof(StorageUnit), p =\> {￼					Expression facilityExpr = Expression.PropertyOrField(p, nameof(StorageUnit.Facility));￼					return Expression.PropertyOrField(facilityExpr, nameof(Facility.Workspace));￼				}￼			},￼			{ typeof(Recipe), p =\> {￼					return Expression.PropertyOrField(p, nameof(Recipe.Workspace));￼				}￼			},￼			{ typeof(Branch), p =\> {￼					Expression recipeExpr = Expression.PropertyOrField(p, nameof(Branch.Recipe));￼					return Expression.PropertyOrField(recipeExpr, nameof(Recipe.Workspace));￼				}￼			},￼			{ typeof(Section), p =\> {￼					Expression branchExpr = Expression.PropertyOrField(p, nameof(Section.Branch));￼					Expression recipeExpr = Expression.PropertyOrField(branchExpr, nameof(Branch.Recipe));￼					return Expression.PropertyOrField(recipeExpr, nameof(Recipe.Workspace));￼				}￼			},￼			{ typeof(Procedure), p =\> {￼					Expression sectionExpr = Expression.PropertyOrField(p, nameof(Procedure.Section));￼					Expression branchExpr = Expression.PropertyOrField(sectionExpr, nameof(Section.Branch));￼					Expression recipeExpr = Expression.PropertyOrField(branchExpr, nameof(Branch.Recipe));￼					return Expression.PropertyOrField(recipeExpr, nameof(Recipe.Workspace));￼				}￼			},￼			{ typeof(Operation), p =\> {￼					Expression procedureExpr = Expression.PropertyOrField(p, nameof(Operation.Procedure));￼					Expression sectionExpr = Expression.PropertyOrField(procedureExpr, nameof(Procedure.Section));￼					Expression branchExpr = Expression.PropertyOrField(sectionExpr, nameof(Section.Branch));￼					Expression recipeExpr = Expression.PropertyOrField(branchExpr, nameof(Branch.Recipe));￼					return Expression.PropertyOrField(recipeExpr, nameof(Recipe.Workspace));￼				}￼			},￼			{ typeof(Material), p =\> {￼					return Expression.PropertyOrField(p, nameof(Material.Workspace));￼				}￼			},￼			{ typeof(OperationType), p =\> {￼					return Expression.PropertyOrField(p, nameof(OperationType.Workspace));￼				}￼			},￼			{ typeof(EquipmentType), p =\> {￼					return Expression.PropertyOrField(p, nameof(EquipmentType.Workspace));￼				}￼			},￼			{ typeof(CompatibilityTag), p =\> {￼					return Expression.PropertyOrField(p, nameof(CompatibilityTag.Workspace));￼				}￼			},￼			{ typeof(RecipeClassification), p =\> {￼					return Expression.PropertyOrField(p, nameof(RecipeClassification.Workspace));￼				}￼			},￼			{ typeof(RecipeType), p =\> {￼					Expression recipeClassificationExpr = Expression.PropertyOrField(p, nameof(RecipeType.RecipeClassification));￼					return Expression.PropertyOrField(recipeClassificationExpr, nameof(RecipeClassification.Workspace));￼				}￼			},￼			{ typeof(OutageTemplate), p =\> {￼					return Expression.PropertyOrField(p, nameof(OutageTemplate.Workspace));￼				}￼			},￼			{ typeof(AttentionCode), p =\> {￼					return Expression.PropertyOrField(p, nameof(AttentionCode.Workspace));￼				}￼			},￼			{ typeof(VisibilityOrderingConfiguration), p =\> {￼					Expression schedulingBoardExpr = Expression.PropertyOrField(p, nameof(VisibilityOrderingConfiguration.SchedulingBoard));￼					return Expression.PropertyOrField(schedulingBoardExpr, nameof(SchedulingBoard.Workspace));￼				}￼			},￼			{ typeof(StaffDisplayNameConfiguration), p =\> {￼					Expression schedulingBoardExpr = Expression.PropertyOrField(p, nameof(StaffDisplayNameConfiguration.SchedulingBoard));￼					return Expression.PropertyOrField(schedulingBoardExpr, nameof(SchedulingBoard.Workspace));￼				}￼			},￼			{ typeof(SchedulingConfiguration), p =\> {￼					Expression schedulingBoardExpr = Expression.PropertyOrField(p, nameof(SchedulingConfiguration.SchedulingBoard));￼					return Expression.PropertyOrField(schedulingBoardExpr, nameof(SchedulingBoard.Workspace));￼				}￼			},￼			{ typeof(ProductionTrackingConfiguration), p =\> {￼					Expression schedulingBoardExpr = Expression.PropertyOrField(p, nameof(ProductionTrackingConfiguration.SchedulingBoard));￼					return Expression.PropertyOrField(schedulingBoardExpr, nameof(SchedulingBoard.Workspace));￼				}￼			},￼			{ typeof(DisplayProfile), p =\> {￼					Expression schedulingBoardExpr = Expression.PropertyOrField(p, nameof(DisplayProfile.SchedulingBoard));￼					return Expression.PropertyOrField(schedulingBoardExpr, nameof(SchedulingBoard.Workspace));￼				}￼			},￼		};￼ ￼		public EntityQueryFilterFactory(IPlanningApiGrpcRequestInfoProvider requestInfoProvider)￼		{￼			_requestInfoProvider = requestInfoProvider;￼		}￼		public Expression\<Func\<T, bool\>\> GetQueryFilter\<T\>(bool workspaceIdOptional = false)￼		{￼			// e parameter￼			ParameterExpression parameter = Expression.Parameter(typeof(T), "e");￼ ￼			if (!_workspaceSelectors.TryGetValue(typeof(T), out var selector))￼			{￼				// TODO: Convert to planning exception￼				throw new NotSupportedException(￼					$"No workspace selector is registered for type {typeof(T).Name}.");￼			}￼ ￼			// e.Workspace / e.SchedulingBoard.Workspace / ...￼			Expression workspaceExpression = selector(parameter);￼ ￼			BinaryExpression bodyExpression = GetWorkspaceBodyExpression(workspaceExpression, workspaceIdOptional);￼ ￼			var result = Expression.Lambda\<Func\<T, bool\>\>(bodyExpression, parameter);￼			Console.WriteLine(result);￼ ￼			return result;￼		}￼ ￼		private BinaryExpression GetWorkspaceBodyExpression(Expression workspaceExpression, bool workspaceIdOptional = false)￼		{￼			//int? workspaceId = _requestInfoProvider.GetWorkspaceId();￼			//Guid userId = _requestInfoProvider.GetUserId();￼			//string tenantId = _requestInfoProvider.GetTenantId();￼			//bool userIsAdmin = _requestInfoProvider.UserIsAdmin();￼ ￼			// workspace.UserId￼			MemberExpression workspaceUserIdExpression =￼				Expression.PropertyOrField(workspaceExpression, nameof(Workspace.UserId));￼ ￼			// workspace.OrganizationId￼			MemberExpression workspaceOrganizationIdExpression =￼				Expression.PropertyOrField(workspaceExpression, nameof(Workspace.OrganizationId));￼ ￼			// constants (capture values)￼			//ConstantExpression userIdConstant =￼			//	Expression.Constant(_requestInfoProvider.GetUserId(), workspaceUserIdExpression.Type); // Guid vs Guid?￼			//ConstantExpression tenantIdConstant = Expression.Constant(_requestInfoProvider.GetTenantId());￼			//ConstantExpression userIsAdminConstant = Expression.Constant(_requestInfoProvider.UserIsAdmin());￼ ￼ ￼			Expression\<Func\<Guid?\>\> userIdParameterLambda = () =\> _requestInfoProvider.GetUserId() as Guid?;￼			var userIdParam = userIdParameterLambda.Body;￼			Expression\<Func\<string\>\> tenantIdParameterLambda = () =\> _requestInfoProvider.GetTenantId();￼			var tenantIdParam = tenantIdParameterLambda.Body;￼			Expression\<Func\<bool\>\> isAdminParameterLambda = () =\> _requestInfoProvider.UserIsAdmin();￼			var isAdminParam = isAdminParameterLambda.Body;￼ ￼			// workspace.UserId == userId￼			BinaryExpression userIdEqualsExpression =￼				Expression.Equal(workspaceUserIdExpression, userIdParam);￼ ￼			// workspace.OrganizationId == tenantId￼			BinaryExpression organizationEqualsExpression =￼				Expression.Equal(workspaceOrganizationIdExpression, tenantIdParam);￼ ￼			// workspace.UserId == userId || workspace.OrganizationId == tenantId￼			BinaryExpression workspaceOrTenantExpression =￼				Expression.OrElse(userIdEqualsExpression, organizationEqualsExpression);￼ ￼			// (workspace.UserId == userId || workspace.OrganizationId == tenantId) || userIsAdmin￼			BinaryExpression userTenantAdminExpression =￼				Expression.OrElse(workspaceOrTenantExpression, isAdminParam);￼ ￼			if (workspaceExpression.Type == typeof(Workspace))￼			{￼				//	e =\> e.UserId == userId￼				//		|| e.OrganizationId == tenantId￼				//		|| userIsAdmin;￼ ￼				return userTenantAdminExpression;￼			}￼ ￼			if (workspaceIdOptional && _requestInfoProvider.GetWorkspaceId() == null)￼			{￼				//	e =\> (workspaceId == null || e.Workspace.Id == workspaceId)￼				//		&& (e.Workspace.UserId == userId￼				//			|| e.Workspace.OrganizationId == tenantId￼				//			|| userIsAdmin);￼ ￼				return userTenantAdminExpression;￼			}￼ ￼			if (!workspaceIdOptional && _requestInfoProvider.GetWorkspaceId() == null)￼			{￼				throw new PlanningApiException(Common.Errors.CommonDomainError.ArgumentNullError,￼					nameof(_requestInfoProvider), nameof(_requestInfoProvider.GetWorkspaceId));￼			}￼ ￼			// workspace.Id￼			MemberExpression workspaceIdExpression =￼			Expression.PropertyOrField(workspaceExpression, nameof(Workspace.Id));￼ ￼			// constant (workspaceId￼			//ConstantExpression workspaceIdConstant = Expression.Constant(_requestInfoProvider.GetWorkspaceId().Value, workspaceIdExpression.Type);￼			Expression\<Func\<int?\>\> workspaceIdParameterLambda = () =\> _requestInfoProvider.GetWorkspaceId();￼			var workspaceIdParam = workspaceIdParameterLambda.Body;￼ ￼			// workspace.Id == workspaceId￼			BinaryExpression workspaceIdEqualsExpression =￼				Expression.Equal(workspaceIdExpression, workspaceIdParam);￼ ￼			//	e =\> (e.Workspace.Id == workspaceId)￼			//		&& (e.Workspace.UserId == userId￼			//			|| e.Workspace.OrganizationId == tenantId￼			//			|| _requestInfoProvider.UserIsAdmin)￼ ￼			// (workspace.Id == workspaceId) && (userTenantAdminExpression)￼			return Expression.AndAlso(workspaceIdEqualsExpression, userTenantAdminExpression);￼		}￼ ￼		public LambdaExpression GetExpr(Expression\<Func\<Guid?\>\> userIdAccessor)￼		{￼			// e parameter￼			ParameterExpression parameter = Expression.Parameter(typeof(SchedulingBoard), "e");￼ ￼			Expression schedulingBoardWorkspaceExpression =￼				Expression.PropertyOrField(parameter, nameof(SchedulingBoard.Workspace));￼ ￼			// workspace.UserId￼			MemberExpression workspaceUserIdExpression =￼				Expression.PropertyOrField(schedulingBoardWorkspaceExpression, nameof(Workspace.UserId));￼ ￼			// workspace.UserId == userId￼			BinaryExpression bodyExpression = Expression.Equal(￼				workspaceUserIdExpression,￼				userIdAccessor.Body);￼ ￼			var result = Expression.Lambda\<Func\<SchedulingBoard, bool\>\>(bodyExpression, parameter);￼ ￼			Console.WriteLine(result);￼ ￼			return result;￼		}￼ ￼		public LambdaExpression GetLambda(Func\<Guid?\> userIdAccessor)￼		{￼			Expression\<Func\<SchedulingBoard, Workspace\>\> selector =￼				sb =\> sb.Workspace;￼ ￼			Expression\<Func\<Workspace, bool\>\> workspacePredicate =￼				w =\> w.UserId == userIdAccessor();￼ ￼			var outerParam = selector.Parameters[0];￼			var visitor = new ReplaceVisitor(workspacePredicate.Parameters[0], selector.Body);￼ ￼			var newBody = visitor.Visit(workspacePredicate.Body);￼ ￼			var result = Expression.Lambda\<Func\<SchedulingBoard, bool\>\>(newBody, outerParam);￼ ￼			return result;￼		}￼ ￼		private sealed class ReplaceVisitor : ExpressionVisitor￼		{￼			private readonly Expression _oldExpr;￼			private readonly Expression _newExpr;￼ ￼			public ReplaceVisitor(Expression oldExpr, Expression newExpr)￼			{￼				_oldExpr = oldExpr;￼				_newExpr = newExpr;￼			}￼ ￼			protected override Expression VisitParameter(ParameterExpression node)￼				=\> node == _oldExpr ? _newExpr : base.VisitParameter(node);￼		}￼	}￼}
```
       
```
public static class ExpressionComposer￼{￼	public static Expression\<Func\<TOuter, bool\>\> Compose\<TOuter, TInner\>(￼		Expression\<Func\<TOuter, TInner\>\> selector,￼		Expression\<Func\<TInner, bool\>\> predicate)￼	{￼		// Use the outer parameter (TOuter) as the lambda parameter￼		var outerParam = selector.Parameters[0];￼ ￼		// Replace all occurrences of predicate's parameter (TInner)￼		// with the selector's body (x.Inner)￼		var visitor = new ReplaceVisitor(￼			predicate.Parameters[0],   // old param: TInner￼			selector.Body              // new expr: x.Inner￼		);￼ ￼		var newBody = visitor.Visit(predicate.Body);￼ ￼		return Expression.Lambda\<Func\<TOuter, bool\>\>(newBody, outerParam);￼	}￼ ￼	private sealed class ReplaceVisitor : ExpressionVisitor￼	{￼		private readonly Expression _oldExpr;￼		private readonly Expression _newExpr;￼ ￼		public ReplaceVisitor(Expression oldExpr, Expression newExpr)￼		{￼			_oldExpr = oldExpr;￼			_newExpr = newExpr;￼		}￼ ￼		protected override Expression VisitParameter(ParameterExpression node)￼			=\> node == _oldExpr ? _newExpr : base.VisitParameter(node);￼	}￼}￼
```

=={==  
=="exp":== ==1762962299====,==  
=="iat":== ==1762960499====,==  
=="auth_time":== ==1762960498====,==  
=="jti":== =="7f7b357f-ef0d-4480-85c9-7f7340bd6546",==  
=="iss":== =="====https://localhost:28443/realms/ScpCloud====",==  
=="aud":== =="scpCloud",==  
=="sub":== =="250819c2-20b0-4968-add1-6da32726bee3",==  
=="typ":== =="Bearer",==  
=="azp":== =="scpCloud",==  
=="nonce":== =="c74e547e-f9d6-4042-9e3f-61d39de15c16",==  
=="session_state":== =="7f22c1f0-7914-492a-89a2-ee24e52c3420",==  
=="allowed-origins":== ==[==  
=="*"==  
==],==  
=="scope":== =="openid profile",==  
=="sid":== =="7f22c1f0-7914-492a-89a2-ee24e52c3420",==  
=="firstName":== =="admin2",==  
=="lastName":== =="admin2",==  
=="country":== =="country",==  
=="organizationName":== =="DemoOrganization",==  
=="jobTitle":== =="job-title",==  
=="tenantId":== =="250819c2-20b0-4968-add1-6da32726bee3",==  
=="isAdmin":== =="true",==  
=="email":== =="admin2@domain.com",==  
=="username":== =="admin2"==  
==}==

![Exported image](Exported%20image%2020260209140356-0.png)

**PRODUCITON TOKEN AS OF 2025-11-25**  
=={==  
=="exp":== ==1764058271====,==  
=="iat":== ==1764056471====,==  
=="auth_time":== ==1764056470====,==  
=="jti":== =="14b6c75c-439a-4402-9a2a-4515185dd972",==  
=="iss":== =="====https://identity.scpcloud.intelligen.com/realms/ScpCloud====",==  
=="aud":== =="scpCloud",==  
=="sub":== =="10a67da8-446a-4652-91e6-ac09e5550f8c",==  
=="typ":== =="Bearer",==  
=="azp":== =="scpCloud",==  
=="nonce":== =="7aa6f02e-4480-4fe7-8296-6ba2d17e594c",==  
=="session_state":== =="d2ec4325-347c-4597-ac74-e11e0099c1e4",==  
=="allowed-origins":== ==[==  
=="*"==  
==],==  
=="scope":== =="openid",==  
=="sid":== =="d2ec4325-347c-4597-ac74-e11e0099c1e4",==  
=="lastName":== =="Timoleon",==  
=="firstName":== =="Michail",==  
=="email":== =="mitimo@gmail.com",==  
=="username":== =="mitimo@gmail.com"==  
==}==
 \> Από \<[https://www.jwt.io/](https://www.jwt.io/)\>