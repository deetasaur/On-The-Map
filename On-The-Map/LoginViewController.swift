//
//  LoginViewController.swift
//  On-The-Map
//
//  Created by Aditya Ramayanam on 1/30/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwdTextFIeld: UITextField!
    @IBOutlet weak var debugText: UILabel!
    @IBOutlet weak var udacityIcon: UIImageView!
    
    var appDelegate: AppDelegate!
    var session: NSURLSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        /* Get the app delegate */
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        /* Get the shared URL session */
        session = NSURLSession.sharedSession()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func loginButtonTouch(sender: UIButton) {
        if emailTextField.text!.isEmpty {
            self.debugText.text = "Email can't be empty"
            return
        } else if pwdTextFIeld.text!.isEmpty {
            self.debugText.text = "Password can't be empty"
            return
        } else {
            OTMClient.sharedInstance().authenticateWithViewController(emailTextField.text!, password: pwdTextFIeld.text!, hostViewController: self) { (success, errorString) in
                if success {
                    print("Success Authentication")
                    self.completeLogin()
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.debugText.text = errorString
                    }
                }
            }
        }
    }
    
    
    @IBAction func signUp(sender: AnyObject) {
        let app = UIApplication.sharedApplication()
        app.openURL(NSURL(fileURLWithPath: "https://www.udacity.com/account/auth#!/signin"))
    }
    
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MainTabbedController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
    func displayError(errorString: String?) {
        dispatch_async(dispatch_get_main_queue()) {
            if let errorString = errorString {
                self.debugText.text = errorString
            }
        }
    }
    
    func configureUI() {
        debugText.text = ""
        udacityIcon.hidden = false
        padTextField(self.emailTextField)
        padTextField(self.pwdTextFIeld)
    }
    
    func padTextField(textField: UITextField!) {
        let paddingView = UIView(frame: CGRectMake(0, 0, 15, textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = UITextFieldViewMode.Always
        textField.autocapitalizationType = UITextAutocapitalizationType.None
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
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
