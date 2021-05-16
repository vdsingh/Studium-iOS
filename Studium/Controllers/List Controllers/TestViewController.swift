//
//  TestViewController.swift
//  Studium
//
//  Created by Vikram Singh on 5/14/21.
//  Copyright © 2021 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

class TestViewController: UITableViewController{
    override func viewDidLoad() {
        tableView.register(UINib(nibName: "CourseCell1", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.rowHeight = 140

    }
    
    //MARK: - TableView Data Source Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:  "Cell", for: indexPath) as! CourseCell1
//            cell.delegate = self
        return cell

    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
}
