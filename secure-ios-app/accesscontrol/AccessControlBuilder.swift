//
//  AccessControlBuilder.swift
//  secure-ios-app
//
//  Created by Wei Li on 14/12/2017.
//  Copyright © 2017 Wei Li. All rights reserved.
//

import Foundation

class AccessControlBuilder {
    
    let appComponents: AppComponents
    
    init(appComponents: AppComponents) {
        self.appComponents = appComponents
    }
    
    func build() -> AccessControlRouter {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let authService = self.appComponents.resolveAuthService()
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "AccessControlViewController") as! AccessControlViewController
        viewController.userIdentity = authService.currentIdentity()
        
        let accessControlRouter = AccessControlRouterImpl(viewController: viewController)
        return accessControlRouter
    }
}
