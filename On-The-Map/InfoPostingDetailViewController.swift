//
//  InfoPostingDetailViewController.swift
//  On-The-Map
//
//  Created by Aditya Ramayanam on 2/14/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import UIKit

class InfoPostingDetailViewController: UIViewController {
    @IBOutlet weak var passValue: UILabel!
    var toPass: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passValue.text = toPass
    }
}
