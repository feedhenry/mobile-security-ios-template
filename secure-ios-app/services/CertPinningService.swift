//
//  CertPinningService.swift
//  secure-ios-app
//
//  Created by Tom Jackman on 02/01/2018.
//  Copyright © 2018 Wei Li. All rights reserved.
//

import Foundation
import Alamofire

protocol CertPinningService {
    func performValidCertCheck(url: String?, onCompleted: @escaping (Bool) -> Void)
}

class iosCertPinningService: CertPinningService {
    var appConfiguration: AppConfiguration
    
    /*
     - Init function
     
     - Parameter appConfiguration - the app configuration
     */
    init(appConfiguration: AppConfiguration) {
        self.appConfiguration = appConfiguration
    }
    
    // tag::performValidCertCheck[]
    /*
     - Checks if the servers presented cert matches a pin from the pinset
     
     - Parameter url - the url of the host to check. If no URL is provided, the auth server will be tested by default.
     
     - Parameter onCompleted - a completion handler that returns the result of the cert check. A true value means that the cert pinning validated successfully. A false value means there was a validation issue which resulted in a pin verification failure.
     */
    func performValidCertCheck(url:String? = nil, onCompleted: @escaping (Bool) -> Void) {
        let requestURL = url ?? "\(self.appConfiguration.authServerConf.authServerUrl)/auth/"
        
        Alamofire.request(requestURL).validate(statusCode: 200..<300).responseData(completionHandler: {response in
            switch response.result {
            case .success:
                onCompleted(true)
            case .failure(let error):
                if(!self.checkPinningFailed(error: error)) {
                    // error is not cert pinning related
                    onCompleted(true)
                } else {
                    onCompleted(false)
                }
            }
        })
    }
    // end::performValidCertCheck[]
    
    // tag::checkPinningFailed[]
    /*
     - Checks if the presented error was caused by a pinning validation failure
     
     - Parameter error - The error to check.
     
     - Returns - Boolean. Returns true if the error was due to a pinning issue.
     */
    func checkPinningFailed(error: Error) -> Bool {
        if let error = error as? NSError {
            // check for the alamofire cancelled/error code 999 to check if there was an SSL issue
            if error.code == NSURLErrorCancelled {
                return true
            } else {
                // error was not caused by a pinning failure
                return false
            }
        }
    }
    // end::checkPinningFailed[]
}
