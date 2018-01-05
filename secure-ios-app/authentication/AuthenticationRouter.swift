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
    func navigateToUserDetailsView(withIdentify identify: Identity?, andError error: Error?)
    func leaveUserDetailsView(withError error: Error?)
    func initialViewController(identity: Identity?) -> UIViewController
}

class AuthenticationRouterImpl: AuthenticationRouter {
    let viewController: AuthenticationViewController
    let detailsViewController: AuthenticationDetailsViewController
    
    init(viewController: AuthenticationViewController, detailsViewController: AuthenticationDetailsViewController) {
        self.viewController = viewController
        self.detailsViewController = detailsViewController
    }
    
    func navigateToUserDetailsView(withIdentify identity: Identity?, andError error: Error?) {
        if let identityInfo = identity {
            Logger.info("got user identity: \(identityInfo)")
            self.detailsViewController.displayUserDetails(from: self.viewController, identity: identityInfo)
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
    
    func initialViewController(identity: Identity?) -> UIViewController {
        if let idn = identity {
            // if the user is already logged in, add the details atop of the authentication view
            self.detailsViewController.userIdentify = idn
            ViewHelper.showChildViewController(parentViewController: self.viewController, childViewController: self.detailsViewController)
        }
        return self.viewController
    }
}
