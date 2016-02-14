
//
//  InfoPostingViewController.swift
//  On-The-Map
//
//  Created by Aditya Ramayanam on 1/30/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import UIKit

class InfoPostingViewController: UIViewController {
    
    @IBOutlet weak var studentLoc: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancel(sender: AnyObject) {
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MainTabbedController") as! UITabBarController
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "infoPostingSegue") {
            let svc = segue.destinationViewController as! InfoPostingDetailViewController
            svc.toPass = studentLoc.text!
        }
    }
}
