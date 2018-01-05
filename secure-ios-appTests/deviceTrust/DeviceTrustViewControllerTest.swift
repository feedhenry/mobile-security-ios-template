//
//  DeviceTrustViewControllerTest.swift
//  secure-ios-appTests
//
//  Created by Wei Li on 04/01/2018.
//  Copyright © 2018 Wei Li. All rights reserved.
//

import XCTest
@testable import secure_ios_app

class FakeDeviceTrustListener: DeviceTrustListener {
    func performTrustChecks() -> [Detector] {
        let detector = Detector(label: "test", detected: true, description: "test")
        return [detector]
    }
}

class DeviceTrustViewControllerTest: XCTestCase {
    
    var deviceTrustVCToTest: DeviceTrustViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        deviceTrustVCToTest = mainStoryboard.instantiateViewController(withIdentifier: "DeviceTrustViewController") as! DeviceTrustViewController
        deviceTrustVCToTest.deviceTrustListener = FakeDeviceTrustListener()
        UIApplication.shared.keyWindow!.rootViewController = deviceTrustVCToTest
        _ = deviceTrustVCToTest.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        deviceTrustVCToTest = nil
        super.tearDown()
    }
    
    func testRender() {
        XCTAssertEqual(deviceTrustVCToTest.deviceTrustScore.text, "Device Trust Score: 0.0%")
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = deviceTrustVCToTest.tableView.cellForRow(at: indexPath)
        XCTAssertEqual(cell?.textLabel?.text, "test")
    }
}
