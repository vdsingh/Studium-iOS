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
import RealmSwift
import GoogleSignIn

struct K {
    
//    static let app = App(id: Secret.appID)

    //GOOGLE SIGN IN STUFF
//    static let signInConfig = GIDConfiguration.init(clientID: Secret.clientID)
    
    static let headerHeight: CGFloat = 32
    
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
//    static var assignmentNum = 0
    static var defaultThemeColor: UIColor = UIColor(hexString: "#F77F49")!
    
    static var themeColor: UIColor = colorsDict[UserDefaults.standard.string(forKey: "themeColor") ?? "flatRed"] ?? .black

    
    //The current theme is stored as a string key in UserDefaults (ex: "black"). We then retrieve the UIColor based on that key from here, to use as the theme.
    static var colorsDict: [String: UIColor] = [
        "black": UIColor(hexString: "000000") ?? .flatBlack(),
        "studiumPurple": UIColor(named: "Studium Purple") ?? .purple,
        "studiumOrange": UIColor(named: "Studium Orange") ?? .orange,
        "flatRed": UIColor(hexString: "#F34440") ?? .flatRed(),
        "flatOrange": UIColor(hexString:"#F77F49") ?? .flatOrange(),
        "flatYellow": UIColor(hexString:"#F7BA63") ?? .flatYellow(),
        "flatGreen": UIColor(hexString:"#ACCF6A") ?? .flatGreen(),
        "flatTeal": UIColor(hexString:"51B2AF") ?? .flatTeal(),
        "flatBlue": UIColor(hexString:"2d73f5") ?? .flatBlue(),
        "flatPurple": UIColor(hexString:"aa46be") ?? .flatPurple(),
        "redorangeGradient": UIColor(gradientStyle: UIGradientStyle.leftToRight, withFrame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), andColors: [UIColor.red, UIColor.orange]),
        "blueGradient": UIColor(gradientStyle: UIGradientStyle.leftToRight, withFrame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), andColors: [UIColor(hexString: "2C69D1")!, UIColor(hexString: "0ABCF9")!]),
        "bluegreenGradient": UIColor(gradientStyle: UIGradientStyle.leftToRight, withFrame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), andColors: [UIColor(hexString: "087EE1")!, UIColor(hexString: "05E8BA")!]),
        "purplepinkGradient": UIColor(gradientStyle: UIGradientStyle.leftToRight, withFrame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), andColors: [UIColor(hexString: "CB218E")!, UIColor(hexString: "6617CB")!])
    ]
    
    static var gradientPreviewDict: [String: [CGColor]] = [
        "black": [UIColor(hexString: "000000")!.cgColor,UIColor(hexString: "000000")!.cgColor],
        "studiumPurple": [UIColor(named: "Studium Purple")?.cgColor ?? UIColor.purple.cgColor, UIColor(named: "Studium Purple")?.cgColor ?? UIColor.purple.cgColor],
        "studiumOrange": [UIColor(named: "Studium Orange")?.cgColor ?? UIColor.orange.cgColor, UIColor(named: "Studium Orange")?.cgColor ?? UIColor.orange.cgColor],
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
    
    static var wakeUpKeyDict: [Int: String] = [1: "sunWakeUp", 2: "monWakeUp", 3: "tueWakeUp", 4: "wedWakeUp", 5: "thuWakeUp", 6: "friWakeUp", 7: "satWakeUp"]
    
//    static var weekdayDict: [String: Int] = ["Sun": 1, "Mon": 2, "Tue": 3, "Wed": 4, "Thu": 5, "Fri": 6, "Sat": 7]
//    static var IntToWeekdayDict: [Int: String] = [1:"Sun", 2:"Mon", 3:"Tue", 4:"Wed", 5:"Thu", 6:"Fri", 7:"Sat"]

    static var defaultNotificationTimesKey: String = "defaultNotificationTimes"
    
    static let app = App(id: Secret.appID)
    
    
    //CELL IDENTIFIERS
    static let assignmentCellID = "AssignmentCell1"
    static let genericCellID = "GenericTableViewCell"
    static let headerCellID = "HeaderView"
    static let otherEventCellID = "OtherEventCell"


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
    
    //TODO: Doesnt work and shouldn't be here.
    static func handleLogOut() {
//        GIDSignIn.sharedInstance.signOut()

        guard let user = app.currentUser else {
            print("ERROR: error getting user when trying to sign out")
            return
        }
//        user.log
//        let _ = user.logOut()
    }
}
