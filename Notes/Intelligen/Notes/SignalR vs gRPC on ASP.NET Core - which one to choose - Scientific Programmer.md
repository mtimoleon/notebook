---
categories:
  - "[[Work]]"
created: 2021-10-10T17:03
tags:
  - intelligen
---

Clipped from: [https://scientificprogrammer.net/2020/07/18/signalr-vs-grpc-on-asp-net-core-which-one-to-choose/](https://scientificprogrammer.net/2020/07/18/signalr-vs-grpc-on-asp-net-core-which-one-to-choose/)

![t6RPC,](Exported%20image%2020260209140523-0.jpeg)

A while ago, when ASP.NET Core didnβ€™t even exist, Microsoft has created a library for .NET Framework-based ASP.NET that enabled a two-way communication between the clients and a server in real time. This library was called SignalR.  
The goal of this library was to significantly simplify the implementation of standard communication protocols that were normally used for this type of communication. These protocols included [WebSocket](https://developer.mozilla.org/en-US/docs/Web/API/WebSockets_API), [long polling](https://javascript.info/long-polling) and [server-sent events](https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events/Using_server-sent_events).  
Any of these protocols could be used directly, but none of them was very easy to use on its own. SingnalR made it easy by hiding away all complex implementation details.  
With the introduction of ASP.NET Core version 2.1, this library was completely re-written and became a [standard part](https://docs.microsoft.com/en-us/aspnet/core/signalr/introduction) of ASP.NET Core.  
[gRPC](https://grpc.io/about/) is a communication protocol that was originally developed by Google. Unlike SignalR, it doesnβ€™t leverage the usage of existing protocols. Itβ€™s a completely self-contained protocol that leverages new features of [HTTP/2](https://developers.google.com/web/fundamentals/performance/http2), which was made generally available in 2015.  
gRPC implementations are available in most of the major programming languages. And, since ASP.NET Core 3.0 has been released, it became an [integral part](https://docs.microsoft.com/en-us/aspnet/core/grpc/) of ASP.NET Core, just like SignalR did before it.  
Both of these technologies are extremely useful and they can be used for similar purposes. Whether one is better than the other depends purely on the context.  
Today, we will have a look at the pros and cons of each of these technologies in different contexts so you can be better equipped to decide which one to use.

## Where SignalR beats gRPC

I have previously outlined the key [benefits of using SignalR](https://scientificprogrammer.net/2019/08/18/why-you-absolutely-need-signalr-for-asp-net-development/) compared to writing equivalent functionality manually. These can be summarized as follows:

- All complexity is abstracted away
- No more need for AJAX
- Works with any types of client (even pure WebSocket ones)
- Can be scaled out very easily
- Used in various parts of ASP.NET out of the box (e.g. in [Blazor Server](https://scientificprogrammer.net/2019/08/18/pros-and-cons-of-blazor-for-web-development/))

The most fundamental benefit of using SignalR is how it abstracts away complex implementations of WebSocket, long polling and server-sent events. For example, while a pure WebSocket implementation may look like this:

![var try buffer new byte 4096 while true var result...](Exported%20image%2020260209140528-1.jpeg)

The SignalR equivalent will look like this:

![public async Task await Clients BroadcastMessagest...](Exported%20image%2020260209140529-2.jpeg)

However, this time, we are not comparing SignalR against writing your own implementations manually. We are comparing it specifically against gRPC. So, here are some of the advantages that SignalR has over gRPC:

_1. No need to use HTTP/2 (i.e. it works virtually anywhere)_

Without HTTP/2, you cannot have gRPC. This means that not all systems can use it. If either the client or the server application you are working on is hosted on a system that doesnβ€™t have HTTP/2 support, there is nothing you can do to make it work.  
SignalR, on the other hand, works with basic HTTP. This is why it can be used on almost any system.  
Of course, not all systems can use WebSocket protocol. So you may not be able to use SignalR in the most efficient way in some setups. But this is precisely why it has two fallback protocols β€“ server-sent events and long polling.  
And the fact that SignalR is not using HTTP/2 doesnβ€™t mean that it is less performant than gRPC. Yes, HTTP/2 provides many performance benefits, such as compressed headers, which increase the performance. And the messaging mechanism used by gRPC, [protocol buffer](https://developers.google.com/protocol-buffers), serializes messages in an efficient way, making the payload as small as possible, which increases the performance even further.  
However, SignalR, when used with WebSocket, is comparable in itβ€™s efficiency. First of all, it only uses HTTP header to establish the initial connection, so the header compression provided by HTTP/2 is almost irrelevant. Secondly, it can be configured to use a proprietary binary JSON protocol called [MessagePack](https://docs.microsoft.com/en-us/aspnet/core/signalr/messagepackhubprotocol), which, just like protocol buffer, substantially reduces the payload size and therefore improves the performance.  
==Performance-wise, SignalR and gRPC are comparable.== And both of them beat the standard HTTP-based communication hands down.

_2. Events can be initiated by either a client or the server_

One limitation of ==gRPC== is that itβ€™s still largely similar to a standard request-response model employed by HTTP. ==Only the client can initiate events==. The server can only respond to those.  
There is a work-around. gRPC can use [server streaming](https://docs.microsoft.com/en-us/aspnet/core/grpc/client), where the client sends the initial request and then both the client and the server keep the stream open, so the server can put messages into it when specific action is triggered.  
But the implementation of this would have to be fairly clumsy. Streaming calls are not designed to be used like this. You would need to add loops to both the client and the server and you will need to manage the connection status manually. Plus you would need to do it for every individual method that needs to communicate both ways.  
==With SignalR, on the other hand, all you have to do from the client is send the initial connection request==. After this, both the client and the server can send messages to each other by using any of each otherβ€™s endpoints. All you have to do is add methods on the server side and add named event listeners on the client side. The connection can remain open indefinitely. SignalR library itself will manage the connection status for you by sending heartbeats at regular intervals and by attempting to reconnect automatically if the connection is broken.  
And, just like gRPC, SignalR is fully capable of [streaming real time data](https://docs.microsoft.com/en-us/aspnet/core/signalr/streaming) both to and from the server.

_3. No need to write any communication contracts and generate code from them_

To enable gRPC communication, you will need to write a [proto file](https://developers.google.com/protocol-buffers/docs/overview) that would contain definitions of the gRPC services and all the remote procedures on these services that clients will be able to call. Once this is done, you will need to run a language-specific tool to generate code that would correspond with these definitions. And only then you can start writing the actual logic.  
With SignalR, you donβ€™t have to do any of this. All you need to do is write any arbitrary method definitions in your server-side app and write named message handlers on your client.  
Of course, this doesnβ€™t come without its own potential issues. For example, you need to be extra careful that the method names are spelled the same on both the client and the server. But nevertheless, not having to write an explicitly defined contract and not having to rely on various tools to generate a code based on this contract substantially speeds up the development process.

## Where gRPC beats SignalR

Even though SignalR has its advantages over gRPC, the latter would be a better solution in certain situations. Here is the areas where gRPC has an edge over SignalR.

_1. Much easier API versioning_

Even though, when you are using gRPC, you have to write an explicit contract between the client and the server, itβ€™s not always a disadvantage. For example, the way proto format has been designed allows you to easily apply API versioning.  
When defining a structure of messages in a proto file, you will be required to give each of your fields a unique integer number. This would look like this:

![DemoRequest message int32 request_id 1 payload_col...](Exported%20image%2020260209140530-3.png)

And this mechanism is what makes API versioning easy. Letβ€™s imagine a scenario which will help us to see why is it so.  
In the first version of your gRPC service, you have a message definition that contains two fields as per the above screenshot β€“ request_id and payload_collection. These fields have been assigned numbers 1 and 2 respectively. Now, for our second version, we have decided to add a new field, timestamp, and assign number 3 to it.  
As long as we havenβ€™t modified any of the fields with the existing numbers, the clients that havenβ€™t received this update will still work with the new message definition. If this is a definition of a response object that server sends back to the client, the client will simply ignore the new field, as a field with number 3 is not outlined in its own proto definition. If this was a request object, then the client would populate the first two fields and the field with number 3 would be given a default value on the server-side.  
In either case, both the client and the server will still work. ==The key is not to modify the fields with the existing numbers. Otherwise things may break.==  
SignalR doesnβ€™t have any of this. Of course, there is nothing that stops you from implementing your own API versioning mechanism that is similar to this. But with gRPC, you already have such a mechanism in place, so you wonβ€™t have to re-invent the wheel.

_2. Libraries available in pretty much any language_

Even though SignalR is open source, it is still Microsoftβ€™s proprietary technology. And this is why SignalR server can only be written in Microsoftβ€™s own back-end languages (primarily C#, although [using F# is also supported](https://www.codesuji.com/2019/02/19/Building-Game-with-SignalR-and-F/)).  
SignalR clients can also be written only in a limited number of languages. At the time of writing, only .NET, JavaScript and Java [clients](https://docs.microsoft.com/en-us/aspnet/core/signalr/client-features) were supported. Of course, you can write your own client in any language by using pure WebSocket, but you will loose all the benefits of using SignalR if youβ€™ll choose to do it this way.  
gRPC, on the other hand, is an open standard. And this is why it is available on [many popular languages](https://grpc.io/docs/languages/). This applies to both the client and the server.

_3. Easier to apply in microservice architecture_

Another area where gRPC beats SignalR hands-down is communication between [microservices](https://microservices.io/) and [containers](https://www.docker.com/resources/what-container).  
More and more organizations are getting rid of large monolithic apps by splitting them up into smaller components that can be executed and updated individually. However, these components still form a large distributed application. And this is why there needs to be an efficient mechanism in place for them to communicate with each other.  
Various forms of remote procedure call (RPC) mechanisms were traditionally used for this purpose. They tend to be more efficient than HTTP, as they donβ€™t have as much data in the headers. Also, they donβ€™t have to adhere to outdated common standards and can be completely proprietary. [Azure Service Fabric Remoting](https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-reliable-services-communication-remoting) mechanism is an example of this.  
gRPC eliminated the need to use proprietary RPC mechanisms for different types of technologies. Itβ€™s an open standard, so any system can use it. And itβ€™s highly efficient, because itβ€™s running on top of HTTP/2.  
SignalR, on the other hand, wouldnβ€™t be efficient enough to get microservices to communicate with each other. Even though it allows you to write code that looks like the client and the server are calling each otherβ€™s methods remotely, this is not what happens under the hood. Instead, a persistent connection is established between the client and the server. And the connection is maintained by sending small heartbeat messages both ways.  
==If you have a distributed application with a large number of moving parts, imagine how much bandwidth would be used if all individual components opened a number of persistent connections to communicate with each other. With gRPC, on the other hand, any data is exchanged only when such exchange is needed.== The only time you would need any long-lasting connection is when you use streams. But even then you would close the stream once you transfer all the data through.

## Conclusion

Both SignalR and gRPC are great communication mechanisms that every Microsoft-stack software developer should learn. And neither is better than the other. There are just specific scenarios that favor the usage of a particular one.  
For example, if you need to build something where the server regularly communicates with the client, SignalR would be better. If, on the other hand, you are building a large distributed application with many moving parts, gRPC would be a better mechanism for those parts to communicate with one another.




