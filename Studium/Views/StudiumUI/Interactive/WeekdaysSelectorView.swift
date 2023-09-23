//
//  InteractiveDaysView.swift
//  Studium
//
//  Created by Vikram Singh on 9/17/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

/// Interactive view to select and deselect weekdays
struct WeekdaysSelectorView: View {
    @State var selectedDays: Set<Weekday> = []
    
    var body: some View {
        HStack(alignment: .center) {
            ForEach(Weekday.allKnownCases, id: \.self) { weekday in
                WeekdaySelectorView(day: weekday, selectedDays: self.$selectedDays)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

struct WeekdaySelectorView: View {
    
    let day: Weekday
    @Binding var selectedDays: Set<Weekday>
    let tintColor: Color = StudiumColor.primaryAccent.color
    var isSelected: Bool {
        self.selectedDays.contains(self.day)
    }
    
    var body: some View {
        Button {
            if self.isSelected {
                self.selectedDays.remove(self.day)
            } else {
                self.selectedDays.insert(self.day)
            }
        } label: {
            WeekdayView(isSelected: self.isSelected,
                        tintColor: self.tintColor,
                        day: self.day)
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}

struct WeekdayView: View {
    var isSelected: Bool
    let tintColor: Color
    let day: Weekday
    var body: some View {
        ZStack {
            if self.isSelected {
                self.tintColor
                    .clipShape(.rect(cornerRadius: Increment.one))
            } else {
                Color.clear
            }
            
            Text(self.day.buttonText)
                .font(StudiumFont.subText.font)
                .foregroundStyle(self.isSelected ? .white : StudiumColor.primaryLabel.color)
        }
        .frame(maxHeight: Increment.four)
        .overlay(RoundedRectangle(cornerRadius: Increment.one).stroke(self.tintColor, lineWidth: 2))
    }
}

struct InteractiveDaysPreview: PreviewProvider {
    
    @State static var selectedDays = Set<Weekday>()
    static var previews: some View {
        WeekdaysSelectorView()
    }
}
