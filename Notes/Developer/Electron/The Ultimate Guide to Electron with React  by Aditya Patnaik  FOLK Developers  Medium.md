Clipped from: [https://medium.com/folkdevelopers/the-ultimate-guide-to-electron-with-react-8df8d73f4c97](https://medium.com/folkdevelopers/the-ultimate-guide-to-electron-with-react-8df8d73f4c97)

![F DELECTRON React](Exported%20image%2020260208235847-0.png)

Welcome to the Most Comprehensive Cross-Platform Desktop App Development journey.  
In this article, we’ll learn how to implement powerful features of Electron with React. By the end of the article, you will be a maestro on the following implementations:

1. How to create desktop app screens?
2. How to implement routes using react-router-dom on Electron?
3. How to make native calls from a React Component using the remote module?
4. How to trigger OS-specific dialogs from within a React component?
5. IPC(Inter-process Communication) in Electron.

Towards the end of the article, we have a surprise for you!

![Exported image](Exported%20image%2020260208235848-1.gif)

gif: excited Pikachu

# Prominent Apps built using Electron

![Exported image](Exported%20image%2020260208235849-2.gif)

Products that are built using Electron

# Electron? I’m outta here if we’re learning physics!

**Electron** is a robust multi-process-architecture framework that runs on the chromium engine. It ensures that the heavy I/O and CPU-bound operations are put onto the new threads that would avoid blocking the UI(**main process**).  
Electron ships with the latest version of Chrome. Its powerful features could be used to orchestrate heavy computations in an application window(**renderer process****)** that would enable the app to run at 60fps.

# Wait! What’s the main process? It sounds scary!

The main process is the backbone of an Electron App. It can spawn multiple child processes(also called the renderer process). How? We will see that in a minute.  
Let’s quickly set up a react app with Electron.  
It is assumed that you have node and npm installed. Create a folder named **electron-app**. Open the folder in your favorite code editor.  
Fire up a terminal and run npx create-react-app . with a dot at the end, which would create a react app in the current directory.  
Create a file called **main.js** under the public folder.

![v public favicon.ico index.html JS logo 192.png lo...](Exported%20image%2020260208235851-3.png)

Screenshot:public folder  
Copy the code given below to the **main.js** file. We’ll come back to what it does in some time.  
With that done, open up your **package.json** file.  
Add the **main** entry that holds the path pointing to the **main.js** file, as shown below.  
//Dont forget to add a comma after this line"private":true,//add this line**"main":"public/main.js"**  
Now we are ready to install Electron, open up the terminal, and run:  
npm i electron  
Now, let’s add an entry to the scripts section in the **package.json** file to run the react app on Electron.  
Add **electron-dev** as an entry holding the value electron . under the scripts section in the package.json file as shown below.

![15 16 17 18 19 2e 21 scripts reactscripts start , ...](Exported%20image%2020260208235852-4.png)

Screenshot: package.json — scripts section  
If you have followed all the steps correctly, the **package.json** file should look as given below.  
Now, its time to start the electron app. As Electron emulates the react-app, we first need the react-app running.  
Open a terminal instance and run:  
npm start  
Once the react app is up and running on the browser, open another terminal and run:  
npm run electron-dev  
You should see a native Desktop window running your very first electron app!

![React App File Edit View hov . cls Window Help x x...](Exported%20image%2020260208235854-5.png)

Screenshot:First Electron App with React

# Main Process

An Electron app has a main process that creates the GUI by spawning BrowserWindows. Each BrowserWindow runs its isolated renderer process and gets destroyed when the BrowserWindow is closed. When we run the npm run electron-dev (runs electron . under the hood) command, the main process starts and initializes the Electron Environment.  
Next, the main process looks for the main entry in the package.json file and runs the main file.  
In the main.js file, Electron checks if the **ready** event has been already fired.  
**ready Event**  
The first event that gets fired. It fires after Electron has finished initializing.To check if the **ready** event is fired, the **isReady()** or the **whenReady()** function is used.  
The **whenReady()** function returns a fulfilled promise only when the ready event has been fired.  
app.whenReady().then(createWindow)  
If the **whenReady()** function returns a fulfilled promise, the **createWindow()** function is executed. The **createWindow()** function spawns a new BrowserWindow instance and loads a webpage into it.

# Renderer Process

Each renderer process cares about the webpage running in it. A **BrowserWindow** seeks for an HTML file. In our case, the react-app has its **index.html** file running on port 3000. On passing the URL of an html file to the _loadURL()_ function, Electron loads it on the **BrowserWindow**.  
win.loadURL('http://localhost:3000');  
If all BrowserWindows are closed signaling an app-exit operation, the **window-all-closed** event is triggered exactly after the last BrowserWindow instance closes. The **quit()** function from the app module quits the app.  
**window-all-closed Event**  
The event is triggered when all BrowserWindows are closed.  
app.on('window-all-closed', () =\> {  
if (process.platform !== 'darwin') {  
app.quit()  
}  
})  
However, on macOS(darwin), it’s normal for an app to remain active in the dock until the user explicitly quits it, so we can keep the app active in the dock.

# Remote Module

The remote module enables the renderer process to access APIs which are normally only available to the main process. To access them from a renderer process, the remote module uses an internal IPC channel to communicate with the main process. We’ll discuss IPC in detail later in this article. The remote module lets us access the GUI modules without having to explicitly send inter-process messages.  
It’s important to understand that although we can access GUI modules in the renderer process, it’s often misunderstood that the modules are created in the renderer process. Because, in reality, the objects are created in the main process and are remotely shared with the renderer process.  
import React from 'react';  
// how to import the remote module in a React component?  
const electron = window.require('electron');  
const remote = electron.remote  
const {BrowserWindow,dialog,Menu} = remote  
Enable the remote module by setting the **enableRemoteModule** option to true.

# BrowserWindow

We have already seen what a BrowserWindow is and what it does. Let’s look at the BrowserWindow properties.

## How to Create a BrowserWindow?

The line below creates a blank BrowserWindow.  
//width and height defaults to 800 by 600  
const window = new BrowserWindow()  
We saw how to load an HTML file from a URL using the **loadURL()** function. However, in production, we bundle files/modules that we need the most. The **loadFile()** function helps in loading the HTML file from the assets.  
Here’s how it looks.

![o](Exported%20image%2020260208235858-6.gif)

gif: BrowserWindow loads Electron’s official website

## Setting Dimensions

The BrowserWindow API gives away properties to set the dimensions of a BrowserWindow.  
function createWindow () {  
const windowOne = new BrowserWindow({width:400,height:400})  
}  
The example above creates a BrowserWindow with dimensions 400 by 400. However, it would stretch endlessly which may not be the expected behavior.  
You can set an upper/lower cap by setting the maxHeight, maxWidth, minHeight, and minWidth properties.  
function createWindow () {  
const windowOne = new BrowserWindow({  
width:500,  
height:500,  
maxHeight:600,  
maxWidth:600,  
minHeight:400,  
minWidth:400,  
backgroundColor:'#7B435B'})  
}  
Now the window is stretchable only between the dimensions 400 x 400 and 600 x 600. Awesome!

![Exported image](Exported%20image%2020260208235900-7.gif)

gif: BrowserWindow stretches between 400x400 and 600x600

## Custom Title

If not explicitly defined as shown below, the title of a BrowserWindow would be the same as the app-name defined in the package.json file. Or, if a title is defined in the HTML file running on it, that would be taken as the title.  
function createWindow () {  
const windowOne = new BrowserWindow({  
title:"My First App"  
})  
}

## How to Create a Frameless BrowserWindow?

By setting the frame property to false, a BrowserWindow removes parts of a native window, like Menu, toolbar, close and minimize buttons.  
function createWindow () {  
const windowOne = new BrowserWindow({  
title:"My First App",  
frame:false  
})  
}

![Docs Releases Blog Apps Governance Community Engli...](Exported%20image%2020260208235902-8.png)

Screenshot: Frameless BrowserWindow

## Creation of Parent and Child Windows

If a parent property is defined on a BrowserWindow, then that BrowserWindow becomes a child window to the BrowserWindow that has been assigned as its parent window.  
function createWindow () {  
let heyparent = new BrowserWindow()  
let heychild = new BrowserWindow({ parent: heyparent })  
heychild.show()  
heyparent.show()  
}  
A child window always stays on top of the parent window.

![Dwp.](Exported%20image%2020260208235903-9.gif)

gif: Parent and Child BrowserWindows

## Modal Window

How to disable a parent window when a child window pops up? That’s exactly what a modal window does. To create a modal window, you need to set both the parent and modal properties.  
const parent = new BrowserWindow()const child = new BrowserWindow({ parent: top, modal: true})  
child.loadURL('https://github.com')  
While the above approach successfully creates a modal window, Electron loads it with a slight delay. So, the recommended way is to set the **show** property to false.  
Now as soon as the child window gets rendered, show it by running the show function. But, how to detect when a page finishes getting rendered?  
As soon as a webpage renders, the **ready-to-show** event is fired.  
**ready-to-show event**  
This event is a renderer process event, emitted when the web page has been rendered (while not being shown) and window can be displayed without a visual flash.  
When the **ready-to-show** event is fired the webpage could then be shown using the **show()** function without the delay.  
const parent = new BrowserWindow()// recommended  
const child = new BrowserWindow({  
parent: parent,  
modal: true,  
show: false  
})child.loadURL('https://github.com')  
//show as soon as the file is rendered  
child.once('ready-to-show', () =\> { child.show() })

![Exported image](Exported%20image%2020260208235905-10.gif)

gif: Modal window disables parent window

## How to remove/hide the MenuBar?

Call the **removeMenu()** function or set the Menu to null by using **setMenu()** function.  
Here’s how a BrowserWindow looks with the menu bar removed.

![GitHub Where the world builds software GitHub o Bu...](Exported%20image%2020260208235906-11.png)

Screenshot: Menu-less BrowserWindow

## Open a BrowserWindow from a React Component

The component has a button that fires-up a BrowserWindow on click.  
Here’s how it looks.

![Open BrowserWindow](Exported%20image%2020260208235907-12.gif)

gif: Open a BrowserWindow from a React Component on button click

# How to open a Dialog in Electron from a React Component?

We’ll discuss three prominent dialogs. We’ll trigger each with a click of a button from a React Component.

## showErrorBox()

Displays a dialog that shows an error message. It takes two parameters, a **title: string** and a **content: string**. It is used to report errors at the startup. Hence, this could be safely used before the ready event.  
import React from 'react';  
const electron = window.require('electron');  
const remote = electron.remote  
const {dialog} = remoteconst App = () =\>{return( \<button onClick={()=\>{ dialog.showErrorBox('Error Box','Fatal Error') }}\>Show Error Box\</button\>  
)  
}export default App  
Let’s see it in action

![Show Error BOX](Exported%20image%2020260208235912-13.gif)

gif: Error Box on a button click

## showOpenDialog()

Acts as a file selector or a directory selector. The properties array could be set to define the behavior of the dialog. This function returns a Promise that resolves to an object with the following properties:  
cancelled : Boolean — whether or not the dialog was canceled.  
filePaths: Array — An array of file paths selected.  
You can also specify filters to limit the user to select specific file types.  
dialog.showOpenDialog({  
title: 'Title',  
message: 'Message'  
filters: [  
{ name: 'Images', extensions: ['jpg', 'png', 'gif'] },  
{ name: 'Movies', extensions: ['mkv', 'avi', 'mp4'] },  
{ name: 'Custom File Type', extensions: ['as'] },  
{ name: 'All Files', extensions: ['*'] }  
]  
})  
Here’s how it looks.

![Exported image](Exported%20image%2020260208235913-14.gif)

gif: File selector dialog on a button click

## showMessageBox()

Shows different types of dialogs based on the **type** specified. This dialog function also takes buttons, checkboxes, etc. The Message Box blocks the process until the dialog is closed. This function returns a Promise that resolves to an object with the following properties:  
response: Index of the clicked Button  
checkboxChecked: Boolean — Whether or not the checkbox is checked.  
The following is a demonstration of different types of Message Boxes with its most used parameters.  
Here’s how it looks.

![Message BoxNone Message Boxinfo with buttons Messa...](Exported%20image%2020260208235915-15.gif)

gif: Multiple message box types on a button click

# How to build a custom Menu in Electron?

Generally, it’s best to set a menu in the ready event. However, let’s first set it from a react component on a button click.

## buildFromTemplate

The **buildFromTemplate** function takes an array of options(template) and returns a Menu instance. Each option is an object that takes the following parameters: **label: string, click: function,type: string, submenu: array(options)** and **role: name-of-a-role.**  
// option:object  
{label:'options',submenu:[{role:'selectall'},{role:'reload'}]}

## setApplicationMenu

Takes a Menu instance as a parameter and sets the Menu as each window’s top menu.  
See it in action.

![Look at the Menu!](Exported%20image%2020260208235916-16.gif)

gif: Custom Menu

## Menu with the role, separator, and submenu properties

In the following example, we will see the menu with separator, submenus, and roles.  
Here’s how it looks.

![Open options mth Separator Look at the Menu!](Exported%20image%2020260208235918-17.gif)

gif: Custom Menu with Submenu,separator and roles

# How to implement Routes in Electron with React

## Why not use BrowserRouter?

Conventionally, in a react app, we enclose our Routes in a BrowserRouter component. The BrowserRouter component implements a routing mechanism that is best suited for a request based environment. Here’s a simple example that demonstrates routing in a react-app.  
Though the BrowserRouter component works well with request based frameworks like react, it may not work at all with file-based environments like Electron. However, the react-router-dom package has us covered for all our routing cases.

## Hash Router to the rescue!

The react-router-dom package ships with the Hash Router Component that works like a BrowserRouter in a file-based environment.  
Routes using the Hash Router component can be set up in the same way as with BrowserRouter. All you need to change in the BrowserRouter based implementation is to replace the BrowserRouter component with the HashRouter component and you are good to go. Here are the BrowserRouter based routes modified to work with Electron.  
Let’s see that in action.

![File Edit View Window Help Heme Stand Sit](Exported%20image%2020260208235919-18.gif)

gif: Routes using HashRouter  
Great! So far we have learned to create/modify BrowserWindows, ran pages in it, triggered some well-targeted OS-specific dialogs for a range of use cases, set up routes using HashRouter, accessed modules in the renderer process that are only accessible in the main process using the remote module. Let’s dig a little deeper and understand the heart of the Electron Framework, the IPC!

# Inter-Process Communication(IPC)

We have learned about the **main** and **renderer** process.  
**Inter-process Communication** refers to the mechanism provided by the operating system that allows two processes to interact with each other.  
Electron requires the main process to create/handle BrowserWindows, each running its own renderer process that runs a webpage. **So, if a renderer process needs to make some changes to the GUI by making use of the native API, it could directly import the necessary native modules from Electron and call as it needs. Right?**  
Wrong! A renderer process runs third-party libraries/webpages, hence, calling native GUI APIs could be fatal and may account for data leaks.  
If a renderer process needs to perform a GUI operation on a webpage, **it must communicate with the** **main** **process that could in turn operate only after validating if the native-operation-request is indeed valid**.  
The communication between the main and renderer process could be synchronous or asynchronous based on the requirement.

![send Executing tasks on Native API on behalf of re...](Exported%20image%2020260208235921-19.png)

Screenshot:Illustration depicting Inter-process communication between main and renderer process  
The renderer process sends a request to the main process on a specified channel for the execution of a native operation with some arguments and the main process fulfills the request by executing the operation on the native API with the arguments on the webpage asynchronously.

## on() and once()

Both ipcMain and ipcRenderer modules have ‘**on’** and ‘**once’** methods to listen for events on a specific channel.  
//**channel:**string and **listener:**callback with event and args as function parameters// main process  
ipcMain.on(channel, listener)  
ipcMain.once(channel, listener)// renderer process  
ipcRenderer.on(channel,listener)  
ipcRenderer.once(channel,listener)  
When a new message arrives on a specified channel the callback(listener) would be executed with the parameters passed.  
The ‘**once**’ function also behaves in the same way, the only difference is that it gets removed after listening once to an event.

## send()

The ipcRenderer module has a ‘**send’** method to send messages to a specified channel.  
// channel:string(channel name),  
// args to be sent through the channel  
// to the main process.  
ipcRenderer.send(channel,...args)

## removeListener() and removeAllListeners()

There are situations where many renderer processes subscribe to a channel on the main process, you may want to remove one or all listeners at once for better performance. The ipcMain module ships with the **removeListener** and **removeAllListeners** methods that remove a specified listener and all listeners from a channel respectively.  
// removes a specific listener from a specified channel  
removeListener(channel,listener)// removes all listeners from a channel  
removeAllListeners([channel])

## Asynchronous Message Exchange

Assume that you want to call a native API from a renderer process, you would naturally make an IPC call to the main process as native APIs are inaccessible in the renderer process. But what if the requested native operation is a heavy one? If that’s the case the IPC call will end up blocking the UI till the heavy native operation has finished its execution. The non-blocking asynchronous **send** function solves this problem.  
The main process can also send a **reply** asynchronously with some meta-data after fulfilling the request.

## Synchronous Message Exchange

There could be situations where some user activity may need an immediate change in the UI. For all such urgent triggers in the UI, the synchronous way of exchange could be used.  
The ipcRenderer module ships with a ‘**sendSync**’ function that behaves exactly like the ‘**send**’ function but behaves synchronously. That also means any requests sent synchronously has to be light in terms of resource utilization as otherwise, it may block the UI from rendering seamlessly.  
Let’s try to implement what we have learned so far on React.

# Let’s see the IPC in action with a React component

We will send messages to the main process from a react component on a button click both synchronously and asynchronously.  
Let’s create two buttons in the App component. Each for synchronously as well as asynchronously sending a string to the main process.

## [App.js](https://gist.github.com/adityapatnaik/0879a40c35cbdb32745a177049dccf1b)

In the main.js file, create an ‘**on**’ function to listen to the messages sent on the ‘**anything-synchronous**’ and ‘**anything-asynchronous**’ channels.

## [main.js](https://gist.github.com/adityapatnaik/d76a75c1bb9f4de841a9e042bbae1f7d)

Here’s how it would look like.

![Site V. Run PS C r.](Exported%20image%2020260208235925-20.gif)

gif: IPC send function(async and sync)

## Let’s also send a reply to the renderer process(App component) from the main process both synchronously and asynchronously.

## Asynchronous Reply

To send a reply to an asynchronous message, the ‘**event.reply**’ method is used.  
The asynchronous reply is sent on a different channel so that the meta-data passed as a reply doesn’t clog the main channel where the native requests are made by the renderer processes.  
**main.js**  
**App.js**  
Since the reply is sent on a different channel by the main process, the renderer process should be listening to it in order to accept the reply.  
The ‘**on**’ method is used with a listener(callback) that would catch the reply in the ‘**arg**’ param passed to the listener.

## Synchronous Reply

In order to send a reply synchronously, set the ‘**event.returnValue**’ to the data to be passed as a reply.  
**main.js**  
**App.js**  
And here’s how you catch it in the renderer process i.e. App component.  
Here’s how it would look like.

![ou,4s ouKsv](Exported%20image%2020260208235926-21.gif)

gif: IPC two-way message exchange (sync and async)  
On the left is the renderer process running the App component, on the right is the main process. On the browser console, you can see the messages sent by the main process in reply to both asynchronous and synchronous messages sent by the renderer process.

## Surprise! Good News for you!

Microsoft has been trying to implement its blazing fast WASM(WebAssembly) enabled .NET based cross-platform app development framework **BLAZOR** on Electron. That would be a humongous performance upgrade for Apps made with Electron with little or no changes to the code base.  
If you have reached this far, give yourself a pat on the back. You did a great job. With Electron,you have started your development journey with a Bang!  
A Big Thank You for giving us your time.

![Exported image](Exported%20image%2020260208235927-22.gif)

gif: Thank You  
I wish you all the very best for the future!

![Exported image](Exported%20image%2020260208235929-23.gif)