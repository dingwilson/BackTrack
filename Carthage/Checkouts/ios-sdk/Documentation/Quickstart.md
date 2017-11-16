#Quick Start Guide

This is a quick walkthrough to demonstrate how to create an iOS app that uses Watson's Text To Speech service to speak in English.

###Prerequisite

Before beginning to create the iOS application, make sure you set up a BlueMix application and create a Text To Speech service. First, sign up for a Bluemix account. Next, create a new Bluemix application, it can either be Node JS or Liberty application (it does not matter in this example since we will not be deploying any server-side code). Next, setup an instance of the Watson Text to Speech service for that application. When a service gets bound to a Bluemix application, new credentials are automatically generated for making calls to the service. These credentials will be used as part of this getting started guide, and can be found once the service is started by clicking on the “Show Credentials” link on the service. For more information about creating Bluemix applications and attaching Bluemix and Watson services read [Bluemix getting started](https://developer.ibm.com/bluemix/#gettingstarted).

In addition, this quick guide uses Carthage to fetch the Watson Developer Cloud iOS SDK and its dependencies. [Carthage](https://github.com/Carthage/Carthage) provides instruction for [Installing Carthage](https://github.com/Carthage/Carthage#installing-carthage).


###Create a Text to Speech App

1) Create a **"Single View App"** in Xcode and name it "WatsonSpeaks".

<img src="./Quickstart-Images/SingleViewapp.png" width="500">

2) Fill in the fields for Product Name, Organization Name, and Organization Identifier.  

<img src="./Quickstart-Images/WatsonSpeak.png" width="500">

3) Create a file called "Cartfile" in the root directory of your project and put the following inside the file:

```
# cartfile contents
github "watson-developer-cloud/ios-sdk"
```

<img src="./Quickstart-Images/cartfile.png" width="400">

4) Run `carthage update --platform iOS` from the command line at the root of the project. If you receive a compile then run the command again.

5) Create a new Group in your Xcode project called "Frameworks".

<img src="./Quickstart-Images/NewGroup.png" width="300">

6) Select all the .framework files in the `Carthage/Build/iOS/` directory of your project (Alamofire, RestKit, Freddy, TextToSpeechV1). Drag-and-drop those files from Finder into the new "Frameworks" group inside of your project in Xcode. When the dialog appears, **make sure** you deselect the option to copy items. This will create a reference to those Framework files without copying them.

<img src="./Quickstart-Images/frameworksInGroup.png" width="400">

7) In Xcode, select the "WatsonSpeaks" project then select its "WatsonSpeaks" build target. In the "Build Phases" tab, add a new **Copy Files Phase** and set its destination to "Frameworks".

<img src="./Quickstart-Images/BuildPhases.png" width="600">

8) Add all of the frameworks you added to Xcode to the Copy Files Phase.

<img src="./Quickstart-Images/AddedCopyFiles.png" width="600">

9) Add the following to your info.plist. In order to make network calls to Watson, we need to whitelist the URL to the watsonplatform.net server.

```xml
	<key>NSAppTransportSecurity</key>
	<dict>
		<key>NSExceptionDomains</key>
		<dict>
			<key>watsonplatform.net</key>
			<dict>
				<key>NSTemporaryExceptionRequiresForwardSecrecy</key>
				<false/>
				<key>NSIncludesSubdomains</key>
				<true/>
				<key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
				<true/>
				<key>NSTemporaryExceptionMinimumTLSVersion</key>
				<string>TLSv1.0</string>
			</dict>
		</dict>
	</dict>
```

<img src="./Quickstart-Images/plistPropertyList.png" width="600">

<img src="./Quickstart-Images/plistSource.png" width="600">

10) Open your ViewController class and add the following under the import of UIKit.

```swift
import UIKit
import TextToSpeechV1
import AVFoundation

```
11) Replace the code over the ***viewDidLoad*** function in the ViewController class:

```swift

    var player: AVAudioPlayer?

    // Do any additional setup after loading the view, typically from a nib.
    override func viewDidLoad() {

        super.viewDidLoad()

        let tts = TextToSpeech(username: "YOUR SERVICE USERNAME", password: "YOUR SERVICE PASSWORD")

        tts.synthesize("All the problems of the world could be settled easily if men were only willing to think.",
                       voice: SynthesisVoice.GB_Kate,
                       audioFormat: AudioFormat.WAV,
                       failure: { error in
                            print("error was generated \(error)")
                        }) { data in

                        do {
                            self.player = try AVAudioPlayer(data: data)
                            self.player!.play()
                        } catch {
                            print("Couldn't create player.")
                        }

        }
    }
```

<img src="./Quickstart-Images/viewDidLoad.png" width="500">

12) Update the initialization of `TextToSpeech` to use the credentials you obtained in the "Prerequisite" section above.

13) Run application in a Simulator, and you should hear speech coming from the speaker.

14) Enjoy!

You can review the different voices and languages [here](http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/doc/text-to-speech/using.shtml#voices).

You can download all the source code for the Watson Developer Cloud iOS SDK [here](https://github.com/watson-developer-cloud/ios-sdk).
