//
//  AuthenticationRouter.swift
//  secure-ios-app
//
//  Created by Wei Li on 08/11/2017.
//  Copyright © 2017 Wei Li. All rights reserved.
//

import Foundation

/* Manage the routing insdie the authentication view */
protocol AuthenticationRouter {
    var viewController: AuthenticationViewController {get}
}

class AuthenticationRouterImpl: AuthenticationRouter {
    let viewController: AuthenticationViewController
    var detailsViewController: AuthenticationDetailsViewController?
    
    init(viewController: AuthenticationViewController) {
        self.viewController = viewController
    }
    
    func showUserDetails(_ identify: Identify) {
        if (self.detailsViewController == nil) {
            //self.detailsViewController = 
        }
    }
    
}
