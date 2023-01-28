//
//  AlertTableViewController.swift
//  Studium
//
//  Created by Vikram Singh on 8/15/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//


//HOW TO USE THIS CLASS:
//1: Conform to AlertInfoStorer protocol - Whenever we want to select alert times, the class we are selecting from must obey the "AlertInfoStorer" protocol, which requires the class to have an integer array dedicated to storing the alertTimes that are selected on this screen as well as informing this screen about the alertTimes already selected.
//2: Set the delegate for this class to the class that conforms to the AlertInfoStorer protocol in the prepare method for preparing for segue. This usually just looks like:

//override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    if let destinationVC = segue.destination as? AlertTableViewController{
//        destinationVC.delegate = self
//        //            destinationVC.alertTimes = alertTimes
//    }
//}

//3: Make sure that alertTimes are stored somewhere for future form fill functionality (an object or UserDefaults for example). If the delegate's alertTimes array is filled with the correct data before segueing to this screen, then this screen will automatically check the alert times that are associated with that data.
//4: If necessary, implement processAlertTimes(). Right before this screen will be dismissed, processAlertTimes() will be called, in which you can store the data as necessary (UserDefaults usually).

//Example: We want to store the alert times for an assignment.
//1: Make AddAssignmentViewController conform to AlertInfoStorer protocol (it then has var alertTimes: [Int])
//2: Before segueing into this screen, make sure alertTimes is populated with the pre-existing information. If the user has already indicated that they want to be notified about the assignment due date 5 minutes before and 15 minutes before, then alertTimes should equal [5, 15] before we segue here
//3: When we leave this screen and return back to AddAssignmentViewController, alertTimes will be updated with the edits we made here. Store that information in the Assignment object so that it can be kept and used for later.


import UIKit

enum AlertOption: Int, CaseIterable {
    case atTime = 0
    case fiveMin = 5
    case tenMin = 10
    case fifteenMin = 15
    case thirtyMin = 30
    case oneHour = 60
    case twoHour = 120
    case fourHour = 240
    case eightHour = 480
    case oneDay = 1440
    
    var userString: String {
        switch self {
        case .atTime:
            return "At time of event"
        case .fiveMin:
            return "5 minutes before"
        case .tenMin:
            return "10 minutes before"
        case .fifteenMin:
            return "15 minutes before"
        case .thirtyMin:
            return "30 minutes before"
        case .oneHour:
            return "1 hour before"
        case .twoHour:
            return "2 hours before"
        case .fourHour:
            return "4 hours before"
        case .eightHour:
            return "8 hours before"
        case .oneDay:
            return "1 day before"
        }
    }
}

protocol AlertInfoStorer{
    var alertTimes: [AlertOption] { get set }
    func processAlertTimes()
}

class AlertTableViewController: UITableViewController {
    var delegate: AlertInfoStorer?
    
    //what the user sees in the tableview

    let alertOptions = AlertOption.allCases
    //the corresponding number of minutes
//    var times: [Int] = [0, 5, 10, 15, 30, 60, 120, 240, 480, 1440]
    
    
//    var checked: [AlertBool] = [false,false,false,false,false,false,false,false,false,false]
    
    var alertTimes: [Int] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "LabelCell", bundle: nil), forCellReuseIdentifier: "LabelCell")
        
        guard let delegate = delegate else {
            print("$Error: delegate is nil in AlertTableViewController")
            return
        }

//        for time in delegate.alertTimes {
//            let index = times.firstIndex(of: time)
//            checked[index!] = true
//        }
        
        //makes it so that there are no empty cells at the bottom
        tableView.tableFooterView = UIView()
    }
    
    //when the user presses the back button we update data appropriately
    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        alertTimes = []
//        for i in 0..<checked.count {
//            if checked[i] == true{
//                alertTimes.append(times[i])
//            }
//        }
//        delegate!.alertTimes = alertTimes
//        delegate!.processAlertTimes()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return alertOptions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let alertOption = alertOptions[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: LabelCell.id, for: indexPath) as! LabelCell
        cell.label.text = alertOptions[indexPath.row].userString
        cell.accessoryType = .none
        
        if let delegate = delegate,
           delegate.alertTimes.contains(alertOption) {
            cell.accessoryType = .checkmark
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAlertOption = self.alertOptions[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)
//        if cell?.accessoryType == UITableViewCell.AccessoryType.none {
        if var delegate = delegate,
           delegate.alertTimes.contains(selectedAlertOption) {
            cell?.accessoryType = .checkmark
            delegate.alertTimes.removeAll(where: {$0.rawValue == selectedAlertOption.rawValue})
//            checked[indexPath.row] = true
        } else {
            cell?.accessoryType = .none
//            checked[indexPath.row] = false
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
