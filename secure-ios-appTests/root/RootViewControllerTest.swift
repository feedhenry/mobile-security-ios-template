//
//  RootViewControllerTest.swift
//  secure-ios-appTests
//
//  Created by Wei Li on 04/01/2018.
//  Copyright © 2018 Wei Li. All rights reserved.
//

import XCTest
@testable import secure_ios_app

class TestMenuListener: MenuListener {
    var selectedMenuItem: MenuItem?
    
    func onMenuItemSelected(_ item: MenuItem) {
        self.selectedMenuItem = item
    }
}

class RootViewControllerTest: XCTestCase {
    var rootVCToTest: RootViewController!
    var menuListener: TestMenuListener!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navController = mainStoryboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        rootVCToTest = navController.childViewControllers.first as! RootViewController;
        menuListener = TestMenuListener()
        
        rootVCToTest.listener = menuListener
        UIApplication.shared.keyWindow!.rootViewController = navController
        _ = rootVCToTest.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        rootVCToTest = nil
        super.tearDown()
    }
    
    func testMenuItems() {
        XCTAssertTrue(rootVCToTest.arrayMenuOptions.count >= 1)
        XCTAssertNotNil(menuListener.selectedMenuItem)
        XCTAssertEqual(menuListener.selectedMenuItem?.title, rootVCToTest.arrayMenuOptions[0].title)
        rootVCToTest.drawerMenuItemSelectedAtIndex(1)
        XCTAssertEqual(menuListener.selectedMenuItem?.title, rootVCToTest.arrayMenuOptions[1].title)
    }
    
    func testMenuOpenClose() {
        let sender = UIButton()
        //open
        rootVCToTest.onSlideMenuButtonPressed(sender)
        XCTAssertTrue(rootVCToTest.childViewControllers.first!.isKind(of: MenuViewController.self))
        var menuVC = rootVCToTest.childViewControllers.first! as! MenuViewController
        XCTAssertTrue(menuVC.isOpen)
        //close
        rootVCToTest.onSlideMenuButtonPressed(sender)
        menuVC = rootVCToTest.childViewControllers.first! as! MenuViewController
        XCTAssertFalse(menuVC.isOpen)
    }
}
