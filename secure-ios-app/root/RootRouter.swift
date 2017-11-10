//
//  RootRouter.swift
//  secure-ios-app
//
//  Created by Wei Li on 08/11/2017.
//  Copyright © 2017 Wei Li. All rights reserved.
//

import Foundation
import UIKit

/*
 The router for the root view module. It is responsible to load child modules and attach them to the view.
 It should call the child module's corresponding builder class to build the child module, pass on the dependencies that are required.
 */
protocol RootRouter {
    var appComponents: AppComponents {get}
    var rootViewController: RootViewController {get}
    
    func launchFromWindow(window:UIWindow)
    func launchHomeView()
    func launchAuthenticationView()
}

class RootRouterImpl: RootRouter {
    
    let navViewController: UINavigationController
    let rootViewController: RootViewController
    let appComponents: AppComponents
    
    var homeRouter: HomeRouter?
    var authenticationRouter: AuthenticationRouter?
    
    init(navViewController: UINavigationController, viewController: RootViewController, appComponents: AppComponents) {
        self.navViewController = navViewController
        self.rootViewController = viewController
        self.appComponents = appComponents
    }
    
    func launchFromWindow(window: UIWindow) {
        window.rootViewController = self.navViewController
        window.makeKeyAndVisible()
    }
    
    func launchHomeView() {
        if self.homeRouter == nil {
            self.homeRouter = HomeBuilder().build()
        }
        self.rootViewController.presentViewController(self.homeRouter!.viewController, true)
    }
    
    func launchAuthenticationView() {
        if self.authenticationRouter == nil {
            self.authenticationRouter = AuthenticationBuilder(appComponents: self.appComponents).build()
        }
        self.rootViewController.presentViewController(self.authenticationRouter!.viewController, true)
    }
}
