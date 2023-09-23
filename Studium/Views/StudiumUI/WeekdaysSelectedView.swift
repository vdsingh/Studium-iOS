//
//  DaysView.swift
//  Studium
//
//  Created by Vikram Singh on 8/13/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

/// View-only display of weekdays selected
struct WeekdaysSelectedView: View {
    var selectedDays: Set<Weekday>
    
    var body: some View {
        HStack(alignment: .center) {
            ForEach(Weekday.allKnownCases, id: \.self) { weekday in
                WeekdaySelectedView(day: weekday, selectedDays: self.selectedDays)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

struct WeekdaySelectedView: View {
    
    let day: Weekday
    @State var selectedDays: Set<Weekday>
    
    var isSelected: Bool {
        self.selectedDays.contains(self.day)
    }
    
    var body: some View {
            self.dayTextView
    }
    
    var dayTextView: some View {
        WeekdayView(isSelected: self.isSelected, tintColor: StudiumColor.primaryAccent.color, day: self.day)
//        VStack {
//            if self.isSelected {
//                ZStack {
//                    StudiumColor.primaryAccent.color
//                        .clipShape(.rect(cornerRadius: Increment.one))
//                        .frame(maxHeight: Increment.four)
//                    Text(self.day.buttonText)
//                        .font(StudiumFont.subText.font)
//                        .foregroundStyle(StudiumFont.body.color)
//                        .padding(2)
//                }
//            } else {
//                Text(self.day.buttonText)
//                    .font(StudiumFont.subText.font)
//                    .foregroundStyle(StudiumColor.primaryAccent.color)
//            }
//        }
    }
}
