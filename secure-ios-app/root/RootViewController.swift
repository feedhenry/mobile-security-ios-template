//
//  RootViewController.swift
//  secure-ios-app
//
//  Created by Wei Li on 06/11/2017.
//  Copyright © 2017 Wei Li. All rights reserved.
//

import UIKit

/*
 The main root view controller. It is responsible for listening to the user interaction events, and passing the events on to the listener (interactor).
 */
class RootViewController: BaseViewController,  DrawerMenuDelegate {
    
    static let MENU_HOME_TITLE = "Home"
    static let MENU_AUTHENTICATION_TITLE = "Authentication"
    static let MENU_STORAGE_TITLE = "Storage"
    
    var listener: MenuListener?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuDelegate = self
        
        addMenuItem(titleOfChildView: RootViewController.MENU_HOME_TITLE, iconName: "ic_home")
        addMenuItem(titleOfChildView: RootViewController.MENU_AUTHENTICATION_TITLE, iconName: "ic_account_circle")
        addMenuItem(titleOfChildView: RootViewController.MENU_STORAGE_TITLE, iconName: "ic_storage")
        
        showFirstChild()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //listen for the menu item selected event, and invoke the listener
    func drawerMenuItemSelectedAtIndex(_ index: Int, _ animated: Bool = true) {
        if (index >= 0) {
            let selectedMenuItem = arrayMenuOptions[index];
            listener?.onMenuItemSelected(selectedMenuItem)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
