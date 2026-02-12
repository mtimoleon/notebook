---
categories:
  - "[[Work]]"
  - "[[Documentation]]"
tags:
  - intelligen
  - gantt
---

Clipped from: [https://medium.com/stackanatomy/the-ultimate-guide-to-getting-started-with-the-rollup-js-javascript-bundler-2ebec9398656](https://medium.com/stackanatomy/the-ultimate-guide-to-getting-started-with-the-rollup-js-javascript-bundler-2ebec9398656)

![Exported image](Exported%20image%2020260209140138-0.jpeg)

[Rollup.js](https://rollupjs.org/) is a Node.js module bundler most often used for client-side JavaScript running in the browser. (You can bundle Node.js scripts but there are fewer reasons to do so). The tool compiles all your JavaScript source files into a single bundle for inclusion in your production web pages.  
The benefits of using Rollup.js include:

1. You can develop JavaScript in smaller self-contained files which have specific responsibilities. The project becomes easier to understand and maintain.
2. It includes a watch option which re-runs bundling whenever you make a change to a source file.
3. Rollup.js can verify source code (linting), restructure layout (prettify), and make other syntax checks.
4. Unused functions are automatically removed using _tree-shaking_ methods which reduce file sizes and improve performance.
5. More than one bundle can be output from the same source files, such as an ES6 edition using modules, an ES5 edition for older browsers, a CommonJS edition for Node.js, etc.
6. The final production bundle can have whitespace and logging removed to minify the file size.

Rollup.js has some competition with build tools such as [webpack](https://webpack.js.org/), [Snowpack](https://www.snowpack.dev/), and [Parcel](https://parceljs.org/). As well as JavaScript module bundling, these can handle other aspects of your site such as HTML templates, CSS preprocessing, and image optimization. The downside is they can be more difficult to configure if you have custom requirements.  
Rollup.js primarily concentrates on JavaScript so it’s fast and lightweight. It’s easy to get started but you’ll discover plugins for HTML, CSS, images, and other options as you become familiar with the tool. Let’s get started…

# Rollup.js Installation

Rollup.js requires Node.js v8.0.0 or above. You can install it globally by running:  
npm install rollup --global  
You can then execute the rollup command from any project directory.  
You can also install Rollup.js in a Node.js project folder using:  
npm install rollup --save-dev  
This manages the installation in npm’s package.json file to ensure all developers on your team are using the same version to avoid compatibility issues. You can run Rollup.js with npx rollup or add commands to the "scripts" section of package.json, e.g.  
"scripts": {  
"rollup:help": "rollup --help"  
},  
Execute a script with npm run \<scriptname\>, e.g. npm run rollup:help.  
The examples below use npx rollup since it will work regardless of whether you install rollup locally or globally.

# First Use

Create a project folder with a src sub-folder and add the following files:  
Library functions in **src/a.js**:  
export function hello() {  
console.log('hello from a.js');  
}export function goodbye() {  
console.log('goodbye from a.js');  
}  
Library functions in **src/b.js**:  
export function hello() {  
console.log('hello from b.js');  
}export function goodbye() {  
console.log('goodbye from b.js');  
}  
Main script entry point at **src/main.js**:  
import * as a from './a.js';  
import * as b from './b.js';a.hello();  
b.goodbye();  
Now run Rollup.js to bundle the source files into a single ES6 file:  
npx rollup ./src/main.js --file ./build/bundle.js --format es  
The resulting **build/bundle.js** file contains:  
function hello() {  
console.log('hello from a.js');  
}function goodbye() {  
console.log('goodbye from b.js');  
}hello();  
goodbye();  
All your code is now contained in single file and the tool removes unused functions. You could load it from an HTML file using:  
\<script type="module" src="./build/bundle.js"\>\</script\>  
In this case, the bundled \<script\> would also work in older browsers such as IE11 if you remove the type="module" attribute. Add a defer attribute or place it before the closing \</body\> to ensure the script runs when the DOM has loaded.  
Try editing and add a call to the a.goodbye() function:  
import * as a from './a.js';  
import * as b from './b.js';a.hello();  
a.goodbye();  
b.goodbye();  
Bundle again with the command:  
npx rollup ./src/main.js --file ./build/bundle.js --format es  
Or add another "scripts" entry to package.json such as:  
"scripts": {  
"rollup:help": "rollup --help",  
"rollup:es": "rollup ./src/main.js --file ./build/bundle.js --format es"  
},  
and run with npm run rollup:es.  
The resulting **build/bundle.js** file contains an additional renamed function which avoid any conflicts:  
function hello() {  
console.log('hello from a.js');  
}function goodbye$1() {  
console.log('goodbye from a.js');  
}function goodbye() {  
console.log('goodbye from b.js');  
}hello();  
goodbye$1();  
goodbye();

# Rollup.js Options and Flags

The example above introduces the basic Rollup.js [command-line options](https://rollupjs.org/guide/en/#command-line-flags). The most-used are:

- --version (or -v): display the Rollup.js version number
- --input \<filename\> (or -i): specify the entry script. This is not necessary because the file is usually defined as the first option.
- --file \<output\> (or -o): the bundled file name. When omitted, the bundle is output to stdout.
- --format \<type\> (or -f): the JavaScript bundle format:  
    iifeoutput an Immediately Invoked Function Expression (function () { ... }());  
    esstandard ES6  
    cjsCommonJS for Node.js  
    umd[Universal Module Definition](https://github.com/umdjs/umd)￼amd[Asynchronous Module Definition](https://github.com/amdjs)￼system[SystemJS modules](https://github.com/systemjs/systemjs)
- If in doubt, use es6. iife may be practical if you need to support older browsers which do not support modules.
- --environment \<values\>: set one or more comma-separated environment variables, e.g. --environment NODE_ENV:development,VAR1,VAR2:abc which sets NODE_ENV to development, VAR1 to true, and VAR2 to abc.
- --sourcemap: create a source map so you can reference the original source files in browser DevTools. The bundled file will link to a .map file in build folder, e.g. build/bundle.js.map.
- Use --sourcemap inline to define an inline source map within the bundle.
- --watch (or -w): watch for source file changes during development and bundle automatically.
- The screen clears when a change triggers a re-build but you can disable this with --no-watch.clearScreen
- --silent: do not output warnings.

# Rollup.js Configuration Files

Commands can become cumbersome when adding options and flags. A Rollup.js [configuration file](https://rollupjs.org/guide/en/#configuration-files) is a better alternative:

1. it’s easier to read and edit
2. you can define more than one bundle process, and
3. the configuration file is an ES6 module which can execute other functionality. For example, you can conditionally process development or production builds according to the environment where Rollup.js runs.

The default configuration file name is rollup.config.js. Create this file in the root of your project folder and add the following code to replicate the input, output, and formatting options used above:  
// rollup.config.js  
export default [  
{ input: './src/main.js', output: {  
file: './build/bundle.js',  
format: 'es'  
} }  
];  
Set the Rollup.js --config (or -c) flag to use this configuration file:  
npx rollup --config  
You can also pass a filename if you want to move or rename the configuration file, e.g.  
npx rollup --config ./rollup/config1.js  
The configuration above exports an array with a single object which defines one bundle process. An array isn’t necessary for one object but it allows you to define further processes later, e.g.  
// rollup.config.js  
export default [ // ES6 bundle  
{ input: './src/main.js', output: {  
file: './build/bundle.js',  
format: 'es'  
} }, // IIFE bundle  
{ input: './src/main.js', output: {  
file: './build/bundle-iife.js',  
format: 'iife'  
} }  
];

# Automated Watch Bundling

You can add a watch option to the configuration file to define which files trigger the bundling process when changed:  
// rollup.config.js  
export default [  
{ input: './src/main.js', watch: {  
include: './src/**',  
clearScreen: false  
}, output: {  
file: './build/bundle.js',  
format: 'es'  
} }  
];  
Note that you must still use a --watch flag on the command line:  
npx rollup --config --watch

# Creating Development and Production Builds

You will want to enable logging commands and source maps during development but omit these options when deploying to a production server. The configuration file code can updated to detect environment variable values and bundle differently.  
The following configuration examines the NODE_ENV environment variable and adds an inline source map to the bundle when it's set to development:  
// rollup.config.js  
const devMode = (process.env.NODE_ENV === 'development');  
console.log(`${ devMode ? 'development' : 'production' } mode bundle`);export default [  
{ input: './src/main.js', output: {  
file: './build/bundle.js',  
format: 'es',  
sourcemap: devMode ? 'inline' : false  
} }  
];  
Run the Rollup.js command with the environment variable set accordingly:  
npx rollup --config --environment NODE_ENV:development  
You can also set the NODE_ENV for the current session on mac OS and Linux:  
NODE_ENV=development  
the Windows cmd prompt:  
set NODE_ENV=development  
or Windows Powershell:  
$env:NODE_ENV="development"

# Rollup.js Plugins

You can extend the basic Rollup.js bundling functionality using any number of [plugins](https://github.com/rollup/awesome). Use npm to install plugins locally or globally then reference them in your Rollup. js configuration file.  
The following sections describe a selection of popular plugins but you can also [create your own plugin](https://rollupjs.org/guide/en/#plugin-development) in the unlikely event that you cannot find an appropriate option.

# Minify Production Bundles

[Terser](https://terser.org/) can reduce bundle file sizes by removing whitespace, comments, logging commands, and other unnecessary code. Install the Rollup.js [Terser plugin](https://github.com/TrySound/rollup-plugin-terser) locally:  
npm install rollup-plugin-terser --save-dev  
then import it into your rollup.config.js file and add a plugins array definition to the output object (Terser is an output plugin which runs after Rollup.js has completed other bundling tasks):  
// rollup.config.js  
import { terser } from 'rollup-plugin-terser';const devMode = (process.env.NODE_ENV === 'development');  
console.log(`${ devMode ? 'development' : 'production' } mode bundle`);export default [  
{ input: './src/main.js', output: {  
file: './build/bundle.js',  
format: 'es',  
sourcemap: devMode ? 'inline' : false,  
plugins: [  
terser({  
ecma: 2020,  
mangle: { toplevel: true },  
compress: {  
module: true,  
toplevel: true,  
unsafe_arrows: true,  
drop_console: !devMode,  
drop_debugger: !devMode  
},  
output: { quote_style: 1 }  
})  
]  
} }  
];  
Run a development build with:  
npx rollup --config --environment NODE_ENV:development  
and the resulting ./build/bundle.js file contains:  
console.log('hello from a.js'),console.log('goodbye from a.js'),console.log('goodbye from b.js');  
//# sourceMappingURL=data:application/json;charset=utf-8;base64,...  
_A production build results in an empty file because Terser removes all the logging statements!_  
Refer to the [Terser documentation](https://github.com/terser/terser) to configure your own project options.

# Replace Values at Bundle Time

The Rollup.js [replace plugin](https://github.com/rollup/plugins/tree/master/packages/replace) allows you to define configuration variables at bundle time which become hard-coded in the bundled script. Install it locally:  
npm install [@rollup/plugin-replace](http://twitter.com/rollup/plugin-replace) --save-dev  
then import it into your rollup.config.js file and add a plugins array with the following settings:  
// rollup.config.js  
import replace from '[@rollup/plugin-replace](http://twitter.com/rollup/plugin-replace)';const devMode = (process.env.NODE_ENV === 'development');  
console.log(`${ devMode ? 'development' : 'production' } mode bundle`);export default [  
{ input: './src/main.js', plugins: [  
replace({  
values: {  
__HELLO__: 'Hi there',  
__GOODBYE__: 'Bye'  
}  
})  
], output: {  
file: './build/bundle.js',  
format: 'es',  
sourcemap: devMode ? 'inline' : false  
} }  
];  
Add __HELLO__ and __GOODBYE__ tokens anywhere in your scripts such as:  
export function hello() {  
console.log('__HELLO__ from a.js');  
}export function goodbye() {  
console.log('__GOODBYE__ from a.js');  
}  
Run a development build with:  
npx rollup --config --environment NODE_ENV:development  
and the resulting ./build/bundle.js file now contains:  
function hello() {  
console.log('Hi there from a.js');  
}function goodbye$1() {  
console.log('Bye from a.js');  
}function goodbye() {  
console.log('goodbye from b.js');  
}

# Import npm CommonJS Modules

JavaScript libraries are often packaged as CommonJS modules which you can install with npm. Rollup.js can parse CommonJS with the following plugins:

1. [node-resolve](https://github.com/rollup/plugins/tree/master/packages/node-resolve) locates a module in the project's node_modules directory, and
2. [plugin-commonjs](https://github.com/rollup/plugins/tree/master/packages/commonjs) converts CommonJS to ES6 modules.

Install them in your project:  
npm install [@rollup/plugin-node-resolve](http://twitter.com/rollup/plugin-node-resolve) [@rollup/plugin-commonjs](http://twitter.com/rollup/plugin-commonjs) --save-dev  
then import them into your rollup.config.js file and update the plugins array:  
// rollup.config.js  
import { nodeResolve } from '[@rollup/plugin-node-resolve](http://twitter.com/rollup/plugin-node-resolve)';  
import commonjs from '[@rollup/plugin-commonjs](http://twitter.com/rollup/plugin-commonjs)';const devMode = (process.env.NODE_ENV === 'development');  
console.log(`${ devMode ? 'development' : 'production' } mode bundle`);export default [  
{ input: './src/main.js', plugins: [  
nodeResolve(),  
commonjs()  
], output: {  
file: './build/bundle.js',  
format: 'es'  
} }  
];  
Install an example CommonJS library such as [Lodash](https://lodash.com/):  
npm install lodash --save-dev  
and use one of its methods — such as capitalize() in :  
import * as _ from 'lodash/string';export function hello() {  
console.log(_.capitalize('hello from a.js '));  
}  
Run a development build with:  
npx rollup --config --environment NODE_ENV:development  
and examine the bundled code. The Lodash library appears at the top.  
_Be aware that Rollup.js cannot tree-shake Lodash because it exports a single object with multiple methods. Most JavaScript libraries use a similar structure but the situation should improve as more developers adopt ES6 modules._

# Open Source Session Replay

Debugging a web application in production may be challenging and time-consuming. [OpenReplay](https://github.com/openreplay/openreplay) is an Open-source alternative to FullStory, LogRocket and Hotjar. It allows you to monitor and replay everything your users do and shows how your app behaves for every issue. It’s like having your browser’s inspector open while looking over your user’s shoulder. OpenReplay is the only open-source alternative currently available.

![SSO Sr sruns vtt6](Exported%20image%2020260209140139-1.png)

Happy debugging, for modern frontend teams — [Start monitoring your web app for free](https://github.com/openreplay/openreplay).

# Transpile ES6 to ES5 Using Babel

ES6 syntax result in more concise code. For example, you could use arrow function expressions in **src/a.js**:  
const hello = () =\> {  
console.log('hello from a.js ');  
};const goodbye = () =\> {  
console.log('goodbye from a.js');  
};export { hello, goodbye };  
The resulting bundle will run in all modern browsers but fail in legacy applications such as Internet Explorer 11 and below. This may not be of concern: IE11 has a minimal market share and those users can still see content if your site functions reasonably well without JavaScript.  
You can transpile your code to ES5 using [Babel](https://babeljs.io/) if you’re unfortunate enough to have a reasonably high number of IE11 users. The resulting code _should_ work in any browser (although you may still require Polyfills to add missing functionality in IE11).  
Bundling two files from the same source is a better option. You can produce a small ES6 version loaded by all browsers which support ES modules and a larger ES5 fallback version for older browsers.  
Install Babel locally:  
npm install [@rollup/plugin-babel](http://twitter.com/rollup/plugin-babel) [@babel/core](http://twitter.com/babel/core) [@babel/preset-env](http://twitter.com/babel/preset-env) --save-dev  
then import it into your rollup.config.js file and add an ES5 bundle configuration to the exported array:  
// rollup.config.js  
import { getBabelOutputPlugin } from '[@rollup/plugin-babel](http://twitter.com/rollup/plugin-babel)';const devMode = (process.env.NODE_ENV === 'development');  
console.log(`${ devMode ? 'development' : 'production' } mode bundle`);export default [  
{  
// ES6  
input: './src/main.js', output: {  
file: './build/bundle.js',  
format: 'es'  
} },  
{  
// ES5  
input: './src/main.js', plugins: [  
getBabelOutputPlugin({  
presets: ['[@babel/preset-env](http://twitter.com/babel/preset-env)']  
})  
], output: {  
file: './build/bundle-es5.js',  
format: 'cjs'  
} }  
];  
Run a development build with:  
npx rollup --config --environment NODE_ENV:development  
to create two bundle files. **build/bundle.js** contains ES6-compatible code:  
const hello = () =\> {  
console.log('hello from a.js ');  
};const goodbye$1 = () =\> {  
console.log('goodbye from a.js');  
};function goodbye() {  
console.log('goodbye from b.js');  
}hello();  
goodbye$1();  
goodbye();  
and **build/bundle-es5.js** contains ES5-compatible code:  
'use strict';var hello = function hello() {  
console.log('hello from a.js ');  
};var goodbye$1 = function goodbye$1() {  
console.log('goodbye from a.js');  
};function goodbye() {  
console.log('goodbye from b.js');  
}hello();  
goodbye$1();  
goodbye();  
Reference both scripts in any HTML file:  
\<script type="module" src="./build/bundle.js"\>\</script\>  
\<script nomodule src="./build/bundle-es5.js" defer\>\</script\>  
Modern browsers will load and run the ES6 module contained in ./build/bundle.js. Older browsers will load and run the ES5 script contained in ./build/bundle-es5.js. In both cases, the scripts will run when the DOM is ready - that is the default for ES6 and a the defer attribute enables it in ES5.

# Rolling Your Own

Rollup.js requires a little more initial effort than build tools such as Webpack and Parcel but ongoing configuration is easier and more flexible. Your resulting bundles should be smaller and faster.  
For more information, refer to the [Rollupjs.org website](https://rollupjs.org/). The [big list of Rollup.js options](https://rollupjs.org/guide/en/#big-list-of-options) describes all the command line switches and you can browse the [awesome list of Rollup.js plugins](https://github.com/rollup/awesome). You’ll find dozens of plugins for building and optimizing HTML, CSS, files, images, TypeScript, data URIs, code quality, and more. You can also integrate Rollup.js with Deno, Grunt, Gulp, React, Angular, Vue, and Svelte projects. I recommend you keep your configuration simple at first then add further configuration options as your knowledge of Rollup.js grows.