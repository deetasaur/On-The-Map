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
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var fbLoginButton: UIButton!
    
    var appDelegate: AppDelegate!
    var session: NSURLSession!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Get the app delegate */
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        /* Get the shared URL session */
        session = NSURLSession.sharedSession()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func loginButtonTouch(sender: UIButton) {
        if emailTextField.text!.isEmpty {
            print("Email can't be empty")
            return
        } else if pwdTextFIeld.text!.isEmpty {
            print("Password can't be empty")
            return
        } else {
            OTMClient.sharedInstance().authenticateWithViewController(emailTextField.text!, password: pwdTextFIeld.text!, hostViewController: self) { (success, errorString) in
                if success {
                    print("Success Authentication")
                    self.completeLogin()
                } else {
                    print("Failed Authentication")
                }
            }
        }
    }
    
    @IBAction func fbLoginButtonTouch(sender: UIButton) {
    }
    
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MainTabbedController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
}
