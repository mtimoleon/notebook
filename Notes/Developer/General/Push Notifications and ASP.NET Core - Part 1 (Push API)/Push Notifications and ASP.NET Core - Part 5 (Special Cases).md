---
title: "Push Notifications and ASP.NET Core - Part 5 (Special Cases)"
source: "https://www.tpeczek.com/2019/02/push-notifications-and-aspnet-core-part.html"
author:
  - "[[Tomasz Pęczek]]"
published: 2019-02-21
created: 2026-02-09
description: "This post is part of Push Notifications and ASP.NET Core series. In this post we take a look at some special cases which should be handled for correct usage of push notifications."
tags:
  - "clippings"
---
February 21, 2019 asp.net core, push notifications, web push [3 comments](https://www.tpeczek.com/2019/02/push-notifications-and-aspnet-core-part.html#disqus_thread)

It's been a while since I've written my last post in *Push Notifications and ASP.NET Core* series. Since that time I've received a number of questions about more uncommon aspects of Push Notifications, so I've decided I need to write another one.

- [Part 1 (Push API)](https://www.tpeczek.com/2017/12/push-notifications-and-aspnet-core-part.html)
- [Part 2 (Requesting Delivery)](https://www.tpeczek.com/2018/01/push-notifications-and-aspnet-core-part.html)
- [Part 3 (Replacing Messages & Urgency)](https://www.tpeczek.com/2018/01/push-notifications-and-aspnet-core-part_18.html)
- [Part 4 (Queueing requesting delivery in background)](https://www.tpeczek.com/2018/03/push-notifications-and-aspnet-core-part.html)
- Part 5 (Special Cases)

In this post, I'm going to focus on special cases which a production-ready application using push notifications should be able to handle.

## Handling Out-Of-Control Subscription Changes on the Client Side

There are several things which can happen to a push subscription outside of the application's control. For example, it can be refreshed, lost, expired or permissions can be revoked. When something like this happens, the browser should fire a `pushsubscriptionchange` event on service worker registration, to inform it about the change. Service worker should use information provided by this event to update the server.

The `pushsubscriptionchange` event is often misused. This is because its definition has changed. In the beginning, the event was defined to fire when a subscription has expired. Because of that, many sample implementations available on the web are limited to resubscribe attempt. Currently, this is not the correct approach. The event has two properties: `newSubscription` and `oldSubscription`. Depending on those properties values, different actions should be taken.

```
self.addEventListener('pushsubscriptionchange', function (event) {
    const handlePushSubscriptionChangePromise = Promise.resolve();

    if (event.oldSubscription) { }

    if (event.newSubscription) { }

    if (!event.newSubscription) { }

    event.waitUntil(handlePushSubscriptionChangePromise);
});
```

The value of `oldSubscription` represents a push subscription that is no longer valid. The subscription should be removed from the server. This is not a bulletproof mechanism, the value may be `null` if the browser was not able to provide the full set of details.

```
self.addEventListener('pushsubscriptionchange', function (event) {
    const handlePushSubscriptionChangePromise = Promise.resolve();

    if (event.oldSubscription) {
        handlePushSubscriptionChangePromise = handlePushSubscriptionChangePromise.then(function () {
            return fetch('push-notifications-api/subscriptions?endpoint=' + encodeURIComponent(event.oldSubscriptio.endpoint), {
                method: 'DELETE'
            });
        });
    }

    ...
});
```

The value of `newSubscription` represents a new valid push subscription. If the value is there, it should be sent to the server. But, similar to `oldSubscription`, the value may be `null`. This means that the browser didn't establish a new subscription. At this point, the code can attempt to resubscribe after retrieving public *VAPID* key from the server (the key change is often why browser couldn't establish new subscription). The attempt may fail (for example the reason for triggering the event was user revoking the permissions). In such a case, there is nothing more that can be done.

```
self.addEventListener('pushsubscriptionchange', function (event) {
    const handlePushSubscriptionChangePromise = Promise.resolve();

    ...

    if (event.newSubscription) {
        handlePushSubscriptionChangePromise = handlePushSubscriptionChangePromise.then(function () {
            return fetch('push-notifications-api/subscriptions', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(pushSubscription)
            });
        });
    }

    if (!event.newSubscription) {
        handlePushSubscriptionChangePromise = handlePushSubscriptionChangePromise.then(function () {
            return fetch('push-notifications-api/public-key').then(function (response) {
                if (response.ok) {
                    return response.text().then(function (applicationServerPublicKeyBase64) {
                        return urlB64ToUint8Array(applicationServerPublicKeyBase64);
                    });
                } else {
                    return Promise.reject(response.status + ' ' + response.statusText);
                }
            }).then(function (applicationServerPublicKey) {
                return pushServiceWorkerRegistration.pushManager.subscribe({
                    userVisibleOnly: true,
                    applicationServerKey: applicationServerPublicKey
                }).then(function (pushSubscription) {
                    return fetch('push-notifications-api/subscriptions', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify(pushSubscription)
                    });
                });
            });
        });
    }

    event.waitUntil(handlePushSubscriptionChangePromise);
});
```

## Handling Out-Of-Control Subscription Changes on the Server Side

The `pushsubscriptionchange` event is not a silver bullet to all potential issues. Even if it's triggered, it may not provide the `oldSubscription`. In general, it may happen that application will send a notification to removed, expired or otherwise invalid subscription. If that happens, Push Service will respond with 410 or 404 status. The application must be prepared for such a response and discard the subscription. In case of [Lib.Net.Http.WebPush](https://github.com/tpeczek/Lib.Net.Http.WebPush) failed requests end up as `PushServiceClientException`. It's enough to catch this exception, check `StatusCode` property and act accordingly.

```
internal class PushServicePushNotificationService : IPushNotificationService
{
    ...

    public async Task SendNotificationAsync(PushSubscription subscription, PushMessage message, CancellationToken cancellationToken)
    {
        try
        {
            await _pushClient.RequestPushMessageDeliveryAsync(subscription, message, cancellationToken);
        }
        catch (Exception ex)
        {
            await HandlePushMessageDeliveryExceptionAsync(ex, subscription);
        }
    }

    private async Task HandlePushMessageDeliveryExceptionAsync(Exception exception, PushSubscription subscription)
    {
        PushServiceClientException pushServiceClientException = exception as PushServiceClientException;

        if (pushServiceClientException is null)
        {
            _logger?.LogError(exception, "Failed requesting push message delivery to {0}.", subscription.Endpoint);
        }
        else
        {
            if ((pushServiceClientException.StatusCode == HttpStatusCode.NotFound)
                || (pushServiceClientException.StatusCode == HttpStatusCode.Gone))
            {
                // Remove subcription from store
                ...

                _logger?.LogInformation("Subscription has expired or is no longer valid and has been removed.");
            }
        }
    }
}
```

The implementation may get a little bit complicated. Notifications are usually sent outside of request scope, from singleton services, and often with a fire-and-forget approach. If storage service is a scoped one (which is typical when Entity Framework is being used), this will enforce additional code to manage scope and storage service instance. This strongly depends on the particular project approach, but usually can be solved without too much trouble.

## Dealing with Rate Limiting

One more common problem when using push notifications is reaching a rate limit with a push service. When this happens push service responds with *429 Too Many Requests* which should include a `Retry-After` header. What application should do is wait given period of time and resend the notification. I believe this kind of functionality should be built into a client. This is why I've added it to [Lib.Net.Http.WebPush](https://github.com/tpeczek/Lib.Net.Http.WebPush). Lib.Net.Http.WebPush determines if an attempt to resend should be made based on status code and `Retry-After` header presence.

```
private bool ShouldRetryAfter(HttpResponseMessage pushMessageDeliveryRequestResponse, out TimeSpan delay)
{
    delay = TimeSpan.MinValue;

    if ((pushMessageDeliveryRequestResponse.StatusCode != (HttpStatusCode)429) || !AutoRetryAfter)
    {
        return false;
    }

    if ((pushMessageDeliveryRequestResponse.Headers.RetryAfter is null)
        || (!pushMessageDeliveryRequestResponse.Headers.RetryAfter.Date.HasValue && !pushMessageDeliveryRequestResponse.Headers.RetryAfter.Delta.HasValue))
    {
        return false;
    }

    if (pushMessageDeliveryRequestResponse.Headers.RetryAfter.Delta.HasValue)
    {
        delay = pushMessageDeliveryRequestResponse.Headers.RetryAfter.Delta.Value;
    }

    if (pushMessageDeliveryRequestResponse.Headers.RetryAfter.Date.HasValue)
    {
        delay = pushMessageDeliveryRequestResponse.Headers.RetryAfter.Date.Value.Subtract(DateTimeOffset.UtcNow);
    }

    return true;
}
```

The check is used to create an optional waiting loop while sending a notification.

```
public async Task RequestPushMessageDeliveryAsync(PushSubscription subscription, PushMessage message, VapidAuthentication authentication,
    VapidAuthenticationScheme authenticationScheme, CancellationToken cancellationToken)
{
    HttpRequestMessage pushMessageDeliveryRequest =
        PreparePushMessageDeliveryRequest(subscription, message, authentication, authenticationScheme);

    HttpResponseMessage pushMessageDeliveryRequestResponse =
        await _httpClient.SendAsync(pushMessageDeliveryRequest, HttpCompletionOption.ResponseHeadersRead, cancellationToken);

    while (ShouldRetryAfter(pushMessageDeliveryRequestResponse, out TimeSpan delay))
    {
        await Task.Delay(delay, cancellationToken);

        pushMessageDeliveryRequest =
            SetAuthentication(pushMessageDeliveryRequest, subscription, authentication ?? DefaultAuthentication, authenticationScheme);

        pushMessageDeliveryRequestResponse =
            await _httpClient.SendAsync(pushMessageDeliveryRequest, HttpCompletionOption.ResponseHeadersRead, cancellationToken);
    }

    HandlePushMessageDeliveryRequestResponse(pushMessageDeliveryRequest, pushMessageDeliveryRequestResponse, cancellationToken);
}
```

There is one small, important detail here. For every retry, the authentication is set again. This avoids a situation where *JWT* has expired while waiting for retry.

## Footnote

I've updated my demo project with all the above changes, you can grab it [here](https://github.com/tpeczek/Demo.AspNetCore.PushNotifications). I hope it will help you to use push notifications in your own applications.