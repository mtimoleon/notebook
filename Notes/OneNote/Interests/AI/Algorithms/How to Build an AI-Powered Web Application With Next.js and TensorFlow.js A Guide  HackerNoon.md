Clipped from: [https://hackernoon.com/how-to-build-an-ai-powered-web-application-with-nextjs-and-tensorflowjs-a-guide?source=rss](https://hackernoon.com/how-to-build-an-ai-powered-web-application-with-nextjs-and-tensorflowjs-a-guide?source=rss)  
by [IvanDev](https://hackernoon.com/how-to-build-an-ai-powered-web-application-with-nextjs-and-tensorflowjs-a-guide)

## IvanDev

### @ivandev

_Backend developer loves metal and rock music and sometimes plays..._

August 31st, 2024

Read this story in a terminal

![Print this story](Exported%20image%2020260209130240-0.png)

Print this story  
Read this story w/o Javascript

## Too Long; Didn't Read

Building an AI-Powered Web Application with Next.js and TensorFlow.js. Artificial Intelligence is revolutionizing modern web technology, making it more innovative and responsive. By incorporating AI, developers can enhance user experiences through features like real-time data analysis, personalized content recommendations, and advanced image recognition.

## IvanDev

@ivandev  
Backend developer loves metal and rock music and sometimes plays acoustical flamenco guitar for fun!  
[About @ivandev](https://hackernoon.com/how-to-build-an-ai-powered-web-application-with-nextjs-and-tensorflowjs-a-guide)  
LEARN MORE ABOUT @IVANDEV'S  
EXPERTISE AND PLACE ON THE INTERNET.

This tutorial is designed to guide you through building an AI-powered web application and showcase the potential of AI in everyday web development. Artificial Intelligence (AI) is revolutionizing modern web technology, making it more innovative and responsive. By incorporating AI, developers can enhance user experiences through features like real-time data analysis, personalized content recommendations, and advanced image recognition.
 
Next.js is a robust Reach framework that enables developers to quickly build server-side rendered and static web applications. It offers excellent performance, scalability, and a seamless developer experience. TensorFlow.js, on the other hand, TensorFlow.js is a Javascript library that allows you to train and run machine learning models directly in the browser.
 
By combining Next.js and TensorFlow.js, you can create sophisticated web applications that leverage the power of AI without needing extensive backend infrastructure.
 
By the end of this tutorial, you will have built a fully functional AI-powered web application capable of performing image recognition tasks. You'll gain hands-on experience with Next.js and TensorFlow.js, learning how to integrate machine learning models into a modern web framework.
 
This tutorial will equip you with the skills to start incorporating AI features into your projects, opening up new possibilities for innovation and user engagement.

## Setting Up the Environment

### Prerequisites:

- Basic JavaScript
- Node.js
- Code Editor

## Step 1: Setting Up the Project

- First, ensure you have Node.js installed on your system. If you haven't already, you can download it from [nodejs.org](https://nodejs.org/en?ref=hackernoon.com).
 
- Next, make a folder on your PC, like in a Linux/Mac root folder or Windows.
 
- **Linux/Mac**

It's common to place your projects in a Projects directory within your home directory.

- Open the VS Code at the top bar, select View scroll down to the terminal, and create a folder called Projects this into the terminal:

mkdir -p ~/Projects
 
and move to the project's folder by running:  
cd Projects

 
Your projects would then be located in paths like:/home/your-username/Projects/my_project (Linux)/Users/your-username/Projects/my_project (Mac)
 
**Windows Using Linux subsystem WSL**

- Open VS Code press F1, and select connect to WSL.
 
- Follow the same previous instructions from Linux/Mac

## Step 2: Installing Next.js

If you haven't installed Next.js yet, you can create a new Next.js project using the following command:

### Installing Next.js:

npx create-next-app ai-web-app

 
Test that the app is working as for now:  
npm run dev

 
You will see the Next.js app on the page [http://localhost:3000](http://localhost:3000). If it works, we can proceed.

### Installing TensorFlow.js:

npm install @tensorflow/tfjs @tensorflow-models/mobilenet

 
### Project Structure

ai-web-app/
├── node_modules/
├── public/
├── src/
│ ├── pages/
│ │ ├── api/
│ │ │ └── hello.js
│ │ ├── _app.js
│ │ ├── _document.js
│ │ ├── index.js
│ ├── styles/
│ │ ├── globals.css
│ │ ├── Home.module.css
│ ├── utils/
│ │ └── imageProcessing.js
├── .gitignore
├── package.json
├── README.md

 
So, we have to add the following file:

- imageProcessing.js
- Edit src/pages/index.js:
 
Erase all the code and add the following ones:

## Part 1: Imports and State Initialization

1. Imports
 
- Head from next/head: Used to modify the \<head\> section of the HTML.
- styles from ../styles/Home.module.css: Imports the CSS module for styling.
- useState from react: React hook for state management.
- loadModel and loadImage from @/utils/imageProcessing: Utility functions for loading the model and image.
 
1. State Initialization
 
- model: State to store the loaded TensorFlow model.
- predictions: State to store the predictions made by the model.

import Head from "next/head"; import styles from "../styles/Home.module.css"; import { useState } from "react"; import { loadModel, loadImage } from "@/utils/imageProcessing";  
export default function Home() { const [model, setModel] = useState(null); const [predictions, setPredictions] = useState([]);
  
## Part 2: Handling Image Analysis

1. handleAnalyzeClick Function:
 
- Retrieves the uploaded image file.
 
- Loads the image and passes it to the model for classification.
 
- Sets the predictions state with the results.

const handleAnalyzeClick = async () =\> { const fileInput = document.getElementById("image-upload"); const imageFile = fileInput.files[0];  
if (!imageFile) {
 alert("Please upload an image file.");
 return;
}

try {
 const image = await loadImage(imageFile);
 const predictions = await model.classify(image);
 setPredictions(predictions);
} catch (error) {
 console.error('Error analyzing the image:', error);
}

 - Retrieving the Uploaded Image File:

const fileInput = document.getElementById("image-upload"); const imageFile = fileInput.files[0];
   

- document.getElementById("image-upload");: This retrieves the file input element from the DOM. This element is where users upload their images.
- const imageFile = fileInput.files[0];: This gets the first file from the file input. The files property is an array-like object, so we select the first file uploaded.
 
1. Checking if an Image File is Uploaded:

if (!imageFile) { alert("Please upload an image file."); return; }
 
- if (!imageFile): This checks if an image file is selected. If no file is selected, imageFile will be null or undefined.
- alert("Please upload an image file.");: If no file is selected, an alert message is displayed to the user.
- return;: The Function exits early if no file is selected, preventing further execution.
 
1. Loading the Image and Classifying It:

try { const image = await loadImage(imageFile); const predictions = await model.classify(image); setPredictions(predictions); } catch (error) { console.error('Error analyzing the image:', error); }

3. try { ... } catch (error) { ... }: The try-catch The block handles any errors during the image loading and classification process.
4. Loading the Image:

const image = await loadImage(imageFile);
 
- loadImage(imageFile): This function is a utility that converts the image file into a format suitable for processing TensorFlow.js. It likely involves reading the file and creating an HTML image element or a TensorFlow.js tensor.
- await: This keyword ensures that the Function waits for the image loading to complete before moving to the next step.
- const image =: The loaded image is stored in the image Variable.

### Classifying the Image:

const predictions = await model.classify(image);

 
- model.classify(image): This method uses the TensorFlow.js model to classify the input image. It returns predictions about what the image contains.
- await: This ensures the Function waits for the classification process to complete.
- const predictions =: The classification results are stored in the predictions Variable.

### Setting Predictions State:

setPredictions(predictions);

 
setPredictions(predictions): This updates the predictions State with the new classification results. This triggers a re-render of the component, displaying the predictions to the user.

1. Handling Errors:

catch (error) { console.error('Error analyzing the image:', error); }
 
catch (error) { ... }: This block catches any errors that occur during the try block.console.error('Error analyzing the image:', error);: If an error occurs, it logs the error message to the console for debugging purposes.

## Part 3: Loading the TensorFlow Model

1. Model Loading:
 
- Uses a useState Hook to load the model when the component mounts.
- Sets the loaded model into the state.

useState(() =\> { (async () =\> { try { const loadedModel = await loadModel(); setModel(loadedModel); } catch (error) { console.error('Error loading the model:', error); } })(); }, []);
 
- Defines a React useState Hook that initializes and loads the TensorFlow.js model when the component mounts.
- It uses an immediately invoked asynchronous function to call the loadModel Function, which loads the model and sets it in the component's state using the setModel Function.
- If an error occurs during the model loading process, it catches the error and logs it to the console.
- The empty dependency array [] ensures this effect runs only once when the component is first rendered.

### Basic Layout

To begin building our AI-powered web application with Next.js and TensorFlow.js, we'll set up a basic layout using Next.js components. This initial structure will be the foundation for our application's user interface.

## Part 4: Rendering the UI

### 5. Rendering:

- Renders the main layout of the application.
- Provides input for image upload and button for analysis.
- Displays the predictions if available.

## JSX Return Statement

### 1. Fragment Wrapper

return (
 \<\>
 ...
 \</\>

 
\<\> ... \</\>: This React Fragment allows multiple elements to be grouped without adding extra nodes to the DOM.

### 2. Container Div

\<div className={styles.container}\>
 ...
\</div\>

 
\<div className={styles.container}\> ... \</div\>: This div wraps the main content of the page and applies styling from the styles.container Class.

### 3. Head Component

\<Head\>
 \<title\>AI-Powered Web App\</title\>
\</Head\>

 
### 4. Main Content

\<main className={styles.main}\>
 ...
\</main\>

 
\<main className={styles.main}\> ... \</main\>: This main element contains the primary content of the page and applies styling from the styles.main class

### 5. Title and Description

\<h1 className={styles.title}\>AI-Powered Web Application\</h1\>
\<p className={styles.description}\>
 Using Next.js and TensorFlow.js to show some AI model.
\</p\>

 
- \<h1 className={styles.title}\> ... \</h1\>: This heading displays the main title of the page with styling from the styles.title Class.
- \<p className={styles.description}\> ... \</p\>: This paragraph provides a brief description and is styled using the styles.description Class.

### 6. Input Area

\<div id="input-area"\>
 \<input type="file" className={styles.input} id="image-upload" /\>
 \<button className={styles.button} onClick={handleAnalyzeClick}\>
 Analyze Image
 \</button\>
\</div\>

 
- \<div id="input-area"\> ... \</div\>: This div wraps the input elements for uploading and analyzing an image.
- \<input type="file" className={styles.input} id="image-upload" /\>: This input element allows users to upload an image file. It uses the styles.input class for styling and has an ID of image-upload.
- \<button className={styles.button} onClick={handleAnalyzeClick}\>Analyze Image\</button\>: This button triggers the handleAnalyzeClick function when clicked. It is styled using the styles.button Class.

### 7. Ouput Area

\<div id="output-area"\>
 {predictions.length \> 0 && (
 \<ul\>
 {predictions.map((pred, index) =\> (
 \<li key={index}\>
 {pred.className}: {(pred.probability * 100).toFixed(2)}%
 \</li\>
 ))}
 \</ul\>
 )}
\</div\>

 
- \<div id="output-area"\> ... \</div\>: This div contains the output area where predictions are displayed.
- {predictions.length \> 0 && ( ... )}: This conditional rendering checks for predictions and renders the list of predictions if there are any.
- \<ul\> ... \</ul\>: An unordered list that will contain the prediction items.
- predictions.map((pred, index) =\> ( ... )): This maps over the predictions Array and render each prediction as a list item.
- \<li key={index}\> ... \</li\>: Each list item displays the class name and probability of the prediction, formatted to two decimal places. The key attribute helps React identify which items have changed
 
Edit the Styles for the index.js file in Home.module.css erase all the code, and add the following one:  
.container {
 min-height: 100vh;
 padding: 0 0.5rem;
 display: flex;
 flex-direction: column;
 justify-content: center;
 align-items: center;
}
.main {
 padding: 5rem 0;
 flex: 1;
 display: flex;
 flex-direction: column;
 justify-content: center;
 align-items: center;
}
.title {
 margin: 0;
 line-height: 1.15;
 font-size: 4rem;
 text-align: center;
}
.description {
 margin: 4rem 0;
 line-height: 1.5;
 font-size: 1.5rem;
 text-align: center;
}

\#ouput-area {
 margin-top: 2rem;
}
.li {
 margin-top: 10px;
 font-size: 20px;
}
.button {
 margin-top: 1rem;
 padding: 0.5rem 1rem;
 font-size: 1rem;
 cursor:pointer;
 background-color: \#0070f3;
 color: white;
 border: none;
 border-radius: 5px;
}

.button:hover {
 background-color: \#005bb5;
}

 
Once you have done the previous steps, check to see something like this:   [UI Visual](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fv2t07fw8s29mw4g7uees.png?ref=hackernoon.com)  
Now, let's work with the brain of the app. imageProcessing.js File:

## Part 1: Loading the Model

### Function: loadModel

import * as tf from "@tensorflow/tfjs";
import * as mobilenet from "@tensorflow-models/mobilenet";

export async function loadModel() {
 try {
 const model = await mobilenet.load();
 return model;
 } catch (error) {
 console.error("Error loading the model:", error);
 throw error;
 }
}

 
This Function loads the MobileNet model using TensorFlow.js. Here's a step-by-step explanation:

- Imports: The Function imports TensorFlow.js (tf) and the MobileNet model (mobilenet).
- Function Definition: The loadModel function is defined as an asynchronous function.
- Try-Catch Block: Within a try-catch block, the Function loads the MobileNet model asynchronously with await mobilenet.load().
- Return Model: If successful, it returns the loaded model.
- Error Handling: If an error occurs, it logs the error to the console and throws it, allowing the calling function to handle it.

## Part 2: Preprocessing the Image

### Function: preprocesImage

export function preprocesImage(image) {
 const tensor = tf.browser
 .fromPixels(image)
 .resizeNearestNeighbor([224, 224]) // MobileNet input size
 .toFloat()
 .expandDims();
 return tensor.div(127.5).sub(1); // Normalize to [-1, 1] range
}

 
This function preprocesses an image in the format required by MobileNet. Here's a step-by-step explanation:

- Function Definition: The preprocesImage function is defined to take an image as an argument.
- Tensor Conversion: The Function converts the image to a tensor using tf.browser.fromPixels(image).
- Resize: It resizes the image tensor to [224, 224], which is the required input size for MobileNet.
- Float Conversion: The tensor is then converted to a float using .toFloat().
- Add Dimension: The tensor is expanded to include a batch dimension using .expandDims().
- Normalization: Finally, the tensor is normalized to a range of [-1, 1] by dividing by 127.5 and subtracting 1.

## Part 3: Loading the Image

### Function: loadImage

export function loadImage(file) {
 return new Promise((resolve, reject) =\> {
 const reader = new FileReader();
 reader.onload = (event) =\> {
 const img = new Image();
 img.src = event.target.result;
 img.onload = () =\> resolve(img);
 };
 reader.onerror = (error) =\> reject(error);
 reader.readAsDataURL(file);
 });
}

 
This Function loads an image file and returns an HTML Image element. Here's a step-by-step explanation:

- Function Definition: The loadImage function is defined as taking a file as an argument.
- Promise Creation: The Function returns a new Promise, which resolves with the loaded image or rejects with an error.
- FileReader: A FileReader Object is created to read the file.
- Reader onLoad: The onload event handler of the reader is defined. It creates a new Image Object sets its source to the file reader's result and resolves the promise with the image once it is loaded.
- Reader onError: The onerror event handler of the reader is defined to reject the promise with an error if one occurs. Read File: The file reader reads the file as a data URL using reader.readAsDataURL(file).
 
Now, you can test this final project by uploading images to the project's page and seeing the final results; if you have any problems, please check the provided link to clone the project from Github:  
[Github repository project](https://github.com/ivansing/ai-web-app?ref=hackernoon.com)

## Conclusion

This tutorial taught you how to build an AI-powered web application using Next.js and TensorFlow.js. We covered:

1. **Setting Up the Environment**: You installed Next.js and TensorFlow.js and set up your development environment.
2. **Creating the User Interface**: You made a simple UI for uploading images and displaying predictions.
3. **Integrating TensorFlow.js**: You integrated the MobileNet model to perform image classification directly in the browser.
 
By combining Next.js and TensorFlow.js, you can create sophisticated web applications that leverage the power of AI, enhancing user experiences with features like image recognition.

## Next Steps

To further improve your application, consider exploring these additional features:

- **Enhanced UI**: Improve the user interface with more advanced styling or additional features.
- **Additional Models**: Integrate other pre-trained models from TensorFlow.js or train your custom models.
- **Real-Time Data**: Implement real-time data processing and display for dynamic user interactions.

## Additional Resources

## About the Author

Ivan Duarte is a backend developer with experience working freelance. He is passionate about web development and artificial intelligence and enjoys sharing their knowledge through tutorials and articles. Follow me on [X](https://x.com/ldway27?ref=hackernoon.com), [Github](https://github.com/ivansing?ref=hackernoon.com), and [LinkedIn](https://www.linkedin.com/in/lance-dev/?ref=hackernoon.com) for more insights and updates.