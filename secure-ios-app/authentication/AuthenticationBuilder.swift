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
    
    let appComponents: AppComponents
    
    init(appComponents: AppComponents) {
        self.appComponents = appComponents
    }
    
    func build() -> AuthenticationRouter {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "AuthenticationViewController") as! AuthenticationViewController
        let detailsViewController = mainStoryboard.instantiateViewController(withIdentifier: "AuthenticationDetailsViewController") as! AuthenticationDetailsViewController
        
        let authenticationRouter = AuthenticationRouterImpl(viewController: viewController, detailsViewController: detailsViewController)
        let authenticationInteractor = AuthenticationInteractorImpl(authService: self.appComponents.resolveAuthService())
        authenticationInteractor.router = authenticationRouter
        
        viewController.authListener = authenticationInteractor
        detailsViewController.authListener = authenticationInteractor
        return authenticationRouter
    }
}
