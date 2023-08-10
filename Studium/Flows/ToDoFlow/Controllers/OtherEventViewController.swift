//
//  OtherEventViewController.swift
//  Studium
//
//  Created by Vikram Singh on 8/6/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import VikUtilityKit
import RealmSwift
import UIKit
import SwiftUI

struct OtherEventViewDetails: View {
    
    @ObservedRealmObject var otherEvent: OtherEvent
    
    let studiumEventService = StudiumEventService.shared
    
    var body: some View {
            VStack(alignment: .leading, spacing: Increment.two) {
                Button {
                    if let otherEvent = self.otherEvent.thaw() {
                        self.studiumEventService.markComplete(otherEvent, !otherEvent.complete)
                    }
                } label: {
                    HStack {
                        SmallIcon(color: StudiumColor.secondaryAccent.color, image: self.otherEvent.complete ? SystemIcon.circleCheckmarkFill.createImage() : SystemIcon.circle.createImage())
                        Text(self.otherEvent.complete ? "Complete" : "Incomplete")
                            .strikethrough(self.otherEvent.complete)
                            .font(StudiumFont.bodySemibold.font)
                            .foregroundStyle(StudiumFont.bodySemibold.color)
                        Spacer()
                    }
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        if !self.otherEvent.location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            HStack {
                                SmallIcon(image: SystemIcon.map.createImage())
                                StudiumText(self.otherEvent.location)
                            }
                        }
                        
                        HStack {
                            SmallIcon(image: SystemIcon.calendarClock.createImage())
                            StudiumText("Start Date: \(self.otherEvent.startDate.formatted())")
                        }
                        
                        HStack {
                            SmallIcon(image: SystemIcon.calendarExclamation)
                            StudiumText("End Date: \(self.otherEvent.endDate.formatted())")
                        }
                    }
                }
            }
    }
}

struct OtherEventView: View {
    @ObservedRealmObject var otherEvent: OtherEvent
    var body: some View {
        if !self.otherEvent.isInvalidated {
            ZStack {
                StudiumColor.background.color
                    .ignoresSafeArea()
                VStack(spacing: Increment.two) {
                    StudiumEventViewHeader(icon: self.otherEvent.icon.uiImage, color: Color(uiColor: self.otherEvent.color), primaryTitle: self.otherEvent.name, secondaryTitle: self.otherEvent.location)
                    ScrollView {
                        VStack(alignment: .leading, spacing: Increment.three) {
                            OtherEventViewDetails(otherEvent: self.otherEvent)
                            StudiumEventViewDivider()
//                            Spacer()
                            
                            VStack(alignment: .leading) {
                                HStack(alignment: .top) {
                                    SmallIcon(image: SystemIcon.paragraphSign.createImage())
                                    StudiumSubtitle("Additional Details")
                                }
                                
                                if self.otherEvent.additionalDetails.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    StudiumSubtext("No Additional Details Provided")
                                } else {
                                    StudiumText(self.otherEvent.additionalDetails)
                                }
                            }
                        }
                        .padding(.horizontal, Increment.three)
                        .padding(.top, Increment.three)
                    }
                    Spacer()
                }
            }
        }
    }
}

class OtherEventViewController: UIViewController {
    
    let otherEvent: OtherEvent
    let editButtonPressed: () -> Void
    let deleteButtonPressed: () -> Void
    
    init(
        otherEvent: OtherEvent,
        editButtonPressed: @escaping () -> Void,
        deleteButtonPressed: @escaping () -> Void
    ) {
        self.otherEvent = otherEvent
        self.editButtonPressed = editButtonPressed
        self.deleteButtonPressed = deleteButtonPressed
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSwiftUI()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.tintColor = StudiumColor.primaryLabelColor(forBackgroundColor: self.otherEvent.color)
        
        let editImage = SystemIcon.pencilCircleFill.createImage()
        let editItem = UIBarButtonItem(image: editImage, style: .done, target: self, action: #selector(self.editAssignment))
        
        
        let deleteItem = UIBarButtonItem(image: SystemIcon.trashCanCircleFill.createImage(), style: .done, target: self, action: #selector(self.deleteAssignment))
        self.navigationItem.rightBarButtonItems = [
            editItem,
            deleteItem
        ]
    }
    
    private func setupSwiftUI() {
        let assignmentView = OtherEventView(
            otherEvent: self.otherEvent
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
    
    static let mockOtherEvent = OtherEvent(name: "To Do Event", location: "Some Place", additionalDetails: "Some additional details", startDate: Date(), endDate: Date() + 100000, color: .green, icon: .atom, alertTimes: [])
    
    static var previews: some View {
        OtherEventView(otherEvent: mockOtherEvent)
    }
}
