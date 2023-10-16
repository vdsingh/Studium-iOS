//
//  NonRecurringEventCell.swift
//  Studium
//
//  Created by Vikram Singh on 10/7/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftUI

struct NonRecurringEventCell: View {
    
    @ObservedRealmObject var event: NonRecurringStudiumEvent
    
    let checkboxWasTapped: () -> Void
    
    var backgroundColor: Color {
        Color(uiColor: self.event.color)
    }
    
    var textColor: Color {
        Color(uiColor: StudiumColor.primaryLabelColor(forBackgroundColor: UIColor(self.backgroundColor)))
    }
    
    var body: some View {
        if !self.event.isInvalidated {
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
                        Image(uiImage: self.event.complete ?
                              SystemIcon.circleCheckmarkFill.createImage() :
                                SystemIcon.circle.createImage())
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(self.textColor)
                        .scaledToFit()
                        .frame(width: Increment.seven, height: Increment.seven)
                    }
                    
                    VStack(alignment: .leading) {
                        Spacer()
                        Text(self.event.name.trimmed())
                            .strikethrough(self.event.complete)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(self.textColor)
                        Spacer()
                        if !self.event.location.trimmed().isEmpty {
                            HStack {
                                MiniIcon(color: self.textColor, image: SystemIcon.map.createImage())
                                Text(self.event.location.trimmed())
                                    .font(StudiumFont.body.font)
                                    .foregroundStyle(self.textColor)
                            }
                            
                            Spacer()
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Spacer()
                        Text(self.event.startDate.format(with: DateFormat.fullDateWithTime))
                            .font(StudiumFont.body.font)
                            .foregroundStyle(self.textColor)
                        Spacer()
                        Text(self.event.endDate.format(with: DateFormat.fullDateWithTime))
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
