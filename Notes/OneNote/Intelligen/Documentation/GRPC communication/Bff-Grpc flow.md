![Exported image](Exported%20image%2020260209134046-0.png)   
# Depict the flow from logs
 
```
[11:55:24 INF] Request starting HTTP/1.1 POST https://localhost:5221/planning/Workspace/2/schedule application/json 41
[11:55:24 INF] Executing endpoint 'WebPlanningBff.Controllers.WorkspaceController.ScheduleWorkspaceCampaignsAsync (WebPlanningBff)'
[11:55:24 INF] Route matched with {action = "ScheduleWorkspaceCampaigns", controller = "Workspace"}. Executing controller action with signature System.Threading.Tasks.Task`1[Microsoft.AspNetCore.Mvc.ActionResult`1[Planning.Grpc.Dtos.CommandStatus]] ScheduleWorkspaceCampaignsAsync(System.Threading.CancellationToken, Planning.Grpc.Dtos.RequestByIdDto, Int32) on controller WebPlanningBff.Controllers.WorkspaceController (WebPlanningBff).
[11:55:24 INF] SERVICE CALL
[11:55:24 INF] Start processing HTTP request POST https://planning-api:444/Planning.Grpc.Contracts.WorkspaceServiceContract/ScheduleWorkspaceCampaigns
[11:55:24 INF] Sending HTTP request POST https://planning-api:444/Planning.Grpc.Contracts.WorkspaceServiceContract/ScheduleWorkspaceCampaigns
[11:55:24 INF] BFF INTERCEPTOR
[11:55:24 INF] Request starting HTTP/2 POST https://planning-api:444/Planning.Grpc.Contracts.WorkspaceServiceContract/ScheduleWorkspaceCampaigns application/grpc -
[11:55:24 INF] Executing endpoint 'gRPC - /Planning.Grpc.Contracts.WorkspaceServiceContract/ScheduleWorkspaceCampaigns'
[11:55:24 INF] gRpc INTERCEPTOR
[11:55:24 INF] RabbitMQ Client is trying to connect
[11:55:24 INF] RabbitMQ Client acquired a persistent connection to 'rabbitmq' and is subscribed to failure events
[11:55:25 INF] Entity Framework Core 6.0.9 initialized 'PlanningDbContext' using provider 'Microsoft.EntityFrameworkCore.SqlServer:6.0.9' with options: None
[11:55:25 INF] TRANSACTION
[11:55:25 INF] Call failed with gRPC error status. Status code: 'Cancelled', Message: 'Call canceled by the client.'.
Exception thrown: 'Grpc.Core.RpcException' in System.Private.CoreLib.dll
[11:55:25 INF] BFF INTERCEPTOR CATCH ECEPTION
[11:55:25 ERR] Error calling via grpc: Status(StatusCode="Cancelled", Detail="Call canceled by the client.") - Status(StatusCode="Cancelled", Detail="Call canceled by the client.")
[11:55:25 INF] SERVICE RESPONSE
[11:55:25 INF] CONTROLLER RESPONSE
CONTROLLER EXTENSION RESPONSE
[11:55:25 INF] Executing UnprocessableEntityObjectResult, writing value of type 'Planning.Grpc.Dtos.CommandStatus'.
[11:55:25 INF] Executed action WebPlanningBff.Controllers.WorkspaceController.ScheduleWorkspaceCampaignsAsync (WebPlanningBff) in 612.3188ms
[11:55:25 INF] Executed endpoint 'WebPlanningBff.Controllers.WorkspaceController.ScheduleWorkspaceCampaignsAsync (WebPlanningBff)'
[11:55:25 INF] HTTP POST /planning/Workspace/2/schedule responded 422 in 614.4593 ms
[11:55:25 INF] Request finished HTTP/1.1 POST https://localhost:5221/planning/Workspace/2/schedule application/json 41 - 0 - application/json;+charset=utf-8 615.2618ms
[11:55:25 INF] ----- Begin transaction 2680a095-9716-4e32-913d-51bbd461d98f for ScheduleWorkspaceCampaignsCommand ({"RequestByIdDto": {"Id": 2, "ConcurrencyToken": 2151, "$type": "RequestByIdDto"}, "$type": "ScheduleWorkspaceCampaignsCommand"})
[11:55:25 ERR] Failed executing DbCommand (4ms) [Parameters=[@__command_RequestByIdDto_Id_0='?' (DbType = Int32)], CommandType='Text', CommandTimeout='30']
SELECT TOP(1) [w].[Id], [w].[ConcurrencyToken], [w].[Description], [w].[Name], [w].[Start], [w].[Time]
FROM [Workspaces] AS [w]
WHERE [w].[Id] = @__command_RequestByIdDto_Id_0
ORDER BY [w].[Id]
[11:55:25 ERR] An exception occurred while iterating over the results of a query for context type 'Planning.Infrastructure.PlanningDbContext'.
System.Threading.Tasks.TaskCanceledException: A task was canceled.
   at Microsoft.EntityFrameworkCore.Storage.RelationalCommand.ExecuteReaderAsync(RelationalCommandParameterObject parameterObject, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Storage.RelationalCommand.ExecuteReaderAsync(RelationalCommandParameterObject parameterObject, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Query.Internal.SplitQueryingEnumerable`1.AsyncEnumerator.InitializeReaderAsync(AsyncEnumerator enumerator, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.SqlServer.Storage.Internal.SqlServerExecutionStrategy.ExecuteAsync[TState,TResult](TState state, Func`4 operation, Func`4 verifySucceeded, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Query.Internal.SplitQueryingEnumerable`1.AsyncEnumerator.MoveNextAsync()
System.Threading.Tasks.TaskCanceledException: A task was canceled.
   at Microsoft.EntityFrameworkCore.Storage.RelationalCommand.ExecuteReaderAsync(RelationalCommandParameterObject parameterObject, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Storage.RelationalCommand.ExecuteReaderAsync(RelationalCommandParameterObject parameterObject, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Query.Internal.SplitQueryingEnumerable`1.AsyncEnumerator.InitializeReaderAsync(AsyncEnumerator enumerator, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.SqlServer.Storage.Internal.SqlServerExecutionStrategy.ExecuteAsync[TState,TResult](TState state, Func`4 operation, Func`4 verifySucceeded, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Query.Internal.SplitQueryingEnumerable`1.AsyncEnumerator.MoveNextAsync()
Exception thrown: 'System.Threading.Tasks.TaskCanceledException' in System.Private.CoreLib.dll
Exception thrown: 'System.Threading.Tasks.TaskCanceledException' in System.Private.CoreLib.dll
Exception thrown: 'System.Threading.Tasks.TaskCanceledException' in System.Private.CoreLib.dll
[11:55:25 INF] TRANSACTION CATCH ECEPTION
[11:55:25 INF] Executed endpoint 'gRPC - /Planning.Grpc.Contracts.WorkspaceServiceContract/ScheduleWorkspaceCampaigns'
[11:55:25 INF] HTTP POST /Planning.Grpc.Contracts.WorkspaceServiceContract/ScheduleWorkspaceCampaigns responded 200 in 1086.1538 ms
[11:55:25 INF] Request finished HTTP/2 POST https://planning-api:444/Planning.Grpc.Contracts.WorkspaceServiceContract/ScheduleWorkspaceCampaigns application/grpc - - 200 - application/grpc 1091.6047ms
The program 'dotnet' has exited with code 0 (0x0).
The program 'dotnet' has exited with code 0 (0x0).
The program 'dotnet' has exited with code 0 (0x0).
```