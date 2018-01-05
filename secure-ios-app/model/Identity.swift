//
//  File.swift
//  secure-ios-app
//
//  Created by Wei Li on 10/11/2017.
//  Copyright © 2017 Wei Li. All rights reserved.
//

import Foundation

struct Identity {
    var userName: String = "Unknown Username"
    var fullName: String = "Unknown Name"
    var emailAddress: String = "Unknown Email"
    var reamlRoles: [String] = []
    
    func hasRole(role: String) -> Bool {
        return self.reamlRoles.contains(role)
    }
}

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
