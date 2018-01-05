//
//  DeviceTrustServiceTest.swift
//  secure-ios-appTests
//
//  Created by Wei Li on 03/01/2018.
//  Copyright © 2018 Wei Li. All rights reserved.
//

import XCTest
@testable import secure_ios_app

class DeviceTrustServiceTest: XCTestCase {
    
    var trustServiceToTest: DeviceTrustService!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        trustServiceToTest = iosDeviceTrustService()
    }
    
    override func tearDown() {
        trustServiceToTest = nil
        super.tearDown()
    }
    
    func testPerformTrustChecks() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let detectors = trustServiceToTest.performTrustChecks()
        XCTAssertEqual(detectors.count, 5)
    }
    
}
