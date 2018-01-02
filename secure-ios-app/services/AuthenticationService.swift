//
//  AuthenticationService.swift
//  secure-ios-app
//
//  Created by Wei Li on 09/11/2017.
//  Copyright © 2017 Wei Li. All rights reserved.
//

import Foundation
import AppAuth
import UIKit
import SwiftKeychainWrapper
import Alamofire

protocol AuthenticationService {
    func performAuthentication(presentingViewController viewController:UIViewController, onCompleted: @escaping (Identity?, Error?) -> Void)
    func resumeAuth(url: URL) -> Bool
    func isLoggedIn() -> Bool
    func performLogout(onCompleted: @escaping (Error?) -> Void)
    func currentIdentity() -> Identity?
}

class AppAuthAuthenticationService: AuthenticationService {
    let REDIRECT_URL = URL(string:"com.feedhenry.securenativeandroidtemplate:/callback")
    let KC_AUTH_STATE_KEY = "auth-state"
    
    let authServerConfiguration: AuthServerConfiguration
    let keychainWrapper: KeychainWrapper
    
    var currentAuthorisationFlow: OIDAuthorizationFlowSession?
    var authState: OIDAuthState?
    var identify: Identity?
    var onCompleted: ((Identity?, Error?) -> Void)?
    
    init(authServerConfig: AuthServerConfiguration, kcWrapper: KeychainWrapper) {
        self.authServerConfiguration = authServerConfig
        self.keychainWrapper = kcWrapper
        self.authState = loadState()
        self.identify = getIdentify(authState: self.authState)
    }
    
    func performAuthentication(presentingViewController viewController:UIViewController, onCompleted: @escaping (Identity?, Error?) -> Void) {
        self.onCompleted = onCompleted
        
        let oidServiceConfiguration = OIDServiceConfiguration(authorizationEndpoint: self.authServerConfiguration.authEndpoint, tokenEndpoint: self.authServerConfiguration.tokenEndpoint)
        let oidAuthRequest = OIDAuthorizationRequest(configuration: oidServiceConfiguration, clientId: self.authServerConfiguration.clientId, scopes: [OIDScopeOpenID, OIDScopeProfile], redirectURL: REDIRECT_URL!, responseType: OIDResponseTypeCode, additionalParameters: nil)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.authService = self;
        //this will automatically exchange the token to get the user info
        self.currentAuthorisationFlow = OIDAuthState.authState(byPresenting: oidAuthRequest, presenting: viewController) {
            authState,error in
            if authState != nil && authState?.authorizationError == nil {
                self.authSuccess(authState: authState!)
            } else {
                self.authFailure(authState: authState, error: error)
            }
        }
    }
    
    func resumeAuth(url: URL) -> Bool {
        if self.currentAuthorisationFlow!.resumeAuthorizationFlow(with: url) {
            self.currentAuthorisationFlow = nil;
            return true
        }
        return false
    }
    
    func isLoggedIn() -> Bool {
        return self.identify != nil
    }
    
    func authSuccess(authState: OIDAuthState) {
        Logger.debug("got auth state \(authState.debugDescription)")
        self.assignAuthState(authState: authState)
        self.authCompleted(identify: self.identify, error: nil)
    }
    
    func authFailure(authState: OIDAuthState?, error: Error?) {
        let e = authState?.authorizationError ?? error
        Logger.error("auth error \(e.debugDescription)")
        self.assignAuthState(authState: nil)
        self.authCompleted(identify: nil, error: e)
    }
    
    func authCompleted(identify: Identity?, error: Error?) {
        if (self.onCompleted != nil) {
            self.onCompleted!(identify, error)
        }
    }
    
    func performLogout(onCompleted: @escaping (Error?) -> Void) {
        if self.isLoggedIn() {
            let logoutUrl = self.authServerConfiguration.getLogoutUrl(identityToken: self.authState!.lastTokenResponse!.idToken!)
            Alamofire.request(logoutUrl).validate(statusCode: 200..<300).responseData(completionHandler: {response in
                switch response.result {
                case .success:
                    self.assignAuthState(authState: nil)
                    onCompleted(nil)
                case .failure(let error):
                    onCompleted(error)
                }
            })
        }
    }
    
    func currentIdentity() -> Identity? {
        return self.identify
    }
    
    fileprivate func assignAuthState(authState: OIDAuthState?) {
        self.authState = authState
        self.identify = self.getIdentify(authState: authState)
        self.saveState()
    }
    
    fileprivate func saveState() {
        if self.authState != nil {
            self.keychainWrapper.set(self.authState!, forKey: KC_AUTH_STATE_KEY)
        } else {
            self.keychainWrapper.removeObject(forKey: KC_AUTH_STATE_KEY)
        }
    }
    
    fileprivate func loadState() -> OIDAuthState? {
        guard let loadedState = self.keychainWrapper.object(forKey: KC_AUTH_STATE_KEY) else {
            return nil
        }
        return loadedState as? OIDAuthState
    }
    
    fileprivate func getIdentify(authState: OIDAuthState?) -> Identity? {
        if authState == nil {
            return nil
        }
        return Identity(accessToken: authState!.lastTokenResponse?.accessToken)
    }
}

func base64urlToBase64(base64url: String) -> String {
    var base64 = base64url
        .replacingOccurrences(of: "-", with: "+")
        .replacingOccurrences(of: "_", with: "/")
    if base64.characters.count % 4 != 0 {
        base64.append(String(repeating: "=", count: 4 - base64.characters.count % 4))
    }
    return base64
}

extension Identity {
    init?(accessToken: String?) {
        if accessToken == nil {
            return nil
        }
        let parts = accessToken?.components(separatedBy: ".")
        guard let encodedToken = parts?[1] else {
            return nil
        }
        guard let jsonData = Data(base64Encoded: base64urlToBase64(base64url: encodedToken)) else {
            return nil
        }
        let tokenJson = try? JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
        guard let userName = tokenJson!["name"] as? String,
            let fullName = tokenJson!["name"] as? String,
            let emailAddress = tokenJson!["email"] as? String,
            let realmAccess = tokenJson!["realm_access"] as? [String: [String]],
            let realmRoles = realmAccess["roles"]
        else {
                return nil
        }
        self.userName = userName
        self.fullName = fullName
        self.emailAddress = emailAddress
        self.reamlRoles = realmRoles
    }
}


