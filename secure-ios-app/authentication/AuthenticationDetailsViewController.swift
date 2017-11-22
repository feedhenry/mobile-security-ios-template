//
//  AuthenticationDetailsViewController.swift
//  secure-ios-app
//
//  Created by Wei Li on 20/11/2017.
//  Copyright © 2017 Wei Li. All rights reserved.
//

import UIKit

class AuthenticationDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var userInfoView: UITableView!
    
    var userIdentify: Identify = Identify()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userInfoView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return self.userIdentify.reamlRoles.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionNum = indexPath.section
        if (sectionNum == 0) {
            let userInfoCell = tableView.dequeueReusableCell(withIdentifier: "userInfoCell")!
            let fieldNameLabel = userInfoCell.contentView.viewWithTag(1) as! UILabel
            let fieldValueLabel = userInfoCell.contentView.viewWithTag(2) as! UILabel
            if (indexPath.row == 0) {
                fieldNameLabel.text = "Name"
                fieldValueLabel.text = self.userIdentify.fullName
            } else {
                fieldNameLabel.text = "Email"
                fieldValueLabel.text = self.userIdentify.emailAddress
            }
            return userInfoCell
        } else {
            let roleNameCell = tableView.dequeueReusableCell(withIdentifier: "roleNameCell")!
            let roleValueLabel = roleNameCell.contentView.viewWithTag(1) as! UILabel
            roleValueLabel.text = self.userIdentify.reamlRoles[indexPath.row]
            return roleNameCell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "User Details"
        case 1:
            return "Roles"
        default:
            return ""
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
}
