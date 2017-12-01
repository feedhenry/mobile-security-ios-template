//
//  DeviceTrustViewController.swift
//  secure-ios-app
//
//  Created by Tom Jackman on 30/11/2017.
//  Copyright © 2017 Wei Li. All rights reserved.
//

import Foundation

protocol DeviceTrustListener {
    func performChecks()
}

/* The view controller for the device trust view. */
class DeviceTrustViewController: UIViewController {
    
    var deviceTrustListener: DeviceTrustListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func performChecks() {
        if let listener = self.deviceTrustListener {
            listener.performChecks()
        }
    }
}
