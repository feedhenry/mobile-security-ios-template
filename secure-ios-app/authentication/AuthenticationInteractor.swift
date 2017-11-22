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
    var router: AuthenticationRouter? {get set}
}

class AuthenticationInteractorImpl: AuthenticationInteractor {
    
    let authService: AuthenticationService
    var router: AuthenticationRouter?
    
    init(authService: AuthenticationService) {
        self.authService = authService
    }
    
    func startAuth(presentingViewController: UIViewController) {
        self.authService.performAuthentication(presentingViewController: presentingViewController){
            identify,error in
            if identify != nil {
                Logger.info("got user identity: \(identify.debugDescription)")
                self.router?.showUserDetails(identify!)
            } else {
                Logger.info("authentication failed")
            }
        }
    }
}
