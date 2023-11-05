//
//  EditHabitViewController.swift
//  Studium
//
//  Created by Vikram Singh on 9/24/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

//struct EditHabitForm: View {
//    
//    init(habit: Habit, refreshCallback: @escaping () -> Void) {
//        self.refreshCallback = refreshCallback
//        self.habit = habit
//        
//        self._name = State(initialValue: habit.name)
//        self._location = State(initialValue: habit.location)
//        self._daysSelected = State(initialValue: habit.days)
//        
//        self._startDate = State(initialValue: habit.startDate)
//        self._endDate = State(initialValue: habit.endDate)
//        self._totalAutoscheduleLengthMinutes = State(initialValue: habit.autoschedulingConfig?.autoLengthMinutes ?? 60)
//        self._isAutoscheduling = State(initialValue: habit.autoscheduling)
//        self._notificationSelections = State(initialValue: habit.alertTimes)
//
//        self._icon = State(initialValue: habit.icon)
//        self._color = State(initialValue: habit.color)
//        self._additionalDetails = State(initialValue: habit.additionalDetails)
//    }
//    
//    let refreshCallback: () -> Void
//    let habit: Habit
//    
//    @Environment(\.dismiss) var dismiss
//    @State var formErrors: [StudiumFormError] = []
//    
//    // MARK: - Course Properties
//    
//    @State var name: String
//    @State var location: String
//    @State var daysSelected: Set<Weekday>
//    
//    @State var startDate: Date
//    @State var endDate: Date
//    @State var totalAutoscheduleLengthMinutes: Int
//    @State var isAutoscheduling: Bool
//    @State var notificationSelections: [AlertOption]
//    
//    @State var icon: StudiumIcon
//    @State var color: UIColor?
//    
//    @State var additionalDetails: String
//    
//    var habitFormView: HabitFormView {
//        HabitFormView(formErrors: self.$formErrors, name: self.$name,
//                      location: self.$location, daysSelected: self.$daysSelected,
//                      isAutoscheduling: self.$isAutoscheduling,
//                      startDate: self.$startDate, endDate: self.$endDate,
//                      totalAutoscheduleLengthMinutes: self.$totalAutoscheduleLengthMinutes,
//                      notificationSelections: self.$notificationSelections,
//                      icon: self.$icon, color: self.$color,
//                      additionalDetails: self.$additionalDetails)
//    }
//    
//    var body: some View {
//        NavigationView {
//            self.habitFormView
//                .navigationBarTitleDisplayMode(.inline)
//                .toolbar {
//                    ToolbarItem(placement: .principal) {
//                        Text("Add Course")
//                            .foregroundColor(StudiumFormNavigationConstants.navBarForegroundColor)
//                            .font(StudiumFont.bodySemibold.font)
//                    }
//                    
//                    ToolbarItemGroup(placement: .topBarLeading) {
//                        Button("Cancel") {
//                            self.dismiss()
//                        }.foregroundStyle(StudiumFormNavigationConstants.navBarForegroundColor)
//                    }
//                    
//                    ToolbarItemGroup(placement: .topBarTrailing) {
//                        Button("Done") {
//                            if let createdHabit = self.habitFormView.createdHabit() {
////                                StudiumEventService.shared.saveStudiumEvent(createdCourse)
//                                StudiumEventService.shared.updateStudiumEvent(oldEvent: self.habit, updatedEvent: createdHabit)
//                                self.refreshCallback()
//                                self.dismiss()
//                            }
//                        }
//                    }
//                }
//        }
//        .accentColor(StudiumFormNavigationConstants.navBarForegroundColor)
//    }
//}
//
//class EditHabitViewController: SwiftUIViewController<EditHabitForm> {
//    
//    let habit: Habit
//    let refreshCallback: () -> Void
//    
//    lazy var editHabitForm = EditHabitForm(habit: self.habit,
//                                             refreshCallback: self.refreshCallback)
//    
//    override func loadView() {
//        super.loadView()
//        self.setupSwiftUI(withView: self.editHabitForm)
//        self.setStudiumFormNavigationStyle()
//    }
//    
//    init(habit: Habit, refreshCallback: @escaping () -> Void) {
//        self.habit = habit
//        self.refreshCallback = refreshCallback
//        super.init()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}

