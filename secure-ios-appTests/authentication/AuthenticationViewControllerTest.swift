//
//  AuthenticationViewControllerTest.swift
//  secure-ios-appTests
//
//  Created by Wei Li on 04/01/2018.
//  Copyright © 2018 Wei Li. All rights reserved.
//

import XCTest
@testable import secure_ios_app

class TestAuthListener: AuthListener {

    var startAuthCalled: Bool = false
    var logoutCalled: Bool = false
    var pinningFailure: Bool = false
    
    func startAuth(presentingViewController: UIViewController) {
        startAuthCalled = true
    }
    
    func logout() {
        logoutCalled = true
    }
    
    func performPreCertCheck(onCompleted: @escaping (Bool) -> Void) {
        onCompleted(!pinningFailure)
    }
}

class AuthenticationViewControllerTest: XCTestCase {
    
    var authViewController: AuthenticationViewController!
    var authListener: TestAuthListener = TestAuthListener()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        authViewController = mainStoryboard.instantiateViewController(withIdentifier: "AuthenticationViewController") as! AuthenticationViewController
        authViewController.authListener = authListener
        UIApplication.shared.keyWindow!.rootViewController = authViewController
        _ = authViewController.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        authViewController = nil
        super.tearDown()
    }
    
    func testAuthButton() {
        XCTAssertFalse(authViewController.authenticationButton.isHidden)
        authViewController.onAuthButtonTapped(UIButton())
        XCTAssertTrue(authListener.startAuthCalled)
    }
    
    func testAuthButtonWithInsecureChannel() {
        XCTAssertFalse(authViewController.authenticationButton.isHidden)
        authListener.pinningFailure = true
        authViewController.onAuthButtonTapped(UIButton())
        XCTAssertFalse(authListener.startAuthCalled)
        XCTAssertTrue(authViewController.authenticationButton.isHidden)
        XCTAssertTrue(authViewController.logoImage.isHidden)
        XCTAssertFalse(authViewController.dangerLogo.isHidden)
        XCTAssertFalse(authViewController.certPinningError.isHidden)
    }
    
}
