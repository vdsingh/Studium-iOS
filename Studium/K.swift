//
//  K.swift
//  Studium
//
//  Created by Vikram Singh on 5/24/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit
import ChameleonFramework

struct K {
    //SEGUES
    static let coursesToAssignmentsSegue = "coursesToAssignments"
    static let coursesToAllSegue = "coursesToAll"
    static let toAddCourseSegue = "toAddCourse"
    static let toCoursesSegue = "toCourses"
    static let toMainSegue = "toMain"
    static let toLoginSegue = "toLogin"
    static let toRegisterSegue = "toRegister"
    static let toCalendarSegue = "toCalendar"
    
    static let sortAssignmentsBy = "name"
    
    static var assignmentNum = 0
    
    static var defaultThemeColor: UIColor = UIColor(hexString: "#F77F49")!
    
    //The current theme is stored as a string key in UserDefaults (ex: "black"). We then retrieve the UIColor based on that key from here, to use as the theme.
    static var colorsDict: [String: UIColor] = ["black": UIColor(hexString: "000000")!, "flatRed": UIColor(hexString: "#F34440")!, "flatOrange": UIColor(hexString:"#F77F49")!, "flatYellow": UIColor(hexString:"#F7BA63")!, "flatGreen": UIColor(hexString:"#ACCF6A")!, "flatTeal": UIColor(hexString:"51B2AF")!, "flatBlue": UIColor(hexString:"2d73f5")!, "flatPurple": UIColor(hexString:"aa46be")!, "redorangeGradient": UIColor(gradientStyle: UIGradientStyle.leftToRight, withFrame: CGRect(x: 0, y: UIScreen.main.bounds.height - 100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 2), andColors: [UIColor.red, UIColor.orange])]
    
    
    static func scheduleNotification(components: DateComponents, body: String, titles:String, repeatNotif: Bool, identifier: String) {
            
            print("notification scheduled.")
            
    //        let triggerWeekly = Calendar.current.dateComponents([.weekday,.hour,.minute], from: date)
            print(components)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: repeatNotif)
            
            
            let content = UNMutableNotificationContent()
            content.title = titles
            content.body = body
            content.sound = UNNotificationSound.default
    //        content.categoryIdentifier = identifier
            
            
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            //identifiers for courses are stored as "courseName alertTime"
    //        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
    //        print(request)
    //        UNUserNotificationCenter.curren///t().delegate = self
            //UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UNUserNotificationCenter.current().add(request) {(error) in
                if error != nil {
                    print(error!)
                }
            }
        }
}
