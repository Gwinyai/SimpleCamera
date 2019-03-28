//
//  CameraViewController.swift
//  ExampleSimpleCamera
//
/*
 
 MIT License
 
 Copyright (c) 2019 Gwinyai Nyatsoka
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

import UIKit

import AVFoundation

enum CapturedAsset {
    
    case photo(UIImage), video(URL)
    
}

class CameraViewController: UIViewController {
    
    var simpleCamera: SimpleCamera!
    
    var capturedAsset: CapturedAsset?
    
    @IBOutlet weak var recordingLabel: UILabel!
    
    @IBOutlet weak var videoModeButton: UIButton!
    
    @IBOutlet weak var photoModeButton: UIButton!
    
    @IBOutlet weak var cameraButton: UIView!
    
    @IBOutlet weak var flashButton: UIButton!
    
    @IBOutlet weak var positionButton: UIButton!
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    @IBOutlet weak var simpleCameraView: SimpleCameraView! {
        
        didSet {
            
            simpleCamera = SimpleCamera(cameraView: simpleCameraView)
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let buttonTap = UITapGestureRecognizer(target: self, action: #selector(cameraButtonDidTouch))
        
        cameraButton.addGestureRecognizer(buttonTap)
        
        cameraButton.isUserInteractionEnabled = true
        
        let thumbnailTap = UITapGestureRecognizer(target: self, action: #selector(thumbnailDidTouch))
        
        thumbnailImageView.addGestureRecognizer(thumbnailTap)
        
        thumbnailImageView.isUserInteractionEnabled = true
        
        setupCameraInitialUI()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        simpleCamera.startSession()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        simpleCamera.stopSession()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        cameraButton.layer.cornerRadius = cameraButton.frame.width / 2
        
    }
    
    private func setupCameraInitialUI() {
        
        recordingLabel.isHidden = true
        
        let currentSettings = simpleCamera.currentSettings
        
        flashButton.setTitle(currentSettings.torchMode.description, for: .normal)
        
        positionButton.setTitle(currentSettings.position.description, for: .normal)
        
        switch currentSettings.captureMode {
            
        case .photo:
            
            setPhotoCaptureButtonStyle()
            
        case .video:
            
            setVideoCaptureButtonStyle()
            
        }
        
    }
    
    //MARK: Toggle Torch Flash
    
    /*
    The toggleTorch function will set toggle to a new torch mode. This only works for video capture mode therefore we first check
     for the current capture mode in the flashButtonDidTouch function further below.
    */
    private func toggleTorch() {
        
        simpleCamera.toggleTorch { [weak self] (result) in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let torchMode):
                
                strongSelf.flashButton.setTitle(torchMode.description, for: .normal)
                
            case .failure(let error):
                
                strongSelf.presentError(title: "Error", message: "Could not set torch mode")
                
                print(error.localizedDescription)
                
            }
            
        }
        
    }
    
    
    /*
     The toggleFlash function will set toggle to a new flash mode. This only works for photo capture mode therefore we first check
     for the current capture mode in the flashButtonDidTouch function further below.
     */
    private func toggleFlash() {
        
        simpleCamera.toggleFlash { [weak self] (result) in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let flashMode):
                
                strongSelf.flashButton.setTitle(flashMode.description, for: .normal)
                
            case .failure(let error):
                
                strongSelf.presentError(title: "Error", message: "Could not set flash mode")
                
                print(error.localizedDescription)
                
            }
            
        }
        
    }
    
    //MARK:- Set Capture Button Style
    
    //This function sets a custom capture button style when the capture mode is video
    private func setVideoCaptureButtonStyle() {
        
        cameraButton.layer.borderWidth = CGFloat(0)
        
        cameraButton.backgroundColor = UIColor.red
        
        cameraButton.layer.borderColor = UIColor.black.cgColor
        
        videoModeButton.setTitleColor(UIColor.gray, for: .normal)
        
        photoModeButton.setTitleColor(UIColor.white, for: .normal)
        
    }
    
    //This function sets a custom capture button style when the capture mode is photo
    private func setPhotoCaptureButtonStyle() {
        
        cameraButton.backgroundColor = UIColor.clear
        
        cameraButton.layer.borderWidth = CGFloat(10.0)
        
        cameraButton.layer.borderColor = UIColor.black.cgColor
        
        videoModeButton.setTitleColor(UIColor.white, for: .normal)
        
        photoModeButton.setTitleColor(UIColor.gray, for: .normal)
        
    }
    
    //MARK:- Capture Video or Photo
    
    @objc func cameraButtonDidTouch() {
        
        switch simpleCamera.currentCaptureMode {
            
        case .video:
            
            recordingLabel.isHidden = false
            
            simpleCamera.takeVideo { [weak self] (videoPath, success) in
                
                guard let strongSelf = self else { return }
                
                strongSelf.recordingLabel.isHidden = true
                
                if success {
                    
                    if let videoPath = videoPath {
                    
                        if let thumbnail = strongSelf.createVideoThumbnail(path: videoPath) {
                            
                            strongSelf.thumbnailImageView.image = thumbnail
                            
                        }
                        
                        strongSelf.capturedAsset = CapturedAsset.video(videoPath)
                        
                    }
                    
                }
                else {
                    
                    print("not successful")
                    
                }
                
            }
            
        case .photo:
            
            simpleCamera.takePhoto { [weak self] (data, success) in
                
                guard let strongSelf = self else { return }
                
                if success {
                    
                    if let data = data {
                        
                        if let image = UIImage(data: data) {
                        
                            strongSelf.thumbnailImageView.image = image
                            
                            strongSelf.capturedAsset = CapturedAsset.photo(image)
                            
                        }
                        
                    }
                    
                }
                else {
                    
                    print("not successful")
                    
                }
                
            }
            
        }
        
    }
    
    //MARK:- Thumbnail Did Touch
    
    @objc func thumbnailDidTouch() {
        
        guard let capturedAsset = capturedAsset else {
            
            presentError(title: "Error", message: "No photo or video captured yet!")
            
            return
            
        }
        
        switch capturedAsset {
            
        case .photo(let image):
            
            performSegue(withIdentifier: "RevealImageSegue", sender: image)
            
            break
            
        case .video(let url):
            
            performSegue(withIdentifier: "RevealVideoSegue", sender: url)
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "RevealImageSegue" {
            
            guard let photo = sender as? UIImage else { return }
            
            let destinationVC = segue.destination as! PhotoViewController
            
            destinationVC.photo = photo
            
        }
        else if segue.identifier == "RevealVideoSegue" {
            
            guard let videoURL = sender as? URL else { return }
            
            let destinationVC = segue.destination as! VideoViewController
            
            destinationVC.videoURL = videoURL
            
        }
        
    }
    
    //MARK:- Change Camera Position
    
    @IBAction func cameraPositionButtonDidTouch(_ sender: Any) {
        
        simpleCamera.toggleCamera { [weak self] (result) in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let position):
                
                strongSelf.positionButton.setTitle(position.description, for: .normal)
                
            case .failure(let error):
                
                strongSelf.presentError(title: "Error", message: "Could not change camera position")
                
                print(error.description)
                
                return
                
            }
            
        }
        
    }
    
    //MARK:- Toggle Flash or Torch
    
    @IBAction func flashButtonDidTouch(_ sender: Any) {
        
        let currentCaptureMode = simpleCamera.currentCaptureMode
        
        switch currentCaptureMode {
            
        case .photo:
            
            toggleFlash()
            
        case .video:
            
            toggleTorch()
            
        }
        
    }
    
    //MARK:- Set Video or Photo mode
    
    @IBAction func setVideoButtonDidTouch(_ sender: Any) {
        
        simpleCamera.setVideoMode { [weak self] (result) in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let newSettings):
                
                strongSelf.setVideoCaptureButtonStyle()
                
                strongSelf.flashButton.setTitle(newSettings.torchMode.description, for: .normal)
                
                strongSelf.positionButton.setTitle(newSettings.position.description, for: .normal)
                
            case .failure(let error):
                
                strongSelf.presentError(title: "Error", message: "Could not set video camera")
                
                print(error.localizedDescription)
                
            }
            
        }
        
    }
    
    @IBAction func setPhotoButtonDidTouch(_ sender: Any) {
        
        simpleCamera.setPhotoMode { [weak self] (result) in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let newSettings):
                
                strongSelf.setPhotoCaptureButtonStyle()
                
                strongSelf.flashButton.setTitle(newSettings.flashMode.description, for: .normal)
                
                strongSelf.positionButton.setTitle(newSettings.position.description, for: .normal)
                
            case .failure(let error):
                
                strongSelf.presentError(title: "Error", message: "Could not set photo camera")
                
                print(error.localizedDescription)
                
            }
            
        }
        
    }

}

//MARK:- Extension to Present Error

extension CameraViewController {
    
    func presentError(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            alert.dismiss(animated: true, completion: nil)
            
        })
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func createVideoThumbnail(path: URL) -> UIImage? {
        
        let asset = AVURLAsset(url: path)
        
        let generator = AVAssetImageGenerator(asset: asset)
        
        generator.appliesPreferredTrackTransform = true
        
        let timestamp = CMTime(seconds: 2, preferredTimescale: 60)
        
        if let imageRef = try? generator.copyCGImage(at: timestamp, actualTime: nil) {
            
            return UIImage(cgImage: imageRef)
            
        } else {
            
            return nil
            
        }
        
    }
    
}
