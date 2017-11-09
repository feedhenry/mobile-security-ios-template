//
//  AppConfiguration.swift
//  secure-ios-app
//
//  Created by Wei Li on 07/11/2017.
//  Copyright © 2017 Wei Li. All rights reserved.
//

import Foundation

struct AuthServerConfiguration {
    let authServerUrl: URL
    let readmId: String
    let clientId: String
}

struct ApiServerConfiguration {
    let apiServerUrl: URL
}

class AppConfiguration {
    static let API_SERVER_KEY = "api-server"
    static let API_SERVER_URL_KEY = "server-url"
    
    static let AUTH_SERVER_KEY = "auth-server"
    static let AUTH_SERVER_URL_KEY = "auth-server-url"
    static let AUTH_SERVER_REALM_ID_KEY = "realm-id"
    static let AUTH_SERVER_CLIENT_ID_KEY = "client-id"
    
    let authServerConf: AuthServerConfiguration
    let apiServerConf: ApiServerConfiguration
    
    init(_ configuration: NSDictionary) {
        authServerConf = AppConfiguration.initAuthServerConf(configuration.object(forKey: AppConfiguration.AUTH_SERVER_KEY) as! NSDictionary)
        apiServerConf = AppConfiguration.initApiServerConfig(configuration.object(forKey: AppConfiguration.API_SERVER_KEY) as! NSDictionary)
    }
    
    class func initAuthServerConf(_ authServerConfig: NSDictionary) -> AuthServerConfiguration {
        let serverUrl = URL(string: authServerConfig.value(forKey: AppConfiguration.AUTH_SERVER_URL_KEY) as! String)
        let realmId = authServerConfig.value(forKey: AppConfiguration.AUTH_SERVER_REALM_ID_KEY) as! String
        let clientId = authServerConfig.value(forKey: AppConfiguration.AUTH_SERVER_CLIENT_ID_KEY) as! String
        return AuthServerConfiguration(authServerUrl: serverUrl!, readmId: realmId, clientId: clientId)
    }
    
   class func initApiServerConfig(_ apiServerConfig: NSDictionary) -> ApiServerConfiguration {
        let apiServerUrl = URL(string: apiServerConfig.value(forKey: AppConfiguration.API_SERVER_URL_KEY) as! String)
        return ApiServerConfiguration(apiServerUrl: apiServerUrl!)
    }
}
