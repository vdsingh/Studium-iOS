//
//  HabitViewController.swift
//  Studium
//
//  Created by Vikram Singh on 8/12/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

import SwiftUI
import RealmSwift

struct HabitDetailsView: View {
    @ObservedRealmObject var habit: Habit
    var body: some View {
        HStack {
            if !self.habit.location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                SmallIcon(image: SystemIcon.map.createImage())
                StudiumText(self.habit.location)
            }
        }
    }
}

struct HabitView: View {
    
    @ObservedRealmObject var habit: Habit
    
    var body: some View {
        if !self.habit.isInvalidated {
            ZStack {
                StudiumColor.background.color
                    .ignoresSafeArea()
                VStack(spacing: Increment.two) {
                    StudiumEventViewHeader(
                        icon: self.habit.icon.uiImage,
                        color: Color(uiColor: self.habit.color),
                        primaryTitle: self.habit.name,
                        secondaryTitle: self.habit.location
                    )
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: Increment.three)  {

                            if !self.habit.location.trimmed().isEmpty {
                                HabitDetailsView(habit: self.habit)
                                StudiumEventViewDivider()
                            }
                            VStack(alignment: .leading) {
                                HStack {
                                    SmallIcon(image: SystemIcon.calendar.createImage())
                                    StudiumSubtitle(self.habit.autoscheduling ? "Autoschedule On:" : "Occurs On:")
                                }
                                
                                WeekdaysSelectedView(selectedDays: self.habit.days, tintColor: StudiumColor.primaryAccent.color)
                                
                                HStack {
                                    MiniIcon(image: SystemIcon.clock.createImage())
                                    StudiumText("Between \(self.habit.startDate.format(with: DateFormat.standardTime)) - \(self.habit.endDate.format(with: DateFormat.standardTime))")
                                }

                            }

                            StudiumEventViewDivider()
                            
                            VStack(alignment: .leading) {
                                HStack(alignment: .top) {
                                    SmallIcon(image: SystemIcon.paragraphSign.createImage())
                                    StudiumSubtitle("Additional Details")
                                }
                                
                                if self.habit.additionalDetails.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    StudiumSubtext("No Additional Details Provided")
                                } else {
                                    StudiumText(self.habit.additionalDetails)
                                }
                            }
                        }
                        .padding(.horizontal, Increment.three)
                        .padding(.top, Increment.three)
                    }
                    
                    Spacer()
                }
            }
            .navigationBarBackButtonHidden()
        } else {
            Spacer()
        }
    }
}

class HabitViewController: UIViewController {
    let habit: Habit
    let editButtonPressed: () -> Void
    let deleteButtonPressed: () -> Void
    
    init(habit: Habit,
         editButtonPressed: @escaping () -> Void,
         deleteButtonPressed: @escaping () -> Void) {
        self.habit = habit
        self.editButtonPressed = editButtonPressed
        self.deleteButtonPressed = deleteButtonPressed
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.backgroundColor = self.habit.color
        self.navigationController?.navigationBar.tintColor = StudiumColor.primaryLabelColor(forBackgroundColor: self.habit.color)
        self.navigationController?.navigationBar.prefersLargeTitles = false

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSwiftUI()
        
        let editImage = SystemIcon.pencilCircleFill.createImage()
        let editItem = UIBarButtonItem(image: editImage, style: .done, target: self, action: #selector(self.editAssignment))
        
        let deleteItem = UIBarButtonItem(image: SystemIcon.trashCanCircleFill.createImage(), style: .done, target: self, action: #selector(self.deleteAssignment))
        
        self.navigationItem.rightBarButtonItems = [
            editItem,
            deleteItem
        ]
    }
    
    private func setupSwiftUI() {
        let habitView = HabitView(habit: self.habit)
        
        let hostingController = UIHostingController(rootView: habitView)
        self.addChild(hostingController)
        
        self.view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        hostingController.didMove(toParent: self)
    }
    
    @objc private func editAssignment() {
        self.editButtonPressed()
    }
    
    @objc private func deleteAssignment() {
        self.deleteButtonPressed()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct HabitViewController_Previews: PreviewProvider {
    static var previews: some View {
        HabitView(habit: MockStudiumEventService.mockAutoschedulingHabit)
    }
}
