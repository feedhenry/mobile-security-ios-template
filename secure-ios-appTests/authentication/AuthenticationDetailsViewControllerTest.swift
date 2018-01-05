//
//  AuthenticationDetailsViewControllerTest.swift
//  secure-ios-appTests
//
//  Created by Wei Li on 04/01/2018.
//  Copyright © 2018 Wei Li. All rights reserved.
//

import XCTest
@testable import secure_ios_app


class AuthenticationDetailsViewControllerTest: XCTestCase {
    
    var authDetailsViewController: AuthenticationDetailsViewController!
    var authListener = TestAuthListener()
    var testIdentity = Identity(userName: "test", fullName: "test user", emailAddress: "test@example.com", reamlRoles: [RealmRoles.apiAccess.roleName])
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        authDetailsViewController = mainStoryboard.instantiateViewController(withIdentifier: "AuthenticationDetailsViewController") as! AuthenticationDetailsViewController
        authDetailsViewController.authListener = authListener
        authDetailsViewController.userIdentify = testIdentity
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
        checkUserName(name: testIdentity.fullName)
        checkFirstRole(role: testIdentity.reamlRoles.first!)
        let anotherUser = Identity(userName: "atest", fullName: "auser", emailAddress: "auser@example.com", reamlRoles: [RealmRoles.mobileUser.roleName])
        authDetailsViewController.userIdentify = anotherUser
        checkUserName(name: anotherUser.fullName)
        checkFirstRole(role: anotherUser.reamlRoles.first!)
    }
    
}
