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
    static let emptyHeaderHeight: CGFloat = 12
    static let populatedHeaderHeight: CGFloat = 32
    
    //SEGUES
//    static let coursesToAssignmentsSegue = "coursesToAssignments"
//    static let coursesToAllSegue = "coursesToAll"
//    static let toAddCourseSegue = "toAddCourse"
//    static let toCoursesSegue = "toCourses"
//    static let toMainSegue = "toMain"
//    static let toLoginSegue = "toLogin"
//    static let toRegisterSegue = "toRegister"
//    static let toCalendarSegue = "toCalendar"
//    
//    static let sortAssignmentsBy = "name"

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
}
