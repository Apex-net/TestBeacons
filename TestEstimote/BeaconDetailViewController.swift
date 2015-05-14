//
//  BeaconDetailViewController.swift
//  TestEstimote
//
//  Created by Andrea Calisesi on 08/05/15.
//  Copyright (c) 2015 Andrea Calisesi. All rights reserved.
//

import UIKit

class BeaconDetailViewController: UITableViewController {

    var currentBeacon: CLBeacon!
    
    var textDetails: Array<[String : String]> = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // title
        self.navigationItem.title = NSLocalizedString("Detail beacon", comment: "")
        
        // Set Data
        self.prepareArrayForTable()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    
    // MARK: - Set Data for Table view
    
    private func prepareArrayForTable() {
        
        // Append some arrays
        var item : [String : String] = [:]
        item = ["title" : NSLocalizedString("proximityUUID", comment: ""),  "subTitle" : self.currentBeacon.proximityUUID.UUIDString]
        textDetails.append(item)
        item = ["title" : NSLocalizedString("major", comment: ""),  "subTitle" : self.currentBeacon.major.integerValue.description]
        textDetails.append(item)
        item = ["title" : NSLocalizedString("minor", comment: ""),  "subTitle" : self.currentBeacon.minor.integerValue.description]
        textDetails.append(item)
        
        item = ["title" : NSLocalizedString("proximity", comment: ""),  "subTitle" : self.currentBeacon.proximity.rawValue.description]
        textDetails.append(item)
        item = ["title" : NSLocalizedString("accuracy", comment: ""),  "subTitle" : self.currentBeacon.accuracy.description]
        textDetails.append(item)
        item = ["title" : NSLocalizedString("rssi", comment: ""),  "subTitle" : self.currentBeacon.rssi.description]
        textDetails.append(item)
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return textDetails.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        // Configure the cell...
        let cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath) as! UITableViewCell
        
        // Configure the cell...
        let dict = self.textDetails[indexPath.row]
        
        // set texts
        cell.textLabel?.text = dict["title"]!
        cell.detailTextLabel?.text = dict["subTitle"]!

        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
