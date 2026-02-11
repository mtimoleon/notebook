---
title: "Push Notifications and ASP.NET Core - Part 3 (Replacing Messages & Urgency)"
source: "https://www.tpeczek.com/2018/01/push-notifications-and-aspnet-core-part_18.html"
author:
  - "[[Tomasz Pęczek]]"
published: 2018-01-18
created: 2026-02-09
description: "This post shows lesser known features of Web Push Protocol - Replacing Messages and Urgency."
tags:
  - "clippings"
---
January 18, 2018 asp.net core, http, push notifications, web push, web push protocol [4 comments](https://www.tpeczek.com/2018/01/push-notifications-and-aspnet-core-part_18.html#disqus_thread)

This is third post in my "Push Notifications and ASP.NET Core" series

- [Part 1 (Push API)](https://www.tpeczek.com/2017/12/push-notifications-and-aspnet-core-part.html)
- [Part 2 (Requesting Delivery)](https://www.tpeczek.com/2018/01/push-notifications-and-aspnet-core-part.html)
- Part 3 (Replacing Messages & Urgency)
- [Part 4 (Queueing requesting delivery in background)](https://www.tpeczek.com/2018/03/push-notifications-and-aspnet-core-part.html)
- [Part 5 (Special Cases)](https://www.tpeczek.com/2019/02/push-notifications-and-aspnet-core-part.html)

Since the last post I've have extracted the *push service* client to separate [project](https://github.com/tpeczek/Lib.Net.Http.WebPush) and added few more features to it (for example capability of *VAPID* tokens caching). In this post I wanted to show two of those features, which are not so well-known capabilities of *push messages*: replacing and urgency.

## Replacing Messages

There is a way to correlate push messages send to the same push service. In order to do this a *topic* property needs to be added to the push message.

```
public class PushMessage
{
    ...

    public string Topic { get; set; }

    ...
}
```

The topic should be a string with maximum length of 32 and should contain only characters from ["URL and Filename safe" Base 64 alphabet](https://tools.ietf.org/html/rfc4648#section-5). It can be delivered to the push service by using `Topic` request header.

```
public class PushServiceClient
{
    ...

    private const string TOPIC_HEADER_NAME = "Topic";

    ...

    private static HttpRequestMessage SetTopic(HttpRequestMessage pushMessageDeliveryRequest,
        PushMessage message)
    {
        if (!String.IsNullOrWhiteSpace(message.Topic))
        {
            pushMessageDeliveryRequest.Headers.Add(TOPIC_HEADER_NAME, message.Topic);
        }

        return pushMessageDeliveryRequest;
    }

    ...
}
```

When push service receives a message with topic, it goes through all not delivered messages for the related subscription and checks if there is one with identical topic. If such message exists, it will be replaced (which means replacing content and attributes like *Time-To-Live*). So, if a client has been offline it will receive only the latest version of the message (the client which has been online the whole time will receive all versions). This way delivering unnecessary (outdated) messages can be avoided.

## Urgency

Another message property which impacts how push service delivers messages is *urgency*.

```
public class PushMessage
{
    ...

    public PushMessageUrgency Urgency { get; set; }

    ...

    public PushMessage(string content)
    {
        ...
        Urgency = PushMessageUrgency.Normal;
    }
}
```

Urgency serves as a filter. A client can let the push service know what is the lowest urgency of the messages it wants to receive. The typical scenario here is limiting resources consumption. That's why the four currently defined levels have suggested relation to the power and network state of the device:

- *very-low* - On power and Wi-Fi
- *low* - On power or Wi-Fi
- *normal* - On neither power nor Wi-Fi
- *high* - Low battery

Like the topic, the urgency can be delivered by using dedicated request header. The name of the header is also easy to guess.

```
public class PushServiceClient
{
    ...

    private const string URGENCY_HEADER_NAME = "Urgency";

    ...

    private static readonly Dictionary<PushMessageUrgency, string> _urgencyHeaderValues =
    new Dictionary<PushMessageUrgency, string>
    {
        { PushMessageUrgency.VeryLow, "very-low" },
        { PushMessageUrgency.Low, "low" },
        { PushMessageUrgency.High, "high" }
    };

    ...

    private static HttpRequestMessage SetUrgency(HttpRequestMessage pushMessageDeliveryRequest,
        PushMessage message)
    {
        switch (message.Urgency)
        {
            case PushMessageUrgency.Normal:
                break;
            case PushMessageUrgency.VeryLow:
            case PushMessageUrgency.Low:
            case PushMessageUrgency.High:
                pushMessageDeliveryRequest.Headers.Add(URGENCY_HEADER_NAME,
                    _urgencyHeaderValues[message.Urgency]);
                break;
            default:
                throw new NotSupportedException(
                    $"Not supported value has been provided for {nameof(PushMessageUrgency)}."
                );
        }

        return pushMessageDeliveryRequest;
    }

    ...
}
```

A push message which delivery has been requested without `Urgency` header is considered to have urgency level of normal.

This is probably the last (at least for now) of my posts about push notifications. I've updated the demo [project](https://github.com/tpeczek/Demo.AspNetCore.PushNotifications) with support for features described here (and there is still couple things on the issues list to come in future).