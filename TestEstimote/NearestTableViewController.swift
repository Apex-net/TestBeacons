//
//  NearestTableViewController.swift
//  TestEstimote
//
//  Created by Andrea Calisesi on 08/05/15.
//  Copyright (c) 2015 Andrea Calisesi. All rights reserved.
//

import UIKit

class NearestTableViewController: UITableViewController, ESTBeaconManagerDelegate {

    let beaconManager = ESTBeaconManager()
    
    let beaconRegion = CLBeaconRegion(
        proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D"),
        identifier: "Apex-net")

    @IBOutlet weak var proximityLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var minorLabel: UILabel!
    
    var currentBeacon: CLBeacon?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // title
        self.navigationItem.title = NSLocalizedString("Nearest beacon", comment: "")

        // beacon setup
        beaconManager.delegate = self
        // start ranging
        self.startRangingBeacons()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - init start ranging
    func startRangingBeacons() {
        beaconManager.requestWhenInUseAuthorization()
        beaconManager.startRangingBeaconsInRegion(beaconRegion)
        
    }
    
    // MARK: - ESTBeaconManager Delegate
    func beaconManager(manager: AnyObject!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        
        println("ESTBeaconManager Delegate in Nearest beacon - beacons count: \(beacons.count)")
        
        if let nearestBeacon = beacons.first as? CLBeacon {
            beaconManager.stopRangingBeaconsInRegion(region)
            
            println("beacons: \(beacons) ---- nearest : \(nearestBeacon.proximityUUID.UUIDString) - \(nearestBeacon.major.integerValue) - \(nearestBeacon.minor.integerValue)")
            
            // set label values
            proximityLabel.text = nearestBeacon.proximityUUID.UUIDString
            majorLabel.text = nearestBeacon.major.integerValue.description
            minorLabel.text = nearestBeacon.minor.integerValue.description
            
            // current beacon
            self.currentBeacon = nearestBeacon
        }
    }
    
    @IBAction func refreshButton(sender: AnyObject) {
        self.startRangingBeacons()
    }
    
    @IBAction func showDetail(sender: AnyObject) {
        self.performSegueWithIdentifier("NearestToDetail", sender: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "NearestToDetail" {
            let vc = segue.destinationViewController as! BeaconDetailViewController
            
            if let beacon = self.currentBeacon {
                vc.currentBeacon = beacon
            }
        }
        
    }

}
