//
//  OTMConstants.swift
//  On-The-Map
//
//  Created by Aditya Ramayanam on 2/2/16.
//  Copyright © 2016 Udacity. All rights reserved.
//


extension OTMClient {
    
    // Constants
    struct Constants {
        
        /* Constants for Udacity */
        static let baseURLSecureString = "https://www.udacity.com/api/"
        
        /* Constants for Parse */
        static let baseParseSecureURL = "https://api.parse.com/1/classes/"
        static let parseAppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let restApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    // Methods
    struct Methods {
        static let udacityUserData = "users/{id}"
        static let udacityPostSession = "session"
        static let udacityDeleteSession = "session"
        
        static let parseStudentLocation = "StudentLocation"
        static let updateStudentLocation = "StudentLocation/{objectId}"
    }
    
    // Parameter Keys
    struct ParameterKeys {
        static let limit = "limit"
        static let skip = "skip"
        static let order = "order"
    }
    
    // JSON Body Keys
    struct JSONBodyKeys {
        static let udacity = "udacity"
        static let username = "username"
        static let password = "password"
    }
    
    // JSON Response Keys
    struct JSONResponseKeys {
        static let SessionID = "session"
        static let locationResults = "results"
        
        static let createdAt = "createdAt"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let objectId = "objectId"
        static let uniqueKey = "uniqueKey"
        static let updatedAt = "updatedAt"
    }
    

}

