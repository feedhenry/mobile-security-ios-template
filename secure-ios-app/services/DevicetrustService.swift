//
//  DevicetrustService.swift
//  secure-ios-app
//
//  Created by Tom Jackman on 30/11/2017.
//  Copyright © 2017 Wei Li. All rights reserved.
//

import Foundation
import LocalAuthentication

protocol DeviceTrustService {
    func performChecks()
}

class iosDeviceTrustService: DeviceTrustService {
    
    var detections: [Detector]
    let DETECTION_DEVICE_LOCK = "Device Lock Set"
    
    
    init() {
        self.detections = []
    }
    
    func performChecks() {
        
    }
    
    fileprivate func detectDeviceLock() {
        
        if #available(iOS 9.0, *) {
            let deviceLockSet = LAContext().canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
            if deviceLockSet == false {
                addDetection(name: DETECTION_DEVICE_LOCK, detected: true)
            }
        }
    }
    
    fileprivate func detectJailbreak() {
        
    }
    
    fileprivate func detectFsEncryption() {
        
    }
    
    fileprivate func addDetection(name: String, detected: Bool) {
        let detector = Detector(name: name, detected: detected)
        self.detections.append(detector)
    }

}

