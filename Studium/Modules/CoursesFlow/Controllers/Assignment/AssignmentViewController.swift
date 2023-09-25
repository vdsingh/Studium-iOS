//
//  AssignmentViewController.swift
//  Studium
//
//  Created by Vikram Singh on 7/24/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation

import RealmSwift
import UIKit
import SwiftUI

struct AssignmentViewSectionTitle: View {
    
    let icon: UIImage
    let title: String
    
    var body: some View {
        HStack(spacing: Increment.one) {
            SmallIcon(image: self.icon)
            StudiumSubtitle(self.title)
        }
    }
}
struct AssignmentViewDetails: View {
    
    
    let studiumEventService = StudiumEventService.shared
    @ObservedRealmObject var assignment: Assignment
    @State private var isImporting: Bool = false
    
    let pdfUrlWasPressed: (URL) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: Increment.two) {
            Button {
                if let assignment = self.assignment.thaw() {
                    self.studiumEventService.markComplete(assignment, !assignment.complete)
                }
            } label: {
                HStack {
                    SmallIcon(color: StudiumColor.secondaryAccent.color, image: self.assignment.complete ? SystemIcon.circleCheckmarkFill.createImage() : SystemIcon.circle.createImage())
                    Text(self.assignment.complete ? "Complete" : "Incomplete")
                        .strikethrough(self.assignment.complete)
                        .font(StudiumFont.bodySemibold.font)
                        .foregroundStyle(StudiumFont.bodySemibold.color)
                    Spacer()
                }
            }
            
            HStack {
                SmallIcon(color: self.assignment.latenessStatus.color, image: SystemIcon.clockFill.createImage())
                VStack(alignment: .leading) {
                    StudiumText("Due: \(self.assignment.dueDateString)")
                    StudiumSubtext(self.assignment.endDate.daysHoursMinsDueDateString)
                }
            }
            
            HStack {
                SmallIcon(image: SystemIcon.paperclip.createImage())
                UploadFileButton(
                    fileStorer: self.assignment,
                    isImporting: self.$isImporting,
                    urlWasPressed: self.pdfUrlWasPressed
                )
            }
        }
    }
}

struct AssignmentViewStudyTime: View {
    @ObservedRealmObject var assignment: Assignment
    
    var autoLengthString: String? {
        if let autoschedulingConfig = self.assignment.autoschedulingConfig {
            let hours = autoschedulingConfig.autoLengthMinutes / 60
            let minutes = autoschedulingConfig.autoLengthMinutes % 60
            
            let hoursString = hours == 1 ? "\(hours) hour" : "\(hours) hours"
            let minutesString = minutes == 1 ? "\(minutes) minute" : "\(minutes) minutes"
            
            return "\(hoursString), \(minutesString)"
        }
        
        return nil
    }
    
    var body: some View {
        if let autoschedulingConfig = self.assignment.autoschedulingConfig {
            VStack(alignment: .leading, spacing: Increment.two) {
                AssignmentViewSectionTitle(icon: StudiumIcon.book.uiImage, title: "Study Time")
                VStack(alignment: .leading) {
                    HStack {
                        MiniIcon(image: SystemIcon.clockFill.createImage())
                        if let autoLengthString = self.autoLengthString {
                            StudiumText(autoLengthString)
                        }
                    }
                    
                    HStack {
                        MiniIcon(image: SystemIcon.calendar.createImage())
                        WeekdaysSelectedView(selectedDays: autoschedulingConfig.autoschedulingDays)
                    }
                }
                .padding(.leading, 30)
            }
        }
    }
}

struct AssignmentViewAIResourceProvider: View {
    @ObservedRealmObject var assignment: Assignment
    
    @State var keyword1: String = ""
    @State var keyword2: String = ""
    @State var keyword3: String = ""
    
    @State var aiResourceProviderIsHidden: Bool = false
    
    var keywords: [String] {
        [self.keyword1, self.keyword2, self.keyword3]
    }
    
    var resourcesButtonIsDisabled: Bool {
        self.keyword1.isEmpty || self.keyword2.isEmpty || self.keyword3.isEmpty
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Increment.three) {
            HStack {
                AssignmentViewSectionTitle(icon: StudiumIcon.robot.uiImage, title: "AI Resource Provider")
                Spacer()
                Button {
                    withAnimation {
                        self.aiResourceProviderIsHidden.toggle()
                    }
                } label: {
                    Text(self.aiResourceProviderIsHidden ? "Show" : "Hide")
                        .foregroundStyle(StudiumColor.link.color)
                        .font(StudiumFont.body.font)
                }
            }
            
            if !self.aiResourceProviderIsHidden {
                if self.assignment.resourcesAreLoading {
                    HStack(alignment: .center) {
                        Spacer()
                        Spinner()
                            .frame(width: Increment.eight, height: Increment.eight)
                        Spacer()
                    }
                } else if self.assignment.resourceLinks.isEmpty {
                    VStack(spacing: Increment.two) {
                        TextField("", text: self.$keyword1)
                            .placeholder(when: self.keyword1.isEmpty, placeholder: {
                                Text("Keyword 1").foregroundColor(StudiumFont.placeholder.color)
                            })
                            .withStudiumTextFieldStyle()
                        
                        TextField(
                            "",
                            text: self.$keyword2
                        )
                        .placeholder(when: self.keyword2.isEmpty, placeholder: {
                            Text("Keyword 2").foregroundColor(StudiumFont.placeholder.color)
                        })
                        .withStudiumTextFieldStyle()
                        
                        TextField("", text: self.$keyword3)
                            .placeholder(when: self.keyword3.isEmpty, placeholder: {
                                Text("Keyword 3").foregroundColor(StudiumFont.placeholder.color)
                            })
                            .withStudiumTextFieldStyle()
                        
                        Button {
                            ChatGPTService.shared.generateResources(forAssignment: self.assignment, keywords: self.keywords)
                        } label: {
                            Text("Find Resources")
                                .frame(maxWidth: .infinity)
                                .padding(Increment.one)
                        }
                        .buttonStyle(StudiumButtonStyle(disabled: self.resourcesButtonIsDisabled))
                        .disabled(self.resourcesButtonIsDisabled)
                    }
                    .transition(.scale)
                } else {
                    VStack(alignment: .leading, spacing: Increment.two) {
                        ForEach(self.assignment.resourceLinks, id: \.self) { linkConfig in
                            StudiumLinkView(linkConfig)
                        }
                    }
                }
            }
        }
        .foregroundStyle(StudiumColor.primaryLabel.color)
    }
}


extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}


struct StudiumEventViewDivider: View {
    var body: some View {
        Divider()
            .background(StudiumColor.primaryLabel.color)
    }
}

struct AssignmentView: View {
    @ObservedRealmObject var assignment: Assignment
    let pdfUrlWasPressed: (URL) -> Void
    var body: some View {
        if !self.assignment.isInvalidated {
            ZStack {
                StudiumColor.background.color
                    .ignoresSafeArea()
                VStack(spacing: Increment.two) {
                    StudiumEventViewHeader(icon: self.assignment.icon.uiImage, color: Color(uiColor: self.assignment.color), primaryTitle: self.assignment.name, secondaryTitle: self.assignment.parentCourse?.name ?? "")

                    ScrollView {
                        VStack(alignment: .leading, spacing: Increment.three)  {
                            AssignmentViewDetails(assignment: self.assignment, pdfUrlWasPressed: self.pdfUrlWasPressed)
       
                            StudiumEventViewDivider()

                            if self.assignment.autoscheduling {
                                AssignmentViewStudyTime(assignment: self.assignment)
                                StudiumEventViewDivider()
                            }
                            
                            AssignmentViewAIResourceProvider(assignment: self.assignment)
                            
                            StudiumEventViewDivider()

                            VStack(alignment: .leading) {
                                HStack(alignment: .top) {
                                    SmallIcon(image: SystemIcon.paragraphSign.createImage())
                                    StudiumSubtitle("Additional Details")
                                }
                                
                                if self.assignment.additionalDetails.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    StudiumSubtext("No Additional Details Provided")
                                } else {
                                    StudiumText(self.assignment.additionalDetails)
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

enum LatenessStatus {
    case late
    case withinThreeDays
    case onTime
    
    var statusString: String {
        switch self {
        case .late:
            return "Late"
        case .withinThreeDays:
            return "Due Soon"
        case .onTime:
            return "On Time"
        }
    }
    
    var color: Color {
        switch self {
        case .late:
            return .red
        case .withinThreeDays:
            return .yellow
        case .onTime:
            return .green
        }
    }
}

class AssignmentViewController: UIViewController {
    
    let assignment: Assignment
    let editButtonPressed: () -> Void
    let deleteButtonPressed: () -> Void
    
    init(
        assignment: Assignment,
        editButtonPressed: @escaping () -> Void,
        deleteButtonPressed: @escaping () -> Void
    ) {
        self.assignment = assignment
        self.editButtonPressed = editButtonPressed
        self.deleteButtonPressed = deleteButtonPressed
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.backgroundColor = self.assignment.color
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSwiftUI()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.tintColor = StudiumColor.primaryLabelColor(forBackgroundColor: self.assignment.color)
        
        let editImage = SystemIcon.pencilCircleFill.createImage()
        let editItem = UIBarButtonItem(image: editImage, style: .done, target: self, action: #selector(self.editAssignment))
    
        let deleteItem = UIBarButtonItem(image: SystemIcon.trashCanCircleFill.createImage(), style: .done, target: self, action: #selector(self.deleteAssignment))
        
        self.navigationItem.rightBarButtonItems = [
            editItem,
            deleteItem
        ]
    }
    
    private func setupSwiftUI() {
        let assignmentView = AssignmentView(
            assignment: self.assignment, pdfUrlWasPressed: { url in
                self.openPDFViewController(url: url)
            }
        )
        
        let hostingController = UIHostingController(rootView: assignmentView)
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
    
    func openPDFViewController(url: URL) {
        let pdfViewController = PDFViewController(pdfURL: url)
        self.navigationController?.pushViewController(pdfViewController, animated: true)
    }
    
    @objc private func editAssignment() {
        self.editButtonPressed()
    }
    
    @objc private func deleteAssignment() {
        self.deleteButtonPressed()
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var weekdays: Set<Weekday> {
        var set = Set<Weekday>()
        set.insert(.wednesday)
        set.insert(.monday)
        return set
    }
    
    static let mockAssignment = Assignment(name: "Homework 4", additionalDetails: "Additional Details", complete: true, startDate: Date(), endDate: Date()+100000, notificationAlertTimes: [], autoschedulingConfig: nil, parentCourse: Course(name: "CS 320", location: "Building A", additionalDetails: "Hello World", startDate: Date(), endDate: Date(), color: .green, icon: .atom, alertTimes: []))
    
    static var previews: some View {
        AssignmentView(
            assignment: mockAssignment,
            pdfUrlWasPressed: { _ in }
        )
    }
}
