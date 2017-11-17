//
//  RootBuilder.swift
//  secure-ios-app
//
//  Created by Wei Li on 08/11/2017.
//  Copyright © 2017 Wei Li. All rights reserved.
//

import Foundation
import UIKit


/*
  Builder class to create all the required instances for the root view.
  This is where all the dependencies for the root module are specified, and all the required instances are created.
 */
class RootBuilder {
    
    let appComponents: AppComponents
    
    init(components: AppComponents) {
        self.appComponents = components
    }
    
    func build() -> RootRouter {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navController = mainStoryboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        let rootViewController = navController.childViewControllers.first as! RootViewController;
        
        let rootRouter = RootRouterImpl(navViewController: navController, viewController: rootViewController, appComponents: self.appComponents)
        
        let rootInteractor = RootInteractorImpl()
        rootInteractor.router = rootRouter
        
        rootViewController.listener = rootInteractor
        return rootRouter
    }
}



