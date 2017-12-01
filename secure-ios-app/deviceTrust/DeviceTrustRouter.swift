//
//  DeviceTrustRouter.swift
//  secure-ios-app
//
//  Created by Tom Jackman on 30/11/2017.
//  Copyright © 2017 Wei Li. All rights reserved.
//

import Foundation

/* Manage the routing insdie the device trust view */
protocol DeviceTrustRouter {
    var viewController: DeviceTrustViewController {get}
}

class DeviceTrustRouterImpl: DeviceTrustRouter {
    let viewController: DeviceTrustViewController
    
    init(viewController: DeviceTrustViewController) {
        self.viewController = viewController
    }
    
}
