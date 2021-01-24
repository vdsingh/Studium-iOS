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
<<<<<<< HEAD
    static var colorsDict: [String: UIColor] = [
        "black": UIColor(hexString: "000000")!,
        "flatRed": UIColor(hexString: "#F34440")!,
        "flatOrange": UIColor(hexString:"#F77F49")!,
        "flatYellow": UIColor(hexString:"#F7BA63")!,
        "flatGreen": UIColor(hexString:"#ACCF6A")!,
        "flatTeal": UIColor(hexString:"51B2AF")!,
        "flatBlue": UIColor(hexString:"2d73f5")!,
        "flatPurple": UIColor(hexString:"aa46be")!,
        "redorangeGradient": UIColor(gradientStyle: UIGradientStyle.leftToRight, withFrame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), andColors: [UIColor.red, UIColor.orange]),
        "blueGradient": UIColor(gradientStyle: UIGradientStyle.leftToRight, withFrame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), andColors: [UIColor(hexString: "2C69D1")!, UIColor(hexString: "0ABCF9")!]),
        "bluegreenGradient": UIColor(gradientStyle: UIGradientStyle.leftToRight, withFrame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), andColors: [UIColor(hexString: "087EE1")!, UIColor(hexString: "05E8BA")!]),
        "purplepinkGradient": UIColor(gradientStyle: UIGradientStyle.leftToRight, withFrame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), andColors: [UIColor(hexString: "CB218E")!, UIColor(hexString: "6617CB")!])
    ]
    
    static var gradientPreviewDict: [String: [CGColor]] = [
        "black": [UIColor(hexString: "000000")!.cgColor,UIColor(hexString: "000000")!.cgColor],
        "flatRed": [UIColor(hexString: "#F34440")!.cgColor,UIColor(hexString: "#F34440")!.cgColor],
        "flatOrange": [UIColor(hexString:"#F77F49")!.cgColor,UIColor(hexString:"#F77F49")!.cgColor],
        "flatYellow": [UIColor(hexString:"#F7BA63")!.cgColor,UIColor(hexString:"#F7BA63")!.cgColor],
        "flatGreen": [UIColor(hexString:"#ACCF6A")!.cgColor,UIColor(hexString:"#ACCF6A")!.cgColor],
        "flatTeal": [UIColor(hexString:"51B2AF")!.cgColor,UIColor(hexString:"51B2AF")!.cgColor],
        "flatBlue": [UIColor(hexString:"2d73f5")!.cgColor,UIColor(hexString:"2d73f5")!.cgColor],
        "flatPurple": [UIColor(hexString:"aa46be")!.cgColor,UIColor(hexString:"aa46be")!.cgColor],
        "redorangeGradient": [UIColor.red.cgColor, UIColor.orange.cgColor],
        "blueGradient": [UIColor(hexString: "2C69D1")!.cgColor, UIColor(hexString: "0ABCF9")!.cgColor],
        "bluegreenGradient": [UIColor(hexString: "087EE1")!.cgColor, UIColor(hexString: "05E8BA")!.cgColor],
        "purplepinkGradient": [UIColor(hexString: "CB218E")!.cgColor, UIColor(hexString: "6617CB")!.cgColor]
    ]
=======
    static var colorsDict: [String: UIColor] = ["black": UIColor(hexString: "000000")!, "flatRed": UIColor(hexString: "#F34440")!, "flatOrange": UIColor(hexString:"#F77F49")!, "flatYellow": UIColor(hexString:"#F7BA63")!, "flatGreen": UIColor(hexString:"#ACCF6A")!, "flatTeal": UIColor(hexString:"51B2AF")!, "flatBlue": UIColor(hexString:"2d73f5")!, "flatPurple": UIColor(hexString:"aa46be")!, "redorangeGradient": UIColor(gradientStyle: UIGradientStyle.leftToRight, withFrame: CGRect(x: 0, y: UIScreen.main.bounds.height - 100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 2), andColors: [UIColor.red, UIColor.orange])]
>>>>>>> cda5852b9012b2bb5c49e3a4157b631074502a73
    
    
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
