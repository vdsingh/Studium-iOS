////
////  PickerTest.swift
////  Studium
////
////  Created by Vikram Singh on 5/30/20.
////  Copyright © 2020 Vikram Singh. All rights reserved.
////
//
//import Foundation
//import UIKit
//class PickerTest: UIViewController{
//    
//    var lengths = [23, 59]
//    var hourCount = 1
//    var minuteCount = 1
//    
//    @IBOutlet weak var pickerView: UIPickerView!
//    override func viewDidLoad() {
//        pickerView.dataSource = self
//        pickerView.delegate = self
//        pickerView.reloadAllComponents()
//    }
//    
//}
//
//
//
//extension PickerTest: UIPickerViewDataSource{
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        print("the length of component \(component) is \(lengths[component])")
//        return lengths[component]
//    }
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 2
//    }
//    
//}
//
//extension PickerTest: UIPickerViewDelegate{
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if component == 0{
//            return "\(row+1) hours"
//        }
//        return "\(row+1) min"
//
//    }
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        
//    }
//}
