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

## Features
The following lists the features available with Simple Camera. 
### Take Photo
To take a photo, use the takePhoto method which returns a completion handler with the photo as a Data type and indicates whether the photo was taken successfully or not. Make sure Simple Camera's capture mode is set to take photos to make this succeed.
```
simpleCamera.takePhoto { (data, success) in 
    if let data = data {
        if let image = UIImage(data: data) {
            print("got image \(image)")
        }
    }
}
```
### Take Videos
To take a video, use the takeVideo method which returns a completion handler with the video as a URL and indicates whether the video was taken successfully or not. Make sure Simple Camera's capture mode is set to take video to make this succeed.
```
simpleCamera.takeVideo { (videoPath, success) in 
    if let videoPath = videoPath {
        print("got video \(videoPath)")
    }
}
```
### Set Video Capture Mode
Use this to set Simple Camera to take videos. This is important in ensuring the correct presets are used by AVFoundation and of course taking videos will not succeed unless you correctly set the capture mode to videos. This method will return a Result type where success returns the new video camera settings and an error will return a VideoModeError.
```
simpleCamera.setVideoMode { (result) in 
    switch result {
        case .success(let newSettings):
            print("new torch mode setting is \(newSettings.torchMode.description)")
            print("new camera position setting is \(newSettings.position.description)")
        case .failure(let error):
            print("oops we got an error!")
    }
```
### Set Photo Capture Mode
Use this to set Simple Camera to take photos. This is important in ensuring the correct presets are used by AVFoundation and of course taking photos will not succeed unless you correctly set the capture mode to photos. This method will return a Result type where success returns the new photo camera settings and an error will return a PhotoModeError.
```
simpleCamera.setPhotoMode { (result) in 
    switch result {
        case .success(let newSettings):
            print("new torch mode setting is \(newSettings.flashMode.description)")
            print("new camera position setting is \(newSettings.position.description)")
        case .failure(let error):
            print("oops we got an error!")
    }
```
### Change to Front or Back Camera
You can use the toggleCamera method to toggle the camera automatically. The Result type will let you know the new position the camera is in.
```
simpleCamera.toggleCamera { (result) in
switch result {
case .success(let position):
print("new camera position is \(position.description)")
case .failure(let error):
print("there was an error \(error.description)")
}
```
You can also do this manually. Here is an example of setting the back camera which once again returns a Result type in a callback.
```
setCamera(position: .back) { (result) in

}
```
### Set Torch or Flash
Torch mode is best when taking videos in a dim or dark area. Flash mode is used for more or less the same but with photos. Torch mode is either on or off. Flash mode is auto, on or off. It is important you know the current capture mode before you attempt to change flash or torch mode. Here is an example.
```
let currentCaptureMode = simpleCamera.currentCaptureMode
switch currentCaptureMode {
    case .photo:
        toggleFlash()
    case .video:
        toggleTorch()
}    
```
Here is the full implementation of toggleFlash() to change the flash mode.
```
simpleCamera.toggleFlash { (result) in 
switch result {
case .success(let flashMode):
print("new flash mode is \(flashMode.description)")
case .failure(let error):
print("oops there was an error!!")
}
}
```
Here is the full implementation of toggleTorch() to change the torch mode.
```
simpleCamera.toggleTorch { (result) in 
switch result {
case .success(let torchMode):
print("new torch mode is \(torchMode.description)")
case .failure(let error):
print("oops there was an error!!")
}
}
```
You can also set the torch mode manually using the **setTorchMode(newTorchMode: SimpleCameraTorchMode)** method which take a *SimpleCameraTorchMode* type to indicate whether you want torch mode on or off. You can set the flash mode manually using the **setFlashMode(newFlashMode: SimpleCameraFlashMode)** which takes *SimpleCameraFlashMode* type which indicates whether you want flash mode on auto, on or off.
