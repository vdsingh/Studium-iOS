//
//  OtherEventDetailsView.swift
//  Studium
//
//  Created by Vikram Singh on 9/28/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI
import RealmSwift

struct OtherEventPrimaryDetailsView: View {
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
                        VStack(alignment: .leading) {
                            StudiumText("Start: \(self.otherEvent.startDate.formatted())")
                            StudiumSubtext(self.otherEvent.startDate.daysHoursMinsDueDateString)
                        }
                    }
                    
                    HStack {
                        SmallIcon(image: SystemIcon.calendarExclamation)
                        VStack(alignment: .leading) {
                            StudiumText("End: \(self.otherEvent.endDate.formatted())")
                            StudiumSubtext(self.otherEvent.endDate.daysHoursMinsDueDateString)
                        }
                    }
                }
            }
        }
    }
}

struct OtherEventDetailsView: View {
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
                            OtherEventPrimaryDetailsView(otherEvent: self.otherEvent)
                            StudiumEventViewDivider()
                            
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
