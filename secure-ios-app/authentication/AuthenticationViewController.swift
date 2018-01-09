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
    func performPreCertCheck(onCompleted: @escaping (Bool) -> Void)
}

/* The view controller for the authentication view. It should pass the user events to the listener (interactor) */
class AuthenticationViewController: UIViewController {
    
    @IBOutlet weak var authenticationButton: UIButton!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var certPinningError: UILabel!
    @IBOutlet weak var dangerLogo: UIImageView!

    var authListener: AuthListener?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // tag::onAuthButtonTapped[]
    @IBAction func onAuthButtonTapped(_ sender: UIButton) {
        // perform cert pinning on the auth server when the auth button is pressed
        if let listener = self.authListener {
            listener.performPreCertCheck() {
                validCert in
                if(validCert) {
                    // cert is valid, continue with login
                    listener.startAuth(presentingViewController: self)
                } else {
                    // pin validation issues, update the UI to notify the user and prevent authentication.
                    self.authenticationButton.isHidden = true
                    self.certPinningError.isHidden = false
                    self.logoImage.isHidden = true
                    self.dangerLogo.isHidden = false
                    self.backgroundImage.image = UIImage(named: "ic_error_background")
                }
            }
        }
    }
    // end::onAuthButtonTapped[]
    
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
