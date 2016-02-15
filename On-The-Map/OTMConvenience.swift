//
//  OTMConvenience.swift
//  On-The-Map
//
//  Created by Aditya Ramayanam on 2/2/16.
//  Copyright © 2016 Udacity. All rights reserved.
//


import UIKit
import Foundation

// OTMClient (Convenient Resource Methods)

extension OTMClient {
    
    // Authentication (GET) Methods
    func authenticateWithViewController(username: String?, password: String?, hostViewController: UIViewController, completionHandler: (success: Bool, errorString: String?) -> Void) {
        self.getSessionID(username, password: password) { (success, errorString) in
            if success {
                completionHandler(success: success, errorString: errorString)
            } else {
                completionHandler(success: success, errorString: errorString)
            }
        }
    }
    
    func getSessionID(username: String?, password: String?, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let jsonBody : [String:AnyObject] = [
            OTMClient.JSONBodyKeys.udacity: [
                OTMClient.JSONBodyKeys.username: "\(username!)",
                OTMClient.JSONBodyKeys.password: "\(password!)"
            ]
        ]
        
        let url = OTMClient.Constants.baseURLSecureString + OTMClient.Methods.udacityPostSession
        
        /* 2. Make the request */
        taskForPOSTMethod("udacity", urlString: url, jsonBody: jsonBody) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandler(success: false, errorString: "Login Failed (Session ID).")
            } else {
                print("Found \(OTMClient.JSONResponseKeys.SessionID) in \(JSONResult)")
                let accountValues = JSONResult["account"] as? [String: AnyObject]
                OTMStudentLocation.sharedInstance.uniqueKey = accountValues!["key"] as? String
                completionHandler(success: true, errorString: nil)
            }
        }
    }
    
    func getStudentLocations(completionHandler: (results: [OTMStudentLocation]?, errorString: String?) -> Void) {
        
        let parameters: [String: AnyObject] = [
            OTMClient.ParameterKeys.limit: 100,
            OTMClient.ParameterKeys.skip: 400,
            OTMClient.ParameterKeys.order: "updatedAt"
        ]
        
        let url = OTMClient.Constants.baseParseSecureURL + OTMClient.Methods.parseStudentLocation
        
        taskForGETMethod("parse", urlString: url, parameters: parameters) { JSONResult, error in
            if let error = error {
                print(error)
                completionHandler(results: nil, errorString: "Getting student locations failed")
            } else {
                print("Found student locations")
                if let locations = JSONResult[OTMClient.JSONResponseKeys.locationResults] as? [[String: AnyObject]] {
                    var studentLocations = OTMStudentLocation.sharedInstance
                    studentLocations.studentLocationList = OTMStudentLocation.locationsFromResults(locations)
                    completionHandler(results: studentLocations.studentLocationList, errorString: nil)
                } else {
                    completionHandler(results: nil, errorString: "JSONResult was empty")
                }
            }
        }

    }
    
    func queryStudentLocation(completionHandler: (success: Bool, errorString: String?) -> Void) {
        
    }
}
