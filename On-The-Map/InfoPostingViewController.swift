
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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var mapAnnotation: CLPlacemark!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        studentLoc.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        configureUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func findLocation(sender: AnyObject) {
        activityIndicator.startAnimating()
        activityIndicator.hidden = false
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
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
                print("Found location")
                self.mapAnnotation = placemark
                completionHandler(success: true, errorString: error?.description)
            }
            else {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
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
        activityIndicator.hidden = true
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
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
    
    // Move the image screen up based on keyboard height
    func keyboardWillShow(notification: NSNotification) {
        view.frame.origin.y -= (getKeyboardHeight(notification)/2)
    }
    
    // Move the image screen down based on keyboard height
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y += (getKeyboardHeight(notification)/2)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    // Set notifications for whenever the user selects and dismisses the keyboard
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
}
