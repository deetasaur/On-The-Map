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
        self.postSessionID(username, password: password) { (success, errorString) in
            if success {
                completionHandler(success: success, errorString: errorString)
            } else {
                completionHandler(success: success, errorString: errorString)
            }
        }
    }
    
    func postSessionID(username: String?, password: String?, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
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
                completionHandler(success: false, errorString: error.domain)
            } else {
                print("Got session")
                guard let accountValues = JSONResult[OTMClient.JSONResponseKeys.account] as? [String: AnyObject] else {
                    print("Problem with \(OTMClient.JSONResponseKeys.SessionID) in \(JSONResult)")
                    return
                }
                OTMStudentLocation.sharedInstance.uniqueKey = accountValues["key"] as? String
                completionHandler(success: true, errorString: nil)
            }
        }
    }
    
    func logoutSession(completionHandler: (success: Bool, errorString: String?) -> Void) {
        let url = OTMClient.Constants.baseURLSecureString + OTMClient.Methods.udacityDeleteSession
        taskForDeleteMethod(url) { JSONResult, error in
            if let error = error {
                print(error)
                completionHandler(success: false, errorString: "Logout Failed")
            } else {
                print("Sucessfully Logged Out")
                completionHandler(success: true, errorString: nil)
            }
        }
    }
    
    func getStudentLocations(completionHandler: (results: [OTMStudentLocation]?, errorString: String?) -> Void) {
        
        let parameters: [String: AnyObject] = [
            OTMClient.ParameterKeys.limit: 100,
            OTMClient.ParameterKeys.skip: 400,
            OTMClient.ParameterKeys.order: "-updatedAt"
        ]
        
        let url = OTMClient.Constants.baseParseSecureURL + OTMClient.Methods.parseStudentLocation
        
        taskForGETMethod("parse", urlString: url, parameters: parameters) { JSONResult, error in
            if let error = error {
                print(error)
                completionHandler(results: nil, errorString: "Getting all student locations failed")
            } else {
                if let locations = JSONResult[OTMClient.JSONResponseKeys.locationResults] as? [[String: AnyObject]] {
                    OTMStudentLocation.sharedInstance.studentLocationList = OTMStudentLocation.locationsFromResults(locations)
                    completionHandler(results: OTMStudentLocation.sharedInstance.studentLocationList, errorString: nil)
                } else {
                    completionHandler(results: nil, errorString: "JSONResult was empty")
                }
            }
        }

    }
    
    func postStudentLocation(completionHandler: (success:Bool, errorString: String?) -> Void) {
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let jsonBody : [String:AnyObject] = [
            OTMClient.JSONResponseKeys.uniqueKey: "\(OTMStudentLocation.sharedInstance.uniqueKey!)",
            OTMClient.JSONResponseKeys.firstName: "\(OTMStudentLocation.sharedInstance.firstName!)",
            OTMClient.JSONResponseKeys.lastName: "\(OTMStudentLocation.sharedInstance.lastName!)",
            OTMClient.JSONResponseKeys.mapString: "\(OTMStudentLocation.sharedInstance.mapString!)",
            OTMClient.JSONResponseKeys.mediaURL: "\(OTMStudentLocation.sharedInstance.mediaURL!)",
            OTMClient.JSONResponseKeys.latitude: OTMStudentLocation.sharedInstance.latitude!,
            OTMClient.JSONResponseKeys.longitude: OTMStudentLocation.sharedInstance.longitude!
        ]
        
        let url = OTMClient.Constants.baseParseSecureURL + OTMClient.Methods.updateStudentLocation
        
        taskForPOSTMethod("parse", urlString: url, jsonBody: jsonBody) { JSONResult, error in
            if let error = error {
                print(error)
                completionHandler(success: false, errorString: "Posting Student Location failed")
            } else {
                completionHandler(success: true, errorString: nil)
            }
        }
    }
    
    func getUserData(completionHandler: (success: Bool, errorString: String?) -> Void) {
        let url = OTMClient.Constants.baseURLSecureString + OTMClient.Methods.udacityUserData
        let value = OTMStudentLocation.sharedInstance.uniqueKey!
        
        let newURL = OTMClient.subtituteKeyInMethod(url, key: OTMClient.ParameterKeys.id, value: value)
        
        taskForGETMethod("udacity", urlString: newURL!, parameters: [String:AnyObject]()) { JSONResult, error in
            if let error = error {
                print(error)
                completionHandler(success: false, errorString: "Getting student data failed")
            } else {
                if let student = JSONResult["user"] as? [String: AnyObject] {
                    OTMStudentLocation.sharedInstance.firstName = student["first_name"] as? String
                    OTMStudentLocation.sharedInstance.lastName = student["last_name"] as? String
                    completionHandler(success: true, errorString: nil)
                } else {
                    completionHandler(success: false, errorString: "JSONResult was empty")
                }
            }
        }
    }
}
