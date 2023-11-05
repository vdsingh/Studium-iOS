//
//  CourseForm.swift
//  Studium
//
//  Created by Vikram Singh on 9/21/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

/// ViewModel to enable CourseFormView
class CourseFormViewModel: ObservableObject {
    
    private var originalCourse: Course?
    private var willComplete: () -> Void
    
    private var isEditing: Bool {
        self.originalCourse != nil
    }
    
    var titleText: String {
        self.isEditing ? "Edit Course" : "Add Course"
    }
    
    var positiveCTAButtonText: String {
        self.isEditing ? "Done" : "Add"
    }
    
    // MARK: - Course Properties
    
    @Published var name: String
    @Published var location: String
    @Published var daysSelected: Set<Weekday>
    
    @Published var startTime: Time
    @Published var endTime: Time
    @Published var notificationSelections: [AlertOption]
    
    @Published var icon: StudiumIcon
    @Published var color: UIColor?
    
    @Published var additionalDetails: String
    
    /// Maintains any form errors that prevent postiive CTA from successfully completing
    @Published private(set) var formErrors: [StudiumFormError] = []
    
    /// Function called when the positive CTA button is tapped (i.e,. "done" or "add")
    /// - Returns: Whether the form completed successfully
    func positiveCTATapped() -> Bool {
        if let constructedCourse = self.constructCourse() {
            if let originalCourse = self.originalCourse {
                // If editing, update old course
                StudiumEventService.shared.updateStudiumEvent(
                    oldEvent: originalCourse,
                    updatedEvent: constructedCourse
                )
            } else {
                // If adding, create new course
                StudiumEventService.shared.saveStudiumEvent(constructedCourse)
            }
            
            self.willComplete()
            return true
        }
        
        return false
    }
    
    /// Creates a course from the form fields
    /// - Returns: A course from the form fields
    func constructCourse() -> Course? {
        self.updateErrors()
        if self.formErrors.isEmpty, let color = self.color {
            return Course(name: self.name, color: color, location: self.location,
                          additionalDetails: self.additionalDetails, startDate: self.startTime.arbitraryDateWithTime,
                          endDate: self.endTime.arbitraryDateWithTime, days: self.daysSelected, icon: self.icon,
                          notificationAlertTimes: self.notificationSelections)
        }
        
        return nil
    }
    
    /// Resets the form errors
    func updateErrors() {
        Log.d("Update Errors called. self name: \(self.name)")
        self.formErrors = []
        if self.name.trimmed().isEmpty { self.formErrors.append(.nameNotSpecified) }
        if self.daysSelected.isEmpty { self.formErrors.append(.oneDayNotSpecified) }
        if self.startTime > self.endTime { self.formErrors.append(.endTimeOccursBeforeStartTime) }
        if self.color == nil { self.formErrors.append(.colorNotSpecfied) }
    }
    
    /// Initializer for adding a new course (default values represent "Empty Form")
    /// - Parameters:
    ///   - name:                   Course name
    ///   - location:               Course location
    ///   - daysSelected:           Days selected for course
    ///   - startTime:              The time that the course starts
    ///   - endTime:                The time that the course ends
    ///   - notificationSelections: Notification settings for the course
    ///   - icon:                   The custom icon for the course
    ///   - color:                  The color for the course
    ///   - additionalDetails:      Any additional details associated with the course
    internal init(name: String = "", location: String = "", daysSelected: Set<Weekday> = [], startTime: Time = .now, endTime: Time = .now.adding(hours: 1, minutes: 0), notificationSelections: [AlertOption] = [], icon: StudiumIcon = .book, color: UIColor? = StudiumEventColor.darkRed.uiColor, additionalDetails: String = "", willComplete: @escaping () -> Void) {
        self.name = name
        self.location = location
        self.daysSelected = daysSelected
        self.startTime = startTime
        self.endTime = endTime
        self.notificationSelections = notificationSelections
        self.icon = icon
        self.color = color
        self.additionalDetails = additionalDetails
        self.willComplete = willComplete
    }
    
    /// Initiailzer intended to be used for editing a course
    /// - Parameter course: The course to be edited
    internal convenience init(course: Course, willComplete: @escaping () -> Void) {
        self.init(name: course.name, location: course.location, daysSelected: course.days, startTime: course.startDate.time, endTime: course.endDate.time, notificationSelections: course.alertTimes, icon: course.icon, additionalDetails: course.additionalDetails, willComplete: willComplete)
        self.originalCourse = course
    }
}

struct CourseFormView: View {
    
    @ObservedObject var viewModel: CourseFormViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            self.formView
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text(self.viewModel.titleText)
                            .foregroundColor(StudiumFormNavigationConstants.navBarForegroundColor)
                            .font(StudiumFont.bodySemibold.font)
                    }
                    
                    ToolbarItemGroup(placement: .topBarLeading) {
                        Button("Cancel") {
                            self.dismiss()
                        }.foregroundStyle(StudiumFormNavigationConstants.navBarForegroundColor)
                    }
                    
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Button(self.viewModel.positiveCTAButtonText) {
                            if self.viewModel.positiveCTATapped() {
                                self.dismiss()
                            }
                        }
                    }
                }
        }
        .accentColor(StudiumFormNavigationConstants.navBarForegroundColor)
    }
    
    private var formView: some View {
        VStack(alignment: .leading) {
            Form {
                Section(header: Text("Details")) {
                    StudiumTextField(text: self.$viewModel.name,
                                     placeholderText: "Name",
                                     charLimit: .shortField)
                    StudiumTextField(text: self.$viewModel.location,
                                     placeholderText: "Location",
                                     charLimit: .shortField)
                    WeekdaysSelectorView(selectedDays: self.$viewModel.daysSelected)
                }
                
                Section(header: Text("Start / End Time")) {
                    TimePicker(label: "Starts", time: self.$viewModel.startTime)
                    TimePicker(label: "Ends", time: self.$viewModel.endTime)
                    
                    //                    DatePicker("Starts", selection: self.$startTime, displayedComponents: [.hourAndMinute]).tint(StudiumColor.primaryAccent.color)
                    //                    DatePicker("Ends", selection: self.$endDate, displayedComponents: [.hourAndMinute]).tint(StudiumColor.primaryAccent.color)
                    ShowNotificationSelectionButton(selectedOptions: self.$viewModel.notificationSelections)
                }
                
                Section(header: Text("Customization")) {
                    ShowIconSelectorButton(icon: self.$viewModel.icon)
                    ColorPickerView(selectedColor: self.$viewModel.color, colors: StudiumEventColor.allCasesUIColors)
                }
                
                Section {
                    StudiumTextField(text: self.$viewModel.additionalDetails,
                                     placeholderText: "Additional Details",
                                     charLimit: .longField)
                }
            }
            
            VStack(alignment: .leading, spacing: Increment.one) {
                ForEach(self.viewModel.formErrors, id: \.self) { error in
                    HStack(alignment: .top) {
                        TinyIcon(color: .red, image: SystemIcon.circleFill.uiImage)
                        Text(error.stringRepresentation)
                    }.foregroundStyle(StudiumColor.failure.color)
                }
            }
            .padding(.horizontal, Increment.three)
        }
    }
}
