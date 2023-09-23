//
//  CourseForm.swift
//  Studium
//
//  Created by Vikram Singh on 9/21/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

struct CourseFormView: View {
    
    func constructCourseFromFields() -> Course {
        return Course(name: self.name, color: self.color, location: self.location, additionalDetails: self.additionalDetails, startDate: self.startDate, endDate: self.endDate, days: [], icon: self.icon, notificationAlertTimes: [])
    }
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    init(course: Course, navigationController: UINavigationController?) {
        self.init(navigationController: navigationController)
        self._name = State(initialValue: course.name)
        self._location = State(initialValue: course.location)
        self._startDate = State(initialValue: course.startDate)
        self._endDate = State(initialValue: course.endDate)
        self._icon = State(initialValue: course.icon)
        self._color = State(initialValue: course.color)
        self._additionalDetails = State(initialValue: course.additionalDetails)
    }
    
    let navigationController: UINavigationController?
        
    @State var name: String = ""
    @State var location: String = ""
//    @State var daysSelected = Set<Weekday>()
    
    @State var startDate: Date = Date()
    @State var endDate: Date = Date().add(hours: 1)
    
    @State var icon: StudiumIcon = StudiumIcon.book
    @State var color: UIColor = .white
    
    @State var additionalDetails: String = ""
    
    @State var errors: [FormError] = []
    
    var body: some View {
        Form {
            Section(header: Text("Details")) {
                StudiumTextField(text: self.$name,
                                 placeholderText: "Name",
                                 charLimit: .shortField)
                StudiumTextField(text: self.$location,
                                 placeholderText: "Location",
                                 charLimit: .shortField)
                InteractiveDaysView()
            }
            
            Section(header: Text("Start / End Time")) {
                DatePicker("Starts", selection: self.$startDate, displayedComponents: [.hourAndMinute]).tint(StudiumColor.primaryAccent.color)
                DatePicker("Ends", selection: self.$endDate, displayedComponents: [.hourAndMinute]).tint(StudiumColor.primaryAccent.color)
                NotificationSelectionButton()
            }
            
            
            Section(header: Text("Customization")) {
                IconSelectionButton(
                    icon: self.$icon,
                    navigationController: self.navigationController
                )
                
                ColorPickerCellV2View(selectedColor: self.$color, colors: StudiumEventColor.allCasesUIColors)
            }
            
            Section {
                TextField(
                    "",
                    text: self.$additionalDetails,
                    prompt: Text("Additional Details").foregroundColor(StudiumColor.placeholderLabel.color)
                )
            }
        }
    }
}
