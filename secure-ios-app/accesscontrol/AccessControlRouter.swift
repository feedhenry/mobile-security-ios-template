//
//  AccessControlRouter.swift
//  secure-ios-app
//
//  Created by Wei Li on 02/01/2018.
//  Copyright © 2018 Wei Li. All rights reserved.
//

import Foundation

protocol AccessControlRouter {
    var viewController: AccessControlViewController {get}
}

class AccessControlRouterImpl: AccessControlRouter {
    let viewController: AccessControlViewController
    
    init(viewController: AccessControlViewController) {
        self.viewController = viewController
    }
}
