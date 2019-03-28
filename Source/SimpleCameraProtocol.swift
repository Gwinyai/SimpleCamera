//
//  SimpleCameraProtocol.swift
//  SimpleCamera
//
//
/*
 
 MIT License
 
 Copyright (c) 2019 Gwinyai Nyatsoka
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import Foundation

import AVFoundation

typealias PhotoCompletionHandler = (_ data: Data?, _ success: Bool) -> Void

typealias VideoCompletionHandler = (_ url: URL?, _ sucess: Bool) -> Void

typealias SetVideoCompletionHandler = (Result<CameraSettings, VideoModeError>) -> Void

typealias SetPhotoCompletionHandler = (Result<CameraSettings, CameraPositionError>) -> Void

typealias SetCameraCompletionHandler = (Result<SimpleCameraPosition, CameraPositionError>) -> Void

typealias SetFlashCompletionHandler = (Result<SimpleCameraFlashMode, FlashError>) -> Void

typealias SetTorchCompletionHandler = (Result<SimpleCameraTorchMode, TorchError>) -> Void

typealias CameraSettings = (position: SimpleCameraPosition, flashMode: SimpleCameraFlashMode, torchMode: SimpleCameraTorchMode, captureMode: SimpleCameraCaptureMode)

enum VideoModeError: Error {
    
    case positionError(CameraPositionError), outputError
}

enum TorchError: Error {
    
    case notVideoMode, noActiveInput, torchNotSupported, unspecifiedError
}

enum FlashError: Error {
    
    case notCameraMode, noActiveInput, frontCameraPosition
    
}

enum CameraPositionError: Error, CustomStringConvertible {
    
    case noActiveInput, unknownCameraPosition, deviceInputError
    
    var description: String {
        
        switch self {
            
        case .noActiveInput:
            
            return "No active input"
            
        case .unknownCameraPosition:
            
            return "Unknown camera position"
            
        case .deviceInputError:
            
            return "Device input error"
            
        }
        
    }
    
}

enum SimpleCameraPosition: Int {
    
    case front, back, unspecified
    
    static func getValue(position: AVCaptureDevice.Position) -> SimpleCameraPosition {
        
        switch position {
            
        case .back:
            
            return SimpleCameraPosition.back
            
        case .front:
            
            return SimpleCameraPosition.front
            
        case .unspecified:
            
            return SimpleCameraPosition.unspecified
            
        @unknown default:
            
            return SimpleCameraPosition.unspecified
            
        }
        
    }
    
    var description: String {
        
    switch self {
        
        case .back:
            
            return "BACK"
        
        case .front:
            
            return "FRONT"
        
        case .unspecified:
            
            return "N/A"
        
        }
        
    }
    
}

enum SimpleCameraCaptureMode: Int {
    
    case photo = 1, video
    
    var description: String {
        
        switch self {
            
        case .photo:
            return "Photo"
            
        case .video:
            return "Video"
            
        }
        
    }
}

enum SimpleCameraFlashMode: Int {
    
    case off = 0, on, auto, na
    
    var description: String {
        
        switch self {
            
        case .off:
            return "OFF"
            
        case .on:
            return "ON"
            
        case .auto:
            return "AUTO"
            
        case .na:
            
            return "N/A"
            
        }
        
    }
    
}

enum SimpleCameraTorchMode: Int {
    
    case off = 0, on, na
    
    var description: String {
        
        switch self {
            
        case .off:
            return "OFF"
            
        case .on:
            return "ON"
            
        case .na:
            return "N/A"
            
        }
    }
    
}

protocol SimpleCameraProtocol {
    
    func startSession()
    
    func stopSession()
    
    func takePhoto(photoCompletionHandler: @escaping PhotoCompletionHandler)
    
    func takeVideo(videoCompletionHandler: @escaping VideoCompletionHandler)
    
    func toggleCamera(completion: @escaping SetCameraCompletionHandler)
    
    func toggleFlash(completion: @escaping SetFlashCompletionHandler)
    
    func toggleTorch(completion: @escaping SetTorchCompletionHandler)
    
    func setPhotoMode(completion: @escaping SetPhotoCompletionHandler)
    
    func setVideoMode(completion: @escaping SetVideoCompletionHandler)
    
}
