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
    
    // detection descriptions
    let DETECTION_DEVICE_LOCK_DESC = "This check will detect if a lock screen has been set on the device. Not setting a lock screen on the device can make it vulnerable to unauthorised access."
    let JAILBREAK_DETECTED_DESC = "This check will detect if the underlying device is Jailbroken. A Jailbroken device permits root access and can be used to used to carry out malicious actions, such as recovering application data."
    let DEBUG_MODE_DETECTED_DESC = "This check will detect if the app is running in a debug mode. A debuggable app allows calls within the app to be traced."
    let EMULATOR_DETECTED_DESC = "This check will detect if the app is running on an emulator. Emulators can be created that are already jailbroken and come packaged with other tooling that can be used to attack or reverse engineer an application more easily than on a physical device."
    let LATEST_OS_DETECTED_DESC = "This check will detect if the application is running on the latest major iOS version (iOS 11.0). If the device is running on an older version, it may be vulnerable to unpatched vulnerabilities."

    
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
        if #available(iOS 9.0, *) {
            self.detections.append(detectDeviceLock())
        }
        self.detections.append( detectJailbreak())
        self.detections.append(detectEmulator())
        self.detections.append(detectDebugabble())
        self.detections.append(detectLatestOS())
        
        return self.detections
    }
    
    /**
     - Check if a lock screen is set on the device. (iOS 9 or higher).
     */
    fileprivate func detectDeviceLock() -> Detector {
        let deviceLockSet = LAContext().canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        if deviceLockSet == false {
            return Detector(label: DETECTION_DEVICE_LOCK_POSITIVE, detected: true, description: DETECTION_DEVICE_LOCK_DESC)
        } else {
            return Detector(label: DETECTION_DEVICE_LOCK_NEGATIVE, detected: false, description: DETECTION_DEVICE_LOCK_DESC)
        }
    }
    
    /**
     - Check if the device running the application is jailbroken.
     */
    fileprivate func detectJailbreak() -> Detector {
        if (DTTJailbreakDetection.isJailbroken()) {
            return Detector(label: JAILBREAK_DETECTED_POSITIVE, detected: true, description: JAILBREAK_DETECTED_DESC)
        } else {
            return Detector(label: JAILBREAK_DETECTED_NEGATIVE, detected: false, description: JAILBREAK_DETECTED_DESC)
        }
    }
    
    /**
     - Check if the device running the application is jailbroken.
     */
    fileprivate func detectDebugabble() -> Detector {
        #if DEBUG
            return Detector(label: DEBUG_MODE_DETECTED_POSITIVE, detected: true, description: DEBUG_MODE_DETECTED_DESC)
        #else
            return Detector(label: DEBUG_MODE_DETECTED_NEGATIVE, detected: false, description: DEBUG_MODE_DETECTED_DESC)
        #endif
    }
    
    /**
     - Check if the application is running in an emulator.
     */
    fileprivate func detectEmulator() -> Detector {
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            return Detector(label: EMULATOR_DETECTED_POSITIVE, detected: true, description: EMULATOR_DETECTED_DESC)
        #else
            return Detector(label: EMULATOR_DETECTED_NEGATIVE, detected: false, description: EMULATOR_DETECTED_DESC)
        #endif
    }
    
    /**
     - Check if the device is running the on the latest version of iOS.
     */
    fileprivate func detectLatestOS() -> Detector {
        if #available(iOS 11.0, *) {
            return Detector(label: LATEST_OS_DETECTED_NEGATIVE, detected: false, description: LATEST_OS_DETECTED_DESC)
        } else {
            return Detector(label: LATEST_OS_DETECTED_POSITIVE, detected: true, description: LATEST_OS_DETECTED_DESC)
        }
    }

}

