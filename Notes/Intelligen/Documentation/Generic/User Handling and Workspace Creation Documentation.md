---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
created: 2026-01-27T13:01
tags:
  - intelligen
---


## Overview
This document describes the user handling mechanisms in the ScpCloud system, including authentication, authorization, workspace creation, and production database management. The system uses Keycloak for identity management, JWT tokens for request authentication, and multi-tenant architecture with separate databases for planning and production services.
## User Authentication and Token Structure
### Keycloak Integration
Users are managed through Keycloak identity provider. The system supports:
- User registration via `KeycloakService.RegisterUserAsync()`
- Email verification workflows
- User enable/disable operations
- User updates and deletion
### JWT Token Claims
JWT tokens from Keycloak contain the following user-related claims:
- `sub` (nameidentifier): User GUID
- `tenantId`: Tenant identifier for multi-tenancy
- `username`: Username
- `firstName`: User's first name
- `lastName`: User's last name
- `jobTitle`: User's job title
- `organizationName`: Organization name
- `country`: Country
- `email`: Email address
- `isAdmin`: Boolean indicating admin privileges
### Request Information Extraction
The `PlanningApiGrpcRequestInfoProvider` extracts user information from HTTP context:
- `GetUserId()`: Returns GUID from `nameidentifier` claim
- `GetTenantId()`: Returns tenant ID from `tenantId` claim
- `GetUser()`: Constructs User entity from claims
- `UserIsAdmin()`: Checks admin status
- `GetToken()`: Returns Authorization header value
## Workspace Creation Process
### Workspace Entity
Workspaces are created in the Planning service with the following properties:
- `TenantId`: Multi-tenant identifier
- `UserId`: Creator's user GUID
- `User`: Associated User entity
- `Name`: Workspace name
- `Description`: Optional description
### Creation Handler Logic
```csharp
public async Task\<CommandStatus\> Handle(CreateWorkspaceCommand command, CancellationToken cancellationToken)
{
Β  Β  var user = await _context.Users.FindAsync(_requestInfoProvider.GetUserId());
Β  Β  if (user == null)
Β  Β  {
Β  Β  Β  Β  user = _requestInfoProvider.GetUser();
Β  Β  Β  Β  _context.Users.Add(user);
Β  Β  }
Β  Β  string tenantId = _requestInfoProvider.GetTenantId();
Β  Β  if (string.IsNullOrEmpty(tenantId))
Β  Β  {
Β  Β  Β  Β  tenantId = user.Id.ToString();
Β  Β  }
Β  Β  var workspace = new Workspace(command.WorkspaceCreateDto.Name, tenantId, user);
Β  Β  _context.Workspaces.Add(workspace);
Β  Β  await _context.SaveChangesAsync(cancellationToken);
Β  Β  // Return success with workspace ID and concurrency token
}
```
### User Existence Handling
When creating a workspace:
1. System attempts to find existing user in Planning database by `UserId`
2. If user does not exist:
Β  Β - User entity is constructed from JWT token claims
Β  Β - New user is added to Planning database
Β  Β - User ID is used as fallback for `TenantId` if not provided in token
### Tenant ID Assignment
- Primary source: `tenantId` claim from JWT token
- Fallback: User's GUID as string if token lacks tenant ID
- Stored in workspace for multi-tenant isolation
## Production Database Creation
### Database Architecture
Production service uses MongoDB with per-scheduling-board databases:
- Database naming: `s-{schedulingBoardId}`
- Each database contains:
Β  - `latest-batches` collection
Β  - `archived-batches` collection
Β  - `metadata` collection with workspace info
### Token Exploitation for Database Creation
JWT tokens enable production database creation through:
1. **Tenant Authorization**: Token's `tenantId` claim authorizes database access
2. **User Context**: Token provides user identity for ownership validation
3. **Multi-tenant Isolation**: Databases are scoped by tenant and scheduling board
### Database Creation Workflow
1. Planning service initiates production via `InitiateProductionCommand`
2. gRPC call to Production service: `CreateDatabaseAsync(DatabaseCreateDto)`
3. Production service creates MongoDB database with:
Β  Β - Indexes on batch collections
Β  Β - Metadata document containing:
Β  Β  Β - `workspaceId`
Β  Β  Β - `workspaceTenantId` (from token)
Β  Β  Β - `workspaceUserId`
Β  Β  Β - `schedulingBoardId`
### Authorization Checks
Database access validates:
```csharp
authorized = _userIsAdmin
Β  Β  || (_tenantId != null && workspaceTenantId == _tenantId)
Β  Β  || workspaceUserId == _userId;
```
## User Handling Edge Cases
### Non-existent User in Planning Database
- Automatically created from token claims during workspace creation
- No separate user registration required in Planning service
- User data synchronized from Keycloak via JWT
### Tenant ID Scenarios
- **Token provides tenantId**: Used directly
- **Token lacks tenantId**: Falls back to user GUID
- **Admin users**: Bypass tenant restrictions
- **Cross-tenant access**: Prevented by authorization logic
### Production Database Access
- Users can access databases where:
Β  - They are admins, OR
Β  - Tenant ID matches workspace tenant, OR
Β  - They are the workspace creator
- Token validation occurs on every database operation
## Security Considerations
- All requests require valid JWT tokens
- Tenant isolation prevents data leakage
- Admin privileges override tenant restrictions
- Database operations log unauthorized access attempts
## Integration Events
User-related events:
- `UserRegistrationApprovedIntegrationEvent`
- `UserRegistrationRemovedIntegrationEvent`
These events coordinate user state across services when registration status changes.




