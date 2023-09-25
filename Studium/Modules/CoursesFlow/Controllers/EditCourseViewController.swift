//
//  EditCourseViewController.swift
//  Studium
//
//  Created by Vikram Singh on 9/21/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

struct EditCourseForm: View {
    
    init(course: Course, refreshCallback: @escaping () -> Void) {
        self.refreshCallback = refreshCallback
        self.course = course
        
        self._name = State(initialValue: course.name)
        self._location = State(initialValue: course.location)
        self._daysSelected = State(initialValue: course.days)
        
        self._startDate = State(initialValue: course.startDate)
        self._endDate = State(initialValue: course.endDate)
        self._notificationSelections = State(initialValue: course.alertTimes)

        self._icon = State(initialValue: course.icon)
        self._color = State(initialValue: course.color)
        self._additionalDetails = State(initialValue: course.additionalDetails)
    }
    
    let refreshCallback: () -> Void
    let course: Course
    
    @Environment(\.dismiss) var dismiss
    @State var formErrors: [StudiumFormError] = []
    
    // MARK: - Course Properties
    
    @State var name: String
    @State var location: String
    @State var daysSelected: Set<Weekday>
    
    @State var startDate: Date
    @State var endDate: Date
    @State var notificationSelections: [AlertOption]
    
    @State var icon: StudiumIcon
    @State var color: UIColor?
    
    @State var additionalDetails: String
    
    var courseFormView: CourseFormView {
        CourseFormView(formErrors: self.$formErrors, name: self.$name, location: self.$location, daysSelected: self.$daysSelected, startDate: self.$startDate, endDate: self.$endDate, notificationSelections: self.$notificationSelections, icon: self.$icon, color: self.$color, additionalDetails: self.$additionalDetails)
    }
    
    var body: some View {
        NavigationView {
            self.courseFormView
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Add Course")
                            .foregroundColor(StudiumFormNavigationConstants.navBarForegroundColor)
                            .font(StudiumFont.bodySemibold.font)
                    }
                    
                    ToolbarItemGroup(placement: .topBarLeading) {
                        Button("Cancel") {
                            self.dismiss()
                        }.foregroundStyle(StudiumFormNavigationConstants.navBarForegroundColor)
                    }
                    
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Button("Done") {
                            if let createdCourse = self.courseFormView.createdCourse() {
//                                StudiumEventService.shared.saveStudiumEvent(createdCourse)
                                StudiumEventService.shared.updateStudiumEvent(oldEvent: self.course, updatedEvent: createdCourse)
                                self.refreshCallback()
                                self.dismiss()
                            }
                        }
                    }
                }
        }
        .accentColor(StudiumFormNavigationConstants.navBarForegroundColor)
    }
}

class EditCourseViewController: SwiftUIViewController<EditCourseForm> {
    
    let course: Course
    let refreshCallback: () -> Void
    
    lazy var editCourseForm = EditCourseForm(course: self.course,
                                             refreshCallback: self.refreshCallback)
    
    override func loadView() {
        super.loadView()
        self.setupSwiftUI(withView: self.editCourseForm)
        self.setStudiumFormNavigationStyle()
    }
    
    init(course: Course, refreshCallback: @escaping () -> Void) {
        self.course = course
        self.refreshCallback = refreshCallback
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
