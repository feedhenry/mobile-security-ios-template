//
//  AuthenticationViewController.swift
//  secure-ios-app
//
//  Created by Wei Li on 06/11/2017.
//  Copyright © 2017 Wei Li. All rights reserved.
//

import UIKit

protocol AuthListener {
    func startAuth(presentingViewController: UIViewController)
    func logout()
}

/* The view controller for the authentication view. It should pass the user events to the listener (interactor) */
class AuthenticationViewController: UIViewController {
    
    @IBOutlet weak var authenticationButton: UIButton!
    
    var authListener: AuthListener?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onAuthButtonTapped(_ sender: UIButton) {
        if let listener = self.authListener {
            listener.startAuth(presentingViewController: self)
        }
    }
    
    func showError(title: String, error: Error) {
        ViewHelper.showErrorBannerMessage(from: self, title: title, message: error.localizedDescription)
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
