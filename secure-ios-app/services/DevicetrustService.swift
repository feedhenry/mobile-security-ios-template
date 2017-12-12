//
//  DevicetrustService.swift
//  secure-ios-app
//
//  Created by Tom Jackman on 30/11/2017.
//  Copyright © 2017 Wei Li. All rights reserved.
//

import Foundation
import LocalAuthentication
import DTTJailbreakDetection

protocol DeviceTrustService {
    func performTrustChecks() -> [Detector]
}

class iosDeviceTrustService: DeviceTrustService {
    
    var detections: [Detector]
    // Detections
    // Positive: Detection occured that is deemed a security issue
    // Negative: No threat found for the detection
    let DETECTION_DEVICE_LOCK_POSITIVE = "Device Lock Not Set"
    let DETECTION_DEVICE_LOCK_NEGATIVE = "Device Lock Set"
    let JAILBREAK_DETECTED_POSITIVE = "Jailbreak Detected"
    let JAILBREAK_DETECTED_NEGATIVE = "Jailbreak Not Detected"
    let DEBUG_MODE_DETECTED_POSITIVE = "Debug Mode Detected"
    let DEBUG_MODE_DETECTED_NEGATIVE = "Debug Mode Not Detected"
    let EMULATOR_DETECTED_POSITIVE = "Emulator Access Detected"
    let EMULATOR_DETECTED_NEGATIVE = "Physical Device Access Detected"
    let LATEST_OS_DETECTED_POSITIVE = "Latest OS Version Not Installed"
    let LATEST_OS_DETECTED_NEGATIVE = "Latest OS Version Installed"
    
    /**
     - Initilise the iOS Device Trust Service
    */
    init() {
        self.detections = []
    }
    
    /**
     - Perform the Device Trust Checks
     
     - Returns: A list of Detector objects
     */
    func performTrustChecks() -> [Detector] {
        detectDeviceLock()
        detectJailbreak()
        detectEmulator()
        detectDebugabble()
        detectLatestOS()
        
        return self.detections
    }
    
    /**
     - Check if a lock screen is set on the device. (iOS 9 or higher).
     */
    fileprivate func detectDeviceLock() {
        if #available(iOS 9.0, *) {
            let deviceLockSet = LAContext().canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
            if deviceLockSet == false {
                addDetection(label: DETECTION_DEVICE_LOCK_POSITIVE, detected: true)
            } else {
                addDetection(label: DETECTION_DEVICE_LOCK_NEGATIVE, detected: false)
            }
        }
    }
    
    /**
     - Check if the device running the application is jailbroken.
     */
    fileprivate func detectJailbreak() {
        if (DTTJailbreakDetection.isJailbroken()) {
            addDetection(label: JAILBREAK_DETECTED_POSITIVE, detected: true)
        } else {
            addDetection(label: JAILBREAK_DETECTED_NEGATIVE, detected: false)
        }
    }
    
    /**
     - Check if the device running the application is jailbroken.
     */
    fileprivate func detectDebugabble() {
        #if DEBUG
            addDetection(label: DEBUG_MODE_DETECTED_POSITIVE, detected: true)
        #else
            addDetection(label: DEBUG_MODE_DETECTED_NEGATIVE, detected: false)
        #endif
    }
    
    /**
     - Check if the application is running in an emulator.
     */
    fileprivate func detectEmulator() {
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            addDetection(label: EMULATOR_DETECTED_POSITIVE, detected: true)
        #else
            addDetection(label: EMULATOR_DETECTED_NEGATIVE, detected: false)
        #endif
    }
    
    /**
     - Check if the device is running the on the latest version of iOS.
     */
    fileprivate func detectLatestOS() {
        if #available(iOS 11.0, *) {
            addDetection(label: LATEST_OS_DETECTED_NEGATIVE, detected: false)
        } else {
            addDetection(label: LATEST_OS_DETECTED_POSITIVE, detected: true)
        }
    }
    
    /**
     - Add a detection result to the detections list.
     
     - Parameter label: the label for the detection in the UI
     - Parameter detected: a boolean value for if a security risk is detected
     */
    fileprivate func addDetection(label: String, detected: Bool) {
        let detector = Detector(label: label, detected: detected)
        self.detections.append(detector)
    }

}

