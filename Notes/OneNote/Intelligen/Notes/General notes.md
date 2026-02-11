1. How to deploy an update to a microservice when it is included in a container deployed on the cloud
2. Are we going to have stages? (QA, Stage, Develop, Production)
3. CI/CD where and how? See Spinaker
4. Http calls vs Pub/Sub
5. What host do we need to run multiple containers?
6. Are we going to use Kubernetes on Azure?
7. API Gateway works on Azure, do we need something similar for local deployment? Ocelot?
8. An API communicates with another API with GRPC?

## MODULES & BACKING SERVICES
 
1. Logger-event aggregator-\>Azure Monitor/Splunk
2. Metrics
3. Configuration service sharing data to microservices
4. Cache
5. Message broker
6. Health service-monitoring
7. Container Orchestrator
8. Circuit breakers

## CHALLENGE
 
- Follow 12-Factor Application rules, [https://12factor.net/](https://12factor.net/), [https://docs.microsoft.com/en-us/dotnet/architecture/cloud-native/definition](https://docs.microsoft.com/en-us/dotnet/architecture/cloud-native/definition)
- Run on containers on premises or cloud
- Easy Deployment process that goes smoothly
- Define communication bus message structure -resiliency
- Access to distributed data
- Identities, Permissions, Roles
- Split application to microservices that can scale and be upgraded individually without breaking the whole app
- Service discovery -\> enable containers to locate each other
- Azure Resource Manager
- API Gateway implementation
- MediatR see Brighter library [https://codeopinion.com/why-use-mediatr-3-reasons-why-and-1-reason-not/](https://codeopinion.com/why-use-mediatr-3-reasons-why-and-1-reason-not/)
 
![Monitoring Storage Services Streaming Services Doc...](Exported%20image%2020260209140509-0.png)

Api to Api -\> GRPC  
Service to Service -\> EventBus with RabbitMQ  
Service Event handlers -\> MediatR  
Polly policies

[https://docs.celeryproject.org/en/stable/](https://docs.celeryproject.org/en/stable/)

**Test names template**: function_arrange_whatToExpect

```
[12:46:14 ERR] Failed executing DbCommand (8ms) [Parameters=[@p10='?' (DbType = Int32), @p11='?' (Size = 4000), @p12='?' (DbType = Int32), @p13='?' (DbType = DateTime2), @p14='?' (DbType = Int32), @p15='?' (DbType = Int32), @p16='?' (Size = 4000), @p17='?' (Size = 4000), @p18='?' (Size = 4000), @p19='?' (Size = 4000), @p20='?' (Size = 4000)], CommandType='Text', CommandTimeout='30']
SET NOCOUNT ON;
INSERT INTO [ordering].[orders] ([Id], [Description], [BuyerId], [OrderDate], [OrderStatusId], [PaymentMethodId], [Address_City], [Address_Country], [Address_State], [Address_Street], [Address_ZipCode])
VALUES (@p10, @p11, @p12, @p13, @p14, @p15, @p16, @p17, @p18, @p19, @p20);
Application Insights Telemetry (unconfigured): {"name":"AppDependencies","time":"2021-11-17T12:46:14.2995596Z","tags":{"ai.application.ver":"1.0.0.0","ai.cloud.roleInstance":"4b0892fe7d0d","ai.operation.id":"e0d71836ad1f4a1c8ee0d3165ce4d012","ai.internal.sdkVersion":"rdddsc:2.16.0-18277","ai.internal.nodeName":"4b0892fe7d0d.localdomain"},"data":{"baseType":"RemoteDependencyData","baseData":{"ver":2,"name":"sqldata | Microsoft.eShopOnContainers.Services.OrderingDb","id":"e0d71836ad1f4a1c8ee0d3165ce4d012","duration":"00:00:00.0022793","success":true,"type":"SQL","target":"sqldata | Microsoft.eShopOnContainers.Services.OrderingDb","properties":{"_MS.ProcessedByMetricExtractors":"(Name:'Dependencies', Ver:'1.1')","DeveloperMode":"true","AspNetCoreEnvironment":"Development"}}}}
[12:46:14 ERR] An exception occurred in the database while saving changes for context type 'Microsoft.eShopOnContainers.Services.Ordering.Infrastructure.OrderingContext'.
Microsoft.EntityFrameworkCore.DbUpdateException: An error occurred while updating the entries. See the inner exception for details.
 ---\> Microsoft.Data.SqlClient.SqlException (0x80131904): The INSERT statement conflicted with the FOREIGN KEY constraint "FK_orders_orderstatus_OrderStatusId". The conflict occurred in database "Microsoft.eShopOnContainers.Services.OrderingDb", table "ordering.orderstatus", column 'Id'.
The statement has been terminated.
   at Microsoft.Data.SqlClient.SqlCommand.\<\>c.\<ExecuteDbDataReaderAsync\>b__188_0(Task`1 result)
   at System.Threading.Tasks.ContinuationResultTaskFromResultTask`2.InnerInvoke()
   at System.Threading.ExecutionContext.RunInternal(ExecutionContext executionContext, ContextCallback callback, Object state)
--- End of stack trace from previous location ---
   at System.Threading.Tasks.Task.ExecuteWithThreadLocal(Task& currentTaskSlot, Thread threadPoolThread)
--- End of stack trace from previous location ---
   at Microsoft.EntityFrameworkCore.Storage.RelationalCommand.ExecuteReaderAsync(RelationalCommandParameterObject parameterObject, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Storage.RelationalCommand.ExecuteReaderAsync(RelationalCommandParameterObject parameterObject, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Update.ReaderModificationCommandBatch.ExecuteAsync(IRelationalConnection connection, CancellationToken cancellationToken)
ClientConnectionId:2b08a53e-fc68-4406-8f06-3c96a4b77eaa
Error Number:547,State:0,Class:16
   --- End of inner exception stack trace ---
   at Microsoft.EntityFrameworkCore.Update.ReaderModificationCommandBatch.ExecuteAsync(IRelationalConnection connection, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Update.Internal.BatchExecutor.ExecuteAsync(IEnumerable`1 commandBatches, IRelationalConnection connection, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Update.Internal.BatchExecutor.ExecuteAsync(IEnumerable`1 commandBatches, IRelationalConnection connection, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Update.Internal.BatchExecutor.ExecuteAsync(IEnumerable`1 commandBatches, IRelationalConnection connection, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.ChangeTracking.Internal.StateManager.SaveChangesAsync(IList`1 entriesToSave, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.ChangeTracking.Internal.StateManager.SaveChangesAsync(DbContext _, Boolean acceptAllChangesOnSuccess, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.DbContext.SaveChangesAsync(Boolean acceptAllChangesOnSuccess, CancellationToken cancellationToken)
Microsoft.EntityFrameworkCore.DbUpdateException: An error occurred while updating the entries. See the inner exception for details.
 ---\> Microsoft.Data.SqlClient.SqlException (0x80131904): The INSERT statement conflicted with the FOREIGN KEY constraint "FK_orders_orderstatus_OrderStatusId". The conflict occurred in database "Microsoft.eShopOnContainers.Services.OrderingDb", table "ordering.orderstatus", column 'Id'.
The statement has been terminated.
   at Microsoft.Data.SqlClient.SqlCommand.\<\>c.\<ExecuteDbDataReaderAsync\>b__188_0(Task`1 result)
   at System.Threading.Tasks.ContinuationResultTaskFromResultTask`2.InnerInvoke()
   at System.Threading.ExecutionContext.RunInternal(ExecutionContext executionContext, ContextCallback callback, Object state)
--- End of stack trace from previous location ---
   at System.Threading.Tasks.Task.ExecuteWithThreadLocal(Task& currentTaskSlot, Thread threadPoolThread)
--- End of stack trace from previous location ---
   at Microsoft.EntityFrameworkCore.Storage.RelationalCommand.ExecuteReaderAsync(RelationalCommandParameterObject parameterObject, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Storage.RelationalCommand.ExecuteReaderAsync(RelationalCommandParameterObject parameterObject, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Update.ReaderModificationCommandBatch.ExecuteAsync(IRelationalConnection connection, CancellationToken cancellationToken)
ClientConnectionId:2b08a53e-fc68-4406-8f06-3c96a4b77eaa
Error Number:547,State:0,Class:16
   --- End of inner exception stack trace ---
   at Microsoft.EntityFrameworkCore.Update.ReaderModificationCommandBatch.ExecuteAsync(IRelationalConnection connection, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Update.Internal.BatchExecutor.ExecuteAsync(IEnumerable`1 commandBatches, IRelationalConnection connection, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Update.Internal.BatchExecutor.ExecuteAsync(IEnumerable`1 commandBatches, IRelationalConnection connection, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Update.Internal.BatchExecutor.ExecuteAsync(IEnumerable`1 commandBatches, IRelationalConnection connection, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.ChangeTracking.Internal.StateManager.SaveChangesAsync(IList`1 entriesToSave, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.ChangeTracking.Internal.StateManager.SaveChangesAsync(DbContext _, Boolean acceptAllChangesOnSuccess, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.DbContext.SaveChangesAsync(Boolean acceptAllChangesOnSuccess, CancellationToken cancellationToken)
Exception thrown: 'Microsoft.EntityFrameworkCore.DbUpdateException' in System.Private.CoreLib.dll
Exception thrown: 'Microsoft.EntityFrameworkCore.DbUpdateException' in System.Private.CoreLib.dll
Exception thrown: 'Microsoft.EntityFrameworkCore.DbUpdateException' in System.Private.CoreLib.dll
Exception thrown: 'Microsoft.EntityFrameworkCore.DbUpdateException' in System.Private.CoreLib.dll
Exception thrown: 'Microsoft.EntityFrameworkCore.DbUpdateException' in System.Private.CoreLib.dll
Exception thrown: 'Microsoft.EntityFrameworkCore.DbUpdateException' in System.Private.CoreLib.dll
[12:46:14 ERR] ERROR Handling transaction for CreateOrderCommand ({"UserId": "99825c6f-4c2d-4734-b928-1011fd33bbd6", "UserName": "demouser@microsoft.com", "City": "Redmond", "Street": "15703 NE 61st Ct", "State": "WA", "Country": "U.S.", "ZipCode": "98052", "CardNumber": "4012888888881881", "CardHolderName": "DemoUser", "CardExpiration": "2021-12-01T00:00:00.0000000", "CardSecurityNumber": "535", "CardTypeId": 1, "OrderItems": [{"ProductId": 2, "ProductName": ".NET Black & White Mug", "UnitPrice": 8.5, "Discount": 0, "Units": 1, "PictureUrl": "http://host.docker.internal:5202/c/api/v1/catalog/items/2/pic/", "$type": "OrderItemDTO"}], "$type": "CreateOrderCommand"})
Microsoft.EntityFrameworkCore.DbUpdateException: An error occurred while updating the entries. See the inner exception for details.
 ---\> Microsoft.Data.SqlClient.SqlException (0x80131904): The INSERT statement conflicted with the FOREIGN KEY constraint "FK_orders_orderstatus_OrderStatusId". The conflict occurred in database "Microsoft.eShopOnContainers.Services.OrderingDb", table "ordering.orderstatus", column 'Id'.
The statement has been terminated.
   at Microsoft.Data.SqlClient.SqlCommand.\<\>c.\<ExecuteDbDataReaderAsync\>b__188_0(Task`1 result)
   at System.Threading.Tasks.ContinuationResultTaskFromResultTask`2.InnerInvoke()
   at System.Threading.ExecutionContext.RunInternal(ExecutionContext executionContext, ContextCallback callback, Object state)
--- End of stack trace from previous location ---
   at System.Threading.Tasks.Task.ExecuteWithThreadLocal(Task& currentTaskSlot, Thread threadPoolThread)
--- End of stack trace from previous location ---
   at Microsoft.EntityFrameworkCore.Storage.RelationalCommand.ExecuteReaderAsync(RelationalCommandParameterObject parameterObject, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Storage.RelationalCommand.ExecuteReaderAsync(RelationalCommandParameterObject parameterObject, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Update.ReaderModificationCommandBatch.ExecuteAsync(IRelationalConnection connection, CancellationToken cancellationToken)
ClientConnectionId:2b08a53e-fc68-4406-8f06-3c96a4b77eaa
Error Number:547,State:0,Class:16
   --- End of inner exception stack trace ---
   at Microsoft.EntityFrameworkCore.Update.ReaderModificationCommandBatch.ExecuteAsync(IRelationalConnection connection, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Update.Internal.BatchExecutor.ExecuteAsync(IEnumerable`1 commandBatches, IRelationalConnection connection, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Update.Internal.BatchExecutor.ExecuteAsync(IEnumerable`1 commandBatches, IRelationalConnection connection, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Update.Internal.BatchExecutor.ExecuteAsync(IEnumerable`1 commandBatches, IRelationalConnection connection, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.ChangeTracking.Internal.StateManager.SaveChangesAsync(IList`1 entriesToSave, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.ChangeTracking.Internal.StateManager.SaveChangesAsync(DbContext _, Boolean acceptAllChangesOnSuccess, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.DbContext.SaveChangesAsync(Boolean acceptAllChangesOnSuccess, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.DbContext.SaveChangesAsync(Boolean acceptAllChangesOnSuccess, CancellationToken cancellationToken)
   at Microsoft.eShopOnContainers.Services.Ordering.Infrastructure.OrderingContext.SaveEntitiesAsync(CancellationToken cancellationToken) in D:\Developer\Development-Assets\eShopOnContainers\src\Services\Ordering\Ordering.Infrastructure\OrderingContext.cs:line 67
   at Ordering.API.Application.DomainEventHandlers.OrderStartedEvent.ValidateOrAddBuyerAggregateWhenOrderStartedDomainEventHandler.Handle(OrderStartedDomainEvent orderStartedEvent, CancellationToken cancellationToken) in D:\Developer\Development-Assets\eShopOnContainers\src\Services\Ordering\Ordering.API\Application\DomainEventHandlers\OrderStartedEvent\ValidateOrAddBuyerAggregateWhenOrderStartedDomainEventHandler.cs:line 57
   at MediatR.Mediator.PublishCore(IEnumerable`1 allHandlers, INotification notification, CancellationToken cancellationToken)
   at Ordering.Infrastructure.MediatorExtension.DispatchDomainEventsAsync(IMediator mediator, OrderingContext ctx) in D:\Developer\Development-Assets\eShopOnContainers\src\Services\Ordering\Ordering.Infrastructure\MediatorExtension.cs:line 25
   at Microsoft.eShopOnContainers.Services.Ordering.Infrastructure.OrderingContext.SaveEntitiesAsync(CancellationToken cancellationToken) in D:\Developer\Development-Assets\eShopOnContainers\src\Services\Ordering\Ordering.Infrastructure\OrderingContext.cs:line 63
   at Microsoft.eShopOnContainers.Services.Ordering.API.Application.Commands.CreateOrderCommandHandler.Handle(CreateOrderCommand message, CancellationToken cancellationToken) in D:\Developer\Development-Assets\eShopOnContainers\src\Services\Ordering\Ordering.API\Application\Commands\CreateOrderCommandHandler.cs:line 60
   at Ordering.API.Application.Behaviors.TransactionBehaviour`2.Handle(TRequest request, CancellationToken cancellationToken, RequestHandlerDelegate`1 next) in D:\Developer\Development-Assets\eShopOnContainers\src\Services\Ordering\Ordering.API\Application\Behaviors\TransactionBehaviour.cs:line 38
Exception thrown: 'Microsoft.EntityFrameworkCore.DbUpdateException' in Ordering.API.dll
Exception thrown: 'Microsoft.EntityFrameworkCore.DbUpdateException' in System.Private.CoreLib.dll
Exception thrown: 'Microsoft.EntityFrameworkCore.DbUpdateException' in System.Private.CoreLib.dll
Exception thrown: 'Microsoft.EntityFrameworkCore.DbUpdateException' in System.Private.CoreLib.dll
Application Insights Telemetry (unconfigured): {"name":"AppMetrics","time":"2021-11-17T12:46:14.7446647Z","seq":"0","tags":{"ai.application.ver":"1.0.0.0","ai.cloud.roleInstance":"d119f7952cd0","ai.operation.syntheticSource":"HeartbeatState","ai.internal.sdkVersion":"hbnetc:2.16.0-18277","ai.internal.nodeName":"d119f7952cd0.localdomain"},"data":{"baseType":"MetricData","baseData":{"ver":2,"metrics":[{"name":"HeartbeatState","kind":"Aggregation","value":0,"count":1}],"properties":{"DeveloperMode":"true","processSessionId":"087e22bd-2b59-4ffe-8fea-5c2a1e44221d","osType":"LINUX","AspNetCoreEnvironment":"Development","baseSdkTargetFramework":"netstandard2.0","runtimeFramework":".NET 5.0.12"}}}}
[12:46:14 INF] ----- Commit transaction 7aa0339e-f8cd-4bda-a97b-902884e6dfc9 for IdentifiedCommand\<CreateOrderCommand,Boolean\>
Application Insights Telemetry (unconfigured): {"name":"AppDependencies","time":"2021-11-17T12:46:14.7570425Z","tags":{"ai.application.ver":"1.0.0.0","ai.cloud.roleInstance":"4b0892fe7d0d","ai.operation.id":"a24c86fd47fb49f0be487d45e3a0e613","ai.internal.sdkVersion":"rdddsc:2.16.0-18277","ai.internal.nodeName":"4b0892fe7d0d.localdomain"},"data":{"baseType":"RemoteDependencyData","baseData":{"ver":2,"name":"sqldata | Microsoft.eShopOnContainers.Services.OrderingDb","id":"a24c86fd47fb49f0be487d45e3a0e613","duration":"00:00:00.0024443","success":true,"type":"SQL","target":"sqldata | Microsoft.eShopOnContainers.Services.OrderingDb","properties":{"_MS.ProcessedByMetricExtractors":"(Name:'Dependencies', Ver:'1.1')","DeveloperMode":"true","AspNetCoreEnvironment":"Development"}}}}
Application Insights Telemetry (unconfigured): {"name":"AppDependencies","time":"2021-11-17T12:46:14.7629216Z","tags":{"ai.application.ver":"1.0.0.0","ai.cloud.roleInstance":"4b0892fe7d0d","ai.operation.id":"a24fa59b34dc4e53bf53dc270e44c5b5","ai.internal.sdkVersion":"rdddsc:2.16.0-18277","ai.internal.nodeName":"4b0892fe7d0d.localdomain"},"data":{"baseType":"RemoteDependencyData","baseData":{"ver":2,"name":"sqldata | Microsoft.eShopOnContainers.Services.OrderingDb","id":"a24fa59b34dc4e53bf53dc270e44c5b5","duration":"00:00:00.0613391","success":true,"type":"SQL","target":"sqldata | Microsoft.eShopOnContainers.Services.OrderingDb","properties":{"_MS.ProcessedByMetricExtractors":"(Name:'Dependencies', Ver:'1.1')","DeveloperMode":"true","AspNetCoreEnvironment":"Development"}}}}
Application Insights Telemetry (unconfigured): {"name":"AppDependencies","time":"2021-11-17T12:46:14.8835299Z","tags":{"ai.application.ver":"1.0.0.0","ai.cloud.roleInstance":"4b0892fe7d0d","ai.operation.id":"abab7f24492e44619ad1f8f24c25496b","ai.internal.sdkVersion":"rdddsc:2.16.0-18277","ai.internal.nodeName":"4b0892fe7d0d.localdomain"},"data":{"baseType":"RemoteDependencyData","baseData":{"ver":2,"name":"sqldata | Microsoft.eShopOnContainers.Services.OrderingDb","id":"abab7f24492e44619ad1f8f24c25496b","duration":"00:00:00.0700683","success":true,"type":"SQL","target":"sqldata | Microsoft.eShopOnContainers.Services.OrderingDb","properties":{"_MS.ProcessedByMetricExtractors":"(Name:'Dependencies', Ver:'1.1')","DeveloperMode":"true","AspNetCoreEnvironment":"Development"}}}}
Application Insights Telemetry (unconfigured): {"name":"AppDependencies","time":"2021-11-17T12:46:14.9930108Z","tags":{"ai.application.ver":"1.0.0.0","ai.cloud.roleInstance":"4b0892fe7d0d","ai.operation.id":"99ee25476e894e7b95f37fcd92a30196","ai.internal.sdkVersion":"rdddsc:2.16.0-18277","ai.internal.nodeName":"4b0892fe7d0d.localdomain"},"data":{"baseType":"RemoteDependencyData","baseData":{"ver":2,"name":"sqldata | Microsoft.eShopOnContainers.Services.OrderingDb","id":"99ee25476e894e7b95f37fcd92a30196","duration":"00:00:00.1055178","resultCode":"547","success":false,"type":"SQL","target":"sqldata | Microsoft.eShopOnContainers.Services.OrderingDb","properties":{"_MS.ProcessedByMetricExtractors":"(Name:'Dependencies', Ver:'1.1')","Exception":"Microsoft.Data.SqlClient.SqlException (0x80131904): The INSERT statement conflicted with the FOREIGN KEY constraint \"FK_orders_orderstatus_OrderStatusId\". The conflict occurred in database \"Microsoft.eShopOnContainers.Services.OrderingDb\", table \"ordering.orderstatus\", column 'Id'.\nThe statement has been terminated.\n   at Microsoft.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)\n   at Microsoft.Data.SqlClient.SqlInternalConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)\n   at Microsoft.Data.SqlClient.TdsParser.ThrowExceptionAndWarning(TdsParserStateObject stateObj, Boolean callerHasConnectionLock, Boolean asyncClose)\n   at Microsoft.Data.SqlClient.TdsParser.TryRun(RunBehavior runBehavior, SqlCommand cmdHandler, SqlDataReader dataStream, BulkCopySimpleResultSet bulkCopyHandler, TdsParserStateObject stateObj, Boolean& dataReady)\n   at Microsoft.Data.SqlClient.SqlDataReader.TryConsumeMetaData()\n   at Microsoft.Data.SqlClient.SqlDataReader.get_MetaData()\n   at Microsoft.Data.SqlClient.SqlCommand.FinishExecuteReader(SqlDataReader ds, RunBehavior runBehavior, String resetOptionsString, Boolean isInternal, Boolean forDescribeParameterEncryption, Boolean shouldCacheForAlwaysEncrypted)\n   at Microsoft.Data.SqlClient.SqlCommand.CompleteAsyncExecuteReader(Boolean isInternal, Boolean forDescribeParameterEncryption)\n   at Microsoft.Data.SqlClient.SqlCommand.InternalEndExecuteReader(IAsyncResult asyncResult, Boolean isInternal, String endMethod)\n   at Microsoft.Data.SqlClient.SqlCommand.EndExecuteReaderInternal(IAsyncResult asyncResult)\n   at Microsoft.Data.SqlClient.SqlCommand.EndExecuteReaderAsync(IAsyncResult asyncResult)\n   at System.Threading.Tasks.TaskFactory`1.FromAsyncCoreLogic(IAsyncResult iar, Func`2 endFunction, Action`1 endAction, Task`1 promise, Boolean requiresSynchronization)\nClientConnectionId:2b08a53e-fc68-4406-8f06-3c96a4b77eaa\nError Number:547,State:0,Class:16","DeveloperMode":"true","AspNetCoreEnvironment":"Development"}}}}
[12:46:15 ERR] Failed executing DbCommand (128ms) [Parameters=[@p10='?' (DbType = Int32), @p11='?' (Size = 4000), @p12='?' (DbType = Int32), @p13='?' (DbType = DateTime2), @p14='?' (DbType = Int32), @p15='?' (DbType = Int32), @p16='?' (Size = 4000), @p17='?' (Size = 4000), @p18='?' (Size = 4000), @p19='?' (Size = 4000), @p20='?' (Size = 4000)], CommandType='Text', CommandTimeout='30']
SET NOCOUNT ON;
INSERT INTO [ordering].[orders] ([Id], [Description], [BuyerId], [OrderDate], [OrderStatusId], [PaymentMethodId], [Address_City], [Address_Country], [Address_State], [Address_Street], [Address_ZipCode])
VALUES (@p10, @p11, @p12, @p13, @p14, @p15, @p16, @p17, @p18, @p19, @p20);
Application Insights Telemetry (unconfigured): {"name":"AppDependencies","time":"2021-11-17T12:46:15.1217244Z","tags":{"ai.application.ver":"1.0.0.0","ai.cloud.roleInstance":"4b0892fe7d0d","ai.operation.id":"cd4107b7efa740d69bd9a9ce0cfd16a9","ai.internal.sdkVersion":"rdddsc:2.16.0-18277","ai.internal.nodeName":"4b0892fe7d0d.localdomain"},"data":{"baseType":"RemoteDependencyData","baseData":{"ver":2,"name":"sqldata | Microsoft.eShopOnContainers.Services.OrderingDb","id":"cd4107b7efa740d69bd9a9ce0cfd16a9","duration":"00:00:00.0215478","success":true,"type":"SQL","target":"sqldata | Microsoft.eShopOnContainers.Services.OrderingDb","properties":{"_MS.ProcessedByMetricExtractors":"(Name:'Dependencies', Ver:'1.1')","DeveloperMode":"true","AspNetCoreEnvironment":"Development"}}}}
[12:46:15 ERR] An exception occurred in the database while saving changes for context type 'Microsoft.eShopOnContainers.Services.Ordering.Infrastructure.OrderingContext'.
Microsoft.EntityFrameworkCore.DbUpdateException: An error occurred while updating the entries. See the inner exception for details.
 ---\> Microsoft.Data.SqlClient.SqlException (0x80131904): The INSERT statement conflicted with the FOREIGN KEY constraint "FK_orders_orderstatus_OrderStatusId". The conflict occurred in database "Microsoft.eShopOnContainers.Services.OrderingDb", table "ordering.orderstatus", column 'Id'.
The statement has been terminated.
   at Microsoft.Data.SqlClient.SqlCommand.\<\>c.\<ExecuteDbDataReaderAsync\>b__188_0(Task`1 result)
   at System.Threading.Tasks.ContinuationResultTaskFromResultTask`2.InnerInvoke()
   at System.Threading.ExecutionContext.RunInternal(ExecutionContext executionContext, ContextCallback callback, Object state)
--- End of stack trace from previous location ---
   at System.Threading.Tasks.Task.ExecuteWithThreadLocal(Task& currentTaskSlot, Thread threadPoolThread)
--- End of stack trace from previous location ---
   at Microsoft.EntityFrameworkCore.Storage.RelationalCommand.ExecuteReaderAsync(RelationalCommandParameterObject parameterObject, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Storage.RelationalCommand.ExecuteReaderAsync(RelationalCommandParameterObject parameterObject, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Update.ReaderModificationCommandBatch.ExecuteAsync(IRelationalConnection connection, CancellationToken cancellationToken)
ClientConnectionId:2b08a53e-fc68-4406-8f06-3c96a4b77eaa
Error Number:547,State:0,Class:16
   --- End of inner exception stack trace ---
   at Microsoft.EntityFrameworkCore.Update.ReaderModificationCommandBatch.ExecuteAsync(IRelationalConnection connection, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Update.Internal.BatchExecutor.ExecuteAsync(IEnumerable`1 commandBatches, IRelationalConnection connection, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Update.Internal.BatchExecutor.ExecuteAsync(IEnumerable`1 commandBatches, IRelationalConnection connection, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Update.Internal.BatchExecutor.ExecuteAsync(IEnumerable`1 commandBatches, IRelationalConnection connection, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.ChangeTracking.Internal.StateManager.SaveChangesAsync(IList`1 entriesToSave, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.ChangeTracking.Internal.StateManager.SaveChangesAsync(DbContext _, Boolean acceptAllChangesOnSuccess, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.DbContext.SaveChangesAsync(Boolean acceptAllChangesOnSuccess, CancellationToken cancellationToken)
Microsoft.EntityFrameworkCore.DbUpdateException: An error occurred while updating the entries. See the inner exception for details.
 ---\> Microsoft.Data.SqlClient.SqlException (0x80131904): The INSERT statement conflicted with the FOREIGN KEY constraint "FK_orders_orderstatus_OrderStatusId". The conflict occurred in database "Microsoft.eShopOnContainers.Services.OrderingDb", table "ordering.orderstatus", column 'Id'.
The statement has been terminated.
   at Microsoft.Data.SqlClient.SqlCommand.\<\>c.\<ExecuteDbDataReaderAsync\>b__188_0(Task`1 result)
   at System.Threading.Tasks.ContinuationResultTaskFromResultTask`2.InnerInvoke()
   at System.Threading.ExecutionContext.RunInternal(ExecutionContext executionContext, ContextCallback callback, Object state)
--- End of stack trace from previous location ---
   at System.Threading.Tasks.Task.ExecuteWithThreadLocal(Task& currentTaskSlot, Thread threadPoolThread)
--- End of stack trace from previous location ---
   at Microsoft.EntityFrameworkCore.Storage.RelationalCommand.ExecuteReaderAsync(RelationalCommandParameterObject parameterObject, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Storage.RelationalCommand.ExecuteReaderAsync(RelationalCommandParameterObject parameterObject, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Update.ReaderModificationCommandBatch.ExecuteAsync(IRelationalConnection connection, CancellationToken cancellationToken)
ClientConnectionId:2b08a53e-fc68-4406-8f06-3c96a4b77eaa
Error Number:547,State:0,Class:16
   --- End of inner exception stack trace ---
   at Microsoft.EntityFrameworkCore.Update.ReaderModificationCommandBatch.ExecuteAsync(IRelationalConnection connection, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Update.Internal.BatchExecutor.ExecuteAsync(IEnumerable`1 commandBatches, IRelationalConnection connection, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Update.Internal.BatchExecutor.ExecuteAsync(IEnumerable`1 commandBatches, IRelationalConnection connection, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Update.Internal.BatchExecutor.ExecuteAsync(IEnumerable`1 commandBatches, IRelationalConnection connection, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.ChangeTracking.Internal.StateManager.SaveChangesAsync(IList`1 entriesToSave, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.ChangeTracking.Internal.StateManager.SaveChangesAsync(DbContext _, Boolean acceptAllChangesOnSuccess, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.DbContext.SaveChangesAsync(Boolean acceptAllChangesOnSuccess, CancellationToken cancellationToken)
Exception thrown: 'Microsoft.EntityFrameworkCore.DbUpdateException' in System.Private.CoreLib.dll
Application Insights Telemetry (unconfigured): {"name":"AppDependencies","time":"2021-11-17T12:46:15.1810700Z","tags":{"ai.application.ver":"1.0.0.0","ai.cloud.roleInstance":"4b0892fe7d0d","ai.operation.id":"bc57f82dedd84c39a588a3b254e15cc9","ai.internal.sdkVersion":"rdddsc:2.16.0-18277","ai.internal.nodeName":"4b0892fe7d0d.localdomain"},"data":{"baseType":"RemoteDependencyData","baseData":{"ver":2,"name":"sqldata | Microsoft.eShopOnContainers.Services.OrderingDb | Rollback | ReadCommitted","id":"bc57f82dedd84c39a588a3b254e15cc9","data":"Rollback","duration":"00:00:00.0007896","success":true,"type":"SQL","target":"sqldata | Microsoft.eShopOnContainers.Services.OrderingDb","properties":{"_MS.ProcessedByMetricExtractors":"(Name:'Dependencies', Ver:'1.1')","DeveloperMode":"true","AspNetCoreEnvironment":"Development"}}}}
Exception thrown: 'Microsoft.EntityFrameworkCore.DbUpdateException' in Ordering.Infrastructure.dll
Exception thrown: 'Microsoft.EntityFrameworkCore.DbUpdateException' in System.Private.CoreLib.dll
Exception thrown: 'Microsoft.EntityFrameworkCore.DbUpdateException' in System.Private.CoreLib.dll
[12:46:15 ERR] ERROR Handling transaction for IdentifiedCommand\<CreateOrderCommand,Boolean\> ({"Command": {"UserId": "99825c6f-4c2d-4734-b928-1011fd33bbd6", "UserName": "demouser@microsoft.com", "City": "Redmond", "Street": "15703 NE 61st Ct", "State": "WA", "Country": "U.S.", "ZipCode": "98052", "CardNumber": "4012888888881881", "CardHolderName": "DemoUser", "CardExpiration": "2021-12-01T00:00:00.0000000", "CardSecurityNumber": "535", "CardTypeId": 1, "OrderItems": [{"ProductId": 2, "ProductName": ".NET Black & White Mug", "UnitPrice": 8.5, "Discount": 0, "Units": 1, "PictureUrl": "http://host.docker.internal:5202/c/api/v1/catalog/items/2/pic/", "$type": "OrderItemDTO"}], "$type": "CreateOrderCommand"}, "Id": "e16b5b9f-c08e-4dbb-8daf-a2e235a249f9", "$type": "IdentifiedCommand`2"})
Microsoft.EntityFrameworkCore.DbUpdateException: An error occurred while updating the entries. See the inner exception for details.
 ---\> Microsoft.Data.SqlClient.SqlException (0x80131904): The INSERT statement conflicted with the FOREIGN KEY constraint "FK_orders_orderstatus_OrderStatusId". The conflict occurred in database "Microsoft.eShopOnContainers.Services.OrderingDb", table "ordering.orderstatus", column 'Id'.
The statement has been terminated.
   at Microsoft.Data.SqlClient.SqlCommand.\<\>c.\<ExecuteDbDataReaderAsync\>b__188_0(Task`1 result)
   at System.Threading.Tasks.ContinuationResultTaskFromResultTask`2.InnerInvoke()
   at System.Threading.ExecutionContext.RunInternal(ExecutionContext executionContext, ContextCallback callback, Object state)
--- End of stack trace from previous location ---
   at System.Threading.Tasks.Task.ExecuteWithThreadLocal(Task& currentTaskSlot, Thread threadPoolThread)
--- End of stack trace from previous location ---
   at Microsoft.EntityFrameworkCore.Storage.RelationalCommand.ExecuteReaderAsync(RelationalCommandParameterObject parameterObject, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Storage.RelationalCommand.ExecuteReaderAsync(RelationalCommandParameterObject parameterObject, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Update.ReaderModificationCommandBatch.ExecuteAsync(IRelationalConnection connection, CancellationToken cancellationToken)
ClientConnectionId:2b08a53e-fc68-4406-8f06-3c96a4b77eaa
Error Number:547,State:0,Class:16
   --- End of inner exception stack trace ---
   at Microsoft.EntityFrameworkCore.Update.ReaderModificationCommandBatch.ExecuteAsync(IRelationalConnection connection, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Update.Internal.BatchExecutor.ExecuteAsync(IEnumerable`1 commandBatches, IRelationalConnection connection, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Update.Internal.BatchExecutor.ExecuteAsync(IEnumerable`1 commandBatches, IRelationalConnection connection, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Update.Internal.BatchExecutor.ExecuteAsync(IEnumerable`1 commandBatches, IRelationalConnection connection, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.ChangeTracking.Internal.StateManager.SaveChangesAsync(IList`1 entriesToSave, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.ChangeTracking.Internal.StateManager.SaveChangesAsync(DbContext _, Boolean acceptAllChangesOnSuccess, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.DbContext.SaveChangesAsync(Boolean acceptAllChangesOnSuccess, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.DbContext.SaveChangesAsync(Boolean acceptAllChangesOnSuccess, CancellationToken cancellationToken)
   at Microsoft.eShopOnContainers.Services.Ordering.Infrastructure.OrderingContext.CommitTransactionAsync(IDbContextTransaction transaction) in D:\Developer\Development-Assets\eShopOnContainers\src\Services\Ordering\Ordering.Infrastructure\OrderingContext.cs:line 88
   at Ordering.API.Application.Behaviors.TransactionBehaviour`2.\<\>c__DisplayClass4_0.\<\<Handle\>b__0\>d.MoveNext() in D:\Developer\Development-Assets\eShopOnContainers\src\Services\Ordering\Ordering.API\Application\Behaviors\TransactionBehaviour.cs:line 56
--- End of stack trace from previous location ---
   at Microsoft.EntityFrameworkCore.ExecutionStrategyExtensions.\<\>c.\<\<ExecuteAsync\>b__3_0\>d.MoveNext()
--- End of stack trace from previous location ---
   at Microsoft.EntityFrameworkCore.Storage.ExecutionStrategy.ExecuteImplementationAsync[TState,TResult](Func`4 operation, Func`4 verifySucceeded, TState state, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Storage.ExecutionStrategy.ExecuteImplementationAsync[TState,TResult](Func`4 operation, Func`4 verifySucceeded, TState state, CancellationToken cancellationToken)
   at Ordering.API.Application.Behaviors.TransactionBehaviour`2.Handle(TRequest request, CancellationToken cancellationToken, RequestHandlerDelegate`1 next) in D:\Developer\Development-Assets\eShopOnContainers\src\Services\Ordering\Ordering.API\Application\Behaviors\TransactionBehaviour.cs:line 43
Exception thrown: 'Microsoft.EntityFrameworkCore.DbUpdateException' in Ordering.API.dll
Exception thrown: 'Microsoft.EntityFrameworkCore.DbUpdateException' in System.Private.CoreLib.dll
Exception thrown: 'Microsoft.EntityFrameworkCore.DbUpdateException' in System.Private.CoreLib.dll
Exception thrown: 'Microsoft.EntityFrameworkCore.DbUpdateException' in System.Private.CoreLib.dll
Exception thrown: 'Microsoft.EntityFrameworkCore.DbUpdateException' in System.Private.CoreLib.dll
Exception thrown: 'Microsoft.EntityFrameworkCore.DbUpdateException' in System.Private.CoreLib.dll
The thread 0x3f5 has exited with code 0 (0x0).
[12:46:15 WRN] ----- ERROR Processing message "{
  "UserId": "99825c6f-4c2d-4734-b928-1011fd33bbd6",
  "UserName": "demouser@microsoft.com",
  "OrderNumber": 0,
  "City": "Redmond",
  "Street": "15703 NE 61st Ct",
  "State": "WA",
  "Country": "U.S.",
  "ZipCode": "98052",
  "CardNumber": "4012888888881881",
  "CardHolderName": "DemoUser",
  "CardExpiration": "2021-12-01T00:00:00",
  "CardSecurityNumber": "535",
  "CardTypeId": 1,
  "Buyer": null,
  "RequestId": "e16b5b9f-c08e-4dbb-8daf-a2e235a249f9",
  "Basket": {
    "BuyerId": "99825c6f-4c2d-4734-b928-1011fd33bbd6",
    "Items": [
      {
        "Id": "b1a5f0eb-ef62-4c21-ab04-88c92b74a966",
        "ProductId": 2,
        "ProductName": ".NET Black \u0026 White Mug",
        "UnitPrice": 8.5,
        "OldUnitPrice": 0,
        "Quantity": 1,
        "PictureUrl": "http://host.docker.internal:5202/c/api/v1/catalog/items/2/pic/"
      }
    ]
  },
  "Id": "84f858fb-eca1-43cb-b235-cd5566083b66",
  "CreationDate": "2021-11-17T12:45:55.0401089Z"
}"
Microsoft.EntityFrameworkCore.DbUpdateException: An error occurred while updating the entries. See the inner exception for details.
 ---\> Microsoft.Data.SqlClient.SqlException (0x80131904): The INSERT statement conflicted with the FOREIGN KEY constraint "FK_orders_orderstatus_OrderStatusId". The conflict occurred in database "Microsoft.eShopOnContainers.Services.OrderingDb", table "ordering.orderstatus", column 'Id'.
The statement has been terminated.
   at Microsoft.Data.SqlClient.SqlCommand.\<\>c.\<ExecuteDbDataReaderAsync\>b__188_0(Task`1 result)
   at System.Threading.Tasks.ContinuationResultTaskFromResultTask`2.InnerInvoke()
   at System.Threading.ExecutionContext.RunInternal(ExecutionContext executionContext, ContextCallback callback, Object state)
--- End of stack trace from previous location ---
   at System.Threading.Tasks.Task.ExecuteWithThreadLocal(Task& currentTaskSlot, Thread threadPoolThread)
--- End of stack trace from previous location ---
   at Microsoft.EntityFrameworkCore.Storage.RelationalCommand.ExecuteReaderAsync(RelationalCommandParameterObject parameterObject, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Storage.RelationalCommand.ExecuteReaderAsync(RelationalCommandParameterObject parameterObject, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Update.ReaderModificationCommandBatch.ExecuteAsync(IRelationalConnection connection, CancellationToken cancellationToken)
ClientConnectionId:2b08a53e-fc68-4406-8f06-3c96a4b77eaa
Error Number:547,State:0,Class:16
   --- End of inner exception stack trace ---
   at Microsoft.EntityFrameworkCore.Update.ReaderModificationCommandBatch.ExecuteAsync(IRelationalConnection connection, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Update.Internal.BatchExecutor.ExecuteAsync(IEnumerable`1 commandBatches, IRelationalConnection connection, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Update.Internal.BatchExecutor.ExecuteAsync(IEnumerable`1 commandBatches, IRelationalConnection connection, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Update.Internal.BatchExecutor.ExecuteAsync(IEnumerable`1 commandBatches, IRelationalConnection connection, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.ChangeTracking.Internal.StateManager.SaveChangesAsync(IList`1 entriesToSave, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.ChangeTracking.Internal.StateManager.SaveChangesAsync(DbContext _, Boolean acceptAllChangesOnSuccess, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.DbContext.SaveChangesAsync(Boolean acceptAllChangesOnSuccess, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.DbContext.SaveChangesAsync(Boolean acceptAllChangesOnSuccess, CancellationToken cancellationToken)
   at Microsoft.eShopOnContainers.Services.Ordering.Infrastructure.OrderingContext.CommitTransactionAsync(IDbContextTransaction transaction) in D:\Developer\Development-Assets\eShopOnContainers\src\Services\Ordering\Ordering.Infrastructure\OrderingContext.cs:line 88
   at Ordering.API.Application.Behaviors.TransactionBehaviour`2.\<\>c__DisplayClass4_0.\<\<Handle\>b__0\>d.MoveNext() in D:\Developer\Development-Assets\eShopOnContainers\src\Services\Ordering\Ordering.API\Application\Behaviors\TransactionBehaviour.cs:line 56
--- End of stack trace from previous location ---
   at Microsoft.EntityFrameworkCore.ExecutionStrategyExtensions.\<\>c.\<\<ExecuteAsync\>b__3_0\>d.MoveNext()
--- End of stack trace from previous location ---
   at Microsoft.EntityFrameworkCore.Storage.ExecutionStrategy.ExecuteImplementationAsync[TState,TResult](Func`4 operation, Func`4 verifySucceeded, TState state, CancellationToken cancellationToken)
   at Microsoft.EntityFrameworkCore.Storage.ExecutionStrategy.ExecuteImplementationAsync[TState,TResult](Func`4 operation, Func`4 verifySucceeded, TState state, CancellationToken cancellationToken)
   at Ordering.API.Application.Behaviors.TransactionBehaviour`2.Handle(TRequest request, CancellationToken cancellationToken, RequestHandlerDelegate`1 next) in D:\Developer\Development-Assets\eShopOnContainers\src\Services\Ordering\Ordering.API\Application\Behaviors\TransactionBehaviour.cs:line 43
   at Ordering.API.Application.Behaviors.ValidatorBehavior`2.Handle(TRequest request, CancellationToken cancellationToken, RequestHandlerDelegate`1 next) in D:\Developer\Development-Assets\eShopOnContainers\src\Services\Ordering\Ordering.API\Application\Behaviors\ValidatorBehavior.cs:line 43
   at Ordering.API.Application.Behaviors.LoggingBehavior`2.Handle(TRequest request, CancellationToken cancellationToken, RequestHandlerDelegate`1 next) in D:\Developer\Development-Assets\eShopOnContainers\src\Services\Ordering\Ordering.API\Application\Behaviors\LoggingBehavior.cs:line 17
   at Ordering.API.Application.IntegrationEvents.EventHandling.UserCheckoutAcceptedIntegrationEventHandler.Handle(UserCheckoutAcceptedIntegrationEvent event) in D:\Developer\Development-Assets\eShopOnContainers\src\Services\Ordering\Ordering.API\Application\IntegrationEvents\EventHandling\UserCheckoutAcceptedIntegrationEventHandler.cs:line 61
   at Microsoft.eShopOnContainers.BuildingBlocks.EventBusRabbitMQ.EventBusRabbitMQ.ProcessEvent(String eventName, String message) in D:\Developer\Development-Assets\eShopOnContainers\src\BuildingBlocks\EventBus\EventBusRabbitMQ\EventBusRabbitMQ.cs:line 286
   at Microsoft.eShopOnContainers.BuildingBlocks.EventBusRabbitMQ.EventBusRabbitMQ.Consumer_Received(Object sender, BasicDeliverEventArgs eventArgs) in D:\Developer\Development-Assets\eShopOnContainers\src\BuildingBlocks\EventBus\EventBusRabbitMQ\EventBusRabbitMQ.cs:line 213
Application Insights Telemetry (unconfigured): {"name":"AppMetrics","time":"2021-11-17T12:46:15.8320349Z","seq":"0","tags":{"ai.application.ver":"1.0.0.0","ai.cloud.roleInstance":"62398bea5877","ai.operation.syntheticSource":"HeartbeatState","ai.internal.sdkVersion":"hbnetc:2.16.0-18277","ai.internal.nodeName":"62398bea5877.localdomain"},"data":{"baseType":"MetricData","baseData":{"ver":2,"metrics":[{"name":"HeartbeatState","kind":"Aggregation","value":0,"count":1}],"properties":{"osType":"LINUX","processSessionId":"5bcfe320-1b6c-4a73-a6c7-7c097f2a8cad","DeveloperMode":"true","runtimeFramework":".NET 5.0.12","AspNetCoreEnvironment":"Development","baseSdkTargetFramework":"netstandard2.0"}}}}
Application Insights Telemetry (unconfigured): {"name":"AppDependencies","time":"2021-11-17T12:46:16.0217367Z","tags":{"ai.application.ver":"1.0.0.0","ai.cloud.roleInstance":"4b0892fe7d0d","ai.operation.id":"1d1b918f04d66841ac0d1cb58be117a0","ai.internal.sdkVersion":"rdddsc:2.16.0-18277","ai.internal.nodeName":"4b0892fe7d0d.localdomain"},"data":{"baseType":"RemoteDependencyData","baseData":{"ver":2,"name":"POST /api/events/raw","id":"3ee8bdc514fcd14a","data":"http://seq/api/events/raw","duration":"00:00:00.0114137","resultCode":"201","success":true,"type":"Http","target":"seq","properties":{"_MS.ProcessedByMetricExtractors":"(Name:'Dependencies', Ver:'1.1')","DeveloperMode":"true","AspNetCoreEnvironment":"Development"}}}}
The thread 0x5e2 has exited with code 0 (0x0).
The thread 0x5ca has exited with code 0 (0x0).
Application Insights Telemetry (unconfigured): {"name":"AppMetrics","time":"2021-11-17T12:46:17.8851966Z","tags":{"ai.application.ver":"1.0.0.0","ai.cloud.roleInstance":"d119f7952cd0","ai.internal.sdkVersion":"pccore:2.16.0-18277","ai.internal.nodeName":"d119f7952cd0.localdomain"},"data":{"baseType":"MetricData","baseData":{"ver":2,"metrics":[{"name":"\\Process(??APP_WIN32_PROC??)\\% Processor Time","kind":"Aggregation","value":1.0831466223238215,"count":1,"min":1.0831466223238215,"max":1.0831466223238215,"stdDev":0}],"properties":{"DeveloperMode":"true","CustomPerfCounter":"true","AspNetCoreEnvironment":"Development","CounterInstanceName":"??APP_WIN32_PROC??"}}}}
Application Insights Telemetry (unconfigured): {"name":"AppMetrics","time":"2021-11-17T12:46:17.8874520Z","tags":{"ai.application.ver":"1.0.0.0","ai.cloud.roleInstance":"d119f7952cd0","ai.internal.sdkVersion":"pccore:2.16.0-18277","ai.internal.nodeName":"d119f7952cd0.localdomain"},"data":{"baseType":"MetricData","baseData":{"ver":2,"metrics":[{"name":"\\Process(??APP_WIN32_PROC??)\\% Processor Time Normalized","kind":"Aggregation","value":0.27078677335290047,"count":1,"min":0.27078677335290047,"max":0.27078677335290047,"stdDev":0}],"properties":{"DeveloperMode":"true","CustomPerfCounter":"true","AspNetCoreEnvironment":"Development","CounterInstanceName":"??APP_WIN32_PROC??"}}}}
Application Insights Telemetry (unconfigured): {"name":"AppMetrics","time":"2021-11-17T12:46:17.8894637Z","tags":{"ai.application.ver":"1.0.0.0","ai.cloud.roleInstance":"d119f7952cd0","ai.internal.sdkVersion":"pccore:2.16.0-18277","ai.internal.nodeName":"d119f7952cd0.localdomain"},"data":{"baseType":"MetricData","baseData":{"ver":2,"metrics":[{"name":"\\Process(??APP_WIN32_PROC??)\\Private Bytes","kind":"Aggregation","value":338055168,"count":1,"min":338055168,"max":338055168,"stdDev":0}],"properties":{"DeveloperMode":"true","CustomPerfCounter":"true","AspNetCoreEnvironment":"Development","CounterInstanceName":"??APP_WIN32_PROC??"}}}}
The thread 0x4ec has exited with code 0 (0x0).
Application Insights Telemetry (unconfigured): {"name":"AppMetrics","time":"2021-11-17T12:46:18.9321556Z","tags":{"ai.application.ver":"1.0.0.0","ai.cloud.roleInstance":"62398bea5877","ai.internal.sdkVersion":"pccore:2.16.0-18277","ai.internal.nodeName":"62398bea5877.localdomain"},"data":{"baseType":"MetricData","baseData":{"ver":2,"metrics":[{"name":"\\Process(??APP_WIN32_PROC??)\\% Processor Time","kind":"Aggregation","value":0.6833276936021021,"count":1,"min":0.6833276936021021,"max":0.6833276936021021,"stdDev":0}],"properties":{"CounterInstanceName":"??APP_WIN32_PROC??","DeveloperMode":"true","AspNetCoreEnvironment":"Development","CustomPerfCounter":"true"}}}}
Application Insights Telemetry (unconfigured): {"name":"AppMetrics","time":"2021-11-17T12:46:18.9340612Z","tags":{"ai.application.ver":"1.0.0.0","ai.cloud.roleInstance":"62398bea5877","ai.internal.sdkVersion":"pccore:2.16.0-18277","ai.internal.nodeName":"62398bea5877.localdomain"},"data":{"baseType":"MetricData","baseData":{"ver":2,"metrics":[{"name":"\\Process(??APP_WIN32_PROC??)\\% Processor Time Normalized","kind":"Aggregation","value":0.1708317537090507,"count":1,"min":0.1708317537090507,"max":0.1708317537090507,"stdDev":0}],"properties":{"CounterInstanceName":"??APP_WIN32_PROC??","DeveloperMode":"true","AspNetCoreEnvironment":"Development","CustomPerfCounter":"true"}}}}
Application Insights Telemetry (unconfigured): {"name":"AppMetrics","time":"2021-11-17T12:46:18.9363986Z","tags":{"ai.application.ver":"1.0.0.0","ai.cloud.roleInstance":"62398bea5877","ai.internal.sdkVersion":"pccore:2.16.0-18277","ai.internal.nodeName":"62398bea5877.localdomain"},"data":{"baseType":"MetricData","baseData":{"ver":2,"metrics":[{"name":"\\Process(??APP_WIN32_PROC??)\\Private Bytes","kind":"Aggregation","value":328359936,"count":1,"min":328359936,"max":328359936,"stdDev":0}],"properties":{"CounterInstanceName":"??APP_WIN32_PROC??","DeveloperMode":"true","AspNetCoreEnvironment":"Development","CustomPerfCounter":"true"}}}}
The thread 0x85a has exited with code 0 (0x0).
The thread 0x865 has exited with code 0 (0x0).
The thread 0x869 has exited with code 0 (0x0).
The thread 0x7dd has exited with code 0 (0x0).
The thread 0x837 has exited with code 0 (0x0).
```

![[General notes - Ink.svg]]
