//
//  OTMConvenience.swift
//  On-The-Map
//
//  Created by Aditya Ramayanam on 2/2/16.
//  Copyright © 2016 Udacity. All rights reserved.
//


import UIKit
import Foundation

// MARK: - TMDBClient (Convenient Resource Methods)

extension OTMClient {
    
    // MARK: Authentication (GET) Methods
    /*
    Steps for Authentication...
    https://www.themoviedb.org/documentation/api/sessions
    
    Step 1: Create a new request token
    Step 2a: Ask the user for permission via the website
    Step 3: Create a session ID
    Bonus Step: Go ahead and get the user id 😎!
    */
    func authenticateWithViewController(username: String?, password: String?, hostViewController: UIViewController, completionHandler: (success: Bool, errorString: String?) -> Void) {
        self.getSessionID(username, password: password) { (success, errorString) in
            if success {
                /* Success! We have the sessionID! */
                print("Found session ID")
                completionHandler(success: success, errorString: errorString)
            } else {
                completionHandler(success: success, errorString: errorString)
            }
        }
    }
    
    func getSessionID(username: String?, password: String?, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [OTMClient.ParameterKeys.username : username!,
                          OTMClient.ParameterKeys.password : password!]
        
        /* 2. Make the request */
        taskForPOSTMethod("", parameters: parameters, jsonBody: [String:AnyObject]()) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandler(success: false, errorString: "Login Failed (Session ID).")
            } else {
                print("Found \(OTMClient.JSONResponseKeys.SessionID) in \(JSONResult)")
                completionHandler(success: true, errorString: nil)
            }
        }
    }
}
