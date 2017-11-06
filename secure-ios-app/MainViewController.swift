//
//  MainViewController.swift
//  secure-ios-app
//
//  Created by Wei Li on 06/11/2017.
//  Copyright © 2017 Wei Li. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildView(storyBoardId: "HomeViewController", titleOfChildView: "Home", iconName: "ic_home")
        addChildView(storyBoardId: "AuthenticationViewController", titleOfChildView: "Authentication", iconName: "ic_account_circle")
        
        showFirstChild()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
