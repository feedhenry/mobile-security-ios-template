//
//  DeviceTrustBuilder.swift
//  secure-ios-app
//
//  Created by Tom Jackman on 30/11/2017.
//  Copyright © 2017 Wei Li. All rights reserved.
//

import Foundation

/* Builder class for the device trust module */
class DeviceTrustBuilder {
    
    let appComponents: AppComponents
    
    init(appComponents: AppComponents) {
        self.appComponents = appComponents
    }
    
    func build() -> DeviceTrustRouter {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "DeviceTrustViewController") as! DeviceTrustViewController
        
        let deviceTrustRouter = DeviceTrustRouterImpl(viewController: viewController)
        let deviceTrustInteractor = DeviceTrustInteractorImpl(deviceTrustService: self.appComponents.resolveDeviceTrustService())
        deviceTrustInteractor.router = deviceTrustRouter
        
        viewController.deviceTrustListener = deviceTrustInteractor
        return deviceTrustRouter
    }
}
