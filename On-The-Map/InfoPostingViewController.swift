
//
//  InfoPostingViewController.swift
//  On-The-Map
//
//  Created by Aditya Ramayanam on 1/30/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import UIKit
import MapKit

class InfoPostingViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var studentLoc: UITextView!
    
    var mapAnnotation: CLPlacemark!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        studentLoc.delegate = self
        configureUI()
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
                self.errorAlert("Not a valid location")
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
    
    func errorAlert(errorString: String) {
        let alertController = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func configureUI() {
        studentLoc.textContainerInset = UIEdgeInsetsMake(40, 12, 40, 12)
        studentLoc.text = "Enter a location here..."
        studentLoc.textColor = UIColor.lightGrayColor()
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = ""
            textView.textColor = UIColor.whiteColor()
        }
        return true
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        if textView.text.isEmpty {
            textView.text = "Enter a location here..."
            textView.textColor = UIColor.lightGrayColor()
        }
        return true
    }
}
