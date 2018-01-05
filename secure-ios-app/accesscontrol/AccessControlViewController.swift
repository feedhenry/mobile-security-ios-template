//
//  AccessControlViewController.swift
//  secure-ios-app
//
//  Created by Wei Li on 14/12/2017.
//  Copyright © 2017 Wei Li. All rights reserved.
//

import UIKit

protocol AccessControlListener {
    func showAccess()
}

class AccessControlViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var rolesTable: UITableView!
    
    let allRealmRoles = [RealmRoles.apiAccess, RealmRoles.mobileUser, RealmRoles.superUser]
    
    var userIdentity: Identity? {
        didSet {
            if rolesTable == nil {
                return
            }
            if let identity = self.userIdentity {
                highlightUserRealmRoles(identity: identity)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        rolesTable.separatorStyle = UITableViewCellSeparatorStyle.none
        rolesTable.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let identity = self.userIdentity {
            highlightUserRealmRoles(identity: identity)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func highlightUserRealmRoles(identity: Identity) {
        for realmRole in self.allRealmRoles {
            if identity.hasRole(role: realmRole.roleName) {
                setRoleAccessoryType(role: realmRole, type: UITableViewCellAccessoryType.checkmark)
            } else {
                setRoleAccessoryType(role: realmRole, type: UITableViewCellAccessoryType.none)
            }
        }
    }
    
    func setRoleAccessoryType(role: RealmRole, type: UITableViewCellAccessoryType) {
        let rowIndex = self.allRealmRoles.index(of: role)!
        let indexPath = IndexPath(row: rowIndex, section: 0)
        let roleCell = self.rolesTable.cellForRow(at: indexPath)
        if let cell = roleCell {
            cell.accessoryType = type
        }
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
        return self.allRealmRoles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lableText = self.allRealmRoles[indexPath.row].roleText
        let roleNameCell = tableView.dequeueReusableCell(withIdentifier: "realmRoleNameCell")!
        let roleNameLabel = roleNameCell.contentView.viewWithTag(1) as! UILabel
        roleNameLabel.text = lableText
        return roleNameCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
