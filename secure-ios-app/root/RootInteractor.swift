//
//  RootInteractor.swift
//  secure-ios-app
//
//  Created by Wei Li on 08/11/2017.
//  Copyright © 2017 Wei Li. All rights reserved.
//

import Foundation

protocol MenuListener {
    func onMenuItemSelected(_ item: MenuItem)
}

/*
 Specify the business logic of the app.
 It should handle the user's actions (received from the view controller), perform any required operations (business logic), and then use the router to navigate the views and pass data around if required.
 */
protocol RootInteractor: MenuListener {
    var router: RootRouter? {get set}
}

class RootInteractorImpl: RootInteractor {
    
    var router: RootRouter?
    
    func onMenuItemSelected(_ item: MenuItem) {
        switch item.title {
        case RootViewController.MENU_HOME_TITLE:
            router?.launchHomeView()
        case RootViewController.MENU_AUTHENTICATION_TITLE:
            router?.launchAuthenticationView()
        case RootViewController.MENU_STORAGE_TITLE:
            router?.launchStorageView()
        default:
            print("no view to show")
        }
    }
    
}
