//
//  AuthenticationRouter.swift
//  secure-ios-app
//
//  Created by Wei Li on 08/11/2017.
//  Copyright © 2017 Wei Li. All rights reserved.
//

import Foundation
import AGSAuth

/* Manage the routing insdie the authentication view */
protocol AuthenticationRouter {
    var viewController: AuthenticationViewController {get}
    var detailsViewController: AuthenticationDetailsViewController {get}
    func navigateToUserDetailsView(withIdentify identify: User?, andError error: Error?)
    func leaveUserDetailsView(withError error: Error?)
    func initialViewController(user: User?) -> UIViewController
}

class AuthenticationRouterImpl: AuthenticationRouter {
    let viewController: AuthenticationViewController
    let detailsViewController: AuthenticationDetailsViewController
    
    init(viewController: AuthenticationViewController, detailsViewController: AuthenticationDetailsViewController) {
        self.viewController = viewController
        self.detailsViewController = detailsViewController
    }
    
    func navigateToUserDetailsView(withIdentify user: User?, andError error: Error?) {
        if let identityInfo = user {
            Logger.info("got user identity: \(identityInfo)")
            self.detailsViewController.displayUserDetails(from: self.viewController, user: identityInfo)
        } else if let err = error {
            Logger.info("authentication failed with error \(err.localizedDescription)")
            self.viewController.showError(title: "Login Failed", error: err)
        }
    }
    
    func leaveUserDetailsView(withError error: Error?) {
        if let err = error {
            Logger.error("logout failed due to error : \(err.localizedDescription)")
            self.detailsViewController.showError(title: "Logout Failed", error: err)
        } else {
            Logger.debug("user logged out successfully")
            self.detailsViewController.removeView()
        }
    }
    
    func initialViewController(user: User?) -> UIViewController {
        if let userIdentity = user {
            // if the user is already logged in, add the details atop of the authentication view
            self.detailsViewController.currentUser = userIdentity
            ViewHelper.showChildViewController(parentViewController: self.viewController, childViewController: self.detailsViewController)
        }
        return self.viewController
    }
}
