//
//  EddystoneDiscoveryViewController.swift
//  TestEstimote
//
//  Created by Andrea Calisesi on 20/07/15.
//  Copyright (c) 2015 Andrea Calisesi. All rights reserved.
//

import UIKit

class EddystoneDiscoveryViewController: UITableViewController, ESTEddystoneManagerDelegate {
    
    let eddystoneManager = ESTEddystoneManager()
    
    var namespaceFilter:ESTEddystoneFilterUID!
    
    var beaconsArray: Array<AnyObject> = Array()

    override func viewDidLoad() {
        super.viewDidLoad()

        // title
        self.navigationItem.title = NSLocalizedString("Eddystone", comment: "")
        
        self.eddystoneManager.delegate = self // ESTEddystoneManagerDelegate
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // filter by namespace
        // "EDD1EBEAC04E5DEFA017" is the default namespace ID for estimote
        // you have to define your namespace ID
        let namespaceUID = ESTEddystoneUID(namespaceID: "EDD1EBEAC04E5DEFA017")

        self.namespaceFilter = ESTEddystoneFilterUID(UID: namespaceUID)
        self.eddystoneManager.startEddystoneDiscoveryWithFilter(namespaceFilter)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.eddystoneManager.stopEddystoneDiscoveryWithFilter(self.namespaceFilter)
    }
    

    // MARK: - ESTEddystoneManager Delegate
    func eddystoneManager(manager: ESTEddystoneManager!,
        didDiscoverEddystones eddystones: [AnyObject]!,
        withFilter eddystoneFilter: ESTEddystoneFilter!) {

            println("ESTEddystoneManager Delegate Eddystone count: \(eddystones.count)")
            
            // check for filter
            if eddystoneFilter == self.namespaceFilter {
                self.beaconsArray = eddystones
            }
            
            self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.beaconsArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("eddystone", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        if let beacon = beaconsArray[indexPath.row] as? ESTEddystone {
            
            // set texts
            if beacon.url != nil {
                cell.textLabel?.text = "\(beacon.macAddress) / \(beacon.url)"
            }
            else {
                cell.textLabel?.text = "\(beacon.macAddress)"
            }
            if beacon.telemetry != nil {
                cell.detailTextLabel?.text = "RSSI: \(beacon.rssi) Battery: \(beacon.telemetry.battery) Temp:  \(beacon.telemetry.temperature)"
            }
            else {
                cell.detailTextLabel?.text = "RSSI: \(beacon.rssi)"
            }

            
        }

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
