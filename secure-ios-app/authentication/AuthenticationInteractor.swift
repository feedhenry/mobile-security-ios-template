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
            self.router?.navigateToUserDetailsView(withIdentify: identify, andError: error)
        }
    }
    
    func logout() {
        self.authService.performLogout(onCompleted: { error in
            self.router?.leaveUserDetailsView(withError: error)
        })
    }
}
