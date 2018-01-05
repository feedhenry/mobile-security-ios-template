//
//  AccessControlViewControllerTest.swift
//  secure-ios-appTests
//
//  Created by Wei Li on 04/01/2018.
//  Copyright © 2018 Wei Li. All rights reserved.
//

import XCTest
@testable import secure_ios_app

class AccessControlViewControllerTest: XCTestCase {
    var accessControlVCToTest: AccessControlViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let user = Identity(userName: "testuser", fullName: "testuser", emailAddress: "testuser@example.com", reamlRoles: [RealmRoles.mobileUser.roleName])
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        accessControlVCToTest = mainStoryboard.instantiateViewController(withIdentifier: "AccessControlViewController") as! AccessControlViewController
        accessControlVCToTest.userIdentity = user
        UIApplication.shared.keyWindow!.rootViewController = accessControlVCToTest
        _ = accessControlVCToTest.view
    }
    
    override func tearDown() {
        accessControlVCToTest = nil
        super.tearDown()
    }
    
    func checkRoleAccessoryType(row: Int, type: UITableViewCellAccessoryType) {
        let indexPath = IndexPath(row: row, section: 0)
        let roleCell = accessControlVCToTest.rolesTable.cellForRow(at: indexPath)
        XCTAssertNotNil(roleCell)
        XCTAssertEqual(roleCell?.accessoryType, type)
    }
    
    func testRender() {
        accessControlVCToTest.viewDidLayoutSubviews()
        self.checkRoleAccessoryType(row: 1, type: UITableViewCellAccessoryType.checkmark)
        
        let anotherUser = Identity(userName: "auser", fullName: "auser", emailAddress: "auser@example.com", reamlRoles: [RealmRoles.superUser.roleName])
        accessControlVCToTest.userIdentity = anotherUser
        self.checkRoleAccessoryType(row: 1, type: UITableViewCellAccessoryType.none)
        self.checkRoleAccessoryType(row: 2, type: UITableViewCellAccessoryType.checkmark)
    }
}
