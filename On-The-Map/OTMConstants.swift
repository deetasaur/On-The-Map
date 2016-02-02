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
        let baseURLSecureString = "https://www.udacity.com/api/session"
        
        /* Constants for Parse */
        let parseAppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        let restApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
    }
    
    // Parameter Keys
    struct ParameterKeys {
        
        static let username = "username"
        static let password = "password"
        
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        static let SessionID = "session"
    }
    

}

