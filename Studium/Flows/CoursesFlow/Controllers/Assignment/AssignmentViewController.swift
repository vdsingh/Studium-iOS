//
//  AssignmentViewController.swift
//  Studium
//
//  Created by Vikram Singh on 7/24/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import VikUtilityKit
import RealmSwift
import UIKit
import SwiftUI

struct AssignmentViewHeader: View {
    @ObservedRealmObject var assignment: Assignment
    var body: some View {
        HStack(alignment: .top) {
            HStack(spacing: Increment.two) {
                Image(uiImage: StudiumIcon.code.uiImage)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.white)
                    .frame(width: Increment.eight)
                
                VStack(alignment: .leading, spacing: 0) {
                    StudiumTitle(self.assignment.name)
                    StudiumGraySubtitle(self.assignment.parentCourse?.name ?? "")
                }
            }
            
            Spacer()
            
            HStack(alignment: .top, spacing: Increment.two) {
                Button {
                    
                } label: {
                    SmallIcon(image: SystemIcon.trashCan.createImage())
                }
                
                Button {
                    
                } label: {
                    SmallIcon(image: SystemIcon.pencil.createImage())
                    
                }
            }
        }
    }
}

struct AssignmentViewDetails: View {
    @ObservedRealmObject var assignment: Assignment
    var body: some View {
        VStack(alignment: .leading, spacing: Increment.two) {
            HStack {
                LatenessIndicatorView(self.assignment.latenessStatus)
                StudiumText(self.assignment.latenessStatus.statusString)
            }
            
            HStack {
                SmallIcon(image: SystemIcon.clockFill.createImage())
                StudiumText("Due: \(self.assignment.dueDateString)")
            }
            
            HStack {
                SmallIcon(image: SystemIcon.paperclip.createImage())
                Button {
                    
                } label:  {
                    StudiumText("Attach a File")
                }
                .buttonStyle(StudiumButtonStyle(disabled: false))
            }
        }
    }
}

//struct StudiumButtonStyleDisabled: ButtonStyle {
//    func makeBody(configuration: Configuration) -> some View {
//        configuration.label
//            .padding(.vertical, Increment.one)
//            .padding(.horizontal, Increment.two)
//            .background(.gray)
//            .foregroundStyle(.white)
//            .clipShape(.rect(cornerRadius: Increment.one))
//    }
//}

struct StudiumButtonStyle: ButtonStyle {
    let disabled: Bool
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, Increment.one)
            .padding(.horizontal, Increment.two)
            .background(Color(self.disabled ? .gray: StudiumColor.primaryAccent.uiColor))
            .foregroundStyle(.white)
            .clipShape(.rect(cornerRadius: Increment.one))
    }
}

class LinkConfig: Object {
    @Persisted(primaryKey: true) var _id: ObjectId = ObjectId.generate()
    @Persisted var label: String
    @Persisted var link: String
    
    convenience init(label: String, link: String) {
        self.init()
        self.label = label
        self.link = link
    }
}

//enum ResourceProviderState {
//    case noResourcesProvided
//    case loading
//    case resourcesProvided(links: [LinkConfig])
//}

struct CustomTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(Increment.two)
            .background(StudiumColor.tertiaryBackground.color)
            .cornerRadius(Increment.one)
    }
}

extension View {
    func customTextFieldStyle() -> some View {
        self.modifier(CustomTextFieldStyle())
    }
}

struct AssignmentViewAIResourceProvider: View {
    @ObservedRealmObject var assignment: Assignment
    
    @State var keyword1: String = ""
    @State var keyword2: String = ""
    @State var keyword3: String = ""
    
    
    var keywords: [String] {
        [self.keyword1, self.keyword2, self.keyword3]
    }
    
    var resourcesButtonIsDisabled: Bool {
        self.keyword1.isEmpty || self.keyword2.isEmpty || self.keyword3.isEmpty
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Increment.three) {
            HStack(spacing: Increment.one) {
                SmallIcon(image: StudiumIcon.robot.uiImage)
                StudiumSubtitle("AI Resource Provider")
            }
            
//            switch self.$assignment.resourceProviderState {
//            case .noResourcesProvided:
            if self.assignment.resourcesAreLoading {
                HStack(alignment: .center) {
                    Spacer()
                    Spinner()
                        .frame(width: Increment.eight, height: Increment.eight)
                    Spacer()
                }
            } else if self.assignment.resourceLinks.isEmpty {
                VStack(spacing: Increment.two) {
                    TextField("Keyword 1", text: $keyword1)
                        .customTextFieldStyle()
                    
                    TextField("Keyword 2", text: $keyword2)
                        .customTextFieldStyle()
                    
                    TextField("Keyword 3", text: $keyword3)
                        .customTextFieldStyle()
                    
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
            } else {
                
                //            case .loading:
                
                
                //            case .resourcesProvided(let links):
                VStack(alignment: .leading, spacing: Increment.two) {
                    ForEach(self.assignment.resourceLinks, id: \.self) { linkConfig in
                        StudiumLinkView(linkConfig)
                    }
                }
            }
        }
        .foregroundStyle(StudiumColor.primaryLabel.color)
    }
}


struct AssignmentView: View {
    @ObservedRealmObject var assignment: Assignment
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundStyle(StudiumColor.primaryAccent.color)
                    .frame(height: Increment.eight * 2)
                    .padding(0)
                AssignmentViewHeader(assignment: assignment)
                    .padding(.horizontal, Increment.three)
            }
            
            VStack(alignment: .leading, spacing: Increment.three)  {
                AssignmentViewDetails(assignment: self.assignment)
                Divider()
                    .background(StudiumColor.primaryLabel.color)
                AssignmentViewAIResourceProvider(assignment: self.assignment)
                Divider()
                    .background(StudiumColor.primaryLabel.color)
                VStack(alignment: .leading, spacing: Increment.two) {
                    HStack(alignment: .top) {
                        SmallIcon(image: SystemIcon.paragraphSign.createImage())
                        StudiumSubtitle("Additional Details")
                    }
                    
                    StudiumText(self.assignment.additionalDetails)
                }
                
                Spacer()
            }
            .padding(.horizontal, Increment.three)
            .padding(.top, Increment.three)
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
    
    init(assignment: Assignment) {
        self.assignment = assignment
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSwiftUI()
    }
    
    private func setupSwiftUI() {
        let assignmentView = AssignmentView(assignment: self.assignment)
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
}


struct ContentView_Previews: PreviewProvider {
    static let mockAssignment = Assignment(name: "Homework 4", additionalDetails: "Additional Details", complete: true, startDate: Date(), endDate: Date()+100000, notificationAlertTimes: [], autoscheduling: true, autoLengthMinutes: 60, autoDays: Set(), parentCourse: Course(name: "CS 320", location: "Building A", additionalDetails: "Hello World", startDate: Date(), endDate: Date(), color: .green, icon: .atom, alertTimes: []))
    
    static var previews: some View {

        AssignmentView(assignment: mockAssignment)
    }
}
