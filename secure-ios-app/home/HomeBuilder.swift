//
//  HomeBuilder.swift
//  secure-ios-app
//
//  Created by Wei Li on 08/11/2017.
//  Copyright © 2017 Wei Li. All rights reserved.
//

import Foundation
import UIKit

/*
 Builder class for the home module.
 This class should be used to build the home module, and the caller should be able to pass the required dependencies to it.
 */
class HomeBuilder {
    
    func build() -> HomeRouter {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
        let homeRouter = HomeRouterImpl(viewController: viewController)
        return homeRouter
    }
}
