//
//  RadarViewController.swift
//  TestEstimote
//
//  Created by Andrea Calisesi on 08/05/15.
//  Copyright (c) 2015 Andrea Calisesi. All rights reserved.
//

import UIKit

class RadarViewController: UITableViewController, ESTBeaconManagerDelegate {
    
    let beaconManager = ESTBeaconManager()
    
    let beaconRegion = CLBeaconRegion(
        proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D"),
        identifier: "Apex-net Radar")
    
    // Right NavBar
    private var startBarItem : UIBarButtonItem?
    private var stopBarItem : UIBarButtonItem?
    
    var beaconsArray: Array<AnyObject> = Array()

    /*
    Blue: 15459
    Purple: 47721
    Green: 59038
    */
    let colors = [
        15459: UIColor(red: 84/255, green: 77/255, blue: 160/255, alpha: 1),
        47721: UIColor(red: 142/255, green: 212/255, blue: 220/255, alpha: 1),
        59038: UIColor(red: 162/255, green: 213/255, blue: 181/255, alpha: 1)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // title
        self.navigationItem.title = NSLocalizedString("All Beacons", comment: "")
        
        // beacon setup
        beaconManager.delegate = self
        
        // buttons
        var buttons: [UIBarButtonItem] = []
        // stop
        if let image = UIImage(named: "1243-stop-toolbar"){
            self.stopBarItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Plain, target: self, action: "stopAction:")
            buttons.append(self.stopBarItem!)
        }
        // start
        if let image = UIImage(named: "1241-play-toolbar"){
            self.startBarItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Plain, target: self, action: "startAction:")
            buttons.append(self.startBarItem!)
        }
        if buttons.count > 0 {
            self.navigationItem.rightBarButtonItems = buttons
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Actions
    func startAction(sender:AnyObject) {
        beaconManager.requestWhenInUseAuthorization()
        beaconManager.startRangingBeaconsInRegion(beaconRegion)
    }

    func stopAction(sender:AnyObject) {
        beaconManager.stopRangingBeaconsInRegion(beaconRegion)
    }
    
    // MARK: - ESTBeaconManager Delegate
    func beaconManager(manager: AnyObject!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown }
        println("ESTBeaconManager Delegate in Radar beacon - known beacons count: \(knownBeacons.count)")
        
        beaconsArray = knownBeacons
        
        self.tableView.reloadData()
        
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return beaconsArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("RadarCell", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        
        if let beacon = beaconsArray[indexPath.row] as? CLBeacon {
            
            // set texts
            cell.textLabel?.text =  "\(beacon.proximityUUID.UUIDString) \(beacon.major.integerValue.description) \(beacon.minor.integerValue.description)"
            cell.textLabel?.numberOfLines = 3
            cell.textLabel?.sizeToFit()
            cell.detailTextLabel?.text = self.textForProximity(beacon.proximity)
            cell.detailTextLabel?.numberOfLines = 1
            cell.detailTextLabel?.sizeToFit()
            // image
            let placeholderImage = UIImage(named: "beacon_linearnie")
            let size = CGSizeMake(50,75)
            let thumbPlaceholderImage = self.resizeImageForThumbnail(placeholderImage!, size: size)
            cell.imageView?.image = thumbPlaceholderImage
            cell.imageView?.backgroundColor = self.colors[beacon.minor.integerValue]
            
        }

        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }

    // MARK: - Utilities
    private func resizeImageForThumbnail(image: UIImage, size:CGSize) -> UIImage {
        
        UIGraphicsBeginImageContext(size)
        image.drawInRect(CGRectMake(0,0,size.width,size.height))
        var thumbnail:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return thumbnail
        
    }

    private func textForProximity(proximity: CLProximity) -> String {
        
        var returnText = String()
        
        // Set current Map Type
        switch (proximity) {
        case CLProximity.Far:
            // Far
            returnText = "Far"
        case CLProximity.Near:
            // Near
            returnText = "Near"
        case CLProximity.Immediate:
            // Immediate
            returnText = "Immediate"
        default:
            returnText = "Unknown"
            break
        }
        return returnText
        
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "RadarToDetail" {
            let vc = segue.destinationViewController as! BeaconDetailViewController
            
            let indexPath = tableView.indexPathForSelectedRow()
            
            if let beacon = beaconsArray[indexPath!.row] as? CLBeacon {
                vc.currentBeacon = beacon
            }
        }
    }

}
