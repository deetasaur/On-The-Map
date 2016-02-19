//
//  InfoPostingDetailViewController.swift
//  On-The-Map
//
//  Created by Aditya Ramayanam on 2/14/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import UIKit
import MapKit

class InfoPostingDetailViewController: UIViewController {
    
    @IBOutlet weak var mapLocation: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var mediaURL: UITextView!
    
    var textLocation: String!
    var mapAnnotation: CLPlacemark!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        OTMStudentLocation.sharedInstance.latitude = Double(mapAnnotation.location!.coordinate.latitude)
        OTMStudentLocation.sharedInstance.longitude = Double(mapAnnotation.location!.coordinate.longitude)
        OTMStudentLocation.sharedInstance.mapString = textLocation
        
        mapLocation.addAnnotation(MKPlacemark(placemark: mapAnnotation))
        //mapLocation.camera.altitude = 100000.0
        mapLocation.setCenterCoordinate(mapAnnotation.location!.coordinate, animated: true)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MainTabbedController") as! UITabBarController
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func submit(sender: AnyObject) {
        if(mediaURL.text.isEmpty) {
            let alertController = UIAlertController(title: "Error", message: "Please enter a URL", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            OTMClient.sharedInstance().getUserData() { (success, errorString) in
                if(success) {
                    print("Found all student values for \(OTMStudentLocation.sharedInstance.firstName!) \(OTMStudentLocation.sharedInstance.lastName!)")
                    OTMStudentLocation.sharedInstance.mediaURL = self.mediaURL.text
                    self.submitLocation()
                } else {
                    print("Could not find all student values")
                }
            }
        }
    }
    
    func submitLocation() {
        OTMClient.sharedInstance().postStudentLocation() { (success, errorString) in
            if(success) {
                print("Successfully submitted location")
                dispatch_async(dispatch_get_main_queue()) {
                    let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MainTabbedController") as! UITabBarController
                    self.presentViewController(controller, animated: true, completion: nil)
                }
            } else {
                print("Location submission errored out")
            }
        }
    }
}
