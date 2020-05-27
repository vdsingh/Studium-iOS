//
//  AddHabitViewController.swift
//  Studium
//
//  Created by Vikram Singh on 5/27/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

protocol HabitRefreshProtocol{
    func loadHabits()
}

class AddHabitViewController: UIViewController{
    var delegate: HabitRefreshProtocol?
    
}
