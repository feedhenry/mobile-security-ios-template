//
//  DeviceTrustInteractor.swift
//  secure-ios-app
//
//  Created by Tom Jackman on 30/11/2017.
//  Copyright © 2017 Wei Li. All rights reserved.
//

import Foundation

/* Implement the business logic for the device trust view here. */
protocol DeviceTrustInteractor: DeviceTrustListener {
    var deviceTrustService: DeviceTrustService {get}
    var router: DeviceTrustRouter? {get set}
}

class DeviceTrustInteractorImpl: DeviceTrustInteractor {
    
    let deviceTrustService: DeviceTrustService
    var router: DeviceTrustRouter?
    
    init(deviceTrustService: DeviceTrustService) {
        self.deviceTrustService = deviceTrustService
    }
    
    func performChecks() {
        self.deviceTrustService.performChecks()
    }
}

