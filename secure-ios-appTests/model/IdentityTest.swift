//
//  IdentityTest.swift
//  secure-ios-appTests
//
//  Created by Wei Li on 03/01/2018.
//  Copyright © 2018 Wei Li. All rights reserved.
//

import XCTest
@testable import secure_ios_app

class IdentityTest: XCTestCase {
    var identityToTest: Identity!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        identityToTest = Identity(userName: "test", fullName: "testUser", emailAddress: "test@example.com", reamlRoles: ["role1"])
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        identityToTest = nil
        super.tearDown()
    }
    
    func testHasRole() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssert(identityToTest.hasRole(role: "role1"))
        XCTAssert(!identityToTest.hasRole(role: "role2"))
    }
    
}
