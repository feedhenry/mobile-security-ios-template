//
//  AppConfiguration.swift
//  secure-ios-app
//
//  Created by Wei Li on 07/11/2017.
//  Copyright © 2017 Wei Li. All rights reserved.
//

import Foundation

struct AuthServerConfiguration {
//    let authServerUrl: URL
//    let realmId: String
//    let clientId: String
//    var clientSecret: String?
//
//    var authEndpoint: URL {
//        get {
//            return self.authServerUrl.appendingPathComponent("/auth/realms/\(realmId)/protocol/openid-connect/auth")
//        }
//    }
//
//    var tokenEndpoint: URL {
//        get {
//            return self.authServerUrl.appendingPathComponent("/auth/realms/\(realmId)/protocol/openid-connect/token")
//        }
//    }
//
//    func getLogoutUrl(identityToken: String) -> URL {
//        let queryItems = [NSURLQueryItem(name: "id_token_hint", value: identityToken)]
//        let urlComps = NSURLComponents(string: self.authServerUrl.appendingPathComponent("/auth/realms/\(realmId)/protocol/openid-connect/logout").absoluteString)!
//        urlComps.queryItems = queryItems as [URLQueryItem]
//        let fullurl = urlComps.url!
//        return fullurl
//    }
}

struct ApiServerConfiguration {
    let apiServerUrl: URL
}

class AppConfiguration {
    static let API_SERVER_KEY = "api-server"
    static let API_SERVER_URL_KEY = "server-url"

//    static let AUTH_SERVER_KEY = "auth-server"
//    static let AUTH_SERVER_URL_KEY = "auth-server-url"
//    static let AUTH_SERVER_REALM_ID_KEY = "realm-id"
//    static let AUTH_SERVER_CLIENT_ID_KEY = "client-id"
//    static let AUTH_SERVER_CLIENT_SECRET_KEY = "client-secret"
    
//    let authServerConf: AuthServerConfiguration
    let apiServerConf: ApiServerConfiguration
    
    init(_ configuration: NSDictionary) {
//        authServerConf = AppConfiguration.initAuthServerConf(configuration.object(forKey: AppConfiguration.AUTH_SERVER_KEY) as! NSDictionary)
        apiServerConf = AppConfiguration.initApiServerConfig(configuration.object(forKey: AppConfiguration.API_SERVER_KEY) as! NSDictionary)
    }
    
//    class func initAuthServerConf(_ authServerConfig: NSDictionary) -> AuthServerConfiguration {
//        let serverUrl = URL(string: authServerConfig.value(forKey: AppConfiguration.AUTH_SERVER_URL_KEY) as! String)
//        let realmId = authServerConfig.value(forKey: AppConfiguration.AUTH_SERVER_REALM_ID_KEY) as! String
//        let clientId = authServerConfig.value(forKey: AppConfiguration.AUTH_SERVER_CLIENT_ID_KEY) as! String
//        let clientSecret = authServerConfig.value(forKey: AppConfiguration.AUTH_SERVER_CLIENT_SECRET_KEY) as? String
//
//        return AuthServerConfiguration(authServerUrl: serverUrl!, realmId: realmId, clientId: clientId, clientSecret: clientSecret)
//    }
    
   class func initApiServerConfig(_ apiServerConfig: NSDictionary) -> ApiServerConfiguration {
        let apiServerUrl = URL(string: apiServerConfig.value(forKey: AppConfiguration.API_SERVER_URL_KEY) as! String)
        return ApiServerConfiguration(apiServerUrl: apiServerUrl!)
    }
}
