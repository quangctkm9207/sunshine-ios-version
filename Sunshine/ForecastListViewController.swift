//
//  ViewController.swift
//  Sunshine
//
//  Created by Quang Nguyen on 3/22/16.
//  Copyright © 2016 Quang Nguyen. All rights reserved.
//

import UIKit
import Foundation

class ForecastListViewController: UITableViewController {

    let data = [
        "March 22 - Clear - 32/22",
        "March 23 - Rain - 28/20",
        "March 24 - Clear - 32/22",
        "March 25 - Rain - 28/20",
        "March 26 - Clear - 32/22",
        "March 27 - Rain - 28/20",
        "March 28 - Clear - 32/22"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //Get reusable cell by identifier
        let cell = tableView.dequeueReusableCellWithIdentifier("ForecastCell")!
        
        //Get the data for exact cell
        let forecastStr = data[indexPath.row]
        
        //Populate the data to the cell
        cell.textLabel?.text = forecastStr
        
        return cell
    }


}

