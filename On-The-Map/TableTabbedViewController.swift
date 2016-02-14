//
//  TableTabbedViewController.swift
//  On-The-Map
//
//  Created by Aditya Ramayanam on 1/30/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import UIKit

class TableTabbedViewController: UIViewController {
    
    var locations : [OTMStudentLocation] = []
    
    @IBOutlet weak var studentLocTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTableLocations()
    }
    
    @IBAction func refresh() {
        getTableLocations()
    }
    
    @IBAction func logout(sender: AnyObject) {
    }
    
    @IBAction func infoPosting(sender: AnyObject) {
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("InfoPostingViewController") 
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func getTableLocations() {
        OTMClient.sharedInstance().getStudentLocations() { (results, errorString) in
            if(results != nil) {
                dispatch_async(dispatch_get_main_queue()) {
                    self.locations = results!
                    self.studentLocTable.reloadData()
                }
            } else {
                print("Didn't get student locations")
            }
        }
    }

}

extension TableTabbedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let cellReuseIdentifier = "StudentTableViewCell"
        let location = locations[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        
        
        /* Set cell defaults */
        cell.textLabel!.text = location.firstName! + " " + location.lastName!
        cell.imageView!.image = UIImage(named: "Pin")
        cell.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let app = UIApplication.sharedApplication()
        let location = locations[indexPath.row]
        let mediaURL = location.mediaURL
        app.openURL(NSURL(string: mediaURL!)!)
    }
}

