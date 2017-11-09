//
//  AuthenticationBuilder.swift
//  secure-ios-app
//
//  Created by Wei Li on 08/11/2017.
//  Copyright © 2017 Wei Li. All rights reserved.
//

import Foundation
import UIKit

/*
 Builder class for the authentication module.
 This class should be used to build the authentication module, and the caller should be able to pass the required dependencies to it.
 */
class AuthenticationBuilder {
    
    func build(authServerConfiguration: AuthServerConfiguration) -> AuthenticationRouter {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "AuthenticationViewController") as! AuthenticationViewController
        
        let authenticationRouter = AuthenticationRouterImpl(viewController: viewController)
        let authenticationInteractor = AuthenticationInteractorImpl(authServerConfiguration: authServerConfiguration)
        authenticationInteractor.router = authenticationRouter
        return authenticationRouter
    }
}
