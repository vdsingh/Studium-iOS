//
//  AlertTableViewController.swift
//  Studium
//
//  Created by Vikram Singh on 8/15/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit
protocol AlertInfoStorer{
    var alertTimes: [Int] {get set}
}
class AlertTableViewController: UITableViewController {
    var delegate: AlertInfoStorer?
    
    //what the user sees in the tableview
    var tags: [String] = ["At time of event","5 minutes before","10 minutes before","15 minutes before","30 minutes before", "1 hour before", "2 hours before", "4 hours before", "8 hours before", "1 day before"]
    
    //the corresponding number of minutes
    var times: [Int] = [0,5,10,15,30,60,120,240,480,1440]
    
    
    var checked: [Bool] = [false,false,false,false,false,false,false,false,false,false]
    
    var alertTimes: [Int] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "LabelCell", bundle: nil), forCellReuseIdentifier: "LabelCell")
        
        for time in delegate!.alertTimes{
            let index = times.firstIndex(of: time)
            checked[index!] = true
        }
        
        //makes it so that there are no empty cells at the bottom
        tableView.tableFooterView = UIView()
        
    }
    
    //when the user presses the back button we update data appropriately
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        alertTimes = []
        print("viewwilldisappear")
        for i in 0..<checked.count {
            if checked[i] == true{
                print("checked \(i) is true")
                alertTimes.append(times[i])
            }
        }
        print("alertTimes: \(alertTimes)")
        delegate!.alertTimes = alertTimes
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tags.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! LabelCell
        cell.label.text = tags[indexPath.row]
        cell.accessoryType = .none
        if checked[indexPath.row]{
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.accessoryType == UITableViewCell.AccessoryType.none{
            cell?.accessoryType = .checkmark
            checked[indexPath.row] = true
        }else{
            cell?.accessoryType = .none
            checked[indexPath.row] = false
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
