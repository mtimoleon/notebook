---
categories:
  - "[[Work]]"
  - "[[Issues]]"
created: 2025-12-15T12:56
tags:
  - intelligen
  - keycloak
status: completed
product: ScpCloud
component: Keycloak
---

- [x] ~~Aspnet core checks for role claim, see if it can check for {realm_access:roles}~~

- [x] Sample Code
```

public static class AuthorizationOptionsExtensions
        {
                public static void AddScpPolicies(this AuthorizationOptions options)
                {
                        options.AddPolicy(AuthPolicies.AdminOnly, p => p.RequireRole("admin"));
                        options.AddPolicy(AuthPolicies.CanManageUsers, p => p.RequireRole("user-admin", "realm-admin"));
                }
        }

        public class AppRoleRequirement : IAuthorizationRequirement
        {
                public string Role { get; }
                public AppRoleRequirement(string role) => Role = role;
        }

        public class AppRoleHandler : AuthorizationHandler
        {
                protected override Task HandleRequirementAsync(AuthorizationHandlerContext context, AppRoleRequirement requirement)
                {
                        // Check if the user has a claim of type "AppRole" with the required value
                        if (context.User.HasClaim("AppRole", requirement.Role))
                        {
                                context.Succeed(requirement);
                        }
                        return Task.CompletedTask;
                }
        }


public static void AddPolicy(AuthorizationOptions options, string policyName)
{
        if (PolicyRoles.TryGetValue(policyName, out string[] roles))
        {
                options.AddPolicy(
                        policyName,
                        p => p.RequireAuthenticatedUser()
                                .RequireRole(roles));
        }
}

public static AuthorizationPolicy BuildAuthorizationPolicy(string policyName)
{
        if (PolicyRoles.TryGetValue(policyName, out string[] roles))
        {
                var authorizationPolicyBuilder = new AuthorizationPolicyBuilder();

                authorizationPolicyBuilder.RequireAuthenticatedUser();
                authorizationPolicyBuilder.RequireRole(roles);

                return authorizationPolicyBuilder.Build();
        }
        return null;
}

public static class AuthorizationOptionsExtensions
{
        public static void AddPolicyFromName(this AuthorizationOptions options, string policyName)
        {
                if (AuthorizationPolicies.PolicyRoles.TryGetValue(policyName, out string[] roles))
                {
                        options.AddPolicy(
                                policyName,
                                p=>p.RequireAuthenticatedUser().RequireRole(roles)
                        );
                }
                throw new InvalidOperationException();
        }
}
```



- [ ] Changes on keycloak

1. - [x] ==Fix the realm roles mapper (client-scopes/roles)==

![Exported image](Exported%20image%2020260209140358-0.png)
![Exported image](Exported%20image%2020260209140400-1.png)

1. - [x] ==Add roles to dedicated scope==

![Exported image](Exported%20image%2020260209140402-2.png)

- [x] Registration issues through events (we do not have user roles)
- [x] Endpoint to return policies

- [x] Production checks
- [x] CreateDataBaseAsync
- [x] DropDatabaseAsync
- [x] BulkWriteAsync

|   |   |   |   |
|---|---|---|---|
|**User**|**Role**|**tenantId**|**tenant**|
|admin|admin|==250819c2-20b0-4968-add1-6da32726bee3==||
|globalReadOnly|globalReadOnly|==c7834e89-74ff-42ae-a6d8-8693f24b1351==|==1==|
|planner1|planner|==c7834e89-74ff-42ae-a6d8-8693f24b1351==|==1==|
|operator1|operator|==c7834e89-74ff-42ae-a6d8-8693f24b1351==|==1==|
|planner2|planner|==fdd90b4f-c587-4615-942a-ff1098225bef==|==2==|
|operator2|operator|==fdd90b4f-c587-4615-942a-ff1098225bef==|==2==|

Test plan

1. Prerequisities
    1. Create wsp/sb for planner1 and sync
    2. Create wsp/sb for planner2 and sync
    3. Create wsp/sb for admin and sync
