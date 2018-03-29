//
//  AuthenticationInteractor.swift
//  secure-ios-app
//
//  Created by Wei Li on 08/11/2017.
//  Copyright © 2017 Wei Li. All rights reserved.
//

import Foundation
import AGSAuth

/* Implement the business logic for the authentication view here. */
protocol AuthenticationInteractor: AuthListener {
    var authService: AgsAuth {get}
    var certPinningService: CertPinningService {get}
    var router: AuthenticationRouter? {get set}
}

class AuthenticationInteractorImpl: AuthenticationInteractor {
    
    let authService: AgsAuth
    let certPinningService: CertPinningService
    var router: AuthenticationRouter?
    
    init(authService: AgsAuth, certPinningService: CertPinningService) {
        self.authService = authService
        self.certPinningService = certPinningService
    }
    
    func startAuth(presentingViewController: UIViewController) {
        do {
            try self.authService.login(presentingViewController: presentingViewController, onCompleted: onLoginCompleted)
        } catch {
            fatalError("Unexpected error: \(error)")
        }
    }
    
    func logout() {
        do {
            try self.authService.logout(onCompleted: { error in
                self.router?.leaveUserDetailsView(withError: error)
            })
        } catch {
            fatalError("Unexpected error: \(error)")
        }
    }
    
    /*
     - Calls the cert pinning service to perform a preflight check on the auth server to ensure the channel is clear before continuing.
     
     - Parameter url - the url of the host to check. If no URL is provided, the auth server will be tested by default.
     
     - Parameter onCompleted - a completion handler that returns the result of the cert check. A true value means that the cert pinning validated successfully. A false value means there was a validation issue which resulted in a pin verification failure.
     */
    func performPreCertCheck(onCompleted: @escaping (Bool) -> Void) {
        certPinningService.performValidCertCheck(url: nil, onCompleted: onCompleted)
    }
    
    func onLoginCompleted(user: User?, err: Error?) {
        self.router?.navigateToUserDetailsView(withIdentify: user, andError: err)
    }
}
