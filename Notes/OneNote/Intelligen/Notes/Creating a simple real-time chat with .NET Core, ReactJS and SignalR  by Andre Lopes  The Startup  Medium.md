Clipped from: [https://medium.com/swlh/creating-a-simple-real-time-chat-with-net-core-reactjs-and-signalr-6367dcadd2c6](https://medium.com/swlh/creating-a-simple-real-time-chat-with-net-core-reactjs-and-signalr-6367dcadd2c6)

![Exported image](Exported%20image%2020260209140815-0.jpeg)

WebSockets is a technology that enables your server and your client to keep a connection open and send requests to each other. This is widely used when you need to keep your clients synchronized or to send messages or notifications to all your clients.  
Microsoft developed SignalR, which is its technology for developing real-time applications, which are applications where the server can push information to the client instantly. SignalR also has support for the implementation of WebSockets.  
Here I’m going to walk you through the creation of a simple real-time chat by having a .NET Core API and a ReactJS application connected and synchronized with SignalR.

# Requirements

- [.NET Core 3.1.5](https://dotnet.microsoft.com/download/dotnet-core/3.1)
- [NodeJS](https://nodejs.org/en/) — For **npm**
- Your favorite IDE/Text Editor — Here I’ll be using [Visual Studio Code](https://code.visualstudio.com/)

# The Project

Our project will be divided into two projects, one server Web API with .NET Core and one front-end with ReactJS. So let’s create a folder Chatty to hold our whole project.  
We’ll start by developing our API.

# API

Let’s create our API by navigating to the Chatty folder and creating a new folder called API. Inside this folder run the following command to create a new solution:  
dotnet new sln -n Chatty  
Now let’s create a new webapi project and add it to our solution with:  
dotnet new webapi -o Chatty.Api  
dotnet sln add ./Chatty.Api/Chatty.Api.csproj

## SignalR

SignalR already comes shipped in .NET Core 3.1, so there’s no need to add any extra package in our API to use it.  
To handle server-client connections, SignalR uses what is called Hubs. These are classes that implement the Hub class and implement methods that will be called on connected clients from your server.  
So, in your server, you define methods that are called from your clients. And in the client, you define methods that are called by your server.  
Now to create our Hub, create a folder called Hubs and inside of it, create a file ChatHub.cs and, in a Models folder, a class to represent our ChatMessage:  
The method SendMessage sends a ChatMessage to all clients that are listening to the ReceiveMessage event.  
Now you might have noticed the “magical” string ReceiveMessage. This might pose some issues like runtime errors if for some reason we misspell the correct name. To improve this code, we can extend the Hub\<T\> class instead of the default Hub class.  
The type this class receive is an interface that defines our ReceiveMessage action with its parameters.  
So let’s create a folder Clients inside the Hubs folder and add an interface IChatClient.cs:  
And now modify the ChatHub:  
You can note that now we are using the method we defined in our IChatClient instead of the SendAsync method.  
It is extremely important that your method name defined in your interface does not contain any suffixes if it is not your intention. This method name is the one that your client must use to be able to listen to any requests.  
_Note that by extending_ _Hub\<T\>__, the method SendAsync becomes unavailable to use._  
Awesome! We have our hubs defined, now we just need to enable SignalR and register our hub endpoint.  
To do so, let’s add the following line to our ConfigureServices method in Startup.cs:  
services.AddSignalR();  
And after endpoints.MapControllers() inside the app.UseEndpoints in the Configure , add the following line to register our hub on the /hubs/chat endpoint:  
endpoints.MapHub\<ChatHub\>("/hubs/chat");  
Great! Now our SignalR hub is properly configured.  
Two last things to configure are needed so your clients can properly use it.

## CORS

First is configuring CORS ([Cross-origin resource sharing](https://www.w3.org/TR/cors/)) to allow clients from other domains to be able to make requests.  
SignalR requires three policies enabled:

- The origins must be explicitly specified. Wildcards are not accepted.
- GET and POST HTTP methods must be allowed.
- Credentials must be allowed.

First, we need to create a policy with the following code in the ConfigureServices method in our Startup.cs:  
services.AddCors(options =\>  
{  
options.AddPolicy("ClientPermission", policy =\>  
{  
policy.AllowAnyHeader()  
.AllowAnyMethod()  
.WithOrigins("http://localhost:3000")  
.AllowCredentials();  
});  
});  
Now to enable CORS middleware by adding the following line to the Configure method before app.UseRouting():  
app.UseCors("ClientPermission");

## Update HTTPS Certificate

If you chose to not remove **HTTPS** redirection you will need to target the **HTTPS** address because SignalR doesn’t allow redirections. In our case, we will be using the default local address [https://localhost:5001](https://medium.com/swlh/creating-a-simple-real-time-chat-with-net-core-reactjs-and-signalr-6367dcadd2c6).  
To update the certificates is quite easy. Just run the following commands:  
dotnet dev-certs https --clean  
dotnet dev-certs https --trust  
Awesome! Now your API is correctly configured to use SignalR.

# Client

To start our client run the following command in the Chatty root folder:  
npx create-react-app client  
This will generate a new React project for us without the need of installing create-react-app.  
Now to use SignalR in your React project, we will need a package @microsoft/signalr. It contains all the necessary implementations to connect to our hub and listen to requests. To add it run the following command:  
npm i --save @microsoft/signalr  
Now let’s start by creating a ChatInput.js to render our user and message inputs:  
After that, we create a Message.js to display our message block and a ChatWindow.js to render ao chat messages:  
Awesome! We have our base components. Let’s connect them and enable a SignalR connection. Let’s create a Chat.js component:  
And now for the App.js:

## Result

Now run your API from the api folder with:  
dotnet run -p ./Chatty.Api/Chatty.Api.csproj  
And then run your client from the client folder with:  
npm start  
It will open your browser for you and you should see this view:

![User. Message Submit](Exported%20image%2020260209140817-1.png)

Now, if you open two tabs with the client’s address and fill the inputs with some information, you should see the messages showing on both views.  
Here’s a demo on the chat working.

![React App React App c localhost3000 User Message S...](Exported%20image%2020260209140820-2.gif)

# Send message from outside the hub

At the moment we are using the /hubs/chat endpoint provided by SignalR to send requests to the server. But what if we want to send the new message to one of our endpoints and run some logic there, instead of our hub?  
For that, .NET Core gives us IHubContext to be able to inject and use our hub inside other services.  
To use it, let’s first create a new controller ChatController.cs:  
Here we inject the interface IHubContext\<THub, T\> where THub is our ChatHub and T is our client type IChatClient.  
_Note that you can inject_ _Hub\<ChatHub\>__, but then you won’t be able to access the methods from your_ _IChatClient__, like_ _ReceiveMessage__._  
And as we will not be using SendMessage anymore, we can just remove it from our ChatHub.cs , leaving it to be:  
Now that we defined our endpoint, we just need to change how we make the request to the API. Instead of using the SignalR connection, we can make a directly HTTP POST request to /chat/messages.  
Our new Chat.js will be like:  
Now if you run the API and Client, you’ll be getting the same result as before.

# Conclusion

WebSockets are a great technology when you need to keep your clients synchronized with changes from your server. This is really useful when dealing with messages and notifications that need to be seen in real-time.  
SignalR is Microsoft’s technology that makes it easy to implement real-time applications. And the greatest thing is that you don’t need to install any third-party packages because it is already embedded in the .NET Core framework.  
Also, for the front-end part, it is not so difficult either to implement and use WebSockets connections from your API.  
In this article, you could also see how to, instead of using your Hub to make requests to your API, you can make use of IHubContext in your services or controllers, this can help you avoid having too much logic in your Hub.  
If you’d like to see how the finished project from this article, you can get it [here](https://github.com/alopes2/Medium-Chatty).