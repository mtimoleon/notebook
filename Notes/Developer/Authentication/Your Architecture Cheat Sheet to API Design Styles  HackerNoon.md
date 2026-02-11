Clipped from: [https://hackernoon.com/your-architecture-cheat-sheet-to-api-design-styles?source=rss](https://hackernoon.com/your-architecture-cheat-sheet-to-api-design-styles?source=rss)

## Too Long; Didn't Read

REST is a set of architectural principles that describe how to properly build communication between a client and a server. Roy Fielding created the REST architectural style in 2000. The REST approach is very flexible and can be used in almost any system. Different API design approaches may support the same protocol under the hood.  
How to find the best approach to build a truly convenient and reliable API? There are many factors to consider, such as performance, readability, versioning, security, usability, supportability, complexity, and more. Engineers often struggle at the beginning with deciding exactly what they need to choose and how to properly build the API. It is always a matter of choice.
 
I do not intend to provide a comprehensive description of each API design approach. My goal is to summarize the most essential aspects each approach has to offer and relate them to appropriate business cases. An important note, if I don’t say something in pros, e.g. security or caching, it means everything is alright with that. I don’t consider such things as benefits, more like must have.
 
I divided each API design approach into sections: introduction, advantages, disadvantages, and use cases. In the introduction I provided basic information and links where you can find more details. Nowadays, the internet is full of data; the only thing you need to know is how to structure it and find what you need.
 
Please, do not confuse API design styles with API protocols. Different API design approaches may support the same protocol under the hood.
 
I believe having a list of pros and cons to review in times of hesitation will help you make the right decision. Do not compare only the number of pros and cons, as it is not just about the quantity. You must weigh the key factors of each item and apply them to your needs. I know sometimes you may think that I am comparing apples and oranges and I tried to add clarity to what I mean in each case.

## REST
 
It is a set of architectural principles that describe how to properly build communication between a client and a server. There is a common misconception that REST must use the HTTP/1 protocol exclusively or that REST and HTTP are the same thing. In reality, things are a bit different. Roy Fielding created the REST architectural style in 2000. Here is his [dissertation](https://ics.uci.edu/~fielding/pubs/dissertation/rest_arch_style.htm?ref=hackernoon.com), where he described the basic principles (Chapter 5). You may also find in section 5.3.2 that REST does not restrict communication to a particular protocol. It is just a de facto standard to use HTTP, specifically HTTP/1.
 
Although I can use REST with custom protocols, and at the same time, I can use the HTTP protocol without API being RESTful. I can have a RESTful API based on HTTP/2 or even HTTP/3, which means I cannot compare the performance of REST and gRPC directly. That might sound confusing. I need to point out that when I refer to a RESTful API, I am referring to one based on HTTP/1; otherwise, the results could be different. REST, like other architectural approaches, has certain principles:
 
- Client/Server
- Stateless
- Cache
- Uniform Interface
- Layered System
- Code on-demand  
Each of these principles is comprehensively described in Roy Fielding’s dissertation and on other websites, and I don’t want to duplicate that information. These principles guide you on how to design your API and create endpoints in systems to avoid problems. A good explanation can also be found [here](https://restfulapi.net/?ref=hackernoon.com).
 
**Advantages**

1. The REST approach is very flexible and can be used in almost any system, regardless of complexity. If you build your endpoints according to the Uniform Interface principle, you will have no problem building an API for the entities you have and scale the system to any size you need.
2. REST APIs are easy to read and understand, even if you’re not a programmer. Tools like Swagger allow you to browse your HTTP API and examine all parameters. If you use the REST approach, your endpoints will be clear and readable.
3. Very popular worldwide, making it easier to build integrations with your API. If you have a platform and need to offer an open API or share your API with certain users, and you design your request structure according to REST principles, it will be easy for other developers to start integrating with it.
4. REST is language and protocol agnostic. The architectural style itself does not rely on any specific language or protocol. While the initial proposal used HTTP/1 as an example, this is not mandatory. You can also move your API to HTTP/2 or HTTP/3, and it will still be RESTful but with added benefits.  
**Disadvantages**

1. Unidirectional communication. REST works only from client to server and was created to resolve certain issues. Unfortunately, sometimes you need to consider other API solutions if you require real-time information or bidirectional communication. REST is simply not designed for that.
2. De-facto highly coupled to HTTP/1. Although you can build a RESTful API with HTTP/2 and HTTP/3, people usually expect HTTP/1, inheriting all its drawbacks. This is especially relevant when your API is involved in B2B integration, where clients may not be ready to switch to HTTP/2 or HTTP/3 from a development perspective.
3. Many APIs are labeled as RESTful but are not truly RESTful. Due to the high coupling with HTTP, many non-RESTful APIs are considered RESTful. It is very easy to follow this approach for newcomers.
4. Hard to support in big systems. With application growth, the number of endpoints can become very large, making it hard to avoid code duplication in certain endpoint implementations, especially if the number of resources in your application is significant.  
**Use cases**  
REST is applicable to almost all levels of system complexity because the entry barrier is quite low and the API can be scaled to almost any size. It requires minimal configuration, allowing application prototypes to be ready in days. It is well-suited for e-commerce applications and back-office operations. REST is an ideal candidate when you need to ask something and see the result. Major applications on mobile phones use REST to communicate with servers. Unless you need exceptionally strong performance or your application must work intensively with the server in both directions, REST is one of the best options to consider.

## gRPC
 
gRPC is not an architectural style but a framework created by Google, based on the HTTP/2 protocol. The framework follows the RPC concept, allowing clients to call specific functions on the server. The calls can be synchronous or asynchronous, with each function having input and output described in a proto file. gRPC uses Google Protobuf for data serialization, meaning that data is transferred between the client and server in a binary format. The framework provides four types of communication:
 
- Unary RPC
- Server streaming RPC
- Client streaming RPC
- Bidirectional streaming RPC
 
Depending on your needs, you can either support well-known request-reply methods of communication or stream data in both directions. For more information, you can visit [gRPC’s official site](https://grpc.io/?ref=hackernoon.com).
 
**Advantages**

1. Speed. The framework uses the HTTP/2 protocol, which can perform several requests in parallel. However, the speed advantage depends on what you compare gRPC with. For instance, compared to HTTP/3, gRPC may be slower, but compared to HTTP/1, it is faster. HTTP/2 sets up a persistent connection between the client and server and then multiplexes requests over this connection, reducing latency and increasing performance.
2. Bidirectional Data Stream. gRPC supports bidirectional communication, allowing data to be streamed in both directions. You can also trigger streaming with a call from the client, which is particularly useful for transferring chunks of data in real-time.
3. Lightweight messages. Using Protobuf, gRPC significantly decreases the size of the payload by around 30%. However, this advantage is not exclusive to gRPC, as you can configure Protobuf to work with REST, HTTP/1, or even WebSockets.
4. Strongly typed messages. You can configure how much memory each attribute consumes, helping to avoid unnecessary data transfer and making messages more compact.  
**Disadvantages**

1. Readability issues. Each method in gRPC requires a defined message format for requests and responses. This means different functions require different messages. With numerous endpoints, the message model can become convoluted and difficult to manage. Messages may be scattered across multiple files, making it challenging to correlate requests with their corresponding functions, especially if code is not very clean.
2. Troubles with load balancing. gRPC performs load balancing only on the client side. It utilizes persistent connection at the TCP level and sends further requests through this connection, and standard microservices load balancing tools won’t help. To achieve request-level load balancing, you must implement client-side load balancing. This involves managing a pool of persistent connections to various servers and distributing requests among them, or creating a new persistent connection for each request, which can degrade performance.
3. Binary data. Dealing with binary data is a common issue in solutions using Protobuf. Without proper conversion, understanding the payload content can be difficult. While there are tools available to assist with this, they require separate installation and configuration, adding complexity to the setup process.
4. Impossible to call from the browser. Some modern browsers do not support direct gRPC calls, complicating debugging and making it challenging to use gRPC directly from the browser. Future improvements in browser support may alleviate this issue.
5. File transfer. While gRPC supports file transfer, it is not widely used for this purpose. For file sizes between 1 MB and 4 MB, simple HTTP file transfers typically outperform gRPC due to the overhead of serialization/deserialization processes involved in gRPC.
6. Too complex for real time updates. gRPC supports streaming for real-time updates, but it may be difficult for simple scenarios. The overhead and complexity of managing gRPC streams may outweigh the benefits, making simpler solutions like WebSocket integration more practical and efficient.  
**Use cases**
 
gRPC is used when you need a strongly typed communication data model that ensures fast and efficient performance. This makes it ideal for microservices architecture. The proto messages can be observed in the repository, making the contract between services clear, and your endpoints do not need to be accessed externally. Due to Protobuf message compression, the transferred size is 30% less than other payloads. Also, for internal communication you don’t need the benefits of REST or other API styles. Just make sure to load balance gRPC requests on the client side if you scale your services horizontally. If you are considering using gRPC between frontend and backend, you will need compelling reasons related to performance. For instance, you may need data streaming with heavy channels or large request payloads, where Protobuf serialization could be beneficial.

## **GraphQL**
 
It is very hard to describe the essence of GraphQL in a few sentences. Long story short, GraphQL allows you to build text-based queries or mutations on the client side and send this information to the server. The server sends this information to the GraphQL server, which parses the text and calls the appropriate resolvers according to the schema definition. Queries are used to retrieve information, and mutations are used to change data (create, update, delete). Resolvers are functions that define how data will be fetched and filtered. The schema is a data definition model where all data types are specified. Additionally, clients can subscribe to certain data for real-time data. GraphQL is a simple wrapper and is not based on any specific protocol. You can use whatever protocol you need, though HTTP is commonly popular, and WebSockets are used for subscriptions. For more information, please visit [GraphQL’s official site](https://graphql.org/learn/?ref=hackernoon.com).
 
**Advantages**

1. Protocol agnostic. GraphQL does not rely on any specific protocol, so you can use HTTP/1, HTTP/2, or HTTP/3. You can even choose another protocol if needed. You just need to properly configure the GraphQL server. This allows you to determine your configuration based on your preferences.
2. Flexible API configuration. GraphQL supports filtering and nested queries, allowing you to retrieve only relevant data based on client requests. You don’t need to transfer unnecessary data, making your requests lightweight and potentially increasing performance. You can easily adjust requests to retrieve the exact information you need. This flexibility helps you avoid creating hundreds of endpoints, where much of the data and logic on the server is partially duplicated.
3. Realtime updates. You can subscribe to any changes and receive updates regularly. This is a significant advantage, making your system more comprehensive. However, you should consider the data size, as such updates typically work over WebSocket, requiring you to follow the protocol’s rules and maintain a small payload.  
**Disadvantages**

1. Long learning curve. GraphQL is complex and it takes time to understand the basic principles and build an efficient API. You need to set up schemas, configure the GraphQL server, define resolvers, and ensure the API works correctly. While it is completely doable, switching to a different context can be challenging.
2. Caching. Although you can configure exactly what you need in your requests, the underlying requests will remain the same, making it impossible to implement caching at the network level. You will need to optimize caching on the server side, possibly using established GraphQL solutions like persistent queries.
3. Over Engineering for simple systems. GraphQL requires preliminary configuration and additional resources to build a robust API. Simple systems may not need this complexity. With simple HTTP, you can see results in hours, but with GraphQL, significant experience is required to achieve the same speed.
4. Heavy requests. While GraphQL allows you to avoid transferring unnecessary data, its payloads can be larger than those of simple HTTP requests due to the additional parameters required by GraphQL. Although the difference is usually only a few KB, it can have an impact if the number of requests is large.  
**Use cases**  
GraphQL is suitable for complex systems where the number of resources can grow significantly. I would not recommend using it in startups unless you are very experienced with GraphQL and know exactly what to do. Otherwise, you will spend a lot of time configuring it properly. The elegance of GraphQL lies in its ability to easily define what data you want from the server without retrieving redundant information. Unlike gRPC, you don’t need to duplicate response messages if you need more or less data. You can easily filter data using nested queries to exclude unnecessary information. Additionally, you can combine real-time updates with simple endpoints, allowing you to maintain a single API approach. In complex systems, REST can be very hard to maintain due to the large number of endpoints, but GraphQL helps make your endpoints more elegant and manageable.

## **EDA**
 
I had some doubts about including the Event Drive API to this list but eventually decided it is an important part. EDA allows you to subscribe to certain types of messages and build your system accordingly. There are different types of events and various approaches to properly design your system to align with them. For instance you follow event sourcing, which allows you to have a sequence of business events and recreate the operation flow. There are hundreds of message brokers and frameworks of any size and scale to help you operate your business logic. Various protocols like AMQP, MQTT, and others dictate how subscribers should get data and how events are propagated. Essentially, EDA is applicable when you need events to signal that something is happening. It is preferable to use asynchronous events because synchronous events create high congestion and unnecessary dependencies.
 
**Advantages**

1. Eliminate dependencies. Asynchronous events are indeed the best way to communicate without the necessity of waiting for a response. There are numerous benefits to this approach. Your service can continue functioning even if another part of the system is down. You don’t need to worry about whether the event is delivered immediately, and you are not dependent on changes in other parts of the system, as long as the event message remains unchanged.
2. Variety of protocols and implementations. There is a wide range of protocols and frameworks available, many of which are open source. You can choose the one that best suits your needs. Kafka, RabbitMQ, NATS, and even Redis have pub/sub implementations. Each of these systems comes with comprehensive documentation and numerous libraries for different languages.
3. Easy to scale. Many message brokers are good at scaling. Generally, you will not encounter scaling issues if your cluster configuration is accurate. Most message brokers can scale horizontally, making it hard to imagine a load that could overwhelm your resources.  
**Disadvantages**

1. Hard to examine message types. Event messages are often not well documented, and descriptions can be hidden somewhere in the repository. Different messages might be scattered across various parts of the repository, so there is no single point of view like with Swagger. However, this can be improved if developers make a concerted effort.
2. Can become a mess in a complex system. Initially, configuring events might be very beneficial, as your service boundaries are uncoupled and independent. However, as the system grows, it becomes challenging to maintain clear event communication. The event structure might become user-defined without a strong protocol, causing dependencies between publishers and subscribers to grow exponentially. This can make it difficult to revert to a clear structure. Data Platforms exist to address this issue by aggregating all events, allowing any service to query the Data Platform directly.
3. Variety of protocols and implementations. This is both an advantage and a disadvantage. While having a wide range of solutions is beneficial, the technological stack for these solutions varies. You may need to spend time understanding the differences between Kafka and RabbitMQ, determining which to use for your scenario, what libraries to integrate, and how to host and scale them. Your developers and DevOps team might lack experience with some solutions or need time to weigh the pros and cons. Without adequate knowledge, there is a risk of missing something, leading to design gaps or the need to seek alternative solutions.  
**Use cases**  
Almost any system sooner or later starts using event-driven architecture. When you need to inform other services without requiring a response, EDA is a good choice, especially when the guarantee of delivery does not need to be 100%. In e-commerce applications, for instance, when a customer makes a purchase, the service may emit an event, and other services can execute their business logic accordingly.
 
However, people sometimes confuse events with commands, particularly when guaranteed delivery is necessary. When you need to inform a service and ensure delivery is guaranteed, otherwise, you cannot proceed, you should consider using an HTTP request, gRPC, or another method. This is because your business logic strongly depends on the response from the different services. For example, you cannot emit an event to withdraw funds and proceed with a purchase transaction without knowing that the balance has been decreased. In such cases, a synchronous call is required.
 
**Why I did not mention SOAP** I strongly believe that SOAP is used primarily in old enterprise applications. SOAP is based on XML, making it heavy. The SOAP architecture is not well-supported nowadays, and you may find difficulties in locating appropriate libraries. Many years ago, when accessible protocols were scarce, SOAP was one of the known solutions, but today it is outdated. It should be considered only when necessary to support legacy applications, where the risks of changing something are critical. This article is written for those who need to decide which approach to use in a new system, so adding SOAP to the list would be redundant.