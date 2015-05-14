//
//  NotificationViewController.swift
//  TestEstimote
//
//  Created by Andrea Calisesi on 08/05/15.
//  Copyright (c) 2015 Andrea Calisesi. All rights reserved.
//

import UIKit
import CoreLocation

class NotificationDetailViewController: UITableViewController, ESTBeaconManagerDelegate {
    
    var currentBeacon: CLBeacon!
    
    private let beaconManager = ESTBeaconManager()
    
    private var beaconRegion: CLBeaconRegion!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // title
        self.navigationItem.title = NSLocalizedString("Beaconn: \(currentBeacon.minor.integerValue.description)" , comment: "")

        // beacon setup
        self.beaconRegion = CLBeaconRegion(proximityUUID: currentBeacon.proximityUUID, major: currentBeacon.major.unsignedShortValue, minor: currentBeacon.minor.unsignedShortValue, identifier: "CurrentBeacon.minor=\(currentBeacon.minor.stringValue)")
        self.beaconManager.delegate = self
        self.beaconManager.avoidUnknownStateBeacons = true
        self.beaconManager.requestAlwaysAuthorization()
        
        // start looking for Estimote beacons in the region
        // when beacons are found in range, beaconManager:didEnterRegion: is invoked
        // when beacons disappear from range, beaconManager:didExitRegion: is invoked
        self.beaconManager.startMonitoringForRegion(beaconRegion)
        
        // Retrieves the state of a region (results in delegate method)
        self.beaconManager.requestStateForRegion(beaconRegion)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - ESTBeaconManager Delegate
    func beaconManager(manager: AnyObject!, didDetermineState state: CLRegionState, forRegion region: CLBeaconRegion!) {
        //
        if (state == CLRegionState.Inside)
        {
            println("BM didDetermineState: Inside \(region.identifier) region")
        }
        else
        {
            println("BM didDetermineState: Outside \(region.identifier) region")
        }
    }
    
    func beaconManager(manager: AnyObject!, didEnterRegion region: CLBeaconRegion!) {
        // iPhone/iPad entered the beacon region
        println("BM didEnterRegion \(region.identifier)")

        // local notification
        var localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertBody = "Enter \(region.identifier) region notification"
        UIApplication.sharedApplication().presentLocalNotificationNow(localNotification)
        
    }
    
    func beaconManager(manager: AnyObject!, didExitRegion region: CLBeaconRegion!) {
        // iPhone/iPad left the beacon region
        println("BM didExitRegion \(region.identifier)")
        
        // local notification
        var localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertBody = "Exit \(region.identifier) region notification"
        UIApplication.sharedApplication().presentLocalNotificationNow(localNotification)
        
    }
    
    func beaconManager(manager: AnyObject!, monitoringDidFailForRegion region: CLBeaconRegion!, withError error: NSError!) {
        println("BM monitoringDidFailForRegion \(region.identifier) - error: \(error.description)")
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
