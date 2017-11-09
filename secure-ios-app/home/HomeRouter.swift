//
//  HomeRouter.swift
//  secure-ios-app
//
//  Created by Wei Li on 08/11/2017.
//  Copyright © 2017 Wei Li. All rights reserved.
//

import Foundation
import UIKit

/* Manage the routing for the home view */
protocol HomeRouter {
    var viewController: HomeViewController {get}
}

class HomeRouterImpl: HomeRouter {
    let viewController: HomeViewController
    
    init(viewController: HomeViewController) {
        self.viewController = viewController
    }
    
}
