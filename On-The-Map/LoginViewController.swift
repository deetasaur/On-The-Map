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
            //getSessionID()
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
    
    func getSessionID() {
        let request = NSMutableURLRequest(URL: NSURL(string: self.appDelegate.baseURLSecureString)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(self.emailTextField.text!)\", \"password\": \"\(self.pwdTextFIeld.text!)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                dispatch_async(dispatch_get_main_queue()) {
                }
                print("There was an error with your request: \(error)")
                return
            }

            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                dispatch_async(dispatch_get_main_queue()) {
                }
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }

            /* GUARD: Was there any data returned? */
            guard let data = data else {
                dispatch_async(dispatch_get_main_queue()) {
                }
                print("No data was returned by the request!")
                return
            }

            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            let parsedResult = NSString(data: newData, encoding: NSUTF8StringEncoding)
            //print(parsedResult)
            self.completeLogin()
        }
        task.resume()
    }    
}
