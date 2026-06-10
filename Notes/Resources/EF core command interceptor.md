---
categories:
  - "[[Resources]]"
created: 2026-06-02
url:
tags:
  - topic/code
  - topic/databases
  - documentation
  - tech/measuring
  - topic/ef
---

## Notes

Code to measure database commands and execution time using ef interceptor.

1. Add the interceptor code:
![[EF core command interceptor-20260602.cs]]

2. In tests setup, add database interceptor:
   ```
    services.AddSingleton<QueryCommandCounterInterceptor>();
​
	var configuration = services.BuildServiceProvider()
		.GetRequiredService<IConfiguration>();
​
	services.AddDbContext<PlanningDbContext>((serviceProvider, options) =>
	{
		options.AddInterceptors(serviceProvider.GetRequiredService<QueryCommandCounterInterceptor>());
		options.UseSqlServer(
			configuration["TestsConnectionString"],
			sqlServerOptions => sqlServerOptions.UseQuerySplittingBehavior(QuerySplittingBehavior.SplitQuery)
		);
		options.EnableSensitiveDataLogging();
		options.LogTo(message => Debug.WriteLine(message), LogLevel.Information);
	});
​
   ```

3. Then in tests you can do something like:
   ```
	var seedData = await SeedBenchmarkOperationEntryAsync();
	var storedOperationEntry = await LoadStoredOperationEntryAsync(seedData.OperationEntryId);
	var commandCounter = _sutFixture.PlanningApiFactory.Services.GetRequiredService<QueryCommandCounterInterceptor>();
	var requestUrl = $"planning/{seedData.WorkspaceId}/operation-entry/panel/{seedData.OperationEntryId}?queryType={queryType}";
	​
	var measuredResults = new List<BenchmarkMeasurement>();
	​
	for (int iteration = 0; iteration < MeasuredRuns; iteration++)
	{
		using var commandScope = commandCounter.BeginScope();
		var stopwatch = Stopwatch.StartNew();
	​
		var response = await _httpClient.GetAsync(requestUrl);
		var contentString = await response.Content.ReadAsStringAsync();
		stopwatch.Stop();
	​
		var result = JsonConvert.DeserializeObject<QueryStatus<OperationEntryPanelDto>>(contentString);
		
		Assertions ...​
			​
		var measurement = new BenchmarkMeasurement(
			commandScope.CommandCount,
			commandScope.TotalDuration,
			stopwatch.Elapsed);
		measuredResults.Add(measurement);
	​
		_output.WriteLine($"Run {iteration}: DB {measurement.DbDuration.TotalMilliseconds:0} ms | App {measurement.AppDuration.TotalMilliseconds:0} ms | Cmds {measurement.CommandCount}");
   ```

