//
//  RadarNotificationViewController.swift
//  TestEstimote
//
//  Created by Andrea Calisesi on 13/05/15.
//  Copyright (c) 2015 Andrea Calisesi. All rights reserved.
//

import UIKit

class RadarNotificationViewController: RadarViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // title
        self.navigationItem.title = NSLocalizedString("Notifications", comment: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Before you have to select a beacon for test notifications"
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "RadarNotificationToDetailNotification" {
            let vc = segue.destinationViewController as! NotificationDetailViewController
            
            let indexPath = tableView.indexPathForSelectedRow()
            
            if let beacon = beaconsArray[indexPath!.row] as? CLBeacon {
                vc.currentBeacon = beacon
            }
        }
        
    }

}
