//
//  OTMStudentLocation.swift
//  On-The-Map
//
//  Created by Aditya Ramayanam on 2/2/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

struct OTMStudentLocation {
    
    var createdAt: String? = nil
    var firstName: String? = nil
    var lastName: String? = nil
    var latitude: Double?
    var longitude: Double?
    var mapString: String? = nil
    var mediaURL: String? = nil
    var objectId: String? = nil
    var uniqueKey: String? = nil
    var updatedAt: String? = nil
    
    static var sharedInstance = OTMStudentLocation()
    var studentLocationList = [OTMStudentLocation]()
    
    init() {
        createdAt = ""
        firstName = ""
        lastName = ""
        latitude = 0.0
        longitude = 0.0
        mapString = ""
        mediaURL = ""
        objectId = ""
        uniqueKey = ""
        updatedAt = ""
    }
    
    init(dictionary: [String : AnyObject]) {
        createdAt = dictionary[OTMClient.JSONResponseKeys.createdAt] as? String
        firstName = dictionary[OTMClient.JSONResponseKeys.firstName] as? String
        lastName  = dictionary[OTMClient.JSONResponseKeys.lastName] as? String
        mapString = dictionary[OTMClient.JSONResponseKeys.mapString] as? String
        mediaURL  = dictionary[OTMClient.JSONResponseKeys.mediaURL] as? String
        objectId  = dictionary[OTMClient.JSONResponseKeys.objectId] as? String
        updatedAt = dictionary[OTMClient.JSONResponseKeys.updatedAt] as? String
        uniqueKey = dictionary[OTMClient.JSONResponseKeys.uniqueKey] as? String

        latitude  = dictionary[OTMClient.JSONResponseKeys.latitude] as? Double
        longitude = dictionary[OTMClient.JSONResponseKeys.longitude] as? Double
    }
    
    /* Helper: Given an array of dictionaries, convert them to an array of OTMStudentLocation objects */
    static func locationsFromResults(results: [[String : AnyObject]]) -> [OTMStudentLocation] {
        var locations = [OTMStudentLocation]()
        
        for result in results {
            locations.append(OTMStudentLocation(dictionary: result))
        }
        
        return locations
    }
    
}