//
//  LoginViewController.swift
//  On-The-Map
//
//  Created by Aditya Ramayanam on 1/30/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwdTextFIeld: UITextField!
    @IBOutlet weak var udacityIcon: UIImageView!
    
    var appDelegate: AppDelegate!
    var session: NSURLSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        self.emailTextField.delegate = self
        self.pwdTextFIeld.delegate = self
        
        /* Get the app delegate */
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        /* Get the shared URL session */
        session = NSURLSession.sharedSession()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func loginButtonTouch(sender: UIButton) {
        if emailTextField.text!.isEmpty {
            errorAlert("Email can't be empty")
            return
        } else if pwdTextFIeld.text!.isEmpty {
            errorAlert("Password can't be empty")
            return
        } else {
            OTMClient.sharedInstance().authenticateWithViewController(emailTextField.text!, password: pwdTextFIeld.text!, hostViewController: self) { (success, errorString) in
                if success {
                    print("Success Authentication")
                    self.completeLogin()
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.errorAlert(errorString!)
                    }
                }
            }
        }
    }
    
    
    @IBAction func signUp(sender: AnyObject) {
        let app = UIApplication.sharedApplication()
        app.openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signin")!)
    }
    
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MainTabbedController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
    func errorAlert(errorString: String) {
        let alertController = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func configureUI() {
        udacityIcon.hidden = false
        self.emailTextField.text = ""
        self.pwdTextFIeld.text = ""
        padTextField(self.emailTextField)
        padTextField(self.pwdTextFIeld)
    }
    
    func padTextField(textField: UITextField!) {
        let paddingView = UIView(frame: CGRectMake(0, 0, 15, textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = UITextFieldViewMode.Always
        textField.autocapitalizationType = UITextAutocapitalizationType.None
        textField.autocorrectionType = UITextAutocorrectionType.No
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    // Move the image screen up based on keyboard height
    func keyboardWillShow(notification: NSNotification) {
        if(udacityIcon.hidden == false) {
            view.frame.origin.y -= getKeyboardHeight(notification)
            udacityIcon.hidden = true
        }
    }
    
    // Move the image screen down based on keyboard height
    func keyboardWillHide(notification: NSNotification) {
        if(udacityIcon.hidden == true) {
            view.frame.origin.y += getKeyboardHeight(notification)
            udacityIcon.hidden = false
        }
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
