## So what is this
MarvinCpp is a project that is aimed at being a man-in-the-middle proxy. Another attempt at a __Charles__ equivalent.

Unlike __marvin__. This one is more ambitious and is written in C++ using BOOST/ASIO with the intent that eventually it will hook into a front end in Obj-C or Swift and provide a fully compiled native OSX replacement for Charles.

Circumstances have forced me to suspend work on this project for the moment - life and other projects happen. But at the point in time that I stopped this was working but without a GUI interface. IIt simply streams traffic to a terminal session in raw text.

## major steps
<!-- this is an html comment -->

-	tunnel
-	ui - like this [example - https://www.raywenderlich.com/123463/nsoutlineview-macos-tutorial](https://www.raywenderlich.com/123463/nsoutlineview-macos-tutorial)
## TODO

-	need to do something easy for config options
### need test harness
### message body
-	clean up how message bodies are handled and how EOF is handled by readers
-	request does not handle body correctly and forwardingHandler probably copies the body too many times. Need a review of how body content is being managed. 
-	line 345 MessageReader::onBody - need an efficient way of collectin the body data

### design issue
-	some kind of "data base" for collected exchanges so GUI can display them
-	how to do edit/replay of echanges, does this imply tight coupling between mitmproxy and GUI or a command interface to the proxy

### development steps
-	package up request/response for transmission to GUI
-	select the media types for which we will collect the body data
-	de-compress the body data of those media types 

### others
-	read timeouts
-	how to pass preferences/options to the proxy so that they can be updated during execution
-	set sensible buffer sizes
-	need to have some better method of handling header keys that simply literals
-	related to body - Request needs for interface routines to manage start/end of message and streaming body data
-	document the code using headerdocs syntax
-	finish and test a stand alonehttps server
-	fix the signal handling in server - does not close down the accept call
-	do I need signal handling in the client??
-	test including a Cocoa call (run on thread?) for future connection to a Cocoa app. How to send intercepted messages to cocoa app
-	multi thread support
	-	strand in server
	-	strand in request/connection pool
	-	limit number of accepts, like request have a count and wait if count exceeded
-	review code to see that callbacks are posted not called
-	review code to isolate boost and io_service into a replaceable layer
-	proxy handler, build
	-	how to handle connect??
	-	how to handle connect when we decide not to tunnel. Will need some form of  https server> Do we use a slave https server like in the nodejs version or can we convert the main server to https for this client. If the latter - how to convert server to TLS, slave server or take over existing connection.
-	certificate server in c/c++
-	upgrade request to stream the body


## Notes of folder structure
These are the folders you can see when you look at the project through __finder__.

	-	all
	-	deps
		-	include
		-	lib
	-	experiments
	-	external_src
	-	include
	-	packages
	-	src
	
Here is the explanation:

__all__, contains a simple target that has all other important targets as prerequisites and hence building 'all' builds all the targets of usual interest 

__deps__, contains the public __include__ and __lib__ for external C++ and C libraries that are (or a version is) specific to this project. IN this case __boost__.

__experiments__, a series of targets that build executables that I have used for experiments of component testing.

__external_src__, source files that come from various repos that I have found convenient to use.

__include__, contains the `.h`, `.hpp`, `.ipp` and perhaps some `.cpp` files for this project that are either standalione header files (that do not have a matching `.cpp` file), or define a template class. Note `.ipp` files are the implementation parts of templates and hence are like `.cpp` but must be included inside their corresponding `.hpp`.

__src__, contains C++ source code and includes that go with an `.cpp`.

__collector__, a sub folder of source contains various "collector" classes. These are the vehicle by which the monitoring process is delivers output. Have two implementations to date. On for `objc/cocoa` and another that delivers output to a named pipe. 

__objc__, contains `objc++` code for wrappers that enable us to use __Marvin__ in a cocoa app

__packages__, this is a folder where the `makefile` clones git repos that are used as external components in this project. Once `cloned` into this folder the necessary source files are copied (by the makefile) into __external_src__. 