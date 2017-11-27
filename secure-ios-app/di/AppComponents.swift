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
    let kcWrapper: KeychainWrapper
    
    var authService: AuthenticationService?
    
    var storageService: StorageService?
    let REALM_STORAGE_KEYCHAIN_ALIAS = "realm-db-keychain"
    
    init(appConfiguration: AppConfiguration) {
        self.appConfiguration = appConfiguration
        self.kcWrapper = KeychainWrapper.standard
    }
    
    func resolveAuthService() -> AuthenticationService {
        if self.authService == nil {
            self.authService = AppAuthAuthenticationService(authServerConfig: self.appConfiguration.authServerConf, kcWrapper: self.kcWrapper)
        }
        return self.authService!
    }
    
    // Setup the Storage Service
    func resolveStorageService() -> StorageService {
        if self.storageService == nil {
            var encryptionKey = RealmStorageService.getEncryptionKey(kcWrapper: self.kcWrapper, keychainAlias: self.REALM_STORAGE_KEYCHAIN_ALIAS)
            self.storageService = RealmStorageService(kcWrapper: self.kcWrapper, encryptionKey: encryptionKey!)
            // nullify key
            encryptionKey = nil
        }
        return self.storageService!
    }
}
