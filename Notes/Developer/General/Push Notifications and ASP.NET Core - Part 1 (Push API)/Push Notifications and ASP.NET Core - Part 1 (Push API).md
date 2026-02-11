---
title: "Push Notifications and ASP.NET Core - Part 1 (Push API)"
source: "https://www.tpeczek.com/2017/12/push-notifications-and-aspnet-core-part.html"
author:
  - "[[Tomasz Pęczek]]"
published: 2017-12-28
created: 2026-02-09
description: "Push API and Web Push Protocol specifications allow for delivering push notifications even when client is offline. This post shows how this capabilities can be used in ASP.NET Core."
tags:
  - "clippings"
---

December 28, 2017 asp.net core, http, push api, push notifications, web push [28 comments](https://www.tpeczek.com/2017/12/push-notifications-and-aspnet-core-part.html#disqus_thread)

Probably all of you have encountered *Push Notifications*. A lot of portals are bombarding us with requests to allow notifications as soon as we visit them. Despite this abuse, when used in responsible way, Push Notifications can be very useful. They key advantage is that web application doesn't have to check if the user is online or not, it can simply request delivery of *push message* and user will receive it as soon as possible. Of course this capability is not for free and I will try to show where the cost is hiding.

In this post I'm going to show how Push Notifications can be used from ASP.NET Core web application, although most of the information (and the client side code) are cross-platform. This post focuses on [Push API](http://www.w3.org/TR/push-api/) and general flow, there will be follow up posts which will take a deep dive into sending push message from .NET based backend:

- [Part 2 (Requesting Delivery)](https://www.tpeczek.com/2018/01/push-notifications-and-aspnet-core-part.html)
- [Part 3 (Replacing Messages & Urgency)](https://www.tpeczek.com/2018/01/push-notifications-and-aspnet-core-part_18.html)
- [Part 4 (Queueing requesting delivery in background)](https://www.tpeczek.com/2018/03/push-notifications-and-aspnet-core-part.html)
- [Part 5 (Special Cases)](https://www.tpeczek.com/2019/02/push-notifications-and-aspnet-core-part.html)

If you would like to see how it works before reading (or to look at final code while reading) the demo application is available [here](https://github.com/tpeczek/Demo.AspNetCore.PushNotifications).

## Prerequisites

It's important to understand that there is a third party in *web push protocol* flow: *push service*. Push service acts as intermediary which ensures reliable and efficient delivery of push messages to the client.

![Web Push Protocol Flow](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgEuzjuTVPKtsiaa9SXnPIEthVBxIB3D3IN9gyNYI4KqARBIDHSgJMSURl_GrW9BEojjjZLpI5z4LzaXJHHyCfCPklwh8SIWzKqklkVnn5JPNYhyqol8I2ZJU2YbSfPRdk-jCFb9lBGtYs/s1600/Web+Push+Protocol+Flow.png)

The presence of push service rises security and privacy concerns. One of such concerns is authentication. Each subscription to push service has its own unique URL which is a *[capability URL](http://www.w3.org/TR/capability-urls/)*. This means that if such URL would leak, other parties would be able to send a push message to related subscription. This is why an additional mechanism has been introduced to limit the potential senders. This mechanism is *Voluntary Application Server Identification (VAPID)*, details of which I'm going to describe in second post. What is important now is that VAPID requires *Application Server Keys* (public and private key pair). The easiest way to generate those keys is to use an [online generator](https://web-push-libs.github.io/vapid/js/). The public key has to be delivered to the client. In this post I will put it directly into snippets but in real life I would suggest delivering it on demand (the demo application is doing exactly that), preferably over HTTPS.

## Service Worker

The client side components of Push API specification rely on *Service Worker* [specification](http://www.w3.org/TR/service-workers-1/). More precisely they extend `ServiceWorkerRegistration` interface with `pushManager` attribute, which exposes `PushManager` interface. Service workers are beyond the scope of this post, so I will just quickly show how to register one.

```
let pushServiceWorkerRegistration;

function registerPushServiceWorker() {
    navigator.serviceWorker.register('/scripts/service-workers/push-service-worker.js',
        { scope: '/scripts/service-workers/push-service-worker/' })
        .then(function (serviceWorkerRegistration) {
            pushServiceWorkerRegistration = serviceWorkerRegistration;

            ...

            console.log('Push Service Worker has been registered successfully');
        }).catch(function (error) {
            console.log('Push Service Worker registration has failed: ' + error);
        });
};
```

The first parameter of the `register` method is the path to the script which will be registered as service worker. The `register` method returns a promise, when it resolves successfully the created `ServiceWorkerRegistration` should be stored for later usage.

## Subscribing

Before showing how to subscribe let me make one remark about when to subscribe. Please avoid attempting to subscribe on load, instead of that give your users a nicely visible button or something else which they can use to subscribe when they wish too.

In order to subscribe for push messages the `subscribe` method of `PushManager` interface should be called. The push messages receiver will be the service worker to which the `PushManager` interface belongs. Two things should be passed to the `subscribe` method. One is previously mentioned application server public key. The second is `userVisibility` flag with `true` value. The `userVisibility` flag indicates that a notification will be shown every time a push message arrives. If the subscription is created (the user has provided permission for notifications and the push service has responded correctly) it should be distributed to the application server as depicted in diagram above.

```
function subscribeForPushNotifications() {
    let applicationServerPublicKey = urlB64ToUint8Array('<Public Key in Base64 Format>');

    pushServiceWorkerRegistration.pushManager.subscribe({
        userVisibleOnly: true,
        applicationServerKey: applicationServerPublicKey
    }).then(function (pushSubscription) {
        fetch('push-notifications-api/subscriptions', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(pushSubscription)
        }).then(function (response) {
            if (response.ok) {
                console.log('Successfully subscribed for Push Notifications');
            } else {
                console.log('Failed to store the Push Notifications subscription on server');
            }
        }).catch(function (error) {
            console.log('Failed to store the Push Notifications subscription on server: ' + error);
        });

        ...
    }).catch(function (error) {
        if (Notification.permission === 'denied') {
            ...
        } else {
            console.log('Failed to subscribe for Push Notifications: ' + error);
        }
    });
};
```

The request for distributing the subscription is a standard *AJAX* request. This gives a chance to provide any additional information to the application server (cookies identifying the user, additional attributes in payload etc.). If it comes to the subscription itself, there are two key attributes which must be stored. First is the `endpoint` attribute (it contains previously mentioned capability URL) and second is `keys`. On server side it can be represented with simple class.

```
public class PushSubscription
{
    public string Endpoint { get; set; }

    public IDictionary<string, string> Keys { get; set; }
}
```

The `Keys` property is a dictionary which is used to share any required push message encryption keys. This is how the privacy of push messages is achieved. It's the client (browser) who generates those key, the push service doesn't know about them. Currently there are two keys defined: `p256dh` which is the *P-256 ECDH Diffie-Hellman* public key and `auth` which is the *authentication secret*. Details of push message encryption (like VAPID) will be described in next post.

Before implementing an action for handling subscription distribution request there is a service needed which will take care of storing the subscriptions. At this point this service can have a very simple interface.

```
public interface IPushSubscriptionStore
{
    Task StoreSubscriptionAsync(PushSubscription subscription);
}
```

This service can have many different implementations. The one in demo project is using SQLite, but NoSQL databases sound like a good candidates for storing this kind of data. With service in place the action implementation is quite simple.

```
namespace Demo.AspNetCore.PushNotifications.Controllers
{
    private readonly IPushSubscriptionStore _subscriptionStore;

    public PushNotificationsApiController(IPushSubscriptionStore subscriptionStore)
    {
        _subscriptionStore = subscriptionStore;
    }

    // POST push-notifications-api/subscriptions
    [HttpPost("subscriptions")]
    public async Task<IActionResult> StoreSubscription([FromBody]PushSubscription subscription)
    {
        await _subscriptionStore.StoreSubscriptionAsync(subscription);

        return NoContent();
    }
}
```

At this point the cost of push messages becomes visible. First part is storage (all active subscriptions must be stored, and queried as frequently as messages are being send) and second part is computation needed to request the delivery of push message.

## Requesting delivery

We already know all the building blocks needed to request push message delivery. Every subscription contains unique information which are needed for creating the request, so they all need to be iterated. I decided to make the `IPushSubscriptionStore` responsible for the iteration, which should make it easier for memory efficient implementation.

```
public interface IPushSubscriptionStore
{
    ...

    Task ForEachSubscriptionAsync(Action<PushSubscription> action);
}
```

There should be also an abstraction for requesting the delivery.

```
public class PushNotificationServiceOptions
{
    public string Subject { get; set; }

    public string PublicKey { get; set; }

    public string PrivateKey { get; set; }
}

public interface IPushNotificationService
{
    void SendNotification(PushSubscription subscription, string payload);
}
```

With such API sending push message can be represented as a single call.

```
await _subscriptionStore.ForEachSubscriptionAsync(
    (PushSubscription subscription) => _notificationService.SendNotification(subscription, "<Push Message>")
);
```

All the complexity is hiding inside `IPushNotificationService` implementation. This is also where the computation cost of push messages is. The application must generate the values for VAPID headers based on the options provided and encrypt the message payload based on the keys provided in subscription. The VAPID headers generation can be done once, but message payload has to be encrypted separately for every subscription. That's a lot of cryptography to do.

The push service client implementation is the exact subject of the next post, but this post goal is to have fully working flow so without going into details a library will be used.

```
internal class WebPushPushNotificationService : IPushNotificationService
{
    private readonly PushNotificationServiceOptions _options;
    private readonly WebPushClient _pushClient;

    public string PublicKey { get { return _options.PublicKey; } }

    public WebPushPushNotificationService(IOptions<PushNotificationServiceOptions> optionsAccessor)
    {
        _options = optionsAccessor.Value;

        _pushClient = new WebPushClient();
        _pushClient.SetVapidDetails(_options.Subject, _options.PublicKey, _options.PrivateKey);
    }

    public void SendNotification(Abstractions.PushSubscription subscription, string payload)
    {
        var webPushSubscription = WebPush.PushSubscription(
            subscription.Endpoint,
            subscription.Keys["p256dh"],
            subscription.Keys["auth"]);

        _pushClient.SendNotification(webPushSubscription, payload);
    }
}
```

## Receiving

The push message will be delivered directly to the service worker which has been used for registration and will trigger a `push` event. The payload can be extracted from the event argument and used to display notification.

```
self.addEventListener('push', function (event) {
    event.waitUntil(self.registration.showNotification('Demo.AspNetCore.PushNotifications', {
        body: event.data.text(),
        icon: '/images/push-notification-icon.png'
    }));
});
```

The `showNotification` method has a number of options which impact how the notification will look, you can read about them [here](https://developer.mozilla.org/en-US/docs/Web/API/ServiceWorkerRegistration/showNotification).

## Unsubscribing

There is one last thing remaining. To be a good web world citizen the application should provide a way for user to unsubscribe from notifications. The process is similar to subscribing. First we should unsubscribe from push service and then discard the subscription on the server side.

```
function unsubscribeFromPushNotifications() {
    pushServiceWorkerRegistration.pushManager.getSubscription().then(function (pushSubscription) {
        if (pushSubscription) {
            pushSubscription.unsubscribe().then(function () {
                fetch('push-notifications-api/subscriptions?endpoint='
                    + encodeURIComponent(pushSubscription.endpoint),
                    { method: 'DELETE' }
                ).then(function (response) {
                    if (response.ok) {
                        console.log('Successfully unsubscribed from Push Notifications');
                    } else {
                        console.log('Failed to discard the Push Notifications subscription from server');
                    }
                }).catch(function (error) {
                   console.log('Failed to discard the Push Notifications subscription from server: ' + error);
                });

                ...
            }).catch(function (error) {
                console.log('Failed to unsubscribe from Push Notifications: ' + error);
            });
        }
    });
};
```

To support the discarding of subscription the `IPushSubscriptionStore` needs to be extended. The endpoint is unique for every subscription so it's can be used as primary key.

```
public interface IPushSubscriptionStore
{
    ...

    Task DiscardSubscriptionAsync(string endpoint);
}
```

All that remains is action which will handle the delete request.

```
namespace Demo.AspNetCore.PushNotifications.Controllers
{
    ...

    // DELETE push-notifications-api/subscriptions?endpoint={endpoint}
    [HttpDelete("subscriptions")]
    public async Task<IActionResult> DiscardSubscription(string endpoint)
    {
        await _subscriptionStore.DiscardSubscriptionAsync(endpoint);

        return NoContent();
    }
}
```

This is enough to create a nicely behaving web application which uses Push Notifications. As already mentioned the demo application can be found [here](https://github.com/tpeczek/Demo.AspNetCore.PushNotifications).