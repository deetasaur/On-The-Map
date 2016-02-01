//
//  StudentLocation.swift
//  On-The-Map
//
//  Created by Aditya Ramayanam on 2/1/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import UIKit

struct StudentLocation {
    
    var longitude = 0
    var latitude = 0
    var firstName = ""
    var lastName = ""
    var mediaURL: String? = nil
    
    init(dictionary: [String : AnyObject]) {
        longitude = dictionary["longitude"] as! Int
        latitude  = dictionary["latitude"] as! Int
        firstName = dictionary["firstName"] as! String
        lastName  = dictionary["lastName"] as! String
        mediaURL  = dictionary["mediaURL"] as? String
    }
    
    static func locationsFromResults(results: [[String : AnyObject]]) -> [StudentLocation] {
        var locations = [StudentLocation]()
        
        for result in results {
            locations.append(StudentLocation(dictionary: result))
        }
        
        return locations
    }
}
