//
//  AccessControlBuilder.swift
//  secure-ios-app
//
//  Created by Wei Li on 14/12/2017.
//  Copyright © 2017 Wei Li. All rights reserved.
//

import Foundation
import AGSAuth

class AccessControlBuilder {
    
    let appComponents: AppComponents
    
    init(appComponents: AppComponents) {
        self.appComponents = appComponents
    }
    
    func build() -> AccessControlRouter {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "AccessControlViewController") as! AccessControlViewController
        viewController.userIdentity = self.resolveCurrentUser()
        
        let accessControlRouter = AccessControlRouterImpl(viewController: viewController)
        return accessControlRouter
    }
    
    // tag::resolveCurrentUser[]
    func resolveCurrentUser() -> User? {
        let authService = self.appComponents.resolveAuthService()
        do {
            guard let currentUser = try! authService.currentUser() else {
                return nil
            }
            return currentUser
        }
    }
    // end::resolveCurrentUser[]
}
