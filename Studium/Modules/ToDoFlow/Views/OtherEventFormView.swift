//
//  OtherEventFormView.swift
//  Studium
//
//  Created by Vikram Singh on 9/28/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

class OtherEventFormViewModel: ObservableObject {
    
    private var originalOtherEvent: OtherEvent?
    private let completion: () -> Void
    
    private var isEditing: Bool {
        self.originalOtherEvent != nil
    }
    
    var titleText: String {
        self.isEditing ? "Edit Event" : "Add Event"
    }
    
    var positiveCTAButtonText: String {
        self.isEditing ? "Done" : "Add"
    }
    
    @Published private(set) var formErrors: [StudiumFormError] = []
    
    
    
    // MARK: - OtherEvent Properties
    
    @Published var name: String
    @Published var location: String
    
    @Published var startDate: Date
    @Published var endDate: Date
    @Published var notificationSelections: Set<AlertOption>
    
    @Published var icon: StudiumIcon
    @Published var color: UIColor?
    
    @Published var additionalDetails: String
    
    // MARK: - Functions
    
    /// Function called when the positive CTA button is tapped (i.e,. "done" or "add")
    func positiveCTATapped() {
        if let constructedOtherEvent = self.constructOtherEvent() {
            if let originalOtherEvent = self.originalOtherEvent {
                // If editing, update old OtherEvent
                StudiumEventService.shared.updateStudiumEvent(
                    oldEvent: originalOtherEvent,
                    updatedEvent: constructedOtherEvent
                )
            } else {
                // If adding, create new OtherEvent
                StudiumEventService.shared.saveStudiumEvent(constructedOtherEvent)
            }
            
            self.completion()
        }
    }
    
    /// Constructs an OtherEvent from the properties
    /// - Returns: An OtherEvent from the properties or nil if there is a form error
    func constructOtherEvent() -> OtherEvent? {
        self.updateErrors()
        if self.formErrors.isEmpty, let color = self.color {
            return OtherEvent(name: self.name, 
                              location: self.location,
                              additionalDetails: self.additionalDetails,
                              startDate: self.startDate,
                              endDate: self.endDate,
                              alertTimes: self.notificationSelections,
                              icon: self.icon,
                              color: color)
        }
        
        return nil
    }
    
    /// Resets the form errors
    func updateErrors() {
        Log.d("Update Errors called. self name: \(self.name)")
        self.formErrors = []
        
        if self.name.trimmed().isEmpty{
            self.formErrors.append(.nameNotSpecified)
        }
        
        if self.startDate > self.endDate {
            self.formErrors.append(.endTimeOccursBeforeStartTime)
        }
        
        if self.color == nil {
            self.formErrors.append(.colorNotSpecfied)
        }
    }
    
    // MARK: - Initializers
    
    internal init(
        name: String = "",
        location: String = "",
        startDate: Date = Date(),
        endDate: Date = Date().add(hours: 1),
        notificationSelections: Set<AlertOption> = [],
        icon: StudiumIcon = .book,
        color: UIColor? = StudiumEventColor.darkRed.uiColor,
        additionalDetails: String = "",
        completion: @escaping () -> Void
    ) {
        self.name = name
        self.location = location
        self.startDate = startDate
        self.endDate = endDate
        self.notificationSelections = notificationSelections
        self.icon = icon
        self.color = color
        self.additionalDetails = additionalDetails
        self.completion = completion
    }
    
    
    /// Initialize from an existing OtherEvent object
    /// - Parameter otherEvent: The OtherEvent that specifies the properties
    internal convenience init(otherEvent: OtherEvent, completion: @escaping () -> Void) {
        self.init(name: otherEvent.name, location: otherEvent.location, startDate: otherEvent.startDate,  endDate: otherEvent.endDate, notificationSelections: otherEvent.alertTimes, icon: otherEvent.icon, color: otherEvent.color, additionalDetails: otherEvent.additionalDetails, completion: completion)
        self.originalOtherEvent = otherEvent
        
    }
}

struct OtherEventFormView: View {
    
    @ObservedObject var viewModel: OtherEventFormViewModel
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
                            self.viewModel.positiveCTATapped()
                            self.dismiss()
                        }
                    }
                }
        }
        .accentColor(StudiumFormNavigationConstants.navBarForegroundColor)
    }
    
    var formView: some View {
        VStack(alignment: .leading) {
            Form {
                Section(header: Text("Details")) {
                    StudiumTextField(text: self.$viewModel.name,
                                     placeholderText: "Name",
                                     charLimit: .shortField)
                    StudiumTextField(text: self.$viewModel.location,
                                     placeholderText: "Location",
                                     charLimit: .shortField)
                }
                
                Section(header: Text("Start / End Time")) {
//                    TimePicker(label: "Starts", time: self.$viewModel.startTime)
//                    TimePicker(label: "Ends", time: self.$viewModel.endTime)

                    DatePicker("Starts", selection: self.$viewModel.startDate, displayedComponents: [.hourAndMinute]).tint(StudiumColor.primaryAccent.color)
                    DatePicker("Ends", selection: self.$viewModel.endDate, displayedComponents: [.hourAndMinute]).tint(StudiumColor.primaryAccent.color)
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
