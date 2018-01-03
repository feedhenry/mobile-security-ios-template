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
        
        // perform cert pinning of the auth server on load
        self.performPreCertCheck()

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
     - Calls the cert pinning service to perform a preflight check on the auth server to ensure the channel is clear before continuing.
     
     - Parameter url - the url of the host to check. If no URL is provided, the auth server will be tested by default.
     
     - Parameter onCompleted - a completion handler that returns the result of the cert check. A true value means that the cert pinning validated successfully. A false value means there was a validation issue which resulted in a pin verification failure.
     */
    func performPreCertCheck() {
        if let listener = self.authListener {
            listener.performPreCertCheck() {
                validCert in
                if(validCert) {
                    // cert is valid
                    self.authenticationButton.isEnabled = true
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
