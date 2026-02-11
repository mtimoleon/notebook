---
title: "Push Notifications and ASP.NET Core - Part 4 (Queueing requesting delivery in background)"
source: "https://www.tpeczek.com/2018/03/push-notifications-and-aspnet-core-part.html"
author:
  - "[[Tomasz Pęczek]]"
published: 2018-03-22
created: 2026-02-09
description: "This post shows how to queue background tasks (specifically push notifications delivery requests) with help of IHostedService in ASP.NET Core."
tags:
  - "clippings"
---
March 22, 2018 asp.net core, background processing, push notifications [6 comments](https://www.tpeczek.com/2018/03/push-notifications-and-aspnet-core-part.html#disqus_thread)

I have a [demo project](https://github.com/tpeczek/Demo.AspNetCore.PushNotifications) on GitHub which accompanies my blog series about [Web Push](https://tools.ietf.org/html/rfc8030) based push notifications in ASP.NET Core:

- [Part 1 (Push API)](https://www.tpeczek.com/2017/12/push-notifications-and-aspnet-core-part.html)
- [Part 2 (Requesting Delivery)](https://www.tpeczek.com/2018/01/push-notifications-and-aspnet-core-part.html)
- [Part 3 (Replacing Messages & Urgency)](https://www.tpeczek.com/2018/01/push-notifications-and-aspnet-core-part_18.html)
- Part 4 (Queueing requesting delivery in background)
- [Part 5 (Special Cases)](https://www.tpeczek.com/2019/02/push-notifications-and-aspnet-core-part.html)

There is one thing in that project which I wanted to "fix" for some time. That thing is requesting delivery of notifications, which is being done inside an action.

```
public class PushNotificationsApiController : Controller
{
    ...

    [HttpPost("notifications")]
    public async Task<IActionResult> SendNotification([FromBody]PushMessageViewModel message)
    {
        PushMessage pushMessage = new PushMessage(message.Notification)
        {
            Topic = message.Topic,
            Urgency = message.Urgency
        };

        await _subscriptionStore.ForEachSubscriptionAsync((PushSubscription subscription) =>
        {
            _notificationService.SendNotificationAsync(subscription, pushMessage);
        });

        return NoContent();
    }
}
```

If you have read [post](https://www.tpeczek.com/2018/01/push-notifications-and-aspnet-core-part.html) about requesting delivery you know it's an expensive operation. Taking into consideration possible high number of subscription this is something which shouldn't be done in context of request. It would be much better to queue it in the background, independent of any request. Back in ASP.NET days this could be done with [`QueueBackgroundWorkItem`](https://docs.microsoft.com/en-us/dotnet/api/system.web.hosting.hostingenvironment.queuebackgroundworkitem) method, but it's not available in ASP.NET Core (at least not [yet](https://github.com/aspnet/Hosting/issues/1280)). However, there is a prototype implementation based on [`IHostedService`](https://docs.microsoft.com/en-us/dotnet/api/microsoft.extensions.hosting.ihostedservice) which can be used as it is or adjusted to specific case. I've decided to go the second path. First step on that path is the queue itself.

## Creating the queue

The queue interface should be simple. Only two operations are needed: enqueue and dequeue. The dequeue should be returning `Task` so the dequeuer can wait for new items. It also should accept a `CancellationToken` so the dequeuer can be stopped while it's waiting on dequeue.

```
internal interface IPushNotificationsQueue
{
    void Enqueue(PushMessage message);

    Task<PushMessage> DequeueAsync(CancellationToken cancellationToken);
}
```

The implementation is based on `ConcurrentQueue` and `SemaphoreSlim`. That `SemaphoreSlim` is where the magic happens. The `DequeueAsync` should be waiting on that semaphore. When a new message is enqueued the semaphore should be released, which allow the `DequeueAsync` to continue. If the semaphore will be raised more than once, the next call to `DequeueAsync` will not wait, just decrement the internal count of the semaphore until it's back at 0 again.

```
internal class PushNotificationsQueue : IPushNotificationsQueue
{
    private readonly ConcurrentQueue<PushMessage> _messages = new ConcurrentQueue<PushMessage>();
    private readonly SemaphoreSlim _messageEnqueuedSignal = new SemaphoreSlim(0);

    public void Enqueue(PushMessage message)
    {
        if (message == null)
        {
            throw new ArgumentNullException(nameof(message));
        }

        _messages.Enqueue(message);

        _messageEnqueuedSignal.Release();
    }

    public async Task<PushMessage> DequeueAsync(CancellationToken cancellationToken)
    {
        await _messageEnqueuedSignal.WaitAsync(cancellationToken);

        _messages.TryDequeue(out PushMessage message);

        return message;
    }
}
```

Having the queue, next step is implementing the dequeuer.

## Implementing the dequeuer

The dequeuer is an implementation of `IHostedService`. In general it should be waiting on `DequeueAsync` and perform the same logic as the action does. But there are two important differences from the code in action here. A services scope needs to be created. The reason is `IPushSubscriptionStore`. By itself it's transient, so it wouldn't cause any issues, but its *Sqlite* implementation depends on `DbContext` which is scoped. Furthermore, the whole processing must support cancellation in order for the host to be able to shutdown graceful.

```
internal class PushNotificationsDequeuer : IHostedService
{
    private readonly IServiceProvider _serviceProvider;
    private readonly IPushNotificationsQueue _messagesQueue;
    private readonly IPushNotificationService _notificationService;
    private readonly CancellationTokenSource _stopTokenSource = new CancellationTokenSource();

    private Task _dequeueMessagesTask;

    public PushNotificationsDequeuer(IServiceProvider serviceProvider,
        IPushNotificationsQueue messagesQueue, IPushNotificationService notificationService)
    {
        _serviceProvider = serviceProvider;
        _messagesQueue = messagesQueue;
        _notificationService = notificationService;
    }

    public Task StartAsync(CancellationToken cancellationToken)
    {
        _dequeueMessagesTask = Task.Run(DequeueMessagesAsync);

        return Task.CompletedTask;
    }

    public Task StopAsync(CancellationToken cancellationToken)
    {
        _stopTokenSource.Cancel();

        return Task.WhenAny(_dequeueMessagesTask, Task.Delay(Timeout.Infinite, cancellationToken));
    }

    private async Task DequeueMessagesAsync()
    {
        while (!_stopTokenSource.IsCancellationRequested)
        {
            PushMessage message = await _messagesQueue.DequeueAsync(_stopTokenSource.Token);

            if (!_stopTokenSource.IsCancellationRequested)
            {
                using (IServiceScope serviceScope = _serviceProvider.CreateScope())
                {
                    IPushSubscriptionStore subscriptionStore =
                        serviceScope.ServiceProvider.GetRequiredService<IPushSubscriptionStore>();

                    await subscriptionStore.ForEachSubscriptionAsync(
                        (PushSubscription subscription) =>
                        {
                            _notificationService.SendNotificationAsync(subscription, message,
                                _stopTokenSource.Token);
                        },
                        _stopTokenSource.Token
                    );
                }

            }
        }

    }
}
```

Now the queue and dequeuer just need to be registered (both as singletons).

```
public static class ServiceCollectionExtensions
{
    ...

    public static IServiceCollection AddPushNotificationsQueue(this IServiceCollection services)
    {
        services.AddSingleton<IPushNotificationsQueue, PushNotificationsQueue>();
        services.AddSingleton<IHostedService, PushNotificationsDequeuer>();

        return services;
    }
}
```

## Queueing requesting delivery

With queue and dequeuer available the action can be changed to pass the message to the background.

```
public class PushNotificationsApiController : Controller
{
    ...

    [HttpPost("notifications")]
    public IActionResult SendNotification([FromBody]PushMessageViewModel message)
    {
        _pushNotificationsQueue.Enqueue(new PushMessage(message.Notification)
        {
            Topic = message.Topic,
            Urgency = message.Urgency
        });

        return NoContent();
    }
}
```

It is important to note, that the dequeuer is sequential. If one would want to parallelize there are two ways. One way is to use the dequeuer implementation as a base and register multiple delivered dequeuers. The other way is to introduce parallelization inside the dequeuer. In this approach a single instance would manage multiple reading threads. It's also easy to achieve, just a proper synchronization inside `StopAsync` method is needed. I prefer the second approach as the first is rather ugly.