//
//  AuthenticationDetailsViewControllerTest.swift
//  secure-ios-appTests
//
//  Created by Wei Li on 04/01/2018.
//  Copyright © 2018 Wei Li. All rights reserved.
//

import XCTest
@testable import secure_ios_app
@testable import AGSAuth


class AuthenticationDetailsViewControllerTest: XCTestCase {
    var authDetailsViewController: AuthenticationDetailsViewController!
    var authListener = TestAuthListener()
    
    var realmRole: UserRole!
    var clientRole: UserRole!
    var roles: Set<UserRole>!
    var testUser: User!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        realmRole = UserRole(nameSpace: nil, roleName: "realmRole")
        clientRole = UserRole(nameSpace: "client", roleName: "clientRole")
        roles = [realmRole, clientRole]
        testUser = User(userName: "testUser", email: "testUser@example.com", firstName: "test", lastName: "user", accessToken: "", identityToken: "", roles: roles)
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        authDetailsViewController = mainStoryboard.instantiateViewController(withIdentifier: "AuthenticationDetailsViewController") as! AuthenticationDetailsViewController
        authDetailsViewController.authListener = authListener
        authDetailsViewController.currentUser = testUser
        UIApplication.shared.keyWindow!.rootViewController = authDetailsViewController
        _ = authDetailsViewController.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        authDetailsViewController = nil
        super.tearDown()
    }

    func checkUserName(name: String) {
        let indexPath = IndexPath(row: 0, section: 0)
        let userNameCell = authDetailsViewController.userInfoView.cellForRow(at: indexPath)!
        let fieldValueLabel = userNameCell.contentView.viewWithTag(2) as! UILabel
        XCTAssertNotNil(fieldValueLabel)
        XCTAssertEqual(fieldValueLabel.text, name)
    }
    
    func checkFirstRole(role: String) {
        let indexPath = IndexPath(row: 0, section: 1)
        let userRoleCell = authDetailsViewController.userInfoView.cellForRow(at: indexPath)!
        let roleValueLabel = userRoleCell.contentView.viewWithTag(1) as! UILabel
        XCTAssertNotNil(userRoleCell)
        XCTAssertEqual(roleValueLabel.text, role)
    }
    
    func testRender() {
        checkUserName(name: "\(testUser.firstName!) \(testUser.lastName!)")
        checkFirstRole(role: testUser.roles.first!.roleName)
        let anotherUser: User = User(userName: "aTestUser", email: "aTestUser@example.com", firstName: "aTest", lastName: "User", accessToken: "", identityToken: "", roles: roles)
        authDetailsViewController.currentUser = anotherUser
        checkUserName(name: "\(anotherUser.firstName!) \(anotherUser.lastName!)")
        checkFirstRole(role: anotherUser.roles.first!.roleName)
    }
    
}
