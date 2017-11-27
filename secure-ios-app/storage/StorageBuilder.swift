//
//  StorageBuilder.swift
//  secure-ios-app
//
//  Created by Tom Jackman on 20/11/2017.
//  Copyright © 2017 Wei Li. All rights reserved.
//

import Foundation
import UIKit

/*
 Builder class for the storage module.
 */
class StorageBuilder {
    
    let appComponents: AppComponents
    
    init(appComponents: AppComponents) {
        self.appComponents = appComponents
    }
    
    func build() -> StorageRouter {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let storageStoryboardId = "StorageViewController"
        
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: storageStoryboardId) as! StorageViewController
        
        let storageListRouter = StorageRouterImpl(viewController: viewController)
        
        let storageInteractor = StorageInteractorImpl(storageService: self.appComponents.resolveStorageService())
        storageInteractor.router = storageListRouter
        
        viewController.storageListener = storageInteractor
        return storageListRouter
    }
}

