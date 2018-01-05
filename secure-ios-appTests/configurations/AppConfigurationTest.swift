//
//  AppConfigurationTest.swift
//  secure-ios-appTests
//
//  Created by Wei Li on 04/01/2018.
//  Copyright © 2018 Wei Li. All rights reserved.
//

import XCTest
@testable import secure_ios_app

class AppConfigurationTest: XCTestCase {
    
    var appConfigurationToTest: AppConfiguration!
    let configDict: NSDictionary = ["api-server": ["server-url": "http://server.example.com"], "auth-server": ["auth-server-url": "http://auth.example.com", "realm-id": "test-realm", "client-id": "test-client"] ]
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        appConfigurationToTest = AppConfiguration(configDict)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        appConfigurationToTest = nil
        super.tearDown()
    }
    
    func testApiServerConfig() {
        let apiServerConfig = appConfigurationToTest.apiServerConf
        XCTAssertNotNil(apiServerConfig)
        
        let apiServerDict = configDict.object(forKey: "api-server") as! NSDictionary
        
        let apiServerUrl = apiServerConfig.apiServerUrl
        XCTAssertEqual(apiServerUrl.absoluteString, apiServerDict.value(forKey: "server-url") as! String)
    }
    
    func testAuthServerConfig() {
        let authServerConfig = appConfigurationToTest.authServerConf
        XCTAssertNotNil(authServerConfig)
        
        let authServerDict = configDict.object(forKey: "auth-server") as! NSDictionary
        let authServerUrl = authServerDict.value(forKey: "auth-server-url") as! String
        let realmId = authServerDict.value(forKey: "realm-id") as! String
        let clientId = authServerDict.value(forKey: "client-id") as! String
        
        let authEndpoint = authServerConfig.authEndpoint
        XCTAssertEqual(authEndpoint.absoluteString, "\(authServerUrl)/auth/realms/\(realmId)/protocol/openid-connect/auth")
        
        let tokenEndpoint = authServerConfig.tokenEndpoint
        XCTAssertEqual(tokenEndpoint.absoluteString, "\(authServerUrl)/auth/realms/\(realmId)/protocol/openid-connect/token")
        
        let testIdentityToken = "test"
        let logoutUrl = authServerConfig.getLogoutUrl(identityToken: testIdentityToken)
        XCTAssertEqual(logoutUrl.absoluteString, "\(authServerUrl)/auth/realms/\(realmId)/protocol/openid-connect/logout?id_token_hint=\(testIdentityToken)")
    }
    
}
