//
//  TableTabbedViewController.swift
//  On-The-Map
//
//  Created by Aditya Ramayanam on 1/30/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import UIKit

class TableTabbedViewController: UIViewController {
    
    @IBOutlet weak var studentLocTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTableLocations()
    }
    
    @IBAction func refresh() {
        getTableLocations()
    }
    
    @IBAction func logout(sender: AnyObject) {
        OTMClient.sharedInstance().logoutSession() { (success, errorString) in
            if(success) {
                dispatch_async(dispatch_get_main_queue()) {
                    self.dismissViewControllerAnimated(false, completion: nil)
                }
            } else {
                print("Failed to log out")
                self.errorAlert("Logout failed")
            }
        }
    }
    
    @IBAction func infoPosting(sender: AnyObject) {
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("InfoPostingViewController") 
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func getTableLocations() {
        OTMClient.sharedInstance().getStudentLocations() { (results, errorString) in
            if(results != nil) {
                dispatch_async(dispatch_get_main_queue()) {
                    self.studentLocTable.reloadData()
                }
            } else {
                print("Didn't get student locations")
                self.errorAlert("Could not download student locations")
            }
        }
    }

}

extension TableTabbedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let cellReuseIdentifier = "StudentTableViewCell"
        let location = OTMStudentLocation.sharedInstance.studentLocationList [indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        
        
        /* Set cell defaults */
        cell.textLabel!.text = location.firstName! + " " + location.lastName!
        cell.imageView!.image = UIImage(named: "Pin")
        cell.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OTMStudentLocation.sharedInstance.studentLocationList .count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let app = UIApplication.sharedApplication()
        let location = OTMStudentLocation.sharedInstance.studentLocationList [indexPath.row]
        let mediaURL = location.mediaURL
        app.openURL(NSURL(string: mediaURL!)!)
    }
    
    func errorAlert(errorString: String) {
        let alertController = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

