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
    
    @Binding var formErrors: [StudiumFormError]
    
    // MARK: - Course Properties
    
    @Binding var name: String
    @Binding var location: String
    @Binding var daysSelected: Set<Weekday>
    
    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var notificationSelections: [AlertOption]
    
    @Binding var icon: StudiumIcon
    @Binding var color: UIColor?
    
    @Binding var additionalDetails: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Form {
                Section(header: Text("Details")) {
                    StudiumTextField(text: self.$name,
                                     placeholderText: "Name",
                                     charLimit: .shortField)
                    StudiumTextField(text: self.$location,
                                     placeholderText: "Location",
                                     charLimit: .shortField)
                    WeekdaysSelectorView(selectedDays: self.$daysSelected)
                }
                
                Section(header: Text("Start / End Time")) {
                    DatePicker("Starts", selection: self.$startDate, displayedComponents: [.hourAndMinute]).tint(StudiumColor.primaryAccent.color)
                    DatePicker("Ends", selection: self.$endDate, displayedComponents: [.hourAndMinute]).tint(StudiumColor.primaryAccent.color)
                    ShowNotificationSelectionButton(selectedOptions: self.$notificationSelections)
                }
                
                Section(header: Text("Customization")) {
                    ShowIconSelectorButton(icon: self.$icon)
                    ColorPickerView(selectedColor: self.$color, colors: StudiumEventColor.allCasesUIColors)
                }
                
                Section {
                    StudiumTextField(text: self.$additionalDetails,
                                     placeholderText: "Additional Details",
                                     charLimit: .longField)
                }
            }
            
            VStack(alignment: .leading, spacing: Increment.one) {
                ForEach(self.formErrors, id: \.self) { error in
                    HStack(alignment: .top) {
                        TinyIcon(color: .red, image: SystemIcon.circleFill.uiImage)
                        Text(error.stringRepresentation)
                    }.foregroundStyle(StudiumColor.failure.color)
                }
            }
            .padding(.horizontal, Increment.three)
        }
    }
    
    func createdCourse() -> Course? {
        self.updateErrors()
        if self.formErrors.isEmpty, let color = self.color {
            return Course(name: self.name, color: color, location: self.location,
                          additionalDetails: self.additionalDetails, startDate: self.startDate,
                          endDate: self.endDate, days: self.daysSelected, icon: self.icon,
                          notificationAlertTimes: self.notificationSelections)
        }
        
        return nil
    }
    
    /// Resets the form errors
    private func updateErrors() {
        Log.d("Update Errors called. self name: \(self.name)")
        self.formErrors = []
        
        if self.name.trimmed().isEmpty{
            self.formErrors.append(.nameNotSpecified)
        }
        
        if self.daysSelected.isEmpty {
            self.formErrors.append(.oneDayNotSpecified)
        }
        
        if self.startDate > self.endDate {
            self.formErrors.append(.endTimeOccursBeforeStartTime)
        }
        
        if self.color == nil {
            self.formErrors.append(.colorNotSpecfied)
        }
    }
}
