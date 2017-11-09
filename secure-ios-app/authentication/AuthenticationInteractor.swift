//
//  AuthenticationInteractor.swift
//  secure-ios-app
//
//  Created by Wei Li on 08/11/2017.
//  Copyright © 2017 Wei Li. All rights reserved.
//

import Foundation

/* Implement the business logic for the authentication view here. */
protocol AuthenticationInteractor {
    var authServerConfiguration: AuthServerConfiguration {get}
    var router: AuthenticationRouter? {get set}
}

class AuthenticationInteractorImpl: AuthenticationInteractor {
    let authServerConfiguration: AuthServerConfiguration
    var router: AuthenticationRouter?
    
    init(authServerConfiguration: AuthServerConfiguration) {
        self.authServerConfiguration = authServerConfiguration
    }
}
