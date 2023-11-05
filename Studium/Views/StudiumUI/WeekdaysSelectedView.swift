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
    let tintColor: Color

    var body: some View {
        HStack(alignment: .center) {
            ForEach(Weekday.allKnownCases, id: \.self) { weekday in
                WeekdaySelectedView(day: weekday, tintColor: self.tintColor, selectedDays: self.selectedDays)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

private struct WeekdaySelectedView: View {

    let day: Weekday
    let tintColor: Color
    @State var selectedDays: Set<Weekday>

    var isSelected: Bool {
        self.selectedDays.contains(self.day)
    }

    var body: some View {
            self.dayTextView
    }

    var dayTextView: some View {
        WeekdayView(isSelected: self.isSelected, tintColor: self.tintColor, day: self.day)
    }
}
