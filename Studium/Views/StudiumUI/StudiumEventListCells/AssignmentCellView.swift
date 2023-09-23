//
//  AssignmentCellView.swift
//  Studium
//
//  Created by Vikram Singh on 8/12/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit
import RealmSwift


struct AssignmentCellView: View {
    @ObservedRealmObject var assignment: Assignment
    var isExpanded: Bool
    var isLoading: Bool = false
    
    let checkboxWasTapped: () -> Void
    let assignmentCollapseHandler: AssignmentCollapseDelegate?
    
    var backgroundColor: Color {
        Color(uiColor: self.assignment.color)
    }
    
    var textColor: Color {
        Color(uiColor: StudiumColor.primaryLabelColor(forBackgroundColor: UIColor(self.backgroundColor)))
    }
    
    var body: some View {
        if !self.assignment.isInvalidated {
            ZStack {
                HStack(spacing: Increment.two) {
                    LatenessIndicatorView(
                        .late,
                        width: Increment.three,
                        height: Increment.three
                    )
                    
                    Button {
                        self.checkboxWasTapped()
                    } label: {
                        Image(uiImage: self.assignment.complete ? SystemIcon.circleCheckmarkFill.createImage() : SystemIcon.circle.createImage())
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(self.textColor)
                            .scaledToFit()
                            .frame(width: Increment.seven, height: Increment.seven)
                    }
                    
                    VStack(alignment: .leading) {
                        Spacer()
                        Text(self.assignment.name)
                            .strikethrough(self.assignment.complete)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(self.textColor)
                        
                        Spacer()
                        HStack {
                            HStack(alignment: .center) {
                                if let course = self.assignment.parentCourse {
                                    MiniIcon(color: self.textColor, image: course.icon.uiImage)
                                    Text(course.name)
                                        .font(StudiumFont.body.font)
                                        .foregroundStyle(self.textColor)
                                }
                            }
                            
                            Spacer()
                            Text(self.assignment.endDate.format(with: DateFormat.fullDateWithTime))
                                .font(StudiumFont.body.font)
                                .foregroundStyle(self.textColor)
                        }
                        
                        Spacer()
                    }
                    
                    if let autoschedulingConfig = self.assignment.autoschedulingConfig,
                       !self.assignment.autoscheduledEvents.isEmpty {
                        Button {
                            guard let assignmentCollapseDelegate = self.assignmentCollapseHandler else {
                                Log.e("assignmentCollapseDelegate was nil)")
                                return
                            }
                            
                            assignmentCollapseDelegate.collapseButtonClicked(assignment: self.assignment)
                        } label: {
                            Image(uiImage: self.isExpanded ? SystemIcon.chevronUp.createImage() : SystemIcon.chevronDown.createImage())
                                .resizable()
                                .renderingMode(.template)
                                .foregroundStyle(self.textColor)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: Increment.four, height: Increment.four)
                        }
                    }
                    
                    if self.isLoading {
                        Spinner()
                            .frame(width: Increment.five, height: Increment.five)
                    }
                }
                .padding(.horizontal, Increment.three)
            }
        }
    }
}

struct AssignmentViewController_Previews: PreviewProvider {
    
    static var weekdays: Set<Weekday> {
        var set = Set<Weekday>()
        set.insert(.wednesday)
        set.insert(.monday)
        return set
    }
    
    static let mockAssignment = Assignment(name: "Homework 4", additionalDetails: "Additional Details", complete: true, startDate: Date(), endDate: Date()+100000, notificationAlertTimes: [], autoschedulingConfig: nil, parentCourse: Course(name: "CS 320", location: "Building A", additionalDetails: "Hello World", startDate: Date(), endDate: Date(), color: .green, icon: .atom, alertTimes: []))
    
    static var previews: some View {
        AssignmentCellView(assignment: mockAssignment, isExpanded: true, checkboxWasTapped: {}, assignmentCollapseHandler: nil)
    }
}

class AssignmentTableViewCell: DeletableEventCell {
    
    static let id: String = "AssignmentTableViewCell"
    
    var assignmentCellView: AssignmentCellView
    
    init(assignment: Assignment, isExpanded: Bool, assignmentCollapseHandler: AssignmentCollapseDelegate, checkboxWasTapped: @escaping () -> Void) {
        
        let assignmentCellView = AssignmentCellView(assignment: assignment, isExpanded: isExpanded, checkboxWasTapped: checkboxWasTapped, assignmentCollapseHandler: assignmentCollapseHandler)
        self.assignmentCellView = assignmentCellView
        
        super.init(style: .default, reuseIdentifier: nil)
        
        
        self.event = assignment
        
        let hostingVC = UIHostingController(rootView: assignmentCellView)
        self.contentView.addSubview(hostingVC.view)
        hostingVC.view.backgroundColor = .clear
        
        self.backgroundColor = assignment.complete ? UIColor.gray : self.event.color
        
        hostingVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hostingVC.view.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor),
            hostingVC.view.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor),
            hostingVC.view.leftAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leftAnchor),
            hostingVC.view.rightAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.rightAnchor),
            
        ])
    }
    
    func setLoading(_ loading: Bool) {
        self.assignmentCellView.isLoading = loading
    }
    
    func setExpanded(_ expanded: Bool) {
        self.assignmentCellView.isExpanded = expanded
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
