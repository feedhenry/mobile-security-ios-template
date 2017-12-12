//
//  DeviceTrustViewController.swift
//  secure-ios-app
//
//  Created by Tom Jackman on 30/11/2017.
//  Copyright © 2017 Wei Li. All rights reserved.
//

import Foundation

protocol DeviceTrustListener {
    func performTrustChecks() -> [Detector]
}

/* The class for the table view cells. */
class DeviceTrustTableViewCell: UITableViewCell {
    @IBOutlet var name: UILabel!
}

/* The view controller for the device trust view. */
class DeviceTrustViewController: UITableViewController {
    
    var deviceTrustListener: DeviceTrustListener?
    var deviceChecks = [Detector]()
    @IBOutlet var deviceTrustScore: UILabel!
    let RED_COLOR = UIColor.init(red: CGFloat(150.0/255.0), green: CGFloat(44.0/255.0), blue: CGFloat(44.0/255.0), alpha: CGFloat(1.0))
    let GREEN_COLOR = UIColor.init(red: CGFloat(57.0/255.0), green: CGFloat(180.0/255.0), blue: CGFloat(171.0/255.0), alpha: CGFloat(1.0))

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // don't show empty table items
        self.tableView.tableFooterView = UIView()
        
        // cell row height
        self.tableView.rowHeight = 75.0
        
        // perform the detection checks
        self.performTrustChecks()
    }
    
    /**
     - Run the device trust checks in the service and refresh the table view with the results.
     */
    func performTrustChecks() {
        if let listener = self.deviceTrustListener {
            self.deviceChecks = listener.performTrustChecks()
            self.tableView.reloadData()
            self.setTrustScore()
        }
    }
    
    /**
     - Set the trust score header value in the UI.
     */
    func setTrustScore() {
        let totalTestFailures = self.deviceChecks.filter{ $0.detected }.count
        let deviceTrustScore = 100 - ((Double(totalTestFailures) / Double(self.deviceChecks.count)) * 100)
        self.deviceTrustScore?.text = "Device Trust Score: \(deviceTrustScore)%"
        
        if deviceTrustScore == 100 {
            self.deviceTrustScore.backgroundColor = GREEN_COLOR
        } else {
            self.deviceTrustScore.backgroundColor = RED_COLOR
        }
    }
    
    /**
     - Set the number of sections required in the table
     
     - Returns: The number of sections
     */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    /**
     - Set the number of rows required in the section
     
     - Returns: The number of device checks
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.deviceChecks.count
    }
    
    /**
     - Setup of the table view to reference the table in the storyboard
     
     - Returns: An individual cell in the table list
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "DeviceTrustTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DeviceTrustTableViewCell
        
        // Fetches the appropriate note for the data source layout.
        let detection = self.deviceChecks[indexPath.row]
        
        // set the properties for the cell
        cell.textLabel?.text = detection.label
        
        // set the text colouring
        if(detection.detected) {
            
            cell.textLabel?.textColor = RED_COLOR
            cell.imageView?.image = UIImage(named: "ic_detected_true")
        } else {
            let greenColorShade = GREEN_COLOR
            cell.textLabel?.textColor = greenColorShade
            cell.imageView?.image = UIImage(named: "ic_detected_false")
        }
        
        return cell
    }
}
