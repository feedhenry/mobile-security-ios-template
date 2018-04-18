//
//  AccessControlViewControllerTest.swift
//  secure-ios-appTests
//
//  Created by Wei Li on 04/01/2018.
//  Copyright © 2018 Wei Li. All rights reserved.
//

import XCTest
@testable import AGSAuth

@testable import secure_ios_app

class AccessControlViewControllerTest: XCTestCase {
    var accessControlVCToTest: AccessControlViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        
        let realmRole: UserRole = UserRole(nameSpace: nil, roleName: RealmRoles.apiAccess.roleName)
        let clientRole: UserRole = UserRole(nameSpace: "client", roleName: "clientRole")
        let roles: Set<UserRole> = [realmRole, clientRole]
        
        let user: User = User(userName: "testUser", email: "testUser@example.com", firstName: "test", lastName: "user", accessToken: "", identityToken: "", roles: roles)
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
        self.checkRoleAccessoryType(row: 0, type: UITableViewCellAccessoryType.checkmark)
        
        let realmRole: UserRole = UserRole(nameSpace: nil, roleName: RealmRoles.mobileUser.roleName)
        let clientRole: UserRole = UserRole(nameSpace: "client", roleName: "clientRole")
        let roles: Set<UserRole> = [realmRole, clientRole]
        let anotherUser: User = User(userName: "aUser", email: "aUser@example.com", firstName: "aTest", lastName: "User", accessToken: "", identityToken: "", roles: roles)

        accessControlVCToTest.userIdentity = anotherUser
        self.checkRoleAccessoryType(row: 0, type: UITableViewCellAccessoryType.none)
        self.checkRoleAccessoryType(row: 1, type: UITableViewCellAccessoryType.checkmark)
    }
}
