//
//  SettingsViewController.swift
//  Studium
//
//  Created by Vikram Singh on 7/21/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UITableViewController{
    let cellData: [[String]] = [["Theme", "Reset Wake Up Times", "Clear Notifs"],["Credits"]]
    let cellLinks: [[String]] = [["toThemePage", "toWakeUpTimes", ""],[""]]
    
    override func viewDidLoad() {
        tableView.tableFooterView = UIView()

    }
    override func viewWillAppear(_ animated: Bool){
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = cellData[indexPath.section][indexPath.row]
        return cell!
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cellData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData[section].count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if cellLinks[indexPath.section][indexPath.row] != ""{
            performSegue(withIdentifier: cellLinks[indexPath.section][indexPath.row], sender: self)
        }
        
        if cellData[indexPath.section][indexPath.row] == "Clear Notifs"{
            let center = UNUserNotificationCenter.current()
            center.removeAllDeliveredNotifications()    // to remove all delivered notifications
            center.removeAllPendingNotificationRequests()   // to remove all pending notifications
            UIApplication.shared.applicationIconBadgeNumber = 0 // to clear the icon notification badge
//            print("cleared all notifications")
//            print(UIApplication.shared.scheduledLocalNotifications)
        }
    }
}
