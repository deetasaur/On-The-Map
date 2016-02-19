
//
//  InfoPostingViewController.swift
//  On-The-Map
//
//  Created by Aditya Ramayanam on 1/30/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import UIKit
import MapKit

class InfoPostingViewController: UIViewController {
    
    @IBOutlet weak var studentLoc: UITextView!
    
    var mapAnnotation: CLPlacemark!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancel(sender: AnyObject) {
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MainTabbedController") as! UITabBarController
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func findLocation(sender: AnyObject) {
        validateLocation() { (success, errorString) in
            if(success == true) {
                self.performSegueWithIdentifier("infoPostingSegue", sender: self)
            }
            else {
                print("Invalid Location")
                let alertController = UIAlertController(title: "Error", message: "Not a valid location", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "infoPostingSegue") {
            let svc = segue.destinationViewController as! InfoPostingDetailViewController
            svc.textLocation = studentLoc.text!
            svc.mapAnnotation = self.mapAnnotation
        }
    }
    
    func validateLocation(completionHandler: (success: Bool, errorString: String?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(studentLoc.text!, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            if let placemark = placemarks?[0] {
                print("Found location")
                self.mapAnnotation = placemark
                completionHandler(success: true, errorString: error?.description)
            }
            else {
                print("Could not find location")
                completionHandler(success: false, errorString: error?.description)
            }
        })
    }
}
