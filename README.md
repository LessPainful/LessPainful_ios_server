This guide explains how to setup and use LessPainful for iOS.
=============================================================

After completing this guide you will be able to run
tests locally against the iOS Simulator. You can also
interactively explore your applications using the Ruby
irb console.

Finally you will be able to build your application using special "test
target" and run that on real iOS devices via
[the LessPainful service](http://www.lesspainful.com/).

This guide takes approximately 10-15 minutes to complete.

Installing the client.
----------------------

### Prerequisites

You should have installed the LessPainful-ios-client from Github:

(https://github.com/LessPainful/LessPainful_ios_client)

If you haven't go ahead and do that now.

Preparing your application.
---------------------------

To use LessPainful for iOS with your app, you must create a new target
for your app. This target links with a couple of frameworks, as
described here.

*Note*: it is important that you create a separate target as a copy the target you usually use when distributing you app to your users. Don't link with our framework in your production app - this may cause app rejection by Apple since we are using private APIs.


* Duplicate target.
 - Select your project in XCode and select your target for your app.
 - Right click (two-finger tap) your target and select "Duplicate target"
 - Select "Duplicate only" (no transition to iPad)
 - Rename your new target from ".. copy" to "..-LP"
 - From the menu select Edit Scheme and select manage schemes.
 - Rename the Scheme from ".. copy" to "..-LP"

* Target Build Settings
 - Click on your project and select your new "-LP" target.
 - Select "Build Settings".
 - Ensure that "All" and not "Basic" settings are selected in "build settings".
 - Find "Other Linker Flags" (you can type other link in the search field).
 - Ensure that "Other linker flags" contains: -all_load -lstdc++

This screenshot is a reference for you build settings.

![Build settings](example-2.png "Build settings")

### Linking the test target with Frameworks:

Open your application project and the LPSimpleExample sample project in Xcode. Expand the Frameworks folder in both projects.

You must link with the frameworks listed below. The easiest way is to simply drag the frameworks from the LPSimpleExample project to your Frameworks folder. Notice that our framework is named `"server.framework"` and not iLessPainfulServer.framework, as in the graphical example.

Select only the frameworks illustrated below, and make sure that (i) `Copy items into destination group's folder (if needed)` is not checked and (ii) only your "-LP "
 target is checked in `Add to targets`

![Build settings](example-3.png "Linking with frameworks")

![Build settings](example-4.png "Options")


### Try it out!

Make sure you select your "..-LP" scheme and then run you app on 4.x/5
iPhone simulator.

Verify that you see console output like

    2011-11-14 21:20:00.699 Example copy[12296:18203] Creating the server: <HTTPServer: 0x8995850>
    2011-11-14 21:20:00:703 Example copy[12296:18203] HTTPServer: Started HTTP server on port 37265
    2011-11-14 21:20:01:354 Example copy[12296:1a703] Bonjour Service Published: domain(local.) type(_http._tcp.) name(iLessPainful Server)


You should now be able to explore your application by installing the client as described below.

If you are having problems don't waste time! Contact `karl@lesspainful.com` ASAP :)



License
=======
LessPainful-ios-server
Copyright (c) Karl Krukow. All rights reserved.
The use and distribution terms for this software are covered by the
Eclipse Public License 1.0 (http://opensource.org/licenses/eclipse-1.0.php)
which can be found in the file epl-v10.html at the root of this distribution.
By using this software in any fashion, you are agreeing to be bound by
the terms of this license.
You must not remove this notice, or any other, from this software.
