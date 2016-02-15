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
    
    var studentLocation = OTMStudentLocation.sharedInstance
    var textLocation: String!
    var mapAnnotation: CLPlacemark!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        studentLocation.latitude = Double(mapAnnotation.location!.coordinate.latitude)
        studentLocation.longitude = Double(mapAnnotation.location!.coordinate.longitude)
        studentLocation.mapString = textLocation
        
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
            OTMClient.sharedInstance().queryStudentLocation() { (success, errorString) in
                self.studentLocation.mediaURL = self.mediaURL.text
            }
        }
    }
}
