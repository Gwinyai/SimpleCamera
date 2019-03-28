# Simple Camera
Simple Camera makes it easy to add video and photo capabilites to your iOS app. It also supports flash, torch, front and back camera features.

## Installation
Refer to the Example Simple Camera project for an additional example of how to setup Simple Camera.

1. Add the files from the Source folder into your project (or add the Source folder as it is). There are three files in the Source folder which should all be present. These files are named SimpleCamera.swift, **SimpleCameraProtocol.swift** and **SimpleCameraView.swift**.
2. Navigate to your **info.plist** and add the *Privacy - Camera Usage Description* and *Privacy - Microphone Usage Description* permissions. 
3. Add a UIView to your view controller to act as the camera view. Change the class of the UIView to SimpleCameraView. Make sure you have a reference to your UIView and let's say you call it simpleCameraView. If you do this through Storyboard then it is simply an @IBOutlet:
```
@IBOutlet weak var simpleCameraView: SimpleCameraView!
```
4. Create a strong reference variable to the class SimpleCamera at the top of your view controller as follows:
```
var simpleCamera: SimpleCamera!
```
5. Create an instance of SimpleCamera and pass a reference to your SimpleCameraView as a dependency. You should prefereably do this in your viewDidLoad.
```
simpleCamera = SimpleCamera(cameraView: simpleCameraView)
```
6. In your viewDidAppear, start a session of Simple Camera.
```
simpleCamera.startSession()
```
7. In your viewWillDisappear, end your Simple Camera session.
```
simpleCamera.stopSession()
```
8. You are all set!!!

