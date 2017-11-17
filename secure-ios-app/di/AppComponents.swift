//
//  AppComponents.swift
//  secure-ios-app
//
//  Created by Wei Li on 09/11/2017.
//  Copyright © 2017 Wei Li. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class AppComponents {
    
    let appConfiguration: AppConfiguration
    
    var authService: AuthenticationService?
    
    init(appConfiguration: AppConfiguration) {
        self.appConfiguration = appConfiguration
    }
    
    func resolveAuthService() -> AuthenticationService {
        if self.authService == nil {
            self.authService = AppAuthAuthenticationService(authServerConfig: self.appConfiguration.authServerConf, kcWrapper: KeychainWrapper.standard)
        }
        return self.authService!
    }
}