2. Checks
    1. admin
        1. can read all sb
        2. can read production data for all sb
        3. can delete all
        4. can move/drag/sync/resync in planning
        5. can force update/update tracking in production
    2. globalReadOnly (can access all tenants)
        1. - [x] can read all workspace/scheduling board
        2. - [x] can read all workspace/scheduling board in production
        3. - [x] cannot can move/drag/sync/resync planning
        4. - [x] cannot force update/update tracking in production
        5. - [x] cannot delete anything
    3. planner1 ==(only under the same tenant)==
        1. - [x] cannot read admin wp/sb (if different tenant)
        2. - [x] can read own/tenant sb
        3. - [x] can read own/tenant production data sb
        4. - [x] can delete own/tenant sb and production db
        5. - [x] cannot read/update/delete other tenant data (tenant2)
        6. - [x] cannot force update/update tracking other tenant data in production (tenant2)
    4. planner2 ==(only under the same tenant)==
        1. - [x] cannot read admin wp/sb (if different tenant)
        2. - [x] can read own/tenant sb
        3. - [x] can read own/tenant production data sb
        4. - [x] can delete own/tenant sb and production db
        5. - [x] cannot read/update/delete other tenant data (tenant1)
        6. - [x] cannot force update/update tracking other tenant data in production (tenant1)
    5. operator1 ==(only under the same tenant)==
        1. - [x] cannot access planning app
        2. - [x] can read own/tenant production data sb
        3. - [x] cannot read other tenant production data sb (tenant2)
        4. - [x] cannot create production db
        5. - [x] cannot delete own/tenant sb and production db
        6. - [ ] can force update/update tracking only for same tenant
    6. operator2 ==(only under the same tenant)==
        1. - [x] cannot access planning app
        2. - [x] can read own/tenant production data sb
        3. - [x] cannot read other tenant production data sb (tenant1)
        4. - [x] cannot create production db
        5. - [x] cannot delete own/tenant sb and production db
        6. - [ ] can force update/update tracking only for same tenant


- [x] GetUser().UserFullfilsPolicy() na kano ena extension sto User toy http context ki ekei pano na rotao gia to policy
- [x] ProductionAppDatabaseCreate ==na fygoyn==
- [x] ProductionAppDatabaseDrop ==na fygoyn==
- [x] public async Task<CommandStatus> BulkWriteAsync<T>(
        string collectionName,
        List<WriteModel<T>> writeOperations,
        bool ordered = true,
        CancellationToken cancellationToken = default)
		{
	        if (_userIsGlobalReadOnly) na fygei den xreiazetai giati elexoyme sto transaction toy production
	        {
                throw new ProductionApiException(CommonDomainError.UserNotAuthorizedError);
	        }

	na vazo to user (operator) otan kanei tracking update sto production (nomizo 3 methods), opos kanoyme me to workspace create.
	na valo sto admin app kai roles kai na ftiaxo poia policies einai default sto mapping ton controllers
		CreateRegistrationAsync
		GetRegistrationByIdAsync
		GetRegistrationsAsync
		GetRegistrationsFilteredOrderedAsync

		ApproveRegistrationsAsync
		RejectRegistrationsAsync
		DeleteRegistrationsAsync

- [x] PlanningAppGlobalReadOnly & ProductionAppGlobalReadOnly policies na ginei ena AppGlobalReadOnly
- [x] na fero to master sto 508
- [x] fix initial scp realm json users and realm roles
- [x] create instructions for local computers => updated scp realm settings
      GetAuthorizationPolicies() endpoint is now open for everyone.
      Ioakeim Papathomas <Ioakeim_Papathomas@outlook.com> f972e62c69a6e9698840cd653fae29a9d8bd3bf2 22/12/2025 14:18:44



TestsCommon.Helpers.AuthHandler

@channel Now that we introduce user roles (task 508) you need to be aware of how we assign user for the test requests. Currently all the tests run with "admin" role user and assigned "tenantId" to 1 (though this does not matter for admin). You can see the setting in TestsCommon.Helpers.AuthHandler. But there are some cases where we want to perform the test as another user, for example with role "planner". For such cases we expose the ClaimsPrincipal of AuthHandler so before any request we can set a different user role (See planning Authorization tests on how to do this). Now you must remember to always return the user role to "admin" after this specific test run otherwise other tests that run susequently may break. To reset the user role to admin you just set "AuthHandler.ClaimsPrincipal = null;" and the AuthHandler will take the default principals. If it is convinient you can add this in tests constructor as it is in WorkspaceTests so for every test it starts with user having "admin" role.



