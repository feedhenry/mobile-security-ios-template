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
    var detailsViewController: AuthenticationDetailsViewController {get}
    func showUserDetails(_ identify: Identify)
}

class AuthenticationRouterImpl: AuthenticationRouter {
    let viewController: AuthenticationViewController
    let detailsViewController: AuthenticationDetailsViewController
    
    init(viewController: AuthenticationViewController, detailsViewController: AuthenticationDetailsViewController) {
        self.viewController = viewController
        self.detailsViewController = detailsViewController
    }
    
    func showUserDetails(_ identify: Identify) {
        self.detailsViewController.userIdentify = identify
        self.viewController.addChildViewController(self.detailsViewController)
        
        self.detailsViewController.view.frame = self.viewController.view.bounds
        self.viewController.view.addSubview(self.detailsViewController.view)
        self.detailsViewController.didMove(toParentViewController: self.viewController)
    }
}
