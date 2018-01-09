//
//  AuthenticationInteractor.swift
//  secure-ios-app
//
//  Created by Wei Li on 08/11/2017.
//  Copyright © 2017 Wei Li. All rights reserved.
//

import Foundation

/* Implement the business logic for the authentication view here. */
protocol AuthenticationInteractor: AuthListener {
    var authService: AuthenticationService {get}
    var certPinningService: CertPinningService {get}
    var router: AuthenticationRouter? {get set}
}

class AuthenticationInteractorImpl: AuthenticationInteractor {
    
    let authService: AuthenticationService
    let certPinningService: CertPinningService
    var router: AuthenticationRouter?
    
    init(authService: AuthenticationService, certPinningService: CertPinningService) {
        self.authService = authService
        self.certPinningService = certPinningService
    }
    
    func startAuth(presentingViewController: UIViewController) {
        self.authService.performAuthentication(presentingViewController: presentingViewController){
            identify,error in
            self.router?.navigateToUserDetailsView(withIdentify: identify, andError: error)
        }
    }
    
    func logout() {
        self.authService.performLogout(onCompleted: { error in
            self.router?.leaveUserDetailsView(withError: error)
        })
    }
    
    /*
     - Calls the cert pinning service to perform a preflight check on the auth server to ensure the channel is clear before continuing.
     
     - Parameter url - the url of the host to check. If no URL is provided, the auth server will be tested by default.
     
     - Parameter onCompleted - a completion handler that returns the result of the cert check. A true value means that the cert pinning validated successfully. A false value means there was a validation issue which resulted in a pin verification failure.
     */
    func performPreCertCheck(onCompleted: @escaping (Bool) -> Void) {
        certPinningService.performValidCertCheck(url: nil, onCompleted: onCompleted)
    }
}
