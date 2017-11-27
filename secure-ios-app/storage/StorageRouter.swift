//
//  StorageRouter.swift
//  secure-ios-app
//
//  Created by Tom Jackman on 20/11/2017.
//  Copyright © 2017 Wei Li. All rights reserved.
//

import Foundation

/* Manage the routing inside the storage view */
protocol StorageRouter {
    var viewController: StorageViewController {get}
}

/* Manage the routing inside the storage view */
class StorageRouterImpl: StorageRouter {
    let viewController: StorageViewController
    
    /**
     - Storage Router Initialisor
     
     - Parameter viewController: the storage view controller
     */
    init(viewController: StorageViewController) {
        self.viewController = viewController
    }
}
