using Microsoft.EntityFrameworkCore.Diagnostics;
using System;
using System.Data.Common;
using System.Threading;
using System.Threading.Tasks;

namespace TestsCommon.Helpers
{
	public class QueryCommandCounterInterceptor : DbCommandInterceptor
	{
		private readonly object _syncLock = new();
		private CounterScopeState _currentState;

		public QueryCommandCounterScope BeginScope()
		{
			lock (_syncLock)
			{
				var scope = new CounterScopeState(_currentState);
				_currentState = scope;
				return new QueryCommandCounterScope(this, scope);
			}
		}

		public void EndScope(CounterScopeState scopeState)
		{
			lock (_syncLock)
			{
				if (_currentState == scopeState)
				{
					_currentState = scopeState.Parent;
				}
			}
		}

		private void Count(CommandExecutedEventData eventData)
		{
			lock (_syncLock)
			{
				var currentState = _currentState;
				if (currentState == null)
				{
					return;
				}

				currentState.CommandCount++;
				currentState.TotalDuration += eventData.Duration;
			}
		}

		public override DbDataReader ReaderExecuted(DbCommand command, CommandExecutedEventData eventData, DbDataReader result)
		{
			Count(eventData);
			return base.ReaderExecuted(command, eventData, result);
		}

		public override object ScalarExecuted(DbCommand command, CommandExecutedEventData eventData, object result)
		{
			Count(eventData);
			return base.ScalarExecuted(command, eventData, result);
		}

		public override int NonQueryExecuted(DbCommand command, CommandExecutedEventData eventData, int result)
		{
			Count(eventData);
			return base.NonQueryExecuted(command, eventData, result);
		}

		public override ValueTask<DbDataReader> ReaderExecutedAsync(
			DbCommand command,
			CommandExecutedEventData eventData,
			DbDataReader result,
			CancellationToken cancellationToken = default)
		{
			Count(eventData);
			return base.ReaderExecutedAsync(command, eventData, result, cancellationToken);
		}

		public override ValueTask<object> ScalarExecutedAsync(
			DbCommand command,
			CommandExecutedEventData eventData,
			object result,
			CancellationToken cancellationToken = default)
		{
			Count(eventData);
			return base.ScalarExecutedAsync(command, eventData, result, cancellationToken);
		}

		public override ValueTask<int> NonQueryExecutedAsync(
			DbCommand command,
			CommandExecutedEventData eventData,
			int result,
			CancellationToken cancellationToken = default)
		{
			Count(eventData);
			return base.NonQueryExecutedAsync(command, eventData, result, cancellationToken);
		}

		public sealed class CounterScopeState
		{
			public CounterScopeState Parent { get; }
			public int CommandCount { get; set; }
			public TimeSpan TotalDuration { get; set; }

			public CounterScopeState(CounterScopeState parent)
			{
				Parent = parent;
			}
		}
	}

	public sealed class QueryCommandCounterScope : IDisposable
	{
		private readonly QueryCommandCounterInterceptor _interceptor;
		private readonly QueryCommandCounterInterceptor.CounterScopeState _scopeState;
		private bool _disposed;

		internal QueryCommandCounterScope(
			QueryCommandCounterInterceptor interceptor,
			QueryCommandCounterInterceptor.CounterScopeState scopeState)
		{
			_interceptor = interceptor;
			_scopeState = scopeState;
		}

		public int CommandCount => _scopeState.CommandCount;
		public TimeSpan TotalDuration => _scopeState.TotalDuration;

		public void Dispose()
		{
			if (_disposed)
			{
				return;
			}

			_disposed = true;
			_interceptor.EndScope(_scopeState);
		}
	}
}
