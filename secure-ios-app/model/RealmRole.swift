//
//  RealmRole.swift
//  secure-ios-app
//
//  Created by Thomas Nolan on 29/03/2018.
//  Copyright © 2018 Wei Li. All rights reserved.
//

import Foundation

struct RealmRole : Equatable{
    
    var roleName: String
    var roleText: String
    
    static func ==(lhs: RealmRole, rhs: RealmRole) -> Bool {
        return lhs.roleName == rhs.roleName
    }
}

struct RealmRoles {
    static let mobileUser = RealmRole(roleName: "mobile-user", roleText: "Mobile User Role")
    static let apiAccess = RealmRole(roleName: "api-access", roleText: "API Access Role")
    static let superUser = RealmRole(roleName: "superuser", roleText: "Superuser Role")
}
