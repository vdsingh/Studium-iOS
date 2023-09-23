//
//  OtherEventCellView.swift
//  Studium
//
//  Created by Vikram Singh on 8/12/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//
//


import Foundation
import SwiftUI
import UIKit
import RealmSwift


struct OtherEventCellView: View {
    @ObservedRealmObject var otherEvent: OtherEvent
    
    let checkboxWasTapped: () -> Void
    
    var backgroundColor: Color {
        Color(uiColor: self.otherEvent.color)
    }
    
    var textColor: Color {
        Color(uiColor: StudiumColor.primaryLabelColor(forBackgroundColor: UIColor(self.backgroundColor)))
    }
    
    var body: some View {
        if !self.otherEvent.isInvalidated {
            ZStack {
                HStack(spacing: Increment.two) {
                    LatenessIndicatorView(
                        .late,
                        width: Increment.three,
                        height: Increment.three
                    )
                    
                    Button {
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.success)
                        self.checkboxWasTapped()
                    } label: {
                        Image(uiImage: self.otherEvent.complete ? SystemIcon.circleCheckmarkFill.createImage() : SystemIcon.circle.createImage())
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(self.textColor)
                            .scaledToFit()
                            .frame(width: Increment.seven, height: Increment.seven)
                    }
                    
                    VStack(alignment: .leading) {
                        Spacer()
                        Text(self.otherEvent.name.trimmed())
                            .strikethrough(self.otherEvent.complete)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(self.textColor)
                        Spacer()
                        if !self.otherEvent.location.trimmed().isEmpty {
                            HStack {
                                MiniIcon(color: self.textColor, image: SystemIcon.map.createImage())
                                Text(self.otherEvent.location.trimmed())
                                    .font(StudiumFont.body.font)
                                    .foregroundStyle(self.textColor)
                            }
                            
                            Spacer()
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Spacer()
                        Text(self.otherEvent.startDate.format(with: DateFormat.fullDateWithTime))
                            .font(StudiumFont.body.font)
                            .foregroundStyle(self.textColor)
                        Spacer()
                        Text(self.otherEvent.endDate.format(with: DateFormat.fullDateWithTime))
                            .font(StudiumFont.body.font)
                            .foregroundStyle(self.textColor)
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, Increment.three)
        }
    }
}


//struct ContentView_Previews: PreviewProvider {
//
//    static var weekdays: Set<Weekday> {
//        var set = Set<Weekday>()
//        set.insert(.wednesday)
//        set.insert(.monday)
//        return set
//    }
//
//    static let mockAssignment = Assignment(name: "Homework 4", additionalDetails: "Additional Details", complete: true, startDate: Date(), endDate: Date()+100000, notificationAlertTimes: [], autoscheduling: true, autoLengthMinutes: 60, autoDays: weekdays, parentCourse: Course(name: "CS 320", location: "Building A", additionalDetails: "Hello World", startDate: Date(), endDate: Date(), color: .green, icon: .atom, alertTimes: []))
//
//    static var previews: some View {
//        AssignmentCellView(assignment: mockAssignment, isExpanded: true, checkboxWasTapped: {}, assignmentCollapseHandler: nil)
//    }
//}


class OtherEventTableViewCell: DeletableEventCell {
    
    static let id: String = "OtherEventTableViewCell"
    
    var otherEventCellView: OtherEventCellView
    
    init(otherEvent: OtherEvent, checkboxWasTapped: @escaping () -> Void) {
        
        let otherEventCellView = OtherEventCellView(otherEvent: otherEvent, checkboxWasTapped: checkboxWasTapped)
        self.otherEventCellView = otherEventCellView
        
        super.init(style: .default, reuseIdentifier: nil)
        
        self.event = otherEvent
        
        let hostingVC = UIHostingController(rootView: otherEventCellView)
        self.contentView.addSubview(hostingVC.view)
        hostingVC.view.backgroundColor = .clear
        
        self.backgroundColor = otherEvent.complete ? UIColor.gray : self.event.color
        
        hostingVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hostingVC.view.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor),
            hostingVC.view.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor),
            hostingVC.view.leftAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leftAnchor),
            hostingVC.view.rightAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.rightAnchor),
            
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
